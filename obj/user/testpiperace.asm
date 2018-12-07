
obj/user/testpiperace.debug:     formato del fichero elf32-i386


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
  80002c:	e8 b3 01 00 00       	call   8001e4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 1c             	sub    $0x1c,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  80003b:	68 20 24 80 00       	push   $0x802420
  800040:	e8 dc 02 00 00       	call   800321 <cprintf>
	if ((r = pipe(p)) < 0)
  800045:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800048:	89 04 24             	mov    %eax,(%esp)
  80004b:	e8 97 1d 00 00       	call   801de7 <pipe>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	79 12                	jns    800069 <umain+0x36>
		panic("pipe: %e", r);
  800057:	50                   	push   %eax
  800058:	68 39 24 80 00       	push   $0x802439
  80005d:	6a 0d                	push   $0xd
  80005f:	68 42 24 80 00       	push   $0x802442
  800064:	e8 df 01 00 00       	call   800248 <_panic>
	max = 200;
	if ((r = fork()) < 0)
  800069:	e8 15 11 00 00       	call   801183 <fork>
  80006e:	89 c6                	mov    %eax,%esi
  800070:	85 c0                	test   %eax,%eax
  800072:	79 12                	jns    800086 <umain+0x53>
		panic("fork: %e", r);
  800074:	50                   	push   %eax
  800075:	68 50 29 80 00       	push   $0x802950
  80007a:	6a 10                	push   $0x10
  80007c:	68 42 24 80 00       	push   $0x802442
  800081:	e8 c2 01 00 00       	call   800248 <_panic>
	if (r == 0) {
  800086:	85 c0                	test   %eax,%eax
  800088:	75 55                	jne    8000df <umain+0xac>
		close(p[1]);
  80008a:	83 ec 0c             	sub    $0xc,%esp
  80008d:	ff 75 f4             	pushl  -0xc(%ebp)
  800090:	e8 b3 14 00 00       	call   801548 <close>
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	bb c8 00 00 00       	mov    $0xc8,%ebx
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
			if(pipeisclosed(p[0])){
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000a3:	e8 92 1e 00 00       	call   801f3a <pipeisclosed>
  8000a8:	83 c4 10             	add    $0x10,%esp
  8000ab:	85 c0                	test   %eax,%eax
  8000ad:	74 15                	je     8000c4 <umain+0x91>
				cprintf("RACE: pipe appears closed\n");
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	68 56 24 80 00       	push   $0x802456
  8000b7:	e8 65 02 00 00       	call   800321 <cprintf>
				exit();
  8000bc:	e8 6d 01 00 00       	call   80022e <exit>
  8000c1:	83 c4 10             	add    $0x10,%esp
			}
			sys_yield();
  8000c4:	e8 ec 0b 00 00       	call   800cb5 <sys_yield>
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  8000c9:	83 eb 01             	sub    $0x1,%ebx
  8000cc:	75 cf                	jne    80009d <umain+0x6a>
				exit();
			}
			sys_yield();
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
  8000ce:	83 ec 04             	sub    $0x4,%esp
  8000d1:	6a 00                	push   $0x0
  8000d3:	6a 00                	push   $0x0
  8000d5:	6a 00                	push   $0x0
  8000d7:	e8 d4 11 00 00       	call   8012b0 <ipc_recv>
  8000dc:	83 c4 10             	add    $0x10,%esp
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  8000df:	83 ec 08             	sub    $0x8,%esp
  8000e2:	56                   	push   %esi
  8000e3:	68 71 24 80 00       	push   $0x802471
  8000e8:	e8 34 02 00 00       	call   800321 <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  8000ed:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	cprintf("kid is %d\n", kid-envs);
  8000f3:	83 c4 08             	add    $0x8,%esp
  8000f6:	6b c6 7c             	imul   $0x7c,%esi,%eax
  8000f9:	c1 f8 02             	sar    $0x2,%eax
  8000fc:	69 c0 df 7b ef bd    	imul   $0xbdef7bdf,%eax,%eax
  800102:	50                   	push   %eax
  800103:	68 7c 24 80 00       	push   $0x80247c
  800108:	e8 14 02 00 00       	call   800321 <cprintf>
	dup(p[0], 10);
  80010d:	83 c4 08             	add    $0x8,%esp
  800110:	6a 0a                	push   $0xa
  800112:	ff 75 f0             	pushl  -0x10(%ebp)
  800115:	e8 7e 14 00 00       	call   801598 <dup>
	while (kid->env_status == ENV_RUNNABLE)
  80011a:	83 c4 10             	add    $0x10,%esp
  80011d:	6b de 7c             	imul   $0x7c,%esi,%ebx
  800120:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800126:	eb 10                	jmp    800138 <umain+0x105>
		dup(p[0], 10);
  800128:	83 ec 08             	sub    $0x8,%esp
  80012b:	6a 0a                	push   $0xa
  80012d:	ff 75 f0             	pushl  -0x10(%ebp)
  800130:	e8 63 14 00 00       	call   801598 <dup>
  800135:	83 c4 10             	add    $0x10,%esp
	cprintf("pid is %d\n", pid);
	va = 0;
	kid = &envs[ENVX(pid)];
	cprintf("kid is %d\n", kid-envs);
	dup(p[0], 10);
	while (kid->env_status == ENV_RUNNABLE)
  800138:	8b 53 54             	mov    0x54(%ebx),%edx
  80013b:	83 fa 02             	cmp    $0x2,%edx
  80013e:	74 e8                	je     800128 <umain+0xf5>
		dup(p[0], 10);

	cprintf("child done with loop\n");
  800140:	83 ec 0c             	sub    $0xc,%esp
  800143:	68 87 24 80 00       	push   $0x802487
  800148:	e8 d4 01 00 00       	call   800321 <cprintf>
	if (pipeisclosed(p[0]))
  80014d:	83 c4 04             	add    $0x4,%esp
  800150:	ff 75 f0             	pushl  -0x10(%ebp)
  800153:	e8 e2 1d 00 00       	call   801f3a <pipeisclosed>
  800158:	83 c4 10             	add    $0x10,%esp
  80015b:	85 c0                	test   %eax,%eax
  80015d:	74 14                	je     800173 <umain+0x140>
		panic("somehow the other end of p[0] got closed!");
  80015f:	83 ec 04             	sub    $0x4,%esp
  800162:	68 e0 24 80 00       	push   $0x8024e0
  800167:	6a 3a                	push   $0x3a
  800169:	68 42 24 80 00       	push   $0x802442
  80016e:	e8 d5 00 00 00       	call   800248 <_panic>
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800173:	83 ec 08             	sub    $0x8,%esp
  800176:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800179:	50                   	push   %eax
  80017a:	ff 75 f0             	pushl  -0x10(%ebp)
  80017d:	e8 9d 12 00 00       	call   80141f <fd_lookup>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	85 c0                	test   %eax,%eax
  800187:	79 12                	jns    80019b <umain+0x168>
		panic("cannot look up p[0]: %e", r);
  800189:	50                   	push   %eax
  80018a:	68 9d 24 80 00       	push   $0x80249d
  80018f:	6a 3c                	push   $0x3c
  800191:	68 42 24 80 00       	push   $0x802442
  800196:	e8 ad 00 00 00       	call   800248 <_panic>
	va = fd2data(fd);
  80019b:	83 ec 0c             	sub    $0xc,%esp
  80019e:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a1:	e8 12 12 00 00       	call   8013b8 <fd2data>
	if (pageref(va) != 3+1)
  8001a6:	89 04 24             	mov    %eax,(%esp)
  8001a9:	e8 28 1a 00 00       	call   801bd6 <pageref>
  8001ae:	83 c4 10             	add    $0x10,%esp
  8001b1:	83 f8 04             	cmp    $0x4,%eax
  8001b4:	74 12                	je     8001c8 <umain+0x195>
		cprintf("\nchild detected race\n");
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	68 b5 24 80 00       	push   $0x8024b5
  8001be:	e8 5e 01 00 00       	call   800321 <cprintf>
  8001c3:	83 c4 10             	add    $0x10,%esp
  8001c6:	eb 15                	jmp    8001dd <umain+0x1aa>
	else
		cprintf("\nrace didn't happen\n", max);
  8001c8:	83 ec 08             	sub    $0x8,%esp
  8001cb:	68 c8 00 00 00       	push   $0xc8
  8001d0:	68 cb 24 80 00       	push   $0x8024cb
  8001d5:	e8 47 01 00 00       	call   800321 <cprintf>
  8001da:	83 c4 10             	add    $0x10,%esp
}
  8001dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001e0:	5b                   	pop    %ebx
  8001e1:	5e                   	pop    %esi
  8001e2:	5d                   	pop    %ebp
  8001e3:	c3                   	ret    

008001e4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001e4:	55                   	push   %ebp
  8001e5:	89 e5                	mov    %esp,%ebp
  8001e7:	56                   	push   %esi
  8001e8:	53                   	push   %ebx
  8001e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001ec:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8001ef:	e8 9d 0a 00 00       	call   800c91 <sys_getenvid>
	if (id >= 0)
  8001f4:	85 c0                	test   %eax,%eax
  8001f6:	78 12                	js     80020a <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  8001f8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001fd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800200:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800205:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80020a:	85 db                	test   %ebx,%ebx
  80020c:	7e 07                	jle    800215 <libmain+0x31>
		binaryname = argv[0];
  80020e:	8b 06                	mov    (%esi),%eax
  800210:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800215:	83 ec 08             	sub    $0x8,%esp
  800218:	56                   	push   %esi
  800219:	53                   	push   %ebx
  80021a:	e8 14 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80021f:	e8 0a 00 00 00       	call   80022e <exit>
}
  800224:	83 c4 10             	add    $0x10,%esp
  800227:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80022a:	5b                   	pop    %ebx
  80022b:	5e                   	pop    %esi
  80022c:	5d                   	pop    %ebp
  80022d:	c3                   	ret    

0080022e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80022e:	55                   	push   %ebp
  80022f:	89 e5                	mov    %esp,%ebp
  800231:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800234:	e8 3a 13 00 00       	call   801573 <close_all>
	sys_env_destroy(0);
  800239:	83 ec 0c             	sub    $0xc,%esp
  80023c:	6a 00                	push   $0x0
  80023e:	e8 2c 0a 00 00       	call   800c6f <sys_env_destroy>
}
  800243:	83 c4 10             	add    $0x10,%esp
  800246:	c9                   	leave  
  800247:	c3                   	ret    

00800248 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800248:	55                   	push   %ebp
  800249:	89 e5                	mov    %esp,%ebp
  80024b:	56                   	push   %esi
  80024c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80024d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800250:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800256:	e8 36 0a 00 00       	call   800c91 <sys_getenvid>
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	ff 75 0c             	pushl  0xc(%ebp)
  800261:	ff 75 08             	pushl  0x8(%ebp)
  800264:	56                   	push   %esi
  800265:	50                   	push   %eax
  800266:	68 14 25 80 00       	push   $0x802514
  80026b:	e8 b1 00 00 00       	call   800321 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800270:	83 c4 18             	add    $0x18,%esp
  800273:	53                   	push   %ebx
  800274:	ff 75 10             	pushl  0x10(%ebp)
  800277:	e8 54 00 00 00       	call   8002d0 <vcprintf>
	cprintf("\n");
  80027c:	c7 04 24 37 24 80 00 	movl   $0x802437,(%esp)
  800283:	e8 99 00 00 00       	call   800321 <cprintf>
  800288:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80028b:	cc                   	int3   
  80028c:	eb fd                	jmp    80028b <_panic+0x43>

0080028e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	53                   	push   %ebx
  800292:	83 ec 04             	sub    $0x4,%esp
  800295:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800298:	8b 13                	mov    (%ebx),%edx
  80029a:	8d 42 01             	lea    0x1(%edx),%eax
  80029d:	89 03                	mov    %eax,(%ebx)
  80029f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002a2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002a6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ab:	75 1a                	jne    8002c7 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  8002ad:	83 ec 08             	sub    $0x8,%esp
  8002b0:	68 ff 00 00 00       	push   $0xff
  8002b5:	8d 43 08             	lea    0x8(%ebx),%eax
  8002b8:	50                   	push   %eax
  8002b9:	e8 67 09 00 00       	call   800c25 <sys_cputs>
		b->idx = 0;
  8002be:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002c4:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  8002c7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002d9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002e0:	00 00 00 
	b.cnt = 0;
  8002e3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002ea:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002ed:	ff 75 0c             	pushl  0xc(%ebp)
  8002f0:	ff 75 08             	pushl  0x8(%ebp)
  8002f3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002f9:	50                   	push   %eax
  8002fa:	68 8e 02 80 00       	push   $0x80028e
  8002ff:	e8 86 01 00 00       	call   80048a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800304:	83 c4 08             	add    $0x8,%esp
  800307:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80030d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800313:	50                   	push   %eax
  800314:	e8 0c 09 00 00       	call   800c25 <sys_cputs>

	return b.cnt;
}
  800319:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80031f:	c9                   	leave  
  800320:	c3                   	ret    

00800321 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800321:	55                   	push   %ebp
  800322:	89 e5                	mov    %esp,%ebp
  800324:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800327:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80032a:	50                   	push   %eax
  80032b:	ff 75 08             	pushl  0x8(%ebp)
  80032e:	e8 9d ff ff ff       	call   8002d0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800333:	c9                   	leave  
  800334:	c3                   	ret    

00800335 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	57                   	push   %edi
  800339:	56                   	push   %esi
  80033a:	53                   	push   %ebx
  80033b:	83 ec 1c             	sub    $0x1c,%esp
  80033e:	89 c7                	mov    %eax,%edi
  800340:	89 d6                	mov    %edx,%esi
  800342:	8b 45 08             	mov    0x8(%ebp),%eax
  800345:	8b 55 0c             	mov    0xc(%ebp),%edx
  800348:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80034b:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80034e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800351:	bb 00 00 00 00       	mov    $0x0,%ebx
  800356:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800359:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80035c:	39 d3                	cmp    %edx,%ebx
  80035e:	72 05                	jb     800365 <printnum+0x30>
  800360:	39 45 10             	cmp    %eax,0x10(%ebp)
  800363:	77 45                	ja     8003aa <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800365:	83 ec 0c             	sub    $0xc,%esp
  800368:	ff 75 18             	pushl  0x18(%ebp)
  80036b:	8b 45 14             	mov    0x14(%ebp),%eax
  80036e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800371:	53                   	push   %ebx
  800372:	ff 75 10             	pushl  0x10(%ebp)
  800375:	83 ec 08             	sub    $0x8,%esp
  800378:	ff 75 e4             	pushl  -0x1c(%ebp)
  80037b:	ff 75 e0             	pushl  -0x20(%ebp)
  80037e:	ff 75 dc             	pushl  -0x24(%ebp)
  800381:	ff 75 d8             	pushl  -0x28(%ebp)
  800384:	e8 07 1e 00 00       	call   802190 <__udivdi3>
  800389:	83 c4 18             	add    $0x18,%esp
  80038c:	52                   	push   %edx
  80038d:	50                   	push   %eax
  80038e:	89 f2                	mov    %esi,%edx
  800390:	89 f8                	mov    %edi,%eax
  800392:	e8 9e ff ff ff       	call   800335 <printnum>
  800397:	83 c4 20             	add    $0x20,%esp
  80039a:	eb 18                	jmp    8003b4 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80039c:	83 ec 08             	sub    $0x8,%esp
  80039f:	56                   	push   %esi
  8003a0:	ff 75 18             	pushl  0x18(%ebp)
  8003a3:	ff d7                	call   *%edi
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	eb 03                	jmp    8003ad <printnum+0x78>
  8003aa:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003ad:	83 eb 01             	sub    $0x1,%ebx
  8003b0:	85 db                	test   %ebx,%ebx
  8003b2:	7f e8                	jg     80039c <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003b4:	83 ec 08             	sub    $0x8,%esp
  8003b7:	56                   	push   %esi
  8003b8:	83 ec 04             	sub    $0x4,%esp
  8003bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003be:	ff 75 e0             	pushl  -0x20(%ebp)
  8003c1:	ff 75 dc             	pushl  -0x24(%ebp)
  8003c4:	ff 75 d8             	pushl  -0x28(%ebp)
  8003c7:	e8 f4 1e 00 00       	call   8022c0 <__umoddi3>
  8003cc:	83 c4 14             	add    $0x14,%esp
  8003cf:	0f be 80 37 25 80 00 	movsbl 0x802537(%eax),%eax
  8003d6:	50                   	push   %eax
  8003d7:	ff d7                	call   *%edi
}
  8003d9:	83 c4 10             	add    $0x10,%esp
  8003dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003df:	5b                   	pop    %ebx
  8003e0:	5e                   	pop    %esi
  8003e1:	5f                   	pop    %edi
  8003e2:	5d                   	pop    %ebp
  8003e3:	c3                   	ret    

008003e4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003e7:	83 fa 01             	cmp    $0x1,%edx
  8003ea:	7e 0e                	jle    8003fa <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003ec:	8b 10                	mov    (%eax),%edx
  8003ee:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003f1:	89 08                	mov    %ecx,(%eax)
  8003f3:	8b 02                	mov    (%edx),%eax
  8003f5:	8b 52 04             	mov    0x4(%edx),%edx
  8003f8:	eb 22                	jmp    80041c <getuint+0x38>
	else if (lflag)
  8003fa:	85 d2                	test   %edx,%edx
  8003fc:	74 10                	je     80040e <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003fe:	8b 10                	mov    (%eax),%edx
  800400:	8d 4a 04             	lea    0x4(%edx),%ecx
  800403:	89 08                	mov    %ecx,(%eax)
  800405:	8b 02                	mov    (%edx),%eax
  800407:	ba 00 00 00 00       	mov    $0x0,%edx
  80040c:	eb 0e                	jmp    80041c <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80040e:	8b 10                	mov    (%eax),%edx
  800410:	8d 4a 04             	lea    0x4(%edx),%ecx
  800413:	89 08                	mov    %ecx,(%eax)
  800415:	8b 02                	mov    (%edx),%eax
  800417:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80041c:	5d                   	pop    %ebp
  80041d:	c3                   	ret    

0080041e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80041e:	55                   	push   %ebp
  80041f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800421:	83 fa 01             	cmp    $0x1,%edx
  800424:	7e 0e                	jle    800434 <getint+0x16>
		return va_arg(*ap, long long);
  800426:	8b 10                	mov    (%eax),%edx
  800428:	8d 4a 08             	lea    0x8(%edx),%ecx
  80042b:	89 08                	mov    %ecx,(%eax)
  80042d:	8b 02                	mov    (%edx),%eax
  80042f:	8b 52 04             	mov    0x4(%edx),%edx
  800432:	eb 1a                	jmp    80044e <getint+0x30>
	else if (lflag)
  800434:	85 d2                	test   %edx,%edx
  800436:	74 0c                	je     800444 <getint+0x26>
		return va_arg(*ap, long);
  800438:	8b 10                	mov    (%eax),%edx
  80043a:	8d 4a 04             	lea    0x4(%edx),%ecx
  80043d:	89 08                	mov    %ecx,(%eax)
  80043f:	8b 02                	mov    (%edx),%eax
  800441:	99                   	cltd   
  800442:	eb 0a                	jmp    80044e <getint+0x30>
	else
		return va_arg(*ap, int);
  800444:	8b 10                	mov    (%eax),%edx
  800446:	8d 4a 04             	lea    0x4(%edx),%ecx
  800449:	89 08                	mov    %ecx,(%eax)
  80044b:	8b 02                	mov    (%edx),%eax
  80044d:	99                   	cltd   
}
  80044e:	5d                   	pop    %ebp
  80044f:	c3                   	ret    

00800450 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800450:	55                   	push   %ebp
  800451:	89 e5                	mov    %esp,%ebp
  800453:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800456:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80045a:	8b 10                	mov    (%eax),%edx
  80045c:	3b 50 04             	cmp    0x4(%eax),%edx
  80045f:	73 0a                	jae    80046b <sprintputch+0x1b>
		*b->buf++ = ch;
  800461:	8d 4a 01             	lea    0x1(%edx),%ecx
  800464:	89 08                	mov    %ecx,(%eax)
  800466:	8b 45 08             	mov    0x8(%ebp),%eax
  800469:	88 02                	mov    %al,(%edx)
}
  80046b:	5d                   	pop    %ebp
  80046c:	c3                   	ret    

0080046d <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80046d:	55                   	push   %ebp
  80046e:	89 e5                	mov    %esp,%ebp
  800470:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800473:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800476:	50                   	push   %eax
  800477:	ff 75 10             	pushl  0x10(%ebp)
  80047a:	ff 75 0c             	pushl  0xc(%ebp)
  80047d:	ff 75 08             	pushl  0x8(%ebp)
  800480:	e8 05 00 00 00       	call   80048a <vprintfmt>
	va_end(ap);
}
  800485:	83 c4 10             	add    $0x10,%esp
  800488:	c9                   	leave  
  800489:	c3                   	ret    

0080048a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80048a:	55                   	push   %ebp
  80048b:	89 e5                	mov    %esp,%ebp
  80048d:	57                   	push   %edi
  80048e:	56                   	push   %esi
  80048f:	53                   	push   %ebx
  800490:	83 ec 2c             	sub    $0x2c,%esp
  800493:	8b 75 08             	mov    0x8(%ebp),%esi
  800496:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800499:	8b 7d 10             	mov    0x10(%ebp),%edi
  80049c:	eb 12                	jmp    8004b0 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80049e:	85 c0                	test   %eax,%eax
  8004a0:	0f 84 44 03 00 00    	je     8007ea <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  8004a6:	83 ec 08             	sub    $0x8,%esp
  8004a9:	53                   	push   %ebx
  8004aa:	50                   	push   %eax
  8004ab:	ff d6                	call   *%esi
  8004ad:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004b0:	83 c7 01             	add    $0x1,%edi
  8004b3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004b7:	83 f8 25             	cmp    $0x25,%eax
  8004ba:	75 e2                	jne    80049e <vprintfmt+0x14>
  8004bc:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8004c0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8004c7:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004ce:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8004d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8004da:	eb 07                	jmp    8004e3 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8004df:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e3:	8d 47 01             	lea    0x1(%edi),%eax
  8004e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004e9:	0f b6 07             	movzbl (%edi),%eax
  8004ec:	0f b6 c8             	movzbl %al,%ecx
  8004ef:	83 e8 23             	sub    $0x23,%eax
  8004f2:	3c 55                	cmp    $0x55,%al
  8004f4:	0f 87 d5 02 00 00    	ja     8007cf <vprintfmt+0x345>
  8004fa:	0f b6 c0             	movzbl %al,%eax
  8004fd:	ff 24 85 80 26 80 00 	jmp    *0x802680(,%eax,4)
  800504:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800507:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80050b:	eb d6                	jmp    8004e3 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80050d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800510:	b8 00 00 00 00       	mov    $0x0,%eax
  800515:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800518:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80051b:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  80051f:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  800522:	8d 51 d0             	lea    -0x30(%ecx),%edx
  800525:	83 fa 09             	cmp    $0x9,%edx
  800528:	77 39                	ja     800563 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80052a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80052d:	eb e9                	jmp    800518 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80052f:	8b 45 14             	mov    0x14(%ebp),%eax
  800532:	8d 48 04             	lea    0x4(%eax),%ecx
  800535:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800538:	8b 00                	mov    (%eax),%eax
  80053a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80053d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800540:	eb 27                	jmp    800569 <vprintfmt+0xdf>
  800542:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800545:	85 c0                	test   %eax,%eax
  800547:	b9 00 00 00 00       	mov    $0x0,%ecx
  80054c:	0f 49 c8             	cmovns %eax,%ecx
  80054f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800552:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800555:	eb 8c                	jmp    8004e3 <vprintfmt+0x59>
  800557:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80055a:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800561:	eb 80                	jmp    8004e3 <vprintfmt+0x59>
  800563:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800566:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  800569:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80056d:	0f 89 70 ff ff ff    	jns    8004e3 <vprintfmt+0x59>
				width = precision, precision = -1;
  800573:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800576:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800579:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800580:	e9 5e ff ff ff       	jmp    8004e3 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800585:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800588:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80058b:	e9 53 ff ff ff       	jmp    8004e3 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800590:	8b 45 14             	mov    0x14(%ebp),%eax
  800593:	8d 50 04             	lea    0x4(%eax),%edx
  800596:	89 55 14             	mov    %edx,0x14(%ebp)
  800599:	83 ec 08             	sub    $0x8,%esp
  80059c:	53                   	push   %ebx
  80059d:	ff 30                	pushl  (%eax)
  80059f:	ff d6                	call   *%esi
			break;
  8005a1:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  8005a7:	e9 04 ff ff ff       	jmp    8004b0 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8005af:	8d 50 04             	lea    0x4(%eax),%edx
  8005b2:	89 55 14             	mov    %edx,0x14(%ebp)
  8005b5:	8b 00                	mov    (%eax),%eax
  8005b7:	99                   	cltd   
  8005b8:	31 d0                	xor    %edx,%eax
  8005ba:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005bc:	83 f8 0f             	cmp    $0xf,%eax
  8005bf:	7f 0b                	jg     8005cc <vprintfmt+0x142>
  8005c1:	8b 14 85 e0 27 80 00 	mov    0x8027e0(,%eax,4),%edx
  8005c8:	85 d2                	test   %edx,%edx
  8005ca:	75 18                	jne    8005e4 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  8005cc:	50                   	push   %eax
  8005cd:	68 4f 25 80 00       	push   $0x80254f
  8005d2:	53                   	push   %ebx
  8005d3:	56                   	push   %esi
  8005d4:	e8 94 fe ff ff       	call   80046d <printfmt>
  8005d9:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8005df:	e9 cc fe ff ff       	jmp    8004b0 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  8005e4:	52                   	push   %edx
  8005e5:	68 95 2a 80 00       	push   $0x802a95
  8005ea:	53                   	push   %ebx
  8005eb:	56                   	push   %esi
  8005ec:	e8 7c fe ff ff       	call   80046d <printfmt>
  8005f1:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005f7:	e9 b4 fe ff ff       	jmp    8004b0 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	8d 50 04             	lea    0x4(%eax),%edx
  800602:	89 55 14             	mov    %edx,0x14(%ebp)
  800605:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800607:	85 ff                	test   %edi,%edi
  800609:	b8 48 25 80 00       	mov    $0x802548,%eax
  80060e:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800611:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800615:	0f 8e 94 00 00 00    	jle    8006af <vprintfmt+0x225>
  80061b:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80061f:	0f 84 98 00 00 00    	je     8006bd <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  800625:	83 ec 08             	sub    $0x8,%esp
  800628:	ff 75 d0             	pushl  -0x30(%ebp)
  80062b:	57                   	push   %edi
  80062c:	e8 41 02 00 00       	call   800872 <strnlen>
  800631:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800634:	29 c1                	sub    %eax,%ecx
  800636:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800639:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80063c:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800640:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800643:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800646:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800648:	eb 0f                	jmp    800659 <vprintfmt+0x1cf>
					putch(padc, putdat);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	53                   	push   %ebx
  80064e:	ff 75 e0             	pushl  -0x20(%ebp)
  800651:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800653:	83 ef 01             	sub    $0x1,%edi
  800656:	83 c4 10             	add    $0x10,%esp
  800659:	85 ff                	test   %edi,%edi
  80065b:	7f ed                	jg     80064a <vprintfmt+0x1c0>
  80065d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800660:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800663:	85 c9                	test   %ecx,%ecx
  800665:	b8 00 00 00 00       	mov    $0x0,%eax
  80066a:	0f 49 c1             	cmovns %ecx,%eax
  80066d:	29 c1                	sub    %eax,%ecx
  80066f:	89 75 08             	mov    %esi,0x8(%ebp)
  800672:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800675:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800678:	89 cb                	mov    %ecx,%ebx
  80067a:	eb 4d                	jmp    8006c9 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80067c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800680:	74 1b                	je     80069d <vprintfmt+0x213>
  800682:	0f be c0             	movsbl %al,%eax
  800685:	83 e8 20             	sub    $0x20,%eax
  800688:	83 f8 5e             	cmp    $0x5e,%eax
  80068b:	76 10                	jbe    80069d <vprintfmt+0x213>
					putch('?', putdat);
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	ff 75 0c             	pushl  0xc(%ebp)
  800693:	6a 3f                	push   $0x3f
  800695:	ff 55 08             	call   *0x8(%ebp)
  800698:	83 c4 10             	add    $0x10,%esp
  80069b:	eb 0d                	jmp    8006aa <vprintfmt+0x220>
				else
					putch(ch, putdat);
  80069d:	83 ec 08             	sub    $0x8,%esp
  8006a0:	ff 75 0c             	pushl  0xc(%ebp)
  8006a3:	52                   	push   %edx
  8006a4:	ff 55 08             	call   *0x8(%ebp)
  8006a7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006aa:	83 eb 01             	sub    $0x1,%ebx
  8006ad:	eb 1a                	jmp    8006c9 <vprintfmt+0x23f>
  8006af:	89 75 08             	mov    %esi,0x8(%ebp)
  8006b2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006b5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006b8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006bb:	eb 0c                	jmp    8006c9 <vprintfmt+0x23f>
  8006bd:	89 75 08             	mov    %esi,0x8(%ebp)
  8006c0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006c3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006c6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006c9:	83 c7 01             	add    $0x1,%edi
  8006cc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006d0:	0f be d0             	movsbl %al,%edx
  8006d3:	85 d2                	test   %edx,%edx
  8006d5:	74 23                	je     8006fa <vprintfmt+0x270>
  8006d7:	85 f6                	test   %esi,%esi
  8006d9:	78 a1                	js     80067c <vprintfmt+0x1f2>
  8006db:	83 ee 01             	sub    $0x1,%esi
  8006de:	79 9c                	jns    80067c <vprintfmt+0x1f2>
  8006e0:	89 df                	mov    %ebx,%edi
  8006e2:	8b 75 08             	mov    0x8(%ebp),%esi
  8006e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006e8:	eb 18                	jmp    800702 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006ea:	83 ec 08             	sub    $0x8,%esp
  8006ed:	53                   	push   %ebx
  8006ee:	6a 20                	push   $0x20
  8006f0:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006f2:	83 ef 01             	sub    $0x1,%edi
  8006f5:	83 c4 10             	add    $0x10,%esp
  8006f8:	eb 08                	jmp    800702 <vprintfmt+0x278>
  8006fa:	89 df                	mov    %ebx,%edi
  8006fc:	8b 75 08             	mov    0x8(%ebp),%esi
  8006ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800702:	85 ff                	test   %edi,%edi
  800704:	7f e4                	jg     8006ea <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800706:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800709:	e9 a2 fd ff ff       	jmp    8004b0 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80070e:	8d 45 14             	lea    0x14(%ebp),%eax
  800711:	e8 08 fd ff ff       	call   80041e <getint>
  800716:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800719:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80071c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800721:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800725:	79 74                	jns    80079b <vprintfmt+0x311>
				putch('-', putdat);
  800727:	83 ec 08             	sub    $0x8,%esp
  80072a:	53                   	push   %ebx
  80072b:	6a 2d                	push   $0x2d
  80072d:	ff d6                	call   *%esi
				num = -(long long) num;
  80072f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800732:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800735:	f7 d8                	neg    %eax
  800737:	83 d2 00             	adc    $0x0,%edx
  80073a:	f7 da                	neg    %edx
  80073c:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  80073f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800744:	eb 55                	jmp    80079b <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800746:	8d 45 14             	lea    0x14(%ebp),%eax
  800749:	e8 96 fc ff ff       	call   8003e4 <getuint>
			base = 10;
  80074e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800753:	eb 46                	jmp    80079b <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800755:	8d 45 14             	lea    0x14(%ebp),%eax
  800758:	e8 87 fc ff ff       	call   8003e4 <getuint>
			base = 8;
  80075d:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800762:	eb 37                	jmp    80079b <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	53                   	push   %ebx
  800768:	6a 30                	push   $0x30
  80076a:	ff d6                	call   *%esi
			putch('x', putdat);
  80076c:	83 c4 08             	add    $0x8,%esp
  80076f:	53                   	push   %ebx
  800770:	6a 78                	push   $0x78
  800772:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8d 50 04             	lea    0x4(%eax),%edx
  80077a:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800784:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800787:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80078c:	eb 0d                	jmp    80079b <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80078e:	8d 45 14             	lea    0x14(%ebp),%eax
  800791:	e8 4e fc ff ff       	call   8003e4 <getuint>
			base = 16;
  800796:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  80079b:	83 ec 0c             	sub    $0xc,%esp
  80079e:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8007a2:	57                   	push   %edi
  8007a3:	ff 75 e0             	pushl  -0x20(%ebp)
  8007a6:	51                   	push   %ecx
  8007a7:	52                   	push   %edx
  8007a8:	50                   	push   %eax
  8007a9:	89 da                	mov    %ebx,%edx
  8007ab:	89 f0                	mov    %esi,%eax
  8007ad:	e8 83 fb ff ff       	call   800335 <printnum>
			break;
  8007b2:	83 c4 20             	add    $0x20,%esp
  8007b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8007b8:	e9 f3 fc ff ff       	jmp    8004b0 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007bd:	83 ec 08             	sub    $0x8,%esp
  8007c0:	53                   	push   %ebx
  8007c1:	51                   	push   %ecx
  8007c2:	ff d6                	call   *%esi
			break;
  8007c4:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8007ca:	e9 e1 fc ff ff       	jmp    8004b0 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007cf:	83 ec 08             	sub    $0x8,%esp
  8007d2:	53                   	push   %ebx
  8007d3:	6a 25                	push   $0x25
  8007d5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007d7:	83 c4 10             	add    $0x10,%esp
  8007da:	eb 03                	jmp    8007df <vprintfmt+0x355>
  8007dc:	83 ef 01             	sub    $0x1,%edi
  8007df:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  8007e3:	75 f7                	jne    8007dc <vprintfmt+0x352>
  8007e5:	e9 c6 fc ff ff       	jmp    8004b0 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  8007ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007ed:	5b                   	pop    %ebx
  8007ee:	5e                   	pop    %esi
  8007ef:	5f                   	pop    %edi
  8007f0:	5d                   	pop    %ebp
  8007f1:	c3                   	ret    

008007f2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	83 ec 18             	sub    $0x18,%esp
  8007f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800801:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800805:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800808:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80080f:	85 c0                	test   %eax,%eax
  800811:	74 26                	je     800839 <vsnprintf+0x47>
  800813:	85 d2                	test   %edx,%edx
  800815:	7e 22                	jle    800839 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800817:	ff 75 14             	pushl  0x14(%ebp)
  80081a:	ff 75 10             	pushl  0x10(%ebp)
  80081d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800820:	50                   	push   %eax
  800821:	68 50 04 80 00       	push   $0x800450
  800826:	e8 5f fc ff ff       	call   80048a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80082b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80082e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800834:	83 c4 10             	add    $0x10,%esp
  800837:	eb 05                	jmp    80083e <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800839:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80083e:	c9                   	leave  
  80083f:	c3                   	ret    

00800840 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800846:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800849:	50                   	push   %eax
  80084a:	ff 75 10             	pushl  0x10(%ebp)
  80084d:	ff 75 0c             	pushl  0xc(%ebp)
  800850:	ff 75 08             	pushl  0x8(%ebp)
  800853:	e8 9a ff ff ff       	call   8007f2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800858:	c9                   	leave  
  800859:	c3                   	ret    

0080085a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
  80085d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800860:	b8 00 00 00 00       	mov    $0x0,%eax
  800865:	eb 03                	jmp    80086a <strlen+0x10>
		n++;
  800867:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80086a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80086e:	75 f7                	jne    800867 <strlen+0xd>
		n++;
	return n;
}
  800870:	5d                   	pop    %ebp
  800871:	c3                   	ret    

00800872 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800878:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80087b:	ba 00 00 00 00       	mov    $0x0,%edx
  800880:	eb 03                	jmp    800885 <strnlen+0x13>
		n++;
  800882:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800885:	39 c2                	cmp    %eax,%edx
  800887:	74 08                	je     800891 <strnlen+0x1f>
  800889:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80088d:	75 f3                	jne    800882 <strnlen+0x10>
  80088f:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  800891:	5d                   	pop    %ebp
  800892:	c3                   	ret    

00800893 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800893:	55                   	push   %ebp
  800894:	89 e5                	mov    %esp,%ebp
  800896:	53                   	push   %ebx
  800897:	8b 45 08             	mov    0x8(%ebp),%eax
  80089a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80089d:	89 c2                	mov    %eax,%edx
  80089f:	83 c2 01             	add    $0x1,%edx
  8008a2:	83 c1 01             	add    $0x1,%ecx
  8008a5:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008a9:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008ac:	84 db                	test   %bl,%bl
  8008ae:	75 ef                	jne    80089f <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008b0:	5b                   	pop    %ebx
  8008b1:	5d                   	pop    %ebp
  8008b2:	c3                   	ret    

008008b3 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	53                   	push   %ebx
  8008b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008ba:	53                   	push   %ebx
  8008bb:	e8 9a ff ff ff       	call   80085a <strlen>
  8008c0:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008c3:	ff 75 0c             	pushl  0xc(%ebp)
  8008c6:	01 d8                	add    %ebx,%eax
  8008c8:	50                   	push   %eax
  8008c9:	e8 c5 ff ff ff       	call   800893 <strcpy>
	return dst;
}
  8008ce:	89 d8                	mov    %ebx,%eax
  8008d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008d3:	c9                   	leave  
  8008d4:	c3                   	ret    

008008d5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
  8008d8:	56                   	push   %esi
  8008d9:	53                   	push   %ebx
  8008da:	8b 75 08             	mov    0x8(%ebp),%esi
  8008dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008e0:	89 f3                	mov    %esi,%ebx
  8008e2:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008e5:	89 f2                	mov    %esi,%edx
  8008e7:	eb 0f                	jmp    8008f8 <strncpy+0x23>
		*dst++ = *src;
  8008e9:	83 c2 01             	add    $0x1,%edx
  8008ec:	0f b6 01             	movzbl (%ecx),%eax
  8008ef:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008f2:	80 39 01             	cmpb   $0x1,(%ecx)
  8008f5:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008f8:	39 da                	cmp    %ebx,%edx
  8008fa:	75 ed                	jne    8008e9 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008fc:	89 f0                	mov    %esi,%eax
  8008fe:	5b                   	pop    %ebx
  8008ff:	5e                   	pop    %esi
  800900:	5d                   	pop    %ebp
  800901:	c3                   	ret    

00800902 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800902:	55                   	push   %ebp
  800903:	89 e5                	mov    %esp,%ebp
  800905:	56                   	push   %esi
  800906:	53                   	push   %ebx
  800907:	8b 75 08             	mov    0x8(%ebp),%esi
  80090a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80090d:	8b 55 10             	mov    0x10(%ebp),%edx
  800910:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800912:	85 d2                	test   %edx,%edx
  800914:	74 21                	je     800937 <strlcpy+0x35>
  800916:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80091a:	89 f2                	mov    %esi,%edx
  80091c:	eb 09                	jmp    800927 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80091e:	83 c2 01             	add    $0x1,%edx
  800921:	83 c1 01             	add    $0x1,%ecx
  800924:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800927:	39 c2                	cmp    %eax,%edx
  800929:	74 09                	je     800934 <strlcpy+0x32>
  80092b:	0f b6 19             	movzbl (%ecx),%ebx
  80092e:	84 db                	test   %bl,%bl
  800930:	75 ec                	jne    80091e <strlcpy+0x1c>
  800932:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  800934:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800937:	29 f0                	sub    %esi,%eax
}
  800939:	5b                   	pop    %ebx
  80093a:	5e                   	pop    %esi
  80093b:	5d                   	pop    %ebp
  80093c:	c3                   	ret    

0080093d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80093d:	55                   	push   %ebp
  80093e:	89 e5                	mov    %esp,%ebp
  800940:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800943:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800946:	eb 06                	jmp    80094e <strcmp+0x11>
		p++, q++;
  800948:	83 c1 01             	add    $0x1,%ecx
  80094b:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80094e:	0f b6 01             	movzbl (%ecx),%eax
  800951:	84 c0                	test   %al,%al
  800953:	74 04                	je     800959 <strcmp+0x1c>
  800955:	3a 02                	cmp    (%edx),%al
  800957:	74 ef                	je     800948 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800959:	0f b6 c0             	movzbl %al,%eax
  80095c:	0f b6 12             	movzbl (%edx),%edx
  80095f:	29 d0                	sub    %edx,%eax
}
  800961:	5d                   	pop    %ebp
  800962:	c3                   	ret    

00800963 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	53                   	push   %ebx
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096d:	89 c3                	mov    %eax,%ebx
  80096f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800972:	eb 06                	jmp    80097a <strncmp+0x17>
		n--, p++, q++;
  800974:	83 c0 01             	add    $0x1,%eax
  800977:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80097a:	39 d8                	cmp    %ebx,%eax
  80097c:	74 15                	je     800993 <strncmp+0x30>
  80097e:	0f b6 08             	movzbl (%eax),%ecx
  800981:	84 c9                	test   %cl,%cl
  800983:	74 04                	je     800989 <strncmp+0x26>
  800985:	3a 0a                	cmp    (%edx),%cl
  800987:	74 eb                	je     800974 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800989:	0f b6 00             	movzbl (%eax),%eax
  80098c:	0f b6 12             	movzbl (%edx),%edx
  80098f:	29 d0                	sub    %edx,%eax
  800991:	eb 05                	jmp    800998 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800993:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800998:	5b                   	pop    %ebx
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009a5:	eb 07                	jmp    8009ae <strchr+0x13>
		if (*s == c)
  8009a7:	38 ca                	cmp    %cl,%dl
  8009a9:	74 0f                	je     8009ba <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009ab:	83 c0 01             	add    $0x1,%eax
  8009ae:	0f b6 10             	movzbl (%eax),%edx
  8009b1:	84 d2                	test   %dl,%dl
  8009b3:	75 f2                	jne    8009a7 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8009b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ba:	5d                   	pop    %ebp
  8009bb:	c3                   	ret    

008009bc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009c6:	eb 03                	jmp    8009cb <strfind+0xf>
  8009c8:	83 c0 01             	add    $0x1,%eax
  8009cb:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009ce:	38 ca                	cmp    %cl,%dl
  8009d0:	74 04                	je     8009d6 <strfind+0x1a>
  8009d2:	84 d2                	test   %dl,%dl
  8009d4:	75 f2                	jne    8009c8 <strfind+0xc>
			break;
	return (char *) s;
}
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    

008009d8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	57                   	push   %edi
  8009dc:	56                   	push   %esi
  8009dd:	53                   	push   %ebx
  8009de:	8b 55 08             	mov    0x8(%ebp),%edx
  8009e1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  8009e4:	85 c9                	test   %ecx,%ecx
  8009e6:	74 37                	je     800a1f <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009e8:	f6 c2 03             	test   $0x3,%dl
  8009eb:	75 2a                	jne    800a17 <memset+0x3f>
  8009ed:	f6 c1 03             	test   $0x3,%cl
  8009f0:	75 25                	jne    800a17 <memset+0x3f>
		c &= 0xFF;
  8009f2:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009f6:	89 df                	mov    %ebx,%edi
  8009f8:	c1 e7 08             	shl    $0x8,%edi
  8009fb:	89 de                	mov    %ebx,%esi
  8009fd:	c1 e6 18             	shl    $0x18,%esi
  800a00:	89 d8                	mov    %ebx,%eax
  800a02:	c1 e0 10             	shl    $0x10,%eax
  800a05:	09 f0                	or     %esi,%eax
  800a07:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800a09:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a0c:	89 f8                	mov    %edi,%eax
  800a0e:	09 d8                	or     %ebx,%eax
  800a10:	89 d7                	mov    %edx,%edi
  800a12:	fc                   	cld    
  800a13:	f3 ab                	rep stos %eax,%es:(%edi)
  800a15:	eb 08                	jmp    800a1f <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a17:	89 d7                	mov    %edx,%edi
  800a19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1c:	fc                   	cld    
  800a1d:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800a1f:	89 d0                	mov    %edx,%eax
  800a21:	5b                   	pop    %ebx
  800a22:	5e                   	pop    %esi
  800a23:	5f                   	pop    %edi
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    

00800a26 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	57                   	push   %edi
  800a2a:	56                   	push   %esi
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a31:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a34:	39 c6                	cmp    %eax,%esi
  800a36:	73 35                	jae    800a6d <memmove+0x47>
  800a38:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a3b:	39 d0                	cmp    %edx,%eax
  800a3d:	73 2e                	jae    800a6d <memmove+0x47>
		s += n;
		d += n;
  800a3f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a42:	89 d6                	mov    %edx,%esi
  800a44:	09 fe                	or     %edi,%esi
  800a46:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a4c:	75 13                	jne    800a61 <memmove+0x3b>
  800a4e:	f6 c1 03             	test   $0x3,%cl
  800a51:	75 0e                	jne    800a61 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  800a53:	83 ef 04             	sub    $0x4,%edi
  800a56:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a59:	c1 e9 02             	shr    $0x2,%ecx
  800a5c:	fd                   	std    
  800a5d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a5f:	eb 09                	jmp    800a6a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a61:	83 ef 01             	sub    $0x1,%edi
  800a64:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a67:	fd                   	std    
  800a68:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a6a:	fc                   	cld    
  800a6b:	eb 1d                	jmp    800a8a <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a6d:	89 f2                	mov    %esi,%edx
  800a6f:	09 c2                	or     %eax,%edx
  800a71:	f6 c2 03             	test   $0x3,%dl
  800a74:	75 0f                	jne    800a85 <memmove+0x5f>
  800a76:	f6 c1 03             	test   $0x3,%cl
  800a79:	75 0a                	jne    800a85 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  800a7b:	c1 e9 02             	shr    $0x2,%ecx
  800a7e:	89 c7                	mov    %eax,%edi
  800a80:	fc                   	cld    
  800a81:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a83:	eb 05                	jmp    800a8a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a85:	89 c7                	mov    %eax,%edi
  800a87:	fc                   	cld    
  800a88:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a8a:	5e                   	pop    %esi
  800a8b:	5f                   	pop    %edi
  800a8c:	5d                   	pop    %ebp
  800a8d:	c3                   	ret    

00800a8e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a8e:	55                   	push   %ebp
  800a8f:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a91:	ff 75 10             	pushl  0x10(%ebp)
  800a94:	ff 75 0c             	pushl  0xc(%ebp)
  800a97:	ff 75 08             	pushl  0x8(%ebp)
  800a9a:	e8 87 ff ff ff       	call   800a26 <memmove>
}
  800a9f:	c9                   	leave  
  800aa0:	c3                   	ret    

00800aa1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	56                   	push   %esi
  800aa5:	53                   	push   %ebx
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aac:	89 c6                	mov    %eax,%esi
  800aae:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ab1:	eb 1a                	jmp    800acd <memcmp+0x2c>
		if (*s1 != *s2)
  800ab3:	0f b6 08             	movzbl (%eax),%ecx
  800ab6:	0f b6 1a             	movzbl (%edx),%ebx
  800ab9:	38 d9                	cmp    %bl,%cl
  800abb:	74 0a                	je     800ac7 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800abd:	0f b6 c1             	movzbl %cl,%eax
  800ac0:	0f b6 db             	movzbl %bl,%ebx
  800ac3:	29 d8                	sub    %ebx,%eax
  800ac5:	eb 0f                	jmp    800ad6 <memcmp+0x35>
		s1++, s2++;
  800ac7:	83 c0 01             	add    $0x1,%eax
  800aca:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800acd:	39 f0                	cmp    %esi,%eax
  800acf:	75 e2                	jne    800ab3 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ad1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ad6:	5b                   	pop    %ebx
  800ad7:	5e                   	pop    %esi
  800ad8:	5d                   	pop    %ebp
  800ad9:	c3                   	ret    

00800ada <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	53                   	push   %ebx
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800ae1:	89 c1                	mov    %eax,%ecx
  800ae3:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  800ae6:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800aea:	eb 0a                	jmp    800af6 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800aec:	0f b6 10             	movzbl (%eax),%edx
  800aef:	39 da                	cmp    %ebx,%edx
  800af1:	74 07                	je     800afa <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800af3:	83 c0 01             	add    $0x1,%eax
  800af6:	39 c8                	cmp    %ecx,%eax
  800af8:	72 f2                	jb     800aec <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800afa:	5b                   	pop    %ebx
  800afb:	5d                   	pop    %ebp
  800afc:	c3                   	ret    

00800afd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
  800b00:	57                   	push   %edi
  800b01:	56                   	push   %esi
  800b02:	53                   	push   %ebx
  800b03:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b06:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b09:	eb 03                	jmp    800b0e <strtol+0x11>
		s++;
  800b0b:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b0e:	0f b6 01             	movzbl (%ecx),%eax
  800b11:	3c 20                	cmp    $0x20,%al
  800b13:	74 f6                	je     800b0b <strtol+0xe>
  800b15:	3c 09                	cmp    $0x9,%al
  800b17:	74 f2                	je     800b0b <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b19:	3c 2b                	cmp    $0x2b,%al
  800b1b:	75 0a                	jne    800b27 <strtol+0x2a>
		s++;
  800b1d:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b20:	bf 00 00 00 00       	mov    $0x0,%edi
  800b25:	eb 11                	jmp    800b38 <strtol+0x3b>
  800b27:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b2c:	3c 2d                	cmp    $0x2d,%al
  800b2e:	75 08                	jne    800b38 <strtol+0x3b>
		s++, neg = 1;
  800b30:	83 c1 01             	add    $0x1,%ecx
  800b33:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b38:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b3e:	75 15                	jne    800b55 <strtol+0x58>
  800b40:	80 39 30             	cmpb   $0x30,(%ecx)
  800b43:	75 10                	jne    800b55 <strtol+0x58>
  800b45:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b49:	75 7c                	jne    800bc7 <strtol+0xca>
		s += 2, base = 16;
  800b4b:	83 c1 02             	add    $0x2,%ecx
  800b4e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b53:	eb 16                	jmp    800b6b <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800b55:	85 db                	test   %ebx,%ebx
  800b57:	75 12                	jne    800b6b <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b59:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b5e:	80 39 30             	cmpb   $0x30,(%ecx)
  800b61:	75 08                	jne    800b6b <strtol+0x6e>
		s++, base = 8;
  800b63:	83 c1 01             	add    $0x1,%ecx
  800b66:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800b6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b70:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b73:	0f b6 11             	movzbl (%ecx),%edx
  800b76:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b79:	89 f3                	mov    %esi,%ebx
  800b7b:	80 fb 09             	cmp    $0x9,%bl
  800b7e:	77 08                	ja     800b88 <strtol+0x8b>
			dig = *s - '0';
  800b80:	0f be d2             	movsbl %dl,%edx
  800b83:	83 ea 30             	sub    $0x30,%edx
  800b86:	eb 22                	jmp    800baa <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800b88:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b8b:	89 f3                	mov    %esi,%ebx
  800b8d:	80 fb 19             	cmp    $0x19,%bl
  800b90:	77 08                	ja     800b9a <strtol+0x9d>
			dig = *s - 'a' + 10;
  800b92:	0f be d2             	movsbl %dl,%edx
  800b95:	83 ea 57             	sub    $0x57,%edx
  800b98:	eb 10                	jmp    800baa <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800b9a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b9d:	89 f3                	mov    %esi,%ebx
  800b9f:	80 fb 19             	cmp    $0x19,%bl
  800ba2:	77 16                	ja     800bba <strtol+0xbd>
			dig = *s - 'A' + 10;
  800ba4:	0f be d2             	movsbl %dl,%edx
  800ba7:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800baa:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bad:	7d 0b                	jge    800bba <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800baf:	83 c1 01             	add    $0x1,%ecx
  800bb2:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bb6:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800bb8:	eb b9                	jmp    800b73 <strtol+0x76>

	if (endptr)
  800bba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bbe:	74 0d                	je     800bcd <strtol+0xd0>
		*endptr = (char *) s;
  800bc0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bc3:	89 0e                	mov    %ecx,(%esi)
  800bc5:	eb 06                	jmp    800bcd <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bc7:	85 db                	test   %ebx,%ebx
  800bc9:	74 98                	je     800b63 <strtol+0x66>
  800bcb:	eb 9e                	jmp    800b6b <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800bcd:	89 c2                	mov    %eax,%edx
  800bcf:	f7 da                	neg    %edx
  800bd1:	85 ff                	test   %edi,%edi
  800bd3:	0f 45 c2             	cmovne %edx,%eax
}
  800bd6:	5b                   	pop    %ebx
  800bd7:	5e                   	pop    %esi
  800bd8:	5f                   	pop    %edi
  800bd9:	5d                   	pop    %ebp
  800bda:	c3                   	ret    

00800bdb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	57                   	push   %edi
  800bdf:	56                   	push   %esi
  800be0:	53                   	push   %ebx
  800be1:	83 ec 1c             	sub    $0x1c,%esp
  800be4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800be7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800bea:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800bf2:	8b 7d 10             	mov    0x10(%ebp),%edi
  800bf5:	8b 75 14             	mov    0x14(%ebp),%esi
  800bf8:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800bfa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bfe:	74 1d                	je     800c1d <syscall+0x42>
  800c00:	85 c0                	test   %eax,%eax
  800c02:	7e 19                	jle    800c1d <syscall+0x42>
  800c04:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800c07:	83 ec 0c             	sub    $0xc,%esp
  800c0a:	50                   	push   %eax
  800c0b:	52                   	push   %edx
  800c0c:	68 3f 28 80 00       	push   $0x80283f
  800c11:	6a 23                	push   $0x23
  800c13:	68 5c 28 80 00       	push   $0x80285c
  800c18:	e8 2b f6 ff ff       	call   800248 <_panic>

	return ret;
}
  800c1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c20:	5b                   	pop    %ebx
  800c21:	5e                   	pop    %esi
  800c22:	5f                   	pop    %edi
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    

00800c25 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800c2b:	6a 00                	push   $0x0
  800c2d:	6a 00                	push   $0x0
  800c2f:	6a 00                	push   $0x0
  800c31:	ff 75 0c             	pushl  0xc(%ebp)
  800c34:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c37:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c41:	e8 95 ff ff ff       	call   800bdb <syscall>
}
  800c46:	83 c4 10             	add    $0x10,%esp
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    

00800c4b <sys_cgetc>:

int
sys_cgetc(void)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800c51:	6a 00                	push   $0x0
  800c53:	6a 00                	push   $0x0
  800c55:	6a 00                	push   $0x0
  800c57:	6a 00                	push   $0x0
  800c59:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c63:	b8 01 00 00 00       	mov    $0x1,%eax
  800c68:	e8 6e ff ff ff       	call   800bdb <syscall>
}
  800c6d:	c9                   	leave  
  800c6e:	c3                   	ret    

00800c6f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800c75:	6a 00                	push   $0x0
  800c77:	6a 00                	push   $0x0
  800c79:	6a 00                	push   $0x0
  800c7b:	6a 00                	push   $0x0
  800c7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c80:	ba 01 00 00 00       	mov    $0x1,%edx
  800c85:	b8 03 00 00 00       	mov    $0x3,%eax
  800c8a:	e8 4c ff ff ff       	call   800bdb <syscall>
}
  800c8f:	c9                   	leave  
  800c90:	c3                   	ret    

00800c91 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800c97:	6a 00                	push   $0x0
  800c99:	6a 00                	push   $0x0
  800c9b:	6a 00                	push   $0x0
  800c9d:	6a 00                	push   $0x0
  800c9f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ca4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca9:	b8 02 00 00 00       	mov    $0x2,%eax
  800cae:	e8 28 ff ff ff       	call   800bdb <syscall>
}
  800cb3:	c9                   	leave  
  800cb4:	c3                   	ret    

00800cb5 <sys_yield>:

void
sys_yield(void)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800cbb:	6a 00                	push   $0x0
  800cbd:	6a 00                	push   $0x0
  800cbf:	6a 00                	push   $0x0
  800cc1:	6a 00                	push   $0x0
  800cc3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cc8:	ba 00 00 00 00       	mov    $0x0,%edx
  800ccd:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cd2:	e8 04 ff ff ff       	call   800bdb <syscall>
}
  800cd7:	83 c4 10             	add    $0x10,%esp
  800cda:	c9                   	leave  
  800cdb:	c3                   	ret    

00800cdc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800ce2:	6a 00                	push   $0x0
  800ce4:	6a 00                	push   $0x0
  800ce6:	ff 75 10             	pushl  0x10(%ebp)
  800ce9:	ff 75 0c             	pushl  0xc(%ebp)
  800cec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cef:	ba 01 00 00 00       	mov    $0x1,%edx
  800cf4:	b8 04 00 00 00       	mov    $0x4,%eax
  800cf9:	e8 dd fe ff ff       	call   800bdb <syscall>
}
  800cfe:	c9                   	leave  
  800cff:	c3                   	ret    

00800d00 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d00:	55                   	push   %ebp
  800d01:	89 e5                	mov    %esp,%ebp
  800d03:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800d06:	ff 75 18             	pushl  0x18(%ebp)
  800d09:	ff 75 14             	pushl  0x14(%ebp)
  800d0c:	ff 75 10             	pushl  0x10(%ebp)
  800d0f:	ff 75 0c             	pushl  0xc(%ebp)
  800d12:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d15:	ba 01 00 00 00       	mov    $0x1,%edx
  800d1a:	b8 05 00 00 00       	mov    $0x5,%eax
  800d1f:	e8 b7 fe ff ff       	call   800bdb <syscall>
}
  800d24:	c9                   	leave  
  800d25:	c3                   	ret    

00800d26 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800d2c:	6a 00                	push   $0x0
  800d2e:	6a 00                	push   $0x0
  800d30:	6a 00                	push   $0x0
  800d32:	ff 75 0c             	pushl  0xc(%ebp)
  800d35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d38:	ba 01 00 00 00       	mov    $0x1,%edx
  800d3d:	b8 06 00 00 00       	mov    $0x6,%eax
  800d42:	e8 94 fe ff ff       	call   800bdb <syscall>
}
  800d47:	c9                   	leave  
  800d48:	c3                   	ret    

00800d49 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800d4f:	6a 00                	push   $0x0
  800d51:	6a 00                	push   $0x0
  800d53:	6a 00                	push   $0x0
  800d55:	ff 75 0c             	pushl  0xc(%ebp)
  800d58:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d5b:	ba 01 00 00 00       	mov    $0x1,%edx
  800d60:	b8 08 00 00 00       	mov    $0x8,%eax
  800d65:	e8 71 fe ff ff       	call   800bdb <syscall>
}
  800d6a:	c9                   	leave  
  800d6b:	c3                   	ret    

00800d6c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800d72:	6a 00                	push   $0x0
  800d74:	6a 00                	push   $0x0
  800d76:	6a 00                	push   $0x0
  800d78:	ff 75 0c             	pushl  0xc(%ebp)
  800d7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d7e:	ba 01 00 00 00       	mov    $0x1,%edx
  800d83:	b8 09 00 00 00       	mov    $0x9,%eax
  800d88:	e8 4e fe ff ff       	call   800bdb <syscall>
}
  800d8d:	c9                   	leave  
  800d8e:	c3                   	ret    

00800d8f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800d95:	6a 00                	push   $0x0
  800d97:	6a 00                	push   $0x0
  800d99:	6a 00                	push   $0x0
  800d9b:	ff 75 0c             	pushl  0xc(%ebp)
  800d9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800da1:	ba 01 00 00 00       	mov    $0x1,%edx
  800da6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dab:	e8 2b fe ff ff       	call   800bdb <syscall>
}
  800db0:	c9                   	leave  
  800db1:	c3                   	ret    

00800db2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800db8:	6a 00                	push   $0x0
  800dba:	ff 75 14             	pushl  0x14(%ebp)
  800dbd:	ff 75 10             	pushl  0x10(%ebp)
  800dc0:	ff 75 0c             	pushl  0xc(%ebp)
  800dc3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dc6:	ba 00 00 00 00       	mov    $0x0,%edx
  800dcb:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dd0:	e8 06 fe ff ff       	call   800bdb <syscall>
}
  800dd5:	c9                   	leave  
  800dd6:	c3                   	ret    

00800dd7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800ddd:	6a 00                	push   $0x0
  800ddf:	6a 00                	push   $0x0
  800de1:	6a 00                	push   $0x0
  800de3:	6a 00                	push   $0x0
  800de5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800de8:	ba 01 00 00 00       	mov    $0x1,%edx
  800ded:	b8 0d 00 00 00       	mov    $0xd,%eax
  800df2:	e8 e4 fd ff ff       	call   800bdb <syscall>
}
  800df7:	c9                   	leave  
  800df8:	c3                   	ret    

00800df9 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	53                   	push   %ebx
  800dfd:	83 ec 04             	sub    $0x4,%esp

	int perm_w = PTE_COW|PTE_U|PTE_P;
	int perm = PTE_U|PTE_P;

	// LAB 4: Your code here.
	void *addr = (void*) (pn*PGSIZE);
  800e00:	89 d3                	mov    %edx,%ebx
  800e02:	c1 e3 0c             	shl    $0xc,%ebx

	//Si una página tiene el bit PTE_SHARE, se comparte con el hijo con los mismos permisos.
  	if (uvpt[pn] & PTE_SHARE) {
  800e05:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800e0c:	f6 c5 04             	test   $0x4,%ch
  800e0f:	74 3a                	je     800e4b <duppage+0x52>
    	if (sys_page_map(0, addr, envid,addr, uvpt[pn] & PTE_SYSCALL) < 0) {
  800e11:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e18:	83 ec 0c             	sub    $0xc,%esp
  800e1b:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800e21:	52                   	push   %edx
  800e22:	53                   	push   %ebx
  800e23:	50                   	push   %eax
  800e24:	53                   	push   %ebx
  800e25:	6a 00                	push   $0x0
  800e27:	e8 d4 fe ff ff       	call   800d00 <sys_page_map>
  800e2c:	83 c4 20             	add    $0x20,%esp
  800e2f:	85 c0                	test   %eax,%eax
  800e31:	0f 89 99 00 00 00    	jns    800ed0 <duppage+0xd7>
 	     	panic("Error en sys_page_map");
  800e37:	83 ec 04             	sub    $0x4,%esp
  800e3a:	68 6a 28 80 00       	push   $0x80286a
  800e3f:	6a 50                	push   $0x50
  800e41:	68 80 28 80 00       	push   $0x802880
  800e46:	e8 fd f3 ff ff       	call   800248 <_panic>
    	} 
    	return 0;
	}

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  800e4b:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800e52:	f6 c1 02             	test   $0x2,%cl
  800e55:	75 0c                	jne    800e63 <duppage+0x6a>
  800e57:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e5e:	f6 c6 08             	test   $0x8,%dh
  800e61:	74 5b                	je     800ebe <duppage+0xc5>
		if (sys_page_map(0, addr, envid, addr, perm_w) < 0){
  800e63:	83 ec 0c             	sub    $0xc,%esp
  800e66:	68 05 08 00 00       	push   $0x805
  800e6b:	53                   	push   %ebx
  800e6c:	50                   	push   %eax
  800e6d:	53                   	push   %ebx
  800e6e:	6a 00                	push   $0x0
  800e70:	e8 8b fe ff ff       	call   800d00 <sys_page_map>
  800e75:	83 c4 20             	add    $0x20,%esp
  800e78:	85 c0                	test   %eax,%eax
  800e7a:	79 14                	jns    800e90 <duppage+0x97>
			panic("Error mapeando pagina Padre");
  800e7c:	83 ec 04             	sub    $0x4,%esp
  800e7f:	68 8b 28 80 00       	push   $0x80288b
  800e84:	6a 57                	push   $0x57
  800e86:	68 80 28 80 00       	push   $0x802880
  800e8b:	e8 b8 f3 ff ff       	call   800248 <_panic>
		}
		if (sys_page_map(0, addr, 0, addr, perm_w) < 0){
  800e90:	83 ec 0c             	sub    $0xc,%esp
  800e93:	68 05 08 00 00       	push   $0x805
  800e98:	53                   	push   %ebx
  800e99:	6a 00                	push   $0x0
  800e9b:	53                   	push   %ebx
  800e9c:	6a 00                	push   $0x0
  800e9e:	e8 5d fe ff ff       	call   800d00 <sys_page_map>
  800ea3:	83 c4 20             	add    $0x20,%esp
  800ea6:	85 c0                	test   %eax,%eax
  800ea8:	79 26                	jns    800ed0 <duppage+0xd7>
			panic("Error mapeando pagina Hijo");
  800eaa:	83 ec 04             	sub    $0x4,%esp
  800ead:	68 a7 28 80 00       	push   $0x8028a7
  800eb2:	6a 5a                	push   $0x5a
  800eb4:	68 80 28 80 00       	push   $0x802880
  800eb9:	e8 8a f3 ff ff       	call   800248 <_panic>
		}
	} else sys_page_map(0, addr, envid, addr, perm);
  800ebe:	83 ec 0c             	sub    $0xc,%esp
  800ec1:	6a 05                	push   $0x5
  800ec3:	53                   	push   %ebx
  800ec4:	50                   	push   %eax
  800ec5:	53                   	push   %ebx
  800ec6:	6a 00                	push   $0x0
  800ec8:	e8 33 fe ff ff       	call   800d00 <sys_page_map>
  800ecd:	83 c4 20             	add    $0x20,%esp
	
	return 0;
}
  800ed0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ed8:	c9                   	leave  
  800ed9:	c3                   	ret    

00800eda <dup_or_share>:
//FORK V0

static void
dup_or_share(envid_t dstenv, void *va, int perm){
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	57                   	push   %edi
  800ede:	56                   	push   %esi
  800edf:	53                   	push   %ebx
  800ee0:	83 ec 0c             	sub    $0xc,%esp
  800ee3:	89 c7                	mov    %eax,%edi
  800ee5:	89 d6                	mov    %edx,%esi
  800ee7:	89 cb                	mov    %ecx,%ebx
	int result;
	// Si no es de escritura, comparto la pagina
	if((perm &PTE_W) != PTE_W){
  800ee9:	f6 c1 02             	test   $0x2,%cl
  800eec:	75 2d                	jne    800f1b <dup_or_share+0x41>
		if((result = sys_page_map(0, va, dstenv, va, perm))<0){
  800eee:	83 ec 0c             	sub    $0xc,%esp
  800ef1:	51                   	push   %ecx
  800ef2:	52                   	push   %edx
  800ef3:	50                   	push   %eax
  800ef4:	52                   	push   %edx
  800ef5:	6a 00                	push   $0x0
  800ef7:	e8 04 fe ff ff       	call   800d00 <sys_page_map>
  800efc:	83 c4 20             	add    $0x20,%esp
  800eff:	85 c0                	test   %eax,%eax
  800f01:	0f 89 a4 00 00 00    	jns    800fab <dup_or_share+0xd1>
			panic("Error compartiendo la pagina");
  800f07:	83 ec 04             	sub    $0x4,%esp
  800f0a:	68 c2 28 80 00       	push   $0x8028c2
  800f0f:	6a 68                	push   $0x68
  800f11:	68 80 28 80 00       	push   $0x802880
  800f16:	e8 2d f3 ff ff       	call   800248 <_panic>
		}
	// Si es de escritura comportamiento de duppage, en dumbfork
	}else{
		if ((result = sys_page_alloc(dstenv, va, perm)) < 0){
  800f1b:	83 ec 04             	sub    $0x4,%esp
  800f1e:	51                   	push   %ecx
  800f1f:	52                   	push   %edx
  800f20:	50                   	push   %eax
  800f21:	e8 b6 fd ff ff       	call   800cdc <sys_page_alloc>
  800f26:	83 c4 10             	add    $0x10,%esp
  800f29:	85 c0                	test   %eax,%eax
  800f2b:	79 14                	jns    800f41 <dup_or_share+0x67>
			panic("Error copiando la pagina");
  800f2d:	83 ec 04             	sub    $0x4,%esp
  800f30:	68 df 28 80 00       	push   $0x8028df
  800f35:	6a 6d                	push   $0x6d
  800f37:	68 80 28 80 00       	push   $0x802880
  800f3c:	e8 07 f3 ff ff       	call   800248 <_panic>
		}
		if ((result = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0){
  800f41:	83 ec 0c             	sub    $0xc,%esp
  800f44:	53                   	push   %ebx
  800f45:	68 00 00 40 00       	push   $0x400000
  800f4a:	6a 00                	push   $0x0
  800f4c:	56                   	push   %esi
  800f4d:	57                   	push   %edi
  800f4e:	e8 ad fd ff ff       	call   800d00 <sys_page_map>
  800f53:	83 c4 20             	add    $0x20,%esp
  800f56:	85 c0                	test   %eax,%eax
  800f58:	79 14                	jns    800f6e <dup_or_share+0x94>
			panic("Error copiando la pagina");
  800f5a:	83 ec 04             	sub    $0x4,%esp
  800f5d:	68 df 28 80 00       	push   $0x8028df
  800f62:	6a 70                	push   $0x70
  800f64:	68 80 28 80 00       	push   $0x802880
  800f69:	e8 da f2 ff ff       	call   800248 <_panic>
		}
		memmove(UTEMP, va, PGSIZE);
  800f6e:	83 ec 04             	sub    $0x4,%esp
  800f71:	68 00 10 00 00       	push   $0x1000
  800f76:	56                   	push   %esi
  800f77:	68 00 00 40 00       	push   $0x400000
  800f7c:	e8 a5 fa ff ff       	call   800a26 <memmove>
		if ((result = sys_page_unmap(0, UTEMP)) < 0){
  800f81:	83 c4 08             	add    $0x8,%esp
  800f84:	68 00 00 40 00       	push   $0x400000
  800f89:	6a 00                	push   $0x0
  800f8b:	e8 96 fd ff ff       	call   800d26 <sys_page_unmap>
  800f90:	83 c4 10             	add    $0x10,%esp
  800f93:	85 c0                	test   %eax,%eax
  800f95:	79 14                	jns    800fab <dup_or_share+0xd1>
			panic("Error copiando la pagina");
  800f97:	83 ec 04             	sub    $0x4,%esp
  800f9a:	68 df 28 80 00       	push   $0x8028df
  800f9f:	6a 74                	push   $0x74
  800fa1:	68 80 28 80 00       	push   $0x802880
  800fa6:	e8 9d f2 ff ff       	call   800248 <_panic>
		}
	}	
}
  800fab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fae:	5b                   	pop    %ebx
  800faf:	5e                   	pop    %esi
  800fb0:	5f                   	pop    %edi
  800fb1:	5d                   	pop    %ebp
  800fb2:	c3                   	ret    

00800fb3 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	53                   	push   %ebx
  800fb7:	83 ec 04             	sub    $0x4,%esp
  800fba:	8b 55 08             	mov    0x8(%ebp),%edx
	void *va = (void *) utf->utf_fault_va;
  800fbd:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800fbf:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  800fc3:	74 2e                	je     800ff3 <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
  800fc5:	89 c2                	mov    %eax,%edx
  800fc7:	c1 ea 16             	shr    $0x16,%edx
  800fca:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800fd1:	f6 c2 01             	test   $0x1,%dl
  800fd4:	74 1d                	je     800ff3 <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
  800fd6:	89 c2                	mov    %eax,%edx
  800fd8:	c1 ea 0c             	shr    $0xc,%edx
  800fdb:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
		(uvpd[PDX(va)] & PTE_P) && 
  800fe2:	f6 c1 01             	test   $0x1,%cl
  800fe5:	74 0c                	je     800ff3 <pgfault+0x40>
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
  800fe7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800fee:	f6 c6 08             	test   $0x8,%dh
  800ff1:	75 14                	jne    801007 <pgfault+0x54>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
		panic("No es copy-on-write");
  800ff3:	83 ec 04             	sub    $0x4,%esp
  800ff6:	68 f8 28 80 00       	push   $0x8028f8
  800ffb:	6a 21                	push   $0x21
  800ffd:	68 80 28 80 00       	push   $0x802880
  801002:	e8 41 f2 ff ff       	call   800248 <_panic>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	va = ROUNDDOWN(va, PGSIZE);
  801007:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80100c:	89 c3                	mov    %eax,%ebx
	if (sys_page_alloc(0, PFTEMP, perm) < 0){
  80100e:	83 ec 04             	sub    $0x4,%esp
  801011:	6a 07                	push   $0x7
  801013:	68 00 f0 7f 00       	push   $0x7ff000
  801018:	6a 00                	push   $0x0
  80101a:	e8 bd fc ff ff       	call   800cdc <sys_page_alloc>
  80101f:	83 c4 10             	add    $0x10,%esp
  801022:	85 c0                	test   %eax,%eax
  801024:	79 14                	jns    80103a <pgfault+0x87>
		panic("Error sys_page_alloc");
  801026:	83 ec 04             	sub    $0x4,%esp
  801029:	68 0c 29 80 00       	push   $0x80290c
  80102e:	6a 2a                	push   $0x2a
  801030:	68 80 28 80 00       	push   $0x802880
  801035:	e8 0e f2 ff ff       	call   800248 <_panic>
	}
	memcpy(PFTEMP, va, PGSIZE);
  80103a:	83 ec 04             	sub    $0x4,%esp
  80103d:	68 00 10 00 00       	push   $0x1000
  801042:	53                   	push   %ebx
  801043:	68 00 f0 7f 00       	push   $0x7ff000
  801048:	e8 41 fa ff ff       	call   800a8e <memcpy>
	if (sys_page_map(0, PFTEMP, 0, va, perm) < 0){
  80104d:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801054:	53                   	push   %ebx
  801055:	6a 00                	push   $0x0
  801057:	68 00 f0 7f 00       	push   $0x7ff000
  80105c:	6a 00                	push   $0x0
  80105e:	e8 9d fc ff ff       	call   800d00 <sys_page_map>
  801063:	83 c4 20             	add    $0x20,%esp
  801066:	85 c0                	test   %eax,%eax
  801068:	79 14                	jns    80107e <pgfault+0xcb>
		panic("Error sys_page_map");
  80106a:	83 ec 04             	sub    $0x4,%esp
  80106d:	68 21 29 80 00       	push   $0x802921
  801072:	6a 2e                	push   $0x2e
  801074:	68 80 28 80 00       	push   $0x802880
  801079:	e8 ca f1 ff ff       	call   800248 <_panic>
	}
	if (sys_page_unmap(0, PFTEMP) < 0){
  80107e:	83 ec 08             	sub    $0x8,%esp
  801081:	68 00 f0 7f 00       	push   $0x7ff000
  801086:	6a 00                	push   $0x0
  801088:	e8 99 fc ff ff       	call   800d26 <sys_page_unmap>
  80108d:	83 c4 10             	add    $0x10,%esp
  801090:	85 c0                	test   %eax,%eax
  801092:	79 14                	jns    8010a8 <pgfault+0xf5>
		panic("Error sys_page_unmap");
  801094:	83 ec 04             	sub    $0x4,%esp
  801097:	68 34 29 80 00       	push   $0x802934
  80109c:	6a 31                	push   $0x31
  80109e:	68 80 28 80 00       	push   $0x802880
  8010a3:	e8 a0 f1 ff ff       	call   800248 <_panic>
	}
	return;

}
  8010a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010ab:	c9                   	leave  
  8010ac:	c3                   	ret    

008010ad <fork_v0>:
		}
	}	
}

envid_t
fork_v0(void){
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	57                   	push   %edi
  8010b1:	56                   	push   %esi
  8010b2:	53                   	push   %ebx
  8010b3:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010b6:	b8 07 00 00 00       	mov    $0x7,%eax
  8010bb:	cd 30                	int    $0x30
  8010bd:	89 c6                	mov    %eax,%esi
	envid_t envid;
	uint8_t *va;
	int result;	

	envid = sys_exofork();
	if (envid < 0)
  8010bf:	85 c0                	test   %eax,%eax
  8010c1:	79 15                	jns    8010d8 <fork_v0+0x2b>
		panic("sys_exofork: %e", envid);
  8010c3:	50                   	push   %eax
  8010c4:	68 49 29 80 00       	push   $0x802949
  8010c9:	68 81 00 00 00       	push   $0x81
  8010ce:	68 80 28 80 00       	push   $0x802880
  8010d3:	e8 70 f1 ff ff       	call   800248 <_panic>
  8010d8:	89 c7                	mov    %eax,%edi
  8010da:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {		
  8010df:	85 c0                	test   %eax,%eax
  8010e1:	75 1e                	jne    801101 <fork_v0+0x54>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010e3:	e8 a9 fb ff ff       	call   800c91 <sys_getenvid>
  8010e8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010ed:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010f0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010f5:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8010fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ff:	eb 7a                	jmp    80117b <fork_v0+0xce>
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  801101:	89 d8                	mov    %ebx,%eax
  801103:	c1 e8 16             	shr    $0x16,%eax
  801106:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80110d:	a8 01                	test   $0x1,%al
  80110f:	74 33                	je     801144 <fork_v0+0x97>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  801111:	89 d8                	mov    %ebx,%eax
  801113:	c1 e8 0c             	shr    $0xc,%eax
  801116:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80111d:	f6 c2 01             	test   $0x1,%dl
  801120:	74 22                	je     801144 <fork_v0+0x97>
  801122:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801129:	f6 c2 04             	test   $0x4,%dl
  80112c:	74 16                	je     801144 <fork_v0+0x97>
				pte_t pte =uvpt[PGNUM(va)];
  80112e:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
  801135:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80113b:	89 da                	mov    %ebx,%edx
  80113d:	89 f8                	mov    %edi,%eax
  80113f:	e8 96 fd ff ff       	call   800eda <dup_or_share>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
  801144:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80114a:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801150:	75 af                	jne    801101 <fork_v0+0x54>
				pte_t pte =uvpt[PGNUM(va)];
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
			}
		}
	}	
	if ((result = sys_env_set_status(envid, ENV_RUNNABLE)) < 0){
  801152:	83 ec 08             	sub    $0x8,%esp
  801155:	6a 02                	push   $0x2
  801157:	56                   	push   %esi
  801158:	e8 ec fb ff ff       	call   800d49 <sys_env_set_status>
  80115d:	83 c4 10             	add    $0x10,%esp
  801160:	85 c0                	test   %eax,%eax
  801162:	79 15                	jns    801179 <fork_v0+0xcc>

		panic("sys_env_set_status: %e", result);
  801164:	50                   	push   %eax
  801165:	68 59 29 80 00       	push   $0x802959
  80116a:	68 90 00 00 00       	push   $0x90
  80116f:	68 80 28 80 00       	push   $0x802880
  801174:	e8 cf f0 ff ff       	call   800248 <_panic>
	}
	return envid;
  801179:	89 f0                	mov    %esi,%eax
}
  80117b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80117e:	5b                   	pop    %ebx
  80117f:	5e                   	pop    %esi
  801180:	5f                   	pop    %edi
  801181:	5d                   	pop    %ebp
  801182:	c3                   	ret    

00801183 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
  801186:	57                   	push   %edi
  801187:	56                   	push   %esi
  801188:	53                   	push   %ebx
  801189:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  80118c:	68 b3 0f 80 00       	push   $0x800fb3
  801191:	e8 5a 0f 00 00       	call   8020f0 <set_pgfault_handler>
  801196:	b8 07 00 00 00       	mov    $0x7,%eax
  80119b:	cd 30                	int    $0x30
  80119d:	89 c6                	mov    %eax,%esi

	envid_t envid;
	uint32_t va;
	envid = sys_exofork();
	if (envid < 0){
  80119f:	83 c4 10             	add    $0x10,%esp
  8011a2:	85 c0                	test   %eax,%eax
  8011a4:	79 15                	jns    8011bb <fork+0x38>
		panic("sys_exofork: %e", envid);
  8011a6:	50                   	push   %eax
  8011a7:	68 49 29 80 00       	push   $0x802949
  8011ac:	68 b1 00 00 00       	push   $0xb1
  8011b1:	68 80 28 80 00       	push   $0x802880
  8011b6:	e8 8d f0 ff ff       	call   800248 <_panic>
  8011bb:	89 c7                	mov    %eax,%edi
  8011bd:	bb 00 00 00 00       	mov    $0x0,%ebx
	}
	if (envid == 0) {		
  8011c2:	85 c0                	test   %eax,%eax
  8011c4:	75 21                	jne    8011e7 <fork+0x64>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011c6:	e8 c6 fa ff ff       	call   800c91 <sys_getenvid>
  8011cb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011d0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011d3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011d8:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8011dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e2:	e9 a7 00 00 00       	jmp    80128e <fork+0x10b>
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  8011e7:	89 d8                	mov    %ebx,%eax
  8011e9:	c1 e8 16             	shr    $0x16,%eax
  8011ec:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011f3:	a8 01                	test   $0x1,%al
  8011f5:	74 22                	je     801219 <fork+0x96>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  8011f7:	89 da                	mov    %ebx,%edx
  8011f9:	c1 ea 0c             	shr    $0xc,%edx
  8011fc:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801203:	a8 01                	test   $0x1,%al
  801205:	74 12                	je     801219 <fork+0x96>
  801207:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80120e:	a8 04                	test   $0x4,%al
  801210:	74 07                	je     801219 <fork+0x96>
				duppage(envid, PGNUM(va));			
  801212:	89 f8                	mov    %edi,%eax
  801214:	e8 e0 fb ff ff       	call   800df9 <duppage>
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
  801219:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80121f:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801225:	75 c0                	jne    8011e7 <fork+0x64>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
				duppage(envid, PGNUM(va));			
			}
		}
	}
	if (sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P) < 0){
  801227:	83 ec 04             	sub    $0x4,%esp
  80122a:	6a 07                	push   $0x7
  80122c:	68 00 f0 bf ee       	push   $0xeebff000
  801231:	56                   	push   %esi
  801232:	e8 a5 fa ff ff       	call   800cdc <sys_page_alloc>
  801237:	83 c4 10             	add    $0x10,%esp
  80123a:	85 c0                	test   %eax,%eax
  80123c:	79 17                	jns    801255 <fork+0xd2>
		panic("Se escribio en la pagina de excepciones");
  80123e:	83 ec 04             	sub    $0x4,%esp
  801241:	68 88 29 80 00       	push   $0x802988
  801246:	68 c0 00 00 00       	push   $0xc0
  80124b:	68 80 28 80 00       	push   $0x802880
  801250:	e8 f3 ef ff ff       	call   800248 <_panic>
	}	
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801255:	83 ec 08             	sub    $0x8,%esp
  801258:	68 5f 21 80 00       	push   $0x80215f
  80125d:	56                   	push   %esi
  80125e:	e8 2c fb ff ff       	call   800d8f <sys_env_set_pgfault_upcall>

	if (sys_env_set_status(envid, ENV_RUNNABLE) < 0)
  801263:	83 c4 08             	add    $0x8,%esp
  801266:	6a 02                	push   $0x2
  801268:	56                   	push   %esi
  801269:	e8 db fa ff ff       	call   800d49 <sys_env_set_status>
  80126e:	83 c4 10             	add    $0x10,%esp
  801271:	85 c0                	test   %eax,%eax
  801273:	79 17                	jns    80128c <fork+0x109>
		panic("Status incorrecto de enviroment");
  801275:	83 ec 04             	sub    $0x4,%esp
  801278:	68 b0 29 80 00       	push   $0x8029b0
  80127d:	68 c5 00 00 00       	push   $0xc5
  801282:	68 80 28 80 00       	push   $0x802880
  801287:	e8 bc ef ff ff       	call   800248 <_panic>

	return envid;
  80128c:	89 f0                	mov    %esi,%eax
	
}
  80128e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801291:	5b                   	pop    %ebx
  801292:	5e                   	pop    %esi
  801293:	5f                   	pop    %edi
  801294:	5d                   	pop    %ebp
  801295:	c3                   	ret    

00801296 <sfork>:


// Challenge!
int
sfork(void)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80129c:	68 70 29 80 00       	push   $0x802970
  8012a1:	68 d1 00 00 00       	push   $0xd1
  8012a6:	68 80 28 80 00       	push   $0x802880
  8012ab:	e8 98 ef ff ff       	call   800248 <_panic>

008012b0 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	56                   	push   %esi
  8012b4:	53                   	push   %ebx
  8012b5:	8b 75 08             	mov    0x8(%ebp),%esi
  8012b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  8012be:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  8012c0:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8012c5:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  8012c8:	83 ec 0c             	sub    $0xc,%esp
  8012cb:	50                   	push   %eax
  8012cc:	e8 06 fb ff ff       	call   800dd7 <sys_ipc_recv>
	if (from_env_store)
  8012d1:	83 c4 10             	add    $0x10,%esp
  8012d4:	85 f6                	test   %esi,%esi
  8012d6:	74 0b                	je     8012e3 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  8012d8:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8012de:	8b 52 74             	mov    0x74(%edx),%edx
  8012e1:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8012e3:	85 db                	test   %ebx,%ebx
  8012e5:	74 0b                	je     8012f2 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  8012e7:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8012ed:	8b 52 78             	mov    0x78(%edx),%edx
  8012f0:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  8012f2:	85 c0                	test   %eax,%eax
  8012f4:	79 16                	jns    80130c <ipc_recv+0x5c>
		if (from_env_store)
  8012f6:	85 f6                	test   %esi,%esi
  8012f8:	74 06                	je     801300 <ipc_recv+0x50>
			*from_env_store = 0;
  8012fa:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  801300:	85 db                	test   %ebx,%ebx
  801302:	74 10                	je     801314 <ipc_recv+0x64>
			*perm_store = 0;
  801304:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80130a:	eb 08                	jmp    801314 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  80130c:	a1 04 40 80 00       	mov    0x804004,%eax
  801311:	8b 40 70             	mov    0x70(%eax),%eax
}
  801314:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801317:	5b                   	pop    %ebx
  801318:	5e                   	pop    %esi
  801319:	5d                   	pop    %ebp
  80131a:	c3                   	ret    

0080131b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
  80131e:	57                   	push   %edi
  80131f:	56                   	push   %esi
  801320:	53                   	push   %ebx
  801321:	83 ec 0c             	sub    $0xc,%esp
  801324:	8b 7d 08             	mov    0x8(%ebp),%edi
  801327:	8b 75 0c             	mov    0xc(%ebp),%esi
  80132a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  80132d:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  80132f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801334:	0f 44 d8             	cmove  %eax,%ebx
  801337:	eb 1c                	jmp    801355 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  801339:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80133c:	74 12                	je     801350 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  80133e:	50                   	push   %eax
  80133f:	68 d0 29 80 00       	push   $0x8029d0
  801344:	6a 42                	push   $0x42
  801346:	68 e6 29 80 00       	push   $0x8029e6
  80134b:	e8 f8 ee ff ff       	call   800248 <_panic>
		sys_yield();
  801350:	e8 60 f9 ff ff       	call   800cb5 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801355:	ff 75 14             	pushl  0x14(%ebp)
  801358:	53                   	push   %ebx
  801359:	56                   	push   %esi
  80135a:	57                   	push   %edi
  80135b:	e8 52 fa ff ff       	call   800db2 <sys_ipc_try_send>
  801360:	83 c4 10             	add    $0x10,%esp
  801363:	85 c0                	test   %eax,%eax
  801365:	75 d2                	jne    801339 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801367:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80136a:	5b                   	pop    %ebx
  80136b:	5e                   	pop    %esi
  80136c:	5f                   	pop    %edi
  80136d:	5d                   	pop    %ebp
  80136e:	c3                   	ret    

0080136f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
  801372:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801375:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80137a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80137d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801383:	8b 52 50             	mov    0x50(%edx),%edx
  801386:	39 ca                	cmp    %ecx,%edx
  801388:	75 0d                	jne    801397 <ipc_find_env+0x28>
			return envs[i].env_id;
  80138a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80138d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801392:	8b 40 48             	mov    0x48(%eax),%eax
  801395:	eb 0f                	jmp    8013a6 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801397:	83 c0 01             	add    $0x1,%eax
  80139a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80139f:	75 d9                	jne    80137a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8013a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a6:	5d                   	pop    %ebp
  8013a7:	c3                   	ret    

008013a8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ae:	05 00 00 00 30       	add    $0x30000000,%eax
  8013b3:	c1 e8 0c             	shr    $0xc,%eax
}
  8013b6:	5d                   	pop    %ebp
  8013b7:	c3                   	ret    

008013b8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  8013bb:	ff 75 08             	pushl  0x8(%ebp)
  8013be:	e8 e5 ff ff ff       	call   8013a8 <fd2num>
  8013c3:	83 c4 04             	add    $0x4,%esp
  8013c6:	c1 e0 0c             	shl    $0xc,%eax
  8013c9:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013ce:	c9                   	leave  
  8013cf:	c3                   	ret    

008013d0 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013d6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013db:	89 c2                	mov    %eax,%edx
  8013dd:	c1 ea 16             	shr    $0x16,%edx
  8013e0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013e7:	f6 c2 01             	test   $0x1,%dl
  8013ea:	74 11                	je     8013fd <fd_alloc+0x2d>
  8013ec:	89 c2                	mov    %eax,%edx
  8013ee:	c1 ea 0c             	shr    $0xc,%edx
  8013f1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013f8:	f6 c2 01             	test   $0x1,%dl
  8013fb:	75 09                	jne    801406 <fd_alloc+0x36>
			*fd_store = fd;
  8013fd:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801404:	eb 17                	jmp    80141d <fd_alloc+0x4d>
  801406:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80140b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801410:	75 c9                	jne    8013db <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801412:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801418:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80141d:	5d                   	pop    %ebp
  80141e:	c3                   	ret    

0080141f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801425:	83 f8 1f             	cmp    $0x1f,%eax
  801428:	77 36                	ja     801460 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80142a:	c1 e0 0c             	shl    $0xc,%eax
  80142d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801432:	89 c2                	mov    %eax,%edx
  801434:	c1 ea 16             	shr    $0x16,%edx
  801437:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80143e:	f6 c2 01             	test   $0x1,%dl
  801441:	74 24                	je     801467 <fd_lookup+0x48>
  801443:	89 c2                	mov    %eax,%edx
  801445:	c1 ea 0c             	shr    $0xc,%edx
  801448:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80144f:	f6 c2 01             	test   $0x1,%dl
  801452:	74 1a                	je     80146e <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801454:	8b 55 0c             	mov    0xc(%ebp),%edx
  801457:	89 02                	mov    %eax,(%edx)
	return 0;
  801459:	b8 00 00 00 00       	mov    $0x0,%eax
  80145e:	eb 13                	jmp    801473 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801460:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801465:	eb 0c                	jmp    801473 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801467:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80146c:	eb 05                	jmp    801473 <fd_lookup+0x54>
  80146e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  801473:	5d                   	pop    %ebp
  801474:	c3                   	ret    

00801475 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
  801478:	83 ec 08             	sub    $0x8,%esp
  80147b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80147e:	ba 6c 2a 80 00       	mov    $0x802a6c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801483:	eb 13                	jmp    801498 <dev_lookup+0x23>
  801485:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  801488:	39 08                	cmp    %ecx,(%eax)
  80148a:	75 0c                	jne    801498 <dev_lookup+0x23>
			*dev = devtab[i];
  80148c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80148f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801491:	b8 00 00 00 00       	mov    $0x0,%eax
  801496:	eb 2e                	jmp    8014c6 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801498:	8b 02                	mov    (%edx),%eax
  80149a:	85 c0                	test   %eax,%eax
  80149c:	75 e7                	jne    801485 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80149e:	a1 04 40 80 00       	mov    0x804004,%eax
  8014a3:	8b 40 48             	mov    0x48(%eax),%eax
  8014a6:	83 ec 04             	sub    $0x4,%esp
  8014a9:	51                   	push   %ecx
  8014aa:	50                   	push   %eax
  8014ab:	68 f0 29 80 00       	push   $0x8029f0
  8014b0:	e8 6c ee ff ff       	call   800321 <cprintf>
	*dev = 0;
  8014b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014be:	83 c4 10             	add    $0x10,%esp
  8014c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014c6:	c9                   	leave  
  8014c7:	c3                   	ret    

008014c8 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
  8014cb:	56                   	push   %esi
  8014cc:	53                   	push   %ebx
  8014cd:	83 ec 10             	sub    $0x10,%esp
  8014d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8014d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014d6:	56                   	push   %esi
  8014d7:	e8 cc fe ff ff       	call   8013a8 <fd2num>
  8014dc:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8014df:	89 14 24             	mov    %edx,(%esp)
  8014e2:	50                   	push   %eax
  8014e3:	e8 37 ff ff ff       	call   80141f <fd_lookup>
  8014e8:	83 c4 08             	add    $0x8,%esp
  8014eb:	85 c0                	test   %eax,%eax
  8014ed:	78 05                	js     8014f4 <fd_close+0x2c>
	    || fd != fd2)
  8014ef:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8014f2:	74 0c                	je     801500 <fd_close+0x38>
		return (must_exist ? r : 0);
  8014f4:	84 db                	test   %bl,%bl
  8014f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8014fb:	0f 44 c2             	cmove  %edx,%eax
  8014fe:	eb 41                	jmp    801541 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801500:	83 ec 08             	sub    $0x8,%esp
  801503:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801506:	50                   	push   %eax
  801507:	ff 36                	pushl  (%esi)
  801509:	e8 67 ff ff ff       	call   801475 <dev_lookup>
  80150e:	89 c3                	mov    %eax,%ebx
  801510:	83 c4 10             	add    $0x10,%esp
  801513:	85 c0                	test   %eax,%eax
  801515:	78 1a                	js     801531 <fd_close+0x69>
		if (dev->dev_close)
  801517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151a:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80151d:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801522:	85 c0                	test   %eax,%eax
  801524:	74 0b                	je     801531 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  801526:	83 ec 0c             	sub    $0xc,%esp
  801529:	56                   	push   %esi
  80152a:	ff d0                	call   *%eax
  80152c:	89 c3                	mov    %eax,%ebx
  80152e:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801531:	83 ec 08             	sub    $0x8,%esp
  801534:	56                   	push   %esi
  801535:	6a 00                	push   $0x0
  801537:	e8 ea f7 ff ff       	call   800d26 <sys_page_unmap>
	return r;
  80153c:	83 c4 10             	add    $0x10,%esp
  80153f:	89 d8                	mov    %ebx,%eax
}
  801541:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801544:	5b                   	pop    %ebx
  801545:	5e                   	pop    %esi
  801546:	5d                   	pop    %ebp
  801547:	c3                   	ret    

00801548 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80154e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801551:	50                   	push   %eax
  801552:	ff 75 08             	pushl  0x8(%ebp)
  801555:	e8 c5 fe ff ff       	call   80141f <fd_lookup>
  80155a:	83 c4 08             	add    $0x8,%esp
  80155d:	85 c0                	test   %eax,%eax
  80155f:	78 10                	js     801571 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801561:	83 ec 08             	sub    $0x8,%esp
  801564:	6a 01                	push   $0x1
  801566:	ff 75 f4             	pushl  -0xc(%ebp)
  801569:	e8 5a ff ff ff       	call   8014c8 <fd_close>
  80156e:	83 c4 10             	add    $0x10,%esp
}
  801571:	c9                   	leave  
  801572:	c3                   	ret    

00801573 <close_all>:

void
close_all(void)
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
  801576:	53                   	push   %ebx
  801577:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80157a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80157f:	83 ec 0c             	sub    $0xc,%esp
  801582:	53                   	push   %ebx
  801583:	e8 c0 ff ff ff       	call   801548 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801588:	83 c3 01             	add    $0x1,%ebx
  80158b:	83 c4 10             	add    $0x10,%esp
  80158e:	83 fb 20             	cmp    $0x20,%ebx
  801591:	75 ec                	jne    80157f <close_all+0xc>
		close(i);
}
  801593:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	57                   	push   %edi
  80159c:	56                   	push   %esi
  80159d:	53                   	push   %ebx
  80159e:	83 ec 2c             	sub    $0x2c,%esp
  8015a1:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015a4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015a7:	50                   	push   %eax
  8015a8:	ff 75 08             	pushl  0x8(%ebp)
  8015ab:	e8 6f fe ff ff       	call   80141f <fd_lookup>
  8015b0:	83 c4 08             	add    $0x8,%esp
  8015b3:	85 c0                	test   %eax,%eax
  8015b5:	0f 88 c1 00 00 00    	js     80167c <dup+0xe4>
		return r;
	close(newfdnum);
  8015bb:	83 ec 0c             	sub    $0xc,%esp
  8015be:	56                   	push   %esi
  8015bf:	e8 84 ff ff ff       	call   801548 <close>

	newfd = INDEX2FD(newfdnum);
  8015c4:	89 f3                	mov    %esi,%ebx
  8015c6:	c1 e3 0c             	shl    $0xc,%ebx
  8015c9:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8015cf:	83 c4 04             	add    $0x4,%esp
  8015d2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015d5:	e8 de fd ff ff       	call   8013b8 <fd2data>
  8015da:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  8015dc:	89 1c 24             	mov    %ebx,(%esp)
  8015df:	e8 d4 fd ff ff       	call   8013b8 <fd2data>
  8015e4:	83 c4 10             	add    $0x10,%esp
  8015e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015ea:	89 f8                	mov    %edi,%eax
  8015ec:	c1 e8 16             	shr    $0x16,%eax
  8015ef:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015f6:	a8 01                	test   $0x1,%al
  8015f8:	74 37                	je     801631 <dup+0x99>
  8015fa:	89 f8                	mov    %edi,%eax
  8015fc:	c1 e8 0c             	shr    $0xc,%eax
  8015ff:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801606:	f6 c2 01             	test   $0x1,%dl
  801609:	74 26                	je     801631 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80160b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801612:	83 ec 0c             	sub    $0xc,%esp
  801615:	25 07 0e 00 00       	and    $0xe07,%eax
  80161a:	50                   	push   %eax
  80161b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80161e:	6a 00                	push   $0x0
  801620:	57                   	push   %edi
  801621:	6a 00                	push   $0x0
  801623:	e8 d8 f6 ff ff       	call   800d00 <sys_page_map>
  801628:	89 c7                	mov    %eax,%edi
  80162a:	83 c4 20             	add    $0x20,%esp
  80162d:	85 c0                	test   %eax,%eax
  80162f:	78 2e                	js     80165f <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801631:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801634:	89 d0                	mov    %edx,%eax
  801636:	c1 e8 0c             	shr    $0xc,%eax
  801639:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801640:	83 ec 0c             	sub    $0xc,%esp
  801643:	25 07 0e 00 00       	and    $0xe07,%eax
  801648:	50                   	push   %eax
  801649:	53                   	push   %ebx
  80164a:	6a 00                	push   $0x0
  80164c:	52                   	push   %edx
  80164d:	6a 00                	push   $0x0
  80164f:	e8 ac f6 ff ff       	call   800d00 <sys_page_map>
  801654:	89 c7                	mov    %eax,%edi
  801656:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  801659:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80165b:	85 ff                	test   %edi,%edi
  80165d:	79 1d                	jns    80167c <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80165f:	83 ec 08             	sub    $0x8,%esp
  801662:	53                   	push   %ebx
  801663:	6a 00                	push   $0x0
  801665:	e8 bc f6 ff ff       	call   800d26 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80166a:	83 c4 08             	add    $0x8,%esp
  80166d:	ff 75 d4             	pushl  -0x2c(%ebp)
  801670:	6a 00                	push   $0x0
  801672:	e8 af f6 ff ff       	call   800d26 <sys_page_unmap>
	return r;
  801677:	83 c4 10             	add    $0x10,%esp
  80167a:	89 f8                	mov    %edi,%eax
}
  80167c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80167f:	5b                   	pop    %ebx
  801680:	5e                   	pop    %esi
  801681:	5f                   	pop    %edi
  801682:	5d                   	pop    %ebp
  801683:	c3                   	ret    

00801684 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	53                   	push   %ebx
  801688:	83 ec 14             	sub    $0x14,%esp
  80168b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80168e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801691:	50                   	push   %eax
  801692:	53                   	push   %ebx
  801693:	e8 87 fd ff ff       	call   80141f <fd_lookup>
  801698:	83 c4 08             	add    $0x8,%esp
  80169b:	89 c2                	mov    %eax,%edx
  80169d:	85 c0                	test   %eax,%eax
  80169f:	78 6d                	js     80170e <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a1:	83 ec 08             	sub    $0x8,%esp
  8016a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a7:	50                   	push   %eax
  8016a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ab:	ff 30                	pushl  (%eax)
  8016ad:	e8 c3 fd ff ff       	call   801475 <dev_lookup>
  8016b2:	83 c4 10             	add    $0x10,%esp
  8016b5:	85 c0                	test   %eax,%eax
  8016b7:	78 4c                	js     801705 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016bc:	8b 42 08             	mov    0x8(%edx),%eax
  8016bf:	83 e0 03             	and    $0x3,%eax
  8016c2:	83 f8 01             	cmp    $0x1,%eax
  8016c5:	75 21                	jne    8016e8 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016c7:	a1 04 40 80 00       	mov    0x804004,%eax
  8016cc:	8b 40 48             	mov    0x48(%eax),%eax
  8016cf:	83 ec 04             	sub    $0x4,%esp
  8016d2:	53                   	push   %ebx
  8016d3:	50                   	push   %eax
  8016d4:	68 31 2a 80 00       	push   $0x802a31
  8016d9:	e8 43 ec ff ff       	call   800321 <cprintf>
		return -E_INVAL;
  8016de:	83 c4 10             	add    $0x10,%esp
  8016e1:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8016e6:	eb 26                	jmp    80170e <read+0x8a>
	}
	if (!dev->dev_read)
  8016e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016eb:	8b 40 08             	mov    0x8(%eax),%eax
  8016ee:	85 c0                	test   %eax,%eax
  8016f0:	74 17                	je     801709 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016f2:	83 ec 04             	sub    $0x4,%esp
  8016f5:	ff 75 10             	pushl  0x10(%ebp)
  8016f8:	ff 75 0c             	pushl  0xc(%ebp)
  8016fb:	52                   	push   %edx
  8016fc:	ff d0                	call   *%eax
  8016fe:	89 c2                	mov    %eax,%edx
  801700:	83 c4 10             	add    $0x10,%esp
  801703:	eb 09                	jmp    80170e <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801705:	89 c2                	mov    %eax,%edx
  801707:	eb 05                	jmp    80170e <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801709:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  80170e:	89 d0                	mov    %edx,%eax
  801710:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	57                   	push   %edi
  801719:	56                   	push   %esi
  80171a:	53                   	push   %ebx
  80171b:	83 ec 0c             	sub    $0xc,%esp
  80171e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801721:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801724:	bb 00 00 00 00       	mov    $0x0,%ebx
  801729:	eb 21                	jmp    80174c <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80172b:	83 ec 04             	sub    $0x4,%esp
  80172e:	89 f0                	mov    %esi,%eax
  801730:	29 d8                	sub    %ebx,%eax
  801732:	50                   	push   %eax
  801733:	89 d8                	mov    %ebx,%eax
  801735:	03 45 0c             	add    0xc(%ebp),%eax
  801738:	50                   	push   %eax
  801739:	57                   	push   %edi
  80173a:	e8 45 ff ff ff       	call   801684 <read>
		if (m < 0)
  80173f:	83 c4 10             	add    $0x10,%esp
  801742:	85 c0                	test   %eax,%eax
  801744:	78 10                	js     801756 <readn+0x41>
			return m;
		if (m == 0)
  801746:	85 c0                	test   %eax,%eax
  801748:	74 0a                	je     801754 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80174a:	01 c3                	add    %eax,%ebx
  80174c:	39 f3                	cmp    %esi,%ebx
  80174e:	72 db                	jb     80172b <readn+0x16>
  801750:	89 d8                	mov    %ebx,%eax
  801752:	eb 02                	jmp    801756 <readn+0x41>
  801754:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801756:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801759:	5b                   	pop    %ebx
  80175a:	5e                   	pop    %esi
  80175b:	5f                   	pop    %edi
  80175c:	5d                   	pop    %ebp
  80175d:	c3                   	ret    

0080175e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	53                   	push   %ebx
  801762:	83 ec 14             	sub    $0x14,%esp
  801765:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801768:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80176b:	50                   	push   %eax
  80176c:	53                   	push   %ebx
  80176d:	e8 ad fc ff ff       	call   80141f <fd_lookup>
  801772:	83 c4 08             	add    $0x8,%esp
  801775:	89 c2                	mov    %eax,%edx
  801777:	85 c0                	test   %eax,%eax
  801779:	78 68                	js     8017e3 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80177b:	83 ec 08             	sub    $0x8,%esp
  80177e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801781:	50                   	push   %eax
  801782:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801785:	ff 30                	pushl  (%eax)
  801787:	e8 e9 fc ff ff       	call   801475 <dev_lookup>
  80178c:	83 c4 10             	add    $0x10,%esp
  80178f:	85 c0                	test   %eax,%eax
  801791:	78 47                	js     8017da <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801796:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80179a:	75 21                	jne    8017bd <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80179c:	a1 04 40 80 00       	mov    0x804004,%eax
  8017a1:	8b 40 48             	mov    0x48(%eax),%eax
  8017a4:	83 ec 04             	sub    $0x4,%esp
  8017a7:	53                   	push   %ebx
  8017a8:	50                   	push   %eax
  8017a9:	68 4d 2a 80 00       	push   $0x802a4d
  8017ae:	e8 6e eb ff ff       	call   800321 <cprintf>
		return -E_INVAL;
  8017b3:	83 c4 10             	add    $0x10,%esp
  8017b6:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8017bb:	eb 26                	jmp    8017e3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c0:	8b 52 0c             	mov    0xc(%edx),%edx
  8017c3:	85 d2                	test   %edx,%edx
  8017c5:	74 17                	je     8017de <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017c7:	83 ec 04             	sub    $0x4,%esp
  8017ca:	ff 75 10             	pushl  0x10(%ebp)
  8017cd:	ff 75 0c             	pushl  0xc(%ebp)
  8017d0:	50                   	push   %eax
  8017d1:	ff d2                	call   *%edx
  8017d3:	89 c2                	mov    %eax,%edx
  8017d5:	83 c4 10             	add    $0x10,%esp
  8017d8:	eb 09                	jmp    8017e3 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017da:	89 c2                	mov    %eax,%edx
  8017dc:	eb 05                	jmp    8017e3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8017de:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  8017e3:	89 d0                	mov    %edx,%eax
  8017e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <seek>:

int
seek(int fdnum, off_t offset)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017f0:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8017f3:	50                   	push   %eax
  8017f4:	ff 75 08             	pushl  0x8(%ebp)
  8017f7:	e8 23 fc ff ff       	call   80141f <fd_lookup>
  8017fc:	83 c4 08             	add    $0x8,%esp
  8017ff:	85 c0                	test   %eax,%eax
  801801:	78 0e                	js     801811 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801803:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801806:	8b 55 0c             	mov    0xc(%ebp),%edx
  801809:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80180c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
  801816:	53                   	push   %ebx
  801817:	83 ec 14             	sub    $0x14,%esp
  80181a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80181d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801820:	50                   	push   %eax
  801821:	53                   	push   %ebx
  801822:	e8 f8 fb ff ff       	call   80141f <fd_lookup>
  801827:	83 c4 08             	add    $0x8,%esp
  80182a:	89 c2                	mov    %eax,%edx
  80182c:	85 c0                	test   %eax,%eax
  80182e:	78 65                	js     801895 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801830:	83 ec 08             	sub    $0x8,%esp
  801833:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801836:	50                   	push   %eax
  801837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183a:	ff 30                	pushl  (%eax)
  80183c:	e8 34 fc ff ff       	call   801475 <dev_lookup>
  801841:	83 c4 10             	add    $0x10,%esp
  801844:	85 c0                	test   %eax,%eax
  801846:	78 44                	js     80188c <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801848:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80184f:	75 21                	jne    801872 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801851:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801856:	8b 40 48             	mov    0x48(%eax),%eax
  801859:	83 ec 04             	sub    $0x4,%esp
  80185c:	53                   	push   %ebx
  80185d:	50                   	push   %eax
  80185e:	68 10 2a 80 00       	push   $0x802a10
  801863:	e8 b9 ea ff ff       	call   800321 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801868:	83 c4 10             	add    $0x10,%esp
  80186b:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801870:	eb 23                	jmp    801895 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  801872:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801875:	8b 52 18             	mov    0x18(%edx),%edx
  801878:	85 d2                	test   %edx,%edx
  80187a:	74 14                	je     801890 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80187c:	83 ec 08             	sub    $0x8,%esp
  80187f:	ff 75 0c             	pushl  0xc(%ebp)
  801882:	50                   	push   %eax
  801883:	ff d2                	call   *%edx
  801885:	89 c2                	mov    %eax,%edx
  801887:	83 c4 10             	add    $0x10,%esp
  80188a:	eb 09                	jmp    801895 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80188c:	89 c2                	mov    %eax,%edx
  80188e:	eb 05                	jmp    801895 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801890:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  801895:	89 d0                	mov    %edx,%eax
  801897:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	53                   	push   %ebx
  8018a0:	83 ec 14             	sub    $0x14,%esp
  8018a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018a9:	50                   	push   %eax
  8018aa:	ff 75 08             	pushl  0x8(%ebp)
  8018ad:	e8 6d fb ff ff       	call   80141f <fd_lookup>
  8018b2:	83 c4 08             	add    $0x8,%esp
  8018b5:	89 c2                	mov    %eax,%edx
  8018b7:	85 c0                	test   %eax,%eax
  8018b9:	78 58                	js     801913 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018bb:	83 ec 08             	sub    $0x8,%esp
  8018be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c1:	50                   	push   %eax
  8018c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c5:	ff 30                	pushl  (%eax)
  8018c7:	e8 a9 fb ff ff       	call   801475 <dev_lookup>
  8018cc:	83 c4 10             	add    $0x10,%esp
  8018cf:	85 c0                	test   %eax,%eax
  8018d1:	78 37                	js     80190a <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  8018d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d6:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018da:	74 32                	je     80190e <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018dc:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018df:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018e6:	00 00 00 
	stat->st_isdir = 0;
  8018e9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018f0:	00 00 00 
	stat->st_dev = dev;
  8018f3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018f9:	83 ec 08             	sub    $0x8,%esp
  8018fc:	53                   	push   %ebx
  8018fd:	ff 75 f0             	pushl  -0x10(%ebp)
  801900:	ff 50 14             	call   *0x14(%eax)
  801903:	89 c2                	mov    %eax,%edx
  801905:	83 c4 10             	add    $0x10,%esp
  801908:	eb 09                	jmp    801913 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80190a:	89 c2                	mov    %eax,%edx
  80190c:	eb 05                	jmp    801913 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  80190e:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801913:	89 d0                	mov    %edx,%eax
  801915:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	56                   	push   %esi
  80191e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80191f:	83 ec 08             	sub    $0x8,%esp
  801922:	6a 00                	push   $0x0
  801924:	ff 75 08             	pushl  0x8(%ebp)
  801927:	e8 06 02 00 00       	call   801b32 <open>
  80192c:	89 c3                	mov    %eax,%ebx
  80192e:	83 c4 10             	add    $0x10,%esp
  801931:	85 c0                	test   %eax,%eax
  801933:	78 1b                	js     801950 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801935:	83 ec 08             	sub    $0x8,%esp
  801938:	ff 75 0c             	pushl  0xc(%ebp)
  80193b:	50                   	push   %eax
  80193c:	e8 5b ff ff ff       	call   80189c <fstat>
  801941:	89 c6                	mov    %eax,%esi
	close(fd);
  801943:	89 1c 24             	mov    %ebx,(%esp)
  801946:	e8 fd fb ff ff       	call   801548 <close>
	return r;
  80194b:	83 c4 10             	add    $0x10,%esp
  80194e:	89 f0                	mov    %esi,%eax
}
  801950:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801953:	5b                   	pop    %ebx
  801954:	5e                   	pop    %esi
  801955:	5d                   	pop    %ebp
  801956:	c3                   	ret    

00801957 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
  80195a:	56                   	push   %esi
  80195b:	53                   	push   %ebx
  80195c:	89 c6                	mov    %eax,%esi
  80195e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801960:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801967:	75 12                	jne    80197b <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801969:	83 ec 0c             	sub    $0xc,%esp
  80196c:	6a 01                	push   $0x1
  80196e:	e8 fc f9 ff ff       	call   80136f <ipc_find_env>
  801973:	a3 00 40 80 00       	mov    %eax,0x804000
  801978:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80197b:	6a 07                	push   $0x7
  80197d:	68 00 50 80 00       	push   $0x805000
  801982:	56                   	push   %esi
  801983:	ff 35 00 40 80 00    	pushl  0x804000
  801989:	e8 8d f9 ff ff       	call   80131b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80198e:	83 c4 0c             	add    $0xc,%esp
  801991:	6a 00                	push   $0x0
  801993:	53                   	push   %ebx
  801994:	6a 00                	push   $0x0
  801996:	e8 15 f9 ff ff       	call   8012b0 <ipc_recv>
}
  80199b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80199e:	5b                   	pop    %ebx
  80199f:	5e                   	pop    %esi
  8019a0:	5d                   	pop    %ebp
  8019a1:	c3                   	ret    

008019a2 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ae:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8019b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b6:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c0:	b8 02 00 00 00       	mov    $0x2,%eax
  8019c5:	e8 8d ff ff ff       	call   801957 <fsipc>
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d8:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8019dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e2:	b8 06 00 00 00       	mov    $0x6,%eax
  8019e7:	e8 6b ff ff ff       	call   801957 <fsipc>
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
  8019f1:	53                   	push   %ebx
  8019f2:	83 ec 04             	sub    $0x4,%esp
  8019f5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8019fe:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a03:	ba 00 00 00 00       	mov    $0x0,%edx
  801a08:	b8 05 00 00 00       	mov    $0x5,%eax
  801a0d:	e8 45 ff ff ff       	call   801957 <fsipc>
  801a12:	85 c0                	test   %eax,%eax
  801a14:	78 2c                	js     801a42 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a16:	83 ec 08             	sub    $0x8,%esp
  801a19:	68 00 50 80 00       	push   $0x805000
  801a1e:	53                   	push   %ebx
  801a1f:	e8 6f ee ff ff       	call   800893 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a24:	a1 80 50 80 00       	mov    0x805080,%eax
  801a29:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a2f:	a1 84 50 80 00       	mov    0x805084,%eax
  801a34:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a3a:	83 c4 10             	add    $0x10,%esp
  801a3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	83 ec 08             	sub    $0x8,%esp
  801a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a50:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a56:	8b 49 0c             	mov    0xc(%ecx),%ecx
  801a59:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  801a5f:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801a64:	76 22                	jbe    801a88 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  801a66:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  801a6d:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  801a70:	83 ec 04             	sub    $0x4,%esp
  801a73:	68 f8 0f 00 00       	push   $0xff8
  801a78:	52                   	push   %edx
  801a79:	68 08 50 80 00       	push   $0x805008
  801a7e:	e8 a3 ef ff ff       	call   800a26 <memmove>
  801a83:	83 c4 10             	add    $0x10,%esp
  801a86:	eb 17                	jmp    801a9f <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  801a88:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  801a8d:	83 ec 04             	sub    $0x4,%esp
  801a90:	50                   	push   %eax
  801a91:	52                   	push   %edx
  801a92:	68 08 50 80 00       	push   $0x805008
  801a97:	e8 8a ef ff ff       	call   800a26 <memmove>
  801a9c:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  801a9f:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa4:	b8 04 00 00 00       	mov    $0x4,%eax
  801aa9:	e8 a9 fe ff ff       	call   801957 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	56                   	push   %esi
  801ab4:	53                   	push   %ebx
  801ab5:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	8b 40 0c             	mov    0xc(%eax),%eax
  801abe:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801ac3:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ac9:	ba 00 00 00 00       	mov    $0x0,%edx
  801ace:	b8 03 00 00 00       	mov    $0x3,%eax
  801ad3:	e8 7f fe ff ff       	call   801957 <fsipc>
  801ad8:	89 c3                	mov    %eax,%ebx
  801ada:	85 c0                	test   %eax,%eax
  801adc:	78 4b                	js     801b29 <devfile_read+0x79>
		return r;
	assert(r <= n);
  801ade:	39 c6                	cmp    %eax,%esi
  801ae0:	73 16                	jae    801af8 <devfile_read+0x48>
  801ae2:	68 7c 2a 80 00       	push   $0x802a7c
  801ae7:	68 83 2a 80 00       	push   $0x802a83
  801aec:	6a 7c                	push   $0x7c
  801aee:	68 98 2a 80 00       	push   $0x802a98
  801af3:	e8 50 e7 ff ff       	call   800248 <_panic>
	assert(r <= PGSIZE);
  801af8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801afd:	7e 16                	jle    801b15 <devfile_read+0x65>
  801aff:	68 a3 2a 80 00       	push   $0x802aa3
  801b04:	68 83 2a 80 00       	push   $0x802a83
  801b09:	6a 7d                	push   $0x7d
  801b0b:	68 98 2a 80 00       	push   $0x802a98
  801b10:	e8 33 e7 ff ff       	call   800248 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b15:	83 ec 04             	sub    $0x4,%esp
  801b18:	50                   	push   %eax
  801b19:	68 00 50 80 00       	push   $0x805000
  801b1e:	ff 75 0c             	pushl  0xc(%ebp)
  801b21:	e8 00 ef ff ff       	call   800a26 <memmove>
	return r;
  801b26:	83 c4 10             	add    $0x10,%esp
}
  801b29:	89 d8                	mov    %ebx,%eax
  801b2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b2e:	5b                   	pop    %ebx
  801b2f:	5e                   	pop    %esi
  801b30:	5d                   	pop    %ebp
  801b31:	c3                   	ret    

00801b32 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
  801b35:	53                   	push   %ebx
  801b36:	83 ec 20             	sub    $0x20,%esp
  801b39:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801b3c:	53                   	push   %ebx
  801b3d:	e8 18 ed ff ff       	call   80085a <strlen>
  801b42:	83 c4 10             	add    $0x10,%esp
  801b45:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b4a:	7f 67                	jg     801bb3 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801b4c:	83 ec 0c             	sub    $0xc,%esp
  801b4f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b52:	50                   	push   %eax
  801b53:	e8 78 f8 ff ff       	call   8013d0 <fd_alloc>
  801b58:	83 c4 10             	add    $0x10,%esp
		return r;
  801b5b:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801b5d:	85 c0                	test   %eax,%eax
  801b5f:	78 57                	js     801bb8 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801b61:	83 ec 08             	sub    $0x8,%esp
  801b64:	53                   	push   %ebx
  801b65:	68 00 50 80 00       	push   $0x805000
  801b6a:	e8 24 ed ff ff       	call   800893 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b72:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b7f:	e8 d3 fd ff ff       	call   801957 <fsipc>
  801b84:	89 c3                	mov    %eax,%ebx
  801b86:	83 c4 10             	add    $0x10,%esp
  801b89:	85 c0                	test   %eax,%eax
  801b8b:	79 14                	jns    801ba1 <open+0x6f>
		fd_close(fd, 0);
  801b8d:	83 ec 08             	sub    $0x8,%esp
  801b90:	6a 00                	push   $0x0
  801b92:	ff 75 f4             	pushl  -0xc(%ebp)
  801b95:	e8 2e f9 ff ff       	call   8014c8 <fd_close>
		return r;
  801b9a:	83 c4 10             	add    $0x10,%esp
  801b9d:	89 da                	mov    %ebx,%edx
  801b9f:	eb 17                	jmp    801bb8 <open+0x86>
	}

	return fd2num(fd);
  801ba1:	83 ec 0c             	sub    $0xc,%esp
  801ba4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ba7:	e8 fc f7 ff ff       	call   8013a8 <fd2num>
  801bac:	89 c2                	mov    %eax,%edx
  801bae:	83 c4 10             	add    $0x10,%esp
  801bb1:	eb 05                	jmp    801bb8 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801bb3:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801bb8:	89 d0                	mov    %edx,%eax
  801bba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bc5:	ba 00 00 00 00       	mov    $0x0,%edx
  801bca:	b8 08 00 00 00       	mov    $0x8,%eax
  801bcf:	e8 83 fd ff ff       	call   801957 <fsipc>
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801bdc:	89 d0                	mov    %edx,%eax
  801bde:	c1 e8 16             	shr    $0x16,%eax
  801be1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801be8:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801bed:	f6 c1 01             	test   $0x1,%cl
  801bf0:	74 1d                	je     801c0f <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801bf2:	c1 ea 0c             	shr    $0xc,%edx
  801bf5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801bfc:	f6 c2 01             	test   $0x1,%dl
  801bff:	74 0e                	je     801c0f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c01:	c1 ea 0c             	shr    $0xc,%edx
  801c04:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801c0b:	ef 
  801c0c:	0f b7 c0             	movzwl %ax,%eax
}
  801c0f:	5d                   	pop    %ebp
  801c10:	c3                   	ret    

00801c11 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	56                   	push   %esi
  801c15:	53                   	push   %ebx
  801c16:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c19:	83 ec 0c             	sub    $0xc,%esp
  801c1c:	ff 75 08             	pushl  0x8(%ebp)
  801c1f:	e8 94 f7 ff ff       	call   8013b8 <fd2data>
  801c24:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c26:	83 c4 08             	add    $0x8,%esp
  801c29:	68 af 2a 80 00       	push   $0x802aaf
  801c2e:	53                   	push   %ebx
  801c2f:	e8 5f ec ff ff       	call   800893 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c34:	8b 46 04             	mov    0x4(%esi),%eax
  801c37:	2b 06                	sub    (%esi),%eax
  801c39:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c3f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c46:	00 00 00 
	stat->st_dev = &devpipe;
  801c49:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801c50:	30 80 00 
	return 0;
}
  801c53:	b8 00 00 00 00       	mov    $0x0,%eax
  801c58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c5b:	5b                   	pop    %ebx
  801c5c:	5e                   	pop    %esi
  801c5d:	5d                   	pop    %ebp
  801c5e:	c3                   	ret    

00801c5f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	53                   	push   %ebx
  801c63:	83 ec 0c             	sub    $0xc,%esp
  801c66:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c69:	53                   	push   %ebx
  801c6a:	6a 00                	push   $0x0
  801c6c:	e8 b5 f0 ff ff       	call   800d26 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c71:	89 1c 24             	mov    %ebx,(%esp)
  801c74:	e8 3f f7 ff ff       	call   8013b8 <fd2data>
  801c79:	83 c4 08             	add    $0x8,%esp
  801c7c:	50                   	push   %eax
  801c7d:	6a 00                	push   $0x0
  801c7f:	e8 a2 f0 ff ff       	call   800d26 <sys_page_unmap>
}
  801c84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	57                   	push   %edi
  801c8d:	56                   	push   %esi
  801c8e:	53                   	push   %ebx
  801c8f:	83 ec 1c             	sub    $0x1c,%esp
  801c92:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801c95:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801c97:	a1 04 40 80 00       	mov    0x804004,%eax
  801c9c:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801c9f:	83 ec 0c             	sub    $0xc,%esp
  801ca2:	ff 75 e0             	pushl  -0x20(%ebp)
  801ca5:	e8 2c ff ff ff       	call   801bd6 <pageref>
  801caa:	89 c3                	mov    %eax,%ebx
  801cac:	89 3c 24             	mov    %edi,(%esp)
  801caf:	e8 22 ff ff ff       	call   801bd6 <pageref>
  801cb4:	83 c4 10             	add    $0x10,%esp
  801cb7:	39 c3                	cmp    %eax,%ebx
  801cb9:	0f 94 c1             	sete   %cl
  801cbc:	0f b6 c9             	movzbl %cl,%ecx
  801cbf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801cc2:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801cc8:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ccb:	39 ce                	cmp    %ecx,%esi
  801ccd:	74 1b                	je     801cea <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801ccf:	39 c3                	cmp    %eax,%ebx
  801cd1:	75 c4                	jne    801c97 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cd3:	8b 42 58             	mov    0x58(%edx),%eax
  801cd6:	ff 75 e4             	pushl  -0x1c(%ebp)
  801cd9:	50                   	push   %eax
  801cda:	56                   	push   %esi
  801cdb:	68 b6 2a 80 00       	push   $0x802ab6
  801ce0:	e8 3c e6 ff ff       	call   800321 <cprintf>
  801ce5:	83 c4 10             	add    $0x10,%esp
  801ce8:	eb ad                	jmp    801c97 <_pipeisclosed+0xe>
	}
}
  801cea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ced:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cf0:	5b                   	pop    %ebx
  801cf1:	5e                   	pop    %esi
  801cf2:	5f                   	pop    %edi
  801cf3:	5d                   	pop    %ebp
  801cf4:	c3                   	ret    

00801cf5 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
  801cf8:	57                   	push   %edi
  801cf9:	56                   	push   %esi
  801cfa:	53                   	push   %ebx
  801cfb:	83 ec 28             	sub    $0x28,%esp
  801cfe:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801d01:	56                   	push   %esi
  801d02:	e8 b1 f6 ff ff       	call   8013b8 <fd2data>
  801d07:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d09:	83 c4 10             	add    $0x10,%esp
  801d0c:	bf 00 00 00 00       	mov    $0x0,%edi
  801d11:	eb 4b                	jmp    801d5e <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801d13:	89 da                	mov    %ebx,%edx
  801d15:	89 f0                	mov    %esi,%eax
  801d17:	e8 6d ff ff ff       	call   801c89 <_pipeisclosed>
  801d1c:	85 c0                	test   %eax,%eax
  801d1e:	75 48                	jne    801d68 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801d20:	e8 90 ef ff ff       	call   800cb5 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d25:	8b 43 04             	mov    0x4(%ebx),%eax
  801d28:	8b 0b                	mov    (%ebx),%ecx
  801d2a:	8d 51 20             	lea    0x20(%ecx),%edx
  801d2d:	39 d0                	cmp    %edx,%eax
  801d2f:	73 e2                	jae    801d13 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d34:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d38:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d3b:	89 c2                	mov    %eax,%edx
  801d3d:	c1 fa 1f             	sar    $0x1f,%edx
  801d40:	89 d1                	mov    %edx,%ecx
  801d42:	c1 e9 1b             	shr    $0x1b,%ecx
  801d45:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d48:	83 e2 1f             	and    $0x1f,%edx
  801d4b:	29 ca                	sub    %ecx,%edx
  801d4d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d51:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d55:	83 c0 01             	add    $0x1,%eax
  801d58:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d5b:	83 c7 01             	add    $0x1,%edi
  801d5e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d61:	75 c2                	jne    801d25 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801d63:	8b 45 10             	mov    0x10(%ebp),%eax
  801d66:	eb 05                	jmp    801d6d <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801d68:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801d6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d70:	5b                   	pop    %ebx
  801d71:	5e                   	pop    %esi
  801d72:	5f                   	pop    %edi
  801d73:	5d                   	pop    %ebp
  801d74:	c3                   	ret    

00801d75 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	57                   	push   %edi
  801d79:	56                   	push   %esi
  801d7a:	53                   	push   %ebx
  801d7b:	83 ec 18             	sub    $0x18,%esp
  801d7e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801d81:	57                   	push   %edi
  801d82:	e8 31 f6 ff ff       	call   8013b8 <fd2data>
  801d87:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d89:	83 c4 10             	add    $0x10,%esp
  801d8c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d91:	eb 3d                	jmp    801dd0 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801d93:	85 db                	test   %ebx,%ebx
  801d95:	74 04                	je     801d9b <devpipe_read+0x26>
				return i;
  801d97:	89 d8                	mov    %ebx,%eax
  801d99:	eb 44                	jmp    801ddf <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801d9b:	89 f2                	mov    %esi,%edx
  801d9d:	89 f8                	mov    %edi,%eax
  801d9f:	e8 e5 fe ff ff       	call   801c89 <_pipeisclosed>
  801da4:	85 c0                	test   %eax,%eax
  801da6:	75 32                	jne    801dda <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801da8:	e8 08 ef ff ff       	call   800cb5 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801dad:	8b 06                	mov    (%esi),%eax
  801daf:	3b 46 04             	cmp    0x4(%esi),%eax
  801db2:	74 df                	je     801d93 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801db4:	99                   	cltd   
  801db5:	c1 ea 1b             	shr    $0x1b,%edx
  801db8:	01 d0                	add    %edx,%eax
  801dba:	83 e0 1f             	and    $0x1f,%eax
  801dbd:	29 d0                	sub    %edx,%eax
  801dbf:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801dc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dc7:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801dca:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801dcd:	83 c3 01             	add    $0x1,%ebx
  801dd0:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801dd3:	75 d8                	jne    801dad <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801dd5:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd8:	eb 05                	jmp    801ddf <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801dda:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801ddf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801de2:	5b                   	pop    %ebx
  801de3:	5e                   	pop    %esi
  801de4:	5f                   	pop    %edi
  801de5:	5d                   	pop    %ebp
  801de6:	c3                   	ret    

00801de7 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	56                   	push   %esi
  801deb:	53                   	push   %ebx
  801dec:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801def:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801df2:	50                   	push   %eax
  801df3:	e8 d8 f5 ff ff       	call   8013d0 <fd_alloc>
  801df8:	83 c4 10             	add    $0x10,%esp
  801dfb:	89 c2                	mov    %eax,%edx
  801dfd:	85 c0                	test   %eax,%eax
  801dff:	0f 88 2c 01 00 00    	js     801f31 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e05:	83 ec 04             	sub    $0x4,%esp
  801e08:	68 07 04 00 00       	push   $0x407
  801e0d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e10:	6a 00                	push   $0x0
  801e12:	e8 c5 ee ff ff       	call   800cdc <sys_page_alloc>
  801e17:	83 c4 10             	add    $0x10,%esp
  801e1a:	89 c2                	mov    %eax,%edx
  801e1c:	85 c0                	test   %eax,%eax
  801e1e:	0f 88 0d 01 00 00    	js     801f31 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801e24:	83 ec 0c             	sub    $0xc,%esp
  801e27:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e2a:	50                   	push   %eax
  801e2b:	e8 a0 f5 ff ff       	call   8013d0 <fd_alloc>
  801e30:	89 c3                	mov    %eax,%ebx
  801e32:	83 c4 10             	add    $0x10,%esp
  801e35:	85 c0                	test   %eax,%eax
  801e37:	0f 88 e2 00 00 00    	js     801f1f <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e3d:	83 ec 04             	sub    $0x4,%esp
  801e40:	68 07 04 00 00       	push   $0x407
  801e45:	ff 75 f0             	pushl  -0x10(%ebp)
  801e48:	6a 00                	push   $0x0
  801e4a:	e8 8d ee ff ff       	call   800cdc <sys_page_alloc>
  801e4f:	89 c3                	mov    %eax,%ebx
  801e51:	83 c4 10             	add    $0x10,%esp
  801e54:	85 c0                	test   %eax,%eax
  801e56:	0f 88 c3 00 00 00    	js     801f1f <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801e5c:	83 ec 0c             	sub    $0xc,%esp
  801e5f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e62:	e8 51 f5 ff ff       	call   8013b8 <fd2data>
  801e67:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e69:	83 c4 0c             	add    $0xc,%esp
  801e6c:	68 07 04 00 00       	push   $0x407
  801e71:	50                   	push   %eax
  801e72:	6a 00                	push   $0x0
  801e74:	e8 63 ee ff ff       	call   800cdc <sys_page_alloc>
  801e79:	89 c3                	mov    %eax,%ebx
  801e7b:	83 c4 10             	add    $0x10,%esp
  801e7e:	85 c0                	test   %eax,%eax
  801e80:	0f 88 89 00 00 00    	js     801f0f <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e86:	83 ec 0c             	sub    $0xc,%esp
  801e89:	ff 75 f0             	pushl  -0x10(%ebp)
  801e8c:	e8 27 f5 ff ff       	call   8013b8 <fd2data>
  801e91:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e98:	50                   	push   %eax
  801e99:	6a 00                	push   $0x0
  801e9b:	56                   	push   %esi
  801e9c:	6a 00                	push   $0x0
  801e9e:	e8 5d ee ff ff       	call   800d00 <sys_page_map>
  801ea3:	89 c3                	mov    %eax,%ebx
  801ea5:	83 c4 20             	add    $0x20,%esp
  801ea8:	85 c0                	test   %eax,%eax
  801eaa:	78 55                	js     801f01 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801eac:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb5:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801ec1:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eca:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecf:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801ed6:	83 ec 0c             	sub    $0xc,%esp
  801ed9:	ff 75 f4             	pushl  -0xc(%ebp)
  801edc:	e8 c7 f4 ff ff       	call   8013a8 <fd2num>
  801ee1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ee4:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ee6:	83 c4 04             	add    $0x4,%esp
  801ee9:	ff 75 f0             	pushl  -0x10(%ebp)
  801eec:	e8 b7 f4 ff ff       	call   8013a8 <fd2num>
  801ef1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ef4:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ef7:	83 c4 10             	add    $0x10,%esp
  801efa:	ba 00 00 00 00       	mov    $0x0,%edx
  801eff:	eb 30                	jmp    801f31 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801f01:	83 ec 08             	sub    $0x8,%esp
  801f04:	56                   	push   %esi
  801f05:	6a 00                	push   $0x0
  801f07:	e8 1a ee ff ff       	call   800d26 <sys_page_unmap>
  801f0c:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801f0f:	83 ec 08             	sub    $0x8,%esp
  801f12:	ff 75 f0             	pushl  -0x10(%ebp)
  801f15:	6a 00                	push   $0x0
  801f17:	e8 0a ee ff ff       	call   800d26 <sys_page_unmap>
  801f1c:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801f1f:	83 ec 08             	sub    $0x8,%esp
  801f22:	ff 75 f4             	pushl  -0xc(%ebp)
  801f25:	6a 00                	push   $0x0
  801f27:	e8 fa ed ff ff       	call   800d26 <sys_page_unmap>
  801f2c:	83 c4 10             	add    $0x10,%esp
  801f2f:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  801f31:	89 d0                	mov    %edx,%eax
  801f33:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f36:	5b                   	pop    %ebx
  801f37:	5e                   	pop    %esi
  801f38:	5d                   	pop    %ebp
  801f39:	c3                   	ret    

00801f3a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f40:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f43:	50                   	push   %eax
  801f44:	ff 75 08             	pushl  0x8(%ebp)
  801f47:	e8 d3 f4 ff ff       	call   80141f <fd_lookup>
  801f4c:	83 c4 10             	add    $0x10,%esp
  801f4f:	85 c0                	test   %eax,%eax
  801f51:	78 18                	js     801f6b <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801f53:	83 ec 0c             	sub    $0xc,%esp
  801f56:	ff 75 f4             	pushl  -0xc(%ebp)
  801f59:	e8 5a f4 ff ff       	call   8013b8 <fd2data>
	return _pipeisclosed(fd, p);
  801f5e:	89 c2                	mov    %eax,%edx
  801f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f63:	e8 21 fd ff ff       	call   801c89 <_pipeisclosed>
  801f68:	83 c4 10             	add    $0x10,%esp
}
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801f70:	b8 00 00 00 00       	mov    $0x0,%eax
  801f75:	5d                   	pop    %ebp
  801f76:	c3                   	ret    

00801f77 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
  801f7a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f7d:	68 ce 2a 80 00       	push   $0x802ace
  801f82:	ff 75 0c             	pushl  0xc(%ebp)
  801f85:	e8 09 e9 ff ff       	call   800893 <strcpy>
	return 0;
}
  801f8a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
  801f94:	57                   	push   %edi
  801f95:	56                   	push   %esi
  801f96:	53                   	push   %ebx
  801f97:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801f9d:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801fa2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801fa8:	eb 2d                	jmp    801fd7 <devcons_write+0x46>
		m = n - tot;
  801faa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fad:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801faf:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801fb2:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801fb7:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801fba:	83 ec 04             	sub    $0x4,%esp
  801fbd:	53                   	push   %ebx
  801fbe:	03 45 0c             	add    0xc(%ebp),%eax
  801fc1:	50                   	push   %eax
  801fc2:	57                   	push   %edi
  801fc3:	e8 5e ea ff ff       	call   800a26 <memmove>
		sys_cputs(buf, m);
  801fc8:	83 c4 08             	add    $0x8,%esp
  801fcb:	53                   	push   %ebx
  801fcc:	57                   	push   %edi
  801fcd:	e8 53 ec ff ff       	call   800c25 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801fd2:	01 de                	add    %ebx,%esi
  801fd4:	83 c4 10             	add    $0x10,%esp
  801fd7:	89 f0                	mov    %esi,%eax
  801fd9:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fdc:	72 cc                	jb     801faa <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801fde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fe1:	5b                   	pop    %ebx
  801fe2:	5e                   	pop    %esi
  801fe3:	5f                   	pop    %edi
  801fe4:	5d                   	pop    %ebp
  801fe5:	c3                   	ret    

00801fe6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	83 ec 08             	sub    $0x8,%esp
  801fec:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801ff1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ff5:	74 2a                	je     802021 <devcons_read+0x3b>
  801ff7:	eb 05                	jmp    801ffe <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801ff9:	e8 b7 ec ff ff       	call   800cb5 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801ffe:	e8 48 ec ff ff       	call   800c4b <sys_cgetc>
  802003:	85 c0                	test   %eax,%eax
  802005:	74 f2                	je     801ff9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802007:	85 c0                	test   %eax,%eax
  802009:	78 16                	js     802021 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80200b:	83 f8 04             	cmp    $0x4,%eax
  80200e:	74 0c                	je     80201c <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802010:	8b 55 0c             	mov    0xc(%ebp),%edx
  802013:	88 02                	mov    %al,(%edx)
	return 1;
  802015:	b8 01 00 00 00       	mov    $0x1,%eax
  80201a:	eb 05                	jmp    802021 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80201c:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802029:	8b 45 08             	mov    0x8(%ebp),%eax
  80202c:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80202f:	6a 01                	push   $0x1
  802031:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802034:	50                   	push   %eax
  802035:	e8 eb eb ff ff       	call   800c25 <sys_cputs>
}
  80203a:	83 c4 10             	add    $0x10,%esp
  80203d:	c9                   	leave  
  80203e:	c3                   	ret    

0080203f <getchar>:

int
getchar(void)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
  802042:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802045:	6a 01                	push   $0x1
  802047:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80204a:	50                   	push   %eax
  80204b:	6a 00                	push   $0x0
  80204d:	e8 32 f6 ff ff       	call   801684 <read>
	if (r < 0)
  802052:	83 c4 10             	add    $0x10,%esp
  802055:	85 c0                	test   %eax,%eax
  802057:	78 0f                	js     802068 <getchar+0x29>
		return r;
	if (r < 1)
  802059:	85 c0                	test   %eax,%eax
  80205b:	7e 06                	jle    802063 <getchar+0x24>
		return -E_EOF;
	return c;
  80205d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802061:	eb 05                	jmp    802068 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802063:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802070:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802073:	50                   	push   %eax
  802074:	ff 75 08             	pushl  0x8(%ebp)
  802077:	e8 a3 f3 ff ff       	call   80141f <fd_lookup>
  80207c:	83 c4 10             	add    $0x10,%esp
  80207f:	85 c0                	test   %eax,%eax
  802081:	78 11                	js     802094 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802086:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80208c:	39 10                	cmp    %edx,(%eax)
  80208e:	0f 94 c0             	sete   %al
  802091:	0f b6 c0             	movzbl %al,%eax
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <opencons>:

int
opencons(void)
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80209c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80209f:	50                   	push   %eax
  8020a0:	e8 2b f3 ff ff       	call   8013d0 <fd_alloc>
  8020a5:	83 c4 10             	add    $0x10,%esp
		return r;
  8020a8:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8020aa:	85 c0                	test   %eax,%eax
  8020ac:	78 3e                	js     8020ec <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020ae:	83 ec 04             	sub    $0x4,%esp
  8020b1:	68 07 04 00 00       	push   $0x407
  8020b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8020b9:	6a 00                	push   $0x0
  8020bb:	e8 1c ec ff ff       	call   800cdc <sys_page_alloc>
  8020c0:	83 c4 10             	add    $0x10,%esp
		return r;
  8020c3:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	78 23                	js     8020ec <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8020c9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d2:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020de:	83 ec 0c             	sub    $0xc,%esp
  8020e1:	50                   	push   %eax
  8020e2:	e8 c1 f2 ff ff       	call   8013a8 <fd2num>
  8020e7:	89 c2                	mov    %eax,%edx
  8020e9:	83 c4 10             	add    $0x10,%esp
}
  8020ec:	89 d0                	mov    %edx,%eax
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
  8020f3:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8020f6:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8020fd:	75 2c                	jne    80212b <set_pgfault_handler+0x3b>
		// First time through!
		// LAB 4: Your code here.
		r = sys_page_alloc(0,(void *)(UXSTACKTOP - PGSIZE),PTE_P | PTE_U | PTE_W);
  8020ff:	83 ec 04             	sub    $0x4,%esp
  802102:	6a 07                	push   $0x7
  802104:	68 00 f0 bf ee       	push   $0xeebff000
  802109:	6a 00                	push   $0x0
  80210b:	e8 cc eb ff ff       	call   800cdc <sys_page_alloc>
		if(r < 0)
  802110:	83 c4 10             	add    $0x10,%esp
  802113:	85 c0                	test   %eax,%eax
  802115:	79 14                	jns    80212b <set_pgfault_handler+0x3b>
			panic("set_pgfault_handler: error in sys_page_alloc\n");	
  802117:	83 ec 04             	sub    $0x4,%esp
  80211a:	68 dc 2a 80 00       	push   $0x802adc
  80211f:	6a 22                	push   $0x22
  802121:	68 48 2b 80 00       	push   $0x802b48
  802126:	e8 1d e1 ff ff       	call   800248 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	a3 00 60 80 00       	mov    %eax,0x806000
	r = sys_env_set_pgfault_upcall(0, _pgfault_upcall); 
  802133:	83 ec 08             	sub    $0x8,%esp
  802136:	68 5f 21 80 00       	push   $0x80215f
  80213b:	6a 00                	push   $0x0
  80213d:	e8 4d ec ff ff       	call   800d8f <sys_env_set_pgfault_upcall>
	if (r < 0)
  802142:	83 c4 10             	add    $0x10,%esp
  802145:	85 c0                	test   %eax,%eax
  802147:	79 14                	jns    80215d <set_pgfault_handler+0x6d>
		panic("set_pgfault_handler: error in sys_env_set_pgfault_upcall");
  802149:	83 ec 04             	sub    $0x4,%esp
  80214c:	68 0c 2b 80 00       	push   $0x802b0c
  802151:	6a 29                	push   $0x29
  802153:	68 48 2b 80 00       	push   $0x802b48
  802158:	e8 eb e0 ff ff       	call   800248 <_panic>
}
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    

0080215f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80215f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802160:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802165:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802167:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	subl $0x4, 0x30(%esp)
  80216a:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  80216f:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 0x28(%esp), %ebx 	
  802173:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  802177:	89 18                	mov    %ebx,(%eax)
	addl $0x8, %esp
  802179:	83 c4 08             	add    $0x8,%esp


	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  80217c:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp 
  80217d:	83 c4 04             	add    $0x4,%esp
	popfl
  802180:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802181:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802182:	c3                   	ret    
  802183:	66 90                	xchg   %ax,%ax
  802185:	66 90                	xchg   %ax,%ax
  802187:	66 90                	xchg   %ax,%ax
  802189:	66 90                	xchg   %ax,%ax
  80218b:	66 90                	xchg   %ax,%ax
  80218d:	66 90                	xchg   %ax,%ax
  80218f:	90                   	nop

00802190 <__udivdi3>:
  802190:	55                   	push   %ebp
  802191:	57                   	push   %edi
  802192:	56                   	push   %esi
  802193:	53                   	push   %ebx
  802194:	83 ec 1c             	sub    $0x1c,%esp
  802197:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80219b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80219f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8021a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021a7:	85 f6                	test   %esi,%esi
  8021a9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021ad:	89 ca                	mov    %ecx,%edx
  8021af:	89 f8                	mov    %edi,%eax
  8021b1:	75 3d                	jne    8021f0 <__udivdi3+0x60>
  8021b3:	39 cf                	cmp    %ecx,%edi
  8021b5:	0f 87 c5 00 00 00    	ja     802280 <__udivdi3+0xf0>
  8021bb:	85 ff                	test   %edi,%edi
  8021bd:	89 fd                	mov    %edi,%ebp
  8021bf:	75 0b                	jne    8021cc <__udivdi3+0x3c>
  8021c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8021c6:	31 d2                	xor    %edx,%edx
  8021c8:	f7 f7                	div    %edi
  8021ca:	89 c5                	mov    %eax,%ebp
  8021cc:	89 c8                	mov    %ecx,%eax
  8021ce:	31 d2                	xor    %edx,%edx
  8021d0:	f7 f5                	div    %ebp
  8021d2:	89 c1                	mov    %eax,%ecx
  8021d4:	89 d8                	mov    %ebx,%eax
  8021d6:	89 cf                	mov    %ecx,%edi
  8021d8:	f7 f5                	div    %ebp
  8021da:	89 c3                	mov    %eax,%ebx
  8021dc:	89 d8                	mov    %ebx,%eax
  8021de:	89 fa                	mov    %edi,%edx
  8021e0:	83 c4 1c             	add    $0x1c,%esp
  8021e3:	5b                   	pop    %ebx
  8021e4:	5e                   	pop    %esi
  8021e5:	5f                   	pop    %edi
  8021e6:	5d                   	pop    %ebp
  8021e7:	c3                   	ret    
  8021e8:	90                   	nop
  8021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021f0:	39 ce                	cmp    %ecx,%esi
  8021f2:	77 74                	ja     802268 <__udivdi3+0xd8>
  8021f4:	0f bd fe             	bsr    %esi,%edi
  8021f7:	83 f7 1f             	xor    $0x1f,%edi
  8021fa:	0f 84 98 00 00 00    	je     802298 <__udivdi3+0x108>
  802200:	bb 20 00 00 00       	mov    $0x20,%ebx
  802205:	89 f9                	mov    %edi,%ecx
  802207:	89 c5                	mov    %eax,%ebp
  802209:	29 fb                	sub    %edi,%ebx
  80220b:	d3 e6                	shl    %cl,%esi
  80220d:	89 d9                	mov    %ebx,%ecx
  80220f:	d3 ed                	shr    %cl,%ebp
  802211:	89 f9                	mov    %edi,%ecx
  802213:	d3 e0                	shl    %cl,%eax
  802215:	09 ee                	or     %ebp,%esi
  802217:	89 d9                	mov    %ebx,%ecx
  802219:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80221d:	89 d5                	mov    %edx,%ebp
  80221f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802223:	d3 ed                	shr    %cl,%ebp
  802225:	89 f9                	mov    %edi,%ecx
  802227:	d3 e2                	shl    %cl,%edx
  802229:	89 d9                	mov    %ebx,%ecx
  80222b:	d3 e8                	shr    %cl,%eax
  80222d:	09 c2                	or     %eax,%edx
  80222f:	89 d0                	mov    %edx,%eax
  802231:	89 ea                	mov    %ebp,%edx
  802233:	f7 f6                	div    %esi
  802235:	89 d5                	mov    %edx,%ebp
  802237:	89 c3                	mov    %eax,%ebx
  802239:	f7 64 24 0c          	mull   0xc(%esp)
  80223d:	39 d5                	cmp    %edx,%ebp
  80223f:	72 10                	jb     802251 <__udivdi3+0xc1>
  802241:	8b 74 24 08          	mov    0x8(%esp),%esi
  802245:	89 f9                	mov    %edi,%ecx
  802247:	d3 e6                	shl    %cl,%esi
  802249:	39 c6                	cmp    %eax,%esi
  80224b:	73 07                	jae    802254 <__udivdi3+0xc4>
  80224d:	39 d5                	cmp    %edx,%ebp
  80224f:	75 03                	jne    802254 <__udivdi3+0xc4>
  802251:	83 eb 01             	sub    $0x1,%ebx
  802254:	31 ff                	xor    %edi,%edi
  802256:	89 d8                	mov    %ebx,%eax
  802258:	89 fa                	mov    %edi,%edx
  80225a:	83 c4 1c             	add    $0x1c,%esp
  80225d:	5b                   	pop    %ebx
  80225e:	5e                   	pop    %esi
  80225f:	5f                   	pop    %edi
  802260:	5d                   	pop    %ebp
  802261:	c3                   	ret    
  802262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802268:	31 ff                	xor    %edi,%edi
  80226a:	31 db                	xor    %ebx,%ebx
  80226c:	89 d8                	mov    %ebx,%eax
  80226e:	89 fa                	mov    %edi,%edx
  802270:	83 c4 1c             	add    $0x1c,%esp
  802273:	5b                   	pop    %ebx
  802274:	5e                   	pop    %esi
  802275:	5f                   	pop    %edi
  802276:	5d                   	pop    %ebp
  802277:	c3                   	ret    
  802278:	90                   	nop
  802279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802280:	89 d8                	mov    %ebx,%eax
  802282:	f7 f7                	div    %edi
  802284:	31 ff                	xor    %edi,%edi
  802286:	89 c3                	mov    %eax,%ebx
  802288:	89 d8                	mov    %ebx,%eax
  80228a:	89 fa                	mov    %edi,%edx
  80228c:	83 c4 1c             	add    $0x1c,%esp
  80228f:	5b                   	pop    %ebx
  802290:	5e                   	pop    %esi
  802291:	5f                   	pop    %edi
  802292:	5d                   	pop    %ebp
  802293:	c3                   	ret    
  802294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802298:	39 ce                	cmp    %ecx,%esi
  80229a:	72 0c                	jb     8022a8 <__udivdi3+0x118>
  80229c:	31 db                	xor    %ebx,%ebx
  80229e:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8022a2:	0f 87 34 ff ff ff    	ja     8021dc <__udivdi3+0x4c>
  8022a8:	bb 01 00 00 00       	mov    $0x1,%ebx
  8022ad:	e9 2a ff ff ff       	jmp    8021dc <__udivdi3+0x4c>
  8022b2:	66 90                	xchg   %ax,%ax
  8022b4:	66 90                	xchg   %ax,%ax
  8022b6:	66 90                	xchg   %ax,%ax
  8022b8:	66 90                	xchg   %ax,%ax
  8022ba:	66 90                	xchg   %ax,%ax
  8022bc:	66 90                	xchg   %ax,%ax
  8022be:	66 90                	xchg   %ax,%ax

008022c0 <__umoddi3>:
  8022c0:	55                   	push   %ebp
  8022c1:	57                   	push   %edi
  8022c2:	56                   	push   %esi
  8022c3:	53                   	push   %ebx
  8022c4:	83 ec 1c             	sub    $0x1c,%esp
  8022c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022cb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8022cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022d7:	85 d2                	test   %edx,%edx
  8022d9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8022dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022e1:	89 f3                	mov    %esi,%ebx
  8022e3:	89 3c 24             	mov    %edi,(%esp)
  8022e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022ea:	75 1c                	jne    802308 <__umoddi3+0x48>
  8022ec:	39 f7                	cmp    %esi,%edi
  8022ee:	76 50                	jbe    802340 <__umoddi3+0x80>
  8022f0:	89 c8                	mov    %ecx,%eax
  8022f2:	89 f2                	mov    %esi,%edx
  8022f4:	f7 f7                	div    %edi
  8022f6:	89 d0                	mov    %edx,%eax
  8022f8:	31 d2                	xor    %edx,%edx
  8022fa:	83 c4 1c             	add    $0x1c,%esp
  8022fd:	5b                   	pop    %ebx
  8022fe:	5e                   	pop    %esi
  8022ff:	5f                   	pop    %edi
  802300:	5d                   	pop    %ebp
  802301:	c3                   	ret    
  802302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802308:	39 f2                	cmp    %esi,%edx
  80230a:	89 d0                	mov    %edx,%eax
  80230c:	77 52                	ja     802360 <__umoddi3+0xa0>
  80230e:	0f bd ea             	bsr    %edx,%ebp
  802311:	83 f5 1f             	xor    $0x1f,%ebp
  802314:	75 5a                	jne    802370 <__umoddi3+0xb0>
  802316:	3b 54 24 04          	cmp    0x4(%esp),%edx
  80231a:	0f 82 e0 00 00 00    	jb     802400 <__umoddi3+0x140>
  802320:	39 0c 24             	cmp    %ecx,(%esp)
  802323:	0f 86 d7 00 00 00    	jbe    802400 <__umoddi3+0x140>
  802329:	8b 44 24 08          	mov    0x8(%esp),%eax
  80232d:	8b 54 24 04          	mov    0x4(%esp),%edx
  802331:	83 c4 1c             	add    $0x1c,%esp
  802334:	5b                   	pop    %ebx
  802335:	5e                   	pop    %esi
  802336:	5f                   	pop    %edi
  802337:	5d                   	pop    %ebp
  802338:	c3                   	ret    
  802339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802340:	85 ff                	test   %edi,%edi
  802342:	89 fd                	mov    %edi,%ebp
  802344:	75 0b                	jne    802351 <__umoddi3+0x91>
  802346:	b8 01 00 00 00       	mov    $0x1,%eax
  80234b:	31 d2                	xor    %edx,%edx
  80234d:	f7 f7                	div    %edi
  80234f:	89 c5                	mov    %eax,%ebp
  802351:	89 f0                	mov    %esi,%eax
  802353:	31 d2                	xor    %edx,%edx
  802355:	f7 f5                	div    %ebp
  802357:	89 c8                	mov    %ecx,%eax
  802359:	f7 f5                	div    %ebp
  80235b:	89 d0                	mov    %edx,%eax
  80235d:	eb 99                	jmp    8022f8 <__umoddi3+0x38>
  80235f:	90                   	nop
  802360:	89 c8                	mov    %ecx,%eax
  802362:	89 f2                	mov    %esi,%edx
  802364:	83 c4 1c             	add    $0x1c,%esp
  802367:	5b                   	pop    %ebx
  802368:	5e                   	pop    %esi
  802369:	5f                   	pop    %edi
  80236a:	5d                   	pop    %ebp
  80236b:	c3                   	ret    
  80236c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802370:	8b 34 24             	mov    (%esp),%esi
  802373:	bf 20 00 00 00       	mov    $0x20,%edi
  802378:	89 e9                	mov    %ebp,%ecx
  80237a:	29 ef                	sub    %ebp,%edi
  80237c:	d3 e0                	shl    %cl,%eax
  80237e:	89 f9                	mov    %edi,%ecx
  802380:	89 f2                	mov    %esi,%edx
  802382:	d3 ea                	shr    %cl,%edx
  802384:	89 e9                	mov    %ebp,%ecx
  802386:	09 c2                	or     %eax,%edx
  802388:	89 d8                	mov    %ebx,%eax
  80238a:	89 14 24             	mov    %edx,(%esp)
  80238d:	89 f2                	mov    %esi,%edx
  80238f:	d3 e2                	shl    %cl,%edx
  802391:	89 f9                	mov    %edi,%ecx
  802393:	89 54 24 04          	mov    %edx,0x4(%esp)
  802397:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80239b:	d3 e8                	shr    %cl,%eax
  80239d:	89 e9                	mov    %ebp,%ecx
  80239f:	89 c6                	mov    %eax,%esi
  8023a1:	d3 e3                	shl    %cl,%ebx
  8023a3:	89 f9                	mov    %edi,%ecx
  8023a5:	89 d0                	mov    %edx,%eax
  8023a7:	d3 e8                	shr    %cl,%eax
  8023a9:	89 e9                	mov    %ebp,%ecx
  8023ab:	09 d8                	or     %ebx,%eax
  8023ad:	89 d3                	mov    %edx,%ebx
  8023af:	89 f2                	mov    %esi,%edx
  8023b1:	f7 34 24             	divl   (%esp)
  8023b4:	89 d6                	mov    %edx,%esi
  8023b6:	d3 e3                	shl    %cl,%ebx
  8023b8:	f7 64 24 04          	mull   0x4(%esp)
  8023bc:	39 d6                	cmp    %edx,%esi
  8023be:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023c2:	89 d1                	mov    %edx,%ecx
  8023c4:	89 c3                	mov    %eax,%ebx
  8023c6:	72 08                	jb     8023d0 <__umoddi3+0x110>
  8023c8:	75 11                	jne    8023db <__umoddi3+0x11b>
  8023ca:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8023ce:	73 0b                	jae    8023db <__umoddi3+0x11b>
  8023d0:	2b 44 24 04          	sub    0x4(%esp),%eax
  8023d4:	1b 14 24             	sbb    (%esp),%edx
  8023d7:	89 d1                	mov    %edx,%ecx
  8023d9:	89 c3                	mov    %eax,%ebx
  8023db:	8b 54 24 08          	mov    0x8(%esp),%edx
  8023df:	29 da                	sub    %ebx,%edx
  8023e1:	19 ce                	sbb    %ecx,%esi
  8023e3:	89 f9                	mov    %edi,%ecx
  8023e5:	89 f0                	mov    %esi,%eax
  8023e7:	d3 e0                	shl    %cl,%eax
  8023e9:	89 e9                	mov    %ebp,%ecx
  8023eb:	d3 ea                	shr    %cl,%edx
  8023ed:	89 e9                	mov    %ebp,%ecx
  8023ef:	d3 ee                	shr    %cl,%esi
  8023f1:	09 d0                	or     %edx,%eax
  8023f3:	89 f2                	mov    %esi,%edx
  8023f5:	83 c4 1c             	add    $0x1c,%esp
  8023f8:	5b                   	pop    %ebx
  8023f9:	5e                   	pop    %esi
  8023fa:	5f                   	pop    %edi
  8023fb:	5d                   	pop    %ebp
  8023fc:	c3                   	ret    
  8023fd:	8d 76 00             	lea    0x0(%esi),%esi
  802400:	29 f9                	sub    %edi,%ecx
  802402:	19 d6                	sbb    %edx,%esi
  802404:	89 74 24 04          	mov    %esi,0x4(%esp)
  802408:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80240c:	e9 18 ff ff ff       	jmp    802329 <__umoddi3+0x69>
