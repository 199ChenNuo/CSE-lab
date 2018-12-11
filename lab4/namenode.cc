#include "namenode.h"
#include "extent_client.h"
#include "lock_client.h"
#include <sys/stat.h>
#include <unistd.h>
#include "threader.h"

using namespace std;

void NameNode::init(const string &extent_dst, const string &lock_dst) {
  ec = new extent_client(extent_dst);
  lc = new lock_client_cache(lock_dst);
  yfs = new yfs_client(extent_dst, lock_dst);

  /* Add your init logic here */
}

void NameNode::prt(char *s){
  cout << "namenode: " << s << endl;
  fflush(stdout);
}

list<NameNode::LocatedBlock> NameNode::GetBlockLocations(yfs_client::inum ino) {
  char c[100];sprintf(c, "GetBlockLocations: inum:%lld", ino);prt(c);

  list<LocatedBlock> r;
  list<blockid_t> block_ids;
  list<blockid_t>::iterator it;
  extent_protocol::attr a;
  int counter = 0;

  ec->get_block_ids(ino, block_ids);
  ec->getattr(ino, a);
  for (it=block_ids.begin(); it!=block_ids.end(); it++){
    unsigned int size = (counter == (block_ids.size()-1)) ? a.size-(counter*BLOCK_SIZE) : BLOCK_SIZE;
    LocatedBlock lb(*it, counter*BLOCK_SIZE, size, master_datanode);
    r.push_back(lb);
    counter++;
  }
  prt("end of GetLocatedBlocks");
  return r;
}

bool NameNode::Complete(yfs_client::inum ino, uint32_t new_size) {
  char c[100];sprintf(c, "Complete(ino:%lld, new_size:%d)", ino, new_size);prt(c);

  bool ret = !ec->complete(ino, new_size);
  if (ret)
    lc->release(ino);
  prt((char *)"end of Complete");
  return ret;
}

NameNode::LocatedBlock NameNode::AppendBlock(yfs_client::inum ino) {
  char c[100];sprintf(c, "AppendBlock(inum:%lld)", ino);prt(c);

  blockid_t bid;
  extent_protocol::attr attr;
  ec->getattr(ino, attr);
  ec->append_block(ino, bid);

  uint64_t size;
  if (attr.size%BLOCK_SIZE == 0){
    size = BLOCK_SIZE;
  }else{
    size = attr.size%BLOCK_SIZE;
  }
  LocatedBlock ret(bid, attr.size, size, master_datanode);
  return ret;
}

bool NameNode::Rename(yfs_client::inum src_dir_ino, string src_name, yfs_client::inum dst_dir_ino, string dst_name) {
  char c[100];sprintf(c, "Rename:src dir:%lld, src_name:%s, dst dir:%lld, dst name:%s", \
                      src_dir_ino, src_name.c_str(), dst_dir_ino, dst_name.c_str());prt(c);
  list<yfs_client::dirent> src_dir;
  list<yfs_client::dirent> dst_dir;
  Readdir(src_dir_ino, src_dir);
  Readdir(dst_dir_ino, dst_dir);
  list<yfs_client::dirent>::iterator sit = src_dir.begin();
  list<yfs_client::dirent>::iterator dit = dst_dir.begin();
  stringstream ss, dss;
  bool found = true;

  if(src_dir_ino == dst_dir_ino){
    if(src_name == dst_name)
      return true;
    for(; sit!=src_dir.end(); sit++){
      if(sit->name == src_name){
        ss << sit->inum;
        ss << "/";
        for(unsigned int i=0; i<dst_name.size(); i++){
          ss << dst_name.substr(i, 1);
        }
        ss << "/";
        found = true;
      } else {
        ss << sit->inum;
        ss << "/";
        ss << sit->name;
        ss << "/";
      }
    }
    ec->put(src_dir_ino, ss.str());
    sprintf(c, "src dir==dst dir, end of rename");prt(c);
    return found;
  }

  for(; sit!=src_dir.end(); sit++){
    if(sit->name == src_name){
      dss << sit->inum;
      dss << "/";
      for(unsigned int i=0; i<dst_name.size(); i++){
        dss << dst_name.substr(i, 1);
      }
      dss << "/";
      found = true;
    } else {
      ss << sit->inum;
      ss << "/";
      ss << sit->name;
      ss << "/";
    }
  }
  for(; dit!=dst_dir.end(); dit++){
    dss << dit->inum;
    dss << "/";
    for(unsigned int i=0; i<dit->name.size(); i++){
      dss << dit->name.substr(i, 1);
    }
    dss << "/";
  }
  ec->put(src_dir_ino, ss.str());
  ec->put(dst_dir_ino, dss.str());
  sprintf(c, "src dir!=dst dir, end of rename");prt(c);
  return found;
}

bool NameNode::Mkdir(yfs_client::inum parent, string name, mode_t mode, yfs_client::inum &ino_out) {
  // return false;
  char c[100];sprintf(c, "Mkdir(parent:%lld)", parent);prt(c);

  int r = !(yfs->mkdir(parent, name.c_str(), mode, ino_out));

  sprintf(c, "ino_out:%lld, r:%d", ino_out, r);
  return r;
}

bool NameNode::Create(yfs_client::inum parent, string name, mode_t mode, yfs_client::inum &ino_out) {
  char c[100];sprintf(c, "Create(parent:%lld, name:%s)", parent, name.c_str());prt(c);

  bool res =  !(yfs->create(parent, name.c_str(), mode, ino_out));
  
  if (res){
    sprintf(c, "create inode is : %lld", ino_out);prt(c);
    lc->acquire(ino_out);
    return true;
  }
  prt((char *)"res is not OK");
  return false;
}

bool NameNode::Isfile(yfs_client::inum ino) {
  char c[100];sprintf(c, "Isfile(inum:%lld)", ino);prt(c);

  extent_protocol::attr a;

  if (ec->getattr(ino, a) != extent_protocol::OK) {
    prt((char *)"error get attr");
    return false;
  }

  if (a.type == extent_protocol::T_FILE) {
    prt((char *)"is file");
    return true;
  }
  prt((char *)"not a file");
  return false;
}

bool NameNode::Isdir(yfs_client::inum ino) {
  char c[100];sprintf(c, "Isdir(inum:%lld)", ino);prt(c);
  extent_protocol::attr a;

  if (ec->getattr(ino, a) != extent_protocol::OK) {
      prt((char *)"error get attr");
      return false;
  }

  if (a.type == extent_protocol::T_DIR) {
      prt((char *)"is dir");
      return true;
  } 
  prt((char *)"not a dir");
  return false;
}

bool NameNode::Getfile(yfs_client::inum ino, yfs_client::fileinfo &info) {
  char c[100];sprintf(c, "Getfile(inum:%lld)", ino);prt(c);
  extent_protocol::attr attr;
  if (ec->getattr(ino, attr) != extent_protocol::OK) {
    prt((char *)"error get attr");
    return false;
  }
  info.atime = attr.atime;
  info.mtime = attr.mtime;
  info.ctime = attr.ctime;
  info.size = attr.size;
  prt((char *)"end of Getfile");
  return true;
}

bool NameNode::Getdir(yfs_client::inum ino, yfs_client::dirinfo &info) {
  char c[100];sprintf(c, "Getdir(inum:%lld)", ino);prt(c);

  extent_protocol::attr attr;
  if (ec->getattr(ino, attr) != extent_protocol::OK) {
    prt((char *)"error get attr");
    return false;
  }
  info.atime = attr.atime;
  info.mtime = attr.mtime;
  info.ctime = attr.ctime;
  prt((char *)"end of Getdir");
  return true;
}

bool NameNode::Readdir(yfs_client::inum ino, std::list<yfs_client::dirent> &dir) {
  char c[100];sprintf(c, "Readdir(inum:%lld)", ino);prt(c);

  int r = true;
  std::string buf;
  std::istringstream ss;
  std::string de_name;
  char delima;
  yfs_client::dirent de;
  
  dir.clear();
  r = ec->get(ino, buf);
  ss.unsetf(std::ios::skipws);
  ss.str(buf);
  
  if(r != extent_protocol::OK){
      prt((char *)"get dir error");
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
      sprintf(c, "file name is :%s", de_name.c_str()); prt(c);
      de.name = de_name;
      dir.push_back(de);
      de_name = "";
  }
  prt((char *)"end of readdir");
  return true;
}

bool NameNode::Unlink(yfs_client::inum parent, string name, yfs_client::inum ino) {
  char c[100];sprintf(c, "Unlink(parent:%lld, name:%s, ino:%lld",parent, name.c_str(), ino);prt(c);

  std::list<yfs_client::dirent> entries;
  std::list<yfs_client::dirent>::iterator it;
  bool found;
  stringstream ss;

  Readdir(parent, entries);
  for(it=entries.begin(); it!=entries.end(); it++){
    if(it->name == name){
      ec->remove(ino);
      found=true;
    }else{
      ss << it->inum;
      ss << "/";
      for(unsigned int i=0; i<it->name.size(); i++){
        ss << it->name.substr(i, 1);
      }
      ss << "/";
    }
  }
  ec->put(parent, ss.str());
  sprintf(c, "found:%d", found);prt(c);
  return found;
}

void NameNode::DatanodeHeartbeat(DatanodeIDProto id) {
}

void NameNode::RegisterDatanode(DatanodeIDProto id) {
}

list<DatanodeIDProto> NameNode::GetDatanodes() {
  return list<DatanodeIDProto>();
}
