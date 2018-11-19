// the caching lock server implementation

#include "lock_server_cache.h"
#include <sstream>
#include <string>
#include <queue>
#include <stdio.h>
#include <unistd.h>
#include <arpa/inet.h>
#include "lang/verify.h"
#include "handle.h"
#include "tprintf.h"



lock_server_cache::lock_server_cache()
{
  mutex = PTHREAD_MUTEX_INITIALIZER;
  cond = PTHREAD_COND_INITIALIZER;
}


int lock_server_cache::acquire(lock_protocol::lockid_t lid, std::string id, 
                               int &)
{
  tprintf("lock-server\t id:%s\t acquire lock:%lld\n",id.c_str(),lid);
  lock_protocol::status ret = lock_protocol::OK;
  pthread_mutex_lock(&mutex);
  int r;

  if(locks_state.find(lid) == locks_state.end()){
    tprintf("lock-server\t id:%s\t acquire lock:%lld new lock\n",id.c_str(),lid);
    locks_state[lid] = NONE;
    locks_owner[lid] = -1;
    std::queue<std::string> waiting_thread;
    wait_thread[lid] = waiting_thread;
  }

  switch(locks_state[lid]){
    case NONE:
      tprintf("lock-server\t id:%s\t acquire lock:%lld NONE\n",id.c_str(),lid);
      locks_owner[lid] = id;
      locks_state[lid] = LOCKED;
      if(!wait_thread[lid].empty()){
        tprintf("lock-server\t id:%s\t acquire lock:%lld OTHERS want the lock\n",id.c_str(),lid);
        handle h(id);
        rpcc *cl = h.safebind();
        pthread_mutex_unlock(&mutex);
        tprintf("lock-server\t id:%s\t acquire lock:%lld revoke\n",id.c_str(),lid);
        ret = cl->call(rlock_protocol::revoke, lid, r);
        return lock_protocol::OK;
      }
      pthread_mutex_unlock(&mutex);
      return ret;
    case FREE:
      tprintf("lock-server\t id:%s\t acquire lock:%lld FREE\n",id.c_str(),lid);
      locks_owner[lid] = id;
      locks_state[lid] = LOCKED;
      if(!wait_thread[lid].empty()){
        tprintf("lock-server\t id:%s\t acquire lock:%lld OTHERS want the lock\n",id.c_str(),lid);
        handle h(id);
        rpcc *cl = h.safebind();
        locks_state[lid] = ROVOKING;
        pthread_mutex_unlock(&mutex);
        tprintf("lock-server\t id:%s\t acquire lock:%lld revoke\n",id.c_str(),lid);
        ret = cl->call(rlock_protocol::revoke, lid, r);
        return lock_protocol::OK;
      }
      pthread_mutex_unlock(&mutex);
      return ret;
    case LOCKED:{
      tprintf("lock-server\t id:%s\t acquire lock:%lld LOCKED\n",id.c_str(),lid);
      if(locks_owner[lid] == id){
        tprintf("lock-server\t id:%s\t acquire lock:%lld owner is this calling id\n",id.c_str(),lid);
        pthread_mutex_unlock(&mutex);
        tprintf("returning\n");
        return rlock_protocol::OK;
      }
      tprintf("lock-server\t id:%s\t acquire lock:%lld hold by other\n",id.c_str(),lid);
      wait_thread[lid].push(id);
      std::string owner = locks_owner[lid];
      locks_state[lid] = REVOKING;
      handle h(owner);
      rpcc *cl = h.safebind();
      pthread_mutex_unlock(&mutex);
      ret = cl->call(rlock_protocol::revoke, lid, r);
      return rlock_protocol::RETRY;
    }
    case REVOKING:
      tprintf("lock-server\t id:%s\t acquire lock:%lld ROVOKING\n",id.c_str(),lid);
      pthread_mutex_unlock(&mutex);
      return rlock_protocol::RETRY;
    case RELEASING:
      tprintf("lock-server\t id:%s\t acquire lock:%lld RELEASING\n",id.c_str(),lid);
      pthread_mutex_unlock(&mutex);
      return rlock_protocol::RETRY;
  }

  return ret;
}

int 
lock_server_cache::release(lock_protocol::lockid_t lid, std::string id, 
         int &r)
{
  tprintf("lock-server\t id:%s\t release lock:%lld\n",id.c_str(),lid);
  lock_protocol::status ret = lock_protocol::OK;
  pthread_mutex_lock(&mutex);
  int tmp;

  if(locks_owner[lid] != id){
    tprintf("lock_server_cache\t wrong client id\t owner:%s\t client:%s\n", locks_owner[lid].c_str(), id.c_str());
    pthread_mutex_unlock(&mutex);
    return lock_protocol::RETRY;
  }
  if(wait_thread[lid].empty()){
    tprintf("lock-server\t id:%s\t release lock:%lld no thread waiting\n",id.c_str(),lid);
    locks_owner[lid] = -1;
    locks_state[lid] = FREE;
    pthread_mutex_unlock(&mutex);
    return lock_protocol::OK;
  }
  tprintf("lock-server\t id:%s\t release lock:%lld assign to front\n",id.c_str(),lid);
  std::string top = wait_thread[lid].front();
  wait_thread[lid].pop();
  // locks_state[lid] = LOCKED;
  // locks_owner[lid] = top;
  locks_state[lid] = FREE;
  locks_owner[lid] = -1;
  pthread_mutex_unlock(&mutex);
  handle h(top);
  rpcc *cl = h.safebind();
  ret = cl->call(rlock_protocol::retry, lid, tmp);
  pthread_mutex_lock(&mutex);
  if(ret != lock_protocol::OK){
    tprintf("lock_server_cache\t release\t retry with wrong answer\t top:%s\n", top.c_str());
    pthread_mutex_unlock(&mutex);
    release(lid, top, r);
  }else{
    pthread_mutex_unlock(&mutex);
    return lock_protocol::OK;
  }
  return ret;
}

lock_protocol::status
lock_server_cache::stat(lock_protocol::lockid_t lid, int &r)
{
  tprintf("stat request\n");
  r = nacquire;
  return lock_protocol::OK;
}

