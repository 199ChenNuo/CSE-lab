#ifndef lock_server_cache_h
#define lock_server_cache_h

#include <string>


#include <map>
#include <queue>
#include "lock_protocol.h"
#include "rpc.h"
#include "lock_server.h"

enum server_state {NONE, FREE, LOCKED, REVOKING, RELEASING};

class lock_server_cache {
 private:
  int nacquire;
  pthread_mutex_t mutex;
  pthread_cond_t cond;
  std::map<lock_protocol::lockid_t, std::string> locks_owner;
  std::map<lock_protocol::lockid_t, int> locks_state;
  std::map<lock_protocol::lockid_t, std::queue<std::string> > wait_thread;
 public:
  lock_server_cache();
  lock_protocol::status stat(lock_protocol::lockid_t, int &);
  int acquire(lock_protocol::lockid_t, std::string id, int &);
  int release(lock_protocol::lockid_t, std::string id, int &);
};

#endif
