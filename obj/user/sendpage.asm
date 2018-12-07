
obj/user/sendpage.debug:     formato del fichero elf32-i386


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
  80002c:	e8 74 01 00 00       	call   8001a5 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	envid_t who;

	if ((who = fork()) == 0) {
  800039:	e8 c0 10 00 00       	call   8010fe <fork>
  80003e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800041:	85 c0                	test   %eax,%eax
  800043:	0f 85 a5 00 00 00    	jne    8000ee <umain+0xbb>
		// Child
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	6a 00                	push   $0x0
  80004e:	68 00 00 b0 00       	push   $0xb00000
  800053:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800056:	50                   	push   %eax
  800057:	e8 cf 11 00 00       	call   80122b <ipc_recv>
		cprintf("%x got message from %x: %s\n",
			thisenv->env_id, who, TEMP_ADDR_CHILD);
  80005c:	a1 04 40 80 00       	mov    0x804004,%eax
	envid_t who;

	if ((who = fork()) == 0) {
		// Child
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
		cprintf("%x got message from %x: %s\n",
  800061:	8b 40 48             	mov    0x48(%eax),%eax
  800064:	68 00 00 b0 00       	push   $0xb00000
  800069:	ff 75 f4             	pushl  -0xc(%ebp)
  80006c:	50                   	push   %eax
  80006d:	68 e0 23 80 00       	push   $0x8023e0
  800072:	e8 25 02 00 00       	call   80029c <cprintf>
			thisenv->env_id, who, TEMP_ADDR_CHILD);
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  800077:	83 c4 14             	add    $0x14,%esp
  80007a:	ff 35 04 30 80 00    	pushl  0x803004
  800080:	e8 50 07 00 00       	call   8007d5 <strlen>
  800085:	83 c4 0c             	add    $0xc,%esp
  800088:	50                   	push   %eax
  800089:	ff 35 04 30 80 00    	pushl  0x803004
  80008f:	68 00 00 b0 00       	push   $0xb00000
  800094:	e8 45 08 00 00       	call   8008de <strncmp>
  800099:	83 c4 10             	add    $0x10,%esp
  80009c:	85 c0                	test   %eax,%eax
  80009e:	75 10                	jne    8000b0 <umain+0x7d>
			cprintf("child received correct message\n");
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	68 fc 23 80 00       	push   $0x8023fc
  8000a8:	e8 ef 01 00 00       	call   80029c <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp

		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  8000b0:	83 ec 0c             	sub    $0xc,%esp
  8000b3:	ff 35 00 30 80 00    	pushl  0x803000
  8000b9:	e8 17 07 00 00       	call   8007d5 <strlen>
  8000be:	83 c4 0c             	add    $0xc,%esp
  8000c1:	83 c0 01             	add    $0x1,%eax
  8000c4:	50                   	push   %eax
  8000c5:	ff 35 00 30 80 00    	pushl  0x803000
  8000cb:	68 00 00 b0 00       	push   $0xb00000
  8000d0:	e8 34 09 00 00       	call   800a09 <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  8000d5:	6a 07                	push   $0x7
  8000d7:	68 00 00 b0 00       	push   $0xb00000
  8000dc:	6a 00                	push   $0x0
  8000de:	ff 75 f4             	pushl  -0xc(%ebp)
  8000e1:	e8 b0 11 00 00       	call   801296 <ipc_send>
		return;
  8000e6:	83 c4 20             	add    $0x20,%esp
  8000e9:	e9 b5 00 00 00       	jmp    8001a3 <umain+0x170>
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  8000ee:	a1 04 40 80 00       	mov    0x804004,%eax
  8000f3:	8b 40 48             	mov    0x48(%eax),%eax
  8000f6:	83 ec 04             	sub    $0x4,%esp
  8000f9:	6a 07                	push   $0x7
  8000fb:	68 00 00 a0 00       	push   $0xa00000
  800100:	50                   	push   %eax
  800101:	e8 51 0b 00 00       	call   800c57 <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  800106:	83 c4 04             	add    $0x4,%esp
  800109:	ff 35 04 30 80 00    	pushl  0x803004
  80010f:	e8 c1 06 00 00       	call   8007d5 <strlen>
  800114:	83 c4 0c             	add    $0xc,%esp
  800117:	83 c0 01             	add    $0x1,%eax
  80011a:	50                   	push   %eax
  80011b:	ff 35 04 30 80 00    	pushl  0x803004
  800121:	68 00 00 a0 00       	push   $0xa00000
  800126:	e8 de 08 00 00       	call   800a09 <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  80012b:	6a 07                	push   $0x7
  80012d:	68 00 00 a0 00       	push   $0xa00000
  800132:	6a 00                	push   $0x0
  800134:	ff 75 f4             	pushl  -0xc(%ebp)
  800137:	e8 5a 11 00 00       	call   801296 <ipc_send>

	ipc_recv(&who, TEMP_ADDR, 0);
  80013c:	83 c4 1c             	add    $0x1c,%esp
  80013f:	6a 00                	push   $0x0
  800141:	68 00 00 a0 00       	push   $0xa00000
  800146:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800149:	50                   	push   %eax
  80014a:	e8 dc 10 00 00       	call   80122b <ipc_recv>
	cprintf("%x got message from %x: %s\n",
		thisenv->env_id, who, TEMP_ADDR);
  80014f:	a1 04 40 80 00       	mov    0x804004,%eax
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);

	ipc_recv(&who, TEMP_ADDR, 0);
	cprintf("%x got message from %x: %s\n",
  800154:	8b 40 48             	mov    0x48(%eax),%eax
  800157:	68 00 00 a0 00       	push   $0xa00000
  80015c:	ff 75 f4             	pushl  -0xc(%ebp)
  80015f:	50                   	push   %eax
  800160:	68 e0 23 80 00       	push   $0x8023e0
  800165:	e8 32 01 00 00       	call   80029c <cprintf>
		thisenv->env_id, who, TEMP_ADDR);
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  80016a:	83 c4 14             	add    $0x14,%esp
  80016d:	ff 35 00 30 80 00    	pushl  0x803000
  800173:	e8 5d 06 00 00       	call   8007d5 <strlen>
  800178:	83 c4 0c             	add    $0xc,%esp
  80017b:	50                   	push   %eax
  80017c:	ff 35 00 30 80 00    	pushl  0x803000
  800182:	68 00 00 a0 00       	push   $0xa00000
  800187:	e8 52 07 00 00       	call   8008de <strncmp>
  80018c:	83 c4 10             	add    $0x10,%esp
  80018f:	85 c0                	test   %eax,%eax
  800191:	75 10                	jne    8001a3 <umain+0x170>
		cprintf("parent received correct message\n");
  800193:	83 ec 0c             	sub    $0xc,%esp
  800196:	68 1c 24 80 00       	push   $0x80241c
  80019b:	e8 fc 00 00 00       	call   80029c <cprintf>
  8001a0:	83 c4 10             	add    $0x10,%esp
	return;
}
  8001a3:	c9                   	leave  
  8001a4:	c3                   	ret    

008001a5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001a5:	55                   	push   %ebp
  8001a6:	89 e5                	mov    %esp,%ebp
  8001a8:	56                   	push   %esi
  8001a9:	53                   	push   %ebx
  8001aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001ad:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8001b0:	e8 57 0a 00 00       	call   800c0c <sys_getenvid>
	if (id >= 0)
  8001b5:	85 c0                	test   %eax,%eax
  8001b7:	78 12                	js     8001cb <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  8001b9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001be:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001c1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001c6:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001cb:	85 db                	test   %ebx,%ebx
  8001cd:	7e 07                	jle    8001d6 <libmain+0x31>
		binaryname = argv[0];
  8001cf:	8b 06                	mov    (%esi),%eax
  8001d1:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	umain(argc, argv);
  8001d6:	83 ec 08             	sub    $0x8,%esp
  8001d9:	56                   	push   %esi
  8001da:	53                   	push   %ebx
  8001db:	e8 53 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8001e0:	e8 0a 00 00 00       	call   8001ef <exit>
}
  8001e5:	83 c4 10             	add    $0x10,%esp
  8001e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001eb:	5b                   	pop    %ebx
  8001ec:	5e                   	pop    %esi
  8001ed:	5d                   	pop    %ebp
  8001ee:	c3                   	ret    

008001ef <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ef:	55                   	push   %ebp
  8001f0:	89 e5                	mov    %esp,%ebp
  8001f2:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001f5:	e8 f4 12 00 00       	call   8014ee <close_all>
	sys_env_destroy(0);
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	6a 00                	push   $0x0
  8001ff:	e8 e6 09 00 00       	call   800bea <sys_env_destroy>
}
  800204:	83 c4 10             	add    $0x10,%esp
  800207:	c9                   	leave  
  800208:	c3                   	ret    

00800209 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800209:	55                   	push   %ebp
  80020a:	89 e5                	mov    %esp,%ebp
  80020c:	53                   	push   %ebx
  80020d:	83 ec 04             	sub    $0x4,%esp
  800210:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800213:	8b 13                	mov    (%ebx),%edx
  800215:	8d 42 01             	lea    0x1(%edx),%eax
  800218:	89 03                	mov    %eax,(%ebx)
  80021a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80021d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800221:	3d ff 00 00 00       	cmp    $0xff,%eax
  800226:	75 1a                	jne    800242 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  800228:	83 ec 08             	sub    $0x8,%esp
  80022b:	68 ff 00 00 00       	push   $0xff
  800230:	8d 43 08             	lea    0x8(%ebx),%eax
  800233:	50                   	push   %eax
  800234:	e8 67 09 00 00       	call   800ba0 <sys_cputs>
		b->idx = 0;
  800239:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80023f:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  800242:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800246:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800249:	c9                   	leave  
  80024a:	c3                   	ret    

0080024b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80024b:	55                   	push   %ebp
  80024c:	89 e5                	mov    %esp,%ebp
  80024e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800254:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80025b:	00 00 00 
	b.cnt = 0;
  80025e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800265:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800268:	ff 75 0c             	pushl  0xc(%ebp)
  80026b:	ff 75 08             	pushl  0x8(%ebp)
  80026e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800274:	50                   	push   %eax
  800275:	68 09 02 80 00       	push   $0x800209
  80027a:	e8 86 01 00 00       	call   800405 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80027f:	83 c4 08             	add    $0x8,%esp
  800282:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800288:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80028e:	50                   	push   %eax
  80028f:	e8 0c 09 00 00       	call   800ba0 <sys_cputs>

	return b.cnt;
}
  800294:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80029a:	c9                   	leave  
  80029b:	c3                   	ret    

0080029c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80029c:	55                   	push   %ebp
  80029d:	89 e5                	mov    %esp,%ebp
  80029f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002a2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002a5:	50                   	push   %eax
  8002a6:	ff 75 08             	pushl  0x8(%ebp)
  8002a9:	e8 9d ff ff ff       	call   80024b <vcprintf>
	va_end(ap);

	return cnt;
}
  8002ae:	c9                   	leave  
  8002af:	c3                   	ret    

008002b0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	57                   	push   %edi
  8002b4:	56                   	push   %esi
  8002b5:	53                   	push   %ebx
  8002b6:	83 ec 1c             	sub    $0x1c,%esp
  8002b9:	89 c7                	mov    %eax,%edi
  8002bb:	89 d6                	mov    %edx,%esi
  8002bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002c6:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002d1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002d4:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002d7:	39 d3                	cmp    %edx,%ebx
  8002d9:	72 05                	jb     8002e0 <printnum+0x30>
  8002db:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002de:	77 45                	ja     800325 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	ff 75 18             	pushl  0x18(%ebp)
  8002e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002ec:	53                   	push   %ebx
  8002ed:	ff 75 10             	pushl  0x10(%ebp)
  8002f0:	83 ec 08             	sub    $0x8,%esp
  8002f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f6:	ff 75 e0             	pushl  -0x20(%ebp)
  8002f9:	ff 75 dc             	pushl  -0x24(%ebp)
  8002fc:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ff:	e8 4c 1e 00 00       	call   802150 <__udivdi3>
  800304:	83 c4 18             	add    $0x18,%esp
  800307:	52                   	push   %edx
  800308:	50                   	push   %eax
  800309:	89 f2                	mov    %esi,%edx
  80030b:	89 f8                	mov    %edi,%eax
  80030d:	e8 9e ff ff ff       	call   8002b0 <printnum>
  800312:	83 c4 20             	add    $0x20,%esp
  800315:	eb 18                	jmp    80032f <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800317:	83 ec 08             	sub    $0x8,%esp
  80031a:	56                   	push   %esi
  80031b:	ff 75 18             	pushl  0x18(%ebp)
  80031e:	ff d7                	call   *%edi
  800320:	83 c4 10             	add    $0x10,%esp
  800323:	eb 03                	jmp    800328 <printnum+0x78>
  800325:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800328:	83 eb 01             	sub    $0x1,%ebx
  80032b:	85 db                	test   %ebx,%ebx
  80032d:	7f e8                	jg     800317 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80032f:	83 ec 08             	sub    $0x8,%esp
  800332:	56                   	push   %esi
  800333:	83 ec 04             	sub    $0x4,%esp
  800336:	ff 75 e4             	pushl  -0x1c(%ebp)
  800339:	ff 75 e0             	pushl  -0x20(%ebp)
  80033c:	ff 75 dc             	pushl  -0x24(%ebp)
  80033f:	ff 75 d8             	pushl  -0x28(%ebp)
  800342:	e8 39 1f 00 00       	call   802280 <__umoddi3>
  800347:	83 c4 14             	add    $0x14,%esp
  80034a:	0f be 80 94 24 80 00 	movsbl 0x802494(%eax),%eax
  800351:	50                   	push   %eax
  800352:	ff d7                	call   *%edi
}
  800354:	83 c4 10             	add    $0x10,%esp
  800357:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80035a:	5b                   	pop    %ebx
  80035b:	5e                   	pop    %esi
  80035c:	5f                   	pop    %edi
  80035d:	5d                   	pop    %ebp
  80035e:	c3                   	ret    

0080035f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80035f:	55                   	push   %ebp
  800360:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800362:	83 fa 01             	cmp    $0x1,%edx
  800365:	7e 0e                	jle    800375 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800367:	8b 10                	mov    (%eax),%edx
  800369:	8d 4a 08             	lea    0x8(%edx),%ecx
  80036c:	89 08                	mov    %ecx,(%eax)
  80036e:	8b 02                	mov    (%edx),%eax
  800370:	8b 52 04             	mov    0x4(%edx),%edx
  800373:	eb 22                	jmp    800397 <getuint+0x38>
	else if (lflag)
  800375:	85 d2                	test   %edx,%edx
  800377:	74 10                	je     800389 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800379:	8b 10                	mov    (%eax),%edx
  80037b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80037e:	89 08                	mov    %ecx,(%eax)
  800380:	8b 02                	mov    (%edx),%eax
  800382:	ba 00 00 00 00       	mov    $0x0,%edx
  800387:	eb 0e                	jmp    800397 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800389:	8b 10                	mov    (%eax),%edx
  80038b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80038e:	89 08                	mov    %ecx,(%eax)
  800390:	8b 02                	mov    (%edx),%eax
  800392:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800397:	5d                   	pop    %ebp
  800398:	c3                   	ret    

00800399 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800399:	55                   	push   %ebp
  80039a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80039c:	83 fa 01             	cmp    $0x1,%edx
  80039f:	7e 0e                	jle    8003af <getint+0x16>
		return va_arg(*ap, long long);
  8003a1:	8b 10                	mov    (%eax),%edx
  8003a3:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003a6:	89 08                	mov    %ecx,(%eax)
  8003a8:	8b 02                	mov    (%edx),%eax
  8003aa:	8b 52 04             	mov    0x4(%edx),%edx
  8003ad:	eb 1a                	jmp    8003c9 <getint+0x30>
	else if (lflag)
  8003af:	85 d2                	test   %edx,%edx
  8003b1:	74 0c                	je     8003bf <getint+0x26>
		return va_arg(*ap, long);
  8003b3:	8b 10                	mov    (%eax),%edx
  8003b5:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003b8:	89 08                	mov    %ecx,(%eax)
  8003ba:	8b 02                	mov    (%edx),%eax
  8003bc:	99                   	cltd   
  8003bd:	eb 0a                	jmp    8003c9 <getint+0x30>
	else
		return va_arg(*ap, int);
  8003bf:	8b 10                	mov    (%eax),%edx
  8003c1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003c4:	89 08                	mov    %ecx,(%eax)
  8003c6:	8b 02                	mov    (%edx),%eax
  8003c8:	99                   	cltd   
}
  8003c9:	5d                   	pop    %ebp
  8003ca:	c3                   	ret    

008003cb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003cb:	55                   	push   %ebp
  8003cc:	89 e5                	mov    %esp,%ebp
  8003ce:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003d1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003d5:	8b 10                	mov    (%eax),%edx
  8003d7:	3b 50 04             	cmp    0x4(%eax),%edx
  8003da:	73 0a                	jae    8003e6 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003dc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003df:	89 08                	mov    %ecx,(%eax)
  8003e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e4:	88 02                	mov    %al,(%edx)
}
  8003e6:	5d                   	pop    %ebp
  8003e7:	c3                   	ret    

008003e8 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003e8:	55                   	push   %ebp
  8003e9:	89 e5                	mov    %esp,%ebp
  8003eb:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8003ee:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003f1:	50                   	push   %eax
  8003f2:	ff 75 10             	pushl  0x10(%ebp)
  8003f5:	ff 75 0c             	pushl  0xc(%ebp)
  8003f8:	ff 75 08             	pushl  0x8(%ebp)
  8003fb:	e8 05 00 00 00       	call   800405 <vprintfmt>
	va_end(ap);
}
  800400:	83 c4 10             	add    $0x10,%esp
  800403:	c9                   	leave  
  800404:	c3                   	ret    

00800405 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800405:	55                   	push   %ebp
  800406:	89 e5                	mov    %esp,%ebp
  800408:	57                   	push   %edi
  800409:	56                   	push   %esi
  80040a:	53                   	push   %ebx
  80040b:	83 ec 2c             	sub    $0x2c,%esp
  80040e:	8b 75 08             	mov    0x8(%ebp),%esi
  800411:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800414:	8b 7d 10             	mov    0x10(%ebp),%edi
  800417:	eb 12                	jmp    80042b <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800419:	85 c0                	test   %eax,%eax
  80041b:	0f 84 44 03 00 00    	je     800765 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  800421:	83 ec 08             	sub    $0x8,%esp
  800424:	53                   	push   %ebx
  800425:	50                   	push   %eax
  800426:	ff d6                	call   *%esi
  800428:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80042b:	83 c7 01             	add    $0x1,%edi
  80042e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800432:	83 f8 25             	cmp    $0x25,%eax
  800435:	75 e2                	jne    800419 <vprintfmt+0x14>
  800437:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  80043b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800442:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800449:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800450:	ba 00 00 00 00       	mov    $0x0,%edx
  800455:	eb 07                	jmp    80045e <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800457:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  80045a:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80045e:	8d 47 01             	lea    0x1(%edi),%eax
  800461:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800464:	0f b6 07             	movzbl (%edi),%eax
  800467:	0f b6 c8             	movzbl %al,%ecx
  80046a:	83 e8 23             	sub    $0x23,%eax
  80046d:	3c 55                	cmp    $0x55,%al
  80046f:	0f 87 d5 02 00 00    	ja     80074a <vprintfmt+0x345>
  800475:	0f b6 c0             	movzbl %al,%eax
  800478:	ff 24 85 e0 25 80 00 	jmp    *0x8025e0(,%eax,4)
  80047f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800482:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800486:	eb d6                	jmp    80045e <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800488:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80048b:	b8 00 00 00 00       	mov    $0x0,%eax
  800490:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800493:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800496:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  80049a:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  80049d:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8004a0:	83 fa 09             	cmp    $0x9,%edx
  8004a3:	77 39                	ja     8004de <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004a5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004a8:	eb e9                	jmp    800493 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ad:	8d 48 04             	lea    0x4(%eax),%ecx
  8004b0:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8004b3:	8b 00                	mov    (%eax),%eax
  8004b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004bb:	eb 27                	jmp    8004e4 <vprintfmt+0xdf>
  8004bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c0:	85 c0                	test   %eax,%eax
  8004c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004c7:	0f 49 c8             	cmovns %eax,%ecx
  8004ca:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004d0:	eb 8c                	jmp    80045e <vprintfmt+0x59>
  8004d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004d5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004dc:	eb 80                	jmp    80045e <vprintfmt+0x59>
  8004de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8004e1:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  8004e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004e8:	0f 89 70 ff ff ff    	jns    80045e <vprintfmt+0x59>
				width = precision, precision = -1;
  8004ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f4:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004fb:	e9 5e ff ff ff       	jmp    80045e <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800500:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800503:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800506:	e9 53 ff ff ff       	jmp    80045e <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80050b:	8b 45 14             	mov    0x14(%ebp),%eax
  80050e:	8d 50 04             	lea    0x4(%eax),%edx
  800511:	89 55 14             	mov    %edx,0x14(%ebp)
  800514:	83 ec 08             	sub    $0x8,%esp
  800517:	53                   	push   %ebx
  800518:	ff 30                	pushl  (%eax)
  80051a:	ff d6                	call   *%esi
			break;
  80051c:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80051f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800522:	e9 04 ff ff ff       	jmp    80042b <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800527:	8b 45 14             	mov    0x14(%ebp),%eax
  80052a:	8d 50 04             	lea    0x4(%eax),%edx
  80052d:	89 55 14             	mov    %edx,0x14(%ebp)
  800530:	8b 00                	mov    (%eax),%eax
  800532:	99                   	cltd   
  800533:	31 d0                	xor    %edx,%eax
  800535:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800537:	83 f8 0f             	cmp    $0xf,%eax
  80053a:	7f 0b                	jg     800547 <vprintfmt+0x142>
  80053c:	8b 14 85 40 27 80 00 	mov    0x802740(,%eax,4),%edx
  800543:	85 d2                	test   %edx,%edx
  800545:	75 18                	jne    80055f <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  800547:	50                   	push   %eax
  800548:	68 ac 24 80 00       	push   $0x8024ac
  80054d:	53                   	push   %ebx
  80054e:	56                   	push   %esi
  80054f:	e8 94 fe ff ff       	call   8003e8 <printfmt>
  800554:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800557:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80055a:	e9 cc fe ff ff       	jmp    80042b <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  80055f:	52                   	push   %edx
  800560:	68 f5 29 80 00       	push   $0x8029f5
  800565:	53                   	push   %ebx
  800566:	56                   	push   %esi
  800567:	e8 7c fe ff ff       	call   8003e8 <printfmt>
  80056c:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80056f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800572:	e9 b4 fe ff ff       	jmp    80042b <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800577:	8b 45 14             	mov    0x14(%ebp),%eax
  80057a:	8d 50 04             	lea    0x4(%eax),%edx
  80057d:	89 55 14             	mov    %edx,0x14(%ebp)
  800580:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800582:	85 ff                	test   %edi,%edi
  800584:	b8 a5 24 80 00       	mov    $0x8024a5,%eax
  800589:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80058c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800590:	0f 8e 94 00 00 00    	jle    80062a <vprintfmt+0x225>
  800596:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80059a:	0f 84 98 00 00 00    	je     800638 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a0:	83 ec 08             	sub    $0x8,%esp
  8005a3:	ff 75 d0             	pushl  -0x30(%ebp)
  8005a6:	57                   	push   %edi
  8005a7:	e8 41 02 00 00       	call   8007ed <strnlen>
  8005ac:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005af:	29 c1                	sub    %eax,%ecx
  8005b1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8005b4:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005b7:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005be:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005c1:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c3:	eb 0f                	jmp    8005d4 <vprintfmt+0x1cf>
					putch(padc, putdat);
  8005c5:	83 ec 08             	sub    $0x8,%esp
  8005c8:	53                   	push   %ebx
  8005c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8005cc:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ce:	83 ef 01             	sub    $0x1,%edi
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	85 ff                	test   %edi,%edi
  8005d6:	7f ed                	jg     8005c5 <vprintfmt+0x1c0>
  8005d8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005db:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8005de:	85 c9                	test   %ecx,%ecx
  8005e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e5:	0f 49 c1             	cmovns %ecx,%eax
  8005e8:	29 c1                	sub    %eax,%ecx
  8005ea:	89 75 08             	mov    %esi,0x8(%ebp)
  8005ed:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005f0:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005f3:	89 cb                	mov    %ecx,%ebx
  8005f5:	eb 4d                	jmp    800644 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005f7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005fb:	74 1b                	je     800618 <vprintfmt+0x213>
  8005fd:	0f be c0             	movsbl %al,%eax
  800600:	83 e8 20             	sub    $0x20,%eax
  800603:	83 f8 5e             	cmp    $0x5e,%eax
  800606:	76 10                	jbe    800618 <vprintfmt+0x213>
					putch('?', putdat);
  800608:	83 ec 08             	sub    $0x8,%esp
  80060b:	ff 75 0c             	pushl  0xc(%ebp)
  80060e:	6a 3f                	push   $0x3f
  800610:	ff 55 08             	call   *0x8(%ebp)
  800613:	83 c4 10             	add    $0x10,%esp
  800616:	eb 0d                	jmp    800625 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  800618:	83 ec 08             	sub    $0x8,%esp
  80061b:	ff 75 0c             	pushl  0xc(%ebp)
  80061e:	52                   	push   %edx
  80061f:	ff 55 08             	call   *0x8(%ebp)
  800622:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800625:	83 eb 01             	sub    $0x1,%ebx
  800628:	eb 1a                	jmp    800644 <vprintfmt+0x23f>
  80062a:	89 75 08             	mov    %esi,0x8(%ebp)
  80062d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800630:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800633:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800636:	eb 0c                	jmp    800644 <vprintfmt+0x23f>
  800638:	89 75 08             	mov    %esi,0x8(%ebp)
  80063b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80063e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800641:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800644:	83 c7 01             	add    $0x1,%edi
  800647:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80064b:	0f be d0             	movsbl %al,%edx
  80064e:	85 d2                	test   %edx,%edx
  800650:	74 23                	je     800675 <vprintfmt+0x270>
  800652:	85 f6                	test   %esi,%esi
  800654:	78 a1                	js     8005f7 <vprintfmt+0x1f2>
  800656:	83 ee 01             	sub    $0x1,%esi
  800659:	79 9c                	jns    8005f7 <vprintfmt+0x1f2>
  80065b:	89 df                	mov    %ebx,%edi
  80065d:	8b 75 08             	mov    0x8(%ebp),%esi
  800660:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800663:	eb 18                	jmp    80067d <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800665:	83 ec 08             	sub    $0x8,%esp
  800668:	53                   	push   %ebx
  800669:	6a 20                	push   $0x20
  80066b:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80066d:	83 ef 01             	sub    $0x1,%edi
  800670:	83 c4 10             	add    $0x10,%esp
  800673:	eb 08                	jmp    80067d <vprintfmt+0x278>
  800675:	89 df                	mov    %ebx,%edi
  800677:	8b 75 08             	mov    0x8(%ebp),%esi
  80067a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80067d:	85 ff                	test   %edi,%edi
  80067f:	7f e4                	jg     800665 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800681:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800684:	e9 a2 fd ff ff       	jmp    80042b <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800689:	8d 45 14             	lea    0x14(%ebp),%eax
  80068c:	e8 08 fd ff ff       	call   800399 <getint>
  800691:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800694:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800697:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  80069c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006a0:	79 74                	jns    800716 <vprintfmt+0x311>
				putch('-', putdat);
  8006a2:	83 ec 08             	sub    $0x8,%esp
  8006a5:	53                   	push   %ebx
  8006a6:	6a 2d                	push   $0x2d
  8006a8:	ff d6                	call   *%esi
				num = -(long long) num;
  8006aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006ad:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006b0:	f7 d8                	neg    %eax
  8006b2:	83 d2 00             	adc    $0x0,%edx
  8006b5:	f7 da                	neg    %edx
  8006b7:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8006ba:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006bf:	eb 55                	jmp    800716 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006c1:	8d 45 14             	lea    0x14(%ebp),%eax
  8006c4:	e8 96 fc ff ff       	call   80035f <getuint>
			base = 10;
  8006c9:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006ce:	eb 46                	jmp    800716 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8006d0:	8d 45 14             	lea    0x14(%ebp),%eax
  8006d3:	e8 87 fc ff ff       	call   80035f <getuint>
			base = 8;
  8006d8:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8006dd:	eb 37                	jmp    800716 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  8006df:	83 ec 08             	sub    $0x8,%esp
  8006e2:	53                   	push   %ebx
  8006e3:	6a 30                	push   $0x30
  8006e5:	ff d6                	call   *%esi
			putch('x', putdat);
  8006e7:	83 c4 08             	add    $0x8,%esp
  8006ea:	53                   	push   %ebx
  8006eb:	6a 78                	push   $0x78
  8006ed:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8d 50 04             	lea    0x4(%eax),%edx
  8006f5:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8006ff:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800702:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800707:	eb 0d                	jmp    800716 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800709:	8d 45 14             	lea    0x14(%ebp),%eax
  80070c:	e8 4e fc ff ff       	call   80035f <getuint>
			base = 16;
  800711:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800716:	83 ec 0c             	sub    $0xc,%esp
  800719:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80071d:	57                   	push   %edi
  80071e:	ff 75 e0             	pushl  -0x20(%ebp)
  800721:	51                   	push   %ecx
  800722:	52                   	push   %edx
  800723:	50                   	push   %eax
  800724:	89 da                	mov    %ebx,%edx
  800726:	89 f0                	mov    %esi,%eax
  800728:	e8 83 fb ff ff       	call   8002b0 <printnum>
			break;
  80072d:	83 c4 20             	add    $0x20,%esp
  800730:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800733:	e9 f3 fc ff ff       	jmp    80042b <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800738:	83 ec 08             	sub    $0x8,%esp
  80073b:	53                   	push   %ebx
  80073c:	51                   	push   %ecx
  80073d:	ff d6                	call   *%esi
			break;
  80073f:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800742:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800745:	e9 e1 fc ff ff       	jmp    80042b <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	53                   	push   %ebx
  80074e:	6a 25                	push   $0x25
  800750:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	eb 03                	jmp    80075a <vprintfmt+0x355>
  800757:	83 ef 01             	sub    $0x1,%edi
  80075a:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  80075e:	75 f7                	jne    800757 <vprintfmt+0x352>
  800760:	e9 c6 fc ff ff       	jmp    80042b <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  800765:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800768:	5b                   	pop    %ebx
  800769:	5e                   	pop    %esi
  80076a:	5f                   	pop    %edi
  80076b:	5d                   	pop    %ebp
  80076c:	c3                   	ret    

0080076d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 18             	sub    $0x18,%esp
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800779:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80077c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800780:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800783:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80078a:	85 c0                	test   %eax,%eax
  80078c:	74 26                	je     8007b4 <vsnprintf+0x47>
  80078e:	85 d2                	test   %edx,%edx
  800790:	7e 22                	jle    8007b4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800792:	ff 75 14             	pushl  0x14(%ebp)
  800795:	ff 75 10             	pushl  0x10(%ebp)
  800798:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80079b:	50                   	push   %eax
  80079c:	68 cb 03 80 00       	push   $0x8003cb
  8007a1:	e8 5f fc ff ff       	call   800405 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007af:	83 c4 10             	add    $0x10,%esp
  8007b2:	eb 05                	jmp    8007b9 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    

008007bb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
  8007be:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007c1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007c4:	50                   	push   %eax
  8007c5:	ff 75 10             	pushl  0x10(%ebp)
  8007c8:	ff 75 0c             	pushl  0xc(%ebp)
  8007cb:	ff 75 08             	pushl  0x8(%ebp)
  8007ce:	e8 9a ff ff ff       	call   80076d <vsnprintf>
	va_end(ap);

	return rc;
}
  8007d3:	c9                   	leave  
  8007d4:	c3                   	ret    

008007d5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007d5:	55                   	push   %ebp
  8007d6:	89 e5                	mov    %esp,%ebp
  8007d8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007db:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e0:	eb 03                	jmp    8007e5 <strlen+0x10>
		n++;
  8007e2:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007e5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007e9:	75 f7                	jne    8007e2 <strlen+0xd>
		n++;
	return n;
}
  8007eb:	5d                   	pop    %ebp
  8007ec:	c3                   	ret    

008007ed <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007ed:	55                   	push   %ebp
  8007ee:	89 e5                	mov    %esp,%ebp
  8007f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f3:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8007fb:	eb 03                	jmp    800800 <strnlen+0x13>
		n++;
  8007fd:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800800:	39 c2                	cmp    %eax,%edx
  800802:	74 08                	je     80080c <strnlen+0x1f>
  800804:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800808:	75 f3                	jne    8007fd <strnlen+0x10>
  80080a:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  80080c:	5d                   	pop    %ebp
  80080d:	c3                   	ret    

0080080e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80080e:	55                   	push   %ebp
  80080f:	89 e5                	mov    %esp,%ebp
  800811:	53                   	push   %ebx
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800818:	89 c2                	mov    %eax,%edx
  80081a:	83 c2 01             	add    $0x1,%edx
  80081d:	83 c1 01             	add    $0x1,%ecx
  800820:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800824:	88 5a ff             	mov    %bl,-0x1(%edx)
  800827:	84 db                	test   %bl,%bl
  800829:	75 ef                	jne    80081a <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80082b:	5b                   	pop    %ebx
  80082c:	5d                   	pop    %ebp
  80082d:	c3                   	ret    

0080082e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	53                   	push   %ebx
  800832:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800835:	53                   	push   %ebx
  800836:	e8 9a ff ff ff       	call   8007d5 <strlen>
  80083b:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80083e:	ff 75 0c             	pushl  0xc(%ebp)
  800841:	01 d8                	add    %ebx,%eax
  800843:	50                   	push   %eax
  800844:	e8 c5 ff ff ff       	call   80080e <strcpy>
	return dst;
}
  800849:	89 d8                	mov    %ebx,%eax
  80084b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80084e:	c9                   	leave  
  80084f:	c3                   	ret    

00800850 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800850:	55                   	push   %ebp
  800851:	89 e5                	mov    %esp,%ebp
  800853:	56                   	push   %esi
  800854:	53                   	push   %ebx
  800855:	8b 75 08             	mov    0x8(%ebp),%esi
  800858:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80085b:	89 f3                	mov    %esi,%ebx
  80085d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800860:	89 f2                	mov    %esi,%edx
  800862:	eb 0f                	jmp    800873 <strncpy+0x23>
		*dst++ = *src;
  800864:	83 c2 01             	add    $0x1,%edx
  800867:	0f b6 01             	movzbl (%ecx),%eax
  80086a:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80086d:	80 39 01             	cmpb   $0x1,(%ecx)
  800870:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800873:	39 da                	cmp    %ebx,%edx
  800875:	75 ed                	jne    800864 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800877:	89 f0                	mov    %esi,%eax
  800879:	5b                   	pop    %ebx
  80087a:	5e                   	pop    %esi
  80087b:	5d                   	pop    %ebp
  80087c:	c3                   	ret    

0080087d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80087d:	55                   	push   %ebp
  80087e:	89 e5                	mov    %esp,%ebp
  800880:	56                   	push   %esi
  800881:	53                   	push   %ebx
  800882:	8b 75 08             	mov    0x8(%ebp),%esi
  800885:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800888:	8b 55 10             	mov    0x10(%ebp),%edx
  80088b:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80088d:	85 d2                	test   %edx,%edx
  80088f:	74 21                	je     8008b2 <strlcpy+0x35>
  800891:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800895:	89 f2                	mov    %esi,%edx
  800897:	eb 09                	jmp    8008a2 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800899:	83 c2 01             	add    $0x1,%edx
  80089c:	83 c1 01             	add    $0x1,%ecx
  80089f:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008a2:	39 c2                	cmp    %eax,%edx
  8008a4:	74 09                	je     8008af <strlcpy+0x32>
  8008a6:	0f b6 19             	movzbl (%ecx),%ebx
  8008a9:	84 db                	test   %bl,%bl
  8008ab:	75 ec                	jne    800899 <strlcpy+0x1c>
  8008ad:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  8008af:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008b2:	29 f0                	sub    %esi,%eax
}
  8008b4:	5b                   	pop    %ebx
  8008b5:	5e                   	pop    %esi
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008be:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008c1:	eb 06                	jmp    8008c9 <strcmp+0x11>
		p++, q++;
  8008c3:	83 c1 01             	add    $0x1,%ecx
  8008c6:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008c9:	0f b6 01             	movzbl (%ecx),%eax
  8008cc:	84 c0                	test   %al,%al
  8008ce:	74 04                	je     8008d4 <strcmp+0x1c>
  8008d0:	3a 02                	cmp    (%edx),%al
  8008d2:	74 ef                	je     8008c3 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008d4:	0f b6 c0             	movzbl %al,%eax
  8008d7:	0f b6 12             	movzbl (%edx),%edx
  8008da:	29 d0                	sub    %edx,%eax
}
  8008dc:	5d                   	pop    %ebp
  8008dd:	c3                   	ret    

008008de <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008de:	55                   	push   %ebp
  8008df:	89 e5                	mov    %esp,%ebp
  8008e1:	53                   	push   %ebx
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e8:	89 c3                	mov    %eax,%ebx
  8008ea:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008ed:	eb 06                	jmp    8008f5 <strncmp+0x17>
		n--, p++, q++;
  8008ef:	83 c0 01             	add    $0x1,%eax
  8008f2:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008f5:	39 d8                	cmp    %ebx,%eax
  8008f7:	74 15                	je     80090e <strncmp+0x30>
  8008f9:	0f b6 08             	movzbl (%eax),%ecx
  8008fc:	84 c9                	test   %cl,%cl
  8008fe:	74 04                	je     800904 <strncmp+0x26>
  800900:	3a 0a                	cmp    (%edx),%cl
  800902:	74 eb                	je     8008ef <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800904:	0f b6 00             	movzbl (%eax),%eax
  800907:	0f b6 12             	movzbl (%edx),%edx
  80090a:	29 d0                	sub    %edx,%eax
  80090c:	eb 05                	jmp    800913 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  80090e:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800913:	5b                   	pop    %ebx
  800914:	5d                   	pop    %ebp
  800915:	c3                   	ret    

00800916 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800920:	eb 07                	jmp    800929 <strchr+0x13>
		if (*s == c)
  800922:	38 ca                	cmp    %cl,%dl
  800924:	74 0f                	je     800935 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800926:	83 c0 01             	add    $0x1,%eax
  800929:	0f b6 10             	movzbl (%eax),%edx
  80092c:	84 d2                	test   %dl,%dl
  80092e:	75 f2                	jne    800922 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800930:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    

00800937 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800941:	eb 03                	jmp    800946 <strfind+0xf>
  800943:	83 c0 01             	add    $0x1,%eax
  800946:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800949:	38 ca                	cmp    %cl,%dl
  80094b:	74 04                	je     800951 <strfind+0x1a>
  80094d:	84 d2                	test   %dl,%dl
  80094f:	75 f2                	jne    800943 <strfind+0xc>
			break;
	return (char *) s;
}
  800951:	5d                   	pop    %ebp
  800952:	c3                   	ret    

00800953 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800953:	55                   	push   %ebp
  800954:	89 e5                	mov    %esp,%ebp
  800956:	57                   	push   %edi
  800957:	56                   	push   %esi
  800958:	53                   	push   %ebx
  800959:	8b 55 08             	mov    0x8(%ebp),%edx
  80095c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  80095f:	85 c9                	test   %ecx,%ecx
  800961:	74 37                	je     80099a <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800963:	f6 c2 03             	test   $0x3,%dl
  800966:	75 2a                	jne    800992 <memset+0x3f>
  800968:	f6 c1 03             	test   $0x3,%cl
  80096b:	75 25                	jne    800992 <memset+0x3f>
		c &= 0xFF;
  80096d:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800971:	89 df                	mov    %ebx,%edi
  800973:	c1 e7 08             	shl    $0x8,%edi
  800976:	89 de                	mov    %ebx,%esi
  800978:	c1 e6 18             	shl    $0x18,%esi
  80097b:	89 d8                	mov    %ebx,%eax
  80097d:	c1 e0 10             	shl    $0x10,%eax
  800980:	09 f0                	or     %esi,%eax
  800982:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800984:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800987:	89 f8                	mov    %edi,%eax
  800989:	09 d8                	or     %ebx,%eax
  80098b:	89 d7                	mov    %edx,%edi
  80098d:	fc                   	cld    
  80098e:	f3 ab                	rep stos %eax,%es:(%edi)
  800990:	eb 08                	jmp    80099a <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800992:	89 d7                	mov    %edx,%edi
  800994:	8b 45 0c             	mov    0xc(%ebp),%eax
  800997:	fc                   	cld    
  800998:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  80099a:	89 d0                	mov    %edx,%eax
  80099c:	5b                   	pop    %ebx
  80099d:	5e                   	pop    %esi
  80099e:	5f                   	pop    %edi
  80099f:	5d                   	pop    %ebp
  8009a0:	c3                   	ret    

008009a1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009a1:	55                   	push   %ebp
  8009a2:	89 e5                	mov    %esp,%ebp
  8009a4:	57                   	push   %edi
  8009a5:	56                   	push   %esi
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009af:	39 c6                	cmp    %eax,%esi
  8009b1:	73 35                	jae    8009e8 <memmove+0x47>
  8009b3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009b6:	39 d0                	cmp    %edx,%eax
  8009b8:	73 2e                	jae    8009e8 <memmove+0x47>
		s += n;
		d += n;
  8009ba:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009bd:	89 d6                	mov    %edx,%esi
  8009bf:	09 fe                	or     %edi,%esi
  8009c1:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009c7:	75 13                	jne    8009dc <memmove+0x3b>
  8009c9:	f6 c1 03             	test   $0x3,%cl
  8009cc:	75 0e                	jne    8009dc <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  8009ce:	83 ef 04             	sub    $0x4,%edi
  8009d1:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009d4:	c1 e9 02             	shr    $0x2,%ecx
  8009d7:	fd                   	std    
  8009d8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009da:	eb 09                	jmp    8009e5 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009dc:	83 ef 01             	sub    $0x1,%edi
  8009df:	8d 72 ff             	lea    -0x1(%edx),%esi
  8009e2:	fd                   	std    
  8009e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009e5:	fc                   	cld    
  8009e6:	eb 1d                	jmp    800a05 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e8:	89 f2                	mov    %esi,%edx
  8009ea:	09 c2                	or     %eax,%edx
  8009ec:	f6 c2 03             	test   $0x3,%dl
  8009ef:	75 0f                	jne    800a00 <memmove+0x5f>
  8009f1:	f6 c1 03             	test   $0x3,%cl
  8009f4:	75 0a                	jne    800a00 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  8009f6:	c1 e9 02             	shr    $0x2,%ecx
  8009f9:	89 c7                	mov    %eax,%edi
  8009fb:	fc                   	cld    
  8009fc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009fe:	eb 05                	jmp    800a05 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a00:	89 c7                	mov    %eax,%edi
  800a02:	fc                   	cld    
  800a03:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a05:	5e                   	pop    %esi
  800a06:	5f                   	pop    %edi
  800a07:	5d                   	pop    %ebp
  800a08:	c3                   	ret    

00800a09 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a09:	55                   	push   %ebp
  800a0a:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a0c:	ff 75 10             	pushl  0x10(%ebp)
  800a0f:	ff 75 0c             	pushl  0xc(%ebp)
  800a12:	ff 75 08             	pushl  0x8(%ebp)
  800a15:	e8 87 ff ff ff       	call   8009a1 <memmove>
}
  800a1a:	c9                   	leave  
  800a1b:	c3                   	ret    

00800a1c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	56                   	push   %esi
  800a20:	53                   	push   %ebx
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a27:	89 c6                	mov    %eax,%esi
  800a29:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a2c:	eb 1a                	jmp    800a48 <memcmp+0x2c>
		if (*s1 != *s2)
  800a2e:	0f b6 08             	movzbl (%eax),%ecx
  800a31:	0f b6 1a             	movzbl (%edx),%ebx
  800a34:	38 d9                	cmp    %bl,%cl
  800a36:	74 0a                	je     800a42 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a38:	0f b6 c1             	movzbl %cl,%eax
  800a3b:	0f b6 db             	movzbl %bl,%ebx
  800a3e:	29 d8                	sub    %ebx,%eax
  800a40:	eb 0f                	jmp    800a51 <memcmp+0x35>
		s1++, s2++;
  800a42:	83 c0 01             	add    $0x1,%eax
  800a45:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a48:	39 f0                	cmp    %esi,%eax
  800a4a:	75 e2                	jne    800a2e <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a51:	5b                   	pop    %ebx
  800a52:	5e                   	pop    %esi
  800a53:	5d                   	pop    %ebp
  800a54:	c3                   	ret    

00800a55 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a55:	55                   	push   %ebp
  800a56:	89 e5                	mov    %esp,%ebp
  800a58:	53                   	push   %ebx
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800a5c:	89 c1                	mov    %eax,%ecx
  800a5e:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  800a61:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a65:	eb 0a                	jmp    800a71 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a67:	0f b6 10             	movzbl (%eax),%edx
  800a6a:	39 da                	cmp    %ebx,%edx
  800a6c:	74 07                	je     800a75 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a6e:	83 c0 01             	add    $0x1,%eax
  800a71:	39 c8                	cmp    %ecx,%eax
  800a73:	72 f2                	jb     800a67 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a75:	5b                   	pop    %ebx
  800a76:	5d                   	pop    %ebp
  800a77:	c3                   	ret    

00800a78 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	57                   	push   %edi
  800a7c:	56                   	push   %esi
  800a7d:	53                   	push   %ebx
  800a7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a81:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a84:	eb 03                	jmp    800a89 <strtol+0x11>
		s++;
  800a86:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a89:	0f b6 01             	movzbl (%ecx),%eax
  800a8c:	3c 20                	cmp    $0x20,%al
  800a8e:	74 f6                	je     800a86 <strtol+0xe>
  800a90:	3c 09                	cmp    $0x9,%al
  800a92:	74 f2                	je     800a86 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a94:	3c 2b                	cmp    $0x2b,%al
  800a96:	75 0a                	jne    800aa2 <strtol+0x2a>
		s++;
  800a98:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a9b:	bf 00 00 00 00       	mov    $0x0,%edi
  800aa0:	eb 11                	jmp    800ab3 <strtol+0x3b>
  800aa2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800aa7:	3c 2d                	cmp    $0x2d,%al
  800aa9:	75 08                	jne    800ab3 <strtol+0x3b>
		s++, neg = 1;
  800aab:	83 c1 01             	add    $0x1,%ecx
  800aae:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ab3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ab9:	75 15                	jne    800ad0 <strtol+0x58>
  800abb:	80 39 30             	cmpb   $0x30,(%ecx)
  800abe:	75 10                	jne    800ad0 <strtol+0x58>
  800ac0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ac4:	75 7c                	jne    800b42 <strtol+0xca>
		s += 2, base = 16;
  800ac6:	83 c1 02             	add    $0x2,%ecx
  800ac9:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ace:	eb 16                	jmp    800ae6 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800ad0:	85 db                	test   %ebx,%ebx
  800ad2:	75 12                	jne    800ae6 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ad4:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ad9:	80 39 30             	cmpb   $0x30,(%ecx)
  800adc:	75 08                	jne    800ae6 <strtol+0x6e>
		s++, base = 8;
  800ade:	83 c1 01             	add    $0x1,%ecx
  800ae1:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800ae6:	b8 00 00 00 00       	mov    $0x0,%eax
  800aeb:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800aee:	0f b6 11             	movzbl (%ecx),%edx
  800af1:	8d 72 d0             	lea    -0x30(%edx),%esi
  800af4:	89 f3                	mov    %esi,%ebx
  800af6:	80 fb 09             	cmp    $0x9,%bl
  800af9:	77 08                	ja     800b03 <strtol+0x8b>
			dig = *s - '0';
  800afb:	0f be d2             	movsbl %dl,%edx
  800afe:	83 ea 30             	sub    $0x30,%edx
  800b01:	eb 22                	jmp    800b25 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800b03:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b06:	89 f3                	mov    %esi,%ebx
  800b08:	80 fb 19             	cmp    $0x19,%bl
  800b0b:	77 08                	ja     800b15 <strtol+0x9d>
			dig = *s - 'a' + 10;
  800b0d:	0f be d2             	movsbl %dl,%edx
  800b10:	83 ea 57             	sub    $0x57,%edx
  800b13:	eb 10                	jmp    800b25 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800b15:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b18:	89 f3                	mov    %esi,%ebx
  800b1a:	80 fb 19             	cmp    $0x19,%bl
  800b1d:	77 16                	ja     800b35 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800b1f:	0f be d2             	movsbl %dl,%edx
  800b22:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800b25:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b28:	7d 0b                	jge    800b35 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800b2a:	83 c1 01             	add    $0x1,%ecx
  800b2d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b31:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800b33:	eb b9                	jmp    800aee <strtol+0x76>

	if (endptr)
  800b35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b39:	74 0d                	je     800b48 <strtol+0xd0>
		*endptr = (char *) s;
  800b3b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b3e:	89 0e                	mov    %ecx,(%esi)
  800b40:	eb 06                	jmp    800b48 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b42:	85 db                	test   %ebx,%ebx
  800b44:	74 98                	je     800ade <strtol+0x66>
  800b46:	eb 9e                	jmp    800ae6 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800b48:	89 c2                	mov    %eax,%edx
  800b4a:	f7 da                	neg    %edx
  800b4c:	85 ff                	test   %edi,%edi
  800b4e:	0f 45 c2             	cmovne %edx,%eax
}
  800b51:	5b                   	pop    %ebx
  800b52:	5e                   	pop    %esi
  800b53:	5f                   	pop    %edi
  800b54:	5d                   	pop    %ebp
  800b55:	c3                   	ret    

00800b56 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	57                   	push   %edi
  800b5a:	56                   	push   %esi
  800b5b:	53                   	push   %ebx
  800b5c:	83 ec 1c             	sub    $0x1c,%esp
  800b5f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b62:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b65:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b6a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b6d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800b70:	8b 75 14             	mov    0x14(%ebp),%esi
  800b73:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800b75:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b79:	74 1d                	je     800b98 <syscall+0x42>
  800b7b:	85 c0                	test   %eax,%eax
  800b7d:	7e 19                	jle    800b98 <syscall+0x42>
  800b7f:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800b82:	83 ec 0c             	sub    $0xc,%esp
  800b85:	50                   	push   %eax
  800b86:	52                   	push   %edx
  800b87:	68 9f 27 80 00       	push   $0x80279f
  800b8c:	6a 23                	push   $0x23
  800b8e:	68 bc 27 80 00       	push   $0x8027bc
  800b93:	e8 98 14 00 00       	call   802030 <_panic>

	return ret;
}
  800b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b9b:	5b                   	pop    %ebx
  800b9c:	5e                   	pop    %esi
  800b9d:	5f                   	pop    %edi
  800b9e:	5d                   	pop    %ebp
  800b9f:	c3                   	ret    

00800ba0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800ba6:	6a 00                	push   $0x0
  800ba8:	6a 00                	push   $0x0
  800baa:	6a 00                	push   $0x0
  800bac:	ff 75 0c             	pushl  0xc(%ebp)
  800baf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb2:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bbc:	e8 95 ff ff ff       	call   800b56 <syscall>
}
  800bc1:	83 c4 10             	add    $0x10,%esp
  800bc4:	c9                   	leave  
  800bc5:	c3                   	ret    

00800bc6 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800bcc:	6a 00                	push   $0x0
  800bce:	6a 00                	push   $0x0
  800bd0:	6a 00                	push   $0x0
  800bd2:	6a 00                	push   $0x0
  800bd4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bd9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bde:	b8 01 00 00 00       	mov    $0x1,%eax
  800be3:	e8 6e ff ff ff       	call   800b56 <syscall>
}
  800be8:	c9                   	leave  
  800be9:	c3                   	ret    

00800bea <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800bf0:	6a 00                	push   $0x0
  800bf2:	6a 00                	push   $0x0
  800bf4:	6a 00                	push   $0x0
  800bf6:	6a 00                	push   $0x0
  800bf8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bfb:	ba 01 00 00 00       	mov    $0x1,%edx
  800c00:	b8 03 00 00 00       	mov    $0x3,%eax
  800c05:	e8 4c ff ff ff       	call   800b56 <syscall>
}
  800c0a:	c9                   	leave  
  800c0b:	c3                   	ret    

00800c0c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800c12:	6a 00                	push   $0x0
  800c14:	6a 00                	push   $0x0
  800c16:	6a 00                	push   $0x0
  800c18:	6a 00                	push   $0x0
  800c1a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c24:	b8 02 00 00 00       	mov    $0x2,%eax
  800c29:	e8 28 ff ff ff       	call   800b56 <syscall>
}
  800c2e:	c9                   	leave  
  800c2f:	c3                   	ret    

00800c30 <sys_yield>:

void
sys_yield(void)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800c36:	6a 00                	push   $0x0
  800c38:	6a 00                	push   $0x0
  800c3a:	6a 00                	push   $0x0
  800c3c:	6a 00                	push   $0x0
  800c3e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c43:	ba 00 00 00 00       	mov    $0x0,%edx
  800c48:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c4d:	e8 04 ff ff ff       	call   800b56 <syscall>
}
  800c52:	83 c4 10             	add    $0x10,%esp
  800c55:	c9                   	leave  
  800c56:	c3                   	ret    

00800c57 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800c5d:	6a 00                	push   $0x0
  800c5f:	6a 00                	push   $0x0
  800c61:	ff 75 10             	pushl  0x10(%ebp)
  800c64:	ff 75 0c             	pushl  0xc(%ebp)
  800c67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c6a:	ba 01 00 00 00       	mov    $0x1,%edx
  800c6f:	b8 04 00 00 00       	mov    $0x4,%eax
  800c74:	e8 dd fe ff ff       	call   800b56 <syscall>
}
  800c79:	c9                   	leave  
  800c7a:	c3                   	ret    

00800c7b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800c81:	ff 75 18             	pushl  0x18(%ebp)
  800c84:	ff 75 14             	pushl  0x14(%ebp)
  800c87:	ff 75 10             	pushl  0x10(%ebp)
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c90:	ba 01 00 00 00       	mov    $0x1,%edx
  800c95:	b8 05 00 00 00       	mov    $0x5,%eax
  800c9a:	e8 b7 fe ff ff       	call   800b56 <syscall>
}
  800c9f:	c9                   	leave  
  800ca0:	c3                   	ret    

00800ca1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
  800ca4:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800ca7:	6a 00                	push   $0x0
  800ca9:	6a 00                	push   $0x0
  800cab:	6a 00                	push   $0x0
  800cad:	ff 75 0c             	pushl  0xc(%ebp)
  800cb0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cb3:	ba 01 00 00 00       	mov    $0x1,%edx
  800cb8:	b8 06 00 00 00       	mov    $0x6,%eax
  800cbd:	e8 94 fe ff ff       	call   800b56 <syscall>
}
  800cc2:	c9                   	leave  
  800cc3:	c3                   	ret    

00800cc4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800cca:	6a 00                	push   $0x0
  800ccc:	6a 00                	push   $0x0
  800cce:	6a 00                	push   $0x0
  800cd0:	ff 75 0c             	pushl  0xc(%ebp)
  800cd3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd6:	ba 01 00 00 00       	mov    $0x1,%edx
  800cdb:	b8 08 00 00 00       	mov    $0x8,%eax
  800ce0:	e8 71 fe ff ff       	call   800b56 <syscall>
}
  800ce5:	c9                   	leave  
  800ce6:	c3                   	ret    

00800ce7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800ced:	6a 00                	push   $0x0
  800cef:	6a 00                	push   $0x0
  800cf1:	6a 00                	push   $0x0
  800cf3:	ff 75 0c             	pushl  0xc(%ebp)
  800cf6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cf9:	ba 01 00 00 00       	mov    $0x1,%edx
  800cfe:	b8 09 00 00 00       	mov    $0x9,%eax
  800d03:	e8 4e fe ff ff       	call   800b56 <syscall>
}
  800d08:	c9                   	leave  
  800d09:	c3                   	ret    

00800d0a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
  800d0d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800d10:	6a 00                	push   $0x0
  800d12:	6a 00                	push   $0x0
  800d14:	6a 00                	push   $0x0
  800d16:	ff 75 0c             	pushl  0xc(%ebp)
  800d19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d1c:	ba 01 00 00 00       	mov    $0x1,%edx
  800d21:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d26:	e8 2b fe ff ff       	call   800b56 <syscall>
}
  800d2b:	c9                   	leave  
  800d2c:	c3                   	ret    

00800d2d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800d33:	6a 00                	push   $0x0
  800d35:	ff 75 14             	pushl  0x14(%ebp)
  800d38:	ff 75 10             	pushl  0x10(%ebp)
  800d3b:	ff 75 0c             	pushl  0xc(%ebp)
  800d3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d41:	ba 00 00 00 00       	mov    $0x0,%edx
  800d46:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d4b:	e8 06 fe ff ff       	call   800b56 <syscall>
}
  800d50:	c9                   	leave  
  800d51:	c3                   	ret    

00800d52 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800d58:	6a 00                	push   $0x0
  800d5a:	6a 00                	push   $0x0
  800d5c:	6a 00                	push   $0x0
  800d5e:	6a 00                	push   $0x0
  800d60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d63:	ba 01 00 00 00       	mov    $0x1,%edx
  800d68:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d6d:	e8 e4 fd ff ff       	call   800b56 <syscall>
}
  800d72:	c9                   	leave  
  800d73:	c3                   	ret    

00800d74 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800d74:	55                   	push   %ebp
  800d75:	89 e5                	mov    %esp,%ebp
  800d77:	53                   	push   %ebx
  800d78:	83 ec 04             	sub    $0x4,%esp

	int perm_w = PTE_COW|PTE_U|PTE_P;
	int perm = PTE_U|PTE_P;

	// LAB 4: Your code here.
	void *addr = (void*) (pn*PGSIZE);
  800d7b:	89 d3                	mov    %edx,%ebx
  800d7d:	c1 e3 0c             	shl    $0xc,%ebx

	//Si una página tiene el bit PTE_SHARE, se comparte con el hijo con los mismos permisos.
  	if (uvpt[pn] & PTE_SHARE) {
  800d80:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800d87:	f6 c5 04             	test   $0x4,%ch
  800d8a:	74 3a                	je     800dc6 <duppage+0x52>
    	if (sys_page_map(0, addr, envid,addr, uvpt[pn] & PTE_SYSCALL) < 0) {
  800d8c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d93:	83 ec 0c             	sub    $0xc,%esp
  800d96:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800d9c:	52                   	push   %edx
  800d9d:	53                   	push   %ebx
  800d9e:	50                   	push   %eax
  800d9f:	53                   	push   %ebx
  800da0:	6a 00                	push   $0x0
  800da2:	e8 d4 fe ff ff       	call   800c7b <sys_page_map>
  800da7:	83 c4 20             	add    $0x20,%esp
  800daa:	85 c0                	test   %eax,%eax
  800dac:	0f 89 99 00 00 00    	jns    800e4b <duppage+0xd7>
 	     	panic("Error en sys_page_map");
  800db2:	83 ec 04             	sub    $0x4,%esp
  800db5:	68 ca 27 80 00       	push   $0x8027ca
  800dba:	6a 50                	push   $0x50
  800dbc:	68 e0 27 80 00       	push   $0x8027e0
  800dc1:	e8 6a 12 00 00       	call   802030 <_panic>
    	} 
    	return 0;
	}

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  800dc6:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800dcd:	f6 c1 02             	test   $0x2,%cl
  800dd0:	75 0c                	jne    800dde <duppage+0x6a>
  800dd2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800dd9:	f6 c6 08             	test   $0x8,%dh
  800ddc:	74 5b                	je     800e39 <duppage+0xc5>
		if (sys_page_map(0, addr, envid, addr, perm_w) < 0){
  800dde:	83 ec 0c             	sub    $0xc,%esp
  800de1:	68 05 08 00 00       	push   $0x805
  800de6:	53                   	push   %ebx
  800de7:	50                   	push   %eax
  800de8:	53                   	push   %ebx
  800de9:	6a 00                	push   $0x0
  800deb:	e8 8b fe ff ff       	call   800c7b <sys_page_map>
  800df0:	83 c4 20             	add    $0x20,%esp
  800df3:	85 c0                	test   %eax,%eax
  800df5:	79 14                	jns    800e0b <duppage+0x97>
			panic("Error mapeando pagina Padre");
  800df7:	83 ec 04             	sub    $0x4,%esp
  800dfa:	68 eb 27 80 00       	push   $0x8027eb
  800dff:	6a 57                	push   $0x57
  800e01:	68 e0 27 80 00       	push   $0x8027e0
  800e06:	e8 25 12 00 00       	call   802030 <_panic>
		}
		if (sys_page_map(0, addr, 0, addr, perm_w) < 0){
  800e0b:	83 ec 0c             	sub    $0xc,%esp
  800e0e:	68 05 08 00 00       	push   $0x805
  800e13:	53                   	push   %ebx
  800e14:	6a 00                	push   $0x0
  800e16:	53                   	push   %ebx
  800e17:	6a 00                	push   $0x0
  800e19:	e8 5d fe ff ff       	call   800c7b <sys_page_map>
  800e1e:	83 c4 20             	add    $0x20,%esp
  800e21:	85 c0                	test   %eax,%eax
  800e23:	79 26                	jns    800e4b <duppage+0xd7>
			panic("Error mapeando pagina Hijo");
  800e25:	83 ec 04             	sub    $0x4,%esp
  800e28:	68 07 28 80 00       	push   $0x802807
  800e2d:	6a 5a                	push   $0x5a
  800e2f:	68 e0 27 80 00       	push   $0x8027e0
  800e34:	e8 f7 11 00 00       	call   802030 <_panic>
		}
	} else sys_page_map(0, addr, envid, addr, perm);
  800e39:	83 ec 0c             	sub    $0xc,%esp
  800e3c:	6a 05                	push   $0x5
  800e3e:	53                   	push   %ebx
  800e3f:	50                   	push   %eax
  800e40:	53                   	push   %ebx
  800e41:	6a 00                	push   $0x0
  800e43:	e8 33 fe ff ff       	call   800c7b <sys_page_map>
  800e48:	83 c4 20             	add    $0x20,%esp
	
	return 0;
}
  800e4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e53:	c9                   	leave  
  800e54:	c3                   	ret    

00800e55 <dup_or_share>:
//FORK V0

static void
dup_or_share(envid_t dstenv, void *va, int perm){
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
  800e58:	57                   	push   %edi
  800e59:	56                   	push   %esi
  800e5a:	53                   	push   %ebx
  800e5b:	83 ec 0c             	sub    $0xc,%esp
  800e5e:	89 c7                	mov    %eax,%edi
  800e60:	89 d6                	mov    %edx,%esi
  800e62:	89 cb                	mov    %ecx,%ebx
	int result;
	// Si no es de escritura, comparto la pagina
	if((perm &PTE_W) != PTE_W){
  800e64:	f6 c1 02             	test   $0x2,%cl
  800e67:	75 2d                	jne    800e96 <dup_or_share+0x41>
		if((result = sys_page_map(0, va, dstenv, va, perm))<0){
  800e69:	83 ec 0c             	sub    $0xc,%esp
  800e6c:	51                   	push   %ecx
  800e6d:	52                   	push   %edx
  800e6e:	50                   	push   %eax
  800e6f:	52                   	push   %edx
  800e70:	6a 00                	push   $0x0
  800e72:	e8 04 fe ff ff       	call   800c7b <sys_page_map>
  800e77:	83 c4 20             	add    $0x20,%esp
  800e7a:	85 c0                	test   %eax,%eax
  800e7c:	0f 89 a4 00 00 00    	jns    800f26 <dup_or_share+0xd1>
			panic("Error compartiendo la pagina");
  800e82:	83 ec 04             	sub    $0x4,%esp
  800e85:	68 22 28 80 00       	push   $0x802822
  800e8a:	6a 68                	push   $0x68
  800e8c:	68 e0 27 80 00       	push   $0x8027e0
  800e91:	e8 9a 11 00 00       	call   802030 <_panic>
		}
	// Si es de escritura comportamiento de duppage, en dumbfork
	}else{
		if ((result = sys_page_alloc(dstenv, va, perm)) < 0){
  800e96:	83 ec 04             	sub    $0x4,%esp
  800e99:	51                   	push   %ecx
  800e9a:	52                   	push   %edx
  800e9b:	50                   	push   %eax
  800e9c:	e8 b6 fd ff ff       	call   800c57 <sys_page_alloc>
  800ea1:	83 c4 10             	add    $0x10,%esp
  800ea4:	85 c0                	test   %eax,%eax
  800ea6:	79 14                	jns    800ebc <dup_or_share+0x67>
			panic("Error copiando la pagina");
  800ea8:	83 ec 04             	sub    $0x4,%esp
  800eab:	68 3f 28 80 00       	push   $0x80283f
  800eb0:	6a 6d                	push   $0x6d
  800eb2:	68 e0 27 80 00       	push   $0x8027e0
  800eb7:	e8 74 11 00 00       	call   802030 <_panic>
		}
		if ((result = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0){
  800ebc:	83 ec 0c             	sub    $0xc,%esp
  800ebf:	53                   	push   %ebx
  800ec0:	68 00 00 40 00       	push   $0x400000
  800ec5:	6a 00                	push   $0x0
  800ec7:	56                   	push   %esi
  800ec8:	57                   	push   %edi
  800ec9:	e8 ad fd ff ff       	call   800c7b <sys_page_map>
  800ece:	83 c4 20             	add    $0x20,%esp
  800ed1:	85 c0                	test   %eax,%eax
  800ed3:	79 14                	jns    800ee9 <dup_or_share+0x94>
			panic("Error copiando la pagina");
  800ed5:	83 ec 04             	sub    $0x4,%esp
  800ed8:	68 3f 28 80 00       	push   $0x80283f
  800edd:	6a 70                	push   $0x70
  800edf:	68 e0 27 80 00       	push   $0x8027e0
  800ee4:	e8 47 11 00 00       	call   802030 <_panic>
		}
		memmove(UTEMP, va, PGSIZE);
  800ee9:	83 ec 04             	sub    $0x4,%esp
  800eec:	68 00 10 00 00       	push   $0x1000
  800ef1:	56                   	push   %esi
  800ef2:	68 00 00 40 00       	push   $0x400000
  800ef7:	e8 a5 fa ff ff       	call   8009a1 <memmove>
		if ((result = sys_page_unmap(0, UTEMP)) < 0){
  800efc:	83 c4 08             	add    $0x8,%esp
  800eff:	68 00 00 40 00       	push   $0x400000
  800f04:	6a 00                	push   $0x0
  800f06:	e8 96 fd ff ff       	call   800ca1 <sys_page_unmap>
  800f0b:	83 c4 10             	add    $0x10,%esp
  800f0e:	85 c0                	test   %eax,%eax
  800f10:	79 14                	jns    800f26 <dup_or_share+0xd1>
			panic("Error copiando la pagina");
  800f12:	83 ec 04             	sub    $0x4,%esp
  800f15:	68 3f 28 80 00       	push   $0x80283f
  800f1a:	6a 74                	push   $0x74
  800f1c:	68 e0 27 80 00       	push   $0x8027e0
  800f21:	e8 0a 11 00 00       	call   802030 <_panic>
		}
	}	
}
  800f26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f29:	5b                   	pop    %ebx
  800f2a:	5e                   	pop    %esi
  800f2b:	5f                   	pop    %edi
  800f2c:	5d                   	pop    %ebp
  800f2d:	c3                   	ret    

00800f2e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	53                   	push   %ebx
  800f32:	83 ec 04             	sub    $0x4,%esp
  800f35:	8b 55 08             	mov    0x8(%ebp),%edx
	void *va = (void *) utf->utf_fault_va;
  800f38:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800f3a:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  800f3e:	74 2e                	je     800f6e <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
  800f40:	89 c2                	mov    %eax,%edx
  800f42:	c1 ea 16             	shr    $0x16,%edx
  800f45:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800f4c:	f6 c2 01             	test   $0x1,%dl
  800f4f:	74 1d                	je     800f6e <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
  800f51:	89 c2                	mov    %eax,%edx
  800f53:	c1 ea 0c             	shr    $0xc,%edx
  800f56:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
		(uvpd[PDX(va)] & PTE_P) && 
  800f5d:	f6 c1 01             	test   $0x1,%cl
  800f60:	74 0c                	je     800f6e <pgfault+0x40>
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
  800f62:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800f69:	f6 c6 08             	test   $0x8,%dh
  800f6c:	75 14                	jne    800f82 <pgfault+0x54>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
		panic("No es copy-on-write");
  800f6e:	83 ec 04             	sub    $0x4,%esp
  800f71:	68 58 28 80 00       	push   $0x802858
  800f76:	6a 21                	push   $0x21
  800f78:	68 e0 27 80 00       	push   $0x8027e0
  800f7d:	e8 ae 10 00 00       	call   802030 <_panic>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	va = ROUNDDOWN(va, PGSIZE);
  800f82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f87:	89 c3                	mov    %eax,%ebx
	if (sys_page_alloc(0, PFTEMP, perm) < 0){
  800f89:	83 ec 04             	sub    $0x4,%esp
  800f8c:	6a 07                	push   $0x7
  800f8e:	68 00 f0 7f 00       	push   $0x7ff000
  800f93:	6a 00                	push   $0x0
  800f95:	e8 bd fc ff ff       	call   800c57 <sys_page_alloc>
  800f9a:	83 c4 10             	add    $0x10,%esp
  800f9d:	85 c0                	test   %eax,%eax
  800f9f:	79 14                	jns    800fb5 <pgfault+0x87>
		panic("Error sys_page_alloc");
  800fa1:	83 ec 04             	sub    $0x4,%esp
  800fa4:	68 6c 28 80 00       	push   $0x80286c
  800fa9:	6a 2a                	push   $0x2a
  800fab:	68 e0 27 80 00       	push   $0x8027e0
  800fb0:	e8 7b 10 00 00       	call   802030 <_panic>
	}
	memcpy(PFTEMP, va, PGSIZE);
  800fb5:	83 ec 04             	sub    $0x4,%esp
  800fb8:	68 00 10 00 00       	push   $0x1000
  800fbd:	53                   	push   %ebx
  800fbe:	68 00 f0 7f 00       	push   $0x7ff000
  800fc3:	e8 41 fa ff ff       	call   800a09 <memcpy>
	if (sys_page_map(0, PFTEMP, 0, va, perm) < 0){
  800fc8:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800fcf:	53                   	push   %ebx
  800fd0:	6a 00                	push   $0x0
  800fd2:	68 00 f0 7f 00       	push   $0x7ff000
  800fd7:	6a 00                	push   $0x0
  800fd9:	e8 9d fc ff ff       	call   800c7b <sys_page_map>
  800fde:	83 c4 20             	add    $0x20,%esp
  800fe1:	85 c0                	test   %eax,%eax
  800fe3:	79 14                	jns    800ff9 <pgfault+0xcb>
		panic("Error sys_page_map");
  800fe5:	83 ec 04             	sub    $0x4,%esp
  800fe8:	68 81 28 80 00       	push   $0x802881
  800fed:	6a 2e                	push   $0x2e
  800fef:	68 e0 27 80 00       	push   $0x8027e0
  800ff4:	e8 37 10 00 00       	call   802030 <_panic>
	}
	if (sys_page_unmap(0, PFTEMP) < 0){
  800ff9:	83 ec 08             	sub    $0x8,%esp
  800ffc:	68 00 f0 7f 00       	push   $0x7ff000
  801001:	6a 00                	push   $0x0
  801003:	e8 99 fc ff ff       	call   800ca1 <sys_page_unmap>
  801008:	83 c4 10             	add    $0x10,%esp
  80100b:	85 c0                	test   %eax,%eax
  80100d:	79 14                	jns    801023 <pgfault+0xf5>
		panic("Error sys_page_unmap");
  80100f:	83 ec 04             	sub    $0x4,%esp
  801012:	68 94 28 80 00       	push   $0x802894
  801017:	6a 31                	push   $0x31
  801019:	68 e0 27 80 00       	push   $0x8027e0
  80101e:	e8 0d 10 00 00       	call   802030 <_panic>
	}
	return;

}
  801023:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <fork_v0>:
		}
	}	
}

envid_t
fork_v0(void){
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	57                   	push   %edi
  80102c:	56                   	push   %esi
  80102d:	53                   	push   %ebx
  80102e:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801031:	b8 07 00 00 00       	mov    $0x7,%eax
  801036:	cd 30                	int    $0x30
  801038:	89 c6                	mov    %eax,%esi
	envid_t envid;
	uint8_t *va;
	int result;	

	envid = sys_exofork();
	if (envid < 0)
  80103a:	85 c0                	test   %eax,%eax
  80103c:	79 15                	jns    801053 <fork_v0+0x2b>
		panic("sys_exofork: %e", envid);
  80103e:	50                   	push   %eax
  80103f:	68 a9 28 80 00       	push   $0x8028a9
  801044:	68 81 00 00 00       	push   $0x81
  801049:	68 e0 27 80 00       	push   $0x8027e0
  80104e:	e8 dd 0f 00 00       	call   802030 <_panic>
  801053:	89 c7                	mov    %eax,%edi
  801055:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {		
  80105a:	85 c0                	test   %eax,%eax
  80105c:	75 1e                	jne    80107c <fork_v0+0x54>
		thisenv = &envs[ENVX(sys_getenvid())];
  80105e:	e8 a9 fb ff ff       	call   800c0c <sys_getenvid>
  801063:	25 ff 03 00 00       	and    $0x3ff,%eax
  801068:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80106b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801070:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801075:	b8 00 00 00 00       	mov    $0x0,%eax
  80107a:	eb 7a                	jmp    8010f6 <fork_v0+0xce>
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  80107c:	89 d8                	mov    %ebx,%eax
  80107e:	c1 e8 16             	shr    $0x16,%eax
  801081:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801088:	a8 01                	test   $0x1,%al
  80108a:	74 33                	je     8010bf <fork_v0+0x97>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  80108c:	89 d8                	mov    %ebx,%eax
  80108e:	c1 e8 0c             	shr    $0xc,%eax
  801091:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801098:	f6 c2 01             	test   $0x1,%dl
  80109b:	74 22                	je     8010bf <fork_v0+0x97>
  80109d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010a4:	f6 c2 04             	test   $0x4,%dl
  8010a7:	74 16                	je     8010bf <fork_v0+0x97>
				pte_t pte =uvpt[PGNUM(va)];
  8010a9:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
  8010b0:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8010b6:	89 da                	mov    %ebx,%edx
  8010b8:	89 f8                	mov    %edi,%eax
  8010ba:	e8 96 fd ff ff       	call   800e55 <dup_or_share>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
  8010bf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010c5:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  8010cb:	75 af                	jne    80107c <fork_v0+0x54>
				pte_t pte =uvpt[PGNUM(va)];
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
			}
		}
	}	
	if ((result = sys_env_set_status(envid, ENV_RUNNABLE)) < 0){
  8010cd:	83 ec 08             	sub    $0x8,%esp
  8010d0:	6a 02                	push   $0x2
  8010d2:	56                   	push   %esi
  8010d3:	e8 ec fb ff ff       	call   800cc4 <sys_env_set_status>
  8010d8:	83 c4 10             	add    $0x10,%esp
  8010db:	85 c0                	test   %eax,%eax
  8010dd:	79 15                	jns    8010f4 <fork_v0+0xcc>

		panic("sys_env_set_status: %e", result);
  8010df:	50                   	push   %eax
  8010e0:	68 b9 28 80 00       	push   $0x8028b9
  8010e5:	68 90 00 00 00       	push   $0x90
  8010ea:	68 e0 27 80 00       	push   $0x8027e0
  8010ef:	e8 3c 0f 00 00       	call   802030 <_panic>
	}
	return envid;
  8010f4:	89 f0                	mov    %esi,%eax
}
  8010f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f9:	5b                   	pop    %ebx
  8010fa:	5e                   	pop    %esi
  8010fb:	5f                   	pop    %edi
  8010fc:	5d                   	pop    %ebp
  8010fd:	c3                   	ret    

008010fe <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010fe:	55                   	push   %ebp
  8010ff:	89 e5                	mov    %esp,%ebp
  801101:	57                   	push   %edi
  801102:	56                   	push   %esi
  801103:	53                   	push   %ebx
  801104:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801107:	68 2e 0f 80 00       	push   $0x800f2e
  80110c:	e8 65 0f 00 00       	call   802076 <set_pgfault_handler>
  801111:	b8 07 00 00 00       	mov    $0x7,%eax
  801116:	cd 30                	int    $0x30
  801118:	89 c6                	mov    %eax,%esi

	envid_t envid;
	uint32_t va;
	envid = sys_exofork();
	if (envid < 0){
  80111a:	83 c4 10             	add    $0x10,%esp
  80111d:	85 c0                	test   %eax,%eax
  80111f:	79 15                	jns    801136 <fork+0x38>
		panic("sys_exofork: %e", envid);
  801121:	50                   	push   %eax
  801122:	68 a9 28 80 00       	push   $0x8028a9
  801127:	68 b1 00 00 00       	push   $0xb1
  80112c:	68 e0 27 80 00       	push   $0x8027e0
  801131:	e8 fa 0e 00 00       	call   802030 <_panic>
  801136:	89 c7                	mov    %eax,%edi
  801138:	bb 00 00 00 00       	mov    $0x0,%ebx
	}
	if (envid == 0) {		
  80113d:	85 c0                	test   %eax,%eax
  80113f:	75 21                	jne    801162 <fork+0x64>
		thisenv = &envs[ENVX(sys_getenvid())];
  801141:	e8 c6 fa ff ff       	call   800c0c <sys_getenvid>
  801146:	25 ff 03 00 00       	and    $0x3ff,%eax
  80114b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80114e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801153:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801158:	b8 00 00 00 00       	mov    $0x0,%eax
  80115d:	e9 a7 00 00 00       	jmp    801209 <fork+0x10b>
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  801162:	89 d8                	mov    %ebx,%eax
  801164:	c1 e8 16             	shr    $0x16,%eax
  801167:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80116e:	a8 01                	test   $0x1,%al
  801170:	74 22                	je     801194 <fork+0x96>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  801172:	89 da                	mov    %ebx,%edx
  801174:	c1 ea 0c             	shr    $0xc,%edx
  801177:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80117e:	a8 01                	test   $0x1,%al
  801180:	74 12                	je     801194 <fork+0x96>
  801182:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801189:	a8 04                	test   $0x4,%al
  80118b:	74 07                	je     801194 <fork+0x96>
				duppage(envid, PGNUM(va));			
  80118d:	89 f8                	mov    %edi,%eax
  80118f:	e8 e0 fb ff ff       	call   800d74 <duppage>
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
  801194:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80119a:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8011a0:	75 c0                	jne    801162 <fork+0x64>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
				duppage(envid, PGNUM(va));			
			}
		}
	}
	if (sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P) < 0){
  8011a2:	83 ec 04             	sub    $0x4,%esp
  8011a5:	6a 07                	push   $0x7
  8011a7:	68 00 f0 bf ee       	push   $0xeebff000
  8011ac:	56                   	push   %esi
  8011ad:	e8 a5 fa ff ff       	call   800c57 <sys_page_alloc>
  8011b2:	83 c4 10             	add    $0x10,%esp
  8011b5:	85 c0                	test   %eax,%eax
  8011b7:	79 17                	jns    8011d0 <fork+0xd2>
		panic("Se escribio en la pagina de excepciones");
  8011b9:	83 ec 04             	sub    $0x4,%esp
  8011bc:	68 e8 28 80 00       	push   $0x8028e8
  8011c1:	68 c0 00 00 00       	push   $0xc0
  8011c6:	68 e0 27 80 00       	push   $0x8027e0
  8011cb:	e8 60 0e 00 00       	call   802030 <_panic>
	}	
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8011d0:	83 ec 08             	sub    $0x8,%esp
  8011d3:	68 e5 20 80 00       	push   $0x8020e5
  8011d8:	56                   	push   %esi
  8011d9:	e8 2c fb ff ff       	call   800d0a <sys_env_set_pgfault_upcall>

	if (sys_env_set_status(envid, ENV_RUNNABLE) < 0)
  8011de:	83 c4 08             	add    $0x8,%esp
  8011e1:	6a 02                	push   $0x2
  8011e3:	56                   	push   %esi
  8011e4:	e8 db fa ff ff       	call   800cc4 <sys_env_set_status>
  8011e9:	83 c4 10             	add    $0x10,%esp
  8011ec:	85 c0                	test   %eax,%eax
  8011ee:	79 17                	jns    801207 <fork+0x109>
		panic("Status incorrecto de enviroment");
  8011f0:	83 ec 04             	sub    $0x4,%esp
  8011f3:	68 10 29 80 00       	push   $0x802910
  8011f8:	68 c5 00 00 00       	push   $0xc5
  8011fd:	68 e0 27 80 00       	push   $0x8027e0
  801202:	e8 29 0e 00 00       	call   802030 <_panic>

	return envid;
  801207:	89 f0                	mov    %esi,%eax
	
}
  801209:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80120c:	5b                   	pop    %ebx
  80120d:	5e                   	pop    %esi
  80120e:	5f                   	pop    %edi
  80120f:	5d                   	pop    %ebp
  801210:	c3                   	ret    

00801211 <sfork>:


// Challenge!
int
sfork(void)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801217:	68 d0 28 80 00       	push   $0x8028d0
  80121c:	68 d1 00 00 00       	push   $0xd1
  801221:	68 e0 27 80 00       	push   $0x8027e0
  801226:	e8 05 0e 00 00       	call   802030 <_panic>

0080122b <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80122b:	55                   	push   %ebp
  80122c:	89 e5                	mov    %esp,%ebp
  80122e:	56                   	push   %esi
  80122f:	53                   	push   %ebx
  801230:	8b 75 08             	mov    0x8(%ebp),%esi
  801233:	8b 45 0c             	mov    0xc(%ebp),%eax
  801236:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801239:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  80123b:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801240:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801243:	83 ec 0c             	sub    $0xc,%esp
  801246:	50                   	push   %eax
  801247:	e8 06 fb ff ff       	call   800d52 <sys_ipc_recv>
	if (from_env_store)
  80124c:	83 c4 10             	add    $0x10,%esp
  80124f:	85 f6                	test   %esi,%esi
  801251:	74 0b                	je     80125e <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801253:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801259:	8b 52 74             	mov    0x74(%edx),%edx
  80125c:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  80125e:	85 db                	test   %ebx,%ebx
  801260:	74 0b                	je     80126d <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  801262:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801268:	8b 52 78             	mov    0x78(%edx),%edx
  80126b:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  80126d:	85 c0                	test   %eax,%eax
  80126f:	79 16                	jns    801287 <ipc_recv+0x5c>
		if (from_env_store)
  801271:	85 f6                	test   %esi,%esi
  801273:	74 06                	je     80127b <ipc_recv+0x50>
			*from_env_store = 0;
  801275:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  80127b:	85 db                	test   %ebx,%ebx
  80127d:	74 10                	je     80128f <ipc_recv+0x64>
			*perm_store = 0;
  80127f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801285:	eb 08                	jmp    80128f <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  801287:	a1 04 40 80 00       	mov    0x804004,%eax
  80128c:	8b 40 70             	mov    0x70(%eax),%eax
}
  80128f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801292:	5b                   	pop    %ebx
  801293:	5e                   	pop    %esi
  801294:	5d                   	pop    %ebp
  801295:	c3                   	ret    

00801296 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	57                   	push   %edi
  80129a:	56                   	push   %esi
  80129b:	53                   	push   %ebx
  80129c:	83 ec 0c             	sub    $0xc,%esp
  80129f:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012a2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  8012a8:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  8012aa:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8012af:	0f 44 d8             	cmove  %eax,%ebx
  8012b2:	eb 1c                	jmp    8012d0 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  8012b4:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8012b7:	74 12                	je     8012cb <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  8012b9:	50                   	push   %eax
  8012ba:	68 30 29 80 00       	push   $0x802930
  8012bf:	6a 42                	push   $0x42
  8012c1:	68 46 29 80 00       	push   $0x802946
  8012c6:	e8 65 0d 00 00       	call   802030 <_panic>
		sys_yield();
  8012cb:	e8 60 f9 ff ff       	call   800c30 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  8012d0:	ff 75 14             	pushl  0x14(%ebp)
  8012d3:	53                   	push   %ebx
  8012d4:	56                   	push   %esi
  8012d5:	57                   	push   %edi
  8012d6:	e8 52 fa ff ff       	call   800d2d <sys_ipc_try_send>
  8012db:	83 c4 10             	add    $0x10,%esp
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	75 d2                	jne    8012b4 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  8012e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e5:	5b                   	pop    %ebx
  8012e6:	5e                   	pop    %esi
  8012e7:	5f                   	pop    %edi
  8012e8:	5d                   	pop    %ebp
  8012e9:	c3                   	ret    

008012ea <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8012f0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8012f5:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8012f8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8012fe:	8b 52 50             	mov    0x50(%edx),%edx
  801301:	39 ca                	cmp    %ecx,%edx
  801303:	75 0d                	jne    801312 <ipc_find_env+0x28>
			return envs[i].env_id;
  801305:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801308:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80130d:	8b 40 48             	mov    0x48(%eax),%eax
  801310:	eb 0f                	jmp    801321 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801312:	83 c0 01             	add    $0x1,%eax
  801315:	3d 00 04 00 00       	cmp    $0x400,%eax
  80131a:	75 d9                	jne    8012f5 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80131c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801321:	5d                   	pop    %ebp
  801322:	c3                   	ret    

00801323 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801323:	55                   	push   %ebp
  801324:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	05 00 00 00 30       	add    $0x30000000,%eax
  80132e:	c1 e8 0c             	shr    $0xc,%eax
}
  801331:	5d                   	pop    %ebp
  801332:	c3                   	ret    

00801333 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  801336:	ff 75 08             	pushl  0x8(%ebp)
  801339:	e8 e5 ff ff ff       	call   801323 <fd2num>
  80133e:	83 c4 04             	add    $0x4,%esp
  801341:	c1 e0 0c             	shl    $0xc,%eax
  801344:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801349:	c9                   	leave  
  80134a:	c3                   	ret    

0080134b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
  80134e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801351:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801356:	89 c2                	mov    %eax,%edx
  801358:	c1 ea 16             	shr    $0x16,%edx
  80135b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801362:	f6 c2 01             	test   $0x1,%dl
  801365:	74 11                	je     801378 <fd_alloc+0x2d>
  801367:	89 c2                	mov    %eax,%edx
  801369:	c1 ea 0c             	shr    $0xc,%edx
  80136c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801373:	f6 c2 01             	test   $0x1,%dl
  801376:	75 09                	jne    801381 <fd_alloc+0x36>
			*fd_store = fd;
  801378:	89 01                	mov    %eax,(%ecx)
			return 0;
  80137a:	b8 00 00 00 00       	mov    $0x0,%eax
  80137f:	eb 17                	jmp    801398 <fd_alloc+0x4d>
  801381:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801386:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80138b:	75 c9                	jne    801356 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80138d:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801393:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801398:	5d                   	pop    %ebp
  801399:	c3                   	ret    

0080139a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
  80139d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013a0:	83 f8 1f             	cmp    $0x1f,%eax
  8013a3:	77 36                	ja     8013db <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013a5:	c1 e0 0c             	shl    $0xc,%eax
  8013a8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013ad:	89 c2                	mov    %eax,%edx
  8013af:	c1 ea 16             	shr    $0x16,%edx
  8013b2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013b9:	f6 c2 01             	test   $0x1,%dl
  8013bc:	74 24                	je     8013e2 <fd_lookup+0x48>
  8013be:	89 c2                	mov    %eax,%edx
  8013c0:	c1 ea 0c             	shr    $0xc,%edx
  8013c3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013ca:	f6 c2 01             	test   $0x1,%dl
  8013cd:	74 1a                	je     8013e9 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d2:	89 02                	mov    %eax,(%edx)
	return 0;
  8013d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d9:	eb 13                	jmp    8013ee <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8013db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e0:	eb 0c                	jmp    8013ee <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8013e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e7:	eb 05                	jmp    8013ee <fd_lookup+0x54>
  8013e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8013ee:	5d                   	pop    %ebp
  8013ef:	c3                   	ret    

008013f0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
  8013f3:	83 ec 08             	sub    $0x8,%esp
  8013f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013f9:	ba cc 29 80 00       	mov    $0x8029cc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8013fe:	eb 13                	jmp    801413 <dev_lookup+0x23>
  801400:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  801403:	39 08                	cmp    %ecx,(%eax)
  801405:	75 0c                	jne    801413 <dev_lookup+0x23>
			*dev = devtab[i];
  801407:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80140a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80140c:	b8 00 00 00 00       	mov    $0x0,%eax
  801411:	eb 2e                	jmp    801441 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801413:	8b 02                	mov    (%edx),%eax
  801415:	85 c0                	test   %eax,%eax
  801417:	75 e7                	jne    801400 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801419:	a1 04 40 80 00       	mov    0x804004,%eax
  80141e:	8b 40 48             	mov    0x48(%eax),%eax
  801421:	83 ec 04             	sub    $0x4,%esp
  801424:	51                   	push   %ecx
  801425:	50                   	push   %eax
  801426:	68 50 29 80 00       	push   $0x802950
  80142b:	e8 6c ee ff ff       	call   80029c <cprintf>
	*dev = 0;
  801430:	8b 45 0c             	mov    0xc(%ebp),%eax
  801433:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801439:	83 c4 10             	add    $0x10,%esp
  80143c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801441:	c9                   	leave  
  801442:	c3                   	ret    

00801443 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
  801446:	56                   	push   %esi
  801447:	53                   	push   %ebx
  801448:	83 ec 10             	sub    $0x10,%esp
  80144b:	8b 75 08             	mov    0x8(%ebp),%esi
  80144e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801451:	56                   	push   %esi
  801452:	e8 cc fe ff ff       	call   801323 <fd2num>
  801457:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80145a:	89 14 24             	mov    %edx,(%esp)
  80145d:	50                   	push   %eax
  80145e:	e8 37 ff ff ff       	call   80139a <fd_lookup>
  801463:	83 c4 08             	add    $0x8,%esp
  801466:	85 c0                	test   %eax,%eax
  801468:	78 05                	js     80146f <fd_close+0x2c>
	    || fd != fd2)
  80146a:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80146d:	74 0c                	je     80147b <fd_close+0x38>
		return (must_exist ? r : 0);
  80146f:	84 db                	test   %bl,%bl
  801471:	ba 00 00 00 00       	mov    $0x0,%edx
  801476:	0f 44 c2             	cmove  %edx,%eax
  801479:	eb 41                	jmp    8014bc <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80147b:	83 ec 08             	sub    $0x8,%esp
  80147e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801481:	50                   	push   %eax
  801482:	ff 36                	pushl  (%esi)
  801484:	e8 67 ff ff ff       	call   8013f0 <dev_lookup>
  801489:	89 c3                	mov    %eax,%ebx
  80148b:	83 c4 10             	add    $0x10,%esp
  80148e:	85 c0                	test   %eax,%eax
  801490:	78 1a                	js     8014ac <fd_close+0x69>
		if (dev->dev_close)
  801492:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801495:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801498:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80149d:	85 c0                	test   %eax,%eax
  80149f:	74 0b                	je     8014ac <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  8014a1:	83 ec 0c             	sub    $0xc,%esp
  8014a4:	56                   	push   %esi
  8014a5:	ff d0                	call   *%eax
  8014a7:	89 c3                	mov    %eax,%ebx
  8014a9:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8014ac:	83 ec 08             	sub    $0x8,%esp
  8014af:	56                   	push   %esi
  8014b0:	6a 00                	push   $0x0
  8014b2:	e8 ea f7 ff ff       	call   800ca1 <sys_page_unmap>
	return r;
  8014b7:	83 c4 10             	add    $0x10,%esp
  8014ba:	89 d8                	mov    %ebx,%eax
}
  8014bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014bf:	5b                   	pop    %ebx
  8014c0:	5e                   	pop    %esi
  8014c1:	5d                   	pop    %ebp
  8014c2:	c3                   	ret    

008014c3 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014cc:	50                   	push   %eax
  8014cd:	ff 75 08             	pushl  0x8(%ebp)
  8014d0:	e8 c5 fe ff ff       	call   80139a <fd_lookup>
  8014d5:	83 c4 08             	add    $0x8,%esp
  8014d8:	85 c0                	test   %eax,%eax
  8014da:	78 10                	js     8014ec <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8014dc:	83 ec 08             	sub    $0x8,%esp
  8014df:	6a 01                	push   $0x1
  8014e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8014e4:	e8 5a ff ff ff       	call   801443 <fd_close>
  8014e9:	83 c4 10             	add    $0x10,%esp
}
  8014ec:	c9                   	leave  
  8014ed:	c3                   	ret    

008014ee <close_all>:

void
close_all(void)
{
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
  8014f1:	53                   	push   %ebx
  8014f2:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014f5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014fa:	83 ec 0c             	sub    $0xc,%esp
  8014fd:	53                   	push   %ebx
  8014fe:	e8 c0 ff ff ff       	call   8014c3 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801503:	83 c3 01             	add    $0x1,%ebx
  801506:	83 c4 10             	add    $0x10,%esp
  801509:	83 fb 20             	cmp    $0x20,%ebx
  80150c:	75 ec                	jne    8014fa <close_all+0xc>
		close(i);
}
  80150e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801511:	c9                   	leave  
  801512:	c3                   	ret    

00801513 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	57                   	push   %edi
  801517:	56                   	push   %esi
  801518:	53                   	push   %ebx
  801519:	83 ec 2c             	sub    $0x2c,%esp
  80151c:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80151f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801522:	50                   	push   %eax
  801523:	ff 75 08             	pushl  0x8(%ebp)
  801526:	e8 6f fe ff ff       	call   80139a <fd_lookup>
  80152b:	83 c4 08             	add    $0x8,%esp
  80152e:	85 c0                	test   %eax,%eax
  801530:	0f 88 c1 00 00 00    	js     8015f7 <dup+0xe4>
		return r;
	close(newfdnum);
  801536:	83 ec 0c             	sub    $0xc,%esp
  801539:	56                   	push   %esi
  80153a:	e8 84 ff ff ff       	call   8014c3 <close>

	newfd = INDEX2FD(newfdnum);
  80153f:	89 f3                	mov    %esi,%ebx
  801541:	c1 e3 0c             	shl    $0xc,%ebx
  801544:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  80154a:	83 c4 04             	add    $0x4,%esp
  80154d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801550:	e8 de fd ff ff       	call   801333 <fd2data>
  801555:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  801557:	89 1c 24             	mov    %ebx,(%esp)
  80155a:	e8 d4 fd ff ff       	call   801333 <fd2data>
  80155f:	83 c4 10             	add    $0x10,%esp
  801562:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801565:	89 f8                	mov    %edi,%eax
  801567:	c1 e8 16             	shr    $0x16,%eax
  80156a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801571:	a8 01                	test   $0x1,%al
  801573:	74 37                	je     8015ac <dup+0x99>
  801575:	89 f8                	mov    %edi,%eax
  801577:	c1 e8 0c             	shr    $0xc,%eax
  80157a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801581:	f6 c2 01             	test   $0x1,%dl
  801584:	74 26                	je     8015ac <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801586:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80158d:	83 ec 0c             	sub    $0xc,%esp
  801590:	25 07 0e 00 00       	and    $0xe07,%eax
  801595:	50                   	push   %eax
  801596:	ff 75 d4             	pushl  -0x2c(%ebp)
  801599:	6a 00                	push   $0x0
  80159b:	57                   	push   %edi
  80159c:	6a 00                	push   $0x0
  80159e:	e8 d8 f6 ff ff       	call   800c7b <sys_page_map>
  8015a3:	89 c7                	mov    %eax,%edi
  8015a5:	83 c4 20             	add    $0x20,%esp
  8015a8:	85 c0                	test   %eax,%eax
  8015aa:	78 2e                	js     8015da <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015af:	89 d0                	mov    %edx,%eax
  8015b1:	c1 e8 0c             	shr    $0xc,%eax
  8015b4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015bb:	83 ec 0c             	sub    $0xc,%esp
  8015be:	25 07 0e 00 00       	and    $0xe07,%eax
  8015c3:	50                   	push   %eax
  8015c4:	53                   	push   %ebx
  8015c5:	6a 00                	push   $0x0
  8015c7:	52                   	push   %edx
  8015c8:	6a 00                	push   $0x0
  8015ca:	e8 ac f6 ff ff       	call   800c7b <sys_page_map>
  8015cf:	89 c7                	mov    %eax,%edi
  8015d1:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  8015d4:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015d6:	85 ff                	test   %edi,%edi
  8015d8:	79 1d                	jns    8015f7 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8015da:	83 ec 08             	sub    $0x8,%esp
  8015dd:	53                   	push   %ebx
  8015de:	6a 00                	push   $0x0
  8015e0:	e8 bc f6 ff ff       	call   800ca1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015e5:	83 c4 08             	add    $0x8,%esp
  8015e8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8015eb:	6a 00                	push   $0x0
  8015ed:	e8 af f6 ff ff       	call   800ca1 <sys_page_unmap>
	return r;
  8015f2:	83 c4 10             	add    $0x10,%esp
  8015f5:	89 f8                	mov    %edi,%eax
}
  8015f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015fa:	5b                   	pop    %ebx
  8015fb:	5e                   	pop    %esi
  8015fc:	5f                   	pop    %edi
  8015fd:	5d                   	pop    %ebp
  8015fe:	c3                   	ret    

008015ff <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	53                   	push   %ebx
  801603:	83 ec 14             	sub    $0x14,%esp
  801606:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801609:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80160c:	50                   	push   %eax
  80160d:	53                   	push   %ebx
  80160e:	e8 87 fd ff ff       	call   80139a <fd_lookup>
  801613:	83 c4 08             	add    $0x8,%esp
  801616:	89 c2                	mov    %eax,%edx
  801618:	85 c0                	test   %eax,%eax
  80161a:	78 6d                	js     801689 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80161c:	83 ec 08             	sub    $0x8,%esp
  80161f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801622:	50                   	push   %eax
  801623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801626:	ff 30                	pushl  (%eax)
  801628:	e8 c3 fd ff ff       	call   8013f0 <dev_lookup>
  80162d:	83 c4 10             	add    $0x10,%esp
  801630:	85 c0                	test   %eax,%eax
  801632:	78 4c                	js     801680 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801634:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801637:	8b 42 08             	mov    0x8(%edx),%eax
  80163a:	83 e0 03             	and    $0x3,%eax
  80163d:	83 f8 01             	cmp    $0x1,%eax
  801640:	75 21                	jne    801663 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801642:	a1 04 40 80 00       	mov    0x804004,%eax
  801647:	8b 40 48             	mov    0x48(%eax),%eax
  80164a:	83 ec 04             	sub    $0x4,%esp
  80164d:	53                   	push   %ebx
  80164e:	50                   	push   %eax
  80164f:	68 91 29 80 00       	push   $0x802991
  801654:	e8 43 ec ff ff       	call   80029c <cprintf>
		return -E_INVAL;
  801659:	83 c4 10             	add    $0x10,%esp
  80165c:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801661:	eb 26                	jmp    801689 <read+0x8a>
	}
	if (!dev->dev_read)
  801663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801666:	8b 40 08             	mov    0x8(%eax),%eax
  801669:	85 c0                	test   %eax,%eax
  80166b:	74 17                	je     801684 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80166d:	83 ec 04             	sub    $0x4,%esp
  801670:	ff 75 10             	pushl  0x10(%ebp)
  801673:	ff 75 0c             	pushl  0xc(%ebp)
  801676:	52                   	push   %edx
  801677:	ff d0                	call   *%eax
  801679:	89 c2                	mov    %eax,%edx
  80167b:	83 c4 10             	add    $0x10,%esp
  80167e:	eb 09                	jmp    801689 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801680:	89 c2                	mov    %eax,%edx
  801682:	eb 05                	jmp    801689 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801684:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  801689:	89 d0                	mov    %edx,%eax
  80168b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	57                   	push   %edi
  801694:	56                   	push   %esi
  801695:	53                   	push   %ebx
  801696:	83 ec 0c             	sub    $0xc,%esp
  801699:	8b 7d 08             	mov    0x8(%ebp),%edi
  80169c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80169f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016a4:	eb 21                	jmp    8016c7 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016a6:	83 ec 04             	sub    $0x4,%esp
  8016a9:	89 f0                	mov    %esi,%eax
  8016ab:	29 d8                	sub    %ebx,%eax
  8016ad:	50                   	push   %eax
  8016ae:	89 d8                	mov    %ebx,%eax
  8016b0:	03 45 0c             	add    0xc(%ebp),%eax
  8016b3:	50                   	push   %eax
  8016b4:	57                   	push   %edi
  8016b5:	e8 45 ff ff ff       	call   8015ff <read>
		if (m < 0)
  8016ba:	83 c4 10             	add    $0x10,%esp
  8016bd:	85 c0                	test   %eax,%eax
  8016bf:	78 10                	js     8016d1 <readn+0x41>
			return m;
		if (m == 0)
  8016c1:	85 c0                	test   %eax,%eax
  8016c3:	74 0a                	je     8016cf <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016c5:	01 c3                	add    %eax,%ebx
  8016c7:	39 f3                	cmp    %esi,%ebx
  8016c9:	72 db                	jb     8016a6 <readn+0x16>
  8016cb:	89 d8                	mov    %ebx,%eax
  8016cd:	eb 02                	jmp    8016d1 <readn+0x41>
  8016cf:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8016d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016d4:	5b                   	pop    %ebx
  8016d5:	5e                   	pop    %esi
  8016d6:	5f                   	pop    %edi
  8016d7:	5d                   	pop    %ebp
  8016d8:	c3                   	ret    

008016d9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
  8016dc:	53                   	push   %ebx
  8016dd:	83 ec 14             	sub    $0x14,%esp
  8016e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016e6:	50                   	push   %eax
  8016e7:	53                   	push   %ebx
  8016e8:	e8 ad fc ff ff       	call   80139a <fd_lookup>
  8016ed:	83 c4 08             	add    $0x8,%esp
  8016f0:	89 c2                	mov    %eax,%edx
  8016f2:	85 c0                	test   %eax,%eax
  8016f4:	78 68                	js     80175e <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016f6:	83 ec 08             	sub    $0x8,%esp
  8016f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016fc:	50                   	push   %eax
  8016fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801700:	ff 30                	pushl  (%eax)
  801702:	e8 e9 fc ff ff       	call   8013f0 <dev_lookup>
  801707:	83 c4 10             	add    $0x10,%esp
  80170a:	85 c0                	test   %eax,%eax
  80170c:	78 47                	js     801755 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80170e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801711:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801715:	75 21                	jne    801738 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801717:	a1 04 40 80 00       	mov    0x804004,%eax
  80171c:	8b 40 48             	mov    0x48(%eax),%eax
  80171f:	83 ec 04             	sub    $0x4,%esp
  801722:	53                   	push   %ebx
  801723:	50                   	push   %eax
  801724:	68 ad 29 80 00       	push   $0x8029ad
  801729:	e8 6e eb ff ff       	call   80029c <cprintf>
		return -E_INVAL;
  80172e:	83 c4 10             	add    $0x10,%esp
  801731:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801736:	eb 26                	jmp    80175e <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801738:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80173b:	8b 52 0c             	mov    0xc(%edx),%edx
  80173e:	85 d2                	test   %edx,%edx
  801740:	74 17                	je     801759 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801742:	83 ec 04             	sub    $0x4,%esp
  801745:	ff 75 10             	pushl  0x10(%ebp)
  801748:	ff 75 0c             	pushl  0xc(%ebp)
  80174b:	50                   	push   %eax
  80174c:	ff d2                	call   *%edx
  80174e:	89 c2                	mov    %eax,%edx
  801750:	83 c4 10             	add    $0x10,%esp
  801753:	eb 09                	jmp    80175e <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801755:	89 c2                	mov    %eax,%edx
  801757:	eb 05                	jmp    80175e <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801759:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  80175e:	89 d0                	mov    %edx,%eax
  801760:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <seek>:

int
seek(int fdnum, off_t offset)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80176b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80176e:	50                   	push   %eax
  80176f:	ff 75 08             	pushl  0x8(%ebp)
  801772:	e8 23 fc ff ff       	call   80139a <fd_lookup>
  801777:	83 c4 08             	add    $0x8,%esp
  80177a:	85 c0                	test   %eax,%eax
  80177c:	78 0e                	js     80178c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80177e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801781:	8b 55 0c             	mov    0xc(%ebp),%edx
  801784:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801787:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80178c:	c9                   	leave  
  80178d:	c3                   	ret    

0080178e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	53                   	push   %ebx
  801792:	83 ec 14             	sub    $0x14,%esp
  801795:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801798:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80179b:	50                   	push   %eax
  80179c:	53                   	push   %ebx
  80179d:	e8 f8 fb ff ff       	call   80139a <fd_lookup>
  8017a2:	83 c4 08             	add    $0x8,%esp
  8017a5:	89 c2                	mov    %eax,%edx
  8017a7:	85 c0                	test   %eax,%eax
  8017a9:	78 65                	js     801810 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017ab:	83 ec 08             	sub    $0x8,%esp
  8017ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b1:	50                   	push   %eax
  8017b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b5:	ff 30                	pushl  (%eax)
  8017b7:	e8 34 fc ff ff       	call   8013f0 <dev_lookup>
  8017bc:	83 c4 10             	add    $0x10,%esp
  8017bf:	85 c0                	test   %eax,%eax
  8017c1:	78 44                	js     801807 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017ca:	75 21                	jne    8017ed <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8017cc:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017d1:	8b 40 48             	mov    0x48(%eax),%eax
  8017d4:	83 ec 04             	sub    $0x4,%esp
  8017d7:	53                   	push   %ebx
  8017d8:	50                   	push   %eax
  8017d9:	68 70 29 80 00       	push   $0x802970
  8017de:	e8 b9 ea ff ff       	call   80029c <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8017e3:	83 c4 10             	add    $0x10,%esp
  8017e6:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8017eb:	eb 23                	jmp    801810 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  8017ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017f0:	8b 52 18             	mov    0x18(%edx),%edx
  8017f3:	85 d2                	test   %edx,%edx
  8017f5:	74 14                	je     80180b <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017f7:	83 ec 08             	sub    $0x8,%esp
  8017fa:	ff 75 0c             	pushl  0xc(%ebp)
  8017fd:	50                   	push   %eax
  8017fe:	ff d2                	call   *%edx
  801800:	89 c2                	mov    %eax,%edx
  801802:	83 c4 10             	add    $0x10,%esp
  801805:	eb 09                	jmp    801810 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801807:	89 c2                	mov    %eax,%edx
  801809:	eb 05                	jmp    801810 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80180b:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  801810:	89 d0                	mov    %edx,%eax
  801812:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	53                   	push   %ebx
  80181b:	83 ec 14             	sub    $0x14,%esp
  80181e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801821:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801824:	50                   	push   %eax
  801825:	ff 75 08             	pushl  0x8(%ebp)
  801828:	e8 6d fb ff ff       	call   80139a <fd_lookup>
  80182d:	83 c4 08             	add    $0x8,%esp
  801830:	89 c2                	mov    %eax,%edx
  801832:	85 c0                	test   %eax,%eax
  801834:	78 58                	js     80188e <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801836:	83 ec 08             	sub    $0x8,%esp
  801839:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80183c:	50                   	push   %eax
  80183d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801840:	ff 30                	pushl  (%eax)
  801842:	e8 a9 fb ff ff       	call   8013f0 <dev_lookup>
  801847:	83 c4 10             	add    $0x10,%esp
  80184a:	85 c0                	test   %eax,%eax
  80184c:	78 37                	js     801885 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  80184e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801851:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801855:	74 32                	je     801889 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801857:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80185a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801861:	00 00 00 
	stat->st_isdir = 0;
  801864:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80186b:	00 00 00 
	stat->st_dev = dev;
  80186e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801874:	83 ec 08             	sub    $0x8,%esp
  801877:	53                   	push   %ebx
  801878:	ff 75 f0             	pushl  -0x10(%ebp)
  80187b:	ff 50 14             	call   *0x14(%eax)
  80187e:	89 c2                	mov    %eax,%edx
  801880:	83 c4 10             	add    $0x10,%esp
  801883:	eb 09                	jmp    80188e <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801885:	89 c2                	mov    %eax,%edx
  801887:	eb 05                	jmp    80188e <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801889:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80188e:	89 d0                	mov    %edx,%eax
  801890:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	56                   	push   %esi
  801899:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80189a:	83 ec 08             	sub    $0x8,%esp
  80189d:	6a 00                	push   $0x0
  80189f:	ff 75 08             	pushl  0x8(%ebp)
  8018a2:	e8 06 02 00 00       	call   801aad <open>
  8018a7:	89 c3                	mov    %eax,%ebx
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	78 1b                	js     8018cb <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8018b0:	83 ec 08             	sub    $0x8,%esp
  8018b3:	ff 75 0c             	pushl  0xc(%ebp)
  8018b6:	50                   	push   %eax
  8018b7:	e8 5b ff ff ff       	call   801817 <fstat>
  8018bc:	89 c6                	mov    %eax,%esi
	close(fd);
  8018be:	89 1c 24             	mov    %ebx,(%esp)
  8018c1:	e8 fd fb ff ff       	call   8014c3 <close>
	return r;
  8018c6:	83 c4 10             	add    $0x10,%esp
  8018c9:	89 f0                	mov    %esi,%eax
}
  8018cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ce:	5b                   	pop    %ebx
  8018cf:	5e                   	pop    %esi
  8018d0:	5d                   	pop    %ebp
  8018d1:	c3                   	ret    

008018d2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	56                   	push   %esi
  8018d6:	53                   	push   %ebx
  8018d7:	89 c6                	mov    %eax,%esi
  8018d9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018db:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8018e2:	75 12                	jne    8018f6 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018e4:	83 ec 0c             	sub    $0xc,%esp
  8018e7:	6a 01                	push   $0x1
  8018e9:	e8 fc f9 ff ff       	call   8012ea <ipc_find_env>
  8018ee:	a3 00 40 80 00       	mov    %eax,0x804000
  8018f3:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018f6:	6a 07                	push   $0x7
  8018f8:	68 00 50 80 00       	push   $0x805000
  8018fd:	56                   	push   %esi
  8018fe:	ff 35 00 40 80 00    	pushl  0x804000
  801904:	e8 8d f9 ff ff       	call   801296 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801909:	83 c4 0c             	add    $0xc,%esp
  80190c:	6a 00                	push   $0x0
  80190e:	53                   	push   %ebx
  80190f:	6a 00                	push   $0x0
  801911:	e8 15 f9 ff ff       	call   80122b <ipc_recv>
}
  801916:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801919:	5b                   	pop    %ebx
  80191a:	5e                   	pop    %esi
  80191b:	5d                   	pop    %ebp
  80191c:	c3                   	ret    

0080191d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801923:	8b 45 08             	mov    0x8(%ebp),%eax
  801926:	8b 40 0c             	mov    0xc(%eax),%eax
  801929:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80192e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801931:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801936:	ba 00 00 00 00       	mov    $0x0,%edx
  80193b:	b8 02 00 00 00       	mov    $0x2,%eax
  801940:	e8 8d ff ff ff       	call   8018d2 <fsipc>
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	8b 40 0c             	mov    0xc(%eax),%eax
  801953:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801958:	ba 00 00 00 00       	mov    $0x0,%edx
  80195d:	b8 06 00 00 00       	mov    $0x6,%eax
  801962:	e8 6b ff ff ff       	call   8018d2 <fsipc>
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	53                   	push   %ebx
  80196d:	83 ec 04             	sub    $0x4,%esp
  801970:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801973:	8b 45 08             	mov    0x8(%ebp),%eax
  801976:	8b 40 0c             	mov    0xc(%eax),%eax
  801979:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80197e:	ba 00 00 00 00       	mov    $0x0,%edx
  801983:	b8 05 00 00 00       	mov    $0x5,%eax
  801988:	e8 45 ff ff ff       	call   8018d2 <fsipc>
  80198d:	85 c0                	test   %eax,%eax
  80198f:	78 2c                	js     8019bd <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801991:	83 ec 08             	sub    $0x8,%esp
  801994:	68 00 50 80 00       	push   $0x805000
  801999:	53                   	push   %ebx
  80199a:	e8 6f ee ff ff       	call   80080e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80199f:	a1 80 50 80 00       	mov    0x805080,%eax
  8019a4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019aa:	a1 84 50 80 00       	mov    0x805084,%eax
  8019af:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019b5:	83 c4 10             	add    $0x10,%esp
  8019b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
  8019c5:	83 ec 08             	sub    $0x8,%esp
  8019c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cb:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019d1:	8b 49 0c             	mov    0xc(%ecx),%ecx
  8019d4:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  8019da:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8019df:	76 22                	jbe    801a03 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  8019e1:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  8019e8:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  8019eb:	83 ec 04             	sub    $0x4,%esp
  8019ee:	68 f8 0f 00 00       	push   $0xff8
  8019f3:	52                   	push   %edx
  8019f4:	68 08 50 80 00       	push   $0x805008
  8019f9:	e8 a3 ef ff ff       	call   8009a1 <memmove>
  8019fe:	83 c4 10             	add    $0x10,%esp
  801a01:	eb 17                	jmp    801a1a <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  801a03:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  801a08:	83 ec 04             	sub    $0x4,%esp
  801a0b:	50                   	push   %eax
  801a0c:	52                   	push   %edx
  801a0d:	68 08 50 80 00       	push   $0x805008
  801a12:	e8 8a ef ff ff       	call   8009a1 <memmove>
  801a17:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  801a1a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1f:	b8 04 00 00 00       	mov    $0x4,%eax
  801a24:	e8 a9 fe ff ff       	call   8018d2 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
  801a2e:	56                   	push   %esi
  801a2f:	53                   	push   %ebx
  801a30:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a33:	8b 45 08             	mov    0x8(%ebp),%eax
  801a36:	8b 40 0c             	mov    0xc(%eax),%eax
  801a39:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a3e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a44:	ba 00 00 00 00       	mov    $0x0,%edx
  801a49:	b8 03 00 00 00       	mov    $0x3,%eax
  801a4e:	e8 7f fe ff ff       	call   8018d2 <fsipc>
  801a53:	89 c3                	mov    %eax,%ebx
  801a55:	85 c0                	test   %eax,%eax
  801a57:	78 4b                	js     801aa4 <devfile_read+0x79>
		return r;
	assert(r <= n);
  801a59:	39 c6                	cmp    %eax,%esi
  801a5b:	73 16                	jae    801a73 <devfile_read+0x48>
  801a5d:	68 dc 29 80 00       	push   $0x8029dc
  801a62:	68 e3 29 80 00       	push   $0x8029e3
  801a67:	6a 7c                	push   $0x7c
  801a69:	68 f8 29 80 00       	push   $0x8029f8
  801a6e:	e8 bd 05 00 00       	call   802030 <_panic>
	assert(r <= PGSIZE);
  801a73:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a78:	7e 16                	jle    801a90 <devfile_read+0x65>
  801a7a:	68 03 2a 80 00       	push   $0x802a03
  801a7f:	68 e3 29 80 00       	push   $0x8029e3
  801a84:	6a 7d                	push   $0x7d
  801a86:	68 f8 29 80 00       	push   $0x8029f8
  801a8b:	e8 a0 05 00 00       	call   802030 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a90:	83 ec 04             	sub    $0x4,%esp
  801a93:	50                   	push   %eax
  801a94:	68 00 50 80 00       	push   $0x805000
  801a99:	ff 75 0c             	pushl  0xc(%ebp)
  801a9c:	e8 00 ef ff ff       	call   8009a1 <memmove>
	return r;
  801aa1:	83 c4 10             	add    $0x10,%esp
}
  801aa4:	89 d8                	mov    %ebx,%eax
  801aa6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aa9:	5b                   	pop    %ebx
  801aaa:	5e                   	pop    %esi
  801aab:	5d                   	pop    %ebp
  801aac:	c3                   	ret    

00801aad <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
  801ab0:	53                   	push   %ebx
  801ab1:	83 ec 20             	sub    $0x20,%esp
  801ab4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801ab7:	53                   	push   %ebx
  801ab8:	e8 18 ed ff ff       	call   8007d5 <strlen>
  801abd:	83 c4 10             	add    $0x10,%esp
  801ac0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ac5:	7f 67                	jg     801b2e <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801ac7:	83 ec 0c             	sub    $0xc,%esp
  801aca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801acd:	50                   	push   %eax
  801ace:	e8 78 f8 ff ff       	call   80134b <fd_alloc>
  801ad3:	83 c4 10             	add    $0x10,%esp
		return r;
  801ad6:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801ad8:	85 c0                	test   %eax,%eax
  801ada:	78 57                	js     801b33 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801adc:	83 ec 08             	sub    $0x8,%esp
  801adf:	53                   	push   %ebx
  801ae0:	68 00 50 80 00       	push   $0x805000
  801ae5:	e8 24 ed ff ff       	call   80080e <strcpy>
	fsipcbuf.open.req_omode = mode;
  801aea:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aed:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801af2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801af5:	b8 01 00 00 00       	mov    $0x1,%eax
  801afa:	e8 d3 fd ff ff       	call   8018d2 <fsipc>
  801aff:	89 c3                	mov    %eax,%ebx
  801b01:	83 c4 10             	add    $0x10,%esp
  801b04:	85 c0                	test   %eax,%eax
  801b06:	79 14                	jns    801b1c <open+0x6f>
		fd_close(fd, 0);
  801b08:	83 ec 08             	sub    $0x8,%esp
  801b0b:	6a 00                	push   $0x0
  801b0d:	ff 75 f4             	pushl  -0xc(%ebp)
  801b10:	e8 2e f9 ff ff       	call   801443 <fd_close>
		return r;
  801b15:	83 c4 10             	add    $0x10,%esp
  801b18:	89 da                	mov    %ebx,%edx
  801b1a:	eb 17                	jmp    801b33 <open+0x86>
	}

	return fd2num(fd);
  801b1c:	83 ec 0c             	sub    $0xc,%esp
  801b1f:	ff 75 f4             	pushl  -0xc(%ebp)
  801b22:	e8 fc f7 ff ff       	call   801323 <fd2num>
  801b27:	89 c2                	mov    %eax,%edx
  801b29:	83 c4 10             	add    $0x10,%esp
  801b2c:	eb 05                	jmp    801b33 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801b2e:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801b33:	89 d0                	mov    %edx,%eax
  801b35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b40:	ba 00 00 00 00       	mov    $0x0,%edx
  801b45:	b8 08 00 00 00       	mov    $0x8,%eax
  801b4a:	e8 83 fd ff ff       	call   8018d2 <fsipc>
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
  801b54:	56                   	push   %esi
  801b55:	53                   	push   %ebx
  801b56:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b59:	83 ec 0c             	sub    $0xc,%esp
  801b5c:	ff 75 08             	pushl  0x8(%ebp)
  801b5f:	e8 cf f7 ff ff       	call   801333 <fd2data>
  801b64:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b66:	83 c4 08             	add    $0x8,%esp
  801b69:	68 0f 2a 80 00       	push   $0x802a0f
  801b6e:	53                   	push   %ebx
  801b6f:	e8 9a ec ff ff       	call   80080e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b74:	8b 46 04             	mov    0x4(%esi),%eax
  801b77:	2b 06                	sub    (%esi),%eax
  801b79:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b7f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b86:	00 00 00 
	stat->st_dev = &devpipe;
  801b89:	c7 83 88 00 00 00 28 	movl   $0x803028,0x88(%ebx)
  801b90:	30 80 00 
	return 0;
}
  801b93:	b8 00 00 00 00       	mov    $0x0,%eax
  801b98:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b9b:	5b                   	pop    %ebx
  801b9c:	5e                   	pop    %esi
  801b9d:	5d                   	pop    %ebp
  801b9e:	c3                   	ret    

00801b9f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
  801ba2:	53                   	push   %ebx
  801ba3:	83 ec 0c             	sub    $0xc,%esp
  801ba6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ba9:	53                   	push   %ebx
  801baa:	6a 00                	push   $0x0
  801bac:	e8 f0 f0 ff ff       	call   800ca1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bb1:	89 1c 24             	mov    %ebx,(%esp)
  801bb4:	e8 7a f7 ff ff       	call   801333 <fd2data>
  801bb9:	83 c4 08             	add    $0x8,%esp
  801bbc:	50                   	push   %eax
  801bbd:	6a 00                	push   $0x0
  801bbf:	e8 dd f0 ff ff       	call   800ca1 <sys_page_unmap>
}
  801bc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	57                   	push   %edi
  801bcd:	56                   	push   %esi
  801bce:	53                   	push   %ebx
  801bcf:	83 ec 1c             	sub    $0x1c,%esp
  801bd2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801bd5:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801bd7:	a1 04 40 80 00       	mov    0x804004,%eax
  801bdc:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801bdf:	83 ec 0c             	sub    $0xc,%esp
  801be2:	ff 75 e0             	pushl  -0x20(%ebp)
  801be5:	e8 1f 05 00 00       	call   802109 <pageref>
  801bea:	89 c3                	mov    %eax,%ebx
  801bec:	89 3c 24             	mov    %edi,(%esp)
  801bef:	e8 15 05 00 00       	call   802109 <pageref>
  801bf4:	83 c4 10             	add    $0x10,%esp
  801bf7:	39 c3                	cmp    %eax,%ebx
  801bf9:	0f 94 c1             	sete   %cl
  801bfc:	0f b6 c9             	movzbl %cl,%ecx
  801bff:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801c02:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c08:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c0b:	39 ce                	cmp    %ecx,%esi
  801c0d:	74 1b                	je     801c2a <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801c0f:	39 c3                	cmp    %eax,%ebx
  801c11:	75 c4                	jne    801bd7 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c13:	8b 42 58             	mov    0x58(%edx),%eax
  801c16:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c19:	50                   	push   %eax
  801c1a:	56                   	push   %esi
  801c1b:	68 16 2a 80 00       	push   $0x802a16
  801c20:	e8 77 e6 ff ff       	call   80029c <cprintf>
  801c25:	83 c4 10             	add    $0x10,%esp
  801c28:	eb ad                	jmp    801bd7 <_pipeisclosed+0xe>
	}
}
  801c2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c30:	5b                   	pop    %ebx
  801c31:	5e                   	pop    %esi
  801c32:	5f                   	pop    %edi
  801c33:	5d                   	pop    %ebp
  801c34:	c3                   	ret    

00801c35 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	57                   	push   %edi
  801c39:	56                   	push   %esi
  801c3a:	53                   	push   %ebx
  801c3b:	83 ec 28             	sub    $0x28,%esp
  801c3e:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801c41:	56                   	push   %esi
  801c42:	e8 ec f6 ff ff       	call   801333 <fd2data>
  801c47:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c49:	83 c4 10             	add    $0x10,%esp
  801c4c:	bf 00 00 00 00       	mov    $0x0,%edi
  801c51:	eb 4b                	jmp    801c9e <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801c53:	89 da                	mov    %ebx,%edx
  801c55:	89 f0                	mov    %esi,%eax
  801c57:	e8 6d ff ff ff       	call   801bc9 <_pipeisclosed>
  801c5c:	85 c0                	test   %eax,%eax
  801c5e:	75 48                	jne    801ca8 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801c60:	e8 cb ef ff ff       	call   800c30 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c65:	8b 43 04             	mov    0x4(%ebx),%eax
  801c68:	8b 0b                	mov    (%ebx),%ecx
  801c6a:	8d 51 20             	lea    0x20(%ecx),%edx
  801c6d:	39 d0                	cmp    %edx,%eax
  801c6f:	73 e2                	jae    801c53 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c74:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c78:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c7b:	89 c2                	mov    %eax,%edx
  801c7d:	c1 fa 1f             	sar    $0x1f,%edx
  801c80:	89 d1                	mov    %edx,%ecx
  801c82:	c1 e9 1b             	shr    $0x1b,%ecx
  801c85:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c88:	83 e2 1f             	and    $0x1f,%edx
  801c8b:	29 ca                	sub    %ecx,%edx
  801c8d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c91:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c95:	83 c0 01             	add    $0x1,%eax
  801c98:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c9b:	83 c7 01             	add    $0x1,%edi
  801c9e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ca1:	75 c2                	jne    801c65 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801ca3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca6:	eb 05                	jmp    801cad <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801ca8:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801cad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cb0:	5b                   	pop    %ebx
  801cb1:	5e                   	pop    %esi
  801cb2:	5f                   	pop    %edi
  801cb3:	5d                   	pop    %ebp
  801cb4:	c3                   	ret    

00801cb5 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	57                   	push   %edi
  801cb9:	56                   	push   %esi
  801cba:	53                   	push   %ebx
  801cbb:	83 ec 18             	sub    $0x18,%esp
  801cbe:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801cc1:	57                   	push   %edi
  801cc2:	e8 6c f6 ff ff       	call   801333 <fd2data>
  801cc7:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801cc9:	83 c4 10             	add    $0x10,%esp
  801ccc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cd1:	eb 3d                	jmp    801d10 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801cd3:	85 db                	test   %ebx,%ebx
  801cd5:	74 04                	je     801cdb <devpipe_read+0x26>
				return i;
  801cd7:	89 d8                	mov    %ebx,%eax
  801cd9:	eb 44                	jmp    801d1f <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801cdb:	89 f2                	mov    %esi,%edx
  801cdd:	89 f8                	mov    %edi,%eax
  801cdf:	e8 e5 fe ff ff       	call   801bc9 <_pipeisclosed>
  801ce4:	85 c0                	test   %eax,%eax
  801ce6:	75 32                	jne    801d1a <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801ce8:	e8 43 ef ff ff       	call   800c30 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801ced:	8b 06                	mov    (%esi),%eax
  801cef:	3b 46 04             	cmp    0x4(%esi),%eax
  801cf2:	74 df                	je     801cd3 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cf4:	99                   	cltd   
  801cf5:	c1 ea 1b             	shr    $0x1b,%edx
  801cf8:	01 d0                	add    %edx,%eax
  801cfa:	83 e0 1f             	and    $0x1f,%eax
  801cfd:	29 d0                	sub    %edx,%eax
  801cff:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801d04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d07:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801d0a:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d0d:	83 c3 01             	add    $0x1,%ebx
  801d10:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801d13:	75 d8                	jne    801ced <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801d15:	8b 45 10             	mov    0x10(%ebp),%eax
  801d18:	eb 05                	jmp    801d1f <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801d1a:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801d1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d22:	5b                   	pop    %ebx
  801d23:	5e                   	pop    %esi
  801d24:	5f                   	pop    %edi
  801d25:	5d                   	pop    %ebp
  801d26:	c3                   	ret    

00801d27 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
  801d2a:	56                   	push   %esi
  801d2b:	53                   	push   %ebx
  801d2c:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801d2f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d32:	50                   	push   %eax
  801d33:	e8 13 f6 ff ff       	call   80134b <fd_alloc>
  801d38:	83 c4 10             	add    $0x10,%esp
  801d3b:	89 c2                	mov    %eax,%edx
  801d3d:	85 c0                	test   %eax,%eax
  801d3f:	0f 88 2c 01 00 00    	js     801e71 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d45:	83 ec 04             	sub    $0x4,%esp
  801d48:	68 07 04 00 00       	push   $0x407
  801d4d:	ff 75 f4             	pushl  -0xc(%ebp)
  801d50:	6a 00                	push   $0x0
  801d52:	e8 00 ef ff ff       	call   800c57 <sys_page_alloc>
  801d57:	83 c4 10             	add    $0x10,%esp
  801d5a:	89 c2                	mov    %eax,%edx
  801d5c:	85 c0                	test   %eax,%eax
  801d5e:	0f 88 0d 01 00 00    	js     801e71 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801d64:	83 ec 0c             	sub    $0xc,%esp
  801d67:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d6a:	50                   	push   %eax
  801d6b:	e8 db f5 ff ff       	call   80134b <fd_alloc>
  801d70:	89 c3                	mov    %eax,%ebx
  801d72:	83 c4 10             	add    $0x10,%esp
  801d75:	85 c0                	test   %eax,%eax
  801d77:	0f 88 e2 00 00 00    	js     801e5f <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d7d:	83 ec 04             	sub    $0x4,%esp
  801d80:	68 07 04 00 00       	push   $0x407
  801d85:	ff 75 f0             	pushl  -0x10(%ebp)
  801d88:	6a 00                	push   $0x0
  801d8a:	e8 c8 ee ff ff       	call   800c57 <sys_page_alloc>
  801d8f:	89 c3                	mov    %eax,%ebx
  801d91:	83 c4 10             	add    $0x10,%esp
  801d94:	85 c0                	test   %eax,%eax
  801d96:	0f 88 c3 00 00 00    	js     801e5f <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801d9c:	83 ec 0c             	sub    $0xc,%esp
  801d9f:	ff 75 f4             	pushl  -0xc(%ebp)
  801da2:	e8 8c f5 ff ff       	call   801333 <fd2data>
  801da7:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801da9:	83 c4 0c             	add    $0xc,%esp
  801dac:	68 07 04 00 00       	push   $0x407
  801db1:	50                   	push   %eax
  801db2:	6a 00                	push   $0x0
  801db4:	e8 9e ee ff ff       	call   800c57 <sys_page_alloc>
  801db9:	89 c3                	mov    %eax,%ebx
  801dbb:	83 c4 10             	add    $0x10,%esp
  801dbe:	85 c0                	test   %eax,%eax
  801dc0:	0f 88 89 00 00 00    	js     801e4f <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dc6:	83 ec 0c             	sub    $0xc,%esp
  801dc9:	ff 75 f0             	pushl  -0x10(%ebp)
  801dcc:	e8 62 f5 ff ff       	call   801333 <fd2data>
  801dd1:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801dd8:	50                   	push   %eax
  801dd9:	6a 00                	push   $0x0
  801ddb:	56                   	push   %esi
  801ddc:	6a 00                	push   $0x0
  801dde:	e8 98 ee ff ff       	call   800c7b <sys_page_map>
  801de3:	89 c3                	mov    %eax,%ebx
  801de5:	83 c4 20             	add    $0x20,%esp
  801de8:	85 c0                	test   %eax,%eax
  801dea:	78 55                	js     801e41 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801dec:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df5:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801e01:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0a:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801e0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801e16:	83 ec 0c             	sub    $0xc,%esp
  801e19:	ff 75 f4             	pushl  -0xc(%ebp)
  801e1c:	e8 02 f5 ff ff       	call   801323 <fd2num>
  801e21:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e24:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e26:	83 c4 04             	add    $0x4,%esp
  801e29:	ff 75 f0             	pushl  -0x10(%ebp)
  801e2c:	e8 f2 f4 ff ff       	call   801323 <fd2num>
  801e31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e34:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e37:	83 c4 10             	add    $0x10,%esp
  801e3a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e3f:	eb 30                	jmp    801e71 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801e41:	83 ec 08             	sub    $0x8,%esp
  801e44:	56                   	push   %esi
  801e45:	6a 00                	push   $0x0
  801e47:	e8 55 ee ff ff       	call   800ca1 <sys_page_unmap>
  801e4c:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801e4f:	83 ec 08             	sub    $0x8,%esp
  801e52:	ff 75 f0             	pushl  -0x10(%ebp)
  801e55:	6a 00                	push   $0x0
  801e57:	e8 45 ee ff ff       	call   800ca1 <sys_page_unmap>
  801e5c:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801e5f:	83 ec 08             	sub    $0x8,%esp
  801e62:	ff 75 f4             	pushl  -0xc(%ebp)
  801e65:	6a 00                	push   $0x0
  801e67:	e8 35 ee ff ff       	call   800ca1 <sys_page_unmap>
  801e6c:	83 c4 10             	add    $0x10,%esp
  801e6f:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  801e71:	89 d0                	mov    %edx,%eax
  801e73:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e76:	5b                   	pop    %ebx
  801e77:	5e                   	pop    %esi
  801e78:	5d                   	pop    %ebp
  801e79:	c3                   	ret    

00801e7a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
  801e7d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e80:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e83:	50                   	push   %eax
  801e84:	ff 75 08             	pushl  0x8(%ebp)
  801e87:	e8 0e f5 ff ff       	call   80139a <fd_lookup>
  801e8c:	83 c4 10             	add    $0x10,%esp
  801e8f:	85 c0                	test   %eax,%eax
  801e91:	78 18                	js     801eab <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801e93:	83 ec 0c             	sub    $0xc,%esp
  801e96:	ff 75 f4             	pushl  -0xc(%ebp)
  801e99:	e8 95 f4 ff ff       	call   801333 <fd2data>
	return _pipeisclosed(fd, p);
  801e9e:	89 c2                	mov    %eax,%edx
  801ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea3:	e8 21 fd ff ff       	call   801bc9 <_pipeisclosed>
  801ea8:	83 c4 10             	add    $0x10,%esp
}
  801eab:	c9                   	leave  
  801eac:	c3                   	ret    

00801ead <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801eb0:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb5:	5d                   	pop    %ebp
  801eb6:	c3                   	ret    

00801eb7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
  801eba:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ebd:	68 2e 2a 80 00       	push   $0x802a2e
  801ec2:	ff 75 0c             	pushl  0xc(%ebp)
  801ec5:	e8 44 e9 ff ff       	call   80080e <strcpy>
	return 0;
}
  801eca:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	57                   	push   %edi
  801ed5:	56                   	push   %esi
  801ed6:	53                   	push   %ebx
  801ed7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801edd:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801ee2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801ee8:	eb 2d                	jmp    801f17 <devcons_write+0x46>
		m = n - tot;
  801eea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801eed:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801eef:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801ef2:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801ef7:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801efa:	83 ec 04             	sub    $0x4,%esp
  801efd:	53                   	push   %ebx
  801efe:	03 45 0c             	add    0xc(%ebp),%eax
  801f01:	50                   	push   %eax
  801f02:	57                   	push   %edi
  801f03:	e8 99 ea ff ff       	call   8009a1 <memmove>
		sys_cputs(buf, m);
  801f08:	83 c4 08             	add    $0x8,%esp
  801f0b:	53                   	push   %ebx
  801f0c:	57                   	push   %edi
  801f0d:	e8 8e ec ff ff       	call   800ba0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801f12:	01 de                	add    %ebx,%esi
  801f14:	83 c4 10             	add    $0x10,%esp
  801f17:	89 f0                	mov    %esi,%eax
  801f19:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f1c:	72 cc                	jb     801eea <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f21:	5b                   	pop    %ebx
  801f22:	5e                   	pop    %esi
  801f23:	5f                   	pop    %edi
  801f24:	5d                   	pop    %ebp
  801f25:	c3                   	ret    

00801f26 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	83 ec 08             	sub    $0x8,%esp
  801f2c:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801f31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f35:	74 2a                	je     801f61 <devcons_read+0x3b>
  801f37:	eb 05                	jmp    801f3e <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801f39:	e8 f2 ec ff ff       	call   800c30 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801f3e:	e8 83 ec ff ff       	call   800bc6 <sys_cgetc>
  801f43:	85 c0                	test   %eax,%eax
  801f45:	74 f2                	je     801f39 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801f47:	85 c0                	test   %eax,%eax
  801f49:	78 16                	js     801f61 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801f4b:	83 f8 04             	cmp    $0x4,%eax
  801f4e:	74 0c                	je     801f5c <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801f50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f53:	88 02                	mov    %al,(%edx)
	return 1;
  801f55:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5a:	eb 05                	jmp    801f61 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801f5c:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
  801f66:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f69:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6c:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801f6f:	6a 01                	push   $0x1
  801f71:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f74:	50                   	push   %eax
  801f75:	e8 26 ec ff ff       	call   800ba0 <sys_cputs>
}
  801f7a:	83 c4 10             	add    $0x10,%esp
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <getchar>:

int
getchar(void)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801f85:	6a 01                	push   $0x1
  801f87:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f8a:	50                   	push   %eax
  801f8b:	6a 00                	push   $0x0
  801f8d:	e8 6d f6 ff ff       	call   8015ff <read>
	if (r < 0)
  801f92:	83 c4 10             	add    $0x10,%esp
  801f95:	85 c0                	test   %eax,%eax
  801f97:	78 0f                	js     801fa8 <getchar+0x29>
		return r;
	if (r < 1)
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	7e 06                	jle    801fa3 <getchar+0x24>
		return -E_EOF;
	return c;
  801f9d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801fa1:	eb 05                	jmp    801fa8 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801fa3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    

00801faa <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
  801fad:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fb0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fb3:	50                   	push   %eax
  801fb4:	ff 75 08             	pushl  0x8(%ebp)
  801fb7:	e8 de f3 ff ff       	call   80139a <fd_lookup>
  801fbc:	83 c4 10             	add    $0x10,%esp
  801fbf:	85 c0                	test   %eax,%eax
  801fc1:	78 11                	js     801fd4 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc6:	8b 15 44 30 80 00    	mov    0x803044,%edx
  801fcc:	39 10                	cmp    %edx,(%eax)
  801fce:	0f 94 c0             	sete   %al
  801fd1:	0f b6 c0             	movzbl %al,%eax
}
  801fd4:	c9                   	leave  
  801fd5:	c3                   	ret    

00801fd6 <opencons>:

int
opencons(void)
{
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
  801fd9:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801fdc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fdf:	50                   	push   %eax
  801fe0:	e8 66 f3 ff ff       	call   80134b <fd_alloc>
  801fe5:	83 c4 10             	add    $0x10,%esp
		return r;
  801fe8:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801fea:	85 c0                	test   %eax,%eax
  801fec:	78 3e                	js     80202c <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fee:	83 ec 04             	sub    $0x4,%esp
  801ff1:	68 07 04 00 00       	push   $0x407
  801ff6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff9:	6a 00                	push   $0x0
  801ffb:	e8 57 ec ff ff       	call   800c57 <sys_page_alloc>
  802000:	83 c4 10             	add    $0x10,%esp
		return r;
  802003:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802005:	85 c0                	test   %eax,%eax
  802007:	78 23                	js     80202c <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802009:	8b 15 44 30 80 00    	mov    0x803044,%edx
  80200f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802012:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802017:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80201e:	83 ec 0c             	sub    $0xc,%esp
  802021:	50                   	push   %eax
  802022:	e8 fc f2 ff ff       	call   801323 <fd2num>
  802027:	89 c2                	mov    %eax,%edx
  802029:	83 c4 10             	add    $0x10,%esp
}
  80202c:	89 d0                	mov    %edx,%eax
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	56                   	push   %esi
  802034:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  802035:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802038:	8b 35 08 30 80 00    	mov    0x803008,%esi
  80203e:	e8 c9 eb ff ff       	call   800c0c <sys_getenvid>
  802043:	83 ec 0c             	sub    $0xc,%esp
  802046:	ff 75 0c             	pushl  0xc(%ebp)
  802049:	ff 75 08             	pushl  0x8(%ebp)
  80204c:	56                   	push   %esi
  80204d:	50                   	push   %eax
  80204e:	68 3c 2a 80 00       	push   $0x802a3c
  802053:	e8 44 e2 ff ff       	call   80029c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802058:	83 c4 18             	add    $0x18,%esp
  80205b:	53                   	push   %ebx
  80205c:	ff 75 10             	pushl  0x10(%ebp)
  80205f:	e8 e7 e1 ff ff       	call   80024b <vcprintf>
	cprintf("\n");
  802064:	c7 04 24 27 2a 80 00 	movl   $0x802a27,(%esp)
  80206b:	e8 2c e2 ff ff       	call   80029c <cprintf>
  802070:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802073:	cc                   	int3   
  802074:	eb fd                	jmp    802073 <_panic+0x43>

00802076 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
  802079:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80207c:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802083:	75 2c                	jne    8020b1 <set_pgfault_handler+0x3b>
		// First time through!
		// LAB 4: Your code here.
		r = sys_page_alloc(0,(void *)(UXSTACKTOP - PGSIZE),PTE_P | PTE_U | PTE_W);
  802085:	83 ec 04             	sub    $0x4,%esp
  802088:	6a 07                	push   $0x7
  80208a:	68 00 f0 bf ee       	push   $0xeebff000
  80208f:	6a 00                	push   $0x0
  802091:	e8 c1 eb ff ff       	call   800c57 <sys_page_alloc>
		if(r < 0)
  802096:	83 c4 10             	add    $0x10,%esp
  802099:	85 c0                	test   %eax,%eax
  80209b:	79 14                	jns    8020b1 <set_pgfault_handler+0x3b>
			panic("set_pgfault_handler: error in sys_page_alloc\n");	
  80209d:	83 ec 04             	sub    $0x4,%esp
  8020a0:	68 60 2a 80 00       	push   $0x802a60
  8020a5:	6a 22                	push   $0x22
  8020a7:	68 cc 2a 80 00       	push   $0x802acc
  8020ac:	e8 7f ff ff ff       	call   802030 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	a3 00 60 80 00       	mov    %eax,0x806000
	r = sys_env_set_pgfault_upcall(0, _pgfault_upcall); 
  8020b9:	83 ec 08             	sub    $0x8,%esp
  8020bc:	68 e5 20 80 00       	push   $0x8020e5
  8020c1:	6a 00                	push   $0x0
  8020c3:	e8 42 ec ff ff       	call   800d0a <sys_env_set_pgfault_upcall>
	if (r < 0)
  8020c8:	83 c4 10             	add    $0x10,%esp
  8020cb:	85 c0                	test   %eax,%eax
  8020cd:	79 14                	jns    8020e3 <set_pgfault_handler+0x6d>
		panic("set_pgfault_handler: error in sys_env_set_pgfault_upcall");
  8020cf:	83 ec 04             	sub    $0x4,%esp
  8020d2:	68 90 2a 80 00       	push   $0x802a90
  8020d7:	6a 29                	push   $0x29
  8020d9:	68 cc 2a 80 00       	push   $0x802acc
  8020de:	e8 4d ff ff ff       	call   802030 <_panic>
}
  8020e3:	c9                   	leave  
  8020e4:	c3                   	ret    

008020e5 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8020e5:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8020e6:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8020eb:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8020ed:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	subl $0x4, 0x30(%esp)
  8020f0:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  8020f5:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 0x28(%esp), %ebx 	
  8020f9:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  8020fd:	89 18                	mov    %ebx,(%eax)
	addl $0x8, %esp
  8020ff:	83 c4 08             	add    $0x8,%esp


	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  802102:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp 
  802103:	83 c4 04             	add    $0x4,%esp
	popfl
  802106:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802107:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802108:	c3                   	ret    

00802109 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
  80210c:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80210f:	89 d0                	mov    %edx,%eax
  802111:	c1 e8 16             	shr    $0x16,%eax
  802114:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80211b:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802120:	f6 c1 01             	test   $0x1,%cl
  802123:	74 1d                	je     802142 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802125:	c1 ea 0c             	shr    $0xc,%edx
  802128:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80212f:	f6 c2 01             	test   $0x1,%dl
  802132:	74 0e                	je     802142 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802134:	c1 ea 0c             	shr    $0xc,%edx
  802137:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80213e:	ef 
  80213f:	0f b7 c0             	movzwl %ax,%eax
}
  802142:	5d                   	pop    %ebp
  802143:	c3                   	ret    
  802144:	66 90                	xchg   %ax,%ax
  802146:	66 90                	xchg   %ax,%ax
  802148:	66 90                	xchg   %ax,%ax
  80214a:	66 90                	xchg   %ax,%ax
  80214c:	66 90                	xchg   %ax,%ax
  80214e:	66 90                	xchg   %ax,%ax

00802150 <__udivdi3>:
  802150:	55                   	push   %ebp
  802151:	57                   	push   %edi
  802152:	56                   	push   %esi
  802153:	53                   	push   %ebx
  802154:	83 ec 1c             	sub    $0x1c,%esp
  802157:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80215b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80215f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802163:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802167:	85 f6                	test   %esi,%esi
  802169:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80216d:	89 ca                	mov    %ecx,%edx
  80216f:	89 f8                	mov    %edi,%eax
  802171:	75 3d                	jne    8021b0 <__udivdi3+0x60>
  802173:	39 cf                	cmp    %ecx,%edi
  802175:	0f 87 c5 00 00 00    	ja     802240 <__udivdi3+0xf0>
  80217b:	85 ff                	test   %edi,%edi
  80217d:	89 fd                	mov    %edi,%ebp
  80217f:	75 0b                	jne    80218c <__udivdi3+0x3c>
  802181:	b8 01 00 00 00       	mov    $0x1,%eax
  802186:	31 d2                	xor    %edx,%edx
  802188:	f7 f7                	div    %edi
  80218a:	89 c5                	mov    %eax,%ebp
  80218c:	89 c8                	mov    %ecx,%eax
  80218e:	31 d2                	xor    %edx,%edx
  802190:	f7 f5                	div    %ebp
  802192:	89 c1                	mov    %eax,%ecx
  802194:	89 d8                	mov    %ebx,%eax
  802196:	89 cf                	mov    %ecx,%edi
  802198:	f7 f5                	div    %ebp
  80219a:	89 c3                	mov    %eax,%ebx
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
  8021b0:	39 ce                	cmp    %ecx,%esi
  8021b2:	77 74                	ja     802228 <__udivdi3+0xd8>
  8021b4:	0f bd fe             	bsr    %esi,%edi
  8021b7:	83 f7 1f             	xor    $0x1f,%edi
  8021ba:	0f 84 98 00 00 00    	je     802258 <__udivdi3+0x108>
  8021c0:	bb 20 00 00 00       	mov    $0x20,%ebx
  8021c5:	89 f9                	mov    %edi,%ecx
  8021c7:	89 c5                	mov    %eax,%ebp
  8021c9:	29 fb                	sub    %edi,%ebx
  8021cb:	d3 e6                	shl    %cl,%esi
  8021cd:	89 d9                	mov    %ebx,%ecx
  8021cf:	d3 ed                	shr    %cl,%ebp
  8021d1:	89 f9                	mov    %edi,%ecx
  8021d3:	d3 e0                	shl    %cl,%eax
  8021d5:	09 ee                	or     %ebp,%esi
  8021d7:	89 d9                	mov    %ebx,%ecx
  8021d9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021dd:	89 d5                	mov    %edx,%ebp
  8021df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021e3:	d3 ed                	shr    %cl,%ebp
  8021e5:	89 f9                	mov    %edi,%ecx
  8021e7:	d3 e2                	shl    %cl,%edx
  8021e9:	89 d9                	mov    %ebx,%ecx
  8021eb:	d3 e8                	shr    %cl,%eax
  8021ed:	09 c2                	or     %eax,%edx
  8021ef:	89 d0                	mov    %edx,%eax
  8021f1:	89 ea                	mov    %ebp,%edx
  8021f3:	f7 f6                	div    %esi
  8021f5:	89 d5                	mov    %edx,%ebp
  8021f7:	89 c3                	mov    %eax,%ebx
  8021f9:	f7 64 24 0c          	mull   0xc(%esp)
  8021fd:	39 d5                	cmp    %edx,%ebp
  8021ff:	72 10                	jb     802211 <__udivdi3+0xc1>
  802201:	8b 74 24 08          	mov    0x8(%esp),%esi
  802205:	89 f9                	mov    %edi,%ecx
  802207:	d3 e6                	shl    %cl,%esi
  802209:	39 c6                	cmp    %eax,%esi
  80220b:	73 07                	jae    802214 <__udivdi3+0xc4>
  80220d:	39 d5                	cmp    %edx,%ebp
  80220f:	75 03                	jne    802214 <__udivdi3+0xc4>
  802211:	83 eb 01             	sub    $0x1,%ebx
  802214:	31 ff                	xor    %edi,%edi
  802216:	89 d8                	mov    %ebx,%eax
  802218:	89 fa                	mov    %edi,%edx
  80221a:	83 c4 1c             	add    $0x1c,%esp
  80221d:	5b                   	pop    %ebx
  80221e:	5e                   	pop    %esi
  80221f:	5f                   	pop    %edi
  802220:	5d                   	pop    %ebp
  802221:	c3                   	ret    
  802222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802228:	31 ff                	xor    %edi,%edi
  80222a:	31 db                	xor    %ebx,%ebx
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
  802240:	89 d8                	mov    %ebx,%eax
  802242:	f7 f7                	div    %edi
  802244:	31 ff                	xor    %edi,%edi
  802246:	89 c3                	mov    %eax,%ebx
  802248:	89 d8                	mov    %ebx,%eax
  80224a:	89 fa                	mov    %edi,%edx
  80224c:	83 c4 1c             	add    $0x1c,%esp
  80224f:	5b                   	pop    %ebx
  802250:	5e                   	pop    %esi
  802251:	5f                   	pop    %edi
  802252:	5d                   	pop    %ebp
  802253:	c3                   	ret    
  802254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802258:	39 ce                	cmp    %ecx,%esi
  80225a:	72 0c                	jb     802268 <__udivdi3+0x118>
  80225c:	31 db                	xor    %ebx,%ebx
  80225e:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802262:	0f 87 34 ff ff ff    	ja     80219c <__udivdi3+0x4c>
  802268:	bb 01 00 00 00       	mov    $0x1,%ebx
  80226d:	e9 2a ff ff ff       	jmp    80219c <__udivdi3+0x4c>
  802272:	66 90                	xchg   %ax,%ax
  802274:	66 90                	xchg   %ax,%ax
  802276:	66 90                	xchg   %ax,%ax
  802278:	66 90                	xchg   %ax,%ax
  80227a:	66 90                	xchg   %ax,%ax
  80227c:	66 90                	xchg   %ax,%ax
  80227e:	66 90                	xchg   %ax,%ax

00802280 <__umoddi3>:
  802280:	55                   	push   %ebp
  802281:	57                   	push   %edi
  802282:	56                   	push   %esi
  802283:	53                   	push   %ebx
  802284:	83 ec 1c             	sub    $0x1c,%esp
  802287:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80228b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80228f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802293:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802297:	85 d2                	test   %edx,%edx
  802299:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80229d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022a1:	89 f3                	mov    %esi,%ebx
  8022a3:	89 3c 24             	mov    %edi,(%esp)
  8022a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022aa:	75 1c                	jne    8022c8 <__umoddi3+0x48>
  8022ac:	39 f7                	cmp    %esi,%edi
  8022ae:	76 50                	jbe    802300 <__umoddi3+0x80>
  8022b0:	89 c8                	mov    %ecx,%eax
  8022b2:	89 f2                	mov    %esi,%edx
  8022b4:	f7 f7                	div    %edi
  8022b6:	89 d0                	mov    %edx,%eax
  8022b8:	31 d2                	xor    %edx,%edx
  8022ba:	83 c4 1c             	add    $0x1c,%esp
  8022bd:	5b                   	pop    %ebx
  8022be:	5e                   	pop    %esi
  8022bf:	5f                   	pop    %edi
  8022c0:	5d                   	pop    %ebp
  8022c1:	c3                   	ret    
  8022c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022c8:	39 f2                	cmp    %esi,%edx
  8022ca:	89 d0                	mov    %edx,%eax
  8022cc:	77 52                	ja     802320 <__umoddi3+0xa0>
  8022ce:	0f bd ea             	bsr    %edx,%ebp
  8022d1:	83 f5 1f             	xor    $0x1f,%ebp
  8022d4:	75 5a                	jne    802330 <__umoddi3+0xb0>
  8022d6:	3b 54 24 04          	cmp    0x4(%esp),%edx
  8022da:	0f 82 e0 00 00 00    	jb     8023c0 <__umoddi3+0x140>
  8022e0:	39 0c 24             	cmp    %ecx,(%esp)
  8022e3:	0f 86 d7 00 00 00    	jbe    8023c0 <__umoddi3+0x140>
  8022e9:	8b 44 24 08          	mov    0x8(%esp),%eax
  8022ed:	8b 54 24 04          	mov    0x4(%esp),%edx
  8022f1:	83 c4 1c             	add    $0x1c,%esp
  8022f4:	5b                   	pop    %ebx
  8022f5:	5e                   	pop    %esi
  8022f6:	5f                   	pop    %edi
  8022f7:	5d                   	pop    %ebp
  8022f8:	c3                   	ret    
  8022f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802300:	85 ff                	test   %edi,%edi
  802302:	89 fd                	mov    %edi,%ebp
  802304:	75 0b                	jne    802311 <__umoddi3+0x91>
  802306:	b8 01 00 00 00       	mov    $0x1,%eax
  80230b:	31 d2                	xor    %edx,%edx
  80230d:	f7 f7                	div    %edi
  80230f:	89 c5                	mov    %eax,%ebp
  802311:	89 f0                	mov    %esi,%eax
  802313:	31 d2                	xor    %edx,%edx
  802315:	f7 f5                	div    %ebp
  802317:	89 c8                	mov    %ecx,%eax
  802319:	f7 f5                	div    %ebp
  80231b:	89 d0                	mov    %edx,%eax
  80231d:	eb 99                	jmp    8022b8 <__umoddi3+0x38>
  80231f:	90                   	nop
  802320:	89 c8                	mov    %ecx,%eax
  802322:	89 f2                	mov    %esi,%edx
  802324:	83 c4 1c             	add    $0x1c,%esp
  802327:	5b                   	pop    %ebx
  802328:	5e                   	pop    %esi
  802329:	5f                   	pop    %edi
  80232a:	5d                   	pop    %ebp
  80232b:	c3                   	ret    
  80232c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802330:	8b 34 24             	mov    (%esp),%esi
  802333:	bf 20 00 00 00       	mov    $0x20,%edi
  802338:	89 e9                	mov    %ebp,%ecx
  80233a:	29 ef                	sub    %ebp,%edi
  80233c:	d3 e0                	shl    %cl,%eax
  80233e:	89 f9                	mov    %edi,%ecx
  802340:	89 f2                	mov    %esi,%edx
  802342:	d3 ea                	shr    %cl,%edx
  802344:	89 e9                	mov    %ebp,%ecx
  802346:	09 c2                	or     %eax,%edx
  802348:	89 d8                	mov    %ebx,%eax
  80234a:	89 14 24             	mov    %edx,(%esp)
  80234d:	89 f2                	mov    %esi,%edx
  80234f:	d3 e2                	shl    %cl,%edx
  802351:	89 f9                	mov    %edi,%ecx
  802353:	89 54 24 04          	mov    %edx,0x4(%esp)
  802357:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80235b:	d3 e8                	shr    %cl,%eax
  80235d:	89 e9                	mov    %ebp,%ecx
  80235f:	89 c6                	mov    %eax,%esi
  802361:	d3 e3                	shl    %cl,%ebx
  802363:	89 f9                	mov    %edi,%ecx
  802365:	89 d0                	mov    %edx,%eax
  802367:	d3 e8                	shr    %cl,%eax
  802369:	89 e9                	mov    %ebp,%ecx
  80236b:	09 d8                	or     %ebx,%eax
  80236d:	89 d3                	mov    %edx,%ebx
  80236f:	89 f2                	mov    %esi,%edx
  802371:	f7 34 24             	divl   (%esp)
  802374:	89 d6                	mov    %edx,%esi
  802376:	d3 e3                	shl    %cl,%ebx
  802378:	f7 64 24 04          	mull   0x4(%esp)
  80237c:	39 d6                	cmp    %edx,%esi
  80237e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802382:	89 d1                	mov    %edx,%ecx
  802384:	89 c3                	mov    %eax,%ebx
  802386:	72 08                	jb     802390 <__umoddi3+0x110>
  802388:	75 11                	jne    80239b <__umoddi3+0x11b>
  80238a:	39 44 24 08          	cmp    %eax,0x8(%esp)
  80238e:	73 0b                	jae    80239b <__umoddi3+0x11b>
  802390:	2b 44 24 04          	sub    0x4(%esp),%eax
  802394:	1b 14 24             	sbb    (%esp),%edx
  802397:	89 d1                	mov    %edx,%ecx
  802399:	89 c3                	mov    %eax,%ebx
  80239b:	8b 54 24 08          	mov    0x8(%esp),%edx
  80239f:	29 da                	sub    %ebx,%edx
  8023a1:	19 ce                	sbb    %ecx,%esi
  8023a3:	89 f9                	mov    %edi,%ecx
  8023a5:	89 f0                	mov    %esi,%eax
  8023a7:	d3 e0                	shl    %cl,%eax
  8023a9:	89 e9                	mov    %ebp,%ecx
  8023ab:	d3 ea                	shr    %cl,%edx
  8023ad:	89 e9                	mov    %ebp,%ecx
  8023af:	d3 ee                	shr    %cl,%esi
  8023b1:	09 d0                	or     %edx,%eax
  8023b3:	89 f2                	mov    %esi,%edx
  8023b5:	83 c4 1c             	add    $0x1c,%esp
  8023b8:	5b                   	pop    %ebx
  8023b9:	5e                   	pop    %esi
  8023ba:	5f                   	pop    %edi
  8023bb:	5d                   	pop    %ebp
  8023bc:	c3                   	ret    
  8023bd:	8d 76 00             	lea    0x0(%esi),%esi
  8023c0:	29 f9                	sub    %edi,%ecx
  8023c2:	19 d6                	sbb    %edx,%esi
  8023c4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023c8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023cc:	e9 18 ff ff ff       	jmp    8022e9 <__umoddi3+0x69>
