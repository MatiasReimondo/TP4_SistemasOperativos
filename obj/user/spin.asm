
obj/user/spin.debug:     formato del fichero elf32-i386


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
  80002c:	e8 84 00 00 00       	call   8000b5 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 10             	sub    $0x10,%esp
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  80003a:	68 00 23 80 00       	push   $0x802300
  80003f:	e8 68 01 00 00       	call   8001ac <cprintf>
	if ((env = fork()) == 0) {
  800044:	e8 c5 0f 00 00       	call   80100e <fork>
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	85 c0                	test   %eax,%eax
  80004e:	75 12                	jne    800062 <umain+0x2f>
		cprintf("I am the child.  Spinning...\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 78 23 80 00       	push   $0x802378
  800058:	e8 4f 01 00 00       	call   8001ac <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	eb fe                	jmp    800060 <umain+0x2d>
  800062:	89 c3                	mov    %eax,%ebx
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  800064:	83 ec 0c             	sub    $0xc,%esp
  800067:	68 28 23 80 00       	push   $0x802328
  80006c:	e8 3b 01 00 00       	call   8001ac <cprintf>
	sys_yield();
  800071:	e8 ca 0a 00 00       	call   800b40 <sys_yield>
	sys_yield();
  800076:	e8 c5 0a 00 00       	call   800b40 <sys_yield>
	sys_yield();
  80007b:	e8 c0 0a 00 00       	call   800b40 <sys_yield>
	sys_yield();
  800080:	e8 bb 0a 00 00       	call   800b40 <sys_yield>
	sys_yield();
  800085:	e8 b6 0a 00 00       	call   800b40 <sys_yield>
	sys_yield();
  80008a:	e8 b1 0a 00 00       	call   800b40 <sys_yield>
	sys_yield();
  80008f:	e8 ac 0a 00 00       	call   800b40 <sys_yield>
	sys_yield();
  800094:	e8 a7 0a 00 00       	call   800b40 <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  800099:	c7 04 24 50 23 80 00 	movl   $0x802350,(%esp)
  8000a0:	e8 07 01 00 00       	call   8001ac <cprintf>
	sys_env_destroy(env);
  8000a5:	89 1c 24             	mov    %ebx,(%esp)
  8000a8:	e8 4d 0a 00 00       	call   800afa <sys_env_destroy>
}
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    

008000b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
  8000ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000bd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8000c0:	e8 57 0a 00 00       	call   800b1c <sys_getenvid>
	if (id >= 0)
  8000c5:	85 c0                	test   %eax,%eax
  8000c7:	78 12                	js     8000db <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  8000c9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ce:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000d1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000d6:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000db:	85 db                	test   %ebx,%ebx
  8000dd:	7e 07                	jle    8000e6 <libmain+0x31>
		binaryname = argv[0];
  8000df:	8b 06                	mov    (%esi),%eax
  8000e1:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000e6:	83 ec 08             	sub    $0x8,%esp
  8000e9:	56                   	push   %esi
  8000ea:	53                   	push   %ebx
  8000eb:	e8 43 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000f0:	e8 0a 00 00 00       	call   8000ff <exit>
}
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000fb:	5b                   	pop    %ebx
  8000fc:	5e                   	pop    %esi
  8000fd:	5d                   	pop    %ebp
  8000fe:	c3                   	ret    

008000ff <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ff:	55                   	push   %ebp
  800100:	89 e5                	mov    %esp,%ebp
  800102:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800105:	e8 fc 11 00 00       	call   801306 <close_all>
	sys_env_destroy(0);
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	6a 00                	push   $0x0
  80010f:	e8 e6 09 00 00       	call   800afa <sys_env_destroy>
}
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	c9                   	leave  
  800118:	c3                   	ret    

00800119 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800119:	55                   	push   %ebp
  80011a:	89 e5                	mov    %esp,%ebp
  80011c:	53                   	push   %ebx
  80011d:	83 ec 04             	sub    $0x4,%esp
  800120:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800123:	8b 13                	mov    (%ebx),%edx
  800125:	8d 42 01             	lea    0x1(%edx),%eax
  800128:	89 03                	mov    %eax,(%ebx)
  80012a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80012d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800131:	3d ff 00 00 00       	cmp    $0xff,%eax
  800136:	75 1a                	jne    800152 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  800138:	83 ec 08             	sub    $0x8,%esp
  80013b:	68 ff 00 00 00       	push   $0xff
  800140:	8d 43 08             	lea    0x8(%ebx),%eax
  800143:	50                   	push   %eax
  800144:	e8 67 09 00 00       	call   800ab0 <sys_cputs>
		b->idx = 0;
  800149:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80014f:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  800152:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800156:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800159:	c9                   	leave  
  80015a:	c3                   	ret    

0080015b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800164:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80016b:	00 00 00 
	b.cnt = 0;
  80016e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800175:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800178:	ff 75 0c             	pushl  0xc(%ebp)
  80017b:	ff 75 08             	pushl  0x8(%ebp)
  80017e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800184:	50                   	push   %eax
  800185:	68 19 01 80 00       	push   $0x800119
  80018a:	e8 86 01 00 00       	call   800315 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80018f:	83 c4 08             	add    $0x8,%esp
  800192:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800198:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80019e:	50                   	push   %eax
  80019f:	e8 0c 09 00 00       	call   800ab0 <sys_cputs>

	return b.cnt;
}
  8001a4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001aa:	c9                   	leave  
  8001ab:	c3                   	ret    

008001ac <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b5:	50                   	push   %eax
  8001b6:	ff 75 08             	pushl  0x8(%ebp)
  8001b9:	e8 9d ff ff ff       	call   80015b <vcprintf>
	va_end(ap);

	return cnt;
}
  8001be:	c9                   	leave  
  8001bf:	c3                   	ret    

008001c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	57                   	push   %edi
  8001c4:	56                   	push   %esi
  8001c5:	53                   	push   %ebx
  8001c6:	83 ec 1c             	sub    $0x1c,%esp
  8001c9:	89 c7                	mov    %eax,%edi
  8001cb:	89 d6                	mov    %edx,%esi
  8001cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001e4:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001e7:	39 d3                	cmp    %edx,%ebx
  8001e9:	72 05                	jb     8001f0 <printnum+0x30>
  8001eb:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001ee:	77 45                	ja     800235 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	ff 75 18             	pushl  0x18(%ebp)
  8001f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8001f9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001fc:	53                   	push   %ebx
  8001fd:	ff 75 10             	pushl  0x10(%ebp)
  800200:	83 ec 08             	sub    $0x8,%esp
  800203:	ff 75 e4             	pushl  -0x1c(%ebp)
  800206:	ff 75 e0             	pushl  -0x20(%ebp)
  800209:	ff 75 dc             	pushl  -0x24(%ebp)
  80020c:	ff 75 d8             	pushl  -0x28(%ebp)
  80020f:	e8 4c 1e 00 00       	call   802060 <__udivdi3>
  800214:	83 c4 18             	add    $0x18,%esp
  800217:	52                   	push   %edx
  800218:	50                   	push   %eax
  800219:	89 f2                	mov    %esi,%edx
  80021b:	89 f8                	mov    %edi,%eax
  80021d:	e8 9e ff ff ff       	call   8001c0 <printnum>
  800222:	83 c4 20             	add    $0x20,%esp
  800225:	eb 18                	jmp    80023f <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800227:	83 ec 08             	sub    $0x8,%esp
  80022a:	56                   	push   %esi
  80022b:	ff 75 18             	pushl  0x18(%ebp)
  80022e:	ff d7                	call   *%edi
  800230:	83 c4 10             	add    $0x10,%esp
  800233:	eb 03                	jmp    800238 <printnum+0x78>
  800235:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800238:	83 eb 01             	sub    $0x1,%ebx
  80023b:	85 db                	test   %ebx,%ebx
  80023d:	7f e8                	jg     800227 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80023f:	83 ec 08             	sub    $0x8,%esp
  800242:	56                   	push   %esi
  800243:	83 ec 04             	sub    $0x4,%esp
  800246:	ff 75 e4             	pushl  -0x1c(%ebp)
  800249:	ff 75 e0             	pushl  -0x20(%ebp)
  80024c:	ff 75 dc             	pushl  -0x24(%ebp)
  80024f:	ff 75 d8             	pushl  -0x28(%ebp)
  800252:	e8 39 1f 00 00       	call   802190 <__umoddi3>
  800257:	83 c4 14             	add    $0x14,%esp
  80025a:	0f be 80 a0 23 80 00 	movsbl 0x8023a0(%eax),%eax
  800261:	50                   	push   %eax
  800262:	ff d7                	call   *%edi
}
  800264:	83 c4 10             	add    $0x10,%esp
  800267:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026a:	5b                   	pop    %ebx
  80026b:	5e                   	pop    %esi
  80026c:	5f                   	pop    %edi
  80026d:	5d                   	pop    %ebp
  80026e:	c3                   	ret    

0080026f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800272:	83 fa 01             	cmp    $0x1,%edx
  800275:	7e 0e                	jle    800285 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800277:	8b 10                	mov    (%eax),%edx
  800279:	8d 4a 08             	lea    0x8(%edx),%ecx
  80027c:	89 08                	mov    %ecx,(%eax)
  80027e:	8b 02                	mov    (%edx),%eax
  800280:	8b 52 04             	mov    0x4(%edx),%edx
  800283:	eb 22                	jmp    8002a7 <getuint+0x38>
	else if (lflag)
  800285:	85 d2                	test   %edx,%edx
  800287:	74 10                	je     800299 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800289:	8b 10                	mov    (%eax),%edx
  80028b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80028e:	89 08                	mov    %ecx,(%eax)
  800290:	8b 02                	mov    (%edx),%eax
  800292:	ba 00 00 00 00       	mov    $0x0,%edx
  800297:	eb 0e                	jmp    8002a7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800299:	8b 10                	mov    (%eax),%edx
  80029b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80029e:	89 08                	mov    %ecx,(%eax)
  8002a0:	8b 02                	mov    (%edx),%eax
  8002a2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002a7:	5d                   	pop    %ebp
  8002a8:	c3                   	ret    

008002a9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002ac:	83 fa 01             	cmp    $0x1,%edx
  8002af:	7e 0e                	jle    8002bf <getint+0x16>
		return va_arg(*ap, long long);
  8002b1:	8b 10                	mov    (%eax),%edx
  8002b3:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002b6:	89 08                	mov    %ecx,(%eax)
  8002b8:	8b 02                	mov    (%edx),%eax
  8002ba:	8b 52 04             	mov    0x4(%edx),%edx
  8002bd:	eb 1a                	jmp    8002d9 <getint+0x30>
	else if (lflag)
  8002bf:	85 d2                	test   %edx,%edx
  8002c1:	74 0c                	je     8002cf <getint+0x26>
		return va_arg(*ap, long);
  8002c3:	8b 10                	mov    (%eax),%edx
  8002c5:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002c8:	89 08                	mov    %ecx,(%eax)
  8002ca:	8b 02                	mov    (%edx),%eax
  8002cc:	99                   	cltd   
  8002cd:	eb 0a                	jmp    8002d9 <getint+0x30>
	else
		return va_arg(*ap, int);
  8002cf:	8b 10                	mov    (%eax),%edx
  8002d1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002d4:	89 08                	mov    %ecx,(%eax)
  8002d6:	8b 02                	mov    (%edx),%eax
  8002d8:	99                   	cltd   
}
  8002d9:	5d                   	pop    %ebp
  8002da:	c3                   	ret    

008002db <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002e1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002e5:	8b 10                	mov    (%eax),%edx
  8002e7:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ea:	73 0a                	jae    8002f6 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002ec:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002ef:	89 08                	mov    %ecx,(%eax)
  8002f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f4:	88 02                	mov    %al,(%edx)
}
  8002f6:	5d                   	pop    %ebp
  8002f7:	c3                   	ret    

008002f8 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8002f8:	55                   	push   %ebp
  8002f9:	89 e5                	mov    %esp,%ebp
  8002fb:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8002fe:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800301:	50                   	push   %eax
  800302:	ff 75 10             	pushl  0x10(%ebp)
  800305:	ff 75 0c             	pushl  0xc(%ebp)
  800308:	ff 75 08             	pushl  0x8(%ebp)
  80030b:	e8 05 00 00 00       	call   800315 <vprintfmt>
	va_end(ap);
}
  800310:	83 c4 10             	add    $0x10,%esp
  800313:	c9                   	leave  
  800314:	c3                   	ret    

00800315 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	57                   	push   %edi
  800319:	56                   	push   %esi
  80031a:	53                   	push   %ebx
  80031b:	83 ec 2c             	sub    $0x2c,%esp
  80031e:	8b 75 08             	mov    0x8(%ebp),%esi
  800321:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800324:	8b 7d 10             	mov    0x10(%ebp),%edi
  800327:	eb 12                	jmp    80033b <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800329:	85 c0                	test   %eax,%eax
  80032b:	0f 84 44 03 00 00    	je     800675 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  800331:	83 ec 08             	sub    $0x8,%esp
  800334:	53                   	push   %ebx
  800335:	50                   	push   %eax
  800336:	ff d6                	call   *%esi
  800338:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80033b:	83 c7 01             	add    $0x1,%edi
  80033e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800342:	83 f8 25             	cmp    $0x25,%eax
  800345:	75 e2                	jne    800329 <vprintfmt+0x14>
  800347:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  80034b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800352:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800359:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800360:	ba 00 00 00 00       	mov    $0x0,%edx
  800365:	eb 07                	jmp    80036e <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800367:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  80036a:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80036e:	8d 47 01             	lea    0x1(%edi),%eax
  800371:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800374:	0f b6 07             	movzbl (%edi),%eax
  800377:	0f b6 c8             	movzbl %al,%ecx
  80037a:	83 e8 23             	sub    $0x23,%eax
  80037d:	3c 55                	cmp    $0x55,%al
  80037f:	0f 87 d5 02 00 00    	ja     80065a <vprintfmt+0x345>
  800385:	0f b6 c0             	movzbl %al,%eax
  800388:	ff 24 85 e0 24 80 00 	jmp    *0x8024e0(,%eax,4)
  80038f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800392:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800396:	eb d6                	jmp    80036e <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800398:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80039b:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003a3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003a6:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8003aa:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8003ad:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8003b0:	83 fa 09             	cmp    $0x9,%edx
  8003b3:	77 39                	ja     8003ee <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003b5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003b8:	eb e9                	jmp    8003a3 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bd:	8d 48 04             	lea    0x4(%eax),%ecx
  8003c0:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8003c3:	8b 00                	mov    (%eax),%eax
  8003c5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003cb:	eb 27                	jmp    8003f4 <vprintfmt+0xdf>
  8003cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d0:	85 c0                	test   %eax,%eax
  8003d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003d7:	0f 49 c8             	cmovns %eax,%ecx
  8003da:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003e0:	eb 8c                	jmp    80036e <vprintfmt+0x59>
  8003e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8003e5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003ec:	eb 80                	jmp    80036e <vprintfmt+0x59>
  8003ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003f1:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  8003f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003f8:	0f 89 70 ff ff ff    	jns    80036e <vprintfmt+0x59>
				width = precision, precision = -1;
  8003fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800401:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800404:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80040b:	e9 5e ff ff ff       	jmp    80036e <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800410:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800413:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800416:	e9 53 ff ff ff       	jmp    80036e <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80041b:	8b 45 14             	mov    0x14(%ebp),%eax
  80041e:	8d 50 04             	lea    0x4(%eax),%edx
  800421:	89 55 14             	mov    %edx,0x14(%ebp)
  800424:	83 ec 08             	sub    $0x8,%esp
  800427:	53                   	push   %ebx
  800428:	ff 30                	pushl  (%eax)
  80042a:	ff d6                	call   *%esi
			break;
  80042c:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80042f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800432:	e9 04 ff ff ff       	jmp    80033b <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800437:	8b 45 14             	mov    0x14(%ebp),%eax
  80043a:	8d 50 04             	lea    0x4(%eax),%edx
  80043d:	89 55 14             	mov    %edx,0x14(%ebp)
  800440:	8b 00                	mov    (%eax),%eax
  800442:	99                   	cltd   
  800443:	31 d0                	xor    %edx,%eax
  800445:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800447:	83 f8 0f             	cmp    $0xf,%eax
  80044a:	7f 0b                	jg     800457 <vprintfmt+0x142>
  80044c:	8b 14 85 40 26 80 00 	mov    0x802640(,%eax,4),%edx
  800453:	85 d2                	test   %edx,%edx
  800455:	75 18                	jne    80046f <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  800457:	50                   	push   %eax
  800458:	68 b8 23 80 00       	push   $0x8023b8
  80045d:	53                   	push   %ebx
  80045e:	56                   	push   %esi
  80045f:	e8 94 fe ff ff       	call   8002f8 <printfmt>
  800464:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800467:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80046a:	e9 cc fe ff ff       	jmp    80033b <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  80046f:	52                   	push   %edx
  800470:	68 d5 28 80 00       	push   $0x8028d5
  800475:	53                   	push   %ebx
  800476:	56                   	push   %esi
  800477:	e8 7c fe ff ff       	call   8002f8 <printfmt>
  80047c:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80047f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800482:	e9 b4 fe ff ff       	jmp    80033b <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800487:	8b 45 14             	mov    0x14(%ebp),%eax
  80048a:	8d 50 04             	lea    0x4(%eax),%edx
  80048d:	89 55 14             	mov    %edx,0x14(%ebp)
  800490:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800492:	85 ff                	test   %edi,%edi
  800494:	b8 b1 23 80 00       	mov    $0x8023b1,%eax
  800499:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80049c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004a0:	0f 8e 94 00 00 00    	jle    80053a <vprintfmt+0x225>
  8004a6:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004aa:	0f 84 98 00 00 00    	je     800548 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b0:	83 ec 08             	sub    $0x8,%esp
  8004b3:	ff 75 d0             	pushl  -0x30(%ebp)
  8004b6:	57                   	push   %edi
  8004b7:	e8 41 02 00 00       	call   8006fd <strnlen>
  8004bc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004bf:	29 c1                	sub    %eax,%ecx
  8004c1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8004c4:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004c7:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ce:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004d1:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d3:	eb 0f                	jmp    8004e4 <vprintfmt+0x1cf>
					putch(padc, putdat);
  8004d5:	83 ec 08             	sub    $0x8,%esp
  8004d8:	53                   	push   %ebx
  8004d9:	ff 75 e0             	pushl  -0x20(%ebp)
  8004dc:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004de:	83 ef 01             	sub    $0x1,%edi
  8004e1:	83 c4 10             	add    $0x10,%esp
  8004e4:	85 ff                	test   %edi,%edi
  8004e6:	7f ed                	jg     8004d5 <vprintfmt+0x1c0>
  8004e8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004eb:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8004ee:	85 c9                	test   %ecx,%ecx
  8004f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f5:	0f 49 c1             	cmovns %ecx,%eax
  8004f8:	29 c1                	sub    %eax,%ecx
  8004fa:	89 75 08             	mov    %esi,0x8(%ebp)
  8004fd:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800500:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800503:	89 cb                	mov    %ecx,%ebx
  800505:	eb 4d                	jmp    800554 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800507:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80050b:	74 1b                	je     800528 <vprintfmt+0x213>
  80050d:	0f be c0             	movsbl %al,%eax
  800510:	83 e8 20             	sub    $0x20,%eax
  800513:	83 f8 5e             	cmp    $0x5e,%eax
  800516:	76 10                	jbe    800528 <vprintfmt+0x213>
					putch('?', putdat);
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	ff 75 0c             	pushl  0xc(%ebp)
  80051e:	6a 3f                	push   $0x3f
  800520:	ff 55 08             	call   *0x8(%ebp)
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	eb 0d                	jmp    800535 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  800528:	83 ec 08             	sub    $0x8,%esp
  80052b:	ff 75 0c             	pushl  0xc(%ebp)
  80052e:	52                   	push   %edx
  80052f:	ff 55 08             	call   *0x8(%ebp)
  800532:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800535:	83 eb 01             	sub    $0x1,%ebx
  800538:	eb 1a                	jmp    800554 <vprintfmt+0x23f>
  80053a:	89 75 08             	mov    %esi,0x8(%ebp)
  80053d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800540:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800543:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800546:	eb 0c                	jmp    800554 <vprintfmt+0x23f>
  800548:	89 75 08             	mov    %esi,0x8(%ebp)
  80054b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80054e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800551:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800554:	83 c7 01             	add    $0x1,%edi
  800557:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80055b:	0f be d0             	movsbl %al,%edx
  80055e:	85 d2                	test   %edx,%edx
  800560:	74 23                	je     800585 <vprintfmt+0x270>
  800562:	85 f6                	test   %esi,%esi
  800564:	78 a1                	js     800507 <vprintfmt+0x1f2>
  800566:	83 ee 01             	sub    $0x1,%esi
  800569:	79 9c                	jns    800507 <vprintfmt+0x1f2>
  80056b:	89 df                	mov    %ebx,%edi
  80056d:	8b 75 08             	mov    0x8(%ebp),%esi
  800570:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800573:	eb 18                	jmp    80058d <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800575:	83 ec 08             	sub    $0x8,%esp
  800578:	53                   	push   %ebx
  800579:	6a 20                	push   $0x20
  80057b:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80057d:	83 ef 01             	sub    $0x1,%edi
  800580:	83 c4 10             	add    $0x10,%esp
  800583:	eb 08                	jmp    80058d <vprintfmt+0x278>
  800585:	89 df                	mov    %ebx,%edi
  800587:	8b 75 08             	mov    0x8(%ebp),%esi
  80058a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80058d:	85 ff                	test   %edi,%edi
  80058f:	7f e4                	jg     800575 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800591:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800594:	e9 a2 fd ff ff       	jmp    80033b <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800599:	8d 45 14             	lea    0x14(%ebp),%eax
  80059c:	e8 08 fd ff ff       	call   8002a9 <getint>
  8005a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8005a7:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8005ac:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005b0:	79 74                	jns    800626 <vprintfmt+0x311>
				putch('-', putdat);
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	53                   	push   %ebx
  8005b6:	6a 2d                	push   $0x2d
  8005b8:	ff d6                	call   *%esi
				num = -(long long) num;
  8005ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005bd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005c0:	f7 d8                	neg    %eax
  8005c2:	83 d2 00             	adc    $0x0,%edx
  8005c5:	f7 da                	neg    %edx
  8005c7:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8005ca:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8005cf:	eb 55                	jmp    800626 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8005d1:	8d 45 14             	lea    0x14(%ebp),%eax
  8005d4:	e8 96 fc ff ff       	call   80026f <getuint>
			base = 10;
  8005d9:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8005de:	eb 46                	jmp    800626 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8005e0:	8d 45 14             	lea    0x14(%ebp),%eax
  8005e3:	e8 87 fc ff ff       	call   80026f <getuint>
			base = 8;
  8005e8:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8005ed:	eb 37                	jmp    800626 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  8005ef:	83 ec 08             	sub    $0x8,%esp
  8005f2:	53                   	push   %ebx
  8005f3:	6a 30                	push   $0x30
  8005f5:	ff d6                	call   *%esi
			putch('x', putdat);
  8005f7:	83 c4 08             	add    $0x8,%esp
  8005fa:	53                   	push   %ebx
  8005fb:	6a 78                	push   $0x78
  8005fd:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8005ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800602:	8d 50 04             	lea    0x4(%eax),%edx
  800605:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800608:	8b 00                	mov    (%eax),%eax
  80060a:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  80060f:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800612:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800617:	eb 0d                	jmp    800626 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800619:	8d 45 14             	lea    0x14(%ebp),%eax
  80061c:	e8 4e fc ff ff       	call   80026f <getuint>
			base = 16;
  800621:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800626:	83 ec 0c             	sub    $0xc,%esp
  800629:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80062d:	57                   	push   %edi
  80062e:	ff 75 e0             	pushl  -0x20(%ebp)
  800631:	51                   	push   %ecx
  800632:	52                   	push   %edx
  800633:	50                   	push   %eax
  800634:	89 da                	mov    %ebx,%edx
  800636:	89 f0                	mov    %esi,%eax
  800638:	e8 83 fb ff ff       	call   8001c0 <printnum>
			break;
  80063d:	83 c4 20             	add    $0x20,%esp
  800640:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800643:	e9 f3 fc ff ff       	jmp    80033b <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	53                   	push   %ebx
  80064c:	51                   	push   %ecx
  80064d:	ff d6                	call   *%esi
			break;
  80064f:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800652:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800655:	e9 e1 fc ff ff       	jmp    80033b <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	53                   	push   %ebx
  80065e:	6a 25                	push   $0x25
  800660:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800662:	83 c4 10             	add    $0x10,%esp
  800665:	eb 03                	jmp    80066a <vprintfmt+0x355>
  800667:	83 ef 01             	sub    $0x1,%edi
  80066a:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  80066e:	75 f7                	jne    800667 <vprintfmt+0x352>
  800670:	e9 c6 fc ff ff       	jmp    80033b <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  800675:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800678:	5b                   	pop    %ebx
  800679:	5e                   	pop    %esi
  80067a:	5f                   	pop    %edi
  80067b:	5d                   	pop    %ebp
  80067c:	c3                   	ret    

0080067d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80067d:	55                   	push   %ebp
  80067e:	89 e5                	mov    %esp,%ebp
  800680:	83 ec 18             	sub    $0x18,%esp
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800689:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80068c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800690:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800693:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80069a:	85 c0                	test   %eax,%eax
  80069c:	74 26                	je     8006c4 <vsnprintf+0x47>
  80069e:	85 d2                	test   %edx,%edx
  8006a0:	7e 22                	jle    8006c4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006a2:	ff 75 14             	pushl  0x14(%ebp)
  8006a5:	ff 75 10             	pushl  0x10(%ebp)
  8006a8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006ab:	50                   	push   %eax
  8006ac:	68 db 02 80 00       	push   $0x8002db
  8006b1:	e8 5f fc ff ff       	call   800315 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006b9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006bf:	83 c4 10             	add    $0x10,%esp
  8006c2:	eb 05                	jmp    8006c9 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8006c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8006c9:	c9                   	leave  
  8006ca:	c3                   	ret    

008006cb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006cb:	55                   	push   %ebp
  8006cc:	89 e5                	mov    %esp,%ebp
  8006ce:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8006d1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8006d4:	50                   	push   %eax
  8006d5:	ff 75 10             	pushl  0x10(%ebp)
  8006d8:	ff 75 0c             	pushl  0xc(%ebp)
  8006db:	ff 75 08             	pushl  0x8(%ebp)
  8006de:	e8 9a ff ff ff       	call   80067d <vsnprintf>
	va_end(ap);

	return rc;
}
  8006e3:	c9                   	leave  
  8006e4:	c3                   	ret    

008006e5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
  8006e8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8006eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f0:	eb 03                	jmp    8006f5 <strlen+0x10>
		n++;
  8006f2:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8006f5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8006f9:	75 f7                	jne    8006f2 <strlen+0xd>
		n++;
	return n;
}
  8006fb:	5d                   	pop    %ebp
  8006fc:	c3                   	ret    

008006fd <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
  800700:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800703:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800706:	ba 00 00 00 00       	mov    $0x0,%edx
  80070b:	eb 03                	jmp    800710 <strnlen+0x13>
		n++;
  80070d:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800710:	39 c2                	cmp    %eax,%edx
  800712:	74 08                	je     80071c <strnlen+0x1f>
  800714:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800718:	75 f3                	jne    80070d <strnlen+0x10>
  80071a:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  80071c:	5d                   	pop    %ebp
  80071d:	c3                   	ret    

0080071e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	53                   	push   %ebx
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800728:	89 c2                	mov    %eax,%edx
  80072a:	83 c2 01             	add    $0x1,%edx
  80072d:	83 c1 01             	add    $0x1,%ecx
  800730:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800734:	88 5a ff             	mov    %bl,-0x1(%edx)
  800737:	84 db                	test   %bl,%bl
  800739:	75 ef                	jne    80072a <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80073b:	5b                   	pop    %ebx
  80073c:	5d                   	pop    %ebp
  80073d:	c3                   	ret    

0080073e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80073e:	55                   	push   %ebp
  80073f:	89 e5                	mov    %esp,%ebp
  800741:	53                   	push   %ebx
  800742:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800745:	53                   	push   %ebx
  800746:	e8 9a ff ff ff       	call   8006e5 <strlen>
  80074b:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80074e:	ff 75 0c             	pushl  0xc(%ebp)
  800751:	01 d8                	add    %ebx,%eax
  800753:	50                   	push   %eax
  800754:	e8 c5 ff ff ff       	call   80071e <strcpy>
	return dst;
}
  800759:	89 d8                	mov    %ebx,%eax
  80075b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80075e:	c9                   	leave  
  80075f:	c3                   	ret    

00800760 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800760:	55                   	push   %ebp
  800761:	89 e5                	mov    %esp,%ebp
  800763:	56                   	push   %esi
  800764:	53                   	push   %ebx
  800765:	8b 75 08             	mov    0x8(%ebp),%esi
  800768:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80076b:	89 f3                	mov    %esi,%ebx
  80076d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800770:	89 f2                	mov    %esi,%edx
  800772:	eb 0f                	jmp    800783 <strncpy+0x23>
		*dst++ = *src;
  800774:	83 c2 01             	add    $0x1,%edx
  800777:	0f b6 01             	movzbl (%ecx),%eax
  80077a:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80077d:	80 39 01             	cmpb   $0x1,(%ecx)
  800780:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800783:	39 da                	cmp    %ebx,%edx
  800785:	75 ed                	jne    800774 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800787:	89 f0                	mov    %esi,%eax
  800789:	5b                   	pop    %ebx
  80078a:	5e                   	pop    %esi
  80078b:	5d                   	pop    %ebp
  80078c:	c3                   	ret    

0080078d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
  800790:	56                   	push   %esi
  800791:	53                   	push   %ebx
  800792:	8b 75 08             	mov    0x8(%ebp),%esi
  800795:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800798:	8b 55 10             	mov    0x10(%ebp),%edx
  80079b:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80079d:	85 d2                	test   %edx,%edx
  80079f:	74 21                	je     8007c2 <strlcpy+0x35>
  8007a1:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8007a5:	89 f2                	mov    %esi,%edx
  8007a7:	eb 09                	jmp    8007b2 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8007a9:	83 c2 01             	add    $0x1,%edx
  8007ac:	83 c1 01             	add    $0x1,%ecx
  8007af:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8007b2:	39 c2                	cmp    %eax,%edx
  8007b4:	74 09                	je     8007bf <strlcpy+0x32>
  8007b6:	0f b6 19             	movzbl (%ecx),%ebx
  8007b9:	84 db                	test   %bl,%bl
  8007bb:	75 ec                	jne    8007a9 <strlcpy+0x1c>
  8007bd:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  8007bf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007c2:	29 f0                	sub    %esi,%eax
}
  8007c4:	5b                   	pop    %ebx
  8007c5:	5e                   	pop    %esi
  8007c6:	5d                   	pop    %ebp
  8007c7:	c3                   	ret    

008007c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007c8:	55                   	push   %ebp
  8007c9:	89 e5                	mov    %esp,%ebp
  8007cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007ce:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007d1:	eb 06                	jmp    8007d9 <strcmp+0x11>
		p++, q++;
  8007d3:	83 c1 01             	add    $0x1,%ecx
  8007d6:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8007d9:	0f b6 01             	movzbl (%ecx),%eax
  8007dc:	84 c0                	test   %al,%al
  8007de:	74 04                	je     8007e4 <strcmp+0x1c>
  8007e0:	3a 02                	cmp    (%edx),%al
  8007e2:	74 ef                	je     8007d3 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8007e4:	0f b6 c0             	movzbl %al,%eax
  8007e7:	0f b6 12             	movzbl (%edx),%edx
  8007ea:	29 d0                	sub    %edx,%eax
}
  8007ec:	5d                   	pop    %ebp
  8007ed:	c3                   	ret    

008007ee <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8007ee:	55                   	push   %ebp
  8007ef:	89 e5                	mov    %esp,%ebp
  8007f1:	53                   	push   %ebx
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007f8:	89 c3                	mov    %eax,%ebx
  8007fa:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8007fd:	eb 06                	jmp    800805 <strncmp+0x17>
		n--, p++, q++;
  8007ff:	83 c0 01             	add    $0x1,%eax
  800802:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800805:	39 d8                	cmp    %ebx,%eax
  800807:	74 15                	je     80081e <strncmp+0x30>
  800809:	0f b6 08             	movzbl (%eax),%ecx
  80080c:	84 c9                	test   %cl,%cl
  80080e:	74 04                	je     800814 <strncmp+0x26>
  800810:	3a 0a                	cmp    (%edx),%cl
  800812:	74 eb                	je     8007ff <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800814:	0f b6 00             	movzbl (%eax),%eax
  800817:	0f b6 12             	movzbl (%edx),%edx
  80081a:	29 d0                	sub    %edx,%eax
  80081c:	eb 05                	jmp    800823 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  80081e:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800823:	5b                   	pop    %ebx
  800824:	5d                   	pop    %ebp
  800825:	c3                   	ret    

00800826 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800826:	55                   	push   %ebp
  800827:	89 e5                	mov    %esp,%ebp
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800830:	eb 07                	jmp    800839 <strchr+0x13>
		if (*s == c)
  800832:	38 ca                	cmp    %cl,%dl
  800834:	74 0f                	je     800845 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800836:	83 c0 01             	add    $0x1,%eax
  800839:	0f b6 10             	movzbl (%eax),%edx
  80083c:	84 d2                	test   %dl,%dl
  80083e:	75 f2                	jne    800832 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800840:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800845:	5d                   	pop    %ebp
  800846:	c3                   	ret    

00800847 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800847:	55                   	push   %ebp
  800848:	89 e5                	mov    %esp,%ebp
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800851:	eb 03                	jmp    800856 <strfind+0xf>
  800853:	83 c0 01             	add    $0x1,%eax
  800856:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800859:	38 ca                	cmp    %cl,%dl
  80085b:	74 04                	je     800861 <strfind+0x1a>
  80085d:	84 d2                	test   %dl,%dl
  80085f:	75 f2                	jne    800853 <strfind+0xc>
			break;
	return (char *) s;
}
  800861:	5d                   	pop    %ebp
  800862:	c3                   	ret    

00800863 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800863:	55                   	push   %ebp
  800864:	89 e5                	mov    %esp,%ebp
  800866:	57                   	push   %edi
  800867:	56                   	push   %esi
  800868:	53                   	push   %ebx
  800869:	8b 55 08             	mov    0x8(%ebp),%edx
  80086c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  80086f:	85 c9                	test   %ecx,%ecx
  800871:	74 37                	je     8008aa <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800873:	f6 c2 03             	test   $0x3,%dl
  800876:	75 2a                	jne    8008a2 <memset+0x3f>
  800878:	f6 c1 03             	test   $0x3,%cl
  80087b:	75 25                	jne    8008a2 <memset+0x3f>
		c &= 0xFF;
  80087d:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800881:	89 df                	mov    %ebx,%edi
  800883:	c1 e7 08             	shl    $0x8,%edi
  800886:	89 de                	mov    %ebx,%esi
  800888:	c1 e6 18             	shl    $0x18,%esi
  80088b:	89 d8                	mov    %ebx,%eax
  80088d:	c1 e0 10             	shl    $0x10,%eax
  800890:	09 f0                	or     %esi,%eax
  800892:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800894:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800897:	89 f8                	mov    %edi,%eax
  800899:	09 d8                	or     %ebx,%eax
  80089b:	89 d7                	mov    %edx,%edi
  80089d:	fc                   	cld    
  80089e:	f3 ab                	rep stos %eax,%es:(%edi)
  8008a0:	eb 08                	jmp    8008aa <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008a2:	89 d7                	mov    %edx,%edi
  8008a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a7:	fc                   	cld    
  8008a8:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8008aa:	89 d0                	mov    %edx,%eax
  8008ac:	5b                   	pop    %ebx
  8008ad:	5e                   	pop    %esi
  8008ae:	5f                   	pop    %edi
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	57                   	push   %edi
  8008b5:	56                   	push   %esi
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008bf:	39 c6                	cmp    %eax,%esi
  8008c1:	73 35                	jae    8008f8 <memmove+0x47>
  8008c3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008c6:	39 d0                	cmp    %edx,%eax
  8008c8:	73 2e                	jae    8008f8 <memmove+0x47>
		s += n;
		d += n;
  8008ca:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008cd:	89 d6                	mov    %edx,%esi
  8008cf:	09 fe                	or     %edi,%esi
  8008d1:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008d7:	75 13                	jne    8008ec <memmove+0x3b>
  8008d9:	f6 c1 03             	test   $0x3,%cl
  8008dc:	75 0e                	jne    8008ec <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  8008de:	83 ef 04             	sub    $0x4,%edi
  8008e1:	8d 72 fc             	lea    -0x4(%edx),%esi
  8008e4:	c1 e9 02             	shr    $0x2,%ecx
  8008e7:	fd                   	std    
  8008e8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008ea:	eb 09                	jmp    8008f5 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8008ec:	83 ef 01             	sub    $0x1,%edi
  8008ef:	8d 72 ff             	lea    -0x1(%edx),%esi
  8008f2:	fd                   	std    
  8008f3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8008f5:	fc                   	cld    
  8008f6:	eb 1d                	jmp    800915 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008f8:	89 f2                	mov    %esi,%edx
  8008fa:	09 c2                	or     %eax,%edx
  8008fc:	f6 c2 03             	test   $0x3,%dl
  8008ff:	75 0f                	jne    800910 <memmove+0x5f>
  800901:	f6 c1 03             	test   $0x3,%cl
  800904:	75 0a                	jne    800910 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  800906:	c1 e9 02             	shr    $0x2,%ecx
  800909:	89 c7                	mov    %eax,%edi
  80090b:	fc                   	cld    
  80090c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80090e:	eb 05                	jmp    800915 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800910:	89 c7                	mov    %eax,%edi
  800912:	fc                   	cld    
  800913:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800915:	5e                   	pop    %esi
  800916:	5f                   	pop    %edi
  800917:	5d                   	pop    %ebp
  800918:	c3                   	ret    

00800919 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80091c:	ff 75 10             	pushl  0x10(%ebp)
  80091f:	ff 75 0c             	pushl  0xc(%ebp)
  800922:	ff 75 08             	pushl  0x8(%ebp)
  800925:	e8 87 ff ff ff       	call   8008b1 <memmove>
}
  80092a:	c9                   	leave  
  80092b:	c3                   	ret    

0080092c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	56                   	push   %esi
  800930:	53                   	push   %ebx
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	8b 55 0c             	mov    0xc(%ebp),%edx
  800937:	89 c6                	mov    %eax,%esi
  800939:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80093c:	eb 1a                	jmp    800958 <memcmp+0x2c>
		if (*s1 != *s2)
  80093e:	0f b6 08             	movzbl (%eax),%ecx
  800941:	0f b6 1a             	movzbl (%edx),%ebx
  800944:	38 d9                	cmp    %bl,%cl
  800946:	74 0a                	je     800952 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800948:	0f b6 c1             	movzbl %cl,%eax
  80094b:	0f b6 db             	movzbl %bl,%ebx
  80094e:	29 d8                	sub    %ebx,%eax
  800950:	eb 0f                	jmp    800961 <memcmp+0x35>
		s1++, s2++;
  800952:	83 c0 01             	add    $0x1,%eax
  800955:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800958:	39 f0                	cmp    %esi,%eax
  80095a:	75 e2                	jne    80093e <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80095c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800961:	5b                   	pop    %ebx
  800962:	5e                   	pop    %esi
  800963:	5d                   	pop    %ebp
  800964:	c3                   	ret    

00800965 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	53                   	push   %ebx
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  80096c:	89 c1                	mov    %eax,%ecx
  80096e:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  800971:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800975:	eb 0a                	jmp    800981 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800977:	0f b6 10             	movzbl (%eax),%edx
  80097a:	39 da                	cmp    %ebx,%edx
  80097c:	74 07                	je     800985 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80097e:	83 c0 01             	add    $0x1,%eax
  800981:	39 c8                	cmp    %ecx,%eax
  800983:	72 f2                	jb     800977 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800985:	5b                   	pop    %ebx
  800986:	5d                   	pop    %ebp
  800987:	c3                   	ret    

00800988 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	57                   	push   %edi
  80098c:	56                   	push   %esi
  80098d:	53                   	push   %ebx
  80098e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800991:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800994:	eb 03                	jmp    800999 <strtol+0x11>
		s++;
  800996:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800999:	0f b6 01             	movzbl (%ecx),%eax
  80099c:	3c 20                	cmp    $0x20,%al
  80099e:	74 f6                	je     800996 <strtol+0xe>
  8009a0:	3c 09                	cmp    $0x9,%al
  8009a2:	74 f2                	je     800996 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8009a4:	3c 2b                	cmp    $0x2b,%al
  8009a6:	75 0a                	jne    8009b2 <strtol+0x2a>
		s++;
  8009a8:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8009ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8009b0:	eb 11                	jmp    8009c3 <strtol+0x3b>
  8009b2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8009b7:	3c 2d                	cmp    $0x2d,%al
  8009b9:	75 08                	jne    8009c3 <strtol+0x3b>
		s++, neg = 1;
  8009bb:	83 c1 01             	add    $0x1,%ecx
  8009be:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009c3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009c9:	75 15                	jne    8009e0 <strtol+0x58>
  8009cb:	80 39 30             	cmpb   $0x30,(%ecx)
  8009ce:	75 10                	jne    8009e0 <strtol+0x58>
  8009d0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8009d4:	75 7c                	jne    800a52 <strtol+0xca>
		s += 2, base = 16;
  8009d6:	83 c1 02             	add    $0x2,%ecx
  8009d9:	bb 10 00 00 00       	mov    $0x10,%ebx
  8009de:	eb 16                	jmp    8009f6 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  8009e0:	85 db                	test   %ebx,%ebx
  8009e2:	75 12                	jne    8009f6 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009e4:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009e9:	80 39 30             	cmpb   $0x30,(%ecx)
  8009ec:	75 08                	jne    8009f6 <strtol+0x6e>
		s++, base = 8;
  8009ee:	83 c1 01             	add    $0x1,%ecx
  8009f1:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  8009f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fb:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8009fe:	0f b6 11             	movzbl (%ecx),%edx
  800a01:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a04:	89 f3                	mov    %esi,%ebx
  800a06:	80 fb 09             	cmp    $0x9,%bl
  800a09:	77 08                	ja     800a13 <strtol+0x8b>
			dig = *s - '0';
  800a0b:	0f be d2             	movsbl %dl,%edx
  800a0e:	83 ea 30             	sub    $0x30,%edx
  800a11:	eb 22                	jmp    800a35 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800a13:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a16:	89 f3                	mov    %esi,%ebx
  800a18:	80 fb 19             	cmp    $0x19,%bl
  800a1b:	77 08                	ja     800a25 <strtol+0x9d>
			dig = *s - 'a' + 10;
  800a1d:	0f be d2             	movsbl %dl,%edx
  800a20:	83 ea 57             	sub    $0x57,%edx
  800a23:	eb 10                	jmp    800a35 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800a25:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a28:	89 f3                	mov    %esi,%ebx
  800a2a:	80 fb 19             	cmp    $0x19,%bl
  800a2d:	77 16                	ja     800a45 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800a2f:	0f be d2             	movsbl %dl,%edx
  800a32:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800a35:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a38:	7d 0b                	jge    800a45 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800a3a:	83 c1 01             	add    $0x1,%ecx
  800a3d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a41:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800a43:	eb b9                	jmp    8009fe <strtol+0x76>

	if (endptr)
  800a45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a49:	74 0d                	je     800a58 <strtol+0xd0>
		*endptr = (char *) s;
  800a4b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a4e:	89 0e                	mov    %ecx,(%esi)
  800a50:	eb 06                	jmp    800a58 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a52:	85 db                	test   %ebx,%ebx
  800a54:	74 98                	je     8009ee <strtol+0x66>
  800a56:	eb 9e                	jmp    8009f6 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800a58:	89 c2                	mov    %eax,%edx
  800a5a:	f7 da                	neg    %edx
  800a5c:	85 ff                	test   %edi,%edi
  800a5e:	0f 45 c2             	cmovne %edx,%eax
}
  800a61:	5b                   	pop    %ebx
  800a62:	5e                   	pop    %esi
  800a63:	5f                   	pop    %edi
  800a64:	5d                   	pop    %ebp
  800a65:	c3                   	ret    

00800a66 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800a66:	55                   	push   %ebp
  800a67:	89 e5                	mov    %esp,%ebp
  800a69:	57                   	push   %edi
  800a6a:	56                   	push   %esi
  800a6b:	53                   	push   %ebx
  800a6c:	83 ec 1c             	sub    $0x1c,%esp
  800a6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a72:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a75:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800a77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a7a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a7d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800a80:	8b 75 14             	mov    0x14(%ebp),%esi
  800a83:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800a85:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a89:	74 1d                	je     800aa8 <syscall+0x42>
  800a8b:	85 c0                	test   %eax,%eax
  800a8d:	7e 19                	jle    800aa8 <syscall+0x42>
  800a8f:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800a92:	83 ec 0c             	sub    $0xc,%esp
  800a95:	50                   	push   %eax
  800a96:	52                   	push   %edx
  800a97:	68 9f 26 80 00       	push   $0x80269f
  800a9c:	6a 23                	push   $0x23
  800a9e:	68 bc 26 80 00       	push   $0x8026bc
  800aa3:	e8 a0 13 00 00       	call   801e48 <_panic>

	return ret;
}
  800aa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800aab:	5b                   	pop    %ebx
  800aac:	5e                   	pop    %esi
  800aad:	5f                   	pop    %edi
  800aae:	5d                   	pop    %ebp
  800aaf:	c3                   	ret    

00800ab0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800ab6:	6a 00                	push   $0x0
  800ab8:	6a 00                	push   $0x0
  800aba:	6a 00                	push   $0x0
  800abc:	ff 75 0c             	pushl  0xc(%ebp)
  800abf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac7:	b8 00 00 00 00       	mov    $0x0,%eax
  800acc:	e8 95 ff ff ff       	call   800a66 <syscall>
}
  800ad1:	83 c4 10             	add    $0x10,%esp
  800ad4:	c9                   	leave  
  800ad5:	c3                   	ret    

00800ad6 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800adc:	6a 00                	push   $0x0
  800ade:	6a 00                	push   $0x0
  800ae0:	6a 00                	push   $0x0
  800ae2:	6a 00                	push   $0x0
  800ae4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ae9:	ba 00 00 00 00       	mov    $0x0,%edx
  800aee:	b8 01 00 00 00       	mov    $0x1,%eax
  800af3:	e8 6e ff ff ff       	call   800a66 <syscall>
}
  800af8:	c9                   	leave  
  800af9:	c3                   	ret    

00800afa <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800b00:	6a 00                	push   $0x0
  800b02:	6a 00                	push   $0x0
  800b04:	6a 00                	push   $0x0
  800b06:	6a 00                	push   $0x0
  800b08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b0b:	ba 01 00 00 00       	mov    $0x1,%edx
  800b10:	b8 03 00 00 00       	mov    $0x3,%eax
  800b15:	e8 4c ff ff ff       	call   800a66 <syscall>
}
  800b1a:	c9                   	leave  
  800b1b:	c3                   	ret    

00800b1c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b22:	6a 00                	push   $0x0
  800b24:	6a 00                	push   $0x0
  800b26:	6a 00                	push   $0x0
  800b28:	6a 00                	push   $0x0
  800b2a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b34:	b8 02 00 00 00       	mov    $0x2,%eax
  800b39:	e8 28 ff ff ff       	call   800a66 <syscall>
}
  800b3e:	c9                   	leave  
  800b3f:	c3                   	ret    

00800b40 <sys_yield>:

void
sys_yield(void)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b46:	6a 00                	push   $0x0
  800b48:	6a 00                	push   $0x0
  800b4a:	6a 00                	push   $0x0
  800b4c:	6a 00                	push   $0x0
  800b4e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b53:	ba 00 00 00 00       	mov    $0x0,%edx
  800b58:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b5d:	e8 04 ff ff ff       	call   800a66 <syscall>
}
  800b62:	83 c4 10             	add    $0x10,%esp
  800b65:	c9                   	leave  
  800b66:	c3                   	ret    

00800b67 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800b6d:	6a 00                	push   $0x0
  800b6f:	6a 00                	push   $0x0
  800b71:	ff 75 10             	pushl  0x10(%ebp)
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b7a:	ba 01 00 00 00       	mov    $0x1,%edx
  800b7f:	b8 04 00 00 00       	mov    $0x4,%eax
  800b84:	e8 dd fe ff ff       	call   800a66 <syscall>
}
  800b89:	c9                   	leave  
  800b8a:	c3                   	ret    

00800b8b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800b91:	ff 75 18             	pushl  0x18(%ebp)
  800b94:	ff 75 14             	pushl  0x14(%ebp)
  800b97:	ff 75 10             	pushl  0x10(%ebp)
  800b9a:	ff 75 0c             	pushl  0xc(%ebp)
  800b9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba0:	ba 01 00 00 00       	mov    $0x1,%edx
  800ba5:	b8 05 00 00 00       	mov    $0x5,%eax
  800baa:	e8 b7 fe ff ff       	call   800a66 <syscall>
}
  800baf:	c9                   	leave  
  800bb0:	c3                   	ret    

00800bb1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
  800bb4:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800bb7:	6a 00                	push   $0x0
  800bb9:	6a 00                	push   $0x0
  800bbb:	6a 00                	push   $0x0
  800bbd:	ff 75 0c             	pushl  0xc(%ebp)
  800bc0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc3:	ba 01 00 00 00       	mov    $0x1,%edx
  800bc8:	b8 06 00 00 00       	mov    $0x6,%eax
  800bcd:	e8 94 fe ff ff       	call   800a66 <syscall>
}
  800bd2:	c9                   	leave  
  800bd3:	c3                   	ret    

00800bd4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800bda:	6a 00                	push   $0x0
  800bdc:	6a 00                	push   $0x0
  800bde:	6a 00                	push   $0x0
  800be0:	ff 75 0c             	pushl  0xc(%ebp)
  800be3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800be6:	ba 01 00 00 00       	mov    $0x1,%edx
  800beb:	b8 08 00 00 00       	mov    $0x8,%eax
  800bf0:	e8 71 fe ff ff       	call   800a66 <syscall>
}
  800bf5:	c9                   	leave  
  800bf6:	c3                   	ret    

00800bf7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800bfd:	6a 00                	push   $0x0
  800bff:	6a 00                	push   $0x0
  800c01:	6a 00                	push   $0x0
  800c03:	ff 75 0c             	pushl  0xc(%ebp)
  800c06:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c09:	ba 01 00 00 00       	mov    $0x1,%edx
  800c0e:	b8 09 00 00 00       	mov    $0x9,%eax
  800c13:	e8 4e fe ff ff       	call   800a66 <syscall>
}
  800c18:	c9                   	leave  
  800c19:	c3                   	ret    

00800c1a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800c20:	6a 00                	push   $0x0
  800c22:	6a 00                	push   $0x0
  800c24:	6a 00                	push   $0x0
  800c26:	ff 75 0c             	pushl  0xc(%ebp)
  800c29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c2c:	ba 01 00 00 00       	mov    $0x1,%edx
  800c31:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c36:	e8 2b fe ff ff       	call   800a66 <syscall>
}
  800c3b:	c9                   	leave  
  800c3c:	c3                   	ret    

00800c3d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800c43:	6a 00                	push   $0x0
  800c45:	ff 75 14             	pushl  0x14(%ebp)
  800c48:	ff 75 10             	pushl  0x10(%ebp)
  800c4b:	ff 75 0c             	pushl  0xc(%ebp)
  800c4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c51:	ba 00 00 00 00       	mov    $0x0,%edx
  800c56:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c5b:	e8 06 fe ff ff       	call   800a66 <syscall>
}
  800c60:	c9                   	leave  
  800c61:	c3                   	ret    

00800c62 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800c68:	6a 00                	push   $0x0
  800c6a:	6a 00                	push   $0x0
  800c6c:	6a 00                	push   $0x0
  800c6e:	6a 00                	push   $0x0
  800c70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c73:	ba 01 00 00 00       	mov    $0x1,%edx
  800c78:	b8 0d 00 00 00       	mov    $0xd,%eax
  800c7d:	e8 e4 fd ff ff       	call   800a66 <syscall>
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	53                   	push   %ebx
  800c88:	83 ec 04             	sub    $0x4,%esp

	int perm_w = PTE_COW|PTE_U|PTE_P;
	int perm = PTE_U|PTE_P;

	// LAB 4: Your code here.
	void *addr = (void*) (pn*PGSIZE);
  800c8b:	89 d3                	mov    %edx,%ebx
  800c8d:	c1 e3 0c             	shl    $0xc,%ebx

	//Si una página tiene el bit PTE_SHARE, se comparte con el hijo con los mismos permisos.
  	if (uvpt[pn] & PTE_SHARE) {
  800c90:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800c97:	f6 c5 04             	test   $0x4,%ch
  800c9a:	74 3a                	je     800cd6 <duppage+0x52>
    	if (sys_page_map(0, addr, envid,addr, uvpt[pn] & PTE_SYSCALL) < 0) {
  800c9c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ca3:	83 ec 0c             	sub    $0xc,%esp
  800ca6:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800cac:	52                   	push   %edx
  800cad:	53                   	push   %ebx
  800cae:	50                   	push   %eax
  800caf:	53                   	push   %ebx
  800cb0:	6a 00                	push   $0x0
  800cb2:	e8 d4 fe ff ff       	call   800b8b <sys_page_map>
  800cb7:	83 c4 20             	add    $0x20,%esp
  800cba:	85 c0                	test   %eax,%eax
  800cbc:	0f 89 99 00 00 00    	jns    800d5b <duppage+0xd7>
 	     	panic("Error en sys_page_map");
  800cc2:	83 ec 04             	sub    $0x4,%esp
  800cc5:	68 ca 26 80 00       	push   $0x8026ca
  800cca:	6a 50                	push   $0x50
  800ccc:	68 e0 26 80 00       	push   $0x8026e0
  800cd1:	e8 72 11 00 00       	call   801e48 <_panic>
    	} 
    	return 0;
	}

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  800cd6:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800cdd:	f6 c1 02             	test   $0x2,%cl
  800ce0:	75 0c                	jne    800cee <duppage+0x6a>
  800ce2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ce9:	f6 c6 08             	test   $0x8,%dh
  800cec:	74 5b                	je     800d49 <duppage+0xc5>
		if (sys_page_map(0, addr, envid, addr, perm_w) < 0){
  800cee:	83 ec 0c             	sub    $0xc,%esp
  800cf1:	68 05 08 00 00       	push   $0x805
  800cf6:	53                   	push   %ebx
  800cf7:	50                   	push   %eax
  800cf8:	53                   	push   %ebx
  800cf9:	6a 00                	push   $0x0
  800cfb:	e8 8b fe ff ff       	call   800b8b <sys_page_map>
  800d00:	83 c4 20             	add    $0x20,%esp
  800d03:	85 c0                	test   %eax,%eax
  800d05:	79 14                	jns    800d1b <duppage+0x97>
			panic("Error mapeando pagina Padre");
  800d07:	83 ec 04             	sub    $0x4,%esp
  800d0a:	68 eb 26 80 00       	push   $0x8026eb
  800d0f:	6a 57                	push   $0x57
  800d11:	68 e0 26 80 00       	push   $0x8026e0
  800d16:	e8 2d 11 00 00       	call   801e48 <_panic>
		}
		if (sys_page_map(0, addr, 0, addr, perm_w) < 0){
  800d1b:	83 ec 0c             	sub    $0xc,%esp
  800d1e:	68 05 08 00 00       	push   $0x805
  800d23:	53                   	push   %ebx
  800d24:	6a 00                	push   $0x0
  800d26:	53                   	push   %ebx
  800d27:	6a 00                	push   $0x0
  800d29:	e8 5d fe ff ff       	call   800b8b <sys_page_map>
  800d2e:	83 c4 20             	add    $0x20,%esp
  800d31:	85 c0                	test   %eax,%eax
  800d33:	79 26                	jns    800d5b <duppage+0xd7>
			panic("Error mapeando pagina Hijo");
  800d35:	83 ec 04             	sub    $0x4,%esp
  800d38:	68 07 27 80 00       	push   $0x802707
  800d3d:	6a 5a                	push   $0x5a
  800d3f:	68 e0 26 80 00       	push   $0x8026e0
  800d44:	e8 ff 10 00 00       	call   801e48 <_panic>
		}
	} else sys_page_map(0, addr, envid, addr, perm);
  800d49:	83 ec 0c             	sub    $0xc,%esp
  800d4c:	6a 05                	push   $0x5
  800d4e:	53                   	push   %ebx
  800d4f:	50                   	push   %eax
  800d50:	53                   	push   %ebx
  800d51:	6a 00                	push   $0x0
  800d53:	e8 33 fe ff ff       	call   800b8b <sys_page_map>
  800d58:	83 c4 20             	add    $0x20,%esp
	
	return 0;
}
  800d5b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d63:	c9                   	leave  
  800d64:	c3                   	ret    

00800d65 <dup_or_share>:
//FORK V0

static void
dup_or_share(envid_t dstenv, void *va, int perm){
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	57                   	push   %edi
  800d69:	56                   	push   %esi
  800d6a:	53                   	push   %ebx
  800d6b:	83 ec 0c             	sub    $0xc,%esp
  800d6e:	89 c7                	mov    %eax,%edi
  800d70:	89 d6                	mov    %edx,%esi
  800d72:	89 cb                	mov    %ecx,%ebx
	int result;
	// Si no es de escritura, comparto la pagina
	if((perm &PTE_W) != PTE_W){
  800d74:	f6 c1 02             	test   $0x2,%cl
  800d77:	75 2d                	jne    800da6 <dup_or_share+0x41>
		if((result = sys_page_map(0, va, dstenv, va, perm))<0){
  800d79:	83 ec 0c             	sub    $0xc,%esp
  800d7c:	51                   	push   %ecx
  800d7d:	52                   	push   %edx
  800d7e:	50                   	push   %eax
  800d7f:	52                   	push   %edx
  800d80:	6a 00                	push   $0x0
  800d82:	e8 04 fe ff ff       	call   800b8b <sys_page_map>
  800d87:	83 c4 20             	add    $0x20,%esp
  800d8a:	85 c0                	test   %eax,%eax
  800d8c:	0f 89 a4 00 00 00    	jns    800e36 <dup_or_share+0xd1>
			panic("Error compartiendo la pagina");
  800d92:	83 ec 04             	sub    $0x4,%esp
  800d95:	68 22 27 80 00       	push   $0x802722
  800d9a:	6a 68                	push   $0x68
  800d9c:	68 e0 26 80 00       	push   $0x8026e0
  800da1:	e8 a2 10 00 00       	call   801e48 <_panic>
		}
	// Si es de escritura comportamiento de duppage, en dumbfork
	}else{
		if ((result = sys_page_alloc(dstenv, va, perm)) < 0){
  800da6:	83 ec 04             	sub    $0x4,%esp
  800da9:	51                   	push   %ecx
  800daa:	52                   	push   %edx
  800dab:	50                   	push   %eax
  800dac:	e8 b6 fd ff ff       	call   800b67 <sys_page_alloc>
  800db1:	83 c4 10             	add    $0x10,%esp
  800db4:	85 c0                	test   %eax,%eax
  800db6:	79 14                	jns    800dcc <dup_or_share+0x67>
			panic("Error copiando la pagina");
  800db8:	83 ec 04             	sub    $0x4,%esp
  800dbb:	68 3f 27 80 00       	push   $0x80273f
  800dc0:	6a 6d                	push   $0x6d
  800dc2:	68 e0 26 80 00       	push   $0x8026e0
  800dc7:	e8 7c 10 00 00       	call   801e48 <_panic>
		}
		if ((result = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0){
  800dcc:	83 ec 0c             	sub    $0xc,%esp
  800dcf:	53                   	push   %ebx
  800dd0:	68 00 00 40 00       	push   $0x400000
  800dd5:	6a 00                	push   $0x0
  800dd7:	56                   	push   %esi
  800dd8:	57                   	push   %edi
  800dd9:	e8 ad fd ff ff       	call   800b8b <sys_page_map>
  800dde:	83 c4 20             	add    $0x20,%esp
  800de1:	85 c0                	test   %eax,%eax
  800de3:	79 14                	jns    800df9 <dup_or_share+0x94>
			panic("Error copiando la pagina");
  800de5:	83 ec 04             	sub    $0x4,%esp
  800de8:	68 3f 27 80 00       	push   $0x80273f
  800ded:	6a 70                	push   $0x70
  800def:	68 e0 26 80 00       	push   $0x8026e0
  800df4:	e8 4f 10 00 00       	call   801e48 <_panic>
		}
		memmove(UTEMP, va, PGSIZE);
  800df9:	83 ec 04             	sub    $0x4,%esp
  800dfc:	68 00 10 00 00       	push   $0x1000
  800e01:	56                   	push   %esi
  800e02:	68 00 00 40 00       	push   $0x400000
  800e07:	e8 a5 fa ff ff       	call   8008b1 <memmove>
		if ((result = sys_page_unmap(0, UTEMP)) < 0){
  800e0c:	83 c4 08             	add    $0x8,%esp
  800e0f:	68 00 00 40 00       	push   $0x400000
  800e14:	6a 00                	push   $0x0
  800e16:	e8 96 fd ff ff       	call   800bb1 <sys_page_unmap>
  800e1b:	83 c4 10             	add    $0x10,%esp
  800e1e:	85 c0                	test   %eax,%eax
  800e20:	79 14                	jns    800e36 <dup_or_share+0xd1>
			panic("Error copiando la pagina");
  800e22:	83 ec 04             	sub    $0x4,%esp
  800e25:	68 3f 27 80 00       	push   $0x80273f
  800e2a:	6a 74                	push   $0x74
  800e2c:	68 e0 26 80 00       	push   $0x8026e0
  800e31:	e8 12 10 00 00       	call   801e48 <_panic>
		}
	}	
}
  800e36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e39:	5b                   	pop    %ebx
  800e3a:	5e                   	pop    %esi
  800e3b:	5f                   	pop    %edi
  800e3c:	5d                   	pop    %ebp
  800e3d:	c3                   	ret    

00800e3e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
  800e41:	53                   	push   %ebx
  800e42:	83 ec 04             	sub    $0x4,%esp
  800e45:	8b 55 08             	mov    0x8(%ebp),%edx
	void *va = (void *) utf->utf_fault_va;
  800e48:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800e4a:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  800e4e:	74 2e                	je     800e7e <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
  800e50:	89 c2                	mov    %eax,%edx
  800e52:	c1 ea 16             	shr    $0x16,%edx
  800e55:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800e5c:	f6 c2 01             	test   $0x1,%dl
  800e5f:	74 1d                	je     800e7e <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
  800e61:	89 c2                	mov    %eax,%edx
  800e63:	c1 ea 0c             	shr    $0xc,%edx
  800e66:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
		(uvpd[PDX(va)] & PTE_P) && 
  800e6d:	f6 c1 01             	test   $0x1,%cl
  800e70:	74 0c                	je     800e7e <pgfault+0x40>
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
  800e72:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800e79:	f6 c6 08             	test   $0x8,%dh
  800e7c:	75 14                	jne    800e92 <pgfault+0x54>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
		panic("No es copy-on-write");
  800e7e:	83 ec 04             	sub    $0x4,%esp
  800e81:	68 58 27 80 00       	push   $0x802758
  800e86:	6a 21                	push   $0x21
  800e88:	68 e0 26 80 00       	push   $0x8026e0
  800e8d:	e8 b6 0f 00 00       	call   801e48 <_panic>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	va = ROUNDDOWN(va, PGSIZE);
  800e92:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e97:	89 c3                	mov    %eax,%ebx
	if (sys_page_alloc(0, PFTEMP, perm) < 0){
  800e99:	83 ec 04             	sub    $0x4,%esp
  800e9c:	6a 07                	push   $0x7
  800e9e:	68 00 f0 7f 00       	push   $0x7ff000
  800ea3:	6a 00                	push   $0x0
  800ea5:	e8 bd fc ff ff       	call   800b67 <sys_page_alloc>
  800eaa:	83 c4 10             	add    $0x10,%esp
  800ead:	85 c0                	test   %eax,%eax
  800eaf:	79 14                	jns    800ec5 <pgfault+0x87>
		panic("Error sys_page_alloc");
  800eb1:	83 ec 04             	sub    $0x4,%esp
  800eb4:	68 6c 27 80 00       	push   $0x80276c
  800eb9:	6a 2a                	push   $0x2a
  800ebb:	68 e0 26 80 00       	push   $0x8026e0
  800ec0:	e8 83 0f 00 00       	call   801e48 <_panic>
	}
	memcpy(PFTEMP, va, PGSIZE);
  800ec5:	83 ec 04             	sub    $0x4,%esp
  800ec8:	68 00 10 00 00       	push   $0x1000
  800ecd:	53                   	push   %ebx
  800ece:	68 00 f0 7f 00       	push   $0x7ff000
  800ed3:	e8 41 fa ff ff       	call   800919 <memcpy>
	if (sys_page_map(0, PFTEMP, 0, va, perm) < 0){
  800ed8:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800edf:	53                   	push   %ebx
  800ee0:	6a 00                	push   $0x0
  800ee2:	68 00 f0 7f 00       	push   $0x7ff000
  800ee7:	6a 00                	push   $0x0
  800ee9:	e8 9d fc ff ff       	call   800b8b <sys_page_map>
  800eee:	83 c4 20             	add    $0x20,%esp
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	79 14                	jns    800f09 <pgfault+0xcb>
		panic("Error sys_page_map");
  800ef5:	83 ec 04             	sub    $0x4,%esp
  800ef8:	68 81 27 80 00       	push   $0x802781
  800efd:	6a 2e                	push   $0x2e
  800eff:	68 e0 26 80 00       	push   $0x8026e0
  800f04:	e8 3f 0f 00 00       	call   801e48 <_panic>
	}
	if (sys_page_unmap(0, PFTEMP) < 0){
  800f09:	83 ec 08             	sub    $0x8,%esp
  800f0c:	68 00 f0 7f 00       	push   $0x7ff000
  800f11:	6a 00                	push   $0x0
  800f13:	e8 99 fc ff ff       	call   800bb1 <sys_page_unmap>
  800f18:	83 c4 10             	add    $0x10,%esp
  800f1b:	85 c0                	test   %eax,%eax
  800f1d:	79 14                	jns    800f33 <pgfault+0xf5>
		panic("Error sys_page_unmap");
  800f1f:	83 ec 04             	sub    $0x4,%esp
  800f22:	68 94 27 80 00       	push   $0x802794
  800f27:	6a 31                	push   $0x31
  800f29:	68 e0 26 80 00       	push   $0x8026e0
  800f2e:	e8 15 0f 00 00       	call   801e48 <_panic>
	}
	return;

}
  800f33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f36:	c9                   	leave  
  800f37:	c3                   	ret    

00800f38 <fork_v0>:
		}
	}	
}

envid_t
fork_v0(void){
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	57                   	push   %edi
  800f3c:	56                   	push   %esi
  800f3d:	53                   	push   %ebx
  800f3e:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f41:	b8 07 00 00 00       	mov    $0x7,%eax
  800f46:	cd 30                	int    $0x30
  800f48:	89 c6                	mov    %eax,%esi
	envid_t envid;
	uint8_t *va;
	int result;	

	envid = sys_exofork();
	if (envid < 0)
  800f4a:	85 c0                	test   %eax,%eax
  800f4c:	79 15                	jns    800f63 <fork_v0+0x2b>
		panic("sys_exofork: %e", envid);
  800f4e:	50                   	push   %eax
  800f4f:	68 a9 27 80 00       	push   $0x8027a9
  800f54:	68 81 00 00 00       	push   $0x81
  800f59:	68 e0 26 80 00       	push   $0x8026e0
  800f5e:	e8 e5 0e 00 00       	call   801e48 <_panic>
  800f63:	89 c7                	mov    %eax,%edi
  800f65:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {		
  800f6a:	85 c0                	test   %eax,%eax
  800f6c:	75 1e                	jne    800f8c <fork_v0+0x54>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f6e:	e8 a9 fb ff ff       	call   800b1c <sys_getenvid>
  800f73:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f78:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f7b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f80:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800f85:	b8 00 00 00 00       	mov    $0x0,%eax
  800f8a:	eb 7a                	jmp    801006 <fork_v0+0xce>
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  800f8c:	89 d8                	mov    %ebx,%eax
  800f8e:	c1 e8 16             	shr    $0x16,%eax
  800f91:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f98:	a8 01                	test   $0x1,%al
  800f9a:	74 33                	je     800fcf <fork_v0+0x97>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  800f9c:	89 d8                	mov    %ebx,%eax
  800f9e:	c1 e8 0c             	shr    $0xc,%eax
  800fa1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fa8:	f6 c2 01             	test   $0x1,%dl
  800fab:	74 22                	je     800fcf <fork_v0+0x97>
  800fad:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fb4:	f6 c2 04             	test   $0x4,%dl
  800fb7:	74 16                	je     800fcf <fork_v0+0x97>
				pte_t pte =uvpt[PGNUM(va)];
  800fb9:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
  800fc0:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  800fc6:	89 da                	mov    %ebx,%edx
  800fc8:	89 f8                	mov    %edi,%eax
  800fca:	e8 96 fd ff ff       	call   800d65 <dup_or_share>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
  800fcf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800fd5:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  800fdb:	75 af                	jne    800f8c <fork_v0+0x54>
				pte_t pte =uvpt[PGNUM(va)];
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
			}
		}
	}	
	if ((result = sys_env_set_status(envid, ENV_RUNNABLE)) < 0){
  800fdd:	83 ec 08             	sub    $0x8,%esp
  800fe0:	6a 02                	push   $0x2
  800fe2:	56                   	push   %esi
  800fe3:	e8 ec fb ff ff       	call   800bd4 <sys_env_set_status>
  800fe8:	83 c4 10             	add    $0x10,%esp
  800feb:	85 c0                	test   %eax,%eax
  800fed:	79 15                	jns    801004 <fork_v0+0xcc>

		panic("sys_env_set_status: %e", result);
  800fef:	50                   	push   %eax
  800ff0:	68 b9 27 80 00       	push   $0x8027b9
  800ff5:	68 90 00 00 00       	push   $0x90
  800ffa:	68 e0 26 80 00       	push   $0x8026e0
  800fff:	e8 44 0e 00 00       	call   801e48 <_panic>
	}
	return envid;
  801004:	89 f0                	mov    %esi,%eax
}
  801006:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801009:	5b                   	pop    %ebx
  80100a:	5e                   	pop    %esi
  80100b:	5f                   	pop    %edi
  80100c:	5d                   	pop    %ebp
  80100d:	c3                   	ret    

0080100e <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
  801011:	57                   	push   %edi
  801012:	56                   	push   %esi
  801013:	53                   	push   %ebx
  801014:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801017:	68 3e 0e 80 00       	push   $0x800e3e
  80101c:	e8 6d 0e 00 00       	call   801e8e <set_pgfault_handler>
  801021:	b8 07 00 00 00       	mov    $0x7,%eax
  801026:	cd 30                	int    $0x30
  801028:	89 c6                	mov    %eax,%esi

	envid_t envid;
	uint32_t va;
	envid = sys_exofork();
	if (envid < 0){
  80102a:	83 c4 10             	add    $0x10,%esp
  80102d:	85 c0                	test   %eax,%eax
  80102f:	79 15                	jns    801046 <fork+0x38>
		panic("sys_exofork: %e", envid);
  801031:	50                   	push   %eax
  801032:	68 a9 27 80 00       	push   $0x8027a9
  801037:	68 b1 00 00 00       	push   $0xb1
  80103c:	68 e0 26 80 00       	push   $0x8026e0
  801041:	e8 02 0e 00 00       	call   801e48 <_panic>
  801046:	89 c7                	mov    %eax,%edi
  801048:	bb 00 00 00 00       	mov    $0x0,%ebx
	}
	if (envid == 0) {		
  80104d:	85 c0                	test   %eax,%eax
  80104f:	75 21                	jne    801072 <fork+0x64>
		thisenv = &envs[ENVX(sys_getenvid())];
  801051:	e8 c6 fa ff ff       	call   800b1c <sys_getenvid>
  801056:	25 ff 03 00 00       	and    $0x3ff,%eax
  80105b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80105e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801063:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801068:	b8 00 00 00 00       	mov    $0x0,%eax
  80106d:	e9 a7 00 00 00       	jmp    801119 <fork+0x10b>
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  801072:	89 d8                	mov    %ebx,%eax
  801074:	c1 e8 16             	shr    $0x16,%eax
  801077:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80107e:	a8 01                	test   $0x1,%al
  801080:	74 22                	je     8010a4 <fork+0x96>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  801082:	89 da                	mov    %ebx,%edx
  801084:	c1 ea 0c             	shr    $0xc,%edx
  801087:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80108e:	a8 01                	test   $0x1,%al
  801090:	74 12                	je     8010a4 <fork+0x96>
  801092:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801099:	a8 04                	test   $0x4,%al
  80109b:	74 07                	je     8010a4 <fork+0x96>
				duppage(envid, PGNUM(va));			
  80109d:	89 f8                	mov    %edi,%eax
  80109f:	e8 e0 fb ff ff       	call   800c84 <duppage>
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
  8010a4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010aa:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8010b0:	75 c0                	jne    801072 <fork+0x64>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
				duppage(envid, PGNUM(va));			
			}
		}
	}
	if (sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P) < 0){
  8010b2:	83 ec 04             	sub    $0x4,%esp
  8010b5:	6a 07                	push   $0x7
  8010b7:	68 00 f0 bf ee       	push   $0xeebff000
  8010bc:	56                   	push   %esi
  8010bd:	e8 a5 fa ff ff       	call   800b67 <sys_page_alloc>
  8010c2:	83 c4 10             	add    $0x10,%esp
  8010c5:	85 c0                	test   %eax,%eax
  8010c7:	79 17                	jns    8010e0 <fork+0xd2>
		panic("Se escribio en la pagina de excepciones");
  8010c9:	83 ec 04             	sub    $0x4,%esp
  8010cc:	68 e8 27 80 00       	push   $0x8027e8
  8010d1:	68 c0 00 00 00       	push   $0xc0
  8010d6:	68 e0 26 80 00       	push   $0x8026e0
  8010db:	e8 68 0d 00 00       	call   801e48 <_panic>
	}	
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8010e0:	83 ec 08             	sub    $0x8,%esp
  8010e3:	68 fd 1e 80 00       	push   $0x801efd
  8010e8:	56                   	push   %esi
  8010e9:	e8 2c fb ff ff       	call   800c1a <sys_env_set_pgfault_upcall>

	if (sys_env_set_status(envid, ENV_RUNNABLE) < 0)
  8010ee:	83 c4 08             	add    $0x8,%esp
  8010f1:	6a 02                	push   $0x2
  8010f3:	56                   	push   %esi
  8010f4:	e8 db fa ff ff       	call   800bd4 <sys_env_set_status>
  8010f9:	83 c4 10             	add    $0x10,%esp
  8010fc:	85 c0                	test   %eax,%eax
  8010fe:	79 17                	jns    801117 <fork+0x109>
		panic("Status incorrecto de enviroment");
  801100:	83 ec 04             	sub    $0x4,%esp
  801103:	68 10 28 80 00       	push   $0x802810
  801108:	68 c5 00 00 00       	push   $0xc5
  80110d:	68 e0 26 80 00       	push   $0x8026e0
  801112:	e8 31 0d 00 00       	call   801e48 <_panic>

	return envid;
  801117:	89 f0                	mov    %esi,%eax
	
}
  801119:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80111c:	5b                   	pop    %ebx
  80111d:	5e                   	pop    %esi
  80111e:	5f                   	pop    %edi
  80111f:	5d                   	pop    %ebp
  801120:	c3                   	ret    

00801121 <sfork>:


// Challenge!
int
sfork(void)
{
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
  801124:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801127:	68 d0 27 80 00       	push   $0x8027d0
  80112c:	68 d1 00 00 00       	push   $0xd1
  801131:	68 e0 26 80 00       	push   $0x8026e0
  801136:	e8 0d 0d 00 00       	call   801e48 <_panic>

0080113b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80113b:	55                   	push   %ebp
  80113c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	05 00 00 00 30       	add    $0x30000000,%eax
  801146:	c1 e8 0c             	shr    $0xc,%eax
}
  801149:	5d                   	pop    %ebp
  80114a:	c3                   	ret    

0080114b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  80114e:	ff 75 08             	pushl  0x8(%ebp)
  801151:	e8 e5 ff ff ff       	call   80113b <fd2num>
  801156:	83 c4 04             	add    $0x4,%esp
  801159:	c1 e0 0c             	shl    $0xc,%eax
  80115c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801161:	c9                   	leave  
  801162:	c3                   	ret    

00801163 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801169:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80116e:	89 c2                	mov    %eax,%edx
  801170:	c1 ea 16             	shr    $0x16,%edx
  801173:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80117a:	f6 c2 01             	test   $0x1,%dl
  80117d:	74 11                	je     801190 <fd_alloc+0x2d>
  80117f:	89 c2                	mov    %eax,%edx
  801181:	c1 ea 0c             	shr    $0xc,%edx
  801184:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80118b:	f6 c2 01             	test   $0x1,%dl
  80118e:	75 09                	jne    801199 <fd_alloc+0x36>
			*fd_store = fd;
  801190:	89 01                	mov    %eax,(%ecx)
			return 0;
  801192:	b8 00 00 00 00       	mov    $0x0,%eax
  801197:	eb 17                	jmp    8011b0 <fd_alloc+0x4d>
  801199:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80119e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011a3:	75 c9                	jne    80116e <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011a5:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8011ab:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8011b0:	5d                   	pop    %ebp
  8011b1:	c3                   	ret    

008011b2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011b2:	55                   	push   %ebp
  8011b3:	89 e5                	mov    %esp,%ebp
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011b8:	83 f8 1f             	cmp    $0x1f,%eax
  8011bb:	77 36                	ja     8011f3 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011bd:	c1 e0 0c             	shl    $0xc,%eax
  8011c0:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011c5:	89 c2                	mov    %eax,%edx
  8011c7:	c1 ea 16             	shr    $0x16,%edx
  8011ca:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011d1:	f6 c2 01             	test   $0x1,%dl
  8011d4:	74 24                	je     8011fa <fd_lookup+0x48>
  8011d6:	89 c2                	mov    %eax,%edx
  8011d8:	c1 ea 0c             	shr    $0xc,%edx
  8011db:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011e2:	f6 c2 01             	test   $0x1,%dl
  8011e5:	74 1a                	je     801201 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ea:	89 02                	mov    %eax,(%edx)
	return 0;
  8011ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f1:	eb 13                	jmp    801206 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f8:	eb 0c                	jmp    801206 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ff:	eb 05                	jmp    801206 <fd_lookup+0x54>
  801201:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  801206:	5d                   	pop    %ebp
  801207:	c3                   	ret    

00801208 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
  80120b:	83 ec 08             	sub    $0x8,%esp
  80120e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801211:	ba ac 28 80 00       	mov    $0x8028ac,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801216:	eb 13                	jmp    80122b <dev_lookup+0x23>
  801218:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  80121b:	39 08                	cmp    %ecx,(%eax)
  80121d:	75 0c                	jne    80122b <dev_lookup+0x23>
			*dev = devtab[i];
  80121f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801222:	89 01                	mov    %eax,(%ecx)
			return 0;
  801224:	b8 00 00 00 00       	mov    $0x0,%eax
  801229:	eb 2e                	jmp    801259 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80122b:	8b 02                	mov    (%edx),%eax
  80122d:	85 c0                	test   %eax,%eax
  80122f:	75 e7                	jne    801218 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801231:	a1 04 40 80 00       	mov    0x804004,%eax
  801236:	8b 40 48             	mov    0x48(%eax),%eax
  801239:	83 ec 04             	sub    $0x4,%esp
  80123c:	51                   	push   %ecx
  80123d:	50                   	push   %eax
  80123e:	68 30 28 80 00       	push   $0x802830
  801243:	e8 64 ef ff ff       	call   8001ac <cprintf>
	*dev = 0;
  801248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801251:	83 c4 10             	add    $0x10,%esp
  801254:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801259:	c9                   	leave  
  80125a:	c3                   	ret    

0080125b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
  80125e:	56                   	push   %esi
  80125f:	53                   	push   %ebx
  801260:	83 ec 10             	sub    $0x10,%esp
  801263:	8b 75 08             	mov    0x8(%ebp),%esi
  801266:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801269:	56                   	push   %esi
  80126a:	e8 cc fe ff ff       	call   80113b <fd2num>
  80126f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801272:	89 14 24             	mov    %edx,(%esp)
  801275:	50                   	push   %eax
  801276:	e8 37 ff ff ff       	call   8011b2 <fd_lookup>
  80127b:	83 c4 08             	add    $0x8,%esp
  80127e:	85 c0                	test   %eax,%eax
  801280:	78 05                	js     801287 <fd_close+0x2c>
	    || fd != fd2)
  801282:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801285:	74 0c                	je     801293 <fd_close+0x38>
		return (must_exist ? r : 0);
  801287:	84 db                	test   %bl,%bl
  801289:	ba 00 00 00 00       	mov    $0x0,%edx
  80128e:	0f 44 c2             	cmove  %edx,%eax
  801291:	eb 41                	jmp    8012d4 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801293:	83 ec 08             	sub    $0x8,%esp
  801296:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801299:	50                   	push   %eax
  80129a:	ff 36                	pushl  (%esi)
  80129c:	e8 67 ff ff ff       	call   801208 <dev_lookup>
  8012a1:	89 c3                	mov    %eax,%ebx
  8012a3:	83 c4 10             	add    $0x10,%esp
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	78 1a                	js     8012c4 <fd_close+0x69>
		if (dev->dev_close)
  8012aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ad:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8012b0:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8012b5:	85 c0                	test   %eax,%eax
  8012b7:	74 0b                	je     8012c4 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  8012b9:	83 ec 0c             	sub    $0xc,%esp
  8012bc:	56                   	push   %esi
  8012bd:	ff d0                	call   *%eax
  8012bf:	89 c3                	mov    %eax,%ebx
  8012c1:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8012c4:	83 ec 08             	sub    $0x8,%esp
  8012c7:	56                   	push   %esi
  8012c8:	6a 00                	push   $0x0
  8012ca:	e8 e2 f8 ff ff       	call   800bb1 <sys_page_unmap>
	return r;
  8012cf:	83 c4 10             	add    $0x10,%esp
  8012d2:	89 d8                	mov    %ebx,%eax
}
  8012d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012d7:	5b                   	pop    %ebx
  8012d8:	5e                   	pop    %esi
  8012d9:	5d                   	pop    %ebp
  8012da:	c3                   	ret    

008012db <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e4:	50                   	push   %eax
  8012e5:	ff 75 08             	pushl  0x8(%ebp)
  8012e8:	e8 c5 fe ff ff       	call   8011b2 <fd_lookup>
  8012ed:	83 c4 08             	add    $0x8,%esp
  8012f0:	85 c0                	test   %eax,%eax
  8012f2:	78 10                	js     801304 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8012f4:	83 ec 08             	sub    $0x8,%esp
  8012f7:	6a 01                	push   $0x1
  8012f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8012fc:	e8 5a ff ff ff       	call   80125b <fd_close>
  801301:	83 c4 10             	add    $0x10,%esp
}
  801304:	c9                   	leave  
  801305:	c3                   	ret    

00801306 <close_all>:

void
close_all(void)
{
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
  801309:	53                   	push   %ebx
  80130a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80130d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801312:	83 ec 0c             	sub    $0xc,%esp
  801315:	53                   	push   %ebx
  801316:	e8 c0 ff ff ff       	call   8012db <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80131b:	83 c3 01             	add    $0x1,%ebx
  80131e:	83 c4 10             	add    $0x10,%esp
  801321:	83 fb 20             	cmp    $0x20,%ebx
  801324:	75 ec                	jne    801312 <close_all+0xc>
		close(i);
}
  801326:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801329:	c9                   	leave  
  80132a:	c3                   	ret    

0080132b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	57                   	push   %edi
  80132f:	56                   	push   %esi
  801330:	53                   	push   %ebx
  801331:	83 ec 2c             	sub    $0x2c,%esp
  801334:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801337:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80133a:	50                   	push   %eax
  80133b:	ff 75 08             	pushl  0x8(%ebp)
  80133e:	e8 6f fe ff ff       	call   8011b2 <fd_lookup>
  801343:	83 c4 08             	add    $0x8,%esp
  801346:	85 c0                	test   %eax,%eax
  801348:	0f 88 c1 00 00 00    	js     80140f <dup+0xe4>
		return r;
	close(newfdnum);
  80134e:	83 ec 0c             	sub    $0xc,%esp
  801351:	56                   	push   %esi
  801352:	e8 84 ff ff ff       	call   8012db <close>

	newfd = INDEX2FD(newfdnum);
  801357:	89 f3                	mov    %esi,%ebx
  801359:	c1 e3 0c             	shl    $0xc,%ebx
  80135c:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801362:	83 c4 04             	add    $0x4,%esp
  801365:	ff 75 e4             	pushl  -0x1c(%ebp)
  801368:	e8 de fd ff ff       	call   80114b <fd2data>
  80136d:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  80136f:	89 1c 24             	mov    %ebx,(%esp)
  801372:	e8 d4 fd ff ff       	call   80114b <fd2data>
  801377:	83 c4 10             	add    $0x10,%esp
  80137a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80137d:	89 f8                	mov    %edi,%eax
  80137f:	c1 e8 16             	shr    $0x16,%eax
  801382:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801389:	a8 01                	test   $0x1,%al
  80138b:	74 37                	je     8013c4 <dup+0x99>
  80138d:	89 f8                	mov    %edi,%eax
  80138f:	c1 e8 0c             	shr    $0xc,%eax
  801392:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801399:	f6 c2 01             	test   $0x1,%dl
  80139c:	74 26                	je     8013c4 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80139e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013a5:	83 ec 0c             	sub    $0xc,%esp
  8013a8:	25 07 0e 00 00       	and    $0xe07,%eax
  8013ad:	50                   	push   %eax
  8013ae:	ff 75 d4             	pushl  -0x2c(%ebp)
  8013b1:	6a 00                	push   $0x0
  8013b3:	57                   	push   %edi
  8013b4:	6a 00                	push   $0x0
  8013b6:	e8 d0 f7 ff ff       	call   800b8b <sys_page_map>
  8013bb:	89 c7                	mov    %eax,%edi
  8013bd:	83 c4 20             	add    $0x20,%esp
  8013c0:	85 c0                	test   %eax,%eax
  8013c2:	78 2e                	js     8013f2 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013c7:	89 d0                	mov    %edx,%eax
  8013c9:	c1 e8 0c             	shr    $0xc,%eax
  8013cc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013d3:	83 ec 0c             	sub    $0xc,%esp
  8013d6:	25 07 0e 00 00       	and    $0xe07,%eax
  8013db:	50                   	push   %eax
  8013dc:	53                   	push   %ebx
  8013dd:	6a 00                	push   $0x0
  8013df:	52                   	push   %edx
  8013e0:	6a 00                	push   $0x0
  8013e2:	e8 a4 f7 ff ff       	call   800b8b <sys_page_map>
  8013e7:	89 c7                	mov    %eax,%edi
  8013e9:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  8013ec:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013ee:	85 ff                	test   %edi,%edi
  8013f0:	79 1d                	jns    80140f <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8013f2:	83 ec 08             	sub    $0x8,%esp
  8013f5:	53                   	push   %ebx
  8013f6:	6a 00                	push   $0x0
  8013f8:	e8 b4 f7 ff ff       	call   800bb1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013fd:	83 c4 08             	add    $0x8,%esp
  801400:	ff 75 d4             	pushl  -0x2c(%ebp)
  801403:	6a 00                	push   $0x0
  801405:	e8 a7 f7 ff ff       	call   800bb1 <sys_page_unmap>
	return r;
  80140a:	83 c4 10             	add    $0x10,%esp
  80140d:	89 f8                	mov    %edi,%eax
}
  80140f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801412:	5b                   	pop    %ebx
  801413:	5e                   	pop    %esi
  801414:	5f                   	pop    %edi
  801415:	5d                   	pop    %ebp
  801416:	c3                   	ret    

00801417 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	53                   	push   %ebx
  80141b:	83 ec 14             	sub    $0x14,%esp
  80141e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801421:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801424:	50                   	push   %eax
  801425:	53                   	push   %ebx
  801426:	e8 87 fd ff ff       	call   8011b2 <fd_lookup>
  80142b:	83 c4 08             	add    $0x8,%esp
  80142e:	89 c2                	mov    %eax,%edx
  801430:	85 c0                	test   %eax,%eax
  801432:	78 6d                	js     8014a1 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801434:	83 ec 08             	sub    $0x8,%esp
  801437:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143a:	50                   	push   %eax
  80143b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143e:	ff 30                	pushl  (%eax)
  801440:	e8 c3 fd ff ff       	call   801208 <dev_lookup>
  801445:	83 c4 10             	add    $0x10,%esp
  801448:	85 c0                	test   %eax,%eax
  80144a:	78 4c                	js     801498 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80144c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80144f:	8b 42 08             	mov    0x8(%edx),%eax
  801452:	83 e0 03             	and    $0x3,%eax
  801455:	83 f8 01             	cmp    $0x1,%eax
  801458:	75 21                	jne    80147b <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80145a:	a1 04 40 80 00       	mov    0x804004,%eax
  80145f:	8b 40 48             	mov    0x48(%eax),%eax
  801462:	83 ec 04             	sub    $0x4,%esp
  801465:	53                   	push   %ebx
  801466:	50                   	push   %eax
  801467:	68 71 28 80 00       	push   $0x802871
  80146c:	e8 3b ed ff ff       	call   8001ac <cprintf>
		return -E_INVAL;
  801471:	83 c4 10             	add    $0x10,%esp
  801474:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801479:	eb 26                	jmp    8014a1 <read+0x8a>
	}
	if (!dev->dev_read)
  80147b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147e:	8b 40 08             	mov    0x8(%eax),%eax
  801481:	85 c0                	test   %eax,%eax
  801483:	74 17                	je     80149c <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801485:	83 ec 04             	sub    $0x4,%esp
  801488:	ff 75 10             	pushl  0x10(%ebp)
  80148b:	ff 75 0c             	pushl  0xc(%ebp)
  80148e:	52                   	push   %edx
  80148f:	ff d0                	call   *%eax
  801491:	89 c2                	mov    %eax,%edx
  801493:	83 c4 10             	add    $0x10,%esp
  801496:	eb 09                	jmp    8014a1 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801498:	89 c2                	mov    %eax,%edx
  80149a:	eb 05                	jmp    8014a1 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80149c:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  8014a1:	89 d0                	mov    %edx,%eax
  8014a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a6:	c9                   	leave  
  8014a7:	c3                   	ret    

008014a8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
  8014ab:	57                   	push   %edi
  8014ac:	56                   	push   %esi
  8014ad:	53                   	push   %ebx
  8014ae:	83 ec 0c             	sub    $0xc,%esp
  8014b1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014b4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014bc:	eb 21                	jmp    8014df <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014be:	83 ec 04             	sub    $0x4,%esp
  8014c1:	89 f0                	mov    %esi,%eax
  8014c3:	29 d8                	sub    %ebx,%eax
  8014c5:	50                   	push   %eax
  8014c6:	89 d8                	mov    %ebx,%eax
  8014c8:	03 45 0c             	add    0xc(%ebp),%eax
  8014cb:	50                   	push   %eax
  8014cc:	57                   	push   %edi
  8014cd:	e8 45 ff ff ff       	call   801417 <read>
		if (m < 0)
  8014d2:	83 c4 10             	add    $0x10,%esp
  8014d5:	85 c0                	test   %eax,%eax
  8014d7:	78 10                	js     8014e9 <readn+0x41>
			return m;
		if (m == 0)
  8014d9:	85 c0                	test   %eax,%eax
  8014db:	74 0a                	je     8014e7 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014dd:	01 c3                	add    %eax,%ebx
  8014df:	39 f3                	cmp    %esi,%ebx
  8014e1:	72 db                	jb     8014be <readn+0x16>
  8014e3:	89 d8                	mov    %ebx,%eax
  8014e5:	eb 02                	jmp    8014e9 <readn+0x41>
  8014e7:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8014e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014ec:	5b                   	pop    %ebx
  8014ed:	5e                   	pop    %esi
  8014ee:	5f                   	pop    %edi
  8014ef:	5d                   	pop    %ebp
  8014f0:	c3                   	ret    

008014f1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
  8014f4:	53                   	push   %ebx
  8014f5:	83 ec 14             	sub    $0x14,%esp
  8014f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014fe:	50                   	push   %eax
  8014ff:	53                   	push   %ebx
  801500:	e8 ad fc ff ff       	call   8011b2 <fd_lookup>
  801505:	83 c4 08             	add    $0x8,%esp
  801508:	89 c2                	mov    %eax,%edx
  80150a:	85 c0                	test   %eax,%eax
  80150c:	78 68                	js     801576 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80150e:	83 ec 08             	sub    $0x8,%esp
  801511:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801514:	50                   	push   %eax
  801515:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801518:	ff 30                	pushl  (%eax)
  80151a:	e8 e9 fc ff ff       	call   801208 <dev_lookup>
  80151f:	83 c4 10             	add    $0x10,%esp
  801522:	85 c0                	test   %eax,%eax
  801524:	78 47                	js     80156d <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801529:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80152d:	75 21                	jne    801550 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80152f:	a1 04 40 80 00       	mov    0x804004,%eax
  801534:	8b 40 48             	mov    0x48(%eax),%eax
  801537:	83 ec 04             	sub    $0x4,%esp
  80153a:	53                   	push   %ebx
  80153b:	50                   	push   %eax
  80153c:	68 8d 28 80 00       	push   $0x80288d
  801541:	e8 66 ec ff ff       	call   8001ac <cprintf>
		return -E_INVAL;
  801546:	83 c4 10             	add    $0x10,%esp
  801549:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80154e:	eb 26                	jmp    801576 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801550:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801553:	8b 52 0c             	mov    0xc(%edx),%edx
  801556:	85 d2                	test   %edx,%edx
  801558:	74 17                	je     801571 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80155a:	83 ec 04             	sub    $0x4,%esp
  80155d:	ff 75 10             	pushl  0x10(%ebp)
  801560:	ff 75 0c             	pushl  0xc(%ebp)
  801563:	50                   	push   %eax
  801564:	ff d2                	call   *%edx
  801566:	89 c2                	mov    %eax,%edx
  801568:	83 c4 10             	add    $0x10,%esp
  80156b:	eb 09                	jmp    801576 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80156d:	89 c2                	mov    %eax,%edx
  80156f:	eb 05                	jmp    801576 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801571:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  801576:	89 d0                	mov    %edx,%eax
  801578:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <seek>:

int
seek(int fdnum, off_t offset)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801583:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801586:	50                   	push   %eax
  801587:	ff 75 08             	pushl  0x8(%ebp)
  80158a:	e8 23 fc ff ff       	call   8011b2 <fd_lookup>
  80158f:	83 c4 08             	add    $0x8,%esp
  801592:	85 c0                	test   %eax,%eax
  801594:	78 0e                	js     8015a4 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801596:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801599:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80159f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	53                   	push   %ebx
  8015aa:	83 ec 14             	sub    $0x14,%esp
  8015ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b3:	50                   	push   %eax
  8015b4:	53                   	push   %ebx
  8015b5:	e8 f8 fb ff ff       	call   8011b2 <fd_lookup>
  8015ba:	83 c4 08             	add    $0x8,%esp
  8015bd:	89 c2                	mov    %eax,%edx
  8015bf:	85 c0                	test   %eax,%eax
  8015c1:	78 65                	js     801628 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015c3:	83 ec 08             	sub    $0x8,%esp
  8015c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c9:	50                   	push   %eax
  8015ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cd:	ff 30                	pushl  (%eax)
  8015cf:	e8 34 fc ff ff       	call   801208 <dev_lookup>
  8015d4:	83 c4 10             	add    $0x10,%esp
  8015d7:	85 c0                	test   %eax,%eax
  8015d9:	78 44                	js     80161f <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015de:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015e2:	75 21                	jne    801605 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8015e4:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015e9:	8b 40 48             	mov    0x48(%eax),%eax
  8015ec:	83 ec 04             	sub    $0x4,%esp
  8015ef:	53                   	push   %ebx
  8015f0:	50                   	push   %eax
  8015f1:	68 50 28 80 00       	push   $0x802850
  8015f6:	e8 b1 eb ff ff       	call   8001ac <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8015fb:	83 c4 10             	add    $0x10,%esp
  8015fe:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801603:	eb 23                	jmp    801628 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  801605:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801608:	8b 52 18             	mov    0x18(%edx),%edx
  80160b:	85 d2                	test   %edx,%edx
  80160d:	74 14                	je     801623 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80160f:	83 ec 08             	sub    $0x8,%esp
  801612:	ff 75 0c             	pushl  0xc(%ebp)
  801615:	50                   	push   %eax
  801616:	ff d2                	call   *%edx
  801618:	89 c2                	mov    %eax,%edx
  80161a:	83 c4 10             	add    $0x10,%esp
  80161d:	eb 09                	jmp    801628 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80161f:	89 c2                	mov    %eax,%edx
  801621:	eb 05                	jmp    801628 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801623:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  801628:	89 d0                	mov    %edx,%eax
  80162a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
  801632:	53                   	push   %ebx
  801633:	83 ec 14             	sub    $0x14,%esp
  801636:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801639:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80163c:	50                   	push   %eax
  80163d:	ff 75 08             	pushl  0x8(%ebp)
  801640:	e8 6d fb ff ff       	call   8011b2 <fd_lookup>
  801645:	83 c4 08             	add    $0x8,%esp
  801648:	89 c2                	mov    %eax,%edx
  80164a:	85 c0                	test   %eax,%eax
  80164c:	78 58                	js     8016a6 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80164e:	83 ec 08             	sub    $0x8,%esp
  801651:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801654:	50                   	push   %eax
  801655:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801658:	ff 30                	pushl  (%eax)
  80165a:	e8 a9 fb ff ff       	call   801208 <dev_lookup>
  80165f:	83 c4 10             	add    $0x10,%esp
  801662:	85 c0                	test   %eax,%eax
  801664:	78 37                	js     80169d <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  801666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801669:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80166d:	74 32                	je     8016a1 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80166f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801672:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801679:	00 00 00 
	stat->st_isdir = 0;
  80167c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801683:	00 00 00 
	stat->st_dev = dev;
  801686:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80168c:	83 ec 08             	sub    $0x8,%esp
  80168f:	53                   	push   %ebx
  801690:	ff 75 f0             	pushl  -0x10(%ebp)
  801693:	ff 50 14             	call   *0x14(%eax)
  801696:	89 c2                	mov    %eax,%edx
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	eb 09                	jmp    8016a6 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80169d:	89 c2                	mov    %eax,%edx
  80169f:	eb 05                	jmp    8016a6 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8016a1:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8016a6:	89 d0                	mov    %edx,%eax
  8016a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	56                   	push   %esi
  8016b1:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016b2:	83 ec 08             	sub    $0x8,%esp
  8016b5:	6a 00                	push   $0x0
  8016b7:	ff 75 08             	pushl  0x8(%ebp)
  8016ba:	e8 06 02 00 00       	call   8018c5 <open>
  8016bf:	89 c3                	mov    %eax,%ebx
  8016c1:	83 c4 10             	add    $0x10,%esp
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	78 1b                	js     8016e3 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016c8:	83 ec 08             	sub    $0x8,%esp
  8016cb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ce:	50                   	push   %eax
  8016cf:	e8 5b ff ff ff       	call   80162f <fstat>
  8016d4:	89 c6                	mov    %eax,%esi
	close(fd);
  8016d6:	89 1c 24             	mov    %ebx,(%esp)
  8016d9:	e8 fd fb ff ff       	call   8012db <close>
	return r;
  8016de:	83 c4 10             	add    $0x10,%esp
  8016e1:	89 f0                	mov    %esi,%eax
}
  8016e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016e6:	5b                   	pop    %ebx
  8016e7:	5e                   	pop    %esi
  8016e8:	5d                   	pop    %ebp
  8016e9:	c3                   	ret    

008016ea <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
  8016ed:	56                   	push   %esi
  8016ee:	53                   	push   %ebx
  8016ef:	89 c6                	mov    %eax,%esi
  8016f1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016f3:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016fa:	75 12                	jne    80170e <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016fc:	83 ec 0c             	sub    $0xc,%esp
  8016ff:	6a 01                	push   $0x1
  801701:	e8 da 08 00 00       	call   801fe0 <ipc_find_env>
  801706:	a3 00 40 80 00       	mov    %eax,0x804000
  80170b:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80170e:	6a 07                	push   $0x7
  801710:	68 00 50 80 00       	push   $0x805000
  801715:	56                   	push   %esi
  801716:	ff 35 00 40 80 00    	pushl  0x804000
  80171c:	e8 6b 08 00 00       	call   801f8c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801721:	83 c4 0c             	add    $0xc,%esp
  801724:	6a 00                	push   $0x0
  801726:	53                   	push   %ebx
  801727:	6a 00                	push   $0x0
  801729:	e8 f3 07 00 00       	call   801f21 <ipc_recv>
}
  80172e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801731:	5b                   	pop    %ebx
  801732:	5e                   	pop    %esi
  801733:	5d                   	pop    %ebp
  801734:	c3                   	ret    

00801735 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	8b 40 0c             	mov    0xc(%eax),%eax
  801741:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801746:	8b 45 0c             	mov    0xc(%ebp),%eax
  801749:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80174e:	ba 00 00 00 00       	mov    $0x0,%edx
  801753:	b8 02 00 00 00       	mov    $0x2,%eax
  801758:	e8 8d ff ff ff       	call   8016ea <fsipc>
}
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801765:	8b 45 08             	mov    0x8(%ebp),%eax
  801768:	8b 40 0c             	mov    0xc(%eax),%eax
  80176b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801770:	ba 00 00 00 00       	mov    $0x0,%edx
  801775:	b8 06 00 00 00       	mov    $0x6,%eax
  80177a:	e8 6b ff ff ff       	call   8016ea <fsipc>
}
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	53                   	push   %ebx
  801785:	83 ec 04             	sub    $0x4,%esp
  801788:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	8b 40 0c             	mov    0xc(%eax),%eax
  801791:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801796:	ba 00 00 00 00       	mov    $0x0,%edx
  80179b:	b8 05 00 00 00       	mov    $0x5,%eax
  8017a0:	e8 45 ff ff ff       	call   8016ea <fsipc>
  8017a5:	85 c0                	test   %eax,%eax
  8017a7:	78 2c                	js     8017d5 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017a9:	83 ec 08             	sub    $0x8,%esp
  8017ac:	68 00 50 80 00       	push   $0x805000
  8017b1:	53                   	push   %ebx
  8017b2:	e8 67 ef ff ff       	call   80071e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017b7:	a1 80 50 80 00       	mov    0x805080,%eax
  8017bc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017c2:	a1 84 50 80 00       	mov    0x805084,%eax
  8017c7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017cd:	83 c4 10             	add    $0x10,%esp
  8017d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	83 ec 08             	sub    $0x8,%esp
  8017e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e3:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017e9:	8b 49 0c             	mov    0xc(%ecx),%ecx
  8017ec:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  8017f2:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8017f7:	76 22                	jbe    80181b <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  8017f9:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  801800:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  801803:	83 ec 04             	sub    $0x4,%esp
  801806:	68 f8 0f 00 00       	push   $0xff8
  80180b:	52                   	push   %edx
  80180c:	68 08 50 80 00       	push   $0x805008
  801811:	e8 9b f0 ff ff       	call   8008b1 <memmove>
  801816:	83 c4 10             	add    $0x10,%esp
  801819:	eb 17                	jmp    801832 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  80181b:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  801820:	83 ec 04             	sub    $0x4,%esp
  801823:	50                   	push   %eax
  801824:	52                   	push   %edx
  801825:	68 08 50 80 00       	push   $0x805008
  80182a:	e8 82 f0 ff ff       	call   8008b1 <memmove>
  80182f:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  801832:	ba 00 00 00 00       	mov    $0x0,%edx
  801837:	b8 04 00 00 00       	mov    $0x4,%eax
  80183c:	e8 a9 fe ff ff       	call   8016ea <fsipc>
	if (result < 0)
		return result;

	return result;
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	56                   	push   %esi
  801847:	53                   	push   %ebx
  801848:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
  80184e:	8b 40 0c             	mov    0xc(%eax),%eax
  801851:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801856:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80185c:	ba 00 00 00 00       	mov    $0x0,%edx
  801861:	b8 03 00 00 00       	mov    $0x3,%eax
  801866:	e8 7f fe ff ff       	call   8016ea <fsipc>
  80186b:	89 c3                	mov    %eax,%ebx
  80186d:	85 c0                	test   %eax,%eax
  80186f:	78 4b                	js     8018bc <devfile_read+0x79>
		return r;
	assert(r <= n);
  801871:	39 c6                	cmp    %eax,%esi
  801873:	73 16                	jae    80188b <devfile_read+0x48>
  801875:	68 bc 28 80 00       	push   $0x8028bc
  80187a:	68 c3 28 80 00       	push   $0x8028c3
  80187f:	6a 7c                	push   $0x7c
  801881:	68 d8 28 80 00       	push   $0x8028d8
  801886:	e8 bd 05 00 00       	call   801e48 <_panic>
	assert(r <= PGSIZE);
  80188b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801890:	7e 16                	jle    8018a8 <devfile_read+0x65>
  801892:	68 e3 28 80 00       	push   $0x8028e3
  801897:	68 c3 28 80 00       	push   $0x8028c3
  80189c:	6a 7d                	push   $0x7d
  80189e:	68 d8 28 80 00       	push   $0x8028d8
  8018a3:	e8 a0 05 00 00       	call   801e48 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018a8:	83 ec 04             	sub    $0x4,%esp
  8018ab:	50                   	push   %eax
  8018ac:	68 00 50 80 00       	push   $0x805000
  8018b1:	ff 75 0c             	pushl  0xc(%ebp)
  8018b4:	e8 f8 ef ff ff       	call   8008b1 <memmove>
	return r;
  8018b9:	83 c4 10             	add    $0x10,%esp
}
  8018bc:	89 d8                	mov    %ebx,%eax
  8018be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c1:	5b                   	pop    %ebx
  8018c2:	5e                   	pop    %esi
  8018c3:	5d                   	pop    %ebp
  8018c4:	c3                   	ret    

008018c5 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	53                   	push   %ebx
  8018c9:	83 ec 20             	sub    $0x20,%esp
  8018cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8018cf:	53                   	push   %ebx
  8018d0:	e8 10 ee ff ff       	call   8006e5 <strlen>
  8018d5:	83 c4 10             	add    $0x10,%esp
  8018d8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018dd:	7f 67                	jg     801946 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8018df:	83 ec 0c             	sub    $0xc,%esp
  8018e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e5:	50                   	push   %eax
  8018e6:	e8 78 f8 ff ff       	call   801163 <fd_alloc>
  8018eb:	83 c4 10             	add    $0x10,%esp
		return r;
  8018ee:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8018f0:	85 c0                	test   %eax,%eax
  8018f2:	78 57                	js     80194b <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8018f4:	83 ec 08             	sub    $0x8,%esp
  8018f7:	53                   	push   %ebx
  8018f8:	68 00 50 80 00       	push   $0x805000
  8018fd:	e8 1c ee ff ff       	call   80071e <strcpy>
	fsipcbuf.open.req_omode = mode;
  801902:	8b 45 0c             	mov    0xc(%ebp),%eax
  801905:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80190a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80190d:	b8 01 00 00 00       	mov    $0x1,%eax
  801912:	e8 d3 fd ff ff       	call   8016ea <fsipc>
  801917:	89 c3                	mov    %eax,%ebx
  801919:	83 c4 10             	add    $0x10,%esp
  80191c:	85 c0                	test   %eax,%eax
  80191e:	79 14                	jns    801934 <open+0x6f>
		fd_close(fd, 0);
  801920:	83 ec 08             	sub    $0x8,%esp
  801923:	6a 00                	push   $0x0
  801925:	ff 75 f4             	pushl  -0xc(%ebp)
  801928:	e8 2e f9 ff ff       	call   80125b <fd_close>
		return r;
  80192d:	83 c4 10             	add    $0x10,%esp
  801930:	89 da                	mov    %ebx,%edx
  801932:	eb 17                	jmp    80194b <open+0x86>
	}

	return fd2num(fd);
  801934:	83 ec 0c             	sub    $0xc,%esp
  801937:	ff 75 f4             	pushl  -0xc(%ebp)
  80193a:	e8 fc f7 ff ff       	call   80113b <fd2num>
  80193f:	89 c2                	mov    %eax,%edx
  801941:	83 c4 10             	add    $0x10,%esp
  801944:	eb 05                	jmp    80194b <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801946:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  80194b:	89 d0                	mov    %edx,%eax
  80194d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801958:	ba 00 00 00 00       	mov    $0x0,%edx
  80195d:	b8 08 00 00 00       	mov    $0x8,%eax
  801962:	e8 83 fd ff ff       	call   8016ea <fsipc>
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	56                   	push   %esi
  80196d:	53                   	push   %ebx
  80196e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801971:	83 ec 0c             	sub    $0xc,%esp
  801974:	ff 75 08             	pushl  0x8(%ebp)
  801977:	e8 cf f7 ff ff       	call   80114b <fd2data>
  80197c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80197e:	83 c4 08             	add    $0x8,%esp
  801981:	68 ef 28 80 00       	push   $0x8028ef
  801986:	53                   	push   %ebx
  801987:	e8 92 ed ff ff       	call   80071e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80198c:	8b 46 04             	mov    0x4(%esi),%eax
  80198f:	2b 06                	sub    (%esi),%eax
  801991:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801997:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80199e:	00 00 00 
	stat->st_dev = &devpipe;
  8019a1:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8019a8:	30 80 00 
	return 0;
}
  8019ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b3:	5b                   	pop    %ebx
  8019b4:	5e                   	pop    %esi
  8019b5:	5d                   	pop    %ebp
  8019b6:	c3                   	ret    

008019b7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	53                   	push   %ebx
  8019bb:	83 ec 0c             	sub    $0xc,%esp
  8019be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8019c1:	53                   	push   %ebx
  8019c2:	6a 00                	push   $0x0
  8019c4:	e8 e8 f1 ff ff       	call   800bb1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8019c9:	89 1c 24             	mov    %ebx,(%esp)
  8019cc:	e8 7a f7 ff ff       	call   80114b <fd2data>
  8019d1:	83 c4 08             	add    $0x8,%esp
  8019d4:	50                   	push   %eax
  8019d5:	6a 00                	push   $0x0
  8019d7:	e8 d5 f1 ff ff       	call   800bb1 <sys_page_unmap>
}
  8019dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	57                   	push   %edi
  8019e5:	56                   	push   %esi
  8019e6:	53                   	push   %ebx
  8019e7:	83 ec 1c             	sub    $0x1c,%esp
  8019ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019ed:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8019ef:	a1 04 40 80 00       	mov    0x804004,%eax
  8019f4:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  8019f7:	83 ec 0c             	sub    $0xc,%esp
  8019fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8019fd:	e8 17 06 00 00       	call   802019 <pageref>
  801a02:	89 c3                	mov    %eax,%ebx
  801a04:	89 3c 24             	mov    %edi,(%esp)
  801a07:	e8 0d 06 00 00       	call   802019 <pageref>
  801a0c:	83 c4 10             	add    $0x10,%esp
  801a0f:	39 c3                	cmp    %eax,%ebx
  801a11:	0f 94 c1             	sete   %cl
  801a14:	0f b6 c9             	movzbl %cl,%ecx
  801a17:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801a1a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a20:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a23:	39 ce                	cmp    %ecx,%esi
  801a25:	74 1b                	je     801a42 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801a27:	39 c3                	cmp    %eax,%ebx
  801a29:	75 c4                	jne    8019ef <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a2b:	8b 42 58             	mov    0x58(%edx),%eax
  801a2e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a31:	50                   	push   %eax
  801a32:	56                   	push   %esi
  801a33:	68 f6 28 80 00       	push   $0x8028f6
  801a38:	e8 6f e7 ff ff       	call   8001ac <cprintf>
  801a3d:	83 c4 10             	add    $0x10,%esp
  801a40:	eb ad                	jmp    8019ef <_pipeisclosed+0xe>
	}
}
  801a42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a48:	5b                   	pop    %ebx
  801a49:	5e                   	pop    %esi
  801a4a:	5f                   	pop    %edi
  801a4b:	5d                   	pop    %ebp
  801a4c:	c3                   	ret    

00801a4d <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
  801a50:	57                   	push   %edi
  801a51:	56                   	push   %esi
  801a52:	53                   	push   %ebx
  801a53:	83 ec 28             	sub    $0x28,%esp
  801a56:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801a59:	56                   	push   %esi
  801a5a:	e8 ec f6 ff ff       	call   80114b <fd2data>
  801a5f:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a61:	83 c4 10             	add    $0x10,%esp
  801a64:	bf 00 00 00 00       	mov    $0x0,%edi
  801a69:	eb 4b                	jmp    801ab6 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801a6b:	89 da                	mov    %ebx,%edx
  801a6d:	89 f0                	mov    %esi,%eax
  801a6f:	e8 6d ff ff ff       	call   8019e1 <_pipeisclosed>
  801a74:	85 c0                	test   %eax,%eax
  801a76:	75 48                	jne    801ac0 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801a78:	e8 c3 f0 ff ff       	call   800b40 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a7d:	8b 43 04             	mov    0x4(%ebx),%eax
  801a80:	8b 0b                	mov    (%ebx),%ecx
  801a82:	8d 51 20             	lea    0x20(%ecx),%edx
  801a85:	39 d0                	cmp    %edx,%eax
  801a87:	73 e2                	jae    801a6b <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a8c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801a90:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801a93:	89 c2                	mov    %eax,%edx
  801a95:	c1 fa 1f             	sar    $0x1f,%edx
  801a98:	89 d1                	mov    %edx,%ecx
  801a9a:	c1 e9 1b             	shr    $0x1b,%ecx
  801a9d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801aa0:	83 e2 1f             	and    $0x1f,%edx
  801aa3:	29 ca                	sub    %ecx,%edx
  801aa5:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801aa9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801aad:	83 c0 01             	add    $0x1,%eax
  801ab0:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ab3:	83 c7 01             	add    $0x1,%edi
  801ab6:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ab9:	75 c2                	jne    801a7d <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801abb:	8b 45 10             	mov    0x10(%ebp),%eax
  801abe:	eb 05                	jmp    801ac5 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801ac0:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801ac5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ac8:	5b                   	pop    %ebx
  801ac9:	5e                   	pop    %esi
  801aca:	5f                   	pop    %edi
  801acb:	5d                   	pop    %ebp
  801acc:	c3                   	ret    

00801acd <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	57                   	push   %edi
  801ad1:	56                   	push   %esi
  801ad2:	53                   	push   %ebx
  801ad3:	83 ec 18             	sub    $0x18,%esp
  801ad6:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801ad9:	57                   	push   %edi
  801ada:	e8 6c f6 ff ff       	call   80114b <fd2data>
  801adf:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ae1:	83 c4 10             	add    $0x10,%esp
  801ae4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ae9:	eb 3d                	jmp    801b28 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801aeb:	85 db                	test   %ebx,%ebx
  801aed:	74 04                	je     801af3 <devpipe_read+0x26>
				return i;
  801aef:	89 d8                	mov    %ebx,%eax
  801af1:	eb 44                	jmp    801b37 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801af3:	89 f2                	mov    %esi,%edx
  801af5:	89 f8                	mov    %edi,%eax
  801af7:	e8 e5 fe ff ff       	call   8019e1 <_pipeisclosed>
  801afc:	85 c0                	test   %eax,%eax
  801afe:	75 32                	jne    801b32 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801b00:	e8 3b f0 ff ff       	call   800b40 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801b05:	8b 06                	mov    (%esi),%eax
  801b07:	3b 46 04             	cmp    0x4(%esi),%eax
  801b0a:	74 df                	je     801aeb <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b0c:	99                   	cltd   
  801b0d:	c1 ea 1b             	shr    $0x1b,%edx
  801b10:	01 d0                	add    %edx,%eax
  801b12:	83 e0 1f             	and    $0x1f,%eax
  801b15:	29 d0                	sub    %edx,%eax
  801b17:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801b1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b1f:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801b22:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b25:	83 c3 01             	add    $0x1,%ebx
  801b28:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801b2b:	75 d8                	jne    801b05 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801b2d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b30:	eb 05                	jmp    801b37 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801b32:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801b37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b3a:	5b                   	pop    %ebx
  801b3b:	5e                   	pop    %esi
  801b3c:	5f                   	pop    %edi
  801b3d:	5d                   	pop    %ebp
  801b3e:	c3                   	ret    

00801b3f <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
  801b42:	56                   	push   %esi
  801b43:	53                   	push   %ebx
  801b44:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801b47:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b4a:	50                   	push   %eax
  801b4b:	e8 13 f6 ff ff       	call   801163 <fd_alloc>
  801b50:	83 c4 10             	add    $0x10,%esp
  801b53:	89 c2                	mov    %eax,%edx
  801b55:	85 c0                	test   %eax,%eax
  801b57:	0f 88 2c 01 00 00    	js     801c89 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b5d:	83 ec 04             	sub    $0x4,%esp
  801b60:	68 07 04 00 00       	push   $0x407
  801b65:	ff 75 f4             	pushl  -0xc(%ebp)
  801b68:	6a 00                	push   $0x0
  801b6a:	e8 f8 ef ff ff       	call   800b67 <sys_page_alloc>
  801b6f:	83 c4 10             	add    $0x10,%esp
  801b72:	89 c2                	mov    %eax,%edx
  801b74:	85 c0                	test   %eax,%eax
  801b76:	0f 88 0d 01 00 00    	js     801c89 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801b7c:	83 ec 0c             	sub    $0xc,%esp
  801b7f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b82:	50                   	push   %eax
  801b83:	e8 db f5 ff ff       	call   801163 <fd_alloc>
  801b88:	89 c3                	mov    %eax,%ebx
  801b8a:	83 c4 10             	add    $0x10,%esp
  801b8d:	85 c0                	test   %eax,%eax
  801b8f:	0f 88 e2 00 00 00    	js     801c77 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b95:	83 ec 04             	sub    $0x4,%esp
  801b98:	68 07 04 00 00       	push   $0x407
  801b9d:	ff 75 f0             	pushl  -0x10(%ebp)
  801ba0:	6a 00                	push   $0x0
  801ba2:	e8 c0 ef ff ff       	call   800b67 <sys_page_alloc>
  801ba7:	89 c3                	mov    %eax,%ebx
  801ba9:	83 c4 10             	add    $0x10,%esp
  801bac:	85 c0                	test   %eax,%eax
  801bae:	0f 88 c3 00 00 00    	js     801c77 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801bb4:	83 ec 0c             	sub    $0xc,%esp
  801bb7:	ff 75 f4             	pushl  -0xc(%ebp)
  801bba:	e8 8c f5 ff ff       	call   80114b <fd2data>
  801bbf:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bc1:	83 c4 0c             	add    $0xc,%esp
  801bc4:	68 07 04 00 00       	push   $0x407
  801bc9:	50                   	push   %eax
  801bca:	6a 00                	push   $0x0
  801bcc:	e8 96 ef ff ff       	call   800b67 <sys_page_alloc>
  801bd1:	89 c3                	mov    %eax,%ebx
  801bd3:	83 c4 10             	add    $0x10,%esp
  801bd6:	85 c0                	test   %eax,%eax
  801bd8:	0f 88 89 00 00 00    	js     801c67 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bde:	83 ec 0c             	sub    $0xc,%esp
  801be1:	ff 75 f0             	pushl  -0x10(%ebp)
  801be4:	e8 62 f5 ff ff       	call   80114b <fd2data>
  801be9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801bf0:	50                   	push   %eax
  801bf1:	6a 00                	push   $0x0
  801bf3:	56                   	push   %esi
  801bf4:	6a 00                	push   $0x0
  801bf6:	e8 90 ef ff ff       	call   800b8b <sys_page_map>
  801bfb:	89 c3                	mov    %eax,%ebx
  801bfd:	83 c4 20             	add    $0x20,%esp
  801c00:	85 c0                	test   %eax,%eax
  801c02:	78 55                	js     801c59 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801c04:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c12:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801c19:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c22:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c27:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801c2e:	83 ec 0c             	sub    $0xc,%esp
  801c31:	ff 75 f4             	pushl  -0xc(%ebp)
  801c34:	e8 02 f5 ff ff       	call   80113b <fd2num>
  801c39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c3c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c3e:	83 c4 04             	add    $0x4,%esp
  801c41:	ff 75 f0             	pushl  -0x10(%ebp)
  801c44:	e8 f2 f4 ff ff       	call   80113b <fd2num>
  801c49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c4c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c4f:	83 c4 10             	add    $0x10,%esp
  801c52:	ba 00 00 00 00       	mov    $0x0,%edx
  801c57:	eb 30                	jmp    801c89 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801c59:	83 ec 08             	sub    $0x8,%esp
  801c5c:	56                   	push   %esi
  801c5d:	6a 00                	push   $0x0
  801c5f:	e8 4d ef ff ff       	call   800bb1 <sys_page_unmap>
  801c64:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801c67:	83 ec 08             	sub    $0x8,%esp
  801c6a:	ff 75 f0             	pushl  -0x10(%ebp)
  801c6d:	6a 00                	push   $0x0
  801c6f:	e8 3d ef ff ff       	call   800bb1 <sys_page_unmap>
  801c74:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801c77:	83 ec 08             	sub    $0x8,%esp
  801c7a:	ff 75 f4             	pushl  -0xc(%ebp)
  801c7d:	6a 00                	push   $0x0
  801c7f:	e8 2d ef ff ff       	call   800bb1 <sys_page_unmap>
  801c84:	83 c4 10             	add    $0x10,%esp
  801c87:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  801c89:	89 d0                	mov    %edx,%eax
  801c8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c8e:	5b                   	pop    %ebx
  801c8f:	5e                   	pop    %esi
  801c90:	5d                   	pop    %ebp
  801c91:	c3                   	ret    

00801c92 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
  801c95:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c98:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c9b:	50                   	push   %eax
  801c9c:	ff 75 08             	pushl  0x8(%ebp)
  801c9f:	e8 0e f5 ff ff       	call   8011b2 <fd_lookup>
  801ca4:	83 c4 10             	add    $0x10,%esp
  801ca7:	85 c0                	test   %eax,%eax
  801ca9:	78 18                	js     801cc3 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801cab:	83 ec 0c             	sub    $0xc,%esp
  801cae:	ff 75 f4             	pushl  -0xc(%ebp)
  801cb1:	e8 95 f4 ff ff       	call   80114b <fd2data>
	return _pipeisclosed(fd, p);
  801cb6:	89 c2                	mov    %eax,%edx
  801cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbb:	e8 21 fd ff ff       	call   8019e1 <_pipeisclosed>
  801cc0:	83 c4 10             	add    $0x10,%esp
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801cc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccd:	5d                   	pop    %ebp
  801cce:	c3                   	ret    

00801ccf <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801cd5:	68 0e 29 80 00       	push   $0x80290e
  801cda:	ff 75 0c             	pushl  0xc(%ebp)
  801cdd:	e8 3c ea ff ff       	call   80071e <strcpy>
	return 0;
}
  801ce2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
  801cec:	57                   	push   %edi
  801ced:	56                   	push   %esi
  801cee:	53                   	push   %ebx
  801cef:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801cf5:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801cfa:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d00:	eb 2d                	jmp    801d2f <devcons_write+0x46>
		m = n - tot;
  801d02:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d05:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801d07:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801d0a:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801d0f:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801d12:	83 ec 04             	sub    $0x4,%esp
  801d15:	53                   	push   %ebx
  801d16:	03 45 0c             	add    0xc(%ebp),%eax
  801d19:	50                   	push   %eax
  801d1a:	57                   	push   %edi
  801d1b:	e8 91 eb ff ff       	call   8008b1 <memmove>
		sys_cputs(buf, m);
  801d20:	83 c4 08             	add    $0x8,%esp
  801d23:	53                   	push   %ebx
  801d24:	57                   	push   %edi
  801d25:	e8 86 ed ff ff       	call   800ab0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d2a:	01 de                	add    %ebx,%esi
  801d2c:	83 c4 10             	add    $0x10,%esp
  801d2f:	89 f0                	mov    %esi,%eax
  801d31:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d34:	72 cc                	jb     801d02 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801d36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d39:	5b                   	pop    %ebx
  801d3a:	5e                   	pop    %esi
  801d3b:	5f                   	pop    %edi
  801d3c:	5d                   	pop    %ebp
  801d3d:	c3                   	ret    

00801d3e <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
  801d41:	83 ec 08             	sub    $0x8,%esp
  801d44:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801d49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d4d:	74 2a                	je     801d79 <devcons_read+0x3b>
  801d4f:	eb 05                	jmp    801d56 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801d51:	e8 ea ed ff ff       	call   800b40 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801d56:	e8 7b ed ff ff       	call   800ad6 <sys_cgetc>
  801d5b:	85 c0                	test   %eax,%eax
  801d5d:	74 f2                	je     801d51 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801d5f:	85 c0                	test   %eax,%eax
  801d61:	78 16                	js     801d79 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801d63:	83 f8 04             	cmp    $0x4,%eax
  801d66:	74 0c                	je     801d74 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801d68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6b:	88 02                	mov    %al,(%edx)
	return 1;
  801d6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d72:	eb 05                	jmp    801d79 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801d74:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
  801d7e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801d81:	8b 45 08             	mov    0x8(%ebp),%eax
  801d84:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801d87:	6a 01                	push   $0x1
  801d89:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d8c:	50                   	push   %eax
  801d8d:	e8 1e ed ff ff       	call   800ab0 <sys_cputs>
}
  801d92:	83 c4 10             	add    $0x10,%esp
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <getchar>:

int
getchar(void)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801d9d:	6a 01                	push   $0x1
  801d9f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801da2:	50                   	push   %eax
  801da3:	6a 00                	push   $0x0
  801da5:	e8 6d f6 ff ff       	call   801417 <read>
	if (r < 0)
  801daa:	83 c4 10             	add    $0x10,%esp
  801dad:	85 c0                	test   %eax,%eax
  801daf:	78 0f                	js     801dc0 <getchar+0x29>
		return r;
	if (r < 1)
  801db1:	85 c0                	test   %eax,%eax
  801db3:	7e 06                	jle    801dbb <getchar+0x24>
		return -E_EOF;
	return c;
  801db5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801db9:	eb 05                	jmp    801dc0 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801dbb:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dc8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dcb:	50                   	push   %eax
  801dcc:	ff 75 08             	pushl  0x8(%ebp)
  801dcf:	e8 de f3 ff ff       	call   8011b2 <fd_lookup>
  801dd4:	83 c4 10             	add    $0x10,%esp
  801dd7:	85 c0                	test   %eax,%eax
  801dd9:	78 11                	js     801dec <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dde:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801de4:	39 10                	cmp    %edx,(%eax)
  801de6:	0f 94 c0             	sete   %al
  801de9:	0f b6 c0             	movzbl %al,%eax
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <opencons>:

int
opencons(void)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801df4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801df7:	50                   	push   %eax
  801df8:	e8 66 f3 ff ff       	call   801163 <fd_alloc>
  801dfd:	83 c4 10             	add    $0x10,%esp
		return r;
  801e00:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801e02:	85 c0                	test   %eax,%eax
  801e04:	78 3e                	js     801e44 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e06:	83 ec 04             	sub    $0x4,%esp
  801e09:	68 07 04 00 00       	push   $0x407
  801e0e:	ff 75 f4             	pushl  -0xc(%ebp)
  801e11:	6a 00                	push   $0x0
  801e13:	e8 4f ed ff ff       	call   800b67 <sys_page_alloc>
  801e18:	83 c4 10             	add    $0x10,%esp
		return r;
  801e1b:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e1d:	85 c0                	test   %eax,%eax
  801e1f:	78 23                	js     801e44 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801e21:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e36:	83 ec 0c             	sub    $0xc,%esp
  801e39:	50                   	push   %eax
  801e3a:	e8 fc f2 ff ff       	call   80113b <fd2num>
  801e3f:	89 c2                	mov    %eax,%edx
  801e41:	83 c4 10             	add    $0x10,%esp
}
  801e44:	89 d0                	mov    %edx,%eax
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    

00801e48 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
  801e4b:	56                   	push   %esi
  801e4c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801e4d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801e50:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801e56:	e8 c1 ec ff ff       	call   800b1c <sys_getenvid>
  801e5b:	83 ec 0c             	sub    $0xc,%esp
  801e5e:	ff 75 0c             	pushl  0xc(%ebp)
  801e61:	ff 75 08             	pushl  0x8(%ebp)
  801e64:	56                   	push   %esi
  801e65:	50                   	push   %eax
  801e66:	68 1c 29 80 00       	push   $0x80291c
  801e6b:	e8 3c e3 ff ff       	call   8001ac <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801e70:	83 c4 18             	add    $0x18,%esp
  801e73:	53                   	push   %ebx
  801e74:	ff 75 10             	pushl  0x10(%ebp)
  801e77:	e8 df e2 ff ff       	call   80015b <vcprintf>
	cprintf("\n");
  801e7c:	c7 04 24 94 23 80 00 	movl   $0x802394,(%esp)
  801e83:	e8 24 e3 ff ff       	call   8001ac <cprintf>
  801e88:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801e8b:	cc                   	int3   
  801e8c:	eb fd                	jmp    801e8b <_panic+0x43>

00801e8e <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
  801e91:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801e94:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801e9b:	75 2c                	jne    801ec9 <set_pgfault_handler+0x3b>
		// First time through!
		// LAB 4: Your code here.
		r = sys_page_alloc(0,(void *)(UXSTACKTOP - PGSIZE),PTE_P | PTE_U | PTE_W);
  801e9d:	83 ec 04             	sub    $0x4,%esp
  801ea0:	6a 07                	push   $0x7
  801ea2:	68 00 f0 bf ee       	push   $0xeebff000
  801ea7:	6a 00                	push   $0x0
  801ea9:	e8 b9 ec ff ff       	call   800b67 <sys_page_alloc>
		if(r < 0)
  801eae:	83 c4 10             	add    $0x10,%esp
  801eb1:	85 c0                	test   %eax,%eax
  801eb3:	79 14                	jns    801ec9 <set_pgfault_handler+0x3b>
			panic("set_pgfault_handler: error in sys_page_alloc\n");	
  801eb5:	83 ec 04             	sub    $0x4,%esp
  801eb8:	68 40 29 80 00       	push   $0x802940
  801ebd:	6a 22                	push   $0x22
  801ebf:	68 ac 29 80 00       	push   $0x8029ac
  801ec4:	e8 7f ff ff ff       	call   801e48 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecc:	a3 00 60 80 00       	mov    %eax,0x806000
	r = sys_env_set_pgfault_upcall(0, _pgfault_upcall); 
  801ed1:	83 ec 08             	sub    $0x8,%esp
  801ed4:	68 fd 1e 80 00       	push   $0x801efd
  801ed9:	6a 00                	push   $0x0
  801edb:	e8 3a ed ff ff       	call   800c1a <sys_env_set_pgfault_upcall>
	if (r < 0)
  801ee0:	83 c4 10             	add    $0x10,%esp
  801ee3:	85 c0                	test   %eax,%eax
  801ee5:	79 14                	jns    801efb <set_pgfault_handler+0x6d>
		panic("set_pgfault_handler: error in sys_env_set_pgfault_upcall");
  801ee7:	83 ec 04             	sub    $0x4,%esp
  801eea:	68 70 29 80 00       	push   $0x802970
  801eef:	6a 29                	push   $0x29
  801ef1:	68 ac 29 80 00       	push   $0x8029ac
  801ef6:	e8 4d ff ff ff       	call   801e48 <_panic>
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801efd:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801efe:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801f03:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801f05:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	subl $0x4, 0x30(%esp)
  801f08:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  801f0d:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 0x28(%esp), %ebx 	
  801f11:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  801f15:	89 18                	mov    %ebx,(%eax)
	addl $0x8, %esp
  801f17:	83 c4 08             	add    $0x8,%esp


	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  801f1a:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp 
  801f1b:	83 c4 04             	add    $0x4,%esp
	popfl
  801f1e:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801f1f:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801f20:	c3                   	ret    

00801f21 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	56                   	push   %esi
  801f25:	53                   	push   %ebx
  801f26:	8b 75 08             	mov    0x8(%ebp),%esi
  801f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801f2f:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801f31:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801f36:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801f39:	83 ec 0c             	sub    $0xc,%esp
  801f3c:	50                   	push   %eax
  801f3d:	e8 20 ed ff ff       	call   800c62 <sys_ipc_recv>
	if (from_env_store)
  801f42:	83 c4 10             	add    $0x10,%esp
  801f45:	85 f6                	test   %esi,%esi
  801f47:	74 0b                	je     801f54 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801f49:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801f4f:	8b 52 74             	mov    0x74(%edx),%edx
  801f52:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801f54:	85 db                	test   %ebx,%ebx
  801f56:	74 0b                	je     801f63 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  801f58:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801f5e:	8b 52 78             	mov    0x78(%edx),%edx
  801f61:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  801f63:	85 c0                	test   %eax,%eax
  801f65:	79 16                	jns    801f7d <ipc_recv+0x5c>
		if (from_env_store)
  801f67:	85 f6                	test   %esi,%esi
  801f69:	74 06                	je     801f71 <ipc_recv+0x50>
			*from_env_store = 0;
  801f6b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  801f71:	85 db                	test   %ebx,%ebx
  801f73:	74 10                	je     801f85 <ipc_recv+0x64>
			*perm_store = 0;
  801f75:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801f7b:	eb 08                	jmp    801f85 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  801f7d:	a1 04 40 80 00       	mov    0x804004,%eax
  801f82:	8b 40 70             	mov    0x70(%eax),%eax
}
  801f85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f88:	5b                   	pop    %ebx
  801f89:	5e                   	pop    %esi
  801f8a:	5d                   	pop    %ebp
  801f8b:	c3                   	ret    

00801f8c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
  801f8f:	57                   	push   %edi
  801f90:	56                   	push   %esi
  801f91:	53                   	push   %ebx
  801f92:	83 ec 0c             	sub    $0xc,%esp
  801f95:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f98:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  801f9e:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  801fa0:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801fa5:	0f 44 d8             	cmove  %eax,%ebx
  801fa8:	eb 1c                	jmp    801fc6 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  801faa:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801fad:	74 12                	je     801fc1 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801faf:	50                   	push   %eax
  801fb0:	68 ba 29 80 00       	push   $0x8029ba
  801fb5:	6a 42                	push   $0x42
  801fb7:	68 d0 29 80 00       	push   $0x8029d0
  801fbc:	e8 87 fe ff ff       	call   801e48 <_panic>
		sys_yield();
  801fc1:	e8 7a eb ff ff       	call   800b40 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801fc6:	ff 75 14             	pushl  0x14(%ebp)
  801fc9:	53                   	push   %ebx
  801fca:	56                   	push   %esi
  801fcb:	57                   	push   %edi
  801fcc:	e8 6c ec ff ff       	call   800c3d <sys_ipc_try_send>
  801fd1:	83 c4 10             	add    $0x10,%esp
  801fd4:	85 c0                	test   %eax,%eax
  801fd6:	75 d2                	jne    801faa <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fdb:	5b                   	pop    %ebx
  801fdc:	5e                   	pop    %esi
  801fdd:	5f                   	pop    %edi
  801fde:	5d                   	pop    %ebp
  801fdf:	c3                   	ret    

00801fe0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801fe6:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801feb:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801fee:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801ff4:	8b 52 50             	mov    0x50(%edx),%edx
  801ff7:	39 ca                	cmp    %ecx,%edx
  801ff9:	75 0d                	jne    802008 <ipc_find_env+0x28>
			return envs[i].env_id;
  801ffb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ffe:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802003:	8b 40 48             	mov    0x48(%eax),%eax
  802006:	eb 0f                	jmp    802017 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802008:	83 c0 01             	add    $0x1,%eax
  80200b:	3d 00 04 00 00       	cmp    $0x400,%eax
  802010:	75 d9                	jne    801feb <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802012:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802017:	5d                   	pop    %ebp
  802018:	c3                   	ret    

00802019 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80201f:	89 d0                	mov    %edx,%eax
  802021:	c1 e8 16             	shr    $0x16,%eax
  802024:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80202b:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802030:	f6 c1 01             	test   $0x1,%cl
  802033:	74 1d                	je     802052 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802035:	c1 ea 0c             	shr    $0xc,%edx
  802038:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80203f:	f6 c2 01             	test   $0x1,%dl
  802042:	74 0e                	je     802052 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802044:	c1 ea 0c             	shr    $0xc,%edx
  802047:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80204e:	ef 
  80204f:	0f b7 c0             	movzwl %ax,%eax
}
  802052:	5d                   	pop    %ebp
  802053:	c3                   	ret    
  802054:	66 90                	xchg   %ax,%ax
  802056:	66 90                	xchg   %ax,%ax
  802058:	66 90                	xchg   %ax,%ax
  80205a:	66 90                	xchg   %ax,%ax
  80205c:	66 90                	xchg   %ax,%ax
  80205e:	66 90                	xchg   %ax,%ax

00802060 <__udivdi3>:
  802060:	55                   	push   %ebp
  802061:	57                   	push   %edi
  802062:	56                   	push   %esi
  802063:	53                   	push   %ebx
  802064:	83 ec 1c             	sub    $0x1c,%esp
  802067:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80206b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80206f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802073:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802077:	85 f6                	test   %esi,%esi
  802079:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80207d:	89 ca                	mov    %ecx,%edx
  80207f:	89 f8                	mov    %edi,%eax
  802081:	75 3d                	jne    8020c0 <__udivdi3+0x60>
  802083:	39 cf                	cmp    %ecx,%edi
  802085:	0f 87 c5 00 00 00    	ja     802150 <__udivdi3+0xf0>
  80208b:	85 ff                	test   %edi,%edi
  80208d:	89 fd                	mov    %edi,%ebp
  80208f:	75 0b                	jne    80209c <__udivdi3+0x3c>
  802091:	b8 01 00 00 00       	mov    $0x1,%eax
  802096:	31 d2                	xor    %edx,%edx
  802098:	f7 f7                	div    %edi
  80209a:	89 c5                	mov    %eax,%ebp
  80209c:	89 c8                	mov    %ecx,%eax
  80209e:	31 d2                	xor    %edx,%edx
  8020a0:	f7 f5                	div    %ebp
  8020a2:	89 c1                	mov    %eax,%ecx
  8020a4:	89 d8                	mov    %ebx,%eax
  8020a6:	89 cf                	mov    %ecx,%edi
  8020a8:	f7 f5                	div    %ebp
  8020aa:	89 c3                	mov    %eax,%ebx
  8020ac:	89 d8                	mov    %ebx,%eax
  8020ae:	89 fa                	mov    %edi,%edx
  8020b0:	83 c4 1c             	add    $0x1c,%esp
  8020b3:	5b                   	pop    %ebx
  8020b4:	5e                   	pop    %esi
  8020b5:	5f                   	pop    %edi
  8020b6:	5d                   	pop    %ebp
  8020b7:	c3                   	ret    
  8020b8:	90                   	nop
  8020b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020c0:	39 ce                	cmp    %ecx,%esi
  8020c2:	77 74                	ja     802138 <__udivdi3+0xd8>
  8020c4:	0f bd fe             	bsr    %esi,%edi
  8020c7:	83 f7 1f             	xor    $0x1f,%edi
  8020ca:	0f 84 98 00 00 00    	je     802168 <__udivdi3+0x108>
  8020d0:	bb 20 00 00 00       	mov    $0x20,%ebx
  8020d5:	89 f9                	mov    %edi,%ecx
  8020d7:	89 c5                	mov    %eax,%ebp
  8020d9:	29 fb                	sub    %edi,%ebx
  8020db:	d3 e6                	shl    %cl,%esi
  8020dd:	89 d9                	mov    %ebx,%ecx
  8020df:	d3 ed                	shr    %cl,%ebp
  8020e1:	89 f9                	mov    %edi,%ecx
  8020e3:	d3 e0                	shl    %cl,%eax
  8020e5:	09 ee                	or     %ebp,%esi
  8020e7:	89 d9                	mov    %ebx,%ecx
  8020e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020ed:	89 d5                	mov    %edx,%ebp
  8020ef:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020f3:	d3 ed                	shr    %cl,%ebp
  8020f5:	89 f9                	mov    %edi,%ecx
  8020f7:	d3 e2                	shl    %cl,%edx
  8020f9:	89 d9                	mov    %ebx,%ecx
  8020fb:	d3 e8                	shr    %cl,%eax
  8020fd:	09 c2                	or     %eax,%edx
  8020ff:	89 d0                	mov    %edx,%eax
  802101:	89 ea                	mov    %ebp,%edx
  802103:	f7 f6                	div    %esi
  802105:	89 d5                	mov    %edx,%ebp
  802107:	89 c3                	mov    %eax,%ebx
  802109:	f7 64 24 0c          	mull   0xc(%esp)
  80210d:	39 d5                	cmp    %edx,%ebp
  80210f:	72 10                	jb     802121 <__udivdi3+0xc1>
  802111:	8b 74 24 08          	mov    0x8(%esp),%esi
  802115:	89 f9                	mov    %edi,%ecx
  802117:	d3 e6                	shl    %cl,%esi
  802119:	39 c6                	cmp    %eax,%esi
  80211b:	73 07                	jae    802124 <__udivdi3+0xc4>
  80211d:	39 d5                	cmp    %edx,%ebp
  80211f:	75 03                	jne    802124 <__udivdi3+0xc4>
  802121:	83 eb 01             	sub    $0x1,%ebx
  802124:	31 ff                	xor    %edi,%edi
  802126:	89 d8                	mov    %ebx,%eax
  802128:	89 fa                	mov    %edi,%edx
  80212a:	83 c4 1c             	add    $0x1c,%esp
  80212d:	5b                   	pop    %ebx
  80212e:	5e                   	pop    %esi
  80212f:	5f                   	pop    %edi
  802130:	5d                   	pop    %ebp
  802131:	c3                   	ret    
  802132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802138:	31 ff                	xor    %edi,%edi
  80213a:	31 db                	xor    %ebx,%ebx
  80213c:	89 d8                	mov    %ebx,%eax
  80213e:	89 fa                	mov    %edi,%edx
  802140:	83 c4 1c             	add    $0x1c,%esp
  802143:	5b                   	pop    %ebx
  802144:	5e                   	pop    %esi
  802145:	5f                   	pop    %edi
  802146:	5d                   	pop    %ebp
  802147:	c3                   	ret    
  802148:	90                   	nop
  802149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802150:	89 d8                	mov    %ebx,%eax
  802152:	f7 f7                	div    %edi
  802154:	31 ff                	xor    %edi,%edi
  802156:	89 c3                	mov    %eax,%ebx
  802158:	89 d8                	mov    %ebx,%eax
  80215a:	89 fa                	mov    %edi,%edx
  80215c:	83 c4 1c             	add    $0x1c,%esp
  80215f:	5b                   	pop    %ebx
  802160:	5e                   	pop    %esi
  802161:	5f                   	pop    %edi
  802162:	5d                   	pop    %ebp
  802163:	c3                   	ret    
  802164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802168:	39 ce                	cmp    %ecx,%esi
  80216a:	72 0c                	jb     802178 <__udivdi3+0x118>
  80216c:	31 db                	xor    %ebx,%ebx
  80216e:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802172:	0f 87 34 ff ff ff    	ja     8020ac <__udivdi3+0x4c>
  802178:	bb 01 00 00 00       	mov    $0x1,%ebx
  80217d:	e9 2a ff ff ff       	jmp    8020ac <__udivdi3+0x4c>
  802182:	66 90                	xchg   %ax,%ax
  802184:	66 90                	xchg   %ax,%ax
  802186:	66 90                	xchg   %ax,%ax
  802188:	66 90                	xchg   %ax,%ax
  80218a:	66 90                	xchg   %ax,%ax
  80218c:	66 90                	xchg   %ax,%ax
  80218e:	66 90                	xchg   %ax,%ax

00802190 <__umoddi3>:
  802190:	55                   	push   %ebp
  802191:	57                   	push   %edi
  802192:	56                   	push   %esi
  802193:	53                   	push   %ebx
  802194:	83 ec 1c             	sub    $0x1c,%esp
  802197:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80219b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80219f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021a7:	85 d2                	test   %edx,%edx
  8021a9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8021ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021b1:	89 f3                	mov    %esi,%ebx
  8021b3:	89 3c 24             	mov    %edi,(%esp)
  8021b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021ba:	75 1c                	jne    8021d8 <__umoddi3+0x48>
  8021bc:	39 f7                	cmp    %esi,%edi
  8021be:	76 50                	jbe    802210 <__umoddi3+0x80>
  8021c0:	89 c8                	mov    %ecx,%eax
  8021c2:	89 f2                	mov    %esi,%edx
  8021c4:	f7 f7                	div    %edi
  8021c6:	89 d0                	mov    %edx,%eax
  8021c8:	31 d2                	xor    %edx,%edx
  8021ca:	83 c4 1c             	add    $0x1c,%esp
  8021cd:	5b                   	pop    %ebx
  8021ce:	5e                   	pop    %esi
  8021cf:	5f                   	pop    %edi
  8021d0:	5d                   	pop    %ebp
  8021d1:	c3                   	ret    
  8021d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021d8:	39 f2                	cmp    %esi,%edx
  8021da:	89 d0                	mov    %edx,%eax
  8021dc:	77 52                	ja     802230 <__umoddi3+0xa0>
  8021de:	0f bd ea             	bsr    %edx,%ebp
  8021e1:	83 f5 1f             	xor    $0x1f,%ebp
  8021e4:	75 5a                	jne    802240 <__umoddi3+0xb0>
  8021e6:	3b 54 24 04          	cmp    0x4(%esp),%edx
  8021ea:	0f 82 e0 00 00 00    	jb     8022d0 <__umoddi3+0x140>
  8021f0:	39 0c 24             	cmp    %ecx,(%esp)
  8021f3:	0f 86 d7 00 00 00    	jbe    8022d0 <__umoddi3+0x140>
  8021f9:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021fd:	8b 54 24 04          	mov    0x4(%esp),%edx
  802201:	83 c4 1c             	add    $0x1c,%esp
  802204:	5b                   	pop    %ebx
  802205:	5e                   	pop    %esi
  802206:	5f                   	pop    %edi
  802207:	5d                   	pop    %ebp
  802208:	c3                   	ret    
  802209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802210:	85 ff                	test   %edi,%edi
  802212:	89 fd                	mov    %edi,%ebp
  802214:	75 0b                	jne    802221 <__umoddi3+0x91>
  802216:	b8 01 00 00 00       	mov    $0x1,%eax
  80221b:	31 d2                	xor    %edx,%edx
  80221d:	f7 f7                	div    %edi
  80221f:	89 c5                	mov    %eax,%ebp
  802221:	89 f0                	mov    %esi,%eax
  802223:	31 d2                	xor    %edx,%edx
  802225:	f7 f5                	div    %ebp
  802227:	89 c8                	mov    %ecx,%eax
  802229:	f7 f5                	div    %ebp
  80222b:	89 d0                	mov    %edx,%eax
  80222d:	eb 99                	jmp    8021c8 <__umoddi3+0x38>
  80222f:	90                   	nop
  802230:	89 c8                	mov    %ecx,%eax
  802232:	89 f2                	mov    %esi,%edx
  802234:	83 c4 1c             	add    $0x1c,%esp
  802237:	5b                   	pop    %ebx
  802238:	5e                   	pop    %esi
  802239:	5f                   	pop    %edi
  80223a:	5d                   	pop    %ebp
  80223b:	c3                   	ret    
  80223c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802240:	8b 34 24             	mov    (%esp),%esi
  802243:	bf 20 00 00 00       	mov    $0x20,%edi
  802248:	89 e9                	mov    %ebp,%ecx
  80224a:	29 ef                	sub    %ebp,%edi
  80224c:	d3 e0                	shl    %cl,%eax
  80224e:	89 f9                	mov    %edi,%ecx
  802250:	89 f2                	mov    %esi,%edx
  802252:	d3 ea                	shr    %cl,%edx
  802254:	89 e9                	mov    %ebp,%ecx
  802256:	09 c2                	or     %eax,%edx
  802258:	89 d8                	mov    %ebx,%eax
  80225a:	89 14 24             	mov    %edx,(%esp)
  80225d:	89 f2                	mov    %esi,%edx
  80225f:	d3 e2                	shl    %cl,%edx
  802261:	89 f9                	mov    %edi,%ecx
  802263:	89 54 24 04          	mov    %edx,0x4(%esp)
  802267:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80226b:	d3 e8                	shr    %cl,%eax
  80226d:	89 e9                	mov    %ebp,%ecx
  80226f:	89 c6                	mov    %eax,%esi
  802271:	d3 e3                	shl    %cl,%ebx
  802273:	89 f9                	mov    %edi,%ecx
  802275:	89 d0                	mov    %edx,%eax
  802277:	d3 e8                	shr    %cl,%eax
  802279:	89 e9                	mov    %ebp,%ecx
  80227b:	09 d8                	or     %ebx,%eax
  80227d:	89 d3                	mov    %edx,%ebx
  80227f:	89 f2                	mov    %esi,%edx
  802281:	f7 34 24             	divl   (%esp)
  802284:	89 d6                	mov    %edx,%esi
  802286:	d3 e3                	shl    %cl,%ebx
  802288:	f7 64 24 04          	mull   0x4(%esp)
  80228c:	39 d6                	cmp    %edx,%esi
  80228e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802292:	89 d1                	mov    %edx,%ecx
  802294:	89 c3                	mov    %eax,%ebx
  802296:	72 08                	jb     8022a0 <__umoddi3+0x110>
  802298:	75 11                	jne    8022ab <__umoddi3+0x11b>
  80229a:	39 44 24 08          	cmp    %eax,0x8(%esp)
  80229e:	73 0b                	jae    8022ab <__umoddi3+0x11b>
  8022a0:	2b 44 24 04          	sub    0x4(%esp),%eax
  8022a4:	1b 14 24             	sbb    (%esp),%edx
  8022a7:	89 d1                	mov    %edx,%ecx
  8022a9:	89 c3                	mov    %eax,%ebx
  8022ab:	8b 54 24 08          	mov    0x8(%esp),%edx
  8022af:	29 da                	sub    %ebx,%edx
  8022b1:	19 ce                	sbb    %ecx,%esi
  8022b3:	89 f9                	mov    %edi,%ecx
  8022b5:	89 f0                	mov    %esi,%eax
  8022b7:	d3 e0                	shl    %cl,%eax
  8022b9:	89 e9                	mov    %ebp,%ecx
  8022bb:	d3 ea                	shr    %cl,%edx
  8022bd:	89 e9                	mov    %ebp,%ecx
  8022bf:	d3 ee                	shr    %cl,%esi
  8022c1:	09 d0                	or     %edx,%eax
  8022c3:	89 f2                	mov    %esi,%edx
  8022c5:	83 c4 1c             	add    $0x1c,%esp
  8022c8:	5b                   	pop    %ebx
  8022c9:	5e                   	pop    %esi
  8022ca:	5f                   	pop    %edi
  8022cb:	5d                   	pop    %ebp
  8022cc:	c3                   	ret    
  8022cd:	8d 76 00             	lea    0x0(%esi),%esi
  8022d0:	29 f9                	sub    %edi,%ecx
  8022d2:	19 d6                	sbb    %edx,%esi
  8022d4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022d8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022dc:	e9 18 ff ff ff       	jmp    8021f9 <__umoddi3+0x69>
