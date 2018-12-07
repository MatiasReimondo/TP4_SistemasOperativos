
obj/user/faultdie.debug:     formato del fichero elf32-i386


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
  80002c:	e8 4f 00 00 00       	call   800080 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
  800039:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  80003c:	8b 42 04             	mov    0x4(%edx),%eax
  80003f:	83 e0 07             	and    $0x7,%eax
  800042:	50                   	push   %eax
  800043:	ff 32                	pushl  (%edx)
  800045:	68 00 1e 80 00       	push   $0x801e00
  80004a:	e8 28 01 00 00       	call   800177 <cprintf>
	sys_env_destroy(sys_getenvid());
  80004f:	e8 93 0a 00 00       	call   800ae7 <sys_getenvid>
  800054:	89 04 24             	mov    %eax,(%esp)
  800057:	e8 69 0a 00 00       	call   800ac5 <sys_env_destroy>
}
  80005c:	83 c4 10             	add    $0x10,%esp
  80005f:	c9                   	leave  
  800060:	c3                   	ret    

00800061 <umain>:

void
umain(int argc, char **argv)
{
  800061:	55                   	push   %ebp
  800062:	89 e5                	mov    %esp,%ebp
  800064:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800067:	68 33 00 80 00       	push   $0x800033
  80006c:	e8 de 0b 00 00       	call   800c4f <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  800071:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  800078:	00 00 00 
}
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	c9                   	leave  
  80007f:	c3                   	ret    

00800080 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800080:	55                   	push   %ebp
  800081:	89 e5                	mov    %esp,%ebp
  800083:	56                   	push   %esi
  800084:	53                   	push   %ebx
  800085:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800088:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  80008b:	e8 57 0a 00 00       	call   800ae7 <sys_getenvid>
	if (id >= 0)
  800090:	85 c0                	test   %eax,%eax
  800092:	78 12                	js     8000a6 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  800094:	25 ff 03 00 00       	and    $0x3ff,%eax
  800099:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80009c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000a1:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a6:	85 db                	test   %ebx,%ebx
  8000a8:	7e 07                	jle    8000b1 <libmain+0x31>
		binaryname = argv[0];
  8000aa:	8b 06                	mov    (%esi),%eax
  8000ac:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000b1:	83 ec 08             	sub    $0x8,%esp
  8000b4:	56                   	push   %esi
  8000b5:	53                   	push   %ebx
  8000b6:	e8 a6 ff ff ff       	call   800061 <umain>

	// exit gracefully
	exit();
  8000bb:	e8 0a 00 00 00       	call   8000ca <exit>
}
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c6:	5b                   	pop    %ebx
  8000c7:	5e                   	pop    %esi
  8000c8:	5d                   	pop    %ebp
  8000c9:	c3                   	ret    

008000ca <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ca:	55                   	push   %ebp
  8000cb:	89 e5                	mov    %esp,%ebp
  8000cd:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000d0:	e8 d8 0d 00 00       	call   800ead <close_all>
	sys_env_destroy(0);
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	6a 00                	push   $0x0
  8000da:	e8 e6 09 00 00       	call   800ac5 <sys_env_destroy>
}
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	c9                   	leave  
  8000e3:	c3                   	ret    

008000e4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	53                   	push   %ebx
  8000e8:	83 ec 04             	sub    $0x4,%esp
  8000eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000ee:	8b 13                	mov    (%ebx),%edx
  8000f0:	8d 42 01             	lea    0x1(%edx),%eax
  8000f3:	89 03                	mov    %eax,(%ebx)
  8000f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000f8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000fc:	3d ff 00 00 00       	cmp    $0xff,%eax
  800101:	75 1a                	jne    80011d <putch+0x39>
		sys_cputs(b->buf, b->idx);
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	68 ff 00 00 00       	push   $0xff
  80010b:	8d 43 08             	lea    0x8(%ebx),%eax
  80010e:	50                   	push   %eax
  80010f:	e8 67 09 00 00       	call   800a7b <sys_cputs>
		b->idx = 0;
  800114:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80011a:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  80011d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800121:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800124:	c9                   	leave  
  800125:	c3                   	ret    

00800126 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800126:	55                   	push   %ebp
  800127:	89 e5                	mov    %esp,%ebp
  800129:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80012f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800136:	00 00 00 
	b.cnt = 0;
  800139:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800140:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800143:	ff 75 0c             	pushl  0xc(%ebp)
  800146:	ff 75 08             	pushl  0x8(%ebp)
  800149:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80014f:	50                   	push   %eax
  800150:	68 e4 00 80 00       	push   $0x8000e4
  800155:	e8 86 01 00 00       	call   8002e0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80015a:	83 c4 08             	add    $0x8,%esp
  80015d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800163:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800169:	50                   	push   %eax
  80016a:	e8 0c 09 00 00       	call   800a7b <sys_cputs>

	return b.cnt;
}
  80016f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800175:	c9                   	leave  
  800176:	c3                   	ret    

00800177 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800177:	55                   	push   %ebp
  800178:	89 e5                	mov    %esp,%ebp
  80017a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80017d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800180:	50                   	push   %eax
  800181:	ff 75 08             	pushl  0x8(%ebp)
  800184:	e8 9d ff ff ff       	call   800126 <vcprintf>
	va_end(ap);

	return cnt;
}
  800189:	c9                   	leave  
  80018a:	c3                   	ret    

0080018b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80018b:	55                   	push   %ebp
  80018c:	89 e5                	mov    %esp,%ebp
  80018e:	57                   	push   %edi
  80018f:	56                   	push   %esi
  800190:	53                   	push   %ebx
  800191:	83 ec 1c             	sub    $0x1c,%esp
  800194:	89 c7                	mov    %eax,%edi
  800196:	89 d6                	mov    %edx,%esi
  800198:	8b 45 08             	mov    0x8(%ebp),%eax
  80019b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80019e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001ac:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001af:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001b2:	39 d3                	cmp    %edx,%ebx
  8001b4:	72 05                	jb     8001bb <printnum+0x30>
  8001b6:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001b9:	77 45                	ja     800200 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001bb:	83 ec 0c             	sub    $0xc,%esp
  8001be:	ff 75 18             	pushl  0x18(%ebp)
  8001c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8001c4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001c7:	53                   	push   %ebx
  8001c8:	ff 75 10             	pushl  0x10(%ebp)
  8001cb:	83 ec 08             	sub    $0x8,%esp
  8001ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d1:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d4:	ff 75 dc             	pushl  -0x24(%ebp)
  8001d7:	ff 75 d8             	pushl  -0x28(%ebp)
  8001da:	e8 91 19 00 00       	call   801b70 <__udivdi3>
  8001df:	83 c4 18             	add    $0x18,%esp
  8001e2:	52                   	push   %edx
  8001e3:	50                   	push   %eax
  8001e4:	89 f2                	mov    %esi,%edx
  8001e6:	89 f8                	mov    %edi,%eax
  8001e8:	e8 9e ff ff ff       	call   80018b <printnum>
  8001ed:	83 c4 20             	add    $0x20,%esp
  8001f0:	eb 18                	jmp    80020a <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001f2:	83 ec 08             	sub    $0x8,%esp
  8001f5:	56                   	push   %esi
  8001f6:	ff 75 18             	pushl  0x18(%ebp)
  8001f9:	ff d7                	call   *%edi
  8001fb:	83 c4 10             	add    $0x10,%esp
  8001fe:	eb 03                	jmp    800203 <printnum+0x78>
  800200:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800203:	83 eb 01             	sub    $0x1,%ebx
  800206:	85 db                	test   %ebx,%ebx
  800208:	7f e8                	jg     8001f2 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80020a:	83 ec 08             	sub    $0x8,%esp
  80020d:	56                   	push   %esi
  80020e:	83 ec 04             	sub    $0x4,%esp
  800211:	ff 75 e4             	pushl  -0x1c(%ebp)
  800214:	ff 75 e0             	pushl  -0x20(%ebp)
  800217:	ff 75 dc             	pushl  -0x24(%ebp)
  80021a:	ff 75 d8             	pushl  -0x28(%ebp)
  80021d:	e8 7e 1a 00 00       	call   801ca0 <__umoddi3>
  800222:	83 c4 14             	add    $0x14,%esp
  800225:	0f be 80 26 1e 80 00 	movsbl 0x801e26(%eax),%eax
  80022c:	50                   	push   %eax
  80022d:	ff d7                	call   *%edi
}
  80022f:	83 c4 10             	add    $0x10,%esp
  800232:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800235:	5b                   	pop    %ebx
  800236:	5e                   	pop    %esi
  800237:	5f                   	pop    %edi
  800238:	5d                   	pop    %ebp
  800239:	c3                   	ret    

0080023a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80023d:	83 fa 01             	cmp    $0x1,%edx
  800240:	7e 0e                	jle    800250 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800242:	8b 10                	mov    (%eax),%edx
  800244:	8d 4a 08             	lea    0x8(%edx),%ecx
  800247:	89 08                	mov    %ecx,(%eax)
  800249:	8b 02                	mov    (%edx),%eax
  80024b:	8b 52 04             	mov    0x4(%edx),%edx
  80024e:	eb 22                	jmp    800272 <getuint+0x38>
	else if (lflag)
  800250:	85 d2                	test   %edx,%edx
  800252:	74 10                	je     800264 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800254:	8b 10                	mov    (%eax),%edx
  800256:	8d 4a 04             	lea    0x4(%edx),%ecx
  800259:	89 08                	mov    %ecx,(%eax)
  80025b:	8b 02                	mov    (%edx),%eax
  80025d:	ba 00 00 00 00       	mov    $0x0,%edx
  800262:	eb 0e                	jmp    800272 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800264:	8b 10                	mov    (%eax),%edx
  800266:	8d 4a 04             	lea    0x4(%edx),%ecx
  800269:	89 08                	mov    %ecx,(%eax)
  80026b:	8b 02                	mov    (%edx),%eax
  80026d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800272:	5d                   	pop    %ebp
  800273:	c3                   	ret    

00800274 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800277:	83 fa 01             	cmp    $0x1,%edx
  80027a:	7e 0e                	jle    80028a <getint+0x16>
		return va_arg(*ap, long long);
  80027c:	8b 10                	mov    (%eax),%edx
  80027e:	8d 4a 08             	lea    0x8(%edx),%ecx
  800281:	89 08                	mov    %ecx,(%eax)
  800283:	8b 02                	mov    (%edx),%eax
  800285:	8b 52 04             	mov    0x4(%edx),%edx
  800288:	eb 1a                	jmp    8002a4 <getint+0x30>
	else if (lflag)
  80028a:	85 d2                	test   %edx,%edx
  80028c:	74 0c                	je     80029a <getint+0x26>
		return va_arg(*ap, long);
  80028e:	8b 10                	mov    (%eax),%edx
  800290:	8d 4a 04             	lea    0x4(%edx),%ecx
  800293:	89 08                	mov    %ecx,(%eax)
  800295:	8b 02                	mov    (%edx),%eax
  800297:	99                   	cltd   
  800298:	eb 0a                	jmp    8002a4 <getint+0x30>
	else
		return va_arg(*ap, int);
  80029a:	8b 10                	mov    (%eax),%edx
  80029c:	8d 4a 04             	lea    0x4(%edx),%ecx
  80029f:	89 08                	mov    %ecx,(%eax)
  8002a1:	8b 02                	mov    (%edx),%eax
  8002a3:	99                   	cltd   
}
  8002a4:	5d                   	pop    %ebp
  8002a5:	c3                   	ret    

008002a6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002a6:	55                   	push   %ebp
  8002a7:	89 e5                	mov    %esp,%ebp
  8002a9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ac:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002b0:	8b 10                	mov    (%eax),%edx
  8002b2:	3b 50 04             	cmp    0x4(%eax),%edx
  8002b5:	73 0a                	jae    8002c1 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002ba:	89 08                	mov    %ecx,(%eax)
  8002bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bf:	88 02                	mov    %al,(%edx)
}
  8002c1:	5d                   	pop    %ebp
  8002c2:	c3                   	ret    

008002c3 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8002c3:	55                   	push   %ebp
  8002c4:	89 e5                	mov    %esp,%ebp
  8002c6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8002c9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002cc:	50                   	push   %eax
  8002cd:	ff 75 10             	pushl  0x10(%ebp)
  8002d0:	ff 75 0c             	pushl  0xc(%ebp)
  8002d3:	ff 75 08             	pushl  0x8(%ebp)
  8002d6:	e8 05 00 00 00       	call   8002e0 <vprintfmt>
	va_end(ap);
}
  8002db:	83 c4 10             	add    $0x10,%esp
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	57                   	push   %edi
  8002e4:	56                   	push   %esi
  8002e5:	53                   	push   %ebx
  8002e6:	83 ec 2c             	sub    $0x2c,%esp
  8002e9:	8b 75 08             	mov    0x8(%ebp),%esi
  8002ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002ef:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002f2:	eb 12                	jmp    800306 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8002f4:	85 c0                	test   %eax,%eax
  8002f6:	0f 84 44 03 00 00    	je     800640 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  8002fc:	83 ec 08             	sub    $0x8,%esp
  8002ff:	53                   	push   %ebx
  800300:	50                   	push   %eax
  800301:	ff d6                	call   *%esi
  800303:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800306:	83 c7 01             	add    $0x1,%edi
  800309:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80030d:	83 f8 25             	cmp    $0x25,%eax
  800310:	75 e2                	jne    8002f4 <vprintfmt+0x14>
  800312:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800316:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80031d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800324:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80032b:	ba 00 00 00 00       	mov    $0x0,%edx
  800330:	eb 07                	jmp    800339 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800332:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800335:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800339:	8d 47 01             	lea    0x1(%edi),%eax
  80033c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80033f:	0f b6 07             	movzbl (%edi),%eax
  800342:	0f b6 c8             	movzbl %al,%ecx
  800345:	83 e8 23             	sub    $0x23,%eax
  800348:	3c 55                	cmp    $0x55,%al
  80034a:	0f 87 d5 02 00 00    	ja     800625 <vprintfmt+0x345>
  800350:	0f b6 c0             	movzbl %al,%eax
  800353:	ff 24 85 60 1f 80 00 	jmp    *0x801f60(,%eax,4)
  80035a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80035d:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800361:	eb d6                	jmp    800339 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800363:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800366:	b8 00 00 00 00       	mov    $0x0,%eax
  80036b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80036e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800371:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  800375:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  800378:	8d 51 d0             	lea    -0x30(%ecx),%edx
  80037b:	83 fa 09             	cmp    $0x9,%edx
  80037e:	77 39                	ja     8003b9 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800380:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800383:	eb e9                	jmp    80036e <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800385:	8b 45 14             	mov    0x14(%ebp),%eax
  800388:	8d 48 04             	lea    0x4(%eax),%ecx
  80038b:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80038e:	8b 00                	mov    (%eax),%eax
  800390:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800393:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800396:	eb 27                	jmp    8003bf <vprintfmt+0xdf>
  800398:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80039b:	85 c0                	test   %eax,%eax
  80039d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003a2:	0f 49 c8             	cmovns %eax,%ecx
  8003a5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003ab:	eb 8c                	jmp    800339 <vprintfmt+0x59>
  8003ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8003b0:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003b7:	eb 80                	jmp    800339 <vprintfmt+0x59>
  8003b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003bc:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  8003bf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c3:	0f 89 70 ff ff ff    	jns    800339 <vprintfmt+0x59>
				width = precision, precision = -1;
  8003c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003cf:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003d6:	e9 5e ff ff ff       	jmp    800339 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003db:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8003e1:	e9 53 ff ff ff       	jmp    800339 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e9:	8d 50 04             	lea    0x4(%eax),%edx
  8003ec:	89 55 14             	mov    %edx,0x14(%ebp)
  8003ef:	83 ec 08             	sub    $0x8,%esp
  8003f2:	53                   	push   %ebx
  8003f3:	ff 30                	pushl  (%eax)
  8003f5:	ff d6                	call   *%esi
			break;
  8003f7:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  8003fd:	e9 04 ff ff ff       	jmp    800306 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800402:	8b 45 14             	mov    0x14(%ebp),%eax
  800405:	8d 50 04             	lea    0x4(%eax),%edx
  800408:	89 55 14             	mov    %edx,0x14(%ebp)
  80040b:	8b 00                	mov    (%eax),%eax
  80040d:	99                   	cltd   
  80040e:	31 d0                	xor    %edx,%eax
  800410:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800412:	83 f8 0f             	cmp    $0xf,%eax
  800415:	7f 0b                	jg     800422 <vprintfmt+0x142>
  800417:	8b 14 85 c0 20 80 00 	mov    0x8020c0(,%eax,4),%edx
  80041e:	85 d2                	test   %edx,%edx
  800420:	75 18                	jne    80043a <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  800422:	50                   	push   %eax
  800423:	68 3e 1e 80 00       	push   $0x801e3e
  800428:	53                   	push   %ebx
  800429:	56                   	push   %esi
  80042a:	e8 94 fe ff ff       	call   8002c3 <printfmt>
  80042f:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800432:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800435:	e9 cc fe ff ff       	jmp    800306 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  80043a:	52                   	push   %edx
  80043b:	68 69 22 80 00       	push   $0x802269
  800440:	53                   	push   %ebx
  800441:	56                   	push   %esi
  800442:	e8 7c fe ff ff       	call   8002c3 <printfmt>
  800447:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80044a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80044d:	e9 b4 fe ff ff       	jmp    800306 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800452:	8b 45 14             	mov    0x14(%ebp),%eax
  800455:	8d 50 04             	lea    0x4(%eax),%edx
  800458:	89 55 14             	mov    %edx,0x14(%ebp)
  80045b:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80045d:	85 ff                	test   %edi,%edi
  80045f:	b8 37 1e 80 00       	mov    $0x801e37,%eax
  800464:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800467:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80046b:	0f 8e 94 00 00 00    	jle    800505 <vprintfmt+0x225>
  800471:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800475:	0f 84 98 00 00 00    	je     800513 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	ff 75 d0             	pushl  -0x30(%ebp)
  800481:	57                   	push   %edi
  800482:	e8 41 02 00 00       	call   8006c8 <strnlen>
  800487:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80048a:	29 c1                	sub    %eax,%ecx
  80048c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80048f:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800492:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800496:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800499:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80049c:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80049e:	eb 0f                	jmp    8004af <vprintfmt+0x1cf>
					putch(padc, putdat);
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	53                   	push   %ebx
  8004a4:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a7:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a9:	83 ef 01             	sub    $0x1,%edi
  8004ac:	83 c4 10             	add    $0x10,%esp
  8004af:	85 ff                	test   %edi,%edi
  8004b1:	7f ed                	jg     8004a0 <vprintfmt+0x1c0>
  8004b3:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004b6:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8004b9:	85 c9                	test   %ecx,%ecx
  8004bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c0:	0f 49 c1             	cmovns %ecx,%eax
  8004c3:	29 c1                	sub    %eax,%ecx
  8004c5:	89 75 08             	mov    %esi,0x8(%ebp)
  8004c8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004cb:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004ce:	89 cb                	mov    %ecx,%ebx
  8004d0:	eb 4d                	jmp    80051f <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004d2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004d6:	74 1b                	je     8004f3 <vprintfmt+0x213>
  8004d8:	0f be c0             	movsbl %al,%eax
  8004db:	83 e8 20             	sub    $0x20,%eax
  8004de:	83 f8 5e             	cmp    $0x5e,%eax
  8004e1:	76 10                	jbe    8004f3 <vprintfmt+0x213>
					putch('?', putdat);
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	ff 75 0c             	pushl  0xc(%ebp)
  8004e9:	6a 3f                	push   $0x3f
  8004eb:	ff 55 08             	call   *0x8(%ebp)
  8004ee:	83 c4 10             	add    $0x10,%esp
  8004f1:	eb 0d                	jmp    800500 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	ff 75 0c             	pushl  0xc(%ebp)
  8004f9:	52                   	push   %edx
  8004fa:	ff 55 08             	call   *0x8(%ebp)
  8004fd:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800500:	83 eb 01             	sub    $0x1,%ebx
  800503:	eb 1a                	jmp    80051f <vprintfmt+0x23f>
  800505:	89 75 08             	mov    %esi,0x8(%ebp)
  800508:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80050b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80050e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800511:	eb 0c                	jmp    80051f <vprintfmt+0x23f>
  800513:	89 75 08             	mov    %esi,0x8(%ebp)
  800516:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800519:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80051c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80051f:	83 c7 01             	add    $0x1,%edi
  800522:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800526:	0f be d0             	movsbl %al,%edx
  800529:	85 d2                	test   %edx,%edx
  80052b:	74 23                	je     800550 <vprintfmt+0x270>
  80052d:	85 f6                	test   %esi,%esi
  80052f:	78 a1                	js     8004d2 <vprintfmt+0x1f2>
  800531:	83 ee 01             	sub    $0x1,%esi
  800534:	79 9c                	jns    8004d2 <vprintfmt+0x1f2>
  800536:	89 df                	mov    %ebx,%edi
  800538:	8b 75 08             	mov    0x8(%ebp),%esi
  80053b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80053e:	eb 18                	jmp    800558 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800540:	83 ec 08             	sub    $0x8,%esp
  800543:	53                   	push   %ebx
  800544:	6a 20                	push   $0x20
  800546:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800548:	83 ef 01             	sub    $0x1,%edi
  80054b:	83 c4 10             	add    $0x10,%esp
  80054e:	eb 08                	jmp    800558 <vprintfmt+0x278>
  800550:	89 df                	mov    %ebx,%edi
  800552:	8b 75 08             	mov    0x8(%ebp),%esi
  800555:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800558:	85 ff                	test   %edi,%edi
  80055a:	7f e4                	jg     800540 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80055c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80055f:	e9 a2 fd ff ff       	jmp    800306 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800564:	8d 45 14             	lea    0x14(%ebp),%eax
  800567:	e8 08 fd ff ff       	call   800274 <getint>
  80056c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800572:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800577:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80057b:	79 74                	jns    8005f1 <vprintfmt+0x311>
				putch('-', putdat);
  80057d:	83 ec 08             	sub    $0x8,%esp
  800580:	53                   	push   %ebx
  800581:	6a 2d                	push   $0x2d
  800583:	ff d6                	call   *%esi
				num = -(long long) num;
  800585:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800588:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80058b:	f7 d8                	neg    %eax
  80058d:	83 d2 00             	adc    $0x0,%edx
  800590:	f7 da                	neg    %edx
  800592:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  800595:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80059a:	eb 55                	jmp    8005f1 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80059c:	8d 45 14             	lea    0x14(%ebp),%eax
  80059f:	e8 96 fc ff ff       	call   80023a <getuint>
			base = 10;
  8005a4:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8005a9:	eb 46                	jmp    8005f1 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8005ab:	8d 45 14             	lea    0x14(%ebp),%eax
  8005ae:	e8 87 fc ff ff       	call   80023a <getuint>
			base = 8;
  8005b3:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8005b8:	eb 37                	jmp    8005f1 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  8005ba:	83 ec 08             	sub    $0x8,%esp
  8005bd:	53                   	push   %ebx
  8005be:	6a 30                	push   $0x30
  8005c0:	ff d6                	call   *%esi
			putch('x', putdat);
  8005c2:	83 c4 08             	add    $0x8,%esp
  8005c5:	53                   	push   %ebx
  8005c6:	6a 78                	push   $0x78
  8005c8:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	8d 50 04             	lea    0x4(%eax),%edx
  8005d0:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8005d3:	8b 00                	mov    (%eax),%eax
  8005d5:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8005da:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8005dd:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8005e2:	eb 0d                	jmp    8005f1 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8005e4:	8d 45 14             	lea    0x14(%ebp),%eax
  8005e7:	e8 4e fc ff ff       	call   80023a <getuint>
			base = 16;
  8005ec:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8005f1:	83 ec 0c             	sub    $0xc,%esp
  8005f4:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8005f8:	57                   	push   %edi
  8005f9:	ff 75 e0             	pushl  -0x20(%ebp)
  8005fc:	51                   	push   %ecx
  8005fd:	52                   	push   %edx
  8005fe:	50                   	push   %eax
  8005ff:	89 da                	mov    %ebx,%edx
  800601:	89 f0                	mov    %esi,%eax
  800603:	e8 83 fb ff ff       	call   80018b <printnum>
			break;
  800608:	83 c4 20             	add    $0x20,%esp
  80060b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80060e:	e9 f3 fc ff ff       	jmp    800306 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800613:	83 ec 08             	sub    $0x8,%esp
  800616:	53                   	push   %ebx
  800617:	51                   	push   %ecx
  800618:	ff d6                	call   *%esi
			break;
  80061a:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80061d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800620:	e9 e1 fc ff ff       	jmp    800306 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800625:	83 ec 08             	sub    $0x8,%esp
  800628:	53                   	push   %ebx
  800629:	6a 25                	push   $0x25
  80062b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80062d:	83 c4 10             	add    $0x10,%esp
  800630:	eb 03                	jmp    800635 <vprintfmt+0x355>
  800632:	83 ef 01             	sub    $0x1,%edi
  800635:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  800639:	75 f7                	jne    800632 <vprintfmt+0x352>
  80063b:	e9 c6 fc ff ff       	jmp    800306 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  800640:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800643:	5b                   	pop    %ebx
  800644:	5e                   	pop    %esi
  800645:	5f                   	pop    %edi
  800646:	5d                   	pop    %ebp
  800647:	c3                   	ret    

00800648 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800648:	55                   	push   %ebp
  800649:	89 e5                	mov    %esp,%ebp
  80064b:	83 ec 18             	sub    $0x18,%esp
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800654:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800657:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80065b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80065e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800665:	85 c0                	test   %eax,%eax
  800667:	74 26                	je     80068f <vsnprintf+0x47>
  800669:	85 d2                	test   %edx,%edx
  80066b:	7e 22                	jle    80068f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80066d:	ff 75 14             	pushl  0x14(%ebp)
  800670:	ff 75 10             	pushl  0x10(%ebp)
  800673:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800676:	50                   	push   %eax
  800677:	68 a6 02 80 00       	push   $0x8002a6
  80067c:	e8 5f fc ff ff       	call   8002e0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800684:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80068a:	83 c4 10             	add    $0x10,%esp
  80068d:	eb 05                	jmp    800694 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80068f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800694:	c9                   	leave  
  800695:	c3                   	ret    

00800696 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800696:	55                   	push   %ebp
  800697:	89 e5                	mov    %esp,%ebp
  800699:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80069c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80069f:	50                   	push   %eax
  8006a0:	ff 75 10             	pushl  0x10(%ebp)
  8006a3:	ff 75 0c             	pushl  0xc(%ebp)
  8006a6:	ff 75 08             	pushl  0x8(%ebp)
  8006a9:	e8 9a ff ff ff       	call   800648 <vsnprintf>
	va_end(ap);

	return rc;
}
  8006ae:	c9                   	leave  
  8006af:	c3                   	ret    

008006b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8006b0:	55                   	push   %ebp
  8006b1:	89 e5                	mov    %esp,%ebp
  8006b3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8006b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006bb:	eb 03                	jmp    8006c0 <strlen+0x10>
		n++;
  8006bd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8006c0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8006c4:	75 f7                	jne    8006bd <strlen+0xd>
		n++;
	return n;
}
  8006c6:	5d                   	pop    %ebp
  8006c7:	c3                   	ret    

008006c8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8006c8:	55                   	push   %ebp
  8006c9:	89 e5                	mov    %esp,%ebp
  8006cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006ce:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8006d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d6:	eb 03                	jmp    8006db <strnlen+0x13>
		n++;
  8006d8:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8006db:	39 c2                	cmp    %eax,%edx
  8006dd:	74 08                	je     8006e7 <strnlen+0x1f>
  8006df:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8006e3:	75 f3                	jne    8006d8 <strnlen+0x10>
  8006e5:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  8006e7:	5d                   	pop    %ebp
  8006e8:	c3                   	ret    

008006e9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	53                   	push   %ebx
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8006f3:	89 c2                	mov    %eax,%edx
  8006f5:	83 c2 01             	add    $0x1,%edx
  8006f8:	83 c1 01             	add    $0x1,%ecx
  8006fb:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8006ff:	88 5a ff             	mov    %bl,-0x1(%edx)
  800702:	84 db                	test   %bl,%bl
  800704:	75 ef                	jne    8006f5 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800706:	5b                   	pop    %ebx
  800707:	5d                   	pop    %ebp
  800708:	c3                   	ret    

00800709 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
  80070c:	53                   	push   %ebx
  80070d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800710:	53                   	push   %ebx
  800711:	e8 9a ff ff ff       	call   8006b0 <strlen>
  800716:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800719:	ff 75 0c             	pushl  0xc(%ebp)
  80071c:	01 d8                	add    %ebx,%eax
  80071e:	50                   	push   %eax
  80071f:	e8 c5 ff ff ff       	call   8006e9 <strcpy>
	return dst;
}
  800724:	89 d8                	mov    %ebx,%eax
  800726:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800729:	c9                   	leave  
  80072a:	c3                   	ret    

0080072b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	56                   	push   %esi
  80072f:	53                   	push   %ebx
  800730:	8b 75 08             	mov    0x8(%ebp),%esi
  800733:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800736:	89 f3                	mov    %esi,%ebx
  800738:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80073b:	89 f2                	mov    %esi,%edx
  80073d:	eb 0f                	jmp    80074e <strncpy+0x23>
		*dst++ = *src;
  80073f:	83 c2 01             	add    $0x1,%edx
  800742:	0f b6 01             	movzbl (%ecx),%eax
  800745:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800748:	80 39 01             	cmpb   $0x1,(%ecx)
  80074b:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80074e:	39 da                	cmp    %ebx,%edx
  800750:	75 ed                	jne    80073f <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800752:	89 f0                	mov    %esi,%eax
  800754:	5b                   	pop    %ebx
  800755:	5e                   	pop    %esi
  800756:	5d                   	pop    %ebp
  800757:	c3                   	ret    

00800758 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
  80075b:	56                   	push   %esi
  80075c:	53                   	push   %ebx
  80075d:	8b 75 08             	mov    0x8(%ebp),%esi
  800760:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800763:	8b 55 10             	mov    0x10(%ebp),%edx
  800766:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800768:	85 d2                	test   %edx,%edx
  80076a:	74 21                	je     80078d <strlcpy+0x35>
  80076c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800770:	89 f2                	mov    %esi,%edx
  800772:	eb 09                	jmp    80077d <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800774:	83 c2 01             	add    $0x1,%edx
  800777:	83 c1 01             	add    $0x1,%ecx
  80077a:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80077d:	39 c2                	cmp    %eax,%edx
  80077f:	74 09                	je     80078a <strlcpy+0x32>
  800781:	0f b6 19             	movzbl (%ecx),%ebx
  800784:	84 db                	test   %bl,%bl
  800786:	75 ec                	jne    800774 <strlcpy+0x1c>
  800788:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  80078a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80078d:	29 f0                	sub    %esi,%eax
}
  80078f:	5b                   	pop    %ebx
  800790:	5e                   	pop    %esi
  800791:	5d                   	pop    %ebp
  800792:	c3                   	ret    

00800793 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
  800796:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800799:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80079c:	eb 06                	jmp    8007a4 <strcmp+0x11>
		p++, q++;
  80079e:	83 c1 01             	add    $0x1,%ecx
  8007a1:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8007a4:	0f b6 01             	movzbl (%ecx),%eax
  8007a7:	84 c0                	test   %al,%al
  8007a9:	74 04                	je     8007af <strcmp+0x1c>
  8007ab:	3a 02                	cmp    (%edx),%al
  8007ad:	74 ef                	je     80079e <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8007af:	0f b6 c0             	movzbl %al,%eax
  8007b2:	0f b6 12             	movzbl (%edx),%edx
  8007b5:	29 d0                	sub    %edx,%eax
}
  8007b7:	5d                   	pop    %ebp
  8007b8:	c3                   	ret    

008007b9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8007b9:	55                   	push   %ebp
  8007ba:	89 e5                	mov    %esp,%ebp
  8007bc:	53                   	push   %ebx
  8007bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c3:	89 c3                	mov    %eax,%ebx
  8007c5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8007c8:	eb 06                	jmp    8007d0 <strncmp+0x17>
		n--, p++, q++;
  8007ca:	83 c0 01             	add    $0x1,%eax
  8007cd:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8007d0:	39 d8                	cmp    %ebx,%eax
  8007d2:	74 15                	je     8007e9 <strncmp+0x30>
  8007d4:	0f b6 08             	movzbl (%eax),%ecx
  8007d7:	84 c9                	test   %cl,%cl
  8007d9:	74 04                	je     8007df <strncmp+0x26>
  8007db:	3a 0a                	cmp    (%edx),%cl
  8007dd:	74 eb                	je     8007ca <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8007df:	0f b6 00             	movzbl (%eax),%eax
  8007e2:	0f b6 12             	movzbl (%edx),%edx
  8007e5:	29 d0                	sub    %edx,%eax
  8007e7:	eb 05                	jmp    8007ee <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8007e9:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8007ee:	5b                   	pop    %ebx
  8007ef:	5d                   	pop    %ebp
  8007f0:	c3                   	ret    

008007f1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8007f1:	55                   	push   %ebp
  8007f2:	89 e5                	mov    %esp,%ebp
  8007f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8007fb:	eb 07                	jmp    800804 <strchr+0x13>
		if (*s == c)
  8007fd:	38 ca                	cmp    %cl,%dl
  8007ff:	74 0f                	je     800810 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800801:	83 c0 01             	add    $0x1,%eax
  800804:	0f b6 10             	movzbl (%eax),%edx
  800807:	84 d2                	test   %dl,%dl
  800809:	75 f2                	jne    8007fd <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  80080b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800810:	5d                   	pop    %ebp
  800811:	c3                   	ret    

00800812 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80081c:	eb 03                	jmp    800821 <strfind+0xf>
  80081e:	83 c0 01             	add    $0x1,%eax
  800821:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800824:	38 ca                	cmp    %cl,%dl
  800826:	74 04                	je     80082c <strfind+0x1a>
  800828:	84 d2                	test   %dl,%dl
  80082a:	75 f2                	jne    80081e <strfind+0xc>
			break;
	return (char *) s;
}
  80082c:	5d                   	pop    %ebp
  80082d:	c3                   	ret    

0080082e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	57                   	push   %edi
  800832:	56                   	push   %esi
  800833:	53                   	push   %ebx
  800834:	8b 55 08             	mov    0x8(%ebp),%edx
  800837:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  80083a:	85 c9                	test   %ecx,%ecx
  80083c:	74 37                	je     800875 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80083e:	f6 c2 03             	test   $0x3,%dl
  800841:	75 2a                	jne    80086d <memset+0x3f>
  800843:	f6 c1 03             	test   $0x3,%cl
  800846:	75 25                	jne    80086d <memset+0x3f>
		c &= 0xFF;
  800848:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80084c:	89 df                	mov    %ebx,%edi
  80084e:	c1 e7 08             	shl    $0x8,%edi
  800851:	89 de                	mov    %ebx,%esi
  800853:	c1 e6 18             	shl    $0x18,%esi
  800856:	89 d8                	mov    %ebx,%eax
  800858:	c1 e0 10             	shl    $0x10,%eax
  80085b:	09 f0                	or     %esi,%eax
  80085d:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  80085f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800862:	89 f8                	mov    %edi,%eax
  800864:	09 d8                	or     %ebx,%eax
  800866:	89 d7                	mov    %edx,%edi
  800868:	fc                   	cld    
  800869:	f3 ab                	rep stos %eax,%es:(%edi)
  80086b:	eb 08                	jmp    800875 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80086d:	89 d7                	mov    %edx,%edi
  80086f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800872:	fc                   	cld    
  800873:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800875:	89 d0                	mov    %edx,%eax
  800877:	5b                   	pop    %ebx
  800878:	5e                   	pop    %esi
  800879:	5f                   	pop    %edi
  80087a:	5d                   	pop    %ebp
  80087b:	c3                   	ret    

0080087c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	57                   	push   %edi
  800880:	56                   	push   %esi
  800881:	8b 45 08             	mov    0x8(%ebp),%eax
  800884:	8b 75 0c             	mov    0xc(%ebp),%esi
  800887:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80088a:	39 c6                	cmp    %eax,%esi
  80088c:	73 35                	jae    8008c3 <memmove+0x47>
  80088e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800891:	39 d0                	cmp    %edx,%eax
  800893:	73 2e                	jae    8008c3 <memmove+0x47>
		s += n;
		d += n;
  800895:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800898:	89 d6                	mov    %edx,%esi
  80089a:	09 fe                	or     %edi,%esi
  80089c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008a2:	75 13                	jne    8008b7 <memmove+0x3b>
  8008a4:	f6 c1 03             	test   $0x3,%cl
  8008a7:	75 0e                	jne    8008b7 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  8008a9:	83 ef 04             	sub    $0x4,%edi
  8008ac:	8d 72 fc             	lea    -0x4(%edx),%esi
  8008af:	c1 e9 02             	shr    $0x2,%ecx
  8008b2:	fd                   	std    
  8008b3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008b5:	eb 09                	jmp    8008c0 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8008b7:	83 ef 01             	sub    $0x1,%edi
  8008ba:	8d 72 ff             	lea    -0x1(%edx),%esi
  8008bd:	fd                   	std    
  8008be:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8008c0:	fc                   	cld    
  8008c1:	eb 1d                	jmp    8008e0 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008c3:	89 f2                	mov    %esi,%edx
  8008c5:	09 c2                	or     %eax,%edx
  8008c7:	f6 c2 03             	test   $0x3,%dl
  8008ca:	75 0f                	jne    8008db <memmove+0x5f>
  8008cc:	f6 c1 03             	test   $0x3,%cl
  8008cf:	75 0a                	jne    8008db <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  8008d1:	c1 e9 02             	shr    $0x2,%ecx
  8008d4:	89 c7                	mov    %eax,%edi
  8008d6:	fc                   	cld    
  8008d7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008d9:	eb 05                	jmp    8008e0 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8008db:	89 c7                	mov    %eax,%edi
  8008dd:	fc                   	cld    
  8008de:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8008e0:	5e                   	pop    %esi
  8008e1:	5f                   	pop    %edi
  8008e2:	5d                   	pop    %ebp
  8008e3:	c3                   	ret    

008008e4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8008e7:	ff 75 10             	pushl  0x10(%ebp)
  8008ea:	ff 75 0c             	pushl  0xc(%ebp)
  8008ed:	ff 75 08             	pushl  0x8(%ebp)
  8008f0:	e8 87 ff ff ff       	call   80087c <memmove>
}
  8008f5:	c9                   	leave  
  8008f6:	c3                   	ret    

008008f7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8008f7:	55                   	push   %ebp
  8008f8:	89 e5                	mov    %esp,%ebp
  8008fa:	56                   	push   %esi
  8008fb:	53                   	push   %ebx
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800902:	89 c6                	mov    %eax,%esi
  800904:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800907:	eb 1a                	jmp    800923 <memcmp+0x2c>
		if (*s1 != *s2)
  800909:	0f b6 08             	movzbl (%eax),%ecx
  80090c:	0f b6 1a             	movzbl (%edx),%ebx
  80090f:	38 d9                	cmp    %bl,%cl
  800911:	74 0a                	je     80091d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800913:	0f b6 c1             	movzbl %cl,%eax
  800916:	0f b6 db             	movzbl %bl,%ebx
  800919:	29 d8                	sub    %ebx,%eax
  80091b:	eb 0f                	jmp    80092c <memcmp+0x35>
		s1++, s2++;
  80091d:	83 c0 01             	add    $0x1,%eax
  800920:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800923:	39 f0                	cmp    %esi,%eax
  800925:	75 e2                	jne    800909 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800927:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80092c:	5b                   	pop    %ebx
  80092d:	5e                   	pop    %esi
  80092e:	5d                   	pop    %ebp
  80092f:	c3                   	ret    

00800930 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	53                   	push   %ebx
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800937:	89 c1                	mov    %eax,%ecx
  800939:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  80093c:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800940:	eb 0a                	jmp    80094c <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800942:	0f b6 10             	movzbl (%eax),%edx
  800945:	39 da                	cmp    %ebx,%edx
  800947:	74 07                	je     800950 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800949:	83 c0 01             	add    $0x1,%eax
  80094c:	39 c8                	cmp    %ecx,%eax
  80094e:	72 f2                	jb     800942 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800950:	5b                   	pop    %ebx
  800951:	5d                   	pop    %ebp
  800952:	c3                   	ret    

00800953 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800953:	55                   	push   %ebp
  800954:	89 e5                	mov    %esp,%ebp
  800956:	57                   	push   %edi
  800957:	56                   	push   %esi
  800958:	53                   	push   %ebx
  800959:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80095c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80095f:	eb 03                	jmp    800964 <strtol+0x11>
		s++;
  800961:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800964:	0f b6 01             	movzbl (%ecx),%eax
  800967:	3c 20                	cmp    $0x20,%al
  800969:	74 f6                	je     800961 <strtol+0xe>
  80096b:	3c 09                	cmp    $0x9,%al
  80096d:	74 f2                	je     800961 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  80096f:	3c 2b                	cmp    $0x2b,%al
  800971:	75 0a                	jne    80097d <strtol+0x2a>
		s++;
  800973:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800976:	bf 00 00 00 00       	mov    $0x0,%edi
  80097b:	eb 11                	jmp    80098e <strtol+0x3b>
  80097d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800982:	3c 2d                	cmp    $0x2d,%al
  800984:	75 08                	jne    80098e <strtol+0x3b>
		s++, neg = 1;
  800986:	83 c1 01             	add    $0x1,%ecx
  800989:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80098e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800994:	75 15                	jne    8009ab <strtol+0x58>
  800996:	80 39 30             	cmpb   $0x30,(%ecx)
  800999:	75 10                	jne    8009ab <strtol+0x58>
  80099b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80099f:	75 7c                	jne    800a1d <strtol+0xca>
		s += 2, base = 16;
  8009a1:	83 c1 02             	add    $0x2,%ecx
  8009a4:	bb 10 00 00 00       	mov    $0x10,%ebx
  8009a9:	eb 16                	jmp    8009c1 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  8009ab:	85 db                	test   %ebx,%ebx
  8009ad:	75 12                	jne    8009c1 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009af:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009b4:	80 39 30             	cmpb   $0x30,(%ecx)
  8009b7:	75 08                	jne    8009c1 <strtol+0x6e>
		s++, base = 8;
  8009b9:	83 c1 01             	add    $0x1,%ecx
  8009bc:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  8009c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c6:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8009c9:	0f b6 11             	movzbl (%ecx),%edx
  8009cc:	8d 72 d0             	lea    -0x30(%edx),%esi
  8009cf:	89 f3                	mov    %esi,%ebx
  8009d1:	80 fb 09             	cmp    $0x9,%bl
  8009d4:	77 08                	ja     8009de <strtol+0x8b>
			dig = *s - '0';
  8009d6:	0f be d2             	movsbl %dl,%edx
  8009d9:	83 ea 30             	sub    $0x30,%edx
  8009dc:	eb 22                	jmp    800a00 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  8009de:	8d 72 9f             	lea    -0x61(%edx),%esi
  8009e1:	89 f3                	mov    %esi,%ebx
  8009e3:	80 fb 19             	cmp    $0x19,%bl
  8009e6:	77 08                	ja     8009f0 <strtol+0x9d>
			dig = *s - 'a' + 10;
  8009e8:	0f be d2             	movsbl %dl,%edx
  8009eb:	83 ea 57             	sub    $0x57,%edx
  8009ee:	eb 10                	jmp    800a00 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  8009f0:	8d 72 bf             	lea    -0x41(%edx),%esi
  8009f3:	89 f3                	mov    %esi,%ebx
  8009f5:	80 fb 19             	cmp    $0x19,%bl
  8009f8:	77 16                	ja     800a10 <strtol+0xbd>
			dig = *s - 'A' + 10;
  8009fa:	0f be d2             	movsbl %dl,%edx
  8009fd:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800a00:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a03:	7d 0b                	jge    800a10 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800a05:	83 c1 01             	add    $0x1,%ecx
  800a08:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a0c:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800a0e:	eb b9                	jmp    8009c9 <strtol+0x76>

	if (endptr)
  800a10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a14:	74 0d                	je     800a23 <strtol+0xd0>
		*endptr = (char *) s;
  800a16:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a19:	89 0e                	mov    %ecx,(%esi)
  800a1b:	eb 06                	jmp    800a23 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a1d:	85 db                	test   %ebx,%ebx
  800a1f:	74 98                	je     8009b9 <strtol+0x66>
  800a21:	eb 9e                	jmp    8009c1 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800a23:	89 c2                	mov    %eax,%edx
  800a25:	f7 da                	neg    %edx
  800a27:	85 ff                	test   %edi,%edi
  800a29:	0f 45 c2             	cmovne %edx,%eax
}
  800a2c:	5b                   	pop    %ebx
  800a2d:	5e                   	pop    %esi
  800a2e:	5f                   	pop    %edi
  800a2f:	5d                   	pop    %ebp
  800a30:	c3                   	ret    

00800a31 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800a31:	55                   	push   %ebp
  800a32:	89 e5                	mov    %esp,%ebp
  800a34:	57                   	push   %edi
  800a35:	56                   	push   %esi
  800a36:	53                   	push   %ebx
  800a37:	83 ec 1c             	sub    $0x1c,%esp
  800a3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a3d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a40:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800a42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a45:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a48:	8b 7d 10             	mov    0x10(%ebp),%edi
  800a4b:	8b 75 14             	mov    0x14(%ebp),%esi
  800a4e:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800a50:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a54:	74 1d                	je     800a73 <syscall+0x42>
  800a56:	85 c0                	test   %eax,%eax
  800a58:	7e 19                	jle    800a73 <syscall+0x42>
  800a5a:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800a5d:	83 ec 0c             	sub    $0xc,%esp
  800a60:	50                   	push   %eax
  800a61:	52                   	push   %edx
  800a62:	68 1f 21 80 00       	push   $0x80211f
  800a67:	6a 23                	push   $0x23
  800a69:	68 3c 21 80 00       	push   $0x80213c
  800a6e:	e8 7c 0f 00 00       	call   8019ef <_panic>

	return ret;
}
  800a73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a76:	5b                   	pop    %ebx
  800a77:	5e                   	pop    %esi
  800a78:	5f                   	pop    %edi
  800a79:	5d                   	pop    %ebp
  800a7a:	c3                   	ret    

00800a7b <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800a81:	6a 00                	push   $0x0
  800a83:	6a 00                	push   $0x0
  800a85:	6a 00                	push   $0x0
  800a87:	ff 75 0c             	pushl  0xc(%ebp)
  800a8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a92:	b8 00 00 00 00       	mov    $0x0,%eax
  800a97:	e8 95 ff ff ff       	call   800a31 <syscall>
}
  800a9c:	83 c4 10             	add    $0x10,%esp
  800a9f:	c9                   	leave  
  800aa0:	c3                   	ret    

00800aa1 <sys_cgetc>:

int
sys_cgetc(void)
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800aa7:	6a 00                	push   $0x0
  800aa9:	6a 00                	push   $0x0
  800aab:	6a 00                	push   $0x0
  800aad:	6a 00                	push   $0x0
  800aaf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ab4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab9:	b8 01 00 00 00       	mov    $0x1,%eax
  800abe:	e8 6e ff ff ff       	call   800a31 <syscall>
}
  800ac3:	c9                   	leave  
  800ac4:	c3                   	ret    

00800ac5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ac5:	55                   	push   %ebp
  800ac6:	89 e5                	mov    %esp,%ebp
  800ac8:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800acb:	6a 00                	push   $0x0
  800acd:	6a 00                	push   $0x0
  800acf:	6a 00                	push   $0x0
  800ad1:	6a 00                	push   $0x0
  800ad3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad6:	ba 01 00 00 00       	mov    $0x1,%edx
  800adb:	b8 03 00 00 00       	mov    $0x3,%eax
  800ae0:	e8 4c ff ff ff       	call   800a31 <syscall>
}
  800ae5:	c9                   	leave  
  800ae6:	c3                   	ret    

00800ae7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800aed:	6a 00                	push   $0x0
  800aef:	6a 00                	push   $0x0
  800af1:	6a 00                	push   $0x0
  800af3:	6a 00                	push   $0x0
  800af5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800afa:	ba 00 00 00 00       	mov    $0x0,%edx
  800aff:	b8 02 00 00 00       	mov    $0x2,%eax
  800b04:	e8 28 ff ff ff       	call   800a31 <syscall>
}
  800b09:	c9                   	leave  
  800b0a:	c3                   	ret    

00800b0b <sys_yield>:

void
sys_yield(void)
{
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
  800b0e:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b11:	6a 00                	push   $0x0
  800b13:	6a 00                	push   $0x0
  800b15:	6a 00                	push   $0x0
  800b17:	6a 00                	push   $0x0
  800b19:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b23:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b28:	e8 04 ff ff ff       	call   800a31 <syscall>
}
  800b2d:	83 c4 10             	add    $0x10,%esp
  800b30:	c9                   	leave  
  800b31:	c3                   	ret    

00800b32 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800b38:	6a 00                	push   $0x0
  800b3a:	6a 00                	push   $0x0
  800b3c:	ff 75 10             	pushl  0x10(%ebp)
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b45:	ba 01 00 00 00       	mov    $0x1,%edx
  800b4a:	b8 04 00 00 00       	mov    $0x4,%eax
  800b4f:	e8 dd fe ff ff       	call   800a31 <syscall>
}
  800b54:	c9                   	leave  
  800b55:	c3                   	ret    

00800b56 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800b5c:	ff 75 18             	pushl  0x18(%ebp)
  800b5f:	ff 75 14             	pushl  0x14(%ebp)
  800b62:	ff 75 10             	pushl  0x10(%ebp)
  800b65:	ff 75 0c             	pushl  0xc(%ebp)
  800b68:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b6b:	ba 01 00 00 00       	mov    $0x1,%edx
  800b70:	b8 05 00 00 00       	mov    $0x5,%eax
  800b75:	e8 b7 fe ff ff       	call   800a31 <syscall>
}
  800b7a:	c9                   	leave  
  800b7b:	c3                   	ret    

00800b7c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800b82:	6a 00                	push   $0x0
  800b84:	6a 00                	push   $0x0
  800b86:	6a 00                	push   $0x0
  800b88:	ff 75 0c             	pushl  0xc(%ebp)
  800b8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b8e:	ba 01 00 00 00       	mov    $0x1,%edx
  800b93:	b8 06 00 00 00       	mov    $0x6,%eax
  800b98:	e8 94 fe ff ff       	call   800a31 <syscall>
}
  800b9d:	c9                   	leave  
  800b9e:	c3                   	ret    

00800b9f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800ba5:	6a 00                	push   $0x0
  800ba7:	6a 00                	push   $0x0
  800ba9:	6a 00                	push   $0x0
  800bab:	ff 75 0c             	pushl  0xc(%ebp)
  800bae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb1:	ba 01 00 00 00       	mov    $0x1,%edx
  800bb6:	b8 08 00 00 00       	mov    $0x8,%eax
  800bbb:	e8 71 fe ff ff       	call   800a31 <syscall>
}
  800bc0:	c9                   	leave  
  800bc1:	c3                   	ret    

00800bc2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800bc2:	55                   	push   %ebp
  800bc3:	89 e5                	mov    %esp,%ebp
  800bc5:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800bc8:	6a 00                	push   $0x0
  800bca:	6a 00                	push   $0x0
  800bcc:	6a 00                	push   $0x0
  800bce:	ff 75 0c             	pushl  0xc(%ebp)
  800bd1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd4:	ba 01 00 00 00       	mov    $0x1,%edx
  800bd9:	b8 09 00 00 00       	mov    $0x9,%eax
  800bde:	e8 4e fe ff ff       	call   800a31 <syscall>
}
  800be3:	c9                   	leave  
  800be4:	c3                   	ret    

00800be5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800beb:	6a 00                	push   $0x0
  800bed:	6a 00                	push   $0x0
  800bef:	6a 00                	push   $0x0
  800bf1:	ff 75 0c             	pushl  0xc(%ebp)
  800bf4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf7:	ba 01 00 00 00       	mov    $0x1,%edx
  800bfc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c01:	e8 2b fe ff ff       	call   800a31 <syscall>
}
  800c06:	c9                   	leave  
  800c07:	c3                   	ret    

00800c08 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
  800c0b:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800c0e:	6a 00                	push   $0x0
  800c10:	ff 75 14             	pushl  0x14(%ebp)
  800c13:	ff 75 10             	pushl  0x10(%ebp)
  800c16:	ff 75 0c             	pushl  0xc(%ebp)
  800c19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c21:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c26:	e8 06 fe ff ff       	call   800a31 <syscall>
}
  800c2b:	c9                   	leave  
  800c2c:	c3                   	ret    

00800c2d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800c33:	6a 00                	push   $0x0
  800c35:	6a 00                	push   $0x0
  800c37:	6a 00                	push   $0x0
  800c39:	6a 00                	push   $0x0
  800c3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c3e:	ba 01 00 00 00       	mov    $0x1,%edx
  800c43:	b8 0d 00 00 00       	mov    $0xd,%eax
  800c48:	e8 e4 fd ff ff       	call   800a31 <syscall>
}
  800c4d:	c9                   	leave  
  800c4e:	c3                   	ret    

00800c4f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800c55:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  800c5c:	75 2c                	jne    800c8a <set_pgfault_handler+0x3b>
		// First time through!
		// LAB 4: Your code here.
		r = sys_page_alloc(0,(void *)(UXSTACKTOP - PGSIZE),PTE_P | PTE_U | PTE_W);
  800c5e:	83 ec 04             	sub    $0x4,%esp
  800c61:	6a 07                	push   $0x7
  800c63:	68 00 f0 bf ee       	push   $0xeebff000
  800c68:	6a 00                	push   $0x0
  800c6a:	e8 c3 fe ff ff       	call   800b32 <sys_page_alloc>
		if(r < 0)
  800c6f:	83 c4 10             	add    $0x10,%esp
  800c72:	85 c0                	test   %eax,%eax
  800c74:	79 14                	jns    800c8a <set_pgfault_handler+0x3b>
			panic("set_pgfault_handler: error in sys_page_alloc\n");	
  800c76:	83 ec 04             	sub    $0x4,%esp
  800c79:	68 4c 21 80 00       	push   $0x80214c
  800c7e:	6a 22                	push   $0x22
  800c80:	68 b5 21 80 00       	push   $0x8021b5
  800c85:	e8 65 0d 00 00       	call   8019ef <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	a3 08 40 80 00       	mov    %eax,0x804008
	r = sys_env_set_pgfault_upcall(0, _pgfault_upcall); 
  800c92:	83 ec 08             	sub    $0x8,%esp
  800c95:	68 be 0c 80 00       	push   $0x800cbe
  800c9a:	6a 00                	push   $0x0
  800c9c:	e8 44 ff ff ff       	call   800be5 <sys_env_set_pgfault_upcall>
	if (r < 0)
  800ca1:	83 c4 10             	add    $0x10,%esp
  800ca4:	85 c0                	test   %eax,%eax
  800ca6:	79 14                	jns    800cbc <set_pgfault_handler+0x6d>
		panic("set_pgfault_handler: error in sys_env_set_pgfault_upcall");
  800ca8:	83 ec 04             	sub    $0x4,%esp
  800cab:	68 7c 21 80 00       	push   $0x80217c
  800cb0:	6a 29                	push   $0x29
  800cb2:	68 b5 21 80 00       	push   $0x8021b5
  800cb7:	e8 33 0d 00 00       	call   8019ef <_panic>
}
  800cbc:	c9                   	leave  
  800cbd:	c3                   	ret    

00800cbe <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800cbe:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800cbf:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax
  800cc4:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800cc6:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	subl $0x4, 0x30(%esp)
  800cc9:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  800cce:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 0x28(%esp), %ebx 	
  800cd2:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  800cd6:	89 18                	mov    %ebx,(%eax)
	addl $0x8, %esp
  800cd8:	83 c4 08             	add    $0x8,%esp


	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  800cdb:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp 
  800cdc:	83 c4 04             	add    $0x4,%esp
	popfl
  800cdf:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800ce0:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  800ce1:	c3                   	ret    

00800ce2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	05 00 00 00 30       	add    $0x30000000,%eax
  800ced:	c1 e8 0c             	shr    $0xc,%eax
}
  800cf0:	5d                   	pop    %ebp
  800cf1:	c3                   	ret    

00800cf2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  800cf5:	ff 75 08             	pushl  0x8(%ebp)
  800cf8:	e8 e5 ff ff ff       	call   800ce2 <fd2num>
  800cfd:	83 c4 04             	add    $0x4,%esp
  800d00:	c1 e0 0c             	shl    $0xc,%eax
  800d03:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800d08:	c9                   	leave  
  800d09:	c3                   	ret    

00800d0a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
  800d0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d10:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800d15:	89 c2                	mov    %eax,%edx
  800d17:	c1 ea 16             	shr    $0x16,%edx
  800d1a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800d21:	f6 c2 01             	test   $0x1,%dl
  800d24:	74 11                	je     800d37 <fd_alloc+0x2d>
  800d26:	89 c2                	mov    %eax,%edx
  800d28:	c1 ea 0c             	shr    $0xc,%edx
  800d2b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d32:	f6 c2 01             	test   $0x1,%dl
  800d35:	75 09                	jne    800d40 <fd_alloc+0x36>
			*fd_store = fd;
  800d37:	89 01                	mov    %eax,(%ecx)
			return 0;
  800d39:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3e:	eb 17                	jmp    800d57 <fd_alloc+0x4d>
  800d40:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800d45:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800d4a:	75 c9                	jne    800d15 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800d4c:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800d52:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    

00800d59 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800d5f:	83 f8 1f             	cmp    $0x1f,%eax
  800d62:	77 36                	ja     800d9a <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800d64:	c1 e0 0c             	shl    $0xc,%eax
  800d67:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800d6c:	89 c2                	mov    %eax,%edx
  800d6e:	c1 ea 16             	shr    $0x16,%edx
  800d71:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800d78:	f6 c2 01             	test   $0x1,%dl
  800d7b:	74 24                	je     800da1 <fd_lookup+0x48>
  800d7d:	89 c2                	mov    %eax,%edx
  800d7f:	c1 ea 0c             	shr    $0xc,%edx
  800d82:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d89:	f6 c2 01             	test   $0x1,%dl
  800d8c:	74 1a                	je     800da8 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800d8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d91:	89 02                	mov    %eax,(%edx)
	return 0;
  800d93:	b8 00 00 00 00       	mov    $0x0,%eax
  800d98:	eb 13                	jmp    800dad <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800d9a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d9f:	eb 0c                	jmp    800dad <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800da1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800da6:	eb 05                	jmp    800dad <fd_lookup+0x54>
  800da8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800dad:	5d                   	pop    %ebp
  800dae:	c3                   	ret    

00800daf <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 08             	sub    $0x8,%esp
  800db5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800db8:	ba 40 22 80 00       	mov    $0x802240,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800dbd:	eb 13                	jmp    800dd2 <dev_lookup+0x23>
  800dbf:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  800dc2:	39 08                	cmp    %ecx,(%eax)
  800dc4:	75 0c                	jne    800dd2 <dev_lookup+0x23>
			*dev = devtab[i];
  800dc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc9:	89 01                	mov    %eax,(%ecx)
			return 0;
  800dcb:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd0:	eb 2e                	jmp    800e00 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800dd2:	8b 02                	mov    (%edx),%eax
  800dd4:	85 c0                	test   %eax,%eax
  800dd6:	75 e7                	jne    800dbf <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800dd8:	a1 04 40 80 00       	mov    0x804004,%eax
  800ddd:	8b 40 48             	mov    0x48(%eax),%eax
  800de0:	83 ec 04             	sub    $0x4,%esp
  800de3:	51                   	push   %ecx
  800de4:	50                   	push   %eax
  800de5:	68 c4 21 80 00       	push   $0x8021c4
  800dea:	e8 88 f3 ff ff       	call   800177 <cprintf>
	*dev = 0;
  800def:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800df8:	83 c4 10             	add    $0x10,%esp
  800dfb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e00:	c9                   	leave  
  800e01:	c3                   	ret    

00800e02 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	56                   	push   %esi
  800e06:	53                   	push   %ebx
  800e07:	83 ec 10             	sub    $0x10,%esp
  800e0a:	8b 75 08             	mov    0x8(%ebp),%esi
  800e0d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e10:	56                   	push   %esi
  800e11:	e8 cc fe ff ff       	call   800ce2 <fd2num>
  800e16:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800e19:	89 14 24             	mov    %edx,(%esp)
  800e1c:	50                   	push   %eax
  800e1d:	e8 37 ff ff ff       	call   800d59 <fd_lookup>
  800e22:	83 c4 08             	add    $0x8,%esp
  800e25:	85 c0                	test   %eax,%eax
  800e27:	78 05                	js     800e2e <fd_close+0x2c>
	    || fd != fd2)
  800e29:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800e2c:	74 0c                	je     800e3a <fd_close+0x38>
		return (must_exist ? r : 0);
  800e2e:	84 db                	test   %bl,%bl
  800e30:	ba 00 00 00 00       	mov    $0x0,%edx
  800e35:	0f 44 c2             	cmove  %edx,%eax
  800e38:	eb 41                	jmp    800e7b <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800e3a:	83 ec 08             	sub    $0x8,%esp
  800e3d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e40:	50                   	push   %eax
  800e41:	ff 36                	pushl  (%esi)
  800e43:	e8 67 ff ff ff       	call   800daf <dev_lookup>
  800e48:	89 c3                	mov    %eax,%ebx
  800e4a:	83 c4 10             	add    $0x10,%esp
  800e4d:	85 c0                	test   %eax,%eax
  800e4f:	78 1a                	js     800e6b <fd_close+0x69>
		if (dev->dev_close)
  800e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e54:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800e57:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800e5c:	85 c0                	test   %eax,%eax
  800e5e:	74 0b                	je     800e6b <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  800e60:	83 ec 0c             	sub    $0xc,%esp
  800e63:	56                   	push   %esi
  800e64:	ff d0                	call   *%eax
  800e66:	89 c3                	mov    %eax,%ebx
  800e68:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800e6b:	83 ec 08             	sub    $0x8,%esp
  800e6e:	56                   	push   %esi
  800e6f:	6a 00                	push   $0x0
  800e71:	e8 06 fd ff ff       	call   800b7c <sys_page_unmap>
	return r;
  800e76:	83 c4 10             	add    $0x10,%esp
  800e79:	89 d8                	mov    %ebx,%eax
}
  800e7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e7e:	5b                   	pop    %ebx
  800e7f:	5e                   	pop    %esi
  800e80:	5d                   	pop    %ebp
  800e81:	c3                   	ret    

00800e82 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e88:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e8b:	50                   	push   %eax
  800e8c:	ff 75 08             	pushl  0x8(%ebp)
  800e8f:	e8 c5 fe ff ff       	call   800d59 <fd_lookup>
  800e94:	83 c4 08             	add    $0x8,%esp
  800e97:	85 c0                	test   %eax,%eax
  800e99:	78 10                	js     800eab <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800e9b:	83 ec 08             	sub    $0x8,%esp
  800e9e:	6a 01                	push   $0x1
  800ea0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ea3:	e8 5a ff ff ff       	call   800e02 <fd_close>
  800ea8:	83 c4 10             	add    $0x10,%esp
}
  800eab:	c9                   	leave  
  800eac:	c3                   	ret    

00800ead <close_all>:

void
close_all(void)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	53                   	push   %ebx
  800eb1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800eb4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800eb9:	83 ec 0c             	sub    $0xc,%esp
  800ebc:	53                   	push   %ebx
  800ebd:	e8 c0 ff ff ff       	call   800e82 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800ec2:	83 c3 01             	add    $0x1,%ebx
  800ec5:	83 c4 10             	add    $0x10,%esp
  800ec8:	83 fb 20             	cmp    $0x20,%ebx
  800ecb:	75 ec                	jne    800eb9 <close_all+0xc>
		close(i);
}
  800ecd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ed0:	c9                   	leave  
  800ed1:	c3                   	ret    

00800ed2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	57                   	push   %edi
  800ed6:	56                   	push   %esi
  800ed7:	53                   	push   %ebx
  800ed8:	83 ec 2c             	sub    $0x2c,%esp
  800edb:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800ede:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800ee1:	50                   	push   %eax
  800ee2:	ff 75 08             	pushl  0x8(%ebp)
  800ee5:	e8 6f fe ff ff       	call   800d59 <fd_lookup>
  800eea:	83 c4 08             	add    $0x8,%esp
  800eed:	85 c0                	test   %eax,%eax
  800eef:	0f 88 c1 00 00 00    	js     800fb6 <dup+0xe4>
		return r;
	close(newfdnum);
  800ef5:	83 ec 0c             	sub    $0xc,%esp
  800ef8:	56                   	push   %esi
  800ef9:	e8 84 ff ff ff       	call   800e82 <close>

	newfd = INDEX2FD(newfdnum);
  800efe:	89 f3                	mov    %esi,%ebx
  800f00:	c1 e3 0c             	shl    $0xc,%ebx
  800f03:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800f09:	83 c4 04             	add    $0x4,%esp
  800f0c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f0f:	e8 de fd ff ff       	call   800cf2 <fd2data>
  800f14:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  800f16:	89 1c 24             	mov    %ebx,(%esp)
  800f19:	e8 d4 fd ff ff       	call   800cf2 <fd2data>
  800f1e:	83 c4 10             	add    $0x10,%esp
  800f21:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800f24:	89 f8                	mov    %edi,%eax
  800f26:	c1 e8 16             	shr    $0x16,%eax
  800f29:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f30:	a8 01                	test   $0x1,%al
  800f32:	74 37                	je     800f6b <dup+0x99>
  800f34:	89 f8                	mov    %edi,%eax
  800f36:	c1 e8 0c             	shr    $0xc,%eax
  800f39:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800f40:	f6 c2 01             	test   $0x1,%dl
  800f43:	74 26                	je     800f6b <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800f45:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f4c:	83 ec 0c             	sub    $0xc,%esp
  800f4f:	25 07 0e 00 00       	and    $0xe07,%eax
  800f54:	50                   	push   %eax
  800f55:	ff 75 d4             	pushl  -0x2c(%ebp)
  800f58:	6a 00                	push   $0x0
  800f5a:	57                   	push   %edi
  800f5b:	6a 00                	push   $0x0
  800f5d:	e8 f4 fb ff ff       	call   800b56 <sys_page_map>
  800f62:	89 c7                	mov    %eax,%edi
  800f64:	83 c4 20             	add    $0x20,%esp
  800f67:	85 c0                	test   %eax,%eax
  800f69:	78 2e                	js     800f99 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800f6b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f6e:	89 d0                	mov    %edx,%eax
  800f70:	c1 e8 0c             	shr    $0xc,%eax
  800f73:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f7a:	83 ec 0c             	sub    $0xc,%esp
  800f7d:	25 07 0e 00 00       	and    $0xe07,%eax
  800f82:	50                   	push   %eax
  800f83:	53                   	push   %ebx
  800f84:	6a 00                	push   $0x0
  800f86:	52                   	push   %edx
  800f87:	6a 00                	push   $0x0
  800f89:	e8 c8 fb ff ff       	call   800b56 <sys_page_map>
  800f8e:	89 c7                	mov    %eax,%edi
  800f90:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  800f93:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800f95:	85 ff                	test   %edi,%edi
  800f97:	79 1d                	jns    800fb6 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800f99:	83 ec 08             	sub    $0x8,%esp
  800f9c:	53                   	push   %ebx
  800f9d:	6a 00                	push   $0x0
  800f9f:	e8 d8 fb ff ff       	call   800b7c <sys_page_unmap>
	sys_page_unmap(0, nva);
  800fa4:	83 c4 08             	add    $0x8,%esp
  800fa7:	ff 75 d4             	pushl  -0x2c(%ebp)
  800faa:	6a 00                	push   $0x0
  800fac:	e8 cb fb ff ff       	call   800b7c <sys_page_unmap>
	return r;
  800fb1:	83 c4 10             	add    $0x10,%esp
  800fb4:	89 f8                	mov    %edi,%eax
}
  800fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb9:	5b                   	pop    %ebx
  800fba:	5e                   	pop    %esi
  800fbb:	5f                   	pop    %edi
  800fbc:	5d                   	pop    %ebp
  800fbd:	c3                   	ret    

00800fbe <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
  800fc1:	53                   	push   %ebx
  800fc2:	83 ec 14             	sub    $0x14,%esp
  800fc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800fc8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800fcb:	50                   	push   %eax
  800fcc:	53                   	push   %ebx
  800fcd:	e8 87 fd ff ff       	call   800d59 <fd_lookup>
  800fd2:	83 c4 08             	add    $0x8,%esp
  800fd5:	89 c2                	mov    %eax,%edx
  800fd7:	85 c0                	test   %eax,%eax
  800fd9:	78 6d                	js     801048 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800fdb:	83 ec 08             	sub    $0x8,%esp
  800fde:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fe1:	50                   	push   %eax
  800fe2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fe5:	ff 30                	pushl  (%eax)
  800fe7:	e8 c3 fd ff ff       	call   800daf <dev_lookup>
  800fec:	83 c4 10             	add    $0x10,%esp
  800fef:	85 c0                	test   %eax,%eax
  800ff1:	78 4c                	js     80103f <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800ff3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ff6:	8b 42 08             	mov    0x8(%edx),%eax
  800ff9:	83 e0 03             	and    $0x3,%eax
  800ffc:	83 f8 01             	cmp    $0x1,%eax
  800fff:	75 21                	jne    801022 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801001:	a1 04 40 80 00       	mov    0x804004,%eax
  801006:	8b 40 48             	mov    0x48(%eax),%eax
  801009:	83 ec 04             	sub    $0x4,%esp
  80100c:	53                   	push   %ebx
  80100d:	50                   	push   %eax
  80100e:	68 05 22 80 00       	push   $0x802205
  801013:	e8 5f f1 ff ff       	call   800177 <cprintf>
		return -E_INVAL;
  801018:	83 c4 10             	add    $0x10,%esp
  80101b:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801020:	eb 26                	jmp    801048 <read+0x8a>
	}
	if (!dev->dev_read)
  801022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801025:	8b 40 08             	mov    0x8(%eax),%eax
  801028:	85 c0                	test   %eax,%eax
  80102a:	74 17                	je     801043 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80102c:	83 ec 04             	sub    $0x4,%esp
  80102f:	ff 75 10             	pushl  0x10(%ebp)
  801032:	ff 75 0c             	pushl  0xc(%ebp)
  801035:	52                   	push   %edx
  801036:	ff d0                	call   *%eax
  801038:	89 c2                	mov    %eax,%edx
  80103a:	83 c4 10             	add    $0x10,%esp
  80103d:	eb 09                	jmp    801048 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80103f:	89 c2                	mov    %eax,%edx
  801041:	eb 05                	jmp    801048 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801043:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  801048:	89 d0                	mov    %edx,%eax
  80104a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80104d:	c9                   	leave  
  80104e:	c3                   	ret    

0080104f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	57                   	push   %edi
  801053:	56                   	push   %esi
  801054:	53                   	push   %ebx
  801055:	83 ec 0c             	sub    $0xc,%esp
  801058:	8b 7d 08             	mov    0x8(%ebp),%edi
  80105b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80105e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801063:	eb 21                	jmp    801086 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801065:	83 ec 04             	sub    $0x4,%esp
  801068:	89 f0                	mov    %esi,%eax
  80106a:	29 d8                	sub    %ebx,%eax
  80106c:	50                   	push   %eax
  80106d:	89 d8                	mov    %ebx,%eax
  80106f:	03 45 0c             	add    0xc(%ebp),%eax
  801072:	50                   	push   %eax
  801073:	57                   	push   %edi
  801074:	e8 45 ff ff ff       	call   800fbe <read>
		if (m < 0)
  801079:	83 c4 10             	add    $0x10,%esp
  80107c:	85 c0                	test   %eax,%eax
  80107e:	78 10                	js     801090 <readn+0x41>
			return m;
		if (m == 0)
  801080:	85 c0                	test   %eax,%eax
  801082:	74 0a                	je     80108e <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801084:	01 c3                	add    %eax,%ebx
  801086:	39 f3                	cmp    %esi,%ebx
  801088:	72 db                	jb     801065 <readn+0x16>
  80108a:	89 d8                	mov    %ebx,%eax
  80108c:	eb 02                	jmp    801090 <readn+0x41>
  80108e:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801090:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801093:	5b                   	pop    %ebx
  801094:	5e                   	pop    %esi
  801095:	5f                   	pop    %edi
  801096:	5d                   	pop    %ebp
  801097:	c3                   	ret    

00801098 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801098:	55                   	push   %ebp
  801099:	89 e5                	mov    %esp,%ebp
  80109b:	53                   	push   %ebx
  80109c:	83 ec 14             	sub    $0x14,%esp
  80109f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010a5:	50                   	push   %eax
  8010a6:	53                   	push   %ebx
  8010a7:	e8 ad fc ff ff       	call   800d59 <fd_lookup>
  8010ac:	83 c4 08             	add    $0x8,%esp
  8010af:	89 c2                	mov    %eax,%edx
  8010b1:	85 c0                	test   %eax,%eax
  8010b3:	78 68                	js     80111d <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010b5:	83 ec 08             	sub    $0x8,%esp
  8010b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010bb:	50                   	push   %eax
  8010bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010bf:	ff 30                	pushl  (%eax)
  8010c1:	e8 e9 fc ff ff       	call   800daf <dev_lookup>
  8010c6:	83 c4 10             	add    $0x10,%esp
  8010c9:	85 c0                	test   %eax,%eax
  8010cb:	78 47                	js     801114 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8010cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010d0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8010d4:	75 21                	jne    8010f7 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8010d6:	a1 04 40 80 00       	mov    0x804004,%eax
  8010db:	8b 40 48             	mov    0x48(%eax),%eax
  8010de:	83 ec 04             	sub    $0x4,%esp
  8010e1:	53                   	push   %ebx
  8010e2:	50                   	push   %eax
  8010e3:	68 21 22 80 00       	push   $0x802221
  8010e8:	e8 8a f0 ff ff       	call   800177 <cprintf>
		return -E_INVAL;
  8010ed:	83 c4 10             	add    $0x10,%esp
  8010f0:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8010f5:	eb 26                	jmp    80111d <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8010f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010fa:	8b 52 0c             	mov    0xc(%edx),%edx
  8010fd:	85 d2                	test   %edx,%edx
  8010ff:	74 17                	je     801118 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801101:	83 ec 04             	sub    $0x4,%esp
  801104:	ff 75 10             	pushl  0x10(%ebp)
  801107:	ff 75 0c             	pushl  0xc(%ebp)
  80110a:	50                   	push   %eax
  80110b:	ff d2                	call   *%edx
  80110d:	89 c2                	mov    %eax,%edx
  80110f:	83 c4 10             	add    $0x10,%esp
  801112:	eb 09                	jmp    80111d <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801114:	89 c2                	mov    %eax,%edx
  801116:	eb 05                	jmp    80111d <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801118:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  80111d:	89 d0                	mov    %edx,%eax
  80111f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801122:	c9                   	leave  
  801123:	c3                   	ret    

00801124 <seek>:

int
seek(int fdnum, off_t offset)
{
  801124:	55                   	push   %ebp
  801125:	89 e5                	mov    %esp,%ebp
  801127:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80112a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80112d:	50                   	push   %eax
  80112e:	ff 75 08             	pushl  0x8(%ebp)
  801131:	e8 23 fc ff ff       	call   800d59 <fd_lookup>
  801136:	83 c4 08             	add    $0x8,%esp
  801139:	85 c0                	test   %eax,%eax
  80113b:	78 0e                	js     80114b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80113d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801140:	8b 55 0c             	mov    0xc(%ebp),%edx
  801143:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801146:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    

0080114d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	53                   	push   %ebx
  801151:	83 ec 14             	sub    $0x14,%esp
  801154:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801157:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80115a:	50                   	push   %eax
  80115b:	53                   	push   %ebx
  80115c:	e8 f8 fb ff ff       	call   800d59 <fd_lookup>
  801161:	83 c4 08             	add    $0x8,%esp
  801164:	89 c2                	mov    %eax,%edx
  801166:	85 c0                	test   %eax,%eax
  801168:	78 65                	js     8011cf <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80116a:	83 ec 08             	sub    $0x8,%esp
  80116d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801170:	50                   	push   %eax
  801171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801174:	ff 30                	pushl  (%eax)
  801176:	e8 34 fc ff ff       	call   800daf <dev_lookup>
  80117b:	83 c4 10             	add    $0x10,%esp
  80117e:	85 c0                	test   %eax,%eax
  801180:	78 44                	js     8011c6 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801182:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801185:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801189:	75 21                	jne    8011ac <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80118b:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801190:	8b 40 48             	mov    0x48(%eax),%eax
  801193:	83 ec 04             	sub    $0x4,%esp
  801196:	53                   	push   %ebx
  801197:	50                   	push   %eax
  801198:	68 e4 21 80 00       	push   $0x8021e4
  80119d:	e8 d5 ef ff ff       	call   800177 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8011a2:	83 c4 10             	add    $0x10,%esp
  8011a5:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8011aa:	eb 23                	jmp    8011cf <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  8011ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011af:	8b 52 18             	mov    0x18(%edx),%edx
  8011b2:	85 d2                	test   %edx,%edx
  8011b4:	74 14                	je     8011ca <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8011b6:	83 ec 08             	sub    $0x8,%esp
  8011b9:	ff 75 0c             	pushl  0xc(%ebp)
  8011bc:	50                   	push   %eax
  8011bd:	ff d2                	call   *%edx
  8011bf:	89 c2                	mov    %eax,%edx
  8011c1:	83 c4 10             	add    $0x10,%esp
  8011c4:	eb 09                	jmp    8011cf <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011c6:	89 c2                	mov    %eax,%edx
  8011c8:	eb 05                	jmp    8011cf <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8011ca:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  8011cf:	89 d0                	mov    %edx,%eax
  8011d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011d4:	c9                   	leave  
  8011d5:	c3                   	ret    

008011d6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
  8011d9:	53                   	push   %ebx
  8011da:	83 ec 14             	sub    $0x14,%esp
  8011dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011e3:	50                   	push   %eax
  8011e4:	ff 75 08             	pushl  0x8(%ebp)
  8011e7:	e8 6d fb ff ff       	call   800d59 <fd_lookup>
  8011ec:	83 c4 08             	add    $0x8,%esp
  8011ef:	89 c2                	mov    %eax,%edx
  8011f1:	85 c0                	test   %eax,%eax
  8011f3:	78 58                	js     80124d <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011f5:	83 ec 08             	sub    $0x8,%esp
  8011f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011fb:	50                   	push   %eax
  8011fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ff:	ff 30                	pushl  (%eax)
  801201:	e8 a9 fb ff ff       	call   800daf <dev_lookup>
  801206:	83 c4 10             	add    $0x10,%esp
  801209:	85 c0                	test   %eax,%eax
  80120b:	78 37                	js     801244 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  80120d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801210:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801214:	74 32                	je     801248 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801216:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801219:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801220:	00 00 00 
	stat->st_isdir = 0;
  801223:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80122a:	00 00 00 
	stat->st_dev = dev;
  80122d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801233:	83 ec 08             	sub    $0x8,%esp
  801236:	53                   	push   %ebx
  801237:	ff 75 f0             	pushl  -0x10(%ebp)
  80123a:	ff 50 14             	call   *0x14(%eax)
  80123d:	89 c2                	mov    %eax,%edx
  80123f:	83 c4 10             	add    $0x10,%esp
  801242:	eb 09                	jmp    80124d <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801244:	89 c2                	mov    %eax,%edx
  801246:	eb 05                	jmp    80124d <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801248:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80124d:	89 d0                	mov    %edx,%eax
  80124f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801252:	c9                   	leave  
  801253:	c3                   	ret    

00801254 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
  801257:	56                   	push   %esi
  801258:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801259:	83 ec 08             	sub    $0x8,%esp
  80125c:	6a 00                	push   $0x0
  80125e:	ff 75 08             	pushl  0x8(%ebp)
  801261:	e8 06 02 00 00       	call   80146c <open>
  801266:	89 c3                	mov    %eax,%ebx
  801268:	83 c4 10             	add    $0x10,%esp
  80126b:	85 c0                	test   %eax,%eax
  80126d:	78 1b                	js     80128a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80126f:	83 ec 08             	sub    $0x8,%esp
  801272:	ff 75 0c             	pushl  0xc(%ebp)
  801275:	50                   	push   %eax
  801276:	e8 5b ff ff ff       	call   8011d6 <fstat>
  80127b:	89 c6                	mov    %eax,%esi
	close(fd);
  80127d:	89 1c 24             	mov    %ebx,(%esp)
  801280:	e8 fd fb ff ff       	call   800e82 <close>
	return r;
  801285:	83 c4 10             	add    $0x10,%esp
  801288:	89 f0                	mov    %esi,%eax
}
  80128a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80128d:	5b                   	pop    %ebx
  80128e:	5e                   	pop    %esi
  80128f:	5d                   	pop    %ebp
  801290:	c3                   	ret    

00801291 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	56                   	push   %esi
  801295:	53                   	push   %ebx
  801296:	89 c6                	mov    %eax,%esi
  801298:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80129a:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8012a1:	75 12                	jne    8012b5 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8012a3:	83 ec 0c             	sub    $0xc,%esp
  8012a6:	6a 01                	push   $0x1
  8012a8:	e8 47 08 00 00       	call   801af4 <ipc_find_env>
  8012ad:	a3 00 40 80 00       	mov    %eax,0x804000
  8012b2:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8012b5:	6a 07                	push   $0x7
  8012b7:	68 00 50 80 00       	push   $0x805000
  8012bc:	56                   	push   %esi
  8012bd:	ff 35 00 40 80 00    	pushl  0x804000
  8012c3:	e8 d8 07 00 00       	call   801aa0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8012c8:	83 c4 0c             	add    $0xc,%esp
  8012cb:	6a 00                	push   $0x0
  8012cd:	53                   	push   %ebx
  8012ce:	6a 00                	push   $0x0
  8012d0:	e8 60 07 00 00       	call   801a35 <ipc_recv>
}
  8012d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012d8:	5b                   	pop    %ebx
  8012d9:	5e                   	pop    %esi
  8012da:	5d                   	pop    %ebp
  8012db:	c3                   	ret    

008012dc <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8012dc:	55                   	push   %ebp
  8012dd:	89 e5                	mov    %esp,%ebp
  8012df:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8012e8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8012ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f0:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8012f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8012fa:	b8 02 00 00 00       	mov    $0x2,%eax
  8012ff:	e8 8d ff ff ff       	call   801291 <fsipc>
}
  801304:	c9                   	leave  
  801305:	c3                   	ret    

00801306 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
  801309:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80130c:	8b 45 08             	mov    0x8(%ebp),%eax
  80130f:	8b 40 0c             	mov    0xc(%eax),%eax
  801312:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801317:	ba 00 00 00 00       	mov    $0x0,%edx
  80131c:	b8 06 00 00 00       	mov    $0x6,%eax
  801321:	e8 6b ff ff ff       	call   801291 <fsipc>
}
  801326:	c9                   	leave  
  801327:	c3                   	ret    

00801328 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
  80132b:	53                   	push   %ebx
  80132c:	83 ec 04             	sub    $0x4,%esp
  80132f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	8b 40 0c             	mov    0xc(%eax),%eax
  801338:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80133d:	ba 00 00 00 00       	mov    $0x0,%edx
  801342:	b8 05 00 00 00       	mov    $0x5,%eax
  801347:	e8 45 ff ff ff       	call   801291 <fsipc>
  80134c:	85 c0                	test   %eax,%eax
  80134e:	78 2c                	js     80137c <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801350:	83 ec 08             	sub    $0x8,%esp
  801353:	68 00 50 80 00       	push   $0x805000
  801358:	53                   	push   %ebx
  801359:	e8 8b f3 ff ff       	call   8006e9 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80135e:	a1 80 50 80 00       	mov    0x805080,%eax
  801363:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801369:	a1 84 50 80 00       	mov    0x805084,%eax
  80136e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801374:	83 c4 10             	add    $0x10,%esp
  801377:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80137f:	c9                   	leave  
  801380:	c3                   	ret    

00801381 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
  801384:	83 ec 08             	sub    $0x8,%esp
  801387:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138a:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80138d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801390:	8b 49 0c             	mov    0xc(%ecx),%ecx
  801393:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  801399:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80139e:	76 22                	jbe    8013c2 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  8013a0:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  8013a7:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  8013aa:	83 ec 04             	sub    $0x4,%esp
  8013ad:	68 f8 0f 00 00       	push   $0xff8
  8013b2:	52                   	push   %edx
  8013b3:	68 08 50 80 00       	push   $0x805008
  8013b8:	e8 bf f4 ff ff       	call   80087c <memmove>
  8013bd:	83 c4 10             	add    $0x10,%esp
  8013c0:	eb 17                	jmp    8013d9 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  8013c2:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  8013c7:	83 ec 04             	sub    $0x4,%esp
  8013ca:	50                   	push   %eax
  8013cb:	52                   	push   %edx
  8013cc:	68 08 50 80 00       	push   $0x805008
  8013d1:	e8 a6 f4 ff ff       	call   80087c <memmove>
  8013d6:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  8013d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8013de:	b8 04 00 00 00       	mov    $0x4,%eax
  8013e3:	e8 a9 fe ff ff       	call   801291 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    

008013ea <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
  8013ed:	56                   	push   %esi
  8013ee:	53                   	push   %ebx
  8013ef:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8013f8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8013fd:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801403:	ba 00 00 00 00       	mov    $0x0,%edx
  801408:	b8 03 00 00 00       	mov    $0x3,%eax
  80140d:	e8 7f fe ff ff       	call   801291 <fsipc>
  801412:	89 c3                	mov    %eax,%ebx
  801414:	85 c0                	test   %eax,%eax
  801416:	78 4b                	js     801463 <devfile_read+0x79>
		return r;
	assert(r <= n);
  801418:	39 c6                	cmp    %eax,%esi
  80141a:	73 16                	jae    801432 <devfile_read+0x48>
  80141c:	68 50 22 80 00       	push   $0x802250
  801421:	68 57 22 80 00       	push   $0x802257
  801426:	6a 7c                	push   $0x7c
  801428:	68 6c 22 80 00       	push   $0x80226c
  80142d:	e8 bd 05 00 00       	call   8019ef <_panic>
	assert(r <= PGSIZE);
  801432:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801437:	7e 16                	jle    80144f <devfile_read+0x65>
  801439:	68 77 22 80 00       	push   $0x802277
  80143e:	68 57 22 80 00       	push   $0x802257
  801443:	6a 7d                	push   $0x7d
  801445:	68 6c 22 80 00       	push   $0x80226c
  80144a:	e8 a0 05 00 00       	call   8019ef <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80144f:	83 ec 04             	sub    $0x4,%esp
  801452:	50                   	push   %eax
  801453:	68 00 50 80 00       	push   $0x805000
  801458:	ff 75 0c             	pushl  0xc(%ebp)
  80145b:	e8 1c f4 ff ff       	call   80087c <memmove>
	return r;
  801460:	83 c4 10             	add    $0x10,%esp
}
  801463:	89 d8                	mov    %ebx,%eax
  801465:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801468:	5b                   	pop    %ebx
  801469:	5e                   	pop    %esi
  80146a:	5d                   	pop    %ebp
  80146b:	c3                   	ret    

0080146c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
  80146f:	53                   	push   %ebx
  801470:	83 ec 20             	sub    $0x20,%esp
  801473:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801476:	53                   	push   %ebx
  801477:	e8 34 f2 ff ff       	call   8006b0 <strlen>
  80147c:	83 c4 10             	add    $0x10,%esp
  80147f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801484:	7f 67                	jg     8014ed <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801486:	83 ec 0c             	sub    $0xc,%esp
  801489:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80148c:	50                   	push   %eax
  80148d:	e8 78 f8 ff ff       	call   800d0a <fd_alloc>
  801492:	83 c4 10             	add    $0x10,%esp
		return r;
  801495:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801497:	85 c0                	test   %eax,%eax
  801499:	78 57                	js     8014f2 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80149b:	83 ec 08             	sub    $0x8,%esp
  80149e:	53                   	push   %ebx
  80149f:	68 00 50 80 00       	push   $0x805000
  8014a4:	e8 40 f2 ff ff       	call   8006e9 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8014b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8014b9:	e8 d3 fd ff ff       	call   801291 <fsipc>
  8014be:	89 c3                	mov    %eax,%ebx
  8014c0:	83 c4 10             	add    $0x10,%esp
  8014c3:	85 c0                	test   %eax,%eax
  8014c5:	79 14                	jns    8014db <open+0x6f>
		fd_close(fd, 0);
  8014c7:	83 ec 08             	sub    $0x8,%esp
  8014ca:	6a 00                	push   $0x0
  8014cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8014cf:	e8 2e f9 ff ff       	call   800e02 <fd_close>
		return r;
  8014d4:	83 c4 10             	add    $0x10,%esp
  8014d7:	89 da                	mov    %ebx,%edx
  8014d9:	eb 17                	jmp    8014f2 <open+0x86>
	}

	return fd2num(fd);
  8014db:	83 ec 0c             	sub    $0xc,%esp
  8014de:	ff 75 f4             	pushl  -0xc(%ebp)
  8014e1:	e8 fc f7 ff ff       	call   800ce2 <fd2num>
  8014e6:	89 c2                	mov    %eax,%edx
  8014e8:	83 c4 10             	add    $0x10,%esp
  8014eb:	eb 05                	jmp    8014f2 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8014ed:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8014f2:	89 d0                	mov    %edx,%eax
  8014f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8014ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801504:	b8 08 00 00 00       	mov    $0x8,%eax
  801509:	e8 83 fd ff ff       	call   801291 <fsipc>
}
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

00801510 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	56                   	push   %esi
  801514:	53                   	push   %ebx
  801515:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801518:	83 ec 0c             	sub    $0xc,%esp
  80151b:	ff 75 08             	pushl  0x8(%ebp)
  80151e:	e8 cf f7 ff ff       	call   800cf2 <fd2data>
  801523:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801525:	83 c4 08             	add    $0x8,%esp
  801528:	68 83 22 80 00       	push   $0x802283
  80152d:	53                   	push   %ebx
  80152e:	e8 b6 f1 ff ff       	call   8006e9 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801533:	8b 46 04             	mov    0x4(%esi),%eax
  801536:	2b 06                	sub    (%esi),%eax
  801538:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80153e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801545:	00 00 00 
	stat->st_dev = &devpipe;
  801548:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80154f:	30 80 00 
	return 0;
}
  801552:	b8 00 00 00 00       	mov    $0x0,%eax
  801557:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80155a:	5b                   	pop    %ebx
  80155b:	5e                   	pop    %esi
  80155c:	5d                   	pop    %ebp
  80155d:	c3                   	ret    

0080155e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	53                   	push   %ebx
  801562:	83 ec 0c             	sub    $0xc,%esp
  801565:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801568:	53                   	push   %ebx
  801569:	6a 00                	push   $0x0
  80156b:	e8 0c f6 ff ff       	call   800b7c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801570:	89 1c 24             	mov    %ebx,(%esp)
  801573:	e8 7a f7 ff ff       	call   800cf2 <fd2data>
  801578:	83 c4 08             	add    $0x8,%esp
  80157b:	50                   	push   %eax
  80157c:	6a 00                	push   $0x0
  80157e:	e8 f9 f5 ff ff       	call   800b7c <sys_page_unmap>
}
  801583:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801586:	c9                   	leave  
  801587:	c3                   	ret    

00801588 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	57                   	push   %edi
  80158c:	56                   	push   %esi
  80158d:	53                   	push   %ebx
  80158e:	83 ec 1c             	sub    $0x1c,%esp
  801591:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801594:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801596:	a1 04 40 80 00       	mov    0x804004,%eax
  80159b:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  80159e:	83 ec 0c             	sub    $0xc,%esp
  8015a1:	ff 75 e0             	pushl  -0x20(%ebp)
  8015a4:	e8 84 05 00 00       	call   801b2d <pageref>
  8015a9:	89 c3                	mov    %eax,%ebx
  8015ab:	89 3c 24             	mov    %edi,(%esp)
  8015ae:	e8 7a 05 00 00       	call   801b2d <pageref>
  8015b3:	83 c4 10             	add    $0x10,%esp
  8015b6:	39 c3                	cmp    %eax,%ebx
  8015b8:	0f 94 c1             	sete   %cl
  8015bb:	0f b6 c9             	movzbl %cl,%ecx
  8015be:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  8015c1:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8015c7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8015ca:	39 ce                	cmp    %ecx,%esi
  8015cc:	74 1b                	je     8015e9 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8015ce:	39 c3                	cmp    %eax,%ebx
  8015d0:	75 c4                	jne    801596 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8015d2:	8b 42 58             	mov    0x58(%edx),%eax
  8015d5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015d8:	50                   	push   %eax
  8015d9:	56                   	push   %esi
  8015da:	68 8a 22 80 00       	push   $0x80228a
  8015df:	e8 93 eb ff ff       	call   800177 <cprintf>
  8015e4:	83 c4 10             	add    $0x10,%esp
  8015e7:	eb ad                	jmp    801596 <_pipeisclosed+0xe>
	}
}
  8015e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015ef:	5b                   	pop    %ebx
  8015f0:	5e                   	pop    %esi
  8015f1:	5f                   	pop    %edi
  8015f2:	5d                   	pop    %ebp
  8015f3:	c3                   	ret    

008015f4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	57                   	push   %edi
  8015f8:	56                   	push   %esi
  8015f9:	53                   	push   %ebx
  8015fa:	83 ec 28             	sub    $0x28,%esp
  8015fd:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801600:	56                   	push   %esi
  801601:	e8 ec f6 ff ff       	call   800cf2 <fd2data>
  801606:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801608:	83 c4 10             	add    $0x10,%esp
  80160b:	bf 00 00 00 00       	mov    $0x0,%edi
  801610:	eb 4b                	jmp    80165d <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801612:	89 da                	mov    %ebx,%edx
  801614:	89 f0                	mov    %esi,%eax
  801616:	e8 6d ff ff ff       	call   801588 <_pipeisclosed>
  80161b:	85 c0                	test   %eax,%eax
  80161d:	75 48                	jne    801667 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80161f:	e8 e7 f4 ff ff       	call   800b0b <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801624:	8b 43 04             	mov    0x4(%ebx),%eax
  801627:	8b 0b                	mov    (%ebx),%ecx
  801629:	8d 51 20             	lea    0x20(%ecx),%edx
  80162c:	39 d0                	cmp    %edx,%eax
  80162e:	73 e2                	jae    801612 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801630:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801633:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801637:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80163a:	89 c2                	mov    %eax,%edx
  80163c:	c1 fa 1f             	sar    $0x1f,%edx
  80163f:	89 d1                	mov    %edx,%ecx
  801641:	c1 e9 1b             	shr    $0x1b,%ecx
  801644:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801647:	83 e2 1f             	and    $0x1f,%edx
  80164a:	29 ca                	sub    %ecx,%edx
  80164c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801650:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801654:	83 c0 01             	add    $0x1,%eax
  801657:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80165a:	83 c7 01             	add    $0x1,%edi
  80165d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801660:	75 c2                	jne    801624 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	eb 05                	jmp    80166c <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801667:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80166c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80166f:	5b                   	pop    %ebx
  801670:	5e                   	pop    %esi
  801671:	5f                   	pop    %edi
  801672:	5d                   	pop    %ebp
  801673:	c3                   	ret    

00801674 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
  801677:	57                   	push   %edi
  801678:	56                   	push   %esi
  801679:	53                   	push   %ebx
  80167a:	83 ec 18             	sub    $0x18,%esp
  80167d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801680:	57                   	push   %edi
  801681:	e8 6c f6 ff ff       	call   800cf2 <fd2data>
  801686:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801688:	83 c4 10             	add    $0x10,%esp
  80168b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801690:	eb 3d                	jmp    8016cf <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801692:	85 db                	test   %ebx,%ebx
  801694:	74 04                	je     80169a <devpipe_read+0x26>
				return i;
  801696:	89 d8                	mov    %ebx,%eax
  801698:	eb 44                	jmp    8016de <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80169a:	89 f2                	mov    %esi,%edx
  80169c:	89 f8                	mov    %edi,%eax
  80169e:	e8 e5 fe ff ff       	call   801588 <_pipeisclosed>
  8016a3:	85 c0                	test   %eax,%eax
  8016a5:	75 32                	jne    8016d9 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8016a7:	e8 5f f4 ff ff       	call   800b0b <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8016ac:	8b 06                	mov    (%esi),%eax
  8016ae:	3b 46 04             	cmp    0x4(%esi),%eax
  8016b1:	74 df                	je     801692 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8016b3:	99                   	cltd   
  8016b4:	c1 ea 1b             	shr    $0x1b,%edx
  8016b7:	01 d0                	add    %edx,%eax
  8016b9:	83 e0 1f             	and    $0x1f,%eax
  8016bc:	29 d0                	sub    %edx,%eax
  8016be:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  8016c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016c6:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  8016c9:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8016cc:	83 c3 01             	add    $0x1,%ebx
  8016cf:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8016d2:	75 d8                	jne    8016ac <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8016d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d7:	eb 05                	jmp    8016de <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8016d9:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8016de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016e1:	5b                   	pop    %ebx
  8016e2:	5e                   	pop    %esi
  8016e3:	5f                   	pop    %edi
  8016e4:	5d                   	pop    %ebp
  8016e5:	c3                   	ret    

008016e6 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
  8016e9:	56                   	push   %esi
  8016ea:	53                   	push   %ebx
  8016eb:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8016ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f1:	50                   	push   %eax
  8016f2:	e8 13 f6 ff ff       	call   800d0a <fd_alloc>
  8016f7:	83 c4 10             	add    $0x10,%esp
  8016fa:	89 c2                	mov    %eax,%edx
  8016fc:	85 c0                	test   %eax,%eax
  8016fe:	0f 88 2c 01 00 00    	js     801830 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801704:	83 ec 04             	sub    $0x4,%esp
  801707:	68 07 04 00 00       	push   $0x407
  80170c:	ff 75 f4             	pushl  -0xc(%ebp)
  80170f:	6a 00                	push   $0x0
  801711:	e8 1c f4 ff ff       	call   800b32 <sys_page_alloc>
  801716:	83 c4 10             	add    $0x10,%esp
  801719:	89 c2                	mov    %eax,%edx
  80171b:	85 c0                	test   %eax,%eax
  80171d:	0f 88 0d 01 00 00    	js     801830 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801723:	83 ec 0c             	sub    $0xc,%esp
  801726:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801729:	50                   	push   %eax
  80172a:	e8 db f5 ff ff       	call   800d0a <fd_alloc>
  80172f:	89 c3                	mov    %eax,%ebx
  801731:	83 c4 10             	add    $0x10,%esp
  801734:	85 c0                	test   %eax,%eax
  801736:	0f 88 e2 00 00 00    	js     80181e <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80173c:	83 ec 04             	sub    $0x4,%esp
  80173f:	68 07 04 00 00       	push   $0x407
  801744:	ff 75 f0             	pushl  -0x10(%ebp)
  801747:	6a 00                	push   $0x0
  801749:	e8 e4 f3 ff ff       	call   800b32 <sys_page_alloc>
  80174e:	89 c3                	mov    %eax,%ebx
  801750:	83 c4 10             	add    $0x10,%esp
  801753:	85 c0                	test   %eax,%eax
  801755:	0f 88 c3 00 00 00    	js     80181e <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80175b:	83 ec 0c             	sub    $0xc,%esp
  80175e:	ff 75 f4             	pushl  -0xc(%ebp)
  801761:	e8 8c f5 ff ff       	call   800cf2 <fd2data>
  801766:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801768:	83 c4 0c             	add    $0xc,%esp
  80176b:	68 07 04 00 00       	push   $0x407
  801770:	50                   	push   %eax
  801771:	6a 00                	push   $0x0
  801773:	e8 ba f3 ff ff       	call   800b32 <sys_page_alloc>
  801778:	89 c3                	mov    %eax,%ebx
  80177a:	83 c4 10             	add    $0x10,%esp
  80177d:	85 c0                	test   %eax,%eax
  80177f:	0f 88 89 00 00 00    	js     80180e <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801785:	83 ec 0c             	sub    $0xc,%esp
  801788:	ff 75 f0             	pushl  -0x10(%ebp)
  80178b:	e8 62 f5 ff ff       	call   800cf2 <fd2data>
  801790:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801797:	50                   	push   %eax
  801798:	6a 00                	push   $0x0
  80179a:	56                   	push   %esi
  80179b:	6a 00                	push   $0x0
  80179d:	e8 b4 f3 ff ff       	call   800b56 <sys_page_map>
  8017a2:	89 c3                	mov    %eax,%ebx
  8017a4:	83 c4 20             	add    $0x20,%esp
  8017a7:	85 c0                	test   %eax,%eax
  8017a9:	78 55                	js     801800 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8017ab:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8017b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b4:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8017b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8017c0:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8017c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c9:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8017cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ce:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8017d5:	83 ec 0c             	sub    $0xc,%esp
  8017d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8017db:	e8 02 f5 ff ff       	call   800ce2 <fd2num>
  8017e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017e3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8017e5:	83 c4 04             	add    $0x4,%esp
  8017e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8017eb:	e8 f2 f4 ff ff       	call   800ce2 <fd2num>
  8017f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017f3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8017f6:	83 c4 10             	add    $0x10,%esp
  8017f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017fe:	eb 30                	jmp    801830 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801800:	83 ec 08             	sub    $0x8,%esp
  801803:	56                   	push   %esi
  801804:	6a 00                	push   $0x0
  801806:	e8 71 f3 ff ff       	call   800b7c <sys_page_unmap>
  80180b:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  80180e:	83 ec 08             	sub    $0x8,%esp
  801811:	ff 75 f0             	pushl  -0x10(%ebp)
  801814:	6a 00                	push   $0x0
  801816:	e8 61 f3 ff ff       	call   800b7c <sys_page_unmap>
  80181b:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  80181e:	83 ec 08             	sub    $0x8,%esp
  801821:	ff 75 f4             	pushl  -0xc(%ebp)
  801824:	6a 00                	push   $0x0
  801826:	e8 51 f3 ff ff       	call   800b7c <sys_page_unmap>
  80182b:	83 c4 10             	add    $0x10,%esp
  80182e:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  801830:	89 d0                	mov    %edx,%eax
  801832:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801835:	5b                   	pop    %ebx
  801836:	5e                   	pop    %esi
  801837:	5d                   	pop    %ebp
  801838:	c3                   	ret    

00801839 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80183f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801842:	50                   	push   %eax
  801843:	ff 75 08             	pushl  0x8(%ebp)
  801846:	e8 0e f5 ff ff       	call   800d59 <fd_lookup>
  80184b:	83 c4 10             	add    $0x10,%esp
  80184e:	85 c0                	test   %eax,%eax
  801850:	78 18                	js     80186a <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801852:	83 ec 0c             	sub    $0xc,%esp
  801855:	ff 75 f4             	pushl  -0xc(%ebp)
  801858:	e8 95 f4 ff ff       	call   800cf2 <fd2data>
	return _pipeisclosed(fd, p);
  80185d:	89 c2                	mov    %eax,%edx
  80185f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801862:	e8 21 fd ff ff       	call   801588 <_pipeisclosed>
  801867:	83 c4 10             	add    $0x10,%esp
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80186f:	b8 00 00 00 00       	mov    $0x0,%eax
  801874:	5d                   	pop    %ebp
  801875:	c3                   	ret    

00801876 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80187c:	68 a2 22 80 00       	push   $0x8022a2
  801881:	ff 75 0c             	pushl  0xc(%ebp)
  801884:	e8 60 ee ff ff       	call   8006e9 <strcpy>
	return 0;
}
  801889:	b8 00 00 00 00       	mov    $0x0,%eax
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	57                   	push   %edi
  801894:	56                   	push   %esi
  801895:	53                   	push   %ebx
  801896:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80189c:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8018a1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8018a7:	eb 2d                	jmp    8018d6 <devcons_write+0x46>
		m = n - tot;
  8018a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8018ac:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  8018ae:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8018b1:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8018b6:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8018b9:	83 ec 04             	sub    $0x4,%esp
  8018bc:	53                   	push   %ebx
  8018bd:	03 45 0c             	add    0xc(%ebp),%eax
  8018c0:	50                   	push   %eax
  8018c1:	57                   	push   %edi
  8018c2:	e8 b5 ef ff ff       	call   80087c <memmove>
		sys_cputs(buf, m);
  8018c7:	83 c4 08             	add    $0x8,%esp
  8018ca:	53                   	push   %ebx
  8018cb:	57                   	push   %edi
  8018cc:	e8 aa f1 ff ff       	call   800a7b <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8018d1:	01 de                	add    %ebx,%esi
  8018d3:	83 c4 10             	add    $0x10,%esp
  8018d6:	89 f0                	mov    %esi,%eax
  8018d8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8018db:	72 cc                	jb     8018a9 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018e0:	5b                   	pop    %ebx
  8018e1:	5e                   	pop    %esi
  8018e2:	5f                   	pop    %edi
  8018e3:	5d                   	pop    %ebp
  8018e4:	c3                   	ret    

008018e5 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	83 ec 08             	sub    $0x8,%esp
  8018eb:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  8018f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018f4:	74 2a                	je     801920 <devcons_read+0x3b>
  8018f6:	eb 05                	jmp    8018fd <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8018f8:	e8 0e f2 ff ff       	call   800b0b <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8018fd:	e8 9f f1 ff ff       	call   800aa1 <sys_cgetc>
  801902:	85 c0                	test   %eax,%eax
  801904:	74 f2                	je     8018f8 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801906:	85 c0                	test   %eax,%eax
  801908:	78 16                	js     801920 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80190a:	83 f8 04             	cmp    $0x4,%eax
  80190d:	74 0c                	je     80191b <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80190f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801912:	88 02                	mov    %al,(%edx)
	return 1;
  801914:	b8 01 00 00 00       	mov    $0x1,%eax
  801919:	eb 05                	jmp    801920 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80191b:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
  801925:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801928:	8b 45 08             	mov    0x8(%ebp),%eax
  80192b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80192e:	6a 01                	push   $0x1
  801930:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801933:	50                   	push   %eax
  801934:	e8 42 f1 ff ff       	call   800a7b <sys_cputs>
}
  801939:	83 c4 10             	add    $0x10,%esp
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <getchar>:

int
getchar(void)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801944:	6a 01                	push   $0x1
  801946:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801949:	50                   	push   %eax
  80194a:	6a 00                	push   $0x0
  80194c:	e8 6d f6 ff ff       	call   800fbe <read>
	if (r < 0)
  801951:	83 c4 10             	add    $0x10,%esp
  801954:	85 c0                	test   %eax,%eax
  801956:	78 0f                	js     801967 <getchar+0x29>
		return r;
	if (r < 1)
  801958:	85 c0                	test   %eax,%eax
  80195a:	7e 06                	jle    801962 <getchar+0x24>
		return -E_EOF;
	return c;
  80195c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801960:	eb 05                	jmp    801967 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801962:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80196f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801972:	50                   	push   %eax
  801973:	ff 75 08             	pushl  0x8(%ebp)
  801976:	e8 de f3 ff ff       	call   800d59 <fd_lookup>
  80197b:	83 c4 10             	add    $0x10,%esp
  80197e:	85 c0                	test   %eax,%eax
  801980:	78 11                	js     801993 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801985:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80198b:	39 10                	cmp    %edx,(%eax)
  80198d:	0f 94 c0             	sete   %al
  801990:	0f b6 c0             	movzbl %al,%eax
}
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <opencons>:

int
opencons(void)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
  801998:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80199b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80199e:	50                   	push   %eax
  80199f:	e8 66 f3 ff ff       	call   800d0a <fd_alloc>
  8019a4:	83 c4 10             	add    $0x10,%esp
		return r;
  8019a7:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8019a9:	85 c0                	test   %eax,%eax
  8019ab:	78 3e                	js     8019eb <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8019ad:	83 ec 04             	sub    $0x4,%esp
  8019b0:	68 07 04 00 00       	push   $0x407
  8019b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b8:	6a 00                	push   $0x0
  8019ba:	e8 73 f1 ff ff       	call   800b32 <sys_page_alloc>
  8019bf:	83 c4 10             	add    $0x10,%esp
		return r;
  8019c2:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8019c4:	85 c0                	test   %eax,%eax
  8019c6:	78 23                	js     8019eb <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8019c8:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8019ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d1:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8019d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8019dd:	83 ec 0c             	sub    $0xc,%esp
  8019e0:	50                   	push   %eax
  8019e1:	e8 fc f2 ff ff       	call   800ce2 <fd2num>
  8019e6:	89 c2                	mov    %eax,%edx
  8019e8:	83 c4 10             	add    $0x10,%esp
}
  8019eb:	89 d0                	mov    %edx,%eax
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
  8019f2:	56                   	push   %esi
  8019f3:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8019f4:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8019f7:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8019fd:	e8 e5 f0 ff ff       	call   800ae7 <sys_getenvid>
  801a02:	83 ec 0c             	sub    $0xc,%esp
  801a05:	ff 75 0c             	pushl  0xc(%ebp)
  801a08:	ff 75 08             	pushl  0x8(%ebp)
  801a0b:	56                   	push   %esi
  801a0c:	50                   	push   %eax
  801a0d:	68 b0 22 80 00       	push   $0x8022b0
  801a12:	e8 60 e7 ff ff       	call   800177 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801a17:	83 c4 18             	add    $0x18,%esp
  801a1a:	53                   	push   %ebx
  801a1b:	ff 75 10             	pushl  0x10(%ebp)
  801a1e:	e8 03 e7 ff ff       	call   800126 <vcprintf>
	cprintf("\n");
  801a23:	c7 04 24 9b 22 80 00 	movl   $0x80229b,(%esp)
  801a2a:	e8 48 e7 ff ff       	call   800177 <cprintf>
  801a2f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801a32:	cc                   	int3   
  801a33:	eb fd                	jmp    801a32 <_panic+0x43>

00801a35 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	56                   	push   %esi
  801a39:	53                   	push   %ebx
  801a3a:	8b 75 08             	mov    0x8(%ebp),%esi
  801a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a40:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801a43:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801a45:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801a4a:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801a4d:	83 ec 0c             	sub    $0xc,%esp
  801a50:	50                   	push   %eax
  801a51:	e8 d7 f1 ff ff       	call   800c2d <sys_ipc_recv>
	if (from_env_store)
  801a56:	83 c4 10             	add    $0x10,%esp
  801a59:	85 f6                	test   %esi,%esi
  801a5b:	74 0b                	je     801a68 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801a5d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a63:	8b 52 74             	mov    0x74(%edx),%edx
  801a66:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801a68:	85 db                	test   %ebx,%ebx
  801a6a:	74 0b                	je     801a77 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  801a6c:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a72:	8b 52 78             	mov    0x78(%edx),%edx
  801a75:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  801a77:	85 c0                	test   %eax,%eax
  801a79:	79 16                	jns    801a91 <ipc_recv+0x5c>
		if (from_env_store)
  801a7b:	85 f6                	test   %esi,%esi
  801a7d:	74 06                	je     801a85 <ipc_recv+0x50>
			*from_env_store = 0;
  801a7f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  801a85:	85 db                	test   %ebx,%ebx
  801a87:	74 10                	je     801a99 <ipc_recv+0x64>
			*perm_store = 0;
  801a89:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801a8f:	eb 08                	jmp    801a99 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  801a91:	a1 04 40 80 00       	mov    0x804004,%eax
  801a96:	8b 40 70             	mov    0x70(%eax),%eax
}
  801a99:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a9c:	5b                   	pop    %ebx
  801a9d:	5e                   	pop    %esi
  801a9e:	5d                   	pop    %ebp
  801a9f:	c3                   	ret    

00801aa0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	57                   	push   %edi
  801aa4:	56                   	push   %esi
  801aa5:	53                   	push   %ebx
  801aa6:	83 ec 0c             	sub    $0xc,%esp
  801aa9:	8b 7d 08             	mov    0x8(%ebp),%edi
  801aac:	8b 75 0c             	mov    0xc(%ebp),%esi
  801aaf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  801ab2:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  801ab4:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801ab9:	0f 44 d8             	cmove  %eax,%ebx
  801abc:	eb 1c                	jmp    801ada <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  801abe:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801ac1:	74 12                	je     801ad5 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801ac3:	50                   	push   %eax
  801ac4:	68 d4 22 80 00       	push   $0x8022d4
  801ac9:	6a 42                	push   $0x42
  801acb:	68 ea 22 80 00       	push   $0x8022ea
  801ad0:	e8 1a ff ff ff       	call   8019ef <_panic>
		sys_yield();
  801ad5:	e8 31 f0 ff ff       	call   800b0b <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801ada:	ff 75 14             	pushl  0x14(%ebp)
  801add:	53                   	push   %ebx
  801ade:	56                   	push   %esi
  801adf:	57                   	push   %edi
  801ae0:	e8 23 f1 ff ff       	call   800c08 <sys_ipc_try_send>
  801ae5:	83 c4 10             	add    $0x10,%esp
  801ae8:	85 c0                	test   %eax,%eax
  801aea:	75 d2                	jne    801abe <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801aec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aef:	5b                   	pop    %ebx
  801af0:	5e                   	pop    %esi
  801af1:	5f                   	pop    %edi
  801af2:	5d                   	pop    %ebp
  801af3:	c3                   	ret    

00801af4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
  801af7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801afa:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801aff:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801b02:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801b08:	8b 52 50             	mov    0x50(%edx),%edx
  801b0b:	39 ca                	cmp    %ecx,%edx
  801b0d:	75 0d                	jne    801b1c <ipc_find_env+0x28>
			return envs[i].env_id;
  801b0f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b12:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b17:	8b 40 48             	mov    0x48(%eax),%eax
  801b1a:	eb 0f                	jmp    801b2b <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801b1c:	83 c0 01             	add    $0x1,%eax
  801b1f:	3d 00 04 00 00       	cmp    $0x400,%eax
  801b24:	75 d9                	jne    801aff <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801b26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b2b:	5d                   	pop    %ebp
  801b2c:	c3                   	ret    

00801b2d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
  801b30:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b33:	89 d0                	mov    %edx,%eax
  801b35:	c1 e8 16             	shr    $0x16,%eax
  801b38:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801b3f:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b44:	f6 c1 01             	test   $0x1,%cl
  801b47:	74 1d                	je     801b66 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801b49:	c1 ea 0c             	shr    $0xc,%edx
  801b4c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801b53:	f6 c2 01             	test   $0x1,%dl
  801b56:	74 0e                	je     801b66 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801b58:	c1 ea 0c             	shr    $0xc,%edx
  801b5b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801b62:	ef 
  801b63:	0f b7 c0             	movzwl %ax,%eax
}
  801b66:	5d                   	pop    %ebp
  801b67:	c3                   	ret    
  801b68:	66 90                	xchg   %ax,%ax
  801b6a:	66 90                	xchg   %ax,%ax
  801b6c:	66 90                	xchg   %ax,%ax
  801b6e:	66 90                	xchg   %ax,%ax

00801b70 <__udivdi3>:
  801b70:	55                   	push   %ebp
  801b71:	57                   	push   %edi
  801b72:	56                   	push   %esi
  801b73:	53                   	push   %ebx
  801b74:	83 ec 1c             	sub    $0x1c,%esp
  801b77:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b7b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b7f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b87:	85 f6                	test   %esi,%esi
  801b89:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b8d:	89 ca                	mov    %ecx,%edx
  801b8f:	89 f8                	mov    %edi,%eax
  801b91:	75 3d                	jne    801bd0 <__udivdi3+0x60>
  801b93:	39 cf                	cmp    %ecx,%edi
  801b95:	0f 87 c5 00 00 00    	ja     801c60 <__udivdi3+0xf0>
  801b9b:	85 ff                	test   %edi,%edi
  801b9d:	89 fd                	mov    %edi,%ebp
  801b9f:	75 0b                	jne    801bac <__udivdi3+0x3c>
  801ba1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba6:	31 d2                	xor    %edx,%edx
  801ba8:	f7 f7                	div    %edi
  801baa:	89 c5                	mov    %eax,%ebp
  801bac:	89 c8                	mov    %ecx,%eax
  801bae:	31 d2                	xor    %edx,%edx
  801bb0:	f7 f5                	div    %ebp
  801bb2:	89 c1                	mov    %eax,%ecx
  801bb4:	89 d8                	mov    %ebx,%eax
  801bb6:	89 cf                	mov    %ecx,%edi
  801bb8:	f7 f5                	div    %ebp
  801bba:	89 c3                	mov    %eax,%ebx
  801bbc:	89 d8                	mov    %ebx,%eax
  801bbe:	89 fa                	mov    %edi,%edx
  801bc0:	83 c4 1c             	add    $0x1c,%esp
  801bc3:	5b                   	pop    %ebx
  801bc4:	5e                   	pop    %esi
  801bc5:	5f                   	pop    %edi
  801bc6:	5d                   	pop    %ebp
  801bc7:	c3                   	ret    
  801bc8:	90                   	nop
  801bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801bd0:	39 ce                	cmp    %ecx,%esi
  801bd2:	77 74                	ja     801c48 <__udivdi3+0xd8>
  801bd4:	0f bd fe             	bsr    %esi,%edi
  801bd7:	83 f7 1f             	xor    $0x1f,%edi
  801bda:	0f 84 98 00 00 00    	je     801c78 <__udivdi3+0x108>
  801be0:	bb 20 00 00 00       	mov    $0x20,%ebx
  801be5:	89 f9                	mov    %edi,%ecx
  801be7:	89 c5                	mov    %eax,%ebp
  801be9:	29 fb                	sub    %edi,%ebx
  801beb:	d3 e6                	shl    %cl,%esi
  801bed:	89 d9                	mov    %ebx,%ecx
  801bef:	d3 ed                	shr    %cl,%ebp
  801bf1:	89 f9                	mov    %edi,%ecx
  801bf3:	d3 e0                	shl    %cl,%eax
  801bf5:	09 ee                	or     %ebp,%esi
  801bf7:	89 d9                	mov    %ebx,%ecx
  801bf9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bfd:	89 d5                	mov    %edx,%ebp
  801bff:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c03:	d3 ed                	shr    %cl,%ebp
  801c05:	89 f9                	mov    %edi,%ecx
  801c07:	d3 e2                	shl    %cl,%edx
  801c09:	89 d9                	mov    %ebx,%ecx
  801c0b:	d3 e8                	shr    %cl,%eax
  801c0d:	09 c2                	or     %eax,%edx
  801c0f:	89 d0                	mov    %edx,%eax
  801c11:	89 ea                	mov    %ebp,%edx
  801c13:	f7 f6                	div    %esi
  801c15:	89 d5                	mov    %edx,%ebp
  801c17:	89 c3                	mov    %eax,%ebx
  801c19:	f7 64 24 0c          	mull   0xc(%esp)
  801c1d:	39 d5                	cmp    %edx,%ebp
  801c1f:	72 10                	jb     801c31 <__udivdi3+0xc1>
  801c21:	8b 74 24 08          	mov    0x8(%esp),%esi
  801c25:	89 f9                	mov    %edi,%ecx
  801c27:	d3 e6                	shl    %cl,%esi
  801c29:	39 c6                	cmp    %eax,%esi
  801c2b:	73 07                	jae    801c34 <__udivdi3+0xc4>
  801c2d:	39 d5                	cmp    %edx,%ebp
  801c2f:	75 03                	jne    801c34 <__udivdi3+0xc4>
  801c31:	83 eb 01             	sub    $0x1,%ebx
  801c34:	31 ff                	xor    %edi,%edi
  801c36:	89 d8                	mov    %ebx,%eax
  801c38:	89 fa                	mov    %edi,%edx
  801c3a:	83 c4 1c             	add    $0x1c,%esp
  801c3d:	5b                   	pop    %ebx
  801c3e:	5e                   	pop    %esi
  801c3f:	5f                   	pop    %edi
  801c40:	5d                   	pop    %ebp
  801c41:	c3                   	ret    
  801c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c48:	31 ff                	xor    %edi,%edi
  801c4a:	31 db                	xor    %ebx,%ebx
  801c4c:	89 d8                	mov    %ebx,%eax
  801c4e:	89 fa                	mov    %edi,%edx
  801c50:	83 c4 1c             	add    $0x1c,%esp
  801c53:	5b                   	pop    %ebx
  801c54:	5e                   	pop    %esi
  801c55:	5f                   	pop    %edi
  801c56:	5d                   	pop    %ebp
  801c57:	c3                   	ret    
  801c58:	90                   	nop
  801c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c60:	89 d8                	mov    %ebx,%eax
  801c62:	f7 f7                	div    %edi
  801c64:	31 ff                	xor    %edi,%edi
  801c66:	89 c3                	mov    %eax,%ebx
  801c68:	89 d8                	mov    %ebx,%eax
  801c6a:	89 fa                	mov    %edi,%edx
  801c6c:	83 c4 1c             	add    $0x1c,%esp
  801c6f:	5b                   	pop    %ebx
  801c70:	5e                   	pop    %esi
  801c71:	5f                   	pop    %edi
  801c72:	5d                   	pop    %ebp
  801c73:	c3                   	ret    
  801c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801c78:	39 ce                	cmp    %ecx,%esi
  801c7a:	72 0c                	jb     801c88 <__udivdi3+0x118>
  801c7c:	31 db                	xor    %ebx,%ebx
  801c7e:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c82:	0f 87 34 ff ff ff    	ja     801bbc <__udivdi3+0x4c>
  801c88:	bb 01 00 00 00       	mov    $0x1,%ebx
  801c8d:	e9 2a ff ff ff       	jmp    801bbc <__udivdi3+0x4c>
  801c92:	66 90                	xchg   %ax,%ax
  801c94:	66 90                	xchg   %ax,%ax
  801c96:	66 90                	xchg   %ax,%ax
  801c98:	66 90                	xchg   %ax,%ax
  801c9a:	66 90                	xchg   %ax,%ax
  801c9c:	66 90                	xchg   %ax,%ax
  801c9e:	66 90                	xchg   %ax,%ax

00801ca0 <__umoddi3>:
  801ca0:	55                   	push   %ebp
  801ca1:	57                   	push   %edi
  801ca2:	56                   	push   %esi
  801ca3:	53                   	push   %ebx
  801ca4:	83 ec 1c             	sub    $0x1c,%esp
  801ca7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801cab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801caf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cb7:	85 d2                	test   %edx,%edx
  801cb9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801cbd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cc1:	89 f3                	mov    %esi,%ebx
  801cc3:	89 3c 24             	mov    %edi,(%esp)
  801cc6:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cca:	75 1c                	jne    801ce8 <__umoddi3+0x48>
  801ccc:	39 f7                	cmp    %esi,%edi
  801cce:	76 50                	jbe    801d20 <__umoddi3+0x80>
  801cd0:	89 c8                	mov    %ecx,%eax
  801cd2:	89 f2                	mov    %esi,%edx
  801cd4:	f7 f7                	div    %edi
  801cd6:	89 d0                	mov    %edx,%eax
  801cd8:	31 d2                	xor    %edx,%edx
  801cda:	83 c4 1c             	add    $0x1c,%esp
  801cdd:	5b                   	pop    %ebx
  801cde:	5e                   	pop    %esi
  801cdf:	5f                   	pop    %edi
  801ce0:	5d                   	pop    %ebp
  801ce1:	c3                   	ret    
  801ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801ce8:	39 f2                	cmp    %esi,%edx
  801cea:	89 d0                	mov    %edx,%eax
  801cec:	77 52                	ja     801d40 <__umoddi3+0xa0>
  801cee:	0f bd ea             	bsr    %edx,%ebp
  801cf1:	83 f5 1f             	xor    $0x1f,%ebp
  801cf4:	75 5a                	jne    801d50 <__umoddi3+0xb0>
  801cf6:	3b 54 24 04          	cmp    0x4(%esp),%edx
  801cfa:	0f 82 e0 00 00 00    	jb     801de0 <__umoddi3+0x140>
  801d00:	39 0c 24             	cmp    %ecx,(%esp)
  801d03:	0f 86 d7 00 00 00    	jbe    801de0 <__umoddi3+0x140>
  801d09:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d0d:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d11:	83 c4 1c             	add    $0x1c,%esp
  801d14:	5b                   	pop    %ebx
  801d15:	5e                   	pop    %esi
  801d16:	5f                   	pop    %edi
  801d17:	5d                   	pop    %ebp
  801d18:	c3                   	ret    
  801d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d20:	85 ff                	test   %edi,%edi
  801d22:	89 fd                	mov    %edi,%ebp
  801d24:	75 0b                	jne    801d31 <__umoddi3+0x91>
  801d26:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2b:	31 d2                	xor    %edx,%edx
  801d2d:	f7 f7                	div    %edi
  801d2f:	89 c5                	mov    %eax,%ebp
  801d31:	89 f0                	mov    %esi,%eax
  801d33:	31 d2                	xor    %edx,%edx
  801d35:	f7 f5                	div    %ebp
  801d37:	89 c8                	mov    %ecx,%eax
  801d39:	f7 f5                	div    %ebp
  801d3b:	89 d0                	mov    %edx,%eax
  801d3d:	eb 99                	jmp    801cd8 <__umoddi3+0x38>
  801d3f:	90                   	nop
  801d40:	89 c8                	mov    %ecx,%eax
  801d42:	89 f2                	mov    %esi,%edx
  801d44:	83 c4 1c             	add    $0x1c,%esp
  801d47:	5b                   	pop    %ebx
  801d48:	5e                   	pop    %esi
  801d49:	5f                   	pop    %edi
  801d4a:	5d                   	pop    %ebp
  801d4b:	c3                   	ret    
  801d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801d50:	8b 34 24             	mov    (%esp),%esi
  801d53:	bf 20 00 00 00       	mov    $0x20,%edi
  801d58:	89 e9                	mov    %ebp,%ecx
  801d5a:	29 ef                	sub    %ebp,%edi
  801d5c:	d3 e0                	shl    %cl,%eax
  801d5e:	89 f9                	mov    %edi,%ecx
  801d60:	89 f2                	mov    %esi,%edx
  801d62:	d3 ea                	shr    %cl,%edx
  801d64:	89 e9                	mov    %ebp,%ecx
  801d66:	09 c2                	or     %eax,%edx
  801d68:	89 d8                	mov    %ebx,%eax
  801d6a:	89 14 24             	mov    %edx,(%esp)
  801d6d:	89 f2                	mov    %esi,%edx
  801d6f:	d3 e2                	shl    %cl,%edx
  801d71:	89 f9                	mov    %edi,%ecx
  801d73:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d77:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801d7b:	d3 e8                	shr    %cl,%eax
  801d7d:	89 e9                	mov    %ebp,%ecx
  801d7f:	89 c6                	mov    %eax,%esi
  801d81:	d3 e3                	shl    %cl,%ebx
  801d83:	89 f9                	mov    %edi,%ecx
  801d85:	89 d0                	mov    %edx,%eax
  801d87:	d3 e8                	shr    %cl,%eax
  801d89:	89 e9                	mov    %ebp,%ecx
  801d8b:	09 d8                	or     %ebx,%eax
  801d8d:	89 d3                	mov    %edx,%ebx
  801d8f:	89 f2                	mov    %esi,%edx
  801d91:	f7 34 24             	divl   (%esp)
  801d94:	89 d6                	mov    %edx,%esi
  801d96:	d3 e3                	shl    %cl,%ebx
  801d98:	f7 64 24 04          	mull   0x4(%esp)
  801d9c:	39 d6                	cmp    %edx,%esi
  801d9e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801da2:	89 d1                	mov    %edx,%ecx
  801da4:	89 c3                	mov    %eax,%ebx
  801da6:	72 08                	jb     801db0 <__umoddi3+0x110>
  801da8:	75 11                	jne    801dbb <__umoddi3+0x11b>
  801daa:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801dae:	73 0b                	jae    801dbb <__umoddi3+0x11b>
  801db0:	2b 44 24 04          	sub    0x4(%esp),%eax
  801db4:	1b 14 24             	sbb    (%esp),%edx
  801db7:	89 d1                	mov    %edx,%ecx
  801db9:	89 c3                	mov    %eax,%ebx
  801dbb:	8b 54 24 08          	mov    0x8(%esp),%edx
  801dbf:	29 da                	sub    %ebx,%edx
  801dc1:	19 ce                	sbb    %ecx,%esi
  801dc3:	89 f9                	mov    %edi,%ecx
  801dc5:	89 f0                	mov    %esi,%eax
  801dc7:	d3 e0                	shl    %cl,%eax
  801dc9:	89 e9                	mov    %ebp,%ecx
  801dcb:	d3 ea                	shr    %cl,%edx
  801dcd:	89 e9                	mov    %ebp,%ecx
  801dcf:	d3 ee                	shr    %cl,%esi
  801dd1:	09 d0                	or     %edx,%eax
  801dd3:	89 f2                	mov    %esi,%edx
  801dd5:	83 c4 1c             	add    $0x1c,%esp
  801dd8:	5b                   	pop    %ebx
  801dd9:	5e                   	pop    %esi
  801dda:	5f                   	pop    %edi
  801ddb:	5d                   	pop    %ebp
  801ddc:	c3                   	ret    
  801ddd:	8d 76 00             	lea    0x0(%esi),%esi
  801de0:	29 f9                	sub    %edi,%ecx
  801de2:	19 d6                	sbb    %edx,%esi
  801de4:	89 74 24 04          	mov    %esi,0x4(%esp)
  801de8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801dec:	e9 18 ff ff ff       	jmp    801d09 <__umoddi3+0x69>
