#include "datanode.h"
#include <arpa/inet.h>
#include "extent_client.h"
#include <unistd.h>
#include <algorithm>
#include "threader.h"

using namespace std;

void DataNode::prt(char *s){
  cout << "DataNode: " << s << endl;
  fflush(stdout);
}

void DataNode::periodSendHb(){
  while(true){
    if(SendHeartbeat() != true){
      prt((char *)"SendHeartbeat() return false");
    }
    sleep(1);
  }
}

int DataNode::init(const string &extent_dst, const string &namenode, const struct sockaddr_in *bindaddr) {
  ec = new extent_client(extent_dst);

  // Generate ID based on listen address
  id.set_ipaddr(inet_ntoa(bindaddr->sin_addr));
  id.set_hostname(GetHostname());
  id.set_datanodeuuid(GenerateUUID());
  id.set_xferport(ntohs(bindaddr->sin_port));
  id.set_infoport(0);
  id.set_ipcport(0);

  // Save namenode address and connect
  make_sockaddr(namenode.c_str(), &namenode_addr);
  if (!ConnectToNN()) {
    delete ec;
    ec = NULL;
    return -1;
  }

  // Register on namenode
  if (!RegisterOnNamenode()) {
    delete ec;
    ec = NULL;
    close(namenode_conn);
    namenode_conn = -1;
    return -1;
  }

  /* Add your initialization here */
  if (ec->put(1, "") != extent_protocol::OK)
    printf("error init root dir\n"); // XYB: init root dir
  
  NewThread(this, &DataNode::periodSendHb);
  return 0;
}

bool DataNode::ReadBlock(blockid_t bid, uint64_t offset, uint64_t len, string &buf) {
  /* Your lab4 part 2 code */
  char c[100];sprintf(c, "ReadBlock(bid:%u, offset:%lu)", bid, offset);prt(c);
  string content;
  int r;
  r = !(ec->read_block(bid,content));
  if (offset > content.size()){
    buf = "";
  }else{
    if(offset+len <= content.size())
      buf = content.substr(offset,len);
    else{
      buf = content.substr(offset, content.size());
      buf.resize(offset+len, '\0');
    }
  }
  return r;
}

bool DataNode::WriteBlock(blockid_t bid, uint64_t offset, uint64_t len, const string &buf) {
  /* Your lab4 part 2 code */
  char c[100];sprintf(c, "WriteBlock(bid:%u, offset:%lu, len:%lu)", bid, offset, len);prt(c);
  string content;
  int r;
  r = !(ec->read_block(bid,content));
  string wbuf = "";
  wbuf += content.substr(0,offset);
  wbuf += buf;
  wbuf += content.substr(offset+len);
  ec->write_block(bid,wbuf);
  return r;
}

