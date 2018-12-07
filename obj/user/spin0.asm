
obj/user/spin0.debug:     formato del fichero elf32-i386


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
  80002c:	e8 74 00 00 00       	call   8000a5 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>
#define TICK (1U << 15)

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 0c             	sub    $0xc,%esp
	envid_t me = sys_getenvid();
  80003c:	e8 cb 0a 00 00       	call   800b0c <sys_getenvid>
  800041:	89 c7                	mov    %eax,%edi
	unsigned n = 0;
	bool yield = me & 1;
  800043:	89 c6                	mov    %eax,%esi
  800045:	83 e6 01             	and    $0x1,%esi
  800048:	bb 01 00 00 00       	mov    $0x1,%ebx
  80004d:	b8 01 80 00 00       	mov    $0x8001,%eax

	while (n++ < 5 || !yield) {
		unsigned i = TICK;
		while (i--)
  800052:	83 e8 01             	sub    $0x1,%eax
  800055:	75 fb                	jne    800052 <umain+0x1f>
			;
		if (yield) {
  800057:	85 f6                	test   %esi,%esi
  800059:	74 2b                	je     800086 <umain+0x53>
			cprintf("I am %08x and I like my interrupt #%u\n", me, n);
  80005b:	83 ec 04             	sub    $0x4,%esp
  80005e:	53                   	push   %ebx
  80005f:	57                   	push   %edi
  800060:	68 a0 1d 80 00       	push   $0x801da0
  800065:	e8 32 01 00 00       	call   80019c <cprintf>
			sys_yield();
  80006a:	e8 c1 0a 00 00       	call   800b30 <sys_yield>
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	83 fb 04             	cmp    $0x4,%ebx
  800075:	0f 96 c2             	setbe  %dl
  800078:	85 f6                	test   %esi,%esi
  80007a:	0f 94 c0             	sete   %al
  80007d:	83 c3 01             	add    $0x1,%ebx
{
	envid_t me = sys_getenvid();
	unsigned n = 0;
	bool yield = me & 1;

	while (n++ < 5 || !yield) {
  800080:	08 c2                	or     %al,%dl
  800082:	75 c9                	jne    80004d <umain+0x1a>
  800084:	eb 17                	jmp    80009d <umain+0x6a>
		if (yield) {
			cprintf("I am %08x and I like my interrupt #%u\n", me, n);
			sys_yield();
		}
		else {
			cprintf("I am %08x and my spin will go on #%u\n", me, n);
  800086:	83 ec 04             	sub    $0x4,%esp
  800089:	53                   	push   %ebx
  80008a:	57                   	push   %edi
  80008b:	68 c8 1d 80 00       	push   $0x801dc8
  800090:	e8 07 01 00 00       	call   80019c <cprintf>
  800095:	83 c3 01             	add    $0x1,%ebx
  800098:	83 c4 10             	add    $0x10,%esp
  80009b:	eb b0                	jmp    80004d <umain+0x1a>
		}
	}
}
  80009d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000a0:	5b                   	pop    %ebx
  8000a1:	5e                   	pop    %esi
  8000a2:	5f                   	pop    %edi
  8000a3:	5d                   	pop    %ebp
  8000a4:	c3                   	ret    

008000a5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000a5:	55                   	push   %ebp
  8000a6:	89 e5                	mov    %esp,%ebp
  8000a8:	56                   	push   %esi
  8000a9:	53                   	push   %ebx
  8000aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ad:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8000b0:	e8 57 0a 00 00       	call   800b0c <sys_getenvid>
	if (id >= 0)
  8000b5:	85 c0                	test   %eax,%eax
  8000b7:	78 12                	js     8000cb <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  8000b9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000be:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000c1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000c6:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000cb:	85 db                	test   %ebx,%ebx
  8000cd:	7e 07                	jle    8000d6 <libmain+0x31>
		binaryname = argv[0];
  8000cf:	8b 06                	mov    (%esi),%eax
  8000d1:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000d6:	83 ec 08             	sub    $0x8,%esp
  8000d9:	56                   	push   %esi
  8000da:	53                   	push   %ebx
  8000db:	e8 53 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000e0:	e8 0a 00 00 00       	call   8000ef <exit>
}
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000eb:	5b                   	pop    %ebx
  8000ec:	5e                   	pop    %esi
  8000ed:	5d                   	pop    %ebp
  8000ee:	c3                   	ret    

008000ef <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ef:	55                   	push   %ebp
  8000f0:	89 e5                	mov    %esp,%ebp
  8000f2:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000f5:	e8 45 0d 00 00       	call   800e3f <close_all>
	sys_env_destroy(0);
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	6a 00                	push   $0x0
  8000ff:	e8 e6 09 00 00       	call   800aea <sys_env_destroy>
}
  800104:	83 c4 10             	add    $0x10,%esp
  800107:	c9                   	leave  
  800108:	c3                   	ret    

00800109 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800109:	55                   	push   %ebp
  80010a:	89 e5                	mov    %esp,%ebp
  80010c:	53                   	push   %ebx
  80010d:	83 ec 04             	sub    $0x4,%esp
  800110:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800113:	8b 13                	mov    (%ebx),%edx
  800115:	8d 42 01             	lea    0x1(%edx),%eax
  800118:	89 03                	mov    %eax,(%ebx)
  80011a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80011d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800121:	3d ff 00 00 00       	cmp    $0xff,%eax
  800126:	75 1a                	jne    800142 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  800128:	83 ec 08             	sub    $0x8,%esp
  80012b:	68 ff 00 00 00       	push   $0xff
  800130:	8d 43 08             	lea    0x8(%ebx),%eax
  800133:	50                   	push   %eax
  800134:	e8 67 09 00 00       	call   800aa0 <sys_cputs>
		b->idx = 0;
  800139:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80013f:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  800142:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800146:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800149:	c9                   	leave  
  80014a:	c3                   	ret    

0080014b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80014b:	55                   	push   %ebp
  80014c:	89 e5                	mov    %esp,%ebp
  80014e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800154:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80015b:	00 00 00 
	b.cnt = 0;
  80015e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800165:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800168:	ff 75 0c             	pushl  0xc(%ebp)
  80016b:	ff 75 08             	pushl  0x8(%ebp)
  80016e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800174:	50                   	push   %eax
  800175:	68 09 01 80 00       	push   $0x800109
  80017a:	e8 86 01 00 00       	call   800305 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80017f:	83 c4 08             	add    $0x8,%esp
  800182:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800188:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80018e:	50                   	push   %eax
  80018f:	e8 0c 09 00 00       	call   800aa0 <sys_cputs>

	return b.cnt;
}
  800194:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80019a:	c9                   	leave  
  80019b:	c3                   	ret    

0080019c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80019c:	55                   	push   %ebp
  80019d:	89 e5                	mov    %esp,%ebp
  80019f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001a2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001a5:	50                   	push   %eax
  8001a6:	ff 75 08             	pushl  0x8(%ebp)
  8001a9:	e8 9d ff ff ff       	call   80014b <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ae:	c9                   	leave  
  8001af:	c3                   	ret    

008001b0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001b0:	55                   	push   %ebp
  8001b1:	89 e5                	mov    %esp,%ebp
  8001b3:	57                   	push   %edi
  8001b4:	56                   	push   %esi
  8001b5:	53                   	push   %ebx
  8001b6:	83 ec 1c             	sub    $0x1c,%esp
  8001b9:	89 c7                	mov    %eax,%edi
  8001bb:	89 d6                	mov    %edx,%esi
  8001bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001c6:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001d1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001d4:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001d7:	39 d3                	cmp    %edx,%ebx
  8001d9:	72 05                	jb     8001e0 <printnum+0x30>
  8001db:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001de:	77 45                	ja     800225 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001e0:	83 ec 0c             	sub    $0xc,%esp
  8001e3:	ff 75 18             	pushl  0x18(%ebp)
  8001e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8001e9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001ec:	53                   	push   %ebx
  8001ed:	ff 75 10             	pushl  0x10(%ebp)
  8001f0:	83 ec 08             	sub    $0x8,%esp
  8001f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f6:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f9:	ff 75 dc             	pushl  -0x24(%ebp)
  8001fc:	ff 75 d8             	pushl  -0x28(%ebp)
  8001ff:	e8 fc 18 00 00       	call   801b00 <__udivdi3>
  800204:	83 c4 18             	add    $0x18,%esp
  800207:	52                   	push   %edx
  800208:	50                   	push   %eax
  800209:	89 f2                	mov    %esi,%edx
  80020b:	89 f8                	mov    %edi,%eax
  80020d:	e8 9e ff ff ff       	call   8001b0 <printnum>
  800212:	83 c4 20             	add    $0x20,%esp
  800215:	eb 18                	jmp    80022f <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800217:	83 ec 08             	sub    $0x8,%esp
  80021a:	56                   	push   %esi
  80021b:	ff 75 18             	pushl  0x18(%ebp)
  80021e:	ff d7                	call   *%edi
  800220:	83 c4 10             	add    $0x10,%esp
  800223:	eb 03                	jmp    800228 <printnum+0x78>
  800225:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800228:	83 eb 01             	sub    $0x1,%ebx
  80022b:	85 db                	test   %ebx,%ebx
  80022d:	7f e8                	jg     800217 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80022f:	83 ec 08             	sub    $0x8,%esp
  800232:	56                   	push   %esi
  800233:	83 ec 04             	sub    $0x4,%esp
  800236:	ff 75 e4             	pushl  -0x1c(%ebp)
  800239:	ff 75 e0             	pushl  -0x20(%ebp)
  80023c:	ff 75 dc             	pushl  -0x24(%ebp)
  80023f:	ff 75 d8             	pushl  -0x28(%ebp)
  800242:	e8 e9 19 00 00       	call   801c30 <__umoddi3>
  800247:	83 c4 14             	add    $0x14,%esp
  80024a:	0f be 80 f8 1d 80 00 	movsbl 0x801df8(%eax),%eax
  800251:	50                   	push   %eax
  800252:	ff d7                	call   *%edi
}
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80025a:	5b                   	pop    %ebx
  80025b:	5e                   	pop    %esi
  80025c:	5f                   	pop    %edi
  80025d:	5d                   	pop    %ebp
  80025e:	c3                   	ret    

0080025f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80025f:	55                   	push   %ebp
  800260:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800262:	83 fa 01             	cmp    $0x1,%edx
  800265:	7e 0e                	jle    800275 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800267:	8b 10                	mov    (%eax),%edx
  800269:	8d 4a 08             	lea    0x8(%edx),%ecx
  80026c:	89 08                	mov    %ecx,(%eax)
  80026e:	8b 02                	mov    (%edx),%eax
  800270:	8b 52 04             	mov    0x4(%edx),%edx
  800273:	eb 22                	jmp    800297 <getuint+0x38>
	else if (lflag)
  800275:	85 d2                	test   %edx,%edx
  800277:	74 10                	je     800289 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800279:	8b 10                	mov    (%eax),%edx
  80027b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80027e:	89 08                	mov    %ecx,(%eax)
  800280:	8b 02                	mov    (%edx),%eax
  800282:	ba 00 00 00 00       	mov    $0x0,%edx
  800287:	eb 0e                	jmp    800297 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800289:	8b 10                	mov    (%eax),%edx
  80028b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80028e:	89 08                	mov    %ecx,(%eax)
  800290:	8b 02                	mov    (%edx),%eax
  800292:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800297:	5d                   	pop    %ebp
  800298:	c3                   	ret    

00800299 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80029c:	83 fa 01             	cmp    $0x1,%edx
  80029f:	7e 0e                	jle    8002af <getint+0x16>
		return va_arg(*ap, long long);
  8002a1:	8b 10                	mov    (%eax),%edx
  8002a3:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002a6:	89 08                	mov    %ecx,(%eax)
  8002a8:	8b 02                	mov    (%edx),%eax
  8002aa:	8b 52 04             	mov    0x4(%edx),%edx
  8002ad:	eb 1a                	jmp    8002c9 <getint+0x30>
	else if (lflag)
  8002af:	85 d2                	test   %edx,%edx
  8002b1:	74 0c                	je     8002bf <getint+0x26>
		return va_arg(*ap, long);
  8002b3:	8b 10                	mov    (%eax),%edx
  8002b5:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002b8:	89 08                	mov    %ecx,(%eax)
  8002ba:	8b 02                	mov    (%edx),%eax
  8002bc:	99                   	cltd   
  8002bd:	eb 0a                	jmp    8002c9 <getint+0x30>
	else
		return va_arg(*ap, int);
  8002bf:	8b 10                	mov    (%eax),%edx
  8002c1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002c4:	89 08                	mov    %ecx,(%eax)
  8002c6:	8b 02                	mov    (%edx),%eax
  8002c8:	99                   	cltd   
}
  8002c9:	5d                   	pop    %ebp
  8002ca:	c3                   	ret    

008002cb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002cb:	55                   	push   %ebp
  8002cc:	89 e5                	mov    %esp,%ebp
  8002ce:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002d1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d5:	8b 10                	mov    (%eax),%edx
  8002d7:	3b 50 04             	cmp    0x4(%eax),%edx
  8002da:	73 0a                	jae    8002e6 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002dc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002df:	89 08                	mov    %ecx,(%eax)
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	88 02                	mov    %al,(%edx)
}
  8002e6:	5d                   	pop    %ebp
  8002e7:	c3                   	ret    

008002e8 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8002e8:	55                   	push   %ebp
  8002e9:	89 e5                	mov    %esp,%ebp
  8002eb:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8002ee:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002f1:	50                   	push   %eax
  8002f2:	ff 75 10             	pushl  0x10(%ebp)
  8002f5:	ff 75 0c             	pushl  0xc(%ebp)
  8002f8:	ff 75 08             	pushl  0x8(%ebp)
  8002fb:	e8 05 00 00 00       	call   800305 <vprintfmt>
	va_end(ap);
}
  800300:	83 c4 10             	add    $0x10,%esp
  800303:	c9                   	leave  
  800304:	c3                   	ret    

00800305 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
  800308:	57                   	push   %edi
  800309:	56                   	push   %esi
  80030a:	53                   	push   %ebx
  80030b:	83 ec 2c             	sub    $0x2c,%esp
  80030e:	8b 75 08             	mov    0x8(%ebp),%esi
  800311:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800314:	8b 7d 10             	mov    0x10(%ebp),%edi
  800317:	eb 12                	jmp    80032b <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800319:	85 c0                	test   %eax,%eax
  80031b:	0f 84 44 03 00 00    	je     800665 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  800321:	83 ec 08             	sub    $0x8,%esp
  800324:	53                   	push   %ebx
  800325:	50                   	push   %eax
  800326:	ff d6                	call   *%esi
  800328:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80032b:	83 c7 01             	add    $0x1,%edi
  80032e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800332:	83 f8 25             	cmp    $0x25,%eax
  800335:	75 e2                	jne    800319 <vprintfmt+0x14>
  800337:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  80033b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800342:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800349:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800350:	ba 00 00 00 00       	mov    $0x0,%edx
  800355:	eb 07                	jmp    80035e <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800357:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  80035a:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80035e:	8d 47 01             	lea    0x1(%edi),%eax
  800361:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800364:	0f b6 07             	movzbl (%edi),%eax
  800367:	0f b6 c8             	movzbl %al,%ecx
  80036a:	83 e8 23             	sub    $0x23,%eax
  80036d:	3c 55                	cmp    $0x55,%al
  80036f:	0f 87 d5 02 00 00    	ja     80064a <vprintfmt+0x345>
  800375:	0f b6 c0             	movzbl %al,%eax
  800378:	ff 24 85 40 1f 80 00 	jmp    *0x801f40(,%eax,4)
  80037f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800382:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800386:	eb d6                	jmp    80035e <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80038b:	b8 00 00 00 00       	mov    $0x0,%eax
  800390:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800393:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800396:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  80039a:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  80039d:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8003a0:	83 fa 09             	cmp    $0x9,%edx
  8003a3:	77 39                	ja     8003de <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003a5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003a8:	eb e9                	jmp    800393 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ad:	8d 48 04             	lea    0x4(%eax),%ecx
  8003b0:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8003b3:	8b 00                	mov    (%eax),%eax
  8003b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003bb:	eb 27                	jmp    8003e4 <vprintfmt+0xdf>
  8003bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003c0:	85 c0                	test   %eax,%eax
  8003c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003c7:	0f 49 c8             	cmovns %eax,%ecx
  8003ca:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003d0:	eb 8c                	jmp    80035e <vprintfmt+0x59>
  8003d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8003d5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003dc:	eb 80                	jmp    80035e <vprintfmt+0x59>
  8003de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003e1:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  8003e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003e8:	0f 89 70 ff ff ff    	jns    80035e <vprintfmt+0x59>
				width = precision, precision = -1;
  8003ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f4:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003fb:	e9 5e ff ff ff       	jmp    80035e <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800400:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800403:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800406:	e9 53 ff ff ff       	jmp    80035e <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80040b:	8b 45 14             	mov    0x14(%ebp),%eax
  80040e:	8d 50 04             	lea    0x4(%eax),%edx
  800411:	89 55 14             	mov    %edx,0x14(%ebp)
  800414:	83 ec 08             	sub    $0x8,%esp
  800417:	53                   	push   %ebx
  800418:	ff 30                	pushl  (%eax)
  80041a:	ff d6                	call   *%esi
			break;
  80041c:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80041f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800422:	e9 04 ff ff ff       	jmp    80032b <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800427:	8b 45 14             	mov    0x14(%ebp),%eax
  80042a:	8d 50 04             	lea    0x4(%eax),%edx
  80042d:	89 55 14             	mov    %edx,0x14(%ebp)
  800430:	8b 00                	mov    (%eax),%eax
  800432:	99                   	cltd   
  800433:	31 d0                	xor    %edx,%eax
  800435:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800437:	83 f8 0f             	cmp    $0xf,%eax
  80043a:	7f 0b                	jg     800447 <vprintfmt+0x142>
  80043c:	8b 14 85 a0 20 80 00 	mov    0x8020a0(,%eax,4),%edx
  800443:	85 d2                	test   %edx,%edx
  800445:	75 18                	jne    80045f <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  800447:	50                   	push   %eax
  800448:	68 10 1e 80 00       	push   $0x801e10
  80044d:	53                   	push   %ebx
  80044e:	56                   	push   %esi
  80044f:	e8 94 fe ff ff       	call   8002e8 <printfmt>
  800454:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800457:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80045a:	e9 cc fe ff ff       	jmp    80032b <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  80045f:	52                   	push   %edx
  800460:	68 d1 21 80 00       	push   $0x8021d1
  800465:	53                   	push   %ebx
  800466:	56                   	push   %esi
  800467:	e8 7c fe ff ff       	call   8002e8 <printfmt>
  80046c:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800472:	e9 b4 fe ff ff       	jmp    80032b <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800477:	8b 45 14             	mov    0x14(%ebp),%eax
  80047a:	8d 50 04             	lea    0x4(%eax),%edx
  80047d:	89 55 14             	mov    %edx,0x14(%ebp)
  800480:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800482:	85 ff                	test   %edi,%edi
  800484:	b8 09 1e 80 00       	mov    $0x801e09,%eax
  800489:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80048c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800490:	0f 8e 94 00 00 00    	jle    80052a <vprintfmt+0x225>
  800496:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80049a:	0f 84 98 00 00 00    	je     800538 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	ff 75 d0             	pushl  -0x30(%ebp)
  8004a6:	57                   	push   %edi
  8004a7:	e8 41 02 00 00       	call   8006ed <strnlen>
  8004ac:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004af:	29 c1                	sub    %eax,%ecx
  8004b1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8004b4:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004b7:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004be:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004c1:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c3:	eb 0f                	jmp    8004d4 <vprintfmt+0x1cf>
					putch(padc, putdat);
  8004c5:	83 ec 08             	sub    $0x8,%esp
  8004c8:	53                   	push   %ebx
  8004c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8004cc:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ce:	83 ef 01             	sub    $0x1,%edi
  8004d1:	83 c4 10             	add    $0x10,%esp
  8004d4:	85 ff                	test   %edi,%edi
  8004d6:	7f ed                	jg     8004c5 <vprintfmt+0x1c0>
  8004d8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004db:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8004de:	85 c9                	test   %ecx,%ecx
  8004e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e5:	0f 49 c1             	cmovns %ecx,%eax
  8004e8:	29 c1                	sub    %eax,%ecx
  8004ea:	89 75 08             	mov    %esi,0x8(%ebp)
  8004ed:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004f0:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004f3:	89 cb                	mov    %ecx,%ebx
  8004f5:	eb 4d                	jmp    800544 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004f7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004fb:	74 1b                	je     800518 <vprintfmt+0x213>
  8004fd:	0f be c0             	movsbl %al,%eax
  800500:	83 e8 20             	sub    $0x20,%eax
  800503:	83 f8 5e             	cmp    $0x5e,%eax
  800506:	76 10                	jbe    800518 <vprintfmt+0x213>
					putch('?', putdat);
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	ff 75 0c             	pushl  0xc(%ebp)
  80050e:	6a 3f                	push   $0x3f
  800510:	ff 55 08             	call   *0x8(%ebp)
  800513:	83 c4 10             	add    $0x10,%esp
  800516:	eb 0d                	jmp    800525 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	ff 75 0c             	pushl  0xc(%ebp)
  80051e:	52                   	push   %edx
  80051f:	ff 55 08             	call   *0x8(%ebp)
  800522:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800525:	83 eb 01             	sub    $0x1,%ebx
  800528:	eb 1a                	jmp    800544 <vprintfmt+0x23f>
  80052a:	89 75 08             	mov    %esi,0x8(%ebp)
  80052d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800530:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800533:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800536:	eb 0c                	jmp    800544 <vprintfmt+0x23f>
  800538:	89 75 08             	mov    %esi,0x8(%ebp)
  80053b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80053e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800541:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800544:	83 c7 01             	add    $0x1,%edi
  800547:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80054b:	0f be d0             	movsbl %al,%edx
  80054e:	85 d2                	test   %edx,%edx
  800550:	74 23                	je     800575 <vprintfmt+0x270>
  800552:	85 f6                	test   %esi,%esi
  800554:	78 a1                	js     8004f7 <vprintfmt+0x1f2>
  800556:	83 ee 01             	sub    $0x1,%esi
  800559:	79 9c                	jns    8004f7 <vprintfmt+0x1f2>
  80055b:	89 df                	mov    %ebx,%edi
  80055d:	8b 75 08             	mov    0x8(%ebp),%esi
  800560:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800563:	eb 18                	jmp    80057d <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800565:	83 ec 08             	sub    $0x8,%esp
  800568:	53                   	push   %ebx
  800569:	6a 20                	push   $0x20
  80056b:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80056d:	83 ef 01             	sub    $0x1,%edi
  800570:	83 c4 10             	add    $0x10,%esp
  800573:	eb 08                	jmp    80057d <vprintfmt+0x278>
  800575:	89 df                	mov    %ebx,%edi
  800577:	8b 75 08             	mov    0x8(%ebp),%esi
  80057a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80057d:	85 ff                	test   %edi,%edi
  80057f:	7f e4                	jg     800565 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800581:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800584:	e9 a2 fd ff ff       	jmp    80032b <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800589:	8d 45 14             	lea    0x14(%ebp),%eax
  80058c:	e8 08 fd ff ff       	call   800299 <getint>
  800591:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800594:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800597:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  80059c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005a0:	79 74                	jns    800616 <vprintfmt+0x311>
				putch('-', putdat);
  8005a2:	83 ec 08             	sub    $0x8,%esp
  8005a5:	53                   	push   %ebx
  8005a6:	6a 2d                	push   $0x2d
  8005a8:	ff d6                	call   *%esi
				num = -(long long) num;
  8005aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005ad:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005b0:	f7 d8                	neg    %eax
  8005b2:	83 d2 00             	adc    $0x0,%edx
  8005b5:	f7 da                	neg    %edx
  8005b7:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8005ba:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8005bf:	eb 55                	jmp    800616 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8005c1:	8d 45 14             	lea    0x14(%ebp),%eax
  8005c4:	e8 96 fc ff ff       	call   80025f <getuint>
			base = 10;
  8005c9:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8005ce:	eb 46                	jmp    800616 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8005d0:	8d 45 14             	lea    0x14(%ebp),%eax
  8005d3:	e8 87 fc ff ff       	call   80025f <getuint>
			base = 8;
  8005d8:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8005dd:	eb 37                	jmp    800616 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  8005df:	83 ec 08             	sub    $0x8,%esp
  8005e2:	53                   	push   %ebx
  8005e3:	6a 30                	push   $0x30
  8005e5:	ff d6                	call   *%esi
			putch('x', putdat);
  8005e7:	83 c4 08             	add    $0x8,%esp
  8005ea:	53                   	push   %ebx
  8005eb:	6a 78                	push   $0x78
  8005ed:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8d 50 04             	lea    0x4(%eax),%edx
  8005f5:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8005f8:	8b 00                	mov    (%eax),%eax
  8005fa:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8005ff:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800602:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800607:	eb 0d                	jmp    800616 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800609:	8d 45 14             	lea    0x14(%ebp),%eax
  80060c:	e8 4e fc ff ff       	call   80025f <getuint>
			base = 16;
  800611:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800616:	83 ec 0c             	sub    $0xc,%esp
  800619:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80061d:	57                   	push   %edi
  80061e:	ff 75 e0             	pushl  -0x20(%ebp)
  800621:	51                   	push   %ecx
  800622:	52                   	push   %edx
  800623:	50                   	push   %eax
  800624:	89 da                	mov    %ebx,%edx
  800626:	89 f0                	mov    %esi,%eax
  800628:	e8 83 fb ff ff       	call   8001b0 <printnum>
			break;
  80062d:	83 c4 20             	add    $0x20,%esp
  800630:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800633:	e9 f3 fc ff ff       	jmp    80032b <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	53                   	push   %ebx
  80063c:	51                   	push   %ecx
  80063d:	ff d6                	call   *%esi
			break;
  80063f:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800642:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800645:	e9 e1 fc ff ff       	jmp    80032b <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	53                   	push   %ebx
  80064e:	6a 25                	push   $0x25
  800650:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800652:	83 c4 10             	add    $0x10,%esp
  800655:	eb 03                	jmp    80065a <vprintfmt+0x355>
  800657:	83 ef 01             	sub    $0x1,%edi
  80065a:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  80065e:	75 f7                	jne    800657 <vprintfmt+0x352>
  800660:	e9 c6 fc ff ff       	jmp    80032b <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  800665:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800668:	5b                   	pop    %ebx
  800669:	5e                   	pop    %esi
  80066a:	5f                   	pop    %edi
  80066b:	5d                   	pop    %ebp
  80066c:	c3                   	ret    

0080066d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80066d:	55                   	push   %ebp
  80066e:	89 e5                	mov    %esp,%ebp
  800670:	83 ec 18             	sub    $0x18,%esp
  800673:	8b 45 08             	mov    0x8(%ebp),%eax
  800676:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800679:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80067c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800680:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800683:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80068a:	85 c0                	test   %eax,%eax
  80068c:	74 26                	je     8006b4 <vsnprintf+0x47>
  80068e:	85 d2                	test   %edx,%edx
  800690:	7e 22                	jle    8006b4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800692:	ff 75 14             	pushl  0x14(%ebp)
  800695:	ff 75 10             	pushl  0x10(%ebp)
  800698:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80069b:	50                   	push   %eax
  80069c:	68 cb 02 80 00       	push   $0x8002cb
  8006a1:	e8 5f fc ff ff       	call   800305 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006a9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006af:	83 c4 10             	add    $0x10,%esp
  8006b2:	eb 05                	jmp    8006b9 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8006b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8006b9:	c9                   	leave  
  8006ba:	c3                   	ret    

008006bb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006bb:	55                   	push   %ebp
  8006bc:	89 e5                	mov    %esp,%ebp
  8006be:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8006c1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8006c4:	50                   	push   %eax
  8006c5:	ff 75 10             	pushl  0x10(%ebp)
  8006c8:	ff 75 0c             	pushl  0xc(%ebp)
  8006cb:	ff 75 08             	pushl  0x8(%ebp)
  8006ce:	e8 9a ff ff ff       	call   80066d <vsnprintf>
	va_end(ap);

	return rc;
}
  8006d3:	c9                   	leave  
  8006d4:	c3                   	ret    

008006d5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8006d5:	55                   	push   %ebp
  8006d6:	89 e5                	mov    %esp,%ebp
  8006d8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8006db:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e0:	eb 03                	jmp    8006e5 <strlen+0x10>
		n++;
  8006e2:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8006e5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8006e9:	75 f7                	jne    8006e2 <strlen+0xd>
		n++;
	return n;
}
  8006eb:	5d                   	pop    %ebp
  8006ec:	c3                   	ret    

008006ed <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8006ed:	55                   	push   %ebp
  8006ee:	89 e5                	mov    %esp,%ebp
  8006f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006f3:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8006f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fb:	eb 03                	jmp    800700 <strnlen+0x13>
		n++;
  8006fd:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800700:	39 c2                	cmp    %eax,%edx
  800702:	74 08                	je     80070c <strnlen+0x1f>
  800704:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800708:	75 f3                	jne    8006fd <strnlen+0x10>
  80070a:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  80070c:	5d                   	pop    %ebp
  80070d:	c3                   	ret    

0080070e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80070e:	55                   	push   %ebp
  80070f:	89 e5                	mov    %esp,%ebp
  800711:	53                   	push   %ebx
  800712:	8b 45 08             	mov    0x8(%ebp),%eax
  800715:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800718:	89 c2                	mov    %eax,%edx
  80071a:	83 c2 01             	add    $0x1,%edx
  80071d:	83 c1 01             	add    $0x1,%ecx
  800720:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800724:	88 5a ff             	mov    %bl,-0x1(%edx)
  800727:	84 db                	test   %bl,%bl
  800729:	75 ef                	jne    80071a <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80072b:	5b                   	pop    %ebx
  80072c:	5d                   	pop    %ebp
  80072d:	c3                   	ret    

0080072e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80072e:	55                   	push   %ebp
  80072f:	89 e5                	mov    %esp,%ebp
  800731:	53                   	push   %ebx
  800732:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800735:	53                   	push   %ebx
  800736:	e8 9a ff ff ff       	call   8006d5 <strlen>
  80073b:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80073e:	ff 75 0c             	pushl  0xc(%ebp)
  800741:	01 d8                	add    %ebx,%eax
  800743:	50                   	push   %eax
  800744:	e8 c5 ff ff ff       	call   80070e <strcpy>
	return dst;
}
  800749:	89 d8                	mov    %ebx,%eax
  80074b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80074e:	c9                   	leave  
  80074f:	c3                   	ret    

00800750 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	56                   	push   %esi
  800754:	53                   	push   %ebx
  800755:	8b 75 08             	mov    0x8(%ebp),%esi
  800758:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80075b:	89 f3                	mov    %esi,%ebx
  80075d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800760:	89 f2                	mov    %esi,%edx
  800762:	eb 0f                	jmp    800773 <strncpy+0x23>
		*dst++ = *src;
  800764:	83 c2 01             	add    $0x1,%edx
  800767:	0f b6 01             	movzbl (%ecx),%eax
  80076a:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80076d:	80 39 01             	cmpb   $0x1,(%ecx)
  800770:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800773:	39 da                	cmp    %ebx,%edx
  800775:	75 ed                	jne    800764 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800777:	89 f0                	mov    %esi,%eax
  800779:	5b                   	pop    %ebx
  80077a:	5e                   	pop    %esi
  80077b:	5d                   	pop    %ebp
  80077c:	c3                   	ret    

0080077d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80077d:	55                   	push   %ebp
  80077e:	89 e5                	mov    %esp,%ebp
  800780:	56                   	push   %esi
  800781:	53                   	push   %ebx
  800782:	8b 75 08             	mov    0x8(%ebp),%esi
  800785:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800788:	8b 55 10             	mov    0x10(%ebp),%edx
  80078b:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80078d:	85 d2                	test   %edx,%edx
  80078f:	74 21                	je     8007b2 <strlcpy+0x35>
  800791:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800795:	89 f2                	mov    %esi,%edx
  800797:	eb 09                	jmp    8007a2 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800799:	83 c2 01             	add    $0x1,%edx
  80079c:	83 c1 01             	add    $0x1,%ecx
  80079f:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8007a2:	39 c2                	cmp    %eax,%edx
  8007a4:	74 09                	je     8007af <strlcpy+0x32>
  8007a6:	0f b6 19             	movzbl (%ecx),%ebx
  8007a9:	84 db                	test   %bl,%bl
  8007ab:	75 ec                	jne    800799 <strlcpy+0x1c>
  8007ad:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  8007af:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007b2:	29 f0                	sub    %esi,%eax
}
  8007b4:	5b                   	pop    %ebx
  8007b5:	5e                   	pop    %esi
  8007b6:	5d                   	pop    %ebp
  8007b7:	c3                   	ret    

008007b8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007b8:	55                   	push   %ebp
  8007b9:	89 e5                	mov    %esp,%ebp
  8007bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007be:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007c1:	eb 06                	jmp    8007c9 <strcmp+0x11>
		p++, q++;
  8007c3:	83 c1 01             	add    $0x1,%ecx
  8007c6:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8007c9:	0f b6 01             	movzbl (%ecx),%eax
  8007cc:	84 c0                	test   %al,%al
  8007ce:	74 04                	je     8007d4 <strcmp+0x1c>
  8007d0:	3a 02                	cmp    (%edx),%al
  8007d2:	74 ef                	je     8007c3 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8007d4:	0f b6 c0             	movzbl %al,%eax
  8007d7:	0f b6 12             	movzbl (%edx),%edx
  8007da:	29 d0                	sub    %edx,%eax
}
  8007dc:	5d                   	pop    %ebp
  8007dd:	c3                   	ret    

008007de <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8007de:	55                   	push   %ebp
  8007df:	89 e5                	mov    %esp,%ebp
  8007e1:	53                   	push   %ebx
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e8:	89 c3                	mov    %eax,%ebx
  8007ea:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8007ed:	eb 06                	jmp    8007f5 <strncmp+0x17>
		n--, p++, q++;
  8007ef:	83 c0 01             	add    $0x1,%eax
  8007f2:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8007f5:	39 d8                	cmp    %ebx,%eax
  8007f7:	74 15                	je     80080e <strncmp+0x30>
  8007f9:	0f b6 08             	movzbl (%eax),%ecx
  8007fc:	84 c9                	test   %cl,%cl
  8007fe:	74 04                	je     800804 <strncmp+0x26>
  800800:	3a 0a                	cmp    (%edx),%cl
  800802:	74 eb                	je     8007ef <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800804:	0f b6 00             	movzbl (%eax),%eax
  800807:	0f b6 12             	movzbl (%edx),%edx
  80080a:	29 d0                	sub    %edx,%eax
  80080c:	eb 05                	jmp    800813 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  80080e:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800813:	5b                   	pop    %ebx
  800814:	5d                   	pop    %ebp
  800815:	c3                   	ret    

00800816 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800816:	55                   	push   %ebp
  800817:	89 e5                	mov    %esp,%ebp
  800819:	8b 45 08             	mov    0x8(%ebp),%eax
  80081c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800820:	eb 07                	jmp    800829 <strchr+0x13>
		if (*s == c)
  800822:	38 ca                	cmp    %cl,%dl
  800824:	74 0f                	je     800835 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800826:	83 c0 01             	add    $0x1,%eax
  800829:	0f b6 10             	movzbl (%eax),%edx
  80082c:	84 d2                	test   %dl,%dl
  80082e:	75 f2                	jne    800822 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800830:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800835:	5d                   	pop    %ebp
  800836:	c3                   	ret    

00800837 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800837:	55                   	push   %ebp
  800838:	89 e5                	mov    %esp,%ebp
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800841:	eb 03                	jmp    800846 <strfind+0xf>
  800843:	83 c0 01             	add    $0x1,%eax
  800846:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800849:	38 ca                	cmp    %cl,%dl
  80084b:	74 04                	je     800851 <strfind+0x1a>
  80084d:	84 d2                	test   %dl,%dl
  80084f:	75 f2                	jne    800843 <strfind+0xc>
			break;
	return (char *) s;
}
  800851:	5d                   	pop    %ebp
  800852:	c3                   	ret    

00800853 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800853:	55                   	push   %ebp
  800854:	89 e5                	mov    %esp,%ebp
  800856:	57                   	push   %edi
  800857:	56                   	push   %esi
  800858:	53                   	push   %ebx
  800859:	8b 55 08             	mov    0x8(%ebp),%edx
  80085c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  80085f:	85 c9                	test   %ecx,%ecx
  800861:	74 37                	je     80089a <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800863:	f6 c2 03             	test   $0x3,%dl
  800866:	75 2a                	jne    800892 <memset+0x3f>
  800868:	f6 c1 03             	test   $0x3,%cl
  80086b:	75 25                	jne    800892 <memset+0x3f>
		c &= 0xFF;
  80086d:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800871:	89 df                	mov    %ebx,%edi
  800873:	c1 e7 08             	shl    $0x8,%edi
  800876:	89 de                	mov    %ebx,%esi
  800878:	c1 e6 18             	shl    $0x18,%esi
  80087b:	89 d8                	mov    %ebx,%eax
  80087d:	c1 e0 10             	shl    $0x10,%eax
  800880:	09 f0                	or     %esi,%eax
  800882:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800884:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800887:	89 f8                	mov    %edi,%eax
  800889:	09 d8                	or     %ebx,%eax
  80088b:	89 d7                	mov    %edx,%edi
  80088d:	fc                   	cld    
  80088e:	f3 ab                	rep stos %eax,%es:(%edi)
  800890:	eb 08                	jmp    80089a <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800892:	89 d7                	mov    %edx,%edi
  800894:	8b 45 0c             	mov    0xc(%ebp),%eax
  800897:	fc                   	cld    
  800898:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  80089a:	89 d0                	mov    %edx,%eax
  80089c:	5b                   	pop    %ebx
  80089d:	5e                   	pop    %esi
  80089e:	5f                   	pop    %edi
  80089f:	5d                   	pop    %ebp
  8008a0:	c3                   	ret    

008008a1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008a1:	55                   	push   %ebp
  8008a2:	89 e5                	mov    %esp,%ebp
  8008a4:	57                   	push   %edi
  8008a5:	56                   	push   %esi
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008af:	39 c6                	cmp    %eax,%esi
  8008b1:	73 35                	jae    8008e8 <memmove+0x47>
  8008b3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008b6:	39 d0                	cmp    %edx,%eax
  8008b8:	73 2e                	jae    8008e8 <memmove+0x47>
		s += n;
		d += n;
  8008ba:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008bd:	89 d6                	mov    %edx,%esi
  8008bf:	09 fe                	or     %edi,%esi
  8008c1:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008c7:	75 13                	jne    8008dc <memmove+0x3b>
  8008c9:	f6 c1 03             	test   $0x3,%cl
  8008cc:	75 0e                	jne    8008dc <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  8008ce:	83 ef 04             	sub    $0x4,%edi
  8008d1:	8d 72 fc             	lea    -0x4(%edx),%esi
  8008d4:	c1 e9 02             	shr    $0x2,%ecx
  8008d7:	fd                   	std    
  8008d8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008da:	eb 09                	jmp    8008e5 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8008dc:	83 ef 01             	sub    $0x1,%edi
  8008df:	8d 72 ff             	lea    -0x1(%edx),%esi
  8008e2:	fd                   	std    
  8008e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8008e5:	fc                   	cld    
  8008e6:	eb 1d                	jmp    800905 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008e8:	89 f2                	mov    %esi,%edx
  8008ea:	09 c2                	or     %eax,%edx
  8008ec:	f6 c2 03             	test   $0x3,%dl
  8008ef:	75 0f                	jne    800900 <memmove+0x5f>
  8008f1:	f6 c1 03             	test   $0x3,%cl
  8008f4:	75 0a                	jne    800900 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  8008f6:	c1 e9 02             	shr    $0x2,%ecx
  8008f9:	89 c7                	mov    %eax,%edi
  8008fb:	fc                   	cld    
  8008fc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008fe:	eb 05                	jmp    800905 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800900:	89 c7                	mov    %eax,%edi
  800902:	fc                   	cld    
  800903:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800905:	5e                   	pop    %esi
  800906:	5f                   	pop    %edi
  800907:	5d                   	pop    %ebp
  800908:	c3                   	ret    

00800909 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80090c:	ff 75 10             	pushl  0x10(%ebp)
  80090f:	ff 75 0c             	pushl  0xc(%ebp)
  800912:	ff 75 08             	pushl  0x8(%ebp)
  800915:	e8 87 ff ff ff       	call   8008a1 <memmove>
}
  80091a:	c9                   	leave  
  80091b:	c3                   	ret    

0080091c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	56                   	push   %esi
  800920:	53                   	push   %ebx
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	8b 55 0c             	mov    0xc(%ebp),%edx
  800927:	89 c6                	mov    %eax,%esi
  800929:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80092c:	eb 1a                	jmp    800948 <memcmp+0x2c>
		if (*s1 != *s2)
  80092e:	0f b6 08             	movzbl (%eax),%ecx
  800931:	0f b6 1a             	movzbl (%edx),%ebx
  800934:	38 d9                	cmp    %bl,%cl
  800936:	74 0a                	je     800942 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800938:	0f b6 c1             	movzbl %cl,%eax
  80093b:	0f b6 db             	movzbl %bl,%ebx
  80093e:	29 d8                	sub    %ebx,%eax
  800940:	eb 0f                	jmp    800951 <memcmp+0x35>
		s1++, s2++;
  800942:	83 c0 01             	add    $0x1,%eax
  800945:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800948:	39 f0                	cmp    %esi,%eax
  80094a:	75 e2                	jne    80092e <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80094c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800951:	5b                   	pop    %ebx
  800952:	5e                   	pop    %esi
  800953:	5d                   	pop    %ebp
  800954:	c3                   	ret    

00800955 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	53                   	push   %ebx
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  80095c:	89 c1                	mov    %eax,%ecx
  80095e:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  800961:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800965:	eb 0a                	jmp    800971 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800967:	0f b6 10             	movzbl (%eax),%edx
  80096a:	39 da                	cmp    %ebx,%edx
  80096c:	74 07                	je     800975 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80096e:	83 c0 01             	add    $0x1,%eax
  800971:	39 c8                	cmp    %ecx,%eax
  800973:	72 f2                	jb     800967 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800975:	5b                   	pop    %ebx
  800976:	5d                   	pop    %ebp
  800977:	c3                   	ret    

00800978 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800978:	55                   	push   %ebp
  800979:	89 e5                	mov    %esp,%ebp
  80097b:	57                   	push   %edi
  80097c:	56                   	push   %esi
  80097d:	53                   	push   %ebx
  80097e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800981:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800984:	eb 03                	jmp    800989 <strtol+0x11>
		s++;
  800986:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800989:	0f b6 01             	movzbl (%ecx),%eax
  80098c:	3c 20                	cmp    $0x20,%al
  80098e:	74 f6                	je     800986 <strtol+0xe>
  800990:	3c 09                	cmp    $0x9,%al
  800992:	74 f2                	je     800986 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800994:	3c 2b                	cmp    $0x2b,%al
  800996:	75 0a                	jne    8009a2 <strtol+0x2a>
		s++;
  800998:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  80099b:	bf 00 00 00 00       	mov    $0x0,%edi
  8009a0:	eb 11                	jmp    8009b3 <strtol+0x3b>
  8009a2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8009a7:	3c 2d                	cmp    $0x2d,%al
  8009a9:	75 08                	jne    8009b3 <strtol+0x3b>
		s++, neg = 1;
  8009ab:	83 c1 01             	add    $0x1,%ecx
  8009ae:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009b3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009b9:	75 15                	jne    8009d0 <strtol+0x58>
  8009bb:	80 39 30             	cmpb   $0x30,(%ecx)
  8009be:	75 10                	jne    8009d0 <strtol+0x58>
  8009c0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8009c4:	75 7c                	jne    800a42 <strtol+0xca>
		s += 2, base = 16;
  8009c6:	83 c1 02             	add    $0x2,%ecx
  8009c9:	bb 10 00 00 00       	mov    $0x10,%ebx
  8009ce:	eb 16                	jmp    8009e6 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  8009d0:	85 db                	test   %ebx,%ebx
  8009d2:	75 12                	jne    8009e6 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009d4:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009d9:	80 39 30             	cmpb   $0x30,(%ecx)
  8009dc:	75 08                	jne    8009e6 <strtol+0x6e>
		s++, base = 8;
  8009de:	83 c1 01             	add    $0x1,%ecx
  8009e1:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  8009e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009eb:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8009ee:	0f b6 11             	movzbl (%ecx),%edx
  8009f1:	8d 72 d0             	lea    -0x30(%edx),%esi
  8009f4:	89 f3                	mov    %esi,%ebx
  8009f6:	80 fb 09             	cmp    $0x9,%bl
  8009f9:	77 08                	ja     800a03 <strtol+0x8b>
			dig = *s - '0';
  8009fb:	0f be d2             	movsbl %dl,%edx
  8009fe:	83 ea 30             	sub    $0x30,%edx
  800a01:	eb 22                	jmp    800a25 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800a03:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a06:	89 f3                	mov    %esi,%ebx
  800a08:	80 fb 19             	cmp    $0x19,%bl
  800a0b:	77 08                	ja     800a15 <strtol+0x9d>
			dig = *s - 'a' + 10;
  800a0d:	0f be d2             	movsbl %dl,%edx
  800a10:	83 ea 57             	sub    $0x57,%edx
  800a13:	eb 10                	jmp    800a25 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800a15:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a18:	89 f3                	mov    %esi,%ebx
  800a1a:	80 fb 19             	cmp    $0x19,%bl
  800a1d:	77 16                	ja     800a35 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800a1f:	0f be d2             	movsbl %dl,%edx
  800a22:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800a25:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a28:	7d 0b                	jge    800a35 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800a2a:	83 c1 01             	add    $0x1,%ecx
  800a2d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a31:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800a33:	eb b9                	jmp    8009ee <strtol+0x76>

	if (endptr)
  800a35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a39:	74 0d                	je     800a48 <strtol+0xd0>
		*endptr = (char *) s;
  800a3b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a3e:	89 0e                	mov    %ecx,(%esi)
  800a40:	eb 06                	jmp    800a48 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a42:	85 db                	test   %ebx,%ebx
  800a44:	74 98                	je     8009de <strtol+0x66>
  800a46:	eb 9e                	jmp    8009e6 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800a48:	89 c2                	mov    %eax,%edx
  800a4a:	f7 da                	neg    %edx
  800a4c:	85 ff                	test   %edi,%edi
  800a4e:	0f 45 c2             	cmovne %edx,%eax
}
  800a51:	5b                   	pop    %ebx
  800a52:	5e                   	pop    %esi
  800a53:	5f                   	pop    %edi
  800a54:	5d                   	pop    %ebp
  800a55:	c3                   	ret    

00800a56 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	57                   	push   %edi
  800a5a:	56                   	push   %esi
  800a5b:	53                   	push   %ebx
  800a5c:	83 ec 1c             	sub    $0x1c,%esp
  800a5f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a62:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a65:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800a67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a6a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a6d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800a70:	8b 75 14             	mov    0x14(%ebp),%esi
  800a73:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800a75:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a79:	74 1d                	je     800a98 <syscall+0x42>
  800a7b:	85 c0                	test   %eax,%eax
  800a7d:	7e 19                	jle    800a98 <syscall+0x42>
  800a7f:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800a82:	83 ec 0c             	sub    $0xc,%esp
  800a85:	50                   	push   %eax
  800a86:	52                   	push   %edx
  800a87:	68 ff 20 80 00       	push   $0x8020ff
  800a8c:	6a 23                	push   $0x23
  800a8e:	68 1c 21 80 00       	push   $0x80211c
  800a93:	e8 e9 0e 00 00       	call   801981 <_panic>

	return ret;
}
  800a98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a9b:	5b                   	pop    %ebx
  800a9c:	5e                   	pop    %esi
  800a9d:	5f                   	pop    %edi
  800a9e:	5d                   	pop    %ebp
  800a9f:	c3                   	ret    

00800aa0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
  800aa3:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800aa6:	6a 00                	push   $0x0
  800aa8:	6a 00                	push   $0x0
  800aaa:	6a 00                	push   $0x0
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab7:	b8 00 00 00 00       	mov    $0x0,%eax
  800abc:	e8 95 ff ff ff       	call   800a56 <syscall>
}
  800ac1:	83 c4 10             	add    $0x10,%esp
  800ac4:	c9                   	leave  
  800ac5:	c3                   	ret    

00800ac6 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800acc:	6a 00                	push   $0x0
  800ace:	6a 00                	push   $0x0
  800ad0:	6a 00                	push   $0x0
  800ad2:	6a 00                	push   $0x0
  800ad4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ad9:	ba 00 00 00 00       	mov    $0x0,%edx
  800ade:	b8 01 00 00 00       	mov    $0x1,%eax
  800ae3:	e8 6e ff ff ff       	call   800a56 <syscall>
}
  800ae8:	c9                   	leave  
  800ae9:	c3                   	ret    

00800aea <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800af0:	6a 00                	push   $0x0
  800af2:	6a 00                	push   $0x0
  800af4:	6a 00                	push   $0x0
  800af6:	6a 00                	push   $0x0
  800af8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800afb:	ba 01 00 00 00       	mov    $0x1,%edx
  800b00:	b8 03 00 00 00       	mov    $0x3,%eax
  800b05:	e8 4c ff ff ff       	call   800a56 <syscall>
}
  800b0a:	c9                   	leave  
  800b0b:	c3                   	ret    

00800b0c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b0c:	55                   	push   %ebp
  800b0d:	89 e5                	mov    %esp,%ebp
  800b0f:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b12:	6a 00                	push   $0x0
  800b14:	6a 00                	push   $0x0
  800b16:	6a 00                	push   $0x0
  800b18:	6a 00                	push   $0x0
  800b1a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b24:	b8 02 00 00 00       	mov    $0x2,%eax
  800b29:	e8 28 ff ff ff       	call   800a56 <syscall>
}
  800b2e:	c9                   	leave  
  800b2f:	c3                   	ret    

00800b30 <sys_yield>:

void
sys_yield(void)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
  800b33:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b36:	6a 00                	push   $0x0
  800b38:	6a 00                	push   $0x0
  800b3a:	6a 00                	push   $0x0
  800b3c:	6a 00                	push   $0x0
  800b3e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b43:	ba 00 00 00 00       	mov    $0x0,%edx
  800b48:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b4d:	e8 04 ff ff ff       	call   800a56 <syscall>
}
  800b52:	83 c4 10             	add    $0x10,%esp
  800b55:	c9                   	leave  
  800b56:	c3                   	ret    

00800b57 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
  800b5a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800b5d:	6a 00                	push   $0x0
  800b5f:	6a 00                	push   $0x0
  800b61:	ff 75 10             	pushl  0x10(%ebp)
  800b64:	ff 75 0c             	pushl  0xc(%ebp)
  800b67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b6a:	ba 01 00 00 00       	mov    $0x1,%edx
  800b6f:	b8 04 00 00 00       	mov    $0x4,%eax
  800b74:	e8 dd fe ff ff       	call   800a56 <syscall>
}
  800b79:	c9                   	leave  
  800b7a:	c3                   	ret    

00800b7b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800b81:	ff 75 18             	pushl  0x18(%ebp)
  800b84:	ff 75 14             	pushl  0x14(%ebp)
  800b87:	ff 75 10             	pushl  0x10(%ebp)
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b90:	ba 01 00 00 00       	mov    $0x1,%edx
  800b95:	b8 05 00 00 00       	mov    $0x5,%eax
  800b9a:	e8 b7 fe ff ff       	call   800a56 <syscall>
}
  800b9f:	c9                   	leave  
  800ba0:	c3                   	ret    

00800ba1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
  800ba4:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800ba7:	6a 00                	push   $0x0
  800ba9:	6a 00                	push   $0x0
  800bab:	6a 00                	push   $0x0
  800bad:	ff 75 0c             	pushl  0xc(%ebp)
  800bb0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb3:	ba 01 00 00 00       	mov    $0x1,%edx
  800bb8:	b8 06 00 00 00       	mov    $0x6,%eax
  800bbd:	e8 94 fe ff ff       	call   800a56 <syscall>
}
  800bc2:	c9                   	leave  
  800bc3:	c3                   	ret    

00800bc4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800bca:	6a 00                	push   $0x0
  800bcc:	6a 00                	push   $0x0
  800bce:	6a 00                	push   $0x0
  800bd0:	ff 75 0c             	pushl  0xc(%ebp)
  800bd3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd6:	ba 01 00 00 00       	mov    $0x1,%edx
  800bdb:	b8 08 00 00 00       	mov    $0x8,%eax
  800be0:	e8 71 fe ff ff       	call   800a56 <syscall>
}
  800be5:	c9                   	leave  
  800be6:	c3                   	ret    

00800be7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800bed:	6a 00                	push   $0x0
  800bef:	6a 00                	push   $0x0
  800bf1:	6a 00                	push   $0x0
  800bf3:	ff 75 0c             	pushl  0xc(%ebp)
  800bf6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf9:	ba 01 00 00 00       	mov    $0x1,%edx
  800bfe:	b8 09 00 00 00       	mov    $0x9,%eax
  800c03:	e8 4e fe ff ff       	call   800a56 <syscall>
}
  800c08:	c9                   	leave  
  800c09:	c3                   	ret    

00800c0a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800c10:	6a 00                	push   $0x0
  800c12:	6a 00                	push   $0x0
  800c14:	6a 00                	push   $0x0
  800c16:	ff 75 0c             	pushl  0xc(%ebp)
  800c19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c1c:	ba 01 00 00 00       	mov    $0x1,%edx
  800c21:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c26:	e8 2b fe ff ff       	call   800a56 <syscall>
}
  800c2b:	c9                   	leave  
  800c2c:	c3                   	ret    

00800c2d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800c33:	6a 00                	push   $0x0
  800c35:	ff 75 14             	pushl  0x14(%ebp)
  800c38:	ff 75 10             	pushl  0x10(%ebp)
  800c3b:	ff 75 0c             	pushl  0xc(%ebp)
  800c3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c41:	ba 00 00 00 00       	mov    $0x0,%edx
  800c46:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c4b:	e8 06 fe ff ff       	call   800a56 <syscall>
}
  800c50:	c9                   	leave  
  800c51:	c3                   	ret    

00800c52 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800c58:	6a 00                	push   $0x0
  800c5a:	6a 00                	push   $0x0
  800c5c:	6a 00                	push   $0x0
  800c5e:	6a 00                	push   $0x0
  800c60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c63:	ba 01 00 00 00       	mov    $0x1,%edx
  800c68:	b8 0d 00 00 00       	mov    $0xd,%eax
  800c6d:	e8 e4 fd ff ff       	call   800a56 <syscall>
}
  800c72:	c9                   	leave  
  800c73:	c3                   	ret    

00800c74 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800c77:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7a:	05 00 00 00 30       	add    $0x30000000,%eax
  800c7f:	c1 e8 0c             	shr    $0xc,%eax
}
  800c82:	5d                   	pop    %ebp
  800c83:	c3                   	ret    

00800c84 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  800c87:	ff 75 08             	pushl  0x8(%ebp)
  800c8a:	e8 e5 ff ff ff       	call   800c74 <fd2num>
  800c8f:	83 c4 04             	add    $0x4,%esp
  800c92:	c1 e0 0c             	shl    $0xc,%eax
  800c95:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ca2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ca7:	89 c2                	mov    %eax,%edx
  800ca9:	c1 ea 16             	shr    $0x16,%edx
  800cac:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800cb3:	f6 c2 01             	test   $0x1,%dl
  800cb6:	74 11                	je     800cc9 <fd_alloc+0x2d>
  800cb8:	89 c2                	mov    %eax,%edx
  800cba:	c1 ea 0c             	shr    $0xc,%edx
  800cbd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800cc4:	f6 c2 01             	test   $0x1,%dl
  800cc7:	75 09                	jne    800cd2 <fd_alloc+0x36>
			*fd_store = fd;
  800cc9:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ccb:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd0:	eb 17                	jmp    800ce9 <fd_alloc+0x4d>
  800cd2:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800cd7:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800cdc:	75 c9                	jne    800ca7 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800cde:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800ce4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800cf1:	83 f8 1f             	cmp    $0x1f,%eax
  800cf4:	77 36                	ja     800d2c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800cf6:	c1 e0 0c             	shl    $0xc,%eax
  800cf9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800cfe:	89 c2                	mov    %eax,%edx
  800d00:	c1 ea 16             	shr    $0x16,%edx
  800d03:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800d0a:	f6 c2 01             	test   $0x1,%dl
  800d0d:	74 24                	je     800d33 <fd_lookup+0x48>
  800d0f:	89 c2                	mov    %eax,%edx
  800d11:	c1 ea 0c             	shr    $0xc,%edx
  800d14:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d1b:	f6 c2 01             	test   $0x1,%dl
  800d1e:	74 1a                	je     800d3a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800d20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d23:	89 02                	mov    %eax,(%edx)
	return 0;
  800d25:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2a:	eb 13                	jmp    800d3f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800d2c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d31:	eb 0c                	jmp    800d3f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800d33:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d38:	eb 05                	jmp    800d3f <fd_lookup+0x54>
  800d3a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    

00800d41 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	83 ec 08             	sub    $0x8,%esp
  800d47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d4a:	ba a8 21 80 00       	mov    $0x8021a8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800d4f:	eb 13                	jmp    800d64 <dev_lookup+0x23>
  800d51:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  800d54:	39 08                	cmp    %ecx,(%eax)
  800d56:	75 0c                	jne    800d64 <dev_lookup+0x23>
			*dev = devtab[i];
  800d58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5b:	89 01                	mov    %eax,(%ecx)
			return 0;
  800d5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d62:	eb 2e                	jmp    800d92 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800d64:	8b 02                	mov    (%edx),%eax
  800d66:	85 c0                	test   %eax,%eax
  800d68:	75 e7                	jne    800d51 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800d6a:	a1 04 40 80 00       	mov    0x804004,%eax
  800d6f:	8b 40 48             	mov    0x48(%eax),%eax
  800d72:	83 ec 04             	sub    $0x4,%esp
  800d75:	51                   	push   %ecx
  800d76:	50                   	push   %eax
  800d77:	68 2c 21 80 00       	push   $0x80212c
  800d7c:	e8 1b f4 ff ff       	call   80019c <cprintf>
	*dev = 0;
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800d8a:	83 c4 10             	add    $0x10,%esp
  800d8d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800d92:	c9                   	leave  
  800d93:	c3                   	ret    

00800d94 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	56                   	push   %esi
  800d98:	53                   	push   %ebx
  800d99:	83 ec 10             	sub    $0x10,%esp
  800d9c:	8b 75 08             	mov    0x8(%ebp),%esi
  800d9f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800da2:	56                   	push   %esi
  800da3:	e8 cc fe ff ff       	call   800c74 <fd2num>
  800da8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800dab:	89 14 24             	mov    %edx,(%esp)
  800dae:	50                   	push   %eax
  800daf:	e8 37 ff ff ff       	call   800ceb <fd_lookup>
  800db4:	83 c4 08             	add    $0x8,%esp
  800db7:	85 c0                	test   %eax,%eax
  800db9:	78 05                	js     800dc0 <fd_close+0x2c>
	    || fd != fd2)
  800dbb:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800dbe:	74 0c                	je     800dcc <fd_close+0x38>
		return (must_exist ? r : 0);
  800dc0:	84 db                	test   %bl,%bl
  800dc2:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc7:	0f 44 c2             	cmove  %edx,%eax
  800dca:	eb 41                	jmp    800e0d <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800dcc:	83 ec 08             	sub    $0x8,%esp
  800dcf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800dd2:	50                   	push   %eax
  800dd3:	ff 36                	pushl  (%esi)
  800dd5:	e8 67 ff ff ff       	call   800d41 <dev_lookup>
  800dda:	89 c3                	mov    %eax,%ebx
  800ddc:	83 c4 10             	add    $0x10,%esp
  800ddf:	85 c0                	test   %eax,%eax
  800de1:	78 1a                	js     800dfd <fd_close+0x69>
		if (dev->dev_close)
  800de3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de6:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800de9:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800dee:	85 c0                	test   %eax,%eax
  800df0:	74 0b                	je     800dfd <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  800df2:	83 ec 0c             	sub    $0xc,%esp
  800df5:	56                   	push   %esi
  800df6:	ff d0                	call   *%eax
  800df8:	89 c3                	mov    %eax,%ebx
  800dfa:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800dfd:	83 ec 08             	sub    $0x8,%esp
  800e00:	56                   	push   %esi
  800e01:	6a 00                	push   $0x0
  800e03:	e8 99 fd ff ff       	call   800ba1 <sys_page_unmap>
	return r;
  800e08:	83 c4 10             	add    $0x10,%esp
  800e0b:	89 d8                	mov    %ebx,%eax
}
  800e0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e10:	5b                   	pop    %ebx
  800e11:	5e                   	pop    %esi
  800e12:	5d                   	pop    %ebp
  800e13:	c3                   	ret    

00800e14 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e1a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e1d:	50                   	push   %eax
  800e1e:	ff 75 08             	pushl  0x8(%ebp)
  800e21:	e8 c5 fe ff ff       	call   800ceb <fd_lookup>
  800e26:	83 c4 08             	add    $0x8,%esp
  800e29:	85 c0                	test   %eax,%eax
  800e2b:	78 10                	js     800e3d <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800e2d:	83 ec 08             	sub    $0x8,%esp
  800e30:	6a 01                	push   $0x1
  800e32:	ff 75 f4             	pushl  -0xc(%ebp)
  800e35:	e8 5a ff ff ff       	call   800d94 <fd_close>
  800e3a:	83 c4 10             	add    $0x10,%esp
}
  800e3d:	c9                   	leave  
  800e3e:	c3                   	ret    

00800e3f <close_all>:

void
close_all(void)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	53                   	push   %ebx
  800e43:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800e46:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800e4b:	83 ec 0c             	sub    $0xc,%esp
  800e4e:	53                   	push   %ebx
  800e4f:	e8 c0 ff ff ff       	call   800e14 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800e54:	83 c3 01             	add    $0x1,%ebx
  800e57:	83 c4 10             	add    $0x10,%esp
  800e5a:	83 fb 20             	cmp    $0x20,%ebx
  800e5d:	75 ec                	jne    800e4b <close_all+0xc>
		close(i);
}
  800e5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e62:	c9                   	leave  
  800e63:	c3                   	ret    

00800e64 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	57                   	push   %edi
  800e68:	56                   	push   %esi
  800e69:	53                   	push   %ebx
  800e6a:	83 ec 2c             	sub    $0x2c,%esp
  800e6d:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800e70:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800e73:	50                   	push   %eax
  800e74:	ff 75 08             	pushl  0x8(%ebp)
  800e77:	e8 6f fe ff ff       	call   800ceb <fd_lookup>
  800e7c:	83 c4 08             	add    $0x8,%esp
  800e7f:	85 c0                	test   %eax,%eax
  800e81:	0f 88 c1 00 00 00    	js     800f48 <dup+0xe4>
		return r;
	close(newfdnum);
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	56                   	push   %esi
  800e8b:	e8 84 ff ff ff       	call   800e14 <close>

	newfd = INDEX2FD(newfdnum);
  800e90:	89 f3                	mov    %esi,%ebx
  800e92:	c1 e3 0c             	shl    $0xc,%ebx
  800e95:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800e9b:	83 c4 04             	add    $0x4,%esp
  800e9e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ea1:	e8 de fd ff ff       	call   800c84 <fd2data>
  800ea6:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  800ea8:	89 1c 24             	mov    %ebx,(%esp)
  800eab:	e8 d4 fd ff ff       	call   800c84 <fd2data>
  800eb0:	83 c4 10             	add    $0x10,%esp
  800eb3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800eb6:	89 f8                	mov    %edi,%eax
  800eb8:	c1 e8 16             	shr    $0x16,%eax
  800ebb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800ec2:	a8 01                	test   $0x1,%al
  800ec4:	74 37                	je     800efd <dup+0x99>
  800ec6:	89 f8                	mov    %edi,%eax
  800ec8:	c1 e8 0c             	shr    $0xc,%eax
  800ecb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800ed2:	f6 c2 01             	test   $0x1,%dl
  800ed5:	74 26                	je     800efd <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800ed7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ede:	83 ec 0c             	sub    $0xc,%esp
  800ee1:	25 07 0e 00 00       	and    $0xe07,%eax
  800ee6:	50                   	push   %eax
  800ee7:	ff 75 d4             	pushl  -0x2c(%ebp)
  800eea:	6a 00                	push   $0x0
  800eec:	57                   	push   %edi
  800eed:	6a 00                	push   $0x0
  800eef:	e8 87 fc ff ff       	call   800b7b <sys_page_map>
  800ef4:	89 c7                	mov    %eax,%edi
  800ef6:	83 c4 20             	add    $0x20,%esp
  800ef9:	85 c0                	test   %eax,%eax
  800efb:	78 2e                	js     800f2b <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800efd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f00:	89 d0                	mov    %edx,%eax
  800f02:	c1 e8 0c             	shr    $0xc,%eax
  800f05:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f0c:	83 ec 0c             	sub    $0xc,%esp
  800f0f:	25 07 0e 00 00       	and    $0xe07,%eax
  800f14:	50                   	push   %eax
  800f15:	53                   	push   %ebx
  800f16:	6a 00                	push   $0x0
  800f18:	52                   	push   %edx
  800f19:	6a 00                	push   $0x0
  800f1b:	e8 5b fc ff ff       	call   800b7b <sys_page_map>
  800f20:	89 c7                	mov    %eax,%edi
  800f22:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  800f25:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800f27:	85 ff                	test   %edi,%edi
  800f29:	79 1d                	jns    800f48 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800f2b:	83 ec 08             	sub    $0x8,%esp
  800f2e:	53                   	push   %ebx
  800f2f:	6a 00                	push   $0x0
  800f31:	e8 6b fc ff ff       	call   800ba1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800f36:	83 c4 08             	add    $0x8,%esp
  800f39:	ff 75 d4             	pushl  -0x2c(%ebp)
  800f3c:	6a 00                	push   $0x0
  800f3e:	e8 5e fc ff ff       	call   800ba1 <sys_page_unmap>
	return r;
  800f43:	83 c4 10             	add    $0x10,%esp
  800f46:	89 f8                	mov    %edi,%eax
}
  800f48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4b:	5b                   	pop    %ebx
  800f4c:	5e                   	pop    %esi
  800f4d:	5f                   	pop    %edi
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    

00800f50 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	53                   	push   %ebx
  800f54:	83 ec 14             	sub    $0x14,%esp
  800f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800f5a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800f5d:	50                   	push   %eax
  800f5e:	53                   	push   %ebx
  800f5f:	e8 87 fd ff ff       	call   800ceb <fd_lookup>
  800f64:	83 c4 08             	add    $0x8,%esp
  800f67:	89 c2                	mov    %eax,%edx
  800f69:	85 c0                	test   %eax,%eax
  800f6b:	78 6d                	js     800fda <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800f6d:	83 ec 08             	sub    $0x8,%esp
  800f70:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f73:	50                   	push   %eax
  800f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f77:	ff 30                	pushl  (%eax)
  800f79:	e8 c3 fd ff ff       	call   800d41 <dev_lookup>
  800f7e:	83 c4 10             	add    $0x10,%esp
  800f81:	85 c0                	test   %eax,%eax
  800f83:	78 4c                	js     800fd1 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800f85:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f88:	8b 42 08             	mov    0x8(%edx),%eax
  800f8b:	83 e0 03             	and    $0x3,%eax
  800f8e:	83 f8 01             	cmp    $0x1,%eax
  800f91:	75 21                	jne    800fb4 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800f93:	a1 04 40 80 00       	mov    0x804004,%eax
  800f98:	8b 40 48             	mov    0x48(%eax),%eax
  800f9b:	83 ec 04             	sub    $0x4,%esp
  800f9e:	53                   	push   %ebx
  800f9f:	50                   	push   %eax
  800fa0:	68 6d 21 80 00       	push   $0x80216d
  800fa5:	e8 f2 f1 ff ff       	call   80019c <cprintf>
		return -E_INVAL;
  800faa:	83 c4 10             	add    $0x10,%esp
  800fad:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800fb2:	eb 26                	jmp    800fda <read+0x8a>
	}
	if (!dev->dev_read)
  800fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb7:	8b 40 08             	mov    0x8(%eax),%eax
  800fba:	85 c0                	test   %eax,%eax
  800fbc:	74 17                	je     800fd5 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800fbe:	83 ec 04             	sub    $0x4,%esp
  800fc1:	ff 75 10             	pushl  0x10(%ebp)
  800fc4:	ff 75 0c             	pushl  0xc(%ebp)
  800fc7:	52                   	push   %edx
  800fc8:	ff d0                	call   *%eax
  800fca:	89 c2                	mov    %eax,%edx
  800fcc:	83 c4 10             	add    $0x10,%esp
  800fcf:	eb 09                	jmp    800fda <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800fd1:	89 c2                	mov    %eax,%edx
  800fd3:	eb 05                	jmp    800fda <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800fd5:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  800fda:	89 d0                	mov    %edx,%eax
  800fdc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fdf:	c9                   	leave  
  800fe0:	c3                   	ret    

00800fe1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	57                   	push   %edi
  800fe5:	56                   	push   %esi
  800fe6:	53                   	push   %ebx
  800fe7:	83 ec 0c             	sub    $0xc,%esp
  800fea:	8b 7d 08             	mov    0x8(%ebp),%edi
  800fed:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800ff0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff5:	eb 21                	jmp    801018 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800ff7:	83 ec 04             	sub    $0x4,%esp
  800ffa:	89 f0                	mov    %esi,%eax
  800ffc:	29 d8                	sub    %ebx,%eax
  800ffe:	50                   	push   %eax
  800fff:	89 d8                	mov    %ebx,%eax
  801001:	03 45 0c             	add    0xc(%ebp),%eax
  801004:	50                   	push   %eax
  801005:	57                   	push   %edi
  801006:	e8 45 ff ff ff       	call   800f50 <read>
		if (m < 0)
  80100b:	83 c4 10             	add    $0x10,%esp
  80100e:	85 c0                	test   %eax,%eax
  801010:	78 10                	js     801022 <readn+0x41>
			return m;
		if (m == 0)
  801012:	85 c0                	test   %eax,%eax
  801014:	74 0a                	je     801020 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801016:	01 c3                	add    %eax,%ebx
  801018:	39 f3                	cmp    %esi,%ebx
  80101a:	72 db                	jb     800ff7 <readn+0x16>
  80101c:	89 d8                	mov    %ebx,%eax
  80101e:	eb 02                	jmp    801022 <readn+0x41>
  801020:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801022:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801025:	5b                   	pop    %ebx
  801026:	5e                   	pop    %esi
  801027:	5f                   	pop    %edi
  801028:	5d                   	pop    %ebp
  801029:	c3                   	ret    

0080102a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	53                   	push   %ebx
  80102e:	83 ec 14             	sub    $0x14,%esp
  801031:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801034:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801037:	50                   	push   %eax
  801038:	53                   	push   %ebx
  801039:	e8 ad fc ff ff       	call   800ceb <fd_lookup>
  80103e:	83 c4 08             	add    $0x8,%esp
  801041:	89 c2                	mov    %eax,%edx
  801043:	85 c0                	test   %eax,%eax
  801045:	78 68                	js     8010af <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801047:	83 ec 08             	sub    $0x8,%esp
  80104a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80104d:	50                   	push   %eax
  80104e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801051:	ff 30                	pushl  (%eax)
  801053:	e8 e9 fc ff ff       	call   800d41 <dev_lookup>
  801058:	83 c4 10             	add    $0x10,%esp
  80105b:	85 c0                	test   %eax,%eax
  80105d:	78 47                	js     8010a6 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80105f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801062:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801066:	75 21                	jne    801089 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801068:	a1 04 40 80 00       	mov    0x804004,%eax
  80106d:	8b 40 48             	mov    0x48(%eax),%eax
  801070:	83 ec 04             	sub    $0x4,%esp
  801073:	53                   	push   %ebx
  801074:	50                   	push   %eax
  801075:	68 89 21 80 00       	push   $0x802189
  80107a:	e8 1d f1 ff ff       	call   80019c <cprintf>
		return -E_INVAL;
  80107f:	83 c4 10             	add    $0x10,%esp
  801082:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801087:	eb 26                	jmp    8010af <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801089:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80108c:	8b 52 0c             	mov    0xc(%edx),%edx
  80108f:	85 d2                	test   %edx,%edx
  801091:	74 17                	je     8010aa <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801093:	83 ec 04             	sub    $0x4,%esp
  801096:	ff 75 10             	pushl  0x10(%ebp)
  801099:	ff 75 0c             	pushl  0xc(%ebp)
  80109c:	50                   	push   %eax
  80109d:	ff d2                	call   *%edx
  80109f:	89 c2                	mov    %eax,%edx
  8010a1:	83 c4 10             	add    $0x10,%esp
  8010a4:	eb 09                	jmp    8010af <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010a6:	89 c2                	mov    %eax,%edx
  8010a8:	eb 05                	jmp    8010af <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8010aa:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  8010af:	89 d0                	mov    %edx,%eax
  8010b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010bc:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8010bf:	50                   	push   %eax
  8010c0:	ff 75 08             	pushl  0x8(%ebp)
  8010c3:	e8 23 fc ff ff       	call   800ceb <fd_lookup>
  8010c8:	83 c4 08             	add    $0x8,%esp
  8010cb:	85 c0                	test   %eax,%eax
  8010cd:	78 0e                	js     8010dd <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8010cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8010d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010dd:	c9                   	leave  
  8010de:	c3                   	ret    

008010df <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
  8010e2:	53                   	push   %ebx
  8010e3:	83 ec 14             	sub    $0x14,%esp
  8010e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010ec:	50                   	push   %eax
  8010ed:	53                   	push   %ebx
  8010ee:	e8 f8 fb ff ff       	call   800ceb <fd_lookup>
  8010f3:	83 c4 08             	add    $0x8,%esp
  8010f6:	89 c2                	mov    %eax,%edx
  8010f8:	85 c0                	test   %eax,%eax
  8010fa:	78 65                	js     801161 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010fc:	83 ec 08             	sub    $0x8,%esp
  8010ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801102:	50                   	push   %eax
  801103:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801106:	ff 30                	pushl  (%eax)
  801108:	e8 34 fc ff ff       	call   800d41 <dev_lookup>
  80110d:	83 c4 10             	add    $0x10,%esp
  801110:	85 c0                	test   %eax,%eax
  801112:	78 44                	js     801158 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801114:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801117:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80111b:	75 21                	jne    80113e <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80111d:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801122:	8b 40 48             	mov    0x48(%eax),%eax
  801125:	83 ec 04             	sub    $0x4,%esp
  801128:	53                   	push   %ebx
  801129:	50                   	push   %eax
  80112a:	68 4c 21 80 00       	push   $0x80214c
  80112f:	e8 68 f0 ff ff       	call   80019c <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801134:	83 c4 10             	add    $0x10,%esp
  801137:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80113c:	eb 23                	jmp    801161 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  80113e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801141:	8b 52 18             	mov    0x18(%edx),%edx
  801144:	85 d2                	test   %edx,%edx
  801146:	74 14                	je     80115c <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801148:	83 ec 08             	sub    $0x8,%esp
  80114b:	ff 75 0c             	pushl  0xc(%ebp)
  80114e:	50                   	push   %eax
  80114f:	ff d2                	call   *%edx
  801151:	89 c2                	mov    %eax,%edx
  801153:	83 c4 10             	add    $0x10,%esp
  801156:	eb 09                	jmp    801161 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801158:	89 c2                	mov    %eax,%edx
  80115a:	eb 05                	jmp    801161 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80115c:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  801161:	89 d0                	mov    %edx,%eax
  801163:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801166:	c9                   	leave  
  801167:	c3                   	ret    

00801168 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801168:	55                   	push   %ebp
  801169:	89 e5                	mov    %esp,%ebp
  80116b:	53                   	push   %ebx
  80116c:	83 ec 14             	sub    $0x14,%esp
  80116f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801172:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801175:	50                   	push   %eax
  801176:	ff 75 08             	pushl  0x8(%ebp)
  801179:	e8 6d fb ff ff       	call   800ceb <fd_lookup>
  80117e:	83 c4 08             	add    $0x8,%esp
  801181:	89 c2                	mov    %eax,%edx
  801183:	85 c0                	test   %eax,%eax
  801185:	78 58                	js     8011df <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801187:	83 ec 08             	sub    $0x8,%esp
  80118a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80118d:	50                   	push   %eax
  80118e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801191:	ff 30                	pushl  (%eax)
  801193:	e8 a9 fb ff ff       	call   800d41 <dev_lookup>
  801198:	83 c4 10             	add    $0x10,%esp
  80119b:	85 c0                	test   %eax,%eax
  80119d:	78 37                	js     8011d6 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  80119f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a2:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8011a6:	74 32                	je     8011da <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8011a8:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8011ab:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8011b2:	00 00 00 
	stat->st_isdir = 0;
  8011b5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8011bc:	00 00 00 
	stat->st_dev = dev;
  8011bf:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	53                   	push   %ebx
  8011c9:	ff 75 f0             	pushl  -0x10(%ebp)
  8011cc:	ff 50 14             	call   *0x14(%eax)
  8011cf:	89 c2                	mov    %eax,%edx
  8011d1:	83 c4 10             	add    $0x10,%esp
  8011d4:	eb 09                	jmp    8011df <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011d6:	89 c2                	mov    %eax,%edx
  8011d8:	eb 05                	jmp    8011df <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8011da:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8011df:	89 d0                	mov    %edx,%eax
  8011e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011e4:	c9                   	leave  
  8011e5:	c3                   	ret    

008011e6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	56                   	push   %esi
  8011ea:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8011eb:	83 ec 08             	sub    $0x8,%esp
  8011ee:	6a 00                	push   $0x0
  8011f0:	ff 75 08             	pushl  0x8(%ebp)
  8011f3:	e8 06 02 00 00       	call   8013fe <open>
  8011f8:	89 c3                	mov    %eax,%ebx
  8011fa:	83 c4 10             	add    $0x10,%esp
  8011fd:	85 c0                	test   %eax,%eax
  8011ff:	78 1b                	js     80121c <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801201:	83 ec 08             	sub    $0x8,%esp
  801204:	ff 75 0c             	pushl  0xc(%ebp)
  801207:	50                   	push   %eax
  801208:	e8 5b ff ff ff       	call   801168 <fstat>
  80120d:	89 c6                	mov    %eax,%esi
	close(fd);
  80120f:	89 1c 24             	mov    %ebx,(%esp)
  801212:	e8 fd fb ff ff       	call   800e14 <close>
	return r;
  801217:	83 c4 10             	add    $0x10,%esp
  80121a:	89 f0                	mov    %esi,%eax
}
  80121c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80121f:	5b                   	pop    %ebx
  801220:	5e                   	pop    %esi
  801221:	5d                   	pop    %ebp
  801222:	c3                   	ret    

00801223 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	56                   	push   %esi
  801227:	53                   	push   %ebx
  801228:	89 c6                	mov    %eax,%esi
  80122a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80122c:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801233:	75 12                	jne    801247 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801235:	83 ec 0c             	sub    $0xc,%esp
  801238:	6a 01                	push   $0x1
  80123a:	e8 47 08 00 00       	call   801a86 <ipc_find_env>
  80123f:	a3 00 40 80 00       	mov    %eax,0x804000
  801244:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801247:	6a 07                	push   $0x7
  801249:	68 00 50 80 00       	push   $0x805000
  80124e:	56                   	push   %esi
  80124f:	ff 35 00 40 80 00    	pushl  0x804000
  801255:	e8 d8 07 00 00       	call   801a32 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80125a:	83 c4 0c             	add    $0xc,%esp
  80125d:	6a 00                	push   $0x0
  80125f:	53                   	push   %ebx
  801260:	6a 00                	push   $0x0
  801262:	e8 60 07 00 00       	call   8019c7 <ipc_recv>
}
  801267:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80126a:	5b                   	pop    %ebx
  80126b:	5e                   	pop    %esi
  80126c:	5d                   	pop    %ebp
  80126d:	c3                   	ret    

0080126e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
  801271:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	8b 40 0c             	mov    0xc(%eax),%eax
  80127a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80127f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801282:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801287:	ba 00 00 00 00       	mov    $0x0,%edx
  80128c:	b8 02 00 00 00       	mov    $0x2,%eax
  801291:	e8 8d ff ff ff       	call   801223 <fsipc>
}
  801296:	c9                   	leave  
  801297:	c3                   	ret    

00801298 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801298:	55                   	push   %ebp
  801299:	89 e5                	mov    %esp,%ebp
  80129b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8012a4:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8012a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8012ae:	b8 06 00 00 00       	mov    $0x6,%eax
  8012b3:	e8 6b ff ff ff       	call   801223 <fsipc>
}
  8012b8:	c9                   	leave  
  8012b9:	c3                   	ret    

008012ba <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8012ba:	55                   	push   %ebp
  8012bb:	89 e5                	mov    %esp,%ebp
  8012bd:	53                   	push   %ebx
  8012be:	83 ec 04             	sub    $0x4,%esp
  8012c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8012ca:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8012cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d4:	b8 05 00 00 00       	mov    $0x5,%eax
  8012d9:	e8 45 ff ff ff       	call   801223 <fsipc>
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	78 2c                	js     80130e <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8012e2:	83 ec 08             	sub    $0x8,%esp
  8012e5:	68 00 50 80 00       	push   $0x805000
  8012ea:	53                   	push   %ebx
  8012eb:	e8 1e f4 ff ff       	call   80070e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8012f0:	a1 80 50 80 00       	mov    0x805080,%eax
  8012f5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8012fb:	a1 84 50 80 00       	mov    0x805084,%eax
  801300:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801306:	83 c4 10             	add    $0x10,%esp
  801309:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80130e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801311:	c9                   	leave  
  801312:	c3                   	ret    

00801313 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801313:	55                   	push   %ebp
  801314:	89 e5                	mov    %esp,%ebp
  801316:	83 ec 08             	sub    $0x8,%esp
  801319:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131c:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80131f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801322:	8b 49 0c             	mov    0xc(%ecx),%ecx
  801325:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  80132b:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801330:	76 22                	jbe    801354 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  801332:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  801339:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  80133c:	83 ec 04             	sub    $0x4,%esp
  80133f:	68 f8 0f 00 00       	push   $0xff8
  801344:	52                   	push   %edx
  801345:	68 08 50 80 00       	push   $0x805008
  80134a:	e8 52 f5 ff ff       	call   8008a1 <memmove>
  80134f:	83 c4 10             	add    $0x10,%esp
  801352:	eb 17                	jmp    80136b <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  801354:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  801359:	83 ec 04             	sub    $0x4,%esp
  80135c:	50                   	push   %eax
  80135d:	52                   	push   %edx
  80135e:	68 08 50 80 00       	push   $0x805008
  801363:	e8 39 f5 ff ff       	call   8008a1 <memmove>
  801368:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  80136b:	ba 00 00 00 00       	mov    $0x0,%edx
  801370:	b8 04 00 00 00       	mov    $0x4,%eax
  801375:	e8 a9 fe ff ff       	call   801223 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    

0080137c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	56                   	push   %esi
  801380:	53                   	push   %ebx
  801381:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
  801387:	8b 40 0c             	mov    0xc(%eax),%eax
  80138a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80138f:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801395:	ba 00 00 00 00       	mov    $0x0,%edx
  80139a:	b8 03 00 00 00       	mov    $0x3,%eax
  80139f:	e8 7f fe ff ff       	call   801223 <fsipc>
  8013a4:	89 c3                	mov    %eax,%ebx
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	78 4b                	js     8013f5 <devfile_read+0x79>
		return r;
	assert(r <= n);
  8013aa:	39 c6                	cmp    %eax,%esi
  8013ac:	73 16                	jae    8013c4 <devfile_read+0x48>
  8013ae:	68 b8 21 80 00       	push   $0x8021b8
  8013b3:	68 bf 21 80 00       	push   $0x8021bf
  8013b8:	6a 7c                	push   $0x7c
  8013ba:	68 d4 21 80 00       	push   $0x8021d4
  8013bf:	e8 bd 05 00 00       	call   801981 <_panic>
	assert(r <= PGSIZE);
  8013c4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8013c9:	7e 16                	jle    8013e1 <devfile_read+0x65>
  8013cb:	68 df 21 80 00       	push   $0x8021df
  8013d0:	68 bf 21 80 00       	push   $0x8021bf
  8013d5:	6a 7d                	push   $0x7d
  8013d7:	68 d4 21 80 00       	push   $0x8021d4
  8013dc:	e8 a0 05 00 00       	call   801981 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8013e1:	83 ec 04             	sub    $0x4,%esp
  8013e4:	50                   	push   %eax
  8013e5:	68 00 50 80 00       	push   $0x805000
  8013ea:	ff 75 0c             	pushl  0xc(%ebp)
  8013ed:	e8 af f4 ff ff       	call   8008a1 <memmove>
	return r;
  8013f2:	83 c4 10             	add    $0x10,%esp
}
  8013f5:	89 d8                	mov    %ebx,%eax
  8013f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013fa:	5b                   	pop    %ebx
  8013fb:	5e                   	pop    %esi
  8013fc:	5d                   	pop    %ebp
  8013fd:	c3                   	ret    

008013fe <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	53                   	push   %ebx
  801402:	83 ec 20             	sub    $0x20,%esp
  801405:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801408:	53                   	push   %ebx
  801409:	e8 c7 f2 ff ff       	call   8006d5 <strlen>
  80140e:	83 c4 10             	add    $0x10,%esp
  801411:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801416:	7f 67                	jg     80147f <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801418:	83 ec 0c             	sub    $0xc,%esp
  80141b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80141e:	50                   	push   %eax
  80141f:	e8 78 f8 ff ff       	call   800c9c <fd_alloc>
  801424:	83 c4 10             	add    $0x10,%esp
		return r;
  801427:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801429:	85 c0                	test   %eax,%eax
  80142b:	78 57                	js     801484 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80142d:	83 ec 08             	sub    $0x8,%esp
  801430:	53                   	push   %ebx
  801431:	68 00 50 80 00       	push   $0x805000
  801436:	e8 d3 f2 ff ff       	call   80070e <strcpy>
	fsipcbuf.open.req_omode = mode;
  80143b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143e:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801443:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801446:	b8 01 00 00 00       	mov    $0x1,%eax
  80144b:	e8 d3 fd ff ff       	call   801223 <fsipc>
  801450:	89 c3                	mov    %eax,%ebx
  801452:	83 c4 10             	add    $0x10,%esp
  801455:	85 c0                	test   %eax,%eax
  801457:	79 14                	jns    80146d <open+0x6f>
		fd_close(fd, 0);
  801459:	83 ec 08             	sub    $0x8,%esp
  80145c:	6a 00                	push   $0x0
  80145e:	ff 75 f4             	pushl  -0xc(%ebp)
  801461:	e8 2e f9 ff ff       	call   800d94 <fd_close>
		return r;
  801466:	83 c4 10             	add    $0x10,%esp
  801469:	89 da                	mov    %ebx,%edx
  80146b:	eb 17                	jmp    801484 <open+0x86>
	}

	return fd2num(fd);
  80146d:	83 ec 0c             	sub    $0xc,%esp
  801470:	ff 75 f4             	pushl  -0xc(%ebp)
  801473:	e8 fc f7 ff ff       	call   800c74 <fd2num>
  801478:	89 c2                	mov    %eax,%edx
  80147a:	83 c4 10             	add    $0x10,%esp
  80147d:	eb 05                	jmp    801484 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80147f:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801484:	89 d0                	mov    %edx,%eax
  801486:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801489:	c9                   	leave  
  80148a:	c3                   	ret    

0080148b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
  80148e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801491:	ba 00 00 00 00       	mov    $0x0,%edx
  801496:	b8 08 00 00 00       	mov    $0x8,%eax
  80149b:	e8 83 fd ff ff       	call   801223 <fsipc>
}
  8014a0:	c9                   	leave  
  8014a1:	c3                   	ret    

008014a2 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	56                   	push   %esi
  8014a6:	53                   	push   %ebx
  8014a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8014aa:	83 ec 0c             	sub    $0xc,%esp
  8014ad:	ff 75 08             	pushl  0x8(%ebp)
  8014b0:	e8 cf f7 ff ff       	call   800c84 <fd2data>
  8014b5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8014b7:	83 c4 08             	add    $0x8,%esp
  8014ba:	68 eb 21 80 00       	push   $0x8021eb
  8014bf:	53                   	push   %ebx
  8014c0:	e8 49 f2 ff ff       	call   80070e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8014c5:	8b 46 04             	mov    0x4(%esi),%eax
  8014c8:	2b 06                	sub    (%esi),%eax
  8014ca:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8014d0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014d7:	00 00 00 
	stat->st_dev = &devpipe;
  8014da:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8014e1:	30 80 00 
	return 0;
}
  8014e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014ec:	5b                   	pop    %ebx
  8014ed:	5e                   	pop    %esi
  8014ee:	5d                   	pop    %ebp
  8014ef:	c3                   	ret    

008014f0 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	53                   	push   %ebx
  8014f4:	83 ec 0c             	sub    $0xc,%esp
  8014f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8014fa:	53                   	push   %ebx
  8014fb:	6a 00                	push   $0x0
  8014fd:	e8 9f f6 ff ff       	call   800ba1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801502:	89 1c 24             	mov    %ebx,(%esp)
  801505:	e8 7a f7 ff ff       	call   800c84 <fd2data>
  80150a:	83 c4 08             	add    $0x8,%esp
  80150d:	50                   	push   %eax
  80150e:	6a 00                	push   $0x0
  801510:	e8 8c f6 ff ff       	call   800ba1 <sys_page_unmap>
}
  801515:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801518:	c9                   	leave  
  801519:	c3                   	ret    

0080151a <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	57                   	push   %edi
  80151e:	56                   	push   %esi
  80151f:	53                   	push   %ebx
  801520:	83 ec 1c             	sub    $0x1c,%esp
  801523:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801526:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801528:	a1 04 40 80 00       	mov    0x804004,%eax
  80152d:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801530:	83 ec 0c             	sub    $0xc,%esp
  801533:	ff 75 e0             	pushl  -0x20(%ebp)
  801536:	e8 84 05 00 00       	call   801abf <pageref>
  80153b:	89 c3                	mov    %eax,%ebx
  80153d:	89 3c 24             	mov    %edi,(%esp)
  801540:	e8 7a 05 00 00       	call   801abf <pageref>
  801545:	83 c4 10             	add    $0x10,%esp
  801548:	39 c3                	cmp    %eax,%ebx
  80154a:	0f 94 c1             	sete   %cl
  80154d:	0f b6 c9             	movzbl %cl,%ecx
  801550:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801553:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801559:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80155c:	39 ce                	cmp    %ecx,%esi
  80155e:	74 1b                	je     80157b <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801560:	39 c3                	cmp    %eax,%ebx
  801562:	75 c4                	jne    801528 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801564:	8b 42 58             	mov    0x58(%edx),%eax
  801567:	ff 75 e4             	pushl  -0x1c(%ebp)
  80156a:	50                   	push   %eax
  80156b:	56                   	push   %esi
  80156c:	68 f2 21 80 00       	push   $0x8021f2
  801571:	e8 26 ec ff ff       	call   80019c <cprintf>
  801576:	83 c4 10             	add    $0x10,%esp
  801579:	eb ad                	jmp    801528 <_pipeisclosed+0xe>
	}
}
  80157b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80157e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801581:	5b                   	pop    %ebx
  801582:	5e                   	pop    %esi
  801583:	5f                   	pop    %edi
  801584:	5d                   	pop    %ebp
  801585:	c3                   	ret    

00801586 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	57                   	push   %edi
  80158a:	56                   	push   %esi
  80158b:	53                   	push   %ebx
  80158c:	83 ec 28             	sub    $0x28,%esp
  80158f:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801592:	56                   	push   %esi
  801593:	e8 ec f6 ff ff       	call   800c84 <fd2data>
  801598:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80159a:	83 c4 10             	add    $0x10,%esp
  80159d:	bf 00 00 00 00       	mov    $0x0,%edi
  8015a2:	eb 4b                	jmp    8015ef <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8015a4:	89 da                	mov    %ebx,%edx
  8015a6:	89 f0                	mov    %esi,%eax
  8015a8:	e8 6d ff ff ff       	call   80151a <_pipeisclosed>
  8015ad:	85 c0                	test   %eax,%eax
  8015af:	75 48                	jne    8015f9 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8015b1:	e8 7a f5 ff ff       	call   800b30 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8015b6:	8b 43 04             	mov    0x4(%ebx),%eax
  8015b9:	8b 0b                	mov    (%ebx),%ecx
  8015bb:	8d 51 20             	lea    0x20(%ecx),%edx
  8015be:	39 d0                	cmp    %edx,%eax
  8015c0:	73 e2                	jae    8015a4 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8015c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015c5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8015c9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8015cc:	89 c2                	mov    %eax,%edx
  8015ce:	c1 fa 1f             	sar    $0x1f,%edx
  8015d1:	89 d1                	mov    %edx,%ecx
  8015d3:	c1 e9 1b             	shr    $0x1b,%ecx
  8015d6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8015d9:	83 e2 1f             	and    $0x1f,%edx
  8015dc:	29 ca                	sub    %ecx,%edx
  8015de:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8015e2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8015e6:	83 c0 01             	add    $0x1,%eax
  8015e9:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8015ec:	83 c7 01             	add    $0x1,%edi
  8015ef:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8015f2:	75 c2                	jne    8015b6 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8015f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f7:	eb 05                	jmp    8015fe <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8015f9:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8015fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801601:	5b                   	pop    %ebx
  801602:	5e                   	pop    %esi
  801603:	5f                   	pop    %edi
  801604:	5d                   	pop    %ebp
  801605:	c3                   	ret    

00801606 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	57                   	push   %edi
  80160a:	56                   	push   %esi
  80160b:	53                   	push   %ebx
  80160c:	83 ec 18             	sub    $0x18,%esp
  80160f:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801612:	57                   	push   %edi
  801613:	e8 6c f6 ff ff       	call   800c84 <fd2data>
  801618:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80161a:	83 c4 10             	add    $0x10,%esp
  80161d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801622:	eb 3d                	jmp    801661 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801624:	85 db                	test   %ebx,%ebx
  801626:	74 04                	je     80162c <devpipe_read+0x26>
				return i;
  801628:	89 d8                	mov    %ebx,%eax
  80162a:	eb 44                	jmp    801670 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80162c:	89 f2                	mov    %esi,%edx
  80162e:	89 f8                	mov    %edi,%eax
  801630:	e8 e5 fe ff ff       	call   80151a <_pipeisclosed>
  801635:	85 c0                	test   %eax,%eax
  801637:	75 32                	jne    80166b <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801639:	e8 f2 f4 ff ff       	call   800b30 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80163e:	8b 06                	mov    (%esi),%eax
  801640:	3b 46 04             	cmp    0x4(%esi),%eax
  801643:	74 df                	je     801624 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801645:	99                   	cltd   
  801646:	c1 ea 1b             	shr    $0x1b,%edx
  801649:	01 d0                	add    %edx,%eax
  80164b:	83 e0 1f             	and    $0x1f,%eax
  80164e:	29 d0                	sub    %edx,%eax
  801650:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801655:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801658:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  80165b:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80165e:	83 c3 01             	add    $0x1,%ebx
  801661:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801664:	75 d8                	jne    80163e <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801666:	8b 45 10             	mov    0x10(%ebp),%eax
  801669:	eb 05                	jmp    801670 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80166b:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801670:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801673:	5b                   	pop    %ebx
  801674:	5e                   	pop    %esi
  801675:	5f                   	pop    %edi
  801676:	5d                   	pop    %ebp
  801677:	c3                   	ret    

00801678 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	56                   	push   %esi
  80167c:	53                   	push   %ebx
  80167d:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801680:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801683:	50                   	push   %eax
  801684:	e8 13 f6 ff ff       	call   800c9c <fd_alloc>
  801689:	83 c4 10             	add    $0x10,%esp
  80168c:	89 c2                	mov    %eax,%edx
  80168e:	85 c0                	test   %eax,%eax
  801690:	0f 88 2c 01 00 00    	js     8017c2 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801696:	83 ec 04             	sub    $0x4,%esp
  801699:	68 07 04 00 00       	push   $0x407
  80169e:	ff 75 f4             	pushl  -0xc(%ebp)
  8016a1:	6a 00                	push   $0x0
  8016a3:	e8 af f4 ff ff       	call   800b57 <sys_page_alloc>
  8016a8:	83 c4 10             	add    $0x10,%esp
  8016ab:	89 c2                	mov    %eax,%edx
  8016ad:	85 c0                	test   %eax,%eax
  8016af:	0f 88 0d 01 00 00    	js     8017c2 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8016b5:	83 ec 0c             	sub    $0xc,%esp
  8016b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016bb:	50                   	push   %eax
  8016bc:	e8 db f5 ff ff       	call   800c9c <fd_alloc>
  8016c1:	89 c3                	mov    %eax,%ebx
  8016c3:	83 c4 10             	add    $0x10,%esp
  8016c6:	85 c0                	test   %eax,%eax
  8016c8:	0f 88 e2 00 00 00    	js     8017b0 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8016ce:	83 ec 04             	sub    $0x4,%esp
  8016d1:	68 07 04 00 00       	push   $0x407
  8016d6:	ff 75 f0             	pushl  -0x10(%ebp)
  8016d9:	6a 00                	push   $0x0
  8016db:	e8 77 f4 ff ff       	call   800b57 <sys_page_alloc>
  8016e0:	89 c3                	mov    %eax,%ebx
  8016e2:	83 c4 10             	add    $0x10,%esp
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	0f 88 c3 00 00 00    	js     8017b0 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8016ed:	83 ec 0c             	sub    $0xc,%esp
  8016f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8016f3:	e8 8c f5 ff ff       	call   800c84 <fd2data>
  8016f8:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8016fa:	83 c4 0c             	add    $0xc,%esp
  8016fd:	68 07 04 00 00       	push   $0x407
  801702:	50                   	push   %eax
  801703:	6a 00                	push   $0x0
  801705:	e8 4d f4 ff ff       	call   800b57 <sys_page_alloc>
  80170a:	89 c3                	mov    %eax,%ebx
  80170c:	83 c4 10             	add    $0x10,%esp
  80170f:	85 c0                	test   %eax,%eax
  801711:	0f 88 89 00 00 00    	js     8017a0 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801717:	83 ec 0c             	sub    $0xc,%esp
  80171a:	ff 75 f0             	pushl  -0x10(%ebp)
  80171d:	e8 62 f5 ff ff       	call   800c84 <fd2data>
  801722:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801729:	50                   	push   %eax
  80172a:	6a 00                	push   $0x0
  80172c:	56                   	push   %esi
  80172d:	6a 00                	push   $0x0
  80172f:	e8 47 f4 ff ff       	call   800b7b <sys_page_map>
  801734:	89 c3                	mov    %eax,%ebx
  801736:	83 c4 20             	add    $0x20,%esp
  801739:	85 c0                	test   %eax,%eax
  80173b:	78 55                	js     801792 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80173d:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801746:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801752:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801758:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175b:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80175d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801760:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801767:	83 ec 0c             	sub    $0xc,%esp
  80176a:	ff 75 f4             	pushl  -0xc(%ebp)
  80176d:	e8 02 f5 ff ff       	call   800c74 <fd2num>
  801772:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801775:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801777:	83 c4 04             	add    $0x4,%esp
  80177a:	ff 75 f0             	pushl  -0x10(%ebp)
  80177d:	e8 f2 f4 ff ff       	call   800c74 <fd2num>
  801782:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801785:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801788:	83 c4 10             	add    $0x10,%esp
  80178b:	ba 00 00 00 00       	mov    $0x0,%edx
  801790:	eb 30                	jmp    8017c2 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801792:	83 ec 08             	sub    $0x8,%esp
  801795:	56                   	push   %esi
  801796:	6a 00                	push   $0x0
  801798:	e8 04 f4 ff ff       	call   800ba1 <sys_page_unmap>
  80179d:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  8017a0:	83 ec 08             	sub    $0x8,%esp
  8017a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8017a6:	6a 00                	push   $0x0
  8017a8:	e8 f4 f3 ff ff       	call   800ba1 <sys_page_unmap>
  8017ad:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  8017b0:	83 ec 08             	sub    $0x8,%esp
  8017b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8017b6:	6a 00                	push   $0x0
  8017b8:	e8 e4 f3 ff ff       	call   800ba1 <sys_page_unmap>
  8017bd:	83 c4 10             	add    $0x10,%esp
  8017c0:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  8017c2:	89 d0                	mov    %edx,%eax
  8017c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c7:	5b                   	pop    %ebx
  8017c8:	5e                   	pop    %esi
  8017c9:	5d                   	pop    %ebp
  8017ca:	c3                   	ret    

008017cb <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d4:	50                   	push   %eax
  8017d5:	ff 75 08             	pushl  0x8(%ebp)
  8017d8:	e8 0e f5 ff ff       	call   800ceb <fd_lookup>
  8017dd:	83 c4 10             	add    $0x10,%esp
  8017e0:	85 c0                	test   %eax,%eax
  8017e2:	78 18                	js     8017fc <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8017e4:	83 ec 0c             	sub    $0xc,%esp
  8017e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ea:	e8 95 f4 ff ff       	call   800c84 <fd2data>
	return _pipeisclosed(fd, p);
  8017ef:	89 c2                	mov    %eax,%edx
  8017f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f4:	e8 21 fd ff ff       	call   80151a <_pipeisclosed>
  8017f9:	83 c4 10             	add    $0x10,%esp
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801801:	b8 00 00 00 00       	mov    $0x0,%eax
  801806:	5d                   	pop    %ebp
  801807:	c3                   	ret    

00801808 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80180e:	68 0a 22 80 00       	push   $0x80220a
  801813:	ff 75 0c             	pushl  0xc(%ebp)
  801816:	e8 f3 ee ff ff       	call   80070e <strcpy>
	return 0;
}
  80181b:	b8 00 00 00 00       	mov    $0x0,%eax
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	57                   	push   %edi
  801826:	56                   	push   %esi
  801827:	53                   	push   %ebx
  801828:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80182e:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801833:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801839:	eb 2d                	jmp    801868 <devcons_write+0x46>
		m = n - tot;
  80183b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80183e:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801840:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801843:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801848:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80184b:	83 ec 04             	sub    $0x4,%esp
  80184e:	53                   	push   %ebx
  80184f:	03 45 0c             	add    0xc(%ebp),%eax
  801852:	50                   	push   %eax
  801853:	57                   	push   %edi
  801854:	e8 48 f0 ff ff       	call   8008a1 <memmove>
		sys_cputs(buf, m);
  801859:	83 c4 08             	add    $0x8,%esp
  80185c:	53                   	push   %ebx
  80185d:	57                   	push   %edi
  80185e:	e8 3d f2 ff ff       	call   800aa0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801863:	01 de                	add    %ebx,%esi
  801865:	83 c4 10             	add    $0x10,%esp
  801868:	89 f0                	mov    %esi,%eax
  80186a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80186d:	72 cc                	jb     80183b <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80186f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801872:	5b                   	pop    %ebx
  801873:	5e                   	pop    %esi
  801874:	5f                   	pop    %edi
  801875:	5d                   	pop    %ebp
  801876:	c3                   	ret    

00801877 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	83 ec 08             	sub    $0x8,%esp
  80187d:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801882:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801886:	74 2a                	je     8018b2 <devcons_read+0x3b>
  801888:	eb 05                	jmp    80188f <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80188a:	e8 a1 f2 ff ff       	call   800b30 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80188f:	e8 32 f2 ff ff       	call   800ac6 <sys_cgetc>
  801894:	85 c0                	test   %eax,%eax
  801896:	74 f2                	je     80188a <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801898:	85 c0                	test   %eax,%eax
  80189a:	78 16                	js     8018b2 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80189c:	83 f8 04             	cmp    $0x4,%eax
  80189f:	74 0c                	je     8018ad <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8018a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a4:	88 02                	mov    %al,(%edx)
	return 1;
  8018a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ab:	eb 05                	jmp    8018b2 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8018ad:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8018c0:	6a 01                	push   $0x1
  8018c2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8018c5:	50                   	push   %eax
  8018c6:	e8 d5 f1 ff ff       	call   800aa0 <sys_cputs>
}
  8018cb:	83 c4 10             	add    $0x10,%esp
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <getchar>:

int
getchar(void)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8018d6:	6a 01                	push   $0x1
  8018d8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8018db:	50                   	push   %eax
  8018dc:	6a 00                	push   $0x0
  8018de:	e8 6d f6 ff ff       	call   800f50 <read>
	if (r < 0)
  8018e3:	83 c4 10             	add    $0x10,%esp
  8018e6:	85 c0                	test   %eax,%eax
  8018e8:	78 0f                	js     8018f9 <getchar+0x29>
		return r;
	if (r < 1)
  8018ea:	85 c0                	test   %eax,%eax
  8018ec:	7e 06                	jle    8018f4 <getchar+0x24>
		return -E_EOF;
	return c;
  8018ee:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8018f2:	eb 05                	jmp    8018f9 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8018f4:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801901:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801904:	50                   	push   %eax
  801905:	ff 75 08             	pushl  0x8(%ebp)
  801908:	e8 de f3 ff ff       	call   800ceb <fd_lookup>
  80190d:	83 c4 10             	add    $0x10,%esp
  801910:	85 c0                	test   %eax,%eax
  801912:	78 11                	js     801925 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801917:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80191d:	39 10                	cmp    %edx,(%eax)
  80191f:	0f 94 c0             	sete   %al
  801922:	0f b6 c0             	movzbl %al,%eax
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <opencons>:

int
opencons(void)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
  80192a:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80192d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801930:	50                   	push   %eax
  801931:	e8 66 f3 ff ff       	call   800c9c <fd_alloc>
  801936:	83 c4 10             	add    $0x10,%esp
		return r;
  801939:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80193b:	85 c0                	test   %eax,%eax
  80193d:	78 3e                	js     80197d <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80193f:	83 ec 04             	sub    $0x4,%esp
  801942:	68 07 04 00 00       	push   $0x407
  801947:	ff 75 f4             	pushl  -0xc(%ebp)
  80194a:	6a 00                	push   $0x0
  80194c:	e8 06 f2 ff ff       	call   800b57 <sys_page_alloc>
  801951:	83 c4 10             	add    $0x10,%esp
		return r;
  801954:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801956:	85 c0                	test   %eax,%eax
  801958:	78 23                	js     80197d <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80195a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801963:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801968:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80196f:	83 ec 0c             	sub    $0xc,%esp
  801972:	50                   	push   %eax
  801973:	e8 fc f2 ff ff       	call   800c74 <fd2num>
  801978:	89 c2                	mov    %eax,%edx
  80197a:	83 c4 10             	add    $0x10,%esp
}
  80197d:	89 d0                	mov    %edx,%eax
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
  801984:	56                   	push   %esi
  801985:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801986:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801989:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80198f:	e8 78 f1 ff ff       	call   800b0c <sys_getenvid>
  801994:	83 ec 0c             	sub    $0xc,%esp
  801997:	ff 75 0c             	pushl  0xc(%ebp)
  80199a:	ff 75 08             	pushl  0x8(%ebp)
  80199d:	56                   	push   %esi
  80199e:	50                   	push   %eax
  80199f:	68 18 22 80 00       	push   $0x802218
  8019a4:	e8 f3 e7 ff ff       	call   80019c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8019a9:	83 c4 18             	add    $0x18,%esp
  8019ac:	53                   	push   %ebx
  8019ad:	ff 75 10             	pushl  0x10(%ebp)
  8019b0:	e8 96 e7 ff ff       	call   80014b <vcprintf>
	cprintf("\n");
  8019b5:	c7 04 24 03 22 80 00 	movl   $0x802203,(%esp)
  8019bc:	e8 db e7 ff ff       	call   80019c <cprintf>
  8019c1:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8019c4:	cc                   	int3   
  8019c5:	eb fd                	jmp    8019c4 <_panic+0x43>

008019c7 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
  8019ca:	56                   	push   %esi
  8019cb:	53                   	push   %ebx
  8019cc:	8b 75 08             	mov    0x8(%ebp),%esi
  8019cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  8019d5:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  8019d7:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8019dc:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  8019df:	83 ec 0c             	sub    $0xc,%esp
  8019e2:	50                   	push   %eax
  8019e3:	e8 6a f2 ff ff       	call   800c52 <sys_ipc_recv>
	if (from_env_store)
  8019e8:	83 c4 10             	add    $0x10,%esp
  8019eb:	85 f6                	test   %esi,%esi
  8019ed:	74 0b                	je     8019fa <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  8019ef:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019f5:	8b 52 74             	mov    0x74(%edx),%edx
  8019f8:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8019fa:	85 db                	test   %ebx,%ebx
  8019fc:	74 0b                	je     801a09 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  8019fe:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a04:	8b 52 78             	mov    0x78(%edx),%edx
  801a07:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  801a09:	85 c0                	test   %eax,%eax
  801a0b:	79 16                	jns    801a23 <ipc_recv+0x5c>
		if (from_env_store)
  801a0d:	85 f6                	test   %esi,%esi
  801a0f:	74 06                	je     801a17 <ipc_recv+0x50>
			*from_env_store = 0;
  801a11:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  801a17:	85 db                	test   %ebx,%ebx
  801a19:	74 10                	je     801a2b <ipc_recv+0x64>
			*perm_store = 0;
  801a1b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801a21:	eb 08                	jmp    801a2b <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  801a23:	a1 04 40 80 00       	mov    0x804004,%eax
  801a28:	8b 40 70             	mov    0x70(%eax),%eax
}
  801a2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a2e:	5b                   	pop    %ebx
  801a2f:	5e                   	pop    %esi
  801a30:	5d                   	pop    %ebp
  801a31:	c3                   	ret    

00801a32 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
  801a35:	57                   	push   %edi
  801a36:	56                   	push   %esi
  801a37:	53                   	push   %ebx
  801a38:	83 ec 0c             	sub    $0xc,%esp
  801a3b:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a3e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a41:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  801a44:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  801a46:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801a4b:	0f 44 d8             	cmove  %eax,%ebx
  801a4e:	eb 1c                	jmp    801a6c <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  801a50:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801a53:	74 12                	je     801a67 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801a55:	50                   	push   %eax
  801a56:	68 3c 22 80 00       	push   $0x80223c
  801a5b:	6a 42                	push   $0x42
  801a5d:	68 52 22 80 00       	push   $0x802252
  801a62:	e8 1a ff ff ff       	call   801981 <_panic>
		sys_yield();
  801a67:	e8 c4 f0 ff ff       	call   800b30 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801a6c:	ff 75 14             	pushl  0x14(%ebp)
  801a6f:	53                   	push   %ebx
  801a70:	56                   	push   %esi
  801a71:	57                   	push   %edi
  801a72:	e8 b6 f1 ff ff       	call   800c2d <sys_ipc_try_send>
  801a77:	83 c4 10             	add    $0x10,%esp
  801a7a:	85 c0                	test   %eax,%eax
  801a7c:	75 d2                	jne    801a50 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801a7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a81:	5b                   	pop    %ebx
  801a82:	5e                   	pop    %esi
  801a83:	5f                   	pop    %edi
  801a84:	5d                   	pop    %ebp
  801a85:	c3                   	ret    

00801a86 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801a8c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801a91:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801a94:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801a9a:	8b 52 50             	mov    0x50(%edx),%edx
  801a9d:	39 ca                	cmp    %ecx,%edx
  801a9f:	75 0d                	jne    801aae <ipc_find_env+0x28>
			return envs[i].env_id;
  801aa1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801aa4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801aa9:	8b 40 48             	mov    0x48(%eax),%eax
  801aac:	eb 0f                	jmp    801abd <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801aae:	83 c0 01             	add    $0x1,%eax
  801ab1:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ab6:	75 d9                	jne    801a91 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801ab8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801abd:	5d                   	pop    %ebp
  801abe:	c3                   	ret    

00801abf <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ac5:	89 d0                	mov    %edx,%eax
  801ac7:	c1 e8 16             	shr    $0x16,%eax
  801aca:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ad1:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ad6:	f6 c1 01             	test   $0x1,%cl
  801ad9:	74 1d                	je     801af8 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801adb:	c1 ea 0c             	shr    $0xc,%edx
  801ade:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801ae5:	f6 c2 01             	test   $0x1,%dl
  801ae8:	74 0e                	je     801af8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801aea:	c1 ea 0c             	shr    $0xc,%edx
  801aed:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801af4:	ef 
  801af5:	0f b7 c0             	movzwl %ax,%eax
}
  801af8:	5d                   	pop    %ebp
  801af9:	c3                   	ret    
  801afa:	66 90                	xchg   %ax,%ax
  801afc:	66 90                	xchg   %ax,%ax
  801afe:	66 90                	xchg   %ax,%ax

00801b00 <__udivdi3>:
  801b00:	55                   	push   %ebp
  801b01:	57                   	push   %edi
  801b02:	56                   	push   %esi
  801b03:	53                   	push   %ebx
  801b04:	83 ec 1c             	sub    $0x1c,%esp
  801b07:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b0b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b0f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b17:	85 f6                	test   %esi,%esi
  801b19:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b1d:	89 ca                	mov    %ecx,%edx
  801b1f:	89 f8                	mov    %edi,%eax
  801b21:	75 3d                	jne    801b60 <__udivdi3+0x60>
  801b23:	39 cf                	cmp    %ecx,%edi
  801b25:	0f 87 c5 00 00 00    	ja     801bf0 <__udivdi3+0xf0>
  801b2b:	85 ff                	test   %edi,%edi
  801b2d:	89 fd                	mov    %edi,%ebp
  801b2f:	75 0b                	jne    801b3c <__udivdi3+0x3c>
  801b31:	b8 01 00 00 00       	mov    $0x1,%eax
  801b36:	31 d2                	xor    %edx,%edx
  801b38:	f7 f7                	div    %edi
  801b3a:	89 c5                	mov    %eax,%ebp
  801b3c:	89 c8                	mov    %ecx,%eax
  801b3e:	31 d2                	xor    %edx,%edx
  801b40:	f7 f5                	div    %ebp
  801b42:	89 c1                	mov    %eax,%ecx
  801b44:	89 d8                	mov    %ebx,%eax
  801b46:	89 cf                	mov    %ecx,%edi
  801b48:	f7 f5                	div    %ebp
  801b4a:	89 c3                	mov    %eax,%ebx
  801b4c:	89 d8                	mov    %ebx,%eax
  801b4e:	89 fa                	mov    %edi,%edx
  801b50:	83 c4 1c             	add    $0x1c,%esp
  801b53:	5b                   	pop    %ebx
  801b54:	5e                   	pop    %esi
  801b55:	5f                   	pop    %edi
  801b56:	5d                   	pop    %ebp
  801b57:	c3                   	ret    
  801b58:	90                   	nop
  801b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801b60:	39 ce                	cmp    %ecx,%esi
  801b62:	77 74                	ja     801bd8 <__udivdi3+0xd8>
  801b64:	0f bd fe             	bsr    %esi,%edi
  801b67:	83 f7 1f             	xor    $0x1f,%edi
  801b6a:	0f 84 98 00 00 00    	je     801c08 <__udivdi3+0x108>
  801b70:	bb 20 00 00 00       	mov    $0x20,%ebx
  801b75:	89 f9                	mov    %edi,%ecx
  801b77:	89 c5                	mov    %eax,%ebp
  801b79:	29 fb                	sub    %edi,%ebx
  801b7b:	d3 e6                	shl    %cl,%esi
  801b7d:	89 d9                	mov    %ebx,%ecx
  801b7f:	d3 ed                	shr    %cl,%ebp
  801b81:	89 f9                	mov    %edi,%ecx
  801b83:	d3 e0                	shl    %cl,%eax
  801b85:	09 ee                	or     %ebp,%esi
  801b87:	89 d9                	mov    %ebx,%ecx
  801b89:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b8d:	89 d5                	mov    %edx,%ebp
  801b8f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b93:	d3 ed                	shr    %cl,%ebp
  801b95:	89 f9                	mov    %edi,%ecx
  801b97:	d3 e2                	shl    %cl,%edx
  801b99:	89 d9                	mov    %ebx,%ecx
  801b9b:	d3 e8                	shr    %cl,%eax
  801b9d:	09 c2                	or     %eax,%edx
  801b9f:	89 d0                	mov    %edx,%eax
  801ba1:	89 ea                	mov    %ebp,%edx
  801ba3:	f7 f6                	div    %esi
  801ba5:	89 d5                	mov    %edx,%ebp
  801ba7:	89 c3                	mov    %eax,%ebx
  801ba9:	f7 64 24 0c          	mull   0xc(%esp)
  801bad:	39 d5                	cmp    %edx,%ebp
  801baf:	72 10                	jb     801bc1 <__udivdi3+0xc1>
  801bb1:	8b 74 24 08          	mov    0x8(%esp),%esi
  801bb5:	89 f9                	mov    %edi,%ecx
  801bb7:	d3 e6                	shl    %cl,%esi
  801bb9:	39 c6                	cmp    %eax,%esi
  801bbb:	73 07                	jae    801bc4 <__udivdi3+0xc4>
  801bbd:	39 d5                	cmp    %edx,%ebp
  801bbf:	75 03                	jne    801bc4 <__udivdi3+0xc4>
  801bc1:	83 eb 01             	sub    $0x1,%ebx
  801bc4:	31 ff                	xor    %edi,%edi
  801bc6:	89 d8                	mov    %ebx,%eax
  801bc8:	89 fa                	mov    %edi,%edx
  801bca:	83 c4 1c             	add    $0x1c,%esp
  801bcd:	5b                   	pop    %ebx
  801bce:	5e                   	pop    %esi
  801bcf:	5f                   	pop    %edi
  801bd0:	5d                   	pop    %ebp
  801bd1:	c3                   	ret    
  801bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801bd8:	31 ff                	xor    %edi,%edi
  801bda:	31 db                	xor    %ebx,%ebx
  801bdc:	89 d8                	mov    %ebx,%eax
  801bde:	89 fa                	mov    %edi,%edx
  801be0:	83 c4 1c             	add    $0x1c,%esp
  801be3:	5b                   	pop    %ebx
  801be4:	5e                   	pop    %esi
  801be5:	5f                   	pop    %edi
  801be6:	5d                   	pop    %ebp
  801be7:	c3                   	ret    
  801be8:	90                   	nop
  801be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801bf0:	89 d8                	mov    %ebx,%eax
  801bf2:	f7 f7                	div    %edi
  801bf4:	31 ff                	xor    %edi,%edi
  801bf6:	89 c3                	mov    %eax,%ebx
  801bf8:	89 d8                	mov    %ebx,%eax
  801bfa:	89 fa                	mov    %edi,%edx
  801bfc:	83 c4 1c             	add    $0x1c,%esp
  801bff:	5b                   	pop    %ebx
  801c00:	5e                   	pop    %esi
  801c01:	5f                   	pop    %edi
  801c02:	5d                   	pop    %ebp
  801c03:	c3                   	ret    
  801c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801c08:	39 ce                	cmp    %ecx,%esi
  801c0a:	72 0c                	jb     801c18 <__udivdi3+0x118>
  801c0c:	31 db                	xor    %ebx,%ebx
  801c0e:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c12:	0f 87 34 ff ff ff    	ja     801b4c <__udivdi3+0x4c>
  801c18:	bb 01 00 00 00       	mov    $0x1,%ebx
  801c1d:	e9 2a ff ff ff       	jmp    801b4c <__udivdi3+0x4c>
  801c22:	66 90                	xchg   %ax,%ax
  801c24:	66 90                	xchg   %ax,%ax
  801c26:	66 90                	xchg   %ax,%ax
  801c28:	66 90                	xchg   %ax,%ax
  801c2a:	66 90                	xchg   %ax,%ax
  801c2c:	66 90                	xchg   %ax,%ax
  801c2e:	66 90                	xchg   %ax,%ax

00801c30 <__umoddi3>:
  801c30:	55                   	push   %ebp
  801c31:	57                   	push   %edi
  801c32:	56                   	push   %esi
  801c33:	53                   	push   %ebx
  801c34:	83 ec 1c             	sub    $0x1c,%esp
  801c37:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801c3b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c3f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c47:	85 d2                	test   %edx,%edx
  801c49:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c51:	89 f3                	mov    %esi,%ebx
  801c53:	89 3c 24             	mov    %edi,(%esp)
  801c56:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c5a:	75 1c                	jne    801c78 <__umoddi3+0x48>
  801c5c:	39 f7                	cmp    %esi,%edi
  801c5e:	76 50                	jbe    801cb0 <__umoddi3+0x80>
  801c60:	89 c8                	mov    %ecx,%eax
  801c62:	89 f2                	mov    %esi,%edx
  801c64:	f7 f7                	div    %edi
  801c66:	89 d0                	mov    %edx,%eax
  801c68:	31 d2                	xor    %edx,%edx
  801c6a:	83 c4 1c             	add    $0x1c,%esp
  801c6d:	5b                   	pop    %ebx
  801c6e:	5e                   	pop    %esi
  801c6f:	5f                   	pop    %edi
  801c70:	5d                   	pop    %ebp
  801c71:	c3                   	ret    
  801c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c78:	39 f2                	cmp    %esi,%edx
  801c7a:	89 d0                	mov    %edx,%eax
  801c7c:	77 52                	ja     801cd0 <__umoddi3+0xa0>
  801c7e:	0f bd ea             	bsr    %edx,%ebp
  801c81:	83 f5 1f             	xor    $0x1f,%ebp
  801c84:	75 5a                	jne    801ce0 <__umoddi3+0xb0>
  801c86:	3b 54 24 04          	cmp    0x4(%esp),%edx
  801c8a:	0f 82 e0 00 00 00    	jb     801d70 <__umoddi3+0x140>
  801c90:	39 0c 24             	cmp    %ecx,(%esp)
  801c93:	0f 86 d7 00 00 00    	jbe    801d70 <__umoddi3+0x140>
  801c99:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c9d:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ca1:	83 c4 1c             	add    $0x1c,%esp
  801ca4:	5b                   	pop    %ebx
  801ca5:	5e                   	pop    %esi
  801ca6:	5f                   	pop    %edi
  801ca7:	5d                   	pop    %ebp
  801ca8:	c3                   	ret    
  801ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801cb0:	85 ff                	test   %edi,%edi
  801cb2:	89 fd                	mov    %edi,%ebp
  801cb4:	75 0b                	jne    801cc1 <__umoddi3+0x91>
  801cb6:	b8 01 00 00 00       	mov    $0x1,%eax
  801cbb:	31 d2                	xor    %edx,%edx
  801cbd:	f7 f7                	div    %edi
  801cbf:	89 c5                	mov    %eax,%ebp
  801cc1:	89 f0                	mov    %esi,%eax
  801cc3:	31 d2                	xor    %edx,%edx
  801cc5:	f7 f5                	div    %ebp
  801cc7:	89 c8                	mov    %ecx,%eax
  801cc9:	f7 f5                	div    %ebp
  801ccb:	89 d0                	mov    %edx,%eax
  801ccd:	eb 99                	jmp    801c68 <__umoddi3+0x38>
  801ccf:	90                   	nop
  801cd0:	89 c8                	mov    %ecx,%eax
  801cd2:	89 f2                	mov    %esi,%edx
  801cd4:	83 c4 1c             	add    $0x1c,%esp
  801cd7:	5b                   	pop    %ebx
  801cd8:	5e                   	pop    %esi
  801cd9:	5f                   	pop    %edi
  801cda:	5d                   	pop    %ebp
  801cdb:	c3                   	ret    
  801cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ce0:	8b 34 24             	mov    (%esp),%esi
  801ce3:	bf 20 00 00 00       	mov    $0x20,%edi
  801ce8:	89 e9                	mov    %ebp,%ecx
  801cea:	29 ef                	sub    %ebp,%edi
  801cec:	d3 e0                	shl    %cl,%eax
  801cee:	89 f9                	mov    %edi,%ecx
  801cf0:	89 f2                	mov    %esi,%edx
  801cf2:	d3 ea                	shr    %cl,%edx
  801cf4:	89 e9                	mov    %ebp,%ecx
  801cf6:	09 c2                	or     %eax,%edx
  801cf8:	89 d8                	mov    %ebx,%eax
  801cfa:	89 14 24             	mov    %edx,(%esp)
  801cfd:	89 f2                	mov    %esi,%edx
  801cff:	d3 e2                	shl    %cl,%edx
  801d01:	89 f9                	mov    %edi,%ecx
  801d03:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d07:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801d0b:	d3 e8                	shr    %cl,%eax
  801d0d:	89 e9                	mov    %ebp,%ecx
  801d0f:	89 c6                	mov    %eax,%esi
  801d11:	d3 e3                	shl    %cl,%ebx
  801d13:	89 f9                	mov    %edi,%ecx
  801d15:	89 d0                	mov    %edx,%eax
  801d17:	d3 e8                	shr    %cl,%eax
  801d19:	89 e9                	mov    %ebp,%ecx
  801d1b:	09 d8                	or     %ebx,%eax
  801d1d:	89 d3                	mov    %edx,%ebx
  801d1f:	89 f2                	mov    %esi,%edx
  801d21:	f7 34 24             	divl   (%esp)
  801d24:	89 d6                	mov    %edx,%esi
  801d26:	d3 e3                	shl    %cl,%ebx
  801d28:	f7 64 24 04          	mull   0x4(%esp)
  801d2c:	39 d6                	cmp    %edx,%esi
  801d2e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d32:	89 d1                	mov    %edx,%ecx
  801d34:	89 c3                	mov    %eax,%ebx
  801d36:	72 08                	jb     801d40 <__umoddi3+0x110>
  801d38:	75 11                	jne    801d4b <__umoddi3+0x11b>
  801d3a:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801d3e:	73 0b                	jae    801d4b <__umoddi3+0x11b>
  801d40:	2b 44 24 04          	sub    0x4(%esp),%eax
  801d44:	1b 14 24             	sbb    (%esp),%edx
  801d47:	89 d1                	mov    %edx,%ecx
  801d49:	89 c3                	mov    %eax,%ebx
  801d4b:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d4f:	29 da                	sub    %ebx,%edx
  801d51:	19 ce                	sbb    %ecx,%esi
  801d53:	89 f9                	mov    %edi,%ecx
  801d55:	89 f0                	mov    %esi,%eax
  801d57:	d3 e0                	shl    %cl,%eax
  801d59:	89 e9                	mov    %ebp,%ecx
  801d5b:	d3 ea                	shr    %cl,%edx
  801d5d:	89 e9                	mov    %ebp,%ecx
  801d5f:	d3 ee                	shr    %cl,%esi
  801d61:	09 d0                	or     %edx,%eax
  801d63:	89 f2                	mov    %esi,%edx
  801d65:	83 c4 1c             	add    $0x1c,%esp
  801d68:	5b                   	pop    %ebx
  801d69:	5e                   	pop    %esi
  801d6a:	5f                   	pop    %edi
  801d6b:	5d                   	pop    %ebp
  801d6c:	c3                   	ret    
  801d6d:	8d 76 00             	lea    0x0(%esi),%esi
  801d70:	29 f9                	sub    %edi,%ecx
  801d72:	19 d6                	sbb    %edx,%esi
  801d74:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d78:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d7c:	e9 18 ff ff ff       	jmp    801c99 <__umoddi3+0x69>
