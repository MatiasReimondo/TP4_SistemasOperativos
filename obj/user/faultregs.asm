
obj/user/faultregs.debug:     formato del fichero elf32-i386


Desensamblado de la sección .text:

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
  80002c:	e8 66 05 00 00       	call   800597 <libmain>
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
  800044:	68 51 23 80 00       	push   $0x802351
  800049:	68 20 23 80 00       	push   $0x802320
  80004e:	e8 81 06 00 00       	call   8006d4 <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800053:	ff 33                	pushl  (%ebx)
  800055:	ff 36                	pushl  (%esi)
  800057:	68 30 23 80 00       	push   $0x802330
  80005c:	68 34 23 80 00       	push   $0x802334
  800061:	e8 6e 06 00 00       	call   8006d4 <cprintf>
  800066:	83 c4 20             	add    $0x20,%esp
  800069:	8b 03                	mov    (%ebx),%eax
  80006b:	39 06                	cmp    %eax,(%esi)
  80006d:	75 17                	jne    800086 <check_regs+0x53>
  80006f:	83 ec 0c             	sub    $0xc,%esp
  800072:	68 44 23 80 00       	push   $0x802344
  800077:	e8 58 06 00 00       	call   8006d4 <cprintf>
  80007c:	83 c4 10             	add    $0x10,%esp

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
	int mismatch = 0;
  80007f:	bf 00 00 00 00       	mov    $0x0,%edi
  800084:	eb 15                	jmp    80009b <check_regs+0x68>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 48 23 80 00       	push   $0x802348
  80008e:	e8 41 06 00 00       	call   8006d4 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
  800096:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  80009b:	ff 73 04             	pushl  0x4(%ebx)
  80009e:	ff 76 04             	pushl  0x4(%esi)
  8000a1:	68 52 23 80 00       	push   $0x802352
  8000a6:	68 34 23 80 00       	push   $0x802334
  8000ab:	e8 24 06 00 00       	call   8006d4 <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	8b 43 04             	mov    0x4(%ebx),%eax
  8000b6:	39 46 04             	cmp    %eax,0x4(%esi)
  8000b9:	75 12                	jne    8000cd <check_regs+0x9a>
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 44 23 80 00       	push   $0x802344
  8000c3:	e8 0c 06 00 00       	call   8006d4 <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
  8000cb:	eb 15                	jmp    8000e2 <check_regs+0xaf>
  8000cd:	83 ec 0c             	sub    $0xc,%esp
  8000d0:	68 48 23 80 00       	push   $0x802348
  8000d5:	e8 fa 05 00 00       	call   8006d4 <cprintf>
  8000da:	83 c4 10             	add    $0x10,%esp
  8000dd:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000e2:	ff 73 08             	pushl  0x8(%ebx)
  8000e5:	ff 76 08             	pushl  0x8(%esi)
  8000e8:	68 56 23 80 00       	push   $0x802356
  8000ed:	68 34 23 80 00       	push   $0x802334
  8000f2:	e8 dd 05 00 00       	call   8006d4 <cprintf>
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	8b 43 08             	mov    0x8(%ebx),%eax
  8000fd:	39 46 08             	cmp    %eax,0x8(%esi)
  800100:	75 12                	jne    800114 <check_regs+0xe1>
  800102:	83 ec 0c             	sub    $0xc,%esp
  800105:	68 44 23 80 00       	push   $0x802344
  80010a:	e8 c5 05 00 00       	call   8006d4 <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	eb 15                	jmp    800129 <check_regs+0xf6>
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 48 23 80 00       	push   $0x802348
  80011c:	e8 b3 05 00 00       	call   8006d4 <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp
  800124:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  800129:	ff 73 10             	pushl  0x10(%ebx)
  80012c:	ff 76 10             	pushl  0x10(%esi)
  80012f:	68 5a 23 80 00       	push   $0x80235a
  800134:	68 34 23 80 00       	push   $0x802334
  800139:	e8 96 05 00 00       	call   8006d4 <cprintf>
  80013e:	83 c4 10             	add    $0x10,%esp
  800141:	8b 43 10             	mov    0x10(%ebx),%eax
  800144:	39 46 10             	cmp    %eax,0x10(%esi)
  800147:	75 12                	jne    80015b <check_regs+0x128>
  800149:	83 ec 0c             	sub    $0xc,%esp
  80014c:	68 44 23 80 00       	push   $0x802344
  800151:	e8 7e 05 00 00       	call   8006d4 <cprintf>
  800156:	83 c4 10             	add    $0x10,%esp
  800159:	eb 15                	jmp    800170 <check_regs+0x13d>
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	68 48 23 80 00       	push   $0x802348
  800163:	e8 6c 05 00 00       	call   8006d4 <cprintf>
  800168:	83 c4 10             	add    $0x10,%esp
  80016b:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800170:	ff 73 14             	pushl  0x14(%ebx)
  800173:	ff 76 14             	pushl  0x14(%esi)
  800176:	68 5e 23 80 00       	push   $0x80235e
  80017b:	68 34 23 80 00       	push   $0x802334
  800180:	e8 4f 05 00 00       	call   8006d4 <cprintf>
  800185:	83 c4 10             	add    $0x10,%esp
  800188:	8b 43 14             	mov    0x14(%ebx),%eax
  80018b:	39 46 14             	cmp    %eax,0x14(%esi)
  80018e:	75 12                	jne    8001a2 <check_regs+0x16f>
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 44 23 80 00       	push   $0x802344
  800198:	e8 37 05 00 00       	call   8006d4 <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	eb 15                	jmp    8001b7 <check_regs+0x184>
  8001a2:	83 ec 0c             	sub    $0xc,%esp
  8001a5:	68 48 23 80 00       	push   $0x802348
  8001aa:	e8 25 05 00 00       	call   8006d4 <cprintf>
  8001af:	83 c4 10             	add    $0x10,%esp
  8001b2:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  8001b7:	ff 73 18             	pushl  0x18(%ebx)
  8001ba:	ff 76 18             	pushl  0x18(%esi)
  8001bd:	68 62 23 80 00       	push   $0x802362
  8001c2:	68 34 23 80 00       	push   $0x802334
  8001c7:	e8 08 05 00 00       	call   8006d4 <cprintf>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	8b 43 18             	mov    0x18(%ebx),%eax
  8001d2:	39 46 18             	cmp    %eax,0x18(%esi)
  8001d5:	75 12                	jne    8001e9 <check_regs+0x1b6>
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	68 44 23 80 00       	push   $0x802344
  8001df:	e8 f0 04 00 00       	call   8006d4 <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
  8001e7:	eb 15                	jmp    8001fe <check_regs+0x1cb>
  8001e9:	83 ec 0c             	sub    $0xc,%esp
  8001ec:	68 48 23 80 00       	push   $0x802348
  8001f1:	e8 de 04 00 00       	call   8006d4 <cprintf>
  8001f6:	83 c4 10             	add    $0x10,%esp
  8001f9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  8001fe:	ff 73 1c             	pushl  0x1c(%ebx)
  800201:	ff 76 1c             	pushl  0x1c(%esi)
  800204:	68 66 23 80 00       	push   $0x802366
  800209:	68 34 23 80 00       	push   $0x802334
  80020e:	e8 c1 04 00 00       	call   8006d4 <cprintf>
  800213:	83 c4 10             	add    $0x10,%esp
  800216:	8b 43 1c             	mov    0x1c(%ebx),%eax
  800219:	39 46 1c             	cmp    %eax,0x1c(%esi)
  80021c:	75 12                	jne    800230 <check_regs+0x1fd>
  80021e:	83 ec 0c             	sub    $0xc,%esp
  800221:	68 44 23 80 00       	push   $0x802344
  800226:	e8 a9 04 00 00       	call   8006d4 <cprintf>
  80022b:	83 c4 10             	add    $0x10,%esp
  80022e:	eb 15                	jmp    800245 <check_regs+0x212>
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	68 48 23 80 00       	push   $0x802348
  800238:	e8 97 04 00 00       	call   8006d4 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
  800240:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  800245:	ff 73 20             	pushl  0x20(%ebx)
  800248:	ff 76 20             	pushl  0x20(%esi)
  80024b:	68 6a 23 80 00       	push   $0x80236a
  800250:	68 34 23 80 00       	push   $0x802334
  800255:	e8 7a 04 00 00       	call   8006d4 <cprintf>
  80025a:	83 c4 10             	add    $0x10,%esp
  80025d:	8b 43 20             	mov    0x20(%ebx),%eax
  800260:	39 46 20             	cmp    %eax,0x20(%esi)
  800263:	75 12                	jne    800277 <check_regs+0x244>
  800265:	83 ec 0c             	sub    $0xc,%esp
  800268:	68 44 23 80 00       	push   $0x802344
  80026d:	e8 62 04 00 00       	call   8006d4 <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
  800275:	eb 15                	jmp    80028c <check_regs+0x259>
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	68 48 23 80 00       	push   $0x802348
  80027f:	e8 50 04 00 00       	call   8006d4 <cprintf>
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  80028c:	ff 73 24             	pushl  0x24(%ebx)
  80028f:	ff 76 24             	pushl  0x24(%esi)
  800292:	68 6e 23 80 00       	push   $0x80236e
  800297:	68 34 23 80 00       	push   $0x802334
  80029c:	e8 33 04 00 00       	call   8006d4 <cprintf>
  8002a1:	83 c4 10             	add    $0x10,%esp
  8002a4:	8b 43 24             	mov    0x24(%ebx),%eax
  8002a7:	39 46 24             	cmp    %eax,0x24(%esi)
  8002aa:	75 2f                	jne    8002db <check_regs+0x2a8>
  8002ac:	83 ec 0c             	sub    $0xc,%esp
  8002af:	68 44 23 80 00       	push   $0x802344
  8002b4:	e8 1b 04 00 00       	call   8006d4 <cprintf>
	CHECK(esp, esp);
  8002b9:	ff 73 28             	pushl  0x28(%ebx)
  8002bc:	ff 76 28             	pushl  0x28(%esi)
  8002bf:	68 75 23 80 00       	push   $0x802375
  8002c4:	68 34 23 80 00       	push   $0x802334
  8002c9:	e8 06 04 00 00       	call   8006d4 <cprintf>
  8002ce:	83 c4 20             	add    $0x20,%esp
  8002d1:	8b 43 28             	mov    0x28(%ebx),%eax
  8002d4:	39 46 28             	cmp    %eax,0x28(%esi)
  8002d7:	74 31                	je     80030a <check_regs+0x2d7>
  8002d9:	eb 55                	jmp    800330 <check_regs+0x2fd>
	CHECK(ebx, regs.reg_ebx);
	CHECK(edx, regs.reg_edx);
	CHECK(ecx, regs.reg_ecx);
	CHECK(eax, regs.reg_eax);
	CHECK(eip, eip);
	CHECK(eflags, eflags);
  8002db:	83 ec 0c             	sub    $0xc,%esp
  8002de:	68 48 23 80 00       	push   $0x802348
  8002e3:	e8 ec 03 00 00       	call   8006d4 <cprintf>
	CHECK(esp, esp);
  8002e8:	ff 73 28             	pushl  0x28(%ebx)
  8002eb:	ff 76 28             	pushl  0x28(%esi)
  8002ee:	68 75 23 80 00       	push   $0x802375
  8002f3:	68 34 23 80 00       	push   $0x802334
  8002f8:	e8 d7 03 00 00       	call   8006d4 <cprintf>
  8002fd:	83 c4 20             	add    $0x20,%esp
  800300:	8b 43 28             	mov    0x28(%ebx),%eax
  800303:	39 46 28             	cmp    %eax,0x28(%esi)
  800306:	75 28                	jne    800330 <check_regs+0x2fd>
  800308:	eb 6c                	jmp    800376 <check_regs+0x343>
  80030a:	83 ec 0c             	sub    $0xc,%esp
  80030d:	68 44 23 80 00       	push   $0x802344
  800312:	e8 bd 03 00 00       	call   8006d4 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800317:	83 c4 08             	add    $0x8,%esp
  80031a:	ff 75 0c             	pushl  0xc(%ebp)
  80031d:	68 79 23 80 00       	push   $0x802379
  800322:	e8 ad 03 00 00       	call   8006d4 <cprintf>
	if (!mismatch)
  800327:	83 c4 10             	add    $0x10,%esp
  80032a:	85 ff                	test   %edi,%edi
  80032c:	74 24                	je     800352 <check_regs+0x31f>
  80032e:	eb 34                	jmp    800364 <check_regs+0x331>
	CHECK(edx, regs.reg_edx);
	CHECK(ecx, regs.reg_ecx);
	CHECK(eax, regs.reg_eax);
	CHECK(eip, eip);
	CHECK(eflags, eflags);
	CHECK(esp, esp);
  800330:	83 ec 0c             	sub    $0xc,%esp
  800333:	68 48 23 80 00       	push   $0x802348
  800338:	e8 97 03 00 00       	call   8006d4 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  80033d:	83 c4 08             	add    $0x8,%esp
  800340:	ff 75 0c             	pushl  0xc(%ebp)
  800343:	68 79 23 80 00       	push   $0x802379
  800348:	e8 87 03 00 00       	call   8006d4 <cprintf>
  80034d:	83 c4 10             	add    $0x10,%esp
  800350:	eb 12                	jmp    800364 <check_regs+0x331>
	if (!mismatch)
		cprintf("OK\n");
  800352:	83 ec 0c             	sub    $0xc,%esp
  800355:	68 44 23 80 00       	push   $0x802344
  80035a:	e8 75 03 00 00       	call   8006d4 <cprintf>
  80035f:	83 c4 10             	add    $0x10,%esp
  800362:	eb 34                	jmp    800398 <check_regs+0x365>
	else
		cprintf("MISMATCH\n");
  800364:	83 ec 0c             	sub    $0xc,%esp
  800367:	68 48 23 80 00       	push   $0x802348
  80036c:	e8 63 03 00 00       	call   8006d4 <cprintf>
  800371:	83 c4 10             	add    $0x10,%esp
}
  800374:	eb 22                	jmp    800398 <check_regs+0x365>
	CHECK(edx, regs.reg_edx);
	CHECK(ecx, regs.reg_ecx);
	CHECK(eax, regs.reg_eax);
	CHECK(eip, eip);
	CHECK(eflags, eflags);
	CHECK(esp, esp);
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	68 44 23 80 00       	push   $0x802344
  80037e:	e8 51 03 00 00       	call   8006d4 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800383:	83 c4 08             	add    $0x8,%esp
  800386:	ff 75 0c             	pushl  0xc(%ebp)
  800389:	68 79 23 80 00       	push   $0x802379
  80038e:	e8 41 03 00 00       	call   8006d4 <cprintf>
  800393:	83 c4 10             	add    $0x10,%esp
  800396:	eb cc                	jmp    800364 <check_regs+0x331>
	if (!mismatch)
		cprintf("OK\n");
	else
		cprintf("MISMATCH\n");
}
  800398:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80039b:	5b                   	pop    %ebx
  80039c:	5e                   	pop    %esi
  80039d:	5f                   	pop    %edi
  80039e:	5d                   	pop    %ebp
  80039f:	c3                   	ret    

008003a0 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	83 ec 08             	sub    $0x8,%esp
  8003a6:	8b 45 08             	mov    0x8(%ebp),%eax
	int r;

	if (utf->utf_fault_va != (uint32_t)UTEMP)
  8003a9:	8b 10                	mov    (%eax),%edx
  8003ab:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  8003b1:	74 18                	je     8003cb <pgfault+0x2b>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  8003b3:	83 ec 0c             	sub    $0xc,%esp
  8003b6:	ff 70 28             	pushl  0x28(%eax)
  8003b9:	52                   	push   %edx
  8003ba:	68 e0 23 80 00       	push   $0x8023e0
  8003bf:	6a 51                	push   $0x51
  8003c1:	68 87 23 80 00       	push   $0x802387
  8003c6:	e8 30 02 00 00       	call   8005fb <_panic>
		      utf->utf_fault_va, utf->utf_eip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8003cb:	8b 50 08             	mov    0x8(%eax),%edx
  8003ce:	89 15 40 40 80 00    	mov    %edx,0x804040
  8003d4:	8b 50 0c             	mov    0xc(%eax),%edx
  8003d7:	89 15 44 40 80 00    	mov    %edx,0x804044
  8003dd:	8b 50 10             	mov    0x10(%eax),%edx
  8003e0:	89 15 48 40 80 00    	mov    %edx,0x804048
  8003e6:	8b 50 14             	mov    0x14(%eax),%edx
  8003e9:	89 15 4c 40 80 00    	mov    %edx,0x80404c
  8003ef:	8b 50 18             	mov    0x18(%eax),%edx
  8003f2:	89 15 50 40 80 00    	mov    %edx,0x804050
  8003f8:	8b 50 1c             	mov    0x1c(%eax),%edx
  8003fb:	89 15 54 40 80 00    	mov    %edx,0x804054
  800401:	8b 50 20             	mov    0x20(%eax),%edx
  800404:	89 15 58 40 80 00    	mov    %edx,0x804058
  80040a:	8b 50 24             	mov    0x24(%eax),%edx
  80040d:	89 15 5c 40 80 00    	mov    %edx,0x80405c
	during.eip = utf->utf_eip;
  800413:	8b 50 28             	mov    0x28(%eax),%edx
  800416:	89 15 60 40 80 00    	mov    %edx,0x804060
	during.eflags = utf->utf_eflags & ~FL_RF;
  80041c:	8b 50 2c             	mov    0x2c(%eax),%edx
  80041f:	81 e2 ff ff fe ff    	and    $0xfffeffff,%edx
  800425:	89 15 64 40 80 00    	mov    %edx,0x804064
	during.esp = utf->utf_esp;
  80042b:	8b 40 30             	mov    0x30(%eax),%eax
  80042e:	a3 68 40 80 00       	mov    %eax,0x804068
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  800433:	83 ec 08             	sub    $0x8,%esp
  800436:	68 9f 23 80 00       	push   $0x80239f
  80043b:	68 ad 23 80 00       	push   $0x8023ad
  800440:	b9 40 40 80 00       	mov    $0x804040,%ecx
  800445:	ba 98 23 80 00       	mov    $0x802398,%edx
  80044a:	b8 80 40 80 00       	mov    $0x804080,%eax
  80044f:	e8 df fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800454:	83 c4 0c             	add    $0xc,%esp
  800457:	6a 07                	push   $0x7
  800459:	68 00 00 40 00       	push   $0x400000
  80045e:	6a 00                	push   $0x0
  800460:	e8 2a 0c 00 00       	call   80108f <sys_page_alloc>
  800465:	83 c4 10             	add    $0x10,%esp
  800468:	85 c0                	test   %eax,%eax
  80046a:	79 12                	jns    80047e <pgfault+0xde>
		panic("sys_page_alloc: %e", r);
  80046c:	50                   	push   %eax
  80046d:	68 b4 23 80 00       	push   $0x8023b4
  800472:	6a 5c                	push   $0x5c
  800474:	68 87 23 80 00       	push   $0x802387
  800479:	e8 7d 01 00 00       	call   8005fb <_panic>
}
  80047e:	c9                   	leave  
  80047f:	c3                   	ret    

00800480 <umain>:

void
umain(int argc, char **argv)
{
  800480:	55                   	push   %ebp
  800481:	89 e5                	mov    %esp,%ebp
  800483:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(pgfault);
  800486:	68 a0 03 80 00       	push   $0x8003a0
  80048b:	e8 1c 0d 00 00       	call   8011ac <set_pgfault_handler>

	asm volatile(
  800490:	50                   	push   %eax
  800491:	9c                   	pushf  
  800492:	58                   	pop    %eax
  800493:	0d d5 08 00 00       	or     $0x8d5,%eax
  800498:	50                   	push   %eax
  800499:	9d                   	popf   
  80049a:	a3 a4 40 80 00       	mov    %eax,0x8040a4
  80049f:	8d 05 da 04 80 00    	lea    0x8004da,%eax
  8004a5:	a3 a0 40 80 00       	mov    %eax,0x8040a0
  8004aa:	58                   	pop    %eax
  8004ab:	89 3d 80 40 80 00    	mov    %edi,0x804080
  8004b1:	89 35 84 40 80 00    	mov    %esi,0x804084
  8004b7:	89 2d 88 40 80 00    	mov    %ebp,0x804088
  8004bd:	89 1d 90 40 80 00    	mov    %ebx,0x804090
  8004c3:	89 15 94 40 80 00    	mov    %edx,0x804094
  8004c9:	89 0d 98 40 80 00    	mov    %ecx,0x804098
  8004cf:	a3 9c 40 80 00       	mov    %eax,0x80409c
  8004d4:	89 25 a8 40 80 00    	mov    %esp,0x8040a8
  8004da:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  8004e1:	00 00 00 
  8004e4:	89 3d 00 40 80 00    	mov    %edi,0x804000
  8004ea:	89 35 04 40 80 00    	mov    %esi,0x804004
  8004f0:	89 2d 08 40 80 00    	mov    %ebp,0x804008
  8004f6:	89 1d 10 40 80 00    	mov    %ebx,0x804010
  8004fc:	89 15 14 40 80 00    	mov    %edx,0x804014
  800502:	89 0d 18 40 80 00    	mov    %ecx,0x804018
  800508:	a3 1c 40 80 00       	mov    %eax,0x80401c
  80050d:	89 25 28 40 80 00    	mov    %esp,0x804028
  800513:	8b 3d 80 40 80 00    	mov    0x804080,%edi
  800519:	8b 35 84 40 80 00    	mov    0x804084,%esi
  80051f:	8b 2d 88 40 80 00    	mov    0x804088,%ebp
  800525:	8b 1d 90 40 80 00    	mov    0x804090,%ebx
  80052b:	8b 15 94 40 80 00    	mov    0x804094,%edx
  800531:	8b 0d 98 40 80 00    	mov    0x804098,%ecx
  800537:	a1 9c 40 80 00       	mov    0x80409c,%eax
  80053c:	8b 25 a8 40 80 00    	mov    0x8040a8,%esp
  800542:	50                   	push   %eax
  800543:	9c                   	pushf  
  800544:	58                   	pop    %eax
  800545:	a3 24 40 80 00       	mov    %eax,0x804024
  80054a:	58                   	pop    %eax
		: : "m" (before), "m" (after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  80054b:	83 c4 10             	add    $0x10,%esp
  80054e:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
  800555:	74 10                	je     800567 <umain+0xe7>
		cprintf("EIP after page-fault MISMATCH\n");
  800557:	83 ec 0c             	sub    $0xc,%esp
  80055a:	68 14 24 80 00       	push   $0x802414
  80055f:	e8 70 01 00 00       	call   8006d4 <cprintf>
  800564:	83 c4 10             	add    $0x10,%esp
	after.eip = before.eip;
  800567:	a1 a0 40 80 00       	mov    0x8040a0,%eax
  80056c:	a3 20 40 80 00       	mov    %eax,0x804020

	check_regs(&before, "before", &after, "after", "after page-fault");
  800571:	83 ec 08             	sub    $0x8,%esp
  800574:	68 c7 23 80 00       	push   $0x8023c7
  800579:	68 d8 23 80 00       	push   $0x8023d8
  80057e:	b9 00 40 80 00       	mov    $0x804000,%ecx
  800583:	ba 98 23 80 00       	mov    $0x802398,%edx
  800588:	b8 80 40 80 00       	mov    $0x804080,%eax
  80058d:	e8 a1 fa ff ff       	call   800033 <check_regs>
}
  800592:	83 c4 10             	add    $0x10,%esp
  800595:	c9                   	leave  
  800596:	c3                   	ret    

00800597 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800597:	55                   	push   %ebp
  800598:	89 e5                	mov    %esp,%ebp
  80059a:	56                   	push   %esi
  80059b:	53                   	push   %ebx
  80059c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80059f:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8005a2:	e8 9d 0a 00 00       	call   801044 <sys_getenvid>
	if (id >= 0)
  8005a7:	85 c0                	test   %eax,%eax
  8005a9:	78 12                	js     8005bd <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  8005ab:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005b0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8005b3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005b8:	a3 b0 40 80 00       	mov    %eax,0x8040b0

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005bd:	85 db                	test   %ebx,%ebx
  8005bf:	7e 07                	jle    8005c8 <libmain+0x31>
		binaryname = argv[0];
  8005c1:	8b 06                	mov    (%esi),%eax
  8005c3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8005c8:	83 ec 08             	sub    $0x8,%esp
  8005cb:	56                   	push   %esi
  8005cc:	53                   	push   %ebx
  8005cd:	e8 ae fe ff ff       	call   800480 <umain>

	// exit gracefully
	exit();
  8005d2:	e8 0a 00 00 00       	call   8005e1 <exit>
}
  8005d7:	83 c4 10             	add    $0x10,%esp
  8005da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8005dd:	5b                   	pop    %ebx
  8005de:	5e                   	pop    %esi
  8005df:	5d                   	pop    %ebp
  8005e0:	c3                   	ret    

008005e1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005e1:	55                   	push   %ebp
  8005e2:	89 e5                	mov    %esp,%ebp
  8005e4:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8005e7:	e8 1e 0e 00 00       	call   80140a <close_all>
	sys_env_destroy(0);
  8005ec:	83 ec 0c             	sub    $0xc,%esp
  8005ef:	6a 00                	push   $0x0
  8005f1:	e8 2c 0a 00 00       	call   801022 <sys_env_destroy>
}
  8005f6:	83 c4 10             	add    $0x10,%esp
  8005f9:	c9                   	leave  
  8005fa:	c3                   	ret    

008005fb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005fb:	55                   	push   %ebp
  8005fc:	89 e5                	mov    %esp,%ebp
  8005fe:	56                   	push   %esi
  8005ff:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800600:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800603:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800609:	e8 36 0a 00 00       	call   801044 <sys_getenvid>
  80060e:	83 ec 0c             	sub    $0xc,%esp
  800611:	ff 75 0c             	pushl  0xc(%ebp)
  800614:	ff 75 08             	pushl  0x8(%ebp)
  800617:	56                   	push   %esi
  800618:	50                   	push   %eax
  800619:	68 40 24 80 00       	push   $0x802440
  80061e:	e8 b1 00 00 00       	call   8006d4 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800623:	83 c4 18             	add    $0x18,%esp
  800626:	53                   	push   %ebx
  800627:	ff 75 10             	pushl  0x10(%ebp)
  80062a:	e8 54 00 00 00       	call   800683 <vcprintf>
	cprintf("\n");
  80062f:	c7 04 24 50 23 80 00 	movl   $0x802350,(%esp)
  800636:	e8 99 00 00 00       	call   8006d4 <cprintf>
  80063b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80063e:	cc                   	int3   
  80063f:	eb fd                	jmp    80063e <_panic+0x43>

00800641 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800641:	55                   	push   %ebp
  800642:	89 e5                	mov    %esp,%ebp
  800644:	53                   	push   %ebx
  800645:	83 ec 04             	sub    $0x4,%esp
  800648:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80064b:	8b 13                	mov    (%ebx),%edx
  80064d:	8d 42 01             	lea    0x1(%edx),%eax
  800650:	89 03                	mov    %eax,(%ebx)
  800652:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800655:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800659:	3d ff 00 00 00       	cmp    $0xff,%eax
  80065e:	75 1a                	jne    80067a <putch+0x39>
		sys_cputs(b->buf, b->idx);
  800660:	83 ec 08             	sub    $0x8,%esp
  800663:	68 ff 00 00 00       	push   $0xff
  800668:	8d 43 08             	lea    0x8(%ebx),%eax
  80066b:	50                   	push   %eax
  80066c:	e8 67 09 00 00       	call   800fd8 <sys_cputs>
		b->idx = 0;
  800671:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800677:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  80067a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80067e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800681:	c9                   	leave  
  800682:	c3                   	ret    

00800683 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800683:	55                   	push   %ebp
  800684:	89 e5                	mov    %esp,%ebp
  800686:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80068c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800693:	00 00 00 
	b.cnt = 0;
  800696:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80069d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8006a0:	ff 75 0c             	pushl  0xc(%ebp)
  8006a3:	ff 75 08             	pushl  0x8(%ebp)
  8006a6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006ac:	50                   	push   %eax
  8006ad:	68 41 06 80 00       	push   $0x800641
  8006b2:	e8 86 01 00 00       	call   80083d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006b7:	83 c4 08             	add    $0x8,%esp
  8006ba:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8006c0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8006c6:	50                   	push   %eax
  8006c7:	e8 0c 09 00 00       	call   800fd8 <sys_cputs>

	return b.cnt;
}
  8006cc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8006d2:	c9                   	leave  
  8006d3:	c3                   	ret    

008006d4 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8006d4:	55                   	push   %ebp
  8006d5:	89 e5                	mov    %esp,%ebp
  8006d7:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006da:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8006dd:	50                   	push   %eax
  8006de:	ff 75 08             	pushl  0x8(%ebp)
  8006e1:	e8 9d ff ff ff       	call   800683 <vcprintf>
	va_end(ap);

	return cnt;
}
  8006e6:	c9                   	leave  
  8006e7:	c3                   	ret    

008006e8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006e8:	55                   	push   %ebp
  8006e9:	89 e5                	mov    %esp,%ebp
  8006eb:	57                   	push   %edi
  8006ec:	56                   	push   %esi
  8006ed:	53                   	push   %ebx
  8006ee:	83 ec 1c             	sub    $0x1c,%esp
  8006f1:	89 c7                	mov    %eax,%edi
  8006f3:	89 d6                	mov    %edx,%esi
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fe:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800701:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800704:	bb 00 00 00 00       	mov    $0x0,%ebx
  800709:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80070c:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80070f:	39 d3                	cmp    %edx,%ebx
  800711:	72 05                	jb     800718 <printnum+0x30>
  800713:	39 45 10             	cmp    %eax,0x10(%ebp)
  800716:	77 45                	ja     80075d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800718:	83 ec 0c             	sub    $0xc,%esp
  80071b:	ff 75 18             	pushl  0x18(%ebp)
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800724:	53                   	push   %ebx
  800725:	ff 75 10             	pushl  0x10(%ebp)
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80072e:	ff 75 e0             	pushl  -0x20(%ebp)
  800731:	ff 75 dc             	pushl  -0x24(%ebp)
  800734:	ff 75 d8             	pushl  -0x28(%ebp)
  800737:	e8 44 19 00 00       	call   802080 <__udivdi3>
  80073c:	83 c4 18             	add    $0x18,%esp
  80073f:	52                   	push   %edx
  800740:	50                   	push   %eax
  800741:	89 f2                	mov    %esi,%edx
  800743:	89 f8                	mov    %edi,%eax
  800745:	e8 9e ff ff ff       	call   8006e8 <printnum>
  80074a:	83 c4 20             	add    $0x20,%esp
  80074d:	eb 18                	jmp    800767 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80074f:	83 ec 08             	sub    $0x8,%esp
  800752:	56                   	push   %esi
  800753:	ff 75 18             	pushl  0x18(%ebp)
  800756:	ff d7                	call   *%edi
  800758:	83 c4 10             	add    $0x10,%esp
  80075b:	eb 03                	jmp    800760 <printnum+0x78>
  80075d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800760:	83 eb 01             	sub    $0x1,%ebx
  800763:	85 db                	test   %ebx,%ebx
  800765:	7f e8                	jg     80074f <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	56                   	push   %esi
  80076b:	83 ec 04             	sub    $0x4,%esp
  80076e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800771:	ff 75 e0             	pushl  -0x20(%ebp)
  800774:	ff 75 dc             	pushl  -0x24(%ebp)
  800777:	ff 75 d8             	pushl  -0x28(%ebp)
  80077a:	e8 31 1a 00 00       	call   8021b0 <__umoddi3>
  80077f:	83 c4 14             	add    $0x14,%esp
  800782:	0f be 80 63 24 80 00 	movsbl 0x802463(%eax),%eax
  800789:	50                   	push   %eax
  80078a:	ff d7                	call   *%edi
}
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800792:	5b                   	pop    %ebx
  800793:	5e                   	pop    %esi
  800794:	5f                   	pop    %edi
  800795:	5d                   	pop    %ebp
  800796:	c3                   	ret    

00800797 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800797:	55                   	push   %ebp
  800798:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80079a:	83 fa 01             	cmp    $0x1,%edx
  80079d:	7e 0e                	jle    8007ad <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80079f:	8b 10                	mov    (%eax),%edx
  8007a1:	8d 4a 08             	lea    0x8(%edx),%ecx
  8007a4:	89 08                	mov    %ecx,(%eax)
  8007a6:	8b 02                	mov    (%edx),%eax
  8007a8:	8b 52 04             	mov    0x4(%edx),%edx
  8007ab:	eb 22                	jmp    8007cf <getuint+0x38>
	else if (lflag)
  8007ad:	85 d2                	test   %edx,%edx
  8007af:	74 10                	je     8007c1 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8007b1:	8b 10                	mov    (%eax),%edx
  8007b3:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007b6:	89 08                	mov    %ecx,(%eax)
  8007b8:	8b 02                	mov    (%edx),%eax
  8007ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8007bf:	eb 0e                	jmp    8007cf <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8007c1:	8b 10                	mov    (%eax),%edx
  8007c3:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007c6:	89 08                	mov    %ecx,(%eax)
  8007c8:	8b 02                	mov    (%edx),%eax
  8007ca:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007cf:	5d                   	pop    %ebp
  8007d0:	c3                   	ret    

008007d1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007d1:	55                   	push   %ebp
  8007d2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007d4:	83 fa 01             	cmp    $0x1,%edx
  8007d7:	7e 0e                	jle    8007e7 <getint+0x16>
		return va_arg(*ap, long long);
  8007d9:	8b 10                	mov    (%eax),%edx
  8007db:	8d 4a 08             	lea    0x8(%edx),%ecx
  8007de:	89 08                	mov    %ecx,(%eax)
  8007e0:	8b 02                	mov    (%edx),%eax
  8007e2:	8b 52 04             	mov    0x4(%edx),%edx
  8007e5:	eb 1a                	jmp    800801 <getint+0x30>
	else if (lflag)
  8007e7:	85 d2                	test   %edx,%edx
  8007e9:	74 0c                	je     8007f7 <getint+0x26>
		return va_arg(*ap, long);
  8007eb:	8b 10                	mov    (%eax),%edx
  8007ed:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007f0:	89 08                	mov    %ecx,(%eax)
  8007f2:	8b 02                	mov    (%edx),%eax
  8007f4:	99                   	cltd   
  8007f5:	eb 0a                	jmp    800801 <getint+0x30>
	else
		return va_arg(*ap, int);
  8007f7:	8b 10                	mov    (%eax),%edx
  8007f9:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007fc:	89 08                	mov    %ecx,(%eax)
  8007fe:	8b 02                	mov    (%edx),%eax
  800800:	99                   	cltd   
}
  800801:	5d                   	pop    %ebp
  800802:	c3                   	ret    

00800803 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800809:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80080d:	8b 10                	mov    (%eax),%edx
  80080f:	3b 50 04             	cmp    0x4(%eax),%edx
  800812:	73 0a                	jae    80081e <sprintputch+0x1b>
		*b->buf++ = ch;
  800814:	8d 4a 01             	lea    0x1(%edx),%ecx
  800817:	89 08                	mov    %ecx,(%eax)
  800819:	8b 45 08             	mov    0x8(%ebp),%eax
  80081c:	88 02                	mov    %al,(%edx)
}
  80081e:	5d                   	pop    %ebp
  80081f:	c3                   	ret    

00800820 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
  800823:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800826:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800829:	50                   	push   %eax
  80082a:	ff 75 10             	pushl  0x10(%ebp)
  80082d:	ff 75 0c             	pushl  0xc(%ebp)
  800830:	ff 75 08             	pushl  0x8(%ebp)
  800833:	e8 05 00 00 00       	call   80083d <vprintfmt>
	va_end(ap);
}
  800838:	83 c4 10             	add    $0x10,%esp
  80083b:	c9                   	leave  
  80083c:	c3                   	ret    

0080083d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80083d:	55                   	push   %ebp
  80083e:	89 e5                	mov    %esp,%ebp
  800840:	57                   	push   %edi
  800841:	56                   	push   %esi
  800842:	53                   	push   %ebx
  800843:	83 ec 2c             	sub    $0x2c,%esp
  800846:	8b 75 08             	mov    0x8(%ebp),%esi
  800849:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80084c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80084f:	eb 12                	jmp    800863 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800851:	85 c0                	test   %eax,%eax
  800853:	0f 84 44 03 00 00    	je     800b9d <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  800859:	83 ec 08             	sub    $0x8,%esp
  80085c:	53                   	push   %ebx
  80085d:	50                   	push   %eax
  80085e:	ff d6                	call   *%esi
  800860:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800863:	83 c7 01             	add    $0x1,%edi
  800866:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80086a:	83 f8 25             	cmp    $0x25,%eax
  80086d:	75 e2                	jne    800851 <vprintfmt+0x14>
  80086f:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800873:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80087a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800881:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800888:	ba 00 00 00 00       	mov    $0x0,%edx
  80088d:	eb 07                	jmp    800896 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80088f:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800892:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800896:	8d 47 01             	lea    0x1(%edi),%eax
  800899:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80089c:	0f b6 07             	movzbl (%edi),%eax
  80089f:	0f b6 c8             	movzbl %al,%ecx
  8008a2:	83 e8 23             	sub    $0x23,%eax
  8008a5:	3c 55                	cmp    $0x55,%al
  8008a7:	0f 87 d5 02 00 00    	ja     800b82 <vprintfmt+0x345>
  8008ad:	0f b6 c0             	movzbl %al,%eax
  8008b0:	ff 24 85 a0 25 80 00 	jmp    *0x8025a0(,%eax,4)
  8008b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008ba:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8008be:	eb d6                	jmp    800896 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8008c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8008cb:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8008ce:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8008d2:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8008d5:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8008d8:	83 fa 09             	cmp    $0x9,%edx
  8008db:	77 39                	ja     800916 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008dd:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008e0:	eb e9                	jmp    8008cb <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e5:	8d 48 04             	lea    0x4(%eax),%ecx
  8008e8:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8008eb:	8b 00                	mov    (%eax),%eax
  8008ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8008f3:	eb 27                	jmp    80091c <vprintfmt+0xdf>
  8008f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f8:	85 c0                	test   %eax,%eax
  8008fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008ff:	0f 49 c8             	cmovns %eax,%ecx
  800902:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800905:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800908:	eb 8c                	jmp    800896 <vprintfmt+0x59>
  80090a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80090d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800914:	eb 80                	jmp    800896 <vprintfmt+0x59>
  800916:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800919:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  80091c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800920:	0f 89 70 ff ff ff    	jns    800896 <vprintfmt+0x59>
				width = precision, precision = -1;
  800926:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800929:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80092c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800933:	e9 5e ff ff ff       	jmp    800896 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800938:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80093b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80093e:	e9 53 ff ff ff       	jmp    800896 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800943:	8b 45 14             	mov    0x14(%ebp),%eax
  800946:	8d 50 04             	lea    0x4(%eax),%edx
  800949:	89 55 14             	mov    %edx,0x14(%ebp)
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	53                   	push   %ebx
  800950:	ff 30                	pushl  (%eax)
  800952:	ff d6                	call   *%esi
			break;
  800954:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800957:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  80095a:	e9 04 ff ff ff       	jmp    800863 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80095f:	8b 45 14             	mov    0x14(%ebp),%eax
  800962:	8d 50 04             	lea    0x4(%eax),%edx
  800965:	89 55 14             	mov    %edx,0x14(%ebp)
  800968:	8b 00                	mov    (%eax),%eax
  80096a:	99                   	cltd   
  80096b:	31 d0                	xor    %edx,%eax
  80096d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80096f:	83 f8 0f             	cmp    $0xf,%eax
  800972:	7f 0b                	jg     80097f <vprintfmt+0x142>
  800974:	8b 14 85 00 27 80 00 	mov    0x802700(,%eax,4),%edx
  80097b:	85 d2                	test   %edx,%edx
  80097d:	75 18                	jne    800997 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  80097f:	50                   	push   %eax
  800980:	68 7b 24 80 00       	push   $0x80247b
  800985:	53                   	push   %ebx
  800986:	56                   	push   %esi
  800987:	e8 94 fe ff ff       	call   800820 <printfmt>
  80098c:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80098f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800992:	e9 cc fe ff ff       	jmp    800863 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  800997:	52                   	push   %edx
  800998:	68 ad 28 80 00       	push   $0x8028ad
  80099d:	53                   	push   %ebx
  80099e:	56                   	push   %esi
  80099f:	e8 7c fe ff ff       	call   800820 <printfmt>
  8009a4:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8009aa:	e9 b4 fe ff ff       	jmp    800863 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009af:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b2:	8d 50 04             	lea    0x4(%eax),%edx
  8009b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8009b8:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8009ba:	85 ff                	test   %edi,%edi
  8009bc:	b8 74 24 80 00       	mov    $0x802474,%eax
  8009c1:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8009c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009c8:	0f 8e 94 00 00 00    	jle    800a62 <vprintfmt+0x225>
  8009ce:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8009d2:	0f 84 98 00 00 00    	je     800a70 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d8:	83 ec 08             	sub    $0x8,%esp
  8009db:	ff 75 d0             	pushl  -0x30(%ebp)
  8009de:	57                   	push   %edi
  8009df:	e8 41 02 00 00       	call   800c25 <strnlen>
  8009e4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8009e7:	29 c1                	sub    %eax,%ecx
  8009e9:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8009ec:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8009ef:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8009f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8009f6:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8009f9:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009fb:	eb 0f                	jmp    800a0c <vprintfmt+0x1cf>
					putch(padc, putdat);
  8009fd:	83 ec 08             	sub    $0x8,%esp
  800a00:	53                   	push   %ebx
  800a01:	ff 75 e0             	pushl  -0x20(%ebp)
  800a04:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a06:	83 ef 01             	sub    $0x1,%edi
  800a09:	83 c4 10             	add    $0x10,%esp
  800a0c:	85 ff                	test   %edi,%edi
  800a0e:	7f ed                	jg     8009fd <vprintfmt+0x1c0>
  800a10:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800a13:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800a16:	85 c9                	test   %ecx,%ecx
  800a18:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1d:	0f 49 c1             	cmovns %ecx,%eax
  800a20:	29 c1                	sub    %eax,%ecx
  800a22:	89 75 08             	mov    %esi,0x8(%ebp)
  800a25:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800a28:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800a2b:	89 cb                	mov    %ecx,%ebx
  800a2d:	eb 4d                	jmp    800a7c <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800a2f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800a33:	74 1b                	je     800a50 <vprintfmt+0x213>
  800a35:	0f be c0             	movsbl %al,%eax
  800a38:	83 e8 20             	sub    $0x20,%eax
  800a3b:	83 f8 5e             	cmp    $0x5e,%eax
  800a3e:	76 10                	jbe    800a50 <vprintfmt+0x213>
					putch('?', putdat);
  800a40:	83 ec 08             	sub    $0x8,%esp
  800a43:	ff 75 0c             	pushl  0xc(%ebp)
  800a46:	6a 3f                	push   $0x3f
  800a48:	ff 55 08             	call   *0x8(%ebp)
  800a4b:	83 c4 10             	add    $0x10,%esp
  800a4e:	eb 0d                	jmp    800a5d <vprintfmt+0x220>
				else
					putch(ch, putdat);
  800a50:	83 ec 08             	sub    $0x8,%esp
  800a53:	ff 75 0c             	pushl  0xc(%ebp)
  800a56:	52                   	push   %edx
  800a57:	ff 55 08             	call   *0x8(%ebp)
  800a5a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a5d:	83 eb 01             	sub    $0x1,%ebx
  800a60:	eb 1a                	jmp    800a7c <vprintfmt+0x23f>
  800a62:	89 75 08             	mov    %esi,0x8(%ebp)
  800a65:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800a68:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800a6b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800a6e:	eb 0c                	jmp    800a7c <vprintfmt+0x23f>
  800a70:	89 75 08             	mov    %esi,0x8(%ebp)
  800a73:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800a76:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800a79:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800a7c:	83 c7 01             	add    $0x1,%edi
  800a7f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a83:	0f be d0             	movsbl %al,%edx
  800a86:	85 d2                	test   %edx,%edx
  800a88:	74 23                	je     800aad <vprintfmt+0x270>
  800a8a:	85 f6                	test   %esi,%esi
  800a8c:	78 a1                	js     800a2f <vprintfmt+0x1f2>
  800a8e:	83 ee 01             	sub    $0x1,%esi
  800a91:	79 9c                	jns    800a2f <vprintfmt+0x1f2>
  800a93:	89 df                	mov    %ebx,%edi
  800a95:	8b 75 08             	mov    0x8(%ebp),%esi
  800a98:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a9b:	eb 18                	jmp    800ab5 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800a9d:	83 ec 08             	sub    $0x8,%esp
  800aa0:	53                   	push   %ebx
  800aa1:	6a 20                	push   $0x20
  800aa3:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aa5:	83 ef 01             	sub    $0x1,%edi
  800aa8:	83 c4 10             	add    $0x10,%esp
  800aab:	eb 08                	jmp    800ab5 <vprintfmt+0x278>
  800aad:	89 df                	mov    %ebx,%edi
  800aaf:	8b 75 08             	mov    0x8(%ebp),%esi
  800ab2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ab5:	85 ff                	test   %edi,%edi
  800ab7:	7f e4                	jg     800a9d <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ab9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800abc:	e9 a2 fd ff ff       	jmp    800863 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ac1:	8d 45 14             	lea    0x14(%ebp),%eax
  800ac4:	e8 08 fd ff ff       	call   8007d1 <getint>
  800ac9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800acc:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800acf:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800ad4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ad8:	79 74                	jns    800b4e <vprintfmt+0x311>
				putch('-', putdat);
  800ada:	83 ec 08             	sub    $0x8,%esp
  800add:	53                   	push   %ebx
  800ade:	6a 2d                	push   $0x2d
  800ae0:	ff d6                	call   *%esi
				num = -(long long) num;
  800ae2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ae5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800ae8:	f7 d8                	neg    %eax
  800aea:	83 d2 00             	adc    $0x0,%edx
  800aed:	f7 da                	neg    %edx
  800aef:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  800af2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800af7:	eb 55                	jmp    800b4e <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800af9:	8d 45 14             	lea    0x14(%ebp),%eax
  800afc:	e8 96 fc ff ff       	call   800797 <getuint>
			base = 10;
  800b01:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800b06:	eb 46                	jmp    800b4e <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800b08:	8d 45 14             	lea    0x14(%ebp),%eax
  800b0b:	e8 87 fc ff ff       	call   800797 <getuint>
			base = 8;
  800b10:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800b15:	eb 37                	jmp    800b4e <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  800b17:	83 ec 08             	sub    $0x8,%esp
  800b1a:	53                   	push   %ebx
  800b1b:	6a 30                	push   $0x30
  800b1d:	ff d6                	call   *%esi
			putch('x', putdat);
  800b1f:	83 c4 08             	add    $0x8,%esp
  800b22:	53                   	push   %ebx
  800b23:	6a 78                	push   $0x78
  800b25:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800b27:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2a:	8d 50 04             	lea    0x4(%eax),%edx
  800b2d:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b30:	8b 00                	mov    (%eax),%eax
  800b32:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800b37:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800b3a:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800b3f:	eb 0d                	jmp    800b4e <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b41:	8d 45 14             	lea    0x14(%ebp),%eax
  800b44:	e8 4e fc ff ff       	call   800797 <getuint>
			base = 16;
  800b49:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b4e:	83 ec 0c             	sub    $0xc,%esp
  800b51:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800b55:	57                   	push   %edi
  800b56:	ff 75 e0             	pushl  -0x20(%ebp)
  800b59:	51                   	push   %ecx
  800b5a:	52                   	push   %edx
  800b5b:	50                   	push   %eax
  800b5c:	89 da                	mov    %ebx,%edx
  800b5e:	89 f0                	mov    %esi,%eax
  800b60:	e8 83 fb ff ff       	call   8006e8 <printnum>
			break;
  800b65:	83 c4 20             	add    $0x20,%esp
  800b68:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800b6b:	e9 f3 fc ff ff       	jmp    800863 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b70:	83 ec 08             	sub    $0x8,%esp
  800b73:	53                   	push   %ebx
  800b74:	51                   	push   %ecx
  800b75:	ff d6                	call   *%esi
			break;
  800b77:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b7a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800b7d:	e9 e1 fc ff ff       	jmp    800863 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b82:	83 ec 08             	sub    $0x8,%esp
  800b85:	53                   	push   %ebx
  800b86:	6a 25                	push   $0x25
  800b88:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b8a:	83 c4 10             	add    $0x10,%esp
  800b8d:	eb 03                	jmp    800b92 <vprintfmt+0x355>
  800b8f:	83 ef 01             	sub    $0x1,%edi
  800b92:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  800b96:	75 f7                	jne    800b8f <vprintfmt+0x352>
  800b98:	e9 c6 fc ff ff       	jmp    800863 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  800b9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ba0:	5b                   	pop    %ebx
  800ba1:	5e                   	pop    %esi
  800ba2:	5f                   	pop    %edi
  800ba3:	5d                   	pop    %ebp
  800ba4:	c3                   	ret    

00800ba5 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	83 ec 18             	sub    $0x18,%esp
  800bab:	8b 45 08             	mov    0x8(%ebp),%eax
  800bae:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bb4:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800bb8:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800bbb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bc2:	85 c0                	test   %eax,%eax
  800bc4:	74 26                	je     800bec <vsnprintf+0x47>
  800bc6:	85 d2                	test   %edx,%edx
  800bc8:	7e 22                	jle    800bec <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bca:	ff 75 14             	pushl  0x14(%ebp)
  800bcd:	ff 75 10             	pushl  0x10(%ebp)
  800bd0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bd3:	50                   	push   %eax
  800bd4:	68 03 08 80 00       	push   $0x800803
  800bd9:	e8 5f fc ff ff       	call   80083d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800be1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800be7:	83 c4 10             	add    $0x10,%esp
  800bea:	eb 05                	jmp    800bf1 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800bec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800bf1:	c9                   	leave  
  800bf2:	c3                   	ret    

00800bf3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bf9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800bfc:	50                   	push   %eax
  800bfd:	ff 75 10             	pushl  0x10(%ebp)
  800c00:	ff 75 0c             	pushl  0xc(%ebp)
  800c03:	ff 75 08             	pushl  0x8(%ebp)
  800c06:	e8 9a ff ff ff       	call   800ba5 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c0b:	c9                   	leave  
  800c0c:	c3                   	ret    

00800c0d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c13:	b8 00 00 00 00       	mov    $0x0,%eax
  800c18:	eb 03                	jmp    800c1d <strlen+0x10>
		n++;
  800c1a:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c1d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c21:	75 f7                	jne    800c1a <strlen+0xd>
		n++;
	return n;
}
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    

00800c25 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c33:	eb 03                	jmp    800c38 <strnlen+0x13>
		n++;
  800c35:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c38:	39 c2                	cmp    %eax,%edx
  800c3a:	74 08                	je     800c44 <strnlen+0x1f>
  800c3c:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800c40:	75 f3                	jne    800c35 <strnlen+0x10>
  800c42:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  800c44:	5d                   	pop    %ebp
  800c45:	c3                   	ret    

00800c46 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	53                   	push   %ebx
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c50:	89 c2                	mov    %eax,%edx
  800c52:	83 c2 01             	add    $0x1,%edx
  800c55:	83 c1 01             	add    $0x1,%ecx
  800c58:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800c5c:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c5f:	84 db                	test   %bl,%bl
  800c61:	75 ef                	jne    800c52 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800c63:	5b                   	pop    %ebx
  800c64:	5d                   	pop    %ebp
  800c65:	c3                   	ret    

00800c66 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
  800c69:	53                   	push   %ebx
  800c6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c6d:	53                   	push   %ebx
  800c6e:	e8 9a ff ff ff       	call   800c0d <strlen>
  800c73:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800c76:	ff 75 0c             	pushl  0xc(%ebp)
  800c79:	01 d8                	add    %ebx,%eax
  800c7b:	50                   	push   %eax
  800c7c:	e8 c5 ff ff ff       	call   800c46 <strcpy>
	return dst;
}
  800c81:	89 d8                	mov    %ebx,%eax
  800c83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c86:	c9                   	leave  
  800c87:	c3                   	ret    

00800c88 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	56                   	push   %esi
  800c8c:	53                   	push   %ebx
  800c8d:	8b 75 08             	mov    0x8(%ebp),%esi
  800c90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c93:	89 f3                	mov    %esi,%ebx
  800c95:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c98:	89 f2                	mov    %esi,%edx
  800c9a:	eb 0f                	jmp    800cab <strncpy+0x23>
		*dst++ = *src;
  800c9c:	83 c2 01             	add    $0x1,%edx
  800c9f:	0f b6 01             	movzbl (%ecx),%eax
  800ca2:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ca5:	80 39 01             	cmpb   $0x1,(%ecx)
  800ca8:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cab:	39 da                	cmp    %ebx,%edx
  800cad:	75 ed                	jne    800c9c <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800caf:	89 f0                	mov    %esi,%eax
  800cb1:	5b                   	pop    %ebx
  800cb2:	5e                   	pop    %esi
  800cb3:	5d                   	pop    %ebp
  800cb4:	c3                   	ret    

00800cb5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	56                   	push   %esi
  800cb9:	53                   	push   %ebx
  800cba:	8b 75 08             	mov    0x8(%ebp),%esi
  800cbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc0:	8b 55 10             	mov    0x10(%ebp),%edx
  800cc3:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800cc5:	85 d2                	test   %edx,%edx
  800cc7:	74 21                	je     800cea <strlcpy+0x35>
  800cc9:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ccd:	89 f2                	mov    %esi,%edx
  800ccf:	eb 09                	jmp    800cda <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800cd1:	83 c2 01             	add    $0x1,%edx
  800cd4:	83 c1 01             	add    $0x1,%ecx
  800cd7:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cda:	39 c2                	cmp    %eax,%edx
  800cdc:	74 09                	je     800ce7 <strlcpy+0x32>
  800cde:	0f b6 19             	movzbl (%ecx),%ebx
  800ce1:	84 db                	test   %bl,%bl
  800ce3:	75 ec                	jne    800cd1 <strlcpy+0x1c>
  800ce5:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  800ce7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cea:	29 f0                	sub    %esi,%eax
}
  800cec:	5b                   	pop    %ebx
  800ced:	5e                   	pop    %esi
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cf6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cf9:	eb 06                	jmp    800d01 <strcmp+0x11>
		p++, q++;
  800cfb:	83 c1 01             	add    $0x1,%ecx
  800cfe:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d01:	0f b6 01             	movzbl (%ecx),%eax
  800d04:	84 c0                	test   %al,%al
  800d06:	74 04                	je     800d0c <strcmp+0x1c>
  800d08:	3a 02                	cmp    (%edx),%al
  800d0a:	74 ef                	je     800cfb <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d0c:	0f b6 c0             	movzbl %al,%eax
  800d0f:	0f b6 12             	movzbl (%edx),%edx
  800d12:	29 d0                	sub    %edx,%eax
}
  800d14:	5d                   	pop    %ebp
  800d15:	c3                   	ret    

00800d16 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	53                   	push   %ebx
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d20:	89 c3                	mov    %eax,%ebx
  800d22:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d25:	eb 06                	jmp    800d2d <strncmp+0x17>
		n--, p++, q++;
  800d27:	83 c0 01             	add    $0x1,%eax
  800d2a:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800d2d:	39 d8                	cmp    %ebx,%eax
  800d2f:	74 15                	je     800d46 <strncmp+0x30>
  800d31:	0f b6 08             	movzbl (%eax),%ecx
  800d34:	84 c9                	test   %cl,%cl
  800d36:	74 04                	je     800d3c <strncmp+0x26>
  800d38:	3a 0a                	cmp    (%edx),%cl
  800d3a:	74 eb                	je     800d27 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d3c:	0f b6 00             	movzbl (%eax),%eax
  800d3f:	0f b6 12             	movzbl (%edx),%edx
  800d42:	29 d0                	sub    %edx,%eax
  800d44:	eb 05                	jmp    800d4b <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800d46:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800d4b:	5b                   	pop    %ebx
  800d4c:	5d                   	pop    %ebp
  800d4d:	c3                   	ret    

00800d4e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d58:	eb 07                	jmp    800d61 <strchr+0x13>
		if (*s == c)
  800d5a:	38 ca                	cmp    %cl,%dl
  800d5c:	74 0f                	je     800d6d <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d5e:	83 c0 01             	add    $0x1,%eax
  800d61:	0f b6 10             	movzbl (%eax),%edx
  800d64:	84 d2                	test   %dl,%dl
  800d66:	75 f2                	jne    800d5a <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800d68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    

00800d6f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d79:	eb 03                	jmp    800d7e <strfind+0xf>
  800d7b:	83 c0 01             	add    $0x1,%eax
  800d7e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d81:	38 ca                	cmp    %cl,%dl
  800d83:	74 04                	je     800d89 <strfind+0x1a>
  800d85:	84 d2                	test   %dl,%dl
  800d87:	75 f2                	jne    800d7b <strfind+0xc>
			break;
	return (char *) s;
}
  800d89:	5d                   	pop    %ebp
  800d8a:	c3                   	ret    

00800d8b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
  800d8e:	57                   	push   %edi
  800d8f:	56                   	push   %esi
  800d90:	53                   	push   %ebx
  800d91:	8b 55 08             	mov    0x8(%ebp),%edx
  800d94:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800d97:	85 c9                	test   %ecx,%ecx
  800d99:	74 37                	je     800dd2 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d9b:	f6 c2 03             	test   $0x3,%dl
  800d9e:	75 2a                	jne    800dca <memset+0x3f>
  800da0:	f6 c1 03             	test   $0x3,%cl
  800da3:	75 25                	jne    800dca <memset+0x3f>
		c &= 0xFF;
  800da5:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800da9:	89 df                	mov    %ebx,%edi
  800dab:	c1 e7 08             	shl    $0x8,%edi
  800dae:	89 de                	mov    %ebx,%esi
  800db0:	c1 e6 18             	shl    $0x18,%esi
  800db3:	89 d8                	mov    %ebx,%eax
  800db5:	c1 e0 10             	shl    $0x10,%eax
  800db8:	09 f0                	or     %esi,%eax
  800dba:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800dbc:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800dbf:	89 f8                	mov    %edi,%eax
  800dc1:	09 d8                	or     %ebx,%eax
  800dc3:	89 d7                	mov    %edx,%edi
  800dc5:	fc                   	cld    
  800dc6:	f3 ab                	rep stos %eax,%es:(%edi)
  800dc8:	eb 08                	jmp    800dd2 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800dca:	89 d7                	mov    %edx,%edi
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	fc                   	cld    
  800dd0:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800dd2:	89 d0                	mov    %edx,%eax
  800dd4:	5b                   	pop    %ebx
  800dd5:	5e                   	pop    %esi
  800dd6:	5f                   	pop    %edi
  800dd7:	5d                   	pop    %ebp
  800dd8:	c3                   	ret    

00800dd9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	57                   	push   %edi
  800ddd:	56                   	push   %esi
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800de4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800de7:	39 c6                	cmp    %eax,%esi
  800de9:	73 35                	jae    800e20 <memmove+0x47>
  800deb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dee:	39 d0                	cmp    %edx,%eax
  800df0:	73 2e                	jae    800e20 <memmove+0x47>
		s += n;
		d += n;
  800df2:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800df5:	89 d6                	mov    %edx,%esi
  800df7:	09 fe                	or     %edi,%esi
  800df9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800dff:	75 13                	jne    800e14 <memmove+0x3b>
  800e01:	f6 c1 03             	test   $0x3,%cl
  800e04:	75 0e                	jne    800e14 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  800e06:	83 ef 04             	sub    $0x4,%edi
  800e09:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e0c:	c1 e9 02             	shr    $0x2,%ecx
  800e0f:	fd                   	std    
  800e10:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e12:	eb 09                	jmp    800e1d <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800e14:	83 ef 01             	sub    $0x1,%edi
  800e17:	8d 72 ff             	lea    -0x1(%edx),%esi
  800e1a:	fd                   	std    
  800e1b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e1d:	fc                   	cld    
  800e1e:	eb 1d                	jmp    800e3d <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e20:	89 f2                	mov    %esi,%edx
  800e22:	09 c2                	or     %eax,%edx
  800e24:	f6 c2 03             	test   $0x3,%dl
  800e27:	75 0f                	jne    800e38 <memmove+0x5f>
  800e29:	f6 c1 03             	test   $0x3,%cl
  800e2c:	75 0a                	jne    800e38 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  800e2e:	c1 e9 02             	shr    $0x2,%ecx
  800e31:	89 c7                	mov    %eax,%edi
  800e33:	fc                   	cld    
  800e34:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e36:	eb 05                	jmp    800e3d <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800e38:	89 c7                	mov    %eax,%edi
  800e3a:	fc                   	cld    
  800e3b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e3d:	5e                   	pop    %esi
  800e3e:	5f                   	pop    %edi
  800e3f:	5d                   	pop    %ebp
  800e40:	c3                   	ret    

00800e41 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800e44:	ff 75 10             	pushl  0x10(%ebp)
  800e47:	ff 75 0c             	pushl  0xc(%ebp)
  800e4a:	ff 75 08             	pushl  0x8(%ebp)
  800e4d:	e8 87 ff ff ff       	call   800dd9 <memmove>
}
  800e52:	c9                   	leave  
  800e53:	c3                   	ret    

00800e54 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	56                   	push   %esi
  800e58:	53                   	push   %ebx
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5f:	89 c6                	mov    %eax,%esi
  800e61:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e64:	eb 1a                	jmp    800e80 <memcmp+0x2c>
		if (*s1 != *s2)
  800e66:	0f b6 08             	movzbl (%eax),%ecx
  800e69:	0f b6 1a             	movzbl (%edx),%ebx
  800e6c:	38 d9                	cmp    %bl,%cl
  800e6e:	74 0a                	je     800e7a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800e70:	0f b6 c1             	movzbl %cl,%eax
  800e73:	0f b6 db             	movzbl %bl,%ebx
  800e76:	29 d8                	sub    %ebx,%eax
  800e78:	eb 0f                	jmp    800e89 <memcmp+0x35>
		s1++, s2++;
  800e7a:	83 c0 01             	add    $0x1,%eax
  800e7d:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e80:	39 f0                	cmp    %esi,%eax
  800e82:	75 e2                	jne    800e66 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e89:	5b                   	pop    %ebx
  800e8a:	5e                   	pop    %esi
  800e8b:	5d                   	pop    %ebp
  800e8c:	c3                   	ret    

00800e8d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	53                   	push   %ebx
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800e94:	89 c1                	mov    %eax,%ecx
  800e96:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  800e99:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e9d:	eb 0a                	jmp    800ea9 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e9f:	0f b6 10             	movzbl (%eax),%edx
  800ea2:	39 da                	cmp    %ebx,%edx
  800ea4:	74 07                	je     800ead <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ea6:	83 c0 01             	add    $0x1,%eax
  800ea9:	39 c8                	cmp    %ecx,%eax
  800eab:	72 f2                	jb     800e9f <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ead:	5b                   	pop    %ebx
  800eae:	5d                   	pop    %ebp
  800eaf:	c3                   	ret    

00800eb0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	57                   	push   %edi
  800eb4:	56                   	push   %esi
  800eb5:	53                   	push   %ebx
  800eb6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eb9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ebc:	eb 03                	jmp    800ec1 <strtol+0x11>
		s++;
  800ebe:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ec1:	0f b6 01             	movzbl (%ecx),%eax
  800ec4:	3c 20                	cmp    $0x20,%al
  800ec6:	74 f6                	je     800ebe <strtol+0xe>
  800ec8:	3c 09                	cmp    $0x9,%al
  800eca:	74 f2                	je     800ebe <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ecc:	3c 2b                	cmp    $0x2b,%al
  800ece:	75 0a                	jne    800eda <strtol+0x2a>
		s++;
  800ed0:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ed3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ed8:	eb 11                	jmp    800eeb <strtol+0x3b>
  800eda:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800edf:	3c 2d                	cmp    $0x2d,%al
  800ee1:	75 08                	jne    800eeb <strtol+0x3b>
		s++, neg = 1;
  800ee3:	83 c1 01             	add    $0x1,%ecx
  800ee6:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eeb:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ef1:	75 15                	jne    800f08 <strtol+0x58>
  800ef3:	80 39 30             	cmpb   $0x30,(%ecx)
  800ef6:	75 10                	jne    800f08 <strtol+0x58>
  800ef8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800efc:	75 7c                	jne    800f7a <strtol+0xca>
		s += 2, base = 16;
  800efe:	83 c1 02             	add    $0x2,%ecx
  800f01:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f06:	eb 16                	jmp    800f1e <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800f08:	85 db                	test   %ebx,%ebx
  800f0a:	75 12                	jne    800f1e <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f0c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f11:	80 39 30             	cmpb   $0x30,(%ecx)
  800f14:	75 08                	jne    800f1e <strtol+0x6e>
		s++, base = 8;
  800f16:	83 c1 01             	add    $0x1,%ecx
  800f19:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800f1e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f23:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f26:	0f b6 11             	movzbl (%ecx),%edx
  800f29:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f2c:	89 f3                	mov    %esi,%ebx
  800f2e:	80 fb 09             	cmp    $0x9,%bl
  800f31:	77 08                	ja     800f3b <strtol+0x8b>
			dig = *s - '0';
  800f33:	0f be d2             	movsbl %dl,%edx
  800f36:	83 ea 30             	sub    $0x30,%edx
  800f39:	eb 22                	jmp    800f5d <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800f3b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f3e:	89 f3                	mov    %esi,%ebx
  800f40:	80 fb 19             	cmp    $0x19,%bl
  800f43:	77 08                	ja     800f4d <strtol+0x9d>
			dig = *s - 'a' + 10;
  800f45:	0f be d2             	movsbl %dl,%edx
  800f48:	83 ea 57             	sub    $0x57,%edx
  800f4b:	eb 10                	jmp    800f5d <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800f4d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f50:	89 f3                	mov    %esi,%ebx
  800f52:	80 fb 19             	cmp    $0x19,%bl
  800f55:	77 16                	ja     800f6d <strtol+0xbd>
			dig = *s - 'A' + 10;
  800f57:	0f be d2             	movsbl %dl,%edx
  800f5a:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800f5d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f60:	7d 0b                	jge    800f6d <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800f62:	83 c1 01             	add    $0x1,%ecx
  800f65:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f69:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800f6b:	eb b9                	jmp    800f26 <strtol+0x76>

	if (endptr)
  800f6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f71:	74 0d                	je     800f80 <strtol+0xd0>
		*endptr = (char *) s;
  800f73:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f76:	89 0e                	mov    %ecx,(%esi)
  800f78:	eb 06                	jmp    800f80 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f7a:	85 db                	test   %ebx,%ebx
  800f7c:	74 98                	je     800f16 <strtol+0x66>
  800f7e:	eb 9e                	jmp    800f1e <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800f80:	89 c2                	mov    %eax,%edx
  800f82:	f7 da                	neg    %edx
  800f84:	85 ff                	test   %edi,%edi
  800f86:	0f 45 c2             	cmovne %edx,%eax
}
  800f89:	5b                   	pop    %ebx
  800f8a:	5e                   	pop    %esi
  800f8b:	5f                   	pop    %edi
  800f8c:	5d                   	pop    %ebp
  800f8d:	c3                   	ret    

00800f8e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	57                   	push   %edi
  800f92:	56                   	push   %esi
  800f93:	53                   	push   %ebx
  800f94:	83 ec 1c             	sub    $0x1c,%esp
  800f97:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800f9a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800f9d:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fa2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800fa5:	8b 7d 10             	mov    0x10(%ebp),%edi
  800fa8:	8b 75 14             	mov    0x14(%ebp),%esi
  800fab:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800fad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fb1:	74 1d                	je     800fd0 <syscall+0x42>
  800fb3:	85 c0                	test   %eax,%eax
  800fb5:	7e 19                	jle    800fd0 <syscall+0x42>
  800fb7:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800fba:	83 ec 0c             	sub    $0xc,%esp
  800fbd:	50                   	push   %eax
  800fbe:	52                   	push   %edx
  800fbf:	68 5f 27 80 00       	push   $0x80275f
  800fc4:	6a 23                	push   $0x23
  800fc6:	68 7c 27 80 00       	push   $0x80277c
  800fcb:	e8 2b f6 ff ff       	call   8005fb <_panic>

	return ret;
}
  800fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd3:	5b                   	pop    %ebx
  800fd4:	5e                   	pop    %esi
  800fd5:	5f                   	pop    %edi
  800fd6:	5d                   	pop    %ebp
  800fd7:	c3                   	ret    

00800fd8 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800fd8:	55                   	push   %ebp
  800fd9:	89 e5                	mov    %esp,%ebp
  800fdb:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800fde:	6a 00                	push   $0x0
  800fe0:	6a 00                	push   $0x0
  800fe2:	6a 00                	push   $0x0
  800fe4:	ff 75 0c             	pushl  0xc(%ebp)
  800fe7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fea:	ba 00 00 00 00       	mov    $0x0,%edx
  800fef:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff4:	e8 95 ff ff ff       	call   800f8e <syscall>
}
  800ff9:	83 c4 10             	add    $0x10,%esp
  800ffc:	c9                   	leave  
  800ffd:	c3                   	ret    

00800ffe <sys_cgetc>:

int
sys_cgetc(void)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
  801001:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801004:	6a 00                	push   $0x0
  801006:	6a 00                	push   $0x0
  801008:	6a 00                	push   $0x0
  80100a:	6a 00                	push   $0x0
  80100c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801011:	ba 00 00 00 00       	mov    $0x0,%edx
  801016:	b8 01 00 00 00       	mov    $0x1,%eax
  80101b:	e8 6e ff ff ff       	call   800f8e <syscall>
}
  801020:	c9                   	leave  
  801021:	c3                   	ret    

00801022 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
  801025:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801028:	6a 00                	push   $0x0
  80102a:	6a 00                	push   $0x0
  80102c:	6a 00                	push   $0x0
  80102e:	6a 00                	push   $0x0
  801030:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801033:	ba 01 00 00 00       	mov    $0x1,%edx
  801038:	b8 03 00 00 00       	mov    $0x3,%eax
  80103d:	e8 4c ff ff ff       	call   800f8e <syscall>
}
  801042:	c9                   	leave  
  801043:	c3                   	ret    

00801044 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
  801047:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80104a:	6a 00                	push   $0x0
  80104c:	6a 00                	push   $0x0
  80104e:	6a 00                	push   $0x0
  801050:	6a 00                	push   $0x0
  801052:	b9 00 00 00 00       	mov    $0x0,%ecx
  801057:	ba 00 00 00 00       	mov    $0x0,%edx
  80105c:	b8 02 00 00 00       	mov    $0x2,%eax
  801061:	e8 28 ff ff ff       	call   800f8e <syscall>
}
  801066:	c9                   	leave  
  801067:	c3                   	ret    

00801068 <sys_yield>:

void
sys_yield(void)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80106e:	6a 00                	push   $0x0
  801070:	6a 00                	push   $0x0
  801072:	6a 00                	push   $0x0
  801074:	6a 00                	push   $0x0
  801076:	b9 00 00 00 00       	mov    $0x0,%ecx
  80107b:	ba 00 00 00 00       	mov    $0x0,%edx
  801080:	b8 0b 00 00 00       	mov    $0xb,%eax
  801085:	e8 04 ff ff ff       	call   800f8e <syscall>
}
  80108a:	83 c4 10             	add    $0x10,%esp
  80108d:	c9                   	leave  
  80108e:	c3                   	ret    

0080108f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
  801092:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  801095:	6a 00                	push   $0x0
  801097:	6a 00                	push   $0x0
  801099:	ff 75 10             	pushl  0x10(%ebp)
  80109c:	ff 75 0c             	pushl  0xc(%ebp)
  80109f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a2:	ba 01 00 00 00       	mov    $0x1,%edx
  8010a7:	b8 04 00 00 00       	mov    $0x4,%eax
  8010ac:	e8 dd fe ff ff       	call   800f8e <syscall>
}
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    

008010b3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8010b9:	ff 75 18             	pushl  0x18(%ebp)
  8010bc:	ff 75 14             	pushl  0x14(%ebp)
  8010bf:	ff 75 10             	pushl  0x10(%ebp)
  8010c2:	ff 75 0c             	pushl  0xc(%ebp)
  8010c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c8:	ba 01 00 00 00       	mov    $0x1,%edx
  8010cd:	b8 05 00 00 00       	mov    $0x5,%eax
  8010d2:	e8 b7 fe ff ff       	call   800f8e <syscall>
}
  8010d7:	c9                   	leave  
  8010d8:	c3                   	ret    

008010d9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  8010df:	6a 00                	push   $0x0
  8010e1:	6a 00                	push   $0x0
  8010e3:	6a 00                	push   $0x0
  8010e5:	ff 75 0c             	pushl  0xc(%ebp)
  8010e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010eb:	ba 01 00 00 00       	mov    $0x1,%edx
  8010f0:	b8 06 00 00 00       	mov    $0x6,%eax
  8010f5:	e8 94 fe ff ff       	call   800f8e <syscall>
}
  8010fa:	c9                   	leave  
  8010fb:	c3                   	ret    

008010fc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801102:	6a 00                	push   $0x0
  801104:	6a 00                	push   $0x0
  801106:	6a 00                	push   $0x0
  801108:	ff 75 0c             	pushl  0xc(%ebp)
  80110b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80110e:	ba 01 00 00 00       	mov    $0x1,%edx
  801113:	b8 08 00 00 00       	mov    $0x8,%eax
  801118:	e8 71 fe ff ff       	call   800f8e <syscall>
}
  80111d:	c9                   	leave  
  80111e:	c3                   	ret    

0080111f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  801125:	6a 00                	push   $0x0
  801127:	6a 00                	push   $0x0
  801129:	6a 00                	push   $0x0
  80112b:	ff 75 0c             	pushl  0xc(%ebp)
  80112e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801131:	ba 01 00 00 00       	mov    $0x1,%edx
  801136:	b8 09 00 00 00       	mov    $0x9,%eax
  80113b:	e8 4e fe ff ff       	call   800f8e <syscall>
}
  801140:	c9                   	leave  
  801141:	c3                   	ret    

00801142 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801142:	55                   	push   %ebp
  801143:	89 e5                	mov    %esp,%ebp
  801145:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  801148:	6a 00                	push   $0x0
  80114a:	6a 00                	push   $0x0
  80114c:	6a 00                	push   $0x0
  80114e:	ff 75 0c             	pushl  0xc(%ebp)
  801151:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801154:	ba 01 00 00 00       	mov    $0x1,%edx
  801159:	b8 0a 00 00 00       	mov    $0xa,%eax
  80115e:	e8 2b fe ff ff       	call   800f8e <syscall>
}
  801163:	c9                   	leave  
  801164:	c3                   	ret    

00801165 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
  801168:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  80116b:	6a 00                	push   $0x0
  80116d:	ff 75 14             	pushl  0x14(%ebp)
  801170:	ff 75 10             	pushl  0x10(%ebp)
  801173:	ff 75 0c             	pushl  0xc(%ebp)
  801176:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801179:	ba 00 00 00 00       	mov    $0x0,%edx
  80117e:	b8 0c 00 00 00       	mov    $0xc,%eax
  801183:	e8 06 fe ff ff       	call   800f8e <syscall>
}
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  801190:	6a 00                	push   $0x0
  801192:	6a 00                	push   $0x0
  801194:	6a 00                	push   $0x0
  801196:	6a 00                	push   $0x0
  801198:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80119b:	ba 01 00 00 00       	mov    $0x1,%edx
  8011a0:	b8 0d 00 00 00       	mov    $0xd,%eax
  8011a5:	e8 e4 fd ff ff       	call   800f8e <syscall>
}
  8011aa:	c9                   	leave  
  8011ab:	c3                   	ret    

008011ac <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8011b2:	83 3d b4 40 80 00 00 	cmpl   $0x0,0x8040b4
  8011b9:	75 2c                	jne    8011e7 <set_pgfault_handler+0x3b>
		// First time through!
		// LAB 4: Your code here.
		r = sys_page_alloc(0,(void *)(UXSTACKTOP - PGSIZE),PTE_P | PTE_U | PTE_W);
  8011bb:	83 ec 04             	sub    $0x4,%esp
  8011be:	6a 07                	push   $0x7
  8011c0:	68 00 f0 bf ee       	push   $0xeebff000
  8011c5:	6a 00                	push   $0x0
  8011c7:	e8 c3 fe ff ff       	call   80108f <sys_page_alloc>
		if(r < 0)
  8011cc:	83 c4 10             	add    $0x10,%esp
  8011cf:	85 c0                	test   %eax,%eax
  8011d1:	79 14                	jns    8011e7 <set_pgfault_handler+0x3b>
			panic("set_pgfault_handler: error in sys_page_alloc\n");	
  8011d3:	83 ec 04             	sub    $0x4,%esp
  8011d6:	68 8c 27 80 00       	push   $0x80278c
  8011db:	6a 22                	push   $0x22
  8011dd:	68 f5 27 80 00       	push   $0x8027f5
  8011e2:	e8 14 f4 ff ff       	call   8005fb <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	a3 b4 40 80 00       	mov    %eax,0x8040b4
	r = sys_env_set_pgfault_upcall(0, _pgfault_upcall); 
  8011ef:	83 ec 08             	sub    $0x8,%esp
  8011f2:	68 1b 12 80 00       	push   $0x80121b
  8011f7:	6a 00                	push   $0x0
  8011f9:	e8 44 ff ff ff       	call   801142 <sys_env_set_pgfault_upcall>
	if (r < 0)
  8011fe:	83 c4 10             	add    $0x10,%esp
  801201:	85 c0                	test   %eax,%eax
  801203:	79 14                	jns    801219 <set_pgfault_handler+0x6d>
		panic("set_pgfault_handler: error in sys_env_set_pgfault_upcall");
  801205:	83 ec 04             	sub    $0x4,%esp
  801208:	68 bc 27 80 00       	push   $0x8027bc
  80120d:	6a 29                	push   $0x29
  80120f:	68 f5 27 80 00       	push   $0x8027f5
  801214:	e8 e2 f3 ff ff       	call   8005fb <_panic>
}
  801219:	c9                   	leave  
  80121a:	c3                   	ret    

0080121b <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80121b:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80121c:	a1 b4 40 80 00       	mov    0x8040b4,%eax
	call *%eax
  801221:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801223:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	subl $0x4, 0x30(%esp)
  801226:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  80122b:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 0x28(%esp), %ebx 	
  80122f:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  801233:	89 18                	mov    %ebx,(%eax)
	addl $0x8, %esp
  801235:	83 c4 08             	add    $0x8,%esp


	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  801238:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp 
  801239:	83 c4 04             	add    $0x4,%esp
	popfl
  80123c:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80123d:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80123e:	c3                   	ret    

0080123f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80123f:	55                   	push   %ebp
  801240:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	05 00 00 00 30       	add    $0x30000000,%eax
  80124a:	c1 e8 0c             	shr    $0xc,%eax
}
  80124d:	5d                   	pop    %ebp
  80124e:	c3                   	ret    

0080124f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80124f:	55                   	push   %ebp
  801250:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  801252:	ff 75 08             	pushl  0x8(%ebp)
  801255:	e8 e5 ff ff ff       	call   80123f <fd2num>
  80125a:	83 c4 04             	add    $0x4,%esp
  80125d:	c1 e0 0c             	shl    $0xc,%eax
  801260:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801265:	c9                   	leave  
  801266:	c3                   	ret    

00801267 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
  80126a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80126d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801272:	89 c2                	mov    %eax,%edx
  801274:	c1 ea 16             	shr    $0x16,%edx
  801277:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80127e:	f6 c2 01             	test   $0x1,%dl
  801281:	74 11                	je     801294 <fd_alloc+0x2d>
  801283:	89 c2                	mov    %eax,%edx
  801285:	c1 ea 0c             	shr    $0xc,%edx
  801288:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80128f:	f6 c2 01             	test   $0x1,%dl
  801292:	75 09                	jne    80129d <fd_alloc+0x36>
			*fd_store = fd;
  801294:	89 01                	mov    %eax,(%ecx)
			return 0;
  801296:	b8 00 00 00 00       	mov    $0x0,%eax
  80129b:	eb 17                	jmp    8012b4 <fd_alloc+0x4d>
  80129d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8012a2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012a7:	75 c9                	jne    801272 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012a9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8012af:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8012b4:	5d                   	pop    %ebp
  8012b5:	c3                   	ret    

008012b6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012bc:	83 f8 1f             	cmp    $0x1f,%eax
  8012bf:	77 36                	ja     8012f7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012c1:	c1 e0 0c             	shl    $0xc,%eax
  8012c4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012c9:	89 c2                	mov    %eax,%edx
  8012cb:	c1 ea 16             	shr    $0x16,%edx
  8012ce:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012d5:	f6 c2 01             	test   $0x1,%dl
  8012d8:	74 24                	je     8012fe <fd_lookup+0x48>
  8012da:	89 c2                	mov    %eax,%edx
  8012dc:	c1 ea 0c             	shr    $0xc,%edx
  8012df:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012e6:	f6 c2 01             	test   $0x1,%dl
  8012e9:	74 1a                	je     801305 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ee:	89 02                	mov    %eax,(%edx)
	return 0;
  8012f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f5:	eb 13                	jmp    80130a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8012f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012fc:	eb 0c                	jmp    80130a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8012fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801303:	eb 05                	jmp    80130a <fd_lookup+0x54>
  801305:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    

0080130c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 08             	sub    $0x8,%esp
  801312:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801315:	ba 84 28 80 00       	mov    $0x802884,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80131a:	eb 13                	jmp    80132f <dev_lookup+0x23>
  80131c:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  80131f:	39 08                	cmp    %ecx,(%eax)
  801321:	75 0c                	jne    80132f <dev_lookup+0x23>
			*dev = devtab[i];
  801323:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801326:	89 01                	mov    %eax,(%ecx)
			return 0;
  801328:	b8 00 00 00 00       	mov    $0x0,%eax
  80132d:	eb 2e                	jmp    80135d <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80132f:	8b 02                	mov    (%edx),%eax
  801331:	85 c0                	test   %eax,%eax
  801333:	75 e7                	jne    80131c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801335:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  80133a:	8b 40 48             	mov    0x48(%eax),%eax
  80133d:	83 ec 04             	sub    $0x4,%esp
  801340:	51                   	push   %ecx
  801341:	50                   	push   %eax
  801342:	68 04 28 80 00       	push   $0x802804
  801347:	e8 88 f3 ff ff       	call   8006d4 <cprintf>
	*dev = 0;
  80134c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801355:	83 c4 10             	add    $0x10,%esp
  801358:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80135d:	c9                   	leave  
  80135e:	c3                   	ret    

0080135f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
  801362:	56                   	push   %esi
  801363:	53                   	push   %ebx
  801364:	83 ec 10             	sub    $0x10,%esp
  801367:	8b 75 08             	mov    0x8(%ebp),%esi
  80136a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80136d:	56                   	push   %esi
  80136e:	e8 cc fe ff ff       	call   80123f <fd2num>
  801373:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801376:	89 14 24             	mov    %edx,(%esp)
  801379:	50                   	push   %eax
  80137a:	e8 37 ff ff ff       	call   8012b6 <fd_lookup>
  80137f:	83 c4 08             	add    $0x8,%esp
  801382:	85 c0                	test   %eax,%eax
  801384:	78 05                	js     80138b <fd_close+0x2c>
	    || fd != fd2)
  801386:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801389:	74 0c                	je     801397 <fd_close+0x38>
		return (must_exist ? r : 0);
  80138b:	84 db                	test   %bl,%bl
  80138d:	ba 00 00 00 00       	mov    $0x0,%edx
  801392:	0f 44 c2             	cmove  %edx,%eax
  801395:	eb 41                	jmp    8013d8 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801397:	83 ec 08             	sub    $0x8,%esp
  80139a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80139d:	50                   	push   %eax
  80139e:	ff 36                	pushl  (%esi)
  8013a0:	e8 67 ff ff ff       	call   80130c <dev_lookup>
  8013a5:	89 c3                	mov    %eax,%ebx
  8013a7:	83 c4 10             	add    $0x10,%esp
  8013aa:	85 c0                	test   %eax,%eax
  8013ac:	78 1a                	js     8013c8 <fd_close+0x69>
		if (dev->dev_close)
  8013ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b1:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8013b4:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8013b9:	85 c0                	test   %eax,%eax
  8013bb:	74 0b                	je     8013c8 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  8013bd:	83 ec 0c             	sub    $0xc,%esp
  8013c0:	56                   	push   %esi
  8013c1:	ff d0                	call   *%eax
  8013c3:	89 c3                	mov    %eax,%ebx
  8013c5:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8013c8:	83 ec 08             	sub    $0x8,%esp
  8013cb:	56                   	push   %esi
  8013cc:	6a 00                	push   $0x0
  8013ce:	e8 06 fd ff ff       	call   8010d9 <sys_page_unmap>
	return r;
  8013d3:	83 c4 10             	add    $0x10,%esp
  8013d6:	89 d8                	mov    %ebx,%eax
}
  8013d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013db:	5b                   	pop    %ebx
  8013dc:	5e                   	pop    %esi
  8013dd:	5d                   	pop    %ebp
  8013de:	c3                   	ret    

008013df <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
  8013e2:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013e8:	50                   	push   %eax
  8013e9:	ff 75 08             	pushl  0x8(%ebp)
  8013ec:	e8 c5 fe ff ff       	call   8012b6 <fd_lookup>
  8013f1:	83 c4 08             	add    $0x8,%esp
  8013f4:	85 c0                	test   %eax,%eax
  8013f6:	78 10                	js     801408 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8013f8:	83 ec 08             	sub    $0x8,%esp
  8013fb:	6a 01                	push   $0x1
  8013fd:	ff 75 f4             	pushl  -0xc(%ebp)
  801400:	e8 5a ff ff ff       	call   80135f <fd_close>
  801405:	83 c4 10             	add    $0x10,%esp
}
  801408:	c9                   	leave  
  801409:	c3                   	ret    

0080140a <close_all>:

void
close_all(void)
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
  80140d:	53                   	push   %ebx
  80140e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801411:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801416:	83 ec 0c             	sub    $0xc,%esp
  801419:	53                   	push   %ebx
  80141a:	e8 c0 ff ff ff       	call   8013df <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80141f:	83 c3 01             	add    $0x1,%ebx
  801422:	83 c4 10             	add    $0x10,%esp
  801425:	83 fb 20             	cmp    $0x20,%ebx
  801428:	75 ec                	jne    801416 <close_all+0xc>
		close(i);
}
  80142a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80142d:	c9                   	leave  
  80142e:	c3                   	ret    

0080142f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
  801432:	57                   	push   %edi
  801433:	56                   	push   %esi
  801434:	53                   	push   %ebx
  801435:	83 ec 2c             	sub    $0x2c,%esp
  801438:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80143b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80143e:	50                   	push   %eax
  80143f:	ff 75 08             	pushl  0x8(%ebp)
  801442:	e8 6f fe ff ff       	call   8012b6 <fd_lookup>
  801447:	83 c4 08             	add    $0x8,%esp
  80144a:	85 c0                	test   %eax,%eax
  80144c:	0f 88 c1 00 00 00    	js     801513 <dup+0xe4>
		return r;
	close(newfdnum);
  801452:	83 ec 0c             	sub    $0xc,%esp
  801455:	56                   	push   %esi
  801456:	e8 84 ff ff ff       	call   8013df <close>

	newfd = INDEX2FD(newfdnum);
  80145b:	89 f3                	mov    %esi,%ebx
  80145d:	c1 e3 0c             	shl    $0xc,%ebx
  801460:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801466:	83 c4 04             	add    $0x4,%esp
  801469:	ff 75 e4             	pushl  -0x1c(%ebp)
  80146c:	e8 de fd ff ff       	call   80124f <fd2data>
  801471:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  801473:	89 1c 24             	mov    %ebx,(%esp)
  801476:	e8 d4 fd ff ff       	call   80124f <fd2data>
  80147b:	83 c4 10             	add    $0x10,%esp
  80147e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801481:	89 f8                	mov    %edi,%eax
  801483:	c1 e8 16             	shr    $0x16,%eax
  801486:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80148d:	a8 01                	test   $0x1,%al
  80148f:	74 37                	je     8014c8 <dup+0x99>
  801491:	89 f8                	mov    %edi,%eax
  801493:	c1 e8 0c             	shr    $0xc,%eax
  801496:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80149d:	f6 c2 01             	test   $0x1,%dl
  8014a0:	74 26                	je     8014c8 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014a2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014a9:	83 ec 0c             	sub    $0xc,%esp
  8014ac:	25 07 0e 00 00       	and    $0xe07,%eax
  8014b1:	50                   	push   %eax
  8014b2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8014b5:	6a 00                	push   $0x0
  8014b7:	57                   	push   %edi
  8014b8:	6a 00                	push   $0x0
  8014ba:	e8 f4 fb ff ff       	call   8010b3 <sys_page_map>
  8014bf:	89 c7                	mov    %eax,%edi
  8014c1:	83 c4 20             	add    $0x20,%esp
  8014c4:	85 c0                	test   %eax,%eax
  8014c6:	78 2e                	js     8014f6 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014cb:	89 d0                	mov    %edx,%eax
  8014cd:	c1 e8 0c             	shr    $0xc,%eax
  8014d0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014d7:	83 ec 0c             	sub    $0xc,%esp
  8014da:	25 07 0e 00 00       	and    $0xe07,%eax
  8014df:	50                   	push   %eax
  8014e0:	53                   	push   %ebx
  8014e1:	6a 00                	push   $0x0
  8014e3:	52                   	push   %edx
  8014e4:	6a 00                	push   $0x0
  8014e6:	e8 c8 fb ff ff       	call   8010b3 <sys_page_map>
  8014eb:	89 c7                	mov    %eax,%edi
  8014ed:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  8014f0:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014f2:	85 ff                	test   %edi,%edi
  8014f4:	79 1d                	jns    801513 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8014f6:	83 ec 08             	sub    $0x8,%esp
  8014f9:	53                   	push   %ebx
  8014fa:	6a 00                	push   $0x0
  8014fc:	e8 d8 fb ff ff       	call   8010d9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801501:	83 c4 08             	add    $0x8,%esp
  801504:	ff 75 d4             	pushl  -0x2c(%ebp)
  801507:	6a 00                	push   $0x0
  801509:	e8 cb fb ff ff       	call   8010d9 <sys_page_unmap>
	return r;
  80150e:	83 c4 10             	add    $0x10,%esp
  801511:	89 f8                	mov    %edi,%eax
}
  801513:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801516:	5b                   	pop    %ebx
  801517:	5e                   	pop    %esi
  801518:	5f                   	pop    %edi
  801519:	5d                   	pop    %ebp
  80151a:	c3                   	ret    

0080151b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80151b:	55                   	push   %ebp
  80151c:	89 e5                	mov    %esp,%ebp
  80151e:	53                   	push   %ebx
  80151f:	83 ec 14             	sub    $0x14,%esp
  801522:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801525:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801528:	50                   	push   %eax
  801529:	53                   	push   %ebx
  80152a:	e8 87 fd ff ff       	call   8012b6 <fd_lookup>
  80152f:	83 c4 08             	add    $0x8,%esp
  801532:	89 c2                	mov    %eax,%edx
  801534:	85 c0                	test   %eax,%eax
  801536:	78 6d                	js     8015a5 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801538:	83 ec 08             	sub    $0x8,%esp
  80153b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80153e:	50                   	push   %eax
  80153f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801542:	ff 30                	pushl  (%eax)
  801544:	e8 c3 fd ff ff       	call   80130c <dev_lookup>
  801549:	83 c4 10             	add    $0x10,%esp
  80154c:	85 c0                	test   %eax,%eax
  80154e:	78 4c                	js     80159c <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801550:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801553:	8b 42 08             	mov    0x8(%edx),%eax
  801556:	83 e0 03             	and    $0x3,%eax
  801559:	83 f8 01             	cmp    $0x1,%eax
  80155c:	75 21                	jne    80157f <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80155e:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  801563:	8b 40 48             	mov    0x48(%eax),%eax
  801566:	83 ec 04             	sub    $0x4,%esp
  801569:	53                   	push   %ebx
  80156a:	50                   	push   %eax
  80156b:	68 48 28 80 00       	push   $0x802848
  801570:	e8 5f f1 ff ff       	call   8006d4 <cprintf>
		return -E_INVAL;
  801575:	83 c4 10             	add    $0x10,%esp
  801578:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80157d:	eb 26                	jmp    8015a5 <read+0x8a>
	}
	if (!dev->dev_read)
  80157f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801582:	8b 40 08             	mov    0x8(%eax),%eax
  801585:	85 c0                	test   %eax,%eax
  801587:	74 17                	je     8015a0 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801589:	83 ec 04             	sub    $0x4,%esp
  80158c:	ff 75 10             	pushl  0x10(%ebp)
  80158f:	ff 75 0c             	pushl  0xc(%ebp)
  801592:	52                   	push   %edx
  801593:	ff d0                	call   *%eax
  801595:	89 c2                	mov    %eax,%edx
  801597:	83 c4 10             	add    $0x10,%esp
  80159a:	eb 09                	jmp    8015a5 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80159c:	89 c2                	mov    %eax,%edx
  80159e:	eb 05                	jmp    8015a5 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8015a0:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  8015a5:	89 d0                	mov    %edx,%eax
  8015a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    

008015ac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
  8015af:	57                   	push   %edi
  8015b0:	56                   	push   %esi
  8015b1:	53                   	push   %ebx
  8015b2:	83 ec 0c             	sub    $0xc,%esp
  8015b5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015b8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015c0:	eb 21                	jmp    8015e3 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015c2:	83 ec 04             	sub    $0x4,%esp
  8015c5:	89 f0                	mov    %esi,%eax
  8015c7:	29 d8                	sub    %ebx,%eax
  8015c9:	50                   	push   %eax
  8015ca:	89 d8                	mov    %ebx,%eax
  8015cc:	03 45 0c             	add    0xc(%ebp),%eax
  8015cf:	50                   	push   %eax
  8015d0:	57                   	push   %edi
  8015d1:	e8 45 ff ff ff       	call   80151b <read>
		if (m < 0)
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	78 10                	js     8015ed <readn+0x41>
			return m;
		if (m == 0)
  8015dd:	85 c0                	test   %eax,%eax
  8015df:	74 0a                	je     8015eb <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015e1:	01 c3                	add    %eax,%ebx
  8015e3:	39 f3                	cmp    %esi,%ebx
  8015e5:	72 db                	jb     8015c2 <readn+0x16>
  8015e7:	89 d8                	mov    %ebx,%eax
  8015e9:	eb 02                	jmp    8015ed <readn+0x41>
  8015eb:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8015ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015f0:	5b                   	pop    %ebx
  8015f1:	5e                   	pop    %esi
  8015f2:	5f                   	pop    %edi
  8015f3:	5d                   	pop    %ebp
  8015f4:	c3                   	ret    

008015f5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	53                   	push   %ebx
  8015f9:	83 ec 14             	sub    $0x14,%esp
  8015fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801602:	50                   	push   %eax
  801603:	53                   	push   %ebx
  801604:	e8 ad fc ff ff       	call   8012b6 <fd_lookup>
  801609:	83 c4 08             	add    $0x8,%esp
  80160c:	89 c2                	mov    %eax,%edx
  80160e:	85 c0                	test   %eax,%eax
  801610:	78 68                	js     80167a <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801612:	83 ec 08             	sub    $0x8,%esp
  801615:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801618:	50                   	push   %eax
  801619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161c:	ff 30                	pushl  (%eax)
  80161e:	e8 e9 fc ff ff       	call   80130c <dev_lookup>
  801623:	83 c4 10             	add    $0x10,%esp
  801626:	85 c0                	test   %eax,%eax
  801628:	78 47                	js     801671 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80162a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801631:	75 21                	jne    801654 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801633:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  801638:	8b 40 48             	mov    0x48(%eax),%eax
  80163b:	83 ec 04             	sub    $0x4,%esp
  80163e:	53                   	push   %ebx
  80163f:	50                   	push   %eax
  801640:	68 64 28 80 00       	push   $0x802864
  801645:	e8 8a f0 ff ff       	call   8006d4 <cprintf>
		return -E_INVAL;
  80164a:	83 c4 10             	add    $0x10,%esp
  80164d:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801652:	eb 26                	jmp    80167a <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801654:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801657:	8b 52 0c             	mov    0xc(%edx),%edx
  80165a:	85 d2                	test   %edx,%edx
  80165c:	74 17                	je     801675 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80165e:	83 ec 04             	sub    $0x4,%esp
  801661:	ff 75 10             	pushl  0x10(%ebp)
  801664:	ff 75 0c             	pushl  0xc(%ebp)
  801667:	50                   	push   %eax
  801668:	ff d2                	call   *%edx
  80166a:	89 c2                	mov    %eax,%edx
  80166c:	83 c4 10             	add    $0x10,%esp
  80166f:	eb 09                	jmp    80167a <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801671:	89 c2                	mov    %eax,%edx
  801673:	eb 05                	jmp    80167a <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801675:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  80167a:	89 d0                	mov    %edx,%eax
  80167c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <seek>:

int
seek(int fdnum, off_t offset)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801687:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80168a:	50                   	push   %eax
  80168b:	ff 75 08             	pushl  0x8(%ebp)
  80168e:	e8 23 fc ff ff       	call   8012b6 <fd_lookup>
  801693:	83 c4 08             	add    $0x8,%esp
  801696:	85 c0                	test   %eax,%eax
  801698:	78 0e                	js     8016a8 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80169a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80169d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
  8016ad:	53                   	push   %ebx
  8016ae:	83 ec 14             	sub    $0x14,%esp
  8016b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b7:	50                   	push   %eax
  8016b8:	53                   	push   %ebx
  8016b9:	e8 f8 fb ff ff       	call   8012b6 <fd_lookup>
  8016be:	83 c4 08             	add    $0x8,%esp
  8016c1:	89 c2                	mov    %eax,%edx
  8016c3:	85 c0                	test   %eax,%eax
  8016c5:	78 65                	js     80172c <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c7:	83 ec 08             	sub    $0x8,%esp
  8016ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016cd:	50                   	push   %eax
  8016ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d1:	ff 30                	pushl  (%eax)
  8016d3:	e8 34 fc ff ff       	call   80130c <dev_lookup>
  8016d8:	83 c4 10             	add    $0x10,%esp
  8016db:	85 c0                	test   %eax,%eax
  8016dd:	78 44                	js     801723 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016e6:	75 21                	jne    801709 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8016e8:	a1 b0 40 80 00       	mov    0x8040b0,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016ed:	8b 40 48             	mov    0x48(%eax),%eax
  8016f0:	83 ec 04             	sub    $0x4,%esp
  8016f3:	53                   	push   %ebx
  8016f4:	50                   	push   %eax
  8016f5:	68 24 28 80 00       	push   $0x802824
  8016fa:	e8 d5 ef ff ff       	call   8006d4 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801707:	eb 23                	jmp    80172c <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  801709:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80170c:	8b 52 18             	mov    0x18(%edx),%edx
  80170f:	85 d2                	test   %edx,%edx
  801711:	74 14                	je     801727 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801713:	83 ec 08             	sub    $0x8,%esp
  801716:	ff 75 0c             	pushl  0xc(%ebp)
  801719:	50                   	push   %eax
  80171a:	ff d2                	call   *%edx
  80171c:	89 c2                	mov    %eax,%edx
  80171e:	83 c4 10             	add    $0x10,%esp
  801721:	eb 09                	jmp    80172c <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801723:	89 c2                	mov    %eax,%edx
  801725:	eb 05                	jmp    80172c <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801727:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  80172c:	89 d0                	mov    %edx,%eax
  80172e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	53                   	push   %ebx
  801737:	83 ec 14             	sub    $0x14,%esp
  80173a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80173d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801740:	50                   	push   %eax
  801741:	ff 75 08             	pushl  0x8(%ebp)
  801744:	e8 6d fb ff ff       	call   8012b6 <fd_lookup>
  801749:	83 c4 08             	add    $0x8,%esp
  80174c:	89 c2                	mov    %eax,%edx
  80174e:	85 c0                	test   %eax,%eax
  801750:	78 58                	js     8017aa <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801752:	83 ec 08             	sub    $0x8,%esp
  801755:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801758:	50                   	push   %eax
  801759:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175c:	ff 30                	pushl  (%eax)
  80175e:	e8 a9 fb ff ff       	call   80130c <dev_lookup>
  801763:	83 c4 10             	add    $0x10,%esp
  801766:	85 c0                	test   %eax,%eax
  801768:	78 37                	js     8017a1 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  80176a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801771:	74 32                	je     8017a5 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801773:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801776:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80177d:	00 00 00 
	stat->st_isdir = 0;
  801780:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801787:	00 00 00 
	stat->st_dev = dev;
  80178a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801790:	83 ec 08             	sub    $0x8,%esp
  801793:	53                   	push   %ebx
  801794:	ff 75 f0             	pushl  -0x10(%ebp)
  801797:	ff 50 14             	call   *0x14(%eax)
  80179a:	89 c2                	mov    %eax,%edx
  80179c:	83 c4 10             	add    $0x10,%esp
  80179f:	eb 09                	jmp    8017aa <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017a1:	89 c2                	mov    %eax,%edx
  8017a3:	eb 05                	jmp    8017aa <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8017a5:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8017aa:	89 d0                	mov    %edx,%eax
  8017ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
  8017b4:	56                   	push   %esi
  8017b5:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017b6:	83 ec 08             	sub    $0x8,%esp
  8017b9:	6a 00                	push   $0x0
  8017bb:	ff 75 08             	pushl  0x8(%ebp)
  8017be:	e8 06 02 00 00       	call   8019c9 <open>
  8017c3:	89 c3                	mov    %eax,%ebx
  8017c5:	83 c4 10             	add    $0x10,%esp
  8017c8:	85 c0                	test   %eax,%eax
  8017ca:	78 1b                	js     8017e7 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8017cc:	83 ec 08             	sub    $0x8,%esp
  8017cf:	ff 75 0c             	pushl  0xc(%ebp)
  8017d2:	50                   	push   %eax
  8017d3:	e8 5b ff ff ff       	call   801733 <fstat>
  8017d8:	89 c6                	mov    %eax,%esi
	close(fd);
  8017da:	89 1c 24             	mov    %ebx,(%esp)
  8017dd:	e8 fd fb ff ff       	call   8013df <close>
	return r;
  8017e2:	83 c4 10             	add    $0x10,%esp
  8017e5:	89 f0                	mov    %esi,%eax
}
  8017e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ea:	5b                   	pop    %ebx
  8017eb:	5e                   	pop    %esi
  8017ec:	5d                   	pop    %ebp
  8017ed:	c3                   	ret    

008017ee <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
  8017f1:	56                   	push   %esi
  8017f2:	53                   	push   %ebx
  8017f3:	89 c6                	mov    %eax,%esi
  8017f5:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017f7:	83 3d ac 40 80 00 00 	cmpl   $0x0,0x8040ac
  8017fe:	75 12                	jne    801812 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801800:	83 ec 0c             	sub    $0xc,%esp
  801803:	6a 01                	push   $0x1
  801805:	e8 01 08 00 00       	call   80200b <ipc_find_env>
  80180a:	a3 ac 40 80 00       	mov    %eax,0x8040ac
  80180f:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801812:	6a 07                	push   $0x7
  801814:	68 00 50 80 00       	push   $0x805000
  801819:	56                   	push   %esi
  80181a:	ff 35 ac 40 80 00    	pushl  0x8040ac
  801820:	e8 92 07 00 00       	call   801fb7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801825:	83 c4 0c             	add    $0xc,%esp
  801828:	6a 00                	push   $0x0
  80182a:	53                   	push   %ebx
  80182b:	6a 00                	push   $0x0
  80182d:	e8 1a 07 00 00       	call   801f4c <ipc_recv>
}
  801832:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801835:	5b                   	pop    %ebx
  801836:	5e                   	pop    %esi
  801837:	5d                   	pop    %ebp
  801838:	c3                   	ret    

00801839 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	8b 40 0c             	mov    0xc(%eax),%eax
  801845:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80184a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801852:	ba 00 00 00 00       	mov    $0x0,%edx
  801857:	b8 02 00 00 00       	mov    $0x2,%eax
  80185c:	e8 8d ff ff ff       	call   8017ee <fsipc>
}
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	8b 40 0c             	mov    0xc(%eax),%eax
  80186f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801874:	ba 00 00 00 00       	mov    $0x0,%edx
  801879:	b8 06 00 00 00       	mov    $0x6,%eax
  80187e:	e8 6b ff ff ff       	call   8017ee <fsipc>
}
  801883:	c9                   	leave  
  801884:	c3                   	ret    

00801885 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	53                   	push   %ebx
  801889:	83 ec 04             	sub    $0x4,%esp
  80188c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80188f:	8b 45 08             	mov    0x8(%ebp),%eax
  801892:	8b 40 0c             	mov    0xc(%eax),%eax
  801895:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80189a:	ba 00 00 00 00       	mov    $0x0,%edx
  80189f:	b8 05 00 00 00       	mov    $0x5,%eax
  8018a4:	e8 45 ff ff ff       	call   8017ee <fsipc>
  8018a9:	85 c0                	test   %eax,%eax
  8018ab:	78 2c                	js     8018d9 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018ad:	83 ec 08             	sub    $0x8,%esp
  8018b0:	68 00 50 80 00       	push   $0x805000
  8018b5:	53                   	push   %ebx
  8018b6:	e8 8b f3 ff ff       	call   800c46 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018bb:	a1 80 50 80 00       	mov    0x805080,%eax
  8018c0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018c6:	a1 84 50 80 00       	mov    0x805084,%eax
  8018cb:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018d1:	83 c4 10             	add    $0x10,%esp
  8018d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

008018de <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	83 ec 08             	sub    $0x8,%esp
  8018e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e7:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018ed:	8b 49 0c             	mov    0xc(%ecx),%ecx
  8018f0:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  8018f6:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8018fb:	76 22                	jbe    80191f <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  8018fd:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  801904:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  801907:	83 ec 04             	sub    $0x4,%esp
  80190a:	68 f8 0f 00 00       	push   $0xff8
  80190f:	52                   	push   %edx
  801910:	68 08 50 80 00       	push   $0x805008
  801915:	e8 bf f4 ff ff       	call   800dd9 <memmove>
  80191a:	83 c4 10             	add    $0x10,%esp
  80191d:	eb 17                	jmp    801936 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  80191f:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  801924:	83 ec 04             	sub    $0x4,%esp
  801927:	50                   	push   %eax
  801928:	52                   	push   %edx
  801929:	68 08 50 80 00       	push   $0x805008
  80192e:	e8 a6 f4 ff ff       	call   800dd9 <memmove>
  801933:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  801936:	ba 00 00 00 00       	mov    $0x0,%edx
  80193b:	b8 04 00 00 00       	mov    $0x4,%eax
  801940:	e8 a9 fe ff ff       	call   8017ee <fsipc>
	if (result < 0)
		return result;

	return result;
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	56                   	push   %esi
  80194b:	53                   	push   %ebx
  80194c:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80194f:	8b 45 08             	mov    0x8(%ebp),%eax
  801952:	8b 40 0c             	mov    0xc(%eax),%eax
  801955:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80195a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801960:	ba 00 00 00 00       	mov    $0x0,%edx
  801965:	b8 03 00 00 00       	mov    $0x3,%eax
  80196a:	e8 7f fe ff ff       	call   8017ee <fsipc>
  80196f:	89 c3                	mov    %eax,%ebx
  801971:	85 c0                	test   %eax,%eax
  801973:	78 4b                	js     8019c0 <devfile_read+0x79>
		return r;
	assert(r <= n);
  801975:	39 c6                	cmp    %eax,%esi
  801977:	73 16                	jae    80198f <devfile_read+0x48>
  801979:	68 94 28 80 00       	push   $0x802894
  80197e:	68 9b 28 80 00       	push   $0x80289b
  801983:	6a 7c                	push   $0x7c
  801985:	68 b0 28 80 00       	push   $0x8028b0
  80198a:	e8 6c ec ff ff       	call   8005fb <_panic>
	assert(r <= PGSIZE);
  80198f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801994:	7e 16                	jle    8019ac <devfile_read+0x65>
  801996:	68 bb 28 80 00       	push   $0x8028bb
  80199b:	68 9b 28 80 00       	push   $0x80289b
  8019a0:	6a 7d                	push   $0x7d
  8019a2:	68 b0 28 80 00       	push   $0x8028b0
  8019a7:	e8 4f ec ff ff       	call   8005fb <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019ac:	83 ec 04             	sub    $0x4,%esp
  8019af:	50                   	push   %eax
  8019b0:	68 00 50 80 00       	push   $0x805000
  8019b5:	ff 75 0c             	pushl  0xc(%ebp)
  8019b8:	e8 1c f4 ff ff       	call   800dd9 <memmove>
	return r;
  8019bd:	83 c4 10             	add    $0x10,%esp
}
  8019c0:	89 d8                	mov    %ebx,%eax
  8019c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019c5:	5b                   	pop    %ebx
  8019c6:	5e                   	pop    %esi
  8019c7:	5d                   	pop    %ebp
  8019c8:	c3                   	ret    

008019c9 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
  8019cc:	53                   	push   %ebx
  8019cd:	83 ec 20             	sub    $0x20,%esp
  8019d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8019d3:	53                   	push   %ebx
  8019d4:	e8 34 f2 ff ff       	call   800c0d <strlen>
  8019d9:	83 c4 10             	add    $0x10,%esp
  8019dc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019e1:	7f 67                	jg     801a4a <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8019e3:	83 ec 0c             	sub    $0xc,%esp
  8019e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019e9:	50                   	push   %eax
  8019ea:	e8 78 f8 ff ff       	call   801267 <fd_alloc>
  8019ef:	83 c4 10             	add    $0x10,%esp
		return r;
  8019f2:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8019f4:	85 c0                	test   %eax,%eax
  8019f6:	78 57                	js     801a4f <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8019f8:	83 ec 08             	sub    $0x8,%esp
  8019fb:	53                   	push   %ebx
  8019fc:	68 00 50 80 00       	push   $0x805000
  801a01:	e8 40 f2 ff ff       	call   800c46 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a09:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a11:	b8 01 00 00 00       	mov    $0x1,%eax
  801a16:	e8 d3 fd ff ff       	call   8017ee <fsipc>
  801a1b:	89 c3                	mov    %eax,%ebx
  801a1d:	83 c4 10             	add    $0x10,%esp
  801a20:	85 c0                	test   %eax,%eax
  801a22:	79 14                	jns    801a38 <open+0x6f>
		fd_close(fd, 0);
  801a24:	83 ec 08             	sub    $0x8,%esp
  801a27:	6a 00                	push   $0x0
  801a29:	ff 75 f4             	pushl  -0xc(%ebp)
  801a2c:	e8 2e f9 ff ff       	call   80135f <fd_close>
		return r;
  801a31:	83 c4 10             	add    $0x10,%esp
  801a34:	89 da                	mov    %ebx,%edx
  801a36:	eb 17                	jmp    801a4f <open+0x86>
	}

	return fd2num(fd);
  801a38:	83 ec 0c             	sub    $0xc,%esp
  801a3b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a3e:	e8 fc f7 ff ff       	call   80123f <fd2num>
  801a43:	89 c2                	mov    %eax,%edx
  801a45:	83 c4 10             	add    $0x10,%esp
  801a48:	eb 05                	jmp    801a4f <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801a4a:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801a4f:	89 d0                	mov    %edx,%eax
  801a51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a5c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a61:	b8 08 00 00 00       	mov    $0x8,%eax
  801a66:	e8 83 fd ff ff       	call   8017ee <fsipc>
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
  801a70:	56                   	push   %esi
  801a71:	53                   	push   %ebx
  801a72:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a75:	83 ec 0c             	sub    $0xc,%esp
  801a78:	ff 75 08             	pushl  0x8(%ebp)
  801a7b:	e8 cf f7 ff ff       	call   80124f <fd2data>
  801a80:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a82:	83 c4 08             	add    $0x8,%esp
  801a85:	68 c7 28 80 00       	push   $0x8028c7
  801a8a:	53                   	push   %ebx
  801a8b:	e8 b6 f1 ff ff       	call   800c46 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a90:	8b 46 04             	mov    0x4(%esi),%eax
  801a93:	2b 06                	sub    (%esi),%eax
  801a95:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a9b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801aa2:	00 00 00 
	stat->st_dev = &devpipe;
  801aa5:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801aac:	30 80 00 
	return 0;
}
  801aaf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ab7:	5b                   	pop    %ebx
  801ab8:	5e                   	pop    %esi
  801ab9:	5d                   	pop    %ebp
  801aba:	c3                   	ret    

00801abb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	53                   	push   %ebx
  801abf:	83 ec 0c             	sub    $0xc,%esp
  801ac2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ac5:	53                   	push   %ebx
  801ac6:	6a 00                	push   $0x0
  801ac8:	e8 0c f6 ff ff       	call   8010d9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801acd:	89 1c 24             	mov    %ebx,(%esp)
  801ad0:	e8 7a f7 ff ff       	call   80124f <fd2data>
  801ad5:	83 c4 08             	add    $0x8,%esp
  801ad8:	50                   	push   %eax
  801ad9:	6a 00                	push   $0x0
  801adb:	e8 f9 f5 ff ff       	call   8010d9 <sys_page_unmap>
}
  801ae0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	57                   	push   %edi
  801ae9:	56                   	push   %esi
  801aea:	53                   	push   %ebx
  801aeb:	83 ec 1c             	sub    $0x1c,%esp
  801aee:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801af1:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801af3:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  801af8:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801afb:	83 ec 0c             	sub    $0xc,%esp
  801afe:	ff 75 e0             	pushl  -0x20(%ebp)
  801b01:	e8 3e 05 00 00       	call   802044 <pageref>
  801b06:	89 c3                	mov    %eax,%ebx
  801b08:	89 3c 24             	mov    %edi,(%esp)
  801b0b:	e8 34 05 00 00       	call   802044 <pageref>
  801b10:	83 c4 10             	add    $0x10,%esp
  801b13:	39 c3                	cmp    %eax,%ebx
  801b15:	0f 94 c1             	sete   %cl
  801b18:	0f b6 c9             	movzbl %cl,%ecx
  801b1b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801b1e:	8b 15 b0 40 80 00    	mov    0x8040b0,%edx
  801b24:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b27:	39 ce                	cmp    %ecx,%esi
  801b29:	74 1b                	je     801b46 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801b2b:	39 c3                	cmp    %eax,%ebx
  801b2d:	75 c4                	jne    801af3 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b2f:	8b 42 58             	mov    0x58(%edx),%eax
  801b32:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b35:	50                   	push   %eax
  801b36:	56                   	push   %esi
  801b37:	68 ce 28 80 00       	push   $0x8028ce
  801b3c:	e8 93 eb ff ff       	call   8006d4 <cprintf>
  801b41:	83 c4 10             	add    $0x10,%esp
  801b44:	eb ad                	jmp    801af3 <_pipeisclosed+0xe>
	}
}
  801b46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b4c:	5b                   	pop    %ebx
  801b4d:	5e                   	pop    %esi
  801b4e:	5f                   	pop    %edi
  801b4f:	5d                   	pop    %ebp
  801b50:	c3                   	ret    

00801b51 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
  801b54:	57                   	push   %edi
  801b55:	56                   	push   %esi
  801b56:	53                   	push   %ebx
  801b57:	83 ec 28             	sub    $0x28,%esp
  801b5a:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801b5d:	56                   	push   %esi
  801b5e:	e8 ec f6 ff ff       	call   80124f <fd2data>
  801b63:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b65:	83 c4 10             	add    $0x10,%esp
  801b68:	bf 00 00 00 00       	mov    $0x0,%edi
  801b6d:	eb 4b                	jmp    801bba <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801b6f:	89 da                	mov    %ebx,%edx
  801b71:	89 f0                	mov    %esi,%eax
  801b73:	e8 6d ff ff ff       	call   801ae5 <_pipeisclosed>
  801b78:	85 c0                	test   %eax,%eax
  801b7a:	75 48                	jne    801bc4 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801b7c:	e8 e7 f4 ff ff       	call   801068 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b81:	8b 43 04             	mov    0x4(%ebx),%eax
  801b84:	8b 0b                	mov    (%ebx),%ecx
  801b86:	8d 51 20             	lea    0x20(%ecx),%edx
  801b89:	39 d0                	cmp    %edx,%eax
  801b8b:	73 e2                	jae    801b6f <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b90:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b94:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b97:	89 c2                	mov    %eax,%edx
  801b99:	c1 fa 1f             	sar    $0x1f,%edx
  801b9c:	89 d1                	mov    %edx,%ecx
  801b9e:	c1 e9 1b             	shr    $0x1b,%ecx
  801ba1:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ba4:	83 e2 1f             	and    $0x1f,%edx
  801ba7:	29 ca                	sub    %ecx,%edx
  801ba9:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801bad:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801bb1:	83 c0 01             	add    $0x1,%eax
  801bb4:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801bb7:	83 c7 01             	add    $0x1,%edi
  801bba:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bbd:	75 c2                	jne    801b81 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801bbf:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc2:	eb 05                	jmp    801bc9 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801bc4:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801bc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bcc:	5b                   	pop    %ebx
  801bcd:	5e                   	pop    %esi
  801bce:	5f                   	pop    %edi
  801bcf:	5d                   	pop    %ebp
  801bd0:	c3                   	ret    

00801bd1 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	57                   	push   %edi
  801bd5:	56                   	push   %esi
  801bd6:	53                   	push   %ebx
  801bd7:	83 ec 18             	sub    $0x18,%esp
  801bda:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801bdd:	57                   	push   %edi
  801bde:	e8 6c f6 ff ff       	call   80124f <fd2data>
  801be3:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801be5:	83 c4 10             	add    $0x10,%esp
  801be8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bed:	eb 3d                	jmp    801c2c <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801bef:	85 db                	test   %ebx,%ebx
  801bf1:	74 04                	je     801bf7 <devpipe_read+0x26>
				return i;
  801bf3:	89 d8                	mov    %ebx,%eax
  801bf5:	eb 44                	jmp    801c3b <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801bf7:	89 f2                	mov    %esi,%edx
  801bf9:	89 f8                	mov    %edi,%eax
  801bfb:	e8 e5 fe ff ff       	call   801ae5 <_pipeisclosed>
  801c00:	85 c0                	test   %eax,%eax
  801c02:	75 32                	jne    801c36 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801c04:	e8 5f f4 ff ff       	call   801068 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801c09:	8b 06                	mov    (%esi),%eax
  801c0b:	3b 46 04             	cmp    0x4(%esi),%eax
  801c0e:	74 df                	je     801bef <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c10:	99                   	cltd   
  801c11:	c1 ea 1b             	shr    $0x1b,%edx
  801c14:	01 d0                	add    %edx,%eax
  801c16:	83 e0 1f             	and    $0x1f,%eax
  801c19:	29 d0                	sub    %edx,%eax
  801c1b:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801c20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c23:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801c26:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c29:	83 c3 01             	add    $0x1,%ebx
  801c2c:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801c2f:	75 d8                	jne    801c09 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801c31:	8b 45 10             	mov    0x10(%ebp),%eax
  801c34:	eb 05                	jmp    801c3b <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801c36:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801c3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c3e:	5b                   	pop    %ebx
  801c3f:	5e                   	pop    %esi
  801c40:	5f                   	pop    %edi
  801c41:	5d                   	pop    %ebp
  801c42:	c3                   	ret    

00801c43 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	56                   	push   %esi
  801c47:	53                   	push   %ebx
  801c48:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801c4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c4e:	50                   	push   %eax
  801c4f:	e8 13 f6 ff ff       	call   801267 <fd_alloc>
  801c54:	83 c4 10             	add    $0x10,%esp
  801c57:	89 c2                	mov    %eax,%edx
  801c59:	85 c0                	test   %eax,%eax
  801c5b:	0f 88 2c 01 00 00    	js     801d8d <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c61:	83 ec 04             	sub    $0x4,%esp
  801c64:	68 07 04 00 00       	push   $0x407
  801c69:	ff 75 f4             	pushl  -0xc(%ebp)
  801c6c:	6a 00                	push   $0x0
  801c6e:	e8 1c f4 ff ff       	call   80108f <sys_page_alloc>
  801c73:	83 c4 10             	add    $0x10,%esp
  801c76:	89 c2                	mov    %eax,%edx
  801c78:	85 c0                	test   %eax,%eax
  801c7a:	0f 88 0d 01 00 00    	js     801d8d <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801c80:	83 ec 0c             	sub    $0xc,%esp
  801c83:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c86:	50                   	push   %eax
  801c87:	e8 db f5 ff ff       	call   801267 <fd_alloc>
  801c8c:	89 c3                	mov    %eax,%ebx
  801c8e:	83 c4 10             	add    $0x10,%esp
  801c91:	85 c0                	test   %eax,%eax
  801c93:	0f 88 e2 00 00 00    	js     801d7b <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c99:	83 ec 04             	sub    $0x4,%esp
  801c9c:	68 07 04 00 00       	push   $0x407
  801ca1:	ff 75 f0             	pushl  -0x10(%ebp)
  801ca4:	6a 00                	push   $0x0
  801ca6:	e8 e4 f3 ff ff       	call   80108f <sys_page_alloc>
  801cab:	89 c3                	mov    %eax,%ebx
  801cad:	83 c4 10             	add    $0x10,%esp
  801cb0:	85 c0                	test   %eax,%eax
  801cb2:	0f 88 c3 00 00 00    	js     801d7b <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801cb8:	83 ec 0c             	sub    $0xc,%esp
  801cbb:	ff 75 f4             	pushl  -0xc(%ebp)
  801cbe:	e8 8c f5 ff ff       	call   80124f <fd2data>
  801cc3:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cc5:	83 c4 0c             	add    $0xc,%esp
  801cc8:	68 07 04 00 00       	push   $0x407
  801ccd:	50                   	push   %eax
  801cce:	6a 00                	push   $0x0
  801cd0:	e8 ba f3 ff ff       	call   80108f <sys_page_alloc>
  801cd5:	89 c3                	mov    %eax,%ebx
  801cd7:	83 c4 10             	add    $0x10,%esp
  801cda:	85 c0                	test   %eax,%eax
  801cdc:	0f 88 89 00 00 00    	js     801d6b <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ce2:	83 ec 0c             	sub    $0xc,%esp
  801ce5:	ff 75 f0             	pushl  -0x10(%ebp)
  801ce8:	e8 62 f5 ff ff       	call   80124f <fd2data>
  801ced:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801cf4:	50                   	push   %eax
  801cf5:	6a 00                	push   $0x0
  801cf7:	56                   	push   %esi
  801cf8:	6a 00                	push   $0x0
  801cfa:	e8 b4 f3 ff ff       	call   8010b3 <sys_page_map>
  801cff:	89 c3                	mov    %eax,%ebx
  801d01:	83 c4 20             	add    $0x20,%esp
  801d04:	85 c0                	test   %eax,%eax
  801d06:	78 55                	js     801d5d <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801d08:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d11:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d16:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801d1d:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d26:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d2b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801d32:	83 ec 0c             	sub    $0xc,%esp
  801d35:	ff 75 f4             	pushl  -0xc(%ebp)
  801d38:	e8 02 f5 ff ff       	call   80123f <fd2num>
  801d3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d40:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d42:	83 c4 04             	add    $0x4,%esp
  801d45:	ff 75 f0             	pushl  -0x10(%ebp)
  801d48:	e8 f2 f4 ff ff       	call   80123f <fd2num>
  801d4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d50:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d53:	83 c4 10             	add    $0x10,%esp
  801d56:	ba 00 00 00 00       	mov    $0x0,%edx
  801d5b:	eb 30                	jmp    801d8d <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801d5d:	83 ec 08             	sub    $0x8,%esp
  801d60:	56                   	push   %esi
  801d61:	6a 00                	push   $0x0
  801d63:	e8 71 f3 ff ff       	call   8010d9 <sys_page_unmap>
  801d68:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801d6b:	83 ec 08             	sub    $0x8,%esp
  801d6e:	ff 75 f0             	pushl  -0x10(%ebp)
  801d71:	6a 00                	push   $0x0
  801d73:	e8 61 f3 ff ff       	call   8010d9 <sys_page_unmap>
  801d78:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801d7b:	83 ec 08             	sub    $0x8,%esp
  801d7e:	ff 75 f4             	pushl  -0xc(%ebp)
  801d81:	6a 00                	push   $0x0
  801d83:	e8 51 f3 ff ff       	call   8010d9 <sys_page_unmap>
  801d88:	83 c4 10             	add    $0x10,%esp
  801d8b:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  801d8d:	89 d0                	mov    %edx,%eax
  801d8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d92:	5b                   	pop    %ebx
  801d93:	5e                   	pop    %esi
  801d94:	5d                   	pop    %ebp
  801d95:	c3                   	ret    

00801d96 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d9c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d9f:	50                   	push   %eax
  801da0:	ff 75 08             	pushl  0x8(%ebp)
  801da3:	e8 0e f5 ff ff       	call   8012b6 <fd_lookup>
  801da8:	83 c4 10             	add    $0x10,%esp
  801dab:	85 c0                	test   %eax,%eax
  801dad:	78 18                	js     801dc7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801daf:	83 ec 0c             	sub    $0xc,%esp
  801db2:	ff 75 f4             	pushl  -0xc(%ebp)
  801db5:	e8 95 f4 ff ff       	call   80124f <fd2data>
	return _pipeisclosed(fd, p);
  801dba:	89 c2                	mov    %eax,%edx
  801dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbf:	e8 21 fd ff ff       	call   801ae5 <_pipeisclosed>
  801dc4:	83 c4 10             	add    $0x10,%esp
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801dcc:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd1:	5d                   	pop    %ebp
  801dd2:	c3                   	ret    

00801dd3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801dd9:	68 e6 28 80 00       	push   $0x8028e6
  801dde:	ff 75 0c             	pushl  0xc(%ebp)
  801de1:	e8 60 ee ff ff       	call   800c46 <strcpy>
	return 0;
}
  801de6:	b8 00 00 00 00       	mov    $0x0,%eax
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	57                   	push   %edi
  801df1:	56                   	push   %esi
  801df2:	53                   	push   %ebx
  801df3:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801df9:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801dfe:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e04:	eb 2d                	jmp    801e33 <devcons_write+0x46>
		m = n - tot;
  801e06:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e09:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801e0b:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801e0e:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801e13:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801e16:	83 ec 04             	sub    $0x4,%esp
  801e19:	53                   	push   %ebx
  801e1a:	03 45 0c             	add    0xc(%ebp),%eax
  801e1d:	50                   	push   %eax
  801e1e:	57                   	push   %edi
  801e1f:	e8 b5 ef ff ff       	call   800dd9 <memmove>
		sys_cputs(buf, m);
  801e24:	83 c4 08             	add    $0x8,%esp
  801e27:	53                   	push   %ebx
  801e28:	57                   	push   %edi
  801e29:	e8 aa f1 ff ff       	call   800fd8 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e2e:	01 de                	add    %ebx,%esi
  801e30:	83 c4 10             	add    $0x10,%esp
  801e33:	89 f0                	mov    %esi,%eax
  801e35:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e38:	72 cc                	jb     801e06 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801e3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e3d:	5b                   	pop    %ebx
  801e3e:	5e                   	pop    %esi
  801e3f:	5f                   	pop    %edi
  801e40:	5d                   	pop    %ebp
  801e41:	c3                   	ret    

00801e42 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
  801e45:	83 ec 08             	sub    $0x8,%esp
  801e48:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801e4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e51:	74 2a                	je     801e7d <devcons_read+0x3b>
  801e53:	eb 05                	jmp    801e5a <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801e55:	e8 0e f2 ff ff       	call   801068 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801e5a:	e8 9f f1 ff ff       	call   800ffe <sys_cgetc>
  801e5f:	85 c0                	test   %eax,%eax
  801e61:	74 f2                	je     801e55 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801e63:	85 c0                	test   %eax,%eax
  801e65:	78 16                	js     801e7d <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801e67:	83 f8 04             	cmp    $0x4,%eax
  801e6a:	74 0c                	je     801e78 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801e6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e6f:	88 02                	mov    %al,(%edx)
	return 1;
  801e71:	b8 01 00 00 00       	mov    $0x1,%eax
  801e76:	eb 05                	jmp    801e7d <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801e78:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e85:	8b 45 08             	mov    0x8(%ebp),%eax
  801e88:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801e8b:	6a 01                	push   $0x1
  801e8d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e90:	50                   	push   %eax
  801e91:	e8 42 f1 ff ff       	call   800fd8 <sys_cputs>
}
  801e96:	83 c4 10             	add    $0x10,%esp
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <getchar>:

int
getchar(void)
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801ea1:	6a 01                	push   $0x1
  801ea3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ea6:	50                   	push   %eax
  801ea7:	6a 00                	push   $0x0
  801ea9:	e8 6d f6 ff ff       	call   80151b <read>
	if (r < 0)
  801eae:	83 c4 10             	add    $0x10,%esp
  801eb1:	85 c0                	test   %eax,%eax
  801eb3:	78 0f                	js     801ec4 <getchar+0x29>
		return r;
	if (r < 1)
  801eb5:	85 c0                	test   %eax,%eax
  801eb7:	7e 06                	jle    801ebf <getchar+0x24>
		return -E_EOF;
	return c;
  801eb9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801ebd:	eb 05                	jmp    801ec4 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801ebf:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ecc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ecf:	50                   	push   %eax
  801ed0:	ff 75 08             	pushl  0x8(%ebp)
  801ed3:	e8 de f3 ff ff       	call   8012b6 <fd_lookup>
  801ed8:	83 c4 10             	add    $0x10,%esp
  801edb:	85 c0                	test   %eax,%eax
  801edd:	78 11                	js     801ef0 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ee8:	39 10                	cmp    %edx,(%eax)
  801eea:	0f 94 c0             	sete   %al
  801eed:	0f b6 c0             	movzbl %al,%eax
}
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    

00801ef2 <opencons>:

int
opencons(void)
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801ef8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801efb:	50                   	push   %eax
  801efc:	e8 66 f3 ff ff       	call   801267 <fd_alloc>
  801f01:	83 c4 10             	add    $0x10,%esp
		return r;
  801f04:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801f06:	85 c0                	test   %eax,%eax
  801f08:	78 3e                	js     801f48 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f0a:	83 ec 04             	sub    $0x4,%esp
  801f0d:	68 07 04 00 00       	push   $0x407
  801f12:	ff 75 f4             	pushl  -0xc(%ebp)
  801f15:	6a 00                	push   $0x0
  801f17:	e8 73 f1 ff ff       	call   80108f <sys_page_alloc>
  801f1c:	83 c4 10             	add    $0x10,%esp
		return r;
  801f1f:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f21:	85 c0                	test   %eax,%eax
  801f23:	78 23                	js     801f48 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801f25:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f33:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f3a:	83 ec 0c             	sub    $0xc,%esp
  801f3d:	50                   	push   %eax
  801f3e:	e8 fc f2 ff ff       	call   80123f <fd2num>
  801f43:	89 c2                	mov    %eax,%edx
  801f45:	83 c4 10             	add    $0x10,%esp
}
  801f48:	89 d0                	mov    %edx,%eax
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
  801f4f:	56                   	push   %esi
  801f50:	53                   	push   %ebx
  801f51:	8b 75 08             	mov    0x8(%ebp),%esi
  801f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f57:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801f5a:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801f5c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801f61:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801f64:	83 ec 0c             	sub    $0xc,%esp
  801f67:	50                   	push   %eax
  801f68:	e8 1d f2 ff ff       	call   80118a <sys_ipc_recv>
	if (from_env_store)
  801f6d:	83 c4 10             	add    $0x10,%esp
  801f70:	85 f6                	test   %esi,%esi
  801f72:	74 0b                	je     801f7f <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801f74:	8b 15 b0 40 80 00    	mov    0x8040b0,%edx
  801f7a:	8b 52 74             	mov    0x74(%edx),%edx
  801f7d:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801f7f:	85 db                	test   %ebx,%ebx
  801f81:	74 0b                	je     801f8e <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  801f83:	8b 15 b0 40 80 00    	mov    0x8040b0,%edx
  801f89:	8b 52 78             	mov    0x78(%edx),%edx
  801f8c:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  801f8e:	85 c0                	test   %eax,%eax
  801f90:	79 16                	jns    801fa8 <ipc_recv+0x5c>
		if (from_env_store)
  801f92:	85 f6                	test   %esi,%esi
  801f94:	74 06                	je     801f9c <ipc_recv+0x50>
			*from_env_store = 0;
  801f96:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  801f9c:	85 db                	test   %ebx,%ebx
  801f9e:	74 10                	je     801fb0 <ipc_recv+0x64>
			*perm_store = 0;
  801fa0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801fa6:	eb 08                	jmp    801fb0 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  801fa8:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  801fad:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fb3:	5b                   	pop    %ebx
  801fb4:	5e                   	pop    %esi
  801fb5:	5d                   	pop    %ebp
  801fb6:	c3                   	ret    

00801fb7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
  801fba:	57                   	push   %edi
  801fbb:	56                   	push   %esi
  801fbc:	53                   	push   %ebx
  801fbd:	83 ec 0c             	sub    $0xc,%esp
  801fc0:	8b 7d 08             	mov    0x8(%ebp),%edi
  801fc3:	8b 75 0c             	mov    0xc(%ebp),%esi
  801fc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  801fc9:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  801fcb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801fd0:	0f 44 d8             	cmove  %eax,%ebx
  801fd3:	eb 1c                	jmp    801ff1 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  801fd5:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801fd8:	74 12                	je     801fec <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801fda:	50                   	push   %eax
  801fdb:	68 f2 28 80 00       	push   $0x8028f2
  801fe0:	6a 42                	push   $0x42
  801fe2:	68 08 29 80 00       	push   $0x802908
  801fe7:	e8 0f e6 ff ff       	call   8005fb <_panic>
		sys_yield();
  801fec:	e8 77 f0 ff ff       	call   801068 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801ff1:	ff 75 14             	pushl  0x14(%ebp)
  801ff4:	53                   	push   %ebx
  801ff5:	56                   	push   %esi
  801ff6:	57                   	push   %edi
  801ff7:	e8 69 f1 ff ff       	call   801165 <sys_ipc_try_send>
  801ffc:	83 c4 10             	add    $0x10,%esp
  801fff:	85 c0                	test   %eax,%eax
  802001:	75 d2                	jne    801fd5 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  802003:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802006:	5b                   	pop    %ebx
  802007:	5e                   	pop    %esi
  802008:	5f                   	pop    %edi
  802009:	5d                   	pop    %ebp
  80200a:	c3                   	ret    

0080200b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
  80200e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802011:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802016:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802019:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80201f:	8b 52 50             	mov    0x50(%edx),%edx
  802022:	39 ca                	cmp    %ecx,%edx
  802024:	75 0d                	jne    802033 <ipc_find_env+0x28>
			return envs[i].env_id;
  802026:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802029:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80202e:	8b 40 48             	mov    0x48(%eax),%eax
  802031:	eb 0f                	jmp    802042 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802033:	83 c0 01             	add    $0x1,%eax
  802036:	3d 00 04 00 00       	cmp    $0x400,%eax
  80203b:	75 d9                	jne    802016 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80203d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802042:	5d                   	pop    %ebp
  802043:	c3                   	ret    

00802044 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80204a:	89 d0                	mov    %edx,%eax
  80204c:	c1 e8 16             	shr    $0x16,%eax
  80204f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802056:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80205b:	f6 c1 01             	test   $0x1,%cl
  80205e:	74 1d                	je     80207d <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802060:	c1 ea 0c             	shr    $0xc,%edx
  802063:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80206a:	f6 c2 01             	test   $0x1,%dl
  80206d:	74 0e                	je     80207d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80206f:	c1 ea 0c             	shr    $0xc,%edx
  802072:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802079:	ef 
  80207a:	0f b7 c0             	movzwl %ax,%eax
}
  80207d:	5d                   	pop    %ebp
  80207e:	c3                   	ret    
  80207f:	90                   	nop

00802080 <__udivdi3>:
  802080:	55                   	push   %ebp
  802081:	57                   	push   %edi
  802082:	56                   	push   %esi
  802083:	53                   	push   %ebx
  802084:	83 ec 1c             	sub    $0x1c,%esp
  802087:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80208b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80208f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802093:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802097:	85 f6                	test   %esi,%esi
  802099:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80209d:	89 ca                	mov    %ecx,%edx
  80209f:	89 f8                	mov    %edi,%eax
  8020a1:	75 3d                	jne    8020e0 <__udivdi3+0x60>
  8020a3:	39 cf                	cmp    %ecx,%edi
  8020a5:	0f 87 c5 00 00 00    	ja     802170 <__udivdi3+0xf0>
  8020ab:	85 ff                	test   %edi,%edi
  8020ad:	89 fd                	mov    %edi,%ebp
  8020af:	75 0b                	jne    8020bc <__udivdi3+0x3c>
  8020b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b6:	31 d2                	xor    %edx,%edx
  8020b8:	f7 f7                	div    %edi
  8020ba:	89 c5                	mov    %eax,%ebp
  8020bc:	89 c8                	mov    %ecx,%eax
  8020be:	31 d2                	xor    %edx,%edx
  8020c0:	f7 f5                	div    %ebp
  8020c2:	89 c1                	mov    %eax,%ecx
  8020c4:	89 d8                	mov    %ebx,%eax
  8020c6:	89 cf                	mov    %ecx,%edi
  8020c8:	f7 f5                	div    %ebp
  8020ca:	89 c3                	mov    %eax,%ebx
  8020cc:	89 d8                	mov    %ebx,%eax
  8020ce:	89 fa                	mov    %edi,%edx
  8020d0:	83 c4 1c             	add    $0x1c,%esp
  8020d3:	5b                   	pop    %ebx
  8020d4:	5e                   	pop    %esi
  8020d5:	5f                   	pop    %edi
  8020d6:	5d                   	pop    %ebp
  8020d7:	c3                   	ret    
  8020d8:	90                   	nop
  8020d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020e0:	39 ce                	cmp    %ecx,%esi
  8020e2:	77 74                	ja     802158 <__udivdi3+0xd8>
  8020e4:	0f bd fe             	bsr    %esi,%edi
  8020e7:	83 f7 1f             	xor    $0x1f,%edi
  8020ea:	0f 84 98 00 00 00    	je     802188 <__udivdi3+0x108>
  8020f0:	bb 20 00 00 00       	mov    $0x20,%ebx
  8020f5:	89 f9                	mov    %edi,%ecx
  8020f7:	89 c5                	mov    %eax,%ebp
  8020f9:	29 fb                	sub    %edi,%ebx
  8020fb:	d3 e6                	shl    %cl,%esi
  8020fd:	89 d9                	mov    %ebx,%ecx
  8020ff:	d3 ed                	shr    %cl,%ebp
  802101:	89 f9                	mov    %edi,%ecx
  802103:	d3 e0                	shl    %cl,%eax
  802105:	09 ee                	or     %ebp,%esi
  802107:	89 d9                	mov    %ebx,%ecx
  802109:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80210d:	89 d5                	mov    %edx,%ebp
  80210f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802113:	d3 ed                	shr    %cl,%ebp
  802115:	89 f9                	mov    %edi,%ecx
  802117:	d3 e2                	shl    %cl,%edx
  802119:	89 d9                	mov    %ebx,%ecx
  80211b:	d3 e8                	shr    %cl,%eax
  80211d:	09 c2                	or     %eax,%edx
  80211f:	89 d0                	mov    %edx,%eax
  802121:	89 ea                	mov    %ebp,%edx
  802123:	f7 f6                	div    %esi
  802125:	89 d5                	mov    %edx,%ebp
  802127:	89 c3                	mov    %eax,%ebx
  802129:	f7 64 24 0c          	mull   0xc(%esp)
  80212d:	39 d5                	cmp    %edx,%ebp
  80212f:	72 10                	jb     802141 <__udivdi3+0xc1>
  802131:	8b 74 24 08          	mov    0x8(%esp),%esi
  802135:	89 f9                	mov    %edi,%ecx
  802137:	d3 e6                	shl    %cl,%esi
  802139:	39 c6                	cmp    %eax,%esi
  80213b:	73 07                	jae    802144 <__udivdi3+0xc4>
  80213d:	39 d5                	cmp    %edx,%ebp
  80213f:	75 03                	jne    802144 <__udivdi3+0xc4>
  802141:	83 eb 01             	sub    $0x1,%ebx
  802144:	31 ff                	xor    %edi,%edi
  802146:	89 d8                	mov    %ebx,%eax
  802148:	89 fa                	mov    %edi,%edx
  80214a:	83 c4 1c             	add    $0x1c,%esp
  80214d:	5b                   	pop    %ebx
  80214e:	5e                   	pop    %esi
  80214f:	5f                   	pop    %edi
  802150:	5d                   	pop    %ebp
  802151:	c3                   	ret    
  802152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802158:	31 ff                	xor    %edi,%edi
  80215a:	31 db                	xor    %ebx,%ebx
  80215c:	89 d8                	mov    %ebx,%eax
  80215e:	89 fa                	mov    %edi,%edx
  802160:	83 c4 1c             	add    $0x1c,%esp
  802163:	5b                   	pop    %ebx
  802164:	5e                   	pop    %esi
  802165:	5f                   	pop    %edi
  802166:	5d                   	pop    %ebp
  802167:	c3                   	ret    
  802168:	90                   	nop
  802169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802170:	89 d8                	mov    %ebx,%eax
  802172:	f7 f7                	div    %edi
  802174:	31 ff                	xor    %edi,%edi
  802176:	89 c3                	mov    %eax,%ebx
  802178:	89 d8                	mov    %ebx,%eax
  80217a:	89 fa                	mov    %edi,%edx
  80217c:	83 c4 1c             	add    $0x1c,%esp
  80217f:	5b                   	pop    %ebx
  802180:	5e                   	pop    %esi
  802181:	5f                   	pop    %edi
  802182:	5d                   	pop    %ebp
  802183:	c3                   	ret    
  802184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802188:	39 ce                	cmp    %ecx,%esi
  80218a:	72 0c                	jb     802198 <__udivdi3+0x118>
  80218c:	31 db                	xor    %ebx,%ebx
  80218e:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802192:	0f 87 34 ff ff ff    	ja     8020cc <__udivdi3+0x4c>
  802198:	bb 01 00 00 00       	mov    $0x1,%ebx
  80219d:	e9 2a ff ff ff       	jmp    8020cc <__udivdi3+0x4c>
  8021a2:	66 90                	xchg   %ax,%ax
  8021a4:	66 90                	xchg   %ax,%ax
  8021a6:	66 90                	xchg   %ax,%ax
  8021a8:	66 90                	xchg   %ax,%ax
  8021aa:	66 90                	xchg   %ax,%ax
  8021ac:	66 90                	xchg   %ax,%ax
  8021ae:	66 90                	xchg   %ax,%ax

008021b0 <__umoddi3>:
  8021b0:	55                   	push   %ebp
  8021b1:	57                   	push   %edi
  8021b2:	56                   	push   %esi
  8021b3:	53                   	push   %ebx
  8021b4:	83 ec 1c             	sub    $0x1c,%esp
  8021b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8021bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021c7:	85 d2                	test   %edx,%edx
  8021c9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8021cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021d1:	89 f3                	mov    %esi,%ebx
  8021d3:	89 3c 24             	mov    %edi,(%esp)
  8021d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021da:	75 1c                	jne    8021f8 <__umoddi3+0x48>
  8021dc:	39 f7                	cmp    %esi,%edi
  8021de:	76 50                	jbe    802230 <__umoddi3+0x80>
  8021e0:	89 c8                	mov    %ecx,%eax
  8021e2:	89 f2                	mov    %esi,%edx
  8021e4:	f7 f7                	div    %edi
  8021e6:	89 d0                	mov    %edx,%eax
  8021e8:	31 d2                	xor    %edx,%edx
  8021ea:	83 c4 1c             	add    $0x1c,%esp
  8021ed:	5b                   	pop    %ebx
  8021ee:	5e                   	pop    %esi
  8021ef:	5f                   	pop    %edi
  8021f0:	5d                   	pop    %ebp
  8021f1:	c3                   	ret    
  8021f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021f8:	39 f2                	cmp    %esi,%edx
  8021fa:	89 d0                	mov    %edx,%eax
  8021fc:	77 52                	ja     802250 <__umoddi3+0xa0>
  8021fe:	0f bd ea             	bsr    %edx,%ebp
  802201:	83 f5 1f             	xor    $0x1f,%ebp
  802204:	75 5a                	jne    802260 <__umoddi3+0xb0>
  802206:	3b 54 24 04          	cmp    0x4(%esp),%edx
  80220a:	0f 82 e0 00 00 00    	jb     8022f0 <__umoddi3+0x140>
  802210:	39 0c 24             	cmp    %ecx,(%esp)
  802213:	0f 86 d7 00 00 00    	jbe    8022f0 <__umoddi3+0x140>
  802219:	8b 44 24 08          	mov    0x8(%esp),%eax
  80221d:	8b 54 24 04          	mov    0x4(%esp),%edx
  802221:	83 c4 1c             	add    $0x1c,%esp
  802224:	5b                   	pop    %ebx
  802225:	5e                   	pop    %esi
  802226:	5f                   	pop    %edi
  802227:	5d                   	pop    %ebp
  802228:	c3                   	ret    
  802229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802230:	85 ff                	test   %edi,%edi
  802232:	89 fd                	mov    %edi,%ebp
  802234:	75 0b                	jne    802241 <__umoddi3+0x91>
  802236:	b8 01 00 00 00       	mov    $0x1,%eax
  80223b:	31 d2                	xor    %edx,%edx
  80223d:	f7 f7                	div    %edi
  80223f:	89 c5                	mov    %eax,%ebp
  802241:	89 f0                	mov    %esi,%eax
  802243:	31 d2                	xor    %edx,%edx
  802245:	f7 f5                	div    %ebp
  802247:	89 c8                	mov    %ecx,%eax
  802249:	f7 f5                	div    %ebp
  80224b:	89 d0                	mov    %edx,%eax
  80224d:	eb 99                	jmp    8021e8 <__umoddi3+0x38>
  80224f:	90                   	nop
  802250:	89 c8                	mov    %ecx,%eax
  802252:	89 f2                	mov    %esi,%edx
  802254:	83 c4 1c             	add    $0x1c,%esp
  802257:	5b                   	pop    %ebx
  802258:	5e                   	pop    %esi
  802259:	5f                   	pop    %edi
  80225a:	5d                   	pop    %ebp
  80225b:	c3                   	ret    
  80225c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802260:	8b 34 24             	mov    (%esp),%esi
  802263:	bf 20 00 00 00       	mov    $0x20,%edi
  802268:	89 e9                	mov    %ebp,%ecx
  80226a:	29 ef                	sub    %ebp,%edi
  80226c:	d3 e0                	shl    %cl,%eax
  80226e:	89 f9                	mov    %edi,%ecx
  802270:	89 f2                	mov    %esi,%edx
  802272:	d3 ea                	shr    %cl,%edx
  802274:	89 e9                	mov    %ebp,%ecx
  802276:	09 c2                	or     %eax,%edx
  802278:	89 d8                	mov    %ebx,%eax
  80227a:	89 14 24             	mov    %edx,(%esp)
  80227d:	89 f2                	mov    %esi,%edx
  80227f:	d3 e2                	shl    %cl,%edx
  802281:	89 f9                	mov    %edi,%ecx
  802283:	89 54 24 04          	mov    %edx,0x4(%esp)
  802287:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80228b:	d3 e8                	shr    %cl,%eax
  80228d:	89 e9                	mov    %ebp,%ecx
  80228f:	89 c6                	mov    %eax,%esi
  802291:	d3 e3                	shl    %cl,%ebx
  802293:	89 f9                	mov    %edi,%ecx
  802295:	89 d0                	mov    %edx,%eax
  802297:	d3 e8                	shr    %cl,%eax
  802299:	89 e9                	mov    %ebp,%ecx
  80229b:	09 d8                	or     %ebx,%eax
  80229d:	89 d3                	mov    %edx,%ebx
  80229f:	89 f2                	mov    %esi,%edx
  8022a1:	f7 34 24             	divl   (%esp)
  8022a4:	89 d6                	mov    %edx,%esi
  8022a6:	d3 e3                	shl    %cl,%ebx
  8022a8:	f7 64 24 04          	mull   0x4(%esp)
  8022ac:	39 d6                	cmp    %edx,%esi
  8022ae:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022b2:	89 d1                	mov    %edx,%ecx
  8022b4:	89 c3                	mov    %eax,%ebx
  8022b6:	72 08                	jb     8022c0 <__umoddi3+0x110>
  8022b8:	75 11                	jne    8022cb <__umoddi3+0x11b>
  8022ba:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8022be:	73 0b                	jae    8022cb <__umoddi3+0x11b>
  8022c0:	2b 44 24 04          	sub    0x4(%esp),%eax
  8022c4:	1b 14 24             	sbb    (%esp),%edx
  8022c7:	89 d1                	mov    %edx,%ecx
  8022c9:	89 c3                	mov    %eax,%ebx
  8022cb:	8b 54 24 08          	mov    0x8(%esp),%edx
  8022cf:	29 da                	sub    %ebx,%edx
  8022d1:	19 ce                	sbb    %ecx,%esi
  8022d3:	89 f9                	mov    %edi,%ecx
  8022d5:	89 f0                	mov    %esi,%eax
  8022d7:	d3 e0                	shl    %cl,%eax
  8022d9:	89 e9                	mov    %ebp,%ecx
  8022db:	d3 ea                	shr    %cl,%edx
  8022dd:	89 e9                	mov    %ebp,%ecx
  8022df:	d3 ee                	shr    %cl,%esi
  8022e1:	09 d0                	or     %edx,%eax
  8022e3:	89 f2                	mov    %esi,%edx
  8022e5:	83 c4 1c             	add    $0x1c,%esp
  8022e8:	5b                   	pop    %ebx
  8022e9:	5e                   	pop    %esi
  8022ea:	5f                   	pop    %edi
  8022eb:	5d                   	pop    %ebp
  8022ec:	c3                   	ret    
  8022ed:	8d 76 00             	lea    0x0(%esi),%esi
  8022f0:	29 f9                	sub    %edi,%ecx
  8022f2:	19 d6                	sbb    %edx,%esi
  8022f4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022f8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022fc:	e9 18 ff ff ff       	jmp    802219 <__umoddi3+0x69>
