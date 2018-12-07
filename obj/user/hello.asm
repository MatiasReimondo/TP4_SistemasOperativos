
obj/user/hello.debug:     formato del fichero elf32-i386


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
  80002c:	e8 2a 00 00 00       	call   80005b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	cprintf("hello, world\n");
  800039:	68 40 1d 80 00       	push   $0x801d40
  80003e:	e8 0f 01 00 00       	call   800152 <cprintf>
	cprintf("i am environment %08x\n", sys_getenvid());
  800043:	e8 7a 0a 00 00       	call   800ac2 <sys_getenvid>
  800048:	83 c4 08             	add    $0x8,%esp
  80004b:	50                   	push   %eax
  80004c:	68 4e 1d 80 00       	push   $0x801d4e
  800051:	e8 fc 00 00 00       	call   800152 <cprintf>
}
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	c9                   	leave  
  80005a:	c3                   	ret    

0080005b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005b:	55                   	push   %ebp
  80005c:	89 e5                	mov    %esp,%ebp
  80005e:	56                   	push   %esi
  80005f:	53                   	push   %ebx
  800060:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800063:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800066:	e8 57 0a 00 00       	call   800ac2 <sys_getenvid>
	if (id >= 0)
  80006b:	85 c0                	test   %eax,%eax
  80006d:	78 12                	js     800081 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  80006f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800074:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800077:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80007c:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800081:	85 db                	test   %ebx,%ebx
  800083:	7e 07                	jle    80008c <libmain+0x31>
		binaryname = argv[0];
  800085:	8b 06                	mov    (%esi),%eax
  800087:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80008c:	83 ec 08             	sub    $0x8,%esp
  80008f:	56                   	push   %esi
  800090:	53                   	push   %ebx
  800091:	e8 9d ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800096:	e8 0a 00 00 00       	call   8000a5 <exit>
}
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a1:	5b                   	pop    %ebx
  8000a2:	5e                   	pop    %esi
  8000a3:	5d                   	pop    %ebp
  8000a4:	c3                   	ret    

008000a5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a5:	55                   	push   %ebp
  8000a6:	89 e5                	mov    %esp,%ebp
  8000a8:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000ab:	e8 45 0d 00 00       	call   800df5 <close_all>
	sys_env_destroy(0);
  8000b0:	83 ec 0c             	sub    $0xc,%esp
  8000b3:	6a 00                	push   $0x0
  8000b5:	e8 e6 09 00 00       	call   800aa0 <sys_env_destroy>
}
  8000ba:	83 c4 10             	add    $0x10,%esp
  8000bd:	c9                   	leave  
  8000be:	c3                   	ret    

008000bf <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000bf:	55                   	push   %ebp
  8000c0:	89 e5                	mov    %esp,%ebp
  8000c2:	53                   	push   %ebx
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000c9:	8b 13                	mov    (%ebx),%edx
  8000cb:	8d 42 01             	lea    0x1(%edx),%eax
  8000ce:	89 03                	mov    %eax,(%ebx)
  8000d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000d3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000d7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000dc:	75 1a                	jne    8000f8 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  8000de:	83 ec 08             	sub    $0x8,%esp
  8000e1:	68 ff 00 00 00       	push   $0xff
  8000e6:	8d 43 08             	lea    0x8(%ebx),%eax
  8000e9:	50                   	push   %eax
  8000ea:	e8 67 09 00 00       	call   800a56 <sys_cputs>
		b->idx = 0;
  8000ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000f5:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  8000f8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000ff:	c9                   	leave  
  800100:	c3                   	ret    

00800101 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800101:	55                   	push   %ebp
  800102:	89 e5                	mov    %esp,%ebp
  800104:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80010a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800111:	00 00 00 
	b.cnt = 0;
  800114:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80011b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80011e:	ff 75 0c             	pushl  0xc(%ebp)
  800121:	ff 75 08             	pushl  0x8(%ebp)
  800124:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80012a:	50                   	push   %eax
  80012b:	68 bf 00 80 00       	push   $0x8000bf
  800130:	e8 86 01 00 00       	call   8002bb <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800135:	83 c4 08             	add    $0x8,%esp
  800138:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80013e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800144:	50                   	push   %eax
  800145:	e8 0c 09 00 00       	call   800a56 <sys_cputs>

	return b.cnt;
}
  80014a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800150:	c9                   	leave  
  800151:	c3                   	ret    

00800152 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800152:	55                   	push   %ebp
  800153:	89 e5                	mov    %esp,%ebp
  800155:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800158:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80015b:	50                   	push   %eax
  80015c:	ff 75 08             	pushl  0x8(%ebp)
  80015f:	e8 9d ff ff ff       	call   800101 <vcprintf>
	va_end(ap);

	return cnt;
}
  800164:	c9                   	leave  
  800165:	c3                   	ret    

00800166 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800166:	55                   	push   %ebp
  800167:	89 e5                	mov    %esp,%ebp
  800169:	57                   	push   %edi
  80016a:	56                   	push   %esi
  80016b:	53                   	push   %ebx
  80016c:	83 ec 1c             	sub    $0x1c,%esp
  80016f:	89 c7                	mov    %eax,%edi
  800171:	89 d6                	mov    %edx,%esi
  800173:	8b 45 08             	mov    0x8(%ebp),%eax
  800176:	8b 55 0c             	mov    0xc(%ebp),%edx
  800179:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80017c:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80017f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800182:	bb 00 00 00 00       	mov    $0x0,%ebx
  800187:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80018a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80018d:	39 d3                	cmp    %edx,%ebx
  80018f:	72 05                	jb     800196 <printnum+0x30>
  800191:	39 45 10             	cmp    %eax,0x10(%ebp)
  800194:	77 45                	ja     8001db <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800196:	83 ec 0c             	sub    $0xc,%esp
  800199:	ff 75 18             	pushl  0x18(%ebp)
  80019c:	8b 45 14             	mov    0x14(%ebp),%eax
  80019f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001a2:	53                   	push   %ebx
  8001a3:	ff 75 10             	pushl  0x10(%ebp)
  8001a6:	83 ec 08             	sub    $0x8,%esp
  8001a9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ac:	ff 75 e0             	pushl  -0x20(%ebp)
  8001af:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b2:	ff 75 d8             	pushl  -0x28(%ebp)
  8001b5:	e8 f6 18 00 00       	call   801ab0 <__udivdi3>
  8001ba:	83 c4 18             	add    $0x18,%esp
  8001bd:	52                   	push   %edx
  8001be:	50                   	push   %eax
  8001bf:	89 f2                	mov    %esi,%edx
  8001c1:	89 f8                	mov    %edi,%eax
  8001c3:	e8 9e ff ff ff       	call   800166 <printnum>
  8001c8:	83 c4 20             	add    $0x20,%esp
  8001cb:	eb 18                	jmp    8001e5 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001cd:	83 ec 08             	sub    $0x8,%esp
  8001d0:	56                   	push   %esi
  8001d1:	ff 75 18             	pushl  0x18(%ebp)
  8001d4:	ff d7                	call   *%edi
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	eb 03                	jmp    8001de <printnum+0x78>
  8001db:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001de:	83 eb 01             	sub    $0x1,%ebx
  8001e1:	85 db                	test   %ebx,%ebx
  8001e3:	7f e8                	jg     8001cd <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001e5:	83 ec 08             	sub    $0x8,%esp
  8001e8:	56                   	push   %esi
  8001e9:	83 ec 04             	sub    $0x4,%esp
  8001ec:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ef:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f2:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f5:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f8:	e8 e3 19 00 00       	call   801be0 <__umoddi3>
  8001fd:	83 c4 14             	add    $0x14,%esp
  800200:	0f be 80 6f 1d 80 00 	movsbl 0x801d6f(%eax),%eax
  800207:	50                   	push   %eax
  800208:	ff d7                	call   *%edi
}
  80020a:	83 c4 10             	add    $0x10,%esp
  80020d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800210:	5b                   	pop    %ebx
  800211:	5e                   	pop    %esi
  800212:	5f                   	pop    %edi
  800213:	5d                   	pop    %ebp
  800214:	c3                   	ret    

00800215 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800215:	55                   	push   %ebp
  800216:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800218:	83 fa 01             	cmp    $0x1,%edx
  80021b:	7e 0e                	jle    80022b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80021d:	8b 10                	mov    (%eax),%edx
  80021f:	8d 4a 08             	lea    0x8(%edx),%ecx
  800222:	89 08                	mov    %ecx,(%eax)
  800224:	8b 02                	mov    (%edx),%eax
  800226:	8b 52 04             	mov    0x4(%edx),%edx
  800229:	eb 22                	jmp    80024d <getuint+0x38>
	else if (lflag)
  80022b:	85 d2                	test   %edx,%edx
  80022d:	74 10                	je     80023f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80022f:	8b 10                	mov    (%eax),%edx
  800231:	8d 4a 04             	lea    0x4(%edx),%ecx
  800234:	89 08                	mov    %ecx,(%eax)
  800236:	8b 02                	mov    (%edx),%eax
  800238:	ba 00 00 00 00       	mov    $0x0,%edx
  80023d:	eb 0e                	jmp    80024d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80023f:	8b 10                	mov    (%eax),%edx
  800241:	8d 4a 04             	lea    0x4(%edx),%ecx
  800244:	89 08                	mov    %ecx,(%eax)
  800246:	8b 02                	mov    (%edx),%eax
  800248:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80024d:	5d                   	pop    %ebp
  80024e:	c3                   	ret    

0080024f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80024f:	55                   	push   %ebp
  800250:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800252:	83 fa 01             	cmp    $0x1,%edx
  800255:	7e 0e                	jle    800265 <getint+0x16>
		return va_arg(*ap, long long);
  800257:	8b 10                	mov    (%eax),%edx
  800259:	8d 4a 08             	lea    0x8(%edx),%ecx
  80025c:	89 08                	mov    %ecx,(%eax)
  80025e:	8b 02                	mov    (%edx),%eax
  800260:	8b 52 04             	mov    0x4(%edx),%edx
  800263:	eb 1a                	jmp    80027f <getint+0x30>
	else if (lflag)
  800265:	85 d2                	test   %edx,%edx
  800267:	74 0c                	je     800275 <getint+0x26>
		return va_arg(*ap, long);
  800269:	8b 10                	mov    (%eax),%edx
  80026b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80026e:	89 08                	mov    %ecx,(%eax)
  800270:	8b 02                	mov    (%edx),%eax
  800272:	99                   	cltd   
  800273:	eb 0a                	jmp    80027f <getint+0x30>
	else
		return va_arg(*ap, int);
  800275:	8b 10                	mov    (%eax),%edx
  800277:	8d 4a 04             	lea    0x4(%edx),%ecx
  80027a:	89 08                	mov    %ecx,(%eax)
  80027c:	8b 02                	mov    (%edx),%eax
  80027e:	99                   	cltd   
}
  80027f:	5d                   	pop    %ebp
  800280:	c3                   	ret    

00800281 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800281:	55                   	push   %ebp
  800282:	89 e5                	mov    %esp,%ebp
  800284:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800287:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80028b:	8b 10                	mov    (%eax),%edx
  80028d:	3b 50 04             	cmp    0x4(%eax),%edx
  800290:	73 0a                	jae    80029c <sprintputch+0x1b>
		*b->buf++ = ch;
  800292:	8d 4a 01             	lea    0x1(%edx),%ecx
  800295:	89 08                	mov    %ecx,(%eax)
  800297:	8b 45 08             	mov    0x8(%ebp),%eax
  80029a:	88 02                	mov    %al,(%edx)
}
  80029c:	5d                   	pop    %ebp
  80029d:	c3                   	ret    

0080029e <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80029e:	55                   	push   %ebp
  80029f:	89 e5                	mov    %esp,%ebp
  8002a1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8002a4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002a7:	50                   	push   %eax
  8002a8:	ff 75 10             	pushl  0x10(%ebp)
  8002ab:	ff 75 0c             	pushl  0xc(%ebp)
  8002ae:	ff 75 08             	pushl  0x8(%ebp)
  8002b1:	e8 05 00 00 00       	call   8002bb <vprintfmt>
	va_end(ap);
}
  8002b6:	83 c4 10             	add    $0x10,%esp
  8002b9:	c9                   	leave  
  8002ba:	c3                   	ret    

008002bb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
  8002be:	57                   	push   %edi
  8002bf:	56                   	push   %esi
  8002c0:	53                   	push   %ebx
  8002c1:	83 ec 2c             	sub    $0x2c,%esp
  8002c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8002c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002ca:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002cd:	eb 12                	jmp    8002e1 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8002cf:	85 c0                	test   %eax,%eax
  8002d1:	0f 84 44 03 00 00    	je     80061b <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  8002d7:	83 ec 08             	sub    $0x8,%esp
  8002da:	53                   	push   %ebx
  8002db:	50                   	push   %eax
  8002dc:	ff d6                	call   *%esi
  8002de:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002e1:	83 c7 01             	add    $0x1,%edi
  8002e4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8002e8:	83 f8 25             	cmp    $0x25,%eax
  8002eb:	75 e2                	jne    8002cf <vprintfmt+0x14>
  8002ed:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8002f1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8002f8:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8002ff:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800306:	ba 00 00 00 00       	mov    $0x0,%edx
  80030b:	eb 07                	jmp    800314 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80030d:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800310:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800314:	8d 47 01             	lea    0x1(%edi),%eax
  800317:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80031a:	0f b6 07             	movzbl (%edi),%eax
  80031d:	0f b6 c8             	movzbl %al,%ecx
  800320:	83 e8 23             	sub    $0x23,%eax
  800323:	3c 55                	cmp    $0x55,%al
  800325:	0f 87 d5 02 00 00    	ja     800600 <vprintfmt+0x345>
  80032b:	0f b6 c0             	movzbl %al,%eax
  80032e:	ff 24 85 c0 1e 80 00 	jmp    *0x801ec0(,%eax,4)
  800335:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800338:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80033c:	eb d6                	jmp    800314 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80033e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800341:	b8 00 00 00 00       	mov    $0x0,%eax
  800346:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800349:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80034c:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  800350:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  800353:	8d 51 d0             	lea    -0x30(%ecx),%edx
  800356:	83 fa 09             	cmp    $0x9,%edx
  800359:	77 39                	ja     800394 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80035b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80035e:	eb e9                	jmp    800349 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800360:	8b 45 14             	mov    0x14(%ebp),%eax
  800363:	8d 48 04             	lea    0x4(%eax),%ecx
  800366:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800369:	8b 00                	mov    (%eax),%eax
  80036b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80036e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800371:	eb 27                	jmp    80039a <vprintfmt+0xdf>
  800373:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800376:	85 c0                	test   %eax,%eax
  800378:	b9 00 00 00 00       	mov    $0x0,%ecx
  80037d:	0f 49 c8             	cmovns %eax,%ecx
  800380:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800383:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800386:	eb 8c                	jmp    800314 <vprintfmt+0x59>
  800388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80038b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800392:	eb 80                	jmp    800314 <vprintfmt+0x59>
  800394:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800397:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  80039a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80039e:	0f 89 70 ff ff ff    	jns    800314 <vprintfmt+0x59>
				width = precision, precision = -1;
  8003a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003aa:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003b1:	e9 5e ff ff ff       	jmp    800314 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003b6:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8003bc:	e9 53 ff ff ff       	jmp    800314 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c4:	8d 50 04             	lea    0x4(%eax),%edx
  8003c7:	89 55 14             	mov    %edx,0x14(%ebp)
  8003ca:	83 ec 08             	sub    $0x8,%esp
  8003cd:	53                   	push   %ebx
  8003ce:	ff 30                	pushl  (%eax)
  8003d0:	ff d6                	call   *%esi
			break;
  8003d2:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  8003d8:	e9 04 ff ff ff       	jmp    8002e1 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8003dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e0:	8d 50 04             	lea    0x4(%eax),%edx
  8003e3:	89 55 14             	mov    %edx,0x14(%ebp)
  8003e6:	8b 00                	mov    (%eax),%eax
  8003e8:	99                   	cltd   
  8003e9:	31 d0                	xor    %edx,%eax
  8003eb:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003ed:	83 f8 0f             	cmp    $0xf,%eax
  8003f0:	7f 0b                	jg     8003fd <vprintfmt+0x142>
  8003f2:	8b 14 85 20 20 80 00 	mov    0x802020(,%eax,4),%edx
  8003f9:	85 d2                	test   %edx,%edx
  8003fb:	75 18                	jne    800415 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  8003fd:	50                   	push   %eax
  8003fe:	68 87 1d 80 00       	push   $0x801d87
  800403:	53                   	push   %ebx
  800404:	56                   	push   %esi
  800405:	e8 94 fe ff ff       	call   80029e <printfmt>
  80040a:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80040d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800410:	e9 cc fe ff ff       	jmp    8002e1 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  800415:	52                   	push   %edx
  800416:	68 51 21 80 00       	push   $0x802151
  80041b:	53                   	push   %ebx
  80041c:	56                   	push   %esi
  80041d:	e8 7c fe ff ff       	call   80029e <printfmt>
  800422:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800425:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800428:	e9 b4 fe ff ff       	jmp    8002e1 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80042d:	8b 45 14             	mov    0x14(%ebp),%eax
  800430:	8d 50 04             	lea    0x4(%eax),%edx
  800433:	89 55 14             	mov    %edx,0x14(%ebp)
  800436:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800438:	85 ff                	test   %edi,%edi
  80043a:	b8 80 1d 80 00       	mov    $0x801d80,%eax
  80043f:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800442:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800446:	0f 8e 94 00 00 00    	jle    8004e0 <vprintfmt+0x225>
  80044c:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800450:	0f 84 98 00 00 00    	je     8004ee <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  800456:	83 ec 08             	sub    $0x8,%esp
  800459:	ff 75 d0             	pushl  -0x30(%ebp)
  80045c:	57                   	push   %edi
  80045d:	e8 41 02 00 00       	call   8006a3 <strnlen>
  800462:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800465:	29 c1                	sub    %eax,%ecx
  800467:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80046a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80046d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800471:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800474:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800477:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800479:	eb 0f                	jmp    80048a <vprintfmt+0x1cf>
					putch(padc, putdat);
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	53                   	push   %ebx
  80047f:	ff 75 e0             	pushl  -0x20(%ebp)
  800482:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800484:	83 ef 01             	sub    $0x1,%edi
  800487:	83 c4 10             	add    $0x10,%esp
  80048a:	85 ff                	test   %edi,%edi
  80048c:	7f ed                	jg     80047b <vprintfmt+0x1c0>
  80048e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800491:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800494:	85 c9                	test   %ecx,%ecx
  800496:	b8 00 00 00 00       	mov    $0x0,%eax
  80049b:	0f 49 c1             	cmovns %ecx,%eax
  80049e:	29 c1                	sub    %eax,%ecx
  8004a0:	89 75 08             	mov    %esi,0x8(%ebp)
  8004a3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004a6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004a9:	89 cb                	mov    %ecx,%ebx
  8004ab:	eb 4d                	jmp    8004fa <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004ad:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004b1:	74 1b                	je     8004ce <vprintfmt+0x213>
  8004b3:	0f be c0             	movsbl %al,%eax
  8004b6:	83 e8 20             	sub    $0x20,%eax
  8004b9:	83 f8 5e             	cmp    $0x5e,%eax
  8004bc:	76 10                	jbe    8004ce <vprintfmt+0x213>
					putch('?', putdat);
  8004be:	83 ec 08             	sub    $0x8,%esp
  8004c1:	ff 75 0c             	pushl  0xc(%ebp)
  8004c4:	6a 3f                	push   $0x3f
  8004c6:	ff 55 08             	call   *0x8(%ebp)
  8004c9:	83 c4 10             	add    $0x10,%esp
  8004cc:	eb 0d                	jmp    8004db <vprintfmt+0x220>
				else
					putch(ch, putdat);
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	ff 75 0c             	pushl  0xc(%ebp)
  8004d4:	52                   	push   %edx
  8004d5:	ff 55 08             	call   *0x8(%ebp)
  8004d8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004db:	83 eb 01             	sub    $0x1,%ebx
  8004de:	eb 1a                	jmp    8004fa <vprintfmt+0x23f>
  8004e0:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004e6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004e9:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004ec:	eb 0c                	jmp    8004fa <vprintfmt+0x23f>
  8004ee:	89 75 08             	mov    %esi,0x8(%ebp)
  8004f1:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004f4:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004f7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004fa:	83 c7 01             	add    $0x1,%edi
  8004fd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800501:	0f be d0             	movsbl %al,%edx
  800504:	85 d2                	test   %edx,%edx
  800506:	74 23                	je     80052b <vprintfmt+0x270>
  800508:	85 f6                	test   %esi,%esi
  80050a:	78 a1                	js     8004ad <vprintfmt+0x1f2>
  80050c:	83 ee 01             	sub    $0x1,%esi
  80050f:	79 9c                	jns    8004ad <vprintfmt+0x1f2>
  800511:	89 df                	mov    %ebx,%edi
  800513:	8b 75 08             	mov    0x8(%ebp),%esi
  800516:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800519:	eb 18                	jmp    800533 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	53                   	push   %ebx
  80051f:	6a 20                	push   $0x20
  800521:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800523:	83 ef 01             	sub    $0x1,%edi
  800526:	83 c4 10             	add    $0x10,%esp
  800529:	eb 08                	jmp    800533 <vprintfmt+0x278>
  80052b:	89 df                	mov    %ebx,%edi
  80052d:	8b 75 08             	mov    0x8(%ebp),%esi
  800530:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800533:	85 ff                	test   %edi,%edi
  800535:	7f e4                	jg     80051b <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800537:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80053a:	e9 a2 fd ff ff       	jmp    8002e1 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80053f:	8d 45 14             	lea    0x14(%ebp),%eax
  800542:	e8 08 fd ff ff       	call   80024f <getint>
  800547:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80054a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80054d:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800552:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800556:	79 74                	jns    8005cc <vprintfmt+0x311>
				putch('-', putdat);
  800558:	83 ec 08             	sub    $0x8,%esp
  80055b:	53                   	push   %ebx
  80055c:	6a 2d                	push   $0x2d
  80055e:	ff d6                	call   *%esi
				num = -(long long) num;
  800560:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800563:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800566:	f7 d8                	neg    %eax
  800568:	83 d2 00             	adc    $0x0,%edx
  80056b:	f7 da                	neg    %edx
  80056d:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  800570:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800575:	eb 55                	jmp    8005cc <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800577:	8d 45 14             	lea    0x14(%ebp),%eax
  80057a:	e8 96 fc ff ff       	call   800215 <getuint>
			base = 10;
  80057f:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800584:	eb 46                	jmp    8005cc <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800586:	8d 45 14             	lea    0x14(%ebp),%eax
  800589:	e8 87 fc ff ff       	call   800215 <getuint>
			base = 8;
  80058e:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800593:	eb 37                	jmp    8005cc <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  800595:	83 ec 08             	sub    $0x8,%esp
  800598:	53                   	push   %ebx
  800599:	6a 30                	push   $0x30
  80059b:	ff d6                	call   *%esi
			putch('x', putdat);
  80059d:	83 c4 08             	add    $0x8,%esp
  8005a0:	53                   	push   %ebx
  8005a1:	6a 78                	push   $0x78
  8005a3:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	8d 50 04             	lea    0x4(%eax),%edx
  8005ab:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8005b5:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8005b8:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8005bd:	eb 0d                	jmp    8005cc <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8005bf:	8d 45 14             	lea    0x14(%ebp),%eax
  8005c2:	e8 4e fc ff ff       	call   800215 <getuint>
			base = 16;
  8005c7:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8005cc:	83 ec 0c             	sub    $0xc,%esp
  8005cf:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8005d3:	57                   	push   %edi
  8005d4:	ff 75 e0             	pushl  -0x20(%ebp)
  8005d7:	51                   	push   %ecx
  8005d8:	52                   	push   %edx
  8005d9:	50                   	push   %eax
  8005da:	89 da                	mov    %ebx,%edx
  8005dc:	89 f0                	mov    %esi,%eax
  8005de:	e8 83 fb ff ff       	call   800166 <printnum>
			break;
  8005e3:	83 c4 20             	add    $0x20,%esp
  8005e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005e9:	e9 f3 fc ff ff       	jmp    8002e1 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8005ee:	83 ec 08             	sub    $0x8,%esp
  8005f1:	53                   	push   %ebx
  8005f2:	51                   	push   %ecx
  8005f3:	ff d6                	call   *%esi
			break;
  8005f5:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8005fb:	e9 e1 fc ff ff       	jmp    8002e1 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800600:	83 ec 08             	sub    $0x8,%esp
  800603:	53                   	push   %ebx
  800604:	6a 25                	push   $0x25
  800606:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800608:	83 c4 10             	add    $0x10,%esp
  80060b:	eb 03                	jmp    800610 <vprintfmt+0x355>
  80060d:	83 ef 01             	sub    $0x1,%edi
  800610:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  800614:	75 f7                	jne    80060d <vprintfmt+0x352>
  800616:	e9 c6 fc ff ff       	jmp    8002e1 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  80061b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80061e:	5b                   	pop    %ebx
  80061f:	5e                   	pop    %esi
  800620:	5f                   	pop    %edi
  800621:	5d                   	pop    %ebp
  800622:	c3                   	ret    

00800623 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800623:	55                   	push   %ebp
  800624:	89 e5                	mov    %esp,%ebp
  800626:	83 ec 18             	sub    $0x18,%esp
  800629:	8b 45 08             	mov    0x8(%ebp),%eax
  80062c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80062f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800632:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800636:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800639:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800640:	85 c0                	test   %eax,%eax
  800642:	74 26                	je     80066a <vsnprintf+0x47>
  800644:	85 d2                	test   %edx,%edx
  800646:	7e 22                	jle    80066a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800648:	ff 75 14             	pushl  0x14(%ebp)
  80064b:	ff 75 10             	pushl  0x10(%ebp)
  80064e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800651:	50                   	push   %eax
  800652:	68 81 02 80 00       	push   $0x800281
  800657:	e8 5f fc ff ff       	call   8002bb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80065c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80065f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	eb 05                	jmp    80066f <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80066a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80066f:	c9                   	leave  
  800670:	c3                   	ret    

00800671 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800671:	55                   	push   %ebp
  800672:	89 e5                	mov    %esp,%ebp
  800674:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800677:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80067a:	50                   	push   %eax
  80067b:	ff 75 10             	pushl  0x10(%ebp)
  80067e:	ff 75 0c             	pushl  0xc(%ebp)
  800681:	ff 75 08             	pushl  0x8(%ebp)
  800684:	e8 9a ff ff ff       	call   800623 <vsnprintf>
	va_end(ap);

	return rc;
}
  800689:	c9                   	leave  
  80068a:	c3                   	ret    

0080068b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80068b:	55                   	push   %ebp
  80068c:	89 e5                	mov    %esp,%ebp
  80068e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800691:	b8 00 00 00 00       	mov    $0x0,%eax
  800696:	eb 03                	jmp    80069b <strlen+0x10>
		n++;
  800698:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80069b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80069f:	75 f7                	jne    800698 <strlen+0xd>
		n++;
	return n;
}
  8006a1:	5d                   	pop    %ebp
  8006a2:	c3                   	ret    

008006a3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8006a3:	55                   	push   %ebp
  8006a4:	89 e5                	mov    %esp,%ebp
  8006a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006a9:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8006ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b1:	eb 03                	jmp    8006b6 <strnlen+0x13>
		n++;
  8006b3:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8006b6:	39 c2                	cmp    %eax,%edx
  8006b8:	74 08                	je     8006c2 <strnlen+0x1f>
  8006ba:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8006be:	75 f3                	jne    8006b3 <strnlen+0x10>
  8006c0:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  8006c2:	5d                   	pop    %ebp
  8006c3:	c3                   	ret    

008006c4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8006c4:	55                   	push   %ebp
  8006c5:	89 e5                	mov    %esp,%ebp
  8006c7:	53                   	push   %ebx
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8006ce:	89 c2                	mov    %eax,%edx
  8006d0:	83 c2 01             	add    $0x1,%edx
  8006d3:	83 c1 01             	add    $0x1,%ecx
  8006d6:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8006da:	88 5a ff             	mov    %bl,-0x1(%edx)
  8006dd:	84 db                	test   %bl,%bl
  8006df:	75 ef                	jne    8006d0 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8006e1:	5b                   	pop    %ebx
  8006e2:	5d                   	pop    %ebp
  8006e3:	c3                   	ret    

008006e4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8006e4:	55                   	push   %ebp
  8006e5:	89 e5                	mov    %esp,%ebp
  8006e7:	53                   	push   %ebx
  8006e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8006eb:	53                   	push   %ebx
  8006ec:	e8 9a ff ff ff       	call   80068b <strlen>
  8006f1:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8006f4:	ff 75 0c             	pushl  0xc(%ebp)
  8006f7:	01 d8                	add    %ebx,%eax
  8006f9:	50                   	push   %eax
  8006fa:	e8 c5 ff ff ff       	call   8006c4 <strcpy>
	return dst;
}
  8006ff:	89 d8                	mov    %ebx,%eax
  800701:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800704:	c9                   	leave  
  800705:	c3                   	ret    

00800706 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800706:	55                   	push   %ebp
  800707:	89 e5                	mov    %esp,%ebp
  800709:	56                   	push   %esi
  80070a:	53                   	push   %ebx
  80070b:	8b 75 08             	mov    0x8(%ebp),%esi
  80070e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800711:	89 f3                	mov    %esi,%ebx
  800713:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800716:	89 f2                	mov    %esi,%edx
  800718:	eb 0f                	jmp    800729 <strncpy+0x23>
		*dst++ = *src;
  80071a:	83 c2 01             	add    $0x1,%edx
  80071d:	0f b6 01             	movzbl (%ecx),%eax
  800720:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800723:	80 39 01             	cmpb   $0x1,(%ecx)
  800726:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800729:	39 da                	cmp    %ebx,%edx
  80072b:	75 ed                	jne    80071a <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80072d:	89 f0                	mov    %esi,%eax
  80072f:	5b                   	pop    %ebx
  800730:	5e                   	pop    %esi
  800731:	5d                   	pop    %ebp
  800732:	c3                   	ret    

00800733 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800733:	55                   	push   %ebp
  800734:	89 e5                	mov    %esp,%ebp
  800736:	56                   	push   %esi
  800737:	53                   	push   %ebx
  800738:	8b 75 08             	mov    0x8(%ebp),%esi
  80073b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80073e:	8b 55 10             	mov    0x10(%ebp),%edx
  800741:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800743:	85 d2                	test   %edx,%edx
  800745:	74 21                	je     800768 <strlcpy+0x35>
  800747:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80074b:	89 f2                	mov    %esi,%edx
  80074d:	eb 09                	jmp    800758 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80074f:	83 c2 01             	add    $0x1,%edx
  800752:	83 c1 01             	add    $0x1,%ecx
  800755:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800758:	39 c2                	cmp    %eax,%edx
  80075a:	74 09                	je     800765 <strlcpy+0x32>
  80075c:	0f b6 19             	movzbl (%ecx),%ebx
  80075f:	84 db                	test   %bl,%bl
  800761:	75 ec                	jne    80074f <strlcpy+0x1c>
  800763:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  800765:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800768:	29 f0                	sub    %esi,%eax
}
  80076a:	5b                   	pop    %ebx
  80076b:	5e                   	pop    %esi
  80076c:	5d                   	pop    %ebp
  80076d:	c3                   	ret    

0080076e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80076e:	55                   	push   %ebp
  80076f:	89 e5                	mov    %esp,%ebp
  800771:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800774:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800777:	eb 06                	jmp    80077f <strcmp+0x11>
		p++, q++;
  800779:	83 c1 01             	add    $0x1,%ecx
  80077c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80077f:	0f b6 01             	movzbl (%ecx),%eax
  800782:	84 c0                	test   %al,%al
  800784:	74 04                	je     80078a <strcmp+0x1c>
  800786:	3a 02                	cmp    (%edx),%al
  800788:	74 ef                	je     800779 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80078a:	0f b6 c0             	movzbl %al,%eax
  80078d:	0f b6 12             	movzbl (%edx),%edx
  800790:	29 d0                	sub    %edx,%eax
}
  800792:	5d                   	pop    %ebp
  800793:	c3                   	ret    

00800794 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
  800797:	53                   	push   %ebx
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80079e:	89 c3                	mov    %eax,%ebx
  8007a0:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8007a3:	eb 06                	jmp    8007ab <strncmp+0x17>
		n--, p++, q++;
  8007a5:	83 c0 01             	add    $0x1,%eax
  8007a8:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8007ab:	39 d8                	cmp    %ebx,%eax
  8007ad:	74 15                	je     8007c4 <strncmp+0x30>
  8007af:	0f b6 08             	movzbl (%eax),%ecx
  8007b2:	84 c9                	test   %cl,%cl
  8007b4:	74 04                	je     8007ba <strncmp+0x26>
  8007b6:	3a 0a                	cmp    (%edx),%cl
  8007b8:	74 eb                	je     8007a5 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8007ba:	0f b6 00             	movzbl (%eax),%eax
  8007bd:	0f b6 12             	movzbl (%edx),%edx
  8007c0:	29 d0                	sub    %edx,%eax
  8007c2:	eb 05                	jmp    8007c9 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8007c4:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8007c9:	5b                   	pop    %ebx
  8007ca:	5d                   	pop    %ebp
  8007cb:	c3                   	ret    

008007cc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8007d6:	eb 07                	jmp    8007df <strchr+0x13>
		if (*s == c)
  8007d8:	38 ca                	cmp    %cl,%dl
  8007da:	74 0f                	je     8007eb <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8007dc:	83 c0 01             	add    $0x1,%eax
  8007df:	0f b6 10             	movzbl (%eax),%edx
  8007e2:	84 d2                	test   %dl,%dl
  8007e4:	75 f2                	jne    8007d8 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8007e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007eb:	5d                   	pop    %ebp
  8007ec:	c3                   	ret    

008007ed <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8007ed:	55                   	push   %ebp
  8007ee:	89 e5                	mov    %esp,%ebp
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8007f7:	eb 03                	jmp    8007fc <strfind+0xf>
  8007f9:	83 c0 01             	add    $0x1,%eax
  8007fc:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8007ff:	38 ca                	cmp    %cl,%dl
  800801:	74 04                	je     800807 <strfind+0x1a>
  800803:	84 d2                	test   %dl,%dl
  800805:	75 f2                	jne    8007f9 <strfind+0xc>
			break;
	return (char *) s;
}
  800807:	5d                   	pop    %ebp
  800808:	c3                   	ret    

00800809 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800809:	55                   	push   %ebp
  80080a:	89 e5                	mov    %esp,%ebp
  80080c:	57                   	push   %edi
  80080d:	56                   	push   %esi
  80080e:	53                   	push   %ebx
  80080f:	8b 55 08             	mov    0x8(%ebp),%edx
  800812:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800815:	85 c9                	test   %ecx,%ecx
  800817:	74 37                	je     800850 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800819:	f6 c2 03             	test   $0x3,%dl
  80081c:	75 2a                	jne    800848 <memset+0x3f>
  80081e:	f6 c1 03             	test   $0x3,%cl
  800821:	75 25                	jne    800848 <memset+0x3f>
		c &= 0xFF;
  800823:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800827:	89 df                	mov    %ebx,%edi
  800829:	c1 e7 08             	shl    $0x8,%edi
  80082c:	89 de                	mov    %ebx,%esi
  80082e:	c1 e6 18             	shl    $0x18,%esi
  800831:	89 d8                	mov    %ebx,%eax
  800833:	c1 e0 10             	shl    $0x10,%eax
  800836:	09 f0                	or     %esi,%eax
  800838:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  80083a:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80083d:	89 f8                	mov    %edi,%eax
  80083f:	09 d8                	or     %ebx,%eax
  800841:	89 d7                	mov    %edx,%edi
  800843:	fc                   	cld    
  800844:	f3 ab                	rep stos %eax,%es:(%edi)
  800846:	eb 08                	jmp    800850 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800848:	89 d7                	mov    %edx,%edi
  80084a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084d:	fc                   	cld    
  80084e:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800850:	89 d0                	mov    %edx,%eax
  800852:	5b                   	pop    %ebx
  800853:	5e                   	pop    %esi
  800854:	5f                   	pop    %edi
  800855:	5d                   	pop    %ebp
  800856:	c3                   	ret    

00800857 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800857:	55                   	push   %ebp
  800858:	89 e5                	mov    %esp,%ebp
  80085a:	57                   	push   %edi
  80085b:	56                   	push   %esi
  80085c:	8b 45 08             	mov    0x8(%ebp),%eax
  80085f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800862:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800865:	39 c6                	cmp    %eax,%esi
  800867:	73 35                	jae    80089e <memmove+0x47>
  800869:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80086c:	39 d0                	cmp    %edx,%eax
  80086e:	73 2e                	jae    80089e <memmove+0x47>
		s += n;
		d += n;
  800870:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800873:	89 d6                	mov    %edx,%esi
  800875:	09 fe                	or     %edi,%esi
  800877:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80087d:	75 13                	jne    800892 <memmove+0x3b>
  80087f:	f6 c1 03             	test   $0x3,%cl
  800882:	75 0e                	jne    800892 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  800884:	83 ef 04             	sub    $0x4,%edi
  800887:	8d 72 fc             	lea    -0x4(%edx),%esi
  80088a:	c1 e9 02             	shr    $0x2,%ecx
  80088d:	fd                   	std    
  80088e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800890:	eb 09                	jmp    80089b <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800892:	83 ef 01             	sub    $0x1,%edi
  800895:	8d 72 ff             	lea    -0x1(%edx),%esi
  800898:	fd                   	std    
  800899:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80089b:	fc                   	cld    
  80089c:	eb 1d                	jmp    8008bb <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80089e:	89 f2                	mov    %esi,%edx
  8008a0:	09 c2                	or     %eax,%edx
  8008a2:	f6 c2 03             	test   $0x3,%dl
  8008a5:	75 0f                	jne    8008b6 <memmove+0x5f>
  8008a7:	f6 c1 03             	test   $0x3,%cl
  8008aa:	75 0a                	jne    8008b6 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  8008ac:	c1 e9 02             	shr    $0x2,%ecx
  8008af:	89 c7                	mov    %eax,%edi
  8008b1:	fc                   	cld    
  8008b2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008b4:	eb 05                	jmp    8008bb <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8008b6:	89 c7                	mov    %eax,%edi
  8008b8:	fc                   	cld    
  8008b9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8008bb:	5e                   	pop    %esi
  8008bc:	5f                   	pop    %edi
  8008bd:	5d                   	pop    %ebp
  8008be:	c3                   	ret    

008008bf <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8008bf:	55                   	push   %ebp
  8008c0:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8008c2:	ff 75 10             	pushl  0x10(%ebp)
  8008c5:	ff 75 0c             	pushl  0xc(%ebp)
  8008c8:	ff 75 08             	pushl  0x8(%ebp)
  8008cb:	e8 87 ff ff ff       	call   800857 <memmove>
}
  8008d0:	c9                   	leave  
  8008d1:	c3                   	ret    

008008d2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	56                   	push   %esi
  8008d6:	53                   	push   %ebx
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008dd:	89 c6                	mov    %eax,%esi
  8008df:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8008e2:	eb 1a                	jmp    8008fe <memcmp+0x2c>
		if (*s1 != *s2)
  8008e4:	0f b6 08             	movzbl (%eax),%ecx
  8008e7:	0f b6 1a             	movzbl (%edx),%ebx
  8008ea:	38 d9                	cmp    %bl,%cl
  8008ec:	74 0a                	je     8008f8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8008ee:	0f b6 c1             	movzbl %cl,%eax
  8008f1:	0f b6 db             	movzbl %bl,%ebx
  8008f4:	29 d8                	sub    %ebx,%eax
  8008f6:	eb 0f                	jmp    800907 <memcmp+0x35>
		s1++, s2++;
  8008f8:	83 c0 01             	add    $0x1,%eax
  8008fb:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8008fe:	39 f0                	cmp    %esi,%eax
  800900:	75 e2                	jne    8008e4 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800902:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800907:	5b                   	pop    %ebx
  800908:	5e                   	pop    %esi
  800909:	5d                   	pop    %ebp
  80090a:	c3                   	ret    

0080090b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	53                   	push   %ebx
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800912:	89 c1                	mov    %eax,%ecx
  800914:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  800917:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80091b:	eb 0a                	jmp    800927 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  80091d:	0f b6 10             	movzbl (%eax),%edx
  800920:	39 da                	cmp    %ebx,%edx
  800922:	74 07                	je     80092b <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800924:	83 c0 01             	add    $0x1,%eax
  800927:	39 c8                	cmp    %ecx,%eax
  800929:	72 f2                	jb     80091d <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  80092b:	5b                   	pop    %ebx
  80092c:	5d                   	pop    %ebp
  80092d:	c3                   	ret    

0080092e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80092e:	55                   	push   %ebp
  80092f:	89 e5                	mov    %esp,%ebp
  800931:	57                   	push   %edi
  800932:	56                   	push   %esi
  800933:	53                   	push   %ebx
  800934:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800937:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80093a:	eb 03                	jmp    80093f <strtol+0x11>
		s++;
  80093c:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80093f:	0f b6 01             	movzbl (%ecx),%eax
  800942:	3c 20                	cmp    $0x20,%al
  800944:	74 f6                	je     80093c <strtol+0xe>
  800946:	3c 09                	cmp    $0x9,%al
  800948:	74 f2                	je     80093c <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  80094a:	3c 2b                	cmp    $0x2b,%al
  80094c:	75 0a                	jne    800958 <strtol+0x2a>
		s++;
  80094e:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800951:	bf 00 00 00 00       	mov    $0x0,%edi
  800956:	eb 11                	jmp    800969 <strtol+0x3b>
  800958:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  80095d:	3c 2d                	cmp    $0x2d,%al
  80095f:	75 08                	jne    800969 <strtol+0x3b>
		s++, neg = 1;
  800961:	83 c1 01             	add    $0x1,%ecx
  800964:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800969:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80096f:	75 15                	jne    800986 <strtol+0x58>
  800971:	80 39 30             	cmpb   $0x30,(%ecx)
  800974:	75 10                	jne    800986 <strtol+0x58>
  800976:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80097a:	75 7c                	jne    8009f8 <strtol+0xca>
		s += 2, base = 16;
  80097c:	83 c1 02             	add    $0x2,%ecx
  80097f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800984:	eb 16                	jmp    80099c <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800986:	85 db                	test   %ebx,%ebx
  800988:	75 12                	jne    80099c <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80098a:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  80098f:	80 39 30             	cmpb   $0x30,(%ecx)
  800992:	75 08                	jne    80099c <strtol+0x6e>
		s++, base = 8;
  800994:	83 c1 01             	add    $0x1,%ecx
  800997:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  80099c:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a1:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8009a4:	0f b6 11             	movzbl (%ecx),%edx
  8009a7:	8d 72 d0             	lea    -0x30(%edx),%esi
  8009aa:	89 f3                	mov    %esi,%ebx
  8009ac:	80 fb 09             	cmp    $0x9,%bl
  8009af:	77 08                	ja     8009b9 <strtol+0x8b>
			dig = *s - '0';
  8009b1:	0f be d2             	movsbl %dl,%edx
  8009b4:	83 ea 30             	sub    $0x30,%edx
  8009b7:	eb 22                	jmp    8009db <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  8009b9:	8d 72 9f             	lea    -0x61(%edx),%esi
  8009bc:	89 f3                	mov    %esi,%ebx
  8009be:	80 fb 19             	cmp    $0x19,%bl
  8009c1:	77 08                	ja     8009cb <strtol+0x9d>
			dig = *s - 'a' + 10;
  8009c3:	0f be d2             	movsbl %dl,%edx
  8009c6:	83 ea 57             	sub    $0x57,%edx
  8009c9:	eb 10                	jmp    8009db <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  8009cb:	8d 72 bf             	lea    -0x41(%edx),%esi
  8009ce:	89 f3                	mov    %esi,%ebx
  8009d0:	80 fb 19             	cmp    $0x19,%bl
  8009d3:	77 16                	ja     8009eb <strtol+0xbd>
			dig = *s - 'A' + 10;
  8009d5:	0f be d2             	movsbl %dl,%edx
  8009d8:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  8009db:	3b 55 10             	cmp    0x10(%ebp),%edx
  8009de:	7d 0b                	jge    8009eb <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  8009e0:	83 c1 01             	add    $0x1,%ecx
  8009e3:	0f af 45 10          	imul   0x10(%ebp),%eax
  8009e7:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  8009e9:	eb b9                	jmp    8009a4 <strtol+0x76>

	if (endptr)
  8009eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009ef:	74 0d                	je     8009fe <strtol+0xd0>
		*endptr = (char *) s;
  8009f1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009f4:	89 0e                	mov    %ecx,(%esi)
  8009f6:	eb 06                	jmp    8009fe <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009f8:	85 db                	test   %ebx,%ebx
  8009fa:	74 98                	je     800994 <strtol+0x66>
  8009fc:	eb 9e                	jmp    80099c <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  8009fe:	89 c2                	mov    %eax,%edx
  800a00:	f7 da                	neg    %edx
  800a02:	85 ff                	test   %edi,%edi
  800a04:	0f 45 c2             	cmovne %edx,%eax
}
  800a07:	5b                   	pop    %ebx
  800a08:	5e                   	pop    %esi
  800a09:	5f                   	pop    %edi
  800a0a:	5d                   	pop    %ebp
  800a0b:	c3                   	ret    

00800a0c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	57                   	push   %edi
  800a10:	56                   	push   %esi
  800a11:	53                   	push   %ebx
  800a12:	83 ec 1c             	sub    $0x1c,%esp
  800a15:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a18:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a1b:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800a1d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a20:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a23:	8b 7d 10             	mov    0x10(%ebp),%edi
  800a26:	8b 75 14             	mov    0x14(%ebp),%esi
  800a29:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800a2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2f:	74 1d                	je     800a4e <syscall+0x42>
  800a31:	85 c0                	test   %eax,%eax
  800a33:	7e 19                	jle    800a4e <syscall+0x42>
  800a35:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800a38:	83 ec 0c             	sub    $0xc,%esp
  800a3b:	50                   	push   %eax
  800a3c:	52                   	push   %edx
  800a3d:	68 7f 20 80 00       	push   $0x80207f
  800a42:	6a 23                	push   $0x23
  800a44:	68 9c 20 80 00       	push   $0x80209c
  800a49:	e8 e9 0e 00 00       	call   801937 <_panic>

	return ret;
}
  800a4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a51:	5b                   	pop    %ebx
  800a52:	5e                   	pop    %esi
  800a53:	5f                   	pop    %edi
  800a54:	5d                   	pop    %ebp
  800a55:	c3                   	ret    

00800a56 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800a5c:	6a 00                	push   $0x0
  800a5e:	6a 00                	push   $0x0
  800a60:	6a 00                	push   $0x0
  800a62:	ff 75 0c             	pushl  0xc(%ebp)
  800a65:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a68:	ba 00 00 00 00       	mov    $0x0,%edx
  800a6d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a72:	e8 95 ff ff ff       	call   800a0c <syscall>
}
  800a77:	83 c4 10             	add    $0x10,%esp
  800a7a:	c9                   	leave  
  800a7b:	c3                   	ret    

00800a7c <sys_cgetc>:

int
sys_cgetc(void)
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800a82:	6a 00                	push   $0x0
  800a84:	6a 00                	push   $0x0
  800a86:	6a 00                	push   $0x0
  800a88:	6a 00                	push   $0x0
  800a8a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a8f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a94:	b8 01 00 00 00       	mov    $0x1,%eax
  800a99:	e8 6e ff ff ff       	call   800a0c <syscall>
}
  800a9e:	c9                   	leave  
  800a9f:	c3                   	ret    

00800aa0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
  800aa3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800aa6:	6a 00                	push   $0x0
  800aa8:	6a 00                	push   $0x0
  800aaa:	6a 00                	push   $0x0
  800aac:	6a 00                	push   $0x0
  800aae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab1:	ba 01 00 00 00       	mov    $0x1,%edx
  800ab6:	b8 03 00 00 00       	mov    $0x3,%eax
  800abb:	e8 4c ff ff ff       	call   800a0c <syscall>
}
  800ac0:	c9                   	leave  
  800ac1:	c3                   	ret    

00800ac2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ac2:	55                   	push   %ebp
  800ac3:	89 e5                	mov    %esp,%ebp
  800ac5:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800ac8:	6a 00                	push   $0x0
  800aca:	6a 00                	push   $0x0
  800acc:	6a 00                	push   $0x0
  800ace:	6a 00                	push   $0x0
  800ad0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ad5:	ba 00 00 00 00       	mov    $0x0,%edx
  800ada:	b8 02 00 00 00       	mov    $0x2,%eax
  800adf:	e8 28 ff ff ff       	call   800a0c <syscall>
}
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <sys_yield>:

void
sys_yield(void)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800aec:	6a 00                	push   $0x0
  800aee:	6a 00                	push   $0x0
  800af0:	6a 00                	push   $0x0
  800af2:	6a 00                	push   $0x0
  800af4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800af9:	ba 00 00 00 00       	mov    $0x0,%edx
  800afe:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b03:	e8 04 ff ff ff       	call   800a0c <syscall>
}
  800b08:	83 c4 10             	add    $0x10,%esp
  800b0b:	c9                   	leave  
  800b0c:	c3                   	ret    

00800b0d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800b13:	6a 00                	push   $0x0
  800b15:	6a 00                	push   $0x0
  800b17:	ff 75 10             	pushl  0x10(%ebp)
  800b1a:	ff 75 0c             	pushl  0xc(%ebp)
  800b1d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b20:	ba 01 00 00 00       	mov    $0x1,%edx
  800b25:	b8 04 00 00 00       	mov    $0x4,%eax
  800b2a:	e8 dd fe ff ff       	call   800a0c <syscall>
}
  800b2f:	c9                   	leave  
  800b30:	c3                   	ret    

00800b31 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
  800b34:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800b37:	ff 75 18             	pushl  0x18(%ebp)
  800b3a:	ff 75 14             	pushl  0x14(%ebp)
  800b3d:	ff 75 10             	pushl  0x10(%ebp)
  800b40:	ff 75 0c             	pushl  0xc(%ebp)
  800b43:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b46:	ba 01 00 00 00       	mov    $0x1,%edx
  800b4b:	b8 05 00 00 00       	mov    $0x5,%eax
  800b50:	e8 b7 fe ff ff       	call   800a0c <syscall>
}
  800b55:	c9                   	leave  
  800b56:	c3                   	ret    

00800b57 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
  800b5a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800b5d:	6a 00                	push   $0x0
  800b5f:	6a 00                	push   $0x0
  800b61:	6a 00                	push   $0x0
  800b63:	ff 75 0c             	pushl  0xc(%ebp)
  800b66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b69:	ba 01 00 00 00       	mov    $0x1,%edx
  800b6e:	b8 06 00 00 00       	mov    $0x6,%eax
  800b73:	e8 94 fe ff ff       	call   800a0c <syscall>
}
  800b78:	c9                   	leave  
  800b79:	c3                   	ret    

00800b7a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800b80:	6a 00                	push   $0x0
  800b82:	6a 00                	push   $0x0
  800b84:	6a 00                	push   $0x0
  800b86:	ff 75 0c             	pushl  0xc(%ebp)
  800b89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b8c:	ba 01 00 00 00       	mov    $0x1,%edx
  800b91:	b8 08 00 00 00       	mov    $0x8,%eax
  800b96:	e8 71 fe ff ff       	call   800a0c <syscall>
}
  800b9b:	c9                   	leave  
  800b9c:	c3                   	ret    

00800b9d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800ba3:	6a 00                	push   $0x0
  800ba5:	6a 00                	push   $0x0
  800ba7:	6a 00                	push   $0x0
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800baf:	ba 01 00 00 00       	mov    $0x1,%edx
  800bb4:	b8 09 00 00 00       	mov    $0x9,%eax
  800bb9:	e8 4e fe ff ff       	call   800a0c <syscall>
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800bc6:	6a 00                	push   $0x0
  800bc8:	6a 00                	push   $0x0
  800bca:	6a 00                	push   $0x0
  800bcc:	ff 75 0c             	pushl  0xc(%ebp)
  800bcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd2:	ba 01 00 00 00       	mov    $0x1,%edx
  800bd7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bdc:	e8 2b fe ff ff       	call   800a0c <syscall>
}
  800be1:	c9                   	leave  
  800be2:	c3                   	ret    

00800be3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800be9:	6a 00                	push   $0x0
  800beb:	ff 75 14             	pushl  0x14(%ebp)
  800bee:	ff 75 10             	pushl  0x10(%ebp)
  800bf1:	ff 75 0c             	pushl  0xc(%ebp)
  800bf4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bfc:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c01:	e8 06 fe ff ff       	call   800a0c <syscall>
}
  800c06:	c9                   	leave  
  800c07:	c3                   	ret    

00800c08 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
  800c0b:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800c0e:	6a 00                	push   $0x0
  800c10:	6a 00                	push   $0x0
  800c12:	6a 00                	push   $0x0
  800c14:	6a 00                	push   $0x0
  800c16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c19:	ba 01 00 00 00       	mov    $0x1,%edx
  800c1e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800c23:	e8 e4 fd ff ff       	call   800a0c <syscall>
}
  800c28:	c9                   	leave  
  800c29:	c3                   	ret    

00800c2a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	05 00 00 00 30       	add    $0x30000000,%eax
  800c35:	c1 e8 0c             	shr    $0xc,%eax
}
  800c38:	5d                   	pop    %ebp
  800c39:	c3                   	ret    

00800c3a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  800c3d:	ff 75 08             	pushl  0x8(%ebp)
  800c40:	e8 e5 ff ff ff       	call   800c2a <fd2num>
  800c45:	83 c4 04             	add    $0x4,%esp
  800c48:	c1 e0 0c             	shl    $0xc,%eax
  800c4b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800c50:	c9                   	leave  
  800c51:	c3                   	ret    

00800c52 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c58:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800c5d:	89 c2                	mov    %eax,%edx
  800c5f:	c1 ea 16             	shr    $0x16,%edx
  800c62:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800c69:	f6 c2 01             	test   $0x1,%dl
  800c6c:	74 11                	je     800c7f <fd_alloc+0x2d>
  800c6e:	89 c2                	mov    %eax,%edx
  800c70:	c1 ea 0c             	shr    $0xc,%edx
  800c73:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800c7a:	f6 c2 01             	test   $0x1,%dl
  800c7d:	75 09                	jne    800c88 <fd_alloc+0x36>
			*fd_store = fd;
  800c7f:	89 01                	mov    %eax,(%ecx)
			return 0;
  800c81:	b8 00 00 00 00       	mov    $0x0,%eax
  800c86:	eb 17                	jmp    800c9f <fd_alloc+0x4d>
  800c88:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800c8d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800c92:	75 c9                	jne    800c5d <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800c94:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800c9a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800c9f:	5d                   	pop    %ebp
  800ca0:	c3                   	ret    

00800ca1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800ca7:	83 f8 1f             	cmp    $0x1f,%eax
  800caa:	77 36                	ja     800ce2 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800cac:	c1 e0 0c             	shl    $0xc,%eax
  800caf:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800cb4:	89 c2                	mov    %eax,%edx
  800cb6:	c1 ea 16             	shr    $0x16,%edx
  800cb9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800cc0:	f6 c2 01             	test   $0x1,%dl
  800cc3:	74 24                	je     800ce9 <fd_lookup+0x48>
  800cc5:	89 c2                	mov    %eax,%edx
  800cc7:	c1 ea 0c             	shr    $0xc,%edx
  800cca:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800cd1:	f6 c2 01             	test   $0x1,%dl
  800cd4:	74 1a                	je     800cf0 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800cd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd9:	89 02                	mov    %eax,(%edx)
	return 0;
  800cdb:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce0:	eb 13                	jmp    800cf5 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800ce2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ce7:	eb 0c                	jmp    800cf5 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800ce9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cee:	eb 05                	jmp    800cf5 <fd_lookup+0x54>
  800cf0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800cf5:	5d                   	pop    %ebp
  800cf6:	c3                   	ret    

00800cf7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	83 ec 08             	sub    $0x8,%esp
  800cfd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d00:	ba 28 21 80 00       	mov    $0x802128,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800d05:	eb 13                	jmp    800d1a <dev_lookup+0x23>
  800d07:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  800d0a:	39 08                	cmp    %ecx,(%eax)
  800d0c:	75 0c                	jne    800d1a <dev_lookup+0x23>
			*dev = devtab[i];
  800d0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d11:	89 01                	mov    %eax,(%ecx)
			return 0;
  800d13:	b8 00 00 00 00       	mov    $0x0,%eax
  800d18:	eb 2e                	jmp    800d48 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800d1a:	8b 02                	mov    (%edx),%eax
  800d1c:	85 c0                	test   %eax,%eax
  800d1e:	75 e7                	jne    800d07 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800d20:	a1 04 40 80 00       	mov    0x804004,%eax
  800d25:	8b 40 48             	mov    0x48(%eax),%eax
  800d28:	83 ec 04             	sub    $0x4,%esp
  800d2b:	51                   	push   %ecx
  800d2c:	50                   	push   %eax
  800d2d:	68 ac 20 80 00       	push   $0x8020ac
  800d32:	e8 1b f4 ff ff       	call   800152 <cprintf>
	*dev = 0;
  800d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800d40:	83 c4 10             	add    $0x10,%esp
  800d43:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800d48:	c9                   	leave  
  800d49:	c3                   	ret    

00800d4a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	56                   	push   %esi
  800d4e:	53                   	push   %ebx
  800d4f:	83 ec 10             	sub    $0x10,%esp
  800d52:	8b 75 08             	mov    0x8(%ebp),%esi
  800d55:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800d58:	56                   	push   %esi
  800d59:	e8 cc fe ff ff       	call   800c2a <fd2num>
  800d5e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800d61:	89 14 24             	mov    %edx,(%esp)
  800d64:	50                   	push   %eax
  800d65:	e8 37 ff ff ff       	call   800ca1 <fd_lookup>
  800d6a:	83 c4 08             	add    $0x8,%esp
  800d6d:	85 c0                	test   %eax,%eax
  800d6f:	78 05                	js     800d76 <fd_close+0x2c>
	    || fd != fd2)
  800d71:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800d74:	74 0c                	je     800d82 <fd_close+0x38>
		return (must_exist ? r : 0);
  800d76:	84 db                	test   %bl,%bl
  800d78:	ba 00 00 00 00       	mov    $0x0,%edx
  800d7d:	0f 44 c2             	cmove  %edx,%eax
  800d80:	eb 41                	jmp    800dc3 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800d82:	83 ec 08             	sub    $0x8,%esp
  800d85:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d88:	50                   	push   %eax
  800d89:	ff 36                	pushl  (%esi)
  800d8b:	e8 67 ff ff ff       	call   800cf7 <dev_lookup>
  800d90:	89 c3                	mov    %eax,%ebx
  800d92:	83 c4 10             	add    $0x10,%esp
  800d95:	85 c0                	test   %eax,%eax
  800d97:	78 1a                	js     800db3 <fd_close+0x69>
		if (dev->dev_close)
  800d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d9c:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800d9f:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800da4:	85 c0                	test   %eax,%eax
  800da6:	74 0b                	je     800db3 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  800da8:	83 ec 0c             	sub    $0xc,%esp
  800dab:	56                   	push   %esi
  800dac:	ff d0                	call   *%eax
  800dae:	89 c3                	mov    %eax,%ebx
  800db0:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800db3:	83 ec 08             	sub    $0x8,%esp
  800db6:	56                   	push   %esi
  800db7:	6a 00                	push   $0x0
  800db9:	e8 99 fd ff ff       	call   800b57 <sys_page_unmap>
	return r;
  800dbe:	83 c4 10             	add    $0x10,%esp
  800dc1:	89 d8                	mov    %ebx,%eax
}
  800dc3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dc6:	5b                   	pop    %ebx
  800dc7:	5e                   	pop    %esi
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    

00800dca <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800dd0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800dd3:	50                   	push   %eax
  800dd4:	ff 75 08             	pushl  0x8(%ebp)
  800dd7:	e8 c5 fe ff ff       	call   800ca1 <fd_lookup>
  800ddc:	83 c4 08             	add    $0x8,%esp
  800ddf:	85 c0                	test   %eax,%eax
  800de1:	78 10                	js     800df3 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800de3:	83 ec 08             	sub    $0x8,%esp
  800de6:	6a 01                	push   $0x1
  800de8:	ff 75 f4             	pushl  -0xc(%ebp)
  800deb:	e8 5a ff ff ff       	call   800d4a <fd_close>
  800df0:	83 c4 10             	add    $0x10,%esp
}
  800df3:	c9                   	leave  
  800df4:	c3                   	ret    

00800df5 <close_all>:

void
close_all(void)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	53                   	push   %ebx
  800df9:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800dfc:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800e01:	83 ec 0c             	sub    $0xc,%esp
  800e04:	53                   	push   %ebx
  800e05:	e8 c0 ff ff ff       	call   800dca <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800e0a:	83 c3 01             	add    $0x1,%ebx
  800e0d:	83 c4 10             	add    $0x10,%esp
  800e10:	83 fb 20             	cmp    $0x20,%ebx
  800e13:	75 ec                	jne    800e01 <close_all+0xc>
		close(i);
}
  800e15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e18:	c9                   	leave  
  800e19:	c3                   	ret    

00800e1a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	57                   	push   %edi
  800e1e:	56                   	push   %esi
  800e1f:	53                   	push   %ebx
  800e20:	83 ec 2c             	sub    $0x2c,%esp
  800e23:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800e26:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800e29:	50                   	push   %eax
  800e2a:	ff 75 08             	pushl  0x8(%ebp)
  800e2d:	e8 6f fe ff ff       	call   800ca1 <fd_lookup>
  800e32:	83 c4 08             	add    $0x8,%esp
  800e35:	85 c0                	test   %eax,%eax
  800e37:	0f 88 c1 00 00 00    	js     800efe <dup+0xe4>
		return r;
	close(newfdnum);
  800e3d:	83 ec 0c             	sub    $0xc,%esp
  800e40:	56                   	push   %esi
  800e41:	e8 84 ff ff ff       	call   800dca <close>

	newfd = INDEX2FD(newfdnum);
  800e46:	89 f3                	mov    %esi,%ebx
  800e48:	c1 e3 0c             	shl    $0xc,%ebx
  800e4b:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800e51:	83 c4 04             	add    $0x4,%esp
  800e54:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e57:	e8 de fd ff ff       	call   800c3a <fd2data>
  800e5c:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  800e5e:	89 1c 24             	mov    %ebx,(%esp)
  800e61:	e8 d4 fd ff ff       	call   800c3a <fd2data>
  800e66:	83 c4 10             	add    $0x10,%esp
  800e69:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800e6c:	89 f8                	mov    %edi,%eax
  800e6e:	c1 e8 16             	shr    $0x16,%eax
  800e71:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800e78:	a8 01                	test   $0x1,%al
  800e7a:	74 37                	je     800eb3 <dup+0x99>
  800e7c:	89 f8                	mov    %edi,%eax
  800e7e:	c1 e8 0c             	shr    $0xc,%eax
  800e81:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800e88:	f6 c2 01             	test   $0x1,%dl
  800e8b:	74 26                	je     800eb3 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800e8d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e94:	83 ec 0c             	sub    $0xc,%esp
  800e97:	25 07 0e 00 00       	and    $0xe07,%eax
  800e9c:	50                   	push   %eax
  800e9d:	ff 75 d4             	pushl  -0x2c(%ebp)
  800ea0:	6a 00                	push   $0x0
  800ea2:	57                   	push   %edi
  800ea3:	6a 00                	push   $0x0
  800ea5:	e8 87 fc ff ff       	call   800b31 <sys_page_map>
  800eaa:	89 c7                	mov    %eax,%edi
  800eac:	83 c4 20             	add    $0x20,%esp
  800eaf:	85 c0                	test   %eax,%eax
  800eb1:	78 2e                	js     800ee1 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800eb3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800eb6:	89 d0                	mov    %edx,%eax
  800eb8:	c1 e8 0c             	shr    $0xc,%eax
  800ebb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ec2:	83 ec 0c             	sub    $0xc,%esp
  800ec5:	25 07 0e 00 00       	and    $0xe07,%eax
  800eca:	50                   	push   %eax
  800ecb:	53                   	push   %ebx
  800ecc:	6a 00                	push   $0x0
  800ece:	52                   	push   %edx
  800ecf:	6a 00                	push   $0x0
  800ed1:	e8 5b fc ff ff       	call   800b31 <sys_page_map>
  800ed6:	89 c7                	mov    %eax,%edi
  800ed8:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  800edb:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800edd:	85 ff                	test   %edi,%edi
  800edf:	79 1d                	jns    800efe <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800ee1:	83 ec 08             	sub    $0x8,%esp
  800ee4:	53                   	push   %ebx
  800ee5:	6a 00                	push   $0x0
  800ee7:	e8 6b fc ff ff       	call   800b57 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800eec:	83 c4 08             	add    $0x8,%esp
  800eef:	ff 75 d4             	pushl  -0x2c(%ebp)
  800ef2:	6a 00                	push   $0x0
  800ef4:	e8 5e fc ff ff       	call   800b57 <sys_page_unmap>
	return r;
  800ef9:	83 c4 10             	add    $0x10,%esp
  800efc:	89 f8                	mov    %edi,%eax
}
  800efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f01:	5b                   	pop    %ebx
  800f02:	5e                   	pop    %esi
  800f03:	5f                   	pop    %edi
  800f04:	5d                   	pop    %ebp
  800f05:	c3                   	ret    

00800f06 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	53                   	push   %ebx
  800f0a:	83 ec 14             	sub    $0x14,%esp
  800f0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800f10:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800f13:	50                   	push   %eax
  800f14:	53                   	push   %ebx
  800f15:	e8 87 fd ff ff       	call   800ca1 <fd_lookup>
  800f1a:	83 c4 08             	add    $0x8,%esp
  800f1d:	89 c2                	mov    %eax,%edx
  800f1f:	85 c0                	test   %eax,%eax
  800f21:	78 6d                	js     800f90 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800f23:	83 ec 08             	sub    $0x8,%esp
  800f26:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f29:	50                   	push   %eax
  800f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f2d:	ff 30                	pushl  (%eax)
  800f2f:	e8 c3 fd ff ff       	call   800cf7 <dev_lookup>
  800f34:	83 c4 10             	add    $0x10,%esp
  800f37:	85 c0                	test   %eax,%eax
  800f39:	78 4c                	js     800f87 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800f3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f3e:	8b 42 08             	mov    0x8(%edx),%eax
  800f41:	83 e0 03             	and    $0x3,%eax
  800f44:	83 f8 01             	cmp    $0x1,%eax
  800f47:	75 21                	jne    800f6a <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800f49:	a1 04 40 80 00       	mov    0x804004,%eax
  800f4e:	8b 40 48             	mov    0x48(%eax),%eax
  800f51:	83 ec 04             	sub    $0x4,%esp
  800f54:	53                   	push   %ebx
  800f55:	50                   	push   %eax
  800f56:	68 ed 20 80 00       	push   $0x8020ed
  800f5b:	e8 f2 f1 ff ff       	call   800152 <cprintf>
		return -E_INVAL;
  800f60:	83 c4 10             	add    $0x10,%esp
  800f63:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800f68:	eb 26                	jmp    800f90 <read+0x8a>
	}
	if (!dev->dev_read)
  800f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f6d:	8b 40 08             	mov    0x8(%eax),%eax
  800f70:	85 c0                	test   %eax,%eax
  800f72:	74 17                	je     800f8b <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800f74:	83 ec 04             	sub    $0x4,%esp
  800f77:	ff 75 10             	pushl  0x10(%ebp)
  800f7a:	ff 75 0c             	pushl  0xc(%ebp)
  800f7d:	52                   	push   %edx
  800f7e:	ff d0                	call   *%eax
  800f80:	89 c2                	mov    %eax,%edx
  800f82:	83 c4 10             	add    $0x10,%esp
  800f85:	eb 09                	jmp    800f90 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800f87:	89 c2                	mov    %eax,%edx
  800f89:	eb 05                	jmp    800f90 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800f8b:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  800f90:	89 d0                	mov    %edx,%eax
  800f92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f95:	c9                   	leave  
  800f96:	c3                   	ret    

00800f97 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	57                   	push   %edi
  800f9b:	56                   	push   %esi
  800f9c:	53                   	push   %ebx
  800f9d:	83 ec 0c             	sub    $0xc,%esp
  800fa0:	8b 7d 08             	mov    0x8(%ebp),%edi
  800fa3:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800fa6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fab:	eb 21                	jmp    800fce <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800fad:	83 ec 04             	sub    $0x4,%esp
  800fb0:	89 f0                	mov    %esi,%eax
  800fb2:	29 d8                	sub    %ebx,%eax
  800fb4:	50                   	push   %eax
  800fb5:	89 d8                	mov    %ebx,%eax
  800fb7:	03 45 0c             	add    0xc(%ebp),%eax
  800fba:	50                   	push   %eax
  800fbb:	57                   	push   %edi
  800fbc:	e8 45 ff ff ff       	call   800f06 <read>
		if (m < 0)
  800fc1:	83 c4 10             	add    $0x10,%esp
  800fc4:	85 c0                	test   %eax,%eax
  800fc6:	78 10                	js     800fd8 <readn+0x41>
			return m;
		if (m == 0)
  800fc8:	85 c0                	test   %eax,%eax
  800fca:	74 0a                	je     800fd6 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800fcc:	01 c3                	add    %eax,%ebx
  800fce:	39 f3                	cmp    %esi,%ebx
  800fd0:	72 db                	jb     800fad <readn+0x16>
  800fd2:	89 d8                	mov    %ebx,%eax
  800fd4:	eb 02                	jmp    800fd8 <readn+0x41>
  800fd6:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  800fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fdb:	5b                   	pop    %ebx
  800fdc:	5e                   	pop    %esi
  800fdd:	5f                   	pop    %edi
  800fde:	5d                   	pop    %ebp
  800fdf:	c3                   	ret    

00800fe0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	53                   	push   %ebx
  800fe4:	83 ec 14             	sub    $0x14,%esp
  800fe7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800fea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800fed:	50                   	push   %eax
  800fee:	53                   	push   %ebx
  800fef:	e8 ad fc ff ff       	call   800ca1 <fd_lookup>
  800ff4:	83 c4 08             	add    $0x8,%esp
  800ff7:	89 c2                	mov    %eax,%edx
  800ff9:	85 c0                	test   %eax,%eax
  800ffb:	78 68                	js     801065 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ffd:	83 ec 08             	sub    $0x8,%esp
  801000:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801003:	50                   	push   %eax
  801004:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801007:	ff 30                	pushl  (%eax)
  801009:	e8 e9 fc ff ff       	call   800cf7 <dev_lookup>
  80100e:	83 c4 10             	add    $0x10,%esp
  801011:	85 c0                	test   %eax,%eax
  801013:	78 47                	js     80105c <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801015:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801018:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80101c:	75 21                	jne    80103f <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80101e:	a1 04 40 80 00       	mov    0x804004,%eax
  801023:	8b 40 48             	mov    0x48(%eax),%eax
  801026:	83 ec 04             	sub    $0x4,%esp
  801029:	53                   	push   %ebx
  80102a:	50                   	push   %eax
  80102b:	68 09 21 80 00       	push   $0x802109
  801030:	e8 1d f1 ff ff       	call   800152 <cprintf>
		return -E_INVAL;
  801035:	83 c4 10             	add    $0x10,%esp
  801038:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80103d:	eb 26                	jmp    801065 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80103f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801042:	8b 52 0c             	mov    0xc(%edx),%edx
  801045:	85 d2                	test   %edx,%edx
  801047:	74 17                	je     801060 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801049:	83 ec 04             	sub    $0x4,%esp
  80104c:	ff 75 10             	pushl  0x10(%ebp)
  80104f:	ff 75 0c             	pushl  0xc(%ebp)
  801052:	50                   	push   %eax
  801053:	ff d2                	call   *%edx
  801055:	89 c2                	mov    %eax,%edx
  801057:	83 c4 10             	add    $0x10,%esp
  80105a:	eb 09                	jmp    801065 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80105c:	89 c2                	mov    %eax,%edx
  80105e:	eb 05                	jmp    801065 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801060:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  801065:	89 d0                	mov    %edx,%eax
  801067:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80106a:	c9                   	leave  
  80106b:	c3                   	ret    

0080106c <seek>:

int
seek(int fdnum, off_t offset)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801072:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801075:	50                   	push   %eax
  801076:	ff 75 08             	pushl  0x8(%ebp)
  801079:	e8 23 fc ff ff       	call   800ca1 <fd_lookup>
  80107e:	83 c4 08             	add    $0x8,%esp
  801081:	85 c0                	test   %eax,%eax
  801083:	78 0e                	js     801093 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801085:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801088:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80108e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801093:	c9                   	leave  
  801094:	c3                   	ret    

00801095 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	53                   	push   %ebx
  801099:	83 ec 14             	sub    $0x14,%esp
  80109c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80109f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010a2:	50                   	push   %eax
  8010a3:	53                   	push   %ebx
  8010a4:	e8 f8 fb ff ff       	call   800ca1 <fd_lookup>
  8010a9:	83 c4 08             	add    $0x8,%esp
  8010ac:	89 c2                	mov    %eax,%edx
  8010ae:	85 c0                	test   %eax,%eax
  8010b0:	78 65                	js     801117 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010b2:	83 ec 08             	sub    $0x8,%esp
  8010b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010b8:	50                   	push   %eax
  8010b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010bc:	ff 30                	pushl  (%eax)
  8010be:	e8 34 fc ff ff       	call   800cf7 <dev_lookup>
  8010c3:	83 c4 10             	add    $0x10,%esp
  8010c6:	85 c0                	test   %eax,%eax
  8010c8:	78 44                	js     80110e <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8010ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010cd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8010d1:	75 21                	jne    8010f4 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8010d3:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8010d8:	8b 40 48             	mov    0x48(%eax),%eax
  8010db:	83 ec 04             	sub    $0x4,%esp
  8010de:	53                   	push   %ebx
  8010df:	50                   	push   %eax
  8010e0:	68 cc 20 80 00       	push   $0x8020cc
  8010e5:	e8 68 f0 ff ff       	call   800152 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8010ea:	83 c4 10             	add    $0x10,%esp
  8010ed:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8010f2:	eb 23                	jmp    801117 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  8010f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f7:	8b 52 18             	mov    0x18(%edx),%edx
  8010fa:	85 d2                	test   %edx,%edx
  8010fc:	74 14                	je     801112 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8010fe:	83 ec 08             	sub    $0x8,%esp
  801101:	ff 75 0c             	pushl  0xc(%ebp)
  801104:	50                   	push   %eax
  801105:	ff d2                	call   *%edx
  801107:	89 c2                	mov    %eax,%edx
  801109:	83 c4 10             	add    $0x10,%esp
  80110c:	eb 09                	jmp    801117 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80110e:	89 c2                	mov    %eax,%edx
  801110:	eb 05                	jmp    801117 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801112:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  801117:	89 d0                	mov    %edx,%eax
  801119:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80111c:	c9                   	leave  
  80111d:	c3                   	ret    

0080111e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	53                   	push   %ebx
  801122:	83 ec 14             	sub    $0x14,%esp
  801125:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801128:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80112b:	50                   	push   %eax
  80112c:	ff 75 08             	pushl  0x8(%ebp)
  80112f:	e8 6d fb ff ff       	call   800ca1 <fd_lookup>
  801134:	83 c4 08             	add    $0x8,%esp
  801137:	89 c2                	mov    %eax,%edx
  801139:	85 c0                	test   %eax,%eax
  80113b:	78 58                	js     801195 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80113d:	83 ec 08             	sub    $0x8,%esp
  801140:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801143:	50                   	push   %eax
  801144:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801147:	ff 30                	pushl  (%eax)
  801149:	e8 a9 fb ff ff       	call   800cf7 <dev_lookup>
  80114e:	83 c4 10             	add    $0x10,%esp
  801151:	85 c0                	test   %eax,%eax
  801153:	78 37                	js     80118c <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  801155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801158:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80115c:	74 32                	je     801190 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80115e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801161:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801168:	00 00 00 
	stat->st_isdir = 0;
  80116b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801172:	00 00 00 
	stat->st_dev = dev;
  801175:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80117b:	83 ec 08             	sub    $0x8,%esp
  80117e:	53                   	push   %ebx
  80117f:	ff 75 f0             	pushl  -0x10(%ebp)
  801182:	ff 50 14             	call   *0x14(%eax)
  801185:	89 c2                	mov    %eax,%edx
  801187:	83 c4 10             	add    $0x10,%esp
  80118a:	eb 09                	jmp    801195 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80118c:	89 c2                	mov    %eax,%edx
  80118e:	eb 05                	jmp    801195 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801190:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801195:	89 d0                	mov    %edx,%eax
  801197:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80119a:	c9                   	leave  
  80119b:	c3                   	ret    

0080119c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	56                   	push   %esi
  8011a0:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8011a1:	83 ec 08             	sub    $0x8,%esp
  8011a4:	6a 00                	push   $0x0
  8011a6:	ff 75 08             	pushl  0x8(%ebp)
  8011a9:	e8 06 02 00 00       	call   8013b4 <open>
  8011ae:	89 c3                	mov    %eax,%ebx
  8011b0:	83 c4 10             	add    $0x10,%esp
  8011b3:	85 c0                	test   %eax,%eax
  8011b5:	78 1b                	js     8011d2 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8011b7:	83 ec 08             	sub    $0x8,%esp
  8011ba:	ff 75 0c             	pushl  0xc(%ebp)
  8011bd:	50                   	push   %eax
  8011be:	e8 5b ff ff ff       	call   80111e <fstat>
  8011c3:	89 c6                	mov    %eax,%esi
	close(fd);
  8011c5:	89 1c 24             	mov    %ebx,(%esp)
  8011c8:	e8 fd fb ff ff       	call   800dca <close>
	return r;
  8011cd:	83 c4 10             	add    $0x10,%esp
  8011d0:	89 f0                	mov    %esi,%eax
}
  8011d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011d5:	5b                   	pop    %ebx
  8011d6:	5e                   	pop    %esi
  8011d7:	5d                   	pop    %ebp
  8011d8:	c3                   	ret    

008011d9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	56                   	push   %esi
  8011dd:	53                   	push   %ebx
  8011de:	89 c6                	mov    %eax,%esi
  8011e0:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8011e2:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8011e9:	75 12                	jne    8011fd <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8011eb:	83 ec 0c             	sub    $0xc,%esp
  8011ee:	6a 01                	push   $0x1
  8011f0:	e8 47 08 00 00       	call   801a3c <ipc_find_env>
  8011f5:	a3 00 40 80 00       	mov    %eax,0x804000
  8011fa:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8011fd:	6a 07                	push   $0x7
  8011ff:	68 00 50 80 00       	push   $0x805000
  801204:	56                   	push   %esi
  801205:	ff 35 00 40 80 00    	pushl  0x804000
  80120b:	e8 d8 07 00 00       	call   8019e8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801210:	83 c4 0c             	add    $0xc,%esp
  801213:	6a 00                	push   $0x0
  801215:	53                   	push   %ebx
  801216:	6a 00                	push   $0x0
  801218:	e8 60 07 00 00       	call   80197d <ipc_recv>
}
  80121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801220:	5b                   	pop    %ebx
  801221:	5e                   	pop    %esi
  801222:	5d                   	pop    %ebp
  801223:	c3                   	ret    

00801224 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801224:	55                   	push   %ebp
  801225:	89 e5                	mov    %esp,%ebp
  801227:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	8b 40 0c             	mov    0xc(%eax),%eax
  801230:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801235:	8b 45 0c             	mov    0xc(%ebp),%eax
  801238:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80123d:	ba 00 00 00 00       	mov    $0x0,%edx
  801242:	b8 02 00 00 00       	mov    $0x2,%eax
  801247:	e8 8d ff ff ff       	call   8011d9 <fsipc>
}
  80124c:	c9                   	leave  
  80124d:	c3                   	ret    

0080124e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	8b 40 0c             	mov    0xc(%eax),%eax
  80125a:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80125f:	ba 00 00 00 00       	mov    $0x0,%edx
  801264:	b8 06 00 00 00       	mov    $0x6,%eax
  801269:	e8 6b ff ff ff       	call   8011d9 <fsipc>
}
  80126e:	c9                   	leave  
  80126f:	c3                   	ret    

00801270 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801270:	55                   	push   %ebp
  801271:	89 e5                	mov    %esp,%ebp
  801273:	53                   	push   %ebx
  801274:	83 ec 04             	sub    $0x4,%esp
  801277:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
  80127d:	8b 40 0c             	mov    0xc(%eax),%eax
  801280:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801285:	ba 00 00 00 00       	mov    $0x0,%edx
  80128a:	b8 05 00 00 00       	mov    $0x5,%eax
  80128f:	e8 45 ff ff ff       	call   8011d9 <fsipc>
  801294:	85 c0                	test   %eax,%eax
  801296:	78 2c                	js     8012c4 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801298:	83 ec 08             	sub    $0x8,%esp
  80129b:	68 00 50 80 00       	push   $0x805000
  8012a0:	53                   	push   %ebx
  8012a1:	e8 1e f4 ff ff       	call   8006c4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8012a6:	a1 80 50 80 00       	mov    0x805080,%eax
  8012ab:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8012b1:	a1 84 50 80 00       	mov    0x805084,%eax
  8012b6:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8012bc:	83 c4 10             	add    $0x10,%esp
  8012bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c7:	c9                   	leave  
  8012c8:	c3                   	ret    

008012c9 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8012c9:	55                   	push   %ebp
  8012ca:	89 e5                	mov    %esp,%ebp
  8012cc:	83 ec 08             	sub    $0x8,%esp
  8012cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d2:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8012d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d8:	8b 49 0c             	mov    0xc(%ecx),%ecx
  8012db:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  8012e1:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8012e6:	76 22                	jbe    80130a <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  8012e8:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  8012ef:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  8012f2:	83 ec 04             	sub    $0x4,%esp
  8012f5:	68 f8 0f 00 00       	push   $0xff8
  8012fa:	52                   	push   %edx
  8012fb:	68 08 50 80 00       	push   $0x805008
  801300:	e8 52 f5 ff ff       	call   800857 <memmove>
  801305:	83 c4 10             	add    $0x10,%esp
  801308:	eb 17                	jmp    801321 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  80130a:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  80130f:	83 ec 04             	sub    $0x4,%esp
  801312:	50                   	push   %eax
  801313:	52                   	push   %edx
  801314:	68 08 50 80 00       	push   $0x805008
  801319:	e8 39 f5 ff ff       	call   800857 <memmove>
  80131e:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  801321:	ba 00 00 00 00       	mov    $0x0,%edx
  801326:	b8 04 00 00 00       	mov    $0x4,%eax
  80132b:	e8 a9 fe ff ff       	call   8011d9 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  801330:	c9                   	leave  
  801331:	c3                   	ret    

00801332 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
  801335:	56                   	push   %esi
  801336:	53                   	push   %ebx
  801337:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	8b 40 0c             	mov    0xc(%eax),%eax
  801340:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801345:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80134b:	ba 00 00 00 00       	mov    $0x0,%edx
  801350:	b8 03 00 00 00       	mov    $0x3,%eax
  801355:	e8 7f fe ff ff       	call   8011d9 <fsipc>
  80135a:	89 c3                	mov    %eax,%ebx
  80135c:	85 c0                	test   %eax,%eax
  80135e:	78 4b                	js     8013ab <devfile_read+0x79>
		return r;
	assert(r <= n);
  801360:	39 c6                	cmp    %eax,%esi
  801362:	73 16                	jae    80137a <devfile_read+0x48>
  801364:	68 38 21 80 00       	push   $0x802138
  801369:	68 3f 21 80 00       	push   $0x80213f
  80136e:	6a 7c                	push   $0x7c
  801370:	68 54 21 80 00       	push   $0x802154
  801375:	e8 bd 05 00 00       	call   801937 <_panic>
	assert(r <= PGSIZE);
  80137a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80137f:	7e 16                	jle    801397 <devfile_read+0x65>
  801381:	68 5f 21 80 00       	push   $0x80215f
  801386:	68 3f 21 80 00       	push   $0x80213f
  80138b:	6a 7d                	push   $0x7d
  80138d:	68 54 21 80 00       	push   $0x802154
  801392:	e8 a0 05 00 00       	call   801937 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801397:	83 ec 04             	sub    $0x4,%esp
  80139a:	50                   	push   %eax
  80139b:	68 00 50 80 00       	push   $0x805000
  8013a0:	ff 75 0c             	pushl  0xc(%ebp)
  8013a3:	e8 af f4 ff ff       	call   800857 <memmove>
	return r;
  8013a8:	83 c4 10             	add    $0x10,%esp
}
  8013ab:	89 d8                	mov    %ebx,%eax
  8013ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013b0:	5b                   	pop    %ebx
  8013b1:	5e                   	pop    %esi
  8013b2:	5d                   	pop    %ebp
  8013b3:	c3                   	ret    

008013b4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	53                   	push   %ebx
  8013b8:	83 ec 20             	sub    $0x20,%esp
  8013bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8013be:	53                   	push   %ebx
  8013bf:	e8 c7 f2 ff ff       	call   80068b <strlen>
  8013c4:	83 c4 10             	add    $0x10,%esp
  8013c7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8013cc:	7f 67                	jg     801435 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8013ce:	83 ec 0c             	sub    $0xc,%esp
  8013d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d4:	50                   	push   %eax
  8013d5:	e8 78 f8 ff ff       	call   800c52 <fd_alloc>
  8013da:	83 c4 10             	add    $0x10,%esp
		return r;
  8013dd:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8013df:	85 c0                	test   %eax,%eax
  8013e1:	78 57                	js     80143a <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8013e3:	83 ec 08             	sub    $0x8,%esp
  8013e6:	53                   	push   %ebx
  8013e7:	68 00 50 80 00       	push   $0x805000
  8013ec:	e8 d3 f2 ff ff       	call   8006c4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8013f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f4:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8013f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013fc:	b8 01 00 00 00       	mov    $0x1,%eax
  801401:	e8 d3 fd ff ff       	call   8011d9 <fsipc>
  801406:	89 c3                	mov    %eax,%ebx
  801408:	83 c4 10             	add    $0x10,%esp
  80140b:	85 c0                	test   %eax,%eax
  80140d:	79 14                	jns    801423 <open+0x6f>
		fd_close(fd, 0);
  80140f:	83 ec 08             	sub    $0x8,%esp
  801412:	6a 00                	push   $0x0
  801414:	ff 75 f4             	pushl  -0xc(%ebp)
  801417:	e8 2e f9 ff ff       	call   800d4a <fd_close>
		return r;
  80141c:	83 c4 10             	add    $0x10,%esp
  80141f:	89 da                	mov    %ebx,%edx
  801421:	eb 17                	jmp    80143a <open+0x86>
	}

	return fd2num(fd);
  801423:	83 ec 0c             	sub    $0xc,%esp
  801426:	ff 75 f4             	pushl  -0xc(%ebp)
  801429:	e8 fc f7 ff ff       	call   800c2a <fd2num>
  80142e:	89 c2                	mov    %eax,%edx
  801430:	83 c4 10             	add    $0x10,%esp
  801433:	eb 05                	jmp    80143a <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801435:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  80143a:	89 d0                	mov    %edx,%eax
  80143c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80143f:	c9                   	leave  
  801440:	c3                   	ret    

00801441 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
  801444:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801447:	ba 00 00 00 00       	mov    $0x0,%edx
  80144c:	b8 08 00 00 00       	mov    $0x8,%eax
  801451:	e8 83 fd ff ff       	call   8011d9 <fsipc>
}
  801456:	c9                   	leave  
  801457:	c3                   	ret    

00801458 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
  80145b:	56                   	push   %esi
  80145c:	53                   	push   %ebx
  80145d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801460:	83 ec 0c             	sub    $0xc,%esp
  801463:	ff 75 08             	pushl  0x8(%ebp)
  801466:	e8 cf f7 ff ff       	call   800c3a <fd2data>
  80146b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80146d:	83 c4 08             	add    $0x8,%esp
  801470:	68 6b 21 80 00       	push   $0x80216b
  801475:	53                   	push   %ebx
  801476:	e8 49 f2 ff ff       	call   8006c4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80147b:	8b 46 04             	mov    0x4(%esi),%eax
  80147e:	2b 06                	sub    (%esi),%eax
  801480:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801486:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80148d:	00 00 00 
	stat->st_dev = &devpipe;
  801490:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801497:	30 80 00 
	return 0;
}
  80149a:	b8 00 00 00 00       	mov    $0x0,%eax
  80149f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014a2:	5b                   	pop    %ebx
  8014a3:	5e                   	pop    %esi
  8014a4:	5d                   	pop    %ebp
  8014a5:	c3                   	ret    

008014a6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8014a6:	55                   	push   %ebp
  8014a7:	89 e5                	mov    %esp,%ebp
  8014a9:	53                   	push   %ebx
  8014aa:	83 ec 0c             	sub    $0xc,%esp
  8014ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8014b0:	53                   	push   %ebx
  8014b1:	6a 00                	push   $0x0
  8014b3:	e8 9f f6 ff ff       	call   800b57 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8014b8:	89 1c 24             	mov    %ebx,(%esp)
  8014bb:	e8 7a f7 ff ff       	call   800c3a <fd2data>
  8014c0:	83 c4 08             	add    $0x8,%esp
  8014c3:	50                   	push   %eax
  8014c4:	6a 00                	push   $0x0
  8014c6:	e8 8c f6 ff ff       	call   800b57 <sys_page_unmap>
}
  8014cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    

008014d0 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	57                   	push   %edi
  8014d4:	56                   	push   %esi
  8014d5:	53                   	push   %ebx
  8014d6:	83 ec 1c             	sub    $0x1c,%esp
  8014d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8014dc:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8014de:	a1 04 40 80 00       	mov    0x804004,%eax
  8014e3:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  8014e6:	83 ec 0c             	sub    $0xc,%esp
  8014e9:	ff 75 e0             	pushl  -0x20(%ebp)
  8014ec:	e8 84 05 00 00       	call   801a75 <pageref>
  8014f1:	89 c3                	mov    %eax,%ebx
  8014f3:	89 3c 24             	mov    %edi,(%esp)
  8014f6:	e8 7a 05 00 00       	call   801a75 <pageref>
  8014fb:	83 c4 10             	add    $0x10,%esp
  8014fe:	39 c3                	cmp    %eax,%ebx
  801500:	0f 94 c1             	sete   %cl
  801503:	0f b6 c9             	movzbl %cl,%ecx
  801506:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801509:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80150f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801512:	39 ce                	cmp    %ecx,%esi
  801514:	74 1b                	je     801531 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801516:	39 c3                	cmp    %eax,%ebx
  801518:	75 c4                	jne    8014de <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80151a:	8b 42 58             	mov    0x58(%edx),%eax
  80151d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801520:	50                   	push   %eax
  801521:	56                   	push   %esi
  801522:	68 72 21 80 00       	push   $0x802172
  801527:	e8 26 ec ff ff       	call   800152 <cprintf>
  80152c:	83 c4 10             	add    $0x10,%esp
  80152f:	eb ad                	jmp    8014de <_pipeisclosed+0xe>
	}
}
  801531:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801534:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801537:	5b                   	pop    %ebx
  801538:	5e                   	pop    %esi
  801539:	5f                   	pop    %edi
  80153a:	5d                   	pop    %ebp
  80153b:	c3                   	ret    

0080153c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
  80153f:	57                   	push   %edi
  801540:	56                   	push   %esi
  801541:	53                   	push   %ebx
  801542:	83 ec 28             	sub    $0x28,%esp
  801545:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801548:	56                   	push   %esi
  801549:	e8 ec f6 ff ff       	call   800c3a <fd2data>
  80154e:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801550:	83 c4 10             	add    $0x10,%esp
  801553:	bf 00 00 00 00       	mov    $0x0,%edi
  801558:	eb 4b                	jmp    8015a5 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80155a:	89 da                	mov    %ebx,%edx
  80155c:	89 f0                	mov    %esi,%eax
  80155e:	e8 6d ff ff ff       	call   8014d0 <_pipeisclosed>
  801563:	85 c0                	test   %eax,%eax
  801565:	75 48                	jne    8015af <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801567:	e8 7a f5 ff ff       	call   800ae6 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80156c:	8b 43 04             	mov    0x4(%ebx),%eax
  80156f:	8b 0b                	mov    (%ebx),%ecx
  801571:	8d 51 20             	lea    0x20(%ecx),%edx
  801574:	39 d0                	cmp    %edx,%eax
  801576:	73 e2                	jae    80155a <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801578:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80157b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80157f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801582:	89 c2                	mov    %eax,%edx
  801584:	c1 fa 1f             	sar    $0x1f,%edx
  801587:	89 d1                	mov    %edx,%ecx
  801589:	c1 e9 1b             	shr    $0x1b,%ecx
  80158c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80158f:	83 e2 1f             	and    $0x1f,%edx
  801592:	29 ca                	sub    %ecx,%edx
  801594:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801598:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80159c:	83 c0 01             	add    $0x1,%eax
  80159f:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8015a2:	83 c7 01             	add    $0x1,%edi
  8015a5:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8015a8:	75 c2                	jne    80156c <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8015aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ad:	eb 05                	jmp    8015b4 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8015af:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8015b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015b7:	5b                   	pop    %ebx
  8015b8:	5e                   	pop    %esi
  8015b9:	5f                   	pop    %edi
  8015ba:	5d                   	pop    %ebp
  8015bb:	c3                   	ret    

008015bc <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	57                   	push   %edi
  8015c0:	56                   	push   %esi
  8015c1:	53                   	push   %ebx
  8015c2:	83 ec 18             	sub    $0x18,%esp
  8015c5:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8015c8:	57                   	push   %edi
  8015c9:	e8 6c f6 ff ff       	call   800c3a <fd2data>
  8015ce:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8015d0:	83 c4 10             	add    $0x10,%esp
  8015d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d8:	eb 3d                	jmp    801617 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8015da:	85 db                	test   %ebx,%ebx
  8015dc:	74 04                	je     8015e2 <devpipe_read+0x26>
				return i;
  8015de:	89 d8                	mov    %ebx,%eax
  8015e0:	eb 44                	jmp    801626 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8015e2:	89 f2                	mov    %esi,%edx
  8015e4:	89 f8                	mov    %edi,%eax
  8015e6:	e8 e5 fe ff ff       	call   8014d0 <_pipeisclosed>
  8015eb:	85 c0                	test   %eax,%eax
  8015ed:	75 32                	jne    801621 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8015ef:	e8 f2 f4 ff ff       	call   800ae6 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8015f4:	8b 06                	mov    (%esi),%eax
  8015f6:	3b 46 04             	cmp    0x4(%esi),%eax
  8015f9:	74 df                	je     8015da <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8015fb:	99                   	cltd   
  8015fc:	c1 ea 1b             	shr    $0x1b,%edx
  8015ff:	01 d0                	add    %edx,%eax
  801601:	83 e0 1f             	and    $0x1f,%eax
  801604:	29 d0                	sub    %edx,%eax
  801606:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  80160b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80160e:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801611:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801614:	83 c3 01             	add    $0x1,%ebx
  801617:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  80161a:	75 d8                	jne    8015f4 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80161c:	8b 45 10             	mov    0x10(%ebp),%eax
  80161f:	eb 05                	jmp    801626 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801621:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801626:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801629:	5b                   	pop    %ebx
  80162a:	5e                   	pop    %esi
  80162b:	5f                   	pop    %edi
  80162c:	5d                   	pop    %ebp
  80162d:	c3                   	ret    

0080162e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	56                   	push   %esi
  801632:	53                   	push   %ebx
  801633:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801636:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801639:	50                   	push   %eax
  80163a:	e8 13 f6 ff ff       	call   800c52 <fd_alloc>
  80163f:	83 c4 10             	add    $0x10,%esp
  801642:	89 c2                	mov    %eax,%edx
  801644:	85 c0                	test   %eax,%eax
  801646:	0f 88 2c 01 00 00    	js     801778 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80164c:	83 ec 04             	sub    $0x4,%esp
  80164f:	68 07 04 00 00       	push   $0x407
  801654:	ff 75 f4             	pushl  -0xc(%ebp)
  801657:	6a 00                	push   $0x0
  801659:	e8 af f4 ff ff       	call   800b0d <sys_page_alloc>
  80165e:	83 c4 10             	add    $0x10,%esp
  801661:	89 c2                	mov    %eax,%edx
  801663:	85 c0                	test   %eax,%eax
  801665:	0f 88 0d 01 00 00    	js     801778 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80166b:	83 ec 0c             	sub    $0xc,%esp
  80166e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801671:	50                   	push   %eax
  801672:	e8 db f5 ff ff       	call   800c52 <fd_alloc>
  801677:	89 c3                	mov    %eax,%ebx
  801679:	83 c4 10             	add    $0x10,%esp
  80167c:	85 c0                	test   %eax,%eax
  80167e:	0f 88 e2 00 00 00    	js     801766 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801684:	83 ec 04             	sub    $0x4,%esp
  801687:	68 07 04 00 00       	push   $0x407
  80168c:	ff 75 f0             	pushl  -0x10(%ebp)
  80168f:	6a 00                	push   $0x0
  801691:	e8 77 f4 ff ff       	call   800b0d <sys_page_alloc>
  801696:	89 c3                	mov    %eax,%ebx
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	85 c0                	test   %eax,%eax
  80169d:	0f 88 c3 00 00 00    	js     801766 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8016a3:	83 ec 0c             	sub    $0xc,%esp
  8016a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8016a9:	e8 8c f5 ff ff       	call   800c3a <fd2data>
  8016ae:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8016b0:	83 c4 0c             	add    $0xc,%esp
  8016b3:	68 07 04 00 00       	push   $0x407
  8016b8:	50                   	push   %eax
  8016b9:	6a 00                	push   $0x0
  8016bb:	e8 4d f4 ff ff       	call   800b0d <sys_page_alloc>
  8016c0:	89 c3                	mov    %eax,%ebx
  8016c2:	83 c4 10             	add    $0x10,%esp
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	0f 88 89 00 00 00    	js     801756 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8016cd:	83 ec 0c             	sub    $0xc,%esp
  8016d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8016d3:	e8 62 f5 ff ff       	call   800c3a <fd2data>
  8016d8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8016df:	50                   	push   %eax
  8016e0:	6a 00                	push   $0x0
  8016e2:	56                   	push   %esi
  8016e3:	6a 00                	push   $0x0
  8016e5:	e8 47 f4 ff ff       	call   800b31 <sys_page_map>
  8016ea:	89 c3                	mov    %eax,%ebx
  8016ec:	83 c4 20             	add    $0x20,%esp
  8016ef:	85 c0                	test   %eax,%eax
  8016f1:	78 55                	js     801748 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8016f3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8016f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016fc:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8016fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801701:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801708:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80170e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801711:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801716:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80171d:	83 ec 0c             	sub    $0xc,%esp
  801720:	ff 75 f4             	pushl  -0xc(%ebp)
  801723:	e8 02 f5 ff ff       	call   800c2a <fd2num>
  801728:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80172b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80172d:	83 c4 04             	add    $0x4,%esp
  801730:	ff 75 f0             	pushl  -0x10(%ebp)
  801733:	e8 f2 f4 ff ff       	call   800c2a <fd2num>
  801738:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80173b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80173e:	83 c4 10             	add    $0x10,%esp
  801741:	ba 00 00 00 00       	mov    $0x0,%edx
  801746:	eb 30                	jmp    801778 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801748:	83 ec 08             	sub    $0x8,%esp
  80174b:	56                   	push   %esi
  80174c:	6a 00                	push   $0x0
  80174e:	e8 04 f4 ff ff       	call   800b57 <sys_page_unmap>
  801753:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801756:	83 ec 08             	sub    $0x8,%esp
  801759:	ff 75 f0             	pushl  -0x10(%ebp)
  80175c:	6a 00                	push   $0x0
  80175e:	e8 f4 f3 ff ff       	call   800b57 <sys_page_unmap>
  801763:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801766:	83 ec 08             	sub    $0x8,%esp
  801769:	ff 75 f4             	pushl  -0xc(%ebp)
  80176c:	6a 00                	push   $0x0
  80176e:	e8 e4 f3 ff ff       	call   800b57 <sys_page_unmap>
  801773:	83 c4 10             	add    $0x10,%esp
  801776:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  801778:	89 d0                	mov    %edx,%eax
  80177a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80177d:	5b                   	pop    %ebx
  80177e:	5e                   	pop    %esi
  80177f:	5d                   	pop    %ebp
  801780:	c3                   	ret    

00801781 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801787:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80178a:	50                   	push   %eax
  80178b:	ff 75 08             	pushl  0x8(%ebp)
  80178e:	e8 0e f5 ff ff       	call   800ca1 <fd_lookup>
  801793:	83 c4 10             	add    $0x10,%esp
  801796:	85 c0                	test   %eax,%eax
  801798:	78 18                	js     8017b2 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  80179a:	83 ec 0c             	sub    $0xc,%esp
  80179d:	ff 75 f4             	pushl  -0xc(%ebp)
  8017a0:	e8 95 f4 ff ff       	call   800c3a <fd2data>
	return _pipeisclosed(fd, p);
  8017a5:	89 c2                	mov    %eax,%edx
  8017a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017aa:	e8 21 fd ff ff       	call   8014d0 <_pipeisclosed>
  8017af:	83 c4 10             	add    $0x10,%esp
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8017b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017bc:	5d                   	pop    %ebp
  8017bd:	c3                   	ret    

008017be <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8017c4:	68 8a 21 80 00       	push   $0x80218a
  8017c9:	ff 75 0c             	pushl  0xc(%ebp)
  8017cc:	e8 f3 ee ff ff       	call   8006c4 <strcpy>
	return 0;
}
  8017d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	57                   	push   %edi
  8017dc:	56                   	push   %esi
  8017dd:	53                   	push   %ebx
  8017de:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8017e4:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8017e9:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8017ef:	eb 2d                	jmp    80181e <devcons_write+0x46>
		m = n - tot;
  8017f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8017f4:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  8017f6:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8017f9:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8017fe:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801801:	83 ec 04             	sub    $0x4,%esp
  801804:	53                   	push   %ebx
  801805:	03 45 0c             	add    0xc(%ebp),%eax
  801808:	50                   	push   %eax
  801809:	57                   	push   %edi
  80180a:	e8 48 f0 ff ff       	call   800857 <memmove>
		sys_cputs(buf, m);
  80180f:	83 c4 08             	add    $0x8,%esp
  801812:	53                   	push   %ebx
  801813:	57                   	push   %edi
  801814:	e8 3d f2 ff ff       	call   800a56 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801819:	01 de                	add    %ebx,%esi
  80181b:	83 c4 10             	add    $0x10,%esp
  80181e:	89 f0                	mov    %esi,%eax
  801820:	3b 75 10             	cmp    0x10(%ebp),%esi
  801823:	72 cc                	jb     8017f1 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801825:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801828:	5b                   	pop    %ebx
  801829:	5e                   	pop    %esi
  80182a:	5f                   	pop    %edi
  80182b:	5d                   	pop    %ebp
  80182c:	c3                   	ret    

0080182d <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	83 ec 08             	sub    $0x8,%esp
  801833:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801838:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80183c:	74 2a                	je     801868 <devcons_read+0x3b>
  80183e:	eb 05                	jmp    801845 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801840:	e8 a1 f2 ff ff       	call   800ae6 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801845:	e8 32 f2 ff ff       	call   800a7c <sys_cgetc>
  80184a:	85 c0                	test   %eax,%eax
  80184c:	74 f2                	je     801840 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  80184e:	85 c0                	test   %eax,%eax
  801850:	78 16                	js     801868 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801852:	83 f8 04             	cmp    $0x4,%eax
  801855:	74 0c                	je     801863 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801857:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185a:	88 02                	mov    %al,(%edx)
	return 1;
  80185c:	b8 01 00 00 00       	mov    $0x1,%eax
  801861:	eb 05                	jmp    801868 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801863:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
  80186d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801870:	8b 45 08             	mov    0x8(%ebp),%eax
  801873:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801876:	6a 01                	push   $0x1
  801878:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80187b:	50                   	push   %eax
  80187c:	e8 d5 f1 ff ff       	call   800a56 <sys_cputs>
}
  801881:	83 c4 10             	add    $0x10,%esp
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <getchar>:

int
getchar(void)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80188c:	6a 01                	push   $0x1
  80188e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801891:	50                   	push   %eax
  801892:	6a 00                	push   $0x0
  801894:	e8 6d f6 ff ff       	call   800f06 <read>
	if (r < 0)
  801899:	83 c4 10             	add    $0x10,%esp
  80189c:	85 c0                	test   %eax,%eax
  80189e:	78 0f                	js     8018af <getchar+0x29>
		return r;
	if (r < 1)
  8018a0:	85 c0                	test   %eax,%eax
  8018a2:	7e 06                	jle    8018aa <getchar+0x24>
		return -E_EOF;
	return c;
  8018a4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8018a8:	eb 05                	jmp    8018af <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8018aa:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
  8018b4:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ba:	50                   	push   %eax
  8018bb:	ff 75 08             	pushl  0x8(%ebp)
  8018be:	e8 de f3 ff ff       	call   800ca1 <fd_lookup>
  8018c3:	83 c4 10             	add    $0x10,%esp
  8018c6:	85 c0                	test   %eax,%eax
  8018c8:	78 11                	js     8018db <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8018ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018cd:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8018d3:	39 10                	cmp    %edx,(%eax)
  8018d5:	0f 94 c0             	sete   %al
  8018d8:	0f b6 c0             	movzbl %al,%eax
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <opencons>:

int
opencons(void)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8018e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e6:	50                   	push   %eax
  8018e7:	e8 66 f3 ff ff       	call   800c52 <fd_alloc>
  8018ec:	83 c4 10             	add    $0x10,%esp
		return r;
  8018ef:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8018f1:	85 c0                	test   %eax,%eax
  8018f3:	78 3e                	js     801933 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8018f5:	83 ec 04             	sub    $0x4,%esp
  8018f8:	68 07 04 00 00       	push   $0x407
  8018fd:	ff 75 f4             	pushl  -0xc(%ebp)
  801900:	6a 00                	push   $0x0
  801902:	e8 06 f2 ff ff       	call   800b0d <sys_page_alloc>
  801907:	83 c4 10             	add    $0x10,%esp
		return r;
  80190a:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80190c:	85 c0                	test   %eax,%eax
  80190e:	78 23                	js     801933 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801910:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801919:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80191b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801925:	83 ec 0c             	sub    $0xc,%esp
  801928:	50                   	push   %eax
  801929:	e8 fc f2 ff ff       	call   800c2a <fd2num>
  80192e:	89 c2                	mov    %eax,%edx
  801930:	83 c4 10             	add    $0x10,%esp
}
  801933:	89 d0                	mov    %edx,%eax
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
  80193a:	56                   	push   %esi
  80193b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80193c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80193f:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801945:	e8 78 f1 ff ff       	call   800ac2 <sys_getenvid>
  80194a:	83 ec 0c             	sub    $0xc,%esp
  80194d:	ff 75 0c             	pushl  0xc(%ebp)
  801950:	ff 75 08             	pushl  0x8(%ebp)
  801953:	56                   	push   %esi
  801954:	50                   	push   %eax
  801955:	68 98 21 80 00       	push   $0x802198
  80195a:	e8 f3 e7 ff ff       	call   800152 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80195f:	83 c4 18             	add    $0x18,%esp
  801962:	53                   	push   %ebx
  801963:	ff 75 10             	pushl  0x10(%ebp)
  801966:	e8 96 e7 ff ff       	call   800101 <vcprintf>
	cprintf("\n");
  80196b:	c7 04 24 83 21 80 00 	movl   $0x802183,(%esp)
  801972:	e8 db e7 ff ff       	call   800152 <cprintf>
  801977:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80197a:	cc                   	int3   
  80197b:	eb fd                	jmp    80197a <_panic+0x43>

0080197d <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	56                   	push   %esi
  801981:	53                   	push   %ebx
  801982:	8b 75 08             	mov    0x8(%ebp),%esi
  801985:	8b 45 0c             	mov    0xc(%ebp),%eax
  801988:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  80198b:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  80198d:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801992:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801995:	83 ec 0c             	sub    $0xc,%esp
  801998:	50                   	push   %eax
  801999:	e8 6a f2 ff ff       	call   800c08 <sys_ipc_recv>
	if (from_env_store)
  80199e:	83 c4 10             	add    $0x10,%esp
  8019a1:	85 f6                	test   %esi,%esi
  8019a3:	74 0b                	je     8019b0 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  8019a5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019ab:	8b 52 74             	mov    0x74(%edx),%edx
  8019ae:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8019b0:	85 db                	test   %ebx,%ebx
  8019b2:	74 0b                	je     8019bf <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  8019b4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019ba:	8b 52 78             	mov    0x78(%edx),%edx
  8019bd:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  8019bf:	85 c0                	test   %eax,%eax
  8019c1:	79 16                	jns    8019d9 <ipc_recv+0x5c>
		if (from_env_store)
  8019c3:	85 f6                	test   %esi,%esi
  8019c5:	74 06                	je     8019cd <ipc_recv+0x50>
			*from_env_store = 0;
  8019c7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  8019cd:	85 db                	test   %ebx,%ebx
  8019cf:	74 10                	je     8019e1 <ipc_recv+0x64>
			*perm_store = 0;
  8019d1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8019d7:	eb 08                	jmp    8019e1 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  8019d9:	a1 04 40 80 00       	mov    0x804004,%eax
  8019de:	8b 40 70             	mov    0x70(%eax),%eax
}
  8019e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019e4:	5b                   	pop    %ebx
  8019e5:	5e                   	pop    %esi
  8019e6:	5d                   	pop    %ebp
  8019e7:	c3                   	ret    

008019e8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	57                   	push   %edi
  8019ec:	56                   	push   %esi
  8019ed:	53                   	push   %ebx
  8019ee:	83 ec 0c             	sub    $0xc,%esp
  8019f1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019f4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  8019fa:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  8019fc:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801a01:	0f 44 d8             	cmove  %eax,%ebx
  801a04:	eb 1c                	jmp    801a22 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  801a06:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801a09:	74 12                	je     801a1d <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801a0b:	50                   	push   %eax
  801a0c:	68 bc 21 80 00       	push   $0x8021bc
  801a11:	6a 42                	push   $0x42
  801a13:	68 d2 21 80 00       	push   $0x8021d2
  801a18:	e8 1a ff ff ff       	call   801937 <_panic>
		sys_yield();
  801a1d:	e8 c4 f0 ff ff       	call   800ae6 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801a22:	ff 75 14             	pushl  0x14(%ebp)
  801a25:	53                   	push   %ebx
  801a26:	56                   	push   %esi
  801a27:	57                   	push   %edi
  801a28:	e8 b6 f1 ff ff       	call   800be3 <sys_ipc_try_send>
  801a2d:	83 c4 10             	add    $0x10,%esp
  801a30:	85 c0                	test   %eax,%eax
  801a32:	75 d2                	jne    801a06 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801a34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a37:	5b                   	pop    %ebx
  801a38:	5e                   	pop    %esi
  801a39:	5f                   	pop    %edi
  801a3a:	5d                   	pop    %ebp
  801a3b:	c3                   	ret    

00801a3c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
  801a3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801a42:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801a47:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801a4a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801a50:	8b 52 50             	mov    0x50(%edx),%edx
  801a53:	39 ca                	cmp    %ecx,%edx
  801a55:	75 0d                	jne    801a64 <ipc_find_env+0x28>
			return envs[i].env_id;
  801a57:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a5a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a5f:	8b 40 48             	mov    0x48(%eax),%eax
  801a62:	eb 0f                	jmp    801a73 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801a64:	83 c0 01             	add    $0x1,%eax
  801a67:	3d 00 04 00 00       	cmp    $0x400,%eax
  801a6c:	75 d9                	jne    801a47 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801a6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a73:	5d                   	pop    %ebp
  801a74:	c3                   	ret    

00801a75 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
  801a78:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a7b:	89 d0                	mov    %edx,%eax
  801a7d:	c1 e8 16             	shr    $0x16,%eax
  801a80:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801a87:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a8c:	f6 c1 01             	test   $0x1,%cl
  801a8f:	74 1d                	je     801aae <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801a91:	c1 ea 0c             	shr    $0xc,%edx
  801a94:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801a9b:	f6 c2 01             	test   $0x1,%dl
  801a9e:	74 0e                	je     801aae <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801aa0:	c1 ea 0c             	shr    $0xc,%edx
  801aa3:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801aaa:	ef 
  801aab:	0f b7 c0             	movzwl %ax,%eax
}
  801aae:	5d                   	pop    %ebp
  801aaf:	c3                   	ret    

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
