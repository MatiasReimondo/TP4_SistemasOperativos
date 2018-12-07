
obj/user/fairness.debug:     formato del fichero elf32-i386


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
  80002c:	e8 70 00 00 00       	call   8000a1 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
	envid_t who, id;

	id = sys_getenvid();
  80003b:	e8 c8 0a 00 00       	call   800b08 <sys_getenvid>
  800040:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800042:	81 3d 04 40 80 00 7c 	cmpl   $0xeec0007c,0x804004
  800049:	00 c0 ee 
  80004c:	75 26                	jne    800074 <umain+0x41>
		while (1) {
			ipc_recv(&who, 0, 0);
  80004e:	8d 75 f4             	lea    -0xc(%ebp),%esi
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	6a 00                	push   $0x0
  800056:	6a 00                	push   $0x0
  800058:	56                   	push   %esi
  800059:	e8 12 0c 00 00       	call   800c70 <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  80005e:	83 c4 0c             	add    $0xc,%esp
  800061:	ff 75 f4             	pushl  -0xc(%ebp)
  800064:	53                   	push   %ebx
  800065:	68 a0 1d 80 00       	push   $0x801da0
  80006a:	e8 29 01 00 00       	call   800198 <cprintf>
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	eb dd                	jmp    800051 <umain+0x1e>
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  800074:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	50                   	push   %eax
  80007d:	53                   	push   %ebx
  80007e:	68 b1 1d 80 00       	push   $0x801db1
  800083:	e8 10 01 00 00       	call   800198 <cprintf>
  800088:	83 c4 10             	add    $0x10,%esp
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  80008b:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  800090:	6a 00                	push   $0x0
  800092:	6a 00                	push   $0x0
  800094:	6a 00                	push   $0x0
  800096:	50                   	push   %eax
  800097:	e8 3f 0c 00 00       	call   800cdb <ipc_send>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	eb ea                	jmp    80008b <umain+0x58>

008000a1 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000a1:	55                   	push   %ebp
  8000a2:	89 e5                	mov    %esp,%ebp
  8000a4:	56                   	push   %esi
  8000a5:	53                   	push   %ebx
  8000a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8000ac:	e8 57 0a 00 00       	call   800b08 <sys_getenvid>
	if (id >= 0)
  8000b1:	85 c0                	test   %eax,%eax
  8000b3:	78 12                	js     8000c7 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  8000b5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ba:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000bd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000c2:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c7:	85 db                	test   %ebx,%ebx
  8000c9:	7e 07                	jle    8000d2 <libmain+0x31>
		binaryname = argv[0];
  8000cb:	8b 06                	mov    (%esi),%eax
  8000cd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	56                   	push   %esi
  8000d6:	53                   	push   %ebx
  8000d7:	e8 57 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000dc:	e8 0a 00 00 00       	call   8000eb <exit>
}
  8000e1:	83 c4 10             	add    $0x10,%esp
  8000e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000e7:	5b                   	pop    %ebx
  8000e8:	5e                   	pop    %esi
  8000e9:	5d                   	pop    %ebp
  8000ea:	c3                   	ret    

008000eb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000f1:	e8 3d 0e 00 00       	call   800f33 <close_all>
	sys_env_destroy(0);
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	6a 00                	push   $0x0
  8000fb:	e8 e6 09 00 00       	call   800ae6 <sys_env_destroy>
}
  800100:	83 c4 10             	add    $0x10,%esp
  800103:	c9                   	leave  
  800104:	c3                   	ret    

00800105 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800105:	55                   	push   %ebp
  800106:	89 e5                	mov    %esp,%ebp
  800108:	53                   	push   %ebx
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80010f:	8b 13                	mov    (%ebx),%edx
  800111:	8d 42 01             	lea    0x1(%edx),%eax
  800114:	89 03                	mov    %eax,(%ebx)
  800116:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800119:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80011d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800122:	75 1a                	jne    80013e <putch+0x39>
		sys_cputs(b->buf, b->idx);
  800124:	83 ec 08             	sub    $0x8,%esp
  800127:	68 ff 00 00 00       	push   $0xff
  80012c:	8d 43 08             	lea    0x8(%ebx),%eax
  80012f:	50                   	push   %eax
  800130:	e8 67 09 00 00       	call   800a9c <sys_cputs>
		b->idx = 0;
  800135:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80013b:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  80013e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800142:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800145:	c9                   	leave  
  800146:	c3                   	ret    

00800147 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800147:	55                   	push   %ebp
  800148:	89 e5                	mov    %esp,%ebp
  80014a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800150:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800157:	00 00 00 
	b.cnt = 0;
  80015a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800161:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800164:	ff 75 0c             	pushl  0xc(%ebp)
  800167:	ff 75 08             	pushl  0x8(%ebp)
  80016a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800170:	50                   	push   %eax
  800171:	68 05 01 80 00       	push   $0x800105
  800176:	e8 86 01 00 00       	call   800301 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80017b:	83 c4 08             	add    $0x8,%esp
  80017e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800184:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80018a:	50                   	push   %eax
  80018b:	e8 0c 09 00 00       	call   800a9c <sys_cputs>

	return b.cnt;
}
  800190:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800196:	c9                   	leave  
  800197:	c3                   	ret    

00800198 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80019e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001a1:	50                   	push   %eax
  8001a2:	ff 75 08             	pushl  0x8(%ebp)
  8001a5:	e8 9d ff ff ff       	call   800147 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001aa:	c9                   	leave  
  8001ab:	c3                   	ret    

008001ac <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	57                   	push   %edi
  8001b0:	56                   	push   %esi
  8001b1:	53                   	push   %ebx
  8001b2:	83 ec 1c             	sub    $0x1c,%esp
  8001b5:	89 c7                	mov    %eax,%edi
  8001b7:	89 d6                	mov    %edx,%esi
  8001b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001c2:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001cd:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001d0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001d3:	39 d3                	cmp    %edx,%ebx
  8001d5:	72 05                	jb     8001dc <printnum+0x30>
  8001d7:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001da:	77 45                	ja     800221 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	ff 75 18             	pushl  0x18(%ebp)
  8001e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8001e5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001e8:	53                   	push   %ebx
  8001e9:	ff 75 10             	pushl  0x10(%ebp)
  8001ec:	83 ec 08             	sub    $0x8,%esp
  8001ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f2:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f5:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f8:	ff 75 d8             	pushl  -0x28(%ebp)
  8001fb:	e8 00 19 00 00       	call   801b00 <__udivdi3>
  800200:	83 c4 18             	add    $0x18,%esp
  800203:	52                   	push   %edx
  800204:	50                   	push   %eax
  800205:	89 f2                	mov    %esi,%edx
  800207:	89 f8                	mov    %edi,%eax
  800209:	e8 9e ff ff ff       	call   8001ac <printnum>
  80020e:	83 c4 20             	add    $0x20,%esp
  800211:	eb 18                	jmp    80022b <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800213:	83 ec 08             	sub    $0x8,%esp
  800216:	56                   	push   %esi
  800217:	ff 75 18             	pushl  0x18(%ebp)
  80021a:	ff d7                	call   *%edi
  80021c:	83 c4 10             	add    $0x10,%esp
  80021f:	eb 03                	jmp    800224 <printnum+0x78>
  800221:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800224:	83 eb 01             	sub    $0x1,%ebx
  800227:	85 db                	test   %ebx,%ebx
  800229:	7f e8                	jg     800213 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80022b:	83 ec 08             	sub    $0x8,%esp
  80022e:	56                   	push   %esi
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	ff 75 e4             	pushl  -0x1c(%ebp)
  800235:	ff 75 e0             	pushl  -0x20(%ebp)
  800238:	ff 75 dc             	pushl  -0x24(%ebp)
  80023b:	ff 75 d8             	pushl  -0x28(%ebp)
  80023e:	e8 ed 19 00 00       	call   801c30 <__umoddi3>
  800243:	83 c4 14             	add    $0x14,%esp
  800246:	0f be 80 d2 1d 80 00 	movsbl 0x801dd2(%eax),%eax
  80024d:	50                   	push   %eax
  80024e:	ff d7                	call   *%edi
}
  800250:	83 c4 10             	add    $0x10,%esp
  800253:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800256:	5b                   	pop    %ebx
  800257:	5e                   	pop    %esi
  800258:	5f                   	pop    %edi
  800259:	5d                   	pop    %ebp
  80025a:	c3                   	ret    

0080025b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80025e:	83 fa 01             	cmp    $0x1,%edx
  800261:	7e 0e                	jle    800271 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800263:	8b 10                	mov    (%eax),%edx
  800265:	8d 4a 08             	lea    0x8(%edx),%ecx
  800268:	89 08                	mov    %ecx,(%eax)
  80026a:	8b 02                	mov    (%edx),%eax
  80026c:	8b 52 04             	mov    0x4(%edx),%edx
  80026f:	eb 22                	jmp    800293 <getuint+0x38>
	else if (lflag)
  800271:	85 d2                	test   %edx,%edx
  800273:	74 10                	je     800285 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800275:	8b 10                	mov    (%eax),%edx
  800277:	8d 4a 04             	lea    0x4(%edx),%ecx
  80027a:	89 08                	mov    %ecx,(%eax)
  80027c:	8b 02                	mov    (%edx),%eax
  80027e:	ba 00 00 00 00       	mov    $0x0,%edx
  800283:	eb 0e                	jmp    800293 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800285:	8b 10                	mov    (%eax),%edx
  800287:	8d 4a 04             	lea    0x4(%edx),%ecx
  80028a:	89 08                	mov    %ecx,(%eax)
  80028c:	8b 02                	mov    (%edx),%eax
  80028e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800293:	5d                   	pop    %ebp
  800294:	c3                   	ret    

00800295 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800298:	83 fa 01             	cmp    $0x1,%edx
  80029b:	7e 0e                	jle    8002ab <getint+0x16>
		return va_arg(*ap, long long);
  80029d:	8b 10                	mov    (%eax),%edx
  80029f:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002a2:	89 08                	mov    %ecx,(%eax)
  8002a4:	8b 02                	mov    (%edx),%eax
  8002a6:	8b 52 04             	mov    0x4(%edx),%edx
  8002a9:	eb 1a                	jmp    8002c5 <getint+0x30>
	else if (lflag)
  8002ab:	85 d2                	test   %edx,%edx
  8002ad:	74 0c                	je     8002bb <getint+0x26>
		return va_arg(*ap, long);
  8002af:	8b 10                	mov    (%eax),%edx
  8002b1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002b4:	89 08                	mov    %ecx,(%eax)
  8002b6:	8b 02                	mov    (%edx),%eax
  8002b8:	99                   	cltd   
  8002b9:	eb 0a                	jmp    8002c5 <getint+0x30>
	else
		return va_arg(*ap, int);
  8002bb:	8b 10                	mov    (%eax),%edx
  8002bd:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002c0:	89 08                	mov    %ecx,(%eax)
  8002c2:	8b 02                	mov    (%edx),%eax
  8002c4:	99                   	cltd   
}
  8002c5:	5d                   	pop    %ebp
  8002c6:	c3                   	ret    

008002c7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002c7:	55                   	push   %ebp
  8002c8:	89 e5                	mov    %esp,%ebp
  8002ca:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002cd:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d1:	8b 10                	mov    (%eax),%edx
  8002d3:	3b 50 04             	cmp    0x4(%eax),%edx
  8002d6:	73 0a                	jae    8002e2 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002d8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002db:	89 08                	mov    %ecx,(%eax)
  8002dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e0:	88 02                	mov    %al,(%edx)
}
  8002e2:	5d                   	pop    %ebp
  8002e3:	c3                   	ret    

008002e4 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8002ea:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ed:	50                   	push   %eax
  8002ee:	ff 75 10             	pushl  0x10(%ebp)
  8002f1:	ff 75 0c             	pushl  0xc(%ebp)
  8002f4:	ff 75 08             	pushl  0x8(%ebp)
  8002f7:	e8 05 00 00 00       	call   800301 <vprintfmt>
	va_end(ap);
}
  8002fc:	83 c4 10             	add    $0x10,%esp
  8002ff:	c9                   	leave  
  800300:	c3                   	ret    

00800301 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800301:	55                   	push   %ebp
  800302:	89 e5                	mov    %esp,%ebp
  800304:	57                   	push   %edi
  800305:	56                   	push   %esi
  800306:	53                   	push   %ebx
  800307:	83 ec 2c             	sub    $0x2c,%esp
  80030a:	8b 75 08             	mov    0x8(%ebp),%esi
  80030d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800310:	8b 7d 10             	mov    0x10(%ebp),%edi
  800313:	eb 12                	jmp    800327 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800315:	85 c0                	test   %eax,%eax
  800317:	0f 84 44 03 00 00    	je     800661 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  80031d:	83 ec 08             	sub    $0x8,%esp
  800320:	53                   	push   %ebx
  800321:	50                   	push   %eax
  800322:	ff d6                	call   *%esi
  800324:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800327:	83 c7 01             	add    $0x1,%edi
  80032a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80032e:	83 f8 25             	cmp    $0x25,%eax
  800331:	75 e2                	jne    800315 <vprintfmt+0x14>
  800333:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800337:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80033e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800345:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80034c:	ba 00 00 00 00       	mov    $0x0,%edx
  800351:	eb 07                	jmp    80035a <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800353:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800356:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80035a:	8d 47 01             	lea    0x1(%edi),%eax
  80035d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800360:	0f b6 07             	movzbl (%edi),%eax
  800363:	0f b6 c8             	movzbl %al,%ecx
  800366:	83 e8 23             	sub    $0x23,%eax
  800369:	3c 55                	cmp    $0x55,%al
  80036b:	0f 87 d5 02 00 00    	ja     800646 <vprintfmt+0x345>
  800371:	0f b6 c0             	movzbl %al,%eax
  800374:	ff 24 85 20 1f 80 00 	jmp    *0x801f20(,%eax,4)
  80037b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80037e:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800382:	eb d6                	jmp    80035a <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800384:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800387:	b8 00 00 00 00       	mov    $0x0,%eax
  80038c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80038f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800392:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  800396:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  800399:	8d 51 d0             	lea    -0x30(%ecx),%edx
  80039c:	83 fa 09             	cmp    $0x9,%edx
  80039f:	77 39                	ja     8003da <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003a1:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003a4:	eb e9                	jmp    80038f <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a9:	8d 48 04             	lea    0x4(%eax),%ecx
  8003ac:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8003af:	8b 00                	mov    (%eax),%eax
  8003b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003b7:	eb 27                	jmp    8003e0 <vprintfmt+0xdf>
  8003b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003bc:	85 c0                	test   %eax,%eax
  8003be:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003c3:	0f 49 c8             	cmovns %eax,%ecx
  8003c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003cc:	eb 8c                	jmp    80035a <vprintfmt+0x59>
  8003ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8003d1:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003d8:	eb 80                	jmp    80035a <vprintfmt+0x59>
  8003da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003dd:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  8003e0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003e4:	0f 89 70 ff ff ff    	jns    80035a <vprintfmt+0x59>
				width = precision, precision = -1;
  8003ea:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f0:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003f7:	e9 5e ff ff ff       	jmp    80035a <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003fc:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800402:	e9 53 ff ff ff       	jmp    80035a <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800407:	8b 45 14             	mov    0x14(%ebp),%eax
  80040a:	8d 50 04             	lea    0x4(%eax),%edx
  80040d:	89 55 14             	mov    %edx,0x14(%ebp)
  800410:	83 ec 08             	sub    $0x8,%esp
  800413:	53                   	push   %ebx
  800414:	ff 30                	pushl  (%eax)
  800416:	ff d6                	call   *%esi
			break;
  800418:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80041b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  80041e:	e9 04 ff ff ff       	jmp    800327 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800423:	8b 45 14             	mov    0x14(%ebp),%eax
  800426:	8d 50 04             	lea    0x4(%eax),%edx
  800429:	89 55 14             	mov    %edx,0x14(%ebp)
  80042c:	8b 00                	mov    (%eax),%eax
  80042e:	99                   	cltd   
  80042f:	31 d0                	xor    %edx,%eax
  800431:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800433:	83 f8 0f             	cmp    $0xf,%eax
  800436:	7f 0b                	jg     800443 <vprintfmt+0x142>
  800438:	8b 14 85 80 20 80 00 	mov    0x802080(,%eax,4),%edx
  80043f:	85 d2                	test   %edx,%edx
  800441:	75 18                	jne    80045b <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  800443:	50                   	push   %eax
  800444:	68 ea 1d 80 00       	push   $0x801dea
  800449:	53                   	push   %ebx
  80044a:	56                   	push   %esi
  80044b:	e8 94 fe ff ff       	call   8002e4 <printfmt>
  800450:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800453:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800456:	e9 cc fe ff ff       	jmp    800327 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  80045b:	52                   	push   %edx
  80045c:	68 d1 21 80 00       	push   $0x8021d1
  800461:	53                   	push   %ebx
  800462:	56                   	push   %esi
  800463:	e8 7c fe ff ff       	call   8002e4 <printfmt>
  800468:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80046e:	e9 b4 fe ff ff       	jmp    800327 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800473:	8b 45 14             	mov    0x14(%ebp),%eax
  800476:	8d 50 04             	lea    0x4(%eax),%edx
  800479:	89 55 14             	mov    %edx,0x14(%ebp)
  80047c:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80047e:	85 ff                	test   %edi,%edi
  800480:	b8 e3 1d 80 00       	mov    $0x801de3,%eax
  800485:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800488:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80048c:	0f 8e 94 00 00 00    	jle    800526 <vprintfmt+0x225>
  800492:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800496:	0f 84 98 00 00 00    	je     800534 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  80049c:	83 ec 08             	sub    $0x8,%esp
  80049f:	ff 75 d0             	pushl  -0x30(%ebp)
  8004a2:	57                   	push   %edi
  8004a3:	e8 41 02 00 00       	call   8006e9 <strnlen>
  8004a8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ab:	29 c1                	sub    %eax,%ecx
  8004ad:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8004b0:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004b3:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ba:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004bd:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004bf:	eb 0f                	jmp    8004d0 <vprintfmt+0x1cf>
					putch(padc, putdat);
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	53                   	push   %ebx
  8004c5:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c8:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ca:	83 ef 01             	sub    $0x1,%edi
  8004cd:	83 c4 10             	add    $0x10,%esp
  8004d0:	85 ff                	test   %edi,%edi
  8004d2:	7f ed                	jg     8004c1 <vprintfmt+0x1c0>
  8004d4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004d7:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8004da:	85 c9                	test   %ecx,%ecx
  8004dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e1:	0f 49 c1             	cmovns %ecx,%eax
  8004e4:	29 c1                	sub    %eax,%ecx
  8004e6:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e9:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ec:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004ef:	89 cb                	mov    %ecx,%ebx
  8004f1:	eb 4d                	jmp    800540 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004f3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004f7:	74 1b                	je     800514 <vprintfmt+0x213>
  8004f9:	0f be c0             	movsbl %al,%eax
  8004fc:	83 e8 20             	sub    $0x20,%eax
  8004ff:	83 f8 5e             	cmp    $0x5e,%eax
  800502:	76 10                	jbe    800514 <vprintfmt+0x213>
					putch('?', putdat);
  800504:	83 ec 08             	sub    $0x8,%esp
  800507:	ff 75 0c             	pushl  0xc(%ebp)
  80050a:	6a 3f                	push   $0x3f
  80050c:	ff 55 08             	call   *0x8(%ebp)
  80050f:	83 c4 10             	add    $0x10,%esp
  800512:	eb 0d                	jmp    800521 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  800514:	83 ec 08             	sub    $0x8,%esp
  800517:	ff 75 0c             	pushl  0xc(%ebp)
  80051a:	52                   	push   %edx
  80051b:	ff 55 08             	call   *0x8(%ebp)
  80051e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800521:	83 eb 01             	sub    $0x1,%ebx
  800524:	eb 1a                	jmp    800540 <vprintfmt+0x23f>
  800526:	89 75 08             	mov    %esi,0x8(%ebp)
  800529:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80052c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80052f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800532:	eb 0c                	jmp    800540 <vprintfmt+0x23f>
  800534:	89 75 08             	mov    %esi,0x8(%ebp)
  800537:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80053a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80053d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800540:	83 c7 01             	add    $0x1,%edi
  800543:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800547:	0f be d0             	movsbl %al,%edx
  80054a:	85 d2                	test   %edx,%edx
  80054c:	74 23                	je     800571 <vprintfmt+0x270>
  80054e:	85 f6                	test   %esi,%esi
  800550:	78 a1                	js     8004f3 <vprintfmt+0x1f2>
  800552:	83 ee 01             	sub    $0x1,%esi
  800555:	79 9c                	jns    8004f3 <vprintfmt+0x1f2>
  800557:	89 df                	mov    %ebx,%edi
  800559:	8b 75 08             	mov    0x8(%ebp),%esi
  80055c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80055f:	eb 18                	jmp    800579 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800561:	83 ec 08             	sub    $0x8,%esp
  800564:	53                   	push   %ebx
  800565:	6a 20                	push   $0x20
  800567:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800569:	83 ef 01             	sub    $0x1,%edi
  80056c:	83 c4 10             	add    $0x10,%esp
  80056f:	eb 08                	jmp    800579 <vprintfmt+0x278>
  800571:	89 df                	mov    %ebx,%edi
  800573:	8b 75 08             	mov    0x8(%ebp),%esi
  800576:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800579:	85 ff                	test   %edi,%edi
  80057b:	7f e4                	jg     800561 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800580:	e9 a2 fd ff ff       	jmp    800327 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800585:	8d 45 14             	lea    0x14(%ebp),%eax
  800588:	e8 08 fd ff ff       	call   800295 <getint>
  80058d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800590:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800593:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800598:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80059c:	79 74                	jns    800612 <vprintfmt+0x311>
				putch('-', putdat);
  80059e:	83 ec 08             	sub    $0x8,%esp
  8005a1:	53                   	push   %ebx
  8005a2:	6a 2d                	push   $0x2d
  8005a4:	ff d6                	call   *%esi
				num = -(long long) num;
  8005a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005a9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005ac:	f7 d8                	neg    %eax
  8005ae:	83 d2 00             	adc    $0x0,%edx
  8005b1:	f7 da                	neg    %edx
  8005b3:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8005b6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8005bb:	eb 55                	jmp    800612 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8005bd:	8d 45 14             	lea    0x14(%ebp),%eax
  8005c0:	e8 96 fc ff ff       	call   80025b <getuint>
			base = 10;
  8005c5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8005ca:	eb 46                	jmp    800612 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8005cc:	8d 45 14             	lea    0x14(%ebp),%eax
  8005cf:	e8 87 fc ff ff       	call   80025b <getuint>
			base = 8;
  8005d4:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8005d9:	eb 37                	jmp    800612 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  8005db:	83 ec 08             	sub    $0x8,%esp
  8005de:	53                   	push   %ebx
  8005df:	6a 30                	push   $0x30
  8005e1:	ff d6                	call   *%esi
			putch('x', putdat);
  8005e3:	83 c4 08             	add    $0x8,%esp
  8005e6:	53                   	push   %ebx
  8005e7:	6a 78                	push   $0x78
  8005e9:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8005eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ee:	8d 50 04             	lea    0x4(%eax),%edx
  8005f1:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8005f4:	8b 00                	mov    (%eax),%eax
  8005f6:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8005fb:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8005fe:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800603:	eb 0d                	jmp    800612 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800605:	8d 45 14             	lea    0x14(%ebp),%eax
  800608:	e8 4e fc ff ff       	call   80025b <getuint>
			base = 16;
  80060d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800612:	83 ec 0c             	sub    $0xc,%esp
  800615:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800619:	57                   	push   %edi
  80061a:	ff 75 e0             	pushl  -0x20(%ebp)
  80061d:	51                   	push   %ecx
  80061e:	52                   	push   %edx
  80061f:	50                   	push   %eax
  800620:	89 da                	mov    %ebx,%edx
  800622:	89 f0                	mov    %esi,%eax
  800624:	e8 83 fb ff ff       	call   8001ac <printnum>
			break;
  800629:	83 c4 20             	add    $0x20,%esp
  80062c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80062f:	e9 f3 fc ff ff       	jmp    800327 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800634:	83 ec 08             	sub    $0x8,%esp
  800637:	53                   	push   %ebx
  800638:	51                   	push   %ecx
  800639:	ff d6                	call   *%esi
			break;
  80063b:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80063e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800641:	e9 e1 fc ff ff       	jmp    800327 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	53                   	push   %ebx
  80064a:	6a 25                	push   $0x25
  80064c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80064e:	83 c4 10             	add    $0x10,%esp
  800651:	eb 03                	jmp    800656 <vprintfmt+0x355>
  800653:	83 ef 01             	sub    $0x1,%edi
  800656:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  80065a:	75 f7                	jne    800653 <vprintfmt+0x352>
  80065c:	e9 c6 fc ff ff       	jmp    800327 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  800661:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800664:	5b                   	pop    %ebx
  800665:	5e                   	pop    %esi
  800666:	5f                   	pop    %edi
  800667:	5d                   	pop    %ebp
  800668:	c3                   	ret    

00800669 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800669:	55                   	push   %ebp
  80066a:	89 e5                	mov    %esp,%ebp
  80066c:	83 ec 18             	sub    $0x18,%esp
  80066f:	8b 45 08             	mov    0x8(%ebp),%eax
  800672:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800675:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800678:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80067c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80067f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800686:	85 c0                	test   %eax,%eax
  800688:	74 26                	je     8006b0 <vsnprintf+0x47>
  80068a:	85 d2                	test   %edx,%edx
  80068c:	7e 22                	jle    8006b0 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80068e:	ff 75 14             	pushl  0x14(%ebp)
  800691:	ff 75 10             	pushl  0x10(%ebp)
  800694:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800697:	50                   	push   %eax
  800698:	68 c7 02 80 00       	push   $0x8002c7
  80069d:	e8 5f fc ff ff       	call   800301 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006a5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006ab:	83 c4 10             	add    $0x10,%esp
  8006ae:	eb 05                	jmp    8006b5 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8006b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8006b5:	c9                   	leave  
  8006b6:	c3                   	ret    

008006b7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006b7:	55                   	push   %ebp
  8006b8:	89 e5                	mov    %esp,%ebp
  8006ba:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8006bd:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8006c0:	50                   	push   %eax
  8006c1:	ff 75 10             	pushl  0x10(%ebp)
  8006c4:	ff 75 0c             	pushl  0xc(%ebp)
  8006c7:	ff 75 08             	pushl  0x8(%ebp)
  8006ca:	e8 9a ff ff ff       	call   800669 <vsnprintf>
	va_end(ap);

	return rc;
}
  8006cf:	c9                   	leave  
  8006d0:	c3                   	ret    

008006d1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8006d1:	55                   	push   %ebp
  8006d2:	89 e5                	mov    %esp,%ebp
  8006d4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8006d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8006dc:	eb 03                	jmp    8006e1 <strlen+0x10>
		n++;
  8006de:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8006e1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8006e5:	75 f7                	jne    8006de <strlen+0xd>
		n++;
	return n;
}
  8006e7:	5d                   	pop    %ebp
  8006e8:	c3                   	ret    

008006e9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006ef:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8006f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f7:	eb 03                	jmp    8006fc <strnlen+0x13>
		n++;
  8006f9:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8006fc:	39 c2                	cmp    %eax,%edx
  8006fe:	74 08                	je     800708 <strnlen+0x1f>
  800700:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800704:	75 f3                	jne    8006f9 <strnlen+0x10>
  800706:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  800708:	5d                   	pop    %ebp
  800709:	c3                   	ret    

0080070a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80070a:	55                   	push   %ebp
  80070b:	89 e5                	mov    %esp,%ebp
  80070d:	53                   	push   %ebx
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800714:	89 c2                	mov    %eax,%edx
  800716:	83 c2 01             	add    $0x1,%edx
  800719:	83 c1 01             	add    $0x1,%ecx
  80071c:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800720:	88 5a ff             	mov    %bl,-0x1(%edx)
  800723:	84 db                	test   %bl,%bl
  800725:	75 ef                	jne    800716 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800727:	5b                   	pop    %ebx
  800728:	5d                   	pop    %ebp
  800729:	c3                   	ret    

0080072a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80072a:	55                   	push   %ebp
  80072b:	89 e5                	mov    %esp,%ebp
  80072d:	53                   	push   %ebx
  80072e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800731:	53                   	push   %ebx
  800732:	e8 9a ff ff ff       	call   8006d1 <strlen>
  800737:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80073a:	ff 75 0c             	pushl  0xc(%ebp)
  80073d:	01 d8                	add    %ebx,%eax
  80073f:	50                   	push   %eax
  800740:	e8 c5 ff ff ff       	call   80070a <strcpy>
	return dst;
}
  800745:	89 d8                	mov    %ebx,%eax
  800747:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80074a:	c9                   	leave  
  80074b:	c3                   	ret    

0080074c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80074c:	55                   	push   %ebp
  80074d:	89 e5                	mov    %esp,%ebp
  80074f:	56                   	push   %esi
  800750:	53                   	push   %ebx
  800751:	8b 75 08             	mov    0x8(%ebp),%esi
  800754:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800757:	89 f3                	mov    %esi,%ebx
  800759:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80075c:	89 f2                	mov    %esi,%edx
  80075e:	eb 0f                	jmp    80076f <strncpy+0x23>
		*dst++ = *src;
  800760:	83 c2 01             	add    $0x1,%edx
  800763:	0f b6 01             	movzbl (%ecx),%eax
  800766:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800769:	80 39 01             	cmpb   $0x1,(%ecx)
  80076c:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80076f:	39 da                	cmp    %ebx,%edx
  800771:	75 ed                	jne    800760 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800773:	89 f0                	mov    %esi,%eax
  800775:	5b                   	pop    %ebx
  800776:	5e                   	pop    %esi
  800777:	5d                   	pop    %ebp
  800778:	c3                   	ret    

00800779 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800779:	55                   	push   %ebp
  80077a:	89 e5                	mov    %esp,%ebp
  80077c:	56                   	push   %esi
  80077d:	53                   	push   %ebx
  80077e:	8b 75 08             	mov    0x8(%ebp),%esi
  800781:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800784:	8b 55 10             	mov    0x10(%ebp),%edx
  800787:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800789:	85 d2                	test   %edx,%edx
  80078b:	74 21                	je     8007ae <strlcpy+0x35>
  80078d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800791:	89 f2                	mov    %esi,%edx
  800793:	eb 09                	jmp    80079e <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800795:	83 c2 01             	add    $0x1,%edx
  800798:	83 c1 01             	add    $0x1,%ecx
  80079b:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80079e:	39 c2                	cmp    %eax,%edx
  8007a0:	74 09                	je     8007ab <strlcpy+0x32>
  8007a2:	0f b6 19             	movzbl (%ecx),%ebx
  8007a5:	84 db                	test   %bl,%bl
  8007a7:	75 ec                	jne    800795 <strlcpy+0x1c>
  8007a9:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  8007ab:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007ae:	29 f0                	sub    %esi,%eax
}
  8007b0:	5b                   	pop    %ebx
  8007b1:	5e                   	pop    %esi
  8007b2:	5d                   	pop    %ebp
  8007b3:	c3                   	ret    

008007b4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007b4:	55                   	push   %ebp
  8007b5:	89 e5                	mov    %esp,%ebp
  8007b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007ba:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007bd:	eb 06                	jmp    8007c5 <strcmp+0x11>
		p++, q++;
  8007bf:	83 c1 01             	add    $0x1,%ecx
  8007c2:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8007c5:	0f b6 01             	movzbl (%ecx),%eax
  8007c8:	84 c0                	test   %al,%al
  8007ca:	74 04                	je     8007d0 <strcmp+0x1c>
  8007cc:	3a 02                	cmp    (%edx),%al
  8007ce:	74 ef                	je     8007bf <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8007d0:	0f b6 c0             	movzbl %al,%eax
  8007d3:	0f b6 12             	movzbl (%edx),%edx
  8007d6:	29 d0                	sub    %edx,%eax
}
  8007d8:	5d                   	pop    %ebp
  8007d9:	c3                   	ret    

008007da <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8007da:	55                   	push   %ebp
  8007db:	89 e5                	mov    %esp,%ebp
  8007dd:	53                   	push   %ebx
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e4:	89 c3                	mov    %eax,%ebx
  8007e6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8007e9:	eb 06                	jmp    8007f1 <strncmp+0x17>
		n--, p++, q++;
  8007eb:	83 c0 01             	add    $0x1,%eax
  8007ee:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8007f1:	39 d8                	cmp    %ebx,%eax
  8007f3:	74 15                	je     80080a <strncmp+0x30>
  8007f5:	0f b6 08             	movzbl (%eax),%ecx
  8007f8:	84 c9                	test   %cl,%cl
  8007fa:	74 04                	je     800800 <strncmp+0x26>
  8007fc:	3a 0a                	cmp    (%edx),%cl
  8007fe:	74 eb                	je     8007eb <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800800:	0f b6 00             	movzbl (%eax),%eax
  800803:	0f b6 12             	movzbl (%edx),%edx
  800806:	29 d0                	sub    %edx,%eax
  800808:	eb 05                	jmp    80080f <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  80080a:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  80080f:	5b                   	pop    %ebx
  800810:	5d                   	pop    %ebp
  800811:	c3                   	ret    

00800812 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80081c:	eb 07                	jmp    800825 <strchr+0x13>
		if (*s == c)
  80081e:	38 ca                	cmp    %cl,%dl
  800820:	74 0f                	je     800831 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800822:	83 c0 01             	add    $0x1,%eax
  800825:	0f b6 10             	movzbl (%eax),%edx
  800828:	84 d2                	test   %dl,%dl
  80082a:	75 f2                	jne    80081e <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  80082c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800831:	5d                   	pop    %ebp
  800832:	c3                   	ret    

00800833 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800833:	55                   	push   %ebp
  800834:	89 e5                	mov    %esp,%ebp
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80083d:	eb 03                	jmp    800842 <strfind+0xf>
  80083f:	83 c0 01             	add    $0x1,%eax
  800842:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800845:	38 ca                	cmp    %cl,%dl
  800847:	74 04                	je     80084d <strfind+0x1a>
  800849:	84 d2                	test   %dl,%dl
  80084b:	75 f2                	jne    80083f <strfind+0xc>
			break;
	return (char *) s;
}
  80084d:	5d                   	pop    %ebp
  80084e:	c3                   	ret    

0080084f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80084f:	55                   	push   %ebp
  800850:	89 e5                	mov    %esp,%ebp
  800852:	57                   	push   %edi
  800853:	56                   	push   %esi
  800854:	53                   	push   %ebx
  800855:	8b 55 08             	mov    0x8(%ebp),%edx
  800858:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  80085b:	85 c9                	test   %ecx,%ecx
  80085d:	74 37                	je     800896 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80085f:	f6 c2 03             	test   $0x3,%dl
  800862:	75 2a                	jne    80088e <memset+0x3f>
  800864:	f6 c1 03             	test   $0x3,%cl
  800867:	75 25                	jne    80088e <memset+0x3f>
		c &= 0xFF;
  800869:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80086d:	89 df                	mov    %ebx,%edi
  80086f:	c1 e7 08             	shl    $0x8,%edi
  800872:	89 de                	mov    %ebx,%esi
  800874:	c1 e6 18             	shl    $0x18,%esi
  800877:	89 d8                	mov    %ebx,%eax
  800879:	c1 e0 10             	shl    $0x10,%eax
  80087c:	09 f0                	or     %esi,%eax
  80087e:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800880:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800883:	89 f8                	mov    %edi,%eax
  800885:	09 d8                	or     %ebx,%eax
  800887:	89 d7                	mov    %edx,%edi
  800889:	fc                   	cld    
  80088a:	f3 ab                	rep stos %eax,%es:(%edi)
  80088c:	eb 08                	jmp    800896 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80088e:	89 d7                	mov    %edx,%edi
  800890:	8b 45 0c             	mov    0xc(%ebp),%eax
  800893:	fc                   	cld    
  800894:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800896:	89 d0                	mov    %edx,%eax
  800898:	5b                   	pop    %ebx
  800899:	5e                   	pop    %esi
  80089a:	5f                   	pop    %edi
  80089b:	5d                   	pop    %ebp
  80089c:	c3                   	ret    

0080089d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	57                   	push   %edi
  8008a1:	56                   	push   %esi
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008ab:	39 c6                	cmp    %eax,%esi
  8008ad:	73 35                	jae    8008e4 <memmove+0x47>
  8008af:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008b2:	39 d0                	cmp    %edx,%eax
  8008b4:	73 2e                	jae    8008e4 <memmove+0x47>
		s += n;
		d += n;
  8008b6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008b9:	89 d6                	mov    %edx,%esi
  8008bb:	09 fe                	or     %edi,%esi
  8008bd:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008c3:	75 13                	jne    8008d8 <memmove+0x3b>
  8008c5:	f6 c1 03             	test   $0x3,%cl
  8008c8:	75 0e                	jne    8008d8 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  8008ca:	83 ef 04             	sub    $0x4,%edi
  8008cd:	8d 72 fc             	lea    -0x4(%edx),%esi
  8008d0:	c1 e9 02             	shr    $0x2,%ecx
  8008d3:	fd                   	std    
  8008d4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008d6:	eb 09                	jmp    8008e1 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8008d8:	83 ef 01             	sub    $0x1,%edi
  8008db:	8d 72 ff             	lea    -0x1(%edx),%esi
  8008de:	fd                   	std    
  8008df:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8008e1:	fc                   	cld    
  8008e2:	eb 1d                	jmp    800901 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008e4:	89 f2                	mov    %esi,%edx
  8008e6:	09 c2                	or     %eax,%edx
  8008e8:	f6 c2 03             	test   $0x3,%dl
  8008eb:	75 0f                	jne    8008fc <memmove+0x5f>
  8008ed:	f6 c1 03             	test   $0x3,%cl
  8008f0:	75 0a                	jne    8008fc <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  8008f2:	c1 e9 02             	shr    $0x2,%ecx
  8008f5:	89 c7                	mov    %eax,%edi
  8008f7:	fc                   	cld    
  8008f8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008fa:	eb 05                	jmp    800901 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8008fc:	89 c7                	mov    %eax,%edi
  8008fe:	fc                   	cld    
  8008ff:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800901:	5e                   	pop    %esi
  800902:	5f                   	pop    %edi
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800908:	ff 75 10             	pushl  0x10(%ebp)
  80090b:	ff 75 0c             	pushl  0xc(%ebp)
  80090e:	ff 75 08             	pushl  0x8(%ebp)
  800911:	e8 87 ff ff ff       	call   80089d <memmove>
}
  800916:	c9                   	leave  
  800917:	c3                   	ret    

00800918 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	56                   	push   %esi
  80091c:	53                   	push   %ebx
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	8b 55 0c             	mov    0xc(%ebp),%edx
  800923:	89 c6                	mov    %eax,%esi
  800925:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800928:	eb 1a                	jmp    800944 <memcmp+0x2c>
		if (*s1 != *s2)
  80092a:	0f b6 08             	movzbl (%eax),%ecx
  80092d:	0f b6 1a             	movzbl (%edx),%ebx
  800930:	38 d9                	cmp    %bl,%cl
  800932:	74 0a                	je     80093e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800934:	0f b6 c1             	movzbl %cl,%eax
  800937:	0f b6 db             	movzbl %bl,%ebx
  80093a:	29 d8                	sub    %ebx,%eax
  80093c:	eb 0f                	jmp    80094d <memcmp+0x35>
		s1++, s2++;
  80093e:	83 c0 01             	add    $0x1,%eax
  800941:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800944:	39 f0                	cmp    %esi,%eax
  800946:	75 e2                	jne    80092a <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800948:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80094d:	5b                   	pop    %ebx
  80094e:	5e                   	pop    %esi
  80094f:	5d                   	pop    %ebp
  800950:	c3                   	ret    

00800951 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	53                   	push   %ebx
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800958:	89 c1                	mov    %eax,%ecx
  80095a:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  80095d:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800961:	eb 0a                	jmp    80096d <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800963:	0f b6 10             	movzbl (%eax),%edx
  800966:	39 da                	cmp    %ebx,%edx
  800968:	74 07                	je     800971 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80096a:	83 c0 01             	add    $0x1,%eax
  80096d:	39 c8                	cmp    %ecx,%eax
  80096f:	72 f2                	jb     800963 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800971:	5b                   	pop    %ebx
  800972:	5d                   	pop    %ebp
  800973:	c3                   	ret    

00800974 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	57                   	push   %edi
  800978:	56                   	push   %esi
  800979:	53                   	push   %ebx
  80097a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80097d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800980:	eb 03                	jmp    800985 <strtol+0x11>
		s++;
  800982:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800985:	0f b6 01             	movzbl (%ecx),%eax
  800988:	3c 20                	cmp    $0x20,%al
  80098a:	74 f6                	je     800982 <strtol+0xe>
  80098c:	3c 09                	cmp    $0x9,%al
  80098e:	74 f2                	je     800982 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800990:	3c 2b                	cmp    $0x2b,%al
  800992:	75 0a                	jne    80099e <strtol+0x2a>
		s++;
  800994:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800997:	bf 00 00 00 00       	mov    $0x0,%edi
  80099c:	eb 11                	jmp    8009af <strtol+0x3b>
  80099e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8009a3:	3c 2d                	cmp    $0x2d,%al
  8009a5:	75 08                	jne    8009af <strtol+0x3b>
		s++, neg = 1;
  8009a7:	83 c1 01             	add    $0x1,%ecx
  8009aa:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009af:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009b5:	75 15                	jne    8009cc <strtol+0x58>
  8009b7:	80 39 30             	cmpb   $0x30,(%ecx)
  8009ba:	75 10                	jne    8009cc <strtol+0x58>
  8009bc:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8009c0:	75 7c                	jne    800a3e <strtol+0xca>
		s += 2, base = 16;
  8009c2:	83 c1 02             	add    $0x2,%ecx
  8009c5:	bb 10 00 00 00       	mov    $0x10,%ebx
  8009ca:	eb 16                	jmp    8009e2 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  8009cc:	85 db                	test   %ebx,%ebx
  8009ce:	75 12                	jne    8009e2 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009d0:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009d5:	80 39 30             	cmpb   $0x30,(%ecx)
  8009d8:	75 08                	jne    8009e2 <strtol+0x6e>
		s++, base = 8;
  8009da:	83 c1 01             	add    $0x1,%ecx
  8009dd:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  8009e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e7:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8009ea:	0f b6 11             	movzbl (%ecx),%edx
  8009ed:	8d 72 d0             	lea    -0x30(%edx),%esi
  8009f0:	89 f3                	mov    %esi,%ebx
  8009f2:	80 fb 09             	cmp    $0x9,%bl
  8009f5:	77 08                	ja     8009ff <strtol+0x8b>
			dig = *s - '0';
  8009f7:	0f be d2             	movsbl %dl,%edx
  8009fa:	83 ea 30             	sub    $0x30,%edx
  8009fd:	eb 22                	jmp    800a21 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  8009ff:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a02:	89 f3                	mov    %esi,%ebx
  800a04:	80 fb 19             	cmp    $0x19,%bl
  800a07:	77 08                	ja     800a11 <strtol+0x9d>
			dig = *s - 'a' + 10;
  800a09:	0f be d2             	movsbl %dl,%edx
  800a0c:	83 ea 57             	sub    $0x57,%edx
  800a0f:	eb 10                	jmp    800a21 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800a11:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a14:	89 f3                	mov    %esi,%ebx
  800a16:	80 fb 19             	cmp    $0x19,%bl
  800a19:	77 16                	ja     800a31 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800a1b:	0f be d2             	movsbl %dl,%edx
  800a1e:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800a21:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a24:	7d 0b                	jge    800a31 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800a26:	83 c1 01             	add    $0x1,%ecx
  800a29:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a2d:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800a2f:	eb b9                	jmp    8009ea <strtol+0x76>

	if (endptr)
  800a31:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a35:	74 0d                	je     800a44 <strtol+0xd0>
		*endptr = (char *) s;
  800a37:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a3a:	89 0e                	mov    %ecx,(%esi)
  800a3c:	eb 06                	jmp    800a44 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a3e:	85 db                	test   %ebx,%ebx
  800a40:	74 98                	je     8009da <strtol+0x66>
  800a42:	eb 9e                	jmp    8009e2 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800a44:	89 c2                	mov    %eax,%edx
  800a46:	f7 da                	neg    %edx
  800a48:	85 ff                	test   %edi,%edi
  800a4a:	0f 45 c2             	cmovne %edx,%eax
}
  800a4d:	5b                   	pop    %ebx
  800a4e:	5e                   	pop    %esi
  800a4f:	5f                   	pop    %edi
  800a50:	5d                   	pop    %ebp
  800a51:	c3                   	ret    

00800a52 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800a52:	55                   	push   %ebp
  800a53:	89 e5                	mov    %esp,%ebp
  800a55:	57                   	push   %edi
  800a56:	56                   	push   %esi
  800a57:	53                   	push   %ebx
  800a58:	83 ec 1c             	sub    $0x1c,%esp
  800a5b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a5e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a61:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800a63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a66:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a69:	8b 7d 10             	mov    0x10(%ebp),%edi
  800a6c:	8b 75 14             	mov    0x14(%ebp),%esi
  800a6f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800a71:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a75:	74 1d                	je     800a94 <syscall+0x42>
  800a77:	85 c0                	test   %eax,%eax
  800a79:	7e 19                	jle    800a94 <syscall+0x42>
  800a7b:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800a7e:	83 ec 0c             	sub    $0xc,%esp
  800a81:	50                   	push   %eax
  800a82:	52                   	push   %edx
  800a83:	68 df 20 80 00       	push   $0x8020df
  800a88:	6a 23                	push   $0x23
  800a8a:	68 fc 20 80 00       	push   $0x8020fc
  800a8f:	e8 e1 0f 00 00       	call   801a75 <_panic>

	return ret;
}
  800a94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a97:	5b                   	pop    %ebx
  800a98:	5e                   	pop    %esi
  800a99:	5f                   	pop    %edi
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    

00800a9c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800aa2:	6a 00                	push   $0x0
  800aa4:	6a 00                	push   $0x0
  800aa6:	6a 00                	push   $0x0
  800aa8:	ff 75 0c             	pushl  0xc(%ebp)
  800aab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aae:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab8:	e8 95 ff ff ff       	call   800a52 <syscall>
}
  800abd:	83 c4 10             	add    $0x10,%esp
  800ac0:	c9                   	leave  
  800ac1:	c3                   	ret    

00800ac2 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ac2:	55                   	push   %ebp
  800ac3:	89 e5                	mov    %esp,%ebp
  800ac5:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800ac8:	6a 00                	push   $0x0
  800aca:	6a 00                	push   $0x0
  800acc:	6a 00                	push   $0x0
  800ace:	6a 00                	push   $0x0
  800ad0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ad5:	ba 00 00 00 00       	mov    $0x0,%edx
  800ada:	b8 01 00 00 00       	mov    $0x1,%eax
  800adf:	e8 6e ff ff ff       	call   800a52 <syscall>
}
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800aec:	6a 00                	push   $0x0
  800aee:	6a 00                	push   $0x0
  800af0:	6a 00                	push   $0x0
  800af2:	6a 00                	push   $0x0
  800af4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af7:	ba 01 00 00 00       	mov    $0x1,%edx
  800afc:	b8 03 00 00 00       	mov    $0x3,%eax
  800b01:	e8 4c ff ff ff       	call   800a52 <syscall>
}
  800b06:	c9                   	leave  
  800b07:	c3                   	ret    

00800b08 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b0e:	6a 00                	push   $0x0
  800b10:	6a 00                	push   $0x0
  800b12:	6a 00                	push   $0x0
  800b14:	6a 00                	push   $0x0
  800b16:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b20:	b8 02 00 00 00       	mov    $0x2,%eax
  800b25:	e8 28 ff ff ff       	call   800a52 <syscall>
}
  800b2a:	c9                   	leave  
  800b2b:	c3                   	ret    

00800b2c <sys_yield>:

void
sys_yield(void)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b32:	6a 00                	push   $0x0
  800b34:	6a 00                	push   $0x0
  800b36:	6a 00                	push   $0x0
  800b38:	6a 00                	push   $0x0
  800b3a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b44:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b49:	e8 04 ff ff ff       	call   800a52 <syscall>
}
  800b4e:	83 c4 10             	add    $0x10,%esp
  800b51:	c9                   	leave  
  800b52:	c3                   	ret    

00800b53 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800b59:	6a 00                	push   $0x0
  800b5b:	6a 00                	push   $0x0
  800b5d:	ff 75 10             	pushl  0x10(%ebp)
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b66:	ba 01 00 00 00       	mov    $0x1,%edx
  800b6b:	b8 04 00 00 00       	mov    $0x4,%eax
  800b70:	e8 dd fe ff ff       	call   800a52 <syscall>
}
  800b75:	c9                   	leave  
  800b76:	c3                   	ret    

00800b77 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800b7d:	ff 75 18             	pushl  0x18(%ebp)
  800b80:	ff 75 14             	pushl  0x14(%ebp)
  800b83:	ff 75 10             	pushl  0x10(%ebp)
  800b86:	ff 75 0c             	pushl  0xc(%ebp)
  800b89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b8c:	ba 01 00 00 00       	mov    $0x1,%edx
  800b91:	b8 05 00 00 00       	mov    $0x5,%eax
  800b96:	e8 b7 fe ff ff       	call   800a52 <syscall>
}
  800b9b:	c9                   	leave  
  800b9c:	c3                   	ret    

00800b9d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800ba3:	6a 00                	push   $0x0
  800ba5:	6a 00                	push   $0x0
  800ba7:	6a 00                	push   $0x0
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800baf:	ba 01 00 00 00       	mov    $0x1,%edx
  800bb4:	b8 06 00 00 00       	mov    $0x6,%eax
  800bb9:	e8 94 fe ff ff       	call   800a52 <syscall>
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800bc6:	6a 00                	push   $0x0
  800bc8:	6a 00                	push   $0x0
  800bca:	6a 00                	push   $0x0
  800bcc:	ff 75 0c             	pushl  0xc(%ebp)
  800bcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd2:	ba 01 00 00 00       	mov    $0x1,%edx
  800bd7:	b8 08 00 00 00       	mov    $0x8,%eax
  800bdc:	e8 71 fe ff ff       	call   800a52 <syscall>
}
  800be1:	c9                   	leave  
  800be2:	c3                   	ret    

00800be3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800be9:	6a 00                	push   $0x0
  800beb:	6a 00                	push   $0x0
  800bed:	6a 00                	push   $0x0
  800bef:	ff 75 0c             	pushl  0xc(%ebp)
  800bf2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf5:	ba 01 00 00 00       	mov    $0x1,%edx
  800bfa:	b8 09 00 00 00       	mov    $0x9,%eax
  800bff:	e8 4e fe ff ff       	call   800a52 <syscall>
}
  800c04:	c9                   	leave  
  800c05:	c3                   	ret    

00800c06 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800c0c:	6a 00                	push   $0x0
  800c0e:	6a 00                	push   $0x0
  800c10:	6a 00                	push   $0x0
  800c12:	ff 75 0c             	pushl  0xc(%ebp)
  800c15:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c18:	ba 01 00 00 00       	mov    $0x1,%edx
  800c1d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c22:	e8 2b fe ff ff       	call   800a52 <syscall>
}
  800c27:	c9                   	leave  
  800c28:	c3                   	ret    

00800c29 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800c2f:	6a 00                	push   $0x0
  800c31:	ff 75 14             	pushl  0x14(%ebp)
  800c34:	ff 75 10             	pushl  0x10(%ebp)
  800c37:	ff 75 0c             	pushl  0xc(%ebp)
  800c3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c42:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c47:	e8 06 fe ff ff       	call   800a52 <syscall>
}
  800c4c:	c9                   	leave  
  800c4d:	c3                   	ret    

00800c4e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800c54:	6a 00                	push   $0x0
  800c56:	6a 00                	push   $0x0
  800c58:	6a 00                	push   $0x0
  800c5a:	6a 00                	push   $0x0
  800c5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c5f:	ba 01 00 00 00       	mov    $0x1,%edx
  800c64:	b8 0d 00 00 00       	mov    $0xd,%eax
  800c69:	e8 e4 fd ff ff       	call   800a52 <syscall>
}
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	56                   	push   %esi
  800c74:	53                   	push   %ebx
  800c75:	8b 75 08             	mov    0x8(%ebp),%esi
  800c78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  800c7e:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  800c80:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  800c85:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  800c88:	83 ec 0c             	sub    $0xc,%esp
  800c8b:	50                   	push   %eax
  800c8c:	e8 bd ff ff ff       	call   800c4e <sys_ipc_recv>
	if (from_env_store)
  800c91:	83 c4 10             	add    $0x10,%esp
  800c94:	85 f6                	test   %esi,%esi
  800c96:	74 0b                	je     800ca3 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  800c98:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800c9e:	8b 52 74             	mov    0x74(%edx),%edx
  800ca1:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  800ca3:	85 db                	test   %ebx,%ebx
  800ca5:	74 0b                	je     800cb2 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  800ca7:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800cad:	8b 52 78             	mov    0x78(%edx),%edx
  800cb0:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  800cb2:	85 c0                	test   %eax,%eax
  800cb4:	79 16                	jns    800ccc <ipc_recv+0x5c>
		if (from_env_store)
  800cb6:	85 f6                	test   %esi,%esi
  800cb8:	74 06                	je     800cc0 <ipc_recv+0x50>
			*from_env_store = 0;
  800cba:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  800cc0:	85 db                	test   %ebx,%ebx
  800cc2:	74 10                	je     800cd4 <ipc_recv+0x64>
			*perm_store = 0;
  800cc4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800cca:	eb 08                	jmp    800cd4 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  800ccc:	a1 04 40 80 00       	mov    0x804004,%eax
  800cd1:	8b 40 70             	mov    0x70(%eax),%eax
}
  800cd4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cd7:	5b                   	pop    %ebx
  800cd8:	5e                   	pop    %esi
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    

00800cdb <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	57                   	push   %edi
  800cdf:	56                   	push   %esi
  800ce0:	53                   	push   %ebx
  800ce1:	83 ec 0c             	sub    $0xc,%esp
  800ce4:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ce7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cea:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  800ced:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  800cef:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  800cf4:	0f 44 d8             	cmove  %eax,%ebx
  800cf7:	eb 1c                	jmp    800d15 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  800cf9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  800cfc:	74 12                	je     800d10 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  800cfe:	50                   	push   %eax
  800cff:	68 0a 21 80 00       	push   $0x80210a
  800d04:	6a 42                	push   $0x42
  800d06:	68 20 21 80 00       	push   $0x802120
  800d0b:	e8 65 0d 00 00       	call   801a75 <_panic>
		sys_yield();
  800d10:	e8 17 fe ff ff       	call   800b2c <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  800d15:	ff 75 14             	pushl  0x14(%ebp)
  800d18:	53                   	push   %ebx
  800d19:	56                   	push   %esi
  800d1a:	57                   	push   %edi
  800d1b:	e8 09 ff ff ff       	call   800c29 <sys_ipc_try_send>
  800d20:	83 c4 10             	add    $0x10,%esp
  800d23:	85 c0                	test   %eax,%eax
  800d25:	75 d2                	jne    800cf9 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  800d27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2a:	5b                   	pop    %ebx
  800d2b:	5e                   	pop    %esi
  800d2c:	5f                   	pop    %edi
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    

00800d2f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  800d35:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  800d3a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  800d3d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800d43:	8b 52 50             	mov    0x50(%edx),%edx
  800d46:	39 ca                	cmp    %ecx,%edx
  800d48:	75 0d                	jne    800d57 <ipc_find_env+0x28>
			return envs[i].env_id;
  800d4a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800d4d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800d52:	8b 40 48             	mov    0x48(%eax),%eax
  800d55:	eb 0f                	jmp    800d66 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  800d57:	83 c0 01             	add    $0x1,%eax
  800d5a:	3d 00 04 00 00       	cmp    $0x400,%eax
  800d5f:	75 d9                	jne    800d3a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  800d61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d66:	5d                   	pop    %ebp
  800d67:	c3                   	ret    

00800d68 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	05 00 00 00 30       	add    $0x30000000,%eax
  800d73:	c1 e8 0c             	shr    $0xc,%eax
}
  800d76:	5d                   	pop    %ebp
  800d77:	c3                   	ret    

00800d78 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  800d7b:	ff 75 08             	pushl  0x8(%ebp)
  800d7e:	e8 e5 ff ff ff       	call   800d68 <fd2num>
  800d83:	83 c4 04             	add    $0x4,%esp
  800d86:	c1 e0 0c             	shl    $0xc,%eax
  800d89:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800d8e:	c9                   	leave  
  800d8f:	c3                   	ret    

00800d90 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d96:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800d9b:	89 c2                	mov    %eax,%edx
  800d9d:	c1 ea 16             	shr    $0x16,%edx
  800da0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800da7:	f6 c2 01             	test   $0x1,%dl
  800daa:	74 11                	je     800dbd <fd_alloc+0x2d>
  800dac:	89 c2                	mov    %eax,%edx
  800dae:	c1 ea 0c             	shr    $0xc,%edx
  800db1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800db8:	f6 c2 01             	test   $0x1,%dl
  800dbb:	75 09                	jne    800dc6 <fd_alloc+0x36>
			*fd_store = fd;
  800dbd:	89 01                	mov    %eax,(%ecx)
			return 0;
  800dbf:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc4:	eb 17                	jmp    800ddd <fd_alloc+0x4d>
  800dc6:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800dcb:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800dd0:	75 c9                	jne    800d9b <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800dd2:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800dd8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    

00800ddf <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800de5:	83 f8 1f             	cmp    $0x1f,%eax
  800de8:	77 36                	ja     800e20 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800dea:	c1 e0 0c             	shl    $0xc,%eax
  800ded:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800df2:	89 c2                	mov    %eax,%edx
  800df4:	c1 ea 16             	shr    $0x16,%edx
  800df7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800dfe:	f6 c2 01             	test   $0x1,%dl
  800e01:	74 24                	je     800e27 <fd_lookup+0x48>
  800e03:	89 c2                	mov    %eax,%edx
  800e05:	c1 ea 0c             	shr    $0xc,%edx
  800e08:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e0f:	f6 c2 01             	test   $0x1,%dl
  800e12:	74 1a                	je     800e2e <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e17:	89 02                	mov    %eax,(%edx)
	return 0;
  800e19:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1e:	eb 13                	jmp    800e33 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800e20:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e25:	eb 0c                	jmp    800e33 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800e27:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e2c:	eb 05                	jmp    800e33 <fd_lookup+0x54>
  800e2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800e33:	5d                   	pop    %ebp
  800e34:	c3                   	ret    

00800e35 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
  800e38:	83 ec 08             	sub    $0x8,%esp
  800e3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e3e:	ba a8 21 80 00       	mov    $0x8021a8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800e43:	eb 13                	jmp    800e58 <dev_lookup+0x23>
  800e45:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  800e48:	39 08                	cmp    %ecx,(%eax)
  800e4a:	75 0c                	jne    800e58 <dev_lookup+0x23>
			*dev = devtab[i];
  800e4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4f:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e51:	b8 00 00 00 00       	mov    $0x0,%eax
  800e56:	eb 2e                	jmp    800e86 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800e58:	8b 02                	mov    (%edx),%eax
  800e5a:	85 c0                	test   %eax,%eax
  800e5c:	75 e7                	jne    800e45 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e5e:	a1 04 40 80 00       	mov    0x804004,%eax
  800e63:	8b 40 48             	mov    0x48(%eax),%eax
  800e66:	83 ec 04             	sub    $0x4,%esp
  800e69:	51                   	push   %ecx
  800e6a:	50                   	push   %eax
  800e6b:	68 2c 21 80 00       	push   $0x80212c
  800e70:	e8 23 f3 ff ff       	call   800198 <cprintf>
	*dev = 0;
  800e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e7e:	83 c4 10             	add    $0x10,%esp
  800e81:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e86:	c9                   	leave  
  800e87:	c3                   	ret    

00800e88 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	56                   	push   %esi
  800e8c:	53                   	push   %ebx
  800e8d:	83 ec 10             	sub    $0x10,%esp
  800e90:	8b 75 08             	mov    0x8(%ebp),%esi
  800e93:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e96:	56                   	push   %esi
  800e97:	e8 cc fe ff ff       	call   800d68 <fd2num>
  800e9c:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800e9f:	89 14 24             	mov    %edx,(%esp)
  800ea2:	50                   	push   %eax
  800ea3:	e8 37 ff ff ff       	call   800ddf <fd_lookup>
  800ea8:	83 c4 08             	add    $0x8,%esp
  800eab:	85 c0                	test   %eax,%eax
  800ead:	78 05                	js     800eb4 <fd_close+0x2c>
	    || fd != fd2)
  800eaf:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800eb2:	74 0c                	je     800ec0 <fd_close+0x38>
		return (must_exist ? r : 0);
  800eb4:	84 db                	test   %bl,%bl
  800eb6:	ba 00 00 00 00       	mov    $0x0,%edx
  800ebb:	0f 44 c2             	cmove  %edx,%eax
  800ebe:	eb 41                	jmp    800f01 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800ec0:	83 ec 08             	sub    $0x8,%esp
  800ec3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ec6:	50                   	push   %eax
  800ec7:	ff 36                	pushl  (%esi)
  800ec9:	e8 67 ff ff ff       	call   800e35 <dev_lookup>
  800ece:	89 c3                	mov    %eax,%ebx
  800ed0:	83 c4 10             	add    $0x10,%esp
  800ed3:	85 c0                	test   %eax,%eax
  800ed5:	78 1a                	js     800ef1 <fd_close+0x69>
		if (dev->dev_close)
  800ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eda:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800edd:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800ee2:	85 c0                	test   %eax,%eax
  800ee4:	74 0b                	je     800ef1 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  800ee6:	83 ec 0c             	sub    $0xc,%esp
  800ee9:	56                   	push   %esi
  800eea:	ff d0                	call   *%eax
  800eec:	89 c3                	mov    %eax,%ebx
  800eee:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800ef1:	83 ec 08             	sub    $0x8,%esp
  800ef4:	56                   	push   %esi
  800ef5:	6a 00                	push   $0x0
  800ef7:	e8 a1 fc ff ff       	call   800b9d <sys_page_unmap>
	return r;
  800efc:	83 c4 10             	add    $0x10,%esp
  800eff:	89 d8                	mov    %ebx,%eax
}
  800f01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f04:	5b                   	pop    %ebx
  800f05:	5e                   	pop    %esi
  800f06:	5d                   	pop    %ebp
  800f07:	c3                   	ret    

00800f08 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f0e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f11:	50                   	push   %eax
  800f12:	ff 75 08             	pushl  0x8(%ebp)
  800f15:	e8 c5 fe ff ff       	call   800ddf <fd_lookup>
  800f1a:	83 c4 08             	add    $0x8,%esp
  800f1d:	85 c0                	test   %eax,%eax
  800f1f:	78 10                	js     800f31 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800f21:	83 ec 08             	sub    $0x8,%esp
  800f24:	6a 01                	push   $0x1
  800f26:	ff 75 f4             	pushl  -0xc(%ebp)
  800f29:	e8 5a ff ff ff       	call   800e88 <fd_close>
  800f2e:	83 c4 10             	add    $0x10,%esp
}
  800f31:	c9                   	leave  
  800f32:	c3                   	ret    

00800f33 <close_all>:

void
close_all(void)
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	53                   	push   %ebx
  800f37:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f3a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f3f:	83 ec 0c             	sub    $0xc,%esp
  800f42:	53                   	push   %ebx
  800f43:	e8 c0 ff ff ff       	call   800f08 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800f48:	83 c3 01             	add    $0x1,%ebx
  800f4b:	83 c4 10             	add    $0x10,%esp
  800f4e:	83 fb 20             	cmp    $0x20,%ebx
  800f51:	75 ec                	jne    800f3f <close_all+0xc>
		close(i);
}
  800f53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f56:	c9                   	leave  
  800f57:	c3                   	ret    

00800f58 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	57                   	push   %edi
  800f5c:	56                   	push   %esi
  800f5d:	53                   	push   %ebx
  800f5e:	83 ec 2c             	sub    $0x2c,%esp
  800f61:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f64:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f67:	50                   	push   %eax
  800f68:	ff 75 08             	pushl  0x8(%ebp)
  800f6b:	e8 6f fe ff ff       	call   800ddf <fd_lookup>
  800f70:	83 c4 08             	add    $0x8,%esp
  800f73:	85 c0                	test   %eax,%eax
  800f75:	0f 88 c1 00 00 00    	js     80103c <dup+0xe4>
		return r;
	close(newfdnum);
  800f7b:	83 ec 0c             	sub    $0xc,%esp
  800f7e:	56                   	push   %esi
  800f7f:	e8 84 ff ff ff       	call   800f08 <close>

	newfd = INDEX2FD(newfdnum);
  800f84:	89 f3                	mov    %esi,%ebx
  800f86:	c1 e3 0c             	shl    $0xc,%ebx
  800f89:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800f8f:	83 c4 04             	add    $0x4,%esp
  800f92:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f95:	e8 de fd ff ff       	call   800d78 <fd2data>
  800f9a:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  800f9c:	89 1c 24             	mov    %ebx,(%esp)
  800f9f:	e8 d4 fd ff ff       	call   800d78 <fd2data>
  800fa4:	83 c4 10             	add    $0x10,%esp
  800fa7:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800faa:	89 f8                	mov    %edi,%eax
  800fac:	c1 e8 16             	shr    $0x16,%eax
  800faf:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fb6:	a8 01                	test   $0x1,%al
  800fb8:	74 37                	je     800ff1 <dup+0x99>
  800fba:	89 f8                	mov    %edi,%eax
  800fbc:	c1 e8 0c             	shr    $0xc,%eax
  800fbf:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fc6:	f6 c2 01             	test   $0x1,%dl
  800fc9:	74 26                	je     800ff1 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800fcb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fd2:	83 ec 0c             	sub    $0xc,%esp
  800fd5:	25 07 0e 00 00       	and    $0xe07,%eax
  800fda:	50                   	push   %eax
  800fdb:	ff 75 d4             	pushl  -0x2c(%ebp)
  800fde:	6a 00                	push   $0x0
  800fe0:	57                   	push   %edi
  800fe1:	6a 00                	push   $0x0
  800fe3:	e8 8f fb ff ff       	call   800b77 <sys_page_map>
  800fe8:	89 c7                	mov    %eax,%edi
  800fea:	83 c4 20             	add    $0x20,%esp
  800fed:	85 c0                	test   %eax,%eax
  800fef:	78 2e                	js     80101f <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800ff1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ff4:	89 d0                	mov    %edx,%eax
  800ff6:	c1 e8 0c             	shr    $0xc,%eax
  800ff9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801000:	83 ec 0c             	sub    $0xc,%esp
  801003:	25 07 0e 00 00       	and    $0xe07,%eax
  801008:	50                   	push   %eax
  801009:	53                   	push   %ebx
  80100a:	6a 00                	push   $0x0
  80100c:	52                   	push   %edx
  80100d:	6a 00                	push   $0x0
  80100f:	e8 63 fb ff ff       	call   800b77 <sys_page_map>
  801014:	89 c7                	mov    %eax,%edi
  801016:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  801019:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80101b:	85 ff                	test   %edi,%edi
  80101d:	79 1d                	jns    80103c <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80101f:	83 ec 08             	sub    $0x8,%esp
  801022:	53                   	push   %ebx
  801023:	6a 00                	push   $0x0
  801025:	e8 73 fb ff ff       	call   800b9d <sys_page_unmap>
	sys_page_unmap(0, nva);
  80102a:	83 c4 08             	add    $0x8,%esp
  80102d:	ff 75 d4             	pushl  -0x2c(%ebp)
  801030:	6a 00                	push   $0x0
  801032:	e8 66 fb ff ff       	call   800b9d <sys_page_unmap>
	return r;
  801037:	83 c4 10             	add    $0x10,%esp
  80103a:	89 f8                	mov    %edi,%eax
}
  80103c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80103f:	5b                   	pop    %ebx
  801040:	5e                   	pop    %esi
  801041:	5f                   	pop    %edi
  801042:	5d                   	pop    %ebp
  801043:	c3                   	ret    

00801044 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
  801047:	53                   	push   %ebx
  801048:	83 ec 14             	sub    $0x14,%esp
  80104b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80104e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801051:	50                   	push   %eax
  801052:	53                   	push   %ebx
  801053:	e8 87 fd ff ff       	call   800ddf <fd_lookup>
  801058:	83 c4 08             	add    $0x8,%esp
  80105b:	89 c2                	mov    %eax,%edx
  80105d:	85 c0                	test   %eax,%eax
  80105f:	78 6d                	js     8010ce <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801061:	83 ec 08             	sub    $0x8,%esp
  801064:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801067:	50                   	push   %eax
  801068:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106b:	ff 30                	pushl  (%eax)
  80106d:	e8 c3 fd ff ff       	call   800e35 <dev_lookup>
  801072:	83 c4 10             	add    $0x10,%esp
  801075:	85 c0                	test   %eax,%eax
  801077:	78 4c                	js     8010c5 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801079:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80107c:	8b 42 08             	mov    0x8(%edx),%eax
  80107f:	83 e0 03             	and    $0x3,%eax
  801082:	83 f8 01             	cmp    $0x1,%eax
  801085:	75 21                	jne    8010a8 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801087:	a1 04 40 80 00       	mov    0x804004,%eax
  80108c:	8b 40 48             	mov    0x48(%eax),%eax
  80108f:	83 ec 04             	sub    $0x4,%esp
  801092:	53                   	push   %ebx
  801093:	50                   	push   %eax
  801094:	68 6d 21 80 00       	push   $0x80216d
  801099:	e8 fa f0 ff ff       	call   800198 <cprintf>
		return -E_INVAL;
  80109e:	83 c4 10             	add    $0x10,%esp
  8010a1:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8010a6:	eb 26                	jmp    8010ce <read+0x8a>
	}
	if (!dev->dev_read)
  8010a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ab:	8b 40 08             	mov    0x8(%eax),%eax
  8010ae:	85 c0                	test   %eax,%eax
  8010b0:	74 17                	je     8010c9 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8010b2:	83 ec 04             	sub    $0x4,%esp
  8010b5:	ff 75 10             	pushl  0x10(%ebp)
  8010b8:	ff 75 0c             	pushl  0xc(%ebp)
  8010bb:	52                   	push   %edx
  8010bc:	ff d0                	call   *%eax
  8010be:	89 c2                	mov    %eax,%edx
  8010c0:	83 c4 10             	add    $0x10,%esp
  8010c3:	eb 09                	jmp    8010ce <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010c5:	89 c2                	mov    %eax,%edx
  8010c7:	eb 05                	jmp    8010ce <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8010c9:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  8010ce:	89 d0                	mov    %edx,%eax
  8010d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    

008010d5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	57                   	push   %edi
  8010d9:	56                   	push   %esi
  8010da:	53                   	push   %ebx
  8010db:	83 ec 0c             	sub    $0xc,%esp
  8010de:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010e1:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8010e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e9:	eb 21                	jmp    80110c <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010eb:	83 ec 04             	sub    $0x4,%esp
  8010ee:	89 f0                	mov    %esi,%eax
  8010f0:	29 d8                	sub    %ebx,%eax
  8010f2:	50                   	push   %eax
  8010f3:	89 d8                	mov    %ebx,%eax
  8010f5:	03 45 0c             	add    0xc(%ebp),%eax
  8010f8:	50                   	push   %eax
  8010f9:	57                   	push   %edi
  8010fa:	e8 45 ff ff ff       	call   801044 <read>
		if (m < 0)
  8010ff:	83 c4 10             	add    $0x10,%esp
  801102:	85 c0                	test   %eax,%eax
  801104:	78 10                	js     801116 <readn+0x41>
			return m;
		if (m == 0)
  801106:	85 c0                	test   %eax,%eax
  801108:	74 0a                	je     801114 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80110a:	01 c3                	add    %eax,%ebx
  80110c:	39 f3                	cmp    %esi,%ebx
  80110e:	72 db                	jb     8010eb <readn+0x16>
  801110:	89 d8                	mov    %ebx,%eax
  801112:	eb 02                	jmp    801116 <readn+0x41>
  801114:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801116:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801119:	5b                   	pop    %ebx
  80111a:	5e                   	pop    %esi
  80111b:	5f                   	pop    %edi
  80111c:	5d                   	pop    %ebp
  80111d:	c3                   	ret    

0080111e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	53                   	push   %ebx
  801122:	83 ec 14             	sub    $0x14,%esp
  801125:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801128:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80112b:	50                   	push   %eax
  80112c:	53                   	push   %ebx
  80112d:	e8 ad fc ff ff       	call   800ddf <fd_lookup>
  801132:	83 c4 08             	add    $0x8,%esp
  801135:	89 c2                	mov    %eax,%edx
  801137:	85 c0                	test   %eax,%eax
  801139:	78 68                	js     8011a3 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80113b:	83 ec 08             	sub    $0x8,%esp
  80113e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801141:	50                   	push   %eax
  801142:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801145:	ff 30                	pushl  (%eax)
  801147:	e8 e9 fc ff ff       	call   800e35 <dev_lookup>
  80114c:	83 c4 10             	add    $0x10,%esp
  80114f:	85 c0                	test   %eax,%eax
  801151:	78 47                	js     80119a <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801153:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801156:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80115a:	75 21                	jne    80117d <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80115c:	a1 04 40 80 00       	mov    0x804004,%eax
  801161:	8b 40 48             	mov    0x48(%eax),%eax
  801164:	83 ec 04             	sub    $0x4,%esp
  801167:	53                   	push   %ebx
  801168:	50                   	push   %eax
  801169:	68 89 21 80 00       	push   $0x802189
  80116e:	e8 25 f0 ff ff       	call   800198 <cprintf>
		return -E_INVAL;
  801173:	83 c4 10             	add    $0x10,%esp
  801176:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80117b:	eb 26                	jmp    8011a3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80117d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801180:	8b 52 0c             	mov    0xc(%edx),%edx
  801183:	85 d2                	test   %edx,%edx
  801185:	74 17                	je     80119e <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801187:	83 ec 04             	sub    $0x4,%esp
  80118a:	ff 75 10             	pushl  0x10(%ebp)
  80118d:	ff 75 0c             	pushl  0xc(%ebp)
  801190:	50                   	push   %eax
  801191:	ff d2                	call   *%edx
  801193:	89 c2                	mov    %eax,%edx
  801195:	83 c4 10             	add    $0x10,%esp
  801198:	eb 09                	jmp    8011a3 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80119a:	89 c2                	mov    %eax,%edx
  80119c:	eb 05                	jmp    8011a3 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80119e:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  8011a3:	89 d0                	mov    %edx,%eax
  8011a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011a8:	c9                   	leave  
  8011a9:	c3                   	ret    

008011aa <seek>:

int
seek(int fdnum, off_t offset)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
  8011ad:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011b0:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8011b3:	50                   	push   %eax
  8011b4:	ff 75 08             	pushl  0x8(%ebp)
  8011b7:	e8 23 fc ff ff       	call   800ddf <fd_lookup>
  8011bc:	83 c4 08             	add    $0x8,%esp
  8011bf:	85 c0                	test   %eax,%eax
  8011c1:	78 0e                	js     8011d1 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8011c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c9:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8011cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	53                   	push   %ebx
  8011d7:	83 ec 14             	sub    $0x14,%esp
  8011da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011e0:	50                   	push   %eax
  8011e1:	53                   	push   %ebx
  8011e2:	e8 f8 fb ff ff       	call   800ddf <fd_lookup>
  8011e7:	83 c4 08             	add    $0x8,%esp
  8011ea:	89 c2                	mov    %eax,%edx
  8011ec:	85 c0                	test   %eax,%eax
  8011ee:	78 65                	js     801255 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011f0:	83 ec 08             	sub    $0x8,%esp
  8011f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011f6:	50                   	push   %eax
  8011f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011fa:	ff 30                	pushl  (%eax)
  8011fc:	e8 34 fc ff ff       	call   800e35 <dev_lookup>
  801201:	83 c4 10             	add    $0x10,%esp
  801204:	85 c0                	test   %eax,%eax
  801206:	78 44                	js     80124c <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801208:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80120b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80120f:	75 21                	jne    801232 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801211:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801216:	8b 40 48             	mov    0x48(%eax),%eax
  801219:	83 ec 04             	sub    $0x4,%esp
  80121c:	53                   	push   %ebx
  80121d:	50                   	push   %eax
  80121e:	68 4c 21 80 00       	push   $0x80214c
  801223:	e8 70 ef ff ff       	call   800198 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801228:	83 c4 10             	add    $0x10,%esp
  80122b:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801230:	eb 23                	jmp    801255 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  801232:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801235:	8b 52 18             	mov    0x18(%edx),%edx
  801238:	85 d2                	test   %edx,%edx
  80123a:	74 14                	je     801250 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80123c:	83 ec 08             	sub    $0x8,%esp
  80123f:	ff 75 0c             	pushl  0xc(%ebp)
  801242:	50                   	push   %eax
  801243:	ff d2                	call   *%edx
  801245:	89 c2                	mov    %eax,%edx
  801247:	83 c4 10             	add    $0x10,%esp
  80124a:	eb 09                	jmp    801255 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80124c:	89 c2                	mov    %eax,%edx
  80124e:	eb 05                	jmp    801255 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801250:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  801255:	89 d0                	mov    %edx,%eax
  801257:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80125a:	c9                   	leave  
  80125b:	c3                   	ret    

0080125c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
  80125f:	53                   	push   %ebx
  801260:	83 ec 14             	sub    $0x14,%esp
  801263:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801266:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801269:	50                   	push   %eax
  80126a:	ff 75 08             	pushl  0x8(%ebp)
  80126d:	e8 6d fb ff ff       	call   800ddf <fd_lookup>
  801272:	83 c4 08             	add    $0x8,%esp
  801275:	89 c2                	mov    %eax,%edx
  801277:	85 c0                	test   %eax,%eax
  801279:	78 58                	js     8012d3 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80127b:	83 ec 08             	sub    $0x8,%esp
  80127e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801281:	50                   	push   %eax
  801282:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801285:	ff 30                	pushl  (%eax)
  801287:	e8 a9 fb ff ff       	call   800e35 <dev_lookup>
  80128c:	83 c4 10             	add    $0x10,%esp
  80128f:	85 c0                	test   %eax,%eax
  801291:	78 37                	js     8012ca <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  801293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801296:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80129a:	74 32                	je     8012ce <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80129c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80129f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8012a6:	00 00 00 
	stat->st_isdir = 0;
  8012a9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8012b0:	00 00 00 
	stat->st_dev = dev;
  8012b3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8012b9:	83 ec 08             	sub    $0x8,%esp
  8012bc:	53                   	push   %ebx
  8012bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8012c0:	ff 50 14             	call   *0x14(%eax)
  8012c3:	89 c2                	mov    %eax,%edx
  8012c5:	83 c4 10             	add    $0x10,%esp
  8012c8:	eb 09                	jmp    8012d3 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012ca:	89 c2                	mov    %eax,%edx
  8012cc:	eb 05                	jmp    8012d3 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8012ce:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8012d3:	89 d0                	mov    %edx,%eax
  8012d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012d8:	c9                   	leave  
  8012d9:	c3                   	ret    

008012da <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	56                   	push   %esi
  8012de:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8012df:	83 ec 08             	sub    $0x8,%esp
  8012e2:	6a 00                	push   $0x0
  8012e4:	ff 75 08             	pushl  0x8(%ebp)
  8012e7:	e8 06 02 00 00       	call   8014f2 <open>
  8012ec:	89 c3                	mov    %eax,%ebx
  8012ee:	83 c4 10             	add    $0x10,%esp
  8012f1:	85 c0                	test   %eax,%eax
  8012f3:	78 1b                	js     801310 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8012f5:	83 ec 08             	sub    $0x8,%esp
  8012f8:	ff 75 0c             	pushl  0xc(%ebp)
  8012fb:	50                   	push   %eax
  8012fc:	e8 5b ff ff ff       	call   80125c <fstat>
  801301:	89 c6                	mov    %eax,%esi
	close(fd);
  801303:	89 1c 24             	mov    %ebx,(%esp)
  801306:	e8 fd fb ff ff       	call   800f08 <close>
	return r;
  80130b:	83 c4 10             	add    $0x10,%esp
  80130e:	89 f0                	mov    %esi,%eax
}
  801310:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801313:	5b                   	pop    %ebx
  801314:	5e                   	pop    %esi
  801315:	5d                   	pop    %ebp
  801316:	c3                   	ret    

00801317 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	56                   	push   %esi
  80131b:	53                   	push   %ebx
  80131c:	89 c6                	mov    %eax,%esi
  80131e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801320:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801327:	75 12                	jne    80133b <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801329:	83 ec 0c             	sub    $0xc,%esp
  80132c:	6a 01                	push   $0x1
  80132e:	e8 fc f9 ff ff       	call   800d2f <ipc_find_env>
  801333:	a3 00 40 80 00       	mov    %eax,0x804000
  801338:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80133b:	6a 07                	push   $0x7
  80133d:	68 00 50 80 00       	push   $0x805000
  801342:	56                   	push   %esi
  801343:	ff 35 00 40 80 00    	pushl  0x804000
  801349:	e8 8d f9 ff ff       	call   800cdb <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80134e:	83 c4 0c             	add    $0xc,%esp
  801351:	6a 00                	push   $0x0
  801353:	53                   	push   %ebx
  801354:	6a 00                	push   $0x0
  801356:	e8 15 f9 ff ff       	call   800c70 <ipc_recv>
}
  80135b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80135e:	5b                   	pop    %ebx
  80135f:	5e                   	pop    %esi
  801360:	5d                   	pop    %ebp
  801361:	c3                   	ret    

00801362 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
  801365:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	8b 40 0c             	mov    0xc(%eax),%eax
  80136e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801373:	8b 45 0c             	mov    0xc(%ebp),%eax
  801376:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80137b:	ba 00 00 00 00       	mov    $0x0,%edx
  801380:	b8 02 00 00 00       	mov    $0x2,%eax
  801385:	e8 8d ff ff ff       	call   801317 <fsipc>
}
  80138a:	c9                   	leave  
  80138b:	c3                   	ret    

0080138c <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
  80138f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	8b 40 0c             	mov    0xc(%eax),%eax
  801398:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80139d:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a2:	b8 06 00 00 00       	mov    $0x6,%eax
  8013a7:	e8 6b ff ff ff       	call   801317 <fsipc>
}
  8013ac:	c9                   	leave  
  8013ad:	c3                   	ret    

008013ae <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
  8013b1:	53                   	push   %ebx
  8013b2:	83 ec 04             	sub    $0x4,%esp
  8013b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8013be:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8013c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c8:	b8 05 00 00 00       	mov    $0x5,%eax
  8013cd:	e8 45 ff ff ff       	call   801317 <fsipc>
  8013d2:	85 c0                	test   %eax,%eax
  8013d4:	78 2c                	js     801402 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8013d6:	83 ec 08             	sub    $0x8,%esp
  8013d9:	68 00 50 80 00       	push   $0x805000
  8013de:	53                   	push   %ebx
  8013df:	e8 26 f3 ff ff       	call   80070a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8013e4:	a1 80 50 80 00       	mov    0x805080,%eax
  8013e9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8013ef:	a1 84 50 80 00       	mov    0x805084,%eax
  8013f4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8013fa:	83 c4 10             	add    $0x10,%esp
  8013fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801402:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801405:	c9                   	leave  
  801406:	c3                   	ret    

00801407 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801407:	55                   	push   %ebp
  801408:	89 e5                	mov    %esp,%ebp
  80140a:	83 ec 08             	sub    $0x8,%esp
  80140d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801410:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801413:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801416:	8b 49 0c             	mov    0xc(%ecx),%ecx
  801419:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  80141f:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801424:	76 22                	jbe    801448 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  801426:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  80142d:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  801430:	83 ec 04             	sub    $0x4,%esp
  801433:	68 f8 0f 00 00       	push   $0xff8
  801438:	52                   	push   %edx
  801439:	68 08 50 80 00       	push   $0x805008
  80143e:	e8 5a f4 ff ff       	call   80089d <memmove>
  801443:	83 c4 10             	add    $0x10,%esp
  801446:	eb 17                	jmp    80145f <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  801448:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  80144d:	83 ec 04             	sub    $0x4,%esp
  801450:	50                   	push   %eax
  801451:	52                   	push   %edx
  801452:	68 08 50 80 00       	push   $0x805008
  801457:	e8 41 f4 ff ff       	call   80089d <memmove>
  80145c:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  80145f:	ba 00 00 00 00       	mov    $0x0,%edx
  801464:	b8 04 00 00 00       	mov    $0x4,%eax
  801469:	e8 a9 fe ff ff       	call   801317 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  80146e:	c9                   	leave  
  80146f:	c3                   	ret    

00801470 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	56                   	push   %esi
  801474:	53                   	push   %ebx
  801475:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	8b 40 0c             	mov    0xc(%eax),%eax
  80147e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801483:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801489:	ba 00 00 00 00       	mov    $0x0,%edx
  80148e:	b8 03 00 00 00       	mov    $0x3,%eax
  801493:	e8 7f fe ff ff       	call   801317 <fsipc>
  801498:	89 c3                	mov    %eax,%ebx
  80149a:	85 c0                	test   %eax,%eax
  80149c:	78 4b                	js     8014e9 <devfile_read+0x79>
		return r;
	assert(r <= n);
  80149e:	39 c6                	cmp    %eax,%esi
  8014a0:	73 16                	jae    8014b8 <devfile_read+0x48>
  8014a2:	68 b8 21 80 00       	push   $0x8021b8
  8014a7:	68 bf 21 80 00       	push   $0x8021bf
  8014ac:	6a 7c                	push   $0x7c
  8014ae:	68 d4 21 80 00       	push   $0x8021d4
  8014b3:	e8 bd 05 00 00       	call   801a75 <_panic>
	assert(r <= PGSIZE);
  8014b8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8014bd:	7e 16                	jle    8014d5 <devfile_read+0x65>
  8014bf:	68 df 21 80 00       	push   $0x8021df
  8014c4:	68 bf 21 80 00       	push   $0x8021bf
  8014c9:	6a 7d                	push   $0x7d
  8014cb:	68 d4 21 80 00       	push   $0x8021d4
  8014d0:	e8 a0 05 00 00       	call   801a75 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8014d5:	83 ec 04             	sub    $0x4,%esp
  8014d8:	50                   	push   %eax
  8014d9:	68 00 50 80 00       	push   $0x805000
  8014de:	ff 75 0c             	pushl  0xc(%ebp)
  8014e1:	e8 b7 f3 ff ff       	call   80089d <memmove>
	return r;
  8014e6:	83 c4 10             	add    $0x10,%esp
}
  8014e9:	89 d8                	mov    %ebx,%eax
  8014eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014ee:	5b                   	pop    %ebx
  8014ef:	5e                   	pop    %esi
  8014f0:	5d                   	pop    %ebp
  8014f1:	c3                   	ret    

008014f2 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8014f2:	55                   	push   %ebp
  8014f3:	89 e5                	mov    %esp,%ebp
  8014f5:	53                   	push   %ebx
  8014f6:	83 ec 20             	sub    $0x20,%esp
  8014f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8014fc:	53                   	push   %ebx
  8014fd:	e8 cf f1 ff ff       	call   8006d1 <strlen>
  801502:	83 c4 10             	add    $0x10,%esp
  801505:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80150a:	7f 67                	jg     801573 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80150c:	83 ec 0c             	sub    $0xc,%esp
  80150f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801512:	50                   	push   %eax
  801513:	e8 78 f8 ff ff       	call   800d90 <fd_alloc>
  801518:	83 c4 10             	add    $0x10,%esp
		return r;
  80151b:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80151d:	85 c0                	test   %eax,%eax
  80151f:	78 57                	js     801578 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801521:	83 ec 08             	sub    $0x8,%esp
  801524:	53                   	push   %ebx
  801525:	68 00 50 80 00       	push   $0x805000
  80152a:	e8 db f1 ff ff       	call   80070a <strcpy>
	fsipcbuf.open.req_omode = mode;
  80152f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801532:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801537:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80153a:	b8 01 00 00 00       	mov    $0x1,%eax
  80153f:	e8 d3 fd ff ff       	call   801317 <fsipc>
  801544:	89 c3                	mov    %eax,%ebx
  801546:	83 c4 10             	add    $0x10,%esp
  801549:	85 c0                	test   %eax,%eax
  80154b:	79 14                	jns    801561 <open+0x6f>
		fd_close(fd, 0);
  80154d:	83 ec 08             	sub    $0x8,%esp
  801550:	6a 00                	push   $0x0
  801552:	ff 75 f4             	pushl  -0xc(%ebp)
  801555:	e8 2e f9 ff ff       	call   800e88 <fd_close>
		return r;
  80155a:	83 c4 10             	add    $0x10,%esp
  80155d:	89 da                	mov    %ebx,%edx
  80155f:	eb 17                	jmp    801578 <open+0x86>
	}

	return fd2num(fd);
  801561:	83 ec 0c             	sub    $0xc,%esp
  801564:	ff 75 f4             	pushl  -0xc(%ebp)
  801567:	e8 fc f7 ff ff       	call   800d68 <fd2num>
  80156c:	89 c2                	mov    %eax,%edx
  80156e:	83 c4 10             	add    $0x10,%esp
  801571:	eb 05                	jmp    801578 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801573:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801578:	89 d0                	mov    %edx,%eax
  80157a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    

0080157f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801585:	ba 00 00 00 00       	mov    $0x0,%edx
  80158a:	b8 08 00 00 00       	mov    $0x8,%eax
  80158f:	e8 83 fd ff ff       	call   801317 <fsipc>
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	56                   	push   %esi
  80159a:	53                   	push   %ebx
  80159b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80159e:	83 ec 0c             	sub    $0xc,%esp
  8015a1:	ff 75 08             	pushl  0x8(%ebp)
  8015a4:	e8 cf f7 ff ff       	call   800d78 <fd2data>
  8015a9:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8015ab:	83 c4 08             	add    $0x8,%esp
  8015ae:	68 eb 21 80 00       	push   $0x8021eb
  8015b3:	53                   	push   %ebx
  8015b4:	e8 51 f1 ff ff       	call   80070a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8015b9:	8b 46 04             	mov    0x4(%esi),%eax
  8015bc:	2b 06                	sub    (%esi),%eax
  8015be:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8015c4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015cb:	00 00 00 
	stat->st_dev = &devpipe;
  8015ce:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8015d5:	30 80 00 
	return 0;
}
  8015d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015e0:	5b                   	pop    %ebx
  8015e1:	5e                   	pop    %esi
  8015e2:	5d                   	pop    %ebp
  8015e3:	c3                   	ret    

008015e4 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	53                   	push   %ebx
  8015e8:	83 ec 0c             	sub    $0xc,%esp
  8015eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8015ee:	53                   	push   %ebx
  8015ef:	6a 00                	push   $0x0
  8015f1:	e8 a7 f5 ff ff       	call   800b9d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8015f6:	89 1c 24             	mov    %ebx,(%esp)
  8015f9:	e8 7a f7 ff ff       	call   800d78 <fd2data>
  8015fe:	83 c4 08             	add    $0x8,%esp
  801601:	50                   	push   %eax
  801602:	6a 00                	push   $0x0
  801604:	e8 94 f5 ff ff       	call   800b9d <sys_page_unmap>
}
  801609:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80160c:	c9                   	leave  
  80160d:	c3                   	ret    

0080160e <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
  801611:	57                   	push   %edi
  801612:	56                   	push   %esi
  801613:	53                   	push   %ebx
  801614:	83 ec 1c             	sub    $0x1c,%esp
  801617:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80161a:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80161c:	a1 04 40 80 00       	mov    0x804004,%eax
  801621:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801624:	83 ec 0c             	sub    $0xc,%esp
  801627:	ff 75 e0             	pushl  -0x20(%ebp)
  80162a:	e8 8c 04 00 00       	call   801abb <pageref>
  80162f:	89 c3                	mov    %eax,%ebx
  801631:	89 3c 24             	mov    %edi,(%esp)
  801634:	e8 82 04 00 00       	call   801abb <pageref>
  801639:	83 c4 10             	add    $0x10,%esp
  80163c:	39 c3                	cmp    %eax,%ebx
  80163e:	0f 94 c1             	sete   %cl
  801641:	0f b6 c9             	movzbl %cl,%ecx
  801644:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801647:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80164d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801650:	39 ce                	cmp    %ecx,%esi
  801652:	74 1b                	je     80166f <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801654:	39 c3                	cmp    %eax,%ebx
  801656:	75 c4                	jne    80161c <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801658:	8b 42 58             	mov    0x58(%edx),%eax
  80165b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80165e:	50                   	push   %eax
  80165f:	56                   	push   %esi
  801660:	68 f2 21 80 00       	push   $0x8021f2
  801665:	e8 2e eb ff ff       	call   800198 <cprintf>
  80166a:	83 c4 10             	add    $0x10,%esp
  80166d:	eb ad                	jmp    80161c <_pipeisclosed+0xe>
	}
}
  80166f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801672:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801675:	5b                   	pop    %ebx
  801676:	5e                   	pop    %esi
  801677:	5f                   	pop    %edi
  801678:	5d                   	pop    %ebp
  801679:	c3                   	ret    

0080167a <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	57                   	push   %edi
  80167e:	56                   	push   %esi
  80167f:	53                   	push   %ebx
  801680:	83 ec 28             	sub    $0x28,%esp
  801683:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801686:	56                   	push   %esi
  801687:	e8 ec f6 ff ff       	call   800d78 <fd2data>
  80168c:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80168e:	83 c4 10             	add    $0x10,%esp
  801691:	bf 00 00 00 00       	mov    $0x0,%edi
  801696:	eb 4b                	jmp    8016e3 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801698:	89 da                	mov    %ebx,%edx
  80169a:	89 f0                	mov    %esi,%eax
  80169c:	e8 6d ff ff ff       	call   80160e <_pipeisclosed>
  8016a1:	85 c0                	test   %eax,%eax
  8016a3:	75 48                	jne    8016ed <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8016a5:	e8 82 f4 ff ff       	call   800b2c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8016aa:	8b 43 04             	mov    0x4(%ebx),%eax
  8016ad:	8b 0b                	mov    (%ebx),%ecx
  8016af:	8d 51 20             	lea    0x20(%ecx),%edx
  8016b2:	39 d0                	cmp    %edx,%eax
  8016b4:	73 e2                	jae    801698 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8016b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016b9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8016bd:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8016c0:	89 c2                	mov    %eax,%edx
  8016c2:	c1 fa 1f             	sar    $0x1f,%edx
  8016c5:	89 d1                	mov    %edx,%ecx
  8016c7:	c1 e9 1b             	shr    $0x1b,%ecx
  8016ca:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8016cd:	83 e2 1f             	and    $0x1f,%edx
  8016d0:	29 ca                	sub    %ecx,%edx
  8016d2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8016d6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8016da:	83 c0 01             	add    $0x1,%eax
  8016dd:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8016e0:	83 c7 01             	add    $0x1,%edi
  8016e3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8016e6:	75 c2                	jne    8016aa <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8016e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016eb:	eb 05                	jmp    8016f2 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8016ed:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8016f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f5:	5b                   	pop    %ebx
  8016f6:	5e                   	pop    %esi
  8016f7:	5f                   	pop    %edi
  8016f8:	5d                   	pop    %ebp
  8016f9:	c3                   	ret    

008016fa <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	57                   	push   %edi
  8016fe:	56                   	push   %esi
  8016ff:	53                   	push   %ebx
  801700:	83 ec 18             	sub    $0x18,%esp
  801703:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801706:	57                   	push   %edi
  801707:	e8 6c f6 ff ff       	call   800d78 <fd2data>
  80170c:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80170e:	83 c4 10             	add    $0x10,%esp
  801711:	bb 00 00 00 00       	mov    $0x0,%ebx
  801716:	eb 3d                	jmp    801755 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801718:	85 db                	test   %ebx,%ebx
  80171a:	74 04                	je     801720 <devpipe_read+0x26>
				return i;
  80171c:	89 d8                	mov    %ebx,%eax
  80171e:	eb 44                	jmp    801764 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801720:	89 f2                	mov    %esi,%edx
  801722:	89 f8                	mov    %edi,%eax
  801724:	e8 e5 fe ff ff       	call   80160e <_pipeisclosed>
  801729:	85 c0                	test   %eax,%eax
  80172b:	75 32                	jne    80175f <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80172d:	e8 fa f3 ff ff       	call   800b2c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801732:	8b 06                	mov    (%esi),%eax
  801734:	3b 46 04             	cmp    0x4(%esi),%eax
  801737:	74 df                	je     801718 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801739:	99                   	cltd   
  80173a:	c1 ea 1b             	shr    $0x1b,%edx
  80173d:	01 d0                	add    %edx,%eax
  80173f:	83 e0 1f             	and    $0x1f,%eax
  801742:	29 d0                	sub    %edx,%eax
  801744:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801749:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80174c:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  80174f:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801752:	83 c3 01             	add    $0x1,%ebx
  801755:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801758:	75 d8                	jne    801732 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80175a:	8b 45 10             	mov    0x10(%ebp),%eax
  80175d:	eb 05                	jmp    801764 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80175f:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801764:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801767:	5b                   	pop    %ebx
  801768:	5e                   	pop    %esi
  801769:	5f                   	pop    %edi
  80176a:	5d                   	pop    %ebp
  80176b:	c3                   	ret    

0080176c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	56                   	push   %esi
  801770:	53                   	push   %ebx
  801771:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801774:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801777:	50                   	push   %eax
  801778:	e8 13 f6 ff ff       	call   800d90 <fd_alloc>
  80177d:	83 c4 10             	add    $0x10,%esp
  801780:	89 c2                	mov    %eax,%edx
  801782:	85 c0                	test   %eax,%eax
  801784:	0f 88 2c 01 00 00    	js     8018b6 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80178a:	83 ec 04             	sub    $0x4,%esp
  80178d:	68 07 04 00 00       	push   $0x407
  801792:	ff 75 f4             	pushl  -0xc(%ebp)
  801795:	6a 00                	push   $0x0
  801797:	e8 b7 f3 ff ff       	call   800b53 <sys_page_alloc>
  80179c:	83 c4 10             	add    $0x10,%esp
  80179f:	89 c2                	mov    %eax,%edx
  8017a1:	85 c0                	test   %eax,%eax
  8017a3:	0f 88 0d 01 00 00    	js     8018b6 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8017a9:	83 ec 0c             	sub    $0xc,%esp
  8017ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017af:	50                   	push   %eax
  8017b0:	e8 db f5 ff ff       	call   800d90 <fd_alloc>
  8017b5:	89 c3                	mov    %eax,%ebx
  8017b7:	83 c4 10             	add    $0x10,%esp
  8017ba:	85 c0                	test   %eax,%eax
  8017bc:	0f 88 e2 00 00 00    	js     8018a4 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017c2:	83 ec 04             	sub    $0x4,%esp
  8017c5:	68 07 04 00 00       	push   $0x407
  8017ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8017cd:	6a 00                	push   $0x0
  8017cf:	e8 7f f3 ff ff       	call   800b53 <sys_page_alloc>
  8017d4:	89 c3                	mov    %eax,%ebx
  8017d6:	83 c4 10             	add    $0x10,%esp
  8017d9:	85 c0                	test   %eax,%eax
  8017db:	0f 88 c3 00 00 00    	js     8018a4 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8017e1:	83 ec 0c             	sub    $0xc,%esp
  8017e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e7:	e8 8c f5 ff ff       	call   800d78 <fd2data>
  8017ec:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017ee:	83 c4 0c             	add    $0xc,%esp
  8017f1:	68 07 04 00 00       	push   $0x407
  8017f6:	50                   	push   %eax
  8017f7:	6a 00                	push   $0x0
  8017f9:	e8 55 f3 ff ff       	call   800b53 <sys_page_alloc>
  8017fe:	89 c3                	mov    %eax,%ebx
  801800:	83 c4 10             	add    $0x10,%esp
  801803:	85 c0                	test   %eax,%eax
  801805:	0f 88 89 00 00 00    	js     801894 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80180b:	83 ec 0c             	sub    $0xc,%esp
  80180e:	ff 75 f0             	pushl  -0x10(%ebp)
  801811:	e8 62 f5 ff ff       	call   800d78 <fd2data>
  801816:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80181d:	50                   	push   %eax
  80181e:	6a 00                	push   $0x0
  801820:	56                   	push   %esi
  801821:	6a 00                	push   $0x0
  801823:	e8 4f f3 ff ff       	call   800b77 <sys_page_map>
  801828:	89 c3                	mov    %eax,%ebx
  80182a:	83 c4 20             	add    $0x20,%esp
  80182d:	85 c0                	test   %eax,%eax
  80182f:	78 55                	js     801886 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801831:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183a:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80183c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801846:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80184c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184f:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801854:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80185b:	83 ec 0c             	sub    $0xc,%esp
  80185e:	ff 75 f4             	pushl  -0xc(%ebp)
  801861:	e8 02 f5 ff ff       	call   800d68 <fd2num>
  801866:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801869:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80186b:	83 c4 04             	add    $0x4,%esp
  80186e:	ff 75 f0             	pushl  -0x10(%ebp)
  801871:	e8 f2 f4 ff ff       	call   800d68 <fd2num>
  801876:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801879:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80187c:	83 c4 10             	add    $0x10,%esp
  80187f:	ba 00 00 00 00       	mov    $0x0,%edx
  801884:	eb 30                	jmp    8018b6 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801886:	83 ec 08             	sub    $0x8,%esp
  801889:	56                   	push   %esi
  80188a:	6a 00                	push   $0x0
  80188c:	e8 0c f3 ff ff       	call   800b9d <sys_page_unmap>
  801891:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801894:	83 ec 08             	sub    $0x8,%esp
  801897:	ff 75 f0             	pushl  -0x10(%ebp)
  80189a:	6a 00                	push   $0x0
  80189c:	e8 fc f2 ff ff       	call   800b9d <sys_page_unmap>
  8018a1:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  8018a4:	83 ec 08             	sub    $0x8,%esp
  8018a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8018aa:	6a 00                	push   $0x0
  8018ac:	e8 ec f2 ff ff       	call   800b9d <sys_page_unmap>
  8018b1:	83 c4 10             	add    $0x10,%esp
  8018b4:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  8018b6:	89 d0                	mov    %edx,%eax
  8018b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018bb:	5b                   	pop    %ebx
  8018bc:	5e                   	pop    %esi
  8018bd:	5d                   	pop    %ebp
  8018be:	c3                   	ret    

008018bf <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c8:	50                   	push   %eax
  8018c9:	ff 75 08             	pushl  0x8(%ebp)
  8018cc:	e8 0e f5 ff ff       	call   800ddf <fd_lookup>
  8018d1:	83 c4 10             	add    $0x10,%esp
  8018d4:	85 c0                	test   %eax,%eax
  8018d6:	78 18                	js     8018f0 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8018d8:	83 ec 0c             	sub    $0xc,%esp
  8018db:	ff 75 f4             	pushl  -0xc(%ebp)
  8018de:	e8 95 f4 ff ff       	call   800d78 <fd2data>
	return _pipeisclosed(fd, p);
  8018e3:	89 c2                	mov    %eax,%edx
  8018e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e8:	e8 21 fd ff ff       	call   80160e <_pipeisclosed>
  8018ed:	83 c4 10             	add    $0x10,%esp
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8018f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018fa:	5d                   	pop    %ebp
  8018fb:	c3                   	ret    

008018fc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801902:	68 0a 22 80 00       	push   $0x80220a
  801907:	ff 75 0c             	pushl  0xc(%ebp)
  80190a:	e8 fb ed ff ff       	call   80070a <strcpy>
	return 0;
}
  80190f:	b8 00 00 00 00       	mov    $0x0,%eax
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	57                   	push   %edi
  80191a:	56                   	push   %esi
  80191b:	53                   	push   %ebx
  80191c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801922:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801927:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80192d:	eb 2d                	jmp    80195c <devcons_write+0x46>
		m = n - tot;
  80192f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801932:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801934:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801937:	ba 7f 00 00 00       	mov    $0x7f,%edx
  80193c:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80193f:	83 ec 04             	sub    $0x4,%esp
  801942:	53                   	push   %ebx
  801943:	03 45 0c             	add    0xc(%ebp),%eax
  801946:	50                   	push   %eax
  801947:	57                   	push   %edi
  801948:	e8 50 ef ff ff       	call   80089d <memmove>
		sys_cputs(buf, m);
  80194d:	83 c4 08             	add    $0x8,%esp
  801950:	53                   	push   %ebx
  801951:	57                   	push   %edi
  801952:	e8 45 f1 ff ff       	call   800a9c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801957:	01 de                	add    %ebx,%esi
  801959:	83 c4 10             	add    $0x10,%esp
  80195c:	89 f0                	mov    %esi,%eax
  80195e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801961:	72 cc                	jb     80192f <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801963:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801966:	5b                   	pop    %ebx
  801967:	5e                   	pop    %esi
  801968:	5f                   	pop    %edi
  801969:	5d                   	pop    %ebp
  80196a:	c3                   	ret    

0080196b <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	83 ec 08             	sub    $0x8,%esp
  801971:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801976:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80197a:	74 2a                	je     8019a6 <devcons_read+0x3b>
  80197c:	eb 05                	jmp    801983 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80197e:	e8 a9 f1 ff ff       	call   800b2c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801983:	e8 3a f1 ff ff       	call   800ac2 <sys_cgetc>
  801988:	85 c0                	test   %eax,%eax
  80198a:	74 f2                	je     80197e <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  80198c:	85 c0                	test   %eax,%eax
  80198e:	78 16                	js     8019a6 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801990:	83 f8 04             	cmp    $0x4,%eax
  801993:	74 0c                	je     8019a1 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801995:	8b 55 0c             	mov    0xc(%ebp),%edx
  801998:	88 02                	mov    %al,(%edx)
	return 1;
  80199a:	b8 01 00 00 00       	mov    $0x1,%eax
  80199f:	eb 05                	jmp    8019a6 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8019a1:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
  8019ab:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8019b4:	6a 01                	push   $0x1
  8019b6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8019b9:	50                   	push   %eax
  8019ba:	e8 dd f0 ff ff       	call   800a9c <sys_cputs>
}
  8019bf:	83 c4 10             	add    $0x10,%esp
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <getchar>:

int
getchar(void)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8019ca:	6a 01                	push   $0x1
  8019cc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8019cf:	50                   	push   %eax
  8019d0:	6a 00                	push   $0x0
  8019d2:	e8 6d f6 ff ff       	call   801044 <read>
	if (r < 0)
  8019d7:	83 c4 10             	add    $0x10,%esp
  8019da:	85 c0                	test   %eax,%eax
  8019dc:	78 0f                	js     8019ed <getchar+0x29>
		return r;
	if (r < 1)
  8019de:	85 c0                	test   %eax,%eax
  8019e0:	7e 06                	jle    8019e8 <getchar+0x24>
		return -E_EOF;
	return c;
  8019e2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8019e6:	eb 05                	jmp    8019ed <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8019e8:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
  8019f2:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f8:	50                   	push   %eax
  8019f9:	ff 75 08             	pushl  0x8(%ebp)
  8019fc:	e8 de f3 ff ff       	call   800ddf <fd_lookup>
  801a01:	83 c4 10             	add    $0x10,%esp
  801a04:	85 c0                	test   %eax,%eax
  801a06:	78 11                	js     801a19 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a0b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a11:	39 10                	cmp    %edx,(%eax)
  801a13:	0f 94 c0             	sete   %al
  801a16:	0f b6 c0             	movzbl %al,%eax
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <opencons>:

int
opencons(void)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
  801a1e:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801a21:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a24:	50                   	push   %eax
  801a25:	e8 66 f3 ff ff       	call   800d90 <fd_alloc>
  801a2a:	83 c4 10             	add    $0x10,%esp
		return r;
  801a2d:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801a2f:	85 c0                	test   %eax,%eax
  801a31:	78 3e                	js     801a71 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801a33:	83 ec 04             	sub    $0x4,%esp
  801a36:	68 07 04 00 00       	push   $0x407
  801a3b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a3e:	6a 00                	push   $0x0
  801a40:	e8 0e f1 ff ff       	call   800b53 <sys_page_alloc>
  801a45:	83 c4 10             	add    $0x10,%esp
		return r;
  801a48:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801a4a:	85 c0                	test   %eax,%eax
  801a4c:	78 23                	js     801a71 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801a4e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a57:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801a63:	83 ec 0c             	sub    $0xc,%esp
  801a66:	50                   	push   %eax
  801a67:	e8 fc f2 ff ff       	call   800d68 <fd2num>
  801a6c:	89 c2                	mov    %eax,%edx
  801a6e:	83 c4 10             	add    $0x10,%esp
}
  801a71:	89 d0                	mov    %edx,%eax
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
  801a78:	56                   	push   %esi
  801a79:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801a7a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801a7d:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801a83:	e8 80 f0 ff ff       	call   800b08 <sys_getenvid>
  801a88:	83 ec 0c             	sub    $0xc,%esp
  801a8b:	ff 75 0c             	pushl  0xc(%ebp)
  801a8e:	ff 75 08             	pushl  0x8(%ebp)
  801a91:	56                   	push   %esi
  801a92:	50                   	push   %eax
  801a93:	68 18 22 80 00       	push   $0x802218
  801a98:	e8 fb e6 ff ff       	call   800198 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801a9d:	83 c4 18             	add    $0x18,%esp
  801aa0:	53                   	push   %ebx
  801aa1:	ff 75 10             	pushl  0x10(%ebp)
  801aa4:	e8 9e e6 ff ff       	call   800147 <vcprintf>
	cprintf("\n");
  801aa9:	c7 04 24 03 22 80 00 	movl   $0x802203,(%esp)
  801ab0:	e8 e3 e6 ff ff       	call   800198 <cprintf>
  801ab5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801ab8:	cc                   	int3   
  801ab9:	eb fd                	jmp    801ab8 <_panic+0x43>

00801abb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ac1:	89 d0                	mov    %edx,%eax
  801ac3:	c1 e8 16             	shr    $0x16,%eax
  801ac6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801acd:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ad2:	f6 c1 01             	test   $0x1,%cl
  801ad5:	74 1d                	je     801af4 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801ad7:	c1 ea 0c             	shr    $0xc,%edx
  801ada:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801ae1:	f6 c2 01             	test   $0x1,%dl
  801ae4:	74 0e                	je     801af4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ae6:	c1 ea 0c             	shr    $0xc,%edx
  801ae9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801af0:	ef 
  801af1:	0f b7 c0             	movzwl %ax,%eax
}
  801af4:	5d                   	pop    %ebp
  801af5:	c3                   	ret    
  801af6:	66 90                	xchg   %ax,%ax
  801af8:	66 90                	xchg   %ax,%ax
  801afa:	66 90                	xchg   %ax,%ax
  801afc:	66 90                	xchg   %ax,%ax
  801afe:	66 90                	xchg   %ax,%ax

00801b00 <__udivdi3>:
  801b00:	55                   	push   %ebp
  801b01:	57                   	push   %edi
  801b02:	56                   	push   %esi
  801b03:	53                   	push   %ebx
  801b04:	83 ec 1c             	sub    $0x1c,%esp
  801b07:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b0b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b0f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b17:	85 f6                	test   %esi,%esi
  801b19:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b1d:	89 ca                	mov    %ecx,%edx
  801b1f:	89 f8                	mov    %edi,%eax
  801b21:	75 3d                	jne    801b60 <__udivdi3+0x60>
  801b23:	39 cf                	cmp    %ecx,%edi
  801b25:	0f 87 c5 00 00 00    	ja     801bf0 <__udivdi3+0xf0>
  801b2b:	85 ff                	test   %edi,%edi
  801b2d:	89 fd                	mov    %edi,%ebp
  801b2f:	75 0b                	jne    801b3c <__udivdi3+0x3c>
  801b31:	b8 01 00 00 00       	mov    $0x1,%eax
  801b36:	31 d2                	xor    %edx,%edx
  801b38:	f7 f7                	div    %edi
  801b3a:	89 c5                	mov    %eax,%ebp
  801b3c:	89 c8                	mov    %ecx,%eax
  801b3e:	31 d2                	xor    %edx,%edx
  801b40:	f7 f5                	div    %ebp
  801b42:	89 c1                	mov    %eax,%ecx
  801b44:	89 d8                	mov    %ebx,%eax
  801b46:	89 cf                	mov    %ecx,%edi
  801b48:	f7 f5                	div    %ebp
  801b4a:	89 c3                	mov    %eax,%ebx
  801b4c:	89 d8                	mov    %ebx,%eax
  801b4e:	89 fa                	mov    %edi,%edx
  801b50:	83 c4 1c             	add    $0x1c,%esp
  801b53:	5b                   	pop    %ebx
  801b54:	5e                   	pop    %esi
  801b55:	5f                   	pop    %edi
  801b56:	5d                   	pop    %ebp
  801b57:	c3                   	ret    
  801b58:	90                   	nop
  801b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801b60:	39 ce                	cmp    %ecx,%esi
  801b62:	77 74                	ja     801bd8 <__udivdi3+0xd8>
  801b64:	0f bd fe             	bsr    %esi,%edi
  801b67:	83 f7 1f             	xor    $0x1f,%edi
  801b6a:	0f 84 98 00 00 00    	je     801c08 <__udivdi3+0x108>
  801b70:	bb 20 00 00 00       	mov    $0x20,%ebx
  801b75:	89 f9                	mov    %edi,%ecx
  801b77:	89 c5                	mov    %eax,%ebp
  801b79:	29 fb                	sub    %edi,%ebx
  801b7b:	d3 e6                	shl    %cl,%esi
  801b7d:	89 d9                	mov    %ebx,%ecx
  801b7f:	d3 ed                	shr    %cl,%ebp
  801b81:	89 f9                	mov    %edi,%ecx
  801b83:	d3 e0                	shl    %cl,%eax
  801b85:	09 ee                	or     %ebp,%esi
  801b87:	89 d9                	mov    %ebx,%ecx
  801b89:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b8d:	89 d5                	mov    %edx,%ebp
  801b8f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b93:	d3 ed                	shr    %cl,%ebp
  801b95:	89 f9                	mov    %edi,%ecx
  801b97:	d3 e2                	shl    %cl,%edx
  801b99:	89 d9                	mov    %ebx,%ecx
  801b9b:	d3 e8                	shr    %cl,%eax
  801b9d:	09 c2                	or     %eax,%edx
  801b9f:	89 d0                	mov    %edx,%eax
  801ba1:	89 ea                	mov    %ebp,%edx
  801ba3:	f7 f6                	div    %esi
  801ba5:	89 d5                	mov    %edx,%ebp
  801ba7:	89 c3                	mov    %eax,%ebx
  801ba9:	f7 64 24 0c          	mull   0xc(%esp)
  801bad:	39 d5                	cmp    %edx,%ebp
  801baf:	72 10                	jb     801bc1 <__udivdi3+0xc1>
  801bb1:	8b 74 24 08          	mov    0x8(%esp),%esi
  801bb5:	89 f9                	mov    %edi,%ecx
  801bb7:	d3 e6                	shl    %cl,%esi
  801bb9:	39 c6                	cmp    %eax,%esi
  801bbb:	73 07                	jae    801bc4 <__udivdi3+0xc4>
  801bbd:	39 d5                	cmp    %edx,%ebp
  801bbf:	75 03                	jne    801bc4 <__udivdi3+0xc4>
  801bc1:	83 eb 01             	sub    $0x1,%ebx
  801bc4:	31 ff                	xor    %edi,%edi
  801bc6:	89 d8                	mov    %ebx,%eax
  801bc8:	89 fa                	mov    %edi,%edx
  801bca:	83 c4 1c             	add    $0x1c,%esp
  801bcd:	5b                   	pop    %ebx
  801bce:	5e                   	pop    %esi
  801bcf:	5f                   	pop    %edi
  801bd0:	5d                   	pop    %ebp
  801bd1:	c3                   	ret    
  801bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801bd8:	31 ff                	xor    %edi,%edi
  801bda:	31 db                	xor    %ebx,%ebx
  801bdc:	89 d8                	mov    %ebx,%eax
  801bde:	89 fa                	mov    %edi,%edx
  801be0:	83 c4 1c             	add    $0x1c,%esp
  801be3:	5b                   	pop    %ebx
  801be4:	5e                   	pop    %esi
  801be5:	5f                   	pop    %edi
  801be6:	5d                   	pop    %ebp
  801be7:	c3                   	ret    
  801be8:	90                   	nop
  801be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801bf0:	89 d8                	mov    %ebx,%eax
  801bf2:	f7 f7                	div    %edi
  801bf4:	31 ff                	xor    %edi,%edi
  801bf6:	89 c3                	mov    %eax,%ebx
  801bf8:	89 d8                	mov    %ebx,%eax
  801bfa:	89 fa                	mov    %edi,%edx
  801bfc:	83 c4 1c             	add    $0x1c,%esp
  801bff:	5b                   	pop    %ebx
  801c00:	5e                   	pop    %esi
  801c01:	5f                   	pop    %edi
  801c02:	5d                   	pop    %ebp
  801c03:	c3                   	ret    
  801c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801c08:	39 ce                	cmp    %ecx,%esi
  801c0a:	72 0c                	jb     801c18 <__udivdi3+0x118>
  801c0c:	31 db                	xor    %ebx,%ebx
  801c0e:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c12:	0f 87 34 ff ff ff    	ja     801b4c <__udivdi3+0x4c>
  801c18:	bb 01 00 00 00       	mov    $0x1,%ebx
  801c1d:	e9 2a ff ff ff       	jmp    801b4c <__udivdi3+0x4c>
  801c22:	66 90                	xchg   %ax,%ax
  801c24:	66 90                	xchg   %ax,%ax
  801c26:	66 90                	xchg   %ax,%ax
  801c28:	66 90                	xchg   %ax,%ax
  801c2a:	66 90                	xchg   %ax,%ax
  801c2c:	66 90                	xchg   %ax,%ax
  801c2e:	66 90                	xchg   %ax,%ax

00801c30 <__umoddi3>:
  801c30:	55                   	push   %ebp
  801c31:	57                   	push   %edi
  801c32:	56                   	push   %esi
  801c33:	53                   	push   %ebx
  801c34:	83 ec 1c             	sub    $0x1c,%esp
  801c37:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801c3b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c3f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c47:	85 d2                	test   %edx,%edx
  801c49:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c51:	89 f3                	mov    %esi,%ebx
  801c53:	89 3c 24             	mov    %edi,(%esp)
  801c56:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c5a:	75 1c                	jne    801c78 <__umoddi3+0x48>
  801c5c:	39 f7                	cmp    %esi,%edi
  801c5e:	76 50                	jbe    801cb0 <__umoddi3+0x80>
  801c60:	89 c8                	mov    %ecx,%eax
  801c62:	89 f2                	mov    %esi,%edx
  801c64:	f7 f7                	div    %edi
  801c66:	89 d0                	mov    %edx,%eax
  801c68:	31 d2                	xor    %edx,%edx
  801c6a:	83 c4 1c             	add    $0x1c,%esp
  801c6d:	5b                   	pop    %ebx
  801c6e:	5e                   	pop    %esi
  801c6f:	5f                   	pop    %edi
  801c70:	5d                   	pop    %ebp
  801c71:	c3                   	ret    
  801c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c78:	39 f2                	cmp    %esi,%edx
  801c7a:	89 d0                	mov    %edx,%eax
  801c7c:	77 52                	ja     801cd0 <__umoddi3+0xa0>
  801c7e:	0f bd ea             	bsr    %edx,%ebp
  801c81:	83 f5 1f             	xor    $0x1f,%ebp
  801c84:	75 5a                	jne    801ce0 <__umoddi3+0xb0>
  801c86:	3b 54 24 04          	cmp    0x4(%esp),%edx
  801c8a:	0f 82 e0 00 00 00    	jb     801d70 <__umoddi3+0x140>
  801c90:	39 0c 24             	cmp    %ecx,(%esp)
  801c93:	0f 86 d7 00 00 00    	jbe    801d70 <__umoddi3+0x140>
  801c99:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c9d:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ca1:	83 c4 1c             	add    $0x1c,%esp
  801ca4:	5b                   	pop    %ebx
  801ca5:	5e                   	pop    %esi
  801ca6:	5f                   	pop    %edi
  801ca7:	5d                   	pop    %ebp
  801ca8:	c3                   	ret    
  801ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801cb0:	85 ff                	test   %edi,%edi
  801cb2:	89 fd                	mov    %edi,%ebp
  801cb4:	75 0b                	jne    801cc1 <__umoddi3+0x91>
  801cb6:	b8 01 00 00 00       	mov    $0x1,%eax
  801cbb:	31 d2                	xor    %edx,%edx
  801cbd:	f7 f7                	div    %edi
  801cbf:	89 c5                	mov    %eax,%ebp
  801cc1:	89 f0                	mov    %esi,%eax
  801cc3:	31 d2                	xor    %edx,%edx
  801cc5:	f7 f5                	div    %ebp
  801cc7:	89 c8                	mov    %ecx,%eax
  801cc9:	f7 f5                	div    %ebp
  801ccb:	89 d0                	mov    %edx,%eax
  801ccd:	eb 99                	jmp    801c68 <__umoddi3+0x38>
  801ccf:	90                   	nop
  801cd0:	89 c8                	mov    %ecx,%eax
  801cd2:	89 f2                	mov    %esi,%edx
  801cd4:	83 c4 1c             	add    $0x1c,%esp
  801cd7:	5b                   	pop    %ebx
  801cd8:	5e                   	pop    %esi
  801cd9:	5f                   	pop    %edi
  801cda:	5d                   	pop    %ebp
  801cdb:	c3                   	ret    
  801cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ce0:	8b 34 24             	mov    (%esp),%esi
  801ce3:	bf 20 00 00 00       	mov    $0x20,%edi
  801ce8:	89 e9                	mov    %ebp,%ecx
  801cea:	29 ef                	sub    %ebp,%edi
  801cec:	d3 e0                	shl    %cl,%eax
  801cee:	89 f9                	mov    %edi,%ecx
  801cf0:	89 f2                	mov    %esi,%edx
  801cf2:	d3 ea                	shr    %cl,%edx
  801cf4:	89 e9                	mov    %ebp,%ecx
  801cf6:	09 c2                	or     %eax,%edx
  801cf8:	89 d8                	mov    %ebx,%eax
  801cfa:	89 14 24             	mov    %edx,(%esp)
  801cfd:	89 f2                	mov    %esi,%edx
  801cff:	d3 e2                	shl    %cl,%edx
  801d01:	89 f9                	mov    %edi,%ecx
  801d03:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d07:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801d0b:	d3 e8                	shr    %cl,%eax
  801d0d:	89 e9                	mov    %ebp,%ecx
  801d0f:	89 c6                	mov    %eax,%esi
  801d11:	d3 e3                	shl    %cl,%ebx
  801d13:	89 f9                	mov    %edi,%ecx
  801d15:	89 d0                	mov    %edx,%eax
  801d17:	d3 e8                	shr    %cl,%eax
  801d19:	89 e9                	mov    %ebp,%ecx
  801d1b:	09 d8                	or     %ebx,%eax
  801d1d:	89 d3                	mov    %edx,%ebx
  801d1f:	89 f2                	mov    %esi,%edx
  801d21:	f7 34 24             	divl   (%esp)
  801d24:	89 d6                	mov    %edx,%esi
  801d26:	d3 e3                	shl    %cl,%ebx
  801d28:	f7 64 24 04          	mull   0x4(%esp)
  801d2c:	39 d6                	cmp    %edx,%esi
  801d2e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d32:	89 d1                	mov    %edx,%ecx
  801d34:	89 c3                	mov    %eax,%ebx
  801d36:	72 08                	jb     801d40 <__umoddi3+0x110>
  801d38:	75 11                	jne    801d4b <__umoddi3+0x11b>
  801d3a:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801d3e:	73 0b                	jae    801d4b <__umoddi3+0x11b>
  801d40:	2b 44 24 04          	sub    0x4(%esp),%eax
  801d44:	1b 14 24             	sbb    (%esp),%edx
  801d47:	89 d1                	mov    %edx,%ecx
  801d49:	89 c3                	mov    %eax,%ebx
  801d4b:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d4f:	29 da                	sub    %ebx,%edx
  801d51:	19 ce                	sbb    %ecx,%esi
  801d53:	89 f9                	mov    %edi,%ecx
  801d55:	89 f0                	mov    %esi,%eax
  801d57:	d3 e0                	shl    %cl,%eax
  801d59:	89 e9                	mov    %ebp,%ecx
  801d5b:	d3 ea                	shr    %cl,%edx
  801d5d:	89 e9                	mov    %ebp,%ecx
  801d5f:	d3 ee                	shr    %cl,%esi
  801d61:	09 d0                	or     %edx,%eax
  801d63:	89 f2                	mov    %esi,%edx
  801d65:	83 c4 1c             	add    $0x1c,%esp
  801d68:	5b                   	pop    %ebx
  801d69:	5e                   	pop    %esi
  801d6a:	5f                   	pop    %edi
  801d6b:	5d                   	pop    %ebp
  801d6c:	c3                   	ret    
  801d6d:	8d 76 00             	lea    0x0(%esi),%esi
  801d70:	29 f9                	sub    %edi,%ecx
  801d72:	19 d6                	sbb    %edx,%esi
  801d74:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d78:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d7c:	e9 18 ff ff ff       	jmp    801c99 <__umoddi3+0x69>
