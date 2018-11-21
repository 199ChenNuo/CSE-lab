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