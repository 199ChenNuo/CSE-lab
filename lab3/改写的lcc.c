lock_protocol::status
lock_client_cache::acquire(lock_protocol::lockid_t lid)
{
  pthread_mutex_lock(&lock_mutex);
  tprintf("acquire\t lock:%lld\t, id:%s\n", lid, this->id.c_str());

  int r;
  
  if(locks.find(lid) == locks.end() || locks[lid].state == NONE){
      // a new lock (not cached)
    tprintf("acquire\t new lock\t lid:%lld\t acquiring\n", lid);
    locks[lid].state = ACQUIRING;
    pthread_mutex_unlock(&mutex);
    lock_protocol::status ret = cl->call(lock_protocol::acquire, lid, id, r);
    
    if(ret == lock_protocol::OK){
        tprintf("acquire\t new lock\t lid:%lld\t get lock\n", lid);
        pthread_mutex_lock(&mutex);
        locks[lid].state = LOCKED;
        pthread_mutex_unlock(&mutex);
        return ret;
    }

    // spin wait for lock
    while(true){
        pthread_mutex_lock(&mutex);
        if(locks[lid].state == LOCKED){
            tprintf("acquire\t new lock\t lid:%lld, spin wait get lock\n", lic);
            pthread_mutex_unlock(&mutex);
            return lock_protocol::OK;
        }
        pthread_mutex_unlock(&mutex);
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
                pthread_cond_wait(&locks[lid].cond, &mutex);
            }

            if(locks[lid].state == FREE){
                return get_free_lock(lid);
            }

            if(locks[lid].state == NONE){
                locks[lid].state = ACQUIRING;
                pthread_mutex_unlock(&mutex);
                lock_protocol::status ret = cl->call(lock_protocol::acquire, lid, id, r);

                if(ret == lock_protocol::OK){
                    tprintf("acquire\t cached lock\t lid:%lld\t get lock\n", lid);
                    pthread_mutex_lock(&mutex);
                    locks[lid].state = LOCKED;
                    pthread_mutex_unlock(&mutex);
                    return ret;
                }

                // spin wait for lock
                while(true){
                    pthread_mutex_lock(&mutex);
                    if(locks[lid].state == LOCKED){
                        tprintf("acquire\t new lock\t lid:%lld, spin wait get lock\n", lic);
                        pthread_mutex_unlock(&mutex);
                        return lock_protocol::OK;
                    }
                    pthread_mutex_unlock(&mutex);
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
    pthread_mutex_unlock(&mutex);
    return lock_protocol::OK;
}

lock_protocol::status
lock_client_cache::call_server_acquire(lock_protocol::lockid_t lid){
    pthread_mutex_unlock(&mutex);
    lock_protocol::status ret = cl->call(lock_protocol::acquire, lid, id, r);
    pthread_mutex_lock(&mutex);
    return ret;
}


lock_protocol::status
lock_client_cache::release(lock_protocol::lockid_t lid)
{
    pthread_mutex_lock(&lock_mutex);
    tprintf("release\t lock:%lld\t id:%s\n", lid, id.c_str());
    int r;

    if(locks.find(lid) != locks.end()){
        if(revokes.find(lid) == revokes.end()){
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

    tprintf("release\t lock:%lld\t id:%s\t release a wrong lock\n", lid, id.c_str());
    return lock_protocol::RPCERR;
}