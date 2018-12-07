
obj/user/faultallocbad.debug:     formato del fichero elf32-i386


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
  80002c:	e8 84 00 00 00       	call   8000b5 <libmain>
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
  800040:	68 40 1e 80 00       	push   $0x801e40
  800045:	e8 a8 01 00 00       	call   8001f2 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 4f 0b 00 00       	call   800bad <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	79 16                	jns    80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  800065:	83 ec 0c             	sub    $0xc,%esp
  800068:	50                   	push   %eax
  800069:	53                   	push   %ebx
  80006a:	68 60 1e 80 00       	push   $0x801e60
  80006f:	6a 0f                	push   $0xf
  800071:	68 4a 1e 80 00       	push   $0x801e4a
  800076:	e8 9e 00 00 00       	call   800119 <_panic>
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  80007b:	53                   	push   %ebx
  80007c:	68 8c 1e 80 00       	push   $0x801e8c
  800081:	6a 64                	push   $0x64
  800083:	53                   	push   %ebx
  800084:	e8 88 06 00 00       	call   800711 <snprintf>
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
  80009c:	e8 29 0c 00 00       	call   800cca <set_pgfault_handler>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	6a 04                	push   $0x4
  8000a6:	68 ef be ad de       	push   $0xdeadbeef
  8000ab:	e8 46 0a 00 00       	call   800af6 <sys_cputs>
}
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    

008000b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
  8000ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000bd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8000c0:	e8 9d 0a 00 00       	call   800b62 <sys_getenvid>
	if (id >= 0)
  8000c5:	85 c0                	test   %eax,%eax
  8000c7:	78 12                	js     8000db <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  8000c9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ce:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000d1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000d6:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000db:	85 db                	test   %ebx,%ebx
  8000dd:	7e 07                	jle    8000e6 <libmain+0x31>
		binaryname = argv[0];
  8000df:	8b 06                	mov    (%esi),%eax
  8000e1:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000e6:	83 ec 08             	sub    $0x8,%esp
  8000e9:	56                   	push   %esi
  8000ea:	53                   	push   %ebx
  8000eb:	e8 a1 ff ff ff       	call   800091 <umain>

	// exit gracefully
	exit();
  8000f0:	e8 0a 00 00 00       	call   8000ff <exit>
}
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000fb:	5b                   	pop    %ebx
  8000fc:	5e                   	pop    %esi
  8000fd:	5d                   	pop    %ebp
  8000fe:	c3                   	ret    

008000ff <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ff:	55                   	push   %ebp
  800100:	89 e5                	mov    %esp,%ebp
  800102:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800105:	e8 1e 0e 00 00       	call   800f28 <close_all>
	sys_env_destroy(0);
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	6a 00                	push   $0x0
  80010f:	e8 2c 0a 00 00       	call   800b40 <sys_env_destroy>
}
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	c9                   	leave  
  800118:	c3                   	ret    

00800119 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800119:	55                   	push   %ebp
  80011a:	89 e5                	mov    %esp,%ebp
  80011c:	56                   	push   %esi
  80011d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80011e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800121:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800127:	e8 36 0a 00 00       	call   800b62 <sys_getenvid>
  80012c:	83 ec 0c             	sub    $0xc,%esp
  80012f:	ff 75 0c             	pushl  0xc(%ebp)
  800132:	ff 75 08             	pushl  0x8(%ebp)
  800135:	56                   	push   %esi
  800136:	50                   	push   %eax
  800137:	68 b8 1e 80 00       	push   $0x801eb8
  80013c:	e8 b1 00 00 00       	call   8001f2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800141:	83 c4 18             	add    $0x18,%esp
  800144:	53                   	push   %ebx
  800145:	ff 75 10             	pushl  0x10(%ebp)
  800148:	e8 54 00 00 00       	call   8001a1 <vcprintf>
	cprintf("\n");
  80014d:	c7 04 24 5f 23 80 00 	movl   $0x80235f,(%esp)
  800154:	e8 99 00 00 00       	call   8001f2 <cprintf>
  800159:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80015c:	cc                   	int3   
  80015d:	eb fd                	jmp    80015c <_panic+0x43>

0080015f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80015f:	55                   	push   %ebp
  800160:	89 e5                	mov    %esp,%ebp
  800162:	53                   	push   %ebx
  800163:	83 ec 04             	sub    $0x4,%esp
  800166:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800169:	8b 13                	mov    (%ebx),%edx
  80016b:	8d 42 01             	lea    0x1(%edx),%eax
  80016e:	89 03                	mov    %eax,(%ebx)
  800170:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800173:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800177:	3d ff 00 00 00       	cmp    $0xff,%eax
  80017c:	75 1a                	jne    800198 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  80017e:	83 ec 08             	sub    $0x8,%esp
  800181:	68 ff 00 00 00       	push   $0xff
  800186:	8d 43 08             	lea    0x8(%ebx),%eax
  800189:	50                   	push   %eax
  80018a:	e8 67 09 00 00       	call   800af6 <sys_cputs>
		b->idx = 0;
  80018f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800195:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  800198:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80019c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80019f:	c9                   	leave  
  8001a0:	c3                   	ret    

008001a1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001a1:	55                   	push   %ebp
  8001a2:	89 e5                	mov    %esp,%ebp
  8001a4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001aa:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b1:	00 00 00 
	b.cnt = 0;
  8001b4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001bb:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001be:	ff 75 0c             	pushl  0xc(%ebp)
  8001c1:	ff 75 08             	pushl  0x8(%ebp)
  8001c4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ca:	50                   	push   %eax
  8001cb:	68 5f 01 80 00       	push   $0x80015f
  8001d0:	e8 86 01 00 00       	call   80035b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d5:	83 c4 08             	add    $0x8,%esp
  8001d8:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001de:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e4:	50                   	push   %eax
  8001e5:	e8 0c 09 00 00       	call   800af6 <sys_cputs>

	return b.cnt;
}
  8001ea:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f0:	c9                   	leave  
  8001f1:	c3                   	ret    

008001f2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f2:	55                   	push   %ebp
  8001f3:	89 e5                	mov    %esp,%ebp
  8001f5:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001fb:	50                   	push   %eax
  8001fc:	ff 75 08             	pushl  0x8(%ebp)
  8001ff:	e8 9d ff ff ff       	call   8001a1 <vcprintf>
	va_end(ap);

	return cnt;
}
  800204:	c9                   	leave  
  800205:	c3                   	ret    

00800206 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	57                   	push   %edi
  80020a:	56                   	push   %esi
  80020b:	53                   	push   %ebx
  80020c:	83 ec 1c             	sub    $0x1c,%esp
  80020f:	89 c7                	mov    %eax,%edi
  800211:	89 d6                	mov    %edx,%esi
  800213:	8b 45 08             	mov    0x8(%ebp),%eax
  800216:	8b 55 0c             	mov    0xc(%ebp),%edx
  800219:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80021c:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80021f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800222:	bb 00 00 00 00       	mov    $0x0,%ebx
  800227:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80022a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80022d:	39 d3                	cmp    %edx,%ebx
  80022f:	72 05                	jb     800236 <printnum+0x30>
  800231:	39 45 10             	cmp    %eax,0x10(%ebp)
  800234:	77 45                	ja     80027b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	ff 75 18             	pushl  0x18(%ebp)
  80023c:	8b 45 14             	mov    0x14(%ebp),%eax
  80023f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800242:	53                   	push   %ebx
  800243:	ff 75 10             	pushl  0x10(%ebp)
  800246:	83 ec 08             	sub    $0x8,%esp
  800249:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024c:	ff 75 e0             	pushl  -0x20(%ebp)
  80024f:	ff 75 dc             	pushl  -0x24(%ebp)
  800252:	ff 75 d8             	pushl  -0x28(%ebp)
  800255:	e8 46 19 00 00       	call   801ba0 <__udivdi3>
  80025a:	83 c4 18             	add    $0x18,%esp
  80025d:	52                   	push   %edx
  80025e:	50                   	push   %eax
  80025f:	89 f2                	mov    %esi,%edx
  800261:	89 f8                	mov    %edi,%eax
  800263:	e8 9e ff ff ff       	call   800206 <printnum>
  800268:	83 c4 20             	add    $0x20,%esp
  80026b:	eb 18                	jmp    800285 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80026d:	83 ec 08             	sub    $0x8,%esp
  800270:	56                   	push   %esi
  800271:	ff 75 18             	pushl  0x18(%ebp)
  800274:	ff d7                	call   *%edi
  800276:	83 c4 10             	add    $0x10,%esp
  800279:	eb 03                	jmp    80027e <printnum+0x78>
  80027b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80027e:	83 eb 01             	sub    $0x1,%ebx
  800281:	85 db                	test   %ebx,%ebx
  800283:	7f e8                	jg     80026d <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800285:	83 ec 08             	sub    $0x8,%esp
  800288:	56                   	push   %esi
  800289:	83 ec 04             	sub    $0x4,%esp
  80028c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80028f:	ff 75 e0             	pushl  -0x20(%ebp)
  800292:	ff 75 dc             	pushl  -0x24(%ebp)
  800295:	ff 75 d8             	pushl  -0x28(%ebp)
  800298:	e8 33 1a 00 00       	call   801cd0 <__umoddi3>
  80029d:	83 c4 14             	add    $0x14,%esp
  8002a0:	0f be 80 db 1e 80 00 	movsbl 0x801edb(%eax),%eax
  8002a7:	50                   	push   %eax
  8002a8:	ff d7                	call   *%edi
}
  8002aa:	83 c4 10             	add    $0x10,%esp
  8002ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b0:	5b                   	pop    %ebx
  8002b1:	5e                   	pop    %esi
  8002b2:	5f                   	pop    %edi
  8002b3:	5d                   	pop    %ebp
  8002b4:	c3                   	ret    

008002b5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002b8:	83 fa 01             	cmp    $0x1,%edx
  8002bb:	7e 0e                	jle    8002cb <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002bd:	8b 10                	mov    (%eax),%edx
  8002bf:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002c2:	89 08                	mov    %ecx,(%eax)
  8002c4:	8b 02                	mov    (%edx),%eax
  8002c6:	8b 52 04             	mov    0x4(%edx),%edx
  8002c9:	eb 22                	jmp    8002ed <getuint+0x38>
	else if (lflag)
  8002cb:	85 d2                	test   %edx,%edx
  8002cd:	74 10                	je     8002df <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002cf:	8b 10                	mov    (%eax),%edx
  8002d1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002d4:	89 08                	mov    %ecx,(%eax)
  8002d6:	8b 02                	mov    (%edx),%eax
  8002d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8002dd:	eb 0e                	jmp    8002ed <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002df:	8b 10                	mov    (%eax),%edx
  8002e1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002e4:	89 08                	mov    %ecx,(%eax)
  8002e6:	8b 02                	mov    (%edx),%eax
  8002e8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002ed:	5d                   	pop    %ebp
  8002ee:	c3                   	ret    

008002ef <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002f2:	83 fa 01             	cmp    $0x1,%edx
  8002f5:	7e 0e                	jle    800305 <getint+0x16>
		return va_arg(*ap, long long);
  8002f7:	8b 10                	mov    (%eax),%edx
  8002f9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002fc:	89 08                	mov    %ecx,(%eax)
  8002fe:	8b 02                	mov    (%edx),%eax
  800300:	8b 52 04             	mov    0x4(%edx),%edx
  800303:	eb 1a                	jmp    80031f <getint+0x30>
	else if (lflag)
  800305:	85 d2                	test   %edx,%edx
  800307:	74 0c                	je     800315 <getint+0x26>
		return va_arg(*ap, long);
  800309:	8b 10                	mov    (%eax),%edx
  80030b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80030e:	89 08                	mov    %ecx,(%eax)
  800310:	8b 02                	mov    (%edx),%eax
  800312:	99                   	cltd   
  800313:	eb 0a                	jmp    80031f <getint+0x30>
	else
		return va_arg(*ap, int);
  800315:	8b 10                	mov    (%eax),%edx
  800317:	8d 4a 04             	lea    0x4(%edx),%ecx
  80031a:	89 08                	mov    %ecx,(%eax)
  80031c:	8b 02                	mov    (%edx),%eax
  80031e:	99                   	cltd   
}
  80031f:	5d                   	pop    %ebp
  800320:	c3                   	ret    

00800321 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800321:	55                   	push   %ebp
  800322:	89 e5                	mov    %esp,%ebp
  800324:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800327:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80032b:	8b 10                	mov    (%eax),%edx
  80032d:	3b 50 04             	cmp    0x4(%eax),%edx
  800330:	73 0a                	jae    80033c <sprintputch+0x1b>
		*b->buf++ = ch;
  800332:	8d 4a 01             	lea    0x1(%edx),%ecx
  800335:	89 08                	mov    %ecx,(%eax)
  800337:	8b 45 08             	mov    0x8(%ebp),%eax
  80033a:	88 02                	mov    %al,(%edx)
}
  80033c:	5d                   	pop    %ebp
  80033d:	c3                   	ret    

0080033e <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80033e:	55                   	push   %ebp
  80033f:	89 e5                	mov    %esp,%ebp
  800341:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800344:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800347:	50                   	push   %eax
  800348:	ff 75 10             	pushl  0x10(%ebp)
  80034b:	ff 75 0c             	pushl  0xc(%ebp)
  80034e:	ff 75 08             	pushl  0x8(%ebp)
  800351:	e8 05 00 00 00       	call   80035b <vprintfmt>
	va_end(ap);
}
  800356:	83 c4 10             	add    $0x10,%esp
  800359:	c9                   	leave  
  80035a:	c3                   	ret    

0080035b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80035b:	55                   	push   %ebp
  80035c:	89 e5                	mov    %esp,%ebp
  80035e:	57                   	push   %edi
  80035f:	56                   	push   %esi
  800360:	53                   	push   %ebx
  800361:	83 ec 2c             	sub    $0x2c,%esp
  800364:	8b 75 08             	mov    0x8(%ebp),%esi
  800367:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80036a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80036d:	eb 12                	jmp    800381 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80036f:	85 c0                	test   %eax,%eax
  800371:	0f 84 44 03 00 00    	je     8006bb <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  800377:	83 ec 08             	sub    $0x8,%esp
  80037a:	53                   	push   %ebx
  80037b:	50                   	push   %eax
  80037c:	ff d6                	call   *%esi
  80037e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800381:	83 c7 01             	add    $0x1,%edi
  800384:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800388:	83 f8 25             	cmp    $0x25,%eax
  80038b:	75 e2                	jne    80036f <vprintfmt+0x14>
  80038d:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800391:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800398:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80039f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8003a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ab:	eb 07                	jmp    8003b4 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003b0:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003b4:	8d 47 01             	lea    0x1(%edi),%eax
  8003b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ba:	0f b6 07             	movzbl (%edi),%eax
  8003bd:	0f b6 c8             	movzbl %al,%ecx
  8003c0:	83 e8 23             	sub    $0x23,%eax
  8003c3:	3c 55                	cmp    $0x55,%al
  8003c5:	0f 87 d5 02 00 00    	ja     8006a0 <vprintfmt+0x345>
  8003cb:	0f b6 c0             	movzbl %al,%eax
  8003ce:	ff 24 85 20 20 80 00 	jmp    *0x802020(,%eax,4)
  8003d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003d8:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003dc:	eb d6                	jmp    8003b4 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003e9:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003ec:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8003f0:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8003f3:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8003f6:	83 fa 09             	cmp    $0x9,%edx
  8003f9:	77 39                	ja     800434 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003fb:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003fe:	eb e9                	jmp    8003e9 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800400:	8b 45 14             	mov    0x14(%ebp),%eax
  800403:	8d 48 04             	lea    0x4(%eax),%ecx
  800406:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800409:	8b 00                	mov    (%eax),%eax
  80040b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80040e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800411:	eb 27                	jmp    80043a <vprintfmt+0xdf>
  800413:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800416:	85 c0                	test   %eax,%eax
  800418:	b9 00 00 00 00       	mov    $0x0,%ecx
  80041d:	0f 49 c8             	cmovns %eax,%ecx
  800420:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800423:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800426:	eb 8c                	jmp    8003b4 <vprintfmt+0x59>
  800428:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80042b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800432:	eb 80                	jmp    8003b4 <vprintfmt+0x59>
  800434:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800437:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  80043a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80043e:	0f 89 70 ff ff ff    	jns    8003b4 <vprintfmt+0x59>
				width = precision, precision = -1;
  800444:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800447:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80044a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800451:	e9 5e ff ff ff       	jmp    8003b4 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800456:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800459:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80045c:	e9 53 ff ff ff       	jmp    8003b4 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800461:	8b 45 14             	mov    0x14(%ebp),%eax
  800464:	8d 50 04             	lea    0x4(%eax),%edx
  800467:	89 55 14             	mov    %edx,0x14(%ebp)
  80046a:	83 ec 08             	sub    $0x8,%esp
  80046d:	53                   	push   %ebx
  80046e:	ff 30                	pushl  (%eax)
  800470:	ff d6                	call   *%esi
			break;
  800472:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800475:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800478:	e9 04 ff ff ff       	jmp    800381 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80047d:	8b 45 14             	mov    0x14(%ebp),%eax
  800480:	8d 50 04             	lea    0x4(%eax),%edx
  800483:	89 55 14             	mov    %edx,0x14(%ebp)
  800486:	8b 00                	mov    (%eax),%eax
  800488:	99                   	cltd   
  800489:	31 d0                	xor    %edx,%eax
  80048b:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80048d:	83 f8 0f             	cmp    $0xf,%eax
  800490:	7f 0b                	jg     80049d <vprintfmt+0x142>
  800492:	8b 14 85 80 21 80 00 	mov    0x802180(,%eax,4),%edx
  800499:	85 d2                	test   %edx,%edx
  80049b:	75 18                	jne    8004b5 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  80049d:	50                   	push   %eax
  80049e:	68 f3 1e 80 00       	push   $0x801ef3
  8004a3:	53                   	push   %ebx
  8004a4:	56                   	push   %esi
  8004a5:	e8 94 fe ff ff       	call   80033e <printfmt>
  8004aa:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8004b0:	e9 cc fe ff ff       	jmp    800381 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  8004b5:	52                   	push   %edx
  8004b6:	68 2d 23 80 00       	push   $0x80232d
  8004bb:	53                   	push   %ebx
  8004bc:	56                   	push   %esi
  8004bd:	e8 7c fe ff ff       	call   80033e <printfmt>
  8004c2:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004c8:	e9 b4 fe ff ff       	jmp    800381 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d0:	8d 50 04             	lea    0x4(%eax),%edx
  8004d3:	89 55 14             	mov    %edx,0x14(%ebp)
  8004d6:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004d8:	85 ff                	test   %edi,%edi
  8004da:	b8 ec 1e 80 00       	mov    $0x801eec,%eax
  8004df:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004e2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004e6:	0f 8e 94 00 00 00    	jle    800580 <vprintfmt+0x225>
  8004ec:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004f0:	0f 84 98 00 00 00    	je     80058e <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f6:	83 ec 08             	sub    $0x8,%esp
  8004f9:	ff 75 d0             	pushl  -0x30(%ebp)
  8004fc:	57                   	push   %edi
  8004fd:	e8 41 02 00 00       	call   800743 <strnlen>
  800502:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800505:	29 c1                	sub    %eax,%ecx
  800507:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80050a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80050d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800511:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800514:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800517:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800519:	eb 0f                	jmp    80052a <vprintfmt+0x1cf>
					putch(padc, putdat);
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	53                   	push   %ebx
  80051f:	ff 75 e0             	pushl  -0x20(%ebp)
  800522:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800524:	83 ef 01             	sub    $0x1,%edi
  800527:	83 c4 10             	add    $0x10,%esp
  80052a:	85 ff                	test   %edi,%edi
  80052c:	7f ed                	jg     80051b <vprintfmt+0x1c0>
  80052e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800531:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800534:	85 c9                	test   %ecx,%ecx
  800536:	b8 00 00 00 00       	mov    $0x0,%eax
  80053b:	0f 49 c1             	cmovns %ecx,%eax
  80053e:	29 c1                	sub    %eax,%ecx
  800540:	89 75 08             	mov    %esi,0x8(%ebp)
  800543:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800546:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800549:	89 cb                	mov    %ecx,%ebx
  80054b:	eb 4d                	jmp    80059a <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80054d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800551:	74 1b                	je     80056e <vprintfmt+0x213>
  800553:	0f be c0             	movsbl %al,%eax
  800556:	83 e8 20             	sub    $0x20,%eax
  800559:	83 f8 5e             	cmp    $0x5e,%eax
  80055c:	76 10                	jbe    80056e <vprintfmt+0x213>
					putch('?', putdat);
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	ff 75 0c             	pushl  0xc(%ebp)
  800564:	6a 3f                	push   $0x3f
  800566:	ff 55 08             	call   *0x8(%ebp)
  800569:	83 c4 10             	add    $0x10,%esp
  80056c:	eb 0d                	jmp    80057b <vprintfmt+0x220>
				else
					putch(ch, putdat);
  80056e:	83 ec 08             	sub    $0x8,%esp
  800571:	ff 75 0c             	pushl  0xc(%ebp)
  800574:	52                   	push   %edx
  800575:	ff 55 08             	call   *0x8(%ebp)
  800578:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80057b:	83 eb 01             	sub    $0x1,%ebx
  80057e:	eb 1a                	jmp    80059a <vprintfmt+0x23f>
  800580:	89 75 08             	mov    %esi,0x8(%ebp)
  800583:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800586:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800589:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80058c:	eb 0c                	jmp    80059a <vprintfmt+0x23f>
  80058e:	89 75 08             	mov    %esi,0x8(%ebp)
  800591:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800594:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800597:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80059a:	83 c7 01             	add    $0x1,%edi
  80059d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005a1:	0f be d0             	movsbl %al,%edx
  8005a4:	85 d2                	test   %edx,%edx
  8005a6:	74 23                	je     8005cb <vprintfmt+0x270>
  8005a8:	85 f6                	test   %esi,%esi
  8005aa:	78 a1                	js     80054d <vprintfmt+0x1f2>
  8005ac:	83 ee 01             	sub    $0x1,%esi
  8005af:	79 9c                	jns    80054d <vprintfmt+0x1f2>
  8005b1:	89 df                	mov    %ebx,%edi
  8005b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8005b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005b9:	eb 18                	jmp    8005d3 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005bb:	83 ec 08             	sub    $0x8,%esp
  8005be:	53                   	push   %ebx
  8005bf:	6a 20                	push   $0x20
  8005c1:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005c3:	83 ef 01             	sub    $0x1,%edi
  8005c6:	83 c4 10             	add    $0x10,%esp
  8005c9:	eb 08                	jmp    8005d3 <vprintfmt+0x278>
  8005cb:	89 df                	mov    %ebx,%edi
  8005cd:	8b 75 08             	mov    0x8(%ebp),%esi
  8005d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005d3:	85 ff                	test   %edi,%edi
  8005d5:	7f e4                	jg     8005bb <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005da:	e9 a2 fd ff ff       	jmp    800381 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005df:	8d 45 14             	lea    0x14(%ebp),%eax
  8005e2:	e8 08 fd ff ff       	call   8002ef <getint>
  8005e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ea:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8005ed:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8005f2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005f6:	79 74                	jns    80066c <vprintfmt+0x311>
				putch('-', putdat);
  8005f8:	83 ec 08             	sub    $0x8,%esp
  8005fb:	53                   	push   %ebx
  8005fc:	6a 2d                	push   $0x2d
  8005fe:	ff d6                	call   *%esi
				num = -(long long) num;
  800600:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800603:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800606:	f7 d8                	neg    %eax
  800608:	83 d2 00             	adc    $0x0,%edx
  80060b:	f7 da                	neg    %edx
  80060d:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  800610:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800615:	eb 55                	jmp    80066c <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800617:	8d 45 14             	lea    0x14(%ebp),%eax
  80061a:	e8 96 fc ff ff       	call   8002b5 <getuint>
			base = 10;
  80061f:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800624:	eb 46                	jmp    80066c <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800626:	8d 45 14             	lea    0x14(%ebp),%eax
  800629:	e8 87 fc ff ff       	call   8002b5 <getuint>
			base = 8;
  80062e:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800633:	eb 37                	jmp    80066c <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	53                   	push   %ebx
  800639:	6a 30                	push   $0x30
  80063b:	ff d6                	call   *%esi
			putch('x', putdat);
  80063d:	83 c4 08             	add    $0x8,%esp
  800640:	53                   	push   %ebx
  800641:	6a 78                	push   $0x78
  800643:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	8d 50 04             	lea    0x4(%eax),%edx
  80064b:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800655:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800658:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80065d:	eb 0d                	jmp    80066c <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80065f:	8d 45 14             	lea    0x14(%ebp),%eax
  800662:	e8 4e fc ff ff       	call   8002b5 <getuint>
			base = 16;
  800667:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  80066c:	83 ec 0c             	sub    $0xc,%esp
  80066f:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800673:	57                   	push   %edi
  800674:	ff 75 e0             	pushl  -0x20(%ebp)
  800677:	51                   	push   %ecx
  800678:	52                   	push   %edx
  800679:	50                   	push   %eax
  80067a:	89 da                	mov    %ebx,%edx
  80067c:	89 f0                	mov    %esi,%eax
  80067e:	e8 83 fb ff ff       	call   800206 <printnum>
			break;
  800683:	83 c4 20             	add    $0x20,%esp
  800686:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800689:	e9 f3 fc ff ff       	jmp    800381 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	53                   	push   %ebx
  800692:	51                   	push   %ecx
  800693:	ff d6                	call   *%esi
			break;
  800695:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800698:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  80069b:	e9 e1 fc ff ff       	jmp    800381 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006a0:	83 ec 08             	sub    $0x8,%esp
  8006a3:	53                   	push   %ebx
  8006a4:	6a 25                	push   $0x25
  8006a6:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006a8:	83 c4 10             	add    $0x10,%esp
  8006ab:	eb 03                	jmp    8006b0 <vprintfmt+0x355>
  8006ad:	83 ef 01             	sub    $0x1,%edi
  8006b0:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  8006b4:	75 f7                	jne    8006ad <vprintfmt+0x352>
  8006b6:	e9 c6 fc ff ff       	jmp    800381 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  8006bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006be:	5b                   	pop    %ebx
  8006bf:	5e                   	pop    %esi
  8006c0:	5f                   	pop    %edi
  8006c1:	5d                   	pop    %ebp
  8006c2:	c3                   	ret    

008006c3 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006c3:	55                   	push   %ebp
  8006c4:	89 e5                	mov    %esp,%ebp
  8006c6:	83 ec 18             	sub    $0x18,%esp
  8006c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cc:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006d2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006d6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006e0:	85 c0                	test   %eax,%eax
  8006e2:	74 26                	je     80070a <vsnprintf+0x47>
  8006e4:	85 d2                	test   %edx,%edx
  8006e6:	7e 22                	jle    80070a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006e8:	ff 75 14             	pushl  0x14(%ebp)
  8006eb:	ff 75 10             	pushl  0x10(%ebp)
  8006ee:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006f1:	50                   	push   %eax
  8006f2:	68 21 03 80 00       	push   $0x800321
  8006f7:	e8 5f fc ff ff       	call   80035b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006ff:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800705:	83 c4 10             	add    $0x10,%esp
  800708:	eb 05                	jmp    80070f <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80070a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80070f:	c9                   	leave  
  800710:	c3                   	ret    

00800711 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800711:	55                   	push   %ebp
  800712:	89 e5                	mov    %esp,%ebp
  800714:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800717:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80071a:	50                   	push   %eax
  80071b:	ff 75 10             	pushl  0x10(%ebp)
  80071e:	ff 75 0c             	pushl  0xc(%ebp)
  800721:	ff 75 08             	pushl  0x8(%ebp)
  800724:	e8 9a ff ff ff       	call   8006c3 <vsnprintf>
	va_end(ap);

	return rc;
}
  800729:	c9                   	leave  
  80072a:	c3                   	ret    

0080072b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800731:	b8 00 00 00 00       	mov    $0x0,%eax
  800736:	eb 03                	jmp    80073b <strlen+0x10>
		n++;
  800738:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80073b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80073f:	75 f7                	jne    800738 <strlen+0xd>
		n++;
	return n;
}
  800741:	5d                   	pop    %ebp
  800742:	c3                   	ret    

00800743 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800749:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80074c:	ba 00 00 00 00       	mov    $0x0,%edx
  800751:	eb 03                	jmp    800756 <strnlen+0x13>
		n++;
  800753:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800756:	39 c2                	cmp    %eax,%edx
  800758:	74 08                	je     800762 <strnlen+0x1f>
  80075a:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80075e:	75 f3                	jne    800753 <strnlen+0x10>
  800760:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  800762:	5d                   	pop    %ebp
  800763:	c3                   	ret    

00800764 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
  800767:	53                   	push   %ebx
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80076e:	89 c2                	mov    %eax,%edx
  800770:	83 c2 01             	add    $0x1,%edx
  800773:	83 c1 01             	add    $0x1,%ecx
  800776:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80077a:	88 5a ff             	mov    %bl,-0x1(%edx)
  80077d:	84 db                	test   %bl,%bl
  80077f:	75 ef                	jne    800770 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800781:	5b                   	pop    %ebx
  800782:	5d                   	pop    %ebp
  800783:	c3                   	ret    

00800784 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800784:	55                   	push   %ebp
  800785:	89 e5                	mov    %esp,%ebp
  800787:	53                   	push   %ebx
  800788:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80078b:	53                   	push   %ebx
  80078c:	e8 9a ff ff ff       	call   80072b <strlen>
  800791:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800794:	ff 75 0c             	pushl  0xc(%ebp)
  800797:	01 d8                	add    %ebx,%eax
  800799:	50                   	push   %eax
  80079a:	e8 c5 ff ff ff       	call   800764 <strcpy>
	return dst;
}
  80079f:	89 d8                	mov    %ebx,%eax
  8007a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007a4:	c9                   	leave  
  8007a5:	c3                   	ret    

008007a6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
  8007a9:	56                   	push   %esi
  8007aa:	53                   	push   %ebx
  8007ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007b1:	89 f3                	mov    %esi,%ebx
  8007b3:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007b6:	89 f2                	mov    %esi,%edx
  8007b8:	eb 0f                	jmp    8007c9 <strncpy+0x23>
		*dst++ = *src;
  8007ba:	83 c2 01             	add    $0x1,%edx
  8007bd:	0f b6 01             	movzbl (%ecx),%eax
  8007c0:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007c3:	80 39 01             	cmpb   $0x1,(%ecx)
  8007c6:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007c9:	39 da                	cmp    %ebx,%edx
  8007cb:	75 ed                	jne    8007ba <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8007cd:	89 f0                	mov    %esi,%eax
  8007cf:	5b                   	pop    %ebx
  8007d0:	5e                   	pop    %esi
  8007d1:	5d                   	pop    %ebp
  8007d2:	c3                   	ret    

008007d3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
  8007d6:	56                   	push   %esi
  8007d7:	53                   	push   %ebx
  8007d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8007db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007de:	8b 55 10             	mov    0x10(%ebp),%edx
  8007e1:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007e3:	85 d2                	test   %edx,%edx
  8007e5:	74 21                	je     800808 <strlcpy+0x35>
  8007e7:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8007eb:	89 f2                	mov    %esi,%edx
  8007ed:	eb 09                	jmp    8007f8 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8007ef:	83 c2 01             	add    $0x1,%edx
  8007f2:	83 c1 01             	add    $0x1,%ecx
  8007f5:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8007f8:	39 c2                	cmp    %eax,%edx
  8007fa:	74 09                	je     800805 <strlcpy+0x32>
  8007fc:	0f b6 19             	movzbl (%ecx),%ebx
  8007ff:	84 db                	test   %bl,%bl
  800801:	75 ec                	jne    8007ef <strlcpy+0x1c>
  800803:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  800805:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800808:	29 f0                	sub    %esi,%eax
}
  80080a:	5b                   	pop    %ebx
  80080b:	5e                   	pop    %esi
  80080c:	5d                   	pop    %ebp
  80080d:	c3                   	ret    

0080080e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80080e:	55                   	push   %ebp
  80080f:	89 e5                	mov    %esp,%ebp
  800811:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800814:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800817:	eb 06                	jmp    80081f <strcmp+0x11>
		p++, q++;
  800819:	83 c1 01             	add    $0x1,%ecx
  80081c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80081f:	0f b6 01             	movzbl (%ecx),%eax
  800822:	84 c0                	test   %al,%al
  800824:	74 04                	je     80082a <strcmp+0x1c>
  800826:	3a 02                	cmp    (%edx),%al
  800828:	74 ef                	je     800819 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80082a:	0f b6 c0             	movzbl %al,%eax
  80082d:	0f b6 12             	movzbl (%edx),%edx
  800830:	29 d0                	sub    %edx,%eax
}
  800832:	5d                   	pop    %ebp
  800833:	c3                   	ret    

00800834 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
  800837:	53                   	push   %ebx
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80083e:	89 c3                	mov    %eax,%ebx
  800840:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800843:	eb 06                	jmp    80084b <strncmp+0x17>
		n--, p++, q++;
  800845:	83 c0 01             	add    $0x1,%eax
  800848:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80084b:	39 d8                	cmp    %ebx,%eax
  80084d:	74 15                	je     800864 <strncmp+0x30>
  80084f:	0f b6 08             	movzbl (%eax),%ecx
  800852:	84 c9                	test   %cl,%cl
  800854:	74 04                	je     80085a <strncmp+0x26>
  800856:	3a 0a                	cmp    (%edx),%cl
  800858:	74 eb                	je     800845 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80085a:	0f b6 00             	movzbl (%eax),%eax
  80085d:	0f b6 12             	movzbl (%edx),%edx
  800860:	29 d0                	sub    %edx,%eax
  800862:	eb 05                	jmp    800869 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800864:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800869:	5b                   	pop    %ebx
  80086a:	5d                   	pop    %ebp
  80086b:	c3                   	ret    

0080086c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80086c:	55                   	push   %ebp
  80086d:	89 e5                	mov    %esp,%ebp
  80086f:	8b 45 08             	mov    0x8(%ebp),%eax
  800872:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800876:	eb 07                	jmp    80087f <strchr+0x13>
		if (*s == c)
  800878:	38 ca                	cmp    %cl,%dl
  80087a:	74 0f                	je     80088b <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80087c:	83 c0 01             	add    $0x1,%eax
  80087f:	0f b6 10             	movzbl (%eax),%edx
  800882:	84 d2                	test   %dl,%dl
  800884:	75 f2                	jne    800878 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800886:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80088b:	5d                   	pop    %ebp
  80088c:	c3                   	ret    

0080088d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80088d:	55                   	push   %ebp
  80088e:	89 e5                	mov    %esp,%ebp
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800897:	eb 03                	jmp    80089c <strfind+0xf>
  800899:	83 c0 01             	add    $0x1,%eax
  80089c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80089f:	38 ca                	cmp    %cl,%dl
  8008a1:	74 04                	je     8008a7 <strfind+0x1a>
  8008a3:	84 d2                	test   %dl,%dl
  8008a5:	75 f2                	jne    800899 <strfind+0xc>
			break;
	return (char *) s;
}
  8008a7:	5d                   	pop    %ebp
  8008a8:	c3                   	ret    

008008a9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008a9:	55                   	push   %ebp
  8008aa:	89 e5                	mov    %esp,%ebp
  8008ac:	57                   	push   %edi
  8008ad:	56                   	push   %esi
  8008ae:	53                   	push   %ebx
  8008af:	8b 55 08             	mov    0x8(%ebp),%edx
  8008b2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  8008b5:	85 c9                	test   %ecx,%ecx
  8008b7:	74 37                	je     8008f0 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008b9:	f6 c2 03             	test   $0x3,%dl
  8008bc:	75 2a                	jne    8008e8 <memset+0x3f>
  8008be:	f6 c1 03             	test   $0x3,%cl
  8008c1:	75 25                	jne    8008e8 <memset+0x3f>
		c &= 0xFF;
  8008c3:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008c7:	89 df                	mov    %ebx,%edi
  8008c9:	c1 e7 08             	shl    $0x8,%edi
  8008cc:	89 de                	mov    %ebx,%esi
  8008ce:	c1 e6 18             	shl    $0x18,%esi
  8008d1:	89 d8                	mov    %ebx,%eax
  8008d3:	c1 e0 10             	shl    $0x10,%eax
  8008d6:	09 f0                	or     %esi,%eax
  8008d8:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8008da:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8008dd:	89 f8                	mov    %edi,%eax
  8008df:	09 d8                	or     %ebx,%eax
  8008e1:	89 d7                	mov    %edx,%edi
  8008e3:	fc                   	cld    
  8008e4:	f3 ab                	rep stos %eax,%es:(%edi)
  8008e6:	eb 08                	jmp    8008f0 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008e8:	89 d7                	mov    %edx,%edi
  8008ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ed:	fc                   	cld    
  8008ee:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8008f0:	89 d0                	mov    %edx,%eax
  8008f2:	5b                   	pop    %ebx
  8008f3:	5e                   	pop    %esi
  8008f4:	5f                   	pop    %edi
  8008f5:	5d                   	pop    %ebp
  8008f6:	c3                   	ret    

008008f7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008f7:	55                   	push   %ebp
  8008f8:	89 e5                	mov    %esp,%ebp
  8008fa:	57                   	push   %edi
  8008fb:	56                   	push   %esi
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	8b 75 0c             	mov    0xc(%ebp),%esi
  800902:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800905:	39 c6                	cmp    %eax,%esi
  800907:	73 35                	jae    80093e <memmove+0x47>
  800909:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80090c:	39 d0                	cmp    %edx,%eax
  80090e:	73 2e                	jae    80093e <memmove+0x47>
		s += n;
		d += n;
  800910:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800913:	89 d6                	mov    %edx,%esi
  800915:	09 fe                	or     %edi,%esi
  800917:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80091d:	75 13                	jne    800932 <memmove+0x3b>
  80091f:	f6 c1 03             	test   $0x3,%cl
  800922:	75 0e                	jne    800932 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  800924:	83 ef 04             	sub    $0x4,%edi
  800927:	8d 72 fc             	lea    -0x4(%edx),%esi
  80092a:	c1 e9 02             	shr    $0x2,%ecx
  80092d:	fd                   	std    
  80092e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800930:	eb 09                	jmp    80093b <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800932:	83 ef 01             	sub    $0x1,%edi
  800935:	8d 72 ff             	lea    -0x1(%edx),%esi
  800938:	fd                   	std    
  800939:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80093b:	fc                   	cld    
  80093c:	eb 1d                	jmp    80095b <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80093e:	89 f2                	mov    %esi,%edx
  800940:	09 c2                	or     %eax,%edx
  800942:	f6 c2 03             	test   $0x3,%dl
  800945:	75 0f                	jne    800956 <memmove+0x5f>
  800947:	f6 c1 03             	test   $0x3,%cl
  80094a:	75 0a                	jne    800956 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  80094c:	c1 e9 02             	shr    $0x2,%ecx
  80094f:	89 c7                	mov    %eax,%edi
  800951:	fc                   	cld    
  800952:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800954:	eb 05                	jmp    80095b <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800956:	89 c7                	mov    %eax,%edi
  800958:	fc                   	cld    
  800959:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80095b:	5e                   	pop    %esi
  80095c:	5f                   	pop    %edi
  80095d:	5d                   	pop    %ebp
  80095e:	c3                   	ret    

0080095f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80095f:	55                   	push   %ebp
  800960:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800962:	ff 75 10             	pushl  0x10(%ebp)
  800965:	ff 75 0c             	pushl  0xc(%ebp)
  800968:	ff 75 08             	pushl  0x8(%ebp)
  80096b:	e8 87 ff ff ff       	call   8008f7 <memmove>
}
  800970:	c9                   	leave  
  800971:	c3                   	ret    

00800972 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	56                   	push   %esi
  800976:	53                   	push   %ebx
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097d:	89 c6                	mov    %eax,%esi
  80097f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800982:	eb 1a                	jmp    80099e <memcmp+0x2c>
		if (*s1 != *s2)
  800984:	0f b6 08             	movzbl (%eax),%ecx
  800987:	0f b6 1a             	movzbl (%edx),%ebx
  80098a:	38 d9                	cmp    %bl,%cl
  80098c:	74 0a                	je     800998 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  80098e:	0f b6 c1             	movzbl %cl,%eax
  800991:	0f b6 db             	movzbl %bl,%ebx
  800994:	29 d8                	sub    %ebx,%eax
  800996:	eb 0f                	jmp    8009a7 <memcmp+0x35>
		s1++, s2++;
  800998:	83 c0 01             	add    $0x1,%eax
  80099b:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80099e:	39 f0                	cmp    %esi,%eax
  8009a0:	75 e2                	jne    800984 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8009a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009a7:	5b                   	pop    %ebx
  8009a8:	5e                   	pop    %esi
  8009a9:	5d                   	pop    %ebp
  8009aa:	c3                   	ret    

008009ab <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	53                   	push   %ebx
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  8009b2:	89 c1                	mov    %eax,%ecx
  8009b4:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  8009b7:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8009bb:	eb 0a                	jmp    8009c7 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009bd:	0f b6 10             	movzbl (%eax),%edx
  8009c0:	39 da                	cmp    %ebx,%edx
  8009c2:	74 07                	je     8009cb <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8009c4:	83 c0 01             	add    $0x1,%eax
  8009c7:	39 c8                	cmp    %ecx,%eax
  8009c9:	72 f2                	jb     8009bd <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8009cb:	5b                   	pop    %ebx
  8009cc:	5d                   	pop    %ebp
  8009cd:	c3                   	ret    

008009ce <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009ce:	55                   	push   %ebp
  8009cf:	89 e5                	mov    %esp,%ebp
  8009d1:	57                   	push   %edi
  8009d2:	56                   	push   %esi
  8009d3:	53                   	push   %ebx
  8009d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009da:	eb 03                	jmp    8009df <strtol+0x11>
		s++;
  8009dc:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009df:	0f b6 01             	movzbl (%ecx),%eax
  8009e2:	3c 20                	cmp    $0x20,%al
  8009e4:	74 f6                	je     8009dc <strtol+0xe>
  8009e6:	3c 09                	cmp    $0x9,%al
  8009e8:	74 f2                	je     8009dc <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8009ea:	3c 2b                	cmp    $0x2b,%al
  8009ec:	75 0a                	jne    8009f8 <strtol+0x2a>
		s++;
  8009ee:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8009f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8009f6:	eb 11                	jmp    800a09 <strtol+0x3b>
  8009f8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8009fd:	3c 2d                	cmp    $0x2d,%al
  8009ff:	75 08                	jne    800a09 <strtol+0x3b>
		s++, neg = 1;
  800a01:	83 c1 01             	add    $0x1,%ecx
  800a04:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a09:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a0f:	75 15                	jne    800a26 <strtol+0x58>
  800a11:	80 39 30             	cmpb   $0x30,(%ecx)
  800a14:	75 10                	jne    800a26 <strtol+0x58>
  800a16:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a1a:	75 7c                	jne    800a98 <strtol+0xca>
		s += 2, base = 16;
  800a1c:	83 c1 02             	add    $0x2,%ecx
  800a1f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a24:	eb 16                	jmp    800a3c <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800a26:	85 db                	test   %ebx,%ebx
  800a28:	75 12                	jne    800a3c <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a2a:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a2f:	80 39 30             	cmpb   $0x30,(%ecx)
  800a32:	75 08                	jne    800a3c <strtol+0x6e>
		s++, base = 8;
  800a34:	83 c1 01             	add    $0x1,%ecx
  800a37:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800a3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a41:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800a44:	0f b6 11             	movzbl (%ecx),%edx
  800a47:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a4a:	89 f3                	mov    %esi,%ebx
  800a4c:	80 fb 09             	cmp    $0x9,%bl
  800a4f:	77 08                	ja     800a59 <strtol+0x8b>
			dig = *s - '0';
  800a51:	0f be d2             	movsbl %dl,%edx
  800a54:	83 ea 30             	sub    $0x30,%edx
  800a57:	eb 22                	jmp    800a7b <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800a59:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a5c:	89 f3                	mov    %esi,%ebx
  800a5e:	80 fb 19             	cmp    $0x19,%bl
  800a61:	77 08                	ja     800a6b <strtol+0x9d>
			dig = *s - 'a' + 10;
  800a63:	0f be d2             	movsbl %dl,%edx
  800a66:	83 ea 57             	sub    $0x57,%edx
  800a69:	eb 10                	jmp    800a7b <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800a6b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a6e:	89 f3                	mov    %esi,%ebx
  800a70:	80 fb 19             	cmp    $0x19,%bl
  800a73:	77 16                	ja     800a8b <strtol+0xbd>
			dig = *s - 'A' + 10;
  800a75:	0f be d2             	movsbl %dl,%edx
  800a78:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800a7b:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a7e:	7d 0b                	jge    800a8b <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800a80:	83 c1 01             	add    $0x1,%ecx
  800a83:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a87:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800a89:	eb b9                	jmp    800a44 <strtol+0x76>

	if (endptr)
  800a8b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a8f:	74 0d                	je     800a9e <strtol+0xd0>
		*endptr = (char *) s;
  800a91:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a94:	89 0e                	mov    %ecx,(%esi)
  800a96:	eb 06                	jmp    800a9e <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a98:	85 db                	test   %ebx,%ebx
  800a9a:	74 98                	je     800a34 <strtol+0x66>
  800a9c:	eb 9e                	jmp    800a3c <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800a9e:	89 c2                	mov    %eax,%edx
  800aa0:	f7 da                	neg    %edx
  800aa2:	85 ff                	test   %edi,%edi
  800aa4:	0f 45 c2             	cmovne %edx,%eax
}
  800aa7:	5b                   	pop    %ebx
  800aa8:	5e                   	pop    %esi
  800aa9:	5f                   	pop    %edi
  800aaa:	5d                   	pop    %ebp
  800aab:	c3                   	ret    

00800aac <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	57                   	push   %edi
  800ab0:	56                   	push   %esi
  800ab1:	53                   	push   %ebx
  800ab2:	83 ec 1c             	sub    $0x1c,%esp
  800ab5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ab8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800abb:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800abd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ac3:	8b 7d 10             	mov    0x10(%ebp),%edi
  800ac6:	8b 75 14             	mov    0x14(%ebp),%esi
  800ac9:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800acb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800acf:	74 1d                	je     800aee <syscall+0x42>
  800ad1:	85 c0                	test   %eax,%eax
  800ad3:	7e 19                	jle    800aee <syscall+0x42>
  800ad5:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800ad8:	83 ec 0c             	sub    $0xc,%esp
  800adb:	50                   	push   %eax
  800adc:	52                   	push   %edx
  800add:	68 df 21 80 00       	push   $0x8021df
  800ae2:	6a 23                	push   $0x23
  800ae4:	68 fc 21 80 00       	push   $0x8021fc
  800ae9:	e8 2b f6 ff ff       	call   800119 <_panic>

	return ret;
}
  800aee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800af1:	5b                   	pop    %ebx
  800af2:	5e                   	pop    %esi
  800af3:	5f                   	pop    %edi
  800af4:	5d                   	pop    %ebp
  800af5:	c3                   	ret    

00800af6 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800afc:	6a 00                	push   $0x0
  800afe:	6a 00                	push   $0x0
  800b00:	6a 00                	push   $0x0
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b08:	ba 00 00 00 00       	mov    $0x0,%edx
  800b0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b12:	e8 95 ff ff ff       	call   800aac <syscall>
}
  800b17:	83 c4 10             	add    $0x10,%esp
  800b1a:	c9                   	leave  
  800b1b:	c3                   	ret    

00800b1c <sys_cgetc>:

int
sys_cgetc(void)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800b22:	6a 00                	push   $0x0
  800b24:	6a 00                	push   $0x0
  800b26:	6a 00                	push   $0x0
  800b28:	6a 00                	push   $0x0
  800b2a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b34:	b8 01 00 00 00       	mov    $0x1,%eax
  800b39:	e8 6e ff ff ff       	call   800aac <syscall>
}
  800b3e:	c9                   	leave  
  800b3f:	c3                   	ret    

00800b40 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800b46:	6a 00                	push   $0x0
  800b48:	6a 00                	push   $0x0
  800b4a:	6a 00                	push   $0x0
  800b4c:	6a 00                	push   $0x0
  800b4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b51:	ba 01 00 00 00       	mov    $0x1,%edx
  800b56:	b8 03 00 00 00       	mov    $0x3,%eax
  800b5b:	e8 4c ff ff ff       	call   800aac <syscall>
}
  800b60:	c9                   	leave  
  800b61:	c3                   	ret    

00800b62 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b62:	55                   	push   %ebp
  800b63:	89 e5                	mov    %esp,%ebp
  800b65:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b68:	6a 00                	push   $0x0
  800b6a:	6a 00                	push   $0x0
  800b6c:	6a 00                	push   $0x0
  800b6e:	6a 00                	push   $0x0
  800b70:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b75:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7a:	b8 02 00 00 00       	mov    $0x2,%eax
  800b7f:	e8 28 ff ff ff       	call   800aac <syscall>
}
  800b84:	c9                   	leave  
  800b85:	c3                   	ret    

00800b86 <sys_yield>:

void
sys_yield(void)
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b8c:	6a 00                	push   $0x0
  800b8e:	6a 00                	push   $0x0
  800b90:	6a 00                	push   $0x0
  800b92:	6a 00                	push   $0x0
  800b94:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b99:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ba3:	e8 04 ff ff ff       	call   800aac <syscall>
}
  800ba8:	83 c4 10             	add    $0x10,%esp
  800bab:	c9                   	leave  
  800bac:	c3                   	ret    

00800bad <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800bb3:	6a 00                	push   $0x0
  800bb5:	6a 00                	push   $0x0
  800bb7:	ff 75 10             	pushl  0x10(%ebp)
  800bba:	ff 75 0c             	pushl  0xc(%ebp)
  800bbd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc0:	ba 01 00 00 00       	mov    $0x1,%edx
  800bc5:	b8 04 00 00 00       	mov    $0x4,%eax
  800bca:	e8 dd fe ff ff       	call   800aac <syscall>
}
  800bcf:	c9                   	leave  
  800bd0:	c3                   	ret    

00800bd1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800bd7:	ff 75 18             	pushl  0x18(%ebp)
  800bda:	ff 75 14             	pushl  0x14(%ebp)
  800bdd:	ff 75 10             	pushl  0x10(%ebp)
  800be0:	ff 75 0c             	pushl  0xc(%ebp)
  800be3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800be6:	ba 01 00 00 00       	mov    $0x1,%edx
  800beb:	b8 05 00 00 00       	mov    $0x5,%eax
  800bf0:	e8 b7 fe ff ff       	call   800aac <syscall>
}
  800bf5:	c9                   	leave  
  800bf6:	c3                   	ret    

00800bf7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800bfd:	6a 00                	push   $0x0
  800bff:	6a 00                	push   $0x0
  800c01:	6a 00                	push   $0x0
  800c03:	ff 75 0c             	pushl  0xc(%ebp)
  800c06:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c09:	ba 01 00 00 00       	mov    $0x1,%edx
  800c0e:	b8 06 00 00 00       	mov    $0x6,%eax
  800c13:	e8 94 fe ff ff       	call   800aac <syscall>
}
  800c18:	c9                   	leave  
  800c19:	c3                   	ret    

00800c1a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c20:	6a 00                	push   $0x0
  800c22:	6a 00                	push   $0x0
  800c24:	6a 00                	push   $0x0
  800c26:	ff 75 0c             	pushl  0xc(%ebp)
  800c29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c2c:	ba 01 00 00 00       	mov    $0x1,%edx
  800c31:	b8 08 00 00 00       	mov    $0x8,%eax
  800c36:	e8 71 fe ff ff       	call   800aac <syscall>
}
  800c3b:	c9                   	leave  
  800c3c:	c3                   	ret    

00800c3d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800c43:	6a 00                	push   $0x0
  800c45:	6a 00                	push   $0x0
  800c47:	6a 00                	push   $0x0
  800c49:	ff 75 0c             	pushl  0xc(%ebp)
  800c4c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c4f:	ba 01 00 00 00       	mov    $0x1,%edx
  800c54:	b8 09 00 00 00       	mov    $0x9,%eax
  800c59:	e8 4e fe ff ff       	call   800aac <syscall>
}
  800c5e:	c9                   	leave  
  800c5f:	c3                   	ret    

00800c60 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800c66:	6a 00                	push   $0x0
  800c68:	6a 00                	push   $0x0
  800c6a:	6a 00                	push   $0x0
  800c6c:	ff 75 0c             	pushl  0xc(%ebp)
  800c6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c72:	ba 01 00 00 00       	mov    $0x1,%edx
  800c77:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c7c:	e8 2b fe ff ff       	call   800aac <syscall>
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800c89:	6a 00                	push   $0x0
  800c8b:	ff 75 14             	pushl  0x14(%ebp)
  800c8e:	ff 75 10             	pushl  0x10(%ebp)
  800c91:	ff 75 0c             	pushl  0xc(%ebp)
  800c94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c97:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ca1:	e8 06 fe ff ff       	call   800aac <syscall>
}
  800ca6:	c9                   	leave  
  800ca7:	c3                   	ret    

00800ca8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800cae:	6a 00                	push   $0x0
  800cb0:	6a 00                	push   $0x0
  800cb2:	6a 00                	push   $0x0
  800cb4:	6a 00                	push   $0x0
  800cb6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cb9:	ba 01 00 00 00       	mov    $0x1,%edx
  800cbe:	b8 0d 00 00 00       	mov    $0xd,%eax
  800cc3:	e8 e4 fd ff ff       	call   800aac <syscall>
}
  800cc8:	c9                   	leave  
  800cc9:	c3                   	ret    

00800cca <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800cd0:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  800cd7:	75 2c                	jne    800d05 <set_pgfault_handler+0x3b>
		// First time through!
		// LAB 4: Your code here.
		r = sys_page_alloc(0,(void *)(UXSTACKTOP - PGSIZE),PTE_P | PTE_U | PTE_W);
  800cd9:	83 ec 04             	sub    $0x4,%esp
  800cdc:	6a 07                	push   $0x7
  800cde:	68 00 f0 bf ee       	push   $0xeebff000
  800ce3:	6a 00                	push   $0x0
  800ce5:	e8 c3 fe ff ff       	call   800bad <sys_page_alloc>
		if(r < 0)
  800cea:	83 c4 10             	add    $0x10,%esp
  800ced:	85 c0                	test   %eax,%eax
  800cef:	79 14                	jns    800d05 <set_pgfault_handler+0x3b>
			panic("set_pgfault_handler: error in sys_page_alloc\n");	
  800cf1:	83 ec 04             	sub    $0x4,%esp
  800cf4:	68 0c 22 80 00       	push   $0x80220c
  800cf9:	6a 22                	push   $0x22
  800cfb:	68 75 22 80 00       	push   $0x802275
  800d00:	e8 14 f4 ff ff       	call   800119 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	a3 08 40 80 00       	mov    %eax,0x804008
	r = sys_env_set_pgfault_upcall(0, _pgfault_upcall); 
  800d0d:	83 ec 08             	sub    $0x8,%esp
  800d10:	68 39 0d 80 00       	push   $0x800d39
  800d15:	6a 00                	push   $0x0
  800d17:	e8 44 ff ff ff       	call   800c60 <sys_env_set_pgfault_upcall>
	if (r < 0)
  800d1c:	83 c4 10             	add    $0x10,%esp
  800d1f:	85 c0                	test   %eax,%eax
  800d21:	79 14                	jns    800d37 <set_pgfault_handler+0x6d>
		panic("set_pgfault_handler: error in sys_env_set_pgfault_upcall");
  800d23:	83 ec 04             	sub    $0x4,%esp
  800d26:	68 3c 22 80 00       	push   $0x80223c
  800d2b:	6a 29                	push   $0x29
  800d2d:	68 75 22 80 00       	push   $0x802275
  800d32:	e8 e2 f3 ff ff       	call   800119 <_panic>
}
  800d37:	c9                   	leave  
  800d38:	c3                   	ret    

00800d39 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800d39:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800d3a:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax
  800d3f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800d41:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	subl $0x4, 0x30(%esp)
  800d44:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  800d49:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 0x28(%esp), %ebx 	
  800d4d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  800d51:	89 18                	mov    %ebx,(%eax)
	addl $0x8, %esp
  800d53:	83 c4 08             	add    $0x8,%esp


	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  800d56:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp 
  800d57:	83 c4 04             	add    $0x4,%esp
	popfl
  800d5a:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800d5b:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  800d5c:	c3                   	ret    

00800d5d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	05 00 00 00 30       	add    $0x30000000,%eax
  800d68:	c1 e8 0c             	shr    $0xc,%eax
}
  800d6b:	5d                   	pop    %ebp
  800d6c:	c3                   	ret    

00800d6d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  800d70:	ff 75 08             	pushl  0x8(%ebp)
  800d73:	e8 e5 ff ff ff       	call   800d5d <fd2num>
  800d78:	83 c4 04             	add    $0x4,%esp
  800d7b:	c1 e0 0c             	shl    $0xc,%eax
  800d7e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800d83:	c9                   	leave  
  800d84:	c3                   	ret    

00800d85 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d8b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800d90:	89 c2                	mov    %eax,%edx
  800d92:	c1 ea 16             	shr    $0x16,%edx
  800d95:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800d9c:	f6 c2 01             	test   $0x1,%dl
  800d9f:	74 11                	je     800db2 <fd_alloc+0x2d>
  800da1:	89 c2                	mov    %eax,%edx
  800da3:	c1 ea 0c             	shr    $0xc,%edx
  800da6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800dad:	f6 c2 01             	test   $0x1,%dl
  800db0:	75 09                	jne    800dbb <fd_alloc+0x36>
			*fd_store = fd;
  800db2:	89 01                	mov    %eax,(%ecx)
			return 0;
  800db4:	b8 00 00 00 00       	mov    $0x0,%eax
  800db9:	eb 17                	jmp    800dd2 <fd_alloc+0x4d>
  800dbb:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800dc0:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800dc5:	75 c9                	jne    800d90 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800dc7:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800dcd:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    

00800dd4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800dda:	83 f8 1f             	cmp    $0x1f,%eax
  800ddd:	77 36                	ja     800e15 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800ddf:	c1 e0 0c             	shl    $0xc,%eax
  800de2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800de7:	89 c2                	mov    %eax,%edx
  800de9:	c1 ea 16             	shr    $0x16,%edx
  800dec:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800df3:	f6 c2 01             	test   $0x1,%dl
  800df6:	74 24                	je     800e1c <fd_lookup+0x48>
  800df8:	89 c2                	mov    %eax,%edx
  800dfa:	c1 ea 0c             	shr    $0xc,%edx
  800dfd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e04:	f6 c2 01             	test   $0x1,%dl
  800e07:	74 1a                	je     800e23 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e0c:	89 02                	mov    %eax,(%edx)
	return 0;
  800e0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e13:	eb 13                	jmp    800e28 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800e15:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e1a:	eb 0c                	jmp    800e28 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800e1c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e21:	eb 05                	jmp    800e28 <fd_lookup+0x54>
  800e23:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    

00800e2a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	83 ec 08             	sub    $0x8,%esp
  800e30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e33:	ba 04 23 80 00       	mov    $0x802304,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800e38:	eb 13                	jmp    800e4d <dev_lookup+0x23>
  800e3a:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  800e3d:	39 08                	cmp    %ecx,(%eax)
  800e3f:	75 0c                	jne    800e4d <dev_lookup+0x23>
			*dev = devtab[i];
  800e41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e44:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e46:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4b:	eb 2e                	jmp    800e7b <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800e4d:	8b 02                	mov    (%edx),%eax
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	75 e7                	jne    800e3a <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e53:	a1 04 40 80 00       	mov    0x804004,%eax
  800e58:	8b 40 48             	mov    0x48(%eax),%eax
  800e5b:	83 ec 04             	sub    $0x4,%esp
  800e5e:	51                   	push   %ecx
  800e5f:	50                   	push   %eax
  800e60:	68 84 22 80 00       	push   $0x802284
  800e65:	e8 88 f3 ff ff       	call   8001f2 <cprintf>
	*dev = 0;
  800e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e73:	83 c4 10             	add    $0x10,%esp
  800e76:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	56                   	push   %esi
  800e81:	53                   	push   %ebx
  800e82:	83 ec 10             	sub    $0x10,%esp
  800e85:	8b 75 08             	mov    0x8(%ebp),%esi
  800e88:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e8b:	56                   	push   %esi
  800e8c:	e8 cc fe ff ff       	call   800d5d <fd2num>
  800e91:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800e94:	89 14 24             	mov    %edx,(%esp)
  800e97:	50                   	push   %eax
  800e98:	e8 37 ff ff ff       	call   800dd4 <fd_lookup>
  800e9d:	83 c4 08             	add    $0x8,%esp
  800ea0:	85 c0                	test   %eax,%eax
  800ea2:	78 05                	js     800ea9 <fd_close+0x2c>
	    || fd != fd2)
  800ea4:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800ea7:	74 0c                	je     800eb5 <fd_close+0x38>
		return (must_exist ? r : 0);
  800ea9:	84 db                	test   %bl,%bl
  800eab:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb0:	0f 44 c2             	cmove  %edx,%eax
  800eb3:	eb 41                	jmp    800ef6 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800eb5:	83 ec 08             	sub    $0x8,%esp
  800eb8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ebb:	50                   	push   %eax
  800ebc:	ff 36                	pushl  (%esi)
  800ebe:	e8 67 ff ff ff       	call   800e2a <dev_lookup>
  800ec3:	89 c3                	mov    %eax,%ebx
  800ec5:	83 c4 10             	add    $0x10,%esp
  800ec8:	85 c0                	test   %eax,%eax
  800eca:	78 1a                	js     800ee6 <fd_close+0x69>
		if (dev->dev_close)
  800ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ecf:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800ed2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800ed7:	85 c0                	test   %eax,%eax
  800ed9:	74 0b                	je     800ee6 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  800edb:	83 ec 0c             	sub    $0xc,%esp
  800ede:	56                   	push   %esi
  800edf:	ff d0                	call   *%eax
  800ee1:	89 c3                	mov    %eax,%ebx
  800ee3:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800ee6:	83 ec 08             	sub    $0x8,%esp
  800ee9:	56                   	push   %esi
  800eea:	6a 00                	push   $0x0
  800eec:	e8 06 fd ff ff       	call   800bf7 <sys_page_unmap>
	return r;
  800ef1:	83 c4 10             	add    $0x10,%esp
  800ef4:	89 d8                	mov    %ebx,%eax
}
  800ef6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ef9:	5b                   	pop    %ebx
  800efa:	5e                   	pop    %esi
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    

00800efd <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f03:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f06:	50                   	push   %eax
  800f07:	ff 75 08             	pushl  0x8(%ebp)
  800f0a:	e8 c5 fe ff ff       	call   800dd4 <fd_lookup>
  800f0f:	83 c4 08             	add    $0x8,%esp
  800f12:	85 c0                	test   %eax,%eax
  800f14:	78 10                	js     800f26 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800f16:	83 ec 08             	sub    $0x8,%esp
  800f19:	6a 01                	push   $0x1
  800f1b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f1e:	e8 5a ff ff ff       	call   800e7d <fd_close>
  800f23:	83 c4 10             	add    $0x10,%esp
}
  800f26:	c9                   	leave  
  800f27:	c3                   	ret    

00800f28 <close_all>:

void
close_all(void)
{
  800f28:	55                   	push   %ebp
  800f29:	89 e5                	mov    %esp,%ebp
  800f2b:	53                   	push   %ebx
  800f2c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f2f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f34:	83 ec 0c             	sub    $0xc,%esp
  800f37:	53                   	push   %ebx
  800f38:	e8 c0 ff ff ff       	call   800efd <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800f3d:	83 c3 01             	add    $0x1,%ebx
  800f40:	83 c4 10             	add    $0x10,%esp
  800f43:	83 fb 20             	cmp    $0x20,%ebx
  800f46:	75 ec                	jne    800f34 <close_all+0xc>
		close(i);
}
  800f48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f4b:	c9                   	leave  
  800f4c:	c3                   	ret    

00800f4d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
  800f50:	57                   	push   %edi
  800f51:	56                   	push   %esi
  800f52:	53                   	push   %ebx
  800f53:	83 ec 2c             	sub    $0x2c,%esp
  800f56:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f59:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f5c:	50                   	push   %eax
  800f5d:	ff 75 08             	pushl  0x8(%ebp)
  800f60:	e8 6f fe ff ff       	call   800dd4 <fd_lookup>
  800f65:	83 c4 08             	add    $0x8,%esp
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	0f 88 c1 00 00 00    	js     801031 <dup+0xe4>
		return r;
	close(newfdnum);
  800f70:	83 ec 0c             	sub    $0xc,%esp
  800f73:	56                   	push   %esi
  800f74:	e8 84 ff ff ff       	call   800efd <close>

	newfd = INDEX2FD(newfdnum);
  800f79:	89 f3                	mov    %esi,%ebx
  800f7b:	c1 e3 0c             	shl    $0xc,%ebx
  800f7e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800f84:	83 c4 04             	add    $0x4,%esp
  800f87:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f8a:	e8 de fd ff ff       	call   800d6d <fd2data>
  800f8f:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  800f91:	89 1c 24             	mov    %ebx,(%esp)
  800f94:	e8 d4 fd ff ff       	call   800d6d <fd2data>
  800f99:	83 c4 10             	add    $0x10,%esp
  800f9c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800f9f:	89 f8                	mov    %edi,%eax
  800fa1:	c1 e8 16             	shr    $0x16,%eax
  800fa4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fab:	a8 01                	test   $0x1,%al
  800fad:	74 37                	je     800fe6 <dup+0x99>
  800faf:	89 f8                	mov    %edi,%eax
  800fb1:	c1 e8 0c             	shr    $0xc,%eax
  800fb4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fbb:	f6 c2 01             	test   $0x1,%dl
  800fbe:	74 26                	je     800fe6 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800fc0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fc7:	83 ec 0c             	sub    $0xc,%esp
  800fca:	25 07 0e 00 00       	and    $0xe07,%eax
  800fcf:	50                   	push   %eax
  800fd0:	ff 75 d4             	pushl  -0x2c(%ebp)
  800fd3:	6a 00                	push   $0x0
  800fd5:	57                   	push   %edi
  800fd6:	6a 00                	push   $0x0
  800fd8:	e8 f4 fb ff ff       	call   800bd1 <sys_page_map>
  800fdd:	89 c7                	mov    %eax,%edi
  800fdf:	83 c4 20             	add    $0x20,%esp
  800fe2:	85 c0                	test   %eax,%eax
  800fe4:	78 2e                	js     801014 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800fe6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800fe9:	89 d0                	mov    %edx,%eax
  800feb:	c1 e8 0c             	shr    $0xc,%eax
  800fee:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ff5:	83 ec 0c             	sub    $0xc,%esp
  800ff8:	25 07 0e 00 00       	and    $0xe07,%eax
  800ffd:	50                   	push   %eax
  800ffe:	53                   	push   %ebx
  800fff:	6a 00                	push   $0x0
  801001:	52                   	push   %edx
  801002:	6a 00                	push   $0x0
  801004:	e8 c8 fb ff ff       	call   800bd1 <sys_page_map>
  801009:	89 c7                	mov    %eax,%edi
  80100b:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  80100e:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801010:	85 ff                	test   %edi,%edi
  801012:	79 1d                	jns    801031 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801014:	83 ec 08             	sub    $0x8,%esp
  801017:	53                   	push   %ebx
  801018:	6a 00                	push   $0x0
  80101a:	e8 d8 fb ff ff       	call   800bf7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80101f:	83 c4 08             	add    $0x8,%esp
  801022:	ff 75 d4             	pushl  -0x2c(%ebp)
  801025:	6a 00                	push   $0x0
  801027:	e8 cb fb ff ff       	call   800bf7 <sys_page_unmap>
	return r;
  80102c:	83 c4 10             	add    $0x10,%esp
  80102f:	89 f8                	mov    %edi,%eax
}
  801031:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801034:	5b                   	pop    %ebx
  801035:	5e                   	pop    %esi
  801036:	5f                   	pop    %edi
  801037:	5d                   	pop    %ebp
  801038:	c3                   	ret    

00801039 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	53                   	push   %ebx
  80103d:	83 ec 14             	sub    $0x14,%esp
  801040:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801043:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801046:	50                   	push   %eax
  801047:	53                   	push   %ebx
  801048:	e8 87 fd ff ff       	call   800dd4 <fd_lookup>
  80104d:	83 c4 08             	add    $0x8,%esp
  801050:	89 c2                	mov    %eax,%edx
  801052:	85 c0                	test   %eax,%eax
  801054:	78 6d                	js     8010c3 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801056:	83 ec 08             	sub    $0x8,%esp
  801059:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80105c:	50                   	push   %eax
  80105d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801060:	ff 30                	pushl  (%eax)
  801062:	e8 c3 fd ff ff       	call   800e2a <dev_lookup>
  801067:	83 c4 10             	add    $0x10,%esp
  80106a:	85 c0                	test   %eax,%eax
  80106c:	78 4c                	js     8010ba <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80106e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801071:	8b 42 08             	mov    0x8(%edx),%eax
  801074:	83 e0 03             	and    $0x3,%eax
  801077:	83 f8 01             	cmp    $0x1,%eax
  80107a:	75 21                	jne    80109d <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80107c:	a1 04 40 80 00       	mov    0x804004,%eax
  801081:	8b 40 48             	mov    0x48(%eax),%eax
  801084:	83 ec 04             	sub    $0x4,%esp
  801087:	53                   	push   %ebx
  801088:	50                   	push   %eax
  801089:	68 c8 22 80 00       	push   $0x8022c8
  80108e:	e8 5f f1 ff ff       	call   8001f2 <cprintf>
		return -E_INVAL;
  801093:	83 c4 10             	add    $0x10,%esp
  801096:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80109b:	eb 26                	jmp    8010c3 <read+0x8a>
	}
	if (!dev->dev_read)
  80109d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010a0:	8b 40 08             	mov    0x8(%eax),%eax
  8010a3:	85 c0                	test   %eax,%eax
  8010a5:	74 17                	je     8010be <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8010a7:	83 ec 04             	sub    $0x4,%esp
  8010aa:	ff 75 10             	pushl  0x10(%ebp)
  8010ad:	ff 75 0c             	pushl  0xc(%ebp)
  8010b0:	52                   	push   %edx
  8010b1:	ff d0                	call   *%eax
  8010b3:	89 c2                	mov    %eax,%edx
  8010b5:	83 c4 10             	add    $0x10,%esp
  8010b8:	eb 09                	jmp    8010c3 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010ba:	89 c2                	mov    %eax,%edx
  8010bc:	eb 05                	jmp    8010c3 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8010be:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  8010c3:	89 d0                	mov    %edx,%eax
  8010c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010c8:	c9                   	leave  
  8010c9:	c3                   	ret    

008010ca <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
  8010cd:	57                   	push   %edi
  8010ce:	56                   	push   %esi
  8010cf:	53                   	push   %ebx
  8010d0:	83 ec 0c             	sub    $0xc,%esp
  8010d3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010d6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8010d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010de:	eb 21                	jmp    801101 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010e0:	83 ec 04             	sub    $0x4,%esp
  8010e3:	89 f0                	mov    %esi,%eax
  8010e5:	29 d8                	sub    %ebx,%eax
  8010e7:	50                   	push   %eax
  8010e8:	89 d8                	mov    %ebx,%eax
  8010ea:	03 45 0c             	add    0xc(%ebp),%eax
  8010ed:	50                   	push   %eax
  8010ee:	57                   	push   %edi
  8010ef:	e8 45 ff ff ff       	call   801039 <read>
		if (m < 0)
  8010f4:	83 c4 10             	add    $0x10,%esp
  8010f7:	85 c0                	test   %eax,%eax
  8010f9:	78 10                	js     80110b <readn+0x41>
			return m;
		if (m == 0)
  8010fb:	85 c0                	test   %eax,%eax
  8010fd:	74 0a                	je     801109 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8010ff:	01 c3                	add    %eax,%ebx
  801101:	39 f3                	cmp    %esi,%ebx
  801103:	72 db                	jb     8010e0 <readn+0x16>
  801105:	89 d8                	mov    %ebx,%eax
  801107:	eb 02                	jmp    80110b <readn+0x41>
  801109:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80110b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80110e:	5b                   	pop    %ebx
  80110f:	5e                   	pop    %esi
  801110:	5f                   	pop    %edi
  801111:	5d                   	pop    %ebp
  801112:	c3                   	ret    

00801113 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801113:	55                   	push   %ebp
  801114:	89 e5                	mov    %esp,%ebp
  801116:	53                   	push   %ebx
  801117:	83 ec 14             	sub    $0x14,%esp
  80111a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80111d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801120:	50                   	push   %eax
  801121:	53                   	push   %ebx
  801122:	e8 ad fc ff ff       	call   800dd4 <fd_lookup>
  801127:	83 c4 08             	add    $0x8,%esp
  80112a:	89 c2                	mov    %eax,%edx
  80112c:	85 c0                	test   %eax,%eax
  80112e:	78 68                	js     801198 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801130:	83 ec 08             	sub    $0x8,%esp
  801133:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801136:	50                   	push   %eax
  801137:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80113a:	ff 30                	pushl  (%eax)
  80113c:	e8 e9 fc ff ff       	call   800e2a <dev_lookup>
  801141:	83 c4 10             	add    $0x10,%esp
  801144:	85 c0                	test   %eax,%eax
  801146:	78 47                	js     80118f <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801148:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80114b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80114f:	75 21                	jne    801172 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801151:	a1 04 40 80 00       	mov    0x804004,%eax
  801156:	8b 40 48             	mov    0x48(%eax),%eax
  801159:	83 ec 04             	sub    $0x4,%esp
  80115c:	53                   	push   %ebx
  80115d:	50                   	push   %eax
  80115e:	68 e4 22 80 00       	push   $0x8022e4
  801163:	e8 8a f0 ff ff       	call   8001f2 <cprintf>
		return -E_INVAL;
  801168:	83 c4 10             	add    $0x10,%esp
  80116b:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801170:	eb 26                	jmp    801198 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801172:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801175:	8b 52 0c             	mov    0xc(%edx),%edx
  801178:	85 d2                	test   %edx,%edx
  80117a:	74 17                	je     801193 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80117c:	83 ec 04             	sub    $0x4,%esp
  80117f:	ff 75 10             	pushl  0x10(%ebp)
  801182:	ff 75 0c             	pushl  0xc(%ebp)
  801185:	50                   	push   %eax
  801186:	ff d2                	call   *%edx
  801188:	89 c2                	mov    %eax,%edx
  80118a:	83 c4 10             	add    $0x10,%esp
  80118d:	eb 09                	jmp    801198 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80118f:	89 c2                	mov    %eax,%edx
  801191:	eb 05                	jmp    801198 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801193:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  801198:	89 d0                	mov    %edx,%eax
  80119a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80119d:	c9                   	leave  
  80119e:	c3                   	ret    

0080119f <seek>:

int
seek(int fdnum, off_t offset)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
  8011a2:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011a5:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8011a8:	50                   	push   %eax
  8011a9:	ff 75 08             	pushl  0x8(%ebp)
  8011ac:	e8 23 fc ff ff       	call   800dd4 <fd_lookup>
  8011b1:	83 c4 08             	add    $0x8,%esp
  8011b4:	85 c0                	test   %eax,%eax
  8011b6:	78 0e                	js     8011c6 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8011b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011be:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8011c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c6:	c9                   	leave  
  8011c7:	c3                   	ret    

008011c8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	53                   	push   %ebx
  8011cc:	83 ec 14             	sub    $0x14,%esp
  8011cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011d5:	50                   	push   %eax
  8011d6:	53                   	push   %ebx
  8011d7:	e8 f8 fb ff ff       	call   800dd4 <fd_lookup>
  8011dc:	83 c4 08             	add    $0x8,%esp
  8011df:	89 c2                	mov    %eax,%edx
  8011e1:	85 c0                	test   %eax,%eax
  8011e3:	78 65                	js     80124a <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011e5:	83 ec 08             	sub    $0x8,%esp
  8011e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011eb:	50                   	push   %eax
  8011ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ef:	ff 30                	pushl  (%eax)
  8011f1:	e8 34 fc ff ff       	call   800e2a <dev_lookup>
  8011f6:	83 c4 10             	add    $0x10,%esp
  8011f9:	85 c0                	test   %eax,%eax
  8011fb:	78 44                	js     801241 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801200:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801204:	75 21                	jne    801227 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801206:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80120b:	8b 40 48             	mov    0x48(%eax),%eax
  80120e:	83 ec 04             	sub    $0x4,%esp
  801211:	53                   	push   %ebx
  801212:	50                   	push   %eax
  801213:	68 a4 22 80 00       	push   $0x8022a4
  801218:	e8 d5 ef ff ff       	call   8001f2 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80121d:	83 c4 10             	add    $0x10,%esp
  801220:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801225:	eb 23                	jmp    80124a <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  801227:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122a:	8b 52 18             	mov    0x18(%edx),%edx
  80122d:	85 d2                	test   %edx,%edx
  80122f:	74 14                	je     801245 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801231:	83 ec 08             	sub    $0x8,%esp
  801234:	ff 75 0c             	pushl  0xc(%ebp)
  801237:	50                   	push   %eax
  801238:	ff d2                	call   *%edx
  80123a:	89 c2                	mov    %eax,%edx
  80123c:	83 c4 10             	add    $0x10,%esp
  80123f:	eb 09                	jmp    80124a <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801241:	89 c2                	mov    %eax,%edx
  801243:	eb 05                	jmp    80124a <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801245:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  80124a:	89 d0                	mov    %edx,%eax
  80124c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80124f:	c9                   	leave  
  801250:	c3                   	ret    

00801251 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	53                   	push   %ebx
  801255:	83 ec 14             	sub    $0x14,%esp
  801258:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80125b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80125e:	50                   	push   %eax
  80125f:	ff 75 08             	pushl  0x8(%ebp)
  801262:	e8 6d fb ff ff       	call   800dd4 <fd_lookup>
  801267:	83 c4 08             	add    $0x8,%esp
  80126a:	89 c2                	mov    %eax,%edx
  80126c:	85 c0                	test   %eax,%eax
  80126e:	78 58                	js     8012c8 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801270:	83 ec 08             	sub    $0x8,%esp
  801273:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801276:	50                   	push   %eax
  801277:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80127a:	ff 30                	pushl  (%eax)
  80127c:	e8 a9 fb ff ff       	call   800e2a <dev_lookup>
  801281:	83 c4 10             	add    $0x10,%esp
  801284:	85 c0                	test   %eax,%eax
  801286:	78 37                	js     8012bf <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  801288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80128b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80128f:	74 32                	je     8012c3 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801291:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801294:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80129b:	00 00 00 
	stat->st_isdir = 0;
  80129e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8012a5:	00 00 00 
	stat->st_dev = dev;
  8012a8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8012ae:	83 ec 08             	sub    $0x8,%esp
  8012b1:	53                   	push   %ebx
  8012b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8012b5:	ff 50 14             	call   *0x14(%eax)
  8012b8:	89 c2                	mov    %eax,%edx
  8012ba:	83 c4 10             	add    $0x10,%esp
  8012bd:	eb 09                	jmp    8012c8 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012bf:	89 c2                	mov    %eax,%edx
  8012c1:	eb 05                	jmp    8012c8 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8012c3:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8012c8:	89 d0                	mov    %edx,%eax
  8012ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012cd:	c9                   	leave  
  8012ce:	c3                   	ret    

008012cf <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
  8012d2:	56                   	push   %esi
  8012d3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8012d4:	83 ec 08             	sub    $0x8,%esp
  8012d7:	6a 00                	push   $0x0
  8012d9:	ff 75 08             	pushl  0x8(%ebp)
  8012dc:	e8 06 02 00 00       	call   8014e7 <open>
  8012e1:	89 c3                	mov    %eax,%ebx
  8012e3:	83 c4 10             	add    $0x10,%esp
  8012e6:	85 c0                	test   %eax,%eax
  8012e8:	78 1b                	js     801305 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8012ea:	83 ec 08             	sub    $0x8,%esp
  8012ed:	ff 75 0c             	pushl  0xc(%ebp)
  8012f0:	50                   	push   %eax
  8012f1:	e8 5b ff ff ff       	call   801251 <fstat>
  8012f6:	89 c6                	mov    %eax,%esi
	close(fd);
  8012f8:	89 1c 24             	mov    %ebx,(%esp)
  8012fb:	e8 fd fb ff ff       	call   800efd <close>
	return r;
  801300:	83 c4 10             	add    $0x10,%esp
  801303:	89 f0                	mov    %esi,%eax
}
  801305:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801308:	5b                   	pop    %ebx
  801309:	5e                   	pop    %esi
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    

0080130c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	56                   	push   %esi
  801310:	53                   	push   %ebx
  801311:	89 c6                	mov    %eax,%esi
  801313:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801315:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80131c:	75 12                	jne    801330 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80131e:	83 ec 0c             	sub    $0xc,%esp
  801321:	6a 01                	push   $0x1
  801323:	e8 01 08 00 00       	call   801b29 <ipc_find_env>
  801328:	a3 00 40 80 00       	mov    %eax,0x804000
  80132d:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801330:	6a 07                	push   $0x7
  801332:	68 00 50 80 00       	push   $0x805000
  801337:	56                   	push   %esi
  801338:	ff 35 00 40 80 00    	pushl  0x804000
  80133e:	e8 92 07 00 00       	call   801ad5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801343:	83 c4 0c             	add    $0xc,%esp
  801346:	6a 00                	push   $0x0
  801348:	53                   	push   %ebx
  801349:	6a 00                	push   $0x0
  80134b:	e8 1a 07 00 00       	call   801a6a <ipc_recv>
}
  801350:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801353:	5b                   	pop    %ebx
  801354:	5e                   	pop    %esi
  801355:	5d                   	pop    %ebp
  801356:	c3                   	ret    

00801357 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80135d:	8b 45 08             	mov    0x8(%ebp),%eax
  801360:	8b 40 0c             	mov    0xc(%eax),%eax
  801363:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801368:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801370:	ba 00 00 00 00       	mov    $0x0,%edx
  801375:	b8 02 00 00 00       	mov    $0x2,%eax
  80137a:	e8 8d ff ff ff       	call   80130c <fsipc>
}
  80137f:	c9                   	leave  
  801380:	c3                   	ret    

00801381 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
  801384:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	8b 40 0c             	mov    0xc(%eax),%eax
  80138d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801392:	ba 00 00 00 00       	mov    $0x0,%edx
  801397:	b8 06 00 00 00       	mov    $0x6,%eax
  80139c:	e8 6b ff ff ff       	call   80130c <fsipc>
}
  8013a1:	c9                   	leave  
  8013a2:	c3                   	ret    

008013a3 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8013a3:	55                   	push   %ebp
  8013a4:	89 e5                	mov    %esp,%ebp
  8013a6:	53                   	push   %ebx
  8013a7:	83 ec 04             	sub    $0x4,%esp
  8013aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8013b3:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8013b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8013bd:	b8 05 00 00 00       	mov    $0x5,%eax
  8013c2:	e8 45 ff ff ff       	call   80130c <fsipc>
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	78 2c                	js     8013f7 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8013cb:	83 ec 08             	sub    $0x8,%esp
  8013ce:	68 00 50 80 00       	push   $0x805000
  8013d3:	53                   	push   %ebx
  8013d4:	e8 8b f3 ff ff       	call   800764 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8013d9:	a1 80 50 80 00       	mov    0x805080,%eax
  8013de:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8013e4:	a1 84 50 80 00       	mov    0x805084,%eax
  8013e9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8013ef:	83 c4 10             	add    $0x10,%esp
  8013f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	83 ec 08             	sub    $0x8,%esp
  801402:	8b 55 0c             	mov    0xc(%ebp),%edx
  801405:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801408:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80140b:	8b 49 0c             	mov    0xc(%ecx),%ecx
  80140e:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  801414:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801419:	76 22                	jbe    80143d <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  80141b:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  801422:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  801425:	83 ec 04             	sub    $0x4,%esp
  801428:	68 f8 0f 00 00       	push   $0xff8
  80142d:	52                   	push   %edx
  80142e:	68 08 50 80 00       	push   $0x805008
  801433:	e8 bf f4 ff ff       	call   8008f7 <memmove>
  801438:	83 c4 10             	add    $0x10,%esp
  80143b:	eb 17                	jmp    801454 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  80143d:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  801442:	83 ec 04             	sub    $0x4,%esp
  801445:	50                   	push   %eax
  801446:	52                   	push   %edx
  801447:	68 08 50 80 00       	push   $0x805008
  80144c:	e8 a6 f4 ff ff       	call   8008f7 <memmove>
  801451:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  801454:	ba 00 00 00 00       	mov    $0x0,%edx
  801459:	b8 04 00 00 00       	mov    $0x4,%eax
  80145e:	e8 a9 fe ff ff       	call   80130c <fsipc>
	if (result < 0)
		return result;

	return result;
}
  801463:	c9                   	leave  
  801464:	c3                   	ret    

00801465 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801465:	55                   	push   %ebp
  801466:	89 e5                	mov    %esp,%ebp
  801468:	56                   	push   %esi
  801469:	53                   	push   %ebx
  80146a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8b 40 0c             	mov    0xc(%eax),%eax
  801473:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801478:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80147e:	ba 00 00 00 00       	mov    $0x0,%edx
  801483:	b8 03 00 00 00       	mov    $0x3,%eax
  801488:	e8 7f fe ff ff       	call   80130c <fsipc>
  80148d:	89 c3                	mov    %eax,%ebx
  80148f:	85 c0                	test   %eax,%eax
  801491:	78 4b                	js     8014de <devfile_read+0x79>
		return r;
	assert(r <= n);
  801493:	39 c6                	cmp    %eax,%esi
  801495:	73 16                	jae    8014ad <devfile_read+0x48>
  801497:	68 14 23 80 00       	push   $0x802314
  80149c:	68 1b 23 80 00       	push   $0x80231b
  8014a1:	6a 7c                	push   $0x7c
  8014a3:	68 30 23 80 00       	push   $0x802330
  8014a8:	e8 6c ec ff ff       	call   800119 <_panic>
	assert(r <= PGSIZE);
  8014ad:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8014b2:	7e 16                	jle    8014ca <devfile_read+0x65>
  8014b4:	68 3b 23 80 00       	push   $0x80233b
  8014b9:	68 1b 23 80 00       	push   $0x80231b
  8014be:	6a 7d                	push   $0x7d
  8014c0:	68 30 23 80 00       	push   $0x802330
  8014c5:	e8 4f ec ff ff       	call   800119 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8014ca:	83 ec 04             	sub    $0x4,%esp
  8014cd:	50                   	push   %eax
  8014ce:	68 00 50 80 00       	push   $0x805000
  8014d3:	ff 75 0c             	pushl  0xc(%ebp)
  8014d6:	e8 1c f4 ff ff       	call   8008f7 <memmove>
	return r;
  8014db:	83 c4 10             	add    $0x10,%esp
}
  8014de:	89 d8                	mov    %ebx,%eax
  8014e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014e3:	5b                   	pop    %ebx
  8014e4:	5e                   	pop    %esi
  8014e5:	5d                   	pop    %ebp
  8014e6:	c3                   	ret    

008014e7 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
  8014ea:	53                   	push   %ebx
  8014eb:	83 ec 20             	sub    $0x20,%esp
  8014ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8014f1:	53                   	push   %ebx
  8014f2:	e8 34 f2 ff ff       	call   80072b <strlen>
  8014f7:	83 c4 10             	add    $0x10,%esp
  8014fa:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8014ff:	7f 67                	jg     801568 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801501:	83 ec 0c             	sub    $0xc,%esp
  801504:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801507:	50                   	push   %eax
  801508:	e8 78 f8 ff ff       	call   800d85 <fd_alloc>
  80150d:	83 c4 10             	add    $0x10,%esp
		return r;
  801510:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801512:	85 c0                	test   %eax,%eax
  801514:	78 57                	js     80156d <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801516:	83 ec 08             	sub    $0x8,%esp
  801519:	53                   	push   %ebx
  80151a:	68 00 50 80 00       	push   $0x805000
  80151f:	e8 40 f2 ff ff       	call   800764 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801524:	8b 45 0c             	mov    0xc(%ebp),%eax
  801527:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80152c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80152f:	b8 01 00 00 00       	mov    $0x1,%eax
  801534:	e8 d3 fd ff ff       	call   80130c <fsipc>
  801539:	89 c3                	mov    %eax,%ebx
  80153b:	83 c4 10             	add    $0x10,%esp
  80153e:	85 c0                	test   %eax,%eax
  801540:	79 14                	jns    801556 <open+0x6f>
		fd_close(fd, 0);
  801542:	83 ec 08             	sub    $0x8,%esp
  801545:	6a 00                	push   $0x0
  801547:	ff 75 f4             	pushl  -0xc(%ebp)
  80154a:	e8 2e f9 ff ff       	call   800e7d <fd_close>
		return r;
  80154f:	83 c4 10             	add    $0x10,%esp
  801552:	89 da                	mov    %ebx,%edx
  801554:	eb 17                	jmp    80156d <open+0x86>
	}

	return fd2num(fd);
  801556:	83 ec 0c             	sub    $0xc,%esp
  801559:	ff 75 f4             	pushl  -0xc(%ebp)
  80155c:	e8 fc f7 ff ff       	call   800d5d <fd2num>
  801561:	89 c2                	mov    %eax,%edx
  801563:	83 c4 10             	add    $0x10,%esp
  801566:	eb 05                	jmp    80156d <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801568:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  80156d:	89 d0                	mov    %edx,%eax
  80156f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80157a:	ba 00 00 00 00       	mov    $0x0,%edx
  80157f:	b8 08 00 00 00       	mov    $0x8,%eax
  801584:	e8 83 fd ff ff       	call   80130c <fsipc>
}
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

0080158b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	56                   	push   %esi
  80158f:	53                   	push   %ebx
  801590:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801593:	83 ec 0c             	sub    $0xc,%esp
  801596:	ff 75 08             	pushl  0x8(%ebp)
  801599:	e8 cf f7 ff ff       	call   800d6d <fd2data>
  80159e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8015a0:	83 c4 08             	add    $0x8,%esp
  8015a3:	68 47 23 80 00       	push   $0x802347
  8015a8:	53                   	push   %ebx
  8015a9:	e8 b6 f1 ff ff       	call   800764 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8015ae:	8b 46 04             	mov    0x4(%esi),%eax
  8015b1:	2b 06                	sub    (%esi),%eax
  8015b3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8015b9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015c0:	00 00 00 
	stat->st_dev = &devpipe;
  8015c3:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8015ca:	30 80 00 
	return 0;
}
  8015cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015d5:	5b                   	pop    %ebx
  8015d6:	5e                   	pop    %esi
  8015d7:	5d                   	pop    %ebp
  8015d8:	c3                   	ret    

008015d9 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	53                   	push   %ebx
  8015dd:	83 ec 0c             	sub    $0xc,%esp
  8015e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8015e3:	53                   	push   %ebx
  8015e4:	6a 00                	push   $0x0
  8015e6:	e8 0c f6 ff ff       	call   800bf7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8015eb:	89 1c 24             	mov    %ebx,(%esp)
  8015ee:	e8 7a f7 ff ff       	call   800d6d <fd2data>
  8015f3:	83 c4 08             	add    $0x8,%esp
  8015f6:	50                   	push   %eax
  8015f7:	6a 00                	push   $0x0
  8015f9:	e8 f9 f5 ff ff       	call   800bf7 <sys_page_unmap>
}
  8015fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	57                   	push   %edi
  801607:	56                   	push   %esi
  801608:	53                   	push   %ebx
  801609:	83 ec 1c             	sub    $0x1c,%esp
  80160c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80160f:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801611:	a1 04 40 80 00       	mov    0x804004,%eax
  801616:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801619:	83 ec 0c             	sub    $0xc,%esp
  80161c:	ff 75 e0             	pushl  -0x20(%ebp)
  80161f:	e8 3e 05 00 00       	call   801b62 <pageref>
  801624:	89 c3                	mov    %eax,%ebx
  801626:	89 3c 24             	mov    %edi,(%esp)
  801629:	e8 34 05 00 00       	call   801b62 <pageref>
  80162e:	83 c4 10             	add    $0x10,%esp
  801631:	39 c3                	cmp    %eax,%ebx
  801633:	0f 94 c1             	sete   %cl
  801636:	0f b6 c9             	movzbl %cl,%ecx
  801639:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  80163c:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801642:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801645:	39 ce                	cmp    %ecx,%esi
  801647:	74 1b                	je     801664 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801649:	39 c3                	cmp    %eax,%ebx
  80164b:	75 c4                	jne    801611 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80164d:	8b 42 58             	mov    0x58(%edx),%eax
  801650:	ff 75 e4             	pushl  -0x1c(%ebp)
  801653:	50                   	push   %eax
  801654:	56                   	push   %esi
  801655:	68 4e 23 80 00       	push   $0x80234e
  80165a:	e8 93 eb ff ff       	call   8001f2 <cprintf>
  80165f:	83 c4 10             	add    $0x10,%esp
  801662:	eb ad                	jmp    801611 <_pipeisclosed+0xe>
	}
}
  801664:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801667:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80166a:	5b                   	pop    %ebx
  80166b:	5e                   	pop    %esi
  80166c:	5f                   	pop    %edi
  80166d:	5d                   	pop    %ebp
  80166e:	c3                   	ret    

0080166f <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	57                   	push   %edi
  801673:	56                   	push   %esi
  801674:	53                   	push   %ebx
  801675:	83 ec 28             	sub    $0x28,%esp
  801678:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80167b:	56                   	push   %esi
  80167c:	e8 ec f6 ff ff       	call   800d6d <fd2data>
  801681:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801683:	83 c4 10             	add    $0x10,%esp
  801686:	bf 00 00 00 00       	mov    $0x0,%edi
  80168b:	eb 4b                	jmp    8016d8 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80168d:	89 da                	mov    %ebx,%edx
  80168f:	89 f0                	mov    %esi,%eax
  801691:	e8 6d ff ff ff       	call   801603 <_pipeisclosed>
  801696:	85 c0                	test   %eax,%eax
  801698:	75 48                	jne    8016e2 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80169a:	e8 e7 f4 ff ff       	call   800b86 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80169f:	8b 43 04             	mov    0x4(%ebx),%eax
  8016a2:	8b 0b                	mov    (%ebx),%ecx
  8016a4:	8d 51 20             	lea    0x20(%ecx),%edx
  8016a7:	39 d0                	cmp    %edx,%eax
  8016a9:	73 e2                	jae    80168d <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8016ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016ae:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8016b2:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8016b5:	89 c2                	mov    %eax,%edx
  8016b7:	c1 fa 1f             	sar    $0x1f,%edx
  8016ba:	89 d1                	mov    %edx,%ecx
  8016bc:	c1 e9 1b             	shr    $0x1b,%ecx
  8016bf:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8016c2:	83 e2 1f             	and    $0x1f,%edx
  8016c5:	29 ca                	sub    %ecx,%edx
  8016c7:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8016cb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8016cf:	83 c0 01             	add    $0x1,%eax
  8016d2:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8016d5:	83 c7 01             	add    $0x1,%edi
  8016d8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8016db:	75 c2                	jne    80169f <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8016dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e0:	eb 05                	jmp    8016e7 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8016e2:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8016e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016ea:	5b                   	pop    %ebx
  8016eb:	5e                   	pop    %esi
  8016ec:	5f                   	pop    %edi
  8016ed:	5d                   	pop    %ebp
  8016ee:	c3                   	ret    

008016ef <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	57                   	push   %edi
  8016f3:	56                   	push   %esi
  8016f4:	53                   	push   %ebx
  8016f5:	83 ec 18             	sub    $0x18,%esp
  8016f8:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8016fb:	57                   	push   %edi
  8016fc:	e8 6c f6 ff ff       	call   800d6d <fd2data>
  801701:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801703:	83 c4 10             	add    $0x10,%esp
  801706:	bb 00 00 00 00       	mov    $0x0,%ebx
  80170b:	eb 3d                	jmp    80174a <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80170d:	85 db                	test   %ebx,%ebx
  80170f:	74 04                	je     801715 <devpipe_read+0x26>
				return i;
  801711:	89 d8                	mov    %ebx,%eax
  801713:	eb 44                	jmp    801759 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801715:	89 f2                	mov    %esi,%edx
  801717:	89 f8                	mov    %edi,%eax
  801719:	e8 e5 fe ff ff       	call   801603 <_pipeisclosed>
  80171e:	85 c0                	test   %eax,%eax
  801720:	75 32                	jne    801754 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801722:	e8 5f f4 ff ff       	call   800b86 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801727:	8b 06                	mov    (%esi),%eax
  801729:	3b 46 04             	cmp    0x4(%esi),%eax
  80172c:	74 df                	je     80170d <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80172e:	99                   	cltd   
  80172f:	c1 ea 1b             	shr    $0x1b,%edx
  801732:	01 d0                	add    %edx,%eax
  801734:	83 e0 1f             	and    $0x1f,%eax
  801737:	29 d0                	sub    %edx,%eax
  801739:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  80173e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801741:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801744:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801747:	83 c3 01             	add    $0x1,%ebx
  80174a:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  80174d:	75 d8                	jne    801727 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80174f:	8b 45 10             	mov    0x10(%ebp),%eax
  801752:	eb 05                	jmp    801759 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801754:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801759:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80175c:	5b                   	pop    %ebx
  80175d:	5e                   	pop    %esi
  80175e:	5f                   	pop    %edi
  80175f:	5d                   	pop    %ebp
  801760:	c3                   	ret    

00801761 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
  801764:	56                   	push   %esi
  801765:	53                   	push   %ebx
  801766:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801769:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80176c:	50                   	push   %eax
  80176d:	e8 13 f6 ff ff       	call   800d85 <fd_alloc>
  801772:	83 c4 10             	add    $0x10,%esp
  801775:	89 c2                	mov    %eax,%edx
  801777:	85 c0                	test   %eax,%eax
  801779:	0f 88 2c 01 00 00    	js     8018ab <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80177f:	83 ec 04             	sub    $0x4,%esp
  801782:	68 07 04 00 00       	push   $0x407
  801787:	ff 75 f4             	pushl  -0xc(%ebp)
  80178a:	6a 00                	push   $0x0
  80178c:	e8 1c f4 ff ff       	call   800bad <sys_page_alloc>
  801791:	83 c4 10             	add    $0x10,%esp
  801794:	89 c2                	mov    %eax,%edx
  801796:	85 c0                	test   %eax,%eax
  801798:	0f 88 0d 01 00 00    	js     8018ab <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80179e:	83 ec 0c             	sub    $0xc,%esp
  8017a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017a4:	50                   	push   %eax
  8017a5:	e8 db f5 ff ff       	call   800d85 <fd_alloc>
  8017aa:	89 c3                	mov    %eax,%ebx
  8017ac:	83 c4 10             	add    $0x10,%esp
  8017af:	85 c0                	test   %eax,%eax
  8017b1:	0f 88 e2 00 00 00    	js     801899 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017b7:	83 ec 04             	sub    $0x4,%esp
  8017ba:	68 07 04 00 00       	push   $0x407
  8017bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8017c2:	6a 00                	push   $0x0
  8017c4:	e8 e4 f3 ff ff       	call   800bad <sys_page_alloc>
  8017c9:	89 c3                	mov    %eax,%ebx
  8017cb:	83 c4 10             	add    $0x10,%esp
  8017ce:	85 c0                	test   %eax,%eax
  8017d0:	0f 88 c3 00 00 00    	js     801899 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8017d6:	83 ec 0c             	sub    $0xc,%esp
  8017d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8017dc:	e8 8c f5 ff ff       	call   800d6d <fd2data>
  8017e1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017e3:	83 c4 0c             	add    $0xc,%esp
  8017e6:	68 07 04 00 00       	push   $0x407
  8017eb:	50                   	push   %eax
  8017ec:	6a 00                	push   $0x0
  8017ee:	e8 ba f3 ff ff       	call   800bad <sys_page_alloc>
  8017f3:	89 c3                	mov    %eax,%ebx
  8017f5:	83 c4 10             	add    $0x10,%esp
  8017f8:	85 c0                	test   %eax,%eax
  8017fa:	0f 88 89 00 00 00    	js     801889 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801800:	83 ec 0c             	sub    $0xc,%esp
  801803:	ff 75 f0             	pushl  -0x10(%ebp)
  801806:	e8 62 f5 ff ff       	call   800d6d <fd2data>
  80180b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801812:	50                   	push   %eax
  801813:	6a 00                	push   $0x0
  801815:	56                   	push   %esi
  801816:	6a 00                	push   $0x0
  801818:	e8 b4 f3 ff ff       	call   800bd1 <sys_page_map>
  80181d:	89 c3                	mov    %eax,%ebx
  80181f:	83 c4 20             	add    $0x20,%esp
  801822:	85 c0                	test   %eax,%eax
  801824:	78 55                	js     80187b <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801826:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80182c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182f:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801834:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  80183b:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801844:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801846:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801849:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801850:	83 ec 0c             	sub    $0xc,%esp
  801853:	ff 75 f4             	pushl  -0xc(%ebp)
  801856:	e8 02 f5 ff ff       	call   800d5d <fd2num>
  80185b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80185e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801860:	83 c4 04             	add    $0x4,%esp
  801863:	ff 75 f0             	pushl  -0x10(%ebp)
  801866:	e8 f2 f4 ff ff       	call   800d5d <fd2num>
  80186b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80186e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801871:	83 c4 10             	add    $0x10,%esp
  801874:	ba 00 00 00 00       	mov    $0x0,%edx
  801879:	eb 30                	jmp    8018ab <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  80187b:	83 ec 08             	sub    $0x8,%esp
  80187e:	56                   	push   %esi
  80187f:	6a 00                	push   $0x0
  801881:	e8 71 f3 ff ff       	call   800bf7 <sys_page_unmap>
  801886:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801889:	83 ec 08             	sub    $0x8,%esp
  80188c:	ff 75 f0             	pushl  -0x10(%ebp)
  80188f:	6a 00                	push   $0x0
  801891:	e8 61 f3 ff ff       	call   800bf7 <sys_page_unmap>
  801896:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801899:	83 ec 08             	sub    $0x8,%esp
  80189c:	ff 75 f4             	pushl  -0xc(%ebp)
  80189f:	6a 00                	push   $0x0
  8018a1:	e8 51 f3 ff ff       	call   800bf7 <sys_page_unmap>
  8018a6:	83 c4 10             	add    $0x10,%esp
  8018a9:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  8018ab:	89 d0                	mov    %edx,%eax
  8018ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b0:	5b                   	pop    %ebx
  8018b1:	5e                   	pop    %esi
  8018b2:	5d                   	pop    %ebp
  8018b3:	c3                   	ret    

008018b4 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018bd:	50                   	push   %eax
  8018be:	ff 75 08             	pushl  0x8(%ebp)
  8018c1:	e8 0e f5 ff ff       	call   800dd4 <fd_lookup>
  8018c6:	83 c4 10             	add    $0x10,%esp
  8018c9:	85 c0                	test   %eax,%eax
  8018cb:	78 18                	js     8018e5 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8018cd:	83 ec 0c             	sub    $0xc,%esp
  8018d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8018d3:	e8 95 f4 ff ff       	call   800d6d <fd2data>
	return _pipeisclosed(fd, p);
  8018d8:	89 c2                	mov    %eax,%edx
  8018da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018dd:	e8 21 fd ff ff       	call   801603 <_pipeisclosed>
  8018e2:	83 c4 10             	add    $0x10,%esp
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8018ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ef:	5d                   	pop    %ebp
  8018f0:	c3                   	ret    

008018f1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
  8018f4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8018f7:	68 66 23 80 00       	push   $0x802366
  8018fc:	ff 75 0c             	pushl  0xc(%ebp)
  8018ff:	e8 60 ee ff ff       	call   800764 <strcpy>
	return 0;
}
  801904:	b8 00 00 00 00       	mov    $0x0,%eax
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	57                   	push   %edi
  80190f:	56                   	push   %esi
  801910:	53                   	push   %ebx
  801911:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801917:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80191c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801922:	eb 2d                	jmp    801951 <devcons_write+0x46>
		m = n - tot;
  801924:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801927:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801929:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80192c:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801931:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801934:	83 ec 04             	sub    $0x4,%esp
  801937:	53                   	push   %ebx
  801938:	03 45 0c             	add    0xc(%ebp),%eax
  80193b:	50                   	push   %eax
  80193c:	57                   	push   %edi
  80193d:	e8 b5 ef ff ff       	call   8008f7 <memmove>
		sys_cputs(buf, m);
  801942:	83 c4 08             	add    $0x8,%esp
  801945:	53                   	push   %ebx
  801946:	57                   	push   %edi
  801947:	e8 aa f1 ff ff       	call   800af6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80194c:	01 de                	add    %ebx,%esi
  80194e:	83 c4 10             	add    $0x10,%esp
  801951:	89 f0                	mov    %esi,%eax
  801953:	3b 75 10             	cmp    0x10(%ebp),%esi
  801956:	72 cc                	jb     801924 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801958:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80195b:	5b                   	pop    %ebx
  80195c:	5e                   	pop    %esi
  80195d:	5f                   	pop    %edi
  80195e:	5d                   	pop    %ebp
  80195f:	c3                   	ret    

00801960 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 08             	sub    $0x8,%esp
  801966:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  80196b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80196f:	74 2a                	je     80199b <devcons_read+0x3b>
  801971:	eb 05                	jmp    801978 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801973:	e8 0e f2 ff ff       	call   800b86 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801978:	e8 9f f1 ff ff       	call   800b1c <sys_cgetc>
  80197d:	85 c0                	test   %eax,%eax
  80197f:	74 f2                	je     801973 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801981:	85 c0                	test   %eax,%eax
  801983:	78 16                	js     80199b <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801985:	83 f8 04             	cmp    $0x4,%eax
  801988:	74 0c                	je     801996 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80198a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198d:	88 02                	mov    %al,(%edx)
	return 1;
  80198f:	b8 01 00 00 00       	mov    $0x1,%eax
  801994:	eb 05                	jmp    80199b <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801996:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
  8019a0:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8019a9:	6a 01                	push   $0x1
  8019ab:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8019ae:	50                   	push   %eax
  8019af:	e8 42 f1 ff ff       	call   800af6 <sys_cputs>
}
  8019b4:	83 c4 10             	add    $0x10,%esp
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <getchar>:

int
getchar(void)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
  8019bc:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8019bf:	6a 01                	push   $0x1
  8019c1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8019c4:	50                   	push   %eax
  8019c5:	6a 00                	push   $0x0
  8019c7:	e8 6d f6 ff ff       	call   801039 <read>
	if (r < 0)
  8019cc:	83 c4 10             	add    $0x10,%esp
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	78 0f                	js     8019e2 <getchar+0x29>
		return r;
	if (r < 1)
  8019d3:	85 c0                	test   %eax,%eax
  8019d5:	7e 06                	jle    8019dd <getchar+0x24>
		return -E_EOF;
	return c;
  8019d7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8019db:	eb 05                	jmp    8019e2 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8019dd:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ed:	50                   	push   %eax
  8019ee:	ff 75 08             	pushl  0x8(%ebp)
  8019f1:	e8 de f3 ff ff       	call   800dd4 <fd_lookup>
  8019f6:	83 c4 10             	add    $0x10,%esp
  8019f9:	85 c0                	test   %eax,%eax
  8019fb:	78 11                	js     801a0e <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8019fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a00:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a06:	39 10                	cmp    %edx,(%eax)
  801a08:	0f 94 c0             	sete   %al
  801a0b:	0f b6 c0             	movzbl %al,%eax
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <opencons>:

int
opencons(void)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801a16:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a19:	50                   	push   %eax
  801a1a:	e8 66 f3 ff ff       	call   800d85 <fd_alloc>
  801a1f:	83 c4 10             	add    $0x10,%esp
		return r;
  801a22:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801a24:	85 c0                	test   %eax,%eax
  801a26:	78 3e                	js     801a66 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801a28:	83 ec 04             	sub    $0x4,%esp
  801a2b:	68 07 04 00 00       	push   $0x407
  801a30:	ff 75 f4             	pushl  -0xc(%ebp)
  801a33:	6a 00                	push   $0x0
  801a35:	e8 73 f1 ff ff       	call   800bad <sys_page_alloc>
  801a3a:	83 c4 10             	add    $0x10,%esp
		return r;
  801a3d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801a3f:	85 c0                	test   %eax,%eax
  801a41:	78 23                	js     801a66 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801a43:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a51:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801a58:	83 ec 0c             	sub    $0xc,%esp
  801a5b:	50                   	push   %eax
  801a5c:	e8 fc f2 ff ff       	call   800d5d <fd2num>
  801a61:	89 c2                	mov    %eax,%edx
  801a63:	83 c4 10             	add    $0x10,%esp
}
  801a66:	89 d0                	mov    %edx,%eax
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	56                   	push   %esi
  801a6e:	53                   	push   %ebx
  801a6f:	8b 75 08             	mov    0x8(%ebp),%esi
  801a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a75:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801a78:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801a7a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801a7f:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801a82:	83 ec 0c             	sub    $0xc,%esp
  801a85:	50                   	push   %eax
  801a86:	e8 1d f2 ff ff       	call   800ca8 <sys_ipc_recv>
	if (from_env_store)
  801a8b:	83 c4 10             	add    $0x10,%esp
  801a8e:	85 f6                	test   %esi,%esi
  801a90:	74 0b                	je     801a9d <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801a92:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a98:	8b 52 74             	mov    0x74(%edx),%edx
  801a9b:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801a9d:	85 db                	test   %ebx,%ebx
  801a9f:	74 0b                	je     801aac <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  801aa1:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801aa7:	8b 52 78             	mov    0x78(%edx),%edx
  801aaa:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  801aac:	85 c0                	test   %eax,%eax
  801aae:	79 16                	jns    801ac6 <ipc_recv+0x5c>
		if (from_env_store)
  801ab0:	85 f6                	test   %esi,%esi
  801ab2:	74 06                	je     801aba <ipc_recv+0x50>
			*from_env_store = 0;
  801ab4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  801aba:	85 db                	test   %ebx,%ebx
  801abc:	74 10                	je     801ace <ipc_recv+0x64>
			*perm_store = 0;
  801abe:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ac4:	eb 08                	jmp    801ace <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  801ac6:	a1 04 40 80 00       	mov    0x804004,%eax
  801acb:	8b 40 70             	mov    0x70(%eax),%eax
}
  801ace:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad1:	5b                   	pop    %ebx
  801ad2:	5e                   	pop    %esi
  801ad3:	5d                   	pop    %ebp
  801ad4:	c3                   	ret    

00801ad5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	57                   	push   %edi
  801ad9:	56                   	push   %esi
  801ada:	53                   	push   %ebx
  801adb:	83 ec 0c             	sub    $0xc,%esp
  801ade:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ae1:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ae4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  801ae7:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  801ae9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801aee:	0f 44 d8             	cmove  %eax,%ebx
  801af1:	eb 1c                	jmp    801b0f <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  801af3:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801af6:	74 12                	je     801b0a <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801af8:	50                   	push   %eax
  801af9:	68 72 23 80 00       	push   $0x802372
  801afe:	6a 42                	push   $0x42
  801b00:	68 88 23 80 00       	push   $0x802388
  801b05:	e8 0f e6 ff ff       	call   800119 <_panic>
		sys_yield();
  801b0a:	e8 77 f0 ff ff       	call   800b86 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801b0f:	ff 75 14             	pushl  0x14(%ebp)
  801b12:	53                   	push   %ebx
  801b13:	56                   	push   %esi
  801b14:	57                   	push   %edi
  801b15:	e8 69 f1 ff ff       	call   800c83 <sys_ipc_try_send>
  801b1a:	83 c4 10             	add    $0x10,%esp
  801b1d:	85 c0                	test   %eax,%eax
  801b1f:	75 d2                	jne    801af3 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801b21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b24:	5b                   	pop    %ebx
  801b25:	5e                   	pop    %esi
  801b26:	5f                   	pop    %edi
  801b27:	5d                   	pop    %ebp
  801b28:	c3                   	ret    

00801b29 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
  801b2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801b2f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801b34:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801b37:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801b3d:	8b 52 50             	mov    0x50(%edx),%edx
  801b40:	39 ca                	cmp    %ecx,%edx
  801b42:	75 0d                	jne    801b51 <ipc_find_env+0x28>
			return envs[i].env_id;
  801b44:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b47:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b4c:	8b 40 48             	mov    0x48(%eax),%eax
  801b4f:	eb 0f                	jmp    801b60 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801b51:	83 c0 01             	add    $0x1,%eax
  801b54:	3d 00 04 00 00       	cmp    $0x400,%eax
  801b59:	75 d9                	jne    801b34 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801b5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b60:	5d                   	pop    %ebp
  801b61:	c3                   	ret    

00801b62 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
  801b65:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b68:	89 d0                	mov    %edx,%eax
  801b6a:	c1 e8 16             	shr    $0x16,%eax
  801b6d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801b74:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b79:	f6 c1 01             	test   $0x1,%cl
  801b7c:	74 1d                	je     801b9b <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801b7e:	c1 ea 0c             	shr    $0xc,%edx
  801b81:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801b88:	f6 c2 01             	test   $0x1,%dl
  801b8b:	74 0e                	je     801b9b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801b8d:	c1 ea 0c             	shr    $0xc,%edx
  801b90:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801b97:	ef 
  801b98:	0f b7 c0             	movzwl %ax,%eax
}
  801b9b:	5d                   	pop    %ebp
  801b9c:	c3                   	ret    
  801b9d:	66 90                	xchg   %ax,%ax
  801b9f:	90                   	nop

00801ba0 <__udivdi3>:
  801ba0:	55                   	push   %ebp
  801ba1:	57                   	push   %edi
  801ba2:	56                   	push   %esi
  801ba3:	53                   	push   %ebx
  801ba4:	83 ec 1c             	sub    $0x1c,%esp
  801ba7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801baf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bb7:	85 f6                	test   %esi,%esi
  801bb9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bbd:	89 ca                	mov    %ecx,%edx
  801bbf:	89 f8                	mov    %edi,%eax
  801bc1:	75 3d                	jne    801c00 <__udivdi3+0x60>
  801bc3:	39 cf                	cmp    %ecx,%edi
  801bc5:	0f 87 c5 00 00 00    	ja     801c90 <__udivdi3+0xf0>
  801bcb:	85 ff                	test   %edi,%edi
  801bcd:	89 fd                	mov    %edi,%ebp
  801bcf:	75 0b                	jne    801bdc <__udivdi3+0x3c>
  801bd1:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd6:	31 d2                	xor    %edx,%edx
  801bd8:	f7 f7                	div    %edi
  801bda:	89 c5                	mov    %eax,%ebp
  801bdc:	89 c8                	mov    %ecx,%eax
  801bde:	31 d2                	xor    %edx,%edx
  801be0:	f7 f5                	div    %ebp
  801be2:	89 c1                	mov    %eax,%ecx
  801be4:	89 d8                	mov    %ebx,%eax
  801be6:	89 cf                	mov    %ecx,%edi
  801be8:	f7 f5                	div    %ebp
  801bea:	89 c3                	mov    %eax,%ebx
  801bec:	89 d8                	mov    %ebx,%eax
  801bee:	89 fa                	mov    %edi,%edx
  801bf0:	83 c4 1c             	add    $0x1c,%esp
  801bf3:	5b                   	pop    %ebx
  801bf4:	5e                   	pop    %esi
  801bf5:	5f                   	pop    %edi
  801bf6:	5d                   	pop    %ebp
  801bf7:	c3                   	ret    
  801bf8:	90                   	nop
  801bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c00:	39 ce                	cmp    %ecx,%esi
  801c02:	77 74                	ja     801c78 <__udivdi3+0xd8>
  801c04:	0f bd fe             	bsr    %esi,%edi
  801c07:	83 f7 1f             	xor    $0x1f,%edi
  801c0a:	0f 84 98 00 00 00    	je     801ca8 <__udivdi3+0x108>
  801c10:	bb 20 00 00 00       	mov    $0x20,%ebx
  801c15:	89 f9                	mov    %edi,%ecx
  801c17:	89 c5                	mov    %eax,%ebp
  801c19:	29 fb                	sub    %edi,%ebx
  801c1b:	d3 e6                	shl    %cl,%esi
  801c1d:	89 d9                	mov    %ebx,%ecx
  801c1f:	d3 ed                	shr    %cl,%ebp
  801c21:	89 f9                	mov    %edi,%ecx
  801c23:	d3 e0                	shl    %cl,%eax
  801c25:	09 ee                	or     %ebp,%esi
  801c27:	89 d9                	mov    %ebx,%ecx
  801c29:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c2d:	89 d5                	mov    %edx,%ebp
  801c2f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c33:	d3 ed                	shr    %cl,%ebp
  801c35:	89 f9                	mov    %edi,%ecx
  801c37:	d3 e2                	shl    %cl,%edx
  801c39:	89 d9                	mov    %ebx,%ecx
  801c3b:	d3 e8                	shr    %cl,%eax
  801c3d:	09 c2                	or     %eax,%edx
  801c3f:	89 d0                	mov    %edx,%eax
  801c41:	89 ea                	mov    %ebp,%edx
  801c43:	f7 f6                	div    %esi
  801c45:	89 d5                	mov    %edx,%ebp
  801c47:	89 c3                	mov    %eax,%ebx
  801c49:	f7 64 24 0c          	mull   0xc(%esp)
  801c4d:	39 d5                	cmp    %edx,%ebp
  801c4f:	72 10                	jb     801c61 <__udivdi3+0xc1>
  801c51:	8b 74 24 08          	mov    0x8(%esp),%esi
  801c55:	89 f9                	mov    %edi,%ecx
  801c57:	d3 e6                	shl    %cl,%esi
  801c59:	39 c6                	cmp    %eax,%esi
  801c5b:	73 07                	jae    801c64 <__udivdi3+0xc4>
  801c5d:	39 d5                	cmp    %edx,%ebp
  801c5f:	75 03                	jne    801c64 <__udivdi3+0xc4>
  801c61:	83 eb 01             	sub    $0x1,%ebx
  801c64:	31 ff                	xor    %edi,%edi
  801c66:	89 d8                	mov    %ebx,%eax
  801c68:	89 fa                	mov    %edi,%edx
  801c6a:	83 c4 1c             	add    $0x1c,%esp
  801c6d:	5b                   	pop    %ebx
  801c6e:	5e                   	pop    %esi
  801c6f:	5f                   	pop    %edi
  801c70:	5d                   	pop    %ebp
  801c71:	c3                   	ret    
  801c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c78:	31 ff                	xor    %edi,%edi
  801c7a:	31 db                	xor    %ebx,%ebx
  801c7c:	89 d8                	mov    %ebx,%eax
  801c7e:	89 fa                	mov    %edi,%edx
  801c80:	83 c4 1c             	add    $0x1c,%esp
  801c83:	5b                   	pop    %ebx
  801c84:	5e                   	pop    %esi
  801c85:	5f                   	pop    %edi
  801c86:	5d                   	pop    %ebp
  801c87:	c3                   	ret    
  801c88:	90                   	nop
  801c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c90:	89 d8                	mov    %ebx,%eax
  801c92:	f7 f7                	div    %edi
  801c94:	31 ff                	xor    %edi,%edi
  801c96:	89 c3                	mov    %eax,%ebx
  801c98:	89 d8                	mov    %ebx,%eax
  801c9a:	89 fa                	mov    %edi,%edx
  801c9c:	83 c4 1c             	add    $0x1c,%esp
  801c9f:	5b                   	pop    %ebx
  801ca0:	5e                   	pop    %esi
  801ca1:	5f                   	pop    %edi
  801ca2:	5d                   	pop    %ebp
  801ca3:	c3                   	ret    
  801ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ca8:	39 ce                	cmp    %ecx,%esi
  801caa:	72 0c                	jb     801cb8 <__udivdi3+0x118>
  801cac:	31 db                	xor    %ebx,%ebx
  801cae:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801cb2:	0f 87 34 ff ff ff    	ja     801bec <__udivdi3+0x4c>
  801cb8:	bb 01 00 00 00       	mov    $0x1,%ebx
  801cbd:	e9 2a ff ff ff       	jmp    801bec <__udivdi3+0x4c>
  801cc2:	66 90                	xchg   %ax,%ax
  801cc4:	66 90                	xchg   %ax,%ax
  801cc6:	66 90                	xchg   %ax,%ax
  801cc8:	66 90                	xchg   %ax,%ax
  801cca:	66 90                	xchg   %ax,%ax
  801ccc:	66 90                	xchg   %ax,%ax
  801cce:	66 90                	xchg   %ax,%ax

00801cd0 <__umoddi3>:
  801cd0:	55                   	push   %ebp
  801cd1:	57                   	push   %edi
  801cd2:	56                   	push   %esi
  801cd3:	53                   	push   %ebx
  801cd4:	83 ec 1c             	sub    $0x1c,%esp
  801cd7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801cdb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801cdf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ce3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ce7:	85 d2                	test   %edx,%edx
  801ce9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ced:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cf1:	89 f3                	mov    %esi,%ebx
  801cf3:	89 3c 24             	mov    %edi,(%esp)
  801cf6:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cfa:	75 1c                	jne    801d18 <__umoddi3+0x48>
  801cfc:	39 f7                	cmp    %esi,%edi
  801cfe:	76 50                	jbe    801d50 <__umoddi3+0x80>
  801d00:	89 c8                	mov    %ecx,%eax
  801d02:	89 f2                	mov    %esi,%edx
  801d04:	f7 f7                	div    %edi
  801d06:	89 d0                	mov    %edx,%eax
  801d08:	31 d2                	xor    %edx,%edx
  801d0a:	83 c4 1c             	add    $0x1c,%esp
  801d0d:	5b                   	pop    %ebx
  801d0e:	5e                   	pop    %esi
  801d0f:	5f                   	pop    %edi
  801d10:	5d                   	pop    %ebp
  801d11:	c3                   	ret    
  801d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d18:	39 f2                	cmp    %esi,%edx
  801d1a:	89 d0                	mov    %edx,%eax
  801d1c:	77 52                	ja     801d70 <__umoddi3+0xa0>
  801d1e:	0f bd ea             	bsr    %edx,%ebp
  801d21:	83 f5 1f             	xor    $0x1f,%ebp
  801d24:	75 5a                	jne    801d80 <__umoddi3+0xb0>
  801d26:	3b 54 24 04          	cmp    0x4(%esp),%edx
  801d2a:	0f 82 e0 00 00 00    	jb     801e10 <__umoddi3+0x140>
  801d30:	39 0c 24             	cmp    %ecx,(%esp)
  801d33:	0f 86 d7 00 00 00    	jbe    801e10 <__umoddi3+0x140>
  801d39:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d3d:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d41:	83 c4 1c             	add    $0x1c,%esp
  801d44:	5b                   	pop    %ebx
  801d45:	5e                   	pop    %esi
  801d46:	5f                   	pop    %edi
  801d47:	5d                   	pop    %ebp
  801d48:	c3                   	ret    
  801d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d50:	85 ff                	test   %edi,%edi
  801d52:	89 fd                	mov    %edi,%ebp
  801d54:	75 0b                	jne    801d61 <__umoddi3+0x91>
  801d56:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5b:	31 d2                	xor    %edx,%edx
  801d5d:	f7 f7                	div    %edi
  801d5f:	89 c5                	mov    %eax,%ebp
  801d61:	89 f0                	mov    %esi,%eax
  801d63:	31 d2                	xor    %edx,%edx
  801d65:	f7 f5                	div    %ebp
  801d67:	89 c8                	mov    %ecx,%eax
  801d69:	f7 f5                	div    %ebp
  801d6b:	89 d0                	mov    %edx,%eax
  801d6d:	eb 99                	jmp    801d08 <__umoddi3+0x38>
  801d6f:	90                   	nop
  801d70:	89 c8                	mov    %ecx,%eax
  801d72:	89 f2                	mov    %esi,%edx
  801d74:	83 c4 1c             	add    $0x1c,%esp
  801d77:	5b                   	pop    %ebx
  801d78:	5e                   	pop    %esi
  801d79:	5f                   	pop    %edi
  801d7a:	5d                   	pop    %ebp
  801d7b:	c3                   	ret    
  801d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801d80:	8b 34 24             	mov    (%esp),%esi
  801d83:	bf 20 00 00 00       	mov    $0x20,%edi
  801d88:	89 e9                	mov    %ebp,%ecx
  801d8a:	29 ef                	sub    %ebp,%edi
  801d8c:	d3 e0                	shl    %cl,%eax
  801d8e:	89 f9                	mov    %edi,%ecx
  801d90:	89 f2                	mov    %esi,%edx
  801d92:	d3 ea                	shr    %cl,%edx
  801d94:	89 e9                	mov    %ebp,%ecx
  801d96:	09 c2                	or     %eax,%edx
  801d98:	89 d8                	mov    %ebx,%eax
  801d9a:	89 14 24             	mov    %edx,(%esp)
  801d9d:	89 f2                	mov    %esi,%edx
  801d9f:	d3 e2                	shl    %cl,%edx
  801da1:	89 f9                	mov    %edi,%ecx
  801da3:	89 54 24 04          	mov    %edx,0x4(%esp)
  801da7:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801dab:	d3 e8                	shr    %cl,%eax
  801dad:	89 e9                	mov    %ebp,%ecx
  801daf:	89 c6                	mov    %eax,%esi
  801db1:	d3 e3                	shl    %cl,%ebx
  801db3:	89 f9                	mov    %edi,%ecx
  801db5:	89 d0                	mov    %edx,%eax
  801db7:	d3 e8                	shr    %cl,%eax
  801db9:	89 e9                	mov    %ebp,%ecx
  801dbb:	09 d8                	or     %ebx,%eax
  801dbd:	89 d3                	mov    %edx,%ebx
  801dbf:	89 f2                	mov    %esi,%edx
  801dc1:	f7 34 24             	divl   (%esp)
  801dc4:	89 d6                	mov    %edx,%esi
  801dc6:	d3 e3                	shl    %cl,%ebx
  801dc8:	f7 64 24 04          	mull   0x4(%esp)
  801dcc:	39 d6                	cmp    %edx,%esi
  801dce:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801dd2:	89 d1                	mov    %edx,%ecx
  801dd4:	89 c3                	mov    %eax,%ebx
  801dd6:	72 08                	jb     801de0 <__umoddi3+0x110>
  801dd8:	75 11                	jne    801deb <__umoddi3+0x11b>
  801dda:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801dde:	73 0b                	jae    801deb <__umoddi3+0x11b>
  801de0:	2b 44 24 04          	sub    0x4(%esp),%eax
  801de4:	1b 14 24             	sbb    (%esp),%edx
  801de7:	89 d1                	mov    %edx,%ecx
  801de9:	89 c3                	mov    %eax,%ebx
  801deb:	8b 54 24 08          	mov    0x8(%esp),%edx
  801def:	29 da                	sub    %ebx,%edx
  801df1:	19 ce                	sbb    %ecx,%esi
  801df3:	89 f9                	mov    %edi,%ecx
  801df5:	89 f0                	mov    %esi,%eax
  801df7:	d3 e0                	shl    %cl,%eax
  801df9:	89 e9                	mov    %ebp,%ecx
  801dfb:	d3 ea                	shr    %cl,%edx
  801dfd:	89 e9                	mov    %ebp,%ecx
  801dff:	d3 ee                	shr    %cl,%esi
  801e01:	09 d0                	or     %edx,%eax
  801e03:	89 f2                	mov    %esi,%edx
  801e05:	83 c4 1c             	add    $0x1c,%esp
  801e08:	5b                   	pop    %ebx
  801e09:	5e                   	pop    %esi
  801e0a:	5f                   	pop    %edi
  801e0b:	5d                   	pop    %ebp
  801e0c:	c3                   	ret    
  801e0d:	8d 76 00             	lea    0x0(%esi),%esi
  801e10:	29 f9                	sub    %edi,%ecx
  801e12:	19 d6                	sbb    %edx,%esi
  801e14:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e18:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e1c:	e9 18 ff ff ff       	jmp    801d39 <__umoddi3+0x69>
