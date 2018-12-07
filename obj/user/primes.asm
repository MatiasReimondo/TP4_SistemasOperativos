
obj/user/primes.debug:     formato del fichero elf32-i386


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
  80002c:	e8 c7 00 00 00       	call   8000f8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80003f:	83 ec 04             	sub    $0x4,%esp
  800042:	6a 00                	push   $0x0
  800044:	6a 00                	push   $0x0
  800046:	56                   	push   %esi
  800047:	e8 78 11 00 00       	call   8011c4 <ipc_recv>
  80004c:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80004e:	a1 04 40 80 00       	mov    0x804004,%eax
  800053:	8b 40 5c             	mov    0x5c(%eax),%eax
  800056:	83 c4 0c             	add    $0xc,%esp
  800059:	53                   	push   %ebx
  80005a:	50                   	push   %eax
  80005b:	68 40 23 80 00       	push   $0x802340
  800060:	e8 d0 01 00 00       	call   800235 <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800065:	e8 2d 10 00 00       	call   801097 <fork>
  80006a:	89 c7                	mov    %eax,%edi
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	85 c0                	test   %eax,%eax
  800071:	79 12                	jns    800085 <primeproc+0x52>
		panic("fork: %e", id);
  800073:	50                   	push   %eax
  800074:	68 90 27 80 00       	push   $0x802790
  800079:	6a 1a                	push   $0x1a
  80007b:	68 4c 23 80 00       	push   $0x80234c
  800080:	e8 d7 00 00 00       	call   80015c <_panic>
	if (id == 0)
  800085:	85 c0                	test   %eax,%eax
  800087:	74 b6                	je     80003f <primeproc+0xc>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  800089:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80008c:	83 ec 04             	sub    $0x4,%esp
  80008f:	6a 00                	push   $0x0
  800091:	6a 00                	push   $0x0
  800093:	56                   	push   %esi
  800094:	e8 2b 11 00 00       	call   8011c4 <ipc_recv>
  800099:	89 c1                	mov    %eax,%ecx
		if (i % p)
  80009b:	99                   	cltd   
  80009c:	f7 fb                	idiv   %ebx
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	85 d2                	test   %edx,%edx
  8000a3:	74 e7                	je     80008c <primeproc+0x59>
			ipc_send(id, i, 0, 0);
  8000a5:	6a 00                	push   $0x0
  8000a7:	6a 00                	push   $0x0
  8000a9:	51                   	push   %ecx
  8000aa:	57                   	push   %edi
  8000ab:	e8 7f 11 00 00       	call   80122f <ipc_send>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	eb d7                	jmp    80008c <primeproc+0x59>

008000b5 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000ba:	e8 d8 0f 00 00       	call   801097 <fork>
  8000bf:	89 c6                	mov    %eax,%esi
  8000c1:	85 c0                	test   %eax,%eax
  8000c3:	79 12                	jns    8000d7 <umain+0x22>
		panic("fork: %e", id);
  8000c5:	50                   	push   %eax
  8000c6:	68 90 27 80 00       	push   $0x802790
  8000cb:	6a 2d                	push   $0x2d
  8000cd:	68 4c 23 80 00       	push   $0x80234c
  8000d2:	e8 85 00 00 00       	call   80015c <_panic>
  8000d7:	bb 02 00 00 00       	mov    $0x2,%ebx
	if (id == 0)
  8000dc:	85 c0                	test   %eax,%eax
  8000de:	75 05                	jne    8000e5 <umain+0x30>
		primeproc();
  8000e0:	e8 4e ff ff ff       	call   800033 <primeproc>

	// feed all the integers through
	for (i = 2; ; i++)
		ipc_send(id, i, 0, 0);
  8000e5:	6a 00                	push   $0x0
  8000e7:	6a 00                	push   $0x0
  8000e9:	53                   	push   %ebx
  8000ea:	56                   	push   %esi
  8000eb:	e8 3f 11 00 00       	call   80122f <ipc_send>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8000f0:	83 c3 01             	add    $0x1,%ebx
  8000f3:	83 c4 10             	add    $0x10,%esp
  8000f6:	eb ed                	jmp    8000e5 <umain+0x30>

008000f8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	56                   	push   %esi
  8000fc:	53                   	push   %ebx
  8000fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800100:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800103:	e8 9d 0a 00 00       	call   800ba5 <sys_getenvid>
	if (id >= 0)
  800108:	85 c0                	test   %eax,%eax
  80010a:	78 12                	js     80011e <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  80010c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800111:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800114:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800119:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80011e:	85 db                	test   %ebx,%ebx
  800120:	7e 07                	jle    800129 <libmain+0x31>
		binaryname = argv[0];
  800122:	8b 06                	mov    (%esi),%eax
  800124:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800129:	83 ec 08             	sub    $0x8,%esp
  80012c:	56                   	push   %esi
  80012d:	53                   	push   %ebx
  80012e:	e8 82 ff ff ff       	call   8000b5 <umain>

	// exit gracefully
	exit();
  800133:	e8 0a 00 00 00       	call   800142 <exit>
}
  800138:	83 c4 10             	add    $0x10,%esp
  80013b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80013e:	5b                   	pop    %ebx
  80013f:	5e                   	pop    %esi
  800140:	5d                   	pop    %ebp
  800141:	c3                   	ret    

00800142 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800142:	55                   	push   %ebp
  800143:	89 e5                	mov    %esp,%ebp
  800145:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800148:	e8 3a 13 00 00       	call   801487 <close_all>
	sys_env_destroy(0);
  80014d:	83 ec 0c             	sub    $0xc,%esp
  800150:	6a 00                	push   $0x0
  800152:	e8 2c 0a 00 00       	call   800b83 <sys_env_destroy>
}
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	c9                   	leave  
  80015b:	c3                   	ret    

0080015c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	56                   	push   %esi
  800160:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800161:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800164:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80016a:	e8 36 0a 00 00       	call   800ba5 <sys_getenvid>
  80016f:	83 ec 0c             	sub    $0xc,%esp
  800172:	ff 75 0c             	pushl  0xc(%ebp)
  800175:	ff 75 08             	pushl  0x8(%ebp)
  800178:	56                   	push   %esi
  800179:	50                   	push   %eax
  80017a:	68 64 23 80 00       	push   $0x802364
  80017f:	e8 b1 00 00 00       	call   800235 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800184:	83 c4 18             	add    $0x18,%esp
  800187:	53                   	push   %ebx
  800188:	ff 75 10             	pushl  0x10(%ebp)
  80018b:	e8 54 00 00 00       	call   8001e4 <vcprintf>
	cprintf("\n");
  800190:	c7 04 24 07 29 80 00 	movl   $0x802907,(%esp)
  800197:	e8 99 00 00 00       	call   800235 <cprintf>
  80019c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80019f:	cc                   	int3   
  8001a0:	eb fd                	jmp    80019f <_panic+0x43>

008001a2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001a2:	55                   	push   %ebp
  8001a3:	89 e5                	mov    %esp,%ebp
  8001a5:	53                   	push   %ebx
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001ac:	8b 13                	mov    (%ebx),%edx
  8001ae:	8d 42 01             	lea    0x1(%edx),%eax
  8001b1:	89 03                	mov    %eax,(%ebx)
  8001b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001b6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001ba:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001bf:	75 1a                	jne    8001db <putch+0x39>
		sys_cputs(b->buf, b->idx);
  8001c1:	83 ec 08             	sub    $0x8,%esp
  8001c4:	68 ff 00 00 00       	push   $0xff
  8001c9:	8d 43 08             	lea    0x8(%ebx),%eax
  8001cc:	50                   	push   %eax
  8001cd:	e8 67 09 00 00       	call   800b39 <sys_cputs>
		b->idx = 0;
  8001d2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001d8:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  8001db:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001e2:	c9                   	leave  
  8001e3:	c3                   	ret    

008001e4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001e4:	55                   	push   %ebp
  8001e5:	89 e5                	mov    %esp,%ebp
  8001e7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001ed:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001f4:	00 00 00 
	b.cnt = 0;
  8001f7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001fe:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800201:	ff 75 0c             	pushl  0xc(%ebp)
  800204:	ff 75 08             	pushl  0x8(%ebp)
  800207:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80020d:	50                   	push   %eax
  80020e:	68 a2 01 80 00       	push   $0x8001a2
  800213:	e8 86 01 00 00       	call   80039e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800218:	83 c4 08             	add    $0x8,%esp
  80021b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800221:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800227:	50                   	push   %eax
  800228:	e8 0c 09 00 00       	call   800b39 <sys_cputs>

	return b.cnt;
}
  80022d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800233:	c9                   	leave  
  800234:	c3                   	ret    

00800235 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800235:	55                   	push   %ebp
  800236:	89 e5                	mov    %esp,%ebp
  800238:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80023b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80023e:	50                   	push   %eax
  80023f:	ff 75 08             	pushl  0x8(%ebp)
  800242:	e8 9d ff ff ff       	call   8001e4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800247:	c9                   	leave  
  800248:	c3                   	ret    

00800249 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800249:	55                   	push   %ebp
  80024a:	89 e5                	mov    %esp,%ebp
  80024c:	57                   	push   %edi
  80024d:	56                   	push   %esi
  80024e:	53                   	push   %ebx
  80024f:	83 ec 1c             	sub    $0x1c,%esp
  800252:	89 c7                	mov    %eax,%edi
  800254:	89 d6                	mov    %edx,%esi
  800256:	8b 45 08             	mov    0x8(%ebp),%eax
  800259:	8b 55 0c             	mov    0xc(%ebp),%edx
  80025c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80025f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800262:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800265:	bb 00 00 00 00       	mov    $0x0,%ebx
  80026a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80026d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800270:	39 d3                	cmp    %edx,%ebx
  800272:	72 05                	jb     800279 <printnum+0x30>
  800274:	39 45 10             	cmp    %eax,0x10(%ebp)
  800277:	77 45                	ja     8002be <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800279:	83 ec 0c             	sub    $0xc,%esp
  80027c:	ff 75 18             	pushl  0x18(%ebp)
  80027f:	8b 45 14             	mov    0x14(%ebp),%eax
  800282:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800285:	53                   	push   %ebx
  800286:	ff 75 10             	pushl  0x10(%ebp)
  800289:	83 ec 08             	sub    $0x8,%esp
  80028c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80028f:	ff 75 e0             	pushl  -0x20(%ebp)
  800292:	ff 75 dc             	pushl  -0x24(%ebp)
  800295:	ff 75 d8             	pushl  -0x28(%ebp)
  800298:	e8 03 1e 00 00       	call   8020a0 <__udivdi3>
  80029d:	83 c4 18             	add    $0x18,%esp
  8002a0:	52                   	push   %edx
  8002a1:	50                   	push   %eax
  8002a2:	89 f2                	mov    %esi,%edx
  8002a4:	89 f8                	mov    %edi,%eax
  8002a6:	e8 9e ff ff ff       	call   800249 <printnum>
  8002ab:	83 c4 20             	add    $0x20,%esp
  8002ae:	eb 18                	jmp    8002c8 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002b0:	83 ec 08             	sub    $0x8,%esp
  8002b3:	56                   	push   %esi
  8002b4:	ff 75 18             	pushl  0x18(%ebp)
  8002b7:	ff d7                	call   *%edi
  8002b9:	83 c4 10             	add    $0x10,%esp
  8002bc:	eb 03                	jmp    8002c1 <printnum+0x78>
  8002be:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002c1:	83 eb 01             	sub    $0x1,%ebx
  8002c4:	85 db                	test   %ebx,%ebx
  8002c6:	7f e8                	jg     8002b0 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002c8:	83 ec 08             	sub    $0x8,%esp
  8002cb:	56                   	push   %esi
  8002cc:	83 ec 04             	sub    $0x4,%esp
  8002cf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d2:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d5:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d8:	ff 75 d8             	pushl  -0x28(%ebp)
  8002db:	e8 f0 1e 00 00       	call   8021d0 <__umoddi3>
  8002e0:	83 c4 14             	add    $0x14,%esp
  8002e3:	0f be 80 87 23 80 00 	movsbl 0x802387(%eax),%eax
  8002ea:	50                   	push   %eax
  8002eb:	ff d7                	call   *%edi
}
  8002ed:	83 c4 10             	add    $0x10,%esp
  8002f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f3:	5b                   	pop    %ebx
  8002f4:	5e                   	pop    %esi
  8002f5:	5f                   	pop    %edi
  8002f6:	5d                   	pop    %ebp
  8002f7:	c3                   	ret    

008002f8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002f8:	55                   	push   %ebp
  8002f9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002fb:	83 fa 01             	cmp    $0x1,%edx
  8002fe:	7e 0e                	jle    80030e <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800300:	8b 10                	mov    (%eax),%edx
  800302:	8d 4a 08             	lea    0x8(%edx),%ecx
  800305:	89 08                	mov    %ecx,(%eax)
  800307:	8b 02                	mov    (%edx),%eax
  800309:	8b 52 04             	mov    0x4(%edx),%edx
  80030c:	eb 22                	jmp    800330 <getuint+0x38>
	else if (lflag)
  80030e:	85 d2                	test   %edx,%edx
  800310:	74 10                	je     800322 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800312:	8b 10                	mov    (%eax),%edx
  800314:	8d 4a 04             	lea    0x4(%edx),%ecx
  800317:	89 08                	mov    %ecx,(%eax)
  800319:	8b 02                	mov    (%edx),%eax
  80031b:	ba 00 00 00 00       	mov    $0x0,%edx
  800320:	eb 0e                	jmp    800330 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800322:	8b 10                	mov    (%eax),%edx
  800324:	8d 4a 04             	lea    0x4(%edx),%ecx
  800327:	89 08                	mov    %ecx,(%eax)
  800329:	8b 02                	mov    (%edx),%eax
  80032b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800330:	5d                   	pop    %ebp
  800331:	c3                   	ret    

00800332 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800332:	55                   	push   %ebp
  800333:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800335:	83 fa 01             	cmp    $0x1,%edx
  800338:	7e 0e                	jle    800348 <getint+0x16>
		return va_arg(*ap, long long);
  80033a:	8b 10                	mov    (%eax),%edx
  80033c:	8d 4a 08             	lea    0x8(%edx),%ecx
  80033f:	89 08                	mov    %ecx,(%eax)
  800341:	8b 02                	mov    (%edx),%eax
  800343:	8b 52 04             	mov    0x4(%edx),%edx
  800346:	eb 1a                	jmp    800362 <getint+0x30>
	else if (lflag)
  800348:	85 d2                	test   %edx,%edx
  80034a:	74 0c                	je     800358 <getint+0x26>
		return va_arg(*ap, long);
  80034c:	8b 10                	mov    (%eax),%edx
  80034e:	8d 4a 04             	lea    0x4(%edx),%ecx
  800351:	89 08                	mov    %ecx,(%eax)
  800353:	8b 02                	mov    (%edx),%eax
  800355:	99                   	cltd   
  800356:	eb 0a                	jmp    800362 <getint+0x30>
	else
		return va_arg(*ap, int);
  800358:	8b 10                	mov    (%eax),%edx
  80035a:	8d 4a 04             	lea    0x4(%edx),%ecx
  80035d:	89 08                	mov    %ecx,(%eax)
  80035f:	8b 02                	mov    (%edx),%eax
  800361:	99                   	cltd   
}
  800362:	5d                   	pop    %ebp
  800363:	c3                   	ret    

00800364 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800364:	55                   	push   %ebp
  800365:	89 e5                	mov    %esp,%ebp
  800367:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80036a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80036e:	8b 10                	mov    (%eax),%edx
  800370:	3b 50 04             	cmp    0x4(%eax),%edx
  800373:	73 0a                	jae    80037f <sprintputch+0x1b>
		*b->buf++ = ch;
  800375:	8d 4a 01             	lea    0x1(%edx),%ecx
  800378:	89 08                	mov    %ecx,(%eax)
  80037a:	8b 45 08             	mov    0x8(%ebp),%eax
  80037d:	88 02                	mov    %al,(%edx)
}
  80037f:	5d                   	pop    %ebp
  800380:	c3                   	ret    

00800381 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800381:	55                   	push   %ebp
  800382:	89 e5                	mov    %esp,%ebp
  800384:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800387:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80038a:	50                   	push   %eax
  80038b:	ff 75 10             	pushl  0x10(%ebp)
  80038e:	ff 75 0c             	pushl  0xc(%ebp)
  800391:	ff 75 08             	pushl  0x8(%ebp)
  800394:	e8 05 00 00 00       	call   80039e <vprintfmt>
	va_end(ap);
}
  800399:	83 c4 10             	add    $0x10,%esp
  80039c:	c9                   	leave  
  80039d:	c3                   	ret    

0080039e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80039e:	55                   	push   %ebp
  80039f:	89 e5                	mov    %esp,%ebp
  8003a1:	57                   	push   %edi
  8003a2:	56                   	push   %esi
  8003a3:	53                   	push   %ebx
  8003a4:	83 ec 2c             	sub    $0x2c,%esp
  8003a7:	8b 75 08             	mov    0x8(%ebp),%esi
  8003aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003ad:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003b0:	eb 12                	jmp    8003c4 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003b2:	85 c0                	test   %eax,%eax
  8003b4:	0f 84 44 03 00 00    	je     8006fe <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  8003ba:	83 ec 08             	sub    $0x8,%esp
  8003bd:	53                   	push   %ebx
  8003be:	50                   	push   %eax
  8003bf:	ff d6                	call   *%esi
  8003c1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003c4:	83 c7 01             	add    $0x1,%edi
  8003c7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8003cb:	83 f8 25             	cmp    $0x25,%eax
  8003ce:	75 e2                	jne    8003b2 <vprintfmt+0x14>
  8003d0:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8003d4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8003db:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003e2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8003e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ee:	eb 07                	jmp    8003f7 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003f3:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003f7:	8d 47 01             	lea    0x1(%edi),%eax
  8003fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003fd:	0f b6 07             	movzbl (%edi),%eax
  800400:	0f b6 c8             	movzbl %al,%ecx
  800403:	83 e8 23             	sub    $0x23,%eax
  800406:	3c 55                	cmp    $0x55,%al
  800408:	0f 87 d5 02 00 00    	ja     8006e3 <vprintfmt+0x345>
  80040e:	0f b6 c0             	movzbl %al,%eax
  800411:	ff 24 85 c0 24 80 00 	jmp    *0x8024c0(,%eax,4)
  800418:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80041b:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80041f:	eb d6                	jmp    8003f7 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800421:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800424:	b8 00 00 00 00       	mov    $0x0,%eax
  800429:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80042c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80042f:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  800433:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  800436:	8d 51 d0             	lea    -0x30(%ecx),%edx
  800439:	83 fa 09             	cmp    $0x9,%edx
  80043c:	77 39                	ja     800477 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80043e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800441:	eb e9                	jmp    80042c <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800443:	8b 45 14             	mov    0x14(%ebp),%eax
  800446:	8d 48 04             	lea    0x4(%eax),%ecx
  800449:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80044c:	8b 00                	mov    (%eax),%eax
  80044e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800451:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800454:	eb 27                	jmp    80047d <vprintfmt+0xdf>
  800456:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800459:	85 c0                	test   %eax,%eax
  80045b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800460:	0f 49 c8             	cmovns %eax,%ecx
  800463:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800466:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800469:	eb 8c                	jmp    8003f7 <vprintfmt+0x59>
  80046b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80046e:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800475:	eb 80                	jmp    8003f7 <vprintfmt+0x59>
  800477:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80047a:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  80047d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800481:	0f 89 70 ff ff ff    	jns    8003f7 <vprintfmt+0x59>
				width = precision, precision = -1;
  800487:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80048a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80048d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800494:	e9 5e ff ff ff       	jmp    8003f7 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800499:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80049f:	e9 53 ff ff ff       	jmp    8003f7 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a7:	8d 50 04             	lea    0x4(%eax),%edx
  8004aa:	89 55 14             	mov    %edx,0x14(%ebp)
  8004ad:	83 ec 08             	sub    $0x8,%esp
  8004b0:	53                   	push   %ebx
  8004b1:	ff 30                	pushl  (%eax)
  8004b3:	ff d6                	call   *%esi
			break;
  8004b5:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  8004bb:	e9 04 ff ff ff       	jmp    8003c4 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c3:	8d 50 04             	lea    0x4(%eax),%edx
  8004c6:	89 55 14             	mov    %edx,0x14(%ebp)
  8004c9:	8b 00                	mov    (%eax),%eax
  8004cb:	99                   	cltd   
  8004cc:	31 d0                	xor    %edx,%eax
  8004ce:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004d0:	83 f8 0f             	cmp    $0xf,%eax
  8004d3:	7f 0b                	jg     8004e0 <vprintfmt+0x142>
  8004d5:	8b 14 85 20 26 80 00 	mov    0x802620(,%eax,4),%edx
  8004dc:	85 d2                	test   %edx,%edx
  8004de:	75 18                	jne    8004f8 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  8004e0:	50                   	push   %eax
  8004e1:	68 9f 23 80 00       	push   $0x80239f
  8004e6:	53                   	push   %ebx
  8004e7:	56                   	push   %esi
  8004e8:	e8 94 fe ff ff       	call   800381 <printfmt>
  8004ed:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8004f3:	e9 cc fe ff ff       	jmp    8003c4 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  8004f8:	52                   	push   %edx
  8004f9:	68 d5 28 80 00       	push   $0x8028d5
  8004fe:	53                   	push   %ebx
  8004ff:	56                   	push   %esi
  800500:	e8 7c fe ff ff       	call   800381 <printfmt>
  800505:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800508:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80050b:	e9 b4 fe ff ff       	jmp    8003c4 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800510:	8b 45 14             	mov    0x14(%ebp),%eax
  800513:	8d 50 04             	lea    0x4(%eax),%edx
  800516:	89 55 14             	mov    %edx,0x14(%ebp)
  800519:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80051b:	85 ff                	test   %edi,%edi
  80051d:	b8 98 23 80 00       	mov    $0x802398,%eax
  800522:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800525:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800529:	0f 8e 94 00 00 00    	jle    8005c3 <vprintfmt+0x225>
  80052f:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800533:	0f 84 98 00 00 00    	je     8005d1 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	ff 75 d0             	pushl  -0x30(%ebp)
  80053f:	57                   	push   %edi
  800540:	e8 41 02 00 00       	call   800786 <strnlen>
  800545:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800548:	29 c1                	sub    %eax,%ecx
  80054a:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80054d:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800550:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800554:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800557:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80055a:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80055c:	eb 0f                	jmp    80056d <vprintfmt+0x1cf>
					putch(padc, putdat);
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	53                   	push   %ebx
  800562:	ff 75 e0             	pushl  -0x20(%ebp)
  800565:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800567:	83 ef 01             	sub    $0x1,%edi
  80056a:	83 c4 10             	add    $0x10,%esp
  80056d:	85 ff                	test   %edi,%edi
  80056f:	7f ed                	jg     80055e <vprintfmt+0x1c0>
  800571:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800574:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800577:	85 c9                	test   %ecx,%ecx
  800579:	b8 00 00 00 00       	mov    $0x0,%eax
  80057e:	0f 49 c1             	cmovns %ecx,%eax
  800581:	29 c1                	sub    %eax,%ecx
  800583:	89 75 08             	mov    %esi,0x8(%ebp)
  800586:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800589:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80058c:	89 cb                	mov    %ecx,%ebx
  80058e:	eb 4d                	jmp    8005dd <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800590:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800594:	74 1b                	je     8005b1 <vprintfmt+0x213>
  800596:	0f be c0             	movsbl %al,%eax
  800599:	83 e8 20             	sub    $0x20,%eax
  80059c:	83 f8 5e             	cmp    $0x5e,%eax
  80059f:	76 10                	jbe    8005b1 <vprintfmt+0x213>
					putch('?', putdat);
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	ff 75 0c             	pushl  0xc(%ebp)
  8005a7:	6a 3f                	push   $0x3f
  8005a9:	ff 55 08             	call   *0x8(%ebp)
  8005ac:	83 c4 10             	add    $0x10,%esp
  8005af:	eb 0d                	jmp    8005be <vprintfmt+0x220>
				else
					putch(ch, putdat);
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	ff 75 0c             	pushl  0xc(%ebp)
  8005b7:	52                   	push   %edx
  8005b8:	ff 55 08             	call   *0x8(%ebp)
  8005bb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005be:	83 eb 01             	sub    $0x1,%ebx
  8005c1:	eb 1a                	jmp    8005dd <vprintfmt+0x23f>
  8005c3:	89 75 08             	mov    %esi,0x8(%ebp)
  8005c6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005c9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005cc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005cf:	eb 0c                	jmp    8005dd <vprintfmt+0x23f>
  8005d1:	89 75 08             	mov    %esi,0x8(%ebp)
  8005d4:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005d7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005da:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005dd:	83 c7 01             	add    $0x1,%edi
  8005e0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005e4:	0f be d0             	movsbl %al,%edx
  8005e7:	85 d2                	test   %edx,%edx
  8005e9:	74 23                	je     80060e <vprintfmt+0x270>
  8005eb:	85 f6                	test   %esi,%esi
  8005ed:	78 a1                	js     800590 <vprintfmt+0x1f2>
  8005ef:	83 ee 01             	sub    $0x1,%esi
  8005f2:	79 9c                	jns    800590 <vprintfmt+0x1f2>
  8005f4:	89 df                	mov    %ebx,%edi
  8005f6:	8b 75 08             	mov    0x8(%ebp),%esi
  8005f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005fc:	eb 18                	jmp    800616 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005fe:	83 ec 08             	sub    $0x8,%esp
  800601:	53                   	push   %ebx
  800602:	6a 20                	push   $0x20
  800604:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800606:	83 ef 01             	sub    $0x1,%edi
  800609:	83 c4 10             	add    $0x10,%esp
  80060c:	eb 08                	jmp    800616 <vprintfmt+0x278>
  80060e:	89 df                	mov    %ebx,%edi
  800610:	8b 75 08             	mov    0x8(%ebp),%esi
  800613:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800616:	85 ff                	test   %edi,%edi
  800618:	7f e4                	jg     8005fe <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80061a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80061d:	e9 a2 fd ff ff       	jmp    8003c4 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800622:	8d 45 14             	lea    0x14(%ebp),%eax
  800625:	e8 08 fd ff ff       	call   800332 <getint>
  80062a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800630:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800635:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800639:	79 74                	jns    8006af <vprintfmt+0x311>
				putch('-', putdat);
  80063b:	83 ec 08             	sub    $0x8,%esp
  80063e:	53                   	push   %ebx
  80063f:	6a 2d                	push   $0x2d
  800641:	ff d6                	call   *%esi
				num = -(long long) num;
  800643:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800646:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800649:	f7 d8                	neg    %eax
  80064b:	83 d2 00             	adc    $0x0,%edx
  80064e:	f7 da                	neg    %edx
  800650:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  800653:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800658:	eb 55                	jmp    8006af <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80065a:	8d 45 14             	lea    0x14(%ebp),%eax
  80065d:	e8 96 fc ff ff       	call   8002f8 <getuint>
			base = 10;
  800662:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800667:	eb 46                	jmp    8006af <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800669:	8d 45 14             	lea    0x14(%ebp),%eax
  80066c:	e8 87 fc ff ff       	call   8002f8 <getuint>
			base = 8;
  800671:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800676:	eb 37                	jmp    8006af <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  800678:	83 ec 08             	sub    $0x8,%esp
  80067b:	53                   	push   %ebx
  80067c:	6a 30                	push   $0x30
  80067e:	ff d6                	call   *%esi
			putch('x', putdat);
  800680:	83 c4 08             	add    $0x8,%esp
  800683:	53                   	push   %ebx
  800684:	6a 78                	push   $0x78
  800686:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	8d 50 04             	lea    0x4(%eax),%edx
  80068e:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800691:	8b 00                	mov    (%eax),%eax
  800693:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800698:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80069b:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8006a0:	eb 0d                	jmp    8006af <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006a2:	8d 45 14             	lea    0x14(%ebp),%eax
  8006a5:	e8 4e fc ff ff       	call   8002f8 <getuint>
			base = 16;
  8006aa:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006af:	83 ec 0c             	sub    $0xc,%esp
  8006b2:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006b6:	57                   	push   %edi
  8006b7:	ff 75 e0             	pushl  -0x20(%ebp)
  8006ba:	51                   	push   %ecx
  8006bb:	52                   	push   %edx
  8006bc:	50                   	push   %eax
  8006bd:	89 da                	mov    %ebx,%edx
  8006bf:	89 f0                	mov    %esi,%eax
  8006c1:	e8 83 fb ff ff       	call   800249 <printnum>
			break;
  8006c6:	83 c4 20             	add    $0x20,%esp
  8006c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006cc:	e9 f3 fc ff ff       	jmp    8003c4 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006d1:	83 ec 08             	sub    $0x8,%esp
  8006d4:	53                   	push   %ebx
  8006d5:	51                   	push   %ecx
  8006d6:	ff d6                	call   *%esi
			break;
  8006d8:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8006de:	e9 e1 fc ff ff       	jmp    8003c4 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006e3:	83 ec 08             	sub    $0x8,%esp
  8006e6:	53                   	push   %ebx
  8006e7:	6a 25                	push   $0x25
  8006e9:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006eb:	83 c4 10             	add    $0x10,%esp
  8006ee:	eb 03                	jmp    8006f3 <vprintfmt+0x355>
  8006f0:	83 ef 01             	sub    $0x1,%edi
  8006f3:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  8006f7:	75 f7                	jne    8006f0 <vprintfmt+0x352>
  8006f9:	e9 c6 fc ff ff       	jmp    8003c4 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  8006fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800701:	5b                   	pop    %ebx
  800702:	5e                   	pop    %esi
  800703:	5f                   	pop    %edi
  800704:	5d                   	pop    %ebp
  800705:	c3                   	ret    

00800706 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800706:	55                   	push   %ebp
  800707:	89 e5                	mov    %esp,%ebp
  800709:	83 ec 18             	sub    $0x18,%esp
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800712:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800715:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800719:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80071c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800723:	85 c0                	test   %eax,%eax
  800725:	74 26                	je     80074d <vsnprintf+0x47>
  800727:	85 d2                	test   %edx,%edx
  800729:	7e 22                	jle    80074d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80072b:	ff 75 14             	pushl  0x14(%ebp)
  80072e:	ff 75 10             	pushl  0x10(%ebp)
  800731:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800734:	50                   	push   %eax
  800735:	68 64 03 80 00       	push   $0x800364
  80073a:	e8 5f fc ff ff       	call   80039e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80073f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800742:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800748:	83 c4 10             	add    $0x10,%esp
  80074b:	eb 05                	jmp    800752 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80074d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800752:	c9                   	leave  
  800753:	c3                   	ret    

00800754 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800754:	55                   	push   %ebp
  800755:	89 e5                	mov    %esp,%ebp
  800757:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80075a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80075d:	50                   	push   %eax
  80075e:	ff 75 10             	pushl  0x10(%ebp)
  800761:	ff 75 0c             	pushl  0xc(%ebp)
  800764:	ff 75 08             	pushl  0x8(%ebp)
  800767:	e8 9a ff ff ff       	call   800706 <vsnprintf>
	va_end(ap);

	return rc;
}
  80076c:	c9                   	leave  
  80076d:	c3                   	ret    

0080076e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80076e:	55                   	push   %ebp
  80076f:	89 e5                	mov    %esp,%ebp
  800771:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800774:	b8 00 00 00 00       	mov    $0x0,%eax
  800779:	eb 03                	jmp    80077e <strlen+0x10>
		n++;
  80077b:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80077e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800782:	75 f7                	jne    80077b <strlen+0xd>
		n++;
	return n;
}
  800784:	5d                   	pop    %ebp
  800785:	c3                   	ret    

00800786 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800786:	55                   	push   %ebp
  800787:	89 e5                	mov    %esp,%ebp
  800789:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80078c:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80078f:	ba 00 00 00 00       	mov    $0x0,%edx
  800794:	eb 03                	jmp    800799 <strnlen+0x13>
		n++;
  800796:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800799:	39 c2                	cmp    %eax,%edx
  80079b:	74 08                	je     8007a5 <strnlen+0x1f>
  80079d:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8007a1:	75 f3                	jne    800796 <strnlen+0x10>
  8007a3:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  8007a5:	5d                   	pop    %ebp
  8007a6:	c3                   	ret    

008007a7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007a7:	55                   	push   %ebp
  8007a8:	89 e5                	mov    %esp,%ebp
  8007aa:	53                   	push   %ebx
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007b1:	89 c2                	mov    %eax,%edx
  8007b3:	83 c2 01             	add    $0x1,%edx
  8007b6:	83 c1 01             	add    $0x1,%ecx
  8007b9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007bd:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007c0:	84 db                	test   %bl,%bl
  8007c2:	75 ef                	jne    8007b3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007c4:	5b                   	pop    %ebx
  8007c5:	5d                   	pop    %ebp
  8007c6:	c3                   	ret    

008007c7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007c7:	55                   	push   %ebp
  8007c8:	89 e5                	mov    %esp,%ebp
  8007ca:	53                   	push   %ebx
  8007cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007ce:	53                   	push   %ebx
  8007cf:	e8 9a ff ff ff       	call   80076e <strlen>
  8007d4:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007d7:	ff 75 0c             	pushl  0xc(%ebp)
  8007da:	01 d8                	add    %ebx,%eax
  8007dc:	50                   	push   %eax
  8007dd:	e8 c5 ff ff ff       	call   8007a7 <strcpy>
	return dst;
}
  8007e2:	89 d8                	mov    %ebx,%eax
  8007e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e7:	c9                   	leave  
  8007e8:	c3                   	ret    

008007e9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007e9:	55                   	push   %ebp
  8007ea:	89 e5                	mov    %esp,%ebp
  8007ec:	56                   	push   %esi
  8007ed:	53                   	push   %ebx
  8007ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8007f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007f4:	89 f3                	mov    %esi,%ebx
  8007f6:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007f9:	89 f2                	mov    %esi,%edx
  8007fb:	eb 0f                	jmp    80080c <strncpy+0x23>
		*dst++ = *src;
  8007fd:	83 c2 01             	add    $0x1,%edx
  800800:	0f b6 01             	movzbl (%ecx),%eax
  800803:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800806:	80 39 01             	cmpb   $0x1,(%ecx)
  800809:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80080c:	39 da                	cmp    %ebx,%edx
  80080e:	75 ed                	jne    8007fd <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800810:	89 f0                	mov    %esi,%eax
  800812:	5b                   	pop    %ebx
  800813:	5e                   	pop    %esi
  800814:	5d                   	pop    %ebp
  800815:	c3                   	ret    

00800816 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800816:	55                   	push   %ebp
  800817:	89 e5                	mov    %esp,%ebp
  800819:	56                   	push   %esi
  80081a:	53                   	push   %ebx
  80081b:	8b 75 08             	mov    0x8(%ebp),%esi
  80081e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800821:	8b 55 10             	mov    0x10(%ebp),%edx
  800824:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800826:	85 d2                	test   %edx,%edx
  800828:	74 21                	je     80084b <strlcpy+0x35>
  80082a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80082e:	89 f2                	mov    %esi,%edx
  800830:	eb 09                	jmp    80083b <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800832:	83 c2 01             	add    $0x1,%edx
  800835:	83 c1 01             	add    $0x1,%ecx
  800838:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80083b:	39 c2                	cmp    %eax,%edx
  80083d:	74 09                	je     800848 <strlcpy+0x32>
  80083f:	0f b6 19             	movzbl (%ecx),%ebx
  800842:	84 db                	test   %bl,%bl
  800844:	75 ec                	jne    800832 <strlcpy+0x1c>
  800846:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  800848:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80084b:	29 f0                	sub    %esi,%eax
}
  80084d:	5b                   	pop    %ebx
  80084e:	5e                   	pop    %esi
  80084f:	5d                   	pop    %ebp
  800850:	c3                   	ret    

00800851 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
  800854:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800857:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80085a:	eb 06                	jmp    800862 <strcmp+0x11>
		p++, q++;
  80085c:	83 c1 01             	add    $0x1,%ecx
  80085f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800862:	0f b6 01             	movzbl (%ecx),%eax
  800865:	84 c0                	test   %al,%al
  800867:	74 04                	je     80086d <strcmp+0x1c>
  800869:	3a 02                	cmp    (%edx),%al
  80086b:	74 ef                	je     80085c <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80086d:	0f b6 c0             	movzbl %al,%eax
  800870:	0f b6 12             	movzbl (%edx),%edx
  800873:	29 d0                	sub    %edx,%eax
}
  800875:	5d                   	pop    %ebp
  800876:	c3                   	ret    

00800877 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
  80087a:	53                   	push   %ebx
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800881:	89 c3                	mov    %eax,%ebx
  800883:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800886:	eb 06                	jmp    80088e <strncmp+0x17>
		n--, p++, q++;
  800888:	83 c0 01             	add    $0x1,%eax
  80088b:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80088e:	39 d8                	cmp    %ebx,%eax
  800890:	74 15                	je     8008a7 <strncmp+0x30>
  800892:	0f b6 08             	movzbl (%eax),%ecx
  800895:	84 c9                	test   %cl,%cl
  800897:	74 04                	je     80089d <strncmp+0x26>
  800899:	3a 0a                	cmp    (%edx),%cl
  80089b:	74 eb                	je     800888 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80089d:	0f b6 00             	movzbl (%eax),%eax
  8008a0:	0f b6 12             	movzbl (%edx),%edx
  8008a3:	29 d0                	sub    %edx,%eax
  8008a5:	eb 05                	jmp    8008ac <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8008a7:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008ac:	5b                   	pop    %ebx
  8008ad:	5d                   	pop    %ebp
  8008ae:	c3                   	ret    

008008af <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008b9:	eb 07                	jmp    8008c2 <strchr+0x13>
		if (*s == c)
  8008bb:	38 ca                	cmp    %cl,%dl
  8008bd:	74 0f                	je     8008ce <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008bf:	83 c0 01             	add    $0x1,%eax
  8008c2:	0f b6 10             	movzbl (%eax),%edx
  8008c5:	84 d2                	test   %dl,%dl
  8008c7:	75 f2                	jne    8008bb <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8008c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008ce:	5d                   	pop    %ebp
  8008cf:	c3                   	ret    

008008d0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008da:	eb 03                	jmp    8008df <strfind+0xf>
  8008dc:	83 c0 01             	add    $0x1,%eax
  8008df:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008e2:	38 ca                	cmp    %cl,%dl
  8008e4:	74 04                	je     8008ea <strfind+0x1a>
  8008e6:	84 d2                	test   %dl,%dl
  8008e8:	75 f2                	jne    8008dc <strfind+0xc>
			break;
	return (char *) s;
}
  8008ea:	5d                   	pop    %ebp
  8008eb:	c3                   	ret    

008008ec <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008ec:	55                   	push   %ebp
  8008ed:	89 e5                	mov    %esp,%ebp
  8008ef:	57                   	push   %edi
  8008f0:	56                   	push   %esi
  8008f1:	53                   	push   %ebx
  8008f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8008f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  8008f8:	85 c9                	test   %ecx,%ecx
  8008fa:	74 37                	je     800933 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008fc:	f6 c2 03             	test   $0x3,%dl
  8008ff:	75 2a                	jne    80092b <memset+0x3f>
  800901:	f6 c1 03             	test   $0x3,%cl
  800904:	75 25                	jne    80092b <memset+0x3f>
		c &= 0xFF;
  800906:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80090a:	89 df                	mov    %ebx,%edi
  80090c:	c1 e7 08             	shl    $0x8,%edi
  80090f:	89 de                	mov    %ebx,%esi
  800911:	c1 e6 18             	shl    $0x18,%esi
  800914:	89 d8                	mov    %ebx,%eax
  800916:	c1 e0 10             	shl    $0x10,%eax
  800919:	09 f0                	or     %esi,%eax
  80091b:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  80091d:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800920:	89 f8                	mov    %edi,%eax
  800922:	09 d8                	or     %ebx,%eax
  800924:	89 d7                	mov    %edx,%edi
  800926:	fc                   	cld    
  800927:	f3 ab                	rep stos %eax,%es:(%edi)
  800929:	eb 08                	jmp    800933 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80092b:	89 d7                	mov    %edx,%edi
  80092d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800930:	fc                   	cld    
  800931:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800933:	89 d0                	mov    %edx,%eax
  800935:	5b                   	pop    %ebx
  800936:	5e                   	pop    %esi
  800937:	5f                   	pop    %edi
  800938:	5d                   	pop    %ebp
  800939:	c3                   	ret    

0080093a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	57                   	push   %edi
  80093e:	56                   	push   %esi
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	8b 75 0c             	mov    0xc(%ebp),%esi
  800945:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800948:	39 c6                	cmp    %eax,%esi
  80094a:	73 35                	jae    800981 <memmove+0x47>
  80094c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80094f:	39 d0                	cmp    %edx,%eax
  800951:	73 2e                	jae    800981 <memmove+0x47>
		s += n;
		d += n;
  800953:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800956:	89 d6                	mov    %edx,%esi
  800958:	09 fe                	or     %edi,%esi
  80095a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800960:	75 13                	jne    800975 <memmove+0x3b>
  800962:	f6 c1 03             	test   $0x3,%cl
  800965:	75 0e                	jne    800975 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  800967:	83 ef 04             	sub    $0x4,%edi
  80096a:	8d 72 fc             	lea    -0x4(%edx),%esi
  80096d:	c1 e9 02             	shr    $0x2,%ecx
  800970:	fd                   	std    
  800971:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800973:	eb 09                	jmp    80097e <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800975:	83 ef 01             	sub    $0x1,%edi
  800978:	8d 72 ff             	lea    -0x1(%edx),%esi
  80097b:	fd                   	std    
  80097c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80097e:	fc                   	cld    
  80097f:	eb 1d                	jmp    80099e <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800981:	89 f2                	mov    %esi,%edx
  800983:	09 c2                	or     %eax,%edx
  800985:	f6 c2 03             	test   $0x3,%dl
  800988:	75 0f                	jne    800999 <memmove+0x5f>
  80098a:	f6 c1 03             	test   $0x3,%cl
  80098d:	75 0a                	jne    800999 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  80098f:	c1 e9 02             	shr    $0x2,%ecx
  800992:	89 c7                	mov    %eax,%edi
  800994:	fc                   	cld    
  800995:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800997:	eb 05                	jmp    80099e <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800999:	89 c7                	mov    %eax,%edi
  80099b:	fc                   	cld    
  80099c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80099e:	5e                   	pop    %esi
  80099f:	5f                   	pop    %edi
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009a5:	ff 75 10             	pushl  0x10(%ebp)
  8009a8:	ff 75 0c             	pushl  0xc(%ebp)
  8009ab:	ff 75 08             	pushl  0x8(%ebp)
  8009ae:	e8 87 ff ff ff       	call   80093a <memmove>
}
  8009b3:	c9                   	leave  
  8009b4:	c3                   	ret    

008009b5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009b5:	55                   	push   %ebp
  8009b6:	89 e5                	mov    %esp,%ebp
  8009b8:	56                   	push   %esi
  8009b9:	53                   	push   %ebx
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c0:	89 c6                	mov    %eax,%esi
  8009c2:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009c5:	eb 1a                	jmp    8009e1 <memcmp+0x2c>
		if (*s1 != *s2)
  8009c7:	0f b6 08             	movzbl (%eax),%ecx
  8009ca:	0f b6 1a             	movzbl (%edx),%ebx
  8009cd:	38 d9                	cmp    %bl,%cl
  8009cf:	74 0a                	je     8009db <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8009d1:	0f b6 c1             	movzbl %cl,%eax
  8009d4:	0f b6 db             	movzbl %bl,%ebx
  8009d7:	29 d8                	sub    %ebx,%eax
  8009d9:	eb 0f                	jmp    8009ea <memcmp+0x35>
		s1++, s2++;
  8009db:	83 c0 01             	add    $0x1,%eax
  8009de:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009e1:	39 f0                	cmp    %esi,%eax
  8009e3:	75 e2                	jne    8009c7 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8009e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ea:	5b                   	pop    %ebx
  8009eb:	5e                   	pop    %esi
  8009ec:	5d                   	pop    %ebp
  8009ed:	c3                   	ret    

008009ee <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009ee:	55                   	push   %ebp
  8009ef:	89 e5                	mov    %esp,%ebp
  8009f1:	53                   	push   %ebx
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  8009f5:	89 c1                	mov    %eax,%ecx
  8009f7:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  8009fa:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8009fe:	eb 0a                	jmp    800a0a <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a00:	0f b6 10             	movzbl (%eax),%edx
  800a03:	39 da                	cmp    %ebx,%edx
  800a05:	74 07                	je     800a0e <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a07:	83 c0 01             	add    $0x1,%eax
  800a0a:	39 c8                	cmp    %ecx,%eax
  800a0c:	72 f2                	jb     800a00 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a0e:	5b                   	pop    %ebx
  800a0f:	5d                   	pop    %ebp
  800a10:	c3                   	ret    

00800a11 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	57                   	push   %edi
  800a15:	56                   	push   %esi
  800a16:	53                   	push   %ebx
  800a17:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a1a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a1d:	eb 03                	jmp    800a22 <strtol+0x11>
		s++;
  800a1f:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a22:	0f b6 01             	movzbl (%ecx),%eax
  800a25:	3c 20                	cmp    $0x20,%al
  800a27:	74 f6                	je     800a1f <strtol+0xe>
  800a29:	3c 09                	cmp    $0x9,%al
  800a2b:	74 f2                	je     800a1f <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a2d:	3c 2b                	cmp    $0x2b,%al
  800a2f:	75 0a                	jne    800a3b <strtol+0x2a>
		s++;
  800a31:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a34:	bf 00 00 00 00       	mov    $0x0,%edi
  800a39:	eb 11                	jmp    800a4c <strtol+0x3b>
  800a3b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800a40:	3c 2d                	cmp    $0x2d,%al
  800a42:	75 08                	jne    800a4c <strtol+0x3b>
		s++, neg = 1;
  800a44:	83 c1 01             	add    $0x1,%ecx
  800a47:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a4c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a52:	75 15                	jne    800a69 <strtol+0x58>
  800a54:	80 39 30             	cmpb   $0x30,(%ecx)
  800a57:	75 10                	jne    800a69 <strtol+0x58>
  800a59:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a5d:	75 7c                	jne    800adb <strtol+0xca>
		s += 2, base = 16;
  800a5f:	83 c1 02             	add    $0x2,%ecx
  800a62:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a67:	eb 16                	jmp    800a7f <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800a69:	85 db                	test   %ebx,%ebx
  800a6b:	75 12                	jne    800a7f <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a6d:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a72:	80 39 30             	cmpb   $0x30,(%ecx)
  800a75:	75 08                	jne    800a7f <strtol+0x6e>
		s++, base = 8;
  800a77:	83 c1 01             	add    $0x1,%ecx
  800a7a:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800a7f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a84:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800a87:	0f b6 11             	movzbl (%ecx),%edx
  800a8a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a8d:	89 f3                	mov    %esi,%ebx
  800a8f:	80 fb 09             	cmp    $0x9,%bl
  800a92:	77 08                	ja     800a9c <strtol+0x8b>
			dig = *s - '0';
  800a94:	0f be d2             	movsbl %dl,%edx
  800a97:	83 ea 30             	sub    $0x30,%edx
  800a9a:	eb 22                	jmp    800abe <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800a9c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a9f:	89 f3                	mov    %esi,%ebx
  800aa1:	80 fb 19             	cmp    $0x19,%bl
  800aa4:	77 08                	ja     800aae <strtol+0x9d>
			dig = *s - 'a' + 10;
  800aa6:	0f be d2             	movsbl %dl,%edx
  800aa9:	83 ea 57             	sub    $0x57,%edx
  800aac:	eb 10                	jmp    800abe <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800aae:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ab1:	89 f3                	mov    %esi,%ebx
  800ab3:	80 fb 19             	cmp    $0x19,%bl
  800ab6:	77 16                	ja     800ace <strtol+0xbd>
			dig = *s - 'A' + 10;
  800ab8:	0f be d2             	movsbl %dl,%edx
  800abb:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800abe:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ac1:	7d 0b                	jge    800ace <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800ac3:	83 c1 01             	add    $0x1,%ecx
  800ac6:	0f af 45 10          	imul   0x10(%ebp),%eax
  800aca:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800acc:	eb b9                	jmp    800a87 <strtol+0x76>

	if (endptr)
  800ace:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad2:	74 0d                	je     800ae1 <strtol+0xd0>
		*endptr = (char *) s;
  800ad4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ad7:	89 0e                	mov    %ecx,(%esi)
  800ad9:	eb 06                	jmp    800ae1 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800adb:	85 db                	test   %ebx,%ebx
  800add:	74 98                	je     800a77 <strtol+0x66>
  800adf:	eb 9e                	jmp    800a7f <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800ae1:	89 c2                	mov    %eax,%edx
  800ae3:	f7 da                	neg    %edx
  800ae5:	85 ff                	test   %edi,%edi
  800ae7:	0f 45 c2             	cmovne %edx,%eax
}
  800aea:	5b                   	pop    %ebx
  800aeb:	5e                   	pop    %esi
  800aec:	5f                   	pop    %edi
  800aed:	5d                   	pop    %ebp
  800aee:	c3                   	ret    

00800aef <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	57                   	push   %edi
  800af3:	56                   	push   %esi
  800af4:	53                   	push   %ebx
  800af5:	83 ec 1c             	sub    $0x1c,%esp
  800af8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800afb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800afe:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b00:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b03:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b06:	8b 7d 10             	mov    0x10(%ebp),%edi
  800b09:	8b 75 14             	mov    0x14(%ebp),%esi
  800b0c:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800b0e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b12:	74 1d                	je     800b31 <syscall+0x42>
  800b14:	85 c0                	test   %eax,%eax
  800b16:	7e 19                	jle    800b31 <syscall+0x42>
  800b18:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800b1b:	83 ec 0c             	sub    $0xc,%esp
  800b1e:	50                   	push   %eax
  800b1f:	52                   	push   %edx
  800b20:	68 7f 26 80 00       	push   $0x80267f
  800b25:	6a 23                	push   $0x23
  800b27:	68 9c 26 80 00       	push   $0x80269c
  800b2c:	e8 2b f6 ff ff       	call   80015c <_panic>

	return ret;
}
  800b31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b34:	5b                   	pop    %ebx
  800b35:	5e                   	pop    %esi
  800b36:	5f                   	pop    %edi
  800b37:	5d                   	pop    %ebp
  800b38:	c3                   	ret    

00800b39 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800b3f:	6a 00                	push   $0x0
  800b41:	6a 00                	push   $0x0
  800b43:	6a 00                	push   $0x0
  800b45:	ff 75 0c             	pushl  0xc(%ebp)
  800b48:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b50:	b8 00 00 00 00       	mov    $0x0,%eax
  800b55:	e8 95 ff ff ff       	call   800aef <syscall>
}
  800b5a:	83 c4 10             	add    $0x10,%esp
  800b5d:	c9                   	leave  
  800b5e:	c3                   	ret    

00800b5f <sys_cgetc>:

int
sys_cgetc(void)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800b65:	6a 00                	push   $0x0
  800b67:	6a 00                	push   $0x0
  800b69:	6a 00                	push   $0x0
  800b6b:	6a 00                	push   $0x0
  800b6d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b72:	ba 00 00 00 00       	mov    $0x0,%edx
  800b77:	b8 01 00 00 00       	mov    $0x1,%eax
  800b7c:	e8 6e ff ff ff       	call   800aef <syscall>
}
  800b81:	c9                   	leave  
  800b82:	c3                   	ret    

00800b83 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800b89:	6a 00                	push   $0x0
  800b8b:	6a 00                	push   $0x0
  800b8d:	6a 00                	push   $0x0
  800b8f:	6a 00                	push   $0x0
  800b91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b94:	ba 01 00 00 00       	mov    $0x1,%edx
  800b99:	b8 03 00 00 00       	mov    $0x3,%eax
  800b9e:	e8 4c ff ff ff       	call   800aef <syscall>
}
  800ba3:	c9                   	leave  
  800ba4:	c3                   	ret    

00800ba5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800bab:	6a 00                	push   $0x0
  800bad:	6a 00                	push   $0x0
  800baf:	6a 00                	push   $0x0
  800bb1:	6a 00                	push   $0x0
  800bb3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bb8:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbd:	b8 02 00 00 00       	mov    $0x2,%eax
  800bc2:	e8 28 ff ff ff       	call   800aef <syscall>
}
  800bc7:	c9                   	leave  
  800bc8:	c3                   	ret    

00800bc9 <sys_yield>:

void
sys_yield(void)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800bcf:	6a 00                	push   $0x0
  800bd1:	6a 00                	push   $0x0
  800bd3:	6a 00                	push   $0x0
  800bd5:	6a 00                	push   $0x0
  800bd7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bdc:	ba 00 00 00 00       	mov    $0x0,%edx
  800be1:	b8 0b 00 00 00       	mov    $0xb,%eax
  800be6:	e8 04 ff ff ff       	call   800aef <syscall>
}
  800beb:	83 c4 10             	add    $0x10,%esp
  800bee:	c9                   	leave  
  800bef:	c3                   	ret    

00800bf0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800bf6:	6a 00                	push   $0x0
  800bf8:	6a 00                	push   $0x0
  800bfa:	ff 75 10             	pushl  0x10(%ebp)
  800bfd:	ff 75 0c             	pushl  0xc(%ebp)
  800c00:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c03:	ba 01 00 00 00       	mov    $0x1,%edx
  800c08:	b8 04 00 00 00       	mov    $0x4,%eax
  800c0d:	e8 dd fe ff ff       	call   800aef <syscall>
}
  800c12:	c9                   	leave  
  800c13:	c3                   	ret    

00800c14 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800c1a:	ff 75 18             	pushl  0x18(%ebp)
  800c1d:	ff 75 14             	pushl  0x14(%ebp)
  800c20:	ff 75 10             	pushl  0x10(%ebp)
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c29:	ba 01 00 00 00       	mov    $0x1,%edx
  800c2e:	b8 05 00 00 00       	mov    $0x5,%eax
  800c33:	e8 b7 fe ff ff       	call   800aef <syscall>
}
  800c38:	c9                   	leave  
  800c39:	c3                   	ret    

00800c3a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
  800c3d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800c40:	6a 00                	push   $0x0
  800c42:	6a 00                	push   $0x0
  800c44:	6a 00                	push   $0x0
  800c46:	ff 75 0c             	pushl  0xc(%ebp)
  800c49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c4c:	ba 01 00 00 00       	mov    $0x1,%edx
  800c51:	b8 06 00 00 00       	mov    $0x6,%eax
  800c56:	e8 94 fe ff ff       	call   800aef <syscall>
}
  800c5b:	c9                   	leave  
  800c5c:	c3                   	ret    

00800c5d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c5d:	55                   	push   %ebp
  800c5e:	89 e5                	mov    %esp,%ebp
  800c60:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c63:	6a 00                	push   $0x0
  800c65:	6a 00                	push   $0x0
  800c67:	6a 00                	push   $0x0
  800c69:	ff 75 0c             	pushl  0xc(%ebp)
  800c6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c6f:	ba 01 00 00 00       	mov    $0x1,%edx
  800c74:	b8 08 00 00 00       	mov    $0x8,%eax
  800c79:	e8 71 fe ff ff       	call   800aef <syscall>
}
  800c7e:	c9                   	leave  
  800c7f:	c3                   	ret    

00800c80 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800c86:	6a 00                	push   $0x0
  800c88:	6a 00                	push   $0x0
  800c8a:	6a 00                	push   $0x0
  800c8c:	ff 75 0c             	pushl  0xc(%ebp)
  800c8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c92:	ba 01 00 00 00       	mov    $0x1,%edx
  800c97:	b8 09 00 00 00       	mov    $0x9,%eax
  800c9c:	e8 4e fe ff ff       	call   800aef <syscall>
}
  800ca1:	c9                   	leave  
  800ca2:	c3                   	ret    

00800ca3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800ca9:	6a 00                	push   $0x0
  800cab:	6a 00                	push   $0x0
  800cad:	6a 00                	push   $0x0
  800caf:	ff 75 0c             	pushl  0xc(%ebp)
  800cb2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cb5:	ba 01 00 00 00       	mov    $0x1,%edx
  800cba:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cbf:	e8 2b fe ff ff       	call   800aef <syscall>
}
  800cc4:	c9                   	leave  
  800cc5:	c3                   	ret    

00800cc6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800ccc:	6a 00                	push   $0x0
  800cce:	ff 75 14             	pushl  0x14(%ebp)
  800cd1:	ff 75 10             	pushl  0x10(%ebp)
  800cd4:	ff 75 0c             	pushl  0xc(%ebp)
  800cd7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cda:	ba 00 00 00 00       	mov    $0x0,%edx
  800cdf:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ce4:	e8 06 fe ff ff       	call   800aef <syscall>
}
  800ce9:	c9                   	leave  
  800cea:	c3                   	ret    

00800ceb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800cf1:	6a 00                	push   $0x0
  800cf3:	6a 00                	push   $0x0
  800cf5:	6a 00                	push   $0x0
  800cf7:	6a 00                	push   $0x0
  800cf9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cfc:	ba 01 00 00 00       	mov    $0x1,%edx
  800d01:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d06:	e8 e4 fd ff ff       	call   800aef <syscall>
}
  800d0b:	c9                   	leave  
  800d0c:	c3                   	ret    

00800d0d <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	53                   	push   %ebx
  800d11:	83 ec 04             	sub    $0x4,%esp

	int perm_w = PTE_COW|PTE_U|PTE_P;
	int perm = PTE_U|PTE_P;

	// LAB 4: Your code here.
	void *addr = (void*) (pn*PGSIZE);
  800d14:	89 d3                	mov    %edx,%ebx
  800d16:	c1 e3 0c             	shl    $0xc,%ebx

	//Si una página tiene el bit PTE_SHARE, se comparte con el hijo con los mismos permisos.
  	if (uvpt[pn] & PTE_SHARE) {
  800d19:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800d20:	f6 c5 04             	test   $0x4,%ch
  800d23:	74 3a                	je     800d5f <duppage+0x52>
    	if (sys_page_map(0, addr, envid,addr, uvpt[pn] & PTE_SYSCALL) < 0) {
  800d25:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d2c:	83 ec 0c             	sub    $0xc,%esp
  800d2f:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800d35:	52                   	push   %edx
  800d36:	53                   	push   %ebx
  800d37:	50                   	push   %eax
  800d38:	53                   	push   %ebx
  800d39:	6a 00                	push   $0x0
  800d3b:	e8 d4 fe ff ff       	call   800c14 <sys_page_map>
  800d40:	83 c4 20             	add    $0x20,%esp
  800d43:	85 c0                	test   %eax,%eax
  800d45:	0f 89 99 00 00 00    	jns    800de4 <duppage+0xd7>
 	     	panic("Error en sys_page_map");
  800d4b:	83 ec 04             	sub    $0x4,%esp
  800d4e:	68 aa 26 80 00       	push   $0x8026aa
  800d53:	6a 50                	push   $0x50
  800d55:	68 c0 26 80 00       	push   $0x8026c0
  800d5a:	e8 fd f3 ff ff       	call   80015c <_panic>
    	} 
    	return 0;
	}

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  800d5f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800d66:	f6 c1 02             	test   $0x2,%cl
  800d69:	75 0c                	jne    800d77 <duppage+0x6a>
  800d6b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d72:	f6 c6 08             	test   $0x8,%dh
  800d75:	74 5b                	je     800dd2 <duppage+0xc5>
		if (sys_page_map(0, addr, envid, addr, perm_w) < 0){
  800d77:	83 ec 0c             	sub    $0xc,%esp
  800d7a:	68 05 08 00 00       	push   $0x805
  800d7f:	53                   	push   %ebx
  800d80:	50                   	push   %eax
  800d81:	53                   	push   %ebx
  800d82:	6a 00                	push   $0x0
  800d84:	e8 8b fe ff ff       	call   800c14 <sys_page_map>
  800d89:	83 c4 20             	add    $0x20,%esp
  800d8c:	85 c0                	test   %eax,%eax
  800d8e:	79 14                	jns    800da4 <duppage+0x97>
			panic("Error mapeando pagina Padre");
  800d90:	83 ec 04             	sub    $0x4,%esp
  800d93:	68 cb 26 80 00       	push   $0x8026cb
  800d98:	6a 57                	push   $0x57
  800d9a:	68 c0 26 80 00       	push   $0x8026c0
  800d9f:	e8 b8 f3 ff ff       	call   80015c <_panic>
		}
		if (sys_page_map(0, addr, 0, addr, perm_w) < 0){
  800da4:	83 ec 0c             	sub    $0xc,%esp
  800da7:	68 05 08 00 00       	push   $0x805
  800dac:	53                   	push   %ebx
  800dad:	6a 00                	push   $0x0
  800daf:	53                   	push   %ebx
  800db0:	6a 00                	push   $0x0
  800db2:	e8 5d fe ff ff       	call   800c14 <sys_page_map>
  800db7:	83 c4 20             	add    $0x20,%esp
  800dba:	85 c0                	test   %eax,%eax
  800dbc:	79 26                	jns    800de4 <duppage+0xd7>
			panic("Error mapeando pagina Hijo");
  800dbe:	83 ec 04             	sub    $0x4,%esp
  800dc1:	68 e7 26 80 00       	push   $0x8026e7
  800dc6:	6a 5a                	push   $0x5a
  800dc8:	68 c0 26 80 00       	push   $0x8026c0
  800dcd:	e8 8a f3 ff ff       	call   80015c <_panic>
		}
	} else sys_page_map(0, addr, envid, addr, perm);
  800dd2:	83 ec 0c             	sub    $0xc,%esp
  800dd5:	6a 05                	push   $0x5
  800dd7:	53                   	push   %ebx
  800dd8:	50                   	push   %eax
  800dd9:	53                   	push   %ebx
  800dda:	6a 00                	push   $0x0
  800ddc:	e8 33 fe ff ff       	call   800c14 <sys_page_map>
  800de1:	83 c4 20             	add    $0x20,%esp
	
	return 0;
}
  800de4:	b8 00 00 00 00       	mov    $0x0,%eax
  800de9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800dec:	c9                   	leave  
  800ded:	c3                   	ret    

00800dee <dup_or_share>:
//FORK V0

static void
dup_or_share(envid_t dstenv, void *va, int perm){
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	57                   	push   %edi
  800df2:	56                   	push   %esi
  800df3:	53                   	push   %ebx
  800df4:	83 ec 0c             	sub    $0xc,%esp
  800df7:	89 c7                	mov    %eax,%edi
  800df9:	89 d6                	mov    %edx,%esi
  800dfb:	89 cb                	mov    %ecx,%ebx
	int result;
	// Si no es de escritura, comparto la pagina
	if((perm &PTE_W) != PTE_W){
  800dfd:	f6 c1 02             	test   $0x2,%cl
  800e00:	75 2d                	jne    800e2f <dup_or_share+0x41>
		if((result = sys_page_map(0, va, dstenv, va, perm))<0){
  800e02:	83 ec 0c             	sub    $0xc,%esp
  800e05:	51                   	push   %ecx
  800e06:	52                   	push   %edx
  800e07:	50                   	push   %eax
  800e08:	52                   	push   %edx
  800e09:	6a 00                	push   $0x0
  800e0b:	e8 04 fe ff ff       	call   800c14 <sys_page_map>
  800e10:	83 c4 20             	add    $0x20,%esp
  800e13:	85 c0                	test   %eax,%eax
  800e15:	0f 89 a4 00 00 00    	jns    800ebf <dup_or_share+0xd1>
			panic("Error compartiendo la pagina");
  800e1b:	83 ec 04             	sub    $0x4,%esp
  800e1e:	68 02 27 80 00       	push   $0x802702
  800e23:	6a 68                	push   $0x68
  800e25:	68 c0 26 80 00       	push   $0x8026c0
  800e2a:	e8 2d f3 ff ff       	call   80015c <_panic>
		}
	// Si es de escritura comportamiento de duppage, en dumbfork
	}else{
		if ((result = sys_page_alloc(dstenv, va, perm)) < 0){
  800e2f:	83 ec 04             	sub    $0x4,%esp
  800e32:	51                   	push   %ecx
  800e33:	52                   	push   %edx
  800e34:	50                   	push   %eax
  800e35:	e8 b6 fd ff ff       	call   800bf0 <sys_page_alloc>
  800e3a:	83 c4 10             	add    $0x10,%esp
  800e3d:	85 c0                	test   %eax,%eax
  800e3f:	79 14                	jns    800e55 <dup_or_share+0x67>
			panic("Error copiando la pagina");
  800e41:	83 ec 04             	sub    $0x4,%esp
  800e44:	68 1f 27 80 00       	push   $0x80271f
  800e49:	6a 6d                	push   $0x6d
  800e4b:	68 c0 26 80 00       	push   $0x8026c0
  800e50:	e8 07 f3 ff ff       	call   80015c <_panic>
		}
		if ((result = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0){
  800e55:	83 ec 0c             	sub    $0xc,%esp
  800e58:	53                   	push   %ebx
  800e59:	68 00 00 40 00       	push   $0x400000
  800e5e:	6a 00                	push   $0x0
  800e60:	56                   	push   %esi
  800e61:	57                   	push   %edi
  800e62:	e8 ad fd ff ff       	call   800c14 <sys_page_map>
  800e67:	83 c4 20             	add    $0x20,%esp
  800e6a:	85 c0                	test   %eax,%eax
  800e6c:	79 14                	jns    800e82 <dup_or_share+0x94>
			panic("Error copiando la pagina");
  800e6e:	83 ec 04             	sub    $0x4,%esp
  800e71:	68 1f 27 80 00       	push   $0x80271f
  800e76:	6a 70                	push   $0x70
  800e78:	68 c0 26 80 00       	push   $0x8026c0
  800e7d:	e8 da f2 ff ff       	call   80015c <_panic>
		}
		memmove(UTEMP, va, PGSIZE);
  800e82:	83 ec 04             	sub    $0x4,%esp
  800e85:	68 00 10 00 00       	push   $0x1000
  800e8a:	56                   	push   %esi
  800e8b:	68 00 00 40 00       	push   $0x400000
  800e90:	e8 a5 fa ff ff       	call   80093a <memmove>
		if ((result = sys_page_unmap(0, UTEMP)) < 0){
  800e95:	83 c4 08             	add    $0x8,%esp
  800e98:	68 00 00 40 00       	push   $0x400000
  800e9d:	6a 00                	push   $0x0
  800e9f:	e8 96 fd ff ff       	call   800c3a <sys_page_unmap>
  800ea4:	83 c4 10             	add    $0x10,%esp
  800ea7:	85 c0                	test   %eax,%eax
  800ea9:	79 14                	jns    800ebf <dup_or_share+0xd1>
			panic("Error copiando la pagina");
  800eab:	83 ec 04             	sub    $0x4,%esp
  800eae:	68 1f 27 80 00       	push   $0x80271f
  800eb3:	6a 74                	push   $0x74
  800eb5:	68 c0 26 80 00       	push   $0x8026c0
  800eba:	e8 9d f2 ff ff       	call   80015c <_panic>
		}
	}	
}
  800ebf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec2:	5b                   	pop    %ebx
  800ec3:	5e                   	pop    %esi
  800ec4:	5f                   	pop    %edi
  800ec5:	5d                   	pop    %ebp
  800ec6:	c3                   	ret    

00800ec7 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	53                   	push   %ebx
  800ecb:	83 ec 04             	sub    $0x4,%esp
  800ece:	8b 55 08             	mov    0x8(%ebp),%edx
	void *va = (void *) utf->utf_fault_va;
  800ed1:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800ed3:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  800ed7:	74 2e                	je     800f07 <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
  800ed9:	89 c2                	mov    %eax,%edx
  800edb:	c1 ea 16             	shr    $0x16,%edx
  800ede:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800ee5:	f6 c2 01             	test   $0x1,%dl
  800ee8:	74 1d                	je     800f07 <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
  800eea:	89 c2                	mov    %eax,%edx
  800eec:	c1 ea 0c             	shr    $0xc,%edx
  800eef:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
		(uvpd[PDX(va)] & PTE_P) && 
  800ef6:	f6 c1 01             	test   $0x1,%cl
  800ef9:	74 0c                	je     800f07 <pgfault+0x40>
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
  800efb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800f02:	f6 c6 08             	test   $0x8,%dh
  800f05:	75 14                	jne    800f1b <pgfault+0x54>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
		panic("No es copy-on-write");
  800f07:	83 ec 04             	sub    $0x4,%esp
  800f0a:	68 38 27 80 00       	push   $0x802738
  800f0f:	6a 21                	push   $0x21
  800f11:	68 c0 26 80 00       	push   $0x8026c0
  800f16:	e8 41 f2 ff ff       	call   80015c <_panic>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	va = ROUNDDOWN(va, PGSIZE);
  800f1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f20:	89 c3                	mov    %eax,%ebx
	if (sys_page_alloc(0, PFTEMP, perm) < 0){
  800f22:	83 ec 04             	sub    $0x4,%esp
  800f25:	6a 07                	push   $0x7
  800f27:	68 00 f0 7f 00       	push   $0x7ff000
  800f2c:	6a 00                	push   $0x0
  800f2e:	e8 bd fc ff ff       	call   800bf0 <sys_page_alloc>
  800f33:	83 c4 10             	add    $0x10,%esp
  800f36:	85 c0                	test   %eax,%eax
  800f38:	79 14                	jns    800f4e <pgfault+0x87>
		panic("Error sys_page_alloc");
  800f3a:	83 ec 04             	sub    $0x4,%esp
  800f3d:	68 4c 27 80 00       	push   $0x80274c
  800f42:	6a 2a                	push   $0x2a
  800f44:	68 c0 26 80 00       	push   $0x8026c0
  800f49:	e8 0e f2 ff ff       	call   80015c <_panic>
	}
	memcpy(PFTEMP, va, PGSIZE);
  800f4e:	83 ec 04             	sub    $0x4,%esp
  800f51:	68 00 10 00 00       	push   $0x1000
  800f56:	53                   	push   %ebx
  800f57:	68 00 f0 7f 00       	push   $0x7ff000
  800f5c:	e8 41 fa ff ff       	call   8009a2 <memcpy>
	if (sys_page_map(0, PFTEMP, 0, va, perm) < 0){
  800f61:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f68:	53                   	push   %ebx
  800f69:	6a 00                	push   $0x0
  800f6b:	68 00 f0 7f 00       	push   $0x7ff000
  800f70:	6a 00                	push   $0x0
  800f72:	e8 9d fc ff ff       	call   800c14 <sys_page_map>
  800f77:	83 c4 20             	add    $0x20,%esp
  800f7a:	85 c0                	test   %eax,%eax
  800f7c:	79 14                	jns    800f92 <pgfault+0xcb>
		panic("Error sys_page_map");
  800f7e:	83 ec 04             	sub    $0x4,%esp
  800f81:	68 61 27 80 00       	push   $0x802761
  800f86:	6a 2e                	push   $0x2e
  800f88:	68 c0 26 80 00       	push   $0x8026c0
  800f8d:	e8 ca f1 ff ff       	call   80015c <_panic>
	}
	if (sys_page_unmap(0, PFTEMP) < 0){
  800f92:	83 ec 08             	sub    $0x8,%esp
  800f95:	68 00 f0 7f 00       	push   $0x7ff000
  800f9a:	6a 00                	push   $0x0
  800f9c:	e8 99 fc ff ff       	call   800c3a <sys_page_unmap>
  800fa1:	83 c4 10             	add    $0x10,%esp
  800fa4:	85 c0                	test   %eax,%eax
  800fa6:	79 14                	jns    800fbc <pgfault+0xf5>
		panic("Error sys_page_unmap");
  800fa8:	83 ec 04             	sub    $0x4,%esp
  800fab:	68 74 27 80 00       	push   $0x802774
  800fb0:	6a 31                	push   $0x31
  800fb2:	68 c0 26 80 00       	push   $0x8026c0
  800fb7:	e8 a0 f1 ff ff       	call   80015c <_panic>
	}
	return;

}
  800fbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fbf:	c9                   	leave  
  800fc0:	c3                   	ret    

00800fc1 <fork_v0>:
		}
	}	
}

envid_t
fork_v0(void){
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
  800fc4:	57                   	push   %edi
  800fc5:	56                   	push   %esi
  800fc6:	53                   	push   %ebx
  800fc7:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800fca:	b8 07 00 00 00       	mov    $0x7,%eax
  800fcf:	cd 30                	int    $0x30
  800fd1:	89 c6                	mov    %eax,%esi
	envid_t envid;
	uint8_t *va;
	int result;	

	envid = sys_exofork();
	if (envid < 0)
  800fd3:	85 c0                	test   %eax,%eax
  800fd5:	79 15                	jns    800fec <fork_v0+0x2b>
		panic("sys_exofork: %e", envid);
  800fd7:	50                   	push   %eax
  800fd8:	68 89 27 80 00       	push   $0x802789
  800fdd:	68 81 00 00 00       	push   $0x81
  800fe2:	68 c0 26 80 00       	push   $0x8026c0
  800fe7:	e8 70 f1 ff ff       	call   80015c <_panic>
  800fec:	89 c7                	mov    %eax,%edi
  800fee:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {		
  800ff3:	85 c0                	test   %eax,%eax
  800ff5:	75 1e                	jne    801015 <fork_v0+0x54>
		thisenv = &envs[ENVX(sys_getenvid())];
  800ff7:	e8 a9 fb ff ff       	call   800ba5 <sys_getenvid>
  800ffc:	25 ff 03 00 00       	and    $0x3ff,%eax
  801001:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801004:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801009:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  80100e:	b8 00 00 00 00       	mov    $0x0,%eax
  801013:	eb 7a                	jmp    80108f <fork_v0+0xce>
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  801015:	89 d8                	mov    %ebx,%eax
  801017:	c1 e8 16             	shr    $0x16,%eax
  80101a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801021:	a8 01                	test   $0x1,%al
  801023:	74 33                	je     801058 <fork_v0+0x97>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  801025:	89 d8                	mov    %ebx,%eax
  801027:	c1 e8 0c             	shr    $0xc,%eax
  80102a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801031:	f6 c2 01             	test   $0x1,%dl
  801034:	74 22                	je     801058 <fork_v0+0x97>
  801036:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80103d:	f6 c2 04             	test   $0x4,%dl
  801040:	74 16                	je     801058 <fork_v0+0x97>
				pte_t pte =uvpt[PGNUM(va)];
  801042:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
  801049:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80104f:	89 da                	mov    %ebx,%edx
  801051:	89 f8                	mov    %edi,%eax
  801053:	e8 96 fd ff ff       	call   800dee <dup_or_share>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
  801058:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80105e:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801064:	75 af                	jne    801015 <fork_v0+0x54>
				pte_t pte =uvpt[PGNUM(va)];
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
			}
		}
	}	
	if ((result = sys_env_set_status(envid, ENV_RUNNABLE)) < 0){
  801066:	83 ec 08             	sub    $0x8,%esp
  801069:	6a 02                	push   $0x2
  80106b:	56                   	push   %esi
  80106c:	e8 ec fb ff ff       	call   800c5d <sys_env_set_status>
  801071:	83 c4 10             	add    $0x10,%esp
  801074:	85 c0                	test   %eax,%eax
  801076:	79 15                	jns    80108d <fork_v0+0xcc>

		panic("sys_env_set_status: %e", result);
  801078:	50                   	push   %eax
  801079:	68 99 27 80 00       	push   $0x802799
  80107e:	68 90 00 00 00       	push   $0x90
  801083:	68 c0 26 80 00       	push   $0x8026c0
  801088:	e8 cf f0 ff ff       	call   80015c <_panic>
	}
	return envid;
  80108d:	89 f0                	mov    %esi,%eax
}
  80108f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801092:	5b                   	pop    %ebx
  801093:	5e                   	pop    %esi
  801094:	5f                   	pop    %edi
  801095:	5d                   	pop    %ebp
  801096:	c3                   	ret    

00801097 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	57                   	push   %edi
  80109b:	56                   	push   %esi
  80109c:	53                   	push   %ebx
  80109d:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  8010a0:	68 c7 0e 80 00       	push   $0x800ec7
  8010a5:	e8 1f 0f 00 00       	call   801fc9 <set_pgfault_handler>
  8010aa:	b8 07 00 00 00       	mov    $0x7,%eax
  8010af:	cd 30                	int    $0x30
  8010b1:	89 c6                	mov    %eax,%esi

	envid_t envid;
	uint32_t va;
	envid = sys_exofork();
	if (envid < 0){
  8010b3:	83 c4 10             	add    $0x10,%esp
  8010b6:	85 c0                	test   %eax,%eax
  8010b8:	79 15                	jns    8010cf <fork+0x38>
		panic("sys_exofork: %e", envid);
  8010ba:	50                   	push   %eax
  8010bb:	68 89 27 80 00       	push   $0x802789
  8010c0:	68 b1 00 00 00       	push   $0xb1
  8010c5:	68 c0 26 80 00       	push   $0x8026c0
  8010ca:	e8 8d f0 ff ff       	call   80015c <_panic>
  8010cf:	89 c7                	mov    %eax,%edi
  8010d1:	bb 00 00 00 00       	mov    $0x0,%ebx
	}
	if (envid == 0) {		
  8010d6:	85 c0                	test   %eax,%eax
  8010d8:	75 21                	jne    8010fb <fork+0x64>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010da:	e8 c6 fa ff ff       	call   800ba5 <sys_getenvid>
  8010df:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010e4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010e7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010ec:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8010f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f6:	e9 a7 00 00 00       	jmp    8011a2 <fork+0x10b>
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  8010fb:	89 d8                	mov    %ebx,%eax
  8010fd:	c1 e8 16             	shr    $0x16,%eax
  801100:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801107:	a8 01                	test   $0x1,%al
  801109:	74 22                	je     80112d <fork+0x96>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  80110b:	89 da                	mov    %ebx,%edx
  80110d:	c1 ea 0c             	shr    $0xc,%edx
  801110:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801117:	a8 01                	test   $0x1,%al
  801119:	74 12                	je     80112d <fork+0x96>
  80111b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801122:	a8 04                	test   $0x4,%al
  801124:	74 07                	je     80112d <fork+0x96>
				duppage(envid, PGNUM(va));			
  801126:	89 f8                	mov    %edi,%eax
  801128:	e8 e0 fb ff ff       	call   800d0d <duppage>
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
  80112d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801133:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801139:	75 c0                	jne    8010fb <fork+0x64>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
				duppage(envid, PGNUM(va));			
			}
		}
	}
	if (sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P) < 0){
  80113b:	83 ec 04             	sub    $0x4,%esp
  80113e:	6a 07                	push   $0x7
  801140:	68 00 f0 bf ee       	push   $0xeebff000
  801145:	56                   	push   %esi
  801146:	e8 a5 fa ff ff       	call   800bf0 <sys_page_alloc>
  80114b:	83 c4 10             	add    $0x10,%esp
  80114e:	85 c0                	test   %eax,%eax
  801150:	79 17                	jns    801169 <fork+0xd2>
		panic("Se escribio en la pagina de excepciones");
  801152:	83 ec 04             	sub    $0x4,%esp
  801155:	68 c8 27 80 00       	push   $0x8027c8
  80115a:	68 c0 00 00 00       	push   $0xc0
  80115f:	68 c0 26 80 00       	push   $0x8026c0
  801164:	e8 f3 ef ff ff       	call   80015c <_panic>
	}	
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801169:	83 ec 08             	sub    $0x8,%esp
  80116c:	68 38 20 80 00       	push   $0x802038
  801171:	56                   	push   %esi
  801172:	e8 2c fb ff ff       	call   800ca3 <sys_env_set_pgfault_upcall>

	if (sys_env_set_status(envid, ENV_RUNNABLE) < 0)
  801177:	83 c4 08             	add    $0x8,%esp
  80117a:	6a 02                	push   $0x2
  80117c:	56                   	push   %esi
  80117d:	e8 db fa ff ff       	call   800c5d <sys_env_set_status>
  801182:	83 c4 10             	add    $0x10,%esp
  801185:	85 c0                	test   %eax,%eax
  801187:	79 17                	jns    8011a0 <fork+0x109>
		panic("Status incorrecto de enviroment");
  801189:	83 ec 04             	sub    $0x4,%esp
  80118c:	68 f0 27 80 00       	push   $0x8027f0
  801191:	68 c5 00 00 00       	push   $0xc5
  801196:	68 c0 26 80 00       	push   $0x8026c0
  80119b:	e8 bc ef ff ff       	call   80015c <_panic>

	return envid;
  8011a0:	89 f0                	mov    %esi,%eax
	
}
  8011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a5:	5b                   	pop    %ebx
  8011a6:	5e                   	pop    %esi
  8011a7:	5f                   	pop    %edi
  8011a8:	5d                   	pop    %ebp
  8011a9:	c3                   	ret    

008011aa <sfork>:


// Challenge!
int
sfork(void)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
  8011ad:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011b0:	68 b0 27 80 00       	push   $0x8027b0
  8011b5:	68 d1 00 00 00       	push   $0xd1
  8011ba:	68 c0 26 80 00       	push   $0x8026c0
  8011bf:	e8 98 ef ff ff       	call   80015c <_panic>

008011c4 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8011c4:	55                   	push   %ebp
  8011c5:	89 e5                	mov    %esp,%ebp
  8011c7:	56                   	push   %esi
  8011c8:	53                   	push   %ebx
  8011c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8011cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  8011d2:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  8011d4:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8011d9:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  8011dc:	83 ec 0c             	sub    $0xc,%esp
  8011df:	50                   	push   %eax
  8011e0:	e8 06 fb ff ff       	call   800ceb <sys_ipc_recv>
	if (from_env_store)
  8011e5:	83 c4 10             	add    $0x10,%esp
  8011e8:	85 f6                	test   %esi,%esi
  8011ea:	74 0b                	je     8011f7 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  8011ec:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8011f2:	8b 52 74             	mov    0x74(%edx),%edx
  8011f5:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8011f7:	85 db                	test   %ebx,%ebx
  8011f9:	74 0b                	je     801206 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  8011fb:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801201:	8b 52 78             	mov    0x78(%edx),%edx
  801204:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  801206:	85 c0                	test   %eax,%eax
  801208:	79 16                	jns    801220 <ipc_recv+0x5c>
		if (from_env_store)
  80120a:	85 f6                	test   %esi,%esi
  80120c:	74 06                	je     801214 <ipc_recv+0x50>
			*from_env_store = 0;
  80120e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  801214:	85 db                	test   %ebx,%ebx
  801216:	74 10                	je     801228 <ipc_recv+0x64>
			*perm_store = 0;
  801218:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80121e:	eb 08                	jmp    801228 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  801220:	a1 04 40 80 00       	mov    0x804004,%eax
  801225:	8b 40 70             	mov    0x70(%eax),%eax
}
  801228:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80122b:	5b                   	pop    %ebx
  80122c:	5e                   	pop    %esi
  80122d:	5d                   	pop    %ebp
  80122e:	c3                   	ret    

0080122f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80122f:	55                   	push   %ebp
  801230:	89 e5                	mov    %esp,%ebp
  801232:	57                   	push   %edi
  801233:	56                   	push   %esi
  801234:	53                   	push   %ebx
  801235:	83 ec 0c             	sub    $0xc,%esp
  801238:	8b 7d 08             	mov    0x8(%ebp),%edi
  80123b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80123e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  801241:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  801243:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801248:	0f 44 d8             	cmove  %eax,%ebx
  80124b:	eb 1c                	jmp    801269 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  80124d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801250:	74 12                	je     801264 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801252:	50                   	push   %eax
  801253:	68 10 28 80 00       	push   $0x802810
  801258:	6a 42                	push   $0x42
  80125a:	68 26 28 80 00       	push   $0x802826
  80125f:	e8 f8 ee ff ff       	call   80015c <_panic>
		sys_yield();
  801264:	e8 60 f9 ff ff       	call   800bc9 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801269:	ff 75 14             	pushl  0x14(%ebp)
  80126c:	53                   	push   %ebx
  80126d:	56                   	push   %esi
  80126e:	57                   	push   %edi
  80126f:	e8 52 fa ff ff       	call   800cc6 <sys_ipc_try_send>
  801274:	83 c4 10             	add    $0x10,%esp
  801277:	85 c0                	test   %eax,%eax
  801279:	75 d2                	jne    80124d <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  80127b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80127e:	5b                   	pop    %ebx
  80127f:	5e                   	pop    %esi
  801280:	5f                   	pop    %edi
  801281:	5d                   	pop    %ebp
  801282:	c3                   	ret    

00801283 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
  801286:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801289:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80128e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801291:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801297:	8b 52 50             	mov    0x50(%edx),%edx
  80129a:	39 ca                	cmp    %ecx,%edx
  80129c:	75 0d                	jne    8012ab <ipc_find_env+0x28>
			return envs[i].env_id;
  80129e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012a1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012a6:	8b 40 48             	mov    0x48(%eax),%eax
  8012a9:	eb 0f                	jmp    8012ba <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8012ab:	83 c0 01             	add    $0x1,%eax
  8012ae:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012b3:	75 d9                	jne    80128e <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8012b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ba:	5d                   	pop    %ebp
  8012bb:	c3                   	ret    

008012bc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	05 00 00 00 30       	add    $0x30000000,%eax
  8012c7:	c1 e8 0c             	shr    $0xc,%eax
}
  8012ca:	5d                   	pop    %ebp
  8012cb:	c3                   	ret    

008012cc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  8012cf:	ff 75 08             	pushl  0x8(%ebp)
  8012d2:	e8 e5 ff ff ff       	call   8012bc <fd2num>
  8012d7:	83 c4 04             	add    $0x4,%esp
  8012da:	c1 e0 0c             	shl    $0xc,%eax
  8012dd:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012e2:	c9                   	leave  
  8012e3:	c3                   	ret    

008012e4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
  8012e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ea:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012ef:	89 c2                	mov    %eax,%edx
  8012f1:	c1 ea 16             	shr    $0x16,%edx
  8012f4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012fb:	f6 c2 01             	test   $0x1,%dl
  8012fe:	74 11                	je     801311 <fd_alloc+0x2d>
  801300:	89 c2                	mov    %eax,%edx
  801302:	c1 ea 0c             	shr    $0xc,%edx
  801305:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80130c:	f6 c2 01             	test   $0x1,%dl
  80130f:	75 09                	jne    80131a <fd_alloc+0x36>
			*fd_store = fd;
  801311:	89 01                	mov    %eax,(%ecx)
			return 0;
  801313:	b8 00 00 00 00       	mov    $0x0,%eax
  801318:	eb 17                	jmp    801331 <fd_alloc+0x4d>
  80131a:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80131f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801324:	75 c9                	jne    8012ef <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801326:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80132c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801331:	5d                   	pop    %ebp
  801332:	c3                   	ret    

00801333 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801339:	83 f8 1f             	cmp    $0x1f,%eax
  80133c:	77 36                	ja     801374 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80133e:	c1 e0 0c             	shl    $0xc,%eax
  801341:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801346:	89 c2                	mov    %eax,%edx
  801348:	c1 ea 16             	shr    $0x16,%edx
  80134b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801352:	f6 c2 01             	test   $0x1,%dl
  801355:	74 24                	je     80137b <fd_lookup+0x48>
  801357:	89 c2                	mov    %eax,%edx
  801359:	c1 ea 0c             	shr    $0xc,%edx
  80135c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801363:	f6 c2 01             	test   $0x1,%dl
  801366:	74 1a                	je     801382 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801368:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136b:	89 02                	mov    %eax,(%edx)
	return 0;
  80136d:	b8 00 00 00 00       	mov    $0x0,%eax
  801372:	eb 13                	jmp    801387 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801374:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801379:	eb 0c                	jmp    801387 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80137b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801380:	eb 05                	jmp    801387 <fd_lookup+0x54>
  801382:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  801387:	5d                   	pop    %ebp
  801388:	c3                   	ret    

00801389 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	83 ec 08             	sub    $0x8,%esp
  80138f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801392:	ba ac 28 80 00       	mov    $0x8028ac,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801397:	eb 13                	jmp    8013ac <dev_lookup+0x23>
  801399:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  80139c:	39 08                	cmp    %ecx,(%eax)
  80139e:	75 0c                	jne    8013ac <dev_lookup+0x23>
			*dev = devtab[i];
  8013a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013a3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013aa:	eb 2e                	jmp    8013da <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8013ac:	8b 02                	mov    (%edx),%eax
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	75 e7                	jne    801399 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013b2:	a1 04 40 80 00       	mov    0x804004,%eax
  8013b7:	8b 40 48             	mov    0x48(%eax),%eax
  8013ba:	83 ec 04             	sub    $0x4,%esp
  8013bd:	51                   	push   %ecx
  8013be:	50                   	push   %eax
  8013bf:	68 30 28 80 00       	push   $0x802830
  8013c4:	e8 6c ee ff ff       	call   800235 <cprintf>
	*dev = 0;
  8013c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013d2:	83 c4 10             	add    $0x10,%esp
  8013d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013da:	c9                   	leave  
  8013db:	c3                   	ret    

008013dc <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8013dc:	55                   	push   %ebp
  8013dd:	89 e5                	mov    %esp,%ebp
  8013df:	56                   	push   %esi
  8013e0:	53                   	push   %ebx
  8013e1:	83 ec 10             	sub    $0x10,%esp
  8013e4:	8b 75 08             	mov    0x8(%ebp),%esi
  8013e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013ea:	56                   	push   %esi
  8013eb:	e8 cc fe ff ff       	call   8012bc <fd2num>
  8013f0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8013f3:	89 14 24             	mov    %edx,(%esp)
  8013f6:	50                   	push   %eax
  8013f7:	e8 37 ff ff ff       	call   801333 <fd_lookup>
  8013fc:	83 c4 08             	add    $0x8,%esp
  8013ff:	85 c0                	test   %eax,%eax
  801401:	78 05                	js     801408 <fd_close+0x2c>
	    || fd != fd2)
  801403:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801406:	74 0c                	je     801414 <fd_close+0x38>
		return (must_exist ? r : 0);
  801408:	84 db                	test   %bl,%bl
  80140a:	ba 00 00 00 00       	mov    $0x0,%edx
  80140f:	0f 44 c2             	cmove  %edx,%eax
  801412:	eb 41                	jmp    801455 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801414:	83 ec 08             	sub    $0x8,%esp
  801417:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80141a:	50                   	push   %eax
  80141b:	ff 36                	pushl  (%esi)
  80141d:	e8 67 ff ff ff       	call   801389 <dev_lookup>
  801422:	89 c3                	mov    %eax,%ebx
  801424:	83 c4 10             	add    $0x10,%esp
  801427:	85 c0                	test   %eax,%eax
  801429:	78 1a                	js     801445 <fd_close+0x69>
		if (dev->dev_close)
  80142b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80142e:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801431:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801436:	85 c0                	test   %eax,%eax
  801438:	74 0b                	je     801445 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  80143a:	83 ec 0c             	sub    $0xc,%esp
  80143d:	56                   	push   %esi
  80143e:	ff d0                	call   *%eax
  801440:	89 c3                	mov    %eax,%ebx
  801442:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801445:	83 ec 08             	sub    $0x8,%esp
  801448:	56                   	push   %esi
  801449:	6a 00                	push   $0x0
  80144b:	e8 ea f7 ff ff       	call   800c3a <sys_page_unmap>
	return r;
  801450:	83 c4 10             	add    $0x10,%esp
  801453:	89 d8                	mov    %ebx,%eax
}
  801455:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801458:	5b                   	pop    %ebx
  801459:	5e                   	pop    %esi
  80145a:	5d                   	pop    %ebp
  80145b:	c3                   	ret    

0080145c <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801462:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801465:	50                   	push   %eax
  801466:	ff 75 08             	pushl  0x8(%ebp)
  801469:	e8 c5 fe ff ff       	call   801333 <fd_lookup>
  80146e:	83 c4 08             	add    $0x8,%esp
  801471:	85 c0                	test   %eax,%eax
  801473:	78 10                	js     801485 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801475:	83 ec 08             	sub    $0x8,%esp
  801478:	6a 01                	push   $0x1
  80147a:	ff 75 f4             	pushl  -0xc(%ebp)
  80147d:	e8 5a ff ff ff       	call   8013dc <fd_close>
  801482:	83 c4 10             	add    $0x10,%esp
}
  801485:	c9                   	leave  
  801486:	c3                   	ret    

00801487 <close_all>:

void
close_all(void)
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	53                   	push   %ebx
  80148b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80148e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801493:	83 ec 0c             	sub    $0xc,%esp
  801496:	53                   	push   %ebx
  801497:	e8 c0 ff ff ff       	call   80145c <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80149c:	83 c3 01             	add    $0x1,%ebx
  80149f:	83 c4 10             	add    $0x10,%esp
  8014a2:	83 fb 20             	cmp    $0x20,%ebx
  8014a5:	75 ec                	jne    801493 <close_all+0xc>
		close(i);
}
  8014a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014aa:	c9                   	leave  
  8014ab:	c3                   	ret    

008014ac <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
  8014af:	57                   	push   %edi
  8014b0:	56                   	push   %esi
  8014b1:	53                   	push   %ebx
  8014b2:	83 ec 2c             	sub    $0x2c,%esp
  8014b5:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014b8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014bb:	50                   	push   %eax
  8014bc:	ff 75 08             	pushl  0x8(%ebp)
  8014bf:	e8 6f fe ff ff       	call   801333 <fd_lookup>
  8014c4:	83 c4 08             	add    $0x8,%esp
  8014c7:	85 c0                	test   %eax,%eax
  8014c9:	0f 88 c1 00 00 00    	js     801590 <dup+0xe4>
		return r;
	close(newfdnum);
  8014cf:	83 ec 0c             	sub    $0xc,%esp
  8014d2:	56                   	push   %esi
  8014d3:	e8 84 ff ff ff       	call   80145c <close>

	newfd = INDEX2FD(newfdnum);
  8014d8:	89 f3                	mov    %esi,%ebx
  8014da:	c1 e3 0c             	shl    $0xc,%ebx
  8014dd:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8014e3:	83 c4 04             	add    $0x4,%esp
  8014e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014e9:	e8 de fd ff ff       	call   8012cc <fd2data>
  8014ee:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  8014f0:	89 1c 24             	mov    %ebx,(%esp)
  8014f3:	e8 d4 fd ff ff       	call   8012cc <fd2data>
  8014f8:	83 c4 10             	add    $0x10,%esp
  8014fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014fe:	89 f8                	mov    %edi,%eax
  801500:	c1 e8 16             	shr    $0x16,%eax
  801503:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80150a:	a8 01                	test   $0x1,%al
  80150c:	74 37                	je     801545 <dup+0x99>
  80150e:	89 f8                	mov    %edi,%eax
  801510:	c1 e8 0c             	shr    $0xc,%eax
  801513:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80151a:	f6 c2 01             	test   $0x1,%dl
  80151d:	74 26                	je     801545 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80151f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801526:	83 ec 0c             	sub    $0xc,%esp
  801529:	25 07 0e 00 00       	and    $0xe07,%eax
  80152e:	50                   	push   %eax
  80152f:	ff 75 d4             	pushl  -0x2c(%ebp)
  801532:	6a 00                	push   $0x0
  801534:	57                   	push   %edi
  801535:	6a 00                	push   $0x0
  801537:	e8 d8 f6 ff ff       	call   800c14 <sys_page_map>
  80153c:	89 c7                	mov    %eax,%edi
  80153e:	83 c4 20             	add    $0x20,%esp
  801541:	85 c0                	test   %eax,%eax
  801543:	78 2e                	js     801573 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801545:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801548:	89 d0                	mov    %edx,%eax
  80154a:	c1 e8 0c             	shr    $0xc,%eax
  80154d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801554:	83 ec 0c             	sub    $0xc,%esp
  801557:	25 07 0e 00 00       	and    $0xe07,%eax
  80155c:	50                   	push   %eax
  80155d:	53                   	push   %ebx
  80155e:	6a 00                	push   $0x0
  801560:	52                   	push   %edx
  801561:	6a 00                	push   $0x0
  801563:	e8 ac f6 ff ff       	call   800c14 <sys_page_map>
  801568:	89 c7                	mov    %eax,%edi
  80156a:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  80156d:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80156f:	85 ff                	test   %edi,%edi
  801571:	79 1d                	jns    801590 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801573:	83 ec 08             	sub    $0x8,%esp
  801576:	53                   	push   %ebx
  801577:	6a 00                	push   $0x0
  801579:	e8 bc f6 ff ff       	call   800c3a <sys_page_unmap>
	sys_page_unmap(0, nva);
  80157e:	83 c4 08             	add    $0x8,%esp
  801581:	ff 75 d4             	pushl  -0x2c(%ebp)
  801584:	6a 00                	push   $0x0
  801586:	e8 af f6 ff ff       	call   800c3a <sys_page_unmap>
	return r;
  80158b:	83 c4 10             	add    $0x10,%esp
  80158e:	89 f8                	mov    %edi,%eax
}
  801590:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801593:	5b                   	pop    %ebx
  801594:	5e                   	pop    %esi
  801595:	5f                   	pop    %edi
  801596:	5d                   	pop    %ebp
  801597:	c3                   	ret    

00801598 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	53                   	push   %ebx
  80159c:	83 ec 14             	sub    $0x14,%esp
  80159f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a5:	50                   	push   %eax
  8015a6:	53                   	push   %ebx
  8015a7:	e8 87 fd ff ff       	call   801333 <fd_lookup>
  8015ac:	83 c4 08             	add    $0x8,%esp
  8015af:	89 c2                	mov    %eax,%edx
  8015b1:	85 c0                	test   %eax,%eax
  8015b3:	78 6d                	js     801622 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b5:	83 ec 08             	sub    $0x8,%esp
  8015b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015bb:	50                   	push   %eax
  8015bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bf:	ff 30                	pushl  (%eax)
  8015c1:	e8 c3 fd ff ff       	call   801389 <dev_lookup>
  8015c6:	83 c4 10             	add    $0x10,%esp
  8015c9:	85 c0                	test   %eax,%eax
  8015cb:	78 4c                	js     801619 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015d0:	8b 42 08             	mov    0x8(%edx),%eax
  8015d3:	83 e0 03             	and    $0x3,%eax
  8015d6:	83 f8 01             	cmp    $0x1,%eax
  8015d9:	75 21                	jne    8015fc <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015db:	a1 04 40 80 00       	mov    0x804004,%eax
  8015e0:	8b 40 48             	mov    0x48(%eax),%eax
  8015e3:	83 ec 04             	sub    $0x4,%esp
  8015e6:	53                   	push   %ebx
  8015e7:	50                   	push   %eax
  8015e8:	68 71 28 80 00       	push   $0x802871
  8015ed:	e8 43 ec ff ff       	call   800235 <cprintf>
		return -E_INVAL;
  8015f2:	83 c4 10             	add    $0x10,%esp
  8015f5:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8015fa:	eb 26                	jmp    801622 <read+0x8a>
	}
	if (!dev->dev_read)
  8015fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ff:	8b 40 08             	mov    0x8(%eax),%eax
  801602:	85 c0                	test   %eax,%eax
  801604:	74 17                	je     80161d <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801606:	83 ec 04             	sub    $0x4,%esp
  801609:	ff 75 10             	pushl  0x10(%ebp)
  80160c:	ff 75 0c             	pushl  0xc(%ebp)
  80160f:	52                   	push   %edx
  801610:	ff d0                	call   *%eax
  801612:	89 c2                	mov    %eax,%edx
  801614:	83 c4 10             	add    $0x10,%esp
  801617:	eb 09                	jmp    801622 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801619:	89 c2                	mov    %eax,%edx
  80161b:	eb 05                	jmp    801622 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80161d:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  801622:	89 d0                	mov    %edx,%eax
  801624:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	57                   	push   %edi
  80162d:	56                   	push   %esi
  80162e:	53                   	push   %ebx
  80162f:	83 ec 0c             	sub    $0xc,%esp
  801632:	8b 7d 08             	mov    0x8(%ebp),%edi
  801635:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801638:	bb 00 00 00 00       	mov    $0x0,%ebx
  80163d:	eb 21                	jmp    801660 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80163f:	83 ec 04             	sub    $0x4,%esp
  801642:	89 f0                	mov    %esi,%eax
  801644:	29 d8                	sub    %ebx,%eax
  801646:	50                   	push   %eax
  801647:	89 d8                	mov    %ebx,%eax
  801649:	03 45 0c             	add    0xc(%ebp),%eax
  80164c:	50                   	push   %eax
  80164d:	57                   	push   %edi
  80164e:	e8 45 ff ff ff       	call   801598 <read>
		if (m < 0)
  801653:	83 c4 10             	add    $0x10,%esp
  801656:	85 c0                	test   %eax,%eax
  801658:	78 10                	js     80166a <readn+0x41>
			return m;
		if (m == 0)
  80165a:	85 c0                	test   %eax,%eax
  80165c:	74 0a                	je     801668 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80165e:	01 c3                	add    %eax,%ebx
  801660:	39 f3                	cmp    %esi,%ebx
  801662:	72 db                	jb     80163f <readn+0x16>
  801664:	89 d8                	mov    %ebx,%eax
  801666:	eb 02                	jmp    80166a <readn+0x41>
  801668:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80166a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80166d:	5b                   	pop    %ebx
  80166e:	5e                   	pop    %esi
  80166f:	5f                   	pop    %edi
  801670:	5d                   	pop    %ebp
  801671:	c3                   	ret    

00801672 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
  801675:	53                   	push   %ebx
  801676:	83 ec 14             	sub    $0x14,%esp
  801679:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80167c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80167f:	50                   	push   %eax
  801680:	53                   	push   %ebx
  801681:	e8 ad fc ff ff       	call   801333 <fd_lookup>
  801686:	83 c4 08             	add    $0x8,%esp
  801689:	89 c2                	mov    %eax,%edx
  80168b:	85 c0                	test   %eax,%eax
  80168d:	78 68                	js     8016f7 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80168f:	83 ec 08             	sub    $0x8,%esp
  801692:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801695:	50                   	push   %eax
  801696:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801699:	ff 30                	pushl  (%eax)
  80169b:	e8 e9 fc ff ff       	call   801389 <dev_lookup>
  8016a0:	83 c4 10             	add    $0x10,%esp
  8016a3:	85 c0                	test   %eax,%eax
  8016a5:	78 47                	js     8016ee <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016aa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016ae:	75 21                	jne    8016d1 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016b0:	a1 04 40 80 00       	mov    0x804004,%eax
  8016b5:	8b 40 48             	mov    0x48(%eax),%eax
  8016b8:	83 ec 04             	sub    $0x4,%esp
  8016bb:	53                   	push   %ebx
  8016bc:	50                   	push   %eax
  8016bd:	68 8d 28 80 00       	push   $0x80288d
  8016c2:	e8 6e eb ff ff       	call   800235 <cprintf>
		return -E_INVAL;
  8016c7:	83 c4 10             	add    $0x10,%esp
  8016ca:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8016cf:	eb 26                	jmp    8016f7 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d4:	8b 52 0c             	mov    0xc(%edx),%edx
  8016d7:	85 d2                	test   %edx,%edx
  8016d9:	74 17                	je     8016f2 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016db:	83 ec 04             	sub    $0x4,%esp
  8016de:	ff 75 10             	pushl  0x10(%ebp)
  8016e1:	ff 75 0c             	pushl  0xc(%ebp)
  8016e4:	50                   	push   %eax
  8016e5:	ff d2                	call   *%edx
  8016e7:	89 c2                	mov    %eax,%edx
  8016e9:	83 c4 10             	add    $0x10,%esp
  8016ec:	eb 09                	jmp    8016f7 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016ee:	89 c2                	mov    %eax,%edx
  8016f0:	eb 05                	jmp    8016f7 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8016f2:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  8016f7:	89 d0                	mov    %edx,%eax
  8016f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <seek>:

int
seek(int fdnum, off_t offset)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801704:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801707:	50                   	push   %eax
  801708:	ff 75 08             	pushl  0x8(%ebp)
  80170b:	e8 23 fc ff ff       	call   801333 <fd_lookup>
  801710:	83 c4 08             	add    $0x8,%esp
  801713:	85 c0                	test   %eax,%eax
  801715:	78 0e                	js     801725 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801717:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80171a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801720:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
  80172a:	53                   	push   %ebx
  80172b:	83 ec 14             	sub    $0x14,%esp
  80172e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801731:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801734:	50                   	push   %eax
  801735:	53                   	push   %ebx
  801736:	e8 f8 fb ff ff       	call   801333 <fd_lookup>
  80173b:	83 c4 08             	add    $0x8,%esp
  80173e:	89 c2                	mov    %eax,%edx
  801740:	85 c0                	test   %eax,%eax
  801742:	78 65                	js     8017a9 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801744:	83 ec 08             	sub    $0x8,%esp
  801747:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80174a:	50                   	push   %eax
  80174b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174e:	ff 30                	pushl  (%eax)
  801750:	e8 34 fc ff ff       	call   801389 <dev_lookup>
  801755:	83 c4 10             	add    $0x10,%esp
  801758:	85 c0                	test   %eax,%eax
  80175a:	78 44                	js     8017a0 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80175c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801763:	75 21                	jne    801786 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801765:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80176a:	8b 40 48             	mov    0x48(%eax),%eax
  80176d:	83 ec 04             	sub    $0x4,%esp
  801770:	53                   	push   %ebx
  801771:	50                   	push   %eax
  801772:	68 50 28 80 00       	push   $0x802850
  801777:	e8 b9 ea ff ff       	call   800235 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80177c:	83 c4 10             	add    $0x10,%esp
  80177f:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801784:	eb 23                	jmp    8017a9 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  801786:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801789:	8b 52 18             	mov    0x18(%edx),%edx
  80178c:	85 d2                	test   %edx,%edx
  80178e:	74 14                	je     8017a4 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801790:	83 ec 08             	sub    $0x8,%esp
  801793:	ff 75 0c             	pushl  0xc(%ebp)
  801796:	50                   	push   %eax
  801797:	ff d2                	call   *%edx
  801799:	89 c2                	mov    %eax,%edx
  80179b:	83 c4 10             	add    $0x10,%esp
  80179e:	eb 09                	jmp    8017a9 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017a0:	89 c2                	mov    %eax,%edx
  8017a2:	eb 05                	jmp    8017a9 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8017a4:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  8017a9:	89 d0                	mov    %edx,%eax
  8017ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ae:	c9                   	leave  
  8017af:	c3                   	ret    

008017b0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	53                   	push   %ebx
  8017b4:	83 ec 14             	sub    $0x14,%esp
  8017b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017bd:	50                   	push   %eax
  8017be:	ff 75 08             	pushl  0x8(%ebp)
  8017c1:	e8 6d fb ff ff       	call   801333 <fd_lookup>
  8017c6:	83 c4 08             	add    $0x8,%esp
  8017c9:	89 c2                	mov    %eax,%edx
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	78 58                	js     801827 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017cf:	83 ec 08             	sub    $0x8,%esp
  8017d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d5:	50                   	push   %eax
  8017d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d9:	ff 30                	pushl  (%eax)
  8017db:	e8 a9 fb ff ff       	call   801389 <dev_lookup>
  8017e0:	83 c4 10             	add    $0x10,%esp
  8017e3:	85 c0                	test   %eax,%eax
  8017e5:	78 37                	js     80181e <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  8017e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ea:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017ee:	74 32                	je     801822 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017f0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017f3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017fa:	00 00 00 
	stat->st_isdir = 0;
  8017fd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801804:	00 00 00 
	stat->st_dev = dev;
  801807:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80180d:	83 ec 08             	sub    $0x8,%esp
  801810:	53                   	push   %ebx
  801811:	ff 75 f0             	pushl  -0x10(%ebp)
  801814:	ff 50 14             	call   *0x14(%eax)
  801817:	89 c2                	mov    %eax,%edx
  801819:	83 c4 10             	add    $0x10,%esp
  80181c:	eb 09                	jmp    801827 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80181e:	89 c2                	mov    %eax,%edx
  801820:	eb 05                	jmp    801827 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801822:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801827:	89 d0                	mov    %edx,%eax
  801829:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
  801831:	56                   	push   %esi
  801832:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801833:	83 ec 08             	sub    $0x8,%esp
  801836:	6a 00                	push   $0x0
  801838:	ff 75 08             	pushl  0x8(%ebp)
  80183b:	e8 06 02 00 00       	call   801a46 <open>
  801840:	89 c3                	mov    %eax,%ebx
  801842:	83 c4 10             	add    $0x10,%esp
  801845:	85 c0                	test   %eax,%eax
  801847:	78 1b                	js     801864 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801849:	83 ec 08             	sub    $0x8,%esp
  80184c:	ff 75 0c             	pushl  0xc(%ebp)
  80184f:	50                   	push   %eax
  801850:	e8 5b ff ff ff       	call   8017b0 <fstat>
  801855:	89 c6                	mov    %eax,%esi
	close(fd);
  801857:	89 1c 24             	mov    %ebx,(%esp)
  80185a:	e8 fd fb ff ff       	call   80145c <close>
	return r;
  80185f:	83 c4 10             	add    $0x10,%esp
  801862:	89 f0                	mov    %esi,%eax
}
  801864:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801867:	5b                   	pop    %ebx
  801868:	5e                   	pop    %esi
  801869:	5d                   	pop    %ebp
  80186a:	c3                   	ret    

0080186b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
  80186e:	56                   	push   %esi
  80186f:	53                   	push   %ebx
  801870:	89 c6                	mov    %eax,%esi
  801872:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801874:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80187b:	75 12                	jne    80188f <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80187d:	83 ec 0c             	sub    $0xc,%esp
  801880:	6a 01                	push   $0x1
  801882:	e8 fc f9 ff ff       	call   801283 <ipc_find_env>
  801887:	a3 00 40 80 00       	mov    %eax,0x804000
  80188c:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80188f:	6a 07                	push   $0x7
  801891:	68 00 50 80 00       	push   $0x805000
  801896:	56                   	push   %esi
  801897:	ff 35 00 40 80 00    	pushl  0x804000
  80189d:	e8 8d f9 ff ff       	call   80122f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018a2:	83 c4 0c             	add    $0xc,%esp
  8018a5:	6a 00                	push   $0x0
  8018a7:	53                   	push   %ebx
  8018a8:	6a 00                	push   $0x0
  8018aa:	e8 15 f9 ff ff       	call   8011c4 <ipc_recv>
}
  8018af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b2:	5b                   	pop    %ebx
  8018b3:	5e                   	pop    %esi
  8018b4:	5d                   	pop    %ebp
  8018b5:	c3                   	ret    

008018b6 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ca:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d4:	b8 02 00 00 00       	mov    $0x2,%eax
  8018d9:	e8 8d ff ff ff       	call   80186b <fsipc>
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ec:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f6:	b8 06 00 00 00       	mov    $0x6,%eax
  8018fb:	e8 6b ff ff ff       	call   80186b <fsipc>
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	53                   	push   %ebx
  801906:	83 ec 04             	sub    $0x4,%esp
  801909:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	8b 40 0c             	mov    0xc(%eax),%eax
  801912:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801917:	ba 00 00 00 00       	mov    $0x0,%edx
  80191c:	b8 05 00 00 00       	mov    $0x5,%eax
  801921:	e8 45 ff ff ff       	call   80186b <fsipc>
  801926:	85 c0                	test   %eax,%eax
  801928:	78 2c                	js     801956 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80192a:	83 ec 08             	sub    $0x8,%esp
  80192d:	68 00 50 80 00       	push   $0x805000
  801932:	53                   	push   %ebx
  801933:	e8 6f ee ff ff       	call   8007a7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801938:	a1 80 50 80 00       	mov    0x805080,%eax
  80193d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801943:	a1 84 50 80 00       	mov    0x805084,%eax
  801948:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80194e:	83 c4 10             	add    $0x10,%esp
  801951:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801956:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	83 ec 08             	sub    $0x8,%esp
  801961:	8b 55 0c             	mov    0xc(%ebp),%edx
  801964:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801967:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80196a:	8b 49 0c             	mov    0xc(%ecx),%ecx
  80196d:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  801973:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801978:	76 22                	jbe    80199c <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  80197a:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  801981:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  801984:	83 ec 04             	sub    $0x4,%esp
  801987:	68 f8 0f 00 00       	push   $0xff8
  80198c:	52                   	push   %edx
  80198d:	68 08 50 80 00       	push   $0x805008
  801992:	e8 a3 ef ff ff       	call   80093a <memmove>
  801997:	83 c4 10             	add    $0x10,%esp
  80199a:	eb 17                	jmp    8019b3 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  80199c:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  8019a1:	83 ec 04             	sub    $0x4,%esp
  8019a4:	50                   	push   %eax
  8019a5:	52                   	push   %edx
  8019a6:	68 08 50 80 00       	push   $0x805008
  8019ab:	e8 8a ef ff ff       	call   80093a <memmove>
  8019b0:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  8019b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b8:	b8 04 00 00 00       	mov    $0x4,%eax
  8019bd:	e8 a9 fe ff ff       	call   80186b <fsipc>
	if (result < 0)
		return result;

	return result;
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	56                   	push   %esi
  8019c8:	53                   	push   %ebx
  8019c9:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019d7:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e2:	b8 03 00 00 00       	mov    $0x3,%eax
  8019e7:	e8 7f fe ff ff       	call   80186b <fsipc>
  8019ec:	89 c3                	mov    %eax,%ebx
  8019ee:	85 c0                	test   %eax,%eax
  8019f0:	78 4b                	js     801a3d <devfile_read+0x79>
		return r;
	assert(r <= n);
  8019f2:	39 c6                	cmp    %eax,%esi
  8019f4:	73 16                	jae    801a0c <devfile_read+0x48>
  8019f6:	68 bc 28 80 00       	push   $0x8028bc
  8019fb:	68 c3 28 80 00       	push   $0x8028c3
  801a00:	6a 7c                	push   $0x7c
  801a02:	68 d8 28 80 00       	push   $0x8028d8
  801a07:	e8 50 e7 ff ff       	call   80015c <_panic>
	assert(r <= PGSIZE);
  801a0c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a11:	7e 16                	jle    801a29 <devfile_read+0x65>
  801a13:	68 e3 28 80 00       	push   $0x8028e3
  801a18:	68 c3 28 80 00       	push   $0x8028c3
  801a1d:	6a 7d                	push   $0x7d
  801a1f:	68 d8 28 80 00       	push   $0x8028d8
  801a24:	e8 33 e7 ff ff       	call   80015c <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a29:	83 ec 04             	sub    $0x4,%esp
  801a2c:	50                   	push   %eax
  801a2d:	68 00 50 80 00       	push   $0x805000
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	e8 00 ef ff ff       	call   80093a <memmove>
	return r;
  801a3a:	83 c4 10             	add    $0x10,%esp
}
  801a3d:	89 d8                	mov    %ebx,%eax
  801a3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a42:	5b                   	pop    %ebx
  801a43:	5e                   	pop    %esi
  801a44:	5d                   	pop    %ebp
  801a45:	c3                   	ret    

00801a46 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	53                   	push   %ebx
  801a4a:	83 ec 20             	sub    $0x20,%esp
  801a4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801a50:	53                   	push   %ebx
  801a51:	e8 18 ed ff ff       	call   80076e <strlen>
  801a56:	83 c4 10             	add    $0x10,%esp
  801a59:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a5e:	7f 67                	jg     801ac7 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801a60:	83 ec 0c             	sub    $0xc,%esp
  801a63:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a66:	50                   	push   %eax
  801a67:	e8 78 f8 ff ff       	call   8012e4 <fd_alloc>
  801a6c:	83 c4 10             	add    $0x10,%esp
		return r;
  801a6f:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801a71:	85 c0                	test   %eax,%eax
  801a73:	78 57                	js     801acc <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801a75:	83 ec 08             	sub    $0x8,%esp
  801a78:	53                   	push   %ebx
  801a79:	68 00 50 80 00       	push   $0x805000
  801a7e:	e8 24 ed ff ff       	call   8007a7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a83:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a86:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a93:	e8 d3 fd ff ff       	call   80186b <fsipc>
  801a98:	89 c3                	mov    %eax,%ebx
  801a9a:	83 c4 10             	add    $0x10,%esp
  801a9d:	85 c0                	test   %eax,%eax
  801a9f:	79 14                	jns    801ab5 <open+0x6f>
		fd_close(fd, 0);
  801aa1:	83 ec 08             	sub    $0x8,%esp
  801aa4:	6a 00                	push   $0x0
  801aa6:	ff 75 f4             	pushl  -0xc(%ebp)
  801aa9:	e8 2e f9 ff ff       	call   8013dc <fd_close>
		return r;
  801aae:	83 c4 10             	add    $0x10,%esp
  801ab1:	89 da                	mov    %ebx,%edx
  801ab3:	eb 17                	jmp    801acc <open+0x86>
	}

	return fd2num(fd);
  801ab5:	83 ec 0c             	sub    $0xc,%esp
  801ab8:	ff 75 f4             	pushl  -0xc(%ebp)
  801abb:	e8 fc f7 ff ff       	call   8012bc <fd2num>
  801ac0:	89 c2                	mov    %eax,%edx
  801ac2:	83 c4 10             	add    $0x10,%esp
  801ac5:	eb 05                	jmp    801acc <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801ac7:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801acc:	89 d0                	mov    %edx,%eax
  801ace:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
  801ad6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ad9:	ba 00 00 00 00       	mov    $0x0,%edx
  801ade:	b8 08 00 00 00       	mov    $0x8,%eax
  801ae3:	e8 83 fd ff ff       	call   80186b <fsipc>
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
  801aed:	56                   	push   %esi
  801aee:	53                   	push   %ebx
  801aef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801af2:	83 ec 0c             	sub    $0xc,%esp
  801af5:	ff 75 08             	pushl  0x8(%ebp)
  801af8:	e8 cf f7 ff ff       	call   8012cc <fd2data>
  801afd:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801aff:	83 c4 08             	add    $0x8,%esp
  801b02:	68 ef 28 80 00       	push   $0x8028ef
  801b07:	53                   	push   %ebx
  801b08:	e8 9a ec ff ff       	call   8007a7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b0d:	8b 46 04             	mov    0x4(%esi),%eax
  801b10:	2b 06                	sub    (%esi),%eax
  801b12:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b18:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b1f:	00 00 00 
	stat->st_dev = &devpipe;
  801b22:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b29:	30 80 00 
	return 0;
}
  801b2c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b34:	5b                   	pop    %ebx
  801b35:	5e                   	pop    %esi
  801b36:	5d                   	pop    %ebp
  801b37:	c3                   	ret    

00801b38 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
  801b3b:	53                   	push   %ebx
  801b3c:	83 ec 0c             	sub    $0xc,%esp
  801b3f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b42:	53                   	push   %ebx
  801b43:	6a 00                	push   $0x0
  801b45:	e8 f0 f0 ff ff       	call   800c3a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b4a:	89 1c 24             	mov    %ebx,(%esp)
  801b4d:	e8 7a f7 ff ff       	call   8012cc <fd2data>
  801b52:	83 c4 08             	add    $0x8,%esp
  801b55:	50                   	push   %eax
  801b56:	6a 00                	push   $0x0
  801b58:	e8 dd f0 ff ff       	call   800c3a <sys_page_unmap>
}
  801b5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
  801b65:	57                   	push   %edi
  801b66:	56                   	push   %esi
  801b67:	53                   	push   %ebx
  801b68:	83 ec 1c             	sub    $0x1c,%esp
  801b6b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801b6e:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801b70:	a1 04 40 80 00       	mov    0x804004,%eax
  801b75:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801b78:	83 ec 0c             	sub    $0xc,%esp
  801b7b:	ff 75 e0             	pushl  -0x20(%ebp)
  801b7e:	e8 d9 04 00 00       	call   80205c <pageref>
  801b83:	89 c3                	mov    %eax,%ebx
  801b85:	89 3c 24             	mov    %edi,(%esp)
  801b88:	e8 cf 04 00 00       	call   80205c <pageref>
  801b8d:	83 c4 10             	add    $0x10,%esp
  801b90:	39 c3                	cmp    %eax,%ebx
  801b92:	0f 94 c1             	sete   %cl
  801b95:	0f b6 c9             	movzbl %cl,%ecx
  801b98:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801b9b:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801ba1:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ba4:	39 ce                	cmp    %ecx,%esi
  801ba6:	74 1b                	je     801bc3 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801ba8:	39 c3                	cmp    %eax,%ebx
  801baa:	75 c4                	jne    801b70 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801bac:	8b 42 58             	mov    0x58(%edx),%eax
  801baf:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bb2:	50                   	push   %eax
  801bb3:	56                   	push   %esi
  801bb4:	68 f6 28 80 00       	push   $0x8028f6
  801bb9:	e8 77 e6 ff ff       	call   800235 <cprintf>
  801bbe:	83 c4 10             	add    $0x10,%esp
  801bc1:	eb ad                	jmp    801b70 <_pipeisclosed+0xe>
	}
}
  801bc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bc9:	5b                   	pop    %ebx
  801bca:	5e                   	pop    %esi
  801bcb:	5f                   	pop    %edi
  801bcc:	5d                   	pop    %ebp
  801bcd:	c3                   	ret    

00801bce <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
  801bd1:	57                   	push   %edi
  801bd2:	56                   	push   %esi
  801bd3:	53                   	push   %ebx
  801bd4:	83 ec 28             	sub    $0x28,%esp
  801bd7:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801bda:	56                   	push   %esi
  801bdb:	e8 ec f6 ff ff       	call   8012cc <fd2data>
  801be0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801be2:	83 c4 10             	add    $0x10,%esp
  801be5:	bf 00 00 00 00       	mov    $0x0,%edi
  801bea:	eb 4b                	jmp    801c37 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801bec:	89 da                	mov    %ebx,%edx
  801bee:	89 f0                	mov    %esi,%eax
  801bf0:	e8 6d ff ff ff       	call   801b62 <_pipeisclosed>
  801bf5:	85 c0                	test   %eax,%eax
  801bf7:	75 48                	jne    801c41 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801bf9:	e8 cb ef ff ff       	call   800bc9 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bfe:	8b 43 04             	mov    0x4(%ebx),%eax
  801c01:	8b 0b                	mov    (%ebx),%ecx
  801c03:	8d 51 20             	lea    0x20(%ecx),%edx
  801c06:	39 d0                	cmp    %edx,%eax
  801c08:	73 e2                	jae    801bec <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c0d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c11:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c14:	89 c2                	mov    %eax,%edx
  801c16:	c1 fa 1f             	sar    $0x1f,%edx
  801c19:	89 d1                	mov    %edx,%ecx
  801c1b:	c1 e9 1b             	shr    $0x1b,%ecx
  801c1e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c21:	83 e2 1f             	and    $0x1f,%edx
  801c24:	29 ca                	sub    %ecx,%edx
  801c26:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c2a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c2e:	83 c0 01             	add    $0x1,%eax
  801c31:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c34:	83 c7 01             	add    $0x1,%edi
  801c37:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c3a:	75 c2                	jne    801bfe <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801c3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c3f:	eb 05                	jmp    801c46 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801c41:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801c46:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c49:	5b                   	pop    %ebx
  801c4a:	5e                   	pop    %esi
  801c4b:	5f                   	pop    %edi
  801c4c:	5d                   	pop    %ebp
  801c4d:	c3                   	ret    

00801c4e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
  801c51:	57                   	push   %edi
  801c52:	56                   	push   %esi
  801c53:	53                   	push   %ebx
  801c54:	83 ec 18             	sub    $0x18,%esp
  801c57:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801c5a:	57                   	push   %edi
  801c5b:	e8 6c f6 ff ff       	call   8012cc <fd2data>
  801c60:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c62:	83 c4 10             	add    $0x10,%esp
  801c65:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c6a:	eb 3d                	jmp    801ca9 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801c6c:	85 db                	test   %ebx,%ebx
  801c6e:	74 04                	je     801c74 <devpipe_read+0x26>
				return i;
  801c70:	89 d8                	mov    %ebx,%eax
  801c72:	eb 44                	jmp    801cb8 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801c74:	89 f2                	mov    %esi,%edx
  801c76:	89 f8                	mov    %edi,%eax
  801c78:	e8 e5 fe ff ff       	call   801b62 <_pipeisclosed>
  801c7d:	85 c0                	test   %eax,%eax
  801c7f:	75 32                	jne    801cb3 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801c81:	e8 43 ef ff ff       	call   800bc9 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801c86:	8b 06                	mov    (%esi),%eax
  801c88:	3b 46 04             	cmp    0x4(%esi),%eax
  801c8b:	74 df                	je     801c6c <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c8d:	99                   	cltd   
  801c8e:	c1 ea 1b             	shr    $0x1b,%edx
  801c91:	01 d0                	add    %edx,%eax
  801c93:	83 e0 1f             	and    $0x1f,%eax
  801c96:	29 d0                	sub    %edx,%eax
  801c98:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801c9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ca0:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801ca3:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ca6:	83 c3 01             	add    $0x1,%ebx
  801ca9:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801cac:	75 d8                	jne    801c86 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801cae:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb1:	eb 05                	jmp    801cb8 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801cb3:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801cb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cbb:	5b                   	pop    %ebx
  801cbc:	5e                   	pop    %esi
  801cbd:	5f                   	pop    %edi
  801cbe:	5d                   	pop    %ebp
  801cbf:	c3                   	ret    

00801cc0 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	56                   	push   %esi
  801cc4:	53                   	push   %ebx
  801cc5:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801cc8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ccb:	50                   	push   %eax
  801ccc:	e8 13 f6 ff ff       	call   8012e4 <fd_alloc>
  801cd1:	83 c4 10             	add    $0x10,%esp
  801cd4:	89 c2                	mov    %eax,%edx
  801cd6:	85 c0                	test   %eax,%eax
  801cd8:	0f 88 2c 01 00 00    	js     801e0a <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cde:	83 ec 04             	sub    $0x4,%esp
  801ce1:	68 07 04 00 00       	push   $0x407
  801ce6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ce9:	6a 00                	push   $0x0
  801ceb:	e8 00 ef ff ff       	call   800bf0 <sys_page_alloc>
  801cf0:	83 c4 10             	add    $0x10,%esp
  801cf3:	89 c2                	mov    %eax,%edx
  801cf5:	85 c0                	test   %eax,%eax
  801cf7:	0f 88 0d 01 00 00    	js     801e0a <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801cfd:	83 ec 0c             	sub    $0xc,%esp
  801d00:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d03:	50                   	push   %eax
  801d04:	e8 db f5 ff ff       	call   8012e4 <fd_alloc>
  801d09:	89 c3                	mov    %eax,%ebx
  801d0b:	83 c4 10             	add    $0x10,%esp
  801d0e:	85 c0                	test   %eax,%eax
  801d10:	0f 88 e2 00 00 00    	js     801df8 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d16:	83 ec 04             	sub    $0x4,%esp
  801d19:	68 07 04 00 00       	push   $0x407
  801d1e:	ff 75 f0             	pushl  -0x10(%ebp)
  801d21:	6a 00                	push   $0x0
  801d23:	e8 c8 ee ff ff       	call   800bf0 <sys_page_alloc>
  801d28:	89 c3                	mov    %eax,%ebx
  801d2a:	83 c4 10             	add    $0x10,%esp
  801d2d:	85 c0                	test   %eax,%eax
  801d2f:	0f 88 c3 00 00 00    	js     801df8 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801d35:	83 ec 0c             	sub    $0xc,%esp
  801d38:	ff 75 f4             	pushl  -0xc(%ebp)
  801d3b:	e8 8c f5 ff ff       	call   8012cc <fd2data>
  801d40:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d42:	83 c4 0c             	add    $0xc,%esp
  801d45:	68 07 04 00 00       	push   $0x407
  801d4a:	50                   	push   %eax
  801d4b:	6a 00                	push   $0x0
  801d4d:	e8 9e ee ff ff       	call   800bf0 <sys_page_alloc>
  801d52:	89 c3                	mov    %eax,%ebx
  801d54:	83 c4 10             	add    $0x10,%esp
  801d57:	85 c0                	test   %eax,%eax
  801d59:	0f 88 89 00 00 00    	js     801de8 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d5f:	83 ec 0c             	sub    $0xc,%esp
  801d62:	ff 75 f0             	pushl  -0x10(%ebp)
  801d65:	e8 62 f5 ff ff       	call   8012cc <fd2data>
  801d6a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d71:	50                   	push   %eax
  801d72:	6a 00                	push   $0x0
  801d74:	56                   	push   %esi
  801d75:	6a 00                	push   $0x0
  801d77:	e8 98 ee ff ff       	call   800c14 <sys_page_map>
  801d7c:	89 c3                	mov    %eax,%ebx
  801d7e:	83 c4 20             	add    $0x20,%esp
  801d81:	85 c0                	test   %eax,%eax
  801d83:	78 55                	js     801dda <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801d85:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8e:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d93:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801d9a:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da3:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801daf:	83 ec 0c             	sub    $0xc,%esp
  801db2:	ff 75 f4             	pushl  -0xc(%ebp)
  801db5:	e8 02 f5 ff ff       	call   8012bc <fd2num>
  801dba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dbd:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801dbf:	83 c4 04             	add    $0x4,%esp
  801dc2:	ff 75 f0             	pushl  -0x10(%ebp)
  801dc5:	e8 f2 f4 ff ff       	call   8012bc <fd2num>
  801dca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dcd:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801dd0:	83 c4 10             	add    $0x10,%esp
  801dd3:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd8:	eb 30                	jmp    801e0a <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801dda:	83 ec 08             	sub    $0x8,%esp
  801ddd:	56                   	push   %esi
  801dde:	6a 00                	push   $0x0
  801de0:	e8 55 ee ff ff       	call   800c3a <sys_page_unmap>
  801de5:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801de8:	83 ec 08             	sub    $0x8,%esp
  801deb:	ff 75 f0             	pushl  -0x10(%ebp)
  801dee:	6a 00                	push   $0x0
  801df0:	e8 45 ee ff ff       	call   800c3a <sys_page_unmap>
  801df5:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801df8:	83 ec 08             	sub    $0x8,%esp
  801dfb:	ff 75 f4             	pushl  -0xc(%ebp)
  801dfe:	6a 00                	push   $0x0
  801e00:	e8 35 ee ff ff       	call   800c3a <sys_page_unmap>
  801e05:	83 c4 10             	add    $0x10,%esp
  801e08:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  801e0a:	89 d0                	mov    %edx,%eax
  801e0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e0f:	5b                   	pop    %ebx
  801e10:	5e                   	pop    %esi
  801e11:	5d                   	pop    %ebp
  801e12:	c3                   	ret    

00801e13 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e19:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e1c:	50                   	push   %eax
  801e1d:	ff 75 08             	pushl  0x8(%ebp)
  801e20:	e8 0e f5 ff ff       	call   801333 <fd_lookup>
  801e25:	83 c4 10             	add    $0x10,%esp
  801e28:	85 c0                	test   %eax,%eax
  801e2a:	78 18                	js     801e44 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801e2c:	83 ec 0c             	sub    $0xc,%esp
  801e2f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e32:	e8 95 f4 ff ff       	call   8012cc <fd2data>
	return _pipeisclosed(fd, p);
  801e37:	89 c2                	mov    %eax,%edx
  801e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3c:	e8 21 fd ff ff       	call   801b62 <_pipeisclosed>
  801e41:	83 c4 10             	add    $0x10,%esp
}
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801e49:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4e:	5d                   	pop    %ebp
  801e4f:	c3                   	ret    

00801e50 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e56:	68 0e 29 80 00       	push   $0x80290e
  801e5b:	ff 75 0c             	pushl  0xc(%ebp)
  801e5e:	e8 44 e9 ff ff       	call   8007a7 <strcpy>
	return 0;
}
  801e63:	b8 00 00 00 00       	mov    $0x0,%eax
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	57                   	push   %edi
  801e6e:	56                   	push   %esi
  801e6f:	53                   	push   %ebx
  801e70:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e76:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801e7b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e81:	eb 2d                	jmp    801eb0 <devcons_write+0x46>
		m = n - tot;
  801e83:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e86:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801e88:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801e8b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801e90:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801e93:	83 ec 04             	sub    $0x4,%esp
  801e96:	53                   	push   %ebx
  801e97:	03 45 0c             	add    0xc(%ebp),%eax
  801e9a:	50                   	push   %eax
  801e9b:	57                   	push   %edi
  801e9c:	e8 99 ea ff ff       	call   80093a <memmove>
		sys_cputs(buf, m);
  801ea1:	83 c4 08             	add    $0x8,%esp
  801ea4:	53                   	push   %ebx
  801ea5:	57                   	push   %edi
  801ea6:	e8 8e ec ff ff       	call   800b39 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801eab:	01 de                	add    %ebx,%esi
  801ead:	83 c4 10             	add    $0x10,%esp
  801eb0:	89 f0                	mov    %esi,%eax
  801eb2:	3b 75 10             	cmp    0x10(%ebp),%esi
  801eb5:	72 cc                	jb     801e83 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801eb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eba:	5b                   	pop    %ebx
  801ebb:	5e                   	pop    %esi
  801ebc:	5f                   	pop    %edi
  801ebd:	5d                   	pop    %ebp
  801ebe:	c3                   	ret    

00801ebf <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
  801ec2:	83 ec 08             	sub    $0x8,%esp
  801ec5:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801eca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ece:	74 2a                	je     801efa <devcons_read+0x3b>
  801ed0:	eb 05                	jmp    801ed7 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801ed2:	e8 f2 ec ff ff       	call   800bc9 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801ed7:	e8 83 ec ff ff       	call   800b5f <sys_cgetc>
  801edc:	85 c0                	test   %eax,%eax
  801ede:	74 f2                	je     801ed2 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801ee0:	85 c0                	test   %eax,%eax
  801ee2:	78 16                	js     801efa <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801ee4:	83 f8 04             	cmp    $0x4,%eax
  801ee7:	74 0c                	je     801ef5 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801ee9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eec:	88 02                	mov    %al,(%edx)
	return 1;
  801eee:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef3:	eb 05                	jmp    801efa <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801ef5:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f02:	8b 45 08             	mov    0x8(%ebp),%eax
  801f05:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801f08:	6a 01                	push   $0x1
  801f0a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f0d:	50                   	push   %eax
  801f0e:	e8 26 ec ff ff       	call   800b39 <sys_cputs>
}
  801f13:	83 c4 10             	add    $0x10,%esp
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <getchar>:

int
getchar(void)
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
  801f1b:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801f1e:	6a 01                	push   $0x1
  801f20:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f23:	50                   	push   %eax
  801f24:	6a 00                	push   $0x0
  801f26:	e8 6d f6 ff ff       	call   801598 <read>
	if (r < 0)
  801f2b:	83 c4 10             	add    $0x10,%esp
  801f2e:	85 c0                	test   %eax,%eax
  801f30:	78 0f                	js     801f41 <getchar+0x29>
		return r;
	if (r < 1)
  801f32:	85 c0                	test   %eax,%eax
  801f34:	7e 06                	jle    801f3c <getchar+0x24>
		return -E_EOF;
	return c;
  801f36:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801f3a:	eb 05                	jmp    801f41 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801f3c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
  801f46:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f49:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f4c:	50                   	push   %eax
  801f4d:	ff 75 08             	pushl  0x8(%ebp)
  801f50:	e8 de f3 ff ff       	call   801333 <fd_lookup>
  801f55:	83 c4 10             	add    $0x10,%esp
  801f58:	85 c0                	test   %eax,%eax
  801f5a:	78 11                	js     801f6d <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f65:	39 10                	cmp    %edx,(%eax)
  801f67:	0f 94 c0             	sete   %al
  801f6a:	0f b6 c0             	movzbl %al,%eax
}
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <opencons>:

int
opencons(void)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
  801f72:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801f75:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f78:	50                   	push   %eax
  801f79:	e8 66 f3 ff ff       	call   8012e4 <fd_alloc>
  801f7e:	83 c4 10             	add    $0x10,%esp
		return r;
  801f81:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801f83:	85 c0                	test   %eax,%eax
  801f85:	78 3e                	js     801fc5 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f87:	83 ec 04             	sub    $0x4,%esp
  801f8a:	68 07 04 00 00       	push   $0x407
  801f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f92:	6a 00                	push   $0x0
  801f94:	e8 57 ec ff ff       	call   800bf0 <sys_page_alloc>
  801f99:	83 c4 10             	add    $0x10,%esp
		return r;
  801f9c:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	78 23                	js     801fc5 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801fa2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fab:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801fb7:	83 ec 0c             	sub    $0xc,%esp
  801fba:	50                   	push   %eax
  801fbb:	e8 fc f2 ff ff       	call   8012bc <fd2num>
  801fc0:	89 c2                	mov    %eax,%edx
  801fc2:	83 c4 10             	add    $0x10,%esp
}
  801fc5:	89 d0                	mov    %edx,%eax
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801fcf:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801fd6:	75 2c                	jne    802004 <set_pgfault_handler+0x3b>
		// First time through!
		// LAB 4: Your code here.
		r = sys_page_alloc(0,(void *)(UXSTACKTOP - PGSIZE),PTE_P | PTE_U | PTE_W);
  801fd8:	83 ec 04             	sub    $0x4,%esp
  801fdb:	6a 07                	push   $0x7
  801fdd:	68 00 f0 bf ee       	push   $0xeebff000
  801fe2:	6a 00                	push   $0x0
  801fe4:	e8 07 ec ff ff       	call   800bf0 <sys_page_alloc>
		if(r < 0)
  801fe9:	83 c4 10             	add    $0x10,%esp
  801fec:	85 c0                	test   %eax,%eax
  801fee:	79 14                	jns    802004 <set_pgfault_handler+0x3b>
			panic("set_pgfault_handler: error in sys_page_alloc\n");	
  801ff0:	83 ec 04             	sub    $0x4,%esp
  801ff3:	68 1c 29 80 00       	push   $0x80291c
  801ff8:	6a 22                	push   $0x22
  801ffa:	68 88 29 80 00       	push   $0x802988
  801fff:	e8 58 e1 ff ff       	call   80015c <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802004:	8b 45 08             	mov    0x8(%ebp),%eax
  802007:	a3 00 60 80 00       	mov    %eax,0x806000
	r = sys_env_set_pgfault_upcall(0, _pgfault_upcall); 
  80200c:	83 ec 08             	sub    $0x8,%esp
  80200f:	68 38 20 80 00       	push   $0x802038
  802014:	6a 00                	push   $0x0
  802016:	e8 88 ec ff ff       	call   800ca3 <sys_env_set_pgfault_upcall>
	if (r < 0)
  80201b:	83 c4 10             	add    $0x10,%esp
  80201e:	85 c0                	test   %eax,%eax
  802020:	79 14                	jns    802036 <set_pgfault_handler+0x6d>
		panic("set_pgfault_handler: error in sys_env_set_pgfault_upcall");
  802022:	83 ec 04             	sub    $0x4,%esp
  802025:	68 4c 29 80 00       	push   $0x80294c
  80202a:	6a 29                	push   $0x29
  80202c:	68 88 29 80 00       	push   $0x802988
  802031:	e8 26 e1 ff ff       	call   80015c <_panic>
}
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802038:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802039:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  80203e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802040:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	subl $0x4, 0x30(%esp)
  802043:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  802048:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 0x28(%esp), %ebx 	
  80204c:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  802050:	89 18                	mov    %ebx,(%eax)
	addl $0x8, %esp
  802052:	83 c4 08             	add    $0x8,%esp


	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  802055:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp 
  802056:	83 c4 04             	add    $0x4,%esp
	popfl
  802059:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80205a:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80205b:	c3                   	ret    

0080205c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802062:	89 d0                	mov    %edx,%eax
  802064:	c1 e8 16             	shr    $0x16,%eax
  802067:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80206e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802073:	f6 c1 01             	test   $0x1,%cl
  802076:	74 1d                	je     802095 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802078:	c1 ea 0c             	shr    $0xc,%edx
  80207b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802082:	f6 c2 01             	test   $0x1,%dl
  802085:	74 0e                	je     802095 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802087:	c1 ea 0c             	shr    $0xc,%edx
  80208a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802091:	ef 
  802092:	0f b7 c0             	movzwl %ax,%eax
}
  802095:	5d                   	pop    %ebp
  802096:	c3                   	ret    
  802097:	66 90                	xchg   %ax,%ax
  802099:	66 90                	xchg   %ax,%ax
  80209b:	66 90                	xchg   %ax,%ax
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
