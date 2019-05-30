# lab5 File system, Spawn and Shell

## 开始之前

1. pull代码

   出现conflict的代码较多，通过compare changes保留lab3、lab4的实现功能，以及lab5新增的代码。

2. 注释

   将一些lab4中的代码注释掉

   ```c
   // kern/init.t @ i386_init()
   #else
   	// Touch all you want.
   	// ENV_CREATE(user_dumbfork, ENV_TYPE_USER);
   	// ENV_CREATE(user_yield, ENV_TYPE_USER);
   ```

   ```c
   // lib/exit.c @ exit()
   void
   exit(void)
   {
   	// close_all();
   	sys_env_destroy(0);
   }
   ```

3. 检测lab4的测试是否能通过

   > ./grade-lab4

![](.\lab4-grade.png)

4. 尝试`make grade`查看lab5的测试能否正常

![](.\lab5-grade-0.png)

至此准备工作完成。



## The File System

### Disk Access

#### Exercise 1.

#### Question 1.



### The Block Cache

#### Exercise 2.

#### Challenge!



### The Block Bitmap

#### Exercise 3.



### File Operations

#### Exercise 4.



### The file system interface

#### Exercise 5.



#### Exercise 6.



### Spawning Processes

#### Exercise 7.



#### Challenge!

#### Challenge!



### Sharing library state across fork and spawn

#### Exercise 8.



### The keyboard interface

#### Exercise 9.



#### The Shell

#### Exercise 10.







