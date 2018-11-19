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
  mutex = PTHREAD_MUTEX_INITIALIZER;
  cond = PTHREAD_COND_INITIALIZER;
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

lock_protocol::status
lock_client_cache::acquire(lock_protocol::lockid_t lid)
{
  pthread_mutex_lock(&mutex);
  int ret = lock_protocol::OK;
  int r;
  long long me = pthread_self();
  tprintf("lock-client\tid:%s\tthread:%d\tacquire lock:%lld\n",id.c_str(),me,lid);

  // init a new lock
  if(locks_state.find(lid) == locks_state.end()){
    tprintf("lock-client\tid:%s\tthread:%d\tacquire lock:%lld\tnew lock\n",id.c_str(),me,lid);
    locks_state[lid] = NONE;
    std::queue<long long> waiting_thread;
    wait_thread[lid] = waiting_thread;
    locks_owner[lid] = -1;
    locks_revoke[lid] = 0;
  }

// none: client knows nothing about this lock
// free: client owns the lock and no thread has it
// locked: client owns the lock and a thread has it
// acquiring: the client is acquiring ownership
// releasing: the client is releasing ownership
  switch(locks_state[lid]){
    case FREE:
      tprintf("lock-client\tid:%s\tthread:%d\tacquire lock:%lld\t FREE\n",id.c_str(),me,lid);
      locks_state[lid] = LOCKED;
      locks_owner[lid] = me;
      pthread_mutex_unlock(&mutex);
      return lock_protocol::OK;
    case LOCKED:
      wait_thread[lid].push(me);
      tprintf("lock-client\tid:%s\tthread:%d\tacquire lock:%lld\t LOCKED\n",id.c_str(),me,lid);
      // in release, broadcast all waiting on cond, owner is the front in queue, so may not be 'me'
      while(locks_owner[lid] != me){
        pthread_cond_wait(&cond, &mutex);
      }
      locks_state[lid] = LOCKED;
      locks_owner[lid] = me;
      pthread_mutex_unlock(&mutex);
      return lock_protocol::OK;
    case NONE:
      tprintf("lock-client\tid:%s\tthread:%d\tacquire lock:%lld\t NONE\n",id.c_str(),me,lid);
      locks_state[lid] = ACQUIRING;

      pthread_mutex_unlock(&mutex);
      tprintf("ask for this lock\n");
      // there has something to do
      while((ret = cl->call(lock_protocol::acquire, lid, id, r)) != lock_protocol::OK){
        ;
      }
      pthread_mutex_lock(&mutex);
      // if(ret == lock_protocol::OK){
      locks_state[lid] = LOCKED;
      locks_owner[lid] = me;
      pthread_mutex_unlock(&mutex);
      return lock_protocol::OK;
      // }
      // else: go to ACQUIRING
    case ACQUIRING:
      // really to push???
      tprintf("lock-client\tid:%s\tthread:%d\tacquire lock:%lld\t ACQUIRING\n",id.c_str(),me,lid);
      wait_thread[lid].push(me);
      while(locks_owner[lid] != me){
        pthread_cond_wait(&cond, &mutex);
      }
      locks_state[lid] = LOCKED;
      locks_owner[lid] = me;
      pthread_mutex_unlock(&mutex);
      return lock_protocol::OK;
    case RELEASING:
    default:
      tprintf("lock-client\tid:%s\tthread:%d\tacquire lock:%lld\t RELEASING\n",id.c_str(),me,lid);
      wait_thread[lid].push(me);
      while(locks_owner[lid] != me){
        pthread_cond_wait(&cond, &mutex);
      }
      locks_state[lid] = LOCKED;
      if(locks_revoke[lid]){
        locks_state[lid] = RELEASING;
      }
      pthread_mutex_unlock(&mutex);
      return ret;
  }

  pthread_mutex_unlock(&mutex);
  return ret;
}


lock_protocol::status
lock_client_cache::release(lock_protocol::lockid_t lid)
{
  pthread_mutex_lock(&mutex);
  int ret = lock_protocol::OK;
  long long me = pthread_self();
  int r = RELEASING;
  tprintf("lock-client\tid:%s\tthread:%d\trelease lock:%lld\n",id.c_str(),me,lid);
  
  switch (locks_state[lid]){
    case LOCKED:
      tprintf("lock-client\tid:%s\tthread:%d\trelease lock:%lld\t LOCKED\n",id.c_str(),me,lid);
      if(wait_thread[lid].empty()){
        locks_owner[lid] = -1;
        locks_state[lid] = FREE;
        pthread_mutex_unlock(&mutex);
        return lock_protocol::OK;
      } else {
        long long top = wait_thread[lid].front();
        wait_thread[lid].pop();
        locks_owner[lid] = top;
        // wake up all threads waiting on cond
        pthread_cond_broadcast(&cond);
        pthread_mutex_unlock(&mutex);
        return lock_protocol::OK;
      }
    case RELEASING:
      tprintf("lock-client\tid:%s\tthread:%d\trelease lock:%lld\t RELEASING\n",id.c_str(),me,lid);
      if(wait_thread[lid].empty()){
        locks_owner[lid] = -1;
        // should be another state, but for simple, used NONE
        locks_state[lid] = NONE;
        pthread_mutex_unlock(&mutex);
        ret = cl->call(lock_protocol::release, lid, id, r);
        pthread_mutex_lock(&mutex);
        // acquire enter between above unlock
        if(wait_thread[lid].empty()){
          pthread_mutex_unlock(&mutex);
          return lock_protocol::OK;
        }else{
          locks_state[lid] = ACQUIRING;
          pthread_mutex_unlock(&mutex);
          ret = cl->call(lock_protocol::acquire, lid, id, r);
          pthread_mutex_lock(&mutex);
          if(ret == lock_protocol::OK){
          long long top = wait_thread[lid].front();
          wait_thread[lid].pop();
          locks_owner[lid] = top;
          locks_state[lid] = LOCKED;
          tprintf("lock-client\tid:%s\tthread:%d\trelease lock:%lld\tafter call next owner:%d\n",id.c_str(),me,lid,top);
          pthread_cond_broadcast(&cond);
        }
        pthread_mutex_unlock(&mutex);
        return ret;
        }
      } else {
        // acquire for this lock, including above situation where wait_thread[lid] has new member(s) after release mutex for call release
        locks_state[lid] = ACQUIRING;
        pthread_mutex_unlock(&mutex);
        ret = cl->call(lock_protocol::acquire, lid, id, r);
        pthread_mutex_lock(&mutex);
        if(ret == lock_protocol::OK){
          long long top = wait_thread[lid].front();
          wait_thread[lid].pop();
          locks_owner[lid] = top;
          locks_state[lid] = LOCKED;
          tprintf("lock-client\tid:%s\tthread:%d\trelease lock:%lld\tafter call next owner:%d\n",id.c_str(),me,lid,top);
          pthread_cond_broadcast(&cond);
        }
        pthread_mutex_unlock(&mutex);
        return ret;
      }
    default:
      tprintf("lock-client\tid:%s\tthread:%d\trelease lock:%lld\tunexpected state:%d\n",id.c_str(),me,lid,locks_state[lid]);
      pthread_mutex_unlock(&mutex);

  }
  return lock_protocol::OK;

}

rlock_protocol::status
lock_client_cache::revoke_handler(lock_protocol::lockid_t lid, 
                                  int &)
{
  tprintf("lock-client\tid:%s\trevoke lock:%lld\n",id.c_str(),lid);
  int ret = rlock_protocol::OK;
  int r;
  pthread_mutex_lock(&mutex);
  switch(locks_state[lid]){
    case FREE:
    case NONE:
      locks_state[lid] = NONE;
      tprintf("lock-client\tid:%s\trevoke lock:%lld FREE or NONE\n",id.c_str(),lid);
      pthread_mutex_unlock(&mutex);
      cl->call(lock_protocol::release, lid, id, r);
      return rlock_protocol::OK;
    case LOCKED:
      tprintf("lock-client\tid:%s\trevoke lock:%lld LOCKED\n",id.c_str(),lid);
      locks_state[lid] = RELEASING;
      locks_revoke[lid] = 1;
      pthread_mutex_unlock(&mutex);
      while(locks_state[lid] == RELEASING){
        ;
      }
      return rlock_protocol::OK;
    default:
      tprintf("lock-client\tid:%s\trevoke lock:%lld RELEASING\n",id.c_str(),lid);
      locks_state[lid] = RELEASING;
      locks_revoke[lid] = 1;
      pthread_mutex_unlock(&mutex);
      tprintf("lock-client\tid:%s\trevoke lock:%lld unlock\n",id.c_str(),lid);
      while(locks_state[lid] == RELEASING){
        ;
      }
      return rlock_protocol::OK;
  }
  return ret;
}

rlock_protocol::status
lock_client_cache::retry_handler(lock_protocol::lockid_t lid, 
                                 int &)
{
  tprintf("lock-client\tid:%s\tretry lock:%lld \n",id.c_str(),lid);
  int ret = rlock_protocol::OK;
  int r;

  pthread_mutex_lock(&mutex);
  if(wait_thread[lid].empty()){
    tprintf("lock-client\tid:%s\tretry lock:%lld\n",id.c_str(),lid);
    pthread_mutex_unlock(&mutex);
    return lock_protocol::RPCERR;
  }
  pthread_mutex_unlock(&mutex);
  ret = cl->call(lock_protocol::acquire, lid, id, r);
  pthread_mutex_lock(&mutex);

  // retry and revoke
  if(ret == lock_protocol::OK && locks_revoke[lid]){
    tprintf("lock-client\tid:%s\tretry lock:%lld retry and revoke\n",id.c_str(),lid);
    locks_state[lid] = RELEASING;
    long long top = wait_thread[lid].front();
    tprintf("lock-client\tid:%s\tretry lock:%lld assign to top:%lld\n",id.c_str(),lid,top);
    wait_thread[lid].pop();
    locks_owner[lid] = top;
    pthread_cond_broadcast(&cond);
    pthread_mutex_unlock(&mutex);
    // ret = cl->call(lock_protocol::release, lid, id, r);
    return ret;
  }

  // no thread wants the locks now
  if(ret == lock_protocol::OK && wait_thread[lid].empty()){
    tprintf("lock-client\tid:%s\tretry lock:%lld no thread want lock\n",id.c_str(),lid);
    locks_state[lid] = FREE;
    locks_owner[lid] = -1;
    pthread_mutex_unlock(&mutex);
    return ret;
  }

  long long top = wait_thread[lid].front();
  tprintf("lock-client\tid:%s\tretry lock:%lld assign to top:%lld\n",id.c_str(),lid,top);
  wait_thread[lid].pop();
  locks_owner[lid] = top;
  locks_state[lid] = LOCKED;
  // locks_state[lid] = FREE;
  // locks_owner[lid] = -1;
  pthread_cond_broadcast(&cond);
  pthread_mutex_unlock(&mutex);
  return lock_protocol::OK;
}



