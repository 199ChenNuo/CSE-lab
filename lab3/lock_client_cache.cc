// RPC stubs for clients to talk to lock_server, and cache the locks
// see lock_client.cache.h for protocol details.

#include "lock_client_cache.h"
#include "rpc.h"
#include <sstream>
#include <iostream>
#include <queue>
#include <stdio.h>
#include <queue>
#include <string>
#include "tprintf.h"


int lock_client_cache::last_port = 0;

lock_client_cache::lock_client_cache(std::string xdst, 
				     class lock_release_user *_lu)
  : lock_client(xdst), lu(_lu)
{
  std::cout << "lcc init" << std::endl;
  pthread_mutex_init(&lock_mutex, NULL);
  pthread_mutex_init(&revoke_mutex, NULL);
  srand(time(NULL)^last_port);
  rlock_port = ((rand()%32000) | (0x1 << 10));
  const char *hname;
  // VERIFY(gethostname(hname, 100) == 0);
  hname = "127.0.0.1";
  std::ostringstream host;
  host << hname << ":" << rlock_port;
  id = host.str();
  last_port = rlock_port;
  rpcs *rlsrpc = new rpcs(rlock_port);
  rlsrpc->reg(rlock_protocol::revoke, this, &lock_client_cache::revoke_handler);
  rlsrpc->reg(rlock_protocol::retry, this, &lock_client_cache::retry_handler);
}

// lock_protocol::status 
// lock_client_cache::wait_for_lock(lock_protocol::lockid_t lid){
//   while(locks[lid].state != client_lock::NONE && 
//          locks[lid].state != client_lock::FREE)
//     pthread_cond_wait(&(locks[lid].cond), &lock_mutex);
        
//    if(locks[lid].state == client_lock::FREE){
//      locks[lid].state = client_lock::LOCKED;
//      pthread_mutex_unlock(&lock_mutex);
//      return lock_protocol::OK;
//    }else if(locks[lid].state == client_lock::NONE){
//      locks[lid].state = client_lock::ACQUIRING;
//      pthread_mutex_unlock(&lock_mutex);
//      return acquire_from_server(lid); 
//    }
//    return lock_protocol::OK;
// }

// lock_protocol::status 
// lock_client_cache::acquire_from_server(lock_protocol::lockid_t lid){
//   int r;
//   tprintf("acquire from server: lid=>%llu tid=>%lu id=>%s\n", lid, pthread_self(), id.c_str());
//   lock_protocol::status ret = cl->call(lock_protocol::acquire, lid, id, r);
 
//   // using a particular pthread_cond to replace ?
//   while(ret == lock_protocol::RETRY){
//     pthread_mutex_lock(&lock_mutex);
//     if(locks[lid].state == client_lock::LOCKED){
//       pthread_mutex_unlock(&lock_mutex);
//       return lock_protocol::OK;
//     }else{
//       pthread_mutex_unlock(&lock_mutex);
//     }
//   }

//   //cache this lock
//   pthread_mutex_lock(&lock_mutex);
//   locks[lid].state = client_lock::LOCKED;
//   pthread_mutex_unlock(&lock_mutex);
//   return ret;     
// }

// lock_protocol::status
// lock_client_cache::acquire(lock_protocol::lockid_t lid)
// {
//   tprintf("[ACQUIRE]: lid=>%llu id=>%s\n", lid, this->id.c_str());
//   pthread_mutex_lock(&lock_mutex);
//   if(locks.find(lid) != locks.end() && locks[lid].state != client_lock::NONE){
//     tprintf("lock cached\n");
//     switch(locks[lid].state){
//       case client_lock::FREE:
//         locks[lid].state = client_lock::LOCKED;  
//         pthread_mutex_unlock(&lock_mutex);
//         return lock_protocol::OK;
//       case client_lock::LOCKED:
//       case client_lock::ACQUIRING:
//       case client_lock::RELEASING:{
//         while(locks[lid].state != client_lock::NONE && locks[lid].state != client_lock::FREE)
//           pthread_cond_wait(&(locks[lid].cond), &lock_mutex);
              
//         if(locks[lid].state == client_lock::FREE){
//           locks[lid].state = client_lock::LOCKED;
//           pthread_mutex_unlock(&lock_mutex);
//           return lock_protocol::OK;
//         }else if(locks[lid].state == client_lock::NONE){
//           locks[lid].state = client_lock::ACQUIRING;
//           pthread_mutex_unlock(&lock_mutex);
//           int r;
//           tprintf("acquire from server: lid=>%llu tid=>%lu id=>%s\n", lid, pthread_self(), id.c_str());
//           lock_protocol::status ret = cl->call(lock_protocol::acquire, lid, id, r);
        
//           while(ret == lock_protocol::RETRY){
//             pthread_mutex_lock(&lock_mutex);
//             if(locks[lid].state == client_lock::LOCKED){
//               pthread_mutex_unlock(&lock_mutex);
//               return lock_protocol::OK;
//             }else{
//               pthread_mutex_unlock(&lock_mutex);
//             }
//           }

//           //cache this lock
//           pthread_mutex_lock(&lock_mutex);
//           locks[lid].state = client_lock::LOCKED;
//           pthread_mutex_unlock(&lock_mutex);
//           return ret;
//         }
//         return lock_protocol::OK;
//       }
//     } 
//   }else{
//     tprintf("lock not cached\n");
//     // acqure this lock via rpc 
//     locks[lid].state = client_lock::ACQUIRING;
//     pthread_mutex_unlock(&lock_mutex);

//     int r;
//     tprintf("acquire from server: lid=>%llu tid=>%lu id=>%s\n", lid, pthread_self(), id.c_str());
//     lock_protocol::status ret = cl->call(lock_protocol::acquire, lid, id, r);
  
//     // using a particular pthread_cond to replace ?
//     while(ret == lock_protocol::RETRY){
//       pthread_mutex_lock(&lock_mutex);
//       if(locks[lid].state == client_lock::LOCKED){
//         pthread_mutex_unlock(&lock_mutex);
//         return lock_protocol::OK;
//       }else{
//         pthread_mutex_unlock(&lock_mutex);
//       }
//     }

//     //cache this lock
//     pthread_mutex_lock(&lock_mutex);
//     locks[lid].state = client_lock::LOCKED;
//     pthread_mutex_unlock(&lock_mutex);
//     return ret;
//   } 
//   return lock_protocol::OK;
// }

lock_protocol::status
lock_client_cache::acquire(lock_protocol::lockid_t lid)
{
  tprintf("[ACQUIRE]: lid=>%llu id=>%s\n", lid, this->id.c_str());
  pthread_mutex_lock(&lock_mutex);

  int r;
  
  if(locks.find(lid) == locks.end() || locks[lid].state == NONE){
      // a new lock (not cached)
    tprintf("acquire\t new lock\t lid:%lld\t acquiring\n", lid);
    locks[lid].state = ACQUIRING;
    pthread_mutex_unlock(&lock_mutex);
    lock_protocol::status ret = cl->call(lock_protocol::acquire, lid, id, r);
    
    if(ret == lock_protocol::OK){
        tprintf("acquire\t new lock\t lid:%lld\t get lock\n", lid);
        pthread_mutex_lock(&lock_mutex);
        locks[lid].state = LOCKED;
        pthread_mutex_unlock(&lock_mutex);
        return ret;
    }

    // spin wait for lock
    while(true){
        pthread_mutex_lock(&lock_mutex);
        if(locks[lid].state == LOCKED){
            return get_free_lock(lid);
        }
        pthread_mutex_unlock(&lock_mutex);
    }
  } else {
      // a cached lock
    tprintf("acquire\t cached lock\t lid:%lld\t \n", lid);
    
    switch (locks[lid].state)
    {
        case FREE:
            return get_free_lock(lid);
        case LOCKED:
        case RELEASING:
        case ACQUIRING:
            while(locks[lid].state != NONE && locks[lid].state != FREE){
                tprintf("acquire\t waiting for lock:%lld\n", lid);
                pthread_cond_wait(&locks[lid].cond, &lock_mutex);
            }

            if(locks[lid].state == FREE){
                return get_free_lock(lid);
            }

            if(locks[lid].state == NONE){
                locks[lid].state = ACQUIRING;
                pthread_mutex_unlock(&lock_mutex);
                lock_protocol::status ret = cl->call(lock_protocol::acquire, lid, id, r);

                if(ret == lock_protocol::OK){
                    tprintf("acquire\t cached lock\t lid:%lld\t get lock\n", lid);
                    pthread_mutex_lock(&lock_mutex);
                    locks[lid].state = LOCKED;
                    pthread_mutex_unlock(&lock_mutex);
                    return ret;
                }

                // spin wait for lock
                while(true){
                    pthread_mutex_lock(&lock_mutex);
                    if(locks[lid].state == LOCKED){
                        tprintf("acquire\t new lock\t lid:%lld, spin wait get lock\n", lid);
                        pthread_mutex_unlock(&lock_mutex);
                        return lock_protocol::OK;
                    }
                    pthread_mutex_unlock(&lock_mutex);
                }
            }
        default:
            break;
    }
  }
  return lock_protocol::OK;
}

lock_protocol::status
lock_client_cache::get_free_lock(lock_protocol::lockid_t lid){
    tprintf("acquire\t cached lock\t lid:%lld\t get lock: FREE\n", lid);
    locks[lid].state = LOCKED;
    pthread_mutex_unlock(&lock_mutex);
    return lock_protocol::OK;
}

lock_protocol::status
lock_client_cache::call_server_acquire(lock_protocol::lockid_t lid){
    pthread_mutex_unlock(&lock_mutex);
    int r;
    lock_protocol::status ret = cl->call(lock_protocol::acquire, lid, id, r);
    pthread_mutex_lock(&lock_mutex);
    return ret;
}

lock_protocol::status
lock_client_cache::release(lock_protocol::lockid_t lid)
{
  tprintf("[RELEASE]: lid=>%llu id=>%s\n", lid, this->id.c_str());
  pthread_mutex_lock(&lock_mutex);
  if(locks.find(lid) != locks.end()){
    if(revokes.find(lid) != revokes.end()){ // release to the server
      tprintf("[RELEASE TO SERVER]: lid=>%llu id=>%s\n", lid, this->id.c_str());
      locks[lid].state = client_lock::RELEASING;
      // if(lu != 0)
      //   lu->dorelease(lid);

      pthread_mutex_unlock(&lock_mutex);
    
      int r;
      cl->call(lock_protocol::release, lid, id, r);
      
      pthread_mutex_lock(&revoke_mutex);       
      revokes.erase(lid);
      pthread_mutex_unlock(&revoke_mutex);

      pthread_mutex_lock(&lock_mutex);
      locks[lid].state = client_lock::NONE;
      pthread_mutex_unlock(&lock_mutex);
    }else{
      locks[lid].state = client_lock::FREE;
      pthread_mutex_unlock(&lock_mutex);
      tprintf("[RELEASE TO CLIENT]: lid=>%llu id=>%s\n", lid, this->id.c_str());
    }
    // inform waiting threads
    pthread_cond_signal(&(locks[lid].cond)); 
  }
  return lock_protocol::OK;
}

rlock_protocol::status
lock_client_cache::revoke_handler(lock_protocol::lockid_t lid, 
                                  int &)
{
  tprintf("[REVOKE]: lid=>%llu\n", lid);

  pthread_mutex_lock(&lock_mutex);
  if(locks[lid].state == client_lock::FREE){
    locks[lid].state = client_lock::RELEASING;
    // if(lu != 0)
    //   lu->dorelease(lid);

    pthread_mutex_unlock(&lock_mutex);
    tprintf("[RLEASE TO SERVER]: lid=>%llu id=>%s\n", lid, id.c_str());
    
    int r;
    cl->call(lock_protocol::release, lid, id, r);
    pthread_mutex_lock(&lock_mutex);
    locks[lid].state = client_lock::NONE;
    pthread_mutex_unlock(&lock_mutex);

    pthread_cond_signal(&(locks[lid].cond));
    return rlock_protocol::OK; 
  }else{
    pthread_mutex_unlock(&lock_mutex);
    tprintf("[REVOKE]: lid=>%llu id=>%s insert into revokes\n", lid, id.c_str());
    pthread_mutex_lock(&revoke_mutex);  
    revokes.insert(lid);
    pthread_mutex_unlock(&revoke_mutex);

    return rlock_protocol::OK;
  }
}

rlock_protocol::status
lock_client_cache::retry_handler(lock_protocol::lockid_t lid, 
                                 int &)
{
  tprintf("[RETRY]: lid=>%llu\n", lid);
  
  pthread_mutex_lock(&lock_mutex);
  locks[lid].state = client_lock::LOCKED;
  pthread_mutex_unlock(&lock_mutex); 
   
  int ret = rlock_protocol::OK;
  return ret;
}



