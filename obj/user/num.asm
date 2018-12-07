
obj/user/num.debug:     formato del fichero elf32-i386


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
  80002c:	e8 54 01 00 00       	call   800185 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
  80003b:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  80003e:	8d 5d f7             	lea    -0x9(%ebp),%ebx
  800041:	eb 6e                	jmp    8000b1 <num+0x7e>
		if (bol) {
  800043:	83 3d 00 30 80 00 00 	cmpl   $0x0,0x803000
  80004a:	74 28                	je     800074 <num+0x41>
			printf("%5d ", ++line);
  80004c:	a1 00 40 80 00       	mov    0x804000,%eax
  800051:	83 c0 01             	add    $0x1,%eax
  800054:	a3 00 40 80 00       	mov    %eax,0x804000
  800059:	83 ec 08             	sub    $0x8,%esp
  80005c:	50                   	push   %eax
  80005d:	68 80 1f 80 00       	push   $0x801f80
  800062:	e8 5b 16 00 00       	call   8016c2 <printf>
			bol = 0;
  800067:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  80006e:	00 00 00 
  800071:	83 c4 10             	add    $0x10,%esp
		}
		if ((r = write(1, &c, 1)) != 1)
  800074:	83 ec 04             	sub    $0x4,%esp
  800077:	6a 01                	push   $0x1
  800079:	53                   	push   %ebx
  80007a:	6a 01                	push   $0x1
  80007c:	e8 cf 10 00 00       	call   801150 <write>
  800081:	83 c4 10             	add    $0x10,%esp
  800084:	83 f8 01             	cmp    $0x1,%eax
  800087:	74 18                	je     8000a1 <num+0x6e>
			panic("write error copying %s: %e", s, r);
  800089:	83 ec 0c             	sub    $0xc,%esp
  80008c:	50                   	push   %eax
  80008d:	ff 75 0c             	pushl  0xc(%ebp)
  800090:	68 85 1f 80 00       	push   $0x801f85
  800095:	6a 13                	push   $0x13
  800097:	68 a0 1f 80 00       	push   $0x801fa0
  80009c:	e8 48 01 00 00       	call   8001e9 <_panic>
		if (c == '\n')
  8000a1:	80 7d f7 0a          	cmpb   $0xa,-0x9(%ebp)
  8000a5:	75 0a                	jne    8000b1 <num+0x7e>
			bol = 1;
  8000a7:	c7 05 00 30 80 00 01 	movl   $0x1,0x803000
  8000ae:	00 00 00 
{
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  8000b1:	83 ec 04             	sub    $0x4,%esp
  8000b4:	6a 01                	push   $0x1
  8000b6:	53                   	push   %ebx
  8000b7:	56                   	push   %esi
  8000b8:	e8 b9 0f 00 00       	call   801076 <read>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	85 c0                	test   %eax,%eax
  8000c2:	0f 8f 7b ff ff ff    	jg     800043 <num+0x10>
		if ((r = write(1, &c, 1)) != 1)
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
			bol = 1;
	}
	if (n < 0)
  8000c8:	85 c0                	test   %eax,%eax
  8000ca:	79 18                	jns    8000e4 <num+0xb1>
		panic("error reading %s: %e", s, n);
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	ff 75 0c             	pushl  0xc(%ebp)
  8000d3:	68 ab 1f 80 00       	push   $0x801fab
  8000d8:	6a 18                	push   $0x18
  8000da:	68 a0 1f 80 00       	push   $0x801fa0
  8000df:	e8 05 01 00 00       	call   8001e9 <_panic>
}
  8000e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000e7:	5b                   	pop    %ebx
  8000e8:	5e                   	pop    %esi
  8000e9:	5d                   	pop    %ebp
  8000ea:	c3                   	ret    

008000eb <umain>:

void
umain(int argc, char **argv)
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	57                   	push   %edi
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	83 ec 1c             	sub    $0x1c,%esp
	int f, i;

	binaryname = "num";
  8000f4:	c7 05 04 30 80 00 c0 	movl   $0x801fc0,0x803004
  8000fb:	1f 80 00 
	if (argc == 1)
  8000fe:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800102:	74 0d                	je     800111 <umain+0x26>
  800104:	8b 45 0c             	mov    0xc(%ebp),%eax
  800107:	8d 58 04             	lea    0x4(%eax),%ebx
  80010a:	bf 01 00 00 00       	mov    $0x1,%edi
  80010f:	eb 62                	jmp    800173 <umain+0x88>
		num(0, "<stdin>");
  800111:	83 ec 08             	sub    $0x8,%esp
  800114:	68 c4 1f 80 00       	push   $0x801fc4
  800119:	6a 00                	push   $0x0
  80011b:	e8 13 ff ff ff       	call   800033 <num>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	eb 53                	jmp    800178 <umain+0x8d>
	else
		for (i = 1; i < argc; i++) {
			f = open(argv[i], O_RDONLY);
  800125:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800128:	83 ec 08             	sub    $0x8,%esp
  80012b:	6a 00                	push   $0x0
  80012d:	ff 33                	pushl  (%ebx)
  80012f:	e8 f0 13 00 00       	call   801524 <open>
  800134:	89 c6                	mov    %eax,%esi
			if (f < 0)
  800136:	83 c4 10             	add    $0x10,%esp
  800139:	85 c0                	test   %eax,%eax
  80013b:	79 1a                	jns    800157 <umain+0x6c>
				panic("can't open %s: %e", argv[i], f);
  80013d:	83 ec 0c             	sub    $0xc,%esp
  800140:	50                   	push   %eax
  800141:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800144:	ff 30                	pushl  (%eax)
  800146:	68 cc 1f 80 00       	push   $0x801fcc
  80014b:	6a 27                	push   $0x27
  80014d:	68 a0 1f 80 00       	push   $0x801fa0
  800152:	e8 92 00 00 00       	call   8001e9 <_panic>
			else {
				num(f, argv[i]);
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	ff 33                	pushl  (%ebx)
  80015c:	50                   	push   %eax
  80015d:	e8 d1 fe ff ff       	call   800033 <num>
				close(f);
  800162:	89 34 24             	mov    %esi,(%esp)
  800165:	e8 d0 0d 00 00       	call   800f3a <close>

	binaryname = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  80016a:	83 c7 01             	add    $0x1,%edi
  80016d:	83 c3 04             	add    $0x4,%ebx
  800170:	83 c4 10             	add    $0x10,%esp
  800173:	3b 7d 08             	cmp    0x8(%ebp),%edi
  800176:	7c ad                	jl     800125 <umain+0x3a>
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  800178:	e8 52 00 00 00       	call   8001cf <exit>
}
  80017d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800180:	5b                   	pop    %ebx
  800181:	5e                   	pop    %esi
  800182:	5f                   	pop    %edi
  800183:	5d                   	pop    %ebp
  800184:	c3                   	ret    

00800185 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800185:	55                   	push   %ebp
  800186:	89 e5                	mov    %esp,%ebp
  800188:	56                   	push   %esi
  800189:	53                   	push   %ebx
  80018a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80018d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800190:	e8 9d 0a 00 00       	call   800c32 <sys_getenvid>
	if (id >= 0)
  800195:	85 c0                	test   %eax,%eax
  800197:	78 12                	js     8001ab <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  800199:	25 ff 03 00 00       	and    $0x3ff,%eax
  80019e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001a1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a6:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ab:	85 db                	test   %ebx,%ebx
  8001ad:	7e 07                	jle    8001b6 <libmain+0x31>
		binaryname = argv[0];
  8001af:	8b 06                	mov    (%esi),%eax
  8001b1:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8001b6:	83 ec 08             	sub    $0x8,%esp
  8001b9:	56                   	push   %esi
  8001ba:	53                   	push   %ebx
  8001bb:	e8 2b ff ff ff       	call   8000eb <umain>

	// exit gracefully
	exit();
  8001c0:	e8 0a 00 00 00       	call   8001cf <exit>
}
  8001c5:	83 c4 10             	add    $0x10,%esp
  8001c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001cb:	5b                   	pop    %ebx
  8001cc:	5e                   	pop    %esi
  8001cd:	5d                   	pop    %ebp
  8001ce:	c3                   	ret    

008001cf <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001cf:	55                   	push   %ebp
  8001d0:	89 e5                	mov    %esp,%ebp
  8001d2:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001d5:	e8 8b 0d 00 00       	call   800f65 <close_all>
	sys_env_destroy(0);
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	6a 00                	push   $0x0
  8001df:	e8 2c 0a 00 00       	call   800c10 <sys_env_destroy>
}
  8001e4:	83 c4 10             	add    $0x10,%esp
  8001e7:	c9                   	leave  
  8001e8:	c3                   	ret    

008001e9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001e9:	55                   	push   %ebp
  8001ea:	89 e5                	mov    %esp,%ebp
  8001ec:	56                   	push   %esi
  8001ed:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001ee:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001f1:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8001f7:	e8 36 0a 00 00       	call   800c32 <sys_getenvid>
  8001fc:	83 ec 0c             	sub    $0xc,%esp
  8001ff:	ff 75 0c             	pushl  0xc(%ebp)
  800202:	ff 75 08             	pushl  0x8(%ebp)
  800205:	56                   	push   %esi
  800206:	50                   	push   %eax
  800207:	68 e8 1f 80 00       	push   $0x801fe8
  80020c:	e8 b1 00 00 00       	call   8002c2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800211:	83 c4 18             	add    $0x18,%esp
  800214:	53                   	push   %ebx
  800215:	ff 75 10             	pushl  0x10(%ebp)
  800218:	e8 54 00 00 00       	call   800271 <vcprintf>
	cprintf("\n");
  80021d:	c7 04 24 07 24 80 00 	movl   $0x802407,(%esp)
  800224:	e8 99 00 00 00       	call   8002c2 <cprintf>
  800229:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80022c:	cc                   	int3   
  80022d:	eb fd                	jmp    80022c <_panic+0x43>

0080022f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80022f:	55                   	push   %ebp
  800230:	89 e5                	mov    %esp,%ebp
  800232:	53                   	push   %ebx
  800233:	83 ec 04             	sub    $0x4,%esp
  800236:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800239:	8b 13                	mov    (%ebx),%edx
  80023b:	8d 42 01             	lea    0x1(%edx),%eax
  80023e:	89 03                	mov    %eax,(%ebx)
  800240:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800243:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800247:	3d ff 00 00 00       	cmp    $0xff,%eax
  80024c:	75 1a                	jne    800268 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  80024e:	83 ec 08             	sub    $0x8,%esp
  800251:	68 ff 00 00 00       	push   $0xff
  800256:	8d 43 08             	lea    0x8(%ebx),%eax
  800259:	50                   	push   %eax
  80025a:	e8 67 09 00 00       	call   800bc6 <sys_cputs>
		b->idx = 0;
  80025f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800265:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  800268:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80026c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80027a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800281:	00 00 00 
	b.cnt = 0;
  800284:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80028b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80028e:	ff 75 0c             	pushl  0xc(%ebp)
  800291:	ff 75 08             	pushl  0x8(%ebp)
  800294:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80029a:	50                   	push   %eax
  80029b:	68 2f 02 80 00       	push   $0x80022f
  8002a0:	e8 86 01 00 00       	call   80042b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002a5:	83 c4 08             	add    $0x8,%esp
  8002a8:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002ae:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002b4:	50                   	push   %eax
  8002b5:	e8 0c 09 00 00       	call   800bc6 <sys_cputs>

	return b.cnt;
}
  8002ba:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002c8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002cb:	50                   	push   %eax
  8002cc:	ff 75 08             	pushl  0x8(%ebp)
  8002cf:	e8 9d ff ff ff       	call   800271 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002d4:	c9                   	leave  
  8002d5:	c3                   	ret    

008002d6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	57                   	push   %edi
  8002da:	56                   	push   %esi
  8002db:	53                   	push   %ebx
  8002dc:	83 ec 1c             	sub    $0x1c,%esp
  8002df:	89 c7                	mov    %eax,%edi
  8002e1:	89 d6                	mov    %edx,%esi
  8002e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002ec:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002f7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002fa:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002fd:	39 d3                	cmp    %edx,%ebx
  8002ff:	72 05                	jb     800306 <printnum+0x30>
  800301:	39 45 10             	cmp    %eax,0x10(%ebp)
  800304:	77 45                	ja     80034b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800306:	83 ec 0c             	sub    $0xc,%esp
  800309:	ff 75 18             	pushl  0x18(%ebp)
  80030c:	8b 45 14             	mov    0x14(%ebp),%eax
  80030f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800312:	53                   	push   %ebx
  800313:	ff 75 10             	pushl  0x10(%ebp)
  800316:	83 ec 08             	sub    $0x8,%esp
  800319:	ff 75 e4             	pushl  -0x1c(%ebp)
  80031c:	ff 75 e0             	pushl  -0x20(%ebp)
  80031f:	ff 75 dc             	pushl  -0x24(%ebp)
  800322:	ff 75 d8             	pushl  -0x28(%ebp)
  800325:	e8 c6 19 00 00       	call   801cf0 <__udivdi3>
  80032a:	83 c4 18             	add    $0x18,%esp
  80032d:	52                   	push   %edx
  80032e:	50                   	push   %eax
  80032f:	89 f2                	mov    %esi,%edx
  800331:	89 f8                	mov    %edi,%eax
  800333:	e8 9e ff ff ff       	call   8002d6 <printnum>
  800338:	83 c4 20             	add    $0x20,%esp
  80033b:	eb 18                	jmp    800355 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	56                   	push   %esi
  800341:	ff 75 18             	pushl  0x18(%ebp)
  800344:	ff d7                	call   *%edi
  800346:	83 c4 10             	add    $0x10,%esp
  800349:	eb 03                	jmp    80034e <printnum+0x78>
  80034b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80034e:	83 eb 01             	sub    $0x1,%ebx
  800351:	85 db                	test   %ebx,%ebx
  800353:	7f e8                	jg     80033d <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800355:	83 ec 08             	sub    $0x8,%esp
  800358:	56                   	push   %esi
  800359:	83 ec 04             	sub    $0x4,%esp
  80035c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80035f:	ff 75 e0             	pushl  -0x20(%ebp)
  800362:	ff 75 dc             	pushl  -0x24(%ebp)
  800365:	ff 75 d8             	pushl  -0x28(%ebp)
  800368:	e8 b3 1a 00 00       	call   801e20 <__umoddi3>
  80036d:	83 c4 14             	add    $0x14,%esp
  800370:	0f be 80 0b 20 80 00 	movsbl 0x80200b(%eax),%eax
  800377:	50                   	push   %eax
  800378:	ff d7                	call   *%edi
}
  80037a:	83 c4 10             	add    $0x10,%esp
  80037d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800380:	5b                   	pop    %ebx
  800381:	5e                   	pop    %esi
  800382:	5f                   	pop    %edi
  800383:	5d                   	pop    %ebp
  800384:	c3                   	ret    

00800385 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800385:	55                   	push   %ebp
  800386:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800388:	83 fa 01             	cmp    $0x1,%edx
  80038b:	7e 0e                	jle    80039b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80038d:	8b 10                	mov    (%eax),%edx
  80038f:	8d 4a 08             	lea    0x8(%edx),%ecx
  800392:	89 08                	mov    %ecx,(%eax)
  800394:	8b 02                	mov    (%edx),%eax
  800396:	8b 52 04             	mov    0x4(%edx),%edx
  800399:	eb 22                	jmp    8003bd <getuint+0x38>
	else if (lflag)
  80039b:	85 d2                	test   %edx,%edx
  80039d:	74 10                	je     8003af <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80039f:	8b 10                	mov    (%eax),%edx
  8003a1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003a4:	89 08                	mov    %ecx,(%eax)
  8003a6:	8b 02                	mov    (%edx),%eax
  8003a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ad:	eb 0e                	jmp    8003bd <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003af:	8b 10                	mov    (%eax),%edx
  8003b1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003b4:	89 08                	mov    %ecx,(%eax)
  8003b6:	8b 02                	mov    (%edx),%eax
  8003b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003bd:	5d                   	pop    %ebp
  8003be:	c3                   	ret    

008003bf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003c2:	83 fa 01             	cmp    $0x1,%edx
  8003c5:	7e 0e                	jle    8003d5 <getint+0x16>
		return va_arg(*ap, long long);
  8003c7:	8b 10                	mov    (%eax),%edx
  8003c9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003cc:	89 08                	mov    %ecx,(%eax)
  8003ce:	8b 02                	mov    (%edx),%eax
  8003d0:	8b 52 04             	mov    0x4(%edx),%edx
  8003d3:	eb 1a                	jmp    8003ef <getint+0x30>
	else if (lflag)
  8003d5:	85 d2                	test   %edx,%edx
  8003d7:	74 0c                	je     8003e5 <getint+0x26>
		return va_arg(*ap, long);
  8003d9:	8b 10                	mov    (%eax),%edx
  8003db:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003de:	89 08                	mov    %ecx,(%eax)
  8003e0:	8b 02                	mov    (%edx),%eax
  8003e2:	99                   	cltd   
  8003e3:	eb 0a                	jmp    8003ef <getint+0x30>
	else
		return va_arg(*ap, int);
  8003e5:	8b 10                	mov    (%eax),%edx
  8003e7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003ea:	89 08                	mov    %ecx,(%eax)
  8003ec:	8b 02                	mov    (%edx),%eax
  8003ee:	99                   	cltd   
}
  8003ef:	5d                   	pop    %ebp
  8003f0:	c3                   	ret    

008003f1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003f1:	55                   	push   %ebp
  8003f2:	89 e5                	mov    %esp,%ebp
  8003f4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003f7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003fb:	8b 10                	mov    (%eax),%edx
  8003fd:	3b 50 04             	cmp    0x4(%eax),%edx
  800400:	73 0a                	jae    80040c <sprintputch+0x1b>
		*b->buf++ = ch;
  800402:	8d 4a 01             	lea    0x1(%edx),%ecx
  800405:	89 08                	mov    %ecx,(%eax)
  800407:	8b 45 08             	mov    0x8(%ebp),%eax
  80040a:	88 02                	mov    %al,(%edx)
}
  80040c:	5d                   	pop    %ebp
  80040d:	c3                   	ret    

0080040e <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800414:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800417:	50                   	push   %eax
  800418:	ff 75 10             	pushl  0x10(%ebp)
  80041b:	ff 75 0c             	pushl  0xc(%ebp)
  80041e:	ff 75 08             	pushl  0x8(%ebp)
  800421:	e8 05 00 00 00       	call   80042b <vprintfmt>
	va_end(ap);
}
  800426:	83 c4 10             	add    $0x10,%esp
  800429:	c9                   	leave  
  80042a:	c3                   	ret    

0080042b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80042b:	55                   	push   %ebp
  80042c:	89 e5                	mov    %esp,%ebp
  80042e:	57                   	push   %edi
  80042f:	56                   	push   %esi
  800430:	53                   	push   %ebx
  800431:	83 ec 2c             	sub    $0x2c,%esp
  800434:	8b 75 08             	mov    0x8(%ebp),%esi
  800437:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80043a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80043d:	eb 12                	jmp    800451 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80043f:	85 c0                	test   %eax,%eax
  800441:	0f 84 44 03 00 00    	je     80078b <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	53                   	push   %ebx
  80044b:	50                   	push   %eax
  80044c:	ff d6                	call   *%esi
  80044e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800451:	83 c7 01             	add    $0x1,%edi
  800454:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800458:	83 f8 25             	cmp    $0x25,%eax
  80045b:	75 e2                	jne    80043f <vprintfmt+0x14>
  80045d:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800461:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800468:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80046f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800476:	ba 00 00 00 00       	mov    $0x0,%edx
  80047b:	eb 07                	jmp    800484 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80047d:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800480:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800484:	8d 47 01             	lea    0x1(%edi),%eax
  800487:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80048a:	0f b6 07             	movzbl (%edi),%eax
  80048d:	0f b6 c8             	movzbl %al,%ecx
  800490:	83 e8 23             	sub    $0x23,%eax
  800493:	3c 55                	cmp    $0x55,%al
  800495:	0f 87 d5 02 00 00    	ja     800770 <vprintfmt+0x345>
  80049b:	0f b6 c0             	movzbl %al,%eax
  80049e:	ff 24 85 40 21 80 00 	jmp    *0x802140(,%eax,4)
  8004a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004a8:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8004ac:	eb d6                	jmp    800484 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004b9:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004bc:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8004c0:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8004c3:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8004c6:	83 fa 09             	cmp    $0x9,%edx
  8004c9:	77 39                	ja     800504 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004cb:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004ce:	eb e9                	jmp    8004b9 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d3:	8d 48 04             	lea    0x4(%eax),%ecx
  8004d6:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8004d9:	8b 00                	mov    (%eax),%eax
  8004db:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004e1:	eb 27                	jmp    80050a <vprintfmt+0xdf>
  8004e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e6:	85 c0                	test   %eax,%eax
  8004e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004ed:	0f 49 c8             	cmovns %eax,%ecx
  8004f0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004f6:	eb 8c                	jmp    800484 <vprintfmt+0x59>
  8004f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004fb:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800502:	eb 80                	jmp    800484 <vprintfmt+0x59>
  800504:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800507:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  80050a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80050e:	0f 89 70 ff ff ff    	jns    800484 <vprintfmt+0x59>
				width = precision, precision = -1;
  800514:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800517:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80051a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800521:	e9 5e ff ff ff       	jmp    800484 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800526:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800529:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80052c:	e9 53 ff ff ff       	jmp    800484 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800531:	8b 45 14             	mov    0x14(%ebp),%eax
  800534:	8d 50 04             	lea    0x4(%eax),%edx
  800537:	89 55 14             	mov    %edx,0x14(%ebp)
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	53                   	push   %ebx
  80053e:	ff 30                	pushl  (%eax)
  800540:	ff d6                	call   *%esi
			break;
  800542:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800545:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800548:	e9 04 ff ff ff       	jmp    800451 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80054d:	8b 45 14             	mov    0x14(%ebp),%eax
  800550:	8d 50 04             	lea    0x4(%eax),%edx
  800553:	89 55 14             	mov    %edx,0x14(%ebp)
  800556:	8b 00                	mov    (%eax),%eax
  800558:	99                   	cltd   
  800559:	31 d0                	xor    %edx,%eax
  80055b:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80055d:	83 f8 0f             	cmp    $0xf,%eax
  800560:	7f 0b                	jg     80056d <vprintfmt+0x142>
  800562:	8b 14 85 a0 22 80 00 	mov    0x8022a0(,%eax,4),%edx
  800569:	85 d2                	test   %edx,%edx
  80056b:	75 18                	jne    800585 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  80056d:	50                   	push   %eax
  80056e:	68 23 20 80 00       	push   $0x802023
  800573:	53                   	push   %ebx
  800574:	56                   	push   %esi
  800575:	e8 94 fe ff ff       	call   80040e <printfmt>
  80057a:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800580:	e9 cc fe ff ff       	jmp    800451 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  800585:	52                   	push   %edx
  800586:	68 d5 23 80 00       	push   $0x8023d5
  80058b:	53                   	push   %ebx
  80058c:	56                   	push   %esi
  80058d:	e8 7c fe ff ff       	call   80040e <printfmt>
  800592:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800595:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800598:	e9 b4 fe ff ff       	jmp    800451 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	8d 50 04             	lea    0x4(%eax),%edx
  8005a3:	89 55 14             	mov    %edx,0x14(%ebp)
  8005a6:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8005a8:	85 ff                	test   %edi,%edi
  8005aa:	b8 1c 20 80 00       	mov    $0x80201c,%eax
  8005af:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8005b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005b6:	0f 8e 94 00 00 00    	jle    800650 <vprintfmt+0x225>
  8005bc:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8005c0:	0f 84 98 00 00 00    	je     80065e <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	ff 75 d0             	pushl  -0x30(%ebp)
  8005cc:	57                   	push   %edi
  8005cd:	e8 41 02 00 00       	call   800813 <strnlen>
  8005d2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005d5:	29 c1                	sub    %eax,%ecx
  8005d7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8005da:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005dd:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005e4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005e7:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e9:	eb 0f                	jmp    8005fa <vprintfmt+0x1cf>
					putch(padc, putdat);
  8005eb:	83 ec 08             	sub    $0x8,%esp
  8005ee:	53                   	push   %ebx
  8005ef:	ff 75 e0             	pushl  -0x20(%ebp)
  8005f2:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f4:	83 ef 01             	sub    $0x1,%edi
  8005f7:	83 c4 10             	add    $0x10,%esp
  8005fa:	85 ff                	test   %edi,%edi
  8005fc:	7f ed                	jg     8005eb <vprintfmt+0x1c0>
  8005fe:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800601:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800604:	85 c9                	test   %ecx,%ecx
  800606:	b8 00 00 00 00       	mov    $0x0,%eax
  80060b:	0f 49 c1             	cmovns %ecx,%eax
  80060e:	29 c1                	sub    %eax,%ecx
  800610:	89 75 08             	mov    %esi,0x8(%ebp)
  800613:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800616:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800619:	89 cb                	mov    %ecx,%ebx
  80061b:	eb 4d                	jmp    80066a <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80061d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800621:	74 1b                	je     80063e <vprintfmt+0x213>
  800623:	0f be c0             	movsbl %al,%eax
  800626:	83 e8 20             	sub    $0x20,%eax
  800629:	83 f8 5e             	cmp    $0x5e,%eax
  80062c:	76 10                	jbe    80063e <vprintfmt+0x213>
					putch('?', putdat);
  80062e:	83 ec 08             	sub    $0x8,%esp
  800631:	ff 75 0c             	pushl  0xc(%ebp)
  800634:	6a 3f                	push   $0x3f
  800636:	ff 55 08             	call   *0x8(%ebp)
  800639:	83 c4 10             	add    $0x10,%esp
  80063c:	eb 0d                	jmp    80064b <vprintfmt+0x220>
				else
					putch(ch, putdat);
  80063e:	83 ec 08             	sub    $0x8,%esp
  800641:	ff 75 0c             	pushl  0xc(%ebp)
  800644:	52                   	push   %edx
  800645:	ff 55 08             	call   *0x8(%ebp)
  800648:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80064b:	83 eb 01             	sub    $0x1,%ebx
  80064e:	eb 1a                	jmp    80066a <vprintfmt+0x23f>
  800650:	89 75 08             	mov    %esi,0x8(%ebp)
  800653:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800656:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800659:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80065c:	eb 0c                	jmp    80066a <vprintfmt+0x23f>
  80065e:	89 75 08             	mov    %esi,0x8(%ebp)
  800661:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800664:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800667:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80066a:	83 c7 01             	add    $0x1,%edi
  80066d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800671:	0f be d0             	movsbl %al,%edx
  800674:	85 d2                	test   %edx,%edx
  800676:	74 23                	je     80069b <vprintfmt+0x270>
  800678:	85 f6                	test   %esi,%esi
  80067a:	78 a1                	js     80061d <vprintfmt+0x1f2>
  80067c:	83 ee 01             	sub    $0x1,%esi
  80067f:	79 9c                	jns    80061d <vprintfmt+0x1f2>
  800681:	89 df                	mov    %ebx,%edi
  800683:	8b 75 08             	mov    0x8(%ebp),%esi
  800686:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800689:	eb 18                	jmp    8006a3 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80068b:	83 ec 08             	sub    $0x8,%esp
  80068e:	53                   	push   %ebx
  80068f:	6a 20                	push   $0x20
  800691:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800693:	83 ef 01             	sub    $0x1,%edi
  800696:	83 c4 10             	add    $0x10,%esp
  800699:	eb 08                	jmp    8006a3 <vprintfmt+0x278>
  80069b:	89 df                	mov    %ebx,%edi
  80069d:	8b 75 08             	mov    0x8(%ebp),%esi
  8006a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006a3:	85 ff                	test   %edi,%edi
  8006a5:	7f e4                	jg     80068b <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006aa:	e9 a2 fd ff ff       	jmp    800451 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006af:	8d 45 14             	lea    0x14(%ebp),%eax
  8006b2:	e8 08 fd ff ff       	call   8003bf <getint>
  8006b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006bd:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006c2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006c6:	79 74                	jns    80073c <vprintfmt+0x311>
				putch('-', putdat);
  8006c8:	83 ec 08             	sub    $0x8,%esp
  8006cb:	53                   	push   %ebx
  8006cc:	6a 2d                	push   $0x2d
  8006ce:	ff d6                	call   *%esi
				num = -(long long) num;
  8006d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006d3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006d6:	f7 d8                	neg    %eax
  8006d8:	83 d2 00             	adc    $0x0,%edx
  8006db:	f7 da                	neg    %edx
  8006dd:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8006e0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006e5:	eb 55                	jmp    80073c <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006e7:	8d 45 14             	lea    0x14(%ebp),%eax
  8006ea:	e8 96 fc ff ff       	call   800385 <getuint>
			base = 10;
  8006ef:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006f4:	eb 46                	jmp    80073c <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8006f6:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f9:	e8 87 fc ff ff       	call   800385 <getuint>
			base = 8;
  8006fe:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800703:	eb 37                	jmp    80073c <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	53                   	push   %ebx
  800709:	6a 30                	push   $0x30
  80070b:	ff d6                	call   *%esi
			putch('x', putdat);
  80070d:	83 c4 08             	add    $0x8,%esp
  800710:	53                   	push   %ebx
  800711:	6a 78                	push   $0x78
  800713:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8d 50 04             	lea    0x4(%eax),%edx
  80071b:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800725:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800728:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80072d:	eb 0d                	jmp    80073c <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80072f:	8d 45 14             	lea    0x14(%ebp),%eax
  800732:	e8 4e fc ff ff       	call   800385 <getuint>
			base = 16;
  800737:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  80073c:	83 ec 0c             	sub    $0xc,%esp
  80073f:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800743:	57                   	push   %edi
  800744:	ff 75 e0             	pushl  -0x20(%ebp)
  800747:	51                   	push   %ecx
  800748:	52                   	push   %edx
  800749:	50                   	push   %eax
  80074a:	89 da                	mov    %ebx,%edx
  80074c:	89 f0                	mov    %esi,%eax
  80074e:	e8 83 fb ff ff       	call   8002d6 <printnum>
			break;
  800753:	83 c4 20             	add    $0x20,%esp
  800756:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800759:	e9 f3 fc ff ff       	jmp    800451 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	53                   	push   %ebx
  800762:	51                   	push   %ecx
  800763:	ff d6                	call   *%esi
			break;
  800765:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800768:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  80076b:	e9 e1 fc ff ff       	jmp    800451 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800770:	83 ec 08             	sub    $0x8,%esp
  800773:	53                   	push   %ebx
  800774:	6a 25                	push   $0x25
  800776:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800778:	83 c4 10             	add    $0x10,%esp
  80077b:	eb 03                	jmp    800780 <vprintfmt+0x355>
  80077d:	83 ef 01             	sub    $0x1,%edi
  800780:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  800784:	75 f7                	jne    80077d <vprintfmt+0x352>
  800786:	e9 c6 fc ff ff       	jmp    800451 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  80078b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80078e:	5b                   	pop    %ebx
  80078f:	5e                   	pop    %esi
  800790:	5f                   	pop    %edi
  800791:	5d                   	pop    %ebp
  800792:	c3                   	ret    

00800793 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
  800796:	83 ec 18             	sub    $0x18,%esp
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80079f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007a2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007a6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007b0:	85 c0                	test   %eax,%eax
  8007b2:	74 26                	je     8007da <vsnprintf+0x47>
  8007b4:	85 d2                	test   %edx,%edx
  8007b6:	7e 22                	jle    8007da <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007b8:	ff 75 14             	pushl  0x14(%ebp)
  8007bb:	ff 75 10             	pushl  0x10(%ebp)
  8007be:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007c1:	50                   	push   %eax
  8007c2:	68 f1 03 80 00       	push   $0x8003f1
  8007c7:	e8 5f fc ff ff       	call   80042b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007cf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007d5:	83 c4 10             	add    $0x10,%esp
  8007d8:	eb 05                	jmp    8007df <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007df:	c9                   	leave  
  8007e0:	c3                   	ret    

008007e1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007e1:	55                   	push   %ebp
  8007e2:	89 e5                	mov    %esp,%ebp
  8007e4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007e7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007ea:	50                   	push   %eax
  8007eb:	ff 75 10             	pushl  0x10(%ebp)
  8007ee:	ff 75 0c             	pushl  0xc(%ebp)
  8007f1:	ff 75 08             	pushl  0x8(%ebp)
  8007f4:	e8 9a ff ff ff       	call   800793 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007f9:	c9                   	leave  
  8007fa:	c3                   	ret    

008007fb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007fb:	55                   	push   %ebp
  8007fc:	89 e5                	mov    %esp,%ebp
  8007fe:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800801:	b8 00 00 00 00       	mov    $0x0,%eax
  800806:	eb 03                	jmp    80080b <strlen+0x10>
		n++;
  800808:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80080b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80080f:	75 f7                	jne    800808 <strlen+0xd>
		n++;
	return n;
}
  800811:	5d                   	pop    %ebp
  800812:	c3                   	ret    

00800813 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800813:	55                   	push   %ebp
  800814:	89 e5                	mov    %esp,%ebp
  800816:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800819:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80081c:	ba 00 00 00 00       	mov    $0x0,%edx
  800821:	eb 03                	jmp    800826 <strnlen+0x13>
		n++;
  800823:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800826:	39 c2                	cmp    %eax,%edx
  800828:	74 08                	je     800832 <strnlen+0x1f>
  80082a:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80082e:	75 f3                	jne    800823 <strnlen+0x10>
  800830:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  800832:	5d                   	pop    %ebp
  800833:	c3                   	ret    

00800834 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
  800837:	53                   	push   %ebx
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80083e:	89 c2                	mov    %eax,%edx
  800840:	83 c2 01             	add    $0x1,%edx
  800843:	83 c1 01             	add    $0x1,%ecx
  800846:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80084a:	88 5a ff             	mov    %bl,-0x1(%edx)
  80084d:	84 db                	test   %bl,%bl
  80084f:	75 ef                	jne    800840 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800851:	5b                   	pop    %ebx
  800852:	5d                   	pop    %ebp
  800853:	c3                   	ret    

00800854 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800854:	55                   	push   %ebp
  800855:	89 e5                	mov    %esp,%ebp
  800857:	53                   	push   %ebx
  800858:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80085b:	53                   	push   %ebx
  80085c:	e8 9a ff ff ff       	call   8007fb <strlen>
  800861:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800864:	ff 75 0c             	pushl  0xc(%ebp)
  800867:	01 d8                	add    %ebx,%eax
  800869:	50                   	push   %eax
  80086a:	e8 c5 ff ff ff       	call   800834 <strcpy>
	return dst;
}
  80086f:	89 d8                	mov    %ebx,%eax
  800871:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800874:	c9                   	leave  
  800875:	c3                   	ret    

00800876 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800876:	55                   	push   %ebp
  800877:	89 e5                	mov    %esp,%ebp
  800879:	56                   	push   %esi
  80087a:	53                   	push   %ebx
  80087b:	8b 75 08             	mov    0x8(%ebp),%esi
  80087e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800881:	89 f3                	mov    %esi,%ebx
  800883:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800886:	89 f2                	mov    %esi,%edx
  800888:	eb 0f                	jmp    800899 <strncpy+0x23>
		*dst++ = *src;
  80088a:	83 c2 01             	add    $0x1,%edx
  80088d:	0f b6 01             	movzbl (%ecx),%eax
  800890:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800893:	80 39 01             	cmpb   $0x1,(%ecx)
  800896:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800899:	39 da                	cmp    %ebx,%edx
  80089b:	75 ed                	jne    80088a <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80089d:	89 f0                	mov    %esi,%eax
  80089f:	5b                   	pop    %ebx
  8008a0:	5e                   	pop    %esi
  8008a1:	5d                   	pop    %ebp
  8008a2:	c3                   	ret    

008008a3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	56                   	push   %esi
  8008a7:	53                   	push   %ebx
  8008a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ae:	8b 55 10             	mov    0x10(%ebp),%edx
  8008b1:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008b3:	85 d2                	test   %edx,%edx
  8008b5:	74 21                	je     8008d8 <strlcpy+0x35>
  8008b7:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008bb:	89 f2                	mov    %esi,%edx
  8008bd:	eb 09                	jmp    8008c8 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008bf:	83 c2 01             	add    $0x1,%edx
  8008c2:	83 c1 01             	add    $0x1,%ecx
  8008c5:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008c8:	39 c2                	cmp    %eax,%edx
  8008ca:	74 09                	je     8008d5 <strlcpy+0x32>
  8008cc:	0f b6 19             	movzbl (%ecx),%ebx
  8008cf:	84 db                	test   %bl,%bl
  8008d1:	75 ec                	jne    8008bf <strlcpy+0x1c>
  8008d3:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  8008d5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008d8:	29 f0                	sub    %esi,%eax
}
  8008da:	5b                   	pop    %ebx
  8008db:	5e                   	pop    %esi
  8008dc:	5d                   	pop    %ebp
  8008dd:	c3                   	ret    

008008de <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008de:	55                   	push   %ebp
  8008df:	89 e5                	mov    %esp,%ebp
  8008e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e4:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008e7:	eb 06                	jmp    8008ef <strcmp+0x11>
		p++, q++;
  8008e9:	83 c1 01             	add    $0x1,%ecx
  8008ec:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008ef:	0f b6 01             	movzbl (%ecx),%eax
  8008f2:	84 c0                	test   %al,%al
  8008f4:	74 04                	je     8008fa <strcmp+0x1c>
  8008f6:	3a 02                	cmp    (%edx),%al
  8008f8:	74 ef                	je     8008e9 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008fa:	0f b6 c0             	movzbl %al,%eax
  8008fd:	0f b6 12             	movzbl (%edx),%edx
  800900:	29 d0                	sub    %edx,%eax
}
  800902:	5d                   	pop    %ebp
  800903:	c3                   	ret    

00800904 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	53                   	push   %ebx
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090e:	89 c3                	mov    %eax,%ebx
  800910:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800913:	eb 06                	jmp    80091b <strncmp+0x17>
		n--, p++, q++;
  800915:	83 c0 01             	add    $0x1,%eax
  800918:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80091b:	39 d8                	cmp    %ebx,%eax
  80091d:	74 15                	je     800934 <strncmp+0x30>
  80091f:	0f b6 08             	movzbl (%eax),%ecx
  800922:	84 c9                	test   %cl,%cl
  800924:	74 04                	je     80092a <strncmp+0x26>
  800926:	3a 0a                	cmp    (%edx),%cl
  800928:	74 eb                	je     800915 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80092a:	0f b6 00             	movzbl (%eax),%eax
  80092d:	0f b6 12             	movzbl (%edx),%edx
  800930:	29 d0                	sub    %edx,%eax
  800932:	eb 05                	jmp    800939 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800934:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800939:	5b                   	pop    %ebx
  80093a:	5d                   	pop    %ebp
  80093b:	c3                   	ret    

0080093c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800946:	eb 07                	jmp    80094f <strchr+0x13>
		if (*s == c)
  800948:	38 ca                	cmp    %cl,%dl
  80094a:	74 0f                	je     80095b <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80094c:	83 c0 01             	add    $0x1,%eax
  80094f:	0f b6 10             	movzbl (%eax),%edx
  800952:	84 d2                	test   %dl,%dl
  800954:	75 f2                	jne    800948 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800956:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80095b:	5d                   	pop    %ebp
  80095c:	c3                   	ret    

0080095d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80095d:	55                   	push   %ebp
  80095e:	89 e5                	mov    %esp,%ebp
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800967:	eb 03                	jmp    80096c <strfind+0xf>
  800969:	83 c0 01             	add    $0x1,%eax
  80096c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80096f:	38 ca                	cmp    %cl,%dl
  800971:	74 04                	je     800977 <strfind+0x1a>
  800973:	84 d2                	test   %dl,%dl
  800975:	75 f2                	jne    800969 <strfind+0xc>
			break;
	return (char *) s;
}
  800977:	5d                   	pop    %ebp
  800978:	c3                   	ret    

00800979 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	57                   	push   %edi
  80097d:	56                   	push   %esi
  80097e:	53                   	push   %ebx
  80097f:	8b 55 08             	mov    0x8(%ebp),%edx
  800982:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800985:	85 c9                	test   %ecx,%ecx
  800987:	74 37                	je     8009c0 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800989:	f6 c2 03             	test   $0x3,%dl
  80098c:	75 2a                	jne    8009b8 <memset+0x3f>
  80098e:	f6 c1 03             	test   $0x3,%cl
  800991:	75 25                	jne    8009b8 <memset+0x3f>
		c &= 0xFF;
  800993:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800997:	89 df                	mov    %ebx,%edi
  800999:	c1 e7 08             	shl    $0x8,%edi
  80099c:	89 de                	mov    %ebx,%esi
  80099e:	c1 e6 18             	shl    $0x18,%esi
  8009a1:	89 d8                	mov    %ebx,%eax
  8009a3:	c1 e0 10             	shl    $0x10,%eax
  8009a6:	09 f0                	or     %esi,%eax
  8009a8:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8009aa:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8009ad:	89 f8                	mov    %edi,%eax
  8009af:	09 d8                	or     %ebx,%eax
  8009b1:	89 d7                	mov    %edx,%edi
  8009b3:	fc                   	cld    
  8009b4:	f3 ab                	rep stos %eax,%es:(%edi)
  8009b6:	eb 08                	jmp    8009c0 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009b8:	89 d7                	mov    %edx,%edi
  8009ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009bd:	fc                   	cld    
  8009be:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8009c0:	89 d0                	mov    %edx,%eax
  8009c2:	5b                   	pop    %ebx
  8009c3:	5e                   	pop    %esi
  8009c4:	5f                   	pop    %edi
  8009c5:	5d                   	pop    %ebp
  8009c6:	c3                   	ret    

008009c7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	57                   	push   %edi
  8009cb:	56                   	push   %esi
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009d2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009d5:	39 c6                	cmp    %eax,%esi
  8009d7:	73 35                	jae    800a0e <memmove+0x47>
  8009d9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009dc:	39 d0                	cmp    %edx,%eax
  8009de:	73 2e                	jae    800a0e <memmove+0x47>
		s += n;
		d += n;
  8009e0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e3:	89 d6                	mov    %edx,%esi
  8009e5:	09 fe                	or     %edi,%esi
  8009e7:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009ed:	75 13                	jne    800a02 <memmove+0x3b>
  8009ef:	f6 c1 03             	test   $0x3,%cl
  8009f2:	75 0e                	jne    800a02 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  8009f4:	83 ef 04             	sub    $0x4,%edi
  8009f7:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009fa:	c1 e9 02             	shr    $0x2,%ecx
  8009fd:	fd                   	std    
  8009fe:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a00:	eb 09                	jmp    800a0b <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a02:	83 ef 01             	sub    $0x1,%edi
  800a05:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a08:	fd                   	std    
  800a09:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a0b:	fc                   	cld    
  800a0c:	eb 1d                	jmp    800a2b <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a0e:	89 f2                	mov    %esi,%edx
  800a10:	09 c2                	or     %eax,%edx
  800a12:	f6 c2 03             	test   $0x3,%dl
  800a15:	75 0f                	jne    800a26 <memmove+0x5f>
  800a17:	f6 c1 03             	test   $0x3,%cl
  800a1a:	75 0a                	jne    800a26 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  800a1c:	c1 e9 02             	shr    $0x2,%ecx
  800a1f:	89 c7                	mov    %eax,%edi
  800a21:	fc                   	cld    
  800a22:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a24:	eb 05                	jmp    800a2b <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a26:	89 c7                	mov    %eax,%edi
  800a28:	fc                   	cld    
  800a29:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a2b:	5e                   	pop    %esi
  800a2c:	5f                   	pop    %edi
  800a2d:	5d                   	pop    %ebp
  800a2e:	c3                   	ret    

00800a2f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a32:	ff 75 10             	pushl  0x10(%ebp)
  800a35:	ff 75 0c             	pushl  0xc(%ebp)
  800a38:	ff 75 08             	pushl  0x8(%ebp)
  800a3b:	e8 87 ff ff ff       	call   8009c7 <memmove>
}
  800a40:	c9                   	leave  
  800a41:	c3                   	ret    

00800a42 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a42:	55                   	push   %ebp
  800a43:	89 e5                	mov    %esp,%ebp
  800a45:	56                   	push   %esi
  800a46:	53                   	push   %ebx
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4d:	89 c6                	mov    %eax,%esi
  800a4f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a52:	eb 1a                	jmp    800a6e <memcmp+0x2c>
		if (*s1 != *s2)
  800a54:	0f b6 08             	movzbl (%eax),%ecx
  800a57:	0f b6 1a             	movzbl (%edx),%ebx
  800a5a:	38 d9                	cmp    %bl,%cl
  800a5c:	74 0a                	je     800a68 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a5e:	0f b6 c1             	movzbl %cl,%eax
  800a61:	0f b6 db             	movzbl %bl,%ebx
  800a64:	29 d8                	sub    %ebx,%eax
  800a66:	eb 0f                	jmp    800a77 <memcmp+0x35>
		s1++, s2++;
  800a68:	83 c0 01             	add    $0x1,%eax
  800a6b:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a6e:	39 f0                	cmp    %esi,%eax
  800a70:	75 e2                	jne    800a54 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a77:	5b                   	pop    %ebx
  800a78:	5e                   	pop    %esi
  800a79:	5d                   	pop    %ebp
  800a7a:	c3                   	ret    

00800a7b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	53                   	push   %ebx
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800a82:	89 c1                	mov    %eax,%ecx
  800a84:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  800a87:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a8b:	eb 0a                	jmp    800a97 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a8d:	0f b6 10             	movzbl (%eax),%edx
  800a90:	39 da                	cmp    %ebx,%edx
  800a92:	74 07                	je     800a9b <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a94:	83 c0 01             	add    $0x1,%eax
  800a97:	39 c8                	cmp    %ecx,%eax
  800a99:	72 f2                	jb     800a8d <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a9b:	5b                   	pop    %ebx
  800a9c:	5d                   	pop    %ebp
  800a9d:	c3                   	ret    

00800a9e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a9e:	55                   	push   %ebp
  800a9f:	89 e5                	mov    %esp,%ebp
  800aa1:	57                   	push   %edi
  800aa2:	56                   	push   %esi
  800aa3:	53                   	push   %ebx
  800aa4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aa7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aaa:	eb 03                	jmp    800aaf <strtol+0x11>
		s++;
  800aac:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aaf:	0f b6 01             	movzbl (%ecx),%eax
  800ab2:	3c 20                	cmp    $0x20,%al
  800ab4:	74 f6                	je     800aac <strtol+0xe>
  800ab6:	3c 09                	cmp    $0x9,%al
  800ab8:	74 f2                	je     800aac <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800aba:	3c 2b                	cmp    $0x2b,%al
  800abc:	75 0a                	jne    800ac8 <strtol+0x2a>
		s++;
  800abe:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ac1:	bf 00 00 00 00       	mov    $0x0,%edi
  800ac6:	eb 11                	jmp    800ad9 <strtol+0x3b>
  800ac8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800acd:	3c 2d                	cmp    $0x2d,%al
  800acf:	75 08                	jne    800ad9 <strtol+0x3b>
		s++, neg = 1;
  800ad1:	83 c1 01             	add    $0x1,%ecx
  800ad4:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800adf:	75 15                	jne    800af6 <strtol+0x58>
  800ae1:	80 39 30             	cmpb   $0x30,(%ecx)
  800ae4:	75 10                	jne    800af6 <strtol+0x58>
  800ae6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800aea:	75 7c                	jne    800b68 <strtol+0xca>
		s += 2, base = 16;
  800aec:	83 c1 02             	add    $0x2,%ecx
  800aef:	bb 10 00 00 00       	mov    $0x10,%ebx
  800af4:	eb 16                	jmp    800b0c <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800af6:	85 db                	test   %ebx,%ebx
  800af8:	75 12                	jne    800b0c <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800afa:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800aff:	80 39 30             	cmpb   $0x30,(%ecx)
  800b02:	75 08                	jne    800b0c <strtol+0x6e>
		s++, base = 8;
  800b04:	83 c1 01             	add    $0x1,%ecx
  800b07:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b11:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b14:	0f b6 11             	movzbl (%ecx),%edx
  800b17:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b1a:	89 f3                	mov    %esi,%ebx
  800b1c:	80 fb 09             	cmp    $0x9,%bl
  800b1f:	77 08                	ja     800b29 <strtol+0x8b>
			dig = *s - '0';
  800b21:	0f be d2             	movsbl %dl,%edx
  800b24:	83 ea 30             	sub    $0x30,%edx
  800b27:	eb 22                	jmp    800b4b <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800b29:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b2c:	89 f3                	mov    %esi,%ebx
  800b2e:	80 fb 19             	cmp    $0x19,%bl
  800b31:	77 08                	ja     800b3b <strtol+0x9d>
			dig = *s - 'a' + 10;
  800b33:	0f be d2             	movsbl %dl,%edx
  800b36:	83 ea 57             	sub    $0x57,%edx
  800b39:	eb 10                	jmp    800b4b <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800b3b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b3e:	89 f3                	mov    %esi,%ebx
  800b40:	80 fb 19             	cmp    $0x19,%bl
  800b43:	77 16                	ja     800b5b <strtol+0xbd>
			dig = *s - 'A' + 10;
  800b45:	0f be d2             	movsbl %dl,%edx
  800b48:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800b4b:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b4e:	7d 0b                	jge    800b5b <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800b50:	83 c1 01             	add    $0x1,%ecx
  800b53:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b57:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800b59:	eb b9                	jmp    800b14 <strtol+0x76>

	if (endptr)
  800b5b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5f:	74 0d                	je     800b6e <strtol+0xd0>
		*endptr = (char *) s;
  800b61:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b64:	89 0e                	mov    %ecx,(%esi)
  800b66:	eb 06                	jmp    800b6e <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b68:	85 db                	test   %ebx,%ebx
  800b6a:	74 98                	je     800b04 <strtol+0x66>
  800b6c:	eb 9e                	jmp    800b0c <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800b6e:	89 c2                	mov    %eax,%edx
  800b70:	f7 da                	neg    %edx
  800b72:	85 ff                	test   %edi,%edi
  800b74:	0f 45 c2             	cmovne %edx,%eax
}
  800b77:	5b                   	pop    %ebx
  800b78:	5e                   	pop    %esi
  800b79:	5f                   	pop    %edi
  800b7a:	5d                   	pop    %ebp
  800b7b:	c3                   	ret    

00800b7c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	57                   	push   %edi
  800b80:	56                   	push   %esi
  800b81:	53                   	push   %ebx
  800b82:	83 ec 1c             	sub    $0x1c,%esp
  800b85:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b88:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b8b:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b90:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b93:	8b 7d 10             	mov    0x10(%ebp),%edi
  800b96:	8b 75 14             	mov    0x14(%ebp),%esi
  800b99:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800b9b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b9f:	74 1d                	je     800bbe <syscall+0x42>
  800ba1:	85 c0                	test   %eax,%eax
  800ba3:	7e 19                	jle    800bbe <syscall+0x42>
  800ba5:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800ba8:	83 ec 0c             	sub    $0xc,%esp
  800bab:	50                   	push   %eax
  800bac:	52                   	push   %edx
  800bad:	68 ff 22 80 00       	push   $0x8022ff
  800bb2:	6a 23                	push   $0x23
  800bb4:	68 1c 23 80 00       	push   $0x80231c
  800bb9:	e8 2b f6 ff ff       	call   8001e9 <_panic>

	return ret;
}
  800bbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5f                   	pop    %edi
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800bcc:	6a 00                	push   $0x0
  800bce:	6a 00                	push   $0x0
  800bd0:	6a 00                	push   $0x0
  800bd2:	ff 75 0c             	pushl  0xc(%ebp)
  800bd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd8:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdd:	b8 00 00 00 00       	mov    $0x0,%eax
  800be2:	e8 95 ff ff ff       	call   800b7c <syscall>
}
  800be7:	83 c4 10             	add    $0x10,%esp
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <sys_cgetc>:

int
sys_cgetc(void)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800bf2:	6a 00                	push   $0x0
  800bf4:	6a 00                	push   $0x0
  800bf6:	6a 00                	push   $0x0
  800bf8:	6a 00                	push   $0x0
  800bfa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bff:	ba 00 00 00 00       	mov    $0x0,%edx
  800c04:	b8 01 00 00 00       	mov    $0x1,%eax
  800c09:	e8 6e ff ff ff       	call   800b7c <syscall>
}
  800c0e:	c9                   	leave  
  800c0f:	c3                   	ret    

00800c10 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800c16:	6a 00                	push   $0x0
  800c18:	6a 00                	push   $0x0
  800c1a:	6a 00                	push   $0x0
  800c1c:	6a 00                	push   $0x0
  800c1e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c21:	ba 01 00 00 00       	mov    $0x1,%edx
  800c26:	b8 03 00 00 00       	mov    $0x3,%eax
  800c2b:	e8 4c ff ff ff       	call   800b7c <syscall>
}
  800c30:	c9                   	leave  
  800c31:	c3                   	ret    

00800c32 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800c38:	6a 00                	push   $0x0
  800c3a:	6a 00                	push   $0x0
  800c3c:	6a 00                	push   $0x0
  800c3e:	6a 00                	push   $0x0
  800c40:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c45:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4a:	b8 02 00 00 00       	mov    $0x2,%eax
  800c4f:	e8 28 ff ff ff       	call   800b7c <syscall>
}
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <sys_yield>:

void
sys_yield(void)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800c5c:	6a 00                	push   $0x0
  800c5e:	6a 00                	push   $0x0
  800c60:	6a 00                	push   $0x0
  800c62:	6a 00                	push   $0x0
  800c64:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c69:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c73:	e8 04 ff ff ff       	call   800b7c <syscall>
}
  800c78:	83 c4 10             	add    $0x10,%esp
  800c7b:	c9                   	leave  
  800c7c:	c3                   	ret    

00800c7d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c7d:	55                   	push   %ebp
  800c7e:	89 e5                	mov    %esp,%ebp
  800c80:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800c83:	6a 00                	push   $0x0
  800c85:	6a 00                	push   $0x0
  800c87:	ff 75 10             	pushl  0x10(%ebp)
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c90:	ba 01 00 00 00       	mov    $0x1,%edx
  800c95:	b8 04 00 00 00       	mov    $0x4,%eax
  800c9a:	e8 dd fe ff ff       	call   800b7c <syscall>
}
  800c9f:	c9                   	leave  
  800ca0:	c3                   	ret    

00800ca1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
  800ca4:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800ca7:	ff 75 18             	pushl  0x18(%ebp)
  800caa:	ff 75 14             	pushl  0x14(%ebp)
  800cad:	ff 75 10             	pushl  0x10(%ebp)
  800cb0:	ff 75 0c             	pushl  0xc(%ebp)
  800cb3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cb6:	ba 01 00 00 00       	mov    $0x1,%edx
  800cbb:	b8 05 00 00 00       	mov    $0x5,%eax
  800cc0:	e8 b7 fe ff ff       	call   800b7c <syscall>
}
  800cc5:	c9                   	leave  
  800cc6:	c3                   	ret    

00800cc7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800ccd:	6a 00                	push   $0x0
  800ccf:	6a 00                	push   $0x0
  800cd1:	6a 00                	push   $0x0
  800cd3:	ff 75 0c             	pushl  0xc(%ebp)
  800cd6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd9:	ba 01 00 00 00       	mov    $0x1,%edx
  800cde:	b8 06 00 00 00       	mov    $0x6,%eax
  800ce3:	e8 94 fe ff ff       	call   800b7c <syscall>
}
  800ce8:	c9                   	leave  
  800ce9:	c3                   	ret    

00800cea <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800cf0:	6a 00                	push   $0x0
  800cf2:	6a 00                	push   $0x0
  800cf4:	6a 00                	push   $0x0
  800cf6:	ff 75 0c             	pushl  0xc(%ebp)
  800cf9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cfc:	ba 01 00 00 00       	mov    $0x1,%edx
  800d01:	b8 08 00 00 00       	mov    $0x8,%eax
  800d06:	e8 71 fe ff ff       	call   800b7c <syscall>
}
  800d0b:	c9                   	leave  
  800d0c:	c3                   	ret    

00800d0d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800d13:	6a 00                	push   $0x0
  800d15:	6a 00                	push   $0x0
  800d17:	6a 00                	push   $0x0
  800d19:	ff 75 0c             	pushl  0xc(%ebp)
  800d1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d1f:	ba 01 00 00 00       	mov    $0x1,%edx
  800d24:	b8 09 00 00 00       	mov    $0x9,%eax
  800d29:	e8 4e fe ff ff       	call   800b7c <syscall>
}
  800d2e:	c9                   	leave  
  800d2f:	c3                   	ret    

00800d30 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800d36:	6a 00                	push   $0x0
  800d38:	6a 00                	push   $0x0
  800d3a:	6a 00                	push   $0x0
  800d3c:	ff 75 0c             	pushl  0xc(%ebp)
  800d3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d42:	ba 01 00 00 00       	mov    $0x1,%edx
  800d47:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d4c:	e8 2b fe ff ff       	call   800b7c <syscall>
}
  800d51:	c9                   	leave  
  800d52:	c3                   	ret    

00800d53 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800d59:	6a 00                	push   $0x0
  800d5b:	ff 75 14             	pushl  0x14(%ebp)
  800d5e:	ff 75 10             	pushl  0x10(%ebp)
  800d61:	ff 75 0c             	pushl  0xc(%ebp)
  800d64:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d67:	ba 00 00 00 00       	mov    $0x0,%edx
  800d6c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d71:	e8 06 fe ff ff       	call   800b7c <syscall>
}
  800d76:	c9                   	leave  
  800d77:	c3                   	ret    

00800d78 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800d7e:	6a 00                	push   $0x0
  800d80:	6a 00                	push   $0x0
  800d82:	6a 00                	push   $0x0
  800d84:	6a 00                	push   $0x0
  800d86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d89:	ba 01 00 00 00       	mov    $0x1,%edx
  800d8e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d93:	e8 e4 fd ff ff       	call   800b7c <syscall>
}
  800d98:	c9                   	leave  
  800d99:	c3                   	ret    

00800d9a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	05 00 00 00 30       	add    $0x30000000,%eax
  800da5:	c1 e8 0c             	shr    $0xc,%eax
}
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  800dad:	ff 75 08             	pushl  0x8(%ebp)
  800db0:	e8 e5 ff ff ff       	call   800d9a <fd2num>
  800db5:	83 c4 04             	add    $0x4,%esp
  800db8:	c1 e0 0c             	shl    $0xc,%eax
  800dbb:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800dc0:	c9                   	leave  
  800dc1:	c3                   	ret    

00800dc2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dc8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800dcd:	89 c2                	mov    %eax,%edx
  800dcf:	c1 ea 16             	shr    $0x16,%edx
  800dd2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800dd9:	f6 c2 01             	test   $0x1,%dl
  800ddc:	74 11                	je     800def <fd_alloc+0x2d>
  800dde:	89 c2                	mov    %eax,%edx
  800de0:	c1 ea 0c             	shr    $0xc,%edx
  800de3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800dea:	f6 c2 01             	test   $0x1,%dl
  800ded:	75 09                	jne    800df8 <fd_alloc+0x36>
			*fd_store = fd;
  800def:	89 01                	mov    %eax,(%ecx)
			return 0;
  800df1:	b8 00 00 00 00       	mov    $0x0,%eax
  800df6:	eb 17                	jmp    800e0f <fd_alloc+0x4d>
  800df8:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800dfd:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e02:	75 c9                	jne    800dcd <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e04:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800e0a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800e0f:	5d                   	pop    %ebp
  800e10:	c3                   	ret    

00800e11 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e17:	83 f8 1f             	cmp    $0x1f,%eax
  800e1a:	77 36                	ja     800e52 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e1c:	c1 e0 0c             	shl    $0xc,%eax
  800e1f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e24:	89 c2                	mov    %eax,%edx
  800e26:	c1 ea 16             	shr    $0x16,%edx
  800e29:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e30:	f6 c2 01             	test   $0x1,%dl
  800e33:	74 24                	je     800e59 <fd_lookup+0x48>
  800e35:	89 c2                	mov    %eax,%edx
  800e37:	c1 ea 0c             	shr    $0xc,%edx
  800e3a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e41:	f6 c2 01             	test   $0x1,%dl
  800e44:	74 1a                	je     800e60 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e46:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e49:	89 02                	mov    %eax,(%edx)
	return 0;
  800e4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e50:	eb 13                	jmp    800e65 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800e52:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e57:	eb 0c                	jmp    800e65 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800e59:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e5e:	eb 05                	jmp    800e65 <fd_lookup+0x54>
  800e60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    

00800e67 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 08             	sub    $0x8,%esp
  800e6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e70:	ba ac 23 80 00       	mov    $0x8023ac,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800e75:	eb 13                	jmp    800e8a <dev_lookup+0x23>
  800e77:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  800e7a:	39 08                	cmp    %ecx,(%eax)
  800e7c:	75 0c                	jne    800e8a <dev_lookup+0x23>
			*dev = devtab[i];
  800e7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e81:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e83:	b8 00 00 00 00       	mov    $0x0,%eax
  800e88:	eb 2e                	jmp    800eb8 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800e8a:	8b 02                	mov    (%edx),%eax
  800e8c:	85 c0                	test   %eax,%eax
  800e8e:	75 e7                	jne    800e77 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e90:	a1 08 40 80 00       	mov    0x804008,%eax
  800e95:	8b 40 48             	mov    0x48(%eax),%eax
  800e98:	83 ec 04             	sub    $0x4,%esp
  800e9b:	51                   	push   %ecx
  800e9c:	50                   	push   %eax
  800e9d:	68 2c 23 80 00       	push   $0x80232c
  800ea2:	e8 1b f4 ff ff       	call   8002c2 <cprintf>
	*dev = 0;
  800ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800eb0:	83 c4 10             	add    $0x10,%esp
  800eb3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800eb8:	c9                   	leave  
  800eb9:	c3                   	ret    

00800eba <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	56                   	push   %esi
  800ebe:	53                   	push   %ebx
  800ebf:	83 ec 10             	sub    $0x10,%esp
  800ec2:	8b 75 08             	mov    0x8(%ebp),%esi
  800ec5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ec8:	56                   	push   %esi
  800ec9:	e8 cc fe ff ff       	call   800d9a <fd2num>
  800ece:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800ed1:	89 14 24             	mov    %edx,(%esp)
  800ed4:	50                   	push   %eax
  800ed5:	e8 37 ff ff ff       	call   800e11 <fd_lookup>
  800eda:	83 c4 08             	add    $0x8,%esp
  800edd:	85 c0                	test   %eax,%eax
  800edf:	78 05                	js     800ee6 <fd_close+0x2c>
	    || fd != fd2)
  800ee1:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800ee4:	74 0c                	je     800ef2 <fd_close+0x38>
		return (must_exist ? r : 0);
  800ee6:	84 db                	test   %bl,%bl
  800ee8:	ba 00 00 00 00       	mov    $0x0,%edx
  800eed:	0f 44 c2             	cmove  %edx,%eax
  800ef0:	eb 41                	jmp    800f33 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800ef2:	83 ec 08             	sub    $0x8,%esp
  800ef5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ef8:	50                   	push   %eax
  800ef9:	ff 36                	pushl  (%esi)
  800efb:	e8 67 ff ff ff       	call   800e67 <dev_lookup>
  800f00:	89 c3                	mov    %eax,%ebx
  800f02:	83 c4 10             	add    $0x10,%esp
  800f05:	85 c0                	test   %eax,%eax
  800f07:	78 1a                	js     800f23 <fd_close+0x69>
		if (dev->dev_close)
  800f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f0c:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800f0f:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800f14:	85 c0                	test   %eax,%eax
  800f16:	74 0b                	je     800f23 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  800f18:	83 ec 0c             	sub    $0xc,%esp
  800f1b:	56                   	push   %esi
  800f1c:	ff d0                	call   *%eax
  800f1e:	89 c3                	mov    %eax,%ebx
  800f20:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800f23:	83 ec 08             	sub    $0x8,%esp
  800f26:	56                   	push   %esi
  800f27:	6a 00                	push   $0x0
  800f29:	e8 99 fd ff ff       	call   800cc7 <sys_page_unmap>
	return r;
  800f2e:	83 c4 10             	add    $0x10,%esp
  800f31:	89 d8                	mov    %ebx,%eax
}
  800f33:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f36:	5b                   	pop    %ebx
  800f37:	5e                   	pop    %esi
  800f38:	5d                   	pop    %ebp
  800f39:	c3                   	ret    

00800f3a <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f40:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f43:	50                   	push   %eax
  800f44:	ff 75 08             	pushl  0x8(%ebp)
  800f47:	e8 c5 fe ff ff       	call   800e11 <fd_lookup>
  800f4c:	83 c4 08             	add    $0x8,%esp
  800f4f:	85 c0                	test   %eax,%eax
  800f51:	78 10                	js     800f63 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800f53:	83 ec 08             	sub    $0x8,%esp
  800f56:	6a 01                	push   $0x1
  800f58:	ff 75 f4             	pushl  -0xc(%ebp)
  800f5b:	e8 5a ff ff ff       	call   800eba <fd_close>
  800f60:	83 c4 10             	add    $0x10,%esp
}
  800f63:	c9                   	leave  
  800f64:	c3                   	ret    

00800f65 <close_all>:

void
close_all(void)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	53                   	push   %ebx
  800f69:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f6c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f71:	83 ec 0c             	sub    $0xc,%esp
  800f74:	53                   	push   %ebx
  800f75:	e8 c0 ff ff ff       	call   800f3a <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800f7a:	83 c3 01             	add    $0x1,%ebx
  800f7d:	83 c4 10             	add    $0x10,%esp
  800f80:	83 fb 20             	cmp    $0x20,%ebx
  800f83:	75 ec                	jne    800f71 <close_all+0xc>
		close(i);
}
  800f85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    

00800f8a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	57                   	push   %edi
  800f8e:	56                   	push   %esi
  800f8f:	53                   	push   %ebx
  800f90:	83 ec 2c             	sub    $0x2c,%esp
  800f93:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f96:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f99:	50                   	push   %eax
  800f9a:	ff 75 08             	pushl  0x8(%ebp)
  800f9d:	e8 6f fe ff ff       	call   800e11 <fd_lookup>
  800fa2:	83 c4 08             	add    $0x8,%esp
  800fa5:	85 c0                	test   %eax,%eax
  800fa7:	0f 88 c1 00 00 00    	js     80106e <dup+0xe4>
		return r;
	close(newfdnum);
  800fad:	83 ec 0c             	sub    $0xc,%esp
  800fb0:	56                   	push   %esi
  800fb1:	e8 84 ff ff ff       	call   800f3a <close>

	newfd = INDEX2FD(newfdnum);
  800fb6:	89 f3                	mov    %esi,%ebx
  800fb8:	c1 e3 0c             	shl    $0xc,%ebx
  800fbb:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800fc1:	83 c4 04             	add    $0x4,%esp
  800fc4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fc7:	e8 de fd ff ff       	call   800daa <fd2data>
  800fcc:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  800fce:	89 1c 24             	mov    %ebx,(%esp)
  800fd1:	e8 d4 fd ff ff       	call   800daa <fd2data>
  800fd6:	83 c4 10             	add    $0x10,%esp
  800fd9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800fdc:	89 f8                	mov    %edi,%eax
  800fde:	c1 e8 16             	shr    $0x16,%eax
  800fe1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fe8:	a8 01                	test   $0x1,%al
  800fea:	74 37                	je     801023 <dup+0x99>
  800fec:	89 f8                	mov    %edi,%eax
  800fee:	c1 e8 0c             	shr    $0xc,%eax
  800ff1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800ff8:	f6 c2 01             	test   $0x1,%dl
  800ffb:	74 26                	je     801023 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800ffd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801004:	83 ec 0c             	sub    $0xc,%esp
  801007:	25 07 0e 00 00       	and    $0xe07,%eax
  80100c:	50                   	push   %eax
  80100d:	ff 75 d4             	pushl  -0x2c(%ebp)
  801010:	6a 00                	push   $0x0
  801012:	57                   	push   %edi
  801013:	6a 00                	push   $0x0
  801015:	e8 87 fc ff ff       	call   800ca1 <sys_page_map>
  80101a:	89 c7                	mov    %eax,%edi
  80101c:	83 c4 20             	add    $0x20,%esp
  80101f:	85 c0                	test   %eax,%eax
  801021:	78 2e                	js     801051 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801023:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801026:	89 d0                	mov    %edx,%eax
  801028:	c1 e8 0c             	shr    $0xc,%eax
  80102b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801032:	83 ec 0c             	sub    $0xc,%esp
  801035:	25 07 0e 00 00       	and    $0xe07,%eax
  80103a:	50                   	push   %eax
  80103b:	53                   	push   %ebx
  80103c:	6a 00                	push   $0x0
  80103e:	52                   	push   %edx
  80103f:	6a 00                	push   $0x0
  801041:	e8 5b fc ff ff       	call   800ca1 <sys_page_map>
  801046:	89 c7                	mov    %eax,%edi
  801048:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  80104b:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80104d:	85 ff                	test   %edi,%edi
  80104f:	79 1d                	jns    80106e <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801051:	83 ec 08             	sub    $0x8,%esp
  801054:	53                   	push   %ebx
  801055:	6a 00                	push   $0x0
  801057:	e8 6b fc ff ff       	call   800cc7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80105c:	83 c4 08             	add    $0x8,%esp
  80105f:	ff 75 d4             	pushl  -0x2c(%ebp)
  801062:	6a 00                	push   $0x0
  801064:	e8 5e fc ff ff       	call   800cc7 <sys_page_unmap>
	return r;
  801069:	83 c4 10             	add    $0x10,%esp
  80106c:	89 f8                	mov    %edi,%eax
}
  80106e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801071:	5b                   	pop    %ebx
  801072:	5e                   	pop    %esi
  801073:	5f                   	pop    %edi
  801074:	5d                   	pop    %ebp
  801075:	c3                   	ret    

00801076 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	53                   	push   %ebx
  80107a:	83 ec 14             	sub    $0x14,%esp
  80107d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801080:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801083:	50                   	push   %eax
  801084:	53                   	push   %ebx
  801085:	e8 87 fd ff ff       	call   800e11 <fd_lookup>
  80108a:	83 c4 08             	add    $0x8,%esp
  80108d:	89 c2                	mov    %eax,%edx
  80108f:	85 c0                	test   %eax,%eax
  801091:	78 6d                	js     801100 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801093:	83 ec 08             	sub    $0x8,%esp
  801096:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801099:	50                   	push   %eax
  80109a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80109d:	ff 30                	pushl  (%eax)
  80109f:	e8 c3 fd ff ff       	call   800e67 <dev_lookup>
  8010a4:	83 c4 10             	add    $0x10,%esp
  8010a7:	85 c0                	test   %eax,%eax
  8010a9:	78 4c                	js     8010f7 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8010ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010ae:	8b 42 08             	mov    0x8(%edx),%eax
  8010b1:	83 e0 03             	and    $0x3,%eax
  8010b4:	83 f8 01             	cmp    $0x1,%eax
  8010b7:	75 21                	jne    8010da <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8010b9:	a1 08 40 80 00       	mov    0x804008,%eax
  8010be:	8b 40 48             	mov    0x48(%eax),%eax
  8010c1:	83 ec 04             	sub    $0x4,%esp
  8010c4:	53                   	push   %ebx
  8010c5:	50                   	push   %eax
  8010c6:	68 70 23 80 00       	push   $0x802370
  8010cb:	e8 f2 f1 ff ff       	call   8002c2 <cprintf>
		return -E_INVAL;
  8010d0:	83 c4 10             	add    $0x10,%esp
  8010d3:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8010d8:	eb 26                	jmp    801100 <read+0x8a>
	}
	if (!dev->dev_read)
  8010da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010dd:	8b 40 08             	mov    0x8(%eax),%eax
  8010e0:	85 c0                	test   %eax,%eax
  8010e2:	74 17                	je     8010fb <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8010e4:	83 ec 04             	sub    $0x4,%esp
  8010e7:	ff 75 10             	pushl  0x10(%ebp)
  8010ea:	ff 75 0c             	pushl  0xc(%ebp)
  8010ed:	52                   	push   %edx
  8010ee:	ff d0                	call   *%eax
  8010f0:	89 c2                	mov    %eax,%edx
  8010f2:	83 c4 10             	add    $0x10,%esp
  8010f5:	eb 09                	jmp    801100 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010f7:	89 c2                	mov    %eax,%edx
  8010f9:	eb 05                	jmp    801100 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8010fb:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  801100:	89 d0                	mov    %edx,%eax
  801102:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801105:	c9                   	leave  
  801106:	c3                   	ret    

00801107 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	57                   	push   %edi
  80110b:	56                   	push   %esi
  80110c:	53                   	push   %ebx
  80110d:	83 ec 0c             	sub    $0xc,%esp
  801110:	8b 7d 08             	mov    0x8(%ebp),%edi
  801113:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801116:	bb 00 00 00 00       	mov    $0x0,%ebx
  80111b:	eb 21                	jmp    80113e <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80111d:	83 ec 04             	sub    $0x4,%esp
  801120:	89 f0                	mov    %esi,%eax
  801122:	29 d8                	sub    %ebx,%eax
  801124:	50                   	push   %eax
  801125:	89 d8                	mov    %ebx,%eax
  801127:	03 45 0c             	add    0xc(%ebp),%eax
  80112a:	50                   	push   %eax
  80112b:	57                   	push   %edi
  80112c:	e8 45 ff ff ff       	call   801076 <read>
		if (m < 0)
  801131:	83 c4 10             	add    $0x10,%esp
  801134:	85 c0                	test   %eax,%eax
  801136:	78 10                	js     801148 <readn+0x41>
			return m;
		if (m == 0)
  801138:	85 c0                	test   %eax,%eax
  80113a:	74 0a                	je     801146 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80113c:	01 c3                	add    %eax,%ebx
  80113e:	39 f3                	cmp    %esi,%ebx
  801140:	72 db                	jb     80111d <readn+0x16>
  801142:	89 d8                	mov    %ebx,%eax
  801144:	eb 02                	jmp    801148 <readn+0x41>
  801146:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801148:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80114b:	5b                   	pop    %ebx
  80114c:	5e                   	pop    %esi
  80114d:	5f                   	pop    %edi
  80114e:	5d                   	pop    %ebp
  80114f:	c3                   	ret    

00801150 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	53                   	push   %ebx
  801154:	83 ec 14             	sub    $0x14,%esp
  801157:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80115a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80115d:	50                   	push   %eax
  80115e:	53                   	push   %ebx
  80115f:	e8 ad fc ff ff       	call   800e11 <fd_lookup>
  801164:	83 c4 08             	add    $0x8,%esp
  801167:	89 c2                	mov    %eax,%edx
  801169:	85 c0                	test   %eax,%eax
  80116b:	78 68                	js     8011d5 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80116d:	83 ec 08             	sub    $0x8,%esp
  801170:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801173:	50                   	push   %eax
  801174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801177:	ff 30                	pushl  (%eax)
  801179:	e8 e9 fc ff ff       	call   800e67 <dev_lookup>
  80117e:	83 c4 10             	add    $0x10,%esp
  801181:	85 c0                	test   %eax,%eax
  801183:	78 47                	js     8011cc <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801185:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801188:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80118c:	75 21                	jne    8011af <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80118e:	a1 08 40 80 00       	mov    0x804008,%eax
  801193:	8b 40 48             	mov    0x48(%eax),%eax
  801196:	83 ec 04             	sub    $0x4,%esp
  801199:	53                   	push   %ebx
  80119a:	50                   	push   %eax
  80119b:	68 8c 23 80 00       	push   $0x80238c
  8011a0:	e8 1d f1 ff ff       	call   8002c2 <cprintf>
		return -E_INVAL;
  8011a5:	83 c4 10             	add    $0x10,%esp
  8011a8:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8011ad:	eb 26                	jmp    8011d5 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8011af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b2:	8b 52 0c             	mov    0xc(%edx),%edx
  8011b5:	85 d2                	test   %edx,%edx
  8011b7:	74 17                	je     8011d0 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8011b9:	83 ec 04             	sub    $0x4,%esp
  8011bc:	ff 75 10             	pushl  0x10(%ebp)
  8011bf:	ff 75 0c             	pushl  0xc(%ebp)
  8011c2:	50                   	push   %eax
  8011c3:	ff d2                	call   *%edx
  8011c5:	89 c2                	mov    %eax,%edx
  8011c7:	83 c4 10             	add    $0x10,%esp
  8011ca:	eb 09                	jmp    8011d5 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011cc:	89 c2                	mov    %eax,%edx
  8011ce:	eb 05                	jmp    8011d5 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8011d0:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  8011d5:	89 d0                	mov    %edx,%eax
  8011d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011da:	c9                   	leave  
  8011db:	c3                   	ret    

008011dc <seek>:

int
seek(int fdnum, off_t offset)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011e2:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8011e5:	50                   	push   %eax
  8011e6:	ff 75 08             	pushl  0x8(%ebp)
  8011e9:	e8 23 fc ff ff       	call   800e11 <fd_lookup>
  8011ee:	83 c4 08             	add    $0x8,%esp
  8011f1:	85 c0                	test   %eax,%eax
  8011f3:	78 0e                	js     801203 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8011f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011fb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8011fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801203:	c9                   	leave  
  801204:	c3                   	ret    

00801205 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	53                   	push   %ebx
  801209:	83 ec 14             	sub    $0x14,%esp
  80120c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80120f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801212:	50                   	push   %eax
  801213:	53                   	push   %ebx
  801214:	e8 f8 fb ff ff       	call   800e11 <fd_lookup>
  801219:	83 c4 08             	add    $0x8,%esp
  80121c:	89 c2                	mov    %eax,%edx
  80121e:	85 c0                	test   %eax,%eax
  801220:	78 65                	js     801287 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801222:	83 ec 08             	sub    $0x8,%esp
  801225:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801228:	50                   	push   %eax
  801229:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80122c:	ff 30                	pushl  (%eax)
  80122e:	e8 34 fc ff ff       	call   800e67 <dev_lookup>
  801233:	83 c4 10             	add    $0x10,%esp
  801236:	85 c0                	test   %eax,%eax
  801238:	78 44                	js     80127e <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80123a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80123d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801241:	75 21                	jne    801264 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801243:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801248:	8b 40 48             	mov    0x48(%eax),%eax
  80124b:	83 ec 04             	sub    $0x4,%esp
  80124e:	53                   	push   %ebx
  80124f:	50                   	push   %eax
  801250:	68 4c 23 80 00       	push   $0x80234c
  801255:	e8 68 f0 ff ff       	call   8002c2 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80125a:	83 c4 10             	add    $0x10,%esp
  80125d:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801262:	eb 23                	jmp    801287 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  801264:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801267:	8b 52 18             	mov    0x18(%edx),%edx
  80126a:	85 d2                	test   %edx,%edx
  80126c:	74 14                	je     801282 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80126e:	83 ec 08             	sub    $0x8,%esp
  801271:	ff 75 0c             	pushl  0xc(%ebp)
  801274:	50                   	push   %eax
  801275:	ff d2                	call   *%edx
  801277:	89 c2                	mov    %eax,%edx
  801279:	83 c4 10             	add    $0x10,%esp
  80127c:	eb 09                	jmp    801287 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80127e:	89 c2                	mov    %eax,%edx
  801280:	eb 05                	jmp    801287 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801282:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  801287:	89 d0                	mov    %edx,%eax
  801289:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80128c:	c9                   	leave  
  80128d:	c3                   	ret    

0080128e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
  801291:	53                   	push   %ebx
  801292:	83 ec 14             	sub    $0x14,%esp
  801295:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801298:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80129b:	50                   	push   %eax
  80129c:	ff 75 08             	pushl  0x8(%ebp)
  80129f:	e8 6d fb ff ff       	call   800e11 <fd_lookup>
  8012a4:	83 c4 08             	add    $0x8,%esp
  8012a7:	89 c2                	mov    %eax,%edx
  8012a9:	85 c0                	test   %eax,%eax
  8012ab:	78 58                	js     801305 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012ad:	83 ec 08             	sub    $0x8,%esp
  8012b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b3:	50                   	push   %eax
  8012b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b7:	ff 30                	pushl  (%eax)
  8012b9:	e8 a9 fb ff ff       	call   800e67 <dev_lookup>
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	85 c0                	test   %eax,%eax
  8012c3:	78 37                	js     8012fc <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  8012c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8012cc:	74 32                	je     801300 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8012ce:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8012d1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8012d8:	00 00 00 
	stat->st_isdir = 0;
  8012db:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8012e2:	00 00 00 
	stat->st_dev = dev;
  8012e5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8012eb:	83 ec 08             	sub    $0x8,%esp
  8012ee:	53                   	push   %ebx
  8012ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8012f2:	ff 50 14             	call   *0x14(%eax)
  8012f5:	89 c2                	mov    %eax,%edx
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	eb 09                	jmp    801305 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012fc:	89 c2                	mov    %eax,%edx
  8012fe:	eb 05                	jmp    801305 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801300:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801305:	89 d0                	mov    %edx,%eax
  801307:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80130a:	c9                   	leave  
  80130b:	c3                   	ret    

0080130c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	56                   	push   %esi
  801310:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801311:	83 ec 08             	sub    $0x8,%esp
  801314:	6a 00                	push   $0x0
  801316:	ff 75 08             	pushl  0x8(%ebp)
  801319:	e8 06 02 00 00       	call   801524 <open>
  80131e:	89 c3                	mov    %eax,%ebx
  801320:	83 c4 10             	add    $0x10,%esp
  801323:	85 c0                	test   %eax,%eax
  801325:	78 1b                	js     801342 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801327:	83 ec 08             	sub    $0x8,%esp
  80132a:	ff 75 0c             	pushl  0xc(%ebp)
  80132d:	50                   	push   %eax
  80132e:	e8 5b ff ff ff       	call   80128e <fstat>
  801333:	89 c6                	mov    %eax,%esi
	close(fd);
  801335:	89 1c 24             	mov    %ebx,(%esp)
  801338:	e8 fd fb ff ff       	call   800f3a <close>
	return r;
  80133d:	83 c4 10             	add    $0x10,%esp
  801340:	89 f0                	mov    %esi,%eax
}
  801342:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801345:	5b                   	pop    %ebx
  801346:	5e                   	pop    %esi
  801347:	5d                   	pop    %ebp
  801348:	c3                   	ret    

00801349 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	56                   	push   %esi
  80134d:	53                   	push   %ebx
  80134e:	89 c6                	mov    %eax,%esi
  801350:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801352:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801359:	75 12                	jne    80136d <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80135b:	83 ec 0c             	sub    $0xc,%esp
  80135e:	6a 01                	push   $0x1
  801360:	e8 11 09 00 00       	call   801c76 <ipc_find_env>
  801365:	a3 04 40 80 00       	mov    %eax,0x804004
  80136a:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80136d:	6a 07                	push   $0x7
  80136f:	68 00 50 80 00       	push   $0x805000
  801374:	56                   	push   %esi
  801375:	ff 35 04 40 80 00    	pushl  0x804004
  80137b:	e8 a2 08 00 00       	call   801c22 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801380:	83 c4 0c             	add    $0xc,%esp
  801383:	6a 00                	push   $0x0
  801385:	53                   	push   %ebx
  801386:	6a 00                	push   $0x0
  801388:	e8 2a 08 00 00       	call   801bb7 <ipc_recv>
}
  80138d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801390:	5b                   	pop    %ebx
  801391:	5e                   	pop    %esi
  801392:	5d                   	pop    %ebp
  801393:	c3                   	ret    

00801394 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
  801397:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	8b 40 0c             	mov    0xc(%eax),%eax
  8013a0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8013a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a8:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b2:	b8 02 00 00 00       	mov    $0x2,%eax
  8013b7:	e8 8d ff ff ff       	call   801349 <fsipc>
}
  8013bc:	c9                   	leave  
  8013bd:	c3                   	ret    

008013be <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
  8013c1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8013ca:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8013cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d4:	b8 06 00 00 00       	mov    $0x6,%eax
  8013d9:	e8 6b ff ff ff       	call   801349 <fsipc>
}
  8013de:	c9                   	leave  
  8013df:	c3                   	ret    

008013e0 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
  8013e3:	53                   	push   %ebx
  8013e4:	83 ec 04             	sub    $0x4,%esp
  8013e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8013f0:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8013f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8013fa:	b8 05 00 00 00       	mov    $0x5,%eax
  8013ff:	e8 45 ff ff ff       	call   801349 <fsipc>
  801404:	85 c0                	test   %eax,%eax
  801406:	78 2c                	js     801434 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801408:	83 ec 08             	sub    $0x8,%esp
  80140b:	68 00 50 80 00       	push   $0x805000
  801410:	53                   	push   %ebx
  801411:	e8 1e f4 ff ff       	call   800834 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801416:	a1 80 50 80 00       	mov    0x805080,%eax
  80141b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801421:	a1 84 50 80 00       	mov    0x805084,%eax
  801426:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80142c:	83 c4 10             	add    $0x10,%esp
  80142f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801434:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801437:	c9                   	leave  
  801438:	c3                   	ret    

00801439 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
  80143c:	83 ec 08             	sub    $0x8,%esp
  80143f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801442:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801445:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801448:	8b 49 0c             	mov    0xc(%ecx),%ecx
  80144b:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  801451:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801456:	76 22                	jbe    80147a <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  801458:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  80145f:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  801462:	83 ec 04             	sub    $0x4,%esp
  801465:	68 f8 0f 00 00       	push   $0xff8
  80146a:	52                   	push   %edx
  80146b:	68 08 50 80 00       	push   $0x805008
  801470:	e8 52 f5 ff ff       	call   8009c7 <memmove>
  801475:	83 c4 10             	add    $0x10,%esp
  801478:	eb 17                	jmp    801491 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  80147a:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  80147f:	83 ec 04             	sub    $0x4,%esp
  801482:	50                   	push   %eax
  801483:	52                   	push   %edx
  801484:	68 08 50 80 00       	push   $0x805008
  801489:	e8 39 f5 ff ff       	call   8009c7 <memmove>
  80148e:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  801491:	ba 00 00 00 00       	mov    $0x0,%edx
  801496:	b8 04 00 00 00       	mov    $0x4,%eax
  80149b:	e8 a9 fe ff ff       	call   801349 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  8014a0:	c9                   	leave  
  8014a1:	c3                   	ret    

008014a2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	56                   	push   %esi
  8014a6:	53                   	push   %ebx
  8014a7:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8014b0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8014b5:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8014bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c0:	b8 03 00 00 00       	mov    $0x3,%eax
  8014c5:	e8 7f fe ff ff       	call   801349 <fsipc>
  8014ca:	89 c3                	mov    %eax,%ebx
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	78 4b                	js     80151b <devfile_read+0x79>
		return r;
	assert(r <= n);
  8014d0:	39 c6                	cmp    %eax,%esi
  8014d2:	73 16                	jae    8014ea <devfile_read+0x48>
  8014d4:	68 bc 23 80 00       	push   $0x8023bc
  8014d9:	68 c3 23 80 00       	push   $0x8023c3
  8014de:	6a 7c                	push   $0x7c
  8014e0:	68 d8 23 80 00       	push   $0x8023d8
  8014e5:	e8 ff ec ff ff       	call   8001e9 <_panic>
	assert(r <= PGSIZE);
  8014ea:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8014ef:	7e 16                	jle    801507 <devfile_read+0x65>
  8014f1:	68 e3 23 80 00       	push   $0x8023e3
  8014f6:	68 c3 23 80 00       	push   $0x8023c3
  8014fb:	6a 7d                	push   $0x7d
  8014fd:	68 d8 23 80 00       	push   $0x8023d8
  801502:	e8 e2 ec ff ff       	call   8001e9 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801507:	83 ec 04             	sub    $0x4,%esp
  80150a:	50                   	push   %eax
  80150b:	68 00 50 80 00       	push   $0x805000
  801510:	ff 75 0c             	pushl  0xc(%ebp)
  801513:	e8 af f4 ff ff       	call   8009c7 <memmove>
	return r;
  801518:	83 c4 10             	add    $0x10,%esp
}
  80151b:	89 d8                	mov    %ebx,%eax
  80151d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801520:	5b                   	pop    %ebx
  801521:	5e                   	pop    %esi
  801522:	5d                   	pop    %ebp
  801523:	c3                   	ret    

00801524 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	53                   	push   %ebx
  801528:	83 ec 20             	sub    $0x20,%esp
  80152b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80152e:	53                   	push   %ebx
  80152f:	e8 c7 f2 ff ff       	call   8007fb <strlen>
  801534:	83 c4 10             	add    $0x10,%esp
  801537:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80153c:	7f 67                	jg     8015a5 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80153e:	83 ec 0c             	sub    $0xc,%esp
  801541:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801544:	50                   	push   %eax
  801545:	e8 78 f8 ff ff       	call   800dc2 <fd_alloc>
  80154a:	83 c4 10             	add    $0x10,%esp
		return r;
  80154d:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80154f:	85 c0                	test   %eax,%eax
  801551:	78 57                	js     8015aa <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801553:	83 ec 08             	sub    $0x8,%esp
  801556:	53                   	push   %ebx
  801557:	68 00 50 80 00       	push   $0x805000
  80155c:	e8 d3 f2 ff ff       	call   800834 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801561:	8b 45 0c             	mov    0xc(%ebp),%eax
  801564:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801569:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156c:	b8 01 00 00 00       	mov    $0x1,%eax
  801571:	e8 d3 fd ff ff       	call   801349 <fsipc>
  801576:	89 c3                	mov    %eax,%ebx
  801578:	83 c4 10             	add    $0x10,%esp
  80157b:	85 c0                	test   %eax,%eax
  80157d:	79 14                	jns    801593 <open+0x6f>
		fd_close(fd, 0);
  80157f:	83 ec 08             	sub    $0x8,%esp
  801582:	6a 00                	push   $0x0
  801584:	ff 75 f4             	pushl  -0xc(%ebp)
  801587:	e8 2e f9 ff ff       	call   800eba <fd_close>
		return r;
  80158c:	83 c4 10             	add    $0x10,%esp
  80158f:	89 da                	mov    %ebx,%edx
  801591:	eb 17                	jmp    8015aa <open+0x86>
	}

	return fd2num(fd);
  801593:	83 ec 0c             	sub    $0xc,%esp
  801596:	ff 75 f4             	pushl  -0xc(%ebp)
  801599:	e8 fc f7 ff ff       	call   800d9a <fd2num>
  80159e:	89 c2                	mov    %eax,%edx
  8015a0:	83 c4 10             	add    $0x10,%esp
  8015a3:	eb 05                	jmp    8015aa <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8015a5:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8015aa:	89 d0                	mov    %edx,%eax
  8015ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8015b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015bc:	b8 08 00 00 00       	mov    $0x8,%eax
  8015c1:	e8 83 fd ff ff       	call   801349 <fsipc>
}
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8015c8:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8015cc:	7e 37                	jle    801605 <writebuf+0x3d>
};


static void
writebuf(struct printbuf *b)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	53                   	push   %ebx
  8015d2:	83 ec 08             	sub    $0x8,%esp
  8015d5:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
		ssize_t result = write(b->fd, b->buf, b->idx);
  8015d7:	ff 70 04             	pushl  0x4(%eax)
  8015da:	8d 40 10             	lea    0x10(%eax),%eax
  8015dd:	50                   	push   %eax
  8015de:	ff 33                	pushl  (%ebx)
  8015e0:	e8 6b fb ff ff       	call   801150 <write>
		if (result > 0)
  8015e5:	83 c4 10             	add    $0x10,%esp
  8015e8:	85 c0                	test   %eax,%eax
  8015ea:	7e 03                	jle    8015ef <writebuf+0x27>
			b->result += result;
  8015ec:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8015ef:	3b 43 04             	cmp    0x4(%ebx),%eax
  8015f2:	74 0d                	je     801601 <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  8015f4:	85 c0                	test   %eax,%eax
  8015f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fb:	0f 4f c2             	cmovg  %edx,%eax
  8015fe:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801601:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801604:	c9                   	leave  
  801605:	f3 c3                	repz ret 

00801607 <putch>:

static void
putch(int ch, void *thunk)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	53                   	push   %ebx
  80160b:	83 ec 04             	sub    $0x4,%esp
  80160e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801611:	8b 53 04             	mov    0x4(%ebx),%edx
  801614:	8d 42 01             	lea    0x1(%edx),%eax
  801617:	89 43 04             	mov    %eax,0x4(%ebx)
  80161a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80161d:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801621:	3d 00 01 00 00       	cmp    $0x100,%eax
  801626:	75 0e                	jne    801636 <putch+0x2f>
		writebuf(b);
  801628:	89 d8                	mov    %ebx,%eax
  80162a:	e8 99 ff ff ff       	call   8015c8 <writebuf>
		b->idx = 0;
  80162f:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801636:	83 c4 04             	add    $0x4,%esp
  801639:	5b                   	pop    %ebx
  80163a:	5d                   	pop    %ebp
  80163b:	c3                   	ret    

0080163c <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801645:	8b 45 08             	mov    0x8(%ebp),%eax
  801648:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  80164e:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801655:	00 00 00 
	b.result = 0;
  801658:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80165f:	00 00 00 
	b.error = 1;
  801662:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801669:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80166c:	ff 75 10             	pushl  0x10(%ebp)
  80166f:	ff 75 0c             	pushl  0xc(%ebp)
  801672:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801678:	50                   	push   %eax
  801679:	68 07 16 80 00       	push   $0x801607
  80167e:	e8 a8 ed ff ff       	call   80042b <vprintfmt>
	if (b.idx > 0)
  801683:	83 c4 10             	add    $0x10,%esp
  801686:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  80168d:	7e 0b                	jle    80169a <vfprintf+0x5e>
		writebuf(&b);
  80168f:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801695:	e8 2e ff ff ff       	call   8015c8 <writebuf>

	return (b.result ? b.result : b.error);
  80169a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8016a0:	85 c0                	test   %eax,%eax
  8016a2:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8016b1:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8016b4:	50                   	push   %eax
  8016b5:	ff 75 0c             	pushl  0xc(%ebp)
  8016b8:	ff 75 08             	pushl  0x8(%ebp)
  8016bb:	e8 7c ff ff ff       	call   80163c <vfprintf>
	va_end(ap);

	return cnt;
}
  8016c0:	c9                   	leave  
  8016c1:	c3                   	ret    

008016c2 <printf>:

int
printf(const char *fmt, ...)
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
  8016c5:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8016c8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8016cb:	50                   	push   %eax
  8016cc:	ff 75 08             	pushl  0x8(%ebp)
  8016cf:	6a 01                	push   $0x1
  8016d1:	e8 66 ff ff ff       	call   80163c <vfprintf>
	va_end(ap);

	return cnt;
}
  8016d6:	c9                   	leave  
  8016d7:	c3                   	ret    

008016d8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
  8016db:	56                   	push   %esi
  8016dc:	53                   	push   %ebx
  8016dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8016e0:	83 ec 0c             	sub    $0xc,%esp
  8016e3:	ff 75 08             	pushl  0x8(%ebp)
  8016e6:	e8 bf f6 ff ff       	call   800daa <fd2data>
  8016eb:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8016ed:	83 c4 08             	add    $0x8,%esp
  8016f0:	68 ef 23 80 00       	push   $0x8023ef
  8016f5:	53                   	push   %ebx
  8016f6:	e8 39 f1 ff ff       	call   800834 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8016fb:	8b 46 04             	mov    0x4(%esi),%eax
  8016fe:	2b 06                	sub    (%esi),%eax
  801700:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801706:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80170d:	00 00 00 
	stat->st_dev = &devpipe;
  801710:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801717:	30 80 00 
	return 0;
}
  80171a:	b8 00 00 00 00       	mov    $0x0,%eax
  80171f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801722:	5b                   	pop    %ebx
  801723:	5e                   	pop    %esi
  801724:	5d                   	pop    %ebp
  801725:	c3                   	ret    

00801726 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	53                   	push   %ebx
  80172a:	83 ec 0c             	sub    $0xc,%esp
  80172d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801730:	53                   	push   %ebx
  801731:	6a 00                	push   $0x0
  801733:	e8 8f f5 ff ff       	call   800cc7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801738:	89 1c 24             	mov    %ebx,(%esp)
  80173b:	e8 6a f6 ff ff       	call   800daa <fd2data>
  801740:	83 c4 08             	add    $0x8,%esp
  801743:	50                   	push   %eax
  801744:	6a 00                	push   $0x0
  801746:	e8 7c f5 ff ff       	call   800cc7 <sys_page_unmap>
}
  80174b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	57                   	push   %edi
  801754:	56                   	push   %esi
  801755:	53                   	push   %ebx
  801756:	83 ec 1c             	sub    $0x1c,%esp
  801759:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80175c:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80175e:	a1 08 40 80 00       	mov    0x804008,%eax
  801763:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801766:	83 ec 0c             	sub    $0xc,%esp
  801769:	ff 75 e0             	pushl  -0x20(%ebp)
  80176c:	e8 3e 05 00 00       	call   801caf <pageref>
  801771:	89 c3                	mov    %eax,%ebx
  801773:	89 3c 24             	mov    %edi,(%esp)
  801776:	e8 34 05 00 00       	call   801caf <pageref>
  80177b:	83 c4 10             	add    $0x10,%esp
  80177e:	39 c3                	cmp    %eax,%ebx
  801780:	0f 94 c1             	sete   %cl
  801783:	0f b6 c9             	movzbl %cl,%ecx
  801786:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801789:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80178f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801792:	39 ce                	cmp    %ecx,%esi
  801794:	74 1b                	je     8017b1 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801796:	39 c3                	cmp    %eax,%ebx
  801798:	75 c4                	jne    80175e <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80179a:	8b 42 58             	mov    0x58(%edx),%eax
  80179d:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017a0:	50                   	push   %eax
  8017a1:	56                   	push   %esi
  8017a2:	68 f6 23 80 00       	push   $0x8023f6
  8017a7:	e8 16 eb ff ff       	call   8002c2 <cprintf>
  8017ac:	83 c4 10             	add    $0x10,%esp
  8017af:	eb ad                	jmp    80175e <_pipeisclosed+0xe>
	}
}
  8017b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017b7:	5b                   	pop    %ebx
  8017b8:	5e                   	pop    %esi
  8017b9:	5f                   	pop    %edi
  8017ba:	5d                   	pop    %ebp
  8017bb:	c3                   	ret    

008017bc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	57                   	push   %edi
  8017c0:	56                   	push   %esi
  8017c1:	53                   	push   %ebx
  8017c2:	83 ec 28             	sub    $0x28,%esp
  8017c5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8017c8:	56                   	push   %esi
  8017c9:	e8 dc f5 ff ff       	call   800daa <fd2data>
  8017ce:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8017d0:	83 c4 10             	add    $0x10,%esp
  8017d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8017d8:	eb 4b                	jmp    801825 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8017da:	89 da                	mov    %ebx,%edx
  8017dc:	89 f0                	mov    %esi,%eax
  8017de:	e8 6d ff ff ff       	call   801750 <_pipeisclosed>
  8017e3:	85 c0                	test   %eax,%eax
  8017e5:	75 48                	jne    80182f <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8017e7:	e8 6a f4 ff ff       	call   800c56 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8017ec:	8b 43 04             	mov    0x4(%ebx),%eax
  8017ef:	8b 0b                	mov    (%ebx),%ecx
  8017f1:	8d 51 20             	lea    0x20(%ecx),%edx
  8017f4:	39 d0                	cmp    %edx,%eax
  8017f6:	73 e2                	jae    8017da <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8017f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017fb:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8017ff:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801802:	89 c2                	mov    %eax,%edx
  801804:	c1 fa 1f             	sar    $0x1f,%edx
  801807:	89 d1                	mov    %edx,%ecx
  801809:	c1 e9 1b             	shr    $0x1b,%ecx
  80180c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80180f:	83 e2 1f             	and    $0x1f,%edx
  801812:	29 ca                	sub    %ecx,%edx
  801814:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801818:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80181c:	83 c0 01             	add    $0x1,%eax
  80181f:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801822:	83 c7 01             	add    $0x1,%edi
  801825:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801828:	75 c2                	jne    8017ec <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80182a:	8b 45 10             	mov    0x10(%ebp),%eax
  80182d:	eb 05                	jmp    801834 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80182f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801834:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801837:	5b                   	pop    %ebx
  801838:	5e                   	pop    %esi
  801839:	5f                   	pop    %edi
  80183a:	5d                   	pop    %ebp
  80183b:	c3                   	ret    

0080183c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	57                   	push   %edi
  801840:	56                   	push   %esi
  801841:	53                   	push   %ebx
  801842:	83 ec 18             	sub    $0x18,%esp
  801845:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801848:	57                   	push   %edi
  801849:	e8 5c f5 ff ff       	call   800daa <fd2data>
  80184e:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801850:	83 c4 10             	add    $0x10,%esp
  801853:	bb 00 00 00 00       	mov    $0x0,%ebx
  801858:	eb 3d                	jmp    801897 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80185a:	85 db                	test   %ebx,%ebx
  80185c:	74 04                	je     801862 <devpipe_read+0x26>
				return i;
  80185e:	89 d8                	mov    %ebx,%eax
  801860:	eb 44                	jmp    8018a6 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801862:	89 f2                	mov    %esi,%edx
  801864:	89 f8                	mov    %edi,%eax
  801866:	e8 e5 fe ff ff       	call   801750 <_pipeisclosed>
  80186b:	85 c0                	test   %eax,%eax
  80186d:	75 32                	jne    8018a1 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80186f:	e8 e2 f3 ff ff       	call   800c56 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801874:	8b 06                	mov    (%esi),%eax
  801876:	3b 46 04             	cmp    0x4(%esi),%eax
  801879:	74 df                	je     80185a <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80187b:	99                   	cltd   
  80187c:	c1 ea 1b             	shr    $0x1b,%edx
  80187f:	01 d0                	add    %edx,%eax
  801881:	83 e0 1f             	and    $0x1f,%eax
  801884:	29 d0                	sub    %edx,%eax
  801886:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  80188b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80188e:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801891:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801894:	83 c3 01             	add    $0x1,%ebx
  801897:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  80189a:	75 d8                	jne    801874 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80189c:	8b 45 10             	mov    0x10(%ebp),%eax
  80189f:	eb 05                	jmp    8018a6 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8018a1:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8018a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018a9:	5b                   	pop    %ebx
  8018aa:	5e                   	pop    %esi
  8018ab:	5f                   	pop    %edi
  8018ac:	5d                   	pop    %ebp
  8018ad:	c3                   	ret    

008018ae <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	56                   	push   %esi
  8018b2:	53                   	push   %ebx
  8018b3:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8018b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b9:	50                   	push   %eax
  8018ba:	e8 03 f5 ff ff       	call   800dc2 <fd_alloc>
  8018bf:	83 c4 10             	add    $0x10,%esp
  8018c2:	89 c2                	mov    %eax,%edx
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	0f 88 2c 01 00 00    	js     8019f8 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018cc:	83 ec 04             	sub    $0x4,%esp
  8018cf:	68 07 04 00 00       	push   $0x407
  8018d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8018d7:	6a 00                	push   $0x0
  8018d9:	e8 9f f3 ff ff       	call   800c7d <sys_page_alloc>
  8018de:	83 c4 10             	add    $0x10,%esp
  8018e1:	89 c2                	mov    %eax,%edx
  8018e3:	85 c0                	test   %eax,%eax
  8018e5:	0f 88 0d 01 00 00    	js     8019f8 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8018eb:	83 ec 0c             	sub    $0xc,%esp
  8018ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018f1:	50                   	push   %eax
  8018f2:	e8 cb f4 ff ff       	call   800dc2 <fd_alloc>
  8018f7:	89 c3                	mov    %eax,%ebx
  8018f9:	83 c4 10             	add    $0x10,%esp
  8018fc:	85 c0                	test   %eax,%eax
  8018fe:	0f 88 e2 00 00 00    	js     8019e6 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801904:	83 ec 04             	sub    $0x4,%esp
  801907:	68 07 04 00 00       	push   $0x407
  80190c:	ff 75 f0             	pushl  -0x10(%ebp)
  80190f:	6a 00                	push   $0x0
  801911:	e8 67 f3 ff ff       	call   800c7d <sys_page_alloc>
  801916:	89 c3                	mov    %eax,%ebx
  801918:	83 c4 10             	add    $0x10,%esp
  80191b:	85 c0                	test   %eax,%eax
  80191d:	0f 88 c3 00 00 00    	js     8019e6 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801923:	83 ec 0c             	sub    $0xc,%esp
  801926:	ff 75 f4             	pushl  -0xc(%ebp)
  801929:	e8 7c f4 ff ff       	call   800daa <fd2data>
  80192e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801930:	83 c4 0c             	add    $0xc,%esp
  801933:	68 07 04 00 00       	push   $0x407
  801938:	50                   	push   %eax
  801939:	6a 00                	push   $0x0
  80193b:	e8 3d f3 ff ff       	call   800c7d <sys_page_alloc>
  801940:	89 c3                	mov    %eax,%ebx
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	85 c0                	test   %eax,%eax
  801947:	0f 88 89 00 00 00    	js     8019d6 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80194d:	83 ec 0c             	sub    $0xc,%esp
  801950:	ff 75 f0             	pushl  -0x10(%ebp)
  801953:	e8 52 f4 ff ff       	call   800daa <fd2data>
  801958:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80195f:	50                   	push   %eax
  801960:	6a 00                	push   $0x0
  801962:	56                   	push   %esi
  801963:	6a 00                	push   $0x0
  801965:	e8 37 f3 ff ff       	call   800ca1 <sys_page_map>
  80196a:	89 c3                	mov    %eax,%ebx
  80196c:	83 c4 20             	add    $0x20,%esp
  80196f:	85 c0                	test   %eax,%eax
  801971:	78 55                	js     8019c8 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801973:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197c:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80197e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801981:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801988:	8b 15 24 30 80 00    	mov    0x803024,%edx
  80198e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801991:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801993:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801996:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80199d:	83 ec 0c             	sub    $0xc,%esp
  8019a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8019a3:	e8 f2 f3 ff ff       	call   800d9a <fd2num>
  8019a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019ab:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8019ad:	83 c4 04             	add    $0x4,%esp
  8019b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8019b3:	e8 e2 f3 ff ff       	call   800d9a <fd2num>
  8019b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019bb:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8019be:	83 c4 10             	add    $0x10,%esp
  8019c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c6:	eb 30                	jmp    8019f8 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  8019c8:	83 ec 08             	sub    $0x8,%esp
  8019cb:	56                   	push   %esi
  8019cc:	6a 00                	push   $0x0
  8019ce:	e8 f4 f2 ff ff       	call   800cc7 <sys_page_unmap>
  8019d3:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  8019d6:	83 ec 08             	sub    $0x8,%esp
  8019d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8019dc:	6a 00                	push   $0x0
  8019de:	e8 e4 f2 ff ff       	call   800cc7 <sys_page_unmap>
  8019e3:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  8019e6:	83 ec 08             	sub    $0x8,%esp
  8019e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ec:	6a 00                	push   $0x0
  8019ee:	e8 d4 f2 ff ff       	call   800cc7 <sys_page_unmap>
  8019f3:	83 c4 10             	add    $0x10,%esp
  8019f6:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  8019f8:	89 d0                	mov    %edx,%eax
  8019fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019fd:	5b                   	pop    %ebx
  8019fe:	5e                   	pop    %esi
  8019ff:	5d                   	pop    %ebp
  801a00:	c3                   	ret    

00801a01 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a07:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a0a:	50                   	push   %eax
  801a0b:	ff 75 08             	pushl  0x8(%ebp)
  801a0e:	e8 fe f3 ff ff       	call   800e11 <fd_lookup>
  801a13:	83 c4 10             	add    $0x10,%esp
  801a16:	85 c0                	test   %eax,%eax
  801a18:	78 18                	js     801a32 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801a1a:	83 ec 0c             	sub    $0xc,%esp
  801a1d:	ff 75 f4             	pushl  -0xc(%ebp)
  801a20:	e8 85 f3 ff ff       	call   800daa <fd2data>
	return _pipeisclosed(fd, p);
  801a25:	89 c2                	mov    %eax,%edx
  801a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a2a:	e8 21 fd ff ff       	call   801750 <_pipeisclosed>
  801a2f:	83 c4 10             	add    $0x10,%esp
}
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801a37:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3c:	5d                   	pop    %ebp
  801a3d:	c3                   	ret    

00801a3e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
  801a41:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801a44:	68 0e 24 80 00       	push   $0x80240e
  801a49:	ff 75 0c             	pushl  0xc(%ebp)
  801a4c:	e8 e3 ed ff ff       	call   800834 <strcpy>
	return 0;
}
  801a51:	b8 00 00 00 00       	mov    $0x0,%eax
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
  801a5b:	57                   	push   %edi
  801a5c:	56                   	push   %esi
  801a5d:	53                   	push   %ebx
  801a5e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801a64:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801a69:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801a6f:	eb 2d                	jmp    801a9e <devcons_write+0x46>
		m = n - tot;
  801a71:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801a74:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801a76:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801a79:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801a7e:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801a81:	83 ec 04             	sub    $0x4,%esp
  801a84:	53                   	push   %ebx
  801a85:	03 45 0c             	add    0xc(%ebp),%eax
  801a88:	50                   	push   %eax
  801a89:	57                   	push   %edi
  801a8a:	e8 38 ef ff ff       	call   8009c7 <memmove>
		sys_cputs(buf, m);
  801a8f:	83 c4 08             	add    $0x8,%esp
  801a92:	53                   	push   %ebx
  801a93:	57                   	push   %edi
  801a94:	e8 2d f1 ff ff       	call   800bc6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801a99:	01 de                	add    %ebx,%esi
  801a9b:	83 c4 10             	add    $0x10,%esp
  801a9e:	89 f0                	mov    %esi,%eax
  801aa0:	3b 75 10             	cmp    0x10(%ebp),%esi
  801aa3:	72 cc                	jb     801a71 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801aa5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aa8:	5b                   	pop    %ebx
  801aa9:	5e                   	pop    %esi
  801aaa:	5f                   	pop    %edi
  801aab:	5d                   	pop    %ebp
  801aac:	c3                   	ret    

00801aad <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
  801ab0:	83 ec 08             	sub    $0x8,%esp
  801ab3:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801ab8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801abc:	74 2a                	je     801ae8 <devcons_read+0x3b>
  801abe:	eb 05                	jmp    801ac5 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801ac0:	e8 91 f1 ff ff       	call   800c56 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801ac5:	e8 22 f1 ff ff       	call   800bec <sys_cgetc>
  801aca:	85 c0                	test   %eax,%eax
  801acc:	74 f2                	je     801ac0 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801ace:	85 c0                	test   %eax,%eax
  801ad0:	78 16                	js     801ae8 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801ad2:	83 f8 04             	cmp    $0x4,%eax
  801ad5:	74 0c                	je     801ae3 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801ad7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ada:	88 02                	mov    %al,(%edx)
	return 1;
  801adc:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae1:	eb 05                	jmp    801ae8 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801ae3:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
  801aed:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801af0:	8b 45 08             	mov    0x8(%ebp),%eax
  801af3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801af6:	6a 01                	push   $0x1
  801af8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801afb:	50                   	push   %eax
  801afc:	e8 c5 f0 ff ff       	call   800bc6 <sys_cputs>
}
  801b01:	83 c4 10             	add    $0x10,%esp
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <getchar>:

int
getchar(void)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
  801b09:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801b0c:	6a 01                	push   $0x1
  801b0e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b11:	50                   	push   %eax
  801b12:	6a 00                	push   $0x0
  801b14:	e8 5d f5 ff ff       	call   801076 <read>
	if (r < 0)
  801b19:	83 c4 10             	add    $0x10,%esp
  801b1c:	85 c0                	test   %eax,%eax
  801b1e:	78 0f                	js     801b2f <getchar+0x29>
		return r;
	if (r < 1)
  801b20:	85 c0                	test   %eax,%eax
  801b22:	7e 06                	jle    801b2a <getchar+0x24>
		return -E_EOF;
	return c;
  801b24:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801b28:	eb 05                	jmp    801b2f <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801b2a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b37:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b3a:	50                   	push   %eax
  801b3b:	ff 75 08             	pushl  0x8(%ebp)
  801b3e:	e8 ce f2 ff ff       	call   800e11 <fd_lookup>
  801b43:	83 c4 10             	add    $0x10,%esp
  801b46:	85 c0                	test   %eax,%eax
  801b48:	78 11                	js     801b5b <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4d:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801b53:	39 10                	cmp    %edx,(%eax)
  801b55:	0f 94 c0             	sete   %al
  801b58:	0f b6 c0             	movzbl %al,%eax
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <opencons>:

int
opencons(void)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801b63:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b66:	50                   	push   %eax
  801b67:	e8 56 f2 ff ff       	call   800dc2 <fd_alloc>
  801b6c:	83 c4 10             	add    $0x10,%esp
		return r;
  801b6f:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801b71:	85 c0                	test   %eax,%eax
  801b73:	78 3e                	js     801bb3 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801b75:	83 ec 04             	sub    $0x4,%esp
  801b78:	68 07 04 00 00       	push   $0x407
  801b7d:	ff 75 f4             	pushl  -0xc(%ebp)
  801b80:	6a 00                	push   $0x0
  801b82:	e8 f6 f0 ff ff       	call   800c7d <sys_page_alloc>
  801b87:	83 c4 10             	add    $0x10,%esp
		return r;
  801b8a:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801b8c:	85 c0                	test   %eax,%eax
  801b8e:	78 23                	js     801bb3 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801b90:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b99:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b9e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801ba5:	83 ec 0c             	sub    $0xc,%esp
  801ba8:	50                   	push   %eax
  801ba9:	e8 ec f1 ff ff       	call   800d9a <fd2num>
  801bae:	89 c2                	mov    %eax,%edx
  801bb0:	83 c4 10             	add    $0x10,%esp
}
  801bb3:	89 d0                	mov    %edx,%eax
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	56                   	push   %esi
  801bbb:	53                   	push   %ebx
  801bbc:	8b 75 08             	mov    0x8(%ebp),%esi
  801bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801bc5:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801bc7:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801bcc:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801bcf:	83 ec 0c             	sub    $0xc,%esp
  801bd2:	50                   	push   %eax
  801bd3:	e8 a0 f1 ff ff       	call   800d78 <sys_ipc_recv>
	if (from_env_store)
  801bd8:	83 c4 10             	add    $0x10,%esp
  801bdb:	85 f6                	test   %esi,%esi
  801bdd:	74 0b                	je     801bea <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801bdf:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801be5:	8b 52 74             	mov    0x74(%edx),%edx
  801be8:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801bea:	85 db                	test   %ebx,%ebx
  801bec:	74 0b                	je     801bf9 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  801bee:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801bf4:	8b 52 78             	mov    0x78(%edx),%edx
  801bf7:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  801bf9:	85 c0                	test   %eax,%eax
  801bfb:	79 16                	jns    801c13 <ipc_recv+0x5c>
		if (from_env_store)
  801bfd:	85 f6                	test   %esi,%esi
  801bff:	74 06                	je     801c07 <ipc_recv+0x50>
			*from_env_store = 0;
  801c01:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  801c07:	85 db                	test   %ebx,%ebx
  801c09:	74 10                	je     801c1b <ipc_recv+0x64>
			*perm_store = 0;
  801c0b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801c11:	eb 08                	jmp    801c1b <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  801c13:	a1 08 40 80 00       	mov    0x804008,%eax
  801c18:	8b 40 70             	mov    0x70(%eax),%eax
}
  801c1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c1e:	5b                   	pop    %ebx
  801c1f:	5e                   	pop    %esi
  801c20:	5d                   	pop    %ebp
  801c21:	c3                   	ret    

00801c22 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	57                   	push   %edi
  801c26:	56                   	push   %esi
  801c27:	53                   	push   %ebx
  801c28:	83 ec 0c             	sub    $0xc,%esp
  801c2b:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c2e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c31:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  801c34:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  801c36:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801c3b:	0f 44 d8             	cmove  %eax,%ebx
  801c3e:	eb 1c                	jmp    801c5c <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  801c40:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c43:	74 12                	je     801c57 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801c45:	50                   	push   %eax
  801c46:	68 1a 24 80 00       	push   $0x80241a
  801c4b:	6a 42                	push   $0x42
  801c4d:	68 30 24 80 00       	push   $0x802430
  801c52:	e8 92 e5 ff ff       	call   8001e9 <_panic>
		sys_yield();
  801c57:	e8 fa ef ff ff       	call   800c56 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801c5c:	ff 75 14             	pushl  0x14(%ebp)
  801c5f:	53                   	push   %ebx
  801c60:	56                   	push   %esi
  801c61:	57                   	push   %edi
  801c62:	e8 ec f0 ff ff       	call   800d53 <sys_ipc_try_send>
  801c67:	83 c4 10             	add    $0x10,%esp
  801c6a:	85 c0                	test   %eax,%eax
  801c6c:	75 d2                	jne    801c40 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801c6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c71:	5b                   	pop    %ebx
  801c72:	5e                   	pop    %esi
  801c73:	5f                   	pop    %edi
  801c74:	5d                   	pop    %ebp
  801c75:	c3                   	ret    

00801c76 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c7c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c81:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c84:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801c8a:	8b 52 50             	mov    0x50(%edx),%edx
  801c8d:	39 ca                	cmp    %ecx,%edx
  801c8f:	75 0d                	jne    801c9e <ipc_find_env+0x28>
			return envs[i].env_id;
  801c91:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c94:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c99:	8b 40 48             	mov    0x48(%eax),%eax
  801c9c:	eb 0f                	jmp    801cad <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801c9e:	83 c0 01             	add    $0x1,%eax
  801ca1:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ca6:	75 d9                	jne    801c81 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801ca8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cad:	5d                   	pop    %ebp
  801cae:	c3                   	ret    

00801caf <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
  801cb2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801cb5:	89 d0                	mov    %edx,%eax
  801cb7:	c1 e8 16             	shr    $0x16,%eax
  801cba:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801cc1:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801cc6:	f6 c1 01             	test   $0x1,%cl
  801cc9:	74 1d                	je     801ce8 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801ccb:	c1 ea 0c             	shr    $0xc,%edx
  801cce:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801cd5:	f6 c2 01             	test   $0x1,%dl
  801cd8:	74 0e                	je     801ce8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801cda:	c1 ea 0c             	shr    $0xc,%edx
  801cdd:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801ce4:	ef 
  801ce5:	0f b7 c0             	movzwl %ax,%eax
}
  801ce8:	5d                   	pop    %ebp
  801ce9:	c3                   	ret    
  801cea:	66 90                	xchg   %ax,%ax
  801cec:	66 90                	xchg   %ax,%ax
  801cee:	66 90                	xchg   %ax,%ax

00801cf0 <__udivdi3>:
  801cf0:	55                   	push   %ebp
  801cf1:	57                   	push   %edi
  801cf2:	56                   	push   %esi
  801cf3:	53                   	push   %ebx
  801cf4:	83 ec 1c             	sub    $0x1c,%esp
  801cf7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801cfb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801cff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d07:	85 f6                	test   %esi,%esi
  801d09:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d0d:	89 ca                	mov    %ecx,%edx
  801d0f:	89 f8                	mov    %edi,%eax
  801d11:	75 3d                	jne    801d50 <__udivdi3+0x60>
  801d13:	39 cf                	cmp    %ecx,%edi
  801d15:	0f 87 c5 00 00 00    	ja     801de0 <__udivdi3+0xf0>
  801d1b:	85 ff                	test   %edi,%edi
  801d1d:	89 fd                	mov    %edi,%ebp
  801d1f:	75 0b                	jne    801d2c <__udivdi3+0x3c>
  801d21:	b8 01 00 00 00       	mov    $0x1,%eax
  801d26:	31 d2                	xor    %edx,%edx
  801d28:	f7 f7                	div    %edi
  801d2a:	89 c5                	mov    %eax,%ebp
  801d2c:	89 c8                	mov    %ecx,%eax
  801d2e:	31 d2                	xor    %edx,%edx
  801d30:	f7 f5                	div    %ebp
  801d32:	89 c1                	mov    %eax,%ecx
  801d34:	89 d8                	mov    %ebx,%eax
  801d36:	89 cf                	mov    %ecx,%edi
  801d38:	f7 f5                	div    %ebp
  801d3a:	89 c3                	mov    %eax,%ebx
  801d3c:	89 d8                	mov    %ebx,%eax
  801d3e:	89 fa                	mov    %edi,%edx
  801d40:	83 c4 1c             	add    $0x1c,%esp
  801d43:	5b                   	pop    %ebx
  801d44:	5e                   	pop    %esi
  801d45:	5f                   	pop    %edi
  801d46:	5d                   	pop    %ebp
  801d47:	c3                   	ret    
  801d48:	90                   	nop
  801d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d50:	39 ce                	cmp    %ecx,%esi
  801d52:	77 74                	ja     801dc8 <__udivdi3+0xd8>
  801d54:	0f bd fe             	bsr    %esi,%edi
  801d57:	83 f7 1f             	xor    $0x1f,%edi
  801d5a:	0f 84 98 00 00 00    	je     801df8 <__udivdi3+0x108>
  801d60:	bb 20 00 00 00       	mov    $0x20,%ebx
  801d65:	89 f9                	mov    %edi,%ecx
  801d67:	89 c5                	mov    %eax,%ebp
  801d69:	29 fb                	sub    %edi,%ebx
  801d6b:	d3 e6                	shl    %cl,%esi
  801d6d:	89 d9                	mov    %ebx,%ecx
  801d6f:	d3 ed                	shr    %cl,%ebp
  801d71:	89 f9                	mov    %edi,%ecx
  801d73:	d3 e0                	shl    %cl,%eax
  801d75:	09 ee                	or     %ebp,%esi
  801d77:	89 d9                	mov    %ebx,%ecx
  801d79:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d7d:	89 d5                	mov    %edx,%ebp
  801d7f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d83:	d3 ed                	shr    %cl,%ebp
  801d85:	89 f9                	mov    %edi,%ecx
  801d87:	d3 e2                	shl    %cl,%edx
  801d89:	89 d9                	mov    %ebx,%ecx
  801d8b:	d3 e8                	shr    %cl,%eax
  801d8d:	09 c2                	or     %eax,%edx
  801d8f:	89 d0                	mov    %edx,%eax
  801d91:	89 ea                	mov    %ebp,%edx
  801d93:	f7 f6                	div    %esi
  801d95:	89 d5                	mov    %edx,%ebp
  801d97:	89 c3                	mov    %eax,%ebx
  801d99:	f7 64 24 0c          	mull   0xc(%esp)
  801d9d:	39 d5                	cmp    %edx,%ebp
  801d9f:	72 10                	jb     801db1 <__udivdi3+0xc1>
  801da1:	8b 74 24 08          	mov    0x8(%esp),%esi
  801da5:	89 f9                	mov    %edi,%ecx
  801da7:	d3 e6                	shl    %cl,%esi
  801da9:	39 c6                	cmp    %eax,%esi
  801dab:	73 07                	jae    801db4 <__udivdi3+0xc4>
  801dad:	39 d5                	cmp    %edx,%ebp
  801daf:	75 03                	jne    801db4 <__udivdi3+0xc4>
  801db1:	83 eb 01             	sub    $0x1,%ebx
  801db4:	31 ff                	xor    %edi,%edi
  801db6:	89 d8                	mov    %ebx,%eax
  801db8:	89 fa                	mov    %edi,%edx
  801dba:	83 c4 1c             	add    $0x1c,%esp
  801dbd:	5b                   	pop    %ebx
  801dbe:	5e                   	pop    %esi
  801dbf:	5f                   	pop    %edi
  801dc0:	5d                   	pop    %ebp
  801dc1:	c3                   	ret    
  801dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801dc8:	31 ff                	xor    %edi,%edi
  801dca:	31 db                	xor    %ebx,%ebx
  801dcc:	89 d8                	mov    %ebx,%eax
  801dce:	89 fa                	mov    %edi,%edx
  801dd0:	83 c4 1c             	add    $0x1c,%esp
  801dd3:	5b                   	pop    %ebx
  801dd4:	5e                   	pop    %esi
  801dd5:	5f                   	pop    %edi
  801dd6:	5d                   	pop    %ebp
  801dd7:	c3                   	ret    
  801dd8:	90                   	nop
  801dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801de0:	89 d8                	mov    %ebx,%eax
  801de2:	f7 f7                	div    %edi
  801de4:	31 ff                	xor    %edi,%edi
  801de6:	89 c3                	mov    %eax,%ebx
  801de8:	89 d8                	mov    %ebx,%eax
  801dea:	89 fa                	mov    %edi,%edx
  801dec:	83 c4 1c             	add    $0x1c,%esp
  801def:	5b                   	pop    %ebx
  801df0:	5e                   	pop    %esi
  801df1:	5f                   	pop    %edi
  801df2:	5d                   	pop    %ebp
  801df3:	c3                   	ret    
  801df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801df8:	39 ce                	cmp    %ecx,%esi
  801dfa:	72 0c                	jb     801e08 <__udivdi3+0x118>
  801dfc:	31 db                	xor    %ebx,%ebx
  801dfe:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801e02:	0f 87 34 ff ff ff    	ja     801d3c <__udivdi3+0x4c>
  801e08:	bb 01 00 00 00       	mov    $0x1,%ebx
  801e0d:	e9 2a ff ff ff       	jmp    801d3c <__udivdi3+0x4c>
  801e12:	66 90                	xchg   %ax,%ax
  801e14:	66 90                	xchg   %ax,%ax
  801e16:	66 90                	xchg   %ax,%ax
  801e18:	66 90                	xchg   %ax,%ax
  801e1a:	66 90                	xchg   %ax,%ax
  801e1c:	66 90                	xchg   %ax,%ax
  801e1e:	66 90                	xchg   %ax,%ax

00801e20 <__umoddi3>:
  801e20:	55                   	push   %ebp
  801e21:	57                   	push   %edi
  801e22:	56                   	push   %esi
  801e23:	53                   	push   %ebx
  801e24:	83 ec 1c             	sub    $0x1c,%esp
  801e27:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801e2b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e37:	85 d2                	test   %edx,%edx
  801e39:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e41:	89 f3                	mov    %esi,%ebx
  801e43:	89 3c 24             	mov    %edi,(%esp)
  801e46:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e4a:	75 1c                	jne    801e68 <__umoddi3+0x48>
  801e4c:	39 f7                	cmp    %esi,%edi
  801e4e:	76 50                	jbe    801ea0 <__umoddi3+0x80>
  801e50:	89 c8                	mov    %ecx,%eax
  801e52:	89 f2                	mov    %esi,%edx
  801e54:	f7 f7                	div    %edi
  801e56:	89 d0                	mov    %edx,%eax
  801e58:	31 d2                	xor    %edx,%edx
  801e5a:	83 c4 1c             	add    $0x1c,%esp
  801e5d:	5b                   	pop    %ebx
  801e5e:	5e                   	pop    %esi
  801e5f:	5f                   	pop    %edi
  801e60:	5d                   	pop    %ebp
  801e61:	c3                   	ret    
  801e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e68:	39 f2                	cmp    %esi,%edx
  801e6a:	89 d0                	mov    %edx,%eax
  801e6c:	77 52                	ja     801ec0 <__umoddi3+0xa0>
  801e6e:	0f bd ea             	bsr    %edx,%ebp
  801e71:	83 f5 1f             	xor    $0x1f,%ebp
  801e74:	75 5a                	jne    801ed0 <__umoddi3+0xb0>
  801e76:	3b 54 24 04          	cmp    0x4(%esp),%edx
  801e7a:	0f 82 e0 00 00 00    	jb     801f60 <__umoddi3+0x140>
  801e80:	39 0c 24             	cmp    %ecx,(%esp)
  801e83:	0f 86 d7 00 00 00    	jbe    801f60 <__umoddi3+0x140>
  801e89:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e8d:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e91:	83 c4 1c             	add    $0x1c,%esp
  801e94:	5b                   	pop    %ebx
  801e95:	5e                   	pop    %esi
  801e96:	5f                   	pop    %edi
  801e97:	5d                   	pop    %ebp
  801e98:	c3                   	ret    
  801e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ea0:	85 ff                	test   %edi,%edi
  801ea2:	89 fd                	mov    %edi,%ebp
  801ea4:	75 0b                	jne    801eb1 <__umoddi3+0x91>
  801ea6:	b8 01 00 00 00       	mov    $0x1,%eax
  801eab:	31 d2                	xor    %edx,%edx
  801ead:	f7 f7                	div    %edi
  801eaf:	89 c5                	mov    %eax,%ebp
  801eb1:	89 f0                	mov    %esi,%eax
  801eb3:	31 d2                	xor    %edx,%edx
  801eb5:	f7 f5                	div    %ebp
  801eb7:	89 c8                	mov    %ecx,%eax
  801eb9:	f7 f5                	div    %ebp
  801ebb:	89 d0                	mov    %edx,%eax
  801ebd:	eb 99                	jmp    801e58 <__umoddi3+0x38>
  801ebf:	90                   	nop
  801ec0:	89 c8                	mov    %ecx,%eax
  801ec2:	89 f2                	mov    %esi,%edx
  801ec4:	83 c4 1c             	add    $0x1c,%esp
  801ec7:	5b                   	pop    %ebx
  801ec8:	5e                   	pop    %esi
  801ec9:	5f                   	pop    %edi
  801eca:	5d                   	pop    %ebp
  801ecb:	c3                   	ret    
  801ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ed0:	8b 34 24             	mov    (%esp),%esi
  801ed3:	bf 20 00 00 00       	mov    $0x20,%edi
  801ed8:	89 e9                	mov    %ebp,%ecx
  801eda:	29 ef                	sub    %ebp,%edi
  801edc:	d3 e0                	shl    %cl,%eax
  801ede:	89 f9                	mov    %edi,%ecx
  801ee0:	89 f2                	mov    %esi,%edx
  801ee2:	d3 ea                	shr    %cl,%edx
  801ee4:	89 e9                	mov    %ebp,%ecx
  801ee6:	09 c2                	or     %eax,%edx
  801ee8:	89 d8                	mov    %ebx,%eax
  801eea:	89 14 24             	mov    %edx,(%esp)
  801eed:	89 f2                	mov    %esi,%edx
  801eef:	d3 e2                	shl    %cl,%edx
  801ef1:	89 f9                	mov    %edi,%ecx
  801ef3:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ef7:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801efb:	d3 e8                	shr    %cl,%eax
  801efd:	89 e9                	mov    %ebp,%ecx
  801eff:	89 c6                	mov    %eax,%esi
  801f01:	d3 e3                	shl    %cl,%ebx
  801f03:	89 f9                	mov    %edi,%ecx
  801f05:	89 d0                	mov    %edx,%eax
  801f07:	d3 e8                	shr    %cl,%eax
  801f09:	89 e9                	mov    %ebp,%ecx
  801f0b:	09 d8                	or     %ebx,%eax
  801f0d:	89 d3                	mov    %edx,%ebx
  801f0f:	89 f2                	mov    %esi,%edx
  801f11:	f7 34 24             	divl   (%esp)
  801f14:	89 d6                	mov    %edx,%esi
  801f16:	d3 e3                	shl    %cl,%ebx
  801f18:	f7 64 24 04          	mull   0x4(%esp)
  801f1c:	39 d6                	cmp    %edx,%esi
  801f1e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f22:	89 d1                	mov    %edx,%ecx
  801f24:	89 c3                	mov    %eax,%ebx
  801f26:	72 08                	jb     801f30 <__umoddi3+0x110>
  801f28:	75 11                	jne    801f3b <__umoddi3+0x11b>
  801f2a:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801f2e:	73 0b                	jae    801f3b <__umoddi3+0x11b>
  801f30:	2b 44 24 04          	sub    0x4(%esp),%eax
  801f34:	1b 14 24             	sbb    (%esp),%edx
  801f37:	89 d1                	mov    %edx,%ecx
  801f39:	89 c3                	mov    %eax,%ebx
  801f3b:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f3f:	29 da                	sub    %ebx,%edx
  801f41:	19 ce                	sbb    %ecx,%esi
  801f43:	89 f9                	mov    %edi,%ecx
  801f45:	89 f0                	mov    %esi,%eax
  801f47:	d3 e0                	shl    %cl,%eax
  801f49:	89 e9                	mov    %ebp,%ecx
  801f4b:	d3 ea                	shr    %cl,%edx
  801f4d:	89 e9                	mov    %ebp,%ecx
  801f4f:	d3 ee                	shr    %cl,%esi
  801f51:	09 d0                	or     %edx,%eax
  801f53:	89 f2                	mov    %esi,%edx
  801f55:	83 c4 1c             	add    $0x1c,%esp
  801f58:	5b                   	pop    %ebx
  801f59:	5e                   	pop    %esi
  801f5a:	5f                   	pop    %edi
  801f5b:	5d                   	pop    %ebp
  801f5c:	c3                   	ret    
  801f5d:	8d 76 00             	lea    0x0(%esi),%esi
  801f60:	29 f9                	sub    %edi,%ecx
  801f62:	19 d6                	sbb    %edx,%esi
  801f64:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f68:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f6c:	e9 18 ff ff ff       	jmp    801e89 <__umoddi3+0x69>
