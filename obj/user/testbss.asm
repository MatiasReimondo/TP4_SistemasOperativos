
obj/user/testbss.debug:     formato del fichero elf32-i386


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
  80002c:	e8 ab 00 00 00       	call   8000dc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	int i;

	cprintf("Making sure bss works right...\n");
  800039:	68 e0 1d 80 00       	push   $0x801de0
  80003e:	e8 d6 01 00 00       	call   800219 <cprintf>
  800043:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < ARRAYSIZE; i++)
  800046:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
  80004b:	83 3c 85 20 40 80 00 	cmpl   $0x0,0x804020(,%eax,4)
  800052:	00 
  800053:	74 12                	je     800067 <umain+0x34>
			panic("bigarray[%d] isn't cleared!\n", i);
  800055:	50                   	push   %eax
  800056:	68 5b 1e 80 00       	push   $0x801e5b
  80005b:	6a 11                	push   $0x11
  80005d:	68 78 1e 80 00       	push   $0x801e78
  800062:	e8 d9 00 00 00       	call   800140 <_panic>
umain(int argc, char **argv)
{
	int i;

	cprintf("Making sure bss works right...\n");
	for (i = 0; i < ARRAYSIZE; i++)
  800067:	83 c0 01             	add    $0x1,%eax
  80006a:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80006f:	75 da                	jne    80004b <umain+0x18>
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
		bigarray[i] = i;
  800076:	89 04 85 20 40 80 00 	mov    %eax,0x804020(,%eax,4)

	cprintf("Making sure bss works right...\n");
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  80007d:	83 c0 01             	add    $0x1,%eax
  800080:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800085:	75 ef                	jne    800076 <umain+0x43>
  800087:	b8 00 00 00 00       	mov    $0x0,%eax
		bigarray[i] = i;
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != i)
  80008c:	3b 04 85 20 40 80 00 	cmp    0x804020(,%eax,4),%eax
  800093:	74 12                	je     8000a7 <umain+0x74>
			panic("bigarray[%d] didn't hold its value!\n", i);
  800095:	50                   	push   %eax
  800096:	68 00 1e 80 00       	push   $0x801e00
  80009b:	6a 16                	push   $0x16
  80009d:	68 78 1e 80 00       	push   $0x801e78
  8000a2:	e8 99 00 00 00       	call   800140 <_panic>
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
		bigarray[i] = i;
	for (i = 0; i < ARRAYSIZE; i++)
  8000a7:	83 c0 01             	add    $0x1,%eax
  8000aa:	3d 00 00 10 00       	cmp    $0x100000,%eax
  8000af:	75 db                	jne    80008c <umain+0x59>
		if (bigarray[i] != i)
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 28 1e 80 00       	push   $0x801e28
  8000b9:	e8 5b 01 00 00       	call   800219 <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  8000be:	c7 05 20 50 c0 00 00 	movl   $0x0,0xc05020
  8000c5:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000c8:	83 c4 0c             	add    $0xc,%esp
  8000cb:	68 87 1e 80 00       	push   $0x801e87
  8000d0:	6a 1a                	push   $0x1a
  8000d2:	68 78 1e 80 00       	push   $0x801e78
  8000d7:	e8 64 00 00 00       	call   800140 <_panic>

008000dc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
  8000e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000e4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8000e7:	e8 9d 0a 00 00       	call   800b89 <sys_getenvid>
	if (id >= 0)
  8000ec:	85 c0                	test   %eax,%eax
  8000ee:	78 12                	js     800102 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  8000f0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000f8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000fd:	a3 20 40 c0 00       	mov    %eax,0xc04020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800102:	85 db                	test   %ebx,%ebx
  800104:	7e 07                	jle    80010d <libmain+0x31>
		binaryname = argv[0];
  800106:	8b 06                	mov    (%esi),%eax
  800108:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80010d:	83 ec 08             	sub    $0x8,%esp
  800110:	56                   	push   %esi
  800111:	53                   	push   %ebx
  800112:	e8 1c ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800117:	e8 0a 00 00 00       	call   800126 <exit>
}
  80011c:	83 c4 10             	add    $0x10,%esp
  80011f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800122:	5b                   	pop    %ebx
  800123:	5e                   	pop    %esi
  800124:	5d                   	pop    %ebp
  800125:	c3                   	ret    

00800126 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800126:	55                   	push   %ebp
  800127:	89 e5                	mov    %esp,%ebp
  800129:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80012c:	e8 8b 0d 00 00       	call   800ebc <close_all>
	sys_env_destroy(0);
  800131:	83 ec 0c             	sub    $0xc,%esp
  800134:	6a 00                	push   $0x0
  800136:	e8 2c 0a 00 00       	call   800b67 <sys_env_destroy>
}
  80013b:	83 c4 10             	add    $0x10,%esp
  80013e:	c9                   	leave  
  80013f:	c3                   	ret    

00800140 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800140:	55                   	push   %ebp
  800141:	89 e5                	mov    %esp,%ebp
  800143:	56                   	push   %esi
  800144:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800145:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800148:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80014e:	e8 36 0a 00 00       	call   800b89 <sys_getenvid>
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	ff 75 0c             	pushl  0xc(%ebp)
  800159:	ff 75 08             	pushl  0x8(%ebp)
  80015c:	56                   	push   %esi
  80015d:	50                   	push   %eax
  80015e:	68 a8 1e 80 00       	push   $0x801ea8
  800163:	e8 b1 00 00 00       	call   800219 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800168:	83 c4 18             	add    $0x18,%esp
  80016b:	53                   	push   %ebx
  80016c:	ff 75 10             	pushl  0x10(%ebp)
  80016f:	e8 54 00 00 00       	call   8001c8 <vcprintf>
	cprintf("\n");
  800174:	c7 04 24 76 1e 80 00 	movl   $0x801e76,(%esp)
  80017b:	e8 99 00 00 00       	call   800219 <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800183:	cc                   	int3   
  800184:	eb fd                	jmp    800183 <_panic+0x43>

00800186 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800186:	55                   	push   %ebp
  800187:	89 e5                	mov    %esp,%ebp
  800189:	53                   	push   %ebx
  80018a:	83 ec 04             	sub    $0x4,%esp
  80018d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800190:	8b 13                	mov    (%ebx),%edx
  800192:	8d 42 01             	lea    0x1(%edx),%eax
  800195:	89 03                	mov    %eax,(%ebx)
  800197:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80019a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80019e:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001a3:	75 1a                	jne    8001bf <putch+0x39>
		sys_cputs(b->buf, b->idx);
  8001a5:	83 ec 08             	sub    $0x8,%esp
  8001a8:	68 ff 00 00 00       	push   $0xff
  8001ad:	8d 43 08             	lea    0x8(%ebx),%eax
  8001b0:	50                   	push   %eax
  8001b1:	e8 67 09 00 00       	call   800b1d <sys_cputs>
		b->idx = 0;
  8001b6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001bc:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  8001bf:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001c6:	c9                   	leave  
  8001c7:	c3                   	ret    

008001c8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001c8:	55                   	push   %ebp
  8001c9:	89 e5                	mov    %esp,%ebp
  8001cb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001d1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001d8:	00 00 00 
	b.cnt = 0;
  8001db:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001e2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001e5:	ff 75 0c             	pushl  0xc(%ebp)
  8001e8:	ff 75 08             	pushl  0x8(%ebp)
  8001eb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001f1:	50                   	push   %eax
  8001f2:	68 86 01 80 00       	push   $0x800186
  8001f7:	e8 86 01 00 00       	call   800382 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001fc:	83 c4 08             	add    $0x8,%esp
  8001ff:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800205:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80020b:	50                   	push   %eax
  80020c:	e8 0c 09 00 00       	call   800b1d <sys_cputs>

	return b.cnt;
}
  800211:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800217:	c9                   	leave  
  800218:	c3                   	ret    

00800219 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80021f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800222:	50                   	push   %eax
  800223:	ff 75 08             	pushl  0x8(%ebp)
  800226:	e8 9d ff ff ff       	call   8001c8 <vcprintf>
	va_end(ap);

	return cnt;
}
  80022b:	c9                   	leave  
  80022c:	c3                   	ret    

0080022d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80022d:	55                   	push   %ebp
  80022e:	89 e5                	mov    %esp,%ebp
  800230:	57                   	push   %edi
  800231:	56                   	push   %esi
  800232:	53                   	push   %ebx
  800233:	83 ec 1c             	sub    $0x1c,%esp
  800236:	89 c7                	mov    %eax,%edi
  800238:	89 d6                	mov    %edx,%esi
  80023a:	8b 45 08             	mov    0x8(%ebp),%eax
  80023d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800240:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800243:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800246:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800249:	bb 00 00 00 00       	mov    $0x0,%ebx
  80024e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800251:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800254:	39 d3                	cmp    %edx,%ebx
  800256:	72 05                	jb     80025d <printnum+0x30>
  800258:	39 45 10             	cmp    %eax,0x10(%ebp)
  80025b:	77 45                	ja     8002a2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80025d:	83 ec 0c             	sub    $0xc,%esp
  800260:	ff 75 18             	pushl  0x18(%ebp)
  800263:	8b 45 14             	mov    0x14(%ebp),%eax
  800266:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800269:	53                   	push   %ebx
  80026a:	ff 75 10             	pushl  0x10(%ebp)
  80026d:	83 ec 08             	sub    $0x8,%esp
  800270:	ff 75 e4             	pushl  -0x1c(%ebp)
  800273:	ff 75 e0             	pushl  -0x20(%ebp)
  800276:	ff 75 dc             	pushl  -0x24(%ebp)
  800279:	ff 75 d8             	pushl  -0x28(%ebp)
  80027c:	e8 bf 18 00 00       	call   801b40 <__udivdi3>
  800281:	83 c4 18             	add    $0x18,%esp
  800284:	52                   	push   %edx
  800285:	50                   	push   %eax
  800286:	89 f2                	mov    %esi,%edx
  800288:	89 f8                	mov    %edi,%eax
  80028a:	e8 9e ff ff ff       	call   80022d <printnum>
  80028f:	83 c4 20             	add    $0x20,%esp
  800292:	eb 18                	jmp    8002ac <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	56                   	push   %esi
  800298:	ff 75 18             	pushl  0x18(%ebp)
  80029b:	ff d7                	call   *%edi
  80029d:	83 c4 10             	add    $0x10,%esp
  8002a0:	eb 03                	jmp    8002a5 <printnum+0x78>
  8002a2:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002a5:	83 eb 01             	sub    $0x1,%ebx
  8002a8:	85 db                	test   %ebx,%ebx
  8002aa:	7f e8                	jg     800294 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002ac:	83 ec 08             	sub    $0x8,%esp
  8002af:	56                   	push   %esi
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b9:	ff 75 dc             	pushl  -0x24(%ebp)
  8002bc:	ff 75 d8             	pushl  -0x28(%ebp)
  8002bf:	e8 ac 19 00 00       	call   801c70 <__umoddi3>
  8002c4:	83 c4 14             	add    $0x14,%esp
  8002c7:	0f be 80 cb 1e 80 00 	movsbl 0x801ecb(%eax),%eax
  8002ce:	50                   	push   %eax
  8002cf:	ff d7                	call   *%edi
}
  8002d1:	83 c4 10             	add    $0x10,%esp
  8002d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d7:	5b                   	pop    %ebx
  8002d8:	5e                   	pop    %esi
  8002d9:	5f                   	pop    %edi
  8002da:	5d                   	pop    %ebp
  8002db:	c3                   	ret    

008002dc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002dc:	55                   	push   %ebp
  8002dd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002df:	83 fa 01             	cmp    $0x1,%edx
  8002e2:	7e 0e                	jle    8002f2 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002e4:	8b 10                	mov    (%eax),%edx
  8002e6:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002e9:	89 08                	mov    %ecx,(%eax)
  8002eb:	8b 02                	mov    (%edx),%eax
  8002ed:	8b 52 04             	mov    0x4(%edx),%edx
  8002f0:	eb 22                	jmp    800314 <getuint+0x38>
	else if (lflag)
  8002f2:	85 d2                	test   %edx,%edx
  8002f4:	74 10                	je     800306 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002f6:	8b 10                	mov    (%eax),%edx
  8002f8:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002fb:	89 08                	mov    %ecx,(%eax)
  8002fd:	8b 02                	mov    (%edx),%eax
  8002ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800304:	eb 0e                	jmp    800314 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800306:	8b 10                	mov    (%eax),%edx
  800308:	8d 4a 04             	lea    0x4(%edx),%ecx
  80030b:	89 08                	mov    %ecx,(%eax)
  80030d:	8b 02                	mov    (%edx),%eax
  80030f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800314:	5d                   	pop    %ebp
  800315:	c3                   	ret    

00800316 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800316:	55                   	push   %ebp
  800317:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800319:	83 fa 01             	cmp    $0x1,%edx
  80031c:	7e 0e                	jle    80032c <getint+0x16>
		return va_arg(*ap, long long);
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8d 4a 08             	lea    0x8(%edx),%ecx
  800323:	89 08                	mov    %ecx,(%eax)
  800325:	8b 02                	mov    (%edx),%eax
  800327:	8b 52 04             	mov    0x4(%edx),%edx
  80032a:	eb 1a                	jmp    800346 <getint+0x30>
	else if (lflag)
  80032c:	85 d2                	test   %edx,%edx
  80032e:	74 0c                	je     80033c <getint+0x26>
		return va_arg(*ap, long);
  800330:	8b 10                	mov    (%eax),%edx
  800332:	8d 4a 04             	lea    0x4(%edx),%ecx
  800335:	89 08                	mov    %ecx,(%eax)
  800337:	8b 02                	mov    (%edx),%eax
  800339:	99                   	cltd   
  80033a:	eb 0a                	jmp    800346 <getint+0x30>
	else
		return va_arg(*ap, int);
  80033c:	8b 10                	mov    (%eax),%edx
  80033e:	8d 4a 04             	lea    0x4(%edx),%ecx
  800341:	89 08                	mov    %ecx,(%eax)
  800343:	8b 02                	mov    (%edx),%eax
  800345:	99                   	cltd   
}
  800346:	5d                   	pop    %ebp
  800347:	c3                   	ret    

00800348 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800348:	55                   	push   %ebp
  800349:	89 e5                	mov    %esp,%ebp
  80034b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80034e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800352:	8b 10                	mov    (%eax),%edx
  800354:	3b 50 04             	cmp    0x4(%eax),%edx
  800357:	73 0a                	jae    800363 <sprintputch+0x1b>
		*b->buf++ = ch;
  800359:	8d 4a 01             	lea    0x1(%edx),%ecx
  80035c:	89 08                	mov    %ecx,(%eax)
  80035e:	8b 45 08             	mov    0x8(%ebp),%eax
  800361:	88 02                	mov    %al,(%edx)
}
  800363:	5d                   	pop    %ebp
  800364:	c3                   	ret    

00800365 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800365:	55                   	push   %ebp
  800366:	89 e5                	mov    %esp,%ebp
  800368:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  80036b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80036e:	50                   	push   %eax
  80036f:	ff 75 10             	pushl  0x10(%ebp)
  800372:	ff 75 0c             	pushl  0xc(%ebp)
  800375:	ff 75 08             	pushl  0x8(%ebp)
  800378:	e8 05 00 00 00       	call   800382 <vprintfmt>
	va_end(ap);
}
  80037d:	83 c4 10             	add    $0x10,%esp
  800380:	c9                   	leave  
  800381:	c3                   	ret    

00800382 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	57                   	push   %edi
  800386:	56                   	push   %esi
  800387:	53                   	push   %ebx
  800388:	83 ec 2c             	sub    $0x2c,%esp
  80038b:	8b 75 08             	mov    0x8(%ebp),%esi
  80038e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800391:	8b 7d 10             	mov    0x10(%ebp),%edi
  800394:	eb 12                	jmp    8003a8 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800396:	85 c0                	test   %eax,%eax
  800398:	0f 84 44 03 00 00    	je     8006e2 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  80039e:	83 ec 08             	sub    $0x8,%esp
  8003a1:	53                   	push   %ebx
  8003a2:	50                   	push   %eax
  8003a3:	ff d6                	call   *%esi
  8003a5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003a8:	83 c7 01             	add    $0x1,%edi
  8003ab:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8003af:	83 f8 25             	cmp    $0x25,%eax
  8003b2:	75 e2                	jne    800396 <vprintfmt+0x14>
  8003b4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8003b8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8003bf:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003c6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8003cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d2:	eb 07                	jmp    8003db <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003d7:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003db:	8d 47 01             	lea    0x1(%edi),%eax
  8003de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003e1:	0f b6 07             	movzbl (%edi),%eax
  8003e4:	0f b6 c8             	movzbl %al,%ecx
  8003e7:	83 e8 23             	sub    $0x23,%eax
  8003ea:	3c 55                	cmp    $0x55,%al
  8003ec:	0f 87 d5 02 00 00    	ja     8006c7 <vprintfmt+0x345>
  8003f2:	0f b6 c0             	movzbl %al,%eax
  8003f5:	ff 24 85 00 20 80 00 	jmp    *0x802000(,%eax,4)
  8003fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003ff:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800403:	eb d6                	jmp    8003db <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800405:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800408:	b8 00 00 00 00       	mov    $0x0,%eax
  80040d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800410:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800413:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  800417:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  80041a:	8d 51 d0             	lea    -0x30(%ecx),%edx
  80041d:	83 fa 09             	cmp    $0x9,%edx
  800420:	77 39                	ja     80045b <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800422:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800425:	eb e9                	jmp    800410 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800427:	8b 45 14             	mov    0x14(%ebp),%eax
  80042a:	8d 48 04             	lea    0x4(%eax),%ecx
  80042d:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800430:	8b 00                	mov    (%eax),%eax
  800432:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800435:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800438:	eb 27                	jmp    800461 <vprintfmt+0xdf>
  80043a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043d:	85 c0                	test   %eax,%eax
  80043f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800444:	0f 49 c8             	cmovns %eax,%ecx
  800447:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80044a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80044d:	eb 8c                	jmp    8003db <vprintfmt+0x59>
  80044f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800452:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800459:	eb 80                	jmp    8003db <vprintfmt+0x59>
  80045b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80045e:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  800461:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800465:	0f 89 70 ff ff ff    	jns    8003db <vprintfmt+0x59>
				width = precision, precision = -1;
  80046b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80046e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800471:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800478:	e9 5e ff ff ff       	jmp    8003db <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80047d:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800480:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800483:	e9 53 ff ff ff       	jmp    8003db <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800488:	8b 45 14             	mov    0x14(%ebp),%eax
  80048b:	8d 50 04             	lea    0x4(%eax),%edx
  80048e:	89 55 14             	mov    %edx,0x14(%ebp)
  800491:	83 ec 08             	sub    $0x8,%esp
  800494:	53                   	push   %ebx
  800495:	ff 30                	pushl  (%eax)
  800497:	ff d6                	call   *%esi
			break;
  800499:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  80049f:	e9 04 ff ff ff       	jmp    8003a8 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a7:	8d 50 04             	lea    0x4(%eax),%edx
  8004aa:	89 55 14             	mov    %edx,0x14(%ebp)
  8004ad:	8b 00                	mov    (%eax),%eax
  8004af:	99                   	cltd   
  8004b0:	31 d0                	xor    %edx,%eax
  8004b2:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004b4:	83 f8 0f             	cmp    $0xf,%eax
  8004b7:	7f 0b                	jg     8004c4 <vprintfmt+0x142>
  8004b9:	8b 14 85 60 21 80 00 	mov    0x802160(,%eax,4),%edx
  8004c0:	85 d2                	test   %edx,%edx
  8004c2:	75 18                	jne    8004dc <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  8004c4:	50                   	push   %eax
  8004c5:	68 e3 1e 80 00       	push   $0x801ee3
  8004ca:	53                   	push   %ebx
  8004cb:	56                   	push   %esi
  8004cc:	e8 94 fe ff ff       	call   800365 <printfmt>
  8004d1:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8004d7:	e9 cc fe ff ff       	jmp    8003a8 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  8004dc:	52                   	push   %edx
  8004dd:	68 95 22 80 00       	push   $0x802295
  8004e2:	53                   	push   %ebx
  8004e3:	56                   	push   %esi
  8004e4:	e8 7c fe ff ff       	call   800365 <printfmt>
  8004e9:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ef:	e9 b4 fe ff ff       	jmp    8003a8 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f7:	8d 50 04             	lea    0x4(%eax),%edx
  8004fa:	89 55 14             	mov    %edx,0x14(%ebp)
  8004fd:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004ff:	85 ff                	test   %edi,%edi
  800501:	b8 dc 1e 80 00       	mov    $0x801edc,%eax
  800506:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800509:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80050d:	0f 8e 94 00 00 00    	jle    8005a7 <vprintfmt+0x225>
  800513:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800517:	0f 84 98 00 00 00    	je     8005b5 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  80051d:	83 ec 08             	sub    $0x8,%esp
  800520:	ff 75 d0             	pushl  -0x30(%ebp)
  800523:	57                   	push   %edi
  800524:	e8 41 02 00 00       	call   80076a <strnlen>
  800529:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80052c:	29 c1                	sub    %eax,%ecx
  80052e:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800531:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800534:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800538:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80053b:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80053e:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800540:	eb 0f                	jmp    800551 <vprintfmt+0x1cf>
					putch(padc, putdat);
  800542:	83 ec 08             	sub    $0x8,%esp
  800545:	53                   	push   %ebx
  800546:	ff 75 e0             	pushl  -0x20(%ebp)
  800549:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80054b:	83 ef 01             	sub    $0x1,%edi
  80054e:	83 c4 10             	add    $0x10,%esp
  800551:	85 ff                	test   %edi,%edi
  800553:	7f ed                	jg     800542 <vprintfmt+0x1c0>
  800555:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800558:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  80055b:	85 c9                	test   %ecx,%ecx
  80055d:	b8 00 00 00 00       	mov    $0x0,%eax
  800562:	0f 49 c1             	cmovns %ecx,%eax
  800565:	29 c1                	sub    %eax,%ecx
  800567:	89 75 08             	mov    %esi,0x8(%ebp)
  80056a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80056d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800570:	89 cb                	mov    %ecx,%ebx
  800572:	eb 4d                	jmp    8005c1 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800574:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800578:	74 1b                	je     800595 <vprintfmt+0x213>
  80057a:	0f be c0             	movsbl %al,%eax
  80057d:	83 e8 20             	sub    $0x20,%eax
  800580:	83 f8 5e             	cmp    $0x5e,%eax
  800583:	76 10                	jbe    800595 <vprintfmt+0x213>
					putch('?', putdat);
  800585:	83 ec 08             	sub    $0x8,%esp
  800588:	ff 75 0c             	pushl  0xc(%ebp)
  80058b:	6a 3f                	push   $0x3f
  80058d:	ff 55 08             	call   *0x8(%ebp)
  800590:	83 c4 10             	add    $0x10,%esp
  800593:	eb 0d                	jmp    8005a2 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  800595:	83 ec 08             	sub    $0x8,%esp
  800598:	ff 75 0c             	pushl  0xc(%ebp)
  80059b:	52                   	push   %edx
  80059c:	ff 55 08             	call   *0x8(%ebp)
  80059f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005a2:	83 eb 01             	sub    $0x1,%ebx
  8005a5:	eb 1a                	jmp    8005c1 <vprintfmt+0x23f>
  8005a7:	89 75 08             	mov    %esi,0x8(%ebp)
  8005aa:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005ad:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005b0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005b3:	eb 0c                	jmp    8005c1 <vprintfmt+0x23f>
  8005b5:	89 75 08             	mov    %esi,0x8(%ebp)
  8005b8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005bb:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005be:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005c1:	83 c7 01             	add    $0x1,%edi
  8005c4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005c8:	0f be d0             	movsbl %al,%edx
  8005cb:	85 d2                	test   %edx,%edx
  8005cd:	74 23                	je     8005f2 <vprintfmt+0x270>
  8005cf:	85 f6                	test   %esi,%esi
  8005d1:	78 a1                	js     800574 <vprintfmt+0x1f2>
  8005d3:	83 ee 01             	sub    $0x1,%esi
  8005d6:	79 9c                	jns    800574 <vprintfmt+0x1f2>
  8005d8:	89 df                	mov    %ebx,%edi
  8005da:	8b 75 08             	mov    0x8(%ebp),%esi
  8005dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005e0:	eb 18                	jmp    8005fa <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005e2:	83 ec 08             	sub    $0x8,%esp
  8005e5:	53                   	push   %ebx
  8005e6:	6a 20                	push   $0x20
  8005e8:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005ea:	83 ef 01             	sub    $0x1,%edi
  8005ed:	83 c4 10             	add    $0x10,%esp
  8005f0:	eb 08                	jmp    8005fa <vprintfmt+0x278>
  8005f2:	89 df                	mov    %ebx,%edi
  8005f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8005f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005fa:	85 ff                	test   %edi,%edi
  8005fc:	7f e4                	jg     8005e2 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800601:	e9 a2 fd ff ff       	jmp    8003a8 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800606:	8d 45 14             	lea    0x14(%ebp),%eax
  800609:	e8 08 fd ff ff       	call   800316 <getint>
  80060e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800611:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800614:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800619:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80061d:	79 74                	jns    800693 <vprintfmt+0x311>
				putch('-', putdat);
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	53                   	push   %ebx
  800623:	6a 2d                	push   $0x2d
  800625:	ff d6                	call   *%esi
				num = -(long long) num;
  800627:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80062a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80062d:	f7 d8                	neg    %eax
  80062f:	83 d2 00             	adc    $0x0,%edx
  800632:	f7 da                	neg    %edx
  800634:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  800637:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80063c:	eb 55                	jmp    800693 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80063e:	8d 45 14             	lea    0x14(%ebp),%eax
  800641:	e8 96 fc ff ff       	call   8002dc <getuint>
			base = 10;
  800646:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80064b:	eb 46                	jmp    800693 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  80064d:	8d 45 14             	lea    0x14(%ebp),%eax
  800650:	e8 87 fc ff ff       	call   8002dc <getuint>
			base = 8;
  800655:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80065a:	eb 37                	jmp    800693 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  80065c:	83 ec 08             	sub    $0x8,%esp
  80065f:	53                   	push   %ebx
  800660:	6a 30                	push   $0x30
  800662:	ff d6                	call   *%esi
			putch('x', putdat);
  800664:	83 c4 08             	add    $0x8,%esp
  800667:	53                   	push   %ebx
  800668:	6a 78                	push   $0x78
  80066a:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8d 50 04             	lea    0x4(%eax),%edx
  800672:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800675:	8b 00                	mov    (%eax),%eax
  800677:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  80067c:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80067f:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800684:	eb 0d                	jmp    800693 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800686:	8d 45 14             	lea    0x14(%ebp),%eax
  800689:	e8 4e fc ff ff       	call   8002dc <getuint>
			base = 16;
  80068e:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800693:	83 ec 0c             	sub    $0xc,%esp
  800696:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80069a:	57                   	push   %edi
  80069b:	ff 75 e0             	pushl  -0x20(%ebp)
  80069e:	51                   	push   %ecx
  80069f:	52                   	push   %edx
  8006a0:	50                   	push   %eax
  8006a1:	89 da                	mov    %ebx,%edx
  8006a3:	89 f0                	mov    %esi,%eax
  8006a5:	e8 83 fb ff ff       	call   80022d <printnum>
			break;
  8006aa:	83 c4 20             	add    $0x20,%esp
  8006ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006b0:	e9 f3 fc ff ff       	jmp    8003a8 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006b5:	83 ec 08             	sub    $0x8,%esp
  8006b8:	53                   	push   %ebx
  8006b9:	51                   	push   %ecx
  8006ba:	ff d6                	call   *%esi
			break;
  8006bc:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8006c2:	e9 e1 fc ff ff       	jmp    8003a8 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006c7:	83 ec 08             	sub    $0x8,%esp
  8006ca:	53                   	push   %ebx
  8006cb:	6a 25                	push   $0x25
  8006cd:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006cf:	83 c4 10             	add    $0x10,%esp
  8006d2:	eb 03                	jmp    8006d7 <vprintfmt+0x355>
  8006d4:	83 ef 01             	sub    $0x1,%edi
  8006d7:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  8006db:	75 f7                	jne    8006d4 <vprintfmt+0x352>
  8006dd:	e9 c6 fc ff ff       	jmp    8003a8 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  8006e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006e5:	5b                   	pop    %ebx
  8006e6:	5e                   	pop    %esi
  8006e7:	5f                   	pop    %edi
  8006e8:	5d                   	pop    %ebp
  8006e9:	c3                   	ret    

008006ea <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006ea:	55                   	push   %ebp
  8006eb:	89 e5                	mov    %esp,%ebp
  8006ed:	83 ec 18             	sub    $0x18,%esp
  8006f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006f9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006fd:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800700:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800707:	85 c0                	test   %eax,%eax
  800709:	74 26                	je     800731 <vsnprintf+0x47>
  80070b:	85 d2                	test   %edx,%edx
  80070d:	7e 22                	jle    800731 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80070f:	ff 75 14             	pushl  0x14(%ebp)
  800712:	ff 75 10             	pushl  0x10(%ebp)
  800715:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800718:	50                   	push   %eax
  800719:	68 48 03 80 00       	push   $0x800348
  80071e:	e8 5f fc ff ff       	call   800382 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800723:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800726:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80072c:	83 c4 10             	add    $0x10,%esp
  80072f:	eb 05                	jmp    800736 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800731:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800736:	c9                   	leave  
  800737:	c3                   	ret    

00800738 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800738:	55                   	push   %ebp
  800739:	89 e5                	mov    %esp,%ebp
  80073b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80073e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800741:	50                   	push   %eax
  800742:	ff 75 10             	pushl  0x10(%ebp)
  800745:	ff 75 0c             	pushl  0xc(%ebp)
  800748:	ff 75 08             	pushl  0x8(%ebp)
  80074b:	e8 9a ff ff ff       	call   8006ea <vsnprintf>
	va_end(ap);

	return rc;
}
  800750:	c9                   	leave  
  800751:	c3                   	ret    

00800752 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800752:	55                   	push   %ebp
  800753:	89 e5                	mov    %esp,%ebp
  800755:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800758:	b8 00 00 00 00       	mov    $0x0,%eax
  80075d:	eb 03                	jmp    800762 <strlen+0x10>
		n++;
  80075f:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800762:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800766:	75 f7                	jne    80075f <strlen+0xd>
		n++;
	return n;
}
  800768:	5d                   	pop    %ebp
  800769:	c3                   	ret    

0080076a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800770:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800773:	ba 00 00 00 00       	mov    $0x0,%edx
  800778:	eb 03                	jmp    80077d <strnlen+0x13>
		n++;
  80077a:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80077d:	39 c2                	cmp    %eax,%edx
  80077f:	74 08                	je     800789 <strnlen+0x1f>
  800781:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800785:	75 f3                	jne    80077a <strnlen+0x10>
  800787:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  800789:	5d                   	pop    %ebp
  80078a:	c3                   	ret    

0080078b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80078b:	55                   	push   %ebp
  80078c:	89 e5                	mov    %esp,%ebp
  80078e:	53                   	push   %ebx
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800795:	89 c2                	mov    %eax,%edx
  800797:	83 c2 01             	add    $0x1,%edx
  80079a:	83 c1 01             	add    $0x1,%ecx
  80079d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007a1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007a4:	84 db                	test   %bl,%bl
  8007a6:	75 ef                	jne    800797 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007a8:	5b                   	pop    %ebx
  8007a9:	5d                   	pop    %ebp
  8007aa:	c3                   	ret    

008007ab <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	53                   	push   %ebx
  8007af:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007b2:	53                   	push   %ebx
  8007b3:	e8 9a ff ff ff       	call   800752 <strlen>
  8007b8:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007bb:	ff 75 0c             	pushl  0xc(%ebp)
  8007be:	01 d8                	add    %ebx,%eax
  8007c0:	50                   	push   %eax
  8007c1:	e8 c5 ff ff ff       	call   80078b <strcpy>
	return dst;
}
  8007c6:	89 d8                	mov    %ebx,%eax
  8007c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007cb:	c9                   	leave  
  8007cc:	c3                   	ret    

008007cd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007cd:	55                   	push   %ebp
  8007ce:	89 e5                	mov    %esp,%ebp
  8007d0:	56                   	push   %esi
  8007d1:	53                   	push   %ebx
  8007d2:	8b 75 08             	mov    0x8(%ebp),%esi
  8007d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007d8:	89 f3                	mov    %esi,%ebx
  8007da:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007dd:	89 f2                	mov    %esi,%edx
  8007df:	eb 0f                	jmp    8007f0 <strncpy+0x23>
		*dst++ = *src;
  8007e1:	83 c2 01             	add    $0x1,%edx
  8007e4:	0f b6 01             	movzbl (%ecx),%eax
  8007e7:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007ea:	80 39 01             	cmpb   $0x1,(%ecx)
  8007ed:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007f0:	39 da                	cmp    %ebx,%edx
  8007f2:	75 ed                	jne    8007e1 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8007f4:	89 f0                	mov    %esi,%eax
  8007f6:	5b                   	pop    %ebx
  8007f7:	5e                   	pop    %esi
  8007f8:	5d                   	pop    %ebp
  8007f9:	c3                   	ret    

008007fa <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	56                   	push   %esi
  8007fe:	53                   	push   %ebx
  8007ff:	8b 75 08             	mov    0x8(%ebp),%esi
  800802:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800805:	8b 55 10             	mov    0x10(%ebp),%edx
  800808:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80080a:	85 d2                	test   %edx,%edx
  80080c:	74 21                	je     80082f <strlcpy+0x35>
  80080e:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800812:	89 f2                	mov    %esi,%edx
  800814:	eb 09                	jmp    80081f <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800816:	83 c2 01             	add    $0x1,%edx
  800819:	83 c1 01             	add    $0x1,%ecx
  80081c:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80081f:	39 c2                	cmp    %eax,%edx
  800821:	74 09                	je     80082c <strlcpy+0x32>
  800823:	0f b6 19             	movzbl (%ecx),%ebx
  800826:	84 db                	test   %bl,%bl
  800828:	75 ec                	jne    800816 <strlcpy+0x1c>
  80082a:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  80082c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80082f:	29 f0                	sub    %esi,%eax
}
  800831:	5b                   	pop    %ebx
  800832:	5e                   	pop    %esi
  800833:	5d                   	pop    %ebp
  800834:	c3                   	ret    

00800835 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800835:	55                   	push   %ebp
  800836:	89 e5                	mov    %esp,%ebp
  800838:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80083b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80083e:	eb 06                	jmp    800846 <strcmp+0x11>
		p++, q++;
  800840:	83 c1 01             	add    $0x1,%ecx
  800843:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800846:	0f b6 01             	movzbl (%ecx),%eax
  800849:	84 c0                	test   %al,%al
  80084b:	74 04                	je     800851 <strcmp+0x1c>
  80084d:	3a 02                	cmp    (%edx),%al
  80084f:	74 ef                	je     800840 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800851:	0f b6 c0             	movzbl %al,%eax
  800854:	0f b6 12             	movzbl (%edx),%edx
  800857:	29 d0                	sub    %edx,%eax
}
  800859:	5d                   	pop    %ebp
  80085a:	c3                   	ret    

0080085b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	53                   	push   %ebx
  80085f:	8b 45 08             	mov    0x8(%ebp),%eax
  800862:	8b 55 0c             	mov    0xc(%ebp),%edx
  800865:	89 c3                	mov    %eax,%ebx
  800867:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80086a:	eb 06                	jmp    800872 <strncmp+0x17>
		n--, p++, q++;
  80086c:	83 c0 01             	add    $0x1,%eax
  80086f:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800872:	39 d8                	cmp    %ebx,%eax
  800874:	74 15                	je     80088b <strncmp+0x30>
  800876:	0f b6 08             	movzbl (%eax),%ecx
  800879:	84 c9                	test   %cl,%cl
  80087b:	74 04                	je     800881 <strncmp+0x26>
  80087d:	3a 0a                	cmp    (%edx),%cl
  80087f:	74 eb                	je     80086c <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800881:	0f b6 00             	movzbl (%eax),%eax
  800884:	0f b6 12             	movzbl (%edx),%edx
  800887:	29 d0                	sub    %edx,%eax
  800889:	eb 05                	jmp    800890 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  80088b:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800890:	5b                   	pop    %ebx
  800891:	5d                   	pop    %ebp
  800892:	c3                   	ret    

00800893 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800893:	55                   	push   %ebp
  800894:	89 e5                	mov    %esp,%ebp
  800896:	8b 45 08             	mov    0x8(%ebp),%eax
  800899:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80089d:	eb 07                	jmp    8008a6 <strchr+0x13>
		if (*s == c)
  80089f:	38 ca                	cmp    %cl,%dl
  8008a1:	74 0f                	je     8008b2 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008a3:	83 c0 01             	add    $0x1,%eax
  8008a6:	0f b6 10             	movzbl (%eax),%edx
  8008a9:	84 d2                	test   %dl,%dl
  8008ab:	75 f2                	jne    80089f <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8008ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008b2:	5d                   	pop    %ebp
  8008b3:	c3                   	ret    

008008b4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008b4:	55                   	push   %ebp
  8008b5:	89 e5                	mov    %esp,%ebp
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008be:	eb 03                	jmp    8008c3 <strfind+0xf>
  8008c0:	83 c0 01             	add    $0x1,%eax
  8008c3:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008c6:	38 ca                	cmp    %cl,%dl
  8008c8:	74 04                	je     8008ce <strfind+0x1a>
  8008ca:	84 d2                	test   %dl,%dl
  8008cc:	75 f2                	jne    8008c0 <strfind+0xc>
			break;
	return (char *) s;
}
  8008ce:	5d                   	pop    %ebp
  8008cf:	c3                   	ret    

008008d0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	57                   	push   %edi
  8008d4:	56                   	push   %esi
  8008d5:	53                   	push   %ebx
  8008d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8008d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  8008dc:	85 c9                	test   %ecx,%ecx
  8008de:	74 37                	je     800917 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008e0:	f6 c2 03             	test   $0x3,%dl
  8008e3:	75 2a                	jne    80090f <memset+0x3f>
  8008e5:	f6 c1 03             	test   $0x3,%cl
  8008e8:	75 25                	jne    80090f <memset+0x3f>
		c &= 0xFF;
  8008ea:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008ee:	89 df                	mov    %ebx,%edi
  8008f0:	c1 e7 08             	shl    $0x8,%edi
  8008f3:	89 de                	mov    %ebx,%esi
  8008f5:	c1 e6 18             	shl    $0x18,%esi
  8008f8:	89 d8                	mov    %ebx,%eax
  8008fa:	c1 e0 10             	shl    $0x10,%eax
  8008fd:	09 f0                	or     %esi,%eax
  8008ff:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800901:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800904:	89 f8                	mov    %edi,%eax
  800906:	09 d8                	or     %ebx,%eax
  800908:	89 d7                	mov    %edx,%edi
  80090a:	fc                   	cld    
  80090b:	f3 ab                	rep stos %eax,%es:(%edi)
  80090d:	eb 08                	jmp    800917 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80090f:	89 d7                	mov    %edx,%edi
  800911:	8b 45 0c             	mov    0xc(%ebp),%eax
  800914:	fc                   	cld    
  800915:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800917:	89 d0                	mov    %edx,%eax
  800919:	5b                   	pop    %ebx
  80091a:	5e                   	pop    %esi
  80091b:	5f                   	pop    %edi
  80091c:	5d                   	pop    %ebp
  80091d:	c3                   	ret    

0080091e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	57                   	push   %edi
  800922:	56                   	push   %esi
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	8b 75 0c             	mov    0xc(%ebp),%esi
  800929:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80092c:	39 c6                	cmp    %eax,%esi
  80092e:	73 35                	jae    800965 <memmove+0x47>
  800930:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800933:	39 d0                	cmp    %edx,%eax
  800935:	73 2e                	jae    800965 <memmove+0x47>
		s += n;
		d += n;
  800937:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80093a:	89 d6                	mov    %edx,%esi
  80093c:	09 fe                	or     %edi,%esi
  80093e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800944:	75 13                	jne    800959 <memmove+0x3b>
  800946:	f6 c1 03             	test   $0x3,%cl
  800949:	75 0e                	jne    800959 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  80094b:	83 ef 04             	sub    $0x4,%edi
  80094e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800951:	c1 e9 02             	shr    $0x2,%ecx
  800954:	fd                   	std    
  800955:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800957:	eb 09                	jmp    800962 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800959:	83 ef 01             	sub    $0x1,%edi
  80095c:	8d 72 ff             	lea    -0x1(%edx),%esi
  80095f:	fd                   	std    
  800960:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800962:	fc                   	cld    
  800963:	eb 1d                	jmp    800982 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800965:	89 f2                	mov    %esi,%edx
  800967:	09 c2                	or     %eax,%edx
  800969:	f6 c2 03             	test   $0x3,%dl
  80096c:	75 0f                	jne    80097d <memmove+0x5f>
  80096e:	f6 c1 03             	test   $0x3,%cl
  800971:	75 0a                	jne    80097d <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  800973:	c1 e9 02             	shr    $0x2,%ecx
  800976:	89 c7                	mov    %eax,%edi
  800978:	fc                   	cld    
  800979:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80097b:	eb 05                	jmp    800982 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80097d:	89 c7                	mov    %eax,%edi
  80097f:	fc                   	cld    
  800980:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800982:	5e                   	pop    %esi
  800983:	5f                   	pop    %edi
  800984:	5d                   	pop    %ebp
  800985:	c3                   	ret    

00800986 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800986:	55                   	push   %ebp
  800987:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800989:	ff 75 10             	pushl  0x10(%ebp)
  80098c:	ff 75 0c             	pushl  0xc(%ebp)
  80098f:	ff 75 08             	pushl  0x8(%ebp)
  800992:	e8 87 ff ff ff       	call   80091e <memmove>
}
  800997:	c9                   	leave  
  800998:	c3                   	ret    

00800999 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	56                   	push   %esi
  80099d:	53                   	push   %ebx
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a4:	89 c6                	mov    %eax,%esi
  8009a6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009a9:	eb 1a                	jmp    8009c5 <memcmp+0x2c>
		if (*s1 != *s2)
  8009ab:	0f b6 08             	movzbl (%eax),%ecx
  8009ae:	0f b6 1a             	movzbl (%edx),%ebx
  8009b1:	38 d9                	cmp    %bl,%cl
  8009b3:	74 0a                	je     8009bf <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8009b5:	0f b6 c1             	movzbl %cl,%eax
  8009b8:	0f b6 db             	movzbl %bl,%ebx
  8009bb:	29 d8                	sub    %ebx,%eax
  8009bd:	eb 0f                	jmp    8009ce <memcmp+0x35>
		s1++, s2++;
  8009bf:	83 c0 01             	add    $0x1,%eax
  8009c2:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009c5:	39 f0                	cmp    %esi,%eax
  8009c7:	75 e2                	jne    8009ab <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8009c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ce:	5b                   	pop    %ebx
  8009cf:	5e                   	pop    %esi
  8009d0:	5d                   	pop    %ebp
  8009d1:	c3                   	ret    

008009d2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	53                   	push   %ebx
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  8009d9:	89 c1                	mov    %eax,%ecx
  8009db:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  8009de:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8009e2:	eb 0a                	jmp    8009ee <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009e4:	0f b6 10             	movzbl (%eax),%edx
  8009e7:	39 da                	cmp    %ebx,%edx
  8009e9:	74 07                	je     8009f2 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8009eb:	83 c0 01             	add    $0x1,%eax
  8009ee:	39 c8                	cmp    %ecx,%eax
  8009f0:	72 f2                	jb     8009e4 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8009f2:	5b                   	pop    %ebx
  8009f3:	5d                   	pop    %ebp
  8009f4:	c3                   	ret    

008009f5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	57                   	push   %edi
  8009f9:	56                   	push   %esi
  8009fa:	53                   	push   %ebx
  8009fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a01:	eb 03                	jmp    800a06 <strtol+0x11>
		s++;
  800a03:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a06:	0f b6 01             	movzbl (%ecx),%eax
  800a09:	3c 20                	cmp    $0x20,%al
  800a0b:	74 f6                	je     800a03 <strtol+0xe>
  800a0d:	3c 09                	cmp    $0x9,%al
  800a0f:	74 f2                	je     800a03 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a11:	3c 2b                	cmp    $0x2b,%al
  800a13:	75 0a                	jne    800a1f <strtol+0x2a>
		s++;
  800a15:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a18:	bf 00 00 00 00       	mov    $0x0,%edi
  800a1d:	eb 11                	jmp    800a30 <strtol+0x3b>
  800a1f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800a24:	3c 2d                	cmp    $0x2d,%al
  800a26:	75 08                	jne    800a30 <strtol+0x3b>
		s++, neg = 1;
  800a28:	83 c1 01             	add    $0x1,%ecx
  800a2b:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a30:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a36:	75 15                	jne    800a4d <strtol+0x58>
  800a38:	80 39 30             	cmpb   $0x30,(%ecx)
  800a3b:	75 10                	jne    800a4d <strtol+0x58>
  800a3d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a41:	75 7c                	jne    800abf <strtol+0xca>
		s += 2, base = 16;
  800a43:	83 c1 02             	add    $0x2,%ecx
  800a46:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a4b:	eb 16                	jmp    800a63 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800a4d:	85 db                	test   %ebx,%ebx
  800a4f:	75 12                	jne    800a63 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a51:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a56:	80 39 30             	cmpb   $0x30,(%ecx)
  800a59:	75 08                	jne    800a63 <strtol+0x6e>
		s++, base = 8;
  800a5b:	83 c1 01             	add    $0x1,%ecx
  800a5e:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800a63:	b8 00 00 00 00       	mov    $0x0,%eax
  800a68:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800a6b:	0f b6 11             	movzbl (%ecx),%edx
  800a6e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a71:	89 f3                	mov    %esi,%ebx
  800a73:	80 fb 09             	cmp    $0x9,%bl
  800a76:	77 08                	ja     800a80 <strtol+0x8b>
			dig = *s - '0';
  800a78:	0f be d2             	movsbl %dl,%edx
  800a7b:	83 ea 30             	sub    $0x30,%edx
  800a7e:	eb 22                	jmp    800aa2 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800a80:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a83:	89 f3                	mov    %esi,%ebx
  800a85:	80 fb 19             	cmp    $0x19,%bl
  800a88:	77 08                	ja     800a92 <strtol+0x9d>
			dig = *s - 'a' + 10;
  800a8a:	0f be d2             	movsbl %dl,%edx
  800a8d:	83 ea 57             	sub    $0x57,%edx
  800a90:	eb 10                	jmp    800aa2 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800a92:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a95:	89 f3                	mov    %esi,%ebx
  800a97:	80 fb 19             	cmp    $0x19,%bl
  800a9a:	77 16                	ja     800ab2 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800a9c:	0f be d2             	movsbl %dl,%edx
  800a9f:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800aa2:	3b 55 10             	cmp    0x10(%ebp),%edx
  800aa5:	7d 0b                	jge    800ab2 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800aa7:	83 c1 01             	add    $0x1,%ecx
  800aaa:	0f af 45 10          	imul   0x10(%ebp),%eax
  800aae:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800ab0:	eb b9                	jmp    800a6b <strtol+0x76>

	if (endptr)
  800ab2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ab6:	74 0d                	je     800ac5 <strtol+0xd0>
		*endptr = (char *) s;
  800ab8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800abb:	89 0e                	mov    %ecx,(%esi)
  800abd:	eb 06                	jmp    800ac5 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800abf:	85 db                	test   %ebx,%ebx
  800ac1:	74 98                	je     800a5b <strtol+0x66>
  800ac3:	eb 9e                	jmp    800a63 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800ac5:	89 c2                	mov    %eax,%edx
  800ac7:	f7 da                	neg    %edx
  800ac9:	85 ff                	test   %edi,%edi
  800acb:	0f 45 c2             	cmovne %edx,%eax
}
  800ace:	5b                   	pop    %ebx
  800acf:	5e                   	pop    %esi
  800ad0:	5f                   	pop    %edi
  800ad1:	5d                   	pop    %ebp
  800ad2:	c3                   	ret    

00800ad3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	57                   	push   %edi
  800ad7:	56                   	push   %esi
  800ad8:	53                   	push   %ebx
  800ad9:	83 ec 1c             	sub    $0x1c,%esp
  800adc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800adf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800ae2:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ae4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800aea:	8b 7d 10             	mov    0x10(%ebp),%edi
  800aed:	8b 75 14             	mov    0x14(%ebp),%esi
  800af0:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800af2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af6:	74 1d                	je     800b15 <syscall+0x42>
  800af8:	85 c0                	test   %eax,%eax
  800afa:	7e 19                	jle    800b15 <syscall+0x42>
  800afc:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800aff:	83 ec 0c             	sub    $0xc,%esp
  800b02:	50                   	push   %eax
  800b03:	52                   	push   %edx
  800b04:	68 bf 21 80 00       	push   $0x8021bf
  800b09:	6a 23                	push   $0x23
  800b0b:	68 dc 21 80 00       	push   $0x8021dc
  800b10:	e8 2b f6 ff ff       	call   800140 <_panic>

	return ret;
}
  800b15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b18:	5b                   	pop    %ebx
  800b19:	5e                   	pop    %esi
  800b1a:	5f                   	pop    %edi
  800b1b:	5d                   	pop    %ebp
  800b1c:	c3                   	ret    

00800b1d <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800b23:	6a 00                	push   $0x0
  800b25:	6a 00                	push   $0x0
  800b27:	6a 00                	push   $0x0
  800b29:	ff 75 0c             	pushl  0xc(%ebp)
  800b2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b34:	b8 00 00 00 00       	mov    $0x0,%eax
  800b39:	e8 95 ff ff ff       	call   800ad3 <syscall>
}
  800b3e:	83 c4 10             	add    $0x10,%esp
  800b41:	c9                   	leave  
  800b42:	c3                   	ret    

00800b43 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800b49:	6a 00                	push   $0x0
  800b4b:	6a 00                	push   $0x0
  800b4d:	6a 00                	push   $0x0
  800b4f:	6a 00                	push   $0x0
  800b51:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b56:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5b:	b8 01 00 00 00       	mov    $0x1,%eax
  800b60:	e8 6e ff ff ff       	call   800ad3 <syscall>
}
  800b65:	c9                   	leave  
  800b66:	c3                   	ret    

00800b67 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800b6d:	6a 00                	push   $0x0
  800b6f:	6a 00                	push   $0x0
  800b71:	6a 00                	push   $0x0
  800b73:	6a 00                	push   $0x0
  800b75:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b78:	ba 01 00 00 00       	mov    $0x1,%edx
  800b7d:	b8 03 00 00 00       	mov    $0x3,%eax
  800b82:	e8 4c ff ff ff       	call   800ad3 <syscall>
}
  800b87:	c9                   	leave  
  800b88:	c3                   	ret    

00800b89 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b8f:	6a 00                	push   $0x0
  800b91:	6a 00                	push   $0x0
  800b93:	6a 00                	push   $0x0
  800b95:	6a 00                	push   $0x0
  800b97:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba1:	b8 02 00 00 00       	mov    $0x2,%eax
  800ba6:	e8 28 ff ff ff       	call   800ad3 <syscall>
}
  800bab:	c9                   	leave  
  800bac:	c3                   	ret    

00800bad <sys_yield>:

void
sys_yield(void)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800bb3:	6a 00                	push   $0x0
  800bb5:	6a 00                	push   $0x0
  800bb7:	6a 00                	push   $0x0
  800bb9:	6a 00                	push   $0x0
  800bbb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bc0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bca:	e8 04 ff ff ff       	call   800ad3 <syscall>
}
  800bcf:	83 c4 10             	add    $0x10,%esp
  800bd2:	c9                   	leave  
  800bd3:	c3                   	ret    

00800bd4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800bda:	6a 00                	push   $0x0
  800bdc:	6a 00                	push   $0x0
  800bde:	ff 75 10             	pushl  0x10(%ebp)
  800be1:	ff 75 0c             	pushl  0xc(%ebp)
  800be4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800be7:	ba 01 00 00 00       	mov    $0x1,%edx
  800bec:	b8 04 00 00 00       	mov    $0x4,%eax
  800bf1:	e8 dd fe ff ff       	call   800ad3 <syscall>
}
  800bf6:	c9                   	leave  
  800bf7:	c3                   	ret    

00800bf8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800bfe:	ff 75 18             	pushl  0x18(%ebp)
  800c01:	ff 75 14             	pushl  0x14(%ebp)
  800c04:	ff 75 10             	pushl  0x10(%ebp)
  800c07:	ff 75 0c             	pushl  0xc(%ebp)
  800c0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c0d:	ba 01 00 00 00       	mov    $0x1,%edx
  800c12:	b8 05 00 00 00       	mov    $0x5,%eax
  800c17:	e8 b7 fe ff ff       	call   800ad3 <syscall>
}
  800c1c:	c9                   	leave  
  800c1d:	c3                   	ret    

00800c1e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800c24:	6a 00                	push   $0x0
  800c26:	6a 00                	push   $0x0
  800c28:	6a 00                	push   $0x0
  800c2a:	ff 75 0c             	pushl  0xc(%ebp)
  800c2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c30:	ba 01 00 00 00       	mov    $0x1,%edx
  800c35:	b8 06 00 00 00       	mov    $0x6,%eax
  800c3a:	e8 94 fe ff ff       	call   800ad3 <syscall>
}
  800c3f:	c9                   	leave  
  800c40:	c3                   	ret    

00800c41 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c41:	55                   	push   %ebp
  800c42:	89 e5                	mov    %esp,%ebp
  800c44:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c47:	6a 00                	push   $0x0
  800c49:	6a 00                	push   $0x0
  800c4b:	6a 00                	push   $0x0
  800c4d:	ff 75 0c             	pushl  0xc(%ebp)
  800c50:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c53:	ba 01 00 00 00       	mov    $0x1,%edx
  800c58:	b8 08 00 00 00       	mov    $0x8,%eax
  800c5d:	e8 71 fe ff ff       	call   800ad3 <syscall>
}
  800c62:	c9                   	leave  
  800c63:	c3                   	ret    

00800c64 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800c6a:	6a 00                	push   $0x0
  800c6c:	6a 00                	push   $0x0
  800c6e:	6a 00                	push   $0x0
  800c70:	ff 75 0c             	pushl  0xc(%ebp)
  800c73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c76:	ba 01 00 00 00       	mov    $0x1,%edx
  800c7b:	b8 09 00 00 00       	mov    $0x9,%eax
  800c80:	e8 4e fe ff ff       	call   800ad3 <syscall>
}
  800c85:	c9                   	leave  
  800c86:	c3                   	ret    

00800c87 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800c8d:	6a 00                	push   $0x0
  800c8f:	6a 00                	push   $0x0
  800c91:	6a 00                	push   $0x0
  800c93:	ff 75 0c             	pushl  0xc(%ebp)
  800c96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c99:	ba 01 00 00 00       	mov    $0x1,%edx
  800c9e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ca3:	e8 2b fe ff ff       	call   800ad3 <syscall>
}
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800cb0:	6a 00                	push   $0x0
  800cb2:	ff 75 14             	pushl  0x14(%ebp)
  800cb5:	ff 75 10             	pushl  0x10(%ebp)
  800cb8:	ff 75 0c             	pushl  0xc(%ebp)
  800cbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cbe:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc3:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cc8:	e8 06 fe ff ff       	call   800ad3 <syscall>
}
  800ccd:	c9                   	leave  
  800cce:	c3                   	ret    

00800ccf <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ccf:	55                   	push   %ebp
  800cd0:	89 e5                	mov    %esp,%ebp
  800cd2:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800cd5:	6a 00                	push   $0x0
  800cd7:	6a 00                	push   $0x0
  800cd9:	6a 00                	push   $0x0
  800cdb:	6a 00                	push   $0x0
  800cdd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ce0:	ba 01 00 00 00       	mov    $0x1,%edx
  800ce5:	b8 0d 00 00 00       	mov    $0xd,%eax
  800cea:	e8 e4 fd ff ff       	call   800ad3 <syscall>
}
  800cef:	c9                   	leave  
  800cf0:	c3                   	ret    

00800cf1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	05 00 00 00 30       	add    $0x30000000,%eax
  800cfc:	c1 e8 0c             	shr    $0xc,%eax
}
  800cff:	5d                   	pop    %ebp
  800d00:	c3                   	ret    

00800d01 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800d01:	55                   	push   %ebp
  800d02:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  800d04:	ff 75 08             	pushl  0x8(%ebp)
  800d07:	e8 e5 ff ff ff       	call   800cf1 <fd2num>
  800d0c:	83 c4 04             	add    $0x4,%esp
  800d0f:	c1 e0 0c             	shl    $0xc,%eax
  800d12:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800d17:	c9                   	leave  
  800d18:	c3                   	ret    

00800d19 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d1f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800d24:	89 c2                	mov    %eax,%edx
  800d26:	c1 ea 16             	shr    $0x16,%edx
  800d29:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800d30:	f6 c2 01             	test   $0x1,%dl
  800d33:	74 11                	je     800d46 <fd_alloc+0x2d>
  800d35:	89 c2                	mov    %eax,%edx
  800d37:	c1 ea 0c             	shr    $0xc,%edx
  800d3a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d41:	f6 c2 01             	test   $0x1,%dl
  800d44:	75 09                	jne    800d4f <fd_alloc+0x36>
			*fd_store = fd;
  800d46:	89 01                	mov    %eax,(%ecx)
			return 0;
  800d48:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4d:	eb 17                	jmp    800d66 <fd_alloc+0x4d>
  800d4f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800d54:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800d59:	75 c9                	jne    800d24 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800d5b:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800d61:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800d66:	5d                   	pop    %ebp
  800d67:	c3                   	ret    

00800d68 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800d6e:	83 f8 1f             	cmp    $0x1f,%eax
  800d71:	77 36                	ja     800da9 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800d73:	c1 e0 0c             	shl    $0xc,%eax
  800d76:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800d7b:	89 c2                	mov    %eax,%edx
  800d7d:	c1 ea 16             	shr    $0x16,%edx
  800d80:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800d87:	f6 c2 01             	test   $0x1,%dl
  800d8a:	74 24                	je     800db0 <fd_lookup+0x48>
  800d8c:	89 c2                	mov    %eax,%edx
  800d8e:	c1 ea 0c             	shr    $0xc,%edx
  800d91:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d98:	f6 c2 01             	test   $0x1,%dl
  800d9b:	74 1a                	je     800db7 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800d9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da0:	89 02                	mov    %eax,(%edx)
	return 0;
  800da2:	b8 00 00 00 00       	mov    $0x0,%eax
  800da7:	eb 13                	jmp    800dbc <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800da9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dae:	eb 0c                	jmp    800dbc <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800db0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800db5:	eb 05                	jmp    800dbc <fd_lookup+0x54>
  800db7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800dbc:	5d                   	pop    %ebp
  800dbd:	c3                   	ret    

00800dbe <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	83 ec 08             	sub    $0x8,%esp
  800dc4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dc7:	ba 6c 22 80 00       	mov    $0x80226c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800dcc:	eb 13                	jmp    800de1 <dev_lookup+0x23>
  800dce:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  800dd1:	39 08                	cmp    %ecx,(%eax)
  800dd3:	75 0c                	jne    800de1 <dev_lookup+0x23>
			*dev = devtab[i];
  800dd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd8:	89 01                	mov    %eax,(%ecx)
			return 0;
  800dda:	b8 00 00 00 00       	mov    $0x0,%eax
  800ddf:	eb 2e                	jmp    800e0f <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800de1:	8b 02                	mov    (%edx),%eax
  800de3:	85 c0                	test   %eax,%eax
  800de5:	75 e7                	jne    800dce <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800de7:	a1 20 40 c0 00       	mov    0xc04020,%eax
  800dec:	8b 40 48             	mov    0x48(%eax),%eax
  800def:	83 ec 04             	sub    $0x4,%esp
  800df2:	51                   	push   %ecx
  800df3:	50                   	push   %eax
  800df4:	68 ec 21 80 00       	push   $0x8021ec
  800df9:	e8 1b f4 ff ff       	call   800219 <cprintf>
	*dev = 0;
  800dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e07:	83 c4 10             	add    $0x10,%esp
  800e0a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	56                   	push   %esi
  800e15:	53                   	push   %ebx
  800e16:	83 ec 10             	sub    $0x10,%esp
  800e19:	8b 75 08             	mov    0x8(%ebp),%esi
  800e1c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e1f:	56                   	push   %esi
  800e20:	e8 cc fe ff ff       	call   800cf1 <fd2num>
  800e25:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800e28:	89 14 24             	mov    %edx,(%esp)
  800e2b:	50                   	push   %eax
  800e2c:	e8 37 ff ff ff       	call   800d68 <fd_lookup>
  800e31:	83 c4 08             	add    $0x8,%esp
  800e34:	85 c0                	test   %eax,%eax
  800e36:	78 05                	js     800e3d <fd_close+0x2c>
	    || fd != fd2)
  800e38:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800e3b:	74 0c                	je     800e49 <fd_close+0x38>
		return (must_exist ? r : 0);
  800e3d:	84 db                	test   %bl,%bl
  800e3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800e44:	0f 44 c2             	cmove  %edx,%eax
  800e47:	eb 41                	jmp    800e8a <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800e49:	83 ec 08             	sub    $0x8,%esp
  800e4c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e4f:	50                   	push   %eax
  800e50:	ff 36                	pushl  (%esi)
  800e52:	e8 67 ff ff ff       	call   800dbe <dev_lookup>
  800e57:	89 c3                	mov    %eax,%ebx
  800e59:	83 c4 10             	add    $0x10,%esp
  800e5c:	85 c0                	test   %eax,%eax
  800e5e:	78 1a                	js     800e7a <fd_close+0x69>
		if (dev->dev_close)
  800e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e63:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800e66:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800e6b:	85 c0                	test   %eax,%eax
  800e6d:	74 0b                	je     800e7a <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  800e6f:	83 ec 0c             	sub    $0xc,%esp
  800e72:	56                   	push   %esi
  800e73:	ff d0                	call   *%eax
  800e75:	89 c3                	mov    %eax,%ebx
  800e77:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800e7a:	83 ec 08             	sub    $0x8,%esp
  800e7d:	56                   	push   %esi
  800e7e:	6a 00                	push   $0x0
  800e80:	e8 99 fd ff ff       	call   800c1e <sys_page_unmap>
	return r;
  800e85:	83 c4 10             	add    $0x10,%esp
  800e88:	89 d8                	mov    %ebx,%eax
}
  800e8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e8d:	5b                   	pop    %ebx
  800e8e:	5e                   	pop    %esi
  800e8f:	5d                   	pop    %ebp
  800e90:	c3                   	ret    

00800e91 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800e91:	55                   	push   %ebp
  800e92:	89 e5                	mov    %esp,%ebp
  800e94:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e97:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e9a:	50                   	push   %eax
  800e9b:	ff 75 08             	pushl  0x8(%ebp)
  800e9e:	e8 c5 fe ff ff       	call   800d68 <fd_lookup>
  800ea3:	83 c4 08             	add    $0x8,%esp
  800ea6:	85 c0                	test   %eax,%eax
  800ea8:	78 10                	js     800eba <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800eaa:	83 ec 08             	sub    $0x8,%esp
  800ead:	6a 01                	push   $0x1
  800eaf:	ff 75 f4             	pushl  -0xc(%ebp)
  800eb2:	e8 5a ff ff ff       	call   800e11 <fd_close>
  800eb7:	83 c4 10             	add    $0x10,%esp
}
  800eba:	c9                   	leave  
  800ebb:	c3                   	ret    

00800ebc <close_all>:

void
close_all(void)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	53                   	push   %ebx
  800ec0:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800ec3:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	53                   	push   %ebx
  800ecc:	e8 c0 ff ff ff       	call   800e91 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800ed1:	83 c3 01             	add    $0x1,%ebx
  800ed4:	83 c4 10             	add    $0x10,%esp
  800ed7:	83 fb 20             	cmp    $0x20,%ebx
  800eda:	75 ec                	jne    800ec8 <close_all+0xc>
		close(i);
}
  800edc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800edf:	c9                   	leave  
  800ee0:	c3                   	ret    

00800ee1 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800ee1:	55                   	push   %ebp
  800ee2:	89 e5                	mov    %esp,%ebp
  800ee4:	57                   	push   %edi
  800ee5:	56                   	push   %esi
  800ee6:	53                   	push   %ebx
  800ee7:	83 ec 2c             	sub    $0x2c,%esp
  800eea:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800eed:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800ef0:	50                   	push   %eax
  800ef1:	ff 75 08             	pushl  0x8(%ebp)
  800ef4:	e8 6f fe ff ff       	call   800d68 <fd_lookup>
  800ef9:	83 c4 08             	add    $0x8,%esp
  800efc:	85 c0                	test   %eax,%eax
  800efe:	0f 88 c1 00 00 00    	js     800fc5 <dup+0xe4>
		return r;
	close(newfdnum);
  800f04:	83 ec 0c             	sub    $0xc,%esp
  800f07:	56                   	push   %esi
  800f08:	e8 84 ff ff ff       	call   800e91 <close>

	newfd = INDEX2FD(newfdnum);
  800f0d:	89 f3                	mov    %esi,%ebx
  800f0f:	c1 e3 0c             	shl    $0xc,%ebx
  800f12:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800f18:	83 c4 04             	add    $0x4,%esp
  800f1b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f1e:	e8 de fd ff ff       	call   800d01 <fd2data>
  800f23:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  800f25:	89 1c 24             	mov    %ebx,(%esp)
  800f28:	e8 d4 fd ff ff       	call   800d01 <fd2data>
  800f2d:	83 c4 10             	add    $0x10,%esp
  800f30:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800f33:	89 f8                	mov    %edi,%eax
  800f35:	c1 e8 16             	shr    $0x16,%eax
  800f38:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f3f:	a8 01                	test   $0x1,%al
  800f41:	74 37                	je     800f7a <dup+0x99>
  800f43:	89 f8                	mov    %edi,%eax
  800f45:	c1 e8 0c             	shr    $0xc,%eax
  800f48:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800f4f:	f6 c2 01             	test   $0x1,%dl
  800f52:	74 26                	je     800f7a <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800f54:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f5b:	83 ec 0c             	sub    $0xc,%esp
  800f5e:	25 07 0e 00 00       	and    $0xe07,%eax
  800f63:	50                   	push   %eax
  800f64:	ff 75 d4             	pushl  -0x2c(%ebp)
  800f67:	6a 00                	push   $0x0
  800f69:	57                   	push   %edi
  800f6a:	6a 00                	push   $0x0
  800f6c:	e8 87 fc ff ff       	call   800bf8 <sys_page_map>
  800f71:	89 c7                	mov    %eax,%edi
  800f73:	83 c4 20             	add    $0x20,%esp
  800f76:	85 c0                	test   %eax,%eax
  800f78:	78 2e                	js     800fa8 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800f7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f7d:	89 d0                	mov    %edx,%eax
  800f7f:	c1 e8 0c             	shr    $0xc,%eax
  800f82:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f89:	83 ec 0c             	sub    $0xc,%esp
  800f8c:	25 07 0e 00 00       	and    $0xe07,%eax
  800f91:	50                   	push   %eax
  800f92:	53                   	push   %ebx
  800f93:	6a 00                	push   $0x0
  800f95:	52                   	push   %edx
  800f96:	6a 00                	push   $0x0
  800f98:	e8 5b fc ff ff       	call   800bf8 <sys_page_map>
  800f9d:	89 c7                	mov    %eax,%edi
  800f9f:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  800fa2:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800fa4:	85 ff                	test   %edi,%edi
  800fa6:	79 1d                	jns    800fc5 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800fa8:	83 ec 08             	sub    $0x8,%esp
  800fab:	53                   	push   %ebx
  800fac:	6a 00                	push   $0x0
  800fae:	e8 6b fc ff ff       	call   800c1e <sys_page_unmap>
	sys_page_unmap(0, nva);
  800fb3:	83 c4 08             	add    $0x8,%esp
  800fb6:	ff 75 d4             	pushl  -0x2c(%ebp)
  800fb9:	6a 00                	push   $0x0
  800fbb:	e8 5e fc ff ff       	call   800c1e <sys_page_unmap>
	return r;
  800fc0:	83 c4 10             	add    $0x10,%esp
  800fc3:	89 f8                	mov    %edi,%eax
}
  800fc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc8:	5b                   	pop    %ebx
  800fc9:	5e                   	pop    %esi
  800fca:	5f                   	pop    %edi
  800fcb:	5d                   	pop    %ebp
  800fcc:	c3                   	ret    

00800fcd <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	53                   	push   %ebx
  800fd1:	83 ec 14             	sub    $0x14,%esp
  800fd4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800fd7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800fda:	50                   	push   %eax
  800fdb:	53                   	push   %ebx
  800fdc:	e8 87 fd ff ff       	call   800d68 <fd_lookup>
  800fe1:	83 c4 08             	add    $0x8,%esp
  800fe4:	89 c2                	mov    %eax,%edx
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	78 6d                	js     801057 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800fea:	83 ec 08             	sub    $0x8,%esp
  800fed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ff0:	50                   	push   %eax
  800ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff4:	ff 30                	pushl  (%eax)
  800ff6:	e8 c3 fd ff ff       	call   800dbe <dev_lookup>
  800ffb:	83 c4 10             	add    $0x10,%esp
  800ffe:	85 c0                	test   %eax,%eax
  801000:	78 4c                	js     80104e <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801002:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801005:	8b 42 08             	mov    0x8(%edx),%eax
  801008:	83 e0 03             	and    $0x3,%eax
  80100b:	83 f8 01             	cmp    $0x1,%eax
  80100e:	75 21                	jne    801031 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801010:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801015:	8b 40 48             	mov    0x48(%eax),%eax
  801018:	83 ec 04             	sub    $0x4,%esp
  80101b:	53                   	push   %ebx
  80101c:	50                   	push   %eax
  80101d:	68 30 22 80 00       	push   $0x802230
  801022:	e8 f2 f1 ff ff       	call   800219 <cprintf>
		return -E_INVAL;
  801027:	83 c4 10             	add    $0x10,%esp
  80102a:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80102f:	eb 26                	jmp    801057 <read+0x8a>
	}
	if (!dev->dev_read)
  801031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801034:	8b 40 08             	mov    0x8(%eax),%eax
  801037:	85 c0                	test   %eax,%eax
  801039:	74 17                	je     801052 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80103b:	83 ec 04             	sub    $0x4,%esp
  80103e:	ff 75 10             	pushl  0x10(%ebp)
  801041:	ff 75 0c             	pushl  0xc(%ebp)
  801044:	52                   	push   %edx
  801045:	ff d0                	call   *%eax
  801047:	89 c2                	mov    %eax,%edx
  801049:	83 c4 10             	add    $0x10,%esp
  80104c:	eb 09                	jmp    801057 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80104e:	89 c2                	mov    %eax,%edx
  801050:	eb 05                	jmp    801057 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801052:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  801057:	89 d0                	mov    %edx,%eax
  801059:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80105c:	c9                   	leave  
  80105d:	c3                   	ret    

0080105e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	57                   	push   %edi
  801062:	56                   	push   %esi
  801063:	53                   	push   %ebx
  801064:	83 ec 0c             	sub    $0xc,%esp
  801067:	8b 7d 08             	mov    0x8(%ebp),%edi
  80106a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80106d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801072:	eb 21                	jmp    801095 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801074:	83 ec 04             	sub    $0x4,%esp
  801077:	89 f0                	mov    %esi,%eax
  801079:	29 d8                	sub    %ebx,%eax
  80107b:	50                   	push   %eax
  80107c:	89 d8                	mov    %ebx,%eax
  80107e:	03 45 0c             	add    0xc(%ebp),%eax
  801081:	50                   	push   %eax
  801082:	57                   	push   %edi
  801083:	e8 45 ff ff ff       	call   800fcd <read>
		if (m < 0)
  801088:	83 c4 10             	add    $0x10,%esp
  80108b:	85 c0                	test   %eax,%eax
  80108d:	78 10                	js     80109f <readn+0x41>
			return m;
		if (m == 0)
  80108f:	85 c0                	test   %eax,%eax
  801091:	74 0a                	je     80109d <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801093:	01 c3                	add    %eax,%ebx
  801095:	39 f3                	cmp    %esi,%ebx
  801097:	72 db                	jb     801074 <readn+0x16>
  801099:	89 d8                	mov    %ebx,%eax
  80109b:	eb 02                	jmp    80109f <readn+0x41>
  80109d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80109f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a2:	5b                   	pop    %ebx
  8010a3:	5e                   	pop    %esi
  8010a4:	5f                   	pop    %edi
  8010a5:	5d                   	pop    %ebp
  8010a6:	c3                   	ret    

008010a7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	53                   	push   %ebx
  8010ab:	83 ec 14             	sub    $0x14,%esp
  8010ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010b4:	50                   	push   %eax
  8010b5:	53                   	push   %ebx
  8010b6:	e8 ad fc ff ff       	call   800d68 <fd_lookup>
  8010bb:	83 c4 08             	add    $0x8,%esp
  8010be:	89 c2                	mov    %eax,%edx
  8010c0:	85 c0                	test   %eax,%eax
  8010c2:	78 68                	js     80112c <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010c4:	83 ec 08             	sub    $0x8,%esp
  8010c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010ca:	50                   	push   %eax
  8010cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010ce:	ff 30                	pushl  (%eax)
  8010d0:	e8 e9 fc ff ff       	call   800dbe <dev_lookup>
  8010d5:	83 c4 10             	add    $0x10,%esp
  8010d8:	85 c0                	test   %eax,%eax
  8010da:	78 47                	js     801123 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8010dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010df:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8010e3:	75 21                	jne    801106 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8010e5:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8010ea:	8b 40 48             	mov    0x48(%eax),%eax
  8010ed:	83 ec 04             	sub    $0x4,%esp
  8010f0:	53                   	push   %ebx
  8010f1:	50                   	push   %eax
  8010f2:	68 4c 22 80 00       	push   $0x80224c
  8010f7:	e8 1d f1 ff ff       	call   800219 <cprintf>
		return -E_INVAL;
  8010fc:	83 c4 10             	add    $0x10,%esp
  8010ff:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801104:	eb 26                	jmp    80112c <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801106:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801109:	8b 52 0c             	mov    0xc(%edx),%edx
  80110c:	85 d2                	test   %edx,%edx
  80110e:	74 17                	je     801127 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801110:	83 ec 04             	sub    $0x4,%esp
  801113:	ff 75 10             	pushl  0x10(%ebp)
  801116:	ff 75 0c             	pushl  0xc(%ebp)
  801119:	50                   	push   %eax
  80111a:	ff d2                	call   *%edx
  80111c:	89 c2                	mov    %eax,%edx
  80111e:	83 c4 10             	add    $0x10,%esp
  801121:	eb 09                	jmp    80112c <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801123:	89 c2                	mov    %eax,%edx
  801125:	eb 05                	jmp    80112c <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801127:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  80112c:	89 d0                	mov    %edx,%eax
  80112e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801131:	c9                   	leave  
  801132:	c3                   	ret    

00801133 <seek>:

int
seek(int fdnum, off_t offset)
{
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
  801136:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801139:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80113c:	50                   	push   %eax
  80113d:	ff 75 08             	pushl  0x8(%ebp)
  801140:	e8 23 fc ff ff       	call   800d68 <fd_lookup>
  801145:	83 c4 08             	add    $0x8,%esp
  801148:	85 c0                	test   %eax,%eax
  80114a:	78 0e                	js     80115a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80114c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801152:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801155:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80115a:	c9                   	leave  
  80115b:	c3                   	ret    

0080115c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	53                   	push   %ebx
  801160:	83 ec 14             	sub    $0x14,%esp
  801163:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801166:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801169:	50                   	push   %eax
  80116a:	53                   	push   %ebx
  80116b:	e8 f8 fb ff ff       	call   800d68 <fd_lookup>
  801170:	83 c4 08             	add    $0x8,%esp
  801173:	89 c2                	mov    %eax,%edx
  801175:	85 c0                	test   %eax,%eax
  801177:	78 65                	js     8011de <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801179:	83 ec 08             	sub    $0x8,%esp
  80117c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80117f:	50                   	push   %eax
  801180:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801183:	ff 30                	pushl  (%eax)
  801185:	e8 34 fc ff ff       	call   800dbe <dev_lookup>
  80118a:	83 c4 10             	add    $0x10,%esp
  80118d:	85 c0                	test   %eax,%eax
  80118f:	78 44                	js     8011d5 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801191:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801194:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801198:	75 21                	jne    8011bb <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80119a:	a1 20 40 c0 00       	mov    0xc04020,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80119f:	8b 40 48             	mov    0x48(%eax),%eax
  8011a2:	83 ec 04             	sub    $0x4,%esp
  8011a5:	53                   	push   %ebx
  8011a6:	50                   	push   %eax
  8011a7:	68 0c 22 80 00       	push   $0x80220c
  8011ac:	e8 68 f0 ff ff       	call   800219 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8011b1:	83 c4 10             	add    $0x10,%esp
  8011b4:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8011b9:	eb 23                	jmp    8011de <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  8011bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011be:	8b 52 18             	mov    0x18(%edx),%edx
  8011c1:	85 d2                	test   %edx,%edx
  8011c3:	74 14                	je     8011d9 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	ff 75 0c             	pushl  0xc(%ebp)
  8011cb:	50                   	push   %eax
  8011cc:	ff d2                	call   *%edx
  8011ce:	89 c2                	mov    %eax,%edx
  8011d0:	83 c4 10             	add    $0x10,%esp
  8011d3:	eb 09                	jmp    8011de <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011d5:	89 c2                	mov    %eax,%edx
  8011d7:	eb 05                	jmp    8011de <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8011d9:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  8011de:	89 d0                	mov    %edx,%eax
  8011e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011e3:	c9                   	leave  
  8011e4:	c3                   	ret    

008011e5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
  8011e8:	53                   	push   %ebx
  8011e9:	83 ec 14             	sub    $0x14,%esp
  8011ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011f2:	50                   	push   %eax
  8011f3:	ff 75 08             	pushl  0x8(%ebp)
  8011f6:	e8 6d fb ff ff       	call   800d68 <fd_lookup>
  8011fb:	83 c4 08             	add    $0x8,%esp
  8011fe:	89 c2                	mov    %eax,%edx
  801200:	85 c0                	test   %eax,%eax
  801202:	78 58                	js     80125c <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801204:	83 ec 08             	sub    $0x8,%esp
  801207:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80120a:	50                   	push   %eax
  80120b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80120e:	ff 30                	pushl  (%eax)
  801210:	e8 a9 fb ff ff       	call   800dbe <dev_lookup>
  801215:	83 c4 10             	add    $0x10,%esp
  801218:	85 c0                	test   %eax,%eax
  80121a:	78 37                	js     801253 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  80121c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80121f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801223:	74 32                	je     801257 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801225:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801228:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80122f:	00 00 00 
	stat->st_isdir = 0;
  801232:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801239:	00 00 00 
	stat->st_dev = dev;
  80123c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801242:	83 ec 08             	sub    $0x8,%esp
  801245:	53                   	push   %ebx
  801246:	ff 75 f0             	pushl  -0x10(%ebp)
  801249:	ff 50 14             	call   *0x14(%eax)
  80124c:	89 c2                	mov    %eax,%edx
  80124e:	83 c4 10             	add    $0x10,%esp
  801251:	eb 09                	jmp    80125c <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801253:	89 c2                	mov    %eax,%edx
  801255:	eb 05                	jmp    80125c <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801257:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80125c:	89 d0                	mov    %edx,%eax
  80125e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801261:	c9                   	leave  
  801262:	c3                   	ret    

00801263 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
  801266:	56                   	push   %esi
  801267:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801268:	83 ec 08             	sub    $0x8,%esp
  80126b:	6a 00                	push   $0x0
  80126d:	ff 75 08             	pushl  0x8(%ebp)
  801270:	e8 06 02 00 00       	call   80147b <open>
  801275:	89 c3                	mov    %eax,%ebx
  801277:	83 c4 10             	add    $0x10,%esp
  80127a:	85 c0                	test   %eax,%eax
  80127c:	78 1b                	js     801299 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80127e:	83 ec 08             	sub    $0x8,%esp
  801281:	ff 75 0c             	pushl  0xc(%ebp)
  801284:	50                   	push   %eax
  801285:	e8 5b ff ff ff       	call   8011e5 <fstat>
  80128a:	89 c6                	mov    %eax,%esi
	close(fd);
  80128c:	89 1c 24             	mov    %ebx,(%esp)
  80128f:	e8 fd fb ff ff       	call   800e91 <close>
	return r;
  801294:	83 c4 10             	add    $0x10,%esp
  801297:	89 f0                	mov    %esi,%eax
}
  801299:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80129c:	5b                   	pop    %ebx
  80129d:	5e                   	pop    %esi
  80129e:	5d                   	pop    %ebp
  80129f:	c3                   	ret    

008012a0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
  8012a3:	56                   	push   %esi
  8012a4:	53                   	push   %ebx
  8012a5:	89 c6                	mov    %eax,%esi
  8012a7:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8012a9:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8012b0:	75 12                	jne    8012c4 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8012b2:	83 ec 0c             	sub    $0xc,%esp
  8012b5:	6a 01                	push   $0x1
  8012b7:	e8 01 08 00 00       	call   801abd <ipc_find_env>
  8012bc:	a3 00 40 80 00       	mov    %eax,0x804000
  8012c1:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8012c4:	6a 07                	push   $0x7
  8012c6:	68 00 50 c0 00       	push   $0xc05000
  8012cb:	56                   	push   %esi
  8012cc:	ff 35 00 40 80 00    	pushl  0x804000
  8012d2:	e8 92 07 00 00       	call   801a69 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8012d7:	83 c4 0c             	add    $0xc,%esp
  8012da:	6a 00                	push   $0x0
  8012dc:	53                   	push   %ebx
  8012dd:	6a 00                	push   $0x0
  8012df:	e8 1a 07 00 00       	call   8019fe <ipc_recv>
}
  8012e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e7:	5b                   	pop    %ebx
  8012e8:	5e                   	pop    %esi
  8012e9:	5d                   	pop    %ebp
  8012ea:	c3                   	ret    

008012eb <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
  8012ee:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8012f7:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.set_size.req_size = newsize;
  8012fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ff:	a3 04 50 c0 00       	mov    %eax,0xc05004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801304:	ba 00 00 00 00       	mov    $0x0,%edx
  801309:	b8 02 00 00 00       	mov    $0x2,%eax
  80130e:	e8 8d ff ff ff       	call   8012a0 <fsipc>
}
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
  801318:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80131b:	8b 45 08             	mov    0x8(%ebp),%eax
  80131e:	8b 40 0c             	mov    0xc(%eax),%eax
  801321:	a3 00 50 c0 00       	mov    %eax,0xc05000
	return fsipc(FSREQ_FLUSH, NULL);
  801326:	ba 00 00 00 00       	mov    $0x0,%edx
  80132b:	b8 06 00 00 00       	mov    $0x6,%eax
  801330:	e8 6b ff ff ff       	call   8012a0 <fsipc>
}
  801335:	c9                   	leave  
  801336:	c3                   	ret    

00801337 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	53                   	push   %ebx
  80133b:	83 ec 04             	sub    $0x4,%esp
  80133e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	8b 40 0c             	mov    0xc(%eax),%eax
  801347:	a3 00 50 c0 00       	mov    %eax,0xc05000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80134c:	ba 00 00 00 00       	mov    $0x0,%edx
  801351:	b8 05 00 00 00       	mov    $0x5,%eax
  801356:	e8 45 ff ff ff       	call   8012a0 <fsipc>
  80135b:	85 c0                	test   %eax,%eax
  80135d:	78 2c                	js     80138b <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80135f:	83 ec 08             	sub    $0x8,%esp
  801362:	68 00 50 c0 00       	push   $0xc05000
  801367:	53                   	push   %ebx
  801368:	e8 1e f4 ff ff       	call   80078b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80136d:	a1 80 50 c0 00       	mov    0xc05080,%eax
  801372:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801378:	a1 84 50 c0 00       	mov    0xc05084,%eax
  80137d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801383:	83 c4 10             	add    $0x10,%esp
  801386:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80138b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80138e:	c9                   	leave  
  80138f:	c3                   	ret    

00801390 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
  801393:	83 ec 08             	sub    $0x8,%esp
  801396:	8b 55 0c             	mov    0xc(%ebp),%edx
  801399:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80139c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80139f:	8b 49 0c             	mov    0xc(%ecx),%ecx
  8013a2:	89 0d 00 50 c0 00    	mov    %ecx,0xc05000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  8013a8:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8013ad:	76 22                	jbe    8013d1 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  8013af:	c7 05 04 50 c0 00 f8 	movl   $0xff8,0xc05004
  8013b6:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  8013b9:	83 ec 04             	sub    $0x4,%esp
  8013bc:	68 f8 0f 00 00       	push   $0xff8
  8013c1:	52                   	push   %edx
  8013c2:	68 08 50 c0 00       	push   $0xc05008
  8013c7:	e8 52 f5 ff ff       	call   80091e <memmove>
  8013cc:	83 c4 10             	add    $0x10,%esp
  8013cf:	eb 17                	jmp    8013e8 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  8013d1:	a3 04 50 c0 00       	mov    %eax,0xc05004
		memmove(fsipcbuf.write.req_buf, buf, n);
  8013d6:	83 ec 04             	sub    $0x4,%esp
  8013d9:	50                   	push   %eax
  8013da:	52                   	push   %edx
  8013db:	68 08 50 c0 00       	push   $0xc05008
  8013e0:	e8 39 f5 ff ff       	call   80091e <memmove>
  8013e5:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  8013e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ed:	b8 04 00 00 00       	mov    $0x4,%eax
  8013f2:	e8 a9 fe ff ff       	call   8012a0 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    

008013f9 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	56                   	push   %esi
  8013fd:	53                   	push   %ebx
  8013fe:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	8b 40 0c             	mov    0xc(%eax),%eax
  801407:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.read.req_n = n;
  80140c:	89 35 04 50 c0 00    	mov    %esi,0xc05004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801412:	ba 00 00 00 00       	mov    $0x0,%edx
  801417:	b8 03 00 00 00       	mov    $0x3,%eax
  80141c:	e8 7f fe ff ff       	call   8012a0 <fsipc>
  801421:	89 c3                	mov    %eax,%ebx
  801423:	85 c0                	test   %eax,%eax
  801425:	78 4b                	js     801472 <devfile_read+0x79>
		return r;
	assert(r <= n);
  801427:	39 c6                	cmp    %eax,%esi
  801429:	73 16                	jae    801441 <devfile_read+0x48>
  80142b:	68 7c 22 80 00       	push   $0x80227c
  801430:	68 83 22 80 00       	push   $0x802283
  801435:	6a 7c                	push   $0x7c
  801437:	68 98 22 80 00       	push   $0x802298
  80143c:	e8 ff ec ff ff       	call   800140 <_panic>
	assert(r <= PGSIZE);
  801441:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801446:	7e 16                	jle    80145e <devfile_read+0x65>
  801448:	68 a3 22 80 00       	push   $0x8022a3
  80144d:	68 83 22 80 00       	push   $0x802283
  801452:	6a 7d                	push   $0x7d
  801454:	68 98 22 80 00       	push   $0x802298
  801459:	e8 e2 ec ff ff       	call   800140 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80145e:	83 ec 04             	sub    $0x4,%esp
  801461:	50                   	push   %eax
  801462:	68 00 50 c0 00       	push   $0xc05000
  801467:	ff 75 0c             	pushl  0xc(%ebp)
  80146a:	e8 af f4 ff ff       	call   80091e <memmove>
	return r;
  80146f:	83 c4 10             	add    $0x10,%esp
}
  801472:	89 d8                	mov    %ebx,%eax
  801474:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801477:	5b                   	pop    %ebx
  801478:	5e                   	pop    %esi
  801479:	5d                   	pop    %ebp
  80147a:	c3                   	ret    

0080147b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
  80147e:	53                   	push   %ebx
  80147f:	83 ec 20             	sub    $0x20,%esp
  801482:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801485:	53                   	push   %ebx
  801486:	e8 c7 f2 ff ff       	call   800752 <strlen>
  80148b:	83 c4 10             	add    $0x10,%esp
  80148e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801493:	7f 67                	jg     8014fc <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801495:	83 ec 0c             	sub    $0xc,%esp
  801498:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80149b:	50                   	push   %eax
  80149c:	e8 78 f8 ff ff       	call   800d19 <fd_alloc>
  8014a1:	83 c4 10             	add    $0x10,%esp
		return r;
  8014a4:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	78 57                	js     801501 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8014aa:	83 ec 08             	sub    $0x8,%esp
  8014ad:	53                   	push   %ebx
  8014ae:	68 00 50 c0 00       	push   $0xc05000
  8014b3:	e8 d3 f2 ff ff       	call   80078b <strcpy>
	fsipcbuf.open.req_omode = mode;
  8014b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bb:	a3 00 54 c0 00       	mov    %eax,0xc05400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8014c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8014c8:	e8 d3 fd ff ff       	call   8012a0 <fsipc>
  8014cd:	89 c3                	mov    %eax,%ebx
  8014cf:	83 c4 10             	add    $0x10,%esp
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	79 14                	jns    8014ea <open+0x6f>
		fd_close(fd, 0);
  8014d6:	83 ec 08             	sub    $0x8,%esp
  8014d9:	6a 00                	push   $0x0
  8014db:	ff 75 f4             	pushl  -0xc(%ebp)
  8014de:	e8 2e f9 ff ff       	call   800e11 <fd_close>
		return r;
  8014e3:	83 c4 10             	add    $0x10,%esp
  8014e6:	89 da                	mov    %ebx,%edx
  8014e8:	eb 17                	jmp    801501 <open+0x86>
	}

	return fd2num(fd);
  8014ea:	83 ec 0c             	sub    $0xc,%esp
  8014ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8014f0:	e8 fc f7 ff ff       	call   800cf1 <fd2num>
  8014f5:	89 c2                	mov    %eax,%edx
  8014f7:	83 c4 10             	add    $0x10,%esp
  8014fa:	eb 05                	jmp    801501 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8014fc:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801501:	89 d0                	mov    %edx,%eax
  801503:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801506:	c9                   	leave  
  801507:	c3                   	ret    

00801508 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80150e:	ba 00 00 00 00       	mov    $0x0,%edx
  801513:	b8 08 00 00 00       	mov    $0x8,%eax
  801518:	e8 83 fd ff ff       	call   8012a0 <fsipc>
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
  801522:	56                   	push   %esi
  801523:	53                   	push   %ebx
  801524:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801527:	83 ec 0c             	sub    $0xc,%esp
  80152a:	ff 75 08             	pushl  0x8(%ebp)
  80152d:	e8 cf f7 ff ff       	call   800d01 <fd2data>
  801532:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801534:	83 c4 08             	add    $0x8,%esp
  801537:	68 af 22 80 00       	push   $0x8022af
  80153c:	53                   	push   %ebx
  80153d:	e8 49 f2 ff ff       	call   80078b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801542:	8b 46 04             	mov    0x4(%esi),%eax
  801545:	2b 06                	sub    (%esi),%eax
  801547:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80154d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801554:	00 00 00 
	stat->st_dev = &devpipe;
  801557:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80155e:	30 80 00 
	return 0;
}
  801561:	b8 00 00 00 00       	mov    $0x0,%eax
  801566:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801569:	5b                   	pop    %ebx
  80156a:	5e                   	pop    %esi
  80156b:	5d                   	pop    %ebp
  80156c:	c3                   	ret    

0080156d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
  801570:	53                   	push   %ebx
  801571:	83 ec 0c             	sub    $0xc,%esp
  801574:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801577:	53                   	push   %ebx
  801578:	6a 00                	push   $0x0
  80157a:	e8 9f f6 ff ff       	call   800c1e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80157f:	89 1c 24             	mov    %ebx,(%esp)
  801582:	e8 7a f7 ff ff       	call   800d01 <fd2data>
  801587:	83 c4 08             	add    $0x8,%esp
  80158a:	50                   	push   %eax
  80158b:	6a 00                	push   $0x0
  80158d:	e8 8c f6 ff ff       	call   800c1e <sys_page_unmap>
}
  801592:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	57                   	push   %edi
  80159b:	56                   	push   %esi
  80159c:	53                   	push   %ebx
  80159d:	83 ec 1c             	sub    $0x1c,%esp
  8015a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8015a3:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8015a5:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8015aa:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  8015ad:	83 ec 0c             	sub    $0xc,%esp
  8015b0:	ff 75 e0             	pushl  -0x20(%ebp)
  8015b3:	e8 3e 05 00 00       	call   801af6 <pageref>
  8015b8:	89 c3                	mov    %eax,%ebx
  8015ba:	89 3c 24             	mov    %edi,(%esp)
  8015bd:	e8 34 05 00 00       	call   801af6 <pageref>
  8015c2:	83 c4 10             	add    $0x10,%esp
  8015c5:	39 c3                	cmp    %eax,%ebx
  8015c7:	0f 94 c1             	sete   %cl
  8015ca:	0f b6 c9             	movzbl %cl,%ecx
  8015cd:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  8015d0:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  8015d6:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8015d9:	39 ce                	cmp    %ecx,%esi
  8015db:	74 1b                	je     8015f8 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8015dd:	39 c3                	cmp    %eax,%ebx
  8015df:	75 c4                	jne    8015a5 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8015e1:	8b 42 58             	mov    0x58(%edx),%eax
  8015e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015e7:	50                   	push   %eax
  8015e8:	56                   	push   %esi
  8015e9:	68 b6 22 80 00       	push   $0x8022b6
  8015ee:	e8 26 ec ff ff       	call   800219 <cprintf>
  8015f3:	83 c4 10             	add    $0x10,%esp
  8015f6:	eb ad                	jmp    8015a5 <_pipeisclosed+0xe>
	}
}
  8015f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015fe:	5b                   	pop    %ebx
  8015ff:	5e                   	pop    %esi
  801600:	5f                   	pop    %edi
  801601:	5d                   	pop    %ebp
  801602:	c3                   	ret    

00801603 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	57                   	push   %edi
  801607:	56                   	push   %esi
  801608:	53                   	push   %ebx
  801609:	83 ec 28             	sub    $0x28,%esp
  80160c:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80160f:	56                   	push   %esi
  801610:	e8 ec f6 ff ff       	call   800d01 <fd2data>
  801615:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801617:	83 c4 10             	add    $0x10,%esp
  80161a:	bf 00 00 00 00       	mov    $0x0,%edi
  80161f:	eb 4b                	jmp    80166c <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801621:	89 da                	mov    %ebx,%edx
  801623:	89 f0                	mov    %esi,%eax
  801625:	e8 6d ff ff ff       	call   801597 <_pipeisclosed>
  80162a:	85 c0                	test   %eax,%eax
  80162c:	75 48                	jne    801676 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80162e:	e8 7a f5 ff ff       	call   800bad <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801633:	8b 43 04             	mov    0x4(%ebx),%eax
  801636:	8b 0b                	mov    (%ebx),%ecx
  801638:	8d 51 20             	lea    0x20(%ecx),%edx
  80163b:	39 d0                	cmp    %edx,%eax
  80163d:	73 e2                	jae    801621 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80163f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801642:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801646:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801649:	89 c2                	mov    %eax,%edx
  80164b:	c1 fa 1f             	sar    $0x1f,%edx
  80164e:	89 d1                	mov    %edx,%ecx
  801650:	c1 e9 1b             	shr    $0x1b,%ecx
  801653:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801656:	83 e2 1f             	and    $0x1f,%edx
  801659:	29 ca                	sub    %ecx,%edx
  80165b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80165f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801663:	83 c0 01             	add    $0x1,%eax
  801666:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801669:	83 c7 01             	add    $0x1,%edi
  80166c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80166f:	75 c2                	jne    801633 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801671:	8b 45 10             	mov    0x10(%ebp),%eax
  801674:	eb 05                	jmp    80167b <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801676:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80167b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80167e:	5b                   	pop    %ebx
  80167f:	5e                   	pop    %esi
  801680:	5f                   	pop    %edi
  801681:	5d                   	pop    %ebp
  801682:	c3                   	ret    

00801683 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	57                   	push   %edi
  801687:	56                   	push   %esi
  801688:	53                   	push   %ebx
  801689:	83 ec 18             	sub    $0x18,%esp
  80168c:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80168f:	57                   	push   %edi
  801690:	e8 6c f6 ff ff       	call   800d01 <fd2data>
  801695:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801697:	83 c4 10             	add    $0x10,%esp
  80169a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80169f:	eb 3d                	jmp    8016de <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8016a1:	85 db                	test   %ebx,%ebx
  8016a3:	74 04                	je     8016a9 <devpipe_read+0x26>
				return i;
  8016a5:	89 d8                	mov    %ebx,%eax
  8016a7:	eb 44                	jmp    8016ed <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8016a9:	89 f2                	mov    %esi,%edx
  8016ab:	89 f8                	mov    %edi,%eax
  8016ad:	e8 e5 fe ff ff       	call   801597 <_pipeisclosed>
  8016b2:	85 c0                	test   %eax,%eax
  8016b4:	75 32                	jne    8016e8 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8016b6:	e8 f2 f4 ff ff       	call   800bad <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8016bb:	8b 06                	mov    (%esi),%eax
  8016bd:	3b 46 04             	cmp    0x4(%esi),%eax
  8016c0:	74 df                	je     8016a1 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8016c2:	99                   	cltd   
  8016c3:	c1 ea 1b             	shr    $0x1b,%edx
  8016c6:	01 d0                	add    %edx,%eax
  8016c8:	83 e0 1f             	and    $0x1f,%eax
  8016cb:	29 d0                	sub    %edx,%eax
  8016cd:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  8016d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016d5:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  8016d8:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8016db:	83 c3 01             	add    $0x1,%ebx
  8016de:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8016e1:	75 d8                	jne    8016bb <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8016e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e6:	eb 05                	jmp    8016ed <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8016e8:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8016ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f0:	5b                   	pop    %ebx
  8016f1:	5e                   	pop    %esi
  8016f2:	5f                   	pop    %edi
  8016f3:	5d                   	pop    %ebp
  8016f4:	c3                   	ret    

008016f5 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	56                   	push   %esi
  8016f9:	53                   	push   %ebx
  8016fa:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8016fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801700:	50                   	push   %eax
  801701:	e8 13 f6 ff ff       	call   800d19 <fd_alloc>
  801706:	83 c4 10             	add    $0x10,%esp
  801709:	89 c2                	mov    %eax,%edx
  80170b:	85 c0                	test   %eax,%eax
  80170d:	0f 88 2c 01 00 00    	js     80183f <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801713:	83 ec 04             	sub    $0x4,%esp
  801716:	68 07 04 00 00       	push   $0x407
  80171b:	ff 75 f4             	pushl  -0xc(%ebp)
  80171e:	6a 00                	push   $0x0
  801720:	e8 af f4 ff ff       	call   800bd4 <sys_page_alloc>
  801725:	83 c4 10             	add    $0x10,%esp
  801728:	89 c2                	mov    %eax,%edx
  80172a:	85 c0                	test   %eax,%eax
  80172c:	0f 88 0d 01 00 00    	js     80183f <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801732:	83 ec 0c             	sub    $0xc,%esp
  801735:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801738:	50                   	push   %eax
  801739:	e8 db f5 ff ff       	call   800d19 <fd_alloc>
  80173e:	89 c3                	mov    %eax,%ebx
  801740:	83 c4 10             	add    $0x10,%esp
  801743:	85 c0                	test   %eax,%eax
  801745:	0f 88 e2 00 00 00    	js     80182d <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80174b:	83 ec 04             	sub    $0x4,%esp
  80174e:	68 07 04 00 00       	push   $0x407
  801753:	ff 75 f0             	pushl  -0x10(%ebp)
  801756:	6a 00                	push   $0x0
  801758:	e8 77 f4 ff ff       	call   800bd4 <sys_page_alloc>
  80175d:	89 c3                	mov    %eax,%ebx
  80175f:	83 c4 10             	add    $0x10,%esp
  801762:	85 c0                	test   %eax,%eax
  801764:	0f 88 c3 00 00 00    	js     80182d <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80176a:	83 ec 0c             	sub    $0xc,%esp
  80176d:	ff 75 f4             	pushl  -0xc(%ebp)
  801770:	e8 8c f5 ff ff       	call   800d01 <fd2data>
  801775:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801777:	83 c4 0c             	add    $0xc,%esp
  80177a:	68 07 04 00 00       	push   $0x407
  80177f:	50                   	push   %eax
  801780:	6a 00                	push   $0x0
  801782:	e8 4d f4 ff ff       	call   800bd4 <sys_page_alloc>
  801787:	89 c3                	mov    %eax,%ebx
  801789:	83 c4 10             	add    $0x10,%esp
  80178c:	85 c0                	test   %eax,%eax
  80178e:	0f 88 89 00 00 00    	js     80181d <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801794:	83 ec 0c             	sub    $0xc,%esp
  801797:	ff 75 f0             	pushl  -0x10(%ebp)
  80179a:	e8 62 f5 ff ff       	call   800d01 <fd2data>
  80179f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8017a6:	50                   	push   %eax
  8017a7:	6a 00                	push   $0x0
  8017a9:	56                   	push   %esi
  8017aa:	6a 00                	push   $0x0
  8017ac:	e8 47 f4 ff ff       	call   800bf8 <sys_page_map>
  8017b1:	89 c3                	mov    %eax,%ebx
  8017b3:	83 c4 20             	add    $0x20,%esp
  8017b6:	85 c0                	test   %eax,%eax
  8017b8:	78 55                	js     80180f <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8017ba:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8017c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c3:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8017c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8017cf:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8017d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d8:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8017da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017dd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8017e4:	83 ec 0c             	sub    $0xc,%esp
  8017e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ea:	e8 02 f5 ff ff       	call   800cf1 <fd2num>
  8017ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017f2:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8017f4:	83 c4 04             	add    $0x4,%esp
  8017f7:	ff 75 f0             	pushl  -0x10(%ebp)
  8017fa:	e8 f2 f4 ff ff       	call   800cf1 <fd2num>
  8017ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801802:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801805:	83 c4 10             	add    $0x10,%esp
  801808:	ba 00 00 00 00       	mov    $0x0,%edx
  80180d:	eb 30                	jmp    80183f <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  80180f:	83 ec 08             	sub    $0x8,%esp
  801812:	56                   	push   %esi
  801813:	6a 00                	push   $0x0
  801815:	e8 04 f4 ff ff       	call   800c1e <sys_page_unmap>
  80181a:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  80181d:	83 ec 08             	sub    $0x8,%esp
  801820:	ff 75 f0             	pushl  -0x10(%ebp)
  801823:	6a 00                	push   $0x0
  801825:	e8 f4 f3 ff ff       	call   800c1e <sys_page_unmap>
  80182a:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  80182d:	83 ec 08             	sub    $0x8,%esp
  801830:	ff 75 f4             	pushl  -0xc(%ebp)
  801833:	6a 00                	push   $0x0
  801835:	e8 e4 f3 ff ff       	call   800c1e <sys_page_unmap>
  80183a:	83 c4 10             	add    $0x10,%esp
  80183d:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  80183f:	89 d0                	mov    %edx,%eax
  801841:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801844:	5b                   	pop    %ebx
  801845:	5e                   	pop    %esi
  801846:	5d                   	pop    %ebp
  801847:	c3                   	ret    

00801848 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80184e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801851:	50                   	push   %eax
  801852:	ff 75 08             	pushl  0x8(%ebp)
  801855:	e8 0e f5 ff ff       	call   800d68 <fd_lookup>
  80185a:	83 c4 10             	add    $0x10,%esp
  80185d:	85 c0                	test   %eax,%eax
  80185f:	78 18                	js     801879 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801861:	83 ec 0c             	sub    $0xc,%esp
  801864:	ff 75 f4             	pushl  -0xc(%ebp)
  801867:	e8 95 f4 ff ff       	call   800d01 <fd2data>
	return _pipeisclosed(fd, p);
  80186c:	89 c2                	mov    %eax,%edx
  80186e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801871:	e8 21 fd ff ff       	call   801597 <_pipeisclosed>
  801876:	83 c4 10             	add    $0x10,%esp
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80187e:	b8 00 00 00 00       	mov    $0x0,%eax
  801883:	5d                   	pop    %ebp
  801884:	c3                   	ret    

00801885 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80188b:	68 ce 22 80 00       	push   $0x8022ce
  801890:	ff 75 0c             	pushl  0xc(%ebp)
  801893:	e8 f3 ee ff ff       	call   80078b <strcpy>
	return 0;
}
  801898:	b8 00 00 00 00       	mov    $0x0,%eax
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
  8018a2:	57                   	push   %edi
  8018a3:	56                   	push   %esi
  8018a4:	53                   	push   %ebx
  8018a5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8018ab:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8018b0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8018b6:	eb 2d                	jmp    8018e5 <devcons_write+0x46>
		m = n - tot;
  8018b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8018bb:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  8018bd:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8018c0:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8018c5:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8018c8:	83 ec 04             	sub    $0x4,%esp
  8018cb:	53                   	push   %ebx
  8018cc:	03 45 0c             	add    0xc(%ebp),%eax
  8018cf:	50                   	push   %eax
  8018d0:	57                   	push   %edi
  8018d1:	e8 48 f0 ff ff       	call   80091e <memmove>
		sys_cputs(buf, m);
  8018d6:	83 c4 08             	add    $0x8,%esp
  8018d9:	53                   	push   %ebx
  8018da:	57                   	push   %edi
  8018db:	e8 3d f2 ff ff       	call   800b1d <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8018e0:	01 de                	add    %ebx,%esi
  8018e2:	83 c4 10             	add    $0x10,%esp
  8018e5:	89 f0                	mov    %esi,%eax
  8018e7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8018ea:	72 cc                	jb     8018b8 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8018ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018ef:	5b                   	pop    %ebx
  8018f0:	5e                   	pop    %esi
  8018f1:	5f                   	pop    %edi
  8018f2:	5d                   	pop    %ebp
  8018f3:	c3                   	ret    

008018f4 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	83 ec 08             	sub    $0x8,%esp
  8018fa:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  8018ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801903:	74 2a                	je     80192f <devcons_read+0x3b>
  801905:	eb 05                	jmp    80190c <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801907:	e8 a1 f2 ff ff       	call   800bad <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80190c:	e8 32 f2 ff ff       	call   800b43 <sys_cgetc>
  801911:	85 c0                	test   %eax,%eax
  801913:	74 f2                	je     801907 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801915:	85 c0                	test   %eax,%eax
  801917:	78 16                	js     80192f <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801919:	83 f8 04             	cmp    $0x4,%eax
  80191c:	74 0c                	je     80192a <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80191e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801921:	88 02                	mov    %al,(%edx)
	return 1;
  801923:	b8 01 00 00 00       	mov    $0x1,%eax
  801928:	eb 05                	jmp    80192f <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80192a:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801937:	8b 45 08             	mov    0x8(%ebp),%eax
  80193a:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80193d:	6a 01                	push   $0x1
  80193f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801942:	50                   	push   %eax
  801943:	e8 d5 f1 ff ff       	call   800b1d <sys_cputs>
}
  801948:	83 c4 10             	add    $0x10,%esp
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <getchar>:

int
getchar(void)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801953:	6a 01                	push   $0x1
  801955:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801958:	50                   	push   %eax
  801959:	6a 00                	push   $0x0
  80195b:	e8 6d f6 ff ff       	call   800fcd <read>
	if (r < 0)
  801960:	83 c4 10             	add    $0x10,%esp
  801963:	85 c0                	test   %eax,%eax
  801965:	78 0f                	js     801976 <getchar+0x29>
		return r;
	if (r < 1)
  801967:	85 c0                	test   %eax,%eax
  801969:	7e 06                	jle    801971 <getchar+0x24>
		return -E_EOF;
	return c;
  80196b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  80196f:	eb 05                	jmp    801976 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801971:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80197e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801981:	50                   	push   %eax
  801982:	ff 75 08             	pushl  0x8(%ebp)
  801985:	e8 de f3 ff ff       	call   800d68 <fd_lookup>
  80198a:	83 c4 10             	add    $0x10,%esp
  80198d:	85 c0                	test   %eax,%eax
  80198f:	78 11                	js     8019a2 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801994:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80199a:	39 10                	cmp    %edx,(%eax)
  80199c:	0f 94 c0             	sete   %al
  80199f:	0f b6 c0             	movzbl %al,%eax
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <opencons>:

int
opencons(void)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
  8019a7:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8019aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ad:	50                   	push   %eax
  8019ae:	e8 66 f3 ff ff       	call   800d19 <fd_alloc>
  8019b3:	83 c4 10             	add    $0x10,%esp
		return r;
  8019b6:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8019b8:	85 c0                	test   %eax,%eax
  8019ba:	78 3e                	js     8019fa <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8019bc:	83 ec 04             	sub    $0x4,%esp
  8019bf:	68 07 04 00 00       	push   $0x407
  8019c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8019c7:	6a 00                	push   $0x0
  8019c9:	e8 06 f2 ff ff       	call   800bd4 <sys_page_alloc>
  8019ce:	83 c4 10             	add    $0x10,%esp
		return r;
  8019d1:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8019d3:	85 c0                	test   %eax,%eax
  8019d5:	78 23                	js     8019fa <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8019d7:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8019dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8019e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8019ec:	83 ec 0c             	sub    $0xc,%esp
  8019ef:	50                   	push   %eax
  8019f0:	e8 fc f2 ff ff       	call   800cf1 <fd2num>
  8019f5:	89 c2                	mov    %eax,%edx
  8019f7:	83 c4 10             	add    $0x10,%esp
}
  8019fa:	89 d0                	mov    %edx,%eax
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	56                   	push   %esi
  801a02:	53                   	push   %ebx
  801a03:	8b 75 08             	mov    0x8(%ebp),%esi
  801a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a09:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801a0c:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801a0e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801a13:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801a16:	83 ec 0c             	sub    $0xc,%esp
  801a19:	50                   	push   %eax
  801a1a:	e8 b0 f2 ff ff       	call   800ccf <sys_ipc_recv>
	if (from_env_store)
  801a1f:	83 c4 10             	add    $0x10,%esp
  801a22:	85 f6                	test   %esi,%esi
  801a24:	74 0b                	je     801a31 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801a26:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  801a2c:	8b 52 74             	mov    0x74(%edx),%edx
  801a2f:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801a31:	85 db                	test   %ebx,%ebx
  801a33:	74 0b                	je     801a40 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  801a35:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  801a3b:	8b 52 78             	mov    0x78(%edx),%edx
  801a3e:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  801a40:	85 c0                	test   %eax,%eax
  801a42:	79 16                	jns    801a5a <ipc_recv+0x5c>
		if (from_env_store)
  801a44:	85 f6                	test   %esi,%esi
  801a46:	74 06                	je     801a4e <ipc_recv+0x50>
			*from_env_store = 0;
  801a48:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  801a4e:	85 db                	test   %ebx,%ebx
  801a50:	74 10                	je     801a62 <ipc_recv+0x64>
			*perm_store = 0;
  801a52:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801a58:	eb 08                	jmp    801a62 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  801a5a:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801a5f:	8b 40 70             	mov    0x70(%eax),%eax
}
  801a62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a65:	5b                   	pop    %ebx
  801a66:	5e                   	pop    %esi
  801a67:	5d                   	pop    %ebp
  801a68:	c3                   	ret    

00801a69 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	57                   	push   %edi
  801a6d:	56                   	push   %esi
  801a6e:	53                   	push   %ebx
  801a6f:	83 ec 0c             	sub    $0xc,%esp
  801a72:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a75:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a78:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  801a7b:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  801a7d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801a82:	0f 44 d8             	cmove  %eax,%ebx
  801a85:	eb 1c                	jmp    801aa3 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  801a87:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801a8a:	74 12                	je     801a9e <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801a8c:	50                   	push   %eax
  801a8d:	68 da 22 80 00       	push   $0x8022da
  801a92:	6a 42                	push   $0x42
  801a94:	68 f0 22 80 00       	push   $0x8022f0
  801a99:	e8 a2 e6 ff ff       	call   800140 <_panic>
		sys_yield();
  801a9e:	e8 0a f1 ff ff       	call   800bad <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801aa3:	ff 75 14             	pushl  0x14(%ebp)
  801aa6:	53                   	push   %ebx
  801aa7:	56                   	push   %esi
  801aa8:	57                   	push   %edi
  801aa9:	e8 fc f1 ff ff       	call   800caa <sys_ipc_try_send>
  801aae:	83 c4 10             	add    $0x10,%esp
  801ab1:	85 c0                	test   %eax,%eax
  801ab3:	75 d2                	jne    801a87 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801ab5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ab8:	5b                   	pop    %ebx
  801ab9:	5e                   	pop    %esi
  801aba:	5f                   	pop    %edi
  801abb:	5d                   	pop    %ebp
  801abc:	c3                   	ret    

00801abd <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801ac3:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801ac8:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801acb:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801ad1:	8b 52 50             	mov    0x50(%edx),%edx
  801ad4:	39 ca                	cmp    %ecx,%edx
  801ad6:	75 0d                	jne    801ae5 <ipc_find_env+0x28>
			return envs[i].env_id;
  801ad8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801adb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801ae0:	8b 40 48             	mov    0x48(%eax),%eax
  801ae3:	eb 0f                	jmp    801af4 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801ae5:	83 c0 01             	add    $0x1,%eax
  801ae8:	3d 00 04 00 00       	cmp    $0x400,%eax
  801aed:	75 d9                	jne    801ac8 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801aef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801af4:	5d                   	pop    %ebp
  801af5:	c3                   	ret    

00801af6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801afc:	89 d0                	mov    %edx,%eax
  801afe:	c1 e8 16             	shr    $0x16,%eax
  801b01:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801b08:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b0d:	f6 c1 01             	test   $0x1,%cl
  801b10:	74 1d                	je     801b2f <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801b12:	c1 ea 0c             	shr    $0xc,%edx
  801b15:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801b1c:	f6 c2 01             	test   $0x1,%dl
  801b1f:	74 0e                	je     801b2f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801b21:	c1 ea 0c             	shr    $0xc,%edx
  801b24:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801b2b:	ef 
  801b2c:	0f b7 c0             	movzwl %ax,%eax
}
  801b2f:	5d                   	pop    %ebp
  801b30:	c3                   	ret    
  801b31:	66 90                	xchg   %ax,%ax
  801b33:	66 90                	xchg   %ax,%ax
  801b35:	66 90                	xchg   %ax,%ax
  801b37:	66 90                	xchg   %ax,%ax
  801b39:	66 90                	xchg   %ax,%ax
  801b3b:	66 90                	xchg   %ax,%ax
  801b3d:	66 90                	xchg   %ax,%ax
  801b3f:	90                   	nop

00801b40 <__udivdi3>:
  801b40:	55                   	push   %ebp
  801b41:	57                   	push   %edi
  801b42:	56                   	push   %esi
  801b43:	53                   	push   %ebx
  801b44:	83 ec 1c             	sub    $0x1c,%esp
  801b47:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b4b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b4f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b57:	85 f6                	test   %esi,%esi
  801b59:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b5d:	89 ca                	mov    %ecx,%edx
  801b5f:	89 f8                	mov    %edi,%eax
  801b61:	75 3d                	jne    801ba0 <__udivdi3+0x60>
  801b63:	39 cf                	cmp    %ecx,%edi
  801b65:	0f 87 c5 00 00 00    	ja     801c30 <__udivdi3+0xf0>
  801b6b:	85 ff                	test   %edi,%edi
  801b6d:	89 fd                	mov    %edi,%ebp
  801b6f:	75 0b                	jne    801b7c <__udivdi3+0x3c>
  801b71:	b8 01 00 00 00       	mov    $0x1,%eax
  801b76:	31 d2                	xor    %edx,%edx
  801b78:	f7 f7                	div    %edi
  801b7a:	89 c5                	mov    %eax,%ebp
  801b7c:	89 c8                	mov    %ecx,%eax
  801b7e:	31 d2                	xor    %edx,%edx
  801b80:	f7 f5                	div    %ebp
  801b82:	89 c1                	mov    %eax,%ecx
  801b84:	89 d8                	mov    %ebx,%eax
  801b86:	89 cf                	mov    %ecx,%edi
  801b88:	f7 f5                	div    %ebp
  801b8a:	89 c3                	mov    %eax,%ebx
  801b8c:	89 d8                	mov    %ebx,%eax
  801b8e:	89 fa                	mov    %edi,%edx
  801b90:	83 c4 1c             	add    $0x1c,%esp
  801b93:	5b                   	pop    %ebx
  801b94:	5e                   	pop    %esi
  801b95:	5f                   	pop    %edi
  801b96:	5d                   	pop    %ebp
  801b97:	c3                   	ret    
  801b98:	90                   	nop
  801b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ba0:	39 ce                	cmp    %ecx,%esi
  801ba2:	77 74                	ja     801c18 <__udivdi3+0xd8>
  801ba4:	0f bd fe             	bsr    %esi,%edi
  801ba7:	83 f7 1f             	xor    $0x1f,%edi
  801baa:	0f 84 98 00 00 00    	je     801c48 <__udivdi3+0x108>
  801bb0:	bb 20 00 00 00       	mov    $0x20,%ebx
  801bb5:	89 f9                	mov    %edi,%ecx
  801bb7:	89 c5                	mov    %eax,%ebp
  801bb9:	29 fb                	sub    %edi,%ebx
  801bbb:	d3 e6                	shl    %cl,%esi
  801bbd:	89 d9                	mov    %ebx,%ecx
  801bbf:	d3 ed                	shr    %cl,%ebp
  801bc1:	89 f9                	mov    %edi,%ecx
  801bc3:	d3 e0                	shl    %cl,%eax
  801bc5:	09 ee                	or     %ebp,%esi
  801bc7:	89 d9                	mov    %ebx,%ecx
  801bc9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bcd:	89 d5                	mov    %edx,%ebp
  801bcf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bd3:	d3 ed                	shr    %cl,%ebp
  801bd5:	89 f9                	mov    %edi,%ecx
  801bd7:	d3 e2                	shl    %cl,%edx
  801bd9:	89 d9                	mov    %ebx,%ecx
  801bdb:	d3 e8                	shr    %cl,%eax
  801bdd:	09 c2                	or     %eax,%edx
  801bdf:	89 d0                	mov    %edx,%eax
  801be1:	89 ea                	mov    %ebp,%edx
  801be3:	f7 f6                	div    %esi
  801be5:	89 d5                	mov    %edx,%ebp
  801be7:	89 c3                	mov    %eax,%ebx
  801be9:	f7 64 24 0c          	mull   0xc(%esp)
  801bed:	39 d5                	cmp    %edx,%ebp
  801bef:	72 10                	jb     801c01 <__udivdi3+0xc1>
  801bf1:	8b 74 24 08          	mov    0x8(%esp),%esi
  801bf5:	89 f9                	mov    %edi,%ecx
  801bf7:	d3 e6                	shl    %cl,%esi
  801bf9:	39 c6                	cmp    %eax,%esi
  801bfb:	73 07                	jae    801c04 <__udivdi3+0xc4>
  801bfd:	39 d5                	cmp    %edx,%ebp
  801bff:	75 03                	jne    801c04 <__udivdi3+0xc4>
  801c01:	83 eb 01             	sub    $0x1,%ebx
  801c04:	31 ff                	xor    %edi,%edi
  801c06:	89 d8                	mov    %ebx,%eax
  801c08:	89 fa                	mov    %edi,%edx
  801c0a:	83 c4 1c             	add    $0x1c,%esp
  801c0d:	5b                   	pop    %ebx
  801c0e:	5e                   	pop    %esi
  801c0f:	5f                   	pop    %edi
  801c10:	5d                   	pop    %ebp
  801c11:	c3                   	ret    
  801c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c18:	31 ff                	xor    %edi,%edi
  801c1a:	31 db                	xor    %ebx,%ebx
  801c1c:	89 d8                	mov    %ebx,%eax
  801c1e:	89 fa                	mov    %edi,%edx
  801c20:	83 c4 1c             	add    $0x1c,%esp
  801c23:	5b                   	pop    %ebx
  801c24:	5e                   	pop    %esi
  801c25:	5f                   	pop    %edi
  801c26:	5d                   	pop    %ebp
  801c27:	c3                   	ret    
  801c28:	90                   	nop
  801c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c30:	89 d8                	mov    %ebx,%eax
  801c32:	f7 f7                	div    %edi
  801c34:	31 ff                	xor    %edi,%edi
  801c36:	89 c3                	mov    %eax,%ebx
  801c38:	89 d8                	mov    %ebx,%eax
  801c3a:	89 fa                	mov    %edi,%edx
  801c3c:	83 c4 1c             	add    $0x1c,%esp
  801c3f:	5b                   	pop    %ebx
  801c40:	5e                   	pop    %esi
  801c41:	5f                   	pop    %edi
  801c42:	5d                   	pop    %ebp
  801c43:	c3                   	ret    
  801c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801c48:	39 ce                	cmp    %ecx,%esi
  801c4a:	72 0c                	jb     801c58 <__udivdi3+0x118>
  801c4c:	31 db                	xor    %ebx,%ebx
  801c4e:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c52:	0f 87 34 ff ff ff    	ja     801b8c <__udivdi3+0x4c>
  801c58:	bb 01 00 00 00       	mov    $0x1,%ebx
  801c5d:	e9 2a ff ff ff       	jmp    801b8c <__udivdi3+0x4c>
  801c62:	66 90                	xchg   %ax,%ax
  801c64:	66 90                	xchg   %ax,%ax
  801c66:	66 90                	xchg   %ax,%ax
  801c68:	66 90                	xchg   %ax,%ax
  801c6a:	66 90                	xchg   %ax,%ax
  801c6c:	66 90                	xchg   %ax,%ax
  801c6e:	66 90                	xchg   %ax,%ax

00801c70 <__umoddi3>:
  801c70:	55                   	push   %ebp
  801c71:	57                   	push   %edi
  801c72:	56                   	push   %esi
  801c73:	53                   	push   %ebx
  801c74:	83 ec 1c             	sub    $0x1c,%esp
  801c77:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801c7b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c87:	85 d2                	test   %edx,%edx
  801c89:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c91:	89 f3                	mov    %esi,%ebx
  801c93:	89 3c 24             	mov    %edi,(%esp)
  801c96:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c9a:	75 1c                	jne    801cb8 <__umoddi3+0x48>
  801c9c:	39 f7                	cmp    %esi,%edi
  801c9e:	76 50                	jbe    801cf0 <__umoddi3+0x80>
  801ca0:	89 c8                	mov    %ecx,%eax
  801ca2:	89 f2                	mov    %esi,%edx
  801ca4:	f7 f7                	div    %edi
  801ca6:	89 d0                	mov    %edx,%eax
  801ca8:	31 d2                	xor    %edx,%edx
  801caa:	83 c4 1c             	add    $0x1c,%esp
  801cad:	5b                   	pop    %ebx
  801cae:	5e                   	pop    %esi
  801caf:	5f                   	pop    %edi
  801cb0:	5d                   	pop    %ebp
  801cb1:	c3                   	ret    
  801cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801cb8:	39 f2                	cmp    %esi,%edx
  801cba:	89 d0                	mov    %edx,%eax
  801cbc:	77 52                	ja     801d10 <__umoddi3+0xa0>
  801cbe:	0f bd ea             	bsr    %edx,%ebp
  801cc1:	83 f5 1f             	xor    $0x1f,%ebp
  801cc4:	75 5a                	jne    801d20 <__umoddi3+0xb0>
  801cc6:	3b 54 24 04          	cmp    0x4(%esp),%edx
  801cca:	0f 82 e0 00 00 00    	jb     801db0 <__umoddi3+0x140>
  801cd0:	39 0c 24             	cmp    %ecx,(%esp)
  801cd3:	0f 86 d7 00 00 00    	jbe    801db0 <__umoddi3+0x140>
  801cd9:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cdd:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ce1:	83 c4 1c             	add    $0x1c,%esp
  801ce4:	5b                   	pop    %ebx
  801ce5:	5e                   	pop    %esi
  801ce6:	5f                   	pop    %edi
  801ce7:	5d                   	pop    %ebp
  801ce8:	c3                   	ret    
  801ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801cf0:	85 ff                	test   %edi,%edi
  801cf2:	89 fd                	mov    %edi,%ebp
  801cf4:	75 0b                	jne    801d01 <__umoddi3+0x91>
  801cf6:	b8 01 00 00 00       	mov    $0x1,%eax
  801cfb:	31 d2                	xor    %edx,%edx
  801cfd:	f7 f7                	div    %edi
  801cff:	89 c5                	mov    %eax,%ebp
  801d01:	89 f0                	mov    %esi,%eax
  801d03:	31 d2                	xor    %edx,%edx
  801d05:	f7 f5                	div    %ebp
  801d07:	89 c8                	mov    %ecx,%eax
  801d09:	f7 f5                	div    %ebp
  801d0b:	89 d0                	mov    %edx,%eax
  801d0d:	eb 99                	jmp    801ca8 <__umoddi3+0x38>
  801d0f:	90                   	nop
  801d10:	89 c8                	mov    %ecx,%eax
  801d12:	89 f2                	mov    %esi,%edx
  801d14:	83 c4 1c             	add    $0x1c,%esp
  801d17:	5b                   	pop    %ebx
  801d18:	5e                   	pop    %esi
  801d19:	5f                   	pop    %edi
  801d1a:	5d                   	pop    %ebp
  801d1b:	c3                   	ret    
  801d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801d20:	8b 34 24             	mov    (%esp),%esi
  801d23:	bf 20 00 00 00       	mov    $0x20,%edi
  801d28:	89 e9                	mov    %ebp,%ecx
  801d2a:	29 ef                	sub    %ebp,%edi
  801d2c:	d3 e0                	shl    %cl,%eax
  801d2e:	89 f9                	mov    %edi,%ecx
  801d30:	89 f2                	mov    %esi,%edx
  801d32:	d3 ea                	shr    %cl,%edx
  801d34:	89 e9                	mov    %ebp,%ecx
  801d36:	09 c2                	or     %eax,%edx
  801d38:	89 d8                	mov    %ebx,%eax
  801d3a:	89 14 24             	mov    %edx,(%esp)
  801d3d:	89 f2                	mov    %esi,%edx
  801d3f:	d3 e2                	shl    %cl,%edx
  801d41:	89 f9                	mov    %edi,%ecx
  801d43:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d47:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801d4b:	d3 e8                	shr    %cl,%eax
  801d4d:	89 e9                	mov    %ebp,%ecx
  801d4f:	89 c6                	mov    %eax,%esi
  801d51:	d3 e3                	shl    %cl,%ebx
  801d53:	89 f9                	mov    %edi,%ecx
  801d55:	89 d0                	mov    %edx,%eax
  801d57:	d3 e8                	shr    %cl,%eax
  801d59:	89 e9                	mov    %ebp,%ecx
  801d5b:	09 d8                	or     %ebx,%eax
  801d5d:	89 d3                	mov    %edx,%ebx
  801d5f:	89 f2                	mov    %esi,%edx
  801d61:	f7 34 24             	divl   (%esp)
  801d64:	89 d6                	mov    %edx,%esi
  801d66:	d3 e3                	shl    %cl,%ebx
  801d68:	f7 64 24 04          	mull   0x4(%esp)
  801d6c:	39 d6                	cmp    %edx,%esi
  801d6e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d72:	89 d1                	mov    %edx,%ecx
  801d74:	89 c3                	mov    %eax,%ebx
  801d76:	72 08                	jb     801d80 <__umoddi3+0x110>
  801d78:	75 11                	jne    801d8b <__umoddi3+0x11b>
  801d7a:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801d7e:	73 0b                	jae    801d8b <__umoddi3+0x11b>
  801d80:	2b 44 24 04          	sub    0x4(%esp),%eax
  801d84:	1b 14 24             	sbb    (%esp),%edx
  801d87:	89 d1                	mov    %edx,%ecx
  801d89:	89 c3                	mov    %eax,%ebx
  801d8b:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d8f:	29 da                	sub    %ebx,%edx
  801d91:	19 ce                	sbb    %ecx,%esi
  801d93:	89 f9                	mov    %edi,%ecx
  801d95:	89 f0                	mov    %esi,%eax
  801d97:	d3 e0                	shl    %cl,%eax
  801d99:	89 e9                	mov    %ebp,%ecx
  801d9b:	d3 ea                	shr    %cl,%edx
  801d9d:	89 e9                	mov    %ebp,%ecx
  801d9f:	d3 ee                	shr    %cl,%esi
  801da1:	09 d0                	or     %edx,%eax
  801da3:	89 f2                	mov    %esi,%edx
  801da5:	83 c4 1c             	add    $0x1c,%esp
  801da8:	5b                   	pop    %ebx
  801da9:	5e                   	pop    %esi
  801daa:	5f                   	pop    %edi
  801dab:	5d                   	pop    %ebp
  801dac:	c3                   	ret    
  801dad:	8d 76 00             	lea    0x0(%esi),%esi
  801db0:	29 f9                	sub    %edi,%ecx
  801db2:	19 d6                	sbb    %edx,%esi
  801db4:	89 74 24 04          	mov    %esi,0x4(%esp)
  801db8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801dbc:	e9 18 ff ff ff       	jmp    801cd9 <__umoddi3+0x69>
