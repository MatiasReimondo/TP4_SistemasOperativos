
obj/user/primespipe.debug:     formato del fichero elf32-i386


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
  80002c:	e8 07 02 00 00       	call   800238 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80003f:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800042:	8d 7d d8             	lea    -0x28(%ebp),%edi
{
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  800045:	83 ec 04             	sub    $0x4,%esp
  800048:	6a 04                	push   $0x4
  80004a:	56                   	push   %esi
  80004b:	53                   	push   %ebx
  80004c:	e8 20 16 00 00       	call   801671 <readn>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	83 f8 04             	cmp    $0x4,%eax
  800057:	74 20                	je     800079 <primeproc+0x46>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  800059:	83 ec 0c             	sub    $0xc,%esp
  80005c:	85 c0                	test   %eax,%eax
  80005e:	ba 00 00 00 00       	mov    $0x0,%edx
  800063:	0f 4e d0             	cmovle %eax,%edx
  800066:	52                   	push   %edx
  800067:	50                   	push   %eax
  800068:	68 80 24 80 00       	push   $0x802480
  80006d:	6a 15                	push   $0x15
  80006f:	68 af 24 80 00       	push   $0x8024af
  800074:	e8 23 02 00 00       	call   80029c <_panic>

	cprintf("%d\n", p);
  800079:	83 ec 08             	sub    $0x8,%esp
  80007c:	ff 75 e0             	pushl  -0x20(%ebp)
  80007f:	68 c1 24 80 00       	push   $0x8024c1
  800084:	e8 ec 02 00 00       	call   800375 <cprintf>

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800089:	89 3c 24             	mov    %edi,(%esp)
  80008c:	e8 77 1c 00 00       	call   801d08 <pipe>
  800091:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	85 c0                	test   %eax,%eax
  800099:	79 12                	jns    8000ad <primeproc+0x7a>
		panic("pipe: %e", i);
  80009b:	50                   	push   %eax
  80009c:	68 c5 24 80 00       	push   $0x8024c5
  8000a1:	6a 1b                	push   $0x1b
  8000a3:	68 af 24 80 00       	push   $0x8024af
  8000a8:	e8 ef 01 00 00       	call   80029c <_panic>
	if ((id = fork()) < 0)
  8000ad:	e8 25 11 00 00       	call   8011d7 <fork>
  8000b2:	85 c0                	test   %eax,%eax
  8000b4:	79 12                	jns    8000c8 <primeproc+0x95>
		panic("fork: %e", id);
  8000b6:	50                   	push   %eax
  8000b7:	68 70 29 80 00       	push   $0x802970
  8000bc:	6a 1d                	push   $0x1d
  8000be:	68 af 24 80 00       	push   $0x8024af
  8000c3:	e8 d4 01 00 00       	call   80029c <_panic>
	if (id == 0) {
  8000c8:	85 c0                	test   %eax,%eax
  8000ca:	75 1f                	jne    8000eb <primeproc+0xb8>
		close(fd);
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	53                   	push   %ebx
  8000d0:	e8 cf 13 00 00       	call   8014a4 <close>
		close(pfd[1]);
  8000d5:	83 c4 04             	add    $0x4,%esp
  8000d8:	ff 75 dc             	pushl  -0x24(%ebp)
  8000db:	e8 c4 13 00 00       	call   8014a4 <close>
		fd = pfd[0];
  8000e0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  8000e3:	83 c4 10             	add    $0x10,%esp
  8000e6:	e9 5a ff ff ff       	jmp    800045 <primeproc+0x12>
	}

	close(pfd[0]);
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	ff 75 d8             	pushl  -0x28(%ebp)
  8000f1:	e8 ae 13 00 00       	call   8014a4 <close>
	wfd = pfd[1];
  8000f6:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8000f9:	83 c4 10             	add    $0x10,%esp

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8000fc:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	6a 04                	push   $0x4
  800104:	56                   	push   %esi
  800105:	53                   	push   %ebx
  800106:	e8 66 15 00 00       	call   801671 <readn>
  80010b:	83 c4 10             	add    $0x10,%esp
  80010e:	83 f8 04             	cmp    $0x4,%eax
  800111:	74 24                	je     800137 <primeproc+0x104>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800113:	83 ec 04             	sub    $0x4,%esp
  800116:	85 c0                	test   %eax,%eax
  800118:	ba 00 00 00 00       	mov    $0x0,%edx
  80011d:	0f 4e d0             	cmovle %eax,%edx
  800120:	52                   	push   %edx
  800121:	50                   	push   %eax
  800122:	53                   	push   %ebx
  800123:	ff 75 e0             	pushl  -0x20(%ebp)
  800126:	68 ce 24 80 00       	push   $0x8024ce
  80012b:	6a 2b                	push   $0x2b
  80012d:	68 af 24 80 00       	push   $0x8024af
  800132:	e8 65 01 00 00       	call   80029c <_panic>
		if (i%p)
  800137:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80013a:	99                   	cltd   
  80013b:	f7 7d e0             	idivl  -0x20(%ebp)
  80013e:	85 d2                	test   %edx,%edx
  800140:	74 bd                	je     8000ff <primeproc+0xcc>
			if ((r=write(wfd, &i, 4)) != 4)
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	6a 04                	push   $0x4
  800147:	56                   	push   %esi
  800148:	57                   	push   %edi
  800149:	e8 6c 15 00 00       	call   8016ba <write>
  80014e:	83 c4 10             	add    $0x10,%esp
  800151:	83 f8 04             	cmp    $0x4,%eax
  800154:	74 a9                	je     8000ff <primeproc+0xcc>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  800156:	83 ec 08             	sub    $0x8,%esp
  800159:	85 c0                	test   %eax,%eax
  80015b:	ba 00 00 00 00       	mov    $0x0,%edx
  800160:	0f 4e d0             	cmovle %eax,%edx
  800163:	52                   	push   %edx
  800164:	50                   	push   %eax
  800165:	ff 75 e0             	pushl  -0x20(%ebp)
  800168:	68 ea 24 80 00       	push   $0x8024ea
  80016d:	6a 2e                	push   $0x2e
  80016f:	68 af 24 80 00       	push   $0x8024af
  800174:	e8 23 01 00 00       	call   80029c <_panic>

00800179 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800179:	55                   	push   %ebp
  80017a:	89 e5                	mov    %esp,%ebp
  80017c:	53                   	push   %ebx
  80017d:	83 ec 20             	sub    $0x20,%esp
	int i, id, p[2], r;

	binaryname = "primespipe";
  800180:	c7 05 00 30 80 00 04 	movl   $0x802504,0x803000
  800187:	25 80 00 

	if ((i=pipe(p)) < 0)
  80018a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80018d:	50                   	push   %eax
  80018e:	e8 75 1b 00 00       	call   801d08 <pipe>
  800193:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	85 c0                	test   %eax,%eax
  80019b:	79 12                	jns    8001af <umain+0x36>
		panic("pipe: %e", i);
  80019d:	50                   	push   %eax
  80019e:	68 c5 24 80 00       	push   $0x8024c5
  8001a3:	6a 3a                	push   $0x3a
  8001a5:	68 af 24 80 00       	push   $0x8024af
  8001aa:	e8 ed 00 00 00       	call   80029c <_panic>

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  8001af:	e8 23 10 00 00       	call   8011d7 <fork>
  8001b4:	85 c0                	test   %eax,%eax
  8001b6:	79 12                	jns    8001ca <umain+0x51>
		panic("fork: %e", id);
  8001b8:	50                   	push   %eax
  8001b9:	68 70 29 80 00       	push   $0x802970
  8001be:	6a 3e                	push   $0x3e
  8001c0:	68 af 24 80 00       	push   $0x8024af
  8001c5:	e8 d2 00 00 00       	call   80029c <_panic>

	if (id == 0) {
  8001ca:	85 c0                	test   %eax,%eax
  8001cc:	75 16                	jne    8001e4 <umain+0x6b>
		close(p[1]);
  8001ce:	83 ec 0c             	sub    $0xc,%esp
  8001d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8001d4:	e8 cb 12 00 00       	call   8014a4 <close>
		primeproc(p[0]);
  8001d9:	83 c4 04             	add    $0x4,%esp
  8001dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001df:	e8 4f fe ff ff       	call   800033 <primeproc>
	}

	close(p[0]);
  8001e4:	83 ec 0c             	sub    $0xc,%esp
  8001e7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ea:	e8 b5 12 00 00       	call   8014a4 <close>

	// feed all the integers through
	for (i=2;; i++)
  8001ef:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
  8001f6:	83 c4 10             	add    $0x10,%esp
		if ((r=write(p[1], &i, 4)) != 4)
  8001f9:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  8001fc:	83 ec 04             	sub    $0x4,%esp
  8001ff:	6a 04                	push   $0x4
  800201:	53                   	push   %ebx
  800202:	ff 75 f0             	pushl  -0x10(%ebp)
  800205:	e8 b0 14 00 00       	call   8016ba <write>
  80020a:	83 c4 10             	add    $0x10,%esp
  80020d:	83 f8 04             	cmp    $0x4,%eax
  800210:	74 20                	je     800232 <umain+0xb9>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	85 c0                	test   %eax,%eax
  800217:	ba 00 00 00 00       	mov    $0x0,%edx
  80021c:	0f 4e d0             	cmovle %eax,%edx
  80021f:	52                   	push   %edx
  800220:	50                   	push   %eax
  800221:	68 0f 25 80 00       	push   $0x80250f
  800226:	6a 4a                	push   $0x4a
  800228:	68 af 24 80 00       	push   $0x8024af
  80022d:	e8 6a 00 00 00       	call   80029c <_panic>
	}

	close(p[0]);

	// feed all the integers through
	for (i=2;; i++)
  800232:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
}
  800236:	eb c4                	jmp    8001fc <umain+0x83>

00800238 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800238:	55                   	push   %ebp
  800239:	89 e5                	mov    %esp,%ebp
  80023b:	56                   	push   %esi
  80023c:	53                   	push   %ebx
  80023d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800240:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800243:	e8 9d 0a 00 00       	call   800ce5 <sys_getenvid>
	if (id >= 0)
  800248:	85 c0                	test   %eax,%eax
  80024a:	78 12                	js     80025e <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  80024c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800251:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800254:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800259:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80025e:	85 db                	test   %ebx,%ebx
  800260:	7e 07                	jle    800269 <libmain+0x31>
		binaryname = argv[0];
  800262:	8b 06                	mov    (%esi),%eax
  800264:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800269:	83 ec 08             	sub    $0x8,%esp
  80026c:	56                   	push   %esi
  80026d:	53                   	push   %ebx
  80026e:	e8 06 ff ff ff       	call   800179 <umain>

	// exit gracefully
	exit();
  800273:	e8 0a 00 00 00       	call   800282 <exit>
}
  800278:	83 c4 10             	add    $0x10,%esp
  80027b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80027e:	5b                   	pop    %ebx
  80027f:	5e                   	pop    %esi
  800280:	5d                   	pop    %ebp
  800281:	c3                   	ret    

00800282 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800288:	e8 42 12 00 00       	call   8014cf <close_all>
	sys_env_destroy(0);
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	6a 00                	push   $0x0
  800292:	e8 2c 0a 00 00       	call   800cc3 <sys_env_destroy>
}
  800297:	83 c4 10             	add    $0x10,%esp
  80029a:	c9                   	leave  
  80029b:	c3                   	ret    

0080029c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80029c:	55                   	push   %ebp
  80029d:	89 e5                	mov    %esp,%ebp
  80029f:	56                   	push   %esi
  8002a0:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8002a1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002a4:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8002aa:	e8 36 0a 00 00       	call   800ce5 <sys_getenvid>
  8002af:	83 ec 0c             	sub    $0xc,%esp
  8002b2:	ff 75 0c             	pushl  0xc(%ebp)
  8002b5:	ff 75 08             	pushl  0x8(%ebp)
  8002b8:	56                   	push   %esi
  8002b9:	50                   	push   %eax
  8002ba:	68 34 25 80 00       	push   $0x802534
  8002bf:	e8 b1 00 00 00       	call   800375 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002c4:	83 c4 18             	add    $0x18,%esp
  8002c7:	53                   	push   %ebx
  8002c8:	ff 75 10             	pushl  0x10(%ebp)
  8002cb:	e8 54 00 00 00       	call   800324 <vcprintf>
	cprintf("\n");
  8002d0:	c7 04 24 c3 24 80 00 	movl   $0x8024c3,(%esp)
  8002d7:	e8 99 00 00 00       	call   800375 <cprintf>
  8002dc:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002df:	cc                   	int3   
  8002e0:	eb fd                	jmp    8002df <_panic+0x43>

008002e2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002e2:	55                   	push   %ebp
  8002e3:	89 e5                	mov    %esp,%ebp
  8002e5:	53                   	push   %ebx
  8002e6:	83 ec 04             	sub    $0x4,%esp
  8002e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002ec:	8b 13                	mov    (%ebx),%edx
  8002ee:	8d 42 01             	lea    0x1(%edx),%eax
  8002f1:	89 03                	mov    %eax,(%ebx)
  8002f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002f6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002fa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ff:	75 1a                	jne    80031b <putch+0x39>
		sys_cputs(b->buf, b->idx);
  800301:	83 ec 08             	sub    $0x8,%esp
  800304:	68 ff 00 00 00       	push   $0xff
  800309:	8d 43 08             	lea    0x8(%ebx),%eax
  80030c:	50                   	push   %eax
  80030d:	e8 67 09 00 00       	call   800c79 <sys_cputs>
		b->idx = 0;
  800312:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800318:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  80031b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80031f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800322:	c9                   	leave  
  800323:	c3                   	ret    

00800324 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800324:	55                   	push   %ebp
  800325:	89 e5                	mov    %esp,%ebp
  800327:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80032d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800334:	00 00 00 
	b.cnt = 0;
  800337:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80033e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800341:	ff 75 0c             	pushl  0xc(%ebp)
  800344:	ff 75 08             	pushl  0x8(%ebp)
  800347:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80034d:	50                   	push   %eax
  80034e:	68 e2 02 80 00       	push   $0x8002e2
  800353:	e8 86 01 00 00       	call   8004de <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800358:	83 c4 08             	add    $0x8,%esp
  80035b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800361:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800367:	50                   	push   %eax
  800368:	e8 0c 09 00 00       	call   800c79 <sys_cputs>

	return b.cnt;
}
  80036d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800373:	c9                   	leave  
  800374:	c3                   	ret    

00800375 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
  800378:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80037b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80037e:	50                   	push   %eax
  80037f:	ff 75 08             	pushl  0x8(%ebp)
  800382:	e8 9d ff ff ff       	call   800324 <vcprintf>
	va_end(ap);

	return cnt;
}
  800387:	c9                   	leave  
  800388:	c3                   	ret    

00800389 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800389:	55                   	push   %ebp
  80038a:	89 e5                	mov    %esp,%ebp
  80038c:	57                   	push   %edi
  80038d:	56                   	push   %esi
  80038e:	53                   	push   %ebx
  80038f:	83 ec 1c             	sub    $0x1c,%esp
  800392:	89 c7                	mov    %eax,%edi
  800394:	89 d6                	mov    %edx,%esi
  800396:	8b 45 08             	mov    0x8(%ebp),%eax
  800399:	8b 55 0c             	mov    0xc(%ebp),%edx
  80039c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80039f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8003a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003aa:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8003ad:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8003b0:	39 d3                	cmp    %edx,%ebx
  8003b2:	72 05                	jb     8003b9 <printnum+0x30>
  8003b4:	39 45 10             	cmp    %eax,0x10(%ebp)
  8003b7:	77 45                	ja     8003fe <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003b9:	83 ec 0c             	sub    $0xc,%esp
  8003bc:	ff 75 18             	pushl  0x18(%ebp)
  8003bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003c5:	53                   	push   %ebx
  8003c6:	ff 75 10             	pushl  0x10(%ebp)
  8003c9:	83 ec 08             	sub    $0x8,%esp
  8003cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8003d2:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d5:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d8:	e8 03 1e 00 00       	call   8021e0 <__udivdi3>
  8003dd:	83 c4 18             	add    $0x18,%esp
  8003e0:	52                   	push   %edx
  8003e1:	50                   	push   %eax
  8003e2:	89 f2                	mov    %esi,%edx
  8003e4:	89 f8                	mov    %edi,%eax
  8003e6:	e8 9e ff ff ff       	call   800389 <printnum>
  8003eb:	83 c4 20             	add    $0x20,%esp
  8003ee:	eb 18                	jmp    800408 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003f0:	83 ec 08             	sub    $0x8,%esp
  8003f3:	56                   	push   %esi
  8003f4:	ff 75 18             	pushl  0x18(%ebp)
  8003f7:	ff d7                	call   *%edi
  8003f9:	83 c4 10             	add    $0x10,%esp
  8003fc:	eb 03                	jmp    800401 <printnum+0x78>
  8003fe:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800401:	83 eb 01             	sub    $0x1,%ebx
  800404:	85 db                	test   %ebx,%ebx
  800406:	7f e8                	jg     8003f0 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800408:	83 ec 08             	sub    $0x8,%esp
  80040b:	56                   	push   %esi
  80040c:	83 ec 04             	sub    $0x4,%esp
  80040f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800412:	ff 75 e0             	pushl  -0x20(%ebp)
  800415:	ff 75 dc             	pushl  -0x24(%ebp)
  800418:	ff 75 d8             	pushl  -0x28(%ebp)
  80041b:	e8 f0 1e 00 00       	call   802310 <__umoddi3>
  800420:	83 c4 14             	add    $0x14,%esp
  800423:	0f be 80 57 25 80 00 	movsbl 0x802557(%eax),%eax
  80042a:	50                   	push   %eax
  80042b:	ff d7                	call   *%edi
}
  80042d:	83 c4 10             	add    $0x10,%esp
  800430:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800433:	5b                   	pop    %ebx
  800434:	5e                   	pop    %esi
  800435:	5f                   	pop    %edi
  800436:	5d                   	pop    %ebp
  800437:	c3                   	ret    

00800438 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800438:	55                   	push   %ebp
  800439:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80043b:	83 fa 01             	cmp    $0x1,%edx
  80043e:	7e 0e                	jle    80044e <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800440:	8b 10                	mov    (%eax),%edx
  800442:	8d 4a 08             	lea    0x8(%edx),%ecx
  800445:	89 08                	mov    %ecx,(%eax)
  800447:	8b 02                	mov    (%edx),%eax
  800449:	8b 52 04             	mov    0x4(%edx),%edx
  80044c:	eb 22                	jmp    800470 <getuint+0x38>
	else if (lflag)
  80044e:	85 d2                	test   %edx,%edx
  800450:	74 10                	je     800462 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800452:	8b 10                	mov    (%eax),%edx
  800454:	8d 4a 04             	lea    0x4(%edx),%ecx
  800457:	89 08                	mov    %ecx,(%eax)
  800459:	8b 02                	mov    (%edx),%eax
  80045b:	ba 00 00 00 00       	mov    $0x0,%edx
  800460:	eb 0e                	jmp    800470 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800462:	8b 10                	mov    (%eax),%edx
  800464:	8d 4a 04             	lea    0x4(%edx),%ecx
  800467:	89 08                	mov    %ecx,(%eax)
  800469:	8b 02                	mov    (%edx),%eax
  80046b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800470:	5d                   	pop    %ebp
  800471:	c3                   	ret    

00800472 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800472:	55                   	push   %ebp
  800473:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800475:	83 fa 01             	cmp    $0x1,%edx
  800478:	7e 0e                	jle    800488 <getint+0x16>
		return va_arg(*ap, long long);
  80047a:	8b 10                	mov    (%eax),%edx
  80047c:	8d 4a 08             	lea    0x8(%edx),%ecx
  80047f:	89 08                	mov    %ecx,(%eax)
  800481:	8b 02                	mov    (%edx),%eax
  800483:	8b 52 04             	mov    0x4(%edx),%edx
  800486:	eb 1a                	jmp    8004a2 <getint+0x30>
	else if (lflag)
  800488:	85 d2                	test   %edx,%edx
  80048a:	74 0c                	je     800498 <getint+0x26>
		return va_arg(*ap, long);
  80048c:	8b 10                	mov    (%eax),%edx
  80048e:	8d 4a 04             	lea    0x4(%edx),%ecx
  800491:	89 08                	mov    %ecx,(%eax)
  800493:	8b 02                	mov    (%edx),%eax
  800495:	99                   	cltd   
  800496:	eb 0a                	jmp    8004a2 <getint+0x30>
	else
		return va_arg(*ap, int);
  800498:	8b 10                	mov    (%eax),%edx
  80049a:	8d 4a 04             	lea    0x4(%edx),%ecx
  80049d:	89 08                	mov    %ecx,(%eax)
  80049f:	8b 02                	mov    (%edx),%eax
  8004a1:	99                   	cltd   
}
  8004a2:	5d                   	pop    %ebp
  8004a3:	c3                   	ret    

008004a4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004a4:	55                   	push   %ebp
  8004a5:	89 e5                	mov    %esp,%ebp
  8004a7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004aa:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004ae:	8b 10                	mov    (%eax),%edx
  8004b0:	3b 50 04             	cmp    0x4(%eax),%edx
  8004b3:	73 0a                	jae    8004bf <sprintputch+0x1b>
		*b->buf++ = ch;
  8004b5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004b8:	89 08                	mov    %ecx,(%eax)
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	88 02                	mov    %al,(%edx)
}
  8004bf:	5d                   	pop    %ebp
  8004c0:	c3                   	ret    

008004c1 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8004c1:	55                   	push   %ebp
  8004c2:	89 e5                	mov    %esp,%ebp
  8004c4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8004c7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004ca:	50                   	push   %eax
  8004cb:	ff 75 10             	pushl  0x10(%ebp)
  8004ce:	ff 75 0c             	pushl  0xc(%ebp)
  8004d1:	ff 75 08             	pushl  0x8(%ebp)
  8004d4:	e8 05 00 00 00       	call   8004de <vprintfmt>
	va_end(ap);
}
  8004d9:	83 c4 10             	add    $0x10,%esp
  8004dc:	c9                   	leave  
  8004dd:	c3                   	ret    

008004de <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004de:	55                   	push   %ebp
  8004df:	89 e5                	mov    %esp,%ebp
  8004e1:	57                   	push   %edi
  8004e2:	56                   	push   %esi
  8004e3:	53                   	push   %ebx
  8004e4:	83 ec 2c             	sub    $0x2c,%esp
  8004e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004ed:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004f0:	eb 12                	jmp    800504 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004f2:	85 c0                	test   %eax,%eax
  8004f4:	0f 84 44 03 00 00    	je     80083e <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	53                   	push   %ebx
  8004fe:	50                   	push   %eax
  8004ff:	ff d6                	call   *%esi
  800501:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800504:	83 c7 01             	add    $0x1,%edi
  800507:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80050b:	83 f8 25             	cmp    $0x25,%eax
  80050e:	75 e2                	jne    8004f2 <vprintfmt+0x14>
  800510:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800514:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80051b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800522:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800529:	ba 00 00 00 00       	mov    $0x0,%edx
  80052e:	eb 07                	jmp    800537 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800530:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800533:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800537:	8d 47 01             	lea    0x1(%edi),%eax
  80053a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80053d:	0f b6 07             	movzbl (%edi),%eax
  800540:	0f b6 c8             	movzbl %al,%ecx
  800543:	83 e8 23             	sub    $0x23,%eax
  800546:	3c 55                	cmp    $0x55,%al
  800548:	0f 87 d5 02 00 00    	ja     800823 <vprintfmt+0x345>
  80054e:	0f b6 c0             	movzbl %al,%eax
  800551:	ff 24 85 a0 26 80 00 	jmp    *0x8026a0(,%eax,4)
  800558:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80055b:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80055f:	eb d6                	jmp    800537 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800561:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800564:	b8 00 00 00 00       	mov    $0x0,%eax
  800569:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80056c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80056f:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  800573:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  800576:	8d 51 d0             	lea    -0x30(%ecx),%edx
  800579:	83 fa 09             	cmp    $0x9,%edx
  80057c:	77 39                	ja     8005b7 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80057e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800581:	eb e9                	jmp    80056c <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800583:	8b 45 14             	mov    0x14(%ebp),%eax
  800586:	8d 48 04             	lea    0x4(%eax),%ecx
  800589:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800591:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800594:	eb 27                	jmp    8005bd <vprintfmt+0xdf>
  800596:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800599:	85 c0                	test   %eax,%eax
  80059b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005a0:	0f 49 c8             	cmovns %eax,%ecx
  8005a3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005a9:	eb 8c                	jmp    800537 <vprintfmt+0x59>
  8005ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8005ae:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005b5:	eb 80                	jmp    800537 <vprintfmt+0x59>
  8005b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005ba:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  8005bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005c1:	0f 89 70 ff ff ff    	jns    800537 <vprintfmt+0x59>
				width = precision, precision = -1;
  8005c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005cd:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005d4:	e9 5e ff ff ff       	jmp    800537 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005d9:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8005df:	e9 53 ff ff ff       	jmp    800537 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e7:	8d 50 04             	lea    0x4(%eax),%edx
  8005ea:	89 55 14             	mov    %edx,0x14(%ebp)
  8005ed:	83 ec 08             	sub    $0x8,%esp
  8005f0:	53                   	push   %ebx
  8005f1:	ff 30                	pushl  (%eax)
  8005f3:	ff d6                	call   *%esi
			break;
  8005f5:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  8005fb:	e9 04 ff ff ff       	jmp    800504 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8d 50 04             	lea    0x4(%eax),%edx
  800606:	89 55 14             	mov    %edx,0x14(%ebp)
  800609:	8b 00                	mov    (%eax),%eax
  80060b:	99                   	cltd   
  80060c:	31 d0                	xor    %edx,%eax
  80060e:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800610:	83 f8 0f             	cmp    $0xf,%eax
  800613:	7f 0b                	jg     800620 <vprintfmt+0x142>
  800615:	8b 14 85 00 28 80 00 	mov    0x802800(,%eax,4),%edx
  80061c:	85 d2                	test   %edx,%edx
  80061e:	75 18                	jne    800638 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  800620:	50                   	push   %eax
  800621:	68 6f 25 80 00       	push   $0x80256f
  800626:	53                   	push   %ebx
  800627:	56                   	push   %esi
  800628:	e8 94 fe ff ff       	call   8004c1 <printfmt>
  80062d:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800630:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800633:	e9 cc fe ff ff       	jmp    800504 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  800638:	52                   	push   %edx
  800639:	68 95 2a 80 00       	push   $0x802a95
  80063e:	53                   	push   %ebx
  80063f:	56                   	push   %esi
  800640:	e8 7c fe ff ff       	call   8004c1 <printfmt>
  800645:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800648:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80064b:	e9 b4 fe ff ff       	jmp    800504 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800650:	8b 45 14             	mov    0x14(%ebp),%eax
  800653:	8d 50 04             	lea    0x4(%eax),%edx
  800656:	89 55 14             	mov    %edx,0x14(%ebp)
  800659:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80065b:	85 ff                	test   %edi,%edi
  80065d:	b8 68 25 80 00       	mov    $0x802568,%eax
  800662:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800665:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800669:	0f 8e 94 00 00 00    	jle    800703 <vprintfmt+0x225>
  80066f:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800673:	0f 84 98 00 00 00    	je     800711 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  800679:	83 ec 08             	sub    $0x8,%esp
  80067c:	ff 75 d0             	pushl  -0x30(%ebp)
  80067f:	57                   	push   %edi
  800680:	e8 41 02 00 00       	call   8008c6 <strnlen>
  800685:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800688:	29 c1                	sub    %eax,%ecx
  80068a:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80068d:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800690:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800694:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800697:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80069a:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80069c:	eb 0f                	jmp    8006ad <vprintfmt+0x1cf>
					putch(padc, putdat);
  80069e:	83 ec 08             	sub    $0x8,%esp
  8006a1:	53                   	push   %ebx
  8006a2:	ff 75 e0             	pushl  -0x20(%ebp)
  8006a5:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a7:	83 ef 01             	sub    $0x1,%edi
  8006aa:	83 c4 10             	add    $0x10,%esp
  8006ad:	85 ff                	test   %edi,%edi
  8006af:	7f ed                	jg     80069e <vprintfmt+0x1c0>
  8006b1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006b4:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8006b7:	85 c9                	test   %ecx,%ecx
  8006b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8006be:	0f 49 c1             	cmovns %ecx,%eax
  8006c1:	29 c1                	sub    %eax,%ecx
  8006c3:	89 75 08             	mov    %esi,0x8(%ebp)
  8006c6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006c9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006cc:	89 cb                	mov    %ecx,%ebx
  8006ce:	eb 4d                	jmp    80071d <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006d0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006d4:	74 1b                	je     8006f1 <vprintfmt+0x213>
  8006d6:	0f be c0             	movsbl %al,%eax
  8006d9:	83 e8 20             	sub    $0x20,%eax
  8006dc:	83 f8 5e             	cmp    $0x5e,%eax
  8006df:	76 10                	jbe    8006f1 <vprintfmt+0x213>
					putch('?', putdat);
  8006e1:	83 ec 08             	sub    $0x8,%esp
  8006e4:	ff 75 0c             	pushl  0xc(%ebp)
  8006e7:	6a 3f                	push   $0x3f
  8006e9:	ff 55 08             	call   *0x8(%ebp)
  8006ec:	83 c4 10             	add    $0x10,%esp
  8006ef:	eb 0d                	jmp    8006fe <vprintfmt+0x220>
				else
					putch(ch, putdat);
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	ff 75 0c             	pushl  0xc(%ebp)
  8006f7:	52                   	push   %edx
  8006f8:	ff 55 08             	call   *0x8(%ebp)
  8006fb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006fe:	83 eb 01             	sub    $0x1,%ebx
  800701:	eb 1a                	jmp    80071d <vprintfmt+0x23f>
  800703:	89 75 08             	mov    %esi,0x8(%ebp)
  800706:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800709:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80070c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80070f:	eb 0c                	jmp    80071d <vprintfmt+0x23f>
  800711:	89 75 08             	mov    %esi,0x8(%ebp)
  800714:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800717:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80071a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80071d:	83 c7 01             	add    $0x1,%edi
  800720:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800724:	0f be d0             	movsbl %al,%edx
  800727:	85 d2                	test   %edx,%edx
  800729:	74 23                	je     80074e <vprintfmt+0x270>
  80072b:	85 f6                	test   %esi,%esi
  80072d:	78 a1                	js     8006d0 <vprintfmt+0x1f2>
  80072f:	83 ee 01             	sub    $0x1,%esi
  800732:	79 9c                	jns    8006d0 <vprintfmt+0x1f2>
  800734:	89 df                	mov    %ebx,%edi
  800736:	8b 75 08             	mov    0x8(%ebp),%esi
  800739:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80073c:	eb 18                	jmp    800756 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80073e:	83 ec 08             	sub    $0x8,%esp
  800741:	53                   	push   %ebx
  800742:	6a 20                	push   $0x20
  800744:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800746:	83 ef 01             	sub    $0x1,%edi
  800749:	83 c4 10             	add    $0x10,%esp
  80074c:	eb 08                	jmp    800756 <vprintfmt+0x278>
  80074e:	89 df                	mov    %ebx,%edi
  800750:	8b 75 08             	mov    0x8(%ebp),%esi
  800753:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800756:	85 ff                	test   %edi,%edi
  800758:	7f e4                	jg     80073e <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80075a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80075d:	e9 a2 fd ff ff       	jmp    800504 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800762:	8d 45 14             	lea    0x14(%ebp),%eax
  800765:	e8 08 fd ff ff       	call   800472 <getint>
  80076a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800770:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800775:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800779:	79 74                	jns    8007ef <vprintfmt+0x311>
				putch('-', putdat);
  80077b:	83 ec 08             	sub    $0x8,%esp
  80077e:	53                   	push   %ebx
  80077f:	6a 2d                	push   $0x2d
  800781:	ff d6                	call   *%esi
				num = -(long long) num;
  800783:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800786:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800789:	f7 d8                	neg    %eax
  80078b:	83 d2 00             	adc    $0x0,%edx
  80078e:	f7 da                	neg    %edx
  800790:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  800793:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800798:	eb 55                	jmp    8007ef <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80079a:	8d 45 14             	lea    0x14(%ebp),%eax
  80079d:	e8 96 fc ff ff       	call   800438 <getuint>
			base = 10;
  8007a2:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8007a7:	eb 46                	jmp    8007ef <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8007a9:	8d 45 14             	lea    0x14(%ebp),%eax
  8007ac:	e8 87 fc ff ff       	call   800438 <getuint>
			base = 8;
  8007b1:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8007b6:	eb 37                	jmp    8007ef <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	53                   	push   %ebx
  8007bc:	6a 30                	push   $0x30
  8007be:	ff d6                	call   *%esi
			putch('x', putdat);
  8007c0:	83 c4 08             	add    $0x8,%esp
  8007c3:	53                   	push   %ebx
  8007c4:	6a 78                	push   $0x78
  8007c6:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cb:	8d 50 04             	lea    0x4(%eax),%edx
  8007ce:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8007d8:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8007db:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8007e0:	eb 0d                	jmp    8007ef <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007e2:	8d 45 14             	lea    0x14(%ebp),%eax
  8007e5:	e8 4e fc ff ff       	call   800438 <getuint>
			base = 16;
  8007ea:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007ef:	83 ec 0c             	sub    $0xc,%esp
  8007f2:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8007f6:	57                   	push   %edi
  8007f7:	ff 75 e0             	pushl  -0x20(%ebp)
  8007fa:	51                   	push   %ecx
  8007fb:	52                   	push   %edx
  8007fc:	50                   	push   %eax
  8007fd:	89 da                	mov    %ebx,%edx
  8007ff:	89 f0                	mov    %esi,%eax
  800801:	e8 83 fb ff ff       	call   800389 <printnum>
			break;
  800806:	83 c4 20             	add    $0x20,%esp
  800809:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80080c:	e9 f3 fc ff ff       	jmp    800504 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800811:	83 ec 08             	sub    $0x8,%esp
  800814:	53                   	push   %ebx
  800815:	51                   	push   %ecx
  800816:	ff d6                	call   *%esi
			break;
  800818:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80081b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  80081e:	e9 e1 fc ff ff       	jmp    800504 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800823:	83 ec 08             	sub    $0x8,%esp
  800826:	53                   	push   %ebx
  800827:	6a 25                	push   $0x25
  800829:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80082b:	83 c4 10             	add    $0x10,%esp
  80082e:	eb 03                	jmp    800833 <vprintfmt+0x355>
  800830:	83 ef 01             	sub    $0x1,%edi
  800833:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  800837:	75 f7                	jne    800830 <vprintfmt+0x352>
  800839:	e9 c6 fc ff ff       	jmp    800504 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  80083e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800841:	5b                   	pop    %ebx
  800842:	5e                   	pop    %esi
  800843:	5f                   	pop    %edi
  800844:	5d                   	pop    %ebp
  800845:	c3                   	ret    

00800846 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800846:	55                   	push   %ebp
  800847:	89 e5                	mov    %esp,%ebp
  800849:	83 ec 18             	sub    $0x18,%esp
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800852:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800855:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800859:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80085c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800863:	85 c0                	test   %eax,%eax
  800865:	74 26                	je     80088d <vsnprintf+0x47>
  800867:	85 d2                	test   %edx,%edx
  800869:	7e 22                	jle    80088d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80086b:	ff 75 14             	pushl  0x14(%ebp)
  80086e:	ff 75 10             	pushl  0x10(%ebp)
  800871:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800874:	50                   	push   %eax
  800875:	68 a4 04 80 00       	push   $0x8004a4
  80087a:	e8 5f fc ff ff       	call   8004de <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80087f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800882:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800888:	83 c4 10             	add    $0x10,%esp
  80088b:	eb 05                	jmp    800892 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80088d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800892:	c9                   	leave  
  800893:	c3                   	ret    

00800894 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800894:	55                   	push   %ebp
  800895:	89 e5                	mov    %esp,%ebp
  800897:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80089a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80089d:	50                   	push   %eax
  80089e:	ff 75 10             	pushl  0x10(%ebp)
  8008a1:	ff 75 0c             	pushl  0xc(%ebp)
  8008a4:	ff 75 08             	pushl  0x8(%ebp)
  8008a7:	e8 9a ff ff ff       	call   800846 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008ac:	c9                   	leave  
  8008ad:	c3                   	ret    

008008ae <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008ae:	55                   	push   %ebp
  8008af:	89 e5                	mov    %esp,%ebp
  8008b1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b9:	eb 03                	jmp    8008be <strlen+0x10>
		n++;
  8008bb:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008be:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008c2:	75 f7                	jne    8008bb <strlen+0xd>
		n++;
	return n;
}
  8008c4:	5d                   	pop    %ebp
  8008c5:	c3                   	ret    

008008c6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008c6:	55                   	push   %ebp
  8008c7:	89 e5                	mov    %esp,%ebp
  8008c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008cc:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d4:	eb 03                	jmp    8008d9 <strnlen+0x13>
		n++;
  8008d6:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008d9:	39 c2                	cmp    %eax,%edx
  8008db:	74 08                	je     8008e5 <strnlen+0x1f>
  8008dd:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008e1:	75 f3                	jne    8008d6 <strnlen+0x10>
  8008e3:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	53                   	push   %ebx
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008f1:	89 c2                	mov    %eax,%edx
  8008f3:	83 c2 01             	add    $0x1,%edx
  8008f6:	83 c1 01             	add    $0x1,%ecx
  8008f9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008fd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800900:	84 db                	test   %bl,%bl
  800902:	75 ef                	jne    8008f3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800904:	5b                   	pop    %ebx
  800905:	5d                   	pop    %ebp
  800906:	c3                   	ret    

00800907 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	53                   	push   %ebx
  80090b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80090e:	53                   	push   %ebx
  80090f:	e8 9a ff ff ff       	call   8008ae <strlen>
  800914:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800917:	ff 75 0c             	pushl  0xc(%ebp)
  80091a:	01 d8                	add    %ebx,%eax
  80091c:	50                   	push   %eax
  80091d:	e8 c5 ff ff ff       	call   8008e7 <strcpy>
	return dst;
}
  800922:	89 d8                	mov    %ebx,%eax
  800924:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800927:	c9                   	leave  
  800928:	c3                   	ret    

00800929 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800929:	55                   	push   %ebp
  80092a:	89 e5                	mov    %esp,%ebp
  80092c:	56                   	push   %esi
  80092d:	53                   	push   %ebx
  80092e:	8b 75 08             	mov    0x8(%ebp),%esi
  800931:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800934:	89 f3                	mov    %esi,%ebx
  800936:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800939:	89 f2                	mov    %esi,%edx
  80093b:	eb 0f                	jmp    80094c <strncpy+0x23>
		*dst++ = *src;
  80093d:	83 c2 01             	add    $0x1,%edx
  800940:	0f b6 01             	movzbl (%ecx),%eax
  800943:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800946:	80 39 01             	cmpb   $0x1,(%ecx)
  800949:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80094c:	39 da                	cmp    %ebx,%edx
  80094e:	75 ed                	jne    80093d <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800950:	89 f0                	mov    %esi,%eax
  800952:	5b                   	pop    %ebx
  800953:	5e                   	pop    %esi
  800954:	5d                   	pop    %ebp
  800955:	c3                   	ret    

00800956 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	56                   	push   %esi
  80095a:	53                   	push   %ebx
  80095b:	8b 75 08             	mov    0x8(%ebp),%esi
  80095e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800961:	8b 55 10             	mov    0x10(%ebp),%edx
  800964:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800966:	85 d2                	test   %edx,%edx
  800968:	74 21                	je     80098b <strlcpy+0x35>
  80096a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80096e:	89 f2                	mov    %esi,%edx
  800970:	eb 09                	jmp    80097b <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800972:	83 c2 01             	add    $0x1,%edx
  800975:	83 c1 01             	add    $0x1,%ecx
  800978:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80097b:	39 c2                	cmp    %eax,%edx
  80097d:	74 09                	je     800988 <strlcpy+0x32>
  80097f:	0f b6 19             	movzbl (%ecx),%ebx
  800982:	84 db                	test   %bl,%bl
  800984:	75 ec                	jne    800972 <strlcpy+0x1c>
  800986:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  800988:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80098b:	29 f0                	sub    %esi,%eax
}
  80098d:	5b                   	pop    %ebx
  80098e:	5e                   	pop    %esi
  80098f:	5d                   	pop    %ebp
  800990:	c3                   	ret    

00800991 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800997:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80099a:	eb 06                	jmp    8009a2 <strcmp+0x11>
		p++, q++;
  80099c:	83 c1 01             	add    $0x1,%ecx
  80099f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009a2:	0f b6 01             	movzbl (%ecx),%eax
  8009a5:	84 c0                	test   %al,%al
  8009a7:	74 04                	je     8009ad <strcmp+0x1c>
  8009a9:	3a 02                	cmp    (%edx),%al
  8009ab:	74 ef                	je     80099c <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ad:	0f b6 c0             	movzbl %al,%eax
  8009b0:	0f b6 12             	movzbl (%edx),%edx
  8009b3:	29 d0                	sub    %edx,%eax
}
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    

008009b7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	53                   	push   %ebx
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c1:	89 c3                	mov    %eax,%ebx
  8009c3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009c6:	eb 06                	jmp    8009ce <strncmp+0x17>
		n--, p++, q++;
  8009c8:	83 c0 01             	add    $0x1,%eax
  8009cb:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009ce:	39 d8                	cmp    %ebx,%eax
  8009d0:	74 15                	je     8009e7 <strncmp+0x30>
  8009d2:	0f b6 08             	movzbl (%eax),%ecx
  8009d5:	84 c9                	test   %cl,%cl
  8009d7:	74 04                	je     8009dd <strncmp+0x26>
  8009d9:	3a 0a                	cmp    (%edx),%cl
  8009db:	74 eb                	je     8009c8 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009dd:	0f b6 00             	movzbl (%eax),%eax
  8009e0:	0f b6 12             	movzbl (%edx),%edx
  8009e3:	29 d0                	sub    %edx,%eax
  8009e5:	eb 05                	jmp    8009ec <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009e7:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009ec:	5b                   	pop    %ebx
  8009ed:	5d                   	pop    %ebp
  8009ee:	c3                   	ret    

008009ef <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009f9:	eb 07                	jmp    800a02 <strchr+0x13>
		if (*s == c)
  8009fb:	38 ca                	cmp    %cl,%dl
  8009fd:	74 0f                	je     800a0e <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009ff:	83 c0 01             	add    $0x1,%eax
  800a02:	0f b6 10             	movzbl (%eax),%edx
  800a05:	84 d2                	test   %dl,%dl
  800a07:	75 f2                	jne    8009fb <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a0e:	5d                   	pop    %ebp
  800a0f:	c3                   	ret    

00800a10 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a1a:	eb 03                	jmp    800a1f <strfind+0xf>
  800a1c:	83 c0 01             	add    $0x1,%eax
  800a1f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a22:	38 ca                	cmp    %cl,%dl
  800a24:	74 04                	je     800a2a <strfind+0x1a>
  800a26:	84 d2                	test   %dl,%dl
  800a28:	75 f2                	jne    800a1c <strfind+0xc>
			break;
	return (char *) s;
}
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    

00800a2c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	57                   	push   %edi
  800a30:	56                   	push   %esi
  800a31:	53                   	push   %ebx
  800a32:	8b 55 08             	mov    0x8(%ebp),%edx
  800a35:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800a38:	85 c9                	test   %ecx,%ecx
  800a3a:	74 37                	je     800a73 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a3c:	f6 c2 03             	test   $0x3,%dl
  800a3f:	75 2a                	jne    800a6b <memset+0x3f>
  800a41:	f6 c1 03             	test   $0x3,%cl
  800a44:	75 25                	jne    800a6b <memset+0x3f>
		c &= 0xFF;
  800a46:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a4a:	89 df                	mov    %ebx,%edi
  800a4c:	c1 e7 08             	shl    $0x8,%edi
  800a4f:	89 de                	mov    %ebx,%esi
  800a51:	c1 e6 18             	shl    $0x18,%esi
  800a54:	89 d8                	mov    %ebx,%eax
  800a56:	c1 e0 10             	shl    $0x10,%eax
  800a59:	09 f0                	or     %esi,%eax
  800a5b:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800a5d:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a60:	89 f8                	mov    %edi,%eax
  800a62:	09 d8                	or     %ebx,%eax
  800a64:	89 d7                	mov    %edx,%edi
  800a66:	fc                   	cld    
  800a67:	f3 ab                	rep stos %eax,%es:(%edi)
  800a69:	eb 08                	jmp    800a73 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a6b:	89 d7                	mov    %edx,%edi
  800a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a70:	fc                   	cld    
  800a71:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800a73:	89 d0                	mov    %edx,%eax
  800a75:	5b                   	pop    %ebx
  800a76:	5e                   	pop    %esi
  800a77:	5f                   	pop    %edi
  800a78:	5d                   	pop    %ebp
  800a79:	c3                   	ret    

00800a7a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	57                   	push   %edi
  800a7e:	56                   	push   %esi
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a85:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a88:	39 c6                	cmp    %eax,%esi
  800a8a:	73 35                	jae    800ac1 <memmove+0x47>
  800a8c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a8f:	39 d0                	cmp    %edx,%eax
  800a91:	73 2e                	jae    800ac1 <memmove+0x47>
		s += n;
		d += n;
  800a93:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a96:	89 d6                	mov    %edx,%esi
  800a98:	09 fe                	or     %edi,%esi
  800a9a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aa0:	75 13                	jne    800ab5 <memmove+0x3b>
  800aa2:	f6 c1 03             	test   $0x3,%cl
  800aa5:	75 0e                	jne    800ab5 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  800aa7:	83 ef 04             	sub    $0x4,%edi
  800aaa:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aad:	c1 e9 02             	shr    $0x2,%ecx
  800ab0:	fd                   	std    
  800ab1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ab3:	eb 09                	jmp    800abe <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ab5:	83 ef 01             	sub    $0x1,%edi
  800ab8:	8d 72 ff             	lea    -0x1(%edx),%esi
  800abb:	fd                   	std    
  800abc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800abe:	fc                   	cld    
  800abf:	eb 1d                	jmp    800ade <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ac1:	89 f2                	mov    %esi,%edx
  800ac3:	09 c2                	or     %eax,%edx
  800ac5:	f6 c2 03             	test   $0x3,%dl
  800ac8:	75 0f                	jne    800ad9 <memmove+0x5f>
  800aca:	f6 c1 03             	test   $0x3,%cl
  800acd:	75 0a                	jne    800ad9 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  800acf:	c1 e9 02             	shr    $0x2,%ecx
  800ad2:	89 c7                	mov    %eax,%edi
  800ad4:	fc                   	cld    
  800ad5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad7:	eb 05                	jmp    800ade <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ad9:	89 c7                	mov    %eax,%edi
  800adb:	fc                   	cld    
  800adc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ade:	5e                   	pop    %esi
  800adf:	5f                   	pop    %edi
  800ae0:	5d                   	pop    %ebp
  800ae1:	c3                   	ret    

00800ae2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800ae5:	ff 75 10             	pushl  0x10(%ebp)
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	ff 75 08             	pushl  0x8(%ebp)
  800aee:	e8 87 ff ff ff       	call   800a7a <memmove>
}
  800af3:	c9                   	leave  
  800af4:	c3                   	ret    

00800af5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	56                   	push   %esi
  800af9:	53                   	push   %ebx
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b00:	89 c6                	mov    %eax,%esi
  800b02:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b05:	eb 1a                	jmp    800b21 <memcmp+0x2c>
		if (*s1 != *s2)
  800b07:	0f b6 08             	movzbl (%eax),%ecx
  800b0a:	0f b6 1a             	movzbl (%edx),%ebx
  800b0d:	38 d9                	cmp    %bl,%cl
  800b0f:	74 0a                	je     800b1b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b11:	0f b6 c1             	movzbl %cl,%eax
  800b14:	0f b6 db             	movzbl %bl,%ebx
  800b17:	29 d8                	sub    %ebx,%eax
  800b19:	eb 0f                	jmp    800b2a <memcmp+0x35>
		s1++, s2++;
  800b1b:	83 c0 01             	add    $0x1,%eax
  800b1e:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b21:	39 f0                	cmp    %esi,%eax
  800b23:	75 e2                	jne    800b07 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b2a:	5b                   	pop    %ebx
  800b2b:	5e                   	pop    %esi
  800b2c:	5d                   	pop    %ebp
  800b2d:	c3                   	ret    

00800b2e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b2e:	55                   	push   %ebp
  800b2f:	89 e5                	mov    %esp,%ebp
  800b31:	53                   	push   %ebx
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800b35:	89 c1                	mov    %eax,%ecx
  800b37:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  800b3a:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b3e:	eb 0a                	jmp    800b4a <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b40:	0f b6 10             	movzbl (%eax),%edx
  800b43:	39 da                	cmp    %ebx,%edx
  800b45:	74 07                	je     800b4e <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b47:	83 c0 01             	add    $0x1,%eax
  800b4a:	39 c8                	cmp    %ecx,%eax
  800b4c:	72 f2                	jb     800b40 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b4e:	5b                   	pop    %ebx
  800b4f:	5d                   	pop    %ebp
  800b50:	c3                   	ret    

00800b51 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	57                   	push   %edi
  800b55:	56                   	push   %esi
  800b56:	53                   	push   %ebx
  800b57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b5a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b5d:	eb 03                	jmp    800b62 <strtol+0x11>
		s++;
  800b5f:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b62:	0f b6 01             	movzbl (%ecx),%eax
  800b65:	3c 20                	cmp    $0x20,%al
  800b67:	74 f6                	je     800b5f <strtol+0xe>
  800b69:	3c 09                	cmp    $0x9,%al
  800b6b:	74 f2                	je     800b5f <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b6d:	3c 2b                	cmp    $0x2b,%al
  800b6f:	75 0a                	jne    800b7b <strtol+0x2a>
		s++;
  800b71:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b74:	bf 00 00 00 00       	mov    $0x0,%edi
  800b79:	eb 11                	jmp    800b8c <strtol+0x3b>
  800b7b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b80:	3c 2d                	cmp    $0x2d,%al
  800b82:	75 08                	jne    800b8c <strtol+0x3b>
		s++, neg = 1;
  800b84:	83 c1 01             	add    $0x1,%ecx
  800b87:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b8c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b92:	75 15                	jne    800ba9 <strtol+0x58>
  800b94:	80 39 30             	cmpb   $0x30,(%ecx)
  800b97:	75 10                	jne    800ba9 <strtol+0x58>
  800b99:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b9d:	75 7c                	jne    800c1b <strtol+0xca>
		s += 2, base = 16;
  800b9f:	83 c1 02             	add    $0x2,%ecx
  800ba2:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ba7:	eb 16                	jmp    800bbf <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800ba9:	85 db                	test   %ebx,%ebx
  800bab:	75 12                	jne    800bbf <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bad:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bb2:	80 39 30             	cmpb   $0x30,(%ecx)
  800bb5:	75 08                	jne    800bbf <strtol+0x6e>
		s++, base = 8;
  800bb7:	83 c1 01             	add    $0x1,%ecx
  800bba:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800bbf:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc4:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bc7:	0f b6 11             	movzbl (%ecx),%edx
  800bca:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bcd:	89 f3                	mov    %esi,%ebx
  800bcf:	80 fb 09             	cmp    $0x9,%bl
  800bd2:	77 08                	ja     800bdc <strtol+0x8b>
			dig = *s - '0';
  800bd4:	0f be d2             	movsbl %dl,%edx
  800bd7:	83 ea 30             	sub    $0x30,%edx
  800bda:	eb 22                	jmp    800bfe <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800bdc:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bdf:	89 f3                	mov    %esi,%ebx
  800be1:	80 fb 19             	cmp    $0x19,%bl
  800be4:	77 08                	ja     800bee <strtol+0x9d>
			dig = *s - 'a' + 10;
  800be6:	0f be d2             	movsbl %dl,%edx
  800be9:	83 ea 57             	sub    $0x57,%edx
  800bec:	eb 10                	jmp    800bfe <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800bee:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bf1:	89 f3                	mov    %esi,%ebx
  800bf3:	80 fb 19             	cmp    $0x19,%bl
  800bf6:	77 16                	ja     800c0e <strtol+0xbd>
			dig = *s - 'A' + 10;
  800bf8:	0f be d2             	movsbl %dl,%edx
  800bfb:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800bfe:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c01:	7d 0b                	jge    800c0e <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800c03:	83 c1 01             	add    $0x1,%ecx
  800c06:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c0a:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800c0c:	eb b9                	jmp    800bc7 <strtol+0x76>

	if (endptr)
  800c0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c12:	74 0d                	je     800c21 <strtol+0xd0>
		*endptr = (char *) s;
  800c14:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c17:	89 0e                	mov    %ecx,(%esi)
  800c19:	eb 06                	jmp    800c21 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c1b:	85 db                	test   %ebx,%ebx
  800c1d:	74 98                	je     800bb7 <strtol+0x66>
  800c1f:	eb 9e                	jmp    800bbf <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800c21:	89 c2                	mov    %eax,%edx
  800c23:	f7 da                	neg    %edx
  800c25:	85 ff                	test   %edi,%edi
  800c27:	0f 45 c2             	cmovne %edx,%eax
}
  800c2a:	5b                   	pop    %ebx
  800c2b:	5e                   	pop    %esi
  800c2c:	5f                   	pop    %edi
  800c2d:	5d                   	pop    %ebp
  800c2e:	c3                   	ret    

00800c2f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	57                   	push   %edi
  800c33:	56                   	push   %esi
  800c34:	53                   	push   %ebx
  800c35:	83 ec 1c             	sub    $0x1c,%esp
  800c38:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800c3b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800c3e:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c40:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c43:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c46:	8b 7d 10             	mov    0x10(%ebp),%edi
  800c49:	8b 75 14             	mov    0x14(%ebp),%esi
  800c4c:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c52:	74 1d                	je     800c71 <syscall+0x42>
  800c54:	85 c0                	test   %eax,%eax
  800c56:	7e 19                	jle    800c71 <syscall+0x42>
  800c58:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800c5b:	83 ec 0c             	sub    $0xc,%esp
  800c5e:	50                   	push   %eax
  800c5f:	52                   	push   %edx
  800c60:	68 5f 28 80 00       	push   $0x80285f
  800c65:	6a 23                	push   $0x23
  800c67:	68 7c 28 80 00       	push   $0x80287c
  800c6c:	e8 2b f6 ff ff       	call   80029c <_panic>

	return ret;
}
  800c71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c74:	5b                   	pop    %ebx
  800c75:	5e                   	pop    %esi
  800c76:	5f                   	pop    %edi
  800c77:	5d                   	pop    %ebp
  800c78:	c3                   	ret    

00800c79 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800c7f:	6a 00                	push   $0x0
  800c81:	6a 00                	push   $0x0
  800c83:	6a 00                	push   $0x0
  800c85:	ff 75 0c             	pushl  0xc(%ebp)
  800c88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c90:	b8 00 00 00 00       	mov    $0x0,%eax
  800c95:	e8 95 ff ff ff       	call   800c2f <syscall>
}
  800c9a:	83 c4 10             	add    $0x10,%esp
  800c9d:	c9                   	leave  
  800c9e:	c3                   	ret    

00800c9f <sys_cgetc>:

int
sys_cgetc(void)
{
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
  800ca2:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800ca5:	6a 00                	push   $0x0
  800ca7:	6a 00                	push   $0x0
  800ca9:	6a 00                	push   $0x0
  800cab:	6a 00                	push   $0x0
  800cad:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb2:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb7:	b8 01 00 00 00       	mov    $0x1,%eax
  800cbc:	e8 6e ff ff ff       	call   800c2f <syscall>
}
  800cc1:	c9                   	leave  
  800cc2:	c3                   	ret    

00800cc3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800cc9:	6a 00                	push   $0x0
  800ccb:	6a 00                	push   $0x0
  800ccd:	6a 00                	push   $0x0
  800ccf:	6a 00                	push   $0x0
  800cd1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd4:	ba 01 00 00 00       	mov    $0x1,%edx
  800cd9:	b8 03 00 00 00       	mov    $0x3,%eax
  800cde:	e8 4c ff ff ff       	call   800c2f <syscall>
}
  800ce3:	c9                   	leave  
  800ce4:	c3                   	ret    

00800ce5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
  800ce8:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800ceb:	6a 00                	push   $0x0
  800ced:	6a 00                	push   $0x0
  800cef:	6a 00                	push   $0x0
  800cf1:	6a 00                	push   $0x0
  800cf3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf8:	ba 00 00 00 00       	mov    $0x0,%edx
  800cfd:	b8 02 00 00 00       	mov    $0x2,%eax
  800d02:	e8 28 ff ff ff       	call   800c2f <syscall>
}
  800d07:	c9                   	leave  
  800d08:	c3                   	ret    

00800d09 <sys_yield>:

void
sys_yield(void)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800d0f:	6a 00                	push   $0x0
  800d11:	6a 00                	push   $0x0
  800d13:	6a 00                	push   $0x0
  800d15:	6a 00                	push   $0x0
  800d17:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d21:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d26:	e8 04 ff ff ff       	call   800c2f <syscall>
}
  800d2b:	83 c4 10             	add    $0x10,%esp
  800d2e:	c9                   	leave  
  800d2f:	c3                   	ret    

00800d30 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800d36:	6a 00                	push   $0x0
  800d38:	6a 00                	push   $0x0
  800d3a:	ff 75 10             	pushl  0x10(%ebp)
  800d3d:	ff 75 0c             	pushl  0xc(%ebp)
  800d40:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d43:	ba 01 00 00 00       	mov    $0x1,%edx
  800d48:	b8 04 00 00 00       	mov    $0x4,%eax
  800d4d:	e8 dd fe ff ff       	call   800c2f <syscall>
}
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800d5a:	ff 75 18             	pushl  0x18(%ebp)
  800d5d:	ff 75 14             	pushl  0x14(%ebp)
  800d60:	ff 75 10             	pushl  0x10(%ebp)
  800d63:	ff 75 0c             	pushl  0xc(%ebp)
  800d66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d69:	ba 01 00 00 00       	mov    $0x1,%edx
  800d6e:	b8 05 00 00 00       	mov    $0x5,%eax
  800d73:	e8 b7 fe ff ff       	call   800c2f <syscall>
}
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    

00800d7a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800d80:	6a 00                	push   $0x0
  800d82:	6a 00                	push   $0x0
  800d84:	6a 00                	push   $0x0
  800d86:	ff 75 0c             	pushl  0xc(%ebp)
  800d89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d8c:	ba 01 00 00 00       	mov    $0x1,%edx
  800d91:	b8 06 00 00 00       	mov    $0x6,%eax
  800d96:	e8 94 fe ff ff       	call   800c2f <syscall>
}
  800d9b:	c9                   	leave  
  800d9c:	c3                   	ret    

00800d9d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800da3:	6a 00                	push   $0x0
  800da5:	6a 00                	push   $0x0
  800da7:	6a 00                	push   $0x0
  800da9:	ff 75 0c             	pushl  0xc(%ebp)
  800dac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800daf:	ba 01 00 00 00       	mov    $0x1,%edx
  800db4:	b8 08 00 00 00       	mov    $0x8,%eax
  800db9:	e8 71 fe ff ff       	call   800c2f <syscall>
}
  800dbe:	c9                   	leave  
  800dbf:	c3                   	ret    

00800dc0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800dc6:	6a 00                	push   $0x0
  800dc8:	6a 00                	push   $0x0
  800dca:	6a 00                	push   $0x0
  800dcc:	ff 75 0c             	pushl  0xc(%ebp)
  800dcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dd2:	ba 01 00 00 00       	mov    $0x1,%edx
  800dd7:	b8 09 00 00 00       	mov    $0x9,%eax
  800ddc:	e8 4e fe ff ff       	call   800c2f <syscall>
}
  800de1:	c9                   	leave  
  800de2:	c3                   	ret    

00800de3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800de9:	6a 00                	push   $0x0
  800deb:	6a 00                	push   $0x0
  800ded:	6a 00                	push   $0x0
  800def:	ff 75 0c             	pushl  0xc(%ebp)
  800df2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800df5:	ba 01 00 00 00       	mov    $0x1,%edx
  800dfa:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dff:	e8 2b fe ff ff       	call   800c2f <syscall>
}
  800e04:	c9                   	leave  
  800e05:	c3                   	ret    

00800e06 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800e0c:	6a 00                	push   $0x0
  800e0e:	ff 75 14             	pushl  0x14(%ebp)
  800e11:	ff 75 10             	pushl  0x10(%ebp)
  800e14:	ff 75 0c             	pushl  0xc(%ebp)
  800e17:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e1f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e24:	e8 06 fe ff ff       	call   800c2f <syscall>
}
  800e29:	c9                   	leave  
  800e2a:	c3                   	ret    

00800e2b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800e31:	6a 00                	push   $0x0
  800e33:	6a 00                	push   $0x0
  800e35:	6a 00                	push   $0x0
  800e37:	6a 00                	push   $0x0
  800e39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e3c:	ba 01 00 00 00       	mov    $0x1,%edx
  800e41:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e46:	e8 e4 fd ff ff       	call   800c2f <syscall>
}
  800e4b:	c9                   	leave  
  800e4c:	c3                   	ret    

00800e4d <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	53                   	push   %ebx
  800e51:	83 ec 04             	sub    $0x4,%esp

	int perm_w = PTE_COW|PTE_U|PTE_P;
	int perm = PTE_U|PTE_P;

	// LAB 4: Your code here.
	void *addr = (void*) (pn*PGSIZE);
  800e54:	89 d3                	mov    %edx,%ebx
  800e56:	c1 e3 0c             	shl    $0xc,%ebx

	//Si una página tiene el bit PTE_SHARE, se comparte con el hijo con los mismos permisos.
  	if (uvpt[pn] & PTE_SHARE) {
  800e59:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800e60:	f6 c5 04             	test   $0x4,%ch
  800e63:	74 3a                	je     800e9f <duppage+0x52>
    	if (sys_page_map(0, addr, envid,addr, uvpt[pn] & PTE_SYSCALL) < 0) {
  800e65:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e6c:	83 ec 0c             	sub    $0xc,%esp
  800e6f:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800e75:	52                   	push   %edx
  800e76:	53                   	push   %ebx
  800e77:	50                   	push   %eax
  800e78:	53                   	push   %ebx
  800e79:	6a 00                	push   $0x0
  800e7b:	e8 d4 fe ff ff       	call   800d54 <sys_page_map>
  800e80:	83 c4 20             	add    $0x20,%esp
  800e83:	85 c0                	test   %eax,%eax
  800e85:	0f 89 99 00 00 00    	jns    800f24 <duppage+0xd7>
 	     	panic("Error en sys_page_map");
  800e8b:	83 ec 04             	sub    $0x4,%esp
  800e8e:	68 8a 28 80 00       	push   $0x80288a
  800e93:	6a 50                	push   $0x50
  800e95:	68 a0 28 80 00       	push   $0x8028a0
  800e9a:	e8 fd f3 ff ff       	call   80029c <_panic>
    	} 
    	return 0;
	}

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  800e9f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800ea6:	f6 c1 02             	test   $0x2,%cl
  800ea9:	75 0c                	jne    800eb7 <duppage+0x6a>
  800eab:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800eb2:	f6 c6 08             	test   $0x8,%dh
  800eb5:	74 5b                	je     800f12 <duppage+0xc5>
		if (sys_page_map(0, addr, envid, addr, perm_w) < 0){
  800eb7:	83 ec 0c             	sub    $0xc,%esp
  800eba:	68 05 08 00 00       	push   $0x805
  800ebf:	53                   	push   %ebx
  800ec0:	50                   	push   %eax
  800ec1:	53                   	push   %ebx
  800ec2:	6a 00                	push   $0x0
  800ec4:	e8 8b fe ff ff       	call   800d54 <sys_page_map>
  800ec9:	83 c4 20             	add    $0x20,%esp
  800ecc:	85 c0                	test   %eax,%eax
  800ece:	79 14                	jns    800ee4 <duppage+0x97>
			panic("Error mapeando pagina Padre");
  800ed0:	83 ec 04             	sub    $0x4,%esp
  800ed3:	68 ab 28 80 00       	push   $0x8028ab
  800ed8:	6a 57                	push   $0x57
  800eda:	68 a0 28 80 00       	push   $0x8028a0
  800edf:	e8 b8 f3 ff ff       	call   80029c <_panic>
		}
		if (sys_page_map(0, addr, 0, addr, perm_w) < 0){
  800ee4:	83 ec 0c             	sub    $0xc,%esp
  800ee7:	68 05 08 00 00       	push   $0x805
  800eec:	53                   	push   %ebx
  800eed:	6a 00                	push   $0x0
  800eef:	53                   	push   %ebx
  800ef0:	6a 00                	push   $0x0
  800ef2:	e8 5d fe ff ff       	call   800d54 <sys_page_map>
  800ef7:	83 c4 20             	add    $0x20,%esp
  800efa:	85 c0                	test   %eax,%eax
  800efc:	79 26                	jns    800f24 <duppage+0xd7>
			panic("Error mapeando pagina Hijo");
  800efe:	83 ec 04             	sub    $0x4,%esp
  800f01:	68 c7 28 80 00       	push   $0x8028c7
  800f06:	6a 5a                	push   $0x5a
  800f08:	68 a0 28 80 00       	push   $0x8028a0
  800f0d:	e8 8a f3 ff ff       	call   80029c <_panic>
		}
	} else sys_page_map(0, addr, envid, addr, perm);
  800f12:	83 ec 0c             	sub    $0xc,%esp
  800f15:	6a 05                	push   $0x5
  800f17:	53                   	push   %ebx
  800f18:	50                   	push   %eax
  800f19:	53                   	push   %ebx
  800f1a:	6a 00                	push   $0x0
  800f1c:	e8 33 fe ff ff       	call   800d54 <sys_page_map>
  800f21:	83 c4 20             	add    $0x20,%esp
	
	return 0;
}
  800f24:	b8 00 00 00 00       	mov    $0x0,%eax
  800f29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f2c:	c9                   	leave  
  800f2d:	c3                   	ret    

00800f2e <dup_or_share>:
//FORK V0

static void
dup_or_share(envid_t dstenv, void *va, int perm){
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	57                   	push   %edi
  800f32:	56                   	push   %esi
  800f33:	53                   	push   %ebx
  800f34:	83 ec 0c             	sub    $0xc,%esp
  800f37:	89 c7                	mov    %eax,%edi
  800f39:	89 d6                	mov    %edx,%esi
  800f3b:	89 cb                	mov    %ecx,%ebx
	int result;
	// Si no es de escritura, comparto la pagina
	if((perm &PTE_W) != PTE_W){
  800f3d:	f6 c1 02             	test   $0x2,%cl
  800f40:	75 2d                	jne    800f6f <dup_or_share+0x41>
		if((result = sys_page_map(0, va, dstenv, va, perm))<0){
  800f42:	83 ec 0c             	sub    $0xc,%esp
  800f45:	51                   	push   %ecx
  800f46:	52                   	push   %edx
  800f47:	50                   	push   %eax
  800f48:	52                   	push   %edx
  800f49:	6a 00                	push   $0x0
  800f4b:	e8 04 fe ff ff       	call   800d54 <sys_page_map>
  800f50:	83 c4 20             	add    $0x20,%esp
  800f53:	85 c0                	test   %eax,%eax
  800f55:	0f 89 a4 00 00 00    	jns    800fff <dup_or_share+0xd1>
			panic("Error compartiendo la pagina");
  800f5b:	83 ec 04             	sub    $0x4,%esp
  800f5e:	68 e2 28 80 00       	push   $0x8028e2
  800f63:	6a 68                	push   $0x68
  800f65:	68 a0 28 80 00       	push   $0x8028a0
  800f6a:	e8 2d f3 ff ff       	call   80029c <_panic>
		}
	// Si es de escritura comportamiento de duppage, en dumbfork
	}else{
		if ((result = sys_page_alloc(dstenv, va, perm)) < 0){
  800f6f:	83 ec 04             	sub    $0x4,%esp
  800f72:	51                   	push   %ecx
  800f73:	52                   	push   %edx
  800f74:	50                   	push   %eax
  800f75:	e8 b6 fd ff ff       	call   800d30 <sys_page_alloc>
  800f7a:	83 c4 10             	add    $0x10,%esp
  800f7d:	85 c0                	test   %eax,%eax
  800f7f:	79 14                	jns    800f95 <dup_or_share+0x67>
			panic("Error copiando la pagina");
  800f81:	83 ec 04             	sub    $0x4,%esp
  800f84:	68 ff 28 80 00       	push   $0x8028ff
  800f89:	6a 6d                	push   $0x6d
  800f8b:	68 a0 28 80 00       	push   $0x8028a0
  800f90:	e8 07 f3 ff ff       	call   80029c <_panic>
		}
		if ((result = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0){
  800f95:	83 ec 0c             	sub    $0xc,%esp
  800f98:	53                   	push   %ebx
  800f99:	68 00 00 40 00       	push   $0x400000
  800f9e:	6a 00                	push   $0x0
  800fa0:	56                   	push   %esi
  800fa1:	57                   	push   %edi
  800fa2:	e8 ad fd ff ff       	call   800d54 <sys_page_map>
  800fa7:	83 c4 20             	add    $0x20,%esp
  800faa:	85 c0                	test   %eax,%eax
  800fac:	79 14                	jns    800fc2 <dup_or_share+0x94>
			panic("Error copiando la pagina");
  800fae:	83 ec 04             	sub    $0x4,%esp
  800fb1:	68 ff 28 80 00       	push   $0x8028ff
  800fb6:	6a 70                	push   $0x70
  800fb8:	68 a0 28 80 00       	push   $0x8028a0
  800fbd:	e8 da f2 ff ff       	call   80029c <_panic>
		}
		memmove(UTEMP, va, PGSIZE);
  800fc2:	83 ec 04             	sub    $0x4,%esp
  800fc5:	68 00 10 00 00       	push   $0x1000
  800fca:	56                   	push   %esi
  800fcb:	68 00 00 40 00       	push   $0x400000
  800fd0:	e8 a5 fa ff ff       	call   800a7a <memmove>
		if ((result = sys_page_unmap(0, UTEMP)) < 0){
  800fd5:	83 c4 08             	add    $0x8,%esp
  800fd8:	68 00 00 40 00       	push   $0x400000
  800fdd:	6a 00                	push   $0x0
  800fdf:	e8 96 fd ff ff       	call   800d7a <sys_page_unmap>
  800fe4:	83 c4 10             	add    $0x10,%esp
  800fe7:	85 c0                	test   %eax,%eax
  800fe9:	79 14                	jns    800fff <dup_or_share+0xd1>
			panic("Error copiando la pagina");
  800feb:	83 ec 04             	sub    $0x4,%esp
  800fee:	68 ff 28 80 00       	push   $0x8028ff
  800ff3:	6a 74                	push   $0x74
  800ff5:	68 a0 28 80 00       	push   $0x8028a0
  800ffa:	e8 9d f2 ff ff       	call   80029c <_panic>
		}
	}	
}
  800fff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801002:	5b                   	pop    %ebx
  801003:	5e                   	pop    %esi
  801004:	5f                   	pop    %edi
  801005:	5d                   	pop    %ebp
  801006:	c3                   	ret    

00801007 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	53                   	push   %ebx
  80100b:	83 ec 04             	sub    $0x4,%esp
  80100e:	8b 55 08             	mov    0x8(%ebp),%edx
	void *va = (void *) utf->utf_fault_va;
  801011:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  801013:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801017:	74 2e                	je     801047 <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
  801019:	89 c2                	mov    %eax,%edx
  80101b:	c1 ea 16             	shr    $0x16,%edx
  80101e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  801025:	f6 c2 01             	test   $0x1,%dl
  801028:	74 1d                	je     801047 <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
  80102a:	89 c2                	mov    %eax,%edx
  80102c:	c1 ea 0c             	shr    $0xc,%edx
  80102f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
		(uvpd[PDX(va)] & PTE_P) && 
  801036:	f6 c1 01             	test   $0x1,%cl
  801039:	74 0c                	je     801047 <pgfault+0x40>
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
  80103b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  801042:	f6 c6 08             	test   $0x8,%dh
  801045:	75 14                	jne    80105b <pgfault+0x54>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
		panic("No es copy-on-write");
  801047:	83 ec 04             	sub    $0x4,%esp
  80104a:	68 18 29 80 00       	push   $0x802918
  80104f:	6a 21                	push   $0x21
  801051:	68 a0 28 80 00       	push   $0x8028a0
  801056:	e8 41 f2 ff ff       	call   80029c <_panic>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	va = ROUNDDOWN(va, PGSIZE);
  80105b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801060:	89 c3                	mov    %eax,%ebx
	if (sys_page_alloc(0, PFTEMP, perm) < 0){
  801062:	83 ec 04             	sub    $0x4,%esp
  801065:	6a 07                	push   $0x7
  801067:	68 00 f0 7f 00       	push   $0x7ff000
  80106c:	6a 00                	push   $0x0
  80106e:	e8 bd fc ff ff       	call   800d30 <sys_page_alloc>
  801073:	83 c4 10             	add    $0x10,%esp
  801076:	85 c0                	test   %eax,%eax
  801078:	79 14                	jns    80108e <pgfault+0x87>
		panic("Error sys_page_alloc");
  80107a:	83 ec 04             	sub    $0x4,%esp
  80107d:	68 2c 29 80 00       	push   $0x80292c
  801082:	6a 2a                	push   $0x2a
  801084:	68 a0 28 80 00       	push   $0x8028a0
  801089:	e8 0e f2 ff ff       	call   80029c <_panic>
	}
	memcpy(PFTEMP, va, PGSIZE);
  80108e:	83 ec 04             	sub    $0x4,%esp
  801091:	68 00 10 00 00       	push   $0x1000
  801096:	53                   	push   %ebx
  801097:	68 00 f0 7f 00       	push   $0x7ff000
  80109c:	e8 41 fa ff ff       	call   800ae2 <memcpy>
	if (sys_page_map(0, PFTEMP, 0, va, perm) < 0){
  8010a1:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8010a8:	53                   	push   %ebx
  8010a9:	6a 00                	push   $0x0
  8010ab:	68 00 f0 7f 00       	push   $0x7ff000
  8010b0:	6a 00                	push   $0x0
  8010b2:	e8 9d fc ff ff       	call   800d54 <sys_page_map>
  8010b7:	83 c4 20             	add    $0x20,%esp
  8010ba:	85 c0                	test   %eax,%eax
  8010bc:	79 14                	jns    8010d2 <pgfault+0xcb>
		panic("Error sys_page_map");
  8010be:	83 ec 04             	sub    $0x4,%esp
  8010c1:	68 41 29 80 00       	push   $0x802941
  8010c6:	6a 2e                	push   $0x2e
  8010c8:	68 a0 28 80 00       	push   $0x8028a0
  8010cd:	e8 ca f1 ff ff       	call   80029c <_panic>
	}
	if (sys_page_unmap(0, PFTEMP) < 0){
  8010d2:	83 ec 08             	sub    $0x8,%esp
  8010d5:	68 00 f0 7f 00       	push   $0x7ff000
  8010da:	6a 00                	push   $0x0
  8010dc:	e8 99 fc ff ff       	call   800d7a <sys_page_unmap>
  8010e1:	83 c4 10             	add    $0x10,%esp
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	79 14                	jns    8010fc <pgfault+0xf5>
		panic("Error sys_page_unmap");
  8010e8:	83 ec 04             	sub    $0x4,%esp
  8010eb:	68 54 29 80 00       	push   $0x802954
  8010f0:	6a 31                	push   $0x31
  8010f2:	68 a0 28 80 00       	push   $0x8028a0
  8010f7:	e8 a0 f1 ff ff       	call   80029c <_panic>
	}
	return;

}
  8010fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010ff:	c9                   	leave  
  801100:	c3                   	ret    

00801101 <fork_v0>:
		}
	}	
}

envid_t
fork_v0(void){
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
  801104:	57                   	push   %edi
  801105:	56                   	push   %esi
  801106:	53                   	push   %ebx
  801107:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80110a:	b8 07 00 00 00       	mov    $0x7,%eax
  80110f:	cd 30                	int    $0x30
  801111:	89 c6                	mov    %eax,%esi
	envid_t envid;
	uint8_t *va;
	int result;	

	envid = sys_exofork();
	if (envid < 0)
  801113:	85 c0                	test   %eax,%eax
  801115:	79 15                	jns    80112c <fork_v0+0x2b>
		panic("sys_exofork: %e", envid);
  801117:	50                   	push   %eax
  801118:	68 69 29 80 00       	push   $0x802969
  80111d:	68 81 00 00 00       	push   $0x81
  801122:	68 a0 28 80 00       	push   $0x8028a0
  801127:	e8 70 f1 ff ff       	call   80029c <_panic>
  80112c:	89 c7                	mov    %eax,%edi
  80112e:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {		
  801133:	85 c0                	test   %eax,%eax
  801135:	75 1e                	jne    801155 <fork_v0+0x54>
		thisenv = &envs[ENVX(sys_getenvid())];
  801137:	e8 a9 fb ff ff       	call   800ce5 <sys_getenvid>
  80113c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801141:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801144:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801149:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  80114e:	b8 00 00 00 00       	mov    $0x0,%eax
  801153:	eb 7a                	jmp    8011cf <fork_v0+0xce>
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  801155:	89 d8                	mov    %ebx,%eax
  801157:	c1 e8 16             	shr    $0x16,%eax
  80115a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801161:	a8 01                	test   $0x1,%al
  801163:	74 33                	je     801198 <fork_v0+0x97>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  801165:	89 d8                	mov    %ebx,%eax
  801167:	c1 e8 0c             	shr    $0xc,%eax
  80116a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801171:	f6 c2 01             	test   $0x1,%dl
  801174:	74 22                	je     801198 <fork_v0+0x97>
  801176:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80117d:	f6 c2 04             	test   $0x4,%dl
  801180:	74 16                	je     801198 <fork_v0+0x97>
				pte_t pte =uvpt[PGNUM(va)];
  801182:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
  801189:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80118f:	89 da                	mov    %ebx,%edx
  801191:	89 f8                	mov    %edi,%eax
  801193:	e8 96 fd ff ff       	call   800f2e <dup_or_share>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
  801198:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80119e:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  8011a4:	75 af                	jne    801155 <fork_v0+0x54>
				pte_t pte =uvpt[PGNUM(va)];
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
			}
		}
	}	
	if ((result = sys_env_set_status(envid, ENV_RUNNABLE)) < 0){
  8011a6:	83 ec 08             	sub    $0x8,%esp
  8011a9:	6a 02                	push   $0x2
  8011ab:	56                   	push   %esi
  8011ac:	e8 ec fb ff ff       	call   800d9d <sys_env_set_status>
  8011b1:	83 c4 10             	add    $0x10,%esp
  8011b4:	85 c0                	test   %eax,%eax
  8011b6:	79 15                	jns    8011cd <fork_v0+0xcc>

		panic("sys_env_set_status: %e", result);
  8011b8:	50                   	push   %eax
  8011b9:	68 79 29 80 00       	push   $0x802979
  8011be:	68 90 00 00 00       	push   $0x90
  8011c3:	68 a0 28 80 00       	push   $0x8028a0
  8011c8:	e8 cf f0 ff ff       	call   80029c <_panic>
	}
	return envid;
  8011cd:	89 f0                	mov    %esi,%eax
}
  8011cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d2:	5b                   	pop    %ebx
  8011d3:	5e                   	pop    %esi
  8011d4:	5f                   	pop    %edi
  8011d5:	5d                   	pop    %ebp
  8011d6:	c3                   	ret    

008011d7 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	57                   	push   %edi
  8011db:	56                   	push   %esi
  8011dc:	53                   	push   %ebx
  8011dd:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  8011e0:	68 07 10 80 00       	push   $0x801007
  8011e5:	e8 27 0e 00 00       	call   802011 <set_pgfault_handler>
  8011ea:	b8 07 00 00 00       	mov    $0x7,%eax
  8011ef:	cd 30                	int    $0x30
  8011f1:	89 c6                	mov    %eax,%esi

	envid_t envid;
	uint32_t va;
	envid = sys_exofork();
	if (envid < 0){
  8011f3:	83 c4 10             	add    $0x10,%esp
  8011f6:	85 c0                	test   %eax,%eax
  8011f8:	79 15                	jns    80120f <fork+0x38>
		panic("sys_exofork: %e", envid);
  8011fa:	50                   	push   %eax
  8011fb:	68 69 29 80 00       	push   $0x802969
  801200:	68 b1 00 00 00       	push   $0xb1
  801205:	68 a0 28 80 00       	push   $0x8028a0
  80120a:	e8 8d f0 ff ff       	call   80029c <_panic>
  80120f:	89 c7                	mov    %eax,%edi
  801211:	bb 00 00 00 00       	mov    $0x0,%ebx
	}
	if (envid == 0) {		
  801216:	85 c0                	test   %eax,%eax
  801218:	75 21                	jne    80123b <fork+0x64>
		thisenv = &envs[ENVX(sys_getenvid())];
  80121a:	e8 c6 fa ff ff       	call   800ce5 <sys_getenvid>
  80121f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801224:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801227:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80122c:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801231:	b8 00 00 00 00       	mov    $0x0,%eax
  801236:	e9 a7 00 00 00       	jmp    8012e2 <fork+0x10b>
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  80123b:	89 d8                	mov    %ebx,%eax
  80123d:	c1 e8 16             	shr    $0x16,%eax
  801240:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801247:	a8 01                	test   $0x1,%al
  801249:	74 22                	je     80126d <fork+0x96>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  80124b:	89 da                	mov    %ebx,%edx
  80124d:	c1 ea 0c             	shr    $0xc,%edx
  801250:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801257:	a8 01                	test   $0x1,%al
  801259:	74 12                	je     80126d <fork+0x96>
  80125b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801262:	a8 04                	test   $0x4,%al
  801264:	74 07                	je     80126d <fork+0x96>
				duppage(envid, PGNUM(va));			
  801266:	89 f8                	mov    %edi,%eax
  801268:	e8 e0 fb ff ff       	call   800e4d <duppage>
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
  80126d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801273:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801279:	75 c0                	jne    80123b <fork+0x64>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
				duppage(envid, PGNUM(va));			
			}
		}
	}
	if (sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P) < 0){
  80127b:	83 ec 04             	sub    $0x4,%esp
  80127e:	6a 07                	push   $0x7
  801280:	68 00 f0 bf ee       	push   $0xeebff000
  801285:	56                   	push   %esi
  801286:	e8 a5 fa ff ff       	call   800d30 <sys_page_alloc>
  80128b:	83 c4 10             	add    $0x10,%esp
  80128e:	85 c0                	test   %eax,%eax
  801290:	79 17                	jns    8012a9 <fork+0xd2>
		panic("Se escribio en la pagina de excepciones");
  801292:	83 ec 04             	sub    $0x4,%esp
  801295:	68 a8 29 80 00       	push   $0x8029a8
  80129a:	68 c0 00 00 00       	push   $0xc0
  80129f:	68 a0 28 80 00       	push   $0x8028a0
  8012a4:	e8 f3 ef ff ff       	call   80029c <_panic>
	}	
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8012a9:	83 ec 08             	sub    $0x8,%esp
  8012ac:	68 80 20 80 00       	push   $0x802080
  8012b1:	56                   	push   %esi
  8012b2:	e8 2c fb ff ff       	call   800de3 <sys_env_set_pgfault_upcall>

	if (sys_env_set_status(envid, ENV_RUNNABLE) < 0)
  8012b7:	83 c4 08             	add    $0x8,%esp
  8012ba:	6a 02                	push   $0x2
  8012bc:	56                   	push   %esi
  8012bd:	e8 db fa ff ff       	call   800d9d <sys_env_set_status>
  8012c2:	83 c4 10             	add    $0x10,%esp
  8012c5:	85 c0                	test   %eax,%eax
  8012c7:	79 17                	jns    8012e0 <fork+0x109>
		panic("Status incorrecto de enviroment");
  8012c9:	83 ec 04             	sub    $0x4,%esp
  8012cc:	68 d0 29 80 00       	push   $0x8029d0
  8012d1:	68 c5 00 00 00       	push   $0xc5
  8012d6:	68 a0 28 80 00       	push   $0x8028a0
  8012db:	e8 bc ef ff ff       	call   80029c <_panic>

	return envid;
  8012e0:	89 f0                	mov    %esi,%eax
	
}
  8012e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e5:	5b                   	pop    %ebx
  8012e6:	5e                   	pop    %esi
  8012e7:	5f                   	pop    %edi
  8012e8:	5d                   	pop    %ebp
  8012e9:	c3                   	ret    

008012ea <sfork>:


// Challenge!
int
sfork(void)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8012f0:	68 90 29 80 00       	push   $0x802990
  8012f5:	68 d1 00 00 00       	push   $0xd1
  8012fa:	68 a0 28 80 00       	push   $0x8028a0
  8012ff:	e8 98 ef ff ff       	call   80029c <_panic>

00801304 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801304:	55                   	push   %ebp
  801305:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	05 00 00 00 30       	add    $0x30000000,%eax
  80130f:	c1 e8 0c             	shr    $0xc,%eax
}
  801312:	5d                   	pop    %ebp
  801313:	c3                   	ret    

00801314 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  801317:	ff 75 08             	pushl  0x8(%ebp)
  80131a:	e8 e5 ff ff ff       	call   801304 <fd2num>
  80131f:	83 c4 04             	add    $0x4,%esp
  801322:	c1 e0 0c             	shl    $0xc,%eax
  801325:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801332:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801337:	89 c2                	mov    %eax,%edx
  801339:	c1 ea 16             	shr    $0x16,%edx
  80133c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801343:	f6 c2 01             	test   $0x1,%dl
  801346:	74 11                	je     801359 <fd_alloc+0x2d>
  801348:	89 c2                	mov    %eax,%edx
  80134a:	c1 ea 0c             	shr    $0xc,%edx
  80134d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801354:	f6 c2 01             	test   $0x1,%dl
  801357:	75 09                	jne    801362 <fd_alloc+0x36>
			*fd_store = fd;
  801359:	89 01                	mov    %eax,(%ecx)
			return 0;
  80135b:	b8 00 00 00 00       	mov    $0x0,%eax
  801360:	eb 17                	jmp    801379 <fd_alloc+0x4d>
  801362:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801367:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80136c:	75 c9                	jne    801337 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80136e:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801374:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801379:	5d                   	pop    %ebp
  80137a:	c3                   	ret    

0080137b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801381:	83 f8 1f             	cmp    $0x1f,%eax
  801384:	77 36                	ja     8013bc <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801386:	c1 e0 0c             	shl    $0xc,%eax
  801389:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80138e:	89 c2                	mov    %eax,%edx
  801390:	c1 ea 16             	shr    $0x16,%edx
  801393:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80139a:	f6 c2 01             	test   $0x1,%dl
  80139d:	74 24                	je     8013c3 <fd_lookup+0x48>
  80139f:	89 c2                	mov    %eax,%edx
  8013a1:	c1 ea 0c             	shr    $0xc,%edx
  8013a4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013ab:	f6 c2 01             	test   $0x1,%dl
  8013ae:	74 1a                	je     8013ca <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b3:	89 02                	mov    %eax,(%edx)
	return 0;
  8013b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ba:	eb 13                	jmp    8013cf <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8013bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c1:	eb 0c                	jmp    8013cf <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8013c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c8:	eb 05                	jmp    8013cf <fd_lookup+0x54>
  8013ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8013cf:	5d                   	pop    %ebp
  8013d0:	c3                   	ret    

008013d1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
  8013d4:	83 ec 08             	sub    $0x8,%esp
  8013d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013da:	ba 6c 2a 80 00       	mov    $0x802a6c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8013df:	eb 13                	jmp    8013f4 <dev_lookup+0x23>
  8013e1:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  8013e4:	39 08                	cmp    %ecx,(%eax)
  8013e6:	75 0c                	jne    8013f4 <dev_lookup+0x23>
			*dev = devtab[i];
  8013e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013eb:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f2:	eb 2e                	jmp    801422 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8013f4:	8b 02                	mov    (%edx),%eax
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	75 e7                	jne    8013e1 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013fa:	a1 04 40 80 00       	mov    0x804004,%eax
  8013ff:	8b 40 48             	mov    0x48(%eax),%eax
  801402:	83 ec 04             	sub    $0x4,%esp
  801405:	51                   	push   %ecx
  801406:	50                   	push   %eax
  801407:	68 f0 29 80 00       	push   $0x8029f0
  80140c:	e8 64 ef ff ff       	call   800375 <cprintf>
	*dev = 0;
  801411:	8b 45 0c             	mov    0xc(%ebp),%eax
  801414:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80141a:	83 c4 10             	add    $0x10,%esp
  80141d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	56                   	push   %esi
  801428:	53                   	push   %ebx
  801429:	83 ec 10             	sub    $0x10,%esp
  80142c:	8b 75 08             	mov    0x8(%ebp),%esi
  80142f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801432:	56                   	push   %esi
  801433:	e8 cc fe ff ff       	call   801304 <fd2num>
  801438:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80143b:	89 14 24             	mov    %edx,(%esp)
  80143e:	50                   	push   %eax
  80143f:	e8 37 ff ff ff       	call   80137b <fd_lookup>
  801444:	83 c4 08             	add    $0x8,%esp
  801447:	85 c0                	test   %eax,%eax
  801449:	78 05                	js     801450 <fd_close+0x2c>
	    || fd != fd2)
  80144b:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80144e:	74 0c                	je     80145c <fd_close+0x38>
		return (must_exist ? r : 0);
  801450:	84 db                	test   %bl,%bl
  801452:	ba 00 00 00 00       	mov    $0x0,%edx
  801457:	0f 44 c2             	cmove  %edx,%eax
  80145a:	eb 41                	jmp    80149d <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80145c:	83 ec 08             	sub    $0x8,%esp
  80145f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801462:	50                   	push   %eax
  801463:	ff 36                	pushl  (%esi)
  801465:	e8 67 ff ff ff       	call   8013d1 <dev_lookup>
  80146a:	89 c3                	mov    %eax,%ebx
  80146c:	83 c4 10             	add    $0x10,%esp
  80146f:	85 c0                	test   %eax,%eax
  801471:	78 1a                	js     80148d <fd_close+0x69>
		if (dev->dev_close)
  801473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801476:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801479:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80147e:	85 c0                	test   %eax,%eax
  801480:	74 0b                	je     80148d <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  801482:	83 ec 0c             	sub    $0xc,%esp
  801485:	56                   	push   %esi
  801486:	ff d0                	call   *%eax
  801488:	89 c3                	mov    %eax,%ebx
  80148a:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80148d:	83 ec 08             	sub    $0x8,%esp
  801490:	56                   	push   %esi
  801491:	6a 00                	push   $0x0
  801493:	e8 e2 f8 ff ff       	call   800d7a <sys_page_unmap>
	return r;
  801498:	83 c4 10             	add    $0x10,%esp
  80149b:	89 d8                	mov    %ebx,%eax
}
  80149d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014a0:	5b                   	pop    %ebx
  8014a1:	5e                   	pop    %esi
  8014a2:	5d                   	pop    %ebp
  8014a3:	c3                   	ret    

008014a4 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ad:	50                   	push   %eax
  8014ae:	ff 75 08             	pushl  0x8(%ebp)
  8014b1:	e8 c5 fe ff ff       	call   80137b <fd_lookup>
  8014b6:	83 c4 08             	add    $0x8,%esp
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	78 10                	js     8014cd <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8014bd:	83 ec 08             	sub    $0x8,%esp
  8014c0:	6a 01                	push   $0x1
  8014c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8014c5:	e8 5a ff ff ff       	call   801424 <fd_close>
  8014ca:	83 c4 10             	add    $0x10,%esp
}
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <close_all>:

void
close_all(void)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
  8014d2:	53                   	push   %ebx
  8014d3:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014d6:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014db:	83 ec 0c             	sub    $0xc,%esp
  8014de:	53                   	push   %ebx
  8014df:	e8 c0 ff ff ff       	call   8014a4 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8014e4:	83 c3 01             	add    $0x1,%ebx
  8014e7:	83 c4 10             	add    $0x10,%esp
  8014ea:	83 fb 20             	cmp    $0x20,%ebx
  8014ed:	75 ec                	jne    8014db <close_all+0xc>
		close(i);
}
  8014ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	57                   	push   %edi
  8014f8:	56                   	push   %esi
  8014f9:	53                   	push   %ebx
  8014fa:	83 ec 2c             	sub    $0x2c,%esp
  8014fd:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801500:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801503:	50                   	push   %eax
  801504:	ff 75 08             	pushl  0x8(%ebp)
  801507:	e8 6f fe ff ff       	call   80137b <fd_lookup>
  80150c:	83 c4 08             	add    $0x8,%esp
  80150f:	85 c0                	test   %eax,%eax
  801511:	0f 88 c1 00 00 00    	js     8015d8 <dup+0xe4>
		return r;
	close(newfdnum);
  801517:	83 ec 0c             	sub    $0xc,%esp
  80151a:	56                   	push   %esi
  80151b:	e8 84 ff ff ff       	call   8014a4 <close>

	newfd = INDEX2FD(newfdnum);
  801520:	89 f3                	mov    %esi,%ebx
  801522:	c1 e3 0c             	shl    $0xc,%ebx
  801525:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  80152b:	83 c4 04             	add    $0x4,%esp
  80152e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801531:	e8 de fd ff ff       	call   801314 <fd2data>
  801536:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  801538:	89 1c 24             	mov    %ebx,(%esp)
  80153b:	e8 d4 fd ff ff       	call   801314 <fd2data>
  801540:	83 c4 10             	add    $0x10,%esp
  801543:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801546:	89 f8                	mov    %edi,%eax
  801548:	c1 e8 16             	shr    $0x16,%eax
  80154b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801552:	a8 01                	test   $0x1,%al
  801554:	74 37                	je     80158d <dup+0x99>
  801556:	89 f8                	mov    %edi,%eax
  801558:	c1 e8 0c             	shr    $0xc,%eax
  80155b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801562:	f6 c2 01             	test   $0x1,%dl
  801565:	74 26                	je     80158d <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801567:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80156e:	83 ec 0c             	sub    $0xc,%esp
  801571:	25 07 0e 00 00       	and    $0xe07,%eax
  801576:	50                   	push   %eax
  801577:	ff 75 d4             	pushl  -0x2c(%ebp)
  80157a:	6a 00                	push   $0x0
  80157c:	57                   	push   %edi
  80157d:	6a 00                	push   $0x0
  80157f:	e8 d0 f7 ff ff       	call   800d54 <sys_page_map>
  801584:	89 c7                	mov    %eax,%edi
  801586:	83 c4 20             	add    $0x20,%esp
  801589:	85 c0                	test   %eax,%eax
  80158b:	78 2e                	js     8015bb <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80158d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801590:	89 d0                	mov    %edx,%eax
  801592:	c1 e8 0c             	shr    $0xc,%eax
  801595:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80159c:	83 ec 0c             	sub    $0xc,%esp
  80159f:	25 07 0e 00 00       	and    $0xe07,%eax
  8015a4:	50                   	push   %eax
  8015a5:	53                   	push   %ebx
  8015a6:	6a 00                	push   $0x0
  8015a8:	52                   	push   %edx
  8015a9:	6a 00                	push   $0x0
  8015ab:	e8 a4 f7 ff ff       	call   800d54 <sys_page_map>
  8015b0:	89 c7                	mov    %eax,%edi
  8015b2:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  8015b5:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015b7:	85 ff                	test   %edi,%edi
  8015b9:	79 1d                	jns    8015d8 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8015bb:	83 ec 08             	sub    $0x8,%esp
  8015be:	53                   	push   %ebx
  8015bf:	6a 00                	push   $0x0
  8015c1:	e8 b4 f7 ff ff       	call   800d7a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015c6:	83 c4 08             	add    $0x8,%esp
  8015c9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8015cc:	6a 00                	push   $0x0
  8015ce:	e8 a7 f7 ff ff       	call   800d7a <sys_page_unmap>
	return r;
  8015d3:	83 c4 10             	add    $0x10,%esp
  8015d6:	89 f8                	mov    %edi,%eax
}
  8015d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015db:	5b                   	pop    %ebx
  8015dc:	5e                   	pop    %esi
  8015dd:	5f                   	pop    %edi
  8015de:	5d                   	pop    %ebp
  8015df:	c3                   	ret    

008015e0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	53                   	push   %ebx
  8015e4:	83 ec 14             	sub    $0x14,%esp
  8015e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ed:	50                   	push   %eax
  8015ee:	53                   	push   %ebx
  8015ef:	e8 87 fd ff ff       	call   80137b <fd_lookup>
  8015f4:	83 c4 08             	add    $0x8,%esp
  8015f7:	89 c2                	mov    %eax,%edx
  8015f9:	85 c0                	test   %eax,%eax
  8015fb:	78 6d                	js     80166a <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015fd:	83 ec 08             	sub    $0x8,%esp
  801600:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801603:	50                   	push   %eax
  801604:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801607:	ff 30                	pushl  (%eax)
  801609:	e8 c3 fd ff ff       	call   8013d1 <dev_lookup>
  80160e:	83 c4 10             	add    $0x10,%esp
  801611:	85 c0                	test   %eax,%eax
  801613:	78 4c                	js     801661 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801615:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801618:	8b 42 08             	mov    0x8(%edx),%eax
  80161b:	83 e0 03             	and    $0x3,%eax
  80161e:	83 f8 01             	cmp    $0x1,%eax
  801621:	75 21                	jne    801644 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801623:	a1 04 40 80 00       	mov    0x804004,%eax
  801628:	8b 40 48             	mov    0x48(%eax),%eax
  80162b:	83 ec 04             	sub    $0x4,%esp
  80162e:	53                   	push   %ebx
  80162f:	50                   	push   %eax
  801630:	68 31 2a 80 00       	push   $0x802a31
  801635:	e8 3b ed ff ff       	call   800375 <cprintf>
		return -E_INVAL;
  80163a:	83 c4 10             	add    $0x10,%esp
  80163d:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801642:	eb 26                	jmp    80166a <read+0x8a>
	}
	if (!dev->dev_read)
  801644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801647:	8b 40 08             	mov    0x8(%eax),%eax
  80164a:	85 c0                	test   %eax,%eax
  80164c:	74 17                	je     801665 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80164e:	83 ec 04             	sub    $0x4,%esp
  801651:	ff 75 10             	pushl  0x10(%ebp)
  801654:	ff 75 0c             	pushl  0xc(%ebp)
  801657:	52                   	push   %edx
  801658:	ff d0                	call   *%eax
  80165a:	89 c2                	mov    %eax,%edx
  80165c:	83 c4 10             	add    $0x10,%esp
  80165f:	eb 09                	jmp    80166a <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801661:	89 c2                	mov    %eax,%edx
  801663:	eb 05                	jmp    80166a <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801665:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  80166a:	89 d0                	mov    %edx,%eax
  80166c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	57                   	push   %edi
  801675:	56                   	push   %esi
  801676:	53                   	push   %ebx
  801677:	83 ec 0c             	sub    $0xc,%esp
  80167a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80167d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801680:	bb 00 00 00 00       	mov    $0x0,%ebx
  801685:	eb 21                	jmp    8016a8 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801687:	83 ec 04             	sub    $0x4,%esp
  80168a:	89 f0                	mov    %esi,%eax
  80168c:	29 d8                	sub    %ebx,%eax
  80168e:	50                   	push   %eax
  80168f:	89 d8                	mov    %ebx,%eax
  801691:	03 45 0c             	add    0xc(%ebp),%eax
  801694:	50                   	push   %eax
  801695:	57                   	push   %edi
  801696:	e8 45 ff ff ff       	call   8015e0 <read>
		if (m < 0)
  80169b:	83 c4 10             	add    $0x10,%esp
  80169e:	85 c0                	test   %eax,%eax
  8016a0:	78 10                	js     8016b2 <readn+0x41>
			return m;
		if (m == 0)
  8016a2:	85 c0                	test   %eax,%eax
  8016a4:	74 0a                	je     8016b0 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016a6:	01 c3                	add    %eax,%ebx
  8016a8:	39 f3                	cmp    %esi,%ebx
  8016aa:	72 db                	jb     801687 <readn+0x16>
  8016ac:	89 d8                	mov    %ebx,%eax
  8016ae:	eb 02                	jmp    8016b2 <readn+0x41>
  8016b0:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8016b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016b5:	5b                   	pop    %ebx
  8016b6:	5e                   	pop    %esi
  8016b7:	5f                   	pop    %edi
  8016b8:	5d                   	pop    %ebp
  8016b9:	c3                   	ret    

008016ba <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
  8016bd:	53                   	push   %ebx
  8016be:	83 ec 14             	sub    $0x14,%esp
  8016c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016c7:	50                   	push   %eax
  8016c8:	53                   	push   %ebx
  8016c9:	e8 ad fc ff ff       	call   80137b <fd_lookup>
  8016ce:	83 c4 08             	add    $0x8,%esp
  8016d1:	89 c2                	mov    %eax,%edx
  8016d3:	85 c0                	test   %eax,%eax
  8016d5:	78 68                	js     80173f <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016d7:	83 ec 08             	sub    $0x8,%esp
  8016da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016dd:	50                   	push   %eax
  8016de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e1:	ff 30                	pushl  (%eax)
  8016e3:	e8 e9 fc ff ff       	call   8013d1 <dev_lookup>
  8016e8:	83 c4 10             	add    $0x10,%esp
  8016eb:	85 c0                	test   %eax,%eax
  8016ed:	78 47                	js     801736 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016f6:	75 21                	jne    801719 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016f8:	a1 04 40 80 00       	mov    0x804004,%eax
  8016fd:	8b 40 48             	mov    0x48(%eax),%eax
  801700:	83 ec 04             	sub    $0x4,%esp
  801703:	53                   	push   %ebx
  801704:	50                   	push   %eax
  801705:	68 4d 2a 80 00       	push   $0x802a4d
  80170a:	e8 66 ec ff ff       	call   800375 <cprintf>
		return -E_INVAL;
  80170f:	83 c4 10             	add    $0x10,%esp
  801712:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801717:	eb 26                	jmp    80173f <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801719:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80171c:	8b 52 0c             	mov    0xc(%edx),%edx
  80171f:	85 d2                	test   %edx,%edx
  801721:	74 17                	je     80173a <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801723:	83 ec 04             	sub    $0x4,%esp
  801726:	ff 75 10             	pushl  0x10(%ebp)
  801729:	ff 75 0c             	pushl  0xc(%ebp)
  80172c:	50                   	push   %eax
  80172d:	ff d2                	call   *%edx
  80172f:	89 c2                	mov    %eax,%edx
  801731:	83 c4 10             	add    $0x10,%esp
  801734:	eb 09                	jmp    80173f <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801736:	89 c2                	mov    %eax,%edx
  801738:	eb 05                	jmp    80173f <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80173a:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  80173f:	89 d0                	mov    %edx,%eax
  801741:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <seek>:

int
seek(int fdnum, off_t offset)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80174c:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80174f:	50                   	push   %eax
  801750:	ff 75 08             	pushl  0x8(%ebp)
  801753:	e8 23 fc ff ff       	call   80137b <fd_lookup>
  801758:	83 c4 08             	add    $0x8,%esp
  80175b:	85 c0                	test   %eax,%eax
  80175d:	78 0e                	js     80176d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80175f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801762:	8b 55 0c             	mov    0xc(%ebp),%edx
  801765:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801768:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
  801772:	53                   	push   %ebx
  801773:	83 ec 14             	sub    $0x14,%esp
  801776:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801779:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80177c:	50                   	push   %eax
  80177d:	53                   	push   %ebx
  80177e:	e8 f8 fb ff ff       	call   80137b <fd_lookup>
  801783:	83 c4 08             	add    $0x8,%esp
  801786:	89 c2                	mov    %eax,%edx
  801788:	85 c0                	test   %eax,%eax
  80178a:	78 65                	js     8017f1 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80178c:	83 ec 08             	sub    $0x8,%esp
  80178f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801792:	50                   	push   %eax
  801793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801796:	ff 30                	pushl  (%eax)
  801798:	e8 34 fc ff ff       	call   8013d1 <dev_lookup>
  80179d:	83 c4 10             	add    $0x10,%esp
  8017a0:	85 c0                	test   %eax,%eax
  8017a2:	78 44                	js     8017e8 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017ab:	75 21                	jne    8017ce <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8017ad:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017b2:	8b 40 48             	mov    0x48(%eax),%eax
  8017b5:	83 ec 04             	sub    $0x4,%esp
  8017b8:	53                   	push   %ebx
  8017b9:	50                   	push   %eax
  8017ba:	68 10 2a 80 00       	push   $0x802a10
  8017bf:	e8 b1 eb ff ff       	call   800375 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8017c4:	83 c4 10             	add    $0x10,%esp
  8017c7:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8017cc:	eb 23                	jmp    8017f1 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  8017ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d1:	8b 52 18             	mov    0x18(%edx),%edx
  8017d4:	85 d2                	test   %edx,%edx
  8017d6:	74 14                	je     8017ec <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017d8:	83 ec 08             	sub    $0x8,%esp
  8017db:	ff 75 0c             	pushl  0xc(%ebp)
  8017de:	50                   	push   %eax
  8017df:	ff d2                	call   *%edx
  8017e1:	89 c2                	mov    %eax,%edx
  8017e3:	83 c4 10             	add    $0x10,%esp
  8017e6:	eb 09                	jmp    8017f1 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017e8:	89 c2                	mov    %eax,%edx
  8017ea:	eb 05                	jmp    8017f1 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8017ec:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  8017f1:	89 d0                	mov    %edx,%eax
  8017f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	53                   	push   %ebx
  8017fc:	83 ec 14             	sub    $0x14,%esp
  8017ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801802:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801805:	50                   	push   %eax
  801806:	ff 75 08             	pushl  0x8(%ebp)
  801809:	e8 6d fb ff ff       	call   80137b <fd_lookup>
  80180e:	83 c4 08             	add    $0x8,%esp
  801811:	89 c2                	mov    %eax,%edx
  801813:	85 c0                	test   %eax,%eax
  801815:	78 58                	js     80186f <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801817:	83 ec 08             	sub    $0x8,%esp
  80181a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80181d:	50                   	push   %eax
  80181e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801821:	ff 30                	pushl  (%eax)
  801823:	e8 a9 fb ff ff       	call   8013d1 <dev_lookup>
  801828:	83 c4 10             	add    $0x10,%esp
  80182b:	85 c0                	test   %eax,%eax
  80182d:	78 37                	js     801866 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  80182f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801832:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801836:	74 32                	je     80186a <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801838:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80183b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801842:	00 00 00 
	stat->st_isdir = 0;
  801845:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80184c:	00 00 00 
	stat->st_dev = dev;
  80184f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801855:	83 ec 08             	sub    $0x8,%esp
  801858:	53                   	push   %ebx
  801859:	ff 75 f0             	pushl  -0x10(%ebp)
  80185c:	ff 50 14             	call   *0x14(%eax)
  80185f:	89 c2                	mov    %eax,%edx
  801861:	83 c4 10             	add    $0x10,%esp
  801864:	eb 09                	jmp    80186f <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801866:	89 c2                	mov    %eax,%edx
  801868:	eb 05                	jmp    80186f <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  80186a:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80186f:	89 d0                	mov    %edx,%eax
  801871:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	56                   	push   %esi
  80187a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80187b:	83 ec 08             	sub    $0x8,%esp
  80187e:	6a 00                	push   $0x0
  801880:	ff 75 08             	pushl  0x8(%ebp)
  801883:	e8 06 02 00 00       	call   801a8e <open>
  801888:	89 c3                	mov    %eax,%ebx
  80188a:	83 c4 10             	add    $0x10,%esp
  80188d:	85 c0                	test   %eax,%eax
  80188f:	78 1b                	js     8018ac <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801891:	83 ec 08             	sub    $0x8,%esp
  801894:	ff 75 0c             	pushl  0xc(%ebp)
  801897:	50                   	push   %eax
  801898:	e8 5b ff ff ff       	call   8017f8 <fstat>
  80189d:	89 c6                	mov    %eax,%esi
	close(fd);
  80189f:	89 1c 24             	mov    %ebx,(%esp)
  8018a2:	e8 fd fb ff ff       	call   8014a4 <close>
	return r;
  8018a7:	83 c4 10             	add    $0x10,%esp
  8018aa:	89 f0                	mov    %esi,%eax
}
  8018ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018af:	5b                   	pop    %ebx
  8018b0:	5e                   	pop    %esi
  8018b1:	5d                   	pop    %ebp
  8018b2:	c3                   	ret    

008018b3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
  8018b6:	56                   	push   %esi
  8018b7:	53                   	push   %ebx
  8018b8:	89 c6                	mov    %eax,%esi
  8018ba:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018bc:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8018c3:	75 12                	jne    8018d7 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018c5:	83 ec 0c             	sub    $0xc,%esp
  8018c8:	6a 01                	push   $0x1
  8018ca:	e8 94 08 00 00       	call   802163 <ipc_find_env>
  8018cf:	a3 00 40 80 00       	mov    %eax,0x804000
  8018d4:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018d7:	6a 07                	push   $0x7
  8018d9:	68 00 50 80 00       	push   $0x805000
  8018de:	56                   	push   %esi
  8018df:	ff 35 00 40 80 00    	pushl  0x804000
  8018e5:	e8 25 08 00 00       	call   80210f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018ea:	83 c4 0c             	add    $0xc,%esp
  8018ed:	6a 00                	push   $0x0
  8018ef:	53                   	push   %ebx
  8018f0:	6a 00                	push   $0x0
  8018f2:	e8 ad 07 00 00       	call   8020a4 <ipc_recv>
}
  8018f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018fa:	5b                   	pop    %ebx
  8018fb:	5e                   	pop    %esi
  8018fc:	5d                   	pop    %ebp
  8018fd:	c3                   	ret    

008018fe <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801904:	8b 45 08             	mov    0x8(%ebp),%eax
  801907:	8b 40 0c             	mov    0xc(%eax),%eax
  80190a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80190f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801912:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801917:	ba 00 00 00 00       	mov    $0x0,%edx
  80191c:	b8 02 00 00 00       	mov    $0x2,%eax
  801921:	e8 8d ff ff ff       	call   8018b3 <fsipc>
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
  80192b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	8b 40 0c             	mov    0xc(%eax),%eax
  801934:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801939:	ba 00 00 00 00       	mov    $0x0,%edx
  80193e:	b8 06 00 00 00       	mov    $0x6,%eax
  801943:	e8 6b ff ff ff       	call   8018b3 <fsipc>
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	53                   	push   %ebx
  80194e:	83 ec 04             	sub    $0x4,%esp
  801951:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	8b 40 0c             	mov    0xc(%eax),%eax
  80195a:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80195f:	ba 00 00 00 00       	mov    $0x0,%edx
  801964:	b8 05 00 00 00       	mov    $0x5,%eax
  801969:	e8 45 ff ff ff       	call   8018b3 <fsipc>
  80196e:	85 c0                	test   %eax,%eax
  801970:	78 2c                	js     80199e <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801972:	83 ec 08             	sub    $0x8,%esp
  801975:	68 00 50 80 00       	push   $0x805000
  80197a:	53                   	push   %ebx
  80197b:	e8 67 ef ff ff       	call   8008e7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801980:	a1 80 50 80 00       	mov    0x805080,%eax
  801985:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80198b:	a1 84 50 80 00       	mov    0x805084,%eax
  801990:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801996:	83 c4 10             	add    $0x10,%esp
  801999:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80199e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	83 ec 08             	sub    $0x8,%esp
  8019a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ac:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019b2:	8b 49 0c             	mov    0xc(%ecx),%ecx
  8019b5:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  8019bb:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8019c0:	76 22                	jbe    8019e4 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  8019c2:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  8019c9:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  8019cc:	83 ec 04             	sub    $0x4,%esp
  8019cf:	68 f8 0f 00 00       	push   $0xff8
  8019d4:	52                   	push   %edx
  8019d5:	68 08 50 80 00       	push   $0x805008
  8019da:	e8 9b f0 ff ff       	call   800a7a <memmove>
  8019df:	83 c4 10             	add    $0x10,%esp
  8019e2:	eb 17                	jmp    8019fb <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  8019e4:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  8019e9:	83 ec 04             	sub    $0x4,%esp
  8019ec:	50                   	push   %eax
  8019ed:	52                   	push   %edx
  8019ee:	68 08 50 80 00       	push   $0x805008
  8019f3:	e8 82 f0 ff ff       	call   800a7a <memmove>
  8019f8:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  8019fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801a00:	b8 04 00 00 00       	mov    $0x4,%eax
  801a05:	e8 a9 fe ff ff       	call   8018b3 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	56                   	push   %esi
  801a10:	53                   	push   %ebx
  801a11:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	8b 40 0c             	mov    0xc(%eax),%eax
  801a1a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a1f:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a25:	ba 00 00 00 00       	mov    $0x0,%edx
  801a2a:	b8 03 00 00 00       	mov    $0x3,%eax
  801a2f:	e8 7f fe ff ff       	call   8018b3 <fsipc>
  801a34:	89 c3                	mov    %eax,%ebx
  801a36:	85 c0                	test   %eax,%eax
  801a38:	78 4b                	js     801a85 <devfile_read+0x79>
		return r;
	assert(r <= n);
  801a3a:	39 c6                	cmp    %eax,%esi
  801a3c:	73 16                	jae    801a54 <devfile_read+0x48>
  801a3e:	68 7c 2a 80 00       	push   $0x802a7c
  801a43:	68 83 2a 80 00       	push   $0x802a83
  801a48:	6a 7c                	push   $0x7c
  801a4a:	68 98 2a 80 00       	push   $0x802a98
  801a4f:	e8 48 e8 ff ff       	call   80029c <_panic>
	assert(r <= PGSIZE);
  801a54:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a59:	7e 16                	jle    801a71 <devfile_read+0x65>
  801a5b:	68 a3 2a 80 00       	push   $0x802aa3
  801a60:	68 83 2a 80 00       	push   $0x802a83
  801a65:	6a 7d                	push   $0x7d
  801a67:	68 98 2a 80 00       	push   $0x802a98
  801a6c:	e8 2b e8 ff ff       	call   80029c <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a71:	83 ec 04             	sub    $0x4,%esp
  801a74:	50                   	push   %eax
  801a75:	68 00 50 80 00       	push   $0x805000
  801a7a:	ff 75 0c             	pushl  0xc(%ebp)
  801a7d:	e8 f8 ef ff ff       	call   800a7a <memmove>
	return r;
  801a82:	83 c4 10             	add    $0x10,%esp
}
  801a85:	89 d8                	mov    %ebx,%eax
  801a87:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a8a:	5b                   	pop    %ebx
  801a8b:	5e                   	pop    %esi
  801a8c:	5d                   	pop    %ebp
  801a8d:	c3                   	ret    

00801a8e <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
  801a91:	53                   	push   %ebx
  801a92:	83 ec 20             	sub    $0x20,%esp
  801a95:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801a98:	53                   	push   %ebx
  801a99:	e8 10 ee ff ff       	call   8008ae <strlen>
  801a9e:	83 c4 10             	add    $0x10,%esp
  801aa1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801aa6:	7f 67                	jg     801b0f <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801aa8:	83 ec 0c             	sub    $0xc,%esp
  801aab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aae:	50                   	push   %eax
  801aaf:	e8 78 f8 ff ff       	call   80132c <fd_alloc>
  801ab4:	83 c4 10             	add    $0x10,%esp
		return r;
  801ab7:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801ab9:	85 c0                	test   %eax,%eax
  801abb:	78 57                	js     801b14 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801abd:	83 ec 08             	sub    $0x8,%esp
  801ac0:	53                   	push   %ebx
  801ac1:	68 00 50 80 00       	push   $0x805000
  801ac6:	e8 1c ee ff ff       	call   8008e7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ace:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ad3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ad6:	b8 01 00 00 00       	mov    $0x1,%eax
  801adb:	e8 d3 fd ff ff       	call   8018b3 <fsipc>
  801ae0:	89 c3                	mov    %eax,%ebx
  801ae2:	83 c4 10             	add    $0x10,%esp
  801ae5:	85 c0                	test   %eax,%eax
  801ae7:	79 14                	jns    801afd <open+0x6f>
		fd_close(fd, 0);
  801ae9:	83 ec 08             	sub    $0x8,%esp
  801aec:	6a 00                	push   $0x0
  801aee:	ff 75 f4             	pushl  -0xc(%ebp)
  801af1:	e8 2e f9 ff ff       	call   801424 <fd_close>
		return r;
  801af6:	83 c4 10             	add    $0x10,%esp
  801af9:	89 da                	mov    %ebx,%edx
  801afb:	eb 17                	jmp    801b14 <open+0x86>
	}

	return fd2num(fd);
  801afd:	83 ec 0c             	sub    $0xc,%esp
  801b00:	ff 75 f4             	pushl  -0xc(%ebp)
  801b03:	e8 fc f7 ff ff       	call   801304 <fd2num>
  801b08:	89 c2                	mov    %eax,%edx
  801b0a:	83 c4 10             	add    $0x10,%esp
  801b0d:	eb 05                	jmp    801b14 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801b0f:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801b14:	89 d0                	mov    %edx,%eax
  801b16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b21:	ba 00 00 00 00       	mov    $0x0,%edx
  801b26:	b8 08 00 00 00       	mov    $0x8,%eax
  801b2b:	e8 83 fd ff ff       	call   8018b3 <fsipc>
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
  801b35:	56                   	push   %esi
  801b36:	53                   	push   %ebx
  801b37:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b3a:	83 ec 0c             	sub    $0xc,%esp
  801b3d:	ff 75 08             	pushl  0x8(%ebp)
  801b40:	e8 cf f7 ff ff       	call   801314 <fd2data>
  801b45:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b47:	83 c4 08             	add    $0x8,%esp
  801b4a:	68 af 2a 80 00       	push   $0x802aaf
  801b4f:	53                   	push   %ebx
  801b50:	e8 92 ed ff ff       	call   8008e7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b55:	8b 46 04             	mov    0x4(%esi),%eax
  801b58:	2b 06                	sub    (%esi),%eax
  801b5a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b60:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b67:	00 00 00 
	stat->st_dev = &devpipe;
  801b6a:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b71:	30 80 00 
	return 0;
}
  801b74:	b8 00 00 00 00       	mov    $0x0,%eax
  801b79:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b7c:	5b                   	pop    %ebx
  801b7d:	5e                   	pop    %esi
  801b7e:	5d                   	pop    %ebp
  801b7f:	c3                   	ret    

00801b80 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	53                   	push   %ebx
  801b84:	83 ec 0c             	sub    $0xc,%esp
  801b87:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b8a:	53                   	push   %ebx
  801b8b:	6a 00                	push   $0x0
  801b8d:	e8 e8 f1 ff ff       	call   800d7a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b92:	89 1c 24             	mov    %ebx,(%esp)
  801b95:	e8 7a f7 ff ff       	call   801314 <fd2data>
  801b9a:	83 c4 08             	add    $0x8,%esp
  801b9d:	50                   	push   %eax
  801b9e:	6a 00                	push   $0x0
  801ba0:	e8 d5 f1 ff ff       	call   800d7a <sys_page_unmap>
}
  801ba5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	57                   	push   %edi
  801bae:	56                   	push   %esi
  801baf:	53                   	push   %ebx
  801bb0:	83 ec 1c             	sub    $0x1c,%esp
  801bb3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801bb6:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801bb8:	a1 04 40 80 00       	mov    0x804004,%eax
  801bbd:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801bc0:	83 ec 0c             	sub    $0xc,%esp
  801bc3:	ff 75 e0             	pushl  -0x20(%ebp)
  801bc6:	e8 d1 05 00 00       	call   80219c <pageref>
  801bcb:	89 c3                	mov    %eax,%ebx
  801bcd:	89 3c 24             	mov    %edi,(%esp)
  801bd0:	e8 c7 05 00 00       	call   80219c <pageref>
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	39 c3                	cmp    %eax,%ebx
  801bda:	0f 94 c1             	sete   %cl
  801bdd:	0f b6 c9             	movzbl %cl,%ecx
  801be0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801be3:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801be9:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801bec:	39 ce                	cmp    %ecx,%esi
  801bee:	74 1b                	je     801c0b <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801bf0:	39 c3                	cmp    %eax,%ebx
  801bf2:	75 c4                	jne    801bb8 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801bf4:	8b 42 58             	mov    0x58(%edx),%eax
  801bf7:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bfa:	50                   	push   %eax
  801bfb:	56                   	push   %esi
  801bfc:	68 b6 2a 80 00       	push   $0x802ab6
  801c01:	e8 6f e7 ff ff       	call   800375 <cprintf>
  801c06:	83 c4 10             	add    $0x10,%esp
  801c09:	eb ad                	jmp    801bb8 <_pipeisclosed+0xe>
	}
}
  801c0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c11:	5b                   	pop    %ebx
  801c12:	5e                   	pop    %esi
  801c13:	5f                   	pop    %edi
  801c14:	5d                   	pop    %ebp
  801c15:	c3                   	ret    

00801c16 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	57                   	push   %edi
  801c1a:	56                   	push   %esi
  801c1b:	53                   	push   %ebx
  801c1c:	83 ec 28             	sub    $0x28,%esp
  801c1f:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801c22:	56                   	push   %esi
  801c23:	e8 ec f6 ff ff       	call   801314 <fd2data>
  801c28:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c2a:	83 c4 10             	add    $0x10,%esp
  801c2d:	bf 00 00 00 00       	mov    $0x0,%edi
  801c32:	eb 4b                	jmp    801c7f <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801c34:	89 da                	mov    %ebx,%edx
  801c36:	89 f0                	mov    %esi,%eax
  801c38:	e8 6d ff ff ff       	call   801baa <_pipeisclosed>
  801c3d:	85 c0                	test   %eax,%eax
  801c3f:	75 48                	jne    801c89 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801c41:	e8 c3 f0 ff ff       	call   800d09 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c46:	8b 43 04             	mov    0x4(%ebx),%eax
  801c49:	8b 0b                	mov    (%ebx),%ecx
  801c4b:	8d 51 20             	lea    0x20(%ecx),%edx
  801c4e:	39 d0                	cmp    %edx,%eax
  801c50:	73 e2                	jae    801c34 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c55:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c59:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c5c:	89 c2                	mov    %eax,%edx
  801c5e:	c1 fa 1f             	sar    $0x1f,%edx
  801c61:	89 d1                	mov    %edx,%ecx
  801c63:	c1 e9 1b             	shr    $0x1b,%ecx
  801c66:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c69:	83 e2 1f             	and    $0x1f,%edx
  801c6c:	29 ca                	sub    %ecx,%edx
  801c6e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c72:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c76:	83 c0 01             	add    $0x1,%eax
  801c79:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c7c:	83 c7 01             	add    $0x1,%edi
  801c7f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c82:	75 c2                	jne    801c46 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801c84:	8b 45 10             	mov    0x10(%ebp),%eax
  801c87:	eb 05                	jmp    801c8e <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801c89:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801c8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c91:	5b                   	pop    %ebx
  801c92:	5e                   	pop    %esi
  801c93:	5f                   	pop    %edi
  801c94:	5d                   	pop    %ebp
  801c95:	c3                   	ret    

00801c96 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
  801c99:	57                   	push   %edi
  801c9a:	56                   	push   %esi
  801c9b:	53                   	push   %ebx
  801c9c:	83 ec 18             	sub    $0x18,%esp
  801c9f:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801ca2:	57                   	push   %edi
  801ca3:	e8 6c f6 ff ff       	call   801314 <fd2data>
  801ca8:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801caa:	83 c4 10             	add    $0x10,%esp
  801cad:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cb2:	eb 3d                	jmp    801cf1 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801cb4:	85 db                	test   %ebx,%ebx
  801cb6:	74 04                	je     801cbc <devpipe_read+0x26>
				return i;
  801cb8:	89 d8                	mov    %ebx,%eax
  801cba:	eb 44                	jmp    801d00 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801cbc:	89 f2                	mov    %esi,%edx
  801cbe:	89 f8                	mov    %edi,%eax
  801cc0:	e8 e5 fe ff ff       	call   801baa <_pipeisclosed>
  801cc5:	85 c0                	test   %eax,%eax
  801cc7:	75 32                	jne    801cfb <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801cc9:	e8 3b f0 ff ff       	call   800d09 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801cce:	8b 06                	mov    (%esi),%eax
  801cd0:	3b 46 04             	cmp    0x4(%esi),%eax
  801cd3:	74 df                	je     801cb4 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cd5:	99                   	cltd   
  801cd6:	c1 ea 1b             	shr    $0x1b,%edx
  801cd9:	01 d0                	add    %edx,%eax
  801cdb:	83 e0 1f             	and    $0x1f,%eax
  801cde:	29 d0                	sub    %edx,%eax
  801ce0:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801ce5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ce8:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801ceb:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801cee:	83 c3 01             	add    $0x1,%ebx
  801cf1:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801cf4:	75 d8                	jne    801cce <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801cf6:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf9:	eb 05                	jmp    801d00 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801cfb:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801d00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d03:	5b                   	pop    %ebx
  801d04:	5e                   	pop    %esi
  801d05:	5f                   	pop    %edi
  801d06:	5d                   	pop    %ebp
  801d07:	c3                   	ret    

00801d08 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
  801d0b:	56                   	push   %esi
  801d0c:	53                   	push   %ebx
  801d0d:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801d10:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d13:	50                   	push   %eax
  801d14:	e8 13 f6 ff ff       	call   80132c <fd_alloc>
  801d19:	83 c4 10             	add    $0x10,%esp
  801d1c:	89 c2                	mov    %eax,%edx
  801d1e:	85 c0                	test   %eax,%eax
  801d20:	0f 88 2c 01 00 00    	js     801e52 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d26:	83 ec 04             	sub    $0x4,%esp
  801d29:	68 07 04 00 00       	push   $0x407
  801d2e:	ff 75 f4             	pushl  -0xc(%ebp)
  801d31:	6a 00                	push   $0x0
  801d33:	e8 f8 ef ff ff       	call   800d30 <sys_page_alloc>
  801d38:	83 c4 10             	add    $0x10,%esp
  801d3b:	89 c2                	mov    %eax,%edx
  801d3d:	85 c0                	test   %eax,%eax
  801d3f:	0f 88 0d 01 00 00    	js     801e52 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801d45:	83 ec 0c             	sub    $0xc,%esp
  801d48:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d4b:	50                   	push   %eax
  801d4c:	e8 db f5 ff ff       	call   80132c <fd_alloc>
  801d51:	89 c3                	mov    %eax,%ebx
  801d53:	83 c4 10             	add    $0x10,%esp
  801d56:	85 c0                	test   %eax,%eax
  801d58:	0f 88 e2 00 00 00    	js     801e40 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d5e:	83 ec 04             	sub    $0x4,%esp
  801d61:	68 07 04 00 00       	push   $0x407
  801d66:	ff 75 f0             	pushl  -0x10(%ebp)
  801d69:	6a 00                	push   $0x0
  801d6b:	e8 c0 ef ff ff       	call   800d30 <sys_page_alloc>
  801d70:	89 c3                	mov    %eax,%ebx
  801d72:	83 c4 10             	add    $0x10,%esp
  801d75:	85 c0                	test   %eax,%eax
  801d77:	0f 88 c3 00 00 00    	js     801e40 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801d7d:	83 ec 0c             	sub    $0xc,%esp
  801d80:	ff 75 f4             	pushl  -0xc(%ebp)
  801d83:	e8 8c f5 ff ff       	call   801314 <fd2data>
  801d88:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d8a:	83 c4 0c             	add    $0xc,%esp
  801d8d:	68 07 04 00 00       	push   $0x407
  801d92:	50                   	push   %eax
  801d93:	6a 00                	push   $0x0
  801d95:	e8 96 ef ff ff       	call   800d30 <sys_page_alloc>
  801d9a:	89 c3                	mov    %eax,%ebx
  801d9c:	83 c4 10             	add    $0x10,%esp
  801d9f:	85 c0                	test   %eax,%eax
  801da1:	0f 88 89 00 00 00    	js     801e30 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801da7:	83 ec 0c             	sub    $0xc,%esp
  801daa:	ff 75 f0             	pushl  -0x10(%ebp)
  801dad:	e8 62 f5 ff ff       	call   801314 <fd2data>
  801db2:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801db9:	50                   	push   %eax
  801dba:	6a 00                	push   $0x0
  801dbc:	56                   	push   %esi
  801dbd:	6a 00                	push   $0x0
  801dbf:	e8 90 ef ff ff       	call   800d54 <sys_page_map>
  801dc4:	89 c3                	mov    %eax,%ebx
  801dc6:	83 c4 20             	add    $0x20,%esp
  801dc9:	85 c0                	test   %eax,%eax
  801dcb:	78 55                	js     801e22 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801dcd:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd6:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801de2:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801deb:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801df7:	83 ec 0c             	sub    $0xc,%esp
  801dfa:	ff 75 f4             	pushl  -0xc(%ebp)
  801dfd:	e8 02 f5 ff ff       	call   801304 <fd2num>
  801e02:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e05:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e07:	83 c4 04             	add    $0x4,%esp
  801e0a:	ff 75 f0             	pushl  -0x10(%ebp)
  801e0d:	e8 f2 f4 ff ff       	call   801304 <fd2num>
  801e12:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e15:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e18:	83 c4 10             	add    $0x10,%esp
  801e1b:	ba 00 00 00 00       	mov    $0x0,%edx
  801e20:	eb 30                	jmp    801e52 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801e22:	83 ec 08             	sub    $0x8,%esp
  801e25:	56                   	push   %esi
  801e26:	6a 00                	push   $0x0
  801e28:	e8 4d ef ff ff       	call   800d7a <sys_page_unmap>
  801e2d:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801e30:	83 ec 08             	sub    $0x8,%esp
  801e33:	ff 75 f0             	pushl  -0x10(%ebp)
  801e36:	6a 00                	push   $0x0
  801e38:	e8 3d ef ff ff       	call   800d7a <sys_page_unmap>
  801e3d:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801e40:	83 ec 08             	sub    $0x8,%esp
  801e43:	ff 75 f4             	pushl  -0xc(%ebp)
  801e46:	6a 00                	push   $0x0
  801e48:	e8 2d ef ff ff       	call   800d7a <sys_page_unmap>
  801e4d:	83 c4 10             	add    $0x10,%esp
  801e50:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  801e52:	89 d0                	mov    %edx,%eax
  801e54:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e57:	5b                   	pop    %ebx
  801e58:	5e                   	pop    %esi
  801e59:	5d                   	pop    %ebp
  801e5a:	c3                   	ret    

00801e5b <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e61:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e64:	50                   	push   %eax
  801e65:	ff 75 08             	pushl  0x8(%ebp)
  801e68:	e8 0e f5 ff ff       	call   80137b <fd_lookup>
  801e6d:	83 c4 10             	add    $0x10,%esp
  801e70:	85 c0                	test   %eax,%eax
  801e72:	78 18                	js     801e8c <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801e74:	83 ec 0c             	sub    $0xc,%esp
  801e77:	ff 75 f4             	pushl  -0xc(%ebp)
  801e7a:	e8 95 f4 ff ff       	call   801314 <fd2data>
	return _pipeisclosed(fd, p);
  801e7f:	89 c2                	mov    %eax,%edx
  801e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e84:	e8 21 fd ff ff       	call   801baa <_pipeisclosed>
  801e89:	83 c4 10             	add    $0x10,%esp
}
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801e91:	b8 00 00 00 00       	mov    $0x0,%eax
  801e96:	5d                   	pop    %ebp
  801e97:	c3                   	ret    

00801e98 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e9e:	68 c9 2a 80 00       	push   $0x802ac9
  801ea3:	ff 75 0c             	pushl  0xc(%ebp)
  801ea6:	e8 3c ea ff ff       	call   8008e7 <strcpy>
	return 0;
}
  801eab:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	57                   	push   %edi
  801eb6:	56                   	push   %esi
  801eb7:	53                   	push   %ebx
  801eb8:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801ebe:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801ec3:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801ec9:	eb 2d                	jmp    801ef8 <devcons_write+0x46>
		m = n - tot;
  801ecb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ece:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801ed0:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801ed3:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801ed8:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801edb:	83 ec 04             	sub    $0x4,%esp
  801ede:	53                   	push   %ebx
  801edf:	03 45 0c             	add    0xc(%ebp),%eax
  801ee2:	50                   	push   %eax
  801ee3:	57                   	push   %edi
  801ee4:	e8 91 eb ff ff       	call   800a7a <memmove>
		sys_cputs(buf, m);
  801ee9:	83 c4 08             	add    $0x8,%esp
  801eec:	53                   	push   %ebx
  801eed:	57                   	push   %edi
  801eee:	e8 86 ed ff ff       	call   800c79 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801ef3:	01 de                	add    %ebx,%esi
  801ef5:	83 c4 10             	add    $0x10,%esp
  801ef8:	89 f0                	mov    %esi,%eax
  801efa:	3b 75 10             	cmp    0x10(%ebp),%esi
  801efd:	72 cc                	jb     801ecb <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801eff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f02:	5b                   	pop    %ebx
  801f03:	5e                   	pop    %esi
  801f04:	5f                   	pop    %edi
  801f05:	5d                   	pop    %ebp
  801f06:	c3                   	ret    

00801f07 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
  801f0a:	83 ec 08             	sub    $0x8,%esp
  801f0d:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801f12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f16:	74 2a                	je     801f42 <devcons_read+0x3b>
  801f18:	eb 05                	jmp    801f1f <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801f1a:	e8 ea ed ff ff       	call   800d09 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801f1f:	e8 7b ed ff ff       	call   800c9f <sys_cgetc>
  801f24:	85 c0                	test   %eax,%eax
  801f26:	74 f2                	je     801f1a <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801f28:	85 c0                	test   %eax,%eax
  801f2a:	78 16                	js     801f42 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801f2c:	83 f8 04             	cmp    $0x4,%eax
  801f2f:	74 0c                	je     801f3d <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801f31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f34:	88 02                	mov    %al,(%edx)
	return 1;
  801f36:	b8 01 00 00 00       	mov    $0x1,%eax
  801f3b:	eb 05                	jmp    801f42 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801f3d:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
  801f47:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801f50:	6a 01                	push   $0x1
  801f52:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f55:	50                   	push   %eax
  801f56:	e8 1e ed ff ff       	call   800c79 <sys_cputs>
}
  801f5b:	83 c4 10             	add    $0x10,%esp
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <getchar>:

int
getchar(void)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801f66:	6a 01                	push   $0x1
  801f68:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f6b:	50                   	push   %eax
  801f6c:	6a 00                	push   $0x0
  801f6e:	e8 6d f6 ff ff       	call   8015e0 <read>
	if (r < 0)
  801f73:	83 c4 10             	add    $0x10,%esp
  801f76:	85 c0                	test   %eax,%eax
  801f78:	78 0f                	js     801f89 <getchar+0x29>
		return r;
	if (r < 1)
  801f7a:	85 c0                	test   %eax,%eax
  801f7c:	7e 06                	jle    801f84 <getchar+0x24>
		return -E_EOF;
	return c;
  801f7e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801f82:	eb 05                	jmp    801f89 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801f84:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f91:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f94:	50                   	push   %eax
  801f95:	ff 75 08             	pushl  0x8(%ebp)
  801f98:	e8 de f3 ff ff       	call   80137b <fd_lookup>
  801f9d:	83 c4 10             	add    $0x10,%esp
  801fa0:	85 c0                	test   %eax,%eax
  801fa2:	78 11                	js     801fb5 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa7:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fad:	39 10                	cmp    %edx,(%eax)
  801faf:	0f 94 c0             	sete   %al
  801fb2:	0f b6 c0             	movzbl %al,%eax
}
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <opencons>:

int
opencons(void)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
  801fba:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801fbd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fc0:	50                   	push   %eax
  801fc1:	e8 66 f3 ff ff       	call   80132c <fd_alloc>
  801fc6:	83 c4 10             	add    $0x10,%esp
		return r;
  801fc9:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801fcb:	85 c0                	test   %eax,%eax
  801fcd:	78 3e                	js     80200d <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fcf:	83 ec 04             	sub    $0x4,%esp
  801fd2:	68 07 04 00 00       	push   $0x407
  801fd7:	ff 75 f4             	pushl  -0xc(%ebp)
  801fda:	6a 00                	push   $0x0
  801fdc:	e8 4f ed ff ff       	call   800d30 <sys_page_alloc>
  801fe1:	83 c4 10             	add    $0x10,%esp
		return r;
  801fe4:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fe6:	85 c0                	test   %eax,%eax
  801fe8:	78 23                	js     80200d <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801fea:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff3:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801fff:	83 ec 0c             	sub    $0xc,%esp
  802002:	50                   	push   %eax
  802003:	e8 fc f2 ff ff       	call   801304 <fd2num>
  802008:	89 c2                	mov    %eax,%edx
  80200a:	83 c4 10             	add    $0x10,%esp
}
  80200d:	89 d0                	mov    %edx,%eax
  80200f:	c9                   	leave  
  802010:	c3                   	ret    

00802011 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
  802014:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802017:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80201e:	75 2c                	jne    80204c <set_pgfault_handler+0x3b>
		// First time through!
		// LAB 4: Your code here.
		r = sys_page_alloc(0,(void *)(UXSTACKTOP - PGSIZE),PTE_P | PTE_U | PTE_W);
  802020:	83 ec 04             	sub    $0x4,%esp
  802023:	6a 07                	push   $0x7
  802025:	68 00 f0 bf ee       	push   $0xeebff000
  80202a:	6a 00                	push   $0x0
  80202c:	e8 ff ec ff ff       	call   800d30 <sys_page_alloc>
		if(r < 0)
  802031:	83 c4 10             	add    $0x10,%esp
  802034:	85 c0                	test   %eax,%eax
  802036:	79 14                	jns    80204c <set_pgfault_handler+0x3b>
			panic("set_pgfault_handler: error in sys_page_alloc\n");	
  802038:	83 ec 04             	sub    $0x4,%esp
  80203b:	68 d8 2a 80 00       	push   $0x802ad8
  802040:	6a 22                	push   $0x22
  802042:	68 44 2b 80 00       	push   $0x802b44
  802047:	e8 50 e2 ff ff       	call   80029c <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	a3 00 60 80 00       	mov    %eax,0x806000
	r = sys_env_set_pgfault_upcall(0, _pgfault_upcall); 
  802054:	83 ec 08             	sub    $0x8,%esp
  802057:	68 80 20 80 00       	push   $0x802080
  80205c:	6a 00                	push   $0x0
  80205e:	e8 80 ed ff ff       	call   800de3 <sys_env_set_pgfault_upcall>
	if (r < 0)
  802063:	83 c4 10             	add    $0x10,%esp
  802066:	85 c0                	test   %eax,%eax
  802068:	79 14                	jns    80207e <set_pgfault_handler+0x6d>
		panic("set_pgfault_handler: error in sys_env_set_pgfault_upcall");
  80206a:	83 ec 04             	sub    $0x4,%esp
  80206d:	68 08 2b 80 00       	push   $0x802b08
  802072:	6a 29                	push   $0x29
  802074:	68 44 2b 80 00       	push   $0x802b44
  802079:	e8 1e e2 ff ff       	call   80029c <_panic>
}
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802080:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802081:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802086:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802088:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	subl $0x4, 0x30(%esp)
  80208b:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  802090:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 0x28(%esp), %ebx 	
  802094:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  802098:	89 18                	mov    %ebx,(%eax)
	addl $0x8, %esp
  80209a:	83 c4 08             	add    $0x8,%esp


	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  80209d:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp 
  80209e:	83 c4 04             	add    $0x4,%esp
	popfl
  8020a1:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8020a2:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8020a3:	c3                   	ret    

008020a4 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
  8020a7:	56                   	push   %esi
  8020a8:	53                   	push   %ebx
  8020a9:	8b 75 08             	mov    0x8(%ebp),%esi
  8020ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020af:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  8020b2:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  8020b4:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8020b9:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  8020bc:	83 ec 0c             	sub    $0xc,%esp
  8020bf:	50                   	push   %eax
  8020c0:	e8 66 ed ff ff       	call   800e2b <sys_ipc_recv>
	if (from_env_store)
  8020c5:	83 c4 10             	add    $0x10,%esp
  8020c8:	85 f6                	test   %esi,%esi
  8020ca:	74 0b                	je     8020d7 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  8020cc:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8020d2:	8b 52 74             	mov    0x74(%edx),%edx
  8020d5:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8020d7:	85 db                	test   %ebx,%ebx
  8020d9:	74 0b                	je     8020e6 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  8020db:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8020e1:	8b 52 78             	mov    0x78(%edx),%edx
  8020e4:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  8020e6:	85 c0                	test   %eax,%eax
  8020e8:	79 16                	jns    802100 <ipc_recv+0x5c>
		if (from_env_store)
  8020ea:	85 f6                	test   %esi,%esi
  8020ec:	74 06                	je     8020f4 <ipc_recv+0x50>
			*from_env_store = 0;
  8020ee:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  8020f4:	85 db                	test   %ebx,%ebx
  8020f6:	74 10                	je     802108 <ipc_recv+0x64>
			*perm_store = 0;
  8020f8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8020fe:	eb 08                	jmp    802108 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  802100:	a1 04 40 80 00       	mov    0x804004,%eax
  802105:	8b 40 70             	mov    0x70(%eax),%eax
}
  802108:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80210b:	5b                   	pop    %ebx
  80210c:	5e                   	pop    %esi
  80210d:	5d                   	pop    %ebp
  80210e:	c3                   	ret    

0080210f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	57                   	push   %edi
  802113:	56                   	push   %esi
  802114:	53                   	push   %ebx
  802115:	83 ec 0c             	sub    $0xc,%esp
  802118:	8b 7d 08             	mov    0x8(%ebp),%edi
  80211b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80211e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  802121:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  802123:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802128:	0f 44 d8             	cmove  %eax,%ebx
  80212b:	eb 1c                	jmp    802149 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  80212d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802130:	74 12                	je     802144 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  802132:	50                   	push   %eax
  802133:	68 52 2b 80 00       	push   $0x802b52
  802138:	6a 42                	push   $0x42
  80213a:	68 68 2b 80 00       	push   $0x802b68
  80213f:	e8 58 e1 ff ff       	call   80029c <_panic>
		sys_yield();
  802144:	e8 c0 eb ff ff       	call   800d09 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  802149:	ff 75 14             	pushl  0x14(%ebp)
  80214c:	53                   	push   %ebx
  80214d:	56                   	push   %esi
  80214e:	57                   	push   %edi
  80214f:	e8 b2 ec ff ff       	call   800e06 <sys_ipc_try_send>
  802154:	83 c4 10             	add    $0x10,%esp
  802157:	85 c0                	test   %eax,%eax
  802159:	75 d2                	jne    80212d <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  80215b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80215e:	5b                   	pop    %ebx
  80215f:	5e                   	pop    %esi
  802160:	5f                   	pop    %edi
  802161:	5d                   	pop    %ebp
  802162:	c3                   	ret    

00802163 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
  802166:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802169:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80216e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802171:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802177:	8b 52 50             	mov    0x50(%edx),%edx
  80217a:	39 ca                	cmp    %ecx,%edx
  80217c:	75 0d                	jne    80218b <ipc_find_env+0x28>
			return envs[i].env_id;
  80217e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802181:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802186:	8b 40 48             	mov    0x48(%eax),%eax
  802189:	eb 0f                	jmp    80219a <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80218b:	83 c0 01             	add    $0x1,%eax
  80218e:	3d 00 04 00 00       	cmp    $0x400,%eax
  802193:	75 d9                	jne    80216e <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802195:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80219a:	5d                   	pop    %ebp
  80219b:	c3                   	ret    

0080219c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
  80219f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021a2:	89 d0                	mov    %edx,%eax
  8021a4:	c1 e8 16             	shr    $0x16,%eax
  8021a7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8021ae:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021b3:	f6 c1 01             	test   $0x1,%cl
  8021b6:	74 1d                	je     8021d5 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8021b8:	c1 ea 0c             	shr    $0xc,%edx
  8021bb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8021c2:	f6 c2 01             	test   $0x1,%dl
  8021c5:	74 0e                	je     8021d5 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021c7:	c1 ea 0c             	shr    $0xc,%edx
  8021ca:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8021d1:	ef 
  8021d2:	0f b7 c0             	movzwl %ax,%eax
}
  8021d5:	5d                   	pop    %ebp
  8021d6:	c3                   	ret    
  8021d7:	66 90                	xchg   %ax,%ax
  8021d9:	66 90                	xchg   %ax,%ax
  8021db:	66 90                	xchg   %ax,%ax
  8021dd:	66 90                	xchg   %ax,%ax
  8021df:	90                   	nop

008021e0 <__udivdi3>:
  8021e0:	55                   	push   %ebp
  8021e1:	57                   	push   %edi
  8021e2:	56                   	push   %esi
  8021e3:	53                   	push   %ebx
  8021e4:	83 ec 1c             	sub    $0x1c,%esp
  8021e7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8021eb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8021ef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8021f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021f7:	85 f6                	test   %esi,%esi
  8021f9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021fd:	89 ca                	mov    %ecx,%edx
  8021ff:	89 f8                	mov    %edi,%eax
  802201:	75 3d                	jne    802240 <__udivdi3+0x60>
  802203:	39 cf                	cmp    %ecx,%edi
  802205:	0f 87 c5 00 00 00    	ja     8022d0 <__udivdi3+0xf0>
  80220b:	85 ff                	test   %edi,%edi
  80220d:	89 fd                	mov    %edi,%ebp
  80220f:	75 0b                	jne    80221c <__udivdi3+0x3c>
  802211:	b8 01 00 00 00       	mov    $0x1,%eax
  802216:	31 d2                	xor    %edx,%edx
  802218:	f7 f7                	div    %edi
  80221a:	89 c5                	mov    %eax,%ebp
  80221c:	89 c8                	mov    %ecx,%eax
  80221e:	31 d2                	xor    %edx,%edx
  802220:	f7 f5                	div    %ebp
  802222:	89 c1                	mov    %eax,%ecx
  802224:	89 d8                	mov    %ebx,%eax
  802226:	89 cf                	mov    %ecx,%edi
  802228:	f7 f5                	div    %ebp
  80222a:	89 c3                	mov    %eax,%ebx
  80222c:	89 d8                	mov    %ebx,%eax
  80222e:	89 fa                	mov    %edi,%edx
  802230:	83 c4 1c             	add    $0x1c,%esp
  802233:	5b                   	pop    %ebx
  802234:	5e                   	pop    %esi
  802235:	5f                   	pop    %edi
  802236:	5d                   	pop    %ebp
  802237:	c3                   	ret    
  802238:	90                   	nop
  802239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802240:	39 ce                	cmp    %ecx,%esi
  802242:	77 74                	ja     8022b8 <__udivdi3+0xd8>
  802244:	0f bd fe             	bsr    %esi,%edi
  802247:	83 f7 1f             	xor    $0x1f,%edi
  80224a:	0f 84 98 00 00 00    	je     8022e8 <__udivdi3+0x108>
  802250:	bb 20 00 00 00       	mov    $0x20,%ebx
  802255:	89 f9                	mov    %edi,%ecx
  802257:	89 c5                	mov    %eax,%ebp
  802259:	29 fb                	sub    %edi,%ebx
  80225b:	d3 e6                	shl    %cl,%esi
  80225d:	89 d9                	mov    %ebx,%ecx
  80225f:	d3 ed                	shr    %cl,%ebp
  802261:	89 f9                	mov    %edi,%ecx
  802263:	d3 e0                	shl    %cl,%eax
  802265:	09 ee                	or     %ebp,%esi
  802267:	89 d9                	mov    %ebx,%ecx
  802269:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80226d:	89 d5                	mov    %edx,%ebp
  80226f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802273:	d3 ed                	shr    %cl,%ebp
  802275:	89 f9                	mov    %edi,%ecx
  802277:	d3 e2                	shl    %cl,%edx
  802279:	89 d9                	mov    %ebx,%ecx
  80227b:	d3 e8                	shr    %cl,%eax
  80227d:	09 c2                	or     %eax,%edx
  80227f:	89 d0                	mov    %edx,%eax
  802281:	89 ea                	mov    %ebp,%edx
  802283:	f7 f6                	div    %esi
  802285:	89 d5                	mov    %edx,%ebp
  802287:	89 c3                	mov    %eax,%ebx
  802289:	f7 64 24 0c          	mull   0xc(%esp)
  80228d:	39 d5                	cmp    %edx,%ebp
  80228f:	72 10                	jb     8022a1 <__udivdi3+0xc1>
  802291:	8b 74 24 08          	mov    0x8(%esp),%esi
  802295:	89 f9                	mov    %edi,%ecx
  802297:	d3 e6                	shl    %cl,%esi
  802299:	39 c6                	cmp    %eax,%esi
  80229b:	73 07                	jae    8022a4 <__udivdi3+0xc4>
  80229d:	39 d5                	cmp    %edx,%ebp
  80229f:	75 03                	jne    8022a4 <__udivdi3+0xc4>
  8022a1:	83 eb 01             	sub    $0x1,%ebx
  8022a4:	31 ff                	xor    %edi,%edi
  8022a6:	89 d8                	mov    %ebx,%eax
  8022a8:	89 fa                	mov    %edi,%edx
  8022aa:	83 c4 1c             	add    $0x1c,%esp
  8022ad:	5b                   	pop    %ebx
  8022ae:	5e                   	pop    %esi
  8022af:	5f                   	pop    %edi
  8022b0:	5d                   	pop    %ebp
  8022b1:	c3                   	ret    
  8022b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022b8:	31 ff                	xor    %edi,%edi
  8022ba:	31 db                	xor    %ebx,%ebx
  8022bc:	89 d8                	mov    %ebx,%eax
  8022be:	89 fa                	mov    %edi,%edx
  8022c0:	83 c4 1c             	add    $0x1c,%esp
  8022c3:	5b                   	pop    %ebx
  8022c4:	5e                   	pop    %esi
  8022c5:	5f                   	pop    %edi
  8022c6:	5d                   	pop    %ebp
  8022c7:	c3                   	ret    
  8022c8:	90                   	nop
  8022c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022d0:	89 d8                	mov    %ebx,%eax
  8022d2:	f7 f7                	div    %edi
  8022d4:	31 ff                	xor    %edi,%edi
  8022d6:	89 c3                	mov    %eax,%ebx
  8022d8:	89 d8                	mov    %ebx,%eax
  8022da:	89 fa                	mov    %edi,%edx
  8022dc:	83 c4 1c             	add    $0x1c,%esp
  8022df:	5b                   	pop    %ebx
  8022e0:	5e                   	pop    %esi
  8022e1:	5f                   	pop    %edi
  8022e2:	5d                   	pop    %ebp
  8022e3:	c3                   	ret    
  8022e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022e8:	39 ce                	cmp    %ecx,%esi
  8022ea:	72 0c                	jb     8022f8 <__udivdi3+0x118>
  8022ec:	31 db                	xor    %ebx,%ebx
  8022ee:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8022f2:	0f 87 34 ff ff ff    	ja     80222c <__udivdi3+0x4c>
  8022f8:	bb 01 00 00 00       	mov    $0x1,%ebx
  8022fd:	e9 2a ff ff ff       	jmp    80222c <__udivdi3+0x4c>
  802302:	66 90                	xchg   %ax,%ax
  802304:	66 90                	xchg   %ax,%ax
  802306:	66 90                	xchg   %ax,%ax
  802308:	66 90                	xchg   %ax,%ax
  80230a:	66 90                	xchg   %ax,%ax
  80230c:	66 90                	xchg   %ax,%ax
  80230e:	66 90                	xchg   %ax,%ax

00802310 <__umoddi3>:
  802310:	55                   	push   %ebp
  802311:	57                   	push   %edi
  802312:	56                   	push   %esi
  802313:	53                   	push   %ebx
  802314:	83 ec 1c             	sub    $0x1c,%esp
  802317:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80231b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80231f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802323:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802327:	85 d2                	test   %edx,%edx
  802329:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80232d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802331:	89 f3                	mov    %esi,%ebx
  802333:	89 3c 24             	mov    %edi,(%esp)
  802336:	89 74 24 04          	mov    %esi,0x4(%esp)
  80233a:	75 1c                	jne    802358 <__umoddi3+0x48>
  80233c:	39 f7                	cmp    %esi,%edi
  80233e:	76 50                	jbe    802390 <__umoddi3+0x80>
  802340:	89 c8                	mov    %ecx,%eax
  802342:	89 f2                	mov    %esi,%edx
  802344:	f7 f7                	div    %edi
  802346:	89 d0                	mov    %edx,%eax
  802348:	31 d2                	xor    %edx,%edx
  80234a:	83 c4 1c             	add    $0x1c,%esp
  80234d:	5b                   	pop    %ebx
  80234e:	5e                   	pop    %esi
  80234f:	5f                   	pop    %edi
  802350:	5d                   	pop    %ebp
  802351:	c3                   	ret    
  802352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802358:	39 f2                	cmp    %esi,%edx
  80235a:	89 d0                	mov    %edx,%eax
  80235c:	77 52                	ja     8023b0 <__umoddi3+0xa0>
  80235e:	0f bd ea             	bsr    %edx,%ebp
  802361:	83 f5 1f             	xor    $0x1f,%ebp
  802364:	75 5a                	jne    8023c0 <__umoddi3+0xb0>
  802366:	3b 54 24 04          	cmp    0x4(%esp),%edx
  80236a:	0f 82 e0 00 00 00    	jb     802450 <__umoddi3+0x140>
  802370:	39 0c 24             	cmp    %ecx,(%esp)
  802373:	0f 86 d7 00 00 00    	jbe    802450 <__umoddi3+0x140>
  802379:	8b 44 24 08          	mov    0x8(%esp),%eax
  80237d:	8b 54 24 04          	mov    0x4(%esp),%edx
  802381:	83 c4 1c             	add    $0x1c,%esp
  802384:	5b                   	pop    %ebx
  802385:	5e                   	pop    %esi
  802386:	5f                   	pop    %edi
  802387:	5d                   	pop    %ebp
  802388:	c3                   	ret    
  802389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802390:	85 ff                	test   %edi,%edi
  802392:	89 fd                	mov    %edi,%ebp
  802394:	75 0b                	jne    8023a1 <__umoddi3+0x91>
  802396:	b8 01 00 00 00       	mov    $0x1,%eax
  80239b:	31 d2                	xor    %edx,%edx
  80239d:	f7 f7                	div    %edi
  80239f:	89 c5                	mov    %eax,%ebp
  8023a1:	89 f0                	mov    %esi,%eax
  8023a3:	31 d2                	xor    %edx,%edx
  8023a5:	f7 f5                	div    %ebp
  8023a7:	89 c8                	mov    %ecx,%eax
  8023a9:	f7 f5                	div    %ebp
  8023ab:	89 d0                	mov    %edx,%eax
  8023ad:	eb 99                	jmp    802348 <__umoddi3+0x38>
  8023af:	90                   	nop
  8023b0:	89 c8                	mov    %ecx,%eax
  8023b2:	89 f2                	mov    %esi,%edx
  8023b4:	83 c4 1c             	add    $0x1c,%esp
  8023b7:	5b                   	pop    %ebx
  8023b8:	5e                   	pop    %esi
  8023b9:	5f                   	pop    %edi
  8023ba:	5d                   	pop    %ebp
  8023bb:	c3                   	ret    
  8023bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023c0:	8b 34 24             	mov    (%esp),%esi
  8023c3:	bf 20 00 00 00       	mov    $0x20,%edi
  8023c8:	89 e9                	mov    %ebp,%ecx
  8023ca:	29 ef                	sub    %ebp,%edi
  8023cc:	d3 e0                	shl    %cl,%eax
  8023ce:	89 f9                	mov    %edi,%ecx
  8023d0:	89 f2                	mov    %esi,%edx
  8023d2:	d3 ea                	shr    %cl,%edx
  8023d4:	89 e9                	mov    %ebp,%ecx
  8023d6:	09 c2                	or     %eax,%edx
  8023d8:	89 d8                	mov    %ebx,%eax
  8023da:	89 14 24             	mov    %edx,(%esp)
  8023dd:	89 f2                	mov    %esi,%edx
  8023df:	d3 e2                	shl    %cl,%edx
  8023e1:	89 f9                	mov    %edi,%ecx
  8023e3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023e7:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8023eb:	d3 e8                	shr    %cl,%eax
  8023ed:	89 e9                	mov    %ebp,%ecx
  8023ef:	89 c6                	mov    %eax,%esi
  8023f1:	d3 e3                	shl    %cl,%ebx
  8023f3:	89 f9                	mov    %edi,%ecx
  8023f5:	89 d0                	mov    %edx,%eax
  8023f7:	d3 e8                	shr    %cl,%eax
  8023f9:	89 e9                	mov    %ebp,%ecx
  8023fb:	09 d8                	or     %ebx,%eax
  8023fd:	89 d3                	mov    %edx,%ebx
  8023ff:	89 f2                	mov    %esi,%edx
  802401:	f7 34 24             	divl   (%esp)
  802404:	89 d6                	mov    %edx,%esi
  802406:	d3 e3                	shl    %cl,%ebx
  802408:	f7 64 24 04          	mull   0x4(%esp)
  80240c:	39 d6                	cmp    %edx,%esi
  80240e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802412:	89 d1                	mov    %edx,%ecx
  802414:	89 c3                	mov    %eax,%ebx
  802416:	72 08                	jb     802420 <__umoddi3+0x110>
  802418:	75 11                	jne    80242b <__umoddi3+0x11b>
  80241a:	39 44 24 08          	cmp    %eax,0x8(%esp)
  80241e:	73 0b                	jae    80242b <__umoddi3+0x11b>
  802420:	2b 44 24 04          	sub    0x4(%esp),%eax
  802424:	1b 14 24             	sbb    (%esp),%edx
  802427:	89 d1                	mov    %edx,%ecx
  802429:	89 c3                	mov    %eax,%ebx
  80242b:	8b 54 24 08          	mov    0x8(%esp),%edx
  80242f:	29 da                	sub    %ebx,%edx
  802431:	19 ce                	sbb    %ecx,%esi
  802433:	89 f9                	mov    %edi,%ecx
  802435:	89 f0                	mov    %esi,%eax
  802437:	d3 e0                	shl    %cl,%eax
  802439:	89 e9                	mov    %ebp,%ecx
  80243b:	d3 ea                	shr    %cl,%edx
  80243d:	89 e9                	mov    %ebp,%ecx
  80243f:	d3 ee                	shr    %cl,%esi
  802441:	09 d0                	or     %edx,%eax
  802443:	89 f2                	mov    %esi,%edx
  802445:	83 c4 1c             	add    $0x1c,%esp
  802448:	5b                   	pop    %ebx
  802449:	5e                   	pop    %esi
  80244a:	5f                   	pop    %edi
  80244b:	5d                   	pop    %ebp
  80244c:	c3                   	ret    
  80244d:	8d 76 00             	lea    0x0(%esi),%esi
  802450:	29 f9                	sub    %edi,%ecx
  802452:	19 d6                	sbb    %edx,%esi
  802454:	89 74 24 04          	mov    %esi,0x4(%esp)
  802458:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80245c:	e9 18 ff ff ff       	jmp    802379 <__umoddi3+0x69>
