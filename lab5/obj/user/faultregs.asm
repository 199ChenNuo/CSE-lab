
obj/user/faultregs.debug:     file format elf32-i386


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
  80002c:	e8 b0 05 00 00       	call   8005e1 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 0c             	sub    $0xc,%esp
  80003c:	89 c6                	mov    %eax,%esi
  80003e:	89 cb                	mov    %ecx,%ebx
	int mismatch = 0;

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800040:	ff 75 08             	pushl  0x8(%ebp)
  800043:	52                   	push   %edx
  800044:	68 91 17 80 00       	push   $0x801791
  800049:	68 60 17 80 00       	push   $0x801760
  80004e:	e8 c4 06 00 00       	call   800717 <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800053:	ff 33                	pushl  (%ebx)
  800055:	ff 36                	pushl  (%esi)
  800057:	68 70 17 80 00       	push   $0x801770
  80005c:	68 74 17 80 00       	push   $0x801774
  800061:	e8 b1 06 00 00       	call   800717 <cprintf>
  800066:	83 c4 20             	add    $0x20,%esp
  800069:	8b 03                	mov    (%ebx),%eax
  80006b:	39 06                	cmp    %eax,(%esi)
  80006d:	0f 84 2e 02 00 00    	je     8002a1 <check_regs+0x26e>
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 88 17 80 00       	push   $0x801788
  80007b:	e8 97 06 00 00       	call   800717 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  800088:	ff 73 04             	pushl  0x4(%ebx)
  80008b:	ff 76 04             	pushl  0x4(%esi)
  80008e:	68 92 17 80 00       	push   $0x801792
  800093:	68 74 17 80 00       	push   $0x801774
  800098:	e8 7a 06 00 00       	call   800717 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	8b 43 04             	mov    0x4(%ebx),%eax
  8000a3:	39 46 04             	cmp    %eax,0x4(%esi)
  8000a6:	0f 84 0f 02 00 00    	je     8002bb <check_regs+0x288>
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 88 17 80 00       	push   $0x801788
  8000b4:	e8 5e 06 00 00       	call   800717 <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000c1:	ff 73 08             	pushl  0x8(%ebx)
  8000c4:	ff 76 08             	pushl  0x8(%esi)
  8000c7:	68 96 17 80 00       	push   $0x801796
  8000cc:	68 74 17 80 00       	push   $0x801774
  8000d1:	e8 41 06 00 00       	call   800717 <cprintf>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8b 43 08             	mov    0x8(%ebx),%eax
  8000dc:	39 46 08             	cmp    %eax,0x8(%esi)
  8000df:	0f 84 eb 01 00 00    	je     8002d0 <check_regs+0x29d>
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 88 17 80 00       	push   $0x801788
  8000ed:	e8 25 06 00 00       	call   800717 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  8000fa:	ff 73 10             	pushl  0x10(%ebx)
  8000fd:	ff 76 10             	pushl  0x10(%esi)
  800100:	68 9a 17 80 00       	push   $0x80179a
  800105:	68 74 17 80 00       	push   $0x801774
  80010a:	e8 08 06 00 00       	call   800717 <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	8b 43 10             	mov    0x10(%ebx),%eax
  800115:	39 46 10             	cmp    %eax,0x10(%esi)
  800118:	0f 84 c7 01 00 00    	je     8002e5 <check_regs+0x2b2>
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 88 17 80 00       	push   $0x801788
  800126:	e8 ec 05 00 00       	call   800717 <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800133:	ff 73 14             	pushl  0x14(%ebx)
  800136:	ff 76 14             	pushl  0x14(%esi)
  800139:	68 9e 17 80 00       	push   $0x80179e
  80013e:	68 74 17 80 00       	push   $0x801774
  800143:	e8 cf 05 00 00       	call   800717 <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	8b 43 14             	mov    0x14(%ebx),%eax
  80014e:	39 46 14             	cmp    %eax,0x14(%esi)
  800151:	0f 84 a3 01 00 00    	je     8002fa <check_regs+0x2c7>
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 88 17 80 00       	push   $0x801788
  80015f:	e8 b3 05 00 00       	call   800717 <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  80016c:	ff 73 18             	pushl  0x18(%ebx)
  80016f:	ff 76 18             	pushl  0x18(%esi)
  800172:	68 a2 17 80 00       	push   $0x8017a2
  800177:	68 74 17 80 00       	push   $0x801774
  80017c:	e8 96 05 00 00       	call   800717 <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	8b 43 18             	mov    0x18(%ebx),%eax
  800187:	39 46 18             	cmp    %eax,0x18(%esi)
  80018a:	0f 84 7f 01 00 00    	je     80030f <check_regs+0x2dc>
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 88 17 80 00       	push   $0x801788
  800198:	e8 7a 05 00 00       	call   800717 <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  8001a5:	ff 73 1c             	pushl  0x1c(%ebx)
  8001a8:	ff 76 1c             	pushl  0x1c(%esi)
  8001ab:	68 a6 17 80 00       	push   $0x8017a6
  8001b0:	68 74 17 80 00       	push   $0x801774
  8001b5:	e8 5d 05 00 00       	call   800717 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	8b 43 1c             	mov    0x1c(%ebx),%eax
  8001c0:	39 46 1c             	cmp    %eax,0x1c(%esi)
  8001c3:	0f 84 5b 01 00 00    	je     800324 <check_regs+0x2f1>
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	68 88 17 80 00       	push   $0x801788
  8001d1:	e8 41 05 00 00       	call   800717 <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  8001de:	ff 73 20             	pushl  0x20(%ebx)
  8001e1:	ff 76 20             	pushl  0x20(%esi)
  8001e4:	68 aa 17 80 00       	push   $0x8017aa
  8001e9:	68 74 17 80 00       	push   $0x801774
  8001ee:	e8 24 05 00 00       	call   800717 <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	8b 43 20             	mov    0x20(%ebx),%eax
  8001f9:	39 46 20             	cmp    %eax,0x20(%esi)
  8001fc:	0f 84 37 01 00 00    	je     800339 <check_regs+0x306>
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	68 88 17 80 00       	push   $0x801788
  80020a:	e8 08 05 00 00       	call   800717 <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  800217:	ff 73 24             	pushl  0x24(%ebx)
  80021a:	ff 76 24             	pushl  0x24(%esi)
  80021d:	68 ae 17 80 00       	push   $0x8017ae
  800222:	68 74 17 80 00       	push   $0x801774
  800227:	e8 eb 04 00 00       	call   800717 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8b 43 24             	mov    0x24(%ebx),%eax
  800232:	39 46 24             	cmp    %eax,0x24(%esi)
  800235:	0f 84 13 01 00 00    	je     80034e <check_regs+0x31b>
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	68 88 17 80 00       	push   $0x801788
  800243:	e8 cf 04 00 00       	call   800717 <cprintf>
	CHECK(esp, esp);
  800248:	ff 73 28             	pushl  0x28(%ebx)
  80024b:	ff 76 28             	pushl  0x28(%esi)
  80024e:	68 b5 17 80 00       	push   $0x8017b5
  800253:	68 74 17 80 00       	push   $0x801774
  800258:	e8 ba 04 00 00       	call   800717 <cprintf>
  80025d:	83 c4 20             	add    $0x20,%esp
  800260:	8b 43 28             	mov    0x28(%ebx),%eax
  800263:	39 46 28             	cmp    %eax,0x28(%esi)
  800266:	0f 84 53 01 00 00    	je     8003bf <check_regs+0x38c>
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	68 88 17 80 00       	push   $0x801788
  800274:	e8 9e 04 00 00       	call   800717 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800279:	83 c4 08             	add    $0x8,%esp
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	68 b9 17 80 00       	push   $0x8017b9
  800284:	e8 8e 04 00 00       	call   800717 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	if (!mismatch)
		cprintf("OK\n");
	else
		cprintf("MISMATCH\n");
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	68 88 17 80 00       	push   $0x801788
  800294:	e8 7e 04 00 00       	call   800717 <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
}
  80029c:	e9 16 01 00 00       	jmp    8003b7 <check_regs+0x384>
	CHECK(edi, regs.reg_edi);
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	68 84 17 80 00       	push   $0x801784
  8002a9:	e8 69 04 00 00       	call   800717 <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
	int mismatch = 0;
  8002b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b6:	e9 cd fd ff ff       	jmp    800088 <check_regs+0x55>
	CHECK(esi, regs.reg_esi);
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 84 17 80 00       	push   $0x801784
  8002c3:	e8 4f 04 00 00       	call   800717 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
  8002cb:	e9 f1 fd ff ff       	jmp    8000c1 <check_regs+0x8e>
	CHECK(ebp, regs.reg_ebp);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	68 84 17 80 00       	push   $0x801784
  8002d8:	e8 3a 04 00 00       	call   800717 <cprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp
  8002e0:	e9 15 fe ff ff       	jmp    8000fa <check_regs+0xc7>
	CHECK(ebx, regs.reg_ebx);
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 84 17 80 00       	push   $0x801784
  8002ed:	e8 25 04 00 00       	call   800717 <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	e9 39 fe ff ff       	jmp    800133 <check_regs+0x100>
	CHECK(edx, regs.reg_edx);
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	68 84 17 80 00       	push   $0x801784
  800302:	e8 10 04 00 00       	call   800717 <cprintf>
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	e9 5d fe ff ff       	jmp    80016c <check_regs+0x139>
	CHECK(ecx, regs.reg_ecx);
  80030f:	83 ec 0c             	sub    $0xc,%esp
  800312:	68 84 17 80 00       	push   $0x801784
  800317:	e8 fb 03 00 00       	call   800717 <cprintf>
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	e9 81 fe ff ff       	jmp    8001a5 <check_regs+0x172>
	CHECK(eax, regs.reg_eax);
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	68 84 17 80 00       	push   $0x801784
  80032c:	e8 e6 03 00 00       	call   800717 <cprintf>
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	e9 a5 fe ff ff       	jmp    8001de <check_regs+0x1ab>
	CHECK(eip, eip);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	68 84 17 80 00       	push   $0x801784
  800341:	e8 d1 03 00 00       	call   800717 <cprintf>
  800346:	83 c4 10             	add    $0x10,%esp
  800349:	e9 c9 fe ff ff       	jmp    800217 <check_regs+0x1e4>
	CHECK(eflags, eflags);
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	68 84 17 80 00       	push   $0x801784
  800356:	e8 bc 03 00 00       	call   800717 <cprintf>
	CHECK(esp, esp);
  80035b:	ff 73 28             	pushl  0x28(%ebx)
  80035e:	ff 76 28             	pushl  0x28(%esi)
  800361:	68 b5 17 80 00       	push   $0x8017b5
  800366:	68 74 17 80 00       	push   $0x801774
  80036b:	e8 a7 03 00 00       	call   800717 <cprintf>
  800370:	83 c4 20             	add    $0x20,%esp
  800373:	8b 43 28             	mov    0x28(%ebx),%eax
  800376:	39 46 28             	cmp    %eax,0x28(%esi)
  800379:	0f 85 ed fe ff ff    	jne    80026c <check_regs+0x239>
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 84 17 80 00       	push   $0x801784
  800387:	e8 8b 03 00 00       	call   800717 <cprintf>
	cprintf("Registers %s ", testname);
  80038c:	83 c4 08             	add    $0x8,%esp
  80038f:	ff 75 0c             	pushl  0xc(%ebp)
  800392:	68 b9 17 80 00       	push   $0x8017b9
  800397:	e8 7b 03 00 00       	call   800717 <cprintf>
	if (!mismatch)
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	85 ff                	test   %edi,%edi
  8003a1:	0f 85 e5 fe ff ff    	jne    80028c <check_regs+0x259>
		cprintf("OK\n");
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	68 84 17 80 00       	push   $0x801784
  8003af:	e8 63 03 00 00       	call   800717 <cprintf>
  8003b4:	83 c4 10             	add    $0x10,%esp
}
  8003b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003ba:	5b                   	pop    %ebx
  8003bb:	5e                   	pop    %esi
  8003bc:	5f                   	pop    %edi
  8003bd:	5d                   	pop    %ebp
  8003be:	c3                   	ret    
	CHECK(esp, esp);
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 84 17 80 00       	push   $0x801784
  8003c7:	e8 4b 03 00 00       	call   800717 <cprintf>
	cprintf("Registers %s ", testname);
  8003cc:	83 c4 08             	add    $0x8,%esp
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	68 b9 17 80 00       	push   $0x8017b9
  8003d7:	e8 3b 03 00 00       	call   800717 <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	e9 a8 fe ff ff       	jmp    80028c <check_regs+0x259>

008003e4 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
	int r;

	if (utf->utf_fault_va != (uint32_t)UTEMP)
  8003ed:	8b 10                	mov    (%eax),%edx
  8003ef:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  8003f5:	0f 85 a3 00 00 00    	jne    80049e <pgfault+0xba>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
		      utf->utf_fault_va, utf->utf_eip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8003fb:	8b 50 08             	mov    0x8(%eax),%edx
  8003fe:	89 15 60 20 80 00    	mov    %edx,0x802060
  800404:	8b 50 0c             	mov    0xc(%eax),%edx
  800407:	89 15 64 20 80 00    	mov    %edx,0x802064
  80040d:	8b 50 10             	mov    0x10(%eax),%edx
  800410:	89 15 68 20 80 00    	mov    %edx,0x802068
  800416:	8b 50 14             	mov    0x14(%eax),%edx
  800419:	89 15 6c 20 80 00    	mov    %edx,0x80206c
  80041f:	8b 50 18             	mov    0x18(%eax),%edx
  800422:	89 15 70 20 80 00    	mov    %edx,0x802070
  800428:	8b 50 1c             	mov    0x1c(%eax),%edx
  80042b:	89 15 74 20 80 00    	mov    %edx,0x802074
  800431:	8b 50 20             	mov    0x20(%eax),%edx
  800434:	89 15 78 20 80 00    	mov    %edx,0x802078
  80043a:	8b 50 24             	mov    0x24(%eax),%edx
  80043d:	89 15 7c 20 80 00    	mov    %edx,0x80207c
	during.eip = utf->utf_eip;
  800443:	8b 50 28             	mov    0x28(%eax),%edx
  800446:	89 15 80 20 80 00    	mov    %edx,0x802080
	during.eflags = utf->utf_eflags & ~FL_RF;
  80044c:	8b 50 2c             	mov    0x2c(%eax),%edx
  80044f:	81 e2 ff ff fe ff    	and    $0xfffeffff,%edx
  800455:	89 15 84 20 80 00    	mov    %edx,0x802084
	during.esp = utf->utf_esp;
  80045b:	8b 40 30             	mov    0x30(%eax),%eax
  80045e:	a3 88 20 80 00       	mov    %eax,0x802088
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	68 df 17 80 00       	push   $0x8017df
  80046b:	68 ed 17 80 00       	push   $0x8017ed
  800470:	b9 60 20 80 00       	mov    $0x802060,%ecx
  800475:	ba d8 17 80 00       	mov    $0x8017d8,%edx
  80047a:	b8 a0 20 80 00       	mov    $0x8020a0,%eax
  80047f:	e8 af fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800484:	83 c4 0c             	add    $0xc,%esp
  800487:	6a 07                	push   $0x7
  800489:	68 00 00 40 00       	push   $0x400000
  80048e:	6a 00                	push   $0x0
  800490:	e8 9a 0d 00 00       	call   80122f <sys_page_alloc>
  800495:	83 c4 10             	add    $0x10,%esp
  800498:	85 c0                	test   %eax,%eax
  80049a:	78 1a                	js     8004b6 <pgfault+0xd2>
		panic("sys_page_alloc: %e", r);
}
  80049c:	c9                   	leave  
  80049d:	c3                   	ret    
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  80049e:	83 ec 0c             	sub    $0xc,%esp
  8004a1:	ff 70 28             	pushl  0x28(%eax)
  8004a4:	52                   	push   %edx
  8004a5:	68 20 18 80 00       	push   $0x801820
  8004aa:	6a 51                	push   $0x51
  8004ac:	68 c7 17 80 00       	push   $0x8017c7
  8004b1:	e8 86 01 00 00       	call   80063c <_panic>
		panic("sys_page_alloc: %e", r);
  8004b6:	50                   	push   %eax
  8004b7:	68 f4 17 80 00       	push   $0x8017f4
  8004bc:	6a 5c                	push   $0x5c
  8004be:	68 c7 17 80 00       	push   $0x8017c7
  8004c3:	e8 74 01 00 00       	call   80063c <_panic>

008004c8 <umain>:

void
umain(int argc, char **argv)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(pgfault);
  8004ce:	68 e4 03 80 00       	push   $0x8003e4
  8004d3:	e8 89 0f 00 00       	call   801461 <set_pgfault_handler>

	asm volatile(
  8004d8:	50                   	push   %eax
  8004d9:	9c                   	pushf  
  8004da:	58                   	pop    %eax
  8004db:	0d d5 08 00 00       	or     $0x8d5,%eax
  8004e0:	50                   	push   %eax
  8004e1:	9d                   	popf   
  8004e2:	a3 c4 20 80 00       	mov    %eax,0x8020c4
  8004e7:	8d 05 22 05 80 00    	lea    0x800522,%eax
  8004ed:	a3 c0 20 80 00       	mov    %eax,0x8020c0
  8004f2:	58                   	pop    %eax
  8004f3:	89 3d a0 20 80 00    	mov    %edi,0x8020a0
  8004f9:	89 35 a4 20 80 00    	mov    %esi,0x8020a4
  8004ff:	89 2d a8 20 80 00    	mov    %ebp,0x8020a8
  800505:	89 1d b0 20 80 00    	mov    %ebx,0x8020b0
  80050b:	89 15 b4 20 80 00    	mov    %edx,0x8020b4
  800511:	89 0d b8 20 80 00    	mov    %ecx,0x8020b8
  800517:	a3 bc 20 80 00       	mov    %eax,0x8020bc
  80051c:	89 25 c8 20 80 00    	mov    %esp,0x8020c8
  800522:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  800529:	00 00 00 
  80052c:	89 3d 20 20 80 00    	mov    %edi,0x802020
  800532:	89 35 24 20 80 00    	mov    %esi,0x802024
  800538:	89 2d 28 20 80 00    	mov    %ebp,0x802028
  80053e:	89 1d 30 20 80 00    	mov    %ebx,0x802030
  800544:	89 15 34 20 80 00    	mov    %edx,0x802034
  80054a:	89 0d 38 20 80 00    	mov    %ecx,0x802038
  800550:	a3 3c 20 80 00       	mov    %eax,0x80203c
  800555:	89 25 48 20 80 00    	mov    %esp,0x802048
  80055b:	8b 3d a0 20 80 00    	mov    0x8020a0,%edi
  800561:	8b 35 a4 20 80 00    	mov    0x8020a4,%esi
  800567:	8b 2d a8 20 80 00    	mov    0x8020a8,%ebp
  80056d:	8b 1d b0 20 80 00    	mov    0x8020b0,%ebx
  800573:	8b 15 b4 20 80 00    	mov    0x8020b4,%edx
  800579:	8b 0d b8 20 80 00    	mov    0x8020b8,%ecx
  80057f:	a1 bc 20 80 00       	mov    0x8020bc,%eax
  800584:	8b 25 c8 20 80 00    	mov    0x8020c8,%esp
  80058a:	50                   	push   %eax
  80058b:	9c                   	pushf  
  80058c:	58                   	pop    %eax
  80058d:	a3 44 20 80 00       	mov    %eax,0x802044
  800592:	58                   	pop    %eax
		: : "m" (before), "m" (after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
  80059d:	75 30                	jne    8005cf <umain+0x107>
		cprintf("EIP after page-fault MISMATCH\n");
	after.eip = before.eip;
  80059f:	a1 c0 20 80 00       	mov    0x8020c0,%eax
  8005a4:	a3 40 20 80 00       	mov    %eax,0x802040

	check_regs(&before, "before", &after, "after", "after page-fault");
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	68 07 18 80 00       	push   $0x801807
  8005b1:	68 18 18 80 00       	push   $0x801818
  8005b6:	b9 20 20 80 00       	mov    $0x802020,%ecx
  8005bb:	ba d8 17 80 00       	mov    $0x8017d8,%edx
  8005c0:	b8 a0 20 80 00       	mov    $0x8020a0,%eax
  8005c5:	e8 69 fa ff ff       	call   800033 <check_regs>
}
  8005ca:	83 c4 10             	add    $0x10,%esp
  8005cd:	c9                   	leave  
  8005ce:	c3                   	ret    
		cprintf("EIP after page-fault MISMATCH\n");
  8005cf:	83 ec 0c             	sub    $0xc,%esp
  8005d2:	68 54 18 80 00       	push   $0x801854
  8005d7:	e8 3b 01 00 00       	call   800717 <cprintf>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	eb be                	jmp    80059f <umain+0xd7>

008005e1 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8005e1:	55                   	push   %ebp
  8005e2:	89 e5                	mov    %esp,%ebp
  8005e4:	56                   	push   %esi
  8005e5:	53                   	push   %ebx
  8005e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005e9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  8005ec:	e8 00 0c 00 00       	call   8011f1 <sys_getenvid>
  8005f1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005f6:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8005fc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800601:	a3 cc 20 80 00       	mov    %eax,0x8020cc

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800606:	85 db                	test   %ebx,%ebx
  800608:	7e 07                	jle    800611 <libmain+0x30>
		binaryname = argv[0];
  80060a:	8b 06                	mov    (%esi),%eax
  80060c:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800611:	83 ec 08             	sub    $0x8,%esp
  800614:	56                   	push   %esi
  800615:	53                   	push   %ebx
  800616:	e8 ad fe ff ff       	call   8004c8 <umain>

	// exit gracefully
	exit();
  80061b:	e8 0a 00 00 00       	call   80062a <exit>
}
  800620:	83 c4 10             	add    $0x10,%esp
  800623:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800626:	5b                   	pop    %ebx
  800627:	5e                   	pop    %esi
  800628:	5d                   	pop    %ebp
  800629:	c3                   	ret    

0080062a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80062a:	55                   	push   %ebp
  80062b:	89 e5                	mov    %esp,%ebp
  80062d:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800630:	6a 00                	push   $0x0
  800632:	e8 79 0b 00 00       	call   8011b0 <sys_env_destroy>
}
  800637:	83 c4 10             	add    $0x10,%esp
  80063a:	c9                   	leave  
  80063b:	c3                   	ret    

0080063c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80063c:	55                   	push   %ebp
  80063d:	89 e5                	mov    %esp,%ebp
  80063f:	56                   	push   %esi
  800640:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800641:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800644:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80064a:	e8 a2 0b 00 00       	call   8011f1 <sys_getenvid>
  80064f:	83 ec 0c             	sub    $0xc,%esp
  800652:	ff 75 0c             	pushl  0xc(%ebp)
  800655:	ff 75 08             	pushl  0x8(%ebp)
  800658:	56                   	push   %esi
  800659:	50                   	push   %eax
  80065a:	68 80 18 80 00       	push   $0x801880
  80065f:	e8 b3 00 00 00       	call   800717 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800664:	83 c4 18             	add    $0x18,%esp
  800667:	53                   	push   %ebx
  800668:	ff 75 10             	pushl  0x10(%ebp)
  80066b:	e8 56 00 00 00       	call   8006c6 <vcprintf>
	cprintf("\n");
  800670:	c7 04 24 90 17 80 00 	movl   $0x801790,(%esp)
  800677:	e8 9b 00 00 00       	call   800717 <cprintf>
  80067c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80067f:	cc                   	int3   
  800680:	eb fd                	jmp    80067f <_panic+0x43>

00800682 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800682:	55                   	push   %ebp
  800683:	89 e5                	mov    %esp,%ebp
  800685:	53                   	push   %ebx
  800686:	83 ec 04             	sub    $0x4,%esp
  800689:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80068c:	8b 13                	mov    (%ebx),%edx
  80068e:	8d 42 01             	lea    0x1(%edx),%eax
  800691:	89 03                	mov    %eax,(%ebx)
  800693:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800696:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80069a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80069f:	74 09                	je     8006aa <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8006a1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8006a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006a8:	c9                   	leave  
  8006a9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	68 ff 00 00 00       	push   $0xff
  8006b2:	8d 43 08             	lea    0x8(%ebx),%eax
  8006b5:	50                   	push   %eax
  8006b6:	e8 b8 0a 00 00       	call   801173 <sys_cputs>
		b->idx = 0;
  8006bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8006c1:	83 c4 10             	add    $0x10,%esp
  8006c4:	eb db                	jmp    8006a1 <putch+0x1f>

008006c6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006c6:	55                   	push   %ebp
  8006c7:	89 e5                	mov    %esp,%ebp
  8006c9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006cf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006d6:	00 00 00 
	b.cnt = 0;
  8006d9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006e0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	ff 75 08             	pushl  0x8(%ebp)
  8006e9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006ef:	50                   	push   %eax
  8006f0:	68 82 06 80 00       	push   $0x800682
  8006f5:	e8 4a 01 00 00       	call   800844 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006fa:	83 c4 08             	add    $0x8,%esp
  8006fd:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800703:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800709:	50                   	push   %eax
  80070a:	e8 64 0a 00 00       	call   801173 <sys_cputs>

	return b.cnt;
}
  80070f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800715:	c9                   	leave  
  800716:	c3                   	ret    

00800717 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800717:	55                   	push   %ebp
  800718:	89 e5                	mov    %esp,%ebp
  80071a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80071d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800720:	50                   	push   %eax
  800721:	ff 75 08             	pushl  0x8(%ebp)
  800724:	e8 9d ff ff ff       	call   8006c6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800729:	c9                   	leave  
  80072a:	c3                   	ret    

0080072b <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	57                   	push   %edi
  80072f:	56                   	push   %esi
  800730:	53                   	push   %ebx
  800731:	83 ec 1c             	sub    $0x1c,%esp
  800734:	89 c6                	mov    %eax,%esi
  800736:	89 d7                	mov    %edx,%edi
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80073e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800741:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800744:	8b 45 10             	mov    0x10(%ebp),%eax
  800747:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  80074a:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80074e:	74 2c                	je     80077c <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800750:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800753:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80075a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80075d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800760:	39 c2                	cmp    %eax,%edx
  800762:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800765:	73 43                	jae    8007aa <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800767:	83 eb 01             	sub    $0x1,%ebx
  80076a:	85 db                	test   %ebx,%ebx
  80076c:	7e 6c                	jle    8007da <printnum+0xaf>
			putch(padc, putdat);
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	57                   	push   %edi
  800772:	ff 75 18             	pushl  0x18(%ebp)
  800775:	ff d6                	call   *%esi
  800777:	83 c4 10             	add    $0x10,%esp
  80077a:	eb eb                	jmp    800767 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80077c:	83 ec 0c             	sub    $0xc,%esp
  80077f:	6a 20                	push   $0x20
  800781:	6a 00                	push   $0x0
  800783:	50                   	push   %eax
  800784:	ff 75 e4             	pushl  -0x1c(%ebp)
  800787:	ff 75 e0             	pushl  -0x20(%ebp)
  80078a:	89 fa                	mov    %edi,%edx
  80078c:	89 f0                	mov    %esi,%eax
  80078e:	e8 98 ff ff ff       	call   80072b <printnum>
		while (--width > 0)
  800793:	83 c4 20             	add    $0x20,%esp
  800796:	83 eb 01             	sub    $0x1,%ebx
  800799:	85 db                	test   %ebx,%ebx
  80079b:	7e 65                	jle    800802 <printnum+0xd7>
			putch(' ', putdat);
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	57                   	push   %edi
  8007a1:	6a 20                	push   $0x20
  8007a3:	ff d6                	call   *%esi
  8007a5:	83 c4 10             	add    $0x10,%esp
  8007a8:	eb ec                	jmp    800796 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007aa:	83 ec 0c             	sub    $0xc,%esp
  8007ad:	ff 75 18             	pushl  0x18(%ebp)
  8007b0:	83 eb 01             	sub    $0x1,%ebx
  8007b3:	53                   	push   %ebx
  8007b4:	50                   	push   %eax
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	ff 75 dc             	pushl  -0x24(%ebp)
  8007bb:	ff 75 d8             	pushl  -0x28(%ebp)
  8007be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007c1:	ff 75 e0             	pushl  -0x20(%ebp)
  8007c4:	e8 37 0d 00 00       	call   801500 <__udivdi3>
  8007c9:	83 c4 18             	add    $0x18,%esp
  8007cc:	52                   	push   %edx
  8007cd:	50                   	push   %eax
  8007ce:	89 fa                	mov    %edi,%edx
  8007d0:	89 f0                	mov    %esi,%eax
  8007d2:	e8 54 ff ff ff       	call   80072b <printnum>
  8007d7:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007da:	83 ec 08             	sub    $0x8,%esp
  8007dd:	57                   	push   %edi
  8007de:	83 ec 04             	sub    $0x4,%esp
  8007e1:	ff 75 dc             	pushl  -0x24(%ebp)
  8007e4:	ff 75 d8             	pushl  -0x28(%ebp)
  8007e7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8007ed:	e8 1e 0e 00 00       	call   801610 <__umoddi3>
  8007f2:	83 c4 14             	add    $0x14,%esp
  8007f5:	0f be 80 a3 18 80 00 	movsbl 0x8018a3(%eax),%eax
  8007fc:	50                   	push   %eax
  8007fd:	ff d6                	call   *%esi
  8007ff:	83 c4 10             	add    $0x10,%esp
}
  800802:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800805:	5b                   	pop    %ebx
  800806:	5e                   	pop    %esi
  800807:	5f                   	pop    %edi
  800808:	5d                   	pop    %ebp
  800809:	c3                   	ret    

0080080a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80080a:	55                   	push   %ebp
  80080b:	89 e5                	mov    %esp,%ebp
  80080d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800810:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800814:	8b 10                	mov    (%eax),%edx
  800816:	3b 50 04             	cmp    0x4(%eax),%edx
  800819:	73 0a                	jae    800825 <sprintputch+0x1b>
		*b->buf++ = ch;
  80081b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80081e:	89 08                	mov    %ecx,(%eax)
  800820:	8b 45 08             	mov    0x8(%ebp),%eax
  800823:	88 02                	mov    %al,(%edx)
}
  800825:	5d                   	pop    %ebp
  800826:	c3                   	ret    

00800827 <printfmt>:
{
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80082d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800830:	50                   	push   %eax
  800831:	ff 75 10             	pushl  0x10(%ebp)
  800834:	ff 75 0c             	pushl  0xc(%ebp)
  800837:	ff 75 08             	pushl  0x8(%ebp)
  80083a:	e8 05 00 00 00       	call   800844 <vprintfmt>
}
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	c9                   	leave  
  800843:	c3                   	ret    

00800844 <vprintfmt>:
{
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	57                   	push   %edi
  800848:	56                   	push   %esi
  800849:	53                   	push   %ebx
  80084a:	83 ec 3c             	sub    $0x3c,%esp
  80084d:	8b 75 08             	mov    0x8(%ebp),%esi
  800850:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800853:	8b 7d 10             	mov    0x10(%ebp),%edi
  800856:	e9 1e 04 00 00       	jmp    800c79 <vprintfmt+0x435>
		posflag = 0;
  80085b:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  800862:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800866:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80086d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800874:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80087b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800882:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800887:	8d 47 01             	lea    0x1(%edi),%eax
  80088a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80088d:	0f b6 17             	movzbl (%edi),%edx
  800890:	8d 42 dd             	lea    -0x23(%edx),%eax
  800893:	3c 55                	cmp    $0x55,%al
  800895:	0f 87 d9 04 00 00    	ja     800d74 <vprintfmt+0x530>
  80089b:	0f b6 c0             	movzbl %al,%eax
  80089e:	ff 24 85 80 1a 80 00 	jmp    *0x801a80(,%eax,4)
  8008a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8008a8:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8008ac:	eb d9                	jmp    800887 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8008ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  8008b1:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  8008b8:	eb cd                	jmp    800887 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8008ba:	0f b6 d2             	movzbl %dl,%edx
  8008bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8008c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c5:	89 75 08             	mov    %esi,0x8(%ebp)
  8008c8:	eb 0c                	jmp    8008d6 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  8008ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8008cd:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8008d1:	eb b4                	jmp    800887 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  8008d3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8008d6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8008d9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8008dd:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8008e0:	8d 72 d0             	lea    -0x30(%edx),%esi
  8008e3:	83 fe 09             	cmp    $0x9,%esi
  8008e6:	76 eb                	jbe    8008d3 <vprintfmt+0x8f>
  8008e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ee:	eb 14                	jmp    800904 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  8008f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fb:	8d 40 04             	lea    0x4(%eax),%eax
  8008fe:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800901:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800904:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800908:	0f 89 79 ff ff ff    	jns    800887 <vprintfmt+0x43>
				width = precision, precision = -1;
  80090e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800911:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800914:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80091b:	e9 67 ff ff ff       	jmp    800887 <vprintfmt+0x43>
  800920:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800923:	85 c0                	test   %eax,%eax
  800925:	0f 48 c1             	cmovs  %ecx,%eax
  800928:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80092b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80092e:	e9 54 ff ff ff       	jmp    800887 <vprintfmt+0x43>
  800933:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800936:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80093d:	e9 45 ff ff ff       	jmp    800887 <vprintfmt+0x43>
			lflag++;
  800942:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800946:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800949:	e9 39 ff ff ff       	jmp    800887 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80094e:	8b 45 14             	mov    0x14(%ebp),%eax
  800951:	8d 78 04             	lea    0x4(%eax),%edi
  800954:	83 ec 08             	sub    $0x8,%esp
  800957:	53                   	push   %ebx
  800958:	ff 30                	pushl  (%eax)
  80095a:	ff d6                	call   *%esi
			break;
  80095c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80095f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800962:	e9 0f 03 00 00       	jmp    800c76 <vprintfmt+0x432>
			err = va_arg(ap, int);
  800967:	8b 45 14             	mov    0x14(%ebp),%eax
  80096a:	8d 78 04             	lea    0x4(%eax),%edi
  80096d:	8b 00                	mov    (%eax),%eax
  80096f:	99                   	cltd   
  800970:	31 d0                	xor    %edx,%eax
  800972:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800974:	83 f8 0f             	cmp    $0xf,%eax
  800977:	7f 23                	jg     80099c <vprintfmt+0x158>
  800979:	8b 14 85 e0 1b 80 00 	mov    0x801be0(,%eax,4),%edx
  800980:	85 d2                	test   %edx,%edx
  800982:	74 18                	je     80099c <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  800984:	52                   	push   %edx
  800985:	68 c4 18 80 00       	push   $0x8018c4
  80098a:	53                   	push   %ebx
  80098b:	56                   	push   %esi
  80098c:	e8 96 fe ff ff       	call   800827 <printfmt>
  800991:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800994:	89 7d 14             	mov    %edi,0x14(%ebp)
  800997:	e9 da 02 00 00       	jmp    800c76 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  80099c:	50                   	push   %eax
  80099d:	68 bb 18 80 00       	push   $0x8018bb
  8009a2:	53                   	push   %ebx
  8009a3:	56                   	push   %esi
  8009a4:	e8 7e fe ff ff       	call   800827 <printfmt>
  8009a9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8009ac:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8009af:	e9 c2 02 00 00       	jmp    800c76 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  8009b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b7:	83 c0 04             	add    $0x4,%eax
  8009ba:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8009bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c0:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8009c2:	85 c9                	test   %ecx,%ecx
  8009c4:	b8 b4 18 80 00       	mov    $0x8018b4,%eax
  8009c9:	0f 45 c1             	cmovne %ecx,%eax
  8009cc:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8009cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009d3:	7e 06                	jle    8009db <vprintfmt+0x197>
  8009d5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8009d9:	75 0d                	jne    8009e8 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8009de:	89 c7                	mov    %eax,%edi
  8009e0:	03 45 e0             	add    -0x20(%ebp),%eax
  8009e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8009e6:	eb 53                	jmp    800a3b <vprintfmt+0x1f7>
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 d8             	pushl  -0x28(%ebp)
  8009ee:	50                   	push   %eax
  8009ef:	e8 28 04 00 00       	call   800e1c <strnlen>
  8009f4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8009f7:	29 c1                	sub    %eax,%ecx
  8009f9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8009fc:	83 c4 10             	add    $0x10,%esp
  8009ff:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800a01:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800a05:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800a08:	eb 0f                	jmp    800a19 <vprintfmt+0x1d5>
					putch(padc, putdat);
  800a0a:	83 ec 08             	sub    $0x8,%esp
  800a0d:	53                   	push   %ebx
  800a0e:	ff 75 e0             	pushl  -0x20(%ebp)
  800a11:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800a13:	83 ef 01             	sub    $0x1,%edi
  800a16:	83 c4 10             	add    $0x10,%esp
  800a19:	85 ff                	test   %edi,%edi
  800a1b:	7f ed                	jg     800a0a <vprintfmt+0x1c6>
  800a1d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800a20:	85 c9                	test   %ecx,%ecx
  800a22:	b8 00 00 00 00       	mov    $0x0,%eax
  800a27:	0f 49 c1             	cmovns %ecx,%eax
  800a2a:	29 c1                	sub    %eax,%ecx
  800a2c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800a2f:	eb aa                	jmp    8009db <vprintfmt+0x197>
					putch(ch, putdat);
  800a31:	83 ec 08             	sub    $0x8,%esp
  800a34:	53                   	push   %ebx
  800a35:	52                   	push   %edx
  800a36:	ff d6                	call   *%esi
  800a38:	83 c4 10             	add    $0x10,%esp
  800a3b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a3e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a40:	83 c7 01             	add    $0x1,%edi
  800a43:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a47:	0f be d0             	movsbl %al,%edx
  800a4a:	85 d2                	test   %edx,%edx
  800a4c:	74 4b                	je     800a99 <vprintfmt+0x255>
  800a4e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800a52:	78 06                	js     800a5a <vprintfmt+0x216>
  800a54:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800a58:	78 1e                	js     800a78 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  800a5a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800a5e:	74 d1                	je     800a31 <vprintfmt+0x1ed>
  800a60:	0f be c0             	movsbl %al,%eax
  800a63:	83 e8 20             	sub    $0x20,%eax
  800a66:	83 f8 5e             	cmp    $0x5e,%eax
  800a69:	76 c6                	jbe    800a31 <vprintfmt+0x1ed>
					putch('?', putdat);
  800a6b:	83 ec 08             	sub    $0x8,%esp
  800a6e:	53                   	push   %ebx
  800a6f:	6a 3f                	push   $0x3f
  800a71:	ff d6                	call   *%esi
  800a73:	83 c4 10             	add    $0x10,%esp
  800a76:	eb c3                	jmp    800a3b <vprintfmt+0x1f7>
  800a78:	89 cf                	mov    %ecx,%edi
  800a7a:	eb 0e                	jmp    800a8a <vprintfmt+0x246>
				putch(' ', putdat);
  800a7c:	83 ec 08             	sub    $0x8,%esp
  800a7f:	53                   	push   %ebx
  800a80:	6a 20                	push   $0x20
  800a82:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800a84:	83 ef 01             	sub    $0x1,%edi
  800a87:	83 c4 10             	add    $0x10,%esp
  800a8a:	85 ff                	test   %edi,%edi
  800a8c:	7f ee                	jg     800a7c <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  800a8e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a91:	89 45 14             	mov    %eax,0x14(%ebp)
  800a94:	e9 dd 01 00 00       	jmp    800c76 <vprintfmt+0x432>
  800a99:	89 cf                	mov    %ecx,%edi
  800a9b:	eb ed                	jmp    800a8a <vprintfmt+0x246>
	if (lflag >= 2)
  800a9d:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800aa1:	7f 21                	jg     800ac4 <vprintfmt+0x280>
	else if (lflag)
  800aa3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800aa7:	74 6a                	je     800b13 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  800aa9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aac:	8b 00                	mov    (%eax),%eax
  800aae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ab1:	89 c1                	mov    %eax,%ecx
  800ab3:	c1 f9 1f             	sar    $0x1f,%ecx
  800ab6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800ab9:	8b 45 14             	mov    0x14(%ebp),%eax
  800abc:	8d 40 04             	lea    0x4(%eax),%eax
  800abf:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac2:	eb 17                	jmp    800adb <vprintfmt+0x297>
		return va_arg(*ap, long long);
  800ac4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac7:	8b 50 04             	mov    0x4(%eax),%edx
  800aca:	8b 00                	mov    (%eax),%eax
  800acc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800acf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ad2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad5:	8d 40 08             	lea    0x8(%eax),%eax
  800ad8:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800adb:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800ade:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800ae3:	85 d2                	test   %edx,%edx
  800ae5:	0f 89 5c 01 00 00    	jns    800c47 <vprintfmt+0x403>
				putch('-', putdat);
  800aeb:	83 ec 08             	sub    $0x8,%esp
  800aee:	53                   	push   %ebx
  800aef:	6a 2d                	push   $0x2d
  800af1:	ff d6                	call   *%esi
				num = -(long long) num;
  800af3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800af6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800af9:	f7 d8                	neg    %eax
  800afb:	83 d2 00             	adc    $0x0,%edx
  800afe:	f7 da                	neg    %edx
  800b00:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b03:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b06:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800b09:	bf 0a 00 00 00       	mov    $0xa,%edi
  800b0e:	e9 45 01 00 00       	jmp    800c58 <vprintfmt+0x414>
		return va_arg(*ap, int);
  800b13:	8b 45 14             	mov    0x14(%ebp),%eax
  800b16:	8b 00                	mov    (%eax),%eax
  800b18:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b1b:	89 c1                	mov    %eax,%ecx
  800b1d:	c1 f9 1f             	sar    $0x1f,%ecx
  800b20:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800b23:	8b 45 14             	mov    0x14(%ebp),%eax
  800b26:	8d 40 04             	lea    0x4(%eax),%eax
  800b29:	89 45 14             	mov    %eax,0x14(%ebp)
  800b2c:	eb ad                	jmp    800adb <vprintfmt+0x297>
	if (lflag >= 2)
  800b2e:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800b32:	7f 29                	jg     800b5d <vprintfmt+0x319>
	else if (lflag)
  800b34:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800b38:	74 44                	je     800b7e <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  800b3a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3d:	8b 00                	mov    (%eax),%eax
  800b3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b44:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b47:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4d:	8d 40 04             	lea    0x4(%eax),%eax
  800b50:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b53:	bf 0a 00 00 00       	mov    $0xa,%edi
  800b58:	e9 ea 00 00 00       	jmp    800c47 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800b5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b60:	8b 50 04             	mov    0x4(%eax),%edx
  800b63:	8b 00                	mov    (%eax),%eax
  800b65:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b68:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6e:	8d 40 08             	lea    0x8(%eax),%eax
  800b71:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b74:	bf 0a 00 00 00       	mov    $0xa,%edi
  800b79:	e9 c9 00 00 00       	jmp    800c47 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800b7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b81:	8b 00                	mov    (%eax),%eax
  800b83:	ba 00 00 00 00       	mov    $0x0,%edx
  800b88:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b8b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b91:	8d 40 04             	lea    0x4(%eax),%eax
  800b94:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b97:	bf 0a 00 00 00       	mov    $0xa,%edi
  800b9c:	e9 a6 00 00 00       	jmp    800c47 <vprintfmt+0x403>
			putch('0', putdat);
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	53                   	push   %ebx
  800ba5:	6a 30                	push   $0x30
  800ba7:	ff d6                	call   *%esi
	if (lflag >= 2)
  800ba9:	83 c4 10             	add    $0x10,%esp
  800bac:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800bb0:	7f 26                	jg     800bd8 <vprintfmt+0x394>
	else if (lflag)
  800bb2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800bb6:	74 3e                	je     800bf6 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  800bb8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbb:	8b 00                	mov    (%eax),%eax
  800bbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bc5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800bc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bcb:	8d 40 04             	lea    0x4(%eax),%eax
  800bce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800bd1:	bf 08 00 00 00       	mov    $0x8,%edi
  800bd6:	eb 6f                	jmp    800c47 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800bd8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bdb:	8b 50 04             	mov    0x4(%eax),%edx
  800bde:	8b 00                	mov    (%eax),%eax
  800be0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800be3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800be6:	8b 45 14             	mov    0x14(%ebp),%eax
  800be9:	8d 40 08             	lea    0x8(%eax),%eax
  800bec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800bef:	bf 08 00 00 00       	mov    $0x8,%edi
  800bf4:	eb 51                	jmp    800c47 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800bf6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf9:	8b 00                	mov    (%eax),%eax
  800bfb:	ba 00 00 00 00       	mov    $0x0,%edx
  800c00:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c03:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c06:	8b 45 14             	mov    0x14(%ebp),%eax
  800c09:	8d 40 04             	lea    0x4(%eax),%eax
  800c0c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c0f:	bf 08 00 00 00       	mov    $0x8,%edi
  800c14:	eb 31                	jmp    800c47 <vprintfmt+0x403>
			putch('0', putdat);
  800c16:	83 ec 08             	sub    $0x8,%esp
  800c19:	53                   	push   %ebx
  800c1a:	6a 30                	push   $0x30
  800c1c:	ff d6                	call   *%esi
			putch('x', putdat);
  800c1e:	83 c4 08             	add    $0x8,%esp
  800c21:	53                   	push   %ebx
  800c22:	6a 78                	push   $0x78
  800c24:	ff d6                	call   *%esi
			num = (unsigned long long)
  800c26:	8b 45 14             	mov    0x14(%ebp),%eax
  800c29:	8b 00                	mov    (%eax),%eax
  800c2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c30:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c33:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800c36:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800c39:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3c:	8d 40 04             	lea    0x4(%eax),%eax
  800c3f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c42:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  800c47:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800c4b:	74 0b                	je     800c58 <vprintfmt+0x414>
				putch('+', putdat);
  800c4d:	83 ec 08             	sub    $0x8,%esp
  800c50:	53                   	push   %ebx
  800c51:	6a 2b                	push   $0x2b
  800c53:	ff d6                	call   *%esi
  800c55:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800c58:	83 ec 0c             	sub    $0xc,%esp
  800c5b:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800c5f:	50                   	push   %eax
  800c60:	ff 75 e0             	pushl  -0x20(%ebp)
  800c63:	57                   	push   %edi
  800c64:	ff 75 dc             	pushl  -0x24(%ebp)
  800c67:	ff 75 d8             	pushl  -0x28(%ebp)
  800c6a:	89 da                	mov    %ebx,%edx
  800c6c:	89 f0                	mov    %esi,%eax
  800c6e:	e8 b8 fa ff ff       	call   80072b <printnum>
			break;
  800c73:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  800c76:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c79:	83 c7 01             	add    $0x1,%edi
  800c7c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800c80:	83 f8 25             	cmp    $0x25,%eax
  800c83:	0f 84 d2 fb ff ff    	je     80085b <vprintfmt+0x17>
			if (ch == '\0')
  800c89:	85 c0                	test   %eax,%eax
  800c8b:	0f 84 03 01 00 00    	je     800d94 <vprintfmt+0x550>
			putch(ch, putdat);
  800c91:	83 ec 08             	sub    $0x8,%esp
  800c94:	53                   	push   %ebx
  800c95:	50                   	push   %eax
  800c96:	ff d6                	call   *%esi
  800c98:	83 c4 10             	add    $0x10,%esp
  800c9b:	eb dc                	jmp    800c79 <vprintfmt+0x435>
	if (lflag >= 2)
  800c9d:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800ca1:	7f 29                	jg     800ccc <vprintfmt+0x488>
	else if (lflag)
  800ca3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800ca7:	74 44                	je     800ced <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  800ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cac:	8b 00                	mov    (%eax),%eax
  800cae:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cb6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800cb9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbc:	8d 40 04             	lea    0x4(%eax),%eax
  800cbf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800cc2:	bf 10 00 00 00       	mov    $0x10,%edi
  800cc7:	e9 7b ff ff ff       	jmp    800c47 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800ccc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccf:	8b 50 04             	mov    0x4(%eax),%edx
  800cd2:	8b 00                	mov    (%eax),%eax
  800cd4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cd7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800cda:	8b 45 14             	mov    0x14(%ebp),%eax
  800cdd:	8d 40 08             	lea    0x8(%eax),%eax
  800ce0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ce3:	bf 10 00 00 00       	mov    $0x10,%edi
  800ce8:	e9 5a ff ff ff       	jmp    800c47 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800ced:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf0:	8b 00                	mov    (%eax),%eax
  800cf2:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cfa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800cfd:	8b 45 14             	mov    0x14(%ebp),%eax
  800d00:	8d 40 04             	lea    0x4(%eax),%eax
  800d03:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d06:	bf 10 00 00 00       	mov    $0x10,%edi
  800d0b:	e9 37 ff ff ff       	jmp    800c47 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800d10:	8b 45 14             	mov    0x14(%ebp),%eax
  800d13:	8d 78 04             	lea    0x4(%eax),%edi
  800d16:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800d18:	85 c0                	test   %eax,%eax
  800d1a:	74 2c                	je     800d48 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800d1c:	8b 13                	mov    (%ebx),%edx
  800d1e:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800d20:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800d23:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800d26:	0f 8e 4a ff ff ff    	jle    800c76 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800d2c:	68 14 1a 80 00       	push   $0x801a14
  800d31:	68 c4 18 80 00       	push   $0x8018c4
  800d36:	53                   	push   %ebx
  800d37:	56                   	push   %esi
  800d38:	e8 ea fa ff ff       	call   800827 <printfmt>
  800d3d:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800d40:	89 7d 14             	mov    %edi,0x14(%ebp)
  800d43:	e9 2e ff ff ff       	jmp    800c76 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800d48:	68 dc 19 80 00       	push   $0x8019dc
  800d4d:	68 c4 18 80 00       	push   $0x8018c4
  800d52:	53                   	push   %ebx
  800d53:	56                   	push   %esi
  800d54:	e8 ce fa ff ff       	call   800827 <printfmt>
        		break;
  800d59:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800d5c:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800d5f:	e9 12 ff ff ff       	jmp    800c76 <vprintfmt+0x432>
			putch(ch, putdat);
  800d64:	83 ec 08             	sub    $0x8,%esp
  800d67:	53                   	push   %ebx
  800d68:	6a 25                	push   $0x25
  800d6a:	ff d6                	call   *%esi
			break;
  800d6c:	83 c4 10             	add    $0x10,%esp
  800d6f:	e9 02 ff ff ff       	jmp    800c76 <vprintfmt+0x432>
			putch('%', putdat);
  800d74:	83 ec 08             	sub    $0x8,%esp
  800d77:	53                   	push   %ebx
  800d78:	6a 25                	push   $0x25
  800d7a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d7c:	83 c4 10             	add    $0x10,%esp
  800d7f:	89 f8                	mov    %edi,%eax
  800d81:	eb 03                	jmp    800d86 <vprintfmt+0x542>
  800d83:	83 e8 01             	sub    $0x1,%eax
  800d86:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800d8a:	75 f7                	jne    800d83 <vprintfmt+0x53f>
  800d8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d8f:	e9 e2 fe ff ff       	jmp    800c76 <vprintfmt+0x432>
}
  800d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d97:	5b                   	pop    %ebx
  800d98:	5e                   	pop    %esi
  800d99:	5f                   	pop    %edi
  800d9a:	5d                   	pop    %ebp
  800d9b:	c3                   	ret    

00800d9c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
  800d9f:	83 ec 18             	sub    $0x18,%esp
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800da8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dab:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800daf:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800db2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800db9:	85 c0                	test   %eax,%eax
  800dbb:	74 26                	je     800de3 <vsnprintf+0x47>
  800dbd:	85 d2                	test   %edx,%edx
  800dbf:	7e 22                	jle    800de3 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dc1:	ff 75 14             	pushl  0x14(%ebp)
  800dc4:	ff 75 10             	pushl  0x10(%ebp)
  800dc7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dca:	50                   	push   %eax
  800dcb:	68 0a 08 80 00       	push   $0x80080a
  800dd0:	e8 6f fa ff ff       	call   800844 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dde:	83 c4 10             	add    $0x10,%esp
}
  800de1:	c9                   	leave  
  800de2:	c3                   	ret    
		return -E_INVAL;
  800de3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800de8:	eb f7                	jmp    800de1 <vsnprintf+0x45>

00800dea <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800df0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800df3:	50                   	push   %eax
  800df4:	ff 75 10             	pushl  0x10(%ebp)
  800df7:	ff 75 0c             	pushl  0xc(%ebp)
  800dfa:	ff 75 08             	pushl  0x8(%ebp)
  800dfd:	e8 9a ff ff ff       	call   800d9c <vsnprintf>
	va_end(ap);

	return rc;
}
  800e02:	c9                   	leave  
  800e03:	c3                   	ret    

00800e04 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800e0a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e0f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800e13:	74 05                	je     800e1a <strlen+0x16>
		n++;
  800e15:	83 c0 01             	add    $0x1,%eax
  800e18:	eb f5                	jmp    800e0f <strlen+0xb>
	return n;
}
  800e1a:	5d                   	pop    %ebp
  800e1b:	c3                   	ret    

00800e1c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e1c:	55                   	push   %ebp
  800e1d:	89 e5                	mov    %esp,%ebp
  800e1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e22:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e25:	ba 00 00 00 00       	mov    $0x0,%edx
  800e2a:	39 c2                	cmp    %eax,%edx
  800e2c:	74 0d                	je     800e3b <strnlen+0x1f>
  800e2e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800e32:	74 05                	je     800e39 <strnlen+0x1d>
		n++;
  800e34:	83 c2 01             	add    $0x1,%edx
  800e37:	eb f1                	jmp    800e2a <strnlen+0xe>
  800e39:	89 d0                	mov    %edx,%eax
	return n;
}
  800e3b:	5d                   	pop    %ebp
  800e3c:	c3                   	ret    

00800e3d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	53                   	push   %ebx
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800e47:	ba 00 00 00 00       	mov    $0x0,%edx
  800e4c:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800e50:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800e53:	83 c2 01             	add    $0x1,%edx
  800e56:	84 c9                	test   %cl,%cl
  800e58:	75 f2                	jne    800e4c <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800e5a:	5b                   	pop    %ebx
  800e5b:	5d                   	pop    %ebp
  800e5c:	c3                   	ret    

00800e5d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	53                   	push   %ebx
  800e61:	83 ec 10             	sub    $0x10,%esp
  800e64:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800e67:	53                   	push   %ebx
  800e68:	e8 97 ff ff ff       	call   800e04 <strlen>
  800e6d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800e70:	ff 75 0c             	pushl  0xc(%ebp)
  800e73:	01 d8                	add    %ebx,%eax
  800e75:	50                   	push   %eax
  800e76:	e8 c2 ff ff ff       	call   800e3d <strcpy>
	return dst;
}
  800e7b:	89 d8                	mov    %ebx,%eax
  800e7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e80:	c9                   	leave  
  800e81:	c3                   	ret    

00800e82 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	56                   	push   %esi
  800e86:	53                   	push   %ebx
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8d:	89 c6                	mov    %eax,%esi
  800e8f:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e92:	89 c2                	mov    %eax,%edx
  800e94:	39 f2                	cmp    %esi,%edx
  800e96:	74 11                	je     800ea9 <strncpy+0x27>
		*dst++ = *src;
  800e98:	83 c2 01             	add    $0x1,%edx
  800e9b:	0f b6 19             	movzbl (%ecx),%ebx
  800e9e:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ea1:	80 fb 01             	cmp    $0x1,%bl
  800ea4:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800ea7:	eb eb                	jmp    800e94 <strncpy+0x12>
	}
	return ret;
}
  800ea9:	5b                   	pop    %ebx
  800eaa:	5e                   	pop    %esi
  800eab:	5d                   	pop    %ebp
  800eac:	c3                   	ret    

00800ead <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	56                   	push   %esi
  800eb1:	53                   	push   %ebx
  800eb2:	8b 75 08             	mov    0x8(%ebp),%esi
  800eb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb8:	8b 55 10             	mov    0x10(%ebp),%edx
  800ebb:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ebd:	85 d2                	test   %edx,%edx
  800ebf:	74 21                	je     800ee2 <strlcpy+0x35>
  800ec1:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ec5:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ec7:	39 c2                	cmp    %eax,%edx
  800ec9:	74 14                	je     800edf <strlcpy+0x32>
  800ecb:	0f b6 19             	movzbl (%ecx),%ebx
  800ece:	84 db                	test   %bl,%bl
  800ed0:	74 0b                	je     800edd <strlcpy+0x30>
			*dst++ = *src++;
  800ed2:	83 c1 01             	add    $0x1,%ecx
  800ed5:	83 c2 01             	add    $0x1,%edx
  800ed8:	88 5a ff             	mov    %bl,-0x1(%edx)
  800edb:	eb ea                	jmp    800ec7 <strlcpy+0x1a>
  800edd:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800edf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ee2:	29 f0                	sub    %esi,%eax
}
  800ee4:	5b                   	pop    %ebx
  800ee5:	5e                   	pop    %esi
  800ee6:	5d                   	pop    %ebp
  800ee7:	c3                   	ret    

00800ee8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eee:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ef1:	0f b6 01             	movzbl (%ecx),%eax
  800ef4:	84 c0                	test   %al,%al
  800ef6:	74 0c                	je     800f04 <strcmp+0x1c>
  800ef8:	3a 02                	cmp    (%edx),%al
  800efa:	75 08                	jne    800f04 <strcmp+0x1c>
		p++, q++;
  800efc:	83 c1 01             	add    $0x1,%ecx
  800eff:	83 c2 01             	add    $0x1,%edx
  800f02:	eb ed                	jmp    800ef1 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f04:	0f b6 c0             	movzbl %al,%eax
  800f07:	0f b6 12             	movzbl (%edx),%edx
  800f0a:	29 d0                	sub    %edx,%eax
}
  800f0c:	5d                   	pop    %ebp
  800f0d:	c3                   	ret    

00800f0e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	53                   	push   %ebx
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f18:	89 c3                	mov    %eax,%ebx
  800f1a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800f1d:	eb 06                	jmp    800f25 <strncmp+0x17>
		n--, p++, q++;
  800f1f:	83 c0 01             	add    $0x1,%eax
  800f22:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800f25:	39 d8                	cmp    %ebx,%eax
  800f27:	74 16                	je     800f3f <strncmp+0x31>
  800f29:	0f b6 08             	movzbl (%eax),%ecx
  800f2c:	84 c9                	test   %cl,%cl
  800f2e:	74 04                	je     800f34 <strncmp+0x26>
  800f30:	3a 0a                	cmp    (%edx),%cl
  800f32:	74 eb                	je     800f1f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f34:	0f b6 00             	movzbl (%eax),%eax
  800f37:	0f b6 12             	movzbl (%edx),%edx
  800f3a:	29 d0                	sub    %edx,%eax
}
  800f3c:	5b                   	pop    %ebx
  800f3d:	5d                   	pop    %ebp
  800f3e:	c3                   	ret    
		return 0;
  800f3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f44:	eb f6                	jmp    800f3c <strncmp+0x2e>

00800f46 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800f50:	0f b6 10             	movzbl (%eax),%edx
  800f53:	84 d2                	test   %dl,%dl
  800f55:	74 09                	je     800f60 <strchr+0x1a>
		if (*s == c)
  800f57:	38 ca                	cmp    %cl,%dl
  800f59:	74 0a                	je     800f65 <strchr+0x1f>
	for (; *s; s++)
  800f5b:	83 c0 01             	add    $0x1,%eax
  800f5e:	eb f0                	jmp    800f50 <strchr+0xa>
			return (char *) s;
	return 0;
  800f60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f65:	5d                   	pop    %ebp
  800f66:	c3                   	ret    

00800f67 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800f71:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800f74:	38 ca                	cmp    %cl,%dl
  800f76:	74 09                	je     800f81 <strfind+0x1a>
  800f78:	84 d2                	test   %dl,%dl
  800f7a:	74 05                	je     800f81 <strfind+0x1a>
	for (; *s; s++)
  800f7c:	83 c0 01             	add    $0x1,%eax
  800f7f:	eb f0                	jmp    800f71 <strfind+0xa>
			break;
	return (char *) s;
}
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    

00800f83 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	57                   	push   %edi
  800f87:	56                   	push   %esi
  800f88:	53                   	push   %ebx
  800f89:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f8c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800f8f:	85 c9                	test   %ecx,%ecx
  800f91:	74 31                	je     800fc4 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800f93:	89 f8                	mov    %edi,%eax
  800f95:	09 c8                	or     %ecx,%eax
  800f97:	a8 03                	test   $0x3,%al
  800f99:	75 23                	jne    800fbe <memset+0x3b>
		c &= 0xFF;
  800f9b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800f9f:	89 d3                	mov    %edx,%ebx
  800fa1:	c1 e3 08             	shl    $0x8,%ebx
  800fa4:	89 d0                	mov    %edx,%eax
  800fa6:	c1 e0 18             	shl    $0x18,%eax
  800fa9:	89 d6                	mov    %edx,%esi
  800fab:	c1 e6 10             	shl    $0x10,%esi
  800fae:	09 f0                	or     %esi,%eax
  800fb0:	09 c2                	or     %eax,%edx
  800fb2:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800fb4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800fb7:	89 d0                	mov    %edx,%eax
  800fb9:	fc                   	cld    
  800fba:	f3 ab                	rep stos %eax,%es:(%edi)
  800fbc:	eb 06                	jmp    800fc4 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc1:	fc                   	cld    
  800fc2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800fc4:	89 f8                	mov    %edi,%eax
  800fc6:	5b                   	pop    %ebx
  800fc7:	5e                   	pop    %esi
  800fc8:	5f                   	pop    %edi
  800fc9:	5d                   	pop    %ebp
  800fca:	c3                   	ret    

00800fcb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	57                   	push   %edi
  800fcf:	56                   	push   %esi
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fd6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fd9:	39 c6                	cmp    %eax,%esi
  800fdb:	73 32                	jae    80100f <memmove+0x44>
  800fdd:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800fe0:	39 c2                	cmp    %eax,%edx
  800fe2:	76 2b                	jbe    80100f <memmove+0x44>
		s += n;
		d += n;
  800fe4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800fe7:	89 fe                	mov    %edi,%esi
  800fe9:	09 ce                	or     %ecx,%esi
  800feb:	09 d6                	or     %edx,%esi
  800fed:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ff3:	75 0e                	jne    801003 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ff5:	83 ef 04             	sub    $0x4,%edi
  800ff8:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ffb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ffe:	fd                   	std    
  800fff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801001:	eb 09                	jmp    80100c <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801003:	83 ef 01             	sub    $0x1,%edi
  801006:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801009:	fd                   	std    
  80100a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80100c:	fc                   	cld    
  80100d:	eb 1a                	jmp    801029 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80100f:	89 c2                	mov    %eax,%edx
  801011:	09 ca                	or     %ecx,%edx
  801013:	09 f2                	or     %esi,%edx
  801015:	f6 c2 03             	test   $0x3,%dl
  801018:	75 0a                	jne    801024 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80101a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80101d:	89 c7                	mov    %eax,%edi
  80101f:	fc                   	cld    
  801020:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801022:	eb 05                	jmp    801029 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801024:	89 c7                	mov    %eax,%edi
  801026:	fc                   	cld    
  801027:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801029:	5e                   	pop    %esi
  80102a:	5f                   	pop    %edi
  80102b:	5d                   	pop    %ebp
  80102c:	c3                   	ret    

0080102d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801033:	ff 75 10             	pushl  0x10(%ebp)
  801036:	ff 75 0c             	pushl  0xc(%ebp)
  801039:	ff 75 08             	pushl  0x8(%ebp)
  80103c:	e8 8a ff ff ff       	call   800fcb <memmove>
}
  801041:	c9                   	leave  
  801042:	c3                   	ret    

00801043 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801043:	55                   	push   %ebp
  801044:	89 e5                	mov    %esp,%ebp
  801046:	56                   	push   %esi
  801047:	53                   	push   %ebx
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80104e:	89 c6                	mov    %eax,%esi
  801050:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801053:	39 f0                	cmp    %esi,%eax
  801055:	74 1c                	je     801073 <memcmp+0x30>
		if (*s1 != *s2)
  801057:	0f b6 08             	movzbl (%eax),%ecx
  80105a:	0f b6 1a             	movzbl (%edx),%ebx
  80105d:	38 d9                	cmp    %bl,%cl
  80105f:	75 08                	jne    801069 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801061:	83 c0 01             	add    $0x1,%eax
  801064:	83 c2 01             	add    $0x1,%edx
  801067:	eb ea                	jmp    801053 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801069:	0f b6 c1             	movzbl %cl,%eax
  80106c:	0f b6 db             	movzbl %bl,%ebx
  80106f:	29 d8                	sub    %ebx,%eax
  801071:	eb 05                	jmp    801078 <memcmp+0x35>
	}

	return 0;
  801073:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801078:	5b                   	pop    %ebx
  801079:	5e                   	pop    %esi
  80107a:	5d                   	pop    %ebp
  80107b:	c3                   	ret    

0080107c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80107c:	55                   	push   %ebp
  80107d:	89 e5                	mov    %esp,%ebp
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801085:	89 c2                	mov    %eax,%edx
  801087:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80108a:	39 d0                	cmp    %edx,%eax
  80108c:	73 09                	jae    801097 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80108e:	38 08                	cmp    %cl,(%eax)
  801090:	74 05                	je     801097 <memfind+0x1b>
	for (; s < ends; s++)
  801092:	83 c0 01             	add    $0x1,%eax
  801095:	eb f3                	jmp    80108a <memfind+0xe>
			break;
	return (void *) s;
}
  801097:	5d                   	pop    %ebp
  801098:	c3                   	ret    

00801099 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	57                   	push   %edi
  80109d:	56                   	push   %esi
  80109e:	53                   	push   %ebx
  80109f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a5:	eb 03                	jmp    8010aa <strtol+0x11>
		s++;
  8010a7:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8010aa:	0f b6 01             	movzbl (%ecx),%eax
  8010ad:	3c 20                	cmp    $0x20,%al
  8010af:	74 f6                	je     8010a7 <strtol+0xe>
  8010b1:	3c 09                	cmp    $0x9,%al
  8010b3:	74 f2                	je     8010a7 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8010b5:	3c 2b                	cmp    $0x2b,%al
  8010b7:	74 2a                	je     8010e3 <strtol+0x4a>
	int neg = 0;
  8010b9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8010be:	3c 2d                	cmp    $0x2d,%al
  8010c0:	74 2b                	je     8010ed <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010c2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8010c8:	75 0f                	jne    8010d9 <strtol+0x40>
  8010ca:	80 39 30             	cmpb   $0x30,(%ecx)
  8010cd:	74 28                	je     8010f7 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8010cf:	85 db                	test   %ebx,%ebx
  8010d1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010d6:	0f 44 d8             	cmove  %eax,%ebx
  8010d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8010de:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8010e1:	eb 50                	jmp    801133 <strtol+0x9a>
		s++;
  8010e3:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8010e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8010eb:	eb d5                	jmp    8010c2 <strtol+0x29>
		s++, neg = 1;
  8010ed:	83 c1 01             	add    $0x1,%ecx
  8010f0:	bf 01 00 00 00       	mov    $0x1,%edi
  8010f5:	eb cb                	jmp    8010c2 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010f7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8010fb:	74 0e                	je     80110b <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8010fd:	85 db                	test   %ebx,%ebx
  8010ff:	75 d8                	jne    8010d9 <strtol+0x40>
		s++, base = 8;
  801101:	83 c1 01             	add    $0x1,%ecx
  801104:	bb 08 00 00 00       	mov    $0x8,%ebx
  801109:	eb ce                	jmp    8010d9 <strtol+0x40>
		s += 2, base = 16;
  80110b:	83 c1 02             	add    $0x2,%ecx
  80110e:	bb 10 00 00 00       	mov    $0x10,%ebx
  801113:	eb c4                	jmp    8010d9 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801115:	8d 72 9f             	lea    -0x61(%edx),%esi
  801118:	89 f3                	mov    %esi,%ebx
  80111a:	80 fb 19             	cmp    $0x19,%bl
  80111d:	77 29                	ja     801148 <strtol+0xaf>
			dig = *s - 'a' + 10;
  80111f:	0f be d2             	movsbl %dl,%edx
  801122:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801125:	3b 55 10             	cmp    0x10(%ebp),%edx
  801128:	7d 30                	jge    80115a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  80112a:	83 c1 01             	add    $0x1,%ecx
  80112d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801131:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801133:	0f b6 11             	movzbl (%ecx),%edx
  801136:	8d 72 d0             	lea    -0x30(%edx),%esi
  801139:	89 f3                	mov    %esi,%ebx
  80113b:	80 fb 09             	cmp    $0x9,%bl
  80113e:	77 d5                	ja     801115 <strtol+0x7c>
			dig = *s - '0';
  801140:	0f be d2             	movsbl %dl,%edx
  801143:	83 ea 30             	sub    $0x30,%edx
  801146:	eb dd                	jmp    801125 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801148:	8d 72 bf             	lea    -0x41(%edx),%esi
  80114b:	89 f3                	mov    %esi,%ebx
  80114d:	80 fb 19             	cmp    $0x19,%bl
  801150:	77 08                	ja     80115a <strtol+0xc1>
			dig = *s - 'A' + 10;
  801152:	0f be d2             	movsbl %dl,%edx
  801155:	83 ea 37             	sub    $0x37,%edx
  801158:	eb cb                	jmp    801125 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  80115a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80115e:	74 05                	je     801165 <strtol+0xcc>
		*endptr = (char *) s;
  801160:	8b 75 0c             	mov    0xc(%ebp),%esi
  801163:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801165:	89 c2                	mov    %eax,%edx
  801167:	f7 da                	neg    %edx
  801169:	85 ff                	test   %edi,%edi
  80116b:	0f 45 c2             	cmovne %edx,%eax
}
  80116e:	5b                   	pop    %ebx
  80116f:	5e                   	pop    %esi
  801170:	5f                   	pop    %edi
  801171:	5d                   	pop    %ebp
  801172:	c3                   	ret    

00801173 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801173:	55                   	push   %ebp
  801174:	89 e5                	mov    %esp,%ebp
  801176:	57                   	push   %edi
  801177:	56                   	push   %esi
  801178:	53                   	push   %ebx
	asm volatile("int %1\n"
  801179:	b8 00 00 00 00       	mov    $0x0,%eax
  80117e:	8b 55 08             	mov    0x8(%ebp),%edx
  801181:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801184:	89 c3                	mov    %eax,%ebx
  801186:	89 c7                	mov    %eax,%edi
  801188:	89 c6                	mov    %eax,%esi
  80118a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80118c:	5b                   	pop    %ebx
  80118d:	5e                   	pop    %esi
  80118e:	5f                   	pop    %edi
  80118f:	5d                   	pop    %ebp
  801190:	c3                   	ret    

00801191 <sys_cgetc>:

int
sys_cgetc(void)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	57                   	push   %edi
  801195:	56                   	push   %esi
  801196:	53                   	push   %ebx
	asm volatile("int %1\n"
  801197:	ba 00 00 00 00       	mov    $0x0,%edx
  80119c:	b8 01 00 00 00       	mov    $0x1,%eax
  8011a1:	89 d1                	mov    %edx,%ecx
  8011a3:	89 d3                	mov    %edx,%ebx
  8011a5:	89 d7                	mov    %edx,%edi
  8011a7:	89 d6                	mov    %edx,%esi
  8011a9:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8011ab:	5b                   	pop    %ebx
  8011ac:	5e                   	pop    %esi
  8011ad:	5f                   	pop    %edi
  8011ae:	5d                   	pop    %ebp
  8011af:	c3                   	ret    

008011b0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	57                   	push   %edi
  8011b4:	56                   	push   %esi
  8011b5:	53                   	push   %ebx
  8011b6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011be:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c1:	b8 03 00 00 00       	mov    $0x3,%eax
  8011c6:	89 cb                	mov    %ecx,%ebx
  8011c8:	89 cf                	mov    %ecx,%edi
  8011ca:	89 ce                	mov    %ecx,%esi
  8011cc:	cd 30                	int    $0x30
	if (check && ret > 0)
  8011ce:	85 c0                	test   %eax,%eax
  8011d0:	7f 08                	jg     8011da <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8011d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d5:	5b                   	pop    %ebx
  8011d6:	5e                   	pop    %esi
  8011d7:	5f                   	pop    %edi
  8011d8:	5d                   	pop    %ebp
  8011d9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011da:	83 ec 0c             	sub    $0xc,%esp
  8011dd:	50                   	push   %eax
  8011de:	6a 03                	push   $0x3
  8011e0:	68 20 1c 80 00       	push   $0x801c20
  8011e5:	6a 4c                	push   $0x4c
  8011e7:	68 3d 1c 80 00       	push   $0x801c3d
  8011ec:	e8 4b f4 ff ff       	call   80063c <_panic>

008011f1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	57                   	push   %edi
  8011f5:	56                   	push   %esi
  8011f6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8011fc:	b8 02 00 00 00       	mov    $0x2,%eax
  801201:	89 d1                	mov    %edx,%ecx
  801203:	89 d3                	mov    %edx,%ebx
  801205:	89 d7                	mov    %edx,%edi
  801207:	89 d6                	mov    %edx,%esi
  801209:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80120b:	5b                   	pop    %ebx
  80120c:	5e                   	pop    %esi
  80120d:	5f                   	pop    %edi
  80120e:	5d                   	pop    %ebp
  80120f:	c3                   	ret    

00801210 <sys_yield>:

void
sys_yield(void)
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
  801213:	57                   	push   %edi
  801214:	56                   	push   %esi
  801215:	53                   	push   %ebx
	asm volatile("int %1\n"
  801216:	ba 00 00 00 00       	mov    $0x0,%edx
  80121b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801220:	89 d1                	mov    %edx,%ecx
  801222:	89 d3                	mov    %edx,%ebx
  801224:	89 d7                	mov    %edx,%edi
  801226:	89 d6                	mov    %edx,%esi
  801228:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80122a:	5b                   	pop    %ebx
  80122b:	5e                   	pop    %esi
  80122c:	5f                   	pop    %edi
  80122d:	5d                   	pop    %ebp
  80122e:	c3                   	ret    

0080122f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80122f:	55                   	push   %ebp
  801230:	89 e5                	mov    %esp,%ebp
  801232:	57                   	push   %edi
  801233:	56                   	push   %esi
  801234:	53                   	push   %ebx
  801235:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801238:	be 00 00 00 00       	mov    $0x0,%esi
  80123d:	8b 55 08             	mov    0x8(%ebp),%edx
  801240:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801243:	b8 04 00 00 00       	mov    $0x4,%eax
  801248:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80124b:	89 f7                	mov    %esi,%edi
  80124d:	cd 30                	int    $0x30
	if (check && ret > 0)
  80124f:	85 c0                	test   %eax,%eax
  801251:	7f 08                	jg     80125b <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801253:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801256:	5b                   	pop    %ebx
  801257:	5e                   	pop    %esi
  801258:	5f                   	pop    %edi
  801259:	5d                   	pop    %ebp
  80125a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80125b:	83 ec 0c             	sub    $0xc,%esp
  80125e:	50                   	push   %eax
  80125f:	6a 04                	push   $0x4
  801261:	68 20 1c 80 00       	push   $0x801c20
  801266:	6a 4c                	push   $0x4c
  801268:	68 3d 1c 80 00       	push   $0x801c3d
  80126d:	e8 ca f3 ff ff       	call   80063c <_panic>

00801272 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	57                   	push   %edi
  801276:	56                   	push   %esi
  801277:	53                   	push   %ebx
  801278:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80127b:	8b 55 08             	mov    0x8(%ebp),%edx
  80127e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801281:	b8 05 00 00 00       	mov    $0x5,%eax
  801286:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801289:	8b 7d 14             	mov    0x14(%ebp),%edi
  80128c:	8b 75 18             	mov    0x18(%ebp),%esi
  80128f:	cd 30                	int    $0x30
	if (check && ret > 0)
  801291:	85 c0                	test   %eax,%eax
  801293:	7f 08                	jg     80129d <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801295:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801298:	5b                   	pop    %ebx
  801299:	5e                   	pop    %esi
  80129a:	5f                   	pop    %edi
  80129b:	5d                   	pop    %ebp
  80129c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80129d:	83 ec 0c             	sub    $0xc,%esp
  8012a0:	50                   	push   %eax
  8012a1:	6a 05                	push   $0x5
  8012a3:	68 20 1c 80 00       	push   $0x801c20
  8012a8:	6a 4c                	push   $0x4c
  8012aa:	68 3d 1c 80 00       	push   $0x801c3d
  8012af:	e8 88 f3 ff ff       	call   80063c <_panic>

008012b4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	57                   	push   %edi
  8012b8:	56                   	push   %esi
  8012b9:	53                   	push   %ebx
  8012ba:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012c8:	b8 06 00 00 00       	mov    $0x6,%eax
  8012cd:	89 df                	mov    %ebx,%edi
  8012cf:	89 de                	mov    %ebx,%esi
  8012d1:	cd 30                	int    $0x30
	if (check && ret > 0)
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	7f 08                	jg     8012df <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8012d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012da:	5b                   	pop    %ebx
  8012db:	5e                   	pop    %esi
  8012dc:	5f                   	pop    %edi
  8012dd:	5d                   	pop    %ebp
  8012de:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012df:	83 ec 0c             	sub    $0xc,%esp
  8012e2:	50                   	push   %eax
  8012e3:	6a 06                	push   $0x6
  8012e5:	68 20 1c 80 00       	push   $0x801c20
  8012ea:	6a 4c                	push   $0x4c
  8012ec:	68 3d 1c 80 00       	push   $0x801c3d
  8012f1:	e8 46 f3 ff ff       	call   80063c <_panic>

008012f6 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8012f6:	55                   	push   %ebp
  8012f7:	89 e5                	mov    %esp,%ebp
  8012f9:	57                   	push   %edi
  8012fa:	56                   	push   %esi
  8012fb:	53                   	push   %ebx
  8012fc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  801304:	8b 55 08             	mov    0x8(%ebp),%edx
  801307:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80130a:	b8 08 00 00 00       	mov    $0x8,%eax
  80130f:	89 df                	mov    %ebx,%edi
  801311:	89 de                	mov    %ebx,%esi
  801313:	cd 30                	int    $0x30
	if (check && ret > 0)
  801315:	85 c0                	test   %eax,%eax
  801317:	7f 08                	jg     801321 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801319:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80131c:	5b                   	pop    %ebx
  80131d:	5e                   	pop    %esi
  80131e:	5f                   	pop    %edi
  80131f:	5d                   	pop    %ebp
  801320:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801321:	83 ec 0c             	sub    $0xc,%esp
  801324:	50                   	push   %eax
  801325:	6a 08                	push   $0x8
  801327:	68 20 1c 80 00       	push   $0x801c20
  80132c:	6a 4c                	push   $0x4c
  80132e:	68 3d 1c 80 00       	push   $0x801c3d
  801333:	e8 04 f3 ff ff       	call   80063c <_panic>

00801338 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801338:	55                   	push   %ebp
  801339:	89 e5                	mov    %esp,%ebp
  80133b:	57                   	push   %edi
  80133c:	56                   	push   %esi
  80133d:	53                   	push   %ebx
  80133e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801341:	bb 00 00 00 00       	mov    $0x0,%ebx
  801346:	8b 55 08             	mov    0x8(%ebp),%edx
  801349:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80134c:	b8 09 00 00 00       	mov    $0x9,%eax
  801351:	89 df                	mov    %ebx,%edi
  801353:	89 de                	mov    %ebx,%esi
  801355:	cd 30                	int    $0x30
	if (check && ret > 0)
  801357:	85 c0                	test   %eax,%eax
  801359:	7f 08                	jg     801363 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80135b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80135e:	5b                   	pop    %ebx
  80135f:	5e                   	pop    %esi
  801360:	5f                   	pop    %edi
  801361:	5d                   	pop    %ebp
  801362:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801363:	83 ec 0c             	sub    $0xc,%esp
  801366:	50                   	push   %eax
  801367:	6a 09                	push   $0x9
  801369:	68 20 1c 80 00       	push   $0x801c20
  80136e:	6a 4c                	push   $0x4c
  801370:	68 3d 1c 80 00       	push   $0x801c3d
  801375:	e8 c2 f2 ff ff       	call   80063c <_panic>

0080137a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	57                   	push   %edi
  80137e:	56                   	push   %esi
  80137f:	53                   	push   %ebx
  801380:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801383:	bb 00 00 00 00       	mov    $0x0,%ebx
  801388:	8b 55 08             	mov    0x8(%ebp),%edx
  80138b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80138e:	b8 0a 00 00 00       	mov    $0xa,%eax
  801393:	89 df                	mov    %ebx,%edi
  801395:	89 de                	mov    %ebx,%esi
  801397:	cd 30                	int    $0x30
	if (check && ret > 0)
  801399:	85 c0                	test   %eax,%eax
  80139b:	7f 08                	jg     8013a5 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80139d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013a0:	5b                   	pop    %ebx
  8013a1:	5e                   	pop    %esi
  8013a2:	5f                   	pop    %edi
  8013a3:	5d                   	pop    %ebp
  8013a4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013a5:	83 ec 0c             	sub    $0xc,%esp
  8013a8:	50                   	push   %eax
  8013a9:	6a 0a                	push   $0xa
  8013ab:	68 20 1c 80 00       	push   $0x801c20
  8013b0:	6a 4c                	push   $0x4c
  8013b2:	68 3d 1c 80 00       	push   $0x801c3d
  8013b7:	e8 80 f2 ff ff       	call   80063c <_panic>

008013bc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	57                   	push   %edi
  8013c0:	56                   	push   %esi
  8013c1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013c8:	b8 0c 00 00 00       	mov    $0xc,%eax
  8013cd:	be 00 00 00 00       	mov    $0x0,%esi
  8013d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013d5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8013d8:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8013da:	5b                   	pop    %ebx
  8013db:	5e                   	pop    %esi
  8013dc:	5f                   	pop    %edi
  8013dd:	5d                   	pop    %ebp
  8013de:	c3                   	ret    

008013df <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
  8013e2:	57                   	push   %edi
  8013e3:	56                   	push   %esi
  8013e4:	53                   	push   %ebx
  8013e5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f0:	b8 0d 00 00 00       	mov    $0xd,%eax
  8013f5:	89 cb                	mov    %ecx,%ebx
  8013f7:	89 cf                	mov    %ecx,%edi
  8013f9:	89 ce                	mov    %ecx,%esi
  8013fb:	cd 30                	int    $0x30
	if (check && ret > 0)
  8013fd:	85 c0                	test   %eax,%eax
  8013ff:	7f 08                	jg     801409 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801401:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801404:	5b                   	pop    %ebx
  801405:	5e                   	pop    %esi
  801406:	5f                   	pop    %edi
  801407:	5d                   	pop    %ebp
  801408:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801409:	83 ec 0c             	sub    $0xc,%esp
  80140c:	50                   	push   %eax
  80140d:	6a 0d                	push   $0xd
  80140f:	68 20 1c 80 00       	push   $0x801c20
  801414:	6a 4c                	push   $0x4c
  801416:	68 3d 1c 80 00       	push   $0x801c3d
  80141b:	e8 1c f2 ff ff       	call   80063c <_panic>

00801420 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	57                   	push   %edi
  801424:	56                   	push   %esi
  801425:	53                   	push   %ebx
	asm volatile("int %1\n"
  801426:	bb 00 00 00 00       	mov    $0x0,%ebx
  80142b:	8b 55 08             	mov    0x8(%ebp),%edx
  80142e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801431:	b8 0e 00 00 00       	mov    $0xe,%eax
  801436:	89 df                	mov    %ebx,%edi
  801438:	89 de                	mov    %ebx,%esi
  80143a:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80143c:	5b                   	pop    %ebx
  80143d:	5e                   	pop    %esi
  80143e:	5f                   	pop    %edi
  80143f:	5d                   	pop    %ebp
  801440:	c3                   	ret    

00801441 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
  801444:	57                   	push   %edi
  801445:	56                   	push   %esi
  801446:	53                   	push   %ebx
	asm volatile("int %1\n"
  801447:	b9 00 00 00 00       	mov    $0x0,%ecx
  80144c:	8b 55 08             	mov    0x8(%ebp),%edx
  80144f:	b8 0f 00 00 00       	mov    $0xf,%eax
  801454:	89 cb                	mov    %ecx,%ebx
  801456:	89 cf                	mov    %ecx,%edi
  801458:	89 ce                	mov    %ecx,%esi
  80145a:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80145c:	5b                   	pop    %ebx
  80145d:	5e                   	pop    %esi
  80145e:	5f                   	pop    %edi
  80145f:	5d                   	pop    %ebp
  801460:	c3                   	ret    

00801461 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
  801464:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801467:	83 3d d0 20 80 00 00 	cmpl   $0x0,0x8020d0
  80146e:	74 0a                	je     80147a <set_pgfault_handler+0x19>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	a3 d0 20 80 00       	mov    %eax,0x8020d0
}
  801478:	c9                   	leave  
  801479:	c3                   	ret    
		ret = sys_page_alloc((envid_t)0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W);
  80147a:	83 ec 04             	sub    $0x4,%esp
  80147d:	6a 07                	push   $0x7
  80147f:	68 00 f0 bf ee       	push   $0xeebff000
  801484:	6a 00                	push   $0x0
  801486:	e8 a4 fd ff ff       	call   80122f <sys_page_alloc>
		if(ret < 0){
  80148b:	83 c4 10             	add    $0x10,%esp
  80148e:	85 c0                	test   %eax,%eax
  801490:	78 28                	js     8014ba <set_pgfault_handler+0x59>
    	ret = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  801492:	83 ec 08             	sub    $0x8,%esp
  801495:	68 cc 14 80 00       	push   $0x8014cc
  80149a:	6a 00                	push   $0x0
  80149c:	e8 d9 fe ff ff       	call   80137a <sys_env_set_pgfault_upcall>
		if(ret < 0){
  8014a1:	83 c4 10             	add    $0x10,%esp
  8014a4:	85 c0                	test   %eax,%eax
  8014a6:	79 c8                	jns    801470 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
  8014a8:	50                   	push   %eax
  8014a9:	68 80 1c 80 00       	push   $0x801c80
  8014ae:	6a 28                	push   $0x28
  8014b0:	68 c0 1c 80 00       	push   $0x801cc0
  8014b5:	e8 82 f1 ff ff       	call   80063c <_panic>
			panic("set_pgfault_handler: sys_page_alloc fail, ret:%d", ret);
  8014ba:	50                   	push   %eax
  8014bb:	68 4c 1c 80 00       	push   $0x801c4c
  8014c0:	6a 24                	push   $0x24
  8014c2:	68 c0 1c 80 00       	push   $0x801cc0
  8014c7:	e8 70 f1 ff ff       	call   80063c <_panic>

008014cc <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8014cc:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8014cd:	a1 d0 20 80 00       	mov    0x8020d0,%eax
	call *%eax
  8014d2:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8014d4:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edi
  8014d7:	8b 7c 24 28          	mov    0x28(%esp),%edi
	movl 0x30(%esp), %esi
  8014db:	8b 74 24 30          	mov    0x30(%esp),%esi
	subl $4, %esi
  8014df:	83 ee 04             	sub    $0x4,%esi
	movl %edi, (%esi)
  8014e2:	89 3e                	mov    %edi,(%esi)
	movl %esi, 0x30(%esp)
  8014e4:	89 74 24 30          	mov    %esi,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8014e8:	83 c4 08             	add    $0x8,%esp
	popal
  8014eb:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8014ec:	83 c4 04             	add    $0x4,%esp
	popfl
  8014ef:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8014f0:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8014f1:	c3                   	ret    
  8014f2:	66 90                	xchg   %ax,%ax
  8014f4:	66 90                	xchg   %ax,%ax
  8014f6:	66 90                	xchg   %ax,%ax
  8014f8:	66 90                	xchg   %ax,%ax
  8014fa:	66 90                	xchg   %ax,%ax
  8014fc:	66 90                	xchg   %ax,%ax
  8014fe:	66 90                	xchg   %ax,%ax

00801500 <__udivdi3>:
  801500:	55                   	push   %ebp
  801501:	57                   	push   %edi
  801502:	56                   	push   %esi
  801503:	53                   	push   %ebx
  801504:	83 ec 1c             	sub    $0x1c,%esp
  801507:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80150b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80150f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801513:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801517:	85 d2                	test   %edx,%edx
  801519:	75 4d                	jne    801568 <__udivdi3+0x68>
  80151b:	39 f3                	cmp    %esi,%ebx
  80151d:	76 19                	jbe    801538 <__udivdi3+0x38>
  80151f:	31 ff                	xor    %edi,%edi
  801521:	89 e8                	mov    %ebp,%eax
  801523:	89 f2                	mov    %esi,%edx
  801525:	f7 f3                	div    %ebx
  801527:	89 fa                	mov    %edi,%edx
  801529:	83 c4 1c             	add    $0x1c,%esp
  80152c:	5b                   	pop    %ebx
  80152d:	5e                   	pop    %esi
  80152e:	5f                   	pop    %edi
  80152f:	5d                   	pop    %ebp
  801530:	c3                   	ret    
  801531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801538:	89 d9                	mov    %ebx,%ecx
  80153a:	85 db                	test   %ebx,%ebx
  80153c:	75 0b                	jne    801549 <__udivdi3+0x49>
  80153e:	b8 01 00 00 00       	mov    $0x1,%eax
  801543:	31 d2                	xor    %edx,%edx
  801545:	f7 f3                	div    %ebx
  801547:	89 c1                	mov    %eax,%ecx
  801549:	31 d2                	xor    %edx,%edx
  80154b:	89 f0                	mov    %esi,%eax
  80154d:	f7 f1                	div    %ecx
  80154f:	89 c6                	mov    %eax,%esi
  801551:	89 e8                	mov    %ebp,%eax
  801553:	89 f7                	mov    %esi,%edi
  801555:	f7 f1                	div    %ecx
  801557:	89 fa                	mov    %edi,%edx
  801559:	83 c4 1c             	add    $0x1c,%esp
  80155c:	5b                   	pop    %ebx
  80155d:	5e                   	pop    %esi
  80155e:	5f                   	pop    %edi
  80155f:	5d                   	pop    %ebp
  801560:	c3                   	ret    
  801561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801568:	39 f2                	cmp    %esi,%edx
  80156a:	77 1c                	ja     801588 <__udivdi3+0x88>
  80156c:	0f bd fa             	bsr    %edx,%edi
  80156f:	83 f7 1f             	xor    $0x1f,%edi
  801572:	75 2c                	jne    8015a0 <__udivdi3+0xa0>
  801574:	39 f2                	cmp    %esi,%edx
  801576:	72 06                	jb     80157e <__udivdi3+0x7e>
  801578:	31 c0                	xor    %eax,%eax
  80157a:	39 eb                	cmp    %ebp,%ebx
  80157c:	77 a9                	ja     801527 <__udivdi3+0x27>
  80157e:	b8 01 00 00 00       	mov    $0x1,%eax
  801583:	eb a2                	jmp    801527 <__udivdi3+0x27>
  801585:	8d 76 00             	lea    0x0(%esi),%esi
  801588:	31 ff                	xor    %edi,%edi
  80158a:	31 c0                	xor    %eax,%eax
  80158c:	89 fa                	mov    %edi,%edx
  80158e:	83 c4 1c             	add    $0x1c,%esp
  801591:	5b                   	pop    %ebx
  801592:	5e                   	pop    %esi
  801593:	5f                   	pop    %edi
  801594:	5d                   	pop    %ebp
  801595:	c3                   	ret    
  801596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80159d:	8d 76 00             	lea    0x0(%esi),%esi
  8015a0:	89 f9                	mov    %edi,%ecx
  8015a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8015a7:	29 f8                	sub    %edi,%eax
  8015a9:	d3 e2                	shl    %cl,%edx
  8015ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8015af:	89 c1                	mov    %eax,%ecx
  8015b1:	89 da                	mov    %ebx,%edx
  8015b3:	d3 ea                	shr    %cl,%edx
  8015b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8015b9:	09 d1                	or     %edx,%ecx
  8015bb:	89 f2                	mov    %esi,%edx
  8015bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015c1:	89 f9                	mov    %edi,%ecx
  8015c3:	d3 e3                	shl    %cl,%ebx
  8015c5:	89 c1                	mov    %eax,%ecx
  8015c7:	d3 ea                	shr    %cl,%edx
  8015c9:	89 f9                	mov    %edi,%ecx
  8015cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8015cf:	89 eb                	mov    %ebp,%ebx
  8015d1:	d3 e6                	shl    %cl,%esi
  8015d3:	89 c1                	mov    %eax,%ecx
  8015d5:	d3 eb                	shr    %cl,%ebx
  8015d7:	09 de                	or     %ebx,%esi
  8015d9:	89 f0                	mov    %esi,%eax
  8015db:	f7 74 24 08          	divl   0x8(%esp)
  8015df:	89 d6                	mov    %edx,%esi
  8015e1:	89 c3                	mov    %eax,%ebx
  8015e3:	f7 64 24 0c          	mull   0xc(%esp)
  8015e7:	39 d6                	cmp    %edx,%esi
  8015e9:	72 15                	jb     801600 <__udivdi3+0x100>
  8015eb:	89 f9                	mov    %edi,%ecx
  8015ed:	d3 e5                	shl    %cl,%ebp
  8015ef:	39 c5                	cmp    %eax,%ebp
  8015f1:	73 04                	jae    8015f7 <__udivdi3+0xf7>
  8015f3:	39 d6                	cmp    %edx,%esi
  8015f5:	74 09                	je     801600 <__udivdi3+0x100>
  8015f7:	89 d8                	mov    %ebx,%eax
  8015f9:	31 ff                	xor    %edi,%edi
  8015fb:	e9 27 ff ff ff       	jmp    801527 <__udivdi3+0x27>
  801600:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801603:	31 ff                	xor    %edi,%edi
  801605:	e9 1d ff ff ff       	jmp    801527 <__udivdi3+0x27>
  80160a:	66 90                	xchg   %ax,%ax
  80160c:	66 90                	xchg   %ax,%ax
  80160e:	66 90                	xchg   %ax,%ax

00801610 <__umoddi3>:
  801610:	55                   	push   %ebp
  801611:	57                   	push   %edi
  801612:	56                   	push   %esi
  801613:	53                   	push   %ebx
  801614:	83 ec 1c             	sub    $0x1c,%esp
  801617:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80161b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80161f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801623:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801627:	89 da                	mov    %ebx,%edx
  801629:	85 c0                	test   %eax,%eax
  80162b:	75 43                	jne    801670 <__umoddi3+0x60>
  80162d:	39 df                	cmp    %ebx,%edi
  80162f:	76 17                	jbe    801648 <__umoddi3+0x38>
  801631:	89 f0                	mov    %esi,%eax
  801633:	f7 f7                	div    %edi
  801635:	89 d0                	mov    %edx,%eax
  801637:	31 d2                	xor    %edx,%edx
  801639:	83 c4 1c             	add    $0x1c,%esp
  80163c:	5b                   	pop    %ebx
  80163d:	5e                   	pop    %esi
  80163e:	5f                   	pop    %edi
  80163f:	5d                   	pop    %ebp
  801640:	c3                   	ret    
  801641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801648:	89 fd                	mov    %edi,%ebp
  80164a:	85 ff                	test   %edi,%edi
  80164c:	75 0b                	jne    801659 <__umoddi3+0x49>
  80164e:	b8 01 00 00 00       	mov    $0x1,%eax
  801653:	31 d2                	xor    %edx,%edx
  801655:	f7 f7                	div    %edi
  801657:	89 c5                	mov    %eax,%ebp
  801659:	89 d8                	mov    %ebx,%eax
  80165b:	31 d2                	xor    %edx,%edx
  80165d:	f7 f5                	div    %ebp
  80165f:	89 f0                	mov    %esi,%eax
  801661:	f7 f5                	div    %ebp
  801663:	89 d0                	mov    %edx,%eax
  801665:	eb d0                	jmp    801637 <__umoddi3+0x27>
  801667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80166e:	66 90                	xchg   %ax,%ax
  801670:	89 f1                	mov    %esi,%ecx
  801672:	39 d8                	cmp    %ebx,%eax
  801674:	76 0a                	jbe    801680 <__umoddi3+0x70>
  801676:	89 f0                	mov    %esi,%eax
  801678:	83 c4 1c             	add    $0x1c,%esp
  80167b:	5b                   	pop    %ebx
  80167c:	5e                   	pop    %esi
  80167d:	5f                   	pop    %edi
  80167e:	5d                   	pop    %ebp
  80167f:	c3                   	ret    
  801680:	0f bd e8             	bsr    %eax,%ebp
  801683:	83 f5 1f             	xor    $0x1f,%ebp
  801686:	75 20                	jne    8016a8 <__umoddi3+0x98>
  801688:	39 d8                	cmp    %ebx,%eax
  80168a:	0f 82 b0 00 00 00    	jb     801740 <__umoddi3+0x130>
  801690:	39 f7                	cmp    %esi,%edi
  801692:	0f 86 a8 00 00 00    	jbe    801740 <__umoddi3+0x130>
  801698:	89 c8                	mov    %ecx,%eax
  80169a:	83 c4 1c             	add    $0x1c,%esp
  80169d:	5b                   	pop    %ebx
  80169e:	5e                   	pop    %esi
  80169f:	5f                   	pop    %edi
  8016a0:	5d                   	pop    %ebp
  8016a1:	c3                   	ret    
  8016a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8016a8:	89 e9                	mov    %ebp,%ecx
  8016aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8016af:	29 ea                	sub    %ebp,%edx
  8016b1:	d3 e0                	shl    %cl,%eax
  8016b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016b7:	89 d1                	mov    %edx,%ecx
  8016b9:	89 f8                	mov    %edi,%eax
  8016bb:	d3 e8                	shr    %cl,%eax
  8016bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8016c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8016c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8016c9:	09 c1                	or     %eax,%ecx
  8016cb:	89 d8                	mov    %ebx,%eax
  8016cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016d1:	89 e9                	mov    %ebp,%ecx
  8016d3:	d3 e7                	shl    %cl,%edi
  8016d5:	89 d1                	mov    %edx,%ecx
  8016d7:	d3 e8                	shr    %cl,%eax
  8016d9:	89 e9                	mov    %ebp,%ecx
  8016db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8016df:	d3 e3                	shl    %cl,%ebx
  8016e1:	89 c7                	mov    %eax,%edi
  8016e3:	89 d1                	mov    %edx,%ecx
  8016e5:	89 f0                	mov    %esi,%eax
  8016e7:	d3 e8                	shr    %cl,%eax
  8016e9:	89 e9                	mov    %ebp,%ecx
  8016eb:	89 fa                	mov    %edi,%edx
  8016ed:	d3 e6                	shl    %cl,%esi
  8016ef:	09 d8                	or     %ebx,%eax
  8016f1:	f7 74 24 08          	divl   0x8(%esp)
  8016f5:	89 d1                	mov    %edx,%ecx
  8016f7:	89 f3                	mov    %esi,%ebx
  8016f9:	f7 64 24 0c          	mull   0xc(%esp)
  8016fd:	89 c6                	mov    %eax,%esi
  8016ff:	89 d7                	mov    %edx,%edi
  801701:	39 d1                	cmp    %edx,%ecx
  801703:	72 06                	jb     80170b <__umoddi3+0xfb>
  801705:	75 10                	jne    801717 <__umoddi3+0x107>
  801707:	39 c3                	cmp    %eax,%ebx
  801709:	73 0c                	jae    801717 <__umoddi3+0x107>
  80170b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80170f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801713:	89 d7                	mov    %edx,%edi
  801715:	89 c6                	mov    %eax,%esi
  801717:	89 ca                	mov    %ecx,%edx
  801719:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80171e:	29 f3                	sub    %esi,%ebx
  801720:	19 fa                	sbb    %edi,%edx
  801722:	89 d0                	mov    %edx,%eax
  801724:	d3 e0                	shl    %cl,%eax
  801726:	89 e9                	mov    %ebp,%ecx
  801728:	d3 eb                	shr    %cl,%ebx
  80172a:	d3 ea                	shr    %cl,%edx
  80172c:	09 d8                	or     %ebx,%eax
  80172e:	83 c4 1c             	add    $0x1c,%esp
  801731:	5b                   	pop    %ebx
  801732:	5e                   	pop    %esi
  801733:	5f                   	pop    %edi
  801734:	5d                   	pop    %ebp
  801735:	c3                   	ret    
  801736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80173d:	8d 76 00             	lea    0x0(%esi),%esi
  801740:	89 da                	mov    %ebx,%edx
  801742:	29 fe                	sub    %edi,%esi
  801744:	19 c2                	sbb    %eax,%edx
  801746:	89 f1                	mov    %esi,%ecx
  801748:	89 c8                	mov    %ecx,%eax
  80174a:	e9 4b ff ff ff       	jmp    80169a <__umoddi3+0x8a>
