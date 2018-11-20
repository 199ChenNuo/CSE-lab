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

// void lock_server_cache::revoke_owner(lock_protocol::lockid_t lid, handle &h){
//   rpcc* cl = h.safebind();
//   if(cl){
//     int r;
//     rlock_protocol::status ret = cl->call(rlock_protocol::revoke,lid,r);
//     if (ret != rlock_protocol::OK){
//       std::cerr<<"error in revoke owner"<<std::endl;
//     }
//   }
// }

int lock_server_cache::acquire(lock_protocol::lockid_t lid, std::string id, 
                               int &)
{
  tprintf("acquire request: lid=>%llu id=>%s\n", lid, id.c_str());
  pthread_mutex_lock(&mutex);

  // a new lock, directly give to client
  if(locks.find(lid) == locks.end())
  {
    locks[lid].owner = id;
    pthread_mutex_unlock(&mutex);
    return lock_protocol::OK;

  // a cached lock
  }else{
    locks[lid].waiting_clients.push(id);
    if(locks[lid].waiting_clients.size() > 1){
      tprintf("waiting_clients size is: %u\n", locks[lid].waiting_clients.size());
      pthread_mutex_unlock(&mutex);

      return lock_protocol::RETRY;     
    }else{
      // send a revoke to the owner of this lock
      handle h(locks[lid].owner);
      pthread_mutex_unlock(&mutex);

      // revoke_owner(lid, h);
      rpcc* cl = h.safebind();
      if(cl){
        int r;
        rlock_protocol::status ret = cl->call(rlock_protocol::revoke,lid,r);
        if (ret != rlock_protocol::OK){
          std::cerr<<"error in revoke owner"<<std::endl;
        }
      }
      return lock_protocol::RETRY;
    }
  }
  return lock_protocol::NOENT;
}

int 
lock_server_cache::release(lock_protocol::lockid_t lid, std::string id, 
         int &r)
{
  tprintf("release request: lid=>%llu id=>%s\n", lid, id.c_str());
  pthread_mutex_lock(&mutex);
  if(locks.find(lid) != locks.end()){
    locks[lid].owner = "";
    if(locks[lid].waiting_clients.size() == 0){  // remove this lock's info
      locks.erase(lid); 
      pthread_mutex_unlock(&mutex);
    }else{        
      // send a retry to the first waiting_clients client
      handle h(locks[lid].waiting_clients.front());
      pthread_mutex_unlock(&mutex);
      
      rpcc* cl = h.safebind();
      if(cl){
        int r;
        cl->call(rlock_protocol::retry, lid, r);       
        pthread_mutex_lock(&mutex);
        locks[lid].owner = locks[lid].waiting_clients.front();
        locks[lid].waiting_clients.pop();  
        tprintf("CHANGE waiting_clients TO OWNER NEW OWNER: %s\n", locks[lid].owner.c_str());
        
        // if there are other clients waiting_clients, send a reovke to the owner
        if(locks[lid].waiting_clients.size() > 0){
          printf("waiting_clients size is: %u\t owner is:%s\n", locks[lid].waiting_clients.size(), locks[lid].owner.c_str());

          handle hh(locks[lid].owner); 
          pthread_mutex_unlock(&mutex);
          // revoke_owner(lid, hh);  
          rpcc* cl = h.safebind();
          if(cl){
            int r;
            rlock_protocol::status ret = cl->call(rlock_protocol::revoke,lid,r);
            if (ret != rlock_protocol::OK){
              std::cerr<<"error in revoke owner"<<std::endl;
            }
          }
        }else{  
          pthread_mutex_unlock(&mutex);
        }
      }
    } 
    return lock_protocol::OK; 
  } 
  tprintf("lsc\t releasing a new lock\t lid:%lld client:%s\n", lid, id.c_str());
  return lock_protocol::NOENT;
}

lock_protocol::status
lock_server_cache::stat(lock_protocol::lockid_t lid, int &r)
{
  tprintf("stat request\n");
  r = nacquire;
  return lock_protocol::OK;
}

