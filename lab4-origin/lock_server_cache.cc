// the caching lock server implementation

#include "lock_server_cache.h"
#include <sstream>
#include <stdio.h>
#include <unistd.h>
#include <arpa/inet.h>
#include "lang/verify.h"
#include "handle.h"
#include "tprintf.h"

lock_server_cache::lock_server_cache()
{
  pthread_mutex_init(&mutex,NULL);
}

int lock_server_cache::acquire(lock_protocol::lockid_t lid, std::string id, 
                               int &)
{
  pthread_mutex_lock(&mutex);
  tprintf("acquire\t id:%s\t lock:%lld\n", id.c_str(), lid);
  int r;
  // a new lock, directly give to client
  if(locks.find(lid) == locks.end())
  {
    tprintf("acquire\t id:%s\t lock:%lld a new lock\n", id.c_str(), lid);
    locks[lid].owner = id;
    pthread_mutex_unlock(&mutex);
    return lock_protocol::OK;
  // a cached lock
  }else{
    locks[lid].waiting_clients.push(id);
    if(locks[lid].waiting_clients.size() == 1){
      // send a revoke to the owner of this lock
      std::string owner = locks[lid].owner;
      handle h(owner);
      tprintf("acquire\t id:%s\t lock:%lld revoke to:%s\n", id.c_str(), lid, owner.c_str());
      pthread_mutex_unlock(&mutex);
      rpcc* cl = h.safebind();
      cl->call(rlock_protocol::revoke,lid,r);
      return lock_protocol::RETRY;     
    }else{
      tprintf("acquire\t id:%s\t lock:%lld\t has revoked\n", id.c_str(), lid);
      pthread_mutex_unlock(&mutex);
      return lock_protocol::RETRY;
    }
  }
  return lock_protocol::RPCERR;
}

int 
lock_server_cache::release(lock_protocol::lockid_t lid, std::string id, 
         int &r)
{
  pthread_mutex_lock(&mutex);
  tprintf("release\t id:%s\t lock:%lld\n", id.c_str(), lid);
  int tmp;

  if(locks.find(lid) == locks.end()){
    tprintf("release\t id:%s\t lock:%lld\t releasing a unexist lock\n", id.c_str(), lid);
    pthread_mutex_unlock(&mutex);
    return lock_protocol::RPCERR;
  }
  if(locks[lid].owner != id){
    tprintf("release\t id:%s\t lock:%lld wrong client release lock\n", id.c_str(), lid);
    pthread_mutex_unlock(&mutex);  
    return lock_protocol::RPCERR;
  }

  locks[lid].owner = "";
  if(!locks[lid].waiting_clients.empty()){
      std::string top = locks[lid].waiting_clients.front();
      locks[lid].waiting_clients.pop();
      locks[lid].owner = top;

      handle h(top);
      rpcc *cl = h.safebind();
      pthread_mutex_unlock(&mutex);
      cl->call(rlock_protocol::retry, lid, tmp);
      pthread_mutex_lock(&mutex);

      if(!locks[lid].waiting_clients.empty()){
          pthread_mutex_unlock(&mutex);
          cl->call(rlock_protocol::revoke,lid,tmp);
          pthread_mutex_lock(&mutex);
      }
  } else {
      locks.erase(lid);
  }
    pthread_mutex_unlock(&mutex);
    return lock_protocol::OK;
}

lock_protocol::status
lock_server_cache::stat(lock_protocol::lockid_t lid, int &r)
{
  tprintf("state\t lock:%lld\n", lid);
  r = nacquire;
  return lock_protocol::OK;
}

