// yfs client.  implements FS operations using extent and lock server
#include "yfs_client.h"
#include "extent_client.h"
#include <sstream>
#include <iostream>
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

// #define LOCK_CREATE     1
// #define LOCK_MKDIR      2
// #define LOCK_WRITE      3
// #define LOCK_UNLINK     4
// #define LOCK_SYMLINK    5

void yfs_client::prt(char *s){
    std::cout << "==== yfs_client ====" << std::endl;
    std::cout << s << std::endl;
    fflush(stdout);
}

yfs_client::yfs_client(std::string extent_dst, std::string lock_dst)
{
  ec = new extent_client(extent_dst);
//   lc = new lock_client(lock_dst);
  lc = new lock_client_cache(lock_dst);
  if (ec->put(1, "") != extent_protocol::OK)
      printf("error init root dir\n"); // XYB: init root dir
    prt("init in yfs");
}

yfs_client::yfs_client(extent_client * nec, lock_client_cache* nlc){
    ec = nec;
    //lc = new lock_client(lock_dst);
    lc = nlc;
    prt("yfs::init in namenode");
}


yfs_client::inum
yfs_client::n2i(std::string n)
{
    std::istringstream ist(n);
    unsigned long long finum;
    ist >> finum;
    return finum;
}

std::string
yfs_client::filename(inum inum)
{
    std::ostringstream ost;
    ost << inum;
    return ost.str();
}

bool
yfs_client::isfile(inum inum)
{
    extent_protocol::attr a;

    if (ec->getattr(inum, a) != extent_protocol::OK) {
        printf("error getting attr\n");
        return false;
    }

    if (a.type == extent_protocol::T_FILE) {
        printf("isfile: %lld is a file\n", inum);
        return true;
    } else if(a.type == extent_protocol::T_DIR) {
        printf("isfile: %lld is a dir\n", inum);
    } else {
        printf("isfile: %lld is a symlink\n", inum);
    }
    return false;
}
/** Your code here for Lab...
 * You may need to add routines such as
 * readlink, issymlink here to implement symbolic link.
 * 
 * */

bool
yfs_client::isdir(inum inum)
{
    // Oops! is this still correct when you implement symlink?
    extent_protocol::attr a;

    if (ec->getattr(inum, a) != extent_protocol::OK) {
        printf("error getting attr\n");
        return false;
    }

    if (a.type == extent_protocol::T_DIR) {
        printf("isdir: %lld is a dir\n", inum);
        return true;
    } else if(a.type == extent_protocol::T_FILE) {
        printf("isdir: %lld is a file\n", inum);
    } else {
        printf("isfile: %lld is a symlink\n", inum);
    }
    return false;
}

int
yfs_client::getfile(inum inum, fileinfo &fin)
{
    int r = OK;

    printf("getfile %016llx\n", inum);
    extent_protocol::attr a;
    if (ec->getattr(inum, a) != extent_protocol::OK) {
        r = IOERR;
        goto release;
    }

    fin.atime = a.atime;
    fin.mtime = a.mtime;
    fin.ctime = a.ctime;
    fin.size = a.size;
    printf("getfile %016llx -> sz %llu\n", inum, fin.size);

release:
    return r;
}

int
yfs_client::getdir(inum inum, dirinfo &din)
{
    int r = OK;

    printf("getdir %016llx\n", inum);
    extent_protocol::attr a;
    if (ec->getattr(inum, a) != extent_protocol::OK) {
        r = IOERR;
        goto release;
    }
    din.atime = a.atime;
    din.mtime = a.mtime;
    din.ctime = a.ctime;

release:
    return r;
}


#define EXT_RPC(xx) do { \
    if ((xx) != extent_protocol::OK) { \
        printf("EXT_RPC Error: %s:%d \n", __FILE__, __LINE__); \
        r = IOERR; \
        goto release; \
    } \
} while (0)

// Only support set size of attr
int
yfs_client::setattr(inum ino, size_t size)
{
    int r = OK;

    /*
     * your code goes here.
     * note: get the content of inode ino, and modify its content
     * according to the size (<, =, or >) content length.
     */
    std::string buf;
    r = ec->get(ino, buf);
    if(r != extent_protocol::OK){
        std::cout << "ERROR in yfs::setattr()" << std::endl;
        return r;
    }

    if(size > buf.size()){
        std::string padding(size-buf.size(), '\0');
        buf += padding;
        r = ec->put(ino, buf);
    }else{
        r = ec->put(ino, buf.substr(0, size));
    }
    if(r != extent_protocol::OK){
        std::cout << "ERROR in yfs::setattr()" << std::endl;
        return r;
    }
    return r;
}

int
yfs_client::create(inum parent, const char *name, mode_t mode, inum &ino_out)
{
    char c[100];
    sprintf(c, "create, parent:%lld, name:%s", parent, name);
    prt(c);

    lc->acquire(parent);
    int r = OK;

    std::list<dirent> dirents;
    std::list<dirent>::iterator it;
    std::stringstream ss;
    dirent de;

    r = readdir(parent, dirents);

    if(r != extent_protocol::OK){
        prt((char *)"ERROR: yfs::create");
        goto release;
    }

    for(it = dirents.begin(); it!=dirents.end(); it++){
        if(it->name == name){
            prt((char *)"ERROR yfs::create dir already has name");
            r = EXIST;
            goto release;
        }
    }

    r = ec->create(extent_protocol::T_FILE, ino_out);
    if(r != extent_protocol::OK){
        prt((char *)"ERROR yfs::create");
        goto release;
    }

    de.name = name;
    de.inum = ino_out;
    dirents.push_back(de);

    ss.unsetf(std::ios::skipws);
    for(it=dirents.begin(); it!=dirents.end(); it++){
        ss << it->inum;
        ss << "/";
        for(unsigned int i=0; i<it->name.size(); i++){
            ss << it->name.substr(i, 1);
        }
        ss << "/";
    }
    r = ec->put(parent, ss.str());
    if(r != extent_protocol::OK){
        prt((char *)"ERROR create put");
    }
release:
    lc->release(parent);
    return r;
}

int
yfs_client::mkdir(inum parent, const char *name, mode_t mode, inum &ino_out)
{
    prt((char *)"mkdir");
    lc->acquire(parent);
    int r = OK;

    std::list<dirent> dirents;
    std::list<dirent>::iterator it;
    std::stringstream ss;
    dirent de;

    
    r = readdir(parent, dirents);

    if(r != extent_protocol::OK){
        prt((char *)"ERROR yfs::create");        
        lc->release(parent);
        return r;
    }

    for(it = dirents.begin(); it!=dirents.end(); it++){
        if(it->name == name){
            prt((char *)"ERROR yfs::create dir already has this name");
            lc->release(parent);
            return EXIST;
        }
    }

    r = ec->create(extent_protocol::T_DIR, ino_out);
    if(r != extent_protocol::OK){
        prt((char *)"ERROR yfs::create");
        lc->release(parent);
        return r;
    }

    de.name = name;
    de.inum = ino_out;
    dirents.push_back(de);

    ss.unsetf(std::ios::skipws);
    for(it=dirents.begin(); it!=dirents.end(); it++){
        ss << it->inum;
        ss << "/";
        for(unsigned int i=0; i<it->name.size(); i++){
            ss << it->name.substr(i, 1);
        }
        ss << "/";
    }
    r = ec->put(parent, ss.str());
    if(r != extent_protocol::OK){
        printf("ERROR: yfs::create  \n");
        lc->release(parent);
        return r;
    }
    prt((char *)"end of mkdir");
    lc->release(parent);
    return r;
}

int
yfs_client::lookup(inum parent, const char *name, bool &found, inum &ino_out)
{
    char c[100];
    sprintf(c, "lookup parent:%lld, name:%s", parent, name);
    prt(c);

    int r = OK;
    std::list<dirent> dirents;
    std::list<dirent>::iterator it;

    r = readdir(parent, dirents);
    found = false;
    if(r != extent_protocol::OK){
        prt((char *)"readdir failed");
        return r;
    }
    it = dirents.begin();
    for(; it!=dirents.end(); it++){
        if(it->name == name){
            prt((char *)"lookup find");
            found=true;
            ino_out = it->inum;
            break;
        }
    }
    prt((char *)"end of lookup");
    return r;
}

int
yfs_client::readdir(inum dir, std::list<dirent> &list)
{
        /*
     * your code goes here.
     * note: you should parse the dirctory content using your defined format,
     * and push the dirents to the list.
     */
    char c[100];
    sprintf(c, "readdir, dir(inum):%lld", dir);
    prt(c);

    int r = OK;
    std::string buf;
    std::istringstream ss;
    std::string de_name; // dirent name
    char delima;
    dirent de;
    list.clear();
    r = ec->get(dir, buf);
    ss.unsetf(std::ios::skipws);
    ss.str(buf);
    if(r != extent_protocol::OK){
        prt((char *)"ERROR: ec->get() error");
        return r;
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
        prt((char *)de_name.c_str());
        de.name = de_name;
        list.push_back(de);
        de_name = "";
    }
    prt((char *)"end of readdir");
    return r;
}

void yfs_client::print_list(std::list<dirent> list){
    std::list<dirent>::iterator it;
    it = list.begin();
    std::cout << "print_list()\n";
    for(; it!=list.end(); it++){
        std::cout << "inum: " << it->inum << ", name: " << it->name << std::endl;
        isfile(it->inum);
    }
}

int
yfs_client::read(inum ino, size_t size, off_t off, std::string &data)
{
    int r = OK;
    prt((char *)"read");

    /*
     * your code goes here.
     * note: read using ec->get().
     */
    std::string buf;
    extent_protocol::attr a;
    r = ec->get(ino, buf);
    if(r != extent_protocol::OK){
        std::cout << "ERROR in yfs::read()" << std::endl;
        return r;
    }
    r = ec->getattr(ino, a);
    if(r != extent_protocol::OK){
        std::cout << "ERROR in yfs::read()" << std::endl;
        return r;
    }
    if(off > a.size){
        data = "";
    }
    else if(off + size > a.size){
        data = buf.substr(off, a.size-off);
    }else{
        data = buf.substr(off, size);
    }
    return r;
}

int
yfs_client::write(inum ino, size_t size, off_t off, const char *data,
        size_t &bytes_written)
{
    prt((char *)"write");
    lc->acquire(ino);
    int r = OK;

    /*
     * your code goes here.
     * note: write using ec->put().
     * when off > length of original file, fill the holes with '\0'.
     */
    std::string tmp;
    std::string buf;
    std::string new_content(data, size);
    extent_protocol::attr a;

    ec->getattr(ino, a);
    r = ec->get(ino, buf);
    tmp = buf;
    if(r != extent_protocol::OK){
        std::cout << "ERROR in yfs::write()" << std::endl;
        lc->release(ino);
        return r;
    }
    if(off > a.size){
        buf.resize(off, '\0');
        buf += new_content;
        r = ec->put(ino, buf);
    }else if(off + size < a.size){
        std::string head =  buf.substr(0, off);
        std::string tail = buf.substr(off+size, buf.size()-off-size);
        buf = head;
        buf += new_content;
        buf += tail;
        r = ec->put(ino, buf);
    }else{
        buf = buf.substr(0, off);
        buf += new_content;
        r = ec->put(ino, buf);
    }
    if(r != extent_protocol::OK){
        std::cout << "ERROR in yfs::write()" << std::endl;
        lc->release(ino);        
        return r;
    }
    
    bytes_written = size;
    lc->release(ino);        
    return r;
}

int yfs_client::unlink(inum parent,const char *name)
{
    prt((char *)"unlink");
    lc->acquire(parent);
    int r = OK;

    std::list<dirent> dirents;
    std::stringstream ss;

    r = readdir(parent, dirents);
    if(r != extent_protocol::OK){
        printf("ERROR in unlink() readdir()\n");
        lc->release(parent);
        return r;
    }
    std::list<dirent>::iterator it;

    bool find=false;
    for(it=dirents.begin(); it!=dirents.end(); it++){
        if(it->name == name){
            if(isdir(it->inum)){
                lc->release(parent);
                return IOERR;
            }
			lc->acquire(it->inum);
            r = ec->remove(it->inum);
			lc->release(it->inum);
            dirents.erase(it);
            find=true;
            break;
        }
    }
    if(r != extent_protocol::OK){
        printf("ERROR in unlink()\n");
        lc->release(parent);
        return r;
    }
    if(!find){
        r = NOENT;
        lc->release(parent);
        return r;
    }

    ss.unsetf(std::ios::skipws);
    for(it=dirents.begin(); it!=dirents.end(); it++){
        ss << it->inum;
        ss << "/";
        for(unsigned int i=0; i<it->name.size(); i++){
            ss << it->name.substr(i, 1);
        }
        ss << "/";
    }
    r = ec->put(parent, ss.str());
    if(r != extent_protocol::OK){
        printf("ERROR in unlink()\n");
        lc->release(parent);
        return r;
    }
    lc->release(parent);
    return r;
}

int yfs_client::symlink(inum parent, const char *link, const char *name, inum &ino_out){
    prt((char *)"symlink");
    lc->acquire(parent);
    int r;
    std::list<dirent> dirents;
    std::list<dirent>::iterator it;
    std::stringstream ss;
    dirent de;
    r = OK;
    r = readdir(parent, dirents);
    if(r != extent_protocol::OK){
        printf("ERROR: yfs::symlink \n");
        lc->release(parent);
        return r;
    }
    for(it = dirents.begin(); it!=dirents.end(); it++){
        if(it->name == name){
            printf("ERROR yfs::symlink file already has name\n");
            lc->release(parent);            
            return EXIST;
        }
    }

    r = ec->create(extent_protocol::T_LINK, ino_out);
    if(r != extent_protocol::OK){
        printf("ERROR: yfs::create \n");
        lc->release(parent);
        return r;
    }
    r = ec->put(ino_out, link);
    if(r != extent_protocol::OK){
        printf("ERROR: yfs::create \n");
        lc->release(parent);
        return r;
    }
    de.name = name;
    de.inum = ino_out;
    dirents.push_back(de);
    

    ss.unsetf(std::ios::skipws);
    for(it=dirents.begin(); it!=dirents.end(); it++){
        ss << it->inum;
        ss << "/";
        for(unsigned int i=0; i<it->name.size(); i++){
            ss << it->name.substr(i, 1);
        }
        ss << "/";
    }
    
    r = ec->put(parent, ss.str());
    if(r != extent_protocol::OK){
        printf("ERROR: yfs::create \n");
        lc->release(parent);
        return r;
    }
    
    if(r != extent_protocol::OK){
        printf("ERROR: yfs::create \n");
        lc->release(parent);
        return r;
    }

    std::list<dirent> new_list;
    readdir(parent, new_list);
    // print_list(new_list);

    // std::string sympath;
    // readlink(ino_out, sympath);
    // printf("end of symlink()\n");
    lc->release(parent);
    return r;
}

int yfs_client::readlink(inum ino, std::string& path) {
    prt((char *)"readlink");
    int r = extent_protocol::OK;
    r = ec->get(ino, path);
    if(r != extent_protocol::OK){
        printf("ERROR in yfs::readlink\n");
        return r;
    }
    // printf("path: %s\n", path.c_str());
    return r;
}


