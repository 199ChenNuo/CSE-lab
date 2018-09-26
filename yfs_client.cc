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

yfs_client::yfs_client()
{
    ec = new extent_client();

}

yfs_client::yfs_client(std::string extent_dst, std::string lock_dst)
{
    ec = new extent_client();
    if (ec->put(1, "") != extent_protocol::OK)
        printf("error init root dir\n"); // XYB: init root dir
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
    } 
    printf("isfile: %lld is a dir\n", inum);
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
    return ! isfile(inum);
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
    // int r = OK;

    // /*
    //  * your code goes here.
    //  * note: get the content of inode ino, and modify its content
    //  * according to the size (<, =, or >) content length.
    //  */
    // std::cout << "yfs::setattr()" << std::endl;
    // std::string buf;
    // r = ec->get(ino, buf);
    // if(r != extent_protocol::OK){
    //     std::cout << "ERROR in yfs::setattr()" << std::endl;
    //     return r;
    // }

    // if(size > buf.size()){
    //     std::string padding(size-buf.size(), '\0');
    //     buf += padding;
    //     r = ec->put(ino, buf);
    // }else{
    //     r = ec->put(ino, buf.substr(0, size));
    // }
    // if(r != extent_protocol::OK){
    //     std::cout << "ERROR in yfs::setattr()" << std::endl;
    //     return r;
    // }
    // return r;
    int r = OK;

    /*
     * your code goes here.
     * note: get the content of inode ino, and modify its content
     * according to the size (<, =, or >) content length.
     */
    std::string content;
    ec->get(ino, content);
    extent_protocol::attr a;
    ec->getattr(ino, a);
    if (a.type == 0) {
        r = IOERR;
        return r;
    }

    if (size > a.size) { 
        std::string padding(size - a.size, '\0');
        content += padding;
        a.size = size;
    } 
    else if (size < a.size) {
        content = content.substr(0, size);
        a.size = size;
    }
    ec->put(ino, content);

    return r;
}

int
yfs_client::create(inum parent, const char *name, mode_t mode, inum &ino_out)
{
    int r = OK;

    /*
     * your code goes here.
     * note: lookup is what you need to check if file exist;
     * after create file or dir, you must remember to modify the parent infomation.
     */

    std::cout << "========== yfs::create(parent: " << parent << ", name: " << name << ") ==========" << std::endl;
    std::list<dirent> dirents;
    std::list<dirent>::iterator it;
    std::stringstream ss;
    dirent de;

    
    r = readdir(parent, dirents);

    if(r != extent_protocol::OK){
        printf("ERROR: yfs::create readder\n");
        return r;
    }

    for(it = dirents.begin(); it!=dirents.end(); it++){
        if(it->name == name){
            printf("ERROR yfs::create dir already has name\n");
            return EXIST;
        }
    }

    r = ec->create(extent_protocol::T_FILE, ino_out);
    if(r != extent_protocol::OK){
        printf("ERROR: yfs::create readder\n");
        return r;
    }

    de.name = name;
    de.inum = ino_out;
    dirents.push_back(de);

    // std::cout << "all files :\n" ;
    ss.unsetf(std::ios::skipws);
    for(it=dirents.begin(); it!=dirents.end(); it++){
        ss << it->inum;
        ss << "/";
        for(int i=0; i<it->name.size(); i++){
            ss << it->name.substr(i, 1);
        }
        ss << "/";
        // std::cout << "it->inum:" << it->inum << "\tit->name:" << it->name << std::endl;
    }
    r = ec->put(parent, ss.str());
    // std::cout << "ss.str():\n" << ss.str() << std::endl;
    if(r != extent_protocol::OK){
        printf("ERROR: yfs::create readder\n");
        return r;
    }
    printf("end of create()\n\n");
    return r;
}

int
yfs_client::mkdir(inum parent, const char *name, mode_t mode, inum &ino_out)
{
    int r = OK;

    /*
     * your code goes here.
     * note: lookup is what you need to check if directory exist;
     * after create file or dir, you must remember to modify the parent infomation.
     */

    return r;
}

int
yfs_client::lookup(inum parent, const char *name, bool &found, inum &ino_out)
{
    int r = OK;
    std::list<dirent> dirents;
    std::list<dirent>::iterator it;

    /*
     * your code goes here.
     * note: lookup file from parent dir according to name;
     * you should design the format of directory content.
     */
    std::cout << "========== yfs::lookup(parent: " << parent << ", name: " << name << ") ==========" << std::endl;
    r = readdir(parent, dirents);
    found = false;
    if(r != extent_protocol::OK){
        printf("ERROR: in readdir()\n");
        printf("end of yfs::lookup()\n\n");
        return r;
    }
    // it=dirents.begin();
    // for(it++; it!=dirents.end(); it++){
    //     std::cout<< "file inum: " << it->inum << "\tname: " << it->name << std::endl;
    // }
    it = dirents.begin();
    for(; it!=dirents.end(); it++){
        if(it->name == name){
            found=true;
            ino_out = it->inum;
            break;
        }
    }
    printf("end of yfs::lookup()\n\n");
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
    int r = OK;
    unsigned int i;
    std::string buf;
    std::istringstream ss;
    std::string de_name; // dirent name
    char *str_inum;
    yfs_client::inum de_inum;
    char delima;
    int inum_end, name_end, de_end;
    dirent de;

    
    list.clear();

    std::cout << "========== yfs::readdir(dir: " << dir << ") ==========" << std::endl;

    r = ec->get(dir, buf);
    // std::cout << "*****get dir content:*****\n" << buf << std::endl;
    
    ss.unsetf(std::ios::skipws);
    ss.str(buf);
    
    if(r != extent_protocol::OK){
        printf("ERROR: ec->get() error");
        return r;
    }
    
    // std::cout << "before while loop\n";
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
        // std::cout << "inum:" << de.inum << "name:" << de.name << std::endl;
        list.push_back(de);
        de_name = "";
    }
    // std::cout << "end of while loop\n";

    print_list(list);
    printf("end of yfs::readdir()\n\n");
    return r;
}

void yfs_client::print_list(std::list<dirent> list){
    std::list<dirent>::iterator it;
    it = list.begin();
    std::cout << "print_list()\n";
    for(; it!=list.end(); it++){
        std::cout << "inum: " << it->inum << ", name: " << it->name << std::endl;
    }
}

int
yfs_client::read(inum ino, size_t size, off_t off, std::string &data)
{
    int r = OK;

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
    int i;

    ec->getattr(ino, a);
    std::cout << "write()" << ",inum:" << ino << std::endl;
    std::cout << "new_content: " << new_content << std::endl; 
    r = ec->get(ino, buf);
    tmp = buf;
    std::cout << "off: " << off << " ,buf.size():" << a.size << " ,size: " << size << std::endl;
    if(r != extent_protocol::OK){
        std::cout << "ERROR in yfs::write()" << std::endl;
        return r;
    }
    if(off > a.size){
        std::string padding(off - a.size, '\0');
        buf += padding;
        buf += new_content;
        r = ec->put(ino, buf);
        printf("find this case, buf.size():%d\n", buf.size());
        
        if(r != extent_protocol::OK){
            std::cout << "in this case, write wrong" << std::endl;
            // return r;
        }
    }else if(off + size < a.size){
        std::string head =  buf.substr(0, off);

        std::string tail = buf.substr(off+size, buf.size()-off-size);
        
        buf = head;
        buf += new_content;
        buf += tail;
        r = ec->put(ino, buf);
    }else{
        // off + size > buf.size() > off
        buf = buf.substr(0, off);
        // std::cout << "buf after: 393\t" << buf << std::endl;
        buf += new_content;
        // std::cout << "buf after: 396\t" << buf << std::endl;
        r = ec->put(ino, buf);
    }
    if(r != extent_protocol::OK){
        std::cout << "ERROR in yfs::write()" << std::endl;
        return r;
    }
    
    bytes_written = size;
    if(buf.size() == 65554){
        printf("find this case\n");
        int i;
        for(i=0; i<15199; i++){
            if(buf.substr(i, 0) != tmp.substr(i, 0)){
                printf("differ in tmp, i:%d, buf:%s, tmp:%s\n", i, buf.substr(i, 1).c_str(), tmp.substr(i, 1).c_str());
            }
        }
        for(; i<65536; i++){
            if(buf.substr(i, 1) != "\0"){
                printf("differ in off, i:%d, buf:%s\n", i, buf.substr(i, 1).c_str());
            }
        }
        for(; i<65554; i++){
            if(buf.substr(i, 1) != new_content.substr(i-65536, 1)){
                printf("differ in new_content, i:%d, buf:%s, new_content:%s\n", i, buf.substr(i, 1).c_str(), new_content.substr(i, 1).c_str());
            }
        }
    }
    // std::cout << "buf after: " << buf << std::endl;
    
    return r;

}

int yfs_client::unlink(inum parent,const char *name)
{
    int r = OK;

    /*
     * your code goes here.
     * note: you should remove the file using ec->remove,
     * and update the parent directory content.
     */

    return r;
}

