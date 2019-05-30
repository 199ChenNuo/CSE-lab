
obj/user/buggyhello.debug:     file format elf32-i386


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
  80002c:	e8 16 00 00 00       	call   800047 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs((char*)1, 1);
  800039:	6a 01                	push   $0x1
  80003b:	6a 01                	push   $0x1
  80003d:	e8 60 00 00 00       	call   8000a2 <sys_cputs>
}
  800042:	83 c4 10             	add    $0x10,%esp
  800045:	c9                   	leave  
  800046:	c3                   	ret    

00800047 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800047:	55                   	push   %ebp
  800048:	89 e5                	mov    %esp,%ebp
  80004a:	56                   	push   %esi
  80004b:	53                   	push   %ebx
  80004c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004f:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  800052:	e8 c9 00 00 00       	call   800120 <sys_getenvid>
  800057:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005c:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800062:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800067:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006c:	85 db                	test   %ebx,%ebx
  80006e:	7e 07                	jle    800077 <libmain+0x30>
		binaryname = argv[0];
  800070:	8b 06                	mov    (%esi),%eax
  800072:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800077:	83 ec 08             	sub    $0x8,%esp
  80007a:	56                   	push   %esi
  80007b:	53                   	push   %ebx
  80007c:	e8 b2 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800081:	e8 0a 00 00 00       	call   800090 <exit>
}
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008c:	5b                   	pop    %ebx
  80008d:	5e                   	pop    %esi
  80008e:	5d                   	pop    %ebp
  80008f:	c3                   	ret    

00800090 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800090:	55                   	push   %ebp
  800091:	89 e5                	mov    %esp,%ebp
  800093:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800096:	6a 00                	push   $0x0
  800098:	e8 42 00 00 00       	call   8000df <sys_env_destroy>
}
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	57                   	push   %edi
  8000a6:	56                   	push   %esi
  8000a7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b3:	89 c3                	mov    %eax,%ebx
  8000b5:	89 c7                	mov    %eax,%edi
  8000b7:	89 c6                	mov    %eax,%esi
  8000b9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000bb:	5b                   	pop    %ebx
  8000bc:	5e                   	pop    %esi
  8000bd:	5f                   	pop    %edi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    

008000c0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	57                   	push   %edi
  8000c4:	56                   	push   %esi
  8000c5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d0:	89 d1                	mov    %edx,%ecx
  8000d2:	89 d3                	mov    %edx,%ebx
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	89 d6                	mov    %edx,%esi
  8000d8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000da:	5b                   	pop    %ebx
  8000db:	5e                   	pop    %esi
  8000dc:	5f                   	pop    %edi
  8000dd:	5d                   	pop    %ebp
  8000de:	c3                   	ret    

008000df <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000df:	55                   	push   %ebp
  8000e0:	89 e5                	mov    %esp,%ebp
  8000e2:	57                   	push   %edi
  8000e3:	56                   	push   %esi
  8000e4:	53                   	push   %ebx
  8000e5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f0:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f5:	89 cb                	mov    %ecx,%ebx
  8000f7:	89 cf                	mov    %ecx,%edi
  8000f9:	89 ce                	mov    %ecx,%esi
  8000fb:	cd 30                	int    $0x30
	if (check && ret > 0)
  8000fd:	85 c0                	test   %eax,%eax
  8000ff:	7f 08                	jg     800109 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800101:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800104:	5b                   	pop    %ebx
  800105:	5e                   	pop    %esi
  800106:	5f                   	pop    %edi
  800107:	5d                   	pop    %ebp
  800108:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	50                   	push   %eax
  80010d:	6a 03                	push   $0x3
  80010f:	68 2a 11 80 00       	push   $0x80112a
  800114:	6a 4c                	push   $0x4c
  800116:	68 47 11 80 00       	push   $0x801147
  80011b:	e8 70 02 00 00       	call   800390 <_panic>

00800120 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
  800123:	57                   	push   %edi
  800124:	56                   	push   %esi
  800125:	53                   	push   %ebx
	asm volatile("int %1\n"
  800126:	ba 00 00 00 00       	mov    $0x0,%edx
  80012b:	b8 02 00 00 00       	mov    $0x2,%eax
  800130:	89 d1                	mov    %edx,%ecx
  800132:	89 d3                	mov    %edx,%ebx
  800134:	89 d7                	mov    %edx,%edi
  800136:	89 d6                	mov    %edx,%esi
  800138:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80013a:	5b                   	pop    %ebx
  80013b:	5e                   	pop    %esi
  80013c:	5f                   	pop    %edi
  80013d:	5d                   	pop    %ebp
  80013e:	c3                   	ret    

0080013f <sys_yield>:

void
sys_yield(void)
{
  80013f:	55                   	push   %ebp
  800140:	89 e5                	mov    %esp,%ebp
  800142:	57                   	push   %edi
  800143:	56                   	push   %esi
  800144:	53                   	push   %ebx
	asm volatile("int %1\n"
  800145:	ba 00 00 00 00       	mov    $0x0,%edx
  80014a:	b8 0b 00 00 00       	mov    $0xb,%eax
  80014f:	89 d1                	mov    %edx,%ecx
  800151:	89 d3                	mov    %edx,%ebx
  800153:	89 d7                	mov    %edx,%edi
  800155:	89 d6                	mov    %edx,%esi
  800157:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800159:	5b                   	pop    %ebx
  80015a:	5e                   	pop    %esi
  80015b:	5f                   	pop    %edi
  80015c:	5d                   	pop    %ebp
  80015d:	c3                   	ret    

0080015e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80015e:	55                   	push   %ebp
  80015f:	89 e5                	mov    %esp,%ebp
  800161:	57                   	push   %edi
  800162:	56                   	push   %esi
  800163:	53                   	push   %ebx
  800164:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800167:	be 00 00 00 00       	mov    $0x0,%esi
  80016c:	8b 55 08             	mov    0x8(%ebp),%edx
  80016f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800172:	b8 04 00 00 00       	mov    $0x4,%eax
  800177:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80017a:	89 f7                	mov    %esi,%edi
  80017c:	cd 30                	int    $0x30
	if (check && ret > 0)
  80017e:	85 c0                	test   %eax,%eax
  800180:	7f 08                	jg     80018a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800182:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800185:	5b                   	pop    %ebx
  800186:	5e                   	pop    %esi
  800187:	5f                   	pop    %edi
  800188:	5d                   	pop    %ebp
  800189:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	50                   	push   %eax
  80018e:	6a 04                	push   $0x4
  800190:	68 2a 11 80 00       	push   $0x80112a
  800195:	6a 4c                	push   $0x4c
  800197:	68 47 11 80 00       	push   $0x801147
  80019c:	e8 ef 01 00 00       	call   800390 <_panic>

008001a1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001a1:	55                   	push   %ebp
  8001a2:	89 e5                	mov    %esp,%ebp
  8001a4:	57                   	push   %edi
  8001a5:	56                   	push   %esi
  8001a6:	53                   	push   %ebx
  8001a7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b0:	b8 05 00 00 00       	mov    $0x5,%eax
  8001b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001bb:	8b 75 18             	mov    0x18(%ebp),%esi
  8001be:	cd 30                	int    $0x30
	if (check && ret > 0)
  8001c0:	85 c0                	test   %eax,%eax
  8001c2:	7f 08                	jg     8001cc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c7:	5b                   	pop    %ebx
  8001c8:	5e                   	pop    %esi
  8001c9:	5f                   	pop    %edi
  8001ca:	5d                   	pop    %ebp
  8001cb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	50                   	push   %eax
  8001d0:	6a 05                	push   $0x5
  8001d2:	68 2a 11 80 00       	push   $0x80112a
  8001d7:	6a 4c                	push   $0x4c
  8001d9:	68 47 11 80 00       	push   $0x801147
  8001de:	e8 ad 01 00 00       	call   800390 <_panic>

008001e3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001e3:	55                   	push   %ebp
  8001e4:	89 e5                	mov    %esp,%ebp
  8001e6:	57                   	push   %edi
  8001e7:	56                   	push   %esi
  8001e8:	53                   	push   %ebx
  8001e9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f7:	b8 06 00 00 00       	mov    $0x6,%eax
  8001fc:	89 df                	mov    %ebx,%edi
  8001fe:	89 de                	mov    %ebx,%esi
  800200:	cd 30                	int    $0x30
	if (check && ret > 0)
  800202:	85 c0                	test   %eax,%eax
  800204:	7f 08                	jg     80020e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800206:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800209:	5b                   	pop    %ebx
  80020a:	5e                   	pop    %esi
  80020b:	5f                   	pop    %edi
  80020c:	5d                   	pop    %ebp
  80020d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80020e:	83 ec 0c             	sub    $0xc,%esp
  800211:	50                   	push   %eax
  800212:	6a 06                	push   $0x6
  800214:	68 2a 11 80 00       	push   $0x80112a
  800219:	6a 4c                	push   $0x4c
  80021b:	68 47 11 80 00       	push   $0x801147
  800220:	e8 6b 01 00 00       	call   800390 <_panic>

00800225 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	57                   	push   %edi
  800229:	56                   	push   %esi
  80022a:	53                   	push   %ebx
  80022b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80022e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800233:	8b 55 08             	mov    0x8(%ebp),%edx
  800236:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800239:	b8 08 00 00 00       	mov    $0x8,%eax
  80023e:	89 df                	mov    %ebx,%edi
  800240:	89 de                	mov    %ebx,%esi
  800242:	cd 30                	int    $0x30
	if (check && ret > 0)
  800244:	85 c0                	test   %eax,%eax
  800246:	7f 08                	jg     800250 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800248:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024b:	5b                   	pop    %ebx
  80024c:	5e                   	pop    %esi
  80024d:	5f                   	pop    %edi
  80024e:	5d                   	pop    %ebp
  80024f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800250:	83 ec 0c             	sub    $0xc,%esp
  800253:	50                   	push   %eax
  800254:	6a 08                	push   $0x8
  800256:	68 2a 11 80 00       	push   $0x80112a
  80025b:	6a 4c                	push   $0x4c
  80025d:	68 47 11 80 00       	push   $0x801147
  800262:	e8 29 01 00 00       	call   800390 <_panic>

00800267 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	57                   	push   %edi
  80026b:	56                   	push   %esi
  80026c:	53                   	push   %ebx
  80026d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800270:	bb 00 00 00 00       	mov    $0x0,%ebx
  800275:	8b 55 08             	mov    0x8(%ebp),%edx
  800278:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80027b:	b8 09 00 00 00       	mov    $0x9,%eax
  800280:	89 df                	mov    %ebx,%edi
  800282:	89 de                	mov    %ebx,%esi
  800284:	cd 30                	int    $0x30
	if (check && ret > 0)
  800286:	85 c0                	test   %eax,%eax
  800288:	7f 08                	jg     800292 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80028a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028d:	5b                   	pop    %ebx
  80028e:	5e                   	pop    %esi
  80028f:	5f                   	pop    %edi
  800290:	5d                   	pop    %ebp
  800291:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	50                   	push   %eax
  800296:	6a 09                	push   $0x9
  800298:	68 2a 11 80 00       	push   $0x80112a
  80029d:	6a 4c                	push   $0x4c
  80029f:	68 47 11 80 00       	push   $0x801147
  8002a4:	e8 e7 00 00 00       	call   800390 <_panic>

008002a9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	57                   	push   %edi
  8002ad:	56                   	push   %esi
  8002ae:	53                   	push   %ebx
  8002af:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002bd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002c2:	89 df                	mov    %ebx,%edi
  8002c4:	89 de                	mov    %ebx,%esi
  8002c6:	cd 30                	int    $0x30
	if (check && ret > 0)
  8002c8:	85 c0                	test   %eax,%eax
  8002ca:	7f 08                	jg     8002d4 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cf:	5b                   	pop    %ebx
  8002d0:	5e                   	pop    %esi
  8002d1:	5f                   	pop    %edi
  8002d2:	5d                   	pop    %ebp
  8002d3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	50                   	push   %eax
  8002d8:	6a 0a                	push   $0xa
  8002da:	68 2a 11 80 00       	push   $0x80112a
  8002df:	6a 4c                	push   $0x4c
  8002e1:	68 47 11 80 00       	push   $0x801147
  8002e6:	e8 a5 00 00 00       	call   800390 <_panic>

008002eb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002eb:	55                   	push   %ebp
  8002ec:	89 e5                	mov    %esp,%ebp
  8002ee:	57                   	push   %edi
  8002ef:	56                   	push   %esi
  8002f0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002fc:	be 00 00 00 00       	mov    $0x0,%esi
  800301:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800304:	8b 7d 14             	mov    0x14(%ebp),%edi
  800307:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800309:	5b                   	pop    %ebx
  80030a:	5e                   	pop    %esi
  80030b:	5f                   	pop    %edi
  80030c:	5d                   	pop    %ebp
  80030d:	c3                   	ret    

0080030e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	57                   	push   %edi
  800312:	56                   	push   %esi
  800313:	53                   	push   %ebx
  800314:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800317:	b9 00 00 00 00       	mov    $0x0,%ecx
  80031c:	8b 55 08             	mov    0x8(%ebp),%edx
  80031f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800324:	89 cb                	mov    %ecx,%ebx
  800326:	89 cf                	mov    %ecx,%edi
  800328:	89 ce                	mov    %ecx,%esi
  80032a:	cd 30                	int    $0x30
	if (check && ret > 0)
  80032c:	85 c0                	test   %eax,%eax
  80032e:	7f 08                	jg     800338 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800330:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800333:	5b                   	pop    %ebx
  800334:	5e                   	pop    %esi
  800335:	5f                   	pop    %edi
  800336:	5d                   	pop    %ebp
  800337:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800338:	83 ec 0c             	sub    $0xc,%esp
  80033b:	50                   	push   %eax
  80033c:	6a 0d                	push   $0xd
  80033e:	68 2a 11 80 00       	push   $0x80112a
  800343:	6a 4c                	push   $0x4c
  800345:	68 47 11 80 00       	push   $0x801147
  80034a:	e8 41 00 00 00       	call   800390 <_panic>

0080034f <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
  800352:	57                   	push   %edi
  800353:	56                   	push   %esi
  800354:	53                   	push   %ebx
	asm volatile("int %1\n"
  800355:	bb 00 00 00 00       	mov    $0x0,%ebx
  80035a:	8b 55 08             	mov    0x8(%ebp),%edx
  80035d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800360:	b8 0e 00 00 00       	mov    $0xe,%eax
  800365:	89 df                	mov    %ebx,%edi
  800367:	89 de                	mov    %ebx,%esi
  800369:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80036b:	5b                   	pop    %ebx
  80036c:	5e                   	pop    %esi
  80036d:	5f                   	pop    %edi
  80036e:	5d                   	pop    %ebp
  80036f:	c3                   	ret    

00800370 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
  800373:	57                   	push   %edi
  800374:	56                   	push   %esi
  800375:	53                   	push   %ebx
	asm volatile("int %1\n"
  800376:	b9 00 00 00 00       	mov    $0x0,%ecx
  80037b:	8b 55 08             	mov    0x8(%ebp),%edx
  80037e:	b8 0f 00 00 00       	mov    $0xf,%eax
  800383:	89 cb                	mov    %ecx,%ebx
  800385:	89 cf                	mov    %ecx,%edi
  800387:	89 ce                	mov    %ecx,%esi
  800389:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80038b:	5b                   	pop    %ebx
  80038c:	5e                   	pop    %esi
  80038d:	5f                   	pop    %edi
  80038e:	5d                   	pop    %ebp
  80038f:	c3                   	ret    

00800390 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	56                   	push   %esi
  800394:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800395:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800398:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80039e:	e8 7d fd ff ff       	call   800120 <sys_getenvid>
  8003a3:	83 ec 0c             	sub    $0xc,%esp
  8003a6:	ff 75 0c             	pushl  0xc(%ebp)
  8003a9:	ff 75 08             	pushl  0x8(%ebp)
  8003ac:	56                   	push   %esi
  8003ad:	50                   	push   %eax
  8003ae:	68 58 11 80 00       	push   $0x801158
  8003b3:	e8 b3 00 00 00       	call   80046b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003b8:	83 c4 18             	add    $0x18,%esp
  8003bb:	53                   	push   %ebx
  8003bc:	ff 75 10             	pushl  0x10(%ebp)
  8003bf:	e8 56 00 00 00       	call   80041a <vcprintf>
	cprintf("\n");
  8003c4:	c7 04 24 7b 11 80 00 	movl   $0x80117b,(%esp)
  8003cb:	e8 9b 00 00 00       	call   80046b <cprintf>
  8003d0:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003d3:	cc                   	int3   
  8003d4:	eb fd                	jmp    8003d3 <_panic+0x43>

008003d6 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003d6:	55                   	push   %ebp
  8003d7:	89 e5                	mov    %esp,%ebp
  8003d9:	53                   	push   %ebx
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003e0:	8b 13                	mov    (%ebx),%edx
  8003e2:	8d 42 01             	lea    0x1(%edx),%eax
  8003e5:	89 03                	mov    %eax,(%ebx)
  8003e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003ea:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003ee:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003f3:	74 09                	je     8003fe <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003f5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003fc:	c9                   	leave  
  8003fd:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003fe:	83 ec 08             	sub    $0x8,%esp
  800401:	68 ff 00 00 00       	push   $0xff
  800406:	8d 43 08             	lea    0x8(%ebx),%eax
  800409:	50                   	push   %eax
  80040a:	e8 93 fc ff ff       	call   8000a2 <sys_cputs>
		b->idx = 0;
  80040f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800415:	83 c4 10             	add    $0x10,%esp
  800418:	eb db                	jmp    8003f5 <putch+0x1f>

0080041a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80041a:	55                   	push   %ebp
  80041b:	89 e5                	mov    %esp,%ebp
  80041d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800423:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80042a:	00 00 00 
	b.cnt = 0;
  80042d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800434:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800437:	ff 75 0c             	pushl  0xc(%ebp)
  80043a:	ff 75 08             	pushl  0x8(%ebp)
  80043d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800443:	50                   	push   %eax
  800444:	68 d6 03 80 00       	push   $0x8003d6
  800449:	e8 4a 01 00 00       	call   800598 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80044e:	83 c4 08             	add    $0x8,%esp
  800451:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800457:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80045d:	50                   	push   %eax
  80045e:	e8 3f fc ff ff       	call   8000a2 <sys_cputs>

	return b.cnt;
}
  800463:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800469:	c9                   	leave  
  80046a:	c3                   	ret    

0080046b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80046b:	55                   	push   %ebp
  80046c:	89 e5                	mov    %esp,%ebp
  80046e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800471:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800474:	50                   	push   %eax
  800475:	ff 75 08             	pushl  0x8(%ebp)
  800478:	e8 9d ff ff ff       	call   80041a <vcprintf>
	va_end(ap);

	return cnt;
}
  80047d:	c9                   	leave  
  80047e:	c3                   	ret    

0080047f <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80047f:	55                   	push   %ebp
  800480:	89 e5                	mov    %esp,%ebp
  800482:	57                   	push   %edi
  800483:	56                   	push   %esi
  800484:	53                   	push   %ebx
  800485:	83 ec 1c             	sub    $0x1c,%esp
  800488:	89 c6                	mov    %eax,%esi
  80048a:	89 d7                	mov    %edx,%edi
  80048c:	8b 45 08             	mov    0x8(%ebp),%eax
  80048f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800492:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800495:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800498:	8b 45 10             	mov    0x10(%ebp),%eax
  80049b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  80049e:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8004a2:	74 2c                	je     8004d0 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004a7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004ae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004b4:	39 c2                	cmp    %eax,%edx
  8004b6:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8004b9:	73 43                	jae    8004fe <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004bb:	83 eb 01             	sub    $0x1,%ebx
  8004be:	85 db                	test   %ebx,%ebx
  8004c0:	7e 6c                	jle    80052e <printnum+0xaf>
			putch(padc, putdat);
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	57                   	push   %edi
  8004c6:	ff 75 18             	pushl  0x18(%ebp)
  8004c9:	ff d6                	call   *%esi
  8004cb:	83 c4 10             	add    $0x10,%esp
  8004ce:	eb eb                	jmp    8004bb <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8004d0:	83 ec 0c             	sub    $0xc,%esp
  8004d3:	6a 20                	push   $0x20
  8004d5:	6a 00                	push   $0x0
  8004d7:	50                   	push   %eax
  8004d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004db:	ff 75 e0             	pushl  -0x20(%ebp)
  8004de:	89 fa                	mov    %edi,%edx
  8004e0:	89 f0                	mov    %esi,%eax
  8004e2:	e8 98 ff ff ff       	call   80047f <printnum>
		while (--width > 0)
  8004e7:	83 c4 20             	add    $0x20,%esp
  8004ea:	83 eb 01             	sub    $0x1,%ebx
  8004ed:	85 db                	test   %ebx,%ebx
  8004ef:	7e 65                	jle    800556 <printnum+0xd7>
			putch(' ', putdat);
  8004f1:	83 ec 08             	sub    $0x8,%esp
  8004f4:	57                   	push   %edi
  8004f5:	6a 20                	push   $0x20
  8004f7:	ff d6                	call   *%esi
  8004f9:	83 c4 10             	add    $0x10,%esp
  8004fc:	eb ec                	jmp    8004ea <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004fe:	83 ec 0c             	sub    $0xc,%esp
  800501:	ff 75 18             	pushl  0x18(%ebp)
  800504:	83 eb 01             	sub    $0x1,%ebx
  800507:	53                   	push   %ebx
  800508:	50                   	push   %eax
  800509:	83 ec 08             	sub    $0x8,%esp
  80050c:	ff 75 dc             	pushl  -0x24(%ebp)
  80050f:	ff 75 d8             	pushl  -0x28(%ebp)
  800512:	ff 75 e4             	pushl  -0x1c(%ebp)
  800515:	ff 75 e0             	pushl  -0x20(%ebp)
  800518:	e8 b3 09 00 00       	call   800ed0 <__udivdi3>
  80051d:	83 c4 18             	add    $0x18,%esp
  800520:	52                   	push   %edx
  800521:	50                   	push   %eax
  800522:	89 fa                	mov    %edi,%edx
  800524:	89 f0                	mov    %esi,%eax
  800526:	e8 54 ff ff ff       	call   80047f <printnum>
  80052b:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80052e:	83 ec 08             	sub    $0x8,%esp
  800531:	57                   	push   %edi
  800532:	83 ec 04             	sub    $0x4,%esp
  800535:	ff 75 dc             	pushl  -0x24(%ebp)
  800538:	ff 75 d8             	pushl  -0x28(%ebp)
  80053b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80053e:	ff 75 e0             	pushl  -0x20(%ebp)
  800541:	e8 9a 0a 00 00       	call   800fe0 <__umoddi3>
  800546:	83 c4 14             	add    $0x14,%esp
  800549:	0f be 80 7d 11 80 00 	movsbl 0x80117d(%eax),%eax
  800550:	50                   	push   %eax
  800551:	ff d6                	call   *%esi
  800553:	83 c4 10             	add    $0x10,%esp
}
  800556:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800559:	5b                   	pop    %ebx
  80055a:	5e                   	pop    %esi
  80055b:	5f                   	pop    %edi
  80055c:	5d                   	pop    %ebp
  80055d:	c3                   	ret    

0080055e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800564:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800568:	8b 10                	mov    (%eax),%edx
  80056a:	3b 50 04             	cmp    0x4(%eax),%edx
  80056d:	73 0a                	jae    800579 <sprintputch+0x1b>
		*b->buf++ = ch;
  80056f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800572:	89 08                	mov    %ecx,(%eax)
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	88 02                	mov    %al,(%edx)
}
  800579:	5d                   	pop    %ebp
  80057a:	c3                   	ret    

0080057b <printfmt>:
{
  80057b:	55                   	push   %ebp
  80057c:	89 e5                	mov    %esp,%ebp
  80057e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800581:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800584:	50                   	push   %eax
  800585:	ff 75 10             	pushl  0x10(%ebp)
  800588:	ff 75 0c             	pushl  0xc(%ebp)
  80058b:	ff 75 08             	pushl  0x8(%ebp)
  80058e:	e8 05 00 00 00       	call   800598 <vprintfmt>
}
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	c9                   	leave  
  800597:	c3                   	ret    

00800598 <vprintfmt>:
{
  800598:	55                   	push   %ebp
  800599:	89 e5                	mov    %esp,%ebp
  80059b:	57                   	push   %edi
  80059c:	56                   	push   %esi
  80059d:	53                   	push   %ebx
  80059e:	83 ec 3c             	sub    $0x3c,%esp
  8005a1:	8b 75 08             	mov    0x8(%ebp),%esi
  8005a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005a7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005aa:	e9 1e 04 00 00       	jmp    8009cd <vprintfmt+0x435>
		posflag = 0;
  8005af:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  8005b6:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8005ba:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8005c1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8005c8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005cf:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8005d6:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005db:	8d 47 01             	lea    0x1(%edi),%eax
  8005de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005e1:	0f b6 17             	movzbl (%edi),%edx
  8005e4:	8d 42 dd             	lea    -0x23(%edx),%eax
  8005e7:	3c 55                	cmp    $0x55,%al
  8005e9:	0f 87 d9 04 00 00    	ja     800ac8 <vprintfmt+0x530>
  8005ef:	0f b6 c0             	movzbl %al,%eax
  8005f2:	ff 24 85 60 13 80 00 	jmp    *0x801360(,%eax,4)
  8005f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8005fc:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800600:	eb d9                	jmp    8005db <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800602:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  800605:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  80060c:	eb cd                	jmp    8005db <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80060e:	0f b6 d2             	movzbl %dl,%edx
  800611:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800614:	b8 00 00 00 00       	mov    $0x0,%eax
  800619:	89 75 08             	mov    %esi,0x8(%ebp)
  80061c:	eb 0c                	jmp    80062a <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  80061e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800621:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800625:	eb b4                	jmp    8005db <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  800627:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80062a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80062d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800631:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800634:	8d 72 d0             	lea    -0x30(%edx),%esi
  800637:	83 fe 09             	cmp    $0x9,%esi
  80063a:	76 eb                	jbe    800627 <vprintfmt+0x8f>
  80063c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063f:	8b 75 08             	mov    0x8(%ebp),%esi
  800642:	eb 14                	jmp    800658 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8b 00                	mov    (%eax),%eax
  800649:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	8d 40 04             	lea    0x4(%eax),%eax
  800652:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800655:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800658:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80065c:	0f 89 79 ff ff ff    	jns    8005db <vprintfmt+0x43>
				width = precision, precision = -1;
  800662:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800665:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800668:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80066f:	e9 67 ff ff ff       	jmp    8005db <vprintfmt+0x43>
  800674:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800677:	85 c0                	test   %eax,%eax
  800679:	0f 48 c1             	cmovs  %ecx,%eax
  80067c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80067f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800682:	e9 54 ff ff ff       	jmp    8005db <vprintfmt+0x43>
  800687:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80068a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800691:	e9 45 ff ff ff       	jmp    8005db <vprintfmt+0x43>
			lflag++;
  800696:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80069a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80069d:	e9 39 ff ff ff       	jmp    8005db <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8d 78 04             	lea    0x4(%eax),%edi
  8006a8:	83 ec 08             	sub    $0x8,%esp
  8006ab:	53                   	push   %ebx
  8006ac:	ff 30                	pushl  (%eax)
  8006ae:	ff d6                	call   *%esi
			break;
  8006b0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006b3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006b6:	e9 0f 03 00 00       	jmp    8009ca <vprintfmt+0x432>
			err = va_arg(ap, int);
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	8d 78 04             	lea    0x4(%eax),%edi
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	99                   	cltd   
  8006c4:	31 d0                	xor    %edx,%eax
  8006c6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006c8:	83 f8 0f             	cmp    $0xf,%eax
  8006cb:	7f 23                	jg     8006f0 <vprintfmt+0x158>
  8006cd:	8b 14 85 c0 14 80 00 	mov    0x8014c0(,%eax,4),%edx
  8006d4:	85 d2                	test   %edx,%edx
  8006d6:	74 18                	je     8006f0 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  8006d8:	52                   	push   %edx
  8006d9:	68 9e 11 80 00       	push   $0x80119e
  8006de:	53                   	push   %ebx
  8006df:	56                   	push   %esi
  8006e0:	e8 96 fe ff ff       	call   80057b <printfmt>
  8006e5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006e8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8006eb:	e9 da 02 00 00       	jmp    8009ca <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  8006f0:	50                   	push   %eax
  8006f1:	68 95 11 80 00       	push   $0x801195
  8006f6:	53                   	push   %ebx
  8006f7:	56                   	push   %esi
  8006f8:	e8 7e fe ff ff       	call   80057b <printfmt>
  8006fd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800700:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800703:	e9 c2 02 00 00       	jmp    8009ca <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	83 c0 04             	add    $0x4,%eax
  80070e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800716:	85 c9                	test   %ecx,%ecx
  800718:	b8 8e 11 80 00       	mov    $0x80118e,%eax
  80071d:	0f 45 c1             	cmovne %ecx,%eax
  800720:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800723:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800727:	7e 06                	jle    80072f <vprintfmt+0x197>
  800729:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80072d:	75 0d                	jne    80073c <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  80072f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800732:	89 c7                	mov    %eax,%edi
  800734:	03 45 e0             	add    -0x20(%ebp),%eax
  800737:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80073a:	eb 53                	jmp    80078f <vprintfmt+0x1f7>
  80073c:	83 ec 08             	sub    $0x8,%esp
  80073f:	ff 75 d8             	pushl  -0x28(%ebp)
  800742:	50                   	push   %eax
  800743:	e8 28 04 00 00       	call   800b70 <strnlen>
  800748:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80074b:	29 c1                	sub    %eax,%ecx
  80074d:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800750:	83 c4 10             	add    $0x10,%esp
  800753:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800755:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800759:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80075c:	eb 0f                	jmp    80076d <vprintfmt+0x1d5>
					putch(padc, putdat);
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	53                   	push   %ebx
  800762:	ff 75 e0             	pushl  -0x20(%ebp)
  800765:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800767:	83 ef 01             	sub    $0x1,%edi
  80076a:	83 c4 10             	add    $0x10,%esp
  80076d:	85 ff                	test   %edi,%edi
  80076f:	7f ed                	jg     80075e <vprintfmt+0x1c6>
  800771:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800774:	85 c9                	test   %ecx,%ecx
  800776:	b8 00 00 00 00       	mov    $0x0,%eax
  80077b:	0f 49 c1             	cmovns %ecx,%eax
  80077e:	29 c1                	sub    %eax,%ecx
  800780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800783:	eb aa                	jmp    80072f <vprintfmt+0x197>
					putch(ch, putdat);
  800785:	83 ec 08             	sub    $0x8,%esp
  800788:	53                   	push   %ebx
  800789:	52                   	push   %edx
  80078a:	ff d6                	call   *%esi
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800792:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800794:	83 c7 01             	add    $0x1,%edi
  800797:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80079b:	0f be d0             	movsbl %al,%edx
  80079e:	85 d2                	test   %edx,%edx
  8007a0:	74 4b                	je     8007ed <vprintfmt+0x255>
  8007a2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007a6:	78 06                	js     8007ae <vprintfmt+0x216>
  8007a8:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007ac:	78 1e                	js     8007cc <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  8007ae:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007b2:	74 d1                	je     800785 <vprintfmt+0x1ed>
  8007b4:	0f be c0             	movsbl %al,%eax
  8007b7:	83 e8 20             	sub    $0x20,%eax
  8007ba:	83 f8 5e             	cmp    $0x5e,%eax
  8007bd:	76 c6                	jbe    800785 <vprintfmt+0x1ed>
					putch('?', putdat);
  8007bf:	83 ec 08             	sub    $0x8,%esp
  8007c2:	53                   	push   %ebx
  8007c3:	6a 3f                	push   $0x3f
  8007c5:	ff d6                	call   *%esi
  8007c7:	83 c4 10             	add    $0x10,%esp
  8007ca:	eb c3                	jmp    80078f <vprintfmt+0x1f7>
  8007cc:	89 cf                	mov    %ecx,%edi
  8007ce:	eb 0e                	jmp    8007de <vprintfmt+0x246>
				putch(' ', putdat);
  8007d0:	83 ec 08             	sub    $0x8,%esp
  8007d3:	53                   	push   %ebx
  8007d4:	6a 20                	push   $0x20
  8007d6:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8007d8:	83 ef 01             	sub    $0x1,%edi
  8007db:	83 c4 10             	add    $0x10,%esp
  8007de:	85 ff                	test   %edi,%edi
  8007e0:	7f ee                	jg     8007d0 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  8007e2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e8:	e9 dd 01 00 00       	jmp    8009ca <vprintfmt+0x432>
  8007ed:	89 cf                	mov    %ecx,%edi
  8007ef:	eb ed                	jmp    8007de <vprintfmt+0x246>
	if (lflag >= 2)
  8007f1:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8007f5:	7f 21                	jg     800818 <vprintfmt+0x280>
	else if (lflag)
  8007f7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8007fb:	74 6a                	je     800867 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  8007fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800800:	8b 00                	mov    (%eax),%eax
  800802:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800805:	89 c1                	mov    %eax,%ecx
  800807:	c1 f9 1f             	sar    $0x1f,%ecx
  80080a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	8d 40 04             	lea    0x4(%eax),%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
  800816:	eb 17                	jmp    80082f <vprintfmt+0x297>
		return va_arg(*ap, long long);
  800818:	8b 45 14             	mov    0x14(%ebp),%eax
  80081b:	8b 50 04             	mov    0x4(%eax),%edx
  80081e:	8b 00                	mov    (%eax),%eax
  800820:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800823:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800826:	8b 45 14             	mov    0x14(%ebp),%eax
  800829:	8d 40 08             	lea    0x8(%eax),%eax
  80082c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80082f:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800832:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800837:	85 d2                	test   %edx,%edx
  800839:	0f 89 5c 01 00 00    	jns    80099b <vprintfmt+0x403>
				putch('-', putdat);
  80083f:	83 ec 08             	sub    $0x8,%esp
  800842:	53                   	push   %ebx
  800843:	6a 2d                	push   $0x2d
  800845:	ff d6                	call   *%esi
				num = -(long long) num;
  800847:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80084a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80084d:	f7 d8                	neg    %eax
  80084f:	83 d2 00             	adc    $0x0,%edx
  800852:	f7 da                	neg    %edx
  800854:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800857:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80085a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80085d:	bf 0a 00 00 00       	mov    $0xa,%edi
  800862:	e9 45 01 00 00       	jmp    8009ac <vprintfmt+0x414>
		return va_arg(*ap, int);
  800867:	8b 45 14             	mov    0x14(%ebp),%eax
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80086f:	89 c1                	mov    %eax,%ecx
  800871:	c1 f9 1f             	sar    $0x1f,%ecx
  800874:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	8d 40 04             	lea    0x4(%eax),%eax
  80087d:	89 45 14             	mov    %eax,0x14(%ebp)
  800880:	eb ad                	jmp    80082f <vprintfmt+0x297>
	if (lflag >= 2)
  800882:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800886:	7f 29                	jg     8008b1 <vprintfmt+0x319>
	else if (lflag)
  800888:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80088c:	74 44                	je     8008d2 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	8b 00                	mov    (%eax),%eax
  800893:	ba 00 00 00 00       	mov    $0x0,%edx
  800898:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80089e:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a1:	8d 40 04             	lea    0x4(%eax),%eax
  8008a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008a7:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008ac:	e9 ea 00 00 00       	jmp    80099b <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	8b 50 04             	mov    0x4(%eax),%edx
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c2:	8d 40 08             	lea    0x8(%eax),%eax
  8008c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008c8:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008cd:	e9 c9 00 00 00       	jmp    80099b <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8008d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d5:	8b 00                	mov    (%eax),%eax
  8008d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e5:	8d 40 04             	lea    0x4(%eax),%eax
  8008e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008eb:	bf 0a 00 00 00       	mov    $0xa,%edi
  8008f0:	e9 a6 00 00 00       	jmp    80099b <vprintfmt+0x403>
			putch('0', putdat);
  8008f5:	83 ec 08             	sub    $0x8,%esp
  8008f8:	53                   	push   %ebx
  8008f9:	6a 30                	push   $0x30
  8008fb:	ff d6                	call   *%esi
	if (lflag >= 2)
  8008fd:	83 c4 10             	add    $0x10,%esp
  800900:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800904:	7f 26                	jg     80092c <vprintfmt+0x394>
	else if (lflag)
  800906:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80090a:	74 3e                	je     80094a <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	ba 00 00 00 00       	mov    $0x0,%edx
  800916:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800919:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80091c:	8b 45 14             	mov    0x14(%ebp),%eax
  80091f:	8d 40 04             	lea    0x4(%eax),%eax
  800922:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800925:	bf 08 00 00 00       	mov    $0x8,%edi
  80092a:	eb 6f                	jmp    80099b <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	8b 50 04             	mov    0x4(%eax),%edx
  800932:	8b 00                	mov    (%eax),%eax
  800934:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800937:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80093a:	8b 45 14             	mov    0x14(%ebp),%eax
  80093d:	8d 40 08             	lea    0x8(%eax),%eax
  800940:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800943:	bf 08 00 00 00       	mov    $0x8,%edi
  800948:	eb 51                	jmp    80099b <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80094a:	8b 45 14             	mov    0x14(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	ba 00 00 00 00       	mov    $0x0,%edx
  800954:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800957:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80095a:	8b 45 14             	mov    0x14(%ebp),%eax
  80095d:	8d 40 04             	lea    0x4(%eax),%eax
  800960:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800963:	bf 08 00 00 00       	mov    $0x8,%edi
  800968:	eb 31                	jmp    80099b <vprintfmt+0x403>
			putch('0', putdat);
  80096a:	83 ec 08             	sub    $0x8,%esp
  80096d:	53                   	push   %ebx
  80096e:	6a 30                	push   $0x30
  800970:	ff d6                	call   *%esi
			putch('x', putdat);
  800972:	83 c4 08             	add    $0x8,%esp
  800975:	53                   	push   %ebx
  800976:	6a 78                	push   $0x78
  800978:	ff d6                	call   *%esi
			num = (unsigned long long)
  80097a:	8b 45 14             	mov    0x14(%ebp),%eax
  80097d:	8b 00                	mov    (%eax),%eax
  80097f:	ba 00 00 00 00       	mov    $0x0,%edx
  800984:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800987:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80098a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80098d:	8b 45 14             	mov    0x14(%ebp),%eax
  800990:	8d 40 04             	lea    0x4(%eax),%eax
  800993:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800996:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  80099b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80099f:	74 0b                	je     8009ac <vprintfmt+0x414>
				putch('+', putdat);
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	53                   	push   %ebx
  8009a5:	6a 2b                	push   $0x2b
  8009a7:	ff d6                	call   *%esi
  8009a9:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8009ac:	83 ec 0c             	sub    $0xc,%esp
  8009af:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009b3:	50                   	push   %eax
  8009b4:	ff 75 e0             	pushl  -0x20(%ebp)
  8009b7:	57                   	push   %edi
  8009b8:	ff 75 dc             	pushl  -0x24(%ebp)
  8009bb:	ff 75 d8             	pushl  -0x28(%ebp)
  8009be:	89 da                	mov    %ebx,%edx
  8009c0:	89 f0                	mov    %esi,%eax
  8009c2:	e8 b8 fa ff ff       	call   80047f <printnum>
			break;
  8009c7:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  8009ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009cd:	83 c7 01             	add    $0x1,%edi
  8009d0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009d4:	83 f8 25             	cmp    $0x25,%eax
  8009d7:	0f 84 d2 fb ff ff    	je     8005af <vprintfmt+0x17>
			if (ch == '\0')
  8009dd:	85 c0                	test   %eax,%eax
  8009df:	0f 84 03 01 00 00    	je     800ae8 <vprintfmt+0x550>
			putch(ch, putdat);
  8009e5:	83 ec 08             	sub    $0x8,%esp
  8009e8:	53                   	push   %ebx
  8009e9:	50                   	push   %eax
  8009ea:	ff d6                	call   *%esi
  8009ec:	83 c4 10             	add    $0x10,%esp
  8009ef:	eb dc                	jmp    8009cd <vprintfmt+0x435>
	if (lflag >= 2)
  8009f1:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8009f5:	7f 29                	jg     800a20 <vprintfmt+0x488>
	else if (lflag)
  8009f7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8009fb:	74 44                	je     800a41 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  8009fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800a00:	8b 00                	mov    (%eax),%eax
  800a02:	ba 00 00 00 00       	mov    $0x0,%edx
  800a07:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a0a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a10:	8d 40 04             	lea    0x4(%eax),%eax
  800a13:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a16:	bf 10 00 00 00       	mov    $0x10,%edi
  800a1b:	e9 7b ff ff ff       	jmp    80099b <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800a20:	8b 45 14             	mov    0x14(%ebp),%eax
  800a23:	8b 50 04             	mov    0x4(%eax),%edx
  800a26:	8b 00                	mov    (%eax),%eax
  800a28:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a2b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	8d 40 08             	lea    0x8(%eax),%eax
  800a34:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a37:	bf 10 00 00 00       	mov    $0x10,%edi
  800a3c:	e9 5a ff ff ff       	jmp    80099b <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800a41:	8b 45 14             	mov    0x14(%ebp),%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a4e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a51:	8b 45 14             	mov    0x14(%ebp),%eax
  800a54:	8d 40 04             	lea    0x4(%eax),%eax
  800a57:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a5a:	bf 10 00 00 00       	mov    $0x10,%edi
  800a5f:	e9 37 ff ff ff       	jmp    80099b <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800a64:	8b 45 14             	mov    0x14(%ebp),%eax
  800a67:	8d 78 04             	lea    0x4(%eax),%edi
  800a6a:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800a6c:	85 c0                	test   %eax,%eax
  800a6e:	74 2c                	je     800a9c <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800a70:	8b 13                	mov    (%ebx),%edx
  800a72:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800a74:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800a77:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800a7a:	0f 8e 4a ff ff ff    	jle    8009ca <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800a80:	68 ec 12 80 00       	push   $0x8012ec
  800a85:	68 9e 11 80 00       	push   $0x80119e
  800a8a:	53                   	push   %ebx
  800a8b:	56                   	push   %esi
  800a8c:	e8 ea fa ff ff       	call   80057b <printfmt>
  800a91:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800a94:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a97:	e9 2e ff ff ff       	jmp    8009ca <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800a9c:	68 b4 12 80 00       	push   $0x8012b4
  800aa1:	68 9e 11 80 00       	push   $0x80119e
  800aa6:	53                   	push   %ebx
  800aa7:	56                   	push   %esi
  800aa8:	e8 ce fa ff ff       	call   80057b <printfmt>
        		break;
  800aad:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800ab0:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800ab3:	e9 12 ff ff ff       	jmp    8009ca <vprintfmt+0x432>
			putch(ch, putdat);
  800ab8:	83 ec 08             	sub    $0x8,%esp
  800abb:	53                   	push   %ebx
  800abc:	6a 25                	push   $0x25
  800abe:	ff d6                	call   *%esi
			break;
  800ac0:	83 c4 10             	add    $0x10,%esp
  800ac3:	e9 02 ff ff ff       	jmp    8009ca <vprintfmt+0x432>
			putch('%', putdat);
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	53                   	push   %ebx
  800acc:	6a 25                	push   $0x25
  800ace:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ad0:	83 c4 10             	add    $0x10,%esp
  800ad3:	89 f8                	mov    %edi,%eax
  800ad5:	eb 03                	jmp    800ada <vprintfmt+0x542>
  800ad7:	83 e8 01             	sub    $0x1,%eax
  800ada:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800ade:	75 f7                	jne    800ad7 <vprintfmt+0x53f>
  800ae0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ae3:	e9 e2 fe ff ff       	jmp    8009ca <vprintfmt+0x432>
}
  800ae8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800aeb:	5b                   	pop    %ebx
  800aec:	5e                   	pop    %esi
  800aed:	5f                   	pop    %edi
  800aee:	5d                   	pop    %ebp
  800aef:	c3                   	ret    

00800af0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	83 ec 18             	sub    $0x18,%esp
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800afc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800aff:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b03:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b0d:	85 c0                	test   %eax,%eax
  800b0f:	74 26                	je     800b37 <vsnprintf+0x47>
  800b11:	85 d2                	test   %edx,%edx
  800b13:	7e 22                	jle    800b37 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b15:	ff 75 14             	pushl  0x14(%ebp)
  800b18:	ff 75 10             	pushl  0x10(%ebp)
  800b1b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b1e:	50                   	push   %eax
  800b1f:	68 5e 05 80 00       	push   $0x80055e
  800b24:	e8 6f fa ff ff       	call   800598 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b2c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b32:	83 c4 10             	add    $0x10,%esp
}
  800b35:	c9                   	leave  
  800b36:	c3                   	ret    
		return -E_INVAL;
  800b37:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b3c:	eb f7                	jmp    800b35 <vsnprintf+0x45>

00800b3e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b44:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b47:	50                   	push   %eax
  800b48:	ff 75 10             	pushl  0x10(%ebp)
  800b4b:	ff 75 0c             	pushl  0xc(%ebp)
  800b4e:	ff 75 08             	pushl  0x8(%ebp)
  800b51:	e8 9a ff ff ff       	call   800af0 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b56:	c9                   	leave  
  800b57:	c3                   	ret    

00800b58 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b63:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b67:	74 05                	je     800b6e <strlen+0x16>
		n++;
  800b69:	83 c0 01             	add    $0x1,%eax
  800b6c:	eb f5                	jmp    800b63 <strlen+0xb>
	return n;
}
  800b6e:	5d                   	pop    %ebp
  800b6f:	c3                   	ret    

00800b70 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b76:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b79:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7e:	39 c2                	cmp    %eax,%edx
  800b80:	74 0d                	je     800b8f <strnlen+0x1f>
  800b82:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b86:	74 05                	je     800b8d <strnlen+0x1d>
		n++;
  800b88:	83 c2 01             	add    $0x1,%edx
  800b8b:	eb f1                	jmp    800b7e <strnlen+0xe>
  800b8d:	89 d0                	mov    %edx,%eax
	return n;
}
  800b8f:	5d                   	pop    %ebp
  800b90:	c3                   	ret    

00800b91 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	53                   	push   %ebx
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800ba4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ba7:	83 c2 01             	add    $0x1,%edx
  800baa:	84 c9                	test   %cl,%cl
  800bac:	75 f2                	jne    800ba0 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bae:	5b                   	pop    %ebx
  800baf:	5d                   	pop    %ebp
  800bb0:	c3                   	ret    

00800bb1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
  800bb4:	53                   	push   %ebx
  800bb5:	83 ec 10             	sub    $0x10,%esp
  800bb8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bbb:	53                   	push   %ebx
  800bbc:	e8 97 ff ff ff       	call   800b58 <strlen>
  800bc1:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bc4:	ff 75 0c             	pushl  0xc(%ebp)
  800bc7:	01 d8                	add    %ebx,%eax
  800bc9:	50                   	push   %eax
  800bca:	e8 c2 ff ff ff       	call   800b91 <strcpy>
	return dst;
}
  800bcf:	89 d8                	mov    %ebx,%eax
  800bd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bd4:	c9                   	leave  
  800bd5:	c3                   	ret    

00800bd6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
  800bd9:	56                   	push   %esi
  800bda:	53                   	push   %ebx
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be1:	89 c6                	mov    %eax,%esi
  800be3:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800be6:	89 c2                	mov    %eax,%edx
  800be8:	39 f2                	cmp    %esi,%edx
  800bea:	74 11                	je     800bfd <strncpy+0x27>
		*dst++ = *src;
  800bec:	83 c2 01             	add    $0x1,%edx
  800bef:	0f b6 19             	movzbl (%ecx),%ebx
  800bf2:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bf5:	80 fb 01             	cmp    $0x1,%bl
  800bf8:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800bfb:	eb eb                	jmp    800be8 <strncpy+0x12>
	}
	return ret;
}
  800bfd:	5b                   	pop    %ebx
  800bfe:	5e                   	pop    %esi
  800bff:	5d                   	pop    %ebp
  800c00:	c3                   	ret    

00800c01 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c01:	55                   	push   %ebp
  800c02:	89 e5                	mov    %esp,%ebp
  800c04:	56                   	push   %esi
  800c05:	53                   	push   %ebx
  800c06:	8b 75 08             	mov    0x8(%ebp),%esi
  800c09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0c:	8b 55 10             	mov    0x10(%ebp),%edx
  800c0f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c11:	85 d2                	test   %edx,%edx
  800c13:	74 21                	je     800c36 <strlcpy+0x35>
  800c15:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c19:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c1b:	39 c2                	cmp    %eax,%edx
  800c1d:	74 14                	je     800c33 <strlcpy+0x32>
  800c1f:	0f b6 19             	movzbl (%ecx),%ebx
  800c22:	84 db                	test   %bl,%bl
  800c24:	74 0b                	je     800c31 <strlcpy+0x30>
			*dst++ = *src++;
  800c26:	83 c1 01             	add    $0x1,%ecx
  800c29:	83 c2 01             	add    $0x1,%edx
  800c2c:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c2f:	eb ea                	jmp    800c1b <strlcpy+0x1a>
  800c31:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c33:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c36:	29 f0                	sub    %esi,%eax
}
  800c38:	5b                   	pop    %ebx
  800c39:	5e                   	pop    %esi
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    

00800c3c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c42:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c45:	0f b6 01             	movzbl (%ecx),%eax
  800c48:	84 c0                	test   %al,%al
  800c4a:	74 0c                	je     800c58 <strcmp+0x1c>
  800c4c:	3a 02                	cmp    (%edx),%al
  800c4e:	75 08                	jne    800c58 <strcmp+0x1c>
		p++, q++;
  800c50:	83 c1 01             	add    $0x1,%ecx
  800c53:	83 c2 01             	add    $0x1,%edx
  800c56:	eb ed                	jmp    800c45 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c58:	0f b6 c0             	movzbl %al,%eax
  800c5b:	0f b6 12             	movzbl (%edx),%edx
  800c5e:	29 d0                	sub    %edx,%eax
}
  800c60:	5d                   	pop    %ebp
  800c61:	c3                   	ret    

00800c62 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	53                   	push   %ebx
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6c:	89 c3                	mov    %eax,%ebx
  800c6e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c71:	eb 06                	jmp    800c79 <strncmp+0x17>
		n--, p++, q++;
  800c73:	83 c0 01             	add    $0x1,%eax
  800c76:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c79:	39 d8                	cmp    %ebx,%eax
  800c7b:	74 16                	je     800c93 <strncmp+0x31>
  800c7d:	0f b6 08             	movzbl (%eax),%ecx
  800c80:	84 c9                	test   %cl,%cl
  800c82:	74 04                	je     800c88 <strncmp+0x26>
  800c84:	3a 0a                	cmp    (%edx),%cl
  800c86:	74 eb                	je     800c73 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c88:	0f b6 00             	movzbl (%eax),%eax
  800c8b:	0f b6 12             	movzbl (%edx),%edx
  800c8e:	29 d0                	sub    %edx,%eax
}
  800c90:	5b                   	pop    %ebx
  800c91:	5d                   	pop    %ebp
  800c92:	c3                   	ret    
		return 0;
  800c93:	b8 00 00 00 00       	mov    $0x0,%eax
  800c98:	eb f6                	jmp    800c90 <strncmp+0x2e>

00800c9a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ca4:	0f b6 10             	movzbl (%eax),%edx
  800ca7:	84 d2                	test   %dl,%dl
  800ca9:	74 09                	je     800cb4 <strchr+0x1a>
		if (*s == c)
  800cab:	38 ca                	cmp    %cl,%dl
  800cad:	74 0a                	je     800cb9 <strchr+0x1f>
	for (; *s; s++)
  800caf:	83 c0 01             	add    $0x1,%eax
  800cb2:	eb f0                	jmp    800ca4 <strchr+0xa>
			return (char *) s;
	return 0;
  800cb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb9:	5d                   	pop    %ebp
  800cba:	c3                   	ret    

00800cbb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cc5:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800cc8:	38 ca                	cmp    %cl,%dl
  800cca:	74 09                	je     800cd5 <strfind+0x1a>
  800ccc:	84 d2                	test   %dl,%dl
  800cce:	74 05                	je     800cd5 <strfind+0x1a>
	for (; *s; s++)
  800cd0:	83 c0 01             	add    $0x1,%eax
  800cd3:	eb f0                	jmp    800cc5 <strfind+0xa>
			break;
	return (char *) s;
}
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
  800cdd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ce0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ce3:	85 c9                	test   %ecx,%ecx
  800ce5:	74 31                	je     800d18 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ce7:	89 f8                	mov    %edi,%eax
  800ce9:	09 c8                	or     %ecx,%eax
  800ceb:	a8 03                	test   $0x3,%al
  800ced:	75 23                	jne    800d12 <memset+0x3b>
		c &= 0xFF;
  800cef:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cf3:	89 d3                	mov    %edx,%ebx
  800cf5:	c1 e3 08             	shl    $0x8,%ebx
  800cf8:	89 d0                	mov    %edx,%eax
  800cfa:	c1 e0 18             	shl    $0x18,%eax
  800cfd:	89 d6                	mov    %edx,%esi
  800cff:	c1 e6 10             	shl    $0x10,%esi
  800d02:	09 f0                	or     %esi,%eax
  800d04:	09 c2                	or     %eax,%edx
  800d06:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d08:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d0b:	89 d0                	mov    %edx,%eax
  800d0d:	fc                   	cld    
  800d0e:	f3 ab                	rep stos %eax,%es:(%edi)
  800d10:	eb 06                	jmp    800d18 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d15:	fc                   	cld    
  800d16:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d18:	89 f8                	mov    %edi,%eax
  800d1a:	5b                   	pop    %ebx
  800d1b:	5e                   	pop    %esi
  800d1c:	5f                   	pop    %edi
  800d1d:	5d                   	pop    %ebp
  800d1e:	c3                   	ret    

00800d1f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	57                   	push   %edi
  800d23:	56                   	push   %esi
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d2d:	39 c6                	cmp    %eax,%esi
  800d2f:	73 32                	jae    800d63 <memmove+0x44>
  800d31:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d34:	39 c2                	cmp    %eax,%edx
  800d36:	76 2b                	jbe    800d63 <memmove+0x44>
		s += n;
		d += n;
  800d38:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d3b:	89 fe                	mov    %edi,%esi
  800d3d:	09 ce                	or     %ecx,%esi
  800d3f:	09 d6                	or     %edx,%esi
  800d41:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d47:	75 0e                	jne    800d57 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d49:	83 ef 04             	sub    $0x4,%edi
  800d4c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d4f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d52:	fd                   	std    
  800d53:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d55:	eb 09                	jmp    800d60 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d57:	83 ef 01             	sub    $0x1,%edi
  800d5a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d5d:	fd                   	std    
  800d5e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d60:	fc                   	cld    
  800d61:	eb 1a                	jmp    800d7d <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d63:	89 c2                	mov    %eax,%edx
  800d65:	09 ca                	or     %ecx,%edx
  800d67:	09 f2                	or     %esi,%edx
  800d69:	f6 c2 03             	test   $0x3,%dl
  800d6c:	75 0a                	jne    800d78 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d6e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d71:	89 c7                	mov    %eax,%edi
  800d73:	fc                   	cld    
  800d74:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d76:	eb 05                	jmp    800d7d <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d78:	89 c7                	mov    %eax,%edi
  800d7a:	fc                   	cld    
  800d7b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d7d:	5e                   	pop    %esi
  800d7e:	5f                   	pop    %edi
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    

00800d81 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d87:	ff 75 10             	pushl  0x10(%ebp)
  800d8a:	ff 75 0c             	pushl  0xc(%ebp)
  800d8d:	ff 75 08             	pushl  0x8(%ebp)
  800d90:	e8 8a ff ff ff       	call   800d1f <memmove>
}
  800d95:	c9                   	leave  
  800d96:	c3                   	ret    

00800d97 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	56                   	push   %esi
  800d9b:	53                   	push   %ebx
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da2:	89 c6                	mov    %eax,%esi
  800da4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800da7:	39 f0                	cmp    %esi,%eax
  800da9:	74 1c                	je     800dc7 <memcmp+0x30>
		if (*s1 != *s2)
  800dab:	0f b6 08             	movzbl (%eax),%ecx
  800dae:	0f b6 1a             	movzbl (%edx),%ebx
  800db1:	38 d9                	cmp    %bl,%cl
  800db3:	75 08                	jne    800dbd <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800db5:	83 c0 01             	add    $0x1,%eax
  800db8:	83 c2 01             	add    $0x1,%edx
  800dbb:	eb ea                	jmp    800da7 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800dbd:	0f b6 c1             	movzbl %cl,%eax
  800dc0:	0f b6 db             	movzbl %bl,%ebx
  800dc3:	29 d8                	sub    %ebx,%eax
  800dc5:	eb 05                	jmp    800dcc <memcmp+0x35>
	}

	return 0;
  800dc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dcc:	5b                   	pop    %ebx
  800dcd:	5e                   	pop    %esi
  800dce:	5d                   	pop    %ebp
  800dcf:	c3                   	ret    

00800dd0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800dd9:	89 c2                	mov    %eax,%edx
  800ddb:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800dde:	39 d0                	cmp    %edx,%eax
  800de0:	73 09                	jae    800deb <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800de2:	38 08                	cmp    %cl,(%eax)
  800de4:	74 05                	je     800deb <memfind+0x1b>
	for (; s < ends; s++)
  800de6:	83 c0 01             	add    $0x1,%eax
  800de9:	eb f3                	jmp    800dde <memfind+0xe>
			break;
	return (void *) s;
}
  800deb:	5d                   	pop    %ebp
  800dec:	c3                   	ret    

00800ded <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
  800df0:	57                   	push   %edi
  800df1:	56                   	push   %esi
  800df2:	53                   	push   %ebx
  800df3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800df6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800df9:	eb 03                	jmp    800dfe <strtol+0x11>
		s++;
  800dfb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800dfe:	0f b6 01             	movzbl (%ecx),%eax
  800e01:	3c 20                	cmp    $0x20,%al
  800e03:	74 f6                	je     800dfb <strtol+0xe>
  800e05:	3c 09                	cmp    $0x9,%al
  800e07:	74 f2                	je     800dfb <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e09:	3c 2b                	cmp    $0x2b,%al
  800e0b:	74 2a                	je     800e37 <strtol+0x4a>
	int neg = 0;
  800e0d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e12:	3c 2d                	cmp    $0x2d,%al
  800e14:	74 2b                	je     800e41 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e16:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e1c:	75 0f                	jne    800e2d <strtol+0x40>
  800e1e:	80 39 30             	cmpb   $0x30,(%ecx)
  800e21:	74 28                	je     800e4b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e23:	85 db                	test   %ebx,%ebx
  800e25:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e2a:	0f 44 d8             	cmove  %eax,%ebx
  800e2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e32:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e35:	eb 50                	jmp    800e87 <strtol+0x9a>
		s++;
  800e37:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e3a:	bf 00 00 00 00       	mov    $0x0,%edi
  800e3f:	eb d5                	jmp    800e16 <strtol+0x29>
		s++, neg = 1;
  800e41:	83 c1 01             	add    $0x1,%ecx
  800e44:	bf 01 00 00 00       	mov    $0x1,%edi
  800e49:	eb cb                	jmp    800e16 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e4b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e4f:	74 0e                	je     800e5f <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e51:	85 db                	test   %ebx,%ebx
  800e53:	75 d8                	jne    800e2d <strtol+0x40>
		s++, base = 8;
  800e55:	83 c1 01             	add    $0x1,%ecx
  800e58:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e5d:	eb ce                	jmp    800e2d <strtol+0x40>
		s += 2, base = 16;
  800e5f:	83 c1 02             	add    $0x2,%ecx
  800e62:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e67:	eb c4                	jmp    800e2d <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e69:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e6c:	89 f3                	mov    %esi,%ebx
  800e6e:	80 fb 19             	cmp    $0x19,%bl
  800e71:	77 29                	ja     800e9c <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e73:	0f be d2             	movsbl %dl,%edx
  800e76:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e79:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e7c:	7d 30                	jge    800eae <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e7e:	83 c1 01             	add    $0x1,%ecx
  800e81:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e85:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e87:	0f b6 11             	movzbl (%ecx),%edx
  800e8a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e8d:	89 f3                	mov    %esi,%ebx
  800e8f:	80 fb 09             	cmp    $0x9,%bl
  800e92:	77 d5                	ja     800e69 <strtol+0x7c>
			dig = *s - '0';
  800e94:	0f be d2             	movsbl %dl,%edx
  800e97:	83 ea 30             	sub    $0x30,%edx
  800e9a:	eb dd                	jmp    800e79 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e9c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e9f:	89 f3                	mov    %esi,%ebx
  800ea1:	80 fb 19             	cmp    $0x19,%bl
  800ea4:	77 08                	ja     800eae <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ea6:	0f be d2             	movsbl %dl,%edx
  800ea9:	83 ea 37             	sub    $0x37,%edx
  800eac:	eb cb                	jmp    800e79 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800eae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eb2:	74 05                	je     800eb9 <strtol+0xcc>
		*endptr = (char *) s;
  800eb4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800eb7:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800eb9:	89 c2                	mov    %eax,%edx
  800ebb:	f7 da                	neg    %edx
  800ebd:	85 ff                	test   %edi,%edi
  800ebf:	0f 45 c2             	cmovne %edx,%eax
}
  800ec2:	5b                   	pop    %ebx
  800ec3:	5e                   	pop    %esi
  800ec4:	5f                   	pop    %edi
  800ec5:	5d                   	pop    %ebp
  800ec6:	c3                   	ret    
  800ec7:	66 90                	xchg   %ax,%ax
  800ec9:	66 90                	xchg   %ax,%ax
  800ecb:	66 90                	xchg   %ax,%ax
  800ecd:	66 90                	xchg   %ax,%ax
  800ecf:	90                   	nop

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
