
obj/user/yield.debug:     formato del fichero elf32-i386


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
  80002c:	e8 6e 00 00 00       	call   80009f <libmain>
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
  800037:	83 ec 08             	sub    $0x8,%esp
	int i;

	  cprintf("Hello, I am environment %08x, cpu %d.\n",thisenv->env_id, thisenv->env_cpunum);
  80003a:	a1 04 40 80 00       	mov    0x804004,%eax
  80003f:	8b 50 5c             	mov    0x5c(%eax),%edx
  800042:	8b 40 48             	mov    0x48(%eax),%eax
  800045:	52                   	push   %edx
  800046:	50                   	push   %eax
  800047:	68 a0 1d 80 00       	push   $0x801da0
  80004c:	e8 45 01 00 00       	call   800196 <cprintf>
  800051:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 5; i++) {
  800054:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800059:	e8 cc 0a 00 00       	call   800b2a <sys_yield>
		cprintf("Back in environment %08x, iteration %d, cpu %d.\n",thisenv->env_id, i, thisenv->env_cpunum);
  80005e:	a1 04 40 80 00       	mov    0x804004,%eax
  800063:	8b 50 5c             	mov    0x5c(%eax),%edx
  800066:	8b 40 48             	mov    0x48(%eax),%eax
  800069:	52                   	push   %edx
  80006a:	53                   	push   %ebx
  80006b:	50                   	push   %eax
  80006c:	68 c8 1d 80 00       	push   $0x801dc8
  800071:	e8 20 01 00 00       	call   800196 <cprintf>
umain(int argc, char **argv)
{
	int i;

	  cprintf("Hello, I am environment %08x, cpu %d.\n",thisenv->env_id, thisenv->env_cpunum);
	for (i = 0; i < 5; i++) {
  800076:	83 c3 01             	add    $0x1,%ebx
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	83 fb 05             	cmp    $0x5,%ebx
  80007f:	75 d8                	jne    800059 <umain+0x26>
		sys_yield();
		cprintf("Back in environment %08x, iteration %d, cpu %d.\n",thisenv->env_id, i, thisenv->env_cpunum);
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  800081:	a1 04 40 80 00       	mov    0x804004,%eax
  800086:	8b 40 48             	mov    0x48(%eax),%eax
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	50                   	push   %eax
  80008d:	68 fc 1d 80 00       	push   $0x801dfc
  800092:	e8 ff 00 00 00       	call   800196 <cprintf>
}
  800097:	83 c4 10             	add    $0x10,%esp
  80009a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80009d:	c9                   	leave  
  80009e:	c3                   	ret    

0080009f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009f:	55                   	push   %ebp
  8000a0:	89 e5                	mov    %esp,%ebp
  8000a2:	56                   	push   %esi
  8000a3:	53                   	push   %ebx
  8000a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a7:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8000aa:	e8 57 0a 00 00       	call   800b06 <sys_getenvid>
	if (id >= 0)
  8000af:	85 c0                	test   %eax,%eax
  8000b1:	78 12                	js     8000c5 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  8000b3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000bb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000c0:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c5:	85 db                	test   %ebx,%ebx
  8000c7:	7e 07                	jle    8000d0 <libmain+0x31>
		binaryname = argv[0];
  8000c9:	8b 06                	mov    (%esi),%eax
  8000cb:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000d0:	83 ec 08             	sub    $0x8,%esp
  8000d3:	56                   	push   %esi
  8000d4:	53                   	push   %ebx
  8000d5:	e8 59 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000da:	e8 0a 00 00 00       	call   8000e9 <exit>
}
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000e5:	5b                   	pop    %ebx
  8000e6:	5e                   	pop    %esi
  8000e7:	5d                   	pop    %ebp
  8000e8:	c3                   	ret    

008000e9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
  8000ec:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000ef:	e8 45 0d 00 00       	call   800e39 <close_all>
	sys_env_destroy(0);
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	6a 00                	push   $0x0
  8000f9:	e8 e6 09 00 00       	call   800ae4 <sys_env_destroy>
}
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	c9                   	leave  
  800102:	c3                   	ret    

00800103 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800103:	55                   	push   %ebp
  800104:	89 e5                	mov    %esp,%ebp
  800106:	53                   	push   %ebx
  800107:	83 ec 04             	sub    $0x4,%esp
  80010a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80010d:	8b 13                	mov    (%ebx),%edx
  80010f:	8d 42 01             	lea    0x1(%edx),%eax
  800112:	89 03                	mov    %eax,(%ebx)
  800114:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800117:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80011b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800120:	75 1a                	jne    80013c <putch+0x39>
		sys_cputs(b->buf, b->idx);
  800122:	83 ec 08             	sub    $0x8,%esp
  800125:	68 ff 00 00 00       	push   $0xff
  80012a:	8d 43 08             	lea    0x8(%ebx),%eax
  80012d:	50                   	push   %eax
  80012e:	e8 67 09 00 00       	call   800a9a <sys_cputs>
		b->idx = 0;
  800133:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800139:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  80013c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800140:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800143:	c9                   	leave  
  800144:	c3                   	ret    

00800145 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800145:	55                   	push   %ebp
  800146:	89 e5                	mov    %esp,%ebp
  800148:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80014e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800155:	00 00 00 
	b.cnt = 0;
  800158:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80015f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800162:	ff 75 0c             	pushl  0xc(%ebp)
  800165:	ff 75 08             	pushl  0x8(%ebp)
  800168:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80016e:	50                   	push   %eax
  80016f:	68 03 01 80 00       	push   $0x800103
  800174:	e8 86 01 00 00       	call   8002ff <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800179:	83 c4 08             	add    $0x8,%esp
  80017c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800182:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800188:	50                   	push   %eax
  800189:	e8 0c 09 00 00       	call   800a9a <sys_cputs>

	return b.cnt;
}
  80018e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800194:	c9                   	leave  
  800195:	c3                   	ret    

00800196 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80019c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80019f:	50                   	push   %eax
  8001a0:	ff 75 08             	pushl  0x8(%ebp)
  8001a3:	e8 9d ff ff ff       	call   800145 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    

008001aa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	57                   	push   %edi
  8001ae:	56                   	push   %esi
  8001af:	53                   	push   %ebx
  8001b0:	83 ec 1c             	sub    $0x1c,%esp
  8001b3:	89 c7                	mov    %eax,%edi
  8001b5:	89 d6                	mov    %edx,%esi
  8001b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001cb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001ce:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001d1:	39 d3                	cmp    %edx,%ebx
  8001d3:	72 05                	jb     8001da <printnum+0x30>
  8001d5:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001d8:	77 45                	ja     80021f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	ff 75 18             	pushl  0x18(%ebp)
  8001e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8001e3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001e6:	53                   	push   %ebx
  8001e7:	ff 75 10             	pushl  0x10(%ebp)
  8001ea:	83 ec 08             	sub    $0x8,%esp
  8001ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f0:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f3:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f6:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f9:	e8 02 19 00 00       	call   801b00 <__udivdi3>
  8001fe:	83 c4 18             	add    $0x18,%esp
  800201:	52                   	push   %edx
  800202:	50                   	push   %eax
  800203:	89 f2                	mov    %esi,%edx
  800205:	89 f8                	mov    %edi,%eax
  800207:	e8 9e ff ff ff       	call   8001aa <printnum>
  80020c:	83 c4 20             	add    $0x20,%esp
  80020f:	eb 18                	jmp    800229 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800211:	83 ec 08             	sub    $0x8,%esp
  800214:	56                   	push   %esi
  800215:	ff 75 18             	pushl  0x18(%ebp)
  800218:	ff d7                	call   *%edi
  80021a:	83 c4 10             	add    $0x10,%esp
  80021d:	eb 03                	jmp    800222 <printnum+0x78>
  80021f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800222:	83 eb 01             	sub    $0x1,%ebx
  800225:	85 db                	test   %ebx,%ebx
  800227:	7f e8                	jg     800211 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800229:	83 ec 08             	sub    $0x8,%esp
  80022c:	56                   	push   %esi
  80022d:	83 ec 04             	sub    $0x4,%esp
  800230:	ff 75 e4             	pushl  -0x1c(%ebp)
  800233:	ff 75 e0             	pushl  -0x20(%ebp)
  800236:	ff 75 dc             	pushl  -0x24(%ebp)
  800239:	ff 75 d8             	pushl  -0x28(%ebp)
  80023c:	e8 ef 19 00 00       	call   801c30 <__umoddi3>
  800241:	83 c4 14             	add    $0x14,%esp
  800244:	0f be 80 25 1e 80 00 	movsbl 0x801e25(%eax),%eax
  80024b:	50                   	push   %eax
  80024c:	ff d7                	call   *%edi
}
  80024e:	83 c4 10             	add    $0x10,%esp
  800251:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800254:	5b                   	pop    %ebx
  800255:	5e                   	pop    %esi
  800256:	5f                   	pop    %edi
  800257:	5d                   	pop    %ebp
  800258:	c3                   	ret    

00800259 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80025c:	83 fa 01             	cmp    $0x1,%edx
  80025f:	7e 0e                	jle    80026f <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800261:	8b 10                	mov    (%eax),%edx
  800263:	8d 4a 08             	lea    0x8(%edx),%ecx
  800266:	89 08                	mov    %ecx,(%eax)
  800268:	8b 02                	mov    (%edx),%eax
  80026a:	8b 52 04             	mov    0x4(%edx),%edx
  80026d:	eb 22                	jmp    800291 <getuint+0x38>
	else if (lflag)
  80026f:	85 d2                	test   %edx,%edx
  800271:	74 10                	je     800283 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800273:	8b 10                	mov    (%eax),%edx
  800275:	8d 4a 04             	lea    0x4(%edx),%ecx
  800278:	89 08                	mov    %ecx,(%eax)
  80027a:	8b 02                	mov    (%edx),%eax
  80027c:	ba 00 00 00 00       	mov    $0x0,%edx
  800281:	eb 0e                	jmp    800291 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800283:	8b 10                	mov    (%eax),%edx
  800285:	8d 4a 04             	lea    0x4(%edx),%ecx
  800288:	89 08                	mov    %ecx,(%eax)
  80028a:	8b 02                	mov    (%edx),%eax
  80028c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800291:	5d                   	pop    %ebp
  800292:	c3                   	ret    

00800293 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800293:	55                   	push   %ebp
  800294:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800296:	83 fa 01             	cmp    $0x1,%edx
  800299:	7e 0e                	jle    8002a9 <getint+0x16>
		return va_arg(*ap, long long);
  80029b:	8b 10                	mov    (%eax),%edx
  80029d:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002a0:	89 08                	mov    %ecx,(%eax)
  8002a2:	8b 02                	mov    (%edx),%eax
  8002a4:	8b 52 04             	mov    0x4(%edx),%edx
  8002a7:	eb 1a                	jmp    8002c3 <getint+0x30>
	else if (lflag)
  8002a9:	85 d2                	test   %edx,%edx
  8002ab:	74 0c                	je     8002b9 <getint+0x26>
		return va_arg(*ap, long);
  8002ad:	8b 10                	mov    (%eax),%edx
  8002af:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002b2:	89 08                	mov    %ecx,(%eax)
  8002b4:	8b 02                	mov    (%edx),%eax
  8002b6:	99                   	cltd   
  8002b7:	eb 0a                	jmp    8002c3 <getint+0x30>
	else
		return va_arg(*ap, int);
  8002b9:	8b 10                	mov    (%eax),%edx
  8002bb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002be:	89 08                	mov    %ecx,(%eax)
  8002c0:	8b 02                	mov    (%edx),%eax
  8002c2:	99                   	cltd   
}
  8002c3:	5d                   	pop    %ebp
  8002c4:	c3                   	ret    

008002c5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002cb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002cf:	8b 10                	mov    (%eax),%edx
  8002d1:	3b 50 04             	cmp    0x4(%eax),%edx
  8002d4:	73 0a                	jae    8002e0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002d6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002d9:	89 08                	mov    %ecx,(%eax)
  8002db:	8b 45 08             	mov    0x8(%ebp),%eax
  8002de:	88 02                	mov    %al,(%edx)
}
  8002e0:	5d                   	pop    %ebp
  8002e1:	c3                   	ret    

008002e2 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8002e2:	55                   	push   %ebp
  8002e3:	89 e5                	mov    %esp,%ebp
  8002e5:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8002e8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002eb:	50                   	push   %eax
  8002ec:	ff 75 10             	pushl  0x10(%ebp)
  8002ef:	ff 75 0c             	pushl  0xc(%ebp)
  8002f2:	ff 75 08             	pushl  0x8(%ebp)
  8002f5:	e8 05 00 00 00       	call   8002ff <vprintfmt>
	va_end(ap);
}
  8002fa:	83 c4 10             	add    $0x10,%esp
  8002fd:	c9                   	leave  
  8002fe:	c3                   	ret    

008002ff <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
  800302:	57                   	push   %edi
  800303:	56                   	push   %esi
  800304:	53                   	push   %ebx
  800305:	83 ec 2c             	sub    $0x2c,%esp
  800308:	8b 75 08             	mov    0x8(%ebp),%esi
  80030b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80030e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800311:	eb 12                	jmp    800325 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800313:	85 c0                	test   %eax,%eax
  800315:	0f 84 44 03 00 00    	je     80065f <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  80031b:	83 ec 08             	sub    $0x8,%esp
  80031e:	53                   	push   %ebx
  80031f:	50                   	push   %eax
  800320:	ff d6                	call   *%esi
  800322:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800325:	83 c7 01             	add    $0x1,%edi
  800328:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80032c:	83 f8 25             	cmp    $0x25,%eax
  80032f:	75 e2                	jne    800313 <vprintfmt+0x14>
  800331:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800335:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80033c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800343:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80034a:	ba 00 00 00 00       	mov    $0x0,%edx
  80034f:	eb 07                	jmp    800358 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800351:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800354:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800358:	8d 47 01             	lea    0x1(%edi),%eax
  80035b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80035e:	0f b6 07             	movzbl (%edi),%eax
  800361:	0f b6 c8             	movzbl %al,%ecx
  800364:	83 e8 23             	sub    $0x23,%eax
  800367:	3c 55                	cmp    $0x55,%al
  800369:	0f 87 d5 02 00 00    	ja     800644 <vprintfmt+0x345>
  80036f:	0f b6 c0             	movzbl %al,%eax
  800372:	ff 24 85 60 1f 80 00 	jmp    *0x801f60(,%eax,4)
  800379:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80037c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800380:	eb d6                	jmp    800358 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800382:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800385:	b8 00 00 00 00       	mov    $0x0,%eax
  80038a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80038d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800390:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  800394:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  800397:	8d 51 d0             	lea    -0x30(%ecx),%edx
  80039a:	83 fa 09             	cmp    $0x9,%edx
  80039d:	77 39                	ja     8003d8 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80039f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003a2:	eb e9                	jmp    80038d <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a7:	8d 48 04             	lea    0x4(%eax),%ecx
  8003aa:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8003ad:	8b 00                	mov    (%eax),%eax
  8003af:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003b5:	eb 27                	jmp    8003de <vprintfmt+0xdf>
  8003b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ba:	85 c0                	test   %eax,%eax
  8003bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003c1:	0f 49 c8             	cmovns %eax,%ecx
  8003c4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003ca:	eb 8c                	jmp    800358 <vprintfmt+0x59>
  8003cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8003cf:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003d6:	eb 80                	jmp    800358 <vprintfmt+0x59>
  8003d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003db:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  8003de:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003e2:	0f 89 70 ff ff ff    	jns    800358 <vprintfmt+0x59>
				width = precision, precision = -1;
  8003e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ee:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003f5:	e9 5e ff ff ff       	jmp    800358 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003fa:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800400:	e9 53 ff ff ff       	jmp    800358 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800405:	8b 45 14             	mov    0x14(%ebp),%eax
  800408:	8d 50 04             	lea    0x4(%eax),%edx
  80040b:	89 55 14             	mov    %edx,0x14(%ebp)
  80040e:	83 ec 08             	sub    $0x8,%esp
  800411:	53                   	push   %ebx
  800412:	ff 30                	pushl  (%eax)
  800414:	ff d6                	call   *%esi
			break;
  800416:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800419:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  80041c:	e9 04 ff ff ff       	jmp    800325 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800421:	8b 45 14             	mov    0x14(%ebp),%eax
  800424:	8d 50 04             	lea    0x4(%eax),%edx
  800427:	89 55 14             	mov    %edx,0x14(%ebp)
  80042a:	8b 00                	mov    (%eax),%eax
  80042c:	99                   	cltd   
  80042d:	31 d0                	xor    %edx,%eax
  80042f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800431:	83 f8 0f             	cmp    $0xf,%eax
  800434:	7f 0b                	jg     800441 <vprintfmt+0x142>
  800436:	8b 14 85 c0 20 80 00 	mov    0x8020c0(,%eax,4),%edx
  80043d:	85 d2                	test   %edx,%edx
  80043f:	75 18                	jne    800459 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  800441:	50                   	push   %eax
  800442:	68 3d 1e 80 00       	push   $0x801e3d
  800447:	53                   	push   %ebx
  800448:	56                   	push   %esi
  800449:	e8 94 fe ff ff       	call   8002e2 <printfmt>
  80044e:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800451:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800454:	e9 cc fe ff ff       	jmp    800325 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  800459:	52                   	push   %edx
  80045a:	68 f1 21 80 00       	push   $0x8021f1
  80045f:	53                   	push   %ebx
  800460:	56                   	push   %esi
  800461:	e8 7c fe ff ff       	call   8002e2 <printfmt>
  800466:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800469:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80046c:	e9 b4 fe ff ff       	jmp    800325 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800471:	8b 45 14             	mov    0x14(%ebp),%eax
  800474:	8d 50 04             	lea    0x4(%eax),%edx
  800477:	89 55 14             	mov    %edx,0x14(%ebp)
  80047a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80047c:	85 ff                	test   %edi,%edi
  80047e:	b8 36 1e 80 00       	mov    $0x801e36,%eax
  800483:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800486:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80048a:	0f 8e 94 00 00 00    	jle    800524 <vprintfmt+0x225>
  800490:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800494:	0f 84 98 00 00 00    	je     800532 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	ff 75 d0             	pushl  -0x30(%ebp)
  8004a0:	57                   	push   %edi
  8004a1:	e8 41 02 00 00       	call   8006e7 <strnlen>
  8004a6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004a9:	29 c1                	sub    %eax,%ecx
  8004ab:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8004ae:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004b1:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b8:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004bb:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004bd:	eb 0f                	jmp    8004ce <vprintfmt+0x1cf>
					putch(padc, putdat);
  8004bf:	83 ec 08             	sub    $0x8,%esp
  8004c2:	53                   	push   %ebx
  8004c3:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c6:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c8:	83 ef 01             	sub    $0x1,%edi
  8004cb:	83 c4 10             	add    $0x10,%esp
  8004ce:	85 ff                	test   %edi,%edi
  8004d0:	7f ed                	jg     8004bf <vprintfmt+0x1c0>
  8004d2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004d5:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8004d8:	85 c9                	test   %ecx,%ecx
  8004da:	b8 00 00 00 00       	mov    $0x0,%eax
  8004df:	0f 49 c1             	cmovns %ecx,%eax
  8004e2:	29 c1                	sub    %eax,%ecx
  8004e4:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e7:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ea:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004ed:	89 cb                	mov    %ecx,%ebx
  8004ef:	eb 4d                	jmp    80053e <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004f1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004f5:	74 1b                	je     800512 <vprintfmt+0x213>
  8004f7:	0f be c0             	movsbl %al,%eax
  8004fa:	83 e8 20             	sub    $0x20,%eax
  8004fd:	83 f8 5e             	cmp    $0x5e,%eax
  800500:	76 10                	jbe    800512 <vprintfmt+0x213>
					putch('?', putdat);
  800502:	83 ec 08             	sub    $0x8,%esp
  800505:	ff 75 0c             	pushl  0xc(%ebp)
  800508:	6a 3f                	push   $0x3f
  80050a:	ff 55 08             	call   *0x8(%ebp)
  80050d:	83 c4 10             	add    $0x10,%esp
  800510:	eb 0d                	jmp    80051f <vprintfmt+0x220>
				else
					putch(ch, putdat);
  800512:	83 ec 08             	sub    $0x8,%esp
  800515:	ff 75 0c             	pushl  0xc(%ebp)
  800518:	52                   	push   %edx
  800519:	ff 55 08             	call   *0x8(%ebp)
  80051c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80051f:	83 eb 01             	sub    $0x1,%ebx
  800522:	eb 1a                	jmp    80053e <vprintfmt+0x23f>
  800524:	89 75 08             	mov    %esi,0x8(%ebp)
  800527:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80052a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80052d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800530:	eb 0c                	jmp    80053e <vprintfmt+0x23f>
  800532:	89 75 08             	mov    %esi,0x8(%ebp)
  800535:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800538:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80053b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80053e:	83 c7 01             	add    $0x1,%edi
  800541:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800545:	0f be d0             	movsbl %al,%edx
  800548:	85 d2                	test   %edx,%edx
  80054a:	74 23                	je     80056f <vprintfmt+0x270>
  80054c:	85 f6                	test   %esi,%esi
  80054e:	78 a1                	js     8004f1 <vprintfmt+0x1f2>
  800550:	83 ee 01             	sub    $0x1,%esi
  800553:	79 9c                	jns    8004f1 <vprintfmt+0x1f2>
  800555:	89 df                	mov    %ebx,%edi
  800557:	8b 75 08             	mov    0x8(%ebp),%esi
  80055a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80055d:	eb 18                	jmp    800577 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	53                   	push   %ebx
  800563:	6a 20                	push   $0x20
  800565:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800567:	83 ef 01             	sub    $0x1,%edi
  80056a:	83 c4 10             	add    $0x10,%esp
  80056d:	eb 08                	jmp    800577 <vprintfmt+0x278>
  80056f:	89 df                	mov    %ebx,%edi
  800571:	8b 75 08             	mov    0x8(%ebp),%esi
  800574:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800577:	85 ff                	test   %edi,%edi
  800579:	7f e4                	jg     80055f <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80057e:	e9 a2 fd ff ff       	jmp    800325 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800583:	8d 45 14             	lea    0x14(%ebp),%eax
  800586:	e8 08 fd ff ff       	call   800293 <getint>
  80058b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800591:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800596:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80059a:	79 74                	jns    800610 <vprintfmt+0x311>
				putch('-', putdat);
  80059c:	83 ec 08             	sub    $0x8,%esp
  80059f:	53                   	push   %ebx
  8005a0:	6a 2d                	push   $0x2d
  8005a2:	ff d6                	call   *%esi
				num = -(long long) num;
  8005a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005a7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005aa:	f7 d8                	neg    %eax
  8005ac:	83 d2 00             	adc    $0x0,%edx
  8005af:	f7 da                	neg    %edx
  8005b1:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8005b4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8005b9:	eb 55                	jmp    800610 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8005bb:	8d 45 14             	lea    0x14(%ebp),%eax
  8005be:	e8 96 fc ff ff       	call   800259 <getuint>
			base = 10;
  8005c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8005c8:	eb 46                	jmp    800610 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8005ca:	8d 45 14             	lea    0x14(%ebp),%eax
  8005cd:	e8 87 fc ff ff       	call   800259 <getuint>
			base = 8;
  8005d2:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8005d7:	eb 37                	jmp    800610 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  8005d9:	83 ec 08             	sub    $0x8,%esp
  8005dc:	53                   	push   %ebx
  8005dd:	6a 30                	push   $0x30
  8005df:	ff d6                	call   *%esi
			putch('x', putdat);
  8005e1:	83 c4 08             	add    $0x8,%esp
  8005e4:	53                   	push   %ebx
  8005e5:	6a 78                	push   $0x78
  8005e7:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	8d 50 04             	lea    0x4(%eax),%edx
  8005ef:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8005f2:	8b 00                	mov    (%eax),%eax
  8005f4:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8005f9:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8005fc:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800601:	eb 0d                	jmp    800610 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800603:	8d 45 14             	lea    0x14(%ebp),%eax
  800606:	e8 4e fc ff ff       	call   800259 <getuint>
			base = 16;
  80060b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800610:	83 ec 0c             	sub    $0xc,%esp
  800613:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800617:	57                   	push   %edi
  800618:	ff 75 e0             	pushl  -0x20(%ebp)
  80061b:	51                   	push   %ecx
  80061c:	52                   	push   %edx
  80061d:	50                   	push   %eax
  80061e:	89 da                	mov    %ebx,%edx
  800620:	89 f0                	mov    %esi,%eax
  800622:	e8 83 fb ff ff       	call   8001aa <printnum>
			break;
  800627:	83 c4 20             	add    $0x20,%esp
  80062a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80062d:	e9 f3 fc ff ff       	jmp    800325 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	53                   	push   %ebx
  800636:	51                   	push   %ecx
  800637:	ff d6                	call   *%esi
			break;
  800639:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80063c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  80063f:	e9 e1 fc ff ff       	jmp    800325 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800644:	83 ec 08             	sub    $0x8,%esp
  800647:	53                   	push   %ebx
  800648:	6a 25                	push   $0x25
  80064a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80064c:	83 c4 10             	add    $0x10,%esp
  80064f:	eb 03                	jmp    800654 <vprintfmt+0x355>
  800651:	83 ef 01             	sub    $0x1,%edi
  800654:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  800658:	75 f7                	jne    800651 <vprintfmt+0x352>
  80065a:	e9 c6 fc ff ff       	jmp    800325 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  80065f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800662:	5b                   	pop    %ebx
  800663:	5e                   	pop    %esi
  800664:	5f                   	pop    %edi
  800665:	5d                   	pop    %ebp
  800666:	c3                   	ret    

00800667 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800667:	55                   	push   %ebp
  800668:	89 e5                	mov    %esp,%ebp
  80066a:	83 ec 18             	sub    $0x18,%esp
  80066d:	8b 45 08             	mov    0x8(%ebp),%eax
  800670:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800673:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800676:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80067a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80067d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800684:	85 c0                	test   %eax,%eax
  800686:	74 26                	je     8006ae <vsnprintf+0x47>
  800688:	85 d2                	test   %edx,%edx
  80068a:	7e 22                	jle    8006ae <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80068c:	ff 75 14             	pushl  0x14(%ebp)
  80068f:	ff 75 10             	pushl  0x10(%ebp)
  800692:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800695:	50                   	push   %eax
  800696:	68 c5 02 80 00       	push   $0x8002c5
  80069b:	e8 5f fc ff ff       	call   8002ff <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006a3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a9:	83 c4 10             	add    $0x10,%esp
  8006ac:	eb 05                	jmp    8006b3 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8006ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8006b3:	c9                   	leave  
  8006b4:	c3                   	ret    

008006b5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006b5:	55                   	push   %ebp
  8006b6:	89 e5                	mov    %esp,%ebp
  8006b8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8006bb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8006be:	50                   	push   %eax
  8006bf:	ff 75 10             	pushl  0x10(%ebp)
  8006c2:	ff 75 0c             	pushl  0xc(%ebp)
  8006c5:	ff 75 08             	pushl  0x8(%ebp)
  8006c8:	e8 9a ff ff ff       	call   800667 <vsnprintf>
	va_end(ap);

	return rc;
}
  8006cd:	c9                   	leave  
  8006ce:	c3                   	ret    

008006cf <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8006cf:	55                   	push   %ebp
  8006d0:	89 e5                	mov    %esp,%ebp
  8006d2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8006d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006da:	eb 03                	jmp    8006df <strlen+0x10>
		n++;
  8006dc:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8006df:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8006e3:	75 f7                	jne    8006dc <strlen+0xd>
		n++;
	return n;
}
  8006e5:	5d                   	pop    %ebp
  8006e6:	c3                   	ret    

008006e7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8006e7:	55                   	push   %ebp
  8006e8:	89 e5                	mov    %esp,%ebp
  8006ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006ed:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8006f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f5:	eb 03                	jmp    8006fa <strnlen+0x13>
		n++;
  8006f7:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8006fa:	39 c2                	cmp    %eax,%edx
  8006fc:	74 08                	je     800706 <strnlen+0x1f>
  8006fe:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800702:	75 f3                	jne    8006f7 <strnlen+0x10>
  800704:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  800706:	5d                   	pop    %ebp
  800707:	c3                   	ret    

00800708 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800708:	55                   	push   %ebp
  800709:	89 e5                	mov    %esp,%ebp
  80070b:	53                   	push   %ebx
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800712:	89 c2                	mov    %eax,%edx
  800714:	83 c2 01             	add    $0x1,%edx
  800717:	83 c1 01             	add    $0x1,%ecx
  80071a:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80071e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800721:	84 db                	test   %bl,%bl
  800723:	75 ef                	jne    800714 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800725:	5b                   	pop    %ebx
  800726:	5d                   	pop    %ebp
  800727:	c3                   	ret    

00800728 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800728:	55                   	push   %ebp
  800729:	89 e5                	mov    %esp,%ebp
  80072b:	53                   	push   %ebx
  80072c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80072f:	53                   	push   %ebx
  800730:	e8 9a ff ff ff       	call   8006cf <strlen>
  800735:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800738:	ff 75 0c             	pushl  0xc(%ebp)
  80073b:	01 d8                	add    %ebx,%eax
  80073d:	50                   	push   %eax
  80073e:	e8 c5 ff ff ff       	call   800708 <strcpy>
	return dst;
}
  800743:	89 d8                	mov    %ebx,%eax
  800745:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800748:	c9                   	leave  
  800749:	c3                   	ret    

0080074a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80074a:	55                   	push   %ebp
  80074b:	89 e5                	mov    %esp,%ebp
  80074d:	56                   	push   %esi
  80074e:	53                   	push   %ebx
  80074f:	8b 75 08             	mov    0x8(%ebp),%esi
  800752:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800755:	89 f3                	mov    %esi,%ebx
  800757:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80075a:	89 f2                	mov    %esi,%edx
  80075c:	eb 0f                	jmp    80076d <strncpy+0x23>
		*dst++ = *src;
  80075e:	83 c2 01             	add    $0x1,%edx
  800761:	0f b6 01             	movzbl (%ecx),%eax
  800764:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800767:	80 39 01             	cmpb   $0x1,(%ecx)
  80076a:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80076d:	39 da                	cmp    %ebx,%edx
  80076f:	75 ed                	jne    80075e <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800771:	89 f0                	mov    %esi,%eax
  800773:	5b                   	pop    %ebx
  800774:	5e                   	pop    %esi
  800775:	5d                   	pop    %ebp
  800776:	c3                   	ret    

00800777 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	56                   	push   %esi
  80077b:	53                   	push   %ebx
  80077c:	8b 75 08             	mov    0x8(%ebp),%esi
  80077f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800782:	8b 55 10             	mov    0x10(%ebp),%edx
  800785:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800787:	85 d2                	test   %edx,%edx
  800789:	74 21                	je     8007ac <strlcpy+0x35>
  80078b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80078f:	89 f2                	mov    %esi,%edx
  800791:	eb 09                	jmp    80079c <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800793:	83 c2 01             	add    $0x1,%edx
  800796:	83 c1 01             	add    $0x1,%ecx
  800799:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80079c:	39 c2                	cmp    %eax,%edx
  80079e:	74 09                	je     8007a9 <strlcpy+0x32>
  8007a0:	0f b6 19             	movzbl (%ecx),%ebx
  8007a3:	84 db                	test   %bl,%bl
  8007a5:	75 ec                	jne    800793 <strlcpy+0x1c>
  8007a7:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  8007a9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007ac:	29 f0                	sub    %esi,%eax
}
  8007ae:	5b                   	pop    %ebx
  8007af:	5e                   	pop    %esi
  8007b0:	5d                   	pop    %ebp
  8007b1:	c3                   	ret    

008007b2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007b2:	55                   	push   %ebp
  8007b3:	89 e5                	mov    %esp,%ebp
  8007b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007b8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007bb:	eb 06                	jmp    8007c3 <strcmp+0x11>
		p++, q++;
  8007bd:	83 c1 01             	add    $0x1,%ecx
  8007c0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8007c3:	0f b6 01             	movzbl (%ecx),%eax
  8007c6:	84 c0                	test   %al,%al
  8007c8:	74 04                	je     8007ce <strcmp+0x1c>
  8007ca:	3a 02                	cmp    (%edx),%al
  8007cc:	74 ef                	je     8007bd <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8007ce:	0f b6 c0             	movzbl %al,%eax
  8007d1:	0f b6 12             	movzbl (%edx),%edx
  8007d4:	29 d0                	sub    %edx,%eax
}
  8007d6:	5d                   	pop    %ebp
  8007d7:	c3                   	ret    

008007d8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8007d8:	55                   	push   %ebp
  8007d9:	89 e5                	mov    %esp,%ebp
  8007db:	53                   	push   %ebx
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e2:	89 c3                	mov    %eax,%ebx
  8007e4:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8007e7:	eb 06                	jmp    8007ef <strncmp+0x17>
		n--, p++, q++;
  8007e9:	83 c0 01             	add    $0x1,%eax
  8007ec:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8007ef:	39 d8                	cmp    %ebx,%eax
  8007f1:	74 15                	je     800808 <strncmp+0x30>
  8007f3:	0f b6 08             	movzbl (%eax),%ecx
  8007f6:	84 c9                	test   %cl,%cl
  8007f8:	74 04                	je     8007fe <strncmp+0x26>
  8007fa:	3a 0a                	cmp    (%edx),%cl
  8007fc:	74 eb                	je     8007e9 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8007fe:	0f b6 00             	movzbl (%eax),%eax
  800801:	0f b6 12             	movzbl (%edx),%edx
  800804:	29 d0                	sub    %edx,%eax
  800806:	eb 05                	jmp    80080d <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800808:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  80080d:	5b                   	pop    %ebx
  80080e:	5d                   	pop    %ebp
  80080f:	c3                   	ret    

00800810 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800810:	55                   	push   %ebp
  800811:	89 e5                	mov    %esp,%ebp
  800813:	8b 45 08             	mov    0x8(%ebp),%eax
  800816:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80081a:	eb 07                	jmp    800823 <strchr+0x13>
		if (*s == c)
  80081c:	38 ca                	cmp    %cl,%dl
  80081e:	74 0f                	je     80082f <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800820:	83 c0 01             	add    $0x1,%eax
  800823:	0f b6 10             	movzbl (%eax),%edx
  800826:	84 d2                	test   %dl,%dl
  800828:	75 f2                	jne    80081c <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  80082a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80082f:	5d                   	pop    %ebp
  800830:	c3                   	ret    

00800831 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80083b:	eb 03                	jmp    800840 <strfind+0xf>
  80083d:	83 c0 01             	add    $0x1,%eax
  800840:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800843:	38 ca                	cmp    %cl,%dl
  800845:	74 04                	je     80084b <strfind+0x1a>
  800847:	84 d2                	test   %dl,%dl
  800849:	75 f2                	jne    80083d <strfind+0xc>
			break;
	return (char *) s;
}
  80084b:	5d                   	pop    %ebp
  80084c:	c3                   	ret    

0080084d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80084d:	55                   	push   %ebp
  80084e:	89 e5                	mov    %esp,%ebp
  800850:	57                   	push   %edi
  800851:	56                   	push   %esi
  800852:	53                   	push   %ebx
  800853:	8b 55 08             	mov    0x8(%ebp),%edx
  800856:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800859:	85 c9                	test   %ecx,%ecx
  80085b:	74 37                	je     800894 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80085d:	f6 c2 03             	test   $0x3,%dl
  800860:	75 2a                	jne    80088c <memset+0x3f>
  800862:	f6 c1 03             	test   $0x3,%cl
  800865:	75 25                	jne    80088c <memset+0x3f>
		c &= 0xFF;
  800867:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80086b:	89 df                	mov    %ebx,%edi
  80086d:	c1 e7 08             	shl    $0x8,%edi
  800870:	89 de                	mov    %ebx,%esi
  800872:	c1 e6 18             	shl    $0x18,%esi
  800875:	89 d8                	mov    %ebx,%eax
  800877:	c1 e0 10             	shl    $0x10,%eax
  80087a:	09 f0                	or     %esi,%eax
  80087c:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  80087e:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800881:	89 f8                	mov    %edi,%eax
  800883:	09 d8                	or     %ebx,%eax
  800885:	89 d7                	mov    %edx,%edi
  800887:	fc                   	cld    
  800888:	f3 ab                	rep stos %eax,%es:(%edi)
  80088a:	eb 08                	jmp    800894 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80088c:	89 d7                	mov    %edx,%edi
  80088e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800891:	fc                   	cld    
  800892:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800894:	89 d0                	mov    %edx,%eax
  800896:	5b                   	pop    %ebx
  800897:	5e                   	pop    %esi
  800898:	5f                   	pop    %edi
  800899:	5d                   	pop    %ebp
  80089a:	c3                   	ret    

0080089b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80089b:	55                   	push   %ebp
  80089c:	89 e5                	mov    %esp,%ebp
  80089e:	57                   	push   %edi
  80089f:	56                   	push   %esi
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008a9:	39 c6                	cmp    %eax,%esi
  8008ab:	73 35                	jae    8008e2 <memmove+0x47>
  8008ad:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008b0:	39 d0                	cmp    %edx,%eax
  8008b2:	73 2e                	jae    8008e2 <memmove+0x47>
		s += n;
		d += n;
  8008b4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008b7:	89 d6                	mov    %edx,%esi
  8008b9:	09 fe                	or     %edi,%esi
  8008bb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008c1:	75 13                	jne    8008d6 <memmove+0x3b>
  8008c3:	f6 c1 03             	test   $0x3,%cl
  8008c6:	75 0e                	jne    8008d6 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  8008c8:	83 ef 04             	sub    $0x4,%edi
  8008cb:	8d 72 fc             	lea    -0x4(%edx),%esi
  8008ce:	c1 e9 02             	shr    $0x2,%ecx
  8008d1:	fd                   	std    
  8008d2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008d4:	eb 09                	jmp    8008df <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8008d6:	83 ef 01             	sub    $0x1,%edi
  8008d9:	8d 72 ff             	lea    -0x1(%edx),%esi
  8008dc:	fd                   	std    
  8008dd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8008df:	fc                   	cld    
  8008e0:	eb 1d                	jmp    8008ff <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008e2:	89 f2                	mov    %esi,%edx
  8008e4:	09 c2                	or     %eax,%edx
  8008e6:	f6 c2 03             	test   $0x3,%dl
  8008e9:	75 0f                	jne    8008fa <memmove+0x5f>
  8008eb:	f6 c1 03             	test   $0x3,%cl
  8008ee:	75 0a                	jne    8008fa <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  8008f0:	c1 e9 02             	shr    $0x2,%ecx
  8008f3:	89 c7                	mov    %eax,%edi
  8008f5:	fc                   	cld    
  8008f6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008f8:	eb 05                	jmp    8008ff <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8008fa:	89 c7                	mov    %eax,%edi
  8008fc:	fc                   	cld    
  8008fd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8008ff:	5e                   	pop    %esi
  800900:	5f                   	pop    %edi
  800901:	5d                   	pop    %ebp
  800902:	c3                   	ret    

00800903 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800906:	ff 75 10             	pushl  0x10(%ebp)
  800909:	ff 75 0c             	pushl  0xc(%ebp)
  80090c:	ff 75 08             	pushl  0x8(%ebp)
  80090f:	e8 87 ff ff ff       	call   80089b <memmove>
}
  800914:	c9                   	leave  
  800915:	c3                   	ret    

00800916 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	56                   	push   %esi
  80091a:	53                   	push   %ebx
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800921:	89 c6                	mov    %eax,%esi
  800923:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800926:	eb 1a                	jmp    800942 <memcmp+0x2c>
		if (*s1 != *s2)
  800928:	0f b6 08             	movzbl (%eax),%ecx
  80092b:	0f b6 1a             	movzbl (%edx),%ebx
  80092e:	38 d9                	cmp    %bl,%cl
  800930:	74 0a                	je     80093c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800932:	0f b6 c1             	movzbl %cl,%eax
  800935:	0f b6 db             	movzbl %bl,%ebx
  800938:	29 d8                	sub    %ebx,%eax
  80093a:	eb 0f                	jmp    80094b <memcmp+0x35>
		s1++, s2++;
  80093c:	83 c0 01             	add    $0x1,%eax
  80093f:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800942:	39 f0                	cmp    %esi,%eax
  800944:	75 e2                	jne    800928 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800946:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80094b:	5b                   	pop    %ebx
  80094c:	5e                   	pop    %esi
  80094d:	5d                   	pop    %ebp
  80094e:	c3                   	ret    

0080094f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	53                   	push   %ebx
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800956:	89 c1                	mov    %eax,%ecx
  800958:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  80095b:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80095f:	eb 0a                	jmp    80096b <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800961:	0f b6 10             	movzbl (%eax),%edx
  800964:	39 da                	cmp    %ebx,%edx
  800966:	74 07                	je     80096f <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800968:	83 c0 01             	add    $0x1,%eax
  80096b:	39 c8                	cmp    %ecx,%eax
  80096d:	72 f2                	jb     800961 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  80096f:	5b                   	pop    %ebx
  800970:	5d                   	pop    %ebp
  800971:	c3                   	ret    

00800972 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	57                   	push   %edi
  800976:	56                   	push   %esi
  800977:	53                   	push   %ebx
  800978:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80097b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80097e:	eb 03                	jmp    800983 <strtol+0x11>
		s++;
  800980:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800983:	0f b6 01             	movzbl (%ecx),%eax
  800986:	3c 20                	cmp    $0x20,%al
  800988:	74 f6                	je     800980 <strtol+0xe>
  80098a:	3c 09                	cmp    $0x9,%al
  80098c:	74 f2                	je     800980 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  80098e:	3c 2b                	cmp    $0x2b,%al
  800990:	75 0a                	jne    80099c <strtol+0x2a>
		s++;
  800992:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800995:	bf 00 00 00 00       	mov    $0x0,%edi
  80099a:	eb 11                	jmp    8009ad <strtol+0x3b>
  80099c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8009a1:	3c 2d                	cmp    $0x2d,%al
  8009a3:	75 08                	jne    8009ad <strtol+0x3b>
		s++, neg = 1;
  8009a5:	83 c1 01             	add    $0x1,%ecx
  8009a8:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009ad:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009b3:	75 15                	jne    8009ca <strtol+0x58>
  8009b5:	80 39 30             	cmpb   $0x30,(%ecx)
  8009b8:	75 10                	jne    8009ca <strtol+0x58>
  8009ba:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8009be:	75 7c                	jne    800a3c <strtol+0xca>
		s += 2, base = 16;
  8009c0:	83 c1 02             	add    $0x2,%ecx
  8009c3:	bb 10 00 00 00       	mov    $0x10,%ebx
  8009c8:	eb 16                	jmp    8009e0 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  8009ca:	85 db                	test   %ebx,%ebx
  8009cc:	75 12                	jne    8009e0 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009ce:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009d3:	80 39 30             	cmpb   $0x30,(%ecx)
  8009d6:	75 08                	jne    8009e0 <strtol+0x6e>
		s++, base = 8;
  8009d8:	83 c1 01             	add    $0x1,%ecx
  8009db:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  8009e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e5:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8009e8:	0f b6 11             	movzbl (%ecx),%edx
  8009eb:	8d 72 d0             	lea    -0x30(%edx),%esi
  8009ee:	89 f3                	mov    %esi,%ebx
  8009f0:	80 fb 09             	cmp    $0x9,%bl
  8009f3:	77 08                	ja     8009fd <strtol+0x8b>
			dig = *s - '0';
  8009f5:	0f be d2             	movsbl %dl,%edx
  8009f8:	83 ea 30             	sub    $0x30,%edx
  8009fb:	eb 22                	jmp    800a1f <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  8009fd:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a00:	89 f3                	mov    %esi,%ebx
  800a02:	80 fb 19             	cmp    $0x19,%bl
  800a05:	77 08                	ja     800a0f <strtol+0x9d>
			dig = *s - 'a' + 10;
  800a07:	0f be d2             	movsbl %dl,%edx
  800a0a:	83 ea 57             	sub    $0x57,%edx
  800a0d:	eb 10                	jmp    800a1f <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800a0f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a12:	89 f3                	mov    %esi,%ebx
  800a14:	80 fb 19             	cmp    $0x19,%bl
  800a17:	77 16                	ja     800a2f <strtol+0xbd>
			dig = *s - 'A' + 10;
  800a19:	0f be d2             	movsbl %dl,%edx
  800a1c:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800a1f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a22:	7d 0b                	jge    800a2f <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800a24:	83 c1 01             	add    $0x1,%ecx
  800a27:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a2b:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800a2d:	eb b9                	jmp    8009e8 <strtol+0x76>

	if (endptr)
  800a2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a33:	74 0d                	je     800a42 <strtol+0xd0>
		*endptr = (char *) s;
  800a35:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a38:	89 0e                	mov    %ecx,(%esi)
  800a3a:	eb 06                	jmp    800a42 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a3c:	85 db                	test   %ebx,%ebx
  800a3e:	74 98                	je     8009d8 <strtol+0x66>
  800a40:	eb 9e                	jmp    8009e0 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800a42:	89 c2                	mov    %eax,%edx
  800a44:	f7 da                	neg    %edx
  800a46:	85 ff                	test   %edi,%edi
  800a48:	0f 45 c2             	cmovne %edx,%eax
}
  800a4b:	5b                   	pop    %ebx
  800a4c:	5e                   	pop    %esi
  800a4d:	5f                   	pop    %edi
  800a4e:	5d                   	pop    %ebp
  800a4f:	c3                   	ret    

00800a50 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	57                   	push   %edi
  800a54:	56                   	push   %esi
  800a55:	53                   	push   %ebx
  800a56:	83 ec 1c             	sub    $0x1c,%esp
  800a59:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a5c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a5f:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800a61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a64:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a67:	8b 7d 10             	mov    0x10(%ebp),%edi
  800a6a:	8b 75 14             	mov    0x14(%ebp),%esi
  800a6d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800a6f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a73:	74 1d                	je     800a92 <syscall+0x42>
  800a75:	85 c0                	test   %eax,%eax
  800a77:	7e 19                	jle    800a92 <syscall+0x42>
  800a79:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800a7c:	83 ec 0c             	sub    $0xc,%esp
  800a7f:	50                   	push   %eax
  800a80:	52                   	push   %edx
  800a81:	68 1f 21 80 00       	push   $0x80211f
  800a86:	6a 23                	push   $0x23
  800a88:	68 3c 21 80 00       	push   $0x80213c
  800a8d:	e8 e9 0e 00 00       	call   80197b <_panic>

	return ret;
}
  800a92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a95:	5b                   	pop    %ebx
  800a96:	5e                   	pop    %esi
  800a97:	5f                   	pop    %edi
  800a98:	5d                   	pop    %ebp
  800a99:	c3                   	ret    

00800a9a <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800aa0:	6a 00                	push   $0x0
  800aa2:	6a 00                	push   $0x0
  800aa4:	6a 00                	push   $0x0
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aac:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab6:	e8 95 ff ff ff       	call   800a50 <syscall>
}
  800abb:	83 c4 10             	add    $0x10,%esp
  800abe:	c9                   	leave  
  800abf:	c3                   	ret    

00800ac0 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800ac6:	6a 00                	push   $0x0
  800ac8:	6a 00                	push   $0x0
  800aca:	6a 00                	push   $0x0
  800acc:	6a 00                	push   $0x0
  800ace:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ad3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad8:	b8 01 00 00 00       	mov    $0x1,%eax
  800add:	e8 6e ff ff ff       	call   800a50 <syscall>
}
  800ae2:	c9                   	leave  
  800ae3:	c3                   	ret    

00800ae4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ae4:	55                   	push   %ebp
  800ae5:	89 e5                	mov    %esp,%ebp
  800ae7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800aea:	6a 00                	push   $0x0
  800aec:	6a 00                	push   $0x0
  800aee:	6a 00                	push   $0x0
  800af0:	6a 00                	push   $0x0
  800af2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af5:	ba 01 00 00 00       	mov    $0x1,%edx
  800afa:	b8 03 00 00 00       	mov    $0x3,%eax
  800aff:	e8 4c ff ff ff       	call   800a50 <syscall>
}
  800b04:	c9                   	leave  
  800b05:	c3                   	ret    

00800b06 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b0c:	6a 00                	push   $0x0
  800b0e:	6a 00                	push   $0x0
  800b10:	6a 00                	push   $0x0
  800b12:	6a 00                	push   $0x0
  800b14:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b19:	ba 00 00 00 00       	mov    $0x0,%edx
  800b1e:	b8 02 00 00 00       	mov    $0x2,%eax
  800b23:	e8 28 ff ff ff       	call   800a50 <syscall>
}
  800b28:	c9                   	leave  
  800b29:	c3                   	ret    

00800b2a <sys_yield>:

void
sys_yield(void)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b30:	6a 00                	push   $0x0
  800b32:	6a 00                	push   $0x0
  800b34:	6a 00                	push   $0x0
  800b36:	6a 00                	push   $0x0
  800b38:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b42:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b47:	e8 04 ff ff ff       	call   800a50 <syscall>
}
  800b4c:	83 c4 10             	add    $0x10,%esp
  800b4f:	c9                   	leave  
  800b50:	c3                   	ret    

00800b51 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800b57:	6a 00                	push   $0x0
  800b59:	6a 00                	push   $0x0
  800b5b:	ff 75 10             	pushl  0x10(%ebp)
  800b5e:	ff 75 0c             	pushl  0xc(%ebp)
  800b61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b64:	ba 01 00 00 00       	mov    $0x1,%edx
  800b69:	b8 04 00 00 00       	mov    $0x4,%eax
  800b6e:	e8 dd fe ff ff       	call   800a50 <syscall>
}
  800b73:	c9                   	leave  
  800b74:	c3                   	ret    

00800b75 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800b7b:	ff 75 18             	pushl  0x18(%ebp)
  800b7e:	ff 75 14             	pushl  0x14(%ebp)
  800b81:	ff 75 10             	pushl  0x10(%ebp)
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b8a:	ba 01 00 00 00       	mov    $0x1,%edx
  800b8f:	b8 05 00 00 00       	mov    $0x5,%eax
  800b94:	e8 b7 fe ff ff       	call   800a50 <syscall>
}
  800b99:	c9                   	leave  
  800b9a:	c3                   	ret    

00800b9b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800ba1:	6a 00                	push   $0x0
  800ba3:	6a 00                	push   $0x0
  800ba5:	6a 00                	push   $0x0
  800ba7:	ff 75 0c             	pushl  0xc(%ebp)
  800baa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bad:	ba 01 00 00 00       	mov    $0x1,%edx
  800bb2:	b8 06 00 00 00       	mov    $0x6,%eax
  800bb7:	e8 94 fe ff ff       	call   800a50 <syscall>
}
  800bbc:	c9                   	leave  
  800bbd:	c3                   	ret    

00800bbe <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800bc4:	6a 00                	push   $0x0
  800bc6:	6a 00                	push   $0x0
  800bc8:	6a 00                	push   $0x0
  800bca:	ff 75 0c             	pushl  0xc(%ebp)
  800bcd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd0:	ba 01 00 00 00       	mov    $0x1,%edx
  800bd5:	b8 08 00 00 00       	mov    $0x8,%eax
  800bda:	e8 71 fe ff ff       	call   800a50 <syscall>
}
  800bdf:	c9                   	leave  
  800be0:	c3                   	ret    

00800be1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800be7:	6a 00                	push   $0x0
  800be9:	6a 00                	push   $0x0
  800beb:	6a 00                	push   $0x0
  800bed:	ff 75 0c             	pushl  0xc(%ebp)
  800bf0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf3:	ba 01 00 00 00       	mov    $0x1,%edx
  800bf8:	b8 09 00 00 00       	mov    $0x9,%eax
  800bfd:	e8 4e fe ff ff       	call   800a50 <syscall>
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800c0a:	6a 00                	push   $0x0
  800c0c:	6a 00                	push   $0x0
  800c0e:	6a 00                	push   $0x0
  800c10:	ff 75 0c             	pushl  0xc(%ebp)
  800c13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c16:	ba 01 00 00 00       	mov    $0x1,%edx
  800c1b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c20:	e8 2b fe ff ff       	call   800a50 <syscall>
}
  800c25:	c9                   	leave  
  800c26:	c3                   	ret    

00800c27 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800c2d:	6a 00                	push   $0x0
  800c2f:	ff 75 14             	pushl  0x14(%ebp)
  800c32:	ff 75 10             	pushl  0x10(%ebp)
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c40:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c45:	e8 06 fe ff ff       	call   800a50 <syscall>
}
  800c4a:	c9                   	leave  
  800c4b:	c3                   	ret    

00800c4c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800c52:	6a 00                	push   $0x0
  800c54:	6a 00                	push   $0x0
  800c56:	6a 00                	push   $0x0
  800c58:	6a 00                	push   $0x0
  800c5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c5d:	ba 01 00 00 00       	mov    $0x1,%edx
  800c62:	b8 0d 00 00 00       	mov    $0xd,%eax
  800c67:	e8 e4 fd ff ff       	call   800a50 <syscall>
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	05 00 00 00 30       	add    $0x30000000,%eax
  800c79:	c1 e8 0c             	shr    $0xc,%eax
}
  800c7c:	5d                   	pop    %ebp
  800c7d:	c3                   	ret    

00800c7e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  800c81:	ff 75 08             	pushl  0x8(%ebp)
  800c84:	e8 e5 ff ff ff       	call   800c6e <fd2num>
  800c89:	83 c4 04             	add    $0x4,%esp
  800c8c:	c1 e0 0c             	shl    $0xc,%eax
  800c8f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800c94:	c9                   	leave  
  800c95:	c3                   	ret    

00800c96 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
  800c99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c9c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ca1:	89 c2                	mov    %eax,%edx
  800ca3:	c1 ea 16             	shr    $0x16,%edx
  800ca6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800cad:	f6 c2 01             	test   $0x1,%dl
  800cb0:	74 11                	je     800cc3 <fd_alloc+0x2d>
  800cb2:	89 c2                	mov    %eax,%edx
  800cb4:	c1 ea 0c             	shr    $0xc,%edx
  800cb7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800cbe:	f6 c2 01             	test   $0x1,%dl
  800cc1:	75 09                	jne    800ccc <fd_alloc+0x36>
			*fd_store = fd;
  800cc3:	89 01                	mov    %eax,(%ecx)
			return 0;
  800cc5:	b8 00 00 00 00       	mov    $0x0,%eax
  800cca:	eb 17                	jmp    800ce3 <fd_alloc+0x4d>
  800ccc:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800cd1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800cd6:	75 c9                	jne    800ca1 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800cd8:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800cde:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800ce3:	5d                   	pop    %ebp
  800ce4:	c3                   	ret    

00800ce5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800ceb:	83 f8 1f             	cmp    $0x1f,%eax
  800cee:	77 36                	ja     800d26 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800cf0:	c1 e0 0c             	shl    $0xc,%eax
  800cf3:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800cf8:	89 c2                	mov    %eax,%edx
  800cfa:	c1 ea 16             	shr    $0x16,%edx
  800cfd:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800d04:	f6 c2 01             	test   $0x1,%dl
  800d07:	74 24                	je     800d2d <fd_lookup+0x48>
  800d09:	89 c2                	mov    %eax,%edx
  800d0b:	c1 ea 0c             	shr    $0xc,%edx
  800d0e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d15:	f6 c2 01             	test   $0x1,%dl
  800d18:	74 1a                	je     800d34 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800d1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1d:	89 02                	mov    %eax,(%edx)
	return 0;
  800d1f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d24:	eb 13                	jmp    800d39 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800d26:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d2b:	eb 0c                	jmp    800d39 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800d2d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d32:	eb 05                	jmp    800d39 <fd_lookup+0x54>
  800d34:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    

00800d3b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	83 ec 08             	sub    $0x8,%esp
  800d41:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d44:	ba c8 21 80 00       	mov    $0x8021c8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800d49:	eb 13                	jmp    800d5e <dev_lookup+0x23>
  800d4b:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  800d4e:	39 08                	cmp    %ecx,(%eax)
  800d50:	75 0c                	jne    800d5e <dev_lookup+0x23>
			*dev = devtab[i];
  800d52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d55:	89 01                	mov    %eax,(%ecx)
			return 0;
  800d57:	b8 00 00 00 00       	mov    $0x0,%eax
  800d5c:	eb 2e                	jmp    800d8c <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800d5e:	8b 02                	mov    (%edx),%eax
  800d60:	85 c0                	test   %eax,%eax
  800d62:	75 e7                	jne    800d4b <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800d64:	a1 04 40 80 00       	mov    0x804004,%eax
  800d69:	8b 40 48             	mov    0x48(%eax),%eax
  800d6c:	83 ec 04             	sub    $0x4,%esp
  800d6f:	51                   	push   %ecx
  800d70:	50                   	push   %eax
  800d71:	68 4c 21 80 00       	push   $0x80214c
  800d76:	e8 1b f4 ff ff       	call   800196 <cprintf>
	*dev = 0;
  800d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800d84:	83 c4 10             	add    $0x10,%esp
  800d87:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800d8c:	c9                   	leave  
  800d8d:	c3                   	ret    

00800d8e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800d8e:	55                   	push   %ebp
  800d8f:	89 e5                	mov    %esp,%ebp
  800d91:	56                   	push   %esi
  800d92:	53                   	push   %ebx
  800d93:	83 ec 10             	sub    $0x10,%esp
  800d96:	8b 75 08             	mov    0x8(%ebp),%esi
  800d99:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800d9c:	56                   	push   %esi
  800d9d:	e8 cc fe ff ff       	call   800c6e <fd2num>
  800da2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800da5:	89 14 24             	mov    %edx,(%esp)
  800da8:	50                   	push   %eax
  800da9:	e8 37 ff ff ff       	call   800ce5 <fd_lookup>
  800dae:	83 c4 08             	add    $0x8,%esp
  800db1:	85 c0                	test   %eax,%eax
  800db3:	78 05                	js     800dba <fd_close+0x2c>
	    || fd != fd2)
  800db5:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800db8:	74 0c                	je     800dc6 <fd_close+0x38>
		return (must_exist ? r : 0);
  800dba:	84 db                	test   %bl,%bl
  800dbc:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc1:	0f 44 c2             	cmove  %edx,%eax
  800dc4:	eb 41                	jmp    800e07 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800dc6:	83 ec 08             	sub    $0x8,%esp
  800dc9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800dcc:	50                   	push   %eax
  800dcd:	ff 36                	pushl  (%esi)
  800dcf:	e8 67 ff ff ff       	call   800d3b <dev_lookup>
  800dd4:	89 c3                	mov    %eax,%ebx
  800dd6:	83 c4 10             	add    $0x10,%esp
  800dd9:	85 c0                	test   %eax,%eax
  800ddb:	78 1a                	js     800df7 <fd_close+0x69>
		if (dev->dev_close)
  800ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de0:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800de3:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800de8:	85 c0                	test   %eax,%eax
  800dea:	74 0b                	je     800df7 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  800dec:	83 ec 0c             	sub    $0xc,%esp
  800def:	56                   	push   %esi
  800df0:	ff d0                	call   *%eax
  800df2:	89 c3                	mov    %eax,%ebx
  800df4:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800df7:	83 ec 08             	sub    $0x8,%esp
  800dfa:	56                   	push   %esi
  800dfb:	6a 00                	push   $0x0
  800dfd:	e8 99 fd ff ff       	call   800b9b <sys_page_unmap>
	return r;
  800e02:	83 c4 10             	add    $0x10,%esp
  800e05:	89 d8                	mov    %ebx,%eax
}
  800e07:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e0a:	5b                   	pop    %ebx
  800e0b:	5e                   	pop    %esi
  800e0c:	5d                   	pop    %ebp
  800e0d:	c3                   	ret    

00800e0e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e17:	50                   	push   %eax
  800e18:	ff 75 08             	pushl  0x8(%ebp)
  800e1b:	e8 c5 fe ff ff       	call   800ce5 <fd_lookup>
  800e20:	83 c4 08             	add    $0x8,%esp
  800e23:	85 c0                	test   %eax,%eax
  800e25:	78 10                	js     800e37 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800e27:	83 ec 08             	sub    $0x8,%esp
  800e2a:	6a 01                	push   $0x1
  800e2c:	ff 75 f4             	pushl  -0xc(%ebp)
  800e2f:	e8 5a ff ff ff       	call   800d8e <fd_close>
  800e34:	83 c4 10             	add    $0x10,%esp
}
  800e37:	c9                   	leave  
  800e38:	c3                   	ret    

00800e39 <close_all>:

void
close_all(void)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	53                   	push   %ebx
  800e3d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800e40:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800e45:	83 ec 0c             	sub    $0xc,%esp
  800e48:	53                   	push   %ebx
  800e49:	e8 c0 ff ff ff       	call   800e0e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800e4e:	83 c3 01             	add    $0x1,%ebx
  800e51:	83 c4 10             	add    $0x10,%esp
  800e54:	83 fb 20             	cmp    $0x20,%ebx
  800e57:	75 ec                	jne    800e45 <close_all+0xc>
		close(i);
}
  800e59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e5c:	c9                   	leave  
  800e5d:	c3                   	ret    

00800e5e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	57                   	push   %edi
  800e62:	56                   	push   %esi
  800e63:	53                   	push   %ebx
  800e64:	83 ec 2c             	sub    $0x2c,%esp
  800e67:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800e6a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800e6d:	50                   	push   %eax
  800e6e:	ff 75 08             	pushl  0x8(%ebp)
  800e71:	e8 6f fe ff ff       	call   800ce5 <fd_lookup>
  800e76:	83 c4 08             	add    $0x8,%esp
  800e79:	85 c0                	test   %eax,%eax
  800e7b:	0f 88 c1 00 00 00    	js     800f42 <dup+0xe4>
		return r;
	close(newfdnum);
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	56                   	push   %esi
  800e85:	e8 84 ff ff ff       	call   800e0e <close>

	newfd = INDEX2FD(newfdnum);
  800e8a:	89 f3                	mov    %esi,%ebx
  800e8c:	c1 e3 0c             	shl    $0xc,%ebx
  800e8f:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800e95:	83 c4 04             	add    $0x4,%esp
  800e98:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e9b:	e8 de fd ff ff       	call   800c7e <fd2data>
  800ea0:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  800ea2:	89 1c 24             	mov    %ebx,(%esp)
  800ea5:	e8 d4 fd ff ff       	call   800c7e <fd2data>
  800eaa:	83 c4 10             	add    $0x10,%esp
  800ead:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800eb0:	89 f8                	mov    %edi,%eax
  800eb2:	c1 e8 16             	shr    $0x16,%eax
  800eb5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800ebc:	a8 01                	test   $0x1,%al
  800ebe:	74 37                	je     800ef7 <dup+0x99>
  800ec0:	89 f8                	mov    %edi,%eax
  800ec2:	c1 e8 0c             	shr    $0xc,%eax
  800ec5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800ecc:	f6 c2 01             	test   $0x1,%dl
  800ecf:	74 26                	je     800ef7 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800ed1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ed8:	83 ec 0c             	sub    $0xc,%esp
  800edb:	25 07 0e 00 00       	and    $0xe07,%eax
  800ee0:	50                   	push   %eax
  800ee1:	ff 75 d4             	pushl  -0x2c(%ebp)
  800ee4:	6a 00                	push   $0x0
  800ee6:	57                   	push   %edi
  800ee7:	6a 00                	push   $0x0
  800ee9:	e8 87 fc ff ff       	call   800b75 <sys_page_map>
  800eee:	89 c7                	mov    %eax,%edi
  800ef0:	83 c4 20             	add    $0x20,%esp
  800ef3:	85 c0                	test   %eax,%eax
  800ef5:	78 2e                	js     800f25 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800ef7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800efa:	89 d0                	mov    %edx,%eax
  800efc:	c1 e8 0c             	shr    $0xc,%eax
  800eff:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f06:	83 ec 0c             	sub    $0xc,%esp
  800f09:	25 07 0e 00 00       	and    $0xe07,%eax
  800f0e:	50                   	push   %eax
  800f0f:	53                   	push   %ebx
  800f10:	6a 00                	push   $0x0
  800f12:	52                   	push   %edx
  800f13:	6a 00                	push   $0x0
  800f15:	e8 5b fc ff ff       	call   800b75 <sys_page_map>
  800f1a:	89 c7                	mov    %eax,%edi
  800f1c:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  800f1f:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800f21:	85 ff                	test   %edi,%edi
  800f23:	79 1d                	jns    800f42 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800f25:	83 ec 08             	sub    $0x8,%esp
  800f28:	53                   	push   %ebx
  800f29:	6a 00                	push   $0x0
  800f2b:	e8 6b fc ff ff       	call   800b9b <sys_page_unmap>
	sys_page_unmap(0, nva);
  800f30:	83 c4 08             	add    $0x8,%esp
  800f33:	ff 75 d4             	pushl  -0x2c(%ebp)
  800f36:	6a 00                	push   $0x0
  800f38:	e8 5e fc ff ff       	call   800b9b <sys_page_unmap>
	return r;
  800f3d:	83 c4 10             	add    $0x10,%esp
  800f40:	89 f8                	mov    %edi,%eax
}
  800f42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f45:	5b                   	pop    %ebx
  800f46:	5e                   	pop    %esi
  800f47:	5f                   	pop    %edi
  800f48:	5d                   	pop    %ebp
  800f49:	c3                   	ret    

00800f4a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	53                   	push   %ebx
  800f4e:	83 ec 14             	sub    $0x14,%esp
  800f51:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800f54:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800f57:	50                   	push   %eax
  800f58:	53                   	push   %ebx
  800f59:	e8 87 fd ff ff       	call   800ce5 <fd_lookup>
  800f5e:	83 c4 08             	add    $0x8,%esp
  800f61:	89 c2                	mov    %eax,%edx
  800f63:	85 c0                	test   %eax,%eax
  800f65:	78 6d                	js     800fd4 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800f67:	83 ec 08             	sub    $0x8,%esp
  800f6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f6d:	50                   	push   %eax
  800f6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f71:	ff 30                	pushl  (%eax)
  800f73:	e8 c3 fd ff ff       	call   800d3b <dev_lookup>
  800f78:	83 c4 10             	add    $0x10,%esp
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	78 4c                	js     800fcb <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800f7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f82:	8b 42 08             	mov    0x8(%edx),%eax
  800f85:	83 e0 03             	and    $0x3,%eax
  800f88:	83 f8 01             	cmp    $0x1,%eax
  800f8b:	75 21                	jne    800fae <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800f8d:	a1 04 40 80 00       	mov    0x804004,%eax
  800f92:	8b 40 48             	mov    0x48(%eax),%eax
  800f95:	83 ec 04             	sub    $0x4,%esp
  800f98:	53                   	push   %ebx
  800f99:	50                   	push   %eax
  800f9a:	68 8d 21 80 00       	push   $0x80218d
  800f9f:	e8 f2 f1 ff ff       	call   800196 <cprintf>
		return -E_INVAL;
  800fa4:	83 c4 10             	add    $0x10,%esp
  800fa7:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800fac:	eb 26                	jmp    800fd4 <read+0x8a>
	}
	if (!dev->dev_read)
  800fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb1:	8b 40 08             	mov    0x8(%eax),%eax
  800fb4:	85 c0                	test   %eax,%eax
  800fb6:	74 17                	je     800fcf <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800fb8:	83 ec 04             	sub    $0x4,%esp
  800fbb:	ff 75 10             	pushl  0x10(%ebp)
  800fbe:	ff 75 0c             	pushl  0xc(%ebp)
  800fc1:	52                   	push   %edx
  800fc2:	ff d0                	call   *%eax
  800fc4:	89 c2                	mov    %eax,%edx
  800fc6:	83 c4 10             	add    $0x10,%esp
  800fc9:	eb 09                	jmp    800fd4 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800fcb:	89 c2                	mov    %eax,%edx
  800fcd:	eb 05                	jmp    800fd4 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800fcf:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  800fd4:	89 d0                	mov    %edx,%eax
  800fd6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fd9:	c9                   	leave  
  800fda:	c3                   	ret    

00800fdb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	57                   	push   %edi
  800fdf:	56                   	push   %esi
  800fe0:	53                   	push   %ebx
  800fe1:	83 ec 0c             	sub    $0xc,%esp
  800fe4:	8b 7d 08             	mov    0x8(%ebp),%edi
  800fe7:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800fea:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fef:	eb 21                	jmp    801012 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800ff1:	83 ec 04             	sub    $0x4,%esp
  800ff4:	89 f0                	mov    %esi,%eax
  800ff6:	29 d8                	sub    %ebx,%eax
  800ff8:	50                   	push   %eax
  800ff9:	89 d8                	mov    %ebx,%eax
  800ffb:	03 45 0c             	add    0xc(%ebp),%eax
  800ffe:	50                   	push   %eax
  800fff:	57                   	push   %edi
  801000:	e8 45 ff ff ff       	call   800f4a <read>
		if (m < 0)
  801005:	83 c4 10             	add    $0x10,%esp
  801008:	85 c0                	test   %eax,%eax
  80100a:	78 10                	js     80101c <readn+0x41>
			return m;
		if (m == 0)
  80100c:	85 c0                	test   %eax,%eax
  80100e:	74 0a                	je     80101a <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801010:	01 c3                	add    %eax,%ebx
  801012:	39 f3                	cmp    %esi,%ebx
  801014:	72 db                	jb     800ff1 <readn+0x16>
  801016:	89 d8                	mov    %ebx,%eax
  801018:	eb 02                	jmp    80101c <readn+0x41>
  80101a:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80101c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80101f:	5b                   	pop    %ebx
  801020:	5e                   	pop    %esi
  801021:	5f                   	pop    %edi
  801022:	5d                   	pop    %ebp
  801023:	c3                   	ret    

00801024 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
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
  801033:	e8 ad fc ff ff       	call   800ce5 <fd_lookup>
  801038:	83 c4 08             	add    $0x8,%esp
  80103b:	89 c2                	mov    %eax,%edx
  80103d:	85 c0                	test   %eax,%eax
  80103f:	78 68                	js     8010a9 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801041:	83 ec 08             	sub    $0x8,%esp
  801044:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801047:	50                   	push   %eax
  801048:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80104b:	ff 30                	pushl  (%eax)
  80104d:	e8 e9 fc ff ff       	call   800d3b <dev_lookup>
  801052:	83 c4 10             	add    $0x10,%esp
  801055:	85 c0                	test   %eax,%eax
  801057:	78 47                	js     8010a0 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801059:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801060:	75 21                	jne    801083 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801062:	a1 04 40 80 00       	mov    0x804004,%eax
  801067:	8b 40 48             	mov    0x48(%eax),%eax
  80106a:	83 ec 04             	sub    $0x4,%esp
  80106d:	53                   	push   %ebx
  80106e:	50                   	push   %eax
  80106f:	68 a9 21 80 00       	push   $0x8021a9
  801074:	e8 1d f1 ff ff       	call   800196 <cprintf>
		return -E_INVAL;
  801079:	83 c4 10             	add    $0x10,%esp
  80107c:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801081:	eb 26                	jmp    8010a9 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801083:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801086:	8b 52 0c             	mov    0xc(%edx),%edx
  801089:	85 d2                	test   %edx,%edx
  80108b:	74 17                	je     8010a4 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80108d:	83 ec 04             	sub    $0x4,%esp
  801090:	ff 75 10             	pushl  0x10(%ebp)
  801093:	ff 75 0c             	pushl  0xc(%ebp)
  801096:	50                   	push   %eax
  801097:	ff d2                	call   *%edx
  801099:	89 c2                	mov    %eax,%edx
  80109b:	83 c4 10             	add    $0x10,%esp
  80109e:	eb 09                	jmp    8010a9 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010a0:	89 c2                	mov    %eax,%edx
  8010a2:	eb 05                	jmp    8010a9 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8010a4:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  8010a9:	89 d0                	mov    %edx,%eax
  8010ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010ae:	c9                   	leave  
  8010af:	c3                   	ret    

008010b0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
  8010b3:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010b6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8010b9:	50                   	push   %eax
  8010ba:	ff 75 08             	pushl  0x8(%ebp)
  8010bd:	e8 23 fc ff ff       	call   800ce5 <fd_lookup>
  8010c2:	83 c4 08             	add    $0x8,%esp
  8010c5:	85 c0                	test   %eax,%eax
  8010c7:	78 0e                	js     8010d7 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8010c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010cf:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8010d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010d7:	c9                   	leave  
  8010d8:	c3                   	ret    

008010d9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	53                   	push   %ebx
  8010dd:	83 ec 14             	sub    $0x14,%esp
  8010e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010e6:	50                   	push   %eax
  8010e7:	53                   	push   %ebx
  8010e8:	e8 f8 fb ff ff       	call   800ce5 <fd_lookup>
  8010ed:	83 c4 08             	add    $0x8,%esp
  8010f0:	89 c2                	mov    %eax,%edx
  8010f2:	85 c0                	test   %eax,%eax
  8010f4:	78 65                	js     80115b <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010f6:	83 ec 08             	sub    $0x8,%esp
  8010f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010fc:	50                   	push   %eax
  8010fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801100:	ff 30                	pushl  (%eax)
  801102:	e8 34 fc ff ff       	call   800d3b <dev_lookup>
  801107:	83 c4 10             	add    $0x10,%esp
  80110a:	85 c0                	test   %eax,%eax
  80110c:	78 44                	js     801152 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80110e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801111:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801115:	75 21                	jne    801138 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801117:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80111c:	8b 40 48             	mov    0x48(%eax),%eax
  80111f:	83 ec 04             	sub    $0x4,%esp
  801122:	53                   	push   %ebx
  801123:	50                   	push   %eax
  801124:	68 6c 21 80 00       	push   $0x80216c
  801129:	e8 68 f0 ff ff       	call   800196 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80112e:	83 c4 10             	add    $0x10,%esp
  801131:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801136:	eb 23                	jmp    80115b <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  801138:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80113b:	8b 52 18             	mov    0x18(%edx),%edx
  80113e:	85 d2                	test   %edx,%edx
  801140:	74 14                	je     801156 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801142:	83 ec 08             	sub    $0x8,%esp
  801145:	ff 75 0c             	pushl  0xc(%ebp)
  801148:	50                   	push   %eax
  801149:	ff d2                	call   *%edx
  80114b:	89 c2                	mov    %eax,%edx
  80114d:	83 c4 10             	add    $0x10,%esp
  801150:	eb 09                	jmp    80115b <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801152:	89 c2                	mov    %eax,%edx
  801154:	eb 05                	jmp    80115b <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801156:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  80115b:	89 d0                	mov    %edx,%eax
  80115d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801160:	c9                   	leave  
  801161:	c3                   	ret    

00801162 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	53                   	push   %ebx
  801166:	83 ec 14             	sub    $0x14,%esp
  801169:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80116c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80116f:	50                   	push   %eax
  801170:	ff 75 08             	pushl  0x8(%ebp)
  801173:	e8 6d fb ff ff       	call   800ce5 <fd_lookup>
  801178:	83 c4 08             	add    $0x8,%esp
  80117b:	89 c2                	mov    %eax,%edx
  80117d:	85 c0                	test   %eax,%eax
  80117f:	78 58                	js     8011d9 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801181:	83 ec 08             	sub    $0x8,%esp
  801184:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801187:	50                   	push   %eax
  801188:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80118b:	ff 30                	pushl  (%eax)
  80118d:	e8 a9 fb ff ff       	call   800d3b <dev_lookup>
  801192:	83 c4 10             	add    $0x10,%esp
  801195:	85 c0                	test   %eax,%eax
  801197:	78 37                	js     8011d0 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  801199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80119c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8011a0:	74 32                	je     8011d4 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8011a2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8011a5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8011ac:	00 00 00 
	stat->st_isdir = 0;
  8011af:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8011b6:	00 00 00 
	stat->st_dev = dev;
  8011b9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8011bf:	83 ec 08             	sub    $0x8,%esp
  8011c2:	53                   	push   %ebx
  8011c3:	ff 75 f0             	pushl  -0x10(%ebp)
  8011c6:	ff 50 14             	call   *0x14(%eax)
  8011c9:	89 c2                	mov    %eax,%edx
  8011cb:	83 c4 10             	add    $0x10,%esp
  8011ce:	eb 09                	jmp    8011d9 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011d0:	89 c2                	mov    %eax,%edx
  8011d2:	eb 05                	jmp    8011d9 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8011d4:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8011d9:	89 d0                	mov    %edx,%eax
  8011db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	56                   	push   %esi
  8011e4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8011e5:	83 ec 08             	sub    $0x8,%esp
  8011e8:	6a 00                	push   $0x0
  8011ea:	ff 75 08             	pushl  0x8(%ebp)
  8011ed:	e8 06 02 00 00       	call   8013f8 <open>
  8011f2:	89 c3                	mov    %eax,%ebx
  8011f4:	83 c4 10             	add    $0x10,%esp
  8011f7:	85 c0                	test   %eax,%eax
  8011f9:	78 1b                	js     801216 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8011fb:	83 ec 08             	sub    $0x8,%esp
  8011fe:	ff 75 0c             	pushl  0xc(%ebp)
  801201:	50                   	push   %eax
  801202:	e8 5b ff ff ff       	call   801162 <fstat>
  801207:	89 c6                	mov    %eax,%esi
	close(fd);
  801209:	89 1c 24             	mov    %ebx,(%esp)
  80120c:	e8 fd fb ff ff       	call   800e0e <close>
	return r;
  801211:	83 c4 10             	add    $0x10,%esp
  801214:	89 f0                	mov    %esi,%eax
}
  801216:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801219:	5b                   	pop    %ebx
  80121a:	5e                   	pop    %esi
  80121b:	5d                   	pop    %ebp
  80121c:	c3                   	ret    

0080121d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
  801220:	56                   	push   %esi
  801221:	53                   	push   %ebx
  801222:	89 c6                	mov    %eax,%esi
  801224:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801226:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80122d:	75 12                	jne    801241 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80122f:	83 ec 0c             	sub    $0xc,%esp
  801232:	6a 01                	push   $0x1
  801234:	e8 47 08 00 00       	call   801a80 <ipc_find_env>
  801239:	a3 00 40 80 00       	mov    %eax,0x804000
  80123e:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801241:	6a 07                	push   $0x7
  801243:	68 00 50 80 00       	push   $0x805000
  801248:	56                   	push   %esi
  801249:	ff 35 00 40 80 00    	pushl  0x804000
  80124f:	e8 d8 07 00 00       	call   801a2c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801254:	83 c4 0c             	add    $0xc,%esp
  801257:	6a 00                	push   $0x0
  801259:	53                   	push   %ebx
  80125a:	6a 00                	push   $0x0
  80125c:	e8 60 07 00 00       	call   8019c1 <ipc_recv>
}
  801261:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801264:	5b                   	pop    %ebx
  801265:	5e                   	pop    %esi
  801266:	5d                   	pop    %ebp
  801267:	c3                   	ret    

00801268 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801268:	55                   	push   %ebp
  801269:	89 e5                	mov    %esp,%ebp
  80126b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8b 40 0c             	mov    0xc(%eax),%eax
  801274:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801279:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127c:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801281:	ba 00 00 00 00       	mov    $0x0,%edx
  801286:	b8 02 00 00 00       	mov    $0x2,%eax
  80128b:	e8 8d ff ff ff       	call   80121d <fsipc>
}
  801290:	c9                   	leave  
  801291:	c3                   	ret    

00801292 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
  801295:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
  80129b:	8b 40 0c             	mov    0xc(%eax),%eax
  80129e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8012a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8012a8:	b8 06 00 00 00       	mov    $0x6,%eax
  8012ad:	e8 6b ff ff ff       	call   80121d <fsipc>
}
  8012b2:	c9                   	leave  
  8012b3:	c3                   	ret    

008012b4 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	53                   	push   %ebx
  8012b8:	83 ec 04             	sub    $0x4,%esp
  8012bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8012be:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8012c4:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8012c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8012ce:	b8 05 00 00 00       	mov    $0x5,%eax
  8012d3:	e8 45 ff ff ff       	call   80121d <fsipc>
  8012d8:	85 c0                	test   %eax,%eax
  8012da:	78 2c                	js     801308 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8012dc:	83 ec 08             	sub    $0x8,%esp
  8012df:	68 00 50 80 00       	push   $0x805000
  8012e4:	53                   	push   %ebx
  8012e5:	e8 1e f4 ff ff       	call   800708 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8012ea:	a1 80 50 80 00       	mov    0x805080,%eax
  8012ef:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8012f5:	a1 84 50 80 00       	mov    0x805084,%eax
  8012fa:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801300:	83 c4 10             	add    $0x10,%esp
  801303:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801308:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80130b:	c9                   	leave  
  80130c:	c3                   	ret    

0080130d <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
  801310:	83 ec 08             	sub    $0x8,%esp
  801313:	8b 55 0c             	mov    0xc(%ebp),%edx
  801316:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801319:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80131c:	8b 49 0c             	mov    0xc(%ecx),%ecx
  80131f:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  801325:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80132a:	76 22                	jbe    80134e <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  80132c:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  801333:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  801336:	83 ec 04             	sub    $0x4,%esp
  801339:	68 f8 0f 00 00       	push   $0xff8
  80133e:	52                   	push   %edx
  80133f:	68 08 50 80 00       	push   $0x805008
  801344:	e8 52 f5 ff ff       	call   80089b <memmove>
  801349:	83 c4 10             	add    $0x10,%esp
  80134c:	eb 17                	jmp    801365 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  80134e:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  801353:	83 ec 04             	sub    $0x4,%esp
  801356:	50                   	push   %eax
  801357:	52                   	push   %edx
  801358:	68 08 50 80 00       	push   $0x805008
  80135d:	e8 39 f5 ff ff       	call   80089b <memmove>
  801362:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  801365:	ba 00 00 00 00       	mov    $0x0,%edx
  80136a:	b8 04 00 00 00       	mov    $0x4,%eax
  80136f:	e8 a9 fe ff ff       	call   80121d <fsipc>
	if (result < 0)
		return result;

	return result;
}
  801374:	c9                   	leave  
  801375:	c3                   	ret    

00801376 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	56                   	push   %esi
  80137a:	53                   	push   %ebx
  80137b:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80137e:	8b 45 08             	mov    0x8(%ebp),%eax
  801381:	8b 40 0c             	mov    0xc(%eax),%eax
  801384:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801389:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80138f:	ba 00 00 00 00       	mov    $0x0,%edx
  801394:	b8 03 00 00 00       	mov    $0x3,%eax
  801399:	e8 7f fe ff ff       	call   80121d <fsipc>
  80139e:	89 c3                	mov    %eax,%ebx
  8013a0:	85 c0                	test   %eax,%eax
  8013a2:	78 4b                	js     8013ef <devfile_read+0x79>
		return r;
	assert(r <= n);
  8013a4:	39 c6                	cmp    %eax,%esi
  8013a6:	73 16                	jae    8013be <devfile_read+0x48>
  8013a8:	68 d8 21 80 00       	push   $0x8021d8
  8013ad:	68 df 21 80 00       	push   $0x8021df
  8013b2:	6a 7c                	push   $0x7c
  8013b4:	68 f4 21 80 00       	push   $0x8021f4
  8013b9:	e8 bd 05 00 00       	call   80197b <_panic>
	assert(r <= PGSIZE);
  8013be:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8013c3:	7e 16                	jle    8013db <devfile_read+0x65>
  8013c5:	68 ff 21 80 00       	push   $0x8021ff
  8013ca:	68 df 21 80 00       	push   $0x8021df
  8013cf:	6a 7d                	push   $0x7d
  8013d1:	68 f4 21 80 00       	push   $0x8021f4
  8013d6:	e8 a0 05 00 00       	call   80197b <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8013db:	83 ec 04             	sub    $0x4,%esp
  8013de:	50                   	push   %eax
  8013df:	68 00 50 80 00       	push   $0x805000
  8013e4:	ff 75 0c             	pushl  0xc(%ebp)
  8013e7:	e8 af f4 ff ff       	call   80089b <memmove>
	return r;
  8013ec:	83 c4 10             	add    $0x10,%esp
}
  8013ef:	89 d8                	mov    %ebx,%eax
  8013f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013f4:	5b                   	pop    %ebx
  8013f5:	5e                   	pop    %esi
  8013f6:	5d                   	pop    %ebp
  8013f7:	c3                   	ret    

008013f8 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8013f8:	55                   	push   %ebp
  8013f9:	89 e5                	mov    %esp,%ebp
  8013fb:	53                   	push   %ebx
  8013fc:	83 ec 20             	sub    $0x20,%esp
  8013ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801402:	53                   	push   %ebx
  801403:	e8 c7 f2 ff ff       	call   8006cf <strlen>
  801408:	83 c4 10             	add    $0x10,%esp
  80140b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801410:	7f 67                	jg     801479 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801412:	83 ec 0c             	sub    $0xc,%esp
  801415:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801418:	50                   	push   %eax
  801419:	e8 78 f8 ff ff       	call   800c96 <fd_alloc>
  80141e:	83 c4 10             	add    $0x10,%esp
		return r;
  801421:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801423:	85 c0                	test   %eax,%eax
  801425:	78 57                	js     80147e <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801427:	83 ec 08             	sub    $0x8,%esp
  80142a:	53                   	push   %ebx
  80142b:	68 00 50 80 00       	push   $0x805000
  801430:	e8 d3 f2 ff ff       	call   800708 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801435:	8b 45 0c             	mov    0xc(%ebp),%eax
  801438:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80143d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801440:	b8 01 00 00 00       	mov    $0x1,%eax
  801445:	e8 d3 fd ff ff       	call   80121d <fsipc>
  80144a:	89 c3                	mov    %eax,%ebx
  80144c:	83 c4 10             	add    $0x10,%esp
  80144f:	85 c0                	test   %eax,%eax
  801451:	79 14                	jns    801467 <open+0x6f>
		fd_close(fd, 0);
  801453:	83 ec 08             	sub    $0x8,%esp
  801456:	6a 00                	push   $0x0
  801458:	ff 75 f4             	pushl  -0xc(%ebp)
  80145b:	e8 2e f9 ff ff       	call   800d8e <fd_close>
		return r;
  801460:	83 c4 10             	add    $0x10,%esp
  801463:	89 da                	mov    %ebx,%edx
  801465:	eb 17                	jmp    80147e <open+0x86>
	}

	return fd2num(fd);
  801467:	83 ec 0c             	sub    $0xc,%esp
  80146a:	ff 75 f4             	pushl  -0xc(%ebp)
  80146d:	e8 fc f7 ff ff       	call   800c6e <fd2num>
  801472:	89 c2                	mov    %eax,%edx
  801474:	83 c4 10             	add    $0x10,%esp
  801477:	eb 05                	jmp    80147e <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801479:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  80147e:	89 d0                	mov    %edx,%eax
  801480:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801483:	c9                   	leave  
  801484:	c3                   	ret    

00801485 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80148b:	ba 00 00 00 00       	mov    $0x0,%edx
  801490:	b8 08 00 00 00       	mov    $0x8,%eax
  801495:	e8 83 fd ff ff       	call   80121d <fsipc>
}
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	56                   	push   %esi
  8014a0:	53                   	push   %ebx
  8014a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8014a4:	83 ec 0c             	sub    $0xc,%esp
  8014a7:	ff 75 08             	pushl  0x8(%ebp)
  8014aa:	e8 cf f7 ff ff       	call   800c7e <fd2data>
  8014af:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8014b1:	83 c4 08             	add    $0x8,%esp
  8014b4:	68 0b 22 80 00       	push   $0x80220b
  8014b9:	53                   	push   %ebx
  8014ba:	e8 49 f2 ff ff       	call   800708 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8014bf:	8b 46 04             	mov    0x4(%esi),%eax
  8014c2:	2b 06                	sub    (%esi),%eax
  8014c4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8014ca:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014d1:	00 00 00 
	stat->st_dev = &devpipe;
  8014d4:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8014db:	30 80 00 
	return 0;
}
  8014de:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014e6:	5b                   	pop    %ebx
  8014e7:	5e                   	pop    %esi
  8014e8:	5d                   	pop    %ebp
  8014e9:	c3                   	ret    

008014ea <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
  8014ed:	53                   	push   %ebx
  8014ee:	83 ec 0c             	sub    $0xc,%esp
  8014f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8014f4:	53                   	push   %ebx
  8014f5:	6a 00                	push   $0x0
  8014f7:	e8 9f f6 ff ff       	call   800b9b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8014fc:	89 1c 24             	mov    %ebx,(%esp)
  8014ff:	e8 7a f7 ff ff       	call   800c7e <fd2data>
  801504:	83 c4 08             	add    $0x8,%esp
  801507:	50                   	push   %eax
  801508:	6a 00                	push   $0x0
  80150a:	e8 8c f6 ff ff       	call   800b9b <sys_page_unmap>
}
  80150f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	57                   	push   %edi
  801518:	56                   	push   %esi
  801519:	53                   	push   %ebx
  80151a:	83 ec 1c             	sub    $0x1c,%esp
  80151d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801520:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801522:	a1 04 40 80 00       	mov    0x804004,%eax
  801527:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  80152a:	83 ec 0c             	sub    $0xc,%esp
  80152d:	ff 75 e0             	pushl  -0x20(%ebp)
  801530:	e8 84 05 00 00       	call   801ab9 <pageref>
  801535:	89 c3                	mov    %eax,%ebx
  801537:	89 3c 24             	mov    %edi,(%esp)
  80153a:	e8 7a 05 00 00       	call   801ab9 <pageref>
  80153f:	83 c4 10             	add    $0x10,%esp
  801542:	39 c3                	cmp    %eax,%ebx
  801544:	0f 94 c1             	sete   %cl
  801547:	0f b6 c9             	movzbl %cl,%ecx
  80154a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  80154d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801553:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801556:	39 ce                	cmp    %ecx,%esi
  801558:	74 1b                	je     801575 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  80155a:	39 c3                	cmp    %eax,%ebx
  80155c:	75 c4                	jne    801522 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80155e:	8b 42 58             	mov    0x58(%edx),%eax
  801561:	ff 75 e4             	pushl  -0x1c(%ebp)
  801564:	50                   	push   %eax
  801565:	56                   	push   %esi
  801566:	68 12 22 80 00       	push   $0x802212
  80156b:	e8 26 ec ff ff       	call   800196 <cprintf>
  801570:	83 c4 10             	add    $0x10,%esp
  801573:	eb ad                	jmp    801522 <_pipeisclosed+0xe>
	}
}
  801575:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801578:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80157b:	5b                   	pop    %ebx
  80157c:	5e                   	pop    %esi
  80157d:	5f                   	pop    %edi
  80157e:	5d                   	pop    %ebp
  80157f:	c3                   	ret    

00801580 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	57                   	push   %edi
  801584:	56                   	push   %esi
  801585:	53                   	push   %ebx
  801586:	83 ec 28             	sub    $0x28,%esp
  801589:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80158c:	56                   	push   %esi
  80158d:	e8 ec f6 ff ff       	call   800c7e <fd2data>
  801592:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801594:	83 c4 10             	add    $0x10,%esp
  801597:	bf 00 00 00 00       	mov    $0x0,%edi
  80159c:	eb 4b                	jmp    8015e9 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80159e:	89 da                	mov    %ebx,%edx
  8015a0:	89 f0                	mov    %esi,%eax
  8015a2:	e8 6d ff ff ff       	call   801514 <_pipeisclosed>
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	75 48                	jne    8015f3 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8015ab:	e8 7a f5 ff ff       	call   800b2a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8015b0:	8b 43 04             	mov    0x4(%ebx),%eax
  8015b3:	8b 0b                	mov    (%ebx),%ecx
  8015b5:	8d 51 20             	lea    0x20(%ecx),%edx
  8015b8:	39 d0                	cmp    %edx,%eax
  8015ba:	73 e2                	jae    80159e <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8015bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015bf:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8015c3:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8015c6:	89 c2                	mov    %eax,%edx
  8015c8:	c1 fa 1f             	sar    $0x1f,%edx
  8015cb:	89 d1                	mov    %edx,%ecx
  8015cd:	c1 e9 1b             	shr    $0x1b,%ecx
  8015d0:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8015d3:	83 e2 1f             	and    $0x1f,%edx
  8015d6:	29 ca                	sub    %ecx,%edx
  8015d8:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8015dc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8015e0:	83 c0 01             	add    $0x1,%eax
  8015e3:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8015e6:	83 c7 01             	add    $0x1,%edi
  8015e9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8015ec:	75 c2                	jne    8015b0 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8015ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f1:	eb 05                	jmp    8015f8 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8015f3:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8015f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015fb:	5b                   	pop    %ebx
  8015fc:	5e                   	pop    %esi
  8015fd:	5f                   	pop    %edi
  8015fe:	5d                   	pop    %ebp
  8015ff:	c3                   	ret    

00801600 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	57                   	push   %edi
  801604:	56                   	push   %esi
  801605:	53                   	push   %ebx
  801606:	83 ec 18             	sub    $0x18,%esp
  801609:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80160c:	57                   	push   %edi
  80160d:	e8 6c f6 ff ff       	call   800c7e <fd2data>
  801612:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801614:	83 c4 10             	add    $0x10,%esp
  801617:	bb 00 00 00 00       	mov    $0x0,%ebx
  80161c:	eb 3d                	jmp    80165b <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80161e:	85 db                	test   %ebx,%ebx
  801620:	74 04                	je     801626 <devpipe_read+0x26>
				return i;
  801622:	89 d8                	mov    %ebx,%eax
  801624:	eb 44                	jmp    80166a <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801626:	89 f2                	mov    %esi,%edx
  801628:	89 f8                	mov    %edi,%eax
  80162a:	e8 e5 fe ff ff       	call   801514 <_pipeisclosed>
  80162f:	85 c0                	test   %eax,%eax
  801631:	75 32                	jne    801665 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801633:	e8 f2 f4 ff ff       	call   800b2a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801638:	8b 06                	mov    (%esi),%eax
  80163a:	3b 46 04             	cmp    0x4(%esi),%eax
  80163d:	74 df                	je     80161e <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80163f:	99                   	cltd   
  801640:	c1 ea 1b             	shr    $0x1b,%edx
  801643:	01 d0                	add    %edx,%eax
  801645:	83 e0 1f             	and    $0x1f,%eax
  801648:	29 d0                	sub    %edx,%eax
  80164a:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  80164f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801652:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801655:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801658:	83 c3 01             	add    $0x1,%ebx
  80165b:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  80165e:	75 d8                	jne    801638 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801660:	8b 45 10             	mov    0x10(%ebp),%eax
  801663:	eb 05                	jmp    80166a <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801665:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80166a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80166d:	5b                   	pop    %ebx
  80166e:	5e                   	pop    %esi
  80166f:	5f                   	pop    %edi
  801670:	5d                   	pop    %ebp
  801671:	c3                   	ret    

00801672 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
  801675:	56                   	push   %esi
  801676:	53                   	push   %ebx
  801677:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80167a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167d:	50                   	push   %eax
  80167e:	e8 13 f6 ff ff       	call   800c96 <fd_alloc>
  801683:	83 c4 10             	add    $0x10,%esp
  801686:	89 c2                	mov    %eax,%edx
  801688:	85 c0                	test   %eax,%eax
  80168a:	0f 88 2c 01 00 00    	js     8017bc <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801690:	83 ec 04             	sub    $0x4,%esp
  801693:	68 07 04 00 00       	push   $0x407
  801698:	ff 75 f4             	pushl  -0xc(%ebp)
  80169b:	6a 00                	push   $0x0
  80169d:	e8 af f4 ff ff       	call   800b51 <sys_page_alloc>
  8016a2:	83 c4 10             	add    $0x10,%esp
  8016a5:	89 c2                	mov    %eax,%edx
  8016a7:	85 c0                	test   %eax,%eax
  8016a9:	0f 88 0d 01 00 00    	js     8017bc <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8016af:	83 ec 0c             	sub    $0xc,%esp
  8016b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b5:	50                   	push   %eax
  8016b6:	e8 db f5 ff ff       	call   800c96 <fd_alloc>
  8016bb:	89 c3                	mov    %eax,%ebx
  8016bd:	83 c4 10             	add    $0x10,%esp
  8016c0:	85 c0                	test   %eax,%eax
  8016c2:	0f 88 e2 00 00 00    	js     8017aa <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8016c8:	83 ec 04             	sub    $0x4,%esp
  8016cb:	68 07 04 00 00       	push   $0x407
  8016d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8016d3:	6a 00                	push   $0x0
  8016d5:	e8 77 f4 ff ff       	call   800b51 <sys_page_alloc>
  8016da:	89 c3                	mov    %eax,%ebx
  8016dc:	83 c4 10             	add    $0x10,%esp
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	0f 88 c3 00 00 00    	js     8017aa <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8016e7:	83 ec 0c             	sub    $0xc,%esp
  8016ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8016ed:	e8 8c f5 ff ff       	call   800c7e <fd2data>
  8016f2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8016f4:	83 c4 0c             	add    $0xc,%esp
  8016f7:	68 07 04 00 00       	push   $0x407
  8016fc:	50                   	push   %eax
  8016fd:	6a 00                	push   $0x0
  8016ff:	e8 4d f4 ff ff       	call   800b51 <sys_page_alloc>
  801704:	89 c3                	mov    %eax,%ebx
  801706:	83 c4 10             	add    $0x10,%esp
  801709:	85 c0                	test   %eax,%eax
  80170b:	0f 88 89 00 00 00    	js     80179a <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801711:	83 ec 0c             	sub    $0xc,%esp
  801714:	ff 75 f0             	pushl  -0x10(%ebp)
  801717:	e8 62 f5 ff ff       	call   800c7e <fd2data>
  80171c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801723:	50                   	push   %eax
  801724:	6a 00                	push   $0x0
  801726:	56                   	push   %esi
  801727:	6a 00                	push   $0x0
  801729:	e8 47 f4 ff ff       	call   800b75 <sys_page_map>
  80172e:	89 c3                	mov    %eax,%ebx
  801730:	83 c4 20             	add    $0x20,%esp
  801733:	85 c0                	test   %eax,%eax
  801735:	78 55                	js     80178c <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801737:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80173d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801740:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801745:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  80174c:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801755:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801757:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801761:	83 ec 0c             	sub    $0xc,%esp
  801764:	ff 75 f4             	pushl  -0xc(%ebp)
  801767:	e8 02 f5 ff ff       	call   800c6e <fd2num>
  80176c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80176f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801771:	83 c4 04             	add    $0x4,%esp
  801774:	ff 75 f0             	pushl  -0x10(%ebp)
  801777:	e8 f2 f4 ff ff       	call   800c6e <fd2num>
  80177c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80177f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801782:	83 c4 10             	add    $0x10,%esp
  801785:	ba 00 00 00 00       	mov    $0x0,%edx
  80178a:	eb 30                	jmp    8017bc <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  80178c:	83 ec 08             	sub    $0x8,%esp
  80178f:	56                   	push   %esi
  801790:	6a 00                	push   $0x0
  801792:	e8 04 f4 ff ff       	call   800b9b <sys_page_unmap>
  801797:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  80179a:	83 ec 08             	sub    $0x8,%esp
  80179d:	ff 75 f0             	pushl  -0x10(%ebp)
  8017a0:	6a 00                	push   $0x0
  8017a2:	e8 f4 f3 ff ff       	call   800b9b <sys_page_unmap>
  8017a7:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  8017aa:	83 ec 08             	sub    $0x8,%esp
  8017ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8017b0:	6a 00                	push   $0x0
  8017b2:	e8 e4 f3 ff ff       	call   800b9b <sys_page_unmap>
  8017b7:	83 c4 10             	add    $0x10,%esp
  8017ba:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  8017bc:	89 d0                	mov    %edx,%eax
  8017be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c1:	5b                   	pop    %ebx
  8017c2:	5e                   	pop    %esi
  8017c3:	5d                   	pop    %ebp
  8017c4:	c3                   	ret    

008017c5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ce:	50                   	push   %eax
  8017cf:	ff 75 08             	pushl  0x8(%ebp)
  8017d2:	e8 0e f5 ff ff       	call   800ce5 <fd_lookup>
  8017d7:	83 c4 10             	add    $0x10,%esp
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	78 18                	js     8017f6 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8017de:	83 ec 0c             	sub    $0xc,%esp
  8017e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e4:	e8 95 f4 ff ff       	call   800c7e <fd2data>
	return _pipeisclosed(fd, p);
  8017e9:	89 c2                	mov    %eax,%edx
  8017eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ee:	e8 21 fd ff ff       	call   801514 <_pipeisclosed>
  8017f3:	83 c4 10             	add    $0x10,%esp
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8017fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801800:	5d                   	pop    %ebp
  801801:	c3                   	ret    

00801802 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
  801805:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801808:	68 2a 22 80 00       	push   $0x80222a
  80180d:	ff 75 0c             	pushl  0xc(%ebp)
  801810:	e8 f3 ee ff ff       	call   800708 <strcpy>
	return 0;
}
  801815:	b8 00 00 00 00       	mov    $0x0,%eax
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	57                   	push   %edi
  801820:	56                   	push   %esi
  801821:	53                   	push   %ebx
  801822:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801828:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80182d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801833:	eb 2d                	jmp    801862 <devcons_write+0x46>
		m = n - tot;
  801835:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801838:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  80183a:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80183d:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801842:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801845:	83 ec 04             	sub    $0x4,%esp
  801848:	53                   	push   %ebx
  801849:	03 45 0c             	add    0xc(%ebp),%eax
  80184c:	50                   	push   %eax
  80184d:	57                   	push   %edi
  80184e:	e8 48 f0 ff ff       	call   80089b <memmove>
		sys_cputs(buf, m);
  801853:	83 c4 08             	add    $0x8,%esp
  801856:	53                   	push   %ebx
  801857:	57                   	push   %edi
  801858:	e8 3d f2 ff ff       	call   800a9a <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80185d:	01 de                	add    %ebx,%esi
  80185f:	83 c4 10             	add    $0x10,%esp
  801862:	89 f0                	mov    %esi,%eax
  801864:	3b 75 10             	cmp    0x10(%ebp),%esi
  801867:	72 cc                	jb     801835 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801869:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80186c:	5b                   	pop    %ebx
  80186d:	5e                   	pop    %esi
  80186e:	5f                   	pop    %edi
  80186f:	5d                   	pop    %ebp
  801870:	c3                   	ret    

00801871 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	83 ec 08             	sub    $0x8,%esp
  801877:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  80187c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801880:	74 2a                	je     8018ac <devcons_read+0x3b>
  801882:	eb 05                	jmp    801889 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801884:	e8 a1 f2 ff ff       	call   800b2a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801889:	e8 32 f2 ff ff       	call   800ac0 <sys_cgetc>
  80188e:	85 c0                	test   %eax,%eax
  801890:	74 f2                	je     801884 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801892:	85 c0                	test   %eax,%eax
  801894:	78 16                	js     8018ac <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801896:	83 f8 04             	cmp    $0x4,%eax
  801899:	74 0c                	je     8018a7 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80189b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189e:	88 02                	mov    %al,(%edx)
	return 1;
  8018a0:	b8 01 00 00 00       	mov    $0x1,%eax
  8018a5:	eb 05                	jmp    8018ac <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8018a7:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8018ba:	6a 01                	push   $0x1
  8018bc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8018bf:	50                   	push   %eax
  8018c0:	e8 d5 f1 ff ff       	call   800a9a <sys_cputs>
}
  8018c5:	83 c4 10             	add    $0x10,%esp
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <getchar>:

int
getchar(void)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8018d0:	6a 01                	push   $0x1
  8018d2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8018d5:	50                   	push   %eax
  8018d6:	6a 00                	push   $0x0
  8018d8:	e8 6d f6 ff ff       	call   800f4a <read>
	if (r < 0)
  8018dd:	83 c4 10             	add    $0x10,%esp
  8018e0:	85 c0                	test   %eax,%eax
  8018e2:	78 0f                	js     8018f3 <getchar+0x29>
		return r;
	if (r < 1)
  8018e4:	85 c0                	test   %eax,%eax
  8018e6:	7e 06                	jle    8018ee <getchar+0x24>
		return -E_EOF;
	return c;
  8018e8:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8018ec:	eb 05                	jmp    8018f3 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8018ee:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018fe:	50                   	push   %eax
  8018ff:	ff 75 08             	pushl  0x8(%ebp)
  801902:	e8 de f3 ff ff       	call   800ce5 <fd_lookup>
  801907:	83 c4 10             	add    $0x10,%esp
  80190a:	85 c0                	test   %eax,%eax
  80190c:	78 11                	js     80191f <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  80190e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801911:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801917:	39 10                	cmp    %edx,(%eax)
  801919:	0f 94 c0             	sete   %al
  80191c:	0f b6 c0             	movzbl %al,%eax
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <opencons>:

int
opencons(void)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801927:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80192a:	50                   	push   %eax
  80192b:	e8 66 f3 ff ff       	call   800c96 <fd_alloc>
  801930:	83 c4 10             	add    $0x10,%esp
		return r;
  801933:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801935:	85 c0                	test   %eax,%eax
  801937:	78 3e                	js     801977 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801939:	83 ec 04             	sub    $0x4,%esp
  80193c:	68 07 04 00 00       	push   $0x407
  801941:	ff 75 f4             	pushl  -0xc(%ebp)
  801944:	6a 00                	push   $0x0
  801946:	e8 06 f2 ff ff       	call   800b51 <sys_page_alloc>
  80194b:	83 c4 10             	add    $0x10,%esp
		return r;
  80194e:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801950:	85 c0                	test   %eax,%eax
  801952:	78 23                	js     801977 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801954:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80195a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80195f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801962:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801969:	83 ec 0c             	sub    $0xc,%esp
  80196c:	50                   	push   %eax
  80196d:	e8 fc f2 ff ff       	call   800c6e <fd2num>
  801972:	89 c2                	mov    %eax,%edx
  801974:	83 c4 10             	add    $0x10,%esp
}
  801977:	89 d0                	mov    %edx,%eax
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	56                   	push   %esi
  80197f:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801980:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801983:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801989:	e8 78 f1 ff ff       	call   800b06 <sys_getenvid>
  80198e:	83 ec 0c             	sub    $0xc,%esp
  801991:	ff 75 0c             	pushl  0xc(%ebp)
  801994:	ff 75 08             	pushl  0x8(%ebp)
  801997:	56                   	push   %esi
  801998:	50                   	push   %eax
  801999:	68 38 22 80 00       	push   $0x802238
  80199e:	e8 f3 e7 ff ff       	call   800196 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8019a3:	83 c4 18             	add    $0x18,%esp
  8019a6:	53                   	push   %ebx
  8019a7:	ff 75 10             	pushl  0x10(%ebp)
  8019aa:	e8 96 e7 ff ff       	call   800145 <vcprintf>
	cprintf("\n");
  8019af:	c7 04 24 23 22 80 00 	movl   $0x802223,(%esp)
  8019b6:	e8 db e7 ff ff       	call   800196 <cprintf>
  8019bb:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8019be:	cc                   	int3   
  8019bf:	eb fd                	jmp    8019be <_panic+0x43>

008019c1 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
  8019c4:	56                   	push   %esi
  8019c5:	53                   	push   %ebx
  8019c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8019c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  8019cf:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  8019d1:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8019d6:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  8019d9:	83 ec 0c             	sub    $0xc,%esp
  8019dc:	50                   	push   %eax
  8019dd:	e8 6a f2 ff ff       	call   800c4c <sys_ipc_recv>
	if (from_env_store)
  8019e2:	83 c4 10             	add    $0x10,%esp
  8019e5:	85 f6                	test   %esi,%esi
  8019e7:	74 0b                	je     8019f4 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  8019e9:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019ef:	8b 52 74             	mov    0x74(%edx),%edx
  8019f2:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8019f4:	85 db                	test   %ebx,%ebx
  8019f6:	74 0b                	je     801a03 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  8019f8:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019fe:	8b 52 78             	mov    0x78(%edx),%edx
  801a01:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  801a03:	85 c0                	test   %eax,%eax
  801a05:	79 16                	jns    801a1d <ipc_recv+0x5c>
		if (from_env_store)
  801a07:	85 f6                	test   %esi,%esi
  801a09:	74 06                	je     801a11 <ipc_recv+0x50>
			*from_env_store = 0;
  801a0b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  801a11:	85 db                	test   %ebx,%ebx
  801a13:	74 10                	je     801a25 <ipc_recv+0x64>
			*perm_store = 0;
  801a15:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801a1b:	eb 08                	jmp    801a25 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  801a1d:	a1 04 40 80 00       	mov    0x804004,%eax
  801a22:	8b 40 70             	mov    0x70(%eax),%eax
}
  801a25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a28:	5b                   	pop    %ebx
  801a29:	5e                   	pop    %esi
  801a2a:	5d                   	pop    %ebp
  801a2b:	c3                   	ret    

00801a2c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	57                   	push   %edi
  801a30:	56                   	push   %esi
  801a31:	53                   	push   %ebx
  801a32:	83 ec 0c             	sub    $0xc,%esp
  801a35:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a38:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a3b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  801a3e:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  801a40:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801a45:	0f 44 d8             	cmove  %eax,%ebx
  801a48:	eb 1c                	jmp    801a66 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  801a4a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801a4d:	74 12                	je     801a61 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801a4f:	50                   	push   %eax
  801a50:	68 5c 22 80 00       	push   $0x80225c
  801a55:	6a 42                	push   $0x42
  801a57:	68 72 22 80 00       	push   $0x802272
  801a5c:	e8 1a ff ff ff       	call   80197b <_panic>
		sys_yield();
  801a61:	e8 c4 f0 ff ff       	call   800b2a <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801a66:	ff 75 14             	pushl  0x14(%ebp)
  801a69:	53                   	push   %ebx
  801a6a:	56                   	push   %esi
  801a6b:	57                   	push   %edi
  801a6c:	e8 b6 f1 ff ff       	call   800c27 <sys_ipc_try_send>
  801a71:	83 c4 10             	add    $0x10,%esp
  801a74:	85 c0                	test   %eax,%eax
  801a76:	75 d2                	jne    801a4a <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801a78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a7b:	5b                   	pop    %ebx
  801a7c:	5e                   	pop    %esi
  801a7d:	5f                   	pop    %edi
  801a7e:	5d                   	pop    %ebp
  801a7f:	c3                   	ret    

00801a80 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801a86:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801a8b:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801a8e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801a94:	8b 52 50             	mov    0x50(%edx),%edx
  801a97:	39 ca                	cmp    %ecx,%edx
  801a99:	75 0d                	jne    801aa8 <ipc_find_env+0x28>
			return envs[i].env_id;
  801a9b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a9e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801aa3:	8b 40 48             	mov    0x48(%eax),%eax
  801aa6:	eb 0f                	jmp    801ab7 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801aa8:	83 c0 01             	add    $0x1,%eax
  801aab:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ab0:	75 d9                	jne    801a8b <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801ab2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab7:	5d                   	pop    %ebp
  801ab8:	c3                   	ret    

00801ab9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801abf:	89 d0                	mov    %edx,%eax
  801ac1:	c1 e8 16             	shr    $0x16,%eax
  801ac4:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801acb:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ad0:	f6 c1 01             	test   $0x1,%cl
  801ad3:	74 1d                	je     801af2 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801ad5:	c1 ea 0c             	shr    $0xc,%edx
  801ad8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801adf:	f6 c2 01             	test   $0x1,%dl
  801ae2:	74 0e                	je     801af2 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ae4:	c1 ea 0c             	shr    $0xc,%edx
  801ae7:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801aee:	ef 
  801aef:	0f b7 c0             	movzwl %ax,%eax
}
  801af2:	5d                   	pop    %ebp
  801af3:	c3                   	ret    
  801af4:	66 90                	xchg   %ax,%ax
  801af6:	66 90                	xchg   %ax,%ax
  801af8:	66 90                	xchg   %ax,%ax
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
