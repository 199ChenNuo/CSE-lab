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
#include <unistd.h>

int lock_client_cache::last_port = 0;

lock_client_cache::lock_client_cache(std::string xdst,
                                     class lock_release_user *_lu)
    : lock_client(xdst), lu(_lu)
{
<<<<<<< HEAD
  srand(time(NULL)^last_port);
  rlock_port = ((rand()%32000) | (0x1 << 10));
  char hname[100];
  VERIFY(gethostname(hname, sizeof(hname)) == 0);
=======
  std::cout << "lcc init" << std::endl;
  pthread_mutex_init(&lock_mutex, NULL);
  pthread_mutex_init(&revoke_mutex, NULL);
  srand(time(NULL) ^ last_port);
  rlock_port = ((rand() % 32000) | (0x1 << 10));
  const char *hname;
  // VERIFY(gethostname(hname, 100) == 0);
  hname = "127.0.0.1";
>>>>>>> lab3
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
  tprintf("acquire\t id:%s\t lock:%lld\n", id.c_str(), lid);
  pthread_mutex_lock(&lock_mutex);

  int r;

  if (locks.find(lid) == locks.end() || locks[lid].state == NONE)
  {
    // a new lock (not cached)
    tprintf("acquire\t id:%s\t new lock\t lid:%lld\t acquiring\n", id.c_str(), lid);
    locks[lid].state = ACQUIRING;
    pthread_mutex_unlock(&lock_mutex);
    lock_protocol::status ret = cl->call(lock_protocol::acquire, lid, id, r);

    if (ret == lock_protocol::OK)
    {
      //cache this lock
      pthread_mutex_lock(&lock_mutex);
      locks[lid].state = client_lock::LOCKED;
      pthread_mutex_unlock(&lock_mutex);
      return ret;
    }
    else if (ret == lock_protocol::RETRY)
    {
      while (true)
      {
        pthread_mutex_lock(&lock_mutex);
        if (locks[lid].state == client_lock::LOCKED)
        {
          pthread_mutex_unlock(&lock_mutex);
          return lock_protocol::OK;
        }
        else
        {
          pthread_mutex_unlock(&lock_mutex);
        }
      }
    }

    //cache this lock
    pthread_mutex_lock(&lock_mutex);
    locks[lid].state = client_lock::LOCKED;
    pthread_mutex_unlock(&lock_mutex);
    return ret;
  }
  else
  {
    // a cached lock
    tprintf("acquire\t id:%s\t cached lock\t lid:%lld\t \n", id.c_str(), lid);

    switch (locks[lid].state)
    {
    case FREE:
      return get_free_lock(lid);
    case LOCKED:
    case RELEASING:
    case ACQUIRING:
      while (locks[lid].state != NONE && locks[lid].state != FREE)
      {
        tprintf("acquire\t id:%s\t waiting for lock:%lld\n", id.c_str(), lid);
        pthread_cond_wait(&locks[lid].cond, &lock_mutex);
      }

      if (locks[lid].state == FREE)
      {
        return get_free_lock(lid);
      }

      if (locks[lid].state == NONE)
      {
        locks[lid].state = ACQUIRING;
        pthread_mutex_unlock(&lock_mutex);
        lock_protocol::status ret = cl->call(lock_protocol::acquire, lid, id, r);

        if (ret == lock_protocol::OK)
        {
          //cache this lock
          pthread_mutex_lock(&lock_mutex);
          locks[lid].state = client_lock::LOCKED;
          pthread_mutex_unlock(&lock_mutex);
          return ret;
        }
        else if (ret == lock_protocol::RETRY)
        {
          while (true)
          {
            pthread_mutex_lock(&lock_mutex);
            if (locks[lid].state == client_lock::LOCKED)
            {
              pthread_mutex_unlock(&lock_mutex);
              return lock_protocol::OK;
            }
            else
            {
              pthread_mutex_unlock(&lock_mutex);
            }
          }
        }
      }
    default:
      break;
    }
  }
  return lock_protocol::OK;
}

lock_protocol::status
lock_client_cache::get_free_lock(lock_protocol::lockid_t lid)
{
  tprintf("acquire\t id:%s\t cached lock\t lid:%lld\t get lock: FREE\n", id.c_str(), lid);
  locks[lid].state = LOCKED;
  pthread_mutex_unlock(&lock_mutex);
  return lock_protocol::OK;
}

lock_protocol::status
lock_client_cache::call_server_acquire(lock_protocol::lockid_t lid)
{
  pthread_mutex_unlock(&lock_mutex);
  int r;
  lock_protocol::status ret = cl->call(lock_protocol::acquire, lid, id, r);
  pthread_mutex_lock(&lock_mutex);
  return ret;
}

lock_protocol::status
lock_client_cache::release(lock_protocol::lockid_t lid)
{
  pthread_mutex_lock(&lock_mutex);
  tprintf("release\t lock:%lld\t id:%s\n", lid, id.c_str());
  int r;

  if (locks.find(lid) != locks.end())
  {
    if (revokes.find(lid) == revokes.end())
    {
      tprintf("release\t lock:%lld\t id:%s\t release\n", lid, id.c_str());
      locks[lid].state = FREE;
      pthread_mutex_unlock(&lock_mutex);
      // wake one waiting thread
      pthread_cond_signal(&locks[lid].cond);
      return lock_protocol::OK;
    }

    tprintf("release\t lock:%lld\t id:%s\t revoke\n", lid, id.c_str());
    locks[lid].state = RELEASING;

    pthread_mutex_unlock(&lock_mutex);
    cl->call(lock_protocol::release, lid, id, r);
    pthread_mutex_lock(&lock_mutex);
    locks[lid].state = NONE;

    pthread_mutex_lock(&revoke_mutex);
    revokes.erase(lid);
    pthread_mutex_unlock(&revoke_mutex);

    pthread_mutex_unlock(&lock_mutex);
    pthread_cond_signal(&locks[lid].cond);
    return lock_protocol::OK;
  }

  tprintf("release\t id:%s\t lock:%lld\t release a wrong lock\n", id.c_str(), lid);
  return lock_protocol::RPCERR;
}

rlock_protocol::status
lock_client_cache::revoke_handler(lock_protocol::lockid_t lid,
                                  int &)
{
  pthread_mutex_lock(&lock_mutex);
  tprintf("revoke\t id:%s\t lock:%lld\n", id.c_str(), lid);
  int r;

  if (locks[lid].state == client_lock::FREE)
  {
    locks[lid].state = client_lock::RELEASING;
    tprintf("revoke\t id:%s\t lock:%lld\t free lock\n", id.c_str(), lid);

    pthread_mutex_unlock(&lock_mutex);
    cl->call(lock_protocol::release, lid, id, r);
    pthread_mutex_lock(&lock_mutex);

    locks[lid].state = client_lock::NONE;
    pthread_mutex_unlock(&lock_mutex);

    // if thread waiting send acquire to server
    pthread_cond_signal(&locks[lid].cond);
    return rlock_protocol::OK;
  }
  else
  {
    tprintf("revoke\t id:%s\t lock:%lld locked, waiting\n", id.c_str(), lid);

    pthread_mutex_lock(&revoke_mutex);
    revokes.insert(lid);
    pthread_mutex_unlock(&revoke_mutex);

    pthread_mutex_unlock(&lock_mutex);
    return rlock_protocol::OK;
  }
}

rlock_protocol::status
lock_client_cache::retry_handler(lock_protocol::lockid_t lid,
                                 int &)
{
  pthread_mutex_lock(&lock_mutex);
  tprintf("retry\t id:%s\t lock:%lld\n", id.c_str(), lid);

  locks[lid].state = client_lock::LOCKED;

  pthread_mutex_unlock(&lock_mutex);
  return rlock_protocol::OK;
}
