
obj/user/icode.debug:     formato del fichero elf32-i386


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
  80002c:	e8 03 01 00 00       	call   800134 <libmain>
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
  800038:	81 ec 1c 02 00 00    	sub    $0x21c,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80003e:	c7 05 00 30 80 00 00 	movl   $0x802400,0x803000
  800045:	24 80 00 

	cprintf("icode startup\n");
  800048:	68 06 24 80 00       	push   $0x802406
  80004d:	e8 1f 02 00 00       	call   800271 <cprintf>

	cprintf("icode: open /motd\n");
  800052:	c7 04 24 15 24 80 00 	movl   $0x802415,(%esp)
  800059:	e8 13 02 00 00       	call   800271 <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  80005e:	83 c4 08             	add    $0x8,%esp
  800061:	6a 00                	push   $0x0
  800063:	68 28 24 80 00       	push   $0x802428
  800068:	e8 66 14 00 00       	call   8014d3 <open>
  80006d:	89 c6                	mov    %eax,%esi
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	85 c0                	test   %eax,%eax
  800074:	79 12                	jns    800088 <umain+0x55>
		panic("icode: open /motd: %e", fd);
  800076:	50                   	push   %eax
  800077:	68 2e 24 80 00       	push   $0x80242e
  80007c:	6a 0f                	push   $0xf
  80007e:	68 44 24 80 00       	push   $0x802444
  800083:	e8 10 01 00 00       	call   800198 <_panic>

	cprintf("icode: read /motd\n");
  800088:	83 ec 0c             	sub    $0xc,%esp
  80008b:	68 51 24 80 00       	push   $0x802451
  800090:	e8 dc 01 00 00       	call   800271 <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  80009e:	eb 0d                	jmp    8000ad <umain+0x7a>
		sys_cputs(buf, n);
  8000a0:	83 ec 08             	sub    $0x8,%esp
  8000a3:	50                   	push   %eax
  8000a4:	53                   	push   %ebx
  8000a5:	e8 cb 0a 00 00       	call   800b75 <sys_cputs>
  8000aa:	83 c4 10             	add    $0x10,%esp
	cprintf("icode: open /motd\n");
	if ((fd = open("/motd", O_RDONLY)) < 0)
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	68 00 02 00 00       	push   $0x200
  8000b5:	53                   	push   %ebx
  8000b6:	56                   	push   %esi
  8000b7:	e8 69 0f 00 00       	call   801025 <read>
  8000bc:	83 c4 10             	add    $0x10,%esp
  8000bf:	85 c0                	test   %eax,%eax
  8000c1:	7f dd                	jg     8000a0 <umain+0x6d>
		sys_cputs(buf, n);

	cprintf("icode: close /motd\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 64 24 80 00       	push   $0x802464
  8000cb:	e8 a1 01 00 00       	call   800271 <cprintf>
	close(fd);
  8000d0:	89 34 24             	mov    %esi,(%esp)
  8000d3:	e8 11 0e 00 00       	call   800ee9 <close>

	cprintf("icode: spawn /init\n");
  8000d8:	c7 04 24 78 24 80 00 	movl   $0x802478,(%esp)
  8000df:	e8 8d 01 00 00       	call   800271 <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000eb:	68 8c 24 80 00       	push   $0x80248c
  8000f0:	68 95 24 80 00       	push   $0x802495
  8000f5:	68 9f 24 80 00       	push   $0x80249f
  8000fa:	68 9e 24 80 00       	push   $0x80249e
  8000ff:	e8 e6 19 00 00       	call   801aea <spawnl>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	85 c0                	test   %eax,%eax
  800109:	79 12                	jns    80011d <umain+0xea>
		panic("icode: spawn /init: %e", r);
  80010b:	50                   	push   %eax
  80010c:	68 a4 24 80 00       	push   $0x8024a4
  800111:	6a 1a                	push   $0x1a
  800113:	68 44 24 80 00       	push   $0x802444
  800118:	e8 7b 00 00 00       	call   800198 <_panic>

	cprintf("icode: exiting\n");
  80011d:	83 ec 0c             	sub    $0xc,%esp
  800120:	68 bb 24 80 00       	push   $0x8024bb
  800125:	e8 47 01 00 00       	call   800271 <cprintf>
}
  80012a:	83 c4 10             	add    $0x10,%esp
  80012d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800130:	5b                   	pop    %ebx
  800131:	5e                   	pop    %esi
  800132:	5d                   	pop    %ebp
  800133:	c3                   	ret    

00800134 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	56                   	push   %esi
  800138:	53                   	push   %ebx
  800139:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80013c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  80013f:	e8 9d 0a 00 00       	call   800be1 <sys_getenvid>
	if (id >= 0)
  800144:	85 c0                	test   %eax,%eax
  800146:	78 12                	js     80015a <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  800148:	25 ff 03 00 00       	and    $0x3ff,%eax
  80014d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800150:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800155:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80015a:	85 db                	test   %ebx,%ebx
  80015c:	7e 07                	jle    800165 <libmain+0x31>
		binaryname = argv[0];
  80015e:	8b 06                	mov    (%esi),%eax
  800160:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800165:	83 ec 08             	sub    $0x8,%esp
  800168:	56                   	push   %esi
  800169:	53                   	push   %ebx
  80016a:	e8 c4 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80016f:	e8 0a 00 00 00       	call   80017e <exit>
}
  800174:	83 c4 10             	add    $0x10,%esp
  800177:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80017a:	5b                   	pop    %ebx
  80017b:	5e                   	pop    %esi
  80017c:	5d                   	pop    %ebp
  80017d:	c3                   	ret    

0080017e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80017e:	55                   	push   %ebp
  80017f:	89 e5                	mov    %esp,%ebp
  800181:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800184:	e8 8b 0d 00 00       	call   800f14 <close_all>
	sys_env_destroy(0);
  800189:	83 ec 0c             	sub    $0xc,%esp
  80018c:	6a 00                	push   $0x0
  80018e:	e8 2c 0a 00 00       	call   800bbf <sys_env_destroy>
}
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	c9                   	leave  
  800197:	c3                   	ret    

00800198 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	56                   	push   %esi
  80019c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80019d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001a0:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001a6:	e8 36 0a 00 00       	call   800be1 <sys_getenvid>
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	ff 75 0c             	pushl  0xc(%ebp)
  8001b1:	ff 75 08             	pushl  0x8(%ebp)
  8001b4:	56                   	push   %esi
  8001b5:	50                   	push   %eax
  8001b6:	68 d8 24 80 00       	push   $0x8024d8
  8001bb:	e8 b1 00 00 00       	call   800271 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001c0:	83 c4 18             	add    $0x18,%esp
  8001c3:	53                   	push   %ebx
  8001c4:	ff 75 10             	pushl  0x10(%ebp)
  8001c7:	e8 54 00 00 00       	call   800220 <vcprintf>
	cprintf("\n");
  8001cc:	c7 04 24 cc 29 80 00 	movl   $0x8029cc,(%esp)
  8001d3:	e8 99 00 00 00       	call   800271 <cprintf>
  8001d8:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001db:	cc                   	int3   
  8001dc:	eb fd                	jmp    8001db <_panic+0x43>

008001de <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	53                   	push   %ebx
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001e8:	8b 13                	mov    (%ebx),%edx
  8001ea:	8d 42 01             	lea    0x1(%edx),%eax
  8001ed:	89 03                	mov    %eax,(%ebx)
  8001ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001f2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001f6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001fb:	75 1a                	jne    800217 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  8001fd:	83 ec 08             	sub    $0x8,%esp
  800200:	68 ff 00 00 00       	push   $0xff
  800205:	8d 43 08             	lea    0x8(%ebx),%eax
  800208:	50                   	push   %eax
  800209:	e8 67 09 00 00       	call   800b75 <sys_cputs>
		b->idx = 0;
  80020e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800214:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  800217:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80021b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80021e:	c9                   	leave  
  80021f:	c3                   	ret    

00800220 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800229:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800230:	00 00 00 
	b.cnt = 0;
  800233:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80023a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80023d:	ff 75 0c             	pushl  0xc(%ebp)
  800240:	ff 75 08             	pushl  0x8(%ebp)
  800243:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800249:	50                   	push   %eax
  80024a:	68 de 01 80 00       	push   $0x8001de
  80024f:	e8 86 01 00 00       	call   8003da <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800254:	83 c4 08             	add    $0x8,%esp
  800257:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80025d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	e8 0c 09 00 00       	call   800b75 <sys_cputs>

	return b.cnt;
}
  800269:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800277:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80027a:	50                   	push   %eax
  80027b:	ff 75 08             	pushl  0x8(%ebp)
  80027e:	e8 9d ff ff ff       	call   800220 <vcprintf>
	va_end(ap);

	return cnt;
}
  800283:	c9                   	leave  
  800284:	c3                   	ret    

00800285 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800285:	55                   	push   %ebp
  800286:	89 e5                	mov    %esp,%ebp
  800288:	57                   	push   %edi
  800289:	56                   	push   %esi
  80028a:	53                   	push   %ebx
  80028b:	83 ec 1c             	sub    $0x1c,%esp
  80028e:	89 c7                	mov    %eax,%edi
  800290:	89 d6                	mov    %edx,%esi
  800292:	8b 45 08             	mov    0x8(%ebp),%eax
  800295:	8b 55 0c             	mov    0xc(%ebp),%edx
  800298:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80029b:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80029e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002a9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002ac:	39 d3                	cmp    %edx,%ebx
  8002ae:	72 05                	jb     8002b5 <printnum+0x30>
  8002b0:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002b3:	77 45                	ja     8002fa <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	ff 75 18             	pushl  0x18(%ebp)
  8002bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8002be:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002c1:	53                   	push   %ebx
  8002c2:	ff 75 10             	pushl  0x10(%ebp)
  8002c5:	83 ec 08             	sub    $0x8,%esp
  8002c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002cb:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ce:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d1:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d4:	e8 97 1e 00 00       	call   802170 <__udivdi3>
  8002d9:	83 c4 18             	add    $0x18,%esp
  8002dc:	52                   	push   %edx
  8002dd:	50                   	push   %eax
  8002de:	89 f2                	mov    %esi,%edx
  8002e0:	89 f8                	mov    %edi,%eax
  8002e2:	e8 9e ff ff ff       	call   800285 <printnum>
  8002e7:	83 c4 20             	add    $0x20,%esp
  8002ea:	eb 18                	jmp    800304 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002ec:	83 ec 08             	sub    $0x8,%esp
  8002ef:	56                   	push   %esi
  8002f0:	ff 75 18             	pushl  0x18(%ebp)
  8002f3:	ff d7                	call   *%edi
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	eb 03                	jmp    8002fd <printnum+0x78>
  8002fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002fd:	83 eb 01             	sub    $0x1,%ebx
  800300:	85 db                	test   %ebx,%ebx
  800302:	7f e8                	jg     8002ec <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800304:	83 ec 08             	sub    $0x8,%esp
  800307:	56                   	push   %esi
  800308:	83 ec 04             	sub    $0x4,%esp
  80030b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030e:	ff 75 e0             	pushl  -0x20(%ebp)
  800311:	ff 75 dc             	pushl  -0x24(%ebp)
  800314:	ff 75 d8             	pushl  -0x28(%ebp)
  800317:	e8 84 1f 00 00       	call   8022a0 <__umoddi3>
  80031c:	83 c4 14             	add    $0x14,%esp
  80031f:	0f be 80 fb 24 80 00 	movsbl 0x8024fb(%eax),%eax
  800326:	50                   	push   %eax
  800327:	ff d7                	call   *%edi
}
  800329:	83 c4 10             	add    $0x10,%esp
  80032c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032f:	5b                   	pop    %ebx
  800330:	5e                   	pop    %esi
  800331:	5f                   	pop    %edi
  800332:	5d                   	pop    %ebp
  800333:	c3                   	ret    

00800334 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800334:	55                   	push   %ebp
  800335:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800337:	83 fa 01             	cmp    $0x1,%edx
  80033a:	7e 0e                	jle    80034a <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80033c:	8b 10                	mov    (%eax),%edx
  80033e:	8d 4a 08             	lea    0x8(%edx),%ecx
  800341:	89 08                	mov    %ecx,(%eax)
  800343:	8b 02                	mov    (%edx),%eax
  800345:	8b 52 04             	mov    0x4(%edx),%edx
  800348:	eb 22                	jmp    80036c <getuint+0x38>
	else if (lflag)
  80034a:	85 d2                	test   %edx,%edx
  80034c:	74 10                	je     80035e <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80034e:	8b 10                	mov    (%eax),%edx
  800350:	8d 4a 04             	lea    0x4(%edx),%ecx
  800353:	89 08                	mov    %ecx,(%eax)
  800355:	8b 02                	mov    (%edx),%eax
  800357:	ba 00 00 00 00       	mov    $0x0,%edx
  80035c:	eb 0e                	jmp    80036c <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80035e:	8b 10                	mov    (%eax),%edx
  800360:	8d 4a 04             	lea    0x4(%edx),%ecx
  800363:	89 08                	mov    %ecx,(%eax)
  800365:	8b 02                	mov    (%edx),%eax
  800367:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80036c:	5d                   	pop    %ebp
  80036d:	c3                   	ret    

0080036e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800371:	83 fa 01             	cmp    $0x1,%edx
  800374:	7e 0e                	jle    800384 <getint+0x16>
		return va_arg(*ap, long long);
  800376:	8b 10                	mov    (%eax),%edx
  800378:	8d 4a 08             	lea    0x8(%edx),%ecx
  80037b:	89 08                	mov    %ecx,(%eax)
  80037d:	8b 02                	mov    (%edx),%eax
  80037f:	8b 52 04             	mov    0x4(%edx),%edx
  800382:	eb 1a                	jmp    80039e <getint+0x30>
	else if (lflag)
  800384:	85 d2                	test   %edx,%edx
  800386:	74 0c                	je     800394 <getint+0x26>
		return va_arg(*ap, long);
  800388:	8b 10                	mov    (%eax),%edx
  80038a:	8d 4a 04             	lea    0x4(%edx),%ecx
  80038d:	89 08                	mov    %ecx,(%eax)
  80038f:	8b 02                	mov    (%edx),%eax
  800391:	99                   	cltd   
  800392:	eb 0a                	jmp    80039e <getint+0x30>
	else
		return va_arg(*ap, int);
  800394:	8b 10                	mov    (%eax),%edx
  800396:	8d 4a 04             	lea    0x4(%edx),%ecx
  800399:	89 08                	mov    %ecx,(%eax)
  80039b:	8b 02                	mov    (%edx),%eax
  80039d:	99                   	cltd   
}
  80039e:	5d                   	pop    %ebp
  80039f:	c3                   	ret    

008003a0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003a6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003aa:	8b 10                	mov    (%eax),%edx
  8003ac:	3b 50 04             	cmp    0x4(%eax),%edx
  8003af:	73 0a                	jae    8003bb <sprintputch+0x1b>
		*b->buf++ = ch;
  8003b1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003b4:	89 08                	mov    %ecx,(%eax)
  8003b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b9:	88 02                	mov    %al,(%edx)
}
  8003bb:	5d                   	pop    %ebp
  8003bc:	c3                   	ret    

008003bd <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8003c3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003c6:	50                   	push   %eax
  8003c7:	ff 75 10             	pushl  0x10(%ebp)
  8003ca:	ff 75 0c             	pushl  0xc(%ebp)
  8003cd:	ff 75 08             	pushl  0x8(%ebp)
  8003d0:	e8 05 00 00 00       	call   8003da <vprintfmt>
	va_end(ap);
}
  8003d5:	83 c4 10             	add    $0x10,%esp
  8003d8:	c9                   	leave  
  8003d9:	c3                   	ret    

008003da <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003da:	55                   	push   %ebp
  8003db:	89 e5                	mov    %esp,%ebp
  8003dd:	57                   	push   %edi
  8003de:	56                   	push   %esi
  8003df:	53                   	push   %ebx
  8003e0:	83 ec 2c             	sub    $0x2c,%esp
  8003e3:	8b 75 08             	mov    0x8(%ebp),%esi
  8003e6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003e9:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003ec:	eb 12                	jmp    800400 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003ee:	85 c0                	test   %eax,%eax
  8003f0:	0f 84 44 03 00 00    	je     80073a <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  8003f6:	83 ec 08             	sub    $0x8,%esp
  8003f9:	53                   	push   %ebx
  8003fa:	50                   	push   %eax
  8003fb:	ff d6                	call   *%esi
  8003fd:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800400:	83 c7 01             	add    $0x1,%edi
  800403:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800407:	83 f8 25             	cmp    $0x25,%eax
  80040a:	75 e2                	jne    8003ee <vprintfmt+0x14>
  80040c:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800410:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800417:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80041e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800425:	ba 00 00 00 00       	mov    $0x0,%edx
  80042a:	eb 07                	jmp    800433 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80042c:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  80042f:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800433:	8d 47 01             	lea    0x1(%edi),%eax
  800436:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800439:	0f b6 07             	movzbl (%edi),%eax
  80043c:	0f b6 c8             	movzbl %al,%ecx
  80043f:	83 e8 23             	sub    $0x23,%eax
  800442:	3c 55                	cmp    $0x55,%al
  800444:	0f 87 d5 02 00 00    	ja     80071f <vprintfmt+0x345>
  80044a:	0f b6 c0             	movzbl %al,%eax
  80044d:	ff 24 85 40 26 80 00 	jmp    *0x802640(,%eax,4)
  800454:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800457:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80045b:	eb d6                	jmp    800433 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80045d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800460:	b8 00 00 00 00       	mov    $0x0,%eax
  800465:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800468:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80046b:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  80046f:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  800472:	8d 51 d0             	lea    -0x30(%ecx),%edx
  800475:	83 fa 09             	cmp    $0x9,%edx
  800478:	77 39                	ja     8004b3 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80047a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80047d:	eb e9                	jmp    800468 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80047f:	8b 45 14             	mov    0x14(%ebp),%eax
  800482:	8d 48 04             	lea    0x4(%eax),%ecx
  800485:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800490:	eb 27                	jmp    8004b9 <vprintfmt+0xdf>
  800492:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800495:	85 c0                	test   %eax,%eax
  800497:	b9 00 00 00 00       	mov    $0x0,%ecx
  80049c:	0f 49 c8             	cmovns %eax,%ecx
  80049f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004a5:	eb 8c                	jmp    800433 <vprintfmt+0x59>
  8004a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004aa:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004b1:	eb 80                	jmp    800433 <vprintfmt+0x59>
  8004b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8004b6:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  8004b9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004bd:	0f 89 70 ff ff ff    	jns    800433 <vprintfmt+0x59>
				width = precision, precision = -1;
  8004c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c9:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004d0:	e9 5e ff ff ff       	jmp    800433 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004d5:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004db:	e9 53 ff ff ff       	jmp    800433 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e3:	8d 50 04             	lea    0x4(%eax),%edx
  8004e6:	89 55 14             	mov    %edx,0x14(%ebp)
  8004e9:	83 ec 08             	sub    $0x8,%esp
  8004ec:	53                   	push   %ebx
  8004ed:	ff 30                	pushl  (%eax)
  8004ef:	ff d6                	call   *%esi
			break;
  8004f1:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  8004f7:	e9 04 ff ff ff       	jmp    800400 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ff:	8d 50 04             	lea    0x4(%eax),%edx
  800502:	89 55 14             	mov    %edx,0x14(%ebp)
  800505:	8b 00                	mov    (%eax),%eax
  800507:	99                   	cltd   
  800508:	31 d0                	xor    %edx,%eax
  80050a:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80050c:	83 f8 0f             	cmp    $0xf,%eax
  80050f:	7f 0b                	jg     80051c <vprintfmt+0x142>
  800511:	8b 14 85 a0 27 80 00 	mov    0x8027a0(,%eax,4),%edx
  800518:	85 d2                	test   %edx,%edx
  80051a:	75 18                	jne    800534 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  80051c:	50                   	push   %eax
  80051d:	68 13 25 80 00       	push   $0x802513
  800522:	53                   	push   %ebx
  800523:	56                   	push   %esi
  800524:	e8 94 fe ff ff       	call   8003bd <printfmt>
  800529:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80052f:	e9 cc fe ff ff       	jmp    800400 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  800534:	52                   	push   %edx
  800535:	68 d1 28 80 00       	push   $0x8028d1
  80053a:	53                   	push   %ebx
  80053b:	56                   	push   %esi
  80053c:	e8 7c fe ff ff       	call   8003bd <printfmt>
  800541:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800544:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800547:	e9 b4 fe ff ff       	jmp    800400 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80054c:	8b 45 14             	mov    0x14(%ebp),%eax
  80054f:	8d 50 04             	lea    0x4(%eax),%edx
  800552:	89 55 14             	mov    %edx,0x14(%ebp)
  800555:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800557:	85 ff                	test   %edi,%edi
  800559:	b8 0c 25 80 00       	mov    $0x80250c,%eax
  80055e:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800561:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800565:	0f 8e 94 00 00 00    	jle    8005ff <vprintfmt+0x225>
  80056b:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80056f:	0f 84 98 00 00 00    	je     80060d <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  800575:	83 ec 08             	sub    $0x8,%esp
  800578:	ff 75 d0             	pushl  -0x30(%ebp)
  80057b:	57                   	push   %edi
  80057c:	e8 41 02 00 00       	call   8007c2 <strnlen>
  800581:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800584:	29 c1                	sub    %eax,%ecx
  800586:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800589:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80058c:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800590:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800593:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800596:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800598:	eb 0f                	jmp    8005a9 <vprintfmt+0x1cf>
					putch(padc, putdat);
  80059a:	83 ec 08             	sub    $0x8,%esp
  80059d:	53                   	push   %ebx
  80059e:	ff 75 e0             	pushl  -0x20(%ebp)
  8005a1:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a3:	83 ef 01             	sub    $0x1,%edi
  8005a6:	83 c4 10             	add    $0x10,%esp
  8005a9:	85 ff                	test   %edi,%edi
  8005ab:	7f ed                	jg     80059a <vprintfmt+0x1c0>
  8005ad:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005b0:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8005b3:	85 c9                	test   %ecx,%ecx
  8005b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ba:	0f 49 c1             	cmovns %ecx,%eax
  8005bd:	29 c1                	sub    %eax,%ecx
  8005bf:	89 75 08             	mov    %esi,0x8(%ebp)
  8005c2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005c5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005c8:	89 cb                	mov    %ecx,%ebx
  8005ca:	eb 4d                	jmp    800619 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005cc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005d0:	74 1b                	je     8005ed <vprintfmt+0x213>
  8005d2:	0f be c0             	movsbl %al,%eax
  8005d5:	83 e8 20             	sub    $0x20,%eax
  8005d8:	83 f8 5e             	cmp    $0x5e,%eax
  8005db:	76 10                	jbe    8005ed <vprintfmt+0x213>
					putch('?', putdat);
  8005dd:	83 ec 08             	sub    $0x8,%esp
  8005e0:	ff 75 0c             	pushl  0xc(%ebp)
  8005e3:	6a 3f                	push   $0x3f
  8005e5:	ff 55 08             	call   *0x8(%ebp)
  8005e8:	83 c4 10             	add    $0x10,%esp
  8005eb:	eb 0d                	jmp    8005fa <vprintfmt+0x220>
				else
					putch(ch, putdat);
  8005ed:	83 ec 08             	sub    $0x8,%esp
  8005f0:	ff 75 0c             	pushl  0xc(%ebp)
  8005f3:	52                   	push   %edx
  8005f4:	ff 55 08             	call   *0x8(%ebp)
  8005f7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005fa:	83 eb 01             	sub    $0x1,%ebx
  8005fd:	eb 1a                	jmp    800619 <vprintfmt+0x23f>
  8005ff:	89 75 08             	mov    %esi,0x8(%ebp)
  800602:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800605:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800608:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80060b:	eb 0c                	jmp    800619 <vprintfmt+0x23f>
  80060d:	89 75 08             	mov    %esi,0x8(%ebp)
  800610:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800613:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800616:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800619:	83 c7 01             	add    $0x1,%edi
  80061c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800620:	0f be d0             	movsbl %al,%edx
  800623:	85 d2                	test   %edx,%edx
  800625:	74 23                	je     80064a <vprintfmt+0x270>
  800627:	85 f6                	test   %esi,%esi
  800629:	78 a1                	js     8005cc <vprintfmt+0x1f2>
  80062b:	83 ee 01             	sub    $0x1,%esi
  80062e:	79 9c                	jns    8005cc <vprintfmt+0x1f2>
  800630:	89 df                	mov    %ebx,%edi
  800632:	8b 75 08             	mov    0x8(%ebp),%esi
  800635:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800638:	eb 18                	jmp    800652 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80063a:	83 ec 08             	sub    $0x8,%esp
  80063d:	53                   	push   %ebx
  80063e:	6a 20                	push   $0x20
  800640:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800642:	83 ef 01             	sub    $0x1,%edi
  800645:	83 c4 10             	add    $0x10,%esp
  800648:	eb 08                	jmp    800652 <vprintfmt+0x278>
  80064a:	89 df                	mov    %ebx,%edi
  80064c:	8b 75 08             	mov    0x8(%ebp),%esi
  80064f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800652:	85 ff                	test   %edi,%edi
  800654:	7f e4                	jg     80063a <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800656:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800659:	e9 a2 fd ff ff       	jmp    800400 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80065e:	8d 45 14             	lea    0x14(%ebp),%eax
  800661:	e8 08 fd ff ff       	call   80036e <getint>
  800666:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800669:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80066c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800671:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800675:	79 74                	jns    8006eb <vprintfmt+0x311>
				putch('-', putdat);
  800677:	83 ec 08             	sub    $0x8,%esp
  80067a:	53                   	push   %ebx
  80067b:	6a 2d                	push   $0x2d
  80067d:	ff d6                	call   *%esi
				num = -(long long) num;
  80067f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800682:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800685:	f7 d8                	neg    %eax
  800687:	83 d2 00             	adc    $0x0,%edx
  80068a:	f7 da                	neg    %edx
  80068c:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  80068f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800694:	eb 55                	jmp    8006eb <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800696:	8d 45 14             	lea    0x14(%ebp),%eax
  800699:	e8 96 fc ff ff       	call   800334 <getuint>
			base = 10;
  80069e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006a3:	eb 46                	jmp    8006eb <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8006a5:	8d 45 14             	lea    0x14(%ebp),%eax
  8006a8:	e8 87 fc ff ff       	call   800334 <getuint>
			base = 8;
  8006ad:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8006b2:	eb 37                	jmp    8006eb <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	53                   	push   %ebx
  8006b8:	6a 30                	push   $0x30
  8006ba:	ff d6                	call   *%esi
			putch('x', putdat);
  8006bc:	83 c4 08             	add    $0x8,%esp
  8006bf:	53                   	push   %ebx
  8006c0:	6a 78                	push   $0x78
  8006c2:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8d 50 04             	lea    0x4(%eax),%edx
  8006ca:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006cd:	8b 00                	mov    (%eax),%eax
  8006cf:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8006d4:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8006d7:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8006dc:	eb 0d                	jmp    8006eb <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006de:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e1:	e8 4e fc ff ff       	call   800334 <getuint>
			base = 16;
  8006e6:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006eb:	83 ec 0c             	sub    $0xc,%esp
  8006ee:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006f2:	57                   	push   %edi
  8006f3:	ff 75 e0             	pushl  -0x20(%ebp)
  8006f6:	51                   	push   %ecx
  8006f7:	52                   	push   %edx
  8006f8:	50                   	push   %eax
  8006f9:	89 da                	mov    %ebx,%edx
  8006fb:	89 f0                	mov    %esi,%eax
  8006fd:	e8 83 fb ff ff       	call   800285 <printnum>
			break;
  800702:	83 c4 20             	add    $0x20,%esp
  800705:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800708:	e9 f3 fc ff ff       	jmp    800400 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80070d:	83 ec 08             	sub    $0x8,%esp
  800710:	53                   	push   %ebx
  800711:	51                   	push   %ecx
  800712:	ff d6                	call   *%esi
			break;
  800714:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800717:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  80071a:	e9 e1 fc ff ff       	jmp    800400 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80071f:	83 ec 08             	sub    $0x8,%esp
  800722:	53                   	push   %ebx
  800723:	6a 25                	push   $0x25
  800725:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800727:	83 c4 10             	add    $0x10,%esp
  80072a:	eb 03                	jmp    80072f <vprintfmt+0x355>
  80072c:	83 ef 01             	sub    $0x1,%edi
  80072f:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  800733:	75 f7                	jne    80072c <vprintfmt+0x352>
  800735:	e9 c6 fc ff ff       	jmp    800400 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  80073a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80073d:	5b                   	pop    %ebx
  80073e:	5e                   	pop    %esi
  80073f:	5f                   	pop    %edi
  800740:	5d                   	pop    %ebp
  800741:	c3                   	ret    

00800742 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800742:	55                   	push   %ebp
  800743:	89 e5                	mov    %esp,%ebp
  800745:	83 ec 18             	sub    $0x18,%esp
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80074e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800751:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800755:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800758:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80075f:	85 c0                	test   %eax,%eax
  800761:	74 26                	je     800789 <vsnprintf+0x47>
  800763:	85 d2                	test   %edx,%edx
  800765:	7e 22                	jle    800789 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800767:	ff 75 14             	pushl  0x14(%ebp)
  80076a:	ff 75 10             	pushl  0x10(%ebp)
  80076d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800770:	50                   	push   %eax
  800771:	68 a0 03 80 00       	push   $0x8003a0
  800776:	e8 5f fc ff ff       	call   8003da <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80077b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80077e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800784:	83 c4 10             	add    $0x10,%esp
  800787:	eb 05                	jmp    80078e <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800789:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80078e:	c9                   	leave  
  80078f:	c3                   	ret    

00800790 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800796:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800799:	50                   	push   %eax
  80079a:	ff 75 10             	pushl  0x10(%ebp)
  80079d:	ff 75 0c             	pushl  0xc(%ebp)
  8007a0:	ff 75 08             	pushl  0x8(%ebp)
  8007a3:	e8 9a ff ff ff       	call   800742 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007a8:	c9                   	leave  
  8007a9:	c3                   	ret    

008007aa <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007aa:	55                   	push   %ebp
  8007ab:	89 e5                	mov    %esp,%ebp
  8007ad:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b5:	eb 03                	jmp    8007ba <strlen+0x10>
		n++;
  8007b7:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007ba:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007be:	75 f7                	jne    8007b7 <strlen+0xd>
		n++;
	return n;
}
  8007c0:	5d                   	pop    %ebp
  8007c1:	c3                   	ret    

008007c2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007c2:	55                   	push   %ebp
  8007c3:	89 e5                	mov    %esp,%ebp
  8007c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007c8:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d0:	eb 03                	jmp    8007d5 <strnlen+0x13>
		n++;
  8007d2:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007d5:	39 c2                	cmp    %eax,%edx
  8007d7:	74 08                	je     8007e1 <strnlen+0x1f>
  8007d9:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8007dd:	75 f3                	jne    8007d2 <strnlen+0x10>
  8007df:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  8007e1:	5d                   	pop    %ebp
  8007e2:	c3                   	ret    

008007e3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007e3:	55                   	push   %ebp
  8007e4:	89 e5                	mov    %esp,%ebp
  8007e6:	53                   	push   %ebx
  8007e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007ed:	89 c2                	mov    %eax,%edx
  8007ef:	83 c2 01             	add    $0x1,%edx
  8007f2:	83 c1 01             	add    $0x1,%ecx
  8007f5:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007f9:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007fc:	84 db                	test   %bl,%bl
  8007fe:	75 ef                	jne    8007ef <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800800:	5b                   	pop    %ebx
  800801:	5d                   	pop    %ebp
  800802:	c3                   	ret    

00800803 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	53                   	push   %ebx
  800807:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80080a:	53                   	push   %ebx
  80080b:	e8 9a ff ff ff       	call   8007aa <strlen>
  800810:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800813:	ff 75 0c             	pushl  0xc(%ebp)
  800816:	01 d8                	add    %ebx,%eax
  800818:	50                   	push   %eax
  800819:	e8 c5 ff ff ff       	call   8007e3 <strcpy>
	return dst;
}
  80081e:	89 d8                	mov    %ebx,%eax
  800820:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800823:	c9                   	leave  
  800824:	c3                   	ret    

00800825 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800825:	55                   	push   %ebp
  800826:	89 e5                	mov    %esp,%ebp
  800828:	56                   	push   %esi
  800829:	53                   	push   %ebx
  80082a:	8b 75 08             	mov    0x8(%ebp),%esi
  80082d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800830:	89 f3                	mov    %esi,%ebx
  800832:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800835:	89 f2                	mov    %esi,%edx
  800837:	eb 0f                	jmp    800848 <strncpy+0x23>
		*dst++ = *src;
  800839:	83 c2 01             	add    $0x1,%edx
  80083c:	0f b6 01             	movzbl (%ecx),%eax
  80083f:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800842:	80 39 01             	cmpb   $0x1,(%ecx)
  800845:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800848:	39 da                	cmp    %ebx,%edx
  80084a:	75 ed                	jne    800839 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80084c:	89 f0                	mov    %esi,%eax
  80084e:	5b                   	pop    %ebx
  80084f:	5e                   	pop    %esi
  800850:	5d                   	pop    %ebp
  800851:	c3                   	ret    

00800852 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	56                   	push   %esi
  800856:	53                   	push   %ebx
  800857:	8b 75 08             	mov    0x8(%ebp),%esi
  80085a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80085d:	8b 55 10             	mov    0x10(%ebp),%edx
  800860:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800862:	85 d2                	test   %edx,%edx
  800864:	74 21                	je     800887 <strlcpy+0x35>
  800866:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80086a:	89 f2                	mov    %esi,%edx
  80086c:	eb 09                	jmp    800877 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80086e:	83 c2 01             	add    $0x1,%edx
  800871:	83 c1 01             	add    $0x1,%ecx
  800874:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800877:	39 c2                	cmp    %eax,%edx
  800879:	74 09                	je     800884 <strlcpy+0x32>
  80087b:	0f b6 19             	movzbl (%ecx),%ebx
  80087e:	84 db                	test   %bl,%bl
  800880:	75 ec                	jne    80086e <strlcpy+0x1c>
  800882:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  800884:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800887:	29 f0                	sub    %esi,%eax
}
  800889:	5b                   	pop    %ebx
  80088a:	5e                   	pop    %esi
  80088b:	5d                   	pop    %ebp
  80088c:	c3                   	ret    

0080088d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80088d:	55                   	push   %ebp
  80088e:	89 e5                	mov    %esp,%ebp
  800890:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800893:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800896:	eb 06                	jmp    80089e <strcmp+0x11>
		p++, q++;
  800898:	83 c1 01             	add    $0x1,%ecx
  80089b:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80089e:	0f b6 01             	movzbl (%ecx),%eax
  8008a1:	84 c0                	test   %al,%al
  8008a3:	74 04                	je     8008a9 <strcmp+0x1c>
  8008a5:	3a 02                	cmp    (%edx),%al
  8008a7:	74 ef                	je     800898 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008a9:	0f b6 c0             	movzbl %al,%eax
  8008ac:	0f b6 12             	movzbl (%edx),%edx
  8008af:	29 d0                	sub    %edx,%eax
}
  8008b1:	5d                   	pop    %ebp
  8008b2:	c3                   	ret    

008008b3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	53                   	push   %ebx
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bd:	89 c3                	mov    %eax,%ebx
  8008bf:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008c2:	eb 06                	jmp    8008ca <strncmp+0x17>
		n--, p++, q++;
  8008c4:	83 c0 01             	add    $0x1,%eax
  8008c7:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008ca:	39 d8                	cmp    %ebx,%eax
  8008cc:	74 15                	je     8008e3 <strncmp+0x30>
  8008ce:	0f b6 08             	movzbl (%eax),%ecx
  8008d1:	84 c9                	test   %cl,%cl
  8008d3:	74 04                	je     8008d9 <strncmp+0x26>
  8008d5:	3a 0a                	cmp    (%edx),%cl
  8008d7:	74 eb                	je     8008c4 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008d9:	0f b6 00             	movzbl (%eax),%eax
  8008dc:	0f b6 12             	movzbl (%edx),%edx
  8008df:	29 d0                	sub    %edx,%eax
  8008e1:	eb 05                	jmp    8008e8 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8008e3:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008e8:	5b                   	pop    %ebx
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008f5:	eb 07                	jmp    8008fe <strchr+0x13>
		if (*s == c)
  8008f7:	38 ca                	cmp    %cl,%dl
  8008f9:	74 0f                	je     80090a <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008fb:	83 c0 01             	add    $0x1,%eax
  8008fe:	0f b6 10             	movzbl (%eax),%edx
  800901:	84 d2                	test   %dl,%dl
  800903:	75 f2                	jne    8008f7 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800905:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80090a:	5d                   	pop    %ebp
  80090b:	c3                   	ret    

0080090c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800916:	eb 03                	jmp    80091b <strfind+0xf>
  800918:	83 c0 01             	add    $0x1,%eax
  80091b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80091e:	38 ca                	cmp    %cl,%dl
  800920:	74 04                	je     800926 <strfind+0x1a>
  800922:	84 d2                	test   %dl,%dl
  800924:	75 f2                	jne    800918 <strfind+0xc>
			break;
	return (char *) s;
}
  800926:	5d                   	pop    %ebp
  800927:	c3                   	ret    

00800928 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	57                   	push   %edi
  80092c:	56                   	push   %esi
  80092d:	53                   	push   %ebx
  80092e:	8b 55 08             	mov    0x8(%ebp),%edx
  800931:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800934:	85 c9                	test   %ecx,%ecx
  800936:	74 37                	je     80096f <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800938:	f6 c2 03             	test   $0x3,%dl
  80093b:	75 2a                	jne    800967 <memset+0x3f>
  80093d:	f6 c1 03             	test   $0x3,%cl
  800940:	75 25                	jne    800967 <memset+0x3f>
		c &= 0xFF;
  800942:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800946:	89 df                	mov    %ebx,%edi
  800948:	c1 e7 08             	shl    $0x8,%edi
  80094b:	89 de                	mov    %ebx,%esi
  80094d:	c1 e6 18             	shl    $0x18,%esi
  800950:	89 d8                	mov    %ebx,%eax
  800952:	c1 e0 10             	shl    $0x10,%eax
  800955:	09 f0                	or     %esi,%eax
  800957:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800959:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80095c:	89 f8                	mov    %edi,%eax
  80095e:	09 d8                	or     %ebx,%eax
  800960:	89 d7                	mov    %edx,%edi
  800962:	fc                   	cld    
  800963:	f3 ab                	rep stos %eax,%es:(%edi)
  800965:	eb 08                	jmp    80096f <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800967:	89 d7                	mov    %edx,%edi
  800969:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096c:	fc                   	cld    
  80096d:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  80096f:	89 d0                	mov    %edx,%eax
  800971:	5b                   	pop    %ebx
  800972:	5e                   	pop    %esi
  800973:	5f                   	pop    %edi
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	57                   	push   %edi
  80097a:	56                   	push   %esi
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800981:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800984:	39 c6                	cmp    %eax,%esi
  800986:	73 35                	jae    8009bd <memmove+0x47>
  800988:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80098b:	39 d0                	cmp    %edx,%eax
  80098d:	73 2e                	jae    8009bd <memmove+0x47>
		s += n;
		d += n;
  80098f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800992:	89 d6                	mov    %edx,%esi
  800994:	09 fe                	or     %edi,%esi
  800996:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80099c:	75 13                	jne    8009b1 <memmove+0x3b>
  80099e:	f6 c1 03             	test   $0x3,%cl
  8009a1:	75 0e                	jne    8009b1 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  8009a3:	83 ef 04             	sub    $0x4,%edi
  8009a6:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009a9:	c1 e9 02             	shr    $0x2,%ecx
  8009ac:	fd                   	std    
  8009ad:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009af:	eb 09                	jmp    8009ba <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009b1:	83 ef 01             	sub    $0x1,%edi
  8009b4:	8d 72 ff             	lea    -0x1(%edx),%esi
  8009b7:	fd                   	std    
  8009b8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009ba:	fc                   	cld    
  8009bb:	eb 1d                	jmp    8009da <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009bd:	89 f2                	mov    %esi,%edx
  8009bf:	09 c2                	or     %eax,%edx
  8009c1:	f6 c2 03             	test   $0x3,%dl
  8009c4:	75 0f                	jne    8009d5 <memmove+0x5f>
  8009c6:	f6 c1 03             	test   $0x3,%cl
  8009c9:	75 0a                	jne    8009d5 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  8009cb:	c1 e9 02             	shr    $0x2,%ecx
  8009ce:	89 c7                	mov    %eax,%edi
  8009d0:	fc                   	cld    
  8009d1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009d3:	eb 05                	jmp    8009da <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009d5:	89 c7                	mov    %eax,%edi
  8009d7:	fc                   	cld    
  8009d8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009da:	5e                   	pop    %esi
  8009db:	5f                   	pop    %edi
  8009dc:	5d                   	pop    %ebp
  8009dd:	c3                   	ret    

008009de <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009de:	55                   	push   %ebp
  8009df:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009e1:	ff 75 10             	pushl  0x10(%ebp)
  8009e4:	ff 75 0c             	pushl  0xc(%ebp)
  8009e7:	ff 75 08             	pushl  0x8(%ebp)
  8009ea:	e8 87 ff ff ff       	call   800976 <memmove>
}
  8009ef:	c9                   	leave  
  8009f0:	c3                   	ret    

008009f1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009f1:	55                   	push   %ebp
  8009f2:	89 e5                	mov    %esp,%ebp
  8009f4:	56                   	push   %esi
  8009f5:	53                   	push   %ebx
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009fc:	89 c6                	mov    %eax,%esi
  8009fe:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a01:	eb 1a                	jmp    800a1d <memcmp+0x2c>
		if (*s1 != *s2)
  800a03:	0f b6 08             	movzbl (%eax),%ecx
  800a06:	0f b6 1a             	movzbl (%edx),%ebx
  800a09:	38 d9                	cmp    %bl,%cl
  800a0b:	74 0a                	je     800a17 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a0d:	0f b6 c1             	movzbl %cl,%eax
  800a10:	0f b6 db             	movzbl %bl,%ebx
  800a13:	29 d8                	sub    %ebx,%eax
  800a15:	eb 0f                	jmp    800a26 <memcmp+0x35>
		s1++, s2++;
  800a17:	83 c0 01             	add    $0x1,%eax
  800a1a:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a1d:	39 f0                	cmp    %esi,%eax
  800a1f:	75 e2                	jne    800a03 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a26:	5b                   	pop    %ebx
  800a27:	5e                   	pop    %esi
  800a28:	5d                   	pop    %ebp
  800a29:	c3                   	ret    

00800a2a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	53                   	push   %ebx
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800a31:	89 c1                	mov    %eax,%ecx
  800a33:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  800a36:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a3a:	eb 0a                	jmp    800a46 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a3c:	0f b6 10             	movzbl (%eax),%edx
  800a3f:	39 da                	cmp    %ebx,%edx
  800a41:	74 07                	je     800a4a <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a43:	83 c0 01             	add    $0x1,%eax
  800a46:	39 c8                	cmp    %ecx,%eax
  800a48:	72 f2                	jb     800a3c <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a4a:	5b                   	pop    %ebx
  800a4b:	5d                   	pop    %ebp
  800a4c:	c3                   	ret    

00800a4d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	57                   	push   %edi
  800a51:	56                   	push   %esi
  800a52:	53                   	push   %ebx
  800a53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a56:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a59:	eb 03                	jmp    800a5e <strtol+0x11>
		s++;
  800a5b:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a5e:	0f b6 01             	movzbl (%ecx),%eax
  800a61:	3c 20                	cmp    $0x20,%al
  800a63:	74 f6                	je     800a5b <strtol+0xe>
  800a65:	3c 09                	cmp    $0x9,%al
  800a67:	74 f2                	je     800a5b <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a69:	3c 2b                	cmp    $0x2b,%al
  800a6b:	75 0a                	jne    800a77 <strtol+0x2a>
		s++;
  800a6d:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a70:	bf 00 00 00 00       	mov    $0x0,%edi
  800a75:	eb 11                	jmp    800a88 <strtol+0x3b>
  800a77:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800a7c:	3c 2d                	cmp    $0x2d,%al
  800a7e:	75 08                	jne    800a88 <strtol+0x3b>
		s++, neg = 1;
  800a80:	83 c1 01             	add    $0x1,%ecx
  800a83:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a88:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a8e:	75 15                	jne    800aa5 <strtol+0x58>
  800a90:	80 39 30             	cmpb   $0x30,(%ecx)
  800a93:	75 10                	jne    800aa5 <strtol+0x58>
  800a95:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a99:	75 7c                	jne    800b17 <strtol+0xca>
		s += 2, base = 16;
  800a9b:	83 c1 02             	add    $0x2,%ecx
  800a9e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aa3:	eb 16                	jmp    800abb <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800aa5:	85 db                	test   %ebx,%ebx
  800aa7:	75 12                	jne    800abb <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aa9:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800aae:	80 39 30             	cmpb   $0x30,(%ecx)
  800ab1:	75 08                	jne    800abb <strtol+0x6e>
		s++, base = 8;
  800ab3:	83 c1 01             	add    $0x1,%ecx
  800ab6:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800abb:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac0:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ac3:	0f b6 11             	movzbl (%ecx),%edx
  800ac6:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ac9:	89 f3                	mov    %esi,%ebx
  800acb:	80 fb 09             	cmp    $0x9,%bl
  800ace:	77 08                	ja     800ad8 <strtol+0x8b>
			dig = *s - '0';
  800ad0:	0f be d2             	movsbl %dl,%edx
  800ad3:	83 ea 30             	sub    $0x30,%edx
  800ad6:	eb 22                	jmp    800afa <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800ad8:	8d 72 9f             	lea    -0x61(%edx),%esi
  800adb:	89 f3                	mov    %esi,%ebx
  800add:	80 fb 19             	cmp    $0x19,%bl
  800ae0:	77 08                	ja     800aea <strtol+0x9d>
			dig = *s - 'a' + 10;
  800ae2:	0f be d2             	movsbl %dl,%edx
  800ae5:	83 ea 57             	sub    $0x57,%edx
  800ae8:	eb 10                	jmp    800afa <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800aea:	8d 72 bf             	lea    -0x41(%edx),%esi
  800aed:	89 f3                	mov    %esi,%ebx
  800aef:	80 fb 19             	cmp    $0x19,%bl
  800af2:	77 16                	ja     800b0a <strtol+0xbd>
			dig = *s - 'A' + 10;
  800af4:	0f be d2             	movsbl %dl,%edx
  800af7:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800afa:	3b 55 10             	cmp    0x10(%ebp),%edx
  800afd:	7d 0b                	jge    800b0a <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800aff:	83 c1 01             	add    $0x1,%ecx
  800b02:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b06:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800b08:	eb b9                	jmp    800ac3 <strtol+0x76>

	if (endptr)
  800b0a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0e:	74 0d                	je     800b1d <strtol+0xd0>
		*endptr = (char *) s;
  800b10:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b13:	89 0e                	mov    %ecx,(%esi)
  800b15:	eb 06                	jmp    800b1d <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b17:	85 db                	test   %ebx,%ebx
  800b19:	74 98                	je     800ab3 <strtol+0x66>
  800b1b:	eb 9e                	jmp    800abb <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800b1d:	89 c2                	mov    %eax,%edx
  800b1f:	f7 da                	neg    %edx
  800b21:	85 ff                	test   %edi,%edi
  800b23:	0f 45 c2             	cmovne %edx,%eax
}
  800b26:	5b                   	pop    %ebx
  800b27:	5e                   	pop    %esi
  800b28:	5f                   	pop    %edi
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	57                   	push   %edi
  800b2f:	56                   	push   %esi
  800b30:	53                   	push   %ebx
  800b31:	83 ec 1c             	sub    $0x1c,%esp
  800b34:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b37:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b3a:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b3f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b42:	8b 7d 10             	mov    0x10(%ebp),%edi
  800b45:	8b 75 14             	mov    0x14(%ebp),%esi
  800b48:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800b4a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b4e:	74 1d                	je     800b6d <syscall+0x42>
  800b50:	85 c0                	test   %eax,%eax
  800b52:	7e 19                	jle    800b6d <syscall+0x42>
  800b54:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800b57:	83 ec 0c             	sub    $0xc,%esp
  800b5a:	50                   	push   %eax
  800b5b:	52                   	push   %edx
  800b5c:	68 ff 27 80 00       	push   $0x8027ff
  800b61:	6a 23                	push   $0x23
  800b63:	68 1c 28 80 00       	push   $0x80281c
  800b68:	e8 2b f6 ff ff       	call   800198 <_panic>

	return ret;
}
  800b6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b70:	5b                   	pop    %ebx
  800b71:	5e                   	pop    %esi
  800b72:	5f                   	pop    %edi
  800b73:	5d                   	pop    %ebp
  800b74:	c3                   	ret    

00800b75 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800b7b:	6a 00                	push   $0x0
  800b7d:	6a 00                	push   $0x0
  800b7f:	6a 00                	push   $0x0
  800b81:	ff 75 0c             	pushl  0xc(%ebp)
  800b84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b87:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b91:	e8 95 ff ff ff       	call   800b2b <syscall>
}
  800b96:	83 c4 10             	add    $0x10,%esp
  800b99:	c9                   	leave  
  800b9a:	c3                   	ret    

00800b9b <sys_cgetc>:

int
sys_cgetc(void)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800ba1:	6a 00                	push   $0x0
  800ba3:	6a 00                	push   $0x0
  800ba5:	6a 00                	push   $0x0
  800ba7:	6a 00                	push   $0x0
  800ba9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bae:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb3:	b8 01 00 00 00       	mov    $0x1,%eax
  800bb8:	e8 6e ff ff ff       	call   800b2b <syscall>
}
  800bbd:	c9                   	leave  
  800bbe:	c3                   	ret    

00800bbf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800bc5:	6a 00                	push   $0x0
  800bc7:	6a 00                	push   $0x0
  800bc9:	6a 00                	push   $0x0
  800bcb:	6a 00                	push   $0x0
  800bcd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd0:	ba 01 00 00 00       	mov    $0x1,%edx
  800bd5:	b8 03 00 00 00       	mov    $0x3,%eax
  800bda:	e8 4c ff ff ff       	call   800b2b <syscall>
}
  800bdf:	c9                   	leave  
  800be0:	c3                   	ret    

00800be1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800be7:	6a 00                	push   $0x0
  800be9:	6a 00                	push   $0x0
  800beb:	6a 00                	push   $0x0
  800bed:	6a 00                	push   $0x0
  800bef:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bf4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf9:	b8 02 00 00 00       	mov    $0x2,%eax
  800bfe:	e8 28 ff ff ff       	call   800b2b <syscall>
}
  800c03:	c9                   	leave  
  800c04:	c3                   	ret    

00800c05 <sys_yield>:

void
sys_yield(void)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800c0b:	6a 00                	push   $0x0
  800c0d:	6a 00                	push   $0x0
  800c0f:	6a 00                	push   $0x0
  800c11:	6a 00                	push   $0x0
  800c13:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c18:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c22:	e8 04 ff ff ff       	call   800b2b <syscall>
}
  800c27:	83 c4 10             	add    $0x10,%esp
  800c2a:	c9                   	leave  
  800c2b:	c3                   	ret    

00800c2c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800c32:	6a 00                	push   $0x0
  800c34:	6a 00                	push   $0x0
  800c36:	ff 75 10             	pushl  0x10(%ebp)
  800c39:	ff 75 0c             	pushl  0xc(%ebp)
  800c3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c3f:	ba 01 00 00 00       	mov    $0x1,%edx
  800c44:	b8 04 00 00 00       	mov    $0x4,%eax
  800c49:	e8 dd fe ff ff       	call   800b2b <syscall>
}
  800c4e:	c9                   	leave  
  800c4f:	c3                   	ret    

00800c50 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800c56:	ff 75 18             	pushl  0x18(%ebp)
  800c59:	ff 75 14             	pushl  0x14(%ebp)
  800c5c:	ff 75 10             	pushl  0x10(%ebp)
  800c5f:	ff 75 0c             	pushl  0xc(%ebp)
  800c62:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c65:	ba 01 00 00 00       	mov    $0x1,%edx
  800c6a:	b8 05 00 00 00       	mov    $0x5,%eax
  800c6f:	e8 b7 fe ff ff       	call   800b2b <syscall>
}
  800c74:	c9                   	leave  
  800c75:	c3                   	ret    

00800c76 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800c7c:	6a 00                	push   $0x0
  800c7e:	6a 00                	push   $0x0
  800c80:	6a 00                	push   $0x0
  800c82:	ff 75 0c             	pushl  0xc(%ebp)
  800c85:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c88:	ba 01 00 00 00       	mov    $0x1,%edx
  800c8d:	b8 06 00 00 00       	mov    $0x6,%eax
  800c92:	e8 94 fe ff ff       	call   800b2b <syscall>
}
  800c97:	c9                   	leave  
  800c98:	c3                   	ret    

00800c99 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c9f:	6a 00                	push   $0x0
  800ca1:	6a 00                	push   $0x0
  800ca3:	6a 00                	push   $0x0
  800ca5:	ff 75 0c             	pushl  0xc(%ebp)
  800ca8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cab:	ba 01 00 00 00       	mov    $0x1,%edx
  800cb0:	b8 08 00 00 00       	mov    $0x8,%eax
  800cb5:	e8 71 fe ff ff       	call   800b2b <syscall>
}
  800cba:	c9                   	leave  
  800cbb:	c3                   	ret    

00800cbc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800cc2:	6a 00                	push   $0x0
  800cc4:	6a 00                	push   $0x0
  800cc6:	6a 00                	push   $0x0
  800cc8:	ff 75 0c             	pushl  0xc(%ebp)
  800ccb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cce:	ba 01 00 00 00       	mov    $0x1,%edx
  800cd3:	b8 09 00 00 00       	mov    $0x9,%eax
  800cd8:	e8 4e fe ff ff       	call   800b2b <syscall>
}
  800cdd:	c9                   	leave  
  800cde:	c3                   	ret    

00800cdf <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800ce5:	6a 00                	push   $0x0
  800ce7:	6a 00                	push   $0x0
  800ce9:	6a 00                	push   $0x0
  800ceb:	ff 75 0c             	pushl  0xc(%ebp)
  800cee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cf1:	ba 01 00 00 00       	mov    $0x1,%edx
  800cf6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cfb:	e8 2b fe ff ff       	call   800b2b <syscall>
}
  800d00:	c9                   	leave  
  800d01:	c3                   	ret    

00800d02 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800d08:	6a 00                	push   $0x0
  800d0a:	ff 75 14             	pushl  0x14(%ebp)
  800d0d:	ff 75 10             	pushl  0x10(%ebp)
  800d10:	ff 75 0c             	pushl  0xc(%ebp)
  800d13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d16:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1b:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d20:	e8 06 fe ff ff       	call   800b2b <syscall>
}
  800d25:	c9                   	leave  
  800d26:	c3                   	ret    

00800d27 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800d2d:	6a 00                	push   $0x0
  800d2f:	6a 00                	push   $0x0
  800d31:	6a 00                	push   $0x0
  800d33:	6a 00                	push   $0x0
  800d35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d38:	ba 01 00 00 00       	mov    $0x1,%edx
  800d3d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d42:	e8 e4 fd ff ff       	call   800b2b <syscall>
}
  800d47:	c9                   	leave  
  800d48:	c3                   	ret    

00800d49 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	05 00 00 00 30       	add    $0x30000000,%eax
  800d54:	c1 e8 0c             	shr    $0xc,%eax
}
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    

00800d59 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  800d5c:	ff 75 08             	pushl  0x8(%ebp)
  800d5f:	e8 e5 ff ff ff       	call   800d49 <fd2num>
  800d64:	83 c4 04             	add    $0x4,%esp
  800d67:	c1 e0 0c             	shl    $0xc,%eax
  800d6a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800d6f:	c9                   	leave  
  800d70:	c3                   	ret    

00800d71 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
  800d74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d77:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800d7c:	89 c2                	mov    %eax,%edx
  800d7e:	c1 ea 16             	shr    $0x16,%edx
  800d81:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800d88:	f6 c2 01             	test   $0x1,%dl
  800d8b:	74 11                	je     800d9e <fd_alloc+0x2d>
  800d8d:	89 c2                	mov    %eax,%edx
  800d8f:	c1 ea 0c             	shr    $0xc,%edx
  800d92:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d99:	f6 c2 01             	test   $0x1,%dl
  800d9c:	75 09                	jne    800da7 <fd_alloc+0x36>
			*fd_store = fd;
  800d9e:	89 01                	mov    %eax,(%ecx)
			return 0;
  800da0:	b8 00 00 00 00       	mov    $0x0,%eax
  800da5:	eb 17                	jmp    800dbe <fd_alloc+0x4d>
  800da7:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800dac:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800db1:	75 c9                	jne    800d7c <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800db3:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800db9:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800dbe:	5d                   	pop    %ebp
  800dbf:	c3                   	ret    

00800dc0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800dc6:	83 f8 1f             	cmp    $0x1f,%eax
  800dc9:	77 36                	ja     800e01 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800dcb:	c1 e0 0c             	shl    $0xc,%eax
  800dce:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800dd3:	89 c2                	mov    %eax,%edx
  800dd5:	c1 ea 16             	shr    $0x16,%edx
  800dd8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ddf:	f6 c2 01             	test   $0x1,%dl
  800de2:	74 24                	je     800e08 <fd_lookup+0x48>
  800de4:	89 c2                	mov    %eax,%edx
  800de6:	c1 ea 0c             	shr    $0xc,%edx
  800de9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800df0:	f6 c2 01             	test   $0x1,%dl
  800df3:	74 1a                	je     800e0f <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800df5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df8:	89 02                	mov    %eax,(%edx)
	return 0;
  800dfa:	b8 00 00 00 00       	mov    $0x0,%eax
  800dff:	eb 13                	jmp    800e14 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800e01:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e06:	eb 0c                	jmp    800e14 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800e08:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e0d:	eb 05                	jmp    800e14 <fd_lookup+0x54>
  800e0f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800e14:	5d                   	pop    %ebp
  800e15:	c3                   	ret    

00800e16 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	83 ec 08             	sub    $0x8,%esp
  800e1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e1f:	ba a8 28 80 00       	mov    $0x8028a8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800e24:	eb 13                	jmp    800e39 <dev_lookup+0x23>
  800e26:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  800e29:	39 08                	cmp    %ecx,(%eax)
  800e2b:	75 0c                	jne    800e39 <dev_lookup+0x23>
			*dev = devtab[i];
  800e2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e30:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e32:	b8 00 00 00 00       	mov    $0x0,%eax
  800e37:	eb 2e                	jmp    800e67 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800e39:	8b 02                	mov    (%edx),%eax
  800e3b:	85 c0                	test   %eax,%eax
  800e3d:	75 e7                	jne    800e26 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e3f:	a1 04 40 80 00       	mov    0x804004,%eax
  800e44:	8b 40 48             	mov    0x48(%eax),%eax
  800e47:	83 ec 04             	sub    $0x4,%esp
  800e4a:	51                   	push   %ecx
  800e4b:	50                   	push   %eax
  800e4c:	68 2c 28 80 00       	push   $0x80282c
  800e51:	e8 1b f4 ff ff       	call   800271 <cprintf>
	*dev = 0;
  800e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e5f:	83 c4 10             	add    $0x10,%esp
  800e62:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e67:	c9                   	leave  
  800e68:	c3                   	ret    

00800e69 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	56                   	push   %esi
  800e6d:	53                   	push   %ebx
  800e6e:	83 ec 10             	sub    $0x10,%esp
  800e71:	8b 75 08             	mov    0x8(%ebp),%esi
  800e74:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e77:	56                   	push   %esi
  800e78:	e8 cc fe ff ff       	call   800d49 <fd2num>
  800e7d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800e80:	89 14 24             	mov    %edx,(%esp)
  800e83:	50                   	push   %eax
  800e84:	e8 37 ff ff ff       	call   800dc0 <fd_lookup>
  800e89:	83 c4 08             	add    $0x8,%esp
  800e8c:	85 c0                	test   %eax,%eax
  800e8e:	78 05                	js     800e95 <fd_close+0x2c>
	    || fd != fd2)
  800e90:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800e93:	74 0c                	je     800ea1 <fd_close+0x38>
		return (must_exist ? r : 0);
  800e95:	84 db                	test   %bl,%bl
  800e97:	ba 00 00 00 00       	mov    $0x0,%edx
  800e9c:	0f 44 c2             	cmove  %edx,%eax
  800e9f:	eb 41                	jmp    800ee2 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ea7:	50                   	push   %eax
  800ea8:	ff 36                	pushl  (%esi)
  800eaa:	e8 67 ff ff ff       	call   800e16 <dev_lookup>
  800eaf:	89 c3                	mov    %eax,%ebx
  800eb1:	83 c4 10             	add    $0x10,%esp
  800eb4:	85 c0                	test   %eax,%eax
  800eb6:	78 1a                	js     800ed2 <fd_close+0x69>
		if (dev->dev_close)
  800eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800ebe:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800ec3:	85 c0                	test   %eax,%eax
  800ec5:	74 0b                	je     800ed2 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  800ec7:	83 ec 0c             	sub    $0xc,%esp
  800eca:	56                   	push   %esi
  800ecb:	ff d0                	call   *%eax
  800ecd:	89 c3                	mov    %eax,%ebx
  800ecf:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800ed2:	83 ec 08             	sub    $0x8,%esp
  800ed5:	56                   	push   %esi
  800ed6:	6a 00                	push   $0x0
  800ed8:	e8 99 fd ff ff       	call   800c76 <sys_page_unmap>
	return r;
  800edd:	83 c4 10             	add    $0x10,%esp
  800ee0:	89 d8                	mov    %ebx,%eax
}
  800ee2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ee5:	5b                   	pop    %ebx
  800ee6:	5e                   	pop    %esi
  800ee7:	5d                   	pop    %ebp
  800ee8:	c3                   	ret    

00800ee9 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
  800eec:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800eef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ef2:	50                   	push   %eax
  800ef3:	ff 75 08             	pushl  0x8(%ebp)
  800ef6:	e8 c5 fe ff ff       	call   800dc0 <fd_lookup>
  800efb:	83 c4 08             	add    $0x8,%esp
  800efe:	85 c0                	test   %eax,%eax
  800f00:	78 10                	js     800f12 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800f02:	83 ec 08             	sub    $0x8,%esp
  800f05:	6a 01                	push   $0x1
  800f07:	ff 75 f4             	pushl  -0xc(%ebp)
  800f0a:	e8 5a ff ff ff       	call   800e69 <fd_close>
  800f0f:	83 c4 10             	add    $0x10,%esp
}
  800f12:	c9                   	leave  
  800f13:	c3                   	ret    

00800f14 <close_all>:

void
close_all(void)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	53                   	push   %ebx
  800f18:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f1b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f20:	83 ec 0c             	sub    $0xc,%esp
  800f23:	53                   	push   %ebx
  800f24:	e8 c0 ff ff ff       	call   800ee9 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800f29:	83 c3 01             	add    $0x1,%ebx
  800f2c:	83 c4 10             	add    $0x10,%esp
  800f2f:	83 fb 20             	cmp    $0x20,%ebx
  800f32:	75 ec                	jne    800f20 <close_all+0xc>
		close(i);
}
  800f34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f37:	c9                   	leave  
  800f38:	c3                   	ret    

00800f39 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	57                   	push   %edi
  800f3d:	56                   	push   %esi
  800f3e:	53                   	push   %ebx
  800f3f:	83 ec 2c             	sub    $0x2c,%esp
  800f42:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f45:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f48:	50                   	push   %eax
  800f49:	ff 75 08             	pushl  0x8(%ebp)
  800f4c:	e8 6f fe ff ff       	call   800dc0 <fd_lookup>
  800f51:	83 c4 08             	add    $0x8,%esp
  800f54:	85 c0                	test   %eax,%eax
  800f56:	0f 88 c1 00 00 00    	js     80101d <dup+0xe4>
		return r;
	close(newfdnum);
  800f5c:	83 ec 0c             	sub    $0xc,%esp
  800f5f:	56                   	push   %esi
  800f60:	e8 84 ff ff ff       	call   800ee9 <close>

	newfd = INDEX2FD(newfdnum);
  800f65:	89 f3                	mov    %esi,%ebx
  800f67:	c1 e3 0c             	shl    $0xc,%ebx
  800f6a:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800f70:	83 c4 04             	add    $0x4,%esp
  800f73:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f76:	e8 de fd ff ff       	call   800d59 <fd2data>
  800f7b:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  800f7d:	89 1c 24             	mov    %ebx,(%esp)
  800f80:	e8 d4 fd ff ff       	call   800d59 <fd2data>
  800f85:	83 c4 10             	add    $0x10,%esp
  800f88:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800f8b:	89 f8                	mov    %edi,%eax
  800f8d:	c1 e8 16             	shr    $0x16,%eax
  800f90:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f97:	a8 01                	test   $0x1,%al
  800f99:	74 37                	je     800fd2 <dup+0x99>
  800f9b:	89 f8                	mov    %edi,%eax
  800f9d:	c1 e8 0c             	shr    $0xc,%eax
  800fa0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fa7:	f6 c2 01             	test   $0x1,%dl
  800faa:	74 26                	je     800fd2 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800fac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fb3:	83 ec 0c             	sub    $0xc,%esp
  800fb6:	25 07 0e 00 00       	and    $0xe07,%eax
  800fbb:	50                   	push   %eax
  800fbc:	ff 75 d4             	pushl  -0x2c(%ebp)
  800fbf:	6a 00                	push   $0x0
  800fc1:	57                   	push   %edi
  800fc2:	6a 00                	push   $0x0
  800fc4:	e8 87 fc ff ff       	call   800c50 <sys_page_map>
  800fc9:	89 c7                	mov    %eax,%edi
  800fcb:	83 c4 20             	add    $0x20,%esp
  800fce:	85 c0                	test   %eax,%eax
  800fd0:	78 2e                	js     801000 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800fd2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800fd5:	89 d0                	mov    %edx,%eax
  800fd7:	c1 e8 0c             	shr    $0xc,%eax
  800fda:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fe1:	83 ec 0c             	sub    $0xc,%esp
  800fe4:	25 07 0e 00 00       	and    $0xe07,%eax
  800fe9:	50                   	push   %eax
  800fea:	53                   	push   %ebx
  800feb:	6a 00                	push   $0x0
  800fed:	52                   	push   %edx
  800fee:	6a 00                	push   $0x0
  800ff0:	e8 5b fc ff ff       	call   800c50 <sys_page_map>
  800ff5:	89 c7                	mov    %eax,%edi
  800ff7:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  800ffa:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800ffc:	85 ff                	test   %edi,%edi
  800ffe:	79 1d                	jns    80101d <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801000:	83 ec 08             	sub    $0x8,%esp
  801003:	53                   	push   %ebx
  801004:	6a 00                	push   $0x0
  801006:	e8 6b fc ff ff       	call   800c76 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80100b:	83 c4 08             	add    $0x8,%esp
  80100e:	ff 75 d4             	pushl  -0x2c(%ebp)
  801011:	6a 00                	push   $0x0
  801013:	e8 5e fc ff ff       	call   800c76 <sys_page_unmap>
	return r;
  801018:	83 c4 10             	add    $0x10,%esp
  80101b:	89 f8                	mov    %edi,%eax
}
  80101d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801020:	5b                   	pop    %ebx
  801021:	5e                   	pop    %esi
  801022:	5f                   	pop    %edi
  801023:	5d                   	pop    %ebp
  801024:	c3                   	ret    

00801025 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801025:	55                   	push   %ebp
  801026:	89 e5                	mov    %esp,%ebp
  801028:	53                   	push   %ebx
  801029:	83 ec 14             	sub    $0x14,%esp
  80102c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80102f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801032:	50                   	push   %eax
  801033:	53                   	push   %ebx
  801034:	e8 87 fd ff ff       	call   800dc0 <fd_lookup>
  801039:	83 c4 08             	add    $0x8,%esp
  80103c:	89 c2                	mov    %eax,%edx
  80103e:	85 c0                	test   %eax,%eax
  801040:	78 6d                	js     8010af <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801042:	83 ec 08             	sub    $0x8,%esp
  801045:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801048:	50                   	push   %eax
  801049:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80104c:	ff 30                	pushl  (%eax)
  80104e:	e8 c3 fd ff ff       	call   800e16 <dev_lookup>
  801053:	83 c4 10             	add    $0x10,%esp
  801056:	85 c0                	test   %eax,%eax
  801058:	78 4c                	js     8010a6 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80105a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80105d:	8b 42 08             	mov    0x8(%edx),%eax
  801060:	83 e0 03             	and    $0x3,%eax
  801063:	83 f8 01             	cmp    $0x1,%eax
  801066:	75 21                	jne    801089 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801068:	a1 04 40 80 00       	mov    0x804004,%eax
  80106d:	8b 40 48             	mov    0x48(%eax),%eax
  801070:	83 ec 04             	sub    $0x4,%esp
  801073:	53                   	push   %ebx
  801074:	50                   	push   %eax
  801075:	68 6d 28 80 00       	push   $0x80286d
  80107a:	e8 f2 f1 ff ff       	call   800271 <cprintf>
		return -E_INVAL;
  80107f:	83 c4 10             	add    $0x10,%esp
  801082:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801087:	eb 26                	jmp    8010af <read+0x8a>
	}
	if (!dev->dev_read)
  801089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80108c:	8b 40 08             	mov    0x8(%eax),%eax
  80108f:	85 c0                	test   %eax,%eax
  801091:	74 17                	je     8010aa <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801093:	83 ec 04             	sub    $0x4,%esp
  801096:	ff 75 10             	pushl  0x10(%ebp)
  801099:	ff 75 0c             	pushl  0xc(%ebp)
  80109c:	52                   	push   %edx
  80109d:	ff d0                	call   *%eax
  80109f:	89 c2                	mov    %eax,%edx
  8010a1:	83 c4 10             	add    $0x10,%esp
  8010a4:	eb 09                	jmp    8010af <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010a6:	89 c2                	mov    %eax,%edx
  8010a8:	eb 05                	jmp    8010af <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8010aa:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  8010af:	89 d0                	mov    %edx,%eax
  8010b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	57                   	push   %edi
  8010ba:	56                   	push   %esi
  8010bb:	53                   	push   %ebx
  8010bc:	83 ec 0c             	sub    $0xc,%esp
  8010bf:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010c2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8010c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ca:	eb 21                	jmp    8010ed <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010cc:	83 ec 04             	sub    $0x4,%esp
  8010cf:	89 f0                	mov    %esi,%eax
  8010d1:	29 d8                	sub    %ebx,%eax
  8010d3:	50                   	push   %eax
  8010d4:	89 d8                	mov    %ebx,%eax
  8010d6:	03 45 0c             	add    0xc(%ebp),%eax
  8010d9:	50                   	push   %eax
  8010da:	57                   	push   %edi
  8010db:	e8 45 ff ff ff       	call   801025 <read>
		if (m < 0)
  8010e0:	83 c4 10             	add    $0x10,%esp
  8010e3:	85 c0                	test   %eax,%eax
  8010e5:	78 10                	js     8010f7 <readn+0x41>
			return m;
		if (m == 0)
  8010e7:	85 c0                	test   %eax,%eax
  8010e9:	74 0a                	je     8010f5 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8010eb:	01 c3                	add    %eax,%ebx
  8010ed:	39 f3                	cmp    %esi,%ebx
  8010ef:	72 db                	jb     8010cc <readn+0x16>
  8010f1:	89 d8                	mov    %ebx,%eax
  8010f3:	eb 02                	jmp    8010f7 <readn+0x41>
  8010f5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8010f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010fa:	5b                   	pop    %ebx
  8010fb:	5e                   	pop    %esi
  8010fc:	5f                   	pop    %edi
  8010fd:	5d                   	pop    %ebp
  8010fe:	c3                   	ret    

008010ff <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	53                   	push   %ebx
  801103:	83 ec 14             	sub    $0x14,%esp
  801106:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801109:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80110c:	50                   	push   %eax
  80110d:	53                   	push   %ebx
  80110e:	e8 ad fc ff ff       	call   800dc0 <fd_lookup>
  801113:	83 c4 08             	add    $0x8,%esp
  801116:	89 c2                	mov    %eax,%edx
  801118:	85 c0                	test   %eax,%eax
  80111a:	78 68                	js     801184 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80111c:	83 ec 08             	sub    $0x8,%esp
  80111f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801122:	50                   	push   %eax
  801123:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801126:	ff 30                	pushl  (%eax)
  801128:	e8 e9 fc ff ff       	call   800e16 <dev_lookup>
  80112d:	83 c4 10             	add    $0x10,%esp
  801130:	85 c0                	test   %eax,%eax
  801132:	78 47                	js     80117b <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801134:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801137:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80113b:	75 21                	jne    80115e <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80113d:	a1 04 40 80 00       	mov    0x804004,%eax
  801142:	8b 40 48             	mov    0x48(%eax),%eax
  801145:	83 ec 04             	sub    $0x4,%esp
  801148:	53                   	push   %ebx
  801149:	50                   	push   %eax
  80114a:	68 89 28 80 00       	push   $0x802889
  80114f:	e8 1d f1 ff ff       	call   800271 <cprintf>
		return -E_INVAL;
  801154:	83 c4 10             	add    $0x10,%esp
  801157:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80115c:	eb 26                	jmp    801184 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80115e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801161:	8b 52 0c             	mov    0xc(%edx),%edx
  801164:	85 d2                	test   %edx,%edx
  801166:	74 17                	je     80117f <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801168:	83 ec 04             	sub    $0x4,%esp
  80116b:	ff 75 10             	pushl  0x10(%ebp)
  80116e:	ff 75 0c             	pushl  0xc(%ebp)
  801171:	50                   	push   %eax
  801172:	ff d2                	call   *%edx
  801174:	89 c2                	mov    %eax,%edx
  801176:	83 c4 10             	add    $0x10,%esp
  801179:	eb 09                	jmp    801184 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80117b:	89 c2                	mov    %eax,%edx
  80117d:	eb 05                	jmp    801184 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80117f:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  801184:	89 d0                	mov    %edx,%eax
  801186:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801189:	c9                   	leave  
  80118a:	c3                   	ret    

0080118b <seek>:

int
seek(int fdnum, off_t offset)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801191:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801194:	50                   	push   %eax
  801195:	ff 75 08             	pushl  0x8(%ebp)
  801198:	e8 23 fc ff ff       	call   800dc0 <fd_lookup>
  80119d:	83 c4 08             	add    $0x8,%esp
  8011a0:	85 c0                	test   %eax,%eax
  8011a2:	78 0e                	js     8011b2 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8011a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011aa:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8011ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    

008011b4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	53                   	push   %ebx
  8011b8:	83 ec 14             	sub    $0x14,%esp
  8011bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011be:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011c1:	50                   	push   %eax
  8011c2:	53                   	push   %ebx
  8011c3:	e8 f8 fb ff ff       	call   800dc0 <fd_lookup>
  8011c8:	83 c4 08             	add    $0x8,%esp
  8011cb:	89 c2                	mov    %eax,%edx
  8011cd:	85 c0                	test   %eax,%eax
  8011cf:	78 65                	js     801236 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011d1:	83 ec 08             	sub    $0x8,%esp
  8011d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011d7:	50                   	push   %eax
  8011d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011db:	ff 30                	pushl  (%eax)
  8011dd:	e8 34 fc ff ff       	call   800e16 <dev_lookup>
  8011e2:	83 c4 10             	add    $0x10,%esp
  8011e5:	85 c0                	test   %eax,%eax
  8011e7:	78 44                	js     80122d <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ec:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011f0:	75 21                	jne    801213 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8011f2:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8011f7:	8b 40 48             	mov    0x48(%eax),%eax
  8011fa:	83 ec 04             	sub    $0x4,%esp
  8011fd:	53                   	push   %ebx
  8011fe:	50                   	push   %eax
  8011ff:	68 4c 28 80 00       	push   $0x80284c
  801204:	e8 68 f0 ff ff       	call   800271 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801209:	83 c4 10             	add    $0x10,%esp
  80120c:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801211:	eb 23                	jmp    801236 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  801213:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801216:	8b 52 18             	mov    0x18(%edx),%edx
  801219:	85 d2                	test   %edx,%edx
  80121b:	74 14                	je     801231 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80121d:	83 ec 08             	sub    $0x8,%esp
  801220:	ff 75 0c             	pushl  0xc(%ebp)
  801223:	50                   	push   %eax
  801224:	ff d2                	call   *%edx
  801226:	89 c2                	mov    %eax,%edx
  801228:	83 c4 10             	add    $0x10,%esp
  80122b:	eb 09                	jmp    801236 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80122d:	89 c2                	mov    %eax,%edx
  80122f:	eb 05                	jmp    801236 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801231:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  801236:	89 d0                	mov    %edx,%eax
  801238:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80123b:	c9                   	leave  
  80123c:	c3                   	ret    

0080123d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	53                   	push   %ebx
  801241:	83 ec 14             	sub    $0x14,%esp
  801244:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801247:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80124a:	50                   	push   %eax
  80124b:	ff 75 08             	pushl  0x8(%ebp)
  80124e:	e8 6d fb ff ff       	call   800dc0 <fd_lookup>
  801253:	83 c4 08             	add    $0x8,%esp
  801256:	89 c2                	mov    %eax,%edx
  801258:	85 c0                	test   %eax,%eax
  80125a:	78 58                	js     8012b4 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80125c:	83 ec 08             	sub    $0x8,%esp
  80125f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801262:	50                   	push   %eax
  801263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801266:	ff 30                	pushl  (%eax)
  801268:	e8 a9 fb ff ff       	call   800e16 <dev_lookup>
  80126d:	83 c4 10             	add    $0x10,%esp
  801270:	85 c0                	test   %eax,%eax
  801272:	78 37                	js     8012ab <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  801274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801277:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80127b:	74 32                	je     8012af <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80127d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801280:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801287:	00 00 00 
	stat->st_isdir = 0;
  80128a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801291:	00 00 00 
	stat->st_dev = dev;
  801294:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80129a:	83 ec 08             	sub    $0x8,%esp
  80129d:	53                   	push   %ebx
  80129e:	ff 75 f0             	pushl  -0x10(%ebp)
  8012a1:	ff 50 14             	call   *0x14(%eax)
  8012a4:	89 c2                	mov    %eax,%edx
  8012a6:	83 c4 10             	add    $0x10,%esp
  8012a9:	eb 09                	jmp    8012b4 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012ab:	89 c2                	mov    %eax,%edx
  8012ad:	eb 05                	jmp    8012b4 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8012af:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8012b4:	89 d0                	mov    %edx,%eax
  8012b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012b9:	c9                   	leave  
  8012ba:	c3                   	ret    

008012bb <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	56                   	push   %esi
  8012bf:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8012c0:	83 ec 08             	sub    $0x8,%esp
  8012c3:	6a 00                	push   $0x0
  8012c5:	ff 75 08             	pushl  0x8(%ebp)
  8012c8:	e8 06 02 00 00       	call   8014d3 <open>
  8012cd:	89 c3                	mov    %eax,%ebx
  8012cf:	83 c4 10             	add    $0x10,%esp
  8012d2:	85 c0                	test   %eax,%eax
  8012d4:	78 1b                	js     8012f1 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8012d6:	83 ec 08             	sub    $0x8,%esp
  8012d9:	ff 75 0c             	pushl  0xc(%ebp)
  8012dc:	50                   	push   %eax
  8012dd:	e8 5b ff ff ff       	call   80123d <fstat>
  8012e2:	89 c6                	mov    %eax,%esi
	close(fd);
  8012e4:	89 1c 24             	mov    %ebx,(%esp)
  8012e7:	e8 fd fb ff ff       	call   800ee9 <close>
	return r;
  8012ec:	83 c4 10             	add    $0x10,%esp
  8012ef:	89 f0                	mov    %esi,%eax
}
  8012f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012f4:	5b                   	pop    %ebx
  8012f5:	5e                   	pop    %esi
  8012f6:	5d                   	pop    %ebp
  8012f7:	c3                   	ret    

008012f8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
  8012fb:	56                   	push   %esi
  8012fc:	53                   	push   %ebx
  8012fd:	89 c6                	mov    %eax,%esi
  8012ff:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801301:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801308:	75 12                	jne    80131c <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80130a:	83 ec 0c             	sub    $0xc,%esp
  80130d:	6a 01                	push   $0x1
  80130f:	e8 e7 0d 00 00       	call   8020fb <ipc_find_env>
  801314:	a3 00 40 80 00       	mov    %eax,0x804000
  801319:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80131c:	6a 07                	push   $0x7
  80131e:	68 00 50 80 00       	push   $0x805000
  801323:	56                   	push   %esi
  801324:	ff 35 00 40 80 00    	pushl  0x804000
  80132a:	e8 78 0d 00 00       	call   8020a7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80132f:	83 c4 0c             	add    $0xc,%esp
  801332:	6a 00                	push   $0x0
  801334:	53                   	push   %ebx
  801335:	6a 00                	push   $0x0
  801337:	e8 00 0d 00 00       	call   80203c <ipc_recv>
}
  80133c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80133f:	5b                   	pop    %ebx
  801340:	5e                   	pop    %esi
  801341:	5d                   	pop    %ebp
  801342:	c3                   	ret    

00801343 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
  801346:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8b 40 0c             	mov    0xc(%eax),%eax
  80134f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801354:	8b 45 0c             	mov    0xc(%ebp),%eax
  801357:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80135c:	ba 00 00 00 00       	mov    $0x0,%edx
  801361:	b8 02 00 00 00       	mov    $0x2,%eax
  801366:	e8 8d ff ff ff       	call   8012f8 <fsipc>
}
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	8b 40 0c             	mov    0xc(%eax),%eax
  801379:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80137e:	ba 00 00 00 00       	mov    $0x0,%edx
  801383:	b8 06 00 00 00       	mov    $0x6,%eax
  801388:	e8 6b ff ff ff       	call   8012f8 <fsipc>
}
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    

0080138f <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
  801392:	53                   	push   %ebx
  801393:	83 ec 04             	sub    $0x4,%esp
  801396:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8b 40 0c             	mov    0xc(%eax),%eax
  80139f:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8013a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a9:	b8 05 00 00 00       	mov    $0x5,%eax
  8013ae:	e8 45 ff ff ff       	call   8012f8 <fsipc>
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	78 2c                	js     8013e3 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8013b7:	83 ec 08             	sub    $0x8,%esp
  8013ba:	68 00 50 80 00       	push   $0x805000
  8013bf:	53                   	push   %ebx
  8013c0:	e8 1e f4 ff ff       	call   8007e3 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8013c5:	a1 80 50 80 00       	mov    0x805080,%eax
  8013ca:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8013d0:	a1 84 50 80 00       	mov    0x805084,%eax
  8013d5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8013db:	83 c4 10             	add    $0x10,%esp
  8013de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e6:	c9                   	leave  
  8013e7:	c3                   	ret    

008013e8 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
  8013eb:	83 ec 08             	sub    $0x8,%esp
  8013ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f1:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8013f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013f7:	8b 49 0c             	mov    0xc(%ecx),%ecx
  8013fa:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  801400:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801405:	76 22                	jbe    801429 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  801407:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  80140e:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  801411:	83 ec 04             	sub    $0x4,%esp
  801414:	68 f8 0f 00 00       	push   $0xff8
  801419:	52                   	push   %edx
  80141a:	68 08 50 80 00       	push   $0x805008
  80141f:	e8 52 f5 ff ff       	call   800976 <memmove>
  801424:	83 c4 10             	add    $0x10,%esp
  801427:	eb 17                	jmp    801440 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  801429:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  80142e:	83 ec 04             	sub    $0x4,%esp
  801431:	50                   	push   %eax
  801432:	52                   	push   %edx
  801433:	68 08 50 80 00       	push   $0x805008
  801438:	e8 39 f5 ff ff       	call   800976 <memmove>
  80143d:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  801440:	ba 00 00 00 00       	mov    $0x0,%edx
  801445:	b8 04 00 00 00       	mov    $0x4,%eax
  80144a:	e8 a9 fe ff ff       	call   8012f8 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  80144f:	c9                   	leave  
  801450:	c3                   	ret    

00801451 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801451:	55                   	push   %ebp
  801452:	89 e5                	mov    %esp,%ebp
  801454:	56                   	push   %esi
  801455:	53                   	push   %ebx
  801456:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801459:	8b 45 08             	mov    0x8(%ebp),%eax
  80145c:	8b 40 0c             	mov    0xc(%eax),%eax
  80145f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801464:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80146a:	ba 00 00 00 00       	mov    $0x0,%edx
  80146f:	b8 03 00 00 00       	mov    $0x3,%eax
  801474:	e8 7f fe ff ff       	call   8012f8 <fsipc>
  801479:	89 c3                	mov    %eax,%ebx
  80147b:	85 c0                	test   %eax,%eax
  80147d:	78 4b                	js     8014ca <devfile_read+0x79>
		return r;
	assert(r <= n);
  80147f:	39 c6                	cmp    %eax,%esi
  801481:	73 16                	jae    801499 <devfile_read+0x48>
  801483:	68 b8 28 80 00       	push   $0x8028b8
  801488:	68 bf 28 80 00       	push   $0x8028bf
  80148d:	6a 7c                	push   $0x7c
  80148f:	68 d4 28 80 00       	push   $0x8028d4
  801494:	e8 ff ec ff ff       	call   800198 <_panic>
	assert(r <= PGSIZE);
  801499:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80149e:	7e 16                	jle    8014b6 <devfile_read+0x65>
  8014a0:	68 df 28 80 00       	push   $0x8028df
  8014a5:	68 bf 28 80 00       	push   $0x8028bf
  8014aa:	6a 7d                	push   $0x7d
  8014ac:	68 d4 28 80 00       	push   $0x8028d4
  8014b1:	e8 e2 ec ff ff       	call   800198 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8014b6:	83 ec 04             	sub    $0x4,%esp
  8014b9:	50                   	push   %eax
  8014ba:	68 00 50 80 00       	push   $0x805000
  8014bf:	ff 75 0c             	pushl  0xc(%ebp)
  8014c2:	e8 af f4 ff ff       	call   800976 <memmove>
	return r;
  8014c7:	83 c4 10             	add    $0x10,%esp
}
  8014ca:	89 d8                	mov    %ebx,%eax
  8014cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014cf:	5b                   	pop    %ebx
  8014d0:	5e                   	pop    %esi
  8014d1:	5d                   	pop    %ebp
  8014d2:	c3                   	ret    

008014d3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
  8014d6:	53                   	push   %ebx
  8014d7:	83 ec 20             	sub    $0x20,%esp
  8014da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8014dd:	53                   	push   %ebx
  8014de:	e8 c7 f2 ff ff       	call   8007aa <strlen>
  8014e3:	83 c4 10             	add    $0x10,%esp
  8014e6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8014eb:	7f 67                	jg     801554 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8014ed:	83 ec 0c             	sub    $0xc,%esp
  8014f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f3:	50                   	push   %eax
  8014f4:	e8 78 f8 ff ff       	call   800d71 <fd_alloc>
  8014f9:	83 c4 10             	add    $0x10,%esp
		return r;
  8014fc:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8014fe:	85 c0                	test   %eax,%eax
  801500:	78 57                	js     801559 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801502:	83 ec 08             	sub    $0x8,%esp
  801505:	53                   	push   %ebx
  801506:	68 00 50 80 00       	push   $0x805000
  80150b:	e8 d3 f2 ff ff       	call   8007e3 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801510:	8b 45 0c             	mov    0xc(%ebp),%eax
  801513:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801518:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80151b:	b8 01 00 00 00       	mov    $0x1,%eax
  801520:	e8 d3 fd ff ff       	call   8012f8 <fsipc>
  801525:	89 c3                	mov    %eax,%ebx
  801527:	83 c4 10             	add    $0x10,%esp
  80152a:	85 c0                	test   %eax,%eax
  80152c:	79 14                	jns    801542 <open+0x6f>
		fd_close(fd, 0);
  80152e:	83 ec 08             	sub    $0x8,%esp
  801531:	6a 00                	push   $0x0
  801533:	ff 75 f4             	pushl  -0xc(%ebp)
  801536:	e8 2e f9 ff ff       	call   800e69 <fd_close>
		return r;
  80153b:	83 c4 10             	add    $0x10,%esp
  80153e:	89 da                	mov    %ebx,%edx
  801540:	eb 17                	jmp    801559 <open+0x86>
	}

	return fd2num(fd);
  801542:	83 ec 0c             	sub    $0xc,%esp
  801545:	ff 75 f4             	pushl  -0xc(%ebp)
  801548:	e8 fc f7 ff ff       	call   800d49 <fd2num>
  80154d:	89 c2                	mov    %eax,%edx
  80154f:	83 c4 10             	add    $0x10,%esp
  801552:	eb 05                	jmp    801559 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801554:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801559:	89 d0                	mov    %edx,%eax
  80155b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    

00801560 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801566:	ba 00 00 00 00       	mov    $0x0,%edx
  80156b:	b8 08 00 00 00       	mov    $0x8,%eax
  801570:	e8 83 fd ff ff       	call   8012f8 <fsipc>
}
  801575:	c9                   	leave  
  801576:	c3                   	ret    

00801577 <copy_shared_pages>:
}

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	57                   	push   %edi
  80157b:	56                   	push   %esi
  80157c:	53                   	push   %ebx
  80157d:	83 ec 1c             	sub    $0x1c,%esp
  801580:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801583:	bf 00 04 00 00       	mov    $0x400,%edi
	// LAB 5: Your code here.
	unsigned int pn;
	void* addr;
  	for (int i = 0; i < NPDENTRIES; ++i) {
  801588:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80158f:	eb 7d                	jmp    80160e <copy_shared_pages+0x97>
	    for (int j = 0; j < NPTENTRIES; ++j) {
    	  pn = i*NPDENTRIES + j;
    	  addr = (void*) (pn*PGSIZE);
      	  if ((pn < (UTOP >> PGSHIFT)) && uvpd[i]) {
  801591:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  801597:	77 54                	ja     8015ed <copy_shared_pages+0x76>
  801599:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80159c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015a3:	85 c0                	test   %eax,%eax
  8015a5:	74 46                	je     8015ed <copy_shared_pages+0x76>
        	if (uvpt[pn] & PTE_SHARE) {
  8015a7:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8015ae:	f6 c4 04             	test   $0x4,%ah
  8015b1:	74 3a                	je     8015ed <copy_shared_pages+0x76>
          		if (sys_page_map(0, addr, child, addr, uvpt[pn] & PTE_SYSCALL) < 0) {
  8015b3:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8015ba:	83 ec 0c             	sub    $0xc,%esp
  8015bd:	25 07 0e 00 00       	and    $0xe07,%eax
  8015c2:	50                   	push   %eax
  8015c3:	56                   	push   %esi
  8015c4:	ff 75 e0             	pushl  -0x20(%ebp)
  8015c7:	56                   	push   %esi
  8015c8:	6a 00                	push   $0x0
  8015ca:	e8 81 f6 ff ff       	call   800c50 <sys_page_map>
  8015cf:	83 c4 20             	add    $0x20,%esp
  8015d2:	85 c0                	test   %eax,%eax
  8015d4:	79 17                	jns    8015ed <copy_shared_pages+0x76>
              		panic("Error en sys_page_map");
  8015d6:	83 ec 04             	sub    $0x4,%esp
  8015d9:	68 eb 28 80 00       	push   $0x8028eb
  8015de:	68 4f 01 00 00       	push   $0x14f
  8015e3:	68 01 29 80 00       	push   $0x802901
  8015e8:	e8 ab eb ff ff       	call   800198 <_panic>
  8015ed:	83 c3 01             	add    $0x1,%ebx
  8015f0:	81 c6 00 10 00 00    	add    $0x1000,%esi
{
	// LAB 5: Your code here.
	unsigned int pn;
	void* addr;
  	for (int i = 0; i < NPDENTRIES; ++i) {
	    for (int j = 0; j < NPTENTRIES; ++j) {
  8015f6:	39 fb                	cmp    %edi,%ebx
  8015f8:	75 97                	jne    801591 <copy_shared_pages+0x1a>
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	unsigned int pn;
	void* addr;
  	for (int i = 0; i < NPDENTRIES; ++i) {
  8015fa:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  8015fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801601:	81 c7 00 04 00 00    	add    $0x400,%edi
  801607:	3d 00 04 00 00       	cmp    $0x400,%eax
  80160c:	74 10                	je     80161e <copy_shared_pages+0xa7>
  80160e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801611:	89 f3                	mov    %esi,%ebx
  801613:	c1 e3 0a             	shl    $0xa,%ebx
  801616:	c1 e6 16             	shl    $0x16,%esi
  801619:	e9 73 ff ff ff       	jmp    801591 <copy_shared_pages+0x1a>
        	} 
      	  }
    	}
	}
	return 0;
}
  80161e:	b8 00 00 00 00       	mov    $0x0,%eax
  801623:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801626:	5b                   	pop    %ebx
  801627:	5e                   	pop    %esi
  801628:	5f                   	pop    %edi
  801629:	5d                   	pop    %ebp
  80162a:	c3                   	ret    

0080162b <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	57                   	push   %edi
  80162f:	56                   	push   %esi
  801630:	53                   	push   %ebx
  801631:	83 ec 2c             	sub    $0x2c,%esp
  801634:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801637:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80163a:	89 4d cc             	mov    %ecx,-0x34(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80163d:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801642:	be 00 00 00 00       	mov    $0x0,%esi
  801647:	89 d7                	mov    %edx,%edi
	for (argc = 0; argv[argc] != 0; argc++)
  801649:	eb 13                	jmp    80165e <init_stack+0x33>
		string_size += strlen(argv[argc]) + 1;
  80164b:	83 ec 0c             	sub    $0xc,%esp
  80164e:	50                   	push   %eax
  80164f:	e8 56 f1 ff ff       	call   8007aa <strlen>
  801654:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801658:	83 c3 01             	add    $0x1,%ebx
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801665:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801668:	85 c0                	test   %eax,%eax
  80166a:	75 df                	jne    80164b <init_stack+0x20>
  80166c:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  80166f:	89 4d d8             	mov    %ecx,-0x28(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char *) UTEMP + PGSIZE - string_size;
  801672:	bf 00 10 40 00       	mov    $0x401000,%edi
  801677:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t *) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801679:	89 fa                	mov    %edi,%edx
  80167b:	83 e2 fc             	and    $0xfffffffc,%edx
  80167e:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801685:	29 c2                	sub    %eax,%edx
  801687:	89 55 e4             	mov    %edx,-0x1c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void *) (argv_store - 2) < (void *) UTEMP)
  80168a:	8d 42 f8             	lea    -0x8(%edx),%eax
  80168d:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801692:	0f 86 fc 00 00 00    	jbe    801794 <init_stack+0x169>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void *) UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801698:	83 ec 04             	sub    $0x4,%esp
  80169b:	6a 07                	push   $0x7
  80169d:	68 00 00 40 00       	push   $0x400000
  8016a2:	6a 00                	push   $0x0
  8016a4:	e8 83 f5 ff ff       	call   800c2c <sys_page_alloc>
  8016a9:	83 c4 10             	add    $0x10,%esp
  8016ac:	85 c0                	test   %eax,%eax
  8016ae:	0f 88 e5 00 00 00    	js     801799 <init_stack+0x16e>
  8016b4:	be 00 00 00 00       	mov    $0x0,%esi
  8016b9:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  8016bc:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8016bf:	eb 2d                	jmp    8016ee <init_stack+0xc3>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  8016c1:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8016c7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8016ca:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8016cd:	83 ec 08             	sub    $0x8,%esp
  8016d0:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8016d3:	57                   	push   %edi
  8016d4:	e8 0a f1 ff ff       	call   8007e3 <strcpy>
		string_store += strlen(argv[i]) + 1;
  8016d9:	83 c4 04             	add    $0x4,%esp
  8016dc:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8016df:	e8 c6 f0 ff ff       	call   8007aa <strlen>
  8016e4:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8016e8:	83 c6 01             	add    $0x1,%esi
  8016eb:	83 c4 10             	add    $0x10,%esp
  8016ee:	39 75 e0             	cmp    %esi,-0x20(%ebp)
  8016f1:	7f ce                	jg     8016c1 <init_stack+0x96>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8016f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016f6:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8016f9:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char *) UTEMP + PGSIZE);
  801700:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801706:	74 19                	je     801721 <init_stack+0xf6>
  801708:	68 8c 29 80 00       	push   $0x80298c
  80170d:	68 bf 28 80 00       	push   $0x8028bf
  801712:	68 fc 00 00 00       	push   $0xfc
  801717:	68 01 29 80 00       	push   $0x802901
  80171c:	e8 77 ea ff ff       	call   800198 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801721:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801724:	89 d0                	mov    %edx,%eax
  801726:	2d 00 30 80 11       	sub    $0x11803000,%eax
  80172b:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  80172e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801731:	89 42 f8             	mov    %eax,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801734:	8d 82 f8 cf 7f ee    	lea    -0x11803008(%edx),%eax
  80173a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  80173d:	89 01                	mov    %eax,(%ecx)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0,
  80173f:	83 ec 0c             	sub    $0xc,%esp
  801742:	6a 07                	push   $0x7
  801744:	68 00 d0 bf ee       	push   $0xeebfd000
  801749:	ff 75 d4             	pushl  -0x2c(%ebp)
  80174c:	68 00 00 40 00       	push   $0x400000
  801751:	6a 00                	push   $0x0
  801753:	e8 f8 f4 ff ff       	call   800c50 <sys_page_map>
  801758:	89 c3                	mov    %eax,%ebx
  80175a:	83 c4 20             	add    $0x20,%esp
  80175d:	85 c0                	test   %eax,%eax
  80175f:	78 1d                	js     80177e <init_stack+0x153>
	                      UTEMP,
	                      child,
	                      (void *) (USTACKTOP - PGSIZE),
	                      PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801761:	83 ec 08             	sub    $0x8,%esp
  801764:	68 00 00 40 00       	push   $0x400000
  801769:	6a 00                	push   $0x0
  80176b:	e8 06 f5 ff ff       	call   800c76 <sys_page_unmap>
  801770:	89 c3                	mov    %eax,%ebx
  801772:	83 c4 10             	add    $0x10,%esp
		goto error;

	return 0;
  801775:	b8 00 00 00 00       	mov    $0x0,%eax
	                      UTEMP,
	                      child,
	                      (void *) (USTACKTOP - PGSIZE),
	                      PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80177a:	85 db                	test   %ebx,%ebx
  80177c:	79 1b                	jns    801799 <init_stack+0x16e>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  80177e:	83 ec 08             	sub    $0x8,%esp
  801781:	68 00 00 40 00       	push   $0x400000
  801786:	6a 00                	push   $0x0
  801788:	e8 e9 f4 ff ff       	call   800c76 <sys_page_unmap>
	return r;
  80178d:	83 c4 10             	add    $0x10,%esp
  801790:	89 d8                	mov    %ebx,%eax
  801792:	eb 05                	jmp    801799 <init_stack+0x16e>
	argv_store = (uintptr_t *) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void *) (argv_store - 2) < (void *) UTEMP)
		return -E_NO_MEM;
  801794:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return 0;

error:
	sys_page_unmap(0, UTEMP);
	return r;
}
  801799:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80179c:	5b                   	pop    %ebx
  80179d:	5e                   	pop    %esi
  80179e:	5f                   	pop    %edi
  80179f:	5d                   	pop    %ebp
  8017a0:	c3                   	ret    

008017a1 <map_segment>:
            size_t memsz,
            int fd,
            size_t filesz,
            off_t fileoffset,
            int perm)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	57                   	push   %edi
  8017a5:	56                   	push   %esi
  8017a6:	53                   	push   %ebx
  8017a7:	83 ec 1c             	sub    $0x1c,%esp
  8017aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8017ad:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	int i, r;
	void *blk;

	// cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8017b0:	89 d0                	mov    %edx,%eax
  8017b2:	25 ff 0f 00 00       	and    $0xfff,%eax
  8017b7:	74 0d                	je     8017c6 <map_segment+0x25>
		va -= i;
  8017b9:	29 c2                	sub    %eax,%edx
		memsz += i;
  8017bb:	01 c1                	add    %eax,%ecx
  8017bd:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		filesz += i;
  8017c0:	01 45 0c             	add    %eax,0xc(%ebp)
		fileoffset -= i;
  8017c3:	29 45 10             	sub    %eax,0x10(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8017c6:	89 d6                	mov    %edx,%esi
  8017c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017cd:	e9 d6 00 00 00       	jmp    8018a8 <map_segment+0x107>
		if (i >= filesz) {
  8017d2:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
  8017d5:	77 1f                	ja     8017f6 <map_segment+0x55>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void *) (va + i), perm)) < 0)
  8017d7:	83 ec 04             	sub    $0x4,%esp
  8017da:	ff 75 14             	pushl  0x14(%ebp)
  8017dd:	56                   	push   %esi
  8017de:	ff 75 e0             	pushl  -0x20(%ebp)
  8017e1:	e8 46 f4 ff ff       	call   800c2c <sys_page_alloc>
  8017e6:	83 c4 10             	add    $0x10,%esp
  8017e9:	85 c0                	test   %eax,%eax
  8017eb:	0f 89 ab 00 00 00    	jns    80189c <map_segment+0xfb>
  8017f1:	e9 c2 00 00 00       	jmp    8018b8 <map_segment+0x117>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W)) <
  8017f6:	83 ec 04             	sub    $0x4,%esp
  8017f9:	6a 07                	push   $0x7
  8017fb:	68 00 00 40 00       	push   $0x400000
  801800:	6a 00                	push   $0x0
  801802:	e8 25 f4 ff ff       	call   800c2c <sys_page_alloc>
  801807:	83 c4 10             	add    $0x10,%esp
  80180a:	85 c0                	test   %eax,%eax
  80180c:	0f 88 a6 00 00 00    	js     8018b8 <map_segment+0x117>
			    0)
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801812:	83 ec 08             	sub    $0x8,%esp
  801815:	89 f8                	mov    %edi,%eax
  801817:	03 45 10             	add    0x10(%ebp),%eax
  80181a:	50                   	push   %eax
  80181b:	ff 75 08             	pushl  0x8(%ebp)
  80181e:	e8 68 f9 ff ff       	call   80118b <seek>
  801823:	83 c4 10             	add    $0x10,%esp
  801826:	85 c0                	test   %eax,%eax
  801828:	0f 88 8a 00 00 00    	js     8018b8 <map_segment+0x117>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz - i))) < 0)
  80182e:	83 ec 04             	sub    $0x4,%esp
  801831:	8b 45 0c             	mov    0xc(%ebp),%eax
  801834:	29 f8                	sub    %edi,%eax
  801836:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80183b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801840:	0f 47 c1             	cmova  %ecx,%eax
  801843:	50                   	push   %eax
  801844:	68 00 00 40 00       	push   $0x400000
  801849:	ff 75 08             	pushl  0x8(%ebp)
  80184c:	e8 65 f8 ff ff       	call   8010b6 <readn>
  801851:	83 c4 10             	add    $0x10,%esp
  801854:	85 c0                	test   %eax,%eax
  801856:	78 60                	js     8018b8 <map_segment+0x117>
				return r;
			if ((r = sys_page_map(
  801858:	83 ec 0c             	sub    $0xc,%esp
  80185b:	ff 75 14             	pushl  0x14(%ebp)
  80185e:	56                   	push   %esi
  80185f:	ff 75 e0             	pushl  -0x20(%ebp)
  801862:	68 00 00 40 00       	push   $0x400000
  801867:	6a 00                	push   $0x0
  801869:	e8 e2 f3 ff ff       	call   800c50 <sys_page_map>
  80186e:	83 c4 20             	add    $0x20,%esp
  801871:	85 c0                	test   %eax,%eax
  801873:	79 15                	jns    80188a <map_segment+0xe9>
			             0, UTEMP, child, (void *) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
  801875:	50                   	push   %eax
  801876:	68 0d 29 80 00       	push   $0x80290d
  80187b:	68 3a 01 00 00       	push   $0x13a
  801880:	68 01 29 80 00       	push   $0x802901
  801885:	e8 0e e9 ff ff       	call   800198 <_panic>
			sys_page_unmap(0, UTEMP);
  80188a:	83 ec 08             	sub    $0x8,%esp
  80188d:	68 00 00 40 00       	push   $0x400000
  801892:	6a 00                	push   $0x0
  801894:	e8 dd f3 ff ff       	call   800c76 <sys_page_unmap>
  801899:	83 c4 10             	add    $0x10,%esp
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80189c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8018a2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  8018a8:	89 df                	mov    %ebx,%edi
  8018aa:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
  8018ad:	0f 87 1f ff ff ff    	ja     8017d2 <map_segment+0x31>
			             0, UTEMP, child, (void *) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  8018b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018bb:	5b                   	pop    %ebx
  8018bc:	5e                   	pop    %esi
  8018bd:	5f                   	pop    %edi
  8018be:	5d                   	pop    %ebp
  8018bf:	c3                   	ret    

008018c0 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	57                   	push   %edi
  8018c4:	56                   	push   %esi
  8018c5:	53                   	push   %ebx
  8018c6:	81 ec 74 02 00 00    	sub    $0x274,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8018cc:	6a 00                	push   $0x0
  8018ce:	ff 75 08             	pushl  0x8(%ebp)
  8018d1:	e8 fd fb ff ff       	call   8014d3 <open>
  8018d6:	89 c7                	mov    %eax,%edi
  8018d8:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8018de:	83 c4 10             	add    $0x10,%esp
  8018e1:	85 c0                	test   %eax,%eax
  8018e3:	0f 88 e3 01 00 00    	js     801acc <spawn+0x20c>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf *) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf) ||
  8018e9:	83 ec 04             	sub    $0x4,%esp
  8018ec:	68 00 02 00 00       	push   $0x200
  8018f1:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8018f7:	50                   	push   %eax
  8018f8:	57                   	push   %edi
  8018f9:	e8 b8 f7 ff ff       	call   8010b6 <readn>
  8018fe:	83 c4 10             	add    $0x10,%esp
  801901:	3d 00 02 00 00       	cmp    $0x200,%eax
  801906:	75 0c                	jne    801914 <spawn+0x54>
  801908:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  80190f:	45 4c 46 
  801912:	74 33                	je     801947 <spawn+0x87>
	    elf->e_magic != ELF_MAGIC) {
		close(fd);
  801914:	83 ec 0c             	sub    $0xc,%esp
  801917:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80191d:	e8 c7 f5 ff ff       	call   800ee9 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801922:	83 c4 0c             	add    $0xc,%esp
  801925:	68 7f 45 4c 46       	push   $0x464c457f
  80192a:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801930:	68 2a 29 80 00       	push   $0x80292a
  801935:	e8 37 e9 ff ff       	call   800271 <cprintf>
		return -E_NOT_EXEC;
  80193a:	83 c4 10             	add    $0x10,%esp
  80193d:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801942:	e9 9b 01 00 00       	jmp    801ae2 <spawn+0x222>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801947:	b8 07 00 00 00       	mov    $0x7,%eax
  80194c:	cd 30                	int    $0x30
  80194e:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801954:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80195a:	89 c3                	mov    %eax,%ebx
  80195c:	85 c0                	test   %eax,%eax
  80195e:	0f 88 70 01 00 00    	js     801ad4 <spawn+0x214>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801964:	89 c6                	mov    %eax,%esi
  801966:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  80196c:	6b f6 7c             	imul   $0x7c,%esi,%esi
  80196f:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801975:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  80197b:	b9 11 00 00 00       	mov    $0x11,%ecx
  801980:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801982:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801988:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
  80198e:	8d 8d e0 fd ff ff    	lea    -0x220(%ebp),%ecx
  801994:	8b 55 0c             	mov    0xc(%ebp),%edx
  801997:	89 d8                	mov    %ebx,%eax
  801999:	e8 8d fc ff ff       	call   80162b <init_stack>
  80199e:	85 c0                	test   %eax,%eax
  8019a0:	0f 88 3c 01 00 00    	js     801ae2 <spawn+0x222>
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr *) (elf_buf + elf->e_phoff);
  8019a6:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8019ac:	8d 9c 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%ebx
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8019b3:	be 00 00 00 00       	mov    $0x0,%esi
  8019b8:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  8019be:	eb 40                	jmp    801a00 <spawn+0x140>
		if (ph->p_type != ELF_PROG_LOAD)
  8019c0:	83 3b 01             	cmpl   $0x1,(%ebx)
  8019c3:	75 35                	jne    8019fa <spawn+0x13a>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8019c5:	8b 43 18             	mov    0x18(%ebx),%eax
  8019c8:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  8019cb:	83 f8 01             	cmp    $0x1,%eax
  8019ce:	19 c0                	sbb    %eax,%eax
  8019d0:	83 e0 fe             	and    $0xfffffffe,%eax
  8019d3:	83 c0 07             	add    $0x7,%eax
		if ((r = map_segment(child,
  8019d6:	8b 4b 14             	mov    0x14(%ebx),%ecx
  8019d9:	8b 53 08             	mov    0x8(%ebx),%edx
  8019dc:	50                   	push   %eax
  8019dd:	ff 73 04             	pushl  0x4(%ebx)
  8019e0:	ff 73 10             	pushl  0x10(%ebx)
  8019e3:	57                   	push   %edi
  8019e4:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8019ea:	e8 b2 fd ff ff       	call   8017a1 <map_segment>
  8019ef:	83 c4 10             	add    $0x10,%esp
  8019f2:	85 c0                	test   %eax,%eax
  8019f4:	0f 88 ad 00 00 00    	js     801aa7 <spawn+0x1e7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr *) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8019fa:	83 c6 01             	add    $0x1,%esi
  8019fd:	83 c3 20             	add    $0x20,%ebx
  801a00:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801a07:	39 c6                	cmp    %eax,%esi
  801a09:	7c b5                	jl     8019c0 <spawn+0x100>
		                     ph->p_filesz,
		                     ph->p_offset,
		                     perm)) < 0)
			goto error;
	}
	close(fd);
  801a0b:	83 ec 0c             	sub    $0xc,%esp
  801a0e:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801a14:	e8 d0 f4 ff ff       	call   800ee9 <close>
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  801a19:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801a1f:	e8 53 fb ff ff       	call   801577 <copy_shared_pages>
  801a24:	83 c4 10             	add    $0x10,%esp
  801a27:	85 c0                	test   %eax,%eax
  801a29:	79 15                	jns    801a40 <spawn+0x180>
		panic("copy_shared_pages: %e", r);
  801a2b:	50                   	push   %eax
  801a2c:	68 44 29 80 00       	push   $0x802944
  801a31:	68 8c 00 00 00       	push   $0x8c
  801a36:	68 01 29 80 00       	push   $0x802901
  801a3b:	e8 58 e7 ff ff       	call   800198 <_panic>

	child_tf.tf_eflags |= FL_IOPL_3;  // devious: see user/faultio.c
  801a40:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801a47:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801a4a:	83 ec 08             	sub    $0x8,%esp
  801a4d:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801a53:	50                   	push   %eax
  801a54:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801a5a:	e8 5d f2 ff ff       	call   800cbc <sys_env_set_trapframe>
  801a5f:	83 c4 10             	add    $0x10,%esp
  801a62:	85 c0                	test   %eax,%eax
  801a64:	79 15                	jns    801a7b <spawn+0x1bb>
		panic("sys_env_set_trapframe: %e", r);
  801a66:	50                   	push   %eax
  801a67:	68 5a 29 80 00       	push   $0x80295a
  801a6c:	68 90 00 00 00       	push   $0x90
  801a71:	68 01 29 80 00       	push   $0x802901
  801a76:	e8 1d e7 ff ff       	call   800198 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801a7b:	83 ec 08             	sub    $0x8,%esp
  801a7e:	6a 02                	push   $0x2
  801a80:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801a86:	e8 0e f2 ff ff       	call   800c99 <sys_env_set_status>
  801a8b:	83 c4 10             	add    $0x10,%esp
  801a8e:	85 c0                	test   %eax,%eax
  801a90:	79 4a                	jns    801adc <spawn+0x21c>
		panic("sys_env_set_status: %e", r);
  801a92:	50                   	push   %eax
  801a93:	68 74 29 80 00       	push   $0x802974
  801a98:	68 93 00 00 00       	push   $0x93
  801a9d:	68 01 29 80 00       	push   $0x802901
  801aa2:	e8 f1 e6 ff ff       	call   800198 <_panic>
  801aa7:	89 c7                	mov    %eax,%edi

	return child;

error:
	sys_env_destroy(child);
  801aa9:	83 ec 0c             	sub    $0xc,%esp
  801aac:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801ab2:	e8 08 f1 ff ff       	call   800bbf <sys_env_destroy>
	close(fd);
  801ab7:	83 c4 04             	add    $0x4,%esp
  801aba:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801ac0:	e8 24 f4 ff ff       	call   800ee9 <close>
	return r;
  801ac5:	83 c4 10             	add    $0x10,%esp
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child,
  801ac8:	89 f8                	mov    %edi,%eax
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  801aca:	eb 16                	jmp    801ae2 <spawn+0x222>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  801acc:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801ad2:	eb 0e                	jmp    801ae2 <spawn+0x222>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  801ad4:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801ada:	eb 06                	jmp    801ae2 <spawn+0x222>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  801adc:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  801ae2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ae5:	5b                   	pop    %ebx
  801ae6:	5e                   	pop    %esi
  801ae7:	5f                   	pop    %edi
  801ae8:	5d                   	pop    %ebp
  801ae9:	c3                   	ret    

00801aea <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
  801aed:	56                   	push   %esi
  801aee:	53                   	push   %ebx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc = 0;
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  801aef:	8d 55 10             	lea    0x10(%ebp),%edx
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc = 0;
  801af2:	b8 00 00 00 00       	mov    $0x0,%eax
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  801af7:	eb 03                	jmp    801afc <spawnl+0x12>
		argc++;
  801af9:	83 c0 01             	add    $0x1,%eax
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc = 0;
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  801afc:	83 c2 04             	add    $0x4,%edx
  801aff:	83 7a fc 00          	cmpl   $0x0,-0x4(%edx)
  801b03:	75 f4                	jne    801af9 <spawnl+0xf>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc + 2];
  801b05:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  801b0c:	83 e2 f0             	and    $0xfffffff0,%edx
  801b0f:	29 d4                	sub    %edx,%esp
  801b11:	8d 54 24 03          	lea    0x3(%esp),%edx
  801b15:	c1 ea 02             	shr    $0x2,%edx
  801b18:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801b1f:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801b21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b24:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc + 1] = NULL;
  801b2b:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801b32:	00 
  801b33:	89 c2                	mov    %eax,%edx

	va_start(vl, arg0);
	unsigned i;
	for (i = 0; i < argc; i++)
  801b35:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3a:	eb 0a                	jmp    801b46 <spawnl+0x5c>
		argv[i + 1] = va_arg(vl, const char *);
  801b3c:	83 c0 01             	add    $0x1,%eax
  801b3f:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  801b43:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc + 1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for (i = 0; i < argc; i++)
  801b46:	39 d0                	cmp    %edx,%eax
  801b48:	75 f2                	jne    801b3c <spawnl+0x52>
		argv[i + 1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  801b4a:	83 ec 08             	sub    $0x8,%esp
  801b4d:	56                   	push   %esi
  801b4e:	ff 75 08             	pushl  0x8(%ebp)
  801b51:	e8 6a fd ff ff       	call   8018c0 <spawn>
}
  801b56:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b59:	5b                   	pop    %ebx
  801b5a:	5e                   	pop    %esi
  801b5b:	5d                   	pop    %ebp
  801b5c:	c3                   	ret    

00801b5d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	56                   	push   %esi
  801b61:	53                   	push   %ebx
  801b62:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b65:	83 ec 0c             	sub    $0xc,%esp
  801b68:	ff 75 08             	pushl  0x8(%ebp)
  801b6b:	e8 e9 f1 ff ff       	call   800d59 <fd2data>
  801b70:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b72:	83 c4 08             	add    $0x8,%esp
  801b75:	68 b4 29 80 00       	push   $0x8029b4
  801b7a:	53                   	push   %ebx
  801b7b:	e8 63 ec ff ff       	call   8007e3 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b80:	8b 46 04             	mov    0x4(%esi),%eax
  801b83:	2b 06                	sub    (%esi),%eax
  801b85:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b8b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b92:	00 00 00 
	stat->st_dev = &devpipe;
  801b95:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b9c:	30 80 00 
	return 0;
}
  801b9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba7:	5b                   	pop    %ebx
  801ba8:	5e                   	pop    %esi
  801ba9:	5d                   	pop    %ebp
  801baa:	c3                   	ret    

00801bab <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	53                   	push   %ebx
  801baf:	83 ec 0c             	sub    $0xc,%esp
  801bb2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801bb5:	53                   	push   %ebx
  801bb6:	6a 00                	push   $0x0
  801bb8:	e8 b9 f0 ff ff       	call   800c76 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bbd:	89 1c 24             	mov    %ebx,(%esp)
  801bc0:	e8 94 f1 ff ff       	call   800d59 <fd2data>
  801bc5:	83 c4 08             	add    $0x8,%esp
  801bc8:	50                   	push   %eax
  801bc9:	6a 00                	push   $0x0
  801bcb:	e8 a6 f0 ff ff       	call   800c76 <sys_page_unmap>
}
  801bd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	57                   	push   %edi
  801bd9:	56                   	push   %esi
  801bda:	53                   	push   %ebx
  801bdb:	83 ec 1c             	sub    $0x1c,%esp
  801bde:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801be1:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801be3:	a1 04 40 80 00       	mov    0x804004,%eax
  801be8:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801beb:	83 ec 0c             	sub    $0xc,%esp
  801bee:	ff 75 e0             	pushl  -0x20(%ebp)
  801bf1:	e8 3e 05 00 00       	call   802134 <pageref>
  801bf6:	89 c3                	mov    %eax,%ebx
  801bf8:	89 3c 24             	mov    %edi,(%esp)
  801bfb:	e8 34 05 00 00       	call   802134 <pageref>
  801c00:	83 c4 10             	add    $0x10,%esp
  801c03:	39 c3                	cmp    %eax,%ebx
  801c05:	0f 94 c1             	sete   %cl
  801c08:	0f b6 c9             	movzbl %cl,%ecx
  801c0b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801c0e:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c14:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c17:	39 ce                	cmp    %ecx,%esi
  801c19:	74 1b                	je     801c36 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801c1b:	39 c3                	cmp    %eax,%ebx
  801c1d:	75 c4                	jne    801be3 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c1f:	8b 42 58             	mov    0x58(%edx),%eax
  801c22:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c25:	50                   	push   %eax
  801c26:	56                   	push   %esi
  801c27:	68 bb 29 80 00       	push   $0x8029bb
  801c2c:	e8 40 e6 ff ff       	call   800271 <cprintf>
  801c31:	83 c4 10             	add    $0x10,%esp
  801c34:	eb ad                	jmp    801be3 <_pipeisclosed+0xe>
	}
}
  801c36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c3c:	5b                   	pop    %ebx
  801c3d:	5e                   	pop    %esi
  801c3e:	5f                   	pop    %edi
  801c3f:	5d                   	pop    %ebp
  801c40:	c3                   	ret    

00801c41 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
  801c44:	57                   	push   %edi
  801c45:	56                   	push   %esi
  801c46:	53                   	push   %ebx
  801c47:	83 ec 28             	sub    $0x28,%esp
  801c4a:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801c4d:	56                   	push   %esi
  801c4e:	e8 06 f1 ff ff       	call   800d59 <fd2data>
  801c53:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c55:	83 c4 10             	add    $0x10,%esp
  801c58:	bf 00 00 00 00       	mov    $0x0,%edi
  801c5d:	eb 4b                	jmp    801caa <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801c5f:	89 da                	mov    %ebx,%edx
  801c61:	89 f0                	mov    %esi,%eax
  801c63:	e8 6d ff ff ff       	call   801bd5 <_pipeisclosed>
  801c68:	85 c0                	test   %eax,%eax
  801c6a:	75 48                	jne    801cb4 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801c6c:	e8 94 ef ff ff       	call   800c05 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c71:	8b 43 04             	mov    0x4(%ebx),%eax
  801c74:	8b 0b                	mov    (%ebx),%ecx
  801c76:	8d 51 20             	lea    0x20(%ecx),%edx
  801c79:	39 d0                	cmp    %edx,%eax
  801c7b:	73 e2                	jae    801c5f <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c80:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c84:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c87:	89 c2                	mov    %eax,%edx
  801c89:	c1 fa 1f             	sar    $0x1f,%edx
  801c8c:	89 d1                	mov    %edx,%ecx
  801c8e:	c1 e9 1b             	shr    $0x1b,%ecx
  801c91:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c94:	83 e2 1f             	and    $0x1f,%edx
  801c97:	29 ca                	sub    %ecx,%edx
  801c99:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c9d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ca1:	83 c0 01             	add    $0x1,%eax
  801ca4:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ca7:	83 c7 01             	add    $0x1,%edi
  801caa:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801cad:	75 c2                	jne    801c71 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801caf:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb2:	eb 05                	jmp    801cb9 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801cb4:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801cb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cbc:	5b                   	pop    %ebx
  801cbd:	5e                   	pop    %esi
  801cbe:	5f                   	pop    %edi
  801cbf:	5d                   	pop    %ebp
  801cc0:	c3                   	ret    

00801cc1 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
  801cc4:	57                   	push   %edi
  801cc5:	56                   	push   %esi
  801cc6:	53                   	push   %ebx
  801cc7:	83 ec 18             	sub    $0x18,%esp
  801cca:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801ccd:	57                   	push   %edi
  801cce:	e8 86 f0 ff ff       	call   800d59 <fd2data>
  801cd3:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801cd5:	83 c4 10             	add    $0x10,%esp
  801cd8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cdd:	eb 3d                	jmp    801d1c <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801cdf:	85 db                	test   %ebx,%ebx
  801ce1:	74 04                	je     801ce7 <devpipe_read+0x26>
				return i;
  801ce3:	89 d8                	mov    %ebx,%eax
  801ce5:	eb 44                	jmp    801d2b <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801ce7:	89 f2                	mov    %esi,%edx
  801ce9:	89 f8                	mov    %edi,%eax
  801ceb:	e8 e5 fe ff ff       	call   801bd5 <_pipeisclosed>
  801cf0:	85 c0                	test   %eax,%eax
  801cf2:	75 32                	jne    801d26 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801cf4:	e8 0c ef ff ff       	call   800c05 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801cf9:	8b 06                	mov    (%esi),%eax
  801cfb:	3b 46 04             	cmp    0x4(%esi),%eax
  801cfe:	74 df                	je     801cdf <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d00:	99                   	cltd   
  801d01:	c1 ea 1b             	shr    $0x1b,%edx
  801d04:	01 d0                	add    %edx,%eax
  801d06:	83 e0 1f             	and    $0x1f,%eax
  801d09:	29 d0                	sub    %edx,%eax
  801d0b:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801d10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d13:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801d16:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d19:	83 c3 01             	add    $0x1,%ebx
  801d1c:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801d1f:	75 d8                	jne    801cf9 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801d21:	8b 45 10             	mov    0x10(%ebp),%eax
  801d24:	eb 05                	jmp    801d2b <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801d26:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801d2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d2e:	5b                   	pop    %ebx
  801d2f:	5e                   	pop    %esi
  801d30:	5f                   	pop    %edi
  801d31:	5d                   	pop    %ebp
  801d32:	c3                   	ret    

00801d33 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	56                   	push   %esi
  801d37:	53                   	push   %ebx
  801d38:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801d3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d3e:	50                   	push   %eax
  801d3f:	e8 2d f0 ff ff       	call   800d71 <fd_alloc>
  801d44:	83 c4 10             	add    $0x10,%esp
  801d47:	89 c2                	mov    %eax,%edx
  801d49:	85 c0                	test   %eax,%eax
  801d4b:	0f 88 2c 01 00 00    	js     801e7d <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d51:	83 ec 04             	sub    $0x4,%esp
  801d54:	68 07 04 00 00       	push   $0x407
  801d59:	ff 75 f4             	pushl  -0xc(%ebp)
  801d5c:	6a 00                	push   $0x0
  801d5e:	e8 c9 ee ff ff       	call   800c2c <sys_page_alloc>
  801d63:	83 c4 10             	add    $0x10,%esp
  801d66:	89 c2                	mov    %eax,%edx
  801d68:	85 c0                	test   %eax,%eax
  801d6a:	0f 88 0d 01 00 00    	js     801e7d <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801d70:	83 ec 0c             	sub    $0xc,%esp
  801d73:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d76:	50                   	push   %eax
  801d77:	e8 f5 ef ff ff       	call   800d71 <fd_alloc>
  801d7c:	89 c3                	mov    %eax,%ebx
  801d7e:	83 c4 10             	add    $0x10,%esp
  801d81:	85 c0                	test   %eax,%eax
  801d83:	0f 88 e2 00 00 00    	js     801e6b <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d89:	83 ec 04             	sub    $0x4,%esp
  801d8c:	68 07 04 00 00       	push   $0x407
  801d91:	ff 75 f0             	pushl  -0x10(%ebp)
  801d94:	6a 00                	push   $0x0
  801d96:	e8 91 ee ff ff       	call   800c2c <sys_page_alloc>
  801d9b:	89 c3                	mov    %eax,%ebx
  801d9d:	83 c4 10             	add    $0x10,%esp
  801da0:	85 c0                	test   %eax,%eax
  801da2:	0f 88 c3 00 00 00    	js     801e6b <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801da8:	83 ec 0c             	sub    $0xc,%esp
  801dab:	ff 75 f4             	pushl  -0xc(%ebp)
  801dae:	e8 a6 ef ff ff       	call   800d59 <fd2data>
  801db3:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801db5:	83 c4 0c             	add    $0xc,%esp
  801db8:	68 07 04 00 00       	push   $0x407
  801dbd:	50                   	push   %eax
  801dbe:	6a 00                	push   $0x0
  801dc0:	e8 67 ee ff ff       	call   800c2c <sys_page_alloc>
  801dc5:	89 c3                	mov    %eax,%ebx
  801dc7:	83 c4 10             	add    $0x10,%esp
  801dca:	85 c0                	test   %eax,%eax
  801dcc:	0f 88 89 00 00 00    	js     801e5b <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dd2:	83 ec 0c             	sub    $0xc,%esp
  801dd5:	ff 75 f0             	pushl  -0x10(%ebp)
  801dd8:	e8 7c ef ff ff       	call   800d59 <fd2data>
  801ddd:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801de4:	50                   	push   %eax
  801de5:	6a 00                	push   $0x0
  801de7:	56                   	push   %esi
  801de8:	6a 00                	push   $0x0
  801dea:	e8 61 ee ff ff       	call   800c50 <sys_page_map>
  801def:	89 c3                	mov    %eax,%ebx
  801df1:	83 c4 20             	add    $0x20,%esp
  801df4:	85 c0                	test   %eax,%eax
  801df6:	78 55                	js     801e4d <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801df8:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e01:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e06:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801e0d:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e16:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e1b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801e22:	83 ec 0c             	sub    $0xc,%esp
  801e25:	ff 75 f4             	pushl  -0xc(%ebp)
  801e28:	e8 1c ef ff ff       	call   800d49 <fd2num>
  801e2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e30:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e32:	83 c4 04             	add    $0x4,%esp
  801e35:	ff 75 f0             	pushl  -0x10(%ebp)
  801e38:	e8 0c ef ff ff       	call   800d49 <fd2num>
  801e3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e40:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e43:	83 c4 10             	add    $0x10,%esp
  801e46:	ba 00 00 00 00       	mov    $0x0,%edx
  801e4b:	eb 30                	jmp    801e7d <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801e4d:	83 ec 08             	sub    $0x8,%esp
  801e50:	56                   	push   %esi
  801e51:	6a 00                	push   $0x0
  801e53:	e8 1e ee ff ff       	call   800c76 <sys_page_unmap>
  801e58:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801e5b:	83 ec 08             	sub    $0x8,%esp
  801e5e:	ff 75 f0             	pushl  -0x10(%ebp)
  801e61:	6a 00                	push   $0x0
  801e63:	e8 0e ee ff ff       	call   800c76 <sys_page_unmap>
  801e68:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801e6b:	83 ec 08             	sub    $0x8,%esp
  801e6e:	ff 75 f4             	pushl  -0xc(%ebp)
  801e71:	6a 00                	push   $0x0
  801e73:	e8 fe ed ff ff       	call   800c76 <sys_page_unmap>
  801e78:	83 c4 10             	add    $0x10,%esp
  801e7b:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  801e7d:	89 d0                	mov    %edx,%eax
  801e7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e82:	5b                   	pop    %ebx
  801e83:	5e                   	pop    %esi
  801e84:	5d                   	pop    %ebp
  801e85:	c3                   	ret    

00801e86 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
  801e89:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e8f:	50                   	push   %eax
  801e90:	ff 75 08             	pushl  0x8(%ebp)
  801e93:	e8 28 ef ff ff       	call   800dc0 <fd_lookup>
  801e98:	83 c4 10             	add    $0x10,%esp
  801e9b:	85 c0                	test   %eax,%eax
  801e9d:	78 18                	js     801eb7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801e9f:	83 ec 0c             	sub    $0xc,%esp
  801ea2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea5:	e8 af ee ff ff       	call   800d59 <fd2data>
	return _pipeisclosed(fd, p);
  801eaa:	89 c2                	mov    %eax,%edx
  801eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaf:	e8 21 fd ff ff       	call   801bd5 <_pipeisclosed>
  801eb4:	83 c4 10             	add    $0x10,%esp
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801ebc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec1:	5d                   	pop    %ebp
  801ec2:	c3                   	ret    

00801ec3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
  801ec6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ec9:	68 d3 29 80 00       	push   $0x8029d3
  801ece:	ff 75 0c             	pushl  0xc(%ebp)
  801ed1:	e8 0d e9 ff ff       	call   8007e3 <strcpy>
	return 0;
}
  801ed6:	b8 00 00 00 00       	mov    $0x0,%eax
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
  801ee0:	57                   	push   %edi
  801ee1:	56                   	push   %esi
  801ee2:	53                   	push   %ebx
  801ee3:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801ee9:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801eee:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801ef4:	eb 2d                	jmp    801f23 <devcons_write+0x46>
		m = n - tot;
  801ef6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ef9:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801efb:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801efe:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801f03:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801f06:	83 ec 04             	sub    $0x4,%esp
  801f09:	53                   	push   %ebx
  801f0a:	03 45 0c             	add    0xc(%ebp),%eax
  801f0d:	50                   	push   %eax
  801f0e:	57                   	push   %edi
  801f0f:	e8 62 ea ff ff       	call   800976 <memmove>
		sys_cputs(buf, m);
  801f14:	83 c4 08             	add    $0x8,%esp
  801f17:	53                   	push   %ebx
  801f18:	57                   	push   %edi
  801f19:	e8 57 ec ff ff       	call   800b75 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801f1e:	01 de                	add    %ebx,%esi
  801f20:	83 c4 10             	add    $0x10,%esp
  801f23:	89 f0                	mov    %esi,%eax
  801f25:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f28:	72 cc                	jb     801ef6 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801f2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f2d:	5b                   	pop    %ebx
  801f2e:	5e                   	pop    %esi
  801f2f:	5f                   	pop    %edi
  801f30:	5d                   	pop    %ebp
  801f31:	c3                   	ret    

00801f32 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
  801f35:	83 ec 08             	sub    $0x8,%esp
  801f38:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801f3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f41:	74 2a                	je     801f6d <devcons_read+0x3b>
  801f43:	eb 05                	jmp    801f4a <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801f45:	e8 bb ec ff ff       	call   800c05 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801f4a:	e8 4c ec ff ff       	call   800b9b <sys_cgetc>
  801f4f:	85 c0                	test   %eax,%eax
  801f51:	74 f2                	je     801f45 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801f53:	85 c0                	test   %eax,%eax
  801f55:	78 16                	js     801f6d <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801f57:	83 f8 04             	cmp    $0x4,%eax
  801f5a:	74 0c                	je     801f68 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801f5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5f:	88 02                	mov    %al,(%edx)
	return 1;
  801f61:	b8 01 00 00 00       	mov    $0x1,%eax
  801f66:	eb 05                	jmp    801f6d <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801f68:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
  801f72:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801f7b:	6a 01                	push   $0x1
  801f7d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f80:	50                   	push   %eax
  801f81:	e8 ef eb ff ff       	call   800b75 <sys_cputs>
}
  801f86:	83 c4 10             	add    $0x10,%esp
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <getchar>:

int
getchar(void)
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801f91:	6a 01                	push   $0x1
  801f93:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f96:	50                   	push   %eax
  801f97:	6a 00                	push   $0x0
  801f99:	e8 87 f0 ff ff       	call   801025 <read>
	if (r < 0)
  801f9e:	83 c4 10             	add    $0x10,%esp
  801fa1:	85 c0                	test   %eax,%eax
  801fa3:	78 0f                	js     801fb4 <getchar+0x29>
		return r;
	if (r < 1)
  801fa5:	85 c0                	test   %eax,%eax
  801fa7:	7e 06                	jle    801faf <getchar+0x24>
		return -E_EOF;
	return c;
  801fa9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801fad:	eb 05                	jmp    801fb4 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801faf:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fbc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fbf:	50                   	push   %eax
  801fc0:	ff 75 08             	pushl  0x8(%ebp)
  801fc3:	e8 f8 ed ff ff       	call   800dc0 <fd_lookup>
  801fc8:	83 c4 10             	add    $0x10,%esp
  801fcb:	85 c0                	test   %eax,%eax
  801fcd:	78 11                	js     801fe0 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fd8:	39 10                	cmp    %edx,(%eax)
  801fda:	0f 94 c0             	sete   %al
  801fdd:	0f b6 c0             	movzbl %al,%eax
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <opencons>:

int
opencons(void)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
  801fe5:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801fe8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801feb:	50                   	push   %eax
  801fec:	e8 80 ed ff ff       	call   800d71 <fd_alloc>
  801ff1:	83 c4 10             	add    $0x10,%esp
		return r;
  801ff4:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801ff6:	85 c0                	test   %eax,%eax
  801ff8:	78 3e                	js     802038 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ffa:	83 ec 04             	sub    $0x4,%esp
  801ffd:	68 07 04 00 00       	push   $0x407
  802002:	ff 75 f4             	pushl  -0xc(%ebp)
  802005:	6a 00                	push   $0x0
  802007:	e8 20 ec ff ff       	call   800c2c <sys_page_alloc>
  80200c:	83 c4 10             	add    $0x10,%esp
		return r;
  80200f:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802011:	85 c0                	test   %eax,%eax
  802013:	78 23                	js     802038 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802015:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80201b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802023:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80202a:	83 ec 0c             	sub    $0xc,%esp
  80202d:	50                   	push   %eax
  80202e:	e8 16 ed ff ff       	call   800d49 <fd2num>
  802033:	89 c2                	mov    %eax,%edx
  802035:	83 c4 10             	add    $0x10,%esp
}
  802038:	89 d0                	mov    %edx,%eax
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    

0080203c <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
  80203f:	56                   	push   %esi
  802040:	53                   	push   %ebx
  802041:	8b 75 08             	mov    0x8(%ebp),%esi
  802044:	8b 45 0c             	mov    0xc(%ebp),%eax
  802047:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  80204a:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  80204c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802051:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  802054:	83 ec 0c             	sub    $0xc,%esp
  802057:	50                   	push   %eax
  802058:	e8 ca ec ff ff       	call   800d27 <sys_ipc_recv>
	if (from_env_store)
  80205d:	83 c4 10             	add    $0x10,%esp
  802060:	85 f6                	test   %esi,%esi
  802062:	74 0b                	je     80206f <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  802064:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80206a:	8b 52 74             	mov    0x74(%edx),%edx
  80206d:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  80206f:	85 db                	test   %ebx,%ebx
  802071:	74 0b                	je     80207e <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  802073:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802079:	8b 52 78             	mov    0x78(%edx),%edx
  80207c:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  80207e:	85 c0                	test   %eax,%eax
  802080:	79 16                	jns    802098 <ipc_recv+0x5c>
		if (from_env_store)
  802082:	85 f6                	test   %esi,%esi
  802084:	74 06                	je     80208c <ipc_recv+0x50>
			*from_env_store = 0;
  802086:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  80208c:	85 db                	test   %ebx,%ebx
  80208e:	74 10                	je     8020a0 <ipc_recv+0x64>
			*perm_store = 0;
  802090:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802096:	eb 08                	jmp    8020a0 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  802098:	a1 04 40 80 00       	mov    0x804004,%eax
  80209d:	8b 40 70             	mov    0x70(%eax),%eax
}
  8020a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020a3:	5b                   	pop    %ebx
  8020a4:	5e                   	pop    %esi
  8020a5:	5d                   	pop    %ebp
  8020a6:	c3                   	ret    

008020a7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	57                   	push   %edi
  8020ab:	56                   	push   %esi
  8020ac:	53                   	push   %ebx
  8020ad:	83 ec 0c             	sub    $0xc,%esp
  8020b0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020b3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  8020b9:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  8020bb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020c0:	0f 44 d8             	cmove  %eax,%ebx
  8020c3:	eb 1c                	jmp    8020e1 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  8020c5:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020c8:	74 12                	je     8020dc <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  8020ca:	50                   	push   %eax
  8020cb:	68 df 29 80 00       	push   $0x8029df
  8020d0:	6a 42                	push   $0x42
  8020d2:	68 f5 29 80 00       	push   $0x8029f5
  8020d7:	e8 bc e0 ff ff       	call   800198 <_panic>
		sys_yield();
  8020dc:	e8 24 eb ff ff       	call   800c05 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  8020e1:	ff 75 14             	pushl  0x14(%ebp)
  8020e4:	53                   	push   %ebx
  8020e5:	56                   	push   %esi
  8020e6:	57                   	push   %edi
  8020e7:	e8 16 ec ff ff       	call   800d02 <sys_ipc_try_send>
  8020ec:	83 c4 10             	add    $0x10,%esp
  8020ef:	85 c0                	test   %eax,%eax
  8020f1:	75 d2                	jne    8020c5 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  8020f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020f6:	5b                   	pop    %ebx
  8020f7:	5e                   	pop    %esi
  8020f8:	5f                   	pop    %edi
  8020f9:	5d                   	pop    %ebp
  8020fa:	c3                   	ret    

008020fb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
  8020fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802101:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802106:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802109:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80210f:	8b 52 50             	mov    0x50(%edx),%edx
  802112:	39 ca                	cmp    %ecx,%edx
  802114:	75 0d                	jne    802123 <ipc_find_env+0x28>
			return envs[i].env_id;
  802116:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802119:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80211e:	8b 40 48             	mov    0x48(%eax),%eax
  802121:	eb 0f                	jmp    802132 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802123:	83 c0 01             	add    $0x1,%eax
  802126:	3d 00 04 00 00       	cmp    $0x400,%eax
  80212b:	75 d9                	jne    802106 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80212d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802132:	5d                   	pop    %ebp
  802133:	c3                   	ret    

00802134 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
  802137:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80213a:	89 d0                	mov    %edx,%eax
  80213c:	c1 e8 16             	shr    $0x16,%eax
  80213f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802146:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80214b:	f6 c1 01             	test   $0x1,%cl
  80214e:	74 1d                	je     80216d <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802150:	c1 ea 0c             	shr    $0xc,%edx
  802153:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80215a:	f6 c2 01             	test   $0x1,%dl
  80215d:	74 0e                	je     80216d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80215f:	c1 ea 0c             	shr    $0xc,%edx
  802162:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802169:	ef 
  80216a:	0f b7 c0             	movzwl %ax,%eax
}
  80216d:	5d                   	pop    %ebp
  80216e:	c3                   	ret    
  80216f:	90                   	nop

00802170 <__udivdi3>:
  802170:	55                   	push   %ebp
  802171:	57                   	push   %edi
  802172:	56                   	push   %esi
  802173:	53                   	push   %ebx
  802174:	83 ec 1c             	sub    $0x1c,%esp
  802177:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80217b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80217f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802183:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802187:	85 f6                	test   %esi,%esi
  802189:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80218d:	89 ca                	mov    %ecx,%edx
  80218f:	89 f8                	mov    %edi,%eax
  802191:	75 3d                	jne    8021d0 <__udivdi3+0x60>
  802193:	39 cf                	cmp    %ecx,%edi
  802195:	0f 87 c5 00 00 00    	ja     802260 <__udivdi3+0xf0>
  80219b:	85 ff                	test   %edi,%edi
  80219d:	89 fd                	mov    %edi,%ebp
  80219f:	75 0b                	jne    8021ac <__udivdi3+0x3c>
  8021a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8021a6:	31 d2                	xor    %edx,%edx
  8021a8:	f7 f7                	div    %edi
  8021aa:	89 c5                	mov    %eax,%ebp
  8021ac:	89 c8                	mov    %ecx,%eax
  8021ae:	31 d2                	xor    %edx,%edx
  8021b0:	f7 f5                	div    %ebp
  8021b2:	89 c1                	mov    %eax,%ecx
  8021b4:	89 d8                	mov    %ebx,%eax
  8021b6:	89 cf                	mov    %ecx,%edi
  8021b8:	f7 f5                	div    %ebp
  8021ba:	89 c3                	mov    %eax,%ebx
  8021bc:	89 d8                	mov    %ebx,%eax
  8021be:	89 fa                	mov    %edi,%edx
  8021c0:	83 c4 1c             	add    $0x1c,%esp
  8021c3:	5b                   	pop    %ebx
  8021c4:	5e                   	pop    %esi
  8021c5:	5f                   	pop    %edi
  8021c6:	5d                   	pop    %ebp
  8021c7:	c3                   	ret    
  8021c8:	90                   	nop
  8021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021d0:	39 ce                	cmp    %ecx,%esi
  8021d2:	77 74                	ja     802248 <__udivdi3+0xd8>
  8021d4:	0f bd fe             	bsr    %esi,%edi
  8021d7:	83 f7 1f             	xor    $0x1f,%edi
  8021da:	0f 84 98 00 00 00    	je     802278 <__udivdi3+0x108>
  8021e0:	bb 20 00 00 00       	mov    $0x20,%ebx
  8021e5:	89 f9                	mov    %edi,%ecx
  8021e7:	89 c5                	mov    %eax,%ebp
  8021e9:	29 fb                	sub    %edi,%ebx
  8021eb:	d3 e6                	shl    %cl,%esi
  8021ed:	89 d9                	mov    %ebx,%ecx
  8021ef:	d3 ed                	shr    %cl,%ebp
  8021f1:	89 f9                	mov    %edi,%ecx
  8021f3:	d3 e0                	shl    %cl,%eax
  8021f5:	09 ee                	or     %ebp,%esi
  8021f7:	89 d9                	mov    %ebx,%ecx
  8021f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021fd:	89 d5                	mov    %edx,%ebp
  8021ff:	8b 44 24 08          	mov    0x8(%esp),%eax
  802203:	d3 ed                	shr    %cl,%ebp
  802205:	89 f9                	mov    %edi,%ecx
  802207:	d3 e2                	shl    %cl,%edx
  802209:	89 d9                	mov    %ebx,%ecx
  80220b:	d3 e8                	shr    %cl,%eax
  80220d:	09 c2                	or     %eax,%edx
  80220f:	89 d0                	mov    %edx,%eax
  802211:	89 ea                	mov    %ebp,%edx
  802213:	f7 f6                	div    %esi
  802215:	89 d5                	mov    %edx,%ebp
  802217:	89 c3                	mov    %eax,%ebx
  802219:	f7 64 24 0c          	mull   0xc(%esp)
  80221d:	39 d5                	cmp    %edx,%ebp
  80221f:	72 10                	jb     802231 <__udivdi3+0xc1>
  802221:	8b 74 24 08          	mov    0x8(%esp),%esi
  802225:	89 f9                	mov    %edi,%ecx
  802227:	d3 e6                	shl    %cl,%esi
  802229:	39 c6                	cmp    %eax,%esi
  80222b:	73 07                	jae    802234 <__udivdi3+0xc4>
  80222d:	39 d5                	cmp    %edx,%ebp
  80222f:	75 03                	jne    802234 <__udivdi3+0xc4>
  802231:	83 eb 01             	sub    $0x1,%ebx
  802234:	31 ff                	xor    %edi,%edi
  802236:	89 d8                	mov    %ebx,%eax
  802238:	89 fa                	mov    %edi,%edx
  80223a:	83 c4 1c             	add    $0x1c,%esp
  80223d:	5b                   	pop    %ebx
  80223e:	5e                   	pop    %esi
  80223f:	5f                   	pop    %edi
  802240:	5d                   	pop    %ebp
  802241:	c3                   	ret    
  802242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802248:	31 ff                	xor    %edi,%edi
  80224a:	31 db                	xor    %ebx,%ebx
  80224c:	89 d8                	mov    %ebx,%eax
  80224e:	89 fa                	mov    %edi,%edx
  802250:	83 c4 1c             	add    $0x1c,%esp
  802253:	5b                   	pop    %ebx
  802254:	5e                   	pop    %esi
  802255:	5f                   	pop    %edi
  802256:	5d                   	pop    %ebp
  802257:	c3                   	ret    
  802258:	90                   	nop
  802259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802260:	89 d8                	mov    %ebx,%eax
  802262:	f7 f7                	div    %edi
  802264:	31 ff                	xor    %edi,%edi
  802266:	89 c3                	mov    %eax,%ebx
  802268:	89 d8                	mov    %ebx,%eax
  80226a:	89 fa                	mov    %edi,%edx
  80226c:	83 c4 1c             	add    $0x1c,%esp
  80226f:	5b                   	pop    %ebx
  802270:	5e                   	pop    %esi
  802271:	5f                   	pop    %edi
  802272:	5d                   	pop    %ebp
  802273:	c3                   	ret    
  802274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802278:	39 ce                	cmp    %ecx,%esi
  80227a:	72 0c                	jb     802288 <__udivdi3+0x118>
  80227c:	31 db                	xor    %ebx,%ebx
  80227e:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802282:	0f 87 34 ff ff ff    	ja     8021bc <__udivdi3+0x4c>
  802288:	bb 01 00 00 00       	mov    $0x1,%ebx
  80228d:	e9 2a ff ff ff       	jmp    8021bc <__udivdi3+0x4c>
  802292:	66 90                	xchg   %ax,%ax
  802294:	66 90                	xchg   %ax,%ax
  802296:	66 90                	xchg   %ax,%ax
  802298:	66 90                	xchg   %ax,%ax
  80229a:	66 90                	xchg   %ax,%ax
  80229c:	66 90                	xchg   %ax,%ax
  80229e:	66 90                	xchg   %ax,%ax

008022a0 <__umoddi3>:
  8022a0:	55                   	push   %ebp
  8022a1:	57                   	push   %edi
  8022a2:	56                   	push   %esi
  8022a3:	53                   	push   %ebx
  8022a4:	83 ec 1c             	sub    $0x1c,%esp
  8022a7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022ab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8022af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022b7:	85 d2                	test   %edx,%edx
  8022b9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8022bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022c1:	89 f3                	mov    %esi,%ebx
  8022c3:	89 3c 24             	mov    %edi,(%esp)
  8022c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022ca:	75 1c                	jne    8022e8 <__umoddi3+0x48>
  8022cc:	39 f7                	cmp    %esi,%edi
  8022ce:	76 50                	jbe    802320 <__umoddi3+0x80>
  8022d0:	89 c8                	mov    %ecx,%eax
  8022d2:	89 f2                	mov    %esi,%edx
  8022d4:	f7 f7                	div    %edi
  8022d6:	89 d0                	mov    %edx,%eax
  8022d8:	31 d2                	xor    %edx,%edx
  8022da:	83 c4 1c             	add    $0x1c,%esp
  8022dd:	5b                   	pop    %ebx
  8022de:	5e                   	pop    %esi
  8022df:	5f                   	pop    %edi
  8022e0:	5d                   	pop    %ebp
  8022e1:	c3                   	ret    
  8022e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022e8:	39 f2                	cmp    %esi,%edx
  8022ea:	89 d0                	mov    %edx,%eax
  8022ec:	77 52                	ja     802340 <__umoddi3+0xa0>
  8022ee:	0f bd ea             	bsr    %edx,%ebp
  8022f1:	83 f5 1f             	xor    $0x1f,%ebp
  8022f4:	75 5a                	jne    802350 <__umoddi3+0xb0>
  8022f6:	3b 54 24 04          	cmp    0x4(%esp),%edx
  8022fa:	0f 82 e0 00 00 00    	jb     8023e0 <__umoddi3+0x140>
  802300:	39 0c 24             	cmp    %ecx,(%esp)
  802303:	0f 86 d7 00 00 00    	jbe    8023e0 <__umoddi3+0x140>
  802309:	8b 44 24 08          	mov    0x8(%esp),%eax
  80230d:	8b 54 24 04          	mov    0x4(%esp),%edx
  802311:	83 c4 1c             	add    $0x1c,%esp
  802314:	5b                   	pop    %ebx
  802315:	5e                   	pop    %esi
  802316:	5f                   	pop    %edi
  802317:	5d                   	pop    %ebp
  802318:	c3                   	ret    
  802319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802320:	85 ff                	test   %edi,%edi
  802322:	89 fd                	mov    %edi,%ebp
  802324:	75 0b                	jne    802331 <__umoddi3+0x91>
  802326:	b8 01 00 00 00       	mov    $0x1,%eax
  80232b:	31 d2                	xor    %edx,%edx
  80232d:	f7 f7                	div    %edi
  80232f:	89 c5                	mov    %eax,%ebp
  802331:	89 f0                	mov    %esi,%eax
  802333:	31 d2                	xor    %edx,%edx
  802335:	f7 f5                	div    %ebp
  802337:	89 c8                	mov    %ecx,%eax
  802339:	f7 f5                	div    %ebp
  80233b:	89 d0                	mov    %edx,%eax
  80233d:	eb 99                	jmp    8022d8 <__umoddi3+0x38>
  80233f:	90                   	nop
  802340:	89 c8                	mov    %ecx,%eax
  802342:	89 f2                	mov    %esi,%edx
  802344:	83 c4 1c             	add    $0x1c,%esp
  802347:	5b                   	pop    %ebx
  802348:	5e                   	pop    %esi
  802349:	5f                   	pop    %edi
  80234a:	5d                   	pop    %ebp
  80234b:	c3                   	ret    
  80234c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802350:	8b 34 24             	mov    (%esp),%esi
  802353:	bf 20 00 00 00       	mov    $0x20,%edi
  802358:	89 e9                	mov    %ebp,%ecx
  80235a:	29 ef                	sub    %ebp,%edi
  80235c:	d3 e0                	shl    %cl,%eax
  80235e:	89 f9                	mov    %edi,%ecx
  802360:	89 f2                	mov    %esi,%edx
  802362:	d3 ea                	shr    %cl,%edx
  802364:	89 e9                	mov    %ebp,%ecx
  802366:	09 c2                	or     %eax,%edx
  802368:	89 d8                	mov    %ebx,%eax
  80236a:	89 14 24             	mov    %edx,(%esp)
  80236d:	89 f2                	mov    %esi,%edx
  80236f:	d3 e2                	shl    %cl,%edx
  802371:	89 f9                	mov    %edi,%ecx
  802373:	89 54 24 04          	mov    %edx,0x4(%esp)
  802377:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80237b:	d3 e8                	shr    %cl,%eax
  80237d:	89 e9                	mov    %ebp,%ecx
  80237f:	89 c6                	mov    %eax,%esi
  802381:	d3 e3                	shl    %cl,%ebx
  802383:	89 f9                	mov    %edi,%ecx
  802385:	89 d0                	mov    %edx,%eax
  802387:	d3 e8                	shr    %cl,%eax
  802389:	89 e9                	mov    %ebp,%ecx
  80238b:	09 d8                	or     %ebx,%eax
  80238d:	89 d3                	mov    %edx,%ebx
  80238f:	89 f2                	mov    %esi,%edx
  802391:	f7 34 24             	divl   (%esp)
  802394:	89 d6                	mov    %edx,%esi
  802396:	d3 e3                	shl    %cl,%ebx
  802398:	f7 64 24 04          	mull   0x4(%esp)
  80239c:	39 d6                	cmp    %edx,%esi
  80239e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023a2:	89 d1                	mov    %edx,%ecx
  8023a4:	89 c3                	mov    %eax,%ebx
  8023a6:	72 08                	jb     8023b0 <__umoddi3+0x110>
  8023a8:	75 11                	jne    8023bb <__umoddi3+0x11b>
  8023aa:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8023ae:	73 0b                	jae    8023bb <__umoddi3+0x11b>
  8023b0:	2b 44 24 04          	sub    0x4(%esp),%eax
  8023b4:	1b 14 24             	sbb    (%esp),%edx
  8023b7:	89 d1                	mov    %edx,%ecx
  8023b9:	89 c3                	mov    %eax,%ebx
  8023bb:	8b 54 24 08          	mov    0x8(%esp),%edx
  8023bf:	29 da                	sub    %ebx,%edx
  8023c1:	19 ce                	sbb    %ecx,%esi
  8023c3:	89 f9                	mov    %edi,%ecx
  8023c5:	89 f0                	mov    %esi,%eax
  8023c7:	d3 e0                	shl    %cl,%eax
  8023c9:	89 e9                	mov    %ebp,%ecx
  8023cb:	d3 ea                	shr    %cl,%edx
  8023cd:	89 e9                	mov    %ebp,%ecx
  8023cf:	d3 ee                	shr    %cl,%esi
  8023d1:	09 d0                	or     %edx,%eax
  8023d3:	89 f2                	mov    %esi,%edx
  8023d5:	83 c4 1c             	add    $0x1c,%esp
  8023d8:	5b                   	pop    %ebx
  8023d9:	5e                   	pop    %esi
  8023da:	5f                   	pop    %edi
  8023db:	5d                   	pop    %ebp
  8023dc:	c3                   	ret    
  8023dd:	8d 76 00             	lea    0x0(%esi),%esi
  8023e0:	29 f9                	sub    %edi,%ecx
  8023e2:	19 d6                	sbb    %edx,%esi
  8023e4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023e8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023ec:	e9 18 ff ff ff       	jmp    802309 <__umoddi3+0x69>
