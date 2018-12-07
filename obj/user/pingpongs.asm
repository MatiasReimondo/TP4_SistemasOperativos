
obj/user/pingpongs.debug:     formato del fichero elf32-i386


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
  80002c:	e8 cd 00 00 00       	call   8000fe <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  80003c:	e8 29 11 00 00       	call   80116a <sfork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	74 42                	je     80008a <umain+0x57>
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  800048:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  80004e:	e8 12 0b 00 00       	call   800b65 <sys_getenvid>
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	53                   	push   %ebx
  800057:	50                   	push   %eax
  800058:	68 40 23 80 00       	push   $0x802340
  80005d:	e8 93 01 00 00       	call   8001f5 <cprintf>
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800062:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800065:	e8 fb 0a 00 00       	call   800b65 <sys_getenvid>
  80006a:	83 c4 0c             	add    $0xc,%esp
  80006d:	53                   	push   %ebx
  80006e:	50                   	push   %eax
  80006f:	68 5a 23 80 00       	push   $0x80235a
  800074:	e8 7c 01 00 00       	call   8001f5 <cprintf>
		ipc_send(who, 0, 0, 0);
  800079:	6a 00                	push   $0x0
  80007b:	6a 00                	push   $0x0
  80007d:	6a 00                	push   $0x0
  80007f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800082:	e8 68 11 00 00       	call   8011ef <ipc_send>
  800087:	83 c4 20             	add    $0x20,%esp
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	6a 00                	push   $0x0
  80008f:	6a 00                	push   $0x0
  800091:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800094:	50                   	push   %eax
  800095:	e8 ea 10 00 00       	call   801184 <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  80009a:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  8000a0:	8b 7b 48             	mov    0x48(%ebx),%edi
  8000a3:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8000a6:	a1 04 40 80 00       	mov    0x804004,%eax
  8000ab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8000ae:	e8 b2 0a 00 00       	call   800b65 <sys_getenvid>
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	57                   	push   %edi
  8000b7:	53                   	push   %ebx
  8000b8:	56                   	push   %esi
  8000b9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8000bc:	50                   	push   %eax
  8000bd:	68 70 23 80 00       	push   $0x802370
  8000c2:	e8 2e 01 00 00       	call   8001f5 <cprintf>
		if (val == 10)
  8000c7:	a1 04 40 80 00       	mov    0x804004,%eax
  8000cc:	83 c4 20             	add    $0x20,%esp
  8000cf:	83 f8 0a             	cmp    $0xa,%eax
  8000d2:	74 22                	je     8000f6 <umain+0xc3>
			return;
		++val;
  8000d4:	83 c0 01             	add    $0x1,%eax
  8000d7:	a3 04 40 80 00       	mov    %eax,0x804004
		ipc_send(who, 0, 0, 0);
  8000dc:	6a 00                	push   $0x0
  8000de:	6a 00                	push   $0x0
  8000e0:	6a 00                	push   $0x0
  8000e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e5:	e8 05 11 00 00       	call   8011ef <ipc_send>
		if (val == 10)
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	83 3d 04 40 80 00 0a 	cmpl   $0xa,0x804004
  8000f4:	75 94                	jne    80008a <umain+0x57>
			return;
	}

}
  8000f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f9:	5b                   	pop    %ebx
  8000fa:	5e                   	pop    %esi
  8000fb:	5f                   	pop    %edi
  8000fc:	5d                   	pop    %ebp
  8000fd:	c3                   	ret    

008000fe <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000fe:	55                   	push   %ebp
  8000ff:	89 e5                	mov    %esp,%ebp
  800101:	56                   	push   %esi
  800102:	53                   	push   %ebx
  800103:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800106:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800109:	e8 57 0a 00 00       	call   800b65 <sys_getenvid>
	if (id >= 0)
  80010e:	85 c0                	test   %eax,%eax
  800110:	78 12                	js     800124 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  800112:	25 ff 03 00 00       	and    $0x3ff,%eax
  800117:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80011a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011f:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800124:	85 db                	test   %ebx,%ebx
  800126:	7e 07                	jle    80012f <libmain+0x31>
		binaryname = argv[0];
  800128:	8b 06                	mov    (%esi),%eax
  80012a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80012f:	83 ec 08             	sub    $0x8,%esp
  800132:	56                   	push   %esi
  800133:	53                   	push   %ebx
  800134:	e8 fa fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800139:	e8 0a 00 00 00       	call   800148 <exit>
}
  80013e:	83 c4 10             	add    $0x10,%esp
  800141:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800144:	5b                   	pop    %ebx
  800145:	5e                   	pop    %esi
  800146:	5d                   	pop    %ebp
  800147:	c3                   	ret    

00800148 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80014e:	e8 f4 12 00 00       	call   801447 <close_all>
	sys_env_destroy(0);
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	6a 00                	push   $0x0
  800158:	e8 e6 09 00 00       	call   800b43 <sys_env_destroy>
}
  80015d:	83 c4 10             	add    $0x10,%esp
  800160:	c9                   	leave  
  800161:	c3                   	ret    

00800162 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800162:	55                   	push   %ebp
  800163:	89 e5                	mov    %esp,%ebp
  800165:	53                   	push   %ebx
  800166:	83 ec 04             	sub    $0x4,%esp
  800169:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80016c:	8b 13                	mov    (%ebx),%edx
  80016e:	8d 42 01             	lea    0x1(%edx),%eax
  800171:	89 03                	mov    %eax,(%ebx)
  800173:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800176:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80017a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80017f:	75 1a                	jne    80019b <putch+0x39>
		sys_cputs(b->buf, b->idx);
  800181:	83 ec 08             	sub    $0x8,%esp
  800184:	68 ff 00 00 00       	push   $0xff
  800189:	8d 43 08             	lea    0x8(%ebx),%eax
  80018c:	50                   	push   %eax
  80018d:	e8 67 09 00 00       	call   800af9 <sys_cputs>
		b->idx = 0;
  800192:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800198:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  80019b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80019f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001a2:	c9                   	leave  
  8001a3:	c3                   	ret    

008001a4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001a4:	55                   	push   %ebp
  8001a5:	89 e5                	mov    %esp,%ebp
  8001a7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001ad:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b4:	00 00 00 
	b.cnt = 0;
  8001b7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001be:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001c1:	ff 75 0c             	pushl  0xc(%ebp)
  8001c4:	ff 75 08             	pushl  0x8(%ebp)
  8001c7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001cd:	50                   	push   %eax
  8001ce:	68 62 01 80 00       	push   $0x800162
  8001d3:	e8 86 01 00 00       	call   80035e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d8:	83 c4 08             	add    $0x8,%esp
  8001db:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001e1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e7:	50                   	push   %eax
  8001e8:	e8 0c 09 00 00       	call   800af9 <sys_cputs>

	return b.cnt;
}
  8001ed:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f3:	c9                   	leave  
  8001f4:	c3                   	ret    

008001f5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f5:	55                   	push   %ebp
  8001f6:	89 e5                	mov    %esp,%ebp
  8001f8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001fb:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001fe:	50                   	push   %eax
  8001ff:	ff 75 08             	pushl  0x8(%ebp)
  800202:	e8 9d ff ff ff       	call   8001a4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800207:	c9                   	leave  
  800208:	c3                   	ret    

00800209 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800209:	55                   	push   %ebp
  80020a:	89 e5                	mov    %esp,%ebp
  80020c:	57                   	push   %edi
  80020d:	56                   	push   %esi
  80020e:	53                   	push   %ebx
  80020f:	83 ec 1c             	sub    $0x1c,%esp
  800212:	89 c7                	mov    %eax,%edi
  800214:	89 d6                	mov    %edx,%esi
  800216:	8b 45 08             	mov    0x8(%ebp),%eax
  800219:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80021f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800222:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800225:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80022d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800230:	39 d3                	cmp    %edx,%ebx
  800232:	72 05                	jb     800239 <printnum+0x30>
  800234:	39 45 10             	cmp    %eax,0x10(%ebp)
  800237:	77 45                	ja     80027e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800239:	83 ec 0c             	sub    $0xc,%esp
  80023c:	ff 75 18             	pushl  0x18(%ebp)
  80023f:	8b 45 14             	mov    0x14(%ebp),%eax
  800242:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800245:	53                   	push   %ebx
  800246:	ff 75 10             	pushl  0x10(%ebp)
  800249:	83 ec 08             	sub    $0x8,%esp
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	ff 75 e0             	pushl  -0x20(%ebp)
  800252:	ff 75 dc             	pushl  -0x24(%ebp)
  800255:	ff 75 d8             	pushl  -0x28(%ebp)
  800258:	e8 43 1e 00 00       	call   8020a0 <__udivdi3>
  80025d:	83 c4 18             	add    $0x18,%esp
  800260:	52                   	push   %edx
  800261:	50                   	push   %eax
  800262:	89 f2                	mov    %esi,%edx
  800264:	89 f8                	mov    %edi,%eax
  800266:	e8 9e ff ff ff       	call   800209 <printnum>
  80026b:	83 c4 20             	add    $0x20,%esp
  80026e:	eb 18                	jmp    800288 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800270:	83 ec 08             	sub    $0x8,%esp
  800273:	56                   	push   %esi
  800274:	ff 75 18             	pushl  0x18(%ebp)
  800277:	ff d7                	call   *%edi
  800279:	83 c4 10             	add    $0x10,%esp
  80027c:	eb 03                	jmp    800281 <printnum+0x78>
  80027e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800281:	83 eb 01             	sub    $0x1,%ebx
  800284:	85 db                	test   %ebx,%ebx
  800286:	7f e8                	jg     800270 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800288:	83 ec 08             	sub    $0x8,%esp
  80028b:	56                   	push   %esi
  80028c:	83 ec 04             	sub    $0x4,%esp
  80028f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800292:	ff 75 e0             	pushl  -0x20(%ebp)
  800295:	ff 75 dc             	pushl  -0x24(%ebp)
  800298:	ff 75 d8             	pushl  -0x28(%ebp)
  80029b:	e8 30 1f 00 00       	call   8021d0 <__umoddi3>
  8002a0:	83 c4 14             	add    $0x14,%esp
  8002a3:	0f be 80 a0 23 80 00 	movsbl 0x8023a0(%eax),%eax
  8002aa:	50                   	push   %eax
  8002ab:	ff d7                	call   *%edi
}
  8002ad:	83 c4 10             	add    $0x10,%esp
  8002b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b3:	5b                   	pop    %ebx
  8002b4:	5e                   	pop    %esi
  8002b5:	5f                   	pop    %edi
  8002b6:	5d                   	pop    %ebp
  8002b7:	c3                   	ret    

008002b8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002b8:	55                   	push   %ebp
  8002b9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002bb:	83 fa 01             	cmp    $0x1,%edx
  8002be:	7e 0e                	jle    8002ce <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002c0:	8b 10                	mov    (%eax),%edx
  8002c2:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002c5:	89 08                	mov    %ecx,(%eax)
  8002c7:	8b 02                	mov    (%edx),%eax
  8002c9:	8b 52 04             	mov    0x4(%edx),%edx
  8002cc:	eb 22                	jmp    8002f0 <getuint+0x38>
	else if (lflag)
  8002ce:	85 d2                	test   %edx,%edx
  8002d0:	74 10                	je     8002e2 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002d2:	8b 10                	mov    (%eax),%edx
  8002d4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002d7:	89 08                	mov    %ecx,(%eax)
  8002d9:	8b 02                	mov    (%edx),%eax
  8002db:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e0:	eb 0e                	jmp    8002f0 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002e2:	8b 10                	mov    (%eax),%edx
  8002e4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002e7:	89 08                	mov    %ecx,(%eax)
  8002e9:	8b 02                	mov    (%edx),%eax
  8002eb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002f0:	5d                   	pop    %ebp
  8002f1:	c3                   	ret    

008002f2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8002f2:	55                   	push   %ebp
  8002f3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002f5:	83 fa 01             	cmp    $0x1,%edx
  8002f8:	7e 0e                	jle    800308 <getint+0x16>
		return va_arg(*ap, long long);
  8002fa:	8b 10                	mov    (%eax),%edx
  8002fc:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002ff:	89 08                	mov    %ecx,(%eax)
  800301:	8b 02                	mov    (%edx),%eax
  800303:	8b 52 04             	mov    0x4(%edx),%edx
  800306:	eb 1a                	jmp    800322 <getint+0x30>
	else if (lflag)
  800308:	85 d2                	test   %edx,%edx
  80030a:	74 0c                	je     800318 <getint+0x26>
		return va_arg(*ap, long);
  80030c:	8b 10                	mov    (%eax),%edx
  80030e:	8d 4a 04             	lea    0x4(%edx),%ecx
  800311:	89 08                	mov    %ecx,(%eax)
  800313:	8b 02                	mov    (%edx),%eax
  800315:	99                   	cltd   
  800316:	eb 0a                	jmp    800322 <getint+0x30>
	else
		return va_arg(*ap, int);
  800318:	8b 10                	mov    (%eax),%edx
  80031a:	8d 4a 04             	lea    0x4(%edx),%ecx
  80031d:	89 08                	mov    %ecx,(%eax)
  80031f:	8b 02                	mov    (%edx),%eax
  800321:	99                   	cltd   
}
  800322:	5d                   	pop    %ebp
  800323:	c3                   	ret    

00800324 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800324:	55                   	push   %ebp
  800325:	89 e5                	mov    %esp,%ebp
  800327:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80032a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80032e:	8b 10                	mov    (%eax),%edx
  800330:	3b 50 04             	cmp    0x4(%eax),%edx
  800333:	73 0a                	jae    80033f <sprintputch+0x1b>
		*b->buf++ = ch;
  800335:	8d 4a 01             	lea    0x1(%edx),%ecx
  800338:	89 08                	mov    %ecx,(%eax)
  80033a:	8b 45 08             	mov    0x8(%ebp),%eax
  80033d:	88 02                	mov    %al,(%edx)
}
  80033f:	5d                   	pop    %ebp
  800340:	c3                   	ret    

00800341 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800341:	55                   	push   %ebp
  800342:	89 e5                	mov    %esp,%ebp
  800344:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800347:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80034a:	50                   	push   %eax
  80034b:	ff 75 10             	pushl  0x10(%ebp)
  80034e:	ff 75 0c             	pushl  0xc(%ebp)
  800351:	ff 75 08             	pushl  0x8(%ebp)
  800354:	e8 05 00 00 00       	call   80035e <vprintfmt>
	va_end(ap);
}
  800359:	83 c4 10             	add    $0x10,%esp
  80035c:	c9                   	leave  
  80035d:	c3                   	ret    

0080035e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80035e:	55                   	push   %ebp
  80035f:	89 e5                	mov    %esp,%ebp
  800361:	57                   	push   %edi
  800362:	56                   	push   %esi
  800363:	53                   	push   %ebx
  800364:	83 ec 2c             	sub    $0x2c,%esp
  800367:	8b 75 08             	mov    0x8(%ebp),%esi
  80036a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80036d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800370:	eb 12                	jmp    800384 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800372:	85 c0                	test   %eax,%eax
  800374:	0f 84 44 03 00 00    	je     8006be <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  80037a:	83 ec 08             	sub    $0x8,%esp
  80037d:	53                   	push   %ebx
  80037e:	50                   	push   %eax
  80037f:	ff d6                	call   *%esi
  800381:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800384:	83 c7 01             	add    $0x1,%edi
  800387:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80038b:	83 f8 25             	cmp    $0x25,%eax
  80038e:	75 e2                	jne    800372 <vprintfmt+0x14>
  800390:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800394:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80039b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003a2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8003a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ae:	eb 07                	jmp    8003b7 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003b3:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003b7:	8d 47 01             	lea    0x1(%edi),%eax
  8003ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003bd:	0f b6 07             	movzbl (%edi),%eax
  8003c0:	0f b6 c8             	movzbl %al,%ecx
  8003c3:	83 e8 23             	sub    $0x23,%eax
  8003c6:	3c 55                	cmp    $0x55,%al
  8003c8:	0f 87 d5 02 00 00    	ja     8006a3 <vprintfmt+0x345>
  8003ce:	0f b6 c0             	movzbl %al,%eax
  8003d1:	ff 24 85 e0 24 80 00 	jmp    *0x8024e0(,%eax,4)
  8003d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003db:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003df:	eb d6                	jmp    8003b7 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003ec:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003ef:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8003f3:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8003f6:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8003f9:	83 fa 09             	cmp    $0x9,%edx
  8003fc:	77 39                	ja     800437 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003fe:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800401:	eb e9                	jmp    8003ec <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800403:	8b 45 14             	mov    0x14(%ebp),%eax
  800406:	8d 48 04             	lea    0x4(%eax),%ecx
  800409:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80040c:	8b 00                	mov    (%eax),%eax
  80040e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800411:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800414:	eb 27                	jmp    80043d <vprintfmt+0xdf>
  800416:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800419:	85 c0                	test   %eax,%eax
  80041b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800420:	0f 49 c8             	cmovns %eax,%ecx
  800423:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800426:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800429:	eb 8c                	jmp    8003b7 <vprintfmt+0x59>
  80042b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80042e:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800435:	eb 80                	jmp    8003b7 <vprintfmt+0x59>
  800437:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80043a:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  80043d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800441:	0f 89 70 ff ff ff    	jns    8003b7 <vprintfmt+0x59>
				width = precision, precision = -1;
  800447:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80044a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80044d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800454:	e9 5e ff ff ff       	jmp    8003b7 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800459:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80045c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80045f:	e9 53 ff ff ff       	jmp    8003b7 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	8d 50 04             	lea    0x4(%eax),%edx
  80046a:	89 55 14             	mov    %edx,0x14(%ebp)
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	53                   	push   %ebx
  800471:	ff 30                	pushl  (%eax)
  800473:	ff d6                	call   *%esi
			break;
  800475:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800478:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  80047b:	e9 04 ff ff ff       	jmp    800384 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800480:	8b 45 14             	mov    0x14(%ebp),%eax
  800483:	8d 50 04             	lea    0x4(%eax),%edx
  800486:	89 55 14             	mov    %edx,0x14(%ebp)
  800489:	8b 00                	mov    (%eax),%eax
  80048b:	99                   	cltd   
  80048c:	31 d0                	xor    %edx,%eax
  80048e:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800490:	83 f8 0f             	cmp    $0xf,%eax
  800493:	7f 0b                	jg     8004a0 <vprintfmt+0x142>
  800495:	8b 14 85 40 26 80 00 	mov    0x802640(,%eax,4),%edx
  80049c:	85 d2                	test   %edx,%edx
  80049e:	75 18                	jne    8004b8 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  8004a0:	50                   	push   %eax
  8004a1:	68 b8 23 80 00       	push   $0x8023b8
  8004a6:	53                   	push   %ebx
  8004a7:	56                   	push   %esi
  8004a8:	e8 94 fe ff ff       	call   800341 <printfmt>
  8004ad:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8004b3:	e9 cc fe ff ff       	jmp    800384 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  8004b8:	52                   	push   %edx
  8004b9:	68 f5 28 80 00       	push   $0x8028f5
  8004be:	53                   	push   %ebx
  8004bf:	56                   	push   %esi
  8004c0:	e8 7c fe ff ff       	call   800341 <printfmt>
  8004c5:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004cb:	e9 b4 fe ff ff       	jmp    800384 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d3:	8d 50 04             	lea    0x4(%eax),%edx
  8004d6:	89 55 14             	mov    %edx,0x14(%ebp)
  8004d9:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004db:	85 ff                	test   %edi,%edi
  8004dd:	b8 b1 23 80 00       	mov    $0x8023b1,%eax
  8004e2:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004e9:	0f 8e 94 00 00 00    	jle    800583 <vprintfmt+0x225>
  8004ef:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004f3:	0f 84 98 00 00 00    	je     800591 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f9:	83 ec 08             	sub    $0x8,%esp
  8004fc:	ff 75 d0             	pushl  -0x30(%ebp)
  8004ff:	57                   	push   %edi
  800500:	e8 41 02 00 00       	call   800746 <strnlen>
  800505:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800508:	29 c1                	sub    %eax,%ecx
  80050a:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80050d:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800510:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800514:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800517:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80051a:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80051c:	eb 0f                	jmp    80052d <vprintfmt+0x1cf>
					putch(padc, putdat);
  80051e:	83 ec 08             	sub    $0x8,%esp
  800521:	53                   	push   %ebx
  800522:	ff 75 e0             	pushl  -0x20(%ebp)
  800525:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800527:	83 ef 01             	sub    $0x1,%edi
  80052a:	83 c4 10             	add    $0x10,%esp
  80052d:	85 ff                	test   %edi,%edi
  80052f:	7f ed                	jg     80051e <vprintfmt+0x1c0>
  800531:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800534:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800537:	85 c9                	test   %ecx,%ecx
  800539:	b8 00 00 00 00       	mov    $0x0,%eax
  80053e:	0f 49 c1             	cmovns %ecx,%eax
  800541:	29 c1                	sub    %eax,%ecx
  800543:	89 75 08             	mov    %esi,0x8(%ebp)
  800546:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800549:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80054c:	89 cb                	mov    %ecx,%ebx
  80054e:	eb 4d                	jmp    80059d <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800550:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800554:	74 1b                	je     800571 <vprintfmt+0x213>
  800556:	0f be c0             	movsbl %al,%eax
  800559:	83 e8 20             	sub    $0x20,%eax
  80055c:	83 f8 5e             	cmp    $0x5e,%eax
  80055f:	76 10                	jbe    800571 <vprintfmt+0x213>
					putch('?', putdat);
  800561:	83 ec 08             	sub    $0x8,%esp
  800564:	ff 75 0c             	pushl  0xc(%ebp)
  800567:	6a 3f                	push   $0x3f
  800569:	ff 55 08             	call   *0x8(%ebp)
  80056c:	83 c4 10             	add    $0x10,%esp
  80056f:	eb 0d                	jmp    80057e <vprintfmt+0x220>
				else
					putch(ch, putdat);
  800571:	83 ec 08             	sub    $0x8,%esp
  800574:	ff 75 0c             	pushl  0xc(%ebp)
  800577:	52                   	push   %edx
  800578:	ff 55 08             	call   *0x8(%ebp)
  80057b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80057e:	83 eb 01             	sub    $0x1,%ebx
  800581:	eb 1a                	jmp    80059d <vprintfmt+0x23f>
  800583:	89 75 08             	mov    %esi,0x8(%ebp)
  800586:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800589:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80058c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80058f:	eb 0c                	jmp    80059d <vprintfmt+0x23f>
  800591:	89 75 08             	mov    %esi,0x8(%ebp)
  800594:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800597:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80059a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80059d:	83 c7 01             	add    $0x1,%edi
  8005a0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005a4:	0f be d0             	movsbl %al,%edx
  8005a7:	85 d2                	test   %edx,%edx
  8005a9:	74 23                	je     8005ce <vprintfmt+0x270>
  8005ab:	85 f6                	test   %esi,%esi
  8005ad:	78 a1                	js     800550 <vprintfmt+0x1f2>
  8005af:	83 ee 01             	sub    $0x1,%esi
  8005b2:	79 9c                	jns    800550 <vprintfmt+0x1f2>
  8005b4:	89 df                	mov    %ebx,%edi
  8005b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8005b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005bc:	eb 18                	jmp    8005d6 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005be:	83 ec 08             	sub    $0x8,%esp
  8005c1:	53                   	push   %ebx
  8005c2:	6a 20                	push   $0x20
  8005c4:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005c6:	83 ef 01             	sub    $0x1,%edi
  8005c9:	83 c4 10             	add    $0x10,%esp
  8005cc:	eb 08                	jmp    8005d6 <vprintfmt+0x278>
  8005ce:	89 df                	mov    %ebx,%edi
  8005d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8005d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005d6:	85 ff                	test   %edi,%edi
  8005d8:	7f e4                	jg     8005be <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005dd:	e9 a2 fd ff ff       	jmp    800384 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005e2:	8d 45 14             	lea    0x14(%ebp),%eax
  8005e5:	e8 08 fd ff ff       	call   8002f2 <getint>
  8005ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ed:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8005f0:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8005f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005f9:	79 74                	jns    80066f <vprintfmt+0x311>
				putch('-', putdat);
  8005fb:	83 ec 08             	sub    $0x8,%esp
  8005fe:	53                   	push   %ebx
  8005ff:	6a 2d                	push   $0x2d
  800601:	ff d6                	call   *%esi
				num = -(long long) num;
  800603:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800606:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800609:	f7 d8                	neg    %eax
  80060b:	83 d2 00             	adc    $0x0,%edx
  80060e:	f7 da                	neg    %edx
  800610:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  800613:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800618:	eb 55                	jmp    80066f <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80061a:	8d 45 14             	lea    0x14(%ebp),%eax
  80061d:	e8 96 fc ff ff       	call   8002b8 <getuint>
			base = 10;
  800622:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800627:	eb 46                	jmp    80066f <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800629:	8d 45 14             	lea    0x14(%ebp),%eax
  80062c:	e8 87 fc ff ff       	call   8002b8 <getuint>
			base = 8;
  800631:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800636:	eb 37                	jmp    80066f <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	53                   	push   %ebx
  80063c:	6a 30                	push   $0x30
  80063e:	ff d6                	call   *%esi
			putch('x', putdat);
  800640:	83 c4 08             	add    $0x8,%esp
  800643:	53                   	push   %ebx
  800644:	6a 78                	push   $0x78
  800646:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	8d 50 04             	lea    0x4(%eax),%edx
  80064e:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800651:	8b 00                	mov    (%eax),%eax
  800653:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800658:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80065b:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800660:	eb 0d                	jmp    80066f <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800662:	8d 45 14             	lea    0x14(%ebp),%eax
  800665:	e8 4e fc ff ff       	call   8002b8 <getuint>
			base = 16;
  80066a:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  80066f:	83 ec 0c             	sub    $0xc,%esp
  800672:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800676:	57                   	push   %edi
  800677:	ff 75 e0             	pushl  -0x20(%ebp)
  80067a:	51                   	push   %ecx
  80067b:	52                   	push   %edx
  80067c:	50                   	push   %eax
  80067d:	89 da                	mov    %ebx,%edx
  80067f:	89 f0                	mov    %esi,%eax
  800681:	e8 83 fb ff ff       	call   800209 <printnum>
			break;
  800686:	83 c4 20             	add    $0x20,%esp
  800689:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80068c:	e9 f3 fc ff ff       	jmp    800384 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800691:	83 ec 08             	sub    $0x8,%esp
  800694:	53                   	push   %ebx
  800695:	51                   	push   %ecx
  800696:	ff d6                	call   *%esi
			break;
  800698:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80069b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  80069e:	e9 e1 fc ff ff       	jmp    800384 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006a3:	83 ec 08             	sub    $0x8,%esp
  8006a6:	53                   	push   %ebx
  8006a7:	6a 25                	push   $0x25
  8006a9:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006ab:	83 c4 10             	add    $0x10,%esp
  8006ae:	eb 03                	jmp    8006b3 <vprintfmt+0x355>
  8006b0:	83 ef 01             	sub    $0x1,%edi
  8006b3:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  8006b7:	75 f7                	jne    8006b0 <vprintfmt+0x352>
  8006b9:	e9 c6 fc ff ff       	jmp    800384 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  8006be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006c1:	5b                   	pop    %ebx
  8006c2:	5e                   	pop    %esi
  8006c3:	5f                   	pop    %edi
  8006c4:	5d                   	pop    %ebp
  8006c5:	c3                   	ret    

008006c6 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006c6:	55                   	push   %ebp
  8006c7:	89 e5                	mov    %esp,%ebp
  8006c9:	83 ec 18             	sub    $0x18,%esp
  8006cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cf:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006d5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006d9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006e3:	85 c0                	test   %eax,%eax
  8006e5:	74 26                	je     80070d <vsnprintf+0x47>
  8006e7:	85 d2                	test   %edx,%edx
  8006e9:	7e 22                	jle    80070d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006eb:	ff 75 14             	pushl  0x14(%ebp)
  8006ee:	ff 75 10             	pushl  0x10(%ebp)
  8006f1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006f4:	50                   	push   %eax
  8006f5:	68 24 03 80 00       	push   $0x800324
  8006fa:	e8 5f fc ff ff       	call   80035e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800702:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800708:	83 c4 10             	add    $0x10,%esp
  80070b:	eb 05                	jmp    800712 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80070d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800712:	c9                   	leave  
  800713:	c3                   	ret    

00800714 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800714:	55                   	push   %ebp
  800715:	89 e5                	mov    %esp,%ebp
  800717:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80071a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80071d:	50                   	push   %eax
  80071e:	ff 75 10             	pushl  0x10(%ebp)
  800721:	ff 75 0c             	pushl  0xc(%ebp)
  800724:	ff 75 08             	pushl  0x8(%ebp)
  800727:	e8 9a ff ff ff       	call   8006c6 <vsnprintf>
	va_end(ap);

	return rc;
}
  80072c:	c9                   	leave  
  80072d:	c3                   	ret    

0080072e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80072e:	55                   	push   %ebp
  80072f:	89 e5                	mov    %esp,%ebp
  800731:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800734:	b8 00 00 00 00       	mov    $0x0,%eax
  800739:	eb 03                	jmp    80073e <strlen+0x10>
		n++;
  80073b:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80073e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800742:	75 f7                	jne    80073b <strlen+0xd>
		n++;
	return n;
}
  800744:	5d                   	pop    %ebp
  800745:	c3                   	ret    

00800746 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
  800749:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80074c:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80074f:	ba 00 00 00 00       	mov    $0x0,%edx
  800754:	eb 03                	jmp    800759 <strnlen+0x13>
		n++;
  800756:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800759:	39 c2                	cmp    %eax,%edx
  80075b:	74 08                	je     800765 <strnlen+0x1f>
  80075d:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800761:	75 f3                	jne    800756 <strnlen+0x10>
  800763:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  800765:	5d                   	pop    %ebp
  800766:	c3                   	ret    

00800767 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800767:	55                   	push   %ebp
  800768:	89 e5                	mov    %esp,%ebp
  80076a:	53                   	push   %ebx
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800771:	89 c2                	mov    %eax,%edx
  800773:	83 c2 01             	add    $0x1,%edx
  800776:	83 c1 01             	add    $0x1,%ecx
  800779:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80077d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800780:	84 db                	test   %bl,%bl
  800782:	75 ef                	jne    800773 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800784:	5b                   	pop    %ebx
  800785:	5d                   	pop    %ebp
  800786:	c3                   	ret    

00800787 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800787:	55                   	push   %ebp
  800788:	89 e5                	mov    %esp,%ebp
  80078a:	53                   	push   %ebx
  80078b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80078e:	53                   	push   %ebx
  80078f:	e8 9a ff ff ff       	call   80072e <strlen>
  800794:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800797:	ff 75 0c             	pushl  0xc(%ebp)
  80079a:	01 d8                	add    %ebx,%eax
  80079c:	50                   	push   %eax
  80079d:	e8 c5 ff ff ff       	call   800767 <strcpy>
	return dst;
}
  8007a2:	89 d8                	mov    %ebx,%eax
  8007a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007a7:	c9                   	leave  
  8007a8:	c3                   	ret    

008007a9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007a9:	55                   	push   %ebp
  8007aa:	89 e5                	mov    %esp,%ebp
  8007ac:	56                   	push   %esi
  8007ad:	53                   	push   %ebx
  8007ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8007b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007b4:	89 f3                	mov    %esi,%ebx
  8007b6:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007b9:	89 f2                	mov    %esi,%edx
  8007bb:	eb 0f                	jmp    8007cc <strncpy+0x23>
		*dst++ = *src;
  8007bd:	83 c2 01             	add    $0x1,%edx
  8007c0:	0f b6 01             	movzbl (%ecx),%eax
  8007c3:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007c6:	80 39 01             	cmpb   $0x1,(%ecx)
  8007c9:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007cc:	39 da                	cmp    %ebx,%edx
  8007ce:	75 ed                	jne    8007bd <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8007d0:	89 f0                	mov    %esi,%eax
  8007d2:	5b                   	pop    %ebx
  8007d3:	5e                   	pop    %esi
  8007d4:	5d                   	pop    %ebp
  8007d5:	c3                   	ret    

008007d6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007d6:	55                   	push   %ebp
  8007d7:	89 e5                	mov    %esp,%ebp
  8007d9:	56                   	push   %esi
  8007da:	53                   	push   %ebx
  8007db:	8b 75 08             	mov    0x8(%ebp),%esi
  8007de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007e1:	8b 55 10             	mov    0x10(%ebp),%edx
  8007e4:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007e6:	85 d2                	test   %edx,%edx
  8007e8:	74 21                	je     80080b <strlcpy+0x35>
  8007ea:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8007ee:	89 f2                	mov    %esi,%edx
  8007f0:	eb 09                	jmp    8007fb <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8007f2:	83 c2 01             	add    $0x1,%edx
  8007f5:	83 c1 01             	add    $0x1,%ecx
  8007f8:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8007fb:	39 c2                	cmp    %eax,%edx
  8007fd:	74 09                	je     800808 <strlcpy+0x32>
  8007ff:	0f b6 19             	movzbl (%ecx),%ebx
  800802:	84 db                	test   %bl,%bl
  800804:	75 ec                	jne    8007f2 <strlcpy+0x1c>
  800806:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  800808:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80080b:	29 f0                	sub    %esi,%eax
}
  80080d:	5b                   	pop    %ebx
  80080e:	5e                   	pop    %esi
  80080f:	5d                   	pop    %ebp
  800810:	c3                   	ret    

00800811 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800811:	55                   	push   %ebp
  800812:	89 e5                	mov    %esp,%ebp
  800814:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800817:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80081a:	eb 06                	jmp    800822 <strcmp+0x11>
		p++, q++;
  80081c:	83 c1 01             	add    $0x1,%ecx
  80081f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800822:	0f b6 01             	movzbl (%ecx),%eax
  800825:	84 c0                	test   %al,%al
  800827:	74 04                	je     80082d <strcmp+0x1c>
  800829:	3a 02                	cmp    (%edx),%al
  80082b:	74 ef                	je     80081c <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80082d:	0f b6 c0             	movzbl %al,%eax
  800830:	0f b6 12             	movzbl (%edx),%edx
  800833:	29 d0                	sub    %edx,%eax
}
  800835:	5d                   	pop    %ebp
  800836:	c3                   	ret    

00800837 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800837:	55                   	push   %ebp
  800838:	89 e5                	mov    %esp,%ebp
  80083a:	53                   	push   %ebx
  80083b:	8b 45 08             	mov    0x8(%ebp),%eax
  80083e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800841:	89 c3                	mov    %eax,%ebx
  800843:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800846:	eb 06                	jmp    80084e <strncmp+0x17>
		n--, p++, q++;
  800848:	83 c0 01             	add    $0x1,%eax
  80084b:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80084e:	39 d8                	cmp    %ebx,%eax
  800850:	74 15                	je     800867 <strncmp+0x30>
  800852:	0f b6 08             	movzbl (%eax),%ecx
  800855:	84 c9                	test   %cl,%cl
  800857:	74 04                	je     80085d <strncmp+0x26>
  800859:	3a 0a                	cmp    (%edx),%cl
  80085b:	74 eb                	je     800848 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80085d:	0f b6 00             	movzbl (%eax),%eax
  800860:	0f b6 12             	movzbl (%edx),%edx
  800863:	29 d0                	sub    %edx,%eax
  800865:	eb 05                	jmp    80086c <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800867:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  80086c:	5b                   	pop    %ebx
  80086d:	5d                   	pop    %ebp
  80086e:	c3                   	ret    

0080086f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800879:	eb 07                	jmp    800882 <strchr+0x13>
		if (*s == c)
  80087b:	38 ca                	cmp    %cl,%dl
  80087d:	74 0f                	je     80088e <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80087f:	83 c0 01             	add    $0x1,%eax
  800882:	0f b6 10             	movzbl (%eax),%edx
  800885:	84 d2                	test   %dl,%dl
  800887:	75 f2                	jne    80087b <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800889:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80088e:	5d                   	pop    %ebp
  80088f:	c3                   	ret    

00800890 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	8b 45 08             	mov    0x8(%ebp),%eax
  800896:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80089a:	eb 03                	jmp    80089f <strfind+0xf>
  80089c:	83 c0 01             	add    $0x1,%eax
  80089f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008a2:	38 ca                	cmp    %cl,%dl
  8008a4:	74 04                	je     8008aa <strfind+0x1a>
  8008a6:	84 d2                	test   %dl,%dl
  8008a8:	75 f2                	jne    80089c <strfind+0xc>
			break;
	return (char *) s;
}
  8008aa:	5d                   	pop    %ebp
  8008ab:	c3                   	ret    

008008ac <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008ac:	55                   	push   %ebp
  8008ad:	89 e5                	mov    %esp,%ebp
  8008af:	57                   	push   %edi
  8008b0:	56                   	push   %esi
  8008b1:	53                   	push   %ebx
  8008b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8008b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  8008b8:	85 c9                	test   %ecx,%ecx
  8008ba:	74 37                	je     8008f3 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008bc:	f6 c2 03             	test   $0x3,%dl
  8008bf:	75 2a                	jne    8008eb <memset+0x3f>
  8008c1:	f6 c1 03             	test   $0x3,%cl
  8008c4:	75 25                	jne    8008eb <memset+0x3f>
		c &= 0xFF;
  8008c6:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008ca:	89 df                	mov    %ebx,%edi
  8008cc:	c1 e7 08             	shl    $0x8,%edi
  8008cf:	89 de                	mov    %ebx,%esi
  8008d1:	c1 e6 18             	shl    $0x18,%esi
  8008d4:	89 d8                	mov    %ebx,%eax
  8008d6:	c1 e0 10             	shl    $0x10,%eax
  8008d9:	09 f0                	or     %esi,%eax
  8008db:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8008dd:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8008e0:	89 f8                	mov    %edi,%eax
  8008e2:	09 d8                	or     %ebx,%eax
  8008e4:	89 d7                	mov    %edx,%edi
  8008e6:	fc                   	cld    
  8008e7:	f3 ab                	rep stos %eax,%es:(%edi)
  8008e9:	eb 08                	jmp    8008f3 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008eb:	89 d7                	mov    %edx,%edi
  8008ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f0:	fc                   	cld    
  8008f1:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8008f3:	89 d0                	mov    %edx,%eax
  8008f5:	5b                   	pop    %ebx
  8008f6:	5e                   	pop    %esi
  8008f7:	5f                   	pop    %edi
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	57                   	push   %edi
  8008fe:	56                   	push   %esi
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	8b 75 0c             	mov    0xc(%ebp),%esi
  800905:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800908:	39 c6                	cmp    %eax,%esi
  80090a:	73 35                	jae    800941 <memmove+0x47>
  80090c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80090f:	39 d0                	cmp    %edx,%eax
  800911:	73 2e                	jae    800941 <memmove+0x47>
		s += n;
		d += n;
  800913:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800916:	89 d6                	mov    %edx,%esi
  800918:	09 fe                	or     %edi,%esi
  80091a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800920:	75 13                	jne    800935 <memmove+0x3b>
  800922:	f6 c1 03             	test   $0x3,%cl
  800925:	75 0e                	jne    800935 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  800927:	83 ef 04             	sub    $0x4,%edi
  80092a:	8d 72 fc             	lea    -0x4(%edx),%esi
  80092d:	c1 e9 02             	shr    $0x2,%ecx
  800930:	fd                   	std    
  800931:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800933:	eb 09                	jmp    80093e <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800935:	83 ef 01             	sub    $0x1,%edi
  800938:	8d 72 ff             	lea    -0x1(%edx),%esi
  80093b:	fd                   	std    
  80093c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80093e:	fc                   	cld    
  80093f:	eb 1d                	jmp    80095e <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800941:	89 f2                	mov    %esi,%edx
  800943:	09 c2                	or     %eax,%edx
  800945:	f6 c2 03             	test   $0x3,%dl
  800948:	75 0f                	jne    800959 <memmove+0x5f>
  80094a:	f6 c1 03             	test   $0x3,%cl
  80094d:	75 0a                	jne    800959 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  80094f:	c1 e9 02             	shr    $0x2,%ecx
  800952:	89 c7                	mov    %eax,%edi
  800954:	fc                   	cld    
  800955:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800957:	eb 05                	jmp    80095e <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800959:	89 c7                	mov    %eax,%edi
  80095b:	fc                   	cld    
  80095c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80095e:	5e                   	pop    %esi
  80095f:	5f                   	pop    %edi
  800960:	5d                   	pop    %ebp
  800961:	c3                   	ret    

00800962 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800965:	ff 75 10             	pushl  0x10(%ebp)
  800968:	ff 75 0c             	pushl  0xc(%ebp)
  80096b:	ff 75 08             	pushl  0x8(%ebp)
  80096e:	e8 87 ff ff ff       	call   8008fa <memmove>
}
  800973:	c9                   	leave  
  800974:	c3                   	ret    

00800975 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	56                   	push   %esi
  800979:	53                   	push   %ebx
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800980:	89 c6                	mov    %eax,%esi
  800982:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800985:	eb 1a                	jmp    8009a1 <memcmp+0x2c>
		if (*s1 != *s2)
  800987:	0f b6 08             	movzbl (%eax),%ecx
  80098a:	0f b6 1a             	movzbl (%edx),%ebx
  80098d:	38 d9                	cmp    %bl,%cl
  80098f:	74 0a                	je     80099b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800991:	0f b6 c1             	movzbl %cl,%eax
  800994:	0f b6 db             	movzbl %bl,%ebx
  800997:	29 d8                	sub    %ebx,%eax
  800999:	eb 0f                	jmp    8009aa <memcmp+0x35>
		s1++, s2++;
  80099b:	83 c0 01             	add    $0x1,%eax
  80099e:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009a1:	39 f0                	cmp    %esi,%eax
  8009a3:	75 e2                	jne    800987 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8009a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009aa:	5b                   	pop    %ebx
  8009ab:	5e                   	pop    %esi
  8009ac:	5d                   	pop    %ebp
  8009ad:	c3                   	ret    

008009ae <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	53                   	push   %ebx
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  8009b5:	89 c1                	mov    %eax,%ecx
  8009b7:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  8009ba:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8009be:	eb 0a                	jmp    8009ca <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009c0:	0f b6 10             	movzbl (%eax),%edx
  8009c3:	39 da                	cmp    %ebx,%edx
  8009c5:	74 07                	je     8009ce <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8009c7:	83 c0 01             	add    $0x1,%eax
  8009ca:	39 c8                	cmp    %ecx,%eax
  8009cc:	72 f2                	jb     8009c0 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8009ce:	5b                   	pop    %ebx
  8009cf:	5d                   	pop    %ebp
  8009d0:	c3                   	ret    

008009d1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	57                   	push   %edi
  8009d5:	56                   	push   %esi
  8009d6:	53                   	push   %ebx
  8009d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009da:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009dd:	eb 03                	jmp    8009e2 <strtol+0x11>
		s++;
  8009df:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009e2:	0f b6 01             	movzbl (%ecx),%eax
  8009e5:	3c 20                	cmp    $0x20,%al
  8009e7:	74 f6                	je     8009df <strtol+0xe>
  8009e9:	3c 09                	cmp    $0x9,%al
  8009eb:	74 f2                	je     8009df <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8009ed:	3c 2b                	cmp    $0x2b,%al
  8009ef:	75 0a                	jne    8009fb <strtol+0x2a>
		s++;
  8009f1:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8009f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8009f9:	eb 11                	jmp    800a0c <strtol+0x3b>
  8009fb:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800a00:	3c 2d                	cmp    $0x2d,%al
  800a02:	75 08                	jne    800a0c <strtol+0x3b>
		s++, neg = 1;
  800a04:	83 c1 01             	add    $0x1,%ecx
  800a07:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a0c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a12:	75 15                	jne    800a29 <strtol+0x58>
  800a14:	80 39 30             	cmpb   $0x30,(%ecx)
  800a17:	75 10                	jne    800a29 <strtol+0x58>
  800a19:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a1d:	75 7c                	jne    800a9b <strtol+0xca>
		s += 2, base = 16;
  800a1f:	83 c1 02             	add    $0x2,%ecx
  800a22:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a27:	eb 16                	jmp    800a3f <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800a29:	85 db                	test   %ebx,%ebx
  800a2b:	75 12                	jne    800a3f <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a2d:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a32:	80 39 30             	cmpb   $0x30,(%ecx)
  800a35:	75 08                	jne    800a3f <strtol+0x6e>
		s++, base = 8;
  800a37:	83 c1 01             	add    $0x1,%ecx
  800a3a:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a44:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800a47:	0f b6 11             	movzbl (%ecx),%edx
  800a4a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a4d:	89 f3                	mov    %esi,%ebx
  800a4f:	80 fb 09             	cmp    $0x9,%bl
  800a52:	77 08                	ja     800a5c <strtol+0x8b>
			dig = *s - '0';
  800a54:	0f be d2             	movsbl %dl,%edx
  800a57:	83 ea 30             	sub    $0x30,%edx
  800a5a:	eb 22                	jmp    800a7e <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800a5c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a5f:	89 f3                	mov    %esi,%ebx
  800a61:	80 fb 19             	cmp    $0x19,%bl
  800a64:	77 08                	ja     800a6e <strtol+0x9d>
			dig = *s - 'a' + 10;
  800a66:	0f be d2             	movsbl %dl,%edx
  800a69:	83 ea 57             	sub    $0x57,%edx
  800a6c:	eb 10                	jmp    800a7e <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800a6e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a71:	89 f3                	mov    %esi,%ebx
  800a73:	80 fb 19             	cmp    $0x19,%bl
  800a76:	77 16                	ja     800a8e <strtol+0xbd>
			dig = *s - 'A' + 10;
  800a78:	0f be d2             	movsbl %dl,%edx
  800a7b:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800a7e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a81:	7d 0b                	jge    800a8e <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800a83:	83 c1 01             	add    $0x1,%ecx
  800a86:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a8a:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800a8c:	eb b9                	jmp    800a47 <strtol+0x76>

	if (endptr)
  800a8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a92:	74 0d                	je     800aa1 <strtol+0xd0>
		*endptr = (char *) s;
  800a94:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a97:	89 0e                	mov    %ecx,(%esi)
  800a99:	eb 06                	jmp    800aa1 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a9b:	85 db                	test   %ebx,%ebx
  800a9d:	74 98                	je     800a37 <strtol+0x66>
  800a9f:	eb 9e                	jmp    800a3f <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800aa1:	89 c2                	mov    %eax,%edx
  800aa3:	f7 da                	neg    %edx
  800aa5:	85 ff                	test   %edi,%edi
  800aa7:	0f 45 c2             	cmovne %edx,%eax
}
  800aaa:	5b                   	pop    %ebx
  800aab:	5e                   	pop    %esi
  800aac:	5f                   	pop    %edi
  800aad:	5d                   	pop    %ebp
  800aae:	c3                   	ret    

00800aaf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	57                   	push   %edi
  800ab3:	56                   	push   %esi
  800ab4:	53                   	push   %ebx
  800ab5:	83 ec 1c             	sub    $0x1c,%esp
  800ab8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800abb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800abe:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ac0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ac6:	8b 7d 10             	mov    0x10(%ebp),%edi
  800ac9:	8b 75 14             	mov    0x14(%ebp),%esi
  800acc:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ace:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad2:	74 1d                	je     800af1 <syscall+0x42>
  800ad4:	85 c0                	test   %eax,%eax
  800ad6:	7e 19                	jle    800af1 <syscall+0x42>
  800ad8:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800adb:	83 ec 0c             	sub    $0xc,%esp
  800ade:	50                   	push   %eax
  800adf:	52                   	push   %edx
  800ae0:	68 9f 26 80 00       	push   $0x80269f
  800ae5:	6a 23                	push   $0x23
  800ae7:	68 bc 26 80 00       	push   $0x8026bc
  800aec:	e8 98 14 00 00       	call   801f89 <_panic>

	return ret;
}
  800af1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800af4:	5b                   	pop    %ebx
  800af5:	5e                   	pop    %esi
  800af6:	5f                   	pop    %edi
  800af7:	5d                   	pop    %ebp
  800af8:	c3                   	ret    

00800af9 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
  800afc:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800aff:	6a 00                	push   $0x0
  800b01:	6a 00                	push   $0x0
  800b03:	6a 00                	push   $0x0
  800b05:	ff 75 0c             	pushl  0xc(%ebp)
  800b08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b10:	b8 00 00 00 00       	mov    $0x0,%eax
  800b15:	e8 95 ff ff ff       	call   800aaf <syscall>
}
  800b1a:	83 c4 10             	add    $0x10,%esp
  800b1d:	c9                   	leave  
  800b1e:	c3                   	ret    

00800b1f <sys_cgetc>:

int
sys_cgetc(void)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800b25:	6a 00                	push   $0x0
  800b27:	6a 00                	push   $0x0
  800b29:	6a 00                	push   $0x0
  800b2b:	6a 00                	push   $0x0
  800b2d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b32:	ba 00 00 00 00       	mov    $0x0,%edx
  800b37:	b8 01 00 00 00       	mov    $0x1,%eax
  800b3c:	e8 6e ff ff ff       	call   800aaf <syscall>
}
  800b41:	c9                   	leave  
  800b42:	c3                   	ret    

00800b43 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800b49:	6a 00                	push   $0x0
  800b4b:	6a 00                	push   $0x0
  800b4d:	6a 00                	push   $0x0
  800b4f:	6a 00                	push   $0x0
  800b51:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b54:	ba 01 00 00 00       	mov    $0x1,%edx
  800b59:	b8 03 00 00 00       	mov    $0x3,%eax
  800b5e:	e8 4c ff ff ff       	call   800aaf <syscall>
}
  800b63:	c9                   	leave  
  800b64:	c3                   	ret    

00800b65 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b6b:	6a 00                	push   $0x0
  800b6d:	6a 00                	push   $0x0
  800b6f:	6a 00                	push   $0x0
  800b71:	6a 00                	push   $0x0
  800b73:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b78:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7d:	b8 02 00 00 00       	mov    $0x2,%eax
  800b82:	e8 28 ff ff ff       	call   800aaf <syscall>
}
  800b87:	c9                   	leave  
  800b88:	c3                   	ret    

00800b89 <sys_yield>:

void
sys_yield(void)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b8f:	6a 00                	push   $0x0
  800b91:	6a 00                	push   $0x0
  800b93:	6a 00                	push   $0x0
  800b95:	6a 00                	push   $0x0
  800b97:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba1:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ba6:	e8 04 ff ff ff       	call   800aaf <syscall>
}
  800bab:	83 c4 10             	add    $0x10,%esp
  800bae:	c9                   	leave  
  800baf:	c3                   	ret    

00800bb0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800bb6:	6a 00                	push   $0x0
  800bb8:	6a 00                	push   $0x0
  800bba:	ff 75 10             	pushl  0x10(%ebp)
  800bbd:	ff 75 0c             	pushl  0xc(%ebp)
  800bc0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc3:	ba 01 00 00 00       	mov    $0x1,%edx
  800bc8:	b8 04 00 00 00       	mov    $0x4,%eax
  800bcd:	e8 dd fe ff ff       	call   800aaf <syscall>
}
  800bd2:	c9                   	leave  
  800bd3:	c3                   	ret    

00800bd4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800bda:	ff 75 18             	pushl  0x18(%ebp)
  800bdd:	ff 75 14             	pushl  0x14(%ebp)
  800be0:	ff 75 10             	pushl  0x10(%ebp)
  800be3:	ff 75 0c             	pushl  0xc(%ebp)
  800be6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800be9:	ba 01 00 00 00       	mov    $0x1,%edx
  800bee:	b8 05 00 00 00       	mov    $0x5,%eax
  800bf3:	e8 b7 fe ff ff       	call   800aaf <syscall>
}
  800bf8:	c9                   	leave  
  800bf9:	c3                   	ret    

00800bfa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800c00:	6a 00                	push   $0x0
  800c02:	6a 00                	push   $0x0
  800c04:	6a 00                	push   $0x0
  800c06:	ff 75 0c             	pushl  0xc(%ebp)
  800c09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c0c:	ba 01 00 00 00       	mov    $0x1,%edx
  800c11:	b8 06 00 00 00       	mov    $0x6,%eax
  800c16:	e8 94 fe ff ff       	call   800aaf <syscall>
}
  800c1b:	c9                   	leave  
  800c1c:	c3                   	ret    

00800c1d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c23:	6a 00                	push   $0x0
  800c25:	6a 00                	push   $0x0
  800c27:	6a 00                	push   $0x0
  800c29:	ff 75 0c             	pushl  0xc(%ebp)
  800c2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c2f:	ba 01 00 00 00       	mov    $0x1,%edx
  800c34:	b8 08 00 00 00       	mov    $0x8,%eax
  800c39:	e8 71 fe ff ff       	call   800aaf <syscall>
}
  800c3e:	c9                   	leave  
  800c3f:	c3                   	ret    

00800c40 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800c46:	6a 00                	push   $0x0
  800c48:	6a 00                	push   $0x0
  800c4a:	6a 00                	push   $0x0
  800c4c:	ff 75 0c             	pushl  0xc(%ebp)
  800c4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c52:	ba 01 00 00 00       	mov    $0x1,%edx
  800c57:	b8 09 00 00 00       	mov    $0x9,%eax
  800c5c:	e8 4e fe ff ff       	call   800aaf <syscall>
}
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800c69:	6a 00                	push   $0x0
  800c6b:	6a 00                	push   $0x0
  800c6d:	6a 00                	push   $0x0
  800c6f:	ff 75 0c             	pushl  0xc(%ebp)
  800c72:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c75:	ba 01 00 00 00       	mov    $0x1,%edx
  800c7a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c7f:	e8 2b fe ff ff       	call   800aaf <syscall>
}
  800c84:	c9                   	leave  
  800c85:	c3                   	ret    

00800c86 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800c8c:	6a 00                	push   $0x0
  800c8e:	ff 75 14             	pushl  0x14(%ebp)
  800c91:	ff 75 10             	pushl  0x10(%ebp)
  800c94:	ff 75 0c             	pushl  0xc(%ebp)
  800c97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ca4:	e8 06 fe ff ff       	call   800aaf <syscall>
}
  800ca9:	c9                   	leave  
  800caa:	c3                   	ret    

00800cab <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800cb1:	6a 00                	push   $0x0
  800cb3:	6a 00                	push   $0x0
  800cb5:	6a 00                	push   $0x0
  800cb7:	6a 00                	push   $0x0
  800cb9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cbc:	ba 01 00 00 00       	mov    $0x1,%edx
  800cc1:	b8 0d 00 00 00       	mov    $0xd,%eax
  800cc6:	e8 e4 fd ff ff       	call   800aaf <syscall>
}
  800ccb:	c9                   	leave  
  800ccc:	c3                   	ret    

00800ccd <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	53                   	push   %ebx
  800cd1:	83 ec 04             	sub    $0x4,%esp

	int perm_w = PTE_COW|PTE_U|PTE_P;
	int perm = PTE_U|PTE_P;

	// LAB 4: Your code here.
	void *addr = (void*) (pn*PGSIZE);
  800cd4:	89 d3                	mov    %edx,%ebx
  800cd6:	c1 e3 0c             	shl    $0xc,%ebx

	//Si una página tiene el bit PTE_SHARE, se comparte con el hijo con los mismos permisos.
  	if (uvpt[pn] & PTE_SHARE) {
  800cd9:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800ce0:	f6 c5 04             	test   $0x4,%ch
  800ce3:	74 3a                	je     800d1f <duppage+0x52>
    	if (sys_page_map(0, addr, envid,addr, uvpt[pn] & PTE_SYSCALL) < 0) {
  800ce5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800cec:	83 ec 0c             	sub    $0xc,%esp
  800cef:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800cf5:	52                   	push   %edx
  800cf6:	53                   	push   %ebx
  800cf7:	50                   	push   %eax
  800cf8:	53                   	push   %ebx
  800cf9:	6a 00                	push   $0x0
  800cfb:	e8 d4 fe ff ff       	call   800bd4 <sys_page_map>
  800d00:	83 c4 20             	add    $0x20,%esp
  800d03:	85 c0                	test   %eax,%eax
  800d05:	0f 89 99 00 00 00    	jns    800da4 <duppage+0xd7>
 	     	panic("Error en sys_page_map");
  800d0b:	83 ec 04             	sub    $0x4,%esp
  800d0e:	68 ca 26 80 00       	push   $0x8026ca
  800d13:	6a 50                	push   $0x50
  800d15:	68 e0 26 80 00       	push   $0x8026e0
  800d1a:	e8 6a 12 00 00       	call   801f89 <_panic>
    	} 
    	return 0;
	}

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  800d1f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800d26:	f6 c1 02             	test   $0x2,%cl
  800d29:	75 0c                	jne    800d37 <duppage+0x6a>
  800d2b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d32:	f6 c6 08             	test   $0x8,%dh
  800d35:	74 5b                	je     800d92 <duppage+0xc5>
		if (sys_page_map(0, addr, envid, addr, perm_w) < 0){
  800d37:	83 ec 0c             	sub    $0xc,%esp
  800d3a:	68 05 08 00 00       	push   $0x805
  800d3f:	53                   	push   %ebx
  800d40:	50                   	push   %eax
  800d41:	53                   	push   %ebx
  800d42:	6a 00                	push   $0x0
  800d44:	e8 8b fe ff ff       	call   800bd4 <sys_page_map>
  800d49:	83 c4 20             	add    $0x20,%esp
  800d4c:	85 c0                	test   %eax,%eax
  800d4e:	79 14                	jns    800d64 <duppage+0x97>
			panic("Error mapeando pagina Padre");
  800d50:	83 ec 04             	sub    $0x4,%esp
  800d53:	68 eb 26 80 00       	push   $0x8026eb
  800d58:	6a 57                	push   $0x57
  800d5a:	68 e0 26 80 00       	push   $0x8026e0
  800d5f:	e8 25 12 00 00       	call   801f89 <_panic>
		}
		if (sys_page_map(0, addr, 0, addr, perm_w) < 0){
  800d64:	83 ec 0c             	sub    $0xc,%esp
  800d67:	68 05 08 00 00       	push   $0x805
  800d6c:	53                   	push   %ebx
  800d6d:	6a 00                	push   $0x0
  800d6f:	53                   	push   %ebx
  800d70:	6a 00                	push   $0x0
  800d72:	e8 5d fe ff ff       	call   800bd4 <sys_page_map>
  800d77:	83 c4 20             	add    $0x20,%esp
  800d7a:	85 c0                	test   %eax,%eax
  800d7c:	79 26                	jns    800da4 <duppage+0xd7>
			panic("Error mapeando pagina Hijo");
  800d7e:	83 ec 04             	sub    $0x4,%esp
  800d81:	68 07 27 80 00       	push   $0x802707
  800d86:	6a 5a                	push   $0x5a
  800d88:	68 e0 26 80 00       	push   $0x8026e0
  800d8d:	e8 f7 11 00 00       	call   801f89 <_panic>
		}
	} else sys_page_map(0, addr, envid, addr, perm);
  800d92:	83 ec 0c             	sub    $0xc,%esp
  800d95:	6a 05                	push   $0x5
  800d97:	53                   	push   %ebx
  800d98:	50                   	push   %eax
  800d99:	53                   	push   %ebx
  800d9a:	6a 00                	push   $0x0
  800d9c:	e8 33 fe ff ff       	call   800bd4 <sys_page_map>
  800da1:	83 c4 20             	add    $0x20,%esp
	
	return 0;
}
  800da4:	b8 00 00 00 00       	mov    $0x0,%eax
  800da9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800dac:	c9                   	leave  
  800dad:	c3                   	ret    

00800dae <dup_or_share>:
//FORK V0

static void
dup_or_share(envid_t dstenv, void *va, int perm){
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	57                   	push   %edi
  800db2:	56                   	push   %esi
  800db3:	53                   	push   %ebx
  800db4:	83 ec 0c             	sub    $0xc,%esp
  800db7:	89 c7                	mov    %eax,%edi
  800db9:	89 d6                	mov    %edx,%esi
  800dbb:	89 cb                	mov    %ecx,%ebx
	int result;
	// Si no es de escritura, comparto la pagina
	if((perm &PTE_W) != PTE_W){
  800dbd:	f6 c1 02             	test   $0x2,%cl
  800dc0:	75 2d                	jne    800def <dup_or_share+0x41>
		if((result = sys_page_map(0, va, dstenv, va, perm))<0){
  800dc2:	83 ec 0c             	sub    $0xc,%esp
  800dc5:	51                   	push   %ecx
  800dc6:	52                   	push   %edx
  800dc7:	50                   	push   %eax
  800dc8:	52                   	push   %edx
  800dc9:	6a 00                	push   $0x0
  800dcb:	e8 04 fe ff ff       	call   800bd4 <sys_page_map>
  800dd0:	83 c4 20             	add    $0x20,%esp
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	0f 89 a4 00 00 00    	jns    800e7f <dup_or_share+0xd1>
			panic("Error compartiendo la pagina");
  800ddb:	83 ec 04             	sub    $0x4,%esp
  800dde:	68 22 27 80 00       	push   $0x802722
  800de3:	6a 68                	push   $0x68
  800de5:	68 e0 26 80 00       	push   $0x8026e0
  800dea:	e8 9a 11 00 00       	call   801f89 <_panic>
		}
	// Si es de escritura comportamiento de duppage, en dumbfork
	}else{
		if ((result = sys_page_alloc(dstenv, va, perm)) < 0){
  800def:	83 ec 04             	sub    $0x4,%esp
  800df2:	51                   	push   %ecx
  800df3:	52                   	push   %edx
  800df4:	50                   	push   %eax
  800df5:	e8 b6 fd ff ff       	call   800bb0 <sys_page_alloc>
  800dfa:	83 c4 10             	add    $0x10,%esp
  800dfd:	85 c0                	test   %eax,%eax
  800dff:	79 14                	jns    800e15 <dup_or_share+0x67>
			panic("Error copiando la pagina");
  800e01:	83 ec 04             	sub    $0x4,%esp
  800e04:	68 3f 27 80 00       	push   $0x80273f
  800e09:	6a 6d                	push   $0x6d
  800e0b:	68 e0 26 80 00       	push   $0x8026e0
  800e10:	e8 74 11 00 00       	call   801f89 <_panic>
		}
		if ((result = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0){
  800e15:	83 ec 0c             	sub    $0xc,%esp
  800e18:	53                   	push   %ebx
  800e19:	68 00 00 40 00       	push   $0x400000
  800e1e:	6a 00                	push   $0x0
  800e20:	56                   	push   %esi
  800e21:	57                   	push   %edi
  800e22:	e8 ad fd ff ff       	call   800bd4 <sys_page_map>
  800e27:	83 c4 20             	add    $0x20,%esp
  800e2a:	85 c0                	test   %eax,%eax
  800e2c:	79 14                	jns    800e42 <dup_or_share+0x94>
			panic("Error copiando la pagina");
  800e2e:	83 ec 04             	sub    $0x4,%esp
  800e31:	68 3f 27 80 00       	push   $0x80273f
  800e36:	6a 70                	push   $0x70
  800e38:	68 e0 26 80 00       	push   $0x8026e0
  800e3d:	e8 47 11 00 00       	call   801f89 <_panic>
		}
		memmove(UTEMP, va, PGSIZE);
  800e42:	83 ec 04             	sub    $0x4,%esp
  800e45:	68 00 10 00 00       	push   $0x1000
  800e4a:	56                   	push   %esi
  800e4b:	68 00 00 40 00       	push   $0x400000
  800e50:	e8 a5 fa ff ff       	call   8008fa <memmove>
		if ((result = sys_page_unmap(0, UTEMP)) < 0){
  800e55:	83 c4 08             	add    $0x8,%esp
  800e58:	68 00 00 40 00       	push   $0x400000
  800e5d:	6a 00                	push   $0x0
  800e5f:	e8 96 fd ff ff       	call   800bfa <sys_page_unmap>
  800e64:	83 c4 10             	add    $0x10,%esp
  800e67:	85 c0                	test   %eax,%eax
  800e69:	79 14                	jns    800e7f <dup_or_share+0xd1>
			panic("Error copiando la pagina");
  800e6b:	83 ec 04             	sub    $0x4,%esp
  800e6e:	68 3f 27 80 00       	push   $0x80273f
  800e73:	6a 74                	push   $0x74
  800e75:	68 e0 26 80 00       	push   $0x8026e0
  800e7a:	e8 0a 11 00 00       	call   801f89 <_panic>
		}
	}	
}
  800e7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e82:	5b                   	pop    %ebx
  800e83:	5e                   	pop    %esi
  800e84:	5f                   	pop    %edi
  800e85:	5d                   	pop    %ebp
  800e86:	c3                   	ret    

00800e87 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	53                   	push   %ebx
  800e8b:	83 ec 04             	sub    $0x4,%esp
  800e8e:	8b 55 08             	mov    0x8(%ebp),%edx
	void *va = (void *) utf->utf_fault_va;
  800e91:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800e93:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  800e97:	74 2e                	je     800ec7 <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
  800e99:	89 c2                	mov    %eax,%edx
  800e9b:	c1 ea 16             	shr    $0x16,%edx
  800e9e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800ea5:	f6 c2 01             	test   $0x1,%dl
  800ea8:	74 1d                	je     800ec7 <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
  800eaa:	89 c2                	mov    %eax,%edx
  800eac:	c1 ea 0c             	shr    $0xc,%edx
  800eaf:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
		(uvpd[PDX(va)] & PTE_P) && 
  800eb6:	f6 c1 01             	test   $0x1,%cl
  800eb9:	74 0c                	je     800ec7 <pgfault+0x40>
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
  800ebb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800ec2:	f6 c6 08             	test   $0x8,%dh
  800ec5:	75 14                	jne    800edb <pgfault+0x54>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
		panic("No es copy-on-write");
  800ec7:	83 ec 04             	sub    $0x4,%esp
  800eca:	68 58 27 80 00       	push   $0x802758
  800ecf:	6a 21                	push   $0x21
  800ed1:	68 e0 26 80 00       	push   $0x8026e0
  800ed6:	e8 ae 10 00 00       	call   801f89 <_panic>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	va = ROUNDDOWN(va, PGSIZE);
  800edb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ee0:	89 c3                	mov    %eax,%ebx
	if (sys_page_alloc(0, PFTEMP, perm) < 0){
  800ee2:	83 ec 04             	sub    $0x4,%esp
  800ee5:	6a 07                	push   $0x7
  800ee7:	68 00 f0 7f 00       	push   $0x7ff000
  800eec:	6a 00                	push   $0x0
  800eee:	e8 bd fc ff ff       	call   800bb0 <sys_page_alloc>
  800ef3:	83 c4 10             	add    $0x10,%esp
  800ef6:	85 c0                	test   %eax,%eax
  800ef8:	79 14                	jns    800f0e <pgfault+0x87>
		panic("Error sys_page_alloc");
  800efa:	83 ec 04             	sub    $0x4,%esp
  800efd:	68 6c 27 80 00       	push   $0x80276c
  800f02:	6a 2a                	push   $0x2a
  800f04:	68 e0 26 80 00       	push   $0x8026e0
  800f09:	e8 7b 10 00 00       	call   801f89 <_panic>
	}
	memcpy(PFTEMP, va, PGSIZE);
  800f0e:	83 ec 04             	sub    $0x4,%esp
  800f11:	68 00 10 00 00       	push   $0x1000
  800f16:	53                   	push   %ebx
  800f17:	68 00 f0 7f 00       	push   $0x7ff000
  800f1c:	e8 41 fa ff ff       	call   800962 <memcpy>
	if (sys_page_map(0, PFTEMP, 0, va, perm) < 0){
  800f21:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f28:	53                   	push   %ebx
  800f29:	6a 00                	push   $0x0
  800f2b:	68 00 f0 7f 00       	push   $0x7ff000
  800f30:	6a 00                	push   $0x0
  800f32:	e8 9d fc ff ff       	call   800bd4 <sys_page_map>
  800f37:	83 c4 20             	add    $0x20,%esp
  800f3a:	85 c0                	test   %eax,%eax
  800f3c:	79 14                	jns    800f52 <pgfault+0xcb>
		panic("Error sys_page_map");
  800f3e:	83 ec 04             	sub    $0x4,%esp
  800f41:	68 81 27 80 00       	push   $0x802781
  800f46:	6a 2e                	push   $0x2e
  800f48:	68 e0 26 80 00       	push   $0x8026e0
  800f4d:	e8 37 10 00 00       	call   801f89 <_panic>
	}
	if (sys_page_unmap(0, PFTEMP) < 0){
  800f52:	83 ec 08             	sub    $0x8,%esp
  800f55:	68 00 f0 7f 00       	push   $0x7ff000
  800f5a:	6a 00                	push   $0x0
  800f5c:	e8 99 fc ff ff       	call   800bfa <sys_page_unmap>
  800f61:	83 c4 10             	add    $0x10,%esp
  800f64:	85 c0                	test   %eax,%eax
  800f66:	79 14                	jns    800f7c <pgfault+0xf5>
		panic("Error sys_page_unmap");
  800f68:	83 ec 04             	sub    $0x4,%esp
  800f6b:	68 94 27 80 00       	push   $0x802794
  800f70:	6a 31                	push   $0x31
  800f72:	68 e0 26 80 00       	push   $0x8026e0
  800f77:	e8 0d 10 00 00       	call   801f89 <_panic>
	}
	return;

}
  800f7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f7f:	c9                   	leave  
  800f80:	c3                   	ret    

00800f81 <fork_v0>:
		}
	}	
}

envid_t
fork_v0(void){
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	57                   	push   %edi
  800f85:	56                   	push   %esi
  800f86:	53                   	push   %ebx
  800f87:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f8a:	b8 07 00 00 00       	mov    $0x7,%eax
  800f8f:	cd 30                	int    $0x30
  800f91:	89 c6                	mov    %eax,%esi
	envid_t envid;
	uint8_t *va;
	int result;	

	envid = sys_exofork();
	if (envid < 0)
  800f93:	85 c0                	test   %eax,%eax
  800f95:	79 15                	jns    800fac <fork_v0+0x2b>
		panic("sys_exofork: %e", envid);
  800f97:	50                   	push   %eax
  800f98:	68 a9 27 80 00       	push   $0x8027a9
  800f9d:	68 81 00 00 00       	push   $0x81
  800fa2:	68 e0 26 80 00       	push   $0x8026e0
  800fa7:	e8 dd 0f 00 00       	call   801f89 <_panic>
  800fac:	89 c7                	mov    %eax,%edi
  800fae:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {		
  800fb3:	85 c0                	test   %eax,%eax
  800fb5:	75 1e                	jne    800fd5 <fork_v0+0x54>
		thisenv = &envs[ENVX(sys_getenvid())];
  800fb7:	e8 a9 fb ff ff       	call   800b65 <sys_getenvid>
  800fbc:	25 ff 03 00 00       	and    $0x3ff,%eax
  800fc1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800fc4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800fc9:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  800fce:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd3:	eb 7a                	jmp    80104f <fork_v0+0xce>
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  800fd5:	89 d8                	mov    %ebx,%eax
  800fd7:	c1 e8 16             	shr    $0x16,%eax
  800fda:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fe1:	a8 01                	test   $0x1,%al
  800fe3:	74 33                	je     801018 <fork_v0+0x97>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  800fe5:	89 d8                	mov    %ebx,%eax
  800fe7:	c1 e8 0c             	shr    $0xc,%eax
  800fea:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800ff1:	f6 c2 01             	test   $0x1,%dl
  800ff4:	74 22                	je     801018 <fork_v0+0x97>
  800ff6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800ffd:	f6 c2 04             	test   $0x4,%dl
  801000:	74 16                	je     801018 <fork_v0+0x97>
				pte_t pte =uvpt[PGNUM(va)];
  801002:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
  801009:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80100f:	89 da                	mov    %ebx,%edx
  801011:	89 f8                	mov    %edi,%eax
  801013:	e8 96 fd ff ff       	call   800dae <dup_or_share>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
  801018:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80101e:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801024:	75 af                	jne    800fd5 <fork_v0+0x54>
				pte_t pte =uvpt[PGNUM(va)];
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
			}
		}
	}	
	if ((result = sys_env_set_status(envid, ENV_RUNNABLE)) < 0){
  801026:	83 ec 08             	sub    $0x8,%esp
  801029:	6a 02                	push   $0x2
  80102b:	56                   	push   %esi
  80102c:	e8 ec fb ff ff       	call   800c1d <sys_env_set_status>
  801031:	83 c4 10             	add    $0x10,%esp
  801034:	85 c0                	test   %eax,%eax
  801036:	79 15                	jns    80104d <fork_v0+0xcc>

		panic("sys_env_set_status: %e", result);
  801038:	50                   	push   %eax
  801039:	68 b9 27 80 00       	push   $0x8027b9
  80103e:	68 90 00 00 00       	push   $0x90
  801043:	68 e0 26 80 00       	push   $0x8026e0
  801048:	e8 3c 0f 00 00       	call   801f89 <_panic>
	}
	return envid;
  80104d:	89 f0                	mov    %esi,%eax
}
  80104f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801052:	5b                   	pop    %ebx
  801053:	5e                   	pop    %esi
  801054:	5f                   	pop    %edi
  801055:	5d                   	pop    %ebp
  801056:	c3                   	ret    

00801057 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	57                   	push   %edi
  80105b:	56                   	push   %esi
  80105c:	53                   	push   %ebx
  80105d:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801060:	68 87 0e 80 00       	push   $0x800e87
  801065:	e8 65 0f 00 00       	call   801fcf <set_pgfault_handler>
  80106a:	b8 07 00 00 00       	mov    $0x7,%eax
  80106f:	cd 30                	int    $0x30
  801071:	89 c6                	mov    %eax,%esi

	envid_t envid;
	uint32_t va;
	envid = sys_exofork();
	if (envid < 0){
  801073:	83 c4 10             	add    $0x10,%esp
  801076:	85 c0                	test   %eax,%eax
  801078:	79 15                	jns    80108f <fork+0x38>
		panic("sys_exofork: %e", envid);
  80107a:	50                   	push   %eax
  80107b:	68 a9 27 80 00       	push   $0x8027a9
  801080:	68 b1 00 00 00       	push   $0xb1
  801085:	68 e0 26 80 00       	push   $0x8026e0
  80108a:	e8 fa 0e 00 00       	call   801f89 <_panic>
  80108f:	89 c7                	mov    %eax,%edi
  801091:	bb 00 00 00 00       	mov    $0x0,%ebx
	}
	if (envid == 0) {		
  801096:	85 c0                	test   %eax,%eax
  801098:	75 21                	jne    8010bb <fork+0x64>
		thisenv = &envs[ENVX(sys_getenvid())];
  80109a:	e8 c6 fa ff ff       	call   800b65 <sys_getenvid>
  80109f:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010a4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010a7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010ac:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  8010b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b6:	e9 a7 00 00 00       	jmp    801162 <fork+0x10b>
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  8010bb:	89 d8                	mov    %ebx,%eax
  8010bd:	c1 e8 16             	shr    $0x16,%eax
  8010c0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010c7:	a8 01                	test   $0x1,%al
  8010c9:	74 22                	je     8010ed <fork+0x96>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  8010cb:	89 da                	mov    %ebx,%edx
  8010cd:	c1 ea 0c             	shr    $0xc,%edx
  8010d0:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8010d7:	a8 01                	test   $0x1,%al
  8010d9:	74 12                	je     8010ed <fork+0x96>
  8010db:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8010e2:	a8 04                	test   $0x4,%al
  8010e4:	74 07                	je     8010ed <fork+0x96>
				duppage(envid, PGNUM(va));			
  8010e6:	89 f8                	mov    %edi,%eax
  8010e8:	e8 e0 fb ff ff       	call   800ccd <duppage>
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
  8010ed:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010f3:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8010f9:	75 c0                	jne    8010bb <fork+0x64>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
				duppage(envid, PGNUM(va));			
			}
		}
	}
	if (sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P) < 0){
  8010fb:	83 ec 04             	sub    $0x4,%esp
  8010fe:	6a 07                	push   $0x7
  801100:	68 00 f0 bf ee       	push   $0xeebff000
  801105:	56                   	push   %esi
  801106:	e8 a5 fa ff ff       	call   800bb0 <sys_page_alloc>
  80110b:	83 c4 10             	add    $0x10,%esp
  80110e:	85 c0                	test   %eax,%eax
  801110:	79 17                	jns    801129 <fork+0xd2>
		panic("Se escribio en la pagina de excepciones");
  801112:	83 ec 04             	sub    $0x4,%esp
  801115:	68 e8 27 80 00       	push   $0x8027e8
  80111a:	68 c0 00 00 00       	push   $0xc0
  80111f:	68 e0 26 80 00       	push   $0x8026e0
  801124:	e8 60 0e 00 00       	call   801f89 <_panic>
	}	
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801129:	83 ec 08             	sub    $0x8,%esp
  80112c:	68 3e 20 80 00       	push   $0x80203e
  801131:	56                   	push   %esi
  801132:	e8 2c fb ff ff       	call   800c63 <sys_env_set_pgfault_upcall>

	if (sys_env_set_status(envid, ENV_RUNNABLE) < 0)
  801137:	83 c4 08             	add    $0x8,%esp
  80113a:	6a 02                	push   $0x2
  80113c:	56                   	push   %esi
  80113d:	e8 db fa ff ff       	call   800c1d <sys_env_set_status>
  801142:	83 c4 10             	add    $0x10,%esp
  801145:	85 c0                	test   %eax,%eax
  801147:	79 17                	jns    801160 <fork+0x109>
		panic("Status incorrecto de enviroment");
  801149:	83 ec 04             	sub    $0x4,%esp
  80114c:	68 10 28 80 00       	push   $0x802810
  801151:	68 c5 00 00 00       	push   $0xc5
  801156:	68 e0 26 80 00       	push   $0x8026e0
  80115b:	e8 29 0e 00 00       	call   801f89 <_panic>

	return envid;
  801160:	89 f0                	mov    %esi,%eax
	
}
  801162:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801165:	5b                   	pop    %ebx
  801166:	5e                   	pop    %esi
  801167:	5f                   	pop    %edi
  801168:	5d                   	pop    %ebp
  801169:	c3                   	ret    

0080116a <sfork>:


// Challenge!
int
sfork(void)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801170:	68 d0 27 80 00       	push   $0x8027d0
  801175:	68 d1 00 00 00       	push   $0xd1
  80117a:	68 e0 26 80 00       	push   $0x8026e0
  80117f:	e8 05 0e 00 00       	call   801f89 <_panic>

00801184 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801184:	55                   	push   %ebp
  801185:	89 e5                	mov    %esp,%ebp
  801187:	56                   	push   %esi
  801188:	53                   	push   %ebx
  801189:	8b 75 08             	mov    0x8(%ebp),%esi
  80118c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801192:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801194:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801199:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  80119c:	83 ec 0c             	sub    $0xc,%esp
  80119f:	50                   	push   %eax
  8011a0:	e8 06 fb ff ff       	call   800cab <sys_ipc_recv>
	if (from_env_store)
  8011a5:	83 c4 10             	add    $0x10,%esp
  8011a8:	85 f6                	test   %esi,%esi
  8011aa:	74 0b                	je     8011b7 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  8011ac:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8011b2:	8b 52 74             	mov    0x74(%edx),%edx
  8011b5:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8011b7:	85 db                	test   %ebx,%ebx
  8011b9:	74 0b                	je     8011c6 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  8011bb:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8011c1:	8b 52 78             	mov    0x78(%edx),%edx
  8011c4:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  8011c6:	85 c0                	test   %eax,%eax
  8011c8:	79 16                	jns    8011e0 <ipc_recv+0x5c>
		if (from_env_store)
  8011ca:	85 f6                	test   %esi,%esi
  8011cc:	74 06                	je     8011d4 <ipc_recv+0x50>
			*from_env_store = 0;
  8011ce:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  8011d4:	85 db                	test   %ebx,%ebx
  8011d6:	74 10                	je     8011e8 <ipc_recv+0x64>
			*perm_store = 0;
  8011d8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8011de:	eb 08                	jmp    8011e8 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  8011e0:	a1 08 40 80 00       	mov    0x804008,%eax
  8011e5:	8b 40 70             	mov    0x70(%eax),%eax
}
  8011e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011eb:	5b                   	pop    %ebx
  8011ec:	5e                   	pop    %esi
  8011ed:	5d                   	pop    %ebp
  8011ee:	c3                   	ret    

008011ef <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8011ef:	55                   	push   %ebp
  8011f0:	89 e5                	mov    %esp,%ebp
  8011f2:	57                   	push   %edi
  8011f3:	56                   	push   %esi
  8011f4:	53                   	push   %ebx
  8011f5:	83 ec 0c             	sub    $0xc,%esp
  8011f8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  801201:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  801203:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801208:	0f 44 d8             	cmove  %eax,%ebx
  80120b:	eb 1c                	jmp    801229 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  80120d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801210:	74 12                	je     801224 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801212:	50                   	push   %eax
  801213:	68 30 28 80 00       	push   $0x802830
  801218:	6a 42                	push   $0x42
  80121a:	68 46 28 80 00       	push   $0x802846
  80121f:	e8 65 0d 00 00       	call   801f89 <_panic>
		sys_yield();
  801224:	e8 60 f9 ff ff       	call   800b89 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801229:	ff 75 14             	pushl  0x14(%ebp)
  80122c:	53                   	push   %ebx
  80122d:	56                   	push   %esi
  80122e:	57                   	push   %edi
  80122f:	e8 52 fa ff ff       	call   800c86 <sys_ipc_try_send>
  801234:	83 c4 10             	add    $0x10,%esp
  801237:	85 c0                	test   %eax,%eax
  801239:	75 d2                	jne    80120d <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  80123b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80123e:	5b                   	pop    %ebx
  80123f:	5e                   	pop    %esi
  801240:	5f                   	pop    %edi
  801241:	5d                   	pop    %ebp
  801242:	c3                   	ret    

00801243 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801249:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80124e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801251:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801257:	8b 52 50             	mov    0x50(%edx),%edx
  80125a:	39 ca                	cmp    %ecx,%edx
  80125c:	75 0d                	jne    80126b <ipc_find_env+0x28>
			return envs[i].env_id;
  80125e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801261:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801266:	8b 40 48             	mov    0x48(%eax),%eax
  801269:	eb 0f                	jmp    80127a <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80126b:	83 c0 01             	add    $0x1,%eax
  80126e:	3d 00 04 00 00       	cmp    $0x400,%eax
  801273:	75 d9                	jne    80124e <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801275:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80127a:	5d                   	pop    %ebp
  80127b:	c3                   	ret    

0080127c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80127c:	55                   	push   %ebp
  80127d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	05 00 00 00 30       	add    $0x30000000,%eax
  801287:	c1 e8 0c             	shr    $0xc,%eax
}
  80128a:	5d                   	pop    %ebp
  80128b:	c3                   	ret    

0080128c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  80128f:	ff 75 08             	pushl  0x8(%ebp)
  801292:	e8 e5 ff ff ff       	call   80127c <fd2num>
  801297:	83 c4 04             	add    $0x4,%esp
  80129a:	c1 e0 0c             	shl    $0xc,%eax
  80129d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012a2:	c9                   	leave  
  8012a3:	c3                   	ret    

008012a4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
  8012a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012aa:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012af:	89 c2                	mov    %eax,%edx
  8012b1:	c1 ea 16             	shr    $0x16,%edx
  8012b4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012bb:	f6 c2 01             	test   $0x1,%dl
  8012be:	74 11                	je     8012d1 <fd_alloc+0x2d>
  8012c0:	89 c2                	mov    %eax,%edx
  8012c2:	c1 ea 0c             	shr    $0xc,%edx
  8012c5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012cc:	f6 c2 01             	test   $0x1,%dl
  8012cf:	75 09                	jne    8012da <fd_alloc+0x36>
			*fd_store = fd;
  8012d1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d8:	eb 17                	jmp    8012f1 <fd_alloc+0x4d>
  8012da:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8012df:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012e4:	75 c9                	jne    8012af <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012e6:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8012ec:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8012f1:	5d                   	pop    %ebp
  8012f2:	c3                   	ret    

008012f3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012f3:	55                   	push   %ebp
  8012f4:	89 e5                	mov    %esp,%ebp
  8012f6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012f9:	83 f8 1f             	cmp    $0x1f,%eax
  8012fc:	77 36                	ja     801334 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012fe:	c1 e0 0c             	shl    $0xc,%eax
  801301:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801306:	89 c2                	mov    %eax,%edx
  801308:	c1 ea 16             	shr    $0x16,%edx
  80130b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801312:	f6 c2 01             	test   $0x1,%dl
  801315:	74 24                	je     80133b <fd_lookup+0x48>
  801317:	89 c2                	mov    %eax,%edx
  801319:	c1 ea 0c             	shr    $0xc,%edx
  80131c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801323:	f6 c2 01             	test   $0x1,%dl
  801326:	74 1a                	je     801342 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801328:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132b:	89 02                	mov    %eax,(%edx)
	return 0;
  80132d:	b8 00 00 00 00       	mov    $0x0,%eax
  801332:	eb 13                	jmp    801347 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801334:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801339:	eb 0c                	jmp    801347 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80133b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801340:	eb 05                	jmp    801347 <fd_lookup+0x54>
  801342:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  801347:	5d                   	pop    %ebp
  801348:	c3                   	ret    

00801349 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	83 ec 08             	sub    $0x8,%esp
  80134f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801352:	ba cc 28 80 00       	mov    $0x8028cc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801357:	eb 13                	jmp    80136c <dev_lookup+0x23>
  801359:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  80135c:	39 08                	cmp    %ecx,(%eax)
  80135e:	75 0c                	jne    80136c <dev_lookup+0x23>
			*dev = devtab[i];
  801360:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801363:	89 01                	mov    %eax,(%ecx)
			return 0;
  801365:	b8 00 00 00 00       	mov    $0x0,%eax
  80136a:	eb 2e                	jmp    80139a <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80136c:	8b 02                	mov    (%edx),%eax
  80136e:	85 c0                	test   %eax,%eax
  801370:	75 e7                	jne    801359 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801372:	a1 08 40 80 00       	mov    0x804008,%eax
  801377:	8b 40 48             	mov    0x48(%eax),%eax
  80137a:	83 ec 04             	sub    $0x4,%esp
  80137d:	51                   	push   %ecx
  80137e:	50                   	push   %eax
  80137f:	68 50 28 80 00       	push   $0x802850
  801384:	e8 6c ee ff ff       	call   8001f5 <cprintf>
	*dev = 0;
  801389:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801392:	83 c4 10             	add    $0x10,%esp
  801395:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80139a:	c9                   	leave  
  80139b:	c3                   	ret    

0080139c <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
  80139f:	56                   	push   %esi
  8013a0:	53                   	push   %ebx
  8013a1:	83 ec 10             	sub    $0x10,%esp
  8013a4:	8b 75 08             	mov    0x8(%ebp),%esi
  8013a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013aa:	56                   	push   %esi
  8013ab:	e8 cc fe ff ff       	call   80127c <fd2num>
  8013b0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8013b3:	89 14 24             	mov    %edx,(%esp)
  8013b6:	50                   	push   %eax
  8013b7:	e8 37 ff ff ff       	call   8012f3 <fd_lookup>
  8013bc:	83 c4 08             	add    $0x8,%esp
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	78 05                	js     8013c8 <fd_close+0x2c>
	    || fd != fd2)
  8013c3:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8013c6:	74 0c                	je     8013d4 <fd_close+0x38>
		return (must_exist ? r : 0);
  8013c8:	84 db                	test   %bl,%bl
  8013ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8013cf:	0f 44 c2             	cmove  %edx,%eax
  8013d2:	eb 41                	jmp    801415 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013d4:	83 ec 08             	sub    $0x8,%esp
  8013d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013da:	50                   	push   %eax
  8013db:	ff 36                	pushl  (%esi)
  8013dd:	e8 67 ff ff ff       	call   801349 <dev_lookup>
  8013e2:	89 c3                	mov    %eax,%ebx
  8013e4:	83 c4 10             	add    $0x10,%esp
  8013e7:	85 c0                	test   %eax,%eax
  8013e9:	78 1a                	js     801405 <fd_close+0x69>
		if (dev->dev_close)
  8013eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ee:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8013f1:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	74 0b                	je     801405 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  8013fa:	83 ec 0c             	sub    $0xc,%esp
  8013fd:	56                   	push   %esi
  8013fe:	ff d0                	call   *%eax
  801400:	89 c3                	mov    %eax,%ebx
  801402:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801405:	83 ec 08             	sub    $0x8,%esp
  801408:	56                   	push   %esi
  801409:	6a 00                	push   $0x0
  80140b:	e8 ea f7 ff ff       	call   800bfa <sys_page_unmap>
	return r;
  801410:	83 c4 10             	add    $0x10,%esp
  801413:	89 d8                	mov    %ebx,%eax
}
  801415:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801418:	5b                   	pop    %ebx
  801419:	5e                   	pop    %esi
  80141a:	5d                   	pop    %ebp
  80141b:	c3                   	ret    

0080141c <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801422:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801425:	50                   	push   %eax
  801426:	ff 75 08             	pushl  0x8(%ebp)
  801429:	e8 c5 fe ff ff       	call   8012f3 <fd_lookup>
  80142e:	83 c4 08             	add    $0x8,%esp
  801431:	85 c0                	test   %eax,%eax
  801433:	78 10                	js     801445 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801435:	83 ec 08             	sub    $0x8,%esp
  801438:	6a 01                	push   $0x1
  80143a:	ff 75 f4             	pushl  -0xc(%ebp)
  80143d:	e8 5a ff ff ff       	call   80139c <fd_close>
  801442:	83 c4 10             	add    $0x10,%esp
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <close_all>:

void
close_all(void)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	53                   	push   %ebx
  80144b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80144e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801453:	83 ec 0c             	sub    $0xc,%esp
  801456:	53                   	push   %ebx
  801457:	e8 c0 ff ff ff       	call   80141c <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80145c:	83 c3 01             	add    $0x1,%ebx
  80145f:	83 c4 10             	add    $0x10,%esp
  801462:	83 fb 20             	cmp    $0x20,%ebx
  801465:	75 ec                	jne    801453 <close_all+0xc>
		close(i);
}
  801467:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80146a:	c9                   	leave  
  80146b:	c3                   	ret    

0080146c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
  80146f:	57                   	push   %edi
  801470:	56                   	push   %esi
  801471:	53                   	push   %ebx
  801472:	83 ec 2c             	sub    $0x2c,%esp
  801475:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801478:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80147b:	50                   	push   %eax
  80147c:	ff 75 08             	pushl  0x8(%ebp)
  80147f:	e8 6f fe ff ff       	call   8012f3 <fd_lookup>
  801484:	83 c4 08             	add    $0x8,%esp
  801487:	85 c0                	test   %eax,%eax
  801489:	0f 88 c1 00 00 00    	js     801550 <dup+0xe4>
		return r;
	close(newfdnum);
  80148f:	83 ec 0c             	sub    $0xc,%esp
  801492:	56                   	push   %esi
  801493:	e8 84 ff ff ff       	call   80141c <close>

	newfd = INDEX2FD(newfdnum);
  801498:	89 f3                	mov    %esi,%ebx
  80149a:	c1 e3 0c             	shl    $0xc,%ebx
  80149d:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8014a3:	83 c4 04             	add    $0x4,%esp
  8014a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014a9:	e8 de fd ff ff       	call   80128c <fd2data>
  8014ae:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  8014b0:	89 1c 24             	mov    %ebx,(%esp)
  8014b3:	e8 d4 fd ff ff       	call   80128c <fd2data>
  8014b8:	83 c4 10             	add    $0x10,%esp
  8014bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014be:	89 f8                	mov    %edi,%eax
  8014c0:	c1 e8 16             	shr    $0x16,%eax
  8014c3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014ca:	a8 01                	test   $0x1,%al
  8014cc:	74 37                	je     801505 <dup+0x99>
  8014ce:	89 f8                	mov    %edi,%eax
  8014d0:	c1 e8 0c             	shr    $0xc,%eax
  8014d3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014da:	f6 c2 01             	test   $0x1,%dl
  8014dd:	74 26                	je     801505 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014df:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014e6:	83 ec 0c             	sub    $0xc,%esp
  8014e9:	25 07 0e 00 00       	and    $0xe07,%eax
  8014ee:	50                   	push   %eax
  8014ef:	ff 75 d4             	pushl  -0x2c(%ebp)
  8014f2:	6a 00                	push   $0x0
  8014f4:	57                   	push   %edi
  8014f5:	6a 00                	push   $0x0
  8014f7:	e8 d8 f6 ff ff       	call   800bd4 <sys_page_map>
  8014fc:	89 c7                	mov    %eax,%edi
  8014fe:	83 c4 20             	add    $0x20,%esp
  801501:	85 c0                	test   %eax,%eax
  801503:	78 2e                	js     801533 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801505:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801508:	89 d0                	mov    %edx,%eax
  80150a:	c1 e8 0c             	shr    $0xc,%eax
  80150d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801514:	83 ec 0c             	sub    $0xc,%esp
  801517:	25 07 0e 00 00       	and    $0xe07,%eax
  80151c:	50                   	push   %eax
  80151d:	53                   	push   %ebx
  80151e:	6a 00                	push   $0x0
  801520:	52                   	push   %edx
  801521:	6a 00                	push   $0x0
  801523:	e8 ac f6 ff ff       	call   800bd4 <sys_page_map>
  801528:	89 c7                	mov    %eax,%edi
  80152a:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  80152d:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80152f:	85 ff                	test   %edi,%edi
  801531:	79 1d                	jns    801550 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801533:	83 ec 08             	sub    $0x8,%esp
  801536:	53                   	push   %ebx
  801537:	6a 00                	push   $0x0
  801539:	e8 bc f6 ff ff       	call   800bfa <sys_page_unmap>
	sys_page_unmap(0, nva);
  80153e:	83 c4 08             	add    $0x8,%esp
  801541:	ff 75 d4             	pushl  -0x2c(%ebp)
  801544:	6a 00                	push   $0x0
  801546:	e8 af f6 ff ff       	call   800bfa <sys_page_unmap>
	return r;
  80154b:	83 c4 10             	add    $0x10,%esp
  80154e:	89 f8                	mov    %edi,%eax
}
  801550:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801553:	5b                   	pop    %ebx
  801554:	5e                   	pop    %esi
  801555:	5f                   	pop    %edi
  801556:	5d                   	pop    %ebp
  801557:	c3                   	ret    

00801558 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
  80155b:	53                   	push   %ebx
  80155c:	83 ec 14             	sub    $0x14,%esp
  80155f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801562:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801565:	50                   	push   %eax
  801566:	53                   	push   %ebx
  801567:	e8 87 fd ff ff       	call   8012f3 <fd_lookup>
  80156c:	83 c4 08             	add    $0x8,%esp
  80156f:	89 c2                	mov    %eax,%edx
  801571:	85 c0                	test   %eax,%eax
  801573:	78 6d                	js     8015e2 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801575:	83 ec 08             	sub    $0x8,%esp
  801578:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80157b:	50                   	push   %eax
  80157c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157f:	ff 30                	pushl  (%eax)
  801581:	e8 c3 fd ff ff       	call   801349 <dev_lookup>
  801586:	83 c4 10             	add    $0x10,%esp
  801589:	85 c0                	test   %eax,%eax
  80158b:	78 4c                	js     8015d9 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80158d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801590:	8b 42 08             	mov    0x8(%edx),%eax
  801593:	83 e0 03             	and    $0x3,%eax
  801596:	83 f8 01             	cmp    $0x1,%eax
  801599:	75 21                	jne    8015bc <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80159b:	a1 08 40 80 00       	mov    0x804008,%eax
  8015a0:	8b 40 48             	mov    0x48(%eax),%eax
  8015a3:	83 ec 04             	sub    $0x4,%esp
  8015a6:	53                   	push   %ebx
  8015a7:	50                   	push   %eax
  8015a8:	68 91 28 80 00       	push   $0x802891
  8015ad:	e8 43 ec ff ff       	call   8001f5 <cprintf>
		return -E_INVAL;
  8015b2:	83 c4 10             	add    $0x10,%esp
  8015b5:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8015ba:	eb 26                	jmp    8015e2 <read+0x8a>
	}
	if (!dev->dev_read)
  8015bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bf:	8b 40 08             	mov    0x8(%eax),%eax
  8015c2:	85 c0                	test   %eax,%eax
  8015c4:	74 17                	je     8015dd <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015c6:	83 ec 04             	sub    $0x4,%esp
  8015c9:	ff 75 10             	pushl  0x10(%ebp)
  8015cc:	ff 75 0c             	pushl  0xc(%ebp)
  8015cf:	52                   	push   %edx
  8015d0:	ff d0                	call   *%eax
  8015d2:	89 c2                	mov    %eax,%edx
  8015d4:	83 c4 10             	add    $0x10,%esp
  8015d7:	eb 09                	jmp    8015e2 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015d9:	89 c2                	mov    %eax,%edx
  8015db:	eb 05                	jmp    8015e2 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8015dd:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  8015e2:	89 d0                	mov    %edx,%eax
  8015e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e7:	c9                   	leave  
  8015e8:	c3                   	ret    

008015e9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	57                   	push   %edi
  8015ed:	56                   	push   %esi
  8015ee:	53                   	push   %ebx
  8015ef:	83 ec 0c             	sub    $0xc,%esp
  8015f2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015f5:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015fd:	eb 21                	jmp    801620 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015ff:	83 ec 04             	sub    $0x4,%esp
  801602:	89 f0                	mov    %esi,%eax
  801604:	29 d8                	sub    %ebx,%eax
  801606:	50                   	push   %eax
  801607:	89 d8                	mov    %ebx,%eax
  801609:	03 45 0c             	add    0xc(%ebp),%eax
  80160c:	50                   	push   %eax
  80160d:	57                   	push   %edi
  80160e:	e8 45 ff ff ff       	call   801558 <read>
		if (m < 0)
  801613:	83 c4 10             	add    $0x10,%esp
  801616:	85 c0                	test   %eax,%eax
  801618:	78 10                	js     80162a <readn+0x41>
			return m;
		if (m == 0)
  80161a:	85 c0                	test   %eax,%eax
  80161c:	74 0a                	je     801628 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80161e:	01 c3                	add    %eax,%ebx
  801620:	39 f3                	cmp    %esi,%ebx
  801622:	72 db                	jb     8015ff <readn+0x16>
  801624:	89 d8                	mov    %ebx,%eax
  801626:	eb 02                	jmp    80162a <readn+0x41>
  801628:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80162a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80162d:	5b                   	pop    %ebx
  80162e:	5e                   	pop    %esi
  80162f:	5f                   	pop    %edi
  801630:	5d                   	pop    %ebp
  801631:	c3                   	ret    

00801632 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	53                   	push   %ebx
  801636:	83 ec 14             	sub    $0x14,%esp
  801639:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80163c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80163f:	50                   	push   %eax
  801640:	53                   	push   %ebx
  801641:	e8 ad fc ff ff       	call   8012f3 <fd_lookup>
  801646:	83 c4 08             	add    $0x8,%esp
  801649:	89 c2                	mov    %eax,%edx
  80164b:	85 c0                	test   %eax,%eax
  80164d:	78 68                	js     8016b7 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80164f:	83 ec 08             	sub    $0x8,%esp
  801652:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801655:	50                   	push   %eax
  801656:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801659:	ff 30                	pushl  (%eax)
  80165b:	e8 e9 fc ff ff       	call   801349 <dev_lookup>
  801660:	83 c4 10             	add    $0x10,%esp
  801663:	85 c0                	test   %eax,%eax
  801665:	78 47                	js     8016ae <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801667:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80166e:	75 21                	jne    801691 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801670:	a1 08 40 80 00       	mov    0x804008,%eax
  801675:	8b 40 48             	mov    0x48(%eax),%eax
  801678:	83 ec 04             	sub    $0x4,%esp
  80167b:	53                   	push   %ebx
  80167c:	50                   	push   %eax
  80167d:	68 ad 28 80 00       	push   $0x8028ad
  801682:	e8 6e eb ff ff       	call   8001f5 <cprintf>
		return -E_INVAL;
  801687:	83 c4 10             	add    $0x10,%esp
  80168a:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80168f:	eb 26                	jmp    8016b7 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801691:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801694:	8b 52 0c             	mov    0xc(%edx),%edx
  801697:	85 d2                	test   %edx,%edx
  801699:	74 17                	je     8016b2 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80169b:	83 ec 04             	sub    $0x4,%esp
  80169e:	ff 75 10             	pushl  0x10(%ebp)
  8016a1:	ff 75 0c             	pushl  0xc(%ebp)
  8016a4:	50                   	push   %eax
  8016a5:	ff d2                	call   *%edx
  8016a7:	89 c2                	mov    %eax,%edx
  8016a9:	83 c4 10             	add    $0x10,%esp
  8016ac:	eb 09                	jmp    8016b7 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016ae:	89 c2                	mov    %eax,%edx
  8016b0:	eb 05                	jmp    8016b7 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8016b2:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  8016b7:	89 d0                	mov    %edx,%eax
  8016b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

008016be <seek>:

int
seek(int fdnum, off_t offset)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016c4:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8016c7:	50                   	push   %eax
  8016c8:	ff 75 08             	pushl  0x8(%ebp)
  8016cb:	e8 23 fc ff ff       	call   8012f3 <fd_lookup>
  8016d0:	83 c4 08             	add    $0x8,%esp
  8016d3:	85 c0                	test   %eax,%eax
  8016d5:	78 0e                	js     8016e5 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8016d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016dd:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e5:	c9                   	leave  
  8016e6:	c3                   	ret    

008016e7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	53                   	push   %ebx
  8016eb:	83 ec 14             	sub    $0x14,%esp
  8016ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016f4:	50                   	push   %eax
  8016f5:	53                   	push   %ebx
  8016f6:	e8 f8 fb ff ff       	call   8012f3 <fd_lookup>
  8016fb:	83 c4 08             	add    $0x8,%esp
  8016fe:	89 c2                	mov    %eax,%edx
  801700:	85 c0                	test   %eax,%eax
  801702:	78 65                	js     801769 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801704:	83 ec 08             	sub    $0x8,%esp
  801707:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80170a:	50                   	push   %eax
  80170b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170e:	ff 30                	pushl  (%eax)
  801710:	e8 34 fc ff ff       	call   801349 <dev_lookup>
  801715:	83 c4 10             	add    $0x10,%esp
  801718:	85 c0                	test   %eax,%eax
  80171a:	78 44                	js     801760 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80171c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801723:	75 21                	jne    801746 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801725:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80172a:	8b 40 48             	mov    0x48(%eax),%eax
  80172d:	83 ec 04             	sub    $0x4,%esp
  801730:	53                   	push   %ebx
  801731:	50                   	push   %eax
  801732:	68 70 28 80 00       	push   $0x802870
  801737:	e8 b9 ea ff ff       	call   8001f5 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80173c:	83 c4 10             	add    $0x10,%esp
  80173f:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801744:	eb 23                	jmp    801769 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  801746:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801749:	8b 52 18             	mov    0x18(%edx),%edx
  80174c:	85 d2                	test   %edx,%edx
  80174e:	74 14                	je     801764 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801750:	83 ec 08             	sub    $0x8,%esp
  801753:	ff 75 0c             	pushl  0xc(%ebp)
  801756:	50                   	push   %eax
  801757:	ff d2                	call   *%edx
  801759:	89 c2                	mov    %eax,%edx
  80175b:	83 c4 10             	add    $0x10,%esp
  80175e:	eb 09                	jmp    801769 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801760:	89 c2                	mov    %eax,%edx
  801762:	eb 05                	jmp    801769 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801764:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  801769:	89 d0                	mov    %edx,%eax
  80176b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	53                   	push   %ebx
  801774:	83 ec 14             	sub    $0x14,%esp
  801777:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80177a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80177d:	50                   	push   %eax
  80177e:	ff 75 08             	pushl  0x8(%ebp)
  801781:	e8 6d fb ff ff       	call   8012f3 <fd_lookup>
  801786:	83 c4 08             	add    $0x8,%esp
  801789:	89 c2                	mov    %eax,%edx
  80178b:	85 c0                	test   %eax,%eax
  80178d:	78 58                	js     8017e7 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80178f:	83 ec 08             	sub    $0x8,%esp
  801792:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801795:	50                   	push   %eax
  801796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801799:	ff 30                	pushl  (%eax)
  80179b:	e8 a9 fb ff ff       	call   801349 <dev_lookup>
  8017a0:	83 c4 10             	add    $0x10,%esp
  8017a3:	85 c0                	test   %eax,%eax
  8017a5:	78 37                	js     8017de <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  8017a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017aa:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017ae:	74 32                	je     8017e2 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017b0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017b3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017ba:	00 00 00 
	stat->st_isdir = 0;
  8017bd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017c4:	00 00 00 
	stat->st_dev = dev;
  8017c7:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017cd:	83 ec 08             	sub    $0x8,%esp
  8017d0:	53                   	push   %ebx
  8017d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8017d4:	ff 50 14             	call   *0x14(%eax)
  8017d7:	89 c2                	mov    %eax,%edx
  8017d9:	83 c4 10             	add    $0x10,%esp
  8017dc:	eb 09                	jmp    8017e7 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017de:	89 c2                	mov    %eax,%edx
  8017e0:	eb 05                	jmp    8017e7 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8017e2:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8017e7:	89 d0                	mov    %edx,%eax
  8017e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
  8017f1:	56                   	push   %esi
  8017f2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017f3:	83 ec 08             	sub    $0x8,%esp
  8017f6:	6a 00                	push   $0x0
  8017f8:	ff 75 08             	pushl  0x8(%ebp)
  8017fb:	e8 06 02 00 00       	call   801a06 <open>
  801800:	89 c3                	mov    %eax,%ebx
  801802:	83 c4 10             	add    $0x10,%esp
  801805:	85 c0                	test   %eax,%eax
  801807:	78 1b                	js     801824 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801809:	83 ec 08             	sub    $0x8,%esp
  80180c:	ff 75 0c             	pushl  0xc(%ebp)
  80180f:	50                   	push   %eax
  801810:	e8 5b ff ff ff       	call   801770 <fstat>
  801815:	89 c6                	mov    %eax,%esi
	close(fd);
  801817:	89 1c 24             	mov    %ebx,(%esp)
  80181a:	e8 fd fb ff ff       	call   80141c <close>
	return r;
  80181f:	83 c4 10             	add    $0x10,%esp
  801822:	89 f0                	mov    %esi,%eax
}
  801824:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801827:	5b                   	pop    %ebx
  801828:	5e                   	pop    %esi
  801829:	5d                   	pop    %ebp
  80182a:	c3                   	ret    

0080182b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	56                   	push   %esi
  80182f:	53                   	push   %ebx
  801830:	89 c6                	mov    %eax,%esi
  801832:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801834:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80183b:	75 12                	jne    80184f <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80183d:	83 ec 0c             	sub    $0xc,%esp
  801840:	6a 01                	push   $0x1
  801842:	e8 fc f9 ff ff       	call   801243 <ipc_find_env>
  801847:	a3 00 40 80 00       	mov    %eax,0x804000
  80184c:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80184f:	6a 07                	push   $0x7
  801851:	68 00 50 80 00       	push   $0x805000
  801856:	56                   	push   %esi
  801857:	ff 35 00 40 80 00    	pushl  0x804000
  80185d:	e8 8d f9 ff ff       	call   8011ef <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801862:	83 c4 0c             	add    $0xc,%esp
  801865:	6a 00                	push   $0x0
  801867:	53                   	push   %ebx
  801868:	6a 00                	push   $0x0
  80186a:	e8 15 f9 ff ff       	call   801184 <ipc_recv>
}
  80186f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801872:	5b                   	pop    %ebx
  801873:	5e                   	pop    %esi
  801874:	5d                   	pop    %ebp
  801875:	c3                   	ret    

00801876 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80187c:	8b 45 08             	mov    0x8(%ebp),%eax
  80187f:	8b 40 0c             	mov    0xc(%eax),%eax
  801882:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801887:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188a:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80188f:	ba 00 00 00 00       	mov    $0x0,%edx
  801894:	b8 02 00 00 00       	mov    $0x2,%eax
  801899:	e8 8d ff ff ff       	call   80182b <fsipc>
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ac:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b6:	b8 06 00 00 00       	mov    $0x6,%eax
  8018bb:	e8 6b ff ff ff       	call   80182b <fsipc>
}
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
  8018c5:	53                   	push   %ebx
  8018c6:	83 ec 04             	sub    $0x4,%esp
  8018c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8018d2:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018dc:	b8 05 00 00 00       	mov    $0x5,%eax
  8018e1:	e8 45 ff ff ff       	call   80182b <fsipc>
  8018e6:	85 c0                	test   %eax,%eax
  8018e8:	78 2c                	js     801916 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018ea:	83 ec 08             	sub    $0x8,%esp
  8018ed:	68 00 50 80 00       	push   $0x805000
  8018f2:	53                   	push   %ebx
  8018f3:	e8 6f ee ff ff       	call   800767 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018f8:	a1 80 50 80 00       	mov    0x805080,%eax
  8018fd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801903:	a1 84 50 80 00       	mov    0x805084,%eax
  801908:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80190e:	83 c4 10             	add    $0x10,%esp
  801911:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801916:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	83 ec 08             	sub    $0x8,%esp
  801921:	8b 55 0c             	mov    0xc(%ebp),%edx
  801924:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801927:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80192a:	8b 49 0c             	mov    0xc(%ecx),%ecx
  80192d:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  801933:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801938:	76 22                	jbe    80195c <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  80193a:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  801941:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  801944:	83 ec 04             	sub    $0x4,%esp
  801947:	68 f8 0f 00 00       	push   $0xff8
  80194c:	52                   	push   %edx
  80194d:	68 08 50 80 00       	push   $0x805008
  801952:	e8 a3 ef ff ff       	call   8008fa <memmove>
  801957:	83 c4 10             	add    $0x10,%esp
  80195a:	eb 17                	jmp    801973 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  80195c:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  801961:	83 ec 04             	sub    $0x4,%esp
  801964:	50                   	push   %eax
  801965:	52                   	push   %edx
  801966:	68 08 50 80 00       	push   $0x805008
  80196b:	e8 8a ef ff ff       	call   8008fa <memmove>
  801970:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  801973:	ba 00 00 00 00       	mov    $0x0,%edx
  801978:	b8 04 00 00 00       	mov    $0x4,%eax
  80197d:	e8 a9 fe ff ff       	call   80182b <fsipc>
	if (result < 0)
		return result;

	return result;
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	56                   	push   %esi
  801988:	53                   	push   %ebx
  801989:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	8b 40 0c             	mov    0xc(%eax),%eax
  801992:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801997:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80199d:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a2:	b8 03 00 00 00       	mov    $0x3,%eax
  8019a7:	e8 7f fe ff ff       	call   80182b <fsipc>
  8019ac:	89 c3                	mov    %eax,%ebx
  8019ae:	85 c0                	test   %eax,%eax
  8019b0:	78 4b                	js     8019fd <devfile_read+0x79>
		return r;
	assert(r <= n);
  8019b2:	39 c6                	cmp    %eax,%esi
  8019b4:	73 16                	jae    8019cc <devfile_read+0x48>
  8019b6:	68 dc 28 80 00       	push   $0x8028dc
  8019bb:	68 e3 28 80 00       	push   $0x8028e3
  8019c0:	6a 7c                	push   $0x7c
  8019c2:	68 f8 28 80 00       	push   $0x8028f8
  8019c7:	e8 bd 05 00 00       	call   801f89 <_panic>
	assert(r <= PGSIZE);
  8019cc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019d1:	7e 16                	jle    8019e9 <devfile_read+0x65>
  8019d3:	68 03 29 80 00       	push   $0x802903
  8019d8:	68 e3 28 80 00       	push   $0x8028e3
  8019dd:	6a 7d                	push   $0x7d
  8019df:	68 f8 28 80 00       	push   $0x8028f8
  8019e4:	e8 a0 05 00 00       	call   801f89 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019e9:	83 ec 04             	sub    $0x4,%esp
  8019ec:	50                   	push   %eax
  8019ed:	68 00 50 80 00       	push   $0x805000
  8019f2:	ff 75 0c             	pushl  0xc(%ebp)
  8019f5:	e8 00 ef ff ff       	call   8008fa <memmove>
	return r;
  8019fa:	83 c4 10             	add    $0x10,%esp
}
  8019fd:	89 d8                	mov    %ebx,%eax
  8019ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a02:	5b                   	pop    %ebx
  801a03:	5e                   	pop    %esi
  801a04:	5d                   	pop    %ebp
  801a05:	c3                   	ret    

00801a06 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	53                   	push   %ebx
  801a0a:	83 ec 20             	sub    $0x20,%esp
  801a0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801a10:	53                   	push   %ebx
  801a11:	e8 18 ed ff ff       	call   80072e <strlen>
  801a16:	83 c4 10             	add    $0x10,%esp
  801a19:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a1e:	7f 67                	jg     801a87 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801a20:	83 ec 0c             	sub    $0xc,%esp
  801a23:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a26:	50                   	push   %eax
  801a27:	e8 78 f8 ff ff       	call   8012a4 <fd_alloc>
  801a2c:	83 c4 10             	add    $0x10,%esp
		return r;
  801a2f:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801a31:	85 c0                	test   %eax,%eax
  801a33:	78 57                	js     801a8c <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801a35:	83 ec 08             	sub    $0x8,%esp
  801a38:	53                   	push   %ebx
  801a39:	68 00 50 80 00       	push   $0x805000
  801a3e:	e8 24 ed ff ff       	call   800767 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a43:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a46:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a53:	e8 d3 fd ff ff       	call   80182b <fsipc>
  801a58:	89 c3                	mov    %eax,%ebx
  801a5a:	83 c4 10             	add    $0x10,%esp
  801a5d:	85 c0                	test   %eax,%eax
  801a5f:	79 14                	jns    801a75 <open+0x6f>
		fd_close(fd, 0);
  801a61:	83 ec 08             	sub    $0x8,%esp
  801a64:	6a 00                	push   $0x0
  801a66:	ff 75 f4             	pushl  -0xc(%ebp)
  801a69:	e8 2e f9 ff ff       	call   80139c <fd_close>
		return r;
  801a6e:	83 c4 10             	add    $0x10,%esp
  801a71:	89 da                	mov    %ebx,%edx
  801a73:	eb 17                	jmp    801a8c <open+0x86>
	}

	return fd2num(fd);
  801a75:	83 ec 0c             	sub    $0xc,%esp
  801a78:	ff 75 f4             	pushl  -0xc(%ebp)
  801a7b:	e8 fc f7 ff ff       	call   80127c <fd2num>
  801a80:	89 c2                	mov    %eax,%edx
  801a82:	83 c4 10             	add    $0x10,%esp
  801a85:	eb 05                	jmp    801a8c <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801a87:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801a8c:	89 d0                	mov    %edx,%eax
  801a8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a99:	ba 00 00 00 00       	mov    $0x0,%edx
  801a9e:	b8 08 00 00 00       	mov    $0x8,%eax
  801aa3:	e8 83 fd ff ff       	call   80182b <fsipc>
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	56                   	push   %esi
  801aae:	53                   	push   %ebx
  801aaf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ab2:	83 ec 0c             	sub    $0xc,%esp
  801ab5:	ff 75 08             	pushl  0x8(%ebp)
  801ab8:	e8 cf f7 ff ff       	call   80128c <fd2data>
  801abd:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801abf:	83 c4 08             	add    $0x8,%esp
  801ac2:	68 0f 29 80 00       	push   $0x80290f
  801ac7:	53                   	push   %ebx
  801ac8:	e8 9a ec ff ff       	call   800767 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801acd:	8b 46 04             	mov    0x4(%esi),%eax
  801ad0:	2b 06                	sub    (%esi),%eax
  801ad2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ad8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801adf:	00 00 00 
	stat->st_dev = &devpipe;
  801ae2:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801ae9:	30 80 00 
	return 0;
}
  801aec:	b8 00 00 00 00       	mov    $0x0,%eax
  801af1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801af4:	5b                   	pop    %ebx
  801af5:	5e                   	pop    %esi
  801af6:	5d                   	pop    %ebp
  801af7:	c3                   	ret    

00801af8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	53                   	push   %ebx
  801afc:	83 ec 0c             	sub    $0xc,%esp
  801aff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b02:	53                   	push   %ebx
  801b03:	6a 00                	push   $0x0
  801b05:	e8 f0 f0 ff ff       	call   800bfa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b0a:	89 1c 24             	mov    %ebx,(%esp)
  801b0d:	e8 7a f7 ff ff       	call   80128c <fd2data>
  801b12:	83 c4 08             	add    $0x8,%esp
  801b15:	50                   	push   %eax
  801b16:	6a 00                	push   $0x0
  801b18:	e8 dd f0 ff ff       	call   800bfa <sys_page_unmap>
}
  801b1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
  801b25:	57                   	push   %edi
  801b26:	56                   	push   %esi
  801b27:	53                   	push   %ebx
  801b28:	83 ec 1c             	sub    $0x1c,%esp
  801b2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801b2e:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801b30:	a1 08 40 80 00       	mov    0x804008,%eax
  801b35:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801b38:	83 ec 0c             	sub    $0xc,%esp
  801b3b:	ff 75 e0             	pushl  -0x20(%ebp)
  801b3e:	e8 1f 05 00 00       	call   802062 <pageref>
  801b43:	89 c3                	mov    %eax,%ebx
  801b45:	89 3c 24             	mov    %edi,(%esp)
  801b48:	e8 15 05 00 00       	call   802062 <pageref>
  801b4d:	83 c4 10             	add    $0x10,%esp
  801b50:	39 c3                	cmp    %eax,%ebx
  801b52:	0f 94 c1             	sete   %cl
  801b55:	0f b6 c9             	movzbl %cl,%ecx
  801b58:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801b5b:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801b61:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b64:	39 ce                	cmp    %ecx,%esi
  801b66:	74 1b                	je     801b83 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801b68:	39 c3                	cmp    %eax,%ebx
  801b6a:	75 c4                	jne    801b30 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b6c:	8b 42 58             	mov    0x58(%edx),%eax
  801b6f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b72:	50                   	push   %eax
  801b73:	56                   	push   %esi
  801b74:	68 16 29 80 00       	push   $0x802916
  801b79:	e8 77 e6 ff ff       	call   8001f5 <cprintf>
  801b7e:	83 c4 10             	add    $0x10,%esp
  801b81:	eb ad                	jmp    801b30 <_pipeisclosed+0xe>
	}
}
  801b83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b89:	5b                   	pop    %ebx
  801b8a:	5e                   	pop    %esi
  801b8b:	5f                   	pop    %edi
  801b8c:	5d                   	pop    %ebp
  801b8d:	c3                   	ret    

00801b8e <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
  801b91:	57                   	push   %edi
  801b92:	56                   	push   %esi
  801b93:	53                   	push   %ebx
  801b94:	83 ec 28             	sub    $0x28,%esp
  801b97:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801b9a:	56                   	push   %esi
  801b9b:	e8 ec f6 ff ff       	call   80128c <fd2data>
  801ba0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ba2:	83 c4 10             	add    $0x10,%esp
  801ba5:	bf 00 00 00 00       	mov    $0x0,%edi
  801baa:	eb 4b                	jmp    801bf7 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801bac:	89 da                	mov    %ebx,%edx
  801bae:	89 f0                	mov    %esi,%eax
  801bb0:	e8 6d ff ff ff       	call   801b22 <_pipeisclosed>
  801bb5:	85 c0                	test   %eax,%eax
  801bb7:	75 48                	jne    801c01 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801bb9:	e8 cb ef ff ff       	call   800b89 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bbe:	8b 43 04             	mov    0x4(%ebx),%eax
  801bc1:	8b 0b                	mov    (%ebx),%ecx
  801bc3:	8d 51 20             	lea    0x20(%ecx),%edx
  801bc6:	39 d0                	cmp    %edx,%eax
  801bc8:	73 e2                	jae    801bac <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bcd:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801bd1:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801bd4:	89 c2                	mov    %eax,%edx
  801bd6:	c1 fa 1f             	sar    $0x1f,%edx
  801bd9:	89 d1                	mov    %edx,%ecx
  801bdb:	c1 e9 1b             	shr    $0x1b,%ecx
  801bde:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801be1:	83 e2 1f             	and    $0x1f,%edx
  801be4:	29 ca                	sub    %ecx,%edx
  801be6:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801bea:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801bee:	83 c0 01             	add    $0x1,%eax
  801bf1:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801bf4:	83 c7 01             	add    $0x1,%edi
  801bf7:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bfa:	75 c2                	jne    801bbe <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801bfc:	8b 45 10             	mov    0x10(%ebp),%eax
  801bff:	eb 05                	jmp    801c06 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801c01:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801c06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c09:	5b                   	pop    %ebx
  801c0a:	5e                   	pop    %esi
  801c0b:	5f                   	pop    %edi
  801c0c:	5d                   	pop    %ebp
  801c0d:	c3                   	ret    

00801c0e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	57                   	push   %edi
  801c12:	56                   	push   %esi
  801c13:	53                   	push   %ebx
  801c14:	83 ec 18             	sub    $0x18,%esp
  801c17:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801c1a:	57                   	push   %edi
  801c1b:	e8 6c f6 ff ff       	call   80128c <fd2data>
  801c20:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c22:	83 c4 10             	add    $0x10,%esp
  801c25:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c2a:	eb 3d                	jmp    801c69 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801c2c:	85 db                	test   %ebx,%ebx
  801c2e:	74 04                	je     801c34 <devpipe_read+0x26>
				return i;
  801c30:	89 d8                	mov    %ebx,%eax
  801c32:	eb 44                	jmp    801c78 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801c34:	89 f2                	mov    %esi,%edx
  801c36:	89 f8                	mov    %edi,%eax
  801c38:	e8 e5 fe ff ff       	call   801b22 <_pipeisclosed>
  801c3d:	85 c0                	test   %eax,%eax
  801c3f:	75 32                	jne    801c73 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801c41:	e8 43 ef ff ff       	call   800b89 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801c46:	8b 06                	mov    (%esi),%eax
  801c48:	3b 46 04             	cmp    0x4(%esi),%eax
  801c4b:	74 df                	je     801c2c <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c4d:	99                   	cltd   
  801c4e:	c1 ea 1b             	shr    $0x1b,%edx
  801c51:	01 d0                	add    %edx,%eax
  801c53:	83 e0 1f             	and    $0x1f,%eax
  801c56:	29 d0                	sub    %edx,%eax
  801c58:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801c5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c60:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801c63:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c66:	83 c3 01             	add    $0x1,%ebx
  801c69:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801c6c:	75 d8                	jne    801c46 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801c6e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c71:	eb 05                	jmp    801c78 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801c73:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801c78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c7b:	5b                   	pop    %ebx
  801c7c:	5e                   	pop    %esi
  801c7d:	5f                   	pop    %edi
  801c7e:	5d                   	pop    %ebp
  801c7f:	c3                   	ret    

00801c80 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	56                   	push   %esi
  801c84:	53                   	push   %ebx
  801c85:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801c88:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c8b:	50                   	push   %eax
  801c8c:	e8 13 f6 ff ff       	call   8012a4 <fd_alloc>
  801c91:	83 c4 10             	add    $0x10,%esp
  801c94:	89 c2                	mov    %eax,%edx
  801c96:	85 c0                	test   %eax,%eax
  801c98:	0f 88 2c 01 00 00    	js     801dca <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c9e:	83 ec 04             	sub    $0x4,%esp
  801ca1:	68 07 04 00 00       	push   $0x407
  801ca6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca9:	6a 00                	push   $0x0
  801cab:	e8 00 ef ff ff       	call   800bb0 <sys_page_alloc>
  801cb0:	83 c4 10             	add    $0x10,%esp
  801cb3:	89 c2                	mov    %eax,%edx
  801cb5:	85 c0                	test   %eax,%eax
  801cb7:	0f 88 0d 01 00 00    	js     801dca <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801cbd:	83 ec 0c             	sub    $0xc,%esp
  801cc0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cc3:	50                   	push   %eax
  801cc4:	e8 db f5 ff ff       	call   8012a4 <fd_alloc>
  801cc9:	89 c3                	mov    %eax,%ebx
  801ccb:	83 c4 10             	add    $0x10,%esp
  801cce:	85 c0                	test   %eax,%eax
  801cd0:	0f 88 e2 00 00 00    	js     801db8 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cd6:	83 ec 04             	sub    $0x4,%esp
  801cd9:	68 07 04 00 00       	push   $0x407
  801cde:	ff 75 f0             	pushl  -0x10(%ebp)
  801ce1:	6a 00                	push   $0x0
  801ce3:	e8 c8 ee ff ff       	call   800bb0 <sys_page_alloc>
  801ce8:	89 c3                	mov    %eax,%ebx
  801cea:	83 c4 10             	add    $0x10,%esp
  801ced:	85 c0                	test   %eax,%eax
  801cef:	0f 88 c3 00 00 00    	js     801db8 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801cf5:	83 ec 0c             	sub    $0xc,%esp
  801cf8:	ff 75 f4             	pushl  -0xc(%ebp)
  801cfb:	e8 8c f5 ff ff       	call   80128c <fd2data>
  801d00:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d02:	83 c4 0c             	add    $0xc,%esp
  801d05:	68 07 04 00 00       	push   $0x407
  801d0a:	50                   	push   %eax
  801d0b:	6a 00                	push   $0x0
  801d0d:	e8 9e ee ff ff       	call   800bb0 <sys_page_alloc>
  801d12:	89 c3                	mov    %eax,%ebx
  801d14:	83 c4 10             	add    $0x10,%esp
  801d17:	85 c0                	test   %eax,%eax
  801d19:	0f 88 89 00 00 00    	js     801da8 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d1f:	83 ec 0c             	sub    $0xc,%esp
  801d22:	ff 75 f0             	pushl  -0x10(%ebp)
  801d25:	e8 62 f5 ff ff       	call   80128c <fd2data>
  801d2a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d31:	50                   	push   %eax
  801d32:	6a 00                	push   $0x0
  801d34:	56                   	push   %esi
  801d35:	6a 00                	push   $0x0
  801d37:	e8 98 ee ff ff       	call   800bd4 <sys_page_map>
  801d3c:	89 c3                	mov    %eax,%ebx
  801d3e:	83 c4 20             	add    $0x20,%esp
  801d41:	85 c0                	test   %eax,%eax
  801d43:	78 55                	js     801d9a <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801d45:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4e:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d53:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801d5a:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d63:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d68:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801d6f:	83 ec 0c             	sub    $0xc,%esp
  801d72:	ff 75 f4             	pushl  -0xc(%ebp)
  801d75:	e8 02 f5 ff ff       	call   80127c <fd2num>
  801d7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d7d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d7f:	83 c4 04             	add    $0x4,%esp
  801d82:	ff 75 f0             	pushl  -0x10(%ebp)
  801d85:	e8 f2 f4 ff ff       	call   80127c <fd2num>
  801d8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d8d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d90:	83 c4 10             	add    $0x10,%esp
  801d93:	ba 00 00 00 00       	mov    $0x0,%edx
  801d98:	eb 30                	jmp    801dca <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801d9a:	83 ec 08             	sub    $0x8,%esp
  801d9d:	56                   	push   %esi
  801d9e:	6a 00                	push   $0x0
  801da0:	e8 55 ee ff ff       	call   800bfa <sys_page_unmap>
  801da5:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801da8:	83 ec 08             	sub    $0x8,%esp
  801dab:	ff 75 f0             	pushl  -0x10(%ebp)
  801dae:	6a 00                	push   $0x0
  801db0:	e8 45 ee ff ff       	call   800bfa <sys_page_unmap>
  801db5:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801db8:	83 ec 08             	sub    $0x8,%esp
  801dbb:	ff 75 f4             	pushl  -0xc(%ebp)
  801dbe:	6a 00                	push   $0x0
  801dc0:	e8 35 ee ff ff       	call   800bfa <sys_page_unmap>
  801dc5:	83 c4 10             	add    $0x10,%esp
  801dc8:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  801dca:	89 d0                	mov    %edx,%eax
  801dcc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dcf:	5b                   	pop    %ebx
  801dd0:	5e                   	pop    %esi
  801dd1:	5d                   	pop    %ebp
  801dd2:	c3                   	ret    

00801dd3 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dd9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ddc:	50                   	push   %eax
  801ddd:	ff 75 08             	pushl  0x8(%ebp)
  801de0:	e8 0e f5 ff ff       	call   8012f3 <fd_lookup>
  801de5:	83 c4 10             	add    $0x10,%esp
  801de8:	85 c0                	test   %eax,%eax
  801dea:	78 18                	js     801e04 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801dec:	83 ec 0c             	sub    $0xc,%esp
  801def:	ff 75 f4             	pushl  -0xc(%ebp)
  801df2:	e8 95 f4 ff ff       	call   80128c <fd2data>
	return _pipeisclosed(fd, p);
  801df7:	89 c2                	mov    %eax,%edx
  801df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfc:	e8 21 fd ff ff       	call   801b22 <_pipeisclosed>
  801e01:	83 c4 10             	add    $0x10,%esp
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801e09:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0e:	5d                   	pop    %ebp
  801e0f:	c3                   	ret    

00801e10 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e16:	68 2e 29 80 00       	push   $0x80292e
  801e1b:	ff 75 0c             	pushl  0xc(%ebp)
  801e1e:	e8 44 e9 ff ff       	call   800767 <strcpy>
	return 0;
}
  801e23:	b8 00 00 00 00       	mov    $0x0,%eax
  801e28:	c9                   	leave  
  801e29:	c3                   	ret    

00801e2a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	57                   	push   %edi
  801e2e:	56                   	push   %esi
  801e2f:	53                   	push   %ebx
  801e30:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e36:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801e3b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e41:	eb 2d                	jmp    801e70 <devcons_write+0x46>
		m = n - tot;
  801e43:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e46:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801e48:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801e4b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801e50:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801e53:	83 ec 04             	sub    $0x4,%esp
  801e56:	53                   	push   %ebx
  801e57:	03 45 0c             	add    0xc(%ebp),%eax
  801e5a:	50                   	push   %eax
  801e5b:	57                   	push   %edi
  801e5c:	e8 99 ea ff ff       	call   8008fa <memmove>
		sys_cputs(buf, m);
  801e61:	83 c4 08             	add    $0x8,%esp
  801e64:	53                   	push   %ebx
  801e65:	57                   	push   %edi
  801e66:	e8 8e ec ff ff       	call   800af9 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e6b:	01 de                	add    %ebx,%esi
  801e6d:	83 c4 10             	add    $0x10,%esp
  801e70:	89 f0                	mov    %esi,%eax
  801e72:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e75:	72 cc                	jb     801e43 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801e77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e7a:	5b                   	pop    %ebx
  801e7b:	5e                   	pop    %esi
  801e7c:	5f                   	pop    %edi
  801e7d:	5d                   	pop    %ebp
  801e7e:	c3                   	ret    

00801e7f <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	83 ec 08             	sub    $0x8,%esp
  801e85:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801e8a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e8e:	74 2a                	je     801eba <devcons_read+0x3b>
  801e90:	eb 05                	jmp    801e97 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801e92:	e8 f2 ec ff ff       	call   800b89 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801e97:	e8 83 ec ff ff       	call   800b1f <sys_cgetc>
  801e9c:	85 c0                	test   %eax,%eax
  801e9e:	74 f2                	je     801e92 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801ea0:	85 c0                	test   %eax,%eax
  801ea2:	78 16                	js     801eba <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801ea4:	83 f8 04             	cmp    $0x4,%eax
  801ea7:	74 0c                	je     801eb5 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801ea9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eac:	88 02                	mov    %al,(%edx)
	return 1;
  801eae:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb3:	eb 05                	jmp    801eba <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801eb5:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801eba:	c9                   	leave  
  801ebb:	c3                   	ret    

00801ebc <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
  801ebf:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec5:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801ec8:	6a 01                	push   $0x1
  801eca:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ecd:	50                   	push   %eax
  801ece:	e8 26 ec ff ff       	call   800af9 <sys_cputs>
}
  801ed3:	83 c4 10             	add    $0x10,%esp
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <getchar>:

int
getchar(void)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
  801edb:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801ede:	6a 01                	push   $0x1
  801ee0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ee3:	50                   	push   %eax
  801ee4:	6a 00                	push   $0x0
  801ee6:	e8 6d f6 ff ff       	call   801558 <read>
	if (r < 0)
  801eeb:	83 c4 10             	add    $0x10,%esp
  801eee:	85 c0                	test   %eax,%eax
  801ef0:	78 0f                	js     801f01 <getchar+0x29>
		return r;
	if (r < 1)
  801ef2:	85 c0                	test   %eax,%eax
  801ef4:	7e 06                	jle    801efc <getchar+0x24>
		return -E_EOF;
	return c;
  801ef6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801efa:	eb 05                	jmp    801f01 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801efc:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
  801f06:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f09:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f0c:	50                   	push   %eax
  801f0d:	ff 75 08             	pushl  0x8(%ebp)
  801f10:	e8 de f3 ff ff       	call   8012f3 <fd_lookup>
  801f15:	83 c4 10             	add    $0x10,%esp
  801f18:	85 c0                	test   %eax,%eax
  801f1a:	78 11                	js     801f2d <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f25:	39 10                	cmp    %edx,(%eax)
  801f27:	0f 94 c0             	sete   %al
  801f2a:	0f b6 c0             	movzbl %al,%eax
}
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <opencons>:

int
opencons(void)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
  801f32:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801f35:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f38:	50                   	push   %eax
  801f39:	e8 66 f3 ff ff       	call   8012a4 <fd_alloc>
  801f3e:	83 c4 10             	add    $0x10,%esp
		return r;
  801f41:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801f43:	85 c0                	test   %eax,%eax
  801f45:	78 3e                	js     801f85 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f47:	83 ec 04             	sub    $0x4,%esp
  801f4a:	68 07 04 00 00       	push   $0x407
  801f4f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f52:	6a 00                	push   $0x0
  801f54:	e8 57 ec ff ff       	call   800bb0 <sys_page_alloc>
  801f59:	83 c4 10             	add    $0x10,%esp
		return r;
  801f5c:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f5e:	85 c0                	test   %eax,%eax
  801f60:	78 23                	js     801f85 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801f62:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f70:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f77:	83 ec 0c             	sub    $0xc,%esp
  801f7a:	50                   	push   %eax
  801f7b:	e8 fc f2 ff ff       	call   80127c <fd2num>
  801f80:	89 c2                	mov    %eax,%edx
  801f82:	83 c4 10             	add    $0x10,%esp
}
  801f85:	89 d0                	mov    %edx,%eax
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	56                   	push   %esi
  801f8d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801f8e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801f91:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801f97:	e8 c9 eb ff ff       	call   800b65 <sys_getenvid>
  801f9c:	83 ec 0c             	sub    $0xc,%esp
  801f9f:	ff 75 0c             	pushl  0xc(%ebp)
  801fa2:	ff 75 08             	pushl  0x8(%ebp)
  801fa5:	56                   	push   %esi
  801fa6:	50                   	push   %eax
  801fa7:	68 3c 29 80 00       	push   $0x80293c
  801fac:	e8 44 e2 ff ff       	call   8001f5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801fb1:	83 c4 18             	add    $0x18,%esp
  801fb4:	53                   	push   %ebx
  801fb5:	ff 75 10             	pushl  0x10(%ebp)
  801fb8:	e8 e7 e1 ff ff       	call   8001a4 <vcprintf>
	cprintf("\n");
  801fbd:	c7 04 24 27 29 80 00 	movl   $0x802927,(%esp)
  801fc4:	e8 2c e2 ff ff       	call   8001f5 <cprintf>
  801fc9:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801fcc:	cc                   	int3   
  801fcd:	eb fd                	jmp    801fcc <_panic+0x43>

00801fcf <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801fd5:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801fdc:	75 2c                	jne    80200a <set_pgfault_handler+0x3b>
		// First time through!
		// LAB 4: Your code here.
		r = sys_page_alloc(0,(void *)(UXSTACKTOP - PGSIZE),PTE_P | PTE_U | PTE_W);
  801fde:	83 ec 04             	sub    $0x4,%esp
  801fe1:	6a 07                	push   $0x7
  801fe3:	68 00 f0 bf ee       	push   $0xeebff000
  801fe8:	6a 00                	push   $0x0
  801fea:	e8 c1 eb ff ff       	call   800bb0 <sys_page_alloc>
		if(r < 0)
  801fef:	83 c4 10             	add    $0x10,%esp
  801ff2:	85 c0                	test   %eax,%eax
  801ff4:	79 14                	jns    80200a <set_pgfault_handler+0x3b>
			panic("set_pgfault_handler: error in sys_page_alloc\n");	
  801ff6:	83 ec 04             	sub    $0x4,%esp
  801ff9:	68 60 29 80 00       	push   $0x802960
  801ffe:	6a 22                	push   $0x22
  802000:	68 cc 29 80 00       	push   $0x8029cc
  802005:	e8 7f ff ff ff       	call   801f89 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80200a:	8b 45 08             	mov    0x8(%ebp),%eax
  80200d:	a3 00 60 80 00       	mov    %eax,0x806000
	r = sys_env_set_pgfault_upcall(0, _pgfault_upcall); 
  802012:	83 ec 08             	sub    $0x8,%esp
  802015:	68 3e 20 80 00       	push   $0x80203e
  80201a:	6a 00                	push   $0x0
  80201c:	e8 42 ec ff ff       	call   800c63 <sys_env_set_pgfault_upcall>
	if (r < 0)
  802021:	83 c4 10             	add    $0x10,%esp
  802024:	85 c0                	test   %eax,%eax
  802026:	79 14                	jns    80203c <set_pgfault_handler+0x6d>
		panic("set_pgfault_handler: error in sys_env_set_pgfault_upcall");
  802028:	83 ec 04             	sub    $0x4,%esp
  80202b:	68 90 29 80 00       	push   $0x802990
  802030:	6a 29                	push   $0x29
  802032:	68 cc 29 80 00       	push   $0x8029cc
  802037:	e8 4d ff ff ff       	call   801f89 <_panic>
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80203e:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80203f:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802044:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802046:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	subl $0x4, 0x30(%esp)
  802049:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  80204e:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 0x28(%esp), %ebx 	
  802052:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  802056:	89 18                	mov    %ebx,(%eax)
	addl $0x8, %esp
  802058:	83 c4 08             	add    $0x8,%esp


	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  80205b:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp 
  80205c:	83 c4 04             	add    $0x4,%esp
	popfl
  80205f:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802060:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802061:	c3                   	ret    

00802062 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
  802065:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802068:	89 d0                	mov    %edx,%eax
  80206a:	c1 e8 16             	shr    $0x16,%eax
  80206d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802074:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802079:	f6 c1 01             	test   $0x1,%cl
  80207c:	74 1d                	je     80209b <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80207e:	c1 ea 0c             	shr    $0xc,%edx
  802081:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802088:	f6 c2 01             	test   $0x1,%dl
  80208b:	74 0e                	je     80209b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80208d:	c1 ea 0c             	shr    $0xc,%edx
  802090:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802097:	ef 
  802098:	0f b7 c0             	movzwl %ax,%eax
}
  80209b:	5d                   	pop    %ebp
  80209c:	c3                   	ret    
  80209d:	66 90                	xchg   %ax,%ax
  80209f:	90                   	nop

008020a0 <__udivdi3>:
  8020a0:	55                   	push   %ebp
  8020a1:	57                   	push   %edi
  8020a2:	56                   	push   %esi
  8020a3:	53                   	push   %ebx
  8020a4:	83 ec 1c             	sub    $0x1c,%esp
  8020a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8020ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8020af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8020b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020b7:	85 f6                	test   %esi,%esi
  8020b9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020bd:	89 ca                	mov    %ecx,%edx
  8020bf:	89 f8                	mov    %edi,%eax
  8020c1:	75 3d                	jne    802100 <__udivdi3+0x60>
  8020c3:	39 cf                	cmp    %ecx,%edi
  8020c5:	0f 87 c5 00 00 00    	ja     802190 <__udivdi3+0xf0>
  8020cb:	85 ff                	test   %edi,%edi
  8020cd:	89 fd                	mov    %edi,%ebp
  8020cf:	75 0b                	jne    8020dc <__udivdi3+0x3c>
  8020d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8020d6:	31 d2                	xor    %edx,%edx
  8020d8:	f7 f7                	div    %edi
  8020da:	89 c5                	mov    %eax,%ebp
  8020dc:	89 c8                	mov    %ecx,%eax
  8020de:	31 d2                	xor    %edx,%edx
  8020e0:	f7 f5                	div    %ebp
  8020e2:	89 c1                	mov    %eax,%ecx
  8020e4:	89 d8                	mov    %ebx,%eax
  8020e6:	89 cf                	mov    %ecx,%edi
  8020e8:	f7 f5                	div    %ebp
  8020ea:	89 c3                	mov    %eax,%ebx
  8020ec:	89 d8                	mov    %ebx,%eax
  8020ee:	89 fa                	mov    %edi,%edx
  8020f0:	83 c4 1c             	add    $0x1c,%esp
  8020f3:	5b                   	pop    %ebx
  8020f4:	5e                   	pop    %esi
  8020f5:	5f                   	pop    %edi
  8020f6:	5d                   	pop    %ebp
  8020f7:	c3                   	ret    
  8020f8:	90                   	nop
  8020f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802100:	39 ce                	cmp    %ecx,%esi
  802102:	77 74                	ja     802178 <__udivdi3+0xd8>
  802104:	0f bd fe             	bsr    %esi,%edi
  802107:	83 f7 1f             	xor    $0x1f,%edi
  80210a:	0f 84 98 00 00 00    	je     8021a8 <__udivdi3+0x108>
  802110:	bb 20 00 00 00       	mov    $0x20,%ebx
  802115:	89 f9                	mov    %edi,%ecx
  802117:	89 c5                	mov    %eax,%ebp
  802119:	29 fb                	sub    %edi,%ebx
  80211b:	d3 e6                	shl    %cl,%esi
  80211d:	89 d9                	mov    %ebx,%ecx
  80211f:	d3 ed                	shr    %cl,%ebp
  802121:	89 f9                	mov    %edi,%ecx
  802123:	d3 e0                	shl    %cl,%eax
  802125:	09 ee                	or     %ebp,%esi
  802127:	89 d9                	mov    %ebx,%ecx
  802129:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80212d:	89 d5                	mov    %edx,%ebp
  80212f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802133:	d3 ed                	shr    %cl,%ebp
  802135:	89 f9                	mov    %edi,%ecx
  802137:	d3 e2                	shl    %cl,%edx
  802139:	89 d9                	mov    %ebx,%ecx
  80213b:	d3 e8                	shr    %cl,%eax
  80213d:	09 c2                	or     %eax,%edx
  80213f:	89 d0                	mov    %edx,%eax
  802141:	89 ea                	mov    %ebp,%edx
  802143:	f7 f6                	div    %esi
  802145:	89 d5                	mov    %edx,%ebp
  802147:	89 c3                	mov    %eax,%ebx
  802149:	f7 64 24 0c          	mull   0xc(%esp)
  80214d:	39 d5                	cmp    %edx,%ebp
  80214f:	72 10                	jb     802161 <__udivdi3+0xc1>
  802151:	8b 74 24 08          	mov    0x8(%esp),%esi
  802155:	89 f9                	mov    %edi,%ecx
  802157:	d3 e6                	shl    %cl,%esi
  802159:	39 c6                	cmp    %eax,%esi
  80215b:	73 07                	jae    802164 <__udivdi3+0xc4>
  80215d:	39 d5                	cmp    %edx,%ebp
  80215f:	75 03                	jne    802164 <__udivdi3+0xc4>
  802161:	83 eb 01             	sub    $0x1,%ebx
  802164:	31 ff                	xor    %edi,%edi
  802166:	89 d8                	mov    %ebx,%eax
  802168:	89 fa                	mov    %edi,%edx
  80216a:	83 c4 1c             	add    $0x1c,%esp
  80216d:	5b                   	pop    %ebx
  80216e:	5e                   	pop    %esi
  80216f:	5f                   	pop    %edi
  802170:	5d                   	pop    %ebp
  802171:	c3                   	ret    
  802172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802178:	31 ff                	xor    %edi,%edi
  80217a:	31 db                	xor    %ebx,%ebx
  80217c:	89 d8                	mov    %ebx,%eax
  80217e:	89 fa                	mov    %edi,%edx
  802180:	83 c4 1c             	add    $0x1c,%esp
  802183:	5b                   	pop    %ebx
  802184:	5e                   	pop    %esi
  802185:	5f                   	pop    %edi
  802186:	5d                   	pop    %ebp
  802187:	c3                   	ret    
  802188:	90                   	nop
  802189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802190:	89 d8                	mov    %ebx,%eax
  802192:	f7 f7                	div    %edi
  802194:	31 ff                	xor    %edi,%edi
  802196:	89 c3                	mov    %eax,%ebx
  802198:	89 d8                	mov    %ebx,%eax
  80219a:	89 fa                	mov    %edi,%edx
  80219c:	83 c4 1c             	add    $0x1c,%esp
  80219f:	5b                   	pop    %ebx
  8021a0:	5e                   	pop    %esi
  8021a1:	5f                   	pop    %edi
  8021a2:	5d                   	pop    %ebp
  8021a3:	c3                   	ret    
  8021a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021a8:	39 ce                	cmp    %ecx,%esi
  8021aa:	72 0c                	jb     8021b8 <__udivdi3+0x118>
  8021ac:	31 db                	xor    %ebx,%ebx
  8021ae:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8021b2:	0f 87 34 ff ff ff    	ja     8020ec <__udivdi3+0x4c>
  8021b8:	bb 01 00 00 00       	mov    $0x1,%ebx
  8021bd:	e9 2a ff ff ff       	jmp    8020ec <__udivdi3+0x4c>
  8021c2:	66 90                	xchg   %ax,%ax
  8021c4:	66 90                	xchg   %ax,%ax
  8021c6:	66 90                	xchg   %ax,%ax
  8021c8:	66 90                	xchg   %ax,%ax
  8021ca:	66 90                	xchg   %ax,%ax
  8021cc:	66 90                	xchg   %ax,%ax
  8021ce:	66 90                	xchg   %ax,%ax

008021d0 <__umoddi3>:
  8021d0:	55                   	push   %ebp
  8021d1:	57                   	push   %edi
  8021d2:	56                   	push   %esi
  8021d3:	53                   	push   %ebx
  8021d4:	83 ec 1c             	sub    $0x1c,%esp
  8021d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021db:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8021df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021e7:	85 d2                	test   %edx,%edx
  8021e9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8021ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021f1:	89 f3                	mov    %esi,%ebx
  8021f3:	89 3c 24             	mov    %edi,(%esp)
  8021f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021fa:	75 1c                	jne    802218 <__umoddi3+0x48>
  8021fc:	39 f7                	cmp    %esi,%edi
  8021fe:	76 50                	jbe    802250 <__umoddi3+0x80>
  802200:	89 c8                	mov    %ecx,%eax
  802202:	89 f2                	mov    %esi,%edx
  802204:	f7 f7                	div    %edi
  802206:	89 d0                	mov    %edx,%eax
  802208:	31 d2                	xor    %edx,%edx
  80220a:	83 c4 1c             	add    $0x1c,%esp
  80220d:	5b                   	pop    %ebx
  80220e:	5e                   	pop    %esi
  80220f:	5f                   	pop    %edi
  802210:	5d                   	pop    %ebp
  802211:	c3                   	ret    
  802212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802218:	39 f2                	cmp    %esi,%edx
  80221a:	89 d0                	mov    %edx,%eax
  80221c:	77 52                	ja     802270 <__umoddi3+0xa0>
  80221e:	0f bd ea             	bsr    %edx,%ebp
  802221:	83 f5 1f             	xor    $0x1f,%ebp
  802224:	75 5a                	jne    802280 <__umoddi3+0xb0>
  802226:	3b 54 24 04          	cmp    0x4(%esp),%edx
  80222a:	0f 82 e0 00 00 00    	jb     802310 <__umoddi3+0x140>
  802230:	39 0c 24             	cmp    %ecx,(%esp)
  802233:	0f 86 d7 00 00 00    	jbe    802310 <__umoddi3+0x140>
  802239:	8b 44 24 08          	mov    0x8(%esp),%eax
  80223d:	8b 54 24 04          	mov    0x4(%esp),%edx
  802241:	83 c4 1c             	add    $0x1c,%esp
  802244:	5b                   	pop    %ebx
  802245:	5e                   	pop    %esi
  802246:	5f                   	pop    %edi
  802247:	5d                   	pop    %ebp
  802248:	c3                   	ret    
  802249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802250:	85 ff                	test   %edi,%edi
  802252:	89 fd                	mov    %edi,%ebp
  802254:	75 0b                	jne    802261 <__umoddi3+0x91>
  802256:	b8 01 00 00 00       	mov    $0x1,%eax
  80225b:	31 d2                	xor    %edx,%edx
  80225d:	f7 f7                	div    %edi
  80225f:	89 c5                	mov    %eax,%ebp
  802261:	89 f0                	mov    %esi,%eax
  802263:	31 d2                	xor    %edx,%edx
  802265:	f7 f5                	div    %ebp
  802267:	89 c8                	mov    %ecx,%eax
  802269:	f7 f5                	div    %ebp
  80226b:	89 d0                	mov    %edx,%eax
  80226d:	eb 99                	jmp    802208 <__umoddi3+0x38>
  80226f:	90                   	nop
  802270:	89 c8                	mov    %ecx,%eax
  802272:	89 f2                	mov    %esi,%edx
  802274:	83 c4 1c             	add    $0x1c,%esp
  802277:	5b                   	pop    %ebx
  802278:	5e                   	pop    %esi
  802279:	5f                   	pop    %edi
  80227a:	5d                   	pop    %ebp
  80227b:	c3                   	ret    
  80227c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802280:	8b 34 24             	mov    (%esp),%esi
  802283:	bf 20 00 00 00       	mov    $0x20,%edi
  802288:	89 e9                	mov    %ebp,%ecx
  80228a:	29 ef                	sub    %ebp,%edi
  80228c:	d3 e0                	shl    %cl,%eax
  80228e:	89 f9                	mov    %edi,%ecx
  802290:	89 f2                	mov    %esi,%edx
  802292:	d3 ea                	shr    %cl,%edx
  802294:	89 e9                	mov    %ebp,%ecx
  802296:	09 c2                	or     %eax,%edx
  802298:	89 d8                	mov    %ebx,%eax
  80229a:	89 14 24             	mov    %edx,(%esp)
  80229d:	89 f2                	mov    %esi,%edx
  80229f:	d3 e2                	shl    %cl,%edx
  8022a1:	89 f9                	mov    %edi,%ecx
  8022a3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022a7:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8022ab:	d3 e8                	shr    %cl,%eax
  8022ad:	89 e9                	mov    %ebp,%ecx
  8022af:	89 c6                	mov    %eax,%esi
  8022b1:	d3 e3                	shl    %cl,%ebx
  8022b3:	89 f9                	mov    %edi,%ecx
  8022b5:	89 d0                	mov    %edx,%eax
  8022b7:	d3 e8                	shr    %cl,%eax
  8022b9:	89 e9                	mov    %ebp,%ecx
  8022bb:	09 d8                	or     %ebx,%eax
  8022bd:	89 d3                	mov    %edx,%ebx
  8022bf:	89 f2                	mov    %esi,%edx
  8022c1:	f7 34 24             	divl   (%esp)
  8022c4:	89 d6                	mov    %edx,%esi
  8022c6:	d3 e3                	shl    %cl,%ebx
  8022c8:	f7 64 24 04          	mull   0x4(%esp)
  8022cc:	39 d6                	cmp    %edx,%esi
  8022ce:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022d2:	89 d1                	mov    %edx,%ecx
  8022d4:	89 c3                	mov    %eax,%ebx
  8022d6:	72 08                	jb     8022e0 <__umoddi3+0x110>
  8022d8:	75 11                	jne    8022eb <__umoddi3+0x11b>
  8022da:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8022de:	73 0b                	jae    8022eb <__umoddi3+0x11b>
  8022e0:	2b 44 24 04          	sub    0x4(%esp),%eax
  8022e4:	1b 14 24             	sbb    (%esp),%edx
  8022e7:	89 d1                	mov    %edx,%ecx
  8022e9:	89 c3                	mov    %eax,%ebx
  8022eb:	8b 54 24 08          	mov    0x8(%esp),%edx
  8022ef:	29 da                	sub    %ebx,%edx
  8022f1:	19 ce                	sbb    %ecx,%esi
  8022f3:	89 f9                	mov    %edi,%ecx
  8022f5:	89 f0                	mov    %esi,%eax
  8022f7:	d3 e0                	shl    %cl,%eax
  8022f9:	89 e9                	mov    %ebp,%ecx
  8022fb:	d3 ea                	shr    %cl,%edx
  8022fd:	89 e9                	mov    %ebp,%ecx
  8022ff:	d3 ee                	shr    %cl,%esi
  802301:	09 d0                	or     %edx,%eax
  802303:	89 f2                	mov    %esi,%edx
  802305:	83 c4 1c             	add    $0x1c,%esp
  802308:	5b                   	pop    %ebx
  802309:	5e                   	pop    %esi
  80230a:	5f                   	pop    %edi
  80230b:	5d                   	pop    %ebp
  80230c:	c3                   	ret    
  80230d:	8d 76 00             	lea    0x0(%esi),%esi
  802310:	29 f9                	sub    %edi,%ecx
  802312:	19 d6                	sbb    %edx,%esi
  802314:	89 74 24 04          	mov    %esi,0x4(%esp)
  802318:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80231c:	e9 18 ff ff ff       	jmp    802239 <__umoddi3+0x69>
