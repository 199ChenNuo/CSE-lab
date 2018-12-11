#include "inode_manager.h"

// disk layer -----------------------------------------

disk::disk()
{
  bzero(blocks, sizeof(blocks));
}

void
disk::read_block(blockid_t id, char *buf)
{
  if (id < 0 || id >= BLOCK_NUM || buf == NULL)
    return;

  memcpy(buf, blocks[id], BLOCK_SIZE);
}

void
disk::write_block(blockid_t id, const char *buf)
{
  if (id < 0 || id >= BLOCK_NUM || buf == NULL)
    return;

  memcpy(blocks[id], buf, BLOCK_SIZE);
}

// block layer -----------------------------------------

void block_manager::prt(char *s){
  std::cout << "block_manager: " << s << std::endl;
  fflush(stdout);
}
// Allocate a free disk block.
blockid_t
block_manager::alloc_block()
{
  /*
   * your code goes here.
   * note: you should mark the corresponding bit in block bitmap when alloc.
   * you need to think about which block you can start to be allocated.
   */
  prt((char *)"alloc block");
  // uint32_t blockno, bitmapno;
  // char bitmap[BLOCK_SIZE];
  // int mask;
  // int char_idx, bit, bit_idx;

  // mask = 0x1;
  // for(bitmapno=2; bitmapno<BBLOCK(BLOCK_NUM); bitmapno++){
  //   read_block(bitmapno, bitmap);
  //   for(char_idx=0; char_idx<BLOCK_SIZE; char_idx++){
  //     bit = bitmap[char_idx];
  //     if(bit != 0xf){
  //       for(bit_idx=0; bit_idx<BYTE_SIZE; bit_idx++){
  //         if(! (bit & (mask << bit_idx))){
  //           bitmap[char_idx] = bit | (mask << bit_idx);
  //           write_block(bitmapno, bitmap);
  //           prt((char *)"find block");
  //           return bitmapno*BPB + char_idx*BYTE_SIZE + bit_idx;
  //         }
  //       }
  //     }
  //   }
  // }
  for (int i=IBLOCK(INODE_NUM,BLOCK_NUM)+1;i<BLOCK_NUM;i++){
    if (using_blocks[i]==0){
      using_blocks[i]=1;
      char c[100];sprintf(c, "alloc bids is:%d", i);prt(c);
      return i;
    }
  }
  return -1;
  prt((char *)"not find block");
  return 0;
}

void
block_manager::free_block(uint32_t id)
{
  /* 
   * your code goes here.
   * note: you should unmark the corresponding bit in the block bitmap when free.
   */
  char c[100];
  sprintf(c, "free block: id:%d", id);
  prt((char *)c);
  
  // uint32_t bitmapno;
  // char bitmap[BLOCK_SIZE];
  // int mask, char_pos, bit_pos, char_value;

  // mask = 0x1;
  // char_pos = (id%BPB)/BYTE_SIZE;
  // bit_pos = (id%BPB)%BYTE_SIZE;
 
  // bitmapno = BBLOCK(id);
  // read_block(bitmapno, bitmap);
  
  // char_value = bitmap[char_pos];
  // char_value = char_value & ~(mask << bit_pos);
  // bitmap[char_pos] = char_value;
  // write_block(bitmapno, bitmap);

  using_blocks[id] = 0;

  prt((char *)"end of free block");
  return;
}

// The layout of disk should be like this:
// |<-sb->|<-free block bitmap->|<-inode table->|<-data->|
block_manager::block_manager()
{
  d = new disk();

  // format the disk
  sb.size = BLOCK_SIZE * BLOCK_NUM;
  sb.nblocks = BLOCK_NUM;
  sb.ninodes = INODE_NUM;

  for (int i=0;i<BLOCK_NUM;i++){
    using_blocks[i] = 0;
  }
}

void
block_manager::read_block(uint32_t id, char *buf)
{
  d->read_block(id, buf);
}

void
block_manager::write_block(uint32_t id, const char *buf)
{
  d->write_block(id, buf);
}

// inode layer -----------------------------------------
void inode_manager::prt(char *s){
  std::cout << "\tinode manager: " << s << std::endl;
  fflush(stdout);
}

inode_manager::inode_manager()
{
  bm = new block_manager();
  uint32_t root_dir = alloc_inode(extent_protocol::T_DIR);
  if (root_dir != 1) {
    printf("\tim: error! alloc first inode %d, should be 1\n", root_dir);
    exit(0);
  }
}

/* Create a new file.
 * Return its inum. */
uint32_t
inode_manager::alloc_inode(uint32_t type)
{
  /* 
   * your code goes here.
   * note: the normal inode block should begin from the 2nd inode block.
   * the 1st is used for root_dir, see inode_manager::inode_manager().
   */
  prt((char *)"alloc inode");
  uint32_t inum;
  char buf[BLOCK_SIZE];
  struct inode *inode;

  if( (type != extent_protocol::T_DIR) && (type != extent_protocol::T_FILE) && (type != extent_protocol::T_LINK)){
    return -1;
  }
  for(inum = 1; inum < bm->sb.ninodes; inum++){
    bm->read_block(IBLOCK(inum, bm->sb.nblocks), buf);
    inode = (struct inode*)buf + (inum - 1)%IPB;
    if(inode->type == 0){
      inode->type = type;
      inode->size = 0;
      inode->atime = inode->mtime = inode->ctime = (unsigned int)time(0);

      put_inode(inum, inode);

      prt((char *)"end of alloc inode");
      return inum;
    }
  }
  prt((char *)"end of alloc inode");
  return 1;
}

void
inode_manager::free_inode(uint32_t inum)
{
  /* 
   * your code goes here.
   * note: you need to check if the inode is already a freed one;
   * if not, clear it, and remember to write back to disk.
   */
  prt((char *)"free inode");
  struct inode *ino;
  
  ino = get_inode(inum);
  ino->type=0;
  put_inode(inum, ino);
  free(ino);
  prt((char *)"end of free inode");
  return;
}


/* Return an inode structure by inum, NULL otherwise.
 * Caller should release the memory. */
struct inode* 
inode_manager::get_inode(uint32_t inum)
{
  prt((char *)"get inode");

  struct inode *ino, *ino_disk;
  char buf[BLOCK_SIZE];

  if (inum < 0 || inum >= INODE_NUM) {
    printf("\tim: inum out of range\n");
    return NULL;
  }

  bm->read_block(IBLOCK(inum, bm->sb.nblocks), buf);

  ino_disk = (struct inode*)buf + (inum-1)%IPB;
  if (ino_disk->type == 0) {
    prt((char *)"inode not exist");
    return NULL;
  }

  ino = (struct inode*)malloc(sizeof(struct inode));
  *ino = *ino_disk;
  prt((char *)"end of get inode");
  return ino;
}

void
inode_manager::put_inode(uint32_t inum, struct inode *ino)
{
  char buf[BLOCK_SIZE];
  struct inode *ino_disk;

  prt((char *)"put inode");
  if (ino == NULL)
    return;

  ino->mtime = time(0);
  ino->ctime = time(0);
  bm->read_block(IBLOCK(inum, bm->sb.nblocks), buf);
  ino_disk = (struct inode*)buf + (inum-1)%IPB;
  *ino_disk = *ino;
  bm->write_block(IBLOCK(inum, bm->sb.nblocks), buf);
  prt((char *)"end of put inode");
}

#define MIN(a,b) ((a)<(b) ? (a) : (b))

/* Get all the data of a file by inum. 
 * Return alloced data, should be freed by caller. */
void
inode_manager::read_file(uint32_t inum, char **buf_out, int *size)
{
  /*
   * your code goes here.
   * note: read blocks related to inode number inum,
   * and copy them to buf_Out
   */
  prt((char *)"read file");
  struct inode *ino;
  blockid_t bidx;
  blockid_t ndir_buf[BLOCK_SIZE / sizeof(blockid_t)];
  unsigned int bsize;
  int has_tail;
  char buf[BLOCK_SIZE];

  ino = get_inode(inum);
  ino->atime = (unsigned int)time(NULL);
  *size = ino->size;
  bsize = (ino->size / BLOCK_SIZE);
  has_tail = (ino->size%BLOCK_SIZE > 0) ? 1 : 0;

  *buf_out = (char *)malloc(ino->size);
  if(bsize+has_tail > NDIRECT){
    for(bidx=0; bidx<NDIRECT; bidx++){
      bm->read_block(ino->blocks[bidx], *buf_out + bidx*BLOCK_SIZE);
    }
    bm->read_block(ino->blocks[NDIRECT], (char *)ndir_buf);
    for(bidx=NDIRECT; bidx<bsize; bidx++){
      bm->read_block(ndir_buf[bidx-NDIRECT], *buf_out + bidx*BLOCK_SIZE);
    }
    if(has_tail){
      bm->read_block(ndir_buf[bsize - NDIRECT], buf);
      memcpy(*buf_out + bsize * BLOCK_SIZE, buf, ino->size % BLOCK_SIZE);
    }
  }else{
    for(bidx=0; bidx<bsize; bidx++){
      bm->read_block(ino->blocks[bidx], *buf_out + bidx*BLOCK_SIZE);
    }
    if(has_tail){
      bm->read_block(ino->blocks[bsize], buf);
      memcpy(*buf_out + bsize * BLOCK_SIZE, buf, ino->size % BLOCK_SIZE);
    }
  }
  
  put_inode(inum, ino);
  free(ino);
  prt((char *)"end of read file");
  return;
}

/* alloc/free blocks if needed */
void
inode_manager::write_file(uint32_t inum, const char *buf, int size)
{
  /*
   * your code goes here.
   * note: write buf to blocks of inode inum.
   * you need to consider the situation when the size of buf 
   * is larger or smaller than the size of original inode
   */
  prt((char *)"write file");
  struct inode *ino;
  int old_bsize, new_bsize, has_tail;
  int i;
  char tail_buf[BLOCK_SIZE];
  blockid_t ndir_buf[BLOCK_SIZE / sizeof(blockid_t)];

  ino = get_inode(inum);

  if(!buf || !ino){
    printf("im::write_file() ERROR, invalid inum or buf\n");
    return;
  }
  int maxFileSize = MAXFILE*BLOCK_SIZE;
  if(size >= maxFileSize){
    printf("im::write_file() file bigger than maxfile size\n");
    return;
  }
  old_bsize = (ino->size + BLOCK_SIZE - 1) / BLOCK_SIZE;
  new_bsize = size / BLOCK_SIZE;
  has_tail = (size%BLOCK_SIZE == 0) ? 0 : 1;

  if(new_bsize+has_tail > NDIRECT){
    if(new_bsize+has_tail > old_bsize){

      // new > old > ndirect
      if(old_bsize > NDIRECT){
        bm->read_block(ino->blocks[NDIRECT], (char *)ndir_buf);
        for(i=old_bsize; i<new_bsize+has_tail; i++){
          ndir_buf[i-NDIRECT] = bm->alloc_block();
        }
        bm->write_block(ino->blocks[NDIRECT], (char *)ndir_buf);

      // new > ndirect > old
      }else{
        for(i=old_bsize; i<NDIRECT; i++){
          ino->blocks[i] = bm->alloc_block();
        }
        ino->blocks[NDIRECT] = bm->alloc_block();
        for(; i<new_bsize+has_tail; i++){
          ndir_buf[i-NDIRECT] = bm->alloc_block();
        }
        bm->write_block(ino->blocks[NDIRECT], (char *)ndir_buf);
      }
    
    // old > new > ndirect
    }else{
      bm->read_block(ino->blocks[NDIRECT], (char *)ndir_buf);
      for(i=new_bsize+has_tail; i<old_bsize; i++){
        bm->free_block(ndir_buf[i-NDIRECT]);
      }
    }
  }else{
    
    // ndirect > new > old
    if(new_bsize+has_tail > old_bsize){
      for(i=old_bsize; i<new_bsize+has_tail; i++){
        ino->blocks[i] = bm->alloc_block();
      }
    }else{

      // ndirect > old > new
      if(old_bsize < NDIRECT){
        for(i=new_bsize+has_tail; i<old_bsize; i++){
          bm->free_block(ino->blocks[i]);
        }
      }

      // old > ndirect > new
      else{
        for(i=new_bsize+has_tail; i<NDIRECT; i++){
          bm->free_block(ino->blocks[i]);
        }
        bm->read_block(ino->blocks[NDIRECT], (char *)ndir_buf);
        for(; i<old_bsize; i++){
          bm->free_block(ndir_buf[i-NDIRECT]);
        }
        bm->free_block(ino->blocks[NDIRECT]);
      }
    }
  }

  if(new_bsize+has_tail > NDIRECT){
    for(i=0; i<NDIRECT; i++){
      bm->write_block(ino->blocks[i], buf+i*BLOCK_SIZE);
    }
    for(; i<new_bsize; i++){
      bm->write_block(ndir_buf[i-NDIRECT], buf+i*BLOCK_SIZE);
    }
    if(has_tail){
      memcpy(tail_buf, buf + new_bsize * BLOCK_SIZE, size%BLOCK_SIZE);
     
      bm->write_block(ndir_buf[new_bsize - NDIRECT], tail_buf);
      
    }
  }else{
    for(i=0; i<new_bsize; i++){
      bm->write_block(ino->blocks[i], buf+i*BLOCK_SIZE);
    }
    if(has_tail){
      memcpy(tail_buf, buf + new_bsize * BLOCK_SIZE, size%BLOCK_SIZE);
      bm->write_block(ino->blocks[new_bsize], tail_buf);
    }
  }

  ino->size = size;
  ino->mtime = ino->ctime = (unsigned int)time(NULL);
  put_inode(inum, ino);
 
  
  free(ino);
  prt((char *)"end of write file");
  
  return;

}


void
inode_manager::getattr(uint32_t inum, extent_protocol::attr &a)
{
  /*
   * your code goes here.
   * note: get the attributes of inode inum.
   * you can refer to "struct attr" in extent_protocol.h
   */
  prt((char *)"getattr");
  inode_t *inode;
 

  inode = get_inode(inum);
  if(inode == NULL){
    printf("\tim: getattr: \t error when get inode\n");
    return;
  }

  a.type = inode->type;
  a.atime = inode->atime;
  a.mtime = inode->mtime;
  a.ctime = inode->ctime;
  a.size = inode->size;

  free(inode);
  prt((char *)"end of getattr");
  return;
}

void
inode_manager::remove_file(uint32_t inum)
{
  /*
   * your code goes here
   * note: you need to consider about both the data block and inode of the file
   */
  prt((char *)"remove file");
  struct inode *ino;
  blockid_t ndir_buf[BLOCK_SIZE / sizeof(blockid_t)];
  int bsize, bidx;

  ino = get_inode(inum);
  bsize = (ino->size + BLOCK_SIZE - 1)/BLOCK_SIZE;

  // change from > to >= in 11/13
  if(bsize >= NDIRECT){
    bm->read_block(ino->blocks[NDIRECT], (char *)ndir_buf);
    for(bidx=0; bidx<NDIRECT; bidx++){
      bm->free_block(ino->blocks[bidx]);
    }
    for(; bidx<bsize; bidx++){
      bm->free_block(ndir_buf[bidx-NDIRECT]);
    }
    // added on 11/13
	bm->free_block(ino->blocks[NDIRECT]);
  }else{
    for(bidx=0; bidx<bsize; bidx++){
      bm->free_block(ino->blocks[bidx]);
    }
  }
  free_inode(inum);
  prt((char *)"end of remove file");
  return;
}

void
inode_manager::append_block(uint32_t inum, blockid_t &bid)
{
  /*
   * your code goes here.
   */
  char c[100];
  sprintf(c, "append_block: inum:%d", inum);
  prt(c);

  struct inode * ino = get_inode(inum);
  bid = bm->alloc_block();

  long bsize = (ino->size + BLOCK_SIZE - 1) / BLOCK_SIZE;
  if(bsize < NDIRECT){
    ino->blocks[bsize] = bid;
  } else {
    if(bsize == NDIRECT){
      ino->blocks[NDIRECT] = bm->alloc_block();
    }
    blockid_t ndir_buf[BLOCK_SIZE / sizeof(blockid_t)];
    bm->read_block(ino->blocks[NDIRECT], (char *)ndir_buf);
    ndir_buf[bsize-NDIRECT] = bid;
    bm->write_block(ino->blocks[NDIRECT], (char *)ndir_buf);
  }
  ino->size += BLOCK_SIZE;
  put_inode(inum, ino);
  prt((char *)"end of append_block");
}

void
inode_manager::get_block_ids(uint32_t inum, std::list<blockid_t> &block_ids)
{
  /*
   * your code goes here.
   */
  char c[100];
  sprintf(c, "get block ids, inum:%d",inum);
  prt(c);

  struct inode* ino = get_inode(inum);
  long bsize = (ino->size + BLOCK_SIZE - 1) / BLOCK_SIZE;

  if(bsize < NDIRECT){
    for(int i=0; i<bsize; i++){
      block_ids.push_back(ino->blocks[i]);
    }
  } else {
    blockid_t ndir_buf[BLOCK_SIZE / sizeof(blockid_t)];
    for(int i=0; i<NDIRECT; i++){
      block_ids.push_back(ino->blocks[i]);
    }
    bm->read_block(ino->blocks[NDIRECT], (char *)ndir_buf);
    for(int i=NDIRECT; i<bsize; i++){
      block_ids.push_back(ndir_buf[i-NDIRECT]);
    }
  }
  prt((char *)"end of get block ids");
}

void
inode_manager::read_block(blockid_t id, char buf[BLOCK_SIZE])
{
  /*
   * your code goes here.
   */
  prt((char *)"read block");
  bm->read_block(id, buf);
}

void
inode_manager::write_block(blockid_t id, const char buf[BLOCK_SIZE])
{
  /*
   * your code goes here.
   */
  prt((char *)"write block");
  bm->write_block(id, buf);
}

void
inode_manager::complete(uint32_t inum, uint32_t size)
{
  /*
   * your code goes here.
   */
  prt((char *)"complete");

  struct inode * ino = get_inode(inum);
  ino->size = size;
  put_inode(inum, ino);
}
