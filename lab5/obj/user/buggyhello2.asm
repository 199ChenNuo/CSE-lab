
obj/user/buggyhello2.debug:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs(hello, 1024*1024);
  800039:	68 00 00 10 00       	push   $0x100000
  80003e:	ff 35 00 20 80 00    	pushl  0x802000
  800044:	e8 60 00 00 00       	call   8000a9 <sys_cputs>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800056:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  800059:	e8 c9 00 00 00       	call   800127 <sys_getenvid>
  80005e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800063:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800069:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006e:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800073:	85 db                	test   %ebx,%ebx
  800075:	7e 07                	jle    80007e <libmain+0x30>
		binaryname = argv[0];
  800077:	8b 06                	mov    (%esi),%eax
  800079:	a3 04 20 80 00       	mov    %eax,0x802004

	// call user main routine
	umain(argc, argv);
  80007e:	83 ec 08             	sub    $0x8,%esp
  800081:	56                   	push   %esi
  800082:	53                   	push   %ebx
  800083:	e8 ab ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800088:	e8 0a 00 00 00       	call   800097 <exit>
}
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800093:	5b                   	pop    %ebx
  800094:	5e                   	pop    %esi
  800095:	5d                   	pop    %ebp
  800096:	c3                   	ret    

00800097 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800097:	55                   	push   %ebp
  800098:	89 e5                	mov    %esp,%ebp
  80009a:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80009d:	6a 00                	push   $0x0
  80009f:	e8 42 00 00 00       	call   8000e6 <sys_env_destroy>
}
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	c9                   	leave  
  8000a8:	c3                   	ret    

008000a9 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a9:	55                   	push   %ebp
  8000aa:	89 e5                	mov    %esp,%ebp
  8000ac:	57                   	push   %edi
  8000ad:	56                   	push   %esi
  8000ae:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000af:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000ba:	89 c3                	mov    %eax,%ebx
  8000bc:	89 c7                	mov    %eax,%edi
  8000be:	89 c6                	mov    %eax,%esi
  8000c0:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c2:	5b                   	pop    %ebx
  8000c3:	5e                   	pop    %esi
  8000c4:	5f                   	pop    %edi
  8000c5:	5d                   	pop    %ebp
  8000c6:	c3                   	ret    

008000c7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c7:	55                   	push   %ebp
  8000c8:	89 e5                	mov    %esp,%ebp
  8000ca:	57                   	push   %edi
  8000cb:	56                   	push   %esi
  8000cc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d7:	89 d1                	mov    %edx,%ecx
  8000d9:	89 d3                	mov    %edx,%ebx
  8000db:	89 d7                	mov    %edx,%edi
  8000dd:	89 d6                	mov    %edx,%esi
  8000df:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e1:	5b                   	pop    %ebx
  8000e2:	5e                   	pop    %esi
  8000e3:	5f                   	pop    %edi
  8000e4:	5d                   	pop    %ebp
  8000e5:	c3                   	ret    

008000e6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e6:	55                   	push   %ebp
  8000e7:	89 e5                	mov    %esp,%ebp
  8000e9:	57                   	push   %edi
  8000ea:	56                   	push   %esi
  8000eb:	53                   	push   %ebx
  8000ec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f7:	b8 03 00 00 00       	mov    $0x3,%eax
  8000fc:	89 cb                	mov    %ecx,%ebx
  8000fe:	89 cf                	mov    %ecx,%edi
  800100:	89 ce                	mov    %ecx,%esi
  800102:	cd 30                	int    $0x30
	if (check && ret > 0)
  800104:	85 c0                	test   %eax,%eax
  800106:	7f 08                	jg     800110 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800108:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010b:	5b                   	pop    %ebx
  80010c:	5e                   	pop    %esi
  80010d:	5f                   	pop    %edi
  80010e:	5d                   	pop    %ebp
  80010f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	50                   	push   %eax
  800114:	6a 03                	push   $0x3
  800116:	68 38 11 80 00       	push   $0x801138
  80011b:	6a 4c                	push   $0x4c
  80011d:	68 55 11 80 00       	push   $0x801155
  800122:	e8 70 02 00 00       	call   800397 <_panic>

00800127 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800127:	55                   	push   %ebp
  800128:	89 e5                	mov    %esp,%ebp
  80012a:	57                   	push   %edi
  80012b:	56                   	push   %esi
  80012c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80012d:	ba 00 00 00 00       	mov    $0x0,%edx
  800132:	b8 02 00 00 00       	mov    $0x2,%eax
  800137:	89 d1                	mov    %edx,%ecx
  800139:	89 d3                	mov    %edx,%ebx
  80013b:	89 d7                	mov    %edx,%edi
  80013d:	89 d6                	mov    %edx,%esi
  80013f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800141:	5b                   	pop    %ebx
  800142:	5e                   	pop    %esi
  800143:	5f                   	pop    %edi
  800144:	5d                   	pop    %ebp
  800145:	c3                   	ret    

00800146 <sys_yield>:

void
sys_yield(void)
{
  800146:	55                   	push   %ebp
  800147:	89 e5                	mov    %esp,%ebp
  800149:	57                   	push   %edi
  80014a:	56                   	push   %esi
  80014b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80014c:	ba 00 00 00 00       	mov    $0x0,%edx
  800151:	b8 0b 00 00 00       	mov    $0xb,%eax
  800156:	89 d1                	mov    %edx,%ecx
  800158:	89 d3                	mov    %edx,%ebx
  80015a:	89 d7                	mov    %edx,%edi
  80015c:	89 d6                	mov    %edx,%esi
  80015e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800160:	5b                   	pop    %ebx
  800161:	5e                   	pop    %esi
  800162:	5f                   	pop    %edi
  800163:	5d                   	pop    %ebp
  800164:	c3                   	ret    

00800165 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800165:	55                   	push   %ebp
  800166:	89 e5                	mov    %esp,%ebp
  800168:	57                   	push   %edi
  800169:	56                   	push   %esi
  80016a:	53                   	push   %ebx
  80016b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80016e:	be 00 00 00 00       	mov    $0x0,%esi
  800173:	8b 55 08             	mov    0x8(%ebp),%edx
  800176:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800179:	b8 04 00 00 00       	mov    $0x4,%eax
  80017e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800181:	89 f7                	mov    %esi,%edi
  800183:	cd 30                	int    $0x30
	if (check && ret > 0)
  800185:	85 c0                	test   %eax,%eax
  800187:	7f 08                	jg     800191 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800189:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80018c:	5b                   	pop    %ebx
  80018d:	5e                   	pop    %esi
  80018e:	5f                   	pop    %edi
  80018f:	5d                   	pop    %ebp
  800190:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800191:	83 ec 0c             	sub    $0xc,%esp
  800194:	50                   	push   %eax
  800195:	6a 04                	push   $0x4
  800197:	68 38 11 80 00       	push   $0x801138
  80019c:	6a 4c                	push   $0x4c
  80019e:	68 55 11 80 00       	push   $0x801155
  8001a3:	e8 ef 01 00 00       	call   800397 <_panic>

008001a8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001a8:	55                   	push   %ebp
  8001a9:	89 e5                	mov    %esp,%ebp
  8001ab:	57                   	push   %edi
  8001ac:	56                   	push   %esi
  8001ad:	53                   	push   %ebx
  8001ae:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b7:	b8 05 00 00 00       	mov    $0x5,%eax
  8001bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001bf:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001c2:	8b 75 18             	mov    0x18(%ebp),%esi
  8001c5:	cd 30                	int    $0x30
	if (check && ret > 0)
  8001c7:	85 c0                	test   %eax,%eax
  8001c9:	7f 08                	jg     8001d3 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ce:	5b                   	pop    %ebx
  8001cf:	5e                   	pop    %esi
  8001d0:	5f                   	pop    %edi
  8001d1:	5d                   	pop    %ebp
  8001d2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d3:	83 ec 0c             	sub    $0xc,%esp
  8001d6:	50                   	push   %eax
  8001d7:	6a 05                	push   $0x5
  8001d9:	68 38 11 80 00       	push   $0x801138
  8001de:	6a 4c                	push   $0x4c
  8001e0:	68 55 11 80 00       	push   $0x801155
  8001e5:	e8 ad 01 00 00       	call   800397 <_panic>

008001ea <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	57                   	push   %edi
  8001ee:	56                   	push   %esi
  8001ef:	53                   	push   %ebx
  8001f0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8001fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001fe:	b8 06 00 00 00       	mov    $0x6,%eax
  800203:	89 df                	mov    %ebx,%edi
  800205:	89 de                	mov    %ebx,%esi
  800207:	cd 30                	int    $0x30
	if (check && ret > 0)
  800209:	85 c0                	test   %eax,%eax
  80020b:	7f 08                	jg     800215 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80020d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800210:	5b                   	pop    %ebx
  800211:	5e                   	pop    %esi
  800212:	5f                   	pop    %edi
  800213:	5d                   	pop    %ebp
  800214:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800215:	83 ec 0c             	sub    $0xc,%esp
  800218:	50                   	push   %eax
  800219:	6a 06                	push   $0x6
  80021b:	68 38 11 80 00       	push   $0x801138
  800220:	6a 4c                	push   $0x4c
  800222:	68 55 11 80 00       	push   $0x801155
  800227:	e8 6b 01 00 00       	call   800397 <_panic>

0080022c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	57                   	push   %edi
  800230:	56                   	push   %esi
  800231:	53                   	push   %ebx
  800232:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800235:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023a:	8b 55 08             	mov    0x8(%ebp),%edx
  80023d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800240:	b8 08 00 00 00       	mov    $0x8,%eax
  800245:	89 df                	mov    %ebx,%edi
  800247:	89 de                	mov    %ebx,%esi
  800249:	cd 30                	int    $0x30
	if (check && ret > 0)
  80024b:	85 c0                	test   %eax,%eax
  80024d:	7f 08                	jg     800257 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80024f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800252:	5b                   	pop    %ebx
  800253:	5e                   	pop    %esi
  800254:	5f                   	pop    %edi
  800255:	5d                   	pop    %ebp
  800256:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	50                   	push   %eax
  80025b:	6a 08                	push   $0x8
  80025d:	68 38 11 80 00       	push   $0x801138
  800262:	6a 4c                	push   $0x4c
  800264:	68 55 11 80 00       	push   $0x801155
  800269:	e8 29 01 00 00       	call   800397 <_panic>

0080026e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80026e:	55                   	push   %ebp
  80026f:	89 e5                	mov    %esp,%ebp
  800271:	57                   	push   %edi
  800272:	56                   	push   %esi
  800273:	53                   	push   %ebx
  800274:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800277:	bb 00 00 00 00       	mov    $0x0,%ebx
  80027c:	8b 55 08             	mov    0x8(%ebp),%edx
  80027f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800282:	b8 09 00 00 00       	mov    $0x9,%eax
  800287:	89 df                	mov    %ebx,%edi
  800289:	89 de                	mov    %ebx,%esi
  80028b:	cd 30                	int    $0x30
	if (check && ret > 0)
  80028d:	85 c0                	test   %eax,%eax
  80028f:	7f 08                	jg     800299 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800291:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800294:	5b                   	pop    %ebx
  800295:	5e                   	pop    %esi
  800296:	5f                   	pop    %edi
  800297:	5d                   	pop    %ebp
  800298:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	50                   	push   %eax
  80029d:	6a 09                	push   $0x9
  80029f:	68 38 11 80 00       	push   $0x801138
  8002a4:	6a 4c                	push   $0x4c
  8002a6:	68 55 11 80 00       	push   $0x801155
  8002ab:	e8 e7 00 00 00       	call   800397 <_panic>

008002b0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	57                   	push   %edi
  8002b4:	56                   	push   %esi
  8002b5:	53                   	push   %ebx
  8002b6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002be:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002c9:	89 df                	mov    %ebx,%edi
  8002cb:	89 de                	mov    %ebx,%esi
  8002cd:	cd 30                	int    $0x30
	if (check && ret > 0)
  8002cf:	85 c0                	test   %eax,%eax
  8002d1:	7f 08                	jg     8002db <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d6:	5b                   	pop    %ebx
  8002d7:	5e                   	pop    %esi
  8002d8:	5f                   	pop    %edi
  8002d9:	5d                   	pop    %ebp
  8002da:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002db:	83 ec 0c             	sub    $0xc,%esp
  8002de:	50                   	push   %eax
  8002df:	6a 0a                	push   $0xa
  8002e1:	68 38 11 80 00       	push   $0x801138
  8002e6:	6a 4c                	push   $0x4c
  8002e8:	68 55 11 80 00       	push   $0x801155
  8002ed:	e8 a5 00 00 00       	call   800397 <_panic>

008002f2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002f2:	55                   	push   %ebp
  8002f3:	89 e5                	mov    %esp,%ebp
  8002f5:	57                   	push   %edi
  8002f6:	56                   	push   %esi
  8002f7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8002fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002fe:	b8 0c 00 00 00       	mov    $0xc,%eax
  800303:	be 00 00 00 00       	mov    $0x0,%esi
  800308:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80030b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80030e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800310:	5b                   	pop    %ebx
  800311:	5e                   	pop    %esi
  800312:	5f                   	pop    %edi
  800313:	5d                   	pop    %ebp
  800314:	c3                   	ret    

00800315 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	57                   	push   %edi
  800319:	56                   	push   %esi
  80031a:	53                   	push   %ebx
  80031b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80031e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800323:	8b 55 08             	mov    0x8(%ebp),%edx
  800326:	b8 0d 00 00 00       	mov    $0xd,%eax
  80032b:	89 cb                	mov    %ecx,%ebx
  80032d:	89 cf                	mov    %ecx,%edi
  80032f:	89 ce                	mov    %ecx,%esi
  800331:	cd 30                	int    $0x30
	if (check && ret > 0)
  800333:	85 c0                	test   %eax,%eax
  800335:	7f 08                	jg     80033f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800337:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80033a:	5b                   	pop    %ebx
  80033b:	5e                   	pop    %esi
  80033c:	5f                   	pop    %edi
  80033d:	5d                   	pop    %ebp
  80033e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	50                   	push   %eax
  800343:	6a 0d                	push   $0xd
  800345:	68 38 11 80 00       	push   $0x801138
  80034a:	6a 4c                	push   $0x4c
  80034c:	68 55 11 80 00       	push   $0x801155
  800351:	e8 41 00 00 00       	call   800397 <_panic>

00800356 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	57                   	push   %edi
  80035a:	56                   	push   %esi
  80035b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80035c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800361:	8b 55 08             	mov    0x8(%ebp),%edx
  800364:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800367:	b8 0e 00 00 00       	mov    $0xe,%eax
  80036c:	89 df                	mov    %ebx,%edi
  80036e:	89 de                	mov    %ebx,%esi
  800370:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800372:	5b                   	pop    %ebx
  800373:	5e                   	pop    %esi
  800374:	5f                   	pop    %edi
  800375:	5d                   	pop    %ebp
  800376:	c3                   	ret    

00800377 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800377:	55                   	push   %ebp
  800378:	89 e5                	mov    %esp,%ebp
  80037a:	57                   	push   %edi
  80037b:	56                   	push   %esi
  80037c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80037d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800382:	8b 55 08             	mov    0x8(%ebp),%edx
  800385:	b8 0f 00 00 00       	mov    $0xf,%eax
  80038a:	89 cb                	mov    %ecx,%ebx
  80038c:	89 cf                	mov    %ecx,%edi
  80038e:	89 ce                	mov    %ecx,%esi
  800390:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800392:	5b                   	pop    %ebx
  800393:	5e                   	pop    %esi
  800394:	5f                   	pop    %edi
  800395:	5d                   	pop    %ebp
  800396:	c3                   	ret    

00800397 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800397:	55                   	push   %ebp
  800398:	89 e5                	mov    %esp,%ebp
  80039a:	56                   	push   %esi
  80039b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80039c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80039f:	8b 35 04 20 80 00    	mov    0x802004,%esi
  8003a5:	e8 7d fd ff ff       	call   800127 <sys_getenvid>
  8003aa:	83 ec 0c             	sub    $0xc,%esp
  8003ad:	ff 75 0c             	pushl  0xc(%ebp)
  8003b0:	ff 75 08             	pushl  0x8(%ebp)
  8003b3:	56                   	push   %esi
  8003b4:	50                   	push   %eax
  8003b5:	68 64 11 80 00       	push   $0x801164
  8003ba:	e8 b3 00 00 00       	call   800472 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003bf:	83 c4 18             	add    $0x18,%esp
  8003c2:	53                   	push   %ebx
  8003c3:	ff 75 10             	pushl  0x10(%ebp)
  8003c6:	e8 56 00 00 00       	call   800421 <vcprintf>
	cprintf("\n");
  8003cb:	c7 04 24 2c 11 80 00 	movl   $0x80112c,(%esp)
  8003d2:	e8 9b 00 00 00       	call   800472 <cprintf>
  8003d7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003da:	cc                   	int3   
  8003db:	eb fd                	jmp    8003da <_panic+0x43>

008003dd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003dd:	55                   	push   %ebp
  8003de:	89 e5                	mov    %esp,%ebp
  8003e0:	53                   	push   %ebx
  8003e1:	83 ec 04             	sub    $0x4,%esp
  8003e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003e7:	8b 13                	mov    (%ebx),%edx
  8003e9:	8d 42 01             	lea    0x1(%edx),%eax
  8003ec:	89 03                	mov    %eax,(%ebx)
  8003ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003f1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003f5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003fa:	74 09                	je     800405 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003fc:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800400:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800403:	c9                   	leave  
  800404:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800405:	83 ec 08             	sub    $0x8,%esp
  800408:	68 ff 00 00 00       	push   $0xff
  80040d:	8d 43 08             	lea    0x8(%ebx),%eax
  800410:	50                   	push   %eax
  800411:	e8 93 fc ff ff       	call   8000a9 <sys_cputs>
		b->idx = 0;
  800416:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80041c:	83 c4 10             	add    $0x10,%esp
  80041f:	eb db                	jmp    8003fc <putch+0x1f>

00800421 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800421:	55                   	push   %ebp
  800422:	89 e5                	mov    %esp,%ebp
  800424:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80042a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800431:	00 00 00 
	b.cnt = 0;
  800434:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80043b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80043e:	ff 75 0c             	pushl  0xc(%ebp)
  800441:	ff 75 08             	pushl  0x8(%ebp)
  800444:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80044a:	50                   	push   %eax
  80044b:	68 dd 03 80 00       	push   $0x8003dd
  800450:	e8 4a 01 00 00       	call   80059f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800455:	83 c4 08             	add    $0x8,%esp
  800458:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80045e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800464:	50                   	push   %eax
  800465:	e8 3f fc ff ff       	call   8000a9 <sys_cputs>

	return b.cnt;
}
  80046a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800470:	c9                   	leave  
  800471:	c3                   	ret    

00800472 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800472:	55                   	push   %ebp
  800473:	89 e5                	mov    %esp,%ebp
  800475:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800478:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80047b:	50                   	push   %eax
  80047c:	ff 75 08             	pushl  0x8(%ebp)
  80047f:	e8 9d ff ff ff       	call   800421 <vcprintf>
	va_end(ap);

	return cnt;
}
  800484:	c9                   	leave  
  800485:	c3                   	ret    

00800486 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
  800489:	57                   	push   %edi
  80048a:	56                   	push   %esi
  80048b:	53                   	push   %ebx
  80048c:	83 ec 1c             	sub    $0x1c,%esp
  80048f:	89 c6                	mov    %eax,%esi
  800491:	89 d7                	mov    %edx,%edi
  800493:	8b 45 08             	mov    0x8(%ebp),%eax
  800496:	8b 55 0c             	mov    0xc(%ebp),%edx
  800499:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80049c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80049f:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a2:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  8004a5:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8004a9:	74 2c                	je     8004d7 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ae:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004bb:	39 c2                	cmp    %eax,%edx
  8004bd:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8004c0:	73 43                	jae    800505 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004c2:	83 eb 01             	sub    $0x1,%ebx
  8004c5:	85 db                	test   %ebx,%ebx
  8004c7:	7e 6c                	jle    800535 <printnum+0xaf>
			putch(padc, putdat);
  8004c9:	83 ec 08             	sub    $0x8,%esp
  8004cc:	57                   	push   %edi
  8004cd:	ff 75 18             	pushl  0x18(%ebp)
  8004d0:	ff d6                	call   *%esi
  8004d2:	83 c4 10             	add    $0x10,%esp
  8004d5:	eb eb                	jmp    8004c2 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8004d7:	83 ec 0c             	sub    $0xc,%esp
  8004da:	6a 20                	push   $0x20
  8004dc:	6a 00                	push   $0x0
  8004de:	50                   	push   %eax
  8004df:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004e2:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e5:	89 fa                	mov    %edi,%edx
  8004e7:	89 f0                	mov    %esi,%eax
  8004e9:	e8 98 ff ff ff       	call   800486 <printnum>
		while (--width > 0)
  8004ee:	83 c4 20             	add    $0x20,%esp
  8004f1:	83 eb 01             	sub    $0x1,%ebx
  8004f4:	85 db                	test   %ebx,%ebx
  8004f6:	7e 65                	jle    80055d <printnum+0xd7>
			putch(' ', putdat);
  8004f8:	83 ec 08             	sub    $0x8,%esp
  8004fb:	57                   	push   %edi
  8004fc:	6a 20                	push   $0x20
  8004fe:	ff d6                	call   *%esi
  800500:	83 c4 10             	add    $0x10,%esp
  800503:	eb ec                	jmp    8004f1 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800505:	83 ec 0c             	sub    $0xc,%esp
  800508:	ff 75 18             	pushl  0x18(%ebp)
  80050b:	83 eb 01             	sub    $0x1,%ebx
  80050e:	53                   	push   %ebx
  80050f:	50                   	push   %eax
  800510:	83 ec 08             	sub    $0x8,%esp
  800513:	ff 75 dc             	pushl  -0x24(%ebp)
  800516:	ff 75 d8             	pushl  -0x28(%ebp)
  800519:	ff 75 e4             	pushl  -0x1c(%ebp)
  80051c:	ff 75 e0             	pushl  -0x20(%ebp)
  80051f:	e8 ac 09 00 00       	call   800ed0 <__udivdi3>
  800524:	83 c4 18             	add    $0x18,%esp
  800527:	52                   	push   %edx
  800528:	50                   	push   %eax
  800529:	89 fa                	mov    %edi,%edx
  80052b:	89 f0                	mov    %esi,%eax
  80052d:	e8 54 ff ff ff       	call   800486 <printnum>
  800532:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800535:	83 ec 08             	sub    $0x8,%esp
  800538:	57                   	push   %edi
  800539:	83 ec 04             	sub    $0x4,%esp
  80053c:	ff 75 dc             	pushl  -0x24(%ebp)
  80053f:	ff 75 d8             	pushl  -0x28(%ebp)
  800542:	ff 75 e4             	pushl  -0x1c(%ebp)
  800545:	ff 75 e0             	pushl  -0x20(%ebp)
  800548:	e8 93 0a 00 00       	call   800fe0 <__umoddi3>
  80054d:	83 c4 14             	add    $0x14,%esp
  800550:	0f be 80 87 11 80 00 	movsbl 0x801187(%eax),%eax
  800557:	50                   	push   %eax
  800558:	ff d6                	call   *%esi
  80055a:	83 c4 10             	add    $0x10,%esp
}
  80055d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800560:	5b                   	pop    %ebx
  800561:	5e                   	pop    %esi
  800562:	5f                   	pop    %edi
  800563:	5d                   	pop    %ebp
  800564:	c3                   	ret    

00800565 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800565:	55                   	push   %ebp
  800566:	89 e5                	mov    %esp,%ebp
  800568:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80056b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80056f:	8b 10                	mov    (%eax),%edx
  800571:	3b 50 04             	cmp    0x4(%eax),%edx
  800574:	73 0a                	jae    800580 <sprintputch+0x1b>
		*b->buf++ = ch;
  800576:	8d 4a 01             	lea    0x1(%edx),%ecx
  800579:	89 08                	mov    %ecx,(%eax)
  80057b:	8b 45 08             	mov    0x8(%ebp),%eax
  80057e:	88 02                	mov    %al,(%edx)
}
  800580:	5d                   	pop    %ebp
  800581:	c3                   	ret    

00800582 <printfmt>:
{
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800588:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80058b:	50                   	push   %eax
  80058c:	ff 75 10             	pushl  0x10(%ebp)
  80058f:	ff 75 0c             	pushl  0xc(%ebp)
  800592:	ff 75 08             	pushl  0x8(%ebp)
  800595:	e8 05 00 00 00       	call   80059f <vprintfmt>
}
  80059a:	83 c4 10             	add    $0x10,%esp
  80059d:	c9                   	leave  
  80059e:	c3                   	ret    

0080059f <vprintfmt>:
{
  80059f:	55                   	push   %ebp
  8005a0:	89 e5                	mov    %esp,%ebp
  8005a2:	57                   	push   %edi
  8005a3:	56                   	push   %esi
  8005a4:	53                   	push   %ebx
  8005a5:	83 ec 3c             	sub    $0x3c,%esp
  8005a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005ae:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005b1:	e9 1e 04 00 00       	jmp    8009d4 <vprintfmt+0x435>
		posflag = 0;
  8005b6:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  8005bd:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8005c1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8005c8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8005cf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005d6:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8005dd:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005e2:	8d 47 01             	lea    0x1(%edi),%eax
  8005e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005e8:	0f b6 17             	movzbl (%edi),%edx
  8005eb:	8d 42 dd             	lea    -0x23(%edx),%eax
  8005ee:	3c 55                	cmp    $0x55,%al
  8005f0:	0f 87 d9 04 00 00    	ja     800acf <vprintfmt+0x530>
  8005f6:	0f b6 c0             	movzbl %al,%eax
  8005f9:	ff 24 85 60 13 80 00 	jmp    *0x801360(,%eax,4)
  800600:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800603:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800607:	eb d9                	jmp    8005e2 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800609:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  80060c:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  800613:	eb cd                	jmp    8005e2 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800615:	0f b6 d2             	movzbl %dl,%edx
  800618:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80061b:	b8 00 00 00 00       	mov    $0x0,%eax
  800620:	89 75 08             	mov    %esi,0x8(%ebp)
  800623:	eb 0c                	jmp    800631 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  800625:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800628:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80062c:	eb b4                	jmp    8005e2 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  80062e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800631:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800634:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800638:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80063b:	8d 72 d0             	lea    -0x30(%edx),%esi
  80063e:	83 fe 09             	cmp    $0x9,%esi
  800641:	76 eb                	jbe    80062e <vprintfmt+0x8f>
  800643:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800646:	8b 75 08             	mov    0x8(%ebp),%esi
  800649:	eb 14                	jmp    80065f <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  80064b:	8b 45 14             	mov    0x14(%ebp),%eax
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	8d 40 04             	lea    0x4(%eax),%eax
  800659:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80065c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80065f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800663:	0f 89 79 ff ff ff    	jns    8005e2 <vprintfmt+0x43>
				width = precision, precision = -1;
  800669:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80066c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80066f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800676:	e9 67 ff ff ff       	jmp    8005e2 <vprintfmt+0x43>
  80067b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80067e:	85 c0                	test   %eax,%eax
  800680:	0f 48 c1             	cmovs  %ecx,%eax
  800683:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800686:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800689:	e9 54 ff ff ff       	jmp    8005e2 <vprintfmt+0x43>
  80068e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800691:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800698:	e9 45 ff ff ff       	jmp    8005e2 <vprintfmt+0x43>
			lflag++;
  80069d:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006a4:	e9 39 ff ff ff       	jmp    8005e2 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8d 78 04             	lea    0x4(%eax),%edi
  8006af:	83 ec 08             	sub    $0x8,%esp
  8006b2:	53                   	push   %ebx
  8006b3:	ff 30                	pushl  (%eax)
  8006b5:	ff d6                	call   *%esi
			break;
  8006b7:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006ba:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006bd:	e9 0f 03 00 00       	jmp    8009d1 <vprintfmt+0x432>
			err = va_arg(ap, int);
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8d 78 04             	lea    0x4(%eax),%edi
  8006c8:	8b 00                	mov    (%eax),%eax
  8006ca:	99                   	cltd   
  8006cb:	31 d0                	xor    %edx,%eax
  8006cd:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006cf:	83 f8 0f             	cmp    $0xf,%eax
  8006d2:	7f 23                	jg     8006f7 <vprintfmt+0x158>
  8006d4:	8b 14 85 c0 14 80 00 	mov    0x8014c0(,%eax,4),%edx
  8006db:	85 d2                	test   %edx,%edx
  8006dd:	74 18                	je     8006f7 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  8006df:	52                   	push   %edx
  8006e0:	68 a8 11 80 00       	push   $0x8011a8
  8006e5:	53                   	push   %ebx
  8006e6:	56                   	push   %esi
  8006e7:	e8 96 fe ff ff       	call   800582 <printfmt>
  8006ec:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006ef:	89 7d 14             	mov    %edi,0x14(%ebp)
  8006f2:	e9 da 02 00 00       	jmp    8009d1 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  8006f7:	50                   	push   %eax
  8006f8:	68 9f 11 80 00       	push   $0x80119f
  8006fd:	53                   	push   %ebx
  8006fe:	56                   	push   %esi
  8006ff:	e8 7e fe ff ff       	call   800582 <printfmt>
  800704:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800707:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80070a:	e9 c2 02 00 00       	jmp    8009d1 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	83 c0 04             	add    $0x4,%eax
  800715:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800718:	8b 45 14             	mov    0x14(%ebp),%eax
  80071b:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80071d:	85 c9                	test   %ecx,%ecx
  80071f:	b8 98 11 80 00       	mov    $0x801198,%eax
  800724:	0f 45 c1             	cmovne %ecx,%eax
  800727:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80072a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80072e:	7e 06                	jle    800736 <vprintfmt+0x197>
  800730:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800734:	75 0d                	jne    800743 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800736:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800739:	89 c7                	mov    %eax,%edi
  80073b:	03 45 e0             	add    -0x20(%ebp),%eax
  80073e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800741:	eb 53                	jmp    800796 <vprintfmt+0x1f7>
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	ff 75 d8             	pushl  -0x28(%ebp)
  800749:	50                   	push   %eax
  80074a:	e8 28 04 00 00       	call   800b77 <strnlen>
  80074f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800752:	29 c1                	sub    %eax,%ecx
  800754:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800757:	83 c4 10             	add    $0x10,%esp
  80075a:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80075c:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800760:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800763:	eb 0f                	jmp    800774 <vprintfmt+0x1d5>
					putch(padc, putdat);
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	53                   	push   %ebx
  800769:	ff 75 e0             	pushl  -0x20(%ebp)
  80076c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80076e:	83 ef 01             	sub    $0x1,%edi
  800771:	83 c4 10             	add    $0x10,%esp
  800774:	85 ff                	test   %edi,%edi
  800776:	7f ed                	jg     800765 <vprintfmt+0x1c6>
  800778:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  80077b:	85 c9                	test   %ecx,%ecx
  80077d:	b8 00 00 00 00       	mov    $0x0,%eax
  800782:	0f 49 c1             	cmovns %ecx,%eax
  800785:	29 c1                	sub    %eax,%ecx
  800787:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80078a:	eb aa                	jmp    800736 <vprintfmt+0x197>
					putch(ch, putdat);
  80078c:	83 ec 08             	sub    $0x8,%esp
  80078f:	53                   	push   %ebx
  800790:	52                   	push   %edx
  800791:	ff d6                	call   *%esi
  800793:	83 c4 10             	add    $0x10,%esp
  800796:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800799:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80079b:	83 c7 01             	add    $0x1,%edi
  80079e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007a2:	0f be d0             	movsbl %al,%edx
  8007a5:	85 d2                	test   %edx,%edx
  8007a7:	74 4b                	je     8007f4 <vprintfmt+0x255>
  8007a9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007ad:	78 06                	js     8007b5 <vprintfmt+0x216>
  8007af:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007b3:	78 1e                	js     8007d3 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  8007b5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007b9:	74 d1                	je     80078c <vprintfmt+0x1ed>
  8007bb:	0f be c0             	movsbl %al,%eax
  8007be:	83 e8 20             	sub    $0x20,%eax
  8007c1:	83 f8 5e             	cmp    $0x5e,%eax
  8007c4:	76 c6                	jbe    80078c <vprintfmt+0x1ed>
					putch('?', putdat);
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	53                   	push   %ebx
  8007ca:	6a 3f                	push   $0x3f
  8007cc:	ff d6                	call   *%esi
  8007ce:	83 c4 10             	add    $0x10,%esp
  8007d1:	eb c3                	jmp    800796 <vprintfmt+0x1f7>
  8007d3:	89 cf                	mov    %ecx,%edi
  8007d5:	eb 0e                	jmp    8007e5 <vprintfmt+0x246>
				putch(' ', putdat);
  8007d7:	83 ec 08             	sub    $0x8,%esp
  8007da:	53                   	push   %ebx
  8007db:	6a 20                	push   $0x20
  8007dd:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8007df:	83 ef 01             	sub    $0x1,%edi
  8007e2:	83 c4 10             	add    $0x10,%esp
  8007e5:	85 ff                	test   %edi,%edi
  8007e7:	7f ee                	jg     8007d7 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  8007e9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007ec:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ef:	e9 dd 01 00 00       	jmp    8009d1 <vprintfmt+0x432>
  8007f4:	89 cf                	mov    %ecx,%edi
  8007f6:	eb ed                	jmp    8007e5 <vprintfmt+0x246>
	if (lflag >= 2)
  8007f8:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8007fc:	7f 21                	jg     80081f <vprintfmt+0x280>
	else if (lflag)
  8007fe:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800802:	74 6a                	je     80086e <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  800804:	8b 45 14             	mov    0x14(%ebp),%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080c:	89 c1                	mov    %eax,%ecx
  80080e:	c1 f9 1f             	sar    $0x1f,%ecx
  800811:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	8d 40 04             	lea    0x4(%eax),%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
  80081d:	eb 17                	jmp    800836 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  80081f:	8b 45 14             	mov    0x14(%ebp),%eax
  800822:	8b 50 04             	mov    0x4(%eax),%edx
  800825:	8b 00                	mov    (%eax),%eax
  800827:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80082d:	8b 45 14             	mov    0x14(%ebp),%eax
  800830:	8d 40 08             	lea    0x8(%eax),%eax
  800833:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800836:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800839:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80083e:	85 d2                	test   %edx,%edx
  800840:	0f 89 5c 01 00 00    	jns    8009a2 <vprintfmt+0x403>
				putch('-', putdat);
  800846:	83 ec 08             	sub    $0x8,%esp
  800849:	53                   	push   %ebx
  80084a:	6a 2d                	push   $0x2d
  80084c:	ff d6                	call   *%esi
				num = -(long long) num;
  80084e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800851:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800854:	f7 d8                	neg    %eax
  800856:	83 d2 00             	adc    $0x0,%edx
  800859:	f7 da                	neg    %edx
  80085b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800861:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800864:	bf 0a 00 00 00       	mov    $0xa,%edi
  800869:	e9 45 01 00 00       	jmp    8009b3 <vprintfmt+0x414>
		return va_arg(*ap, int);
  80086e:	8b 45 14             	mov    0x14(%ebp),%eax
  800871:	8b 00                	mov    (%eax),%eax
  800873:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800876:	89 c1                	mov    %eax,%ecx
  800878:	c1 f9 1f             	sar    $0x1f,%ecx
  80087b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	8d 40 04             	lea    0x4(%eax),%eax
  800884:	89 45 14             	mov    %eax,0x14(%ebp)
  800887:	eb ad                	jmp    800836 <vprintfmt+0x297>
	if (lflag >= 2)
  800889:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80088d:	7f 29                	jg     8008b8 <vprintfmt+0x319>
	else if (lflag)
  80088f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800893:	74 44                	je     8008d9 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  800895:	8b 45 14             	mov    0x14(%ebp),%eax
  800898:	8b 00                	mov    (%eax),%eax
  80089a:	ba 00 00 00 00       	mov    $0x0,%edx
  80089f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	8d 40 04             	lea    0x4(%eax),%eax
  8008ab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008ae:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008b3:	e9 ea 00 00 00       	jmp    8009a2 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8008b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bb:	8b 50 04             	mov    0x4(%eax),%edx
  8008be:	8b 00                	mov    (%eax),%eax
  8008c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c9:	8d 40 08             	lea    0x8(%eax),%eax
  8008cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008cf:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008d4:	e9 c9 00 00 00       	jmp    8009a2 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ec:	8d 40 04             	lea    0x4(%eax),%eax
  8008ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008f2:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008f7:	e9 a6 00 00 00       	jmp    8009a2 <vprintfmt+0x403>
			putch('0', putdat);
  8008fc:	83 ec 08             	sub    $0x8,%esp
  8008ff:	53                   	push   %ebx
  800900:	6a 30                	push   $0x30
  800902:	ff d6                	call   *%esi
	if (lflag >= 2)
  800904:	83 c4 10             	add    $0x10,%esp
  800907:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80090b:	7f 26                	jg     800933 <vprintfmt+0x394>
	else if (lflag)
  80090d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800911:	74 3e                	je     800951 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  800913:	8b 45 14             	mov    0x14(%ebp),%eax
  800916:	8b 00                	mov    (%eax),%eax
  800918:	ba 00 00 00 00       	mov    $0x0,%edx
  80091d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800920:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800923:	8b 45 14             	mov    0x14(%ebp),%eax
  800926:	8d 40 04             	lea    0x4(%eax),%eax
  800929:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80092c:	bf 08 00 00 00       	mov    $0x8,%edi
  800931:	eb 6f                	jmp    8009a2 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800933:	8b 45 14             	mov    0x14(%ebp),%eax
  800936:	8b 50 04             	mov    0x4(%eax),%edx
  800939:	8b 00                	mov    (%eax),%eax
  80093b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80093e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800941:	8b 45 14             	mov    0x14(%ebp),%eax
  800944:	8d 40 08             	lea    0x8(%eax),%eax
  800947:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80094a:	bf 08 00 00 00       	mov    $0x8,%edi
  80094f:	eb 51                	jmp    8009a2 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800951:	8b 45 14             	mov    0x14(%ebp),%eax
  800954:	8b 00                	mov    (%eax),%eax
  800956:	ba 00 00 00 00       	mov    $0x0,%edx
  80095b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80095e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800961:	8b 45 14             	mov    0x14(%ebp),%eax
  800964:	8d 40 04             	lea    0x4(%eax),%eax
  800967:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80096a:	bf 08 00 00 00       	mov    $0x8,%edi
  80096f:	eb 31                	jmp    8009a2 <vprintfmt+0x403>
			putch('0', putdat);
  800971:	83 ec 08             	sub    $0x8,%esp
  800974:	53                   	push   %ebx
  800975:	6a 30                	push   $0x30
  800977:	ff d6                	call   *%esi
			putch('x', putdat);
  800979:	83 c4 08             	add    $0x8,%esp
  80097c:	53                   	push   %ebx
  80097d:	6a 78                	push   $0x78
  80097f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800981:	8b 45 14             	mov    0x14(%ebp),%eax
  800984:	8b 00                	mov    (%eax),%eax
  800986:	ba 00 00 00 00       	mov    $0x0,%edx
  80098b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80098e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800991:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800994:	8b 45 14             	mov    0x14(%ebp),%eax
  800997:	8d 40 04             	lea    0x4(%eax),%eax
  80099a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80099d:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  8009a2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009a6:	74 0b                	je     8009b3 <vprintfmt+0x414>
				putch('+', putdat);
  8009a8:	83 ec 08             	sub    $0x8,%esp
  8009ab:	53                   	push   %ebx
  8009ac:	6a 2b                	push   $0x2b
  8009ae:	ff d6                	call   *%esi
  8009b0:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8009b3:	83 ec 0c             	sub    $0xc,%esp
  8009b6:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009ba:	50                   	push   %eax
  8009bb:	ff 75 e0             	pushl  -0x20(%ebp)
  8009be:	57                   	push   %edi
  8009bf:	ff 75 dc             	pushl  -0x24(%ebp)
  8009c2:	ff 75 d8             	pushl  -0x28(%ebp)
  8009c5:	89 da                	mov    %ebx,%edx
  8009c7:	89 f0                	mov    %esi,%eax
  8009c9:	e8 b8 fa ff ff       	call   800486 <printnum>
			break;
  8009ce:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  8009d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009d4:	83 c7 01             	add    $0x1,%edi
  8009d7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009db:	83 f8 25             	cmp    $0x25,%eax
  8009de:	0f 84 d2 fb ff ff    	je     8005b6 <vprintfmt+0x17>
			if (ch == '\0')
  8009e4:	85 c0                	test   %eax,%eax
  8009e6:	0f 84 03 01 00 00    	je     800aef <vprintfmt+0x550>
			putch(ch, putdat);
  8009ec:	83 ec 08             	sub    $0x8,%esp
  8009ef:	53                   	push   %ebx
  8009f0:	50                   	push   %eax
  8009f1:	ff d6                	call   *%esi
  8009f3:	83 c4 10             	add    $0x10,%esp
  8009f6:	eb dc                	jmp    8009d4 <vprintfmt+0x435>
	if (lflag >= 2)
  8009f8:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8009fc:	7f 29                	jg     800a27 <vprintfmt+0x488>
	else if (lflag)
  8009fe:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800a02:	74 44                	je     800a48 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  800a04:	8b 45 14             	mov    0x14(%ebp),%eax
  800a07:	8b 00                	mov    (%eax),%eax
  800a09:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a11:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a14:	8b 45 14             	mov    0x14(%ebp),%eax
  800a17:	8d 40 04             	lea    0x4(%eax),%eax
  800a1a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a1d:	bf 10 00 00 00       	mov    $0x10,%edi
  800a22:	e9 7b ff ff ff       	jmp    8009a2 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800a27:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2a:	8b 50 04             	mov    0x4(%eax),%edx
  800a2d:	8b 00                	mov    (%eax),%eax
  800a2f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a32:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	8d 40 08             	lea    0x8(%eax),%eax
  800a3b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a3e:	bf 10 00 00 00       	mov    $0x10,%edi
  800a43:	e9 5a ff ff ff       	jmp    8009a2 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800a48:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4b:	8b 00                	mov    (%eax),%eax
  800a4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a52:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a55:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a58:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5b:	8d 40 04             	lea    0x4(%eax),%eax
  800a5e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a61:	bf 10 00 00 00       	mov    $0x10,%edi
  800a66:	e9 37 ff ff ff       	jmp    8009a2 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6e:	8d 78 04             	lea    0x4(%eax),%edi
  800a71:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800a73:	85 c0                	test   %eax,%eax
  800a75:	74 2c                	je     800aa3 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800a77:	8b 13                	mov    (%ebx),%edx
  800a79:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800a7b:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800a7e:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800a81:	0f 8e 4a ff ff ff    	jle    8009d1 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800a87:	68 f8 12 80 00       	push   $0x8012f8
  800a8c:	68 a8 11 80 00       	push   $0x8011a8
  800a91:	53                   	push   %ebx
  800a92:	56                   	push   %esi
  800a93:	e8 ea fa ff ff       	call   800582 <printfmt>
  800a98:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800a9b:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a9e:	e9 2e ff ff ff       	jmp    8009d1 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800aa3:	68 c0 12 80 00       	push   $0x8012c0
  800aa8:	68 a8 11 80 00       	push   $0x8011a8
  800aad:	53                   	push   %ebx
  800aae:	56                   	push   %esi
  800aaf:	e8 ce fa ff ff       	call   800582 <printfmt>
        		break;
  800ab4:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800ab7:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800aba:	e9 12 ff ff ff       	jmp    8009d1 <vprintfmt+0x432>
			putch(ch, putdat);
  800abf:	83 ec 08             	sub    $0x8,%esp
  800ac2:	53                   	push   %ebx
  800ac3:	6a 25                	push   $0x25
  800ac5:	ff d6                	call   *%esi
			break;
  800ac7:	83 c4 10             	add    $0x10,%esp
  800aca:	e9 02 ff ff ff       	jmp    8009d1 <vprintfmt+0x432>
			putch('%', putdat);
  800acf:	83 ec 08             	sub    $0x8,%esp
  800ad2:	53                   	push   %ebx
  800ad3:	6a 25                	push   $0x25
  800ad5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ad7:	83 c4 10             	add    $0x10,%esp
  800ada:	89 f8                	mov    %edi,%eax
  800adc:	eb 03                	jmp    800ae1 <vprintfmt+0x542>
  800ade:	83 e8 01             	sub    $0x1,%eax
  800ae1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800ae5:	75 f7                	jne    800ade <vprintfmt+0x53f>
  800ae7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800aea:	e9 e2 fe ff ff       	jmp    8009d1 <vprintfmt+0x432>
}
  800aef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800af2:	5b                   	pop    %ebx
  800af3:	5e                   	pop    %esi
  800af4:	5f                   	pop    %edi
  800af5:	5d                   	pop    %ebp
  800af6:	c3                   	ret    

00800af7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	83 ec 18             	sub    $0x18,%esp
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b03:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b06:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b0a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b14:	85 c0                	test   %eax,%eax
  800b16:	74 26                	je     800b3e <vsnprintf+0x47>
  800b18:	85 d2                	test   %edx,%edx
  800b1a:	7e 22                	jle    800b3e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b1c:	ff 75 14             	pushl  0x14(%ebp)
  800b1f:	ff 75 10             	pushl  0x10(%ebp)
  800b22:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b25:	50                   	push   %eax
  800b26:	68 65 05 80 00       	push   $0x800565
  800b2b:	e8 6f fa ff ff       	call   80059f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b33:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b39:	83 c4 10             	add    $0x10,%esp
}
  800b3c:	c9                   	leave  
  800b3d:	c3                   	ret    
		return -E_INVAL;
  800b3e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b43:	eb f7                	jmp    800b3c <vsnprintf+0x45>

00800b45 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b4b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b4e:	50                   	push   %eax
  800b4f:	ff 75 10             	pushl  0x10(%ebp)
  800b52:	ff 75 0c             	pushl  0xc(%ebp)
  800b55:	ff 75 08             	pushl  0x8(%ebp)
  800b58:	e8 9a ff ff ff       	call   800af7 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b5d:	c9                   	leave  
  800b5e:	c3                   	ret    

00800b5f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b65:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b6e:	74 05                	je     800b75 <strlen+0x16>
		n++;
  800b70:	83 c0 01             	add    $0x1,%eax
  800b73:	eb f5                	jmp    800b6a <strlen+0xb>
	return n;
}
  800b75:	5d                   	pop    %ebp
  800b76:	c3                   	ret    

00800b77 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b80:	ba 00 00 00 00       	mov    $0x0,%edx
  800b85:	39 c2                	cmp    %eax,%edx
  800b87:	74 0d                	je     800b96 <strnlen+0x1f>
  800b89:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b8d:	74 05                	je     800b94 <strnlen+0x1d>
		n++;
  800b8f:	83 c2 01             	add    $0x1,%edx
  800b92:	eb f1                	jmp    800b85 <strnlen+0xe>
  800b94:	89 d0                	mov    %edx,%eax
	return n;
}
  800b96:	5d                   	pop    %ebp
  800b97:	c3                   	ret    

00800b98 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	53                   	push   %ebx
  800b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ba2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba7:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bab:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bae:	83 c2 01             	add    $0x1,%edx
  800bb1:	84 c9                	test   %cl,%cl
  800bb3:	75 f2                	jne    800ba7 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bb5:	5b                   	pop    %ebx
  800bb6:	5d                   	pop    %ebp
  800bb7:	c3                   	ret    

00800bb8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	53                   	push   %ebx
  800bbc:	83 ec 10             	sub    $0x10,%esp
  800bbf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bc2:	53                   	push   %ebx
  800bc3:	e8 97 ff ff ff       	call   800b5f <strlen>
  800bc8:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bcb:	ff 75 0c             	pushl  0xc(%ebp)
  800bce:	01 d8                	add    %ebx,%eax
  800bd0:	50                   	push   %eax
  800bd1:	e8 c2 ff ff ff       	call   800b98 <strcpy>
	return dst;
}
  800bd6:	89 d8                	mov    %ebx,%eax
  800bd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bdb:	c9                   	leave  
  800bdc:	c3                   	ret    

00800bdd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	56                   	push   %esi
  800be1:	53                   	push   %ebx
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be8:	89 c6                	mov    %eax,%esi
  800bea:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bed:	89 c2                	mov    %eax,%edx
  800bef:	39 f2                	cmp    %esi,%edx
  800bf1:	74 11                	je     800c04 <strncpy+0x27>
		*dst++ = *src;
  800bf3:	83 c2 01             	add    $0x1,%edx
  800bf6:	0f b6 19             	movzbl (%ecx),%ebx
  800bf9:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bfc:	80 fb 01             	cmp    $0x1,%bl
  800bff:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c02:	eb eb                	jmp    800bef <strncpy+0x12>
	}
	return ret;
}
  800c04:	5b                   	pop    %ebx
  800c05:	5e                   	pop    %esi
  800c06:	5d                   	pop    %ebp
  800c07:	c3                   	ret    

00800c08 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
  800c0b:	56                   	push   %esi
  800c0c:	53                   	push   %ebx
  800c0d:	8b 75 08             	mov    0x8(%ebp),%esi
  800c10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c13:	8b 55 10             	mov    0x10(%ebp),%edx
  800c16:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c18:	85 d2                	test   %edx,%edx
  800c1a:	74 21                	je     800c3d <strlcpy+0x35>
  800c1c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c20:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c22:	39 c2                	cmp    %eax,%edx
  800c24:	74 14                	je     800c3a <strlcpy+0x32>
  800c26:	0f b6 19             	movzbl (%ecx),%ebx
  800c29:	84 db                	test   %bl,%bl
  800c2b:	74 0b                	je     800c38 <strlcpy+0x30>
			*dst++ = *src++;
  800c2d:	83 c1 01             	add    $0x1,%ecx
  800c30:	83 c2 01             	add    $0x1,%edx
  800c33:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c36:	eb ea                	jmp    800c22 <strlcpy+0x1a>
  800c38:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c3a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c3d:	29 f0                	sub    %esi,%eax
}
  800c3f:	5b                   	pop    %ebx
  800c40:	5e                   	pop    %esi
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    

00800c43 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c49:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c4c:	0f b6 01             	movzbl (%ecx),%eax
  800c4f:	84 c0                	test   %al,%al
  800c51:	74 0c                	je     800c5f <strcmp+0x1c>
  800c53:	3a 02                	cmp    (%edx),%al
  800c55:	75 08                	jne    800c5f <strcmp+0x1c>
		p++, q++;
  800c57:	83 c1 01             	add    $0x1,%ecx
  800c5a:	83 c2 01             	add    $0x1,%edx
  800c5d:	eb ed                	jmp    800c4c <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c5f:	0f b6 c0             	movzbl %al,%eax
  800c62:	0f b6 12             	movzbl (%edx),%edx
  800c65:	29 d0                	sub    %edx,%eax
}
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    

00800c69 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	53                   	push   %ebx
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c73:	89 c3                	mov    %eax,%ebx
  800c75:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c78:	eb 06                	jmp    800c80 <strncmp+0x17>
		n--, p++, q++;
  800c7a:	83 c0 01             	add    $0x1,%eax
  800c7d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c80:	39 d8                	cmp    %ebx,%eax
  800c82:	74 16                	je     800c9a <strncmp+0x31>
  800c84:	0f b6 08             	movzbl (%eax),%ecx
  800c87:	84 c9                	test   %cl,%cl
  800c89:	74 04                	je     800c8f <strncmp+0x26>
  800c8b:	3a 0a                	cmp    (%edx),%cl
  800c8d:	74 eb                	je     800c7a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c8f:	0f b6 00             	movzbl (%eax),%eax
  800c92:	0f b6 12             	movzbl (%edx),%edx
  800c95:	29 d0                	sub    %edx,%eax
}
  800c97:	5b                   	pop    %ebx
  800c98:	5d                   	pop    %ebp
  800c99:	c3                   	ret    
		return 0;
  800c9a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c9f:	eb f6                	jmp    800c97 <strncmp+0x2e>

00800ca1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cab:	0f b6 10             	movzbl (%eax),%edx
  800cae:	84 d2                	test   %dl,%dl
  800cb0:	74 09                	je     800cbb <strchr+0x1a>
		if (*s == c)
  800cb2:	38 ca                	cmp    %cl,%dl
  800cb4:	74 0a                	je     800cc0 <strchr+0x1f>
	for (; *s; s++)
  800cb6:	83 c0 01             	add    $0x1,%eax
  800cb9:	eb f0                	jmp    800cab <strchr+0xa>
			return (char *) s;
	return 0;
  800cbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cc0:	5d                   	pop    %ebp
  800cc1:	c3                   	ret    

00800cc2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ccc:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ccf:	38 ca                	cmp    %cl,%dl
  800cd1:	74 09                	je     800cdc <strfind+0x1a>
  800cd3:	84 d2                	test   %dl,%dl
  800cd5:	74 05                	je     800cdc <strfind+0x1a>
	for (; *s; s++)
  800cd7:	83 c0 01             	add    $0x1,%eax
  800cda:	eb f0                	jmp    800ccc <strfind+0xa>
			break;
	return (char *) s;
}
  800cdc:	5d                   	pop    %ebp
  800cdd:	c3                   	ret    

00800cde <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	57                   	push   %edi
  800ce2:	56                   	push   %esi
  800ce3:	53                   	push   %ebx
  800ce4:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ce7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cea:	85 c9                	test   %ecx,%ecx
  800cec:	74 31                	je     800d1f <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cee:	89 f8                	mov    %edi,%eax
  800cf0:	09 c8                	or     %ecx,%eax
  800cf2:	a8 03                	test   $0x3,%al
  800cf4:	75 23                	jne    800d19 <memset+0x3b>
		c &= 0xFF;
  800cf6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cfa:	89 d3                	mov    %edx,%ebx
  800cfc:	c1 e3 08             	shl    $0x8,%ebx
  800cff:	89 d0                	mov    %edx,%eax
  800d01:	c1 e0 18             	shl    $0x18,%eax
  800d04:	89 d6                	mov    %edx,%esi
  800d06:	c1 e6 10             	shl    $0x10,%esi
  800d09:	09 f0                	or     %esi,%eax
  800d0b:	09 c2                	or     %eax,%edx
  800d0d:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d0f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d12:	89 d0                	mov    %edx,%eax
  800d14:	fc                   	cld    
  800d15:	f3 ab                	rep stos %eax,%es:(%edi)
  800d17:	eb 06                	jmp    800d1f <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1c:	fc                   	cld    
  800d1d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d1f:	89 f8                	mov    %edi,%eax
  800d21:	5b                   	pop    %ebx
  800d22:	5e                   	pop    %esi
  800d23:	5f                   	pop    %edi
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    

00800d26 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	57                   	push   %edi
  800d2a:	56                   	push   %esi
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d31:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d34:	39 c6                	cmp    %eax,%esi
  800d36:	73 32                	jae    800d6a <memmove+0x44>
  800d38:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d3b:	39 c2                	cmp    %eax,%edx
  800d3d:	76 2b                	jbe    800d6a <memmove+0x44>
		s += n;
		d += n;
  800d3f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d42:	89 fe                	mov    %edi,%esi
  800d44:	09 ce                	or     %ecx,%esi
  800d46:	09 d6                	or     %edx,%esi
  800d48:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d4e:	75 0e                	jne    800d5e <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d50:	83 ef 04             	sub    $0x4,%edi
  800d53:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d56:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d59:	fd                   	std    
  800d5a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d5c:	eb 09                	jmp    800d67 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d5e:	83 ef 01             	sub    $0x1,%edi
  800d61:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d64:	fd                   	std    
  800d65:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d67:	fc                   	cld    
  800d68:	eb 1a                	jmp    800d84 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d6a:	89 c2                	mov    %eax,%edx
  800d6c:	09 ca                	or     %ecx,%edx
  800d6e:	09 f2                	or     %esi,%edx
  800d70:	f6 c2 03             	test   $0x3,%dl
  800d73:	75 0a                	jne    800d7f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d75:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d78:	89 c7                	mov    %eax,%edi
  800d7a:	fc                   	cld    
  800d7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d7d:	eb 05                	jmp    800d84 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d7f:	89 c7                	mov    %eax,%edi
  800d81:	fc                   	cld    
  800d82:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d84:	5e                   	pop    %esi
  800d85:	5f                   	pop    %edi
  800d86:	5d                   	pop    %ebp
  800d87:	c3                   	ret    

00800d88 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d8e:	ff 75 10             	pushl  0x10(%ebp)
  800d91:	ff 75 0c             	pushl  0xc(%ebp)
  800d94:	ff 75 08             	pushl  0x8(%ebp)
  800d97:	e8 8a ff ff ff       	call   800d26 <memmove>
}
  800d9c:	c9                   	leave  
  800d9d:	c3                   	ret    

00800d9e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d9e:	55                   	push   %ebp
  800d9f:	89 e5                	mov    %esp,%ebp
  800da1:	56                   	push   %esi
  800da2:	53                   	push   %ebx
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da9:	89 c6                	mov    %eax,%esi
  800dab:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dae:	39 f0                	cmp    %esi,%eax
  800db0:	74 1c                	je     800dce <memcmp+0x30>
		if (*s1 != *s2)
  800db2:	0f b6 08             	movzbl (%eax),%ecx
  800db5:	0f b6 1a             	movzbl (%edx),%ebx
  800db8:	38 d9                	cmp    %bl,%cl
  800dba:	75 08                	jne    800dc4 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800dbc:	83 c0 01             	add    $0x1,%eax
  800dbf:	83 c2 01             	add    $0x1,%edx
  800dc2:	eb ea                	jmp    800dae <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800dc4:	0f b6 c1             	movzbl %cl,%eax
  800dc7:	0f b6 db             	movzbl %bl,%ebx
  800dca:	29 d8                	sub    %ebx,%eax
  800dcc:	eb 05                	jmp    800dd3 <memcmp+0x35>
	}

	return 0;
  800dce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dd3:	5b                   	pop    %ebx
  800dd4:	5e                   	pop    %esi
  800dd5:	5d                   	pop    %ebp
  800dd6:	c3                   	ret    

00800dd7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800de0:	89 c2                	mov    %eax,%edx
  800de2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800de5:	39 d0                	cmp    %edx,%eax
  800de7:	73 09                	jae    800df2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800de9:	38 08                	cmp    %cl,(%eax)
  800deb:	74 05                	je     800df2 <memfind+0x1b>
	for (; s < ends; s++)
  800ded:	83 c0 01             	add    $0x1,%eax
  800df0:	eb f3                	jmp    800de5 <memfind+0xe>
			break;
	return (void *) s;
}
  800df2:	5d                   	pop    %ebp
  800df3:	c3                   	ret    

00800df4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	57                   	push   %edi
  800df8:	56                   	push   %esi
  800df9:	53                   	push   %ebx
  800dfa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dfd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e00:	eb 03                	jmp    800e05 <strtol+0x11>
		s++;
  800e02:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e05:	0f b6 01             	movzbl (%ecx),%eax
  800e08:	3c 20                	cmp    $0x20,%al
  800e0a:	74 f6                	je     800e02 <strtol+0xe>
  800e0c:	3c 09                	cmp    $0x9,%al
  800e0e:	74 f2                	je     800e02 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e10:	3c 2b                	cmp    $0x2b,%al
  800e12:	74 2a                	je     800e3e <strtol+0x4a>
	int neg = 0;
  800e14:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e19:	3c 2d                	cmp    $0x2d,%al
  800e1b:	74 2b                	je     800e48 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e1d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e23:	75 0f                	jne    800e34 <strtol+0x40>
  800e25:	80 39 30             	cmpb   $0x30,(%ecx)
  800e28:	74 28                	je     800e52 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e2a:	85 db                	test   %ebx,%ebx
  800e2c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e31:	0f 44 d8             	cmove  %eax,%ebx
  800e34:	b8 00 00 00 00       	mov    $0x0,%eax
  800e39:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e3c:	eb 50                	jmp    800e8e <strtol+0x9a>
		s++;
  800e3e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e41:	bf 00 00 00 00       	mov    $0x0,%edi
  800e46:	eb d5                	jmp    800e1d <strtol+0x29>
		s++, neg = 1;
  800e48:	83 c1 01             	add    $0x1,%ecx
  800e4b:	bf 01 00 00 00       	mov    $0x1,%edi
  800e50:	eb cb                	jmp    800e1d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e52:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e56:	74 0e                	je     800e66 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e58:	85 db                	test   %ebx,%ebx
  800e5a:	75 d8                	jne    800e34 <strtol+0x40>
		s++, base = 8;
  800e5c:	83 c1 01             	add    $0x1,%ecx
  800e5f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e64:	eb ce                	jmp    800e34 <strtol+0x40>
		s += 2, base = 16;
  800e66:	83 c1 02             	add    $0x2,%ecx
  800e69:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e6e:	eb c4                	jmp    800e34 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e70:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e73:	89 f3                	mov    %esi,%ebx
  800e75:	80 fb 19             	cmp    $0x19,%bl
  800e78:	77 29                	ja     800ea3 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e7a:	0f be d2             	movsbl %dl,%edx
  800e7d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e80:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e83:	7d 30                	jge    800eb5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e85:	83 c1 01             	add    $0x1,%ecx
  800e88:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e8c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e8e:	0f b6 11             	movzbl (%ecx),%edx
  800e91:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e94:	89 f3                	mov    %esi,%ebx
  800e96:	80 fb 09             	cmp    $0x9,%bl
  800e99:	77 d5                	ja     800e70 <strtol+0x7c>
			dig = *s - '0';
  800e9b:	0f be d2             	movsbl %dl,%edx
  800e9e:	83 ea 30             	sub    $0x30,%edx
  800ea1:	eb dd                	jmp    800e80 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ea3:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ea6:	89 f3                	mov    %esi,%ebx
  800ea8:	80 fb 19             	cmp    $0x19,%bl
  800eab:	77 08                	ja     800eb5 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ead:	0f be d2             	movsbl %dl,%edx
  800eb0:	83 ea 37             	sub    $0x37,%edx
  800eb3:	eb cb                	jmp    800e80 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800eb5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eb9:	74 05                	je     800ec0 <strtol+0xcc>
		*endptr = (char *) s;
  800ebb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ebe:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ec0:	89 c2                	mov    %eax,%edx
  800ec2:	f7 da                	neg    %edx
  800ec4:	85 ff                	test   %edi,%edi
  800ec6:	0f 45 c2             	cmovne %edx,%eax
}
  800ec9:	5b                   	pop    %ebx
  800eca:	5e                   	pop    %esi
  800ecb:	5f                   	pop    %edi
  800ecc:	5d                   	pop    %ebp
  800ecd:	c3                   	ret    
  800ece:	66 90                	xchg   %ax,%ax

00800ed0 <__udivdi3>:
  800ed0:	55                   	push   %ebp
  800ed1:	57                   	push   %edi
  800ed2:	56                   	push   %esi
  800ed3:	53                   	push   %ebx
  800ed4:	83 ec 1c             	sub    $0x1c,%esp
  800ed7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800edb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800edf:	8b 74 24 34          	mov    0x34(%esp),%esi
  800ee3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800ee7:	85 d2                	test   %edx,%edx
  800ee9:	75 4d                	jne    800f38 <__udivdi3+0x68>
  800eeb:	39 f3                	cmp    %esi,%ebx
  800eed:	76 19                	jbe    800f08 <__udivdi3+0x38>
  800eef:	31 ff                	xor    %edi,%edi
  800ef1:	89 e8                	mov    %ebp,%eax
  800ef3:	89 f2                	mov    %esi,%edx
  800ef5:	f7 f3                	div    %ebx
  800ef7:	89 fa                	mov    %edi,%edx
  800ef9:	83 c4 1c             	add    $0x1c,%esp
  800efc:	5b                   	pop    %ebx
  800efd:	5e                   	pop    %esi
  800efe:	5f                   	pop    %edi
  800eff:	5d                   	pop    %ebp
  800f00:	c3                   	ret    
  800f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f08:	89 d9                	mov    %ebx,%ecx
  800f0a:	85 db                	test   %ebx,%ebx
  800f0c:	75 0b                	jne    800f19 <__udivdi3+0x49>
  800f0e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f13:	31 d2                	xor    %edx,%edx
  800f15:	f7 f3                	div    %ebx
  800f17:	89 c1                	mov    %eax,%ecx
  800f19:	31 d2                	xor    %edx,%edx
  800f1b:	89 f0                	mov    %esi,%eax
  800f1d:	f7 f1                	div    %ecx
  800f1f:	89 c6                	mov    %eax,%esi
  800f21:	89 e8                	mov    %ebp,%eax
  800f23:	89 f7                	mov    %esi,%edi
  800f25:	f7 f1                	div    %ecx
  800f27:	89 fa                	mov    %edi,%edx
  800f29:	83 c4 1c             	add    $0x1c,%esp
  800f2c:	5b                   	pop    %ebx
  800f2d:	5e                   	pop    %esi
  800f2e:	5f                   	pop    %edi
  800f2f:	5d                   	pop    %ebp
  800f30:	c3                   	ret    
  800f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f38:	39 f2                	cmp    %esi,%edx
  800f3a:	77 1c                	ja     800f58 <__udivdi3+0x88>
  800f3c:	0f bd fa             	bsr    %edx,%edi
  800f3f:	83 f7 1f             	xor    $0x1f,%edi
  800f42:	75 2c                	jne    800f70 <__udivdi3+0xa0>
  800f44:	39 f2                	cmp    %esi,%edx
  800f46:	72 06                	jb     800f4e <__udivdi3+0x7e>
  800f48:	31 c0                	xor    %eax,%eax
  800f4a:	39 eb                	cmp    %ebp,%ebx
  800f4c:	77 a9                	ja     800ef7 <__udivdi3+0x27>
  800f4e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f53:	eb a2                	jmp    800ef7 <__udivdi3+0x27>
  800f55:	8d 76 00             	lea    0x0(%esi),%esi
  800f58:	31 ff                	xor    %edi,%edi
  800f5a:	31 c0                	xor    %eax,%eax
  800f5c:	89 fa                	mov    %edi,%edx
  800f5e:	83 c4 1c             	add    $0x1c,%esp
  800f61:	5b                   	pop    %ebx
  800f62:	5e                   	pop    %esi
  800f63:	5f                   	pop    %edi
  800f64:	5d                   	pop    %ebp
  800f65:	c3                   	ret    
  800f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f6d:	8d 76 00             	lea    0x0(%esi),%esi
  800f70:	89 f9                	mov    %edi,%ecx
  800f72:	b8 20 00 00 00       	mov    $0x20,%eax
  800f77:	29 f8                	sub    %edi,%eax
  800f79:	d3 e2                	shl    %cl,%edx
  800f7b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f7f:	89 c1                	mov    %eax,%ecx
  800f81:	89 da                	mov    %ebx,%edx
  800f83:	d3 ea                	shr    %cl,%edx
  800f85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800f89:	09 d1                	or     %edx,%ecx
  800f8b:	89 f2                	mov    %esi,%edx
  800f8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f91:	89 f9                	mov    %edi,%ecx
  800f93:	d3 e3                	shl    %cl,%ebx
  800f95:	89 c1                	mov    %eax,%ecx
  800f97:	d3 ea                	shr    %cl,%edx
  800f99:	89 f9                	mov    %edi,%ecx
  800f9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800f9f:	89 eb                	mov    %ebp,%ebx
  800fa1:	d3 e6                	shl    %cl,%esi
  800fa3:	89 c1                	mov    %eax,%ecx
  800fa5:	d3 eb                	shr    %cl,%ebx
  800fa7:	09 de                	or     %ebx,%esi
  800fa9:	89 f0                	mov    %esi,%eax
  800fab:	f7 74 24 08          	divl   0x8(%esp)
  800faf:	89 d6                	mov    %edx,%esi
  800fb1:	89 c3                	mov    %eax,%ebx
  800fb3:	f7 64 24 0c          	mull   0xc(%esp)
  800fb7:	39 d6                	cmp    %edx,%esi
  800fb9:	72 15                	jb     800fd0 <__udivdi3+0x100>
  800fbb:	89 f9                	mov    %edi,%ecx
  800fbd:	d3 e5                	shl    %cl,%ebp
  800fbf:	39 c5                	cmp    %eax,%ebp
  800fc1:	73 04                	jae    800fc7 <__udivdi3+0xf7>
  800fc3:	39 d6                	cmp    %edx,%esi
  800fc5:	74 09                	je     800fd0 <__udivdi3+0x100>
  800fc7:	89 d8                	mov    %ebx,%eax
  800fc9:	31 ff                	xor    %edi,%edi
  800fcb:	e9 27 ff ff ff       	jmp    800ef7 <__udivdi3+0x27>
  800fd0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800fd3:	31 ff                	xor    %edi,%edi
  800fd5:	e9 1d ff ff ff       	jmp    800ef7 <__udivdi3+0x27>
  800fda:	66 90                	xchg   %ax,%ax
  800fdc:	66 90                	xchg   %ax,%ax
  800fde:	66 90                	xchg   %ax,%ax

00800fe0 <__umoddi3>:
  800fe0:	55                   	push   %ebp
  800fe1:	57                   	push   %edi
  800fe2:	56                   	push   %esi
  800fe3:	53                   	push   %ebx
  800fe4:	83 ec 1c             	sub    $0x1c,%esp
  800fe7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800feb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  800fef:	8b 74 24 30          	mov    0x30(%esp),%esi
  800ff3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800ff7:	89 da                	mov    %ebx,%edx
  800ff9:	85 c0                	test   %eax,%eax
  800ffb:	75 43                	jne    801040 <__umoddi3+0x60>
  800ffd:	39 df                	cmp    %ebx,%edi
  800fff:	76 17                	jbe    801018 <__umoddi3+0x38>
  801001:	89 f0                	mov    %esi,%eax
  801003:	f7 f7                	div    %edi
  801005:	89 d0                	mov    %edx,%eax
  801007:	31 d2                	xor    %edx,%edx
  801009:	83 c4 1c             	add    $0x1c,%esp
  80100c:	5b                   	pop    %ebx
  80100d:	5e                   	pop    %esi
  80100e:	5f                   	pop    %edi
  80100f:	5d                   	pop    %ebp
  801010:	c3                   	ret    
  801011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801018:	89 fd                	mov    %edi,%ebp
  80101a:	85 ff                	test   %edi,%edi
  80101c:	75 0b                	jne    801029 <__umoddi3+0x49>
  80101e:	b8 01 00 00 00       	mov    $0x1,%eax
  801023:	31 d2                	xor    %edx,%edx
  801025:	f7 f7                	div    %edi
  801027:	89 c5                	mov    %eax,%ebp
  801029:	89 d8                	mov    %ebx,%eax
  80102b:	31 d2                	xor    %edx,%edx
  80102d:	f7 f5                	div    %ebp
  80102f:	89 f0                	mov    %esi,%eax
  801031:	f7 f5                	div    %ebp
  801033:	89 d0                	mov    %edx,%eax
  801035:	eb d0                	jmp    801007 <__umoddi3+0x27>
  801037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80103e:	66 90                	xchg   %ax,%ax
  801040:	89 f1                	mov    %esi,%ecx
  801042:	39 d8                	cmp    %ebx,%eax
  801044:	76 0a                	jbe    801050 <__umoddi3+0x70>
  801046:	89 f0                	mov    %esi,%eax
  801048:	83 c4 1c             	add    $0x1c,%esp
  80104b:	5b                   	pop    %ebx
  80104c:	5e                   	pop    %esi
  80104d:	5f                   	pop    %edi
  80104e:	5d                   	pop    %ebp
  80104f:	c3                   	ret    
  801050:	0f bd e8             	bsr    %eax,%ebp
  801053:	83 f5 1f             	xor    $0x1f,%ebp
  801056:	75 20                	jne    801078 <__umoddi3+0x98>
  801058:	39 d8                	cmp    %ebx,%eax
  80105a:	0f 82 b0 00 00 00    	jb     801110 <__umoddi3+0x130>
  801060:	39 f7                	cmp    %esi,%edi
  801062:	0f 86 a8 00 00 00    	jbe    801110 <__umoddi3+0x130>
  801068:	89 c8                	mov    %ecx,%eax
  80106a:	83 c4 1c             	add    $0x1c,%esp
  80106d:	5b                   	pop    %ebx
  80106e:	5e                   	pop    %esi
  80106f:	5f                   	pop    %edi
  801070:	5d                   	pop    %ebp
  801071:	c3                   	ret    
  801072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801078:	89 e9                	mov    %ebp,%ecx
  80107a:	ba 20 00 00 00       	mov    $0x20,%edx
  80107f:	29 ea                	sub    %ebp,%edx
  801081:	d3 e0                	shl    %cl,%eax
  801083:	89 44 24 08          	mov    %eax,0x8(%esp)
  801087:	89 d1                	mov    %edx,%ecx
  801089:	89 f8                	mov    %edi,%eax
  80108b:	d3 e8                	shr    %cl,%eax
  80108d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801091:	89 54 24 04          	mov    %edx,0x4(%esp)
  801095:	8b 54 24 04          	mov    0x4(%esp),%edx
  801099:	09 c1                	or     %eax,%ecx
  80109b:	89 d8                	mov    %ebx,%eax
  80109d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010a1:	89 e9                	mov    %ebp,%ecx
  8010a3:	d3 e7                	shl    %cl,%edi
  8010a5:	89 d1                	mov    %edx,%ecx
  8010a7:	d3 e8                	shr    %cl,%eax
  8010a9:	89 e9                	mov    %ebp,%ecx
  8010ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8010af:	d3 e3                	shl    %cl,%ebx
  8010b1:	89 c7                	mov    %eax,%edi
  8010b3:	89 d1                	mov    %edx,%ecx
  8010b5:	89 f0                	mov    %esi,%eax
  8010b7:	d3 e8                	shr    %cl,%eax
  8010b9:	89 e9                	mov    %ebp,%ecx
  8010bb:	89 fa                	mov    %edi,%edx
  8010bd:	d3 e6                	shl    %cl,%esi
  8010bf:	09 d8                	or     %ebx,%eax
  8010c1:	f7 74 24 08          	divl   0x8(%esp)
  8010c5:	89 d1                	mov    %edx,%ecx
  8010c7:	89 f3                	mov    %esi,%ebx
  8010c9:	f7 64 24 0c          	mull   0xc(%esp)
  8010cd:	89 c6                	mov    %eax,%esi
  8010cf:	89 d7                	mov    %edx,%edi
  8010d1:	39 d1                	cmp    %edx,%ecx
  8010d3:	72 06                	jb     8010db <__umoddi3+0xfb>
  8010d5:	75 10                	jne    8010e7 <__umoddi3+0x107>
  8010d7:	39 c3                	cmp    %eax,%ebx
  8010d9:	73 0c                	jae    8010e7 <__umoddi3+0x107>
  8010db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8010df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8010e3:	89 d7                	mov    %edx,%edi
  8010e5:	89 c6                	mov    %eax,%esi
  8010e7:	89 ca                	mov    %ecx,%edx
  8010e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8010ee:	29 f3                	sub    %esi,%ebx
  8010f0:	19 fa                	sbb    %edi,%edx
  8010f2:	89 d0                	mov    %edx,%eax
  8010f4:	d3 e0                	shl    %cl,%eax
  8010f6:	89 e9                	mov    %ebp,%ecx
  8010f8:	d3 eb                	shr    %cl,%ebx
  8010fa:	d3 ea                	shr    %cl,%edx
  8010fc:	09 d8                	or     %ebx,%eax
  8010fe:	83 c4 1c             	add    $0x1c,%esp
  801101:	5b                   	pop    %ebx
  801102:	5e                   	pop    %esi
  801103:	5f                   	pop    %edi
  801104:	5d                   	pop    %ebp
  801105:	c3                   	ret    
  801106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80110d:	8d 76 00             	lea    0x0(%esi),%esi
  801110:	89 da                	mov    %ebx,%edx
  801112:	29 fe                	sub    %edi,%esi
  801114:	19 c2                	sbb    %eax,%edx
  801116:	89 f1                	mov    %esi,%ecx
  801118:	89 c8                	mov    %ecx,%eax
  80111a:	e9 4b ff ff ff       	jmp    80106a <__umoddi3+0x8a>
