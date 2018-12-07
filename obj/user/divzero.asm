
obj/user/divzero.debug:     formato del fichero elf32-i386


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
  80002c:	e8 2f 00 00 00       	call   800060 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	zero = 0;
  800039:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  800040:	00 00 00 
	cprintf("1/0 is %08x!\n", 1/zero);
  800043:	b8 01 00 00 00       	mov    $0x1,%eax
  800048:	b9 00 00 00 00       	mov    $0x0,%ecx
  80004d:	99                   	cltd   
  80004e:	f7 f9                	idiv   %ecx
  800050:	50                   	push   %eax
  800051:	68 60 1d 80 00       	push   $0x801d60
  800056:	e8 fc 00 00 00       	call   800157 <cprintf>
}
  80005b:	83 c4 10             	add    $0x10,%esp
  80005e:	c9                   	leave  
  80005f:	c3                   	ret    

00800060 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800060:	55                   	push   %ebp
  800061:	89 e5                	mov    %esp,%ebp
  800063:	56                   	push   %esi
  800064:	53                   	push   %ebx
  800065:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800068:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  80006b:	e8 57 0a 00 00       	call   800ac7 <sys_getenvid>
	if (id >= 0)
  800070:	85 c0                	test   %eax,%eax
  800072:	78 12                	js     800086 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  800074:	25 ff 03 00 00       	and    $0x3ff,%eax
  800079:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80007c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800081:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800086:	85 db                	test   %ebx,%ebx
  800088:	7e 07                	jle    800091 <libmain+0x31>
		binaryname = argv[0];
  80008a:	8b 06                	mov    (%esi),%eax
  80008c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800091:	83 ec 08             	sub    $0x8,%esp
  800094:	56                   	push   %esi
  800095:	53                   	push   %ebx
  800096:	e8 98 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009b:	e8 0a 00 00 00       	call   8000aa <exit>
}
  8000a0:	83 c4 10             	add    $0x10,%esp
  8000a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a6:	5b                   	pop    %ebx
  8000a7:	5e                   	pop    %esi
  8000a8:	5d                   	pop    %ebp
  8000a9:	c3                   	ret    

008000aa <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000aa:	55                   	push   %ebp
  8000ab:	89 e5                	mov    %esp,%ebp
  8000ad:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000b0:	e8 45 0d 00 00       	call   800dfa <close_all>
	sys_env_destroy(0);
  8000b5:	83 ec 0c             	sub    $0xc,%esp
  8000b8:	6a 00                	push   $0x0
  8000ba:	e8 e6 09 00 00       	call   800aa5 <sys_env_destroy>
}
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	c9                   	leave  
  8000c3:	c3                   	ret    

008000c4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000c4:	55                   	push   %ebp
  8000c5:	89 e5                	mov    %esp,%ebp
  8000c7:	53                   	push   %ebx
  8000c8:	83 ec 04             	sub    $0x4,%esp
  8000cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000ce:	8b 13                	mov    (%ebx),%edx
  8000d0:	8d 42 01             	lea    0x1(%edx),%eax
  8000d3:	89 03                	mov    %eax,(%ebx)
  8000d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000d8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000dc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000e1:	75 1a                	jne    8000fd <putch+0x39>
		sys_cputs(b->buf, b->idx);
  8000e3:	83 ec 08             	sub    $0x8,%esp
  8000e6:	68 ff 00 00 00       	push   $0xff
  8000eb:	8d 43 08             	lea    0x8(%ebx),%eax
  8000ee:	50                   	push   %eax
  8000ef:	e8 67 09 00 00       	call   800a5b <sys_cputs>
		b->idx = 0;
  8000f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000fa:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  8000fd:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800101:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800104:	c9                   	leave  
  800105:	c3                   	ret    

00800106 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800106:	55                   	push   %ebp
  800107:	89 e5                	mov    %esp,%ebp
  800109:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80010f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800116:	00 00 00 
	b.cnt = 0;
  800119:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800120:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800123:	ff 75 0c             	pushl  0xc(%ebp)
  800126:	ff 75 08             	pushl  0x8(%ebp)
  800129:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80012f:	50                   	push   %eax
  800130:	68 c4 00 80 00       	push   $0x8000c4
  800135:	e8 86 01 00 00       	call   8002c0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80013a:	83 c4 08             	add    $0x8,%esp
  80013d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800143:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800149:	50                   	push   %eax
  80014a:	e8 0c 09 00 00       	call   800a5b <sys_cputs>

	return b.cnt;
}
  80014f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800155:	c9                   	leave  
  800156:	c3                   	ret    

00800157 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800157:	55                   	push   %ebp
  800158:	89 e5                	mov    %esp,%ebp
  80015a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80015d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800160:	50                   	push   %eax
  800161:	ff 75 08             	pushl  0x8(%ebp)
  800164:	e8 9d ff ff ff       	call   800106 <vcprintf>
	va_end(ap);

	return cnt;
}
  800169:	c9                   	leave  
  80016a:	c3                   	ret    

0080016b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	57                   	push   %edi
  80016f:	56                   	push   %esi
  800170:	53                   	push   %ebx
  800171:	83 ec 1c             	sub    $0x1c,%esp
  800174:	89 c7                	mov    %eax,%edi
  800176:	89 d6                	mov    %edx,%esi
  800178:	8b 45 08             	mov    0x8(%ebp),%eax
  80017b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80017e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800181:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800184:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800187:	bb 00 00 00 00       	mov    $0x0,%ebx
  80018c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80018f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800192:	39 d3                	cmp    %edx,%ebx
  800194:	72 05                	jb     80019b <printnum+0x30>
  800196:	39 45 10             	cmp    %eax,0x10(%ebp)
  800199:	77 45                	ja     8001e0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80019b:	83 ec 0c             	sub    $0xc,%esp
  80019e:	ff 75 18             	pushl  0x18(%ebp)
  8001a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8001a4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001a7:	53                   	push   %ebx
  8001a8:	ff 75 10             	pushl  0x10(%ebp)
  8001ab:	83 ec 08             	sub    $0x8,%esp
  8001ae:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001b1:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b4:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b7:	ff 75 d8             	pushl  -0x28(%ebp)
  8001ba:	e8 01 19 00 00       	call   801ac0 <__udivdi3>
  8001bf:	83 c4 18             	add    $0x18,%esp
  8001c2:	52                   	push   %edx
  8001c3:	50                   	push   %eax
  8001c4:	89 f2                	mov    %esi,%edx
  8001c6:	89 f8                	mov    %edi,%eax
  8001c8:	e8 9e ff ff ff       	call   80016b <printnum>
  8001cd:	83 c4 20             	add    $0x20,%esp
  8001d0:	eb 18                	jmp    8001ea <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001d2:	83 ec 08             	sub    $0x8,%esp
  8001d5:	56                   	push   %esi
  8001d6:	ff 75 18             	pushl  0x18(%ebp)
  8001d9:	ff d7                	call   *%edi
  8001db:	83 c4 10             	add    $0x10,%esp
  8001de:	eb 03                	jmp    8001e3 <printnum+0x78>
  8001e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001e3:	83 eb 01             	sub    $0x1,%ebx
  8001e6:	85 db                	test   %ebx,%ebx
  8001e8:	7f e8                	jg     8001d2 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001ea:	83 ec 08             	sub    $0x8,%esp
  8001ed:	56                   	push   %esi
  8001ee:	83 ec 04             	sub    $0x4,%esp
  8001f1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f7:	ff 75 dc             	pushl  -0x24(%ebp)
  8001fa:	ff 75 d8             	pushl  -0x28(%ebp)
  8001fd:	e8 ee 19 00 00       	call   801bf0 <__umoddi3>
  800202:	83 c4 14             	add    $0x14,%esp
  800205:	0f be 80 78 1d 80 00 	movsbl 0x801d78(%eax),%eax
  80020c:	50                   	push   %eax
  80020d:	ff d7                	call   *%edi
}
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800215:	5b                   	pop    %ebx
  800216:	5e                   	pop    %esi
  800217:	5f                   	pop    %edi
  800218:	5d                   	pop    %ebp
  800219:	c3                   	ret    

0080021a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80021a:	55                   	push   %ebp
  80021b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80021d:	83 fa 01             	cmp    $0x1,%edx
  800220:	7e 0e                	jle    800230 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800222:	8b 10                	mov    (%eax),%edx
  800224:	8d 4a 08             	lea    0x8(%edx),%ecx
  800227:	89 08                	mov    %ecx,(%eax)
  800229:	8b 02                	mov    (%edx),%eax
  80022b:	8b 52 04             	mov    0x4(%edx),%edx
  80022e:	eb 22                	jmp    800252 <getuint+0x38>
	else if (lflag)
  800230:	85 d2                	test   %edx,%edx
  800232:	74 10                	je     800244 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800234:	8b 10                	mov    (%eax),%edx
  800236:	8d 4a 04             	lea    0x4(%edx),%ecx
  800239:	89 08                	mov    %ecx,(%eax)
  80023b:	8b 02                	mov    (%edx),%eax
  80023d:	ba 00 00 00 00       	mov    $0x0,%edx
  800242:	eb 0e                	jmp    800252 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800244:	8b 10                	mov    (%eax),%edx
  800246:	8d 4a 04             	lea    0x4(%edx),%ecx
  800249:	89 08                	mov    %ecx,(%eax)
  80024b:	8b 02                	mov    (%edx),%eax
  80024d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800252:	5d                   	pop    %ebp
  800253:	c3                   	ret    

00800254 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800254:	55                   	push   %ebp
  800255:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800257:	83 fa 01             	cmp    $0x1,%edx
  80025a:	7e 0e                	jle    80026a <getint+0x16>
		return va_arg(*ap, long long);
  80025c:	8b 10                	mov    (%eax),%edx
  80025e:	8d 4a 08             	lea    0x8(%edx),%ecx
  800261:	89 08                	mov    %ecx,(%eax)
  800263:	8b 02                	mov    (%edx),%eax
  800265:	8b 52 04             	mov    0x4(%edx),%edx
  800268:	eb 1a                	jmp    800284 <getint+0x30>
	else if (lflag)
  80026a:	85 d2                	test   %edx,%edx
  80026c:	74 0c                	je     80027a <getint+0x26>
		return va_arg(*ap, long);
  80026e:	8b 10                	mov    (%eax),%edx
  800270:	8d 4a 04             	lea    0x4(%edx),%ecx
  800273:	89 08                	mov    %ecx,(%eax)
  800275:	8b 02                	mov    (%edx),%eax
  800277:	99                   	cltd   
  800278:	eb 0a                	jmp    800284 <getint+0x30>
	else
		return va_arg(*ap, int);
  80027a:	8b 10                	mov    (%eax),%edx
  80027c:	8d 4a 04             	lea    0x4(%edx),%ecx
  80027f:	89 08                	mov    %ecx,(%eax)
  800281:	8b 02                	mov    (%edx),%eax
  800283:	99                   	cltd   
}
  800284:	5d                   	pop    %ebp
  800285:	c3                   	ret    

00800286 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800286:	55                   	push   %ebp
  800287:	89 e5                	mov    %esp,%ebp
  800289:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80028c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800290:	8b 10                	mov    (%eax),%edx
  800292:	3b 50 04             	cmp    0x4(%eax),%edx
  800295:	73 0a                	jae    8002a1 <sprintputch+0x1b>
		*b->buf++ = ch;
  800297:	8d 4a 01             	lea    0x1(%edx),%ecx
  80029a:	89 08                	mov    %ecx,(%eax)
  80029c:	8b 45 08             	mov    0x8(%ebp),%eax
  80029f:	88 02                	mov    %al,(%edx)
}
  8002a1:	5d                   	pop    %ebp
  8002a2:	c3                   	ret    

008002a3 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8002a9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ac:	50                   	push   %eax
  8002ad:	ff 75 10             	pushl  0x10(%ebp)
  8002b0:	ff 75 0c             	pushl  0xc(%ebp)
  8002b3:	ff 75 08             	pushl  0x8(%ebp)
  8002b6:	e8 05 00 00 00       	call   8002c0 <vprintfmt>
	va_end(ap);
}
  8002bb:	83 c4 10             	add    $0x10,%esp
  8002be:	c9                   	leave  
  8002bf:	c3                   	ret    

008002c0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	57                   	push   %edi
  8002c4:	56                   	push   %esi
  8002c5:	53                   	push   %ebx
  8002c6:	83 ec 2c             	sub    $0x2c,%esp
  8002c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8002cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002cf:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002d2:	eb 12                	jmp    8002e6 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8002d4:	85 c0                	test   %eax,%eax
  8002d6:	0f 84 44 03 00 00    	je     800620 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  8002dc:	83 ec 08             	sub    $0x8,%esp
  8002df:	53                   	push   %ebx
  8002e0:	50                   	push   %eax
  8002e1:	ff d6                	call   *%esi
  8002e3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002e6:	83 c7 01             	add    $0x1,%edi
  8002e9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8002ed:	83 f8 25             	cmp    $0x25,%eax
  8002f0:	75 e2                	jne    8002d4 <vprintfmt+0x14>
  8002f2:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8002f6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8002fd:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800304:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80030b:	ba 00 00 00 00       	mov    $0x0,%edx
  800310:	eb 07                	jmp    800319 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800312:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800315:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800319:	8d 47 01             	lea    0x1(%edi),%eax
  80031c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80031f:	0f b6 07             	movzbl (%edi),%eax
  800322:	0f b6 c8             	movzbl %al,%ecx
  800325:	83 e8 23             	sub    $0x23,%eax
  800328:	3c 55                	cmp    $0x55,%al
  80032a:	0f 87 d5 02 00 00    	ja     800605 <vprintfmt+0x345>
  800330:	0f b6 c0             	movzbl %al,%eax
  800333:	ff 24 85 c0 1e 80 00 	jmp    *0x801ec0(,%eax,4)
  80033a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80033d:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800341:	eb d6                	jmp    800319 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800343:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800346:	b8 00 00 00 00       	mov    $0x0,%eax
  80034b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80034e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800351:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  800355:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  800358:	8d 51 d0             	lea    -0x30(%ecx),%edx
  80035b:	83 fa 09             	cmp    $0x9,%edx
  80035e:	77 39                	ja     800399 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800360:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800363:	eb e9                	jmp    80034e <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800365:	8b 45 14             	mov    0x14(%ebp),%eax
  800368:	8d 48 04             	lea    0x4(%eax),%ecx
  80036b:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80036e:	8b 00                	mov    (%eax),%eax
  800370:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800373:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800376:	eb 27                	jmp    80039f <vprintfmt+0xdf>
  800378:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80037b:	85 c0                	test   %eax,%eax
  80037d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800382:	0f 49 c8             	cmovns %eax,%ecx
  800385:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80038b:	eb 8c                	jmp    800319 <vprintfmt+0x59>
  80038d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800390:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800397:	eb 80                	jmp    800319 <vprintfmt+0x59>
  800399:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80039c:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  80039f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003a3:	0f 89 70 ff ff ff    	jns    800319 <vprintfmt+0x59>
				width = precision, precision = -1;
  8003a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003af:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003b6:	e9 5e ff ff ff       	jmp    800319 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003bb:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8003c1:	e9 53 ff ff ff       	jmp    800319 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c9:	8d 50 04             	lea    0x4(%eax),%edx
  8003cc:	89 55 14             	mov    %edx,0x14(%ebp)
  8003cf:	83 ec 08             	sub    $0x8,%esp
  8003d2:	53                   	push   %ebx
  8003d3:	ff 30                	pushl  (%eax)
  8003d5:	ff d6                	call   *%esi
			break;
  8003d7:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  8003dd:	e9 04 ff ff ff       	jmp    8002e6 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8003e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e5:	8d 50 04             	lea    0x4(%eax),%edx
  8003e8:	89 55 14             	mov    %edx,0x14(%ebp)
  8003eb:	8b 00                	mov    (%eax),%eax
  8003ed:	99                   	cltd   
  8003ee:	31 d0                	xor    %edx,%eax
  8003f0:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003f2:	83 f8 0f             	cmp    $0xf,%eax
  8003f5:	7f 0b                	jg     800402 <vprintfmt+0x142>
  8003f7:	8b 14 85 20 20 80 00 	mov    0x802020(,%eax,4),%edx
  8003fe:	85 d2                	test   %edx,%edx
  800400:	75 18                	jne    80041a <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  800402:	50                   	push   %eax
  800403:	68 90 1d 80 00       	push   $0x801d90
  800408:	53                   	push   %ebx
  800409:	56                   	push   %esi
  80040a:	e8 94 fe ff ff       	call   8002a3 <printfmt>
  80040f:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800412:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800415:	e9 cc fe ff ff       	jmp    8002e6 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  80041a:	52                   	push   %edx
  80041b:	68 51 21 80 00       	push   $0x802151
  800420:	53                   	push   %ebx
  800421:	56                   	push   %esi
  800422:	e8 7c fe ff ff       	call   8002a3 <printfmt>
  800427:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80042a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80042d:	e9 b4 fe ff ff       	jmp    8002e6 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800432:	8b 45 14             	mov    0x14(%ebp),%eax
  800435:	8d 50 04             	lea    0x4(%eax),%edx
  800438:	89 55 14             	mov    %edx,0x14(%ebp)
  80043b:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80043d:	85 ff                	test   %edi,%edi
  80043f:	b8 89 1d 80 00       	mov    $0x801d89,%eax
  800444:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800447:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80044b:	0f 8e 94 00 00 00    	jle    8004e5 <vprintfmt+0x225>
  800451:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800455:	0f 84 98 00 00 00    	je     8004f3 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  80045b:	83 ec 08             	sub    $0x8,%esp
  80045e:	ff 75 d0             	pushl  -0x30(%ebp)
  800461:	57                   	push   %edi
  800462:	e8 41 02 00 00       	call   8006a8 <strnlen>
  800467:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80046a:	29 c1                	sub    %eax,%ecx
  80046c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80046f:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800472:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800476:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800479:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80047c:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80047e:	eb 0f                	jmp    80048f <vprintfmt+0x1cf>
					putch(padc, putdat);
  800480:	83 ec 08             	sub    $0x8,%esp
  800483:	53                   	push   %ebx
  800484:	ff 75 e0             	pushl  -0x20(%ebp)
  800487:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800489:	83 ef 01             	sub    $0x1,%edi
  80048c:	83 c4 10             	add    $0x10,%esp
  80048f:	85 ff                	test   %edi,%edi
  800491:	7f ed                	jg     800480 <vprintfmt+0x1c0>
  800493:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800496:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800499:	85 c9                	test   %ecx,%ecx
  80049b:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a0:	0f 49 c1             	cmovns %ecx,%eax
  8004a3:	29 c1                	sub    %eax,%ecx
  8004a5:	89 75 08             	mov    %esi,0x8(%ebp)
  8004a8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ab:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004ae:	89 cb                	mov    %ecx,%ebx
  8004b0:	eb 4d                	jmp    8004ff <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004b2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004b6:	74 1b                	je     8004d3 <vprintfmt+0x213>
  8004b8:	0f be c0             	movsbl %al,%eax
  8004bb:	83 e8 20             	sub    $0x20,%eax
  8004be:	83 f8 5e             	cmp    $0x5e,%eax
  8004c1:	76 10                	jbe    8004d3 <vprintfmt+0x213>
					putch('?', putdat);
  8004c3:	83 ec 08             	sub    $0x8,%esp
  8004c6:	ff 75 0c             	pushl  0xc(%ebp)
  8004c9:	6a 3f                	push   $0x3f
  8004cb:	ff 55 08             	call   *0x8(%ebp)
  8004ce:	83 c4 10             	add    $0x10,%esp
  8004d1:	eb 0d                	jmp    8004e0 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	ff 75 0c             	pushl  0xc(%ebp)
  8004d9:	52                   	push   %edx
  8004da:	ff 55 08             	call   *0x8(%ebp)
  8004dd:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004e0:	83 eb 01             	sub    $0x1,%ebx
  8004e3:	eb 1a                	jmp    8004ff <vprintfmt+0x23f>
  8004e5:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004eb:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004ee:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004f1:	eb 0c                	jmp    8004ff <vprintfmt+0x23f>
  8004f3:	89 75 08             	mov    %esi,0x8(%ebp)
  8004f6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004f9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004fc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004ff:	83 c7 01             	add    $0x1,%edi
  800502:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800506:	0f be d0             	movsbl %al,%edx
  800509:	85 d2                	test   %edx,%edx
  80050b:	74 23                	je     800530 <vprintfmt+0x270>
  80050d:	85 f6                	test   %esi,%esi
  80050f:	78 a1                	js     8004b2 <vprintfmt+0x1f2>
  800511:	83 ee 01             	sub    $0x1,%esi
  800514:	79 9c                	jns    8004b2 <vprintfmt+0x1f2>
  800516:	89 df                	mov    %ebx,%edi
  800518:	8b 75 08             	mov    0x8(%ebp),%esi
  80051b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80051e:	eb 18                	jmp    800538 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	53                   	push   %ebx
  800524:	6a 20                	push   $0x20
  800526:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800528:	83 ef 01             	sub    $0x1,%edi
  80052b:	83 c4 10             	add    $0x10,%esp
  80052e:	eb 08                	jmp    800538 <vprintfmt+0x278>
  800530:	89 df                	mov    %ebx,%edi
  800532:	8b 75 08             	mov    0x8(%ebp),%esi
  800535:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800538:	85 ff                	test   %edi,%edi
  80053a:	7f e4                	jg     800520 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80053c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80053f:	e9 a2 fd ff ff       	jmp    8002e6 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800544:	8d 45 14             	lea    0x14(%ebp),%eax
  800547:	e8 08 fd ff ff       	call   800254 <getint>
  80054c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80054f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800552:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800557:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80055b:	79 74                	jns    8005d1 <vprintfmt+0x311>
				putch('-', putdat);
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	53                   	push   %ebx
  800561:	6a 2d                	push   $0x2d
  800563:	ff d6                	call   *%esi
				num = -(long long) num;
  800565:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800568:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80056b:	f7 d8                	neg    %eax
  80056d:	83 d2 00             	adc    $0x0,%edx
  800570:	f7 da                	neg    %edx
  800572:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  800575:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80057a:	eb 55                	jmp    8005d1 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80057c:	8d 45 14             	lea    0x14(%ebp),%eax
  80057f:	e8 96 fc ff ff       	call   80021a <getuint>
			base = 10;
  800584:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800589:	eb 46                	jmp    8005d1 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  80058b:	8d 45 14             	lea    0x14(%ebp),%eax
  80058e:	e8 87 fc ff ff       	call   80021a <getuint>
			base = 8;
  800593:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800598:	eb 37                	jmp    8005d1 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  80059a:	83 ec 08             	sub    $0x8,%esp
  80059d:	53                   	push   %ebx
  80059e:	6a 30                	push   $0x30
  8005a0:	ff d6                	call   *%esi
			putch('x', putdat);
  8005a2:	83 c4 08             	add    $0x8,%esp
  8005a5:	53                   	push   %ebx
  8005a6:	6a 78                	push   $0x78
  8005a8:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8d 50 04             	lea    0x4(%eax),%edx
  8005b0:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8005b3:	8b 00                	mov    (%eax),%eax
  8005b5:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8005ba:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8005bd:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8005c2:	eb 0d                	jmp    8005d1 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8005c4:	8d 45 14             	lea    0x14(%ebp),%eax
  8005c7:	e8 4e fc ff ff       	call   80021a <getuint>
			base = 16;
  8005cc:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8005d1:	83 ec 0c             	sub    $0xc,%esp
  8005d4:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8005d8:	57                   	push   %edi
  8005d9:	ff 75 e0             	pushl  -0x20(%ebp)
  8005dc:	51                   	push   %ecx
  8005dd:	52                   	push   %edx
  8005de:	50                   	push   %eax
  8005df:	89 da                	mov    %ebx,%edx
  8005e1:	89 f0                	mov    %esi,%eax
  8005e3:	e8 83 fb ff ff       	call   80016b <printnum>
			break;
  8005e8:	83 c4 20             	add    $0x20,%esp
  8005eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005ee:	e9 f3 fc ff ff       	jmp    8002e6 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	53                   	push   %ebx
  8005f7:	51                   	push   %ecx
  8005f8:	ff d6                	call   *%esi
			break;
  8005fa:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800600:	e9 e1 fc ff ff       	jmp    8002e6 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	53                   	push   %ebx
  800609:	6a 25                	push   $0x25
  80060b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80060d:	83 c4 10             	add    $0x10,%esp
  800610:	eb 03                	jmp    800615 <vprintfmt+0x355>
  800612:	83 ef 01             	sub    $0x1,%edi
  800615:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  800619:	75 f7                	jne    800612 <vprintfmt+0x352>
  80061b:	e9 c6 fc ff ff       	jmp    8002e6 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  800620:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800623:	5b                   	pop    %ebx
  800624:	5e                   	pop    %esi
  800625:	5f                   	pop    %edi
  800626:	5d                   	pop    %ebp
  800627:	c3                   	ret    

00800628 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800628:	55                   	push   %ebp
  800629:	89 e5                	mov    %esp,%ebp
  80062b:	83 ec 18             	sub    $0x18,%esp
  80062e:	8b 45 08             	mov    0x8(%ebp),%eax
  800631:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800634:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800637:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80063b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80063e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800645:	85 c0                	test   %eax,%eax
  800647:	74 26                	je     80066f <vsnprintf+0x47>
  800649:	85 d2                	test   %edx,%edx
  80064b:	7e 22                	jle    80066f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80064d:	ff 75 14             	pushl  0x14(%ebp)
  800650:	ff 75 10             	pushl  0x10(%ebp)
  800653:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800656:	50                   	push   %eax
  800657:	68 86 02 80 00       	push   $0x800286
  80065c:	e8 5f fc ff ff       	call   8002c0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800661:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800664:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80066a:	83 c4 10             	add    $0x10,%esp
  80066d:	eb 05                	jmp    800674 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80066f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800674:	c9                   	leave  
  800675:	c3                   	ret    

00800676 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800676:	55                   	push   %ebp
  800677:	89 e5                	mov    %esp,%ebp
  800679:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80067c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80067f:	50                   	push   %eax
  800680:	ff 75 10             	pushl  0x10(%ebp)
  800683:	ff 75 0c             	pushl  0xc(%ebp)
  800686:	ff 75 08             	pushl  0x8(%ebp)
  800689:	e8 9a ff ff ff       	call   800628 <vsnprintf>
	va_end(ap);

	return rc;
}
  80068e:	c9                   	leave  
  80068f:	c3                   	ret    

00800690 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800690:	55                   	push   %ebp
  800691:	89 e5                	mov    %esp,%ebp
  800693:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800696:	b8 00 00 00 00       	mov    $0x0,%eax
  80069b:	eb 03                	jmp    8006a0 <strlen+0x10>
		n++;
  80069d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8006a0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8006a4:	75 f7                	jne    80069d <strlen+0xd>
		n++;
	return n;
}
  8006a6:	5d                   	pop    %ebp
  8006a7:	c3                   	ret    

008006a8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8006a8:	55                   	push   %ebp
  8006a9:	89 e5                	mov    %esp,%ebp
  8006ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006ae:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8006b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b6:	eb 03                	jmp    8006bb <strnlen+0x13>
		n++;
  8006b8:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8006bb:	39 c2                	cmp    %eax,%edx
  8006bd:	74 08                	je     8006c7 <strnlen+0x1f>
  8006bf:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8006c3:	75 f3                	jne    8006b8 <strnlen+0x10>
  8006c5:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  8006c7:	5d                   	pop    %ebp
  8006c8:	c3                   	ret    

008006c9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8006c9:	55                   	push   %ebp
  8006ca:	89 e5                	mov    %esp,%ebp
  8006cc:	53                   	push   %ebx
  8006cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8006d3:	89 c2                	mov    %eax,%edx
  8006d5:	83 c2 01             	add    $0x1,%edx
  8006d8:	83 c1 01             	add    $0x1,%ecx
  8006db:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8006df:	88 5a ff             	mov    %bl,-0x1(%edx)
  8006e2:	84 db                	test   %bl,%bl
  8006e4:	75 ef                	jne    8006d5 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8006e6:	5b                   	pop    %ebx
  8006e7:	5d                   	pop    %ebp
  8006e8:	c3                   	ret    

008006e9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	53                   	push   %ebx
  8006ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8006f0:	53                   	push   %ebx
  8006f1:	e8 9a ff ff ff       	call   800690 <strlen>
  8006f6:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8006f9:	ff 75 0c             	pushl  0xc(%ebp)
  8006fc:	01 d8                	add    %ebx,%eax
  8006fe:	50                   	push   %eax
  8006ff:	e8 c5 ff ff ff       	call   8006c9 <strcpy>
	return dst;
}
  800704:	89 d8                	mov    %ebx,%eax
  800706:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800709:	c9                   	leave  
  80070a:	c3                   	ret    

0080070b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80070b:	55                   	push   %ebp
  80070c:	89 e5                	mov    %esp,%ebp
  80070e:	56                   	push   %esi
  80070f:	53                   	push   %ebx
  800710:	8b 75 08             	mov    0x8(%ebp),%esi
  800713:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800716:	89 f3                	mov    %esi,%ebx
  800718:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80071b:	89 f2                	mov    %esi,%edx
  80071d:	eb 0f                	jmp    80072e <strncpy+0x23>
		*dst++ = *src;
  80071f:	83 c2 01             	add    $0x1,%edx
  800722:	0f b6 01             	movzbl (%ecx),%eax
  800725:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800728:	80 39 01             	cmpb   $0x1,(%ecx)
  80072b:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80072e:	39 da                	cmp    %ebx,%edx
  800730:	75 ed                	jne    80071f <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800732:	89 f0                	mov    %esi,%eax
  800734:	5b                   	pop    %ebx
  800735:	5e                   	pop    %esi
  800736:	5d                   	pop    %ebp
  800737:	c3                   	ret    

00800738 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800738:	55                   	push   %ebp
  800739:	89 e5                	mov    %esp,%ebp
  80073b:	56                   	push   %esi
  80073c:	53                   	push   %ebx
  80073d:	8b 75 08             	mov    0x8(%ebp),%esi
  800740:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800743:	8b 55 10             	mov    0x10(%ebp),%edx
  800746:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800748:	85 d2                	test   %edx,%edx
  80074a:	74 21                	je     80076d <strlcpy+0x35>
  80074c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800750:	89 f2                	mov    %esi,%edx
  800752:	eb 09                	jmp    80075d <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800754:	83 c2 01             	add    $0x1,%edx
  800757:	83 c1 01             	add    $0x1,%ecx
  80075a:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80075d:	39 c2                	cmp    %eax,%edx
  80075f:	74 09                	je     80076a <strlcpy+0x32>
  800761:	0f b6 19             	movzbl (%ecx),%ebx
  800764:	84 db                	test   %bl,%bl
  800766:	75 ec                	jne    800754 <strlcpy+0x1c>
  800768:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  80076a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80076d:	29 f0                	sub    %esi,%eax
}
  80076f:	5b                   	pop    %ebx
  800770:	5e                   	pop    %esi
  800771:	5d                   	pop    %ebp
  800772:	c3                   	ret    

00800773 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800773:	55                   	push   %ebp
  800774:	89 e5                	mov    %esp,%ebp
  800776:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800779:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80077c:	eb 06                	jmp    800784 <strcmp+0x11>
		p++, q++;
  80077e:	83 c1 01             	add    $0x1,%ecx
  800781:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800784:	0f b6 01             	movzbl (%ecx),%eax
  800787:	84 c0                	test   %al,%al
  800789:	74 04                	je     80078f <strcmp+0x1c>
  80078b:	3a 02                	cmp    (%edx),%al
  80078d:	74 ef                	je     80077e <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80078f:	0f b6 c0             	movzbl %al,%eax
  800792:	0f b6 12             	movzbl (%edx),%edx
  800795:	29 d0                	sub    %edx,%eax
}
  800797:	5d                   	pop    %ebp
  800798:	c3                   	ret    

00800799 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
  80079c:	53                   	push   %ebx
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007a3:	89 c3                	mov    %eax,%ebx
  8007a5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8007a8:	eb 06                	jmp    8007b0 <strncmp+0x17>
		n--, p++, q++;
  8007aa:	83 c0 01             	add    $0x1,%eax
  8007ad:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8007b0:	39 d8                	cmp    %ebx,%eax
  8007b2:	74 15                	je     8007c9 <strncmp+0x30>
  8007b4:	0f b6 08             	movzbl (%eax),%ecx
  8007b7:	84 c9                	test   %cl,%cl
  8007b9:	74 04                	je     8007bf <strncmp+0x26>
  8007bb:	3a 0a                	cmp    (%edx),%cl
  8007bd:	74 eb                	je     8007aa <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8007bf:	0f b6 00             	movzbl (%eax),%eax
  8007c2:	0f b6 12             	movzbl (%edx),%edx
  8007c5:	29 d0                	sub    %edx,%eax
  8007c7:	eb 05                	jmp    8007ce <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8007c9:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8007ce:	5b                   	pop    %ebx
  8007cf:	5d                   	pop    %ebp
  8007d0:	c3                   	ret    

008007d1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8007d1:	55                   	push   %ebp
  8007d2:	89 e5                	mov    %esp,%ebp
  8007d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8007db:	eb 07                	jmp    8007e4 <strchr+0x13>
		if (*s == c)
  8007dd:	38 ca                	cmp    %cl,%dl
  8007df:	74 0f                	je     8007f0 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8007e1:	83 c0 01             	add    $0x1,%eax
  8007e4:	0f b6 10             	movzbl (%eax),%edx
  8007e7:	84 d2                	test   %dl,%dl
  8007e9:	75 f2                	jne    8007dd <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8007eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007f0:	5d                   	pop    %ebp
  8007f1:	c3                   	ret    

008007f2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8007fc:	eb 03                	jmp    800801 <strfind+0xf>
  8007fe:	83 c0 01             	add    $0x1,%eax
  800801:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800804:	38 ca                	cmp    %cl,%dl
  800806:	74 04                	je     80080c <strfind+0x1a>
  800808:	84 d2                	test   %dl,%dl
  80080a:	75 f2                	jne    8007fe <strfind+0xc>
			break;
	return (char *) s;
}
  80080c:	5d                   	pop    %ebp
  80080d:	c3                   	ret    

0080080e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80080e:	55                   	push   %ebp
  80080f:	89 e5                	mov    %esp,%ebp
  800811:	57                   	push   %edi
  800812:	56                   	push   %esi
  800813:	53                   	push   %ebx
  800814:	8b 55 08             	mov    0x8(%ebp),%edx
  800817:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  80081a:	85 c9                	test   %ecx,%ecx
  80081c:	74 37                	je     800855 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80081e:	f6 c2 03             	test   $0x3,%dl
  800821:	75 2a                	jne    80084d <memset+0x3f>
  800823:	f6 c1 03             	test   $0x3,%cl
  800826:	75 25                	jne    80084d <memset+0x3f>
		c &= 0xFF;
  800828:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80082c:	89 df                	mov    %ebx,%edi
  80082e:	c1 e7 08             	shl    $0x8,%edi
  800831:	89 de                	mov    %ebx,%esi
  800833:	c1 e6 18             	shl    $0x18,%esi
  800836:	89 d8                	mov    %ebx,%eax
  800838:	c1 e0 10             	shl    $0x10,%eax
  80083b:	09 f0                	or     %esi,%eax
  80083d:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  80083f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800842:	89 f8                	mov    %edi,%eax
  800844:	09 d8                	or     %ebx,%eax
  800846:	89 d7                	mov    %edx,%edi
  800848:	fc                   	cld    
  800849:	f3 ab                	rep stos %eax,%es:(%edi)
  80084b:	eb 08                	jmp    800855 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80084d:	89 d7                	mov    %edx,%edi
  80084f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800852:	fc                   	cld    
  800853:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800855:	89 d0                	mov    %edx,%eax
  800857:	5b                   	pop    %ebx
  800858:	5e                   	pop    %esi
  800859:	5f                   	pop    %edi
  80085a:	5d                   	pop    %ebp
  80085b:	c3                   	ret    

0080085c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80085c:	55                   	push   %ebp
  80085d:	89 e5                	mov    %esp,%ebp
  80085f:	57                   	push   %edi
  800860:	56                   	push   %esi
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	8b 75 0c             	mov    0xc(%ebp),%esi
  800867:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80086a:	39 c6                	cmp    %eax,%esi
  80086c:	73 35                	jae    8008a3 <memmove+0x47>
  80086e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800871:	39 d0                	cmp    %edx,%eax
  800873:	73 2e                	jae    8008a3 <memmove+0x47>
		s += n;
		d += n;
  800875:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800878:	89 d6                	mov    %edx,%esi
  80087a:	09 fe                	or     %edi,%esi
  80087c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800882:	75 13                	jne    800897 <memmove+0x3b>
  800884:	f6 c1 03             	test   $0x3,%cl
  800887:	75 0e                	jne    800897 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  800889:	83 ef 04             	sub    $0x4,%edi
  80088c:	8d 72 fc             	lea    -0x4(%edx),%esi
  80088f:	c1 e9 02             	shr    $0x2,%ecx
  800892:	fd                   	std    
  800893:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800895:	eb 09                	jmp    8008a0 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800897:	83 ef 01             	sub    $0x1,%edi
  80089a:	8d 72 ff             	lea    -0x1(%edx),%esi
  80089d:	fd                   	std    
  80089e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8008a0:	fc                   	cld    
  8008a1:	eb 1d                	jmp    8008c0 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008a3:	89 f2                	mov    %esi,%edx
  8008a5:	09 c2                	or     %eax,%edx
  8008a7:	f6 c2 03             	test   $0x3,%dl
  8008aa:	75 0f                	jne    8008bb <memmove+0x5f>
  8008ac:	f6 c1 03             	test   $0x3,%cl
  8008af:	75 0a                	jne    8008bb <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  8008b1:	c1 e9 02             	shr    $0x2,%ecx
  8008b4:	89 c7                	mov    %eax,%edi
  8008b6:	fc                   	cld    
  8008b7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008b9:	eb 05                	jmp    8008c0 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8008bb:	89 c7                	mov    %eax,%edi
  8008bd:	fc                   	cld    
  8008be:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8008c0:	5e                   	pop    %esi
  8008c1:	5f                   	pop    %edi
  8008c2:	5d                   	pop    %ebp
  8008c3:	c3                   	ret    

008008c4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8008c7:	ff 75 10             	pushl  0x10(%ebp)
  8008ca:	ff 75 0c             	pushl  0xc(%ebp)
  8008cd:	ff 75 08             	pushl  0x8(%ebp)
  8008d0:	e8 87 ff ff ff       	call   80085c <memmove>
}
  8008d5:	c9                   	leave  
  8008d6:	c3                   	ret    

008008d7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	56                   	push   %esi
  8008db:	53                   	push   %ebx
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e2:	89 c6                	mov    %eax,%esi
  8008e4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8008e7:	eb 1a                	jmp    800903 <memcmp+0x2c>
		if (*s1 != *s2)
  8008e9:	0f b6 08             	movzbl (%eax),%ecx
  8008ec:	0f b6 1a             	movzbl (%edx),%ebx
  8008ef:	38 d9                	cmp    %bl,%cl
  8008f1:	74 0a                	je     8008fd <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8008f3:	0f b6 c1             	movzbl %cl,%eax
  8008f6:	0f b6 db             	movzbl %bl,%ebx
  8008f9:	29 d8                	sub    %ebx,%eax
  8008fb:	eb 0f                	jmp    80090c <memcmp+0x35>
		s1++, s2++;
  8008fd:	83 c0 01             	add    $0x1,%eax
  800900:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800903:	39 f0                	cmp    %esi,%eax
  800905:	75 e2                	jne    8008e9 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800907:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80090c:	5b                   	pop    %ebx
  80090d:	5e                   	pop    %esi
  80090e:	5d                   	pop    %ebp
  80090f:	c3                   	ret    

00800910 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	53                   	push   %ebx
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800917:	89 c1                	mov    %eax,%ecx
  800919:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  80091c:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800920:	eb 0a                	jmp    80092c <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800922:	0f b6 10             	movzbl (%eax),%edx
  800925:	39 da                	cmp    %ebx,%edx
  800927:	74 07                	je     800930 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800929:	83 c0 01             	add    $0x1,%eax
  80092c:	39 c8                	cmp    %ecx,%eax
  80092e:	72 f2                	jb     800922 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800930:	5b                   	pop    %ebx
  800931:	5d                   	pop    %ebp
  800932:	c3                   	ret    

00800933 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	57                   	push   %edi
  800937:	56                   	push   %esi
  800938:	53                   	push   %ebx
  800939:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80093c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80093f:	eb 03                	jmp    800944 <strtol+0x11>
		s++;
  800941:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800944:	0f b6 01             	movzbl (%ecx),%eax
  800947:	3c 20                	cmp    $0x20,%al
  800949:	74 f6                	je     800941 <strtol+0xe>
  80094b:	3c 09                	cmp    $0x9,%al
  80094d:	74 f2                	je     800941 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  80094f:	3c 2b                	cmp    $0x2b,%al
  800951:	75 0a                	jne    80095d <strtol+0x2a>
		s++;
  800953:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800956:	bf 00 00 00 00       	mov    $0x0,%edi
  80095b:	eb 11                	jmp    80096e <strtol+0x3b>
  80095d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800962:	3c 2d                	cmp    $0x2d,%al
  800964:	75 08                	jne    80096e <strtol+0x3b>
		s++, neg = 1;
  800966:	83 c1 01             	add    $0x1,%ecx
  800969:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80096e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800974:	75 15                	jne    80098b <strtol+0x58>
  800976:	80 39 30             	cmpb   $0x30,(%ecx)
  800979:	75 10                	jne    80098b <strtol+0x58>
  80097b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80097f:	75 7c                	jne    8009fd <strtol+0xca>
		s += 2, base = 16;
  800981:	83 c1 02             	add    $0x2,%ecx
  800984:	bb 10 00 00 00       	mov    $0x10,%ebx
  800989:	eb 16                	jmp    8009a1 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  80098b:	85 db                	test   %ebx,%ebx
  80098d:	75 12                	jne    8009a1 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80098f:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800994:	80 39 30             	cmpb   $0x30,(%ecx)
  800997:	75 08                	jne    8009a1 <strtol+0x6e>
		s++, base = 8;
  800999:	83 c1 01             	add    $0x1,%ecx
  80099c:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  8009a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a6:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8009a9:	0f b6 11             	movzbl (%ecx),%edx
  8009ac:	8d 72 d0             	lea    -0x30(%edx),%esi
  8009af:	89 f3                	mov    %esi,%ebx
  8009b1:	80 fb 09             	cmp    $0x9,%bl
  8009b4:	77 08                	ja     8009be <strtol+0x8b>
			dig = *s - '0';
  8009b6:	0f be d2             	movsbl %dl,%edx
  8009b9:	83 ea 30             	sub    $0x30,%edx
  8009bc:	eb 22                	jmp    8009e0 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  8009be:	8d 72 9f             	lea    -0x61(%edx),%esi
  8009c1:	89 f3                	mov    %esi,%ebx
  8009c3:	80 fb 19             	cmp    $0x19,%bl
  8009c6:	77 08                	ja     8009d0 <strtol+0x9d>
			dig = *s - 'a' + 10;
  8009c8:	0f be d2             	movsbl %dl,%edx
  8009cb:	83 ea 57             	sub    $0x57,%edx
  8009ce:	eb 10                	jmp    8009e0 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  8009d0:	8d 72 bf             	lea    -0x41(%edx),%esi
  8009d3:	89 f3                	mov    %esi,%ebx
  8009d5:	80 fb 19             	cmp    $0x19,%bl
  8009d8:	77 16                	ja     8009f0 <strtol+0xbd>
			dig = *s - 'A' + 10;
  8009da:	0f be d2             	movsbl %dl,%edx
  8009dd:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  8009e0:	3b 55 10             	cmp    0x10(%ebp),%edx
  8009e3:	7d 0b                	jge    8009f0 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  8009e5:	83 c1 01             	add    $0x1,%ecx
  8009e8:	0f af 45 10          	imul   0x10(%ebp),%eax
  8009ec:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  8009ee:	eb b9                	jmp    8009a9 <strtol+0x76>

	if (endptr)
  8009f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009f4:	74 0d                	je     800a03 <strtol+0xd0>
		*endptr = (char *) s;
  8009f6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009f9:	89 0e                	mov    %ecx,(%esi)
  8009fb:	eb 06                	jmp    800a03 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009fd:	85 db                	test   %ebx,%ebx
  8009ff:	74 98                	je     800999 <strtol+0x66>
  800a01:	eb 9e                	jmp    8009a1 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800a03:	89 c2                	mov    %eax,%edx
  800a05:	f7 da                	neg    %edx
  800a07:	85 ff                	test   %edi,%edi
  800a09:	0f 45 c2             	cmovne %edx,%eax
}
  800a0c:	5b                   	pop    %ebx
  800a0d:	5e                   	pop    %esi
  800a0e:	5f                   	pop    %edi
  800a0f:	5d                   	pop    %ebp
  800a10:	c3                   	ret    

00800a11 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	57                   	push   %edi
  800a15:	56                   	push   %esi
  800a16:	53                   	push   %ebx
  800a17:	83 ec 1c             	sub    $0x1c,%esp
  800a1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a1d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a20:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800a22:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a25:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a28:	8b 7d 10             	mov    0x10(%ebp),%edi
  800a2b:	8b 75 14             	mov    0x14(%ebp),%esi
  800a2e:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800a30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a34:	74 1d                	je     800a53 <syscall+0x42>
  800a36:	85 c0                	test   %eax,%eax
  800a38:	7e 19                	jle    800a53 <syscall+0x42>
  800a3a:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800a3d:	83 ec 0c             	sub    $0xc,%esp
  800a40:	50                   	push   %eax
  800a41:	52                   	push   %edx
  800a42:	68 7f 20 80 00       	push   $0x80207f
  800a47:	6a 23                	push   $0x23
  800a49:	68 9c 20 80 00       	push   $0x80209c
  800a4e:	e8 e9 0e 00 00       	call   80193c <_panic>

	return ret;
}
  800a53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a56:	5b                   	pop    %ebx
  800a57:	5e                   	pop    %esi
  800a58:	5f                   	pop    %edi
  800a59:	5d                   	pop    %ebp
  800a5a:	c3                   	ret    

00800a5b <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800a61:	6a 00                	push   $0x0
  800a63:	6a 00                	push   $0x0
  800a65:	6a 00                	push   $0x0
  800a67:	ff 75 0c             	pushl  0xc(%ebp)
  800a6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a6d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a72:	b8 00 00 00 00       	mov    $0x0,%eax
  800a77:	e8 95 ff ff ff       	call   800a11 <syscall>
}
  800a7c:	83 c4 10             	add    $0x10,%esp
  800a7f:	c9                   	leave  
  800a80:	c3                   	ret    

00800a81 <sys_cgetc>:

int
sys_cgetc(void)
{
  800a81:	55                   	push   %ebp
  800a82:	89 e5                	mov    %esp,%ebp
  800a84:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800a87:	6a 00                	push   $0x0
  800a89:	6a 00                	push   $0x0
  800a8b:	6a 00                	push   $0x0
  800a8d:	6a 00                	push   $0x0
  800a8f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a94:	ba 00 00 00 00       	mov    $0x0,%edx
  800a99:	b8 01 00 00 00       	mov    $0x1,%eax
  800a9e:	e8 6e ff ff ff       	call   800a11 <syscall>
}
  800aa3:	c9                   	leave  
  800aa4:	c3                   	ret    

00800aa5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800aab:	6a 00                	push   $0x0
  800aad:	6a 00                	push   $0x0
  800aaf:	6a 00                	push   $0x0
  800ab1:	6a 00                	push   $0x0
  800ab3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab6:	ba 01 00 00 00       	mov    $0x1,%edx
  800abb:	b8 03 00 00 00       	mov    $0x3,%eax
  800ac0:	e8 4c ff ff ff       	call   800a11 <syscall>
}
  800ac5:	c9                   	leave  
  800ac6:	c3                   	ret    

00800ac7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
  800aca:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800acd:	6a 00                	push   $0x0
  800acf:	6a 00                	push   $0x0
  800ad1:	6a 00                	push   $0x0
  800ad3:	6a 00                	push   $0x0
  800ad5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ada:	ba 00 00 00 00       	mov    $0x0,%edx
  800adf:	b8 02 00 00 00       	mov    $0x2,%eax
  800ae4:	e8 28 ff ff ff       	call   800a11 <syscall>
}
  800ae9:	c9                   	leave  
  800aea:	c3                   	ret    

00800aeb <sys_yield>:

void
sys_yield(void)
{
  800aeb:	55                   	push   %ebp
  800aec:	89 e5                	mov    %esp,%ebp
  800aee:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800af1:	6a 00                	push   $0x0
  800af3:	6a 00                	push   $0x0
  800af5:	6a 00                	push   $0x0
  800af7:	6a 00                	push   $0x0
  800af9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800afe:	ba 00 00 00 00       	mov    $0x0,%edx
  800b03:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b08:	e8 04 ff ff ff       	call   800a11 <syscall>
}
  800b0d:	83 c4 10             	add    $0x10,%esp
  800b10:	c9                   	leave  
  800b11:	c3                   	ret    

00800b12 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800b18:	6a 00                	push   $0x0
  800b1a:	6a 00                	push   $0x0
  800b1c:	ff 75 10             	pushl  0x10(%ebp)
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b25:	ba 01 00 00 00       	mov    $0x1,%edx
  800b2a:	b8 04 00 00 00       	mov    $0x4,%eax
  800b2f:	e8 dd fe ff ff       	call   800a11 <syscall>
}
  800b34:	c9                   	leave  
  800b35:	c3                   	ret    

00800b36 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800b3c:	ff 75 18             	pushl  0x18(%ebp)
  800b3f:	ff 75 14             	pushl  0x14(%ebp)
  800b42:	ff 75 10             	pushl  0x10(%ebp)
  800b45:	ff 75 0c             	pushl  0xc(%ebp)
  800b48:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b4b:	ba 01 00 00 00       	mov    $0x1,%edx
  800b50:	b8 05 00 00 00       	mov    $0x5,%eax
  800b55:	e8 b7 fe ff ff       	call   800a11 <syscall>
}
  800b5a:	c9                   	leave  
  800b5b:	c3                   	ret    

00800b5c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800b62:	6a 00                	push   $0x0
  800b64:	6a 00                	push   $0x0
  800b66:	6a 00                	push   $0x0
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b6e:	ba 01 00 00 00       	mov    $0x1,%edx
  800b73:	b8 06 00 00 00       	mov    $0x6,%eax
  800b78:	e8 94 fe ff ff       	call   800a11 <syscall>
}
  800b7d:	c9                   	leave  
  800b7e:	c3                   	ret    

00800b7f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
  800b82:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800b85:	6a 00                	push   $0x0
  800b87:	6a 00                	push   $0x0
  800b89:	6a 00                	push   $0x0
  800b8b:	ff 75 0c             	pushl  0xc(%ebp)
  800b8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b91:	ba 01 00 00 00       	mov    $0x1,%edx
  800b96:	b8 08 00 00 00       	mov    $0x8,%eax
  800b9b:	e8 71 fe ff ff       	call   800a11 <syscall>
}
  800ba0:	c9                   	leave  
  800ba1:	c3                   	ret    

00800ba2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ba2:	55                   	push   %ebp
  800ba3:	89 e5                	mov    %esp,%ebp
  800ba5:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800ba8:	6a 00                	push   $0x0
  800baa:	6a 00                	push   $0x0
  800bac:	6a 00                	push   $0x0
  800bae:	ff 75 0c             	pushl  0xc(%ebp)
  800bb1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb4:	ba 01 00 00 00       	mov    $0x1,%edx
  800bb9:	b8 09 00 00 00       	mov    $0x9,%eax
  800bbe:	e8 4e fe ff ff       	call   800a11 <syscall>
}
  800bc3:	c9                   	leave  
  800bc4:	c3                   	ret    

00800bc5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800bcb:	6a 00                	push   $0x0
  800bcd:	6a 00                	push   $0x0
  800bcf:	6a 00                	push   $0x0
  800bd1:	ff 75 0c             	pushl  0xc(%ebp)
  800bd4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd7:	ba 01 00 00 00       	mov    $0x1,%edx
  800bdc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800be1:	e8 2b fe ff ff       	call   800a11 <syscall>
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800bee:	6a 00                	push   $0x0
  800bf0:	ff 75 14             	pushl  0x14(%ebp)
  800bf3:	ff 75 10             	pushl  0x10(%ebp)
  800bf6:	ff 75 0c             	pushl  0xc(%ebp)
  800bf9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bfc:	ba 00 00 00 00       	mov    $0x0,%edx
  800c01:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c06:	e8 06 fe ff ff       	call   800a11 <syscall>
}
  800c0b:	c9                   	leave  
  800c0c:	c3                   	ret    

00800c0d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800c13:	6a 00                	push   $0x0
  800c15:	6a 00                	push   $0x0
  800c17:	6a 00                	push   $0x0
  800c19:	6a 00                	push   $0x0
  800c1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c1e:	ba 01 00 00 00       	mov    $0x1,%edx
  800c23:	b8 0d 00 00 00       	mov    $0xd,%eax
  800c28:	e8 e4 fd ff ff       	call   800a11 <syscall>
}
  800c2d:	c9                   	leave  
  800c2e:	c3                   	ret    

00800c2f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	05 00 00 00 30       	add    $0x30000000,%eax
  800c3a:	c1 e8 0c             	shr    $0xc,%eax
}
  800c3d:	5d                   	pop    %ebp
  800c3e:	c3                   	ret    

00800c3f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  800c42:	ff 75 08             	pushl  0x8(%ebp)
  800c45:	e8 e5 ff ff ff       	call   800c2f <fd2num>
  800c4a:	83 c4 04             	add    $0x4,%esp
  800c4d:	c1 e0 0c             	shl    $0xc,%eax
  800c50:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800c55:	c9                   	leave  
  800c56:	c3                   	ret    

00800c57 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c5d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800c62:	89 c2                	mov    %eax,%edx
  800c64:	c1 ea 16             	shr    $0x16,%edx
  800c67:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800c6e:	f6 c2 01             	test   $0x1,%dl
  800c71:	74 11                	je     800c84 <fd_alloc+0x2d>
  800c73:	89 c2                	mov    %eax,%edx
  800c75:	c1 ea 0c             	shr    $0xc,%edx
  800c78:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800c7f:	f6 c2 01             	test   $0x1,%dl
  800c82:	75 09                	jne    800c8d <fd_alloc+0x36>
			*fd_store = fd;
  800c84:	89 01                	mov    %eax,(%ecx)
			return 0;
  800c86:	b8 00 00 00 00       	mov    $0x0,%eax
  800c8b:	eb 17                	jmp    800ca4 <fd_alloc+0x4d>
  800c8d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800c92:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800c97:	75 c9                	jne    800c62 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800c99:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800c9f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    

00800ca6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800cac:	83 f8 1f             	cmp    $0x1f,%eax
  800caf:	77 36                	ja     800ce7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800cb1:	c1 e0 0c             	shl    $0xc,%eax
  800cb4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800cb9:	89 c2                	mov    %eax,%edx
  800cbb:	c1 ea 16             	shr    $0x16,%edx
  800cbe:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800cc5:	f6 c2 01             	test   $0x1,%dl
  800cc8:	74 24                	je     800cee <fd_lookup+0x48>
  800cca:	89 c2                	mov    %eax,%edx
  800ccc:	c1 ea 0c             	shr    $0xc,%edx
  800ccf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800cd6:	f6 c2 01             	test   $0x1,%dl
  800cd9:	74 1a                	je     800cf5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800cdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cde:	89 02                	mov    %eax,(%edx)
	return 0;
  800ce0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce5:	eb 13                	jmp    800cfa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800ce7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cec:	eb 0c                	jmp    800cfa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800cee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cf3:	eb 05                	jmp    800cfa <fd_lookup+0x54>
  800cf5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    

00800cfc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	83 ec 08             	sub    $0x8,%esp
  800d02:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d05:	ba 28 21 80 00       	mov    $0x802128,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800d0a:	eb 13                	jmp    800d1f <dev_lookup+0x23>
  800d0c:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  800d0f:	39 08                	cmp    %ecx,(%eax)
  800d11:	75 0c                	jne    800d1f <dev_lookup+0x23>
			*dev = devtab[i];
  800d13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d16:	89 01                	mov    %eax,(%ecx)
			return 0;
  800d18:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1d:	eb 2e                	jmp    800d4d <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800d1f:	8b 02                	mov    (%edx),%eax
  800d21:	85 c0                	test   %eax,%eax
  800d23:	75 e7                	jne    800d0c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800d25:	a1 08 40 80 00       	mov    0x804008,%eax
  800d2a:	8b 40 48             	mov    0x48(%eax),%eax
  800d2d:	83 ec 04             	sub    $0x4,%esp
  800d30:	51                   	push   %ecx
  800d31:	50                   	push   %eax
  800d32:	68 ac 20 80 00       	push   $0x8020ac
  800d37:	e8 1b f4 ff ff       	call   800157 <cprintf>
	*dev = 0;
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800d45:	83 c4 10             	add    $0x10,%esp
  800d48:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800d4d:	c9                   	leave  
  800d4e:	c3                   	ret    

00800d4f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800d4f:	55                   	push   %ebp
  800d50:	89 e5                	mov    %esp,%ebp
  800d52:	56                   	push   %esi
  800d53:	53                   	push   %ebx
  800d54:	83 ec 10             	sub    $0x10,%esp
  800d57:	8b 75 08             	mov    0x8(%ebp),%esi
  800d5a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800d5d:	56                   	push   %esi
  800d5e:	e8 cc fe ff ff       	call   800c2f <fd2num>
  800d63:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800d66:	89 14 24             	mov    %edx,(%esp)
  800d69:	50                   	push   %eax
  800d6a:	e8 37 ff ff ff       	call   800ca6 <fd_lookup>
  800d6f:	83 c4 08             	add    $0x8,%esp
  800d72:	85 c0                	test   %eax,%eax
  800d74:	78 05                	js     800d7b <fd_close+0x2c>
	    || fd != fd2)
  800d76:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800d79:	74 0c                	je     800d87 <fd_close+0x38>
		return (must_exist ? r : 0);
  800d7b:	84 db                	test   %bl,%bl
  800d7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d82:	0f 44 c2             	cmove  %edx,%eax
  800d85:	eb 41                	jmp    800dc8 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800d87:	83 ec 08             	sub    $0x8,%esp
  800d8a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d8d:	50                   	push   %eax
  800d8e:	ff 36                	pushl  (%esi)
  800d90:	e8 67 ff ff ff       	call   800cfc <dev_lookup>
  800d95:	89 c3                	mov    %eax,%ebx
  800d97:	83 c4 10             	add    $0x10,%esp
  800d9a:	85 c0                	test   %eax,%eax
  800d9c:	78 1a                	js     800db8 <fd_close+0x69>
		if (dev->dev_close)
  800d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800da1:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800da4:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800da9:	85 c0                	test   %eax,%eax
  800dab:	74 0b                	je     800db8 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  800dad:	83 ec 0c             	sub    $0xc,%esp
  800db0:	56                   	push   %esi
  800db1:	ff d0                	call   *%eax
  800db3:	89 c3                	mov    %eax,%ebx
  800db5:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800db8:	83 ec 08             	sub    $0x8,%esp
  800dbb:	56                   	push   %esi
  800dbc:	6a 00                	push   $0x0
  800dbe:	e8 99 fd ff ff       	call   800b5c <sys_page_unmap>
	return r;
  800dc3:	83 c4 10             	add    $0x10,%esp
  800dc6:	89 d8                	mov    %ebx,%eax
}
  800dc8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dcb:	5b                   	pop    %ebx
  800dcc:	5e                   	pop    %esi
  800dcd:	5d                   	pop    %ebp
  800dce:	c3                   	ret    

00800dcf <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800dd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800dd8:	50                   	push   %eax
  800dd9:	ff 75 08             	pushl  0x8(%ebp)
  800ddc:	e8 c5 fe ff ff       	call   800ca6 <fd_lookup>
  800de1:	83 c4 08             	add    $0x8,%esp
  800de4:	85 c0                	test   %eax,%eax
  800de6:	78 10                	js     800df8 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800de8:	83 ec 08             	sub    $0x8,%esp
  800deb:	6a 01                	push   $0x1
  800ded:	ff 75 f4             	pushl  -0xc(%ebp)
  800df0:	e8 5a ff ff ff       	call   800d4f <fd_close>
  800df5:	83 c4 10             	add    $0x10,%esp
}
  800df8:	c9                   	leave  
  800df9:	c3                   	ret    

00800dfa <close_all>:

void
close_all(void)
{
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	53                   	push   %ebx
  800dfe:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800e01:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800e06:	83 ec 0c             	sub    $0xc,%esp
  800e09:	53                   	push   %ebx
  800e0a:	e8 c0 ff ff ff       	call   800dcf <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800e0f:	83 c3 01             	add    $0x1,%ebx
  800e12:	83 c4 10             	add    $0x10,%esp
  800e15:	83 fb 20             	cmp    $0x20,%ebx
  800e18:	75 ec                	jne    800e06 <close_all+0xc>
		close(i);
}
  800e1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e1d:	c9                   	leave  
  800e1e:	c3                   	ret    

00800e1f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	57                   	push   %edi
  800e23:	56                   	push   %esi
  800e24:	53                   	push   %ebx
  800e25:	83 ec 2c             	sub    $0x2c,%esp
  800e28:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800e2b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800e2e:	50                   	push   %eax
  800e2f:	ff 75 08             	pushl  0x8(%ebp)
  800e32:	e8 6f fe ff ff       	call   800ca6 <fd_lookup>
  800e37:	83 c4 08             	add    $0x8,%esp
  800e3a:	85 c0                	test   %eax,%eax
  800e3c:	0f 88 c1 00 00 00    	js     800f03 <dup+0xe4>
		return r;
	close(newfdnum);
  800e42:	83 ec 0c             	sub    $0xc,%esp
  800e45:	56                   	push   %esi
  800e46:	e8 84 ff ff ff       	call   800dcf <close>

	newfd = INDEX2FD(newfdnum);
  800e4b:	89 f3                	mov    %esi,%ebx
  800e4d:	c1 e3 0c             	shl    $0xc,%ebx
  800e50:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800e56:	83 c4 04             	add    $0x4,%esp
  800e59:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e5c:	e8 de fd ff ff       	call   800c3f <fd2data>
  800e61:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  800e63:	89 1c 24             	mov    %ebx,(%esp)
  800e66:	e8 d4 fd ff ff       	call   800c3f <fd2data>
  800e6b:	83 c4 10             	add    $0x10,%esp
  800e6e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800e71:	89 f8                	mov    %edi,%eax
  800e73:	c1 e8 16             	shr    $0x16,%eax
  800e76:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800e7d:	a8 01                	test   $0x1,%al
  800e7f:	74 37                	je     800eb8 <dup+0x99>
  800e81:	89 f8                	mov    %edi,%eax
  800e83:	c1 e8 0c             	shr    $0xc,%eax
  800e86:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800e8d:	f6 c2 01             	test   $0x1,%dl
  800e90:	74 26                	je     800eb8 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800e92:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e99:	83 ec 0c             	sub    $0xc,%esp
  800e9c:	25 07 0e 00 00       	and    $0xe07,%eax
  800ea1:	50                   	push   %eax
  800ea2:	ff 75 d4             	pushl  -0x2c(%ebp)
  800ea5:	6a 00                	push   $0x0
  800ea7:	57                   	push   %edi
  800ea8:	6a 00                	push   $0x0
  800eaa:	e8 87 fc ff ff       	call   800b36 <sys_page_map>
  800eaf:	89 c7                	mov    %eax,%edi
  800eb1:	83 c4 20             	add    $0x20,%esp
  800eb4:	85 c0                	test   %eax,%eax
  800eb6:	78 2e                	js     800ee6 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800eb8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ebb:	89 d0                	mov    %edx,%eax
  800ebd:	c1 e8 0c             	shr    $0xc,%eax
  800ec0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ec7:	83 ec 0c             	sub    $0xc,%esp
  800eca:	25 07 0e 00 00       	and    $0xe07,%eax
  800ecf:	50                   	push   %eax
  800ed0:	53                   	push   %ebx
  800ed1:	6a 00                	push   $0x0
  800ed3:	52                   	push   %edx
  800ed4:	6a 00                	push   $0x0
  800ed6:	e8 5b fc ff ff       	call   800b36 <sys_page_map>
  800edb:	89 c7                	mov    %eax,%edi
  800edd:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  800ee0:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800ee2:	85 ff                	test   %edi,%edi
  800ee4:	79 1d                	jns    800f03 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800ee6:	83 ec 08             	sub    $0x8,%esp
  800ee9:	53                   	push   %ebx
  800eea:	6a 00                	push   $0x0
  800eec:	e8 6b fc ff ff       	call   800b5c <sys_page_unmap>
	sys_page_unmap(0, nva);
  800ef1:	83 c4 08             	add    $0x8,%esp
  800ef4:	ff 75 d4             	pushl  -0x2c(%ebp)
  800ef7:	6a 00                	push   $0x0
  800ef9:	e8 5e fc ff ff       	call   800b5c <sys_page_unmap>
	return r;
  800efe:	83 c4 10             	add    $0x10,%esp
  800f01:	89 f8                	mov    %edi,%eax
}
  800f03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f06:	5b                   	pop    %ebx
  800f07:	5e                   	pop    %esi
  800f08:	5f                   	pop    %edi
  800f09:	5d                   	pop    %ebp
  800f0a:	c3                   	ret    

00800f0b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	53                   	push   %ebx
  800f0f:	83 ec 14             	sub    $0x14,%esp
  800f12:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800f15:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800f18:	50                   	push   %eax
  800f19:	53                   	push   %ebx
  800f1a:	e8 87 fd ff ff       	call   800ca6 <fd_lookup>
  800f1f:	83 c4 08             	add    $0x8,%esp
  800f22:	89 c2                	mov    %eax,%edx
  800f24:	85 c0                	test   %eax,%eax
  800f26:	78 6d                	js     800f95 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800f28:	83 ec 08             	sub    $0x8,%esp
  800f2b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f2e:	50                   	push   %eax
  800f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f32:	ff 30                	pushl  (%eax)
  800f34:	e8 c3 fd ff ff       	call   800cfc <dev_lookup>
  800f39:	83 c4 10             	add    $0x10,%esp
  800f3c:	85 c0                	test   %eax,%eax
  800f3e:	78 4c                	js     800f8c <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800f40:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f43:	8b 42 08             	mov    0x8(%edx),%eax
  800f46:	83 e0 03             	and    $0x3,%eax
  800f49:	83 f8 01             	cmp    $0x1,%eax
  800f4c:	75 21                	jne    800f6f <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800f4e:	a1 08 40 80 00       	mov    0x804008,%eax
  800f53:	8b 40 48             	mov    0x48(%eax),%eax
  800f56:	83 ec 04             	sub    $0x4,%esp
  800f59:	53                   	push   %ebx
  800f5a:	50                   	push   %eax
  800f5b:	68 ed 20 80 00       	push   $0x8020ed
  800f60:	e8 f2 f1 ff ff       	call   800157 <cprintf>
		return -E_INVAL;
  800f65:	83 c4 10             	add    $0x10,%esp
  800f68:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800f6d:	eb 26                	jmp    800f95 <read+0x8a>
	}
	if (!dev->dev_read)
  800f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f72:	8b 40 08             	mov    0x8(%eax),%eax
  800f75:	85 c0                	test   %eax,%eax
  800f77:	74 17                	je     800f90 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800f79:	83 ec 04             	sub    $0x4,%esp
  800f7c:	ff 75 10             	pushl  0x10(%ebp)
  800f7f:	ff 75 0c             	pushl  0xc(%ebp)
  800f82:	52                   	push   %edx
  800f83:	ff d0                	call   *%eax
  800f85:	89 c2                	mov    %eax,%edx
  800f87:	83 c4 10             	add    $0x10,%esp
  800f8a:	eb 09                	jmp    800f95 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800f8c:	89 c2                	mov    %eax,%edx
  800f8e:	eb 05                	jmp    800f95 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800f90:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  800f95:	89 d0                	mov    %edx,%eax
  800f97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	57                   	push   %edi
  800fa0:	56                   	push   %esi
  800fa1:	53                   	push   %ebx
  800fa2:	83 ec 0c             	sub    $0xc,%esp
  800fa5:	8b 7d 08             	mov    0x8(%ebp),%edi
  800fa8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800fab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb0:	eb 21                	jmp    800fd3 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800fb2:	83 ec 04             	sub    $0x4,%esp
  800fb5:	89 f0                	mov    %esi,%eax
  800fb7:	29 d8                	sub    %ebx,%eax
  800fb9:	50                   	push   %eax
  800fba:	89 d8                	mov    %ebx,%eax
  800fbc:	03 45 0c             	add    0xc(%ebp),%eax
  800fbf:	50                   	push   %eax
  800fc0:	57                   	push   %edi
  800fc1:	e8 45 ff ff ff       	call   800f0b <read>
		if (m < 0)
  800fc6:	83 c4 10             	add    $0x10,%esp
  800fc9:	85 c0                	test   %eax,%eax
  800fcb:	78 10                	js     800fdd <readn+0x41>
			return m;
		if (m == 0)
  800fcd:	85 c0                	test   %eax,%eax
  800fcf:	74 0a                	je     800fdb <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800fd1:	01 c3                	add    %eax,%ebx
  800fd3:	39 f3                	cmp    %esi,%ebx
  800fd5:	72 db                	jb     800fb2 <readn+0x16>
  800fd7:	89 d8                	mov    %ebx,%eax
  800fd9:	eb 02                	jmp    800fdd <readn+0x41>
  800fdb:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  800fdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe0:	5b                   	pop    %ebx
  800fe1:	5e                   	pop    %esi
  800fe2:	5f                   	pop    %edi
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    

00800fe5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	53                   	push   %ebx
  800fe9:	83 ec 14             	sub    $0x14,%esp
  800fec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800fef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ff2:	50                   	push   %eax
  800ff3:	53                   	push   %ebx
  800ff4:	e8 ad fc ff ff       	call   800ca6 <fd_lookup>
  800ff9:	83 c4 08             	add    $0x8,%esp
  800ffc:	89 c2                	mov    %eax,%edx
  800ffe:	85 c0                	test   %eax,%eax
  801000:	78 68                	js     80106a <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801002:	83 ec 08             	sub    $0x8,%esp
  801005:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801008:	50                   	push   %eax
  801009:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80100c:	ff 30                	pushl  (%eax)
  80100e:	e8 e9 fc ff ff       	call   800cfc <dev_lookup>
  801013:	83 c4 10             	add    $0x10,%esp
  801016:	85 c0                	test   %eax,%eax
  801018:	78 47                	js     801061 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80101a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80101d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801021:	75 21                	jne    801044 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801023:	a1 08 40 80 00       	mov    0x804008,%eax
  801028:	8b 40 48             	mov    0x48(%eax),%eax
  80102b:	83 ec 04             	sub    $0x4,%esp
  80102e:	53                   	push   %ebx
  80102f:	50                   	push   %eax
  801030:	68 09 21 80 00       	push   $0x802109
  801035:	e8 1d f1 ff ff       	call   800157 <cprintf>
		return -E_INVAL;
  80103a:	83 c4 10             	add    $0x10,%esp
  80103d:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801042:	eb 26                	jmp    80106a <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801044:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801047:	8b 52 0c             	mov    0xc(%edx),%edx
  80104a:	85 d2                	test   %edx,%edx
  80104c:	74 17                	je     801065 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80104e:	83 ec 04             	sub    $0x4,%esp
  801051:	ff 75 10             	pushl  0x10(%ebp)
  801054:	ff 75 0c             	pushl  0xc(%ebp)
  801057:	50                   	push   %eax
  801058:	ff d2                	call   *%edx
  80105a:	89 c2                	mov    %eax,%edx
  80105c:	83 c4 10             	add    $0x10,%esp
  80105f:	eb 09                	jmp    80106a <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801061:	89 c2                	mov    %eax,%edx
  801063:	eb 05                	jmp    80106a <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801065:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  80106a:	89 d0                	mov    %edx,%eax
  80106c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80106f:	c9                   	leave  
  801070:	c3                   	ret    

00801071 <seek>:

int
seek(int fdnum, off_t offset)
{
  801071:	55                   	push   %ebp
  801072:	89 e5                	mov    %esp,%ebp
  801074:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801077:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80107a:	50                   	push   %eax
  80107b:	ff 75 08             	pushl  0x8(%ebp)
  80107e:	e8 23 fc ff ff       	call   800ca6 <fd_lookup>
  801083:	83 c4 08             	add    $0x8,%esp
  801086:	85 c0                	test   %eax,%eax
  801088:	78 0e                	js     801098 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80108a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80108d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801090:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801093:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801098:	c9                   	leave  
  801099:	c3                   	ret    

0080109a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	53                   	push   %ebx
  80109e:	83 ec 14             	sub    $0x14,%esp
  8010a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010a7:	50                   	push   %eax
  8010a8:	53                   	push   %ebx
  8010a9:	e8 f8 fb ff ff       	call   800ca6 <fd_lookup>
  8010ae:	83 c4 08             	add    $0x8,%esp
  8010b1:	89 c2                	mov    %eax,%edx
  8010b3:	85 c0                	test   %eax,%eax
  8010b5:	78 65                	js     80111c <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010b7:	83 ec 08             	sub    $0x8,%esp
  8010ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010bd:	50                   	push   %eax
  8010be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c1:	ff 30                	pushl  (%eax)
  8010c3:	e8 34 fc ff ff       	call   800cfc <dev_lookup>
  8010c8:	83 c4 10             	add    $0x10,%esp
  8010cb:	85 c0                	test   %eax,%eax
  8010cd:	78 44                	js     801113 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8010cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010d2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8010d6:	75 21                	jne    8010f9 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8010d8:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8010dd:	8b 40 48             	mov    0x48(%eax),%eax
  8010e0:	83 ec 04             	sub    $0x4,%esp
  8010e3:	53                   	push   %ebx
  8010e4:	50                   	push   %eax
  8010e5:	68 cc 20 80 00       	push   $0x8020cc
  8010ea:	e8 68 f0 ff ff       	call   800157 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8010ef:	83 c4 10             	add    $0x10,%esp
  8010f2:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8010f7:	eb 23                	jmp    80111c <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  8010f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010fc:	8b 52 18             	mov    0x18(%edx),%edx
  8010ff:	85 d2                	test   %edx,%edx
  801101:	74 14                	je     801117 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801103:	83 ec 08             	sub    $0x8,%esp
  801106:	ff 75 0c             	pushl  0xc(%ebp)
  801109:	50                   	push   %eax
  80110a:	ff d2                	call   *%edx
  80110c:	89 c2                	mov    %eax,%edx
  80110e:	83 c4 10             	add    $0x10,%esp
  801111:	eb 09                	jmp    80111c <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801113:	89 c2                	mov    %eax,%edx
  801115:	eb 05                	jmp    80111c <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801117:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  80111c:	89 d0                	mov    %edx,%eax
  80111e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801121:	c9                   	leave  
  801122:	c3                   	ret    

00801123 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801123:	55                   	push   %ebp
  801124:	89 e5                	mov    %esp,%ebp
  801126:	53                   	push   %ebx
  801127:	83 ec 14             	sub    $0x14,%esp
  80112a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80112d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801130:	50                   	push   %eax
  801131:	ff 75 08             	pushl  0x8(%ebp)
  801134:	e8 6d fb ff ff       	call   800ca6 <fd_lookup>
  801139:	83 c4 08             	add    $0x8,%esp
  80113c:	89 c2                	mov    %eax,%edx
  80113e:	85 c0                	test   %eax,%eax
  801140:	78 58                	js     80119a <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801142:	83 ec 08             	sub    $0x8,%esp
  801145:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801148:	50                   	push   %eax
  801149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80114c:	ff 30                	pushl  (%eax)
  80114e:	e8 a9 fb ff ff       	call   800cfc <dev_lookup>
  801153:	83 c4 10             	add    $0x10,%esp
  801156:	85 c0                	test   %eax,%eax
  801158:	78 37                	js     801191 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  80115a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80115d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801161:	74 32                	je     801195 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801163:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801166:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80116d:	00 00 00 
	stat->st_isdir = 0;
  801170:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801177:	00 00 00 
	stat->st_dev = dev;
  80117a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801180:	83 ec 08             	sub    $0x8,%esp
  801183:	53                   	push   %ebx
  801184:	ff 75 f0             	pushl  -0x10(%ebp)
  801187:	ff 50 14             	call   *0x14(%eax)
  80118a:	89 c2                	mov    %eax,%edx
  80118c:	83 c4 10             	add    $0x10,%esp
  80118f:	eb 09                	jmp    80119a <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801191:	89 c2                	mov    %eax,%edx
  801193:	eb 05                	jmp    80119a <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801195:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80119a:	89 d0                	mov    %edx,%eax
  80119c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80119f:	c9                   	leave  
  8011a0:	c3                   	ret    

008011a1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
  8011a4:	56                   	push   %esi
  8011a5:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8011a6:	83 ec 08             	sub    $0x8,%esp
  8011a9:	6a 00                	push   $0x0
  8011ab:	ff 75 08             	pushl  0x8(%ebp)
  8011ae:	e8 06 02 00 00       	call   8013b9 <open>
  8011b3:	89 c3                	mov    %eax,%ebx
  8011b5:	83 c4 10             	add    $0x10,%esp
  8011b8:	85 c0                	test   %eax,%eax
  8011ba:	78 1b                	js     8011d7 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8011bc:	83 ec 08             	sub    $0x8,%esp
  8011bf:	ff 75 0c             	pushl  0xc(%ebp)
  8011c2:	50                   	push   %eax
  8011c3:	e8 5b ff ff ff       	call   801123 <fstat>
  8011c8:	89 c6                	mov    %eax,%esi
	close(fd);
  8011ca:	89 1c 24             	mov    %ebx,(%esp)
  8011cd:	e8 fd fb ff ff       	call   800dcf <close>
	return r;
  8011d2:	83 c4 10             	add    $0x10,%esp
  8011d5:	89 f0                	mov    %esi,%eax
}
  8011d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011da:	5b                   	pop    %ebx
  8011db:	5e                   	pop    %esi
  8011dc:	5d                   	pop    %ebp
  8011dd:	c3                   	ret    

008011de <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8011de:	55                   	push   %ebp
  8011df:	89 e5                	mov    %esp,%ebp
  8011e1:	56                   	push   %esi
  8011e2:	53                   	push   %ebx
  8011e3:	89 c6                	mov    %eax,%esi
  8011e5:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8011e7:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8011ee:	75 12                	jne    801202 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8011f0:	83 ec 0c             	sub    $0xc,%esp
  8011f3:	6a 01                	push   $0x1
  8011f5:	e8 47 08 00 00       	call   801a41 <ipc_find_env>
  8011fa:	a3 00 40 80 00       	mov    %eax,0x804000
  8011ff:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801202:	6a 07                	push   $0x7
  801204:	68 00 50 80 00       	push   $0x805000
  801209:	56                   	push   %esi
  80120a:	ff 35 00 40 80 00    	pushl  0x804000
  801210:	e8 d8 07 00 00       	call   8019ed <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801215:	83 c4 0c             	add    $0xc,%esp
  801218:	6a 00                	push   $0x0
  80121a:	53                   	push   %ebx
  80121b:	6a 00                	push   $0x0
  80121d:	e8 60 07 00 00       	call   801982 <ipc_recv>
}
  801222:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801225:	5b                   	pop    %ebx
  801226:	5e                   	pop    %esi
  801227:	5d                   	pop    %ebp
  801228:	c3                   	ret    

00801229 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	8b 40 0c             	mov    0xc(%eax),%eax
  801235:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80123a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801242:	ba 00 00 00 00       	mov    $0x0,%edx
  801247:	b8 02 00 00 00       	mov    $0x2,%eax
  80124c:	e8 8d ff ff ff       	call   8011de <fsipc>
}
  801251:	c9                   	leave  
  801252:	c3                   	ret    

00801253 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
  801256:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8b 40 0c             	mov    0xc(%eax),%eax
  80125f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801264:	ba 00 00 00 00       	mov    $0x0,%edx
  801269:	b8 06 00 00 00       	mov    $0x6,%eax
  80126e:	e8 6b ff ff ff       	call   8011de <fsipc>
}
  801273:	c9                   	leave  
  801274:	c3                   	ret    

00801275 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	53                   	push   %ebx
  801279:	83 ec 04             	sub    $0x4,%esp
  80127c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	8b 40 0c             	mov    0xc(%eax),%eax
  801285:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80128a:	ba 00 00 00 00       	mov    $0x0,%edx
  80128f:	b8 05 00 00 00       	mov    $0x5,%eax
  801294:	e8 45 ff ff ff       	call   8011de <fsipc>
  801299:	85 c0                	test   %eax,%eax
  80129b:	78 2c                	js     8012c9 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80129d:	83 ec 08             	sub    $0x8,%esp
  8012a0:	68 00 50 80 00       	push   $0x805000
  8012a5:	53                   	push   %ebx
  8012a6:	e8 1e f4 ff ff       	call   8006c9 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8012ab:	a1 80 50 80 00       	mov    0x805080,%eax
  8012b0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8012b6:	a1 84 50 80 00       	mov    0x805084,%eax
  8012bb:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8012c1:	83 c4 10             	add    $0x10,%esp
  8012c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 08             	sub    $0x8,%esp
  8012d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d7:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8012da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012dd:	8b 49 0c             	mov    0xc(%ecx),%ecx
  8012e0:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  8012e6:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8012eb:	76 22                	jbe    80130f <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  8012ed:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  8012f4:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  8012f7:	83 ec 04             	sub    $0x4,%esp
  8012fa:	68 f8 0f 00 00       	push   $0xff8
  8012ff:	52                   	push   %edx
  801300:	68 08 50 80 00       	push   $0x805008
  801305:	e8 52 f5 ff ff       	call   80085c <memmove>
  80130a:	83 c4 10             	add    $0x10,%esp
  80130d:	eb 17                	jmp    801326 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  80130f:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  801314:	83 ec 04             	sub    $0x4,%esp
  801317:	50                   	push   %eax
  801318:	52                   	push   %edx
  801319:	68 08 50 80 00       	push   $0x805008
  80131e:	e8 39 f5 ff ff       	call   80085c <memmove>
  801323:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  801326:	ba 00 00 00 00       	mov    $0x0,%edx
  80132b:	b8 04 00 00 00       	mov    $0x4,%eax
  801330:	e8 a9 fe ff ff       	call   8011de <fsipc>
	if (result < 0)
		return result;

	return result;
}
  801335:	c9                   	leave  
  801336:	c3                   	ret    

00801337 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	56                   	push   %esi
  80133b:	53                   	push   %ebx
  80133c:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	8b 40 0c             	mov    0xc(%eax),%eax
  801345:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80134a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801350:	ba 00 00 00 00       	mov    $0x0,%edx
  801355:	b8 03 00 00 00       	mov    $0x3,%eax
  80135a:	e8 7f fe ff ff       	call   8011de <fsipc>
  80135f:	89 c3                	mov    %eax,%ebx
  801361:	85 c0                	test   %eax,%eax
  801363:	78 4b                	js     8013b0 <devfile_read+0x79>
		return r;
	assert(r <= n);
  801365:	39 c6                	cmp    %eax,%esi
  801367:	73 16                	jae    80137f <devfile_read+0x48>
  801369:	68 38 21 80 00       	push   $0x802138
  80136e:	68 3f 21 80 00       	push   $0x80213f
  801373:	6a 7c                	push   $0x7c
  801375:	68 54 21 80 00       	push   $0x802154
  80137a:	e8 bd 05 00 00       	call   80193c <_panic>
	assert(r <= PGSIZE);
  80137f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801384:	7e 16                	jle    80139c <devfile_read+0x65>
  801386:	68 5f 21 80 00       	push   $0x80215f
  80138b:	68 3f 21 80 00       	push   $0x80213f
  801390:	6a 7d                	push   $0x7d
  801392:	68 54 21 80 00       	push   $0x802154
  801397:	e8 a0 05 00 00       	call   80193c <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80139c:	83 ec 04             	sub    $0x4,%esp
  80139f:	50                   	push   %eax
  8013a0:	68 00 50 80 00       	push   $0x805000
  8013a5:	ff 75 0c             	pushl  0xc(%ebp)
  8013a8:	e8 af f4 ff ff       	call   80085c <memmove>
	return r;
  8013ad:	83 c4 10             	add    $0x10,%esp
}
  8013b0:	89 d8                	mov    %ebx,%eax
  8013b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013b5:	5b                   	pop    %ebx
  8013b6:	5e                   	pop    %esi
  8013b7:	5d                   	pop    %ebp
  8013b8:	c3                   	ret    

008013b9 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8013b9:	55                   	push   %ebp
  8013ba:	89 e5                	mov    %esp,%ebp
  8013bc:	53                   	push   %ebx
  8013bd:	83 ec 20             	sub    $0x20,%esp
  8013c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8013c3:	53                   	push   %ebx
  8013c4:	e8 c7 f2 ff ff       	call   800690 <strlen>
  8013c9:	83 c4 10             	add    $0x10,%esp
  8013cc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8013d1:	7f 67                	jg     80143a <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8013d3:	83 ec 0c             	sub    $0xc,%esp
  8013d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d9:	50                   	push   %eax
  8013da:	e8 78 f8 ff ff       	call   800c57 <fd_alloc>
  8013df:	83 c4 10             	add    $0x10,%esp
		return r;
  8013e2:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8013e4:	85 c0                	test   %eax,%eax
  8013e6:	78 57                	js     80143f <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8013e8:	83 ec 08             	sub    $0x8,%esp
  8013eb:	53                   	push   %ebx
  8013ec:	68 00 50 80 00       	push   $0x805000
  8013f1:	e8 d3 f2 ff ff       	call   8006c9 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8013f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f9:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8013fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801401:	b8 01 00 00 00       	mov    $0x1,%eax
  801406:	e8 d3 fd ff ff       	call   8011de <fsipc>
  80140b:	89 c3                	mov    %eax,%ebx
  80140d:	83 c4 10             	add    $0x10,%esp
  801410:	85 c0                	test   %eax,%eax
  801412:	79 14                	jns    801428 <open+0x6f>
		fd_close(fd, 0);
  801414:	83 ec 08             	sub    $0x8,%esp
  801417:	6a 00                	push   $0x0
  801419:	ff 75 f4             	pushl  -0xc(%ebp)
  80141c:	e8 2e f9 ff ff       	call   800d4f <fd_close>
		return r;
  801421:	83 c4 10             	add    $0x10,%esp
  801424:	89 da                	mov    %ebx,%edx
  801426:	eb 17                	jmp    80143f <open+0x86>
	}

	return fd2num(fd);
  801428:	83 ec 0c             	sub    $0xc,%esp
  80142b:	ff 75 f4             	pushl  -0xc(%ebp)
  80142e:	e8 fc f7 ff ff       	call   800c2f <fd2num>
  801433:	89 c2                	mov    %eax,%edx
  801435:	83 c4 10             	add    $0x10,%esp
  801438:	eb 05                	jmp    80143f <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80143a:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  80143f:	89 d0                	mov    %edx,%eax
  801441:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801444:	c9                   	leave  
  801445:	c3                   	ret    

00801446 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
  801449:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80144c:	ba 00 00 00 00       	mov    $0x0,%edx
  801451:	b8 08 00 00 00       	mov    $0x8,%eax
  801456:	e8 83 fd ff ff       	call   8011de <fsipc>
}
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	56                   	push   %esi
  801461:	53                   	push   %ebx
  801462:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801465:	83 ec 0c             	sub    $0xc,%esp
  801468:	ff 75 08             	pushl  0x8(%ebp)
  80146b:	e8 cf f7 ff ff       	call   800c3f <fd2data>
  801470:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801472:	83 c4 08             	add    $0x8,%esp
  801475:	68 6b 21 80 00       	push   $0x80216b
  80147a:	53                   	push   %ebx
  80147b:	e8 49 f2 ff ff       	call   8006c9 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801480:	8b 46 04             	mov    0x4(%esi),%eax
  801483:	2b 06                	sub    (%esi),%eax
  801485:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80148b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801492:	00 00 00 
	stat->st_dev = &devpipe;
  801495:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80149c:	30 80 00 
	return 0;
}
  80149f:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014a7:	5b                   	pop    %ebx
  8014a8:	5e                   	pop    %esi
  8014a9:	5d                   	pop    %ebp
  8014aa:	c3                   	ret    

008014ab <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	53                   	push   %ebx
  8014af:	83 ec 0c             	sub    $0xc,%esp
  8014b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8014b5:	53                   	push   %ebx
  8014b6:	6a 00                	push   $0x0
  8014b8:	e8 9f f6 ff ff       	call   800b5c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8014bd:	89 1c 24             	mov    %ebx,(%esp)
  8014c0:	e8 7a f7 ff ff       	call   800c3f <fd2data>
  8014c5:	83 c4 08             	add    $0x8,%esp
  8014c8:	50                   	push   %eax
  8014c9:	6a 00                	push   $0x0
  8014cb:	e8 8c f6 ff ff       	call   800b5c <sys_page_unmap>
}
  8014d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	57                   	push   %edi
  8014d9:	56                   	push   %esi
  8014da:	53                   	push   %ebx
  8014db:	83 ec 1c             	sub    $0x1c,%esp
  8014de:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8014e1:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8014e3:	a1 08 40 80 00       	mov    0x804008,%eax
  8014e8:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  8014eb:	83 ec 0c             	sub    $0xc,%esp
  8014ee:	ff 75 e0             	pushl  -0x20(%ebp)
  8014f1:	e8 84 05 00 00       	call   801a7a <pageref>
  8014f6:	89 c3                	mov    %eax,%ebx
  8014f8:	89 3c 24             	mov    %edi,(%esp)
  8014fb:	e8 7a 05 00 00       	call   801a7a <pageref>
  801500:	83 c4 10             	add    $0x10,%esp
  801503:	39 c3                	cmp    %eax,%ebx
  801505:	0f 94 c1             	sete   %cl
  801508:	0f b6 c9             	movzbl %cl,%ecx
  80150b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  80150e:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801514:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801517:	39 ce                	cmp    %ecx,%esi
  801519:	74 1b                	je     801536 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  80151b:	39 c3                	cmp    %eax,%ebx
  80151d:	75 c4                	jne    8014e3 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80151f:	8b 42 58             	mov    0x58(%edx),%eax
  801522:	ff 75 e4             	pushl  -0x1c(%ebp)
  801525:	50                   	push   %eax
  801526:	56                   	push   %esi
  801527:	68 72 21 80 00       	push   $0x802172
  80152c:	e8 26 ec ff ff       	call   800157 <cprintf>
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	eb ad                	jmp    8014e3 <_pipeisclosed+0xe>
	}
}
  801536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801539:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80153c:	5b                   	pop    %ebx
  80153d:	5e                   	pop    %esi
  80153e:	5f                   	pop    %edi
  80153f:	5d                   	pop    %ebp
  801540:	c3                   	ret    

00801541 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	57                   	push   %edi
  801545:	56                   	push   %esi
  801546:	53                   	push   %ebx
  801547:	83 ec 28             	sub    $0x28,%esp
  80154a:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80154d:	56                   	push   %esi
  80154e:	e8 ec f6 ff ff       	call   800c3f <fd2data>
  801553:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801555:	83 c4 10             	add    $0x10,%esp
  801558:	bf 00 00 00 00       	mov    $0x0,%edi
  80155d:	eb 4b                	jmp    8015aa <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80155f:	89 da                	mov    %ebx,%edx
  801561:	89 f0                	mov    %esi,%eax
  801563:	e8 6d ff ff ff       	call   8014d5 <_pipeisclosed>
  801568:	85 c0                	test   %eax,%eax
  80156a:	75 48                	jne    8015b4 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80156c:	e8 7a f5 ff ff       	call   800aeb <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801571:	8b 43 04             	mov    0x4(%ebx),%eax
  801574:	8b 0b                	mov    (%ebx),%ecx
  801576:	8d 51 20             	lea    0x20(%ecx),%edx
  801579:	39 d0                	cmp    %edx,%eax
  80157b:	73 e2                	jae    80155f <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80157d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801580:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801584:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801587:	89 c2                	mov    %eax,%edx
  801589:	c1 fa 1f             	sar    $0x1f,%edx
  80158c:	89 d1                	mov    %edx,%ecx
  80158e:	c1 e9 1b             	shr    $0x1b,%ecx
  801591:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801594:	83 e2 1f             	and    $0x1f,%edx
  801597:	29 ca                	sub    %ecx,%edx
  801599:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80159d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8015a1:	83 c0 01             	add    $0x1,%eax
  8015a4:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8015a7:	83 c7 01             	add    $0x1,%edi
  8015aa:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8015ad:	75 c2                	jne    801571 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8015af:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b2:	eb 05                	jmp    8015b9 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8015b4:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8015b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015bc:	5b                   	pop    %ebx
  8015bd:	5e                   	pop    %esi
  8015be:	5f                   	pop    %edi
  8015bf:	5d                   	pop    %ebp
  8015c0:	c3                   	ret    

008015c1 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	57                   	push   %edi
  8015c5:	56                   	push   %esi
  8015c6:	53                   	push   %ebx
  8015c7:	83 ec 18             	sub    $0x18,%esp
  8015ca:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8015cd:	57                   	push   %edi
  8015ce:	e8 6c f6 ff ff       	call   800c3f <fd2data>
  8015d3:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8015d5:	83 c4 10             	add    $0x10,%esp
  8015d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015dd:	eb 3d                	jmp    80161c <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8015df:	85 db                	test   %ebx,%ebx
  8015e1:	74 04                	je     8015e7 <devpipe_read+0x26>
				return i;
  8015e3:	89 d8                	mov    %ebx,%eax
  8015e5:	eb 44                	jmp    80162b <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8015e7:	89 f2                	mov    %esi,%edx
  8015e9:	89 f8                	mov    %edi,%eax
  8015eb:	e8 e5 fe ff ff       	call   8014d5 <_pipeisclosed>
  8015f0:	85 c0                	test   %eax,%eax
  8015f2:	75 32                	jne    801626 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8015f4:	e8 f2 f4 ff ff       	call   800aeb <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8015f9:	8b 06                	mov    (%esi),%eax
  8015fb:	3b 46 04             	cmp    0x4(%esi),%eax
  8015fe:	74 df                	je     8015df <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801600:	99                   	cltd   
  801601:	c1 ea 1b             	shr    $0x1b,%edx
  801604:	01 d0                	add    %edx,%eax
  801606:	83 e0 1f             	and    $0x1f,%eax
  801609:	29 d0                	sub    %edx,%eax
  80160b:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801610:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801613:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801616:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801619:	83 c3 01             	add    $0x1,%ebx
  80161c:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  80161f:	75 d8                	jne    8015f9 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	eb 05                	jmp    80162b <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801626:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80162b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80162e:	5b                   	pop    %ebx
  80162f:	5e                   	pop    %esi
  801630:	5f                   	pop    %edi
  801631:	5d                   	pop    %ebp
  801632:	c3                   	ret    

00801633 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	56                   	push   %esi
  801637:	53                   	push   %ebx
  801638:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80163b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80163e:	50                   	push   %eax
  80163f:	e8 13 f6 ff ff       	call   800c57 <fd_alloc>
  801644:	83 c4 10             	add    $0x10,%esp
  801647:	89 c2                	mov    %eax,%edx
  801649:	85 c0                	test   %eax,%eax
  80164b:	0f 88 2c 01 00 00    	js     80177d <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801651:	83 ec 04             	sub    $0x4,%esp
  801654:	68 07 04 00 00       	push   $0x407
  801659:	ff 75 f4             	pushl  -0xc(%ebp)
  80165c:	6a 00                	push   $0x0
  80165e:	e8 af f4 ff ff       	call   800b12 <sys_page_alloc>
  801663:	83 c4 10             	add    $0x10,%esp
  801666:	89 c2                	mov    %eax,%edx
  801668:	85 c0                	test   %eax,%eax
  80166a:	0f 88 0d 01 00 00    	js     80177d <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801670:	83 ec 0c             	sub    $0xc,%esp
  801673:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801676:	50                   	push   %eax
  801677:	e8 db f5 ff ff       	call   800c57 <fd_alloc>
  80167c:	89 c3                	mov    %eax,%ebx
  80167e:	83 c4 10             	add    $0x10,%esp
  801681:	85 c0                	test   %eax,%eax
  801683:	0f 88 e2 00 00 00    	js     80176b <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801689:	83 ec 04             	sub    $0x4,%esp
  80168c:	68 07 04 00 00       	push   $0x407
  801691:	ff 75 f0             	pushl  -0x10(%ebp)
  801694:	6a 00                	push   $0x0
  801696:	e8 77 f4 ff ff       	call   800b12 <sys_page_alloc>
  80169b:	89 c3                	mov    %eax,%ebx
  80169d:	83 c4 10             	add    $0x10,%esp
  8016a0:	85 c0                	test   %eax,%eax
  8016a2:	0f 88 c3 00 00 00    	js     80176b <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8016a8:	83 ec 0c             	sub    $0xc,%esp
  8016ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8016ae:	e8 8c f5 ff ff       	call   800c3f <fd2data>
  8016b3:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8016b5:	83 c4 0c             	add    $0xc,%esp
  8016b8:	68 07 04 00 00       	push   $0x407
  8016bd:	50                   	push   %eax
  8016be:	6a 00                	push   $0x0
  8016c0:	e8 4d f4 ff ff       	call   800b12 <sys_page_alloc>
  8016c5:	89 c3                	mov    %eax,%ebx
  8016c7:	83 c4 10             	add    $0x10,%esp
  8016ca:	85 c0                	test   %eax,%eax
  8016cc:	0f 88 89 00 00 00    	js     80175b <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8016d2:	83 ec 0c             	sub    $0xc,%esp
  8016d5:	ff 75 f0             	pushl  -0x10(%ebp)
  8016d8:	e8 62 f5 ff ff       	call   800c3f <fd2data>
  8016dd:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8016e4:	50                   	push   %eax
  8016e5:	6a 00                	push   $0x0
  8016e7:	56                   	push   %esi
  8016e8:	6a 00                	push   $0x0
  8016ea:	e8 47 f4 ff ff       	call   800b36 <sys_page_map>
  8016ef:	89 c3                	mov    %eax,%ebx
  8016f1:	83 c4 20             	add    $0x20,%esp
  8016f4:	85 c0                	test   %eax,%eax
  8016f6:	78 55                	js     80174d <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8016f8:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8016fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801701:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801706:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  80170d:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801716:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801722:	83 ec 0c             	sub    $0xc,%esp
  801725:	ff 75 f4             	pushl  -0xc(%ebp)
  801728:	e8 02 f5 ff ff       	call   800c2f <fd2num>
  80172d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801730:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801732:	83 c4 04             	add    $0x4,%esp
  801735:	ff 75 f0             	pushl  -0x10(%ebp)
  801738:	e8 f2 f4 ff ff       	call   800c2f <fd2num>
  80173d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801740:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801743:	83 c4 10             	add    $0x10,%esp
  801746:	ba 00 00 00 00       	mov    $0x0,%edx
  80174b:	eb 30                	jmp    80177d <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  80174d:	83 ec 08             	sub    $0x8,%esp
  801750:	56                   	push   %esi
  801751:	6a 00                	push   $0x0
  801753:	e8 04 f4 ff ff       	call   800b5c <sys_page_unmap>
  801758:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  80175b:	83 ec 08             	sub    $0x8,%esp
  80175e:	ff 75 f0             	pushl  -0x10(%ebp)
  801761:	6a 00                	push   $0x0
  801763:	e8 f4 f3 ff ff       	call   800b5c <sys_page_unmap>
  801768:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  80176b:	83 ec 08             	sub    $0x8,%esp
  80176e:	ff 75 f4             	pushl  -0xc(%ebp)
  801771:	6a 00                	push   $0x0
  801773:	e8 e4 f3 ff ff       	call   800b5c <sys_page_unmap>
  801778:	83 c4 10             	add    $0x10,%esp
  80177b:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  80177d:	89 d0                	mov    %edx,%eax
  80177f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801782:	5b                   	pop    %ebx
  801783:	5e                   	pop    %esi
  801784:	5d                   	pop    %ebp
  801785:	c3                   	ret    

00801786 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80178c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80178f:	50                   	push   %eax
  801790:	ff 75 08             	pushl  0x8(%ebp)
  801793:	e8 0e f5 ff ff       	call   800ca6 <fd_lookup>
  801798:	83 c4 10             	add    $0x10,%esp
  80179b:	85 c0                	test   %eax,%eax
  80179d:	78 18                	js     8017b7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  80179f:	83 ec 0c             	sub    $0xc,%esp
  8017a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8017a5:	e8 95 f4 ff ff       	call   800c3f <fd2data>
	return _pipeisclosed(fd, p);
  8017aa:	89 c2                	mov    %eax,%edx
  8017ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017af:	e8 21 fd ff ff       	call   8014d5 <_pipeisclosed>
  8017b4:	83 c4 10             	add    $0x10,%esp
}
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8017bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c1:	5d                   	pop    %ebp
  8017c2:	c3                   	ret    

008017c3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8017c9:	68 8a 21 80 00       	push   $0x80218a
  8017ce:	ff 75 0c             	pushl  0xc(%ebp)
  8017d1:	e8 f3 ee ff ff       	call   8006c9 <strcpy>
	return 0;
}
  8017d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	57                   	push   %edi
  8017e1:	56                   	push   %esi
  8017e2:	53                   	push   %ebx
  8017e3:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8017e9:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8017ee:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8017f4:	eb 2d                	jmp    801823 <devcons_write+0x46>
		m = n - tot;
  8017f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8017f9:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  8017fb:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8017fe:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801803:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801806:	83 ec 04             	sub    $0x4,%esp
  801809:	53                   	push   %ebx
  80180a:	03 45 0c             	add    0xc(%ebp),%eax
  80180d:	50                   	push   %eax
  80180e:	57                   	push   %edi
  80180f:	e8 48 f0 ff ff       	call   80085c <memmove>
		sys_cputs(buf, m);
  801814:	83 c4 08             	add    $0x8,%esp
  801817:	53                   	push   %ebx
  801818:	57                   	push   %edi
  801819:	e8 3d f2 ff ff       	call   800a5b <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80181e:	01 de                	add    %ebx,%esi
  801820:	83 c4 10             	add    $0x10,%esp
  801823:	89 f0                	mov    %esi,%eax
  801825:	3b 75 10             	cmp    0x10(%ebp),%esi
  801828:	72 cc                	jb     8017f6 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80182a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80182d:	5b                   	pop    %ebx
  80182e:	5e                   	pop    %esi
  80182f:	5f                   	pop    %edi
  801830:	5d                   	pop    %ebp
  801831:	c3                   	ret    

00801832 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	83 ec 08             	sub    $0x8,%esp
  801838:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  80183d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801841:	74 2a                	je     80186d <devcons_read+0x3b>
  801843:	eb 05                	jmp    80184a <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801845:	e8 a1 f2 ff ff       	call   800aeb <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80184a:	e8 32 f2 ff ff       	call   800a81 <sys_cgetc>
  80184f:	85 c0                	test   %eax,%eax
  801851:	74 f2                	je     801845 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801853:	85 c0                	test   %eax,%eax
  801855:	78 16                	js     80186d <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801857:	83 f8 04             	cmp    $0x4,%eax
  80185a:	74 0c                	je     801868 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80185c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185f:	88 02                	mov    %al,(%edx)
	return 1;
  801861:	b8 01 00 00 00       	mov    $0x1,%eax
  801866:	eb 05                	jmp    80186d <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801868:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801875:	8b 45 08             	mov    0x8(%ebp),%eax
  801878:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80187b:	6a 01                	push   $0x1
  80187d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801880:	50                   	push   %eax
  801881:	e8 d5 f1 ff ff       	call   800a5b <sys_cputs>
}
  801886:	83 c4 10             	add    $0x10,%esp
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <getchar>:

int
getchar(void)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
  80188e:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801891:	6a 01                	push   $0x1
  801893:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801896:	50                   	push   %eax
  801897:	6a 00                	push   $0x0
  801899:	e8 6d f6 ff ff       	call   800f0b <read>
	if (r < 0)
  80189e:	83 c4 10             	add    $0x10,%esp
  8018a1:	85 c0                	test   %eax,%eax
  8018a3:	78 0f                	js     8018b4 <getchar+0x29>
		return r;
	if (r < 1)
  8018a5:	85 c0                	test   %eax,%eax
  8018a7:	7e 06                	jle    8018af <getchar+0x24>
		return -E_EOF;
	return c;
  8018a9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8018ad:	eb 05                	jmp    8018b4 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8018af:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018bf:	50                   	push   %eax
  8018c0:	ff 75 08             	pushl  0x8(%ebp)
  8018c3:	e8 de f3 ff ff       	call   800ca6 <fd_lookup>
  8018c8:	83 c4 10             	add    $0x10,%esp
  8018cb:	85 c0                	test   %eax,%eax
  8018cd:	78 11                	js     8018e0 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8018cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8018d8:	39 10                	cmp    %edx,(%eax)
  8018da:	0f 94 c0             	sete   %al
  8018dd:	0f b6 c0             	movzbl %al,%eax
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <opencons>:

int
opencons(void)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8018e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018eb:	50                   	push   %eax
  8018ec:	e8 66 f3 ff ff       	call   800c57 <fd_alloc>
  8018f1:	83 c4 10             	add    $0x10,%esp
		return r;
  8018f4:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8018f6:	85 c0                	test   %eax,%eax
  8018f8:	78 3e                	js     801938 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8018fa:	83 ec 04             	sub    $0x4,%esp
  8018fd:	68 07 04 00 00       	push   $0x407
  801902:	ff 75 f4             	pushl  -0xc(%ebp)
  801905:	6a 00                	push   $0x0
  801907:	e8 06 f2 ff ff       	call   800b12 <sys_page_alloc>
  80190c:	83 c4 10             	add    $0x10,%esp
		return r;
  80190f:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801911:	85 c0                	test   %eax,%eax
  801913:	78 23                	js     801938 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801915:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80191b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801923:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80192a:	83 ec 0c             	sub    $0xc,%esp
  80192d:	50                   	push   %eax
  80192e:	e8 fc f2 ff ff       	call   800c2f <fd2num>
  801933:	89 c2                	mov    %eax,%edx
  801935:	83 c4 10             	add    $0x10,%esp
}
  801938:	89 d0                	mov    %edx,%eax
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	56                   	push   %esi
  801940:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801941:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801944:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80194a:	e8 78 f1 ff ff       	call   800ac7 <sys_getenvid>
  80194f:	83 ec 0c             	sub    $0xc,%esp
  801952:	ff 75 0c             	pushl  0xc(%ebp)
  801955:	ff 75 08             	pushl  0x8(%ebp)
  801958:	56                   	push   %esi
  801959:	50                   	push   %eax
  80195a:	68 98 21 80 00       	push   $0x802198
  80195f:	e8 f3 e7 ff ff       	call   800157 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801964:	83 c4 18             	add    $0x18,%esp
  801967:	53                   	push   %ebx
  801968:	ff 75 10             	pushl  0x10(%ebp)
  80196b:	e8 96 e7 ff ff       	call   800106 <vcprintf>
	cprintf("\n");
  801970:	c7 04 24 6c 1d 80 00 	movl   $0x801d6c,(%esp)
  801977:	e8 db e7 ff ff       	call   800157 <cprintf>
  80197c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80197f:	cc                   	int3   
  801980:	eb fd                	jmp    80197f <_panic+0x43>

00801982 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	56                   	push   %esi
  801986:	53                   	push   %ebx
  801987:	8b 75 08             	mov    0x8(%ebp),%esi
  80198a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801990:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801992:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801997:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  80199a:	83 ec 0c             	sub    $0xc,%esp
  80199d:	50                   	push   %eax
  80199e:	e8 6a f2 ff ff       	call   800c0d <sys_ipc_recv>
	if (from_env_store)
  8019a3:	83 c4 10             	add    $0x10,%esp
  8019a6:	85 f6                	test   %esi,%esi
  8019a8:	74 0b                	je     8019b5 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  8019aa:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8019b0:	8b 52 74             	mov    0x74(%edx),%edx
  8019b3:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8019b5:	85 db                	test   %ebx,%ebx
  8019b7:	74 0b                	je     8019c4 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  8019b9:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8019bf:	8b 52 78             	mov    0x78(%edx),%edx
  8019c2:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  8019c4:	85 c0                	test   %eax,%eax
  8019c6:	79 16                	jns    8019de <ipc_recv+0x5c>
		if (from_env_store)
  8019c8:	85 f6                	test   %esi,%esi
  8019ca:	74 06                	je     8019d2 <ipc_recv+0x50>
			*from_env_store = 0;
  8019cc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  8019d2:	85 db                	test   %ebx,%ebx
  8019d4:	74 10                	je     8019e6 <ipc_recv+0x64>
			*perm_store = 0;
  8019d6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8019dc:	eb 08                	jmp    8019e6 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  8019de:	a1 08 40 80 00       	mov    0x804008,%eax
  8019e3:	8b 40 70             	mov    0x70(%eax),%eax
}
  8019e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019e9:	5b                   	pop    %ebx
  8019ea:	5e                   	pop    %esi
  8019eb:	5d                   	pop    %ebp
  8019ec:	c3                   	ret    

008019ed <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
  8019f0:	57                   	push   %edi
  8019f1:	56                   	push   %esi
  8019f2:	53                   	push   %ebx
  8019f3:	83 ec 0c             	sub    $0xc,%esp
  8019f6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019f9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  8019ff:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  801a01:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801a06:	0f 44 d8             	cmove  %eax,%ebx
  801a09:	eb 1c                	jmp    801a27 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  801a0b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801a0e:	74 12                	je     801a22 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801a10:	50                   	push   %eax
  801a11:	68 bc 21 80 00       	push   $0x8021bc
  801a16:	6a 42                	push   $0x42
  801a18:	68 d2 21 80 00       	push   $0x8021d2
  801a1d:	e8 1a ff ff ff       	call   80193c <_panic>
		sys_yield();
  801a22:	e8 c4 f0 ff ff       	call   800aeb <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801a27:	ff 75 14             	pushl  0x14(%ebp)
  801a2a:	53                   	push   %ebx
  801a2b:	56                   	push   %esi
  801a2c:	57                   	push   %edi
  801a2d:	e8 b6 f1 ff ff       	call   800be8 <sys_ipc_try_send>
  801a32:	83 c4 10             	add    $0x10,%esp
  801a35:	85 c0                	test   %eax,%eax
  801a37:	75 d2                	jne    801a0b <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801a39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a3c:	5b                   	pop    %ebx
  801a3d:	5e                   	pop    %esi
  801a3e:	5f                   	pop    %edi
  801a3f:	5d                   	pop    %ebp
  801a40:	c3                   	ret    

00801a41 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801a47:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801a4c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801a4f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801a55:	8b 52 50             	mov    0x50(%edx),%edx
  801a58:	39 ca                	cmp    %ecx,%edx
  801a5a:	75 0d                	jne    801a69 <ipc_find_env+0x28>
			return envs[i].env_id;
  801a5c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a5f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a64:	8b 40 48             	mov    0x48(%eax),%eax
  801a67:	eb 0f                	jmp    801a78 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801a69:	83 c0 01             	add    $0x1,%eax
  801a6c:	3d 00 04 00 00       	cmp    $0x400,%eax
  801a71:	75 d9                	jne    801a4c <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801a73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a78:	5d                   	pop    %ebp
  801a79:	c3                   	ret    

00801a7a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a80:	89 d0                	mov    %edx,%eax
  801a82:	c1 e8 16             	shr    $0x16,%eax
  801a85:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801a8c:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a91:	f6 c1 01             	test   $0x1,%cl
  801a94:	74 1d                	je     801ab3 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801a96:	c1 ea 0c             	shr    $0xc,%edx
  801a99:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801aa0:	f6 c2 01             	test   $0x1,%dl
  801aa3:	74 0e                	je     801ab3 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801aa5:	c1 ea 0c             	shr    $0xc,%edx
  801aa8:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801aaf:	ef 
  801ab0:	0f b7 c0             	movzwl %ax,%eax
}
  801ab3:	5d                   	pop    %ebp
  801ab4:	c3                   	ret    
  801ab5:	66 90                	xchg   %ax,%ax
  801ab7:	66 90                	xchg   %ax,%ax
  801ab9:	66 90                	xchg   %ax,%ax
  801abb:	66 90                	xchg   %ax,%ax
  801abd:	66 90                	xchg   %ax,%ax
  801abf:	90                   	nop

00801ac0 <__udivdi3>:
  801ac0:	55                   	push   %ebp
  801ac1:	57                   	push   %edi
  801ac2:	56                   	push   %esi
  801ac3:	53                   	push   %ebx
  801ac4:	83 ec 1c             	sub    $0x1c,%esp
  801ac7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801acb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801acf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ad3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ad7:	85 f6                	test   %esi,%esi
  801ad9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801add:	89 ca                	mov    %ecx,%edx
  801adf:	89 f8                	mov    %edi,%eax
  801ae1:	75 3d                	jne    801b20 <__udivdi3+0x60>
  801ae3:	39 cf                	cmp    %ecx,%edi
  801ae5:	0f 87 c5 00 00 00    	ja     801bb0 <__udivdi3+0xf0>
  801aeb:	85 ff                	test   %edi,%edi
  801aed:	89 fd                	mov    %edi,%ebp
  801aef:	75 0b                	jne    801afc <__udivdi3+0x3c>
  801af1:	b8 01 00 00 00       	mov    $0x1,%eax
  801af6:	31 d2                	xor    %edx,%edx
  801af8:	f7 f7                	div    %edi
  801afa:	89 c5                	mov    %eax,%ebp
  801afc:	89 c8                	mov    %ecx,%eax
  801afe:	31 d2                	xor    %edx,%edx
  801b00:	f7 f5                	div    %ebp
  801b02:	89 c1                	mov    %eax,%ecx
  801b04:	89 d8                	mov    %ebx,%eax
  801b06:	89 cf                	mov    %ecx,%edi
  801b08:	f7 f5                	div    %ebp
  801b0a:	89 c3                	mov    %eax,%ebx
  801b0c:	89 d8                	mov    %ebx,%eax
  801b0e:	89 fa                	mov    %edi,%edx
  801b10:	83 c4 1c             	add    $0x1c,%esp
  801b13:	5b                   	pop    %ebx
  801b14:	5e                   	pop    %esi
  801b15:	5f                   	pop    %edi
  801b16:	5d                   	pop    %ebp
  801b17:	c3                   	ret    
  801b18:	90                   	nop
  801b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801b20:	39 ce                	cmp    %ecx,%esi
  801b22:	77 74                	ja     801b98 <__udivdi3+0xd8>
  801b24:	0f bd fe             	bsr    %esi,%edi
  801b27:	83 f7 1f             	xor    $0x1f,%edi
  801b2a:	0f 84 98 00 00 00    	je     801bc8 <__udivdi3+0x108>
  801b30:	bb 20 00 00 00       	mov    $0x20,%ebx
  801b35:	89 f9                	mov    %edi,%ecx
  801b37:	89 c5                	mov    %eax,%ebp
  801b39:	29 fb                	sub    %edi,%ebx
  801b3b:	d3 e6                	shl    %cl,%esi
  801b3d:	89 d9                	mov    %ebx,%ecx
  801b3f:	d3 ed                	shr    %cl,%ebp
  801b41:	89 f9                	mov    %edi,%ecx
  801b43:	d3 e0                	shl    %cl,%eax
  801b45:	09 ee                	or     %ebp,%esi
  801b47:	89 d9                	mov    %ebx,%ecx
  801b49:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b4d:	89 d5                	mov    %edx,%ebp
  801b4f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b53:	d3 ed                	shr    %cl,%ebp
  801b55:	89 f9                	mov    %edi,%ecx
  801b57:	d3 e2                	shl    %cl,%edx
  801b59:	89 d9                	mov    %ebx,%ecx
  801b5b:	d3 e8                	shr    %cl,%eax
  801b5d:	09 c2                	or     %eax,%edx
  801b5f:	89 d0                	mov    %edx,%eax
  801b61:	89 ea                	mov    %ebp,%edx
  801b63:	f7 f6                	div    %esi
  801b65:	89 d5                	mov    %edx,%ebp
  801b67:	89 c3                	mov    %eax,%ebx
  801b69:	f7 64 24 0c          	mull   0xc(%esp)
  801b6d:	39 d5                	cmp    %edx,%ebp
  801b6f:	72 10                	jb     801b81 <__udivdi3+0xc1>
  801b71:	8b 74 24 08          	mov    0x8(%esp),%esi
  801b75:	89 f9                	mov    %edi,%ecx
  801b77:	d3 e6                	shl    %cl,%esi
  801b79:	39 c6                	cmp    %eax,%esi
  801b7b:	73 07                	jae    801b84 <__udivdi3+0xc4>
  801b7d:	39 d5                	cmp    %edx,%ebp
  801b7f:	75 03                	jne    801b84 <__udivdi3+0xc4>
  801b81:	83 eb 01             	sub    $0x1,%ebx
  801b84:	31 ff                	xor    %edi,%edi
  801b86:	89 d8                	mov    %ebx,%eax
  801b88:	89 fa                	mov    %edi,%edx
  801b8a:	83 c4 1c             	add    $0x1c,%esp
  801b8d:	5b                   	pop    %ebx
  801b8e:	5e                   	pop    %esi
  801b8f:	5f                   	pop    %edi
  801b90:	5d                   	pop    %ebp
  801b91:	c3                   	ret    
  801b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801b98:	31 ff                	xor    %edi,%edi
  801b9a:	31 db                	xor    %ebx,%ebx
  801b9c:	89 d8                	mov    %ebx,%eax
  801b9e:	89 fa                	mov    %edi,%edx
  801ba0:	83 c4 1c             	add    $0x1c,%esp
  801ba3:	5b                   	pop    %ebx
  801ba4:	5e                   	pop    %esi
  801ba5:	5f                   	pop    %edi
  801ba6:	5d                   	pop    %ebp
  801ba7:	c3                   	ret    
  801ba8:	90                   	nop
  801ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801bb0:	89 d8                	mov    %ebx,%eax
  801bb2:	f7 f7                	div    %edi
  801bb4:	31 ff                	xor    %edi,%edi
  801bb6:	89 c3                	mov    %eax,%ebx
  801bb8:	89 d8                	mov    %ebx,%eax
  801bba:	89 fa                	mov    %edi,%edx
  801bbc:	83 c4 1c             	add    $0x1c,%esp
  801bbf:	5b                   	pop    %ebx
  801bc0:	5e                   	pop    %esi
  801bc1:	5f                   	pop    %edi
  801bc2:	5d                   	pop    %ebp
  801bc3:	c3                   	ret    
  801bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801bc8:	39 ce                	cmp    %ecx,%esi
  801bca:	72 0c                	jb     801bd8 <__udivdi3+0x118>
  801bcc:	31 db                	xor    %ebx,%ebx
  801bce:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bd2:	0f 87 34 ff ff ff    	ja     801b0c <__udivdi3+0x4c>
  801bd8:	bb 01 00 00 00       	mov    $0x1,%ebx
  801bdd:	e9 2a ff ff ff       	jmp    801b0c <__udivdi3+0x4c>
  801be2:	66 90                	xchg   %ax,%ax
  801be4:	66 90                	xchg   %ax,%ax
  801be6:	66 90                	xchg   %ax,%ax
  801be8:	66 90                	xchg   %ax,%ax
  801bea:	66 90                	xchg   %ax,%ax
  801bec:	66 90                	xchg   %ax,%ax
  801bee:	66 90                	xchg   %ax,%ax

00801bf0 <__umoddi3>:
  801bf0:	55                   	push   %ebp
  801bf1:	57                   	push   %edi
  801bf2:	56                   	push   %esi
  801bf3:	53                   	push   %ebx
  801bf4:	83 ec 1c             	sub    $0x1c,%esp
  801bf7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801bfb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bff:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c07:	85 d2                	test   %edx,%edx
  801c09:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c11:	89 f3                	mov    %esi,%ebx
  801c13:	89 3c 24             	mov    %edi,(%esp)
  801c16:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c1a:	75 1c                	jne    801c38 <__umoddi3+0x48>
  801c1c:	39 f7                	cmp    %esi,%edi
  801c1e:	76 50                	jbe    801c70 <__umoddi3+0x80>
  801c20:	89 c8                	mov    %ecx,%eax
  801c22:	89 f2                	mov    %esi,%edx
  801c24:	f7 f7                	div    %edi
  801c26:	89 d0                	mov    %edx,%eax
  801c28:	31 d2                	xor    %edx,%edx
  801c2a:	83 c4 1c             	add    $0x1c,%esp
  801c2d:	5b                   	pop    %ebx
  801c2e:	5e                   	pop    %esi
  801c2f:	5f                   	pop    %edi
  801c30:	5d                   	pop    %ebp
  801c31:	c3                   	ret    
  801c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c38:	39 f2                	cmp    %esi,%edx
  801c3a:	89 d0                	mov    %edx,%eax
  801c3c:	77 52                	ja     801c90 <__umoddi3+0xa0>
  801c3e:	0f bd ea             	bsr    %edx,%ebp
  801c41:	83 f5 1f             	xor    $0x1f,%ebp
  801c44:	75 5a                	jne    801ca0 <__umoddi3+0xb0>
  801c46:	3b 54 24 04          	cmp    0x4(%esp),%edx
  801c4a:	0f 82 e0 00 00 00    	jb     801d30 <__umoddi3+0x140>
  801c50:	39 0c 24             	cmp    %ecx,(%esp)
  801c53:	0f 86 d7 00 00 00    	jbe    801d30 <__umoddi3+0x140>
  801c59:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c5d:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c61:	83 c4 1c             	add    $0x1c,%esp
  801c64:	5b                   	pop    %ebx
  801c65:	5e                   	pop    %esi
  801c66:	5f                   	pop    %edi
  801c67:	5d                   	pop    %ebp
  801c68:	c3                   	ret    
  801c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c70:	85 ff                	test   %edi,%edi
  801c72:	89 fd                	mov    %edi,%ebp
  801c74:	75 0b                	jne    801c81 <__umoddi3+0x91>
  801c76:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7b:	31 d2                	xor    %edx,%edx
  801c7d:	f7 f7                	div    %edi
  801c7f:	89 c5                	mov    %eax,%ebp
  801c81:	89 f0                	mov    %esi,%eax
  801c83:	31 d2                	xor    %edx,%edx
  801c85:	f7 f5                	div    %ebp
  801c87:	89 c8                	mov    %ecx,%eax
  801c89:	f7 f5                	div    %ebp
  801c8b:	89 d0                	mov    %edx,%eax
  801c8d:	eb 99                	jmp    801c28 <__umoddi3+0x38>
  801c8f:	90                   	nop
  801c90:	89 c8                	mov    %ecx,%eax
  801c92:	89 f2                	mov    %esi,%edx
  801c94:	83 c4 1c             	add    $0x1c,%esp
  801c97:	5b                   	pop    %ebx
  801c98:	5e                   	pop    %esi
  801c99:	5f                   	pop    %edi
  801c9a:	5d                   	pop    %ebp
  801c9b:	c3                   	ret    
  801c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ca0:	8b 34 24             	mov    (%esp),%esi
  801ca3:	bf 20 00 00 00       	mov    $0x20,%edi
  801ca8:	89 e9                	mov    %ebp,%ecx
  801caa:	29 ef                	sub    %ebp,%edi
  801cac:	d3 e0                	shl    %cl,%eax
  801cae:	89 f9                	mov    %edi,%ecx
  801cb0:	89 f2                	mov    %esi,%edx
  801cb2:	d3 ea                	shr    %cl,%edx
  801cb4:	89 e9                	mov    %ebp,%ecx
  801cb6:	09 c2                	or     %eax,%edx
  801cb8:	89 d8                	mov    %ebx,%eax
  801cba:	89 14 24             	mov    %edx,(%esp)
  801cbd:	89 f2                	mov    %esi,%edx
  801cbf:	d3 e2                	shl    %cl,%edx
  801cc1:	89 f9                	mov    %edi,%ecx
  801cc3:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cc7:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801ccb:	d3 e8                	shr    %cl,%eax
  801ccd:	89 e9                	mov    %ebp,%ecx
  801ccf:	89 c6                	mov    %eax,%esi
  801cd1:	d3 e3                	shl    %cl,%ebx
  801cd3:	89 f9                	mov    %edi,%ecx
  801cd5:	89 d0                	mov    %edx,%eax
  801cd7:	d3 e8                	shr    %cl,%eax
  801cd9:	89 e9                	mov    %ebp,%ecx
  801cdb:	09 d8                	or     %ebx,%eax
  801cdd:	89 d3                	mov    %edx,%ebx
  801cdf:	89 f2                	mov    %esi,%edx
  801ce1:	f7 34 24             	divl   (%esp)
  801ce4:	89 d6                	mov    %edx,%esi
  801ce6:	d3 e3                	shl    %cl,%ebx
  801ce8:	f7 64 24 04          	mull   0x4(%esp)
  801cec:	39 d6                	cmp    %edx,%esi
  801cee:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cf2:	89 d1                	mov    %edx,%ecx
  801cf4:	89 c3                	mov    %eax,%ebx
  801cf6:	72 08                	jb     801d00 <__umoddi3+0x110>
  801cf8:	75 11                	jne    801d0b <__umoddi3+0x11b>
  801cfa:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801cfe:	73 0b                	jae    801d0b <__umoddi3+0x11b>
  801d00:	2b 44 24 04          	sub    0x4(%esp),%eax
  801d04:	1b 14 24             	sbb    (%esp),%edx
  801d07:	89 d1                	mov    %edx,%ecx
  801d09:	89 c3                	mov    %eax,%ebx
  801d0b:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d0f:	29 da                	sub    %ebx,%edx
  801d11:	19 ce                	sbb    %ecx,%esi
  801d13:	89 f9                	mov    %edi,%ecx
  801d15:	89 f0                	mov    %esi,%eax
  801d17:	d3 e0                	shl    %cl,%eax
  801d19:	89 e9                	mov    %ebp,%ecx
  801d1b:	d3 ea                	shr    %cl,%edx
  801d1d:	89 e9                	mov    %ebp,%ecx
  801d1f:	d3 ee                	shr    %cl,%esi
  801d21:	09 d0                	or     %edx,%eax
  801d23:	89 f2                	mov    %esi,%edx
  801d25:	83 c4 1c             	add    $0x1c,%esp
  801d28:	5b                   	pop    %ebx
  801d29:	5e                   	pop    %esi
  801d2a:	5f                   	pop    %edi
  801d2b:	5d                   	pop    %ebp
  801d2c:	c3                   	ret    
  801d2d:	8d 76 00             	lea    0x0(%esi),%esi
  801d30:	29 f9                	sub    %edi,%ecx
  801d32:	19 d6                	sbb    %edx,%esi
  801d34:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d38:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d3c:	e9 18 ff ff ff       	jmp    801c59 <__umoddi3+0x69>
