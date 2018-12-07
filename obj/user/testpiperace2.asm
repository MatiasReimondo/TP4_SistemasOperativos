
obj/user/testpiperace2.debug:     formato del fichero elf32-i386


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
  80002c:	e8 a5 01 00 00       	call   8001d6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 38             	sub    $0x38,%esp
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  80003c:	68 20 24 80 00       	push   $0x802420
  800041:	e8 cd 02 00 00       	call   800313 <cprintf>
	if ((r = pipe(p)) < 0)
  800046:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800049:	89 04 24             	mov    %eax,(%esp)
  80004c:	e8 55 1c 00 00       	call   801ca6 <pipe>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	85 c0                	test   %eax,%eax
  800056:	79 12                	jns    80006a <umain+0x37>
		panic("pipe: %e", r);
  800058:	50                   	push   %eax
  800059:	68 6e 24 80 00       	push   $0x80246e
  80005e:	6a 0d                	push   $0xd
  800060:	68 77 24 80 00       	push   $0x802477
  800065:	e8 d0 01 00 00       	call   80023a <_panic>
	if ((r = fork()) < 0)
  80006a:	e8 06 11 00 00       	call   801175 <fork>
  80006f:	89 c6                	mov    %eax,%esi
  800071:	85 c0                	test   %eax,%eax
  800073:	79 12                	jns    800087 <umain+0x54>
		panic("fork: %e", r);
  800075:	50                   	push   %eax
  800076:	68 30 29 80 00       	push   $0x802930
  80007b:	6a 0f                	push   $0xf
  80007d:	68 77 24 80 00       	push   $0x802477
  800082:	e8 b3 01 00 00       	call   80023a <_panic>
	if (r == 0) {
  800087:	85 c0                	test   %eax,%eax
  800089:	75 76                	jne    800101 <umain+0xce>
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800091:	e8 ac 13 00 00       	call   801442 <close>
  800096:	83 c4 10             	add    $0x10,%esp
		for (i = 0; i < 200; i++) {
  800099:	bb 00 00 00 00       	mov    $0x0,%ebx
			if (i % 10 == 0)
  80009e:	bf 67 66 66 66       	mov    $0x66666667,%edi
  8000a3:	89 d8                	mov    %ebx,%eax
  8000a5:	f7 ef                	imul   %edi
  8000a7:	c1 fa 02             	sar    $0x2,%edx
  8000aa:	89 d8                	mov    %ebx,%eax
  8000ac:	c1 f8 1f             	sar    $0x1f,%eax
  8000af:	29 c2                	sub    %eax,%edx
  8000b1:	8d 04 92             	lea    (%edx,%edx,4),%eax
  8000b4:	01 c0                	add    %eax,%eax
  8000b6:	39 c3                	cmp    %eax,%ebx
  8000b8:	75 11                	jne    8000cb <umain+0x98>
				cprintf("%d.", i);
  8000ba:	83 ec 08             	sub    $0x8,%esp
  8000bd:	53                   	push   %ebx
  8000be:	68 8c 24 80 00       	push   $0x80248c
  8000c3:	e8 4b 02 00 00       	call   800313 <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
			// dup, then close.  yield so that other guy will
			// see us while we're between them.
			dup(p[0], 10);
  8000cb:	83 ec 08             	sub    $0x8,%esp
  8000ce:	6a 0a                	push   $0xa
  8000d0:	ff 75 e0             	pushl  -0x20(%ebp)
  8000d3:	e8 ba 13 00 00       	call   801492 <dup>
			sys_yield();
  8000d8:	e8 ca 0b 00 00       	call   800ca7 <sys_yield>
			close(10);
  8000dd:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  8000e4:	e8 59 13 00 00       	call   801442 <close>
			sys_yield();
  8000e9:	e8 b9 0b 00 00       	call   800ca7 <sys_yield>
	if (r == 0) {
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
		for (i = 0; i < 200; i++) {
  8000ee:	83 c3 01             	add    $0x1,%ebx
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  8000fa:	75 a7                	jne    8000a3 <umain+0x70>
			dup(p[0], 10);
			sys_yield();
			close(10);
			sys_yield();
		}
		exit();
  8000fc:	e8 1f 01 00 00       	call   800220 <exit>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  800101:	89 f0                	mov    %esi,%eax
  800103:	25 ff 03 00 00       	and    $0x3ff,%eax
	while (kid->env_status == ENV_RUNNABLE)
  800108:	8d 3c 85 00 00 00 00 	lea    0x0(,%eax,4),%edi
  80010f:	c1 e0 07             	shl    $0x7,%eax
  800112:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800115:	eb 2f                	jmp    800146 <umain+0x113>
		if (pipeisclosed(p[0]) != 0) {
  800117:	83 ec 0c             	sub    $0xc,%esp
  80011a:	ff 75 e0             	pushl  -0x20(%ebp)
  80011d:	e8 d7 1c 00 00       	call   801df9 <pipeisclosed>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	74 28                	je     800151 <umain+0x11e>
			cprintf("\nRACE: pipe appears closed\n");
  800129:	83 ec 0c             	sub    $0xc,%esp
  80012c:	68 90 24 80 00       	push   $0x802490
  800131:	e8 dd 01 00 00       	call   800313 <cprintf>
			sys_env_destroy(r);
  800136:	89 34 24             	mov    %esi,(%esp)
  800139:	e8 23 0b 00 00       	call   800c61 <sys_env_destroy>
			exit();
  80013e:	e8 dd 00 00 00       	call   800220 <exit>
  800143:	83 c4 10             	add    $0x10,%esp
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
	while (kid->env_status == ENV_RUNNABLE)
  800146:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800149:	29 fb                	sub    %edi,%ebx
  80014b:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800151:	8b 43 54             	mov    0x54(%ebx),%eax
  800154:	83 f8 02             	cmp    $0x2,%eax
  800157:	74 be                	je     800117 <umain+0xe4>
		if (pipeisclosed(p[0]) != 0) {
			cprintf("\nRACE: pipe appears closed\n");
			sys_env_destroy(r);
			exit();
		}
	cprintf("child done with loop\n");
  800159:	83 ec 0c             	sub    $0xc,%esp
  80015c:	68 ac 24 80 00       	push   $0x8024ac
  800161:	e8 ad 01 00 00       	call   800313 <cprintf>
	if (pipeisclosed(p[0]))
  800166:	83 c4 04             	add    $0x4,%esp
  800169:	ff 75 e0             	pushl  -0x20(%ebp)
  80016c:	e8 88 1c 00 00       	call   801df9 <pipeisclosed>
  800171:	83 c4 10             	add    $0x10,%esp
  800174:	85 c0                	test   %eax,%eax
  800176:	74 14                	je     80018c <umain+0x159>
		panic("somehow the other end of p[0] got closed!");
  800178:	83 ec 04             	sub    $0x4,%esp
  80017b:	68 44 24 80 00       	push   $0x802444
  800180:	6a 40                	push   $0x40
  800182:	68 77 24 80 00       	push   $0x802477
  800187:	e8 ae 00 00 00       	call   80023a <_panic>
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80018c:	83 ec 08             	sub    $0x8,%esp
  80018f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800192:	50                   	push   %eax
  800193:	ff 75 e0             	pushl  -0x20(%ebp)
  800196:	e8 7e 11 00 00       	call   801319 <fd_lookup>
  80019b:	83 c4 10             	add    $0x10,%esp
  80019e:	85 c0                	test   %eax,%eax
  8001a0:	79 12                	jns    8001b4 <umain+0x181>
		panic("cannot look up p[0]: %e", r);
  8001a2:	50                   	push   %eax
  8001a3:	68 c2 24 80 00       	push   $0x8024c2
  8001a8:	6a 42                	push   $0x42
  8001aa:	68 77 24 80 00       	push   $0x802477
  8001af:	e8 86 00 00 00       	call   80023a <_panic>
	(void) fd2data(fd);
  8001b4:	83 ec 0c             	sub    $0xc,%esp
  8001b7:	ff 75 dc             	pushl  -0x24(%ebp)
  8001ba:	e8 f3 10 00 00       	call   8012b2 <fd2data>
	cprintf("race didn't happen\n");
  8001bf:	c7 04 24 da 24 80 00 	movl   $0x8024da,(%esp)
  8001c6:	e8 48 01 00 00       	call   800313 <cprintf>
}
  8001cb:	83 c4 10             	add    $0x10,%esp
  8001ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d1:	5b                   	pop    %ebx
  8001d2:	5e                   	pop    %esi
  8001d3:	5f                   	pop    %edi
  8001d4:	5d                   	pop    %ebp
  8001d5:	c3                   	ret    

008001d6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001d6:	55                   	push   %ebp
  8001d7:	89 e5                	mov    %esp,%ebp
  8001d9:	56                   	push   %esi
  8001da:	53                   	push   %ebx
  8001db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001de:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8001e1:	e8 9d 0a 00 00       	call   800c83 <sys_getenvid>
	if (id >= 0)
  8001e6:	85 c0                	test   %eax,%eax
  8001e8:	78 12                	js     8001fc <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  8001ea:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ef:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001f2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001f7:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001fc:	85 db                	test   %ebx,%ebx
  8001fe:	7e 07                	jle    800207 <libmain+0x31>
		binaryname = argv[0];
  800200:	8b 06                	mov    (%esi),%eax
  800202:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800207:	83 ec 08             	sub    $0x8,%esp
  80020a:	56                   	push   %esi
  80020b:	53                   	push   %ebx
  80020c:	e8 22 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800211:	e8 0a 00 00 00       	call   800220 <exit>
}
  800216:	83 c4 10             	add    $0x10,%esp
  800219:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80021c:	5b                   	pop    %ebx
  80021d:	5e                   	pop    %esi
  80021e:	5d                   	pop    %ebp
  80021f:	c3                   	ret    

00800220 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800226:	e8 42 12 00 00       	call   80146d <close_all>
	sys_env_destroy(0);
  80022b:	83 ec 0c             	sub    $0xc,%esp
  80022e:	6a 00                	push   $0x0
  800230:	e8 2c 0a 00 00       	call   800c61 <sys_env_destroy>
}
  800235:	83 c4 10             	add    $0x10,%esp
  800238:	c9                   	leave  
  800239:	c3                   	ret    

0080023a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	56                   	push   %esi
  80023e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80023f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800242:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800248:	e8 36 0a 00 00       	call   800c83 <sys_getenvid>
  80024d:	83 ec 0c             	sub    $0xc,%esp
  800250:	ff 75 0c             	pushl  0xc(%ebp)
  800253:	ff 75 08             	pushl  0x8(%ebp)
  800256:	56                   	push   %esi
  800257:	50                   	push   %eax
  800258:	68 f8 24 80 00       	push   $0x8024f8
  80025d:	e8 b1 00 00 00       	call   800313 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800262:	83 c4 18             	add    $0x18,%esp
  800265:	53                   	push   %ebx
  800266:	ff 75 10             	pushl  0x10(%ebp)
  800269:	e8 54 00 00 00       	call   8002c2 <vcprintf>
	cprintf("\n");
  80026e:	c7 04 24 87 2a 80 00 	movl   $0x802a87,(%esp)
  800275:	e8 99 00 00 00       	call   800313 <cprintf>
  80027a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80027d:	cc                   	int3   
  80027e:	eb fd                	jmp    80027d <_panic+0x43>

00800280 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	53                   	push   %ebx
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80028a:	8b 13                	mov    (%ebx),%edx
  80028c:	8d 42 01             	lea    0x1(%edx),%eax
  80028f:	89 03                	mov    %eax,(%ebx)
  800291:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800294:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800298:	3d ff 00 00 00       	cmp    $0xff,%eax
  80029d:	75 1a                	jne    8002b9 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  80029f:	83 ec 08             	sub    $0x8,%esp
  8002a2:	68 ff 00 00 00       	push   $0xff
  8002a7:	8d 43 08             	lea    0x8(%ebx),%eax
  8002aa:	50                   	push   %eax
  8002ab:	e8 67 09 00 00       	call   800c17 <sys_cputs>
		b->idx = 0;
  8002b0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002b6:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  8002b9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002cb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002d2:	00 00 00 
	b.cnt = 0;
  8002d5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002dc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002df:	ff 75 0c             	pushl  0xc(%ebp)
  8002e2:	ff 75 08             	pushl  0x8(%ebp)
  8002e5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002eb:	50                   	push   %eax
  8002ec:	68 80 02 80 00       	push   $0x800280
  8002f1:	e8 86 01 00 00       	call   80047c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002f6:	83 c4 08             	add    $0x8,%esp
  8002f9:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002ff:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800305:	50                   	push   %eax
  800306:	e8 0c 09 00 00       	call   800c17 <sys_cputs>

	return b.cnt;
}
  80030b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800311:	c9                   	leave  
  800312:	c3                   	ret    

00800313 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800319:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80031c:	50                   	push   %eax
  80031d:	ff 75 08             	pushl  0x8(%ebp)
  800320:	e8 9d ff ff ff       	call   8002c2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800325:	c9                   	leave  
  800326:	c3                   	ret    

00800327 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	57                   	push   %edi
  80032b:	56                   	push   %esi
  80032c:	53                   	push   %ebx
  80032d:	83 ec 1c             	sub    $0x1c,%esp
  800330:	89 c7                	mov    %eax,%edi
  800332:	89 d6                	mov    %edx,%esi
  800334:	8b 45 08             	mov    0x8(%ebp),%eax
  800337:	8b 55 0c             	mov    0xc(%ebp),%edx
  80033a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80033d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800340:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800343:	bb 00 00 00 00       	mov    $0x0,%ebx
  800348:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80034b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80034e:	39 d3                	cmp    %edx,%ebx
  800350:	72 05                	jb     800357 <printnum+0x30>
  800352:	39 45 10             	cmp    %eax,0x10(%ebp)
  800355:	77 45                	ja     80039c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	ff 75 18             	pushl  0x18(%ebp)
  80035d:	8b 45 14             	mov    0x14(%ebp),%eax
  800360:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800363:	53                   	push   %ebx
  800364:	ff 75 10             	pushl  0x10(%ebp)
  800367:	83 ec 08             	sub    $0x8,%esp
  80036a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80036d:	ff 75 e0             	pushl  -0x20(%ebp)
  800370:	ff 75 dc             	pushl  -0x24(%ebp)
  800373:	ff 75 d8             	pushl  -0x28(%ebp)
  800376:	e8 05 1e 00 00       	call   802180 <__udivdi3>
  80037b:	83 c4 18             	add    $0x18,%esp
  80037e:	52                   	push   %edx
  80037f:	50                   	push   %eax
  800380:	89 f2                	mov    %esi,%edx
  800382:	89 f8                	mov    %edi,%eax
  800384:	e8 9e ff ff ff       	call   800327 <printnum>
  800389:	83 c4 20             	add    $0x20,%esp
  80038c:	eb 18                	jmp    8003a6 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80038e:	83 ec 08             	sub    $0x8,%esp
  800391:	56                   	push   %esi
  800392:	ff 75 18             	pushl  0x18(%ebp)
  800395:	ff d7                	call   *%edi
  800397:	83 c4 10             	add    $0x10,%esp
  80039a:	eb 03                	jmp    80039f <printnum+0x78>
  80039c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80039f:	83 eb 01             	sub    $0x1,%ebx
  8003a2:	85 db                	test   %ebx,%ebx
  8003a4:	7f e8                	jg     80038e <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003a6:	83 ec 08             	sub    $0x8,%esp
  8003a9:	56                   	push   %esi
  8003aa:	83 ec 04             	sub    $0x4,%esp
  8003ad:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b0:	ff 75 e0             	pushl  -0x20(%ebp)
  8003b3:	ff 75 dc             	pushl  -0x24(%ebp)
  8003b6:	ff 75 d8             	pushl  -0x28(%ebp)
  8003b9:	e8 f2 1e 00 00       	call   8022b0 <__umoddi3>
  8003be:	83 c4 14             	add    $0x14,%esp
  8003c1:	0f be 80 1b 25 80 00 	movsbl 0x80251b(%eax),%eax
  8003c8:	50                   	push   %eax
  8003c9:	ff d7                	call   *%edi
}
  8003cb:	83 c4 10             	add    $0x10,%esp
  8003ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003d1:	5b                   	pop    %ebx
  8003d2:	5e                   	pop    %esi
  8003d3:	5f                   	pop    %edi
  8003d4:	5d                   	pop    %ebp
  8003d5:	c3                   	ret    

008003d6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003d6:	55                   	push   %ebp
  8003d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003d9:	83 fa 01             	cmp    $0x1,%edx
  8003dc:	7e 0e                	jle    8003ec <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003de:	8b 10                	mov    (%eax),%edx
  8003e0:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003e3:	89 08                	mov    %ecx,(%eax)
  8003e5:	8b 02                	mov    (%edx),%eax
  8003e7:	8b 52 04             	mov    0x4(%edx),%edx
  8003ea:	eb 22                	jmp    80040e <getuint+0x38>
	else if (lflag)
  8003ec:	85 d2                	test   %edx,%edx
  8003ee:	74 10                	je     800400 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003f0:	8b 10                	mov    (%eax),%edx
  8003f2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003f5:	89 08                	mov    %ecx,(%eax)
  8003f7:	8b 02                	mov    (%edx),%eax
  8003f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8003fe:	eb 0e                	jmp    80040e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800400:	8b 10                	mov    (%eax),%edx
  800402:	8d 4a 04             	lea    0x4(%edx),%ecx
  800405:	89 08                	mov    %ecx,(%eax)
  800407:	8b 02                	mov    (%edx),%eax
  800409:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80040e:	5d                   	pop    %ebp
  80040f:	c3                   	ret    

00800410 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800413:	83 fa 01             	cmp    $0x1,%edx
  800416:	7e 0e                	jle    800426 <getint+0x16>
		return va_arg(*ap, long long);
  800418:	8b 10                	mov    (%eax),%edx
  80041a:	8d 4a 08             	lea    0x8(%edx),%ecx
  80041d:	89 08                	mov    %ecx,(%eax)
  80041f:	8b 02                	mov    (%edx),%eax
  800421:	8b 52 04             	mov    0x4(%edx),%edx
  800424:	eb 1a                	jmp    800440 <getint+0x30>
	else if (lflag)
  800426:	85 d2                	test   %edx,%edx
  800428:	74 0c                	je     800436 <getint+0x26>
		return va_arg(*ap, long);
  80042a:	8b 10                	mov    (%eax),%edx
  80042c:	8d 4a 04             	lea    0x4(%edx),%ecx
  80042f:	89 08                	mov    %ecx,(%eax)
  800431:	8b 02                	mov    (%edx),%eax
  800433:	99                   	cltd   
  800434:	eb 0a                	jmp    800440 <getint+0x30>
	else
		return va_arg(*ap, int);
  800436:	8b 10                	mov    (%eax),%edx
  800438:	8d 4a 04             	lea    0x4(%edx),%ecx
  80043b:	89 08                	mov    %ecx,(%eax)
  80043d:	8b 02                	mov    (%edx),%eax
  80043f:	99                   	cltd   
}
  800440:	5d                   	pop    %ebp
  800441:	c3                   	ret    

00800442 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800442:	55                   	push   %ebp
  800443:	89 e5                	mov    %esp,%ebp
  800445:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800448:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80044c:	8b 10                	mov    (%eax),%edx
  80044e:	3b 50 04             	cmp    0x4(%eax),%edx
  800451:	73 0a                	jae    80045d <sprintputch+0x1b>
		*b->buf++ = ch;
  800453:	8d 4a 01             	lea    0x1(%edx),%ecx
  800456:	89 08                	mov    %ecx,(%eax)
  800458:	8b 45 08             	mov    0x8(%ebp),%eax
  80045b:	88 02                	mov    %al,(%edx)
}
  80045d:	5d                   	pop    %ebp
  80045e:	c3                   	ret    

0080045f <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80045f:	55                   	push   %ebp
  800460:	89 e5                	mov    %esp,%ebp
  800462:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800465:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800468:	50                   	push   %eax
  800469:	ff 75 10             	pushl  0x10(%ebp)
  80046c:	ff 75 0c             	pushl  0xc(%ebp)
  80046f:	ff 75 08             	pushl  0x8(%ebp)
  800472:	e8 05 00 00 00       	call   80047c <vprintfmt>
	va_end(ap);
}
  800477:	83 c4 10             	add    $0x10,%esp
  80047a:	c9                   	leave  
  80047b:	c3                   	ret    

0080047c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80047c:	55                   	push   %ebp
  80047d:	89 e5                	mov    %esp,%ebp
  80047f:	57                   	push   %edi
  800480:	56                   	push   %esi
  800481:	53                   	push   %ebx
  800482:	83 ec 2c             	sub    $0x2c,%esp
  800485:	8b 75 08             	mov    0x8(%ebp),%esi
  800488:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80048b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80048e:	eb 12                	jmp    8004a2 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800490:	85 c0                	test   %eax,%eax
  800492:	0f 84 44 03 00 00    	je     8007dc <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  800498:	83 ec 08             	sub    $0x8,%esp
  80049b:	53                   	push   %ebx
  80049c:	50                   	push   %eax
  80049d:	ff d6                	call   *%esi
  80049f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004a2:	83 c7 01             	add    $0x1,%edi
  8004a5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004a9:	83 f8 25             	cmp    $0x25,%eax
  8004ac:	75 e2                	jne    800490 <vprintfmt+0x14>
  8004ae:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8004b2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8004b9:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004c0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8004c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004cc:	eb 07                	jmp    8004d5 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8004d1:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004d5:	8d 47 01             	lea    0x1(%edi),%eax
  8004d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004db:	0f b6 07             	movzbl (%edi),%eax
  8004de:	0f b6 c8             	movzbl %al,%ecx
  8004e1:	83 e8 23             	sub    $0x23,%eax
  8004e4:	3c 55                	cmp    $0x55,%al
  8004e6:	0f 87 d5 02 00 00    	ja     8007c1 <vprintfmt+0x345>
  8004ec:	0f b6 c0             	movzbl %al,%eax
  8004ef:	ff 24 85 60 26 80 00 	jmp    *0x802660(,%eax,4)
  8004f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004f9:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8004fd:	eb d6                	jmp    8004d5 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800502:	b8 00 00 00 00       	mov    $0x0,%eax
  800507:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80050a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80050d:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  800511:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  800514:	8d 51 d0             	lea    -0x30(%ecx),%edx
  800517:	83 fa 09             	cmp    $0x9,%edx
  80051a:	77 39                	ja     800555 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80051c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80051f:	eb e9                	jmp    80050a <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800521:	8b 45 14             	mov    0x14(%ebp),%eax
  800524:	8d 48 04             	lea    0x4(%eax),%ecx
  800527:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80052a:	8b 00                	mov    (%eax),%eax
  80052c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800532:	eb 27                	jmp    80055b <vprintfmt+0xdf>
  800534:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800537:	85 c0                	test   %eax,%eax
  800539:	b9 00 00 00 00       	mov    $0x0,%ecx
  80053e:	0f 49 c8             	cmovns %eax,%ecx
  800541:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800544:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800547:	eb 8c                	jmp    8004d5 <vprintfmt+0x59>
  800549:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80054c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800553:	eb 80                	jmp    8004d5 <vprintfmt+0x59>
  800555:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800558:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  80055b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80055f:	0f 89 70 ff ff ff    	jns    8004d5 <vprintfmt+0x59>
				width = precision, precision = -1;
  800565:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800568:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80056b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800572:	e9 5e ff ff ff       	jmp    8004d5 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800577:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80057d:	e9 53 ff ff ff       	jmp    8004d5 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800582:	8b 45 14             	mov    0x14(%ebp),%eax
  800585:	8d 50 04             	lea    0x4(%eax),%edx
  800588:	89 55 14             	mov    %edx,0x14(%ebp)
  80058b:	83 ec 08             	sub    $0x8,%esp
  80058e:	53                   	push   %ebx
  80058f:	ff 30                	pushl  (%eax)
  800591:	ff d6                	call   *%esi
			break;
  800593:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800596:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800599:	e9 04 ff ff ff       	jmp    8004a2 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80059e:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a1:	8d 50 04             	lea    0x4(%eax),%edx
  8005a4:	89 55 14             	mov    %edx,0x14(%ebp)
  8005a7:	8b 00                	mov    (%eax),%eax
  8005a9:	99                   	cltd   
  8005aa:	31 d0                	xor    %edx,%eax
  8005ac:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005ae:	83 f8 0f             	cmp    $0xf,%eax
  8005b1:	7f 0b                	jg     8005be <vprintfmt+0x142>
  8005b3:	8b 14 85 c0 27 80 00 	mov    0x8027c0(,%eax,4),%edx
  8005ba:	85 d2                	test   %edx,%edx
  8005bc:	75 18                	jne    8005d6 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  8005be:	50                   	push   %eax
  8005bf:	68 33 25 80 00       	push   $0x802533
  8005c4:	53                   	push   %ebx
  8005c5:	56                   	push   %esi
  8005c6:	e8 94 fe ff ff       	call   80045f <printfmt>
  8005cb:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8005d1:	e9 cc fe ff ff       	jmp    8004a2 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  8005d6:	52                   	push   %edx
  8005d7:	68 55 2a 80 00       	push   $0x802a55
  8005dc:	53                   	push   %ebx
  8005dd:	56                   	push   %esi
  8005de:	e8 7c fe ff ff       	call   80045f <printfmt>
  8005e3:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005e9:	e9 b4 fe ff ff       	jmp    8004a2 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f1:	8d 50 04             	lea    0x4(%eax),%edx
  8005f4:	89 55 14             	mov    %edx,0x14(%ebp)
  8005f7:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8005f9:	85 ff                	test   %edi,%edi
  8005fb:	b8 2c 25 80 00       	mov    $0x80252c,%eax
  800600:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800603:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800607:	0f 8e 94 00 00 00    	jle    8006a1 <vprintfmt+0x225>
  80060d:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800611:	0f 84 98 00 00 00    	je     8006af <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	ff 75 d0             	pushl  -0x30(%ebp)
  80061d:	57                   	push   %edi
  80061e:	e8 41 02 00 00       	call   800864 <strnlen>
  800623:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800626:	29 c1                	sub    %eax,%ecx
  800628:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80062b:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80062e:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800632:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800635:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800638:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80063a:	eb 0f                	jmp    80064b <vprintfmt+0x1cf>
					putch(padc, putdat);
  80063c:	83 ec 08             	sub    $0x8,%esp
  80063f:	53                   	push   %ebx
  800640:	ff 75 e0             	pushl  -0x20(%ebp)
  800643:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800645:	83 ef 01             	sub    $0x1,%edi
  800648:	83 c4 10             	add    $0x10,%esp
  80064b:	85 ff                	test   %edi,%edi
  80064d:	7f ed                	jg     80063c <vprintfmt+0x1c0>
  80064f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800652:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800655:	85 c9                	test   %ecx,%ecx
  800657:	b8 00 00 00 00       	mov    $0x0,%eax
  80065c:	0f 49 c1             	cmovns %ecx,%eax
  80065f:	29 c1                	sub    %eax,%ecx
  800661:	89 75 08             	mov    %esi,0x8(%ebp)
  800664:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800667:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80066a:	89 cb                	mov    %ecx,%ebx
  80066c:	eb 4d                	jmp    8006bb <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80066e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800672:	74 1b                	je     80068f <vprintfmt+0x213>
  800674:	0f be c0             	movsbl %al,%eax
  800677:	83 e8 20             	sub    $0x20,%eax
  80067a:	83 f8 5e             	cmp    $0x5e,%eax
  80067d:	76 10                	jbe    80068f <vprintfmt+0x213>
					putch('?', putdat);
  80067f:	83 ec 08             	sub    $0x8,%esp
  800682:	ff 75 0c             	pushl  0xc(%ebp)
  800685:	6a 3f                	push   $0x3f
  800687:	ff 55 08             	call   *0x8(%ebp)
  80068a:	83 c4 10             	add    $0x10,%esp
  80068d:	eb 0d                	jmp    80069c <vprintfmt+0x220>
				else
					putch(ch, putdat);
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	ff 75 0c             	pushl  0xc(%ebp)
  800695:	52                   	push   %edx
  800696:	ff 55 08             	call   *0x8(%ebp)
  800699:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80069c:	83 eb 01             	sub    $0x1,%ebx
  80069f:	eb 1a                	jmp    8006bb <vprintfmt+0x23f>
  8006a1:	89 75 08             	mov    %esi,0x8(%ebp)
  8006a4:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006a7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006aa:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006ad:	eb 0c                	jmp    8006bb <vprintfmt+0x23f>
  8006af:	89 75 08             	mov    %esi,0x8(%ebp)
  8006b2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006b5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006b8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006bb:	83 c7 01             	add    $0x1,%edi
  8006be:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006c2:	0f be d0             	movsbl %al,%edx
  8006c5:	85 d2                	test   %edx,%edx
  8006c7:	74 23                	je     8006ec <vprintfmt+0x270>
  8006c9:	85 f6                	test   %esi,%esi
  8006cb:	78 a1                	js     80066e <vprintfmt+0x1f2>
  8006cd:	83 ee 01             	sub    $0x1,%esi
  8006d0:	79 9c                	jns    80066e <vprintfmt+0x1f2>
  8006d2:	89 df                	mov    %ebx,%edi
  8006d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8006d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006da:	eb 18                	jmp    8006f4 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006dc:	83 ec 08             	sub    $0x8,%esp
  8006df:	53                   	push   %ebx
  8006e0:	6a 20                	push   $0x20
  8006e2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006e4:	83 ef 01             	sub    $0x1,%edi
  8006e7:	83 c4 10             	add    $0x10,%esp
  8006ea:	eb 08                	jmp    8006f4 <vprintfmt+0x278>
  8006ec:	89 df                	mov    %ebx,%edi
  8006ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8006f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006f4:	85 ff                	test   %edi,%edi
  8006f6:	7f e4                	jg     8006dc <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006fb:	e9 a2 fd ff ff       	jmp    8004a2 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800700:	8d 45 14             	lea    0x14(%ebp),%eax
  800703:	e8 08 fd ff ff       	call   800410 <getint>
  800708:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80070e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800713:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800717:	79 74                	jns    80078d <vprintfmt+0x311>
				putch('-', putdat);
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	53                   	push   %ebx
  80071d:	6a 2d                	push   $0x2d
  80071f:	ff d6                	call   *%esi
				num = -(long long) num;
  800721:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800724:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800727:	f7 d8                	neg    %eax
  800729:	83 d2 00             	adc    $0x0,%edx
  80072c:	f7 da                	neg    %edx
  80072e:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  800731:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800736:	eb 55                	jmp    80078d <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800738:	8d 45 14             	lea    0x14(%ebp),%eax
  80073b:	e8 96 fc ff ff       	call   8003d6 <getuint>
			base = 10;
  800740:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800745:	eb 46                	jmp    80078d <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800747:	8d 45 14             	lea    0x14(%ebp),%eax
  80074a:	e8 87 fc ff ff       	call   8003d6 <getuint>
			base = 8;
  80074f:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800754:	eb 37                	jmp    80078d <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	53                   	push   %ebx
  80075a:	6a 30                	push   $0x30
  80075c:	ff d6                	call   *%esi
			putch('x', putdat);
  80075e:	83 c4 08             	add    $0x8,%esp
  800761:	53                   	push   %ebx
  800762:	6a 78                	push   $0x78
  800764:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	8d 50 04             	lea    0x4(%eax),%edx
  80076c:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80076f:	8b 00                	mov    (%eax),%eax
  800771:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800776:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800779:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80077e:	eb 0d                	jmp    80078d <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800780:	8d 45 14             	lea    0x14(%ebp),%eax
  800783:	e8 4e fc ff ff       	call   8003d6 <getuint>
			base = 16;
  800788:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  80078d:	83 ec 0c             	sub    $0xc,%esp
  800790:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800794:	57                   	push   %edi
  800795:	ff 75 e0             	pushl  -0x20(%ebp)
  800798:	51                   	push   %ecx
  800799:	52                   	push   %edx
  80079a:	50                   	push   %eax
  80079b:	89 da                	mov    %ebx,%edx
  80079d:	89 f0                	mov    %esi,%eax
  80079f:	e8 83 fb ff ff       	call   800327 <printnum>
			break;
  8007a4:	83 c4 20             	add    $0x20,%esp
  8007a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8007aa:	e9 f3 fc ff ff       	jmp    8004a2 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	53                   	push   %ebx
  8007b3:	51                   	push   %ecx
  8007b4:	ff d6                	call   *%esi
			break;
  8007b6:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8007bc:	e9 e1 fc ff ff       	jmp    8004a2 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	53                   	push   %ebx
  8007c5:	6a 25                	push   $0x25
  8007c7:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007c9:	83 c4 10             	add    $0x10,%esp
  8007cc:	eb 03                	jmp    8007d1 <vprintfmt+0x355>
  8007ce:	83 ef 01             	sub    $0x1,%edi
  8007d1:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  8007d5:	75 f7                	jne    8007ce <vprintfmt+0x352>
  8007d7:	e9 c6 fc ff ff       	jmp    8004a2 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  8007dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007df:	5b                   	pop    %ebx
  8007e0:	5e                   	pop    %esi
  8007e1:	5f                   	pop    %edi
  8007e2:	5d                   	pop    %ebp
  8007e3:	c3                   	ret    

008007e4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007e4:	55                   	push   %ebp
  8007e5:	89 e5                	mov    %esp,%ebp
  8007e7:	83 ec 18             	sub    $0x18,%esp
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007f3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007f7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800801:	85 c0                	test   %eax,%eax
  800803:	74 26                	je     80082b <vsnprintf+0x47>
  800805:	85 d2                	test   %edx,%edx
  800807:	7e 22                	jle    80082b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800809:	ff 75 14             	pushl  0x14(%ebp)
  80080c:	ff 75 10             	pushl  0x10(%ebp)
  80080f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800812:	50                   	push   %eax
  800813:	68 42 04 80 00       	push   $0x800442
  800818:	e8 5f fc ff ff       	call   80047c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80081d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800820:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800826:	83 c4 10             	add    $0x10,%esp
  800829:	eb 05                	jmp    800830 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80082b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800830:	c9                   	leave  
  800831:	c3                   	ret    

00800832 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
  800835:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800838:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80083b:	50                   	push   %eax
  80083c:	ff 75 10             	pushl  0x10(%ebp)
  80083f:	ff 75 0c             	pushl  0xc(%ebp)
  800842:	ff 75 08             	pushl  0x8(%ebp)
  800845:	e8 9a ff ff ff       	call   8007e4 <vsnprintf>
	va_end(ap);

	return rc;
}
  80084a:	c9                   	leave  
  80084b:	c3                   	ret    

0080084c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
  80084f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800852:	b8 00 00 00 00       	mov    $0x0,%eax
  800857:	eb 03                	jmp    80085c <strlen+0x10>
		n++;
  800859:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80085c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800860:	75 f7                	jne    800859 <strlen+0xd>
		n++;
	return n;
}
  800862:	5d                   	pop    %ebp
  800863:	c3                   	ret    

00800864 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800864:	55                   	push   %ebp
  800865:	89 e5                	mov    %esp,%ebp
  800867:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80086a:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80086d:	ba 00 00 00 00       	mov    $0x0,%edx
  800872:	eb 03                	jmp    800877 <strnlen+0x13>
		n++;
  800874:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800877:	39 c2                	cmp    %eax,%edx
  800879:	74 08                	je     800883 <strnlen+0x1f>
  80087b:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80087f:	75 f3                	jne    800874 <strnlen+0x10>
  800881:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  800883:	5d                   	pop    %ebp
  800884:	c3                   	ret    

00800885 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	53                   	push   %ebx
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80088f:	89 c2                	mov    %eax,%edx
  800891:	83 c2 01             	add    $0x1,%edx
  800894:	83 c1 01             	add    $0x1,%ecx
  800897:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80089b:	88 5a ff             	mov    %bl,-0x1(%edx)
  80089e:	84 db                	test   %bl,%bl
  8008a0:	75 ef                	jne    800891 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008a2:	5b                   	pop    %ebx
  8008a3:	5d                   	pop    %ebp
  8008a4:	c3                   	ret    

008008a5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008a5:	55                   	push   %ebp
  8008a6:	89 e5                	mov    %esp,%ebp
  8008a8:	53                   	push   %ebx
  8008a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008ac:	53                   	push   %ebx
  8008ad:	e8 9a ff ff ff       	call   80084c <strlen>
  8008b2:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008b5:	ff 75 0c             	pushl  0xc(%ebp)
  8008b8:	01 d8                	add    %ebx,%eax
  8008ba:	50                   	push   %eax
  8008bb:	e8 c5 ff ff ff       	call   800885 <strcpy>
	return dst;
}
  8008c0:	89 d8                	mov    %ebx,%eax
  8008c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c5:	c9                   	leave  
  8008c6:	c3                   	ret    

008008c7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008c7:	55                   	push   %ebp
  8008c8:	89 e5                	mov    %esp,%ebp
  8008ca:	56                   	push   %esi
  8008cb:	53                   	push   %ebx
  8008cc:	8b 75 08             	mov    0x8(%ebp),%esi
  8008cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008d2:	89 f3                	mov    %esi,%ebx
  8008d4:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008d7:	89 f2                	mov    %esi,%edx
  8008d9:	eb 0f                	jmp    8008ea <strncpy+0x23>
		*dst++ = *src;
  8008db:	83 c2 01             	add    $0x1,%edx
  8008de:	0f b6 01             	movzbl (%ecx),%eax
  8008e1:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008e4:	80 39 01             	cmpb   $0x1,(%ecx)
  8008e7:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008ea:	39 da                	cmp    %ebx,%edx
  8008ec:	75 ed                	jne    8008db <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008ee:	89 f0                	mov    %esi,%eax
  8008f0:	5b                   	pop    %ebx
  8008f1:	5e                   	pop    %esi
  8008f2:	5d                   	pop    %ebp
  8008f3:	c3                   	ret    

008008f4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	56                   	push   %esi
  8008f8:	53                   	push   %ebx
  8008f9:	8b 75 08             	mov    0x8(%ebp),%esi
  8008fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ff:	8b 55 10             	mov    0x10(%ebp),%edx
  800902:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800904:	85 d2                	test   %edx,%edx
  800906:	74 21                	je     800929 <strlcpy+0x35>
  800908:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80090c:	89 f2                	mov    %esi,%edx
  80090e:	eb 09                	jmp    800919 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800910:	83 c2 01             	add    $0x1,%edx
  800913:	83 c1 01             	add    $0x1,%ecx
  800916:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800919:	39 c2                	cmp    %eax,%edx
  80091b:	74 09                	je     800926 <strlcpy+0x32>
  80091d:	0f b6 19             	movzbl (%ecx),%ebx
  800920:	84 db                	test   %bl,%bl
  800922:	75 ec                	jne    800910 <strlcpy+0x1c>
  800924:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  800926:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800929:	29 f0                	sub    %esi,%eax
}
  80092b:	5b                   	pop    %ebx
  80092c:	5e                   	pop    %esi
  80092d:	5d                   	pop    %ebp
  80092e:	c3                   	ret    

0080092f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800935:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800938:	eb 06                	jmp    800940 <strcmp+0x11>
		p++, q++;
  80093a:	83 c1 01             	add    $0x1,%ecx
  80093d:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800940:	0f b6 01             	movzbl (%ecx),%eax
  800943:	84 c0                	test   %al,%al
  800945:	74 04                	je     80094b <strcmp+0x1c>
  800947:	3a 02                	cmp    (%edx),%al
  800949:	74 ef                	je     80093a <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80094b:	0f b6 c0             	movzbl %al,%eax
  80094e:	0f b6 12             	movzbl (%edx),%edx
  800951:	29 d0                	sub    %edx,%eax
}
  800953:	5d                   	pop    %ebp
  800954:	c3                   	ret    

00800955 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	53                   	push   %ebx
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095f:	89 c3                	mov    %eax,%ebx
  800961:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800964:	eb 06                	jmp    80096c <strncmp+0x17>
		n--, p++, q++;
  800966:	83 c0 01             	add    $0x1,%eax
  800969:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80096c:	39 d8                	cmp    %ebx,%eax
  80096e:	74 15                	je     800985 <strncmp+0x30>
  800970:	0f b6 08             	movzbl (%eax),%ecx
  800973:	84 c9                	test   %cl,%cl
  800975:	74 04                	je     80097b <strncmp+0x26>
  800977:	3a 0a                	cmp    (%edx),%cl
  800979:	74 eb                	je     800966 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80097b:	0f b6 00             	movzbl (%eax),%eax
  80097e:	0f b6 12             	movzbl (%edx),%edx
  800981:	29 d0                	sub    %edx,%eax
  800983:	eb 05                	jmp    80098a <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800985:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  80098a:	5b                   	pop    %ebx
  80098b:	5d                   	pop    %ebp
  80098c:	c3                   	ret    

0080098d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800997:	eb 07                	jmp    8009a0 <strchr+0x13>
		if (*s == c)
  800999:	38 ca                	cmp    %cl,%dl
  80099b:	74 0f                	je     8009ac <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80099d:	83 c0 01             	add    $0x1,%eax
  8009a0:	0f b6 10             	movzbl (%eax),%edx
  8009a3:	84 d2                	test   %dl,%dl
  8009a5:	75 f2                	jne    800999 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8009a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ac:	5d                   	pop    %ebp
  8009ad:	c3                   	ret    

008009ae <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b8:	eb 03                	jmp    8009bd <strfind+0xf>
  8009ba:	83 c0 01             	add    $0x1,%eax
  8009bd:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009c0:	38 ca                	cmp    %cl,%dl
  8009c2:	74 04                	je     8009c8 <strfind+0x1a>
  8009c4:	84 d2                	test   %dl,%dl
  8009c6:	75 f2                	jne    8009ba <strfind+0xc>
			break;
	return (char *) s;
}
  8009c8:	5d                   	pop    %ebp
  8009c9:	c3                   	ret    

008009ca <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	57                   	push   %edi
  8009ce:	56                   	push   %esi
  8009cf:	53                   	push   %ebx
  8009d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8009d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  8009d6:	85 c9                	test   %ecx,%ecx
  8009d8:	74 37                	je     800a11 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009da:	f6 c2 03             	test   $0x3,%dl
  8009dd:	75 2a                	jne    800a09 <memset+0x3f>
  8009df:	f6 c1 03             	test   $0x3,%cl
  8009e2:	75 25                	jne    800a09 <memset+0x3f>
		c &= 0xFF;
  8009e4:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009e8:	89 df                	mov    %ebx,%edi
  8009ea:	c1 e7 08             	shl    $0x8,%edi
  8009ed:	89 de                	mov    %ebx,%esi
  8009ef:	c1 e6 18             	shl    $0x18,%esi
  8009f2:	89 d8                	mov    %ebx,%eax
  8009f4:	c1 e0 10             	shl    $0x10,%eax
  8009f7:	09 f0                	or     %esi,%eax
  8009f9:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8009fb:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8009fe:	89 f8                	mov    %edi,%eax
  800a00:	09 d8                	or     %ebx,%eax
  800a02:	89 d7                	mov    %edx,%edi
  800a04:	fc                   	cld    
  800a05:	f3 ab                	rep stos %eax,%es:(%edi)
  800a07:	eb 08                	jmp    800a11 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a09:	89 d7                	mov    %edx,%edi
  800a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0e:	fc                   	cld    
  800a0f:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800a11:	89 d0                	mov    %edx,%eax
  800a13:	5b                   	pop    %ebx
  800a14:	5e                   	pop    %esi
  800a15:	5f                   	pop    %edi
  800a16:	5d                   	pop    %ebp
  800a17:	c3                   	ret    

00800a18 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a18:	55                   	push   %ebp
  800a19:	89 e5                	mov    %esp,%ebp
  800a1b:	57                   	push   %edi
  800a1c:	56                   	push   %esi
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a23:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a26:	39 c6                	cmp    %eax,%esi
  800a28:	73 35                	jae    800a5f <memmove+0x47>
  800a2a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a2d:	39 d0                	cmp    %edx,%eax
  800a2f:	73 2e                	jae    800a5f <memmove+0x47>
		s += n;
		d += n;
  800a31:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a34:	89 d6                	mov    %edx,%esi
  800a36:	09 fe                	or     %edi,%esi
  800a38:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a3e:	75 13                	jne    800a53 <memmove+0x3b>
  800a40:	f6 c1 03             	test   $0x3,%cl
  800a43:	75 0e                	jne    800a53 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  800a45:	83 ef 04             	sub    $0x4,%edi
  800a48:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a4b:	c1 e9 02             	shr    $0x2,%ecx
  800a4e:	fd                   	std    
  800a4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a51:	eb 09                	jmp    800a5c <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a53:	83 ef 01             	sub    $0x1,%edi
  800a56:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a59:	fd                   	std    
  800a5a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a5c:	fc                   	cld    
  800a5d:	eb 1d                	jmp    800a7c <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a5f:	89 f2                	mov    %esi,%edx
  800a61:	09 c2                	or     %eax,%edx
  800a63:	f6 c2 03             	test   $0x3,%dl
  800a66:	75 0f                	jne    800a77 <memmove+0x5f>
  800a68:	f6 c1 03             	test   $0x3,%cl
  800a6b:	75 0a                	jne    800a77 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  800a6d:	c1 e9 02             	shr    $0x2,%ecx
  800a70:	89 c7                	mov    %eax,%edi
  800a72:	fc                   	cld    
  800a73:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a75:	eb 05                	jmp    800a7c <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a77:	89 c7                	mov    %eax,%edi
  800a79:	fc                   	cld    
  800a7a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a7c:	5e                   	pop    %esi
  800a7d:	5f                   	pop    %edi
  800a7e:	5d                   	pop    %ebp
  800a7f:	c3                   	ret    

00800a80 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a83:	ff 75 10             	pushl  0x10(%ebp)
  800a86:	ff 75 0c             	pushl  0xc(%ebp)
  800a89:	ff 75 08             	pushl  0x8(%ebp)
  800a8c:	e8 87 ff ff ff       	call   800a18 <memmove>
}
  800a91:	c9                   	leave  
  800a92:	c3                   	ret    

00800a93 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a93:	55                   	push   %ebp
  800a94:	89 e5                	mov    %esp,%ebp
  800a96:	56                   	push   %esi
  800a97:	53                   	push   %ebx
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9e:	89 c6                	mov    %eax,%esi
  800aa0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aa3:	eb 1a                	jmp    800abf <memcmp+0x2c>
		if (*s1 != *s2)
  800aa5:	0f b6 08             	movzbl (%eax),%ecx
  800aa8:	0f b6 1a             	movzbl (%edx),%ebx
  800aab:	38 d9                	cmp    %bl,%cl
  800aad:	74 0a                	je     800ab9 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800aaf:	0f b6 c1             	movzbl %cl,%eax
  800ab2:	0f b6 db             	movzbl %bl,%ebx
  800ab5:	29 d8                	sub    %ebx,%eax
  800ab7:	eb 0f                	jmp    800ac8 <memcmp+0x35>
		s1++, s2++;
  800ab9:	83 c0 01             	add    $0x1,%eax
  800abc:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800abf:	39 f0                	cmp    %esi,%eax
  800ac1:	75 e2                	jne    800aa5 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ac3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac8:	5b                   	pop    %ebx
  800ac9:	5e                   	pop    %esi
  800aca:	5d                   	pop    %ebp
  800acb:	c3                   	ret    

00800acc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	53                   	push   %ebx
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800ad3:	89 c1                	mov    %eax,%ecx
  800ad5:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  800ad8:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800adc:	eb 0a                	jmp    800ae8 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ade:	0f b6 10             	movzbl (%eax),%edx
  800ae1:	39 da                	cmp    %ebx,%edx
  800ae3:	74 07                	je     800aec <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ae5:	83 c0 01             	add    $0x1,%eax
  800ae8:	39 c8                	cmp    %ecx,%eax
  800aea:	72 f2                	jb     800ade <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800aec:	5b                   	pop    %ebx
  800aed:	5d                   	pop    %ebp
  800aee:	c3                   	ret    

00800aef <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	57                   	push   %edi
  800af3:	56                   	push   %esi
  800af4:	53                   	push   %ebx
  800af5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800afb:	eb 03                	jmp    800b00 <strtol+0x11>
		s++;
  800afd:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b00:	0f b6 01             	movzbl (%ecx),%eax
  800b03:	3c 20                	cmp    $0x20,%al
  800b05:	74 f6                	je     800afd <strtol+0xe>
  800b07:	3c 09                	cmp    $0x9,%al
  800b09:	74 f2                	je     800afd <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b0b:	3c 2b                	cmp    $0x2b,%al
  800b0d:	75 0a                	jne    800b19 <strtol+0x2a>
		s++;
  800b0f:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b12:	bf 00 00 00 00       	mov    $0x0,%edi
  800b17:	eb 11                	jmp    800b2a <strtol+0x3b>
  800b19:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b1e:	3c 2d                	cmp    $0x2d,%al
  800b20:	75 08                	jne    800b2a <strtol+0x3b>
		s++, neg = 1;
  800b22:	83 c1 01             	add    $0x1,%ecx
  800b25:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b2a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b30:	75 15                	jne    800b47 <strtol+0x58>
  800b32:	80 39 30             	cmpb   $0x30,(%ecx)
  800b35:	75 10                	jne    800b47 <strtol+0x58>
  800b37:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b3b:	75 7c                	jne    800bb9 <strtol+0xca>
		s += 2, base = 16;
  800b3d:	83 c1 02             	add    $0x2,%ecx
  800b40:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b45:	eb 16                	jmp    800b5d <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800b47:	85 db                	test   %ebx,%ebx
  800b49:	75 12                	jne    800b5d <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b4b:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b50:	80 39 30             	cmpb   $0x30,(%ecx)
  800b53:	75 08                	jne    800b5d <strtol+0x6e>
		s++, base = 8;
  800b55:	83 c1 01             	add    $0x1,%ecx
  800b58:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800b5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b62:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b65:	0f b6 11             	movzbl (%ecx),%edx
  800b68:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b6b:	89 f3                	mov    %esi,%ebx
  800b6d:	80 fb 09             	cmp    $0x9,%bl
  800b70:	77 08                	ja     800b7a <strtol+0x8b>
			dig = *s - '0';
  800b72:	0f be d2             	movsbl %dl,%edx
  800b75:	83 ea 30             	sub    $0x30,%edx
  800b78:	eb 22                	jmp    800b9c <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800b7a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b7d:	89 f3                	mov    %esi,%ebx
  800b7f:	80 fb 19             	cmp    $0x19,%bl
  800b82:	77 08                	ja     800b8c <strtol+0x9d>
			dig = *s - 'a' + 10;
  800b84:	0f be d2             	movsbl %dl,%edx
  800b87:	83 ea 57             	sub    $0x57,%edx
  800b8a:	eb 10                	jmp    800b9c <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800b8c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b8f:	89 f3                	mov    %esi,%ebx
  800b91:	80 fb 19             	cmp    $0x19,%bl
  800b94:	77 16                	ja     800bac <strtol+0xbd>
			dig = *s - 'A' + 10;
  800b96:	0f be d2             	movsbl %dl,%edx
  800b99:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800b9c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b9f:	7d 0b                	jge    800bac <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800ba1:	83 c1 01             	add    $0x1,%ecx
  800ba4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ba8:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800baa:	eb b9                	jmp    800b65 <strtol+0x76>

	if (endptr)
  800bac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb0:	74 0d                	je     800bbf <strtol+0xd0>
		*endptr = (char *) s;
  800bb2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bb5:	89 0e                	mov    %ecx,(%esi)
  800bb7:	eb 06                	jmp    800bbf <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bb9:	85 db                	test   %ebx,%ebx
  800bbb:	74 98                	je     800b55 <strtol+0x66>
  800bbd:	eb 9e                	jmp    800b5d <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800bbf:	89 c2                	mov    %eax,%edx
  800bc1:	f7 da                	neg    %edx
  800bc3:	85 ff                	test   %edi,%edi
  800bc5:	0f 45 c2             	cmovne %edx,%eax
}
  800bc8:	5b                   	pop    %ebx
  800bc9:	5e                   	pop    %esi
  800bca:	5f                   	pop    %edi
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	57                   	push   %edi
  800bd1:	56                   	push   %esi
  800bd2:	53                   	push   %ebx
  800bd3:	83 ec 1c             	sub    $0x1c,%esp
  800bd6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800bd9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800bdc:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bde:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800be1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800be4:	8b 7d 10             	mov    0x10(%ebp),%edi
  800be7:	8b 75 14             	mov    0x14(%ebp),%esi
  800bea:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800bec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bf0:	74 1d                	je     800c0f <syscall+0x42>
  800bf2:	85 c0                	test   %eax,%eax
  800bf4:	7e 19                	jle    800c0f <syscall+0x42>
  800bf6:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800bf9:	83 ec 0c             	sub    $0xc,%esp
  800bfc:	50                   	push   %eax
  800bfd:	52                   	push   %edx
  800bfe:	68 1f 28 80 00       	push   $0x80281f
  800c03:	6a 23                	push   $0x23
  800c05:	68 3c 28 80 00       	push   $0x80283c
  800c0a:	e8 2b f6 ff ff       	call   80023a <_panic>

	return ret;
}
  800c0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c12:	5b                   	pop    %ebx
  800c13:	5e                   	pop    %esi
  800c14:	5f                   	pop    %edi
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    

00800c17 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800c1d:	6a 00                	push   $0x0
  800c1f:	6a 00                	push   $0x0
  800c21:	6a 00                	push   $0x0
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c29:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c33:	e8 95 ff ff ff       	call   800bcd <syscall>
}
  800c38:	83 c4 10             	add    $0x10,%esp
  800c3b:	c9                   	leave  
  800c3c:	c3                   	ret    

00800c3d <sys_cgetc>:

int
sys_cgetc(void)
{
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800c43:	6a 00                	push   $0x0
  800c45:	6a 00                	push   $0x0
  800c47:	6a 00                	push   $0x0
  800c49:	6a 00                	push   $0x0
  800c4b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c50:	ba 00 00 00 00       	mov    $0x0,%edx
  800c55:	b8 01 00 00 00       	mov    $0x1,%eax
  800c5a:	e8 6e ff ff ff       	call   800bcd <syscall>
}
  800c5f:	c9                   	leave  
  800c60:	c3                   	ret    

00800c61 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800c67:	6a 00                	push   $0x0
  800c69:	6a 00                	push   $0x0
  800c6b:	6a 00                	push   $0x0
  800c6d:	6a 00                	push   $0x0
  800c6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c72:	ba 01 00 00 00       	mov    $0x1,%edx
  800c77:	b8 03 00 00 00       	mov    $0x3,%eax
  800c7c:	e8 4c ff ff ff       	call   800bcd <syscall>
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800c89:	6a 00                	push   $0x0
  800c8b:	6a 00                	push   $0x0
  800c8d:	6a 00                	push   $0x0
  800c8f:	6a 00                	push   $0x0
  800c91:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c96:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9b:	b8 02 00 00 00       	mov    $0x2,%eax
  800ca0:	e8 28 ff ff ff       	call   800bcd <syscall>
}
  800ca5:	c9                   	leave  
  800ca6:	c3                   	ret    

00800ca7 <sys_yield>:

void
sys_yield(void)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800cad:	6a 00                	push   $0x0
  800caf:	6a 00                	push   $0x0
  800cb1:	6a 00                	push   $0x0
  800cb3:	6a 00                	push   $0x0
  800cb5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cba:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cc4:	e8 04 ff ff ff       	call   800bcd <syscall>
}
  800cc9:	83 c4 10             	add    $0x10,%esp
  800ccc:	c9                   	leave  
  800ccd:	c3                   	ret    

00800cce <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800cd4:	6a 00                	push   $0x0
  800cd6:	6a 00                	push   $0x0
  800cd8:	ff 75 10             	pushl  0x10(%ebp)
  800cdb:	ff 75 0c             	pushl  0xc(%ebp)
  800cde:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ce1:	ba 01 00 00 00       	mov    $0x1,%edx
  800ce6:	b8 04 00 00 00       	mov    $0x4,%eax
  800ceb:	e8 dd fe ff ff       	call   800bcd <syscall>
}
  800cf0:	c9                   	leave  
  800cf1:	c3                   	ret    

00800cf2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800cf8:	ff 75 18             	pushl  0x18(%ebp)
  800cfb:	ff 75 14             	pushl  0x14(%ebp)
  800cfe:	ff 75 10             	pushl  0x10(%ebp)
  800d01:	ff 75 0c             	pushl  0xc(%ebp)
  800d04:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d07:	ba 01 00 00 00       	mov    $0x1,%edx
  800d0c:	b8 05 00 00 00       	mov    $0x5,%eax
  800d11:	e8 b7 fe ff ff       	call   800bcd <syscall>
}
  800d16:	c9                   	leave  
  800d17:	c3                   	ret    

00800d18 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
  800d1b:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800d1e:	6a 00                	push   $0x0
  800d20:	6a 00                	push   $0x0
  800d22:	6a 00                	push   $0x0
  800d24:	ff 75 0c             	pushl  0xc(%ebp)
  800d27:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d2a:	ba 01 00 00 00       	mov    $0x1,%edx
  800d2f:	b8 06 00 00 00       	mov    $0x6,%eax
  800d34:	e8 94 fe ff ff       	call   800bcd <syscall>
}
  800d39:	c9                   	leave  
  800d3a:	c3                   	ret    

00800d3b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800d41:	6a 00                	push   $0x0
  800d43:	6a 00                	push   $0x0
  800d45:	6a 00                	push   $0x0
  800d47:	ff 75 0c             	pushl  0xc(%ebp)
  800d4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d4d:	ba 01 00 00 00       	mov    $0x1,%edx
  800d52:	b8 08 00 00 00       	mov    $0x8,%eax
  800d57:	e8 71 fe ff ff       	call   800bcd <syscall>
}
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800d64:	6a 00                	push   $0x0
  800d66:	6a 00                	push   $0x0
  800d68:	6a 00                	push   $0x0
  800d6a:	ff 75 0c             	pushl  0xc(%ebp)
  800d6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d70:	ba 01 00 00 00       	mov    $0x1,%edx
  800d75:	b8 09 00 00 00       	mov    $0x9,%eax
  800d7a:	e8 4e fe ff ff       	call   800bcd <syscall>
}
  800d7f:	c9                   	leave  
  800d80:	c3                   	ret    

00800d81 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800d87:	6a 00                	push   $0x0
  800d89:	6a 00                	push   $0x0
  800d8b:	6a 00                	push   $0x0
  800d8d:	ff 75 0c             	pushl  0xc(%ebp)
  800d90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d93:	ba 01 00 00 00       	mov    $0x1,%edx
  800d98:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d9d:	e8 2b fe ff ff       	call   800bcd <syscall>
}
  800da2:	c9                   	leave  
  800da3:	c3                   	ret    

00800da4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800daa:	6a 00                	push   $0x0
  800dac:	ff 75 14             	pushl  0x14(%ebp)
  800daf:	ff 75 10             	pushl  0x10(%ebp)
  800db2:	ff 75 0c             	pushl  0xc(%ebp)
  800db5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800db8:	ba 00 00 00 00       	mov    $0x0,%edx
  800dbd:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dc2:	e8 06 fe ff ff       	call   800bcd <syscall>
}
  800dc7:	c9                   	leave  
  800dc8:	c3                   	ret    

00800dc9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800dcf:	6a 00                	push   $0x0
  800dd1:	6a 00                	push   $0x0
  800dd3:	6a 00                	push   $0x0
  800dd5:	6a 00                	push   $0x0
  800dd7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dda:	ba 01 00 00 00       	mov    $0x1,%edx
  800ddf:	b8 0d 00 00 00       	mov    $0xd,%eax
  800de4:	e8 e4 fd ff ff       	call   800bcd <syscall>
}
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	53                   	push   %ebx
  800def:	83 ec 04             	sub    $0x4,%esp

	int perm_w = PTE_COW|PTE_U|PTE_P;
	int perm = PTE_U|PTE_P;

	// LAB 4: Your code here.
	void *addr = (void*) (pn*PGSIZE);
  800df2:	89 d3                	mov    %edx,%ebx
  800df4:	c1 e3 0c             	shl    $0xc,%ebx

	//Si una página tiene el bit PTE_SHARE, se comparte con el hijo con los mismos permisos.
  	if (uvpt[pn] & PTE_SHARE) {
  800df7:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800dfe:	f6 c5 04             	test   $0x4,%ch
  800e01:	74 3a                	je     800e3d <duppage+0x52>
    	if (sys_page_map(0, addr, envid,addr, uvpt[pn] & PTE_SYSCALL) < 0) {
  800e03:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e0a:	83 ec 0c             	sub    $0xc,%esp
  800e0d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800e13:	52                   	push   %edx
  800e14:	53                   	push   %ebx
  800e15:	50                   	push   %eax
  800e16:	53                   	push   %ebx
  800e17:	6a 00                	push   $0x0
  800e19:	e8 d4 fe ff ff       	call   800cf2 <sys_page_map>
  800e1e:	83 c4 20             	add    $0x20,%esp
  800e21:	85 c0                	test   %eax,%eax
  800e23:	0f 89 99 00 00 00    	jns    800ec2 <duppage+0xd7>
 	     	panic("Error en sys_page_map");
  800e29:	83 ec 04             	sub    $0x4,%esp
  800e2c:	68 4a 28 80 00       	push   $0x80284a
  800e31:	6a 50                	push   $0x50
  800e33:	68 60 28 80 00       	push   $0x802860
  800e38:	e8 fd f3 ff ff       	call   80023a <_panic>
    	} 
    	return 0;
	}

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  800e3d:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800e44:	f6 c1 02             	test   $0x2,%cl
  800e47:	75 0c                	jne    800e55 <duppage+0x6a>
  800e49:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e50:	f6 c6 08             	test   $0x8,%dh
  800e53:	74 5b                	je     800eb0 <duppage+0xc5>
		if (sys_page_map(0, addr, envid, addr, perm_w) < 0){
  800e55:	83 ec 0c             	sub    $0xc,%esp
  800e58:	68 05 08 00 00       	push   $0x805
  800e5d:	53                   	push   %ebx
  800e5e:	50                   	push   %eax
  800e5f:	53                   	push   %ebx
  800e60:	6a 00                	push   $0x0
  800e62:	e8 8b fe ff ff       	call   800cf2 <sys_page_map>
  800e67:	83 c4 20             	add    $0x20,%esp
  800e6a:	85 c0                	test   %eax,%eax
  800e6c:	79 14                	jns    800e82 <duppage+0x97>
			panic("Error mapeando pagina Padre");
  800e6e:	83 ec 04             	sub    $0x4,%esp
  800e71:	68 6b 28 80 00       	push   $0x80286b
  800e76:	6a 57                	push   $0x57
  800e78:	68 60 28 80 00       	push   $0x802860
  800e7d:	e8 b8 f3 ff ff       	call   80023a <_panic>
		}
		if (sys_page_map(0, addr, 0, addr, perm_w) < 0){
  800e82:	83 ec 0c             	sub    $0xc,%esp
  800e85:	68 05 08 00 00       	push   $0x805
  800e8a:	53                   	push   %ebx
  800e8b:	6a 00                	push   $0x0
  800e8d:	53                   	push   %ebx
  800e8e:	6a 00                	push   $0x0
  800e90:	e8 5d fe ff ff       	call   800cf2 <sys_page_map>
  800e95:	83 c4 20             	add    $0x20,%esp
  800e98:	85 c0                	test   %eax,%eax
  800e9a:	79 26                	jns    800ec2 <duppage+0xd7>
			panic("Error mapeando pagina Hijo");
  800e9c:	83 ec 04             	sub    $0x4,%esp
  800e9f:	68 87 28 80 00       	push   $0x802887
  800ea4:	6a 5a                	push   $0x5a
  800ea6:	68 60 28 80 00       	push   $0x802860
  800eab:	e8 8a f3 ff ff       	call   80023a <_panic>
		}
	} else sys_page_map(0, addr, envid, addr, perm);
  800eb0:	83 ec 0c             	sub    $0xc,%esp
  800eb3:	6a 05                	push   $0x5
  800eb5:	53                   	push   %ebx
  800eb6:	50                   	push   %eax
  800eb7:	53                   	push   %ebx
  800eb8:	6a 00                	push   $0x0
  800eba:	e8 33 fe ff ff       	call   800cf2 <sys_page_map>
  800ebf:	83 c4 20             	add    $0x20,%esp
	
	return 0;
}
  800ec2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800eca:	c9                   	leave  
  800ecb:	c3                   	ret    

00800ecc <dup_or_share>:
//FORK V0

static void
dup_or_share(envid_t dstenv, void *va, int perm){
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	57                   	push   %edi
  800ed0:	56                   	push   %esi
  800ed1:	53                   	push   %ebx
  800ed2:	83 ec 0c             	sub    $0xc,%esp
  800ed5:	89 c7                	mov    %eax,%edi
  800ed7:	89 d6                	mov    %edx,%esi
  800ed9:	89 cb                	mov    %ecx,%ebx
	int result;
	// Si no es de escritura, comparto la pagina
	if((perm &PTE_W) != PTE_W){
  800edb:	f6 c1 02             	test   $0x2,%cl
  800ede:	75 2d                	jne    800f0d <dup_or_share+0x41>
		if((result = sys_page_map(0, va, dstenv, va, perm))<0){
  800ee0:	83 ec 0c             	sub    $0xc,%esp
  800ee3:	51                   	push   %ecx
  800ee4:	52                   	push   %edx
  800ee5:	50                   	push   %eax
  800ee6:	52                   	push   %edx
  800ee7:	6a 00                	push   $0x0
  800ee9:	e8 04 fe ff ff       	call   800cf2 <sys_page_map>
  800eee:	83 c4 20             	add    $0x20,%esp
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	0f 89 a4 00 00 00    	jns    800f9d <dup_or_share+0xd1>
			panic("Error compartiendo la pagina");
  800ef9:	83 ec 04             	sub    $0x4,%esp
  800efc:	68 a2 28 80 00       	push   $0x8028a2
  800f01:	6a 68                	push   $0x68
  800f03:	68 60 28 80 00       	push   $0x802860
  800f08:	e8 2d f3 ff ff       	call   80023a <_panic>
		}
	// Si es de escritura comportamiento de duppage, en dumbfork
	}else{
		if ((result = sys_page_alloc(dstenv, va, perm)) < 0){
  800f0d:	83 ec 04             	sub    $0x4,%esp
  800f10:	51                   	push   %ecx
  800f11:	52                   	push   %edx
  800f12:	50                   	push   %eax
  800f13:	e8 b6 fd ff ff       	call   800cce <sys_page_alloc>
  800f18:	83 c4 10             	add    $0x10,%esp
  800f1b:	85 c0                	test   %eax,%eax
  800f1d:	79 14                	jns    800f33 <dup_or_share+0x67>
			panic("Error copiando la pagina");
  800f1f:	83 ec 04             	sub    $0x4,%esp
  800f22:	68 bf 28 80 00       	push   $0x8028bf
  800f27:	6a 6d                	push   $0x6d
  800f29:	68 60 28 80 00       	push   $0x802860
  800f2e:	e8 07 f3 ff ff       	call   80023a <_panic>
		}
		if ((result = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0){
  800f33:	83 ec 0c             	sub    $0xc,%esp
  800f36:	53                   	push   %ebx
  800f37:	68 00 00 40 00       	push   $0x400000
  800f3c:	6a 00                	push   $0x0
  800f3e:	56                   	push   %esi
  800f3f:	57                   	push   %edi
  800f40:	e8 ad fd ff ff       	call   800cf2 <sys_page_map>
  800f45:	83 c4 20             	add    $0x20,%esp
  800f48:	85 c0                	test   %eax,%eax
  800f4a:	79 14                	jns    800f60 <dup_or_share+0x94>
			panic("Error copiando la pagina");
  800f4c:	83 ec 04             	sub    $0x4,%esp
  800f4f:	68 bf 28 80 00       	push   $0x8028bf
  800f54:	6a 70                	push   $0x70
  800f56:	68 60 28 80 00       	push   $0x802860
  800f5b:	e8 da f2 ff ff       	call   80023a <_panic>
		}
		memmove(UTEMP, va, PGSIZE);
  800f60:	83 ec 04             	sub    $0x4,%esp
  800f63:	68 00 10 00 00       	push   $0x1000
  800f68:	56                   	push   %esi
  800f69:	68 00 00 40 00       	push   $0x400000
  800f6e:	e8 a5 fa ff ff       	call   800a18 <memmove>
		if ((result = sys_page_unmap(0, UTEMP)) < 0){
  800f73:	83 c4 08             	add    $0x8,%esp
  800f76:	68 00 00 40 00       	push   $0x400000
  800f7b:	6a 00                	push   $0x0
  800f7d:	e8 96 fd ff ff       	call   800d18 <sys_page_unmap>
  800f82:	83 c4 10             	add    $0x10,%esp
  800f85:	85 c0                	test   %eax,%eax
  800f87:	79 14                	jns    800f9d <dup_or_share+0xd1>
			panic("Error copiando la pagina");
  800f89:	83 ec 04             	sub    $0x4,%esp
  800f8c:	68 bf 28 80 00       	push   $0x8028bf
  800f91:	6a 74                	push   $0x74
  800f93:	68 60 28 80 00       	push   $0x802860
  800f98:	e8 9d f2 ff ff       	call   80023a <_panic>
		}
	}	
}
  800f9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa0:	5b                   	pop    %ebx
  800fa1:	5e                   	pop    %esi
  800fa2:	5f                   	pop    %edi
  800fa3:	5d                   	pop    %ebp
  800fa4:	c3                   	ret    

00800fa5 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	53                   	push   %ebx
  800fa9:	83 ec 04             	sub    $0x4,%esp
  800fac:	8b 55 08             	mov    0x8(%ebp),%edx
	void *va = (void *) utf->utf_fault_va;
  800faf:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800fb1:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  800fb5:	74 2e                	je     800fe5 <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
  800fb7:	89 c2                	mov    %eax,%edx
  800fb9:	c1 ea 16             	shr    $0x16,%edx
  800fbc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800fc3:	f6 c2 01             	test   $0x1,%dl
  800fc6:	74 1d                	je     800fe5 <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
  800fc8:	89 c2                	mov    %eax,%edx
  800fca:	c1 ea 0c             	shr    $0xc,%edx
  800fcd:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
		(uvpd[PDX(va)] & PTE_P) && 
  800fd4:	f6 c1 01             	test   $0x1,%cl
  800fd7:	74 0c                	je     800fe5 <pgfault+0x40>
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
  800fd9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800fe0:	f6 c6 08             	test   $0x8,%dh
  800fe3:	75 14                	jne    800ff9 <pgfault+0x54>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
		panic("No es copy-on-write");
  800fe5:	83 ec 04             	sub    $0x4,%esp
  800fe8:	68 d8 28 80 00       	push   $0x8028d8
  800fed:	6a 21                	push   $0x21
  800fef:	68 60 28 80 00       	push   $0x802860
  800ff4:	e8 41 f2 ff ff       	call   80023a <_panic>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	va = ROUNDDOWN(va, PGSIZE);
  800ff9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ffe:	89 c3                	mov    %eax,%ebx
	if (sys_page_alloc(0, PFTEMP, perm) < 0){
  801000:	83 ec 04             	sub    $0x4,%esp
  801003:	6a 07                	push   $0x7
  801005:	68 00 f0 7f 00       	push   $0x7ff000
  80100a:	6a 00                	push   $0x0
  80100c:	e8 bd fc ff ff       	call   800cce <sys_page_alloc>
  801011:	83 c4 10             	add    $0x10,%esp
  801014:	85 c0                	test   %eax,%eax
  801016:	79 14                	jns    80102c <pgfault+0x87>
		panic("Error sys_page_alloc");
  801018:	83 ec 04             	sub    $0x4,%esp
  80101b:	68 ec 28 80 00       	push   $0x8028ec
  801020:	6a 2a                	push   $0x2a
  801022:	68 60 28 80 00       	push   $0x802860
  801027:	e8 0e f2 ff ff       	call   80023a <_panic>
	}
	memcpy(PFTEMP, va, PGSIZE);
  80102c:	83 ec 04             	sub    $0x4,%esp
  80102f:	68 00 10 00 00       	push   $0x1000
  801034:	53                   	push   %ebx
  801035:	68 00 f0 7f 00       	push   $0x7ff000
  80103a:	e8 41 fa ff ff       	call   800a80 <memcpy>
	if (sys_page_map(0, PFTEMP, 0, va, perm) < 0){
  80103f:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801046:	53                   	push   %ebx
  801047:	6a 00                	push   $0x0
  801049:	68 00 f0 7f 00       	push   $0x7ff000
  80104e:	6a 00                	push   $0x0
  801050:	e8 9d fc ff ff       	call   800cf2 <sys_page_map>
  801055:	83 c4 20             	add    $0x20,%esp
  801058:	85 c0                	test   %eax,%eax
  80105a:	79 14                	jns    801070 <pgfault+0xcb>
		panic("Error sys_page_map");
  80105c:	83 ec 04             	sub    $0x4,%esp
  80105f:	68 01 29 80 00       	push   $0x802901
  801064:	6a 2e                	push   $0x2e
  801066:	68 60 28 80 00       	push   $0x802860
  80106b:	e8 ca f1 ff ff       	call   80023a <_panic>
	}
	if (sys_page_unmap(0, PFTEMP) < 0){
  801070:	83 ec 08             	sub    $0x8,%esp
  801073:	68 00 f0 7f 00       	push   $0x7ff000
  801078:	6a 00                	push   $0x0
  80107a:	e8 99 fc ff ff       	call   800d18 <sys_page_unmap>
  80107f:	83 c4 10             	add    $0x10,%esp
  801082:	85 c0                	test   %eax,%eax
  801084:	79 14                	jns    80109a <pgfault+0xf5>
		panic("Error sys_page_unmap");
  801086:	83 ec 04             	sub    $0x4,%esp
  801089:	68 14 29 80 00       	push   $0x802914
  80108e:	6a 31                	push   $0x31
  801090:	68 60 28 80 00       	push   $0x802860
  801095:	e8 a0 f1 ff ff       	call   80023a <_panic>
	}
	return;

}
  80109a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80109d:	c9                   	leave  
  80109e:	c3                   	ret    

0080109f <fork_v0>:
		}
	}	
}

envid_t
fork_v0(void){
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	57                   	push   %edi
  8010a3:	56                   	push   %esi
  8010a4:	53                   	push   %ebx
  8010a5:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010a8:	b8 07 00 00 00       	mov    $0x7,%eax
  8010ad:	cd 30                	int    $0x30
  8010af:	89 c6                	mov    %eax,%esi
	envid_t envid;
	uint8_t *va;
	int result;	

	envid = sys_exofork();
	if (envid < 0)
  8010b1:	85 c0                	test   %eax,%eax
  8010b3:	79 15                	jns    8010ca <fork_v0+0x2b>
		panic("sys_exofork: %e", envid);
  8010b5:	50                   	push   %eax
  8010b6:	68 29 29 80 00       	push   $0x802929
  8010bb:	68 81 00 00 00       	push   $0x81
  8010c0:	68 60 28 80 00       	push   $0x802860
  8010c5:	e8 70 f1 ff ff       	call   80023a <_panic>
  8010ca:	89 c7                	mov    %eax,%edi
  8010cc:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {		
  8010d1:	85 c0                	test   %eax,%eax
  8010d3:	75 1e                	jne    8010f3 <fork_v0+0x54>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010d5:	e8 a9 fb ff ff       	call   800c83 <sys_getenvid>
  8010da:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010df:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010e2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010e7:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8010ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f1:	eb 7a                	jmp    80116d <fork_v0+0xce>
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  8010f3:	89 d8                	mov    %ebx,%eax
  8010f5:	c1 e8 16             	shr    $0x16,%eax
  8010f8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010ff:	a8 01                	test   $0x1,%al
  801101:	74 33                	je     801136 <fork_v0+0x97>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  801103:	89 d8                	mov    %ebx,%eax
  801105:	c1 e8 0c             	shr    $0xc,%eax
  801108:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80110f:	f6 c2 01             	test   $0x1,%dl
  801112:	74 22                	je     801136 <fork_v0+0x97>
  801114:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80111b:	f6 c2 04             	test   $0x4,%dl
  80111e:	74 16                	je     801136 <fork_v0+0x97>
				pte_t pte =uvpt[PGNUM(va)];
  801120:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
  801127:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80112d:	89 da                	mov    %ebx,%edx
  80112f:	89 f8                	mov    %edi,%eax
  801131:	e8 96 fd ff ff       	call   800ecc <dup_or_share>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
  801136:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80113c:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801142:	75 af                	jne    8010f3 <fork_v0+0x54>
				pte_t pte =uvpt[PGNUM(va)];
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
			}
		}
	}	
	if ((result = sys_env_set_status(envid, ENV_RUNNABLE)) < 0){
  801144:	83 ec 08             	sub    $0x8,%esp
  801147:	6a 02                	push   $0x2
  801149:	56                   	push   %esi
  80114a:	e8 ec fb ff ff       	call   800d3b <sys_env_set_status>
  80114f:	83 c4 10             	add    $0x10,%esp
  801152:	85 c0                	test   %eax,%eax
  801154:	79 15                	jns    80116b <fork_v0+0xcc>

		panic("sys_env_set_status: %e", result);
  801156:	50                   	push   %eax
  801157:	68 39 29 80 00       	push   $0x802939
  80115c:	68 90 00 00 00       	push   $0x90
  801161:	68 60 28 80 00       	push   $0x802860
  801166:	e8 cf f0 ff ff       	call   80023a <_panic>
	}
	return envid;
  80116b:	89 f0                	mov    %esi,%eax
}
  80116d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801170:	5b                   	pop    %ebx
  801171:	5e                   	pop    %esi
  801172:	5f                   	pop    %edi
  801173:	5d                   	pop    %ebp
  801174:	c3                   	ret    

00801175 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
  801178:	57                   	push   %edi
  801179:	56                   	push   %esi
  80117a:	53                   	push   %ebx
  80117b:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  80117e:	68 a5 0f 80 00       	push   $0x800fa5
  801183:	e8 27 0e 00 00       	call   801faf <set_pgfault_handler>
  801188:	b8 07 00 00 00       	mov    $0x7,%eax
  80118d:	cd 30                	int    $0x30
  80118f:	89 c6                	mov    %eax,%esi

	envid_t envid;
	uint32_t va;
	envid = sys_exofork();
	if (envid < 0){
  801191:	83 c4 10             	add    $0x10,%esp
  801194:	85 c0                	test   %eax,%eax
  801196:	79 15                	jns    8011ad <fork+0x38>
		panic("sys_exofork: %e", envid);
  801198:	50                   	push   %eax
  801199:	68 29 29 80 00       	push   $0x802929
  80119e:	68 b1 00 00 00       	push   $0xb1
  8011a3:	68 60 28 80 00       	push   $0x802860
  8011a8:	e8 8d f0 ff ff       	call   80023a <_panic>
  8011ad:	89 c7                	mov    %eax,%edi
  8011af:	bb 00 00 00 00       	mov    $0x0,%ebx
	}
	if (envid == 0) {		
  8011b4:	85 c0                	test   %eax,%eax
  8011b6:	75 21                	jne    8011d9 <fork+0x64>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011b8:	e8 c6 fa ff ff       	call   800c83 <sys_getenvid>
  8011bd:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011c2:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011c5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011ca:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8011cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d4:	e9 a7 00 00 00       	jmp    801280 <fork+0x10b>
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  8011d9:	89 d8                	mov    %ebx,%eax
  8011db:	c1 e8 16             	shr    $0x16,%eax
  8011de:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011e5:	a8 01                	test   $0x1,%al
  8011e7:	74 22                	je     80120b <fork+0x96>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  8011e9:	89 da                	mov    %ebx,%edx
  8011eb:	c1 ea 0c             	shr    $0xc,%edx
  8011ee:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8011f5:	a8 01                	test   $0x1,%al
  8011f7:	74 12                	je     80120b <fork+0x96>
  8011f9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801200:	a8 04                	test   $0x4,%al
  801202:	74 07                	je     80120b <fork+0x96>
				duppage(envid, PGNUM(va));			
  801204:	89 f8                	mov    %edi,%eax
  801206:	e8 e0 fb ff ff       	call   800deb <duppage>
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
  80120b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801211:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801217:	75 c0                	jne    8011d9 <fork+0x64>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
				duppage(envid, PGNUM(va));			
			}
		}
	}
	if (sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P) < 0){
  801219:	83 ec 04             	sub    $0x4,%esp
  80121c:	6a 07                	push   $0x7
  80121e:	68 00 f0 bf ee       	push   $0xeebff000
  801223:	56                   	push   %esi
  801224:	e8 a5 fa ff ff       	call   800cce <sys_page_alloc>
  801229:	83 c4 10             	add    $0x10,%esp
  80122c:	85 c0                	test   %eax,%eax
  80122e:	79 17                	jns    801247 <fork+0xd2>
		panic("Se escribio en la pagina de excepciones");
  801230:	83 ec 04             	sub    $0x4,%esp
  801233:	68 68 29 80 00       	push   $0x802968
  801238:	68 c0 00 00 00       	push   $0xc0
  80123d:	68 60 28 80 00       	push   $0x802860
  801242:	e8 f3 ef ff ff       	call   80023a <_panic>
	}	
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801247:	83 ec 08             	sub    $0x8,%esp
  80124a:	68 1e 20 80 00       	push   $0x80201e
  80124f:	56                   	push   %esi
  801250:	e8 2c fb ff ff       	call   800d81 <sys_env_set_pgfault_upcall>

	if (sys_env_set_status(envid, ENV_RUNNABLE) < 0)
  801255:	83 c4 08             	add    $0x8,%esp
  801258:	6a 02                	push   $0x2
  80125a:	56                   	push   %esi
  80125b:	e8 db fa ff ff       	call   800d3b <sys_env_set_status>
  801260:	83 c4 10             	add    $0x10,%esp
  801263:	85 c0                	test   %eax,%eax
  801265:	79 17                	jns    80127e <fork+0x109>
		panic("Status incorrecto de enviroment");
  801267:	83 ec 04             	sub    $0x4,%esp
  80126a:	68 90 29 80 00       	push   $0x802990
  80126f:	68 c5 00 00 00       	push   $0xc5
  801274:	68 60 28 80 00       	push   $0x802860
  801279:	e8 bc ef ff ff       	call   80023a <_panic>

	return envid;
  80127e:	89 f0                	mov    %esi,%eax
	
}
  801280:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801283:	5b                   	pop    %ebx
  801284:	5e                   	pop    %esi
  801285:	5f                   	pop    %edi
  801286:	5d                   	pop    %ebp
  801287:	c3                   	ret    

00801288 <sfork>:


// Challenge!
int
sfork(void)
{
  801288:	55                   	push   %ebp
  801289:	89 e5                	mov    %esp,%ebp
  80128b:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80128e:	68 50 29 80 00       	push   $0x802950
  801293:	68 d1 00 00 00       	push   $0xd1
  801298:	68 60 28 80 00       	push   $0x802860
  80129d:	e8 98 ef ff ff       	call   80023a <_panic>

008012a2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012a2:	55                   	push   %ebp
  8012a3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	05 00 00 00 30       	add    $0x30000000,%eax
  8012ad:	c1 e8 0c             	shr    $0xc,%eax
}
  8012b0:	5d                   	pop    %ebp
  8012b1:	c3                   	ret    

008012b2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  8012b5:	ff 75 08             	pushl  0x8(%ebp)
  8012b8:	e8 e5 ff ff ff       	call   8012a2 <fd2num>
  8012bd:	83 c4 04             	add    $0x4,%esp
  8012c0:	c1 e0 0c             	shl    $0xc,%eax
  8012c3:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012c8:	c9                   	leave  
  8012c9:	c3                   	ret    

008012ca <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012d5:	89 c2                	mov    %eax,%edx
  8012d7:	c1 ea 16             	shr    $0x16,%edx
  8012da:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012e1:	f6 c2 01             	test   $0x1,%dl
  8012e4:	74 11                	je     8012f7 <fd_alloc+0x2d>
  8012e6:	89 c2                	mov    %eax,%edx
  8012e8:	c1 ea 0c             	shr    $0xc,%edx
  8012eb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012f2:	f6 c2 01             	test   $0x1,%dl
  8012f5:	75 09                	jne    801300 <fd_alloc+0x36>
			*fd_store = fd;
  8012f7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fe:	eb 17                	jmp    801317 <fd_alloc+0x4d>
  801300:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801305:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80130a:	75 c9                	jne    8012d5 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80130c:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801312:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801317:	5d                   	pop    %ebp
  801318:	c3                   	ret    

00801319 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80131f:	83 f8 1f             	cmp    $0x1f,%eax
  801322:	77 36                	ja     80135a <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801324:	c1 e0 0c             	shl    $0xc,%eax
  801327:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80132c:	89 c2                	mov    %eax,%edx
  80132e:	c1 ea 16             	shr    $0x16,%edx
  801331:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801338:	f6 c2 01             	test   $0x1,%dl
  80133b:	74 24                	je     801361 <fd_lookup+0x48>
  80133d:	89 c2                	mov    %eax,%edx
  80133f:	c1 ea 0c             	shr    $0xc,%edx
  801342:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801349:	f6 c2 01             	test   $0x1,%dl
  80134c:	74 1a                	je     801368 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80134e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801351:	89 02                	mov    %eax,(%edx)
	return 0;
  801353:	b8 00 00 00 00       	mov    $0x0,%eax
  801358:	eb 13                	jmp    80136d <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80135a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80135f:	eb 0c                	jmp    80136d <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801361:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801366:	eb 05                	jmp    80136d <fd_lookup+0x54>
  801368:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80136d:	5d                   	pop    %ebp
  80136e:	c3                   	ret    

0080136f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
  801372:	83 ec 08             	sub    $0x8,%esp
  801375:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801378:	ba 2c 2a 80 00       	mov    $0x802a2c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80137d:	eb 13                	jmp    801392 <dev_lookup+0x23>
  80137f:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  801382:	39 08                	cmp    %ecx,(%eax)
  801384:	75 0c                	jne    801392 <dev_lookup+0x23>
			*dev = devtab[i];
  801386:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801389:	89 01                	mov    %eax,(%ecx)
			return 0;
  80138b:	b8 00 00 00 00       	mov    $0x0,%eax
  801390:	eb 2e                	jmp    8013c0 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801392:	8b 02                	mov    (%edx),%eax
  801394:	85 c0                	test   %eax,%eax
  801396:	75 e7                	jne    80137f <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801398:	a1 04 40 80 00       	mov    0x804004,%eax
  80139d:	8b 40 48             	mov    0x48(%eax),%eax
  8013a0:	83 ec 04             	sub    $0x4,%esp
  8013a3:	51                   	push   %ecx
  8013a4:	50                   	push   %eax
  8013a5:	68 b0 29 80 00       	push   $0x8029b0
  8013aa:	e8 64 ef ff ff       	call   800313 <cprintf>
	*dev = 0;
  8013af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013b8:	83 c4 10             	add    $0x10,%esp
  8013bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013c0:	c9                   	leave  
  8013c1:	c3                   	ret    

008013c2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
  8013c5:	56                   	push   %esi
  8013c6:	53                   	push   %ebx
  8013c7:	83 ec 10             	sub    $0x10,%esp
  8013ca:	8b 75 08             	mov    0x8(%ebp),%esi
  8013cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013d0:	56                   	push   %esi
  8013d1:	e8 cc fe ff ff       	call   8012a2 <fd2num>
  8013d6:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8013d9:	89 14 24             	mov    %edx,(%esp)
  8013dc:	50                   	push   %eax
  8013dd:	e8 37 ff ff ff       	call   801319 <fd_lookup>
  8013e2:	83 c4 08             	add    $0x8,%esp
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	78 05                	js     8013ee <fd_close+0x2c>
	    || fd != fd2)
  8013e9:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8013ec:	74 0c                	je     8013fa <fd_close+0x38>
		return (must_exist ? r : 0);
  8013ee:	84 db                	test   %bl,%bl
  8013f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f5:	0f 44 c2             	cmove  %edx,%eax
  8013f8:	eb 41                	jmp    80143b <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013fa:	83 ec 08             	sub    $0x8,%esp
  8013fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801400:	50                   	push   %eax
  801401:	ff 36                	pushl  (%esi)
  801403:	e8 67 ff ff ff       	call   80136f <dev_lookup>
  801408:	89 c3                	mov    %eax,%ebx
  80140a:	83 c4 10             	add    $0x10,%esp
  80140d:	85 c0                	test   %eax,%eax
  80140f:	78 1a                	js     80142b <fd_close+0x69>
		if (dev->dev_close)
  801411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801414:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801417:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80141c:	85 c0                	test   %eax,%eax
  80141e:	74 0b                	je     80142b <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  801420:	83 ec 0c             	sub    $0xc,%esp
  801423:	56                   	push   %esi
  801424:	ff d0                	call   *%eax
  801426:	89 c3                	mov    %eax,%ebx
  801428:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80142b:	83 ec 08             	sub    $0x8,%esp
  80142e:	56                   	push   %esi
  80142f:	6a 00                	push   $0x0
  801431:	e8 e2 f8 ff ff       	call   800d18 <sys_page_unmap>
	return r;
  801436:	83 c4 10             	add    $0x10,%esp
  801439:	89 d8                	mov    %ebx,%eax
}
  80143b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80143e:	5b                   	pop    %ebx
  80143f:	5e                   	pop    %esi
  801440:	5d                   	pop    %ebp
  801441:	c3                   	ret    

00801442 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801442:	55                   	push   %ebp
  801443:	89 e5                	mov    %esp,%ebp
  801445:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801448:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80144b:	50                   	push   %eax
  80144c:	ff 75 08             	pushl  0x8(%ebp)
  80144f:	e8 c5 fe ff ff       	call   801319 <fd_lookup>
  801454:	83 c4 08             	add    $0x8,%esp
  801457:	85 c0                	test   %eax,%eax
  801459:	78 10                	js     80146b <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80145b:	83 ec 08             	sub    $0x8,%esp
  80145e:	6a 01                	push   $0x1
  801460:	ff 75 f4             	pushl  -0xc(%ebp)
  801463:	e8 5a ff ff ff       	call   8013c2 <fd_close>
  801468:	83 c4 10             	add    $0x10,%esp
}
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    

0080146d <close_all>:

void
close_all(void)
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
  801470:	53                   	push   %ebx
  801471:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801474:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801479:	83 ec 0c             	sub    $0xc,%esp
  80147c:	53                   	push   %ebx
  80147d:	e8 c0 ff ff ff       	call   801442 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801482:	83 c3 01             	add    $0x1,%ebx
  801485:	83 c4 10             	add    $0x10,%esp
  801488:	83 fb 20             	cmp    $0x20,%ebx
  80148b:	75 ec                	jne    801479 <close_all+0xc>
		close(i);
}
  80148d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
  801495:	57                   	push   %edi
  801496:	56                   	push   %esi
  801497:	53                   	push   %ebx
  801498:	83 ec 2c             	sub    $0x2c,%esp
  80149b:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80149e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014a1:	50                   	push   %eax
  8014a2:	ff 75 08             	pushl  0x8(%ebp)
  8014a5:	e8 6f fe ff ff       	call   801319 <fd_lookup>
  8014aa:	83 c4 08             	add    $0x8,%esp
  8014ad:	85 c0                	test   %eax,%eax
  8014af:	0f 88 c1 00 00 00    	js     801576 <dup+0xe4>
		return r;
	close(newfdnum);
  8014b5:	83 ec 0c             	sub    $0xc,%esp
  8014b8:	56                   	push   %esi
  8014b9:	e8 84 ff ff ff       	call   801442 <close>

	newfd = INDEX2FD(newfdnum);
  8014be:	89 f3                	mov    %esi,%ebx
  8014c0:	c1 e3 0c             	shl    $0xc,%ebx
  8014c3:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8014c9:	83 c4 04             	add    $0x4,%esp
  8014cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014cf:	e8 de fd ff ff       	call   8012b2 <fd2data>
  8014d4:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  8014d6:	89 1c 24             	mov    %ebx,(%esp)
  8014d9:	e8 d4 fd ff ff       	call   8012b2 <fd2data>
  8014de:	83 c4 10             	add    $0x10,%esp
  8014e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014e4:	89 f8                	mov    %edi,%eax
  8014e6:	c1 e8 16             	shr    $0x16,%eax
  8014e9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014f0:	a8 01                	test   $0x1,%al
  8014f2:	74 37                	je     80152b <dup+0x99>
  8014f4:	89 f8                	mov    %edi,%eax
  8014f6:	c1 e8 0c             	shr    $0xc,%eax
  8014f9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801500:	f6 c2 01             	test   $0x1,%dl
  801503:	74 26                	je     80152b <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801505:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80150c:	83 ec 0c             	sub    $0xc,%esp
  80150f:	25 07 0e 00 00       	and    $0xe07,%eax
  801514:	50                   	push   %eax
  801515:	ff 75 d4             	pushl  -0x2c(%ebp)
  801518:	6a 00                	push   $0x0
  80151a:	57                   	push   %edi
  80151b:	6a 00                	push   $0x0
  80151d:	e8 d0 f7 ff ff       	call   800cf2 <sys_page_map>
  801522:	89 c7                	mov    %eax,%edi
  801524:	83 c4 20             	add    $0x20,%esp
  801527:	85 c0                	test   %eax,%eax
  801529:	78 2e                	js     801559 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80152b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80152e:	89 d0                	mov    %edx,%eax
  801530:	c1 e8 0c             	shr    $0xc,%eax
  801533:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80153a:	83 ec 0c             	sub    $0xc,%esp
  80153d:	25 07 0e 00 00       	and    $0xe07,%eax
  801542:	50                   	push   %eax
  801543:	53                   	push   %ebx
  801544:	6a 00                	push   $0x0
  801546:	52                   	push   %edx
  801547:	6a 00                	push   $0x0
  801549:	e8 a4 f7 ff ff       	call   800cf2 <sys_page_map>
  80154e:	89 c7                	mov    %eax,%edi
  801550:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  801553:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801555:	85 ff                	test   %edi,%edi
  801557:	79 1d                	jns    801576 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801559:	83 ec 08             	sub    $0x8,%esp
  80155c:	53                   	push   %ebx
  80155d:	6a 00                	push   $0x0
  80155f:	e8 b4 f7 ff ff       	call   800d18 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801564:	83 c4 08             	add    $0x8,%esp
  801567:	ff 75 d4             	pushl  -0x2c(%ebp)
  80156a:	6a 00                	push   $0x0
  80156c:	e8 a7 f7 ff ff       	call   800d18 <sys_page_unmap>
	return r;
  801571:	83 c4 10             	add    $0x10,%esp
  801574:	89 f8                	mov    %edi,%eax
}
  801576:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801579:	5b                   	pop    %ebx
  80157a:	5e                   	pop    %esi
  80157b:	5f                   	pop    %edi
  80157c:	5d                   	pop    %ebp
  80157d:	c3                   	ret    

0080157e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	53                   	push   %ebx
  801582:	83 ec 14             	sub    $0x14,%esp
  801585:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801588:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80158b:	50                   	push   %eax
  80158c:	53                   	push   %ebx
  80158d:	e8 87 fd ff ff       	call   801319 <fd_lookup>
  801592:	83 c4 08             	add    $0x8,%esp
  801595:	89 c2                	mov    %eax,%edx
  801597:	85 c0                	test   %eax,%eax
  801599:	78 6d                	js     801608 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80159b:	83 ec 08             	sub    $0x8,%esp
  80159e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a1:	50                   	push   %eax
  8015a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a5:	ff 30                	pushl  (%eax)
  8015a7:	e8 c3 fd ff ff       	call   80136f <dev_lookup>
  8015ac:	83 c4 10             	add    $0x10,%esp
  8015af:	85 c0                	test   %eax,%eax
  8015b1:	78 4c                	js     8015ff <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015b6:	8b 42 08             	mov    0x8(%edx),%eax
  8015b9:	83 e0 03             	and    $0x3,%eax
  8015bc:	83 f8 01             	cmp    $0x1,%eax
  8015bf:	75 21                	jne    8015e2 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015c1:	a1 04 40 80 00       	mov    0x804004,%eax
  8015c6:	8b 40 48             	mov    0x48(%eax),%eax
  8015c9:	83 ec 04             	sub    $0x4,%esp
  8015cc:	53                   	push   %ebx
  8015cd:	50                   	push   %eax
  8015ce:	68 f1 29 80 00       	push   $0x8029f1
  8015d3:	e8 3b ed ff ff       	call   800313 <cprintf>
		return -E_INVAL;
  8015d8:	83 c4 10             	add    $0x10,%esp
  8015db:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8015e0:	eb 26                	jmp    801608 <read+0x8a>
	}
	if (!dev->dev_read)
  8015e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e5:	8b 40 08             	mov    0x8(%eax),%eax
  8015e8:	85 c0                	test   %eax,%eax
  8015ea:	74 17                	je     801603 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015ec:	83 ec 04             	sub    $0x4,%esp
  8015ef:	ff 75 10             	pushl  0x10(%ebp)
  8015f2:	ff 75 0c             	pushl  0xc(%ebp)
  8015f5:	52                   	push   %edx
  8015f6:	ff d0                	call   *%eax
  8015f8:	89 c2                	mov    %eax,%edx
  8015fa:	83 c4 10             	add    $0x10,%esp
  8015fd:	eb 09                	jmp    801608 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ff:	89 c2                	mov    %eax,%edx
  801601:	eb 05                	jmp    801608 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801603:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  801608:	89 d0                	mov    %edx,%eax
  80160a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80160d:	c9                   	leave  
  80160e:	c3                   	ret    

0080160f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
  801612:	57                   	push   %edi
  801613:	56                   	push   %esi
  801614:	53                   	push   %ebx
  801615:	83 ec 0c             	sub    $0xc,%esp
  801618:	8b 7d 08             	mov    0x8(%ebp),%edi
  80161b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80161e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801623:	eb 21                	jmp    801646 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801625:	83 ec 04             	sub    $0x4,%esp
  801628:	89 f0                	mov    %esi,%eax
  80162a:	29 d8                	sub    %ebx,%eax
  80162c:	50                   	push   %eax
  80162d:	89 d8                	mov    %ebx,%eax
  80162f:	03 45 0c             	add    0xc(%ebp),%eax
  801632:	50                   	push   %eax
  801633:	57                   	push   %edi
  801634:	e8 45 ff ff ff       	call   80157e <read>
		if (m < 0)
  801639:	83 c4 10             	add    $0x10,%esp
  80163c:	85 c0                	test   %eax,%eax
  80163e:	78 10                	js     801650 <readn+0x41>
			return m;
		if (m == 0)
  801640:	85 c0                	test   %eax,%eax
  801642:	74 0a                	je     80164e <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801644:	01 c3                	add    %eax,%ebx
  801646:	39 f3                	cmp    %esi,%ebx
  801648:	72 db                	jb     801625 <readn+0x16>
  80164a:	89 d8                	mov    %ebx,%eax
  80164c:	eb 02                	jmp    801650 <readn+0x41>
  80164e:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801650:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801653:	5b                   	pop    %ebx
  801654:	5e                   	pop    %esi
  801655:	5f                   	pop    %edi
  801656:	5d                   	pop    %ebp
  801657:	c3                   	ret    

00801658 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	53                   	push   %ebx
  80165c:	83 ec 14             	sub    $0x14,%esp
  80165f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801662:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801665:	50                   	push   %eax
  801666:	53                   	push   %ebx
  801667:	e8 ad fc ff ff       	call   801319 <fd_lookup>
  80166c:	83 c4 08             	add    $0x8,%esp
  80166f:	89 c2                	mov    %eax,%edx
  801671:	85 c0                	test   %eax,%eax
  801673:	78 68                	js     8016dd <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801675:	83 ec 08             	sub    $0x8,%esp
  801678:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167b:	50                   	push   %eax
  80167c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167f:	ff 30                	pushl  (%eax)
  801681:	e8 e9 fc ff ff       	call   80136f <dev_lookup>
  801686:	83 c4 10             	add    $0x10,%esp
  801689:	85 c0                	test   %eax,%eax
  80168b:	78 47                	js     8016d4 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80168d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801690:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801694:	75 21                	jne    8016b7 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801696:	a1 04 40 80 00       	mov    0x804004,%eax
  80169b:	8b 40 48             	mov    0x48(%eax),%eax
  80169e:	83 ec 04             	sub    $0x4,%esp
  8016a1:	53                   	push   %ebx
  8016a2:	50                   	push   %eax
  8016a3:	68 0d 2a 80 00       	push   $0x802a0d
  8016a8:	e8 66 ec ff ff       	call   800313 <cprintf>
		return -E_INVAL;
  8016ad:	83 c4 10             	add    $0x10,%esp
  8016b0:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8016b5:	eb 26                	jmp    8016dd <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ba:	8b 52 0c             	mov    0xc(%edx),%edx
  8016bd:	85 d2                	test   %edx,%edx
  8016bf:	74 17                	je     8016d8 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016c1:	83 ec 04             	sub    $0x4,%esp
  8016c4:	ff 75 10             	pushl  0x10(%ebp)
  8016c7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ca:	50                   	push   %eax
  8016cb:	ff d2                	call   *%edx
  8016cd:	89 c2                	mov    %eax,%edx
  8016cf:	83 c4 10             	add    $0x10,%esp
  8016d2:	eb 09                	jmp    8016dd <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016d4:	89 c2                	mov    %eax,%edx
  8016d6:	eb 05                	jmp    8016dd <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8016d8:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  8016dd:	89 d0                	mov    %edx,%eax
  8016df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016ea:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8016ed:	50                   	push   %eax
  8016ee:	ff 75 08             	pushl  0x8(%ebp)
  8016f1:	e8 23 fc ff ff       	call   801319 <fd_lookup>
  8016f6:	83 c4 08             	add    $0x8,%esp
  8016f9:	85 c0                	test   %eax,%eax
  8016fb:	78 0e                	js     80170b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8016fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801700:	8b 55 0c             	mov    0xc(%ebp),%edx
  801703:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801706:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	53                   	push   %ebx
  801711:	83 ec 14             	sub    $0x14,%esp
  801714:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801717:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80171a:	50                   	push   %eax
  80171b:	53                   	push   %ebx
  80171c:	e8 f8 fb ff ff       	call   801319 <fd_lookup>
  801721:	83 c4 08             	add    $0x8,%esp
  801724:	89 c2                	mov    %eax,%edx
  801726:	85 c0                	test   %eax,%eax
  801728:	78 65                	js     80178f <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80172a:	83 ec 08             	sub    $0x8,%esp
  80172d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801730:	50                   	push   %eax
  801731:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801734:	ff 30                	pushl  (%eax)
  801736:	e8 34 fc ff ff       	call   80136f <dev_lookup>
  80173b:	83 c4 10             	add    $0x10,%esp
  80173e:	85 c0                	test   %eax,%eax
  801740:	78 44                	js     801786 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801742:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801745:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801749:	75 21                	jne    80176c <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80174b:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801750:	8b 40 48             	mov    0x48(%eax),%eax
  801753:	83 ec 04             	sub    $0x4,%esp
  801756:	53                   	push   %ebx
  801757:	50                   	push   %eax
  801758:	68 d0 29 80 00       	push   $0x8029d0
  80175d:	e8 b1 eb ff ff       	call   800313 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801762:	83 c4 10             	add    $0x10,%esp
  801765:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80176a:	eb 23                	jmp    80178f <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  80176c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80176f:	8b 52 18             	mov    0x18(%edx),%edx
  801772:	85 d2                	test   %edx,%edx
  801774:	74 14                	je     80178a <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801776:	83 ec 08             	sub    $0x8,%esp
  801779:	ff 75 0c             	pushl  0xc(%ebp)
  80177c:	50                   	push   %eax
  80177d:	ff d2                	call   *%edx
  80177f:	89 c2                	mov    %eax,%edx
  801781:	83 c4 10             	add    $0x10,%esp
  801784:	eb 09                	jmp    80178f <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801786:	89 c2                	mov    %eax,%edx
  801788:	eb 05                	jmp    80178f <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80178a:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  80178f:	89 d0                	mov    %edx,%eax
  801791:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	53                   	push   %ebx
  80179a:	83 ec 14             	sub    $0x14,%esp
  80179d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017a3:	50                   	push   %eax
  8017a4:	ff 75 08             	pushl  0x8(%ebp)
  8017a7:	e8 6d fb ff ff       	call   801319 <fd_lookup>
  8017ac:	83 c4 08             	add    $0x8,%esp
  8017af:	89 c2                	mov    %eax,%edx
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	78 58                	js     80180d <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017b5:	83 ec 08             	sub    $0x8,%esp
  8017b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017bb:	50                   	push   %eax
  8017bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017bf:	ff 30                	pushl  (%eax)
  8017c1:	e8 a9 fb ff ff       	call   80136f <dev_lookup>
  8017c6:	83 c4 10             	add    $0x10,%esp
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	78 37                	js     801804 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  8017cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d0:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017d4:	74 32                	je     801808 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017d6:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017d9:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017e0:	00 00 00 
	stat->st_isdir = 0;
  8017e3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017ea:	00 00 00 
	stat->st_dev = dev;
  8017ed:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017f3:	83 ec 08             	sub    $0x8,%esp
  8017f6:	53                   	push   %ebx
  8017f7:	ff 75 f0             	pushl  -0x10(%ebp)
  8017fa:	ff 50 14             	call   *0x14(%eax)
  8017fd:	89 c2                	mov    %eax,%edx
  8017ff:	83 c4 10             	add    $0x10,%esp
  801802:	eb 09                	jmp    80180d <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801804:	89 c2                	mov    %eax,%edx
  801806:	eb 05                	jmp    80180d <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801808:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80180d:	89 d0                	mov    %edx,%eax
  80180f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
  801817:	56                   	push   %esi
  801818:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801819:	83 ec 08             	sub    $0x8,%esp
  80181c:	6a 00                	push   $0x0
  80181e:	ff 75 08             	pushl  0x8(%ebp)
  801821:	e8 06 02 00 00       	call   801a2c <open>
  801826:	89 c3                	mov    %eax,%ebx
  801828:	83 c4 10             	add    $0x10,%esp
  80182b:	85 c0                	test   %eax,%eax
  80182d:	78 1b                	js     80184a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80182f:	83 ec 08             	sub    $0x8,%esp
  801832:	ff 75 0c             	pushl  0xc(%ebp)
  801835:	50                   	push   %eax
  801836:	e8 5b ff ff ff       	call   801796 <fstat>
  80183b:	89 c6                	mov    %eax,%esi
	close(fd);
  80183d:	89 1c 24             	mov    %ebx,(%esp)
  801840:	e8 fd fb ff ff       	call   801442 <close>
	return r;
  801845:	83 c4 10             	add    $0x10,%esp
  801848:	89 f0                	mov    %esi,%eax
}
  80184a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80184d:	5b                   	pop    %ebx
  80184e:	5e                   	pop    %esi
  80184f:	5d                   	pop    %ebp
  801850:	c3                   	ret    

00801851 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	56                   	push   %esi
  801855:	53                   	push   %ebx
  801856:	89 c6                	mov    %eax,%esi
  801858:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80185a:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801861:	75 12                	jne    801875 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801863:	83 ec 0c             	sub    $0xc,%esp
  801866:	6a 01                	push   $0x1
  801868:	e8 94 08 00 00       	call   802101 <ipc_find_env>
  80186d:	a3 00 40 80 00       	mov    %eax,0x804000
  801872:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801875:	6a 07                	push   $0x7
  801877:	68 00 50 80 00       	push   $0x805000
  80187c:	56                   	push   %esi
  80187d:	ff 35 00 40 80 00    	pushl  0x804000
  801883:	e8 25 08 00 00       	call   8020ad <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801888:	83 c4 0c             	add    $0xc,%esp
  80188b:	6a 00                	push   $0x0
  80188d:	53                   	push   %ebx
  80188e:	6a 00                	push   $0x0
  801890:	e8 ad 07 00 00       	call   802042 <ipc_recv>
}
  801895:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801898:	5b                   	pop    %ebx
  801899:	5e                   	pop    %esi
  80189a:	5d                   	pop    %ebp
  80189b:	c3                   	ret    

0080189c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b0:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ba:	b8 02 00 00 00       	mov    $0x2,%eax
  8018bf:	e8 8d ff ff ff       	call   801851 <fsipc>
}
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
  8018c9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8018d2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018dc:	b8 06 00 00 00       	mov    $0x6,%eax
  8018e1:	e8 6b ff ff ff       	call   801851 <fsipc>
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	53                   	push   %ebx
  8018ec:	83 ec 04             	sub    $0x4,%esp
  8018ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8018f8:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801902:	b8 05 00 00 00       	mov    $0x5,%eax
  801907:	e8 45 ff ff ff       	call   801851 <fsipc>
  80190c:	85 c0                	test   %eax,%eax
  80190e:	78 2c                	js     80193c <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801910:	83 ec 08             	sub    $0x8,%esp
  801913:	68 00 50 80 00       	push   $0x805000
  801918:	53                   	push   %ebx
  801919:	e8 67 ef ff ff       	call   800885 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80191e:	a1 80 50 80 00       	mov    0x805080,%eax
  801923:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801929:	a1 84 50 80 00       	mov    0x805084,%eax
  80192e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801934:	83 c4 10             	add    $0x10,%esp
  801937:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80193c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
  801944:	83 ec 08             	sub    $0x8,%esp
  801947:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194a:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80194d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801950:	8b 49 0c             	mov    0xc(%ecx),%ecx
  801953:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  801959:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80195e:	76 22                	jbe    801982 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  801960:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  801967:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  80196a:	83 ec 04             	sub    $0x4,%esp
  80196d:	68 f8 0f 00 00       	push   $0xff8
  801972:	52                   	push   %edx
  801973:	68 08 50 80 00       	push   $0x805008
  801978:	e8 9b f0 ff ff       	call   800a18 <memmove>
  80197d:	83 c4 10             	add    $0x10,%esp
  801980:	eb 17                	jmp    801999 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  801982:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  801987:	83 ec 04             	sub    $0x4,%esp
  80198a:	50                   	push   %eax
  80198b:	52                   	push   %edx
  80198c:	68 08 50 80 00       	push   $0x805008
  801991:	e8 82 f0 ff ff       	call   800a18 <memmove>
  801996:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  801999:	ba 00 00 00 00       	mov    $0x0,%edx
  80199e:	b8 04 00 00 00       	mov    $0x4,%eax
  8019a3:	e8 a9 fe ff ff       	call   801851 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	56                   	push   %esi
  8019ae:	53                   	push   %ebx
  8019af:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8019b8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019bd:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c8:	b8 03 00 00 00       	mov    $0x3,%eax
  8019cd:	e8 7f fe ff ff       	call   801851 <fsipc>
  8019d2:	89 c3                	mov    %eax,%ebx
  8019d4:	85 c0                	test   %eax,%eax
  8019d6:	78 4b                	js     801a23 <devfile_read+0x79>
		return r;
	assert(r <= n);
  8019d8:	39 c6                	cmp    %eax,%esi
  8019da:	73 16                	jae    8019f2 <devfile_read+0x48>
  8019dc:	68 3c 2a 80 00       	push   $0x802a3c
  8019e1:	68 43 2a 80 00       	push   $0x802a43
  8019e6:	6a 7c                	push   $0x7c
  8019e8:	68 58 2a 80 00       	push   $0x802a58
  8019ed:	e8 48 e8 ff ff       	call   80023a <_panic>
	assert(r <= PGSIZE);
  8019f2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019f7:	7e 16                	jle    801a0f <devfile_read+0x65>
  8019f9:	68 63 2a 80 00       	push   $0x802a63
  8019fe:	68 43 2a 80 00       	push   $0x802a43
  801a03:	6a 7d                	push   $0x7d
  801a05:	68 58 2a 80 00       	push   $0x802a58
  801a0a:	e8 2b e8 ff ff       	call   80023a <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a0f:	83 ec 04             	sub    $0x4,%esp
  801a12:	50                   	push   %eax
  801a13:	68 00 50 80 00       	push   $0x805000
  801a18:	ff 75 0c             	pushl  0xc(%ebp)
  801a1b:	e8 f8 ef ff ff       	call   800a18 <memmove>
	return r;
  801a20:	83 c4 10             	add    $0x10,%esp
}
  801a23:	89 d8                	mov    %ebx,%eax
  801a25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a28:	5b                   	pop    %ebx
  801a29:	5e                   	pop    %esi
  801a2a:	5d                   	pop    %ebp
  801a2b:	c3                   	ret    

00801a2c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	53                   	push   %ebx
  801a30:	83 ec 20             	sub    $0x20,%esp
  801a33:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801a36:	53                   	push   %ebx
  801a37:	e8 10 ee ff ff       	call   80084c <strlen>
  801a3c:	83 c4 10             	add    $0x10,%esp
  801a3f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a44:	7f 67                	jg     801aad <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801a46:	83 ec 0c             	sub    $0xc,%esp
  801a49:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a4c:	50                   	push   %eax
  801a4d:	e8 78 f8 ff ff       	call   8012ca <fd_alloc>
  801a52:	83 c4 10             	add    $0x10,%esp
		return r;
  801a55:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801a57:	85 c0                	test   %eax,%eax
  801a59:	78 57                	js     801ab2 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801a5b:	83 ec 08             	sub    $0x8,%esp
  801a5e:	53                   	push   %ebx
  801a5f:	68 00 50 80 00       	push   $0x805000
  801a64:	e8 1c ee ff ff       	call   800885 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6c:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a74:	b8 01 00 00 00       	mov    $0x1,%eax
  801a79:	e8 d3 fd ff ff       	call   801851 <fsipc>
  801a7e:	89 c3                	mov    %eax,%ebx
  801a80:	83 c4 10             	add    $0x10,%esp
  801a83:	85 c0                	test   %eax,%eax
  801a85:	79 14                	jns    801a9b <open+0x6f>
		fd_close(fd, 0);
  801a87:	83 ec 08             	sub    $0x8,%esp
  801a8a:	6a 00                	push   $0x0
  801a8c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a8f:	e8 2e f9 ff ff       	call   8013c2 <fd_close>
		return r;
  801a94:	83 c4 10             	add    $0x10,%esp
  801a97:	89 da                	mov    %ebx,%edx
  801a99:	eb 17                	jmp    801ab2 <open+0x86>
	}

	return fd2num(fd);
  801a9b:	83 ec 0c             	sub    $0xc,%esp
  801a9e:	ff 75 f4             	pushl  -0xc(%ebp)
  801aa1:	e8 fc f7 ff ff       	call   8012a2 <fd2num>
  801aa6:	89 c2                	mov    %eax,%edx
  801aa8:	83 c4 10             	add    $0x10,%esp
  801aab:	eb 05                	jmp    801ab2 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801aad:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801ab2:	89 d0                	mov    %edx,%eax
  801ab4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801abf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac4:	b8 08 00 00 00       	mov    $0x8,%eax
  801ac9:	e8 83 fd ff ff       	call   801851 <fsipc>
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
  801ad3:	56                   	push   %esi
  801ad4:	53                   	push   %ebx
  801ad5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ad8:	83 ec 0c             	sub    $0xc,%esp
  801adb:	ff 75 08             	pushl  0x8(%ebp)
  801ade:	e8 cf f7 ff ff       	call   8012b2 <fd2data>
  801ae3:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ae5:	83 c4 08             	add    $0x8,%esp
  801ae8:	68 6f 2a 80 00       	push   $0x802a6f
  801aed:	53                   	push   %ebx
  801aee:	e8 92 ed ff ff       	call   800885 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801af3:	8b 46 04             	mov    0x4(%esi),%eax
  801af6:	2b 06                	sub    (%esi),%eax
  801af8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801afe:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b05:	00 00 00 
	stat->st_dev = &devpipe;
  801b08:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b0f:	30 80 00 
	return 0;
}
  801b12:	b8 00 00 00 00       	mov    $0x0,%eax
  801b17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b1a:	5b                   	pop    %ebx
  801b1b:	5e                   	pop    %esi
  801b1c:	5d                   	pop    %ebp
  801b1d:	c3                   	ret    

00801b1e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	53                   	push   %ebx
  801b22:	83 ec 0c             	sub    $0xc,%esp
  801b25:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b28:	53                   	push   %ebx
  801b29:	6a 00                	push   $0x0
  801b2b:	e8 e8 f1 ff ff       	call   800d18 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b30:	89 1c 24             	mov    %ebx,(%esp)
  801b33:	e8 7a f7 ff ff       	call   8012b2 <fd2data>
  801b38:	83 c4 08             	add    $0x8,%esp
  801b3b:	50                   	push   %eax
  801b3c:	6a 00                	push   $0x0
  801b3e:	e8 d5 f1 ff ff       	call   800d18 <sys_page_unmap>
}
  801b43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	57                   	push   %edi
  801b4c:	56                   	push   %esi
  801b4d:	53                   	push   %ebx
  801b4e:	83 ec 1c             	sub    $0x1c,%esp
  801b51:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801b54:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801b56:	a1 04 40 80 00       	mov    0x804004,%eax
  801b5b:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801b5e:	83 ec 0c             	sub    $0xc,%esp
  801b61:	ff 75 e0             	pushl  -0x20(%ebp)
  801b64:	e8 d1 05 00 00       	call   80213a <pageref>
  801b69:	89 c3                	mov    %eax,%ebx
  801b6b:	89 3c 24             	mov    %edi,(%esp)
  801b6e:	e8 c7 05 00 00       	call   80213a <pageref>
  801b73:	83 c4 10             	add    $0x10,%esp
  801b76:	39 c3                	cmp    %eax,%ebx
  801b78:	0f 94 c1             	sete   %cl
  801b7b:	0f b6 c9             	movzbl %cl,%ecx
  801b7e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801b81:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b87:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b8a:	39 ce                	cmp    %ecx,%esi
  801b8c:	74 1b                	je     801ba9 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801b8e:	39 c3                	cmp    %eax,%ebx
  801b90:	75 c4                	jne    801b56 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b92:	8b 42 58             	mov    0x58(%edx),%eax
  801b95:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b98:	50                   	push   %eax
  801b99:	56                   	push   %esi
  801b9a:	68 76 2a 80 00       	push   $0x802a76
  801b9f:	e8 6f e7 ff ff       	call   800313 <cprintf>
  801ba4:	83 c4 10             	add    $0x10,%esp
  801ba7:	eb ad                	jmp    801b56 <_pipeisclosed+0xe>
	}
}
  801ba9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801baf:	5b                   	pop    %ebx
  801bb0:	5e                   	pop    %esi
  801bb1:	5f                   	pop    %edi
  801bb2:	5d                   	pop    %ebp
  801bb3:	c3                   	ret    

00801bb4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
  801bb7:	57                   	push   %edi
  801bb8:	56                   	push   %esi
  801bb9:	53                   	push   %ebx
  801bba:	83 ec 28             	sub    $0x28,%esp
  801bbd:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801bc0:	56                   	push   %esi
  801bc1:	e8 ec f6 ff ff       	call   8012b2 <fd2data>
  801bc6:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801bc8:	83 c4 10             	add    $0x10,%esp
  801bcb:	bf 00 00 00 00       	mov    $0x0,%edi
  801bd0:	eb 4b                	jmp    801c1d <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801bd2:	89 da                	mov    %ebx,%edx
  801bd4:	89 f0                	mov    %esi,%eax
  801bd6:	e8 6d ff ff ff       	call   801b48 <_pipeisclosed>
  801bdb:	85 c0                	test   %eax,%eax
  801bdd:	75 48                	jne    801c27 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801bdf:	e8 c3 f0 ff ff       	call   800ca7 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801be4:	8b 43 04             	mov    0x4(%ebx),%eax
  801be7:	8b 0b                	mov    (%ebx),%ecx
  801be9:	8d 51 20             	lea    0x20(%ecx),%edx
  801bec:	39 d0                	cmp    %edx,%eax
  801bee:	73 e2                	jae    801bd2 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bf0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bf3:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801bf7:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801bfa:	89 c2                	mov    %eax,%edx
  801bfc:	c1 fa 1f             	sar    $0x1f,%edx
  801bff:	89 d1                	mov    %edx,%ecx
  801c01:	c1 e9 1b             	shr    $0x1b,%ecx
  801c04:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c07:	83 e2 1f             	and    $0x1f,%edx
  801c0a:	29 ca                	sub    %ecx,%edx
  801c0c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c10:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c14:	83 c0 01             	add    $0x1,%eax
  801c17:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c1a:	83 c7 01             	add    $0x1,%edi
  801c1d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c20:	75 c2                	jne    801be4 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801c22:	8b 45 10             	mov    0x10(%ebp),%eax
  801c25:	eb 05                	jmp    801c2c <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801c27:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c2f:	5b                   	pop    %ebx
  801c30:	5e                   	pop    %esi
  801c31:	5f                   	pop    %edi
  801c32:	5d                   	pop    %ebp
  801c33:	c3                   	ret    

00801c34 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	57                   	push   %edi
  801c38:	56                   	push   %esi
  801c39:	53                   	push   %ebx
  801c3a:	83 ec 18             	sub    $0x18,%esp
  801c3d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801c40:	57                   	push   %edi
  801c41:	e8 6c f6 ff ff       	call   8012b2 <fd2data>
  801c46:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c48:	83 c4 10             	add    $0x10,%esp
  801c4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c50:	eb 3d                	jmp    801c8f <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801c52:	85 db                	test   %ebx,%ebx
  801c54:	74 04                	je     801c5a <devpipe_read+0x26>
				return i;
  801c56:	89 d8                	mov    %ebx,%eax
  801c58:	eb 44                	jmp    801c9e <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801c5a:	89 f2                	mov    %esi,%edx
  801c5c:	89 f8                	mov    %edi,%eax
  801c5e:	e8 e5 fe ff ff       	call   801b48 <_pipeisclosed>
  801c63:	85 c0                	test   %eax,%eax
  801c65:	75 32                	jne    801c99 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801c67:	e8 3b f0 ff ff       	call   800ca7 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801c6c:	8b 06                	mov    (%esi),%eax
  801c6e:	3b 46 04             	cmp    0x4(%esi),%eax
  801c71:	74 df                	je     801c52 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c73:	99                   	cltd   
  801c74:	c1 ea 1b             	shr    $0x1b,%edx
  801c77:	01 d0                	add    %edx,%eax
  801c79:	83 e0 1f             	and    $0x1f,%eax
  801c7c:	29 d0                	sub    %edx,%eax
  801c7e:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801c83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c86:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801c89:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c8c:	83 c3 01             	add    $0x1,%ebx
  801c8f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801c92:	75 d8                	jne    801c6c <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801c94:	8b 45 10             	mov    0x10(%ebp),%eax
  801c97:	eb 05                	jmp    801c9e <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801c99:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801c9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ca1:	5b                   	pop    %ebx
  801ca2:	5e                   	pop    %esi
  801ca3:	5f                   	pop    %edi
  801ca4:	5d                   	pop    %ebp
  801ca5:	c3                   	ret    

00801ca6 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	56                   	push   %esi
  801caa:	53                   	push   %ebx
  801cab:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801cae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cb1:	50                   	push   %eax
  801cb2:	e8 13 f6 ff ff       	call   8012ca <fd_alloc>
  801cb7:	83 c4 10             	add    $0x10,%esp
  801cba:	89 c2                	mov    %eax,%edx
  801cbc:	85 c0                	test   %eax,%eax
  801cbe:	0f 88 2c 01 00 00    	js     801df0 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cc4:	83 ec 04             	sub    $0x4,%esp
  801cc7:	68 07 04 00 00       	push   $0x407
  801ccc:	ff 75 f4             	pushl  -0xc(%ebp)
  801ccf:	6a 00                	push   $0x0
  801cd1:	e8 f8 ef ff ff       	call   800cce <sys_page_alloc>
  801cd6:	83 c4 10             	add    $0x10,%esp
  801cd9:	89 c2                	mov    %eax,%edx
  801cdb:	85 c0                	test   %eax,%eax
  801cdd:	0f 88 0d 01 00 00    	js     801df0 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801ce3:	83 ec 0c             	sub    $0xc,%esp
  801ce6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ce9:	50                   	push   %eax
  801cea:	e8 db f5 ff ff       	call   8012ca <fd_alloc>
  801cef:	89 c3                	mov    %eax,%ebx
  801cf1:	83 c4 10             	add    $0x10,%esp
  801cf4:	85 c0                	test   %eax,%eax
  801cf6:	0f 88 e2 00 00 00    	js     801dde <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cfc:	83 ec 04             	sub    $0x4,%esp
  801cff:	68 07 04 00 00       	push   $0x407
  801d04:	ff 75 f0             	pushl  -0x10(%ebp)
  801d07:	6a 00                	push   $0x0
  801d09:	e8 c0 ef ff ff       	call   800cce <sys_page_alloc>
  801d0e:	89 c3                	mov    %eax,%ebx
  801d10:	83 c4 10             	add    $0x10,%esp
  801d13:	85 c0                	test   %eax,%eax
  801d15:	0f 88 c3 00 00 00    	js     801dde <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801d1b:	83 ec 0c             	sub    $0xc,%esp
  801d1e:	ff 75 f4             	pushl  -0xc(%ebp)
  801d21:	e8 8c f5 ff ff       	call   8012b2 <fd2data>
  801d26:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d28:	83 c4 0c             	add    $0xc,%esp
  801d2b:	68 07 04 00 00       	push   $0x407
  801d30:	50                   	push   %eax
  801d31:	6a 00                	push   $0x0
  801d33:	e8 96 ef ff ff       	call   800cce <sys_page_alloc>
  801d38:	89 c3                	mov    %eax,%ebx
  801d3a:	83 c4 10             	add    $0x10,%esp
  801d3d:	85 c0                	test   %eax,%eax
  801d3f:	0f 88 89 00 00 00    	js     801dce <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d45:	83 ec 0c             	sub    $0xc,%esp
  801d48:	ff 75 f0             	pushl  -0x10(%ebp)
  801d4b:	e8 62 f5 ff ff       	call   8012b2 <fd2data>
  801d50:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d57:	50                   	push   %eax
  801d58:	6a 00                	push   $0x0
  801d5a:	56                   	push   %esi
  801d5b:	6a 00                	push   $0x0
  801d5d:	e8 90 ef ff ff       	call   800cf2 <sys_page_map>
  801d62:	89 c3                	mov    %eax,%ebx
  801d64:	83 c4 20             	add    $0x20,%esp
  801d67:	85 c0                	test   %eax,%eax
  801d69:	78 55                	js     801dc0 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801d6b:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d74:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d79:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801d80:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d89:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801d95:	83 ec 0c             	sub    $0xc,%esp
  801d98:	ff 75 f4             	pushl  -0xc(%ebp)
  801d9b:	e8 02 f5 ff ff       	call   8012a2 <fd2num>
  801da0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801da3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801da5:	83 c4 04             	add    $0x4,%esp
  801da8:	ff 75 f0             	pushl  -0x10(%ebp)
  801dab:	e8 f2 f4 ff ff       	call   8012a2 <fd2num>
  801db0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801db3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801db6:	83 c4 10             	add    $0x10,%esp
  801db9:	ba 00 00 00 00       	mov    $0x0,%edx
  801dbe:	eb 30                	jmp    801df0 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801dc0:	83 ec 08             	sub    $0x8,%esp
  801dc3:	56                   	push   %esi
  801dc4:	6a 00                	push   $0x0
  801dc6:	e8 4d ef ff ff       	call   800d18 <sys_page_unmap>
  801dcb:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801dce:	83 ec 08             	sub    $0x8,%esp
  801dd1:	ff 75 f0             	pushl  -0x10(%ebp)
  801dd4:	6a 00                	push   $0x0
  801dd6:	e8 3d ef ff ff       	call   800d18 <sys_page_unmap>
  801ddb:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801dde:	83 ec 08             	sub    $0x8,%esp
  801de1:	ff 75 f4             	pushl  -0xc(%ebp)
  801de4:	6a 00                	push   $0x0
  801de6:	e8 2d ef ff ff       	call   800d18 <sys_page_unmap>
  801deb:	83 c4 10             	add    $0x10,%esp
  801dee:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  801df0:	89 d0                	mov    %edx,%eax
  801df2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801df5:	5b                   	pop    %ebx
  801df6:	5e                   	pop    %esi
  801df7:	5d                   	pop    %ebp
  801df8:	c3                   	ret    

00801df9 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e02:	50                   	push   %eax
  801e03:	ff 75 08             	pushl  0x8(%ebp)
  801e06:	e8 0e f5 ff ff       	call   801319 <fd_lookup>
  801e0b:	83 c4 10             	add    $0x10,%esp
  801e0e:	85 c0                	test   %eax,%eax
  801e10:	78 18                	js     801e2a <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801e12:	83 ec 0c             	sub    $0xc,%esp
  801e15:	ff 75 f4             	pushl  -0xc(%ebp)
  801e18:	e8 95 f4 ff ff       	call   8012b2 <fd2data>
	return _pipeisclosed(fd, p);
  801e1d:	89 c2                	mov    %eax,%edx
  801e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e22:	e8 21 fd ff ff       	call   801b48 <_pipeisclosed>
  801e27:	83 c4 10             	add    $0x10,%esp
}
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801e2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e34:	5d                   	pop    %ebp
  801e35:	c3                   	ret    

00801e36 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e3c:	68 8e 2a 80 00       	push   $0x802a8e
  801e41:	ff 75 0c             	pushl  0xc(%ebp)
  801e44:	e8 3c ea ff ff       	call   800885 <strcpy>
	return 0;
}
  801e49:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	57                   	push   %edi
  801e54:	56                   	push   %esi
  801e55:	53                   	push   %ebx
  801e56:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e5c:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801e61:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e67:	eb 2d                	jmp    801e96 <devcons_write+0x46>
		m = n - tot;
  801e69:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e6c:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801e6e:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801e71:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801e76:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801e79:	83 ec 04             	sub    $0x4,%esp
  801e7c:	53                   	push   %ebx
  801e7d:	03 45 0c             	add    0xc(%ebp),%eax
  801e80:	50                   	push   %eax
  801e81:	57                   	push   %edi
  801e82:	e8 91 eb ff ff       	call   800a18 <memmove>
		sys_cputs(buf, m);
  801e87:	83 c4 08             	add    $0x8,%esp
  801e8a:	53                   	push   %ebx
  801e8b:	57                   	push   %edi
  801e8c:	e8 86 ed ff ff       	call   800c17 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e91:	01 de                	add    %ebx,%esi
  801e93:	83 c4 10             	add    $0x10,%esp
  801e96:	89 f0                	mov    %esi,%eax
  801e98:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e9b:	72 cc                	jb     801e69 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ea0:	5b                   	pop    %ebx
  801ea1:	5e                   	pop    %esi
  801ea2:	5f                   	pop    %edi
  801ea3:	5d                   	pop    %ebp
  801ea4:	c3                   	ret    

00801ea5 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	83 ec 08             	sub    $0x8,%esp
  801eab:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801eb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eb4:	74 2a                	je     801ee0 <devcons_read+0x3b>
  801eb6:	eb 05                	jmp    801ebd <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801eb8:	e8 ea ed ff ff       	call   800ca7 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801ebd:	e8 7b ed ff ff       	call   800c3d <sys_cgetc>
  801ec2:	85 c0                	test   %eax,%eax
  801ec4:	74 f2                	je     801eb8 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801ec6:	85 c0                	test   %eax,%eax
  801ec8:	78 16                	js     801ee0 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801eca:	83 f8 04             	cmp    $0x4,%eax
  801ecd:	74 0c                	je     801edb <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801ecf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed2:	88 02                	mov    %al,(%edx)
	return 1;
  801ed4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed9:	eb 05                	jmp    801ee0 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801edb:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
  801ee5:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eeb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801eee:	6a 01                	push   $0x1
  801ef0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ef3:	50                   	push   %eax
  801ef4:	e8 1e ed ff ff       	call   800c17 <sys_cputs>
}
  801ef9:	83 c4 10             	add    $0x10,%esp
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <getchar>:

int
getchar(void)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801f04:	6a 01                	push   $0x1
  801f06:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f09:	50                   	push   %eax
  801f0a:	6a 00                	push   $0x0
  801f0c:	e8 6d f6 ff ff       	call   80157e <read>
	if (r < 0)
  801f11:	83 c4 10             	add    $0x10,%esp
  801f14:	85 c0                	test   %eax,%eax
  801f16:	78 0f                	js     801f27 <getchar+0x29>
		return r;
	if (r < 1)
  801f18:	85 c0                	test   %eax,%eax
  801f1a:	7e 06                	jle    801f22 <getchar+0x24>
		return -E_EOF;
	return c;
  801f1c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801f20:	eb 05                	jmp    801f27 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801f22:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f2f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f32:	50                   	push   %eax
  801f33:	ff 75 08             	pushl  0x8(%ebp)
  801f36:	e8 de f3 ff ff       	call   801319 <fd_lookup>
  801f3b:	83 c4 10             	add    $0x10,%esp
  801f3e:	85 c0                	test   %eax,%eax
  801f40:	78 11                	js     801f53 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f45:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f4b:	39 10                	cmp    %edx,(%eax)
  801f4d:	0f 94 c0             	sete   %al
  801f50:	0f b6 c0             	movzbl %al,%eax
}
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    

00801f55 <opencons>:

int
opencons(void)
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
  801f58:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801f5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f5e:	50                   	push   %eax
  801f5f:	e8 66 f3 ff ff       	call   8012ca <fd_alloc>
  801f64:	83 c4 10             	add    $0x10,%esp
		return r;
  801f67:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801f69:	85 c0                	test   %eax,%eax
  801f6b:	78 3e                	js     801fab <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f6d:	83 ec 04             	sub    $0x4,%esp
  801f70:	68 07 04 00 00       	push   $0x407
  801f75:	ff 75 f4             	pushl  -0xc(%ebp)
  801f78:	6a 00                	push   $0x0
  801f7a:	e8 4f ed ff ff       	call   800cce <sys_page_alloc>
  801f7f:	83 c4 10             	add    $0x10,%esp
		return r;
  801f82:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f84:	85 c0                	test   %eax,%eax
  801f86:	78 23                	js     801fab <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801f88:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f91:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f96:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f9d:	83 ec 0c             	sub    $0xc,%esp
  801fa0:	50                   	push   %eax
  801fa1:	e8 fc f2 ff ff       	call   8012a2 <fd2num>
  801fa6:	89 c2                	mov    %eax,%edx
  801fa8:	83 c4 10             	add    $0x10,%esp
}
  801fab:	89 d0                	mov    %edx,%eax
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
  801fb2:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801fb5:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801fbc:	75 2c                	jne    801fea <set_pgfault_handler+0x3b>
		// First time through!
		// LAB 4: Your code here.
		r = sys_page_alloc(0,(void *)(UXSTACKTOP - PGSIZE),PTE_P | PTE_U | PTE_W);
  801fbe:	83 ec 04             	sub    $0x4,%esp
  801fc1:	6a 07                	push   $0x7
  801fc3:	68 00 f0 bf ee       	push   $0xeebff000
  801fc8:	6a 00                	push   $0x0
  801fca:	e8 ff ec ff ff       	call   800cce <sys_page_alloc>
		if(r < 0)
  801fcf:	83 c4 10             	add    $0x10,%esp
  801fd2:	85 c0                	test   %eax,%eax
  801fd4:	79 14                	jns    801fea <set_pgfault_handler+0x3b>
			panic("set_pgfault_handler: error in sys_page_alloc\n");	
  801fd6:	83 ec 04             	sub    $0x4,%esp
  801fd9:	68 9c 2a 80 00       	push   $0x802a9c
  801fde:	6a 22                	push   $0x22
  801fe0:	68 08 2b 80 00       	push   $0x802b08
  801fe5:	e8 50 e2 ff ff       	call   80023a <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	a3 00 60 80 00       	mov    %eax,0x806000
	r = sys_env_set_pgfault_upcall(0, _pgfault_upcall); 
  801ff2:	83 ec 08             	sub    $0x8,%esp
  801ff5:	68 1e 20 80 00       	push   $0x80201e
  801ffa:	6a 00                	push   $0x0
  801ffc:	e8 80 ed ff ff       	call   800d81 <sys_env_set_pgfault_upcall>
	if (r < 0)
  802001:	83 c4 10             	add    $0x10,%esp
  802004:	85 c0                	test   %eax,%eax
  802006:	79 14                	jns    80201c <set_pgfault_handler+0x6d>
		panic("set_pgfault_handler: error in sys_env_set_pgfault_upcall");
  802008:	83 ec 04             	sub    $0x4,%esp
  80200b:	68 cc 2a 80 00       	push   $0x802acc
  802010:	6a 29                	push   $0x29
  802012:	68 08 2b 80 00       	push   $0x802b08
  802017:	e8 1e e2 ff ff       	call   80023a <_panic>
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80201e:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80201f:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802024:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802026:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	subl $0x4, 0x30(%esp)
  802029:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  80202e:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 0x28(%esp), %ebx 	
  802032:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  802036:	89 18                	mov    %ebx,(%eax)
	addl $0x8, %esp
  802038:	83 c4 08             	add    $0x8,%esp


	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  80203b:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp 
  80203c:	83 c4 04             	add    $0x4,%esp
	popfl
  80203f:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802040:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802041:	c3                   	ret    

00802042 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	56                   	push   %esi
  802046:	53                   	push   %ebx
  802047:	8b 75 08             	mov    0x8(%ebp),%esi
  80204a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  802050:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  802052:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802057:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  80205a:	83 ec 0c             	sub    $0xc,%esp
  80205d:	50                   	push   %eax
  80205e:	e8 66 ed ff ff       	call   800dc9 <sys_ipc_recv>
	if (from_env_store)
  802063:	83 c4 10             	add    $0x10,%esp
  802066:	85 f6                	test   %esi,%esi
  802068:	74 0b                	je     802075 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  80206a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802070:	8b 52 74             	mov    0x74(%edx),%edx
  802073:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  802075:	85 db                	test   %ebx,%ebx
  802077:	74 0b                	je     802084 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  802079:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80207f:	8b 52 78             	mov    0x78(%edx),%edx
  802082:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  802084:	85 c0                	test   %eax,%eax
  802086:	79 16                	jns    80209e <ipc_recv+0x5c>
		if (from_env_store)
  802088:	85 f6                	test   %esi,%esi
  80208a:	74 06                	je     802092 <ipc_recv+0x50>
			*from_env_store = 0;
  80208c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  802092:	85 db                	test   %ebx,%ebx
  802094:	74 10                	je     8020a6 <ipc_recv+0x64>
			*perm_store = 0;
  802096:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80209c:	eb 08                	jmp    8020a6 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  80209e:	a1 04 40 80 00       	mov    0x804004,%eax
  8020a3:	8b 40 70             	mov    0x70(%eax),%eax
}
  8020a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020a9:	5b                   	pop    %ebx
  8020aa:	5e                   	pop    %esi
  8020ab:	5d                   	pop    %ebp
  8020ac:	c3                   	ret    

008020ad <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	57                   	push   %edi
  8020b1:	56                   	push   %esi
  8020b2:	53                   	push   %ebx
  8020b3:	83 ec 0c             	sub    $0xc,%esp
  8020b6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  8020bf:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  8020c1:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020c6:	0f 44 d8             	cmove  %eax,%ebx
  8020c9:	eb 1c                	jmp    8020e7 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  8020cb:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020ce:	74 12                	je     8020e2 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  8020d0:	50                   	push   %eax
  8020d1:	68 16 2b 80 00       	push   $0x802b16
  8020d6:	6a 42                	push   $0x42
  8020d8:	68 2c 2b 80 00       	push   $0x802b2c
  8020dd:	e8 58 e1 ff ff       	call   80023a <_panic>
		sys_yield();
  8020e2:	e8 c0 eb ff ff       	call   800ca7 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  8020e7:	ff 75 14             	pushl  0x14(%ebp)
  8020ea:	53                   	push   %ebx
  8020eb:	56                   	push   %esi
  8020ec:	57                   	push   %edi
  8020ed:	e8 b2 ec ff ff       	call   800da4 <sys_ipc_try_send>
  8020f2:	83 c4 10             	add    $0x10,%esp
  8020f5:	85 c0                	test   %eax,%eax
  8020f7:	75 d2                	jne    8020cb <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  8020f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020fc:	5b                   	pop    %ebx
  8020fd:	5e                   	pop    %esi
  8020fe:	5f                   	pop    %edi
  8020ff:	5d                   	pop    %ebp
  802100:	c3                   	ret    

00802101 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802101:	55                   	push   %ebp
  802102:	89 e5                	mov    %esp,%ebp
  802104:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802107:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80210c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80210f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802115:	8b 52 50             	mov    0x50(%edx),%edx
  802118:	39 ca                	cmp    %ecx,%edx
  80211a:	75 0d                	jne    802129 <ipc_find_env+0x28>
			return envs[i].env_id;
  80211c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80211f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802124:	8b 40 48             	mov    0x48(%eax),%eax
  802127:	eb 0f                	jmp    802138 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802129:	83 c0 01             	add    $0x1,%eax
  80212c:	3d 00 04 00 00       	cmp    $0x400,%eax
  802131:	75 d9                	jne    80210c <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802133:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802138:	5d                   	pop    %ebp
  802139:	c3                   	ret    

0080213a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802140:	89 d0                	mov    %edx,%eax
  802142:	c1 e8 16             	shr    $0x16,%eax
  802145:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80214c:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802151:	f6 c1 01             	test   $0x1,%cl
  802154:	74 1d                	je     802173 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802156:	c1 ea 0c             	shr    $0xc,%edx
  802159:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802160:	f6 c2 01             	test   $0x1,%dl
  802163:	74 0e                	je     802173 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802165:	c1 ea 0c             	shr    $0xc,%edx
  802168:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80216f:	ef 
  802170:	0f b7 c0             	movzwl %ax,%eax
}
  802173:	5d                   	pop    %ebp
  802174:	c3                   	ret    
  802175:	66 90                	xchg   %ax,%ax
  802177:	66 90                	xchg   %ax,%ax
  802179:	66 90                	xchg   %ax,%ax
  80217b:	66 90                	xchg   %ax,%ax
  80217d:	66 90                	xchg   %ax,%ax
  80217f:	90                   	nop

00802180 <__udivdi3>:
  802180:	55                   	push   %ebp
  802181:	57                   	push   %edi
  802182:	56                   	push   %esi
  802183:	53                   	push   %ebx
  802184:	83 ec 1c             	sub    $0x1c,%esp
  802187:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80218b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80218f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802193:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802197:	85 f6                	test   %esi,%esi
  802199:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80219d:	89 ca                	mov    %ecx,%edx
  80219f:	89 f8                	mov    %edi,%eax
  8021a1:	75 3d                	jne    8021e0 <__udivdi3+0x60>
  8021a3:	39 cf                	cmp    %ecx,%edi
  8021a5:	0f 87 c5 00 00 00    	ja     802270 <__udivdi3+0xf0>
  8021ab:	85 ff                	test   %edi,%edi
  8021ad:	89 fd                	mov    %edi,%ebp
  8021af:	75 0b                	jne    8021bc <__udivdi3+0x3c>
  8021b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8021b6:	31 d2                	xor    %edx,%edx
  8021b8:	f7 f7                	div    %edi
  8021ba:	89 c5                	mov    %eax,%ebp
  8021bc:	89 c8                	mov    %ecx,%eax
  8021be:	31 d2                	xor    %edx,%edx
  8021c0:	f7 f5                	div    %ebp
  8021c2:	89 c1                	mov    %eax,%ecx
  8021c4:	89 d8                	mov    %ebx,%eax
  8021c6:	89 cf                	mov    %ecx,%edi
  8021c8:	f7 f5                	div    %ebp
  8021ca:	89 c3                	mov    %eax,%ebx
  8021cc:	89 d8                	mov    %ebx,%eax
  8021ce:	89 fa                	mov    %edi,%edx
  8021d0:	83 c4 1c             	add    $0x1c,%esp
  8021d3:	5b                   	pop    %ebx
  8021d4:	5e                   	pop    %esi
  8021d5:	5f                   	pop    %edi
  8021d6:	5d                   	pop    %ebp
  8021d7:	c3                   	ret    
  8021d8:	90                   	nop
  8021d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021e0:	39 ce                	cmp    %ecx,%esi
  8021e2:	77 74                	ja     802258 <__udivdi3+0xd8>
  8021e4:	0f bd fe             	bsr    %esi,%edi
  8021e7:	83 f7 1f             	xor    $0x1f,%edi
  8021ea:	0f 84 98 00 00 00    	je     802288 <__udivdi3+0x108>
  8021f0:	bb 20 00 00 00       	mov    $0x20,%ebx
  8021f5:	89 f9                	mov    %edi,%ecx
  8021f7:	89 c5                	mov    %eax,%ebp
  8021f9:	29 fb                	sub    %edi,%ebx
  8021fb:	d3 e6                	shl    %cl,%esi
  8021fd:	89 d9                	mov    %ebx,%ecx
  8021ff:	d3 ed                	shr    %cl,%ebp
  802201:	89 f9                	mov    %edi,%ecx
  802203:	d3 e0                	shl    %cl,%eax
  802205:	09 ee                	or     %ebp,%esi
  802207:	89 d9                	mov    %ebx,%ecx
  802209:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80220d:	89 d5                	mov    %edx,%ebp
  80220f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802213:	d3 ed                	shr    %cl,%ebp
  802215:	89 f9                	mov    %edi,%ecx
  802217:	d3 e2                	shl    %cl,%edx
  802219:	89 d9                	mov    %ebx,%ecx
  80221b:	d3 e8                	shr    %cl,%eax
  80221d:	09 c2                	or     %eax,%edx
  80221f:	89 d0                	mov    %edx,%eax
  802221:	89 ea                	mov    %ebp,%edx
  802223:	f7 f6                	div    %esi
  802225:	89 d5                	mov    %edx,%ebp
  802227:	89 c3                	mov    %eax,%ebx
  802229:	f7 64 24 0c          	mull   0xc(%esp)
  80222d:	39 d5                	cmp    %edx,%ebp
  80222f:	72 10                	jb     802241 <__udivdi3+0xc1>
  802231:	8b 74 24 08          	mov    0x8(%esp),%esi
  802235:	89 f9                	mov    %edi,%ecx
  802237:	d3 e6                	shl    %cl,%esi
  802239:	39 c6                	cmp    %eax,%esi
  80223b:	73 07                	jae    802244 <__udivdi3+0xc4>
  80223d:	39 d5                	cmp    %edx,%ebp
  80223f:	75 03                	jne    802244 <__udivdi3+0xc4>
  802241:	83 eb 01             	sub    $0x1,%ebx
  802244:	31 ff                	xor    %edi,%edi
  802246:	89 d8                	mov    %ebx,%eax
  802248:	89 fa                	mov    %edi,%edx
  80224a:	83 c4 1c             	add    $0x1c,%esp
  80224d:	5b                   	pop    %ebx
  80224e:	5e                   	pop    %esi
  80224f:	5f                   	pop    %edi
  802250:	5d                   	pop    %ebp
  802251:	c3                   	ret    
  802252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802258:	31 ff                	xor    %edi,%edi
  80225a:	31 db                	xor    %ebx,%ebx
  80225c:	89 d8                	mov    %ebx,%eax
  80225e:	89 fa                	mov    %edi,%edx
  802260:	83 c4 1c             	add    $0x1c,%esp
  802263:	5b                   	pop    %ebx
  802264:	5e                   	pop    %esi
  802265:	5f                   	pop    %edi
  802266:	5d                   	pop    %ebp
  802267:	c3                   	ret    
  802268:	90                   	nop
  802269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802270:	89 d8                	mov    %ebx,%eax
  802272:	f7 f7                	div    %edi
  802274:	31 ff                	xor    %edi,%edi
  802276:	89 c3                	mov    %eax,%ebx
  802278:	89 d8                	mov    %ebx,%eax
  80227a:	89 fa                	mov    %edi,%edx
  80227c:	83 c4 1c             	add    $0x1c,%esp
  80227f:	5b                   	pop    %ebx
  802280:	5e                   	pop    %esi
  802281:	5f                   	pop    %edi
  802282:	5d                   	pop    %ebp
  802283:	c3                   	ret    
  802284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802288:	39 ce                	cmp    %ecx,%esi
  80228a:	72 0c                	jb     802298 <__udivdi3+0x118>
  80228c:	31 db                	xor    %ebx,%ebx
  80228e:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802292:	0f 87 34 ff ff ff    	ja     8021cc <__udivdi3+0x4c>
  802298:	bb 01 00 00 00       	mov    $0x1,%ebx
  80229d:	e9 2a ff ff ff       	jmp    8021cc <__udivdi3+0x4c>
  8022a2:	66 90                	xchg   %ax,%ax
  8022a4:	66 90                	xchg   %ax,%ax
  8022a6:	66 90                	xchg   %ax,%ax
  8022a8:	66 90                	xchg   %ax,%ax
  8022aa:	66 90                	xchg   %ax,%ax
  8022ac:	66 90                	xchg   %ax,%ax
  8022ae:	66 90                	xchg   %ax,%ax

008022b0 <__umoddi3>:
  8022b0:	55                   	push   %ebp
  8022b1:	57                   	push   %edi
  8022b2:	56                   	push   %esi
  8022b3:	53                   	push   %ebx
  8022b4:	83 ec 1c             	sub    $0x1c,%esp
  8022b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8022bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022c7:	85 d2                	test   %edx,%edx
  8022c9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8022cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022d1:	89 f3                	mov    %esi,%ebx
  8022d3:	89 3c 24             	mov    %edi,(%esp)
  8022d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022da:	75 1c                	jne    8022f8 <__umoddi3+0x48>
  8022dc:	39 f7                	cmp    %esi,%edi
  8022de:	76 50                	jbe    802330 <__umoddi3+0x80>
  8022e0:	89 c8                	mov    %ecx,%eax
  8022e2:	89 f2                	mov    %esi,%edx
  8022e4:	f7 f7                	div    %edi
  8022e6:	89 d0                	mov    %edx,%eax
  8022e8:	31 d2                	xor    %edx,%edx
  8022ea:	83 c4 1c             	add    $0x1c,%esp
  8022ed:	5b                   	pop    %ebx
  8022ee:	5e                   	pop    %esi
  8022ef:	5f                   	pop    %edi
  8022f0:	5d                   	pop    %ebp
  8022f1:	c3                   	ret    
  8022f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022f8:	39 f2                	cmp    %esi,%edx
  8022fa:	89 d0                	mov    %edx,%eax
  8022fc:	77 52                	ja     802350 <__umoddi3+0xa0>
  8022fe:	0f bd ea             	bsr    %edx,%ebp
  802301:	83 f5 1f             	xor    $0x1f,%ebp
  802304:	75 5a                	jne    802360 <__umoddi3+0xb0>
  802306:	3b 54 24 04          	cmp    0x4(%esp),%edx
  80230a:	0f 82 e0 00 00 00    	jb     8023f0 <__umoddi3+0x140>
  802310:	39 0c 24             	cmp    %ecx,(%esp)
  802313:	0f 86 d7 00 00 00    	jbe    8023f0 <__umoddi3+0x140>
  802319:	8b 44 24 08          	mov    0x8(%esp),%eax
  80231d:	8b 54 24 04          	mov    0x4(%esp),%edx
  802321:	83 c4 1c             	add    $0x1c,%esp
  802324:	5b                   	pop    %ebx
  802325:	5e                   	pop    %esi
  802326:	5f                   	pop    %edi
  802327:	5d                   	pop    %ebp
  802328:	c3                   	ret    
  802329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802330:	85 ff                	test   %edi,%edi
  802332:	89 fd                	mov    %edi,%ebp
  802334:	75 0b                	jne    802341 <__umoddi3+0x91>
  802336:	b8 01 00 00 00       	mov    $0x1,%eax
  80233b:	31 d2                	xor    %edx,%edx
  80233d:	f7 f7                	div    %edi
  80233f:	89 c5                	mov    %eax,%ebp
  802341:	89 f0                	mov    %esi,%eax
  802343:	31 d2                	xor    %edx,%edx
  802345:	f7 f5                	div    %ebp
  802347:	89 c8                	mov    %ecx,%eax
  802349:	f7 f5                	div    %ebp
  80234b:	89 d0                	mov    %edx,%eax
  80234d:	eb 99                	jmp    8022e8 <__umoddi3+0x38>
  80234f:	90                   	nop
  802350:	89 c8                	mov    %ecx,%eax
  802352:	89 f2                	mov    %esi,%edx
  802354:	83 c4 1c             	add    $0x1c,%esp
  802357:	5b                   	pop    %ebx
  802358:	5e                   	pop    %esi
  802359:	5f                   	pop    %edi
  80235a:	5d                   	pop    %ebp
  80235b:	c3                   	ret    
  80235c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802360:	8b 34 24             	mov    (%esp),%esi
  802363:	bf 20 00 00 00       	mov    $0x20,%edi
  802368:	89 e9                	mov    %ebp,%ecx
  80236a:	29 ef                	sub    %ebp,%edi
  80236c:	d3 e0                	shl    %cl,%eax
  80236e:	89 f9                	mov    %edi,%ecx
  802370:	89 f2                	mov    %esi,%edx
  802372:	d3 ea                	shr    %cl,%edx
  802374:	89 e9                	mov    %ebp,%ecx
  802376:	09 c2                	or     %eax,%edx
  802378:	89 d8                	mov    %ebx,%eax
  80237a:	89 14 24             	mov    %edx,(%esp)
  80237d:	89 f2                	mov    %esi,%edx
  80237f:	d3 e2                	shl    %cl,%edx
  802381:	89 f9                	mov    %edi,%ecx
  802383:	89 54 24 04          	mov    %edx,0x4(%esp)
  802387:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80238b:	d3 e8                	shr    %cl,%eax
  80238d:	89 e9                	mov    %ebp,%ecx
  80238f:	89 c6                	mov    %eax,%esi
  802391:	d3 e3                	shl    %cl,%ebx
  802393:	89 f9                	mov    %edi,%ecx
  802395:	89 d0                	mov    %edx,%eax
  802397:	d3 e8                	shr    %cl,%eax
  802399:	89 e9                	mov    %ebp,%ecx
  80239b:	09 d8                	or     %ebx,%eax
  80239d:	89 d3                	mov    %edx,%ebx
  80239f:	89 f2                	mov    %esi,%edx
  8023a1:	f7 34 24             	divl   (%esp)
  8023a4:	89 d6                	mov    %edx,%esi
  8023a6:	d3 e3                	shl    %cl,%ebx
  8023a8:	f7 64 24 04          	mull   0x4(%esp)
  8023ac:	39 d6                	cmp    %edx,%esi
  8023ae:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023b2:	89 d1                	mov    %edx,%ecx
  8023b4:	89 c3                	mov    %eax,%ebx
  8023b6:	72 08                	jb     8023c0 <__umoddi3+0x110>
  8023b8:	75 11                	jne    8023cb <__umoddi3+0x11b>
  8023ba:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8023be:	73 0b                	jae    8023cb <__umoddi3+0x11b>
  8023c0:	2b 44 24 04          	sub    0x4(%esp),%eax
  8023c4:	1b 14 24             	sbb    (%esp),%edx
  8023c7:	89 d1                	mov    %edx,%ecx
  8023c9:	89 c3                	mov    %eax,%ebx
  8023cb:	8b 54 24 08          	mov    0x8(%esp),%edx
  8023cf:	29 da                	sub    %ebx,%edx
  8023d1:	19 ce                	sbb    %ecx,%esi
  8023d3:	89 f9                	mov    %edi,%ecx
  8023d5:	89 f0                	mov    %esi,%eax
  8023d7:	d3 e0                	shl    %cl,%eax
  8023d9:	89 e9                	mov    %ebp,%ecx
  8023db:	d3 ea                	shr    %cl,%edx
  8023dd:	89 e9                	mov    %ebp,%ecx
  8023df:	d3 ee                	shr    %cl,%esi
  8023e1:	09 d0                	or     %edx,%eax
  8023e3:	89 f2                	mov    %esi,%edx
  8023e5:	83 c4 1c             	add    $0x1c,%esp
  8023e8:	5b                   	pop    %ebx
  8023e9:	5e                   	pop    %esi
  8023ea:	5f                   	pop    %edi
  8023eb:	5d                   	pop    %ebp
  8023ec:	c3                   	ret    
  8023ed:	8d 76 00             	lea    0x0(%esi),%esi
  8023f0:	29 f9                	sub    %edi,%ecx
  8023f2:	19 d6                	sbb    %edx,%esi
  8023f4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023f8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023fc:	e9 18 ff ff ff       	jmp    802319 <__umoddi3+0x69>
