
obj/user/faultreadkernel.debug:     formato del fichero elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
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
	cprintf("I read %08x from location 0xf0100000!\n", *(unsigned*)0xf0100000);
  800039:	ff 35 00 00 10 f0    	pushl  0xf0100000
  80003f:	68 40 1d 80 00       	push   $0x801d40
  800044:	e8 fc 00 00 00       	call   800145 <cprintf>
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
	envid_t id = sys_getenvid();
  800059:	e8 57 0a 00 00       	call   800ab5 <sys_getenvid>
	if (id >= 0)
  80005e:	85 c0                	test   %eax,%eax
  800060:	78 12                	js     800074 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  800062:	25 ff 03 00 00       	and    $0x3ff,%eax
  800067:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006f:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800074:	85 db                	test   %ebx,%ebx
  800076:	7e 07                	jle    80007f <libmain+0x31>
		binaryname = argv[0];
  800078:	8b 06                	mov    (%esi),%eax
  80007a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80007f:	83 ec 08             	sub    $0x8,%esp
  800082:	56                   	push   %esi
  800083:	53                   	push   %ebx
  800084:	e8 aa ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800089:	e8 0a 00 00 00       	call   800098 <exit>
}
  80008e:	83 c4 10             	add    $0x10,%esp
  800091:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800094:	5b                   	pop    %ebx
  800095:	5e                   	pop    %esi
  800096:	5d                   	pop    %ebp
  800097:	c3                   	ret    

00800098 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800098:	55                   	push   %ebp
  800099:	89 e5                	mov    %esp,%ebp
  80009b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80009e:	e8 45 0d 00 00       	call   800de8 <close_all>
	sys_env_destroy(0);
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	6a 00                	push   $0x0
  8000a8:	e8 e6 09 00 00       	call   800a93 <sys_env_destroy>
}
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	c9                   	leave  
  8000b1:	c3                   	ret    

008000b2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000b2:	55                   	push   %ebp
  8000b3:	89 e5                	mov    %esp,%ebp
  8000b5:	53                   	push   %ebx
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000bc:	8b 13                	mov    (%ebx),%edx
  8000be:	8d 42 01             	lea    0x1(%edx),%eax
  8000c1:	89 03                	mov    %eax,(%ebx)
  8000c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000c6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000ca:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000cf:	75 1a                	jne    8000eb <putch+0x39>
		sys_cputs(b->buf, b->idx);
  8000d1:	83 ec 08             	sub    $0x8,%esp
  8000d4:	68 ff 00 00 00       	push   $0xff
  8000d9:	8d 43 08             	lea    0x8(%ebx),%eax
  8000dc:	50                   	push   %eax
  8000dd:	e8 67 09 00 00       	call   800a49 <sys_cputs>
		b->idx = 0;
  8000e2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000e8:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  8000eb:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f2:	c9                   	leave  
  8000f3:	c3                   	ret    

008000f4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8000fd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800104:	00 00 00 
	b.cnt = 0;
  800107:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80010e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800111:	ff 75 0c             	pushl  0xc(%ebp)
  800114:	ff 75 08             	pushl  0x8(%ebp)
  800117:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80011d:	50                   	push   %eax
  80011e:	68 b2 00 80 00       	push   $0x8000b2
  800123:	e8 86 01 00 00       	call   8002ae <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800128:	83 c4 08             	add    $0x8,%esp
  80012b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800131:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800137:	50                   	push   %eax
  800138:	e8 0c 09 00 00       	call   800a49 <sys_cputs>

	return b.cnt;
}
  80013d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800143:	c9                   	leave  
  800144:	c3                   	ret    

00800145 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800145:	55                   	push   %ebp
  800146:	89 e5                	mov    %esp,%ebp
  800148:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80014b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80014e:	50                   	push   %eax
  80014f:	ff 75 08             	pushl  0x8(%ebp)
  800152:	e8 9d ff ff ff       	call   8000f4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800157:	c9                   	leave  
  800158:	c3                   	ret    

00800159 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	57                   	push   %edi
  80015d:	56                   	push   %esi
  80015e:	53                   	push   %ebx
  80015f:	83 ec 1c             	sub    $0x1c,%esp
  800162:	89 c7                	mov    %eax,%edi
  800164:	89 d6                	mov    %edx,%esi
  800166:	8b 45 08             	mov    0x8(%ebp),%eax
  800169:	8b 55 0c             	mov    0xc(%ebp),%edx
  80016c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80016f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800172:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800175:	bb 00 00 00 00       	mov    $0x0,%ebx
  80017a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80017d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800180:	39 d3                	cmp    %edx,%ebx
  800182:	72 05                	jb     800189 <printnum+0x30>
  800184:	39 45 10             	cmp    %eax,0x10(%ebp)
  800187:	77 45                	ja     8001ce <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800189:	83 ec 0c             	sub    $0xc,%esp
  80018c:	ff 75 18             	pushl  0x18(%ebp)
  80018f:	8b 45 14             	mov    0x14(%ebp),%eax
  800192:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800195:	53                   	push   %ebx
  800196:	ff 75 10             	pushl  0x10(%ebp)
  800199:	83 ec 08             	sub    $0x8,%esp
  80019c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80019f:	ff 75 e0             	pushl  -0x20(%ebp)
  8001a2:	ff 75 dc             	pushl  -0x24(%ebp)
  8001a5:	ff 75 d8             	pushl  -0x28(%ebp)
  8001a8:	e8 03 19 00 00       	call   801ab0 <__udivdi3>
  8001ad:	83 c4 18             	add    $0x18,%esp
  8001b0:	52                   	push   %edx
  8001b1:	50                   	push   %eax
  8001b2:	89 f2                	mov    %esi,%edx
  8001b4:	89 f8                	mov    %edi,%eax
  8001b6:	e8 9e ff ff ff       	call   800159 <printnum>
  8001bb:	83 c4 20             	add    $0x20,%esp
  8001be:	eb 18                	jmp    8001d8 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	56                   	push   %esi
  8001c4:	ff 75 18             	pushl  0x18(%ebp)
  8001c7:	ff d7                	call   *%edi
  8001c9:	83 c4 10             	add    $0x10,%esp
  8001cc:	eb 03                	jmp    8001d1 <printnum+0x78>
  8001ce:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001d1:	83 eb 01             	sub    $0x1,%ebx
  8001d4:	85 db                	test   %ebx,%ebx
  8001d6:	7f e8                	jg     8001c0 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001d8:	83 ec 08             	sub    $0x8,%esp
  8001db:	56                   	push   %esi
  8001dc:	83 ec 04             	sub    $0x4,%esp
  8001df:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001e2:	ff 75 e0             	pushl  -0x20(%ebp)
  8001e5:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e8:	ff 75 d8             	pushl  -0x28(%ebp)
  8001eb:	e8 f0 19 00 00       	call   801be0 <__umoddi3>
  8001f0:	83 c4 14             	add    $0x14,%esp
  8001f3:	0f be 80 71 1d 80 00 	movsbl 0x801d71(%eax),%eax
  8001fa:	50                   	push   %eax
  8001fb:	ff d7                	call   *%edi
}
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800203:	5b                   	pop    %ebx
  800204:	5e                   	pop    %esi
  800205:	5f                   	pop    %edi
  800206:	5d                   	pop    %ebp
  800207:	c3                   	ret    

00800208 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80020b:	83 fa 01             	cmp    $0x1,%edx
  80020e:	7e 0e                	jle    80021e <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800210:	8b 10                	mov    (%eax),%edx
  800212:	8d 4a 08             	lea    0x8(%edx),%ecx
  800215:	89 08                	mov    %ecx,(%eax)
  800217:	8b 02                	mov    (%edx),%eax
  800219:	8b 52 04             	mov    0x4(%edx),%edx
  80021c:	eb 22                	jmp    800240 <getuint+0x38>
	else if (lflag)
  80021e:	85 d2                	test   %edx,%edx
  800220:	74 10                	je     800232 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800222:	8b 10                	mov    (%eax),%edx
  800224:	8d 4a 04             	lea    0x4(%edx),%ecx
  800227:	89 08                	mov    %ecx,(%eax)
  800229:	8b 02                	mov    (%edx),%eax
  80022b:	ba 00 00 00 00       	mov    $0x0,%edx
  800230:	eb 0e                	jmp    800240 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800232:	8b 10                	mov    (%eax),%edx
  800234:	8d 4a 04             	lea    0x4(%edx),%ecx
  800237:	89 08                	mov    %ecx,(%eax)
  800239:	8b 02                	mov    (%edx),%eax
  80023b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800240:	5d                   	pop    %ebp
  800241:	c3                   	ret    

00800242 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800242:	55                   	push   %ebp
  800243:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800245:	83 fa 01             	cmp    $0x1,%edx
  800248:	7e 0e                	jle    800258 <getint+0x16>
		return va_arg(*ap, long long);
  80024a:	8b 10                	mov    (%eax),%edx
  80024c:	8d 4a 08             	lea    0x8(%edx),%ecx
  80024f:	89 08                	mov    %ecx,(%eax)
  800251:	8b 02                	mov    (%edx),%eax
  800253:	8b 52 04             	mov    0x4(%edx),%edx
  800256:	eb 1a                	jmp    800272 <getint+0x30>
	else if (lflag)
  800258:	85 d2                	test   %edx,%edx
  80025a:	74 0c                	je     800268 <getint+0x26>
		return va_arg(*ap, long);
  80025c:	8b 10                	mov    (%eax),%edx
  80025e:	8d 4a 04             	lea    0x4(%edx),%ecx
  800261:	89 08                	mov    %ecx,(%eax)
  800263:	8b 02                	mov    (%edx),%eax
  800265:	99                   	cltd   
  800266:	eb 0a                	jmp    800272 <getint+0x30>
	else
		return va_arg(*ap, int);
  800268:	8b 10                	mov    (%eax),%edx
  80026a:	8d 4a 04             	lea    0x4(%edx),%ecx
  80026d:	89 08                	mov    %ecx,(%eax)
  80026f:	8b 02                	mov    (%edx),%eax
  800271:	99                   	cltd   
}
  800272:	5d                   	pop    %ebp
  800273:	c3                   	ret    

00800274 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80027a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80027e:	8b 10                	mov    (%eax),%edx
  800280:	3b 50 04             	cmp    0x4(%eax),%edx
  800283:	73 0a                	jae    80028f <sprintputch+0x1b>
		*b->buf++ = ch;
  800285:	8d 4a 01             	lea    0x1(%edx),%ecx
  800288:	89 08                	mov    %ecx,(%eax)
  80028a:	8b 45 08             	mov    0x8(%ebp),%eax
  80028d:	88 02                	mov    %al,(%edx)
}
  80028f:	5d                   	pop    %ebp
  800290:	c3                   	ret    

00800291 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800291:	55                   	push   %ebp
  800292:	89 e5                	mov    %esp,%ebp
  800294:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800297:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80029a:	50                   	push   %eax
  80029b:	ff 75 10             	pushl  0x10(%ebp)
  80029e:	ff 75 0c             	pushl  0xc(%ebp)
  8002a1:	ff 75 08             	pushl  0x8(%ebp)
  8002a4:	e8 05 00 00 00       	call   8002ae <vprintfmt>
	va_end(ap);
}
  8002a9:	83 c4 10             	add    $0x10,%esp
  8002ac:	c9                   	leave  
  8002ad:	c3                   	ret    

008002ae <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002ae:	55                   	push   %ebp
  8002af:	89 e5                	mov    %esp,%ebp
  8002b1:	57                   	push   %edi
  8002b2:	56                   	push   %esi
  8002b3:	53                   	push   %ebx
  8002b4:	83 ec 2c             	sub    $0x2c,%esp
  8002b7:	8b 75 08             	mov    0x8(%ebp),%esi
  8002ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002bd:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002c0:	eb 12                	jmp    8002d4 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8002c2:	85 c0                	test   %eax,%eax
  8002c4:	0f 84 44 03 00 00    	je     80060e <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  8002ca:	83 ec 08             	sub    $0x8,%esp
  8002cd:	53                   	push   %ebx
  8002ce:	50                   	push   %eax
  8002cf:	ff d6                	call   *%esi
  8002d1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002d4:	83 c7 01             	add    $0x1,%edi
  8002d7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8002db:	83 f8 25             	cmp    $0x25,%eax
  8002de:	75 e2                	jne    8002c2 <vprintfmt+0x14>
  8002e0:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8002e4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8002eb:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8002f2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8002f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8002fe:	eb 07                	jmp    800307 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800300:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800303:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800307:	8d 47 01             	lea    0x1(%edi),%eax
  80030a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80030d:	0f b6 07             	movzbl (%edi),%eax
  800310:	0f b6 c8             	movzbl %al,%ecx
  800313:	83 e8 23             	sub    $0x23,%eax
  800316:	3c 55                	cmp    $0x55,%al
  800318:	0f 87 d5 02 00 00    	ja     8005f3 <vprintfmt+0x345>
  80031e:	0f b6 c0             	movzbl %al,%eax
  800321:	ff 24 85 c0 1e 80 00 	jmp    *0x801ec0(,%eax,4)
  800328:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80032b:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80032f:	eb d6                	jmp    800307 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800331:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800334:	b8 00 00 00 00       	mov    $0x0,%eax
  800339:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80033c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80033f:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  800343:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  800346:	8d 51 d0             	lea    -0x30(%ecx),%edx
  800349:	83 fa 09             	cmp    $0x9,%edx
  80034c:	77 39                	ja     800387 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80034e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800351:	eb e9                	jmp    80033c <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800353:	8b 45 14             	mov    0x14(%ebp),%eax
  800356:	8d 48 04             	lea    0x4(%eax),%ecx
  800359:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80035c:	8b 00                	mov    (%eax),%eax
  80035e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800361:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800364:	eb 27                	jmp    80038d <vprintfmt+0xdf>
  800366:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800369:	85 c0                	test   %eax,%eax
  80036b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800370:	0f 49 c8             	cmovns %eax,%ecx
  800373:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800376:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800379:	eb 8c                	jmp    800307 <vprintfmt+0x59>
  80037b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80037e:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800385:	eb 80                	jmp    800307 <vprintfmt+0x59>
  800387:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80038a:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  80038d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800391:	0f 89 70 ff ff ff    	jns    800307 <vprintfmt+0x59>
				width = precision, precision = -1;
  800397:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80039a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80039d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003a4:	e9 5e ff ff ff       	jmp    800307 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003a9:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8003af:	e9 53 ff ff ff       	jmp    800307 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b7:	8d 50 04             	lea    0x4(%eax),%edx
  8003ba:	89 55 14             	mov    %edx,0x14(%ebp)
  8003bd:	83 ec 08             	sub    $0x8,%esp
  8003c0:	53                   	push   %ebx
  8003c1:	ff 30                	pushl  (%eax)
  8003c3:	ff d6                	call   *%esi
			break;
  8003c5:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  8003cb:	e9 04 ff ff ff       	jmp    8002d4 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8003d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d3:	8d 50 04             	lea    0x4(%eax),%edx
  8003d6:	89 55 14             	mov    %edx,0x14(%ebp)
  8003d9:	8b 00                	mov    (%eax),%eax
  8003db:	99                   	cltd   
  8003dc:	31 d0                	xor    %edx,%eax
  8003de:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e0:	83 f8 0f             	cmp    $0xf,%eax
  8003e3:	7f 0b                	jg     8003f0 <vprintfmt+0x142>
  8003e5:	8b 14 85 20 20 80 00 	mov    0x802020(,%eax,4),%edx
  8003ec:	85 d2                	test   %edx,%edx
  8003ee:	75 18                	jne    800408 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  8003f0:	50                   	push   %eax
  8003f1:	68 89 1d 80 00       	push   $0x801d89
  8003f6:	53                   	push   %ebx
  8003f7:	56                   	push   %esi
  8003f8:	e8 94 fe ff ff       	call   800291 <printfmt>
  8003fd:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800400:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800403:	e9 cc fe ff ff       	jmp    8002d4 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  800408:	52                   	push   %edx
  800409:	68 51 21 80 00       	push   $0x802151
  80040e:	53                   	push   %ebx
  80040f:	56                   	push   %esi
  800410:	e8 7c fe ff ff       	call   800291 <printfmt>
  800415:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800418:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80041b:	e9 b4 fe ff ff       	jmp    8002d4 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800420:	8b 45 14             	mov    0x14(%ebp),%eax
  800423:	8d 50 04             	lea    0x4(%eax),%edx
  800426:	89 55 14             	mov    %edx,0x14(%ebp)
  800429:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80042b:	85 ff                	test   %edi,%edi
  80042d:	b8 82 1d 80 00       	mov    $0x801d82,%eax
  800432:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800435:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800439:	0f 8e 94 00 00 00    	jle    8004d3 <vprintfmt+0x225>
  80043f:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800443:	0f 84 98 00 00 00    	je     8004e1 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  800449:	83 ec 08             	sub    $0x8,%esp
  80044c:	ff 75 d0             	pushl  -0x30(%ebp)
  80044f:	57                   	push   %edi
  800450:	e8 41 02 00 00       	call   800696 <strnlen>
  800455:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800458:	29 c1                	sub    %eax,%ecx
  80045a:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80045d:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800460:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800464:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800467:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80046a:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80046c:	eb 0f                	jmp    80047d <vprintfmt+0x1cf>
					putch(padc, putdat);
  80046e:	83 ec 08             	sub    $0x8,%esp
  800471:	53                   	push   %ebx
  800472:	ff 75 e0             	pushl  -0x20(%ebp)
  800475:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800477:	83 ef 01             	sub    $0x1,%edi
  80047a:	83 c4 10             	add    $0x10,%esp
  80047d:	85 ff                	test   %edi,%edi
  80047f:	7f ed                	jg     80046e <vprintfmt+0x1c0>
  800481:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800484:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800487:	85 c9                	test   %ecx,%ecx
  800489:	b8 00 00 00 00       	mov    $0x0,%eax
  80048e:	0f 49 c1             	cmovns %ecx,%eax
  800491:	29 c1                	sub    %eax,%ecx
  800493:	89 75 08             	mov    %esi,0x8(%ebp)
  800496:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800499:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80049c:	89 cb                	mov    %ecx,%ebx
  80049e:	eb 4d                	jmp    8004ed <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004a0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004a4:	74 1b                	je     8004c1 <vprintfmt+0x213>
  8004a6:	0f be c0             	movsbl %al,%eax
  8004a9:	83 e8 20             	sub    $0x20,%eax
  8004ac:	83 f8 5e             	cmp    $0x5e,%eax
  8004af:	76 10                	jbe    8004c1 <vprintfmt+0x213>
					putch('?', putdat);
  8004b1:	83 ec 08             	sub    $0x8,%esp
  8004b4:	ff 75 0c             	pushl  0xc(%ebp)
  8004b7:	6a 3f                	push   $0x3f
  8004b9:	ff 55 08             	call   *0x8(%ebp)
  8004bc:	83 c4 10             	add    $0x10,%esp
  8004bf:	eb 0d                	jmp    8004ce <vprintfmt+0x220>
				else
					putch(ch, putdat);
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	ff 75 0c             	pushl  0xc(%ebp)
  8004c7:	52                   	push   %edx
  8004c8:	ff 55 08             	call   *0x8(%ebp)
  8004cb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004ce:	83 eb 01             	sub    $0x1,%ebx
  8004d1:	eb 1a                	jmp    8004ed <vprintfmt+0x23f>
  8004d3:	89 75 08             	mov    %esi,0x8(%ebp)
  8004d6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004d9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004dc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004df:	eb 0c                	jmp    8004ed <vprintfmt+0x23f>
  8004e1:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e4:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004e7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004ea:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004ed:	83 c7 01             	add    $0x1,%edi
  8004f0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004f4:	0f be d0             	movsbl %al,%edx
  8004f7:	85 d2                	test   %edx,%edx
  8004f9:	74 23                	je     80051e <vprintfmt+0x270>
  8004fb:	85 f6                	test   %esi,%esi
  8004fd:	78 a1                	js     8004a0 <vprintfmt+0x1f2>
  8004ff:	83 ee 01             	sub    $0x1,%esi
  800502:	79 9c                	jns    8004a0 <vprintfmt+0x1f2>
  800504:	89 df                	mov    %ebx,%edi
  800506:	8b 75 08             	mov    0x8(%ebp),%esi
  800509:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80050c:	eb 18                	jmp    800526 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80050e:	83 ec 08             	sub    $0x8,%esp
  800511:	53                   	push   %ebx
  800512:	6a 20                	push   $0x20
  800514:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800516:	83 ef 01             	sub    $0x1,%edi
  800519:	83 c4 10             	add    $0x10,%esp
  80051c:	eb 08                	jmp    800526 <vprintfmt+0x278>
  80051e:	89 df                	mov    %ebx,%edi
  800520:	8b 75 08             	mov    0x8(%ebp),%esi
  800523:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800526:	85 ff                	test   %edi,%edi
  800528:	7f e4                	jg     80050e <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80052d:	e9 a2 fd ff ff       	jmp    8002d4 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800532:	8d 45 14             	lea    0x14(%ebp),%eax
  800535:	e8 08 fd ff ff       	call   800242 <getint>
  80053a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800540:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800545:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800549:	79 74                	jns    8005bf <vprintfmt+0x311>
				putch('-', putdat);
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	53                   	push   %ebx
  80054f:	6a 2d                	push   $0x2d
  800551:	ff d6                	call   *%esi
				num = -(long long) num;
  800553:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800556:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800559:	f7 d8                	neg    %eax
  80055b:	83 d2 00             	adc    $0x0,%edx
  80055e:	f7 da                	neg    %edx
  800560:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  800563:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800568:	eb 55                	jmp    8005bf <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80056a:	8d 45 14             	lea    0x14(%ebp),%eax
  80056d:	e8 96 fc ff ff       	call   800208 <getuint>
			base = 10;
  800572:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800577:	eb 46                	jmp    8005bf <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800579:	8d 45 14             	lea    0x14(%ebp),%eax
  80057c:	e8 87 fc ff ff       	call   800208 <getuint>
			base = 8;
  800581:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800586:	eb 37                	jmp    8005bf <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  800588:	83 ec 08             	sub    $0x8,%esp
  80058b:	53                   	push   %ebx
  80058c:	6a 30                	push   $0x30
  80058e:	ff d6                	call   *%esi
			putch('x', putdat);
  800590:	83 c4 08             	add    $0x8,%esp
  800593:	53                   	push   %ebx
  800594:	6a 78                	push   $0x78
  800596:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800598:	8b 45 14             	mov    0x14(%ebp),%eax
  80059b:	8d 50 04             	lea    0x4(%eax),%edx
  80059e:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8005a1:	8b 00                	mov    (%eax),%eax
  8005a3:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8005a8:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8005ab:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8005b0:	eb 0d                	jmp    8005bf <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8005b2:	8d 45 14             	lea    0x14(%ebp),%eax
  8005b5:	e8 4e fc ff ff       	call   800208 <getuint>
			base = 16;
  8005ba:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8005bf:	83 ec 0c             	sub    $0xc,%esp
  8005c2:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8005c6:	57                   	push   %edi
  8005c7:	ff 75 e0             	pushl  -0x20(%ebp)
  8005ca:	51                   	push   %ecx
  8005cb:	52                   	push   %edx
  8005cc:	50                   	push   %eax
  8005cd:	89 da                	mov    %ebx,%edx
  8005cf:	89 f0                	mov    %esi,%eax
  8005d1:	e8 83 fb ff ff       	call   800159 <printnum>
			break;
  8005d6:	83 c4 20             	add    $0x20,%esp
  8005d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005dc:	e9 f3 fc ff ff       	jmp    8002d4 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8005e1:	83 ec 08             	sub    $0x8,%esp
  8005e4:	53                   	push   %ebx
  8005e5:	51                   	push   %ecx
  8005e6:	ff d6                	call   *%esi
			break;
  8005e8:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8005ee:	e9 e1 fc ff ff       	jmp    8002d4 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	53                   	push   %ebx
  8005f7:	6a 25                	push   $0x25
  8005f9:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8005fb:	83 c4 10             	add    $0x10,%esp
  8005fe:	eb 03                	jmp    800603 <vprintfmt+0x355>
  800600:	83 ef 01             	sub    $0x1,%edi
  800603:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  800607:	75 f7                	jne    800600 <vprintfmt+0x352>
  800609:	e9 c6 fc ff ff       	jmp    8002d4 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  80060e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800611:	5b                   	pop    %ebx
  800612:	5e                   	pop    %esi
  800613:	5f                   	pop    %edi
  800614:	5d                   	pop    %ebp
  800615:	c3                   	ret    

00800616 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800616:	55                   	push   %ebp
  800617:	89 e5                	mov    %esp,%ebp
  800619:	83 ec 18             	sub    $0x18,%esp
  80061c:	8b 45 08             	mov    0x8(%ebp),%eax
  80061f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800622:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800625:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800629:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80062c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800633:	85 c0                	test   %eax,%eax
  800635:	74 26                	je     80065d <vsnprintf+0x47>
  800637:	85 d2                	test   %edx,%edx
  800639:	7e 22                	jle    80065d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80063b:	ff 75 14             	pushl  0x14(%ebp)
  80063e:	ff 75 10             	pushl  0x10(%ebp)
  800641:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800644:	50                   	push   %eax
  800645:	68 74 02 80 00       	push   $0x800274
  80064a:	e8 5f fc ff ff       	call   8002ae <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80064f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800652:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	eb 05                	jmp    800662 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80065d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800662:	c9                   	leave  
  800663:	c3                   	ret    

00800664 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800664:	55                   	push   %ebp
  800665:	89 e5                	mov    %esp,%ebp
  800667:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80066a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80066d:	50                   	push   %eax
  80066e:	ff 75 10             	pushl  0x10(%ebp)
  800671:	ff 75 0c             	pushl  0xc(%ebp)
  800674:	ff 75 08             	pushl  0x8(%ebp)
  800677:	e8 9a ff ff ff       	call   800616 <vsnprintf>
	va_end(ap);

	return rc;
}
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
  800681:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800684:	b8 00 00 00 00       	mov    $0x0,%eax
  800689:	eb 03                	jmp    80068e <strlen+0x10>
		n++;
  80068b:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80068e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800692:	75 f7                	jne    80068b <strlen+0xd>
		n++;
	return n;
}
  800694:	5d                   	pop    %ebp
  800695:	c3                   	ret    

00800696 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800696:	55                   	push   %ebp
  800697:	89 e5                	mov    %esp,%ebp
  800699:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80069c:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80069f:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a4:	eb 03                	jmp    8006a9 <strnlen+0x13>
		n++;
  8006a6:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8006a9:	39 c2                	cmp    %eax,%edx
  8006ab:	74 08                	je     8006b5 <strnlen+0x1f>
  8006ad:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8006b1:	75 f3                	jne    8006a6 <strnlen+0x10>
  8006b3:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  8006b5:	5d                   	pop    %ebp
  8006b6:	c3                   	ret    

008006b7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8006b7:	55                   	push   %ebp
  8006b8:	89 e5                	mov    %esp,%ebp
  8006ba:	53                   	push   %ebx
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8006c1:	89 c2                	mov    %eax,%edx
  8006c3:	83 c2 01             	add    $0x1,%edx
  8006c6:	83 c1 01             	add    $0x1,%ecx
  8006c9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8006cd:	88 5a ff             	mov    %bl,-0x1(%edx)
  8006d0:	84 db                	test   %bl,%bl
  8006d2:	75 ef                	jne    8006c3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8006d4:	5b                   	pop    %ebx
  8006d5:	5d                   	pop    %ebp
  8006d6:	c3                   	ret    

008006d7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8006d7:	55                   	push   %ebp
  8006d8:	89 e5                	mov    %esp,%ebp
  8006da:	53                   	push   %ebx
  8006db:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8006de:	53                   	push   %ebx
  8006df:	e8 9a ff ff ff       	call   80067e <strlen>
  8006e4:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8006e7:	ff 75 0c             	pushl  0xc(%ebp)
  8006ea:	01 d8                	add    %ebx,%eax
  8006ec:	50                   	push   %eax
  8006ed:	e8 c5 ff ff ff       	call   8006b7 <strcpy>
	return dst;
}
  8006f2:	89 d8                	mov    %ebx,%eax
  8006f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006f7:	c9                   	leave  
  8006f8:	c3                   	ret    

008006f9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8006f9:	55                   	push   %ebp
  8006fa:	89 e5                	mov    %esp,%ebp
  8006fc:	56                   	push   %esi
  8006fd:	53                   	push   %ebx
  8006fe:	8b 75 08             	mov    0x8(%ebp),%esi
  800701:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800704:	89 f3                	mov    %esi,%ebx
  800706:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800709:	89 f2                	mov    %esi,%edx
  80070b:	eb 0f                	jmp    80071c <strncpy+0x23>
		*dst++ = *src;
  80070d:	83 c2 01             	add    $0x1,%edx
  800710:	0f b6 01             	movzbl (%ecx),%eax
  800713:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800716:	80 39 01             	cmpb   $0x1,(%ecx)
  800719:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80071c:	39 da                	cmp    %ebx,%edx
  80071e:	75 ed                	jne    80070d <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800720:	89 f0                	mov    %esi,%eax
  800722:	5b                   	pop    %ebx
  800723:	5e                   	pop    %esi
  800724:	5d                   	pop    %ebp
  800725:	c3                   	ret    

00800726 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800726:	55                   	push   %ebp
  800727:	89 e5                	mov    %esp,%ebp
  800729:	56                   	push   %esi
  80072a:	53                   	push   %ebx
  80072b:	8b 75 08             	mov    0x8(%ebp),%esi
  80072e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800731:	8b 55 10             	mov    0x10(%ebp),%edx
  800734:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800736:	85 d2                	test   %edx,%edx
  800738:	74 21                	je     80075b <strlcpy+0x35>
  80073a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80073e:	89 f2                	mov    %esi,%edx
  800740:	eb 09                	jmp    80074b <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800742:	83 c2 01             	add    $0x1,%edx
  800745:	83 c1 01             	add    $0x1,%ecx
  800748:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80074b:	39 c2                	cmp    %eax,%edx
  80074d:	74 09                	je     800758 <strlcpy+0x32>
  80074f:	0f b6 19             	movzbl (%ecx),%ebx
  800752:	84 db                	test   %bl,%bl
  800754:	75 ec                	jne    800742 <strlcpy+0x1c>
  800756:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  800758:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80075b:	29 f0                	sub    %esi,%eax
}
  80075d:	5b                   	pop    %ebx
  80075e:	5e                   	pop    %esi
  80075f:	5d                   	pop    %ebp
  800760:	c3                   	ret    

00800761 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800767:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80076a:	eb 06                	jmp    800772 <strcmp+0x11>
		p++, q++;
  80076c:	83 c1 01             	add    $0x1,%ecx
  80076f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800772:	0f b6 01             	movzbl (%ecx),%eax
  800775:	84 c0                	test   %al,%al
  800777:	74 04                	je     80077d <strcmp+0x1c>
  800779:	3a 02                	cmp    (%edx),%al
  80077b:	74 ef                	je     80076c <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80077d:	0f b6 c0             	movzbl %al,%eax
  800780:	0f b6 12             	movzbl (%edx),%edx
  800783:	29 d0                	sub    %edx,%eax
}
  800785:	5d                   	pop    %ebp
  800786:	c3                   	ret    

00800787 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800787:	55                   	push   %ebp
  800788:	89 e5                	mov    %esp,%ebp
  80078a:	53                   	push   %ebx
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800791:	89 c3                	mov    %eax,%ebx
  800793:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800796:	eb 06                	jmp    80079e <strncmp+0x17>
		n--, p++, q++;
  800798:	83 c0 01             	add    $0x1,%eax
  80079b:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80079e:	39 d8                	cmp    %ebx,%eax
  8007a0:	74 15                	je     8007b7 <strncmp+0x30>
  8007a2:	0f b6 08             	movzbl (%eax),%ecx
  8007a5:	84 c9                	test   %cl,%cl
  8007a7:	74 04                	je     8007ad <strncmp+0x26>
  8007a9:	3a 0a                	cmp    (%edx),%cl
  8007ab:	74 eb                	je     800798 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8007ad:	0f b6 00             	movzbl (%eax),%eax
  8007b0:	0f b6 12             	movzbl (%edx),%edx
  8007b3:	29 d0                	sub    %edx,%eax
  8007b5:	eb 05                	jmp    8007bc <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8007b7:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8007bc:	5b                   	pop    %ebx
  8007bd:	5d                   	pop    %ebp
  8007be:	c3                   	ret    

008007bf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8007bf:	55                   	push   %ebp
  8007c0:	89 e5                	mov    %esp,%ebp
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8007c9:	eb 07                	jmp    8007d2 <strchr+0x13>
		if (*s == c)
  8007cb:	38 ca                	cmp    %cl,%dl
  8007cd:	74 0f                	je     8007de <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8007cf:	83 c0 01             	add    $0x1,%eax
  8007d2:	0f b6 10             	movzbl (%eax),%edx
  8007d5:	84 d2                	test   %dl,%dl
  8007d7:	75 f2                	jne    8007cb <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8007d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007de:	5d                   	pop    %ebp
  8007df:	c3                   	ret    

008007e0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8007e0:	55                   	push   %ebp
  8007e1:	89 e5                	mov    %esp,%ebp
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8007ea:	eb 03                	jmp    8007ef <strfind+0xf>
  8007ec:	83 c0 01             	add    $0x1,%eax
  8007ef:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8007f2:	38 ca                	cmp    %cl,%dl
  8007f4:	74 04                	je     8007fa <strfind+0x1a>
  8007f6:	84 d2                	test   %dl,%dl
  8007f8:	75 f2                	jne    8007ec <strfind+0xc>
			break;
	return (char *) s;
}
  8007fa:	5d                   	pop    %ebp
  8007fb:	c3                   	ret    

008007fc <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
  8007ff:	57                   	push   %edi
  800800:	56                   	push   %esi
  800801:	53                   	push   %ebx
  800802:	8b 55 08             	mov    0x8(%ebp),%edx
  800805:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800808:	85 c9                	test   %ecx,%ecx
  80080a:	74 37                	je     800843 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80080c:	f6 c2 03             	test   $0x3,%dl
  80080f:	75 2a                	jne    80083b <memset+0x3f>
  800811:	f6 c1 03             	test   $0x3,%cl
  800814:	75 25                	jne    80083b <memset+0x3f>
		c &= 0xFF;
  800816:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80081a:	89 df                	mov    %ebx,%edi
  80081c:	c1 e7 08             	shl    $0x8,%edi
  80081f:	89 de                	mov    %ebx,%esi
  800821:	c1 e6 18             	shl    $0x18,%esi
  800824:	89 d8                	mov    %ebx,%eax
  800826:	c1 e0 10             	shl    $0x10,%eax
  800829:	09 f0                	or     %esi,%eax
  80082b:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  80082d:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800830:	89 f8                	mov    %edi,%eax
  800832:	09 d8                	or     %ebx,%eax
  800834:	89 d7                	mov    %edx,%edi
  800836:	fc                   	cld    
  800837:	f3 ab                	rep stos %eax,%es:(%edi)
  800839:	eb 08                	jmp    800843 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80083b:	89 d7                	mov    %edx,%edi
  80083d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800840:	fc                   	cld    
  800841:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800843:	89 d0                	mov    %edx,%eax
  800845:	5b                   	pop    %ebx
  800846:	5e                   	pop    %esi
  800847:	5f                   	pop    %edi
  800848:	5d                   	pop    %ebp
  800849:	c3                   	ret    

0080084a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80084a:	55                   	push   %ebp
  80084b:	89 e5                	mov    %esp,%ebp
  80084d:	57                   	push   %edi
  80084e:	56                   	push   %esi
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	8b 75 0c             	mov    0xc(%ebp),%esi
  800855:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800858:	39 c6                	cmp    %eax,%esi
  80085a:	73 35                	jae    800891 <memmove+0x47>
  80085c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80085f:	39 d0                	cmp    %edx,%eax
  800861:	73 2e                	jae    800891 <memmove+0x47>
		s += n;
		d += n;
  800863:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800866:	89 d6                	mov    %edx,%esi
  800868:	09 fe                	or     %edi,%esi
  80086a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800870:	75 13                	jne    800885 <memmove+0x3b>
  800872:	f6 c1 03             	test   $0x3,%cl
  800875:	75 0e                	jne    800885 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  800877:	83 ef 04             	sub    $0x4,%edi
  80087a:	8d 72 fc             	lea    -0x4(%edx),%esi
  80087d:	c1 e9 02             	shr    $0x2,%ecx
  800880:	fd                   	std    
  800881:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800883:	eb 09                	jmp    80088e <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800885:	83 ef 01             	sub    $0x1,%edi
  800888:	8d 72 ff             	lea    -0x1(%edx),%esi
  80088b:	fd                   	std    
  80088c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80088e:	fc                   	cld    
  80088f:	eb 1d                	jmp    8008ae <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800891:	89 f2                	mov    %esi,%edx
  800893:	09 c2                	or     %eax,%edx
  800895:	f6 c2 03             	test   $0x3,%dl
  800898:	75 0f                	jne    8008a9 <memmove+0x5f>
  80089a:	f6 c1 03             	test   $0x3,%cl
  80089d:	75 0a                	jne    8008a9 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  80089f:	c1 e9 02             	shr    $0x2,%ecx
  8008a2:	89 c7                	mov    %eax,%edi
  8008a4:	fc                   	cld    
  8008a5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008a7:	eb 05                	jmp    8008ae <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8008a9:	89 c7                	mov    %eax,%edi
  8008ab:	fc                   	cld    
  8008ac:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8008ae:	5e                   	pop    %esi
  8008af:	5f                   	pop    %edi
  8008b0:	5d                   	pop    %ebp
  8008b1:	c3                   	ret    

008008b2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8008b2:	55                   	push   %ebp
  8008b3:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8008b5:	ff 75 10             	pushl  0x10(%ebp)
  8008b8:	ff 75 0c             	pushl  0xc(%ebp)
  8008bb:	ff 75 08             	pushl  0x8(%ebp)
  8008be:	e8 87 ff ff ff       	call   80084a <memmove>
}
  8008c3:	c9                   	leave  
  8008c4:	c3                   	ret    

008008c5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8008c5:	55                   	push   %ebp
  8008c6:	89 e5                	mov    %esp,%ebp
  8008c8:	56                   	push   %esi
  8008c9:	53                   	push   %ebx
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d0:	89 c6                	mov    %eax,%esi
  8008d2:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8008d5:	eb 1a                	jmp    8008f1 <memcmp+0x2c>
		if (*s1 != *s2)
  8008d7:	0f b6 08             	movzbl (%eax),%ecx
  8008da:	0f b6 1a             	movzbl (%edx),%ebx
  8008dd:	38 d9                	cmp    %bl,%cl
  8008df:	74 0a                	je     8008eb <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8008e1:	0f b6 c1             	movzbl %cl,%eax
  8008e4:	0f b6 db             	movzbl %bl,%ebx
  8008e7:	29 d8                	sub    %ebx,%eax
  8008e9:	eb 0f                	jmp    8008fa <memcmp+0x35>
		s1++, s2++;
  8008eb:	83 c0 01             	add    $0x1,%eax
  8008ee:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8008f1:	39 f0                	cmp    %esi,%eax
  8008f3:	75 e2                	jne    8008d7 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8008f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008fa:	5b                   	pop    %ebx
  8008fb:	5e                   	pop    %esi
  8008fc:	5d                   	pop    %ebp
  8008fd:	c3                   	ret    

008008fe <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	53                   	push   %ebx
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800905:	89 c1                	mov    %eax,%ecx
  800907:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  80090a:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80090e:	eb 0a                	jmp    80091a <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800910:	0f b6 10             	movzbl (%eax),%edx
  800913:	39 da                	cmp    %ebx,%edx
  800915:	74 07                	je     80091e <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800917:	83 c0 01             	add    $0x1,%eax
  80091a:	39 c8                	cmp    %ecx,%eax
  80091c:	72 f2                	jb     800910 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  80091e:	5b                   	pop    %ebx
  80091f:	5d                   	pop    %ebp
  800920:	c3                   	ret    

00800921 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
  800924:	57                   	push   %edi
  800925:	56                   	push   %esi
  800926:	53                   	push   %ebx
  800927:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80092a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80092d:	eb 03                	jmp    800932 <strtol+0x11>
		s++;
  80092f:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800932:	0f b6 01             	movzbl (%ecx),%eax
  800935:	3c 20                	cmp    $0x20,%al
  800937:	74 f6                	je     80092f <strtol+0xe>
  800939:	3c 09                	cmp    $0x9,%al
  80093b:	74 f2                	je     80092f <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  80093d:	3c 2b                	cmp    $0x2b,%al
  80093f:	75 0a                	jne    80094b <strtol+0x2a>
		s++;
  800941:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800944:	bf 00 00 00 00       	mov    $0x0,%edi
  800949:	eb 11                	jmp    80095c <strtol+0x3b>
  80094b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800950:	3c 2d                	cmp    $0x2d,%al
  800952:	75 08                	jne    80095c <strtol+0x3b>
		s++, neg = 1;
  800954:	83 c1 01             	add    $0x1,%ecx
  800957:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80095c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800962:	75 15                	jne    800979 <strtol+0x58>
  800964:	80 39 30             	cmpb   $0x30,(%ecx)
  800967:	75 10                	jne    800979 <strtol+0x58>
  800969:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80096d:	75 7c                	jne    8009eb <strtol+0xca>
		s += 2, base = 16;
  80096f:	83 c1 02             	add    $0x2,%ecx
  800972:	bb 10 00 00 00       	mov    $0x10,%ebx
  800977:	eb 16                	jmp    80098f <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800979:	85 db                	test   %ebx,%ebx
  80097b:	75 12                	jne    80098f <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80097d:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800982:	80 39 30             	cmpb   $0x30,(%ecx)
  800985:	75 08                	jne    80098f <strtol+0x6e>
		s++, base = 8;
  800987:	83 c1 01             	add    $0x1,%ecx
  80098a:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  80098f:	b8 00 00 00 00       	mov    $0x0,%eax
  800994:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800997:	0f b6 11             	movzbl (%ecx),%edx
  80099a:	8d 72 d0             	lea    -0x30(%edx),%esi
  80099d:	89 f3                	mov    %esi,%ebx
  80099f:	80 fb 09             	cmp    $0x9,%bl
  8009a2:	77 08                	ja     8009ac <strtol+0x8b>
			dig = *s - '0';
  8009a4:	0f be d2             	movsbl %dl,%edx
  8009a7:	83 ea 30             	sub    $0x30,%edx
  8009aa:	eb 22                	jmp    8009ce <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  8009ac:	8d 72 9f             	lea    -0x61(%edx),%esi
  8009af:	89 f3                	mov    %esi,%ebx
  8009b1:	80 fb 19             	cmp    $0x19,%bl
  8009b4:	77 08                	ja     8009be <strtol+0x9d>
			dig = *s - 'a' + 10;
  8009b6:	0f be d2             	movsbl %dl,%edx
  8009b9:	83 ea 57             	sub    $0x57,%edx
  8009bc:	eb 10                	jmp    8009ce <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  8009be:	8d 72 bf             	lea    -0x41(%edx),%esi
  8009c1:	89 f3                	mov    %esi,%ebx
  8009c3:	80 fb 19             	cmp    $0x19,%bl
  8009c6:	77 16                	ja     8009de <strtol+0xbd>
			dig = *s - 'A' + 10;
  8009c8:	0f be d2             	movsbl %dl,%edx
  8009cb:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  8009ce:	3b 55 10             	cmp    0x10(%ebp),%edx
  8009d1:	7d 0b                	jge    8009de <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  8009d3:	83 c1 01             	add    $0x1,%ecx
  8009d6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8009da:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  8009dc:	eb b9                	jmp    800997 <strtol+0x76>

	if (endptr)
  8009de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009e2:	74 0d                	je     8009f1 <strtol+0xd0>
		*endptr = (char *) s;
  8009e4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009e7:	89 0e                	mov    %ecx,(%esi)
  8009e9:	eb 06                	jmp    8009f1 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009eb:	85 db                	test   %ebx,%ebx
  8009ed:	74 98                	je     800987 <strtol+0x66>
  8009ef:	eb 9e                	jmp    80098f <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  8009f1:	89 c2                	mov    %eax,%edx
  8009f3:	f7 da                	neg    %edx
  8009f5:	85 ff                	test   %edi,%edi
  8009f7:	0f 45 c2             	cmovne %edx,%eax
}
  8009fa:	5b                   	pop    %ebx
  8009fb:	5e                   	pop    %esi
  8009fc:	5f                   	pop    %edi
  8009fd:	5d                   	pop    %ebp
  8009fe:	c3                   	ret    

008009ff <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	57                   	push   %edi
  800a03:	56                   	push   %esi
  800a04:	53                   	push   %ebx
  800a05:	83 ec 1c             	sub    $0x1c,%esp
  800a08:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a0b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a0e:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800a10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a13:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a16:	8b 7d 10             	mov    0x10(%ebp),%edi
  800a19:	8b 75 14             	mov    0x14(%ebp),%esi
  800a1c:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800a1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a22:	74 1d                	je     800a41 <syscall+0x42>
  800a24:	85 c0                	test   %eax,%eax
  800a26:	7e 19                	jle    800a41 <syscall+0x42>
  800a28:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800a2b:	83 ec 0c             	sub    $0xc,%esp
  800a2e:	50                   	push   %eax
  800a2f:	52                   	push   %edx
  800a30:	68 7f 20 80 00       	push   $0x80207f
  800a35:	6a 23                	push   $0x23
  800a37:	68 9c 20 80 00       	push   $0x80209c
  800a3c:	e8 e9 0e 00 00       	call   80192a <_panic>

	return ret;
}
  800a41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a44:	5b                   	pop    %ebx
  800a45:	5e                   	pop    %esi
  800a46:	5f                   	pop    %edi
  800a47:	5d                   	pop    %ebp
  800a48:	c3                   	ret    

00800a49 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800a49:	55                   	push   %ebp
  800a4a:	89 e5                	mov    %esp,%ebp
  800a4c:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800a4f:	6a 00                	push   $0x0
  800a51:	6a 00                	push   $0x0
  800a53:	6a 00                	push   $0x0
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a60:	b8 00 00 00 00       	mov    $0x0,%eax
  800a65:	e8 95 ff ff ff       	call   8009ff <syscall>
}
  800a6a:	83 c4 10             	add    $0x10,%esp
  800a6d:	c9                   	leave  
  800a6e:	c3                   	ret    

00800a6f <sys_cgetc>:

int
sys_cgetc(void)
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800a75:	6a 00                	push   $0x0
  800a77:	6a 00                	push   $0x0
  800a79:	6a 00                	push   $0x0
  800a7b:	6a 00                	push   $0x0
  800a7d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a82:	ba 00 00 00 00       	mov    $0x0,%edx
  800a87:	b8 01 00 00 00       	mov    $0x1,%eax
  800a8c:	e8 6e ff ff ff       	call   8009ff <syscall>
}
  800a91:	c9                   	leave  
  800a92:	c3                   	ret    

00800a93 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800a93:	55                   	push   %ebp
  800a94:	89 e5                	mov    %esp,%ebp
  800a96:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800a99:	6a 00                	push   $0x0
  800a9b:	6a 00                	push   $0x0
  800a9d:	6a 00                	push   $0x0
  800a9f:	6a 00                	push   $0x0
  800aa1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aa4:	ba 01 00 00 00       	mov    $0x1,%edx
  800aa9:	b8 03 00 00 00       	mov    $0x3,%eax
  800aae:	e8 4c ff ff ff       	call   8009ff <syscall>
}
  800ab3:	c9                   	leave  
  800ab4:	c3                   	ret    

00800ab5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800abb:	6a 00                	push   $0x0
  800abd:	6a 00                	push   $0x0
  800abf:	6a 00                	push   $0x0
  800ac1:	6a 00                	push   $0x0
  800ac3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ac8:	ba 00 00 00 00       	mov    $0x0,%edx
  800acd:	b8 02 00 00 00       	mov    $0x2,%eax
  800ad2:	e8 28 ff ff ff       	call   8009ff <syscall>
}
  800ad7:	c9                   	leave  
  800ad8:	c3                   	ret    

00800ad9 <sys_yield>:

void
sys_yield(void)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800adf:	6a 00                	push   $0x0
  800ae1:	6a 00                	push   $0x0
  800ae3:	6a 00                	push   $0x0
  800ae5:	6a 00                	push   $0x0
  800ae7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800aec:	ba 00 00 00 00       	mov    $0x0,%edx
  800af1:	b8 0b 00 00 00       	mov    $0xb,%eax
  800af6:	e8 04 ff ff ff       	call   8009ff <syscall>
}
  800afb:	83 c4 10             	add    $0x10,%esp
  800afe:	c9                   	leave  
  800aff:	c3                   	ret    

00800b00 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
  800b03:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800b06:	6a 00                	push   $0x0
  800b08:	6a 00                	push   $0x0
  800b0a:	ff 75 10             	pushl  0x10(%ebp)
  800b0d:	ff 75 0c             	pushl  0xc(%ebp)
  800b10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b13:	ba 01 00 00 00       	mov    $0x1,%edx
  800b18:	b8 04 00 00 00       	mov    $0x4,%eax
  800b1d:	e8 dd fe ff ff       	call   8009ff <syscall>
}
  800b22:	c9                   	leave  
  800b23:	c3                   	ret    

00800b24 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b24:	55                   	push   %ebp
  800b25:	89 e5                	mov    %esp,%ebp
  800b27:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800b2a:	ff 75 18             	pushl  0x18(%ebp)
  800b2d:	ff 75 14             	pushl  0x14(%ebp)
  800b30:	ff 75 10             	pushl  0x10(%ebp)
  800b33:	ff 75 0c             	pushl  0xc(%ebp)
  800b36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b39:	ba 01 00 00 00       	mov    $0x1,%edx
  800b3e:	b8 05 00 00 00       	mov    $0x5,%eax
  800b43:	e8 b7 fe ff ff       	call   8009ff <syscall>
}
  800b48:	c9                   	leave  
  800b49:	c3                   	ret    

00800b4a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800b50:	6a 00                	push   $0x0
  800b52:	6a 00                	push   $0x0
  800b54:	6a 00                	push   $0x0
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b5c:	ba 01 00 00 00       	mov    $0x1,%edx
  800b61:	b8 06 00 00 00       	mov    $0x6,%eax
  800b66:	e8 94 fe ff ff       	call   8009ff <syscall>
}
  800b6b:	c9                   	leave  
  800b6c:	c3                   	ret    

00800b6d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800b6d:	55                   	push   %ebp
  800b6e:	89 e5                	mov    %esp,%ebp
  800b70:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800b73:	6a 00                	push   $0x0
  800b75:	6a 00                	push   $0x0
  800b77:	6a 00                	push   $0x0
  800b79:	ff 75 0c             	pushl  0xc(%ebp)
  800b7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b7f:	ba 01 00 00 00       	mov    $0x1,%edx
  800b84:	b8 08 00 00 00       	mov    $0x8,%eax
  800b89:	e8 71 fe ff ff       	call   8009ff <syscall>
}
  800b8e:	c9                   	leave  
  800b8f:	c3                   	ret    

00800b90 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800b96:	6a 00                	push   $0x0
  800b98:	6a 00                	push   $0x0
  800b9a:	6a 00                	push   $0x0
  800b9c:	ff 75 0c             	pushl  0xc(%ebp)
  800b9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba2:	ba 01 00 00 00       	mov    $0x1,%edx
  800ba7:	b8 09 00 00 00       	mov    $0x9,%eax
  800bac:	e8 4e fe ff ff       	call   8009ff <syscall>
}
  800bb1:	c9                   	leave  
  800bb2:	c3                   	ret    

00800bb3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800bb9:	6a 00                	push   $0x0
  800bbb:	6a 00                	push   $0x0
  800bbd:	6a 00                	push   $0x0
  800bbf:	ff 75 0c             	pushl  0xc(%ebp)
  800bc2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc5:	ba 01 00 00 00       	mov    $0x1,%edx
  800bca:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bcf:	e8 2b fe ff ff       	call   8009ff <syscall>
}
  800bd4:	c9                   	leave  
  800bd5:	c3                   	ret    

00800bd6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
  800bd9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800bdc:	6a 00                	push   $0x0
  800bde:	ff 75 14             	pushl  0x14(%ebp)
  800be1:	ff 75 10             	pushl  0x10(%ebp)
  800be4:	ff 75 0c             	pushl  0xc(%ebp)
  800be7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bea:	ba 00 00 00 00       	mov    $0x0,%edx
  800bef:	b8 0c 00 00 00       	mov    $0xc,%eax
  800bf4:	e8 06 fe ff ff       	call   8009ff <syscall>
}
  800bf9:	c9                   	leave  
  800bfa:	c3                   	ret    

00800bfb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800c01:	6a 00                	push   $0x0
  800c03:	6a 00                	push   $0x0
  800c05:	6a 00                	push   $0x0
  800c07:	6a 00                	push   $0x0
  800c09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c0c:	ba 01 00 00 00       	mov    $0x1,%edx
  800c11:	b8 0d 00 00 00       	mov    $0xd,%eax
  800c16:	e8 e4 fd ff ff       	call   8009ff <syscall>
}
  800c1b:	c9                   	leave  
  800c1c:	c3                   	ret    

00800c1d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	05 00 00 00 30       	add    $0x30000000,%eax
  800c28:	c1 e8 0c             	shr    $0xc,%eax
}
  800c2b:	5d                   	pop    %ebp
  800c2c:	c3                   	ret    

00800c2d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  800c30:	ff 75 08             	pushl  0x8(%ebp)
  800c33:	e8 e5 ff ff ff       	call   800c1d <fd2num>
  800c38:	83 c4 04             	add    $0x4,%esp
  800c3b:	c1 e0 0c             	shl    $0xc,%eax
  800c3e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800c43:	c9                   	leave  
  800c44:	c3                   	ret    

00800c45 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c4b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800c50:	89 c2                	mov    %eax,%edx
  800c52:	c1 ea 16             	shr    $0x16,%edx
  800c55:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800c5c:	f6 c2 01             	test   $0x1,%dl
  800c5f:	74 11                	je     800c72 <fd_alloc+0x2d>
  800c61:	89 c2                	mov    %eax,%edx
  800c63:	c1 ea 0c             	shr    $0xc,%edx
  800c66:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800c6d:	f6 c2 01             	test   $0x1,%dl
  800c70:	75 09                	jne    800c7b <fd_alloc+0x36>
			*fd_store = fd;
  800c72:	89 01                	mov    %eax,(%ecx)
			return 0;
  800c74:	b8 00 00 00 00       	mov    $0x0,%eax
  800c79:	eb 17                	jmp    800c92 <fd_alloc+0x4d>
  800c7b:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800c80:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800c85:	75 c9                	jne    800c50 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800c87:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800c8d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800c92:	5d                   	pop    %ebp
  800c93:	c3                   	ret    

00800c94 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800c9a:	83 f8 1f             	cmp    $0x1f,%eax
  800c9d:	77 36                	ja     800cd5 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800c9f:	c1 e0 0c             	shl    $0xc,%eax
  800ca2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ca7:	89 c2                	mov    %eax,%edx
  800ca9:	c1 ea 16             	shr    $0x16,%edx
  800cac:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800cb3:	f6 c2 01             	test   $0x1,%dl
  800cb6:	74 24                	je     800cdc <fd_lookup+0x48>
  800cb8:	89 c2                	mov    %eax,%edx
  800cba:	c1 ea 0c             	shr    $0xc,%edx
  800cbd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800cc4:	f6 c2 01             	test   $0x1,%dl
  800cc7:	74 1a                	je     800ce3 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800cc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ccc:	89 02                	mov    %eax,(%edx)
	return 0;
  800cce:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd3:	eb 13                	jmp    800ce8 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800cd5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cda:	eb 0c                	jmp    800ce8 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800cdc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ce1:	eb 05                	jmp    800ce8 <fd_lookup+0x54>
  800ce3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800ce8:	5d                   	pop    %ebp
  800ce9:	c3                   	ret    

00800cea <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	83 ec 08             	sub    $0x8,%esp
  800cf0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cf3:	ba 28 21 80 00       	mov    $0x802128,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800cf8:	eb 13                	jmp    800d0d <dev_lookup+0x23>
  800cfa:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  800cfd:	39 08                	cmp    %ecx,(%eax)
  800cff:	75 0c                	jne    800d0d <dev_lookup+0x23>
			*dev = devtab[i];
  800d01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d04:	89 01                	mov    %eax,(%ecx)
			return 0;
  800d06:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0b:	eb 2e                	jmp    800d3b <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800d0d:	8b 02                	mov    (%edx),%eax
  800d0f:	85 c0                	test   %eax,%eax
  800d11:	75 e7                	jne    800cfa <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800d13:	a1 04 40 80 00       	mov    0x804004,%eax
  800d18:	8b 40 48             	mov    0x48(%eax),%eax
  800d1b:	83 ec 04             	sub    $0x4,%esp
  800d1e:	51                   	push   %ecx
  800d1f:	50                   	push   %eax
  800d20:	68 ac 20 80 00       	push   $0x8020ac
  800d25:	e8 1b f4 ff ff       	call   800145 <cprintf>
	*dev = 0;
  800d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800d33:	83 c4 10             	add    $0x10,%esp
  800d36:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800d3b:	c9                   	leave  
  800d3c:	c3                   	ret    

00800d3d <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	56                   	push   %esi
  800d41:	53                   	push   %ebx
  800d42:	83 ec 10             	sub    $0x10,%esp
  800d45:	8b 75 08             	mov    0x8(%ebp),%esi
  800d48:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800d4b:	56                   	push   %esi
  800d4c:	e8 cc fe ff ff       	call   800c1d <fd2num>
  800d51:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800d54:	89 14 24             	mov    %edx,(%esp)
  800d57:	50                   	push   %eax
  800d58:	e8 37 ff ff ff       	call   800c94 <fd_lookup>
  800d5d:	83 c4 08             	add    $0x8,%esp
  800d60:	85 c0                	test   %eax,%eax
  800d62:	78 05                	js     800d69 <fd_close+0x2c>
	    || fd != fd2)
  800d64:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800d67:	74 0c                	je     800d75 <fd_close+0x38>
		return (must_exist ? r : 0);
  800d69:	84 db                	test   %bl,%bl
  800d6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d70:	0f 44 c2             	cmove  %edx,%eax
  800d73:	eb 41                	jmp    800db6 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800d75:	83 ec 08             	sub    $0x8,%esp
  800d78:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d7b:	50                   	push   %eax
  800d7c:	ff 36                	pushl  (%esi)
  800d7e:	e8 67 ff ff ff       	call   800cea <dev_lookup>
  800d83:	89 c3                	mov    %eax,%ebx
  800d85:	83 c4 10             	add    $0x10,%esp
  800d88:	85 c0                	test   %eax,%eax
  800d8a:	78 1a                	js     800da6 <fd_close+0x69>
		if (dev->dev_close)
  800d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d8f:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800d92:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800d97:	85 c0                	test   %eax,%eax
  800d99:	74 0b                	je     800da6 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  800d9b:	83 ec 0c             	sub    $0xc,%esp
  800d9e:	56                   	push   %esi
  800d9f:	ff d0                	call   *%eax
  800da1:	89 c3                	mov    %eax,%ebx
  800da3:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800da6:	83 ec 08             	sub    $0x8,%esp
  800da9:	56                   	push   %esi
  800daa:	6a 00                	push   $0x0
  800dac:	e8 99 fd ff ff       	call   800b4a <sys_page_unmap>
	return r;
  800db1:	83 c4 10             	add    $0x10,%esp
  800db4:	89 d8                	mov    %ebx,%eax
}
  800db6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800db9:	5b                   	pop    %ebx
  800dba:	5e                   	pop    %esi
  800dbb:	5d                   	pop    %ebp
  800dbc:	c3                   	ret    

00800dbd <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800dc3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800dc6:	50                   	push   %eax
  800dc7:	ff 75 08             	pushl  0x8(%ebp)
  800dca:	e8 c5 fe ff ff       	call   800c94 <fd_lookup>
  800dcf:	83 c4 08             	add    $0x8,%esp
  800dd2:	85 c0                	test   %eax,%eax
  800dd4:	78 10                	js     800de6 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800dd6:	83 ec 08             	sub    $0x8,%esp
  800dd9:	6a 01                	push   $0x1
  800ddb:	ff 75 f4             	pushl  -0xc(%ebp)
  800dde:	e8 5a ff ff ff       	call   800d3d <fd_close>
  800de3:	83 c4 10             	add    $0x10,%esp
}
  800de6:	c9                   	leave  
  800de7:	c3                   	ret    

00800de8 <close_all>:

void
close_all(void)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	53                   	push   %ebx
  800dec:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800def:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800df4:	83 ec 0c             	sub    $0xc,%esp
  800df7:	53                   	push   %ebx
  800df8:	e8 c0 ff ff ff       	call   800dbd <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800dfd:	83 c3 01             	add    $0x1,%ebx
  800e00:	83 c4 10             	add    $0x10,%esp
  800e03:	83 fb 20             	cmp    $0x20,%ebx
  800e06:	75 ec                	jne    800df4 <close_all+0xc>
		close(i);
}
  800e08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	57                   	push   %edi
  800e11:	56                   	push   %esi
  800e12:	53                   	push   %ebx
  800e13:	83 ec 2c             	sub    $0x2c,%esp
  800e16:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800e19:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800e1c:	50                   	push   %eax
  800e1d:	ff 75 08             	pushl  0x8(%ebp)
  800e20:	e8 6f fe ff ff       	call   800c94 <fd_lookup>
  800e25:	83 c4 08             	add    $0x8,%esp
  800e28:	85 c0                	test   %eax,%eax
  800e2a:	0f 88 c1 00 00 00    	js     800ef1 <dup+0xe4>
		return r;
	close(newfdnum);
  800e30:	83 ec 0c             	sub    $0xc,%esp
  800e33:	56                   	push   %esi
  800e34:	e8 84 ff ff ff       	call   800dbd <close>

	newfd = INDEX2FD(newfdnum);
  800e39:	89 f3                	mov    %esi,%ebx
  800e3b:	c1 e3 0c             	shl    $0xc,%ebx
  800e3e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800e44:	83 c4 04             	add    $0x4,%esp
  800e47:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e4a:	e8 de fd ff ff       	call   800c2d <fd2data>
  800e4f:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  800e51:	89 1c 24             	mov    %ebx,(%esp)
  800e54:	e8 d4 fd ff ff       	call   800c2d <fd2data>
  800e59:	83 c4 10             	add    $0x10,%esp
  800e5c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800e5f:	89 f8                	mov    %edi,%eax
  800e61:	c1 e8 16             	shr    $0x16,%eax
  800e64:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800e6b:	a8 01                	test   $0x1,%al
  800e6d:	74 37                	je     800ea6 <dup+0x99>
  800e6f:	89 f8                	mov    %edi,%eax
  800e71:	c1 e8 0c             	shr    $0xc,%eax
  800e74:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800e7b:	f6 c2 01             	test   $0x1,%dl
  800e7e:	74 26                	je     800ea6 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800e80:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	25 07 0e 00 00       	and    $0xe07,%eax
  800e8f:	50                   	push   %eax
  800e90:	ff 75 d4             	pushl  -0x2c(%ebp)
  800e93:	6a 00                	push   $0x0
  800e95:	57                   	push   %edi
  800e96:	6a 00                	push   $0x0
  800e98:	e8 87 fc ff ff       	call   800b24 <sys_page_map>
  800e9d:	89 c7                	mov    %eax,%edi
  800e9f:	83 c4 20             	add    $0x20,%esp
  800ea2:	85 c0                	test   %eax,%eax
  800ea4:	78 2e                	js     800ed4 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800ea6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ea9:	89 d0                	mov    %edx,%eax
  800eab:	c1 e8 0c             	shr    $0xc,%eax
  800eae:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800eb5:	83 ec 0c             	sub    $0xc,%esp
  800eb8:	25 07 0e 00 00       	and    $0xe07,%eax
  800ebd:	50                   	push   %eax
  800ebe:	53                   	push   %ebx
  800ebf:	6a 00                	push   $0x0
  800ec1:	52                   	push   %edx
  800ec2:	6a 00                	push   $0x0
  800ec4:	e8 5b fc ff ff       	call   800b24 <sys_page_map>
  800ec9:	89 c7                	mov    %eax,%edi
  800ecb:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  800ece:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800ed0:	85 ff                	test   %edi,%edi
  800ed2:	79 1d                	jns    800ef1 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800ed4:	83 ec 08             	sub    $0x8,%esp
  800ed7:	53                   	push   %ebx
  800ed8:	6a 00                	push   $0x0
  800eda:	e8 6b fc ff ff       	call   800b4a <sys_page_unmap>
	sys_page_unmap(0, nva);
  800edf:	83 c4 08             	add    $0x8,%esp
  800ee2:	ff 75 d4             	pushl  -0x2c(%ebp)
  800ee5:	6a 00                	push   $0x0
  800ee7:	e8 5e fc ff ff       	call   800b4a <sys_page_unmap>
	return r;
  800eec:	83 c4 10             	add    $0x10,%esp
  800eef:	89 f8                	mov    %edi,%eax
}
  800ef1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef4:	5b                   	pop    %ebx
  800ef5:	5e                   	pop    %esi
  800ef6:	5f                   	pop    %edi
  800ef7:	5d                   	pop    %ebp
  800ef8:	c3                   	ret    

00800ef9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
  800efc:	53                   	push   %ebx
  800efd:	83 ec 14             	sub    $0x14,%esp
  800f00:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800f03:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800f06:	50                   	push   %eax
  800f07:	53                   	push   %ebx
  800f08:	e8 87 fd ff ff       	call   800c94 <fd_lookup>
  800f0d:	83 c4 08             	add    $0x8,%esp
  800f10:	89 c2                	mov    %eax,%edx
  800f12:	85 c0                	test   %eax,%eax
  800f14:	78 6d                	js     800f83 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800f16:	83 ec 08             	sub    $0x8,%esp
  800f19:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f1c:	50                   	push   %eax
  800f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f20:	ff 30                	pushl  (%eax)
  800f22:	e8 c3 fd ff ff       	call   800cea <dev_lookup>
  800f27:	83 c4 10             	add    $0x10,%esp
  800f2a:	85 c0                	test   %eax,%eax
  800f2c:	78 4c                	js     800f7a <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800f2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f31:	8b 42 08             	mov    0x8(%edx),%eax
  800f34:	83 e0 03             	and    $0x3,%eax
  800f37:	83 f8 01             	cmp    $0x1,%eax
  800f3a:	75 21                	jne    800f5d <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800f3c:	a1 04 40 80 00       	mov    0x804004,%eax
  800f41:	8b 40 48             	mov    0x48(%eax),%eax
  800f44:	83 ec 04             	sub    $0x4,%esp
  800f47:	53                   	push   %ebx
  800f48:	50                   	push   %eax
  800f49:	68 ed 20 80 00       	push   $0x8020ed
  800f4e:	e8 f2 f1 ff ff       	call   800145 <cprintf>
		return -E_INVAL;
  800f53:	83 c4 10             	add    $0x10,%esp
  800f56:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800f5b:	eb 26                	jmp    800f83 <read+0x8a>
	}
	if (!dev->dev_read)
  800f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f60:	8b 40 08             	mov    0x8(%eax),%eax
  800f63:	85 c0                	test   %eax,%eax
  800f65:	74 17                	je     800f7e <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800f67:	83 ec 04             	sub    $0x4,%esp
  800f6a:	ff 75 10             	pushl  0x10(%ebp)
  800f6d:	ff 75 0c             	pushl  0xc(%ebp)
  800f70:	52                   	push   %edx
  800f71:	ff d0                	call   *%eax
  800f73:	89 c2                	mov    %eax,%edx
  800f75:	83 c4 10             	add    $0x10,%esp
  800f78:	eb 09                	jmp    800f83 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800f7a:	89 c2                	mov    %eax,%edx
  800f7c:	eb 05                	jmp    800f83 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800f7e:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  800f83:	89 d0                	mov    %edx,%eax
  800f85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    

00800f8a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	57                   	push   %edi
  800f8e:	56                   	push   %esi
  800f8f:	53                   	push   %ebx
  800f90:	83 ec 0c             	sub    $0xc,%esp
  800f93:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f96:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800f99:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9e:	eb 21                	jmp    800fc1 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800fa0:	83 ec 04             	sub    $0x4,%esp
  800fa3:	89 f0                	mov    %esi,%eax
  800fa5:	29 d8                	sub    %ebx,%eax
  800fa7:	50                   	push   %eax
  800fa8:	89 d8                	mov    %ebx,%eax
  800faa:	03 45 0c             	add    0xc(%ebp),%eax
  800fad:	50                   	push   %eax
  800fae:	57                   	push   %edi
  800faf:	e8 45 ff ff ff       	call   800ef9 <read>
		if (m < 0)
  800fb4:	83 c4 10             	add    $0x10,%esp
  800fb7:	85 c0                	test   %eax,%eax
  800fb9:	78 10                	js     800fcb <readn+0x41>
			return m;
		if (m == 0)
  800fbb:	85 c0                	test   %eax,%eax
  800fbd:	74 0a                	je     800fc9 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800fbf:	01 c3                	add    %eax,%ebx
  800fc1:	39 f3                	cmp    %esi,%ebx
  800fc3:	72 db                	jb     800fa0 <readn+0x16>
  800fc5:	89 d8                	mov    %ebx,%eax
  800fc7:	eb 02                	jmp    800fcb <readn+0x41>
  800fc9:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  800fcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fce:	5b                   	pop    %ebx
  800fcf:	5e                   	pop    %esi
  800fd0:	5f                   	pop    %edi
  800fd1:	5d                   	pop    %ebp
  800fd2:	c3                   	ret    

00800fd3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	53                   	push   %ebx
  800fd7:	83 ec 14             	sub    $0x14,%esp
  800fda:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800fdd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800fe0:	50                   	push   %eax
  800fe1:	53                   	push   %ebx
  800fe2:	e8 ad fc ff ff       	call   800c94 <fd_lookup>
  800fe7:	83 c4 08             	add    $0x8,%esp
  800fea:	89 c2                	mov    %eax,%edx
  800fec:	85 c0                	test   %eax,%eax
  800fee:	78 68                	js     801058 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ff0:	83 ec 08             	sub    $0x8,%esp
  800ff3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ff6:	50                   	push   %eax
  800ff7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ffa:	ff 30                	pushl  (%eax)
  800ffc:	e8 e9 fc ff ff       	call   800cea <dev_lookup>
  801001:	83 c4 10             	add    $0x10,%esp
  801004:	85 c0                	test   %eax,%eax
  801006:	78 47                	js     80104f <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801008:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80100b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80100f:	75 21                	jne    801032 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801011:	a1 04 40 80 00       	mov    0x804004,%eax
  801016:	8b 40 48             	mov    0x48(%eax),%eax
  801019:	83 ec 04             	sub    $0x4,%esp
  80101c:	53                   	push   %ebx
  80101d:	50                   	push   %eax
  80101e:	68 09 21 80 00       	push   $0x802109
  801023:	e8 1d f1 ff ff       	call   800145 <cprintf>
		return -E_INVAL;
  801028:	83 c4 10             	add    $0x10,%esp
  80102b:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801030:	eb 26                	jmp    801058 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801032:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801035:	8b 52 0c             	mov    0xc(%edx),%edx
  801038:	85 d2                	test   %edx,%edx
  80103a:	74 17                	je     801053 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80103c:	83 ec 04             	sub    $0x4,%esp
  80103f:	ff 75 10             	pushl  0x10(%ebp)
  801042:	ff 75 0c             	pushl  0xc(%ebp)
  801045:	50                   	push   %eax
  801046:	ff d2                	call   *%edx
  801048:	89 c2                	mov    %eax,%edx
  80104a:	83 c4 10             	add    $0x10,%esp
  80104d:	eb 09                	jmp    801058 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80104f:	89 c2                	mov    %eax,%edx
  801051:	eb 05                	jmp    801058 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801053:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  801058:	89 d0                	mov    %edx,%eax
  80105a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80105d:	c9                   	leave  
  80105e:	c3                   	ret    

0080105f <seek>:

int
seek(int fdnum, off_t offset)
{
  80105f:	55                   	push   %ebp
  801060:	89 e5                	mov    %esp,%ebp
  801062:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801065:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801068:	50                   	push   %eax
  801069:	ff 75 08             	pushl  0x8(%ebp)
  80106c:	e8 23 fc ff ff       	call   800c94 <fd_lookup>
  801071:	83 c4 08             	add    $0x8,%esp
  801074:	85 c0                	test   %eax,%eax
  801076:	78 0e                	js     801086 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801078:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80107e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801081:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801086:	c9                   	leave  
  801087:	c3                   	ret    

00801088 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801088:	55                   	push   %ebp
  801089:	89 e5                	mov    %esp,%ebp
  80108b:	53                   	push   %ebx
  80108c:	83 ec 14             	sub    $0x14,%esp
  80108f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801092:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801095:	50                   	push   %eax
  801096:	53                   	push   %ebx
  801097:	e8 f8 fb ff ff       	call   800c94 <fd_lookup>
  80109c:	83 c4 08             	add    $0x8,%esp
  80109f:	89 c2                	mov    %eax,%edx
  8010a1:	85 c0                	test   %eax,%eax
  8010a3:	78 65                	js     80110a <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010a5:	83 ec 08             	sub    $0x8,%esp
  8010a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010ab:	50                   	push   %eax
  8010ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010af:	ff 30                	pushl  (%eax)
  8010b1:	e8 34 fc ff ff       	call   800cea <dev_lookup>
  8010b6:	83 c4 10             	add    $0x10,%esp
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	78 44                	js     801101 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8010bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8010c4:	75 21                	jne    8010e7 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8010c6:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8010cb:	8b 40 48             	mov    0x48(%eax),%eax
  8010ce:	83 ec 04             	sub    $0x4,%esp
  8010d1:	53                   	push   %ebx
  8010d2:	50                   	push   %eax
  8010d3:	68 cc 20 80 00       	push   $0x8020cc
  8010d8:	e8 68 f0 ff ff       	call   800145 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8010dd:	83 c4 10             	add    $0x10,%esp
  8010e0:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8010e5:	eb 23                	jmp    80110a <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  8010e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ea:	8b 52 18             	mov    0x18(%edx),%edx
  8010ed:	85 d2                	test   %edx,%edx
  8010ef:	74 14                	je     801105 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8010f1:	83 ec 08             	sub    $0x8,%esp
  8010f4:	ff 75 0c             	pushl  0xc(%ebp)
  8010f7:	50                   	push   %eax
  8010f8:	ff d2                	call   *%edx
  8010fa:	89 c2                	mov    %eax,%edx
  8010fc:	83 c4 10             	add    $0x10,%esp
  8010ff:	eb 09                	jmp    80110a <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801101:	89 c2                	mov    %eax,%edx
  801103:	eb 05                	jmp    80110a <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801105:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  80110a:	89 d0                	mov    %edx,%eax
  80110c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	53                   	push   %ebx
  801115:	83 ec 14             	sub    $0x14,%esp
  801118:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80111b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80111e:	50                   	push   %eax
  80111f:	ff 75 08             	pushl  0x8(%ebp)
  801122:	e8 6d fb ff ff       	call   800c94 <fd_lookup>
  801127:	83 c4 08             	add    $0x8,%esp
  80112a:	89 c2                	mov    %eax,%edx
  80112c:	85 c0                	test   %eax,%eax
  80112e:	78 58                	js     801188 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801130:	83 ec 08             	sub    $0x8,%esp
  801133:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801136:	50                   	push   %eax
  801137:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80113a:	ff 30                	pushl  (%eax)
  80113c:	e8 a9 fb ff ff       	call   800cea <dev_lookup>
  801141:	83 c4 10             	add    $0x10,%esp
  801144:	85 c0                	test   %eax,%eax
  801146:	78 37                	js     80117f <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  801148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80114b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80114f:	74 32                	je     801183 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801151:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801154:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80115b:	00 00 00 
	stat->st_isdir = 0;
  80115e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801165:	00 00 00 
	stat->st_dev = dev;
  801168:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80116e:	83 ec 08             	sub    $0x8,%esp
  801171:	53                   	push   %ebx
  801172:	ff 75 f0             	pushl  -0x10(%ebp)
  801175:	ff 50 14             	call   *0x14(%eax)
  801178:	89 c2                	mov    %eax,%edx
  80117a:	83 c4 10             	add    $0x10,%esp
  80117d:	eb 09                	jmp    801188 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80117f:	89 c2                	mov    %eax,%edx
  801181:	eb 05                	jmp    801188 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801183:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801188:	89 d0                	mov    %edx,%eax
  80118a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80118d:	c9                   	leave  
  80118e:	c3                   	ret    

0080118f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
  801192:	56                   	push   %esi
  801193:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801194:	83 ec 08             	sub    $0x8,%esp
  801197:	6a 00                	push   $0x0
  801199:	ff 75 08             	pushl  0x8(%ebp)
  80119c:	e8 06 02 00 00       	call   8013a7 <open>
  8011a1:	89 c3                	mov    %eax,%ebx
  8011a3:	83 c4 10             	add    $0x10,%esp
  8011a6:	85 c0                	test   %eax,%eax
  8011a8:	78 1b                	js     8011c5 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8011aa:	83 ec 08             	sub    $0x8,%esp
  8011ad:	ff 75 0c             	pushl  0xc(%ebp)
  8011b0:	50                   	push   %eax
  8011b1:	e8 5b ff ff ff       	call   801111 <fstat>
  8011b6:	89 c6                	mov    %eax,%esi
	close(fd);
  8011b8:	89 1c 24             	mov    %ebx,(%esp)
  8011bb:	e8 fd fb ff ff       	call   800dbd <close>
	return r;
  8011c0:	83 c4 10             	add    $0x10,%esp
  8011c3:	89 f0                	mov    %esi,%eax
}
  8011c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011c8:	5b                   	pop    %ebx
  8011c9:	5e                   	pop    %esi
  8011ca:	5d                   	pop    %ebp
  8011cb:	c3                   	ret    

008011cc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8011cc:	55                   	push   %ebp
  8011cd:	89 e5                	mov    %esp,%ebp
  8011cf:	56                   	push   %esi
  8011d0:	53                   	push   %ebx
  8011d1:	89 c6                	mov    %eax,%esi
  8011d3:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8011d5:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8011dc:	75 12                	jne    8011f0 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8011de:	83 ec 0c             	sub    $0xc,%esp
  8011e1:	6a 01                	push   $0x1
  8011e3:	e8 47 08 00 00       	call   801a2f <ipc_find_env>
  8011e8:	a3 00 40 80 00       	mov    %eax,0x804000
  8011ed:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8011f0:	6a 07                	push   $0x7
  8011f2:	68 00 50 80 00       	push   $0x805000
  8011f7:	56                   	push   %esi
  8011f8:	ff 35 00 40 80 00    	pushl  0x804000
  8011fe:	e8 d8 07 00 00       	call   8019db <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801203:	83 c4 0c             	add    $0xc,%esp
  801206:	6a 00                	push   $0x0
  801208:	53                   	push   %ebx
  801209:	6a 00                	push   $0x0
  80120b:	e8 60 07 00 00       	call   801970 <ipc_recv>
}
  801210:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801213:	5b                   	pop    %ebx
  801214:	5e                   	pop    %esi
  801215:	5d                   	pop    %ebp
  801216:	c3                   	ret    

00801217 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
  80121a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	8b 40 0c             	mov    0xc(%eax),%eax
  801223:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801230:	ba 00 00 00 00       	mov    $0x0,%edx
  801235:	b8 02 00 00 00       	mov    $0x2,%eax
  80123a:	e8 8d ff ff ff       	call   8011cc <fsipc>
}
  80123f:	c9                   	leave  
  801240:	c3                   	ret    

00801241 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801241:	55                   	push   %ebp
  801242:	89 e5                	mov    %esp,%ebp
  801244:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	8b 40 0c             	mov    0xc(%eax),%eax
  80124d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801252:	ba 00 00 00 00       	mov    $0x0,%edx
  801257:	b8 06 00 00 00       	mov    $0x6,%eax
  80125c:	e8 6b ff ff ff       	call   8011cc <fsipc>
}
  801261:	c9                   	leave  
  801262:	c3                   	ret    

00801263 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
  801266:	53                   	push   %ebx
  801267:	83 ec 04             	sub    $0x4,%esp
  80126a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	8b 40 0c             	mov    0xc(%eax),%eax
  801273:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801278:	ba 00 00 00 00       	mov    $0x0,%edx
  80127d:	b8 05 00 00 00       	mov    $0x5,%eax
  801282:	e8 45 ff ff ff       	call   8011cc <fsipc>
  801287:	85 c0                	test   %eax,%eax
  801289:	78 2c                	js     8012b7 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80128b:	83 ec 08             	sub    $0x8,%esp
  80128e:	68 00 50 80 00       	push   $0x805000
  801293:	53                   	push   %ebx
  801294:	e8 1e f4 ff ff       	call   8006b7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801299:	a1 80 50 80 00       	mov    0x805080,%eax
  80129e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8012a4:	a1 84 50 80 00       	mov    0x805084,%eax
  8012a9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8012af:	83 c4 10             	add    $0x10,%esp
  8012b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012ba:	c9                   	leave  
  8012bb:	c3                   	ret    

008012bc <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	83 ec 08             	sub    $0x8,%esp
  8012c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c5:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8012c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012cb:	8b 49 0c             	mov    0xc(%ecx),%ecx
  8012ce:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  8012d4:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8012d9:	76 22                	jbe    8012fd <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  8012db:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  8012e2:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  8012e5:	83 ec 04             	sub    $0x4,%esp
  8012e8:	68 f8 0f 00 00       	push   $0xff8
  8012ed:	52                   	push   %edx
  8012ee:	68 08 50 80 00       	push   $0x805008
  8012f3:	e8 52 f5 ff ff       	call   80084a <memmove>
  8012f8:	83 c4 10             	add    $0x10,%esp
  8012fb:	eb 17                	jmp    801314 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  8012fd:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  801302:	83 ec 04             	sub    $0x4,%esp
  801305:	50                   	push   %eax
  801306:	52                   	push   %edx
  801307:	68 08 50 80 00       	push   $0x805008
  80130c:	e8 39 f5 ff ff       	call   80084a <memmove>
  801311:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  801314:	ba 00 00 00 00       	mov    $0x0,%edx
  801319:	b8 04 00 00 00       	mov    $0x4,%eax
  80131e:	e8 a9 fe ff ff       	call   8011cc <fsipc>
	if (result < 0)
		return result;

	return result;
}
  801323:	c9                   	leave  
  801324:	c3                   	ret    

00801325 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
  801328:	56                   	push   %esi
  801329:	53                   	push   %ebx
  80132a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80132d:	8b 45 08             	mov    0x8(%ebp),%eax
  801330:	8b 40 0c             	mov    0xc(%eax),%eax
  801333:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801338:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80133e:	ba 00 00 00 00       	mov    $0x0,%edx
  801343:	b8 03 00 00 00       	mov    $0x3,%eax
  801348:	e8 7f fe ff ff       	call   8011cc <fsipc>
  80134d:	89 c3                	mov    %eax,%ebx
  80134f:	85 c0                	test   %eax,%eax
  801351:	78 4b                	js     80139e <devfile_read+0x79>
		return r;
	assert(r <= n);
  801353:	39 c6                	cmp    %eax,%esi
  801355:	73 16                	jae    80136d <devfile_read+0x48>
  801357:	68 38 21 80 00       	push   $0x802138
  80135c:	68 3f 21 80 00       	push   $0x80213f
  801361:	6a 7c                	push   $0x7c
  801363:	68 54 21 80 00       	push   $0x802154
  801368:	e8 bd 05 00 00       	call   80192a <_panic>
	assert(r <= PGSIZE);
  80136d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801372:	7e 16                	jle    80138a <devfile_read+0x65>
  801374:	68 5f 21 80 00       	push   $0x80215f
  801379:	68 3f 21 80 00       	push   $0x80213f
  80137e:	6a 7d                	push   $0x7d
  801380:	68 54 21 80 00       	push   $0x802154
  801385:	e8 a0 05 00 00       	call   80192a <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80138a:	83 ec 04             	sub    $0x4,%esp
  80138d:	50                   	push   %eax
  80138e:	68 00 50 80 00       	push   $0x805000
  801393:	ff 75 0c             	pushl  0xc(%ebp)
  801396:	e8 af f4 ff ff       	call   80084a <memmove>
	return r;
  80139b:	83 c4 10             	add    $0x10,%esp
}
  80139e:	89 d8                	mov    %ebx,%eax
  8013a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013a3:	5b                   	pop    %ebx
  8013a4:	5e                   	pop    %esi
  8013a5:	5d                   	pop    %ebp
  8013a6:	c3                   	ret    

008013a7 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	53                   	push   %ebx
  8013ab:	83 ec 20             	sub    $0x20,%esp
  8013ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8013b1:	53                   	push   %ebx
  8013b2:	e8 c7 f2 ff ff       	call   80067e <strlen>
  8013b7:	83 c4 10             	add    $0x10,%esp
  8013ba:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8013bf:	7f 67                	jg     801428 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8013c1:	83 ec 0c             	sub    $0xc,%esp
  8013c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c7:	50                   	push   %eax
  8013c8:	e8 78 f8 ff ff       	call   800c45 <fd_alloc>
  8013cd:	83 c4 10             	add    $0x10,%esp
		return r;
  8013d0:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8013d2:	85 c0                	test   %eax,%eax
  8013d4:	78 57                	js     80142d <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8013d6:	83 ec 08             	sub    $0x8,%esp
  8013d9:	53                   	push   %ebx
  8013da:	68 00 50 80 00       	push   $0x805000
  8013df:	e8 d3 f2 ff ff       	call   8006b7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8013e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e7:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8013ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ef:	b8 01 00 00 00       	mov    $0x1,%eax
  8013f4:	e8 d3 fd ff ff       	call   8011cc <fsipc>
  8013f9:	89 c3                	mov    %eax,%ebx
  8013fb:	83 c4 10             	add    $0x10,%esp
  8013fe:	85 c0                	test   %eax,%eax
  801400:	79 14                	jns    801416 <open+0x6f>
		fd_close(fd, 0);
  801402:	83 ec 08             	sub    $0x8,%esp
  801405:	6a 00                	push   $0x0
  801407:	ff 75 f4             	pushl  -0xc(%ebp)
  80140a:	e8 2e f9 ff ff       	call   800d3d <fd_close>
		return r;
  80140f:	83 c4 10             	add    $0x10,%esp
  801412:	89 da                	mov    %ebx,%edx
  801414:	eb 17                	jmp    80142d <open+0x86>
	}

	return fd2num(fd);
  801416:	83 ec 0c             	sub    $0xc,%esp
  801419:	ff 75 f4             	pushl  -0xc(%ebp)
  80141c:	e8 fc f7 ff ff       	call   800c1d <fd2num>
  801421:	89 c2                	mov    %eax,%edx
  801423:	83 c4 10             	add    $0x10,%esp
  801426:	eb 05                	jmp    80142d <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801428:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  80142d:	89 d0                	mov    %edx,%eax
  80142f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801432:	c9                   	leave  
  801433:	c3                   	ret    

00801434 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
  801437:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80143a:	ba 00 00 00 00       	mov    $0x0,%edx
  80143f:	b8 08 00 00 00       	mov    $0x8,%eax
  801444:	e8 83 fd ff ff       	call   8011cc <fsipc>
}
  801449:	c9                   	leave  
  80144a:	c3                   	ret    

0080144b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
  80144e:	56                   	push   %esi
  80144f:	53                   	push   %ebx
  801450:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801453:	83 ec 0c             	sub    $0xc,%esp
  801456:	ff 75 08             	pushl  0x8(%ebp)
  801459:	e8 cf f7 ff ff       	call   800c2d <fd2data>
  80145e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801460:	83 c4 08             	add    $0x8,%esp
  801463:	68 6b 21 80 00       	push   $0x80216b
  801468:	53                   	push   %ebx
  801469:	e8 49 f2 ff ff       	call   8006b7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80146e:	8b 46 04             	mov    0x4(%esi),%eax
  801471:	2b 06                	sub    (%esi),%eax
  801473:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801479:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801480:	00 00 00 
	stat->st_dev = &devpipe;
  801483:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80148a:	30 80 00 
	return 0;
}
  80148d:	b8 00 00 00 00       	mov    $0x0,%eax
  801492:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801495:	5b                   	pop    %ebx
  801496:	5e                   	pop    %esi
  801497:	5d                   	pop    %ebp
  801498:	c3                   	ret    

00801499 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	53                   	push   %ebx
  80149d:	83 ec 0c             	sub    $0xc,%esp
  8014a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8014a3:	53                   	push   %ebx
  8014a4:	6a 00                	push   $0x0
  8014a6:	e8 9f f6 ff ff       	call   800b4a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8014ab:	89 1c 24             	mov    %ebx,(%esp)
  8014ae:	e8 7a f7 ff ff       	call   800c2d <fd2data>
  8014b3:	83 c4 08             	add    $0x8,%esp
  8014b6:	50                   	push   %eax
  8014b7:	6a 00                	push   $0x0
  8014b9:	e8 8c f6 ff ff       	call   800b4a <sys_page_unmap>
}
  8014be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	57                   	push   %edi
  8014c7:	56                   	push   %esi
  8014c8:	53                   	push   %ebx
  8014c9:	83 ec 1c             	sub    $0x1c,%esp
  8014cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8014cf:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8014d1:	a1 04 40 80 00       	mov    0x804004,%eax
  8014d6:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  8014d9:	83 ec 0c             	sub    $0xc,%esp
  8014dc:	ff 75 e0             	pushl  -0x20(%ebp)
  8014df:	e8 84 05 00 00       	call   801a68 <pageref>
  8014e4:	89 c3                	mov    %eax,%ebx
  8014e6:	89 3c 24             	mov    %edi,(%esp)
  8014e9:	e8 7a 05 00 00       	call   801a68 <pageref>
  8014ee:	83 c4 10             	add    $0x10,%esp
  8014f1:	39 c3                	cmp    %eax,%ebx
  8014f3:	0f 94 c1             	sete   %cl
  8014f6:	0f b6 c9             	movzbl %cl,%ecx
  8014f9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  8014fc:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801502:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801505:	39 ce                	cmp    %ecx,%esi
  801507:	74 1b                	je     801524 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801509:	39 c3                	cmp    %eax,%ebx
  80150b:	75 c4                	jne    8014d1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80150d:	8b 42 58             	mov    0x58(%edx),%eax
  801510:	ff 75 e4             	pushl  -0x1c(%ebp)
  801513:	50                   	push   %eax
  801514:	56                   	push   %esi
  801515:	68 72 21 80 00       	push   $0x802172
  80151a:	e8 26 ec ff ff       	call   800145 <cprintf>
  80151f:	83 c4 10             	add    $0x10,%esp
  801522:	eb ad                	jmp    8014d1 <_pipeisclosed+0xe>
	}
}
  801524:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801527:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80152a:	5b                   	pop    %ebx
  80152b:	5e                   	pop    %esi
  80152c:	5f                   	pop    %edi
  80152d:	5d                   	pop    %ebp
  80152e:	c3                   	ret    

0080152f <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
  801532:	57                   	push   %edi
  801533:	56                   	push   %esi
  801534:	53                   	push   %ebx
  801535:	83 ec 28             	sub    $0x28,%esp
  801538:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80153b:	56                   	push   %esi
  80153c:	e8 ec f6 ff ff       	call   800c2d <fd2data>
  801541:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801543:	83 c4 10             	add    $0x10,%esp
  801546:	bf 00 00 00 00       	mov    $0x0,%edi
  80154b:	eb 4b                	jmp    801598 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80154d:	89 da                	mov    %ebx,%edx
  80154f:	89 f0                	mov    %esi,%eax
  801551:	e8 6d ff ff ff       	call   8014c3 <_pipeisclosed>
  801556:	85 c0                	test   %eax,%eax
  801558:	75 48                	jne    8015a2 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80155a:	e8 7a f5 ff ff       	call   800ad9 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80155f:	8b 43 04             	mov    0x4(%ebx),%eax
  801562:	8b 0b                	mov    (%ebx),%ecx
  801564:	8d 51 20             	lea    0x20(%ecx),%edx
  801567:	39 d0                	cmp    %edx,%eax
  801569:	73 e2                	jae    80154d <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80156b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80156e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801572:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801575:	89 c2                	mov    %eax,%edx
  801577:	c1 fa 1f             	sar    $0x1f,%edx
  80157a:	89 d1                	mov    %edx,%ecx
  80157c:	c1 e9 1b             	shr    $0x1b,%ecx
  80157f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801582:	83 e2 1f             	and    $0x1f,%edx
  801585:	29 ca                	sub    %ecx,%edx
  801587:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80158b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80158f:	83 c0 01             	add    $0x1,%eax
  801592:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801595:	83 c7 01             	add    $0x1,%edi
  801598:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80159b:	75 c2                	jne    80155f <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80159d:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a0:	eb 05                	jmp    8015a7 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8015a2:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8015a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015aa:	5b                   	pop    %ebx
  8015ab:	5e                   	pop    %esi
  8015ac:	5f                   	pop    %edi
  8015ad:	5d                   	pop    %ebp
  8015ae:	c3                   	ret    

008015af <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
  8015b2:	57                   	push   %edi
  8015b3:	56                   	push   %esi
  8015b4:	53                   	push   %ebx
  8015b5:	83 ec 18             	sub    $0x18,%esp
  8015b8:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8015bb:	57                   	push   %edi
  8015bc:	e8 6c f6 ff ff       	call   800c2d <fd2data>
  8015c1:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8015c3:	83 c4 10             	add    $0x10,%esp
  8015c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015cb:	eb 3d                	jmp    80160a <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8015cd:	85 db                	test   %ebx,%ebx
  8015cf:	74 04                	je     8015d5 <devpipe_read+0x26>
				return i;
  8015d1:	89 d8                	mov    %ebx,%eax
  8015d3:	eb 44                	jmp    801619 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8015d5:	89 f2                	mov    %esi,%edx
  8015d7:	89 f8                	mov    %edi,%eax
  8015d9:	e8 e5 fe ff ff       	call   8014c3 <_pipeisclosed>
  8015de:	85 c0                	test   %eax,%eax
  8015e0:	75 32                	jne    801614 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8015e2:	e8 f2 f4 ff ff       	call   800ad9 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8015e7:	8b 06                	mov    (%esi),%eax
  8015e9:	3b 46 04             	cmp    0x4(%esi),%eax
  8015ec:	74 df                	je     8015cd <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8015ee:	99                   	cltd   
  8015ef:	c1 ea 1b             	shr    $0x1b,%edx
  8015f2:	01 d0                	add    %edx,%eax
  8015f4:	83 e0 1f             	and    $0x1f,%eax
  8015f7:	29 d0                	sub    %edx,%eax
  8015f9:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  8015fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801601:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801604:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801607:	83 c3 01             	add    $0x1,%ebx
  80160a:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  80160d:	75 d8                	jne    8015e7 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80160f:	8b 45 10             	mov    0x10(%ebp),%eax
  801612:	eb 05                	jmp    801619 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801614:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801619:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80161c:	5b                   	pop    %ebx
  80161d:	5e                   	pop    %esi
  80161e:	5f                   	pop    %edi
  80161f:	5d                   	pop    %ebp
  801620:	c3                   	ret    

00801621 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	56                   	push   %esi
  801625:	53                   	push   %ebx
  801626:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801629:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80162c:	50                   	push   %eax
  80162d:	e8 13 f6 ff ff       	call   800c45 <fd_alloc>
  801632:	83 c4 10             	add    $0x10,%esp
  801635:	89 c2                	mov    %eax,%edx
  801637:	85 c0                	test   %eax,%eax
  801639:	0f 88 2c 01 00 00    	js     80176b <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80163f:	83 ec 04             	sub    $0x4,%esp
  801642:	68 07 04 00 00       	push   $0x407
  801647:	ff 75 f4             	pushl  -0xc(%ebp)
  80164a:	6a 00                	push   $0x0
  80164c:	e8 af f4 ff ff       	call   800b00 <sys_page_alloc>
  801651:	83 c4 10             	add    $0x10,%esp
  801654:	89 c2                	mov    %eax,%edx
  801656:	85 c0                	test   %eax,%eax
  801658:	0f 88 0d 01 00 00    	js     80176b <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80165e:	83 ec 0c             	sub    $0xc,%esp
  801661:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801664:	50                   	push   %eax
  801665:	e8 db f5 ff ff       	call   800c45 <fd_alloc>
  80166a:	89 c3                	mov    %eax,%ebx
  80166c:	83 c4 10             	add    $0x10,%esp
  80166f:	85 c0                	test   %eax,%eax
  801671:	0f 88 e2 00 00 00    	js     801759 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801677:	83 ec 04             	sub    $0x4,%esp
  80167a:	68 07 04 00 00       	push   $0x407
  80167f:	ff 75 f0             	pushl  -0x10(%ebp)
  801682:	6a 00                	push   $0x0
  801684:	e8 77 f4 ff ff       	call   800b00 <sys_page_alloc>
  801689:	89 c3                	mov    %eax,%ebx
  80168b:	83 c4 10             	add    $0x10,%esp
  80168e:	85 c0                	test   %eax,%eax
  801690:	0f 88 c3 00 00 00    	js     801759 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801696:	83 ec 0c             	sub    $0xc,%esp
  801699:	ff 75 f4             	pushl  -0xc(%ebp)
  80169c:	e8 8c f5 ff ff       	call   800c2d <fd2data>
  8016a1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8016a3:	83 c4 0c             	add    $0xc,%esp
  8016a6:	68 07 04 00 00       	push   $0x407
  8016ab:	50                   	push   %eax
  8016ac:	6a 00                	push   $0x0
  8016ae:	e8 4d f4 ff ff       	call   800b00 <sys_page_alloc>
  8016b3:	89 c3                	mov    %eax,%ebx
  8016b5:	83 c4 10             	add    $0x10,%esp
  8016b8:	85 c0                	test   %eax,%eax
  8016ba:	0f 88 89 00 00 00    	js     801749 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8016c0:	83 ec 0c             	sub    $0xc,%esp
  8016c3:	ff 75 f0             	pushl  -0x10(%ebp)
  8016c6:	e8 62 f5 ff ff       	call   800c2d <fd2data>
  8016cb:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8016d2:	50                   	push   %eax
  8016d3:	6a 00                	push   $0x0
  8016d5:	56                   	push   %esi
  8016d6:	6a 00                	push   $0x0
  8016d8:	e8 47 f4 ff ff       	call   800b24 <sys_page_map>
  8016dd:	89 c3                	mov    %eax,%ebx
  8016df:	83 c4 20             	add    $0x20,%esp
  8016e2:	85 c0                	test   %eax,%eax
  8016e4:	78 55                	js     80173b <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8016e6:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8016ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ef:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8016f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8016fb:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801704:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801706:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801709:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801710:	83 ec 0c             	sub    $0xc,%esp
  801713:	ff 75 f4             	pushl  -0xc(%ebp)
  801716:	e8 02 f5 ff ff       	call   800c1d <fd2num>
  80171b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80171e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801720:	83 c4 04             	add    $0x4,%esp
  801723:	ff 75 f0             	pushl  -0x10(%ebp)
  801726:	e8 f2 f4 ff ff       	call   800c1d <fd2num>
  80172b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80172e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801731:	83 c4 10             	add    $0x10,%esp
  801734:	ba 00 00 00 00       	mov    $0x0,%edx
  801739:	eb 30                	jmp    80176b <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  80173b:	83 ec 08             	sub    $0x8,%esp
  80173e:	56                   	push   %esi
  80173f:	6a 00                	push   $0x0
  801741:	e8 04 f4 ff ff       	call   800b4a <sys_page_unmap>
  801746:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801749:	83 ec 08             	sub    $0x8,%esp
  80174c:	ff 75 f0             	pushl  -0x10(%ebp)
  80174f:	6a 00                	push   $0x0
  801751:	e8 f4 f3 ff ff       	call   800b4a <sys_page_unmap>
  801756:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801759:	83 ec 08             	sub    $0x8,%esp
  80175c:	ff 75 f4             	pushl  -0xc(%ebp)
  80175f:	6a 00                	push   $0x0
  801761:	e8 e4 f3 ff ff       	call   800b4a <sys_page_unmap>
  801766:	83 c4 10             	add    $0x10,%esp
  801769:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  80176b:	89 d0                	mov    %edx,%eax
  80176d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801770:	5b                   	pop    %ebx
  801771:	5e                   	pop    %esi
  801772:	5d                   	pop    %ebp
  801773:	c3                   	ret    

00801774 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80177a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80177d:	50                   	push   %eax
  80177e:	ff 75 08             	pushl  0x8(%ebp)
  801781:	e8 0e f5 ff ff       	call   800c94 <fd_lookup>
  801786:	83 c4 10             	add    $0x10,%esp
  801789:	85 c0                	test   %eax,%eax
  80178b:	78 18                	js     8017a5 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  80178d:	83 ec 0c             	sub    $0xc,%esp
  801790:	ff 75 f4             	pushl  -0xc(%ebp)
  801793:	e8 95 f4 ff ff       	call   800c2d <fd2data>
	return _pipeisclosed(fd, p);
  801798:	89 c2                	mov    %eax,%edx
  80179a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179d:	e8 21 fd ff ff       	call   8014c3 <_pipeisclosed>
  8017a2:	83 c4 10             	add    $0x10,%esp
}
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    

008017a7 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8017aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8017af:	5d                   	pop    %ebp
  8017b0:	c3                   	ret    

008017b1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
  8017b4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8017b7:	68 8a 21 80 00       	push   $0x80218a
  8017bc:	ff 75 0c             	pushl  0xc(%ebp)
  8017bf:	e8 f3 ee ff ff       	call   8006b7 <strcpy>
	return 0;
}
  8017c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	57                   	push   %edi
  8017cf:	56                   	push   %esi
  8017d0:	53                   	push   %ebx
  8017d1:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8017d7:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8017dc:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8017e2:	eb 2d                	jmp    801811 <devcons_write+0x46>
		m = n - tot;
  8017e4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8017e7:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  8017e9:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8017ec:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8017f1:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8017f4:	83 ec 04             	sub    $0x4,%esp
  8017f7:	53                   	push   %ebx
  8017f8:	03 45 0c             	add    0xc(%ebp),%eax
  8017fb:	50                   	push   %eax
  8017fc:	57                   	push   %edi
  8017fd:	e8 48 f0 ff ff       	call   80084a <memmove>
		sys_cputs(buf, m);
  801802:	83 c4 08             	add    $0x8,%esp
  801805:	53                   	push   %ebx
  801806:	57                   	push   %edi
  801807:	e8 3d f2 ff ff       	call   800a49 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80180c:	01 de                	add    %ebx,%esi
  80180e:	83 c4 10             	add    $0x10,%esp
  801811:	89 f0                	mov    %esi,%eax
  801813:	3b 75 10             	cmp    0x10(%ebp),%esi
  801816:	72 cc                	jb     8017e4 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801818:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80181b:	5b                   	pop    %ebx
  80181c:	5e                   	pop    %esi
  80181d:	5f                   	pop    %edi
  80181e:	5d                   	pop    %ebp
  80181f:	c3                   	ret    

00801820 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 08             	sub    $0x8,%esp
  801826:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  80182b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80182f:	74 2a                	je     80185b <devcons_read+0x3b>
  801831:	eb 05                	jmp    801838 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801833:	e8 a1 f2 ff ff       	call   800ad9 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801838:	e8 32 f2 ff ff       	call   800a6f <sys_cgetc>
  80183d:	85 c0                	test   %eax,%eax
  80183f:	74 f2                	je     801833 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801841:	85 c0                	test   %eax,%eax
  801843:	78 16                	js     80185b <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801845:	83 f8 04             	cmp    $0x4,%eax
  801848:	74 0c                	je     801856 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80184a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184d:	88 02                	mov    %al,(%edx)
	return 1;
  80184f:	b8 01 00 00 00       	mov    $0x1,%eax
  801854:	eb 05                	jmp    80185b <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801856:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801863:	8b 45 08             	mov    0x8(%ebp),%eax
  801866:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801869:	6a 01                	push   $0x1
  80186b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80186e:	50                   	push   %eax
  80186f:	e8 d5 f1 ff ff       	call   800a49 <sys_cputs>
}
  801874:	83 c4 10             	add    $0x10,%esp
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <getchar>:

int
getchar(void)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80187f:	6a 01                	push   $0x1
  801881:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801884:	50                   	push   %eax
  801885:	6a 00                	push   $0x0
  801887:	e8 6d f6 ff ff       	call   800ef9 <read>
	if (r < 0)
  80188c:	83 c4 10             	add    $0x10,%esp
  80188f:	85 c0                	test   %eax,%eax
  801891:	78 0f                	js     8018a2 <getchar+0x29>
		return r;
	if (r < 1)
  801893:	85 c0                	test   %eax,%eax
  801895:	7e 06                	jle    80189d <getchar+0x24>
		return -E_EOF;
	return c;
  801897:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  80189b:	eb 05                	jmp    8018a2 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  80189d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ad:	50                   	push   %eax
  8018ae:	ff 75 08             	pushl  0x8(%ebp)
  8018b1:	e8 de f3 ff ff       	call   800c94 <fd_lookup>
  8018b6:	83 c4 10             	add    $0x10,%esp
  8018b9:	85 c0                	test   %eax,%eax
  8018bb:	78 11                	js     8018ce <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8018bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c0:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8018c6:	39 10                	cmp    %edx,(%eax)
  8018c8:	0f 94 c0             	sete   %al
  8018cb:	0f b6 c0             	movzbl %al,%eax
}
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <opencons>:

int
opencons(void)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8018d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d9:	50                   	push   %eax
  8018da:	e8 66 f3 ff ff       	call   800c45 <fd_alloc>
  8018df:	83 c4 10             	add    $0x10,%esp
		return r;
  8018e2:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8018e4:	85 c0                	test   %eax,%eax
  8018e6:	78 3e                	js     801926 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8018e8:	83 ec 04             	sub    $0x4,%esp
  8018eb:	68 07 04 00 00       	push   $0x407
  8018f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8018f3:	6a 00                	push   $0x0
  8018f5:	e8 06 f2 ff ff       	call   800b00 <sys_page_alloc>
  8018fa:	83 c4 10             	add    $0x10,%esp
		return r;
  8018fd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8018ff:	85 c0                	test   %eax,%eax
  801901:	78 23                	js     801926 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801903:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80190e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801911:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801918:	83 ec 0c             	sub    $0xc,%esp
  80191b:	50                   	push   %eax
  80191c:	e8 fc f2 ff ff       	call   800c1d <fd2num>
  801921:	89 c2                	mov    %eax,%edx
  801923:	83 c4 10             	add    $0x10,%esp
}
  801926:	89 d0                	mov    %edx,%eax
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	56                   	push   %esi
  80192e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80192f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801932:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801938:	e8 78 f1 ff ff       	call   800ab5 <sys_getenvid>
  80193d:	83 ec 0c             	sub    $0xc,%esp
  801940:	ff 75 0c             	pushl  0xc(%ebp)
  801943:	ff 75 08             	pushl  0x8(%ebp)
  801946:	56                   	push   %esi
  801947:	50                   	push   %eax
  801948:	68 98 21 80 00       	push   $0x802198
  80194d:	e8 f3 e7 ff ff       	call   800145 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801952:	83 c4 18             	add    $0x18,%esp
  801955:	53                   	push   %ebx
  801956:	ff 75 10             	pushl  0x10(%ebp)
  801959:	e8 96 e7 ff ff       	call   8000f4 <vcprintf>
	cprintf("\n");
  80195e:	c7 04 24 83 21 80 00 	movl   $0x802183,(%esp)
  801965:	e8 db e7 ff ff       	call   800145 <cprintf>
  80196a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80196d:	cc                   	int3   
  80196e:	eb fd                	jmp    80196d <_panic+0x43>

00801970 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	56                   	push   %esi
  801974:	53                   	push   %ebx
  801975:	8b 75 08             	mov    0x8(%ebp),%esi
  801978:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  80197e:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801980:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801985:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801988:	83 ec 0c             	sub    $0xc,%esp
  80198b:	50                   	push   %eax
  80198c:	e8 6a f2 ff ff       	call   800bfb <sys_ipc_recv>
	if (from_env_store)
  801991:	83 c4 10             	add    $0x10,%esp
  801994:	85 f6                	test   %esi,%esi
  801996:	74 0b                	je     8019a3 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801998:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80199e:	8b 52 74             	mov    0x74(%edx),%edx
  8019a1:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8019a3:	85 db                	test   %ebx,%ebx
  8019a5:	74 0b                	je     8019b2 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  8019a7:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019ad:	8b 52 78             	mov    0x78(%edx),%edx
  8019b0:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  8019b2:	85 c0                	test   %eax,%eax
  8019b4:	79 16                	jns    8019cc <ipc_recv+0x5c>
		if (from_env_store)
  8019b6:	85 f6                	test   %esi,%esi
  8019b8:	74 06                	je     8019c0 <ipc_recv+0x50>
			*from_env_store = 0;
  8019ba:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  8019c0:	85 db                	test   %ebx,%ebx
  8019c2:	74 10                	je     8019d4 <ipc_recv+0x64>
			*perm_store = 0;
  8019c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8019ca:	eb 08                	jmp    8019d4 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  8019cc:	a1 04 40 80 00       	mov    0x804004,%eax
  8019d1:	8b 40 70             	mov    0x70(%eax),%eax
}
  8019d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019d7:	5b                   	pop    %ebx
  8019d8:	5e                   	pop    %esi
  8019d9:	5d                   	pop    %ebp
  8019da:	c3                   	ret    

008019db <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	57                   	push   %edi
  8019df:	56                   	push   %esi
  8019e0:	53                   	push   %ebx
  8019e1:	83 ec 0c             	sub    $0xc,%esp
  8019e4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019e7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  8019ed:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  8019ef:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8019f4:	0f 44 d8             	cmove  %eax,%ebx
  8019f7:	eb 1c                	jmp    801a15 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  8019f9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8019fc:	74 12                	je     801a10 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  8019fe:	50                   	push   %eax
  8019ff:	68 bc 21 80 00       	push   $0x8021bc
  801a04:	6a 42                	push   $0x42
  801a06:	68 d2 21 80 00       	push   $0x8021d2
  801a0b:	e8 1a ff ff ff       	call   80192a <_panic>
		sys_yield();
  801a10:	e8 c4 f0 ff ff       	call   800ad9 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801a15:	ff 75 14             	pushl  0x14(%ebp)
  801a18:	53                   	push   %ebx
  801a19:	56                   	push   %esi
  801a1a:	57                   	push   %edi
  801a1b:	e8 b6 f1 ff ff       	call   800bd6 <sys_ipc_try_send>
  801a20:	83 c4 10             	add    $0x10,%esp
  801a23:	85 c0                	test   %eax,%eax
  801a25:	75 d2                	jne    8019f9 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801a27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a2a:	5b                   	pop    %ebx
  801a2b:	5e                   	pop    %esi
  801a2c:	5f                   	pop    %edi
  801a2d:	5d                   	pop    %ebp
  801a2e:	c3                   	ret    

00801a2f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801a35:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801a3a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801a3d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801a43:	8b 52 50             	mov    0x50(%edx),%edx
  801a46:	39 ca                	cmp    %ecx,%edx
  801a48:	75 0d                	jne    801a57 <ipc_find_env+0x28>
			return envs[i].env_id;
  801a4a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a4d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a52:	8b 40 48             	mov    0x48(%eax),%eax
  801a55:	eb 0f                	jmp    801a66 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801a57:	83 c0 01             	add    $0x1,%eax
  801a5a:	3d 00 04 00 00       	cmp    $0x400,%eax
  801a5f:	75 d9                	jne    801a3a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801a61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a66:	5d                   	pop    %ebp
  801a67:	c3                   	ret    

00801a68 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
  801a6b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a6e:	89 d0                	mov    %edx,%eax
  801a70:	c1 e8 16             	shr    $0x16,%eax
  801a73:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801a7a:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a7f:	f6 c1 01             	test   $0x1,%cl
  801a82:	74 1d                	je     801aa1 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801a84:	c1 ea 0c             	shr    $0xc,%edx
  801a87:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801a8e:	f6 c2 01             	test   $0x1,%dl
  801a91:	74 0e                	je     801aa1 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801a93:	c1 ea 0c             	shr    $0xc,%edx
  801a96:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801a9d:	ef 
  801a9e:	0f b7 c0             	movzwl %ax,%eax
}
  801aa1:	5d                   	pop    %ebp
  801aa2:	c3                   	ret    
  801aa3:	66 90                	xchg   %ax,%ax
  801aa5:	66 90                	xchg   %ax,%ax
  801aa7:	66 90                	xchg   %ax,%ax
  801aa9:	66 90                	xchg   %ax,%ax
  801aab:	66 90                	xchg   %ax,%ax
  801aad:	66 90                	xchg   %ax,%ax
  801aaf:	90                   	nop

00801ab0 <__udivdi3>:
  801ab0:	55                   	push   %ebp
  801ab1:	57                   	push   %edi
  801ab2:	56                   	push   %esi
  801ab3:	53                   	push   %ebx
  801ab4:	83 ec 1c             	sub    $0x1c,%esp
  801ab7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801abb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801abf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ac3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ac7:	85 f6                	test   %esi,%esi
  801ac9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801acd:	89 ca                	mov    %ecx,%edx
  801acf:	89 f8                	mov    %edi,%eax
  801ad1:	75 3d                	jne    801b10 <__udivdi3+0x60>
  801ad3:	39 cf                	cmp    %ecx,%edi
  801ad5:	0f 87 c5 00 00 00    	ja     801ba0 <__udivdi3+0xf0>
  801adb:	85 ff                	test   %edi,%edi
  801add:	89 fd                	mov    %edi,%ebp
  801adf:	75 0b                	jne    801aec <__udivdi3+0x3c>
  801ae1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae6:	31 d2                	xor    %edx,%edx
  801ae8:	f7 f7                	div    %edi
  801aea:	89 c5                	mov    %eax,%ebp
  801aec:	89 c8                	mov    %ecx,%eax
  801aee:	31 d2                	xor    %edx,%edx
  801af0:	f7 f5                	div    %ebp
  801af2:	89 c1                	mov    %eax,%ecx
  801af4:	89 d8                	mov    %ebx,%eax
  801af6:	89 cf                	mov    %ecx,%edi
  801af8:	f7 f5                	div    %ebp
  801afa:	89 c3                	mov    %eax,%ebx
  801afc:	89 d8                	mov    %ebx,%eax
  801afe:	89 fa                	mov    %edi,%edx
  801b00:	83 c4 1c             	add    $0x1c,%esp
  801b03:	5b                   	pop    %ebx
  801b04:	5e                   	pop    %esi
  801b05:	5f                   	pop    %edi
  801b06:	5d                   	pop    %ebp
  801b07:	c3                   	ret    
  801b08:	90                   	nop
  801b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801b10:	39 ce                	cmp    %ecx,%esi
  801b12:	77 74                	ja     801b88 <__udivdi3+0xd8>
  801b14:	0f bd fe             	bsr    %esi,%edi
  801b17:	83 f7 1f             	xor    $0x1f,%edi
  801b1a:	0f 84 98 00 00 00    	je     801bb8 <__udivdi3+0x108>
  801b20:	bb 20 00 00 00       	mov    $0x20,%ebx
  801b25:	89 f9                	mov    %edi,%ecx
  801b27:	89 c5                	mov    %eax,%ebp
  801b29:	29 fb                	sub    %edi,%ebx
  801b2b:	d3 e6                	shl    %cl,%esi
  801b2d:	89 d9                	mov    %ebx,%ecx
  801b2f:	d3 ed                	shr    %cl,%ebp
  801b31:	89 f9                	mov    %edi,%ecx
  801b33:	d3 e0                	shl    %cl,%eax
  801b35:	09 ee                	or     %ebp,%esi
  801b37:	89 d9                	mov    %ebx,%ecx
  801b39:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b3d:	89 d5                	mov    %edx,%ebp
  801b3f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b43:	d3 ed                	shr    %cl,%ebp
  801b45:	89 f9                	mov    %edi,%ecx
  801b47:	d3 e2                	shl    %cl,%edx
  801b49:	89 d9                	mov    %ebx,%ecx
  801b4b:	d3 e8                	shr    %cl,%eax
  801b4d:	09 c2                	or     %eax,%edx
  801b4f:	89 d0                	mov    %edx,%eax
  801b51:	89 ea                	mov    %ebp,%edx
  801b53:	f7 f6                	div    %esi
  801b55:	89 d5                	mov    %edx,%ebp
  801b57:	89 c3                	mov    %eax,%ebx
  801b59:	f7 64 24 0c          	mull   0xc(%esp)
  801b5d:	39 d5                	cmp    %edx,%ebp
  801b5f:	72 10                	jb     801b71 <__udivdi3+0xc1>
  801b61:	8b 74 24 08          	mov    0x8(%esp),%esi
  801b65:	89 f9                	mov    %edi,%ecx
  801b67:	d3 e6                	shl    %cl,%esi
  801b69:	39 c6                	cmp    %eax,%esi
  801b6b:	73 07                	jae    801b74 <__udivdi3+0xc4>
  801b6d:	39 d5                	cmp    %edx,%ebp
  801b6f:	75 03                	jne    801b74 <__udivdi3+0xc4>
  801b71:	83 eb 01             	sub    $0x1,%ebx
  801b74:	31 ff                	xor    %edi,%edi
  801b76:	89 d8                	mov    %ebx,%eax
  801b78:	89 fa                	mov    %edi,%edx
  801b7a:	83 c4 1c             	add    $0x1c,%esp
  801b7d:	5b                   	pop    %ebx
  801b7e:	5e                   	pop    %esi
  801b7f:	5f                   	pop    %edi
  801b80:	5d                   	pop    %ebp
  801b81:	c3                   	ret    
  801b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801b88:	31 ff                	xor    %edi,%edi
  801b8a:	31 db                	xor    %ebx,%ebx
  801b8c:	89 d8                	mov    %ebx,%eax
  801b8e:	89 fa                	mov    %edi,%edx
  801b90:	83 c4 1c             	add    $0x1c,%esp
  801b93:	5b                   	pop    %ebx
  801b94:	5e                   	pop    %esi
  801b95:	5f                   	pop    %edi
  801b96:	5d                   	pop    %ebp
  801b97:	c3                   	ret    
  801b98:	90                   	nop
  801b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ba0:	89 d8                	mov    %ebx,%eax
  801ba2:	f7 f7                	div    %edi
  801ba4:	31 ff                	xor    %edi,%edi
  801ba6:	89 c3                	mov    %eax,%ebx
  801ba8:	89 d8                	mov    %ebx,%eax
  801baa:	89 fa                	mov    %edi,%edx
  801bac:	83 c4 1c             	add    $0x1c,%esp
  801baf:	5b                   	pop    %ebx
  801bb0:	5e                   	pop    %esi
  801bb1:	5f                   	pop    %edi
  801bb2:	5d                   	pop    %ebp
  801bb3:	c3                   	ret    
  801bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801bb8:	39 ce                	cmp    %ecx,%esi
  801bba:	72 0c                	jb     801bc8 <__udivdi3+0x118>
  801bbc:	31 db                	xor    %ebx,%ebx
  801bbe:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bc2:	0f 87 34 ff ff ff    	ja     801afc <__udivdi3+0x4c>
  801bc8:	bb 01 00 00 00       	mov    $0x1,%ebx
  801bcd:	e9 2a ff ff ff       	jmp    801afc <__udivdi3+0x4c>
  801bd2:	66 90                	xchg   %ax,%ax
  801bd4:	66 90                	xchg   %ax,%ax
  801bd6:	66 90                	xchg   %ax,%ax
  801bd8:	66 90                	xchg   %ax,%ax
  801bda:	66 90                	xchg   %ax,%ax
  801bdc:	66 90                	xchg   %ax,%ax
  801bde:	66 90                	xchg   %ax,%ax

00801be0 <__umoddi3>:
  801be0:	55                   	push   %ebp
  801be1:	57                   	push   %edi
  801be2:	56                   	push   %esi
  801be3:	53                   	push   %ebx
  801be4:	83 ec 1c             	sub    $0x1c,%esp
  801be7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801beb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bef:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bf3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bf7:	85 d2                	test   %edx,%edx
  801bf9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801bfd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c01:	89 f3                	mov    %esi,%ebx
  801c03:	89 3c 24             	mov    %edi,(%esp)
  801c06:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c0a:	75 1c                	jne    801c28 <__umoddi3+0x48>
  801c0c:	39 f7                	cmp    %esi,%edi
  801c0e:	76 50                	jbe    801c60 <__umoddi3+0x80>
  801c10:	89 c8                	mov    %ecx,%eax
  801c12:	89 f2                	mov    %esi,%edx
  801c14:	f7 f7                	div    %edi
  801c16:	89 d0                	mov    %edx,%eax
  801c18:	31 d2                	xor    %edx,%edx
  801c1a:	83 c4 1c             	add    $0x1c,%esp
  801c1d:	5b                   	pop    %ebx
  801c1e:	5e                   	pop    %esi
  801c1f:	5f                   	pop    %edi
  801c20:	5d                   	pop    %ebp
  801c21:	c3                   	ret    
  801c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c28:	39 f2                	cmp    %esi,%edx
  801c2a:	89 d0                	mov    %edx,%eax
  801c2c:	77 52                	ja     801c80 <__umoddi3+0xa0>
  801c2e:	0f bd ea             	bsr    %edx,%ebp
  801c31:	83 f5 1f             	xor    $0x1f,%ebp
  801c34:	75 5a                	jne    801c90 <__umoddi3+0xb0>
  801c36:	3b 54 24 04          	cmp    0x4(%esp),%edx
  801c3a:	0f 82 e0 00 00 00    	jb     801d20 <__umoddi3+0x140>
  801c40:	39 0c 24             	cmp    %ecx,(%esp)
  801c43:	0f 86 d7 00 00 00    	jbe    801d20 <__umoddi3+0x140>
  801c49:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c4d:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c51:	83 c4 1c             	add    $0x1c,%esp
  801c54:	5b                   	pop    %ebx
  801c55:	5e                   	pop    %esi
  801c56:	5f                   	pop    %edi
  801c57:	5d                   	pop    %ebp
  801c58:	c3                   	ret    
  801c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c60:	85 ff                	test   %edi,%edi
  801c62:	89 fd                	mov    %edi,%ebp
  801c64:	75 0b                	jne    801c71 <__umoddi3+0x91>
  801c66:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6b:	31 d2                	xor    %edx,%edx
  801c6d:	f7 f7                	div    %edi
  801c6f:	89 c5                	mov    %eax,%ebp
  801c71:	89 f0                	mov    %esi,%eax
  801c73:	31 d2                	xor    %edx,%edx
  801c75:	f7 f5                	div    %ebp
  801c77:	89 c8                	mov    %ecx,%eax
  801c79:	f7 f5                	div    %ebp
  801c7b:	89 d0                	mov    %edx,%eax
  801c7d:	eb 99                	jmp    801c18 <__umoddi3+0x38>
  801c7f:	90                   	nop
  801c80:	89 c8                	mov    %ecx,%eax
  801c82:	89 f2                	mov    %esi,%edx
  801c84:	83 c4 1c             	add    $0x1c,%esp
  801c87:	5b                   	pop    %ebx
  801c88:	5e                   	pop    %esi
  801c89:	5f                   	pop    %edi
  801c8a:	5d                   	pop    %ebp
  801c8b:	c3                   	ret    
  801c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801c90:	8b 34 24             	mov    (%esp),%esi
  801c93:	bf 20 00 00 00       	mov    $0x20,%edi
  801c98:	89 e9                	mov    %ebp,%ecx
  801c9a:	29 ef                	sub    %ebp,%edi
  801c9c:	d3 e0                	shl    %cl,%eax
  801c9e:	89 f9                	mov    %edi,%ecx
  801ca0:	89 f2                	mov    %esi,%edx
  801ca2:	d3 ea                	shr    %cl,%edx
  801ca4:	89 e9                	mov    %ebp,%ecx
  801ca6:	09 c2                	or     %eax,%edx
  801ca8:	89 d8                	mov    %ebx,%eax
  801caa:	89 14 24             	mov    %edx,(%esp)
  801cad:	89 f2                	mov    %esi,%edx
  801caf:	d3 e2                	shl    %cl,%edx
  801cb1:	89 f9                	mov    %edi,%ecx
  801cb3:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cb7:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801cbb:	d3 e8                	shr    %cl,%eax
  801cbd:	89 e9                	mov    %ebp,%ecx
  801cbf:	89 c6                	mov    %eax,%esi
  801cc1:	d3 e3                	shl    %cl,%ebx
  801cc3:	89 f9                	mov    %edi,%ecx
  801cc5:	89 d0                	mov    %edx,%eax
  801cc7:	d3 e8                	shr    %cl,%eax
  801cc9:	89 e9                	mov    %ebp,%ecx
  801ccb:	09 d8                	or     %ebx,%eax
  801ccd:	89 d3                	mov    %edx,%ebx
  801ccf:	89 f2                	mov    %esi,%edx
  801cd1:	f7 34 24             	divl   (%esp)
  801cd4:	89 d6                	mov    %edx,%esi
  801cd6:	d3 e3                	shl    %cl,%ebx
  801cd8:	f7 64 24 04          	mull   0x4(%esp)
  801cdc:	39 d6                	cmp    %edx,%esi
  801cde:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ce2:	89 d1                	mov    %edx,%ecx
  801ce4:	89 c3                	mov    %eax,%ebx
  801ce6:	72 08                	jb     801cf0 <__umoddi3+0x110>
  801ce8:	75 11                	jne    801cfb <__umoddi3+0x11b>
  801cea:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801cee:	73 0b                	jae    801cfb <__umoddi3+0x11b>
  801cf0:	2b 44 24 04          	sub    0x4(%esp),%eax
  801cf4:	1b 14 24             	sbb    (%esp),%edx
  801cf7:	89 d1                	mov    %edx,%ecx
  801cf9:	89 c3                	mov    %eax,%ebx
  801cfb:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cff:	29 da                	sub    %ebx,%edx
  801d01:	19 ce                	sbb    %ecx,%esi
  801d03:	89 f9                	mov    %edi,%ecx
  801d05:	89 f0                	mov    %esi,%eax
  801d07:	d3 e0                	shl    %cl,%eax
  801d09:	89 e9                	mov    %ebp,%ecx
  801d0b:	d3 ea                	shr    %cl,%edx
  801d0d:	89 e9                	mov    %ebp,%ecx
  801d0f:	d3 ee                	shr    %cl,%esi
  801d11:	09 d0                	or     %edx,%eax
  801d13:	89 f2                	mov    %esi,%edx
  801d15:	83 c4 1c             	add    $0x1c,%esp
  801d18:	5b                   	pop    %ebx
  801d19:	5e                   	pop    %esi
  801d1a:	5f                   	pop    %edi
  801d1b:	5d                   	pop    %ebp
  801d1c:	c3                   	ret    
  801d1d:	8d 76 00             	lea    0x0(%esi),%esi
  801d20:	29 f9                	sub    %edi,%ecx
  801d22:	19 d6                	sbb    %edx,%esi
  801d24:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d28:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d2c:	e9 18 ff ff ff       	jmp    801c49 <__umoddi3+0x69>
