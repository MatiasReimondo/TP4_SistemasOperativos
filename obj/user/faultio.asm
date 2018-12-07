
obj/user/faultio.debug:     formato del fichero elf32-i386


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
  80002c:	e8 56 00 00 00       	call   800087 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <outb>:
		     : "memory", "cc");
}

static inline void
outb(int port, uint8_t data)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	89 c1                	mov    %eax,%ecx
  800038:	89 d0                	mov    %edx,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  80003a:	89 ca                	mov    %ecx,%edx
  80003c:	ee                   	out    %al,(%dx)
}
  80003d:	5d                   	pop    %ebp
  80003e:	c3                   	ret    

0080003f <read_eflags>:
	asm volatile("movl %0,%%cr3" : : "r" (cr3));
}

static inline uint32_t
read_eflags(void)
{
  80003f:	55                   	push   %ebp
  800040:	89 e5                	mov    %esp,%ebp
	uint32_t eflags;
	asm volatile("pushfl; popl %0" : "=r" (eflags));
  800042:	9c                   	pushf  
  800043:	58                   	pop    %eax
	return eflags;
}
  800044:	5d                   	pop    %ebp
  800045:	c3                   	ret    

00800046 <umain>:
#include <inc/lib.h>
#include <inc/x86.h>

void
umain(int argc, char **argv)
{
  800046:	55                   	push   %ebp
  800047:	89 e5                	mov    %esp,%ebp
  800049:	83 ec 08             	sub    $0x8,%esp
        int x, r;
	int nsecs = 1;
	int secno = 0;
	int diskno = 1;

	if (read_eflags() & FL_IOPL_3)
  80004c:	e8 ee ff ff ff       	call   80003f <read_eflags>
  800051:	f6 c4 30             	test   $0x30,%ah
  800054:	74 10                	je     800066 <umain+0x20>
		cprintf("eflags wrong\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 80 1d 80 00       	push   $0x801d80
  80005e:	e8 1b 01 00 00       	call   80017e <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp

	// this outb to select disk 1 should result in a general protection
	// fault, because user-level code shouldn't be able to use the io space.
	outb(0x1F6, 0xE0 | (1<<4));
  800066:	ba f0 00 00 00       	mov    $0xf0,%edx
  80006b:	b8 f6 01 00 00       	mov    $0x1f6,%eax
  800070:	e8 be ff ff ff       	call   800033 <outb>

        cprintf("%s: made it here --- bug\n");
  800075:	83 ec 0c             	sub    $0xc,%esp
  800078:	68 8e 1d 80 00       	push   $0x801d8e
  80007d:	e8 fc 00 00 00       	call   80017e <cprintf>
}
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	c9                   	leave  
  800086:	c3                   	ret    

00800087 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800087:	55                   	push   %ebp
  800088:	89 e5                	mov    %esp,%ebp
  80008a:	56                   	push   %esi
  80008b:	53                   	push   %ebx
  80008c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80008f:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800092:	e8 57 0a 00 00       	call   800aee <sys_getenvid>
	if (id >= 0)
  800097:	85 c0                	test   %eax,%eax
  800099:	78 12                	js     8000ad <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  80009b:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000a3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000a8:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ad:	85 db                	test   %ebx,%ebx
  8000af:	7e 07                	jle    8000b8 <libmain+0x31>
		binaryname = argv[0];
  8000b1:	8b 06                	mov    (%esi),%eax
  8000b3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000b8:	83 ec 08             	sub    $0x8,%esp
  8000bb:	56                   	push   %esi
  8000bc:	53                   	push   %ebx
  8000bd:	e8 84 ff ff ff       	call   800046 <umain>

	// exit gracefully
	exit();
  8000c2:	e8 0a 00 00 00       	call   8000d1 <exit>
}
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5d                   	pop    %ebp
  8000d0:	c3                   	ret    

008000d1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000d7:	e8 45 0d 00 00       	call   800e21 <close_all>
	sys_env_destroy(0);
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	6a 00                	push   $0x0
  8000e1:	e8 e6 09 00 00       	call   800acc <sys_env_destroy>
}
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	c9                   	leave  
  8000ea:	c3                   	ret    

008000eb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	53                   	push   %ebx
  8000ef:	83 ec 04             	sub    $0x4,%esp
  8000f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000f5:	8b 13                	mov    (%ebx),%edx
  8000f7:	8d 42 01             	lea    0x1(%edx),%eax
  8000fa:	89 03                	mov    %eax,(%ebx)
  8000fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000ff:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800103:	3d ff 00 00 00       	cmp    $0xff,%eax
  800108:	75 1a                	jne    800124 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  80010a:	83 ec 08             	sub    $0x8,%esp
  80010d:	68 ff 00 00 00       	push   $0xff
  800112:	8d 43 08             	lea    0x8(%ebx),%eax
  800115:	50                   	push   %eax
  800116:	e8 67 09 00 00       	call   800a82 <sys_cputs>
		b->idx = 0;
  80011b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800121:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  800124:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800128:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80012b:	c9                   	leave  
  80012c:	c3                   	ret    

0080012d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80012d:	55                   	push   %ebp
  80012e:	89 e5                	mov    %esp,%ebp
  800130:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800136:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80013d:	00 00 00 
	b.cnt = 0;
  800140:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800147:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80014a:	ff 75 0c             	pushl  0xc(%ebp)
  80014d:	ff 75 08             	pushl  0x8(%ebp)
  800150:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800156:	50                   	push   %eax
  800157:	68 eb 00 80 00       	push   $0x8000eb
  80015c:	e8 86 01 00 00       	call   8002e7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800161:	83 c4 08             	add    $0x8,%esp
  800164:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80016a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800170:	50                   	push   %eax
  800171:	e8 0c 09 00 00       	call   800a82 <sys_cputs>

	return b.cnt;
}
  800176:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80017c:	c9                   	leave  
  80017d:	c3                   	ret    

0080017e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80017e:	55                   	push   %ebp
  80017f:	89 e5                	mov    %esp,%ebp
  800181:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800184:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800187:	50                   	push   %eax
  800188:	ff 75 08             	pushl  0x8(%ebp)
  80018b:	e8 9d ff ff ff       	call   80012d <vcprintf>
	va_end(ap);

	return cnt;
}
  800190:	c9                   	leave  
  800191:	c3                   	ret    

00800192 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	57                   	push   %edi
  800196:	56                   	push   %esi
  800197:	53                   	push   %ebx
  800198:	83 ec 1c             	sub    $0x1c,%esp
  80019b:	89 c7                	mov    %eax,%edi
  80019d:	89 d6                	mov    %edx,%esi
  80019f:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001b3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001b6:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001b9:	39 d3                	cmp    %edx,%ebx
  8001bb:	72 05                	jb     8001c2 <printnum+0x30>
  8001bd:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001c0:	77 45                	ja     800207 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001c2:	83 ec 0c             	sub    $0xc,%esp
  8001c5:	ff 75 18             	pushl  0x18(%ebp)
  8001c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8001cb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001ce:	53                   	push   %ebx
  8001cf:	ff 75 10             	pushl  0x10(%ebp)
  8001d2:	83 ec 08             	sub    $0x8,%esp
  8001d5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d8:	ff 75 e0             	pushl  -0x20(%ebp)
  8001db:	ff 75 dc             	pushl  -0x24(%ebp)
  8001de:	ff 75 d8             	pushl  -0x28(%ebp)
  8001e1:	e8 fa 18 00 00       	call   801ae0 <__udivdi3>
  8001e6:	83 c4 18             	add    $0x18,%esp
  8001e9:	52                   	push   %edx
  8001ea:	50                   	push   %eax
  8001eb:	89 f2                	mov    %esi,%edx
  8001ed:	89 f8                	mov    %edi,%eax
  8001ef:	e8 9e ff ff ff       	call   800192 <printnum>
  8001f4:	83 c4 20             	add    $0x20,%esp
  8001f7:	eb 18                	jmp    800211 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001f9:	83 ec 08             	sub    $0x8,%esp
  8001fc:	56                   	push   %esi
  8001fd:	ff 75 18             	pushl  0x18(%ebp)
  800200:	ff d7                	call   *%edi
  800202:	83 c4 10             	add    $0x10,%esp
  800205:	eb 03                	jmp    80020a <printnum+0x78>
  800207:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80020a:	83 eb 01             	sub    $0x1,%ebx
  80020d:	85 db                	test   %ebx,%ebx
  80020f:	7f e8                	jg     8001f9 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800211:	83 ec 08             	sub    $0x8,%esp
  800214:	56                   	push   %esi
  800215:	83 ec 04             	sub    $0x4,%esp
  800218:	ff 75 e4             	pushl  -0x1c(%ebp)
  80021b:	ff 75 e0             	pushl  -0x20(%ebp)
  80021e:	ff 75 dc             	pushl  -0x24(%ebp)
  800221:	ff 75 d8             	pushl  -0x28(%ebp)
  800224:	e8 e7 19 00 00       	call   801c10 <__umoddi3>
  800229:	83 c4 14             	add    $0x14,%esp
  80022c:	0f be 80 b2 1d 80 00 	movsbl 0x801db2(%eax),%eax
  800233:	50                   	push   %eax
  800234:	ff d7                	call   *%edi
}
  800236:	83 c4 10             	add    $0x10,%esp
  800239:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023c:	5b                   	pop    %ebx
  80023d:	5e                   	pop    %esi
  80023e:	5f                   	pop    %edi
  80023f:	5d                   	pop    %ebp
  800240:	c3                   	ret    

00800241 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800241:	55                   	push   %ebp
  800242:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800244:	83 fa 01             	cmp    $0x1,%edx
  800247:	7e 0e                	jle    800257 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800249:	8b 10                	mov    (%eax),%edx
  80024b:	8d 4a 08             	lea    0x8(%edx),%ecx
  80024e:	89 08                	mov    %ecx,(%eax)
  800250:	8b 02                	mov    (%edx),%eax
  800252:	8b 52 04             	mov    0x4(%edx),%edx
  800255:	eb 22                	jmp    800279 <getuint+0x38>
	else if (lflag)
  800257:	85 d2                	test   %edx,%edx
  800259:	74 10                	je     80026b <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80025b:	8b 10                	mov    (%eax),%edx
  80025d:	8d 4a 04             	lea    0x4(%edx),%ecx
  800260:	89 08                	mov    %ecx,(%eax)
  800262:	8b 02                	mov    (%edx),%eax
  800264:	ba 00 00 00 00       	mov    $0x0,%edx
  800269:	eb 0e                	jmp    800279 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80026b:	8b 10                	mov    (%eax),%edx
  80026d:	8d 4a 04             	lea    0x4(%edx),%ecx
  800270:	89 08                	mov    %ecx,(%eax)
  800272:	8b 02                	mov    (%edx),%eax
  800274:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800279:	5d                   	pop    %ebp
  80027a:	c3                   	ret    

0080027b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80027e:	83 fa 01             	cmp    $0x1,%edx
  800281:	7e 0e                	jle    800291 <getint+0x16>
		return va_arg(*ap, long long);
  800283:	8b 10                	mov    (%eax),%edx
  800285:	8d 4a 08             	lea    0x8(%edx),%ecx
  800288:	89 08                	mov    %ecx,(%eax)
  80028a:	8b 02                	mov    (%edx),%eax
  80028c:	8b 52 04             	mov    0x4(%edx),%edx
  80028f:	eb 1a                	jmp    8002ab <getint+0x30>
	else if (lflag)
  800291:	85 d2                	test   %edx,%edx
  800293:	74 0c                	je     8002a1 <getint+0x26>
		return va_arg(*ap, long);
  800295:	8b 10                	mov    (%eax),%edx
  800297:	8d 4a 04             	lea    0x4(%edx),%ecx
  80029a:	89 08                	mov    %ecx,(%eax)
  80029c:	8b 02                	mov    (%edx),%eax
  80029e:	99                   	cltd   
  80029f:	eb 0a                	jmp    8002ab <getint+0x30>
	else
		return va_arg(*ap, int);
  8002a1:	8b 10                	mov    (%eax),%edx
  8002a3:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002a6:	89 08                	mov    %ecx,(%eax)
  8002a8:	8b 02                	mov    (%edx),%eax
  8002aa:	99                   	cltd   
}
  8002ab:	5d                   	pop    %ebp
  8002ac:	c3                   	ret    

008002ad <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002b3:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002b7:	8b 10                	mov    (%eax),%edx
  8002b9:	3b 50 04             	cmp    0x4(%eax),%edx
  8002bc:	73 0a                	jae    8002c8 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002c1:	89 08                	mov    %ecx,(%eax)
  8002c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c6:	88 02                	mov    %al,(%edx)
}
  8002c8:	5d                   	pop    %ebp
  8002c9:	c3                   	ret    

008002ca <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8002ca:	55                   	push   %ebp
  8002cb:	89 e5                	mov    %esp,%ebp
  8002cd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8002d0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002d3:	50                   	push   %eax
  8002d4:	ff 75 10             	pushl  0x10(%ebp)
  8002d7:	ff 75 0c             	pushl  0xc(%ebp)
  8002da:	ff 75 08             	pushl  0x8(%ebp)
  8002dd:	e8 05 00 00 00       	call   8002e7 <vprintfmt>
	va_end(ap);
}
  8002e2:	83 c4 10             	add    $0x10,%esp
  8002e5:	c9                   	leave  
  8002e6:	c3                   	ret    

008002e7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
  8002ea:	57                   	push   %edi
  8002eb:	56                   	push   %esi
  8002ec:	53                   	push   %ebx
  8002ed:	83 ec 2c             	sub    $0x2c,%esp
  8002f0:	8b 75 08             	mov    0x8(%ebp),%esi
  8002f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002f6:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002f9:	eb 12                	jmp    80030d <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8002fb:	85 c0                	test   %eax,%eax
  8002fd:	0f 84 44 03 00 00    	je     800647 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  800303:	83 ec 08             	sub    $0x8,%esp
  800306:	53                   	push   %ebx
  800307:	50                   	push   %eax
  800308:	ff d6                	call   *%esi
  80030a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80030d:	83 c7 01             	add    $0x1,%edi
  800310:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800314:	83 f8 25             	cmp    $0x25,%eax
  800317:	75 e2                	jne    8002fb <vprintfmt+0x14>
  800319:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  80031d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800324:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80032b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800332:	ba 00 00 00 00       	mov    $0x0,%edx
  800337:	eb 07                	jmp    800340 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800339:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  80033c:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800340:	8d 47 01             	lea    0x1(%edi),%eax
  800343:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800346:	0f b6 07             	movzbl (%edi),%eax
  800349:	0f b6 c8             	movzbl %al,%ecx
  80034c:	83 e8 23             	sub    $0x23,%eax
  80034f:	3c 55                	cmp    $0x55,%al
  800351:	0f 87 d5 02 00 00    	ja     80062c <vprintfmt+0x345>
  800357:	0f b6 c0             	movzbl %al,%eax
  80035a:	ff 24 85 00 1f 80 00 	jmp    *0x801f00(,%eax,4)
  800361:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800364:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800368:	eb d6                	jmp    800340 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80036a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80036d:	b8 00 00 00 00       	mov    $0x0,%eax
  800372:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800375:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800378:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  80037c:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  80037f:	8d 51 d0             	lea    -0x30(%ecx),%edx
  800382:	83 fa 09             	cmp    $0x9,%edx
  800385:	77 39                	ja     8003c0 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800387:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80038a:	eb e9                	jmp    800375 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80038c:	8b 45 14             	mov    0x14(%ebp),%eax
  80038f:	8d 48 04             	lea    0x4(%eax),%ecx
  800392:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800395:	8b 00                	mov    (%eax),%eax
  800397:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80039a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  80039d:	eb 27                	jmp    8003c6 <vprintfmt+0xdf>
  80039f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a2:	85 c0                	test   %eax,%eax
  8003a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003a9:	0f 49 c8             	cmovns %eax,%ecx
  8003ac:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003b2:	eb 8c                	jmp    800340 <vprintfmt+0x59>
  8003b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8003b7:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003be:	eb 80                	jmp    800340 <vprintfmt+0x59>
  8003c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003c3:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  8003c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ca:	0f 89 70 ff ff ff    	jns    800340 <vprintfmt+0x59>
				width = precision, precision = -1;
  8003d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003d6:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003dd:	e9 5e ff ff ff       	jmp    800340 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003e2:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8003e8:	e9 53 ff ff ff       	jmp    800340 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f0:	8d 50 04             	lea    0x4(%eax),%edx
  8003f3:	89 55 14             	mov    %edx,0x14(%ebp)
  8003f6:	83 ec 08             	sub    $0x8,%esp
  8003f9:	53                   	push   %ebx
  8003fa:	ff 30                	pushl  (%eax)
  8003fc:	ff d6                	call   *%esi
			break;
  8003fe:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800401:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800404:	e9 04 ff ff ff       	jmp    80030d <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800409:	8b 45 14             	mov    0x14(%ebp),%eax
  80040c:	8d 50 04             	lea    0x4(%eax),%edx
  80040f:	89 55 14             	mov    %edx,0x14(%ebp)
  800412:	8b 00                	mov    (%eax),%eax
  800414:	99                   	cltd   
  800415:	31 d0                	xor    %edx,%eax
  800417:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800419:	83 f8 0f             	cmp    $0xf,%eax
  80041c:	7f 0b                	jg     800429 <vprintfmt+0x142>
  80041e:	8b 14 85 60 20 80 00 	mov    0x802060(,%eax,4),%edx
  800425:	85 d2                	test   %edx,%edx
  800427:	75 18                	jne    800441 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  800429:	50                   	push   %eax
  80042a:	68 ca 1d 80 00       	push   $0x801dca
  80042f:	53                   	push   %ebx
  800430:	56                   	push   %esi
  800431:	e8 94 fe ff ff       	call   8002ca <printfmt>
  800436:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800439:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80043c:	e9 cc fe ff ff       	jmp    80030d <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  800441:	52                   	push   %edx
  800442:	68 91 21 80 00       	push   $0x802191
  800447:	53                   	push   %ebx
  800448:	56                   	push   %esi
  800449:	e8 7c fe ff ff       	call   8002ca <printfmt>
  80044e:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800451:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800454:	e9 b4 fe ff ff       	jmp    80030d <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800459:	8b 45 14             	mov    0x14(%ebp),%eax
  80045c:	8d 50 04             	lea    0x4(%eax),%edx
  80045f:	89 55 14             	mov    %edx,0x14(%ebp)
  800462:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800464:	85 ff                	test   %edi,%edi
  800466:	b8 c3 1d 80 00       	mov    $0x801dc3,%eax
  80046b:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80046e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800472:	0f 8e 94 00 00 00    	jle    80050c <vprintfmt+0x225>
  800478:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80047c:	0f 84 98 00 00 00    	je     80051a <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  800482:	83 ec 08             	sub    $0x8,%esp
  800485:	ff 75 d0             	pushl  -0x30(%ebp)
  800488:	57                   	push   %edi
  800489:	e8 41 02 00 00       	call   8006cf <strnlen>
  80048e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800491:	29 c1                	sub    %eax,%ecx
  800493:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800496:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800499:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80049d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a0:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004a3:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a5:	eb 0f                	jmp    8004b6 <vprintfmt+0x1cf>
					putch(padc, putdat);
  8004a7:	83 ec 08             	sub    $0x8,%esp
  8004aa:	53                   	push   %ebx
  8004ab:	ff 75 e0             	pushl  -0x20(%ebp)
  8004ae:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b0:	83 ef 01             	sub    $0x1,%edi
  8004b3:	83 c4 10             	add    $0x10,%esp
  8004b6:	85 ff                	test   %edi,%edi
  8004b8:	7f ed                	jg     8004a7 <vprintfmt+0x1c0>
  8004ba:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004bd:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8004c0:	85 c9                	test   %ecx,%ecx
  8004c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c7:	0f 49 c1             	cmovns %ecx,%eax
  8004ca:	29 c1                	sub    %eax,%ecx
  8004cc:	89 75 08             	mov    %esi,0x8(%ebp)
  8004cf:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004d2:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004d5:	89 cb                	mov    %ecx,%ebx
  8004d7:	eb 4d                	jmp    800526 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004d9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004dd:	74 1b                	je     8004fa <vprintfmt+0x213>
  8004df:	0f be c0             	movsbl %al,%eax
  8004e2:	83 e8 20             	sub    $0x20,%eax
  8004e5:	83 f8 5e             	cmp    $0x5e,%eax
  8004e8:	76 10                	jbe    8004fa <vprintfmt+0x213>
					putch('?', putdat);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	ff 75 0c             	pushl  0xc(%ebp)
  8004f0:	6a 3f                	push   $0x3f
  8004f2:	ff 55 08             	call   *0x8(%ebp)
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	eb 0d                	jmp    800507 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	ff 75 0c             	pushl  0xc(%ebp)
  800500:	52                   	push   %edx
  800501:	ff 55 08             	call   *0x8(%ebp)
  800504:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800507:	83 eb 01             	sub    $0x1,%ebx
  80050a:	eb 1a                	jmp    800526 <vprintfmt+0x23f>
  80050c:	89 75 08             	mov    %esi,0x8(%ebp)
  80050f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800512:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800515:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800518:	eb 0c                	jmp    800526 <vprintfmt+0x23f>
  80051a:	89 75 08             	mov    %esi,0x8(%ebp)
  80051d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800520:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800523:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800526:	83 c7 01             	add    $0x1,%edi
  800529:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80052d:	0f be d0             	movsbl %al,%edx
  800530:	85 d2                	test   %edx,%edx
  800532:	74 23                	je     800557 <vprintfmt+0x270>
  800534:	85 f6                	test   %esi,%esi
  800536:	78 a1                	js     8004d9 <vprintfmt+0x1f2>
  800538:	83 ee 01             	sub    $0x1,%esi
  80053b:	79 9c                	jns    8004d9 <vprintfmt+0x1f2>
  80053d:	89 df                	mov    %ebx,%edi
  80053f:	8b 75 08             	mov    0x8(%ebp),%esi
  800542:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800545:	eb 18                	jmp    80055f <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800547:	83 ec 08             	sub    $0x8,%esp
  80054a:	53                   	push   %ebx
  80054b:	6a 20                	push   $0x20
  80054d:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80054f:	83 ef 01             	sub    $0x1,%edi
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	eb 08                	jmp    80055f <vprintfmt+0x278>
  800557:	89 df                	mov    %ebx,%edi
  800559:	8b 75 08             	mov    0x8(%ebp),%esi
  80055c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80055f:	85 ff                	test   %edi,%edi
  800561:	7f e4                	jg     800547 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800563:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800566:	e9 a2 fd ff ff       	jmp    80030d <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80056b:	8d 45 14             	lea    0x14(%ebp),%eax
  80056e:	e8 08 fd ff ff       	call   80027b <getint>
  800573:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800576:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800579:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  80057e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800582:	79 74                	jns    8005f8 <vprintfmt+0x311>
				putch('-', putdat);
  800584:	83 ec 08             	sub    $0x8,%esp
  800587:	53                   	push   %ebx
  800588:	6a 2d                	push   $0x2d
  80058a:	ff d6                	call   *%esi
				num = -(long long) num;
  80058c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80058f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800592:	f7 d8                	neg    %eax
  800594:	83 d2 00             	adc    $0x0,%edx
  800597:	f7 da                	neg    %edx
  800599:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  80059c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8005a1:	eb 55                	jmp    8005f8 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8005a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8005a6:	e8 96 fc ff ff       	call   800241 <getuint>
			base = 10;
  8005ab:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8005b0:	eb 46                	jmp    8005f8 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8005b2:	8d 45 14             	lea    0x14(%ebp),%eax
  8005b5:	e8 87 fc ff ff       	call   800241 <getuint>
			base = 8;
  8005ba:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8005bf:	eb 37                	jmp    8005f8 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  8005c1:	83 ec 08             	sub    $0x8,%esp
  8005c4:	53                   	push   %ebx
  8005c5:	6a 30                	push   $0x30
  8005c7:	ff d6                	call   *%esi
			putch('x', putdat);
  8005c9:	83 c4 08             	add    $0x8,%esp
  8005cc:	53                   	push   %ebx
  8005cd:	6a 78                	push   $0x78
  8005cf:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8005d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d4:	8d 50 04             	lea    0x4(%eax),%edx
  8005d7:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8005e1:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8005e4:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8005e9:	eb 0d                	jmp    8005f8 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8005eb:	8d 45 14             	lea    0x14(%ebp),%eax
  8005ee:	e8 4e fc ff ff       	call   800241 <getuint>
			base = 16;
  8005f3:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8005f8:	83 ec 0c             	sub    $0xc,%esp
  8005fb:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8005ff:	57                   	push   %edi
  800600:	ff 75 e0             	pushl  -0x20(%ebp)
  800603:	51                   	push   %ecx
  800604:	52                   	push   %edx
  800605:	50                   	push   %eax
  800606:	89 da                	mov    %ebx,%edx
  800608:	89 f0                	mov    %esi,%eax
  80060a:	e8 83 fb ff ff       	call   800192 <printnum>
			break;
  80060f:	83 c4 20             	add    $0x20,%esp
  800612:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800615:	e9 f3 fc ff ff       	jmp    80030d <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80061a:	83 ec 08             	sub    $0x8,%esp
  80061d:	53                   	push   %ebx
  80061e:	51                   	push   %ecx
  80061f:	ff d6                	call   *%esi
			break;
  800621:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800624:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800627:	e9 e1 fc ff ff       	jmp    80030d <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80062c:	83 ec 08             	sub    $0x8,%esp
  80062f:	53                   	push   %ebx
  800630:	6a 25                	push   $0x25
  800632:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800634:	83 c4 10             	add    $0x10,%esp
  800637:	eb 03                	jmp    80063c <vprintfmt+0x355>
  800639:	83 ef 01             	sub    $0x1,%edi
  80063c:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  800640:	75 f7                	jne    800639 <vprintfmt+0x352>
  800642:	e9 c6 fc ff ff       	jmp    80030d <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  800647:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80064a:	5b                   	pop    %ebx
  80064b:	5e                   	pop    %esi
  80064c:	5f                   	pop    %edi
  80064d:	5d                   	pop    %ebp
  80064e:	c3                   	ret    

0080064f <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80064f:	55                   	push   %ebp
  800650:	89 e5                	mov    %esp,%ebp
  800652:	83 ec 18             	sub    $0x18,%esp
  800655:	8b 45 08             	mov    0x8(%ebp),%eax
  800658:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80065b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80065e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800662:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800665:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80066c:	85 c0                	test   %eax,%eax
  80066e:	74 26                	je     800696 <vsnprintf+0x47>
  800670:	85 d2                	test   %edx,%edx
  800672:	7e 22                	jle    800696 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800674:	ff 75 14             	pushl  0x14(%ebp)
  800677:	ff 75 10             	pushl  0x10(%ebp)
  80067a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80067d:	50                   	push   %eax
  80067e:	68 ad 02 80 00       	push   $0x8002ad
  800683:	e8 5f fc ff ff       	call   8002e7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800688:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80068b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80068e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800691:	83 c4 10             	add    $0x10,%esp
  800694:	eb 05                	jmp    80069b <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800696:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80069b:	c9                   	leave  
  80069c:	c3                   	ret    

0080069d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80069d:	55                   	push   %ebp
  80069e:	89 e5                	mov    %esp,%ebp
  8006a0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8006a3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8006a6:	50                   	push   %eax
  8006a7:	ff 75 10             	pushl  0x10(%ebp)
  8006aa:	ff 75 0c             	pushl  0xc(%ebp)
  8006ad:	ff 75 08             	pushl  0x8(%ebp)
  8006b0:	e8 9a ff ff ff       	call   80064f <vsnprintf>
	va_end(ap);

	return rc;
}
  8006b5:	c9                   	leave  
  8006b6:	c3                   	ret    

008006b7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8006b7:	55                   	push   %ebp
  8006b8:	89 e5                	mov    %esp,%ebp
  8006ba:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8006bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c2:	eb 03                	jmp    8006c7 <strlen+0x10>
		n++;
  8006c4:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8006c7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8006cb:	75 f7                	jne    8006c4 <strlen+0xd>
		n++;
	return n;
}
  8006cd:	5d                   	pop    %ebp
  8006ce:	c3                   	ret    

008006cf <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8006cf:	55                   	push   %ebp
  8006d0:	89 e5                	mov    %esp,%ebp
  8006d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8006d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006dd:	eb 03                	jmp    8006e2 <strnlen+0x13>
		n++;
  8006df:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8006e2:	39 c2                	cmp    %eax,%edx
  8006e4:	74 08                	je     8006ee <strnlen+0x1f>
  8006e6:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8006ea:	75 f3                	jne    8006df <strnlen+0x10>
  8006ec:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  8006ee:	5d                   	pop    %ebp
  8006ef:	c3                   	ret    

008006f0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8006f0:	55                   	push   %ebp
  8006f1:	89 e5                	mov    %esp,%ebp
  8006f3:	53                   	push   %ebx
  8006f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8006fa:	89 c2                	mov    %eax,%edx
  8006fc:	83 c2 01             	add    $0x1,%edx
  8006ff:	83 c1 01             	add    $0x1,%ecx
  800702:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800706:	88 5a ff             	mov    %bl,-0x1(%edx)
  800709:	84 db                	test   %bl,%bl
  80070b:	75 ef                	jne    8006fc <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80070d:	5b                   	pop    %ebx
  80070e:	5d                   	pop    %ebp
  80070f:	c3                   	ret    

00800710 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	53                   	push   %ebx
  800714:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800717:	53                   	push   %ebx
  800718:	e8 9a ff ff ff       	call   8006b7 <strlen>
  80071d:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800720:	ff 75 0c             	pushl  0xc(%ebp)
  800723:	01 d8                	add    %ebx,%eax
  800725:	50                   	push   %eax
  800726:	e8 c5 ff ff ff       	call   8006f0 <strcpy>
	return dst;
}
  80072b:	89 d8                	mov    %ebx,%eax
  80072d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800730:	c9                   	leave  
  800731:	c3                   	ret    

00800732 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800732:	55                   	push   %ebp
  800733:	89 e5                	mov    %esp,%ebp
  800735:	56                   	push   %esi
  800736:	53                   	push   %ebx
  800737:	8b 75 08             	mov    0x8(%ebp),%esi
  80073a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80073d:	89 f3                	mov    %esi,%ebx
  80073f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800742:	89 f2                	mov    %esi,%edx
  800744:	eb 0f                	jmp    800755 <strncpy+0x23>
		*dst++ = *src;
  800746:	83 c2 01             	add    $0x1,%edx
  800749:	0f b6 01             	movzbl (%ecx),%eax
  80074c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80074f:	80 39 01             	cmpb   $0x1,(%ecx)
  800752:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800755:	39 da                	cmp    %ebx,%edx
  800757:	75 ed                	jne    800746 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800759:	89 f0                	mov    %esi,%eax
  80075b:	5b                   	pop    %ebx
  80075c:	5e                   	pop    %esi
  80075d:	5d                   	pop    %ebp
  80075e:	c3                   	ret    

0080075f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80075f:	55                   	push   %ebp
  800760:	89 e5                	mov    %esp,%ebp
  800762:	56                   	push   %esi
  800763:	53                   	push   %ebx
  800764:	8b 75 08             	mov    0x8(%ebp),%esi
  800767:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80076a:	8b 55 10             	mov    0x10(%ebp),%edx
  80076d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80076f:	85 d2                	test   %edx,%edx
  800771:	74 21                	je     800794 <strlcpy+0x35>
  800773:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800777:	89 f2                	mov    %esi,%edx
  800779:	eb 09                	jmp    800784 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80077b:	83 c2 01             	add    $0x1,%edx
  80077e:	83 c1 01             	add    $0x1,%ecx
  800781:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800784:	39 c2                	cmp    %eax,%edx
  800786:	74 09                	je     800791 <strlcpy+0x32>
  800788:	0f b6 19             	movzbl (%ecx),%ebx
  80078b:	84 db                	test   %bl,%bl
  80078d:	75 ec                	jne    80077b <strlcpy+0x1c>
  80078f:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  800791:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800794:	29 f0                	sub    %esi,%eax
}
  800796:	5b                   	pop    %ebx
  800797:	5e                   	pop    %esi
  800798:	5d                   	pop    %ebp
  800799:	c3                   	ret    

0080079a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007a0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007a3:	eb 06                	jmp    8007ab <strcmp+0x11>
		p++, q++;
  8007a5:	83 c1 01             	add    $0x1,%ecx
  8007a8:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8007ab:	0f b6 01             	movzbl (%ecx),%eax
  8007ae:	84 c0                	test   %al,%al
  8007b0:	74 04                	je     8007b6 <strcmp+0x1c>
  8007b2:	3a 02                	cmp    (%edx),%al
  8007b4:	74 ef                	je     8007a5 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8007b6:	0f b6 c0             	movzbl %al,%eax
  8007b9:	0f b6 12             	movzbl (%edx),%edx
  8007bc:	29 d0                	sub    %edx,%eax
}
  8007be:	5d                   	pop    %ebp
  8007bf:	c3                   	ret    

008007c0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	53                   	push   %ebx
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007ca:	89 c3                	mov    %eax,%ebx
  8007cc:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8007cf:	eb 06                	jmp    8007d7 <strncmp+0x17>
		n--, p++, q++;
  8007d1:	83 c0 01             	add    $0x1,%eax
  8007d4:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8007d7:	39 d8                	cmp    %ebx,%eax
  8007d9:	74 15                	je     8007f0 <strncmp+0x30>
  8007db:	0f b6 08             	movzbl (%eax),%ecx
  8007de:	84 c9                	test   %cl,%cl
  8007e0:	74 04                	je     8007e6 <strncmp+0x26>
  8007e2:	3a 0a                	cmp    (%edx),%cl
  8007e4:	74 eb                	je     8007d1 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8007e6:	0f b6 00             	movzbl (%eax),%eax
  8007e9:	0f b6 12             	movzbl (%edx),%edx
  8007ec:	29 d0                	sub    %edx,%eax
  8007ee:	eb 05                	jmp    8007f5 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8007f0:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8007f5:	5b                   	pop    %ebx
  8007f6:	5d                   	pop    %ebp
  8007f7:	c3                   	ret    

008007f8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800802:	eb 07                	jmp    80080b <strchr+0x13>
		if (*s == c)
  800804:	38 ca                	cmp    %cl,%dl
  800806:	74 0f                	je     800817 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800808:	83 c0 01             	add    $0x1,%eax
  80080b:	0f b6 10             	movzbl (%eax),%edx
  80080e:	84 d2                	test   %dl,%dl
  800810:	75 f2                	jne    800804 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800812:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800817:	5d                   	pop    %ebp
  800818:	c3                   	ret    

00800819 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800819:	55                   	push   %ebp
  80081a:	89 e5                	mov    %esp,%ebp
  80081c:	8b 45 08             	mov    0x8(%ebp),%eax
  80081f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800823:	eb 03                	jmp    800828 <strfind+0xf>
  800825:	83 c0 01             	add    $0x1,%eax
  800828:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80082b:	38 ca                	cmp    %cl,%dl
  80082d:	74 04                	je     800833 <strfind+0x1a>
  80082f:	84 d2                	test   %dl,%dl
  800831:	75 f2                	jne    800825 <strfind+0xc>
			break;
	return (char *) s;
}
  800833:	5d                   	pop    %ebp
  800834:	c3                   	ret    

00800835 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800835:	55                   	push   %ebp
  800836:	89 e5                	mov    %esp,%ebp
  800838:	57                   	push   %edi
  800839:	56                   	push   %esi
  80083a:	53                   	push   %ebx
  80083b:	8b 55 08             	mov    0x8(%ebp),%edx
  80083e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800841:	85 c9                	test   %ecx,%ecx
  800843:	74 37                	je     80087c <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800845:	f6 c2 03             	test   $0x3,%dl
  800848:	75 2a                	jne    800874 <memset+0x3f>
  80084a:	f6 c1 03             	test   $0x3,%cl
  80084d:	75 25                	jne    800874 <memset+0x3f>
		c &= 0xFF;
  80084f:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800853:	89 df                	mov    %ebx,%edi
  800855:	c1 e7 08             	shl    $0x8,%edi
  800858:	89 de                	mov    %ebx,%esi
  80085a:	c1 e6 18             	shl    $0x18,%esi
  80085d:	89 d8                	mov    %ebx,%eax
  80085f:	c1 e0 10             	shl    $0x10,%eax
  800862:	09 f0                	or     %esi,%eax
  800864:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800866:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800869:	89 f8                	mov    %edi,%eax
  80086b:	09 d8                	or     %ebx,%eax
  80086d:	89 d7                	mov    %edx,%edi
  80086f:	fc                   	cld    
  800870:	f3 ab                	rep stos %eax,%es:(%edi)
  800872:	eb 08                	jmp    80087c <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800874:	89 d7                	mov    %edx,%edi
  800876:	8b 45 0c             	mov    0xc(%ebp),%eax
  800879:	fc                   	cld    
  80087a:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  80087c:	89 d0                	mov    %edx,%eax
  80087e:	5b                   	pop    %ebx
  80087f:	5e                   	pop    %esi
  800880:	5f                   	pop    %edi
  800881:	5d                   	pop    %ebp
  800882:	c3                   	ret    

00800883 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800883:	55                   	push   %ebp
  800884:	89 e5                	mov    %esp,%ebp
  800886:	57                   	push   %edi
  800887:	56                   	push   %esi
  800888:	8b 45 08             	mov    0x8(%ebp),%eax
  80088b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80088e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800891:	39 c6                	cmp    %eax,%esi
  800893:	73 35                	jae    8008ca <memmove+0x47>
  800895:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800898:	39 d0                	cmp    %edx,%eax
  80089a:	73 2e                	jae    8008ca <memmove+0x47>
		s += n;
		d += n;
  80089c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80089f:	89 d6                	mov    %edx,%esi
  8008a1:	09 fe                	or     %edi,%esi
  8008a3:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008a9:	75 13                	jne    8008be <memmove+0x3b>
  8008ab:	f6 c1 03             	test   $0x3,%cl
  8008ae:	75 0e                	jne    8008be <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  8008b0:	83 ef 04             	sub    $0x4,%edi
  8008b3:	8d 72 fc             	lea    -0x4(%edx),%esi
  8008b6:	c1 e9 02             	shr    $0x2,%ecx
  8008b9:	fd                   	std    
  8008ba:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008bc:	eb 09                	jmp    8008c7 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8008be:	83 ef 01             	sub    $0x1,%edi
  8008c1:	8d 72 ff             	lea    -0x1(%edx),%esi
  8008c4:	fd                   	std    
  8008c5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8008c7:	fc                   	cld    
  8008c8:	eb 1d                	jmp    8008e7 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008ca:	89 f2                	mov    %esi,%edx
  8008cc:	09 c2                	or     %eax,%edx
  8008ce:	f6 c2 03             	test   $0x3,%dl
  8008d1:	75 0f                	jne    8008e2 <memmove+0x5f>
  8008d3:	f6 c1 03             	test   $0x3,%cl
  8008d6:	75 0a                	jne    8008e2 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  8008d8:	c1 e9 02             	shr    $0x2,%ecx
  8008db:	89 c7                	mov    %eax,%edi
  8008dd:	fc                   	cld    
  8008de:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008e0:	eb 05                	jmp    8008e7 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8008e2:	89 c7                	mov    %eax,%edi
  8008e4:	fc                   	cld    
  8008e5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8008e7:	5e                   	pop    %esi
  8008e8:	5f                   	pop    %edi
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8008ee:	ff 75 10             	pushl  0x10(%ebp)
  8008f1:	ff 75 0c             	pushl  0xc(%ebp)
  8008f4:	ff 75 08             	pushl  0x8(%ebp)
  8008f7:	e8 87 ff ff ff       	call   800883 <memmove>
}
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	56                   	push   %esi
  800902:	53                   	push   %ebx
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	8b 55 0c             	mov    0xc(%ebp),%edx
  800909:	89 c6                	mov    %eax,%esi
  80090b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80090e:	eb 1a                	jmp    80092a <memcmp+0x2c>
		if (*s1 != *s2)
  800910:	0f b6 08             	movzbl (%eax),%ecx
  800913:	0f b6 1a             	movzbl (%edx),%ebx
  800916:	38 d9                	cmp    %bl,%cl
  800918:	74 0a                	je     800924 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  80091a:	0f b6 c1             	movzbl %cl,%eax
  80091d:	0f b6 db             	movzbl %bl,%ebx
  800920:	29 d8                	sub    %ebx,%eax
  800922:	eb 0f                	jmp    800933 <memcmp+0x35>
		s1++, s2++;
  800924:	83 c0 01             	add    $0x1,%eax
  800927:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80092a:	39 f0                	cmp    %esi,%eax
  80092c:	75 e2                	jne    800910 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80092e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800933:	5b                   	pop    %ebx
  800934:	5e                   	pop    %esi
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    

00800937 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	53                   	push   %ebx
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  80093e:	89 c1                	mov    %eax,%ecx
  800940:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  800943:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800947:	eb 0a                	jmp    800953 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800949:	0f b6 10             	movzbl (%eax),%edx
  80094c:	39 da                	cmp    %ebx,%edx
  80094e:	74 07                	je     800957 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800950:	83 c0 01             	add    $0x1,%eax
  800953:	39 c8                	cmp    %ecx,%eax
  800955:	72 f2                	jb     800949 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800957:	5b                   	pop    %ebx
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	57                   	push   %edi
  80095e:	56                   	push   %esi
  80095f:	53                   	push   %ebx
  800960:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800963:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800966:	eb 03                	jmp    80096b <strtol+0x11>
		s++;
  800968:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80096b:	0f b6 01             	movzbl (%ecx),%eax
  80096e:	3c 20                	cmp    $0x20,%al
  800970:	74 f6                	je     800968 <strtol+0xe>
  800972:	3c 09                	cmp    $0x9,%al
  800974:	74 f2                	je     800968 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800976:	3c 2b                	cmp    $0x2b,%al
  800978:	75 0a                	jne    800984 <strtol+0x2a>
		s++;
  80097a:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  80097d:	bf 00 00 00 00       	mov    $0x0,%edi
  800982:	eb 11                	jmp    800995 <strtol+0x3b>
  800984:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800989:	3c 2d                	cmp    $0x2d,%al
  80098b:	75 08                	jne    800995 <strtol+0x3b>
		s++, neg = 1;
  80098d:	83 c1 01             	add    $0x1,%ecx
  800990:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800995:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80099b:	75 15                	jne    8009b2 <strtol+0x58>
  80099d:	80 39 30             	cmpb   $0x30,(%ecx)
  8009a0:	75 10                	jne    8009b2 <strtol+0x58>
  8009a2:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8009a6:	75 7c                	jne    800a24 <strtol+0xca>
		s += 2, base = 16;
  8009a8:	83 c1 02             	add    $0x2,%ecx
  8009ab:	bb 10 00 00 00       	mov    $0x10,%ebx
  8009b0:	eb 16                	jmp    8009c8 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  8009b2:	85 db                	test   %ebx,%ebx
  8009b4:	75 12                	jne    8009c8 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009b6:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009bb:	80 39 30             	cmpb   $0x30,(%ecx)
  8009be:	75 08                	jne    8009c8 <strtol+0x6e>
		s++, base = 8;
  8009c0:	83 c1 01             	add    $0x1,%ecx
  8009c3:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  8009c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009cd:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8009d0:	0f b6 11             	movzbl (%ecx),%edx
  8009d3:	8d 72 d0             	lea    -0x30(%edx),%esi
  8009d6:	89 f3                	mov    %esi,%ebx
  8009d8:	80 fb 09             	cmp    $0x9,%bl
  8009db:	77 08                	ja     8009e5 <strtol+0x8b>
			dig = *s - '0';
  8009dd:	0f be d2             	movsbl %dl,%edx
  8009e0:	83 ea 30             	sub    $0x30,%edx
  8009e3:	eb 22                	jmp    800a07 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  8009e5:	8d 72 9f             	lea    -0x61(%edx),%esi
  8009e8:	89 f3                	mov    %esi,%ebx
  8009ea:	80 fb 19             	cmp    $0x19,%bl
  8009ed:	77 08                	ja     8009f7 <strtol+0x9d>
			dig = *s - 'a' + 10;
  8009ef:	0f be d2             	movsbl %dl,%edx
  8009f2:	83 ea 57             	sub    $0x57,%edx
  8009f5:	eb 10                	jmp    800a07 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  8009f7:	8d 72 bf             	lea    -0x41(%edx),%esi
  8009fa:	89 f3                	mov    %esi,%ebx
  8009fc:	80 fb 19             	cmp    $0x19,%bl
  8009ff:	77 16                	ja     800a17 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800a01:	0f be d2             	movsbl %dl,%edx
  800a04:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800a07:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a0a:	7d 0b                	jge    800a17 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800a0c:	83 c1 01             	add    $0x1,%ecx
  800a0f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a13:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800a15:	eb b9                	jmp    8009d0 <strtol+0x76>

	if (endptr)
  800a17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a1b:	74 0d                	je     800a2a <strtol+0xd0>
		*endptr = (char *) s;
  800a1d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a20:	89 0e                	mov    %ecx,(%esi)
  800a22:	eb 06                	jmp    800a2a <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a24:	85 db                	test   %ebx,%ebx
  800a26:	74 98                	je     8009c0 <strtol+0x66>
  800a28:	eb 9e                	jmp    8009c8 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800a2a:	89 c2                	mov    %eax,%edx
  800a2c:	f7 da                	neg    %edx
  800a2e:	85 ff                	test   %edi,%edi
  800a30:	0f 45 c2             	cmovne %edx,%eax
}
  800a33:	5b                   	pop    %ebx
  800a34:	5e                   	pop    %esi
  800a35:	5f                   	pop    %edi
  800a36:	5d                   	pop    %ebp
  800a37:	c3                   	ret    

00800a38 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
  800a3b:	57                   	push   %edi
  800a3c:	56                   	push   %esi
  800a3d:	53                   	push   %ebx
  800a3e:	83 ec 1c             	sub    $0x1c,%esp
  800a41:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a44:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a47:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800a49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a4c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a4f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800a52:	8b 75 14             	mov    0x14(%ebp),%esi
  800a55:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800a57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5b:	74 1d                	je     800a7a <syscall+0x42>
  800a5d:	85 c0                	test   %eax,%eax
  800a5f:	7e 19                	jle    800a7a <syscall+0x42>
  800a61:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800a64:	83 ec 0c             	sub    $0xc,%esp
  800a67:	50                   	push   %eax
  800a68:	52                   	push   %edx
  800a69:	68 bf 20 80 00       	push   $0x8020bf
  800a6e:	6a 23                	push   $0x23
  800a70:	68 dc 20 80 00       	push   $0x8020dc
  800a75:	e8 e9 0e 00 00       	call   801963 <_panic>

	return ret;
}
  800a7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a7d:	5b                   	pop    %ebx
  800a7e:	5e                   	pop    %esi
  800a7f:	5f                   	pop    %edi
  800a80:	5d                   	pop    %ebp
  800a81:	c3                   	ret    

00800a82 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800a88:	6a 00                	push   $0x0
  800a8a:	6a 00                	push   $0x0
  800a8c:	6a 00                	push   $0x0
  800a8e:	ff 75 0c             	pushl  0xc(%ebp)
  800a91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a94:	ba 00 00 00 00       	mov    $0x0,%edx
  800a99:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9e:	e8 95 ff ff ff       	call   800a38 <syscall>
}
  800aa3:	83 c4 10             	add    $0x10,%esp
  800aa6:	c9                   	leave  
  800aa7:	c3                   	ret    

00800aa8 <sys_cgetc>:

int
sys_cgetc(void)
{
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800aae:	6a 00                	push   $0x0
  800ab0:	6a 00                	push   $0x0
  800ab2:	6a 00                	push   $0x0
  800ab4:	6a 00                	push   $0x0
  800ab6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800abb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac0:	b8 01 00 00 00       	mov    $0x1,%eax
  800ac5:	e8 6e ff ff ff       	call   800a38 <syscall>
}
  800aca:	c9                   	leave  
  800acb:	c3                   	ret    

00800acc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800ad2:	6a 00                	push   $0x0
  800ad4:	6a 00                	push   $0x0
  800ad6:	6a 00                	push   $0x0
  800ad8:	6a 00                	push   $0x0
  800ada:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800add:	ba 01 00 00 00       	mov    $0x1,%edx
  800ae2:	b8 03 00 00 00       	mov    $0x3,%eax
  800ae7:	e8 4c ff ff ff       	call   800a38 <syscall>
}
  800aec:	c9                   	leave  
  800aed:	c3                   	ret    

00800aee <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800af4:	6a 00                	push   $0x0
  800af6:	6a 00                	push   $0x0
  800af8:	6a 00                	push   $0x0
  800afa:	6a 00                	push   $0x0
  800afc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b01:	ba 00 00 00 00       	mov    $0x0,%edx
  800b06:	b8 02 00 00 00       	mov    $0x2,%eax
  800b0b:	e8 28 ff ff ff       	call   800a38 <syscall>
}
  800b10:	c9                   	leave  
  800b11:	c3                   	ret    

00800b12 <sys_yield>:

void
sys_yield(void)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b18:	6a 00                	push   $0x0
  800b1a:	6a 00                	push   $0x0
  800b1c:	6a 00                	push   $0x0
  800b1e:	6a 00                	push   $0x0
  800b20:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b25:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b2f:	e8 04 ff ff ff       	call   800a38 <syscall>
}
  800b34:	83 c4 10             	add    $0x10,%esp
  800b37:	c9                   	leave  
  800b38:	c3                   	ret    

00800b39 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800b3f:	6a 00                	push   $0x0
  800b41:	6a 00                	push   $0x0
  800b43:	ff 75 10             	pushl  0x10(%ebp)
  800b46:	ff 75 0c             	pushl  0xc(%ebp)
  800b49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b4c:	ba 01 00 00 00       	mov    $0x1,%edx
  800b51:	b8 04 00 00 00       	mov    $0x4,%eax
  800b56:	e8 dd fe ff ff       	call   800a38 <syscall>
}
  800b5b:	c9                   	leave  
  800b5c:	c3                   	ret    

00800b5d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b5d:	55                   	push   %ebp
  800b5e:	89 e5                	mov    %esp,%ebp
  800b60:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800b63:	ff 75 18             	pushl  0x18(%ebp)
  800b66:	ff 75 14             	pushl  0x14(%ebp)
  800b69:	ff 75 10             	pushl  0x10(%ebp)
  800b6c:	ff 75 0c             	pushl  0xc(%ebp)
  800b6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b72:	ba 01 00 00 00       	mov    $0x1,%edx
  800b77:	b8 05 00 00 00       	mov    $0x5,%eax
  800b7c:	e8 b7 fe ff ff       	call   800a38 <syscall>
}
  800b81:	c9                   	leave  
  800b82:	c3                   	ret    

00800b83 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800b89:	6a 00                	push   $0x0
  800b8b:	6a 00                	push   $0x0
  800b8d:	6a 00                	push   $0x0
  800b8f:	ff 75 0c             	pushl  0xc(%ebp)
  800b92:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b95:	ba 01 00 00 00       	mov    $0x1,%edx
  800b9a:	b8 06 00 00 00       	mov    $0x6,%eax
  800b9f:	e8 94 fe ff ff       	call   800a38 <syscall>
}
  800ba4:	c9                   	leave  
  800ba5:	c3                   	ret    

00800ba6 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800bac:	6a 00                	push   $0x0
  800bae:	6a 00                	push   $0x0
  800bb0:	6a 00                	push   $0x0
  800bb2:	ff 75 0c             	pushl  0xc(%ebp)
  800bb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb8:	ba 01 00 00 00       	mov    $0x1,%edx
  800bbd:	b8 08 00 00 00       	mov    $0x8,%eax
  800bc2:	e8 71 fe ff ff       	call   800a38 <syscall>
}
  800bc7:	c9                   	leave  
  800bc8:	c3                   	ret    

00800bc9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800bcf:	6a 00                	push   $0x0
  800bd1:	6a 00                	push   $0x0
  800bd3:	6a 00                	push   $0x0
  800bd5:	ff 75 0c             	pushl  0xc(%ebp)
  800bd8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bdb:	ba 01 00 00 00       	mov    $0x1,%edx
  800be0:	b8 09 00 00 00       	mov    $0x9,%eax
  800be5:	e8 4e fe ff ff       	call   800a38 <syscall>
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800bf2:	6a 00                	push   $0x0
  800bf4:	6a 00                	push   $0x0
  800bf6:	6a 00                	push   $0x0
  800bf8:	ff 75 0c             	pushl  0xc(%ebp)
  800bfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bfe:	ba 01 00 00 00       	mov    $0x1,%edx
  800c03:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c08:	e8 2b fe ff ff       	call   800a38 <syscall>
}
  800c0d:	c9                   	leave  
  800c0e:	c3                   	ret    

00800c0f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800c15:	6a 00                	push   $0x0
  800c17:	ff 75 14             	pushl  0x14(%ebp)
  800c1a:	ff 75 10             	pushl  0x10(%ebp)
  800c1d:	ff 75 0c             	pushl  0xc(%ebp)
  800c20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c23:	ba 00 00 00 00       	mov    $0x0,%edx
  800c28:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c2d:	e8 06 fe ff ff       	call   800a38 <syscall>
}
  800c32:	c9                   	leave  
  800c33:	c3                   	ret    

00800c34 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800c3a:	6a 00                	push   $0x0
  800c3c:	6a 00                	push   $0x0
  800c3e:	6a 00                	push   $0x0
  800c40:	6a 00                	push   $0x0
  800c42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c45:	ba 01 00 00 00       	mov    $0x1,%edx
  800c4a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800c4f:	e8 e4 fd ff ff       	call   800a38 <syscall>
}
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	05 00 00 00 30       	add    $0x30000000,%eax
  800c61:	c1 e8 0c             	shr    $0xc,%eax
}
  800c64:	5d                   	pop    %ebp
  800c65:	c3                   	ret    

00800c66 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  800c69:	ff 75 08             	pushl  0x8(%ebp)
  800c6c:	e8 e5 ff ff ff       	call   800c56 <fd2num>
  800c71:	83 c4 04             	add    $0x4,%esp
  800c74:	c1 e0 0c             	shl    $0xc,%eax
  800c77:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800c7c:	c9                   	leave  
  800c7d:	c3                   	ret    

00800c7e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c84:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800c89:	89 c2                	mov    %eax,%edx
  800c8b:	c1 ea 16             	shr    $0x16,%edx
  800c8e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800c95:	f6 c2 01             	test   $0x1,%dl
  800c98:	74 11                	je     800cab <fd_alloc+0x2d>
  800c9a:	89 c2                	mov    %eax,%edx
  800c9c:	c1 ea 0c             	shr    $0xc,%edx
  800c9f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ca6:	f6 c2 01             	test   $0x1,%dl
  800ca9:	75 09                	jne    800cb4 <fd_alloc+0x36>
			*fd_store = fd;
  800cab:	89 01                	mov    %eax,(%ecx)
			return 0;
  800cad:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb2:	eb 17                	jmp    800ccb <fd_alloc+0x4d>
  800cb4:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800cb9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800cbe:	75 c9                	jne    800c89 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800cc0:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800cc6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800ccb:	5d                   	pop    %ebp
  800ccc:	c3                   	ret    

00800ccd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800cd3:	83 f8 1f             	cmp    $0x1f,%eax
  800cd6:	77 36                	ja     800d0e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800cd8:	c1 e0 0c             	shl    $0xc,%eax
  800cdb:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ce0:	89 c2                	mov    %eax,%edx
  800ce2:	c1 ea 16             	shr    $0x16,%edx
  800ce5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800cec:	f6 c2 01             	test   $0x1,%dl
  800cef:	74 24                	je     800d15 <fd_lookup+0x48>
  800cf1:	89 c2                	mov    %eax,%edx
  800cf3:	c1 ea 0c             	shr    $0xc,%edx
  800cf6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800cfd:	f6 c2 01             	test   $0x1,%dl
  800d00:	74 1a                	je     800d1c <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800d02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d05:	89 02                	mov    %eax,(%edx)
	return 0;
  800d07:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0c:	eb 13                	jmp    800d21 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800d0e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d13:	eb 0c                	jmp    800d21 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800d15:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d1a:	eb 05                	jmp    800d21 <fd_lookup+0x54>
  800d1c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	83 ec 08             	sub    $0x8,%esp
  800d29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d2c:	ba 68 21 80 00       	mov    $0x802168,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800d31:	eb 13                	jmp    800d46 <dev_lookup+0x23>
  800d33:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  800d36:	39 08                	cmp    %ecx,(%eax)
  800d38:	75 0c                	jne    800d46 <dev_lookup+0x23>
			*dev = devtab[i];
  800d3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3d:	89 01                	mov    %eax,(%ecx)
			return 0;
  800d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d44:	eb 2e                	jmp    800d74 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800d46:	8b 02                	mov    (%edx),%eax
  800d48:	85 c0                	test   %eax,%eax
  800d4a:	75 e7                	jne    800d33 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800d4c:	a1 04 40 80 00       	mov    0x804004,%eax
  800d51:	8b 40 48             	mov    0x48(%eax),%eax
  800d54:	83 ec 04             	sub    $0x4,%esp
  800d57:	51                   	push   %ecx
  800d58:	50                   	push   %eax
  800d59:	68 ec 20 80 00       	push   $0x8020ec
  800d5e:	e8 1b f4 ff ff       	call   80017e <cprintf>
	*dev = 0;
  800d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800d6c:	83 c4 10             	add    $0x10,%esp
  800d6f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800d74:	c9                   	leave  
  800d75:	c3                   	ret    

00800d76 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
  800d7b:	83 ec 10             	sub    $0x10,%esp
  800d7e:	8b 75 08             	mov    0x8(%ebp),%esi
  800d81:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800d84:	56                   	push   %esi
  800d85:	e8 cc fe ff ff       	call   800c56 <fd2num>
  800d8a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800d8d:	89 14 24             	mov    %edx,(%esp)
  800d90:	50                   	push   %eax
  800d91:	e8 37 ff ff ff       	call   800ccd <fd_lookup>
  800d96:	83 c4 08             	add    $0x8,%esp
  800d99:	85 c0                	test   %eax,%eax
  800d9b:	78 05                	js     800da2 <fd_close+0x2c>
	    || fd != fd2)
  800d9d:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800da0:	74 0c                	je     800dae <fd_close+0x38>
		return (must_exist ? r : 0);
  800da2:	84 db                	test   %bl,%bl
  800da4:	ba 00 00 00 00       	mov    $0x0,%edx
  800da9:	0f 44 c2             	cmove  %edx,%eax
  800dac:	eb 41                	jmp    800def <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800dae:	83 ec 08             	sub    $0x8,%esp
  800db1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800db4:	50                   	push   %eax
  800db5:	ff 36                	pushl  (%esi)
  800db7:	e8 67 ff ff ff       	call   800d23 <dev_lookup>
  800dbc:	89 c3                	mov    %eax,%ebx
  800dbe:	83 c4 10             	add    $0x10,%esp
  800dc1:	85 c0                	test   %eax,%eax
  800dc3:	78 1a                	js     800ddf <fd_close+0x69>
		if (dev->dev_close)
  800dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dc8:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800dcb:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800dd0:	85 c0                	test   %eax,%eax
  800dd2:	74 0b                	je     800ddf <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  800dd4:	83 ec 0c             	sub    $0xc,%esp
  800dd7:	56                   	push   %esi
  800dd8:	ff d0                	call   *%eax
  800dda:	89 c3                	mov    %eax,%ebx
  800ddc:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800ddf:	83 ec 08             	sub    $0x8,%esp
  800de2:	56                   	push   %esi
  800de3:	6a 00                	push   $0x0
  800de5:	e8 99 fd ff ff       	call   800b83 <sys_page_unmap>
	return r;
  800dea:	83 c4 10             	add    $0x10,%esp
  800ded:	89 d8                	mov    %ebx,%eax
}
  800def:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800df2:	5b                   	pop    %ebx
  800df3:	5e                   	pop    %esi
  800df4:	5d                   	pop    %ebp
  800df5:	c3                   	ret    

00800df6 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800dfc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800dff:	50                   	push   %eax
  800e00:	ff 75 08             	pushl  0x8(%ebp)
  800e03:	e8 c5 fe ff ff       	call   800ccd <fd_lookup>
  800e08:	83 c4 08             	add    $0x8,%esp
  800e0b:	85 c0                	test   %eax,%eax
  800e0d:	78 10                	js     800e1f <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800e0f:	83 ec 08             	sub    $0x8,%esp
  800e12:	6a 01                	push   $0x1
  800e14:	ff 75 f4             	pushl  -0xc(%ebp)
  800e17:	e8 5a ff ff ff       	call   800d76 <fd_close>
  800e1c:	83 c4 10             	add    $0x10,%esp
}
  800e1f:	c9                   	leave  
  800e20:	c3                   	ret    

00800e21 <close_all>:

void
close_all(void)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	53                   	push   %ebx
  800e25:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800e28:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800e2d:	83 ec 0c             	sub    $0xc,%esp
  800e30:	53                   	push   %ebx
  800e31:	e8 c0 ff ff ff       	call   800df6 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800e36:	83 c3 01             	add    $0x1,%ebx
  800e39:	83 c4 10             	add    $0x10,%esp
  800e3c:	83 fb 20             	cmp    $0x20,%ebx
  800e3f:	75 ec                	jne    800e2d <close_all+0xc>
		close(i);
}
  800e41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	57                   	push   %edi
  800e4a:	56                   	push   %esi
  800e4b:	53                   	push   %ebx
  800e4c:	83 ec 2c             	sub    $0x2c,%esp
  800e4f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800e52:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800e55:	50                   	push   %eax
  800e56:	ff 75 08             	pushl  0x8(%ebp)
  800e59:	e8 6f fe ff ff       	call   800ccd <fd_lookup>
  800e5e:	83 c4 08             	add    $0x8,%esp
  800e61:	85 c0                	test   %eax,%eax
  800e63:	0f 88 c1 00 00 00    	js     800f2a <dup+0xe4>
		return r;
	close(newfdnum);
  800e69:	83 ec 0c             	sub    $0xc,%esp
  800e6c:	56                   	push   %esi
  800e6d:	e8 84 ff ff ff       	call   800df6 <close>

	newfd = INDEX2FD(newfdnum);
  800e72:	89 f3                	mov    %esi,%ebx
  800e74:	c1 e3 0c             	shl    $0xc,%ebx
  800e77:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800e7d:	83 c4 04             	add    $0x4,%esp
  800e80:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e83:	e8 de fd ff ff       	call   800c66 <fd2data>
  800e88:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  800e8a:	89 1c 24             	mov    %ebx,(%esp)
  800e8d:	e8 d4 fd ff ff       	call   800c66 <fd2data>
  800e92:	83 c4 10             	add    $0x10,%esp
  800e95:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800e98:	89 f8                	mov    %edi,%eax
  800e9a:	c1 e8 16             	shr    $0x16,%eax
  800e9d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800ea4:	a8 01                	test   $0x1,%al
  800ea6:	74 37                	je     800edf <dup+0x99>
  800ea8:	89 f8                	mov    %edi,%eax
  800eaa:	c1 e8 0c             	shr    $0xc,%eax
  800ead:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800eb4:	f6 c2 01             	test   $0x1,%dl
  800eb7:	74 26                	je     800edf <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800eb9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ec0:	83 ec 0c             	sub    $0xc,%esp
  800ec3:	25 07 0e 00 00       	and    $0xe07,%eax
  800ec8:	50                   	push   %eax
  800ec9:	ff 75 d4             	pushl  -0x2c(%ebp)
  800ecc:	6a 00                	push   $0x0
  800ece:	57                   	push   %edi
  800ecf:	6a 00                	push   $0x0
  800ed1:	e8 87 fc ff ff       	call   800b5d <sys_page_map>
  800ed6:	89 c7                	mov    %eax,%edi
  800ed8:	83 c4 20             	add    $0x20,%esp
  800edb:	85 c0                	test   %eax,%eax
  800edd:	78 2e                	js     800f0d <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800edf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ee2:	89 d0                	mov    %edx,%eax
  800ee4:	c1 e8 0c             	shr    $0xc,%eax
  800ee7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800eee:	83 ec 0c             	sub    $0xc,%esp
  800ef1:	25 07 0e 00 00       	and    $0xe07,%eax
  800ef6:	50                   	push   %eax
  800ef7:	53                   	push   %ebx
  800ef8:	6a 00                	push   $0x0
  800efa:	52                   	push   %edx
  800efb:	6a 00                	push   $0x0
  800efd:	e8 5b fc ff ff       	call   800b5d <sys_page_map>
  800f02:	89 c7                	mov    %eax,%edi
  800f04:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  800f07:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800f09:	85 ff                	test   %edi,%edi
  800f0b:	79 1d                	jns    800f2a <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800f0d:	83 ec 08             	sub    $0x8,%esp
  800f10:	53                   	push   %ebx
  800f11:	6a 00                	push   $0x0
  800f13:	e8 6b fc ff ff       	call   800b83 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800f18:	83 c4 08             	add    $0x8,%esp
  800f1b:	ff 75 d4             	pushl  -0x2c(%ebp)
  800f1e:	6a 00                	push   $0x0
  800f20:	e8 5e fc ff ff       	call   800b83 <sys_page_unmap>
	return r;
  800f25:	83 c4 10             	add    $0x10,%esp
  800f28:	89 f8                	mov    %edi,%eax
}
  800f2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2d:	5b                   	pop    %ebx
  800f2e:	5e                   	pop    %esi
  800f2f:	5f                   	pop    %edi
  800f30:	5d                   	pop    %ebp
  800f31:	c3                   	ret    

00800f32 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	53                   	push   %ebx
  800f36:	83 ec 14             	sub    $0x14,%esp
  800f39:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800f3c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800f3f:	50                   	push   %eax
  800f40:	53                   	push   %ebx
  800f41:	e8 87 fd ff ff       	call   800ccd <fd_lookup>
  800f46:	83 c4 08             	add    $0x8,%esp
  800f49:	89 c2                	mov    %eax,%edx
  800f4b:	85 c0                	test   %eax,%eax
  800f4d:	78 6d                	js     800fbc <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f55:	50                   	push   %eax
  800f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f59:	ff 30                	pushl  (%eax)
  800f5b:	e8 c3 fd ff ff       	call   800d23 <dev_lookup>
  800f60:	83 c4 10             	add    $0x10,%esp
  800f63:	85 c0                	test   %eax,%eax
  800f65:	78 4c                	js     800fb3 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800f67:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f6a:	8b 42 08             	mov    0x8(%edx),%eax
  800f6d:	83 e0 03             	and    $0x3,%eax
  800f70:	83 f8 01             	cmp    $0x1,%eax
  800f73:	75 21                	jne    800f96 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800f75:	a1 04 40 80 00       	mov    0x804004,%eax
  800f7a:	8b 40 48             	mov    0x48(%eax),%eax
  800f7d:	83 ec 04             	sub    $0x4,%esp
  800f80:	53                   	push   %ebx
  800f81:	50                   	push   %eax
  800f82:	68 2d 21 80 00       	push   $0x80212d
  800f87:	e8 f2 f1 ff ff       	call   80017e <cprintf>
		return -E_INVAL;
  800f8c:	83 c4 10             	add    $0x10,%esp
  800f8f:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800f94:	eb 26                	jmp    800fbc <read+0x8a>
	}
	if (!dev->dev_read)
  800f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f99:	8b 40 08             	mov    0x8(%eax),%eax
  800f9c:	85 c0                	test   %eax,%eax
  800f9e:	74 17                	je     800fb7 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800fa0:	83 ec 04             	sub    $0x4,%esp
  800fa3:	ff 75 10             	pushl  0x10(%ebp)
  800fa6:	ff 75 0c             	pushl  0xc(%ebp)
  800fa9:	52                   	push   %edx
  800faa:	ff d0                	call   *%eax
  800fac:	89 c2                	mov    %eax,%edx
  800fae:	83 c4 10             	add    $0x10,%esp
  800fb1:	eb 09                	jmp    800fbc <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800fb3:	89 c2                	mov    %eax,%edx
  800fb5:	eb 05                	jmp    800fbc <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800fb7:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  800fbc:	89 d0                	mov    %edx,%eax
  800fbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fc1:	c9                   	leave  
  800fc2:	c3                   	ret    

00800fc3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	57                   	push   %edi
  800fc7:	56                   	push   %esi
  800fc8:	53                   	push   %ebx
  800fc9:	83 ec 0c             	sub    $0xc,%esp
  800fcc:	8b 7d 08             	mov    0x8(%ebp),%edi
  800fcf:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800fd2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd7:	eb 21                	jmp    800ffa <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800fd9:	83 ec 04             	sub    $0x4,%esp
  800fdc:	89 f0                	mov    %esi,%eax
  800fde:	29 d8                	sub    %ebx,%eax
  800fe0:	50                   	push   %eax
  800fe1:	89 d8                	mov    %ebx,%eax
  800fe3:	03 45 0c             	add    0xc(%ebp),%eax
  800fe6:	50                   	push   %eax
  800fe7:	57                   	push   %edi
  800fe8:	e8 45 ff ff ff       	call   800f32 <read>
		if (m < 0)
  800fed:	83 c4 10             	add    $0x10,%esp
  800ff0:	85 c0                	test   %eax,%eax
  800ff2:	78 10                	js     801004 <readn+0x41>
			return m;
		if (m == 0)
  800ff4:	85 c0                	test   %eax,%eax
  800ff6:	74 0a                	je     801002 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800ff8:	01 c3                	add    %eax,%ebx
  800ffa:	39 f3                	cmp    %esi,%ebx
  800ffc:	72 db                	jb     800fd9 <readn+0x16>
  800ffe:	89 d8                	mov    %ebx,%eax
  801000:	eb 02                	jmp    801004 <readn+0x41>
  801002:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801004:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801007:	5b                   	pop    %ebx
  801008:	5e                   	pop    %esi
  801009:	5f                   	pop    %edi
  80100a:	5d                   	pop    %ebp
  80100b:	c3                   	ret    

0080100c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	53                   	push   %ebx
  801010:	83 ec 14             	sub    $0x14,%esp
  801013:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801016:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801019:	50                   	push   %eax
  80101a:	53                   	push   %ebx
  80101b:	e8 ad fc ff ff       	call   800ccd <fd_lookup>
  801020:	83 c4 08             	add    $0x8,%esp
  801023:	89 c2                	mov    %eax,%edx
  801025:	85 c0                	test   %eax,%eax
  801027:	78 68                	js     801091 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801029:	83 ec 08             	sub    $0x8,%esp
  80102c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80102f:	50                   	push   %eax
  801030:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801033:	ff 30                	pushl  (%eax)
  801035:	e8 e9 fc ff ff       	call   800d23 <dev_lookup>
  80103a:	83 c4 10             	add    $0x10,%esp
  80103d:	85 c0                	test   %eax,%eax
  80103f:	78 47                	js     801088 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801044:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801048:	75 21                	jne    80106b <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80104a:	a1 04 40 80 00       	mov    0x804004,%eax
  80104f:	8b 40 48             	mov    0x48(%eax),%eax
  801052:	83 ec 04             	sub    $0x4,%esp
  801055:	53                   	push   %ebx
  801056:	50                   	push   %eax
  801057:	68 49 21 80 00       	push   $0x802149
  80105c:	e8 1d f1 ff ff       	call   80017e <cprintf>
		return -E_INVAL;
  801061:	83 c4 10             	add    $0x10,%esp
  801064:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801069:	eb 26                	jmp    801091 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80106b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80106e:	8b 52 0c             	mov    0xc(%edx),%edx
  801071:	85 d2                	test   %edx,%edx
  801073:	74 17                	je     80108c <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801075:	83 ec 04             	sub    $0x4,%esp
  801078:	ff 75 10             	pushl  0x10(%ebp)
  80107b:	ff 75 0c             	pushl  0xc(%ebp)
  80107e:	50                   	push   %eax
  80107f:	ff d2                	call   *%edx
  801081:	89 c2                	mov    %eax,%edx
  801083:	83 c4 10             	add    $0x10,%esp
  801086:	eb 09                	jmp    801091 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801088:	89 c2                	mov    %eax,%edx
  80108a:	eb 05                	jmp    801091 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80108c:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  801091:	89 d0                	mov    %edx,%eax
  801093:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801096:	c9                   	leave  
  801097:	c3                   	ret    

00801098 <seek>:

int
seek(int fdnum, off_t offset)
{
  801098:	55                   	push   %ebp
  801099:	89 e5                	mov    %esp,%ebp
  80109b:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80109e:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8010a1:	50                   	push   %eax
  8010a2:	ff 75 08             	pushl  0x8(%ebp)
  8010a5:	e8 23 fc ff ff       	call   800ccd <fd_lookup>
  8010aa:	83 c4 08             	add    $0x8,%esp
  8010ad:	85 c0                	test   %eax,%eax
  8010af:	78 0e                	js     8010bf <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8010b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b7:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8010ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010bf:	c9                   	leave  
  8010c0:	c3                   	ret    

008010c1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	53                   	push   %ebx
  8010c5:	83 ec 14             	sub    $0x14,%esp
  8010c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010ce:	50                   	push   %eax
  8010cf:	53                   	push   %ebx
  8010d0:	e8 f8 fb ff ff       	call   800ccd <fd_lookup>
  8010d5:	83 c4 08             	add    $0x8,%esp
  8010d8:	89 c2                	mov    %eax,%edx
  8010da:	85 c0                	test   %eax,%eax
  8010dc:	78 65                	js     801143 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010de:	83 ec 08             	sub    $0x8,%esp
  8010e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010e4:	50                   	push   %eax
  8010e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010e8:	ff 30                	pushl  (%eax)
  8010ea:	e8 34 fc ff ff       	call   800d23 <dev_lookup>
  8010ef:	83 c4 10             	add    $0x10,%esp
  8010f2:	85 c0                	test   %eax,%eax
  8010f4:	78 44                	js     80113a <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8010f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010f9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8010fd:	75 21                	jne    801120 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8010ff:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801104:	8b 40 48             	mov    0x48(%eax),%eax
  801107:	83 ec 04             	sub    $0x4,%esp
  80110a:	53                   	push   %ebx
  80110b:	50                   	push   %eax
  80110c:	68 0c 21 80 00       	push   $0x80210c
  801111:	e8 68 f0 ff ff       	call   80017e <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801116:	83 c4 10             	add    $0x10,%esp
  801119:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80111e:	eb 23                	jmp    801143 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  801120:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801123:	8b 52 18             	mov    0x18(%edx),%edx
  801126:	85 d2                	test   %edx,%edx
  801128:	74 14                	je     80113e <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80112a:	83 ec 08             	sub    $0x8,%esp
  80112d:	ff 75 0c             	pushl  0xc(%ebp)
  801130:	50                   	push   %eax
  801131:	ff d2                	call   *%edx
  801133:	89 c2                	mov    %eax,%edx
  801135:	83 c4 10             	add    $0x10,%esp
  801138:	eb 09                	jmp    801143 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80113a:	89 c2                	mov    %eax,%edx
  80113c:	eb 05                	jmp    801143 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80113e:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  801143:	89 d0                	mov    %edx,%eax
  801145:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801148:	c9                   	leave  
  801149:	c3                   	ret    

0080114a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	53                   	push   %ebx
  80114e:	83 ec 14             	sub    $0x14,%esp
  801151:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801154:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801157:	50                   	push   %eax
  801158:	ff 75 08             	pushl  0x8(%ebp)
  80115b:	e8 6d fb ff ff       	call   800ccd <fd_lookup>
  801160:	83 c4 08             	add    $0x8,%esp
  801163:	89 c2                	mov    %eax,%edx
  801165:	85 c0                	test   %eax,%eax
  801167:	78 58                	js     8011c1 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801169:	83 ec 08             	sub    $0x8,%esp
  80116c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80116f:	50                   	push   %eax
  801170:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801173:	ff 30                	pushl  (%eax)
  801175:	e8 a9 fb ff ff       	call   800d23 <dev_lookup>
  80117a:	83 c4 10             	add    $0x10,%esp
  80117d:	85 c0                	test   %eax,%eax
  80117f:	78 37                	js     8011b8 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  801181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801184:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801188:	74 32                	je     8011bc <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80118a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80118d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801194:	00 00 00 
	stat->st_isdir = 0;
  801197:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80119e:	00 00 00 
	stat->st_dev = dev;
  8011a1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8011a7:	83 ec 08             	sub    $0x8,%esp
  8011aa:	53                   	push   %ebx
  8011ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8011ae:	ff 50 14             	call   *0x14(%eax)
  8011b1:	89 c2                	mov    %eax,%edx
  8011b3:	83 c4 10             	add    $0x10,%esp
  8011b6:	eb 09                	jmp    8011c1 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011b8:	89 c2                	mov    %eax,%edx
  8011ba:	eb 05                	jmp    8011c1 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8011bc:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8011c1:	89 d0                	mov    %edx,%eax
  8011c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011c6:	c9                   	leave  
  8011c7:	c3                   	ret    

008011c8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	56                   	push   %esi
  8011cc:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8011cd:	83 ec 08             	sub    $0x8,%esp
  8011d0:	6a 00                	push   $0x0
  8011d2:	ff 75 08             	pushl  0x8(%ebp)
  8011d5:	e8 06 02 00 00       	call   8013e0 <open>
  8011da:	89 c3                	mov    %eax,%ebx
  8011dc:	83 c4 10             	add    $0x10,%esp
  8011df:	85 c0                	test   %eax,%eax
  8011e1:	78 1b                	js     8011fe <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8011e3:	83 ec 08             	sub    $0x8,%esp
  8011e6:	ff 75 0c             	pushl  0xc(%ebp)
  8011e9:	50                   	push   %eax
  8011ea:	e8 5b ff ff ff       	call   80114a <fstat>
  8011ef:	89 c6                	mov    %eax,%esi
	close(fd);
  8011f1:	89 1c 24             	mov    %ebx,(%esp)
  8011f4:	e8 fd fb ff ff       	call   800df6 <close>
	return r;
  8011f9:	83 c4 10             	add    $0x10,%esp
  8011fc:	89 f0                	mov    %esi,%eax
}
  8011fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801201:	5b                   	pop    %ebx
  801202:	5e                   	pop    %esi
  801203:	5d                   	pop    %ebp
  801204:	c3                   	ret    

00801205 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	56                   	push   %esi
  801209:	53                   	push   %ebx
  80120a:	89 c6                	mov    %eax,%esi
  80120c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80120e:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801215:	75 12                	jne    801229 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801217:	83 ec 0c             	sub    $0xc,%esp
  80121a:	6a 01                	push   $0x1
  80121c:	e8 47 08 00 00       	call   801a68 <ipc_find_env>
  801221:	a3 00 40 80 00       	mov    %eax,0x804000
  801226:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801229:	6a 07                	push   $0x7
  80122b:	68 00 50 80 00       	push   $0x805000
  801230:	56                   	push   %esi
  801231:	ff 35 00 40 80 00    	pushl  0x804000
  801237:	e8 d8 07 00 00       	call   801a14 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80123c:	83 c4 0c             	add    $0xc,%esp
  80123f:	6a 00                	push   $0x0
  801241:	53                   	push   %ebx
  801242:	6a 00                	push   $0x0
  801244:	e8 60 07 00 00       	call   8019a9 <ipc_recv>
}
  801249:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80124c:	5b                   	pop    %ebx
  80124d:	5e                   	pop    %esi
  80124e:	5d                   	pop    %ebp
  80124f:	c3                   	ret    

00801250 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	8b 40 0c             	mov    0xc(%eax),%eax
  80125c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801261:	8b 45 0c             	mov    0xc(%ebp),%eax
  801264:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801269:	ba 00 00 00 00       	mov    $0x0,%edx
  80126e:	b8 02 00 00 00       	mov    $0x2,%eax
  801273:	e8 8d ff ff ff       	call   801205 <fsipc>
}
  801278:	c9                   	leave  
  801279:	c3                   	ret    

0080127a <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
  80127d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	8b 40 0c             	mov    0xc(%eax),%eax
  801286:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80128b:	ba 00 00 00 00       	mov    $0x0,%edx
  801290:	b8 06 00 00 00       	mov    $0x6,%eax
  801295:	e8 6b ff ff ff       	call   801205 <fsipc>
}
  80129a:	c9                   	leave  
  80129b:	c3                   	ret    

0080129c <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	53                   	push   %ebx
  8012a0:	83 ec 04             	sub    $0x4,%esp
  8012a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8012ac:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8012b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8012b6:	b8 05 00 00 00       	mov    $0x5,%eax
  8012bb:	e8 45 ff ff ff       	call   801205 <fsipc>
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	78 2c                	js     8012f0 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8012c4:	83 ec 08             	sub    $0x8,%esp
  8012c7:	68 00 50 80 00       	push   $0x805000
  8012cc:	53                   	push   %ebx
  8012cd:	e8 1e f4 ff ff       	call   8006f0 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8012d2:	a1 80 50 80 00       	mov    0x805080,%eax
  8012d7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8012dd:	a1 84 50 80 00       	mov    0x805084,%eax
  8012e2:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8012e8:	83 c4 10             	add    $0x10,%esp
  8012eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    

008012f5 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
  8012f8:	83 ec 08             	sub    $0x8,%esp
  8012fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fe:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801301:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801304:	8b 49 0c             	mov    0xc(%ecx),%ecx
  801307:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  80130d:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801312:	76 22                	jbe    801336 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  801314:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  80131b:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  80131e:	83 ec 04             	sub    $0x4,%esp
  801321:	68 f8 0f 00 00       	push   $0xff8
  801326:	52                   	push   %edx
  801327:	68 08 50 80 00       	push   $0x805008
  80132c:	e8 52 f5 ff ff       	call   800883 <memmove>
  801331:	83 c4 10             	add    $0x10,%esp
  801334:	eb 17                	jmp    80134d <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  801336:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  80133b:	83 ec 04             	sub    $0x4,%esp
  80133e:	50                   	push   %eax
  80133f:	52                   	push   %edx
  801340:	68 08 50 80 00       	push   $0x805008
  801345:	e8 39 f5 ff ff       	call   800883 <memmove>
  80134a:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  80134d:	ba 00 00 00 00       	mov    $0x0,%edx
  801352:	b8 04 00 00 00       	mov    $0x4,%eax
  801357:	e8 a9 fe ff ff       	call   801205 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    

0080135e <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
  801361:	56                   	push   %esi
  801362:	53                   	push   %ebx
  801363:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801366:	8b 45 08             	mov    0x8(%ebp),%eax
  801369:	8b 40 0c             	mov    0xc(%eax),%eax
  80136c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801371:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801377:	ba 00 00 00 00       	mov    $0x0,%edx
  80137c:	b8 03 00 00 00       	mov    $0x3,%eax
  801381:	e8 7f fe ff ff       	call   801205 <fsipc>
  801386:	89 c3                	mov    %eax,%ebx
  801388:	85 c0                	test   %eax,%eax
  80138a:	78 4b                	js     8013d7 <devfile_read+0x79>
		return r;
	assert(r <= n);
  80138c:	39 c6                	cmp    %eax,%esi
  80138e:	73 16                	jae    8013a6 <devfile_read+0x48>
  801390:	68 78 21 80 00       	push   $0x802178
  801395:	68 7f 21 80 00       	push   $0x80217f
  80139a:	6a 7c                	push   $0x7c
  80139c:	68 94 21 80 00       	push   $0x802194
  8013a1:	e8 bd 05 00 00       	call   801963 <_panic>
	assert(r <= PGSIZE);
  8013a6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8013ab:	7e 16                	jle    8013c3 <devfile_read+0x65>
  8013ad:	68 9f 21 80 00       	push   $0x80219f
  8013b2:	68 7f 21 80 00       	push   $0x80217f
  8013b7:	6a 7d                	push   $0x7d
  8013b9:	68 94 21 80 00       	push   $0x802194
  8013be:	e8 a0 05 00 00       	call   801963 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8013c3:	83 ec 04             	sub    $0x4,%esp
  8013c6:	50                   	push   %eax
  8013c7:	68 00 50 80 00       	push   $0x805000
  8013cc:	ff 75 0c             	pushl  0xc(%ebp)
  8013cf:	e8 af f4 ff ff       	call   800883 <memmove>
	return r;
  8013d4:	83 c4 10             	add    $0x10,%esp
}
  8013d7:	89 d8                	mov    %ebx,%eax
  8013d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013dc:	5b                   	pop    %ebx
  8013dd:	5e                   	pop    %esi
  8013de:	5d                   	pop    %ebp
  8013df:	c3                   	ret    

008013e0 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
  8013e3:	53                   	push   %ebx
  8013e4:	83 ec 20             	sub    $0x20,%esp
  8013e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8013ea:	53                   	push   %ebx
  8013eb:	e8 c7 f2 ff ff       	call   8006b7 <strlen>
  8013f0:	83 c4 10             	add    $0x10,%esp
  8013f3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8013f8:	7f 67                	jg     801461 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8013fa:	83 ec 0c             	sub    $0xc,%esp
  8013fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801400:	50                   	push   %eax
  801401:	e8 78 f8 ff ff       	call   800c7e <fd_alloc>
  801406:	83 c4 10             	add    $0x10,%esp
		return r;
  801409:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80140b:	85 c0                	test   %eax,%eax
  80140d:	78 57                	js     801466 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80140f:	83 ec 08             	sub    $0x8,%esp
  801412:	53                   	push   %ebx
  801413:	68 00 50 80 00       	push   $0x805000
  801418:	e8 d3 f2 ff ff       	call   8006f0 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80141d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801420:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801425:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801428:	b8 01 00 00 00       	mov    $0x1,%eax
  80142d:	e8 d3 fd ff ff       	call   801205 <fsipc>
  801432:	89 c3                	mov    %eax,%ebx
  801434:	83 c4 10             	add    $0x10,%esp
  801437:	85 c0                	test   %eax,%eax
  801439:	79 14                	jns    80144f <open+0x6f>
		fd_close(fd, 0);
  80143b:	83 ec 08             	sub    $0x8,%esp
  80143e:	6a 00                	push   $0x0
  801440:	ff 75 f4             	pushl  -0xc(%ebp)
  801443:	e8 2e f9 ff ff       	call   800d76 <fd_close>
		return r;
  801448:	83 c4 10             	add    $0x10,%esp
  80144b:	89 da                	mov    %ebx,%edx
  80144d:	eb 17                	jmp    801466 <open+0x86>
	}

	return fd2num(fd);
  80144f:	83 ec 0c             	sub    $0xc,%esp
  801452:	ff 75 f4             	pushl  -0xc(%ebp)
  801455:	e8 fc f7 ff ff       	call   800c56 <fd2num>
  80145a:	89 c2                	mov    %eax,%edx
  80145c:	83 c4 10             	add    $0x10,%esp
  80145f:	eb 05                	jmp    801466 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801461:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801466:	89 d0                	mov    %edx,%eax
  801468:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    

0080146d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
  801470:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801473:	ba 00 00 00 00       	mov    $0x0,%edx
  801478:	b8 08 00 00 00       	mov    $0x8,%eax
  80147d:	e8 83 fd ff ff       	call   801205 <fsipc>
}
  801482:	c9                   	leave  
  801483:	c3                   	ret    

00801484 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	56                   	push   %esi
  801488:	53                   	push   %ebx
  801489:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80148c:	83 ec 0c             	sub    $0xc,%esp
  80148f:	ff 75 08             	pushl  0x8(%ebp)
  801492:	e8 cf f7 ff ff       	call   800c66 <fd2data>
  801497:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801499:	83 c4 08             	add    $0x8,%esp
  80149c:	68 ab 21 80 00       	push   $0x8021ab
  8014a1:	53                   	push   %ebx
  8014a2:	e8 49 f2 ff ff       	call   8006f0 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8014a7:	8b 46 04             	mov    0x4(%esi),%eax
  8014aa:	2b 06                	sub    (%esi),%eax
  8014ac:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8014b2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014b9:	00 00 00 
	stat->st_dev = &devpipe;
  8014bc:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8014c3:	30 80 00 
	return 0;
}
  8014c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014ce:	5b                   	pop    %ebx
  8014cf:	5e                   	pop    %esi
  8014d0:	5d                   	pop    %ebp
  8014d1:	c3                   	ret    

008014d2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
  8014d5:	53                   	push   %ebx
  8014d6:	83 ec 0c             	sub    $0xc,%esp
  8014d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8014dc:	53                   	push   %ebx
  8014dd:	6a 00                	push   $0x0
  8014df:	e8 9f f6 ff ff       	call   800b83 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8014e4:	89 1c 24             	mov    %ebx,(%esp)
  8014e7:	e8 7a f7 ff ff       	call   800c66 <fd2data>
  8014ec:	83 c4 08             	add    $0x8,%esp
  8014ef:	50                   	push   %eax
  8014f0:	6a 00                	push   $0x0
  8014f2:	e8 8c f6 ff ff       	call   800b83 <sys_page_unmap>
}
  8014f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    

008014fc <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	57                   	push   %edi
  801500:	56                   	push   %esi
  801501:	53                   	push   %ebx
  801502:	83 ec 1c             	sub    $0x1c,%esp
  801505:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801508:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80150a:	a1 04 40 80 00       	mov    0x804004,%eax
  80150f:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801512:	83 ec 0c             	sub    $0xc,%esp
  801515:	ff 75 e0             	pushl  -0x20(%ebp)
  801518:	e8 84 05 00 00       	call   801aa1 <pageref>
  80151d:	89 c3                	mov    %eax,%ebx
  80151f:	89 3c 24             	mov    %edi,(%esp)
  801522:	e8 7a 05 00 00       	call   801aa1 <pageref>
  801527:	83 c4 10             	add    $0x10,%esp
  80152a:	39 c3                	cmp    %eax,%ebx
  80152c:	0f 94 c1             	sete   %cl
  80152f:	0f b6 c9             	movzbl %cl,%ecx
  801532:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801535:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80153b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80153e:	39 ce                	cmp    %ecx,%esi
  801540:	74 1b                	je     80155d <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801542:	39 c3                	cmp    %eax,%ebx
  801544:	75 c4                	jne    80150a <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801546:	8b 42 58             	mov    0x58(%edx),%eax
  801549:	ff 75 e4             	pushl  -0x1c(%ebp)
  80154c:	50                   	push   %eax
  80154d:	56                   	push   %esi
  80154e:	68 b2 21 80 00       	push   $0x8021b2
  801553:	e8 26 ec ff ff       	call   80017e <cprintf>
  801558:	83 c4 10             	add    $0x10,%esp
  80155b:	eb ad                	jmp    80150a <_pipeisclosed+0xe>
	}
}
  80155d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801560:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801563:	5b                   	pop    %ebx
  801564:	5e                   	pop    %esi
  801565:	5f                   	pop    %edi
  801566:	5d                   	pop    %ebp
  801567:	c3                   	ret    

00801568 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
  80156b:	57                   	push   %edi
  80156c:	56                   	push   %esi
  80156d:	53                   	push   %ebx
  80156e:	83 ec 28             	sub    $0x28,%esp
  801571:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801574:	56                   	push   %esi
  801575:	e8 ec f6 ff ff       	call   800c66 <fd2data>
  80157a:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80157c:	83 c4 10             	add    $0x10,%esp
  80157f:	bf 00 00 00 00       	mov    $0x0,%edi
  801584:	eb 4b                	jmp    8015d1 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801586:	89 da                	mov    %ebx,%edx
  801588:	89 f0                	mov    %esi,%eax
  80158a:	e8 6d ff ff ff       	call   8014fc <_pipeisclosed>
  80158f:	85 c0                	test   %eax,%eax
  801591:	75 48                	jne    8015db <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801593:	e8 7a f5 ff ff       	call   800b12 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801598:	8b 43 04             	mov    0x4(%ebx),%eax
  80159b:	8b 0b                	mov    (%ebx),%ecx
  80159d:	8d 51 20             	lea    0x20(%ecx),%edx
  8015a0:	39 d0                	cmp    %edx,%eax
  8015a2:	73 e2                	jae    801586 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8015a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015a7:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8015ab:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8015ae:	89 c2                	mov    %eax,%edx
  8015b0:	c1 fa 1f             	sar    $0x1f,%edx
  8015b3:	89 d1                	mov    %edx,%ecx
  8015b5:	c1 e9 1b             	shr    $0x1b,%ecx
  8015b8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8015bb:	83 e2 1f             	and    $0x1f,%edx
  8015be:	29 ca                	sub    %ecx,%edx
  8015c0:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8015c4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8015c8:	83 c0 01             	add    $0x1,%eax
  8015cb:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8015ce:	83 c7 01             	add    $0x1,%edi
  8015d1:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8015d4:	75 c2                	jne    801598 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8015d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d9:	eb 05                	jmp    8015e0 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8015db:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8015e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015e3:	5b                   	pop    %ebx
  8015e4:	5e                   	pop    %esi
  8015e5:	5f                   	pop    %edi
  8015e6:	5d                   	pop    %ebp
  8015e7:	c3                   	ret    

008015e8 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
  8015eb:	57                   	push   %edi
  8015ec:	56                   	push   %esi
  8015ed:	53                   	push   %ebx
  8015ee:	83 ec 18             	sub    $0x18,%esp
  8015f1:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8015f4:	57                   	push   %edi
  8015f5:	e8 6c f6 ff ff       	call   800c66 <fd2data>
  8015fa:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8015fc:	83 c4 10             	add    $0x10,%esp
  8015ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  801604:	eb 3d                	jmp    801643 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801606:	85 db                	test   %ebx,%ebx
  801608:	74 04                	je     80160e <devpipe_read+0x26>
				return i;
  80160a:	89 d8                	mov    %ebx,%eax
  80160c:	eb 44                	jmp    801652 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80160e:	89 f2                	mov    %esi,%edx
  801610:	89 f8                	mov    %edi,%eax
  801612:	e8 e5 fe ff ff       	call   8014fc <_pipeisclosed>
  801617:	85 c0                	test   %eax,%eax
  801619:	75 32                	jne    80164d <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80161b:	e8 f2 f4 ff ff       	call   800b12 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801620:	8b 06                	mov    (%esi),%eax
  801622:	3b 46 04             	cmp    0x4(%esi),%eax
  801625:	74 df                	je     801606 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801627:	99                   	cltd   
  801628:	c1 ea 1b             	shr    $0x1b,%edx
  80162b:	01 d0                	add    %edx,%eax
  80162d:	83 e0 1f             	and    $0x1f,%eax
  801630:	29 d0                	sub    %edx,%eax
  801632:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801637:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80163a:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  80163d:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801640:	83 c3 01             	add    $0x1,%ebx
  801643:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801646:	75 d8                	jne    801620 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801648:	8b 45 10             	mov    0x10(%ebp),%eax
  80164b:	eb 05                	jmp    801652 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80164d:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801652:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801655:	5b                   	pop    %ebx
  801656:	5e                   	pop    %esi
  801657:	5f                   	pop    %edi
  801658:	5d                   	pop    %ebp
  801659:	c3                   	ret    

0080165a <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	56                   	push   %esi
  80165e:	53                   	push   %ebx
  80165f:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801662:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801665:	50                   	push   %eax
  801666:	e8 13 f6 ff ff       	call   800c7e <fd_alloc>
  80166b:	83 c4 10             	add    $0x10,%esp
  80166e:	89 c2                	mov    %eax,%edx
  801670:	85 c0                	test   %eax,%eax
  801672:	0f 88 2c 01 00 00    	js     8017a4 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801678:	83 ec 04             	sub    $0x4,%esp
  80167b:	68 07 04 00 00       	push   $0x407
  801680:	ff 75 f4             	pushl  -0xc(%ebp)
  801683:	6a 00                	push   $0x0
  801685:	e8 af f4 ff ff       	call   800b39 <sys_page_alloc>
  80168a:	83 c4 10             	add    $0x10,%esp
  80168d:	89 c2                	mov    %eax,%edx
  80168f:	85 c0                	test   %eax,%eax
  801691:	0f 88 0d 01 00 00    	js     8017a4 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801697:	83 ec 0c             	sub    $0xc,%esp
  80169a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80169d:	50                   	push   %eax
  80169e:	e8 db f5 ff ff       	call   800c7e <fd_alloc>
  8016a3:	89 c3                	mov    %eax,%ebx
  8016a5:	83 c4 10             	add    $0x10,%esp
  8016a8:	85 c0                	test   %eax,%eax
  8016aa:	0f 88 e2 00 00 00    	js     801792 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8016b0:	83 ec 04             	sub    $0x4,%esp
  8016b3:	68 07 04 00 00       	push   $0x407
  8016b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8016bb:	6a 00                	push   $0x0
  8016bd:	e8 77 f4 ff ff       	call   800b39 <sys_page_alloc>
  8016c2:	89 c3                	mov    %eax,%ebx
  8016c4:	83 c4 10             	add    $0x10,%esp
  8016c7:	85 c0                	test   %eax,%eax
  8016c9:	0f 88 c3 00 00 00    	js     801792 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8016cf:	83 ec 0c             	sub    $0xc,%esp
  8016d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8016d5:	e8 8c f5 ff ff       	call   800c66 <fd2data>
  8016da:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8016dc:	83 c4 0c             	add    $0xc,%esp
  8016df:	68 07 04 00 00       	push   $0x407
  8016e4:	50                   	push   %eax
  8016e5:	6a 00                	push   $0x0
  8016e7:	e8 4d f4 ff ff       	call   800b39 <sys_page_alloc>
  8016ec:	89 c3                	mov    %eax,%ebx
  8016ee:	83 c4 10             	add    $0x10,%esp
  8016f1:	85 c0                	test   %eax,%eax
  8016f3:	0f 88 89 00 00 00    	js     801782 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8016f9:	83 ec 0c             	sub    $0xc,%esp
  8016fc:	ff 75 f0             	pushl  -0x10(%ebp)
  8016ff:	e8 62 f5 ff ff       	call   800c66 <fd2data>
  801704:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80170b:	50                   	push   %eax
  80170c:	6a 00                	push   $0x0
  80170e:	56                   	push   %esi
  80170f:	6a 00                	push   $0x0
  801711:	e8 47 f4 ff ff       	call   800b5d <sys_page_map>
  801716:	89 c3                	mov    %eax,%ebx
  801718:	83 c4 20             	add    $0x20,%esp
  80171b:	85 c0                	test   %eax,%eax
  80171d:	78 55                	js     801774 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80171f:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801728:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80172a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801734:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80173a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173d:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80173f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801742:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801749:	83 ec 0c             	sub    $0xc,%esp
  80174c:	ff 75 f4             	pushl  -0xc(%ebp)
  80174f:	e8 02 f5 ff ff       	call   800c56 <fd2num>
  801754:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801757:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801759:	83 c4 04             	add    $0x4,%esp
  80175c:	ff 75 f0             	pushl  -0x10(%ebp)
  80175f:	e8 f2 f4 ff ff       	call   800c56 <fd2num>
  801764:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801767:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80176a:	83 c4 10             	add    $0x10,%esp
  80176d:	ba 00 00 00 00       	mov    $0x0,%edx
  801772:	eb 30                	jmp    8017a4 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801774:	83 ec 08             	sub    $0x8,%esp
  801777:	56                   	push   %esi
  801778:	6a 00                	push   $0x0
  80177a:	e8 04 f4 ff ff       	call   800b83 <sys_page_unmap>
  80177f:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801782:	83 ec 08             	sub    $0x8,%esp
  801785:	ff 75 f0             	pushl  -0x10(%ebp)
  801788:	6a 00                	push   $0x0
  80178a:	e8 f4 f3 ff ff       	call   800b83 <sys_page_unmap>
  80178f:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801792:	83 ec 08             	sub    $0x8,%esp
  801795:	ff 75 f4             	pushl  -0xc(%ebp)
  801798:	6a 00                	push   $0x0
  80179a:	e8 e4 f3 ff ff       	call   800b83 <sys_page_unmap>
  80179f:	83 c4 10             	add    $0x10,%esp
  8017a2:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  8017a4:	89 d0                	mov    %edx,%eax
  8017a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a9:	5b                   	pop    %ebx
  8017aa:	5e                   	pop    %esi
  8017ab:	5d                   	pop    %ebp
  8017ac:	c3                   	ret    

008017ad <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b6:	50                   	push   %eax
  8017b7:	ff 75 08             	pushl  0x8(%ebp)
  8017ba:	e8 0e f5 ff ff       	call   800ccd <fd_lookup>
  8017bf:	83 c4 10             	add    $0x10,%esp
  8017c2:	85 c0                	test   %eax,%eax
  8017c4:	78 18                	js     8017de <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8017c6:	83 ec 0c             	sub    $0xc,%esp
  8017c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8017cc:	e8 95 f4 ff ff       	call   800c66 <fd2data>
	return _pipeisclosed(fd, p);
  8017d1:	89 c2                	mov    %eax,%edx
  8017d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d6:	e8 21 fd ff ff       	call   8014fc <_pipeisclosed>
  8017db:	83 c4 10             	add    $0x10,%esp
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8017e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e8:	5d                   	pop    %ebp
  8017e9:	c3                   	ret    

008017ea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8017f0:	68 ca 21 80 00       	push   $0x8021ca
  8017f5:	ff 75 0c             	pushl  0xc(%ebp)
  8017f8:	e8 f3 ee ff ff       	call   8006f0 <strcpy>
	return 0;
}
  8017fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	57                   	push   %edi
  801808:	56                   	push   %esi
  801809:	53                   	push   %ebx
  80180a:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801810:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801815:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80181b:	eb 2d                	jmp    80184a <devcons_write+0x46>
		m = n - tot;
  80181d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801820:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801822:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801825:	ba 7f 00 00 00       	mov    $0x7f,%edx
  80182a:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80182d:	83 ec 04             	sub    $0x4,%esp
  801830:	53                   	push   %ebx
  801831:	03 45 0c             	add    0xc(%ebp),%eax
  801834:	50                   	push   %eax
  801835:	57                   	push   %edi
  801836:	e8 48 f0 ff ff       	call   800883 <memmove>
		sys_cputs(buf, m);
  80183b:	83 c4 08             	add    $0x8,%esp
  80183e:	53                   	push   %ebx
  80183f:	57                   	push   %edi
  801840:	e8 3d f2 ff ff       	call   800a82 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801845:	01 de                	add    %ebx,%esi
  801847:	83 c4 10             	add    $0x10,%esp
  80184a:	89 f0                	mov    %esi,%eax
  80184c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80184f:	72 cc                	jb     80181d <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801851:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801854:	5b                   	pop    %ebx
  801855:	5e                   	pop    %esi
  801856:	5f                   	pop    %edi
  801857:	5d                   	pop    %ebp
  801858:	c3                   	ret    

00801859 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	83 ec 08             	sub    $0x8,%esp
  80185f:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801864:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801868:	74 2a                	je     801894 <devcons_read+0x3b>
  80186a:	eb 05                	jmp    801871 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80186c:	e8 a1 f2 ff ff       	call   800b12 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801871:	e8 32 f2 ff ff       	call   800aa8 <sys_cgetc>
  801876:	85 c0                	test   %eax,%eax
  801878:	74 f2                	je     80186c <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  80187a:	85 c0                	test   %eax,%eax
  80187c:	78 16                	js     801894 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80187e:	83 f8 04             	cmp    $0x4,%eax
  801881:	74 0c                	je     80188f <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801883:	8b 55 0c             	mov    0xc(%ebp),%edx
  801886:	88 02                	mov    %al,(%edx)
	return 1;
  801888:	b8 01 00 00 00       	mov    $0x1,%eax
  80188d:	eb 05                	jmp    801894 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80188f:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80189c:	8b 45 08             	mov    0x8(%ebp),%eax
  80189f:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8018a2:	6a 01                	push   $0x1
  8018a4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8018a7:	50                   	push   %eax
  8018a8:	e8 d5 f1 ff ff       	call   800a82 <sys_cputs>
}
  8018ad:	83 c4 10             	add    $0x10,%esp
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <getchar>:

int
getchar(void)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8018b8:	6a 01                	push   $0x1
  8018ba:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8018bd:	50                   	push   %eax
  8018be:	6a 00                	push   $0x0
  8018c0:	e8 6d f6 ff ff       	call   800f32 <read>
	if (r < 0)
  8018c5:	83 c4 10             	add    $0x10,%esp
  8018c8:	85 c0                	test   %eax,%eax
  8018ca:	78 0f                	js     8018db <getchar+0x29>
		return r;
	if (r < 1)
  8018cc:	85 c0                	test   %eax,%eax
  8018ce:	7e 06                	jle    8018d6 <getchar+0x24>
		return -E_EOF;
	return c;
  8018d0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8018d4:	eb 05                	jmp    8018db <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8018d6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e6:	50                   	push   %eax
  8018e7:	ff 75 08             	pushl  0x8(%ebp)
  8018ea:	e8 de f3 ff ff       	call   800ccd <fd_lookup>
  8018ef:	83 c4 10             	add    $0x10,%esp
  8018f2:	85 c0                	test   %eax,%eax
  8018f4:	78 11                	js     801907 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8018f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8018ff:	39 10                	cmp    %edx,(%eax)
  801901:	0f 94 c0             	sete   %al
  801904:	0f b6 c0             	movzbl %al,%eax
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <opencons>:

int
opencons(void)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
  80190c:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80190f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801912:	50                   	push   %eax
  801913:	e8 66 f3 ff ff       	call   800c7e <fd_alloc>
  801918:	83 c4 10             	add    $0x10,%esp
		return r;
  80191b:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80191d:	85 c0                	test   %eax,%eax
  80191f:	78 3e                	js     80195f <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801921:	83 ec 04             	sub    $0x4,%esp
  801924:	68 07 04 00 00       	push   $0x407
  801929:	ff 75 f4             	pushl  -0xc(%ebp)
  80192c:	6a 00                	push   $0x0
  80192e:	e8 06 f2 ff ff       	call   800b39 <sys_page_alloc>
  801933:	83 c4 10             	add    $0x10,%esp
		return r;
  801936:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801938:	85 c0                	test   %eax,%eax
  80193a:	78 23                	js     80195f <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80193c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801945:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801951:	83 ec 0c             	sub    $0xc,%esp
  801954:	50                   	push   %eax
  801955:	e8 fc f2 ff ff       	call   800c56 <fd2num>
  80195a:	89 c2                	mov    %eax,%edx
  80195c:	83 c4 10             	add    $0x10,%esp
}
  80195f:	89 d0                	mov    %edx,%eax
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
  801966:	56                   	push   %esi
  801967:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801968:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80196b:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801971:	e8 78 f1 ff ff       	call   800aee <sys_getenvid>
  801976:	83 ec 0c             	sub    $0xc,%esp
  801979:	ff 75 0c             	pushl  0xc(%ebp)
  80197c:	ff 75 08             	pushl  0x8(%ebp)
  80197f:	56                   	push   %esi
  801980:	50                   	push   %eax
  801981:	68 d8 21 80 00       	push   $0x8021d8
  801986:	e8 f3 e7 ff ff       	call   80017e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80198b:	83 c4 18             	add    $0x18,%esp
  80198e:	53                   	push   %ebx
  80198f:	ff 75 10             	pushl  0x10(%ebp)
  801992:	e8 96 e7 ff ff       	call   80012d <vcprintf>
	cprintf("\n");
  801997:	c7 04 24 c3 21 80 00 	movl   $0x8021c3,(%esp)
  80199e:	e8 db e7 ff ff       	call   80017e <cprintf>
  8019a3:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8019a6:	cc                   	int3   
  8019a7:	eb fd                	jmp    8019a6 <_panic+0x43>

008019a9 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	56                   	push   %esi
  8019ad:	53                   	push   %ebx
  8019ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8019b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  8019b7:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  8019b9:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8019be:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  8019c1:	83 ec 0c             	sub    $0xc,%esp
  8019c4:	50                   	push   %eax
  8019c5:	e8 6a f2 ff ff       	call   800c34 <sys_ipc_recv>
	if (from_env_store)
  8019ca:	83 c4 10             	add    $0x10,%esp
  8019cd:	85 f6                	test   %esi,%esi
  8019cf:	74 0b                	je     8019dc <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  8019d1:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019d7:	8b 52 74             	mov    0x74(%edx),%edx
  8019da:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8019dc:	85 db                	test   %ebx,%ebx
  8019de:	74 0b                	je     8019eb <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  8019e0:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019e6:	8b 52 78             	mov    0x78(%edx),%edx
  8019e9:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  8019eb:	85 c0                	test   %eax,%eax
  8019ed:	79 16                	jns    801a05 <ipc_recv+0x5c>
		if (from_env_store)
  8019ef:	85 f6                	test   %esi,%esi
  8019f1:	74 06                	je     8019f9 <ipc_recv+0x50>
			*from_env_store = 0;
  8019f3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  8019f9:	85 db                	test   %ebx,%ebx
  8019fb:	74 10                	je     801a0d <ipc_recv+0x64>
			*perm_store = 0;
  8019fd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801a03:	eb 08                	jmp    801a0d <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  801a05:	a1 04 40 80 00       	mov    0x804004,%eax
  801a0a:	8b 40 70             	mov    0x70(%eax),%eax
}
  801a0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a10:	5b                   	pop    %ebx
  801a11:	5e                   	pop    %esi
  801a12:	5d                   	pop    %ebp
  801a13:	c3                   	ret    

00801a14 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	57                   	push   %edi
  801a18:	56                   	push   %esi
  801a19:	53                   	push   %ebx
  801a1a:	83 ec 0c             	sub    $0xc,%esp
  801a1d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a20:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a23:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  801a26:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  801a28:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801a2d:	0f 44 d8             	cmove  %eax,%ebx
  801a30:	eb 1c                	jmp    801a4e <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  801a32:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801a35:	74 12                	je     801a49 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801a37:	50                   	push   %eax
  801a38:	68 fc 21 80 00       	push   $0x8021fc
  801a3d:	6a 42                	push   $0x42
  801a3f:	68 12 22 80 00       	push   $0x802212
  801a44:	e8 1a ff ff ff       	call   801963 <_panic>
		sys_yield();
  801a49:	e8 c4 f0 ff ff       	call   800b12 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801a4e:	ff 75 14             	pushl  0x14(%ebp)
  801a51:	53                   	push   %ebx
  801a52:	56                   	push   %esi
  801a53:	57                   	push   %edi
  801a54:	e8 b6 f1 ff ff       	call   800c0f <sys_ipc_try_send>
  801a59:	83 c4 10             	add    $0x10,%esp
  801a5c:	85 c0                	test   %eax,%eax
  801a5e:	75 d2                	jne    801a32 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801a60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a63:	5b                   	pop    %ebx
  801a64:	5e                   	pop    %esi
  801a65:	5f                   	pop    %edi
  801a66:	5d                   	pop    %ebp
  801a67:	c3                   	ret    

00801a68 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
  801a6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801a6e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801a73:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801a76:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801a7c:	8b 52 50             	mov    0x50(%edx),%edx
  801a7f:	39 ca                	cmp    %ecx,%edx
  801a81:	75 0d                	jne    801a90 <ipc_find_env+0x28>
			return envs[i].env_id;
  801a83:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a86:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a8b:	8b 40 48             	mov    0x48(%eax),%eax
  801a8e:	eb 0f                	jmp    801a9f <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801a90:	83 c0 01             	add    $0x1,%eax
  801a93:	3d 00 04 00 00       	cmp    $0x400,%eax
  801a98:	75 d9                	jne    801a73 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801a9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a9f:	5d                   	pop    %ebp
  801aa0:	c3                   	ret    

00801aa1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
  801aa4:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801aa7:	89 d0                	mov    %edx,%eax
  801aa9:	c1 e8 16             	shr    $0x16,%eax
  801aac:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ab3:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ab8:	f6 c1 01             	test   $0x1,%cl
  801abb:	74 1d                	je     801ada <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801abd:	c1 ea 0c             	shr    $0xc,%edx
  801ac0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801ac7:	f6 c2 01             	test   $0x1,%dl
  801aca:	74 0e                	je     801ada <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801acc:	c1 ea 0c             	shr    $0xc,%edx
  801acf:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801ad6:	ef 
  801ad7:	0f b7 c0             	movzwl %ax,%eax
}
  801ada:	5d                   	pop    %ebp
  801adb:	c3                   	ret    
  801adc:	66 90                	xchg   %ax,%ax
  801ade:	66 90                	xchg   %ax,%ax

00801ae0 <__udivdi3>:
  801ae0:	55                   	push   %ebp
  801ae1:	57                   	push   %edi
  801ae2:	56                   	push   %esi
  801ae3:	53                   	push   %ebx
  801ae4:	83 ec 1c             	sub    $0x1c,%esp
  801ae7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801aeb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801aef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801af3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801af7:	85 f6                	test   %esi,%esi
  801af9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801afd:	89 ca                	mov    %ecx,%edx
  801aff:	89 f8                	mov    %edi,%eax
  801b01:	75 3d                	jne    801b40 <__udivdi3+0x60>
  801b03:	39 cf                	cmp    %ecx,%edi
  801b05:	0f 87 c5 00 00 00    	ja     801bd0 <__udivdi3+0xf0>
  801b0b:	85 ff                	test   %edi,%edi
  801b0d:	89 fd                	mov    %edi,%ebp
  801b0f:	75 0b                	jne    801b1c <__udivdi3+0x3c>
  801b11:	b8 01 00 00 00       	mov    $0x1,%eax
  801b16:	31 d2                	xor    %edx,%edx
  801b18:	f7 f7                	div    %edi
  801b1a:	89 c5                	mov    %eax,%ebp
  801b1c:	89 c8                	mov    %ecx,%eax
  801b1e:	31 d2                	xor    %edx,%edx
  801b20:	f7 f5                	div    %ebp
  801b22:	89 c1                	mov    %eax,%ecx
  801b24:	89 d8                	mov    %ebx,%eax
  801b26:	89 cf                	mov    %ecx,%edi
  801b28:	f7 f5                	div    %ebp
  801b2a:	89 c3                	mov    %eax,%ebx
  801b2c:	89 d8                	mov    %ebx,%eax
  801b2e:	89 fa                	mov    %edi,%edx
  801b30:	83 c4 1c             	add    $0x1c,%esp
  801b33:	5b                   	pop    %ebx
  801b34:	5e                   	pop    %esi
  801b35:	5f                   	pop    %edi
  801b36:	5d                   	pop    %ebp
  801b37:	c3                   	ret    
  801b38:	90                   	nop
  801b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801b40:	39 ce                	cmp    %ecx,%esi
  801b42:	77 74                	ja     801bb8 <__udivdi3+0xd8>
  801b44:	0f bd fe             	bsr    %esi,%edi
  801b47:	83 f7 1f             	xor    $0x1f,%edi
  801b4a:	0f 84 98 00 00 00    	je     801be8 <__udivdi3+0x108>
  801b50:	bb 20 00 00 00       	mov    $0x20,%ebx
  801b55:	89 f9                	mov    %edi,%ecx
  801b57:	89 c5                	mov    %eax,%ebp
  801b59:	29 fb                	sub    %edi,%ebx
  801b5b:	d3 e6                	shl    %cl,%esi
  801b5d:	89 d9                	mov    %ebx,%ecx
  801b5f:	d3 ed                	shr    %cl,%ebp
  801b61:	89 f9                	mov    %edi,%ecx
  801b63:	d3 e0                	shl    %cl,%eax
  801b65:	09 ee                	or     %ebp,%esi
  801b67:	89 d9                	mov    %ebx,%ecx
  801b69:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b6d:	89 d5                	mov    %edx,%ebp
  801b6f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b73:	d3 ed                	shr    %cl,%ebp
  801b75:	89 f9                	mov    %edi,%ecx
  801b77:	d3 e2                	shl    %cl,%edx
  801b79:	89 d9                	mov    %ebx,%ecx
  801b7b:	d3 e8                	shr    %cl,%eax
  801b7d:	09 c2                	or     %eax,%edx
  801b7f:	89 d0                	mov    %edx,%eax
  801b81:	89 ea                	mov    %ebp,%edx
  801b83:	f7 f6                	div    %esi
  801b85:	89 d5                	mov    %edx,%ebp
  801b87:	89 c3                	mov    %eax,%ebx
  801b89:	f7 64 24 0c          	mull   0xc(%esp)
  801b8d:	39 d5                	cmp    %edx,%ebp
  801b8f:	72 10                	jb     801ba1 <__udivdi3+0xc1>
  801b91:	8b 74 24 08          	mov    0x8(%esp),%esi
  801b95:	89 f9                	mov    %edi,%ecx
  801b97:	d3 e6                	shl    %cl,%esi
  801b99:	39 c6                	cmp    %eax,%esi
  801b9b:	73 07                	jae    801ba4 <__udivdi3+0xc4>
  801b9d:	39 d5                	cmp    %edx,%ebp
  801b9f:	75 03                	jne    801ba4 <__udivdi3+0xc4>
  801ba1:	83 eb 01             	sub    $0x1,%ebx
  801ba4:	31 ff                	xor    %edi,%edi
  801ba6:	89 d8                	mov    %ebx,%eax
  801ba8:	89 fa                	mov    %edi,%edx
  801baa:	83 c4 1c             	add    $0x1c,%esp
  801bad:	5b                   	pop    %ebx
  801bae:	5e                   	pop    %esi
  801baf:	5f                   	pop    %edi
  801bb0:	5d                   	pop    %ebp
  801bb1:	c3                   	ret    
  801bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801bb8:	31 ff                	xor    %edi,%edi
  801bba:	31 db                	xor    %ebx,%ebx
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
  801bd0:	89 d8                	mov    %ebx,%eax
  801bd2:	f7 f7                	div    %edi
  801bd4:	31 ff                	xor    %edi,%edi
  801bd6:	89 c3                	mov    %eax,%ebx
  801bd8:	89 d8                	mov    %ebx,%eax
  801bda:	89 fa                	mov    %edi,%edx
  801bdc:	83 c4 1c             	add    $0x1c,%esp
  801bdf:	5b                   	pop    %ebx
  801be0:	5e                   	pop    %esi
  801be1:	5f                   	pop    %edi
  801be2:	5d                   	pop    %ebp
  801be3:	c3                   	ret    
  801be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801be8:	39 ce                	cmp    %ecx,%esi
  801bea:	72 0c                	jb     801bf8 <__udivdi3+0x118>
  801bec:	31 db                	xor    %ebx,%ebx
  801bee:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bf2:	0f 87 34 ff ff ff    	ja     801b2c <__udivdi3+0x4c>
  801bf8:	bb 01 00 00 00       	mov    $0x1,%ebx
  801bfd:	e9 2a ff ff ff       	jmp    801b2c <__udivdi3+0x4c>
  801c02:	66 90                	xchg   %ax,%ax
  801c04:	66 90                	xchg   %ax,%ax
  801c06:	66 90                	xchg   %ax,%ax
  801c08:	66 90                	xchg   %ax,%ax
  801c0a:	66 90                	xchg   %ax,%ax
  801c0c:	66 90                	xchg   %ax,%ax
  801c0e:	66 90                	xchg   %ax,%ax

00801c10 <__umoddi3>:
  801c10:	55                   	push   %ebp
  801c11:	57                   	push   %edi
  801c12:	56                   	push   %esi
  801c13:	53                   	push   %ebx
  801c14:	83 ec 1c             	sub    $0x1c,%esp
  801c17:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801c1b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c27:	85 d2                	test   %edx,%edx
  801c29:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c31:	89 f3                	mov    %esi,%ebx
  801c33:	89 3c 24             	mov    %edi,(%esp)
  801c36:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c3a:	75 1c                	jne    801c58 <__umoddi3+0x48>
  801c3c:	39 f7                	cmp    %esi,%edi
  801c3e:	76 50                	jbe    801c90 <__umoddi3+0x80>
  801c40:	89 c8                	mov    %ecx,%eax
  801c42:	89 f2                	mov    %esi,%edx
  801c44:	f7 f7                	div    %edi
  801c46:	89 d0                	mov    %edx,%eax
  801c48:	31 d2                	xor    %edx,%edx
  801c4a:	83 c4 1c             	add    $0x1c,%esp
  801c4d:	5b                   	pop    %ebx
  801c4e:	5e                   	pop    %esi
  801c4f:	5f                   	pop    %edi
  801c50:	5d                   	pop    %ebp
  801c51:	c3                   	ret    
  801c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c58:	39 f2                	cmp    %esi,%edx
  801c5a:	89 d0                	mov    %edx,%eax
  801c5c:	77 52                	ja     801cb0 <__umoddi3+0xa0>
  801c5e:	0f bd ea             	bsr    %edx,%ebp
  801c61:	83 f5 1f             	xor    $0x1f,%ebp
  801c64:	75 5a                	jne    801cc0 <__umoddi3+0xb0>
  801c66:	3b 54 24 04          	cmp    0x4(%esp),%edx
  801c6a:	0f 82 e0 00 00 00    	jb     801d50 <__umoddi3+0x140>
  801c70:	39 0c 24             	cmp    %ecx,(%esp)
  801c73:	0f 86 d7 00 00 00    	jbe    801d50 <__umoddi3+0x140>
  801c79:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c7d:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c81:	83 c4 1c             	add    $0x1c,%esp
  801c84:	5b                   	pop    %ebx
  801c85:	5e                   	pop    %esi
  801c86:	5f                   	pop    %edi
  801c87:	5d                   	pop    %ebp
  801c88:	c3                   	ret    
  801c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c90:	85 ff                	test   %edi,%edi
  801c92:	89 fd                	mov    %edi,%ebp
  801c94:	75 0b                	jne    801ca1 <__umoddi3+0x91>
  801c96:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9b:	31 d2                	xor    %edx,%edx
  801c9d:	f7 f7                	div    %edi
  801c9f:	89 c5                	mov    %eax,%ebp
  801ca1:	89 f0                	mov    %esi,%eax
  801ca3:	31 d2                	xor    %edx,%edx
  801ca5:	f7 f5                	div    %ebp
  801ca7:	89 c8                	mov    %ecx,%eax
  801ca9:	f7 f5                	div    %ebp
  801cab:	89 d0                	mov    %edx,%eax
  801cad:	eb 99                	jmp    801c48 <__umoddi3+0x38>
  801caf:	90                   	nop
  801cb0:	89 c8                	mov    %ecx,%eax
  801cb2:	89 f2                	mov    %esi,%edx
  801cb4:	83 c4 1c             	add    $0x1c,%esp
  801cb7:	5b                   	pop    %ebx
  801cb8:	5e                   	pop    %esi
  801cb9:	5f                   	pop    %edi
  801cba:	5d                   	pop    %ebp
  801cbb:	c3                   	ret    
  801cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801cc0:	8b 34 24             	mov    (%esp),%esi
  801cc3:	bf 20 00 00 00       	mov    $0x20,%edi
  801cc8:	89 e9                	mov    %ebp,%ecx
  801cca:	29 ef                	sub    %ebp,%edi
  801ccc:	d3 e0                	shl    %cl,%eax
  801cce:	89 f9                	mov    %edi,%ecx
  801cd0:	89 f2                	mov    %esi,%edx
  801cd2:	d3 ea                	shr    %cl,%edx
  801cd4:	89 e9                	mov    %ebp,%ecx
  801cd6:	09 c2                	or     %eax,%edx
  801cd8:	89 d8                	mov    %ebx,%eax
  801cda:	89 14 24             	mov    %edx,(%esp)
  801cdd:	89 f2                	mov    %esi,%edx
  801cdf:	d3 e2                	shl    %cl,%edx
  801ce1:	89 f9                	mov    %edi,%ecx
  801ce3:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ce7:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801ceb:	d3 e8                	shr    %cl,%eax
  801ced:	89 e9                	mov    %ebp,%ecx
  801cef:	89 c6                	mov    %eax,%esi
  801cf1:	d3 e3                	shl    %cl,%ebx
  801cf3:	89 f9                	mov    %edi,%ecx
  801cf5:	89 d0                	mov    %edx,%eax
  801cf7:	d3 e8                	shr    %cl,%eax
  801cf9:	89 e9                	mov    %ebp,%ecx
  801cfb:	09 d8                	or     %ebx,%eax
  801cfd:	89 d3                	mov    %edx,%ebx
  801cff:	89 f2                	mov    %esi,%edx
  801d01:	f7 34 24             	divl   (%esp)
  801d04:	89 d6                	mov    %edx,%esi
  801d06:	d3 e3                	shl    %cl,%ebx
  801d08:	f7 64 24 04          	mull   0x4(%esp)
  801d0c:	39 d6                	cmp    %edx,%esi
  801d0e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d12:	89 d1                	mov    %edx,%ecx
  801d14:	89 c3                	mov    %eax,%ebx
  801d16:	72 08                	jb     801d20 <__umoddi3+0x110>
  801d18:	75 11                	jne    801d2b <__umoddi3+0x11b>
  801d1a:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801d1e:	73 0b                	jae    801d2b <__umoddi3+0x11b>
  801d20:	2b 44 24 04          	sub    0x4(%esp),%eax
  801d24:	1b 14 24             	sbb    (%esp),%edx
  801d27:	89 d1                	mov    %edx,%ecx
  801d29:	89 c3                	mov    %eax,%ebx
  801d2b:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d2f:	29 da                	sub    %ebx,%edx
  801d31:	19 ce                	sbb    %ecx,%esi
  801d33:	89 f9                	mov    %edi,%ecx
  801d35:	89 f0                	mov    %esi,%eax
  801d37:	d3 e0                	shl    %cl,%eax
  801d39:	89 e9                	mov    %ebp,%ecx
  801d3b:	d3 ea                	shr    %cl,%edx
  801d3d:	89 e9                	mov    %ebp,%ecx
  801d3f:	d3 ee                	shr    %cl,%esi
  801d41:	09 d0                	or     %edx,%eax
  801d43:	89 f2                	mov    %esi,%edx
  801d45:	83 c4 1c             	add    $0x1c,%esp
  801d48:	5b                   	pop    %ebx
  801d49:	5e                   	pop    %esi
  801d4a:	5f                   	pop    %edi
  801d4b:	5d                   	pop    %ebp
  801d4c:	c3                   	ret    
  801d4d:	8d 76 00             	lea    0x0(%esi),%esi
  801d50:	29 f9                	sub    %edi,%ecx
  801d52:	19 d6                	sbb    %edx,%esi
  801d54:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d58:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d5c:	e9 18 ff ff ff       	jmp    801c79 <__umoddi3+0x69>
