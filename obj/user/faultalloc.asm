
obj/user/faultalloc.debug:     formato del fichero elf32-i386


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
  80002c:	e8 99 00 00 00       	call   8000ca <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003a:	8b 45 08             	mov    0x8(%ebp),%eax
  80003d:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80003f:	53                   	push   %ebx
  800040:	68 60 1e 80 00       	push   $0x801e60
  800045:	e8 bd 01 00 00       	call   800207 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 64 0b 00 00       	call   800bc2 <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	79 16                	jns    80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  800065:	83 ec 0c             	sub    $0xc,%esp
  800068:	50                   	push   %eax
  800069:	53                   	push   %ebx
  80006a:	68 80 1e 80 00       	push   $0x801e80
  80006f:	6a 0e                	push   $0xe
  800071:	68 6a 1e 80 00       	push   $0x801e6a
  800076:	e8 b3 00 00 00       	call   80012e <_panic>
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  80007b:	53                   	push   %ebx
  80007c:	68 ac 1e 80 00       	push   $0x801eac
  800081:	6a 64                	push   $0x64
  800083:	53                   	push   %ebx
  800084:	e8 9d 06 00 00       	call   800726 <snprintf>
}
  800089:	83 c4 10             	add    $0x10,%esp
  80008c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80008f:	c9                   	leave  
  800090:	c3                   	ret    

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 3e 0c 00 00       	call   800cdf <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	68 ef be ad de       	push   $0xdeadbeef
  8000a9:	68 7c 1e 80 00       	push   $0x801e7c
  8000ae:	e8 54 01 00 00       	call   800207 <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	68 fe bf fe ca       	push   $0xcafebffe
  8000bb:	68 7c 1e 80 00       	push   $0x801e7c
  8000c0:	e8 42 01 00 00       	call   800207 <cprintf>
}
  8000c5:	83 c4 10             	add    $0x10,%esp
  8000c8:	c9                   	leave  
  8000c9:	c3                   	ret    

008000ca <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000ca:	55                   	push   %ebp
  8000cb:	89 e5                	mov    %esp,%ebp
  8000cd:	56                   	push   %esi
  8000ce:	53                   	push   %ebx
  8000cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000d2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8000d5:	e8 9d 0a 00 00       	call   800b77 <sys_getenvid>
	if (id >= 0)
  8000da:	85 c0                	test   %eax,%eax
  8000dc:	78 12                	js     8000f0 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  8000de:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000e3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000e6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000eb:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f0:	85 db                	test   %ebx,%ebx
  8000f2:	7e 07                	jle    8000fb <libmain+0x31>
		binaryname = argv[0];
  8000f4:	8b 06                	mov    (%esi),%eax
  8000f6:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000fb:	83 ec 08             	sub    $0x8,%esp
  8000fe:	56                   	push   %esi
  8000ff:	53                   	push   %ebx
  800100:	e8 8c ff ff ff       	call   800091 <umain>

	// exit gracefully
	exit();
  800105:	e8 0a 00 00 00       	call   800114 <exit>
}
  80010a:	83 c4 10             	add    $0x10,%esp
  80010d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800110:	5b                   	pop    %ebx
  800111:	5e                   	pop    %esi
  800112:	5d                   	pop    %ebp
  800113:	c3                   	ret    

00800114 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800114:	55                   	push   %ebp
  800115:	89 e5                	mov    %esp,%ebp
  800117:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80011a:	e8 1e 0e 00 00       	call   800f3d <close_all>
	sys_env_destroy(0);
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	6a 00                	push   $0x0
  800124:	e8 2c 0a 00 00       	call   800b55 <sys_env_destroy>
}
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	c9                   	leave  
  80012d:	c3                   	ret    

0080012e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80012e:	55                   	push   %ebp
  80012f:	89 e5                	mov    %esp,%ebp
  800131:	56                   	push   %esi
  800132:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800133:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800136:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80013c:	e8 36 0a 00 00       	call   800b77 <sys_getenvid>
  800141:	83 ec 0c             	sub    $0xc,%esp
  800144:	ff 75 0c             	pushl  0xc(%ebp)
  800147:	ff 75 08             	pushl  0x8(%ebp)
  80014a:	56                   	push   %esi
  80014b:	50                   	push   %eax
  80014c:	68 d8 1e 80 00       	push   $0x801ed8
  800151:	e8 b1 00 00 00       	call   800207 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800156:	83 c4 18             	add    $0x18,%esp
  800159:	53                   	push   %ebx
  80015a:	ff 75 10             	pushl  0x10(%ebp)
  80015d:	e8 54 00 00 00       	call   8001b6 <vcprintf>
	cprintf("\n");
  800162:	c7 04 24 7f 23 80 00 	movl   $0x80237f,(%esp)
  800169:	e8 99 00 00 00       	call   800207 <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800171:	cc                   	int3   
  800172:	eb fd                	jmp    800171 <_panic+0x43>

00800174 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800174:	55                   	push   %ebp
  800175:	89 e5                	mov    %esp,%ebp
  800177:	53                   	push   %ebx
  800178:	83 ec 04             	sub    $0x4,%esp
  80017b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80017e:	8b 13                	mov    (%ebx),%edx
  800180:	8d 42 01             	lea    0x1(%edx),%eax
  800183:	89 03                	mov    %eax,(%ebx)
  800185:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800188:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80018c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800191:	75 1a                	jne    8001ad <putch+0x39>
		sys_cputs(b->buf, b->idx);
  800193:	83 ec 08             	sub    $0x8,%esp
  800196:	68 ff 00 00 00       	push   $0xff
  80019b:	8d 43 08             	lea    0x8(%ebx),%eax
  80019e:	50                   	push   %eax
  80019f:	e8 67 09 00 00       	call   800b0b <sys_cputs>
		b->idx = 0;
  8001a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001aa:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  8001ad:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001b4:	c9                   	leave  
  8001b5:	c3                   	ret    

008001b6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b6:	55                   	push   %ebp
  8001b7:	89 e5                	mov    %esp,%ebp
  8001b9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001bf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c6:	00 00 00 
	b.cnt = 0;
  8001c9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001d0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d3:	ff 75 0c             	pushl  0xc(%ebp)
  8001d6:	ff 75 08             	pushl  0x8(%ebp)
  8001d9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001df:	50                   	push   %eax
  8001e0:	68 74 01 80 00       	push   $0x800174
  8001e5:	e8 86 01 00 00       	call   800370 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001ea:	83 c4 08             	add    $0x8,%esp
  8001ed:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001f3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f9:	50                   	push   %eax
  8001fa:	e8 0c 09 00 00       	call   800b0b <sys_cputs>

	return b.cnt;
}
  8001ff:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800205:	c9                   	leave  
  800206:	c3                   	ret    

00800207 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800207:	55                   	push   %ebp
  800208:	89 e5                	mov    %esp,%ebp
  80020a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80020d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800210:	50                   	push   %eax
  800211:	ff 75 08             	pushl  0x8(%ebp)
  800214:	e8 9d ff ff ff       	call   8001b6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800219:	c9                   	leave  
  80021a:	c3                   	ret    

0080021b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80021b:	55                   	push   %ebp
  80021c:	89 e5                	mov    %esp,%ebp
  80021e:	57                   	push   %edi
  80021f:	56                   	push   %esi
  800220:	53                   	push   %ebx
  800221:	83 ec 1c             	sub    $0x1c,%esp
  800224:	89 c7                	mov    %eax,%edi
  800226:	89 d6                	mov    %edx,%esi
  800228:	8b 45 08             	mov    0x8(%ebp),%eax
  80022b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800231:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800234:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800237:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80023f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800242:	39 d3                	cmp    %edx,%ebx
  800244:	72 05                	jb     80024b <printnum+0x30>
  800246:	39 45 10             	cmp    %eax,0x10(%ebp)
  800249:	77 45                	ja     800290 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	ff 75 18             	pushl  0x18(%ebp)
  800251:	8b 45 14             	mov    0x14(%ebp),%eax
  800254:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800257:	53                   	push   %ebx
  800258:	ff 75 10             	pushl  0x10(%ebp)
  80025b:	83 ec 08             	sub    $0x8,%esp
  80025e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800261:	ff 75 e0             	pushl  -0x20(%ebp)
  800264:	ff 75 dc             	pushl  -0x24(%ebp)
  800267:	ff 75 d8             	pushl  -0x28(%ebp)
  80026a:	e8 51 19 00 00       	call   801bc0 <__udivdi3>
  80026f:	83 c4 18             	add    $0x18,%esp
  800272:	52                   	push   %edx
  800273:	50                   	push   %eax
  800274:	89 f2                	mov    %esi,%edx
  800276:	89 f8                	mov    %edi,%eax
  800278:	e8 9e ff ff ff       	call   80021b <printnum>
  80027d:	83 c4 20             	add    $0x20,%esp
  800280:	eb 18                	jmp    80029a <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800282:	83 ec 08             	sub    $0x8,%esp
  800285:	56                   	push   %esi
  800286:	ff 75 18             	pushl  0x18(%ebp)
  800289:	ff d7                	call   *%edi
  80028b:	83 c4 10             	add    $0x10,%esp
  80028e:	eb 03                	jmp    800293 <printnum+0x78>
  800290:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800293:	83 eb 01             	sub    $0x1,%ebx
  800296:	85 db                	test   %ebx,%ebx
  800298:	7f e8                	jg     800282 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80029a:	83 ec 08             	sub    $0x8,%esp
  80029d:	56                   	push   %esi
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a4:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a7:	ff 75 dc             	pushl  -0x24(%ebp)
  8002aa:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ad:	e8 3e 1a 00 00       	call   801cf0 <__umoddi3>
  8002b2:	83 c4 14             	add    $0x14,%esp
  8002b5:	0f be 80 fb 1e 80 00 	movsbl 0x801efb(%eax),%eax
  8002bc:	50                   	push   %eax
  8002bd:	ff d7                	call   *%edi
}
  8002bf:	83 c4 10             	add    $0x10,%esp
  8002c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c5:	5b                   	pop    %ebx
  8002c6:	5e                   	pop    %esi
  8002c7:	5f                   	pop    %edi
  8002c8:	5d                   	pop    %ebp
  8002c9:	c3                   	ret    

008002ca <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002ca:	55                   	push   %ebp
  8002cb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002cd:	83 fa 01             	cmp    $0x1,%edx
  8002d0:	7e 0e                	jle    8002e0 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002d2:	8b 10                	mov    (%eax),%edx
  8002d4:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002d7:	89 08                	mov    %ecx,(%eax)
  8002d9:	8b 02                	mov    (%edx),%eax
  8002db:	8b 52 04             	mov    0x4(%edx),%edx
  8002de:	eb 22                	jmp    800302 <getuint+0x38>
	else if (lflag)
  8002e0:	85 d2                	test   %edx,%edx
  8002e2:	74 10                	je     8002f4 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002e4:	8b 10                	mov    (%eax),%edx
  8002e6:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002e9:	89 08                	mov    %ecx,(%eax)
  8002eb:	8b 02                	mov    (%edx),%eax
  8002ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f2:	eb 0e                	jmp    800302 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002f4:	8b 10                	mov    (%eax),%edx
  8002f6:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002f9:	89 08                	mov    %ecx,(%eax)
  8002fb:	8b 02                	mov    (%edx),%eax
  8002fd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800302:	5d                   	pop    %ebp
  800303:	c3                   	ret    

00800304 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800304:	55                   	push   %ebp
  800305:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800307:	83 fa 01             	cmp    $0x1,%edx
  80030a:	7e 0e                	jle    80031a <getint+0x16>
		return va_arg(*ap, long long);
  80030c:	8b 10                	mov    (%eax),%edx
  80030e:	8d 4a 08             	lea    0x8(%edx),%ecx
  800311:	89 08                	mov    %ecx,(%eax)
  800313:	8b 02                	mov    (%edx),%eax
  800315:	8b 52 04             	mov    0x4(%edx),%edx
  800318:	eb 1a                	jmp    800334 <getint+0x30>
	else if (lflag)
  80031a:	85 d2                	test   %edx,%edx
  80031c:	74 0c                	je     80032a <getint+0x26>
		return va_arg(*ap, long);
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8d 4a 04             	lea    0x4(%edx),%ecx
  800323:	89 08                	mov    %ecx,(%eax)
  800325:	8b 02                	mov    (%edx),%eax
  800327:	99                   	cltd   
  800328:	eb 0a                	jmp    800334 <getint+0x30>
	else
		return va_arg(*ap, int);
  80032a:	8b 10                	mov    (%eax),%edx
  80032c:	8d 4a 04             	lea    0x4(%edx),%ecx
  80032f:	89 08                	mov    %ecx,(%eax)
  800331:	8b 02                	mov    (%edx),%eax
  800333:	99                   	cltd   
}
  800334:	5d                   	pop    %ebp
  800335:	c3                   	ret    

00800336 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800336:	55                   	push   %ebp
  800337:	89 e5                	mov    %esp,%ebp
  800339:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80033c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800340:	8b 10                	mov    (%eax),%edx
  800342:	3b 50 04             	cmp    0x4(%eax),%edx
  800345:	73 0a                	jae    800351 <sprintputch+0x1b>
		*b->buf++ = ch;
  800347:	8d 4a 01             	lea    0x1(%edx),%ecx
  80034a:	89 08                	mov    %ecx,(%eax)
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	88 02                	mov    %al,(%edx)
}
  800351:	5d                   	pop    %ebp
  800352:	c3                   	ret    

00800353 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800353:	55                   	push   %ebp
  800354:	89 e5                	mov    %esp,%ebp
  800356:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800359:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80035c:	50                   	push   %eax
  80035d:	ff 75 10             	pushl  0x10(%ebp)
  800360:	ff 75 0c             	pushl  0xc(%ebp)
  800363:	ff 75 08             	pushl  0x8(%ebp)
  800366:	e8 05 00 00 00       	call   800370 <vprintfmt>
	va_end(ap);
}
  80036b:	83 c4 10             	add    $0x10,%esp
  80036e:	c9                   	leave  
  80036f:	c3                   	ret    

00800370 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
  800373:	57                   	push   %edi
  800374:	56                   	push   %esi
  800375:	53                   	push   %ebx
  800376:	83 ec 2c             	sub    $0x2c,%esp
  800379:	8b 75 08             	mov    0x8(%ebp),%esi
  80037c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80037f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800382:	eb 12                	jmp    800396 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800384:	85 c0                	test   %eax,%eax
  800386:	0f 84 44 03 00 00    	je     8006d0 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  80038c:	83 ec 08             	sub    $0x8,%esp
  80038f:	53                   	push   %ebx
  800390:	50                   	push   %eax
  800391:	ff d6                	call   *%esi
  800393:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800396:	83 c7 01             	add    $0x1,%edi
  800399:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80039d:	83 f8 25             	cmp    $0x25,%eax
  8003a0:	75 e2                	jne    800384 <vprintfmt+0x14>
  8003a2:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8003a6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8003ad:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003b4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8003bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c0:	eb 07                	jmp    8003c9 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003c5:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003c9:	8d 47 01             	lea    0x1(%edi),%eax
  8003cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003cf:	0f b6 07             	movzbl (%edi),%eax
  8003d2:	0f b6 c8             	movzbl %al,%ecx
  8003d5:	83 e8 23             	sub    $0x23,%eax
  8003d8:	3c 55                	cmp    $0x55,%al
  8003da:	0f 87 d5 02 00 00    	ja     8006b5 <vprintfmt+0x345>
  8003e0:	0f b6 c0             	movzbl %al,%eax
  8003e3:	ff 24 85 40 20 80 00 	jmp    *0x802040(,%eax,4)
  8003ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003ed:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003f1:	eb d6                	jmp    8003c9 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003fe:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800401:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  800405:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  800408:	8d 51 d0             	lea    -0x30(%ecx),%edx
  80040b:	83 fa 09             	cmp    $0x9,%edx
  80040e:	77 39                	ja     800449 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800410:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800413:	eb e9                	jmp    8003fe <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800415:	8b 45 14             	mov    0x14(%ebp),%eax
  800418:	8d 48 04             	lea    0x4(%eax),%ecx
  80041b:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80041e:	8b 00                	mov    (%eax),%eax
  800420:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800423:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800426:	eb 27                	jmp    80044f <vprintfmt+0xdf>
  800428:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042b:	85 c0                	test   %eax,%eax
  80042d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800432:	0f 49 c8             	cmovns %eax,%ecx
  800435:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800438:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80043b:	eb 8c                	jmp    8003c9 <vprintfmt+0x59>
  80043d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800440:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800447:	eb 80                	jmp    8003c9 <vprintfmt+0x59>
  800449:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80044c:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  80044f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800453:	0f 89 70 ff ff ff    	jns    8003c9 <vprintfmt+0x59>
				width = precision, precision = -1;
  800459:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80045c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800466:	e9 5e ff ff ff       	jmp    8003c9 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80046b:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800471:	e9 53 ff ff ff       	jmp    8003c9 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800476:	8b 45 14             	mov    0x14(%ebp),%eax
  800479:	8d 50 04             	lea    0x4(%eax),%edx
  80047c:	89 55 14             	mov    %edx,0x14(%ebp)
  80047f:	83 ec 08             	sub    $0x8,%esp
  800482:	53                   	push   %ebx
  800483:	ff 30                	pushl  (%eax)
  800485:	ff d6                	call   *%esi
			break;
  800487:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  80048d:	e9 04 ff ff ff       	jmp    800396 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800492:	8b 45 14             	mov    0x14(%ebp),%eax
  800495:	8d 50 04             	lea    0x4(%eax),%edx
  800498:	89 55 14             	mov    %edx,0x14(%ebp)
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	99                   	cltd   
  80049e:	31 d0                	xor    %edx,%eax
  8004a0:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004a2:	83 f8 0f             	cmp    $0xf,%eax
  8004a5:	7f 0b                	jg     8004b2 <vprintfmt+0x142>
  8004a7:	8b 14 85 a0 21 80 00 	mov    0x8021a0(,%eax,4),%edx
  8004ae:	85 d2                	test   %edx,%edx
  8004b0:	75 18                	jne    8004ca <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  8004b2:	50                   	push   %eax
  8004b3:	68 13 1f 80 00       	push   $0x801f13
  8004b8:	53                   	push   %ebx
  8004b9:	56                   	push   %esi
  8004ba:	e8 94 fe ff ff       	call   800353 <printfmt>
  8004bf:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8004c5:	e9 cc fe ff ff       	jmp    800396 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  8004ca:	52                   	push   %edx
  8004cb:	68 4d 23 80 00       	push   $0x80234d
  8004d0:	53                   	push   %ebx
  8004d1:	56                   	push   %esi
  8004d2:	e8 7c fe ff ff       	call   800353 <printfmt>
  8004d7:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004dd:	e9 b4 fe ff ff       	jmp    800396 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e5:	8d 50 04             	lea    0x4(%eax),%edx
  8004e8:	89 55 14             	mov    %edx,0x14(%ebp)
  8004eb:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004ed:	85 ff                	test   %edi,%edi
  8004ef:	b8 0c 1f 80 00       	mov    $0x801f0c,%eax
  8004f4:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004fb:	0f 8e 94 00 00 00    	jle    800595 <vprintfmt+0x225>
  800501:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800505:	0f 84 98 00 00 00    	je     8005a3 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  80050b:	83 ec 08             	sub    $0x8,%esp
  80050e:	ff 75 d0             	pushl  -0x30(%ebp)
  800511:	57                   	push   %edi
  800512:	e8 41 02 00 00       	call   800758 <strnlen>
  800517:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80051a:	29 c1                	sub    %eax,%ecx
  80051c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80051f:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800522:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800526:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800529:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80052c:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80052e:	eb 0f                	jmp    80053f <vprintfmt+0x1cf>
					putch(padc, putdat);
  800530:	83 ec 08             	sub    $0x8,%esp
  800533:	53                   	push   %ebx
  800534:	ff 75 e0             	pushl  -0x20(%ebp)
  800537:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800539:	83 ef 01             	sub    $0x1,%edi
  80053c:	83 c4 10             	add    $0x10,%esp
  80053f:	85 ff                	test   %edi,%edi
  800541:	7f ed                	jg     800530 <vprintfmt+0x1c0>
  800543:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800546:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800549:	85 c9                	test   %ecx,%ecx
  80054b:	b8 00 00 00 00       	mov    $0x0,%eax
  800550:	0f 49 c1             	cmovns %ecx,%eax
  800553:	29 c1                	sub    %eax,%ecx
  800555:	89 75 08             	mov    %esi,0x8(%ebp)
  800558:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80055b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80055e:	89 cb                	mov    %ecx,%ebx
  800560:	eb 4d                	jmp    8005af <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800562:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800566:	74 1b                	je     800583 <vprintfmt+0x213>
  800568:	0f be c0             	movsbl %al,%eax
  80056b:	83 e8 20             	sub    $0x20,%eax
  80056e:	83 f8 5e             	cmp    $0x5e,%eax
  800571:	76 10                	jbe    800583 <vprintfmt+0x213>
					putch('?', putdat);
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	ff 75 0c             	pushl  0xc(%ebp)
  800579:	6a 3f                	push   $0x3f
  80057b:	ff 55 08             	call   *0x8(%ebp)
  80057e:	83 c4 10             	add    $0x10,%esp
  800581:	eb 0d                	jmp    800590 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	ff 75 0c             	pushl  0xc(%ebp)
  800589:	52                   	push   %edx
  80058a:	ff 55 08             	call   *0x8(%ebp)
  80058d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800590:	83 eb 01             	sub    $0x1,%ebx
  800593:	eb 1a                	jmp    8005af <vprintfmt+0x23f>
  800595:	89 75 08             	mov    %esi,0x8(%ebp)
  800598:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80059b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80059e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005a1:	eb 0c                	jmp    8005af <vprintfmt+0x23f>
  8005a3:	89 75 08             	mov    %esi,0x8(%ebp)
  8005a6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005a9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005ac:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005af:	83 c7 01             	add    $0x1,%edi
  8005b2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005b6:	0f be d0             	movsbl %al,%edx
  8005b9:	85 d2                	test   %edx,%edx
  8005bb:	74 23                	je     8005e0 <vprintfmt+0x270>
  8005bd:	85 f6                	test   %esi,%esi
  8005bf:	78 a1                	js     800562 <vprintfmt+0x1f2>
  8005c1:	83 ee 01             	sub    $0x1,%esi
  8005c4:	79 9c                	jns    800562 <vprintfmt+0x1f2>
  8005c6:	89 df                	mov    %ebx,%edi
  8005c8:	8b 75 08             	mov    0x8(%ebp),%esi
  8005cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005ce:	eb 18                	jmp    8005e8 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	53                   	push   %ebx
  8005d4:	6a 20                	push   $0x20
  8005d6:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005d8:	83 ef 01             	sub    $0x1,%edi
  8005db:	83 c4 10             	add    $0x10,%esp
  8005de:	eb 08                	jmp    8005e8 <vprintfmt+0x278>
  8005e0:	89 df                	mov    %ebx,%edi
  8005e2:	8b 75 08             	mov    0x8(%ebp),%esi
  8005e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005e8:	85 ff                	test   %edi,%edi
  8005ea:	7f e4                	jg     8005d0 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005ef:	e9 a2 fd ff ff       	jmp    800396 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005f4:	8d 45 14             	lea    0x14(%ebp),%eax
  8005f7:	e8 08 fd ff ff       	call   800304 <getint>
  8005fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800602:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800607:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80060b:	79 74                	jns    800681 <vprintfmt+0x311>
				putch('-', putdat);
  80060d:	83 ec 08             	sub    $0x8,%esp
  800610:	53                   	push   %ebx
  800611:	6a 2d                	push   $0x2d
  800613:	ff d6                	call   *%esi
				num = -(long long) num;
  800615:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800618:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80061b:	f7 d8                	neg    %eax
  80061d:	83 d2 00             	adc    $0x0,%edx
  800620:	f7 da                	neg    %edx
  800622:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  800625:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80062a:	eb 55                	jmp    800681 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80062c:	8d 45 14             	lea    0x14(%ebp),%eax
  80062f:	e8 96 fc ff ff       	call   8002ca <getuint>
			base = 10;
  800634:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800639:	eb 46                	jmp    800681 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  80063b:	8d 45 14             	lea    0x14(%ebp),%eax
  80063e:	e8 87 fc ff ff       	call   8002ca <getuint>
			base = 8;
  800643:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800648:	eb 37                	jmp    800681 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	53                   	push   %ebx
  80064e:	6a 30                	push   $0x30
  800650:	ff d6                	call   *%esi
			putch('x', putdat);
  800652:	83 c4 08             	add    $0x8,%esp
  800655:	53                   	push   %ebx
  800656:	6a 78                	push   $0x78
  800658:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	8d 50 04             	lea    0x4(%eax),%edx
  800660:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800663:	8b 00                	mov    (%eax),%eax
  800665:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  80066a:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80066d:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800672:	eb 0d                	jmp    800681 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800674:	8d 45 14             	lea    0x14(%ebp),%eax
  800677:	e8 4e fc ff ff       	call   8002ca <getuint>
			base = 16;
  80067c:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800681:	83 ec 0c             	sub    $0xc,%esp
  800684:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800688:	57                   	push   %edi
  800689:	ff 75 e0             	pushl  -0x20(%ebp)
  80068c:	51                   	push   %ecx
  80068d:	52                   	push   %edx
  80068e:	50                   	push   %eax
  80068f:	89 da                	mov    %ebx,%edx
  800691:	89 f0                	mov    %esi,%eax
  800693:	e8 83 fb ff ff       	call   80021b <printnum>
			break;
  800698:	83 c4 20             	add    $0x20,%esp
  80069b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80069e:	e9 f3 fc ff ff       	jmp    800396 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006a3:	83 ec 08             	sub    $0x8,%esp
  8006a6:	53                   	push   %ebx
  8006a7:	51                   	push   %ecx
  8006a8:	ff d6                	call   *%esi
			break;
  8006aa:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8006b0:	e9 e1 fc ff ff       	jmp    800396 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006b5:	83 ec 08             	sub    $0x8,%esp
  8006b8:	53                   	push   %ebx
  8006b9:	6a 25                	push   $0x25
  8006bb:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006bd:	83 c4 10             	add    $0x10,%esp
  8006c0:	eb 03                	jmp    8006c5 <vprintfmt+0x355>
  8006c2:	83 ef 01             	sub    $0x1,%edi
  8006c5:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  8006c9:	75 f7                	jne    8006c2 <vprintfmt+0x352>
  8006cb:	e9 c6 fc ff ff       	jmp    800396 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  8006d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006d3:	5b                   	pop    %ebx
  8006d4:	5e                   	pop    %esi
  8006d5:	5f                   	pop    %edi
  8006d6:	5d                   	pop    %ebp
  8006d7:	c3                   	ret    

008006d8 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006d8:	55                   	push   %ebp
  8006d9:	89 e5                	mov    %esp,%ebp
  8006db:	83 ec 18             	sub    $0x18,%esp
  8006de:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006e7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006eb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006f5:	85 c0                	test   %eax,%eax
  8006f7:	74 26                	je     80071f <vsnprintf+0x47>
  8006f9:	85 d2                	test   %edx,%edx
  8006fb:	7e 22                	jle    80071f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006fd:	ff 75 14             	pushl  0x14(%ebp)
  800700:	ff 75 10             	pushl  0x10(%ebp)
  800703:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800706:	50                   	push   %eax
  800707:	68 36 03 80 00       	push   $0x800336
  80070c:	e8 5f fc ff ff       	call   800370 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800711:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800714:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80071a:	83 c4 10             	add    $0x10,%esp
  80071d:	eb 05                	jmp    800724 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80071f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800724:	c9                   	leave  
  800725:	c3                   	ret    

00800726 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800726:	55                   	push   %ebp
  800727:	89 e5                	mov    %esp,%ebp
  800729:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80072c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80072f:	50                   	push   %eax
  800730:	ff 75 10             	pushl  0x10(%ebp)
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	ff 75 08             	pushl  0x8(%ebp)
  800739:	e8 9a ff ff ff       	call   8006d8 <vsnprintf>
	va_end(ap);

	return rc;
}
  80073e:	c9                   	leave  
  80073f:	c3                   	ret    

00800740 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800746:	b8 00 00 00 00       	mov    $0x0,%eax
  80074b:	eb 03                	jmp    800750 <strlen+0x10>
		n++;
  80074d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800750:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800754:	75 f7                	jne    80074d <strlen+0xd>
		n++;
	return n;
}
  800756:	5d                   	pop    %ebp
  800757:	c3                   	ret    

00800758 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
  80075b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80075e:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800761:	ba 00 00 00 00       	mov    $0x0,%edx
  800766:	eb 03                	jmp    80076b <strnlen+0x13>
		n++;
  800768:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80076b:	39 c2                	cmp    %eax,%edx
  80076d:	74 08                	je     800777 <strnlen+0x1f>
  80076f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800773:	75 f3                	jne    800768 <strnlen+0x10>
  800775:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  800777:	5d                   	pop    %ebp
  800778:	c3                   	ret    

00800779 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800779:	55                   	push   %ebp
  80077a:	89 e5                	mov    %esp,%ebp
  80077c:	53                   	push   %ebx
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800783:	89 c2                	mov    %eax,%edx
  800785:	83 c2 01             	add    $0x1,%edx
  800788:	83 c1 01             	add    $0x1,%ecx
  80078b:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80078f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800792:	84 db                	test   %bl,%bl
  800794:	75 ef                	jne    800785 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800796:	5b                   	pop    %ebx
  800797:	5d                   	pop    %ebp
  800798:	c3                   	ret    

00800799 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
  80079c:	53                   	push   %ebx
  80079d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007a0:	53                   	push   %ebx
  8007a1:	e8 9a ff ff ff       	call   800740 <strlen>
  8007a6:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007a9:	ff 75 0c             	pushl  0xc(%ebp)
  8007ac:	01 d8                	add    %ebx,%eax
  8007ae:	50                   	push   %eax
  8007af:	e8 c5 ff ff ff       	call   800779 <strcpy>
	return dst;
}
  8007b4:	89 d8                	mov    %ebx,%eax
  8007b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    

008007bb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
  8007be:	56                   	push   %esi
  8007bf:	53                   	push   %ebx
  8007c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8007c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007c6:	89 f3                	mov    %esi,%ebx
  8007c8:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007cb:	89 f2                	mov    %esi,%edx
  8007cd:	eb 0f                	jmp    8007de <strncpy+0x23>
		*dst++ = *src;
  8007cf:	83 c2 01             	add    $0x1,%edx
  8007d2:	0f b6 01             	movzbl (%ecx),%eax
  8007d5:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007d8:	80 39 01             	cmpb   $0x1,(%ecx)
  8007db:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007de:	39 da                	cmp    %ebx,%edx
  8007e0:	75 ed                	jne    8007cf <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8007e2:	89 f0                	mov    %esi,%eax
  8007e4:	5b                   	pop    %ebx
  8007e5:	5e                   	pop    %esi
  8007e6:	5d                   	pop    %ebp
  8007e7:	c3                   	ret    

008007e8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007e8:	55                   	push   %ebp
  8007e9:	89 e5                	mov    %esp,%ebp
  8007eb:	56                   	push   %esi
  8007ec:	53                   	push   %ebx
  8007ed:	8b 75 08             	mov    0x8(%ebp),%esi
  8007f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007f3:	8b 55 10             	mov    0x10(%ebp),%edx
  8007f6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007f8:	85 d2                	test   %edx,%edx
  8007fa:	74 21                	je     80081d <strlcpy+0x35>
  8007fc:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800800:	89 f2                	mov    %esi,%edx
  800802:	eb 09                	jmp    80080d <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800804:	83 c2 01             	add    $0x1,%edx
  800807:	83 c1 01             	add    $0x1,%ecx
  80080a:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80080d:	39 c2                	cmp    %eax,%edx
  80080f:	74 09                	je     80081a <strlcpy+0x32>
  800811:	0f b6 19             	movzbl (%ecx),%ebx
  800814:	84 db                	test   %bl,%bl
  800816:	75 ec                	jne    800804 <strlcpy+0x1c>
  800818:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  80081a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80081d:	29 f0                	sub    %esi,%eax
}
  80081f:	5b                   	pop    %ebx
  800820:	5e                   	pop    %esi
  800821:	5d                   	pop    %ebp
  800822:	c3                   	ret    

00800823 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800823:	55                   	push   %ebp
  800824:	89 e5                	mov    %esp,%ebp
  800826:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800829:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80082c:	eb 06                	jmp    800834 <strcmp+0x11>
		p++, q++;
  80082e:	83 c1 01             	add    $0x1,%ecx
  800831:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800834:	0f b6 01             	movzbl (%ecx),%eax
  800837:	84 c0                	test   %al,%al
  800839:	74 04                	je     80083f <strcmp+0x1c>
  80083b:	3a 02                	cmp    (%edx),%al
  80083d:	74 ef                	je     80082e <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80083f:	0f b6 c0             	movzbl %al,%eax
  800842:	0f b6 12             	movzbl (%edx),%edx
  800845:	29 d0                	sub    %edx,%eax
}
  800847:	5d                   	pop    %ebp
  800848:	c3                   	ret    

00800849 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800849:	55                   	push   %ebp
  80084a:	89 e5                	mov    %esp,%ebp
  80084c:	53                   	push   %ebx
  80084d:	8b 45 08             	mov    0x8(%ebp),%eax
  800850:	8b 55 0c             	mov    0xc(%ebp),%edx
  800853:	89 c3                	mov    %eax,%ebx
  800855:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800858:	eb 06                	jmp    800860 <strncmp+0x17>
		n--, p++, q++;
  80085a:	83 c0 01             	add    $0x1,%eax
  80085d:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800860:	39 d8                	cmp    %ebx,%eax
  800862:	74 15                	je     800879 <strncmp+0x30>
  800864:	0f b6 08             	movzbl (%eax),%ecx
  800867:	84 c9                	test   %cl,%cl
  800869:	74 04                	je     80086f <strncmp+0x26>
  80086b:	3a 0a                	cmp    (%edx),%cl
  80086d:	74 eb                	je     80085a <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80086f:	0f b6 00             	movzbl (%eax),%eax
  800872:	0f b6 12             	movzbl (%edx),%edx
  800875:	29 d0                	sub    %edx,%eax
  800877:	eb 05                	jmp    80087e <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800879:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  80087e:	5b                   	pop    %ebx
  80087f:	5d                   	pop    %ebp
  800880:	c3                   	ret    

00800881 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800881:	55                   	push   %ebp
  800882:	89 e5                	mov    %esp,%ebp
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80088b:	eb 07                	jmp    800894 <strchr+0x13>
		if (*s == c)
  80088d:	38 ca                	cmp    %cl,%dl
  80088f:	74 0f                	je     8008a0 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800891:	83 c0 01             	add    $0x1,%eax
  800894:	0f b6 10             	movzbl (%eax),%edx
  800897:	84 d2                	test   %dl,%dl
  800899:	75 f2                	jne    80088d <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  80089b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008a0:	5d                   	pop    %ebp
  8008a1:	c3                   	ret    

008008a2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008a2:	55                   	push   %ebp
  8008a3:	89 e5                	mov    %esp,%ebp
  8008a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ac:	eb 03                	jmp    8008b1 <strfind+0xf>
  8008ae:	83 c0 01             	add    $0x1,%eax
  8008b1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008b4:	38 ca                	cmp    %cl,%dl
  8008b6:	74 04                	je     8008bc <strfind+0x1a>
  8008b8:	84 d2                	test   %dl,%dl
  8008ba:	75 f2                	jne    8008ae <strfind+0xc>
			break;
	return (char *) s;
}
  8008bc:	5d                   	pop    %ebp
  8008bd:	c3                   	ret    

008008be <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008be:	55                   	push   %ebp
  8008bf:	89 e5                	mov    %esp,%ebp
  8008c1:	57                   	push   %edi
  8008c2:	56                   	push   %esi
  8008c3:	53                   	push   %ebx
  8008c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8008c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  8008ca:	85 c9                	test   %ecx,%ecx
  8008cc:	74 37                	je     800905 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008ce:	f6 c2 03             	test   $0x3,%dl
  8008d1:	75 2a                	jne    8008fd <memset+0x3f>
  8008d3:	f6 c1 03             	test   $0x3,%cl
  8008d6:	75 25                	jne    8008fd <memset+0x3f>
		c &= 0xFF;
  8008d8:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008dc:	89 df                	mov    %ebx,%edi
  8008de:	c1 e7 08             	shl    $0x8,%edi
  8008e1:	89 de                	mov    %ebx,%esi
  8008e3:	c1 e6 18             	shl    $0x18,%esi
  8008e6:	89 d8                	mov    %ebx,%eax
  8008e8:	c1 e0 10             	shl    $0x10,%eax
  8008eb:	09 f0                	or     %esi,%eax
  8008ed:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8008ef:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8008f2:	89 f8                	mov    %edi,%eax
  8008f4:	09 d8                	or     %ebx,%eax
  8008f6:	89 d7                	mov    %edx,%edi
  8008f8:	fc                   	cld    
  8008f9:	f3 ab                	rep stos %eax,%es:(%edi)
  8008fb:	eb 08                	jmp    800905 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008fd:	89 d7                	mov    %edx,%edi
  8008ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800902:	fc                   	cld    
  800903:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800905:	89 d0                	mov    %edx,%eax
  800907:	5b                   	pop    %ebx
  800908:	5e                   	pop    %esi
  800909:	5f                   	pop    %edi
  80090a:	5d                   	pop    %ebp
  80090b:	c3                   	ret    

0080090c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	57                   	push   %edi
  800910:	56                   	push   %esi
  800911:	8b 45 08             	mov    0x8(%ebp),%eax
  800914:	8b 75 0c             	mov    0xc(%ebp),%esi
  800917:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80091a:	39 c6                	cmp    %eax,%esi
  80091c:	73 35                	jae    800953 <memmove+0x47>
  80091e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800921:	39 d0                	cmp    %edx,%eax
  800923:	73 2e                	jae    800953 <memmove+0x47>
		s += n;
		d += n;
  800925:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800928:	89 d6                	mov    %edx,%esi
  80092a:	09 fe                	or     %edi,%esi
  80092c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800932:	75 13                	jne    800947 <memmove+0x3b>
  800934:	f6 c1 03             	test   $0x3,%cl
  800937:	75 0e                	jne    800947 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  800939:	83 ef 04             	sub    $0x4,%edi
  80093c:	8d 72 fc             	lea    -0x4(%edx),%esi
  80093f:	c1 e9 02             	shr    $0x2,%ecx
  800942:	fd                   	std    
  800943:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800945:	eb 09                	jmp    800950 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800947:	83 ef 01             	sub    $0x1,%edi
  80094a:	8d 72 ff             	lea    -0x1(%edx),%esi
  80094d:	fd                   	std    
  80094e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800950:	fc                   	cld    
  800951:	eb 1d                	jmp    800970 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800953:	89 f2                	mov    %esi,%edx
  800955:	09 c2                	or     %eax,%edx
  800957:	f6 c2 03             	test   $0x3,%dl
  80095a:	75 0f                	jne    80096b <memmove+0x5f>
  80095c:	f6 c1 03             	test   $0x3,%cl
  80095f:	75 0a                	jne    80096b <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  800961:	c1 e9 02             	shr    $0x2,%ecx
  800964:	89 c7                	mov    %eax,%edi
  800966:	fc                   	cld    
  800967:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800969:	eb 05                	jmp    800970 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80096b:	89 c7                	mov    %eax,%edi
  80096d:	fc                   	cld    
  80096e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800970:	5e                   	pop    %esi
  800971:	5f                   	pop    %edi
  800972:	5d                   	pop    %ebp
  800973:	c3                   	ret    

00800974 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800977:	ff 75 10             	pushl  0x10(%ebp)
  80097a:	ff 75 0c             	pushl  0xc(%ebp)
  80097d:	ff 75 08             	pushl  0x8(%ebp)
  800980:	e8 87 ff ff ff       	call   80090c <memmove>
}
  800985:	c9                   	leave  
  800986:	c3                   	ret    

00800987 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	56                   	push   %esi
  80098b:	53                   	push   %ebx
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800992:	89 c6                	mov    %eax,%esi
  800994:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800997:	eb 1a                	jmp    8009b3 <memcmp+0x2c>
		if (*s1 != *s2)
  800999:	0f b6 08             	movzbl (%eax),%ecx
  80099c:	0f b6 1a             	movzbl (%edx),%ebx
  80099f:	38 d9                	cmp    %bl,%cl
  8009a1:	74 0a                	je     8009ad <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8009a3:	0f b6 c1             	movzbl %cl,%eax
  8009a6:	0f b6 db             	movzbl %bl,%ebx
  8009a9:	29 d8                	sub    %ebx,%eax
  8009ab:	eb 0f                	jmp    8009bc <memcmp+0x35>
		s1++, s2++;
  8009ad:	83 c0 01             	add    $0x1,%eax
  8009b0:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009b3:	39 f0                	cmp    %esi,%eax
  8009b5:	75 e2                	jne    800999 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8009b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009bc:	5b                   	pop    %ebx
  8009bd:	5e                   	pop    %esi
  8009be:	5d                   	pop    %ebp
  8009bf:	c3                   	ret    

008009c0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009c0:	55                   	push   %ebp
  8009c1:	89 e5                	mov    %esp,%ebp
  8009c3:	53                   	push   %ebx
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  8009c7:	89 c1                	mov    %eax,%ecx
  8009c9:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  8009cc:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8009d0:	eb 0a                	jmp    8009dc <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009d2:	0f b6 10             	movzbl (%eax),%edx
  8009d5:	39 da                	cmp    %ebx,%edx
  8009d7:	74 07                	je     8009e0 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8009d9:	83 c0 01             	add    $0x1,%eax
  8009dc:	39 c8                	cmp    %ecx,%eax
  8009de:	72 f2                	jb     8009d2 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8009e0:	5b                   	pop    %ebx
  8009e1:	5d                   	pop    %ebp
  8009e2:	c3                   	ret    

008009e3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	57                   	push   %edi
  8009e7:	56                   	push   %esi
  8009e8:	53                   	push   %ebx
  8009e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009ef:	eb 03                	jmp    8009f4 <strtol+0x11>
		s++;
  8009f1:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009f4:	0f b6 01             	movzbl (%ecx),%eax
  8009f7:	3c 20                	cmp    $0x20,%al
  8009f9:	74 f6                	je     8009f1 <strtol+0xe>
  8009fb:	3c 09                	cmp    $0x9,%al
  8009fd:	74 f2                	je     8009f1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8009ff:	3c 2b                	cmp    $0x2b,%al
  800a01:	75 0a                	jne    800a0d <strtol+0x2a>
		s++;
  800a03:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a06:	bf 00 00 00 00       	mov    $0x0,%edi
  800a0b:	eb 11                	jmp    800a1e <strtol+0x3b>
  800a0d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800a12:	3c 2d                	cmp    $0x2d,%al
  800a14:	75 08                	jne    800a1e <strtol+0x3b>
		s++, neg = 1;
  800a16:	83 c1 01             	add    $0x1,%ecx
  800a19:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a1e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a24:	75 15                	jne    800a3b <strtol+0x58>
  800a26:	80 39 30             	cmpb   $0x30,(%ecx)
  800a29:	75 10                	jne    800a3b <strtol+0x58>
  800a2b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a2f:	75 7c                	jne    800aad <strtol+0xca>
		s += 2, base = 16;
  800a31:	83 c1 02             	add    $0x2,%ecx
  800a34:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a39:	eb 16                	jmp    800a51 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800a3b:	85 db                	test   %ebx,%ebx
  800a3d:	75 12                	jne    800a51 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a3f:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a44:	80 39 30             	cmpb   $0x30,(%ecx)
  800a47:	75 08                	jne    800a51 <strtol+0x6e>
		s++, base = 8;
  800a49:	83 c1 01             	add    $0x1,%ecx
  800a4c:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800a51:	b8 00 00 00 00       	mov    $0x0,%eax
  800a56:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800a59:	0f b6 11             	movzbl (%ecx),%edx
  800a5c:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a5f:	89 f3                	mov    %esi,%ebx
  800a61:	80 fb 09             	cmp    $0x9,%bl
  800a64:	77 08                	ja     800a6e <strtol+0x8b>
			dig = *s - '0';
  800a66:	0f be d2             	movsbl %dl,%edx
  800a69:	83 ea 30             	sub    $0x30,%edx
  800a6c:	eb 22                	jmp    800a90 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800a6e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a71:	89 f3                	mov    %esi,%ebx
  800a73:	80 fb 19             	cmp    $0x19,%bl
  800a76:	77 08                	ja     800a80 <strtol+0x9d>
			dig = *s - 'a' + 10;
  800a78:	0f be d2             	movsbl %dl,%edx
  800a7b:	83 ea 57             	sub    $0x57,%edx
  800a7e:	eb 10                	jmp    800a90 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800a80:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a83:	89 f3                	mov    %esi,%ebx
  800a85:	80 fb 19             	cmp    $0x19,%bl
  800a88:	77 16                	ja     800aa0 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800a8a:	0f be d2             	movsbl %dl,%edx
  800a8d:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800a90:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a93:	7d 0b                	jge    800aa0 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800a95:	83 c1 01             	add    $0x1,%ecx
  800a98:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a9c:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800a9e:	eb b9                	jmp    800a59 <strtol+0x76>

	if (endptr)
  800aa0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aa4:	74 0d                	je     800ab3 <strtol+0xd0>
		*endptr = (char *) s;
  800aa6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aa9:	89 0e                	mov    %ecx,(%esi)
  800aab:	eb 06                	jmp    800ab3 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800aad:	85 db                	test   %ebx,%ebx
  800aaf:	74 98                	je     800a49 <strtol+0x66>
  800ab1:	eb 9e                	jmp    800a51 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800ab3:	89 c2                	mov    %eax,%edx
  800ab5:	f7 da                	neg    %edx
  800ab7:	85 ff                	test   %edi,%edi
  800ab9:	0f 45 c2             	cmovne %edx,%eax
}
  800abc:	5b                   	pop    %ebx
  800abd:	5e                   	pop    %esi
  800abe:	5f                   	pop    %edi
  800abf:	5d                   	pop    %ebp
  800ac0:	c3                   	ret    

00800ac1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800ac1:	55                   	push   %ebp
  800ac2:	89 e5                	mov    %esp,%ebp
  800ac4:	57                   	push   %edi
  800ac5:	56                   	push   %esi
  800ac6:	53                   	push   %ebx
  800ac7:	83 ec 1c             	sub    $0x1c,%esp
  800aca:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800acd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800ad0:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ad2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ad8:	8b 7d 10             	mov    0x10(%ebp),%edi
  800adb:	8b 75 14             	mov    0x14(%ebp),%esi
  800ade:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ae0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ae4:	74 1d                	je     800b03 <syscall+0x42>
  800ae6:	85 c0                	test   %eax,%eax
  800ae8:	7e 19                	jle    800b03 <syscall+0x42>
  800aea:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800aed:	83 ec 0c             	sub    $0xc,%esp
  800af0:	50                   	push   %eax
  800af1:	52                   	push   %edx
  800af2:	68 ff 21 80 00       	push   $0x8021ff
  800af7:	6a 23                	push   $0x23
  800af9:	68 1c 22 80 00       	push   $0x80221c
  800afe:	e8 2b f6 ff ff       	call   80012e <_panic>

	return ret;
}
  800b03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b06:	5b                   	pop    %ebx
  800b07:	5e                   	pop    %esi
  800b08:	5f                   	pop    %edi
  800b09:	5d                   	pop    %ebp
  800b0a:	c3                   	ret    

00800b0b <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
  800b0e:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800b11:	6a 00                	push   $0x0
  800b13:	6a 00                	push   $0x0
  800b15:	6a 00                	push   $0x0
  800b17:	ff 75 0c             	pushl  0xc(%ebp)
  800b1a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b22:	b8 00 00 00 00       	mov    $0x0,%eax
  800b27:	e8 95 ff ff ff       	call   800ac1 <syscall>
}
  800b2c:	83 c4 10             	add    $0x10,%esp
  800b2f:	c9                   	leave  
  800b30:	c3                   	ret    

00800b31 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
  800b34:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800b37:	6a 00                	push   $0x0
  800b39:	6a 00                	push   $0x0
  800b3b:	6a 00                	push   $0x0
  800b3d:	6a 00                	push   $0x0
  800b3f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b44:	ba 00 00 00 00       	mov    $0x0,%edx
  800b49:	b8 01 00 00 00       	mov    $0x1,%eax
  800b4e:	e8 6e ff ff ff       	call   800ac1 <syscall>
}
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800b5b:	6a 00                	push   $0x0
  800b5d:	6a 00                	push   $0x0
  800b5f:	6a 00                	push   $0x0
  800b61:	6a 00                	push   $0x0
  800b63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b66:	ba 01 00 00 00       	mov    $0x1,%edx
  800b6b:	b8 03 00 00 00       	mov    $0x3,%eax
  800b70:	e8 4c ff ff ff       	call   800ac1 <syscall>
}
  800b75:	c9                   	leave  
  800b76:	c3                   	ret    

00800b77 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b7d:	6a 00                	push   $0x0
  800b7f:	6a 00                	push   $0x0
  800b81:	6a 00                	push   $0x0
  800b83:	6a 00                	push   $0x0
  800b85:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8f:	b8 02 00 00 00       	mov    $0x2,%eax
  800b94:	e8 28 ff ff ff       	call   800ac1 <syscall>
}
  800b99:	c9                   	leave  
  800b9a:	c3                   	ret    

00800b9b <sys_yield>:

void
sys_yield(void)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800ba1:	6a 00                	push   $0x0
  800ba3:	6a 00                	push   $0x0
  800ba5:	6a 00                	push   $0x0
  800ba7:	6a 00                	push   $0x0
  800ba9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bae:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bb8:	e8 04 ff ff ff       	call   800ac1 <syscall>
}
  800bbd:	83 c4 10             	add    $0x10,%esp
  800bc0:	c9                   	leave  
  800bc1:	c3                   	ret    

00800bc2 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bc2:	55                   	push   %ebp
  800bc3:	89 e5                	mov    %esp,%ebp
  800bc5:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800bc8:	6a 00                	push   $0x0
  800bca:	6a 00                	push   $0x0
  800bcc:	ff 75 10             	pushl  0x10(%ebp)
  800bcf:	ff 75 0c             	pushl  0xc(%ebp)
  800bd2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd5:	ba 01 00 00 00       	mov    $0x1,%edx
  800bda:	b8 04 00 00 00       	mov    $0x4,%eax
  800bdf:	e8 dd fe ff ff       	call   800ac1 <syscall>
}
  800be4:	c9                   	leave  
  800be5:	c3                   	ret    

00800be6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800bec:	ff 75 18             	pushl  0x18(%ebp)
  800bef:	ff 75 14             	pushl  0x14(%ebp)
  800bf2:	ff 75 10             	pushl  0x10(%ebp)
  800bf5:	ff 75 0c             	pushl  0xc(%ebp)
  800bf8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bfb:	ba 01 00 00 00       	mov    $0x1,%edx
  800c00:	b8 05 00 00 00       	mov    $0x5,%eax
  800c05:	e8 b7 fe ff ff       	call   800ac1 <syscall>
}
  800c0a:	c9                   	leave  
  800c0b:	c3                   	ret    

00800c0c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800c12:	6a 00                	push   $0x0
  800c14:	6a 00                	push   $0x0
  800c16:	6a 00                	push   $0x0
  800c18:	ff 75 0c             	pushl  0xc(%ebp)
  800c1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c1e:	ba 01 00 00 00       	mov    $0x1,%edx
  800c23:	b8 06 00 00 00       	mov    $0x6,%eax
  800c28:	e8 94 fe ff ff       	call   800ac1 <syscall>
}
  800c2d:	c9                   	leave  
  800c2e:	c3                   	ret    

00800c2f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c35:	6a 00                	push   $0x0
  800c37:	6a 00                	push   $0x0
  800c39:	6a 00                	push   $0x0
  800c3b:	ff 75 0c             	pushl  0xc(%ebp)
  800c3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c41:	ba 01 00 00 00       	mov    $0x1,%edx
  800c46:	b8 08 00 00 00       	mov    $0x8,%eax
  800c4b:	e8 71 fe ff ff       	call   800ac1 <syscall>
}
  800c50:	c9                   	leave  
  800c51:	c3                   	ret    

00800c52 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800c58:	6a 00                	push   $0x0
  800c5a:	6a 00                	push   $0x0
  800c5c:	6a 00                	push   $0x0
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c64:	ba 01 00 00 00       	mov    $0x1,%edx
  800c69:	b8 09 00 00 00       	mov    $0x9,%eax
  800c6e:	e8 4e fe ff ff       	call   800ac1 <syscall>
}
  800c73:	c9                   	leave  
  800c74:	c3                   	ret    

00800c75 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800c7b:	6a 00                	push   $0x0
  800c7d:	6a 00                	push   $0x0
  800c7f:	6a 00                	push   $0x0
  800c81:	ff 75 0c             	pushl  0xc(%ebp)
  800c84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c87:	ba 01 00 00 00       	mov    $0x1,%edx
  800c8c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c91:	e8 2b fe ff ff       	call   800ac1 <syscall>
}
  800c96:	c9                   	leave  
  800c97:	c3                   	ret    

00800c98 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800c9e:	6a 00                	push   $0x0
  800ca0:	ff 75 14             	pushl  0x14(%ebp)
  800ca3:	ff 75 10             	pushl  0x10(%ebp)
  800ca6:	ff 75 0c             	pushl  0xc(%ebp)
  800ca9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cac:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cb6:	e8 06 fe ff ff       	call   800ac1 <syscall>
}
  800cbb:	c9                   	leave  
  800cbc:	c3                   	ret    

00800cbd <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800cc3:	6a 00                	push   $0x0
  800cc5:	6a 00                	push   $0x0
  800cc7:	6a 00                	push   $0x0
  800cc9:	6a 00                	push   $0x0
  800ccb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cce:	ba 01 00 00 00       	mov    $0x1,%edx
  800cd3:	b8 0d 00 00 00       	mov    $0xd,%eax
  800cd8:	e8 e4 fd ff ff       	call   800ac1 <syscall>
}
  800cdd:	c9                   	leave  
  800cde:	c3                   	ret    

00800cdf <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800ce5:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  800cec:	75 2c                	jne    800d1a <set_pgfault_handler+0x3b>
		// First time through!
		// LAB 4: Your code here.
		r = sys_page_alloc(0,(void *)(UXSTACKTOP - PGSIZE),PTE_P | PTE_U | PTE_W);
  800cee:	83 ec 04             	sub    $0x4,%esp
  800cf1:	6a 07                	push   $0x7
  800cf3:	68 00 f0 bf ee       	push   $0xeebff000
  800cf8:	6a 00                	push   $0x0
  800cfa:	e8 c3 fe ff ff       	call   800bc2 <sys_page_alloc>
		if(r < 0)
  800cff:	83 c4 10             	add    $0x10,%esp
  800d02:	85 c0                	test   %eax,%eax
  800d04:	79 14                	jns    800d1a <set_pgfault_handler+0x3b>
			panic("set_pgfault_handler: error in sys_page_alloc\n");	
  800d06:	83 ec 04             	sub    $0x4,%esp
  800d09:	68 2c 22 80 00       	push   $0x80222c
  800d0e:	6a 22                	push   $0x22
  800d10:	68 95 22 80 00       	push   $0x802295
  800d15:	e8 14 f4 ff ff       	call   80012e <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	a3 08 40 80 00       	mov    %eax,0x804008
	r = sys_env_set_pgfault_upcall(0, _pgfault_upcall); 
  800d22:	83 ec 08             	sub    $0x8,%esp
  800d25:	68 4e 0d 80 00       	push   $0x800d4e
  800d2a:	6a 00                	push   $0x0
  800d2c:	e8 44 ff ff ff       	call   800c75 <sys_env_set_pgfault_upcall>
	if (r < 0)
  800d31:	83 c4 10             	add    $0x10,%esp
  800d34:	85 c0                	test   %eax,%eax
  800d36:	79 14                	jns    800d4c <set_pgfault_handler+0x6d>
		panic("set_pgfault_handler: error in sys_env_set_pgfault_upcall");
  800d38:	83 ec 04             	sub    $0x4,%esp
  800d3b:	68 5c 22 80 00       	push   $0x80225c
  800d40:	6a 29                	push   $0x29
  800d42:	68 95 22 80 00       	push   $0x802295
  800d47:	e8 e2 f3 ff ff       	call   80012e <_panic>
}
  800d4c:	c9                   	leave  
  800d4d:	c3                   	ret    

00800d4e <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800d4e:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800d4f:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax
  800d54:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800d56:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	subl $0x4, 0x30(%esp)
  800d59:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  800d5e:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 0x28(%esp), %ebx 	
  800d62:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  800d66:	89 18                	mov    %ebx,(%eax)
	addl $0x8, %esp
  800d68:	83 c4 08             	add    $0x8,%esp


	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  800d6b:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp 
  800d6c:	83 c4 04             	add    $0x4,%esp
	popfl
  800d6f:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800d70:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  800d71:	c3                   	ret    

00800d72 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	05 00 00 00 30       	add    $0x30000000,%eax
  800d7d:	c1 e8 0c             	shr    $0xc,%eax
}
  800d80:	5d                   	pop    %ebp
  800d81:	c3                   	ret    

00800d82 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  800d85:	ff 75 08             	pushl  0x8(%ebp)
  800d88:	e8 e5 ff ff ff       	call   800d72 <fd2num>
  800d8d:	83 c4 04             	add    $0x4,%esp
  800d90:	c1 e0 0c             	shl    $0xc,%eax
  800d93:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800d98:	c9                   	leave  
  800d99:	c3                   	ret    

00800d9a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800da0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800da5:	89 c2                	mov    %eax,%edx
  800da7:	c1 ea 16             	shr    $0x16,%edx
  800daa:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800db1:	f6 c2 01             	test   $0x1,%dl
  800db4:	74 11                	je     800dc7 <fd_alloc+0x2d>
  800db6:	89 c2                	mov    %eax,%edx
  800db8:	c1 ea 0c             	shr    $0xc,%edx
  800dbb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800dc2:	f6 c2 01             	test   $0x1,%dl
  800dc5:	75 09                	jne    800dd0 <fd_alloc+0x36>
			*fd_store = fd;
  800dc7:	89 01                	mov    %eax,(%ecx)
			return 0;
  800dc9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dce:	eb 17                	jmp    800de7 <fd_alloc+0x4d>
  800dd0:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800dd5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800dda:	75 c9                	jne    800da5 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ddc:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800de2:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800de7:	5d                   	pop    %ebp
  800de8:	c3                   	ret    

00800de9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800def:	83 f8 1f             	cmp    $0x1f,%eax
  800df2:	77 36                	ja     800e2a <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800df4:	c1 e0 0c             	shl    $0xc,%eax
  800df7:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800dfc:	89 c2                	mov    %eax,%edx
  800dfe:	c1 ea 16             	shr    $0x16,%edx
  800e01:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e08:	f6 c2 01             	test   $0x1,%dl
  800e0b:	74 24                	je     800e31 <fd_lookup+0x48>
  800e0d:	89 c2                	mov    %eax,%edx
  800e0f:	c1 ea 0c             	shr    $0xc,%edx
  800e12:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e19:	f6 c2 01             	test   $0x1,%dl
  800e1c:	74 1a                	je     800e38 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e21:	89 02                	mov    %eax,(%edx)
	return 0;
  800e23:	b8 00 00 00 00       	mov    $0x0,%eax
  800e28:	eb 13                	jmp    800e3d <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800e2a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e2f:	eb 0c                	jmp    800e3d <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800e31:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e36:	eb 05                	jmp    800e3d <fd_lookup+0x54>
  800e38:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    

00800e3f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	83 ec 08             	sub    $0x8,%esp
  800e45:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e48:	ba 24 23 80 00       	mov    $0x802324,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800e4d:	eb 13                	jmp    800e62 <dev_lookup+0x23>
  800e4f:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  800e52:	39 08                	cmp    %ecx,(%eax)
  800e54:	75 0c                	jne    800e62 <dev_lookup+0x23>
			*dev = devtab[i];
  800e56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e59:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e5b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e60:	eb 2e                	jmp    800e90 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800e62:	8b 02                	mov    (%edx),%eax
  800e64:	85 c0                	test   %eax,%eax
  800e66:	75 e7                	jne    800e4f <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e68:	a1 04 40 80 00       	mov    0x804004,%eax
  800e6d:	8b 40 48             	mov    0x48(%eax),%eax
  800e70:	83 ec 04             	sub    $0x4,%esp
  800e73:	51                   	push   %ecx
  800e74:	50                   	push   %eax
  800e75:	68 a4 22 80 00       	push   $0x8022a4
  800e7a:	e8 88 f3 ff ff       	call   800207 <cprintf>
	*dev = 0;
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e88:	83 c4 10             	add    $0x10,%esp
  800e8b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	56                   	push   %esi
  800e96:	53                   	push   %ebx
  800e97:	83 ec 10             	sub    $0x10,%esp
  800e9a:	8b 75 08             	mov    0x8(%ebp),%esi
  800e9d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ea0:	56                   	push   %esi
  800ea1:	e8 cc fe ff ff       	call   800d72 <fd2num>
  800ea6:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800ea9:	89 14 24             	mov    %edx,(%esp)
  800eac:	50                   	push   %eax
  800ead:	e8 37 ff ff ff       	call   800de9 <fd_lookup>
  800eb2:	83 c4 08             	add    $0x8,%esp
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	78 05                	js     800ebe <fd_close+0x2c>
	    || fd != fd2)
  800eb9:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800ebc:	74 0c                	je     800eca <fd_close+0x38>
		return (must_exist ? r : 0);
  800ebe:	84 db                	test   %bl,%bl
  800ec0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec5:	0f 44 c2             	cmove  %edx,%eax
  800ec8:	eb 41                	jmp    800f0b <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800eca:	83 ec 08             	sub    $0x8,%esp
  800ecd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ed0:	50                   	push   %eax
  800ed1:	ff 36                	pushl  (%esi)
  800ed3:	e8 67 ff ff ff       	call   800e3f <dev_lookup>
  800ed8:	89 c3                	mov    %eax,%ebx
  800eda:	83 c4 10             	add    $0x10,%esp
  800edd:	85 c0                	test   %eax,%eax
  800edf:	78 1a                	js     800efb <fd_close+0x69>
		if (dev->dev_close)
  800ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee4:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800ee7:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800eec:	85 c0                	test   %eax,%eax
  800eee:	74 0b                	je     800efb <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  800ef0:	83 ec 0c             	sub    $0xc,%esp
  800ef3:	56                   	push   %esi
  800ef4:	ff d0                	call   *%eax
  800ef6:	89 c3                	mov    %eax,%ebx
  800ef8:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800efb:	83 ec 08             	sub    $0x8,%esp
  800efe:	56                   	push   %esi
  800eff:	6a 00                	push   $0x0
  800f01:	e8 06 fd ff ff       	call   800c0c <sys_page_unmap>
	return r;
  800f06:	83 c4 10             	add    $0x10,%esp
  800f09:	89 d8                	mov    %ebx,%eax
}
  800f0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f0e:	5b                   	pop    %ebx
  800f0f:	5e                   	pop    %esi
  800f10:	5d                   	pop    %ebp
  800f11:	c3                   	ret    

00800f12 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f1b:	50                   	push   %eax
  800f1c:	ff 75 08             	pushl  0x8(%ebp)
  800f1f:	e8 c5 fe ff ff       	call   800de9 <fd_lookup>
  800f24:	83 c4 08             	add    $0x8,%esp
  800f27:	85 c0                	test   %eax,%eax
  800f29:	78 10                	js     800f3b <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800f2b:	83 ec 08             	sub    $0x8,%esp
  800f2e:	6a 01                	push   $0x1
  800f30:	ff 75 f4             	pushl  -0xc(%ebp)
  800f33:	e8 5a ff ff ff       	call   800e92 <fd_close>
  800f38:	83 c4 10             	add    $0x10,%esp
}
  800f3b:	c9                   	leave  
  800f3c:	c3                   	ret    

00800f3d <close_all>:

void
close_all(void)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	53                   	push   %ebx
  800f41:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f44:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f49:	83 ec 0c             	sub    $0xc,%esp
  800f4c:	53                   	push   %ebx
  800f4d:	e8 c0 ff ff ff       	call   800f12 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800f52:	83 c3 01             	add    $0x1,%ebx
  800f55:	83 c4 10             	add    $0x10,%esp
  800f58:	83 fb 20             	cmp    $0x20,%ebx
  800f5b:	75 ec                	jne    800f49 <close_all+0xc>
		close(i);
}
  800f5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f60:	c9                   	leave  
  800f61:	c3                   	ret    

00800f62 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	57                   	push   %edi
  800f66:	56                   	push   %esi
  800f67:	53                   	push   %ebx
  800f68:	83 ec 2c             	sub    $0x2c,%esp
  800f6b:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f6e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f71:	50                   	push   %eax
  800f72:	ff 75 08             	pushl  0x8(%ebp)
  800f75:	e8 6f fe ff ff       	call   800de9 <fd_lookup>
  800f7a:	83 c4 08             	add    $0x8,%esp
  800f7d:	85 c0                	test   %eax,%eax
  800f7f:	0f 88 c1 00 00 00    	js     801046 <dup+0xe4>
		return r;
	close(newfdnum);
  800f85:	83 ec 0c             	sub    $0xc,%esp
  800f88:	56                   	push   %esi
  800f89:	e8 84 ff ff ff       	call   800f12 <close>

	newfd = INDEX2FD(newfdnum);
  800f8e:	89 f3                	mov    %esi,%ebx
  800f90:	c1 e3 0c             	shl    $0xc,%ebx
  800f93:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800f99:	83 c4 04             	add    $0x4,%esp
  800f9c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f9f:	e8 de fd ff ff       	call   800d82 <fd2data>
  800fa4:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  800fa6:	89 1c 24             	mov    %ebx,(%esp)
  800fa9:	e8 d4 fd ff ff       	call   800d82 <fd2data>
  800fae:	83 c4 10             	add    $0x10,%esp
  800fb1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800fb4:	89 f8                	mov    %edi,%eax
  800fb6:	c1 e8 16             	shr    $0x16,%eax
  800fb9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fc0:	a8 01                	test   $0x1,%al
  800fc2:	74 37                	je     800ffb <dup+0x99>
  800fc4:	89 f8                	mov    %edi,%eax
  800fc6:	c1 e8 0c             	shr    $0xc,%eax
  800fc9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fd0:	f6 c2 01             	test   $0x1,%dl
  800fd3:	74 26                	je     800ffb <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800fd5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fdc:	83 ec 0c             	sub    $0xc,%esp
  800fdf:	25 07 0e 00 00       	and    $0xe07,%eax
  800fe4:	50                   	push   %eax
  800fe5:	ff 75 d4             	pushl  -0x2c(%ebp)
  800fe8:	6a 00                	push   $0x0
  800fea:	57                   	push   %edi
  800feb:	6a 00                	push   $0x0
  800fed:	e8 f4 fb ff ff       	call   800be6 <sys_page_map>
  800ff2:	89 c7                	mov    %eax,%edi
  800ff4:	83 c4 20             	add    $0x20,%esp
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	78 2e                	js     801029 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800ffb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ffe:	89 d0                	mov    %edx,%eax
  801000:	c1 e8 0c             	shr    $0xc,%eax
  801003:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80100a:	83 ec 0c             	sub    $0xc,%esp
  80100d:	25 07 0e 00 00       	and    $0xe07,%eax
  801012:	50                   	push   %eax
  801013:	53                   	push   %ebx
  801014:	6a 00                	push   $0x0
  801016:	52                   	push   %edx
  801017:	6a 00                	push   $0x0
  801019:	e8 c8 fb ff ff       	call   800be6 <sys_page_map>
  80101e:	89 c7                	mov    %eax,%edi
  801020:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  801023:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801025:	85 ff                	test   %edi,%edi
  801027:	79 1d                	jns    801046 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801029:	83 ec 08             	sub    $0x8,%esp
  80102c:	53                   	push   %ebx
  80102d:	6a 00                	push   $0x0
  80102f:	e8 d8 fb ff ff       	call   800c0c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801034:	83 c4 08             	add    $0x8,%esp
  801037:	ff 75 d4             	pushl  -0x2c(%ebp)
  80103a:	6a 00                	push   $0x0
  80103c:	e8 cb fb ff ff       	call   800c0c <sys_page_unmap>
	return r;
  801041:	83 c4 10             	add    $0x10,%esp
  801044:	89 f8                	mov    %edi,%eax
}
  801046:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801049:	5b                   	pop    %ebx
  80104a:	5e                   	pop    %esi
  80104b:	5f                   	pop    %edi
  80104c:	5d                   	pop    %ebp
  80104d:	c3                   	ret    

0080104e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80104e:	55                   	push   %ebp
  80104f:	89 e5                	mov    %esp,%ebp
  801051:	53                   	push   %ebx
  801052:	83 ec 14             	sub    $0x14,%esp
  801055:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801058:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80105b:	50                   	push   %eax
  80105c:	53                   	push   %ebx
  80105d:	e8 87 fd ff ff       	call   800de9 <fd_lookup>
  801062:	83 c4 08             	add    $0x8,%esp
  801065:	89 c2                	mov    %eax,%edx
  801067:	85 c0                	test   %eax,%eax
  801069:	78 6d                	js     8010d8 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80106b:	83 ec 08             	sub    $0x8,%esp
  80106e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801071:	50                   	push   %eax
  801072:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801075:	ff 30                	pushl  (%eax)
  801077:	e8 c3 fd ff ff       	call   800e3f <dev_lookup>
  80107c:	83 c4 10             	add    $0x10,%esp
  80107f:	85 c0                	test   %eax,%eax
  801081:	78 4c                	js     8010cf <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801083:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801086:	8b 42 08             	mov    0x8(%edx),%eax
  801089:	83 e0 03             	and    $0x3,%eax
  80108c:	83 f8 01             	cmp    $0x1,%eax
  80108f:	75 21                	jne    8010b2 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801091:	a1 04 40 80 00       	mov    0x804004,%eax
  801096:	8b 40 48             	mov    0x48(%eax),%eax
  801099:	83 ec 04             	sub    $0x4,%esp
  80109c:	53                   	push   %ebx
  80109d:	50                   	push   %eax
  80109e:	68 e8 22 80 00       	push   $0x8022e8
  8010a3:	e8 5f f1 ff ff       	call   800207 <cprintf>
		return -E_INVAL;
  8010a8:	83 c4 10             	add    $0x10,%esp
  8010ab:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8010b0:	eb 26                	jmp    8010d8 <read+0x8a>
	}
	if (!dev->dev_read)
  8010b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b5:	8b 40 08             	mov    0x8(%eax),%eax
  8010b8:	85 c0                	test   %eax,%eax
  8010ba:	74 17                	je     8010d3 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8010bc:	83 ec 04             	sub    $0x4,%esp
  8010bf:	ff 75 10             	pushl  0x10(%ebp)
  8010c2:	ff 75 0c             	pushl  0xc(%ebp)
  8010c5:	52                   	push   %edx
  8010c6:	ff d0                	call   *%eax
  8010c8:	89 c2                	mov    %eax,%edx
  8010ca:	83 c4 10             	add    $0x10,%esp
  8010cd:	eb 09                	jmp    8010d8 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010cf:	89 c2                	mov    %eax,%edx
  8010d1:	eb 05                	jmp    8010d8 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8010d3:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  8010d8:	89 d0                	mov    %edx,%eax
  8010da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010dd:	c9                   	leave  
  8010de:	c3                   	ret    

008010df <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
  8010e2:	57                   	push   %edi
  8010e3:	56                   	push   %esi
  8010e4:	53                   	push   %ebx
  8010e5:	83 ec 0c             	sub    $0xc,%esp
  8010e8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010eb:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8010ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f3:	eb 21                	jmp    801116 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010f5:	83 ec 04             	sub    $0x4,%esp
  8010f8:	89 f0                	mov    %esi,%eax
  8010fa:	29 d8                	sub    %ebx,%eax
  8010fc:	50                   	push   %eax
  8010fd:	89 d8                	mov    %ebx,%eax
  8010ff:	03 45 0c             	add    0xc(%ebp),%eax
  801102:	50                   	push   %eax
  801103:	57                   	push   %edi
  801104:	e8 45 ff ff ff       	call   80104e <read>
		if (m < 0)
  801109:	83 c4 10             	add    $0x10,%esp
  80110c:	85 c0                	test   %eax,%eax
  80110e:	78 10                	js     801120 <readn+0x41>
			return m;
		if (m == 0)
  801110:	85 c0                	test   %eax,%eax
  801112:	74 0a                	je     80111e <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801114:	01 c3                	add    %eax,%ebx
  801116:	39 f3                	cmp    %esi,%ebx
  801118:	72 db                	jb     8010f5 <readn+0x16>
  80111a:	89 d8                	mov    %ebx,%eax
  80111c:	eb 02                	jmp    801120 <readn+0x41>
  80111e:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801120:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801123:	5b                   	pop    %ebx
  801124:	5e                   	pop    %esi
  801125:	5f                   	pop    %edi
  801126:	5d                   	pop    %ebp
  801127:	c3                   	ret    

00801128 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	53                   	push   %ebx
  80112c:	83 ec 14             	sub    $0x14,%esp
  80112f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801132:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801135:	50                   	push   %eax
  801136:	53                   	push   %ebx
  801137:	e8 ad fc ff ff       	call   800de9 <fd_lookup>
  80113c:	83 c4 08             	add    $0x8,%esp
  80113f:	89 c2                	mov    %eax,%edx
  801141:	85 c0                	test   %eax,%eax
  801143:	78 68                	js     8011ad <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801145:	83 ec 08             	sub    $0x8,%esp
  801148:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80114b:	50                   	push   %eax
  80114c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80114f:	ff 30                	pushl  (%eax)
  801151:	e8 e9 fc ff ff       	call   800e3f <dev_lookup>
  801156:	83 c4 10             	add    $0x10,%esp
  801159:	85 c0                	test   %eax,%eax
  80115b:	78 47                	js     8011a4 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80115d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801160:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801164:	75 21                	jne    801187 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801166:	a1 04 40 80 00       	mov    0x804004,%eax
  80116b:	8b 40 48             	mov    0x48(%eax),%eax
  80116e:	83 ec 04             	sub    $0x4,%esp
  801171:	53                   	push   %ebx
  801172:	50                   	push   %eax
  801173:	68 04 23 80 00       	push   $0x802304
  801178:	e8 8a f0 ff ff       	call   800207 <cprintf>
		return -E_INVAL;
  80117d:	83 c4 10             	add    $0x10,%esp
  801180:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801185:	eb 26                	jmp    8011ad <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801187:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80118a:	8b 52 0c             	mov    0xc(%edx),%edx
  80118d:	85 d2                	test   %edx,%edx
  80118f:	74 17                	je     8011a8 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801191:	83 ec 04             	sub    $0x4,%esp
  801194:	ff 75 10             	pushl  0x10(%ebp)
  801197:	ff 75 0c             	pushl  0xc(%ebp)
  80119a:	50                   	push   %eax
  80119b:	ff d2                	call   *%edx
  80119d:	89 c2                	mov    %eax,%edx
  80119f:	83 c4 10             	add    $0x10,%esp
  8011a2:	eb 09                	jmp    8011ad <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011a4:	89 c2                	mov    %eax,%edx
  8011a6:	eb 05                	jmp    8011ad <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8011a8:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  8011ad:	89 d0                	mov    %edx,%eax
  8011af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    

008011b4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011ba:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8011bd:	50                   	push   %eax
  8011be:	ff 75 08             	pushl  0x8(%ebp)
  8011c1:	e8 23 fc ff ff       	call   800de9 <fd_lookup>
  8011c6:	83 c4 08             	add    $0x8,%esp
  8011c9:	85 c0                	test   %eax,%eax
  8011cb:	78 0e                	js     8011db <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8011cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d3:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8011d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011db:	c9                   	leave  
  8011dc:	c3                   	ret    

008011dd <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	53                   	push   %ebx
  8011e1:	83 ec 14             	sub    $0x14,%esp
  8011e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011ea:	50                   	push   %eax
  8011eb:	53                   	push   %ebx
  8011ec:	e8 f8 fb ff ff       	call   800de9 <fd_lookup>
  8011f1:	83 c4 08             	add    $0x8,%esp
  8011f4:	89 c2                	mov    %eax,%edx
  8011f6:	85 c0                	test   %eax,%eax
  8011f8:	78 65                	js     80125f <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011fa:	83 ec 08             	sub    $0x8,%esp
  8011fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801200:	50                   	push   %eax
  801201:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801204:	ff 30                	pushl  (%eax)
  801206:	e8 34 fc ff ff       	call   800e3f <dev_lookup>
  80120b:	83 c4 10             	add    $0x10,%esp
  80120e:	85 c0                	test   %eax,%eax
  801210:	78 44                	js     801256 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801215:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801219:	75 21                	jne    80123c <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80121b:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801220:	8b 40 48             	mov    0x48(%eax),%eax
  801223:	83 ec 04             	sub    $0x4,%esp
  801226:	53                   	push   %ebx
  801227:	50                   	push   %eax
  801228:	68 c4 22 80 00       	push   $0x8022c4
  80122d:	e8 d5 ef ff ff       	call   800207 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801232:	83 c4 10             	add    $0x10,%esp
  801235:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80123a:	eb 23                	jmp    80125f <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  80123c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80123f:	8b 52 18             	mov    0x18(%edx),%edx
  801242:	85 d2                	test   %edx,%edx
  801244:	74 14                	je     80125a <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801246:	83 ec 08             	sub    $0x8,%esp
  801249:	ff 75 0c             	pushl  0xc(%ebp)
  80124c:	50                   	push   %eax
  80124d:	ff d2                	call   *%edx
  80124f:	89 c2                	mov    %eax,%edx
  801251:	83 c4 10             	add    $0x10,%esp
  801254:	eb 09                	jmp    80125f <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801256:	89 c2                	mov    %eax,%edx
  801258:	eb 05                	jmp    80125f <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80125a:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  80125f:	89 d0                	mov    %edx,%eax
  801261:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801264:	c9                   	leave  
  801265:	c3                   	ret    

00801266 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
  801269:	53                   	push   %ebx
  80126a:	83 ec 14             	sub    $0x14,%esp
  80126d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801270:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801273:	50                   	push   %eax
  801274:	ff 75 08             	pushl  0x8(%ebp)
  801277:	e8 6d fb ff ff       	call   800de9 <fd_lookup>
  80127c:	83 c4 08             	add    $0x8,%esp
  80127f:	89 c2                	mov    %eax,%edx
  801281:	85 c0                	test   %eax,%eax
  801283:	78 58                	js     8012dd <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801285:	83 ec 08             	sub    $0x8,%esp
  801288:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80128b:	50                   	push   %eax
  80128c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128f:	ff 30                	pushl  (%eax)
  801291:	e8 a9 fb ff ff       	call   800e3f <dev_lookup>
  801296:	83 c4 10             	add    $0x10,%esp
  801299:	85 c0                	test   %eax,%eax
  80129b:	78 37                	js     8012d4 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  80129d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a0:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8012a4:	74 32                	je     8012d8 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8012a6:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8012a9:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8012b0:	00 00 00 
	stat->st_isdir = 0;
  8012b3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8012ba:	00 00 00 
	stat->st_dev = dev;
  8012bd:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8012c3:	83 ec 08             	sub    $0x8,%esp
  8012c6:	53                   	push   %ebx
  8012c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8012ca:	ff 50 14             	call   *0x14(%eax)
  8012cd:	89 c2                	mov    %eax,%edx
  8012cf:	83 c4 10             	add    $0x10,%esp
  8012d2:	eb 09                	jmp    8012dd <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012d4:	89 c2                	mov    %eax,%edx
  8012d6:	eb 05                	jmp    8012dd <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8012d8:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8012dd:	89 d0                	mov    %edx,%eax
  8012df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012e2:	c9                   	leave  
  8012e3:	c3                   	ret    

008012e4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
  8012e7:	56                   	push   %esi
  8012e8:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8012e9:	83 ec 08             	sub    $0x8,%esp
  8012ec:	6a 00                	push   $0x0
  8012ee:	ff 75 08             	pushl  0x8(%ebp)
  8012f1:	e8 06 02 00 00       	call   8014fc <open>
  8012f6:	89 c3                	mov    %eax,%ebx
  8012f8:	83 c4 10             	add    $0x10,%esp
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	78 1b                	js     80131a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8012ff:	83 ec 08             	sub    $0x8,%esp
  801302:	ff 75 0c             	pushl  0xc(%ebp)
  801305:	50                   	push   %eax
  801306:	e8 5b ff ff ff       	call   801266 <fstat>
  80130b:	89 c6                	mov    %eax,%esi
	close(fd);
  80130d:	89 1c 24             	mov    %ebx,(%esp)
  801310:	e8 fd fb ff ff       	call   800f12 <close>
	return r;
  801315:	83 c4 10             	add    $0x10,%esp
  801318:	89 f0                	mov    %esi,%eax
}
  80131a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80131d:	5b                   	pop    %ebx
  80131e:	5e                   	pop    %esi
  80131f:	5d                   	pop    %ebp
  801320:	c3                   	ret    

00801321 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	56                   	push   %esi
  801325:	53                   	push   %ebx
  801326:	89 c6                	mov    %eax,%esi
  801328:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80132a:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801331:	75 12                	jne    801345 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801333:	83 ec 0c             	sub    $0xc,%esp
  801336:	6a 01                	push   $0x1
  801338:	e8 01 08 00 00       	call   801b3e <ipc_find_env>
  80133d:	a3 00 40 80 00       	mov    %eax,0x804000
  801342:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801345:	6a 07                	push   $0x7
  801347:	68 00 50 80 00       	push   $0x805000
  80134c:	56                   	push   %esi
  80134d:	ff 35 00 40 80 00    	pushl  0x804000
  801353:	e8 92 07 00 00       	call   801aea <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801358:	83 c4 0c             	add    $0xc,%esp
  80135b:	6a 00                	push   $0x0
  80135d:	53                   	push   %ebx
  80135e:	6a 00                	push   $0x0
  801360:	e8 1a 07 00 00       	call   801a7f <ipc_recv>
}
  801365:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801368:	5b                   	pop    %ebx
  801369:	5e                   	pop    %esi
  80136a:	5d                   	pop    %ebp
  80136b:	c3                   	ret    

0080136c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	8b 40 0c             	mov    0xc(%eax),%eax
  801378:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80137d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801380:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801385:	ba 00 00 00 00       	mov    $0x0,%edx
  80138a:	b8 02 00 00 00       	mov    $0x2,%eax
  80138f:	e8 8d ff ff ff       	call   801321 <fsipc>
}
  801394:	c9                   	leave  
  801395:	c3                   	ret    

00801396 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801396:	55                   	push   %ebp
  801397:	89 e5                	mov    %esp,%ebp
  801399:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	8b 40 0c             	mov    0xc(%eax),%eax
  8013a2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8013a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ac:	b8 06 00 00 00       	mov    $0x6,%eax
  8013b1:	e8 6b ff ff ff       	call   801321 <fsipc>
}
  8013b6:	c9                   	leave  
  8013b7:	c3                   	ret    

008013b8 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
  8013bb:	53                   	push   %ebx
  8013bc:	83 ec 04             	sub    $0x4,%esp
  8013bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8013c8:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8013cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d2:	b8 05 00 00 00       	mov    $0x5,%eax
  8013d7:	e8 45 ff ff ff       	call   801321 <fsipc>
  8013dc:	85 c0                	test   %eax,%eax
  8013de:	78 2c                	js     80140c <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8013e0:	83 ec 08             	sub    $0x8,%esp
  8013e3:	68 00 50 80 00       	push   $0x805000
  8013e8:	53                   	push   %ebx
  8013e9:	e8 8b f3 ff ff       	call   800779 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8013ee:	a1 80 50 80 00       	mov    0x805080,%eax
  8013f3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8013f9:	a1 84 50 80 00       	mov    0x805084,%eax
  8013fe:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801404:	83 c4 10             	add    $0x10,%esp
  801407:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80140c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80140f:	c9                   	leave  
  801410:	c3                   	ret    

00801411 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
  801414:	83 ec 08             	sub    $0x8,%esp
  801417:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141a:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80141d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801420:	8b 49 0c             	mov    0xc(%ecx),%ecx
  801423:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  801429:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80142e:	76 22                	jbe    801452 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  801430:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  801437:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  80143a:	83 ec 04             	sub    $0x4,%esp
  80143d:	68 f8 0f 00 00       	push   $0xff8
  801442:	52                   	push   %edx
  801443:	68 08 50 80 00       	push   $0x805008
  801448:	e8 bf f4 ff ff       	call   80090c <memmove>
  80144d:	83 c4 10             	add    $0x10,%esp
  801450:	eb 17                	jmp    801469 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  801452:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  801457:	83 ec 04             	sub    $0x4,%esp
  80145a:	50                   	push   %eax
  80145b:	52                   	push   %edx
  80145c:	68 08 50 80 00       	push   $0x805008
  801461:	e8 a6 f4 ff ff       	call   80090c <memmove>
  801466:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  801469:	ba 00 00 00 00       	mov    $0x0,%edx
  80146e:	b8 04 00 00 00       	mov    $0x4,%eax
  801473:	e8 a9 fe ff ff       	call   801321 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  801478:	c9                   	leave  
  801479:	c3                   	ret    

0080147a <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80147a:	55                   	push   %ebp
  80147b:	89 e5                	mov    %esp,%ebp
  80147d:	56                   	push   %esi
  80147e:	53                   	push   %ebx
  80147f:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8b 40 0c             	mov    0xc(%eax),%eax
  801488:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80148d:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801493:	ba 00 00 00 00       	mov    $0x0,%edx
  801498:	b8 03 00 00 00       	mov    $0x3,%eax
  80149d:	e8 7f fe ff ff       	call   801321 <fsipc>
  8014a2:	89 c3                	mov    %eax,%ebx
  8014a4:	85 c0                	test   %eax,%eax
  8014a6:	78 4b                	js     8014f3 <devfile_read+0x79>
		return r;
	assert(r <= n);
  8014a8:	39 c6                	cmp    %eax,%esi
  8014aa:	73 16                	jae    8014c2 <devfile_read+0x48>
  8014ac:	68 34 23 80 00       	push   $0x802334
  8014b1:	68 3b 23 80 00       	push   $0x80233b
  8014b6:	6a 7c                	push   $0x7c
  8014b8:	68 50 23 80 00       	push   $0x802350
  8014bd:	e8 6c ec ff ff       	call   80012e <_panic>
	assert(r <= PGSIZE);
  8014c2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8014c7:	7e 16                	jle    8014df <devfile_read+0x65>
  8014c9:	68 5b 23 80 00       	push   $0x80235b
  8014ce:	68 3b 23 80 00       	push   $0x80233b
  8014d3:	6a 7d                	push   $0x7d
  8014d5:	68 50 23 80 00       	push   $0x802350
  8014da:	e8 4f ec ff ff       	call   80012e <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8014df:	83 ec 04             	sub    $0x4,%esp
  8014e2:	50                   	push   %eax
  8014e3:	68 00 50 80 00       	push   $0x805000
  8014e8:	ff 75 0c             	pushl  0xc(%ebp)
  8014eb:	e8 1c f4 ff ff       	call   80090c <memmove>
	return r;
  8014f0:	83 c4 10             	add    $0x10,%esp
}
  8014f3:	89 d8                	mov    %ebx,%eax
  8014f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014f8:	5b                   	pop    %ebx
  8014f9:	5e                   	pop    %esi
  8014fa:	5d                   	pop    %ebp
  8014fb:	c3                   	ret    

008014fc <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	53                   	push   %ebx
  801500:	83 ec 20             	sub    $0x20,%esp
  801503:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801506:	53                   	push   %ebx
  801507:	e8 34 f2 ff ff       	call   800740 <strlen>
  80150c:	83 c4 10             	add    $0x10,%esp
  80150f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801514:	7f 67                	jg     80157d <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801516:	83 ec 0c             	sub    $0xc,%esp
  801519:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80151c:	50                   	push   %eax
  80151d:	e8 78 f8 ff ff       	call   800d9a <fd_alloc>
  801522:	83 c4 10             	add    $0x10,%esp
		return r;
  801525:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801527:	85 c0                	test   %eax,%eax
  801529:	78 57                	js     801582 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80152b:	83 ec 08             	sub    $0x8,%esp
  80152e:	53                   	push   %ebx
  80152f:	68 00 50 80 00       	push   $0x805000
  801534:	e8 40 f2 ff ff       	call   800779 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801539:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153c:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801541:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801544:	b8 01 00 00 00       	mov    $0x1,%eax
  801549:	e8 d3 fd ff ff       	call   801321 <fsipc>
  80154e:	89 c3                	mov    %eax,%ebx
  801550:	83 c4 10             	add    $0x10,%esp
  801553:	85 c0                	test   %eax,%eax
  801555:	79 14                	jns    80156b <open+0x6f>
		fd_close(fd, 0);
  801557:	83 ec 08             	sub    $0x8,%esp
  80155a:	6a 00                	push   $0x0
  80155c:	ff 75 f4             	pushl  -0xc(%ebp)
  80155f:	e8 2e f9 ff ff       	call   800e92 <fd_close>
		return r;
  801564:	83 c4 10             	add    $0x10,%esp
  801567:	89 da                	mov    %ebx,%edx
  801569:	eb 17                	jmp    801582 <open+0x86>
	}

	return fd2num(fd);
  80156b:	83 ec 0c             	sub    $0xc,%esp
  80156e:	ff 75 f4             	pushl  -0xc(%ebp)
  801571:	e8 fc f7 ff ff       	call   800d72 <fd2num>
  801576:	89 c2                	mov    %eax,%edx
  801578:	83 c4 10             	add    $0x10,%esp
  80157b:	eb 05                	jmp    801582 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80157d:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801582:	89 d0                	mov    %edx,%eax
  801584:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80158f:	ba 00 00 00 00       	mov    $0x0,%edx
  801594:	b8 08 00 00 00       	mov    $0x8,%eax
  801599:	e8 83 fd ff ff       	call   801321 <fsipc>
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	56                   	push   %esi
  8015a4:	53                   	push   %ebx
  8015a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8015a8:	83 ec 0c             	sub    $0xc,%esp
  8015ab:	ff 75 08             	pushl  0x8(%ebp)
  8015ae:	e8 cf f7 ff ff       	call   800d82 <fd2data>
  8015b3:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8015b5:	83 c4 08             	add    $0x8,%esp
  8015b8:	68 67 23 80 00       	push   $0x802367
  8015bd:	53                   	push   %ebx
  8015be:	e8 b6 f1 ff ff       	call   800779 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8015c3:	8b 46 04             	mov    0x4(%esi),%eax
  8015c6:	2b 06                	sub    (%esi),%eax
  8015c8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8015ce:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015d5:	00 00 00 
	stat->st_dev = &devpipe;
  8015d8:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8015df:	30 80 00 
	return 0;
}
  8015e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ea:	5b                   	pop    %ebx
  8015eb:	5e                   	pop    %esi
  8015ec:	5d                   	pop    %ebp
  8015ed:	c3                   	ret    

008015ee <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
  8015f1:	53                   	push   %ebx
  8015f2:	83 ec 0c             	sub    $0xc,%esp
  8015f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8015f8:	53                   	push   %ebx
  8015f9:	6a 00                	push   $0x0
  8015fb:	e8 0c f6 ff ff       	call   800c0c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801600:	89 1c 24             	mov    %ebx,(%esp)
  801603:	e8 7a f7 ff ff       	call   800d82 <fd2data>
  801608:	83 c4 08             	add    $0x8,%esp
  80160b:	50                   	push   %eax
  80160c:	6a 00                	push   $0x0
  80160e:	e8 f9 f5 ff ff       	call   800c0c <sys_page_unmap>
}
  801613:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801616:	c9                   	leave  
  801617:	c3                   	ret    

00801618 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801618:	55                   	push   %ebp
  801619:	89 e5                	mov    %esp,%ebp
  80161b:	57                   	push   %edi
  80161c:	56                   	push   %esi
  80161d:	53                   	push   %ebx
  80161e:	83 ec 1c             	sub    $0x1c,%esp
  801621:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801624:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801626:	a1 04 40 80 00       	mov    0x804004,%eax
  80162b:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  80162e:	83 ec 0c             	sub    $0xc,%esp
  801631:	ff 75 e0             	pushl  -0x20(%ebp)
  801634:	e8 3e 05 00 00       	call   801b77 <pageref>
  801639:	89 c3                	mov    %eax,%ebx
  80163b:	89 3c 24             	mov    %edi,(%esp)
  80163e:	e8 34 05 00 00       	call   801b77 <pageref>
  801643:	83 c4 10             	add    $0x10,%esp
  801646:	39 c3                	cmp    %eax,%ebx
  801648:	0f 94 c1             	sete   %cl
  80164b:	0f b6 c9             	movzbl %cl,%ecx
  80164e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801651:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801657:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80165a:	39 ce                	cmp    %ecx,%esi
  80165c:	74 1b                	je     801679 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  80165e:	39 c3                	cmp    %eax,%ebx
  801660:	75 c4                	jne    801626 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801662:	8b 42 58             	mov    0x58(%edx),%eax
  801665:	ff 75 e4             	pushl  -0x1c(%ebp)
  801668:	50                   	push   %eax
  801669:	56                   	push   %esi
  80166a:	68 6e 23 80 00       	push   $0x80236e
  80166f:	e8 93 eb ff ff       	call   800207 <cprintf>
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	eb ad                	jmp    801626 <_pipeisclosed+0xe>
	}
}
  801679:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80167c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80167f:	5b                   	pop    %ebx
  801680:	5e                   	pop    %esi
  801681:	5f                   	pop    %edi
  801682:	5d                   	pop    %ebp
  801683:	c3                   	ret    

00801684 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	57                   	push   %edi
  801688:	56                   	push   %esi
  801689:	53                   	push   %ebx
  80168a:	83 ec 28             	sub    $0x28,%esp
  80168d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801690:	56                   	push   %esi
  801691:	e8 ec f6 ff ff       	call   800d82 <fd2data>
  801696:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	bf 00 00 00 00       	mov    $0x0,%edi
  8016a0:	eb 4b                	jmp    8016ed <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8016a2:	89 da                	mov    %ebx,%edx
  8016a4:	89 f0                	mov    %esi,%eax
  8016a6:	e8 6d ff ff ff       	call   801618 <_pipeisclosed>
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	75 48                	jne    8016f7 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8016af:	e8 e7 f4 ff ff       	call   800b9b <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8016b4:	8b 43 04             	mov    0x4(%ebx),%eax
  8016b7:	8b 0b                	mov    (%ebx),%ecx
  8016b9:	8d 51 20             	lea    0x20(%ecx),%edx
  8016bc:	39 d0                	cmp    %edx,%eax
  8016be:	73 e2                	jae    8016a2 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8016c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016c3:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8016c7:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8016ca:	89 c2                	mov    %eax,%edx
  8016cc:	c1 fa 1f             	sar    $0x1f,%edx
  8016cf:	89 d1                	mov    %edx,%ecx
  8016d1:	c1 e9 1b             	shr    $0x1b,%ecx
  8016d4:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8016d7:	83 e2 1f             	and    $0x1f,%edx
  8016da:	29 ca                	sub    %ecx,%edx
  8016dc:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8016e0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8016e4:	83 c0 01             	add    $0x1,%eax
  8016e7:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8016ea:	83 c7 01             	add    $0x1,%edi
  8016ed:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8016f0:	75 c2                	jne    8016b4 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8016f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f5:	eb 05                	jmp    8016fc <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8016f7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8016fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016ff:	5b                   	pop    %ebx
  801700:	5e                   	pop    %esi
  801701:	5f                   	pop    %edi
  801702:	5d                   	pop    %ebp
  801703:	c3                   	ret    

00801704 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
  801707:	57                   	push   %edi
  801708:	56                   	push   %esi
  801709:	53                   	push   %ebx
  80170a:	83 ec 18             	sub    $0x18,%esp
  80170d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801710:	57                   	push   %edi
  801711:	e8 6c f6 ff ff       	call   800d82 <fd2data>
  801716:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801718:	83 c4 10             	add    $0x10,%esp
  80171b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801720:	eb 3d                	jmp    80175f <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801722:	85 db                	test   %ebx,%ebx
  801724:	74 04                	je     80172a <devpipe_read+0x26>
				return i;
  801726:	89 d8                	mov    %ebx,%eax
  801728:	eb 44                	jmp    80176e <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80172a:	89 f2                	mov    %esi,%edx
  80172c:	89 f8                	mov    %edi,%eax
  80172e:	e8 e5 fe ff ff       	call   801618 <_pipeisclosed>
  801733:	85 c0                	test   %eax,%eax
  801735:	75 32                	jne    801769 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801737:	e8 5f f4 ff ff       	call   800b9b <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80173c:	8b 06                	mov    (%esi),%eax
  80173e:	3b 46 04             	cmp    0x4(%esi),%eax
  801741:	74 df                	je     801722 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801743:	99                   	cltd   
  801744:	c1 ea 1b             	shr    $0x1b,%edx
  801747:	01 d0                	add    %edx,%eax
  801749:	83 e0 1f             	and    $0x1f,%eax
  80174c:	29 d0                	sub    %edx,%eax
  80174e:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801753:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801756:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801759:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80175c:	83 c3 01             	add    $0x1,%ebx
  80175f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801762:	75 d8                	jne    80173c <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801764:	8b 45 10             	mov    0x10(%ebp),%eax
  801767:	eb 05                	jmp    80176e <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801769:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80176e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801771:	5b                   	pop    %ebx
  801772:	5e                   	pop    %esi
  801773:	5f                   	pop    %edi
  801774:	5d                   	pop    %ebp
  801775:	c3                   	ret    

00801776 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	56                   	push   %esi
  80177a:	53                   	push   %ebx
  80177b:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80177e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801781:	50                   	push   %eax
  801782:	e8 13 f6 ff ff       	call   800d9a <fd_alloc>
  801787:	83 c4 10             	add    $0x10,%esp
  80178a:	89 c2                	mov    %eax,%edx
  80178c:	85 c0                	test   %eax,%eax
  80178e:	0f 88 2c 01 00 00    	js     8018c0 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801794:	83 ec 04             	sub    $0x4,%esp
  801797:	68 07 04 00 00       	push   $0x407
  80179c:	ff 75 f4             	pushl  -0xc(%ebp)
  80179f:	6a 00                	push   $0x0
  8017a1:	e8 1c f4 ff ff       	call   800bc2 <sys_page_alloc>
  8017a6:	83 c4 10             	add    $0x10,%esp
  8017a9:	89 c2                	mov    %eax,%edx
  8017ab:	85 c0                	test   %eax,%eax
  8017ad:	0f 88 0d 01 00 00    	js     8018c0 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8017b3:	83 ec 0c             	sub    $0xc,%esp
  8017b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017b9:	50                   	push   %eax
  8017ba:	e8 db f5 ff ff       	call   800d9a <fd_alloc>
  8017bf:	89 c3                	mov    %eax,%ebx
  8017c1:	83 c4 10             	add    $0x10,%esp
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	0f 88 e2 00 00 00    	js     8018ae <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017cc:	83 ec 04             	sub    $0x4,%esp
  8017cf:	68 07 04 00 00       	push   $0x407
  8017d4:	ff 75 f0             	pushl  -0x10(%ebp)
  8017d7:	6a 00                	push   $0x0
  8017d9:	e8 e4 f3 ff ff       	call   800bc2 <sys_page_alloc>
  8017de:	89 c3                	mov    %eax,%ebx
  8017e0:	83 c4 10             	add    $0x10,%esp
  8017e3:	85 c0                	test   %eax,%eax
  8017e5:	0f 88 c3 00 00 00    	js     8018ae <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8017eb:	83 ec 0c             	sub    $0xc,%esp
  8017ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8017f1:	e8 8c f5 ff ff       	call   800d82 <fd2data>
  8017f6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017f8:	83 c4 0c             	add    $0xc,%esp
  8017fb:	68 07 04 00 00       	push   $0x407
  801800:	50                   	push   %eax
  801801:	6a 00                	push   $0x0
  801803:	e8 ba f3 ff ff       	call   800bc2 <sys_page_alloc>
  801808:	89 c3                	mov    %eax,%ebx
  80180a:	83 c4 10             	add    $0x10,%esp
  80180d:	85 c0                	test   %eax,%eax
  80180f:	0f 88 89 00 00 00    	js     80189e <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801815:	83 ec 0c             	sub    $0xc,%esp
  801818:	ff 75 f0             	pushl  -0x10(%ebp)
  80181b:	e8 62 f5 ff ff       	call   800d82 <fd2data>
  801820:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801827:	50                   	push   %eax
  801828:	6a 00                	push   $0x0
  80182a:	56                   	push   %esi
  80182b:	6a 00                	push   $0x0
  80182d:	e8 b4 f3 ff ff       	call   800be6 <sys_page_map>
  801832:	89 c3                	mov    %eax,%ebx
  801834:	83 c4 20             	add    $0x20,%esp
  801837:	85 c0                	test   %eax,%eax
  801839:	78 55                	js     801890 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80183b:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801844:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801849:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801850:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801856:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801859:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80185b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801865:	83 ec 0c             	sub    $0xc,%esp
  801868:	ff 75 f4             	pushl  -0xc(%ebp)
  80186b:	e8 02 f5 ff ff       	call   800d72 <fd2num>
  801870:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801873:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801875:	83 c4 04             	add    $0x4,%esp
  801878:	ff 75 f0             	pushl  -0x10(%ebp)
  80187b:	e8 f2 f4 ff ff       	call   800d72 <fd2num>
  801880:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801883:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801886:	83 c4 10             	add    $0x10,%esp
  801889:	ba 00 00 00 00       	mov    $0x0,%edx
  80188e:	eb 30                	jmp    8018c0 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801890:	83 ec 08             	sub    $0x8,%esp
  801893:	56                   	push   %esi
  801894:	6a 00                	push   $0x0
  801896:	e8 71 f3 ff ff       	call   800c0c <sys_page_unmap>
  80189b:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  80189e:	83 ec 08             	sub    $0x8,%esp
  8018a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8018a4:	6a 00                	push   $0x0
  8018a6:	e8 61 f3 ff ff       	call   800c0c <sys_page_unmap>
  8018ab:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  8018ae:	83 ec 08             	sub    $0x8,%esp
  8018b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b4:	6a 00                	push   $0x0
  8018b6:	e8 51 f3 ff ff       	call   800c0c <sys_page_unmap>
  8018bb:	83 c4 10             	add    $0x10,%esp
  8018be:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  8018c0:	89 d0                	mov    %edx,%eax
  8018c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c5:	5b                   	pop    %ebx
  8018c6:	5e                   	pop    %esi
  8018c7:	5d                   	pop    %ebp
  8018c8:	c3                   	ret    

008018c9 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d2:	50                   	push   %eax
  8018d3:	ff 75 08             	pushl  0x8(%ebp)
  8018d6:	e8 0e f5 ff ff       	call   800de9 <fd_lookup>
  8018db:	83 c4 10             	add    $0x10,%esp
  8018de:	85 c0                	test   %eax,%eax
  8018e0:	78 18                	js     8018fa <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8018e2:	83 ec 0c             	sub    $0xc,%esp
  8018e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e8:	e8 95 f4 ff ff       	call   800d82 <fd2data>
	return _pipeisclosed(fd, p);
  8018ed:	89 c2                	mov    %eax,%edx
  8018ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f2:	e8 21 fd ff ff       	call   801618 <_pipeisclosed>
  8018f7:	83 c4 10             	add    $0x10,%esp
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8018ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801904:	5d                   	pop    %ebp
  801905:	c3                   	ret    

00801906 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80190c:	68 86 23 80 00       	push   $0x802386
  801911:	ff 75 0c             	pushl  0xc(%ebp)
  801914:	e8 60 ee ff ff       	call   800779 <strcpy>
	return 0;
}
  801919:	b8 00 00 00 00       	mov    $0x0,%eax
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
  801923:	57                   	push   %edi
  801924:	56                   	push   %esi
  801925:	53                   	push   %ebx
  801926:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80192c:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801931:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801937:	eb 2d                	jmp    801966 <devcons_write+0x46>
		m = n - tot;
  801939:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80193c:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  80193e:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801941:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801946:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801949:	83 ec 04             	sub    $0x4,%esp
  80194c:	53                   	push   %ebx
  80194d:	03 45 0c             	add    0xc(%ebp),%eax
  801950:	50                   	push   %eax
  801951:	57                   	push   %edi
  801952:	e8 b5 ef ff ff       	call   80090c <memmove>
		sys_cputs(buf, m);
  801957:	83 c4 08             	add    $0x8,%esp
  80195a:	53                   	push   %ebx
  80195b:	57                   	push   %edi
  80195c:	e8 aa f1 ff ff       	call   800b0b <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801961:	01 de                	add    %ebx,%esi
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	89 f0                	mov    %esi,%eax
  801968:	3b 75 10             	cmp    0x10(%ebp),%esi
  80196b:	72 cc                	jb     801939 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80196d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801970:	5b                   	pop    %ebx
  801971:	5e                   	pop    %esi
  801972:	5f                   	pop    %edi
  801973:	5d                   	pop    %ebp
  801974:	c3                   	ret    

00801975 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	83 ec 08             	sub    $0x8,%esp
  80197b:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801980:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801984:	74 2a                	je     8019b0 <devcons_read+0x3b>
  801986:	eb 05                	jmp    80198d <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801988:	e8 0e f2 ff ff       	call   800b9b <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80198d:	e8 9f f1 ff ff       	call   800b31 <sys_cgetc>
  801992:	85 c0                	test   %eax,%eax
  801994:	74 f2                	je     801988 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801996:	85 c0                	test   %eax,%eax
  801998:	78 16                	js     8019b0 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80199a:	83 f8 04             	cmp    $0x4,%eax
  80199d:	74 0c                	je     8019ab <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80199f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a2:	88 02                	mov    %al,(%edx)
	return 1;
  8019a4:	b8 01 00 00 00       	mov    $0x1,%eax
  8019a9:	eb 05                	jmp    8019b0 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8019ab:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
  8019b5:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8019be:	6a 01                	push   $0x1
  8019c0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8019c3:	50                   	push   %eax
  8019c4:	e8 42 f1 ff ff       	call   800b0b <sys_cputs>
}
  8019c9:	83 c4 10             	add    $0x10,%esp
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <getchar>:

int
getchar(void)
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
  8019d1:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8019d4:	6a 01                	push   $0x1
  8019d6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8019d9:	50                   	push   %eax
  8019da:	6a 00                	push   $0x0
  8019dc:	e8 6d f6 ff ff       	call   80104e <read>
	if (r < 0)
  8019e1:	83 c4 10             	add    $0x10,%esp
  8019e4:	85 c0                	test   %eax,%eax
  8019e6:	78 0f                	js     8019f7 <getchar+0x29>
		return r;
	if (r < 1)
  8019e8:	85 c0                	test   %eax,%eax
  8019ea:	7e 06                	jle    8019f2 <getchar+0x24>
		return -E_EOF;
	return c;
  8019ec:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8019f0:	eb 05                	jmp    8019f7 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8019f2:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a02:	50                   	push   %eax
  801a03:	ff 75 08             	pushl  0x8(%ebp)
  801a06:	e8 de f3 ff ff       	call   800de9 <fd_lookup>
  801a0b:	83 c4 10             	add    $0x10,%esp
  801a0e:	85 c0                	test   %eax,%eax
  801a10:	78 11                	js     801a23 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a15:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a1b:	39 10                	cmp    %edx,(%eax)
  801a1d:	0f 94 c0             	sete   %al
  801a20:	0f b6 c0             	movzbl %al,%eax
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <opencons>:

int
opencons(void)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801a2b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a2e:	50                   	push   %eax
  801a2f:	e8 66 f3 ff ff       	call   800d9a <fd_alloc>
  801a34:	83 c4 10             	add    $0x10,%esp
		return r;
  801a37:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801a39:	85 c0                	test   %eax,%eax
  801a3b:	78 3e                	js     801a7b <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801a3d:	83 ec 04             	sub    $0x4,%esp
  801a40:	68 07 04 00 00       	push   $0x407
  801a45:	ff 75 f4             	pushl  -0xc(%ebp)
  801a48:	6a 00                	push   $0x0
  801a4a:	e8 73 f1 ff ff       	call   800bc2 <sys_page_alloc>
  801a4f:	83 c4 10             	add    $0x10,%esp
		return r;
  801a52:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801a54:	85 c0                	test   %eax,%eax
  801a56:	78 23                	js     801a7b <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801a58:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a61:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a66:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801a6d:	83 ec 0c             	sub    $0xc,%esp
  801a70:	50                   	push   %eax
  801a71:	e8 fc f2 ff ff       	call   800d72 <fd2num>
  801a76:	89 c2                	mov    %eax,%edx
  801a78:	83 c4 10             	add    $0x10,%esp
}
  801a7b:	89 d0                	mov    %edx,%eax
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	56                   	push   %esi
  801a83:	53                   	push   %ebx
  801a84:	8b 75 08             	mov    0x8(%ebp),%esi
  801a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801a8d:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801a8f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801a94:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801a97:	83 ec 0c             	sub    $0xc,%esp
  801a9a:	50                   	push   %eax
  801a9b:	e8 1d f2 ff ff       	call   800cbd <sys_ipc_recv>
	if (from_env_store)
  801aa0:	83 c4 10             	add    $0x10,%esp
  801aa3:	85 f6                	test   %esi,%esi
  801aa5:	74 0b                	je     801ab2 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801aa7:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801aad:	8b 52 74             	mov    0x74(%edx),%edx
  801ab0:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801ab2:	85 db                	test   %ebx,%ebx
  801ab4:	74 0b                	je     801ac1 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  801ab6:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801abc:	8b 52 78             	mov    0x78(%edx),%edx
  801abf:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  801ac1:	85 c0                	test   %eax,%eax
  801ac3:	79 16                	jns    801adb <ipc_recv+0x5c>
		if (from_env_store)
  801ac5:	85 f6                	test   %esi,%esi
  801ac7:	74 06                	je     801acf <ipc_recv+0x50>
			*from_env_store = 0;
  801ac9:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  801acf:	85 db                	test   %ebx,%ebx
  801ad1:	74 10                	je     801ae3 <ipc_recv+0x64>
			*perm_store = 0;
  801ad3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ad9:	eb 08                	jmp    801ae3 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  801adb:	a1 04 40 80 00       	mov    0x804004,%eax
  801ae0:	8b 40 70             	mov    0x70(%eax),%eax
}
  801ae3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae6:	5b                   	pop    %ebx
  801ae7:	5e                   	pop    %esi
  801ae8:	5d                   	pop    %ebp
  801ae9:	c3                   	ret    

00801aea <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
  801aed:	57                   	push   %edi
  801aee:	56                   	push   %esi
  801aef:	53                   	push   %ebx
  801af0:	83 ec 0c             	sub    $0xc,%esp
  801af3:	8b 7d 08             	mov    0x8(%ebp),%edi
  801af6:	8b 75 0c             	mov    0xc(%ebp),%esi
  801af9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  801afc:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  801afe:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801b03:	0f 44 d8             	cmove  %eax,%ebx
  801b06:	eb 1c                	jmp    801b24 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  801b08:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801b0b:	74 12                	je     801b1f <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801b0d:	50                   	push   %eax
  801b0e:	68 92 23 80 00       	push   $0x802392
  801b13:	6a 42                	push   $0x42
  801b15:	68 a8 23 80 00       	push   $0x8023a8
  801b1a:	e8 0f e6 ff ff       	call   80012e <_panic>
		sys_yield();
  801b1f:	e8 77 f0 ff ff       	call   800b9b <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801b24:	ff 75 14             	pushl  0x14(%ebp)
  801b27:	53                   	push   %ebx
  801b28:	56                   	push   %esi
  801b29:	57                   	push   %edi
  801b2a:	e8 69 f1 ff ff       	call   800c98 <sys_ipc_try_send>
  801b2f:	83 c4 10             	add    $0x10,%esp
  801b32:	85 c0                	test   %eax,%eax
  801b34:	75 d2                	jne    801b08 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801b36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b39:	5b                   	pop    %ebx
  801b3a:	5e                   	pop    %esi
  801b3b:	5f                   	pop    %edi
  801b3c:	5d                   	pop    %ebp
  801b3d:	c3                   	ret    

00801b3e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801b44:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801b49:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801b4c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801b52:	8b 52 50             	mov    0x50(%edx),%edx
  801b55:	39 ca                	cmp    %ecx,%edx
  801b57:	75 0d                	jne    801b66 <ipc_find_env+0x28>
			return envs[i].env_id;
  801b59:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b5c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b61:	8b 40 48             	mov    0x48(%eax),%eax
  801b64:	eb 0f                	jmp    801b75 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801b66:	83 c0 01             	add    $0x1,%eax
  801b69:	3d 00 04 00 00       	cmp    $0x400,%eax
  801b6e:	75 d9                	jne    801b49 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801b70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b75:	5d                   	pop    %ebp
  801b76:	c3                   	ret    

00801b77 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b7d:	89 d0                	mov    %edx,%eax
  801b7f:	c1 e8 16             	shr    $0x16,%eax
  801b82:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801b89:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b8e:	f6 c1 01             	test   $0x1,%cl
  801b91:	74 1d                	je     801bb0 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801b93:	c1 ea 0c             	shr    $0xc,%edx
  801b96:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801b9d:	f6 c2 01             	test   $0x1,%dl
  801ba0:	74 0e                	je     801bb0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ba2:	c1 ea 0c             	shr    $0xc,%edx
  801ba5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801bac:	ef 
  801bad:	0f b7 c0             	movzwl %ax,%eax
}
  801bb0:	5d                   	pop    %ebp
  801bb1:	c3                   	ret    
  801bb2:	66 90                	xchg   %ax,%ax
  801bb4:	66 90                	xchg   %ax,%ax
  801bb6:	66 90                	xchg   %ax,%ax
  801bb8:	66 90                	xchg   %ax,%ax
  801bba:	66 90                	xchg   %ax,%ax
  801bbc:	66 90                	xchg   %ax,%ax
  801bbe:	66 90                	xchg   %ax,%ax

00801bc0 <__udivdi3>:
  801bc0:	55                   	push   %ebp
  801bc1:	57                   	push   %edi
  801bc2:	56                   	push   %esi
  801bc3:	53                   	push   %ebx
  801bc4:	83 ec 1c             	sub    $0x1c,%esp
  801bc7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bcb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801bcf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bd3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bd7:	85 f6                	test   %esi,%esi
  801bd9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bdd:	89 ca                	mov    %ecx,%edx
  801bdf:	89 f8                	mov    %edi,%eax
  801be1:	75 3d                	jne    801c20 <__udivdi3+0x60>
  801be3:	39 cf                	cmp    %ecx,%edi
  801be5:	0f 87 c5 00 00 00    	ja     801cb0 <__udivdi3+0xf0>
  801beb:	85 ff                	test   %edi,%edi
  801bed:	89 fd                	mov    %edi,%ebp
  801bef:	75 0b                	jne    801bfc <__udivdi3+0x3c>
  801bf1:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf6:	31 d2                	xor    %edx,%edx
  801bf8:	f7 f7                	div    %edi
  801bfa:	89 c5                	mov    %eax,%ebp
  801bfc:	89 c8                	mov    %ecx,%eax
  801bfe:	31 d2                	xor    %edx,%edx
  801c00:	f7 f5                	div    %ebp
  801c02:	89 c1                	mov    %eax,%ecx
  801c04:	89 d8                	mov    %ebx,%eax
  801c06:	89 cf                	mov    %ecx,%edi
  801c08:	f7 f5                	div    %ebp
  801c0a:	89 c3                	mov    %eax,%ebx
  801c0c:	89 d8                	mov    %ebx,%eax
  801c0e:	89 fa                	mov    %edi,%edx
  801c10:	83 c4 1c             	add    $0x1c,%esp
  801c13:	5b                   	pop    %ebx
  801c14:	5e                   	pop    %esi
  801c15:	5f                   	pop    %edi
  801c16:	5d                   	pop    %ebp
  801c17:	c3                   	ret    
  801c18:	90                   	nop
  801c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c20:	39 ce                	cmp    %ecx,%esi
  801c22:	77 74                	ja     801c98 <__udivdi3+0xd8>
  801c24:	0f bd fe             	bsr    %esi,%edi
  801c27:	83 f7 1f             	xor    $0x1f,%edi
  801c2a:	0f 84 98 00 00 00    	je     801cc8 <__udivdi3+0x108>
  801c30:	bb 20 00 00 00       	mov    $0x20,%ebx
  801c35:	89 f9                	mov    %edi,%ecx
  801c37:	89 c5                	mov    %eax,%ebp
  801c39:	29 fb                	sub    %edi,%ebx
  801c3b:	d3 e6                	shl    %cl,%esi
  801c3d:	89 d9                	mov    %ebx,%ecx
  801c3f:	d3 ed                	shr    %cl,%ebp
  801c41:	89 f9                	mov    %edi,%ecx
  801c43:	d3 e0                	shl    %cl,%eax
  801c45:	09 ee                	or     %ebp,%esi
  801c47:	89 d9                	mov    %ebx,%ecx
  801c49:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c4d:	89 d5                	mov    %edx,%ebp
  801c4f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c53:	d3 ed                	shr    %cl,%ebp
  801c55:	89 f9                	mov    %edi,%ecx
  801c57:	d3 e2                	shl    %cl,%edx
  801c59:	89 d9                	mov    %ebx,%ecx
  801c5b:	d3 e8                	shr    %cl,%eax
  801c5d:	09 c2                	or     %eax,%edx
  801c5f:	89 d0                	mov    %edx,%eax
  801c61:	89 ea                	mov    %ebp,%edx
  801c63:	f7 f6                	div    %esi
  801c65:	89 d5                	mov    %edx,%ebp
  801c67:	89 c3                	mov    %eax,%ebx
  801c69:	f7 64 24 0c          	mull   0xc(%esp)
  801c6d:	39 d5                	cmp    %edx,%ebp
  801c6f:	72 10                	jb     801c81 <__udivdi3+0xc1>
  801c71:	8b 74 24 08          	mov    0x8(%esp),%esi
  801c75:	89 f9                	mov    %edi,%ecx
  801c77:	d3 e6                	shl    %cl,%esi
  801c79:	39 c6                	cmp    %eax,%esi
  801c7b:	73 07                	jae    801c84 <__udivdi3+0xc4>
  801c7d:	39 d5                	cmp    %edx,%ebp
  801c7f:	75 03                	jne    801c84 <__udivdi3+0xc4>
  801c81:	83 eb 01             	sub    $0x1,%ebx
  801c84:	31 ff                	xor    %edi,%edi
  801c86:	89 d8                	mov    %ebx,%eax
  801c88:	89 fa                	mov    %edi,%edx
  801c8a:	83 c4 1c             	add    $0x1c,%esp
  801c8d:	5b                   	pop    %ebx
  801c8e:	5e                   	pop    %esi
  801c8f:	5f                   	pop    %edi
  801c90:	5d                   	pop    %ebp
  801c91:	c3                   	ret    
  801c92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c98:	31 ff                	xor    %edi,%edi
  801c9a:	31 db                	xor    %ebx,%ebx
  801c9c:	89 d8                	mov    %ebx,%eax
  801c9e:	89 fa                	mov    %edi,%edx
  801ca0:	83 c4 1c             	add    $0x1c,%esp
  801ca3:	5b                   	pop    %ebx
  801ca4:	5e                   	pop    %esi
  801ca5:	5f                   	pop    %edi
  801ca6:	5d                   	pop    %ebp
  801ca7:	c3                   	ret    
  801ca8:	90                   	nop
  801ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801cb0:	89 d8                	mov    %ebx,%eax
  801cb2:	f7 f7                	div    %edi
  801cb4:	31 ff                	xor    %edi,%edi
  801cb6:	89 c3                	mov    %eax,%ebx
  801cb8:	89 d8                	mov    %ebx,%eax
  801cba:	89 fa                	mov    %edi,%edx
  801cbc:	83 c4 1c             	add    $0x1c,%esp
  801cbf:	5b                   	pop    %ebx
  801cc0:	5e                   	pop    %esi
  801cc1:	5f                   	pop    %edi
  801cc2:	5d                   	pop    %ebp
  801cc3:	c3                   	ret    
  801cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801cc8:	39 ce                	cmp    %ecx,%esi
  801cca:	72 0c                	jb     801cd8 <__udivdi3+0x118>
  801ccc:	31 db                	xor    %ebx,%ebx
  801cce:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801cd2:	0f 87 34 ff ff ff    	ja     801c0c <__udivdi3+0x4c>
  801cd8:	bb 01 00 00 00       	mov    $0x1,%ebx
  801cdd:	e9 2a ff ff ff       	jmp    801c0c <__udivdi3+0x4c>
  801ce2:	66 90                	xchg   %ax,%ax
  801ce4:	66 90                	xchg   %ax,%ax
  801ce6:	66 90                	xchg   %ax,%ax
  801ce8:	66 90                	xchg   %ax,%ax
  801cea:	66 90                	xchg   %ax,%ax
  801cec:	66 90                	xchg   %ax,%ax
  801cee:	66 90                	xchg   %ax,%ax

00801cf0 <__umoddi3>:
  801cf0:	55                   	push   %ebp
  801cf1:	57                   	push   %edi
  801cf2:	56                   	push   %esi
  801cf3:	53                   	push   %ebx
  801cf4:	83 ec 1c             	sub    $0x1c,%esp
  801cf7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801cfb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801cff:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d07:	85 d2                	test   %edx,%edx
  801d09:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d11:	89 f3                	mov    %esi,%ebx
  801d13:	89 3c 24             	mov    %edi,(%esp)
  801d16:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d1a:	75 1c                	jne    801d38 <__umoddi3+0x48>
  801d1c:	39 f7                	cmp    %esi,%edi
  801d1e:	76 50                	jbe    801d70 <__umoddi3+0x80>
  801d20:	89 c8                	mov    %ecx,%eax
  801d22:	89 f2                	mov    %esi,%edx
  801d24:	f7 f7                	div    %edi
  801d26:	89 d0                	mov    %edx,%eax
  801d28:	31 d2                	xor    %edx,%edx
  801d2a:	83 c4 1c             	add    $0x1c,%esp
  801d2d:	5b                   	pop    %ebx
  801d2e:	5e                   	pop    %esi
  801d2f:	5f                   	pop    %edi
  801d30:	5d                   	pop    %ebp
  801d31:	c3                   	ret    
  801d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d38:	39 f2                	cmp    %esi,%edx
  801d3a:	89 d0                	mov    %edx,%eax
  801d3c:	77 52                	ja     801d90 <__umoddi3+0xa0>
  801d3e:	0f bd ea             	bsr    %edx,%ebp
  801d41:	83 f5 1f             	xor    $0x1f,%ebp
  801d44:	75 5a                	jne    801da0 <__umoddi3+0xb0>
  801d46:	3b 54 24 04          	cmp    0x4(%esp),%edx
  801d4a:	0f 82 e0 00 00 00    	jb     801e30 <__umoddi3+0x140>
  801d50:	39 0c 24             	cmp    %ecx,(%esp)
  801d53:	0f 86 d7 00 00 00    	jbe    801e30 <__umoddi3+0x140>
  801d59:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d5d:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d61:	83 c4 1c             	add    $0x1c,%esp
  801d64:	5b                   	pop    %ebx
  801d65:	5e                   	pop    %esi
  801d66:	5f                   	pop    %edi
  801d67:	5d                   	pop    %ebp
  801d68:	c3                   	ret    
  801d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d70:	85 ff                	test   %edi,%edi
  801d72:	89 fd                	mov    %edi,%ebp
  801d74:	75 0b                	jne    801d81 <__umoddi3+0x91>
  801d76:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7b:	31 d2                	xor    %edx,%edx
  801d7d:	f7 f7                	div    %edi
  801d7f:	89 c5                	mov    %eax,%ebp
  801d81:	89 f0                	mov    %esi,%eax
  801d83:	31 d2                	xor    %edx,%edx
  801d85:	f7 f5                	div    %ebp
  801d87:	89 c8                	mov    %ecx,%eax
  801d89:	f7 f5                	div    %ebp
  801d8b:	89 d0                	mov    %edx,%eax
  801d8d:	eb 99                	jmp    801d28 <__umoddi3+0x38>
  801d8f:	90                   	nop
  801d90:	89 c8                	mov    %ecx,%eax
  801d92:	89 f2                	mov    %esi,%edx
  801d94:	83 c4 1c             	add    $0x1c,%esp
  801d97:	5b                   	pop    %ebx
  801d98:	5e                   	pop    %esi
  801d99:	5f                   	pop    %edi
  801d9a:	5d                   	pop    %ebp
  801d9b:	c3                   	ret    
  801d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801da0:	8b 34 24             	mov    (%esp),%esi
  801da3:	bf 20 00 00 00       	mov    $0x20,%edi
  801da8:	89 e9                	mov    %ebp,%ecx
  801daa:	29 ef                	sub    %ebp,%edi
  801dac:	d3 e0                	shl    %cl,%eax
  801dae:	89 f9                	mov    %edi,%ecx
  801db0:	89 f2                	mov    %esi,%edx
  801db2:	d3 ea                	shr    %cl,%edx
  801db4:	89 e9                	mov    %ebp,%ecx
  801db6:	09 c2                	or     %eax,%edx
  801db8:	89 d8                	mov    %ebx,%eax
  801dba:	89 14 24             	mov    %edx,(%esp)
  801dbd:	89 f2                	mov    %esi,%edx
  801dbf:	d3 e2                	shl    %cl,%edx
  801dc1:	89 f9                	mov    %edi,%ecx
  801dc3:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dc7:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801dcb:	d3 e8                	shr    %cl,%eax
  801dcd:	89 e9                	mov    %ebp,%ecx
  801dcf:	89 c6                	mov    %eax,%esi
  801dd1:	d3 e3                	shl    %cl,%ebx
  801dd3:	89 f9                	mov    %edi,%ecx
  801dd5:	89 d0                	mov    %edx,%eax
  801dd7:	d3 e8                	shr    %cl,%eax
  801dd9:	89 e9                	mov    %ebp,%ecx
  801ddb:	09 d8                	or     %ebx,%eax
  801ddd:	89 d3                	mov    %edx,%ebx
  801ddf:	89 f2                	mov    %esi,%edx
  801de1:	f7 34 24             	divl   (%esp)
  801de4:	89 d6                	mov    %edx,%esi
  801de6:	d3 e3                	shl    %cl,%ebx
  801de8:	f7 64 24 04          	mull   0x4(%esp)
  801dec:	39 d6                	cmp    %edx,%esi
  801dee:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801df2:	89 d1                	mov    %edx,%ecx
  801df4:	89 c3                	mov    %eax,%ebx
  801df6:	72 08                	jb     801e00 <__umoddi3+0x110>
  801df8:	75 11                	jne    801e0b <__umoddi3+0x11b>
  801dfa:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801dfe:	73 0b                	jae    801e0b <__umoddi3+0x11b>
  801e00:	2b 44 24 04          	sub    0x4(%esp),%eax
  801e04:	1b 14 24             	sbb    (%esp),%edx
  801e07:	89 d1                	mov    %edx,%ecx
  801e09:	89 c3                	mov    %eax,%ebx
  801e0b:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e0f:	29 da                	sub    %ebx,%edx
  801e11:	19 ce                	sbb    %ecx,%esi
  801e13:	89 f9                	mov    %edi,%ecx
  801e15:	89 f0                	mov    %esi,%eax
  801e17:	d3 e0                	shl    %cl,%eax
  801e19:	89 e9                	mov    %ebp,%ecx
  801e1b:	d3 ea                	shr    %cl,%edx
  801e1d:	89 e9                	mov    %ebp,%ecx
  801e1f:	d3 ee                	shr    %cl,%esi
  801e21:	09 d0                	or     %edx,%eax
  801e23:	89 f2                	mov    %esi,%edx
  801e25:	83 c4 1c             	add    $0x1c,%esp
  801e28:	5b                   	pop    %ebx
  801e29:	5e                   	pop    %esi
  801e2a:	5f                   	pop    %edi
  801e2b:	5d                   	pop    %ebp
  801e2c:	c3                   	ret    
  801e2d:	8d 76 00             	lea    0x0(%esi),%esi
  801e30:	29 f9                	sub    %edi,%ecx
  801e32:	19 d6                	sbb    %edx,%esi
  801e34:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e38:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e3c:	e9 18 ff ff ff       	jmp    801d59 <__umoddi3+0x69>
