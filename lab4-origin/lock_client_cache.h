// lock client interface.

#ifndef lock_client_cache_h

#define lock_client_cache_h

#include <string>
#include <map>
#include <set>
#include <queue>
#include "lock_protocol.h"
#include "rpc.h"
#include "lock_client.h"
#include "lang/verify.h"

// none: client knows nothing about this lock
// free: client owns the lock and no thread has it
// locked: client owns the lock and a thread has it
// acquiring: the client is acquiring ownership
// releasing: the client is releasing ownership
enum locks_state {NONE, FREE, LOCKED, ACQUIRING, RELEASING};

// Classes that inherit lock_release_user can override dorelease so that 
// that they will be called when lock_client releases a lock.
// You will not need to do anything with this class until Lab 6.
class lock_release_user {
 public:
  virtual void dorelease(lock_protocol::lockid_t) = 0;
  virtual ~lock_release_user() {};
};

class client_lock{
 public:
  enum xxstatus{NONE, FREE, LOCKED, ACQUIRING, RELEASING};
  typedef int status;
  
  status state;
  pthread_cond_t cond;

  client_lock(){
    pthread_cond_init(&cond, NULL);
  }
  ~client_lock(){
    pthread_cond_destroy(&cond);  
  }
};

// class client_lock {
//   public:
//     locks_state state;
//     long long owner;
//     std::queue<long long> waiting_threads;
//     bool revoke;
//     bool retry;
// };

class lock_client_cache : public lock_client {
 private:
  class lock_release_user *lu;
  int rlock_port;
  std::string hostname;
  std::string id;
  pthread_mutex_t mutex;

  pthread_mutex_t lock_mutex;
  pthread_mutex_t revoke_mutex;
  std::map<lock_protocol::lockid_t, client_lock> locks;
  // std::map<lock_protocol::lockid_t, pthread_cond_t> conds; 
  std::set<lock_protocol::lockid_t> revokes;

  // lock_protocol::status wait_for_lock(lock_protocol::lockid_t);
  // lock_protocol::status acquire_from_server(lock_protocol::lockid_t);
  lock_protocol::status get_free_lock(lock_protocol::lockid_t lid);
  lock_protocol::status call_server_acquire(lock_protocol::lockid_t lid);

 public:
  static int last_port;
  lock_client_cache(std::string xdst, class lock_release_user *l = 0);
  virtual ~lock_client_cache() {};
  lock_protocol::status acquire(lock_protocol::lockid_t);
  lock_protocol::status release(lock_protocol::lockid_t);
  rlock_protocol::status revoke_handler(lock_protocol::lockid_t, 
                                        int &);
  rlock_protocol::status retry_handler(lock_protocol::lockid_t, 
                                       int &);
};


#endif
