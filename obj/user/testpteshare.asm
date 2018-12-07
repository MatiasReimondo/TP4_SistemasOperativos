
obj/user/testpteshare.debug:     formato del fichero elf32-i386


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
  80002c:	e8 51 01 00 00       	call   800182 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <breakpoint>:

#include <inc/types.h>

static inline void
breakpoint(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	asm volatile("int3");
  800036:	cc                   	int3   
}
  800037:	5d                   	pop    %ebp
  800038:	c3                   	ret    

00800039 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800039:	55                   	push   %ebp
  80003a:	89 e5                	mov    %esp,%ebp
  80003c:	83 ec 10             	sub    $0x10,%esp
	strcpy(VA, msg2);
  80003f:	ff 35 00 40 80 00    	pushl  0x804000
  800045:	68 00 00 00 a0       	push   $0xa0000000
  80004a:	e8 e2 07 00 00       	call   800831 <strcpy>
	exit();
  80004f:	e8 78 01 00 00       	call   8001cc <exit>
}
  800054:	83 c4 10             	add    $0x10,%esp
  800057:	c9                   	leave  
  800058:	c3                   	ret    

00800059 <umain>:

void childofspawn(void);

void
umain(int argc, char **argv)
{
  800059:	55                   	push   %ebp
  80005a:	89 e5                	mov    %esp,%ebp
  80005c:	53                   	push   %ebx
  80005d:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (argc != 0)
  800060:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800064:	74 05                	je     80006b <umain+0x12>
		childofspawn();
  800066:	e8 ce ff ff ff       	call   800039 <childofspawn>

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80006b:	83 ec 04             	sub    $0x4,%esp
  80006e:	68 07 04 00 00       	push   $0x407
  800073:	68 00 00 00 a0       	push   $0xa0000000
  800078:	6a 00                	push   $0x0
  80007a:	e8 fb 0b 00 00       	call   800c7a <sys_page_alloc>
  80007f:	83 c4 10             	add    $0x10,%esp
  800082:	85 c0                	test   %eax,%eax
  800084:	79 12                	jns    800098 <umain+0x3f>
		panic("sys_page_alloc: %e", r);
  800086:	50                   	push   %eax
  800087:	68 0c 2a 80 00       	push   $0x802a0c
  80008c:	6a 13                	push   $0x13
  80008e:	68 1f 2a 80 00       	push   $0x802a1f
  800093:	e8 4e 01 00 00       	call   8001e6 <_panic>

	// check fork
	if ((r = fork()) < 0)
  800098:	e8 84 10 00 00       	call   801121 <fork>
  80009d:	89 c3                	mov    %eax,%ebx
  80009f:	85 c0                	test   %eax,%eax
  8000a1:	79 12                	jns    8000b5 <umain+0x5c>
		panic("fork: %e", r);
  8000a3:	50                   	push   %eax
  8000a4:	68 f0 2e 80 00       	push   $0x802ef0
  8000a9:	6a 17                	push   $0x17
  8000ab:	68 1f 2a 80 00       	push   $0x802a1f
  8000b0:	e8 31 01 00 00       	call   8001e6 <_panic>
	if (r == 0) {
  8000b5:	85 c0                	test   %eax,%eax
  8000b7:	75 1b                	jne    8000d4 <umain+0x7b>
		strcpy(VA, msg);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 35 04 40 80 00    	pushl  0x804004
  8000c2:	68 00 00 00 a0       	push   $0xa0000000
  8000c7:	e8 65 07 00 00       	call   800831 <strcpy>
		exit();
  8000cc:	e8 fb 00 00 00       	call   8001cc <exit>
  8000d1:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	53                   	push   %ebx
  8000d8:	e8 e1 22 00 00       	call   8023be <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000dd:	83 c4 08             	add    $0x8,%esp
  8000e0:	ff 35 04 40 80 00    	pushl  0x804004
  8000e6:	68 00 00 00 a0       	push   $0xa0000000
  8000eb:	e8 eb 07 00 00       	call   8008db <strcmp>
  8000f0:	83 c4 08             	add    $0x8,%esp
  8000f3:	85 c0                	test   %eax,%eax
  8000f5:	ba 06 2a 80 00       	mov    $0x802a06,%edx
  8000fa:	b8 00 2a 80 00       	mov    $0x802a00,%eax
  8000ff:	0f 45 c2             	cmovne %edx,%eax
  800102:	50                   	push   %eax
  800103:	68 33 2a 80 00       	push   $0x802a33
  800108:	e8 b2 01 00 00       	call   8002bf <cprintf>

	// check spawn
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  80010d:	6a 00                	push   $0x0
  80010f:	68 4e 2a 80 00       	push   $0x802a4e
  800114:	68 53 2a 80 00       	push   $0x802a53
  800119:	68 52 2a 80 00       	push   $0x802a52
  80011e:	e8 cc 1e 00 00       	call   801fef <spawnl>
  800123:	83 c4 20             	add    $0x20,%esp
  800126:	85 c0                	test   %eax,%eax
  800128:	79 12                	jns    80013c <umain+0xe3>
		panic("spawn: %e", r);
  80012a:	50                   	push   %eax
  80012b:	68 60 2a 80 00       	push   $0x802a60
  800130:	6a 21                	push   $0x21
  800132:	68 1f 2a 80 00       	push   $0x802a1f
  800137:	e8 aa 00 00 00       	call   8001e6 <_panic>
	wait(r);
  80013c:	83 ec 0c             	sub    $0xc,%esp
  80013f:	50                   	push   %eax
  800140:	e8 79 22 00 00       	call   8023be <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  800145:	83 c4 08             	add    $0x8,%esp
  800148:	ff 35 00 40 80 00    	pushl  0x804000
  80014e:	68 00 00 00 a0       	push   $0xa0000000
  800153:	e8 83 07 00 00       	call   8008db <strcmp>
  800158:	83 c4 08             	add    $0x8,%esp
  80015b:	85 c0                	test   %eax,%eax
  80015d:	ba 06 2a 80 00       	mov    $0x802a06,%edx
  800162:	b8 00 2a 80 00       	mov    $0x802a00,%eax
  800167:	0f 45 c2             	cmovne %edx,%eax
  80016a:	50                   	push   %eax
  80016b:	68 6a 2a 80 00       	push   $0x802a6a
  800170:	e8 4a 01 00 00       	call   8002bf <cprintf>

	breakpoint();
  800175:	e8 b9 fe ff ff       	call   800033 <breakpoint>
}
  80017a:	83 c4 10             	add    $0x10,%esp
  80017d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800180:	c9                   	leave  
  800181:	c3                   	ret    

00800182 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800182:	55                   	push   %ebp
  800183:	89 e5                	mov    %esp,%ebp
  800185:	56                   	push   %esi
  800186:	53                   	push   %ebx
  800187:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80018a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  80018d:	e8 9d 0a 00 00       	call   800c2f <sys_getenvid>
	if (id >= 0)
  800192:	85 c0                	test   %eax,%eax
  800194:	78 12                	js     8001a8 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  800196:	25 ff 03 00 00       	and    $0x3ff,%eax
  80019b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80019e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a3:	a3 04 50 80 00       	mov    %eax,0x805004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a8:	85 db                	test   %ebx,%ebx
  8001aa:	7e 07                	jle    8001b3 <libmain+0x31>
		binaryname = argv[0];
  8001ac:	8b 06                	mov    (%esi),%eax
  8001ae:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	56                   	push   %esi
  8001b7:	53                   	push   %ebx
  8001b8:	e8 9c fe ff ff       	call   800059 <umain>

	// exit gracefully
	exit();
  8001bd:	e8 0a 00 00 00       	call   8001cc <exit>
}
  8001c2:	83 c4 10             	add    $0x10,%esp
  8001c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001c8:	5b                   	pop    %ebx
  8001c9:	5e                   	pop    %esi
  8001ca:	5d                   	pop    %ebp
  8001cb:	c3                   	ret    

008001cc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001cc:	55                   	push   %ebp
  8001cd:	89 e5                	mov    %esp,%ebp
  8001cf:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001d2:	e8 42 12 00 00       	call   801419 <close_all>
	sys_env_destroy(0);
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	6a 00                	push   $0x0
  8001dc:	e8 2c 0a 00 00       	call   800c0d <sys_env_destroy>
}
  8001e1:	83 c4 10             	add    $0x10,%esp
  8001e4:	c9                   	leave  
  8001e5:	c3                   	ret    

008001e6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	56                   	push   %esi
  8001ea:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001eb:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001ee:	8b 35 08 40 80 00    	mov    0x804008,%esi
  8001f4:	e8 36 0a 00 00       	call   800c2f <sys_getenvid>
  8001f9:	83 ec 0c             	sub    $0xc,%esp
  8001fc:	ff 75 0c             	pushl  0xc(%ebp)
  8001ff:	ff 75 08             	pushl  0x8(%ebp)
  800202:	56                   	push   %esi
  800203:	50                   	push   %eax
  800204:	68 b0 2a 80 00       	push   $0x802ab0
  800209:	e8 b1 00 00 00       	call   8002bf <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80020e:	83 c4 18             	add    $0x18,%esp
  800211:	53                   	push   %ebx
  800212:	ff 75 10             	pushl  0x10(%ebp)
  800215:	e8 54 00 00 00       	call   80026e <vcprintf>
	cprintf("\n");
  80021a:	c7 04 24 e4 30 80 00 	movl   $0x8030e4,(%esp)
  800221:	e8 99 00 00 00       	call   8002bf <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800229:	cc                   	int3   
  80022a:	eb fd                	jmp    800229 <_panic+0x43>

0080022c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	53                   	push   %ebx
  800230:	83 ec 04             	sub    $0x4,%esp
  800233:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800236:	8b 13                	mov    (%ebx),%edx
  800238:	8d 42 01             	lea    0x1(%edx),%eax
  80023b:	89 03                	mov    %eax,(%ebx)
  80023d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800240:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800244:	3d ff 00 00 00       	cmp    $0xff,%eax
  800249:	75 1a                	jne    800265 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  80024b:	83 ec 08             	sub    $0x8,%esp
  80024e:	68 ff 00 00 00       	push   $0xff
  800253:	8d 43 08             	lea    0x8(%ebx),%eax
  800256:	50                   	push   %eax
  800257:	e8 67 09 00 00       	call   800bc3 <sys_cputs>
		b->idx = 0;
  80025c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800262:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  800265:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800269:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80026c:	c9                   	leave  
  80026d:	c3                   	ret    

0080026e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80026e:	55                   	push   %ebp
  80026f:	89 e5                	mov    %esp,%ebp
  800271:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800277:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80027e:	00 00 00 
	b.cnt = 0;
  800281:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800288:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80028b:	ff 75 0c             	pushl  0xc(%ebp)
  80028e:	ff 75 08             	pushl  0x8(%ebp)
  800291:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800297:	50                   	push   %eax
  800298:	68 2c 02 80 00       	push   $0x80022c
  80029d:	e8 86 01 00 00       	call   800428 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002a2:	83 c4 08             	add    $0x8,%esp
  8002a5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002ab:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002b1:	50                   	push   %eax
  8002b2:	e8 0c 09 00 00       	call   800bc3 <sys_cputs>

	return b.cnt;
}
  8002b7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002bd:	c9                   	leave  
  8002be:	c3                   	ret    

008002bf <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002bf:	55                   	push   %ebp
  8002c0:	89 e5                	mov    %esp,%ebp
  8002c2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002c5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002c8:	50                   	push   %eax
  8002c9:	ff 75 08             	pushl  0x8(%ebp)
  8002cc:	e8 9d ff ff ff       	call   80026e <vcprintf>
	va_end(ap);

	return cnt;
}
  8002d1:	c9                   	leave  
  8002d2:	c3                   	ret    

008002d3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002d3:	55                   	push   %ebp
  8002d4:	89 e5                	mov    %esp,%ebp
  8002d6:	57                   	push   %edi
  8002d7:	56                   	push   %esi
  8002d8:	53                   	push   %ebx
  8002d9:	83 ec 1c             	sub    $0x1c,%esp
  8002dc:	89 c7                	mov    %eax,%edi
  8002de:	89 d6                	mov    %edx,%esi
  8002e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002f4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002f7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002fa:	39 d3                	cmp    %edx,%ebx
  8002fc:	72 05                	jb     800303 <printnum+0x30>
  8002fe:	39 45 10             	cmp    %eax,0x10(%ebp)
  800301:	77 45                	ja     800348 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800303:	83 ec 0c             	sub    $0xc,%esp
  800306:	ff 75 18             	pushl  0x18(%ebp)
  800309:	8b 45 14             	mov    0x14(%ebp),%eax
  80030c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80030f:	53                   	push   %ebx
  800310:	ff 75 10             	pushl  0x10(%ebp)
  800313:	83 ec 08             	sub    $0x8,%esp
  800316:	ff 75 e4             	pushl  -0x1c(%ebp)
  800319:	ff 75 e0             	pushl  -0x20(%ebp)
  80031c:	ff 75 dc             	pushl  -0x24(%ebp)
  80031f:	ff 75 d8             	pushl  -0x28(%ebp)
  800322:	e8 39 24 00 00       	call   802760 <__udivdi3>
  800327:	83 c4 18             	add    $0x18,%esp
  80032a:	52                   	push   %edx
  80032b:	50                   	push   %eax
  80032c:	89 f2                	mov    %esi,%edx
  80032e:	89 f8                	mov    %edi,%eax
  800330:	e8 9e ff ff ff       	call   8002d3 <printnum>
  800335:	83 c4 20             	add    $0x20,%esp
  800338:	eb 18                	jmp    800352 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80033a:	83 ec 08             	sub    $0x8,%esp
  80033d:	56                   	push   %esi
  80033e:	ff 75 18             	pushl  0x18(%ebp)
  800341:	ff d7                	call   *%edi
  800343:	83 c4 10             	add    $0x10,%esp
  800346:	eb 03                	jmp    80034b <printnum+0x78>
  800348:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80034b:	83 eb 01             	sub    $0x1,%ebx
  80034e:	85 db                	test   %ebx,%ebx
  800350:	7f e8                	jg     80033a <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800352:	83 ec 08             	sub    $0x8,%esp
  800355:	56                   	push   %esi
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	ff 75 e4             	pushl  -0x1c(%ebp)
  80035c:	ff 75 e0             	pushl  -0x20(%ebp)
  80035f:	ff 75 dc             	pushl  -0x24(%ebp)
  800362:	ff 75 d8             	pushl  -0x28(%ebp)
  800365:	e8 26 25 00 00       	call   802890 <__umoddi3>
  80036a:	83 c4 14             	add    $0x14,%esp
  80036d:	0f be 80 d3 2a 80 00 	movsbl 0x802ad3(%eax),%eax
  800374:	50                   	push   %eax
  800375:	ff d7                	call   *%edi
}
  800377:	83 c4 10             	add    $0x10,%esp
  80037a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80037d:	5b                   	pop    %ebx
  80037e:	5e                   	pop    %esi
  80037f:	5f                   	pop    %edi
  800380:	5d                   	pop    %ebp
  800381:	c3                   	ret    

00800382 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800385:	83 fa 01             	cmp    $0x1,%edx
  800388:	7e 0e                	jle    800398 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80038a:	8b 10                	mov    (%eax),%edx
  80038c:	8d 4a 08             	lea    0x8(%edx),%ecx
  80038f:	89 08                	mov    %ecx,(%eax)
  800391:	8b 02                	mov    (%edx),%eax
  800393:	8b 52 04             	mov    0x4(%edx),%edx
  800396:	eb 22                	jmp    8003ba <getuint+0x38>
	else if (lflag)
  800398:	85 d2                	test   %edx,%edx
  80039a:	74 10                	je     8003ac <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80039c:	8b 10                	mov    (%eax),%edx
  80039e:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003a1:	89 08                	mov    %ecx,(%eax)
  8003a3:	8b 02                	mov    (%edx),%eax
  8003a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003aa:	eb 0e                	jmp    8003ba <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003ac:	8b 10                	mov    (%eax),%edx
  8003ae:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003b1:	89 08                	mov    %ecx,(%eax)
  8003b3:	8b 02                	mov    (%edx),%eax
  8003b5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003ba:	5d                   	pop    %ebp
  8003bb:	c3                   	ret    

008003bc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003bc:	55                   	push   %ebp
  8003bd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003bf:	83 fa 01             	cmp    $0x1,%edx
  8003c2:	7e 0e                	jle    8003d2 <getint+0x16>
		return va_arg(*ap, long long);
  8003c4:	8b 10                	mov    (%eax),%edx
  8003c6:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003c9:	89 08                	mov    %ecx,(%eax)
  8003cb:	8b 02                	mov    (%edx),%eax
  8003cd:	8b 52 04             	mov    0x4(%edx),%edx
  8003d0:	eb 1a                	jmp    8003ec <getint+0x30>
	else if (lflag)
  8003d2:	85 d2                	test   %edx,%edx
  8003d4:	74 0c                	je     8003e2 <getint+0x26>
		return va_arg(*ap, long);
  8003d6:	8b 10                	mov    (%eax),%edx
  8003d8:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003db:	89 08                	mov    %ecx,(%eax)
  8003dd:	8b 02                	mov    (%edx),%eax
  8003df:	99                   	cltd   
  8003e0:	eb 0a                	jmp    8003ec <getint+0x30>
	else
		return va_arg(*ap, int);
  8003e2:	8b 10                	mov    (%eax),%edx
  8003e4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003e7:	89 08                	mov    %ecx,(%eax)
  8003e9:	8b 02                	mov    (%edx),%eax
  8003eb:	99                   	cltd   
}
  8003ec:	5d                   	pop    %ebp
  8003ed:	c3                   	ret    

008003ee <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003ee:	55                   	push   %ebp
  8003ef:	89 e5                	mov    %esp,%ebp
  8003f1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003f4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003f8:	8b 10                	mov    (%eax),%edx
  8003fa:	3b 50 04             	cmp    0x4(%eax),%edx
  8003fd:	73 0a                	jae    800409 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003ff:	8d 4a 01             	lea    0x1(%edx),%ecx
  800402:	89 08                	mov    %ecx,(%eax)
  800404:	8b 45 08             	mov    0x8(%ebp),%eax
  800407:	88 02                	mov    %al,(%edx)
}
  800409:	5d                   	pop    %ebp
  80040a:	c3                   	ret    

0080040b <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80040b:	55                   	push   %ebp
  80040c:	89 e5                	mov    %esp,%ebp
  80040e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800411:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800414:	50                   	push   %eax
  800415:	ff 75 10             	pushl  0x10(%ebp)
  800418:	ff 75 0c             	pushl  0xc(%ebp)
  80041b:	ff 75 08             	pushl  0x8(%ebp)
  80041e:	e8 05 00 00 00       	call   800428 <vprintfmt>
	va_end(ap);
}
  800423:	83 c4 10             	add    $0x10,%esp
  800426:	c9                   	leave  
  800427:	c3                   	ret    

00800428 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800428:	55                   	push   %ebp
  800429:	89 e5                	mov    %esp,%ebp
  80042b:	57                   	push   %edi
  80042c:	56                   	push   %esi
  80042d:	53                   	push   %ebx
  80042e:	83 ec 2c             	sub    $0x2c,%esp
  800431:	8b 75 08             	mov    0x8(%ebp),%esi
  800434:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800437:	8b 7d 10             	mov    0x10(%ebp),%edi
  80043a:	eb 12                	jmp    80044e <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80043c:	85 c0                	test   %eax,%eax
  80043e:	0f 84 44 03 00 00    	je     800788 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  800444:	83 ec 08             	sub    $0x8,%esp
  800447:	53                   	push   %ebx
  800448:	50                   	push   %eax
  800449:	ff d6                	call   *%esi
  80044b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80044e:	83 c7 01             	add    $0x1,%edi
  800451:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800455:	83 f8 25             	cmp    $0x25,%eax
  800458:	75 e2                	jne    80043c <vprintfmt+0x14>
  80045a:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  80045e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800465:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80046c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800473:	ba 00 00 00 00       	mov    $0x0,%edx
  800478:	eb 07                	jmp    800481 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80047a:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  80047d:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800481:	8d 47 01             	lea    0x1(%edi),%eax
  800484:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800487:	0f b6 07             	movzbl (%edi),%eax
  80048a:	0f b6 c8             	movzbl %al,%ecx
  80048d:	83 e8 23             	sub    $0x23,%eax
  800490:	3c 55                	cmp    $0x55,%al
  800492:	0f 87 d5 02 00 00    	ja     80076d <vprintfmt+0x345>
  800498:	0f b6 c0             	movzbl %al,%eax
  80049b:	ff 24 85 20 2c 80 00 	jmp    *0x802c20(,%eax,4)
  8004a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004a5:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8004a9:	eb d6                	jmp    800481 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004b6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004b9:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8004bd:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8004c0:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8004c3:	83 fa 09             	cmp    $0x9,%edx
  8004c6:	77 39                	ja     800501 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004c8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004cb:	eb e9                	jmp    8004b6 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d0:	8d 48 04             	lea    0x4(%eax),%ecx
  8004d3:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8004d6:	8b 00                	mov    (%eax),%eax
  8004d8:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004de:	eb 27                	jmp    800507 <vprintfmt+0xdf>
  8004e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e3:	85 c0                	test   %eax,%eax
  8004e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004ea:	0f 49 c8             	cmovns %eax,%ecx
  8004ed:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004f3:	eb 8c                	jmp    800481 <vprintfmt+0x59>
  8004f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004f8:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004ff:	eb 80                	jmp    800481 <vprintfmt+0x59>
  800501:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800504:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  800507:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80050b:	0f 89 70 ff ff ff    	jns    800481 <vprintfmt+0x59>
				width = precision, precision = -1;
  800511:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800514:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800517:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80051e:	e9 5e ff ff ff       	jmp    800481 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800523:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800526:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800529:	e9 53 ff ff ff       	jmp    800481 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80052e:	8b 45 14             	mov    0x14(%ebp),%eax
  800531:	8d 50 04             	lea    0x4(%eax),%edx
  800534:	89 55 14             	mov    %edx,0x14(%ebp)
  800537:	83 ec 08             	sub    $0x8,%esp
  80053a:	53                   	push   %ebx
  80053b:	ff 30                	pushl  (%eax)
  80053d:	ff d6                	call   *%esi
			break;
  80053f:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800542:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800545:	e9 04 ff ff ff       	jmp    80044e <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80054a:	8b 45 14             	mov    0x14(%ebp),%eax
  80054d:	8d 50 04             	lea    0x4(%eax),%edx
  800550:	89 55 14             	mov    %edx,0x14(%ebp)
  800553:	8b 00                	mov    (%eax),%eax
  800555:	99                   	cltd   
  800556:	31 d0                	xor    %edx,%eax
  800558:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80055a:	83 f8 0f             	cmp    $0xf,%eax
  80055d:	7f 0b                	jg     80056a <vprintfmt+0x142>
  80055f:	8b 14 85 80 2d 80 00 	mov    0x802d80(,%eax,4),%edx
  800566:	85 d2                	test   %edx,%edx
  800568:	75 18                	jne    800582 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  80056a:	50                   	push   %eax
  80056b:	68 eb 2a 80 00       	push   $0x802aeb
  800570:	53                   	push   %ebx
  800571:	56                   	push   %esi
  800572:	e8 94 fe ff ff       	call   80040b <printfmt>
  800577:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80057d:	e9 cc fe ff ff       	jmp    80044e <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  800582:	52                   	push   %edx
  800583:	68 15 30 80 00       	push   $0x803015
  800588:	53                   	push   %ebx
  800589:	56                   	push   %esi
  80058a:	e8 7c fe ff ff       	call   80040b <printfmt>
  80058f:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800592:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800595:	e9 b4 fe ff ff       	jmp    80044e <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8d 50 04             	lea    0x4(%eax),%edx
  8005a0:	89 55 14             	mov    %edx,0x14(%ebp)
  8005a3:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8005a5:	85 ff                	test   %edi,%edi
  8005a7:	b8 e4 2a 80 00       	mov    $0x802ae4,%eax
  8005ac:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8005af:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005b3:	0f 8e 94 00 00 00    	jle    80064d <vprintfmt+0x225>
  8005b9:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8005bd:	0f 84 98 00 00 00    	je     80065b <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c3:	83 ec 08             	sub    $0x8,%esp
  8005c6:	ff 75 d0             	pushl  -0x30(%ebp)
  8005c9:	57                   	push   %edi
  8005ca:	e8 41 02 00 00       	call   800810 <strnlen>
  8005cf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005d2:	29 c1                	sub    %eax,%ecx
  8005d4:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8005d7:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005da:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005de:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005e1:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005e4:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e6:	eb 0f                	jmp    8005f7 <vprintfmt+0x1cf>
					putch(padc, putdat);
  8005e8:	83 ec 08             	sub    $0x8,%esp
  8005eb:	53                   	push   %ebx
  8005ec:	ff 75 e0             	pushl  -0x20(%ebp)
  8005ef:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f1:	83 ef 01             	sub    $0x1,%edi
  8005f4:	83 c4 10             	add    $0x10,%esp
  8005f7:	85 ff                	test   %edi,%edi
  8005f9:	7f ed                	jg     8005e8 <vprintfmt+0x1c0>
  8005fb:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005fe:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800601:	85 c9                	test   %ecx,%ecx
  800603:	b8 00 00 00 00       	mov    $0x0,%eax
  800608:	0f 49 c1             	cmovns %ecx,%eax
  80060b:	29 c1                	sub    %eax,%ecx
  80060d:	89 75 08             	mov    %esi,0x8(%ebp)
  800610:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800613:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800616:	89 cb                	mov    %ecx,%ebx
  800618:	eb 4d                	jmp    800667 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80061a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80061e:	74 1b                	je     80063b <vprintfmt+0x213>
  800620:	0f be c0             	movsbl %al,%eax
  800623:	83 e8 20             	sub    $0x20,%eax
  800626:	83 f8 5e             	cmp    $0x5e,%eax
  800629:	76 10                	jbe    80063b <vprintfmt+0x213>
					putch('?', putdat);
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	ff 75 0c             	pushl  0xc(%ebp)
  800631:	6a 3f                	push   $0x3f
  800633:	ff 55 08             	call   *0x8(%ebp)
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	eb 0d                	jmp    800648 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  80063b:	83 ec 08             	sub    $0x8,%esp
  80063e:	ff 75 0c             	pushl  0xc(%ebp)
  800641:	52                   	push   %edx
  800642:	ff 55 08             	call   *0x8(%ebp)
  800645:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800648:	83 eb 01             	sub    $0x1,%ebx
  80064b:	eb 1a                	jmp    800667 <vprintfmt+0x23f>
  80064d:	89 75 08             	mov    %esi,0x8(%ebp)
  800650:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800653:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800656:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800659:	eb 0c                	jmp    800667 <vprintfmt+0x23f>
  80065b:	89 75 08             	mov    %esi,0x8(%ebp)
  80065e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800661:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800664:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800667:	83 c7 01             	add    $0x1,%edi
  80066a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80066e:	0f be d0             	movsbl %al,%edx
  800671:	85 d2                	test   %edx,%edx
  800673:	74 23                	je     800698 <vprintfmt+0x270>
  800675:	85 f6                	test   %esi,%esi
  800677:	78 a1                	js     80061a <vprintfmt+0x1f2>
  800679:	83 ee 01             	sub    $0x1,%esi
  80067c:	79 9c                	jns    80061a <vprintfmt+0x1f2>
  80067e:	89 df                	mov    %ebx,%edi
  800680:	8b 75 08             	mov    0x8(%ebp),%esi
  800683:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800686:	eb 18                	jmp    8006a0 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800688:	83 ec 08             	sub    $0x8,%esp
  80068b:	53                   	push   %ebx
  80068c:	6a 20                	push   $0x20
  80068e:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800690:	83 ef 01             	sub    $0x1,%edi
  800693:	83 c4 10             	add    $0x10,%esp
  800696:	eb 08                	jmp    8006a0 <vprintfmt+0x278>
  800698:	89 df                	mov    %ebx,%edi
  80069a:	8b 75 08             	mov    0x8(%ebp),%esi
  80069d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006a0:	85 ff                	test   %edi,%edi
  8006a2:	7f e4                	jg     800688 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006a7:	e9 a2 fd ff ff       	jmp    80044e <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006ac:	8d 45 14             	lea    0x14(%ebp),%eax
  8006af:	e8 08 fd ff ff       	call   8003bc <getint>
  8006b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006ba:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006bf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006c3:	79 74                	jns    800739 <vprintfmt+0x311>
				putch('-', putdat);
  8006c5:	83 ec 08             	sub    $0x8,%esp
  8006c8:	53                   	push   %ebx
  8006c9:	6a 2d                	push   $0x2d
  8006cb:	ff d6                	call   *%esi
				num = -(long long) num;
  8006cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006d0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006d3:	f7 d8                	neg    %eax
  8006d5:	83 d2 00             	adc    $0x0,%edx
  8006d8:	f7 da                	neg    %edx
  8006da:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8006dd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006e2:	eb 55                	jmp    800739 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006e4:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e7:	e8 96 fc ff ff       	call   800382 <getuint>
			base = 10;
  8006ec:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006f1:	eb 46                	jmp    800739 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8006f3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f6:	e8 87 fc ff ff       	call   800382 <getuint>
			base = 8;
  8006fb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800700:	eb 37                	jmp    800739 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  800702:	83 ec 08             	sub    $0x8,%esp
  800705:	53                   	push   %ebx
  800706:	6a 30                	push   $0x30
  800708:	ff d6                	call   *%esi
			putch('x', putdat);
  80070a:	83 c4 08             	add    $0x8,%esp
  80070d:	53                   	push   %ebx
  80070e:	6a 78                	push   $0x78
  800710:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	8d 50 04             	lea    0x4(%eax),%edx
  800718:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80071b:	8b 00                	mov    (%eax),%eax
  80071d:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800722:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800725:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80072a:	eb 0d                	jmp    800739 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80072c:	8d 45 14             	lea    0x14(%ebp),%eax
  80072f:	e8 4e fc ff ff       	call   800382 <getuint>
			base = 16;
  800734:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800739:	83 ec 0c             	sub    $0xc,%esp
  80073c:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800740:	57                   	push   %edi
  800741:	ff 75 e0             	pushl  -0x20(%ebp)
  800744:	51                   	push   %ecx
  800745:	52                   	push   %edx
  800746:	50                   	push   %eax
  800747:	89 da                	mov    %ebx,%edx
  800749:	89 f0                	mov    %esi,%eax
  80074b:	e8 83 fb ff ff       	call   8002d3 <printnum>
			break;
  800750:	83 c4 20             	add    $0x20,%esp
  800753:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800756:	e9 f3 fc ff ff       	jmp    80044e <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80075b:	83 ec 08             	sub    $0x8,%esp
  80075e:	53                   	push   %ebx
  80075f:	51                   	push   %ecx
  800760:	ff d6                	call   *%esi
			break;
  800762:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800765:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800768:	e9 e1 fc ff ff       	jmp    80044e <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80076d:	83 ec 08             	sub    $0x8,%esp
  800770:	53                   	push   %ebx
  800771:	6a 25                	push   $0x25
  800773:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800775:	83 c4 10             	add    $0x10,%esp
  800778:	eb 03                	jmp    80077d <vprintfmt+0x355>
  80077a:	83 ef 01             	sub    $0x1,%edi
  80077d:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  800781:	75 f7                	jne    80077a <vprintfmt+0x352>
  800783:	e9 c6 fc ff ff       	jmp    80044e <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  800788:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80078b:	5b                   	pop    %ebx
  80078c:	5e                   	pop    %esi
  80078d:	5f                   	pop    %edi
  80078e:	5d                   	pop    %ebp
  80078f:	c3                   	ret    

00800790 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	83 ec 18             	sub    $0x18,%esp
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80079c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80079f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007a3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007ad:	85 c0                	test   %eax,%eax
  8007af:	74 26                	je     8007d7 <vsnprintf+0x47>
  8007b1:	85 d2                	test   %edx,%edx
  8007b3:	7e 22                	jle    8007d7 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007b5:	ff 75 14             	pushl  0x14(%ebp)
  8007b8:	ff 75 10             	pushl  0x10(%ebp)
  8007bb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007be:	50                   	push   %eax
  8007bf:	68 ee 03 80 00       	push   $0x8003ee
  8007c4:	e8 5f fc ff ff       	call   800428 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007cc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007d2:	83 c4 10             	add    $0x10,%esp
  8007d5:	eb 05                	jmp    8007dc <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007dc:	c9                   	leave  
  8007dd:	c3                   	ret    

008007de <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007de:	55                   	push   %ebp
  8007df:	89 e5                	mov    %esp,%ebp
  8007e1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007e4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007e7:	50                   	push   %eax
  8007e8:	ff 75 10             	pushl  0x10(%ebp)
  8007eb:	ff 75 0c             	pushl  0xc(%ebp)
  8007ee:	ff 75 08             	pushl  0x8(%ebp)
  8007f1:	e8 9a ff ff ff       	call   800790 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007f6:	c9                   	leave  
  8007f7:	c3                   	ret    

008007f8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800803:	eb 03                	jmp    800808 <strlen+0x10>
		n++;
  800805:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800808:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80080c:	75 f7                	jne    800805 <strlen+0xd>
		n++;
	return n;
}
  80080e:	5d                   	pop    %ebp
  80080f:	c3                   	ret    

00800810 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800810:	55                   	push   %ebp
  800811:	89 e5                	mov    %esp,%ebp
  800813:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800816:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800819:	ba 00 00 00 00       	mov    $0x0,%edx
  80081e:	eb 03                	jmp    800823 <strnlen+0x13>
		n++;
  800820:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800823:	39 c2                	cmp    %eax,%edx
  800825:	74 08                	je     80082f <strnlen+0x1f>
  800827:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80082b:	75 f3                	jne    800820 <strnlen+0x10>
  80082d:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  80082f:	5d                   	pop    %ebp
  800830:	c3                   	ret    

00800831 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	53                   	push   %ebx
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  800838:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80083b:	89 c2                	mov    %eax,%edx
  80083d:	83 c2 01             	add    $0x1,%edx
  800840:	83 c1 01             	add    $0x1,%ecx
  800843:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800847:	88 5a ff             	mov    %bl,-0x1(%edx)
  80084a:	84 db                	test   %bl,%bl
  80084c:	75 ef                	jne    80083d <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80084e:	5b                   	pop    %ebx
  80084f:	5d                   	pop    %ebp
  800850:	c3                   	ret    

00800851 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
  800854:	53                   	push   %ebx
  800855:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800858:	53                   	push   %ebx
  800859:	e8 9a ff ff ff       	call   8007f8 <strlen>
  80085e:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800861:	ff 75 0c             	pushl  0xc(%ebp)
  800864:	01 d8                	add    %ebx,%eax
  800866:	50                   	push   %eax
  800867:	e8 c5 ff ff ff       	call   800831 <strcpy>
	return dst;
}
  80086c:	89 d8                	mov    %ebx,%eax
  80086e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800871:	c9                   	leave  
  800872:	c3                   	ret    

00800873 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800873:	55                   	push   %ebp
  800874:	89 e5                	mov    %esp,%ebp
  800876:	56                   	push   %esi
  800877:	53                   	push   %ebx
  800878:	8b 75 08             	mov    0x8(%ebp),%esi
  80087b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80087e:	89 f3                	mov    %esi,%ebx
  800880:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800883:	89 f2                	mov    %esi,%edx
  800885:	eb 0f                	jmp    800896 <strncpy+0x23>
		*dst++ = *src;
  800887:	83 c2 01             	add    $0x1,%edx
  80088a:	0f b6 01             	movzbl (%ecx),%eax
  80088d:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800890:	80 39 01             	cmpb   $0x1,(%ecx)
  800893:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800896:	39 da                	cmp    %ebx,%edx
  800898:	75 ed                	jne    800887 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80089a:	89 f0                	mov    %esi,%eax
  80089c:	5b                   	pop    %ebx
  80089d:	5e                   	pop    %esi
  80089e:	5d                   	pop    %ebp
  80089f:	c3                   	ret    

008008a0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	56                   	push   %esi
  8008a4:	53                   	push   %ebx
  8008a5:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ab:	8b 55 10             	mov    0x10(%ebp),%edx
  8008ae:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008b0:	85 d2                	test   %edx,%edx
  8008b2:	74 21                	je     8008d5 <strlcpy+0x35>
  8008b4:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008b8:	89 f2                	mov    %esi,%edx
  8008ba:	eb 09                	jmp    8008c5 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008bc:	83 c2 01             	add    $0x1,%edx
  8008bf:	83 c1 01             	add    $0x1,%ecx
  8008c2:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008c5:	39 c2                	cmp    %eax,%edx
  8008c7:	74 09                	je     8008d2 <strlcpy+0x32>
  8008c9:	0f b6 19             	movzbl (%ecx),%ebx
  8008cc:	84 db                	test   %bl,%bl
  8008ce:	75 ec                	jne    8008bc <strlcpy+0x1c>
  8008d0:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  8008d2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008d5:	29 f0                	sub    %esi,%eax
}
  8008d7:	5b                   	pop    %ebx
  8008d8:	5e                   	pop    %esi
  8008d9:	5d                   	pop    %ebp
  8008da:	c3                   	ret    

008008db <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008e4:	eb 06                	jmp    8008ec <strcmp+0x11>
		p++, q++;
  8008e6:	83 c1 01             	add    $0x1,%ecx
  8008e9:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008ec:	0f b6 01             	movzbl (%ecx),%eax
  8008ef:	84 c0                	test   %al,%al
  8008f1:	74 04                	je     8008f7 <strcmp+0x1c>
  8008f3:	3a 02                	cmp    (%edx),%al
  8008f5:	74 ef                	je     8008e6 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008f7:	0f b6 c0             	movzbl %al,%eax
  8008fa:	0f b6 12             	movzbl (%edx),%edx
  8008fd:	29 d0                	sub    %edx,%eax
}
  8008ff:	5d                   	pop    %ebp
  800900:	c3                   	ret    

00800901 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	53                   	push   %ebx
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090b:	89 c3                	mov    %eax,%ebx
  80090d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800910:	eb 06                	jmp    800918 <strncmp+0x17>
		n--, p++, q++;
  800912:	83 c0 01             	add    $0x1,%eax
  800915:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800918:	39 d8                	cmp    %ebx,%eax
  80091a:	74 15                	je     800931 <strncmp+0x30>
  80091c:	0f b6 08             	movzbl (%eax),%ecx
  80091f:	84 c9                	test   %cl,%cl
  800921:	74 04                	je     800927 <strncmp+0x26>
  800923:	3a 0a                	cmp    (%edx),%cl
  800925:	74 eb                	je     800912 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800927:	0f b6 00             	movzbl (%eax),%eax
  80092a:	0f b6 12             	movzbl (%edx),%edx
  80092d:	29 d0                	sub    %edx,%eax
  80092f:	eb 05                	jmp    800936 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800931:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800936:	5b                   	pop    %ebx
  800937:	5d                   	pop    %ebp
  800938:	c3                   	ret    

00800939 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800943:	eb 07                	jmp    80094c <strchr+0x13>
		if (*s == c)
  800945:	38 ca                	cmp    %cl,%dl
  800947:	74 0f                	je     800958 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800949:	83 c0 01             	add    $0x1,%eax
  80094c:	0f b6 10             	movzbl (%eax),%edx
  80094f:	84 d2                	test   %dl,%dl
  800951:	75 f2                	jne    800945 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800953:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800964:	eb 03                	jmp    800969 <strfind+0xf>
  800966:	83 c0 01             	add    $0x1,%eax
  800969:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80096c:	38 ca                	cmp    %cl,%dl
  80096e:	74 04                	je     800974 <strfind+0x1a>
  800970:	84 d2                	test   %dl,%dl
  800972:	75 f2                	jne    800966 <strfind+0xc>
			break;
	return (char *) s;
}
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	57                   	push   %edi
  80097a:	56                   	push   %esi
  80097b:	53                   	push   %ebx
  80097c:	8b 55 08             	mov    0x8(%ebp),%edx
  80097f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800982:	85 c9                	test   %ecx,%ecx
  800984:	74 37                	je     8009bd <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800986:	f6 c2 03             	test   $0x3,%dl
  800989:	75 2a                	jne    8009b5 <memset+0x3f>
  80098b:	f6 c1 03             	test   $0x3,%cl
  80098e:	75 25                	jne    8009b5 <memset+0x3f>
		c &= 0xFF;
  800990:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800994:	89 df                	mov    %ebx,%edi
  800996:	c1 e7 08             	shl    $0x8,%edi
  800999:	89 de                	mov    %ebx,%esi
  80099b:	c1 e6 18             	shl    $0x18,%esi
  80099e:	89 d8                	mov    %ebx,%eax
  8009a0:	c1 e0 10             	shl    $0x10,%eax
  8009a3:	09 f0                	or     %esi,%eax
  8009a5:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8009a7:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8009aa:	89 f8                	mov    %edi,%eax
  8009ac:	09 d8                	or     %ebx,%eax
  8009ae:	89 d7                	mov    %edx,%edi
  8009b0:	fc                   	cld    
  8009b1:	f3 ab                	rep stos %eax,%es:(%edi)
  8009b3:	eb 08                	jmp    8009bd <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009b5:	89 d7                	mov    %edx,%edi
  8009b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ba:	fc                   	cld    
  8009bb:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8009bd:	89 d0                	mov    %edx,%eax
  8009bf:	5b                   	pop    %ebx
  8009c0:	5e                   	pop    %esi
  8009c1:	5f                   	pop    %edi
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	57                   	push   %edi
  8009c8:	56                   	push   %esi
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009d2:	39 c6                	cmp    %eax,%esi
  8009d4:	73 35                	jae    800a0b <memmove+0x47>
  8009d6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009d9:	39 d0                	cmp    %edx,%eax
  8009db:	73 2e                	jae    800a0b <memmove+0x47>
		s += n;
		d += n;
  8009dd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e0:	89 d6                	mov    %edx,%esi
  8009e2:	09 fe                	or     %edi,%esi
  8009e4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009ea:	75 13                	jne    8009ff <memmove+0x3b>
  8009ec:	f6 c1 03             	test   $0x3,%cl
  8009ef:	75 0e                	jne    8009ff <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  8009f1:	83 ef 04             	sub    $0x4,%edi
  8009f4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009f7:	c1 e9 02             	shr    $0x2,%ecx
  8009fa:	fd                   	std    
  8009fb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009fd:	eb 09                	jmp    800a08 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009ff:	83 ef 01             	sub    $0x1,%edi
  800a02:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a05:	fd                   	std    
  800a06:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a08:	fc                   	cld    
  800a09:	eb 1d                	jmp    800a28 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a0b:	89 f2                	mov    %esi,%edx
  800a0d:	09 c2                	or     %eax,%edx
  800a0f:	f6 c2 03             	test   $0x3,%dl
  800a12:	75 0f                	jne    800a23 <memmove+0x5f>
  800a14:	f6 c1 03             	test   $0x3,%cl
  800a17:	75 0a                	jne    800a23 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  800a19:	c1 e9 02             	shr    $0x2,%ecx
  800a1c:	89 c7                	mov    %eax,%edi
  800a1e:	fc                   	cld    
  800a1f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a21:	eb 05                	jmp    800a28 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a23:	89 c7                	mov    %eax,%edi
  800a25:	fc                   	cld    
  800a26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a28:	5e                   	pop    %esi
  800a29:	5f                   	pop    %edi
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    

00800a2c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a2f:	ff 75 10             	pushl  0x10(%ebp)
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	ff 75 08             	pushl  0x8(%ebp)
  800a38:	e8 87 ff ff ff       	call   8009c4 <memmove>
}
  800a3d:	c9                   	leave  
  800a3e:	c3                   	ret    

00800a3f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	56                   	push   %esi
  800a43:	53                   	push   %ebx
  800a44:	8b 45 08             	mov    0x8(%ebp),%eax
  800a47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4a:	89 c6                	mov    %eax,%esi
  800a4c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a4f:	eb 1a                	jmp    800a6b <memcmp+0x2c>
		if (*s1 != *s2)
  800a51:	0f b6 08             	movzbl (%eax),%ecx
  800a54:	0f b6 1a             	movzbl (%edx),%ebx
  800a57:	38 d9                	cmp    %bl,%cl
  800a59:	74 0a                	je     800a65 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a5b:	0f b6 c1             	movzbl %cl,%eax
  800a5e:	0f b6 db             	movzbl %bl,%ebx
  800a61:	29 d8                	sub    %ebx,%eax
  800a63:	eb 0f                	jmp    800a74 <memcmp+0x35>
		s1++, s2++;
  800a65:	83 c0 01             	add    $0x1,%eax
  800a68:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a6b:	39 f0                	cmp    %esi,%eax
  800a6d:	75 e2                	jne    800a51 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a74:	5b                   	pop    %ebx
  800a75:	5e                   	pop    %esi
  800a76:	5d                   	pop    %ebp
  800a77:	c3                   	ret    

00800a78 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	53                   	push   %ebx
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800a7f:	89 c1                	mov    %eax,%ecx
  800a81:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  800a84:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a88:	eb 0a                	jmp    800a94 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a8a:	0f b6 10             	movzbl (%eax),%edx
  800a8d:	39 da                	cmp    %ebx,%edx
  800a8f:	74 07                	je     800a98 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a91:	83 c0 01             	add    $0x1,%eax
  800a94:	39 c8                	cmp    %ecx,%eax
  800a96:	72 f2                	jb     800a8a <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a98:	5b                   	pop    %ebx
  800a99:	5d                   	pop    %ebp
  800a9a:	c3                   	ret    

00800a9b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	57                   	push   %edi
  800a9f:	56                   	push   %esi
  800aa0:	53                   	push   %ebx
  800aa1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aa4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aa7:	eb 03                	jmp    800aac <strtol+0x11>
		s++;
  800aa9:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aac:	0f b6 01             	movzbl (%ecx),%eax
  800aaf:	3c 20                	cmp    $0x20,%al
  800ab1:	74 f6                	je     800aa9 <strtol+0xe>
  800ab3:	3c 09                	cmp    $0x9,%al
  800ab5:	74 f2                	je     800aa9 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ab7:	3c 2b                	cmp    $0x2b,%al
  800ab9:	75 0a                	jne    800ac5 <strtol+0x2a>
		s++;
  800abb:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800abe:	bf 00 00 00 00       	mov    $0x0,%edi
  800ac3:	eb 11                	jmp    800ad6 <strtol+0x3b>
  800ac5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800aca:	3c 2d                	cmp    $0x2d,%al
  800acc:	75 08                	jne    800ad6 <strtol+0x3b>
		s++, neg = 1;
  800ace:	83 c1 01             	add    $0x1,%ecx
  800ad1:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800adc:	75 15                	jne    800af3 <strtol+0x58>
  800ade:	80 39 30             	cmpb   $0x30,(%ecx)
  800ae1:	75 10                	jne    800af3 <strtol+0x58>
  800ae3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ae7:	75 7c                	jne    800b65 <strtol+0xca>
		s += 2, base = 16;
  800ae9:	83 c1 02             	add    $0x2,%ecx
  800aec:	bb 10 00 00 00       	mov    $0x10,%ebx
  800af1:	eb 16                	jmp    800b09 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800af3:	85 db                	test   %ebx,%ebx
  800af5:	75 12                	jne    800b09 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800af7:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800afc:	80 39 30             	cmpb   $0x30,(%ecx)
  800aff:	75 08                	jne    800b09 <strtol+0x6e>
		s++, base = 8;
  800b01:	83 c1 01             	add    $0x1,%ecx
  800b04:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800b09:	b8 00 00 00 00       	mov    $0x0,%eax
  800b0e:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b11:	0f b6 11             	movzbl (%ecx),%edx
  800b14:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b17:	89 f3                	mov    %esi,%ebx
  800b19:	80 fb 09             	cmp    $0x9,%bl
  800b1c:	77 08                	ja     800b26 <strtol+0x8b>
			dig = *s - '0';
  800b1e:	0f be d2             	movsbl %dl,%edx
  800b21:	83 ea 30             	sub    $0x30,%edx
  800b24:	eb 22                	jmp    800b48 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800b26:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b29:	89 f3                	mov    %esi,%ebx
  800b2b:	80 fb 19             	cmp    $0x19,%bl
  800b2e:	77 08                	ja     800b38 <strtol+0x9d>
			dig = *s - 'a' + 10;
  800b30:	0f be d2             	movsbl %dl,%edx
  800b33:	83 ea 57             	sub    $0x57,%edx
  800b36:	eb 10                	jmp    800b48 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800b38:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b3b:	89 f3                	mov    %esi,%ebx
  800b3d:	80 fb 19             	cmp    $0x19,%bl
  800b40:	77 16                	ja     800b58 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800b42:	0f be d2             	movsbl %dl,%edx
  800b45:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800b48:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b4b:	7d 0b                	jge    800b58 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800b4d:	83 c1 01             	add    $0x1,%ecx
  800b50:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b54:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800b56:	eb b9                	jmp    800b11 <strtol+0x76>

	if (endptr)
  800b58:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5c:	74 0d                	je     800b6b <strtol+0xd0>
		*endptr = (char *) s;
  800b5e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b61:	89 0e                	mov    %ecx,(%esi)
  800b63:	eb 06                	jmp    800b6b <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b65:	85 db                	test   %ebx,%ebx
  800b67:	74 98                	je     800b01 <strtol+0x66>
  800b69:	eb 9e                	jmp    800b09 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800b6b:	89 c2                	mov    %eax,%edx
  800b6d:	f7 da                	neg    %edx
  800b6f:	85 ff                	test   %edi,%edi
  800b71:	0f 45 c2             	cmovne %edx,%eax
}
  800b74:	5b                   	pop    %ebx
  800b75:	5e                   	pop    %esi
  800b76:	5f                   	pop    %edi
  800b77:	5d                   	pop    %ebp
  800b78:	c3                   	ret    

00800b79 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	57                   	push   %edi
  800b7d:	56                   	push   %esi
  800b7e:	53                   	push   %ebx
  800b7f:	83 ec 1c             	sub    $0x1c,%esp
  800b82:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b85:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b88:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b8d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b90:	8b 7d 10             	mov    0x10(%ebp),%edi
  800b93:	8b 75 14             	mov    0x14(%ebp),%esi
  800b96:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800b98:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b9c:	74 1d                	je     800bbb <syscall+0x42>
  800b9e:	85 c0                	test   %eax,%eax
  800ba0:	7e 19                	jle    800bbb <syscall+0x42>
  800ba2:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800ba5:	83 ec 0c             	sub    $0xc,%esp
  800ba8:	50                   	push   %eax
  800ba9:	52                   	push   %edx
  800baa:	68 df 2d 80 00       	push   $0x802ddf
  800baf:	6a 23                	push   $0x23
  800bb1:	68 fc 2d 80 00       	push   $0x802dfc
  800bb6:	e8 2b f6 ff ff       	call   8001e6 <_panic>

	return ret;
}
  800bbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bbe:	5b                   	pop    %ebx
  800bbf:	5e                   	pop    %esi
  800bc0:	5f                   	pop    %edi
  800bc1:	5d                   	pop    %ebp
  800bc2:	c3                   	ret    

00800bc3 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800bc9:	6a 00                	push   $0x0
  800bcb:	6a 00                	push   $0x0
  800bcd:	6a 00                	push   $0x0
  800bcf:	ff 75 0c             	pushl  0xc(%ebp)
  800bd2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd5:	ba 00 00 00 00       	mov    $0x0,%edx
  800bda:	b8 00 00 00 00       	mov    $0x0,%eax
  800bdf:	e8 95 ff ff ff       	call   800b79 <syscall>
}
  800be4:	83 c4 10             	add    $0x10,%esp
  800be7:	c9                   	leave  
  800be8:	c3                   	ret    

00800be9 <sys_cgetc>:

int
sys_cgetc(void)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800bef:	6a 00                	push   $0x0
  800bf1:	6a 00                	push   $0x0
  800bf3:	6a 00                	push   $0x0
  800bf5:	6a 00                	push   $0x0
  800bf7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bfc:	ba 00 00 00 00       	mov    $0x0,%edx
  800c01:	b8 01 00 00 00       	mov    $0x1,%eax
  800c06:	e8 6e ff ff ff       	call   800b79 <syscall>
}
  800c0b:	c9                   	leave  
  800c0c:	c3                   	ret    

00800c0d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800c13:	6a 00                	push   $0x0
  800c15:	6a 00                	push   $0x0
  800c17:	6a 00                	push   $0x0
  800c19:	6a 00                	push   $0x0
  800c1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c1e:	ba 01 00 00 00       	mov    $0x1,%edx
  800c23:	b8 03 00 00 00       	mov    $0x3,%eax
  800c28:	e8 4c ff ff ff       	call   800b79 <syscall>
}
  800c2d:	c9                   	leave  
  800c2e:	c3                   	ret    

00800c2f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800c35:	6a 00                	push   $0x0
  800c37:	6a 00                	push   $0x0
  800c39:	6a 00                	push   $0x0
  800c3b:	6a 00                	push   $0x0
  800c3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c42:	ba 00 00 00 00       	mov    $0x0,%edx
  800c47:	b8 02 00 00 00       	mov    $0x2,%eax
  800c4c:	e8 28 ff ff ff       	call   800b79 <syscall>
}
  800c51:	c9                   	leave  
  800c52:	c3                   	ret    

00800c53 <sys_yield>:

void
sys_yield(void)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800c59:	6a 00                	push   $0x0
  800c5b:	6a 00                	push   $0x0
  800c5d:	6a 00                	push   $0x0
  800c5f:	6a 00                	push   $0x0
  800c61:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c66:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c70:	e8 04 ff ff ff       	call   800b79 <syscall>
}
  800c75:	83 c4 10             	add    $0x10,%esp
  800c78:	c9                   	leave  
  800c79:	c3                   	ret    

00800c7a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800c80:	6a 00                	push   $0x0
  800c82:	6a 00                	push   $0x0
  800c84:	ff 75 10             	pushl  0x10(%ebp)
  800c87:	ff 75 0c             	pushl  0xc(%ebp)
  800c8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c8d:	ba 01 00 00 00       	mov    $0x1,%edx
  800c92:	b8 04 00 00 00       	mov    $0x4,%eax
  800c97:	e8 dd fe ff ff       	call   800b79 <syscall>
}
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    

00800c9e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800ca4:	ff 75 18             	pushl  0x18(%ebp)
  800ca7:	ff 75 14             	pushl  0x14(%ebp)
  800caa:	ff 75 10             	pushl  0x10(%ebp)
  800cad:	ff 75 0c             	pushl  0xc(%ebp)
  800cb0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cb3:	ba 01 00 00 00       	mov    $0x1,%edx
  800cb8:	b8 05 00 00 00       	mov    $0x5,%eax
  800cbd:	e8 b7 fe ff ff       	call   800b79 <syscall>
}
  800cc2:	c9                   	leave  
  800cc3:	c3                   	ret    

00800cc4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800cca:	6a 00                	push   $0x0
  800ccc:	6a 00                	push   $0x0
  800cce:	6a 00                	push   $0x0
  800cd0:	ff 75 0c             	pushl  0xc(%ebp)
  800cd3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd6:	ba 01 00 00 00       	mov    $0x1,%edx
  800cdb:	b8 06 00 00 00       	mov    $0x6,%eax
  800ce0:	e8 94 fe ff ff       	call   800b79 <syscall>
}
  800ce5:	c9                   	leave  
  800ce6:	c3                   	ret    

00800ce7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800ced:	6a 00                	push   $0x0
  800cef:	6a 00                	push   $0x0
  800cf1:	6a 00                	push   $0x0
  800cf3:	ff 75 0c             	pushl  0xc(%ebp)
  800cf6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cf9:	ba 01 00 00 00       	mov    $0x1,%edx
  800cfe:	b8 08 00 00 00       	mov    $0x8,%eax
  800d03:	e8 71 fe ff ff       	call   800b79 <syscall>
}
  800d08:	c9                   	leave  
  800d09:	c3                   	ret    

00800d0a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
  800d0d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800d10:	6a 00                	push   $0x0
  800d12:	6a 00                	push   $0x0
  800d14:	6a 00                	push   $0x0
  800d16:	ff 75 0c             	pushl  0xc(%ebp)
  800d19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d1c:	ba 01 00 00 00       	mov    $0x1,%edx
  800d21:	b8 09 00 00 00       	mov    $0x9,%eax
  800d26:	e8 4e fe ff ff       	call   800b79 <syscall>
}
  800d2b:	c9                   	leave  
  800d2c:	c3                   	ret    

00800d2d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800d33:	6a 00                	push   $0x0
  800d35:	6a 00                	push   $0x0
  800d37:	6a 00                	push   $0x0
  800d39:	ff 75 0c             	pushl  0xc(%ebp)
  800d3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d3f:	ba 01 00 00 00       	mov    $0x1,%edx
  800d44:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d49:	e8 2b fe ff ff       	call   800b79 <syscall>
}
  800d4e:	c9                   	leave  
  800d4f:	c3                   	ret    

00800d50 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800d56:	6a 00                	push   $0x0
  800d58:	ff 75 14             	pushl  0x14(%ebp)
  800d5b:	ff 75 10             	pushl  0x10(%ebp)
  800d5e:	ff 75 0c             	pushl  0xc(%ebp)
  800d61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d64:	ba 00 00 00 00       	mov    $0x0,%edx
  800d69:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d6e:	e8 06 fe ff ff       	call   800b79 <syscall>
}
  800d73:	c9                   	leave  
  800d74:	c3                   	ret    

00800d75 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800d7b:	6a 00                	push   $0x0
  800d7d:	6a 00                	push   $0x0
  800d7f:	6a 00                	push   $0x0
  800d81:	6a 00                	push   $0x0
  800d83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d86:	ba 01 00 00 00       	mov    $0x1,%edx
  800d8b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d90:	e8 e4 fd ff ff       	call   800b79 <syscall>
}
  800d95:	c9                   	leave  
  800d96:	c3                   	ret    

00800d97 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	53                   	push   %ebx
  800d9b:	83 ec 04             	sub    $0x4,%esp

	int perm_w = PTE_COW|PTE_U|PTE_P;
	int perm = PTE_U|PTE_P;

	// LAB 4: Your code here.
	void *addr = (void*) (pn*PGSIZE);
  800d9e:	89 d3                	mov    %edx,%ebx
  800da0:	c1 e3 0c             	shl    $0xc,%ebx

	//Si una página tiene el bit PTE_SHARE, se comparte con el hijo con los mismos permisos.
  	if (uvpt[pn] & PTE_SHARE) {
  800da3:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800daa:	f6 c5 04             	test   $0x4,%ch
  800dad:	74 3a                	je     800de9 <duppage+0x52>
    	if (sys_page_map(0, addr, envid,addr, uvpt[pn] & PTE_SYSCALL) < 0) {
  800daf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800db6:	83 ec 0c             	sub    $0xc,%esp
  800db9:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800dbf:	52                   	push   %edx
  800dc0:	53                   	push   %ebx
  800dc1:	50                   	push   %eax
  800dc2:	53                   	push   %ebx
  800dc3:	6a 00                	push   $0x0
  800dc5:	e8 d4 fe ff ff       	call   800c9e <sys_page_map>
  800dca:	83 c4 20             	add    $0x20,%esp
  800dcd:	85 c0                	test   %eax,%eax
  800dcf:	0f 89 99 00 00 00    	jns    800e6e <duppage+0xd7>
 	     	panic("Error en sys_page_map");
  800dd5:	83 ec 04             	sub    $0x4,%esp
  800dd8:	68 0a 2e 80 00       	push   $0x802e0a
  800ddd:	6a 50                	push   $0x50
  800ddf:	68 20 2e 80 00       	push   $0x802e20
  800de4:	e8 fd f3 ff ff       	call   8001e6 <_panic>
    	} 
    	return 0;
	}

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  800de9:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800df0:	f6 c1 02             	test   $0x2,%cl
  800df3:	75 0c                	jne    800e01 <duppage+0x6a>
  800df5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800dfc:	f6 c6 08             	test   $0x8,%dh
  800dff:	74 5b                	je     800e5c <duppage+0xc5>
		if (sys_page_map(0, addr, envid, addr, perm_w) < 0){
  800e01:	83 ec 0c             	sub    $0xc,%esp
  800e04:	68 05 08 00 00       	push   $0x805
  800e09:	53                   	push   %ebx
  800e0a:	50                   	push   %eax
  800e0b:	53                   	push   %ebx
  800e0c:	6a 00                	push   $0x0
  800e0e:	e8 8b fe ff ff       	call   800c9e <sys_page_map>
  800e13:	83 c4 20             	add    $0x20,%esp
  800e16:	85 c0                	test   %eax,%eax
  800e18:	79 14                	jns    800e2e <duppage+0x97>
			panic("Error mapeando pagina Padre");
  800e1a:	83 ec 04             	sub    $0x4,%esp
  800e1d:	68 2b 2e 80 00       	push   $0x802e2b
  800e22:	6a 57                	push   $0x57
  800e24:	68 20 2e 80 00       	push   $0x802e20
  800e29:	e8 b8 f3 ff ff       	call   8001e6 <_panic>
		}
		if (sys_page_map(0, addr, 0, addr, perm_w) < 0){
  800e2e:	83 ec 0c             	sub    $0xc,%esp
  800e31:	68 05 08 00 00       	push   $0x805
  800e36:	53                   	push   %ebx
  800e37:	6a 00                	push   $0x0
  800e39:	53                   	push   %ebx
  800e3a:	6a 00                	push   $0x0
  800e3c:	e8 5d fe ff ff       	call   800c9e <sys_page_map>
  800e41:	83 c4 20             	add    $0x20,%esp
  800e44:	85 c0                	test   %eax,%eax
  800e46:	79 26                	jns    800e6e <duppage+0xd7>
			panic("Error mapeando pagina Hijo");
  800e48:	83 ec 04             	sub    $0x4,%esp
  800e4b:	68 47 2e 80 00       	push   $0x802e47
  800e50:	6a 5a                	push   $0x5a
  800e52:	68 20 2e 80 00       	push   $0x802e20
  800e57:	e8 8a f3 ff ff       	call   8001e6 <_panic>
		}
	} else sys_page_map(0, addr, envid, addr, perm);
  800e5c:	83 ec 0c             	sub    $0xc,%esp
  800e5f:	6a 05                	push   $0x5
  800e61:	53                   	push   %ebx
  800e62:	50                   	push   %eax
  800e63:	53                   	push   %ebx
  800e64:	6a 00                	push   $0x0
  800e66:	e8 33 fe ff ff       	call   800c9e <sys_page_map>
  800e6b:	83 c4 20             	add    $0x20,%esp
	
	return 0;
}
  800e6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e76:	c9                   	leave  
  800e77:	c3                   	ret    

00800e78 <dup_or_share>:
//FORK V0

static void
dup_or_share(envid_t dstenv, void *va, int perm){
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	57                   	push   %edi
  800e7c:	56                   	push   %esi
  800e7d:	53                   	push   %ebx
  800e7e:	83 ec 0c             	sub    $0xc,%esp
  800e81:	89 c7                	mov    %eax,%edi
  800e83:	89 d6                	mov    %edx,%esi
  800e85:	89 cb                	mov    %ecx,%ebx
	int result;
	// Si no es de escritura, comparto la pagina
	if((perm &PTE_W) != PTE_W){
  800e87:	f6 c1 02             	test   $0x2,%cl
  800e8a:	75 2d                	jne    800eb9 <dup_or_share+0x41>
		if((result = sys_page_map(0, va, dstenv, va, perm))<0){
  800e8c:	83 ec 0c             	sub    $0xc,%esp
  800e8f:	51                   	push   %ecx
  800e90:	52                   	push   %edx
  800e91:	50                   	push   %eax
  800e92:	52                   	push   %edx
  800e93:	6a 00                	push   $0x0
  800e95:	e8 04 fe ff ff       	call   800c9e <sys_page_map>
  800e9a:	83 c4 20             	add    $0x20,%esp
  800e9d:	85 c0                	test   %eax,%eax
  800e9f:	0f 89 a4 00 00 00    	jns    800f49 <dup_or_share+0xd1>
			panic("Error compartiendo la pagina");
  800ea5:	83 ec 04             	sub    $0x4,%esp
  800ea8:	68 62 2e 80 00       	push   $0x802e62
  800ead:	6a 68                	push   $0x68
  800eaf:	68 20 2e 80 00       	push   $0x802e20
  800eb4:	e8 2d f3 ff ff       	call   8001e6 <_panic>
		}
	// Si es de escritura comportamiento de duppage, en dumbfork
	}else{
		if ((result = sys_page_alloc(dstenv, va, perm)) < 0){
  800eb9:	83 ec 04             	sub    $0x4,%esp
  800ebc:	51                   	push   %ecx
  800ebd:	52                   	push   %edx
  800ebe:	50                   	push   %eax
  800ebf:	e8 b6 fd ff ff       	call   800c7a <sys_page_alloc>
  800ec4:	83 c4 10             	add    $0x10,%esp
  800ec7:	85 c0                	test   %eax,%eax
  800ec9:	79 14                	jns    800edf <dup_or_share+0x67>
			panic("Error copiando la pagina");
  800ecb:	83 ec 04             	sub    $0x4,%esp
  800ece:	68 7f 2e 80 00       	push   $0x802e7f
  800ed3:	6a 6d                	push   $0x6d
  800ed5:	68 20 2e 80 00       	push   $0x802e20
  800eda:	e8 07 f3 ff ff       	call   8001e6 <_panic>
		}
		if ((result = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0){
  800edf:	83 ec 0c             	sub    $0xc,%esp
  800ee2:	53                   	push   %ebx
  800ee3:	68 00 00 40 00       	push   $0x400000
  800ee8:	6a 00                	push   $0x0
  800eea:	56                   	push   %esi
  800eeb:	57                   	push   %edi
  800eec:	e8 ad fd ff ff       	call   800c9e <sys_page_map>
  800ef1:	83 c4 20             	add    $0x20,%esp
  800ef4:	85 c0                	test   %eax,%eax
  800ef6:	79 14                	jns    800f0c <dup_or_share+0x94>
			panic("Error copiando la pagina");
  800ef8:	83 ec 04             	sub    $0x4,%esp
  800efb:	68 7f 2e 80 00       	push   $0x802e7f
  800f00:	6a 70                	push   $0x70
  800f02:	68 20 2e 80 00       	push   $0x802e20
  800f07:	e8 da f2 ff ff       	call   8001e6 <_panic>
		}
		memmove(UTEMP, va, PGSIZE);
  800f0c:	83 ec 04             	sub    $0x4,%esp
  800f0f:	68 00 10 00 00       	push   $0x1000
  800f14:	56                   	push   %esi
  800f15:	68 00 00 40 00       	push   $0x400000
  800f1a:	e8 a5 fa ff ff       	call   8009c4 <memmove>
		if ((result = sys_page_unmap(0, UTEMP)) < 0){
  800f1f:	83 c4 08             	add    $0x8,%esp
  800f22:	68 00 00 40 00       	push   $0x400000
  800f27:	6a 00                	push   $0x0
  800f29:	e8 96 fd ff ff       	call   800cc4 <sys_page_unmap>
  800f2e:	83 c4 10             	add    $0x10,%esp
  800f31:	85 c0                	test   %eax,%eax
  800f33:	79 14                	jns    800f49 <dup_or_share+0xd1>
			panic("Error copiando la pagina");
  800f35:	83 ec 04             	sub    $0x4,%esp
  800f38:	68 7f 2e 80 00       	push   $0x802e7f
  800f3d:	6a 74                	push   $0x74
  800f3f:	68 20 2e 80 00       	push   $0x802e20
  800f44:	e8 9d f2 ff ff       	call   8001e6 <_panic>
		}
	}	
}
  800f49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4c:	5b                   	pop    %ebx
  800f4d:	5e                   	pop    %esi
  800f4e:	5f                   	pop    %edi
  800f4f:	5d                   	pop    %ebp
  800f50:	c3                   	ret    

00800f51 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	53                   	push   %ebx
  800f55:	83 ec 04             	sub    $0x4,%esp
  800f58:	8b 55 08             	mov    0x8(%ebp),%edx
	void *va = (void *) utf->utf_fault_va;
  800f5b:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800f5d:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  800f61:	74 2e                	je     800f91 <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
  800f63:	89 c2                	mov    %eax,%edx
  800f65:	c1 ea 16             	shr    $0x16,%edx
  800f68:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800f6f:	f6 c2 01             	test   $0x1,%dl
  800f72:	74 1d                	je     800f91 <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
  800f74:	89 c2                	mov    %eax,%edx
  800f76:	c1 ea 0c             	shr    $0xc,%edx
  800f79:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
		(uvpd[PDX(va)] & PTE_P) && 
  800f80:	f6 c1 01             	test   $0x1,%cl
  800f83:	74 0c                	je     800f91 <pgfault+0x40>
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
  800f85:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800f8c:	f6 c6 08             	test   $0x8,%dh
  800f8f:	75 14                	jne    800fa5 <pgfault+0x54>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
		panic("No es copy-on-write");
  800f91:	83 ec 04             	sub    $0x4,%esp
  800f94:	68 98 2e 80 00       	push   $0x802e98
  800f99:	6a 21                	push   $0x21
  800f9b:	68 20 2e 80 00       	push   $0x802e20
  800fa0:	e8 41 f2 ff ff       	call   8001e6 <_panic>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	va = ROUNDDOWN(va, PGSIZE);
  800fa5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800faa:	89 c3                	mov    %eax,%ebx
	if (sys_page_alloc(0, PFTEMP, perm) < 0){
  800fac:	83 ec 04             	sub    $0x4,%esp
  800faf:	6a 07                	push   $0x7
  800fb1:	68 00 f0 7f 00       	push   $0x7ff000
  800fb6:	6a 00                	push   $0x0
  800fb8:	e8 bd fc ff ff       	call   800c7a <sys_page_alloc>
  800fbd:	83 c4 10             	add    $0x10,%esp
  800fc0:	85 c0                	test   %eax,%eax
  800fc2:	79 14                	jns    800fd8 <pgfault+0x87>
		panic("Error sys_page_alloc");
  800fc4:	83 ec 04             	sub    $0x4,%esp
  800fc7:	68 ac 2e 80 00       	push   $0x802eac
  800fcc:	6a 2a                	push   $0x2a
  800fce:	68 20 2e 80 00       	push   $0x802e20
  800fd3:	e8 0e f2 ff ff       	call   8001e6 <_panic>
	}
	memcpy(PFTEMP, va, PGSIZE);
  800fd8:	83 ec 04             	sub    $0x4,%esp
  800fdb:	68 00 10 00 00       	push   $0x1000
  800fe0:	53                   	push   %ebx
  800fe1:	68 00 f0 7f 00       	push   $0x7ff000
  800fe6:	e8 41 fa ff ff       	call   800a2c <memcpy>
	if (sys_page_map(0, PFTEMP, 0, va, perm) < 0){
  800feb:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800ff2:	53                   	push   %ebx
  800ff3:	6a 00                	push   $0x0
  800ff5:	68 00 f0 7f 00       	push   $0x7ff000
  800ffa:	6a 00                	push   $0x0
  800ffc:	e8 9d fc ff ff       	call   800c9e <sys_page_map>
  801001:	83 c4 20             	add    $0x20,%esp
  801004:	85 c0                	test   %eax,%eax
  801006:	79 14                	jns    80101c <pgfault+0xcb>
		panic("Error sys_page_map");
  801008:	83 ec 04             	sub    $0x4,%esp
  80100b:	68 c1 2e 80 00       	push   $0x802ec1
  801010:	6a 2e                	push   $0x2e
  801012:	68 20 2e 80 00       	push   $0x802e20
  801017:	e8 ca f1 ff ff       	call   8001e6 <_panic>
	}
	if (sys_page_unmap(0, PFTEMP) < 0){
  80101c:	83 ec 08             	sub    $0x8,%esp
  80101f:	68 00 f0 7f 00       	push   $0x7ff000
  801024:	6a 00                	push   $0x0
  801026:	e8 99 fc ff ff       	call   800cc4 <sys_page_unmap>
  80102b:	83 c4 10             	add    $0x10,%esp
  80102e:	85 c0                	test   %eax,%eax
  801030:	79 14                	jns    801046 <pgfault+0xf5>
		panic("Error sys_page_unmap");
  801032:	83 ec 04             	sub    $0x4,%esp
  801035:	68 d4 2e 80 00       	push   $0x802ed4
  80103a:	6a 31                	push   $0x31
  80103c:	68 20 2e 80 00       	push   $0x802e20
  801041:	e8 a0 f1 ff ff       	call   8001e6 <_panic>
	}
	return;

}
  801046:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801049:	c9                   	leave  
  80104a:	c3                   	ret    

0080104b <fork_v0>:
		}
	}	
}

envid_t
fork_v0(void){
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	57                   	push   %edi
  80104f:	56                   	push   %esi
  801050:	53                   	push   %ebx
  801051:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801054:	b8 07 00 00 00       	mov    $0x7,%eax
  801059:	cd 30                	int    $0x30
  80105b:	89 c6                	mov    %eax,%esi
	envid_t envid;
	uint8_t *va;
	int result;	

	envid = sys_exofork();
	if (envid < 0)
  80105d:	85 c0                	test   %eax,%eax
  80105f:	79 15                	jns    801076 <fork_v0+0x2b>
		panic("sys_exofork: %e", envid);
  801061:	50                   	push   %eax
  801062:	68 e9 2e 80 00       	push   $0x802ee9
  801067:	68 81 00 00 00       	push   $0x81
  80106c:	68 20 2e 80 00       	push   $0x802e20
  801071:	e8 70 f1 ff ff       	call   8001e6 <_panic>
  801076:	89 c7                	mov    %eax,%edi
  801078:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {		
  80107d:	85 c0                	test   %eax,%eax
  80107f:	75 1e                	jne    80109f <fork_v0+0x54>
		thisenv = &envs[ENVX(sys_getenvid())];
  801081:	e8 a9 fb ff ff       	call   800c2f <sys_getenvid>
  801086:	25 ff 03 00 00       	and    $0x3ff,%eax
  80108b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80108e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801093:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  801098:	b8 00 00 00 00       	mov    $0x0,%eax
  80109d:	eb 7a                	jmp    801119 <fork_v0+0xce>
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  80109f:	89 d8                	mov    %ebx,%eax
  8010a1:	c1 e8 16             	shr    $0x16,%eax
  8010a4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010ab:	a8 01                	test   $0x1,%al
  8010ad:	74 33                	je     8010e2 <fork_v0+0x97>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  8010af:	89 d8                	mov    %ebx,%eax
  8010b1:	c1 e8 0c             	shr    $0xc,%eax
  8010b4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010bb:	f6 c2 01             	test   $0x1,%dl
  8010be:	74 22                	je     8010e2 <fork_v0+0x97>
  8010c0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010c7:	f6 c2 04             	test   $0x4,%dl
  8010ca:	74 16                	je     8010e2 <fork_v0+0x97>
				pte_t pte =uvpt[PGNUM(va)];
  8010cc:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
  8010d3:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8010d9:	89 da                	mov    %ebx,%edx
  8010db:	89 f8                	mov    %edi,%eax
  8010dd:	e8 96 fd ff ff       	call   800e78 <dup_or_share>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
  8010e2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010e8:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  8010ee:	75 af                	jne    80109f <fork_v0+0x54>
				pte_t pte =uvpt[PGNUM(va)];
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
			}
		}
	}	
	if ((result = sys_env_set_status(envid, ENV_RUNNABLE)) < 0){
  8010f0:	83 ec 08             	sub    $0x8,%esp
  8010f3:	6a 02                	push   $0x2
  8010f5:	56                   	push   %esi
  8010f6:	e8 ec fb ff ff       	call   800ce7 <sys_env_set_status>
  8010fb:	83 c4 10             	add    $0x10,%esp
  8010fe:	85 c0                	test   %eax,%eax
  801100:	79 15                	jns    801117 <fork_v0+0xcc>

		panic("sys_env_set_status: %e", result);
  801102:	50                   	push   %eax
  801103:	68 f9 2e 80 00       	push   $0x802ef9
  801108:	68 90 00 00 00       	push   $0x90
  80110d:	68 20 2e 80 00       	push   $0x802e20
  801112:	e8 cf f0 ff ff       	call   8001e6 <_panic>
	}
	return envid;
  801117:	89 f0                	mov    %esi,%eax
}
  801119:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80111c:	5b                   	pop    %ebx
  80111d:	5e                   	pop    %esi
  80111e:	5f                   	pop    %edi
  80111f:	5d                   	pop    %ebp
  801120:	c3                   	ret    

00801121 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
  801124:	57                   	push   %edi
  801125:	56                   	push   %esi
  801126:	53                   	push   %ebx
  801127:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  80112a:	68 51 0f 80 00       	push   $0x800f51
  80112f:	e8 5c 14 00 00       	call   802590 <set_pgfault_handler>
  801134:	b8 07 00 00 00       	mov    $0x7,%eax
  801139:	cd 30                	int    $0x30
  80113b:	89 c6                	mov    %eax,%esi

	envid_t envid;
	uint32_t va;
	envid = sys_exofork();
	if (envid < 0){
  80113d:	83 c4 10             	add    $0x10,%esp
  801140:	85 c0                	test   %eax,%eax
  801142:	79 15                	jns    801159 <fork+0x38>
		panic("sys_exofork: %e", envid);
  801144:	50                   	push   %eax
  801145:	68 e9 2e 80 00       	push   $0x802ee9
  80114a:	68 b1 00 00 00       	push   $0xb1
  80114f:	68 20 2e 80 00       	push   $0x802e20
  801154:	e8 8d f0 ff ff       	call   8001e6 <_panic>
  801159:	89 c7                	mov    %eax,%edi
  80115b:	bb 00 00 00 00       	mov    $0x0,%ebx
	}
	if (envid == 0) {		
  801160:	85 c0                	test   %eax,%eax
  801162:	75 21                	jne    801185 <fork+0x64>
		thisenv = &envs[ENVX(sys_getenvid())];
  801164:	e8 c6 fa ff ff       	call   800c2f <sys_getenvid>
  801169:	25 ff 03 00 00       	and    $0x3ff,%eax
  80116e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801171:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801176:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  80117b:	b8 00 00 00 00       	mov    $0x0,%eax
  801180:	e9 a7 00 00 00       	jmp    80122c <fork+0x10b>
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  801185:	89 d8                	mov    %ebx,%eax
  801187:	c1 e8 16             	shr    $0x16,%eax
  80118a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801191:	a8 01                	test   $0x1,%al
  801193:	74 22                	je     8011b7 <fork+0x96>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  801195:	89 da                	mov    %ebx,%edx
  801197:	c1 ea 0c             	shr    $0xc,%edx
  80119a:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8011a1:	a8 01                	test   $0x1,%al
  8011a3:	74 12                	je     8011b7 <fork+0x96>
  8011a5:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8011ac:	a8 04                	test   $0x4,%al
  8011ae:	74 07                	je     8011b7 <fork+0x96>
				duppage(envid, PGNUM(va));			
  8011b0:	89 f8                	mov    %edi,%eax
  8011b2:	e8 e0 fb ff ff       	call   800d97 <duppage>
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
  8011b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8011bd:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8011c3:	75 c0                	jne    801185 <fork+0x64>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
				duppage(envid, PGNUM(va));			
			}
		}
	}
	if (sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P) < 0){
  8011c5:	83 ec 04             	sub    $0x4,%esp
  8011c8:	6a 07                	push   $0x7
  8011ca:	68 00 f0 bf ee       	push   $0xeebff000
  8011cf:	56                   	push   %esi
  8011d0:	e8 a5 fa ff ff       	call   800c7a <sys_page_alloc>
  8011d5:	83 c4 10             	add    $0x10,%esp
  8011d8:	85 c0                	test   %eax,%eax
  8011da:	79 17                	jns    8011f3 <fork+0xd2>
		panic("Se escribio en la pagina de excepciones");
  8011dc:	83 ec 04             	sub    $0x4,%esp
  8011df:	68 28 2f 80 00       	push   $0x802f28
  8011e4:	68 c0 00 00 00       	push   $0xc0
  8011e9:	68 20 2e 80 00       	push   $0x802e20
  8011ee:	e8 f3 ef ff ff       	call   8001e6 <_panic>
	}	
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8011f3:	83 ec 08             	sub    $0x8,%esp
  8011f6:	68 ff 25 80 00       	push   $0x8025ff
  8011fb:	56                   	push   %esi
  8011fc:	e8 2c fb ff ff       	call   800d2d <sys_env_set_pgfault_upcall>

	if (sys_env_set_status(envid, ENV_RUNNABLE) < 0)
  801201:	83 c4 08             	add    $0x8,%esp
  801204:	6a 02                	push   $0x2
  801206:	56                   	push   %esi
  801207:	e8 db fa ff ff       	call   800ce7 <sys_env_set_status>
  80120c:	83 c4 10             	add    $0x10,%esp
  80120f:	85 c0                	test   %eax,%eax
  801211:	79 17                	jns    80122a <fork+0x109>
		panic("Status incorrecto de enviroment");
  801213:	83 ec 04             	sub    $0x4,%esp
  801216:	68 50 2f 80 00       	push   $0x802f50
  80121b:	68 c5 00 00 00       	push   $0xc5
  801220:	68 20 2e 80 00       	push   $0x802e20
  801225:	e8 bc ef ff ff       	call   8001e6 <_panic>

	return envid;
  80122a:	89 f0                	mov    %esi,%eax
	
}
  80122c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80122f:	5b                   	pop    %ebx
  801230:	5e                   	pop    %esi
  801231:	5f                   	pop    %edi
  801232:	5d                   	pop    %ebp
  801233:	c3                   	ret    

00801234 <sfork>:


// Challenge!
int
sfork(void)
{
  801234:	55                   	push   %ebp
  801235:	89 e5                	mov    %esp,%ebp
  801237:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80123a:	68 10 2f 80 00       	push   $0x802f10
  80123f:	68 d1 00 00 00       	push   $0xd1
  801244:	68 20 2e 80 00       	push   $0x802e20
  801249:	e8 98 ef ff ff       	call   8001e6 <_panic>

0080124e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	05 00 00 00 30       	add    $0x30000000,%eax
  801259:	c1 e8 0c             	shr    $0xc,%eax
}
  80125c:	5d                   	pop    %ebp
  80125d:	c3                   	ret    

0080125e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80125e:	55                   	push   %ebp
  80125f:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  801261:	ff 75 08             	pushl  0x8(%ebp)
  801264:	e8 e5 ff ff ff       	call   80124e <fd2num>
  801269:	83 c4 04             	add    $0x4,%esp
  80126c:	c1 e0 0c             	shl    $0xc,%eax
  80126f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801274:	c9                   	leave  
  801275:	c3                   	ret    

00801276 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801276:	55                   	push   %ebp
  801277:	89 e5                	mov    %esp,%ebp
  801279:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80127c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801281:	89 c2                	mov    %eax,%edx
  801283:	c1 ea 16             	shr    $0x16,%edx
  801286:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80128d:	f6 c2 01             	test   $0x1,%dl
  801290:	74 11                	je     8012a3 <fd_alloc+0x2d>
  801292:	89 c2                	mov    %eax,%edx
  801294:	c1 ea 0c             	shr    $0xc,%edx
  801297:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80129e:	f6 c2 01             	test   $0x1,%dl
  8012a1:	75 09                	jne    8012ac <fd_alloc+0x36>
			*fd_store = fd;
  8012a3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012aa:	eb 17                	jmp    8012c3 <fd_alloc+0x4d>
  8012ac:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8012b1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012b6:	75 c9                	jne    801281 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012b8:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8012be:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8012c3:	5d                   	pop    %ebp
  8012c4:	c3                   	ret    

008012c5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012cb:	83 f8 1f             	cmp    $0x1f,%eax
  8012ce:	77 36                	ja     801306 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012d0:	c1 e0 0c             	shl    $0xc,%eax
  8012d3:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012d8:	89 c2                	mov    %eax,%edx
  8012da:	c1 ea 16             	shr    $0x16,%edx
  8012dd:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012e4:	f6 c2 01             	test   $0x1,%dl
  8012e7:	74 24                	je     80130d <fd_lookup+0x48>
  8012e9:	89 c2                	mov    %eax,%edx
  8012eb:	c1 ea 0c             	shr    $0xc,%edx
  8012ee:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012f5:	f6 c2 01             	test   $0x1,%dl
  8012f8:	74 1a                	je     801314 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fd:	89 02                	mov    %eax,(%edx)
	return 0;
  8012ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801304:	eb 13                	jmp    801319 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801306:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80130b:	eb 0c                	jmp    801319 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80130d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801312:	eb 05                	jmp    801319 <fd_lookup+0x54>
  801314:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  801319:	5d                   	pop    %ebp
  80131a:	c3                   	ret    

0080131b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
  80131e:	83 ec 08             	sub    $0x8,%esp
  801321:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801324:	ba ec 2f 80 00       	mov    $0x802fec,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801329:	eb 13                	jmp    80133e <dev_lookup+0x23>
  80132b:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  80132e:	39 08                	cmp    %ecx,(%eax)
  801330:	75 0c                	jne    80133e <dev_lookup+0x23>
			*dev = devtab[i];
  801332:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801335:	89 01                	mov    %eax,(%ecx)
			return 0;
  801337:	b8 00 00 00 00       	mov    $0x0,%eax
  80133c:	eb 2e                	jmp    80136c <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80133e:	8b 02                	mov    (%edx),%eax
  801340:	85 c0                	test   %eax,%eax
  801342:	75 e7                	jne    80132b <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801344:	a1 04 50 80 00       	mov    0x805004,%eax
  801349:	8b 40 48             	mov    0x48(%eax),%eax
  80134c:	83 ec 04             	sub    $0x4,%esp
  80134f:	51                   	push   %ecx
  801350:	50                   	push   %eax
  801351:	68 70 2f 80 00       	push   $0x802f70
  801356:	e8 64 ef ff ff       	call   8002bf <cprintf>
	*dev = 0;
  80135b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801364:	83 c4 10             	add    $0x10,%esp
  801367:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    

0080136e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
  801371:	56                   	push   %esi
  801372:	53                   	push   %ebx
  801373:	83 ec 10             	sub    $0x10,%esp
  801376:	8b 75 08             	mov    0x8(%ebp),%esi
  801379:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80137c:	56                   	push   %esi
  80137d:	e8 cc fe ff ff       	call   80124e <fd2num>
  801382:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801385:	89 14 24             	mov    %edx,(%esp)
  801388:	50                   	push   %eax
  801389:	e8 37 ff ff ff       	call   8012c5 <fd_lookup>
  80138e:	83 c4 08             	add    $0x8,%esp
  801391:	85 c0                	test   %eax,%eax
  801393:	78 05                	js     80139a <fd_close+0x2c>
	    || fd != fd2)
  801395:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801398:	74 0c                	je     8013a6 <fd_close+0x38>
		return (must_exist ? r : 0);
  80139a:	84 db                	test   %bl,%bl
  80139c:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a1:	0f 44 c2             	cmove  %edx,%eax
  8013a4:	eb 41                	jmp    8013e7 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013a6:	83 ec 08             	sub    $0x8,%esp
  8013a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013ac:	50                   	push   %eax
  8013ad:	ff 36                	pushl  (%esi)
  8013af:	e8 67 ff ff ff       	call   80131b <dev_lookup>
  8013b4:	89 c3                	mov    %eax,%ebx
  8013b6:	83 c4 10             	add    $0x10,%esp
  8013b9:	85 c0                	test   %eax,%eax
  8013bb:	78 1a                	js     8013d7 <fd_close+0x69>
		if (dev->dev_close)
  8013bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c0:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8013c3:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8013c8:	85 c0                	test   %eax,%eax
  8013ca:	74 0b                	je     8013d7 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  8013cc:	83 ec 0c             	sub    $0xc,%esp
  8013cf:	56                   	push   %esi
  8013d0:	ff d0                	call   *%eax
  8013d2:	89 c3                	mov    %eax,%ebx
  8013d4:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8013d7:	83 ec 08             	sub    $0x8,%esp
  8013da:	56                   	push   %esi
  8013db:	6a 00                	push   $0x0
  8013dd:	e8 e2 f8 ff ff       	call   800cc4 <sys_page_unmap>
	return r;
  8013e2:	83 c4 10             	add    $0x10,%esp
  8013e5:	89 d8                	mov    %ebx,%eax
}
  8013e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013ea:	5b                   	pop    %ebx
  8013eb:	5e                   	pop    %esi
  8013ec:	5d                   	pop    %ebp
  8013ed:	c3                   	ret    

008013ee <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013f7:	50                   	push   %eax
  8013f8:	ff 75 08             	pushl  0x8(%ebp)
  8013fb:	e8 c5 fe ff ff       	call   8012c5 <fd_lookup>
  801400:	83 c4 08             	add    $0x8,%esp
  801403:	85 c0                	test   %eax,%eax
  801405:	78 10                	js     801417 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801407:	83 ec 08             	sub    $0x8,%esp
  80140a:	6a 01                	push   $0x1
  80140c:	ff 75 f4             	pushl  -0xc(%ebp)
  80140f:	e8 5a ff ff ff       	call   80136e <fd_close>
  801414:	83 c4 10             	add    $0x10,%esp
}
  801417:	c9                   	leave  
  801418:	c3                   	ret    

00801419 <close_all>:

void
close_all(void)
{
  801419:	55                   	push   %ebp
  80141a:	89 e5                	mov    %esp,%ebp
  80141c:	53                   	push   %ebx
  80141d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801420:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801425:	83 ec 0c             	sub    $0xc,%esp
  801428:	53                   	push   %ebx
  801429:	e8 c0 ff ff ff       	call   8013ee <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80142e:	83 c3 01             	add    $0x1,%ebx
  801431:	83 c4 10             	add    $0x10,%esp
  801434:	83 fb 20             	cmp    $0x20,%ebx
  801437:	75 ec                	jne    801425 <close_all+0xc>
		close(i);
}
  801439:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	57                   	push   %edi
  801442:	56                   	push   %esi
  801443:	53                   	push   %ebx
  801444:	83 ec 2c             	sub    $0x2c,%esp
  801447:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80144a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80144d:	50                   	push   %eax
  80144e:	ff 75 08             	pushl  0x8(%ebp)
  801451:	e8 6f fe ff ff       	call   8012c5 <fd_lookup>
  801456:	83 c4 08             	add    $0x8,%esp
  801459:	85 c0                	test   %eax,%eax
  80145b:	0f 88 c1 00 00 00    	js     801522 <dup+0xe4>
		return r;
	close(newfdnum);
  801461:	83 ec 0c             	sub    $0xc,%esp
  801464:	56                   	push   %esi
  801465:	e8 84 ff ff ff       	call   8013ee <close>

	newfd = INDEX2FD(newfdnum);
  80146a:	89 f3                	mov    %esi,%ebx
  80146c:	c1 e3 0c             	shl    $0xc,%ebx
  80146f:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801475:	83 c4 04             	add    $0x4,%esp
  801478:	ff 75 e4             	pushl  -0x1c(%ebp)
  80147b:	e8 de fd ff ff       	call   80125e <fd2data>
  801480:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  801482:	89 1c 24             	mov    %ebx,(%esp)
  801485:	e8 d4 fd ff ff       	call   80125e <fd2data>
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801490:	89 f8                	mov    %edi,%eax
  801492:	c1 e8 16             	shr    $0x16,%eax
  801495:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80149c:	a8 01                	test   $0x1,%al
  80149e:	74 37                	je     8014d7 <dup+0x99>
  8014a0:	89 f8                	mov    %edi,%eax
  8014a2:	c1 e8 0c             	shr    $0xc,%eax
  8014a5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014ac:	f6 c2 01             	test   $0x1,%dl
  8014af:	74 26                	je     8014d7 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014b1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014b8:	83 ec 0c             	sub    $0xc,%esp
  8014bb:	25 07 0e 00 00       	and    $0xe07,%eax
  8014c0:	50                   	push   %eax
  8014c1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8014c4:	6a 00                	push   $0x0
  8014c6:	57                   	push   %edi
  8014c7:	6a 00                	push   $0x0
  8014c9:	e8 d0 f7 ff ff       	call   800c9e <sys_page_map>
  8014ce:	89 c7                	mov    %eax,%edi
  8014d0:	83 c4 20             	add    $0x20,%esp
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	78 2e                	js     801505 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014da:	89 d0                	mov    %edx,%eax
  8014dc:	c1 e8 0c             	shr    $0xc,%eax
  8014df:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014e6:	83 ec 0c             	sub    $0xc,%esp
  8014e9:	25 07 0e 00 00       	and    $0xe07,%eax
  8014ee:	50                   	push   %eax
  8014ef:	53                   	push   %ebx
  8014f0:	6a 00                	push   $0x0
  8014f2:	52                   	push   %edx
  8014f3:	6a 00                	push   $0x0
  8014f5:	e8 a4 f7 ff ff       	call   800c9e <sys_page_map>
  8014fa:	89 c7                	mov    %eax,%edi
  8014fc:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  8014ff:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801501:	85 ff                	test   %edi,%edi
  801503:	79 1d                	jns    801522 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801505:	83 ec 08             	sub    $0x8,%esp
  801508:	53                   	push   %ebx
  801509:	6a 00                	push   $0x0
  80150b:	e8 b4 f7 ff ff       	call   800cc4 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801510:	83 c4 08             	add    $0x8,%esp
  801513:	ff 75 d4             	pushl  -0x2c(%ebp)
  801516:	6a 00                	push   $0x0
  801518:	e8 a7 f7 ff ff       	call   800cc4 <sys_page_unmap>
	return r;
  80151d:	83 c4 10             	add    $0x10,%esp
  801520:	89 f8                	mov    %edi,%eax
}
  801522:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801525:	5b                   	pop    %ebx
  801526:	5e                   	pop    %esi
  801527:	5f                   	pop    %edi
  801528:	5d                   	pop    %ebp
  801529:	c3                   	ret    

0080152a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	53                   	push   %ebx
  80152e:	83 ec 14             	sub    $0x14,%esp
  801531:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801534:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801537:	50                   	push   %eax
  801538:	53                   	push   %ebx
  801539:	e8 87 fd ff ff       	call   8012c5 <fd_lookup>
  80153e:	83 c4 08             	add    $0x8,%esp
  801541:	89 c2                	mov    %eax,%edx
  801543:	85 c0                	test   %eax,%eax
  801545:	78 6d                	js     8015b4 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801547:	83 ec 08             	sub    $0x8,%esp
  80154a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80154d:	50                   	push   %eax
  80154e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801551:	ff 30                	pushl  (%eax)
  801553:	e8 c3 fd ff ff       	call   80131b <dev_lookup>
  801558:	83 c4 10             	add    $0x10,%esp
  80155b:	85 c0                	test   %eax,%eax
  80155d:	78 4c                	js     8015ab <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80155f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801562:	8b 42 08             	mov    0x8(%edx),%eax
  801565:	83 e0 03             	and    $0x3,%eax
  801568:	83 f8 01             	cmp    $0x1,%eax
  80156b:	75 21                	jne    80158e <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80156d:	a1 04 50 80 00       	mov    0x805004,%eax
  801572:	8b 40 48             	mov    0x48(%eax),%eax
  801575:	83 ec 04             	sub    $0x4,%esp
  801578:	53                   	push   %ebx
  801579:	50                   	push   %eax
  80157a:	68 b1 2f 80 00       	push   $0x802fb1
  80157f:	e8 3b ed ff ff       	call   8002bf <cprintf>
		return -E_INVAL;
  801584:	83 c4 10             	add    $0x10,%esp
  801587:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80158c:	eb 26                	jmp    8015b4 <read+0x8a>
	}
	if (!dev->dev_read)
  80158e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801591:	8b 40 08             	mov    0x8(%eax),%eax
  801594:	85 c0                	test   %eax,%eax
  801596:	74 17                	je     8015af <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801598:	83 ec 04             	sub    $0x4,%esp
  80159b:	ff 75 10             	pushl  0x10(%ebp)
  80159e:	ff 75 0c             	pushl  0xc(%ebp)
  8015a1:	52                   	push   %edx
  8015a2:	ff d0                	call   *%eax
  8015a4:	89 c2                	mov    %eax,%edx
  8015a6:	83 c4 10             	add    $0x10,%esp
  8015a9:	eb 09                	jmp    8015b4 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ab:	89 c2                	mov    %eax,%edx
  8015ad:	eb 05                	jmp    8015b4 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8015af:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  8015b4:	89 d0                	mov    %edx,%eax
  8015b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
  8015be:	57                   	push   %edi
  8015bf:	56                   	push   %esi
  8015c0:	53                   	push   %ebx
  8015c1:	83 ec 0c             	sub    $0xc,%esp
  8015c4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015c7:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015ca:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015cf:	eb 21                	jmp    8015f2 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015d1:	83 ec 04             	sub    $0x4,%esp
  8015d4:	89 f0                	mov    %esi,%eax
  8015d6:	29 d8                	sub    %ebx,%eax
  8015d8:	50                   	push   %eax
  8015d9:	89 d8                	mov    %ebx,%eax
  8015db:	03 45 0c             	add    0xc(%ebp),%eax
  8015de:	50                   	push   %eax
  8015df:	57                   	push   %edi
  8015e0:	e8 45 ff ff ff       	call   80152a <read>
		if (m < 0)
  8015e5:	83 c4 10             	add    $0x10,%esp
  8015e8:	85 c0                	test   %eax,%eax
  8015ea:	78 10                	js     8015fc <readn+0x41>
			return m;
		if (m == 0)
  8015ec:	85 c0                	test   %eax,%eax
  8015ee:	74 0a                	je     8015fa <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015f0:	01 c3                	add    %eax,%ebx
  8015f2:	39 f3                	cmp    %esi,%ebx
  8015f4:	72 db                	jb     8015d1 <readn+0x16>
  8015f6:	89 d8                	mov    %ebx,%eax
  8015f8:	eb 02                	jmp    8015fc <readn+0x41>
  8015fa:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8015fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015ff:	5b                   	pop    %ebx
  801600:	5e                   	pop    %esi
  801601:	5f                   	pop    %edi
  801602:	5d                   	pop    %ebp
  801603:	c3                   	ret    

00801604 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
  801607:	53                   	push   %ebx
  801608:	83 ec 14             	sub    $0x14,%esp
  80160b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80160e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801611:	50                   	push   %eax
  801612:	53                   	push   %ebx
  801613:	e8 ad fc ff ff       	call   8012c5 <fd_lookup>
  801618:	83 c4 08             	add    $0x8,%esp
  80161b:	89 c2                	mov    %eax,%edx
  80161d:	85 c0                	test   %eax,%eax
  80161f:	78 68                	js     801689 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801621:	83 ec 08             	sub    $0x8,%esp
  801624:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801627:	50                   	push   %eax
  801628:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162b:	ff 30                	pushl  (%eax)
  80162d:	e8 e9 fc ff ff       	call   80131b <dev_lookup>
  801632:	83 c4 10             	add    $0x10,%esp
  801635:	85 c0                	test   %eax,%eax
  801637:	78 47                	js     801680 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801639:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801640:	75 21                	jne    801663 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801642:	a1 04 50 80 00       	mov    0x805004,%eax
  801647:	8b 40 48             	mov    0x48(%eax),%eax
  80164a:	83 ec 04             	sub    $0x4,%esp
  80164d:	53                   	push   %ebx
  80164e:	50                   	push   %eax
  80164f:	68 cd 2f 80 00       	push   $0x802fcd
  801654:	e8 66 ec ff ff       	call   8002bf <cprintf>
		return -E_INVAL;
  801659:	83 c4 10             	add    $0x10,%esp
  80165c:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801661:	eb 26                	jmp    801689 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801663:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801666:	8b 52 0c             	mov    0xc(%edx),%edx
  801669:	85 d2                	test   %edx,%edx
  80166b:	74 17                	je     801684 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80166d:	83 ec 04             	sub    $0x4,%esp
  801670:	ff 75 10             	pushl  0x10(%ebp)
  801673:	ff 75 0c             	pushl  0xc(%ebp)
  801676:	50                   	push   %eax
  801677:	ff d2                	call   *%edx
  801679:	89 c2                	mov    %eax,%edx
  80167b:	83 c4 10             	add    $0x10,%esp
  80167e:	eb 09                	jmp    801689 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801680:	89 c2                	mov    %eax,%edx
  801682:	eb 05                	jmp    801689 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801684:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  801689:	89 d0                	mov    %edx,%eax
  80168b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <seek>:

int
seek(int fdnum, off_t offset)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801696:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801699:	50                   	push   %eax
  80169a:	ff 75 08             	pushl  0x8(%ebp)
  80169d:	e8 23 fc ff ff       	call   8012c5 <fd_lookup>
  8016a2:	83 c4 08             	add    $0x8,%esp
  8016a5:	85 c0                	test   %eax,%eax
  8016a7:	78 0e                	js     8016b7 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8016a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016af:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
  8016bc:	53                   	push   %ebx
  8016bd:	83 ec 14             	sub    $0x14,%esp
  8016c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016c6:	50                   	push   %eax
  8016c7:	53                   	push   %ebx
  8016c8:	e8 f8 fb ff ff       	call   8012c5 <fd_lookup>
  8016cd:	83 c4 08             	add    $0x8,%esp
  8016d0:	89 c2                	mov    %eax,%edx
  8016d2:	85 c0                	test   %eax,%eax
  8016d4:	78 65                	js     80173b <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016d6:	83 ec 08             	sub    $0x8,%esp
  8016d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016dc:	50                   	push   %eax
  8016dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e0:	ff 30                	pushl  (%eax)
  8016e2:	e8 34 fc ff ff       	call   80131b <dev_lookup>
  8016e7:	83 c4 10             	add    $0x10,%esp
  8016ea:	85 c0                	test   %eax,%eax
  8016ec:	78 44                	js     801732 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016f5:	75 21                	jne    801718 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8016f7:	a1 04 50 80 00       	mov    0x805004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016fc:	8b 40 48             	mov    0x48(%eax),%eax
  8016ff:	83 ec 04             	sub    $0x4,%esp
  801702:	53                   	push   %ebx
  801703:	50                   	push   %eax
  801704:	68 90 2f 80 00       	push   $0x802f90
  801709:	e8 b1 eb ff ff       	call   8002bf <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80170e:	83 c4 10             	add    $0x10,%esp
  801711:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801716:	eb 23                	jmp    80173b <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  801718:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80171b:	8b 52 18             	mov    0x18(%edx),%edx
  80171e:	85 d2                	test   %edx,%edx
  801720:	74 14                	je     801736 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801722:	83 ec 08             	sub    $0x8,%esp
  801725:	ff 75 0c             	pushl  0xc(%ebp)
  801728:	50                   	push   %eax
  801729:	ff d2                	call   *%edx
  80172b:	89 c2                	mov    %eax,%edx
  80172d:	83 c4 10             	add    $0x10,%esp
  801730:	eb 09                	jmp    80173b <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801732:	89 c2                	mov    %eax,%edx
  801734:	eb 05                	jmp    80173b <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801736:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  80173b:	89 d0                	mov    %edx,%eax
  80173d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	53                   	push   %ebx
  801746:	83 ec 14             	sub    $0x14,%esp
  801749:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80174c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80174f:	50                   	push   %eax
  801750:	ff 75 08             	pushl  0x8(%ebp)
  801753:	e8 6d fb ff ff       	call   8012c5 <fd_lookup>
  801758:	83 c4 08             	add    $0x8,%esp
  80175b:	89 c2                	mov    %eax,%edx
  80175d:	85 c0                	test   %eax,%eax
  80175f:	78 58                	js     8017b9 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801761:	83 ec 08             	sub    $0x8,%esp
  801764:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801767:	50                   	push   %eax
  801768:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176b:	ff 30                	pushl  (%eax)
  80176d:	e8 a9 fb ff ff       	call   80131b <dev_lookup>
  801772:	83 c4 10             	add    $0x10,%esp
  801775:	85 c0                	test   %eax,%eax
  801777:	78 37                	js     8017b0 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  801779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801780:	74 32                	je     8017b4 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801782:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801785:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80178c:	00 00 00 
	stat->st_isdir = 0;
  80178f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801796:	00 00 00 
	stat->st_dev = dev;
  801799:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80179f:	83 ec 08             	sub    $0x8,%esp
  8017a2:	53                   	push   %ebx
  8017a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8017a6:	ff 50 14             	call   *0x14(%eax)
  8017a9:	89 c2                	mov    %eax,%edx
  8017ab:	83 c4 10             	add    $0x10,%esp
  8017ae:	eb 09                	jmp    8017b9 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017b0:	89 c2                	mov    %eax,%edx
  8017b2:	eb 05                	jmp    8017b9 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8017b4:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8017b9:	89 d0                	mov    %edx,%eax
  8017bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	56                   	push   %esi
  8017c4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017c5:	83 ec 08             	sub    $0x8,%esp
  8017c8:	6a 00                	push   $0x0
  8017ca:	ff 75 08             	pushl  0x8(%ebp)
  8017cd:	e8 06 02 00 00       	call   8019d8 <open>
  8017d2:	89 c3                	mov    %eax,%ebx
  8017d4:	83 c4 10             	add    $0x10,%esp
  8017d7:	85 c0                	test   %eax,%eax
  8017d9:	78 1b                	js     8017f6 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8017db:	83 ec 08             	sub    $0x8,%esp
  8017de:	ff 75 0c             	pushl  0xc(%ebp)
  8017e1:	50                   	push   %eax
  8017e2:	e8 5b ff ff ff       	call   801742 <fstat>
  8017e7:	89 c6                	mov    %eax,%esi
	close(fd);
  8017e9:	89 1c 24             	mov    %ebx,(%esp)
  8017ec:	e8 fd fb ff ff       	call   8013ee <close>
	return r;
  8017f1:	83 c4 10             	add    $0x10,%esp
  8017f4:	89 f0                	mov    %esi,%eax
}
  8017f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017f9:	5b                   	pop    %ebx
  8017fa:	5e                   	pop    %esi
  8017fb:	5d                   	pop    %ebp
  8017fc:	c3                   	ret    

008017fd <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	56                   	push   %esi
  801801:	53                   	push   %ebx
  801802:	89 c6                	mov    %eax,%esi
  801804:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801806:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80180d:	75 12                	jne    801821 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80180f:	83 ec 0c             	sub    $0xc,%esp
  801812:	6a 01                	push   $0x1
  801814:	e8 c9 0e 00 00       	call   8026e2 <ipc_find_env>
  801819:	a3 00 50 80 00       	mov    %eax,0x805000
  80181e:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801821:	6a 07                	push   $0x7
  801823:	68 00 60 80 00       	push   $0x806000
  801828:	56                   	push   %esi
  801829:	ff 35 00 50 80 00    	pushl  0x805000
  80182f:	e8 5a 0e 00 00       	call   80268e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801834:	83 c4 0c             	add    $0xc,%esp
  801837:	6a 00                	push   $0x0
  801839:	53                   	push   %ebx
  80183a:	6a 00                	push   $0x0
  80183c:	e8 e2 0d 00 00       	call   802623 <ipc_recv>
}
  801841:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801844:	5b                   	pop    %ebx
  801845:	5e                   	pop    %esi
  801846:	5d                   	pop    %ebp
  801847:	c3                   	ret    

00801848 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	8b 40 0c             	mov    0xc(%eax),%eax
  801854:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801859:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185c:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801861:	ba 00 00 00 00       	mov    $0x0,%edx
  801866:	b8 02 00 00 00       	mov    $0x2,%eax
  80186b:	e8 8d ff ff ff       	call   8017fd <fsipc>
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801878:	8b 45 08             	mov    0x8(%ebp),%eax
  80187b:	8b 40 0c             	mov    0xc(%eax),%eax
  80187e:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801883:	ba 00 00 00 00       	mov    $0x0,%edx
  801888:	b8 06 00 00 00       	mov    $0x6,%eax
  80188d:	e8 6b ff ff ff       	call   8017fd <fsipc>
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	53                   	push   %ebx
  801898:	83 ec 04             	sub    $0x4,%esp
  80189b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a4:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ae:	b8 05 00 00 00       	mov    $0x5,%eax
  8018b3:	e8 45 ff ff ff       	call   8017fd <fsipc>
  8018b8:	85 c0                	test   %eax,%eax
  8018ba:	78 2c                	js     8018e8 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018bc:	83 ec 08             	sub    $0x8,%esp
  8018bf:	68 00 60 80 00       	push   $0x806000
  8018c4:	53                   	push   %ebx
  8018c5:	e8 67 ef ff ff       	call   800831 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018ca:	a1 80 60 80 00       	mov    0x806080,%eax
  8018cf:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018d5:	a1 84 60 80 00       	mov    0x806084,%eax
  8018da:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018e0:	83 c4 10             	add    $0x10,%esp
  8018e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	83 ec 08             	sub    $0x8,%esp
  8018f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f6:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018fc:	8b 49 0c             	mov    0xc(%ecx),%ecx
  8018ff:	89 0d 00 60 80 00    	mov    %ecx,0x806000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  801905:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80190a:	76 22                	jbe    80192e <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  80190c:	c7 05 04 60 80 00 f8 	movl   $0xff8,0x806004
  801913:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  801916:	83 ec 04             	sub    $0x4,%esp
  801919:	68 f8 0f 00 00       	push   $0xff8
  80191e:	52                   	push   %edx
  80191f:	68 08 60 80 00       	push   $0x806008
  801924:	e8 9b f0 ff ff       	call   8009c4 <memmove>
  801929:	83 c4 10             	add    $0x10,%esp
  80192c:	eb 17                	jmp    801945 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  80192e:	a3 04 60 80 00       	mov    %eax,0x806004
		memmove(fsipcbuf.write.req_buf, buf, n);
  801933:	83 ec 04             	sub    $0x4,%esp
  801936:	50                   	push   %eax
  801937:	52                   	push   %edx
  801938:	68 08 60 80 00       	push   $0x806008
  80193d:	e8 82 f0 ff ff       	call   8009c4 <memmove>
  801942:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  801945:	ba 00 00 00 00       	mov    $0x0,%edx
  80194a:	b8 04 00 00 00       	mov    $0x4,%eax
  80194f:	e8 a9 fe ff ff       	call   8017fd <fsipc>
	if (result < 0)
		return result;

	return result;
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
  801959:	56                   	push   %esi
  80195a:	53                   	push   %ebx
  80195b:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80195e:	8b 45 08             	mov    0x8(%ebp),%eax
  801961:	8b 40 0c             	mov    0xc(%eax),%eax
  801964:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801969:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80196f:	ba 00 00 00 00       	mov    $0x0,%edx
  801974:	b8 03 00 00 00       	mov    $0x3,%eax
  801979:	e8 7f fe ff ff       	call   8017fd <fsipc>
  80197e:	89 c3                	mov    %eax,%ebx
  801980:	85 c0                	test   %eax,%eax
  801982:	78 4b                	js     8019cf <devfile_read+0x79>
		return r;
	assert(r <= n);
  801984:	39 c6                	cmp    %eax,%esi
  801986:	73 16                	jae    80199e <devfile_read+0x48>
  801988:	68 fc 2f 80 00       	push   $0x802ffc
  80198d:	68 03 30 80 00       	push   $0x803003
  801992:	6a 7c                	push   $0x7c
  801994:	68 18 30 80 00       	push   $0x803018
  801999:	e8 48 e8 ff ff       	call   8001e6 <_panic>
	assert(r <= PGSIZE);
  80199e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019a3:	7e 16                	jle    8019bb <devfile_read+0x65>
  8019a5:	68 23 30 80 00       	push   $0x803023
  8019aa:	68 03 30 80 00       	push   $0x803003
  8019af:	6a 7d                	push   $0x7d
  8019b1:	68 18 30 80 00       	push   $0x803018
  8019b6:	e8 2b e8 ff ff       	call   8001e6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019bb:	83 ec 04             	sub    $0x4,%esp
  8019be:	50                   	push   %eax
  8019bf:	68 00 60 80 00       	push   $0x806000
  8019c4:	ff 75 0c             	pushl  0xc(%ebp)
  8019c7:	e8 f8 ef ff ff       	call   8009c4 <memmove>
	return r;
  8019cc:	83 c4 10             	add    $0x10,%esp
}
  8019cf:	89 d8                	mov    %ebx,%eax
  8019d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019d4:	5b                   	pop    %ebx
  8019d5:	5e                   	pop    %esi
  8019d6:	5d                   	pop    %ebp
  8019d7:	c3                   	ret    

008019d8 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
  8019db:	53                   	push   %ebx
  8019dc:	83 ec 20             	sub    $0x20,%esp
  8019df:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8019e2:	53                   	push   %ebx
  8019e3:	e8 10 ee ff ff       	call   8007f8 <strlen>
  8019e8:	83 c4 10             	add    $0x10,%esp
  8019eb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019f0:	7f 67                	jg     801a59 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8019f2:	83 ec 0c             	sub    $0xc,%esp
  8019f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f8:	50                   	push   %eax
  8019f9:	e8 78 f8 ff ff       	call   801276 <fd_alloc>
  8019fe:	83 c4 10             	add    $0x10,%esp
		return r;
  801a01:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801a03:	85 c0                	test   %eax,%eax
  801a05:	78 57                	js     801a5e <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801a07:	83 ec 08             	sub    $0x8,%esp
  801a0a:	53                   	push   %ebx
  801a0b:	68 00 60 80 00       	push   $0x806000
  801a10:	e8 1c ee ff ff       	call   800831 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a18:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a20:	b8 01 00 00 00       	mov    $0x1,%eax
  801a25:	e8 d3 fd ff ff       	call   8017fd <fsipc>
  801a2a:	89 c3                	mov    %eax,%ebx
  801a2c:	83 c4 10             	add    $0x10,%esp
  801a2f:	85 c0                	test   %eax,%eax
  801a31:	79 14                	jns    801a47 <open+0x6f>
		fd_close(fd, 0);
  801a33:	83 ec 08             	sub    $0x8,%esp
  801a36:	6a 00                	push   $0x0
  801a38:	ff 75 f4             	pushl  -0xc(%ebp)
  801a3b:	e8 2e f9 ff ff       	call   80136e <fd_close>
		return r;
  801a40:	83 c4 10             	add    $0x10,%esp
  801a43:	89 da                	mov    %ebx,%edx
  801a45:	eb 17                	jmp    801a5e <open+0x86>
	}

	return fd2num(fd);
  801a47:	83 ec 0c             	sub    $0xc,%esp
  801a4a:	ff 75 f4             	pushl  -0xc(%ebp)
  801a4d:	e8 fc f7 ff ff       	call   80124e <fd2num>
  801a52:	89 c2                	mov    %eax,%edx
  801a54:	83 c4 10             	add    $0x10,%esp
  801a57:	eb 05                	jmp    801a5e <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801a59:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801a5e:	89 d0                	mov    %edx,%eax
  801a60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a70:	b8 08 00 00 00       	mov    $0x8,%eax
  801a75:	e8 83 fd ff ff       	call   8017fd <fsipc>
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <copy_shared_pages>:
}

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	57                   	push   %edi
  801a80:	56                   	push   %esi
  801a81:	53                   	push   %ebx
  801a82:	83 ec 1c             	sub    $0x1c,%esp
  801a85:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801a88:	bf 00 04 00 00       	mov    $0x400,%edi
	// LAB 5: Your code here.
	unsigned int pn;
	void* addr;
  	for (int i = 0; i < NPDENTRIES; ++i) {
  801a8d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801a94:	eb 7d                	jmp    801b13 <copy_shared_pages+0x97>
	    for (int j = 0; j < NPTENTRIES; ++j) {
    	  pn = i*NPDENTRIES + j;
    	  addr = (void*) (pn*PGSIZE);
      	  if ((pn < (UTOP >> PGSHIFT)) && uvpd[i]) {
  801a96:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  801a9c:	77 54                	ja     801af2 <copy_shared_pages+0x76>
  801a9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aa1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801aa8:	85 c0                	test   %eax,%eax
  801aaa:	74 46                	je     801af2 <copy_shared_pages+0x76>
        	if (uvpt[pn] & PTE_SHARE) {
  801aac:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801ab3:	f6 c4 04             	test   $0x4,%ah
  801ab6:	74 3a                	je     801af2 <copy_shared_pages+0x76>
          		if (sys_page_map(0, addr, child, addr, uvpt[pn] & PTE_SYSCALL) < 0) {
  801ab8:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801abf:	83 ec 0c             	sub    $0xc,%esp
  801ac2:	25 07 0e 00 00       	and    $0xe07,%eax
  801ac7:	50                   	push   %eax
  801ac8:	56                   	push   %esi
  801ac9:	ff 75 e0             	pushl  -0x20(%ebp)
  801acc:	56                   	push   %esi
  801acd:	6a 00                	push   $0x0
  801acf:	e8 ca f1 ff ff       	call   800c9e <sys_page_map>
  801ad4:	83 c4 20             	add    $0x20,%esp
  801ad7:	85 c0                	test   %eax,%eax
  801ad9:	79 17                	jns    801af2 <copy_shared_pages+0x76>
              		panic("Error en sys_page_map");
  801adb:	83 ec 04             	sub    $0x4,%esp
  801ade:	68 0a 2e 80 00       	push   $0x802e0a
  801ae3:	68 4f 01 00 00       	push   $0x14f
  801ae8:	68 2f 30 80 00       	push   $0x80302f
  801aed:	e8 f4 e6 ff ff       	call   8001e6 <_panic>
  801af2:	83 c3 01             	add    $0x1,%ebx
  801af5:	81 c6 00 10 00 00    	add    $0x1000,%esi
{
	// LAB 5: Your code here.
	unsigned int pn;
	void* addr;
  	for (int i = 0; i < NPDENTRIES; ++i) {
	    for (int j = 0; j < NPTENTRIES; ++j) {
  801afb:	39 fb                	cmp    %edi,%ebx
  801afd:	75 97                	jne    801a96 <copy_shared_pages+0x1a>
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	unsigned int pn;
	void* addr;
  	for (int i = 0; i < NPDENTRIES; ++i) {
  801aff:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  801b03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b06:	81 c7 00 04 00 00    	add    $0x400,%edi
  801b0c:	3d 00 04 00 00       	cmp    $0x400,%eax
  801b11:	74 10                	je     801b23 <copy_shared_pages+0xa7>
  801b13:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801b16:	89 f3                	mov    %esi,%ebx
  801b18:	c1 e3 0a             	shl    $0xa,%ebx
  801b1b:	c1 e6 16             	shl    $0x16,%esi
  801b1e:	e9 73 ff ff ff       	jmp    801a96 <copy_shared_pages+0x1a>
        	} 
      	  }
    	}
	}
	return 0;
}
  801b23:	b8 00 00 00 00       	mov    $0x0,%eax
  801b28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b2b:	5b                   	pop    %ebx
  801b2c:	5e                   	pop    %esi
  801b2d:	5f                   	pop    %edi
  801b2e:	5d                   	pop    %ebp
  801b2f:	c3                   	ret    

00801b30 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	57                   	push   %edi
  801b34:	56                   	push   %esi
  801b35:	53                   	push   %ebx
  801b36:	83 ec 2c             	sub    $0x2c,%esp
  801b39:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801b3c:	89 55 d0             	mov    %edx,-0x30(%ebp)
  801b3f:	89 4d cc             	mov    %ecx,-0x34(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801b42:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801b47:	be 00 00 00 00       	mov    $0x0,%esi
  801b4c:	89 d7                	mov    %edx,%edi
	for (argc = 0; argv[argc] != 0; argc++)
  801b4e:	eb 13                	jmp    801b63 <init_stack+0x33>
		string_size += strlen(argv[argc]) + 1;
  801b50:	83 ec 0c             	sub    $0xc,%esp
  801b53:	50                   	push   %eax
  801b54:	e8 9f ec ff ff       	call   8007f8 <strlen>
  801b59:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801b5d:	83 c3 01             	add    $0x1,%ebx
  801b60:	83 c4 10             	add    $0x10,%esp
  801b63:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801b6a:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801b6d:	85 c0                	test   %eax,%eax
  801b6f:	75 df                	jne    801b50 <init_stack+0x20>
  801b71:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  801b74:	89 4d d8             	mov    %ecx,-0x28(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char *) UTEMP + PGSIZE - string_size;
  801b77:	bf 00 10 40 00       	mov    $0x401000,%edi
  801b7c:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t *) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801b7e:	89 fa                	mov    %edi,%edx
  801b80:	83 e2 fc             	and    $0xfffffffc,%edx
  801b83:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801b8a:	29 c2                	sub    %eax,%edx
  801b8c:	89 55 e4             	mov    %edx,-0x1c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void *) (argv_store - 2) < (void *) UTEMP)
  801b8f:	8d 42 f8             	lea    -0x8(%edx),%eax
  801b92:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801b97:	0f 86 fc 00 00 00    	jbe    801c99 <init_stack+0x169>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void *) UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801b9d:	83 ec 04             	sub    $0x4,%esp
  801ba0:	6a 07                	push   $0x7
  801ba2:	68 00 00 40 00       	push   $0x400000
  801ba7:	6a 00                	push   $0x0
  801ba9:	e8 cc f0 ff ff       	call   800c7a <sys_page_alloc>
  801bae:	83 c4 10             	add    $0x10,%esp
  801bb1:	85 c0                	test   %eax,%eax
  801bb3:	0f 88 e5 00 00 00    	js     801c9e <init_stack+0x16e>
  801bb9:	be 00 00 00 00       	mov    $0x0,%esi
  801bbe:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  801bc1:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  801bc4:	eb 2d                	jmp    801bf3 <init_stack+0xc3>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  801bc6:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801bcc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801bcf:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801bd2:	83 ec 08             	sub    $0x8,%esp
  801bd5:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801bd8:	57                   	push   %edi
  801bd9:	e8 53 ec ff ff       	call   800831 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801bde:	83 c4 04             	add    $0x4,%esp
  801be1:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801be4:	e8 0f ec ff ff       	call   8007f8 <strlen>
  801be9:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801bed:	83 c6 01             	add    $0x1,%esi
  801bf0:	83 c4 10             	add    $0x10,%esp
  801bf3:	39 75 e0             	cmp    %esi,-0x20(%ebp)
  801bf6:	7f ce                	jg     801bc6 <init_stack+0x96>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801bf8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bfb:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  801bfe:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char *) UTEMP + PGSIZE);
  801c05:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801c0b:	74 19                	je     801c26 <init_stack+0xf6>
  801c0d:	68 a4 30 80 00       	push   $0x8030a4
  801c12:	68 03 30 80 00       	push   $0x803003
  801c17:	68 fc 00 00 00       	push   $0xfc
  801c1c:	68 2f 30 80 00       	push   $0x80302f
  801c21:	e8 c0 e5 ff ff       	call   8001e6 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801c26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c29:	89 d0                	mov    %edx,%eax
  801c2b:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801c30:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801c33:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c36:	89 42 f8             	mov    %eax,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801c39:	8d 82 f8 cf 7f ee    	lea    -0x11803008(%edx),%eax
  801c3f:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  801c42:	89 01                	mov    %eax,(%ecx)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0,
  801c44:	83 ec 0c             	sub    $0xc,%esp
  801c47:	6a 07                	push   $0x7
  801c49:	68 00 d0 bf ee       	push   $0xeebfd000
  801c4e:	ff 75 d4             	pushl  -0x2c(%ebp)
  801c51:	68 00 00 40 00       	push   $0x400000
  801c56:	6a 00                	push   $0x0
  801c58:	e8 41 f0 ff ff       	call   800c9e <sys_page_map>
  801c5d:	89 c3                	mov    %eax,%ebx
  801c5f:	83 c4 20             	add    $0x20,%esp
  801c62:	85 c0                	test   %eax,%eax
  801c64:	78 1d                	js     801c83 <init_stack+0x153>
	                      UTEMP,
	                      child,
	                      (void *) (USTACKTOP - PGSIZE),
	                      PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801c66:	83 ec 08             	sub    $0x8,%esp
  801c69:	68 00 00 40 00       	push   $0x400000
  801c6e:	6a 00                	push   $0x0
  801c70:	e8 4f f0 ff ff       	call   800cc4 <sys_page_unmap>
  801c75:	89 c3                	mov    %eax,%ebx
  801c77:	83 c4 10             	add    $0x10,%esp
		goto error;

	return 0;
  801c7a:	b8 00 00 00 00       	mov    $0x0,%eax
	                      UTEMP,
	                      child,
	                      (void *) (USTACKTOP - PGSIZE),
	                      PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801c7f:	85 db                	test   %ebx,%ebx
  801c81:	79 1b                	jns    801c9e <init_stack+0x16e>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801c83:	83 ec 08             	sub    $0x8,%esp
  801c86:	68 00 00 40 00       	push   $0x400000
  801c8b:	6a 00                	push   $0x0
  801c8d:	e8 32 f0 ff ff       	call   800cc4 <sys_page_unmap>
	return r;
  801c92:	83 c4 10             	add    $0x10,%esp
  801c95:	89 d8                	mov    %ebx,%eax
  801c97:	eb 05                	jmp    801c9e <init_stack+0x16e>
	argv_store = (uintptr_t *) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void *) (argv_store - 2) < (void *) UTEMP)
		return -E_NO_MEM;
  801c99:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return 0;

error:
	sys_page_unmap(0, UTEMP);
	return r;
}
  801c9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ca1:	5b                   	pop    %ebx
  801ca2:	5e                   	pop    %esi
  801ca3:	5f                   	pop    %edi
  801ca4:	5d                   	pop    %ebp
  801ca5:	c3                   	ret    

00801ca6 <map_segment>:
            size_t memsz,
            int fd,
            size_t filesz,
            off_t fileoffset,
            int perm)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	57                   	push   %edi
  801caa:	56                   	push   %esi
  801cab:	53                   	push   %ebx
  801cac:	83 ec 1c             	sub    $0x1c,%esp
  801caf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801cb2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	int i, r;
	void *blk;

	// cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801cb5:	89 d0                	mov    %edx,%eax
  801cb7:	25 ff 0f 00 00       	and    $0xfff,%eax
  801cbc:	74 0d                	je     801ccb <map_segment+0x25>
		va -= i;
  801cbe:	29 c2                	sub    %eax,%edx
		memsz += i;
  801cc0:	01 c1                	add    %eax,%ecx
  801cc2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		filesz += i;
  801cc5:	01 45 0c             	add    %eax,0xc(%ebp)
		fileoffset -= i;
  801cc8:	29 45 10             	sub    %eax,0x10(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801ccb:	89 d6                	mov    %edx,%esi
  801ccd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cd2:	e9 d6 00 00 00       	jmp    801dad <map_segment+0x107>
		if (i >= filesz) {
  801cd7:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
  801cda:	77 1f                	ja     801cfb <map_segment+0x55>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void *) (va + i), perm)) < 0)
  801cdc:	83 ec 04             	sub    $0x4,%esp
  801cdf:	ff 75 14             	pushl  0x14(%ebp)
  801ce2:	56                   	push   %esi
  801ce3:	ff 75 e0             	pushl  -0x20(%ebp)
  801ce6:	e8 8f ef ff ff       	call   800c7a <sys_page_alloc>
  801ceb:	83 c4 10             	add    $0x10,%esp
  801cee:	85 c0                	test   %eax,%eax
  801cf0:	0f 89 ab 00 00 00    	jns    801da1 <map_segment+0xfb>
  801cf6:	e9 c2 00 00 00       	jmp    801dbd <map_segment+0x117>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W)) <
  801cfb:	83 ec 04             	sub    $0x4,%esp
  801cfe:	6a 07                	push   $0x7
  801d00:	68 00 00 40 00       	push   $0x400000
  801d05:	6a 00                	push   $0x0
  801d07:	e8 6e ef ff ff       	call   800c7a <sys_page_alloc>
  801d0c:	83 c4 10             	add    $0x10,%esp
  801d0f:	85 c0                	test   %eax,%eax
  801d11:	0f 88 a6 00 00 00    	js     801dbd <map_segment+0x117>
			    0)
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801d17:	83 ec 08             	sub    $0x8,%esp
  801d1a:	89 f8                	mov    %edi,%eax
  801d1c:	03 45 10             	add    0x10(%ebp),%eax
  801d1f:	50                   	push   %eax
  801d20:	ff 75 08             	pushl  0x8(%ebp)
  801d23:	e8 68 f9 ff ff       	call   801690 <seek>
  801d28:	83 c4 10             	add    $0x10,%esp
  801d2b:	85 c0                	test   %eax,%eax
  801d2d:	0f 88 8a 00 00 00    	js     801dbd <map_segment+0x117>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz - i))) < 0)
  801d33:	83 ec 04             	sub    $0x4,%esp
  801d36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d39:	29 f8                	sub    %edi,%eax
  801d3b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d40:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801d45:	0f 47 c1             	cmova  %ecx,%eax
  801d48:	50                   	push   %eax
  801d49:	68 00 00 40 00       	push   $0x400000
  801d4e:	ff 75 08             	pushl  0x8(%ebp)
  801d51:	e8 65 f8 ff ff       	call   8015bb <readn>
  801d56:	83 c4 10             	add    $0x10,%esp
  801d59:	85 c0                	test   %eax,%eax
  801d5b:	78 60                	js     801dbd <map_segment+0x117>
				return r;
			if ((r = sys_page_map(
  801d5d:	83 ec 0c             	sub    $0xc,%esp
  801d60:	ff 75 14             	pushl  0x14(%ebp)
  801d63:	56                   	push   %esi
  801d64:	ff 75 e0             	pushl  -0x20(%ebp)
  801d67:	68 00 00 40 00       	push   $0x400000
  801d6c:	6a 00                	push   $0x0
  801d6e:	e8 2b ef ff ff       	call   800c9e <sys_page_map>
  801d73:	83 c4 20             	add    $0x20,%esp
  801d76:	85 c0                	test   %eax,%eax
  801d78:	79 15                	jns    801d8f <map_segment+0xe9>
			             0, UTEMP, child, (void *) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
  801d7a:	50                   	push   %eax
  801d7b:	68 3b 30 80 00       	push   $0x80303b
  801d80:	68 3a 01 00 00       	push   $0x13a
  801d85:	68 2f 30 80 00       	push   $0x80302f
  801d8a:	e8 57 e4 ff ff       	call   8001e6 <_panic>
			sys_page_unmap(0, UTEMP);
  801d8f:	83 ec 08             	sub    $0x8,%esp
  801d92:	68 00 00 40 00       	push   $0x400000
  801d97:	6a 00                	push   $0x0
  801d99:	e8 26 ef ff ff       	call   800cc4 <sys_page_unmap>
  801d9e:	83 c4 10             	add    $0x10,%esp
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801da1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801da7:	81 c6 00 10 00 00    	add    $0x1000,%esi
  801dad:	89 df                	mov    %ebx,%edi
  801daf:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
  801db2:	0f 87 1f ff ff ff    	ja     801cd7 <map_segment+0x31>
			             0, UTEMP, child, (void *) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  801db8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dc0:	5b                   	pop    %ebx
  801dc1:	5e                   	pop    %esi
  801dc2:	5f                   	pop    %edi
  801dc3:	5d                   	pop    %ebp
  801dc4:	c3                   	ret    

00801dc5 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
  801dc8:	57                   	push   %edi
  801dc9:	56                   	push   %esi
  801dca:	53                   	push   %ebx
  801dcb:	81 ec 74 02 00 00    	sub    $0x274,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801dd1:	6a 00                	push   $0x0
  801dd3:	ff 75 08             	pushl  0x8(%ebp)
  801dd6:	e8 fd fb ff ff       	call   8019d8 <open>
  801ddb:	89 c7                	mov    %eax,%edi
  801ddd:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801de3:	83 c4 10             	add    $0x10,%esp
  801de6:	85 c0                	test   %eax,%eax
  801de8:	0f 88 e3 01 00 00    	js     801fd1 <spawn+0x20c>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf *) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf) ||
  801dee:	83 ec 04             	sub    $0x4,%esp
  801df1:	68 00 02 00 00       	push   $0x200
  801df6:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801dfc:	50                   	push   %eax
  801dfd:	57                   	push   %edi
  801dfe:	e8 b8 f7 ff ff       	call   8015bb <readn>
  801e03:	83 c4 10             	add    $0x10,%esp
  801e06:	3d 00 02 00 00       	cmp    $0x200,%eax
  801e0b:	75 0c                	jne    801e19 <spawn+0x54>
  801e0d:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801e14:	45 4c 46 
  801e17:	74 33                	je     801e4c <spawn+0x87>
	    elf->e_magic != ELF_MAGIC) {
		close(fd);
  801e19:	83 ec 0c             	sub    $0xc,%esp
  801e1c:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801e22:	e8 c7 f5 ff ff       	call   8013ee <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801e27:	83 c4 0c             	add    $0xc,%esp
  801e2a:	68 7f 45 4c 46       	push   $0x464c457f
  801e2f:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801e35:	68 58 30 80 00       	push   $0x803058
  801e3a:	e8 80 e4 ff ff       	call   8002bf <cprintf>
		return -E_NOT_EXEC;
  801e3f:	83 c4 10             	add    $0x10,%esp
  801e42:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801e47:	e9 9b 01 00 00       	jmp    801fe7 <spawn+0x222>
  801e4c:	b8 07 00 00 00       	mov    $0x7,%eax
  801e51:	cd 30                	int    $0x30
  801e53:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801e59:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801e5f:	89 c3                	mov    %eax,%ebx
  801e61:	85 c0                	test   %eax,%eax
  801e63:	0f 88 70 01 00 00    	js     801fd9 <spawn+0x214>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801e69:	89 c6                	mov    %eax,%esi
  801e6b:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801e71:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801e74:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801e7a:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801e80:	b9 11 00 00 00       	mov    $0x11,%ecx
  801e85:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801e87:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801e8d:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
  801e93:	8d 8d e0 fd ff ff    	lea    -0x220(%ebp),%ecx
  801e99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9c:	89 d8                	mov    %ebx,%eax
  801e9e:	e8 8d fc ff ff       	call   801b30 <init_stack>
  801ea3:	85 c0                	test   %eax,%eax
  801ea5:	0f 88 3c 01 00 00    	js     801fe7 <spawn+0x222>
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr *) (elf_buf + elf->e_phoff);
  801eab:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801eb1:	8d 9c 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%ebx
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801eb8:	be 00 00 00 00       	mov    $0x0,%esi
  801ebd:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  801ec3:	eb 40                	jmp    801f05 <spawn+0x140>
		if (ph->p_type != ELF_PROG_LOAD)
  801ec5:	83 3b 01             	cmpl   $0x1,(%ebx)
  801ec8:	75 35                	jne    801eff <spawn+0x13a>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801eca:	8b 43 18             	mov    0x18(%ebx),%eax
  801ecd:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801ed0:	83 f8 01             	cmp    $0x1,%eax
  801ed3:	19 c0                	sbb    %eax,%eax
  801ed5:	83 e0 fe             	and    $0xfffffffe,%eax
  801ed8:	83 c0 07             	add    $0x7,%eax
		if ((r = map_segment(child,
  801edb:	8b 4b 14             	mov    0x14(%ebx),%ecx
  801ede:	8b 53 08             	mov    0x8(%ebx),%edx
  801ee1:	50                   	push   %eax
  801ee2:	ff 73 04             	pushl  0x4(%ebx)
  801ee5:	ff 73 10             	pushl  0x10(%ebx)
  801ee8:	57                   	push   %edi
  801ee9:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801eef:	e8 b2 fd ff ff       	call   801ca6 <map_segment>
  801ef4:	83 c4 10             	add    $0x10,%esp
  801ef7:	85 c0                	test   %eax,%eax
  801ef9:	0f 88 ad 00 00 00    	js     801fac <spawn+0x1e7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr *) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801eff:	83 c6 01             	add    $0x1,%esi
  801f02:	83 c3 20             	add    $0x20,%ebx
  801f05:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801f0c:	39 c6                	cmp    %eax,%esi
  801f0e:	7c b5                	jl     801ec5 <spawn+0x100>
		                     ph->p_filesz,
		                     ph->p_offset,
		                     perm)) < 0)
			goto error;
	}
	close(fd);
  801f10:	83 ec 0c             	sub    $0xc,%esp
  801f13:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801f19:	e8 d0 f4 ff ff       	call   8013ee <close>
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  801f1e:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801f24:	e8 53 fb ff ff       	call   801a7c <copy_shared_pages>
  801f29:	83 c4 10             	add    $0x10,%esp
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	79 15                	jns    801f45 <spawn+0x180>
		panic("copy_shared_pages: %e", r);
  801f30:	50                   	push   %eax
  801f31:	68 72 30 80 00       	push   $0x803072
  801f36:	68 8c 00 00 00       	push   $0x8c
  801f3b:	68 2f 30 80 00       	push   $0x80302f
  801f40:	e8 a1 e2 ff ff       	call   8001e6 <_panic>

	child_tf.tf_eflags |= FL_IOPL_3;  // devious: see user/faultio.c
  801f45:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801f4c:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801f4f:	83 ec 08             	sub    $0x8,%esp
  801f52:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801f58:	50                   	push   %eax
  801f59:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801f5f:	e8 a6 ed ff ff       	call   800d0a <sys_env_set_trapframe>
  801f64:	83 c4 10             	add    $0x10,%esp
  801f67:	85 c0                	test   %eax,%eax
  801f69:	79 15                	jns    801f80 <spawn+0x1bb>
		panic("sys_env_set_trapframe: %e", r);
  801f6b:	50                   	push   %eax
  801f6c:	68 88 30 80 00       	push   $0x803088
  801f71:	68 90 00 00 00       	push   $0x90
  801f76:	68 2f 30 80 00       	push   $0x80302f
  801f7b:	e8 66 e2 ff ff       	call   8001e6 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801f80:	83 ec 08             	sub    $0x8,%esp
  801f83:	6a 02                	push   $0x2
  801f85:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801f8b:	e8 57 ed ff ff       	call   800ce7 <sys_env_set_status>
  801f90:	83 c4 10             	add    $0x10,%esp
  801f93:	85 c0                	test   %eax,%eax
  801f95:	79 4a                	jns    801fe1 <spawn+0x21c>
		panic("sys_env_set_status: %e", r);
  801f97:	50                   	push   %eax
  801f98:	68 f9 2e 80 00       	push   $0x802ef9
  801f9d:	68 93 00 00 00       	push   $0x93
  801fa2:	68 2f 30 80 00       	push   $0x80302f
  801fa7:	e8 3a e2 ff ff       	call   8001e6 <_panic>
  801fac:	89 c7                	mov    %eax,%edi

	return child;

error:
	sys_env_destroy(child);
  801fae:	83 ec 0c             	sub    $0xc,%esp
  801fb1:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801fb7:	e8 51 ec ff ff       	call   800c0d <sys_env_destroy>
	close(fd);
  801fbc:	83 c4 04             	add    $0x4,%esp
  801fbf:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801fc5:	e8 24 f4 ff ff       	call   8013ee <close>
	return r;
  801fca:	83 c4 10             	add    $0x10,%esp
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child,
  801fcd:	89 f8                	mov    %edi,%eax
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  801fcf:	eb 16                	jmp    801fe7 <spawn+0x222>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  801fd1:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801fd7:	eb 0e                	jmp    801fe7 <spawn+0x222>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  801fd9:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801fdf:	eb 06                	jmp    801fe7 <spawn+0x222>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  801fe1:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  801fe7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fea:	5b                   	pop    %ebx
  801feb:	5e                   	pop    %esi
  801fec:	5f                   	pop    %edi
  801fed:	5d                   	pop    %ebp
  801fee:	c3                   	ret    

00801fef <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	56                   	push   %esi
  801ff3:	53                   	push   %ebx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc = 0;
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  801ff4:	8d 55 10             	lea    0x10(%ebp),%edx
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc = 0;
  801ff7:	b8 00 00 00 00       	mov    $0x0,%eax
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  801ffc:	eb 03                	jmp    802001 <spawnl+0x12>
		argc++;
  801ffe:	83 c0 01             	add    $0x1,%eax
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc = 0;
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  802001:	83 c2 04             	add    $0x4,%edx
  802004:	83 7a fc 00          	cmpl   $0x0,-0x4(%edx)
  802008:	75 f4                	jne    801ffe <spawnl+0xf>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc + 2];
  80200a:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  802011:	83 e2 f0             	and    $0xfffffff0,%edx
  802014:	29 d4                	sub    %edx,%esp
  802016:	8d 54 24 03          	lea    0x3(%esp),%edx
  80201a:	c1 ea 02             	shr    $0x2,%edx
  80201d:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  802024:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802026:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802029:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc + 1] = NULL;
  802030:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802037:	00 
  802038:	89 c2                	mov    %eax,%edx

	va_start(vl, arg0);
	unsigned i;
	for (i = 0; i < argc; i++)
  80203a:	b8 00 00 00 00       	mov    $0x0,%eax
  80203f:	eb 0a                	jmp    80204b <spawnl+0x5c>
		argv[i + 1] = va_arg(vl, const char *);
  802041:	83 c0 01             	add    $0x1,%eax
  802044:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  802048:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc + 1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for (i = 0; i < argc; i++)
  80204b:	39 d0                	cmp    %edx,%eax
  80204d:	75 f2                	jne    802041 <spawnl+0x52>
		argv[i + 1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  80204f:	83 ec 08             	sub    $0x8,%esp
  802052:	56                   	push   %esi
  802053:	ff 75 08             	pushl  0x8(%ebp)
  802056:	e8 6a fd ff ff       	call   801dc5 <spawn>
}
  80205b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80205e:	5b                   	pop    %ebx
  80205f:	5e                   	pop    %esi
  802060:	5d                   	pop    %ebp
  802061:	c3                   	ret    

00802062 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
  802065:	56                   	push   %esi
  802066:	53                   	push   %ebx
  802067:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80206a:	83 ec 0c             	sub    $0xc,%esp
  80206d:	ff 75 08             	pushl  0x8(%ebp)
  802070:	e8 e9 f1 ff ff       	call   80125e <fd2data>
  802075:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802077:	83 c4 08             	add    $0x8,%esp
  80207a:	68 cc 30 80 00       	push   $0x8030cc
  80207f:	53                   	push   %ebx
  802080:	e8 ac e7 ff ff       	call   800831 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802085:	8b 46 04             	mov    0x4(%esi),%eax
  802088:	2b 06                	sub    (%esi),%eax
  80208a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802090:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802097:	00 00 00 
	stat->st_dev = &devpipe;
  80209a:	c7 83 88 00 00 00 28 	movl   $0x804028,0x88(%ebx)
  8020a1:	40 80 00 
	return 0;
}
  8020a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ac:	5b                   	pop    %ebx
  8020ad:	5e                   	pop    %esi
  8020ae:	5d                   	pop    %ebp
  8020af:	c3                   	ret    

008020b0 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	53                   	push   %ebx
  8020b4:	83 ec 0c             	sub    $0xc,%esp
  8020b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8020ba:	53                   	push   %ebx
  8020bb:	6a 00                	push   $0x0
  8020bd:	e8 02 ec ff ff       	call   800cc4 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8020c2:	89 1c 24             	mov    %ebx,(%esp)
  8020c5:	e8 94 f1 ff ff       	call   80125e <fd2data>
  8020ca:	83 c4 08             	add    $0x8,%esp
  8020cd:	50                   	push   %eax
  8020ce:	6a 00                	push   $0x0
  8020d0:	e8 ef eb ff ff       	call   800cc4 <sys_page_unmap>
}
  8020d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020d8:	c9                   	leave  
  8020d9:	c3                   	ret    

008020da <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
  8020dd:	57                   	push   %edi
  8020de:	56                   	push   %esi
  8020df:	53                   	push   %ebx
  8020e0:	83 ec 1c             	sub    $0x1c,%esp
  8020e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8020e6:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8020e8:	a1 04 50 80 00       	mov    0x805004,%eax
  8020ed:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  8020f0:	83 ec 0c             	sub    $0xc,%esp
  8020f3:	ff 75 e0             	pushl  -0x20(%ebp)
  8020f6:	e8 20 06 00 00       	call   80271b <pageref>
  8020fb:	89 c3                	mov    %eax,%ebx
  8020fd:	89 3c 24             	mov    %edi,(%esp)
  802100:	e8 16 06 00 00       	call   80271b <pageref>
  802105:	83 c4 10             	add    $0x10,%esp
  802108:	39 c3                	cmp    %eax,%ebx
  80210a:	0f 94 c1             	sete   %cl
  80210d:	0f b6 c9             	movzbl %cl,%ecx
  802110:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  802113:	8b 15 04 50 80 00    	mov    0x805004,%edx
  802119:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80211c:	39 ce                	cmp    %ecx,%esi
  80211e:	74 1b                	je     80213b <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802120:	39 c3                	cmp    %eax,%ebx
  802122:	75 c4                	jne    8020e8 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802124:	8b 42 58             	mov    0x58(%edx),%eax
  802127:	ff 75 e4             	pushl  -0x1c(%ebp)
  80212a:	50                   	push   %eax
  80212b:	56                   	push   %esi
  80212c:	68 d3 30 80 00       	push   $0x8030d3
  802131:	e8 89 e1 ff ff       	call   8002bf <cprintf>
  802136:	83 c4 10             	add    $0x10,%esp
  802139:	eb ad                	jmp    8020e8 <_pipeisclosed+0xe>
	}
}
  80213b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80213e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802141:	5b                   	pop    %ebx
  802142:	5e                   	pop    %esi
  802143:	5f                   	pop    %edi
  802144:	5d                   	pop    %ebp
  802145:	c3                   	ret    

00802146 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	57                   	push   %edi
  80214a:	56                   	push   %esi
  80214b:	53                   	push   %ebx
  80214c:	83 ec 28             	sub    $0x28,%esp
  80214f:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802152:	56                   	push   %esi
  802153:	e8 06 f1 ff ff       	call   80125e <fd2data>
  802158:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80215a:	83 c4 10             	add    $0x10,%esp
  80215d:	bf 00 00 00 00       	mov    $0x0,%edi
  802162:	eb 4b                	jmp    8021af <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802164:	89 da                	mov    %ebx,%edx
  802166:	89 f0                	mov    %esi,%eax
  802168:	e8 6d ff ff ff       	call   8020da <_pipeisclosed>
  80216d:	85 c0                	test   %eax,%eax
  80216f:	75 48                	jne    8021b9 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802171:	e8 dd ea ff ff       	call   800c53 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802176:	8b 43 04             	mov    0x4(%ebx),%eax
  802179:	8b 0b                	mov    (%ebx),%ecx
  80217b:	8d 51 20             	lea    0x20(%ecx),%edx
  80217e:	39 d0                	cmp    %edx,%eax
  802180:	73 e2                	jae    802164 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802182:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802185:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802189:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80218c:	89 c2                	mov    %eax,%edx
  80218e:	c1 fa 1f             	sar    $0x1f,%edx
  802191:	89 d1                	mov    %edx,%ecx
  802193:	c1 e9 1b             	shr    $0x1b,%ecx
  802196:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802199:	83 e2 1f             	and    $0x1f,%edx
  80219c:	29 ca                	sub    %ecx,%edx
  80219e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8021a2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8021a6:	83 c0 01             	add    $0x1,%eax
  8021a9:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021ac:	83 c7 01             	add    $0x1,%edi
  8021af:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8021b2:	75 c2                	jne    802176 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8021b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b7:	eb 05                	jmp    8021be <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8021b9:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8021be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021c1:	5b                   	pop    %ebx
  8021c2:	5e                   	pop    %esi
  8021c3:	5f                   	pop    %edi
  8021c4:	5d                   	pop    %ebp
  8021c5:	c3                   	ret    

008021c6 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	57                   	push   %edi
  8021ca:	56                   	push   %esi
  8021cb:	53                   	push   %ebx
  8021cc:	83 ec 18             	sub    $0x18,%esp
  8021cf:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8021d2:	57                   	push   %edi
  8021d3:	e8 86 f0 ff ff       	call   80125e <fd2data>
  8021d8:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021da:	83 c4 10             	add    $0x10,%esp
  8021dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021e2:	eb 3d                	jmp    802221 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8021e4:	85 db                	test   %ebx,%ebx
  8021e6:	74 04                	je     8021ec <devpipe_read+0x26>
				return i;
  8021e8:	89 d8                	mov    %ebx,%eax
  8021ea:	eb 44                	jmp    802230 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8021ec:	89 f2                	mov    %esi,%edx
  8021ee:	89 f8                	mov    %edi,%eax
  8021f0:	e8 e5 fe ff ff       	call   8020da <_pipeisclosed>
  8021f5:	85 c0                	test   %eax,%eax
  8021f7:	75 32                	jne    80222b <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8021f9:	e8 55 ea ff ff       	call   800c53 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8021fe:	8b 06                	mov    (%esi),%eax
  802200:	3b 46 04             	cmp    0x4(%esi),%eax
  802203:	74 df                	je     8021e4 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802205:	99                   	cltd   
  802206:	c1 ea 1b             	shr    $0x1b,%edx
  802209:	01 d0                	add    %edx,%eax
  80220b:	83 e0 1f             	and    $0x1f,%eax
  80220e:	29 d0                	sub    %edx,%eax
  802210:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  802215:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802218:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  80221b:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80221e:	83 c3 01             	add    $0x1,%ebx
  802221:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802224:	75 d8                	jne    8021fe <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802226:	8b 45 10             	mov    0x10(%ebp),%eax
  802229:	eb 05                	jmp    802230 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80222b:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802230:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802233:	5b                   	pop    %ebx
  802234:	5e                   	pop    %esi
  802235:	5f                   	pop    %edi
  802236:	5d                   	pop    %ebp
  802237:	c3                   	ret    

00802238 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
  80223b:	56                   	push   %esi
  80223c:	53                   	push   %ebx
  80223d:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802240:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802243:	50                   	push   %eax
  802244:	e8 2d f0 ff ff       	call   801276 <fd_alloc>
  802249:	83 c4 10             	add    $0x10,%esp
  80224c:	89 c2                	mov    %eax,%edx
  80224e:	85 c0                	test   %eax,%eax
  802250:	0f 88 2c 01 00 00    	js     802382 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802256:	83 ec 04             	sub    $0x4,%esp
  802259:	68 07 04 00 00       	push   $0x407
  80225e:	ff 75 f4             	pushl  -0xc(%ebp)
  802261:	6a 00                	push   $0x0
  802263:	e8 12 ea ff ff       	call   800c7a <sys_page_alloc>
  802268:	83 c4 10             	add    $0x10,%esp
  80226b:	89 c2                	mov    %eax,%edx
  80226d:	85 c0                	test   %eax,%eax
  80226f:	0f 88 0d 01 00 00    	js     802382 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802275:	83 ec 0c             	sub    $0xc,%esp
  802278:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80227b:	50                   	push   %eax
  80227c:	e8 f5 ef ff ff       	call   801276 <fd_alloc>
  802281:	89 c3                	mov    %eax,%ebx
  802283:	83 c4 10             	add    $0x10,%esp
  802286:	85 c0                	test   %eax,%eax
  802288:	0f 88 e2 00 00 00    	js     802370 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80228e:	83 ec 04             	sub    $0x4,%esp
  802291:	68 07 04 00 00       	push   $0x407
  802296:	ff 75 f0             	pushl  -0x10(%ebp)
  802299:	6a 00                	push   $0x0
  80229b:	e8 da e9 ff ff       	call   800c7a <sys_page_alloc>
  8022a0:	89 c3                	mov    %eax,%ebx
  8022a2:	83 c4 10             	add    $0x10,%esp
  8022a5:	85 c0                	test   %eax,%eax
  8022a7:	0f 88 c3 00 00 00    	js     802370 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8022ad:	83 ec 0c             	sub    $0xc,%esp
  8022b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8022b3:	e8 a6 ef ff ff       	call   80125e <fd2data>
  8022b8:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022ba:	83 c4 0c             	add    $0xc,%esp
  8022bd:	68 07 04 00 00       	push   $0x407
  8022c2:	50                   	push   %eax
  8022c3:	6a 00                	push   $0x0
  8022c5:	e8 b0 e9 ff ff       	call   800c7a <sys_page_alloc>
  8022ca:	89 c3                	mov    %eax,%ebx
  8022cc:	83 c4 10             	add    $0x10,%esp
  8022cf:	85 c0                	test   %eax,%eax
  8022d1:	0f 88 89 00 00 00    	js     802360 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022d7:	83 ec 0c             	sub    $0xc,%esp
  8022da:	ff 75 f0             	pushl  -0x10(%ebp)
  8022dd:	e8 7c ef ff ff       	call   80125e <fd2data>
  8022e2:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8022e9:	50                   	push   %eax
  8022ea:	6a 00                	push   $0x0
  8022ec:	56                   	push   %esi
  8022ed:	6a 00                	push   $0x0
  8022ef:	e8 aa e9 ff ff       	call   800c9e <sys_page_map>
  8022f4:	89 c3                	mov    %eax,%ebx
  8022f6:	83 c4 20             	add    $0x20,%esp
  8022f9:	85 c0                	test   %eax,%eax
  8022fb:	78 55                	js     802352 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8022fd:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802306:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802312:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802318:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231b:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80231d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802320:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802327:	83 ec 0c             	sub    $0xc,%esp
  80232a:	ff 75 f4             	pushl  -0xc(%ebp)
  80232d:	e8 1c ef ff ff       	call   80124e <fd2num>
  802332:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802335:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802337:	83 c4 04             	add    $0x4,%esp
  80233a:	ff 75 f0             	pushl  -0x10(%ebp)
  80233d:	e8 0c ef ff ff       	call   80124e <fd2num>
  802342:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802345:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802348:	83 c4 10             	add    $0x10,%esp
  80234b:	ba 00 00 00 00       	mov    $0x0,%edx
  802350:	eb 30                	jmp    802382 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  802352:	83 ec 08             	sub    $0x8,%esp
  802355:	56                   	push   %esi
  802356:	6a 00                	push   $0x0
  802358:	e8 67 e9 ff ff       	call   800cc4 <sys_page_unmap>
  80235d:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  802360:	83 ec 08             	sub    $0x8,%esp
  802363:	ff 75 f0             	pushl  -0x10(%ebp)
  802366:	6a 00                	push   $0x0
  802368:	e8 57 e9 ff ff       	call   800cc4 <sys_page_unmap>
  80236d:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  802370:	83 ec 08             	sub    $0x8,%esp
  802373:	ff 75 f4             	pushl  -0xc(%ebp)
  802376:	6a 00                	push   $0x0
  802378:	e8 47 e9 ff ff       	call   800cc4 <sys_page_unmap>
  80237d:	83 c4 10             	add    $0x10,%esp
  802380:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  802382:	89 d0                	mov    %edx,%eax
  802384:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802387:	5b                   	pop    %ebx
  802388:	5e                   	pop    %esi
  802389:	5d                   	pop    %ebp
  80238a:	c3                   	ret    

0080238b <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
  80238e:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802391:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802394:	50                   	push   %eax
  802395:	ff 75 08             	pushl  0x8(%ebp)
  802398:	e8 28 ef ff ff       	call   8012c5 <fd_lookup>
  80239d:	83 c4 10             	add    $0x10,%esp
  8023a0:	85 c0                	test   %eax,%eax
  8023a2:	78 18                	js     8023bc <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8023a4:	83 ec 0c             	sub    $0xc,%esp
  8023a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8023aa:	e8 af ee ff ff       	call   80125e <fd2data>
	return _pipeisclosed(fd, p);
  8023af:	89 c2                	mov    %eax,%edx
  8023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b4:	e8 21 fd ff ff       	call   8020da <_pipeisclosed>
  8023b9:	83 c4 10             	add    $0x10,%esp
}
  8023bc:	c9                   	leave  
  8023bd:	c3                   	ret    

008023be <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8023be:	55                   	push   %ebp
  8023bf:	89 e5                	mov    %esp,%ebp
  8023c1:	56                   	push   %esi
  8023c2:	53                   	push   %ebx
  8023c3:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8023c6:	85 f6                	test   %esi,%esi
  8023c8:	75 16                	jne    8023e0 <wait+0x22>
  8023ca:	68 eb 30 80 00       	push   $0x8030eb
  8023cf:	68 03 30 80 00       	push   $0x803003
  8023d4:	6a 09                	push   $0x9
  8023d6:	68 f6 30 80 00       	push   $0x8030f6
  8023db:	e8 06 de ff ff       	call   8001e6 <_panic>
	e = &envs[ENVX(envid)];
  8023e0:	89 f3                	mov    %esi,%ebx
  8023e2:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8023e8:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  8023eb:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8023f1:	eb 05                	jmp    8023f8 <wait+0x3a>
		sys_yield();
  8023f3:	e8 5b e8 ff ff       	call   800c53 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8023f8:	8b 43 48             	mov    0x48(%ebx),%eax
  8023fb:	39 c6                	cmp    %eax,%esi
  8023fd:	75 07                	jne    802406 <wait+0x48>
  8023ff:	8b 43 54             	mov    0x54(%ebx),%eax
  802402:	85 c0                	test   %eax,%eax
  802404:	75 ed                	jne    8023f3 <wait+0x35>
		sys_yield();
}
  802406:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802409:	5b                   	pop    %ebx
  80240a:	5e                   	pop    %esi
  80240b:	5d                   	pop    %ebp
  80240c:	c3                   	ret    

0080240d <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802410:	b8 00 00 00 00       	mov    $0x0,%eax
  802415:	5d                   	pop    %ebp
  802416:	c3                   	ret    

00802417 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802417:	55                   	push   %ebp
  802418:	89 e5                	mov    %esp,%ebp
  80241a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80241d:	68 01 31 80 00       	push   $0x803101
  802422:	ff 75 0c             	pushl  0xc(%ebp)
  802425:	e8 07 e4 ff ff       	call   800831 <strcpy>
	return 0;
}
  80242a:	b8 00 00 00 00       	mov    $0x0,%eax
  80242f:	c9                   	leave  
  802430:	c3                   	ret    

00802431 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
  802434:	57                   	push   %edi
  802435:	56                   	push   %esi
  802436:	53                   	push   %ebx
  802437:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80243d:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802442:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802448:	eb 2d                	jmp    802477 <devcons_write+0x46>
		m = n - tot;
  80244a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80244d:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  80244f:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802452:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802457:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80245a:	83 ec 04             	sub    $0x4,%esp
  80245d:	53                   	push   %ebx
  80245e:	03 45 0c             	add    0xc(%ebp),%eax
  802461:	50                   	push   %eax
  802462:	57                   	push   %edi
  802463:	e8 5c e5 ff ff       	call   8009c4 <memmove>
		sys_cputs(buf, m);
  802468:	83 c4 08             	add    $0x8,%esp
  80246b:	53                   	push   %ebx
  80246c:	57                   	push   %edi
  80246d:	e8 51 e7 ff ff       	call   800bc3 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802472:	01 de                	add    %ebx,%esi
  802474:	83 c4 10             	add    $0x10,%esp
  802477:	89 f0                	mov    %esi,%eax
  802479:	3b 75 10             	cmp    0x10(%ebp),%esi
  80247c:	72 cc                	jb     80244a <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80247e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802481:	5b                   	pop    %ebx
  802482:	5e                   	pop    %esi
  802483:	5f                   	pop    %edi
  802484:	5d                   	pop    %ebp
  802485:	c3                   	ret    

00802486 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
  802489:	83 ec 08             	sub    $0x8,%esp
  80248c:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  802491:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802495:	74 2a                	je     8024c1 <devcons_read+0x3b>
  802497:	eb 05                	jmp    80249e <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802499:	e8 b5 e7 ff ff       	call   800c53 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80249e:	e8 46 e7 ff ff       	call   800be9 <sys_cgetc>
  8024a3:	85 c0                	test   %eax,%eax
  8024a5:	74 f2                	je     802499 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8024a7:	85 c0                	test   %eax,%eax
  8024a9:	78 16                	js     8024c1 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8024ab:	83 f8 04             	cmp    $0x4,%eax
  8024ae:	74 0c                	je     8024bc <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8024b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b3:	88 02                	mov    %al,(%edx)
	return 1;
  8024b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ba:	eb 05                	jmp    8024c1 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8024bc:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8024c1:	c9                   	leave  
  8024c2:	c3                   	ret    

008024c3 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8024c3:	55                   	push   %ebp
  8024c4:	89 e5                	mov    %esp,%ebp
  8024c6:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8024c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cc:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8024cf:	6a 01                	push   $0x1
  8024d1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024d4:	50                   	push   %eax
  8024d5:	e8 e9 e6 ff ff       	call   800bc3 <sys_cputs>
}
  8024da:	83 c4 10             	add    $0x10,%esp
  8024dd:	c9                   	leave  
  8024de:	c3                   	ret    

008024df <getchar>:

int
getchar(void)
{
  8024df:	55                   	push   %ebp
  8024e0:	89 e5                	mov    %esp,%ebp
  8024e2:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8024e5:	6a 01                	push   $0x1
  8024e7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024ea:	50                   	push   %eax
  8024eb:	6a 00                	push   $0x0
  8024ed:	e8 38 f0 ff ff       	call   80152a <read>
	if (r < 0)
  8024f2:	83 c4 10             	add    $0x10,%esp
  8024f5:	85 c0                	test   %eax,%eax
  8024f7:	78 0f                	js     802508 <getchar+0x29>
		return r;
	if (r < 1)
  8024f9:	85 c0                	test   %eax,%eax
  8024fb:	7e 06                	jle    802503 <getchar+0x24>
		return -E_EOF;
	return c;
  8024fd:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802501:	eb 05                	jmp    802508 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802503:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802508:	c9                   	leave  
  802509:	c3                   	ret    

0080250a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
  80250d:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802510:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802513:	50                   	push   %eax
  802514:	ff 75 08             	pushl  0x8(%ebp)
  802517:	e8 a9 ed ff ff       	call   8012c5 <fd_lookup>
  80251c:	83 c4 10             	add    $0x10,%esp
  80251f:	85 c0                	test   %eax,%eax
  802521:	78 11                	js     802534 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80252c:	39 10                	cmp    %edx,(%eax)
  80252e:	0f 94 c0             	sete   %al
  802531:	0f b6 c0             	movzbl %al,%eax
}
  802534:	c9                   	leave  
  802535:	c3                   	ret    

00802536 <opencons>:

int
opencons(void)
{
  802536:	55                   	push   %ebp
  802537:	89 e5                	mov    %esp,%ebp
  802539:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80253c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80253f:	50                   	push   %eax
  802540:	e8 31 ed ff ff       	call   801276 <fd_alloc>
  802545:	83 c4 10             	add    $0x10,%esp
		return r;
  802548:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80254a:	85 c0                	test   %eax,%eax
  80254c:	78 3e                	js     80258c <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80254e:	83 ec 04             	sub    $0x4,%esp
  802551:	68 07 04 00 00       	push   $0x407
  802556:	ff 75 f4             	pushl  -0xc(%ebp)
  802559:	6a 00                	push   $0x0
  80255b:	e8 1a e7 ff ff       	call   800c7a <sys_page_alloc>
  802560:	83 c4 10             	add    $0x10,%esp
		return r;
  802563:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802565:	85 c0                	test   %eax,%eax
  802567:	78 23                	js     80258c <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802569:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80257e:	83 ec 0c             	sub    $0xc,%esp
  802581:	50                   	push   %eax
  802582:	e8 c7 ec ff ff       	call   80124e <fd2num>
  802587:	89 c2                	mov    %eax,%edx
  802589:	83 c4 10             	add    $0x10,%esp
}
  80258c:	89 d0                	mov    %edx,%eax
  80258e:	c9                   	leave  
  80258f:	c3                   	ret    

00802590 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802590:	55                   	push   %ebp
  802591:	89 e5                	mov    %esp,%ebp
  802593:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802596:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  80259d:	75 2c                	jne    8025cb <set_pgfault_handler+0x3b>
		// First time through!
		// LAB 4: Your code here.
		r = sys_page_alloc(0,(void *)(UXSTACKTOP - PGSIZE),PTE_P | PTE_U | PTE_W);
  80259f:	83 ec 04             	sub    $0x4,%esp
  8025a2:	6a 07                	push   $0x7
  8025a4:	68 00 f0 bf ee       	push   $0xeebff000
  8025a9:	6a 00                	push   $0x0
  8025ab:	e8 ca e6 ff ff       	call   800c7a <sys_page_alloc>
		if(r < 0)
  8025b0:	83 c4 10             	add    $0x10,%esp
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	79 14                	jns    8025cb <set_pgfault_handler+0x3b>
			panic("set_pgfault_handler: error in sys_page_alloc\n");	
  8025b7:	83 ec 04             	sub    $0x4,%esp
  8025ba:	68 10 31 80 00       	push   $0x803110
  8025bf:	6a 22                	push   $0x22
  8025c1:	68 7c 31 80 00       	push   $0x80317c
  8025c6:	e8 1b dc ff ff       	call   8001e6 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8025cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ce:	a3 00 70 80 00       	mov    %eax,0x807000
	r = sys_env_set_pgfault_upcall(0, _pgfault_upcall); 
  8025d3:	83 ec 08             	sub    $0x8,%esp
  8025d6:	68 ff 25 80 00       	push   $0x8025ff
  8025db:	6a 00                	push   $0x0
  8025dd:	e8 4b e7 ff ff       	call   800d2d <sys_env_set_pgfault_upcall>
	if (r < 0)
  8025e2:	83 c4 10             	add    $0x10,%esp
  8025e5:	85 c0                	test   %eax,%eax
  8025e7:	79 14                	jns    8025fd <set_pgfault_handler+0x6d>
		panic("set_pgfault_handler: error in sys_env_set_pgfault_upcall");
  8025e9:	83 ec 04             	sub    $0x4,%esp
  8025ec:	68 40 31 80 00       	push   $0x803140
  8025f1:	6a 29                	push   $0x29
  8025f3:	68 7c 31 80 00       	push   $0x80317c
  8025f8:	e8 e9 db ff ff       	call   8001e6 <_panic>
}
  8025fd:	c9                   	leave  
  8025fe:	c3                   	ret    

008025ff <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8025ff:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802600:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802605:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802607:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	subl $0x4, 0x30(%esp)
  80260a:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  80260f:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 0x28(%esp), %ebx 	
  802613:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  802617:	89 18                	mov    %ebx,(%eax)
	addl $0x8, %esp
  802619:	83 c4 08             	add    $0x8,%esp


	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  80261c:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp 
  80261d:	83 c4 04             	add    $0x4,%esp
	popfl
  802620:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802621:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802622:	c3                   	ret    

00802623 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802623:	55                   	push   %ebp
  802624:	89 e5                	mov    %esp,%ebp
  802626:	56                   	push   %esi
  802627:	53                   	push   %ebx
  802628:	8b 75 08             	mov    0x8(%ebp),%esi
  80262b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80262e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  802631:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  802633:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802638:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  80263b:	83 ec 0c             	sub    $0xc,%esp
  80263e:	50                   	push   %eax
  80263f:	e8 31 e7 ff ff       	call   800d75 <sys_ipc_recv>
	if (from_env_store)
  802644:	83 c4 10             	add    $0x10,%esp
  802647:	85 f6                	test   %esi,%esi
  802649:	74 0b                	je     802656 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  80264b:	8b 15 04 50 80 00    	mov    0x805004,%edx
  802651:	8b 52 74             	mov    0x74(%edx),%edx
  802654:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  802656:	85 db                	test   %ebx,%ebx
  802658:	74 0b                	je     802665 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  80265a:	8b 15 04 50 80 00    	mov    0x805004,%edx
  802660:	8b 52 78             	mov    0x78(%edx),%edx
  802663:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  802665:	85 c0                	test   %eax,%eax
  802667:	79 16                	jns    80267f <ipc_recv+0x5c>
		if (from_env_store)
  802669:	85 f6                	test   %esi,%esi
  80266b:	74 06                	je     802673 <ipc_recv+0x50>
			*from_env_store = 0;
  80266d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  802673:	85 db                	test   %ebx,%ebx
  802675:	74 10                	je     802687 <ipc_recv+0x64>
			*perm_store = 0;
  802677:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80267d:	eb 08                	jmp    802687 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  80267f:	a1 04 50 80 00       	mov    0x805004,%eax
  802684:	8b 40 70             	mov    0x70(%eax),%eax
}
  802687:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80268a:	5b                   	pop    %ebx
  80268b:	5e                   	pop    %esi
  80268c:	5d                   	pop    %ebp
  80268d:	c3                   	ret    

0080268e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80268e:	55                   	push   %ebp
  80268f:	89 e5                	mov    %esp,%ebp
  802691:	57                   	push   %edi
  802692:	56                   	push   %esi
  802693:	53                   	push   %ebx
  802694:	83 ec 0c             	sub    $0xc,%esp
  802697:	8b 7d 08             	mov    0x8(%ebp),%edi
  80269a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80269d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  8026a0:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  8026a2:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8026a7:	0f 44 d8             	cmove  %eax,%ebx
  8026aa:	eb 1c                	jmp    8026c8 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  8026ac:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8026af:	74 12                	je     8026c3 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  8026b1:	50                   	push   %eax
  8026b2:	68 8a 31 80 00       	push   $0x80318a
  8026b7:	6a 42                	push   $0x42
  8026b9:	68 a0 31 80 00       	push   $0x8031a0
  8026be:	e8 23 db ff ff       	call   8001e6 <_panic>
		sys_yield();
  8026c3:	e8 8b e5 ff ff       	call   800c53 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  8026c8:	ff 75 14             	pushl  0x14(%ebp)
  8026cb:	53                   	push   %ebx
  8026cc:	56                   	push   %esi
  8026cd:	57                   	push   %edi
  8026ce:	e8 7d e6 ff ff       	call   800d50 <sys_ipc_try_send>
  8026d3:	83 c4 10             	add    $0x10,%esp
  8026d6:	85 c0                	test   %eax,%eax
  8026d8:	75 d2                	jne    8026ac <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  8026da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026dd:	5b                   	pop    %ebx
  8026de:	5e                   	pop    %esi
  8026df:	5f                   	pop    %edi
  8026e0:	5d                   	pop    %ebp
  8026e1:	c3                   	ret    

008026e2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8026e2:	55                   	push   %ebp
  8026e3:	89 e5                	mov    %esp,%ebp
  8026e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8026e8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8026ed:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8026f0:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8026f6:	8b 52 50             	mov    0x50(%edx),%edx
  8026f9:	39 ca                	cmp    %ecx,%edx
  8026fb:	75 0d                	jne    80270a <ipc_find_env+0x28>
			return envs[i].env_id;
  8026fd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802700:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802705:	8b 40 48             	mov    0x48(%eax),%eax
  802708:	eb 0f                	jmp    802719 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80270a:	83 c0 01             	add    $0x1,%eax
  80270d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802712:	75 d9                	jne    8026ed <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802714:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802719:	5d                   	pop    %ebp
  80271a:	c3                   	ret    

0080271b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80271b:	55                   	push   %ebp
  80271c:	89 e5                	mov    %esp,%ebp
  80271e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802721:	89 d0                	mov    %edx,%eax
  802723:	c1 e8 16             	shr    $0x16,%eax
  802726:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80272d:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802732:	f6 c1 01             	test   $0x1,%cl
  802735:	74 1d                	je     802754 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802737:	c1 ea 0c             	shr    $0xc,%edx
  80273a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802741:	f6 c2 01             	test   $0x1,%dl
  802744:	74 0e                	je     802754 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802746:	c1 ea 0c             	shr    $0xc,%edx
  802749:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802750:	ef 
  802751:	0f b7 c0             	movzwl %ax,%eax
}
  802754:	5d                   	pop    %ebp
  802755:	c3                   	ret    
  802756:	66 90                	xchg   %ax,%ax
  802758:	66 90                	xchg   %ax,%ax
  80275a:	66 90                	xchg   %ax,%ax
  80275c:	66 90                	xchg   %ax,%ax
  80275e:	66 90                	xchg   %ax,%ax

00802760 <__udivdi3>:
  802760:	55                   	push   %ebp
  802761:	57                   	push   %edi
  802762:	56                   	push   %esi
  802763:	53                   	push   %ebx
  802764:	83 ec 1c             	sub    $0x1c,%esp
  802767:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80276b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80276f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802773:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802777:	85 f6                	test   %esi,%esi
  802779:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80277d:	89 ca                	mov    %ecx,%edx
  80277f:	89 f8                	mov    %edi,%eax
  802781:	75 3d                	jne    8027c0 <__udivdi3+0x60>
  802783:	39 cf                	cmp    %ecx,%edi
  802785:	0f 87 c5 00 00 00    	ja     802850 <__udivdi3+0xf0>
  80278b:	85 ff                	test   %edi,%edi
  80278d:	89 fd                	mov    %edi,%ebp
  80278f:	75 0b                	jne    80279c <__udivdi3+0x3c>
  802791:	b8 01 00 00 00       	mov    $0x1,%eax
  802796:	31 d2                	xor    %edx,%edx
  802798:	f7 f7                	div    %edi
  80279a:	89 c5                	mov    %eax,%ebp
  80279c:	89 c8                	mov    %ecx,%eax
  80279e:	31 d2                	xor    %edx,%edx
  8027a0:	f7 f5                	div    %ebp
  8027a2:	89 c1                	mov    %eax,%ecx
  8027a4:	89 d8                	mov    %ebx,%eax
  8027a6:	89 cf                	mov    %ecx,%edi
  8027a8:	f7 f5                	div    %ebp
  8027aa:	89 c3                	mov    %eax,%ebx
  8027ac:	89 d8                	mov    %ebx,%eax
  8027ae:	89 fa                	mov    %edi,%edx
  8027b0:	83 c4 1c             	add    $0x1c,%esp
  8027b3:	5b                   	pop    %ebx
  8027b4:	5e                   	pop    %esi
  8027b5:	5f                   	pop    %edi
  8027b6:	5d                   	pop    %ebp
  8027b7:	c3                   	ret    
  8027b8:	90                   	nop
  8027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027c0:	39 ce                	cmp    %ecx,%esi
  8027c2:	77 74                	ja     802838 <__udivdi3+0xd8>
  8027c4:	0f bd fe             	bsr    %esi,%edi
  8027c7:	83 f7 1f             	xor    $0x1f,%edi
  8027ca:	0f 84 98 00 00 00    	je     802868 <__udivdi3+0x108>
  8027d0:	bb 20 00 00 00       	mov    $0x20,%ebx
  8027d5:	89 f9                	mov    %edi,%ecx
  8027d7:	89 c5                	mov    %eax,%ebp
  8027d9:	29 fb                	sub    %edi,%ebx
  8027db:	d3 e6                	shl    %cl,%esi
  8027dd:	89 d9                	mov    %ebx,%ecx
  8027df:	d3 ed                	shr    %cl,%ebp
  8027e1:	89 f9                	mov    %edi,%ecx
  8027e3:	d3 e0                	shl    %cl,%eax
  8027e5:	09 ee                	or     %ebp,%esi
  8027e7:	89 d9                	mov    %ebx,%ecx
  8027e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027ed:	89 d5                	mov    %edx,%ebp
  8027ef:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027f3:	d3 ed                	shr    %cl,%ebp
  8027f5:	89 f9                	mov    %edi,%ecx
  8027f7:	d3 e2                	shl    %cl,%edx
  8027f9:	89 d9                	mov    %ebx,%ecx
  8027fb:	d3 e8                	shr    %cl,%eax
  8027fd:	09 c2                	or     %eax,%edx
  8027ff:	89 d0                	mov    %edx,%eax
  802801:	89 ea                	mov    %ebp,%edx
  802803:	f7 f6                	div    %esi
  802805:	89 d5                	mov    %edx,%ebp
  802807:	89 c3                	mov    %eax,%ebx
  802809:	f7 64 24 0c          	mull   0xc(%esp)
  80280d:	39 d5                	cmp    %edx,%ebp
  80280f:	72 10                	jb     802821 <__udivdi3+0xc1>
  802811:	8b 74 24 08          	mov    0x8(%esp),%esi
  802815:	89 f9                	mov    %edi,%ecx
  802817:	d3 e6                	shl    %cl,%esi
  802819:	39 c6                	cmp    %eax,%esi
  80281b:	73 07                	jae    802824 <__udivdi3+0xc4>
  80281d:	39 d5                	cmp    %edx,%ebp
  80281f:	75 03                	jne    802824 <__udivdi3+0xc4>
  802821:	83 eb 01             	sub    $0x1,%ebx
  802824:	31 ff                	xor    %edi,%edi
  802826:	89 d8                	mov    %ebx,%eax
  802828:	89 fa                	mov    %edi,%edx
  80282a:	83 c4 1c             	add    $0x1c,%esp
  80282d:	5b                   	pop    %ebx
  80282e:	5e                   	pop    %esi
  80282f:	5f                   	pop    %edi
  802830:	5d                   	pop    %ebp
  802831:	c3                   	ret    
  802832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802838:	31 ff                	xor    %edi,%edi
  80283a:	31 db                	xor    %ebx,%ebx
  80283c:	89 d8                	mov    %ebx,%eax
  80283e:	89 fa                	mov    %edi,%edx
  802840:	83 c4 1c             	add    $0x1c,%esp
  802843:	5b                   	pop    %ebx
  802844:	5e                   	pop    %esi
  802845:	5f                   	pop    %edi
  802846:	5d                   	pop    %ebp
  802847:	c3                   	ret    
  802848:	90                   	nop
  802849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802850:	89 d8                	mov    %ebx,%eax
  802852:	f7 f7                	div    %edi
  802854:	31 ff                	xor    %edi,%edi
  802856:	89 c3                	mov    %eax,%ebx
  802858:	89 d8                	mov    %ebx,%eax
  80285a:	89 fa                	mov    %edi,%edx
  80285c:	83 c4 1c             	add    $0x1c,%esp
  80285f:	5b                   	pop    %ebx
  802860:	5e                   	pop    %esi
  802861:	5f                   	pop    %edi
  802862:	5d                   	pop    %ebp
  802863:	c3                   	ret    
  802864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802868:	39 ce                	cmp    %ecx,%esi
  80286a:	72 0c                	jb     802878 <__udivdi3+0x118>
  80286c:	31 db                	xor    %ebx,%ebx
  80286e:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802872:	0f 87 34 ff ff ff    	ja     8027ac <__udivdi3+0x4c>
  802878:	bb 01 00 00 00       	mov    $0x1,%ebx
  80287d:	e9 2a ff ff ff       	jmp    8027ac <__udivdi3+0x4c>
  802882:	66 90                	xchg   %ax,%ax
  802884:	66 90                	xchg   %ax,%ax
  802886:	66 90                	xchg   %ax,%ax
  802888:	66 90                	xchg   %ax,%ax
  80288a:	66 90                	xchg   %ax,%ax
  80288c:	66 90                	xchg   %ax,%ax
  80288e:	66 90                	xchg   %ax,%ax

00802890 <__umoddi3>:
  802890:	55                   	push   %ebp
  802891:	57                   	push   %edi
  802892:	56                   	push   %esi
  802893:	53                   	push   %ebx
  802894:	83 ec 1c             	sub    $0x1c,%esp
  802897:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80289b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80289f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8028a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8028a7:	85 d2                	test   %edx,%edx
  8028a9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8028ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028b1:	89 f3                	mov    %esi,%ebx
  8028b3:	89 3c 24             	mov    %edi,(%esp)
  8028b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028ba:	75 1c                	jne    8028d8 <__umoddi3+0x48>
  8028bc:	39 f7                	cmp    %esi,%edi
  8028be:	76 50                	jbe    802910 <__umoddi3+0x80>
  8028c0:	89 c8                	mov    %ecx,%eax
  8028c2:	89 f2                	mov    %esi,%edx
  8028c4:	f7 f7                	div    %edi
  8028c6:	89 d0                	mov    %edx,%eax
  8028c8:	31 d2                	xor    %edx,%edx
  8028ca:	83 c4 1c             	add    $0x1c,%esp
  8028cd:	5b                   	pop    %ebx
  8028ce:	5e                   	pop    %esi
  8028cf:	5f                   	pop    %edi
  8028d0:	5d                   	pop    %ebp
  8028d1:	c3                   	ret    
  8028d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028d8:	39 f2                	cmp    %esi,%edx
  8028da:	89 d0                	mov    %edx,%eax
  8028dc:	77 52                	ja     802930 <__umoddi3+0xa0>
  8028de:	0f bd ea             	bsr    %edx,%ebp
  8028e1:	83 f5 1f             	xor    $0x1f,%ebp
  8028e4:	75 5a                	jne    802940 <__umoddi3+0xb0>
  8028e6:	3b 54 24 04          	cmp    0x4(%esp),%edx
  8028ea:	0f 82 e0 00 00 00    	jb     8029d0 <__umoddi3+0x140>
  8028f0:	39 0c 24             	cmp    %ecx,(%esp)
  8028f3:	0f 86 d7 00 00 00    	jbe    8029d0 <__umoddi3+0x140>
  8028f9:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028fd:	8b 54 24 04          	mov    0x4(%esp),%edx
  802901:	83 c4 1c             	add    $0x1c,%esp
  802904:	5b                   	pop    %ebx
  802905:	5e                   	pop    %esi
  802906:	5f                   	pop    %edi
  802907:	5d                   	pop    %ebp
  802908:	c3                   	ret    
  802909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802910:	85 ff                	test   %edi,%edi
  802912:	89 fd                	mov    %edi,%ebp
  802914:	75 0b                	jne    802921 <__umoddi3+0x91>
  802916:	b8 01 00 00 00       	mov    $0x1,%eax
  80291b:	31 d2                	xor    %edx,%edx
  80291d:	f7 f7                	div    %edi
  80291f:	89 c5                	mov    %eax,%ebp
  802921:	89 f0                	mov    %esi,%eax
  802923:	31 d2                	xor    %edx,%edx
  802925:	f7 f5                	div    %ebp
  802927:	89 c8                	mov    %ecx,%eax
  802929:	f7 f5                	div    %ebp
  80292b:	89 d0                	mov    %edx,%eax
  80292d:	eb 99                	jmp    8028c8 <__umoddi3+0x38>
  80292f:	90                   	nop
  802930:	89 c8                	mov    %ecx,%eax
  802932:	89 f2                	mov    %esi,%edx
  802934:	83 c4 1c             	add    $0x1c,%esp
  802937:	5b                   	pop    %ebx
  802938:	5e                   	pop    %esi
  802939:	5f                   	pop    %edi
  80293a:	5d                   	pop    %ebp
  80293b:	c3                   	ret    
  80293c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802940:	8b 34 24             	mov    (%esp),%esi
  802943:	bf 20 00 00 00       	mov    $0x20,%edi
  802948:	89 e9                	mov    %ebp,%ecx
  80294a:	29 ef                	sub    %ebp,%edi
  80294c:	d3 e0                	shl    %cl,%eax
  80294e:	89 f9                	mov    %edi,%ecx
  802950:	89 f2                	mov    %esi,%edx
  802952:	d3 ea                	shr    %cl,%edx
  802954:	89 e9                	mov    %ebp,%ecx
  802956:	09 c2                	or     %eax,%edx
  802958:	89 d8                	mov    %ebx,%eax
  80295a:	89 14 24             	mov    %edx,(%esp)
  80295d:	89 f2                	mov    %esi,%edx
  80295f:	d3 e2                	shl    %cl,%edx
  802961:	89 f9                	mov    %edi,%ecx
  802963:	89 54 24 04          	mov    %edx,0x4(%esp)
  802967:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80296b:	d3 e8                	shr    %cl,%eax
  80296d:	89 e9                	mov    %ebp,%ecx
  80296f:	89 c6                	mov    %eax,%esi
  802971:	d3 e3                	shl    %cl,%ebx
  802973:	89 f9                	mov    %edi,%ecx
  802975:	89 d0                	mov    %edx,%eax
  802977:	d3 e8                	shr    %cl,%eax
  802979:	89 e9                	mov    %ebp,%ecx
  80297b:	09 d8                	or     %ebx,%eax
  80297d:	89 d3                	mov    %edx,%ebx
  80297f:	89 f2                	mov    %esi,%edx
  802981:	f7 34 24             	divl   (%esp)
  802984:	89 d6                	mov    %edx,%esi
  802986:	d3 e3                	shl    %cl,%ebx
  802988:	f7 64 24 04          	mull   0x4(%esp)
  80298c:	39 d6                	cmp    %edx,%esi
  80298e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802992:	89 d1                	mov    %edx,%ecx
  802994:	89 c3                	mov    %eax,%ebx
  802996:	72 08                	jb     8029a0 <__umoddi3+0x110>
  802998:	75 11                	jne    8029ab <__umoddi3+0x11b>
  80299a:	39 44 24 08          	cmp    %eax,0x8(%esp)
  80299e:	73 0b                	jae    8029ab <__umoddi3+0x11b>
  8029a0:	2b 44 24 04          	sub    0x4(%esp),%eax
  8029a4:	1b 14 24             	sbb    (%esp),%edx
  8029a7:	89 d1                	mov    %edx,%ecx
  8029a9:	89 c3                	mov    %eax,%ebx
  8029ab:	8b 54 24 08          	mov    0x8(%esp),%edx
  8029af:	29 da                	sub    %ebx,%edx
  8029b1:	19 ce                	sbb    %ecx,%esi
  8029b3:	89 f9                	mov    %edi,%ecx
  8029b5:	89 f0                	mov    %esi,%eax
  8029b7:	d3 e0                	shl    %cl,%eax
  8029b9:	89 e9                	mov    %ebp,%ecx
  8029bb:	d3 ea                	shr    %cl,%edx
  8029bd:	89 e9                	mov    %ebp,%ecx
  8029bf:	d3 ee                	shr    %cl,%esi
  8029c1:	09 d0                	or     %edx,%eax
  8029c3:	89 f2                	mov    %esi,%edx
  8029c5:	83 c4 1c             	add    $0x1c,%esp
  8029c8:	5b                   	pop    %ebx
  8029c9:	5e                   	pop    %esi
  8029ca:	5f                   	pop    %edi
  8029cb:	5d                   	pop    %ebp
  8029cc:	c3                   	ret    
  8029cd:	8d 76 00             	lea    0x0(%esi),%esi
  8029d0:	29 f9                	sub    %edi,%ecx
  8029d2:	19 d6                	sbb    %edx,%esi
  8029d4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8029d8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029dc:	e9 18 ff ff ff       	jmp    8028f9 <__umoddi3+0x69>
