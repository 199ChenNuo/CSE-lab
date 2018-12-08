#include "namenode.h"
#include "extent_client.h"
#include "lock_client.h"
#include <sys/stat.h>
#include <unistd.h>
#include <sstream>
#include "threader.h"

using namespace std;

void NameNode::fprt(char *s){
  cout << s << endl;
  fflush(stdout);
}

void NameNode::init(const string &extent_dst, const string &lock_dst) {
  ec = new extent_client(extent_dst);
  lc = new lock_client_cache(lock_dst);
  yfs = new yfs_client(extent_dst, lock_dst);

  /* Add your init logic here */
}

// Call get_block_ids and convert block ids to LocatedBlocks.
list<NameNode::LocatedBlock> NameNode::GetBlockLocations(yfs_client::inum ino) {
  // return list<LocatedBlock>();
  char *output;
  sprintf(output, "namenode\t GetBlockLocations(inum:%lld)", ino);
  fprt(output);

  std::list<blockid_t> block_ids;
  list<NameNode::LocatedBlock> LocatedBlocks;
  list<blockid_t>::iterator it;

  // yfs->get_block_ids(ino, block_ids);
  ec->get_block_ids(ino, block_ids);
  int counter=0;
  for(auto item : block_ids){
    LocatedBlocks.push_back(LocatedBlock(item, counter, BLOCK_SIZE, master_datanode));
    counter++;
  }
  return LocatedBlocks;
}

// Call complete and unlock the file.
bool NameNode::Complete(yfs_client::inum ino, uint32_t new_size) {
  char *output;
  sprintf(output, "namenode\t Complete(inum:%d, new_size: %d", ino, new_size);
  fprt(output);

  bool r = !(ec->complete(ino, new_size));
  fprt("release ino");
  lc->release(ino);

  return r;
}

// Call append_block and convert block id to LocatedBlock.
NameNode::LocatedBlock NameNode::AppendBlock(yfs_client::inum ino) {
  // throw HdfsException("Not implemented");
  char *output;
  sprintf(output, "namenode\t appendBlock(ino:%d)", ino);
  fprt(output);

  blockid_t bid;
  ec->append_block(ino, bid);
  sprintf(output, "bid:%lld" , bid);
  fprt(output);

  extent_protocol::attr attr;
  ec->getattr(ino, attr);

  return LocatedBlock(bid, attr.size / BLOCK_SIZE + attr.size % BLOCK_SIZE, BLOCK_SIZE, master_datanode);
}

// Move a directory entry. Note that src_name/dst_name is entry name, not full path.
// move a file (file name is sec_name) from src_dir to dst_dir, and rename as dst_name
bool NameNode::Rename(yfs_client::inum src_dir_ino, string src_name, yfs_client::inum dst_dir_ino, string dst_name) {
  // return false;
  char *output;
  bool found = false;
  inode_t inode;

  sprintf(output, "namenode\t Rename(src_name:%s)", src_name.c_str());
  fprt(output);

  // yfs->lookup(src_dir_ino, src_name, found, inode);
  // if(!found){
  //   fprt("file not found");
  // }

  list<yfs_client::dirent> entries;
  list<yfs_client::dirent> dst_entry;
  list<yfs_client::dirent>::iterator it;

  yfs->readdir(src_dir_ino, entries);
  yfs->readdir(dst_dir_ino, dst_entry);

  // check is dst_name already in dst_dir
  for (it=dst_entry.begin(); it!=dst_entry.end(); it++){
    if(it->name == dst_name){
      fprt("dst_name already exist");
      return false;
    }
  }

  // check if src_name is in src_dir
  for (it=entries.begin(); it!=entries.end(); it++){
    if(it->name == src_name){
      fprt("find");
      found=true;
      break;
    }
  }
  if(!found){
    fprt("file does not exists");
    return false;
  }
  
  // remove from src_dir
  entries.erase(it);
  
  stringstream dst_ss;
  dst_ss << it->inum;
  dst_ss << "/";
  for(unsigned int i=0; i<it->name.size(); i++){
      dst_ss << it->name.substr(i, 1);
  }
  dst_ss << "/";

  // construct src entries
  stringstream ss;
  for(it=entries.begin(); it!=entries.end(); it++){
    ss << it->inum;
    ss << "/";
    for(unsigned int i=0; i<it->name.size(); i++){
      ss << it->name.substr(i, 1);
    }
    ss << "/";
  }

  // construct dst entries

  for (it=dst_entry.begin(); it!=dst_entry.end(); it++){
    ss << it->inum;
    ss << "/";
    for(unsigned int i=0; i<it->name.size(); i++){
      ss << it->name.substr(i, 1);
    }
    ss << "/";
  }

  // put back
  ec->put(src_dir_ino, ss.str());
  ec->put(dst_dir_ino, dst_ss.str());
  return true;
}

// Just call mkdir.
bool NameNode::Mkdir(yfs_client::inum parent, string name, mode_t mode, yfs_client::inum &ino_out) {
  // return false;
  char *output;
  sprintf(output, "namenode\t Mkdir(parent:%lld, name:%s)", parent, name.c_str());
  fprt(output);

  // OK=0
  return !(yfs->mkdir(parent, name.c_str(), mode, ino_out));
}

// Create a file, remember to lock it before return.
bool NameNode::Create(yfs_client::inum parent, string name, mode_t mode, yfs_client::inum &ino_out) {
  char* output;
  sprintf(output, "namenode\t Create(parent:%lld, name:%s)", parent, name.c_str());
  fprt(output);

  int r = !(yfs->create(parent, name.c_str(), mode, ino_out));

  sprintf(output, "lock ino:%lld", ino_out);
  fprt(output);

  lc->acquire(ino_out);
}

// The same as the functions in yfs_client, 
// but the framework will call these functions with the locks held, 
// so you shouldn't try to lock them again. Otherwise there will be a deadlock.
bool NameNode::Isfile(yfs_client::inum ino) {
  extent_protocol::attr a;

  if (ec->getattr(ino, a) != extent_protocol::OK) {
      printf("error getting attr\n");
      return false;
  }

  if (a.type == extent_protocol::T_FILE) {
      return true;
  } else if(a.type == extent_protocol::T_DIR) {
      // printf("isfile: %lld is a dir\n", inum);
  } else {
      // printf("isfile: %lld is a symlink\n", inum);
  }
  return false;
}

// The same as the functions in yfs_client, 
// but the framework will call these functions with the locks held, 
// so you shouldn't try to lock them again. Otherwise there will be a deadlock.
bool NameNode::Isdir(yfs_client::inum ino) {
  extent_protocol::attr a;

  if (ec->getattr(ino, a) != extent_protocol::OK) {
      printf("error getting attr\n");
      return false;
  }

  if (a.type == extent_protocol::T_DIR) {
      // printf("isdir: %lld is a dir\n", inum);
      return true;
  } else if(a.type == extent_protocol::T_FILE) {
      // printf("isdir: %lld is a file\n", inum);
  } else {
      // printf("isfile: %lld is a symlink\n", inum);
  }
  return false;
}

// The same as the functions in yfs_client, 
// but the framework will call these functions with the locks held, 
// so you shouldn't try to lock them again. Otherwise there will be a deadlock.
bool NameNode::Getfile(yfs_client::inum ino, yfs_client::fileinfo &info) {
  int r = true;

  printf("getfile %016llx\n", ino);
  extent_protocol::attr a;
  if (ec->getattr(ino, a) != extent_protocol::OK) {
    r = yfs_client::IOERR;
    goto release;
  }

  info.atime = a.atime;
  info.mtime = a.mtime;
  info.ctime = a.ctime;
  info.size = a.size;
  printf("getfile %016llx -> sz %llu\n", ino, info.size);

release:
  return r;
}

// The same as the functions in yfs_client, 
// but the framework will call these functions with the locks held, 
// so you shouldn't try to lock them again. Otherwise there will be a deadlock.
bool NameNode::Getdir(yfs_client::inum ino, yfs_client::dirinfo &info) {
  // return false;
  int r = true;

  printf("getdir %016llx\n", ino);
  extent_protocol::attr a;
  if (ec->getattr(ino, a) != extent_protocol::OK) {
      r = false;
      goto release;
  }
  info.atime = a.atime;
  info.mtime = a.mtime;
  info.ctime = a.ctime;

release:
  return r;
}

// The same as the functions in yfs_client, 
// but the framework will call these functions with the locks held, 
// so you shouldn't try to lock them again. Otherwise there will be a deadlock.
bool NameNode::Readdir(yfs_client::inum ino, std::list<yfs_client::dirent> &dir) {
  fprt("namenode\t readdir");
  int r = true;
  std::string buf;
  std::istringstream ss;
  std::string de_name; // dirent name
  char delima;
  yfs_client::dirent de;
  
  dir.clear();
  r = ec->get(ino, buf);
  ss.unsetf(std::ios::skipws);
  ss.str(buf);
  
  if(r != extent_protocol::OK){
      fprt("get dir error");
      return false;
  }
  while(ss >> de.inum){
      ss >> delima;
      while(ss >> delima){
          if(delima == '/'){
              break;
          }else{
              de_name += delima;
          }
      }
      de.name = de_name;
      dir.push_back(de);
      de_name = "";
  }
  return true;;
}

// The same as the functions in yfs_client, 
// but the framework will call these functions with the locks held, 
// so you shouldn't try to lock them again. Otherwise there will be a deadlock.
bool NameNode::Unlink(yfs_client::inum parent, string name, yfs_client::inum ino) {
  // return false;
  fprt("namenode\t unlink");

  std::list<yfs_client::dirent> entries;
  std::list<yfs_client::dirent>::iterator it;
  if(!Readdir(ino, entries)){
    fprt("readdir error");
    return false;
  }
  bool found=false;
  // std::list<yfs_client::dirent>::iterator it;
  for (it=entries.begin(); it!=entries.end(); it++){
    if(it->name == name){
        if(Isdir(it->inum)){
          fprt("unlink a dir");
          return false;
        }
        lc->acquire(it->inum);
        ec->remove(it->inum);
        lc->release(it->inum);
        found = true;
        break;
    }
  }
  if(!found){
    fprt("name not exist");
    return false;
  }
  stringstream ss;
  ss.unsetf(std::ios::skipws);


}

void NameNode::DatanodeHeartbeat(DatanodeIDProto id) {
}

void NameNode::RegisterDatanode(DatanodeIDProto id) {
}

list<DatanodeIDProto> NameNode::GetDatanodes() {
  return list<DatanodeIDProto>();
}
