
obj/user/testfdsharing.debug:     formato del fichero elf32-i386


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
  80002c:	e8 91 01 00 00       	call   8001c2 <libmain>
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

00800039 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800039:	55                   	push   %ebp
  80003a:	89 e5                	mov    %esp,%ebp
  80003c:	57                   	push   %edi
  80003d:	56                   	push   %esi
  80003e:	53                   	push   %ebx
  80003f:	83 ec 14             	sub    $0x14,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  800042:	6a 00                	push   $0x0
  800044:	68 40 24 80 00       	push   $0x802440
  800049:	e8 ca 19 00 00       	call   801a18 <open>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	79 12                	jns    800069 <umain+0x30>
		panic("open motd: %e", fd);
  800057:	50                   	push   %eax
  800058:	68 45 24 80 00       	push   $0x802445
  80005d:	6a 0c                	push   $0xc
  80005f:	68 53 24 80 00       	push   $0x802453
  800064:	e8 bd 01 00 00       	call   800226 <_panic>
	seek(fd, 0);
  800069:	83 ec 08             	sub    $0x8,%esp
  80006c:	6a 00                	push   $0x0
  80006e:	50                   	push   %eax
  80006f:	e8 5c 16 00 00       	call   8016d0 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800074:	83 c4 0c             	add    $0xc,%esp
  800077:	68 00 02 00 00       	push   $0x200
  80007c:	68 20 42 80 00       	push   $0x804220
  800081:	53                   	push   %ebx
  800082:	e8 74 15 00 00       	call   8015fb <readn>
  800087:	89 c6                	mov    %eax,%esi
  800089:	83 c4 10             	add    $0x10,%esp
  80008c:	85 c0                	test   %eax,%eax
  80008e:	7f 12                	jg     8000a2 <umain+0x69>
		panic("readn: %e", n);
  800090:	50                   	push   %eax
  800091:	68 68 24 80 00       	push   $0x802468
  800096:	6a 0f                	push   $0xf
  800098:	68 53 24 80 00       	push   $0x802453
  80009d:	e8 84 01 00 00       	call   800226 <_panic>

	if ((r = fork()) < 0)
  8000a2:	e8 ba 10 00 00       	call   801161 <fork>
  8000a7:	89 c7                	mov    %eax,%edi
  8000a9:	85 c0                	test   %eax,%eax
  8000ab:	79 12                	jns    8000bf <umain+0x86>
		panic("fork: %e", r);
  8000ad:	50                   	push   %eax
  8000ae:	68 b0 29 80 00       	push   $0x8029b0
  8000b3:	6a 12                	push   $0x12
  8000b5:	68 53 24 80 00       	push   $0x802453
  8000ba:	e8 67 01 00 00       	call   800226 <_panic>
	if (r == 0) {
  8000bf:	85 c0                	test   %eax,%eax
  8000c1:	0f 85 9d 00 00 00    	jne    800164 <umain+0x12b>
		seek(fd, 0);
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	6a 00                	push   $0x0
  8000cc:	53                   	push   %ebx
  8000cd:	e8 fe 15 00 00       	call   8016d0 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  8000d2:	c7 04 24 a8 24 80 00 	movl   $0x8024a8,(%esp)
  8000d9:	e8 21 02 00 00       	call   8002ff <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000de:	83 c4 0c             	add    $0xc,%esp
  8000e1:	68 00 02 00 00       	push   $0x200
  8000e6:	68 20 40 80 00       	push   $0x804020
  8000eb:	53                   	push   %ebx
  8000ec:	e8 0a 15 00 00       	call   8015fb <readn>
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	39 c6                	cmp    %eax,%esi
  8000f6:	74 16                	je     80010e <umain+0xd5>
			panic("read in parent got %d, read in child got %d", n, n2);
  8000f8:	83 ec 0c             	sub    $0xc,%esp
  8000fb:	50                   	push   %eax
  8000fc:	56                   	push   %esi
  8000fd:	68 ec 24 80 00       	push   $0x8024ec
  800102:	6a 17                	push   $0x17
  800104:	68 53 24 80 00       	push   $0x802453
  800109:	e8 18 01 00 00       	call   800226 <_panic>
		if (memcmp(buf, buf2, n) != 0)
  80010e:	83 ec 04             	sub    $0x4,%esp
  800111:	56                   	push   %esi
  800112:	68 20 40 80 00       	push   $0x804020
  800117:	68 20 42 80 00       	push   $0x804220
  80011c:	e8 5e 09 00 00       	call   800a7f <memcmp>
  800121:	83 c4 10             	add    $0x10,%esp
  800124:	85 c0                	test   %eax,%eax
  800126:	74 14                	je     80013c <umain+0x103>
			panic("read in parent got different bytes from read in child");
  800128:	83 ec 04             	sub    $0x4,%esp
  80012b:	68 18 25 80 00       	push   $0x802518
  800130:	6a 19                	push   $0x19
  800132:	68 53 24 80 00       	push   $0x802453
  800137:	e8 ea 00 00 00       	call   800226 <_panic>
		cprintf("read in child succeeded\n");
  80013c:	83 ec 0c             	sub    $0xc,%esp
  80013f:	68 72 24 80 00       	push   $0x802472
  800144:	e8 b6 01 00 00       	call   8002ff <cprintf>
		seek(fd, 0);
  800149:	83 c4 08             	add    $0x8,%esp
  80014c:	6a 00                	push   $0x0
  80014e:	53                   	push   %ebx
  80014f:	e8 7c 15 00 00       	call   8016d0 <seek>
		close(fd);
  800154:	89 1c 24             	mov    %ebx,(%esp)
  800157:	e8 d2 12 00 00       	call   80142e <close>
		exit();
  80015c:	e8 ab 00 00 00       	call   80020c <exit>
  800161:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  800164:	83 ec 0c             	sub    $0xc,%esp
  800167:	57                   	push   %edi
  800168:	e8 ab 1c 00 00       	call   801e18 <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  80016d:	83 c4 0c             	add    $0xc,%esp
  800170:	68 00 02 00 00       	push   $0x200
  800175:	68 20 40 80 00       	push   $0x804020
  80017a:	53                   	push   %ebx
  80017b:	e8 7b 14 00 00       	call   8015fb <readn>
  800180:	83 c4 10             	add    $0x10,%esp
  800183:	39 c6                	cmp    %eax,%esi
  800185:	74 16                	je     80019d <umain+0x164>
		panic("read in parent got %d, then got %d", n, n2);
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	50                   	push   %eax
  80018b:	56                   	push   %esi
  80018c:	68 50 25 80 00       	push   $0x802550
  800191:	6a 21                	push   $0x21
  800193:	68 53 24 80 00       	push   $0x802453
  800198:	e8 89 00 00 00       	call   800226 <_panic>
	cprintf("read in parent succeeded\n");
  80019d:	83 ec 0c             	sub    $0xc,%esp
  8001a0:	68 8b 24 80 00       	push   $0x80248b
  8001a5:	e8 55 01 00 00       	call   8002ff <cprintf>
	close(fd);
  8001aa:	89 1c 24             	mov    %ebx,(%esp)
  8001ad:	e8 7c 12 00 00       	call   80142e <close>

	breakpoint();
  8001b2:	e8 7c fe ff ff       	call   800033 <breakpoint>
}
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001bd:	5b                   	pop    %ebx
  8001be:	5e                   	pop    %esi
  8001bf:	5f                   	pop    %edi
  8001c0:	5d                   	pop    %ebp
  8001c1:	c3                   	ret    

008001c2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001c2:	55                   	push   %ebp
  8001c3:	89 e5                	mov    %esp,%ebp
  8001c5:	56                   	push   %esi
  8001c6:	53                   	push   %ebx
  8001c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001ca:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8001cd:	e8 9d 0a 00 00       	call   800c6f <sys_getenvid>
	if (id >= 0)
  8001d2:	85 c0                	test   %eax,%eax
  8001d4:	78 12                	js     8001e8 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  8001d6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001db:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001de:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001e3:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e8:	85 db                	test   %ebx,%ebx
  8001ea:	7e 07                	jle    8001f3 <libmain+0x31>
		binaryname = argv[0];
  8001ec:	8b 06                	mov    (%esi),%eax
  8001ee:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001f3:	83 ec 08             	sub    $0x8,%esp
  8001f6:	56                   	push   %esi
  8001f7:	53                   	push   %ebx
  8001f8:	e8 3c fe ff ff       	call   800039 <umain>

	// exit gracefully
	exit();
  8001fd:	e8 0a 00 00 00       	call   80020c <exit>
}
  800202:	83 c4 10             	add    $0x10,%esp
  800205:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800208:	5b                   	pop    %ebx
  800209:	5e                   	pop    %esi
  80020a:	5d                   	pop    %ebp
  80020b:	c3                   	ret    

0080020c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800212:	e8 42 12 00 00       	call   801459 <close_all>
	sys_env_destroy(0);
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	6a 00                	push   $0x0
  80021c:	e8 2c 0a 00 00       	call   800c4d <sys_env_destroy>
}
  800221:	83 c4 10             	add    $0x10,%esp
  800224:	c9                   	leave  
  800225:	c3                   	ret    

00800226 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800226:	55                   	push   %ebp
  800227:	89 e5                	mov    %esp,%ebp
  800229:	56                   	push   %esi
  80022a:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80022b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80022e:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800234:	e8 36 0a 00 00       	call   800c6f <sys_getenvid>
  800239:	83 ec 0c             	sub    $0xc,%esp
  80023c:	ff 75 0c             	pushl  0xc(%ebp)
  80023f:	ff 75 08             	pushl  0x8(%ebp)
  800242:	56                   	push   %esi
  800243:	50                   	push   %eax
  800244:	68 80 25 80 00       	push   $0x802580
  800249:	e8 b1 00 00 00       	call   8002ff <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80024e:	83 c4 18             	add    $0x18,%esp
  800251:	53                   	push   %ebx
  800252:	ff 75 10             	pushl  0x10(%ebp)
  800255:	e8 54 00 00 00       	call   8002ae <vcprintf>
	cprintf("\n");
  80025a:	c7 04 24 89 24 80 00 	movl   $0x802489,(%esp)
  800261:	e8 99 00 00 00       	call   8002ff <cprintf>
  800266:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800269:	cc                   	int3   
  80026a:	eb fd                	jmp    800269 <_panic+0x43>

0080026c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	53                   	push   %ebx
  800270:	83 ec 04             	sub    $0x4,%esp
  800273:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800276:	8b 13                	mov    (%ebx),%edx
  800278:	8d 42 01             	lea    0x1(%edx),%eax
  80027b:	89 03                	mov    %eax,(%ebx)
  80027d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800280:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800284:	3d ff 00 00 00       	cmp    $0xff,%eax
  800289:	75 1a                	jne    8002a5 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  80028b:	83 ec 08             	sub    $0x8,%esp
  80028e:	68 ff 00 00 00       	push   $0xff
  800293:	8d 43 08             	lea    0x8(%ebx),%eax
  800296:	50                   	push   %eax
  800297:	e8 67 09 00 00       	call   800c03 <sys_cputs>
		b->idx = 0;
  80029c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002a2:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  8002a5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002ac:	c9                   	leave  
  8002ad:	c3                   	ret    

008002ae <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002ae:	55                   	push   %ebp
  8002af:	89 e5                	mov    %esp,%ebp
  8002b1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002b7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002be:	00 00 00 
	b.cnt = 0;
  8002c1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002c8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002cb:	ff 75 0c             	pushl  0xc(%ebp)
  8002ce:	ff 75 08             	pushl  0x8(%ebp)
  8002d1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d7:	50                   	push   %eax
  8002d8:	68 6c 02 80 00       	push   $0x80026c
  8002dd:	e8 86 01 00 00       	call   800468 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002e2:	83 c4 08             	add    $0x8,%esp
  8002e5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002eb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002f1:	50                   	push   %eax
  8002f2:	e8 0c 09 00 00       	call   800c03 <sys_cputs>

	return b.cnt;
}
  8002f7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002fd:	c9                   	leave  
  8002fe:	c3                   	ret    

008002ff <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
  800302:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800305:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800308:	50                   	push   %eax
  800309:	ff 75 08             	pushl  0x8(%ebp)
  80030c:	e8 9d ff ff ff       	call   8002ae <vcprintf>
	va_end(ap);

	return cnt;
}
  800311:	c9                   	leave  
  800312:	c3                   	ret    

00800313 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	57                   	push   %edi
  800317:	56                   	push   %esi
  800318:	53                   	push   %ebx
  800319:	83 ec 1c             	sub    $0x1c,%esp
  80031c:	89 c7                	mov    %eax,%edi
  80031e:	89 d6                	mov    %edx,%esi
  800320:	8b 45 08             	mov    0x8(%ebp),%eax
  800323:	8b 55 0c             	mov    0xc(%ebp),%edx
  800326:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800329:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80032c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80032f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800334:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800337:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80033a:	39 d3                	cmp    %edx,%ebx
  80033c:	72 05                	jb     800343 <printnum+0x30>
  80033e:	39 45 10             	cmp    %eax,0x10(%ebp)
  800341:	77 45                	ja     800388 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800343:	83 ec 0c             	sub    $0xc,%esp
  800346:	ff 75 18             	pushl  0x18(%ebp)
  800349:	8b 45 14             	mov    0x14(%ebp),%eax
  80034c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80034f:	53                   	push   %ebx
  800350:	ff 75 10             	pushl  0x10(%ebp)
  800353:	83 ec 08             	sub    $0x8,%esp
  800356:	ff 75 e4             	pushl  -0x1c(%ebp)
  800359:	ff 75 e0             	pushl  -0x20(%ebp)
  80035c:	ff 75 dc             	pushl  -0x24(%ebp)
  80035f:	ff 75 d8             	pushl  -0x28(%ebp)
  800362:	e8 49 1e 00 00       	call   8021b0 <__udivdi3>
  800367:	83 c4 18             	add    $0x18,%esp
  80036a:	52                   	push   %edx
  80036b:	50                   	push   %eax
  80036c:	89 f2                	mov    %esi,%edx
  80036e:	89 f8                	mov    %edi,%eax
  800370:	e8 9e ff ff ff       	call   800313 <printnum>
  800375:	83 c4 20             	add    $0x20,%esp
  800378:	eb 18                	jmp    800392 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80037a:	83 ec 08             	sub    $0x8,%esp
  80037d:	56                   	push   %esi
  80037e:	ff 75 18             	pushl  0x18(%ebp)
  800381:	ff d7                	call   *%edi
  800383:	83 c4 10             	add    $0x10,%esp
  800386:	eb 03                	jmp    80038b <printnum+0x78>
  800388:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80038b:	83 eb 01             	sub    $0x1,%ebx
  80038e:	85 db                	test   %ebx,%ebx
  800390:	7f e8                	jg     80037a <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800392:	83 ec 08             	sub    $0x8,%esp
  800395:	56                   	push   %esi
  800396:	83 ec 04             	sub    $0x4,%esp
  800399:	ff 75 e4             	pushl  -0x1c(%ebp)
  80039c:	ff 75 e0             	pushl  -0x20(%ebp)
  80039f:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a2:	ff 75 d8             	pushl  -0x28(%ebp)
  8003a5:	e8 36 1f 00 00       	call   8022e0 <__umoddi3>
  8003aa:	83 c4 14             	add    $0x14,%esp
  8003ad:	0f be 80 a3 25 80 00 	movsbl 0x8025a3(%eax),%eax
  8003b4:	50                   	push   %eax
  8003b5:	ff d7                	call   *%edi
}
  8003b7:	83 c4 10             	add    $0x10,%esp
  8003ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003bd:	5b                   	pop    %ebx
  8003be:	5e                   	pop    %esi
  8003bf:	5f                   	pop    %edi
  8003c0:	5d                   	pop    %ebp
  8003c1:	c3                   	ret    

008003c2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003c5:	83 fa 01             	cmp    $0x1,%edx
  8003c8:	7e 0e                	jle    8003d8 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003ca:	8b 10                	mov    (%eax),%edx
  8003cc:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003cf:	89 08                	mov    %ecx,(%eax)
  8003d1:	8b 02                	mov    (%edx),%eax
  8003d3:	8b 52 04             	mov    0x4(%edx),%edx
  8003d6:	eb 22                	jmp    8003fa <getuint+0x38>
	else if (lflag)
  8003d8:	85 d2                	test   %edx,%edx
  8003da:	74 10                	je     8003ec <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003dc:	8b 10                	mov    (%eax),%edx
  8003de:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003e1:	89 08                	mov    %ecx,(%eax)
  8003e3:	8b 02                	mov    (%edx),%eax
  8003e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ea:	eb 0e                	jmp    8003fa <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003ec:	8b 10                	mov    (%eax),%edx
  8003ee:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003f1:	89 08                	mov    %ecx,(%eax)
  8003f3:	8b 02                	mov    (%edx),%eax
  8003f5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003fa:	5d                   	pop    %ebp
  8003fb:	c3                   	ret    

008003fc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003fc:	55                   	push   %ebp
  8003fd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003ff:	83 fa 01             	cmp    $0x1,%edx
  800402:	7e 0e                	jle    800412 <getint+0x16>
		return va_arg(*ap, long long);
  800404:	8b 10                	mov    (%eax),%edx
  800406:	8d 4a 08             	lea    0x8(%edx),%ecx
  800409:	89 08                	mov    %ecx,(%eax)
  80040b:	8b 02                	mov    (%edx),%eax
  80040d:	8b 52 04             	mov    0x4(%edx),%edx
  800410:	eb 1a                	jmp    80042c <getint+0x30>
	else if (lflag)
  800412:	85 d2                	test   %edx,%edx
  800414:	74 0c                	je     800422 <getint+0x26>
		return va_arg(*ap, long);
  800416:	8b 10                	mov    (%eax),%edx
  800418:	8d 4a 04             	lea    0x4(%edx),%ecx
  80041b:	89 08                	mov    %ecx,(%eax)
  80041d:	8b 02                	mov    (%edx),%eax
  80041f:	99                   	cltd   
  800420:	eb 0a                	jmp    80042c <getint+0x30>
	else
		return va_arg(*ap, int);
  800422:	8b 10                	mov    (%eax),%edx
  800424:	8d 4a 04             	lea    0x4(%edx),%ecx
  800427:	89 08                	mov    %ecx,(%eax)
  800429:	8b 02                	mov    (%edx),%eax
  80042b:	99                   	cltd   
}
  80042c:	5d                   	pop    %ebp
  80042d:	c3                   	ret    

0080042e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800434:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800438:	8b 10                	mov    (%eax),%edx
  80043a:	3b 50 04             	cmp    0x4(%eax),%edx
  80043d:	73 0a                	jae    800449 <sprintputch+0x1b>
		*b->buf++ = ch;
  80043f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800442:	89 08                	mov    %ecx,(%eax)
  800444:	8b 45 08             	mov    0x8(%ebp),%eax
  800447:	88 02                	mov    %al,(%edx)
}
  800449:	5d                   	pop    %ebp
  80044a:	c3                   	ret    

0080044b <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80044b:	55                   	push   %ebp
  80044c:	89 e5                	mov    %esp,%ebp
  80044e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800451:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800454:	50                   	push   %eax
  800455:	ff 75 10             	pushl  0x10(%ebp)
  800458:	ff 75 0c             	pushl  0xc(%ebp)
  80045b:	ff 75 08             	pushl  0x8(%ebp)
  80045e:	e8 05 00 00 00       	call   800468 <vprintfmt>
	va_end(ap);
}
  800463:	83 c4 10             	add    $0x10,%esp
  800466:	c9                   	leave  
  800467:	c3                   	ret    

00800468 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800468:	55                   	push   %ebp
  800469:	89 e5                	mov    %esp,%ebp
  80046b:	57                   	push   %edi
  80046c:	56                   	push   %esi
  80046d:	53                   	push   %ebx
  80046e:	83 ec 2c             	sub    $0x2c,%esp
  800471:	8b 75 08             	mov    0x8(%ebp),%esi
  800474:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800477:	8b 7d 10             	mov    0x10(%ebp),%edi
  80047a:	eb 12                	jmp    80048e <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80047c:	85 c0                	test   %eax,%eax
  80047e:	0f 84 44 03 00 00    	je     8007c8 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	53                   	push   %ebx
  800488:	50                   	push   %eax
  800489:	ff d6                	call   *%esi
  80048b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80048e:	83 c7 01             	add    $0x1,%edi
  800491:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800495:	83 f8 25             	cmp    $0x25,%eax
  800498:	75 e2                	jne    80047c <vprintfmt+0x14>
  80049a:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  80049e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8004a5:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004ac:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8004b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b8:	eb 07                	jmp    8004c1 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8004bd:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004c1:	8d 47 01             	lea    0x1(%edi),%eax
  8004c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004c7:	0f b6 07             	movzbl (%edi),%eax
  8004ca:	0f b6 c8             	movzbl %al,%ecx
  8004cd:	83 e8 23             	sub    $0x23,%eax
  8004d0:	3c 55                	cmp    $0x55,%al
  8004d2:	0f 87 d5 02 00 00    	ja     8007ad <vprintfmt+0x345>
  8004d8:	0f b6 c0             	movzbl %al,%eax
  8004db:	ff 24 85 e0 26 80 00 	jmp    *0x8026e0(,%eax,4)
  8004e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004e5:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8004e9:	eb d6                	jmp    8004c1 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004f6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004f9:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8004fd:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  800500:	8d 51 d0             	lea    -0x30(%ecx),%edx
  800503:	83 fa 09             	cmp    $0x9,%edx
  800506:	77 39                	ja     800541 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800508:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80050b:	eb e9                	jmp    8004f6 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	8d 48 04             	lea    0x4(%eax),%ecx
  800513:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800516:	8b 00                	mov    (%eax),%eax
  800518:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80051b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  80051e:	eb 27                	jmp    800547 <vprintfmt+0xdf>
  800520:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800523:	85 c0                	test   %eax,%eax
  800525:	b9 00 00 00 00       	mov    $0x0,%ecx
  80052a:	0f 49 c8             	cmovns %eax,%ecx
  80052d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800530:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800533:	eb 8c                	jmp    8004c1 <vprintfmt+0x59>
  800535:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800538:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80053f:	eb 80                	jmp    8004c1 <vprintfmt+0x59>
  800541:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800544:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  800547:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80054b:	0f 89 70 ff ff ff    	jns    8004c1 <vprintfmt+0x59>
				width = precision, precision = -1;
  800551:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800554:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800557:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80055e:	e9 5e ff ff ff       	jmp    8004c1 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800563:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800566:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800569:	e9 53 ff ff ff       	jmp    8004c1 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80056e:	8b 45 14             	mov    0x14(%ebp),%eax
  800571:	8d 50 04             	lea    0x4(%eax),%edx
  800574:	89 55 14             	mov    %edx,0x14(%ebp)
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	53                   	push   %ebx
  80057b:	ff 30                	pushl  (%eax)
  80057d:	ff d6                	call   *%esi
			break;
  80057f:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800582:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800585:	e9 04 ff ff ff       	jmp    80048e <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80058a:	8b 45 14             	mov    0x14(%ebp),%eax
  80058d:	8d 50 04             	lea    0x4(%eax),%edx
  800590:	89 55 14             	mov    %edx,0x14(%ebp)
  800593:	8b 00                	mov    (%eax),%eax
  800595:	99                   	cltd   
  800596:	31 d0                	xor    %edx,%eax
  800598:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80059a:	83 f8 0f             	cmp    $0xf,%eax
  80059d:	7f 0b                	jg     8005aa <vprintfmt+0x142>
  80059f:	8b 14 85 40 28 80 00 	mov    0x802840(,%eax,4),%edx
  8005a6:	85 d2                	test   %edx,%edx
  8005a8:	75 18                	jne    8005c2 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  8005aa:	50                   	push   %eax
  8005ab:	68 bb 25 80 00       	push   $0x8025bb
  8005b0:	53                   	push   %ebx
  8005b1:	56                   	push   %esi
  8005b2:	e8 94 fe ff ff       	call   80044b <printfmt>
  8005b7:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8005bd:	e9 cc fe ff ff       	jmp    80048e <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  8005c2:	52                   	push   %edx
  8005c3:	68 d5 2a 80 00       	push   $0x802ad5
  8005c8:	53                   	push   %ebx
  8005c9:	56                   	push   %esi
  8005ca:	e8 7c fe ff ff       	call   80044b <printfmt>
  8005cf:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005d5:	e9 b4 fe ff ff       	jmp    80048e <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005da:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dd:	8d 50 04             	lea    0x4(%eax),%edx
  8005e0:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e3:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8005e5:	85 ff                	test   %edi,%edi
  8005e7:	b8 b4 25 80 00       	mov    $0x8025b4,%eax
  8005ec:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8005ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005f3:	0f 8e 94 00 00 00    	jle    80068d <vprintfmt+0x225>
  8005f9:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8005fd:	0f 84 98 00 00 00    	je     80069b <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  800603:	83 ec 08             	sub    $0x8,%esp
  800606:	ff 75 d0             	pushl  -0x30(%ebp)
  800609:	57                   	push   %edi
  80060a:	e8 41 02 00 00       	call   800850 <strnlen>
  80060f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800612:	29 c1                	sub    %eax,%ecx
  800614:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800617:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80061a:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80061e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800621:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800624:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800626:	eb 0f                	jmp    800637 <vprintfmt+0x1cf>
					putch(padc, putdat);
  800628:	83 ec 08             	sub    $0x8,%esp
  80062b:	53                   	push   %ebx
  80062c:	ff 75 e0             	pushl  -0x20(%ebp)
  80062f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800631:	83 ef 01             	sub    $0x1,%edi
  800634:	83 c4 10             	add    $0x10,%esp
  800637:	85 ff                	test   %edi,%edi
  800639:	7f ed                	jg     800628 <vprintfmt+0x1c0>
  80063b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80063e:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800641:	85 c9                	test   %ecx,%ecx
  800643:	b8 00 00 00 00       	mov    $0x0,%eax
  800648:	0f 49 c1             	cmovns %ecx,%eax
  80064b:	29 c1                	sub    %eax,%ecx
  80064d:	89 75 08             	mov    %esi,0x8(%ebp)
  800650:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800653:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800656:	89 cb                	mov    %ecx,%ebx
  800658:	eb 4d                	jmp    8006a7 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80065a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80065e:	74 1b                	je     80067b <vprintfmt+0x213>
  800660:	0f be c0             	movsbl %al,%eax
  800663:	83 e8 20             	sub    $0x20,%eax
  800666:	83 f8 5e             	cmp    $0x5e,%eax
  800669:	76 10                	jbe    80067b <vprintfmt+0x213>
					putch('?', putdat);
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	ff 75 0c             	pushl  0xc(%ebp)
  800671:	6a 3f                	push   $0x3f
  800673:	ff 55 08             	call   *0x8(%ebp)
  800676:	83 c4 10             	add    $0x10,%esp
  800679:	eb 0d                	jmp    800688 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	ff 75 0c             	pushl  0xc(%ebp)
  800681:	52                   	push   %edx
  800682:	ff 55 08             	call   *0x8(%ebp)
  800685:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800688:	83 eb 01             	sub    $0x1,%ebx
  80068b:	eb 1a                	jmp    8006a7 <vprintfmt+0x23f>
  80068d:	89 75 08             	mov    %esi,0x8(%ebp)
  800690:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800693:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800696:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800699:	eb 0c                	jmp    8006a7 <vprintfmt+0x23f>
  80069b:	89 75 08             	mov    %esi,0x8(%ebp)
  80069e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006a1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006a4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006a7:	83 c7 01             	add    $0x1,%edi
  8006aa:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006ae:	0f be d0             	movsbl %al,%edx
  8006b1:	85 d2                	test   %edx,%edx
  8006b3:	74 23                	je     8006d8 <vprintfmt+0x270>
  8006b5:	85 f6                	test   %esi,%esi
  8006b7:	78 a1                	js     80065a <vprintfmt+0x1f2>
  8006b9:	83 ee 01             	sub    $0x1,%esi
  8006bc:	79 9c                	jns    80065a <vprintfmt+0x1f2>
  8006be:	89 df                	mov    %ebx,%edi
  8006c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8006c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006c6:	eb 18                	jmp    8006e0 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006c8:	83 ec 08             	sub    $0x8,%esp
  8006cb:	53                   	push   %ebx
  8006cc:	6a 20                	push   $0x20
  8006ce:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006d0:	83 ef 01             	sub    $0x1,%edi
  8006d3:	83 c4 10             	add    $0x10,%esp
  8006d6:	eb 08                	jmp    8006e0 <vprintfmt+0x278>
  8006d8:	89 df                	mov    %ebx,%edi
  8006da:	8b 75 08             	mov    0x8(%ebp),%esi
  8006dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006e0:	85 ff                	test   %edi,%edi
  8006e2:	7f e4                	jg     8006c8 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006e7:	e9 a2 fd ff ff       	jmp    80048e <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006ec:	8d 45 14             	lea    0x14(%ebp),%eax
  8006ef:	e8 08 fd ff ff       	call   8003fc <getint>
  8006f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f7:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006fa:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006ff:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800703:	79 74                	jns    800779 <vprintfmt+0x311>
				putch('-', putdat);
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	53                   	push   %ebx
  800709:	6a 2d                	push   $0x2d
  80070b:	ff d6                	call   *%esi
				num = -(long long) num;
  80070d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800710:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800713:	f7 d8                	neg    %eax
  800715:	83 d2 00             	adc    $0x0,%edx
  800718:	f7 da                	neg    %edx
  80071a:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  80071d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800722:	eb 55                	jmp    800779 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800724:	8d 45 14             	lea    0x14(%ebp),%eax
  800727:	e8 96 fc ff ff       	call   8003c2 <getuint>
			base = 10;
  80072c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800731:	eb 46                	jmp    800779 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800733:	8d 45 14             	lea    0x14(%ebp),%eax
  800736:	e8 87 fc ff ff       	call   8003c2 <getuint>
			base = 8;
  80073b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800740:	eb 37                	jmp    800779 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  800742:	83 ec 08             	sub    $0x8,%esp
  800745:	53                   	push   %ebx
  800746:	6a 30                	push   $0x30
  800748:	ff d6                	call   *%esi
			putch('x', putdat);
  80074a:	83 c4 08             	add    $0x8,%esp
  80074d:	53                   	push   %ebx
  80074e:	6a 78                	push   $0x78
  800750:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	8d 50 04             	lea    0x4(%eax),%edx
  800758:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800762:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800765:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80076a:	eb 0d                	jmp    800779 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80076c:	8d 45 14             	lea    0x14(%ebp),%eax
  80076f:	e8 4e fc ff ff       	call   8003c2 <getuint>
			base = 16;
  800774:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800779:	83 ec 0c             	sub    $0xc,%esp
  80077c:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800780:	57                   	push   %edi
  800781:	ff 75 e0             	pushl  -0x20(%ebp)
  800784:	51                   	push   %ecx
  800785:	52                   	push   %edx
  800786:	50                   	push   %eax
  800787:	89 da                	mov    %ebx,%edx
  800789:	89 f0                	mov    %esi,%eax
  80078b:	e8 83 fb ff ff       	call   800313 <printnum>
			break;
  800790:	83 c4 20             	add    $0x20,%esp
  800793:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800796:	e9 f3 fc ff ff       	jmp    80048e <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80079b:	83 ec 08             	sub    $0x8,%esp
  80079e:	53                   	push   %ebx
  80079f:	51                   	push   %ecx
  8007a0:	ff d6                	call   *%esi
			break;
  8007a2:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8007a8:	e9 e1 fc ff ff       	jmp    80048e <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007ad:	83 ec 08             	sub    $0x8,%esp
  8007b0:	53                   	push   %ebx
  8007b1:	6a 25                	push   $0x25
  8007b3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007b5:	83 c4 10             	add    $0x10,%esp
  8007b8:	eb 03                	jmp    8007bd <vprintfmt+0x355>
  8007ba:	83 ef 01             	sub    $0x1,%edi
  8007bd:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  8007c1:	75 f7                	jne    8007ba <vprintfmt+0x352>
  8007c3:	e9 c6 fc ff ff       	jmp    80048e <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  8007c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007cb:	5b                   	pop    %ebx
  8007cc:	5e                   	pop    %esi
  8007cd:	5f                   	pop    %edi
  8007ce:	5d                   	pop    %ebp
  8007cf:	c3                   	ret    

008007d0 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
  8007d3:	83 ec 18             	sub    $0x18,%esp
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007df:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007e3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007ed:	85 c0                	test   %eax,%eax
  8007ef:	74 26                	je     800817 <vsnprintf+0x47>
  8007f1:	85 d2                	test   %edx,%edx
  8007f3:	7e 22                	jle    800817 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007f5:	ff 75 14             	pushl  0x14(%ebp)
  8007f8:	ff 75 10             	pushl  0x10(%ebp)
  8007fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007fe:	50                   	push   %eax
  8007ff:	68 2e 04 80 00       	push   $0x80042e
  800804:	e8 5f fc ff ff       	call   800468 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800809:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80080c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80080f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800812:	83 c4 10             	add    $0x10,%esp
  800815:	eb 05                	jmp    80081c <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800817:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80081c:	c9                   	leave  
  80081d:	c3                   	ret    

0080081e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800824:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800827:	50                   	push   %eax
  800828:	ff 75 10             	pushl  0x10(%ebp)
  80082b:	ff 75 0c             	pushl  0xc(%ebp)
  80082e:	ff 75 08             	pushl  0x8(%ebp)
  800831:	e8 9a ff ff ff       	call   8007d0 <vsnprintf>
	va_end(ap);

	return rc;
}
  800836:	c9                   	leave  
  800837:	c3                   	ret    

00800838 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800838:	55                   	push   %ebp
  800839:	89 e5                	mov    %esp,%ebp
  80083b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80083e:	b8 00 00 00 00       	mov    $0x0,%eax
  800843:	eb 03                	jmp    800848 <strlen+0x10>
		n++;
  800845:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800848:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80084c:	75 f7                	jne    800845 <strlen+0xd>
		n++;
	return n;
}
  80084e:	5d                   	pop    %ebp
  80084f:	c3                   	ret    

00800850 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800850:	55                   	push   %ebp
  800851:	89 e5                	mov    %esp,%ebp
  800853:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800856:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800859:	ba 00 00 00 00       	mov    $0x0,%edx
  80085e:	eb 03                	jmp    800863 <strnlen+0x13>
		n++;
  800860:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800863:	39 c2                	cmp    %eax,%edx
  800865:	74 08                	je     80086f <strnlen+0x1f>
  800867:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80086b:	75 f3                	jne    800860 <strnlen+0x10>
  80086d:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  80086f:	5d                   	pop    %ebp
  800870:	c3                   	ret    

00800871 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800871:	55                   	push   %ebp
  800872:	89 e5                	mov    %esp,%ebp
  800874:	53                   	push   %ebx
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80087b:	89 c2                	mov    %eax,%edx
  80087d:	83 c2 01             	add    $0x1,%edx
  800880:	83 c1 01             	add    $0x1,%ecx
  800883:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800887:	88 5a ff             	mov    %bl,-0x1(%edx)
  80088a:	84 db                	test   %bl,%bl
  80088c:	75 ef                	jne    80087d <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80088e:	5b                   	pop    %ebx
  80088f:	5d                   	pop    %ebp
  800890:	c3                   	ret    

00800891 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800891:	55                   	push   %ebp
  800892:	89 e5                	mov    %esp,%ebp
  800894:	53                   	push   %ebx
  800895:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800898:	53                   	push   %ebx
  800899:	e8 9a ff ff ff       	call   800838 <strlen>
  80089e:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008a1:	ff 75 0c             	pushl  0xc(%ebp)
  8008a4:	01 d8                	add    %ebx,%eax
  8008a6:	50                   	push   %eax
  8008a7:	e8 c5 ff ff ff       	call   800871 <strcpy>
	return dst;
}
  8008ac:	89 d8                	mov    %ebx,%eax
  8008ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b1:	c9                   	leave  
  8008b2:	c3                   	ret    

008008b3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	56                   	push   %esi
  8008b7:	53                   	push   %ebx
  8008b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8008bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008be:	89 f3                	mov    %esi,%ebx
  8008c0:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008c3:	89 f2                	mov    %esi,%edx
  8008c5:	eb 0f                	jmp    8008d6 <strncpy+0x23>
		*dst++ = *src;
  8008c7:	83 c2 01             	add    $0x1,%edx
  8008ca:	0f b6 01             	movzbl (%ecx),%eax
  8008cd:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008d0:	80 39 01             	cmpb   $0x1,(%ecx)
  8008d3:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008d6:	39 da                	cmp    %ebx,%edx
  8008d8:	75 ed                	jne    8008c7 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008da:	89 f0                	mov    %esi,%eax
  8008dc:	5b                   	pop    %ebx
  8008dd:	5e                   	pop    %esi
  8008de:	5d                   	pop    %ebp
  8008df:	c3                   	ret    

008008e0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	56                   	push   %esi
  8008e4:	53                   	push   %ebx
  8008e5:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008eb:	8b 55 10             	mov    0x10(%ebp),%edx
  8008ee:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008f0:	85 d2                	test   %edx,%edx
  8008f2:	74 21                	je     800915 <strlcpy+0x35>
  8008f4:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008f8:	89 f2                	mov    %esi,%edx
  8008fa:	eb 09                	jmp    800905 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008fc:	83 c2 01             	add    $0x1,%edx
  8008ff:	83 c1 01             	add    $0x1,%ecx
  800902:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800905:	39 c2                	cmp    %eax,%edx
  800907:	74 09                	je     800912 <strlcpy+0x32>
  800909:	0f b6 19             	movzbl (%ecx),%ebx
  80090c:	84 db                	test   %bl,%bl
  80090e:	75 ec                	jne    8008fc <strlcpy+0x1c>
  800910:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  800912:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800915:	29 f0                	sub    %esi,%eax
}
  800917:	5b                   	pop    %ebx
  800918:	5e                   	pop    %esi
  800919:	5d                   	pop    %ebp
  80091a:	c3                   	ret    

0080091b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800921:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800924:	eb 06                	jmp    80092c <strcmp+0x11>
		p++, q++;
  800926:	83 c1 01             	add    $0x1,%ecx
  800929:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80092c:	0f b6 01             	movzbl (%ecx),%eax
  80092f:	84 c0                	test   %al,%al
  800931:	74 04                	je     800937 <strcmp+0x1c>
  800933:	3a 02                	cmp    (%edx),%al
  800935:	74 ef                	je     800926 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800937:	0f b6 c0             	movzbl %al,%eax
  80093a:	0f b6 12             	movzbl (%edx),%edx
  80093d:	29 d0                	sub    %edx,%eax
}
  80093f:	5d                   	pop    %ebp
  800940:	c3                   	ret    

00800941 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	53                   	push   %ebx
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094b:	89 c3                	mov    %eax,%ebx
  80094d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800950:	eb 06                	jmp    800958 <strncmp+0x17>
		n--, p++, q++;
  800952:	83 c0 01             	add    $0x1,%eax
  800955:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800958:	39 d8                	cmp    %ebx,%eax
  80095a:	74 15                	je     800971 <strncmp+0x30>
  80095c:	0f b6 08             	movzbl (%eax),%ecx
  80095f:	84 c9                	test   %cl,%cl
  800961:	74 04                	je     800967 <strncmp+0x26>
  800963:	3a 0a                	cmp    (%edx),%cl
  800965:	74 eb                	je     800952 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800967:	0f b6 00             	movzbl (%eax),%eax
  80096a:	0f b6 12             	movzbl (%edx),%edx
  80096d:	29 d0                	sub    %edx,%eax
  80096f:	eb 05                	jmp    800976 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800971:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800976:	5b                   	pop    %ebx
  800977:	5d                   	pop    %ebp
  800978:	c3                   	ret    

00800979 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800983:	eb 07                	jmp    80098c <strchr+0x13>
		if (*s == c)
  800985:	38 ca                	cmp    %cl,%dl
  800987:	74 0f                	je     800998 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800989:	83 c0 01             	add    $0x1,%eax
  80098c:	0f b6 10             	movzbl (%eax),%edx
  80098f:	84 d2                	test   %dl,%dl
  800991:	75 f2                	jne    800985 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800993:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800998:	5d                   	pop    %ebp
  800999:	c3                   	ret    

0080099a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009a4:	eb 03                	jmp    8009a9 <strfind+0xf>
  8009a6:	83 c0 01             	add    $0x1,%eax
  8009a9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009ac:	38 ca                	cmp    %cl,%dl
  8009ae:	74 04                	je     8009b4 <strfind+0x1a>
  8009b0:	84 d2                	test   %dl,%dl
  8009b2:	75 f2                	jne    8009a6 <strfind+0xc>
			break;
	return (char *) s;
}
  8009b4:	5d                   	pop    %ebp
  8009b5:	c3                   	ret    

008009b6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	57                   	push   %edi
  8009ba:	56                   	push   %esi
  8009bb:	53                   	push   %ebx
  8009bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8009bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  8009c2:	85 c9                	test   %ecx,%ecx
  8009c4:	74 37                	je     8009fd <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009c6:	f6 c2 03             	test   $0x3,%dl
  8009c9:	75 2a                	jne    8009f5 <memset+0x3f>
  8009cb:	f6 c1 03             	test   $0x3,%cl
  8009ce:	75 25                	jne    8009f5 <memset+0x3f>
		c &= 0xFF;
  8009d0:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009d4:	89 df                	mov    %ebx,%edi
  8009d6:	c1 e7 08             	shl    $0x8,%edi
  8009d9:	89 de                	mov    %ebx,%esi
  8009db:	c1 e6 18             	shl    $0x18,%esi
  8009de:	89 d8                	mov    %ebx,%eax
  8009e0:	c1 e0 10             	shl    $0x10,%eax
  8009e3:	09 f0                	or     %esi,%eax
  8009e5:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8009e7:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8009ea:	89 f8                	mov    %edi,%eax
  8009ec:	09 d8                	or     %ebx,%eax
  8009ee:	89 d7                	mov    %edx,%edi
  8009f0:	fc                   	cld    
  8009f1:	f3 ab                	rep stos %eax,%es:(%edi)
  8009f3:	eb 08                	jmp    8009fd <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009f5:	89 d7                	mov    %edx,%edi
  8009f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fa:	fc                   	cld    
  8009fb:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8009fd:	89 d0                	mov    %edx,%eax
  8009ff:	5b                   	pop    %ebx
  800a00:	5e                   	pop    %esi
  800a01:	5f                   	pop    %edi
  800a02:	5d                   	pop    %ebp
  800a03:	c3                   	ret    

00800a04 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	57                   	push   %edi
  800a08:	56                   	push   %esi
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a0f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a12:	39 c6                	cmp    %eax,%esi
  800a14:	73 35                	jae    800a4b <memmove+0x47>
  800a16:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a19:	39 d0                	cmp    %edx,%eax
  800a1b:	73 2e                	jae    800a4b <memmove+0x47>
		s += n;
		d += n;
  800a1d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a20:	89 d6                	mov    %edx,%esi
  800a22:	09 fe                	or     %edi,%esi
  800a24:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a2a:	75 13                	jne    800a3f <memmove+0x3b>
  800a2c:	f6 c1 03             	test   $0x3,%cl
  800a2f:	75 0e                	jne    800a3f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  800a31:	83 ef 04             	sub    $0x4,%edi
  800a34:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a37:	c1 e9 02             	shr    $0x2,%ecx
  800a3a:	fd                   	std    
  800a3b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a3d:	eb 09                	jmp    800a48 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a3f:	83 ef 01             	sub    $0x1,%edi
  800a42:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a45:	fd                   	std    
  800a46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a48:	fc                   	cld    
  800a49:	eb 1d                	jmp    800a68 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a4b:	89 f2                	mov    %esi,%edx
  800a4d:	09 c2                	or     %eax,%edx
  800a4f:	f6 c2 03             	test   $0x3,%dl
  800a52:	75 0f                	jne    800a63 <memmove+0x5f>
  800a54:	f6 c1 03             	test   $0x3,%cl
  800a57:	75 0a                	jne    800a63 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  800a59:	c1 e9 02             	shr    $0x2,%ecx
  800a5c:	89 c7                	mov    %eax,%edi
  800a5e:	fc                   	cld    
  800a5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a61:	eb 05                	jmp    800a68 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a63:	89 c7                	mov    %eax,%edi
  800a65:	fc                   	cld    
  800a66:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a68:	5e                   	pop    %esi
  800a69:	5f                   	pop    %edi
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a6f:	ff 75 10             	pushl  0x10(%ebp)
  800a72:	ff 75 0c             	pushl  0xc(%ebp)
  800a75:	ff 75 08             	pushl  0x8(%ebp)
  800a78:	e8 87 ff ff ff       	call   800a04 <memmove>
}
  800a7d:	c9                   	leave  
  800a7e:	c3                   	ret    

00800a7f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a7f:	55                   	push   %ebp
  800a80:	89 e5                	mov    %esp,%ebp
  800a82:	56                   	push   %esi
  800a83:	53                   	push   %ebx
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8a:	89 c6                	mov    %eax,%esi
  800a8c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a8f:	eb 1a                	jmp    800aab <memcmp+0x2c>
		if (*s1 != *s2)
  800a91:	0f b6 08             	movzbl (%eax),%ecx
  800a94:	0f b6 1a             	movzbl (%edx),%ebx
  800a97:	38 d9                	cmp    %bl,%cl
  800a99:	74 0a                	je     800aa5 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a9b:	0f b6 c1             	movzbl %cl,%eax
  800a9e:	0f b6 db             	movzbl %bl,%ebx
  800aa1:	29 d8                	sub    %ebx,%eax
  800aa3:	eb 0f                	jmp    800ab4 <memcmp+0x35>
		s1++, s2++;
  800aa5:	83 c0 01             	add    $0x1,%eax
  800aa8:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aab:	39 f0                	cmp    %esi,%eax
  800aad:	75 e2                	jne    800a91 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800aaf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab4:	5b                   	pop    %ebx
  800ab5:	5e                   	pop    %esi
  800ab6:	5d                   	pop    %ebp
  800ab7:	c3                   	ret    

00800ab8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ab8:	55                   	push   %ebp
  800ab9:	89 e5                	mov    %esp,%ebp
  800abb:	53                   	push   %ebx
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800abf:	89 c1                	mov    %eax,%ecx
  800ac1:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  800ac4:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ac8:	eb 0a                	jmp    800ad4 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800aca:	0f b6 10             	movzbl (%eax),%edx
  800acd:	39 da                	cmp    %ebx,%edx
  800acf:	74 07                	je     800ad8 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ad1:	83 c0 01             	add    $0x1,%eax
  800ad4:	39 c8                	cmp    %ecx,%eax
  800ad6:	72 f2                	jb     800aca <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ad8:	5b                   	pop    %ebx
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    

00800adb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	57                   	push   %edi
  800adf:	56                   	push   %esi
  800ae0:	53                   	push   %ebx
  800ae1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ae7:	eb 03                	jmp    800aec <strtol+0x11>
		s++;
  800ae9:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aec:	0f b6 01             	movzbl (%ecx),%eax
  800aef:	3c 20                	cmp    $0x20,%al
  800af1:	74 f6                	je     800ae9 <strtol+0xe>
  800af3:	3c 09                	cmp    $0x9,%al
  800af5:	74 f2                	je     800ae9 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800af7:	3c 2b                	cmp    $0x2b,%al
  800af9:	75 0a                	jne    800b05 <strtol+0x2a>
		s++;
  800afb:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800afe:	bf 00 00 00 00       	mov    $0x0,%edi
  800b03:	eb 11                	jmp    800b16 <strtol+0x3b>
  800b05:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b0a:	3c 2d                	cmp    $0x2d,%al
  800b0c:	75 08                	jne    800b16 <strtol+0x3b>
		s++, neg = 1;
  800b0e:	83 c1 01             	add    $0x1,%ecx
  800b11:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b16:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b1c:	75 15                	jne    800b33 <strtol+0x58>
  800b1e:	80 39 30             	cmpb   $0x30,(%ecx)
  800b21:	75 10                	jne    800b33 <strtol+0x58>
  800b23:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b27:	75 7c                	jne    800ba5 <strtol+0xca>
		s += 2, base = 16;
  800b29:	83 c1 02             	add    $0x2,%ecx
  800b2c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b31:	eb 16                	jmp    800b49 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800b33:	85 db                	test   %ebx,%ebx
  800b35:	75 12                	jne    800b49 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b37:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b3c:	80 39 30             	cmpb   $0x30,(%ecx)
  800b3f:	75 08                	jne    800b49 <strtol+0x6e>
		s++, base = 8;
  800b41:	83 c1 01             	add    $0x1,%ecx
  800b44:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800b49:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4e:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b51:	0f b6 11             	movzbl (%ecx),%edx
  800b54:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b57:	89 f3                	mov    %esi,%ebx
  800b59:	80 fb 09             	cmp    $0x9,%bl
  800b5c:	77 08                	ja     800b66 <strtol+0x8b>
			dig = *s - '0';
  800b5e:	0f be d2             	movsbl %dl,%edx
  800b61:	83 ea 30             	sub    $0x30,%edx
  800b64:	eb 22                	jmp    800b88 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800b66:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b69:	89 f3                	mov    %esi,%ebx
  800b6b:	80 fb 19             	cmp    $0x19,%bl
  800b6e:	77 08                	ja     800b78 <strtol+0x9d>
			dig = *s - 'a' + 10;
  800b70:	0f be d2             	movsbl %dl,%edx
  800b73:	83 ea 57             	sub    $0x57,%edx
  800b76:	eb 10                	jmp    800b88 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800b78:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b7b:	89 f3                	mov    %esi,%ebx
  800b7d:	80 fb 19             	cmp    $0x19,%bl
  800b80:	77 16                	ja     800b98 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800b82:	0f be d2             	movsbl %dl,%edx
  800b85:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800b88:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b8b:	7d 0b                	jge    800b98 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800b8d:	83 c1 01             	add    $0x1,%ecx
  800b90:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b94:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800b96:	eb b9                	jmp    800b51 <strtol+0x76>

	if (endptr)
  800b98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9c:	74 0d                	je     800bab <strtol+0xd0>
		*endptr = (char *) s;
  800b9e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ba1:	89 0e                	mov    %ecx,(%esi)
  800ba3:	eb 06                	jmp    800bab <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ba5:	85 db                	test   %ebx,%ebx
  800ba7:	74 98                	je     800b41 <strtol+0x66>
  800ba9:	eb 9e                	jmp    800b49 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800bab:	89 c2                	mov    %eax,%edx
  800bad:	f7 da                	neg    %edx
  800baf:	85 ff                	test   %edi,%edi
  800bb1:	0f 45 c2             	cmovne %edx,%eax
}
  800bb4:	5b                   	pop    %ebx
  800bb5:	5e                   	pop    %esi
  800bb6:	5f                   	pop    %edi
  800bb7:	5d                   	pop    %ebp
  800bb8:	c3                   	ret    

00800bb9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800bb9:	55                   	push   %ebp
  800bba:	89 e5                	mov    %esp,%ebp
  800bbc:	57                   	push   %edi
  800bbd:	56                   	push   %esi
  800bbe:	53                   	push   %ebx
  800bbf:	83 ec 1c             	sub    $0x1c,%esp
  800bc2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800bc5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800bc8:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bcd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800bd0:	8b 7d 10             	mov    0x10(%ebp),%edi
  800bd3:	8b 75 14             	mov    0x14(%ebp),%esi
  800bd6:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800bd8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bdc:	74 1d                	je     800bfb <syscall+0x42>
  800bde:	85 c0                	test   %eax,%eax
  800be0:	7e 19                	jle    800bfb <syscall+0x42>
  800be2:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800be5:	83 ec 0c             	sub    $0xc,%esp
  800be8:	50                   	push   %eax
  800be9:	52                   	push   %edx
  800bea:	68 9f 28 80 00       	push   $0x80289f
  800bef:	6a 23                	push   $0x23
  800bf1:	68 bc 28 80 00       	push   $0x8028bc
  800bf6:	e8 2b f6 ff ff       	call   800226 <_panic>

	return ret;
}
  800bfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bfe:	5b                   	pop    %ebx
  800bff:	5e                   	pop    %esi
  800c00:	5f                   	pop    %edi
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800c09:	6a 00                	push   $0x0
  800c0b:	6a 00                	push   $0x0
  800c0d:	6a 00                	push   $0x0
  800c0f:	ff 75 0c             	pushl  0xc(%ebp)
  800c12:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c15:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1f:	e8 95 ff ff ff       	call   800bb9 <syscall>
}
  800c24:	83 c4 10             	add    $0x10,%esp
  800c27:	c9                   	leave  
  800c28:	c3                   	ret    

00800c29 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800c2f:	6a 00                	push   $0x0
  800c31:	6a 00                	push   $0x0
  800c33:	6a 00                	push   $0x0
  800c35:	6a 00                	push   $0x0
  800c37:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c3c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c41:	b8 01 00 00 00       	mov    $0x1,%eax
  800c46:	e8 6e ff ff ff       	call   800bb9 <syscall>
}
  800c4b:	c9                   	leave  
  800c4c:	c3                   	ret    

00800c4d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
  800c50:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800c53:	6a 00                	push   $0x0
  800c55:	6a 00                	push   $0x0
  800c57:	6a 00                	push   $0x0
  800c59:	6a 00                	push   $0x0
  800c5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c5e:	ba 01 00 00 00       	mov    $0x1,%edx
  800c63:	b8 03 00 00 00       	mov    $0x3,%eax
  800c68:	e8 4c ff ff ff       	call   800bb9 <syscall>
}
  800c6d:	c9                   	leave  
  800c6e:	c3                   	ret    

00800c6f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800c75:	6a 00                	push   $0x0
  800c77:	6a 00                	push   $0x0
  800c79:	6a 00                	push   $0x0
  800c7b:	6a 00                	push   $0x0
  800c7d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c82:	ba 00 00 00 00       	mov    $0x0,%edx
  800c87:	b8 02 00 00 00       	mov    $0x2,%eax
  800c8c:	e8 28 ff ff ff       	call   800bb9 <syscall>
}
  800c91:	c9                   	leave  
  800c92:	c3                   	ret    

00800c93 <sys_yield>:

void
sys_yield(void)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800c99:	6a 00                	push   $0x0
  800c9b:	6a 00                	push   $0x0
  800c9d:	6a 00                	push   $0x0
  800c9f:	6a 00                	push   $0x0
  800ca1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ca6:	ba 00 00 00 00       	mov    $0x0,%edx
  800cab:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cb0:	e8 04 ff ff ff       	call   800bb9 <syscall>
}
  800cb5:	83 c4 10             	add    $0x10,%esp
  800cb8:	c9                   	leave  
  800cb9:	c3                   	ret    

00800cba <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800cc0:	6a 00                	push   $0x0
  800cc2:	6a 00                	push   $0x0
  800cc4:	ff 75 10             	pushl  0x10(%ebp)
  800cc7:	ff 75 0c             	pushl  0xc(%ebp)
  800cca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ccd:	ba 01 00 00 00       	mov    $0x1,%edx
  800cd2:	b8 04 00 00 00       	mov    $0x4,%eax
  800cd7:	e8 dd fe ff ff       	call   800bb9 <syscall>
}
  800cdc:	c9                   	leave  
  800cdd:	c3                   	ret    

00800cde <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800ce4:	ff 75 18             	pushl  0x18(%ebp)
  800ce7:	ff 75 14             	pushl  0x14(%ebp)
  800cea:	ff 75 10             	pushl  0x10(%ebp)
  800ced:	ff 75 0c             	pushl  0xc(%ebp)
  800cf0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cf3:	ba 01 00 00 00       	mov    $0x1,%edx
  800cf8:	b8 05 00 00 00       	mov    $0x5,%eax
  800cfd:	e8 b7 fe ff ff       	call   800bb9 <syscall>
}
  800d02:	c9                   	leave  
  800d03:	c3                   	ret    

00800d04 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800d0a:	6a 00                	push   $0x0
  800d0c:	6a 00                	push   $0x0
  800d0e:	6a 00                	push   $0x0
  800d10:	ff 75 0c             	pushl  0xc(%ebp)
  800d13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d16:	ba 01 00 00 00       	mov    $0x1,%edx
  800d1b:	b8 06 00 00 00       	mov    $0x6,%eax
  800d20:	e8 94 fe ff ff       	call   800bb9 <syscall>
}
  800d25:	c9                   	leave  
  800d26:	c3                   	ret    

00800d27 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800d2d:	6a 00                	push   $0x0
  800d2f:	6a 00                	push   $0x0
  800d31:	6a 00                	push   $0x0
  800d33:	ff 75 0c             	pushl  0xc(%ebp)
  800d36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d39:	ba 01 00 00 00       	mov    $0x1,%edx
  800d3e:	b8 08 00 00 00       	mov    $0x8,%eax
  800d43:	e8 71 fe ff ff       	call   800bb9 <syscall>
}
  800d48:	c9                   	leave  
  800d49:	c3                   	ret    

00800d4a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800d50:	6a 00                	push   $0x0
  800d52:	6a 00                	push   $0x0
  800d54:	6a 00                	push   $0x0
  800d56:	ff 75 0c             	pushl  0xc(%ebp)
  800d59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d5c:	ba 01 00 00 00       	mov    $0x1,%edx
  800d61:	b8 09 00 00 00       	mov    $0x9,%eax
  800d66:	e8 4e fe ff ff       	call   800bb9 <syscall>
}
  800d6b:	c9                   	leave  
  800d6c:	c3                   	ret    

00800d6d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800d73:	6a 00                	push   $0x0
  800d75:	6a 00                	push   $0x0
  800d77:	6a 00                	push   $0x0
  800d79:	ff 75 0c             	pushl  0xc(%ebp)
  800d7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d7f:	ba 01 00 00 00       	mov    $0x1,%edx
  800d84:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d89:	e8 2b fe ff ff       	call   800bb9 <syscall>
}
  800d8e:	c9                   	leave  
  800d8f:	c3                   	ret    

00800d90 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800d96:	6a 00                	push   $0x0
  800d98:	ff 75 14             	pushl  0x14(%ebp)
  800d9b:	ff 75 10             	pushl  0x10(%ebp)
  800d9e:	ff 75 0c             	pushl  0xc(%ebp)
  800da1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800da4:	ba 00 00 00 00       	mov    $0x0,%edx
  800da9:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dae:	e8 06 fe ff ff       	call   800bb9 <syscall>
}
  800db3:	c9                   	leave  
  800db4:	c3                   	ret    

00800db5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800dbb:	6a 00                	push   $0x0
  800dbd:	6a 00                	push   $0x0
  800dbf:	6a 00                	push   $0x0
  800dc1:	6a 00                	push   $0x0
  800dc3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dc6:	ba 01 00 00 00       	mov    $0x1,%edx
  800dcb:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dd0:	e8 e4 fd ff ff       	call   800bb9 <syscall>
}
  800dd5:	c9                   	leave  
  800dd6:	c3                   	ret    

00800dd7 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	53                   	push   %ebx
  800ddb:	83 ec 04             	sub    $0x4,%esp

	int perm_w = PTE_COW|PTE_U|PTE_P;
	int perm = PTE_U|PTE_P;

	// LAB 4: Your code here.
	void *addr = (void*) (pn*PGSIZE);
  800dde:	89 d3                	mov    %edx,%ebx
  800de0:	c1 e3 0c             	shl    $0xc,%ebx

	//Si una página tiene el bit PTE_SHARE, se comparte con el hijo con los mismos permisos.
  	if (uvpt[pn] & PTE_SHARE) {
  800de3:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800dea:	f6 c5 04             	test   $0x4,%ch
  800ded:	74 3a                	je     800e29 <duppage+0x52>
    	if (sys_page_map(0, addr, envid,addr, uvpt[pn] & PTE_SYSCALL) < 0) {
  800def:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800df6:	83 ec 0c             	sub    $0xc,%esp
  800df9:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800dff:	52                   	push   %edx
  800e00:	53                   	push   %ebx
  800e01:	50                   	push   %eax
  800e02:	53                   	push   %ebx
  800e03:	6a 00                	push   $0x0
  800e05:	e8 d4 fe ff ff       	call   800cde <sys_page_map>
  800e0a:	83 c4 20             	add    $0x20,%esp
  800e0d:	85 c0                	test   %eax,%eax
  800e0f:	0f 89 99 00 00 00    	jns    800eae <duppage+0xd7>
 	     	panic("Error en sys_page_map");
  800e15:	83 ec 04             	sub    $0x4,%esp
  800e18:	68 ca 28 80 00       	push   $0x8028ca
  800e1d:	6a 50                	push   $0x50
  800e1f:	68 e0 28 80 00       	push   $0x8028e0
  800e24:	e8 fd f3 ff ff       	call   800226 <_panic>
    	} 
    	return 0;
	}

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  800e29:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800e30:	f6 c1 02             	test   $0x2,%cl
  800e33:	75 0c                	jne    800e41 <duppage+0x6a>
  800e35:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e3c:	f6 c6 08             	test   $0x8,%dh
  800e3f:	74 5b                	je     800e9c <duppage+0xc5>
		if (sys_page_map(0, addr, envid, addr, perm_w) < 0){
  800e41:	83 ec 0c             	sub    $0xc,%esp
  800e44:	68 05 08 00 00       	push   $0x805
  800e49:	53                   	push   %ebx
  800e4a:	50                   	push   %eax
  800e4b:	53                   	push   %ebx
  800e4c:	6a 00                	push   $0x0
  800e4e:	e8 8b fe ff ff       	call   800cde <sys_page_map>
  800e53:	83 c4 20             	add    $0x20,%esp
  800e56:	85 c0                	test   %eax,%eax
  800e58:	79 14                	jns    800e6e <duppage+0x97>
			panic("Error mapeando pagina Padre");
  800e5a:	83 ec 04             	sub    $0x4,%esp
  800e5d:	68 eb 28 80 00       	push   $0x8028eb
  800e62:	6a 57                	push   $0x57
  800e64:	68 e0 28 80 00       	push   $0x8028e0
  800e69:	e8 b8 f3 ff ff       	call   800226 <_panic>
		}
		if (sys_page_map(0, addr, 0, addr, perm_w) < 0){
  800e6e:	83 ec 0c             	sub    $0xc,%esp
  800e71:	68 05 08 00 00       	push   $0x805
  800e76:	53                   	push   %ebx
  800e77:	6a 00                	push   $0x0
  800e79:	53                   	push   %ebx
  800e7a:	6a 00                	push   $0x0
  800e7c:	e8 5d fe ff ff       	call   800cde <sys_page_map>
  800e81:	83 c4 20             	add    $0x20,%esp
  800e84:	85 c0                	test   %eax,%eax
  800e86:	79 26                	jns    800eae <duppage+0xd7>
			panic("Error mapeando pagina Hijo");
  800e88:	83 ec 04             	sub    $0x4,%esp
  800e8b:	68 07 29 80 00       	push   $0x802907
  800e90:	6a 5a                	push   $0x5a
  800e92:	68 e0 28 80 00       	push   $0x8028e0
  800e97:	e8 8a f3 ff ff       	call   800226 <_panic>
		}
	} else sys_page_map(0, addr, envid, addr, perm);
  800e9c:	83 ec 0c             	sub    $0xc,%esp
  800e9f:	6a 05                	push   $0x5
  800ea1:	53                   	push   %ebx
  800ea2:	50                   	push   %eax
  800ea3:	53                   	push   %ebx
  800ea4:	6a 00                	push   $0x0
  800ea6:	e8 33 fe ff ff       	call   800cde <sys_page_map>
  800eab:	83 c4 20             	add    $0x20,%esp
	
	return 0;
}
  800eae:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800eb6:	c9                   	leave  
  800eb7:	c3                   	ret    

00800eb8 <dup_or_share>:
//FORK V0

static void
dup_or_share(envid_t dstenv, void *va, int perm){
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	57                   	push   %edi
  800ebc:	56                   	push   %esi
  800ebd:	53                   	push   %ebx
  800ebe:	83 ec 0c             	sub    $0xc,%esp
  800ec1:	89 c7                	mov    %eax,%edi
  800ec3:	89 d6                	mov    %edx,%esi
  800ec5:	89 cb                	mov    %ecx,%ebx
	int result;
	// Si no es de escritura, comparto la pagina
	if((perm &PTE_W) != PTE_W){
  800ec7:	f6 c1 02             	test   $0x2,%cl
  800eca:	75 2d                	jne    800ef9 <dup_or_share+0x41>
		if((result = sys_page_map(0, va, dstenv, va, perm))<0){
  800ecc:	83 ec 0c             	sub    $0xc,%esp
  800ecf:	51                   	push   %ecx
  800ed0:	52                   	push   %edx
  800ed1:	50                   	push   %eax
  800ed2:	52                   	push   %edx
  800ed3:	6a 00                	push   $0x0
  800ed5:	e8 04 fe ff ff       	call   800cde <sys_page_map>
  800eda:	83 c4 20             	add    $0x20,%esp
  800edd:	85 c0                	test   %eax,%eax
  800edf:	0f 89 a4 00 00 00    	jns    800f89 <dup_or_share+0xd1>
			panic("Error compartiendo la pagina");
  800ee5:	83 ec 04             	sub    $0x4,%esp
  800ee8:	68 22 29 80 00       	push   $0x802922
  800eed:	6a 68                	push   $0x68
  800eef:	68 e0 28 80 00       	push   $0x8028e0
  800ef4:	e8 2d f3 ff ff       	call   800226 <_panic>
		}
	// Si es de escritura comportamiento de duppage, en dumbfork
	}else{
		if ((result = sys_page_alloc(dstenv, va, perm)) < 0){
  800ef9:	83 ec 04             	sub    $0x4,%esp
  800efc:	51                   	push   %ecx
  800efd:	52                   	push   %edx
  800efe:	50                   	push   %eax
  800eff:	e8 b6 fd ff ff       	call   800cba <sys_page_alloc>
  800f04:	83 c4 10             	add    $0x10,%esp
  800f07:	85 c0                	test   %eax,%eax
  800f09:	79 14                	jns    800f1f <dup_or_share+0x67>
			panic("Error copiando la pagina");
  800f0b:	83 ec 04             	sub    $0x4,%esp
  800f0e:	68 3f 29 80 00       	push   $0x80293f
  800f13:	6a 6d                	push   $0x6d
  800f15:	68 e0 28 80 00       	push   $0x8028e0
  800f1a:	e8 07 f3 ff ff       	call   800226 <_panic>
		}
		if ((result = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0){
  800f1f:	83 ec 0c             	sub    $0xc,%esp
  800f22:	53                   	push   %ebx
  800f23:	68 00 00 40 00       	push   $0x400000
  800f28:	6a 00                	push   $0x0
  800f2a:	56                   	push   %esi
  800f2b:	57                   	push   %edi
  800f2c:	e8 ad fd ff ff       	call   800cde <sys_page_map>
  800f31:	83 c4 20             	add    $0x20,%esp
  800f34:	85 c0                	test   %eax,%eax
  800f36:	79 14                	jns    800f4c <dup_or_share+0x94>
			panic("Error copiando la pagina");
  800f38:	83 ec 04             	sub    $0x4,%esp
  800f3b:	68 3f 29 80 00       	push   $0x80293f
  800f40:	6a 70                	push   $0x70
  800f42:	68 e0 28 80 00       	push   $0x8028e0
  800f47:	e8 da f2 ff ff       	call   800226 <_panic>
		}
		memmove(UTEMP, va, PGSIZE);
  800f4c:	83 ec 04             	sub    $0x4,%esp
  800f4f:	68 00 10 00 00       	push   $0x1000
  800f54:	56                   	push   %esi
  800f55:	68 00 00 40 00       	push   $0x400000
  800f5a:	e8 a5 fa ff ff       	call   800a04 <memmove>
		if ((result = sys_page_unmap(0, UTEMP)) < 0){
  800f5f:	83 c4 08             	add    $0x8,%esp
  800f62:	68 00 00 40 00       	push   $0x400000
  800f67:	6a 00                	push   $0x0
  800f69:	e8 96 fd ff ff       	call   800d04 <sys_page_unmap>
  800f6e:	83 c4 10             	add    $0x10,%esp
  800f71:	85 c0                	test   %eax,%eax
  800f73:	79 14                	jns    800f89 <dup_or_share+0xd1>
			panic("Error copiando la pagina");
  800f75:	83 ec 04             	sub    $0x4,%esp
  800f78:	68 3f 29 80 00       	push   $0x80293f
  800f7d:	6a 74                	push   $0x74
  800f7f:	68 e0 28 80 00       	push   $0x8028e0
  800f84:	e8 9d f2 ff ff       	call   800226 <_panic>
		}
	}	
}
  800f89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f8c:	5b                   	pop    %ebx
  800f8d:	5e                   	pop    %esi
  800f8e:	5f                   	pop    %edi
  800f8f:	5d                   	pop    %ebp
  800f90:	c3                   	ret    

00800f91 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	53                   	push   %ebx
  800f95:	83 ec 04             	sub    $0x4,%esp
  800f98:	8b 55 08             	mov    0x8(%ebp),%edx
	void *va = (void *) utf->utf_fault_va;
  800f9b:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800f9d:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  800fa1:	74 2e                	je     800fd1 <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
  800fa3:	89 c2                	mov    %eax,%edx
  800fa5:	c1 ea 16             	shr    $0x16,%edx
  800fa8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800faf:	f6 c2 01             	test   $0x1,%dl
  800fb2:	74 1d                	je     800fd1 <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
  800fb4:	89 c2                	mov    %eax,%edx
  800fb6:	c1 ea 0c             	shr    $0xc,%edx
  800fb9:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
		(uvpd[PDX(va)] & PTE_P) && 
  800fc0:	f6 c1 01             	test   $0x1,%cl
  800fc3:	74 0c                	je     800fd1 <pgfault+0x40>
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
  800fc5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800fcc:	f6 c6 08             	test   $0x8,%dh
  800fcf:	75 14                	jne    800fe5 <pgfault+0x54>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
		panic("No es copy-on-write");
  800fd1:	83 ec 04             	sub    $0x4,%esp
  800fd4:	68 58 29 80 00       	push   $0x802958
  800fd9:	6a 21                	push   $0x21
  800fdb:	68 e0 28 80 00       	push   $0x8028e0
  800fe0:	e8 41 f2 ff ff       	call   800226 <_panic>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	va = ROUNDDOWN(va, PGSIZE);
  800fe5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fea:	89 c3                	mov    %eax,%ebx
	if (sys_page_alloc(0, PFTEMP, perm) < 0){
  800fec:	83 ec 04             	sub    $0x4,%esp
  800fef:	6a 07                	push   $0x7
  800ff1:	68 00 f0 7f 00       	push   $0x7ff000
  800ff6:	6a 00                	push   $0x0
  800ff8:	e8 bd fc ff ff       	call   800cba <sys_page_alloc>
  800ffd:	83 c4 10             	add    $0x10,%esp
  801000:	85 c0                	test   %eax,%eax
  801002:	79 14                	jns    801018 <pgfault+0x87>
		panic("Error sys_page_alloc");
  801004:	83 ec 04             	sub    $0x4,%esp
  801007:	68 6c 29 80 00       	push   $0x80296c
  80100c:	6a 2a                	push   $0x2a
  80100e:	68 e0 28 80 00       	push   $0x8028e0
  801013:	e8 0e f2 ff ff       	call   800226 <_panic>
	}
	memcpy(PFTEMP, va, PGSIZE);
  801018:	83 ec 04             	sub    $0x4,%esp
  80101b:	68 00 10 00 00       	push   $0x1000
  801020:	53                   	push   %ebx
  801021:	68 00 f0 7f 00       	push   $0x7ff000
  801026:	e8 41 fa ff ff       	call   800a6c <memcpy>
	if (sys_page_map(0, PFTEMP, 0, va, perm) < 0){
  80102b:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801032:	53                   	push   %ebx
  801033:	6a 00                	push   $0x0
  801035:	68 00 f0 7f 00       	push   $0x7ff000
  80103a:	6a 00                	push   $0x0
  80103c:	e8 9d fc ff ff       	call   800cde <sys_page_map>
  801041:	83 c4 20             	add    $0x20,%esp
  801044:	85 c0                	test   %eax,%eax
  801046:	79 14                	jns    80105c <pgfault+0xcb>
		panic("Error sys_page_map");
  801048:	83 ec 04             	sub    $0x4,%esp
  80104b:	68 81 29 80 00       	push   $0x802981
  801050:	6a 2e                	push   $0x2e
  801052:	68 e0 28 80 00       	push   $0x8028e0
  801057:	e8 ca f1 ff ff       	call   800226 <_panic>
	}
	if (sys_page_unmap(0, PFTEMP) < 0){
  80105c:	83 ec 08             	sub    $0x8,%esp
  80105f:	68 00 f0 7f 00       	push   $0x7ff000
  801064:	6a 00                	push   $0x0
  801066:	e8 99 fc ff ff       	call   800d04 <sys_page_unmap>
  80106b:	83 c4 10             	add    $0x10,%esp
  80106e:	85 c0                	test   %eax,%eax
  801070:	79 14                	jns    801086 <pgfault+0xf5>
		panic("Error sys_page_unmap");
  801072:	83 ec 04             	sub    $0x4,%esp
  801075:	68 94 29 80 00       	push   $0x802994
  80107a:	6a 31                	push   $0x31
  80107c:	68 e0 28 80 00       	push   $0x8028e0
  801081:	e8 a0 f1 ff ff       	call   800226 <_panic>
	}
	return;

}
  801086:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801089:	c9                   	leave  
  80108a:	c3                   	ret    

0080108b <fork_v0>:
		}
	}	
}

envid_t
fork_v0(void){
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	57                   	push   %edi
  80108f:	56                   	push   %esi
  801090:	53                   	push   %ebx
  801091:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801094:	b8 07 00 00 00       	mov    $0x7,%eax
  801099:	cd 30                	int    $0x30
  80109b:	89 c6                	mov    %eax,%esi
	envid_t envid;
	uint8_t *va;
	int result;	

	envid = sys_exofork();
	if (envid < 0)
  80109d:	85 c0                	test   %eax,%eax
  80109f:	79 15                	jns    8010b6 <fork_v0+0x2b>
		panic("sys_exofork: %e", envid);
  8010a1:	50                   	push   %eax
  8010a2:	68 a9 29 80 00       	push   $0x8029a9
  8010a7:	68 81 00 00 00       	push   $0x81
  8010ac:	68 e0 28 80 00       	push   $0x8028e0
  8010b1:	e8 70 f1 ff ff       	call   800226 <_panic>
  8010b6:	89 c7                	mov    %eax,%edi
  8010b8:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {		
  8010bd:	85 c0                	test   %eax,%eax
  8010bf:	75 1e                	jne    8010df <fork_v0+0x54>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010c1:	e8 a9 fb ff ff       	call   800c6f <sys_getenvid>
  8010c6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010cb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010ce:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010d3:	a3 20 44 80 00       	mov    %eax,0x804420
		return 0;
  8010d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8010dd:	eb 7a                	jmp    801159 <fork_v0+0xce>
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  8010df:	89 d8                	mov    %ebx,%eax
  8010e1:	c1 e8 16             	shr    $0x16,%eax
  8010e4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010eb:	a8 01                	test   $0x1,%al
  8010ed:	74 33                	je     801122 <fork_v0+0x97>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  8010ef:	89 d8                	mov    %ebx,%eax
  8010f1:	c1 e8 0c             	shr    $0xc,%eax
  8010f4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010fb:	f6 c2 01             	test   $0x1,%dl
  8010fe:	74 22                	je     801122 <fork_v0+0x97>
  801100:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801107:	f6 c2 04             	test   $0x4,%dl
  80110a:	74 16                	je     801122 <fork_v0+0x97>
				pte_t pte =uvpt[PGNUM(va)];
  80110c:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
  801113:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801119:	89 da                	mov    %ebx,%edx
  80111b:	89 f8                	mov    %edi,%eax
  80111d:	e8 96 fd ff ff       	call   800eb8 <dup_or_share>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
  801122:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801128:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  80112e:	75 af                	jne    8010df <fork_v0+0x54>
				pte_t pte =uvpt[PGNUM(va)];
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
			}
		}
	}	
	if ((result = sys_env_set_status(envid, ENV_RUNNABLE)) < 0){
  801130:	83 ec 08             	sub    $0x8,%esp
  801133:	6a 02                	push   $0x2
  801135:	56                   	push   %esi
  801136:	e8 ec fb ff ff       	call   800d27 <sys_env_set_status>
  80113b:	83 c4 10             	add    $0x10,%esp
  80113e:	85 c0                	test   %eax,%eax
  801140:	79 15                	jns    801157 <fork_v0+0xcc>

		panic("sys_env_set_status: %e", result);
  801142:	50                   	push   %eax
  801143:	68 b9 29 80 00       	push   $0x8029b9
  801148:	68 90 00 00 00       	push   $0x90
  80114d:	68 e0 28 80 00       	push   $0x8028e0
  801152:	e8 cf f0 ff ff       	call   800226 <_panic>
	}
	return envid;
  801157:	89 f0                	mov    %esi,%eax
}
  801159:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80115c:	5b                   	pop    %ebx
  80115d:	5e                   	pop    %esi
  80115e:	5f                   	pop    %edi
  80115f:	5d                   	pop    %ebp
  801160:	c3                   	ret    

00801161 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
  801164:	57                   	push   %edi
  801165:	56                   	push   %esi
  801166:	53                   	push   %ebx
  801167:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  80116a:	68 91 0f 80 00       	push   $0x800f91
  80116f:	e8 76 0e 00 00       	call   801fea <set_pgfault_handler>
  801174:	b8 07 00 00 00       	mov    $0x7,%eax
  801179:	cd 30                	int    $0x30
  80117b:	89 c6                	mov    %eax,%esi

	envid_t envid;
	uint32_t va;
	envid = sys_exofork();
	if (envid < 0){
  80117d:	83 c4 10             	add    $0x10,%esp
  801180:	85 c0                	test   %eax,%eax
  801182:	79 15                	jns    801199 <fork+0x38>
		panic("sys_exofork: %e", envid);
  801184:	50                   	push   %eax
  801185:	68 a9 29 80 00       	push   $0x8029a9
  80118a:	68 b1 00 00 00       	push   $0xb1
  80118f:	68 e0 28 80 00       	push   $0x8028e0
  801194:	e8 8d f0 ff ff       	call   800226 <_panic>
  801199:	89 c7                	mov    %eax,%edi
  80119b:	bb 00 00 00 00       	mov    $0x0,%ebx
	}
	if (envid == 0) {		
  8011a0:	85 c0                	test   %eax,%eax
  8011a2:	75 21                	jne    8011c5 <fork+0x64>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011a4:	e8 c6 fa ff ff       	call   800c6f <sys_getenvid>
  8011a9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011ae:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011b1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011b6:	a3 20 44 80 00       	mov    %eax,0x804420
		return 0;
  8011bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c0:	e9 a7 00 00 00       	jmp    80126c <fork+0x10b>
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  8011c5:	89 d8                	mov    %ebx,%eax
  8011c7:	c1 e8 16             	shr    $0x16,%eax
  8011ca:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011d1:	a8 01                	test   $0x1,%al
  8011d3:	74 22                	je     8011f7 <fork+0x96>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  8011d5:	89 da                	mov    %ebx,%edx
  8011d7:	c1 ea 0c             	shr    $0xc,%edx
  8011da:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8011e1:	a8 01                	test   $0x1,%al
  8011e3:	74 12                	je     8011f7 <fork+0x96>
  8011e5:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8011ec:	a8 04                	test   $0x4,%al
  8011ee:	74 07                	je     8011f7 <fork+0x96>
				duppage(envid, PGNUM(va));			
  8011f0:	89 f8                	mov    %edi,%eax
  8011f2:	e8 e0 fb ff ff       	call   800dd7 <duppage>
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
  8011f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8011fd:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801203:	75 c0                	jne    8011c5 <fork+0x64>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
				duppage(envid, PGNUM(va));			
			}
		}
	}
	if (sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P) < 0){
  801205:	83 ec 04             	sub    $0x4,%esp
  801208:	6a 07                	push   $0x7
  80120a:	68 00 f0 bf ee       	push   $0xeebff000
  80120f:	56                   	push   %esi
  801210:	e8 a5 fa ff ff       	call   800cba <sys_page_alloc>
  801215:	83 c4 10             	add    $0x10,%esp
  801218:	85 c0                	test   %eax,%eax
  80121a:	79 17                	jns    801233 <fork+0xd2>
		panic("Se escribio en la pagina de excepciones");
  80121c:	83 ec 04             	sub    $0x4,%esp
  80121f:	68 e8 29 80 00       	push   $0x8029e8
  801224:	68 c0 00 00 00       	push   $0xc0
  801229:	68 e0 28 80 00       	push   $0x8028e0
  80122e:	e8 f3 ef ff ff       	call   800226 <_panic>
	}	
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801233:	83 ec 08             	sub    $0x8,%esp
  801236:	68 59 20 80 00       	push   $0x802059
  80123b:	56                   	push   %esi
  80123c:	e8 2c fb ff ff       	call   800d6d <sys_env_set_pgfault_upcall>

	if (sys_env_set_status(envid, ENV_RUNNABLE) < 0)
  801241:	83 c4 08             	add    $0x8,%esp
  801244:	6a 02                	push   $0x2
  801246:	56                   	push   %esi
  801247:	e8 db fa ff ff       	call   800d27 <sys_env_set_status>
  80124c:	83 c4 10             	add    $0x10,%esp
  80124f:	85 c0                	test   %eax,%eax
  801251:	79 17                	jns    80126a <fork+0x109>
		panic("Status incorrecto de enviroment");
  801253:	83 ec 04             	sub    $0x4,%esp
  801256:	68 10 2a 80 00       	push   $0x802a10
  80125b:	68 c5 00 00 00       	push   $0xc5
  801260:	68 e0 28 80 00       	push   $0x8028e0
  801265:	e8 bc ef ff ff       	call   800226 <_panic>

	return envid;
  80126a:	89 f0                	mov    %esi,%eax
	
}
  80126c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80126f:	5b                   	pop    %ebx
  801270:	5e                   	pop    %esi
  801271:	5f                   	pop    %edi
  801272:	5d                   	pop    %ebp
  801273:	c3                   	ret    

00801274 <sfork>:


// Challenge!
int
sfork(void)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
  801277:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80127a:	68 d0 29 80 00       	push   $0x8029d0
  80127f:	68 d1 00 00 00       	push   $0xd1
  801284:	68 e0 28 80 00       	push   $0x8028e0
  801289:	e8 98 ef ff ff       	call   800226 <_panic>

0080128e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	05 00 00 00 30       	add    $0x30000000,%eax
  801299:	c1 e8 0c             	shr    $0xc,%eax
}
  80129c:	5d                   	pop    %ebp
  80129d:	c3                   	ret    

0080129e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  8012a1:	ff 75 08             	pushl  0x8(%ebp)
  8012a4:	e8 e5 ff ff ff       	call   80128e <fd2num>
  8012a9:	83 c4 04             	add    $0x4,%esp
  8012ac:	c1 e0 0c             	shl    $0xc,%eax
  8012af:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012b4:	c9                   	leave  
  8012b5:	c3                   	ret    

008012b6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
  8012b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012bc:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012c1:	89 c2                	mov    %eax,%edx
  8012c3:	c1 ea 16             	shr    $0x16,%edx
  8012c6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012cd:	f6 c2 01             	test   $0x1,%dl
  8012d0:	74 11                	je     8012e3 <fd_alloc+0x2d>
  8012d2:	89 c2                	mov    %eax,%edx
  8012d4:	c1 ea 0c             	shr    $0xc,%edx
  8012d7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012de:	f6 c2 01             	test   $0x1,%dl
  8012e1:	75 09                	jne    8012ec <fd_alloc+0x36>
			*fd_store = fd;
  8012e3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ea:	eb 17                	jmp    801303 <fd_alloc+0x4d>
  8012ec:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8012f1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012f6:	75 c9                	jne    8012c1 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012f8:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8012fe:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801303:	5d                   	pop    %ebp
  801304:	c3                   	ret    

00801305 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801305:	55                   	push   %ebp
  801306:	89 e5                	mov    %esp,%ebp
  801308:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80130b:	83 f8 1f             	cmp    $0x1f,%eax
  80130e:	77 36                	ja     801346 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801310:	c1 e0 0c             	shl    $0xc,%eax
  801313:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801318:	89 c2                	mov    %eax,%edx
  80131a:	c1 ea 16             	shr    $0x16,%edx
  80131d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801324:	f6 c2 01             	test   $0x1,%dl
  801327:	74 24                	je     80134d <fd_lookup+0x48>
  801329:	89 c2                	mov    %eax,%edx
  80132b:	c1 ea 0c             	shr    $0xc,%edx
  80132e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801335:	f6 c2 01             	test   $0x1,%dl
  801338:	74 1a                	je     801354 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80133a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133d:	89 02                	mov    %eax,(%edx)
	return 0;
  80133f:	b8 00 00 00 00       	mov    $0x0,%eax
  801344:	eb 13                	jmp    801359 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801346:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80134b:	eb 0c                	jmp    801359 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80134d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801352:	eb 05                	jmp    801359 <fd_lookup+0x54>
  801354:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  801359:	5d                   	pop    %ebp
  80135a:	c3                   	ret    

0080135b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	83 ec 08             	sub    $0x8,%esp
  801361:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801364:	ba ac 2a 80 00       	mov    $0x802aac,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801369:	eb 13                	jmp    80137e <dev_lookup+0x23>
  80136b:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  80136e:	39 08                	cmp    %ecx,(%eax)
  801370:	75 0c                	jne    80137e <dev_lookup+0x23>
			*dev = devtab[i];
  801372:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801375:	89 01                	mov    %eax,(%ecx)
			return 0;
  801377:	b8 00 00 00 00       	mov    $0x0,%eax
  80137c:	eb 2e                	jmp    8013ac <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80137e:	8b 02                	mov    (%edx),%eax
  801380:	85 c0                	test   %eax,%eax
  801382:	75 e7                	jne    80136b <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801384:	a1 20 44 80 00       	mov    0x804420,%eax
  801389:	8b 40 48             	mov    0x48(%eax),%eax
  80138c:	83 ec 04             	sub    $0x4,%esp
  80138f:	51                   	push   %ecx
  801390:	50                   	push   %eax
  801391:	68 30 2a 80 00       	push   $0x802a30
  801396:	e8 64 ef ff ff       	call   8002ff <cprintf>
	*dev = 0;
  80139b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013a4:	83 c4 10             	add    $0x10,%esp
  8013a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013ac:	c9                   	leave  
  8013ad:	c3                   	ret    

008013ae <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
  8013b1:	56                   	push   %esi
  8013b2:	53                   	push   %ebx
  8013b3:	83 ec 10             	sub    $0x10,%esp
  8013b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8013b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013bc:	56                   	push   %esi
  8013bd:	e8 cc fe ff ff       	call   80128e <fd2num>
  8013c2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8013c5:	89 14 24             	mov    %edx,(%esp)
  8013c8:	50                   	push   %eax
  8013c9:	e8 37 ff ff ff       	call   801305 <fd_lookup>
  8013ce:	83 c4 08             	add    $0x8,%esp
  8013d1:	85 c0                	test   %eax,%eax
  8013d3:	78 05                	js     8013da <fd_close+0x2c>
	    || fd != fd2)
  8013d5:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8013d8:	74 0c                	je     8013e6 <fd_close+0x38>
		return (must_exist ? r : 0);
  8013da:	84 db                	test   %bl,%bl
  8013dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8013e1:	0f 44 c2             	cmove  %edx,%eax
  8013e4:	eb 41                	jmp    801427 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013e6:	83 ec 08             	sub    $0x8,%esp
  8013e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013ec:	50                   	push   %eax
  8013ed:	ff 36                	pushl  (%esi)
  8013ef:	e8 67 ff ff ff       	call   80135b <dev_lookup>
  8013f4:	89 c3                	mov    %eax,%ebx
  8013f6:	83 c4 10             	add    $0x10,%esp
  8013f9:	85 c0                	test   %eax,%eax
  8013fb:	78 1a                	js     801417 <fd_close+0x69>
		if (dev->dev_close)
  8013fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801400:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801403:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801408:	85 c0                	test   %eax,%eax
  80140a:	74 0b                	je     801417 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  80140c:	83 ec 0c             	sub    $0xc,%esp
  80140f:	56                   	push   %esi
  801410:	ff d0                	call   *%eax
  801412:	89 c3                	mov    %eax,%ebx
  801414:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801417:	83 ec 08             	sub    $0x8,%esp
  80141a:	56                   	push   %esi
  80141b:	6a 00                	push   $0x0
  80141d:	e8 e2 f8 ff ff       	call   800d04 <sys_page_unmap>
	return r;
  801422:	83 c4 10             	add    $0x10,%esp
  801425:	89 d8                	mov    %ebx,%eax
}
  801427:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80142a:	5b                   	pop    %ebx
  80142b:	5e                   	pop    %esi
  80142c:	5d                   	pop    %ebp
  80142d:	c3                   	ret    

0080142e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
  801431:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801434:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801437:	50                   	push   %eax
  801438:	ff 75 08             	pushl  0x8(%ebp)
  80143b:	e8 c5 fe ff ff       	call   801305 <fd_lookup>
  801440:	83 c4 08             	add    $0x8,%esp
  801443:	85 c0                	test   %eax,%eax
  801445:	78 10                	js     801457 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801447:	83 ec 08             	sub    $0x8,%esp
  80144a:	6a 01                	push   $0x1
  80144c:	ff 75 f4             	pushl  -0xc(%ebp)
  80144f:	e8 5a ff ff ff       	call   8013ae <fd_close>
  801454:	83 c4 10             	add    $0x10,%esp
}
  801457:	c9                   	leave  
  801458:	c3                   	ret    

00801459 <close_all>:

void
close_all(void)
{
  801459:	55                   	push   %ebp
  80145a:	89 e5                	mov    %esp,%ebp
  80145c:	53                   	push   %ebx
  80145d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801460:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801465:	83 ec 0c             	sub    $0xc,%esp
  801468:	53                   	push   %ebx
  801469:	e8 c0 ff ff ff       	call   80142e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80146e:	83 c3 01             	add    $0x1,%ebx
  801471:	83 c4 10             	add    $0x10,%esp
  801474:	83 fb 20             	cmp    $0x20,%ebx
  801477:	75 ec                	jne    801465 <close_all+0xc>
		close(i);
}
  801479:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	57                   	push   %edi
  801482:	56                   	push   %esi
  801483:	53                   	push   %ebx
  801484:	83 ec 2c             	sub    $0x2c,%esp
  801487:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80148a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80148d:	50                   	push   %eax
  80148e:	ff 75 08             	pushl  0x8(%ebp)
  801491:	e8 6f fe ff ff       	call   801305 <fd_lookup>
  801496:	83 c4 08             	add    $0x8,%esp
  801499:	85 c0                	test   %eax,%eax
  80149b:	0f 88 c1 00 00 00    	js     801562 <dup+0xe4>
		return r;
	close(newfdnum);
  8014a1:	83 ec 0c             	sub    $0xc,%esp
  8014a4:	56                   	push   %esi
  8014a5:	e8 84 ff ff ff       	call   80142e <close>

	newfd = INDEX2FD(newfdnum);
  8014aa:	89 f3                	mov    %esi,%ebx
  8014ac:	c1 e3 0c             	shl    $0xc,%ebx
  8014af:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8014b5:	83 c4 04             	add    $0x4,%esp
  8014b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014bb:	e8 de fd ff ff       	call   80129e <fd2data>
  8014c0:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  8014c2:	89 1c 24             	mov    %ebx,(%esp)
  8014c5:	e8 d4 fd ff ff       	call   80129e <fd2data>
  8014ca:	83 c4 10             	add    $0x10,%esp
  8014cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014d0:	89 f8                	mov    %edi,%eax
  8014d2:	c1 e8 16             	shr    $0x16,%eax
  8014d5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014dc:	a8 01                	test   $0x1,%al
  8014de:	74 37                	je     801517 <dup+0x99>
  8014e0:	89 f8                	mov    %edi,%eax
  8014e2:	c1 e8 0c             	shr    $0xc,%eax
  8014e5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014ec:	f6 c2 01             	test   $0x1,%dl
  8014ef:	74 26                	je     801517 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014f1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014f8:	83 ec 0c             	sub    $0xc,%esp
  8014fb:	25 07 0e 00 00       	and    $0xe07,%eax
  801500:	50                   	push   %eax
  801501:	ff 75 d4             	pushl  -0x2c(%ebp)
  801504:	6a 00                	push   $0x0
  801506:	57                   	push   %edi
  801507:	6a 00                	push   $0x0
  801509:	e8 d0 f7 ff ff       	call   800cde <sys_page_map>
  80150e:	89 c7                	mov    %eax,%edi
  801510:	83 c4 20             	add    $0x20,%esp
  801513:	85 c0                	test   %eax,%eax
  801515:	78 2e                	js     801545 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801517:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80151a:	89 d0                	mov    %edx,%eax
  80151c:	c1 e8 0c             	shr    $0xc,%eax
  80151f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801526:	83 ec 0c             	sub    $0xc,%esp
  801529:	25 07 0e 00 00       	and    $0xe07,%eax
  80152e:	50                   	push   %eax
  80152f:	53                   	push   %ebx
  801530:	6a 00                	push   $0x0
  801532:	52                   	push   %edx
  801533:	6a 00                	push   $0x0
  801535:	e8 a4 f7 ff ff       	call   800cde <sys_page_map>
  80153a:	89 c7                	mov    %eax,%edi
  80153c:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  80153f:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801541:	85 ff                	test   %edi,%edi
  801543:	79 1d                	jns    801562 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801545:	83 ec 08             	sub    $0x8,%esp
  801548:	53                   	push   %ebx
  801549:	6a 00                	push   $0x0
  80154b:	e8 b4 f7 ff ff       	call   800d04 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801550:	83 c4 08             	add    $0x8,%esp
  801553:	ff 75 d4             	pushl  -0x2c(%ebp)
  801556:	6a 00                	push   $0x0
  801558:	e8 a7 f7 ff ff       	call   800d04 <sys_page_unmap>
	return r;
  80155d:	83 c4 10             	add    $0x10,%esp
  801560:	89 f8                	mov    %edi,%eax
}
  801562:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801565:	5b                   	pop    %ebx
  801566:	5e                   	pop    %esi
  801567:	5f                   	pop    %edi
  801568:	5d                   	pop    %ebp
  801569:	c3                   	ret    

0080156a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	53                   	push   %ebx
  80156e:	83 ec 14             	sub    $0x14,%esp
  801571:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801574:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801577:	50                   	push   %eax
  801578:	53                   	push   %ebx
  801579:	e8 87 fd ff ff       	call   801305 <fd_lookup>
  80157e:	83 c4 08             	add    $0x8,%esp
  801581:	89 c2                	mov    %eax,%edx
  801583:	85 c0                	test   %eax,%eax
  801585:	78 6d                	js     8015f4 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801587:	83 ec 08             	sub    $0x8,%esp
  80158a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80158d:	50                   	push   %eax
  80158e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801591:	ff 30                	pushl  (%eax)
  801593:	e8 c3 fd ff ff       	call   80135b <dev_lookup>
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	85 c0                	test   %eax,%eax
  80159d:	78 4c                	js     8015eb <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80159f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015a2:	8b 42 08             	mov    0x8(%edx),%eax
  8015a5:	83 e0 03             	and    $0x3,%eax
  8015a8:	83 f8 01             	cmp    $0x1,%eax
  8015ab:	75 21                	jne    8015ce <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015ad:	a1 20 44 80 00       	mov    0x804420,%eax
  8015b2:	8b 40 48             	mov    0x48(%eax),%eax
  8015b5:	83 ec 04             	sub    $0x4,%esp
  8015b8:	53                   	push   %ebx
  8015b9:	50                   	push   %eax
  8015ba:	68 71 2a 80 00       	push   $0x802a71
  8015bf:	e8 3b ed ff ff       	call   8002ff <cprintf>
		return -E_INVAL;
  8015c4:	83 c4 10             	add    $0x10,%esp
  8015c7:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8015cc:	eb 26                	jmp    8015f4 <read+0x8a>
	}
	if (!dev->dev_read)
  8015ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d1:	8b 40 08             	mov    0x8(%eax),%eax
  8015d4:	85 c0                	test   %eax,%eax
  8015d6:	74 17                	je     8015ef <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015d8:	83 ec 04             	sub    $0x4,%esp
  8015db:	ff 75 10             	pushl  0x10(%ebp)
  8015de:	ff 75 0c             	pushl  0xc(%ebp)
  8015e1:	52                   	push   %edx
  8015e2:	ff d0                	call   *%eax
  8015e4:	89 c2                	mov    %eax,%edx
  8015e6:	83 c4 10             	add    $0x10,%esp
  8015e9:	eb 09                	jmp    8015f4 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015eb:	89 c2                	mov    %eax,%edx
  8015ed:	eb 05                	jmp    8015f4 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8015ef:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  8015f4:	89 d0                	mov    %edx,%eax
  8015f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    

008015fb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	57                   	push   %edi
  8015ff:	56                   	push   %esi
  801600:	53                   	push   %ebx
  801601:	83 ec 0c             	sub    $0xc,%esp
  801604:	8b 7d 08             	mov    0x8(%ebp),%edi
  801607:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80160a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80160f:	eb 21                	jmp    801632 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801611:	83 ec 04             	sub    $0x4,%esp
  801614:	89 f0                	mov    %esi,%eax
  801616:	29 d8                	sub    %ebx,%eax
  801618:	50                   	push   %eax
  801619:	89 d8                	mov    %ebx,%eax
  80161b:	03 45 0c             	add    0xc(%ebp),%eax
  80161e:	50                   	push   %eax
  80161f:	57                   	push   %edi
  801620:	e8 45 ff ff ff       	call   80156a <read>
		if (m < 0)
  801625:	83 c4 10             	add    $0x10,%esp
  801628:	85 c0                	test   %eax,%eax
  80162a:	78 10                	js     80163c <readn+0x41>
			return m;
		if (m == 0)
  80162c:	85 c0                	test   %eax,%eax
  80162e:	74 0a                	je     80163a <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801630:	01 c3                	add    %eax,%ebx
  801632:	39 f3                	cmp    %esi,%ebx
  801634:	72 db                	jb     801611 <readn+0x16>
  801636:	89 d8                	mov    %ebx,%eax
  801638:	eb 02                	jmp    80163c <readn+0x41>
  80163a:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80163c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80163f:	5b                   	pop    %ebx
  801640:	5e                   	pop    %esi
  801641:	5f                   	pop    %edi
  801642:	5d                   	pop    %ebp
  801643:	c3                   	ret    

00801644 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
  801647:	53                   	push   %ebx
  801648:	83 ec 14             	sub    $0x14,%esp
  80164b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80164e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801651:	50                   	push   %eax
  801652:	53                   	push   %ebx
  801653:	e8 ad fc ff ff       	call   801305 <fd_lookup>
  801658:	83 c4 08             	add    $0x8,%esp
  80165b:	89 c2                	mov    %eax,%edx
  80165d:	85 c0                	test   %eax,%eax
  80165f:	78 68                	js     8016c9 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801661:	83 ec 08             	sub    $0x8,%esp
  801664:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801667:	50                   	push   %eax
  801668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166b:	ff 30                	pushl  (%eax)
  80166d:	e8 e9 fc ff ff       	call   80135b <dev_lookup>
  801672:	83 c4 10             	add    $0x10,%esp
  801675:	85 c0                	test   %eax,%eax
  801677:	78 47                	js     8016c0 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801679:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801680:	75 21                	jne    8016a3 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801682:	a1 20 44 80 00       	mov    0x804420,%eax
  801687:	8b 40 48             	mov    0x48(%eax),%eax
  80168a:	83 ec 04             	sub    $0x4,%esp
  80168d:	53                   	push   %ebx
  80168e:	50                   	push   %eax
  80168f:	68 8d 2a 80 00       	push   $0x802a8d
  801694:	e8 66 ec ff ff       	call   8002ff <cprintf>
		return -E_INVAL;
  801699:	83 c4 10             	add    $0x10,%esp
  80169c:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8016a1:	eb 26                	jmp    8016c9 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016a6:	8b 52 0c             	mov    0xc(%edx),%edx
  8016a9:	85 d2                	test   %edx,%edx
  8016ab:	74 17                	je     8016c4 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016ad:	83 ec 04             	sub    $0x4,%esp
  8016b0:	ff 75 10             	pushl  0x10(%ebp)
  8016b3:	ff 75 0c             	pushl  0xc(%ebp)
  8016b6:	50                   	push   %eax
  8016b7:	ff d2                	call   *%edx
  8016b9:	89 c2                	mov    %eax,%edx
  8016bb:	83 c4 10             	add    $0x10,%esp
  8016be:	eb 09                	jmp    8016c9 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c0:	89 c2                	mov    %eax,%edx
  8016c2:	eb 05                	jmp    8016c9 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8016c4:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  8016c9:	89 d0                	mov    %edx,%eax
  8016cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ce:	c9                   	leave  
  8016cf:	c3                   	ret    

008016d0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
  8016d3:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016d6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8016d9:	50                   	push   %eax
  8016da:	ff 75 08             	pushl  0x8(%ebp)
  8016dd:	e8 23 fc ff ff       	call   801305 <fd_lookup>
  8016e2:	83 c4 08             	add    $0x8,%esp
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	78 0e                	js     8016f7 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8016e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ef:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	53                   	push   %ebx
  8016fd:	83 ec 14             	sub    $0x14,%esp
  801700:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801703:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801706:	50                   	push   %eax
  801707:	53                   	push   %ebx
  801708:	e8 f8 fb ff ff       	call   801305 <fd_lookup>
  80170d:	83 c4 08             	add    $0x8,%esp
  801710:	89 c2                	mov    %eax,%edx
  801712:	85 c0                	test   %eax,%eax
  801714:	78 65                	js     80177b <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801716:	83 ec 08             	sub    $0x8,%esp
  801719:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80171c:	50                   	push   %eax
  80171d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801720:	ff 30                	pushl  (%eax)
  801722:	e8 34 fc ff ff       	call   80135b <dev_lookup>
  801727:	83 c4 10             	add    $0x10,%esp
  80172a:	85 c0                	test   %eax,%eax
  80172c:	78 44                	js     801772 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80172e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801731:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801735:	75 21                	jne    801758 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801737:	a1 20 44 80 00       	mov    0x804420,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80173c:	8b 40 48             	mov    0x48(%eax),%eax
  80173f:	83 ec 04             	sub    $0x4,%esp
  801742:	53                   	push   %ebx
  801743:	50                   	push   %eax
  801744:	68 50 2a 80 00       	push   $0x802a50
  801749:	e8 b1 eb ff ff       	call   8002ff <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80174e:	83 c4 10             	add    $0x10,%esp
  801751:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801756:	eb 23                	jmp    80177b <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  801758:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80175b:	8b 52 18             	mov    0x18(%edx),%edx
  80175e:	85 d2                	test   %edx,%edx
  801760:	74 14                	je     801776 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801762:	83 ec 08             	sub    $0x8,%esp
  801765:	ff 75 0c             	pushl  0xc(%ebp)
  801768:	50                   	push   %eax
  801769:	ff d2                	call   *%edx
  80176b:	89 c2                	mov    %eax,%edx
  80176d:	83 c4 10             	add    $0x10,%esp
  801770:	eb 09                	jmp    80177b <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801772:	89 c2                	mov    %eax,%edx
  801774:	eb 05                	jmp    80177b <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801776:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  80177b:	89 d0                	mov    %edx,%eax
  80177d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	53                   	push   %ebx
  801786:	83 ec 14             	sub    $0x14,%esp
  801789:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80178c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80178f:	50                   	push   %eax
  801790:	ff 75 08             	pushl  0x8(%ebp)
  801793:	e8 6d fb ff ff       	call   801305 <fd_lookup>
  801798:	83 c4 08             	add    $0x8,%esp
  80179b:	89 c2                	mov    %eax,%edx
  80179d:	85 c0                	test   %eax,%eax
  80179f:	78 58                	js     8017f9 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017a1:	83 ec 08             	sub    $0x8,%esp
  8017a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a7:	50                   	push   %eax
  8017a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ab:	ff 30                	pushl  (%eax)
  8017ad:	e8 a9 fb ff ff       	call   80135b <dev_lookup>
  8017b2:	83 c4 10             	add    $0x10,%esp
  8017b5:	85 c0                	test   %eax,%eax
  8017b7:	78 37                	js     8017f0 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  8017b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017bc:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017c0:	74 32                	je     8017f4 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017c2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017c5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017cc:	00 00 00 
	stat->st_isdir = 0;
  8017cf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017d6:	00 00 00 
	stat->st_dev = dev;
  8017d9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017df:	83 ec 08             	sub    $0x8,%esp
  8017e2:	53                   	push   %ebx
  8017e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8017e6:	ff 50 14             	call   *0x14(%eax)
  8017e9:	89 c2                	mov    %eax,%edx
  8017eb:	83 c4 10             	add    $0x10,%esp
  8017ee:	eb 09                	jmp    8017f9 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017f0:	89 c2                	mov    %eax,%edx
  8017f2:	eb 05                	jmp    8017f9 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8017f4:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8017f9:	89 d0                	mov    %edx,%eax
  8017fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	56                   	push   %esi
  801804:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801805:	83 ec 08             	sub    $0x8,%esp
  801808:	6a 00                	push   $0x0
  80180a:	ff 75 08             	pushl  0x8(%ebp)
  80180d:	e8 06 02 00 00       	call   801a18 <open>
  801812:	89 c3                	mov    %eax,%ebx
  801814:	83 c4 10             	add    $0x10,%esp
  801817:	85 c0                	test   %eax,%eax
  801819:	78 1b                	js     801836 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80181b:	83 ec 08             	sub    $0x8,%esp
  80181e:	ff 75 0c             	pushl  0xc(%ebp)
  801821:	50                   	push   %eax
  801822:	e8 5b ff ff ff       	call   801782 <fstat>
  801827:	89 c6                	mov    %eax,%esi
	close(fd);
  801829:	89 1c 24             	mov    %ebx,(%esp)
  80182c:	e8 fd fb ff ff       	call   80142e <close>
	return r;
  801831:	83 c4 10             	add    $0x10,%esp
  801834:	89 f0                	mov    %esi,%eax
}
  801836:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801839:	5b                   	pop    %ebx
  80183a:	5e                   	pop    %esi
  80183b:	5d                   	pop    %ebp
  80183c:	c3                   	ret    

0080183d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	56                   	push   %esi
  801841:	53                   	push   %ebx
  801842:	89 c6                	mov    %eax,%esi
  801844:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801846:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80184d:	75 12                	jne    801861 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80184f:	83 ec 0c             	sub    $0xc,%esp
  801852:	6a 01                	push   $0x1
  801854:	e8 e3 08 00 00       	call   80213c <ipc_find_env>
  801859:	a3 00 40 80 00       	mov    %eax,0x804000
  80185e:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801861:	6a 07                	push   $0x7
  801863:	68 00 50 80 00       	push   $0x805000
  801868:	56                   	push   %esi
  801869:	ff 35 00 40 80 00    	pushl  0x804000
  80186f:	e8 74 08 00 00       	call   8020e8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801874:	83 c4 0c             	add    $0xc,%esp
  801877:	6a 00                	push   $0x0
  801879:	53                   	push   %ebx
  80187a:	6a 00                	push   $0x0
  80187c:	e8 fc 07 00 00       	call   80207d <ipc_recv>
}
  801881:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801884:	5b                   	pop    %ebx
  801885:	5e                   	pop    %esi
  801886:	5d                   	pop    %ebp
  801887:	c3                   	ret    

00801888 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	8b 40 0c             	mov    0xc(%eax),%eax
  801894:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801899:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189c:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a6:	b8 02 00 00 00       	mov    $0x2,%eax
  8018ab:	e8 8d ff ff ff       	call   80183d <fsipc>
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8018be:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c8:	b8 06 00 00 00       	mov    $0x6,%eax
  8018cd:	e8 6b ff ff ff       	call   80183d <fsipc>
}
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    

008018d4 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
  8018d7:	53                   	push   %ebx
  8018d8:	83 ec 04             	sub    $0x4,%esp
  8018db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8018e4:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ee:	b8 05 00 00 00       	mov    $0x5,%eax
  8018f3:	e8 45 ff ff ff       	call   80183d <fsipc>
  8018f8:	85 c0                	test   %eax,%eax
  8018fa:	78 2c                	js     801928 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018fc:	83 ec 08             	sub    $0x8,%esp
  8018ff:	68 00 50 80 00       	push   $0x805000
  801904:	53                   	push   %ebx
  801905:	e8 67 ef ff ff       	call   800871 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80190a:	a1 80 50 80 00       	mov    0x805080,%eax
  80190f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801915:	a1 84 50 80 00       	mov    0x805084,%eax
  80191a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801920:	83 c4 10             	add    $0x10,%esp
  801923:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801928:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
  801930:	83 ec 08             	sub    $0x8,%esp
  801933:	8b 55 0c             	mov    0xc(%ebp),%edx
  801936:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801939:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80193c:	8b 49 0c             	mov    0xc(%ecx),%ecx
  80193f:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  801945:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80194a:	76 22                	jbe    80196e <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  80194c:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  801953:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  801956:	83 ec 04             	sub    $0x4,%esp
  801959:	68 f8 0f 00 00       	push   $0xff8
  80195e:	52                   	push   %edx
  80195f:	68 08 50 80 00       	push   $0x805008
  801964:	e8 9b f0 ff ff       	call   800a04 <memmove>
  801969:	83 c4 10             	add    $0x10,%esp
  80196c:	eb 17                	jmp    801985 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  80196e:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  801973:	83 ec 04             	sub    $0x4,%esp
  801976:	50                   	push   %eax
  801977:	52                   	push   %edx
  801978:	68 08 50 80 00       	push   $0x805008
  80197d:	e8 82 f0 ff ff       	call   800a04 <memmove>
  801982:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  801985:	ba 00 00 00 00       	mov    $0x0,%edx
  80198a:	b8 04 00 00 00       	mov    $0x4,%eax
  80198f:	e8 a9 fe ff ff       	call   80183d <fsipc>
	if (result < 0)
		return result;

	return result;
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	56                   	push   %esi
  80199a:	53                   	push   %ebx
  80199b:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8019a4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019a9:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019af:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b4:	b8 03 00 00 00       	mov    $0x3,%eax
  8019b9:	e8 7f fe ff ff       	call   80183d <fsipc>
  8019be:	89 c3                	mov    %eax,%ebx
  8019c0:	85 c0                	test   %eax,%eax
  8019c2:	78 4b                	js     801a0f <devfile_read+0x79>
		return r;
	assert(r <= n);
  8019c4:	39 c6                	cmp    %eax,%esi
  8019c6:	73 16                	jae    8019de <devfile_read+0x48>
  8019c8:	68 bc 2a 80 00       	push   $0x802abc
  8019cd:	68 c3 2a 80 00       	push   $0x802ac3
  8019d2:	6a 7c                	push   $0x7c
  8019d4:	68 d8 2a 80 00       	push   $0x802ad8
  8019d9:	e8 48 e8 ff ff       	call   800226 <_panic>
	assert(r <= PGSIZE);
  8019de:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019e3:	7e 16                	jle    8019fb <devfile_read+0x65>
  8019e5:	68 e3 2a 80 00       	push   $0x802ae3
  8019ea:	68 c3 2a 80 00       	push   $0x802ac3
  8019ef:	6a 7d                	push   $0x7d
  8019f1:	68 d8 2a 80 00       	push   $0x802ad8
  8019f6:	e8 2b e8 ff ff       	call   800226 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019fb:	83 ec 04             	sub    $0x4,%esp
  8019fe:	50                   	push   %eax
  8019ff:	68 00 50 80 00       	push   $0x805000
  801a04:	ff 75 0c             	pushl  0xc(%ebp)
  801a07:	e8 f8 ef ff ff       	call   800a04 <memmove>
	return r;
  801a0c:	83 c4 10             	add    $0x10,%esp
}
  801a0f:	89 d8                	mov    %ebx,%eax
  801a11:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a14:	5b                   	pop    %ebx
  801a15:	5e                   	pop    %esi
  801a16:	5d                   	pop    %ebp
  801a17:	c3                   	ret    

00801a18 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	53                   	push   %ebx
  801a1c:	83 ec 20             	sub    $0x20,%esp
  801a1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801a22:	53                   	push   %ebx
  801a23:	e8 10 ee ff ff       	call   800838 <strlen>
  801a28:	83 c4 10             	add    $0x10,%esp
  801a2b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a30:	7f 67                	jg     801a99 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801a32:	83 ec 0c             	sub    $0xc,%esp
  801a35:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a38:	50                   	push   %eax
  801a39:	e8 78 f8 ff ff       	call   8012b6 <fd_alloc>
  801a3e:	83 c4 10             	add    $0x10,%esp
		return r;
  801a41:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801a43:	85 c0                	test   %eax,%eax
  801a45:	78 57                	js     801a9e <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801a47:	83 ec 08             	sub    $0x8,%esp
  801a4a:	53                   	push   %ebx
  801a4b:	68 00 50 80 00       	push   $0x805000
  801a50:	e8 1c ee ff ff       	call   800871 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a55:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a58:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a60:	b8 01 00 00 00       	mov    $0x1,%eax
  801a65:	e8 d3 fd ff ff       	call   80183d <fsipc>
  801a6a:	89 c3                	mov    %eax,%ebx
  801a6c:	83 c4 10             	add    $0x10,%esp
  801a6f:	85 c0                	test   %eax,%eax
  801a71:	79 14                	jns    801a87 <open+0x6f>
		fd_close(fd, 0);
  801a73:	83 ec 08             	sub    $0x8,%esp
  801a76:	6a 00                	push   $0x0
  801a78:	ff 75 f4             	pushl  -0xc(%ebp)
  801a7b:	e8 2e f9 ff ff       	call   8013ae <fd_close>
		return r;
  801a80:	83 c4 10             	add    $0x10,%esp
  801a83:	89 da                	mov    %ebx,%edx
  801a85:	eb 17                	jmp    801a9e <open+0x86>
	}

	return fd2num(fd);
  801a87:	83 ec 0c             	sub    $0xc,%esp
  801a8a:	ff 75 f4             	pushl  -0xc(%ebp)
  801a8d:	e8 fc f7 ff ff       	call   80128e <fd2num>
  801a92:	89 c2                	mov    %eax,%edx
  801a94:	83 c4 10             	add    $0x10,%esp
  801a97:	eb 05                	jmp    801a9e <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801a99:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801a9e:	89 d0                	mov    %edx,%eax
  801aa0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
  801aa8:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801aab:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab0:	b8 08 00 00 00       	mov    $0x8,%eax
  801ab5:	e8 83 fd ff ff       	call   80183d <fsipc>
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	56                   	push   %esi
  801ac0:	53                   	push   %ebx
  801ac1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ac4:	83 ec 0c             	sub    $0xc,%esp
  801ac7:	ff 75 08             	pushl  0x8(%ebp)
  801aca:	e8 cf f7 ff ff       	call   80129e <fd2data>
  801acf:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ad1:	83 c4 08             	add    $0x8,%esp
  801ad4:	68 ef 2a 80 00       	push   $0x802aef
  801ad9:	53                   	push   %ebx
  801ada:	e8 92 ed ff ff       	call   800871 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801adf:	8b 46 04             	mov    0x4(%esi),%eax
  801ae2:	2b 06                	sub    (%esi),%eax
  801ae4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801aea:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801af1:	00 00 00 
	stat->st_dev = &devpipe;
  801af4:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801afb:	30 80 00 
	return 0;
}
  801afe:	b8 00 00 00 00       	mov    $0x0,%eax
  801b03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b06:	5b                   	pop    %ebx
  801b07:	5e                   	pop    %esi
  801b08:	5d                   	pop    %ebp
  801b09:	c3                   	ret    

00801b0a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	53                   	push   %ebx
  801b0e:	83 ec 0c             	sub    $0xc,%esp
  801b11:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b14:	53                   	push   %ebx
  801b15:	6a 00                	push   $0x0
  801b17:	e8 e8 f1 ff ff       	call   800d04 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b1c:	89 1c 24             	mov    %ebx,(%esp)
  801b1f:	e8 7a f7 ff ff       	call   80129e <fd2data>
  801b24:	83 c4 08             	add    $0x8,%esp
  801b27:	50                   	push   %eax
  801b28:	6a 00                	push   $0x0
  801b2a:	e8 d5 f1 ff ff       	call   800d04 <sys_page_unmap>
}
  801b2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
  801b37:	57                   	push   %edi
  801b38:	56                   	push   %esi
  801b39:	53                   	push   %ebx
  801b3a:	83 ec 1c             	sub    $0x1c,%esp
  801b3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801b40:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801b42:	a1 20 44 80 00       	mov    0x804420,%eax
  801b47:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801b4a:	83 ec 0c             	sub    $0xc,%esp
  801b4d:	ff 75 e0             	pushl  -0x20(%ebp)
  801b50:	e8 20 06 00 00       	call   802175 <pageref>
  801b55:	89 c3                	mov    %eax,%ebx
  801b57:	89 3c 24             	mov    %edi,(%esp)
  801b5a:	e8 16 06 00 00       	call   802175 <pageref>
  801b5f:	83 c4 10             	add    $0x10,%esp
  801b62:	39 c3                	cmp    %eax,%ebx
  801b64:	0f 94 c1             	sete   %cl
  801b67:	0f b6 c9             	movzbl %cl,%ecx
  801b6a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801b6d:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801b73:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b76:	39 ce                	cmp    %ecx,%esi
  801b78:	74 1b                	je     801b95 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801b7a:	39 c3                	cmp    %eax,%ebx
  801b7c:	75 c4                	jne    801b42 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b7e:	8b 42 58             	mov    0x58(%edx),%eax
  801b81:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b84:	50                   	push   %eax
  801b85:	56                   	push   %esi
  801b86:	68 f6 2a 80 00       	push   $0x802af6
  801b8b:	e8 6f e7 ff ff       	call   8002ff <cprintf>
  801b90:	83 c4 10             	add    $0x10,%esp
  801b93:	eb ad                	jmp    801b42 <_pipeisclosed+0xe>
	}
}
  801b95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b9b:	5b                   	pop    %ebx
  801b9c:	5e                   	pop    %esi
  801b9d:	5f                   	pop    %edi
  801b9e:	5d                   	pop    %ebp
  801b9f:	c3                   	ret    

00801ba0 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	57                   	push   %edi
  801ba4:	56                   	push   %esi
  801ba5:	53                   	push   %ebx
  801ba6:	83 ec 28             	sub    $0x28,%esp
  801ba9:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801bac:	56                   	push   %esi
  801bad:	e8 ec f6 ff ff       	call   80129e <fd2data>
  801bb2:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801bb4:	83 c4 10             	add    $0x10,%esp
  801bb7:	bf 00 00 00 00       	mov    $0x0,%edi
  801bbc:	eb 4b                	jmp    801c09 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801bbe:	89 da                	mov    %ebx,%edx
  801bc0:	89 f0                	mov    %esi,%eax
  801bc2:	e8 6d ff ff ff       	call   801b34 <_pipeisclosed>
  801bc7:	85 c0                	test   %eax,%eax
  801bc9:	75 48                	jne    801c13 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801bcb:	e8 c3 f0 ff ff       	call   800c93 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bd0:	8b 43 04             	mov    0x4(%ebx),%eax
  801bd3:	8b 0b                	mov    (%ebx),%ecx
  801bd5:	8d 51 20             	lea    0x20(%ecx),%edx
  801bd8:	39 d0                	cmp    %edx,%eax
  801bda:	73 e2                	jae    801bbe <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bdf:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801be3:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801be6:	89 c2                	mov    %eax,%edx
  801be8:	c1 fa 1f             	sar    $0x1f,%edx
  801beb:	89 d1                	mov    %edx,%ecx
  801bed:	c1 e9 1b             	shr    $0x1b,%ecx
  801bf0:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801bf3:	83 e2 1f             	and    $0x1f,%edx
  801bf6:	29 ca                	sub    %ecx,%edx
  801bf8:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801bfc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c00:	83 c0 01             	add    $0x1,%eax
  801c03:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c06:	83 c7 01             	add    $0x1,%edi
  801c09:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c0c:	75 c2                	jne    801bd0 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801c0e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c11:	eb 05                	jmp    801c18 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801c13:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801c18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c1b:	5b                   	pop    %ebx
  801c1c:	5e                   	pop    %esi
  801c1d:	5f                   	pop    %edi
  801c1e:	5d                   	pop    %ebp
  801c1f:	c3                   	ret    

00801c20 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	57                   	push   %edi
  801c24:	56                   	push   %esi
  801c25:	53                   	push   %ebx
  801c26:	83 ec 18             	sub    $0x18,%esp
  801c29:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801c2c:	57                   	push   %edi
  801c2d:	e8 6c f6 ff ff       	call   80129e <fd2data>
  801c32:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c34:	83 c4 10             	add    $0x10,%esp
  801c37:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c3c:	eb 3d                	jmp    801c7b <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801c3e:	85 db                	test   %ebx,%ebx
  801c40:	74 04                	je     801c46 <devpipe_read+0x26>
				return i;
  801c42:	89 d8                	mov    %ebx,%eax
  801c44:	eb 44                	jmp    801c8a <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801c46:	89 f2                	mov    %esi,%edx
  801c48:	89 f8                	mov    %edi,%eax
  801c4a:	e8 e5 fe ff ff       	call   801b34 <_pipeisclosed>
  801c4f:	85 c0                	test   %eax,%eax
  801c51:	75 32                	jne    801c85 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801c53:	e8 3b f0 ff ff       	call   800c93 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801c58:	8b 06                	mov    (%esi),%eax
  801c5a:	3b 46 04             	cmp    0x4(%esi),%eax
  801c5d:	74 df                	je     801c3e <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c5f:	99                   	cltd   
  801c60:	c1 ea 1b             	shr    $0x1b,%edx
  801c63:	01 d0                	add    %edx,%eax
  801c65:	83 e0 1f             	and    $0x1f,%eax
  801c68:	29 d0                	sub    %edx,%eax
  801c6a:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801c6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c72:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801c75:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c78:	83 c3 01             	add    $0x1,%ebx
  801c7b:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801c7e:	75 d8                	jne    801c58 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801c80:	8b 45 10             	mov    0x10(%ebp),%eax
  801c83:	eb 05                	jmp    801c8a <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801c85:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801c8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c8d:	5b                   	pop    %ebx
  801c8e:	5e                   	pop    %esi
  801c8f:	5f                   	pop    %edi
  801c90:	5d                   	pop    %ebp
  801c91:	c3                   	ret    

00801c92 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
  801c95:	56                   	push   %esi
  801c96:	53                   	push   %ebx
  801c97:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801c9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c9d:	50                   	push   %eax
  801c9e:	e8 13 f6 ff ff       	call   8012b6 <fd_alloc>
  801ca3:	83 c4 10             	add    $0x10,%esp
  801ca6:	89 c2                	mov    %eax,%edx
  801ca8:	85 c0                	test   %eax,%eax
  801caa:	0f 88 2c 01 00 00    	js     801ddc <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cb0:	83 ec 04             	sub    $0x4,%esp
  801cb3:	68 07 04 00 00       	push   $0x407
  801cb8:	ff 75 f4             	pushl  -0xc(%ebp)
  801cbb:	6a 00                	push   $0x0
  801cbd:	e8 f8 ef ff ff       	call   800cba <sys_page_alloc>
  801cc2:	83 c4 10             	add    $0x10,%esp
  801cc5:	89 c2                	mov    %eax,%edx
  801cc7:	85 c0                	test   %eax,%eax
  801cc9:	0f 88 0d 01 00 00    	js     801ddc <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801ccf:	83 ec 0c             	sub    $0xc,%esp
  801cd2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cd5:	50                   	push   %eax
  801cd6:	e8 db f5 ff ff       	call   8012b6 <fd_alloc>
  801cdb:	89 c3                	mov    %eax,%ebx
  801cdd:	83 c4 10             	add    $0x10,%esp
  801ce0:	85 c0                	test   %eax,%eax
  801ce2:	0f 88 e2 00 00 00    	js     801dca <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ce8:	83 ec 04             	sub    $0x4,%esp
  801ceb:	68 07 04 00 00       	push   $0x407
  801cf0:	ff 75 f0             	pushl  -0x10(%ebp)
  801cf3:	6a 00                	push   $0x0
  801cf5:	e8 c0 ef ff ff       	call   800cba <sys_page_alloc>
  801cfa:	89 c3                	mov    %eax,%ebx
  801cfc:	83 c4 10             	add    $0x10,%esp
  801cff:	85 c0                	test   %eax,%eax
  801d01:	0f 88 c3 00 00 00    	js     801dca <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801d07:	83 ec 0c             	sub    $0xc,%esp
  801d0a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d0d:	e8 8c f5 ff ff       	call   80129e <fd2data>
  801d12:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d14:	83 c4 0c             	add    $0xc,%esp
  801d17:	68 07 04 00 00       	push   $0x407
  801d1c:	50                   	push   %eax
  801d1d:	6a 00                	push   $0x0
  801d1f:	e8 96 ef ff ff       	call   800cba <sys_page_alloc>
  801d24:	89 c3                	mov    %eax,%ebx
  801d26:	83 c4 10             	add    $0x10,%esp
  801d29:	85 c0                	test   %eax,%eax
  801d2b:	0f 88 89 00 00 00    	js     801dba <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d31:	83 ec 0c             	sub    $0xc,%esp
  801d34:	ff 75 f0             	pushl  -0x10(%ebp)
  801d37:	e8 62 f5 ff ff       	call   80129e <fd2data>
  801d3c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d43:	50                   	push   %eax
  801d44:	6a 00                	push   $0x0
  801d46:	56                   	push   %esi
  801d47:	6a 00                	push   $0x0
  801d49:	e8 90 ef ff ff       	call   800cde <sys_page_map>
  801d4e:	89 c3                	mov    %eax,%ebx
  801d50:	83 c4 20             	add    $0x20,%esp
  801d53:	85 c0                	test   %eax,%eax
  801d55:	78 55                	js     801dac <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801d57:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d60:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d65:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801d6c:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d75:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801d81:	83 ec 0c             	sub    $0xc,%esp
  801d84:	ff 75 f4             	pushl  -0xc(%ebp)
  801d87:	e8 02 f5 ff ff       	call   80128e <fd2num>
  801d8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d8f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d91:	83 c4 04             	add    $0x4,%esp
  801d94:	ff 75 f0             	pushl  -0x10(%ebp)
  801d97:	e8 f2 f4 ff ff       	call   80128e <fd2num>
  801d9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d9f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801da2:	83 c4 10             	add    $0x10,%esp
  801da5:	ba 00 00 00 00       	mov    $0x0,%edx
  801daa:	eb 30                	jmp    801ddc <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801dac:	83 ec 08             	sub    $0x8,%esp
  801daf:	56                   	push   %esi
  801db0:	6a 00                	push   $0x0
  801db2:	e8 4d ef ff ff       	call   800d04 <sys_page_unmap>
  801db7:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801dba:	83 ec 08             	sub    $0x8,%esp
  801dbd:	ff 75 f0             	pushl  -0x10(%ebp)
  801dc0:	6a 00                	push   $0x0
  801dc2:	e8 3d ef ff ff       	call   800d04 <sys_page_unmap>
  801dc7:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801dca:	83 ec 08             	sub    $0x8,%esp
  801dcd:	ff 75 f4             	pushl  -0xc(%ebp)
  801dd0:	6a 00                	push   $0x0
  801dd2:	e8 2d ef ff ff       	call   800d04 <sys_page_unmap>
  801dd7:	83 c4 10             	add    $0x10,%esp
  801dda:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  801ddc:	89 d0                	mov    %edx,%eax
  801dde:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de1:	5b                   	pop    %ebx
  801de2:	5e                   	pop    %esi
  801de3:	5d                   	pop    %ebp
  801de4:	c3                   	ret    

00801de5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801deb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dee:	50                   	push   %eax
  801def:	ff 75 08             	pushl  0x8(%ebp)
  801df2:	e8 0e f5 ff ff       	call   801305 <fd_lookup>
  801df7:	83 c4 10             	add    $0x10,%esp
  801dfa:	85 c0                	test   %eax,%eax
  801dfc:	78 18                	js     801e16 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801dfe:	83 ec 0c             	sub    $0xc,%esp
  801e01:	ff 75 f4             	pushl  -0xc(%ebp)
  801e04:	e8 95 f4 ff ff       	call   80129e <fd2data>
	return _pipeisclosed(fd, p);
  801e09:	89 c2                	mov    %eax,%edx
  801e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0e:	e8 21 fd ff ff       	call   801b34 <_pipeisclosed>
  801e13:	83 c4 10             	add    $0x10,%esp
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	56                   	push   %esi
  801e1c:	53                   	push   %ebx
  801e1d:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801e20:	85 f6                	test   %esi,%esi
  801e22:	75 16                	jne    801e3a <wait+0x22>
  801e24:	68 0e 2b 80 00       	push   $0x802b0e
  801e29:	68 c3 2a 80 00       	push   $0x802ac3
  801e2e:	6a 09                	push   $0x9
  801e30:	68 19 2b 80 00       	push   $0x802b19
  801e35:	e8 ec e3 ff ff       	call   800226 <_panic>
	e = &envs[ENVX(envid)];
  801e3a:	89 f3                	mov    %esi,%ebx
  801e3c:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801e42:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  801e45:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801e4b:	eb 05                	jmp    801e52 <wait+0x3a>
		sys_yield();
  801e4d:	e8 41 ee ff ff       	call   800c93 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801e52:	8b 43 48             	mov    0x48(%ebx),%eax
  801e55:	39 c6                	cmp    %eax,%esi
  801e57:	75 07                	jne    801e60 <wait+0x48>
  801e59:	8b 43 54             	mov    0x54(%ebx),%eax
  801e5c:	85 c0                	test   %eax,%eax
  801e5e:	75 ed                	jne    801e4d <wait+0x35>
		sys_yield();
}
  801e60:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e63:	5b                   	pop    %ebx
  801e64:	5e                   	pop    %esi
  801e65:	5d                   	pop    %ebp
  801e66:	c3                   	ret    

00801e67 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801e6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6f:	5d                   	pop    %ebp
  801e70:	c3                   	ret    

00801e71 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
  801e74:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e77:	68 24 2b 80 00       	push   $0x802b24
  801e7c:	ff 75 0c             	pushl  0xc(%ebp)
  801e7f:	e8 ed e9 ff ff       	call   800871 <strcpy>
	return 0;
}
  801e84:	b8 00 00 00 00       	mov    $0x0,%eax
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	57                   	push   %edi
  801e8f:	56                   	push   %esi
  801e90:	53                   	push   %ebx
  801e91:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e97:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801e9c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801ea2:	eb 2d                	jmp    801ed1 <devcons_write+0x46>
		m = n - tot;
  801ea4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ea7:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801ea9:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801eac:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801eb1:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801eb4:	83 ec 04             	sub    $0x4,%esp
  801eb7:	53                   	push   %ebx
  801eb8:	03 45 0c             	add    0xc(%ebp),%eax
  801ebb:	50                   	push   %eax
  801ebc:	57                   	push   %edi
  801ebd:	e8 42 eb ff ff       	call   800a04 <memmove>
		sys_cputs(buf, m);
  801ec2:	83 c4 08             	add    $0x8,%esp
  801ec5:	53                   	push   %ebx
  801ec6:	57                   	push   %edi
  801ec7:	e8 37 ed ff ff       	call   800c03 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801ecc:	01 de                	add    %ebx,%esi
  801ece:	83 c4 10             	add    $0x10,%esp
  801ed1:	89 f0                	mov    %esi,%eax
  801ed3:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ed6:	72 cc                	jb     801ea4 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801ed8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801edb:	5b                   	pop    %ebx
  801edc:	5e                   	pop    %esi
  801edd:	5f                   	pop    %edi
  801ede:	5d                   	pop    %ebp
  801edf:	c3                   	ret    

00801ee0 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 08             	sub    $0x8,%esp
  801ee6:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801eeb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eef:	74 2a                	je     801f1b <devcons_read+0x3b>
  801ef1:	eb 05                	jmp    801ef8 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801ef3:	e8 9b ed ff ff       	call   800c93 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801ef8:	e8 2c ed ff ff       	call   800c29 <sys_cgetc>
  801efd:	85 c0                	test   %eax,%eax
  801eff:	74 f2                	je     801ef3 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801f01:	85 c0                	test   %eax,%eax
  801f03:	78 16                	js     801f1b <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801f05:	83 f8 04             	cmp    $0x4,%eax
  801f08:	74 0c                	je     801f16 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801f0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0d:	88 02                	mov    %al,(%edx)
	return 1;
  801f0f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f14:	eb 05                	jmp    801f1b <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801f16:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
  801f20:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801f29:	6a 01                	push   $0x1
  801f2b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f2e:	50                   	push   %eax
  801f2f:	e8 cf ec ff ff       	call   800c03 <sys_cputs>
}
  801f34:	83 c4 10             	add    $0x10,%esp
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <getchar>:

int
getchar(void)
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
  801f3c:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801f3f:	6a 01                	push   $0x1
  801f41:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f44:	50                   	push   %eax
  801f45:	6a 00                	push   $0x0
  801f47:	e8 1e f6 ff ff       	call   80156a <read>
	if (r < 0)
  801f4c:	83 c4 10             	add    $0x10,%esp
  801f4f:	85 c0                	test   %eax,%eax
  801f51:	78 0f                	js     801f62 <getchar+0x29>
		return r;
	if (r < 1)
  801f53:	85 c0                	test   %eax,%eax
  801f55:	7e 06                	jle    801f5d <getchar+0x24>
		return -E_EOF;
	return c;
  801f57:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801f5b:	eb 05                	jmp    801f62 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801f5d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f6d:	50                   	push   %eax
  801f6e:	ff 75 08             	pushl  0x8(%ebp)
  801f71:	e8 8f f3 ff ff       	call   801305 <fd_lookup>
  801f76:	83 c4 10             	add    $0x10,%esp
  801f79:	85 c0                	test   %eax,%eax
  801f7b:	78 11                	js     801f8e <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f80:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f86:	39 10                	cmp    %edx,(%eax)
  801f88:	0f 94 c0             	sete   %al
  801f8b:	0f b6 c0             	movzbl %al,%eax
}
  801f8e:	c9                   	leave  
  801f8f:	c3                   	ret    

00801f90 <opencons>:

int
opencons(void)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
  801f93:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801f96:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f99:	50                   	push   %eax
  801f9a:	e8 17 f3 ff ff       	call   8012b6 <fd_alloc>
  801f9f:	83 c4 10             	add    $0x10,%esp
		return r;
  801fa2:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801fa4:	85 c0                	test   %eax,%eax
  801fa6:	78 3e                	js     801fe6 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fa8:	83 ec 04             	sub    $0x4,%esp
  801fab:	68 07 04 00 00       	push   $0x407
  801fb0:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb3:	6a 00                	push   $0x0
  801fb5:	e8 00 ed ff ff       	call   800cba <sys_page_alloc>
  801fba:	83 c4 10             	add    $0x10,%esp
		return r;
  801fbd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fbf:	85 c0                	test   %eax,%eax
  801fc1:	78 23                	js     801fe6 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801fc3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801fd8:	83 ec 0c             	sub    $0xc,%esp
  801fdb:	50                   	push   %eax
  801fdc:	e8 ad f2 ff ff       	call   80128e <fd2num>
  801fe1:	89 c2                	mov    %eax,%edx
  801fe3:	83 c4 10             	add    $0x10,%esp
}
  801fe6:	89 d0                	mov    %edx,%eax
  801fe8:	c9                   	leave  
  801fe9:	c3                   	ret    

00801fea <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
  801fed:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801ff0:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801ff7:	75 2c                	jne    802025 <set_pgfault_handler+0x3b>
		// First time through!
		// LAB 4: Your code here.
		r = sys_page_alloc(0,(void *)(UXSTACKTOP - PGSIZE),PTE_P | PTE_U | PTE_W);
  801ff9:	83 ec 04             	sub    $0x4,%esp
  801ffc:	6a 07                	push   $0x7
  801ffe:	68 00 f0 bf ee       	push   $0xeebff000
  802003:	6a 00                	push   $0x0
  802005:	e8 b0 ec ff ff       	call   800cba <sys_page_alloc>
		if(r < 0)
  80200a:	83 c4 10             	add    $0x10,%esp
  80200d:	85 c0                	test   %eax,%eax
  80200f:	79 14                	jns    802025 <set_pgfault_handler+0x3b>
			panic("set_pgfault_handler: error in sys_page_alloc\n");	
  802011:	83 ec 04             	sub    $0x4,%esp
  802014:	68 30 2b 80 00       	push   $0x802b30
  802019:	6a 22                	push   $0x22
  80201b:	68 9c 2b 80 00       	push   $0x802b9c
  802020:	e8 01 e2 ff ff       	call   800226 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802025:	8b 45 08             	mov    0x8(%ebp),%eax
  802028:	a3 00 60 80 00       	mov    %eax,0x806000
	r = sys_env_set_pgfault_upcall(0, _pgfault_upcall); 
  80202d:	83 ec 08             	sub    $0x8,%esp
  802030:	68 59 20 80 00       	push   $0x802059
  802035:	6a 00                	push   $0x0
  802037:	e8 31 ed ff ff       	call   800d6d <sys_env_set_pgfault_upcall>
	if (r < 0)
  80203c:	83 c4 10             	add    $0x10,%esp
  80203f:	85 c0                	test   %eax,%eax
  802041:	79 14                	jns    802057 <set_pgfault_handler+0x6d>
		panic("set_pgfault_handler: error in sys_env_set_pgfault_upcall");
  802043:	83 ec 04             	sub    $0x4,%esp
  802046:	68 60 2b 80 00       	push   $0x802b60
  80204b:	6a 29                	push   $0x29
  80204d:	68 9c 2b 80 00       	push   $0x802b9c
  802052:	e8 cf e1 ff ff       	call   800226 <_panic>
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802059:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80205a:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  80205f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802061:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	subl $0x4, 0x30(%esp)
  802064:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  802069:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 0x28(%esp), %ebx 	
  80206d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  802071:	89 18                	mov    %ebx,(%eax)
	addl $0x8, %esp
  802073:	83 c4 08             	add    $0x8,%esp


	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  802076:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp 
  802077:	83 c4 04             	add    $0x4,%esp
	popfl
  80207a:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80207b:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80207c:	c3                   	ret    

0080207d <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
  802080:	56                   	push   %esi
  802081:	53                   	push   %ebx
  802082:	8b 75 08             	mov    0x8(%ebp),%esi
  802085:	8b 45 0c             	mov    0xc(%ebp),%eax
  802088:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  80208b:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  80208d:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802092:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  802095:	83 ec 0c             	sub    $0xc,%esp
  802098:	50                   	push   %eax
  802099:	e8 17 ed ff ff       	call   800db5 <sys_ipc_recv>
	if (from_env_store)
  80209e:	83 c4 10             	add    $0x10,%esp
  8020a1:	85 f6                	test   %esi,%esi
  8020a3:	74 0b                	je     8020b0 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  8020a5:	8b 15 20 44 80 00    	mov    0x804420,%edx
  8020ab:	8b 52 74             	mov    0x74(%edx),%edx
  8020ae:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8020b0:	85 db                	test   %ebx,%ebx
  8020b2:	74 0b                	je     8020bf <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  8020b4:	8b 15 20 44 80 00    	mov    0x804420,%edx
  8020ba:	8b 52 78             	mov    0x78(%edx),%edx
  8020bd:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  8020bf:	85 c0                	test   %eax,%eax
  8020c1:	79 16                	jns    8020d9 <ipc_recv+0x5c>
		if (from_env_store)
  8020c3:	85 f6                	test   %esi,%esi
  8020c5:	74 06                	je     8020cd <ipc_recv+0x50>
			*from_env_store = 0;
  8020c7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  8020cd:	85 db                	test   %ebx,%ebx
  8020cf:	74 10                	je     8020e1 <ipc_recv+0x64>
			*perm_store = 0;
  8020d1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8020d7:	eb 08                	jmp    8020e1 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  8020d9:	a1 20 44 80 00       	mov    0x804420,%eax
  8020de:	8b 40 70             	mov    0x70(%eax),%eax
}
  8020e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020e4:	5b                   	pop    %ebx
  8020e5:	5e                   	pop    %esi
  8020e6:	5d                   	pop    %ebp
  8020e7:	c3                   	ret    

008020e8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
  8020eb:	57                   	push   %edi
  8020ec:	56                   	push   %esi
  8020ed:	53                   	push   %ebx
  8020ee:	83 ec 0c             	sub    $0xc,%esp
  8020f1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020f4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  8020fa:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  8020fc:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802101:	0f 44 d8             	cmove  %eax,%ebx
  802104:	eb 1c                	jmp    802122 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  802106:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802109:	74 12                	je     80211d <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  80210b:	50                   	push   %eax
  80210c:	68 aa 2b 80 00       	push   $0x802baa
  802111:	6a 42                	push   $0x42
  802113:	68 c0 2b 80 00       	push   $0x802bc0
  802118:	e8 09 e1 ff ff       	call   800226 <_panic>
		sys_yield();
  80211d:	e8 71 eb ff ff       	call   800c93 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  802122:	ff 75 14             	pushl  0x14(%ebp)
  802125:	53                   	push   %ebx
  802126:	56                   	push   %esi
  802127:	57                   	push   %edi
  802128:	e8 63 ec ff ff       	call   800d90 <sys_ipc_try_send>
  80212d:	83 c4 10             	add    $0x10,%esp
  802130:	85 c0                	test   %eax,%eax
  802132:	75 d2                	jne    802106 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  802134:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802137:	5b                   	pop    %ebx
  802138:	5e                   	pop    %esi
  802139:	5f                   	pop    %edi
  80213a:	5d                   	pop    %ebp
  80213b:	c3                   	ret    

0080213c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802142:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802147:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80214a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802150:	8b 52 50             	mov    0x50(%edx),%edx
  802153:	39 ca                	cmp    %ecx,%edx
  802155:	75 0d                	jne    802164 <ipc_find_env+0x28>
			return envs[i].env_id;
  802157:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80215a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80215f:	8b 40 48             	mov    0x48(%eax),%eax
  802162:	eb 0f                	jmp    802173 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802164:	83 c0 01             	add    $0x1,%eax
  802167:	3d 00 04 00 00       	cmp    $0x400,%eax
  80216c:	75 d9                	jne    802147 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80216e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802173:	5d                   	pop    %ebp
  802174:	c3                   	ret    

00802175 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
  802178:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80217b:	89 d0                	mov    %edx,%eax
  80217d:	c1 e8 16             	shr    $0x16,%eax
  802180:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802187:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80218c:	f6 c1 01             	test   $0x1,%cl
  80218f:	74 1d                	je     8021ae <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802191:	c1 ea 0c             	shr    $0xc,%edx
  802194:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80219b:	f6 c2 01             	test   $0x1,%dl
  80219e:	74 0e                	je     8021ae <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021a0:	c1 ea 0c             	shr    $0xc,%edx
  8021a3:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8021aa:	ef 
  8021ab:	0f b7 c0             	movzwl %ax,%eax
}
  8021ae:	5d                   	pop    %ebp
  8021af:	c3                   	ret    

008021b0 <__udivdi3>:
  8021b0:	55                   	push   %ebp
  8021b1:	57                   	push   %edi
  8021b2:	56                   	push   %esi
  8021b3:	53                   	push   %ebx
  8021b4:	83 ec 1c             	sub    $0x1c,%esp
  8021b7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8021bb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8021bf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8021c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021c7:	85 f6                	test   %esi,%esi
  8021c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021cd:	89 ca                	mov    %ecx,%edx
  8021cf:	89 f8                	mov    %edi,%eax
  8021d1:	75 3d                	jne    802210 <__udivdi3+0x60>
  8021d3:	39 cf                	cmp    %ecx,%edi
  8021d5:	0f 87 c5 00 00 00    	ja     8022a0 <__udivdi3+0xf0>
  8021db:	85 ff                	test   %edi,%edi
  8021dd:	89 fd                	mov    %edi,%ebp
  8021df:	75 0b                	jne    8021ec <__udivdi3+0x3c>
  8021e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e6:	31 d2                	xor    %edx,%edx
  8021e8:	f7 f7                	div    %edi
  8021ea:	89 c5                	mov    %eax,%ebp
  8021ec:	89 c8                	mov    %ecx,%eax
  8021ee:	31 d2                	xor    %edx,%edx
  8021f0:	f7 f5                	div    %ebp
  8021f2:	89 c1                	mov    %eax,%ecx
  8021f4:	89 d8                	mov    %ebx,%eax
  8021f6:	89 cf                	mov    %ecx,%edi
  8021f8:	f7 f5                	div    %ebp
  8021fa:	89 c3                	mov    %eax,%ebx
  8021fc:	89 d8                	mov    %ebx,%eax
  8021fe:	89 fa                	mov    %edi,%edx
  802200:	83 c4 1c             	add    $0x1c,%esp
  802203:	5b                   	pop    %ebx
  802204:	5e                   	pop    %esi
  802205:	5f                   	pop    %edi
  802206:	5d                   	pop    %ebp
  802207:	c3                   	ret    
  802208:	90                   	nop
  802209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802210:	39 ce                	cmp    %ecx,%esi
  802212:	77 74                	ja     802288 <__udivdi3+0xd8>
  802214:	0f bd fe             	bsr    %esi,%edi
  802217:	83 f7 1f             	xor    $0x1f,%edi
  80221a:	0f 84 98 00 00 00    	je     8022b8 <__udivdi3+0x108>
  802220:	bb 20 00 00 00       	mov    $0x20,%ebx
  802225:	89 f9                	mov    %edi,%ecx
  802227:	89 c5                	mov    %eax,%ebp
  802229:	29 fb                	sub    %edi,%ebx
  80222b:	d3 e6                	shl    %cl,%esi
  80222d:	89 d9                	mov    %ebx,%ecx
  80222f:	d3 ed                	shr    %cl,%ebp
  802231:	89 f9                	mov    %edi,%ecx
  802233:	d3 e0                	shl    %cl,%eax
  802235:	09 ee                	or     %ebp,%esi
  802237:	89 d9                	mov    %ebx,%ecx
  802239:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80223d:	89 d5                	mov    %edx,%ebp
  80223f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802243:	d3 ed                	shr    %cl,%ebp
  802245:	89 f9                	mov    %edi,%ecx
  802247:	d3 e2                	shl    %cl,%edx
  802249:	89 d9                	mov    %ebx,%ecx
  80224b:	d3 e8                	shr    %cl,%eax
  80224d:	09 c2                	or     %eax,%edx
  80224f:	89 d0                	mov    %edx,%eax
  802251:	89 ea                	mov    %ebp,%edx
  802253:	f7 f6                	div    %esi
  802255:	89 d5                	mov    %edx,%ebp
  802257:	89 c3                	mov    %eax,%ebx
  802259:	f7 64 24 0c          	mull   0xc(%esp)
  80225d:	39 d5                	cmp    %edx,%ebp
  80225f:	72 10                	jb     802271 <__udivdi3+0xc1>
  802261:	8b 74 24 08          	mov    0x8(%esp),%esi
  802265:	89 f9                	mov    %edi,%ecx
  802267:	d3 e6                	shl    %cl,%esi
  802269:	39 c6                	cmp    %eax,%esi
  80226b:	73 07                	jae    802274 <__udivdi3+0xc4>
  80226d:	39 d5                	cmp    %edx,%ebp
  80226f:	75 03                	jne    802274 <__udivdi3+0xc4>
  802271:	83 eb 01             	sub    $0x1,%ebx
  802274:	31 ff                	xor    %edi,%edi
  802276:	89 d8                	mov    %ebx,%eax
  802278:	89 fa                	mov    %edi,%edx
  80227a:	83 c4 1c             	add    $0x1c,%esp
  80227d:	5b                   	pop    %ebx
  80227e:	5e                   	pop    %esi
  80227f:	5f                   	pop    %edi
  802280:	5d                   	pop    %ebp
  802281:	c3                   	ret    
  802282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802288:	31 ff                	xor    %edi,%edi
  80228a:	31 db                	xor    %ebx,%ebx
  80228c:	89 d8                	mov    %ebx,%eax
  80228e:	89 fa                	mov    %edi,%edx
  802290:	83 c4 1c             	add    $0x1c,%esp
  802293:	5b                   	pop    %ebx
  802294:	5e                   	pop    %esi
  802295:	5f                   	pop    %edi
  802296:	5d                   	pop    %ebp
  802297:	c3                   	ret    
  802298:	90                   	nop
  802299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022a0:	89 d8                	mov    %ebx,%eax
  8022a2:	f7 f7                	div    %edi
  8022a4:	31 ff                	xor    %edi,%edi
  8022a6:	89 c3                	mov    %eax,%ebx
  8022a8:	89 d8                	mov    %ebx,%eax
  8022aa:	89 fa                	mov    %edi,%edx
  8022ac:	83 c4 1c             	add    $0x1c,%esp
  8022af:	5b                   	pop    %ebx
  8022b0:	5e                   	pop    %esi
  8022b1:	5f                   	pop    %edi
  8022b2:	5d                   	pop    %ebp
  8022b3:	c3                   	ret    
  8022b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022b8:	39 ce                	cmp    %ecx,%esi
  8022ba:	72 0c                	jb     8022c8 <__udivdi3+0x118>
  8022bc:	31 db                	xor    %ebx,%ebx
  8022be:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8022c2:	0f 87 34 ff ff ff    	ja     8021fc <__udivdi3+0x4c>
  8022c8:	bb 01 00 00 00       	mov    $0x1,%ebx
  8022cd:	e9 2a ff ff ff       	jmp    8021fc <__udivdi3+0x4c>
  8022d2:	66 90                	xchg   %ax,%ax
  8022d4:	66 90                	xchg   %ax,%ax
  8022d6:	66 90                	xchg   %ax,%ax
  8022d8:	66 90                	xchg   %ax,%ax
  8022da:	66 90                	xchg   %ax,%ax
  8022dc:	66 90                	xchg   %ax,%ax
  8022de:	66 90                	xchg   %ax,%ax

008022e0 <__umoddi3>:
  8022e0:	55                   	push   %ebp
  8022e1:	57                   	push   %edi
  8022e2:	56                   	push   %esi
  8022e3:	53                   	push   %ebx
  8022e4:	83 ec 1c             	sub    $0x1c,%esp
  8022e7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022eb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8022ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022f7:	85 d2                	test   %edx,%edx
  8022f9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8022fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802301:	89 f3                	mov    %esi,%ebx
  802303:	89 3c 24             	mov    %edi,(%esp)
  802306:	89 74 24 04          	mov    %esi,0x4(%esp)
  80230a:	75 1c                	jne    802328 <__umoddi3+0x48>
  80230c:	39 f7                	cmp    %esi,%edi
  80230e:	76 50                	jbe    802360 <__umoddi3+0x80>
  802310:	89 c8                	mov    %ecx,%eax
  802312:	89 f2                	mov    %esi,%edx
  802314:	f7 f7                	div    %edi
  802316:	89 d0                	mov    %edx,%eax
  802318:	31 d2                	xor    %edx,%edx
  80231a:	83 c4 1c             	add    $0x1c,%esp
  80231d:	5b                   	pop    %ebx
  80231e:	5e                   	pop    %esi
  80231f:	5f                   	pop    %edi
  802320:	5d                   	pop    %ebp
  802321:	c3                   	ret    
  802322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802328:	39 f2                	cmp    %esi,%edx
  80232a:	89 d0                	mov    %edx,%eax
  80232c:	77 52                	ja     802380 <__umoddi3+0xa0>
  80232e:	0f bd ea             	bsr    %edx,%ebp
  802331:	83 f5 1f             	xor    $0x1f,%ebp
  802334:	75 5a                	jne    802390 <__umoddi3+0xb0>
  802336:	3b 54 24 04          	cmp    0x4(%esp),%edx
  80233a:	0f 82 e0 00 00 00    	jb     802420 <__umoddi3+0x140>
  802340:	39 0c 24             	cmp    %ecx,(%esp)
  802343:	0f 86 d7 00 00 00    	jbe    802420 <__umoddi3+0x140>
  802349:	8b 44 24 08          	mov    0x8(%esp),%eax
  80234d:	8b 54 24 04          	mov    0x4(%esp),%edx
  802351:	83 c4 1c             	add    $0x1c,%esp
  802354:	5b                   	pop    %ebx
  802355:	5e                   	pop    %esi
  802356:	5f                   	pop    %edi
  802357:	5d                   	pop    %ebp
  802358:	c3                   	ret    
  802359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802360:	85 ff                	test   %edi,%edi
  802362:	89 fd                	mov    %edi,%ebp
  802364:	75 0b                	jne    802371 <__umoddi3+0x91>
  802366:	b8 01 00 00 00       	mov    $0x1,%eax
  80236b:	31 d2                	xor    %edx,%edx
  80236d:	f7 f7                	div    %edi
  80236f:	89 c5                	mov    %eax,%ebp
  802371:	89 f0                	mov    %esi,%eax
  802373:	31 d2                	xor    %edx,%edx
  802375:	f7 f5                	div    %ebp
  802377:	89 c8                	mov    %ecx,%eax
  802379:	f7 f5                	div    %ebp
  80237b:	89 d0                	mov    %edx,%eax
  80237d:	eb 99                	jmp    802318 <__umoddi3+0x38>
  80237f:	90                   	nop
  802380:	89 c8                	mov    %ecx,%eax
  802382:	89 f2                	mov    %esi,%edx
  802384:	83 c4 1c             	add    $0x1c,%esp
  802387:	5b                   	pop    %ebx
  802388:	5e                   	pop    %esi
  802389:	5f                   	pop    %edi
  80238a:	5d                   	pop    %ebp
  80238b:	c3                   	ret    
  80238c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802390:	8b 34 24             	mov    (%esp),%esi
  802393:	bf 20 00 00 00       	mov    $0x20,%edi
  802398:	89 e9                	mov    %ebp,%ecx
  80239a:	29 ef                	sub    %ebp,%edi
  80239c:	d3 e0                	shl    %cl,%eax
  80239e:	89 f9                	mov    %edi,%ecx
  8023a0:	89 f2                	mov    %esi,%edx
  8023a2:	d3 ea                	shr    %cl,%edx
  8023a4:	89 e9                	mov    %ebp,%ecx
  8023a6:	09 c2                	or     %eax,%edx
  8023a8:	89 d8                	mov    %ebx,%eax
  8023aa:	89 14 24             	mov    %edx,(%esp)
  8023ad:	89 f2                	mov    %esi,%edx
  8023af:	d3 e2                	shl    %cl,%edx
  8023b1:	89 f9                	mov    %edi,%ecx
  8023b3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023b7:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8023bb:	d3 e8                	shr    %cl,%eax
  8023bd:	89 e9                	mov    %ebp,%ecx
  8023bf:	89 c6                	mov    %eax,%esi
  8023c1:	d3 e3                	shl    %cl,%ebx
  8023c3:	89 f9                	mov    %edi,%ecx
  8023c5:	89 d0                	mov    %edx,%eax
  8023c7:	d3 e8                	shr    %cl,%eax
  8023c9:	89 e9                	mov    %ebp,%ecx
  8023cb:	09 d8                	or     %ebx,%eax
  8023cd:	89 d3                	mov    %edx,%ebx
  8023cf:	89 f2                	mov    %esi,%edx
  8023d1:	f7 34 24             	divl   (%esp)
  8023d4:	89 d6                	mov    %edx,%esi
  8023d6:	d3 e3                	shl    %cl,%ebx
  8023d8:	f7 64 24 04          	mull   0x4(%esp)
  8023dc:	39 d6                	cmp    %edx,%esi
  8023de:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023e2:	89 d1                	mov    %edx,%ecx
  8023e4:	89 c3                	mov    %eax,%ebx
  8023e6:	72 08                	jb     8023f0 <__umoddi3+0x110>
  8023e8:	75 11                	jne    8023fb <__umoddi3+0x11b>
  8023ea:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8023ee:	73 0b                	jae    8023fb <__umoddi3+0x11b>
  8023f0:	2b 44 24 04          	sub    0x4(%esp),%eax
  8023f4:	1b 14 24             	sbb    (%esp),%edx
  8023f7:	89 d1                	mov    %edx,%ecx
  8023f9:	89 c3                	mov    %eax,%ebx
  8023fb:	8b 54 24 08          	mov    0x8(%esp),%edx
  8023ff:	29 da                	sub    %ebx,%edx
  802401:	19 ce                	sbb    %ecx,%esi
  802403:	89 f9                	mov    %edi,%ecx
  802405:	89 f0                	mov    %esi,%eax
  802407:	d3 e0                	shl    %cl,%eax
  802409:	89 e9                	mov    %ebp,%ecx
  80240b:	d3 ea                	shr    %cl,%edx
  80240d:	89 e9                	mov    %ebp,%ecx
  80240f:	d3 ee                	shr    %cl,%esi
  802411:	09 d0                	or     %edx,%eax
  802413:	89 f2                	mov    %esi,%edx
  802415:	83 c4 1c             	add    $0x1c,%esp
  802418:	5b                   	pop    %ebx
  802419:	5e                   	pop    %esi
  80241a:	5f                   	pop    %edi
  80241b:	5d                   	pop    %ebp
  80241c:	c3                   	ret    
  80241d:	8d 76 00             	lea    0x0(%esi),%esi
  802420:	29 f9                	sub    %edi,%ecx
  802422:	19 d6                	sbb    %edx,%esi
  802424:	89 74 24 04          	mov    %esi,0x4(%esp)
  802428:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80242c:	e9 18 ff ff ff       	jmp    802349 <__umoddi3+0x69>
