
obj/user/cat.debug:     formato del fichero elf32-i386


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
  80002c:	e8 02 01 00 00       	call   800133 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80003b:	eb 2f                	jmp    80006c <cat+0x39>
		if ((r = write(1, buf, n)) != n)
  80003d:	83 ec 04             	sub    $0x4,%esp
  800040:	53                   	push   %ebx
  800041:	68 20 40 80 00       	push   $0x804020
  800046:	6a 01                	push   $0x1
  800048:	e8 b1 10 00 00       	call   8010fe <write>
  80004d:	83 c4 10             	add    $0x10,%esp
  800050:	39 c3                	cmp    %eax,%ebx
  800052:	74 18                	je     80006c <cat+0x39>
			panic("write error copying %s: %e", s, r);
  800054:	83 ec 0c             	sub    $0xc,%esp
  800057:	50                   	push   %eax
  800058:	ff 75 0c             	pushl  0xc(%ebp)
  80005b:	68 40 1f 80 00       	push   $0x801f40
  800060:	6a 0d                	push   $0xd
  800062:	68 5b 1f 80 00       	push   $0x801f5b
  800067:	e8 2b 01 00 00       	call   800197 <_panic>
cat(int f, char *s)
{
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80006c:	83 ec 04             	sub    $0x4,%esp
  80006f:	68 00 20 00 00       	push   $0x2000
  800074:	68 20 40 80 00       	push   $0x804020
  800079:	56                   	push   %esi
  80007a:	e8 a5 0f 00 00       	call   801024 <read>
  80007f:	89 c3                	mov    %eax,%ebx
  800081:	83 c4 10             	add    $0x10,%esp
  800084:	85 c0                	test   %eax,%eax
  800086:	7f b5                	jg     80003d <cat+0xa>
		if ((r = write(1, buf, n)) != n)
			panic("write error copying %s: %e", s, r);
	if (n < 0)
  800088:	85 c0                	test   %eax,%eax
  80008a:	79 18                	jns    8000a4 <cat+0x71>
		panic("error reading %s: %e", s, n);
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	50                   	push   %eax
  800090:	ff 75 0c             	pushl  0xc(%ebp)
  800093:	68 66 1f 80 00       	push   $0x801f66
  800098:	6a 0f                	push   $0xf
  80009a:	68 5b 1f 80 00       	push   $0x801f5b
  80009f:	e8 f3 00 00 00       	call   800197 <_panic>
}
  8000a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a7:	5b                   	pop    %ebx
  8000a8:	5e                   	pop    %esi
  8000a9:	5d                   	pop    %ebp
  8000aa:	c3                   	ret    

008000ab <umain>:

void
umain(int argc, char **argv)
{
  8000ab:	55                   	push   %ebp
  8000ac:	89 e5                	mov    %esp,%ebp
  8000ae:	57                   	push   %edi
  8000af:	56                   	push   %esi
  8000b0:	53                   	push   %ebx
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int f, i;

	binaryname = "cat";
  8000b7:	c7 05 00 30 80 00 7b 	movl   $0x801f7b,0x803000
  8000be:	1f 80 00 
  8000c1:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  8000c6:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ca:	75 5a                	jne    800126 <umain+0x7b>
		cat(0, "<stdin>");
  8000cc:	83 ec 08             	sub    $0x8,%esp
  8000cf:	68 7f 1f 80 00       	push   $0x801f7f
  8000d4:	6a 00                	push   $0x0
  8000d6:	e8 58 ff ff ff       	call   800033 <cat>
  8000db:	83 c4 10             	add    $0x10,%esp
  8000de:	eb 4b                	jmp    80012b <umain+0x80>
	else
		for (i = 1; i < argc; i++) {
			f = open(argv[i], O_RDONLY);
  8000e0:	83 ec 08             	sub    $0x8,%esp
  8000e3:	6a 00                	push   $0x0
  8000e5:	ff 34 9f             	pushl  (%edi,%ebx,4)
  8000e8:	e8 e5 13 00 00       	call   8014d2 <open>
  8000ed:	89 c6                	mov    %eax,%esi
			if (f < 0)
  8000ef:	83 c4 10             	add    $0x10,%esp
  8000f2:	85 c0                	test   %eax,%eax
  8000f4:	79 16                	jns    80010c <umain+0x61>
				printf("can't open %s: %e\n", argv[i], f);
  8000f6:	83 ec 04             	sub    $0x4,%esp
  8000f9:	50                   	push   %eax
  8000fa:	ff 34 9f             	pushl  (%edi,%ebx,4)
  8000fd:	68 87 1f 80 00       	push   $0x801f87
  800102:	e8 69 15 00 00       	call   801670 <printf>
  800107:	83 c4 10             	add    $0x10,%esp
  80010a:	eb 17                	jmp    800123 <umain+0x78>
			else {
				cat(f, argv[i]);
  80010c:	83 ec 08             	sub    $0x8,%esp
  80010f:	ff 34 9f             	pushl  (%edi,%ebx,4)
  800112:	50                   	push   %eax
  800113:	e8 1b ff ff ff       	call   800033 <cat>
				close(f);
  800118:	89 34 24             	mov    %esi,(%esp)
  80011b:	e8 c8 0d 00 00       	call   800ee8 <close>
  800120:	83 c4 10             	add    $0x10,%esp

	binaryname = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800123:	83 c3 01             	add    $0x1,%ebx
  800126:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  800129:	7c b5                	jl     8000e0 <umain+0x35>
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  80012b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80012e:	5b                   	pop    %ebx
  80012f:	5e                   	pop    %esi
  800130:	5f                   	pop    %edi
  800131:	5d                   	pop    %ebp
  800132:	c3                   	ret    

00800133 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800133:	55                   	push   %ebp
  800134:	89 e5                	mov    %esp,%ebp
  800136:	56                   	push   %esi
  800137:	53                   	push   %ebx
  800138:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80013b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  80013e:	e8 9d 0a 00 00       	call   800be0 <sys_getenvid>
	if (id >= 0)
  800143:	85 c0                	test   %eax,%eax
  800145:	78 12                	js     800159 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  800147:	25 ff 03 00 00       	and    $0x3ff,%eax
  80014c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80014f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800154:	a3 20 60 80 00       	mov    %eax,0x806020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800159:	85 db                	test   %ebx,%ebx
  80015b:	7e 07                	jle    800164 <libmain+0x31>
		binaryname = argv[0];
  80015d:	8b 06                	mov    (%esi),%eax
  80015f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800164:	83 ec 08             	sub    $0x8,%esp
  800167:	56                   	push   %esi
  800168:	53                   	push   %ebx
  800169:	e8 3d ff ff ff       	call   8000ab <umain>

	// exit gracefully
	exit();
  80016e:	e8 0a 00 00 00       	call   80017d <exit>
}
  800173:	83 c4 10             	add    $0x10,%esp
  800176:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800179:	5b                   	pop    %ebx
  80017a:	5e                   	pop    %esi
  80017b:	5d                   	pop    %ebp
  80017c:	c3                   	ret    

0080017d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80017d:	55                   	push   %ebp
  80017e:	89 e5                	mov    %esp,%ebp
  800180:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800183:	e8 8b 0d 00 00       	call   800f13 <close_all>
	sys_env_destroy(0);
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	6a 00                	push   $0x0
  80018d:	e8 2c 0a 00 00       	call   800bbe <sys_env_destroy>
}
  800192:	83 c4 10             	add    $0x10,%esp
  800195:	c9                   	leave  
  800196:	c3                   	ret    

00800197 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	56                   	push   %esi
  80019b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80019c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80019f:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001a5:	e8 36 0a 00 00       	call   800be0 <sys_getenvid>
  8001aa:	83 ec 0c             	sub    $0xc,%esp
  8001ad:	ff 75 0c             	pushl  0xc(%ebp)
  8001b0:	ff 75 08             	pushl  0x8(%ebp)
  8001b3:	56                   	push   %esi
  8001b4:	50                   	push   %eax
  8001b5:	68 a4 1f 80 00       	push   $0x801fa4
  8001ba:	e8 b1 00 00 00       	call   800270 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001bf:	83 c4 18             	add    $0x18,%esp
  8001c2:	53                   	push   %ebx
  8001c3:	ff 75 10             	pushl  0x10(%ebp)
  8001c6:	e8 54 00 00 00       	call   80021f <vcprintf>
	cprintf("\n");
  8001cb:	c7 04 24 c7 23 80 00 	movl   $0x8023c7,(%esp)
  8001d2:	e8 99 00 00 00       	call   800270 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001da:	cc                   	int3   
  8001db:	eb fd                	jmp    8001da <_panic+0x43>

008001dd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001dd:	55                   	push   %ebp
  8001de:	89 e5                	mov    %esp,%ebp
  8001e0:	53                   	push   %ebx
  8001e1:	83 ec 04             	sub    $0x4,%esp
  8001e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001e7:	8b 13                	mov    (%ebx),%edx
  8001e9:	8d 42 01             	lea    0x1(%edx),%eax
  8001ec:	89 03                	mov    %eax,(%ebx)
  8001ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001f1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001f5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001fa:	75 1a                	jne    800216 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  8001fc:	83 ec 08             	sub    $0x8,%esp
  8001ff:	68 ff 00 00 00       	push   $0xff
  800204:	8d 43 08             	lea    0x8(%ebx),%eax
  800207:	50                   	push   %eax
  800208:	e8 67 09 00 00       	call   800b74 <sys_cputs>
		b->idx = 0;
  80020d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800213:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  800216:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80021a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80021d:	c9                   	leave  
  80021e:	c3                   	ret    

0080021f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80021f:	55                   	push   %ebp
  800220:	89 e5                	mov    %esp,%ebp
  800222:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800228:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80022f:	00 00 00 
	b.cnt = 0;
  800232:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800239:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80023c:	ff 75 0c             	pushl  0xc(%ebp)
  80023f:	ff 75 08             	pushl  0x8(%ebp)
  800242:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800248:	50                   	push   %eax
  800249:	68 dd 01 80 00       	push   $0x8001dd
  80024e:	e8 86 01 00 00       	call   8003d9 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800253:	83 c4 08             	add    $0x8,%esp
  800256:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80025c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800262:	50                   	push   %eax
  800263:	e8 0c 09 00 00       	call   800b74 <sys_cputs>

	return b.cnt;
}
  800268:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80026e:	c9                   	leave  
  80026f:	c3                   	ret    

00800270 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800276:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800279:	50                   	push   %eax
  80027a:	ff 75 08             	pushl  0x8(%ebp)
  80027d:	e8 9d ff ff ff       	call   80021f <vcprintf>
	va_end(ap);

	return cnt;
}
  800282:	c9                   	leave  
  800283:	c3                   	ret    

00800284 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	57                   	push   %edi
  800288:	56                   	push   %esi
  800289:	53                   	push   %ebx
  80028a:	83 ec 1c             	sub    $0x1c,%esp
  80028d:	89 c7                	mov    %eax,%edi
  80028f:	89 d6                	mov    %edx,%esi
  800291:	8b 45 08             	mov    0x8(%ebp),%eax
  800294:	8b 55 0c             	mov    0xc(%ebp),%edx
  800297:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80029a:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80029d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002a8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002ab:	39 d3                	cmp    %edx,%ebx
  8002ad:	72 05                	jb     8002b4 <printnum+0x30>
  8002af:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002b2:	77 45                	ja     8002f9 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002b4:	83 ec 0c             	sub    $0xc,%esp
  8002b7:	ff 75 18             	pushl  0x18(%ebp)
  8002ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8002bd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002c0:	53                   	push   %ebx
  8002c1:	ff 75 10             	pushl  0x10(%ebp)
  8002c4:	83 ec 08             	sub    $0x8,%esp
  8002c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ca:	ff 75 e0             	pushl  -0x20(%ebp)
  8002cd:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d0:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d3:	e8 c8 19 00 00       	call   801ca0 <__udivdi3>
  8002d8:	83 c4 18             	add    $0x18,%esp
  8002db:	52                   	push   %edx
  8002dc:	50                   	push   %eax
  8002dd:	89 f2                	mov    %esi,%edx
  8002df:	89 f8                	mov    %edi,%eax
  8002e1:	e8 9e ff ff ff       	call   800284 <printnum>
  8002e6:	83 c4 20             	add    $0x20,%esp
  8002e9:	eb 18                	jmp    800303 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002eb:	83 ec 08             	sub    $0x8,%esp
  8002ee:	56                   	push   %esi
  8002ef:	ff 75 18             	pushl  0x18(%ebp)
  8002f2:	ff d7                	call   *%edi
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	eb 03                	jmp    8002fc <printnum+0x78>
  8002f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002fc:	83 eb 01             	sub    $0x1,%ebx
  8002ff:	85 db                	test   %ebx,%ebx
  800301:	7f e8                	jg     8002eb <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800303:	83 ec 08             	sub    $0x8,%esp
  800306:	56                   	push   %esi
  800307:	83 ec 04             	sub    $0x4,%esp
  80030a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030d:	ff 75 e0             	pushl  -0x20(%ebp)
  800310:	ff 75 dc             	pushl  -0x24(%ebp)
  800313:	ff 75 d8             	pushl  -0x28(%ebp)
  800316:	e8 b5 1a 00 00       	call   801dd0 <__umoddi3>
  80031b:	83 c4 14             	add    $0x14,%esp
  80031e:	0f be 80 c7 1f 80 00 	movsbl 0x801fc7(%eax),%eax
  800325:	50                   	push   %eax
  800326:	ff d7                	call   *%edi
}
  800328:	83 c4 10             	add    $0x10,%esp
  80032b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032e:	5b                   	pop    %ebx
  80032f:	5e                   	pop    %esi
  800330:	5f                   	pop    %edi
  800331:	5d                   	pop    %ebp
  800332:	c3                   	ret    

00800333 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800336:	83 fa 01             	cmp    $0x1,%edx
  800339:	7e 0e                	jle    800349 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80033b:	8b 10                	mov    (%eax),%edx
  80033d:	8d 4a 08             	lea    0x8(%edx),%ecx
  800340:	89 08                	mov    %ecx,(%eax)
  800342:	8b 02                	mov    (%edx),%eax
  800344:	8b 52 04             	mov    0x4(%edx),%edx
  800347:	eb 22                	jmp    80036b <getuint+0x38>
	else if (lflag)
  800349:	85 d2                	test   %edx,%edx
  80034b:	74 10                	je     80035d <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80034d:	8b 10                	mov    (%eax),%edx
  80034f:	8d 4a 04             	lea    0x4(%edx),%ecx
  800352:	89 08                	mov    %ecx,(%eax)
  800354:	8b 02                	mov    (%edx),%eax
  800356:	ba 00 00 00 00       	mov    $0x0,%edx
  80035b:	eb 0e                	jmp    80036b <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80035d:	8b 10                	mov    (%eax),%edx
  80035f:	8d 4a 04             	lea    0x4(%edx),%ecx
  800362:	89 08                	mov    %ecx,(%eax)
  800364:	8b 02                	mov    (%edx),%eax
  800366:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80036b:	5d                   	pop    %ebp
  80036c:	c3                   	ret    

0080036d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80036d:	55                   	push   %ebp
  80036e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800370:	83 fa 01             	cmp    $0x1,%edx
  800373:	7e 0e                	jle    800383 <getint+0x16>
		return va_arg(*ap, long long);
  800375:	8b 10                	mov    (%eax),%edx
  800377:	8d 4a 08             	lea    0x8(%edx),%ecx
  80037a:	89 08                	mov    %ecx,(%eax)
  80037c:	8b 02                	mov    (%edx),%eax
  80037e:	8b 52 04             	mov    0x4(%edx),%edx
  800381:	eb 1a                	jmp    80039d <getint+0x30>
	else if (lflag)
  800383:	85 d2                	test   %edx,%edx
  800385:	74 0c                	je     800393 <getint+0x26>
		return va_arg(*ap, long);
  800387:	8b 10                	mov    (%eax),%edx
  800389:	8d 4a 04             	lea    0x4(%edx),%ecx
  80038c:	89 08                	mov    %ecx,(%eax)
  80038e:	8b 02                	mov    (%edx),%eax
  800390:	99                   	cltd   
  800391:	eb 0a                	jmp    80039d <getint+0x30>
	else
		return va_arg(*ap, int);
  800393:	8b 10                	mov    (%eax),%edx
  800395:	8d 4a 04             	lea    0x4(%edx),%ecx
  800398:	89 08                	mov    %ecx,(%eax)
  80039a:	8b 02                	mov    (%edx),%eax
  80039c:	99                   	cltd   
}
  80039d:	5d                   	pop    %ebp
  80039e:	c3                   	ret    

0080039f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003a5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003a9:	8b 10                	mov    (%eax),%edx
  8003ab:	3b 50 04             	cmp    0x4(%eax),%edx
  8003ae:	73 0a                	jae    8003ba <sprintputch+0x1b>
		*b->buf++ = ch;
  8003b0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003b3:	89 08                	mov    %ecx,(%eax)
  8003b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b8:	88 02                	mov    %al,(%edx)
}
  8003ba:	5d                   	pop    %ebp
  8003bb:	c3                   	ret    

008003bc <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003bc:	55                   	push   %ebp
  8003bd:	89 e5                	mov    %esp,%ebp
  8003bf:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8003c2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003c5:	50                   	push   %eax
  8003c6:	ff 75 10             	pushl  0x10(%ebp)
  8003c9:	ff 75 0c             	pushl  0xc(%ebp)
  8003cc:	ff 75 08             	pushl  0x8(%ebp)
  8003cf:	e8 05 00 00 00       	call   8003d9 <vprintfmt>
	va_end(ap);
}
  8003d4:	83 c4 10             	add    $0x10,%esp
  8003d7:	c9                   	leave  
  8003d8:	c3                   	ret    

008003d9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	57                   	push   %edi
  8003dd:	56                   	push   %esi
  8003de:	53                   	push   %ebx
  8003df:	83 ec 2c             	sub    $0x2c,%esp
  8003e2:	8b 75 08             	mov    0x8(%ebp),%esi
  8003e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003e8:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003eb:	eb 12                	jmp    8003ff <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003ed:	85 c0                	test   %eax,%eax
  8003ef:	0f 84 44 03 00 00    	je     800739 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  8003f5:	83 ec 08             	sub    $0x8,%esp
  8003f8:	53                   	push   %ebx
  8003f9:	50                   	push   %eax
  8003fa:	ff d6                	call   *%esi
  8003fc:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003ff:	83 c7 01             	add    $0x1,%edi
  800402:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800406:	83 f8 25             	cmp    $0x25,%eax
  800409:	75 e2                	jne    8003ed <vprintfmt+0x14>
  80040b:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  80040f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800416:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80041d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800424:	ba 00 00 00 00       	mov    $0x0,%edx
  800429:	eb 07                	jmp    800432 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80042b:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  80042e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800432:	8d 47 01             	lea    0x1(%edi),%eax
  800435:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800438:	0f b6 07             	movzbl (%edi),%eax
  80043b:	0f b6 c8             	movzbl %al,%ecx
  80043e:	83 e8 23             	sub    $0x23,%eax
  800441:	3c 55                	cmp    $0x55,%al
  800443:	0f 87 d5 02 00 00    	ja     80071e <vprintfmt+0x345>
  800449:	0f b6 c0             	movzbl %al,%eax
  80044c:	ff 24 85 00 21 80 00 	jmp    *0x802100(,%eax,4)
  800453:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800456:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80045a:	eb d6                	jmp    800432 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80045c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80045f:	b8 00 00 00 00       	mov    $0x0,%eax
  800464:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800467:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80046a:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  80046e:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  800471:	8d 51 d0             	lea    -0x30(%ecx),%edx
  800474:	83 fa 09             	cmp    $0x9,%edx
  800477:	77 39                	ja     8004b2 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800479:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80047c:	eb e9                	jmp    800467 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80047e:	8b 45 14             	mov    0x14(%ebp),%eax
  800481:	8d 48 04             	lea    0x4(%eax),%ecx
  800484:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800487:	8b 00                	mov    (%eax),%eax
  800489:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  80048f:	eb 27                	jmp    8004b8 <vprintfmt+0xdf>
  800491:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800494:	85 c0                	test   %eax,%eax
  800496:	b9 00 00 00 00       	mov    $0x0,%ecx
  80049b:	0f 49 c8             	cmovns %eax,%ecx
  80049e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004a4:	eb 8c                	jmp    800432 <vprintfmt+0x59>
  8004a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004a9:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004b0:	eb 80                	jmp    800432 <vprintfmt+0x59>
  8004b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8004b5:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  8004b8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004bc:	0f 89 70 ff ff ff    	jns    800432 <vprintfmt+0x59>
				width = precision, precision = -1;
  8004c2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c8:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004cf:	e9 5e ff ff ff       	jmp    800432 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004d4:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004da:	e9 53 ff ff ff       	jmp    800432 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004df:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e2:	8d 50 04             	lea    0x4(%eax),%edx
  8004e5:	89 55 14             	mov    %edx,0x14(%ebp)
  8004e8:	83 ec 08             	sub    $0x8,%esp
  8004eb:	53                   	push   %ebx
  8004ec:	ff 30                	pushl  (%eax)
  8004ee:	ff d6                	call   *%esi
			break;
  8004f0:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  8004f6:	e9 04 ff ff ff       	jmp    8003ff <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fe:	8d 50 04             	lea    0x4(%eax),%edx
  800501:	89 55 14             	mov    %edx,0x14(%ebp)
  800504:	8b 00                	mov    (%eax),%eax
  800506:	99                   	cltd   
  800507:	31 d0                	xor    %edx,%eax
  800509:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80050b:	83 f8 0f             	cmp    $0xf,%eax
  80050e:	7f 0b                	jg     80051b <vprintfmt+0x142>
  800510:	8b 14 85 60 22 80 00 	mov    0x802260(,%eax,4),%edx
  800517:	85 d2                	test   %edx,%edx
  800519:	75 18                	jne    800533 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  80051b:	50                   	push   %eax
  80051c:	68 df 1f 80 00       	push   $0x801fdf
  800521:	53                   	push   %ebx
  800522:	56                   	push   %esi
  800523:	e8 94 fe ff ff       	call   8003bc <printfmt>
  800528:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80052e:	e9 cc fe ff ff       	jmp    8003ff <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  800533:	52                   	push   %edx
  800534:	68 95 23 80 00       	push   $0x802395
  800539:	53                   	push   %ebx
  80053a:	56                   	push   %esi
  80053b:	e8 7c fe ff ff       	call   8003bc <printfmt>
  800540:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800543:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800546:	e9 b4 fe ff ff       	jmp    8003ff <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80054b:	8b 45 14             	mov    0x14(%ebp),%eax
  80054e:	8d 50 04             	lea    0x4(%eax),%edx
  800551:	89 55 14             	mov    %edx,0x14(%ebp)
  800554:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800556:	85 ff                	test   %edi,%edi
  800558:	b8 d8 1f 80 00       	mov    $0x801fd8,%eax
  80055d:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800560:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800564:	0f 8e 94 00 00 00    	jle    8005fe <vprintfmt+0x225>
  80056a:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80056e:	0f 84 98 00 00 00    	je     80060c <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	ff 75 d0             	pushl  -0x30(%ebp)
  80057a:	57                   	push   %edi
  80057b:	e8 41 02 00 00       	call   8007c1 <strnlen>
  800580:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800583:	29 c1                	sub    %eax,%ecx
  800585:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800588:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80058b:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80058f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800592:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800595:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800597:	eb 0f                	jmp    8005a8 <vprintfmt+0x1cf>
					putch(padc, putdat);
  800599:	83 ec 08             	sub    $0x8,%esp
  80059c:	53                   	push   %ebx
  80059d:	ff 75 e0             	pushl  -0x20(%ebp)
  8005a0:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a2:	83 ef 01             	sub    $0x1,%edi
  8005a5:	83 c4 10             	add    $0x10,%esp
  8005a8:	85 ff                	test   %edi,%edi
  8005aa:	7f ed                	jg     800599 <vprintfmt+0x1c0>
  8005ac:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005af:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8005b2:	85 c9                	test   %ecx,%ecx
  8005b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b9:	0f 49 c1             	cmovns %ecx,%eax
  8005bc:	29 c1                	sub    %eax,%ecx
  8005be:	89 75 08             	mov    %esi,0x8(%ebp)
  8005c1:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005c4:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005c7:	89 cb                	mov    %ecx,%ebx
  8005c9:	eb 4d                	jmp    800618 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005cb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005cf:	74 1b                	je     8005ec <vprintfmt+0x213>
  8005d1:	0f be c0             	movsbl %al,%eax
  8005d4:	83 e8 20             	sub    $0x20,%eax
  8005d7:	83 f8 5e             	cmp    $0x5e,%eax
  8005da:	76 10                	jbe    8005ec <vprintfmt+0x213>
					putch('?', putdat);
  8005dc:	83 ec 08             	sub    $0x8,%esp
  8005df:	ff 75 0c             	pushl  0xc(%ebp)
  8005e2:	6a 3f                	push   $0x3f
  8005e4:	ff 55 08             	call   *0x8(%ebp)
  8005e7:	83 c4 10             	add    $0x10,%esp
  8005ea:	eb 0d                	jmp    8005f9 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  8005ec:	83 ec 08             	sub    $0x8,%esp
  8005ef:	ff 75 0c             	pushl  0xc(%ebp)
  8005f2:	52                   	push   %edx
  8005f3:	ff 55 08             	call   *0x8(%ebp)
  8005f6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f9:	83 eb 01             	sub    $0x1,%ebx
  8005fc:	eb 1a                	jmp    800618 <vprintfmt+0x23f>
  8005fe:	89 75 08             	mov    %esi,0x8(%ebp)
  800601:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800604:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800607:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80060a:	eb 0c                	jmp    800618 <vprintfmt+0x23f>
  80060c:	89 75 08             	mov    %esi,0x8(%ebp)
  80060f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800612:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800615:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800618:	83 c7 01             	add    $0x1,%edi
  80061b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80061f:	0f be d0             	movsbl %al,%edx
  800622:	85 d2                	test   %edx,%edx
  800624:	74 23                	je     800649 <vprintfmt+0x270>
  800626:	85 f6                	test   %esi,%esi
  800628:	78 a1                	js     8005cb <vprintfmt+0x1f2>
  80062a:	83 ee 01             	sub    $0x1,%esi
  80062d:	79 9c                	jns    8005cb <vprintfmt+0x1f2>
  80062f:	89 df                	mov    %ebx,%edi
  800631:	8b 75 08             	mov    0x8(%ebp),%esi
  800634:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800637:	eb 18                	jmp    800651 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800639:	83 ec 08             	sub    $0x8,%esp
  80063c:	53                   	push   %ebx
  80063d:	6a 20                	push   $0x20
  80063f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800641:	83 ef 01             	sub    $0x1,%edi
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	eb 08                	jmp    800651 <vprintfmt+0x278>
  800649:	89 df                	mov    %ebx,%edi
  80064b:	8b 75 08             	mov    0x8(%ebp),%esi
  80064e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800651:	85 ff                	test   %edi,%edi
  800653:	7f e4                	jg     800639 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800655:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800658:	e9 a2 fd ff ff       	jmp    8003ff <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80065d:	8d 45 14             	lea    0x14(%ebp),%eax
  800660:	e8 08 fd ff ff       	call   80036d <getint>
  800665:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800668:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80066b:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800670:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800674:	79 74                	jns    8006ea <vprintfmt+0x311>
				putch('-', putdat);
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	53                   	push   %ebx
  80067a:	6a 2d                	push   $0x2d
  80067c:	ff d6                	call   *%esi
				num = -(long long) num;
  80067e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800681:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800684:	f7 d8                	neg    %eax
  800686:	83 d2 00             	adc    $0x0,%edx
  800689:	f7 da                	neg    %edx
  80068b:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  80068e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800693:	eb 55                	jmp    8006ea <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800695:	8d 45 14             	lea    0x14(%ebp),%eax
  800698:	e8 96 fc ff ff       	call   800333 <getuint>
			base = 10;
  80069d:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006a2:	eb 46                	jmp    8006ea <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8006a4:	8d 45 14             	lea    0x14(%ebp),%eax
  8006a7:	e8 87 fc ff ff       	call   800333 <getuint>
			base = 8;
  8006ac:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8006b1:	eb 37                	jmp    8006ea <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	53                   	push   %ebx
  8006b7:	6a 30                	push   $0x30
  8006b9:	ff d6                	call   *%esi
			putch('x', putdat);
  8006bb:	83 c4 08             	add    $0x8,%esp
  8006be:	53                   	push   %ebx
  8006bf:	6a 78                	push   $0x78
  8006c1:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	8d 50 04             	lea    0x4(%eax),%edx
  8006c9:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006cc:	8b 00                	mov    (%eax),%eax
  8006ce:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8006d3:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8006d6:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8006db:	eb 0d                	jmp    8006ea <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e0:	e8 4e fc ff ff       	call   800333 <getuint>
			base = 16;
  8006e5:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006ea:	83 ec 0c             	sub    $0xc,%esp
  8006ed:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006f1:	57                   	push   %edi
  8006f2:	ff 75 e0             	pushl  -0x20(%ebp)
  8006f5:	51                   	push   %ecx
  8006f6:	52                   	push   %edx
  8006f7:	50                   	push   %eax
  8006f8:	89 da                	mov    %ebx,%edx
  8006fa:	89 f0                	mov    %esi,%eax
  8006fc:	e8 83 fb ff ff       	call   800284 <printnum>
			break;
  800701:	83 c4 20             	add    $0x20,%esp
  800704:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800707:	e9 f3 fc ff ff       	jmp    8003ff <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80070c:	83 ec 08             	sub    $0x8,%esp
  80070f:	53                   	push   %ebx
  800710:	51                   	push   %ecx
  800711:	ff d6                	call   *%esi
			break;
  800713:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800716:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800719:	e9 e1 fc ff ff       	jmp    8003ff <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	53                   	push   %ebx
  800722:	6a 25                	push   $0x25
  800724:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800726:	83 c4 10             	add    $0x10,%esp
  800729:	eb 03                	jmp    80072e <vprintfmt+0x355>
  80072b:	83 ef 01             	sub    $0x1,%edi
  80072e:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  800732:	75 f7                	jne    80072b <vprintfmt+0x352>
  800734:	e9 c6 fc ff ff       	jmp    8003ff <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  800739:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80073c:	5b                   	pop    %ebx
  80073d:	5e                   	pop    %esi
  80073e:	5f                   	pop    %edi
  80073f:	5d                   	pop    %ebp
  800740:	c3                   	ret    

00800741 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800741:	55                   	push   %ebp
  800742:	89 e5                	mov    %esp,%ebp
  800744:	83 ec 18             	sub    $0x18,%esp
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  80074a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80074d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800750:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800754:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800757:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80075e:	85 c0                	test   %eax,%eax
  800760:	74 26                	je     800788 <vsnprintf+0x47>
  800762:	85 d2                	test   %edx,%edx
  800764:	7e 22                	jle    800788 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800766:	ff 75 14             	pushl  0x14(%ebp)
  800769:	ff 75 10             	pushl  0x10(%ebp)
  80076c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80076f:	50                   	push   %eax
  800770:	68 9f 03 80 00       	push   $0x80039f
  800775:	e8 5f fc ff ff       	call   8003d9 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80077a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80077d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800783:	83 c4 10             	add    $0x10,%esp
  800786:	eb 05                	jmp    80078d <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800788:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80078d:	c9                   	leave  
  80078e:	c3                   	ret    

0080078f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800795:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800798:	50                   	push   %eax
  800799:	ff 75 10             	pushl  0x10(%ebp)
  80079c:	ff 75 0c             	pushl  0xc(%ebp)
  80079f:	ff 75 08             	pushl  0x8(%ebp)
  8007a2:	e8 9a ff ff ff       	call   800741 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007a7:	c9                   	leave  
  8007a8:	c3                   	ret    

008007a9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007a9:	55                   	push   %ebp
  8007aa:	89 e5                	mov    %esp,%ebp
  8007ac:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007af:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b4:	eb 03                	jmp    8007b9 <strlen+0x10>
		n++;
  8007b6:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007b9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007bd:	75 f7                	jne    8007b6 <strlen+0xd>
		n++;
	return n;
}
  8007bf:	5d                   	pop    %ebp
  8007c0:	c3                   	ret    

008007c1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007c1:	55                   	push   %ebp
  8007c2:	89 e5                	mov    %esp,%ebp
  8007c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007c7:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8007cf:	eb 03                	jmp    8007d4 <strnlen+0x13>
		n++;
  8007d1:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007d4:	39 c2                	cmp    %eax,%edx
  8007d6:	74 08                	je     8007e0 <strnlen+0x1f>
  8007d8:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8007dc:	75 f3                	jne    8007d1 <strnlen+0x10>
  8007de:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  8007e0:	5d                   	pop    %ebp
  8007e1:	c3                   	ret    

008007e2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	53                   	push   %ebx
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007ec:	89 c2                	mov    %eax,%edx
  8007ee:	83 c2 01             	add    $0x1,%edx
  8007f1:	83 c1 01             	add    $0x1,%ecx
  8007f4:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007f8:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007fb:	84 db                	test   %bl,%bl
  8007fd:	75 ef                	jne    8007ee <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007ff:	5b                   	pop    %ebx
  800800:	5d                   	pop    %ebp
  800801:	c3                   	ret    

00800802 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800802:	55                   	push   %ebp
  800803:	89 e5                	mov    %esp,%ebp
  800805:	53                   	push   %ebx
  800806:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800809:	53                   	push   %ebx
  80080a:	e8 9a ff ff ff       	call   8007a9 <strlen>
  80080f:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800812:	ff 75 0c             	pushl  0xc(%ebp)
  800815:	01 d8                	add    %ebx,%eax
  800817:	50                   	push   %eax
  800818:	e8 c5 ff ff ff       	call   8007e2 <strcpy>
	return dst;
}
  80081d:	89 d8                	mov    %ebx,%eax
  80081f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800822:	c9                   	leave  
  800823:	c3                   	ret    

00800824 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800824:	55                   	push   %ebp
  800825:	89 e5                	mov    %esp,%ebp
  800827:	56                   	push   %esi
  800828:	53                   	push   %ebx
  800829:	8b 75 08             	mov    0x8(%ebp),%esi
  80082c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80082f:	89 f3                	mov    %esi,%ebx
  800831:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800834:	89 f2                	mov    %esi,%edx
  800836:	eb 0f                	jmp    800847 <strncpy+0x23>
		*dst++ = *src;
  800838:	83 c2 01             	add    $0x1,%edx
  80083b:	0f b6 01             	movzbl (%ecx),%eax
  80083e:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800841:	80 39 01             	cmpb   $0x1,(%ecx)
  800844:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800847:	39 da                	cmp    %ebx,%edx
  800849:	75 ed                	jne    800838 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80084b:	89 f0                	mov    %esi,%eax
  80084d:	5b                   	pop    %ebx
  80084e:	5e                   	pop    %esi
  80084f:	5d                   	pop    %ebp
  800850:	c3                   	ret    

00800851 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
  800854:	56                   	push   %esi
  800855:	53                   	push   %ebx
  800856:	8b 75 08             	mov    0x8(%ebp),%esi
  800859:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80085c:	8b 55 10             	mov    0x10(%ebp),%edx
  80085f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800861:	85 d2                	test   %edx,%edx
  800863:	74 21                	je     800886 <strlcpy+0x35>
  800865:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800869:	89 f2                	mov    %esi,%edx
  80086b:	eb 09                	jmp    800876 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80086d:	83 c2 01             	add    $0x1,%edx
  800870:	83 c1 01             	add    $0x1,%ecx
  800873:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800876:	39 c2                	cmp    %eax,%edx
  800878:	74 09                	je     800883 <strlcpy+0x32>
  80087a:	0f b6 19             	movzbl (%ecx),%ebx
  80087d:	84 db                	test   %bl,%bl
  80087f:	75 ec                	jne    80086d <strlcpy+0x1c>
  800881:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  800883:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800886:	29 f0                	sub    %esi,%eax
}
  800888:	5b                   	pop    %ebx
  800889:	5e                   	pop    %esi
  80088a:	5d                   	pop    %ebp
  80088b:	c3                   	ret    

0080088c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
  80088f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800892:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800895:	eb 06                	jmp    80089d <strcmp+0x11>
		p++, q++;
  800897:	83 c1 01             	add    $0x1,%ecx
  80089a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80089d:	0f b6 01             	movzbl (%ecx),%eax
  8008a0:	84 c0                	test   %al,%al
  8008a2:	74 04                	je     8008a8 <strcmp+0x1c>
  8008a4:	3a 02                	cmp    (%edx),%al
  8008a6:	74 ef                	je     800897 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008a8:	0f b6 c0             	movzbl %al,%eax
  8008ab:	0f b6 12             	movzbl (%edx),%edx
  8008ae:	29 d0                	sub    %edx,%eax
}
  8008b0:	5d                   	pop    %ebp
  8008b1:	c3                   	ret    

008008b2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008b2:	55                   	push   %ebp
  8008b3:	89 e5                	mov    %esp,%ebp
  8008b5:	53                   	push   %ebx
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bc:	89 c3                	mov    %eax,%ebx
  8008be:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008c1:	eb 06                	jmp    8008c9 <strncmp+0x17>
		n--, p++, q++;
  8008c3:	83 c0 01             	add    $0x1,%eax
  8008c6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008c9:	39 d8                	cmp    %ebx,%eax
  8008cb:	74 15                	je     8008e2 <strncmp+0x30>
  8008cd:	0f b6 08             	movzbl (%eax),%ecx
  8008d0:	84 c9                	test   %cl,%cl
  8008d2:	74 04                	je     8008d8 <strncmp+0x26>
  8008d4:	3a 0a                	cmp    (%edx),%cl
  8008d6:	74 eb                	je     8008c3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008d8:	0f b6 00             	movzbl (%eax),%eax
  8008db:	0f b6 12             	movzbl (%edx),%edx
  8008de:	29 d0                	sub    %edx,%eax
  8008e0:	eb 05                	jmp    8008e7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8008e2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008e7:	5b                   	pop    %ebx
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008f4:	eb 07                	jmp    8008fd <strchr+0x13>
		if (*s == c)
  8008f6:	38 ca                	cmp    %cl,%dl
  8008f8:	74 0f                	je     800909 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008fa:	83 c0 01             	add    $0x1,%eax
  8008fd:	0f b6 10             	movzbl (%eax),%edx
  800900:	84 d2                	test   %dl,%dl
  800902:	75 f2                	jne    8008f6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800904:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800909:	5d                   	pop    %ebp
  80090a:	c3                   	ret    

0080090b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800915:	eb 03                	jmp    80091a <strfind+0xf>
  800917:	83 c0 01             	add    $0x1,%eax
  80091a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80091d:	38 ca                	cmp    %cl,%dl
  80091f:	74 04                	je     800925 <strfind+0x1a>
  800921:	84 d2                	test   %dl,%dl
  800923:	75 f2                	jne    800917 <strfind+0xc>
			break;
	return (char *) s;
}
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	57                   	push   %edi
  80092b:	56                   	push   %esi
  80092c:	53                   	push   %ebx
  80092d:	8b 55 08             	mov    0x8(%ebp),%edx
  800930:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800933:	85 c9                	test   %ecx,%ecx
  800935:	74 37                	je     80096e <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800937:	f6 c2 03             	test   $0x3,%dl
  80093a:	75 2a                	jne    800966 <memset+0x3f>
  80093c:	f6 c1 03             	test   $0x3,%cl
  80093f:	75 25                	jne    800966 <memset+0x3f>
		c &= 0xFF;
  800941:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800945:	89 df                	mov    %ebx,%edi
  800947:	c1 e7 08             	shl    $0x8,%edi
  80094a:	89 de                	mov    %ebx,%esi
  80094c:	c1 e6 18             	shl    $0x18,%esi
  80094f:	89 d8                	mov    %ebx,%eax
  800951:	c1 e0 10             	shl    $0x10,%eax
  800954:	09 f0                	or     %esi,%eax
  800956:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800958:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80095b:	89 f8                	mov    %edi,%eax
  80095d:	09 d8                	or     %ebx,%eax
  80095f:	89 d7                	mov    %edx,%edi
  800961:	fc                   	cld    
  800962:	f3 ab                	rep stos %eax,%es:(%edi)
  800964:	eb 08                	jmp    80096e <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800966:	89 d7                	mov    %edx,%edi
  800968:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096b:	fc                   	cld    
  80096c:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  80096e:	89 d0                	mov    %edx,%eax
  800970:	5b                   	pop    %ebx
  800971:	5e                   	pop    %esi
  800972:	5f                   	pop    %edi
  800973:	5d                   	pop    %ebp
  800974:	c3                   	ret    

00800975 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	57                   	push   %edi
  800979:	56                   	push   %esi
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800980:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800983:	39 c6                	cmp    %eax,%esi
  800985:	73 35                	jae    8009bc <memmove+0x47>
  800987:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80098a:	39 d0                	cmp    %edx,%eax
  80098c:	73 2e                	jae    8009bc <memmove+0x47>
		s += n;
		d += n;
  80098e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800991:	89 d6                	mov    %edx,%esi
  800993:	09 fe                	or     %edi,%esi
  800995:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80099b:	75 13                	jne    8009b0 <memmove+0x3b>
  80099d:	f6 c1 03             	test   $0x3,%cl
  8009a0:	75 0e                	jne    8009b0 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  8009a2:	83 ef 04             	sub    $0x4,%edi
  8009a5:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009a8:	c1 e9 02             	shr    $0x2,%ecx
  8009ab:	fd                   	std    
  8009ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ae:	eb 09                	jmp    8009b9 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009b0:	83 ef 01             	sub    $0x1,%edi
  8009b3:	8d 72 ff             	lea    -0x1(%edx),%esi
  8009b6:	fd                   	std    
  8009b7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009b9:	fc                   	cld    
  8009ba:	eb 1d                	jmp    8009d9 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009bc:	89 f2                	mov    %esi,%edx
  8009be:	09 c2                	or     %eax,%edx
  8009c0:	f6 c2 03             	test   $0x3,%dl
  8009c3:	75 0f                	jne    8009d4 <memmove+0x5f>
  8009c5:	f6 c1 03             	test   $0x3,%cl
  8009c8:	75 0a                	jne    8009d4 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  8009ca:	c1 e9 02             	shr    $0x2,%ecx
  8009cd:	89 c7                	mov    %eax,%edi
  8009cf:	fc                   	cld    
  8009d0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009d2:	eb 05                	jmp    8009d9 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009d4:	89 c7                	mov    %eax,%edi
  8009d6:	fc                   	cld    
  8009d7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009d9:	5e                   	pop    %esi
  8009da:	5f                   	pop    %edi
  8009db:	5d                   	pop    %ebp
  8009dc:	c3                   	ret    

008009dd <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009e0:	ff 75 10             	pushl  0x10(%ebp)
  8009e3:	ff 75 0c             	pushl  0xc(%ebp)
  8009e6:	ff 75 08             	pushl  0x8(%ebp)
  8009e9:	e8 87 ff ff ff       	call   800975 <memmove>
}
  8009ee:	c9                   	leave  
  8009ef:	c3                   	ret    

008009f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	56                   	push   %esi
  8009f4:	53                   	push   %ebx
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009fb:	89 c6                	mov    %eax,%esi
  8009fd:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a00:	eb 1a                	jmp    800a1c <memcmp+0x2c>
		if (*s1 != *s2)
  800a02:	0f b6 08             	movzbl (%eax),%ecx
  800a05:	0f b6 1a             	movzbl (%edx),%ebx
  800a08:	38 d9                	cmp    %bl,%cl
  800a0a:	74 0a                	je     800a16 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a0c:	0f b6 c1             	movzbl %cl,%eax
  800a0f:	0f b6 db             	movzbl %bl,%ebx
  800a12:	29 d8                	sub    %ebx,%eax
  800a14:	eb 0f                	jmp    800a25 <memcmp+0x35>
		s1++, s2++;
  800a16:	83 c0 01             	add    $0x1,%eax
  800a19:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a1c:	39 f0                	cmp    %esi,%eax
  800a1e:	75 e2                	jne    800a02 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a25:	5b                   	pop    %ebx
  800a26:	5e                   	pop    %esi
  800a27:	5d                   	pop    %ebp
  800a28:	c3                   	ret    

00800a29 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	53                   	push   %ebx
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800a30:	89 c1                	mov    %eax,%ecx
  800a32:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  800a35:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a39:	eb 0a                	jmp    800a45 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a3b:	0f b6 10             	movzbl (%eax),%edx
  800a3e:	39 da                	cmp    %ebx,%edx
  800a40:	74 07                	je     800a49 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a42:	83 c0 01             	add    $0x1,%eax
  800a45:	39 c8                	cmp    %ecx,%eax
  800a47:	72 f2                	jb     800a3b <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a49:	5b                   	pop    %ebx
  800a4a:	5d                   	pop    %ebp
  800a4b:	c3                   	ret    

00800a4c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	57                   	push   %edi
  800a50:	56                   	push   %esi
  800a51:	53                   	push   %ebx
  800a52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a55:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a58:	eb 03                	jmp    800a5d <strtol+0x11>
		s++;
  800a5a:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a5d:	0f b6 01             	movzbl (%ecx),%eax
  800a60:	3c 20                	cmp    $0x20,%al
  800a62:	74 f6                	je     800a5a <strtol+0xe>
  800a64:	3c 09                	cmp    $0x9,%al
  800a66:	74 f2                	je     800a5a <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a68:	3c 2b                	cmp    $0x2b,%al
  800a6a:	75 0a                	jne    800a76 <strtol+0x2a>
		s++;
  800a6c:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a6f:	bf 00 00 00 00       	mov    $0x0,%edi
  800a74:	eb 11                	jmp    800a87 <strtol+0x3b>
  800a76:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800a7b:	3c 2d                	cmp    $0x2d,%al
  800a7d:	75 08                	jne    800a87 <strtol+0x3b>
		s++, neg = 1;
  800a7f:	83 c1 01             	add    $0x1,%ecx
  800a82:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a87:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a8d:	75 15                	jne    800aa4 <strtol+0x58>
  800a8f:	80 39 30             	cmpb   $0x30,(%ecx)
  800a92:	75 10                	jne    800aa4 <strtol+0x58>
  800a94:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a98:	75 7c                	jne    800b16 <strtol+0xca>
		s += 2, base = 16;
  800a9a:	83 c1 02             	add    $0x2,%ecx
  800a9d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aa2:	eb 16                	jmp    800aba <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800aa4:	85 db                	test   %ebx,%ebx
  800aa6:	75 12                	jne    800aba <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aa8:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800aad:	80 39 30             	cmpb   $0x30,(%ecx)
  800ab0:	75 08                	jne    800aba <strtol+0x6e>
		s++, base = 8;
  800ab2:	83 c1 01             	add    $0x1,%ecx
  800ab5:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800aba:	b8 00 00 00 00       	mov    $0x0,%eax
  800abf:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ac2:	0f b6 11             	movzbl (%ecx),%edx
  800ac5:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ac8:	89 f3                	mov    %esi,%ebx
  800aca:	80 fb 09             	cmp    $0x9,%bl
  800acd:	77 08                	ja     800ad7 <strtol+0x8b>
			dig = *s - '0';
  800acf:	0f be d2             	movsbl %dl,%edx
  800ad2:	83 ea 30             	sub    $0x30,%edx
  800ad5:	eb 22                	jmp    800af9 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800ad7:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ada:	89 f3                	mov    %esi,%ebx
  800adc:	80 fb 19             	cmp    $0x19,%bl
  800adf:	77 08                	ja     800ae9 <strtol+0x9d>
			dig = *s - 'a' + 10;
  800ae1:	0f be d2             	movsbl %dl,%edx
  800ae4:	83 ea 57             	sub    $0x57,%edx
  800ae7:	eb 10                	jmp    800af9 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800ae9:	8d 72 bf             	lea    -0x41(%edx),%esi
  800aec:	89 f3                	mov    %esi,%ebx
  800aee:	80 fb 19             	cmp    $0x19,%bl
  800af1:	77 16                	ja     800b09 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800af3:	0f be d2             	movsbl %dl,%edx
  800af6:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800af9:	3b 55 10             	cmp    0x10(%ebp),%edx
  800afc:	7d 0b                	jge    800b09 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800afe:	83 c1 01             	add    $0x1,%ecx
  800b01:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b05:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800b07:	eb b9                	jmp    800ac2 <strtol+0x76>

	if (endptr)
  800b09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0d:	74 0d                	je     800b1c <strtol+0xd0>
		*endptr = (char *) s;
  800b0f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b12:	89 0e                	mov    %ecx,(%esi)
  800b14:	eb 06                	jmp    800b1c <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b16:	85 db                	test   %ebx,%ebx
  800b18:	74 98                	je     800ab2 <strtol+0x66>
  800b1a:	eb 9e                	jmp    800aba <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800b1c:	89 c2                	mov    %eax,%edx
  800b1e:	f7 da                	neg    %edx
  800b20:	85 ff                	test   %edi,%edi
  800b22:	0f 45 c2             	cmovne %edx,%eax
}
  800b25:	5b                   	pop    %ebx
  800b26:	5e                   	pop    %esi
  800b27:	5f                   	pop    %edi
  800b28:	5d                   	pop    %ebp
  800b29:	c3                   	ret    

00800b2a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	57                   	push   %edi
  800b2e:	56                   	push   %esi
  800b2f:	53                   	push   %ebx
  800b30:	83 ec 1c             	sub    $0x1c,%esp
  800b33:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b36:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b39:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b3e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b41:	8b 7d 10             	mov    0x10(%ebp),%edi
  800b44:	8b 75 14             	mov    0x14(%ebp),%esi
  800b47:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800b49:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b4d:	74 1d                	je     800b6c <syscall+0x42>
  800b4f:	85 c0                	test   %eax,%eax
  800b51:	7e 19                	jle    800b6c <syscall+0x42>
  800b53:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800b56:	83 ec 0c             	sub    $0xc,%esp
  800b59:	50                   	push   %eax
  800b5a:	52                   	push   %edx
  800b5b:	68 bf 22 80 00       	push   $0x8022bf
  800b60:	6a 23                	push   $0x23
  800b62:	68 dc 22 80 00       	push   $0x8022dc
  800b67:	e8 2b f6 ff ff       	call   800197 <_panic>

	return ret;
}
  800b6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b6f:	5b                   	pop    %ebx
  800b70:	5e                   	pop    %esi
  800b71:	5f                   	pop    %edi
  800b72:	5d                   	pop    %ebp
  800b73:	c3                   	ret    

00800b74 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800b7a:	6a 00                	push   $0x0
  800b7c:	6a 00                	push   $0x0
  800b7e:	6a 00                	push   $0x0
  800b80:	ff 75 0c             	pushl  0xc(%ebp)
  800b83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b86:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b90:	e8 95 ff ff ff       	call   800b2a <syscall>
}
  800b95:	83 c4 10             	add    $0x10,%esp
  800b98:	c9                   	leave  
  800b99:	c3                   	ret    

00800b9a <sys_cgetc>:

int
sys_cgetc(void)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800ba0:	6a 00                	push   $0x0
  800ba2:	6a 00                	push   $0x0
  800ba4:	6a 00                	push   $0x0
  800ba6:	6a 00                	push   $0x0
  800ba8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bad:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb2:	b8 01 00 00 00       	mov    $0x1,%eax
  800bb7:	e8 6e ff ff ff       	call   800b2a <syscall>
}
  800bbc:	c9                   	leave  
  800bbd:	c3                   	ret    

00800bbe <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800bc4:	6a 00                	push   $0x0
  800bc6:	6a 00                	push   $0x0
  800bc8:	6a 00                	push   $0x0
  800bca:	6a 00                	push   $0x0
  800bcc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bcf:	ba 01 00 00 00       	mov    $0x1,%edx
  800bd4:	b8 03 00 00 00       	mov    $0x3,%eax
  800bd9:	e8 4c ff ff ff       	call   800b2a <syscall>
}
  800bde:	c9                   	leave  
  800bdf:	c3                   	ret    

00800be0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800be6:	6a 00                	push   $0x0
  800be8:	6a 00                	push   $0x0
  800bea:	6a 00                	push   $0x0
  800bec:	6a 00                	push   $0x0
  800bee:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bf3:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf8:	b8 02 00 00 00       	mov    $0x2,%eax
  800bfd:	e8 28 ff ff ff       	call   800b2a <syscall>
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <sys_yield>:

void
sys_yield(void)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800c0a:	6a 00                	push   $0x0
  800c0c:	6a 00                	push   $0x0
  800c0e:	6a 00                	push   $0x0
  800c10:	6a 00                	push   $0x0
  800c12:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c17:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c21:	e8 04 ff ff ff       	call   800b2a <syscall>
}
  800c26:	83 c4 10             	add    $0x10,%esp
  800c29:	c9                   	leave  
  800c2a:	c3                   	ret    

00800c2b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800c31:	6a 00                	push   $0x0
  800c33:	6a 00                	push   $0x0
  800c35:	ff 75 10             	pushl  0x10(%ebp)
  800c38:	ff 75 0c             	pushl  0xc(%ebp)
  800c3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c3e:	ba 01 00 00 00       	mov    $0x1,%edx
  800c43:	b8 04 00 00 00       	mov    $0x4,%eax
  800c48:	e8 dd fe ff ff       	call   800b2a <syscall>
}
  800c4d:	c9                   	leave  
  800c4e:	c3                   	ret    

00800c4f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800c55:	ff 75 18             	pushl  0x18(%ebp)
  800c58:	ff 75 14             	pushl  0x14(%ebp)
  800c5b:	ff 75 10             	pushl  0x10(%ebp)
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c64:	ba 01 00 00 00       	mov    $0x1,%edx
  800c69:	b8 05 00 00 00       	mov    $0x5,%eax
  800c6e:	e8 b7 fe ff ff       	call   800b2a <syscall>
}
  800c73:	c9                   	leave  
  800c74:	c3                   	ret    

00800c75 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800c7b:	6a 00                	push   $0x0
  800c7d:	6a 00                	push   $0x0
  800c7f:	6a 00                	push   $0x0
  800c81:	ff 75 0c             	pushl  0xc(%ebp)
  800c84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c87:	ba 01 00 00 00       	mov    $0x1,%edx
  800c8c:	b8 06 00 00 00       	mov    $0x6,%eax
  800c91:	e8 94 fe ff ff       	call   800b2a <syscall>
}
  800c96:	c9                   	leave  
  800c97:	c3                   	ret    

00800c98 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c9e:	6a 00                	push   $0x0
  800ca0:	6a 00                	push   $0x0
  800ca2:	6a 00                	push   $0x0
  800ca4:	ff 75 0c             	pushl  0xc(%ebp)
  800ca7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800caa:	ba 01 00 00 00       	mov    $0x1,%edx
  800caf:	b8 08 00 00 00       	mov    $0x8,%eax
  800cb4:	e8 71 fe ff ff       	call   800b2a <syscall>
}
  800cb9:	c9                   	leave  
  800cba:	c3                   	ret    

00800cbb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800cc1:	6a 00                	push   $0x0
  800cc3:	6a 00                	push   $0x0
  800cc5:	6a 00                	push   $0x0
  800cc7:	ff 75 0c             	pushl  0xc(%ebp)
  800cca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ccd:	ba 01 00 00 00       	mov    $0x1,%edx
  800cd2:	b8 09 00 00 00       	mov    $0x9,%eax
  800cd7:	e8 4e fe ff ff       	call   800b2a <syscall>
}
  800cdc:	c9                   	leave  
  800cdd:	c3                   	ret    

00800cde <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800ce4:	6a 00                	push   $0x0
  800ce6:	6a 00                	push   $0x0
  800ce8:	6a 00                	push   $0x0
  800cea:	ff 75 0c             	pushl  0xc(%ebp)
  800ced:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cf0:	ba 01 00 00 00       	mov    $0x1,%edx
  800cf5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cfa:	e8 2b fe ff ff       	call   800b2a <syscall>
}
  800cff:	c9                   	leave  
  800d00:	c3                   	ret    

00800d01 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d01:	55                   	push   %ebp
  800d02:	89 e5                	mov    %esp,%ebp
  800d04:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800d07:	6a 00                	push   $0x0
  800d09:	ff 75 14             	pushl  0x14(%ebp)
  800d0c:	ff 75 10             	pushl  0x10(%ebp)
  800d0f:	ff 75 0c             	pushl  0xc(%ebp)
  800d12:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d15:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1a:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d1f:	e8 06 fe ff ff       	call   800b2a <syscall>
}
  800d24:	c9                   	leave  
  800d25:	c3                   	ret    

00800d26 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800d2c:	6a 00                	push   $0x0
  800d2e:	6a 00                	push   $0x0
  800d30:	6a 00                	push   $0x0
  800d32:	6a 00                	push   $0x0
  800d34:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d37:	ba 01 00 00 00       	mov    $0x1,%edx
  800d3c:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d41:	e8 e4 fd ff ff       	call   800b2a <syscall>
}
  800d46:	c9                   	leave  
  800d47:	c3                   	ret    

00800d48 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	05 00 00 00 30       	add    $0x30000000,%eax
  800d53:	c1 e8 0c             	shr    $0xc,%eax
}
  800d56:	5d                   	pop    %ebp
  800d57:	c3                   	ret    

00800d58 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  800d5b:	ff 75 08             	pushl  0x8(%ebp)
  800d5e:	e8 e5 ff ff ff       	call   800d48 <fd2num>
  800d63:	83 c4 04             	add    $0x4,%esp
  800d66:	c1 e0 0c             	shl    $0xc,%eax
  800d69:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800d6e:	c9                   	leave  
  800d6f:	c3                   	ret    

00800d70 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d76:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800d7b:	89 c2                	mov    %eax,%edx
  800d7d:	c1 ea 16             	shr    $0x16,%edx
  800d80:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800d87:	f6 c2 01             	test   $0x1,%dl
  800d8a:	74 11                	je     800d9d <fd_alloc+0x2d>
  800d8c:	89 c2                	mov    %eax,%edx
  800d8e:	c1 ea 0c             	shr    $0xc,%edx
  800d91:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d98:	f6 c2 01             	test   $0x1,%dl
  800d9b:	75 09                	jne    800da6 <fd_alloc+0x36>
			*fd_store = fd;
  800d9d:	89 01                	mov    %eax,(%ecx)
			return 0;
  800d9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800da4:	eb 17                	jmp    800dbd <fd_alloc+0x4d>
  800da6:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800dab:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800db0:	75 c9                	jne    800d7b <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800db2:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800db8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800dbd:	5d                   	pop    %ebp
  800dbe:	c3                   	ret    

00800dbf <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800dc5:	83 f8 1f             	cmp    $0x1f,%eax
  800dc8:	77 36                	ja     800e00 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800dca:	c1 e0 0c             	shl    $0xc,%eax
  800dcd:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800dd2:	89 c2                	mov    %eax,%edx
  800dd4:	c1 ea 16             	shr    $0x16,%edx
  800dd7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800dde:	f6 c2 01             	test   $0x1,%dl
  800de1:	74 24                	je     800e07 <fd_lookup+0x48>
  800de3:	89 c2                	mov    %eax,%edx
  800de5:	c1 ea 0c             	shr    $0xc,%edx
  800de8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800def:	f6 c2 01             	test   $0x1,%dl
  800df2:	74 1a                	je     800e0e <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800df4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df7:	89 02                	mov    %eax,(%edx)
	return 0;
  800df9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dfe:	eb 13                	jmp    800e13 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800e00:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e05:	eb 0c                	jmp    800e13 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800e07:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e0c:	eb 05                	jmp    800e13 <fd_lookup+0x54>
  800e0e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800e13:	5d                   	pop    %ebp
  800e14:	c3                   	ret    

00800e15 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e15:	55                   	push   %ebp
  800e16:	89 e5                	mov    %esp,%ebp
  800e18:	83 ec 08             	sub    $0x8,%esp
  800e1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e1e:	ba 6c 23 80 00       	mov    $0x80236c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800e23:	eb 13                	jmp    800e38 <dev_lookup+0x23>
  800e25:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  800e28:	39 08                	cmp    %ecx,(%eax)
  800e2a:	75 0c                	jne    800e38 <dev_lookup+0x23>
			*dev = devtab[i];
  800e2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2f:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e31:	b8 00 00 00 00       	mov    $0x0,%eax
  800e36:	eb 2e                	jmp    800e66 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800e38:	8b 02                	mov    (%edx),%eax
  800e3a:	85 c0                	test   %eax,%eax
  800e3c:	75 e7                	jne    800e25 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e3e:	a1 20 60 80 00       	mov    0x806020,%eax
  800e43:	8b 40 48             	mov    0x48(%eax),%eax
  800e46:	83 ec 04             	sub    $0x4,%esp
  800e49:	51                   	push   %ecx
  800e4a:	50                   	push   %eax
  800e4b:	68 ec 22 80 00       	push   $0x8022ec
  800e50:	e8 1b f4 ff ff       	call   800270 <cprintf>
	*dev = 0;
  800e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e5e:	83 c4 10             	add    $0x10,%esp
  800e61:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e66:	c9                   	leave  
  800e67:	c3                   	ret    

00800e68 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800e68:	55                   	push   %ebp
  800e69:	89 e5                	mov    %esp,%ebp
  800e6b:	56                   	push   %esi
  800e6c:	53                   	push   %ebx
  800e6d:	83 ec 10             	sub    $0x10,%esp
  800e70:	8b 75 08             	mov    0x8(%ebp),%esi
  800e73:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e76:	56                   	push   %esi
  800e77:	e8 cc fe ff ff       	call   800d48 <fd2num>
  800e7c:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800e7f:	89 14 24             	mov    %edx,(%esp)
  800e82:	50                   	push   %eax
  800e83:	e8 37 ff ff ff       	call   800dbf <fd_lookup>
  800e88:	83 c4 08             	add    $0x8,%esp
  800e8b:	85 c0                	test   %eax,%eax
  800e8d:	78 05                	js     800e94 <fd_close+0x2c>
	    || fd != fd2)
  800e8f:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800e92:	74 0c                	je     800ea0 <fd_close+0x38>
		return (must_exist ? r : 0);
  800e94:	84 db                	test   %bl,%bl
  800e96:	ba 00 00 00 00       	mov    $0x0,%edx
  800e9b:	0f 44 c2             	cmove  %edx,%eax
  800e9e:	eb 41                	jmp    800ee1 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800ea0:	83 ec 08             	sub    $0x8,%esp
  800ea3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ea6:	50                   	push   %eax
  800ea7:	ff 36                	pushl  (%esi)
  800ea9:	e8 67 ff ff ff       	call   800e15 <dev_lookup>
  800eae:	89 c3                	mov    %eax,%ebx
  800eb0:	83 c4 10             	add    $0x10,%esp
  800eb3:	85 c0                	test   %eax,%eax
  800eb5:	78 1a                	js     800ed1 <fd_close+0x69>
		if (dev->dev_close)
  800eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eba:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800ebd:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800ec2:	85 c0                	test   %eax,%eax
  800ec4:	74 0b                	je     800ed1 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  800ec6:	83 ec 0c             	sub    $0xc,%esp
  800ec9:	56                   	push   %esi
  800eca:	ff d0                	call   *%eax
  800ecc:	89 c3                	mov    %eax,%ebx
  800ece:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800ed1:	83 ec 08             	sub    $0x8,%esp
  800ed4:	56                   	push   %esi
  800ed5:	6a 00                	push   $0x0
  800ed7:	e8 99 fd ff ff       	call   800c75 <sys_page_unmap>
	return r;
  800edc:	83 c4 10             	add    $0x10,%esp
  800edf:	89 d8                	mov    %ebx,%eax
}
  800ee1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ee4:	5b                   	pop    %ebx
  800ee5:	5e                   	pop    %esi
  800ee6:	5d                   	pop    %ebp
  800ee7:	c3                   	ret    

00800ee8 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800eee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ef1:	50                   	push   %eax
  800ef2:	ff 75 08             	pushl  0x8(%ebp)
  800ef5:	e8 c5 fe ff ff       	call   800dbf <fd_lookup>
  800efa:	83 c4 08             	add    $0x8,%esp
  800efd:	85 c0                	test   %eax,%eax
  800eff:	78 10                	js     800f11 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800f01:	83 ec 08             	sub    $0x8,%esp
  800f04:	6a 01                	push   $0x1
  800f06:	ff 75 f4             	pushl  -0xc(%ebp)
  800f09:	e8 5a ff ff ff       	call   800e68 <fd_close>
  800f0e:	83 c4 10             	add    $0x10,%esp
}
  800f11:	c9                   	leave  
  800f12:	c3                   	ret    

00800f13 <close_all>:

void
close_all(void)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
  800f16:	53                   	push   %ebx
  800f17:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f1a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f1f:	83 ec 0c             	sub    $0xc,%esp
  800f22:	53                   	push   %ebx
  800f23:	e8 c0 ff ff ff       	call   800ee8 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800f28:	83 c3 01             	add    $0x1,%ebx
  800f2b:	83 c4 10             	add    $0x10,%esp
  800f2e:	83 fb 20             	cmp    $0x20,%ebx
  800f31:	75 ec                	jne    800f1f <close_all+0xc>
		close(i);
}
  800f33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f36:	c9                   	leave  
  800f37:	c3                   	ret    

00800f38 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	57                   	push   %edi
  800f3c:	56                   	push   %esi
  800f3d:	53                   	push   %ebx
  800f3e:	83 ec 2c             	sub    $0x2c,%esp
  800f41:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f44:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f47:	50                   	push   %eax
  800f48:	ff 75 08             	pushl  0x8(%ebp)
  800f4b:	e8 6f fe ff ff       	call   800dbf <fd_lookup>
  800f50:	83 c4 08             	add    $0x8,%esp
  800f53:	85 c0                	test   %eax,%eax
  800f55:	0f 88 c1 00 00 00    	js     80101c <dup+0xe4>
		return r;
	close(newfdnum);
  800f5b:	83 ec 0c             	sub    $0xc,%esp
  800f5e:	56                   	push   %esi
  800f5f:	e8 84 ff ff ff       	call   800ee8 <close>

	newfd = INDEX2FD(newfdnum);
  800f64:	89 f3                	mov    %esi,%ebx
  800f66:	c1 e3 0c             	shl    $0xc,%ebx
  800f69:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800f6f:	83 c4 04             	add    $0x4,%esp
  800f72:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f75:	e8 de fd ff ff       	call   800d58 <fd2data>
  800f7a:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  800f7c:	89 1c 24             	mov    %ebx,(%esp)
  800f7f:	e8 d4 fd ff ff       	call   800d58 <fd2data>
  800f84:	83 c4 10             	add    $0x10,%esp
  800f87:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800f8a:	89 f8                	mov    %edi,%eax
  800f8c:	c1 e8 16             	shr    $0x16,%eax
  800f8f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f96:	a8 01                	test   $0x1,%al
  800f98:	74 37                	je     800fd1 <dup+0x99>
  800f9a:	89 f8                	mov    %edi,%eax
  800f9c:	c1 e8 0c             	shr    $0xc,%eax
  800f9f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fa6:	f6 c2 01             	test   $0x1,%dl
  800fa9:	74 26                	je     800fd1 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800fab:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fb2:	83 ec 0c             	sub    $0xc,%esp
  800fb5:	25 07 0e 00 00       	and    $0xe07,%eax
  800fba:	50                   	push   %eax
  800fbb:	ff 75 d4             	pushl  -0x2c(%ebp)
  800fbe:	6a 00                	push   $0x0
  800fc0:	57                   	push   %edi
  800fc1:	6a 00                	push   $0x0
  800fc3:	e8 87 fc ff ff       	call   800c4f <sys_page_map>
  800fc8:	89 c7                	mov    %eax,%edi
  800fca:	83 c4 20             	add    $0x20,%esp
  800fcd:	85 c0                	test   %eax,%eax
  800fcf:	78 2e                	js     800fff <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800fd1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800fd4:	89 d0                	mov    %edx,%eax
  800fd6:	c1 e8 0c             	shr    $0xc,%eax
  800fd9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fe0:	83 ec 0c             	sub    $0xc,%esp
  800fe3:	25 07 0e 00 00       	and    $0xe07,%eax
  800fe8:	50                   	push   %eax
  800fe9:	53                   	push   %ebx
  800fea:	6a 00                	push   $0x0
  800fec:	52                   	push   %edx
  800fed:	6a 00                	push   $0x0
  800fef:	e8 5b fc ff ff       	call   800c4f <sys_page_map>
  800ff4:	89 c7                	mov    %eax,%edi
  800ff6:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  800ff9:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800ffb:	85 ff                	test   %edi,%edi
  800ffd:	79 1d                	jns    80101c <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800fff:	83 ec 08             	sub    $0x8,%esp
  801002:	53                   	push   %ebx
  801003:	6a 00                	push   $0x0
  801005:	e8 6b fc ff ff       	call   800c75 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80100a:	83 c4 08             	add    $0x8,%esp
  80100d:	ff 75 d4             	pushl  -0x2c(%ebp)
  801010:	6a 00                	push   $0x0
  801012:	e8 5e fc ff ff       	call   800c75 <sys_page_unmap>
	return r;
  801017:	83 c4 10             	add    $0x10,%esp
  80101a:	89 f8                	mov    %edi,%eax
}
  80101c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80101f:	5b                   	pop    %ebx
  801020:	5e                   	pop    %esi
  801021:	5f                   	pop    %edi
  801022:	5d                   	pop    %ebp
  801023:	c3                   	ret    

00801024 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801024:	55                   	push   %ebp
  801025:	89 e5                	mov    %esp,%ebp
  801027:	53                   	push   %ebx
  801028:	83 ec 14             	sub    $0x14,%esp
  80102b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80102e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801031:	50                   	push   %eax
  801032:	53                   	push   %ebx
  801033:	e8 87 fd ff ff       	call   800dbf <fd_lookup>
  801038:	83 c4 08             	add    $0x8,%esp
  80103b:	89 c2                	mov    %eax,%edx
  80103d:	85 c0                	test   %eax,%eax
  80103f:	78 6d                	js     8010ae <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801041:	83 ec 08             	sub    $0x8,%esp
  801044:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801047:	50                   	push   %eax
  801048:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80104b:	ff 30                	pushl  (%eax)
  80104d:	e8 c3 fd ff ff       	call   800e15 <dev_lookup>
  801052:	83 c4 10             	add    $0x10,%esp
  801055:	85 c0                	test   %eax,%eax
  801057:	78 4c                	js     8010a5 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801059:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80105c:	8b 42 08             	mov    0x8(%edx),%eax
  80105f:	83 e0 03             	and    $0x3,%eax
  801062:	83 f8 01             	cmp    $0x1,%eax
  801065:	75 21                	jne    801088 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801067:	a1 20 60 80 00       	mov    0x806020,%eax
  80106c:	8b 40 48             	mov    0x48(%eax),%eax
  80106f:	83 ec 04             	sub    $0x4,%esp
  801072:	53                   	push   %ebx
  801073:	50                   	push   %eax
  801074:	68 30 23 80 00       	push   $0x802330
  801079:	e8 f2 f1 ff ff       	call   800270 <cprintf>
		return -E_INVAL;
  80107e:	83 c4 10             	add    $0x10,%esp
  801081:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801086:	eb 26                	jmp    8010ae <read+0x8a>
	}
	if (!dev->dev_read)
  801088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80108b:	8b 40 08             	mov    0x8(%eax),%eax
  80108e:	85 c0                	test   %eax,%eax
  801090:	74 17                	je     8010a9 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801092:	83 ec 04             	sub    $0x4,%esp
  801095:	ff 75 10             	pushl  0x10(%ebp)
  801098:	ff 75 0c             	pushl  0xc(%ebp)
  80109b:	52                   	push   %edx
  80109c:	ff d0                	call   *%eax
  80109e:	89 c2                	mov    %eax,%edx
  8010a0:	83 c4 10             	add    $0x10,%esp
  8010a3:	eb 09                	jmp    8010ae <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010a5:	89 c2                	mov    %eax,%edx
  8010a7:	eb 05                	jmp    8010ae <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8010a9:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  8010ae:	89 d0                	mov    %edx,%eax
  8010b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010b3:	c9                   	leave  
  8010b4:	c3                   	ret    

008010b5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
  8010b8:	57                   	push   %edi
  8010b9:	56                   	push   %esi
  8010ba:	53                   	push   %ebx
  8010bb:	83 ec 0c             	sub    $0xc,%esp
  8010be:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010c1:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8010c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c9:	eb 21                	jmp    8010ec <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010cb:	83 ec 04             	sub    $0x4,%esp
  8010ce:	89 f0                	mov    %esi,%eax
  8010d0:	29 d8                	sub    %ebx,%eax
  8010d2:	50                   	push   %eax
  8010d3:	89 d8                	mov    %ebx,%eax
  8010d5:	03 45 0c             	add    0xc(%ebp),%eax
  8010d8:	50                   	push   %eax
  8010d9:	57                   	push   %edi
  8010da:	e8 45 ff ff ff       	call   801024 <read>
		if (m < 0)
  8010df:	83 c4 10             	add    $0x10,%esp
  8010e2:	85 c0                	test   %eax,%eax
  8010e4:	78 10                	js     8010f6 <readn+0x41>
			return m;
		if (m == 0)
  8010e6:	85 c0                	test   %eax,%eax
  8010e8:	74 0a                	je     8010f4 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8010ea:	01 c3                	add    %eax,%ebx
  8010ec:	39 f3                	cmp    %esi,%ebx
  8010ee:	72 db                	jb     8010cb <readn+0x16>
  8010f0:	89 d8                	mov    %ebx,%eax
  8010f2:	eb 02                	jmp    8010f6 <readn+0x41>
  8010f4:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8010f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f9:	5b                   	pop    %ebx
  8010fa:	5e                   	pop    %esi
  8010fb:	5f                   	pop    %edi
  8010fc:	5d                   	pop    %ebp
  8010fd:	c3                   	ret    

008010fe <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8010fe:	55                   	push   %ebp
  8010ff:	89 e5                	mov    %esp,%ebp
  801101:	53                   	push   %ebx
  801102:	83 ec 14             	sub    $0x14,%esp
  801105:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801108:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80110b:	50                   	push   %eax
  80110c:	53                   	push   %ebx
  80110d:	e8 ad fc ff ff       	call   800dbf <fd_lookup>
  801112:	83 c4 08             	add    $0x8,%esp
  801115:	89 c2                	mov    %eax,%edx
  801117:	85 c0                	test   %eax,%eax
  801119:	78 68                	js     801183 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80111b:	83 ec 08             	sub    $0x8,%esp
  80111e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801121:	50                   	push   %eax
  801122:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801125:	ff 30                	pushl  (%eax)
  801127:	e8 e9 fc ff ff       	call   800e15 <dev_lookup>
  80112c:	83 c4 10             	add    $0x10,%esp
  80112f:	85 c0                	test   %eax,%eax
  801131:	78 47                	js     80117a <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801136:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80113a:	75 21                	jne    80115d <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80113c:	a1 20 60 80 00       	mov    0x806020,%eax
  801141:	8b 40 48             	mov    0x48(%eax),%eax
  801144:	83 ec 04             	sub    $0x4,%esp
  801147:	53                   	push   %ebx
  801148:	50                   	push   %eax
  801149:	68 4c 23 80 00       	push   $0x80234c
  80114e:	e8 1d f1 ff ff       	call   800270 <cprintf>
		return -E_INVAL;
  801153:	83 c4 10             	add    $0x10,%esp
  801156:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80115b:	eb 26                	jmp    801183 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80115d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801160:	8b 52 0c             	mov    0xc(%edx),%edx
  801163:	85 d2                	test   %edx,%edx
  801165:	74 17                	je     80117e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801167:	83 ec 04             	sub    $0x4,%esp
  80116a:	ff 75 10             	pushl  0x10(%ebp)
  80116d:	ff 75 0c             	pushl  0xc(%ebp)
  801170:	50                   	push   %eax
  801171:	ff d2                	call   *%edx
  801173:	89 c2                	mov    %eax,%edx
  801175:	83 c4 10             	add    $0x10,%esp
  801178:	eb 09                	jmp    801183 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80117a:	89 c2                	mov    %eax,%edx
  80117c:	eb 05                	jmp    801183 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80117e:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  801183:	89 d0                	mov    %edx,%eax
  801185:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <seek>:

int
seek(int fdnum, off_t offset)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801190:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801193:	50                   	push   %eax
  801194:	ff 75 08             	pushl  0x8(%ebp)
  801197:	e8 23 fc ff ff       	call   800dbf <fd_lookup>
  80119c:	83 c4 08             	add    $0x8,%esp
  80119f:	85 c0                	test   %eax,%eax
  8011a1:	78 0e                	js     8011b1 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8011a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011a9:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8011ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011b1:	c9                   	leave  
  8011b2:	c3                   	ret    

008011b3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8011b3:	55                   	push   %ebp
  8011b4:	89 e5                	mov    %esp,%ebp
  8011b6:	53                   	push   %ebx
  8011b7:	83 ec 14             	sub    $0x14,%esp
  8011ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011c0:	50                   	push   %eax
  8011c1:	53                   	push   %ebx
  8011c2:	e8 f8 fb ff ff       	call   800dbf <fd_lookup>
  8011c7:	83 c4 08             	add    $0x8,%esp
  8011ca:	89 c2                	mov    %eax,%edx
  8011cc:	85 c0                	test   %eax,%eax
  8011ce:	78 65                	js     801235 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011d0:	83 ec 08             	sub    $0x8,%esp
  8011d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011d6:	50                   	push   %eax
  8011d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011da:	ff 30                	pushl  (%eax)
  8011dc:	e8 34 fc ff ff       	call   800e15 <dev_lookup>
  8011e1:	83 c4 10             	add    $0x10,%esp
  8011e4:	85 c0                	test   %eax,%eax
  8011e6:	78 44                	js     80122c <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011eb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011ef:	75 21                	jne    801212 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8011f1:	a1 20 60 80 00       	mov    0x806020,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8011f6:	8b 40 48             	mov    0x48(%eax),%eax
  8011f9:	83 ec 04             	sub    $0x4,%esp
  8011fc:	53                   	push   %ebx
  8011fd:	50                   	push   %eax
  8011fe:	68 0c 23 80 00       	push   $0x80230c
  801203:	e8 68 f0 ff ff       	call   800270 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801208:	83 c4 10             	add    $0x10,%esp
  80120b:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801210:	eb 23                	jmp    801235 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  801212:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801215:	8b 52 18             	mov    0x18(%edx),%edx
  801218:	85 d2                	test   %edx,%edx
  80121a:	74 14                	je     801230 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80121c:	83 ec 08             	sub    $0x8,%esp
  80121f:	ff 75 0c             	pushl  0xc(%ebp)
  801222:	50                   	push   %eax
  801223:	ff d2                	call   *%edx
  801225:	89 c2                	mov    %eax,%edx
  801227:	83 c4 10             	add    $0x10,%esp
  80122a:	eb 09                	jmp    801235 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80122c:	89 c2                	mov    %eax,%edx
  80122e:	eb 05                	jmp    801235 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801230:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  801235:	89 d0                	mov    %edx,%eax
  801237:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80123a:	c9                   	leave  
  80123b:	c3                   	ret    

0080123c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
  80123f:	53                   	push   %ebx
  801240:	83 ec 14             	sub    $0x14,%esp
  801243:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801246:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801249:	50                   	push   %eax
  80124a:	ff 75 08             	pushl  0x8(%ebp)
  80124d:	e8 6d fb ff ff       	call   800dbf <fd_lookup>
  801252:	83 c4 08             	add    $0x8,%esp
  801255:	89 c2                	mov    %eax,%edx
  801257:	85 c0                	test   %eax,%eax
  801259:	78 58                	js     8012b3 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80125b:	83 ec 08             	sub    $0x8,%esp
  80125e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801261:	50                   	push   %eax
  801262:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801265:	ff 30                	pushl  (%eax)
  801267:	e8 a9 fb ff ff       	call   800e15 <dev_lookup>
  80126c:	83 c4 10             	add    $0x10,%esp
  80126f:	85 c0                	test   %eax,%eax
  801271:	78 37                	js     8012aa <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  801273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801276:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80127a:	74 32                	je     8012ae <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80127c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80127f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801286:	00 00 00 
	stat->st_isdir = 0;
  801289:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801290:	00 00 00 
	stat->st_dev = dev;
  801293:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801299:	83 ec 08             	sub    $0x8,%esp
  80129c:	53                   	push   %ebx
  80129d:	ff 75 f0             	pushl  -0x10(%ebp)
  8012a0:	ff 50 14             	call   *0x14(%eax)
  8012a3:	89 c2                	mov    %eax,%edx
  8012a5:	83 c4 10             	add    $0x10,%esp
  8012a8:	eb 09                	jmp    8012b3 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012aa:	89 c2                	mov    %eax,%edx
  8012ac:	eb 05                	jmp    8012b3 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8012ae:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8012b3:	89 d0                	mov    %edx,%eax
  8012b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012b8:	c9                   	leave  
  8012b9:	c3                   	ret    

008012ba <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8012ba:	55                   	push   %ebp
  8012bb:	89 e5                	mov    %esp,%ebp
  8012bd:	56                   	push   %esi
  8012be:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8012bf:	83 ec 08             	sub    $0x8,%esp
  8012c2:	6a 00                	push   $0x0
  8012c4:	ff 75 08             	pushl  0x8(%ebp)
  8012c7:	e8 06 02 00 00       	call   8014d2 <open>
  8012cc:	89 c3                	mov    %eax,%ebx
  8012ce:	83 c4 10             	add    $0x10,%esp
  8012d1:	85 c0                	test   %eax,%eax
  8012d3:	78 1b                	js     8012f0 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8012d5:	83 ec 08             	sub    $0x8,%esp
  8012d8:	ff 75 0c             	pushl  0xc(%ebp)
  8012db:	50                   	push   %eax
  8012dc:	e8 5b ff ff ff       	call   80123c <fstat>
  8012e1:	89 c6                	mov    %eax,%esi
	close(fd);
  8012e3:	89 1c 24             	mov    %ebx,(%esp)
  8012e6:	e8 fd fb ff ff       	call   800ee8 <close>
	return r;
  8012eb:	83 c4 10             	add    $0x10,%esp
  8012ee:	89 f0                	mov    %esi,%eax
}
  8012f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012f3:	5b                   	pop    %ebx
  8012f4:	5e                   	pop    %esi
  8012f5:	5d                   	pop    %ebp
  8012f6:	c3                   	ret    

008012f7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8012f7:	55                   	push   %ebp
  8012f8:	89 e5                	mov    %esp,%ebp
  8012fa:	56                   	push   %esi
  8012fb:	53                   	push   %ebx
  8012fc:	89 c6                	mov    %eax,%esi
  8012fe:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801300:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801307:	75 12                	jne    80131b <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801309:	83 ec 0c             	sub    $0xc,%esp
  80130c:	6a 01                	push   $0x1
  80130e:	e8 11 09 00 00       	call   801c24 <ipc_find_env>
  801313:	a3 00 40 80 00       	mov    %eax,0x804000
  801318:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80131b:	6a 07                	push   $0x7
  80131d:	68 00 70 80 00       	push   $0x807000
  801322:	56                   	push   %esi
  801323:	ff 35 00 40 80 00    	pushl  0x804000
  801329:	e8 a2 08 00 00       	call   801bd0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80132e:	83 c4 0c             	add    $0xc,%esp
  801331:	6a 00                	push   $0x0
  801333:	53                   	push   %ebx
  801334:	6a 00                	push   $0x0
  801336:	e8 2a 08 00 00       	call   801b65 <ipc_recv>
}
  80133b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80133e:	5b                   	pop    %ebx
  80133f:	5e                   	pop    %esi
  801340:	5d                   	pop    %ebp
  801341:	c3                   	ret    

00801342 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
  801345:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
  80134b:	8b 40 0c             	mov    0xc(%eax),%eax
  80134e:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  801353:	8b 45 0c             	mov    0xc(%ebp),%eax
  801356:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80135b:	ba 00 00 00 00       	mov    $0x0,%edx
  801360:	b8 02 00 00 00       	mov    $0x2,%eax
  801365:	e8 8d ff ff ff       	call   8012f7 <fsipc>
}
  80136a:	c9                   	leave  
  80136b:	c3                   	ret    

0080136c <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	8b 40 0c             	mov    0xc(%eax),%eax
  801378:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  80137d:	ba 00 00 00 00       	mov    $0x0,%edx
  801382:	b8 06 00 00 00       	mov    $0x6,%eax
  801387:	e8 6b ff ff ff       	call   8012f7 <fsipc>
}
  80138c:	c9                   	leave  
  80138d:	c3                   	ret    

0080138e <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	53                   	push   %ebx
  801392:	83 ec 04             	sub    $0x4,%esp
  801395:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801398:	8b 45 08             	mov    0x8(%ebp),%eax
  80139b:	8b 40 0c             	mov    0xc(%eax),%eax
  80139e:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8013a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a8:	b8 05 00 00 00       	mov    $0x5,%eax
  8013ad:	e8 45 ff ff ff       	call   8012f7 <fsipc>
  8013b2:	85 c0                	test   %eax,%eax
  8013b4:	78 2c                	js     8013e2 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8013b6:	83 ec 08             	sub    $0x8,%esp
  8013b9:	68 00 70 80 00       	push   $0x807000
  8013be:	53                   	push   %ebx
  8013bf:	e8 1e f4 ff ff       	call   8007e2 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8013c4:	a1 80 70 80 00       	mov    0x807080,%eax
  8013c9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8013cf:	a1 84 70 80 00       	mov    0x807084,%eax
  8013d4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8013da:	83 c4 10             	add    $0x10,%esp
  8013dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e5:	c9                   	leave  
  8013e6:	c3                   	ret    

008013e7 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	83 ec 08             	sub    $0x8,%esp
  8013ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f0:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8013f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013f6:	8b 49 0c             	mov    0xc(%ecx),%ecx
  8013f9:	89 0d 00 70 80 00    	mov    %ecx,0x807000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  8013ff:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801404:	76 22                	jbe    801428 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  801406:	c7 05 04 70 80 00 f8 	movl   $0xff8,0x807004
  80140d:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  801410:	83 ec 04             	sub    $0x4,%esp
  801413:	68 f8 0f 00 00       	push   $0xff8
  801418:	52                   	push   %edx
  801419:	68 08 70 80 00       	push   $0x807008
  80141e:	e8 52 f5 ff ff       	call   800975 <memmove>
  801423:	83 c4 10             	add    $0x10,%esp
  801426:	eb 17                	jmp    80143f <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  801428:	a3 04 70 80 00       	mov    %eax,0x807004
		memmove(fsipcbuf.write.req_buf, buf, n);
  80142d:	83 ec 04             	sub    $0x4,%esp
  801430:	50                   	push   %eax
  801431:	52                   	push   %edx
  801432:	68 08 70 80 00       	push   $0x807008
  801437:	e8 39 f5 ff ff       	call   800975 <memmove>
  80143c:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  80143f:	ba 00 00 00 00       	mov    $0x0,%edx
  801444:	b8 04 00 00 00       	mov    $0x4,%eax
  801449:	e8 a9 fe ff ff       	call   8012f7 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    

00801450 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	56                   	push   %esi
  801454:	53                   	push   %ebx
  801455:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801458:	8b 45 08             	mov    0x8(%ebp),%eax
  80145b:	8b 40 0c             	mov    0xc(%eax),%eax
  80145e:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  801463:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801469:	ba 00 00 00 00       	mov    $0x0,%edx
  80146e:	b8 03 00 00 00       	mov    $0x3,%eax
  801473:	e8 7f fe ff ff       	call   8012f7 <fsipc>
  801478:	89 c3                	mov    %eax,%ebx
  80147a:	85 c0                	test   %eax,%eax
  80147c:	78 4b                	js     8014c9 <devfile_read+0x79>
		return r;
	assert(r <= n);
  80147e:	39 c6                	cmp    %eax,%esi
  801480:	73 16                	jae    801498 <devfile_read+0x48>
  801482:	68 7c 23 80 00       	push   $0x80237c
  801487:	68 83 23 80 00       	push   $0x802383
  80148c:	6a 7c                	push   $0x7c
  80148e:	68 98 23 80 00       	push   $0x802398
  801493:	e8 ff ec ff ff       	call   800197 <_panic>
	assert(r <= PGSIZE);
  801498:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80149d:	7e 16                	jle    8014b5 <devfile_read+0x65>
  80149f:	68 a3 23 80 00       	push   $0x8023a3
  8014a4:	68 83 23 80 00       	push   $0x802383
  8014a9:	6a 7d                	push   $0x7d
  8014ab:	68 98 23 80 00       	push   $0x802398
  8014b0:	e8 e2 ec ff ff       	call   800197 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8014b5:	83 ec 04             	sub    $0x4,%esp
  8014b8:	50                   	push   %eax
  8014b9:	68 00 70 80 00       	push   $0x807000
  8014be:	ff 75 0c             	pushl  0xc(%ebp)
  8014c1:	e8 af f4 ff ff       	call   800975 <memmove>
	return r;
  8014c6:	83 c4 10             	add    $0x10,%esp
}
  8014c9:	89 d8                	mov    %ebx,%eax
  8014cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014ce:	5b                   	pop    %ebx
  8014cf:	5e                   	pop    %esi
  8014d0:	5d                   	pop    %ebp
  8014d1:	c3                   	ret    

008014d2 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
  8014d5:	53                   	push   %ebx
  8014d6:	83 ec 20             	sub    $0x20,%esp
  8014d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8014dc:	53                   	push   %ebx
  8014dd:	e8 c7 f2 ff ff       	call   8007a9 <strlen>
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8014ea:	7f 67                	jg     801553 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8014ec:	83 ec 0c             	sub    $0xc,%esp
  8014ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f2:	50                   	push   %eax
  8014f3:	e8 78 f8 ff ff       	call   800d70 <fd_alloc>
  8014f8:	83 c4 10             	add    $0x10,%esp
		return r;
  8014fb:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8014fd:	85 c0                	test   %eax,%eax
  8014ff:	78 57                	js     801558 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801501:	83 ec 08             	sub    $0x8,%esp
  801504:	53                   	push   %ebx
  801505:	68 00 70 80 00       	push   $0x807000
  80150a:	e8 d3 f2 ff ff       	call   8007e2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80150f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801512:	a3 00 74 80 00       	mov    %eax,0x807400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801517:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80151a:	b8 01 00 00 00       	mov    $0x1,%eax
  80151f:	e8 d3 fd ff ff       	call   8012f7 <fsipc>
  801524:	89 c3                	mov    %eax,%ebx
  801526:	83 c4 10             	add    $0x10,%esp
  801529:	85 c0                	test   %eax,%eax
  80152b:	79 14                	jns    801541 <open+0x6f>
		fd_close(fd, 0);
  80152d:	83 ec 08             	sub    $0x8,%esp
  801530:	6a 00                	push   $0x0
  801532:	ff 75 f4             	pushl  -0xc(%ebp)
  801535:	e8 2e f9 ff ff       	call   800e68 <fd_close>
		return r;
  80153a:	83 c4 10             	add    $0x10,%esp
  80153d:	89 da                	mov    %ebx,%edx
  80153f:	eb 17                	jmp    801558 <open+0x86>
	}

	return fd2num(fd);
  801541:	83 ec 0c             	sub    $0xc,%esp
  801544:	ff 75 f4             	pushl  -0xc(%ebp)
  801547:	e8 fc f7 ff ff       	call   800d48 <fd2num>
  80154c:	89 c2                	mov    %eax,%edx
  80154e:	83 c4 10             	add    $0x10,%esp
  801551:	eb 05                	jmp    801558 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801553:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801558:	89 d0                	mov    %edx,%eax
  80155a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    

0080155f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
  801562:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801565:	ba 00 00 00 00       	mov    $0x0,%edx
  80156a:	b8 08 00 00 00       	mov    $0x8,%eax
  80156f:	e8 83 fd ff ff       	call   8012f7 <fsipc>
}
  801574:	c9                   	leave  
  801575:	c3                   	ret    

00801576 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801576:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  80157a:	7e 37                	jle    8015b3 <writebuf+0x3d>
};


static void
writebuf(struct printbuf *b)
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
  80157f:	53                   	push   %ebx
  801580:	83 ec 08             	sub    $0x8,%esp
  801583:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
		ssize_t result = write(b->fd, b->buf, b->idx);
  801585:	ff 70 04             	pushl  0x4(%eax)
  801588:	8d 40 10             	lea    0x10(%eax),%eax
  80158b:	50                   	push   %eax
  80158c:	ff 33                	pushl  (%ebx)
  80158e:	e8 6b fb ff ff       	call   8010fe <write>
		if (result > 0)
  801593:	83 c4 10             	add    $0x10,%esp
  801596:	85 c0                	test   %eax,%eax
  801598:	7e 03                	jle    80159d <writebuf+0x27>
			b->result += result;
  80159a:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80159d:	3b 43 04             	cmp    0x4(%ebx),%eax
  8015a0:	74 0d                	je     8015af <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  8015a2:	85 c0                	test   %eax,%eax
  8015a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a9:	0f 4f c2             	cmovg  %edx,%eax
  8015ac:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8015af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b2:	c9                   	leave  
  8015b3:	f3 c3                	repz ret 

008015b5 <putch>:

static void
putch(int ch, void *thunk)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	53                   	push   %ebx
  8015b9:	83 ec 04             	sub    $0x4,%esp
  8015bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8015bf:	8b 53 04             	mov    0x4(%ebx),%edx
  8015c2:	8d 42 01             	lea    0x1(%edx),%eax
  8015c5:	89 43 04             	mov    %eax,0x4(%ebx)
  8015c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015cb:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8015cf:	3d 00 01 00 00       	cmp    $0x100,%eax
  8015d4:	75 0e                	jne    8015e4 <putch+0x2f>
		writebuf(b);
  8015d6:	89 d8                	mov    %ebx,%eax
  8015d8:	e8 99 ff ff ff       	call   801576 <writebuf>
		b->idx = 0;
  8015dd:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  8015e4:	83 c4 04             	add    $0x4,%esp
  8015e7:	5b                   	pop    %ebx
  8015e8:	5d                   	pop    %ebp
  8015e9:	c3                   	ret    

008015ea <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
  8015ed:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8015fc:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801603:	00 00 00 
	b.result = 0;
  801606:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80160d:	00 00 00 
	b.error = 1;
  801610:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801617:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80161a:	ff 75 10             	pushl  0x10(%ebp)
  80161d:	ff 75 0c             	pushl  0xc(%ebp)
  801620:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801626:	50                   	push   %eax
  801627:	68 b5 15 80 00       	push   $0x8015b5
  80162c:	e8 a8 ed ff ff       	call   8003d9 <vprintfmt>
	if (b.idx > 0)
  801631:	83 c4 10             	add    $0x10,%esp
  801634:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  80163b:	7e 0b                	jle    801648 <vfprintf+0x5e>
		writebuf(&b);
  80163d:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801643:	e8 2e ff ff ff       	call   801576 <writebuf>

	return (b.result ? b.result : b.error);
  801648:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80164e:	85 c0                	test   %eax,%eax
  801650:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80165f:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801662:	50                   	push   %eax
  801663:	ff 75 0c             	pushl  0xc(%ebp)
  801666:	ff 75 08             	pushl  0x8(%ebp)
  801669:	e8 7c ff ff ff       	call   8015ea <vfprintf>
	va_end(ap);

	return cnt;
}
  80166e:	c9                   	leave  
  80166f:	c3                   	ret    

00801670 <printf>:

int
printf(const char *fmt, ...)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801676:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801679:	50                   	push   %eax
  80167a:	ff 75 08             	pushl  0x8(%ebp)
  80167d:	6a 01                	push   $0x1
  80167f:	e8 66 ff ff ff       	call   8015ea <vfprintf>
	va_end(ap);

	return cnt;
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	56                   	push   %esi
  80168a:	53                   	push   %ebx
  80168b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80168e:	83 ec 0c             	sub    $0xc,%esp
  801691:	ff 75 08             	pushl  0x8(%ebp)
  801694:	e8 bf f6 ff ff       	call   800d58 <fd2data>
  801699:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80169b:	83 c4 08             	add    $0x8,%esp
  80169e:	68 af 23 80 00       	push   $0x8023af
  8016a3:	53                   	push   %ebx
  8016a4:	e8 39 f1 ff ff       	call   8007e2 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8016a9:	8b 46 04             	mov    0x4(%esi),%eax
  8016ac:	2b 06                	sub    (%esi),%eax
  8016ae:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8016b4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016bb:	00 00 00 
	stat->st_dev = &devpipe;
  8016be:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8016c5:	30 80 00 
	return 0;
}
  8016c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016d0:	5b                   	pop    %ebx
  8016d1:	5e                   	pop    %esi
  8016d2:	5d                   	pop    %ebp
  8016d3:	c3                   	ret    

008016d4 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
  8016d7:	53                   	push   %ebx
  8016d8:	83 ec 0c             	sub    $0xc,%esp
  8016db:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8016de:	53                   	push   %ebx
  8016df:	6a 00                	push   $0x0
  8016e1:	e8 8f f5 ff ff       	call   800c75 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8016e6:	89 1c 24             	mov    %ebx,(%esp)
  8016e9:	e8 6a f6 ff ff       	call   800d58 <fd2data>
  8016ee:	83 c4 08             	add    $0x8,%esp
  8016f1:	50                   	push   %eax
  8016f2:	6a 00                	push   $0x0
  8016f4:	e8 7c f5 ff ff       	call   800c75 <sys_page_unmap>
}
  8016f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	57                   	push   %edi
  801702:	56                   	push   %esi
  801703:	53                   	push   %ebx
  801704:	83 ec 1c             	sub    $0x1c,%esp
  801707:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80170a:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80170c:	a1 20 60 80 00       	mov    0x806020,%eax
  801711:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801714:	83 ec 0c             	sub    $0xc,%esp
  801717:	ff 75 e0             	pushl  -0x20(%ebp)
  80171a:	e8 3e 05 00 00       	call   801c5d <pageref>
  80171f:	89 c3                	mov    %eax,%ebx
  801721:	89 3c 24             	mov    %edi,(%esp)
  801724:	e8 34 05 00 00       	call   801c5d <pageref>
  801729:	83 c4 10             	add    $0x10,%esp
  80172c:	39 c3                	cmp    %eax,%ebx
  80172e:	0f 94 c1             	sete   %cl
  801731:	0f b6 c9             	movzbl %cl,%ecx
  801734:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801737:	8b 15 20 60 80 00    	mov    0x806020,%edx
  80173d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801740:	39 ce                	cmp    %ecx,%esi
  801742:	74 1b                	je     80175f <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801744:	39 c3                	cmp    %eax,%ebx
  801746:	75 c4                	jne    80170c <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801748:	8b 42 58             	mov    0x58(%edx),%eax
  80174b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80174e:	50                   	push   %eax
  80174f:	56                   	push   %esi
  801750:	68 b6 23 80 00       	push   $0x8023b6
  801755:	e8 16 eb ff ff       	call   800270 <cprintf>
  80175a:	83 c4 10             	add    $0x10,%esp
  80175d:	eb ad                	jmp    80170c <_pipeisclosed+0xe>
	}
}
  80175f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801762:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801765:	5b                   	pop    %ebx
  801766:	5e                   	pop    %esi
  801767:	5f                   	pop    %edi
  801768:	5d                   	pop    %ebp
  801769:	c3                   	ret    

0080176a <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	57                   	push   %edi
  80176e:	56                   	push   %esi
  80176f:	53                   	push   %ebx
  801770:	83 ec 28             	sub    $0x28,%esp
  801773:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801776:	56                   	push   %esi
  801777:	e8 dc f5 ff ff       	call   800d58 <fd2data>
  80177c:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80177e:	83 c4 10             	add    $0x10,%esp
  801781:	bf 00 00 00 00       	mov    $0x0,%edi
  801786:	eb 4b                	jmp    8017d3 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801788:	89 da                	mov    %ebx,%edx
  80178a:	89 f0                	mov    %esi,%eax
  80178c:	e8 6d ff ff ff       	call   8016fe <_pipeisclosed>
  801791:	85 c0                	test   %eax,%eax
  801793:	75 48                	jne    8017dd <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801795:	e8 6a f4 ff ff       	call   800c04 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80179a:	8b 43 04             	mov    0x4(%ebx),%eax
  80179d:	8b 0b                	mov    (%ebx),%ecx
  80179f:	8d 51 20             	lea    0x20(%ecx),%edx
  8017a2:	39 d0                	cmp    %edx,%eax
  8017a4:	73 e2                	jae    801788 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8017a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017a9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8017ad:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8017b0:	89 c2                	mov    %eax,%edx
  8017b2:	c1 fa 1f             	sar    $0x1f,%edx
  8017b5:	89 d1                	mov    %edx,%ecx
  8017b7:	c1 e9 1b             	shr    $0x1b,%ecx
  8017ba:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8017bd:	83 e2 1f             	and    $0x1f,%edx
  8017c0:	29 ca                	sub    %ecx,%edx
  8017c2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8017c6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8017ca:	83 c0 01             	add    $0x1,%eax
  8017cd:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8017d0:	83 c7 01             	add    $0x1,%edi
  8017d3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8017d6:	75 c2                	jne    80179a <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8017d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017db:	eb 05                	jmp    8017e2 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8017dd:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8017e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017e5:	5b                   	pop    %ebx
  8017e6:	5e                   	pop    %esi
  8017e7:	5f                   	pop    %edi
  8017e8:	5d                   	pop    %ebp
  8017e9:	c3                   	ret    

008017ea <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	57                   	push   %edi
  8017ee:	56                   	push   %esi
  8017ef:	53                   	push   %ebx
  8017f0:	83 ec 18             	sub    $0x18,%esp
  8017f3:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8017f6:	57                   	push   %edi
  8017f7:	e8 5c f5 ff ff       	call   800d58 <fd2data>
  8017fc:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8017fe:	83 c4 10             	add    $0x10,%esp
  801801:	bb 00 00 00 00       	mov    $0x0,%ebx
  801806:	eb 3d                	jmp    801845 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801808:	85 db                	test   %ebx,%ebx
  80180a:	74 04                	je     801810 <devpipe_read+0x26>
				return i;
  80180c:	89 d8                	mov    %ebx,%eax
  80180e:	eb 44                	jmp    801854 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801810:	89 f2                	mov    %esi,%edx
  801812:	89 f8                	mov    %edi,%eax
  801814:	e8 e5 fe ff ff       	call   8016fe <_pipeisclosed>
  801819:	85 c0                	test   %eax,%eax
  80181b:	75 32                	jne    80184f <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80181d:	e8 e2 f3 ff ff       	call   800c04 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801822:	8b 06                	mov    (%esi),%eax
  801824:	3b 46 04             	cmp    0x4(%esi),%eax
  801827:	74 df                	je     801808 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801829:	99                   	cltd   
  80182a:	c1 ea 1b             	shr    $0x1b,%edx
  80182d:	01 d0                	add    %edx,%eax
  80182f:	83 e0 1f             	and    $0x1f,%eax
  801832:	29 d0                	sub    %edx,%eax
  801834:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801839:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80183c:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  80183f:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801842:	83 c3 01             	add    $0x1,%ebx
  801845:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801848:	75 d8                	jne    801822 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80184a:	8b 45 10             	mov    0x10(%ebp),%eax
  80184d:	eb 05                	jmp    801854 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80184f:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801854:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801857:	5b                   	pop    %ebx
  801858:	5e                   	pop    %esi
  801859:	5f                   	pop    %edi
  80185a:	5d                   	pop    %ebp
  80185b:	c3                   	ret    

0080185c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	56                   	push   %esi
  801860:	53                   	push   %ebx
  801861:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801864:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801867:	50                   	push   %eax
  801868:	e8 03 f5 ff ff       	call   800d70 <fd_alloc>
  80186d:	83 c4 10             	add    $0x10,%esp
  801870:	89 c2                	mov    %eax,%edx
  801872:	85 c0                	test   %eax,%eax
  801874:	0f 88 2c 01 00 00    	js     8019a6 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80187a:	83 ec 04             	sub    $0x4,%esp
  80187d:	68 07 04 00 00       	push   $0x407
  801882:	ff 75 f4             	pushl  -0xc(%ebp)
  801885:	6a 00                	push   $0x0
  801887:	e8 9f f3 ff ff       	call   800c2b <sys_page_alloc>
  80188c:	83 c4 10             	add    $0x10,%esp
  80188f:	89 c2                	mov    %eax,%edx
  801891:	85 c0                	test   %eax,%eax
  801893:	0f 88 0d 01 00 00    	js     8019a6 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801899:	83 ec 0c             	sub    $0xc,%esp
  80189c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80189f:	50                   	push   %eax
  8018a0:	e8 cb f4 ff ff       	call   800d70 <fd_alloc>
  8018a5:	89 c3                	mov    %eax,%ebx
  8018a7:	83 c4 10             	add    $0x10,%esp
  8018aa:	85 c0                	test   %eax,%eax
  8018ac:	0f 88 e2 00 00 00    	js     801994 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018b2:	83 ec 04             	sub    $0x4,%esp
  8018b5:	68 07 04 00 00       	push   $0x407
  8018ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8018bd:	6a 00                	push   $0x0
  8018bf:	e8 67 f3 ff ff       	call   800c2b <sys_page_alloc>
  8018c4:	89 c3                	mov    %eax,%ebx
  8018c6:	83 c4 10             	add    $0x10,%esp
  8018c9:	85 c0                	test   %eax,%eax
  8018cb:	0f 88 c3 00 00 00    	js     801994 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8018d1:	83 ec 0c             	sub    $0xc,%esp
  8018d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8018d7:	e8 7c f4 ff ff       	call   800d58 <fd2data>
  8018dc:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018de:	83 c4 0c             	add    $0xc,%esp
  8018e1:	68 07 04 00 00       	push   $0x407
  8018e6:	50                   	push   %eax
  8018e7:	6a 00                	push   $0x0
  8018e9:	e8 3d f3 ff ff       	call   800c2b <sys_page_alloc>
  8018ee:	89 c3                	mov    %eax,%ebx
  8018f0:	83 c4 10             	add    $0x10,%esp
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	0f 88 89 00 00 00    	js     801984 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018fb:	83 ec 0c             	sub    $0xc,%esp
  8018fe:	ff 75 f0             	pushl  -0x10(%ebp)
  801901:	e8 52 f4 ff ff       	call   800d58 <fd2data>
  801906:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80190d:	50                   	push   %eax
  80190e:	6a 00                	push   $0x0
  801910:	56                   	push   %esi
  801911:	6a 00                	push   $0x0
  801913:	e8 37 f3 ff ff       	call   800c4f <sys_page_map>
  801918:	89 c3                	mov    %eax,%ebx
  80191a:	83 c4 20             	add    $0x20,%esp
  80191d:	85 c0                	test   %eax,%eax
  80191f:	78 55                	js     801976 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801921:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80192a:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80192c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80192f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801936:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80193c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193f:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801941:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801944:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80194b:	83 ec 0c             	sub    $0xc,%esp
  80194e:	ff 75 f4             	pushl  -0xc(%ebp)
  801951:	e8 f2 f3 ff ff       	call   800d48 <fd2num>
  801956:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801959:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80195b:	83 c4 04             	add    $0x4,%esp
  80195e:	ff 75 f0             	pushl  -0x10(%ebp)
  801961:	e8 e2 f3 ff ff       	call   800d48 <fd2num>
  801966:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801969:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80196c:	83 c4 10             	add    $0x10,%esp
  80196f:	ba 00 00 00 00       	mov    $0x0,%edx
  801974:	eb 30                	jmp    8019a6 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801976:	83 ec 08             	sub    $0x8,%esp
  801979:	56                   	push   %esi
  80197a:	6a 00                	push   $0x0
  80197c:	e8 f4 f2 ff ff       	call   800c75 <sys_page_unmap>
  801981:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801984:	83 ec 08             	sub    $0x8,%esp
  801987:	ff 75 f0             	pushl  -0x10(%ebp)
  80198a:	6a 00                	push   $0x0
  80198c:	e8 e4 f2 ff ff       	call   800c75 <sys_page_unmap>
  801991:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801994:	83 ec 08             	sub    $0x8,%esp
  801997:	ff 75 f4             	pushl  -0xc(%ebp)
  80199a:	6a 00                	push   $0x0
  80199c:	e8 d4 f2 ff ff       	call   800c75 <sys_page_unmap>
  8019a1:	83 c4 10             	add    $0x10,%esp
  8019a4:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  8019a6:	89 d0                	mov    %edx,%eax
  8019a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ab:	5b                   	pop    %ebx
  8019ac:	5e                   	pop    %esi
  8019ad:	5d                   	pop    %ebp
  8019ae:	c3                   	ret    

008019af <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
  8019b2:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019b8:	50                   	push   %eax
  8019b9:	ff 75 08             	pushl  0x8(%ebp)
  8019bc:	e8 fe f3 ff ff       	call   800dbf <fd_lookup>
  8019c1:	83 c4 10             	add    $0x10,%esp
  8019c4:	85 c0                	test   %eax,%eax
  8019c6:	78 18                	js     8019e0 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8019c8:	83 ec 0c             	sub    $0xc,%esp
  8019cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ce:	e8 85 f3 ff ff       	call   800d58 <fd2data>
	return _pipeisclosed(fd, p);
  8019d3:	89 c2                	mov    %eax,%edx
  8019d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d8:	e8 21 fd ff ff       	call   8016fe <_pipeisclosed>
  8019dd:	83 c4 10             	add    $0x10,%esp
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8019e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ea:	5d                   	pop    %ebp
  8019eb:	c3                   	ret    

008019ec <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8019f2:	68 ce 23 80 00       	push   $0x8023ce
  8019f7:	ff 75 0c             	pushl  0xc(%ebp)
  8019fa:	e8 e3 ed ff ff       	call   8007e2 <strcpy>
	return 0;
}
  8019ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	57                   	push   %edi
  801a0a:	56                   	push   %esi
  801a0b:	53                   	push   %ebx
  801a0c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801a12:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801a17:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801a1d:	eb 2d                	jmp    801a4c <devcons_write+0x46>
		m = n - tot;
  801a1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801a22:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801a24:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801a27:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801a2c:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801a2f:	83 ec 04             	sub    $0x4,%esp
  801a32:	53                   	push   %ebx
  801a33:	03 45 0c             	add    0xc(%ebp),%eax
  801a36:	50                   	push   %eax
  801a37:	57                   	push   %edi
  801a38:	e8 38 ef ff ff       	call   800975 <memmove>
		sys_cputs(buf, m);
  801a3d:	83 c4 08             	add    $0x8,%esp
  801a40:	53                   	push   %ebx
  801a41:	57                   	push   %edi
  801a42:	e8 2d f1 ff ff       	call   800b74 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801a47:	01 de                	add    %ebx,%esi
  801a49:	83 c4 10             	add    $0x10,%esp
  801a4c:	89 f0                	mov    %esi,%eax
  801a4e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a51:	72 cc                	jb     801a1f <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801a53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a56:	5b                   	pop    %ebx
  801a57:	5e                   	pop    %esi
  801a58:	5f                   	pop    %edi
  801a59:	5d                   	pop    %ebp
  801a5a:	c3                   	ret    

00801a5b <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	83 ec 08             	sub    $0x8,%esp
  801a61:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801a66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a6a:	74 2a                	je     801a96 <devcons_read+0x3b>
  801a6c:	eb 05                	jmp    801a73 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801a6e:	e8 91 f1 ff ff       	call   800c04 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801a73:	e8 22 f1 ff ff       	call   800b9a <sys_cgetc>
  801a78:	85 c0                	test   %eax,%eax
  801a7a:	74 f2                	je     801a6e <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801a7c:	85 c0                	test   %eax,%eax
  801a7e:	78 16                	js     801a96 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801a80:	83 f8 04             	cmp    $0x4,%eax
  801a83:	74 0c                	je     801a91 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801a85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a88:	88 02                	mov    %al,(%edx)
	return 1;
  801a8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a8f:	eb 05                	jmp    801a96 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801a91:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
  801a9b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801aa4:	6a 01                	push   $0x1
  801aa6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801aa9:	50                   	push   %eax
  801aaa:	e8 c5 f0 ff ff       	call   800b74 <sys_cputs>
}
  801aaf:	83 c4 10             	add    $0x10,%esp
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <getchar>:

int
getchar(void)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
  801ab7:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801aba:	6a 01                	push   $0x1
  801abc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801abf:	50                   	push   %eax
  801ac0:	6a 00                	push   $0x0
  801ac2:	e8 5d f5 ff ff       	call   801024 <read>
	if (r < 0)
  801ac7:	83 c4 10             	add    $0x10,%esp
  801aca:	85 c0                	test   %eax,%eax
  801acc:	78 0f                	js     801add <getchar+0x29>
		return r;
	if (r < 1)
  801ace:	85 c0                	test   %eax,%eax
  801ad0:	7e 06                	jle    801ad8 <getchar+0x24>
		return -E_EOF;
	return c;
  801ad2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801ad6:	eb 05                	jmp    801add <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801ad8:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ae5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae8:	50                   	push   %eax
  801ae9:	ff 75 08             	pushl  0x8(%ebp)
  801aec:	e8 ce f2 ff ff       	call   800dbf <fd_lookup>
  801af1:	83 c4 10             	add    $0x10,%esp
  801af4:	85 c0                	test   %eax,%eax
  801af6:	78 11                	js     801b09 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afb:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b01:	39 10                	cmp    %edx,(%eax)
  801b03:	0f 94 c0             	sete   %al
  801b06:	0f b6 c0             	movzbl %al,%eax
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <opencons>:

int
opencons(void)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801b11:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b14:	50                   	push   %eax
  801b15:	e8 56 f2 ff ff       	call   800d70 <fd_alloc>
  801b1a:	83 c4 10             	add    $0x10,%esp
		return r;
  801b1d:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801b1f:	85 c0                	test   %eax,%eax
  801b21:	78 3e                	js     801b61 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801b23:	83 ec 04             	sub    $0x4,%esp
  801b26:	68 07 04 00 00       	push   $0x407
  801b2b:	ff 75 f4             	pushl  -0xc(%ebp)
  801b2e:	6a 00                	push   $0x0
  801b30:	e8 f6 f0 ff ff       	call   800c2b <sys_page_alloc>
  801b35:	83 c4 10             	add    $0x10,%esp
		return r;
  801b38:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801b3a:	85 c0                	test   %eax,%eax
  801b3c:	78 23                	js     801b61 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801b3e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b47:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801b53:	83 ec 0c             	sub    $0xc,%esp
  801b56:	50                   	push   %eax
  801b57:	e8 ec f1 ff ff       	call   800d48 <fd2num>
  801b5c:	89 c2                	mov    %eax,%edx
  801b5e:	83 c4 10             	add    $0x10,%esp
}
  801b61:	89 d0                	mov    %edx,%eax
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	56                   	push   %esi
  801b69:	53                   	push   %ebx
  801b6a:	8b 75 08             	mov    0x8(%ebp),%esi
  801b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b70:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801b73:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801b75:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801b7a:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801b7d:	83 ec 0c             	sub    $0xc,%esp
  801b80:	50                   	push   %eax
  801b81:	e8 a0 f1 ff ff       	call   800d26 <sys_ipc_recv>
	if (from_env_store)
  801b86:	83 c4 10             	add    $0x10,%esp
  801b89:	85 f6                	test   %esi,%esi
  801b8b:	74 0b                	je     801b98 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801b8d:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801b93:	8b 52 74             	mov    0x74(%edx),%edx
  801b96:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801b98:	85 db                	test   %ebx,%ebx
  801b9a:	74 0b                	je     801ba7 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  801b9c:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801ba2:	8b 52 78             	mov    0x78(%edx),%edx
  801ba5:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  801ba7:	85 c0                	test   %eax,%eax
  801ba9:	79 16                	jns    801bc1 <ipc_recv+0x5c>
		if (from_env_store)
  801bab:	85 f6                	test   %esi,%esi
  801bad:	74 06                	je     801bb5 <ipc_recv+0x50>
			*from_env_store = 0;
  801baf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  801bb5:	85 db                	test   %ebx,%ebx
  801bb7:	74 10                	je     801bc9 <ipc_recv+0x64>
			*perm_store = 0;
  801bb9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801bbf:	eb 08                	jmp    801bc9 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  801bc1:	a1 20 60 80 00       	mov    0x806020,%eax
  801bc6:	8b 40 70             	mov    0x70(%eax),%eax
}
  801bc9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bcc:	5b                   	pop    %ebx
  801bcd:	5e                   	pop    %esi
  801bce:	5d                   	pop    %ebp
  801bcf:	c3                   	ret    

00801bd0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	57                   	push   %edi
  801bd4:	56                   	push   %esi
  801bd5:	53                   	push   %ebx
  801bd6:	83 ec 0c             	sub    $0xc,%esp
  801bd9:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bdc:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bdf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  801be2:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  801be4:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801be9:	0f 44 d8             	cmove  %eax,%ebx
  801bec:	eb 1c                	jmp    801c0a <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  801bee:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801bf1:	74 12                	je     801c05 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801bf3:	50                   	push   %eax
  801bf4:	68 da 23 80 00       	push   $0x8023da
  801bf9:	6a 42                	push   $0x42
  801bfb:	68 f0 23 80 00       	push   $0x8023f0
  801c00:	e8 92 e5 ff ff       	call   800197 <_panic>
		sys_yield();
  801c05:	e8 fa ef ff ff       	call   800c04 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801c0a:	ff 75 14             	pushl  0x14(%ebp)
  801c0d:	53                   	push   %ebx
  801c0e:	56                   	push   %esi
  801c0f:	57                   	push   %edi
  801c10:	e8 ec f0 ff ff       	call   800d01 <sys_ipc_try_send>
  801c15:	83 c4 10             	add    $0x10,%esp
  801c18:	85 c0                	test   %eax,%eax
  801c1a:	75 d2                	jne    801bee <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801c1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c1f:	5b                   	pop    %ebx
  801c20:	5e                   	pop    %esi
  801c21:	5f                   	pop    %edi
  801c22:	5d                   	pop    %ebp
  801c23:	c3                   	ret    

00801c24 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
  801c27:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c2a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c2f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c32:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801c38:	8b 52 50             	mov    0x50(%edx),%edx
  801c3b:	39 ca                	cmp    %ecx,%edx
  801c3d:	75 0d                	jne    801c4c <ipc_find_env+0x28>
			return envs[i].env_id;
  801c3f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c42:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c47:	8b 40 48             	mov    0x48(%eax),%eax
  801c4a:	eb 0f                	jmp    801c5b <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801c4c:	83 c0 01             	add    $0x1,%eax
  801c4f:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c54:	75 d9                	jne    801c2f <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801c56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c5b:	5d                   	pop    %ebp
  801c5c:	c3                   	ret    

00801c5d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c63:	89 d0                	mov    %edx,%eax
  801c65:	c1 e8 16             	shr    $0x16,%eax
  801c68:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801c6f:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c74:	f6 c1 01             	test   $0x1,%cl
  801c77:	74 1d                	je     801c96 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801c79:	c1 ea 0c             	shr    $0xc,%edx
  801c7c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801c83:	f6 c2 01             	test   $0x1,%dl
  801c86:	74 0e                	je     801c96 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c88:	c1 ea 0c             	shr    $0xc,%edx
  801c8b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801c92:	ef 
  801c93:	0f b7 c0             	movzwl %ax,%eax
}
  801c96:	5d                   	pop    %ebp
  801c97:	c3                   	ret    
  801c98:	66 90                	xchg   %ax,%ax
  801c9a:	66 90                	xchg   %ax,%ax
  801c9c:	66 90                	xchg   %ax,%ax
  801c9e:	66 90                	xchg   %ax,%ax

00801ca0 <__udivdi3>:
  801ca0:	55                   	push   %ebp
  801ca1:	57                   	push   %edi
  801ca2:	56                   	push   %esi
  801ca3:	53                   	push   %ebx
  801ca4:	83 ec 1c             	sub    $0x1c,%esp
  801ca7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801cab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801caf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801cb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cb7:	85 f6                	test   %esi,%esi
  801cb9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cbd:	89 ca                	mov    %ecx,%edx
  801cbf:	89 f8                	mov    %edi,%eax
  801cc1:	75 3d                	jne    801d00 <__udivdi3+0x60>
  801cc3:	39 cf                	cmp    %ecx,%edi
  801cc5:	0f 87 c5 00 00 00    	ja     801d90 <__udivdi3+0xf0>
  801ccb:	85 ff                	test   %edi,%edi
  801ccd:	89 fd                	mov    %edi,%ebp
  801ccf:	75 0b                	jne    801cdc <__udivdi3+0x3c>
  801cd1:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd6:	31 d2                	xor    %edx,%edx
  801cd8:	f7 f7                	div    %edi
  801cda:	89 c5                	mov    %eax,%ebp
  801cdc:	89 c8                	mov    %ecx,%eax
  801cde:	31 d2                	xor    %edx,%edx
  801ce0:	f7 f5                	div    %ebp
  801ce2:	89 c1                	mov    %eax,%ecx
  801ce4:	89 d8                	mov    %ebx,%eax
  801ce6:	89 cf                	mov    %ecx,%edi
  801ce8:	f7 f5                	div    %ebp
  801cea:	89 c3                	mov    %eax,%ebx
  801cec:	89 d8                	mov    %ebx,%eax
  801cee:	89 fa                	mov    %edi,%edx
  801cf0:	83 c4 1c             	add    $0x1c,%esp
  801cf3:	5b                   	pop    %ebx
  801cf4:	5e                   	pop    %esi
  801cf5:	5f                   	pop    %edi
  801cf6:	5d                   	pop    %ebp
  801cf7:	c3                   	ret    
  801cf8:	90                   	nop
  801cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d00:	39 ce                	cmp    %ecx,%esi
  801d02:	77 74                	ja     801d78 <__udivdi3+0xd8>
  801d04:	0f bd fe             	bsr    %esi,%edi
  801d07:	83 f7 1f             	xor    $0x1f,%edi
  801d0a:	0f 84 98 00 00 00    	je     801da8 <__udivdi3+0x108>
  801d10:	bb 20 00 00 00       	mov    $0x20,%ebx
  801d15:	89 f9                	mov    %edi,%ecx
  801d17:	89 c5                	mov    %eax,%ebp
  801d19:	29 fb                	sub    %edi,%ebx
  801d1b:	d3 e6                	shl    %cl,%esi
  801d1d:	89 d9                	mov    %ebx,%ecx
  801d1f:	d3 ed                	shr    %cl,%ebp
  801d21:	89 f9                	mov    %edi,%ecx
  801d23:	d3 e0                	shl    %cl,%eax
  801d25:	09 ee                	or     %ebp,%esi
  801d27:	89 d9                	mov    %ebx,%ecx
  801d29:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d2d:	89 d5                	mov    %edx,%ebp
  801d2f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d33:	d3 ed                	shr    %cl,%ebp
  801d35:	89 f9                	mov    %edi,%ecx
  801d37:	d3 e2                	shl    %cl,%edx
  801d39:	89 d9                	mov    %ebx,%ecx
  801d3b:	d3 e8                	shr    %cl,%eax
  801d3d:	09 c2                	or     %eax,%edx
  801d3f:	89 d0                	mov    %edx,%eax
  801d41:	89 ea                	mov    %ebp,%edx
  801d43:	f7 f6                	div    %esi
  801d45:	89 d5                	mov    %edx,%ebp
  801d47:	89 c3                	mov    %eax,%ebx
  801d49:	f7 64 24 0c          	mull   0xc(%esp)
  801d4d:	39 d5                	cmp    %edx,%ebp
  801d4f:	72 10                	jb     801d61 <__udivdi3+0xc1>
  801d51:	8b 74 24 08          	mov    0x8(%esp),%esi
  801d55:	89 f9                	mov    %edi,%ecx
  801d57:	d3 e6                	shl    %cl,%esi
  801d59:	39 c6                	cmp    %eax,%esi
  801d5b:	73 07                	jae    801d64 <__udivdi3+0xc4>
  801d5d:	39 d5                	cmp    %edx,%ebp
  801d5f:	75 03                	jne    801d64 <__udivdi3+0xc4>
  801d61:	83 eb 01             	sub    $0x1,%ebx
  801d64:	31 ff                	xor    %edi,%edi
  801d66:	89 d8                	mov    %ebx,%eax
  801d68:	89 fa                	mov    %edi,%edx
  801d6a:	83 c4 1c             	add    $0x1c,%esp
  801d6d:	5b                   	pop    %ebx
  801d6e:	5e                   	pop    %esi
  801d6f:	5f                   	pop    %edi
  801d70:	5d                   	pop    %ebp
  801d71:	c3                   	ret    
  801d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d78:	31 ff                	xor    %edi,%edi
  801d7a:	31 db                	xor    %ebx,%ebx
  801d7c:	89 d8                	mov    %ebx,%eax
  801d7e:	89 fa                	mov    %edi,%edx
  801d80:	83 c4 1c             	add    $0x1c,%esp
  801d83:	5b                   	pop    %ebx
  801d84:	5e                   	pop    %esi
  801d85:	5f                   	pop    %edi
  801d86:	5d                   	pop    %ebp
  801d87:	c3                   	ret    
  801d88:	90                   	nop
  801d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d90:	89 d8                	mov    %ebx,%eax
  801d92:	f7 f7                	div    %edi
  801d94:	31 ff                	xor    %edi,%edi
  801d96:	89 c3                	mov    %eax,%ebx
  801d98:	89 d8                	mov    %ebx,%eax
  801d9a:	89 fa                	mov    %edi,%edx
  801d9c:	83 c4 1c             	add    $0x1c,%esp
  801d9f:	5b                   	pop    %ebx
  801da0:	5e                   	pop    %esi
  801da1:	5f                   	pop    %edi
  801da2:	5d                   	pop    %ebp
  801da3:	c3                   	ret    
  801da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801da8:	39 ce                	cmp    %ecx,%esi
  801daa:	72 0c                	jb     801db8 <__udivdi3+0x118>
  801dac:	31 db                	xor    %ebx,%ebx
  801dae:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801db2:	0f 87 34 ff ff ff    	ja     801cec <__udivdi3+0x4c>
  801db8:	bb 01 00 00 00       	mov    $0x1,%ebx
  801dbd:	e9 2a ff ff ff       	jmp    801cec <__udivdi3+0x4c>
  801dc2:	66 90                	xchg   %ax,%ax
  801dc4:	66 90                	xchg   %ax,%ax
  801dc6:	66 90                	xchg   %ax,%ax
  801dc8:	66 90                	xchg   %ax,%ax
  801dca:	66 90                	xchg   %ax,%ax
  801dcc:	66 90                	xchg   %ax,%ax
  801dce:	66 90                	xchg   %ax,%ax

00801dd0 <__umoddi3>:
  801dd0:	55                   	push   %ebp
  801dd1:	57                   	push   %edi
  801dd2:	56                   	push   %esi
  801dd3:	53                   	push   %ebx
  801dd4:	83 ec 1c             	sub    $0x1c,%esp
  801dd7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801ddb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ddf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801de3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801de7:	85 d2                	test   %edx,%edx
  801de9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ded:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801df1:	89 f3                	mov    %esi,%ebx
  801df3:	89 3c 24             	mov    %edi,(%esp)
  801df6:	89 74 24 04          	mov    %esi,0x4(%esp)
  801dfa:	75 1c                	jne    801e18 <__umoddi3+0x48>
  801dfc:	39 f7                	cmp    %esi,%edi
  801dfe:	76 50                	jbe    801e50 <__umoddi3+0x80>
  801e00:	89 c8                	mov    %ecx,%eax
  801e02:	89 f2                	mov    %esi,%edx
  801e04:	f7 f7                	div    %edi
  801e06:	89 d0                	mov    %edx,%eax
  801e08:	31 d2                	xor    %edx,%edx
  801e0a:	83 c4 1c             	add    $0x1c,%esp
  801e0d:	5b                   	pop    %ebx
  801e0e:	5e                   	pop    %esi
  801e0f:	5f                   	pop    %edi
  801e10:	5d                   	pop    %ebp
  801e11:	c3                   	ret    
  801e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e18:	39 f2                	cmp    %esi,%edx
  801e1a:	89 d0                	mov    %edx,%eax
  801e1c:	77 52                	ja     801e70 <__umoddi3+0xa0>
  801e1e:	0f bd ea             	bsr    %edx,%ebp
  801e21:	83 f5 1f             	xor    $0x1f,%ebp
  801e24:	75 5a                	jne    801e80 <__umoddi3+0xb0>
  801e26:	3b 54 24 04          	cmp    0x4(%esp),%edx
  801e2a:	0f 82 e0 00 00 00    	jb     801f10 <__umoddi3+0x140>
  801e30:	39 0c 24             	cmp    %ecx,(%esp)
  801e33:	0f 86 d7 00 00 00    	jbe    801f10 <__umoddi3+0x140>
  801e39:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e3d:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e41:	83 c4 1c             	add    $0x1c,%esp
  801e44:	5b                   	pop    %ebx
  801e45:	5e                   	pop    %esi
  801e46:	5f                   	pop    %edi
  801e47:	5d                   	pop    %ebp
  801e48:	c3                   	ret    
  801e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e50:	85 ff                	test   %edi,%edi
  801e52:	89 fd                	mov    %edi,%ebp
  801e54:	75 0b                	jne    801e61 <__umoddi3+0x91>
  801e56:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5b:	31 d2                	xor    %edx,%edx
  801e5d:	f7 f7                	div    %edi
  801e5f:	89 c5                	mov    %eax,%ebp
  801e61:	89 f0                	mov    %esi,%eax
  801e63:	31 d2                	xor    %edx,%edx
  801e65:	f7 f5                	div    %ebp
  801e67:	89 c8                	mov    %ecx,%eax
  801e69:	f7 f5                	div    %ebp
  801e6b:	89 d0                	mov    %edx,%eax
  801e6d:	eb 99                	jmp    801e08 <__umoddi3+0x38>
  801e6f:	90                   	nop
  801e70:	89 c8                	mov    %ecx,%eax
  801e72:	89 f2                	mov    %esi,%edx
  801e74:	83 c4 1c             	add    $0x1c,%esp
  801e77:	5b                   	pop    %ebx
  801e78:	5e                   	pop    %esi
  801e79:	5f                   	pop    %edi
  801e7a:	5d                   	pop    %ebp
  801e7b:	c3                   	ret    
  801e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801e80:	8b 34 24             	mov    (%esp),%esi
  801e83:	bf 20 00 00 00       	mov    $0x20,%edi
  801e88:	89 e9                	mov    %ebp,%ecx
  801e8a:	29 ef                	sub    %ebp,%edi
  801e8c:	d3 e0                	shl    %cl,%eax
  801e8e:	89 f9                	mov    %edi,%ecx
  801e90:	89 f2                	mov    %esi,%edx
  801e92:	d3 ea                	shr    %cl,%edx
  801e94:	89 e9                	mov    %ebp,%ecx
  801e96:	09 c2                	or     %eax,%edx
  801e98:	89 d8                	mov    %ebx,%eax
  801e9a:	89 14 24             	mov    %edx,(%esp)
  801e9d:	89 f2                	mov    %esi,%edx
  801e9f:	d3 e2                	shl    %cl,%edx
  801ea1:	89 f9                	mov    %edi,%ecx
  801ea3:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ea7:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801eab:	d3 e8                	shr    %cl,%eax
  801ead:	89 e9                	mov    %ebp,%ecx
  801eaf:	89 c6                	mov    %eax,%esi
  801eb1:	d3 e3                	shl    %cl,%ebx
  801eb3:	89 f9                	mov    %edi,%ecx
  801eb5:	89 d0                	mov    %edx,%eax
  801eb7:	d3 e8                	shr    %cl,%eax
  801eb9:	89 e9                	mov    %ebp,%ecx
  801ebb:	09 d8                	or     %ebx,%eax
  801ebd:	89 d3                	mov    %edx,%ebx
  801ebf:	89 f2                	mov    %esi,%edx
  801ec1:	f7 34 24             	divl   (%esp)
  801ec4:	89 d6                	mov    %edx,%esi
  801ec6:	d3 e3                	shl    %cl,%ebx
  801ec8:	f7 64 24 04          	mull   0x4(%esp)
  801ecc:	39 d6                	cmp    %edx,%esi
  801ece:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ed2:	89 d1                	mov    %edx,%ecx
  801ed4:	89 c3                	mov    %eax,%ebx
  801ed6:	72 08                	jb     801ee0 <__umoddi3+0x110>
  801ed8:	75 11                	jne    801eeb <__umoddi3+0x11b>
  801eda:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801ede:	73 0b                	jae    801eeb <__umoddi3+0x11b>
  801ee0:	2b 44 24 04          	sub    0x4(%esp),%eax
  801ee4:	1b 14 24             	sbb    (%esp),%edx
  801ee7:	89 d1                	mov    %edx,%ecx
  801ee9:	89 c3                	mov    %eax,%ebx
  801eeb:	8b 54 24 08          	mov    0x8(%esp),%edx
  801eef:	29 da                	sub    %ebx,%edx
  801ef1:	19 ce                	sbb    %ecx,%esi
  801ef3:	89 f9                	mov    %edi,%ecx
  801ef5:	89 f0                	mov    %esi,%eax
  801ef7:	d3 e0                	shl    %cl,%eax
  801ef9:	89 e9                	mov    %ebp,%ecx
  801efb:	d3 ea                	shr    %cl,%edx
  801efd:	89 e9                	mov    %ebp,%ecx
  801eff:	d3 ee                	shr    %cl,%esi
  801f01:	09 d0                	or     %edx,%eax
  801f03:	89 f2                	mov    %esi,%edx
  801f05:	83 c4 1c             	add    $0x1c,%esp
  801f08:	5b                   	pop    %ebx
  801f09:	5e                   	pop    %esi
  801f0a:	5f                   	pop    %edi
  801f0b:	5d                   	pop    %ebp
  801f0c:	c3                   	ret    
  801f0d:	8d 76 00             	lea    0x0(%esi),%esi
  801f10:	29 f9                	sub    %edi,%ecx
  801f12:	19 d6                	sbb    %edx,%esi
  801f14:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f18:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f1c:	e9 18 ff ff ff       	jmp    801e39 <__umoddi3+0x69>
