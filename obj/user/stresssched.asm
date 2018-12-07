
obj/user/stresssched.debug:     formato del fichero elf32-i386


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
  80002c:	e8 bc 00 00 00       	call   8000ed <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800038:	e8 5d 0b 00 00       	call   800b9a <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  80003f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800044:	e8 43 10 00 00       	call   80108c <fork>
  800049:	85 c0                	test   %eax,%eax
  80004b:	74 0a                	je     800057 <umain+0x24>
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();

	// Fork several environments
	for (i = 0; i < 20; i++)
  80004d:	83 c3 01             	add    $0x1,%ebx
  800050:	83 fb 14             	cmp    $0x14,%ebx
  800053:	75 ef                	jne    800044 <umain+0x11>
  800055:	eb 05                	jmp    80005c <umain+0x29>
		if (fork() == 0)
			break;
	if (i == 20) {
  800057:	83 fb 14             	cmp    $0x14,%ebx
  80005a:	75 0e                	jne    80006a <umain+0x37>
		sys_yield();
  80005c:	e8 5d 0b 00 00       	call   800bbe <sys_yield>
		return;
  800061:	e9 80 00 00 00       	jmp    8000e6 <umain+0xb3>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");
  800066:	f3 90                	pause  
  800068:	eb 0f                	jmp    800079 <umain+0x46>
		sys_yield();
		return;
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80006a:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  800070:	6b d6 7c             	imul   $0x7c,%esi,%edx
  800073:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800079:	8b 42 54             	mov    0x54(%edx),%eax
  80007c:	85 c0                	test   %eax,%eax
  80007e:	75 e6                	jne    800066 <umain+0x33>
  800080:	bb 0a 00 00 00       	mov    $0xa,%ebx
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  800085:	e8 34 0b 00 00       	call   800bbe <sys_yield>
  80008a:	ba 10 27 00 00       	mov    $0x2710,%edx
		for (j = 0; j < 10000; j++)
			counter++;
  80008f:	a1 04 40 80 00       	mov    0x804004,%eax
  800094:	83 c0 01             	add    $0x1,%eax
  800097:	a3 04 40 80 00       	mov    %eax,0x804004
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
		for (j = 0; j < 10000; j++)
  80009c:	83 ea 01             	sub    $0x1,%edx
  80009f:	75 ee                	jne    80008f <umain+0x5c>
	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
  8000a1:	83 eb 01             	sub    $0x1,%ebx
  8000a4:	75 df                	jne    800085 <umain+0x52>
		sys_yield();
		for (j = 0; j < 10000; j++)
			counter++;
	}

	if (counter != 10*10000)
  8000a6:	a1 04 40 80 00       	mov    0x804004,%eax
  8000ab:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000b0:	74 17                	je     8000c9 <umain+0x96>
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000b2:	a1 04 40 80 00       	mov    0x804004,%eax
  8000b7:	50                   	push   %eax
  8000b8:	68 20 23 80 00       	push   $0x802320
  8000bd:	6a 21                	push   $0x21
  8000bf:	68 48 23 80 00       	push   $0x802348
  8000c4:	e8 88 00 00 00       	call   800151 <_panic>

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000c9:	a1 08 40 80 00       	mov    0x804008,%eax
  8000ce:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000d1:	8b 40 48             	mov    0x48(%eax),%eax
  8000d4:	83 ec 04             	sub    $0x4,%esp
  8000d7:	52                   	push   %edx
  8000d8:	50                   	push   %eax
  8000d9:	68 5b 23 80 00       	push   $0x80235b
  8000de:	e8 47 01 00 00       	call   80022a <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp

}
  8000e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000e9:	5b                   	pop    %ebx
  8000ea:	5e                   	pop    %esi
  8000eb:	5d                   	pop    %ebp
  8000ec:	c3                   	ret    

008000ed <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000ed:	55                   	push   %ebp
  8000ee:	89 e5                	mov    %esp,%ebp
  8000f0:	56                   	push   %esi
  8000f1:	53                   	push   %ebx
  8000f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000f5:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8000f8:	e8 9d 0a 00 00       	call   800b9a <sys_getenvid>
	if (id >= 0)
  8000fd:	85 c0                	test   %eax,%eax
  8000ff:	78 12                	js     800113 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  800101:	25 ff 03 00 00       	and    $0x3ff,%eax
  800106:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800109:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80010e:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800113:	85 db                	test   %ebx,%ebx
  800115:	7e 07                	jle    80011e <libmain+0x31>
		binaryname = argv[0];
  800117:	8b 06                	mov    (%esi),%eax
  800119:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80011e:	83 ec 08             	sub    $0x8,%esp
  800121:	56                   	push   %esi
  800122:	53                   	push   %ebx
  800123:	e8 0b ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800128:	e8 0a 00 00 00       	call   800137 <exit>
}
  80012d:	83 c4 10             	add    $0x10,%esp
  800130:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800133:	5b                   	pop    %ebx
  800134:	5e                   	pop    %esi
  800135:	5d                   	pop    %ebp
  800136:	c3                   	ret    

00800137 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800137:	55                   	push   %ebp
  800138:	89 e5                	mov    %esp,%ebp
  80013a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80013d:	e8 42 12 00 00       	call   801384 <close_all>
	sys_env_destroy(0);
  800142:	83 ec 0c             	sub    $0xc,%esp
  800145:	6a 00                	push   $0x0
  800147:	e8 2c 0a 00 00       	call   800b78 <sys_env_destroy>
}
  80014c:	83 c4 10             	add    $0x10,%esp
  80014f:	c9                   	leave  
  800150:	c3                   	ret    

00800151 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800151:	55                   	push   %ebp
  800152:	89 e5                	mov    %esp,%ebp
  800154:	56                   	push   %esi
  800155:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800156:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800159:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80015f:	e8 36 0a 00 00       	call   800b9a <sys_getenvid>
  800164:	83 ec 0c             	sub    $0xc,%esp
  800167:	ff 75 0c             	pushl  0xc(%ebp)
  80016a:	ff 75 08             	pushl  0x8(%ebp)
  80016d:	56                   	push   %esi
  80016e:	50                   	push   %eax
  80016f:	68 84 23 80 00       	push   $0x802384
  800174:	e8 b1 00 00 00       	call   80022a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800179:	83 c4 18             	add    $0x18,%esp
  80017c:	53                   	push   %ebx
  80017d:	ff 75 10             	pushl  0x10(%ebp)
  800180:	e8 54 00 00 00       	call   8001d9 <vcprintf>
	cprintf("\n");
  800185:	c7 04 24 77 23 80 00 	movl   $0x802377,(%esp)
  80018c:	e8 99 00 00 00       	call   80022a <cprintf>
  800191:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800194:	cc                   	int3   
  800195:	eb fd                	jmp    800194 <_panic+0x43>

00800197 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	53                   	push   %ebx
  80019b:	83 ec 04             	sub    $0x4,%esp
  80019e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a1:	8b 13                	mov    (%ebx),%edx
  8001a3:	8d 42 01             	lea    0x1(%edx),%eax
  8001a6:	89 03                	mov    %eax,(%ebx)
  8001a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ab:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001af:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b4:	75 1a                	jne    8001d0 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  8001b6:	83 ec 08             	sub    $0x8,%esp
  8001b9:	68 ff 00 00 00       	push   $0xff
  8001be:	8d 43 08             	lea    0x8(%ebx),%eax
  8001c1:	50                   	push   %eax
  8001c2:	e8 67 09 00 00       	call   800b2e <sys_cputs>
		b->idx = 0;
  8001c7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001cd:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  8001d0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001d7:	c9                   	leave  
  8001d8:	c3                   	ret    

008001d9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001d9:	55                   	push   %ebp
  8001da:	89 e5                	mov    %esp,%ebp
  8001dc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001e9:	00 00 00 
	b.cnt = 0;
  8001ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001f3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001f6:	ff 75 0c             	pushl  0xc(%ebp)
  8001f9:	ff 75 08             	pushl  0x8(%ebp)
  8001fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800202:	50                   	push   %eax
  800203:	68 97 01 80 00       	push   $0x800197
  800208:	e8 86 01 00 00       	call   800393 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80020d:	83 c4 08             	add    $0x8,%esp
  800210:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800216:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80021c:	50                   	push   %eax
  80021d:	e8 0c 09 00 00       	call   800b2e <sys_cputs>

	return b.cnt;
}
  800222:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800228:	c9                   	leave  
  800229:	c3                   	ret    

0080022a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80022a:	55                   	push   %ebp
  80022b:	89 e5                	mov    %esp,%ebp
  80022d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800230:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800233:	50                   	push   %eax
  800234:	ff 75 08             	pushl  0x8(%ebp)
  800237:	e8 9d ff ff ff       	call   8001d9 <vcprintf>
	va_end(ap);

	return cnt;
}
  80023c:	c9                   	leave  
  80023d:	c3                   	ret    

0080023e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80023e:	55                   	push   %ebp
  80023f:	89 e5                	mov    %esp,%ebp
  800241:	57                   	push   %edi
  800242:	56                   	push   %esi
  800243:	53                   	push   %ebx
  800244:	83 ec 1c             	sub    $0x1c,%esp
  800247:	89 c7                	mov    %eax,%edi
  800249:	89 d6                	mov    %edx,%esi
  80024b:	8b 45 08             	mov    0x8(%ebp),%eax
  80024e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800251:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800254:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800257:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80025a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80025f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800262:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800265:	39 d3                	cmp    %edx,%ebx
  800267:	72 05                	jb     80026e <printnum+0x30>
  800269:	39 45 10             	cmp    %eax,0x10(%ebp)
  80026c:	77 45                	ja     8002b3 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80026e:	83 ec 0c             	sub    $0xc,%esp
  800271:	ff 75 18             	pushl  0x18(%ebp)
  800274:	8b 45 14             	mov    0x14(%ebp),%eax
  800277:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80027a:	53                   	push   %ebx
  80027b:	ff 75 10             	pushl  0x10(%ebp)
  80027e:	83 ec 08             	sub    $0x8,%esp
  800281:	ff 75 e4             	pushl  -0x1c(%ebp)
  800284:	ff 75 e0             	pushl  -0x20(%ebp)
  800287:	ff 75 dc             	pushl  -0x24(%ebp)
  80028a:	ff 75 d8             	pushl  -0x28(%ebp)
  80028d:	e8 fe 1d 00 00       	call   802090 <__udivdi3>
  800292:	83 c4 18             	add    $0x18,%esp
  800295:	52                   	push   %edx
  800296:	50                   	push   %eax
  800297:	89 f2                	mov    %esi,%edx
  800299:	89 f8                	mov    %edi,%eax
  80029b:	e8 9e ff ff ff       	call   80023e <printnum>
  8002a0:	83 c4 20             	add    $0x20,%esp
  8002a3:	eb 18                	jmp    8002bd <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	56                   	push   %esi
  8002a9:	ff 75 18             	pushl  0x18(%ebp)
  8002ac:	ff d7                	call   *%edi
  8002ae:	83 c4 10             	add    $0x10,%esp
  8002b1:	eb 03                	jmp    8002b6 <printnum+0x78>
  8002b3:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002b6:	83 eb 01             	sub    $0x1,%ebx
  8002b9:	85 db                	test   %ebx,%ebx
  8002bb:	7f e8                	jg     8002a5 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002bd:	83 ec 08             	sub    $0x8,%esp
  8002c0:	56                   	push   %esi
  8002c1:	83 ec 04             	sub    $0x4,%esp
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ca:	ff 75 dc             	pushl  -0x24(%ebp)
  8002cd:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d0:	e8 eb 1e 00 00       	call   8021c0 <__umoddi3>
  8002d5:	83 c4 14             	add    $0x14,%esp
  8002d8:	0f be 80 a7 23 80 00 	movsbl 0x8023a7(%eax),%eax
  8002df:	50                   	push   %eax
  8002e0:	ff d7                	call   *%edi
}
  8002e2:	83 c4 10             	add    $0x10,%esp
  8002e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e8:	5b                   	pop    %ebx
  8002e9:	5e                   	pop    %esi
  8002ea:	5f                   	pop    %edi
  8002eb:	5d                   	pop    %ebp
  8002ec:	c3                   	ret    

008002ed <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002f0:	83 fa 01             	cmp    $0x1,%edx
  8002f3:	7e 0e                	jle    800303 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002f5:	8b 10                	mov    (%eax),%edx
  8002f7:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002fa:	89 08                	mov    %ecx,(%eax)
  8002fc:	8b 02                	mov    (%edx),%eax
  8002fe:	8b 52 04             	mov    0x4(%edx),%edx
  800301:	eb 22                	jmp    800325 <getuint+0x38>
	else if (lflag)
  800303:	85 d2                	test   %edx,%edx
  800305:	74 10                	je     800317 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800307:	8b 10                	mov    (%eax),%edx
  800309:	8d 4a 04             	lea    0x4(%edx),%ecx
  80030c:	89 08                	mov    %ecx,(%eax)
  80030e:	8b 02                	mov    (%edx),%eax
  800310:	ba 00 00 00 00       	mov    $0x0,%edx
  800315:	eb 0e                	jmp    800325 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800317:	8b 10                	mov    (%eax),%edx
  800319:	8d 4a 04             	lea    0x4(%edx),%ecx
  80031c:	89 08                	mov    %ecx,(%eax)
  80031e:	8b 02                	mov    (%edx),%eax
  800320:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800325:	5d                   	pop    %ebp
  800326:	c3                   	ret    

00800327 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80032a:	83 fa 01             	cmp    $0x1,%edx
  80032d:	7e 0e                	jle    80033d <getint+0x16>
		return va_arg(*ap, long long);
  80032f:	8b 10                	mov    (%eax),%edx
  800331:	8d 4a 08             	lea    0x8(%edx),%ecx
  800334:	89 08                	mov    %ecx,(%eax)
  800336:	8b 02                	mov    (%edx),%eax
  800338:	8b 52 04             	mov    0x4(%edx),%edx
  80033b:	eb 1a                	jmp    800357 <getint+0x30>
	else if (lflag)
  80033d:	85 d2                	test   %edx,%edx
  80033f:	74 0c                	je     80034d <getint+0x26>
		return va_arg(*ap, long);
  800341:	8b 10                	mov    (%eax),%edx
  800343:	8d 4a 04             	lea    0x4(%edx),%ecx
  800346:	89 08                	mov    %ecx,(%eax)
  800348:	8b 02                	mov    (%edx),%eax
  80034a:	99                   	cltd   
  80034b:	eb 0a                	jmp    800357 <getint+0x30>
	else
		return va_arg(*ap, int);
  80034d:	8b 10                	mov    (%eax),%edx
  80034f:	8d 4a 04             	lea    0x4(%edx),%ecx
  800352:	89 08                	mov    %ecx,(%eax)
  800354:	8b 02                	mov    (%edx),%eax
  800356:	99                   	cltd   
}
  800357:	5d                   	pop    %ebp
  800358:	c3                   	ret    

00800359 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800359:	55                   	push   %ebp
  80035a:	89 e5                	mov    %esp,%ebp
  80035c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80035f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800363:	8b 10                	mov    (%eax),%edx
  800365:	3b 50 04             	cmp    0x4(%eax),%edx
  800368:	73 0a                	jae    800374 <sprintputch+0x1b>
		*b->buf++ = ch;
  80036a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80036d:	89 08                	mov    %ecx,(%eax)
  80036f:	8b 45 08             	mov    0x8(%ebp),%eax
  800372:	88 02                	mov    %al,(%edx)
}
  800374:	5d                   	pop    %ebp
  800375:	c3                   	ret    

00800376 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800376:	55                   	push   %ebp
  800377:	89 e5                	mov    %esp,%ebp
  800379:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  80037c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80037f:	50                   	push   %eax
  800380:	ff 75 10             	pushl  0x10(%ebp)
  800383:	ff 75 0c             	pushl  0xc(%ebp)
  800386:	ff 75 08             	pushl  0x8(%ebp)
  800389:	e8 05 00 00 00       	call   800393 <vprintfmt>
	va_end(ap);
}
  80038e:	83 c4 10             	add    $0x10,%esp
  800391:	c9                   	leave  
  800392:	c3                   	ret    

00800393 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800393:	55                   	push   %ebp
  800394:	89 e5                	mov    %esp,%ebp
  800396:	57                   	push   %edi
  800397:	56                   	push   %esi
  800398:	53                   	push   %ebx
  800399:	83 ec 2c             	sub    $0x2c,%esp
  80039c:	8b 75 08             	mov    0x8(%ebp),%esi
  80039f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003a2:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003a5:	eb 12                	jmp    8003b9 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003a7:	85 c0                	test   %eax,%eax
  8003a9:	0f 84 44 03 00 00    	je     8006f3 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  8003af:	83 ec 08             	sub    $0x8,%esp
  8003b2:	53                   	push   %ebx
  8003b3:	50                   	push   %eax
  8003b4:	ff d6                	call   *%esi
  8003b6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003b9:	83 c7 01             	add    $0x1,%edi
  8003bc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8003c0:	83 f8 25             	cmp    $0x25,%eax
  8003c3:	75 e2                	jne    8003a7 <vprintfmt+0x14>
  8003c5:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8003c9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8003d0:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003d7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8003de:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e3:	eb 07                	jmp    8003ec <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003e8:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ec:	8d 47 01             	lea    0x1(%edi),%eax
  8003ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003f2:	0f b6 07             	movzbl (%edi),%eax
  8003f5:	0f b6 c8             	movzbl %al,%ecx
  8003f8:	83 e8 23             	sub    $0x23,%eax
  8003fb:	3c 55                	cmp    $0x55,%al
  8003fd:	0f 87 d5 02 00 00    	ja     8006d8 <vprintfmt+0x345>
  800403:	0f b6 c0             	movzbl %al,%eax
  800406:	ff 24 85 e0 24 80 00 	jmp    *0x8024e0(,%eax,4)
  80040d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800410:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800414:	eb d6                	jmp    8003ec <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800416:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800419:	b8 00 00 00 00       	mov    $0x0,%eax
  80041e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800421:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800424:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  800428:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  80042b:	8d 51 d0             	lea    -0x30(%ecx),%edx
  80042e:	83 fa 09             	cmp    $0x9,%edx
  800431:	77 39                	ja     80046c <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800433:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800436:	eb e9                	jmp    800421 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800438:	8b 45 14             	mov    0x14(%ebp),%eax
  80043b:	8d 48 04             	lea    0x4(%eax),%ecx
  80043e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800441:	8b 00                	mov    (%eax),%eax
  800443:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800446:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800449:	eb 27                	jmp    800472 <vprintfmt+0xdf>
  80044b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044e:	85 c0                	test   %eax,%eax
  800450:	b9 00 00 00 00       	mov    $0x0,%ecx
  800455:	0f 49 c8             	cmovns %eax,%ecx
  800458:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80045b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80045e:	eb 8c                	jmp    8003ec <vprintfmt+0x59>
  800460:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800463:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80046a:	eb 80                	jmp    8003ec <vprintfmt+0x59>
  80046c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80046f:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  800472:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800476:	0f 89 70 ff ff ff    	jns    8003ec <vprintfmt+0x59>
				width = precision, precision = -1;
  80047c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80047f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800482:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800489:	e9 5e ff ff ff       	jmp    8003ec <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80048e:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800491:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800494:	e9 53 ff ff ff       	jmp    8003ec <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800499:	8b 45 14             	mov    0x14(%ebp),%eax
  80049c:	8d 50 04             	lea    0x4(%eax),%edx
  80049f:	89 55 14             	mov    %edx,0x14(%ebp)
  8004a2:	83 ec 08             	sub    $0x8,%esp
  8004a5:	53                   	push   %ebx
  8004a6:	ff 30                	pushl  (%eax)
  8004a8:	ff d6                	call   *%esi
			break;
  8004aa:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  8004b0:	e9 04 ff ff ff       	jmp    8003b9 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b8:	8d 50 04             	lea    0x4(%eax),%edx
  8004bb:	89 55 14             	mov    %edx,0x14(%ebp)
  8004be:	8b 00                	mov    (%eax),%eax
  8004c0:	99                   	cltd   
  8004c1:	31 d0                	xor    %edx,%eax
  8004c3:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004c5:	83 f8 0f             	cmp    $0xf,%eax
  8004c8:	7f 0b                	jg     8004d5 <vprintfmt+0x142>
  8004ca:	8b 14 85 40 26 80 00 	mov    0x802640(,%eax,4),%edx
  8004d1:	85 d2                	test   %edx,%edx
  8004d3:	75 18                	jne    8004ed <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  8004d5:	50                   	push   %eax
  8004d6:	68 bf 23 80 00       	push   $0x8023bf
  8004db:	53                   	push   %ebx
  8004dc:	56                   	push   %esi
  8004dd:	e8 94 fe ff ff       	call   800376 <printfmt>
  8004e2:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8004e8:	e9 cc fe ff ff       	jmp    8003b9 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  8004ed:	52                   	push   %edx
  8004ee:	68 d5 28 80 00       	push   $0x8028d5
  8004f3:	53                   	push   %ebx
  8004f4:	56                   	push   %esi
  8004f5:	e8 7c fe ff ff       	call   800376 <printfmt>
  8004fa:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800500:	e9 b4 fe ff ff       	jmp    8003b9 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800505:	8b 45 14             	mov    0x14(%ebp),%eax
  800508:	8d 50 04             	lea    0x4(%eax),%edx
  80050b:	89 55 14             	mov    %edx,0x14(%ebp)
  80050e:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800510:	85 ff                	test   %edi,%edi
  800512:	b8 b8 23 80 00       	mov    $0x8023b8,%eax
  800517:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80051a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80051e:	0f 8e 94 00 00 00    	jle    8005b8 <vprintfmt+0x225>
  800524:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800528:	0f 84 98 00 00 00    	je     8005c6 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  80052e:	83 ec 08             	sub    $0x8,%esp
  800531:	ff 75 d0             	pushl  -0x30(%ebp)
  800534:	57                   	push   %edi
  800535:	e8 41 02 00 00       	call   80077b <strnlen>
  80053a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80053d:	29 c1                	sub    %eax,%ecx
  80053f:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800542:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800545:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800549:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80054c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80054f:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800551:	eb 0f                	jmp    800562 <vprintfmt+0x1cf>
					putch(padc, putdat);
  800553:	83 ec 08             	sub    $0x8,%esp
  800556:	53                   	push   %ebx
  800557:	ff 75 e0             	pushl  -0x20(%ebp)
  80055a:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80055c:	83 ef 01             	sub    $0x1,%edi
  80055f:	83 c4 10             	add    $0x10,%esp
  800562:	85 ff                	test   %edi,%edi
  800564:	7f ed                	jg     800553 <vprintfmt+0x1c0>
  800566:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800569:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  80056c:	85 c9                	test   %ecx,%ecx
  80056e:	b8 00 00 00 00       	mov    $0x0,%eax
  800573:	0f 49 c1             	cmovns %ecx,%eax
  800576:	29 c1                	sub    %eax,%ecx
  800578:	89 75 08             	mov    %esi,0x8(%ebp)
  80057b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80057e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800581:	89 cb                	mov    %ecx,%ebx
  800583:	eb 4d                	jmp    8005d2 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800585:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800589:	74 1b                	je     8005a6 <vprintfmt+0x213>
  80058b:	0f be c0             	movsbl %al,%eax
  80058e:	83 e8 20             	sub    $0x20,%eax
  800591:	83 f8 5e             	cmp    $0x5e,%eax
  800594:	76 10                	jbe    8005a6 <vprintfmt+0x213>
					putch('?', putdat);
  800596:	83 ec 08             	sub    $0x8,%esp
  800599:	ff 75 0c             	pushl  0xc(%ebp)
  80059c:	6a 3f                	push   $0x3f
  80059e:	ff 55 08             	call   *0x8(%ebp)
  8005a1:	83 c4 10             	add    $0x10,%esp
  8005a4:	eb 0d                	jmp    8005b3 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  8005a6:	83 ec 08             	sub    $0x8,%esp
  8005a9:	ff 75 0c             	pushl  0xc(%ebp)
  8005ac:	52                   	push   %edx
  8005ad:	ff 55 08             	call   *0x8(%ebp)
  8005b0:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005b3:	83 eb 01             	sub    $0x1,%ebx
  8005b6:	eb 1a                	jmp    8005d2 <vprintfmt+0x23f>
  8005b8:	89 75 08             	mov    %esi,0x8(%ebp)
  8005bb:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005be:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005c1:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005c4:	eb 0c                	jmp    8005d2 <vprintfmt+0x23f>
  8005c6:	89 75 08             	mov    %esi,0x8(%ebp)
  8005c9:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005cc:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005cf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005d2:	83 c7 01             	add    $0x1,%edi
  8005d5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005d9:	0f be d0             	movsbl %al,%edx
  8005dc:	85 d2                	test   %edx,%edx
  8005de:	74 23                	je     800603 <vprintfmt+0x270>
  8005e0:	85 f6                	test   %esi,%esi
  8005e2:	78 a1                	js     800585 <vprintfmt+0x1f2>
  8005e4:	83 ee 01             	sub    $0x1,%esi
  8005e7:	79 9c                	jns    800585 <vprintfmt+0x1f2>
  8005e9:	89 df                	mov    %ebx,%edi
  8005eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005f1:	eb 18                	jmp    80060b <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	53                   	push   %ebx
  8005f7:	6a 20                	push   $0x20
  8005f9:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005fb:	83 ef 01             	sub    $0x1,%edi
  8005fe:	83 c4 10             	add    $0x10,%esp
  800601:	eb 08                	jmp    80060b <vprintfmt+0x278>
  800603:	89 df                	mov    %ebx,%edi
  800605:	8b 75 08             	mov    0x8(%ebp),%esi
  800608:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80060b:	85 ff                	test   %edi,%edi
  80060d:	7f e4                	jg     8005f3 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80060f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800612:	e9 a2 fd ff ff       	jmp    8003b9 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800617:	8d 45 14             	lea    0x14(%ebp),%eax
  80061a:	e8 08 fd ff ff       	call   800327 <getint>
  80061f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800622:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800625:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  80062a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80062e:	79 74                	jns    8006a4 <vprintfmt+0x311>
				putch('-', putdat);
  800630:	83 ec 08             	sub    $0x8,%esp
  800633:	53                   	push   %ebx
  800634:	6a 2d                	push   $0x2d
  800636:	ff d6                	call   *%esi
				num = -(long long) num;
  800638:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80063e:	f7 d8                	neg    %eax
  800640:	83 d2 00             	adc    $0x0,%edx
  800643:	f7 da                	neg    %edx
  800645:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  800648:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80064d:	eb 55                	jmp    8006a4 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80064f:	8d 45 14             	lea    0x14(%ebp),%eax
  800652:	e8 96 fc ff ff       	call   8002ed <getuint>
			base = 10;
  800657:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80065c:	eb 46                	jmp    8006a4 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  80065e:	8d 45 14             	lea    0x14(%ebp),%eax
  800661:	e8 87 fc ff ff       	call   8002ed <getuint>
			base = 8;
  800666:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80066b:	eb 37                	jmp    8006a4 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  80066d:	83 ec 08             	sub    $0x8,%esp
  800670:	53                   	push   %ebx
  800671:	6a 30                	push   $0x30
  800673:	ff d6                	call   *%esi
			putch('x', putdat);
  800675:	83 c4 08             	add    $0x8,%esp
  800678:	53                   	push   %ebx
  800679:	6a 78                	push   $0x78
  80067b:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8d 50 04             	lea    0x4(%eax),%edx
  800683:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800686:	8b 00                	mov    (%eax),%eax
  800688:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  80068d:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800690:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800695:	eb 0d                	jmp    8006a4 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800697:	8d 45 14             	lea    0x14(%ebp),%eax
  80069a:	e8 4e fc ff ff       	call   8002ed <getuint>
			base = 16;
  80069f:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006a4:	83 ec 0c             	sub    $0xc,%esp
  8006a7:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006ab:	57                   	push   %edi
  8006ac:	ff 75 e0             	pushl  -0x20(%ebp)
  8006af:	51                   	push   %ecx
  8006b0:	52                   	push   %edx
  8006b1:	50                   	push   %eax
  8006b2:	89 da                	mov    %ebx,%edx
  8006b4:	89 f0                	mov    %esi,%eax
  8006b6:	e8 83 fb ff ff       	call   80023e <printnum>
			break;
  8006bb:	83 c4 20             	add    $0x20,%esp
  8006be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006c1:	e9 f3 fc ff ff       	jmp    8003b9 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006c6:	83 ec 08             	sub    $0x8,%esp
  8006c9:	53                   	push   %ebx
  8006ca:	51                   	push   %ecx
  8006cb:	ff d6                	call   *%esi
			break;
  8006cd:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8006d3:	e9 e1 fc ff ff       	jmp    8003b9 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006d8:	83 ec 08             	sub    $0x8,%esp
  8006db:	53                   	push   %ebx
  8006dc:	6a 25                	push   $0x25
  8006de:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006e0:	83 c4 10             	add    $0x10,%esp
  8006e3:	eb 03                	jmp    8006e8 <vprintfmt+0x355>
  8006e5:	83 ef 01             	sub    $0x1,%edi
  8006e8:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  8006ec:	75 f7                	jne    8006e5 <vprintfmt+0x352>
  8006ee:	e9 c6 fc ff ff       	jmp    8003b9 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  8006f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006f6:	5b                   	pop    %ebx
  8006f7:	5e                   	pop    %esi
  8006f8:	5f                   	pop    %edi
  8006f9:	5d                   	pop    %ebp
  8006fa:	c3                   	ret    

008006fb <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	83 ec 18             	sub    $0x18,%esp
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800707:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80070a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80070e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800711:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800718:	85 c0                	test   %eax,%eax
  80071a:	74 26                	je     800742 <vsnprintf+0x47>
  80071c:	85 d2                	test   %edx,%edx
  80071e:	7e 22                	jle    800742 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800720:	ff 75 14             	pushl  0x14(%ebp)
  800723:	ff 75 10             	pushl  0x10(%ebp)
  800726:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800729:	50                   	push   %eax
  80072a:	68 59 03 80 00       	push   $0x800359
  80072f:	e8 5f fc ff ff       	call   800393 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800734:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800737:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80073a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80073d:	83 c4 10             	add    $0x10,%esp
  800740:	eb 05                	jmp    800747 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800742:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800747:	c9                   	leave  
  800748:	c3                   	ret    

00800749 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800749:	55                   	push   %ebp
  80074a:	89 e5                	mov    %esp,%ebp
  80074c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80074f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800752:	50                   	push   %eax
  800753:	ff 75 10             	pushl  0x10(%ebp)
  800756:	ff 75 0c             	pushl  0xc(%ebp)
  800759:	ff 75 08             	pushl  0x8(%ebp)
  80075c:	e8 9a ff ff ff       	call   8006fb <vsnprintf>
	va_end(ap);

	return rc;
}
  800761:	c9                   	leave  
  800762:	c3                   	ret    

00800763 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800763:	55                   	push   %ebp
  800764:	89 e5                	mov    %esp,%ebp
  800766:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800769:	b8 00 00 00 00       	mov    $0x0,%eax
  80076e:	eb 03                	jmp    800773 <strlen+0x10>
		n++;
  800770:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800773:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800777:	75 f7                	jne    800770 <strlen+0xd>
		n++;
	return n;
}
  800779:	5d                   	pop    %ebp
  80077a:	c3                   	ret    

0080077b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80077b:	55                   	push   %ebp
  80077c:	89 e5                	mov    %esp,%ebp
  80077e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800781:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800784:	ba 00 00 00 00       	mov    $0x0,%edx
  800789:	eb 03                	jmp    80078e <strnlen+0x13>
		n++;
  80078b:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80078e:	39 c2                	cmp    %eax,%edx
  800790:	74 08                	je     80079a <strnlen+0x1f>
  800792:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800796:	75 f3                	jne    80078b <strnlen+0x10>
  800798:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  80079a:	5d                   	pop    %ebp
  80079b:	c3                   	ret    

0080079c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
  80079f:	53                   	push   %ebx
  8007a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007a6:	89 c2                	mov    %eax,%edx
  8007a8:	83 c2 01             	add    $0x1,%edx
  8007ab:	83 c1 01             	add    $0x1,%ecx
  8007ae:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007b2:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007b5:	84 db                	test   %bl,%bl
  8007b7:	75 ef                	jne    8007a8 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007b9:	5b                   	pop    %ebx
  8007ba:	5d                   	pop    %ebp
  8007bb:	c3                   	ret    

008007bc <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
  8007bf:	53                   	push   %ebx
  8007c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007c3:	53                   	push   %ebx
  8007c4:	e8 9a ff ff ff       	call   800763 <strlen>
  8007c9:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007cc:	ff 75 0c             	pushl  0xc(%ebp)
  8007cf:	01 d8                	add    %ebx,%eax
  8007d1:	50                   	push   %eax
  8007d2:	e8 c5 ff ff ff       	call   80079c <strcpy>
	return dst;
}
  8007d7:	89 d8                	mov    %ebx,%eax
  8007d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007dc:	c9                   	leave  
  8007dd:	c3                   	ret    

008007de <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007de:	55                   	push   %ebp
  8007df:	89 e5                	mov    %esp,%ebp
  8007e1:	56                   	push   %esi
  8007e2:	53                   	push   %ebx
  8007e3:	8b 75 08             	mov    0x8(%ebp),%esi
  8007e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007e9:	89 f3                	mov    %esi,%ebx
  8007eb:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007ee:	89 f2                	mov    %esi,%edx
  8007f0:	eb 0f                	jmp    800801 <strncpy+0x23>
		*dst++ = *src;
  8007f2:	83 c2 01             	add    $0x1,%edx
  8007f5:	0f b6 01             	movzbl (%ecx),%eax
  8007f8:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007fb:	80 39 01             	cmpb   $0x1,(%ecx)
  8007fe:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800801:	39 da                	cmp    %ebx,%edx
  800803:	75 ed                	jne    8007f2 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800805:	89 f0                	mov    %esi,%eax
  800807:	5b                   	pop    %ebx
  800808:	5e                   	pop    %esi
  800809:	5d                   	pop    %ebp
  80080a:	c3                   	ret    

0080080b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80080b:	55                   	push   %ebp
  80080c:	89 e5                	mov    %esp,%ebp
  80080e:	56                   	push   %esi
  80080f:	53                   	push   %ebx
  800810:	8b 75 08             	mov    0x8(%ebp),%esi
  800813:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800816:	8b 55 10             	mov    0x10(%ebp),%edx
  800819:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80081b:	85 d2                	test   %edx,%edx
  80081d:	74 21                	je     800840 <strlcpy+0x35>
  80081f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800823:	89 f2                	mov    %esi,%edx
  800825:	eb 09                	jmp    800830 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800827:	83 c2 01             	add    $0x1,%edx
  80082a:	83 c1 01             	add    $0x1,%ecx
  80082d:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800830:	39 c2                	cmp    %eax,%edx
  800832:	74 09                	je     80083d <strlcpy+0x32>
  800834:	0f b6 19             	movzbl (%ecx),%ebx
  800837:	84 db                	test   %bl,%bl
  800839:	75 ec                	jne    800827 <strlcpy+0x1c>
  80083b:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  80083d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800840:	29 f0                	sub    %esi,%eax
}
  800842:	5b                   	pop    %ebx
  800843:	5e                   	pop    %esi
  800844:	5d                   	pop    %ebp
  800845:	c3                   	ret    

00800846 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800846:	55                   	push   %ebp
  800847:	89 e5                	mov    %esp,%ebp
  800849:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80084c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80084f:	eb 06                	jmp    800857 <strcmp+0x11>
		p++, q++;
  800851:	83 c1 01             	add    $0x1,%ecx
  800854:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800857:	0f b6 01             	movzbl (%ecx),%eax
  80085a:	84 c0                	test   %al,%al
  80085c:	74 04                	je     800862 <strcmp+0x1c>
  80085e:	3a 02                	cmp    (%edx),%al
  800860:	74 ef                	je     800851 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800862:	0f b6 c0             	movzbl %al,%eax
  800865:	0f b6 12             	movzbl (%edx),%edx
  800868:	29 d0                	sub    %edx,%eax
}
  80086a:	5d                   	pop    %ebp
  80086b:	c3                   	ret    

0080086c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80086c:	55                   	push   %ebp
  80086d:	89 e5                	mov    %esp,%ebp
  80086f:	53                   	push   %ebx
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	8b 55 0c             	mov    0xc(%ebp),%edx
  800876:	89 c3                	mov    %eax,%ebx
  800878:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80087b:	eb 06                	jmp    800883 <strncmp+0x17>
		n--, p++, q++;
  80087d:	83 c0 01             	add    $0x1,%eax
  800880:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800883:	39 d8                	cmp    %ebx,%eax
  800885:	74 15                	je     80089c <strncmp+0x30>
  800887:	0f b6 08             	movzbl (%eax),%ecx
  80088a:	84 c9                	test   %cl,%cl
  80088c:	74 04                	je     800892 <strncmp+0x26>
  80088e:	3a 0a                	cmp    (%edx),%cl
  800890:	74 eb                	je     80087d <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800892:	0f b6 00             	movzbl (%eax),%eax
  800895:	0f b6 12             	movzbl (%edx),%edx
  800898:	29 d0                	sub    %edx,%eax
  80089a:	eb 05                	jmp    8008a1 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  80089c:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008a1:	5b                   	pop    %ebx
  8008a2:	5d                   	pop    %ebp
  8008a3:	c3                   	ret    

008008a4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008a4:	55                   	push   %ebp
  8008a5:	89 e5                	mov    %esp,%ebp
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ae:	eb 07                	jmp    8008b7 <strchr+0x13>
		if (*s == c)
  8008b0:	38 ca                	cmp    %cl,%dl
  8008b2:	74 0f                	je     8008c3 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008b4:	83 c0 01             	add    $0x1,%eax
  8008b7:	0f b6 10             	movzbl (%eax),%edx
  8008ba:	84 d2                	test   %dl,%dl
  8008bc:	75 f2                	jne    8008b0 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8008be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008c3:	5d                   	pop    %ebp
  8008c4:	c3                   	ret    

008008c5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008c5:	55                   	push   %ebp
  8008c6:	89 e5                	mov    %esp,%ebp
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008cf:	eb 03                	jmp    8008d4 <strfind+0xf>
  8008d1:	83 c0 01             	add    $0x1,%eax
  8008d4:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008d7:	38 ca                	cmp    %cl,%dl
  8008d9:	74 04                	je     8008df <strfind+0x1a>
  8008db:	84 d2                	test   %dl,%dl
  8008dd:	75 f2                	jne    8008d1 <strfind+0xc>
			break;
	return (char *) s;
}
  8008df:	5d                   	pop    %ebp
  8008e0:	c3                   	ret    

008008e1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	57                   	push   %edi
  8008e5:	56                   	push   %esi
  8008e6:	53                   	push   %ebx
  8008e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8008ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  8008ed:	85 c9                	test   %ecx,%ecx
  8008ef:	74 37                	je     800928 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008f1:	f6 c2 03             	test   $0x3,%dl
  8008f4:	75 2a                	jne    800920 <memset+0x3f>
  8008f6:	f6 c1 03             	test   $0x3,%cl
  8008f9:	75 25                	jne    800920 <memset+0x3f>
		c &= 0xFF;
  8008fb:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008ff:	89 df                	mov    %ebx,%edi
  800901:	c1 e7 08             	shl    $0x8,%edi
  800904:	89 de                	mov    %ebx,%esi
  800906:	c1 e6 18             	shl    $0x18,%esi
  800909:	89 d8                	mov    %ebx,%eax
  80090b:	c1 e0 10             	shl    $0x10,%eax
  80090e:	09 f0                	or     %esi,%eax
  800910:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800912:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800915:	89 f8                	mov    %edi,%eax
  800917:	09 d8                	or     %ebx,%eax
  800919:	89 d7                	mov    %edx,%edi
  80091b:	fc                   	cld    
  80091c:	f3 ab                	rep stos %eax,%es:(%edi)
  80091e:	eb 08                	jmp    800928 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800920:	89 d7                	mov    %edx,%edi
  800922:	8b 45 0c             	mov    0xc(%ebp),%eax
  800925:	fc                   	cld    
  800926:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800928:	89 d0                	mov    %edx,%eax
  80092a:	5b                   	pop    %ebx
  80092b:	5e                   	pop    %esi
  80092c:	5f                   	pop    %edi
  80092d:	5d                   	pop    %ebp
  80092e:	c3                   	ret    

0080092f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	57                   	push   %edi
  800933:	56                   	push   %esi
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	8b 75 0c             	mov    0xc(%ebp),%esi
  80093a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80093d:	39 c6                	cmp    %eax,%esi
  80093f:	73 35                	jae    800976 <memmove+0x47>
  800941:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800944:	39 d0                	cmp    %edx,%eax
  800946:	73 2e                	jae    800976 <memmove+0x47>
		s += n;
		d += n;
  800948:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80094b:	89 d6                	mov    %edx,%esi
  80094d:	09 fe                	or     %edi,%esi
  80094f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800955:	75 13                	jne    80096a <memmove+0x3b>
  800957:	f6 c1 03             	test   $0x3,%cl
  80095a:	75 0e                	jne    80096a <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  80095c:	83 ef 04             	sub    $0x4,%edi
  80095f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800962:	c1 e9 02             	shr    $0x2,%ecx
  800965:	fd                   	std    
  800966:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800968:	eb 09                	jmp    800973 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80096a:	83 ef 01             	sub    $0x1,%edi
  80096d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800970:	fd                   	std    
  800971:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800973:	fc                   	cld    
  800974:	eb 1d                	jmp    800993 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800976:	89 f2                	mov    %esi,%edx
  800978:	09 c2                	or     %eax,%edx
  80097a:	f6 c2 03             	test   $0x3,%dl
  80097d:	75 0f                	jne    80098e <memmove+0x5f>
  80097f:	f6 c1 03             	test   $0x3,%cl
  800982:	75 0a                	jne    80098e <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  800984:	c1 e9 02             	shr    $0x2,%ecx
  800987:	89 c7                	mov    %eax,%edi
  800989:	fc                   	cld    
  80098a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80098c:	eb 05                	jmp    800993 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80098e:	89 c7                	mov    %eax,%edi
  800990:	fc                   	cld    
  800991:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800993:	5e                   	pop    %esi
  800994:	5f                   	pop    %edi
  800995:	5d                   	pop    %ebp
  800996:	c3                   	ret    

00800997 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800997:	55                   	push   %ebp
  800998:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80099a:	ff 75 10             	pushl  0x10(%ebp)
  80099d:	ff 75 0c             	pushl  0xc(%ebp)
  8009a0:	ff 75 08             	pushl  0x8(%ebp)
  8009a3:	e8 87 ff ff ff       	call   80092f <memmove>
}
  8009a8:	c9                   	leave  
  8009a9:	c3                   	ret    

008009aa <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	56                   	push   %esi
  8009ae:	53                   	push   %ebx
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b5:	89 c6                	mov    %eax,%esi
  8009b7:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009ba:	eb 1a                	jmp    8009d6 <memcmp+0x2c>
		if (*s1 != *s2)
  8009bc:	0f b6 08             	movzbl (%eax),%ecx
  8009bf:	0f b6 1a             	movzbl (%edx),%ebx
  8009c2:	38 d9                	cmp    %bl,%cl
  8009c4:	74 0a                	je     8009d0 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8009c6:	0f b6 c1             	movzbl %cl,%eax
  8009c9:	0f b6 db             	movzbl %bl,%ebx
  8009cc:	29 d8                	sub    %ebx,%eax
  8009ce:	eb 0f                	jmp    8009df <memcmp+0x35>
		s1++, s2++;
  8009d0:	83 c0 01             	add    $0x1,%eax
  8009d3:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009d6:	39 f0                	cmp    %esi,%eax
  8009d8:	75 e2                	jne    8009bc <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8009da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009df:	5b                   	pop    %ebx
  8009e0:	5e                   	pop    %esi
  8009e1:	5d                   	pop    %ebp
  8009e2:	c3                   	ret    

008009e3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	53                   	push   %ebx
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  8009ea:	89 c1                	mov    %eax,%ecx
  8009ec:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  8009ef:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8009f3:	eb 0a                	jmp    8009ff <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009f5:	0f b6 10             	movzbl (%eax),%edx
  8009f8:	39 da                	cmp    %ebx,%edx
  8009fa:	74 07                	je     800a03 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8009fc:	83 c0 01             	add    $0x1,%eax
  8009ff:	39 c8                	cmp    %ecx,%eax
  800a01:	72 f2                	jb     8009f5 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a03:	5b                   	pop    %ebx
  800a04:	5d                   	pop    %ebp
  800a05:	c3                   	ret    

00800a06 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	57                   	push   %edi
  800a0a:	56                   	push   %esi
  800a0b:	53                   	push   %ebx
  800a0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a0f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a12:	eb 03                	jmp    800a17 <strtol+0x11>
		s++;
  800a14:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a17:	0f b6 01             	movzbl (%ecx),%eax
  800a1a:	3c 20                	cmp    $0x20,%al
  800a1c:	74 f6                	je     800a14 <strtol+0xe>
  800a1e:	3c 09                	cmp    $0x9,%al
  800a20:	74 f2                	je     800a14 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a22:	3c 2b                	cmp    $0x2b,%al
  800a24:	75 0a                	jne    800a30 <strtol+0x2a>
		s++;
  800a26:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a29:	bf 00 00 00 00       	mov    $0x0,%edi
  800a2e:	eb 11                	jmp    800a41 <strtol+0x3b>
  800a30:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800a35:	3c 2d                	cmp    $0x2d,%al
  800a37:	75 08                	jne    800a41 <strtol+0x3b>
		s++, neg = 1;
  800a39:	83 c1 01             	add    $0x1,%ecx
  800a3c:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a41:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a47:	75 15                	jne    800a5e <strtol+0x58>
  800a49:	80 39 30             	cmpb   $0x30,(%ecx)
  800a4c:	75 10                	jne    800a5e <strtol+0x58>
  800a4e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a52:	75 7c                	jne    800ad0 <strtol+0xca>
		s += 2, base = 16;
  800a54:	83 c1 02             	add    $0x2,%ecx
  800a57:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a5c:	eb 16                	jmp    800a74 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800a5e:	85 db                	test   %ebx,%ebx
  800a60:	75 12                	jne    800a74 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a62:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a67:	80 39 30             	cmpb   $0x30,(%ecx)
  800a6a:	75 08                	jne    800a74 <strtol+0x6e>
		s++, base = 8;
  800a6c:	83 c1 01             	add    $0x1,%ecx
  800a6f:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
  800a79:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800a7c:	0f b6 11             	movzbl (%ecx),%edx
  800a7f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a82:	89 f3                	mov    %esi,%ebx
  800a84:	80 fb 09             	cmp    $0x9,%bl
  800a87:	77 08                	ja     800a91 <strtol+0x8b>
			dig = *s - '0';
  800a89:	0f be d2             	movsbl %dl,%edx
  800a8c:	83 ea 30             	sub    $0x30,%edx
  800a8f:	eb 22                	jmp    800ab3 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800a91:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a94:	89 f3                	mov    %esi,%ebx
  800a96:	80 fb 19             	cmp    $0x19,%bl
  800a99:	77 08                	ja     800aa3 <strtol+0x9d>
			dig = *s - 'a' + 10;
  800a9b:	0f be d2             	movsbl %dl,%edx
  800a9e:	83 ea 57             	sub    $0x57,%edx
  800aa1:	eb 10                	jmp    800ab3 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800aa3:	8d 72 bf             	lea    -0x41(%edx),%esi
  800aa6:	89 f3                	mov    %esi,%ebx
  800aa8:	80 fb 19             	cmp    $0x19,%bl
  800aab:	77 16                	ja     800ac3 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800aad:	0f be d2             	movsbl %dl,%edx
  800ab0:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800ab3:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ab6:	7d 0b                	jge    800ac3 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800ab8:	83 c1 01             	add    $0x1,%ecx
  800abb:	0f af 45 10          	imul   0x10(%ebp),%eax
  800abf:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800ac1:	eb b9                	jmp    800a7c <strtol+0x76>

	if (endptr)
  800ac3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ac7:	74 0d                	je     800ad6 <strtol+0xd0>
		*endptr = (char *) s;
  800ac9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800acc:	89 0e                	mov    %ecx,(%esi)
  800ace:	eb 06                	jmp    800ad6 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ad0:	85 db                	test   %ebx,%ebx
  800ad2:	74 98                	je     800a6c <strtol+0x66>
  800ad4:	eb 9e                	jmp    800a74 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800ad6:	89 c2                	mov    %eax,%edx
  800ad8:	f7 da                	neg    %edx
  800ada:	85 ff                	test   %edi,%edi
  800adc:	0f 45 c2             	cmovne %edx,%eax
}
  800adf:	5b                   	pop    %ebx
  800ae0:	5e                   	pop    %esi
  800ae1:	5f                   	pop    %edi
  800ae2:	5d                   	pop    %ebp
  800ae3:	c3                   	ret    

00800ae4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800ae4:	55                   	push   %ebp
  800ae5:	89 e5                	mov    %esp,%ebp
  800ae7:	57                   	push   %edi
  800ae8:	56                   	push   %esi
  800ae9:	53                   	push   %ebx
  800aea:	83 ec 1c             	sub    $0x1c,%esp
  800aed:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800af0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800af3:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800af5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800afb:	8b 7d 10             	mov    0x10(%ebp),%edi
  800afe:	8b 75 14             	mov    0x14(%ebp),%esi
  800b01:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800b03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b07:	74 1d                	je     800b26 <syscall+0x42>
  800b09:	85 c0                	test   %eax,%eax
  800b0b:	7e 19                	jle    800b26 <syscall+0x42>
  800b0d:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800b10:	83 ec 0c             	sub    $0xc,%esp
  800b13:	50                   	push   %eax
  800b14:	52                   	push   %edx
  800b15:	68 9f 26 80 00       	push   $0x80269f
  800b1a:	6a 23                	push   $0x23
  800b1c:	68 bc 26 80 00       	push   $0x8026bc
  800b21:	e8 2b f6 ff ff       	call   800151 <_panic>

	return ret;
}
  800b26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b29:	5b                   	pop    %ebx
  800b2a:	5e                   	pop    %esi
  800b2b:	5f                   	pop    %edi
  800b2c:	5d                   	pop    %ebp
  800b2d:	c3                   	ret    

00800b2e <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800b2e:	55                   	push   %ebp
  800b2f:	89 e5                	mov    %esp,%ebp
  800b31:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800b34:	6a 00                	push   $0x0
  800b36:	6a 00                	push   $0x0
  800b38:	6a 00                	push   $0x0
  800b3a:	ff 75 0c             	pushl  0xc(%ebp)
  800b3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b40:	ba 00 00 00 00       	mov    $0x0,%edx
  800b45:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4a:	e8 95 ff ff ff       	call   800ae4 <syscall>
}
  800b4f:	83 c4 10             	add    $0x10,%esp
  800b52:	c9                   	leave  
  800b53:	c3                   	ret    

00800b54 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800b5a:	6a 00                	push   $0x0
  800b5c:	6a 00                	push   $0x0
  800b5e:	6a 00                	push   $0x0
  800b60:	6a 00                	push   $0x0
  800b62:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b67:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6c:	b8 01 00 00 00       	mov    $0x1,%eax
  800b71:	e8 6e ff ff ff       	call   800ae4 <syscall>
}
  800b76:	c9                   	leave  
  800b77:	c3                   	ret    

00800b78 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800b7e:	6a 00                	push   $0x0
  800b80:	6a 00                	push   $0x0
  800b82:	6a 00                	push   $0x0
  800b84:	6a 00                	push   $0x0
  800b86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b89:	ba 01 00 00 00       	mov    $0x1,%edx
  800b8e:	b8 03 00 00 00       	mov    $0x3,%eax
  800b93:	e8 4c ff ff ff       	call   800ae4 <syscall>
}
  800b98:	c9                   	leave  
  800b99:	c3                   	ret    

00800b9a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800ba0:	6a 00                	push   $0x0
  800ba2:	6a 00                	push   $0x0
  800ba4:	6a 00                	push   $0x0
  800ba6:	6a 00                	push   $0x0
  800ba8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bad:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb2:	b8 02 00 00 00       	mov    $0x2,%eax
  800bb7:	e8 28 ff ff ff       	call   800ae4 <syscall>
}
  800bbc:	c9                   	leave  
  800bbd:	c3                   	ret    

00800bbe <sys_yield>:

void
sys_yield(void)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800bc4:	6a 00                	push   $0x0
  800bc6:	6a 00                	push   $0x0
  800bc8:	6a 00                	push   $0x0
  800bca:	6a 00                	push   $0x0
  800bcc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bd1:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd6:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bdb:	e8 04 ff ff ff       	call   800ae4 <syscall>
}
  800be0:	83 c4 10             	add    $0x10,%esp
  800be3:	c9                   	leave  
  800be4:	c3                   	ret    

00800be5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800beb:	6a 00                	push   $0x0
  800bed:	6a 00                	push   $0x0
  800bef:	ff 75 10             	pushl  0x10(%ebp)
  800bf2:	ff 75 0c             	pushl  0xc(%ebp)
  800bf5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf8:	ba 01 00 00 00       	mov    $0x1,%edx
  800bfd:	b8 04 00 00 00       	mov    $0x4,%eax
  800c02:	e8 dd fe ff ff       	call   800ae4 <syscall>
}
  800c07:	c9                   	leave  
  800c08:	c3                   	ret    

00800c09 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800c0f:	ff 75 18             	pushl  0x18(%ebp)
  800c12:	ff 75 14             	pushl  0x14(%ebp)
  800c15:	ff 75 10             	pushl  0x10(%ebp)
  800c18:	ff 75 0c             	pushl  0xc(%ebp)
  800c1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c1e:	ba 01 00 00 00       	mov    $0x1,%edx
  800c23:	b8 05 00 00 00       	mov    $0x5,%eax
  800c28:	e8 b7 fe ff ff       	call   800ae4 <syscall>
}
  800c2d:	c9                   	leave  
  800c2e:	c3                   	ret    

00800c2f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800c35:	6a 00                	push   $0x0
  800c37:	6a 00                	push   $0x0
  800c39:	6a 00                	push   $0x0
  800c3b:	ff 75 0c             	pushl  0xc(%ebp)
  800c3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c41:	ba 01 00 00 00       	mov    $0x1,%edx
  800c46:	b8 06 00 00 00       	mov    $0x6,%eax
  800c4b:	e8 94 fe ff ff       	call   800ae4 <syscall>
}
  800c50:	c9                   	leave  
  800c51:	c3                   	ret    

00800c52 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c58:	6a 00                	push   $0x0
  800c5a:	6a 00                	push   $0x0
  800c5c:	6a 00                	push   $0x0
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c64:	ba 01 00 00 00       	mov    $0x1,%edx
  800c69:	b8 08 00 00 00       	mov    $0x8,%eax
  800c6e:	e8 71 fe ff ff       	call   800ae4 <syscall>
}
  800c73:	c9                   	leave  
  800c74:	c3                   	ret    

00800c75 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800c7b:	6a 00                	push   $0x0
  800c7d:	6a 00                	push   $0x0
  800c7f:	6a 00                	push   $0x0
  800c81:	ff 75 0c             	pushl  0xc(%ebp)
  800c84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c87:	ba 01 00 00 00       	mov    $0x1,%edx
  800c8c:	b8 09 00 00 00       	mov    $0x9,%eax
  800c91:	e8 4e fe ff ff       	call   800ae4 <syscall>
}
  800c96:	c9                   	leave  
  800c97:	c3                   	ret    

00800c98 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800c9e:	6a 00                	push   $0x0
  800ca0:	6a 00                	push   $0x0
  800ca2:	6a 00                	push   $0x0
  800ca4:	ff 75 0c             	pushl  0xc(%ebp)
  800ca7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800caa:	ba 01 00 00 00       	mov    $0x1,%edx
  800caf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cb4:	e8 2b fe ff ff       	call   800ae4 <syscall>
}
  800cb9:	c9                   	leave  
  800cba:	c3                   	ret    

00800cbb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800cc1:	6a 00                	push   $0x0
  800cc3:	ff 75 14             	pushl  0x14(%ebp)
  800cc6:	ff 75 10             	pushl  0x10(%ebp)
  800cc9:	ff 75 0c             	pushl  0xc(%ebp)
  800ccc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ccf:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd4:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cd9:	e8 06 fe ff ff       	call   800ae4 <syscall>
}
  800cde:	c9                   	leave  
  800cdf:	c3                   	ret    

00800ce0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800ce6:	6a 00                	push   $0x0
  800ce8:	6a 00                	push   $0x0
  800cea:	6a 00                	push   $0x0
  800cec:	6a 00                	push   $0x0
  800cee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cf1:	ba 01 00 00 00       	mov    $0x1,%edx
  800cf6:	b8 0d 00 00 00       	mov    $0xd,%eax
  800cfb:	e8 e4 fd ff ff       	call   800ae4 <syscall>
}
  800d00:	c9                   	leave  
  800d01:	c3                   	ret    

00800d02 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	53                   	push   %ebx
  800d06:	83 ec 04             	sub    $0x4,%esp

	int perm_w = PTE_COW|PTE_U|PTE_P;
	int perm = PTE_U|PTE_P;

	// LAB 4: Your code here.
	void *addr = (void*) (pn*PGSIZE);
  800d09:	89 d3                	mov    %edx,%ebx
  800d0b:	c1 e3 0c             	shl    $0xc,%ebx

	//Si una página tiene el bit PTE_SHARE, se comparte con el hijo con los mismos permisos.
  	if (uvpt[pn] & PTE_SHARE) {
  800d0e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800d15:	f6 c5 04             	test   $0x4,%ch
  800d18:	74 3a                	je     800d54 <duppage+0x52>
    	if (sys_page_map(0, addr, envid,addr, uvpt[pn] & PTE_SYSCALL) < 0) {
  800d1a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d21:	83 ec 0c             	sub    $0xc,%esp
  800d24:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800d2a:	52                   	push   %edx
  800d2b:	53                   	push   %ebx
  800d2c:	50                   	push   %eax
  800d2d:	53                   	push   %ebx
  800d2e:	6a 00                	push   $0x0
  800d30:	e8 d4 fe ff ff       	call   800c09 <sys_page_map>
  800d35:	83 c4 20             	add    $0x20,%esp
  800d38:	85 c0                	test   %eax,%eax
  800d3a:	0f 89 99 00 00 00    	jns    800dd9 <duppage+0xd7>
 	     	panic("Error en sys_page_map");
  800d40:	83 ec 04             	sub    $0x4,%esp
  800d43:	68 ca 26 80 00       	push   $0x8026ca
  800d48:	6a 50                	push   $0x50
  800d4a:	68 e0 26 80 00       	push   $0x8026e0
  800d4f:	e8 fd f3 ff ff       	call   800151 <_panic>
    	} 
    	return 0;
	}

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  800d54:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800d5b:	f6 c1 02             	test   $0x2,%cl
  800d5e:	75 0c                	jne    800d6c <duppage+0x6a>
  800d60:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d67:	f6 c6 08             	test   $0x8,%dh
  800d6a:	74 5b                	je     800dc7 <duppage+0xc5>
		if (sys_page_map(0, addr, envid, addr, perm_w) < 0){
  800d6c:	83 ec 0c             	sub    $0xc,%esp
  800d6f:	68 05 08 00 00       	push   $0x805
  800d74:	53                   	push   %ebx
  800d75:	50                   	push   %eax
  800d76:	53                   	push   %ebx
  800d77:	6a 00                	push   $0x0
  800d79:	e8 8b fe ff ff       	call   800c09 <sys_page_map>
  800d7e:	83 c4 20             	add    $0x20,%esp
  800d81:	85 c0                	test   %eax,%eax
  800d83:	79 14                	jns    800d99 <duppage+0x97>
			panic("Error mapeando pagina Padre");
  800d85:	83 ec 04             	sub    $0x4,%esp
  800d88:	68 eb 26 80 00       	push   $0x8026eb
  800d8d:	6a 57                	push   $0x57
  800d8f:	68 e0 26 80 00       	push   $0x8026e0
  800d94:	e8 b8 f3 ff ff       	call   800151 <_panic>
		}
		if (sys_page_map(0, addr, 0, addr, perm_w) < 0){
  800d99:	83 ec 0c             	sub    $0xc,%esp
  800d9c:	68 05 08 00 00       	push   $0x805
  800da1:	53                   	push   %ebx
  800da2:	6a 00                	push   $0x0
  800da4:	53                   	push   %ebx
  800da5:	6a 00                	push   $0x0
  800da7:	e8 5d fe ff ff       	call   800c09 <sys_page_map>
  800dac:	83 c4 20             	add    $0x20,%esp
  800daf:	85 c0                	test   %eax,%eax
  800db1:	79 26                	jns    800dd9 <duppage+0xd7>
			panic("Error mapeando pagina Hijo");
  800db3:	83 ec 04             	sub    $0x4,%esp
  800db6:	68 07 27 80 00       	push   $0x802707
  800dbb:	6a 5a                	push   $0x5a
  800dbd:	68 e0 26 80 00       	push   $0x8026e0
  800dc2:	e8 8a f3 ff ff       	call   800151 <_panic>
		}
	} else sys_page_map(0, addr, envid, addr, perm);
  800dc7:	83 ec 0c             	sub    $0xc,%esp
  800dca:	6a 05                	push   $0x5
  800dcc:	53                   	push   %ebx
  800dcd:	50                   	push   %eax
  800dce:	53                   	push   %ebx
  800dcf:	6a 00                	push   $0x0
  800dd1:	e8 33 fe ff ff       	call   800c09 <sys_page_map>
  800dd6:	83 c4 20             	add    $0x20,%esp
	
	return 0;
}
  800dd9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800de1:	c9                   	leave  
  800de2:	c3                   	ret    

00800de3 <dup_or_share>:
//FORK V0

static void
dup_or_share(envid_t dstenv, void *va, int perm){
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	57                   	push   %edi
  800de7:	56                   	push   %esi
  800de8:	53                   	push   %ebx
  800de9:	83 ec 0c             	sub    $0xc,%esp
  800dec:	89 c7                	mov    %eax,%edi
  800dee:	89 d6                	mov    %edx,%esi
  800df0:	89 cb                	mov    %ecx,%ebx
	int result;
	// Si no es de escritura, comparto la pagina
	if((perm &PTE_W) != PTE_W){
  800df2:	f6 c1 02             	test   $0x2,%cl
  800df5:	75 2d                	jne    800e24 <dup_or_share+0x41>
		if((result = sys_page_map(0, va, dstenv, va, perm))<0){
  800df7:	83 ec 0c             	sub    $0xc,%esp
  800dfa:	51                   	push   %ecx
  800dfb:	52                   	push   %edx
  800dfc:	50                   	push   %eax
  800dfd:	52                   	push   %edx
  800dfe:	6a 00                	push   $0x0
  800e00:	e8 04 fe ff ff       	call   800c09 <sys_page_map>
  800e05:	83 c4 20             	add    $0x20,%esp
  800e08:	85 c0                	test   %eax,%eax
  800e0a:	0f 89 a4 00 00 00    	jns    800eb4 <dup_or_share+0xd1>
			panic("Error compartiendo la pagina");
  800e10:	83 ec 04             	sub    $0x4,%esp
  800e13:	68 22 27 80 00       	push   $0x802722
  800e18:	6a 68                	push   $0x68
  800e1a:	68 e0 26 80 00       	push   $0x8026e0
  800e1f:	e8 2d f3 ff ff       	call   800151 <_panic>
		}
	// Si es de escritura comportamiento de duppage, en dumbfork
	}else{
		if ((result = sys_page_alloc(dstenv, va, perm)) < 0){
  800e24:	83 ec 04             	sub    $0x4,%esp
  800e27:	51                   	push   %ecx
  800e28:	52                   	push   %edx
  800e29:	50                   	push   %eax
  800e2a:	e8 b6 fd ff ff       	call   800be5 <sys_page_alloc>
  800e2f:	83 c4 10             	add    $0x10,%esp
  800e32:	85 c0                	test   %eax,%eax
  800e34:	79 14                	jns    800e4a <dup_or_share+0x67>
			panic("Error copiando la pagina");
  800e36:	83 ec 04             	sub    $0x4,%esp
  800e39:	68 3f 27 80 00       	push   $0x80273f
  800e3e:	6a 6d                	push   $0x6d
  800e40:	68 e0 26 80 00       	push   $0x8026e0
  800e45:	e8 07 f3 ff ff       	call   800151 <_panic>
		}
		if ((result = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0){
  800e4a:	83 ec 0c             	sub    $0xc,%esp
  800e4d:	53                   	push   %ebx
  800e4e:	68 00 00 40 00       	push   $0x400000
  800e53:	6a 00                	push   $0x0
  800e55:	56                   	push   %esi
  800e56:	57                   	push   %edi
  800e57:	e8 ad fd ff ff       	call   800c09 <sys_page_map>
  800e5c:	83 c4 20             	add    $0x20,%esp
  800e5f:	85 c0                	test   %eax,%eax
  800e61:	79 14                	jns    800e77 <dup_or_share+0x94>
			panic("Error copiando la pagina");
  800e63:	83 ec 04             	sub    $0x4,%esp
  800e66:	68 3f 27 80 00       	push   $0x80273f
  800e6b:	6a 70                	push   $0x70
  800e6d:	68 e0 26 80 00       	push   $0x8026e0
  800e72:	e8 da f2 ff ff       	call   800151 <_panic>
		}
		memmove(UTEMP, va, PGSIZE);
  800e77:	83 ec 04             	sub    $0x4,%esp
  800e7a:	68 00 10 00 00       	push   $0x1000
  800e7f:	56                   	push   %esi
  800e80:	68 00 00 40 00       	push   $0x400000
  800e85:	e8 a5 fa ff ff       	call   80092f <memmove>
		if ((result = sys_page_unmap(0, UTEMP)) < 0){
  800e8a:	83 c4 08             	add    $0x8,%esp
  800e8d:	68 00 00 40 00       	push   $0x400000
  800e92:	6a 00                	push   $0x0
  800e94:	e8 96 fd ff ff       	call   800c2f <sys_page_unmap>
  800e99:	83 c4 10             	add    $0x10,%esp
  800e9c:	85 c0                	test   %eax,%eax
  800e9e:	79 14                	jns    800eb4 <dup_or_share+0xd1>
			panic("Error copiando la pagina");
  800ea0:	83 ec 04             	sub    $0x4,%esp
  800ea3:	68 3f 27 80 00       	push   $0x80273f
  800ea8:	6a 74                	push   $0x74
  800eaa:	68 e0 26 80 00       	push   $0x8026e0
  800eaf:	e8 9d f2 ff ff       	call   800151 <_panic>
		}
	}	
}
  800eb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb7:	5b                   	pop    %ebx
  800eb8:	5e                   	pop    %esi
  800eb9:	5f                   	pop    %edi
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    

00800ebc <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	53                   	push   %ebx
  800ec0:	83 ec 04             	sub    $0x4,%esp
  800ec3:	8b 55 08             	mov    0x8(%ebp),%edx
	void *va = (void *) utf->utf_fault_va;
  800ec6:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800ec8:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  800ecc:	74 2e                	je     800efc <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
  800ece:	89 c2                	mov    %eax,%edx
  800ed0:	c1 ea 16             	shr    $0x16,%edx
  800ed3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800eda:	f6 c2 01             	test   $0x1,%dl
  800edd:	74 1d                	je     800efc <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
  800edf:	89 c2                	mov    %eax,%edx
  800ee1:	c1 ea 0c             	shr    $0xc,%edx
  800ee4:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
		(uvpd[PDX(va)] & PTE_P) && 
  800eeb:	f6 c1 01             	test   $0x1,%cl
  800eee:	74 0c                	je     800efc <pgfault+0x40>
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
  800ef0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800ef7:	f6 c6 08             	test   $0x8,%dh
  800efa:	75 14                	jne    800f10 <pgfault+0x54>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
		panic("No es copy-on-write");
  800efc:	83 ec 04             	sub    $0x4,%esp
  800eff:	68 58 27 80 00       	push   $0x802758
  800f04:	6a 21                	push   $0x21
  800f06:	68 e0 26 80 00       	push   $0x8026e0
  800f0b:	e8 41 f2 ff ff       	call   800151 <_panic>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	va = ROUNDDOWN(va, PGSIZE);
  800f10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f15:	89 c3                	mov    %eax,%ebx
	if (sys_page_alloc(0, PFTEMP, perm) < 0){
  800f17:	83 ec 04             	sub    $0x4,%esp
  800f1a:	6a 07                	push   $0x7
  800f1c:	68 00 f0 7f 00       	push   $0x7ff000
  800f21:	6a 00                	push   $0x0
  800f23:	e8 bd fc ff ff       	call   800be5 <sys_page_alloc>
  800f28:	83 c4 10             	add    $0x10,%esp
  800f2b:	85 c0                	test   %eax,%eax
  800f2d:	79 14                	jns    800f43 <pgfault+0x87>
		panic("Error sys_page_alloc");
  800f2f:	83 ec 04             	sub    $0x4,%esp
  800f32:	68 6c 27 80 00       	push   $0x80276c
  800f37:	6a 2a                	push   $0x2a
  800f39:	68 e0 26 80 00       	push   $0x8026e0
  800f3e:	e8 0e f2 ff ff       	call   800151 <_panic>
	}
	memcpy(PFTEMP, va, PGSIZE);
  800f43:	83 ec 04             	sub    $0x4,%esp
  800f46:	68 00 10 00 00       	push   $0x1000
  800f4b:	53                   	push   %ebx
  800f4c:	68 00 f0 7f 00       	push   $0x7ff000
  800f51:	e8 41 fa ff ff       	call   800997 <memcpy>
	if (sys_page_map(0, PFTEMP, 0, va, perm) < 0){
  800f56:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f5d:	53                   	push   %ebx
  800f5e:	6a 00                	push   $0x0
  800f60:	68 00 f0 7f 00       	push   $0x7ff000
  800f65:	6a 00                	push   $0x0
  800f67:	e8 9d fc ff ff       	call   800c09 <sys_page_map>
  800f6c:	83 c4 20             	add    $0x20,%esp
  800f6f:	85 c0                	test   %eax,%eax
  800f71:	79 14                	jns    800f87 <pgfault+0xcb>
		panic("Error sys_page_map");
  800f73:	83 ec 04             	sub    $0x4,%esp
  800f76:	68 81 27 80 00       	push   $0x802781
  800f7b:	6a 2e                	push   $0x2e
  800f7d:	68 e0 26 80 00       	push   $0x8026e0
  800f82:	e8 ca f1 ff ff       	call   800151 <_panic>
	}
	if (sys_page_unmap(0, PFTEMP) < 0){
  800f87:	83 ec 08             	sub    $0x8,%esp
  800f8a:	68 00 f0 7f 00       	push   $0x7ff000
  800f8f:	6a 00                	push   $0x0
  800f91:	e8 99 fc ff ff       	call   800c2f <sys_page_unmap>
  800f96:	83 c4 10             	add    $0x10,%esp
  800f99:	85 c0                	test   %eax,%eax
  800f9b:	79 14                	jns    800fb1 <pgfault+0xf5>
		panic("Error sys_page_unmap");
  800f9d:	83 ec 04             	sub    $0x4,%esp
  800fa0:	68 94 27 80 00       	push   $0x802794
  800fa5:	6a 31                	push   $0x31
  800fa7:	68 e0 26 80 00       	push   $0x8026e0
  800fac:	e8 a0 f1 ff ff       	call   800151 <_panic>
	}
	return;

}
  800fb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fb4:	c9                   	leave  
  800fb5:	c3                   	ret    

00800fb6 <fork_v0>:
		}
	}	
}

envid_t
fork_v0(void){
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	57                   	push   %edi
  800fba:	56                   	push   %esi
  800fbb:	53                   	push   %ebx
  800fbc:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800fbf:	b8 07 00 00 00       	mov    $0x7,%eax
  800fc4:	cd 30                	int    $0x30
  800fc6:	89 c6                	mov    %eax,%esi
	envid_t envid;
	uint8_t *va;
	int result;	

	envid = sys_exofork();
	if (envid < 0)
  800fc8:	85 c0                	test   %eax,%eax
  800fca:	79 15                	jns    800fe1 <fork_v0+0x2b>
		panic("sys_exofork: %e", envid);
  800fcc:	50                   	push   %eax
  800fcd:	68 a9 27 80 00       	push   $0x8027a9
  800fd2:	68 81 00 00 00       	push   $0x81
  800fd7:	68 e0 26 80 00       	push   $0x8026e0
  800fdc:	e8 70 f1 ff ff       	call   800151 <_panic>
  800fe1:	89 c7                	mov    %eax,%edi
  800fe3:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {		
  800fe8:	85 c0                	test   %eax,%eax
  800fea:	75 1e                	jne    80100a <fork_v0+0x54>
		thisenv = &envs[ENVX(sys_getenvid())];
  800fec:	e8 a9 fb ff ff       	call   800b9a <sys_getenvid>
  800ff1:	25 ff 03 00 00       	and    $0x3ff,%eax
  800ff6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800ff9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ffe:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  801003:	b8 00 00 00 00       	mov    $0x0,%eax
  801008:	eb 7a                	jmp    801084 <fork_v0+0xce>
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  80100a:	89 d8                	mov    %ebx,%eax
  80100c:	c1 e8 16             	shr    $0x16,%eax
  80100f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801016:	a8 01                	test   $0x1,%al
  801018:	74 33                	je     80104d <fork_v0+0x97>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  80101a:	89 d8                	mov    %ebx,%eax
  80101c:	c1 e8 0c             	shr    $0xc,%eax
  80101f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801026:	f6 c2 01             	test   $0x1,%dl
  801029:	74 22                	je     80104d <fork_v0+0x97>
  80102b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801032:	f6 c2 04             	test   $0x4,%dl
  801035:	74 16                	je     80104d <fork_v0+0x97>
				pte_t pte =uvpt[PGNUM(va)];
  801037:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
  80103e:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801044:	89 da                	mov    %ebx,%edx
  801046:	89 f8                	mov    %edi,%eax
  801048:	e8 96 fd ff ff       	call   800de3 <dup_or_share>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
  80104d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801053:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801059:	75 af                	jne    80100a <fork_v0+0x54>
				pte_t pte =uvpt[PGNUM(va)];
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
			}
		}
	}	
	if ((result = sys_env_set_status(envid, ENV_RUNNABLE)) < 0){
  80105b:	83 ec 08             	sub    $0x8,%esp
  80105e:	6a 02                	push   $0x2
  801060:	56                   	push   %esi
  801061:	e8 ec fb ff ff       	call   800c52 <sys_env_set_status>
  801066:	83 c4 10             	add    $0x10,%esp
  801069:	85 c0                	test   %eax,%eax
  80106b:	79 15                	jns    801082 <fork_v0+0xcc>

		panic("sys_env_set_status: %e", result);
  80106d:	50                   	push   %eax
  80106e:	68 b9 27 80 00       	push   $0x8027b9
  801073:	68 90 00 00 00       	push   $0x90
  801078:	68 e0 26 80 00       	push   $0x8026e0
  80107d:	e8 cf f0 ff ff       	call   800151 <_panic>
	}
	return envid;
  801082:	89 f0                	mov    %esi,%eax
}
  801084:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801087:	5b                   	pop    %ebx
  801088:	5e                   	pop    %esi
  801089:	5f                   	pop    %edi
  80108a:	5d                   	pop    %ebp
  80108b:	c3                   	ret    

0080108c <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80108c:	55                   	push   %ebp
  80108d:	89 e5                	mov    %esp,%ebp
  80108f:	57                   	push   %edi
  801090:	56                   	push   %esi
  801091:	53                   	push   %ebx
  801092:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801095:	68 bc 0e 80 00       	push   $0x800ebc
  80109a:	e8 27 0e 00 00       	call   801ec6 <set_pgfault_handler>
  80109f:	b8 07 00 00 00       	mov    $0x7,%eax
  8010a4:	cd 30                	int    $0x30
  8010a6:	89 c6                	mov    %eax,%esi

	envid_t envid;
	uint32_t va;
	envid = sys_exofork();
	if (envid < 0){
  8010a8:	83 c4 10             	add    $0x10,%esp
  8010ab:	85 c0                	test   %eax,%eax
  8010ad:	79 15                	jns    8010c4 <fork+0x38>
		panic("sys_exofork: %e", envid);
  8010af:	50                   	push   %eax
  8010b0:	68 a9 27 80 00       	push   $0x8027a9
  8010b5:	68 b1 00 00 00       	push   $0xb1
  8010ba:	68 e0 26 80 00       	push   $0x8026e0
  8010bf:	e8 8d f0 ff ff       	call   800151 <_panic>
  8010c4:	89 c7                	mov    %eax,%edi
  8010c6:	bb 00 00 00 00       	mov    $0x0,%ebx
	}
	if (envid == 0) {		
  8010cb:	85 c0                	test   %eax,%eax
  8010cd:	75 21                	jne    8010f0 <fork+0x64>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010cf:	e8 c6 fa ff ff       	call   800b9a <sys_getenvid>
  8010d4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010d9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010dc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010e1:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  8010e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010eb:	e9 a7 00 00 00       	jmp    801197 <fork+0x10b>
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  8010f0:	89 d8                	mov    %ebx,%eax
  8010f2:	c1 e8 16             	shr    $0x16,%eax
  8010f5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010fc:	a8 01                	test   $0x1,%al
  8010fe:	74 22                	je     801122 <fork+0x96>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  801100:	89 da                	mov    %ebx,%edx
  801102:	c1 ea 0c             	shr    $0xc,%edx
  801105:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80110c:	a8 01                	test   $0x1,%al
  80110e:	74 12                	je     801122 <fork+0x96>
  801110:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801117:	a8 04                	test   $0x4,%al
  801119:	74 07                	je     801122 <fork+0x96>
				duppage(envid, PGNUM(va));			
  80111b:	89 f8                	mov    %edi,%eax
  80111d:	e8 e0 fb ff ff       	call   800d02 <duppage>
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
  801122:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801128:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80112e:	75 c0                	jne    8010f0 <fork+0x64>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
				duppage(envid, PGNUM(va));			
			}
		}
	}
	if (sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P) < 0){
  801130:	83 ec 04             	sub    $0x4,%esp
  801133:	6a 07                	push   $0x7
  801135:	68 00 f0 bf ee       	push   $0xeebff000
  80113a:	56                   	push   %esi
  80113b:	e8 a5 fa ff ff       	call   800be5 <sys_page_alloc>
  801140:	83 c4 10             	add    $0x10,%esp
  801143:	85 c0                	test   %eax,%eax
  801145:	79 17                	jns    80115e <fork+0xd2>
		panic("Se escribio en la pagina de excepciones");
  801147:	83 ec 04             	sub    $0x4,%esp
  80114a:	68 e8 27 80 00       	push   $0x8027e8
  80114f:	68 c0 00 00 00       	push   $0xc0
  801154:	68 e0 26 80 00       	push   $0x8026e0
  801159:	e8 f3 ef ff ff       	call   800151 <_panic>
	}	
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80115e:	83 ec 08             	sub    $0x8,%esp
  801161:	68 35 1f 80 00       	push   $0x801f35
  801166:	56                   	push   %esi
  801167:	e8 2c fb ff ff       	call   800c98 <sys_env_set_pgfault_upcall>

	if (sys_env_set_status(envid, ENV_RUNNABLE) < 0)
  80116c:	83 c4 08             	add    $0x8,%esp
  80116f:	6a 02                	push   $0x2
  801171:	56                   	push   %esi
  801172:	e8 db fa ff ff       	call   800c52 <sys_env_set_status>
  801177:	83 c4 10             	add    $0x10,%esp
  80117a:	85 c0                	test   %eax,%eax
  80117c:	79 17                	jns    801195 <fork+0x109>
		panic("Status incorrecto de enviroment");
  80117e:	83 ec 04             	sub    $0x4,%esp
  801181:	68 10 28 80 00       	push   $0x802810
  801186:	68 c5 00 00 00       	push   $0xc5
  80118b:	68 e0 26 80 00       	push   $0x8026e0
  801190:	e8 bc ef ff ff       	call   800151 <_panic>

	return envid;
  801195:	89 f0                	mov    %esi,%eax
	
}
  801197:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80119a:	5b                   	pop    %ebx
  80119b:	5e                   	pop    %esi
  80119c:	5f                   	pop    %edi
  80119d:	5d                   	pop    %ebp
  80119e:	c3                   	ret    

0080119f <sfork>:


// Challenge!
int
sfork(void)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
  8011a2:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011a5:	68 d0 27 80 00       	push   $0x8027d0
  8011aa:	68 d1 00 00 00       	push   $0xd1
  8011af:	68 e0 26 80 00       	push   $0x8026e0
  8011b4:	e8 98 ef ff ff       	call   800151 <_panic>

008011b9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011b9:	55                   	push   %ebp
  8011ba:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	05 00 00 00 30       	add    $0x30000000,%eax
  8011c4:	c1 e8 0c             	shr    $0xc,%eax
}
  8011c7:	5d                   	pop    %ebp
  8011c8:	c3                   	ret    

008011c9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  8011cc:	ff 75 08             	pushl  0x8(%ebp)
  8011cf:	e8 e5 ff ff ff       	call   8011b9 <fd2num>
  8011d4:	83 c4 04             	add    $0x4,%esp
  8011d7:	c1 e0 0c             	shl    $0xc,%eax
  8011da:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
  8011e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011ec:	89 c2                	mov    %eax,%edx
  8011ee:	c1 ea 16             	shr    $0x16,%edx
  8011f1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011f8:	f6 c2 01             	test   $0x1,%dl
  8011fb:	74 11                	je     80120e <fd_alloc+0x2d>
  8011fd:	89 c2                	mov    %eax,%edx
  8011ff:	c1 ea 0c             	shr    $0xc,%edx
  801202:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801209:	f6 c2 01             	test   $0x1,%dl
  80120c:	75 09                	jne    801217 <fd_alloc+0x36>
			*fd_store = fd;
  80120e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801210:	b8 00 00 00 00       	mov    $0x0,%eax
  801215:	eb 17                	jmp    80122e <fd_alloc+0x4d>
  801217:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80121c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801221:	75 c9                	jne    8011ec <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801223:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801229:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80122e:	5d                   	pop    %ebp
  80122f:	c3                   	ret    

00801230 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801236:	83 f8 1f             	cmp    $0x1f,%eax
  801239:	77 36                	ja     801271 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80123b:	c1 e0 0c             	shl    $0xc,%eax
  80123e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801243:	89 c2                	mov    %eax,%edx
  801245:	c1 ea 16             	shr    $0x16,%edx
  801248:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80124f:	f6 c2 01             	test   $0x1,%dl
  801252:	74 24                	je     801278 <fd_lookup+0x48>
  801254:	89 c2                	mov    %eax,%edx
  801256:	c1 ea 0c             	shr    $0xc,%edx
  801259:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801260:	f6 c2 01             	test   $0x1,%dl
  801263:	74 1a                	je     80127f <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801265:	8b 55 0c             	mov    0xc(%ebp),%edx
  801268:	89 02                	mov    %eax,(%edx)
	return 0;
  80126a:	b8 00 00 00 00       	mov    $0x0,%eax
  80126f:	eb 13                	jmp    801284 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801271:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801276:	eb 0c                	jmp    801284 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801278:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80127d:	eb 05                	jmp    801284 <fd_lookup+0x54>
  80127f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  801284:	5d                   	pop    %ebp
  801285:	c3                   	ret    

00801286 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
  801289:	83 ec 08             	sub    $0x8,%esp
  80128c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80128f:	ba ac 28 80 00       	mov    $0x8028ac,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801294:	eb 13                	jmp    8012a9 <dev_lookup+0x23>
  801296:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  801299:	39 08                	cmp    %ecx,(%eax)
  80129b:	75 0c                	jne    8012a9 <dev_lookup+0x23>
			*dev = devtab[i];
  80129d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a7:	eb 2e                	jmp    8012d7 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8012a9:	8b 02                	mov    (%edx),%eax
  8012ab:	85 c0                	test   %eax,%eax
  8012ad:	75 e7                	jne    801296 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012af:	a1 08 40 80 00       	mov    0x804008,%eax
  8012b4:	8b 40 48             	mov    0x48(%eax),%eax
  8012b7:	83 ec 04             	sub    $0x4,%esp
  8012ba:	51                   	push   %ecx
  8012bb:	50                   	push   %eax
  8012bc:	68 30 28 80 00       	push   $0x802830
  8012c1:	e8 64 ef ff ff       	call   80022a <cprintf>
	*dev = 0;
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012cf:	83 c4 10             	add    $0x10,%esp
  8012d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012d7:	c9                   	leave  
  8012d8:	c3                   	ret    

008012d9 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
  8012dc:	56                   	push   %esi
  8012dd:	53                   	push   %ebx
  8012de:	83 ec 10             	sub    $0x10,%esp
  8012e1:	8b 75 08             	mov    0x8(%ebp),%esi
  8012e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012e7:	56                   	push   %esi
  8012e8:	e8 cc fe ff ff       	call   8011b9 <fd2num>
  8012ed:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8012f0:	89 14 24             	mov    %edx,(%esp)
  8012f3:	50                   	push   %eax
  8012f4:	e8 37 ff ff ff       	call   801230 <fd_lookup>
  8012f9:	83 c4 08             	add    $0x8,%esp
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	78 05                	js     801305 <fd_close+0x2c>
	    || fd != fd2)
  801300:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801303:	74 0c                	je     801311 <fd_close+0x38>
		return (must_exist ? r : 0);
  801305:	84 db                	test   %bl,%bl
  801307:	ba 00 00 00 00       	mov    $0x0,%edx
  80130c:	0f 44 c2             	cmove  %edx,%eax
  80130f:	eb 41                	jmp    801352 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801311:	83 ec 08             	sub    $0x8,%esp
  801314:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801317:	50                   	push   %eax
  801318:	ff 36                	pushl  (%esi)
  80131a:	e8 67 ff ff ff       	call   801286 <dev_lookup>
  80131f:	89 c3                	mov    %eax,%ebx
  801321:	83 c4 10             	add    $0x10,%esp
  801324:	85 c0                	test   %eax,%eax
  801326:	78 1a                	js     801342 <fd_close+0x69>
		if (dev->dev_close)
  801328:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80132b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80132e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801333:	85 c0                	test   %eax,%eax
  801335:	74 0b                	je     801342 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  801337:	83 ec 0c             	sub    $0xc,%esp
  80133a:	56                   	push   %esi
  80133b:	ff d0                	call   *%eax
  80133d:	89 c3                	mov    %eax,%ebx
  80133f:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801342:	83 ec 08             	sub    $0x8,%esp
  801345:	56                   	push   %esi
  801346:	6a 00                	push   $0x0
  801348:	e8 e2 f8 ff ff       	call   800c2f <sys_page_unmap>
	return r;
  80134d:	83 c4 10             	add    $0x10,%esp
  801350:	89 d8                	mov    %ebx,%eax
}
  801352:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801355:	5b                   	pop    %ebx
  801356:	5e                   	pop    %esi
  801357:	5d                   	pop    %ebp
  801358:	c3                   	ret    

00801359 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
  80135c:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80135f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801362:	50                   	push   %eax
  801363:	ff 75 08             	pushl  0x8(%ebp)
  801366:	e8 c5 fe ff ff       	call   801230 <fd_lookup>
  80136b:	83 c4 08             	add    $0x8,%esp
  80136e:	85 c0                	test   %eax,%eax
  801370:	78 10                	js     801382 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801372:	83 ec 08             	sub    $0x8,%esp
  801375:	6a 01                	push   $0x1
  801377:	ff 75 f4             	pushl  -0xc(%ebp)
  80137a:	e8 5a ff ff ff       	call   8012d9 <fd_close>
  80137f:	83 c4 10             	add    $0x10,%esp
}
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <close_all>:

void
close_all(void)
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
  801387:	53                   	push   %ebx
  801388:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80138b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801390:	83 ec 0c             	sub    $0xc,%esp
  801393:	53                   	push   %ebx
  801394:	e8 c0 ff ff ff       	call   801359 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801399:	83 c3 01             	add    $0x1,%ebx
  80139c:	83 c4 10             	add    $0x10,%esp
  80139f:	83 fb 20             	cmp    $0x20,%ebx
  8013a2:	75 ec                	jne    801390 <close_all+0xc>
		close(i);
}
  8013a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a7:	c9                   	leave  
  8013a8:	c3                   	ret    

008013a9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013a9:	55                   	push   %ebp
  8013aa:	89 e5                	mov    %esp,%ebp
  8013ac:	57                   	push   %edi
  8013ad:	56                   	push   %esi
  8013ae:	53                   	push   %ebx
  8013af:	83 ec 2c             	sub    $0x2c,%esp
  8013b2:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013b5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013b8:	50                   	push   %eax
  8013b9:	ff 75 08             	pushl  0x8(%ebp)
  8013bc:	e8 6f fe ff ff       	call   801230 <fd_lookup>
  8013c1:	83 c4 08             	add    $0x8,%esp
  8013c4:	85 c0                	test   %eax,%eax
  8013c6:	0f 88 c1 00 00 00    	js     80148d <dup+0xe4>
		return r;
	close(newfdnum);
  8013cc:	83 ec 0c             	sub    $0xc,%esp
  8013cf:	56                   	push   %esi
  8013d0:	e8 84 ff ff ff       	call   801359 <close>

	newfd = INDEX2FD(newfdnum);
  8013d5:	89 f3                	mov    %esi,%ebx
  8013d7:	c1 e3 0c             	shl    $0xc,%ebx
  8013da:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8013e0:	83 c4 04             	add    $0x4,%esp
  8013e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013e6:	e8 de fd ff ff       	call   8011c9 <fd2data>
  8013eb:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  8013ed:	89 1c 24             	mov    %ebx,(%esp)
  8013f0:	e8 d4 fd ff ff       	call   8011c9 <fd2data>
  8013f5:	83 c4 10             	add    $0x10,%esp
  8013f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013fb:	89 f8                	mov    %edi,%eax
  8013fd:	c1 e8 16             	shr    $0x16,%eax
  801400:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801407:	a8 01                	test   $0x1,%al
  801409:	74 37                	je     801442 <dup+0x99>
  80140b:	89 f8                	mov    %edi,%eax
  80140d:	c1 e8 0c             	shr    $0xc,%eax
  801410:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801417:	f6 c2 01             	test   $0x1,%dl
  80141a:	74 26                	je     801442 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80141c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801423:	83 ec 0c             	sub    $0xc,%esp
  801426:	25 07 0e 00 00       	and    $0xe07,%eax
  80142b:	50                   	push   %eax
  80142c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80142f:	6a 00                	push   $0x0
  801431:	57                   	push   %edi
  801432:	6a 00                	push   $0x0
  801434:	e8 d0 f7 ff ff       	call   800c09 <sys_page_map>
  801439:	89 c7                	mov    %eax,%edi
  80143b:	83 c4 20             	add    $0x20,%esp
  80143e:	85 c0                	test   %eax,%eax
  801440:	78 2e                	js     801470 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801442:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801445:	89 d0                	mov    %edx,%eax
  801447:	c1 e8 0c             	shr    $0xc,%eax
  80144a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801451:	83 ec 0c             	sub    $0xc,%esp
  801454:	25 07 0e 00 00       	and    $0xe07,%eax
  801459:	50                   	push   %eax
  80145a:	53                   	push   %ebx
  80145b:	6a 00                	push   $0x0
  80145d:	52                   	push   %edx
  80145e:	6a 00                	push   $0x0
  801460:	e8 a4 f7 ff ff       	call   800c09 <sys_page_map>
  801465:	89 c7                	mov    %eax,%edi
  801467:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  80146a:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80146c:	85 ff                	test   %edi,%edi
  80146e:	79 1d                	jns    80148d <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801470:	83 ec 08             	sub    $0x8,%esp
  801473:	53                   	push   %ebx
  801474:	6a 00                	push   $0x0
  801476:	e8 b4 f7 ff ff       	call   800c2f <sys_page_unmap>
	sys_page_unmap(0, nva);
  80147b:	83 c4 08             	add    $0x8,%esp
  80147e:	ff 75 d4             	pushl  -0x2c(%ebp)
  801481:	6a 00                	push   $0x0
  801483:	e8 a7 f7 ff ff       	call   800c2f <sys_page_unmap>
	return r;
  801488:	83 c4 10             	add    $0x10,%esp
  80148b:	89 f8                	mov    %edi,%eax
}
  80148d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801490:	5b                   	pop    %ebx
  801491:	5e                   	pop    %esi
  801492:	5f                   	pop    %edi
  801493:	5d                   	pop    %ebp
  801494:	c3                   	ret    

00801495 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
  801498:	53                   	push   %ebx
  801499:	83 ec 14             	sub    $0x14,%esp
  80149c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80149f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a2:	50                   	push   %eax
  8014a3:	53                   	push   %ebx
  8014a4:	e8 87 fd ff ff       	call   801230 <fd_lookup>
  8014a9:	83 c4 08             	add    $0x8,%esp
  8014ac:	89 c2                	mov    %eax,%edx
  8014ae:	85 c0                	test   %eax,%eax
  8014b0:	78 6d                	js     80151f <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b2:	83 ec 08             	sub    $0x8,%esp
  8014b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b8:	50                   	push   %eax
  8014b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014bc:	ff 30                	pushl  (%eax)
  8014be:	e8 c3 fd ff ff       	call   801286 <dev_lookup>
  8014c3:	83 c4 10             	add    $0x10,%esp
  8014c6:	85 c0                	test   %eax,%eax
  8014c8:	78 4c                	js     801516 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014cd:	8b 42 08             	mov    0x8(%edx),%eax
  8014d0:	83 e0 03             	and    $0x3,%eax
  8014d3:	83 f8 01             	cmp    $0x1,%eax
  8014d6:	75 21                	jne    8014f9 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014d8:	a1 08 40 80 00       	mov    0x804008,%eax
  8014dd:	8b 40 48             	mov    0x48(%eax),%eax
  8014e0:	83 ec 04             	sub    $0x4,%esp
  8014e3:	53                   	push   %ebx
  8014e4:	50                   	push   %eax
  8014e5:	68 71 28 80 00       	push   $0x802871
  8014ea:	e8 3b ed ff ff       	call   80022a <cprintf>
		return -E_INVAL;
  8014ef:	83 c4 10             	add    $0x10,%esp
  8014f2:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8014f7:	eb 26                	jmp    80151f <read+0x8a>
	}
	if (!dev->dev_read)
  8014f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014fc:	8b 40 08             	mov    0x8(%eax),%eax
  8014ff:	85 c0                	test   %eax,%eax
  801501:	74 17                	je     80151a <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801503:	83 ec 04             	sub    $0x4,%esp
  801506:	ff 75 10             	pushl  0x10(%ebp)
  801509:	ff 75 0c             	pushl  0xc(%ebp)
  80150c:	52                   	push   %edx
  80150d:	ff d0                	call   *%eax
  80150f:	89 c2                	mov    %eax,%edx
  801511:	83 c4 10             	add    $0x10,%esp
  801514:	eb 09                	jmp    80151f <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801516:	89 c2                	mov    %eax,%edx
  801518:	eb 05                	jmp    80151f <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80151a:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  80151f:	89 d0                	mov    %edx,%eax
  801521:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801524:	c9                   	leave  
  801525:	c3                   	ret    

00801526 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	57                   	push   %edi
  80152a:	56                   	push   %esi
  80152b:	53                   	push   %ebx
  80152c:	83 ec 0c             	sub    $0xc,%esp
  80152f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801532:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801535:	bb 00 00 00 00       	mov    $0x0,%ebx
  80153a:	eb 21                	jmp    80155d <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80153c:	83 ec 04             	sub    $0x4,%esp
  80153f:	89 f0                	mov    %esi,%eax
  801541:	29 d8                	sub    %ebx,%eax
  801543:	50                   	push   %eax
  801544:	89 d8                	mov    %ebx,%eax
  801546:	03 45 0c             	add    0xc(%ebp),%eax
  801549:	50                   	push   %eax
  80154a:	57                   	push   %edi
  80154b:	e8 45 ff ff ff       	call   801495 <read>
		if (m < 0)
  801550:	83 c4 10             	add    $0x10,%esp
  801553:	85 c0                	test   %eax,%eax
  801555:	78 10                	js     801567 <readn+0x41>
			return m;
		if (m == 0)
  801557:	85 c0                	test   %eax,%eax
  801559:	74 0a                	je     801565 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80155b:	01 c3                	add    %eax,%ebx
  80155d:	39 f3                	cmp    %esi,%ebx
  80155f:	72 db                	jb     80153c <readn+0x16>
  801561:	89 d8                	mov    %ebx,%eax
  801563:	eb 02                	jmp    801567 <readn+0x41>
  801565:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801567:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80156a:	5b                   	pop    %ebx
  80156b:	5e                   	pop    %esi
  80156c:	5f                   	pop    %edi
  80156d:	5d                   	pop    %ebp
  80156e:	c3                   	ret    

0080156f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
  801572:	53                   	push   %ebx
  801573:	83 ec 14             	sub    $0x14,%esp
  801576:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801579:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80157c:	50                   	push   %eax
  80157d:	53                   	push   %ebx
  80157e:	e8 ad fc ff ff       	call   801230 <fd_lookup>
  801583:	83 c4 08             	add    $0x8,%esp
  801586:	89 c2                	mov    %eax,%edx
  801588:	85 c0                	test   %eax,%eax
  80158a:	78 68                	js     8015f4 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80158c:	83 ec 08             	sub    $0x8,%esp
  80158f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801592:	50                   	push   %eax
  801593:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801596:	ff 30                	pushl  (%eax)
  801598:	e8 e9 fc ff ff       	call   801286 <dev_lookup>
  80159d:	83 c4 10             	add    $0x10,%esp
  8015a0:	85 c0                	test   %eax,%eax
  8015a2:	78 47                	js     8015eb <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015ab:	75 21                	jne    8015ce <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015ad:	a1 08 40 80 00       	mov    0x804008,%eax
  8015b2:	8b 40 48             	mov    0x48(%eax),%eax
  8015b5:	83 ec 04             	sub    $0x4,%esp
  8015b8:	53                   	push   %ebx
  8015b9:	50                   	push   %eax
  8015ba:	68 8d 28 80 00       	push   $0x80288d
  8015bf:	e8 66 ec ff ff       	call   80022a <cprintf>
		return -E_INVAL;
  8015c4:	83 c4 10             	add    $0x10,%esp
  8015c7:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8015cc:	eb 26                	jmp    8015f4 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d1:	8b 52 0c             	mov    0xc(%edx),%edx
  8015d4:	85 d2                	test   %edx,%edx
  8015d6:	74 17                	je     8015ef <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015d8:	83 ec 04             	sub    $0x4,%esp
  8015db:	ff 75 10             	pushl  0x10(%ebp)
  8015de:	ff 75 0c             	pushl  0xc(%ebp)
  8015e1:	50                   	push   %eax
  8015e2:	ff d2                	call   *%edx
  8015e4:	89 c2                	mov    %eax,%edx
  8015e6:	83 c4 10             	add    $0x10,%esp
  8015e9:	eb 09                	jmp    8015f4 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015eb:	89 c2                	mov    %eax,%edx
  8015ed:	eb 05                	jmp    8015f4 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8015ef:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  8015f4:	89 d0                	mov    %edx,%eax
  8015f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    

008015fb <seek>:

int
seek(int fdnum, off_t offset)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801601:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801604:	50                   	push   %eax
  801605:	ff 75 08             	pushl  0x8(%ebp)
  801608:	e8 23 fc ff ff       	call   801230 <fd_lookup>
  80160d:	83 c4 08             	add    $0x8,%esp
  801610:	85 c0                	test   %eax,%eax
  801612:	78 0e                	js     801622 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801614:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801617:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80161d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801622:	c9                   	leave  
  801623:	c3                   	ret    

00801624 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	53                   	push   %ebx
  801628:	83 ec 14             	sub    $0x14,%esp
  80162b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80162e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801631:	50                   	push   %eax
  801632:	53                   	push   %ebx
  801633:	e8 f8 fb ff ff       	call   801230 <fd_lookup>
  801638:	83 c4 08             	add    $0x8,%esp
  80163b:	89 c2                	mov    %eax,%edx
  80163d:	85 c0                	test   %eax,%eax
  80163f:	78 65                	js     8016a6 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801641:	83 ec 08             	sub    $0x8,%esp
  801644:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801647:	50                   	push   %eax
  801648:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164b:	ff 30                	pushl  (%eax)
  80164d:	e8 34 fc ff ff       	call   801286 <dev_lookup>
  801652:	83 c4 10             	add    $0x10,%esp
  801655:	85 c0                	test   %eax,%eax
  801657:	78 44                	js     80169d <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801659:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801660:	75 21                	jne    801683 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801662:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801667:	8b 40 48             	mov    0x48(%eax),%eax
  80166a:	83 ec 04             	sub    $0x4,%esp
  80166d:	53                   	push   %ebx
  80166e:	50                   	push   %eax
  80166f:	68 50 28 80 00       	push   $0x802850
  801674:	e8 b1 eb ff ff       	call   80022a <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801679:	83 c4 10             	add    $0x10,%esp
  80167c:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801681:	eb 23                	jmp    8016a6 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  801683:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801686:	8b 52 18             	mov    0x18(%edx),%edx
  801689:	85 d2                	test   %edx,%edx
  80168b:	74 14                	je     8016a1 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80168d:	83 ec 08             	sub    $0x8,%esp
  801690:	ff 75 0c             	pushl  0xc(%ebp)
  801693:	50                   	push   %eax
  801694:	ff d2                	call   *%edx
  801696:	89 c2                	mov    %eax,%edx
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	eb 09                	jmp    8016a6 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80169d:	89 c2                	mov    %eax,%edx
  80169f:	eb 05                	jmp    8016a6 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8016a1:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  8016a6:	89 d0                	mov    %edx,%eax
  8016a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	53                   	push   %ebx
  8016b1:	83 ec 14             	sub    $0x14,%esp
  8016b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016ba:	50                   	push   %eax
  8016bb:	ff 75 08             	pushl  0x8(%ebp)
  8016be:	e8 6d fb ff ff       	call   801230 <fd_lookup>
  8016c3:	83 c4 08             	add    $0x8,%esp
  8016c6:	89 c2                	mov    %eax,%edx
  8016c8:	85 c0                	test   %eax,%eax
  8016ca:	78 58                	js     801724 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016cc:	83 ec 08             	sub    $0x8,%esp
  8016cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d2:	50                   	push   %eax
  8016d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d6:	ff 30                	pushl  (%eax)
  8016d8:	e8 a9 fb ff ff       	call   801286 <dev_lookup>
  8016dd:	83 c4 10             	add    $0x10,%esp
  8016e0:	85 c0                	test   %eax,%eax
  8016e2:	78 37                	js     80171b <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  8016e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e7:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016eb:	74 32                	je     80171f <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016ed:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016f0:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016f7:	00 00 00 
	stat->st_isdir = 0;
  8016fa:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801701:	00 00 00 
	stat->st_dev = dev;
  801704:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80170a:	83 ec 08             	sub    $0x8,%esp
  80170d:	53                   	push   %ebx
  80170e:	ff 75 f0             	pushl  -0x10(%ebp)
  801711:	ff 50 14             	call   *0x14(%eax)
  801714:	89 c2                	mov    %eax,%edx
  801716:	83 c4 10             	add    $0x10,%esp
  801719:	eb 09                	jmp    801724 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80171b:	89 c2                	mov    %eax,%edx
  80171d:	eb 05                	jmp    801724 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  80171f:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801724:	89 d0                	mov    %edx,%eax
  801726:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
  80172e:	56                   	push   %esi
  80172f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801730:	83 ec 08             	sub    $0x8,%esp
  801733:	6a 00                	push   $0x0
  801735:	ff 75 08             	pushl  0x8(%ebp)
  801738:	e8 06 02 00 00       	call   801943 <open>
  80173d:	89 c3                	mov    %eax,%ebx
  80173f:	83 c4 10             	add    $0x10,%esp
  801742:	85 c0                	test   %eax,%eax
  801744:	78 1b                	js     801761 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801746:	83 ec 08             	sub    $0x8,%esp
  801749:	ff 75 0c             	pushl  0xc(%ebp)
  80174c:	50                   	push   %eax
  80174d:	e8 5b ff ff ff       	call   8016ad <fstat>
  801752:	89 c6                	mov    %eax,%esi
	close(fd);
  801754:	89 1c 24             	mov    %ebx,(%esp)
  801757:	e8 fd fb ff ff       	call   801359 <close>
	return r;
  80175c:	83 c4 10             	add    $0x10,%esp
  80175f:	89 f0                	mov    %esi,%eax
}
  801761:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801764:	5b                   	pop    %ebx
  801765:	5e                   	pop    %esi
  801766:	5d                   	pop    %ebp
  801767:	c3                   	ret    

00801768 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	56                   	push   %esi
  80176c:	53                   	push   %ebx
  80176d:	89 c6                	mov    %eax,%esi
  80176f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801771:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801778:	75 12                	jne    80178c <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80177a:	83 ec 0c             	sub    $0xc,%esp
  80177d:	6a 01                	push   $0x1
  80177f:	e8 94 08 00 00       	call   802018 <ipc_find_env>
  801784:	a3 00 40 80 00       	mov    %eax,0x804000
  801789:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80178c:	6a 07                	push   $0x7
  80178e:	68 00 50 80 00       	push   $0x805000
  801793:	56                   	push   %esi
  801794:	ff 35 00 40 80 00    	pushl  0x804000
  80179a:	e8 25 08 00 00       	call   801fc4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80179f:	83 c4 0c             	add    $0xc,%esp
  8017a2:	6a 00                	push   $0x0
  8017a4:	53                   	push   %ebx
  8017a5:	6a 00                	push   $0x0
  8017a7:	e8 ad 07 00 00       	call   801f59 <ipc_recv>
}
  8017ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017af:	5b                   	pop    %ebx
  8017b0:	5e                   	pop    %esi
  8017b1:	5d                   	pop    %ebp
  8017b2:	c3                   	ret    

008017b3 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8017bf:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c7:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d1:	b8 02 00 00 00       	mov    $0x2,%eax
  8017d6:	e8 8d ff ff ff       	call   801768 <fsipc>
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e9:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f3:	b8 06 00 00 00       	mov    $0x6,%eax
  8017f8:	e8 6b ff ff ff       	call   801768 <fsipc>
}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	53                   	push   %ebx
  801803:	83 ec 04             	sub    $0x4,%esp
  801806:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
  80180c:	8b 40 0c             	mov    0xc(%eax),%eax
  80180f:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801814:	ba 00 00 00 00       	mov    $0x0,%edx
  801819:	b8 05 00 00 00       	mov    $0x5,%eax
  80181e:	e8 45 ff ff ff       	call   801768 <fsipc>
  801823:	85 c0                	test   %eax,%eax
  801825:	78 2c                	js     801853 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801827:	83 ec 08             	sub    $0x8,%esp
  80182a:	68 00 50 80 00       	push   $0x805000
  80182f:	53                   	push   %ebx
  801830:	e8 67 ef ff ff       	call   80079c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801835:	a1 80 50 80 00       	mov    0x805080,%eax
  80183a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801840:	a1 84 50 80 00       	mov    0x805084,%eax
  801845:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80184b:	83 c4 10             	add    $0x10,%esp
  80184e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801853:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	83 ec 08             	sub    $0x8,%esp
  80185e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801861:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801864:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801867:	8b 49 0c             	mov    0xc(%ecx),%ecx
  80186a:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  801870:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801875:	76 22                	jbe    801899 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  801877:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  80187e:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  801881:	83 ec 04             	sub    $0x4,%esp
  801884:	68 f8 0f 00 00       	push   $0xff8
  801889:	52                   	push   %edx
  80188a:	68 08 50 80 00       	push   $0x805008
  80188f:	e8 9b f0 ff ff       	call   80092f <memmove>
  801894:	83 c4 10             	add    $0x10,%esp
  801897:	eb 17                	jmp    8018b0 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  801899:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  80189e:	83 ec 04             	sub    $0x4,%esp
  8018a1:	50                   	push   %eax
  8018a2:	52                   	push   %edx
  8018a3:	68 08 50 80 00       	push   $0x805008
  8018a8:	e8 82 f0 ff ff       	call   80092f <memmove>
  8018ad:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  8018b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b5:	b8 04 00 00 00       	mov    $0x4,%eax
  8018ba:	e8 a9 fe ff ff       	call   801768 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	56                   	push   %esi
  8018c5:	53                   	push   %ebx
  8018c6:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8018cf:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018d4:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018da:	ba 00 00 00 00       	mov    $0x0,%edx
  8018df:	b8 03 00 00 00       	mov    $0x3,%eax
  8018e4:	e8 7f fe ff ff       	call   801768 <fsipc>
  8018e9:	89 c3                	mov    %eax,%ebx
  8018eb:	85 c0                	test   %eax,%eax
  8018ed:	78 4b                	js     80193a <devfile_read+0x79>
		return r;
	assert(r <= n);
  8018ef:	39 c6                	cmp    %eax,%esi
  8018f1:	73 16                	jae    801909 <devfile_read+0x48>
  8018f3:	68 bc 28 80 00       	push   $0x8028bc
  8018f8:	68 c3 28 80 00       	push   $0x8028c3
  8018fd:	6a 7c                	push   $0x7c
  8018ff:	68 d8 28 80 00       	push   $0x8028d8
  801904:	e8 48 e8 ff ff       	call   800151 <_panic>
	assert(r <= PGSIZE);
  801909:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80190e:	7e 16                	jle    801926 <devfile_read+0x65>
  801910:	68 e3 28 80 00       	push   $0x8028e3
  801915:	68 c3 28 80 00       	push   $0x8028c3
  80191a:	6a 7d                	push   $0x7d
  80191c:	68 d8 28 80 00       	push   $0x8028d8
  801921:	e8 2b e8 ff ff       	call   800151 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801926:	83 ec 04             	sub    $0x4,%esp
  801929:	50                   	push   %eax
  80192a:	68 00 50 80 00       	push   $0x805000
  80192f:	ff 75 0c             	pushl  0xc(%ebp)
  801932:	e8 f8 ef ff ff       	call   80092f <memmove>
	return r;
  801937:	83 c4 10             	add    $0x10,%esp
}
  80193a:	89 d8                	mov    %ebx,%eax
  80193c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80193f:	5b                   	pop    %ebx
  801940:	5e                   	pop    %esi
  801941:	5d                   	pop    %ebp
  801942:	c3                   	ret    

00801943 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	53                   	push   %ebx
  801947:	83 ec 20             	sub    $0x20,%esp
  80194a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80194d:	53                   	push   %ebx
  80194e:	e8 10 ee ff ff       	call   800763 <strlen>
  801953:	83 c4 10             	add    $0x10,%esp
  801956:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80195b:	7f 67                	jg     8019c4 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80195d:	83 ec 0c             	sub    $0xc,%esp
  801960:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801963:	50                   	push   %eax
  801964:	e8 78 f8 ff ff       	call   8011e1 <fd_alloc>
  801969:	83 c4 10             	add    $0x10,%esp
		return r;
  80196c:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80196e:	85 c0                	test   %eax,%eax
  801970:	78 57                	js     8019c9 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801972:	83 ec 08             	sub    $0x8,%esp
  801975:	53                   	push   %ebx
  801976:	68 00 50 80 00       	push   $0x805000
  80197b:	e8 1c ee ff ff       	call   80079c <strcpy>
	fsipcbuf.open.req_omode = mode;
  801980:	8b 45 0c             	mov    0xc(%ebp),%eax
  801983:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801988:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80198b:	b8 01 00 00 00       	mov    $0x1,%eax
  801990:	e8 d3 fd ff ff       	call   801768 <fsipc>
  801995:	89 c3                	mov    %eax,%ebx
  801997:	83 c4 10             	add    $0x10,%esp
  80199a:	85 c0                	test   %eax,%eax
  80199c:	79 14                	jns    8019b2 <open+0x6f>
		fd_close(fd, 0);
  80199e:	83 ec 08             	sub    $0x8,%esp
  8019a1:	6a 00                	push   $0x0
  8019a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8019a6:	e8 2e f9 ff ff       	call   8012d9 <fd_close>
		return r;
  8019ab:	83 c4 10             	add    $0x10,%esp
  8019ae:	89 da                	mov    %ebx,%edx
  8019b0:	eb 17                	jmp    8019c9 <open+0x86>
	}

	return fd2num(fd);
  8019b2:	83 ec 0c             	sub    $0xc,%esp
  8019b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b8:	e8 fc f7 ff ff       	call   8011b9 <fd2num>
  8019bd:	89 c2                	mov    %eax,%edx
  8019bf:	83 c4 10             	add    $0x10,%esp
  8019c2:	eb 05                	jmp    8019c9 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8019c4:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8019c9:	89 d0                	mov    %edx,%eax
  8019cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
  8019d3:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8019db:	b8 08 00 00 00       	mov    $0x8,%eax
  8019e0:	e8 83 fd ff ff       	call   801768 <fsipc>
}
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
  8019ea:	56                   	push   %esi
  8019eb:	53                   	push   %ebx
  8019ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8019ef:	83 ec 0c             	sub    $0xc,%esp
  8019f2:	ff 75 08             	pushl  0x8(%ebp)
  8019f5:	e8 cf f7 ff ff       	call   8011c9 <fd2data>
  8019fa:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8019fc:	83 c4 08             	add    $0x8,%esp
  8019ff:	68 ef 28 80 00       	push   $0x8028ef
  801a04:	53                   	push   %ebx
  801a05:	e8 92 ed ff ff       	call   80079c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a0a:	8b 46 04             	mov    0x4(%esi),%eax
  801a0d:	2b 06                	sub    (%esi),%eax
  801a0f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a15:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a1c:	00 00 00 
	stat->st_dev = &devpipe;
  801a1f:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801a26:	30 80 00 
	return 0;
}
  801a29:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a31:	5b                   	pop    %ebx
  801a32:	5e                   	pop    %esi
  801a33:	5d                   	pop    %ebp
  801a34:	c3                   	ret    

00801a35 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	53                   	push   %ebx
  801a39:	83 ec 0c             	sub    $0xc,%esp
  801a3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a3f:	53                   	push   %ebx
  801a40:	6a 00                	push   $0x0
  801a42:	e8 e8 f1 ff ff       	call   800c2f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a47:	89 1c 24             	mov    %ebx,(%esp)
  801a4a:	e8 7a f7 ff ff       	call   8011c9 <fd2data>
  801a4f:	83 c4 08             	add    $0x8,%esp
  801a52:	50                   	push   %eax
  801a53:	6a 00                	push   $0x0
  801a55:	e8 d5 f1 ff ff       	call   800c2f <sys_page_unmap>
}
  801a5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	57                   	push   %edi
  801a63:	56                   	push   %esi
  801a64:	53                   	push   %ebx
  801a65:	83 ec 1c             	sub    $0x1c,%esp
  801a68:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801a6b:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801a6d:	a1 08 40 80 00       	mov    0x804008,%eax
  801a72:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801a75:	83 ec 0c             	sub    $0xc,%esp
  801a78:	ff 75 e0             	pushl  -0x20(%ebp)
  801a7b:	e8 d1 05 00 00       	call   802051 <pageref>
  801a80:	89 c3                	mov    %eax,%ebx
  801a82:	89 3c 24             	mov    %edi,(%esp)
  801a85:	e8 c7 05 00 00       	call   802051 <pageref>
  801a8a:	83 c4 10             	add    $0x10,%esp
  801a8d:	39 c3                	cmp    %eax,%ebx
  801a8f:	0f 94 c1             	sete   %cl
  801a92:	0f b6 c9             	movzbl %cl,%ecx
  801a95:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801a98:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801a9e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801aa1:	39 ce                	cmp    %ecx,%esi
  801aa3:	74 1b                	je     801ac0 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801aa5:	39 c3                	cmp    %eax,%ebx
  801aa7:	75 c4                	jne    801a6d <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801aa9:	8b 42 58             	mov    0x58(%edx),%eax
  801aac:	ff 75 e4             	pushl  -0x1c(%ebp)
  801aaf:	50                   	push   %eax
  801ab0:	56                   	push   %esi
  801ab1:	68 f6 28 80 00       	push   $0x8028f6
  801ab6:	e8 6f e7 ff ff       	call   80022a <cprintf>
  801abb:	83 c4 10             	add    $0x10,%esp
  801abe:	eb ad                	jmp    801a6d <_pipeisclosed+0xe>
	}
}
  801ac0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ac3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ac6:	5b                   	pop    %ebx
  801ac7:	5e                   	pop    %esi
  801ac8:	5f                   	pop    %edi
  801ac9:	5d                   	pop    %ebp
  801aca:	c3                   	ret    

00801acb <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	57                   	push   %edi
  801acf:	56                   	push   %esi
  801ad0:	53                   	push   %ebx
  801ad1:	83 ec 28             	sub    $0x28,%esp
  801ad4:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801ad7:	56                   	push   %esi
  801ad8:	e8 ec f6 ff ff       	call   8011c9 <fd2data>
  801add:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801adf:	83 c4 10             	add    $0x10,%esp
  801ae2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ae7:	eb 4b                	jmp    801b34 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801ae9:	89 da                	mov    %ebx,%edx
  801aeb:	89 f0                	mov    %esi,%eax
  801aed:	e8 6d ff ff ff       	call   801a5f <_pipeisclosed>
  801af2:	85 c0                	test   %eax,%eax
  801af4:	75 48                	jne    801b3e <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801af6:	e8 c3 f0 ff ff       	call   800bbe <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801afb:	8b 43 04             	mov    0x4(%ebx),%eax
  801afe:	8b 0b                	mov    (%ebx),%ecx
  801b00:	8d 51 20             	lea    0x20(%ecx),%edx
  801b03:	39 d0                	cmp    %edx,%eax
  801b05:	73 e2                	jae    801ae9 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b0a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b0e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b11:	89 c2                	mov    %eax,%edx
  801b13:	c1 fa 1f             	sar    $0x1f,%edx
  801b16:	89 d1                	mov    %edx,%ecx
  801b18:	c1 e9 1b             	shr    $0x1b,%ecx
  801b1b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801b1e:	83 e2 1f             	and    $0x1f,%edx
  801b21:	29 ca                	sub    %ecx,%edx
  801b23:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801b27:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b2b:	83 c0 01             	add    $0x1,%eax
  801b2e:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b31:	83 c7 01             	add    $0x1,%edi
  801b34:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b37:	75 c2                	jne    801afb <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801b39:	8b 45 10             	mov    0x10(%ebp),%eax
  801b3c:	eb 05                	jmp    801b43 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801b3e:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801b43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b46:	5b                   	pop    %ebx
  801b47:	5e                   	pop    %esi
  801b48:	5f                   	pop    %edi
  801b49:	5d                   	pop    %ebp
  801b4a:	c3                   	ret    

00801b4b <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
  801b4e:	57                   	push   %edi
  801b4f:	56                   	push   %esi
  801b50:	53                   	push   %ebx
  801b51:	83 ec 18             	sub    $0x18,%esp
  801b54:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801b57:	57                   	push   %edi
  801b58:	e8 6c f6 ff ff       	call   8011c9 <fd2data>
  801b5d:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b5f:	83 c4 10             	add    $0x10,%esp
  801b62:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b67:	eb 3d                	jmp    801ba6 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801b69:	85 db                	test   %ebx,%ebx
  801b6b:	74 04                	je     801b71 <devpipe_read+0x26>
				return i;
  801b6d:	89 d8                	mov    %ebx,%eax
  801b6f:	eb 44                	jmp    801bb5 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801b71:	89 f2                	mov    %esi,%edx
  801b73:	89 f8                	mov    %edi,%eax
  801b75:	e8 e5 fe ff ff       	call   801a5f <_pipeisclosed>
  801b7a:	85 c0                	test   %eax,%eax
  801b7c:	75 32                	jne    801bb0 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801b7e:	e8 3b f0 ff ff       	call   800bbe <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801b83:	8b 06                	mov    (%esi),%eax
  801b85:	3b 46 04             	cmp    0x4(%esi),%eax
  801b88:	74 df                	je     801b69 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b8a:	99                   	cltd   
  801b8b:	c1 ea 1b             	shr    $0x1b,%edx
  801b8e:	01 d0                	add    %edx,%eax
  801b90:	83 e0 1f             	and    $0x1f,%eax
  801b93:	29 d0                	sub    %edx,%eax
  801b95:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801b9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b9d:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801ba0:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ba3:	83 c3 01             	add    $0x1,%ebx
  801ba6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801ba9:	75 d8                	jne    801b83 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801bab:	8b 45 10             	mov    0x10(%ebp),%eax
  801bae:	eb 05                	jmp    801bb5 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801bb0:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801bb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bb8:	5b                   	pop    %ebx
  801bb9:	5e                   	pop    %esi
  801bba:	5f                   	pop    %edi
  801bbb:	5d                   	pop    %ebp
  801bbc:	c3                   	ret    

00801bbd <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	56                   	push   %esi
  801bc1:	53                   	push   %ebx
  801bc2:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801bc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bc8:	50                   	push   %eax
  801bc9:	e8 13 f6 ff ff       	call   8011e1 <fd_alloc>
  801bce:	83 c4 10             	add    $0x10,%esp
  801bd1:	89 c2                	mov    %eax,%edx
  801bd3:	85 c0                	test   %eax,%eax
  801bd5:	0f 88 2c 01 00 00    	js     801d07 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bdb:	83 ec 04             	sub    $0x4,%esp
  801bde:	68 07 04 00 00       	push   $0x407
  801be3:	ff 75 f4             	pushl  -0xc(%ebp)
  801be6:	6a 00                	push   $0x0
  801be8:	e8 f8 ef ff ff       	call   800be5 <sys_page_alloc>
  801bed:	83 c4 10             	add    $0x10,%esp
  801bf0:	89 c2                	mov    %eax,%edx
  801bf2:	85 c0                	test   %eax,%eax
  801bf4:	0f 88 0d 01 00 00    	js     801d07 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801bfa:	83 ec 0c             	sub    $0xc,%esp
  801bfd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c00:	50                   	push   %eax
  801c01:	e8 db f5 ff ff       	call   8011e1 <fd_alloc>
  801c06:	89 c3                	mov    %eax,%ebx
  801c08:	83 c4 10             	add    $0x10,%esp
  801c0b:	85 c0                	test   %eax,%eax
  801c0d:	0f 88 e2 00 00 00    	js     801cf5 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c13:	83 ec 04             	sub    $0x4,%esp
  801c16:	68 07 04 00 00       	push   $0x407
  801c1b:	ff 75 f0             	pushl  -0x10(%ebp)
  801c1e:	6a 00                	push   $0x0
  801c20:	e8 c0 ef ff ff       	call   800be5 <sys_page_alloc>
  801c25:	89 c3                	mov    %eax,%ebx
  801c27:	83 c4 10             	add    $0x10,%esp
  801c2a:	85 c0                	test   %eax,%eax
  801c2c:	0f 88 c3 00 00 00    	js     801cf5 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801c32:	83 ec 0c             	sub    $0xc,%esp
  801c35:	ff 75 f4             	pushl  -0xc(%ebp)
  801c38:	e8 8c f5 ff ff       	call   8011c9 <fd2data>
  801c3d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c3f:	83 c4 0c             	add    $0xc,%esp
  801c42:	68 07 04 00 00       	push   $0x407
  801c47:	50                   	push   %eax
  801c48:	6a 00                	push   $0x0
  801c4a:	e8 96 ef ff ff       	call   800be5 <sys_page_alloc>
  801c4f:	89 c3                	mov    %eax,%ebx
  801c51:	83 c4 10             	add    $0x10,%esp
  801c54:	85 c0                	test   %eax,%eax
  801c56:	0f 88 89 00 00 00    	js     801ce5 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c5c:	83 ec 0c             	sub    $0xc,%esp
  801c5f:	ff 75 f0             	pushl  -0x10(%ebp)
  801c62:	e8 62 f5 ff ff       	call   8011c9 <fd2data>
  801c67:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c6e:	50                   	push   %eax
  801c6f:	6a 00                	push   $0x0
  801c71:	56                   	push   %esi
  801c72:	6a 00                	push   $0x0
  801c74:	e8 90 ef ff ff       	call   800c09 <sys_page_map>
  801c79:	89 c3                	mov    %eax,%ebx
  801c7b:	83 c4 20             	add    $0x20,%esp
  801c7e:	85 c0                	test   %eax,%eax
  801c80:	78 55                	js     801cd7 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801c82:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c8b:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c90:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801c97:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca0:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801cac:	83 ec 0c             	sub    $0xc,%esp
  801caf:	ff 75 f4             	pushl  -0xc(%ebp)
  801cb2:	e8 02 f5 ff ff       	call   8011b9 <fd2num>
  801cb7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cba:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801cbc:	83 c4 04             	add    $0x4,%esp
  801cbf:	ff 75 f0             	pushl  -0x10(%ebp)
  801cc2:	e8 f2 f4 ff ff       	call   8011b9 <fd2num>
  801cc7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cca:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ccd:	83 c4 10             	add    $0x10,%esp
  801cd0:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd5:	eb 30                	jmp    801d07 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801cd7:	83 ec 08             	sub    $0x8,%esp
  801cda:	56                   	push   %esi
  801cdb:	6a 00                	push   $0x0
  801cdd:	e8 4d ef ff ff       	call   800c2f <sys_page_unmap>
  801ce2:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801ce5:	83 ec 08             	sub    $0x8,%esp
  801ce8:	ff 75 f0             	pushl  -0x10(%ebp)
  801ceb:	6a 00                	push   $0x0
  801ced:	e8 3d ef ff ff       	call   800c2f <sys_page_unmap>
  801cf2:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801cf5:	83 ec 08             	sub    $0x8,%esp
  801cf8:	ff 75 f4             	pushl  -0xc(%ebp)
  801cfb:	6a 00                	push   $0x0
  801cfd:	e8 2d ef ff ff       	call   800c2f <sys_page_unmap>
  801d02:	83 c4 10             	add    $0x10,%esp
  801d05:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  801d07:	89 d0                	mov    %edx,%eax
  801d09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d0c:	5b                   	pop    %ebx
  801d0d:	5e                   	pop    %esi
  801d0e:	5d                   	pop    %ebp
  801d0f:	c3                   	ret    

00801d10 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d16:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d19:	50                   	push   %eax
  801d1a:	ff 75 08             	pushl  0x8(%ebp)
  801d1d:	e8 0e f5 ff ff       	call   801230 <fd_lookup>
  801d22:	83 c4 10             	add    $0x10,%esp
  801d25:	85 c0                	test   %eax,%eax
  801d27:	78 18                	js     801d41 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801d29:	83 ec 0c             	sub    $0xc,%esp
  801d2c:	ff 75 f4             	pushl  -0xc(%ebp)
  801d2f:	e8 95 f4 ff ff       	call   8011c9 <fd2data>
	return _pipeisclosed(fd, p);
  801d34:	89 c2                	mov    %eax,%edx
  801d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d39:	e8 21 fd ff ff       	call   801a5f <_pipeisclosed>
  801d3e:	83 c4 10             	add    $0x10,%esp
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801d46:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4b:	5d                   	pop    %ebp
  801d4c:	c3                   	ret    

00801d4d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801d53:	68 0e 29 80 00       	push   $0x80290e
  801d58:	ff 75 0c             	pushl  0xc(%ebp)
  801d5b:	e8 3c ea ff ff       	call   80079c <strcpy>
	return 0;
}
  801d60:	b8 00 00 00 00       	mov    $0x0,%eax
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
  801d6a:	57                   	push   %edi
  801d6b:	56                   	push   %esi
  801d6c:	53                   	push   %ebx
  801d6d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d73:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801d78:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d7e:	eb 2d                	jmp    801dad <devcons_write+0x46>
		m = n - tot;
  801d80:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d83:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801d85:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801d88:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801d8d:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801d90:	83 ec 04             	sub    $0x4,%esp
  801d93:	53                   	push   %ebx
  801d94:	03 45 0c             	add    0xc(%ebp),%eax
  801d97:	50                   	push   %eax
  801d98:	57                   	push   %edi
  801d99:	e8 91 eb ff ff       	call   80092f <memmove>
		sys_cputs(buf, m);
  801d9e:	83 c4 08             	add    $0x8,%esp
  801da1:	53                   	push   %ebx
  801da2:	57                   	push   %edi
  801da3:	e8 86 ed ff ff       	call   800b2e <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801da8:	01 de                	add    %ebx,%esi
  801daa:	83 c4 10             	add    $0x10,%esp
  801dad:	89 f0                	mov    %esi,%eax
  801daf:	3b 75 10             	cmp    0x10(%ebp),%esi
  801db2:	72 cc                	jb     801d80 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801db4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801db7:	5b                   	pop    %ebx
  801db8:	5e                   	pop    %esi
  801db9:	5f                   	pop    %edi
  801dba:	5d                   	pop    %ebp
  801dbb:	c3                   	ret    

00801dbc <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
  801dbf:	83 ec 08             	sub    $0x8,%esp
  801dc2:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801dc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dcb:	74 2a                	je     801df7 <devcons_read+0x3b>
  801dcd:	eb 05                	jmp    801dd4 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801dcf:	e8 ea ed ff ff       	call   800bbe <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801dd4:	e8 7b ed ff ff       	call   800b54 <sys_cgetc>
  801dd9:	85 c0                	test   %eax,%eax
  801ddb:	74 f2                	je     801dcf <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801ddd:	85 c0                	test   %eax,%eax
  801ddf:	78 16                	js     801df7 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801de1:	83 f8 04             	cmp    $0x4,%eax
  801de4:	74 0c                	je     801df2 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801de6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de9:	88 02                	mov    %al,(%edx)
	return 1;
  801deb:	b8 01 00 00 00       	mov    $0x1,%eax
  801df0:	eb 05                	jmp    801df7 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801df2:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801df7:	c9                   	leave  
  801df8:	c3                   	ret    

00801df9 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801dff:	8b 45 08             	mov    0x8(%ebp),%eax
  801e02:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801e05:	6a 01                	push   $0x1
  801e07:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e0a:	50                   	push   %eax
  801e0b:	e8 1e ed ff ff       	call   800b2e <sys_cputs>
}
  801e10:	83 c4 10             	add    $0x10,%esp
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <getchar>:

int
getchar(void)
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
  801e18:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801e1b:	6a 01                	push   $0x1
  801e1d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e20:	50                   	push   %eax
  801e21:	6a 00                	push   $0x0
  801e23:	e8 6d f6 ff ff       	call   801495 <read>
	if (r < 0)
  801e28:	83 c4 10             	add    $0x10,%esp
  801e2b:	85 c0                	test   %eax,%eax
  801e2d:	78 0f                	js     801e3e <getchar+0x29>
		return r;
	if (r < 1)
  801e2f:	85 c0                	test   %eax,%eax
  801e31:	7e 06                	jle    801e39 <getchar+0x24>
		return -E_EOF;
	return c;
  801e33:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801e37:	eb 05                	jmp    801e3e <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801e39:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e46:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e49:	50                   	push   %eax
  801e4a:	ff 75 08             	pushl  0x8(%ebp)
  801e4d:	e8 de f3 ff ff       	call   801230 <fd_lookup>
  801e52:	83 c4 10             	add    $0x10,%esp
  801e55:	85 c0                	test   %eax,%eax
  801e57:	78 11                	js     801e6a <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e62:	39 10                	cmp    %edx,(%eax)
  801e64:	0f 94 c0             	sete   %al
  801e67:	0f b6 c0             	movzbl %al,%eax
}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <opencons>:

int
opencons(void)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801e72:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e75:	50                   	push   %eax
  801e76:	e8 66 f3 ff ff       	call   8011e1 <fd_alloc>
  801e7b:	83 c4 10             	add    $0x10,%esp
		return r;
  801e7e:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801e80:	85 c0                	test   %eax,%eax
  801e82:	78 3e                	js     801ec2 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e84:	83 ec 04             	sub    $0x4,%esp
  801e87:	68 07 04 00 00       	push   $0x407
  801e8c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e8f:	6a 00                	push   $0x0
  801e91:	e8 4f ed ff ff       	call   800be5 <sys_page_alloc>
  801e96:	83 c4 10             	add    $0x10,%esp
		return r;
  801e99:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e9b:	85 c0                	test   %eax,%eax
  801e9d:	78 23                	js     801ec2 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801e9f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea8:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ead:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801eb4:	83 ec 0c             	sub    $0xc,%esp
  801eb7:	50                   	push   %eax
  801eb8:	e8 fc f2 ff ff       	call   8011b9 <fd2num>
  801ebd:	89 c2                	mov    %eax,%edx
  801ebf:	83 c4 10             	add    $0x10,%esp
}
  801ec2:	89 d0                	mov    %edx,%eax
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801ecc:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801ed3:	75 2c                	jne    801f01 <set_pgfault_handler+0x3b>
		// First time through!
		// LAB 4: Your code here.
		r = sys_page_alloc(0,(void *)(UXSTACKTOP - PGSIZE),PTE_P | PTE_U | PTE_W);
  801ed5:	83 ec 04             	sub    $0x4,%esp
  801ed8:	6a 07                	push   $0x7
  801eda:	68 00 f0 bf ee       	push   $0xeebff000
  801edf:	6a 00                	push   $0x0
  801ee1:	e8 ff ec ff ff       	call   800be5 <sys_page_alloc>
		if(r < 0)
  801ee6:	83 c4 10             	add    $0x10,%esp
  801ee9:	85 c0                	test   %eax,%eax
  801eeb:	79 14                	jns    801f01 <set_pgfault_handler+0x3b>
			panic("set_pgfault_handler: error in sys_page_alloc\n");	
  801eed:	83 ec 04             	sub    $0x4,%esp
  801ef0:	68 1c 29 80 00       	push   $0x80291c
  801ef5:	6a 22                	push   $0x22
  801ef7:	68 88 29 80 00       	push   $0x802988
  801efc:	e8 50 e2 ff ff       	call   800151 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801f01:	8b 45 08             	mov    0x8(%ebp),%eax
  801f04:	a3 00 60 80 00       	mov    %eax,0x806000
	r = sys_env_set_pgfault_upcall(0, _pgfault_upcall); 
  801f09:	83 ec 08             	sub    $0x8,%esp
  801f0c:	68 35 1f 80 00       	push   $0x801f35
  801f11:	6a 00                	push   $0x0
  801f13:	e8 80 ed ff ff       	call   800c98 <sys_env_set_pgfault_upcall>
	if (r < 0)
  801f18:	83 c4 10             	add    $0x10,%esp
  801f1b:	85 c0                	test   %eax,%eax
  801f1d:	79 14                	jns    801f33 <set_pgfault_handler+0x6d>
		panic("set_pgfault_handler: error in sys_env_set_pgfault_upcall");
  801f1f:	83 ec 04             	sub    $0x4,%esp
  801f22:	68 4c 29 80 00       	push   $0x80294c
  801f27:	6a 29                	push   $0x29
  801f29:	68 88 29 80 00       	push   $0x802988
  801f2e:	e8 1e e2 ff ff       	call   800151 <_panic>
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801f35:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801f36:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801f3b:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801f3d:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	subl $0x4, 0x30(%esp)
  801f40:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  801f45:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 0x28(%esp), %ebx 	
  801f49:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  801f4d:	89 18                	mov    %ebx,(%eax)
	addl $0x8, %esp
  801f4f:	83 c4 08             	add    $0x8,%esp


	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  801f52:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp 
  801f53:	83 c4 04             	add    $0x4,%esp
	popfl
  801f56:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801f57:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801f58:	c3                   	ret    

00801f59 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
  801f5c:	56                   	push   %esi
  801f5d:	53                   	push   %ebx
  801f5e:	8b 75 08             	mov    0x8(%ebp),%esi
  801f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f64:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801f67:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801f69:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801f6e:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801f71:	83 ec 0c             	sub    $0xc,%esp
  801f74:	50                   	push   %eax
  801f75:	e8 66 ed ff ff       	call   800ce0 <sys_ipc_recv>
	if (from_env_store)
  801f7a:	83 c4 10             	add    $0x10,%esp
  801f7d:	85 f6                	test   %esi,%esi
  801f7f:	74 0b                	je     801f8c <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801f81:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f87:	8b 52 74             	mov    0x74(%edx),%edx
  801f8a:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801f8c:	85 db                	test   %ebx,%ebx
  801f8e:	74 0b                	je     801f9b <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  801f90:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f96:	8b 52 78             	mov    0x78(%edx),%edx
  801f99:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  801f9b:	85 c0                	test   %eax,%eax
  801f9d:	79 16                	jns    801fb5 <ipc_recv+0x5c>
		if (from_env_store)
  801f9f:	85 f6                	test   %esi,%esi
  801fa1:	74 06                	je     801fa9 <ipc_recv+0x50>
			*from_env_store = 0;
  801fa3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  801fa9:	85 db                	test   %ebx,%ebx
  801fab:	74 10                	je     801fbd <ipc_recv+0x64>
			*perm_store = 0;
  801fad:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801fb3:	eb 08                	jmp    801fbd <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  801fb5:	a1 08 40 80 00       	mov    0x804008,%eax
  801fba:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fbd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc0:	5b                   	pop    %ebx
  801fc1:	5e                   	pop    %esi
  801fc2:	5d                   	pop    %ebp
  801fc3:	c3                   	ret    

00801fc4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	57                   	push   %edi
  801fc8:	56                   	push   %esi
  801fc9:	53                   	push   %ebx
  801fca:	83 ec 0c             	sub    $0xc,%esp
  801fcd:	8b 7d 08             	mov    0x8(%ebp),%edi
  801fd0:	8b 75 0c             	mov    0xc(%ebp),%esi
  801fd3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  801fd6:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  801fd8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801fdd:	0f 44 d8             	cmove  %eax,%ebx
  801fe0:	eb 1c                	jmp    801ffe <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  801fe2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801fe5:	74 12                	je     801ff9 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801fe7:	50                   	push   %eax
  801fe8:	68 96 29 80 00       	push   $0x802996
  801fed:	6a 42                	push   $0x42
  801fef:	68 ac 29 80 00       	push   $0x8029ac
  801ff4:	e8 58 e1 ff ff       	call   800151 <_panic>
		sys_yield();
  801ff9:	e8 c0 eb ff ff       	call   800bbe <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801ffe:	ff 75 14             	pushl  0x14(%ebp)
  802001:	53                   	push   %ebx
  802002:	56                   	push   %esi
  802003:	57                   	push   %edi
  802004:	e8 b2 ec ff ff       	call   800cbb <sys_ipc_try_send>
  802009:	83 c4 10             	add    $0x10,%esp
  80200c:	85 c0                	test   %eax,%eax
  80200e:	75 d2                	jne    801fe2 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  802010:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802013:	5b                   	pop    %ebx
  802014:	5e                   	pop    %esi
  802015:	5f                   	pop    %edi
  802016:	5d                   	pop    %ebp
  802017:	c3                   	ret    

00802018 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80201e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802023:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802026:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80202c:	8b 52 50             	mov    0x50(%edx),%edx
  80202f:	39 ca                	cmp    %ecx,%edx
  802031:	75 0d                	jne    802040 <ipc_find_env+0x28>
			return envs[i].env_id;
  802033:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802036:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80203b:	8b 40 48             	mov    0x48(%eax),%eax
  80203e:	eb 0f                	jmp    80204f <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802040:	83 c0 01             	add    $0x1,%eax
  802043:	3d 00 04 00 00       	cmp    $0x400,%eax
  802048:	75 d9                	jne    802023 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80204a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80204f:	5d                   	pop    %ebp
  802050:	c3                   	ret    

00802051 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802057:	89 d0                	mov    %edx,%eax
  802059:	c1 e8 16             	shr    $0x16,%eax
  80205c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802063:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802068:	f6 c1 01             	test   $0x1,%cl
  80206b:	74 1d                	je     80208a <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80206d:	c1 ea 0c             	shr    $0xc,%edx
  802070:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802077:	f6 c2 01             	test   $0x1,%dl
  80207a:	74 0e                	je     80208a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80207c:	c1 ea 0c             	shr    $0xc,%edx
  80207f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802086:	ef 
  802087:	0f b7 c0             	movzwl %ax,%eax
}
  80208a:	5d                   	pop    %ebp
  80208b:	c3                   	ret    
  80208c:	66 90                	xchg   %ax,%ax
  80208e:	66 90                	xchg   %ax,%ax

00802090 <__udivdi3>:
  802090:	55                   	push   %ebp
  802091:	57                   	push   %edi
  802092:	56                   	push   %esi
  802093:	53                   	push   %ebx
  802094:	83 ec 1c             	sub    $0x1c,%esp
  802097:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80209b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80209f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8020a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020a7:	85 f6                	test   %esi,%esi
  8020a9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020ad:	89 ca                	mov    %ecx,%edx
  8020af:	89 f8                	mov    %edi,%eax
  8020b1:	75 3d                	jne    8020f0 <__udivdi3+0x60>
  8020b3:	39 cf                	cmp    %ecx,%edi
  8020b5:	0f 87 c5 00 00 00    	ja     802180 <__udivdi3+0xf0>
  8020bb:	85 ff                	test   %edi,%edi
  8020bd:	89 fd                	mov    %edi,%ebp
  8020bf:	75 0b                	jne    8020cc <__udivdi3+0x3c>
  8020c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c6:	31 d2                	xor    %edx,%edx
  8020c8:	f7 f7                	div    %edi
  8020ca:	89 c5                	mov    %eax,%ebp
  8020cc:	89 c8                	mov    %ecx,%eax
  8020ce:	31 d2                	xor    %edx,%edx
  8020d0:	f7 f5                	div    %ebp
  8020d2:	89 c1                	mov    %eax,%ecx
  8020d4:	89 d8                	mov    %ebx,%eax
  8020d6:	89 cf                	mov    %ecx,%edi
  8020d8:	f7 f5                	div    %ebp
  8020da:	89 c3                	mov    %eax,%ebx
  8020dc:	89 d8                	mov    %ebx,%eax
  8020de:	89 fa                	mov    %edi,%edx
  8020e0:	83 c4 1c             	add    $0x1c,%esp
  8020e3:	5b                   	pop    %ebx
  8020e4:	5e                   	pop    %esi
  8020e5:	5f                   	pop    %edi
  8020e6:	5d                   	pop    %ebp
  8020e7:	c3                   	ret    
  8020e8:	90                   	nop
  8020e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020f0:	39 ce                	cmp    %ecx,%esi
  8020f2:	77 74                	ja     802168 <__udivdi3+0xd8>
  8020f4:	0f bd fe             	bsr    %esi,%edi
  8020f7:	83 f7 1f             	xor    $0x1f,%edi
  8020fa:	0f 84 98 00 00 00    	je     802198 <__udivdi3+0x108>
  802100:	bb 20 00 00 00       	mov    $0x20,%ebx
  802105:	89 f9                	mov    %edi,%ecx
  802107:	89 c5                	mov    %eax,%ebp
  802109:	29 fb                	sub    %edi,%ebx
  80210b:	d3 e6                	shl    %cl,%esi
  80210d:	89 d9                	mov    %ebx,%ecx
  80210f:	d3 ed                	shr    %cl,%ebp
  802111:	89 f9                	mov    %edi,%ecx
  802113:	d3 e0                	shl    %cl,%eax
  802115:	09 ee                	or     %ebp,%esi
  802117:	89 d9                	mov    %ebx,%ecx
  802119:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80211d:	89 d5                	mov    %edx,%ebp
  80211f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802123:	d3 ed                	shr    %cl,%ebp
  802125:	89 f9                	mov    %edi,%ecx
  802127:	d3 e2                	shl    %cl,%edx
  802129:	89 d9                	mov    %ebx,%ecx
  80212b:	d3 e8                	shr    %cl,%eax
  80212d:	09 c2                	or     %eax,%edx
  80212f:	89 d0                	mov    %edx,%eax
  802131:	89 ea                	mov    %ebp,%edx
  802133:	f7 f6                	div    %esi
  802135:	89 d5                	mov    %edx,%ebp
  802137:	89 c3                	mov    %eax,%ebx
  802139:	f7 64 24 0c          	mull   0xc(%esp)
  80213d:	39 d5                	cmp    %edx,%ebp
  80213f:	72 10                	jb     802151 <__udivdi3+0xc1>
  802141:	8b 74 24 08          	mov    0x8(%esp),%esi
  802145:	89 f9                	mov    %edi,%ecx
  802147:	d3 e6                	shl    %cl,%esi
  802149:	39 c6                	cmp    %eax,%esi
  80214b:	73 07                	jae    802154 <__udivdi3+0xc4>
  80214d:	39 d5                	cmp    %edx,%ebp
  80214f:	75 03                	jne    802154 <__udivdi3+0xc4>
  802151:	83 eb 01             	sub    $0x1,%ebx
  802154:	31 ff                	xor    %edi,%edi
  802156:	89 d8                	mov    %ebx,%eax
  802158:	89 fa                	mov    %edi,%edx
  80215a:	83 c4 1c             	add    $0x1c,%esp
  80215d:	5b                   	pop    %ebx
  80215e:	5e                   	pop    %esi
  80215f:	5f                   	pop    %edi
  802160:	5d                   	pop    %ebp
  802161:	c3                   	ret    
  802162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802168:	31 ff                	xor    %edi,%edi
  80216a:	31 db                	xor    %ebx,%ebx
  80216c:	89 d8                	mov    %ebx,%eax
  80216e:	89 fa                	mov    %edi,%edx
  802170:	83 c4 1c             	add    $0x1c,%esp
  802173:	5b                   	pop    %ebx
  802174:	5e                   	pop    %esi
  802175:	5f                   	pop    %edi
  802176:	5d                   	pop    %ebp
  802177:	c3                   	ret    
  802178:	90                   	nop
  802179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802180:	89 d8                	mov    %ebx,%eax
  802182:	f7 f7                	div    %edi
  802184:	31 ff                	xor    %edi,%edi
  802186:	89 c3                	mov    %eax,%ebx
  802188:	89 d8                	mov    %ebx,%eax
  80218a:	89 fa                	mov    %edi,%edx
  80218c:	83 c4 1c             	add    $0x1c,%esp
  80218f:	5b                   	pop    %ebx
  802190:	5e                   	pop    %esi
  802191:	5f                   	pop    %edi
  802192:	5d                   	pop    %ebp
  802193:	c3                   	ret    
  802194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802198:	39 ce                	cmp    %ecx,%esi
  80219a:	72 0c                	jb     8021a8 <__udivdi3+0x118>
  80219c:	31 db                	xor    %ebx,%ebx
  80219e:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8021a2:	0f 87 34 ff ff ff    	ja     8020dc <__udivdi3+0x4c>
  8021a8:	bb 01 00 00 00       	mov    $0x1,%ebx
  8021ad:	e9 2a ff ff ff       	jmp    8020dc <__udivdi3+0x4c>
  8021b2:	66 90                	xchg   %ax,%ax
  8021b4:	66 90                	xchg   %ax,%ax
  8021b6:	66 90                	xchg   %ax,%ax
  8021b8:	66 90                	xchg   %ax,%ax
  8021ba:	66 90                	xchg   %ax,%ax
  8021bc:	66 90                	xchg   %ax,%ax
  8021be:	66 90                	xchg   %ax,%ax

008021c0 <__umoddi3>:
  8021c0:	55                   	push   %ebp
  8021c1:	57                   	push   %edi
  8021c2:	56                   	push   %esi
  8021c3:	53                   	push   %ebx
  8021c4:	83 ec 1c             	sub    $0x1c,%esp
  8021c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021cb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8021cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021d7:	85 d2                	test   %edx,%edx
  8021d9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8021dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021e1:	89 f3                	mov    %esi,%ebx
  8021e3:	89 3c 24             	mov    %edi,(%esp)
  8021e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021ea:	75 1c                	jne    802208 <__umoddi3+0x48>
  8021ec:	39 f7                	cmp    %esi,%edi
  8021ee:	76 50                	jbe    802240 <__umoddi3+0x80>
  8021f0:	89 c8                	mov    %ecx,%eax
  8021f2:	89 f2                	mov    %esi,%edx
  8021f4:	f7 f7                	div    %edi
  8021f6:	89 d0                	mov    %edx,%eax
  8021f8:	31 d2                	xor    %edx,%edx
  8021fa:	83 c4 1c             	add    $0x1c,%esp
  8021fd:	5b                   	pop    %ebx
  8021fe:	5e                   	pop    %esi
  8021ff:	5f                   	pop    %edi
  802200:	5d                   	pop    %ebp
  802201:	c3                   	ret    
  802202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802208:	39 f2                	cmp    %esi,%edx
  80220a:	89 d0                	mov    %edx,%eax
  80220c:	77 52                	ja     802260 <__umoddi3+0xa0>
  80220e:	0f bd ea             	bsr    %edx,%ebp
  802211:	83 f5 1f             	xor    $0x1f,%ebp
  802214:	75 5a                	jne    802270 <__umoddi3+0xb0>
  802216:	3b 54 24 04          	cmp    0x4(%esp),%edx
  80221a:	0f 82 e0 00 00 00    	jb     802300 <__umoddi3+0x140>
  802220:	39 0c 24             	cmp    %ecx,(%esp)
  802223:	0f 86 d7 00 00 00    	jbe    802300 <__umoddi3+0x140>
  802229:	8b 44 24 08          	mov    0x8(%esp),%eax
  80222d:	8b 54 24 04          	mov    0x4(%esp),%edx
  802231:	83 c4 1c             	add    $0x1c,%esp
  802234:	5b                   	pop    %ebx
  802235:	5e                   	pop    %esi
  802236:	5f                   	pop    %edi
  802237:	5d                   	pop    %ebp
  802238:	c3                   	ret    
  802239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802240:	85 ff                	test   %edi,%edi
  802242:	89 fd                	mov    %edi,%ebp
  802244:	75 0b                	jne    802251 <__umoddi3+0x91>
  802246:	b8 01 00 00 00       	mov    $0x1,%eax
  80224b:	31 d2                	xor    %edx,%edx
  80224d:	f7 f7                	div    %edi
  80224f:	89 c5                	mov    %eax,%ebp
  802251:	89 f0                	mov    %esi,%eax
  802253:	31 d2                	xor    %edx,%edx
  802255:	f7 f5                	div    %ebp
  802257:	89 c8                	mov    %ecx,%eax
  802259:	f7 f5                	div    %ebp
  80225b:	89 d0                	mov    %edx,%eax
  80225d:	eb 99                	jmp    8021f8 <__umoddi3+0x38>
  80225f:	90                   	nop
  802260:	89 c8                	mov    %ecx,%eax
  802262:	89 f2                	mov    %esi,%edx
  802264:	83 c4 1c             	add    $0x1c,%esp
  802267:	5b                   	pop    %ebx
  802268:	5e                   	pop    %esi
  802269:	5f                   	pop    %edi
  80226a:	5d                   	pop    %ebp
  80226b:	c3                   	ret    
  80226c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802270:	8b 34 24             	mov    (%esp),%esi
  802273:	bf 20 00 00 00       	mov    $0x20,%edi
  802278:	89 e9                	mov    %ebp,%ecx
  80227a:	29 ef                	sub    %ebp,%edi
  80227c:	d3 e0                	shl    %cl,%eax
  80227e:	89 f9                	mov    %edi,%ecx
  802280:	89 f2                	mov    %esi,%edx
  802282:	d3 ea                	shr    %cl,%edx
  802284:	89 e9                	mov    %ebp,%ecx
  802286:	09 c2                	or     %eax,%edx
  802288:	89 d8                	mov    %ebx,%eax
  80228a:	89 14 24             	mov    %edx,(%esp)
  80228d:	89 f2                	mov    %esi,%edx
  80228f:	d3 e2                	shl    %cl,%edx
  802291:	89 f9                	mov    %edi,%ecx
  802293:	89 54 24 04          	mov    %edx,0x4(%esp)
  802297:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80229b:	d3 e8                	shr    %cl,%eax
  80229d:	89 e9                	mov    %ebp,%ecx
  80229f:	89 c6                	mov    %eax,%esi
  8022a1:	d3 e3                	shl    %cl,%ebx
  8022a3:	89 f9                	mov    %edi,%ecx
  8022a5:	89 d0                	mov    %edx,%eax
  8022a7:	d3 e8                	shr    %cl,%eax
  8022a9:	89 e9                	mov    %ebp,%ecx
  8022ab:	09 d8                	or     %ebx,%eax
  8022ad:	89 d3                	mov    %edx,%ebx
  8022af:	89 f2                	mov    %esi,%edx
  8022b1:	f7 34 24             	divl   (%esp)
  8022b4:	89 d6                	mov    %edx,%esi
  8022b6:	d3 e3                	shl    %cl,%ebx
  8022b8:	f7 64 24 04          	mull   0x4(%esp)
  8022bc:	39 d6                	cmp    %edx,%esi
  8022be:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022c2:	89 d1                	mov    %edx,%ecx
  8022c4:	89 c3                	mov    %eax,%ebx
  8022c6:	72 08                	jb     8022d0 <__umoddi3+0x110>
  8022c8:	75 11                	jne    8022db <__umoddi3+0x11b>
  8022ca:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8022ce:	73 0b                	jae    8022db <__umoddi3+0x11b>
  8022d0:	2b 44 24 04          	sub    0x4(%esp),%eax
  8022d4:	1b 14 24             	sbb    (%esp),%edx
  8022d7:	89 d1                	mov    %edx,%ecx
  8022d9:	89 c3                	mov    %eax,%ebx
  8022db:	8b 54 24 08          	mov    0x8(%esp),%edx
  8022df:	29 da                	sub    %ebx,%edx
  8022e1:	19 ce                	sbb    %ecx,%esi
  8022e3:	89 f9                	mov    %edi,%ecx
  8022e5:	89 f0                	mov    %esi,%eax
  8022e7:	d3 e0                	shl    %cl,%eax
  8022e9:	89 e9                	mov    %ebp,%ecx
  8022eb:	d3 ea                	shr    %cl,%edx
  8022ed:	89 e9                	mov    %ebp,%ecx
  8022ef:	d3 ee                	shr    %cl,%esi
  8022f1:	09 d0                	or     %edx,%eax
  8022f3:	89 f2                	mov    %esi,%edx
  8022f5:	83 c4 1c             	add    $0x1c,%esp
  8022f8:	5b                   	pop    %ebx
  8022f9:	5e                   	pop    %esi
  8022fa:	5f                   	pop    %edi
  8022fb:	5d                   	pop    %ebp
  8022fc:	c3                   	ret    
  8022fd:	8d 76 00             	lea    0x0(%esi),%esi
  802300:	29 f9                	sub    %edi,%ecx
  802302:	19 d6                	sbb    %edx,%esi
  802304:	89 74 24 04          	mov    %esi,0x4(%esp)
  802308:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80230c:	e9 18 ff ff ff       	jmp    802229 <__umoddi3+0x69>
