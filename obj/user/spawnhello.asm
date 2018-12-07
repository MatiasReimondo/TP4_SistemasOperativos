
obj/user/spawnhello.debug:     formato del fichero elf32-i386


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
  80002c:	e8 4a 00 00 00       	call   80007b <libmain>
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
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800039:	a1 04 40 80 00       	mov    0x804004,%eax
  80003e:	8b 40 48             	mov    0x48(%eax),%eax
  800041:	50                   	push   %eax
  800042:	68 60 23 80 00       	push   $0x802360
  800047:	e8 6c 01 00 00       	call   8001b8 <cprintf>
	if ((r = spawnl("hello", "hello", 0)) < 0)
  80004c:	83 c4 0c             	add    $0xc,%esp
  80004f:	6a 00                	push   $0x0
  800051:	68 7e 23 80 00       	push   $0x80237e
  800056:	68 7e 23 80 00       	push   $0x80237e
  80005b:	e8 d1 19 00 00       	call   801a31 <spawnl>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	85 c0                	test   %eax,%eax
  800065:	79 12                	jns    800079 <umain+0x46>
		panic("spawn(hello) failed: %e", r);
  800067:	50                   	push   %eax
  800068:	68 84 23 80 00       	push   $0x802384
  80006d:	6a 09                	push   $0x9
  80006f:	68 9c 23 80 00       	push   $0x80239c
  800074:	e8 66 00 00 00       	call   8000df <_panic>
}
  800079:	c9                   	leave  
  80007a:	c3                   	ret    

0080007b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007b:	55                   	push   %ebp
  80007c:	89 e5                	mov    %esp,%ebp
  80007e:	56                   	push   %esi
  80007f:	53                   	push   %ebx
  800080:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800083:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800086:	e8 9d 0a 00 00       	call   800b28 <sys_getenvid>
	if (id >= 0)
  80008b:	85 c0                	test   %eax,%eax
  80008d:	78 12                	js     8000a1 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  80008f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800094:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800097:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80009c:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a1:	85 db                	test   %ebx,%ebx
  8000a3:	7e 07                	jle    8000ac <libmain+0x31>
		binaryname = argv[0];
  8000a5:	8b 06                	mov    (%esi),%eax
  8000a7:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ac:	83 ec 08             	sub    $0x8,%esp
  8000af:	56                   	push   %esi
  8000b0:	53                   	push   %ebx
  8000b1:	e8 7d ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000b6:	e8 0a 00 00 00       	call   8000c5 <exit>
}
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c1:	5b                   	pop    %ebx
  8000c2:	5e                   	pop    %esi
  8000c3:	5d                   	pop    %ebp
  8000c4:	c3                   	ret    

008000c5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c5:	55                   	push   %ebp
  8000c6:	89 e5                	mov    %esp,%ebp
  8000c8:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000cb:	e8 8b 0d 00 00       	call   800e5b <close_all>
	sys_env_destroy(0);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	6a 00                	push   $0x0
  8000d5:	e8 2c 0a 00 00       	call   800b06 <sys_env_destroy>
}
  8000da:	83 c4 10             	add    $0x10,%esp
  8000dd:	c9                   	leave  
  8000de:	c3                   	ret    

008000df <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8000df:	55                   	push   %ebp
  8000e0:	89 e5                	mov    %esp,%ebp
  8000e2:	56                   	push   %esi
  8000e3:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8000e4:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8000e7:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8000ed:	e8 36 0a 00 00       	call   800b28 <sys_getenvid>
  8000f2:	83 ec 0c             	sub    $0xc,%esp
  8000f5:	ff 75 0c             	pushl  0xc(%ebp)
  8000f8:	ff 75 08             	pushl  0x8(%ebp)
  8000fb:	56                   	push   %esi
  8000fc:	50                   	push   %eax
  8000fd:	68 b8 23 80 00       	push   $0x8023b8
  800102:	e8 b1 00 00 00       	call   8001b8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800107:	83 c4 18             	add    $0x18,%esp
  80010a:	53                   	push   %ebx
  80010b:	ff 75 10             	pushl  0x10(%ebp)
  80010e:	e8 54 00 00 00       	call   800167 <vcprintf>
	cprintf("\n");
  800113:	c7 04 24 ac 28 80 00 	movl   $0x8028ac,(%esp)
  80011a:	e8 99 00 00 00       	call   8001b8 <cprintf>
  80011f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800122:	cc                   	int3   
  800123:	eb fd                	jmp    800122 <_panic+0x43>

00800125 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800125:	55                   	push   %ebp
  800126:	89 e5                	mov    %esp,%ebp
  800128:	53                   	push   %ebx
  800129:	83 ec 04             	sub    $0x4,%esp
  80012c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80012f:	8b 13                	mov    (%ebx),%edx
  800131:	8d 42 01             	lea    0x1(%edx),%eax
  800134:	89 03                	mov    %eax,(%ebx)
  800136:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800139:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80013d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800142:	75 1a                	jne    80015e <putch+0x39>
		sys_cputs(b->buf, b->idx);
  800144:	83 ec 08             	sub    $0x8,%esp
  800147:	68 ff 00 00 00       	push   $0xff
  80014c:	8d 43 08             	lea    0x8(%ebx),%eax
  80014f:	50                   	push   %eax
  800150:	e8 67 09 00 00       	call   800abc <sys_cputs>
		b->idx = 0;
  800155:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80015b:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  80015e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800162:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800165:	c9                   	leave  
  800166:	c3                   	ret    

00800167 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800167:	55                   	push   %ebp
  800168:	89 e5                	mov    %esp,%ebp
  80016a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800170:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800177:	00 00 00 
	b.cnt = 0;
  80017a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800181:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800184:	ff 75 0c             	pushl  0xc(%ebp)
  800187:	ff 75 08             	pushl  0x8(%ebp)
  80018a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800190:	50                   	push   %eax
  800191:	68 25 01 80 00       	push   $0x800125
  800196:	e8 86 01 00 00       	call   800321 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80019b:	83 c4 08             	add    $0x8,%esp
  80019e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001a4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001aa:	50                   	push   %eax
  8001ab:	e8 0c 09 00 00       	call   800abc <sys_cputs>

	return b.cnt;
}
  8001b0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001b6:	c9                   	leave  
  8001b7:	c3                   	ret    

008001b8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001b8:	55                   	push   %ebp
  8001b9:	89 e5                	mov    %esp,%ebp
  8001bb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001be:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001c1:	50                   	push   %eax
  8001c2:	ff 75 08             	pushl  0x8(%ebp)
  8001c5:	e8 9d ff ff ff       	call   800167 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ca:	c9                   	leave  
  8001cb:	c3                   	ret    

008001cc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001cc:	55                   	push   %ebp
  8001cd:	89 e5                	mov    %esp,%ebp
  8001cf:	57                   	push   %edi
  8001d0:	56                   	push   %esi
  8001d1:	53                   	push   %ebx
  8001d2:	83 ec 1c             	sub    $0x1c,%esp
  8001d5:	89 c7                	mov    %eax,%edi
  8001d7:	89 d6                	mov    %edx,%esi
  8001d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001ed:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001f3:	39 d3                	cmp    %edx,%ebx
  8001f5:	72 05                	jb     8001fc <printnum+0x30>
  8001f7:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001fa:	77 45                	ja     800241 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001fc:	83 ec 0c             	sub    $0xc,%esp
  8001ff:	ff 75 18             	pushl  0x18(%ebp)
  800202:	8b 45 14             	mov    0x14(%ebp),%eax
  800205:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800208:	53                   	push   %ebx
  800209:	ff 75 10             	pushl  0x10(%ebp)
  80020c:	83 ec 08             	sub    $0x8,%esp
  80020f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800212:	ff 75 e0             	pushl  -0x20(%ebp)
  800215:	ff 75 dc             	pushl  -0x24(%ebp)
  800218:	ff 75 d8             	pushl  -0x28(%ebp)
  80021b:	e8 a0 1e 00 00       	call   8020c0 <__udivdi3>
  800220:	83 c4 18             	add    $0x18,%esp
  800223:	52                   	push   %edx
  800224:	50                   	push   %eax
  800225:	89 f2                	mov    %esi,%edx
  800227:	89 f8                	mov    %edi,%eax
  800229:	e8 9e ff ff ff       	call   8001cc <printnum>
  80022e:	83 c4 20             	add    $0x20,%esp
  800231:	eb 18                	jmp    80024b <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800233:	83 ec 08             	sub    $0x8,%esp
  800236:	56                   	push   %esi
  800237:	ff 75 18             	pushl  0x18(%ebp)
  80023a:	ff d7                	call   *%edi
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	eb 03                	jmp    800244 <printnum+0x78>
  800241:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800244:	83 eb 01             	sub    $0x1,%ebx
  800247:	85 db                	test   %ebx,%ebx
  800249:	7f e8                	jg     800233 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80024b:	83 ec 08             	sub    $0x8,%esp
  80024e:	56                   	push   %esi
  80024f:	83 ec 04             	sub    $0x4,%esp
  800252:	ff 75 e4             	pushl  -0x1c(%ebp)
  800255:	ff 75 e0             	pushl  -0x20(%ebp)
  800258:	ff 75 dc             	pushl  -0x24(%ebp)
  80025b:	ff 75 d8             	pushl  -0x28(%ebp)
  80025e:	e8 8d 1f 00 00       	call   8021f0 <__umoddi3>
  800263:	83 c4 14             	add    $0x14,%esp
  800266:	0f be 80 db 23 80 00 	movsbl 0x8023db(%eax),%eax
  80026d:	50                   	push   %eax
  80026e:	ff d7                	call   *%edi
}
  800270:	83 c4 10             	add    $0x10,%esp
  800273:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800276:	5b                   	pop    %ebx
  800277:	5e                   	pop    %esi
  800278:	5f                   	pop    %edi
  800279:	5d                   	pop    %ebp
  80027a:	c3                   	ret    

0080027b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80027e:	83 fa 01             	cmp    $0x1,%edx
  800281:	7e 0e                	jle    800291 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800283:	8b 10                	mov    (%eax),%edx
  800285:	8d 4a 08             	lea    0x8(%edx),%ecx
  800288:	89 08                	mov    %ecx,(%eax)
  80028a:	8b 02                	mov    (%edx),%eax
  80028c:	8b 52 04             	mov    0x4(%edx),%edx
  80028f:	eb 22                	jmp    8002b3 <getuint+0x38>
	else if (lflag)
  800291:	85 d2                	test   %edx,%edx
  800293:	74 10                	je     8002a5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800295:	8b 10                	mov    (%eax),%edx
  800297:	8d 4a 04             	lea    0x4(%edx),%ecx
  80029a:	89 08                	mov    %ecx,(%eax)
  80029c:	8b 02                	mov    (%edx),%eax
  80029e:	ba 00 00 00 00       	mov    $0x0,%edx
  8002a3:	eb 0e                	jmp    8002b3 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002a5:	8b 10                	mov    (%eax),%edx
  8002a7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002aa:	89 08                	mov    %ecx,(%eax)
  8002ac:	8b 02                	mov    (%edx),%eax
  8002ae:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002b3:	5d                   	pop    %ebp
  8002b4:	c3                   	ret    

008002b5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002b8:	83 fa 01             	cmp    $0x1,%edx
  8002bb:	7e 0e                	jle    8002cb <getint+0x16>
		return va_arg(*ap, long long);
  8002bd:	8b 10                	mov    (%eax),%edx
  8002bf:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002c2:	89 08                	mov    %ecx,(%eax)
  8002c4:	8b 02                	mov    (%edx),%eax
  8002c6:	8b 52 04             	mov    0x4(%edx),%edx
  8002c9:	eb 1a                	jmp    8002e5 <getint+0x30>
	else if (lflag)
  8002cb:	85 d2                	test   %edx,%edx
  8002cd:	74 0c                	je     8002db <getint+0x26>
		return va_arg(*ap, long);
  8002cf:	8b 10                	mov    (%eax),%edx
  8002d1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002d4:	89 08                	mov    %ecx,(%eax)
  8002d6:	8b 02                	mov    (%edx),%eax
  8002d8:	99                   	cltd   
  8002d9:	eb 0a                	jmp    8002e5 <getint+0x30>
	else
		return va_arg(*ap, int);
  8002db:	8b 10                	mov    (%eax),%edx
  8002dd:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002e0:	89 08                	mov    %ecx,(%eax)
  8002e2:	8b 02                	mov    (%edx),%eax
  8002e4:	99                   	cltd   
}
  8002e5:	5d                   	pop    %ebp
  8002e6:	c3                   	ret    

008002e7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
  8002ea:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ed:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002f1:	8b 10                	mov    (%eax),%edx
  8002f3:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f6:	73 0a                	jae    800302 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002f8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002fb:	89 08                	mov    %ecx,(%eax)
  8002fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800300:	88 02                	mov    %al,(%edx)
}
  800302:	5d                   	pop    %ebp
  800303:	c3                   	ret    

00800304 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800304:	55                   	push   %ebp
  800305:	89 e5                	mov    %esp,%ebp
  800307:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  80030a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80030d:	50                   	push   %eax
  80030e:	ff 75 10             	pushl  0x10(%ebp)
  800311:	ff 75 0c             	pushl  0xc(%ebp)
  800314:	ff 75 08             	pushl  0x8(%ebp)
  800317:	e8 05 00 00 00       	call   800321 <vprintfmt>
	va_end(ap);
}
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	c9                   	leave  
  800320:	c3                   	ret    

00800321 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800321:	55                   	push   %ebp
  800322:	89 e5                	mov    %esp,%ebp
  800324:	57                   	push   %edi
  800325:	56                   	push   %esi
  800326:	53                   	push   %ebx
  800327:	83 ec 2c             	sub    $0x2c,%esp
  80032a:	8b 75 08             	mov    0x8(%ebp),%esi
  80032d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800330:	8b 7d 10             	mov    0x10(%ebp),%edi
  800333:	eb 12                	jmp    800347 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800335:	85 c0                	test   %eax,%eax
  800337:	0f 84 44 03 00 00    	je     800681 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	53                   	push   %ebx
  800341:	50                   	push   %eax
  800342:	ff d6                	call   *%esi
  800344:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800347:	83 c7 01             	add    $0x1,%edi
  80034a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80034e:	83 f8 25             	cmp    $0x25,%eax
  800351:	75 e2                	jne    800335 <vprintfmt+0x14>
  800353:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800357:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80035e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800365:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80036c:	ba 00 00 00 00       	mov    $0x0,%edx
  800371:	eb 07                	jmp    80037a <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800373:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800376:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80037a:	8d 47 01             	lea    0x1(%edi),%eax
  80037d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800380:	0f b6 07             	movzbl (%edi),%eax
  800383:	0f b6 c8             	movzbl %al,%ecx
  800386:	83 e8 23             	sub    $0x23,%eax
  800389:	3c 55                	cmp    $0x55,%al
  80038b:	0f 87 d5 02 00 00    	ja     800666 <vprintfmt+0x345>
  800391:	0f b6 c0             	movzbl %al,%eax
  800394:	ff 24 85 20 25 80 00 	jmp    *0x802520(,%eax,4)
  80039b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80039e:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003a2:	eb d6                	jmp    80037a <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ac:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003af:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003b2:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8003b6:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8003b9:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8003bc:	83 fa 09             	cmp    $0x9,%edx
  8003bf:	77 39                	ja     8003fa <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003c1:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003c4:	eb e9                	jmp    8003af <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c9:	8d 48 04             	lea    0x4(%eax),%ecx
  8003cc:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8003cf:	8b 00                	mov    (%eax),%eax
  8003d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003d7:	eb 27                	jmp    800400 <vprintfmt+0xdf>
  8003d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003dc:	85 c0                	test   %eax,%eax
  8003de:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003e3:	0f 49 c8             	cmovns %eax,%ecx
  8003e6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003ec:	eb 8c                	jmp    80037a <vprintfmt+0x59>
  8003ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8003f1:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003f8:	eb 80                	jmp    80037a <vprintfmt+0x59>
  8003fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003fd:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  800400:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800404:	0f 89 70 ff ff ff    	jns    80037a <vprintfmt+0x59>
				width = precision, precision = -1;
  80040a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80040d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800410:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800417:	e9 5e ff ff ff       	jmp    80037a <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80041c:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80041f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800422:	e9 53 ff ff ff       	jmp    80037a <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800427:	8b 45 14             	mov    0x14(%ebp),%eax
  80042a:	8d 50 04             	lea    0x4(%eax),%edx
  80042d:	89 55 14             	mov    %edx,0x14(%ebp)
  800430:	83 ec 08             	sub    $0x8,%esp
  800433:	53                   	push   %ebx
  800434:	ff 30                	pushl  (%eax)
  800436:	ff d6                	call   *%esi
			break;
  800438:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80043b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  80043e:	e9 04 ff ff ff       	jmp    800347 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800443:	8b 45 14             	mov    0x14(%ebp),%eax
  800446:	8d 50 04             	lea    0x4(%eax),%edx
  800449:	89 55 14             	mov    %edx,0x14(%ebp)
  80044c:	8b 00                	mov    (%eax),%eax
  80044e:	99                   	cltd   
  80044f:	31 d0                	xor    %edx,%eax
  800451:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800453:	83 f8 0f             	cmp    $0xf,%eax
  800456:	7f 0b                	jg     800463 <vprintfmt+0x142>
  800458:	8b 14 85 80 26 80 00 	mov    0x802680(,%eax,4),%edx
  80045f:	85 d2                	test   %edx,%edx
  800461:	75 18                	jne    80047b <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  800463:	50                   	push   %eax
  800464:	68 f3 23 80 00       	push   $0x8023f3
  800469:	53                   	push   %ebx
  80046a:	56                   	push   %esi
  80046b:	e8 94 fe ff ff       	call   800304 <printfmt>
  800470:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800473:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800476:	e9 cc fe ff ff       	jmp    800347 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  80047b:	52                   	push   %edx
  80047c:	68 b1 27 80 00       	push   $0x8027b1
  800481:	53                   	push   %ebx
  800482:	56                   	push   %esi
  800483:	e8 7c fe ff ff       	call   800304 <printfmt>
  800488:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80048e:	e9 b4 fe ff ff       	jmp    800347 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800493:	8b 45 14             	mov    0x14(%ebp),%eax
  800496:	8d 50 04             	lea    0x4(%eax),%edx
  800499:	89 55 14             	mov    %edx,0x14(%ebp)
  80049c:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80049e:	85 ff                	test   %edi,%edi
  8004a0:	b8 ec 23 80 00       	mov    $0x8023ec,%eax
  8004a5:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ac:	0f 8e 94 00 00 00    	jle    800546 <vprintfmt+0x225>
  8004b2:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004b6:	0f 84 98 00 00 00    	je     800554 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004bc:	83 ec 08             	sub    $0x8,%esp
  8004bf:	ff 75 d0             	pushl  -0x30(%ebp)
  8004c2:	57                   	push   %edi
  8004c3:	e8 41 02 00 00       	call   800709 <strnlen>
  8004c8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004cb:	29 c1                	sub    %eax,%ecx
  8004cd:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8004d0:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004d3:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004da:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004dd:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004df:	eb 0f                	jmp    8004f0 <vprintfmt+0x1cf>
					putch(padc, putdat);
  8004e1:	83 ec 08             	sub    $0x8,%esp
  8004e4:	53                   	push   %ebx
  8004e5:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e8:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ea:	83 ef 01             	sub    $0x1,%edi
  8004ed:	83 c4 10             	add    $0x10,%esp
  8004f0:	85 ff                	test   %edi,%edi
  8004f2:	7f ed                	jg     8004e1 <vprintfmt+0x1c0>
  8004f4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004f7:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8004fa:	85 c9                	test   %ecx,%ecx
  8004fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800501:	0f 49 c1             	cmovns %ecx,%eax
  800504:	29 c1                	sub    %eax,%ecx
  800506:	89 75 08             	mov    %esi,0x8(%ebp)
  800509:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80050c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80050f:	89 cb                	mov    %ecx,%ebx
  800511:	eb 4d                	jmp    800560 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800513:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800517:	74 1b                	je     800534 <vprintfmt+0x213>
  800519:	0f be c0             	movsbl %al,%eax
  80051c:	83 e8 20             	sub    $0x20,%eax
  80051f:	83 f8 5e             	cmp    $0x5e,%eax
  800522:	76 10                	jbe    800534 <vprintfmt+0x213>
					putch('?', putdat);
  800524:	83 ec 08             	sub    $0x8,%esp
  800527:	ff 75 0c             	pushl  0xc(%ebp)
  80052a:	6a 3f                	push   $0x3f
  80052c:	ff 55 08             	call   *0x8(%ebp)
  80052f:	83 c4 10             	add    $0x10,%esp
  800532:	eb 0d                	jmp    800541 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  800534:	83 ec 08             	sub    $0x8,%esp
  800537:	ff 75 0c             	pushl  0xc(%ebp)
  80053a:	52                   	push   %edx
  80053b:	ff 55 08             	call   *0x8(%ebp)
  80053e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800541:	83 eb 01             	sub    $0x1,%ebx
  800544:	eb 1a                	jmp    800560 <vprintfmt+0x23f>
  800546:	89 75 08             	mov    %esi,0x8(%ebp)
  800549:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80054c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80054f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800552:	eb 0c                	jmp    800560 <vprintfmt+0x23f>
  800554:	89 75 08             	mov    %esi,0x8(%ebp)
  800557:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80055a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80055d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800560:	83 c7 01             	add    $0x1,%edi
  800563:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800567:	0f be d0             	movsbl %al,%edx
  80056a:	85 d2                	test   %edx,%edx
  80056c:	74 23                	je     800591 <vprintfmt+0x270>
  80056e:	85 f6                	test   %esi,%esi
  800570:	78 a1                	js     800513 <vprintfmt+0x1f2>
  800572:	83 ee 01             	sub    $0x1,%esi
  800575:	79 9c                	jns    800513 <vprintfmt+0x1f2>
  800577:	89 df                	mov    %ebx,%edi
  800579:	8b 75 08             	mov    0x8(%ebp),%esi
  80057c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80057f:	eb 18                	jmp    800599 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800581:	83 ec 08             	sub    $0x8,%esp
  800584:	53                   	push   %ebx
  800585:	6a 20                	push   $0x20
  800587:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800589:	83 ef 01             	sub    $0x1,%edi
  80058c:	83 c4 10             	add    $0x10,%esp
  80058f:	eb 08                	jmp    800599 <vprintfmt+0x278>
  800591:	89 df                	mov    %ebx,%edi
  800593:	8b 75 08             	mov    0x8(%ebp),%esi
  800596:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800599:	85 ff                	test   %edi,%edi
  80059b:	7f e4                	jg     800581 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80059d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005a0:	e9 a2 fd ff ff       	jmp    800347 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005a5:	8d 45 14             	lea    0x14(%ebp),%eax
  8005a8:	e8 08 fd ff ff       	call   8002b5 <getint>
  8005ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b0:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8005b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8005b8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005bc:	79 74                	jns    800632 <vprintfmt+0x311>
				putch('-', putdat);
  8005be:	83 ec 08             	sub    $0x8,%esp
  8005c1:	53                   	push   %ebx
  8005c2:	6a 2d                	push   $0x2d
  8005c4:	ff d6                	call   *%esi
				num = -(long long) num;
  8005c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005c9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005cc:	f7 d8                	neg    %eax
  8005ce:	83 d2 00             	adc    $0x0,%edx
  8005d1:	f7 da                	neg    %edx
  8005d3:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8005d6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8005db:	eb 55                	jmp    800632 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8005dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8005e0:	e8 96 fc ff ff       	call   80027b <getuint>
			base = 10;
  8005e5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8005ea:	eb 46                	jmp    800632 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8005ec:	8d 45 14             	lea    0x14(%ebp),%eax
  8005ef:	e8 87 fc ff ff       	call   80027b <getuint>
			base = 8;
  8005f4:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8005f9:	eb 37                	jmp    800632 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  8005fb:	83 ec 08             	sub    $0x8,%esp
  8005fe:	53                   	push   %ebx
  8005ff:	6a 30                	push   $0x30
  800601:	ff d6                	call   *%esi
			putch('x', putdat);
  800603:	83 c4 08             	add    $0x8,%esp
  800606:	53                   	push   %ebx
  800607:	6a 78                	push   $0x78
  800609:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	8d 50 04             	lea    0x4(%eax),%edx
  800611:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800614:	8b 00                	mov    (%eax),%eax
  800616:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  80061b:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80061e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800623:	eb 0d                	jmp    800632 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800625:	8d 45 14             	lea    0x14(%ebp),%eax
  800628:	e8 4e fc ff ff       	call   80027b <getuint>
			base = 16;
  80062d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800632:	83 ec 0c             	sub    $0xc,%esp
  800635:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800639:	57                   	push   %edi
  80063a:	ff 75 e0             	pushl  -0x20(%ebp)
  80063d:	51                   	push   %ecx
  80063e:	52                   	push   %edx
  80063f:	50                   	push   %eax
  800640:	89 da                	mov    %ebx,%edx
  800642:	89 f0                	mov    %esi,%eax
  800644:	e8 83 fb ff ff       	call   8001cc <printnum>
			break;
  800649:	83 c4 20             	add    $0x20,%esp
  80064c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80064f:	e9 f3 fc ff ff       	jmp    800347 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	53                   	push   %ebx
  800658:	51                   	push   %ecx
  800659:	ff d6                	call   *%esi
			break;
  80065b:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80065e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800661:	e9 e1 fc ff ff       	jmp    800347 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800666:	83 ec 08             	sub    $0x8,%esp
  800669:	53                   	push   %ebx
  80066a:	6a 25                	push   $0x25
  80066c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80066e:	83 c4 10             	add    $0x10,%esp
  800671:	eb 03                	jmp    800676 <vprintfmt+0x355>
  800673:	83 ef 01             	sub    $0x1,%edi
  800676:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  80067a:	75 f7                	jne    800673 <vprintfmt+0x352>
  80067c:	e9 c6 fc ff ff       	jmp    800347 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  800681:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800684:	5b                   	pop    %ebx
  800685:	5e                   	pop    %esi
  800686:	5f                   	pop    %edi
  800687:	5d                   	pop    %ebp
  800688:	c3                   	ret    

00800689 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800689:	55                   	push   %ebp
  80068a:	89 e5                	mov    %esp,%ebp
  80068c:	83 ec 18             	sub    $0x18,%esp
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800695:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800698:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80069c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80069f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006a6:	85 c0                	test   %eax,%eax
  8006a8:	74 26                	je     8006d0 <vsnprintf+0x47>
  8006aa:	85 d2                	test   %edx,%edx
  8006ac:	7e 22                	jle    8006d0 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006ae:	ff 75 14             	pushl  0x14(%ebp)
  8006b1:	ff 75 10             	pushl  0x10(%ebp)
  8006b4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006b7:	50                   	push   %eax
  8006b8:	68 e7 02 80 00       	push   $0x8002e7
  8006bd:	e8 5f fc ff ff       	call   800321 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006c5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006cb:	83 c4 10             	add    $0x10,%esp
  8006ce:	eb 05                	jmp    8006d5 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8006d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8006d5:	c9                   	leave  
  8006d6:	c3                   	ret    

008006d7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006d7:	55                   	push   %ebp
  8006d8:	89 e5                	mov    %esp,%ebp
  8006da:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8006dd:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8006e0:	50                   	push   %eax
  8006e1:	ff 75 10             	pushl  0x10(%ebp)
  8006e4:	ff 75 0c             	pushl  0xc(%ebp)
  8006e7:	ff 75 08             	pushl  0x8(%ebp)
  8006ea:	e8 9a ff ff ff       	call   800689 <vsnprintf>
	va_end(ap);

	return rc;
}
  8006ef:	c9                   	leave  
  8006f0:	c3                   	ret    

008006f1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8006f1:	55                   	push   %ebp
  8006f2:	89 e5                	mov    %esp,%ebp
  8006f4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8006f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8006fc:	eb 03                	jmp    800701 <strlen+0x10>
		n++;
  8006fe:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800701:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800705:	75 f7                	jne    8006fe <strlen+0xd>
		n++;
	return n;
}
  800707:	5d                   	pop    %ebp
  800708:	c3                   	ret    

00800709 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
  80070c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80070f:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800712:	ba 00 00 00 00       	mov    $0x0,%edx
  800717:	eb 03                	jmp    80071c <strnlen+0x13>
		n++;
  800719:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80071c:	39 c2                	cmp    %eax,%edx
  80071e:	74 08                	je     800728 <strnlen+0x1f>
  800720:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800724:	75 f3                	jne    800719 <strnlen+0x10>
  800726:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  800728:	5d                   	pop    %ebp
  800729:	c3                   	ret    

0080072a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80072a:	55                   	push   %ebp
  80072b:	89 e5                	mov    %esp,%ebp
  80072d:	53                   	push   %ebx
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800734:	89 c2                	mov    %eax,%edx
  800736:	83 c2 01             	add    $0x1,%edx
  800739:	83 c1 01             	add    $0x1,%ecx
  80073c:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800740:	88 5a ff             	mov    %bl,-0x1(%edx)
  800743:	84 db                	test   %bl,%bl
  800745:	75 ef                	jne    800736 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800747:	5b                   	pop    %ebx
  800748:	5d                   	pop    %ebp
  800749:	c3                   	ret    

0080074a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80074a:	55                   	push   %ebp
  80074b:	89 e5                	mov    %esp,%ebp
  80074d:	53                   	push   %ebx
  80074e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800751:	53                   	push   %ebx
  800752:	e8 9a ff ff ff       	call   8006f1 <strlen>
  800757:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80075a:	ff 75 0c             	pushl  0xc(%ebp)
  80075d:	01 d8                	add    %ebx,%eax
  80075f:	50                   	push   %eax
  800760:	e8 c5 ff ff ff       	call   80072a <strcpy>
	return dst;
}
  800765:	89 d8                	mov    %ebx,%eax
  800767:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80076a:	c9                   	leave  
  80076b:	c3                   	ret    

0080076c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80076c:	55                   	push   %ebp
  80076d:	89 e5                	mov    %esp,%ebp
  80076f:	56                   	push   %esi
  800770:	53                   	push   %ebx
  800771:	8b 75 08             	mov    0x8(%ebp),%esi
  800774:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800777:	89 f3                	mov    %esi,%ebx
  800779:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80077c:	89 f2                	mov    %esi,%edx
  80077e:	eb 0f                	jmp    80078f <strncpy+0x23>
		*dst++ = *src;
  800780:	83 c2 01             	add    $0x1,%edx
  800783:	0f b6 01             	movzbl (%ecx),%eax
  800786:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800789:	80 39 01             	cmpb   $0x1,(%ecx)
  80078c:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80078f:	39 da                	cmp    %ebx,%edx
  800791:	75 ed                	jne    800780 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800793:	89 f0                	mov    %esi,%eax
  800795:	5b                   	pop    %ebx
  800796:	5e                   	pop    %esi
  800797:	5d                   	pop    %ebp
  800798:	c3                   	ret    

00800799 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
  80079c:	56                   	push   %esi
  80079d:	53                   	push   %ebx
  80079e:	8b 75 08             	mov    0x8(%ebp),%esi
  8007a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007a4:	8b 55 10             	mov    0x10(%ebp),%edx
  8007a7:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007a9:	85 d2                	test   %edx,%edx
  8007ab:	74 21                	je     8007ce <strlcpy+0x35>
  8007ad:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8007b1:	89 f2                	mov    %esi,%edx
  8007b3:	eb 09                	jmp    8007be <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8007b5:	83 c2 01             	add    $0x1,%edx
  8007b8:	83 c1 01             	add    $0x1,%ecx
  8007bb:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8007be:	39 c2                	cmp    %eax,%edx
  8007c0:	74 09                	je     8007cb <strlcpy+0x32>
  8007c2:	0f b6 19             	movzbl (%ecx),%ebx
  8007c5:	84 db                	test   %bl,%bl
  8007c7:	75 ec                	jne    8007b5 <strlcpy+0x1c>
  8007c9:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  8007cb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007ce:	29 f0                	sub    %esi,%eax
}
  8007d0:	5b                   	pop    %ebx
  8007d1:	5e                   	pop    %esi
  8007d2:	5d                   	pop    %ebp
  8007d3:	c3                   	ret    

008007d4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
  8007d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007da:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007dd:	eb 06                	jmp    8007e5 <strcmp+0x11>
		p++, q++;
  8007df:	83 c1 01             	add    $0x1,%ecx
  8007e2:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8007e5:	0f b6 01             	movzbl (%ecx),%eax
  8007e8:	84 c0                	test   %al,%al
  8007ea:	74 04                	je     8007f0 <strcmp+0x1c>
  8007ec:	3a 02                	cmp    (%edx),%al
  8007ee:	74 ef                	je     8007df <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8007f0:	0f b6 c0             	movzbl %al,%eax
  8007f3:	0f b6 12             	movzbl (%edx),%edx
  8007f6:	29 d0                	sub    %edx,%eax
}
  8007f8:	5d                   	pop    %ebp
  8007f9:	c3                   	ret    

008007fa <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	53                   	push   %ebx
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	8b 55 0c             	mov    0xc(%ebp),%edx
  800804:	89 c3                	mov    %eax,%ebx
  800806:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800809:	eb 06                	jmp    800811 <strncmp+0x17>
		n--, p++, q++;
  80080b:	83 c0 01             	add    $0x1,%eax
  80080e:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800811:	39 d8                	cmp    %ebx,%eax
  800813:	74 15                	je     80082a <strncmp+0x30>
  800815:	0f b6 08             	movzbl (%eax),%ecx
  800818:	84 c9                	test   %cl,%cl
  80081a:	74 04                	je     800820 <strncmp+0x26>
  80081c:	3a 0a                	cmp    (%edx),%cl
  80081e:	74 eb                	je     80080b <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800820:	0f b6 00             	movzbl (%eax),%eax
  800823:	0f b6 12             	movzbl (%edx),%edx
  800826:	29 d0                	sub    %edx,%eax
  800828:	eb 05                	jmp    80082f <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  80082a:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  80082f:	5b                   	pop    %ebx
  800830:	5d                   	pop    %ebp
  800831:	c3                   	ret    

00800832 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  800838:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80083c:	eb 07                	jmp    800845 <strchr+0x13>
		if (*s == c)
  80083e:	38 ca                	cmp    %cl,%dl
  800840:	74 0f                	je     800851 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800842:	83 c0 01             	add    $0x1,%eax
  800845:	0f b6 10             	movzbl (%eax),%edx
  800848:	84 d2                	test   %dl,%dl
  80084a:	75 f2                	jne    80083e <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  80084c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800851:	5d                   	pop    %ebp
  800852:	c3                   	ret    

00800853 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800853:	55                   	push   %ebp
  800854:	89 e5                	mov    %esp,%ebp
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80085d:	eb 03                	jmp    800862 <strfind+0xf>
  80085f:	83 c0 01             	add    $0x1,%eax
  800862:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800865:	38 ca                	cmp    %cl,%dl
  800867:	74 04                	je     80086d <strfind+0x1a>
  800869:	84 d2                	test   %dl,%dl
  80086b:	75 f2                	jne    80085f <strfind+0xc>
			break;
	return (char *) s;
}
  80086d:	5d                   	pop    %ebp
  80086e:	c3                   	ret    

0080086f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
  800872:	57                   	push   %edi
  800873:	56                   	push   %esi
  800874:	53                   	push   %ebx
  800875:	8b 55 08             	mov    0x8(%ebp),%edx
  800878:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  80087b:	85 c9                	test   %ecx,%ecx
  80087d:	74 37                	je     8008b6 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80087f:	f6 c2 03             	test   $0x3,%dl
  800882:	75 2a                	jne    8008ae <memset+0x3f>
  800884:	f6 c1 03             	test   $0x3,%cl
  800887:	75 25                	jne    8008ae <memset+0x3f>
		c &= 0xFF;
  800889:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80088d:	89 df                	mov    %ebx,%edi
  80088f:	c1 e7 08             	shl    $0x8,%edi
  800892:	89 de                	mov    %ebx,%esi
  800894:	c1 e6 18             	shl    $0x18,%esi
  800897:	89 d8                	mov    %ebx,%eax
  800899:	c1 e0 10             	shl    $0x10,%eax
  80089c:	09 f0                	or     %esi,%eax
  80089e:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8008a0:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8008a3:	89 f8                	mov    %edi,%eax
  8008a5:	09 d8                	or     %ebx,%eax
  8008a7:	89 d7                	mov    %edx,%edi
  8008a9:	fc                   	cld    
  8008aa:	f3 ab                	rep stos %eax,%es:(%edi)
  8008ac:	eb 08                	jmp    8008b6 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008ae:	89 d7                	mov    %edx,%edi
  8008b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b3:	fc                   	cld    
  8008b4:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8008b6:	89 d0                	mov    %edx,%eax
  8008b8:	5b                   	pop    %ebx
  8008b9:	5e                   	pop    %esi
  8008ba:	5f                   	pop    %edi
  8008bb:	5d                   	pop    %ebp
  8008bc:	c3                   	ret    

008008bd <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008bd:	55                   	push   %ebp
  8008be:	89 e5                	mov    %esp,%ebp
  8008c0:	57                   	push   %edi
  8008c1:	56                   	push   %esi
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008cb:	39 c6                	cmp    %eax,%esi
  8008cd:	73 35                	jae    800904 <memmove+0x47>
  8008cf:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008d2:	39 d0                	cmp    %edx,%eax
  8008d4:	73 2e                	jae    800904 <memmove+0x47>
		s += n;
		d += n;
  8008d6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008d9:	89 d6                	mov    %edx,%esi
  8008db:	09 fe                	or     %edi,%esi
  8008dd:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008e3:	75 13                	jne    8008f8 <memmove+0x3b>
  8008e5:	f6 c1 03             	test   $0x3,%cl
  8008e8:	75 0e                	jne    8008f8 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  8008ea:	83 ef 04             	sub    $0x4,%edi
  8008ed:	8d 72 fc             	lea    -0x4(%edx),%esi
  8008f0:	c1 e9 02             	shr    $0x2,%ecx
  8008f3:	fd                   	std    
  8008f4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008f6:	eb 09                	jmp    800901 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8008f8:	83 ef 01             	sub    $0x1,%edi
  8008fb:	8d 72 ff             	lea    -0x1(%edx),%esi
  8008fe:	fd                   	std    
  8008ff:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800901:	fc                   	cld    
  800902:	eb 1d                	jmp    800921 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800904:	89 f2                	mov    %esi,%edx
  800906:	09 c2                	or     %eax,%edx
  800908:	f6 c2 03             	test   $0x3,%dl
  80090b:	75 0f                	jne    80091c <memmove+0x5f>
  80090d:	f6 c1 03             	test   $0x3,%cl
  800910:	75 0a                	jne    80091c <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  800912:	c1 e9 02             	shr    $0x2,%ecx
  800915:	89 c7                	mov    %eax,%edi
  800917:	fc                   	cld    
  800918:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80091a:	eb 05                	jmp    800921 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80091c:	89 c7                	mov    %eax,%edi
  80091e:	fc                   	cld    
  80091f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800921:	5e                   	pop    %esi
  800922:	5f                   	pop    %edi
  800923:	5d                   	pop    %ebp
  800924:	c3                   	ret    

00800925 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800928:	ff 75 10             	pushl  0x10(%ebp)
  80092b:	ff 75 0c             	pushl  0xc(%ebp)
  80092e:	ff 75 08             	pushl  0x8(%ebp)
  800931:	e8 87 ff ff ff       	call   8008bd <memmove>
}
  800936:	c9                   	leave  
  800937:	c3                   	ret    

00800938 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800938:	55                   	push   %ebp
  800939:	89 e5                	mov    %esp,%ebp
  80093b:	56                   	push   %esi
  80093c:	53                   	push   %ebx
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 55 0c             	mov    0xc(%ebp),%edx
  800943:	89 c6                	mov    %eax,%esi
  800945:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800948:	eb 1a                	jmp    800964 <memcmp+0x2c>
		if (*s1 != *s2)
  80094a:	0f b6 08             	movzbl (%eax),%ecx
  80094d:	0f b6 1a             	movzbl (%edx),%ebx
  800950:	38 d9                	cmp    %bl,%cl
  800952:	74 0a                	je     80095e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800954:	0f b6 c1             	movzbl %cl,%eax
  800957:	0f b6 db             	movzbl %bl,%ebx
  80095a:	29 d8                	sub    %ebx,%eax
  80095c:	eb 0f                	jmp    80096d <memcmp+0x35>
		s1++, s2++;
  80095e:	83 c0 01             	add    $0x1,%eax
  800961:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800964:	39 f0                	cmp    %esi,%eax
  800966:	75 e2                	jne    80094a <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800968:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80096d:	5b                   	pop    %ebx
  80096e:	5e                   	pop    %esi
  80096f:	5d                   	pop    %ebp
  800970:	c3                   	ret    

00800971 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	53                   	push   %ebx
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800978:	89 c1                	mov    %eax,%ecx
  80097a:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  80097d:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800981:	eb 0a                	jmp    80098d <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800983:	0f b6 10             	movzbl (%eax),%edx
  800986:	39 da                	cmp    %ebx,%edx
  800988:	74 07                	je     800991 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80098a:	83 c0 01             	add    $0x1,%eax
  80098d:	39 c8                	cmp    %ecx,%eax
  80098f:	72 f2                	jb     800983 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800991:	5b                   	pop    %ebx
  800992:	5d                   	pop    %ebp
  800993:	c3                   	ret    

00800994 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	57                   	push   %edi
  800998:	56                   	push   %esi
  800999:	53                   	push   %ebx
  80099a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80099d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009a0:	eb 03                	jmp    8009a5 <strtol+0x11>
		s++;
  8009a2:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009a5:	0f b6 01             	movzbl (%ecx),%eax
  8009a8:	3c 20                	cmp    $0x20,%al
  8009aa:	74 f6                	je     8009a2 <strtol+0xe>
  8009ac:	3c 09                	cmp    $0x9,%al
  8009ae:	74 f2                	je     8009a2 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8009b0:	3c 2b                	cmp    $0x2b,%al
  8009b2:	75 0a                	jne    8009be <strtol+0x2a>
		s++;
  8009b4:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8009b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8009bc:	eb 11                	jmp    8009cf <strtol+0x3b>
  8009be:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8009c3:	3c 2d                	cmp    $0x2d,%al
  8009c5:	75 08                	jne    8009cf <strtol+0x3b>
		s++, neg = 1;
  8009c7:	83 c1 01             	add    $0x1,%ecx
  8009ca:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009cf:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009d5:	75 15                	jne    8009ec <strtol+0x58>
  8009d7:	80 39 30             	cmpb   $0x30,(%ecx)
  8009da:	75 10                	jne    8009ec <strtol+0x58>
  8009dc:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8009e0:	75 7c                	jne    800a5e <strtol+0xca>
		s += 2, base = 16;
  8009e2:	83 c1 02             	add    $0x2,%ecx
  8009e5:	bb 10 00 00 00       	mov    $0x10,%ebx
  8009ea:	eb 16                	jmp    800a02 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  8009ec:	85 db                	test   %ebx,%ebx
  8009ee:	75 12                	jne    800a02 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009f0:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009f5:	80 39 30             	cmpb   $0x30,(%ecx)
  8009f8:	75 08                	jne    800a02 <strtol+0x6e>
		s++, base = 8;
  8009fa:	83 c1 01             	add    $0x1,%ecx
  8009fd:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800a02:	b8 00 00 00 00       	mov    $0x0,%eax
  800a07:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800a0a:	0f b6 11             	movzbl (%ecx),%edx
  800a0d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a10:	89 f3                	mov    %esi,%ebx
  800a12:	80 fb 09             	cmp    $0x9,%bl
  800a15:	77 08                	ja     800a1f <strtol+0x8b>
			dig = *s - '0';
  800a17:	0f be d2             	movsbl %dl,%edx
  800a1a:	83 ea 30             	sub    $0x30,%edx
  800a1d:	eb 22                	jmp    800a41 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800a1f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a22:	89 f3                	mov    %esi,%ebx
  800a24:	80 fb 19             	cmp    $0x19,%bl
  800a27:	77 08                	ja     800a31 <strtol+0x9d>
			dig = *s - 'a' + 10;
  800a29:	0f be d2             	movsbl %dl,%edx
  800a2c:	83 ea 57             	sub    $0x57,%edx
  800a2f:	eb 10                	jmp    800a41 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800a31:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a34:	89 f3                	mov    %esi,%ebx
  800a36:	80 fb 19             	cmp    $0x19,%bl
  800a39:	77 16                	ja     800a51 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800a3b:	0f be d2             	movsbl %dl,%edx
  800a3e:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800a41:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a44:	7d 0b                	jge    800a51 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800a46:	83 c1 01             	add    $0x1,%ecx
  800a49:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a4d:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800a4f:	eb b9                	jmp    800a0a <strtol+0x76>

	if (endptr)
  800a51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a55:	74 0d                	je     800a64 <strtol+0xd0>
		*endptr = (char *) s;
  800a57:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a5a:	89 0e                	mov    %ecx,(%esi)
  800a5c:	eb 06                	jmp    800a64 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a5e:	85 db                	test   %ebx,%ebx
  800a60:	74 98                	je     8009fa <strtol+0x66>
  800a62:	eb 9e                	jmp    800a02 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800a64:	89 c2                	mov    %eax,%edx
  800a66:	f7 da                	neg    %edx
  800a68:	85 ff                	test   %edi,%edi
  800a6a:	0f 45 c2             	cmovne %edx,%eax
}
  800a6d:	5b                   	pop    %ebx
  800a6e:	5e                   	pop    %esi
  800a6f:	5f                   	pop    %edi
  800a70:	5d                   	pop    %ebp
  800a71:	c3                   	ret    

00800a72 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	57                   	push   %edi
  800a76:	56                   	push   %esi
  800a77:	53                   	push   %ebx
  800a78:	83 ec 1c             	sub    $0x1c,%esp
  800a7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a7e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a81:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800a83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a86:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a89:	8b 7d 10             	mov    0x10(%ebp),%edi
  800a8c:	8b 75 14             	mov    0x14(%ebp),%esi
  800a8f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800a91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a95:	74 1d                	je     800ab4 <syscall+0x42>
  800a97:	85 c0                	test   %eax,%eax
  800a99:	7e 19                	jle    800ab4 <syscall+0x42>
  800a9b:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800a9e:	83 ec 0c             	sub    $0xc,%esp
  800aa1:	50                   	push   %eax
  800aa2:	52                   	push   %edx
  800aa3:	68 df 26 80 00       	push   $0x8026df
  800aa8:	6a 23                	push   $0x23
  800aaa:	68 fc 26 80 00       	push   $0x8026fc
  800aaf:	e8 2b f6 ff ff       	call   8000df <_panic>

	return ret;
}
  800ab4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ab7:	5b                   	pop    %ebx
  800ab8:	5e                   	pop    %esi
  800ab9:	5f                   	pop    %edi
  800aba:	5d                   	pop    %ebp
  800abb:	c3                   	ret    

00800abc <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800ac2:	6a 00                	push   $0x0
  800ac4:	6a 00                	push   $0x0
  800ac6:	6a 00                	push   $0x0
  800ac8:	ff 75 0c             	pushl  0xc(%ebp)
  800acb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ace:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad8:	e8 95 ff ff ff       	call   800a72 <syscall>
}
  800add:	83 c4 10             	add    $0x10,%esp
  800ae0:	c9                   	leave  
  800ae1:	c3                   	ret    

00800ae2 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800ae8:	6a 00                	push   $0x0
  800aea:	6a 00                	push   $0x0
  800aec:	6a 00                	push   $0x0
  800aee:	6a 00                	push   $0x0
  800af0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800af5:	ba 00 00 00 00       	mov    $0x0,%edx
  800afa:	b8 01 00 00 00       	mov    $0x1,%eax
  800aff:	e8 6e ff ff ff       	call   800a72 <syscall>
}
  800b04:	c9                   	leave  
  800b05:	c3                   	ret    

00800b06 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800b0c:	6a 00                	push   $0x0
  800b0e:	6a 00                	push   $0x0
  800b10:	6a 00                	push   $0x0
  800b12:	6a 00                	push   $0x0
  800b14:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b17:	ba 01 00 00 00       	mov    $0x1,%edx
  800b1c:	b8 03 00 00 00       	mov    $0x3,%eax
  800b21:	e8 4c ff ff ff       	call   800a72 <syscall>
}
  800b26:	c9                   	leave  
  800b27:	c3                   	ret    

00800b28 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b2e:	6a 00                	push   $0x0
  800b30:	6a 00                	push   $0x0
  800b32:	6a 00                	push   $0x0
  800b34:	6a 00                	push   $0x0
  800b36:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b40:	b8 02 00 00 00       	mov    $0x2,%eax
  800b45:	e8 28 ff ff ff       	call   800a72 <syscall>
}
  800b4a:	c9                   	leave  
  800b4b:	c3                   	ret    

00800b4c <sys_yield>:

void
sys_yield(void)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b52:	6a 00                	push   $0x0
  800b54:	6a 00                	push   $0x0
  800b56:	6a 00                	push   $0x0
  800b58:	6a 00                	push   $0x0
  800b5a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b5f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b64:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b69:	e8 04 ff ff ff       	call   800a72 <syscall>
}
  800b6e:	83 c4 10             	add    $0x10,%esp
  800b71:	c9                   	leave  
  800b72:	c3                   	ret    

00800b73 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800b79:	6a 00                	push   $0x0
  800b7b:	6a 00                	push   $0x0
  800b7d:	ff 75 10             	pushl  0x10(%ebp)
  800b80:	ff 75 0c             	pushl  0xc(%ebp)
  800b83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b86:	ba 01 00 00 00       	mov    $0x1,%edx
  800b8b:	b8 04 00 00 00       	mov    $0x4,%eax
  800b90:	e8 dd fe ff ff       	call   800a72 <syscall>
}
  800b95:	c9                   	leave  
  800b96:	c3                   	ret    

00800b97 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800b9d:	ff 75 18             	pushl  0x18(%ebp)
  800ba0:	ff 75 14             	pushl  0x14(%ebp)
  800ba3:	ff 75 10             	pushl  0x10(%ebp)
  800ba6:	ff 75 0c             	pushl  0xc(%ebp)
  800ba9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bac:	ba 01 00 00 00       	mov    $0x1,%edx
  800bb1:	b8 05 00 00 00       	mov    $0x5,%eax
  800bb6:	e8 b7 fe ff ff       	call   800a72 <syscall>
}
  800bbb:	c9                   	leave  
  800bbc:	c3                   	ret    

00800bbd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800bc3:	6a 00                	push   $0x0
  800bc5:	6a 00                	push   $0x0
  800bc7:	6a 00                	push   $0x0
  800bc9:	ff 75 0c             	pushl  0xc(%ebp)
  800bcc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bcf:	ba 01 00 00 00       	mov    $0x1,%edx
  800bd4:	b8 06 00 00 00       	mov    $0x6,%eax
  800bd9:	e8 94 fe ff ff       	call   800a72 <syscall>
}
  800bde:	c9                   	leave  
  800bdf:	c3                   	ret    

00800be0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800be6:	6a 00                	push   $0x0
  800be8:	6a 00                	push   $0x0
  800bea:	6a 00                	push   $0x0
  800bec:	ff 75 0c             	pushl  0xc(%ebp)
  800bef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf2:	ba 01 00 00 00       	mov    $0x1,%edx
  800bf7:	b8 08 00 00 00       	mov    $0x8,%eax
  800bfc:	e8 71 fe ff ff       	call   800a72 <syscall>
}
  800c01:	c9                   	leave  
  800c02:	c3                   	ret    

00800c03 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800c09:	6a 00                	push   $0x0
  800c0b:	6a 00                	push   $0x0
  800c0d:	6a 00                	push   $0x0
  800c0f:	ff 75 0c             	pushl  0xc(%ebp)
  800c12:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c15:	ba 01 00 00 00       	mov    $0x1,%edx
  800c1a:	b8 09 00 00 00       	mov    $0x9,%eax
  800c1f:	e8 4e fe ff ff       	call   800a72 <syscall>
}
  800c24:	c9                   	leave  
  800c25:	c3                   	ret    

00800c26 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800c2c:	6a 00                	push   $0x0
  800c2e:	6a 00                	push   $0x0
  800c30:	6a 00                	push   $0x0
  800c32:	ff 75 0c             	pushl  0xc(%ebp)
  800c35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c38:	ba 01 00 00 00       	mov    $0x1,%edx
  800c3d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c42:	e8 2b fe ff ff       	call   800a72 <syscall>
}
  800c47:	c9                   	leave  
  800c48:	c3                   	ret    

00800c49 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800c4f:	6a 00                	push   $0x0
  800c51:	ff 75 14             	pushl  0x14(%ebp)
  800c54:	ff 75 10             	pushl  0x10(%ebp)
  800c57:	ff 75 0c             	pushl  0xc(%ebp)
  800c5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c62:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c67:	e8 06 fe ff ff       	call   800a72 <syscall>
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800c74:	6a 00                	push   $0x0
  800c76:	6a 00                	push   $0x0
  800c78:	6a 00                	push   $0x0
  800c7a:	6a 00                	push   $0x0
  800c7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c7f:	ba 01 00 00 00       	mov    $0x1,%edx
  800c84:	b8 0d 00 00 00       	mov    $0xd,%eax
  800c89:	e8 e4 fd ff ff       	call   800a72 <syscall>
}
  800c8e:	c9                   	leave  
  800c8f:	c3                   	ret    

00800c90 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	05 00 00 00 30       	add    $0x30000000,%eax
  800c9b:	c1 e8 0c             	shr    $0xc,%eax
}
  800c9e:	5d                   	pop    %ebp
  800c9f:	c3                   	ret    

00800ca0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  800ca3:	ff 75 08             	pushl  0x8(%ebp)
  800ca6:	e8 e5 ff ff ff       	call   800c90 <fd2num>
  800cab:	83 c4 04             	add    $0x4,%esp
  800cae:	c1 e0 0c             	shl    $0xc,%eax
  800cb1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800cb6:	c9                   	leave  
  800cb7:	c3                   	ret    

00800cb8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cbe:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800cc3:	89 c2                	mov    %eax,%edx
  800cc5:	c1 ea 16             	shr    $0x16,%edx
  800cc8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ccf:	f6 c2 01             	test   $0x1,%dl
  800cd2:	74 11                	je     800ce5 <fd_alloc+0x2d>
  800cd4:	89 c2                	mov    %eax,%edx
  800cd6:	c1 ea 0c             	shr    $0xc,%edx
  800cd9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ce0:	f6 c2 01             	test   $0x1,%dl
  800ce3:	75 09                	jne    800cee <fd_alloc+0x36>
			*fd_store = fd;
  800ce5:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  800cec:	eb 17                	jmp    800d05 <fd_alloc+0x4d>
  800cee:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800cf3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800cf8:	75 c9                	jne    800cc3 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800cfa:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800d00:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    

00800d07 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800d0d:	83 f8 1f             	cmp    $0x1f,%eax
  800d10:	77 36                	ja     800d48 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800d12:	c1 e0 0c             	shl    $0xc,%eax
  800d15:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800d1a:	89 c2                	mov    %eax,%edx
  800d1c:	c1 ea 16             	shr    $0x16,%edx
  800d1f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800d26:	f6 c2 01             	test   $0x1,%dl
  800d29:	74 24                	je     800d4f <fd_lookup+0x48>
  800d2b:	89 c2                	mov    %eax,%edx
  800d2d:	c1 ea 0c             	shr    $0xc,%edx
  800d30:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d37:	f6 c2 01             	test   $0x1,%dl
  800d3a:	74 1a                	je     800d56 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800d3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3f:	89 02                	mov    %eax,(%edx)
	return 0;
  800d41:	b8 00 00 00 00       	mov    $0x0,%eax
  800d46:	eb 13                	jmp    800d5b <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800d48:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d4d:	eb 0c                	jmp    800d5b <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800d4f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d54:	eb 05                	jmp    800d5b <fd_lookup+0x54>
  800d56:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800d5b:	5d                   	pop    %ebp
  800d5c:	c3                   	ret    

00800d5d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	83 ec 08             	sub    $0x8,%esp
  800d63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d66:	ba 88 27 80 00       	mov    $0x802788,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800d6b:	eb 13                	jmp    800d80 <dev_lookup+0x23>
  800d6d:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  800d70:	39 08                	cmp    %ecx,(%eax)
  800d72:	75 0c                	jne    800d80 <dev_lookup+0x23>
			*dev = devtab[i];
  800d74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d77:	89 01                	mov    %eax,(%ecx)
			return 0;
  800d79:	b8 00 00 00 00       	mov    $0x0,%eax
  800d7e:	eb 2e                	jmp    800dae <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800d80:	8b 02                	mov    (%edx),%eax
  800d82:	85 c0                	test   %eax,%eax
  800d84:	75 e7                	jne    800d6d <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800d86:	a1 04 40 80 00       	mov    0x804004,%eax
  800d8b:	8b 40 48             	mov    0x48(%eax),%eax
  800d8e:	83 ec 04             	sub    $0x4,%esp
  800d91:	51                   	push   %ecx
  800d92:	50                   	push   %eax
  800d93:	68 0c 27 80 00       	push   $0x80270c
  800d98:	e8 1b f4 ff ff       	call   8001b8 <cprintf>
	*dev = 0;
  800d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800da6:	83 c4 10             	add    $0x10,%esp
  800da9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	56                   	push   %esi
  800db4:	53                   	push   %ebx
  800db5:	83 ec 10             	sub    $0x10,%esp
  800db8:	8b 75 08             	mov    0x8(%ebp),%esi
  800dbb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800dbe:	56                   	push   %esi
  800dbf:	e8 cc fe ff ff       	call   800c90 <fd2num>
  800dc4:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800dc7:	89 14 24             	mov    %edx,(%esp)
  800dca:	50                   	push   %eax
  800dcb:	e8 37 ff ff ff       	call   800d07 <fd_lookup>
  800dd0:	83 c4 08             	add    $0x8,%esp
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	78 05                	js     800ddc <fd_close+0x2c>
	    || fd != fd2)
  800dd7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800dda:	74 0c                	je     800de8 <fd_close+0x38>
		return (must_exist ? r : 0);
  800ddc:	84 db                	test   %bl,%bl
  800dde:	ba 00 00 00 00       	mov    $0x0,%edx
  800de3:	0f 44 c2             	cmove  %edx,%eax
  800de6:	eb 41                	jmp    800e29 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800de8:	83 ec 08             	sub    $0x8,%esp
  800deb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800dee:	50                   	push   %eax
  800def:	ff 36                	pushl  (%esi)
  800df1:	e8 67 ff ff ff       	call   800d5d <dev_lookup>
  800df6:	89 c3                	mov    %eax,%ebx
  800df8:	83 c4 10             	add    $0x10,%esp
  800dfb:	85 c0                	test   %eax,%eax
  800dfd:	78 1a                	js     800e19 <fd_close+0x69>
		if (dev->dev_close)
  800dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e02:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800e05:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800e0a:	85 c0                	test   %eax,%eax
  800e0c:	74 0b                	je     800e19 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  800e0e:	83 ec 0c             	sub    $0xc,%esp
  800e11:	56                   	push   %esi
  800e12:	ff d0                	call   *%eax
  800e14:	89 c3                	mov    %eax,%ebx
  800e16:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800e19:	83 ec 08             	sub    $0x8,%esp
  800e1c:	56                   	push   %esi
  800e1d:	6a 00                	push   $0x0
  800e1f:	e8 99 fd ff ff       	call   800bbd <sys_page_unmap>
	return r;
  800e24:	83 c4 10             	add    $0x10,%esp
  800e27:	89 d8                	mov    %ebx,%eax
}
  800e29:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e2c:	5b                   	pop    %ebx
  800e2d:	5e                   	pop    %esi
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    

00800e30 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e36:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e39:	50                   	push   %eax
  800e3a:	ff 75 08             	pushl  0x8(%ebp)
  800e3d:	e8 c5 fe ff ff       	call   800d07 <fd_lookup>
  800e42:	83 c4 08             	add    $0x8,%esp
  800e45:	85 c0                	test   %eax,%eax
  800e47:	78 10                	js     800e59 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800e49:	83 ec 08             	sub    $0x8,%esp
  800e4c:	6a 01                	push   $0x1
  800e4e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e51:	e8 5a ff ff ff       	call   800db0 <fd_close>
  800e56:	83 c4 10             	add    $0x10,%esp
}
  800e59:	c9                   	leave  
  800e5a:	c3                   	ret    

00800e5b <close_all>:

void
close_all(void)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	53                   	push   %ebx
  800e5f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800e62:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800e67:	83 ec 0c             	sub    $0xc,%esp
  800e6a:	53                   	push   %ebx
  800e6b:	e8 c0 ff ff ff       	call   800e30 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800e70:	83 c3 01             	add    $0x1,%ebx
  800e73:	83 c4 10             	add    $0x10,%esp
  800e76:	83 fb 20             	cmp    $0x20,%ebx
  800e79:	75 ec                	jne    800e67 <close_all+0xc>
		close(i);
}
  800e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e7e:	c9                   	leave  
  800e7f:	c3                   	ret    

00800e80 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	57                   	push   %edi
  800e84:	56                   	push   %esi
  800e85:	53                   	push   %ebx
  800e86:	83 ec 2c             	sub    $0x2c,%esp
  800e89:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800e8c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800e8f:	50                   	push   %eax
  800e90:	ff 75 08             	pushl  0x8(%ebp)
  800e93:	e8 6f fe ff ff       	call   800d07 <fd_lookup>
  800e98:	83 c4 08             	add    $0x8,%esp
  800e9b:	85 c0                	test   %eax,%eax
  800e9d:	0f 88 c1 00 00 00    	js     800f64 <dup+0xe4>
		return r;
	close(newfdnum);
  800ea3:	83 ec 0c             	sub    $0xc,%esp
  800ea6:	56                   	push   %esi
  800ea7:	e8 84 ff ff ff       	call   800e30 <close>

	newfd = INDEX2FD(newfdnum);
  800eac:	89 f3                	mov    %esi,%ebx
  800eae:	c1 e3 0c             	shl    $0xc,%ebx
  800eb1:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800eb7:	83 c4 04             	add    $0x4,%esp
  800eba:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ebd:	e8 de fd ff ff       	call   800ca0 <fd2data>
  800ec2:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  800ec4:	89 1c 24             	mov    %ebx,(%esp)
  800ec7:	e8 d4 fd ff ff       	call   800ca0 <fd2data>
  800ecc:	83 c4 10             	add    $0x10,%esp
  800ecf:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800ed2:	89 f8                	mov    %edi,%eax
  800ed4:	c1 e8 16             	shr    $0x16,%eax
  800ed7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800ede:	a8 01                	test   $0x1,%al
  800ee0:	74 37                	je     800f19 <dup+0x99>
  800ee2:	89 f8                	mov    %edi,%eax
  800ee4:	c1 e8 0c             	shr    $0xc,%eax
  800ee7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800eee:	f6 c2 01             	test   $0x1,%dl
  800ef1:	74 26                	je     800f19 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800ef3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800efa:	83 ec 0c             	sub    $0xc,%esp
  800efd:	25 07 0e 00 00       	and    $0xe07,%eax
  800f02:	50                   	push   %eax
  800f03:	ff 75 d4             	pushl  -0x2c(%ebp)
  800f06:	6a 00                	push   $0x0
  800f08:	57                   	push   %edi
  800f09:	6a 00                	push   $0x0
  800f0b:	e8 87 fc ff ff       	call   800b97 <sys_page_map>
  800f10:	89 c7                	mov    %eax,%edi
  800f12:	83 c4 20             	add    $0x20,%esp
  800f15:	85 c0                	test   %eax,%eax
  800f17:	78 2e                	js     800f47 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800f19:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f1c:	89 d0                	mov    %edx,%eax
  800f1e:	c1 e8 0c             	shr    $0xc,%eax
  800f21:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f28:	83 ec 0c             	sub    $0xc,%esp
  800f2b:	25 07 0e 00 00       	and    $0xe07,%eax
  800f30:	50                   	push   %eax
  800f31:	53                   	push   %ebx
  800f32:	6a 00                	push   $0x0
  800f34:	52                   	push   %edx
  800f35:	6a 00                	push   $0x0
  800f37:	e8 5b fc ff ff       	call   800b97 <sys_page_map>
  800f3c:	89 c7                	mov    %eax,%edi
  800f3e:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  800f41:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800f43:	85 ff                	test   %edi,%edi
  800f45:	79 1d                	jns    800f64 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800f47:	83 ec 08             	sub    $0x8,%esp
  800f4a:	53                   	push   %ebx
  800f4b:	6a 00                	push   $0x0
  800f4d:	e8 6b fc ff ff       	call   800bbd <sys_page_unmap>
	sys_page_unmap(0, nva);
  800f52:	83 c4 08             	add    $0x8,%esp
  800f55:	ff 75 d4             	pushl  -0x2c(%ebp)
  800f58:	6a 00                	push   $0x0
  800f5a:	e8 5e fc ff ff       	call   800bbd <sys_page_unmap>
	return r;
  800f5f:	83 c4 10             	add    $0x10,%esp
  800f62:	89 f8                	mov    %edi,%eax
}
  800f64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f67:	5b                   	pop    %ebx
  800f68:	5e                   	pop    %esi
  800f69:	5f                   	pop    %edi
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	53                   	push   %ebx
  800f70:	83 ec 14             	sub    $0x14,%esp
  800f73:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800f76:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800f79:	50                   	push   %eax
  800f7a:	53                   	push   %ebx
  800f7b:	e8 87 fd ff ff       	call   800d07 <fd_lookup>
  800f80:	83 c4 08             	add    $0x8,%esp
  800f83:	89 c2                	mov    %eax,%edx
  800f85:	85 c0                	test   %eax,%eax
  800f87:	78 6d                	js     800ff6 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800f89:	83 ec 08             	sub    $0x8,%esp
  800f8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f8f:	50                   	push   %eax
  800f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f93:	ff 30                	pushl  (%eax)
  800f95:	e8 c3 fd ff ff       	call   800d5d <dev_lookup>
  800f9a:	83 c4 10             	add    $0x10,%esp
  800f9d:	85 c0                	test   %eax,%eax
  800f9f:	78 4c                	js     800fed <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800fa1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800fa4:	8b 42 08             	mov    0x8(%edx),%eax
  800fa7:	83 e0 03             	and    $0x3,%eax
  800faa:	83 f8 01             	cmp    $0x1,%eax
  800fad:	75 21                	jne    800fd0 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800faf:	a1 04 40 80 00       	mov    0x804004,%eax
  800fb4:	8b 40 48             	mov    0x48(%eax),%eax
  800fb7:	83 ec 04             	sub    $0x4,%esp
  800fba:	53                   	push   %ebx
  800fbb:	50                   	push   %eax
  800fbc:	68 4d 27 80 00       	push   $0x80274d
  800fc1:	e8 f2 f1 ff ff       	call   8001b8 <cprintf>
		return -E_INVAL;
  800fc6:	83 c4 10             	add    $0x10,%esp
  800fc9:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800fce:	eb 26                	jmp    800ff6 <read+0x8a>
	}
	if (!dev->dev_read)
  800fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd3:	8b 40 08             	mov    0x8(%eax),%eax
  800fd6:	85 c0                	test   %eax,%eax
  800fd8:	74 17                	je     800ff1 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800fda:	83 ec 04             	sub    $0x4,%esp
  800fdd:	ff 75 10             	pushl  0x10(%ebp)
  800fe0:	ff 75 0c             	pushl  0xc(%ebp)
  800fe3:	52                   	push   %edx
  800fe4:	ff d0                	call   *%eax
  800fe6:	89 c2                	mov    %eax,%edx
  800fe8:	83 c4 10             	add    $0x10,%esp
  800feb:	eb 09                	jmp    800ff6 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800fed:	89 c2                	mov    %eax,%edx
  800fef:	eb 05                	jmp    800ff6 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800ff1:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  800ff6:	89 d0                	mov    %edx,%eax
  800ff8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ffb:	c9                   	leave  
  800ffc:	c3                   	ret    

00800ffd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
  801000:	57                   	push   %edi
  801001:	56                   	push   %esi
  801002:	53                   	push   %ebx
  801003:	83 ec 0c             	sub    $0xc,%esp
  801006:	8b 7d 08             	mov    0x8(%ebp),%edi
  801009:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80100c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801011:	eb 21                	jmp    801034 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801013:	83 ec 04             	sub    $0x4,%esp
  801016:	89 f0                	mov    %esi,%eax
  801018:	29 d8                	sub    %ebx,%eax
  80101a:	50                   	push   %eax
  80101b:	89 d8                	mov    %ebx,%eax
  80101d:	03 45 0c             	add    0xc(%ebp),%eax
  801020:	50                   	push   %eax
  801021:	57                   	push   %edi
  801022:	e8 45 ff ff ff       	call   800f6c <read>
		if (m < 0)
  801027:	83 c4 10             	add    $0x10,%esp
  80102a:	85 c0                	test   %eax,%eax
  80102c:	78 10                	js     80103e <readn+0x41>
			return m;
		if (m == 0)
  80102e:	85 c0                	test   %eax,%eax
  801030:	74 0a                	je     80103c <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801032:	01 c3                	add    %eax,%ebx
  801034:	39 f3                	cmp    %esi,%ebx
  801036:	72 db                	jb     801013 <readn+0x16>
  801038:	89 d8                	mov    %ebx,%eax
  80103a:	eb 02                	jmp    80103e <readn+0x41>
  80103c:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80103e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801041:	5b                   	pop    %ebx
  801042:	5e                   	pop    %esi
  801043:	5f                   	pop    %edi
  801044:	5d                   	pop    %ebp
  801045:	c3                   	ret    

00801046 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	53                   	push   %ebx
  80104a:	83 ec 14             	sub    $0x14,%esp
  80104d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801050:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801053:	50                   	push   %eax
  801054:	53                   	push   %ebx
  801055:	e8 ad fc ff ff       	call   800d07 <fd_lookup>
  80105a:	83 c4 08             	add    $0x8,%esp
  80105d:	89 c2                	mov    %eax,%edx
  80105f:	85 c0                	test   %eax,%eax
  801061:	78 68                	js     8010cb <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801063:	83 ec 08             	sub    $0x8,%esp
  801066:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801069:	50                   	push   %eax
  80106a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106d:	ff 30                	pushl  (%eax)
  80106f:	e8 e9 fc ff ff       	call   800d5d <dev_lookup>
  801074:	83 c4 10             	add    $0x10,%esp
  801077:	85 c0                	test   %eax,%eax
  801079:	78 47                	js     8010c2 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80107b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80107e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801082:	75 21                	jne    8010a5 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801084:	a1 04 40 80 00       	mov    0x804004,%eax
  801089:	8b 40 48             	mov    0x48(%eax),%eax
  80108c:	83 ec 04             	sub    $0x4,%esp
  80108f:	53                   	push   %ebx
  801090:	50                   	push   %eax
  801091:	68 69 27 80 00       	push   $0x802769
  801096:	e8 1d f1 ff ff       	call   8001b8 <cprintf>
		return -E_INVAL;
  80109b:	83 c4 10             	add    $0x10,%esp
  80109e:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8010a3:	eb 26                	jmp    8010cb <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8010a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a8:	8b 52 0c             	mov    0xc(%edx),%edx
  8010ab:	85 d2                	test   %edx,%edx
  8010ad:	74 17                	je     8010c6 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8010af:	83 ec 04             	sub    $0x4,%esp
  8010b2:	ff 75 10             	pushl  0x10(%ebp)
  8010b5:	ff 75 0c             	pushl  0xc(%ebp)
  8010b8:	50                   	push   %eax
  8010b9:	ff d2                	call   *%edx
  8010bb:	89 c2                	mov    %eax,%edx
  8010bd:	83 c4 10             	add    $0x10,%esp
  8010c0:	eb 09                	jmp    8010cb <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010c2:	89 c2                	mov    %eax,%edx
  8010c4:	eb 05                	jmp    8010cb <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8010c6:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  8010cb:	89 d0                	mov    %edx,%eax
  8010cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010d0:	c9                   	leave  
  8010d1:	c3                   	ret    

008010d2 <seek>:

int
seek(int fdnum, off_t offset)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010d8:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8010db:	50                   	push   %eax
  8010dc:	ff 75 08             	pushl  0x8(%ebp)
  8010df:	e8 23 fc ff ff       	call   800d07 <fd_lookup>
  8010e4:	83 c4 08             	add    $0x8,%esp
  8010e7:	85 c0                	test   %eax,%eax
  8010e9:	78 0e                	js     8010f9 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8010eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f1:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8010f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010f9:	c9                   	leave  
  8010fa:	c3                   	ret    

008010fb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
  8010fe:	53                   	push   %ebx
  8010ff:	83 ec 14             	sub    $0x14,%esp
  801102:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801105:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801108:	50                   	push   %eax
  801109:	53                   	push   %ebx
  80110a:	e8 f8 fb ff ff       	call   800d07 <fd_lookup>
  80110f:	83 c4 08             	add    $0x8,%esp
  801112:	89 c2                	mov    %eax,%edx
  801114:	85 c0                	test   %eax,%eax
  801116:	78 65                	js     80117d <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801118:	83 ec 08             	sub    $0x8,%esp
  80111b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80111e:	50                   	push   %eax
  80111f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801122:	ff 30                	pushl  (%eax)
  801124:	e8 34 fc ff ff       	call   800d5d <dev_lookup>
  801129:	83 c4 10             	add    $0x10,%esp
  80112c:	85 c0                	test   %eax,%eax
  80112e:	78 44                	js     801174 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801130:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801133:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801137:	75 21                	jne    80115a <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801139:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80113e:	8b 40 48             	mov    0x48(%eax),%eax
  801141:	83 ec 04             	sub    $0x4,%esp
  801144:	53                   	push   %ebx
  801145:	50                   	push   %eax
  801146:	68 2c 27 80 00       	push   $0x80272c
  80114b:	e8 68 f0 ff ff       	call   8001b8 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801150:	83 c4 10             	add    $0x10,%esp
  801153:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801158:	eb 23                	jmp    80117d <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  80115a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80115d:	8b 52 18             	mov    0x18(%edx),%edx
  801160:	85 d2                	test   %edx,%edx
  801162:	74 14                	je     801178 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801164:	83 ec 08             	sub    $0x8,%esp
  801167:	ff 75 0c             	pushl  0xc(%ebp)
  80116a:	50                   	push   %eax
  80116b:	ff d2                	call   *%edx
  80116d:	89 c2                	mov    %eax,%edx
  80116f:	83 c4 10             	add    $0x10,%esp
  801172:	eb 09                	jmp    80117d <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801174:	89 c2                	mov    %eax,%edx
  801176:	eb 05                	jmp    80117d <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801178:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  80117d:	89 d0                	mov    %edx,%eax
  80117f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801182:	c9                   	leave  
  801183:	c3                   	ret    

00801184 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801184:	55                   	push   %ebp
  801185:	89 e5                	mov    %esp,%ebp
  801187:	53                   	push   %ebx
  801188:	83 ec 14             	sub    $0x14,%esp
  80118b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80118e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801191:	50                   	push   %eax
  801192:	ff 75 08             	pushl  0x8(%ebp)
  801195:	e8 6d fb ff ff       	call   800d07 <fd_lookup>
  80119a:	83 c4 08             	add    $0x8,%esp
  80119d:	89 c2                	mov    %eax,%edx
  80119f:	85 c0                	test   %eax,%eax
  8011a1:	78 58                	js     8011fb <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011a3:	83 ec 08             	sub    $0x8,%esp
  8011a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011a9:	50                   	push   %eax
  8011aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ad:	ff 30                	pushl  (%eax)
  8011af:	e8 a9 fb ff ff       	call   800d5d <dev_lookup>
  8011b4:	83 c4 10             	add    $0x10,%esp
  8011b7:	85 c0                	test   %eax,%eax
  8011b9:	78 37                	js     8011f2 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  8011bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011be:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8011c2:	74 32                	je     8011f6 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8011c4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8011c7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8011ce:	00 00 00 
	stat->st_isdir = 0;
  8011d1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8011d8:	00 00 00 
	stat->st_dev = dev;
  8011db:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8011e1:	83 ec 08             	sub    $0x8,%esp
  8011e4:	53                   	push   %ebx
  8011e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8011e8:	ff 50 14             	call   *0x14(%eax)
  8011eb:	89 c2                	mov    %eax,%edx
  8011ed:	83 c4 10             	add    $0x10,%esp
  8011f0:	eb 09                	jmp    8011fb <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011f2:	89 c2                	mov    %eax,%edx
  8011f4:	eb 05                	jmp    8011fb <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8011f6:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8011fb:	89 d0                	mov    %edx,%eax
  8011fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801200:	c9                   	leave  
  801201:	c3                   	ret    

00801202 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801202:	55                   	push   %ebp
  801203:	89 e5                	mov    %esp,%ebp
  801205:	56                   	push   %esi
  801206:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801207:	83 ec 08             	sub    $0x8,%esp
  80120a:	6a 00                	push   $0x0
  80120c:	ff 75 08             	pushl  0x8(%ebp)
  80120f:	e8 06 02 00 00       	call   80141a <open>
  801214:	89 c3                	mov    %eax,%ebx
  801216:	83 c4 10             	add    $0x10,%esp
  801219:	85 c0                	test   %eax,%eax
  80121b:	78 1b                	js     801238 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80121d:	83 ec 08             	sub    $0x8,%esp
  801220:	ff 75 0c             	pushl  0xc(%ebp)
  801223:	50                   	push   %eax
  801224:	e8 5b ff ff ff       	call   801184 <fstat>
  801229:	89 c6                	mov    %eax,%esi
	close(fd);
  80122b:	89 1c 24             	mov    %ebx,(%esp)
  80122e:	e8 fd fb ff ff       	call   800e30 <close>
	return r;
  801233:	83 c4 10             	add    $0x10,%esp
  801236:	89 f0                	mov    %esi,%eax
}
  801238:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80123b:	5b                   	pop    %ebx
  80123c:	5e                   	pop    %esi
  80123d:	5d                   	pop    %ebp
  80123e:	c3                   	ret    

0080123f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80123f:	55                   	push   %ebp
  801240:	89 e5                	mov    %esp,%ebp
  801242:	56                   	push   %esi
  801243:	53                   	push   %ebx
  801244:	89 c6                	mov    %eax,%esi
  801246:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801248:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80124f:	75 12                	jne    801263 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801251:	83 ec 0c             	sub    $0xc,%esp
  801254:	6a 01                	push   $0x1
  801256:	e8 e7 0d 00 00       	call   802042 <ipc_find_env>
  80125b:	a3 00 40 80 00       	mov    %eax,0x804000
  801260:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801263:	6a 07                	push   $0x7
  801265:	68 00 50 80 00       	push   $0x805000
  80126a:	56                   	push   %esi
  80126b:	ff 35 00 40 80 00    	pushl  0x804000
  801271:	e8 78 0d 00 00       	call   801fee <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801276:	83 c4 0c             	add    $0xc,%esp
  801279:	6a 00                	push   $0x0
  80127b:	53                   	push   %ebx
  80127c:	6a 00                	push   $0x0
  80127e:	e8 00 0d 00 00       	call   801f83 <ipc_recv>
}
  801283:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801286:	5b                   	pop    %ebx
  801287:	5e                   	pop    %esi
  801288:	5d                   	pop    %ebp
  801289:	c3                   	ret    

0080128a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	8b 40 0c             	mov    0xc(%eax),%eax
  801296:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80129b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8012a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8012a8:	b8 02 00 00 00       	mov    $0x2,%eax
  8012ad:	e8 8d ff ff ff       	call   80123f <fsipc>
}
  8012b2:	c9                   	leave  
  8012b3:	c3                   	ret    

008012b4 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8012c0:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8012c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8012ca:	b8 06 00 00 00       	mov    $0x6,%eax
  8012cf:	e8 6b ff ff ff       	call   80123f <fsipc>
}
  8012d4:	c9                   	leave  
  8012d5:	c3                   	ret    

008012d6 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
  8012d9:	53                   	push   %ebx
  8012da:	83 ec 04             	sub    $0x4,%esp
  8012dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8012e6:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8012eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8012f0:	b8 05 00 00 00       	mov    $0x5,%eax
  8012f5:	e8 45 ff ff ff       	call   80123f <fsipc>
  8012fa:	85 c0                	test   %eax,%eax
  8012fc:	78 2c                	js     80132a <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8012fe:	83 ec 08             	sub    $0x8,%esp
  801301:	68 00 50 80 00       	push   $0x805000
  801306:	53                   	push   %ebx
  801307:	e8 1e f4 ff ff       	call   80072a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80130c:	a1 80 50 80 00       	mov    0x805080,%eax
  801311:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801317:	a1 84 50 80 00       	mov    0x805084,%eax
  80131c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801322:	83 c4 10             	add    $0x10,%esp
  801325:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80132a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80132d:	c9                   	leave  
  80132e:	c3                   	ret    

0080132f <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
  801332:	83 ec 08             	sub    $0x8,%esp
  801335:	8b 55 0c             	mov    0xc(%ebp),%edx
  801338:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80133b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80133e:	8b 49 0c             	mov    0xc(%ecx),%ecx
  801341:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  801347:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80134c:	76 22                	jbe    801370 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  80134e:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  801355:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  801358:	83 ec 04             	sub    $0x4,%esp
  80135b:	68 f8 0f 00 00       	push   $0xff8
  801360:	52                   	push   %edx
  801361:	68 08 50 80 00       	push   $0x805008
  801366:	e8 52 f5 ff ff       	call   8008bd <memmove>
  80136b:	83 c4 10             	add    $0x10,%esp
  80136e:	eb 17                	jmp    801387 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  801370:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  801375:	83 ec 04             	sub    $0x4,%esp
  801378:	50                   	push   %eax
  801379:	52                   	push   %edx
  80137a:	68 08 50 80 00       	push   $0x805008
  80137f:	e8 39 f5 ff ff       	call   8008bd <memmove>
  801384:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  801387:	ba 00 00 00 00       	mov    $0x0,%edx
  80138c:	b8 04 00 00 00       	mov    $0x4,%eax
  801391:	e8 a9 fe ff ff       	call   80123f <fsipc>
	if (result < 0)
		return result;

	return result;
}
  801396:	c9                   	leave  
  801397:	c3                   	ret    

00801398 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	56                   	push   %esi
  80139c:	53                   	push   %ebx
  80139d:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8013a6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8013ab:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8013b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b6:	b8 03 00 00 00       	mov    $0x3,%eax
  8013bb:	e8 7f fe ff ff       	call   80123f <fsipc>
  8013c0:	89 c3                	mov    %eax,%ebx
  8013c2:	85 c0                	test   %eax,%eax
  8013c4:	78 4b                	js     801411 <devfile_read+0x79>
		return r;
	assert(r <= n);
  8013c6:	39 c6                	cmp    %eax,%esi
  8013c8:	73 16                	jae    8013e0 <devfile_read+0x48>
  8013ca:	68 98 27 80 00       	push   $0x802798
  8013cf:	68 9f 27 80 00       	push   $0x80279f
  8013d4:	6a 7c                	push   $0x7c
  8013d6:	68 b4 27 80 00       	push   $0x8027b4
  8013db:	e8 ff ec ff ff       	call   8000df <_panic>
	assert(r <= PGSIZE);
  8013e0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8013e5:	7e 16                	jle    8013fd <devfile_read+0x65>
  8013e7:	68 bf 27 80 00       	push   $0x8027bf
  8013ec:	68 9f 27 80 00       	push   $0x80279f
  8013f1:	6a 7d                	push   $0x7d
  8013f3:	68 b4 27 80 00       	push   $0x8027b4
  8013f8:	e8 e2 ec ff ff       	call   8000df <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8013fd:	83 ec 04             	sub    $0x4,%esp
  801400:	50                   	push   %eax
  801401:	68 00 50 80 00       	push   $0x805000
  801406:	ff 75 0c             	pushl  0xc(%ebp)
  801409:	e8 af f4 ff ff       	call   8008bd <memmove>
	return r;
  80140e:	83 c4 10             	add    $0x10,%esp
}
  801411:	89 d8                	mov    %ebx,%eax
  801413:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801416:	5b                   	pop    %ebx
  801417:	5e                   	pop    %esi
  801418:	5d                   	pop    %ebp
  801419:	c3                   	ret    

0080141a <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	53                   	push   %ebx
  80141e:	83 ec 20             	sub    $0x20,%esp
  801421:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801424:	53                   	push   %ebx
  801425:	e8 c7 f2 ff ff       	call   8006f1 <strlen>
  80142a:	83 c4 10             	add    $0x10,%esp
  80142d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801432:	7f 67                	jg     80149b <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801434:	83 ec 0c             	sub    $0xc,%esp
  801437:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143a:	50                   	push   %eax
  80143b:	e8 78 f8 ff ff       	call   800cb8 <fd_alloc>
  801440:	83 c4 10             	add    $0x10,%esp
		return r;
  801443:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801445:	85 c0                	test   %eax,%eax
  801447:	78 57                	js     8014a0 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801449:	83 ec 08             	sub    $0x8,%esp
  80144c:	53                   	push   %ebx
  80144d:	68 00 50 80 00       	push   $0x805000
  801452:	e8 d3 f2 ff ff       	call   80072a <strcpy>
	fsipcbuf.open.req_omode = mode;
  801457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145a:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80145f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801462:	b8 01 00 00 00       	mov    $0x1,%eax
  801467:	e8 d3 fd ff ff       	call   80123f <fsipc>
  80146c:	89 c3                	mov    %eax,%ebx
  80146e:	83 c4 10             	add    $0x10,%esp
  801471:	85 c0                	test   %eax,%eax
  801473:	79 14                	jns    801489 <open+0x6f>
		fd_close(fd, 0);
  801475:	83 ec 08             	sub    $0x8,%esp
  801478:	6a 00                	push   $0x0
  80147a:	ff 75 f4             	pushl  -0xc(%ebp)
  80147d:	e8 2e f9 ff ff       	call   800db0 <fd_close>
		return r;
  801482:	83 c4 10             	add    $0x10,%esp
  801485:	89 da                	mov    %ebx,%edx
  801487:	eb 17                	jmp    8014a0 <open+0x86>
	}

	return fd2num(fd);
  801489:	83 ec 0c             	sub    $0xc,%esp
  80148c:	ff 75 f4             	pushl  -0xc(%ebp)
  80148f:	e8 fc f7 ff ff       	call   800c90 <fd2num>
  801494:	89 c2                	mov    %eax,%edx
  801496:	83 c4 10             	add    $0x10,%esp
  801499:	eb 05                	jmp    8014a0 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80149b:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8014a0:	89 d0                	mov    %edx,%eax
  8014a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a5:	c9                   	leave  
  8014a6:	c3                   	ret    

008014a7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
  8014aa:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8014ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b2:	b8 08 00 00 00       	mov    $0x8,%eax
  8014b7:	e8 83 fd ff ff       	call   80123f <fsipc>
}
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    

008014be <copy_shared_pages>:
}

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	57                   	push   %edi
  8014c2:	56                   	push   %esi
  8014c3:	53                   	push   %ebx
  8014c4:	83 ec 1c             	sub    $0x1c,%esp
  8014c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8014ca:	bf 00 04 00 00       	mov    $0x400,%edi
	// LAB 5: Your code here.
	unsigned int pn;
	void* addr;
  	for (int i = 0; i < NPDENTRIES; ++i) {
  8014cf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8014d6:	eb 7d                	jmp    801555 <copy_shared_pages+0x97>
	    for (int j = 0; j < NPTENTRIES; ++j) {
    	  pn = i*NPDENTRIES + j;
    	  addr = (void*) (pn*PGSIZE);
      	  if ((pn < (UTOP >> PGSHIFT)) && uvpd[i]) {
  8014d8:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  8014de:	77 54                	ja     801534 <copy_shared_pages+0x76>
  8014e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014e3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	74 46                	je     801534 <copy_shared_pages+0x76>
        	if (uvpt[pn] & PTE_SHARE) {
  8014ee:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8014f5:	f6 c4 04             	test   $0x4,%ah
  8014f8:	74 3a                	je     801534 <copy_shared_pages+0x76>
          		if (sys_page_map(0, addr, child, addr, uvpt[pn] & PTE_SYSCALL) < 0) {
  8014fa:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801501:	83 ec 0c             	sub    $0xc,%esp
  801504:	25 07 0e 00 00       	and    $0xe07,%eax
  801509:	50                   	push   %eax
  80150a:	56                   	push   %esi
  80150b:	ff 75 e0             	pushl  -0x20(%ebp)
  80150e:	56                   	push   %esi
  80150f:	6a 00                	push   $0x0
  801511:	e8 81 f6 ff ff       	call   800b97 <sys_page_map>
  801516:	83 c4 20             	add    $0x20,%esp
  801519:	85 c0                	test   %eax,%eax
  80151b:	79 17                	jns    801534 <copy_shared_pages+0x76>
              		panic("Error en sys_page_map");
  80151d:	83 ec 04             	sub    $0x4,%esp
  801520:	68 cb 27 80 00       	push   $0x8027cb
  801525:	68 4f 01 00 00       	push   $0x14f
  80152a:	68 e1 27 80 00       	push   $0x8027e1
  80152f:	e8 ab eb ff ff       	call   8000df <_panic>
  801534:	83 c3 01             	add    $0x1,%ebx
  801537:	81 c6 00 10 00 00    	add    $0x1000,%esi
{
	// LAB 5: Your code here.
	unsigned int pn;
	void* addr;
  	for (int i = 0; i < NPDENTRIES; ++i) {
	    for (int j = 0; j < NPTENTRIES; ++j) {
  80153d:	39 fb                	cmp    %edi,%ebx
  80153f:	75 97                	jne    8014d8 <copy_shared_pages+0x1a>
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	unsigned int pn;
	void* addr;
  	for (int i = 0; i < NPDENTRIES; ++i) {
  801541:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  801545:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801548:	81 c7 00 04 00 00    	add    $0x400,%edi
  80154e:	3d 00 04 00 00       	cmp    $0x400,%eax
  801553:	74 10                	je     801565 <copy_shared_pages+0xa7>
  801555:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801558:	89 f3                	mov    %esi,%ebx
  80155a:	c1 e3 0a             	shl    $0xa,%ebx
  80155d:	c1 e6 16             	shl    $0x16,%esi
  801560:	e9 73 ff ff ff       	jmp    8014d8 <copy_shared_pages+0x1a>
        	} 
      	  }
    	}
	}
	return 0;
}
  801565:	b8 00 00 00 00       	mov    $0x0,%eax
  80156a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80156d:	5b                   	pop    %ebx
  80156e:	5e                   	pop    %esi
  80156f:	5f                   	pop    %edi
  801570:	5d                   	pop    %ebp
  801571:	c3                   	ret    

00801572 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
  801575:	57                   	push   %edi
  801576:	56                   	push   %esi
  801577:	53                   	push   %ebx
  801578:	83 ec 2c             	sub    $0x2c,%esp
  80157b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80157e:	89 55 d0             	mov    %edx,-0x30(%ebp)
  801581:	89 4d cc             	mov    %ecx,-0x34(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801584:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801589:	be 00 00 00 00       	mov    $0x0,%esi
  80158e:	89 d7                	mov    %edx,%edi
	for (argc = 0; argv[argc] != 0; argc++)
  801590:	eb 13                	jmp    8015a5 <init_stack+0x33>
		string_size += strlen(argv[argc]) + 1;
  801592:	83 ec 0c             	sub    $0xc,%esp
  801595:	50                   	push   %eax
  801596:	e8 56 f1 ff ff       	call   8006f1 <strlen>
  80159b:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80159f:	83 c3 01             	add    $0x1,%ebx
  8015a2:	83 c4 10             	add    $0x10,%esp
  8015a5:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8015ac:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8015af:	85 c0                	test   %eax,%eax
  8015b1:	75 df                	jne    801592 <init_stack+0x20>
  8015b3:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  8015b6:	89 4d d8             	mov    %ecx,-0x28(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char *) UTEMP + PGSIZE - string_size;
  8015b9:	bf 00 10 40 00       	mov    $0x401000,%edi
  8015be:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t *) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8015c0:	89 fa                	mov    %edi,%edx
  8015c2:	83 e2 fc             	and    $0xfffffffc,%edx
  8015c5:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8015cc:	29 c2                	sub    %eax,%edx
  8015ce:	89 55 e4             	mov    %edx,-0x1c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void *) (argv_store - 2) < (void *) UTEMP)
  8015d1:	8d 42 f8             	lea    -0x8(%edx),%eax
  8015d4:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8015d9:	0f 86 fc 00 00 00    	jbe    8016db <init_stack+0x169>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void *) UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  8015df:	83 ec 04             	sub    $0x4,%esp
  8015e2:	6a 07                	push   $0x7
  8015e4:	68 00 00 40 00       	push   $0x400000
  8015e9:	6a 00                	push   $0x0
  8015eb:	e8 83 f5 ff ff       	call   800b73 <sys_page_alloc>
  8015f0:	83 c4 10             	add    $0x10,%esp
  8015f3:	85 c0                	test   %eax,%eax
  8015f5:	0f 88 e5 00 00 00    	js     8016e0 <init_stack+0x16e>
  8015fb:	be 00 00 00 00       	mov    $0x0,%esi
  801600:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  801603:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  801606:	eb 2d                	jmp    801635 <init_stack+0xc3>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  801608:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  80160e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801611:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801614:	83 ec 08             	sub    $0x8,%esp
  801617:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80161a:	57                   	push   %edi
  80161b:	e8 0a f1 ff ff       	call   80072a <strcpy>
		string_store += strlen(argv[i]) + 1;
  801620:	83 c4 04             	add    $0x4,%esp
  801623:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801626:	e8 c6 f0 ff ff       	call   8006f1 <strlen>
  80162b:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80162f:	83 c6 01             	add    $0x1,%esi
  801632:	83 c4 10             	add    $0x10,%esp
  801635:	39 75 e0             	cmp    %esi,-0x20(%ebp)
  801638:	7f ce                	jg     801608 <init_stack+0x96>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  80163a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80163d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  801640:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char *) UTEMP + PGSIZE);
  801647:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80164d:	74 19                	je     801668 <init_stack+0xf6>
  80164f:	68 6c 28 80 00       	push   $0x80286c
  801654:	68 9f 27 80 00       	push   $0x80279f
  801659:	68 fc 00 00 00       	push   $0xfc
  80165e:	68 e1 27 80 00       	push   $0x8027e1
  801663:	e8 77 ea ff ff       	call   8000df <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801668:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80166b:	89 d0                	mov    %edx,%eax
  80166d:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801672:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801675:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801678:	89 42 f8             	mov    %eax,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80167b:	8d 82 f8 cf 7f ee    	lea    -0x11803008(%edx),%eax
  801681:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  801684:	89 01                	mov    %eax,(%ecx)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0,
  801686:	83 ec 0c             	sub    $0xc,%esp
  801689:	6a 07                	push   $0x7
  80168b:	68 00 d0 bf ee       	push   $0xeebfd000
  801690:	ff 75 d4             	pushl  -0x2c(%ebp)
  801693:	68 00 00 40 00       	push   $0x400000
  801698:	6a 00                	push   $0x0
  80169a:	e8 f8 f4 ff ff       	call   800b97 <sys_page_map>
  80169f:	89 c3                	mov    %eax,%ebx
  8016a1:	83 c4 20             	add    $0x20,%esp
  8016a4:	85 c0                	test   %eax,%eax
  8016a6:	78 1d                	js     8016c5 <init_stack+0x153>
	                      UTEMP,
	                      child,
	                      (void *) (USTACKTOP - PGSIZE),
	                      PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8016a8:	83 ec 08             	sub    $0x8,%esp
  8016ab:	68 00 00 40 00       	push   $0x400000
  8016b0:	6a 00                	push   $0x0
  8016b2:	e8 06 f5 ff ff       	call   800bbd <sys_page_unmap>
  8016b7:	89 c3                	mov    %eax,%ebx
  8016b9:	83 c4 10             	add    $0x10,%esp
		goto error;

	return 0;
  8016bc:	b8 00 00 00 00       	mov    $0x0,%eax
	                      UTEMP,
	                      child,
	                      (void *) (USTACKTOP - PGSIZE),
	                      PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8016c1:	85 db                	test   %ebx,%ebx
  8016c3:	79 1b                	jns    8016e0 <init_stack+0x16e>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  8016c5:	83 ec 08             	sub    $0x8,%esp
  8016c8:	68 00 00 40 00       	push   $0x400000
  8016cd:	6a 00                	push   $0x0
  8016cf:	e8 e9 f4 ff ff       	call   800bbd <sys_page_unmap>
	return r;
  8016d4:	83 c4 10             	add    $0x10,%esp
  8016d7:	89 d8                	mov    %ebx,%eax
  8016d9:	eb 05                	jmp    8016e0 <init_stack+0x16e>
	argv_store = (uintptr_t *) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void *) (argv_store - 2) < (void *) UTEMP)
		return -E_NO_MEM;
  8016db:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return 0;

error:
	sys_page_unmap(0, UTEMP);
	return r;
}
  8016e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016e3:	5b                   	pop    %ebx
  8016e4:	5e                   	pop    %esi
  8016e5:	5f                   	pop    %edi
  8016e6:	5d                   	pop    %ebp
  8016e7:	c3                   	ret    

008016e8 <map_segment>:
            size_t memsz,
            int fd,
            size_t filesz,
            off_t fileoffset,
            int perm)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	57                   	push   %edi
  8016ec:	56                   	push   %esi
  8016ed:	53                   	push   %ebx
  8016ee:	83 ec 1c             	sub    $0x1c,%esp
  8016f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8016f4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	int i, r;
	void *blk;

	// cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8016f7:	89 d0                	mov    %edx,%eax
  8016f9:	25 ff 0f 00 00       	and    $0xfff,%eax
  8016fe:	74 0d                	je     80170d <map_segment+0x25>
		va -= i;
  801700:	29 c2                	sub    %eax,%edx
		memsz += i;
  801702:	01 c1                	add    %eax,%ecx
  801704:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		filesz += i;
  801707:	01 45 0c             	add    %eax,0xc(%ebp)
		fileoffset -= i;
  80170a:	29 45 10             	sub    %eax,0x10(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80170d:	89 d6                	mov    %edx,%esi
  80170f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801714:	e9 d6 00 00 00       	jmp    8017ef <map_segment+0x107>
		if (i >= filesz) {
  801719:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
  80171c:	77 1f                	ja     80173d <map_segment+0x55>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void *) (va + i), perm)) < 0)
  80171e:	83 ec 04             	sub    $0x4,%esp
  801721:	ff 75 14             	pushl  0x14(%ebp)
  801724:	56                   	push   %esi
  801725:	ff 75 e0             	pushl  -0x20(%ebp)
  801728:	e8 46 f4 ff ff       	call   800b73 <sys_page_alloc>
  80172d:	83 c4 10             	add    $0x10,%esp
  801730:	85 c0                	test   %eax,%eax
  801732:	0f 89 ab 00 00 00    	jns    8017e3 <map_segment+0xfb>
  801738:	e9 c2 00 00 00       	jmp    8017ff <map_segment+0x117>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W)) <
  80173d:	83 ec 04             	sub    $0x4,%esp
  801740:	6a 07                	push   $0x7
  801742:	68 00 00 40 00       	push   $0x400000
  801747:	6a 00                	push   $0x0
  801749:	e8 25 f4 ff ff       	call   800b73 <sys_page_alloc>
  80174e:	83 c4 10             	add    $0x10,%esp
  801751:	85 c0                	test   %eax,%eax
  801753:	0f 88 a6 00 00 00    	js     8017ff <map_segment+0x117>
			    0)
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801759:	83 ec 08             	sub    $0x8,%esp
  80175c:	89 f8                	mov    %edi,%eax
  80175e:	03 45 10             	add    0x10(%ebp),%eax
  801761:	50                   	push   %eax
  801762:	ff 75 08             	pushl  0x8(%ebp)
  801765:	e8 68 f9 ff ff       	call   8010d2 <seek>
  80176a:	83 c4 10             	add    $0x10,%esp
  80176d:	85 c0                	test   %eax,%eax
  80176f:	0f 88 8a 00 00 00    	js     8017ff <map_segment+0x117>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz - i))) < 0)
  801775:	83 ec 04             	sub    $0x4,%esp
  801778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177b:	29 f8                	sub    %edi,%eax
  80177d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801782:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801787:	0f 47 c1             	cmova  %ecx,%eax
  80178a:	50                   	push   %eax
  80178b:	68 00 00 40 00       	push   $0x400000
  801790:	ff 75 08             	pushl  0x8(%ebp)
  801793:	e8 65 f8 ff ff       	call   800ffd <readn>
  801798:	83 c4 10             	add    $0x10,%esp
  80179b:	85 c0                	test   %eax,%eax
  80179d:	78 60                	js     8017ff <map_segment+0x117>
				return r;
			if ((r = sys_page_map(
  80179f:	83 ec 0c             	sub    $0xc,%esp
  8017a2:	ff 75 14             	pushl  0x14(%ebp)
  8017a5:	56                   	push   %esi
  8017a6:	ff 75 e0             	pushl  -0x20(%ebp)
  8017a9:	68 00 00 40 00       	push   $0x400000
  8017ae:	6a 00                	push   $0x0
  8017b0:	e8 e2 f3 ff ff       	call   800b97 <sys_page_map>
  8017b5:	83 c4 20             	add    $0x20,%esp
  8017b8:	85 c0                	test   %eax,%eax
  8017ba:	79 15                	jns    8017d1 <map_segment+0xe9>
			             0, UTEMP, child, (void *) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
  8017bc:	50                   	push   %eax
  8017bd:	68 ed 27 80 00       	push   $0x8027ed
  8017c2:	68 3a 01 00 00       	push   $0x13a
  8017c7:	68 e1 27 80 00       	push   $0x8027e1
  8017cc:	e8 0e e9 ff ff       	call   8000df <_panic>
			sys_page_unmap(0, UTEMP);
  8017d1:	83 ec 08             	sub    $0x8,%esp
  8017d4:	68 00 00 40 00       	push   $0x400000
  8017d9:	6a 00                	push   $0x0
  8017db:	e8 dd f3 ff ff       	call   800bbd <sys_page_unmap>
  8017e0:	83 c4 10             	add    $0x10,%esp
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8017e3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8017e9:	81 c6 00 10 00 00    	add    $0x1000,%esi
  8017ef:	89 df                	mov    %ebx,%edi
  8017f1:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
  8017f4:	0f 87 1f ff ff ff    	ja     801719 <map_segment+0x31>
			             0, UTEMP, child, (void *) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  8017fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801802:	5b                   	pop    %ebx
  801803:	5e                   	pop    %esi
  801804:	5f                   	pop    %edi
  801805:	5d                   	pop    %ebp
  801806:	c3                   	ret    

00801807 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	57                   	push   %edi
  80180b:	56                   	push   %esi
  80180c:	53                   	push   %ebx
  80180d:	81 ec 74 02 00 00    	sub    $0x274,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801813:	6a 00                	push   $0x0
  801815:	ff 75 08             	pushl  0x8(%ebp)
  801818:	e8 fd fb ff ff       	call   80141a <open>
  80181d:	89 c7                	mov    %eax,%edi
  80181f:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801825:	83 c4 10             	add    $0x10,%esp
  801828:	85 c0                	test   %eax,%eax
  80182a:	0f 88 e3 01 00 00    	js     801a13 <spawn+0x20c>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf *) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf) ||
  801830:	83 ec 04             	sub    $0x4,%esp
  801833:	68 00 02 00 00       	push   $0x200
  801838:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80183e:	50                   	push   %eax
  80183f:	57                   	push   %edi
  801840:	e8 b8 f7 ff ff       	call   800ffd <readn>
  801845:	83 c4 10             	add    $0x10,%esp
  801848:	3d 00 02 00 00       	cmp    $0x200,%eax
  80184d:	75 0c                	jne    80185b <spawn+0x54>
  80184f:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801856:	45 4c 46 
  801859:	74 33                	je     80188e <spawn+0x87>
	    elf->e_magic != ELF_MAGIC) {
		close(fd);
  80185b:	83 ec 0c             	sub    $0xc,%esp
  80185e:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801864:	e8 c7 f5 ff ff       	call   800e30 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801869:	83 c4 0c             	add    $0xc,%esp
  80186c:	68 7f 45 4c 46       	push   $0x464c457f
  801871:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801877:	68 0a 28 80 00       	push   $0x80280a
  80187c:	e8 37 e9 ff ff       	call   8001b8 <cprintf>
		return -E_NOT_EXEC;
  801881:	83 c4 10             	add    $0x10,%esp
  801884:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801889:	e9 9b 01 00 00       	jmp    801a29 <spawn+0x222>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80188e:	b8 07 00 00 00       	mov    $0x7,%eax
  801893:	cd 30                	int    $0x30
  801895:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  80189b:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8018a1:	89 c3                	mov    %eax,%ebx
  8018a3:	85 c0                	test   %eax,%eax
  8018a5:	0f 88 70 01 00 00    	js     801a1b <spawn+0x214>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8018ab:	89 c6                	mov    %eax,%esi
  8018ad:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  8018b3:	6b f6 7c             	imul   $0x7c,%esi,%esi
  8018b6:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8018bc:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8018c2:	b9 11 00 00 00       	mov    $0x11,%ecx
  8018c7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8018c9:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8018cf:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
  8018d5:	8d 8d e0 fd ff ff    	lea    -0x220(%ebp),%ecx
  8018db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018de:	89 d8                	mov    %ebx,%eax
  8018e0:	e8 8d fc ff ff       	call   801572 <init_stack>
  8018e5:	85 c0                	test   %eax,%eax
  8018e7:	0f 88 3c 01 00 00    	js     801a29 <spawn+0x222>
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr *) (elf_buf + elf->e_phoff);
  8018ed:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8018f3:	8d 9c 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%ebx
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8018fa:	be 00 00 00 00       	mov    $0x0,%esi
  8018ff:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  801905:	eb 40                	jmp    801947 <spawn+0x140>
		if (ph->p_type != ELF_PROG_LOAD)
  801907:	83 3b 01             	cmpl   $0x1,(%ebx)
  80190a:	75 35                	jne    801941 <spawn+0x13a>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80190c:	8b 43 18             	mov    0x18(%ebx),%eax
  80190f:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801912:	83 f8 01             	cmp    $0x1,%eax
  801915:	19 c0                	sbb    %eax,%eax
  801917:	83 e0 fe             	and    $0xfffffffe,%eax
  80191a:	83 c0 07             	add    $0x7,%eax
		if ((r = map_segment(child,
  80191d:	8b 4b 14             	mov    0x14(%ebx),%ecx
  801920:	8b 53 08             	mov    0x8(%ebx),%edx
  801923:	50                   	push   %eax
  801924:	ff 73 04             	pushl  0x4(%ebx)
  801927:	ff 73 10             	pushl  0x10(%ebx)
  80192a:	57                   	push   %edi
  80192b:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801931:	e8 b2 fd ff ff       	call   8016e8 <map_segment>
  801936:	83 c4 10             	add    $0x10,%esp
  801939:	85 c0                	test   %eax,%eax
  80193b:	0f 88 ad 00 00 00    	js     8019ee <spawn+0x1e7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr *) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801941:	83 c6 01             	add    $0x1,%esi
  801944:	83 c3 20             	add    $0x20,%ebx
  801947:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  80194e:	39 c6                	cmp    %eax,%esi
  801950:	7c b5                	jl     801907 <spawn+0x100>
		                     ph->p_filesz,
		                     ph->p_offset,
		                     perm)) < 0)
			goto error;
	}
	close(fd);
  801952:	83 ec 0c             	sub    $0xc,%esp
  801955:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80195b:	e8 d0 f4 ff ff       	call   800e30 <close>
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  801960:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801966:	e8 53 fb ff ff       	call   8014be <copy_shared_pages>
  80196b:	83 c4 10             	add    $0x10,%esp
  80196e:	85 c0                	test   %eax,%eax
  801970:	79 15                	jns    801987 <spawn+0x180>
		panic("copy_shared_pages: %e", r);
  801972:	50                   	push   %eax
  801973:	68 24 28 80 00       	push   $0x802824
  801978:	68 8c 00 00 00       	push   $0x8c
  80197d:	68 e1 27 80 00       	push   $0x8027e1
  801982:	e8 58 e7 ff ff       	call   8000df <_panic>

	child_tf.tf_eflags |= FL_IOPL_3;  // devious: see user/faultio.c
  801987:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  80198e:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801991:	83 ec 08             	sub    $0x8,%esp
  801994:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  80199a:	50                   	push   %eax
  80199b:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8019a1:	e8 5d f2 ff ff       	call   800c03 <sys_env_set_trapframe>
  8019a6:	83 c4 10             	add    $0x10,%esp
  8019a9:	85 c0                	test   %eax,%eax
  8019ab:	79 15                	jns    8019c2 <spawn+0x1bb>
		panic("sys_env_set_trapframe: %e", r);
  8019ad:	50                   	push   %eax
  8019ae:	68 3a 28 80 00       	push   $0x80283a
  8019b3:	68 90 00 00 00       	push   $0x90
  8019b8:	68 e1 27 80 00       	push   $0x8027e1
  8019bd:	e8 1d e7 ff ff       	call   8000df <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8019c2:	83 ec 08             	sub    $0x8,%esp
  8019c5:	6a 02                	push   $0x2
  8019c7:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8019cd:	e8 0e f2 ff ff       	call   800be0 <sys_env_set_status>
  8019d2:	83 c4 10             	add    $0x10,%esp
  8019d5:	85 c0                	test   %eax,%eax
  8019d7:	79 4a                	jns    801a23 <spawn+0x21c>
		panic("sys_env_set_status: %e", r);
  8019d9:	50                   	push   %eax
  8019da:	68 54 28 80 00       	push   $0x802854
  8019df:	68 93 00 00 00       	push   $0x93
  8019e4:	68 e1 27 80 00       	push   $0x8027e1
  8019e9:	e8 f1 e6 ff ff       	call   8000df <_panic>
  8019ee:	89 c7                	mov    %eax,%edi

	return child;

error:
	sys_env_destroy(child);
  8019f0:	83 ec 0c             	sub    $0xc,%esp
  8019f3:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8019f9:	e8 08 f1 ff ff       	call   800b06 <sys_env_destroy>
	close(fd);
  8019fe:	83 c4 04             	add    $0x4,%esp
  801a01:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801a07:	e8 24 f4 ff ff       	call   800e30 <close>
	return r;
  801a0c:	83 c4 10             	add    $0x10,%esp
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child,
  801a0f:	89 f8                	mov    %edi,%eax
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  801a11:	eb 16                	jmp    801a29 <spawn+0x222>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  801a13:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801a19:	eb 0e                	jmp    801a29 <spawn+0x222>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  801a1b:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801a21:	eb 06                	jmp    801a29 <spawn+0x222>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  801a23:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  801a29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a2c:	5b                   	pop    %ebx
  801a2d:	5e                   	pop    %esi
  801a2e:	5f                   	pop    %edi
  801a2f:	5d                   	pop    %ebp
  801a30:	c3                   	ret    

00801a31 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	56                   	push   %esi
  801a35:	53                   	push   %ebx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc = 0;
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  801a36:	8d 55 10             	lea    0x10(%ebp),%edx
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc = 0;
  801a39:	b8 00 00 00 00       	mov    $0x0,%eax
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  801a3e:	eb 03                	jmp    801a43 <spawnl+0x12>
		argc++;
  801a40:	83 c0 01             	add    $0x1,%eax
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc = 0;
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  801a43:	83 c2 04             	add    $0x4,%edx
  801a46:	83 7a fc 00          	cmpl   $0x0,-0x4(%edx)
  801a4a:	75 f4                	jne    801a40 <spawnl+0xf>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc + 2];
  801a4c:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  801a53:	83 e2 f0             	and    $0xfffffff0,%edx
  801a56:	29 d4                	sub    %edx,%esp
  801a58:	8d 54 24 03          	lea    0x3(%esp),%edx
  801a5c:	c1 ea 02             	shr    $0x2,%edx
  801a5f:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801a66:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801a68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a6b:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc + 1] = NULL;
  801a72:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801a79:	00 
  801a7a:	89 c2                	mov    %eax,%edx

	va_start(vl, arg0);
	unsigned i;
	for (i = 0; i < argc; i++)
  801a7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a81:	eb 0a                	jmp    801a8d <spawnl+0x5c>
		argv[i + 1] = va_arg(vl, const char *);
  801a83:	83 c0 01             	add    $0x1,%eax
  801a86:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  801a8a:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc + 1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for (i = 0; i < argc; i++)
  801a8d:	39 d0                	cmp    %edx,%eax
  801a8f:	75 f2                	jne    801a83 <spawnl+0x52>
		argv[i + 1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  801a91:	83 ec 08             	sub    $0x8,%esp
  801a94:	56                   	push   %esi
  801a95:	ff 75 08             	pushl  0x8(%ebp)
  801a98:	e8 6a fd ff ff       	call   801807 <spawn>
}
  801a9d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aa0:	5b                   	pop    %ebx
  801aa1:	5e                   	pop    %esi
  801aa2:	5d                   	pop    %ebp
  801aa3:	c3                   	ret    

00801aa4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	56                   	push   %esi
  801aa8:	53                   	push   %ebx
  801aa9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801aac:	83 ec 0c             	sub    $0xc,%esp
  801aaf:	ff 75 08             	pushl  0x8(%ebp)
  801ab2:	e8 e9 f1 ff ff       	call   800ca0 <fd2data>
  801ab7:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ab9:	83 c4 08             	add    $0x8,%esp
  801abc:	68 94 28 80 00       	push   $0x802894
  801ac1:	53                   	push   %ebx
  801ac2:	e8 63 ec ff ff       	call   80072a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ac7:	8b 46 04             	mov    0x4(%esi),%eax
  801aca:	2b 06                	sub    (%esi),%eax
  801acc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ad2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ad9:	00 00 00 
	stat->st_dev = &devpipe;
  801adc:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801ae3:	30 80 00 
	return 0;
}
  801ae6:	b8 00 00 00 00       	mov    $0x0,%eax
  801aeb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aee:	5b                   	pop    %ebx
  801aef:	5e                   	pop    %esi
  801af0:	5d                   	pop    %ebp
  801af1:	c3                   	ret    

00801af2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
  801af5:	53                   	push   %ebx
  801af6:	83 ec 0c             	sub    $0xc,%esp
  801af9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801afc:	53                   	push   %ebx
  801afd:	6a 00                	push   $0x0
  801aff:	e8 b9 f0 ff ff       	call   800bbd <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b04:	89 1c 24             	mov    %ebx,(%esp)
  801b07:	e8 94 f1 ff ff       	call   800ca0 <fd2data>
  801b0c:	83 c4 08             	add    $0x8,%esp
  801b0f:	50                   	push   %eax
  801b10:	6a 00                	push   $0x0
  801b12:	e8 a6 f0 ff ff       	call   800bbd <sys_page_unmap>
}
  801b17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	57                   	push   %edi
  801b20:	56                   	push   %esi
  801b21:	53                   	push   %ebx
  801b22:	83 ec 1c             	sub    $0x1c,%esp
  801b25:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801b28:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801b2a:	a1 04 40 80 00       	mov    0x804004,%eax
  801b2f:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801b32:	83 ec 0c             	sub    $0xc,%esp
  801b35:	ff 75 e0             	pushl  -0x20(%ebp)
  801b38:	e8 3e 05 00 00       	call   80207b <pageref>
  801b3d:	89 c3                	mov    %eax,%ebx
  801b3f:	89 3c 24             	mov    %edi,(%esp)
  801b42:	e8 34 05 00 00       	call   80207b <pageref>
  801b47:	83 c4 10             	add    $0x10,%esp
  801b4a:	39 c3                	cmp    %eax,%ebx
  801b4c:	0f 94 c1             	sete   %cl
  801b4f:	0f b6 c9             	movzbl %cl,%ecx
  801b52:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801b55:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b5b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b5e:	39 ce                	cmp    %ecx,%esi
  801b60:	74 1b                	je     801b7d <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801b62:	39 c3                	cmp    %eax,%ebx
  801b64:	75 c4                	jne    801b2a <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b66:	8b 42 58             	mov    0x58(%edx),%eax
  801b69:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b6c:	50                   	push   %eax
  801b6d:	56                   	push   %esi
  801b6e:	68 9b 28 80 00       	push   $0x80289b
  801b73:	e8 40 e6 ff ff       	call   8001b8 <cprintf>
  801b78:	83 c4 10             	add    $0x10,%esp
  801b7b:	eb ad                	jmp    801b2a <_pipeisclosed+0xe>
	}
}
  801b7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b83:	5b                   	pop    %ebx
  801b84:	5e                   	pop    %esi
  801b85:	5f                   	pop    %edi
  801b86:	5d                   	pop    %ebp
  801b87:	c3                   	ret    

00801b88 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
  801b8b:	57                   	push   %edi
  801b8c:	56                   	push   %esi
  801b8d:	53                   	push   %ebx
  801b8e:	83 ec 28             	sub    $0x28,%esp
  801b91:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801b94:	56                   	push   %esi
  801b95:	e8 06 f1 ff ff       	call   800ca0 <fd2data>
  801b9a:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b9c:	83 c4 10             	add    $0x10,%esp
  801b9f:	bf 00 00 00 00       	mov    $0x0,%edi
  801ba4:	eb 4b                	jmp    801bf1 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801ba6:	89 da                	mov    %ebx,%edx
  801ba8:	89 f0                	mov    %esi,%eax
  801baa:	e8 6d ff ff ff       	call   801b1c <_pipeisclosed>
  801baf:	85 c0                	test   %eax,%eax
  801bb1:	75 48                	jne    801bfb <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801bb3:	e8 94 ef ff ff       	call   800b4c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bb8:	8b 43 04             	mov    0x4(%ebx),%eax
  801bbb:	8b 0b                	mov    (%ebx),%ecx
  801bbd:	8d 51 20             	lea    0x20(%ecx),%edx
  801bc0:	39 d0                	cmp    %edx,%eax
  801bc2:	73 e2                	jae    801ba6 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bc7:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801bcb:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801bce:	89 c2                	mov    %eax,%edx
  801bd0:	c1 fa 1f             	sar    $0x1f,%edx
  801bd3:	89 d1                	mov    %edx,%ecx
  801bd5:	c1 e9 1b             	shr    $0x1b,%ecx
  801bd8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801bdb:	83 e2 1f             	and    $0x1f,%edx
  801bde:	29 ca                	sub    %ecx,%edx
  801be0:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801be4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801be8:	83 c0 01             	add    $0x1,%eax
  801beb:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801bee:	83 c7 01             	add    $0x1,%edi
  801bf1:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bf4:	75 c2                	jne    801bb8 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801bf6:	8b 45 10             	mov    0x10(%ebp),%eax
  801bf9:	eb 05                	jmp    801c00 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801bfb:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c03:	5b                   	pop    %ebx
  801c04:	5e                   	pop    %esi
  801c05:	5f                   	pop    %edi
  801c06:	5d                   	pop    %ebp
  801c07:	c3                   	ret    

00801c08 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
  801c0b:	57                   	push   %edi
  801c0c:	56                   	push   %esi
  801c0d:	53                   	push   %ebx
  801c0e:	83 ec 18             	sub    $0x18,%esp
  801c11:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801c14:	57                   	push   %edi
  801c15:	e8 86 f0 ff ff       	call   800ca0 <fd2data>
  801c1a:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c1c:	83 c4 10             	add    $0x10,%esp
  801c1f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c24:	eb 3d                	jmp    801c63 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801c26:	85 db                	test   %ebx,%ebx
  801c28:	74 04                	je     801c2e <devpipe_read+0x26>
				return i;
  801c2a:	89 d8                	mov    %ebx,%eax
  801c2c:	eb 44                	jmp    801c72 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801c2e:	89 f2                	mov    %esi,%edx
  801c30:	89 f8                	mov    %edi,%eax
  801c32:	e8 e5 fe ff ff       	call   801b1c <_pipeisclosed>
  801c37:	85 c0                	test   %eax,%eax
  801c39:	75 32                	jne    801c6d <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801c3b:	e8 0c ef ff ff       	call   800b4c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801c40:	8b 06                	mov    (%esi),%eax
  801c42:	3b 46 04             	cmp    0x4(%esi),%eax
  801c45:	74 df                	je     801c26 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c47:	99                   	cltd   
  801c48:	c1 ea 1b             	shr    $0x1b,%edx
  801c4b:	01 d0                	add    %edx,%eax
  801c4d:	83 e0 1f             	and    $0x1f,%eax
  801c50:	29 d0                	sub    %edx,%eax
  801c52:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801c57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c5a:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801c5d:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c60:	83 c3 01             	add    $0x1,%ebx
  801c63:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801c66:	75 d8                	jne    801c40 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801c68:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6b:	eb 05                	jmp    801c72 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801c6d:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801c72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c75:	5b                   	pop    %ebx
  801c76:	5e                   	pop    %esi
  801c77:	5f                   	pop    %edi
  801c78:	5d                   	pop    %ebp
  801c79:	c3                   	ret    

00801c7a <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	56                   	push   %esi
  801c7e:	53                   	push   %ebx
  801c7f:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801c82:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c85:	50                   	push   %eax
  801c86:	e8 2d f0 ff ff       	call   800cb8 <fd_alloc>
  801c8b:	83 c4 10             	add    $0x10,%esp
  801c8e:	89 c2                	mov    %eax,%edx
  801c90:	85 c0                	test   %eax,%eax
  801c92:	0f 88 2c 01 00 00    	js     801dc4 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c98:	83 ec 04             	sub    $0x4,%esp
  801c9b:	68 07 04 00 00       	push   $0x407
  801ca0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca3:	6a 00                	push   $0x0
  801ca5:	e8 c9 ee ff ff       	call   800b73 <sys_page_alloc>
  801caa:	83 c4 10             	add    $0x10,%esp
  801cad:	89 c2                	mov    %eax,%edx
  801caf:	85 c0                	test   %eax,%eax
  801cb1:	0f 88 0d 01 00 00    	js     801dc4 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801cb7:	83 ec 0c             	sub    $0xc,%esp
  801cba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cbd:	50                   	push   %eax
  801cbe:	e8 f5 ef ff ff       	call   800cb8 <fd_alloc>
  801cc3:	89 c3                	mov    %eax,%ebx
  801cc5:	83 c4 10             	add    $0x10,%esp
  801cc8:	85 c0                	test   %eax,%eax
  801cca:	0f 88 e2 00 00 00    	js     801db2 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cd0:	83 ec 04             	sub    $0x4,%esp
  801cd3:	68 07 04 00 00       	push   $0x407
  801cd8:	ff 75 f0             	pushl  -0x10(%ebp)
  801cdb:	6a 00                	push   $0x0
  801cdd:	e8 91 ee ff ff       	call   800b73 <sys_page_alloc>
  801ce2:	89 c3                	mov    %eax,%ebx
  801ce4:	83 c4 10             	add    $0x10,%esp
  801ce7:	85 c0                	test   %eax,%eax
  801ce9:	0f 88 c3 00 00 00    	js     801db2 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801cef:	83 ec 0c             	sub    $0xc,%esp
  801cf2:	ff 75 f4             	pushl  -0xc(%ebp)
  801cf5:	e8 a6 ef ff ff       	call   800ca0 <fd2data>
  801cfa:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cfc:	83 c4 0c             	add    $0xc,%esp
  801cff:	68 07 04 00 00       	push   $0x407
  801d04:	50                   	push   %eax
  801d05:	6a 00                	push   $0x0
  801d07:	e8 67 ee ff ff       	call   800b73 <sys_page_alloc>
  801d0c:	89 c3                	mov    %eax,%ebx
  801d0e:	83 c4 10             	add    $0x10,%esp
  801d11:	85 c0                	test   %eax,%eax
  801d13:	0f 88 89 00 00 00    	js     801da2 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d19:	83 ec 0c             	sub    $0xc,%esp
  801d1c:	ff 75 f0             	pushl  -0x10(%ebp)
  801d1f:	e8 7c ef ff ff       	call   800ca0 <fd2data>
  801d24:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d2b:	50                   	push   %eax
  801d2c:	6a 00                	push   $0x0
  801d2e:	56                   	push   %esi
  801d2f:	6a 00                	push   $0x0
  801d31:	e8 61 ee ff ff       	call   800b97 <sys_page_map>
  801d36:	89 c3                	mov    %eax,%ebx
  801d38:	83 c4 20             	add    $0x20,%esp
  801d3b:	85 c0                	test   %eax,%eax
  801d3d:	78 55                	js     801d94 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801d3f:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d48:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801d54:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5d:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d62:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801d69:	83 ec 0c             	sub    $0xc,%esp
  801d6c:	ff 75 f4             	pushl  -0xc(%ebp)
  801d6f:	e8 1c ef ff ff       	call   800c90 <fd2num>
  801d74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d77:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d79:	83 c4 04             	add    $0x4,%esp
  801d7c:	ff 75 f0             	pushl  -0x10(%ebp)
  801d7f:	e8 0c ef ff ff       	call   800c90 <fd2num>
  801d84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d87:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d8a:	83 c4 10             	add    $0x10,%esp
  801d8d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d92:	eb 30                	jmp    801dc4 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801d94:	83 ec 08             	sub    $0x8,%esp
  801d97:	56                   	push   %esi
  801d98:	6a 00                	push   $0x0
  801d9a:	e8 1e ee ff ff       	call   800bbd <sys_page_unmap>
  801d9f:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801da2:	83 ec 08             	sub    $0x8,%esp
  801da5:	ff 75 f0             	pushl  -0x10(%ebp)
  801da8:	6a 00                	push   $0x0
  801daa:	e8 0e ee ff ff       	call   800bbd <sys_page_unmap>
  801daf:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801db2:	83 ec 08             	sub    $0x8,%esp
  801db5:	ff 75 f4             	pushl  -0xc(%ebp)
  801db8:	6a 00                	push   $0x0
  801dba:	e8 fe ed ff ff       	call   800bbd <sys_page_unmap>
  801dbf:	83 c4 10             	add    $0x10,%esp
  801dc2:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  801dc4:	89 d0                	mov    %edx,%eax
  801dc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dc9:	5b                   	pop    %ebx
  801dca:	5e                   	pop    %esi
  801dcb:	5d                   	pop    %ebp
  801dcc:	c3                   	ret    

00801dcd <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dd3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dd6:	50                   	push   %eax
  801dd7:	ff 75 08             	pushl  0x8(%ebp)
  801dda:	e8 28 ef ff ff       	call   800d07 <fd_lookup>
  801ddf:	83 c4 10             	add    $0x10,%esp
  801de2:	85 c0                	test   %eax,%eax
  801de4:	78 18                	js     801dfe <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801de6:	83 ec 0c             	sub    $0xc,%esp
  801de9:	ff 75 f4             	pushl  -0xc(%ebp)
  801dec:	e8 af ee ff ff       	call   800ca0 <fd2data>
	return _pipeisclosed(fd, p);
  801df1:	89 c2                	mov    %eax,%edx
  801df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df6:	e8 21 fd ff ff       	call   801b1c <_pipeisclosed>
  801dfb:	83 c4 10             	add    $0x10,%esp
}
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801e03:	b8 00 00 00 00       	mov    $0x0,%eax
  801e08:	5d                   	pop    %ebp
  801e09:	c3                   	ret    

00801e0a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
  801e0d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e10:	68 b3 28 80 00       	push   $0x8028b3
  801e15:	ff 75 0c             	pushl  0xc(%ebp)
  801e18:	e8 0d e9 ff ff       	call   80072a <strcpy>
	return 0;
}
  801e1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	57                   	push   %edi
  801e28:	56                   	push   %esi
  801e29:	53                   	push   %ebx
  801e2a:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e30:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801e35:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e3b:	eb 2d                	jmp    801e6a <devcons_write+0x46>
		m = n - tot;
  801e3d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e40:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801e42:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801e45:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801e4a:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801e4d:	83 ec 04             	sub    $0x4,%esp
  801e50:	53                   	push   %ebx
  801e51:	03 45 0c             	add    0xc(%ebp),%eax
  801e54:	50                   	push   %eax
  801e55:	57                   	push   %edi
  801e56:	e8 62 ea ff ff       	call   8008bd <memmove>
		sys_cputs(buf, m);
  801e5b:	83 c4 08             	add    $0x8,%esp
  801e5e:	53                   	push   %ebx
  801e5f:	57                   	push   %edi
  801e60:	e8 57 ec ff ff       	call   800abc <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e65:	01 de                	add    %ebx,%esi
  801e67:	83 c4 10             	add    $0x10,%esp
  801e6a:	89 f0                	mov    %esi,%eax
  801e6c:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e6f:	72 cc                	jb     801e3d <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801e71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e74:	5b                   	pop    %ebx
  801e75:	5e                   	pop    %esi
  801e76:	5f                   	pop    %edi
  801e77:	5d                   	pop    %ebp
  801e78:	c3                   	ret    

00801e79 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
  801e7c:	83 ec 08             	sub    $0x8,%esp
  801e7f:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801e84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e88:	74 2a                	je     801eb4 <devcons_read+0x3b>
  801e8a:	eb 05                	jmp    801e91 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801e8c:	e8 bb ec ff ff       	call   800b4c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801e91:	e8 4c ec ff ff       	call   800ae2 <sys_cgetc>
  801e96:	85 c0                	test   %eax,%eax
  801e98:	74 f2                	je     801e8c <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801e9a:	85 c0                	test   %eax,%eax
  801e9c:	78 16                	js     801eb4 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801e9e:	83 f8 04             	cmp    $0x4,%eax
  801ea1:	74 0c                	je     801eaf <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea6:	88 02                	mov    %al,(%edx)
	return 1;
  801ea8:	b8 01 00 00 00       	mov    $0x1,%eax
  801ead:	eb 05                	jmp    801eb4 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801eaf:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebf:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801ec2:	6a 01                	push   $0x1
  801ec4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ec7:	50                   	push   %eax
  801ec8:	e8 ef eb ff ff       	call   800abc <sys_cputs>
}
  801ecd:	83 c4 10             	add    $0x10,%esp
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <getchar>:

int
getchar(void)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801ed8:	6a 01                	push   $0x1
  801eda:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801edd:	50                   	push   %eax
  801ede:	6a 00                	push   $0x0
  801ee0:	e8 87 f0 ff ff       	call   800f6c <read>
	if (r < 0)
  801ee5:	83 c4 10             	add    $0x10,%esp
  801ee8:	85 c0                	test   %eax,%eax
  801eea:	78 0f                	js     801efb <getchar+0x29>
		return r;
	if (r < 1)
  801eec:	85 c0                	test   %eax,%eax
  801eee:	7e 06                	jle    801ef6 <getchar+0x24>
		return -E_EOF;
	return c;
  801ef0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801ef4:	eb 05                	jmp    801efb <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801ef6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f03:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f06:	50                   	push   %eax
  801f07:	ff 75 08             	pushl  0x8(%ebp)
  801f0a:	e8 f8 ed ff ff       	call   800d07 <fd_lookup>
  801f0f:	83 c4 10             	add    $0x10,%esp
  801f12:	85 c0                	test   %eax,%eax
  801f14:	78 11                	js     801f27 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f19:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f1f:	39 10                	cmp    %edx,(%eax)
  801f21:	0f 94 c0             	sete   %al
  801f24:	0f b6 c0             	movzbl %al,%eax
}
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <opencons>:

int
opencons(void)
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801f2f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f32:	50                   	push   %eax
  801f33:	e8 80 ed ff ff       	call   800cb8 <fd_alloc>
  801f38:	83 c4 10             	add    $0x10,%esp
		return r;
  801f3b:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801f3d:	85 c0                	test   %eax,%eax
  801f3f:	78 3e                	js     801f7f <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f41:	83 ec 04             	sub    $0x4,%esp
  801f44:	68 07 04 00 00       	push   $0x407
  801f49:	ff 75 f4             	pushl  -0xc(%ebp)
  801f4c:	6a 00                	push   $0x0
  801f4e:	e8 20 ec ff ff       	call   800b73 <sys_page_alloc>
  801f53:	83 c4 10             	add    $0x10,%esp
		return r;
  801f56:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f58:	85 c0                	test   %eax,%eax
  801f5a:	78 23                	js     801f7f <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801f5c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f65:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f71:	83 ec 0c             	sub    $0xc,%esp
  801f74:	50                   	push   %eax
  801f75:	e8 16 ed ff ff       	call   800c90 <fd2num>
  801f7a:	89 c2                	mov    %eax,%edx
  801f7c:	83 c4 10             	add    $0x10,%esp
}
  801f7f:	89 d0                	mov    %edx,%eax
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
  801f86:	56                   	push   %esi
  801f87:	53                   	push   %ebx
  801f88:	8b 75 08             	mov    0x8(%ebp),%esi
  801f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801f91:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801f93:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801f98:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801f9b:	83 ec 0c             	sub    $0xc,%esp
  801f9e:	50                   	push   %eax
  801f9f:	e8 ca ec ff ff       	call   800c6e <sys_ipc_recv>
	if (from_env_store)
  801fa4:	83 c4 10             	add    $0x10,%esp
  801fa7:	85 f6                	test   %esi,%esi
  801fa9:	74 0b                	je     801fb6 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801fab:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801fb1:	8b 52 74             	mov    0x74(%edx),%edx
  801fb4:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801fb6:	85 db                	test   %ebx,%ebx
  801fb8:	74 0b                	je     801fc5 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  801fba:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801fc0:	8b 52 78             	mov    0x78(%edx),%edx
  801fc3:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  801fc5:	85 c0                	test   %eax,%eax
  801fc7:	79 16                	jns    801fdf <ipc_recv+0x5c>
		if (from_env_store)
  801fc9:	85 f6                	test   %esi,%esi
  801fcb:	74 06                	je     801fd3 <ipc_recv+0x50>
			*from_env_store = 0;
  801fcd:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  801fd3:	85 db                	test   %ebx,%ebx
  801fd5:	74 10                	je     801fe7 <ipc_recv+0x64>
			*perm_store = 0;
  801fd7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801fdd:	eb 08                	jmp    801fe7 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  801fdf:	a1 04 40 80 00       	mov    0x804004,%eax
  801fe4:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fe7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fea:	5b                   	pop    %ebx
  801feb:	5e                   	pop    %esi
  801fec:	5d                   	pop    %ebp
  801fed:	c3                   	ret    

00801fee <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
  801ff1:	57                   	push   %edi
  801ff2:	56                   	push   %esi
  801ff3:	53                   	push   %ebx
  801ff4:	83 ec 0c             	sub    $0xc,%esp
  801ff7:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ffa:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ffd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  802000:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  802002:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802007:	0f 44 d8             	cmove  %eax,%ebx
  80200a:	eb 1c                	jmp    802028 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  80200c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80200f:	74 12                	je     802023 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  802011:	50                   	push   %eax
  802012:	68 bf 28 80 00       	push   $0x8028bf
  802017:	6a 42                	push   $0x42
  802019:	68 d5 28 80 00       	push   $0x8028d5
  80201e:	e8 bc e0 ff ff       	call   8000df <_panic>
		sys_yield();
  802023:	e8 24 eb ff ff       	call   800b4c <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  802028:	ff 75 14             	pushl  0x14(%ebp)
  80202b:	53                   	push   %ebx
  80202c:	56                   	push   %esi
  80202d:	57                   	push   %edi
  80202e:	e8 16 ec ff ff       	call   800c49 <sys_ipc_try_send>
  802033:	83 c4 10             	add    $0x10,%esp
  802036:	85 c0                	test   %eax,%eax
  802038:	75 d2                	jne    80200c <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  80203a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80203d:	5b                   	pop    %ebx
  80203e:	5e                   	pop    %esi
  80203f:	5f                   	pop    %edi
  802040:	5d                   	pop    %ebp
  802041:	c3                   	ret    

00802042 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802048:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80204d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802050:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802056:	8b 52 50             	mov    0x50(%edx),%edx
  802059:	39 ca                	cmp    %ecx,%edx
  80205b:	75 0d                	jne    80206a <ipc_find_env+0x28>
			return envs[i].env_id;
  80205d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802060:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802065:	8b 40 48             	mov    0x48(%eax),%eax
  802068:	eb 0f                	jmp    802079 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80206a:	83 c0 01             	add    $0x1,%eax
  80206d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802072:	75 d9                	jne    80204d <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802074:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802079:	5d                   	pop    %ebp
  80207a:	c3                   	ret    

0080207b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802081:	89 d0                	mov    %edx,%eax
  802083:	c1 e8 16             	shr    $0x16,%eax
  802086:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80208d:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802092:	f6 c1 01             	test   $0x1,%cl
  802095:	74 1d                	je     8020b4 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802097:	c1 ea 0c             	shr    $0xc,%edx
  80209a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020a1:	f6 c2 01             	test   $0x1,%dl
  8020a4:	74 0e                	je     8020b4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020a6:	c1 ea 0c             	shr    $0xc,%edx
  8020a9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020b0:	ef 
  8020b1:	0f b7 c0             	movzwl %ax,%eax
}
  8020b4:	5d                   	pop    %ebp
  8020b5:	c3                   	ret    
  8020b6:	66 90                	xchg   %ax,%ax
  8020b8:	66 90                	xchg   %ax,%ax
  8020ba:	66 90                	xchg   %ax,%ax
  8020bc:	66 90                	xchg   %ax,%ax
  8020be:	66 90                	xchg   %ax,%ax

008020c0 <__udivdi3>:
  8020c0:	55                   	push   %ebp
  8020c1:	57                   	push   %edi
  8020c2:	56                   	push   %esi
  8020c3:	53                   	push   %ebx
  8020c4:	83 ec 1c             	sub    $0x1c,%esp
  8020c7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8020cb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8020cf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8020d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020d7:	85 f6                	test   %esi,%esi
  8020d9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020dd:	89 ca                	mov    %ecx,%edx
  8020df:	89 f8                	mov    %edi,%eax
  8020e1:	75 3d                	jne    802120 <__udivdi3+0x60>
  8020e3:	39 cf                	cmp    %ecx,%edi
  8020e5:	0f 87 c5 00 00 00    	ja     8021b0 <__udivdi3+0xf0>
  8020eb:	85 ff                	test   %edi,%edi
  8020ed:	89 fd                	mov    %edi,%ebp
  8020ef:	75 0b                	jne    8020fc <__udivdi3+0x3c>
  8020f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8020f6:	31 d2                	xor    %edx,%edx
  8020f8:	f7 f7                	div    %edi
  8020fa:	89 c5                	mov    %eax,%ebp
  8020fc:	89 c8                	mov    %ecx,%eax
  8020fe:	31 d2                	xor    %edx,%edx
  802100:	f7 f5                	div    %ebp
  802102:	89 c1                	mov    %eax,%ecx
  802104:	89 d8                	mov    %ebx,%eax
  802106:	89 cf                	mov    %ecx,%edi
  802108:	f7 f5                	div    %ebp
  80210a:	89 c3                	mov    %eax,%ebx
  80210c:	89 d8                	mov    %ebx,%eax
  80210e:	89 fa                	mov    %edi,%edx
  802110:	83 c4 1c             	add    $0x1c,%esp
  802113:	5b                   	pop    %ebx
  802114:	5e                   	pop    %esi
  802115:	5f                   	pop    %edi
  802116:	5d                   	pop    %ebp
  802117:	c3                   	ret    
  802118:	90                   	nop
  802119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802120:	39 ce                	cmp    %ecx,%esi
  802122:	77 74                	ja     802198 <__udivdi3+0xd8>
  802124:	0f bd fe             	bsr    %esi,%edi
  802127:	83 f7 1f             	xor    $0x1f,%edi
  80212a:	0f 84 98 00 00 00    	je     8021c8 <__udivdi3+0x108>
  802130:	bb 20 00 00 00       	mov    $0x20,%ebx
  802135:	89 f9                	mov    %edi,%ecx
  802137:	89 c5                	mov    %eax,%ebp
  802139:	29 fb                	sub    %edi,%ebx
  80213b:	d3 e6                	shl    %cl,%esi
  80213d:	89 d9                	mov    %ebx,%ecx
  80213f:	d3 ed                	shr    %cl,%ebp
  802141:	89 f9                	mov    %edi,%ecx
  802143:	d3 e0                	shl    %cl,%eax
  802145:	09 ee                	or     %ebp,%esi
  802147:	89 d9                	mov    %ebx,%ecx
  802149:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80214d:	89 d5                	mov    %edx,%ebp
  80214f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802153:	d3 ed                	shr    %cl,%ebp
  802155:	89 f9                	mov    %edi,%ecx
  802157:	d3 e2                	shl    %cl,%edx
  802159:	89 d9                	mov    %ebx,%ecx
  80215b:	d3 e8                	shr    %cl,%eax
  80215d:	09 c2                	or     %eax,%edx
  80215f:	89 d0                	mov    %edx,%eax
  802161:	89 ea                	mov    %ebp,%edx
  802163:	f7 f6                	div    %esi
  802165:	89 d5                	mov    %edx,%ebp
  802167:	89 c3                	mov    %eax,%ebx
  802169:	f7 64 24 0c          	mull   0xc(%esp)
  80216d:	39 d5                	cmp    %edx,%ebp
  80216f:	72 10                	jb     802181 <__udivdi3+0xc1>
  802171:	8b 74 24 08          	mov    0x8(%esp),%esi
  802175:	89 f9                	mov    %edi,%ecx
  802177:	d3 e6                	shl    %cl,%esi
  802179:	39 c6                	cmp    %eax,%esi
  80217b:	73 07                	jae    802184 <__udivdi3+0xc4>
  80217d:	39 d5                	cmp    %edx,%ebp
  80217f:	75 03                	jne    802184 <__udivdi3+0xc4>
  802181:	83 eb 01             	sub    $0x1,%ebx
  802184:	31 ff                	xor    %edi,%edi
  802186:	89 d8                	mov    %ebx,%eax
  802188:	89 fa                	mov    %edi,%edx
  80218a:	83 c4 1c             	add    $0x1c,%esp
  80218d:	5b                   	pop    %ebx
  80218e:	5e                   	pop    %esi
  80218f:	5f                   	pop    %edi
  802190:	5d                   	pop    %ebp
  802191:	c3                   	ret    
  802192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802198:	31 ff                	xor    %edi,%edi
  80219a:	31 db                	xor    %ebx,%ebx
  80219c:	89 d8                	mov    %ebx,%eax
  80219e:	89 fa                	mov    %edi,%edx
  8021a0:	83 c4 1c             	add    $0x1c,%esp
  8021a3:	5b                   	pop    %ebx
  8021a4:	5e                   	pop    %esi
  8021a5:	5f                   	pop    %edi
  8021a6:	5d                   	pop    %ebp
  8021a7:	c3                   	ret    
  8021a8:	90                   	nop
  8021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021b0:	89 d8                	mov    %ebx,%eax
  8021b2:	f7 f7                	div    %edi
  8021b4:	31 ff                	xor    %edi,%edi
  8021b6:	89 c3                	mov    %eax,%ebx
  8021b8:	89 d8                	mov    %ebx,%eax
  8021ba:	89 fa                	mov    %edi,%edx
  8021bc:	83 c4 1c             	add    $0x1c,%esp
  8021bf:	5b                   	pop    %ebx
  8021c0:	5e                   	pop    %esi
  8021c1:	5f                   	pop    %edi
  8021c2:	5d                   	pop    %ebp
  8021c3:	c3                   	ret    
  8021c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021c8:	39 ce                	cmp    %ecx,%esi
  8021ca:	72 0c                	jb     8021d8 <__udivdi3+0x118>
  8021cc:	31 db                	xor    %ebx,%ebx
  8021ce:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8021d2:	0f 87 34 ff ff ff    	ja     80210c <__udivdi3+0x4c>
  8021d8:	bb 01 00 00 00       	mov    $0x1,%ebx
  8021dd:	e9 2a ff ff ff       	jmp    80210c <__udivdi3+0x4c>
  8021e2:	66 90                	xchg   %ax,%ax
  8021e4:	66 90                	xchg   %ax,%ax
  8021e6:	66 90                	xchg   %ax,%ax
  8021e8:	66 90                	xchg   %ax,%ax
  8021ea:	66 90                	xchg   %ax,%ax
  8021ec:	66 90                	xchg   %ax,%ax
  8021ee:	66 90                	xchg   %ax,%ax

008021f0 <__umoddi3>:
  8021f0:	55                   	push   %ebp
  8021f1:	57                   	push   %edi
  8021f2:	56                   	push   %esi
  8021f3:	53                   	push   %ebx
  8021f4:	83 ec 1c             	sub    $0x1c,%esp
  8021f7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021fb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8021ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  802203:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802207:	85 d2                	test   %edx,%edx
  802209:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80220d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802211:	89 f3                	mov    %esi,%ebx
  802213:	89 3c 24             	mov    %edi,(%esp)
  802216:	89 74 24 04          	mov    %esi,0x4(%esp)
  80221a:	75 1c                	jne    802238 <__umoddi3+0x48>
  80221c:	39 f7                	cmp    %esi,%edi
  80221e:	76 50                	jbe    802270 <__umoddi3+0x80>
  802220:	89 c8                	mov    %ecx,%eax
  802222:	89 f2                	mov    %esi,%edx
  802224:	f7 f7                	div    %edi
  802226:	89 d0                	mov    %edx,%eax
  802228:	31 d2                	xor    %edx,%edx
  80222a:	83 c4 1c             	add    $0x1c,%esp
  80222d:	5b                   	pop    %ebx
  80222e:	5e                   	pop    %esi
  80222f:	5f                   	pop    %edi
  802230:	5d                   	pop    %ebp
  802231:	c3                   	ret    
  802232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802238:	39 f2                	cmp    %esi,%edx
  80223a:	89 d0                	mov    %edx,%eax
  80223c:	77 52                	ja     802290 <__umoddi3+0xa0>
  80223e:	0f bd ea             	bsr    %edx,%ebp
  802241:	83 f5 1f             	xor    $0x1f,%ebp
  802244:	75 5a                	jne    8022a0 <__umoddi3+0xb0>
  802246:	3b 54 24 04          	cmp    0x4(%esp),%edx
  80224a:	0f 82 e0 00 00 00    	jb     802330 <__umoddi3+0x140>
  802250:	39 0c 24             	cmp    %ecx,(%esp)
  802253:	0f 86 d7 00 00 00    	jbe    802330 <__umoddi3+0x140>
  802259:	8b 44 24 08          	mov    0x8(%esp),%eax
  80225d:	8b 54 24 04          	mov    0x4(%esp),%edx
  802261:	83 c4 1c             	add    $0x1c,%esp
  802264:	5b                   	pop    %ebx
  802265:	5e                   	pop    %esi
  802266:	5f                   	pop    %edi
  802267:	5d                   	pop    %ebp
  802268:	c3                   	ret    
  802269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802270:	85 ff                	test   %edi,%edi
  802272:	89 fd                	mov    %edi,%ebp
  802274:	75 0b                	jne    802281 <__umoddi3+0x91>
  802276:	b8 01 00 00 00       	mov    $0x1,%eax
  80227b:	31 d2                	xor    %edx,%edx
  80227d:	f7 f7                	div    %edi
  80227f:	89 c5                	mov    %eax,%ebp
  802281:	89 f0                	mov    %esi,%eax
  802283:	31 d2                	xor    %edx,%edx
  802285:	f7 f5                	div    %ebp
  802287:	89 c8                	mov    %ecx,%eax
  802289:	f7 f5                	div    %ebp
  80228b:	89 d0                	mov    %edx,%eax
  80228d:	eb 99                	jmp    802228 <__umoddi3+0x38>
  80228f:	90                   	nop
  802290:	89 c8                	mov    %ecx,%eax
  802292:	89 f2                	mov    %esi,%edx
  802294:	83 c4 1c             	add    $0x1c,%esp
  802297:	5b                   	pop    %ebx
  802298:	5e                   	pop    %esi
  802299:	5f                   	pop    %edi
  80229a:	5d                   	pop    %ebp
  80229b:	c3                   	ret    
  80229c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022a0:	8b 34 24             	mov    (%esp),%esi
  8022a3:	bf 20 00 00 00       	mov    $0x20,%edi
  8022a8:	89 e9                	mov    %ebp,%ecx
  8022aa:	29 ef                	sub    %ebp,%edi
  8022ac:	d3 e0                	shl    %cl,%eax
  8022ae:	89 f9                	mov    %edi,%ecx
  8022b0:	89 f2                	mov    %esi,%edx
  8022b2:	d3 ea                	shr    %cl,%edx
  8022b4:	89 e9                	mov    %ebp,%ecx
  8022b6:	09 c2                	or     %eax,%edx
  8022b8:	89 d8                	mov    %ebx,%eax
  8022ba:	89 14 24             	mov    %edx,(%esp)
  8022bd:	89 f2                	mov    %esi,%edx
  8022bf:	d3 e2                	shl    %cl,%edx
  8022c1:	89 f9                	mov    %edi,%ecx
  8022c3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022c7:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8022cb:	d3 e8                	shr    %cl,%eax
  8022cd:	89 e9                	mov    %ebp,%ecx
  8022cf:	89 c6                	mov    %eax,%esi
  8022d1:	d3 e3                	shl    %cl,%ebx
  8022d3:	89 f9                	mov    %edi,%ecx
  8022d5:	89 d0                	mov    %edx,%eax
  8022d7:	d3 e8                	shr    %cl,%eax
  8022d9:	89 e9                	mov    %ebp,%ecx
  8022db:	09 d8                	or     %ebx,%eax
  8022dd:	89 d3                	mov    %edx,%ebx
  8022df:	89 f2                	mov    %esi,%edx
  8022e1:	f7 34 24             	divl   (%esp)
  8022e4:	89 d6                	mov    %edx,%esi
  8022e6:	d3 e3                	shl    %cl,%ebx
  8022e8:	f7 64 24 04          	mull   0x4(%esp)
  8022ec:	39 d6                	cmp    %edx,%esi
  8022ee:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022f2:	89 d1                	mov    %edx,%ecx
  8022f4:	89 c3                	mov    %eax,%ebx
  8022f6:	72 08                	jb     802300 <__umoddi3+0x110>
  8022f8:	75 11                	jne    80230b <__umoddi3+0x11b>
  8022fa:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8022fe:	73 0b                	jae    80230b <__umoddi3+0x11b>
  802300:	2b 44 24 04          	sub    0x4(%esp),%eax
  802304:	1b 14 24             	sbb    (%esp),%edx
  802307:	89 d1                	mov    %edx,%ecx
  802309:	89 c3                	mov    %eax,%ebx
  80230b:	8b 54 24 08          	mov    0x8(%esp),%edx
  80230f:	29 da                	sub    %ebx,%edx
  802311:	19 ce                	sbb    %ecx,%esi
  802313:	89 f9                	mov    %edi,%ecx
  802315:	89 f0                	mov    %esi,%eax
  802317:	d3 e0                	shl    %cl,%eax
  802319:	89 e9                	mov    %ebp,%ecx
  80231b:	d3 ea                	shr    %cl,%edx
  80231d:	89 e9                	mov    %ebp,%ecx
  80231f:	d3 ee                	shr    %cl,%esi
  802321:	09 d0                	or     %edx,%eax
  802323:	89 f2                	mov    %esi,%edx
  802325:	83 c4 1c             	add    $0x1c,%esp
  802328:	5b                   	pop    %ebx
  802329:	5e                   	pop    %esi
  80232a:	5f                   	pop    %edi
  80232b:	5d                   	pop    %ebp
  80232c:	c3                   	ret    
  80232d:	8d 76 00             	lea    0x0(%esi),%esi
  802330:	29 f9                	sub    %edi,%ecx
  802332:	19 d6                	sbb    %edx,%esi
  802334:	89 74 24 04          	mov    %esi,0x4(%esp)
  802338:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80233c:	e9 18 ff ff ff       	jmp    802259 <__umoddi3+0x69>
