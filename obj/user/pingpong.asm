
obj/user/pingpong.debug:     formato del fichero elf32-i386


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
  80002c:	e8 8d 00 00 00       	call   8000be <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  80003c:	e8 d6 0f 00 00       	call   801017 <fork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	74 27                	je     80006f <umain+0x3c>
  800048:	89 c3                	mov    %eax,%ebx
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  80004a:	e8 d6 0a 00 00       	call   800b25 <sys_getenvid>
  80004f:	83 ec 04             	sub    $0x4,%esp
  800052:	53                   	push   %ebx
  800053:	50                   	push   %eax
  800054:	68 00 23 80 00       	push   $0x802300
  800059:	e8 57 01 00 00       	call   8001b5 <cprintf>
		ipc_send(who, 0, 0, 0);
  80005e:	6a 00                	push   $0x0
  800060:	6a 00                	push   $0x0
  800062:	6a 00                	push   $0x0
  800064:	ff 75 e4             	pushl  -0x1c(%ebp)
  800067:	e8 43 11 00 00       	call   8011af <ipc_send>
  80006c:	83 c4 20             	add    $0x20,%esp
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  80006f:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800072:	83 ec 04             	sub    $0x4,%esp
  800075:	6a 00                	push   $0x0
  800077:	6a 00                	push   $0x0
  800079:	56                   	push   %esi
  80007a:	e8 c5 10 00 00       	call   801144 <ipc_recv>
  80007f:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  800081:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800084:	e8 9c 0a 00 00       	call   800b25 <sys_getenvid>
  800089:	57                   	push   %edi
  80008a:	53                   	push   %ebx
  80008b:	50                   	push   %eax
  80008c:	68 16 23 80 00       	push   $0x802316
  800091:	e8 1f 01 00 00       	call   8001b5 <cprintf>
		if (i == 10)
  800096:	83 c4 20             	add    $0x20,%esp
  800099:	83 fb 0a             	cmp    $0xa,%ebx
  80009c:	74 18                	je     8000b6 <umain+0x83>
			return;
		i++;
  80009e:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  8000a1:	6a 00                	push   $0x0
  8000a3:	6a 00                	push   $0x0
  8000a5:	53                   	push   %ebx
  8000a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000a9:	e8 01 11 00 00       	call   8011af <ipc_send>
		if (i == 10)
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	83 fb 0a             	cmp    $0xa,%ebx
  8000b4:	75 bc                	jne    800072 <umain+0x3f>
			return;
	}

}
  8000b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000b9:	5b                   	pop    %ebx
  8000ba:	5e                   	pop    %esi
  8000bb:	5f                   	pop    %edi
  8000bc:	5d                   	pop    %ebp
  8000bd:	c3                   	ret    

008000be <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000be:	55                   	push   %ebp
  8000bf:	89 e5                	mov    %esp,%ebp
  8000c1:	56                   	push   %esi
  8000c2:	53                   	push   %ebx
  8000c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000c6:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8000c9:	e8 57 0a 00 00       	call   800b25 <sys_getenvid>
	if (id >= 0)
  8000ce:	85 c0                	test   %eax,%eax
  8000d0:	78 12                	js     8000e4 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  8000d2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000da:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000df:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e4:	85 db                	test   %ebx,%ebx
  8000e6:	7e 07                	jle    8000ef <libmain+0x31>
		binaryname = argv[0];
  8000e8:	8b 06                	mov    (%esi),%eax
  8000ea:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ef:	83 ec 08             	sub    $0x8,%esp
  8000f2:	56                   	push   %esi
  8000f3:	53                   	push   %ebx
  8000f4:	e8 3a ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000f9:	e8 0a 00 00 00       	call   800108 <exit>
}
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800104:	5b                   	pop    %ebx
  800105:	5e                   	pop    %esi
  800106:	5d                   	pop    %ebp
  800107:	c3                   	ret    

00800108 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800108:	55                   	push   %ebp
  800109:	89 e5                	mov    %esp,%ebp
  80010b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80010e:	e8 f4 12 00 00       	call   801407 <close_all>
	sys_env_destroy(0);
  800113:	83 ec 0c             	sub    $0xc,%esp
  800116:	6a 00                	push   $0x0
  800118:	e8 e6 09 00 00       	call   800b03 <sys_env_destroy>
}
  80011d:	83 c4 10             	add    $0x10,%esp
  800120:	c9                   	leave  
  800121:	c3                   	ret    

00800122 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800122:	55                   	push   %ebp
  800123:	89 e5                	mov    %esp,%ebp
  800125:	53                   	push   %ebx
  800126:	83 ec 04             	sub    $0x4,%esp
  800129:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80012c:	8b 13                	mov    (%ebx),%edx
  80012e:	8d 42 01             	lea    0x1(%edx),%eax
  800131:	89 03                	mov    %eax,(%ebx)
  800133:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800136:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80013a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80013f:	75 1a                	jne    80015b <putch+0x39>
		sys_cputs(b->buf, b->idx);
  800141:	83 ec 08             	sub    $0x8,%esp
  800144:	68 ff 00 00 00       	push   $0xff
  800149:	8d 43 08             	lea    0x8(%ebx),%eax
  80014c:	50                   	push   %eax
  80014d:	e8 67 09 00 00       	call   800ab9 <sys_cputs>
		b->idx = 0;
  800152:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800158:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  80015b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80015f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800162:	c9                   	leave  
  800163:	c3                   	ret    

00800164 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80016d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800174:	00 00 00 
	b.cnt = 0;
  800177:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80017e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800181:	ff 75 0c             	pushl  0xc(%ebp)
  800184:	ff 75 08             	pushl  0x8(%ebp)
  800187:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80018d:	50                   	push   %eax
  80018e:	68 22 01 80 00       	push   $0x800122
  800193:	e8 86 01 00 00       	call   80031e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800198:	83 c4 08             	add    $0x8,%esp
  80019b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001a1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001a7:	50                   	push   %eax
  8001a8:	e8 0c 09 00 00       	call   800ab9 <sys_cputs>

	return b.cnt;
}
  8001ad:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001b3:	c9                   	leave  
  8001b4:	c3                   	ret    

008001b5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001bb:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001be:	50                   	push   %eax
  8001bf:	ff 75 08             	pushl  0x8(%ebp)
  8001c2:	e8 9d ff ff ff       	call   800164 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    

008001c9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	57                   	push   %edi
  8001cd:	56                   	push   %esi
  8001ce:	53                   	push   %ebx
  8001cf:	83 ec 1c             	sub    $0x1c,%esp
  8001d2:	89 c7                	mov    %eax,%edi
  8001d4:	89 d6                	mov    %edx,%esi
  8001d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001df:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001ea:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001ed:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001f0:	39 d3                	cmp    %edx,%ebx
  8001f2:	72 05                	jb     8001f9 <printnum+0x30>
  8001f4:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001f7:	77 45                	ja     80023e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f9:	83 ec 0c             	sub    $0xc,%esp
  8001fc:	ff 75 18             	pushl  0x18(%ebp)
  8001ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800202:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800205:	53                   	push   %ebx
  800206:	ff 75 10             	pushl  0x10(%ebp)
  800209:	83 ec 08             	sub    $0x8,%esp
  80020c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80020f:	ff 75 e0             	pushl  -0x20(%ebp)
  800212:	ff 75 dc             	pushl  -0x24(%ebp)
  800215:	ff 75 d8             	pushl  -0x28(%ebp)
  800218:	e8 43 1e 00 00       	call   802060 <__udivdi3>
  80021d:	83 c4 18             	add    $0x18,%esp
  800220:	52                   	push   %edx
  800221:	50                   	push   %eax
  800222:	89 f2                	mov    %esi,%edx
  800224:	89 f8                	mov    %edi,%eax
  800226:	e8 9e ff ff ff       	call   8001c9 <printnum>
  80022b:	83 c4 20             	add    $0x20,%esp
  80022e:	eb 18                	jmp    800248 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	56                   	push   %esi
  800234:	ff 75 18             	pushl  0x18(%ebp)
  800237:	ff d7                	call   *%edi
  800239:	83 c4 10             	add    $0x10,%esp
  80023c:	eb 03                	jmp    800241 <printnum+0x78>
  80023e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800241:	83 eb 01             	sub    $0x1,%ebx
  800244:	85 db                	test   %ebx,%ebx
  800246:	7f e8                	jg     800230 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800248:	83 ec 08             	sub    $0x8,%esp
  80024b:	56                   	push   %esi
  80024c:	83 ec 04             	sub    $0x4,%esp
  80024f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800252:	ff 75 e0             	pushl  -0x20(%ebp)
  800255:	ff 75 dc             	pushl  -0x24(%ebp)
  800258:	ff 75 d8             	pushl  -0x28(%ebp)
  80025b:	e8 30 1f 00 00       	call   802190 <__umoddi3>
  800260:	83 c4 14             	add    $0x14,%esp
  800263:	0f be 80 33 23 80 00 	movsbl 0x802333(%eax),%eax
  80026a:	50                   	push   %eax
  80026b:	ff d7                	call   *%edi
}
  80026d:	83 c4 10             	add    $0x10,%esp
  800270:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800273:	5b                   	pop    %ebx
  800274:	5e                   	pop    %esi
  800275:	5f                   	pop    %edi
  800276:	5d                   	pop    %ebp
  800277:	c3                   	ret    

00800278 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80027b:	83 fa 01             	cmp    $0x1,%edx
  80027e:	7e 0e                	jle    80028e <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800280:	8b 10                	mov    (%eax),%edx
  800282:	8d 4a 08             	lea    0x8(%edx),%ecx
  800285:	89 08                	mov    %ecx,(%eax)
  800287:	8b 02                	mov    (%edx),%eax
  800289:	8b 52 04             	mov    0x4(%edx),%edx
  80028c:	eb 22                	jmp    8002b0 <getuint+0x38>
	else if (lflag)
  80028e:	85 d2                	test   %edx,%edx
  800290:	74 10                	je     8002a2 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800292:	8b 10                	mov    (%eax),%edx
  800294:	8d 4a 04             	lea    0x4(%edx),%ecx
  800297:	89 08                	mov    %ecx,(%eax)
  800299:	8b 02                	mov    (%edx),%eax
  80029b:	ba 00 00 00 00       	mov    $0x0,%edx
  8002a0:	eb 0e                	jmp    8002b0 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002a2:	8b 10                	mov    (%eax),%edx
  8002a4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002a7:	89 08                	mov    %ecx,(%eax)
  8002a9:	8b 02                	mov    (%edx),%eax
  8002ab:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002b0:	5d                   	pop    %ebp
  8002b1:	c3                   	ret    

008002b2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002b5:	83 fa 01             	cmp    $0x1,%edx
  8002b8:	7e 0e                	jle    8002c8 <getint+0x16>
		return va_arg(*ap, long long);
  8002ba:	8b 10                	mov    (%eax),%edx
  8002bc:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002bf:	89 08                	mov    %ecx,(%eax)
  8002c1:	8b 02                	mov    (%edx),%eax
  8002c3:	8b 52 04             	mov    0x4(%edx),%edx
  8002c6:	eb 1a                	jmp    8002e2 <getint+0x30>
	else if (lflag)
  8002c8:	85 d2                	test   %edx,%edx
  8002ca:	74 0c                	je     8002d8 <getint+0x26>
		return va_arg(*ap, long);
  8002cc:	8b 10                	mov    (%eax),%edx
  8002ce:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002d1:	89 08                	mov    %ecx,(%eax)
  8002d3:	8b 02                	mov    (%edx),%eax
  8002d5:	99                   	cltd   
  8002d6:	eb 0a                	jmp    8002e2 <getint+0x30>
	else
		return va_arg(*ap, int);
  8002d8:	8b 10                	mov    (%eax),%edx
  8002da:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002dd:	89 08                	mov    %ecx,(%eax)
  8002df:	8b 02                	mov    (%edx),%eax
  8002e1:	99                   	cltd   
}
  8002e2:	5d                   	pop    %ebp
  8002e3:	c3                   	ret    

008002e4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ea:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ee:	8b 10                	mov    (%eax),%edx
  8002f0:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f3:	73 0a                	jae    8002ff <sprintputch+0x1b>
		*b->buf++ = ch;
  8002f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002f8:	89 08                	mov    %ecx,(%eax)
  8002fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fd:	88 02                	mov    %al,(%edx)
}
  8002ff:	5d                   	pop    %ebp
  800300:	c3                   	ret    

00800301 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800301:	55                   	push   %ebp
  800302:	89 e5                	mov    %esp,%ebp
  800304:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800307:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80030a:	50                   	push   %eax
  80030b:	ff 75 10             	pushl  0x10(%ebp)
  80030e:	ff 75 0c             	pushl  0xc(%ebp)
  800311:	ff 75 08             	pushl  0x8(%ebp)
  800314:	e8 05 00 00 00       	call   80031e <vprintfmt>
	va_end(ap);
}
  800319:	83 c4 10             	add    $0x10,%esp
  80031c:	c9                   	leave  
  80031d:	c3                   	ret    

0080031e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80031e:	55                   	push   %ebp
  80031f:	89 e5                	mov    %esp,%ebp
  800321:	57                   	push   %edi
  800322:	56                   	push   %esi
  800323:	53                   	push   %ebx
  800324:	83 ec 2c             	sub    $0x2c,%esp
  800327:	8b 75 08             	mov    0x8(%ebp),%esi
  80032a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80032d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800330:	eb 12                	jmp    800344 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800332:	85 c0                	test   %eax,%eax
  800334:	0f 84 44 03 00 00    	je     80067e <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  80033a:	83 ec 08             	sub    $0x8,%esp
  80033d:	53                   	push   %ebx
  80033e:	50                   	push   %eax
  80033f:	ff d6                	call   *%esi
  800341:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800344:	83 c7 01             	add    $0x1,%edi
  800347:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80034b:	83 f8 25             	cmp    $0x25,%eax
  80034e:	75 e2                	jne    800332 <vprintfmt+0x14>
  800350:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800354:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80035b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800362:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800369:	ba 00 00 00 00       	mov    $0x0,%edx
  80036e:	eb 07                	jmp    800377 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800370:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800373:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800377:	8d 47 01             	lea    0x1(%edi),%eax
  80037a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80037d:	0f b6 07             	movzbl (%edi),%eax
  800380:	0f b6 c8             	movzbl %al,%ecx
  800383:	83 e8 23             	sub    $0x23,%eax
  800386:	3c 55                	cmp    $0x55,%al
  800388:	0f 87 d5 02 00 00    	ja     800663 <vprintfmt+0x345>
  80038e:	0f b6 c0             	movzbl %al,%eax
  800391:	ff 24 85 80 24 80 00 	jmp    *0x802480(,%eax,4)
  800398:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80039b:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80039f:	eb d6                	jmp    800377 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003ac:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003af:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8003b3:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8003b6:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8003b9:	83 fa 09             	cmp    $0x9,%edx
  8003bc:	77 39                	ja     8003f7 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003be:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003c1:	eb e9                	jmp    8003ac <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c6:	8d 48 04             	lea    0x4(%eax),%ecx
  8003c9:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8003cc:	8b 00                	mov    (%eax),%eax
  8003ce:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003d4:	eb 27                	jmp    8003fd <vprintfmt+0xdf>
  8003d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d9:	85 c0                	test   %eax,%eax
  8003db:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003e0:	0f 49 c8             	cmovns %eax,%ecx
  8003e3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003e9:	eb 8c                	jmp    800377 <vprintfmt+0x59>
  8003eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8003ee:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003f5:	eb 80                	jmp    800377 <vprintfmt+0x59>
  8003f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003fa:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  8003fd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800401:	0f 89 70 ff ff ff    	jns    800377 <vprintfmt+0x59>
				width = precision, precision = -1;
  800407:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80040a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80040d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800414:	e9 5e ff ff ff       	jmp    800377 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800419:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80041c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80041f:	e9 53 ff ff ff       	jmp    800377 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800424:	8b 45 14             	mov    0x14(%ebp),%eax
  800427:	8d 50 04             	lea    0x4(%eax),%edx
  80042a:	89 55 14             	mov    %edx,0x14(%ebp)
  80042d:	83 ec 08             	sub    $0x8,%esp
  800430:	53                   	push   %ebx
  800431:	ff 30                	pushl  (%eax)
  800433:	ff d6                	call   *%esi
			break;
  800435:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800438:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  80043b:	e9 04 ff ff ff       	jmp    800344 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800440:	8b 45 14             	mov    0x14(%ebp),%eax
  800443:	8d 50 04             	lea    0x4(%eax),%edx
  800446:	89 55 14             	mov    %edx,0x14(%ebp)
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	99                   	cltd   
  80044c:	31 d0                	xor    %edx,%eax
  80044e:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800450:	83 f8 0f             	cmp    $0xf,%eax
  800453:	7f 0b                	jg     800460 <vprintfmt+0x142>
  800455:	8b 14 85 e0 25 80 00 	mov    0x8025e0(,%eax,4),%edx
  80045c:	85 d2                	test   %edx,%edx
  80045e:	75 18                	jne    800478 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  800460:	50                   	push   %eax
  800461:	68 4b 23 80 00       	push   $0x80234b
  800466:	53                   	push   %ebx
  800467:	56                   	push   %esi
  800468:	e8 94 fe ff ff       	call   800301 <printfmt>
  80046d:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800470:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800473:	e9 cc fe ff ff       	jmp    800344 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  800478:	52                   	push   %edx
  800479:	68 95 28 80 00       	push   $0x802895
  80047e:	53                   	push   %ebx
  80047f:	56                   	push   %esi
  800480:	e8 7c fe ff ff       	call   800301 <printfmt>
  800485:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800488:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80048b:	e9 b4 fe ff ff       	jmp    800344 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800490:	8b 45 14             	mov    0x14(%ebp),%eax
  800493:	8d 50 04             	lea    0x4(%eax),%edx
  800496:	89 55 14             	mov    %edx,0x14(%ebp)
  800499:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80049b:	85 ff                	test   %edi,%edi
  80049d:	b8 44 23 80 00       	mov    $0x802344,%eax
  8004a2:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004a9:	0f 8e 94 00 00 00    	jle    800543 <vprintfmt+0x225>
  8004af:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004b3:	0f 84 98 00 00 00    	je     800551 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b9:	83 ec 08             	sub    $0x8,%esp
  8004bc:	ff 75 d0             	pushl  -0x30(%ebp)
  8004bf:	57                   	push   %edi
  8004c0:	e8 41 02 00 00       	call   800706 <strnlen>
  8004c5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c8:	29 c1                	sub    %eax,%ecx
  8004ca:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8004cd:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004d0:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d7:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004da:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004dc:	eb 0f                	jmp    8004ed <vprintfmt+0x1cf>
					putch(padc, putdat);
  8004de:	83 ec 08             	sub    $0x8,%esp
  8004e1:	53                   	push   %ebx
  8004e2:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e5:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e7:	83 ef 01             	sub    $0x1,%edi
  8004ea:	83 c4 10             	add    $0x10,%esp
  8004ed:	85 ff                	test   %edi,%edi
  8004ef:	7f ed                	jg     8004de <vprintfmt+0x1c0>
  8004f1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004f4:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8004f7:	85 c9                	test   %ecx,%ecx
  8004f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004fe:	0f 49 c1             	cmovns %ecx,%eax
  800501:	29 c1                	sub    %eax,%ecx
  800503:	89 75 08             	mov    %esi,0x8(%ebp)
  800506:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800509:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80050c:	89 cb                	mov    %ecx,%ebx
  80050e:	eb 4d                	jmp    80055d <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800510:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800514:	74 1b                	je     800531 <vprintfmt+0x213>
  800516:	0f be c0             	movsbl %al,%eax
  800519:	83 e8 20             	sub    $0x20,%eax
  80051c:	83 f8 5e             	cmp    $0x5e,%eax
  80051f:	76 10                	jbe    800531 <vprintfmt+0x213>
					putch('?', putdat);
  800521:	83 ec 08             	sub    $0x8,%esp
  800524:	ff 75 0c             	pushl  0xc(%ebp)
  800527:	6a 3f                	push   $0x3f
  800529:	ff 55 08             	call   *0x8(%ebp)
  80052c:	83 c4 10             	add    $0x10,%esp
  80052f:	eb 0d                	jmp    80053e <vprintfmt+0x220>
				else
					putch(ch, putdat);
  800531:	83 ec 08             	sub    $0x8,%esp
  800534:	ff 75 0c             	pushl  0xc(%ebp)
  800537:	52                   	push   %edx
  800538:	ff 55 08             	call   *0x8(%ebp)
  80053b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80053e:	83 eb 01             	sub    $0x1,%ebx
  800541:	eb 1a                	jmp    80055d <vprintfmt+0x23f>
  800543:	89 75 08             	mov    %esi,0x8(%ebp)
  800546:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800549:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80054c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80054f:	eb 0c                	jmp    80055d <vprintfmt+0x23f>
  800551:	89 75 08             	mov    %esi,0x8(%ebp)
  800554:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800557:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80055a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80055d:	83 c7 01             	add    $0x1,%edi
  800560:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800564:	0f be d0             	movsbl %al,%edx
  800567:	85 d2                	test   %edx,%edx
  800569:	74 23                	je     80058e <vprintfmt+0x270>
  80056b:	85 f6                	test   %esi,%esi
  80056d:	78 a1                	js     800510 <vprintfmt+0x1f2>
  80056f:	83 ee 01             	sub    $0x1,%esi
  800572:	79 9c                	jns    800510 <vprintfmt+0x1f2>
  800574:	89 df                	mov    %ebx,%edi
  800576:	8b 75 08             	mov    0x8(%ebp),%esi
  800579:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80057c:	eb 18                	jmp    800596 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80057e:	83 ec 08             	sub    $0x8,%esp
  800581:	53                   	push   %ebx
  800582:	6a 20                	push   $0x20
  800584:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800586:	83 ef 01             	sub    $0x1,%edi
  800589:	83 c4 10             	add    $0x10,%esp
  80058c:	eb 08                	jmp    800596 <vprintfmt+0x278>
  80058e:	89 df                	mov    %ebx,%edi
  800590:	8b 75 08             	mov    0x8(%ebp),%esi
  800593:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800596:	85 ff                	test   %edi,%edi
  800598:	7f e4                	jg     80057e <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80059a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80059d:	e9 a2 fd ff ff       	jmp    800344 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005a2:	8d 45 14             	lea    0x14(%ebp),%eax
  8005a5:	e8 08 fd ff ff       	call   8002b2 <getint>
  8005aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ad:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8005b0:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8005b5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005b9:	79 74                	jns    80062f <vprintfmt+0x311>
				putch('-', putdat);
  8005bb:	83 ec 08             	sub    $0x8,%esp
  8005be:	53                   	push   %ebx
  8005bf:	6a 2d                	push   $0x2d
  8005c1:	ff d6                	call   *%esi
				num = -(long long) num;
  8005c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005c6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005c9:	f7 d8                	neg    %eax
  8005cb:	83 d2 00             	adc    $0x0,%edx
  8005ce:	f7 da                	neg    %edx
  8005d0:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8005d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8005d8:	eb 55                	jmp    80062f <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8005da:	8d 45 14             	lea    0x14(%ebp),%eax
  8005dd:	e8 96 fc ff ff       	call   800278 <getuint>
			base = 10;
  8005e2:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8005e7:	eb 46                	jmp    80062f <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8005e9:	8d 45 14             	lea    0x14(%ebp),%eax
  8005ec:	e8 87 fc ff ff       	call   800278 <getuint>
			base = 8;
  8005f1:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8005f6:	eb 37                	jmp    80062f <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  8005f8:	83 ec 08             	sub    $0x8,%esp
  8005fb:	53                   	push   %ebx
  8005fc:	6a 30                	push   $0x30
  8005fe:	ff d6                	call   *%esi
			putch('x', putdat);
  800600:	83 c4 08             	add    $0x8,%esp
  800603:	53                   	push   %ebx
  800604:	6a 78                	push   $0x78
  800606:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8d 50 04             	lea    0x4(%eax),%edx
  80060e:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800611:	8b 00                	mov    (%eax),%eax
  800613:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800618:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80061b:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800620:	eb 0d                	jmp    80062f <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800622:	8d 45 14             	lea    0x14(%ebp),%eax
  800625:	e8 4e fc ff ff       	call   800278 <getuint>
			base = 16;
  80062a:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  80062f:	83 ec 0c             	sub    $0xc,%esp
  800632:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800636:	57                   	push   %edi
  800637:	ff 75 e0             	pushl  -0x20(%ebp)
  80063a:	51                   	push   %ecx
  80063b:	52                   	push   %edx
  80063c:	50                   	push   %eax
  80063d:	89 da                	mov    %ebx,%edx
  80063f:	89 f0                	mov    %esi,%eax
  800641:	e8 83 fb ff ff       	call   8001c9 <printnum>
			break;
  800646:	83 c4 20             	add    $0x20,%esp
  800649:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80064c:	e9 f3 fc ff ff       	jmp    800344 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	53                   	push   %ebx
  800655:	51                   	push   %ecx
  800656:	ff d6                	call   *%esi
			break;
  800658:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80065b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  80065e:	e9 e1 fc ff ff       	jmp    800344 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800663:	83 ec 08             	sub    $0x8,%esp
  800666:	53                   	push   %ebx
  800667:	6a 25                	push   $0x25
  800669:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	eb 03                	jmp    800673 <vprintfmt+0x355>
  800670:	83 ef 01             	sub    $0x1,%edi
  800673:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  800677:	75 f7                	jne    800670 <vprintfmt+0x352>
  800679:	e9 c6 fc ff ff       	jmp    800344 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  80067e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800681:	5b                   	pop    %ebx
  800682:	5e                   	pop    %esi
  800683:	5f                   	pop    %edi
  800684:	5d                   	pop    %ebp
  800685:	c3                   	ret    

00800686 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800686:	55                   	push   %ebp
  800687:	89 e5                	mov    %esp,%ebp
  800689:	83 ec 18             	sub    $0x18,%esp
  80068c:	8b 45 08             	mov    0x8(%ebp),%eax
  80068f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800692:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800695:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800699:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80069c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006a3:	85 c0                	test   %eax,%eax
  8006a5:	74 26                	je     8006cd <vsnprintf+0x47>
  8006a7:	85 d2                	test   %edx,%edx
  8006a9:	7e 22                	jle    8006cd <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006ab:	ff 75 14             	pushl  0x14(%ebp)
  8006ae:	ff 75 10             	pushl  0x10(%ebp)
  8006b1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006b4:	50                   	push   %eax
  8006b5:	68 e4 02 80 00       	push   $0x8002e4
  8006ba:	e8 5f fc ff ff       	call   80031e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006c2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006c8:	83 c4 10             	add    $0x10,%esp
  8006cb:	eb 05                	jmp    8006d2 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8006cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8006d2:	c9                   	leave  
  8006d3:	c3                   	ret    

008006d4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006d4:	55                   	push   %ebp
  8006d5:	89 e5                	mov    %esp,%ebp
  8006d7:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8006da:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8006dd:	50                   	push   %eax
  8006de:	ff 75 10             	pushl  0x10(%ebp)
  8006e1:	ff 75 0c             	pushl  0xc(%ebp)
  8006e4:	ff 75 08             	pushl  0x8(%ebp)
  8006e7:	e8 9a ff ff ff       	call   800686 <vsnprintf>
	va_end(ap);

	return rc;
}
  8006ec:	c9                   	leave  
  8006ed:	c3                   	ret    

008006ee <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8006ee:	55                   	push   %ebp
  8006ef:	89 e5                	mov    %esp,%ebp
  8006f1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8006f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f9:	eb 03                	jmp    8006fe <strlen+0x10>
		n++;
  8006fb:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8006fe:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800702:	75 f7                	jne    8006fb <strlen+0xd>
		n++;
	return n;
}
  800704:	5d                   	pop    %ebp
  800705:	c3                   	ret    

00800706 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800706:	55                   	push   %ebp
  800707:	89 e5                	mov    %esp,%ebp
  800709:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80070c:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80070f:	ba 00 00 00 00       	mov    $0x0,%edx
  800714:	eb 03                	jmp    800719 <strnlen+0x13>
		n++;
  800716:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800719:	39 c2                	cmp    %eax,%edx
  80071b:	74 08                	je     800725 <strnlen+0x1f>
  80071d:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800721:	75 f3                	jne    800716 <strnlen+0x10>
  800723:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  800725:	5d                   	pop    %ebp
  800726:	c3                   	ret    

00800727 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800727:	55                   	push   %ebp
  800728:	89 e5                	mov    %esp,%ebp
  80072a:	53                   	push   %ebx
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800731:	89 c2                	mov    %eax,%edx
  800733:	83 c2 01             	add    $0x1,%edx
  800736:	83 c1 01             	add    $0x1,%ecx
  800739:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80073d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800740:	84 db                	test   %bl,%bl
  800742:	75 ef                	jne    800733 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800744:	5b                   	pop    %ebx
  800745:	5d                   	pop    %ebp
  800746:	c3                   	ret    

00800747 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800747:	55                   	push   %ebp
  800748:	89 e5                	mov    %esp,%ebp
  80074a:	53                   	push   %ebx
  80074b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80074e:	53                   	push   %ebx
  80074f:	e8 9a ff ff ff       	call   8006ee <strlen>
  800754:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800757:	ff 75 0c             	pushl  0xc(%ebp)
  80075a:	01 d8                	add    %ebx,%eax
  80075c:	50                   	push   %eax
  80075d:	e8 c5 ff ff ff       	call   800727 <strcpy>
	return dst;
}
  800762:	89 d8                	mov    %ebx,%eax
  800764:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800767:	c9                   	leave  
  800768:	c3                   	ret    

00800769 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800769:	55                   	push   %ebp
  80076a:	89 e5                	mov    %esp,%ebp
  80076c:	56                   	push   %esi
  80076d:	53                   	push   %ebx
  80076e:	8b 75 08             	mov    0x8(%ebp),%esi
  800771:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800774:	89 f3                	mov    %esi,%ebx
  800776:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800779:	89 f2                	mov    %esi,%edx
  80077b:	eb 0f                	jmp    80078c <strncpy+0x23>
		*dst++ = *src;
  80077d:	83 c2 01             	add    $0x1,%edx
  800780:	0f b6 01             	movzbl (%ecx),%eax
  800783:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800786:	80 39 01             	cmpb   $0x1,(%ecx)
  800789:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80078c:	39 da                	cmp    %ebx,%edx
  80078e:	75 ed                	jne    80077d <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800790:	89 f0                	mov    %esi,%eax
  800792:	5b                   	pop    %ebx
  800793:	5e                   	pop    %esi
  800794:	5d                   	pop    %ebp
  800795:	c3                   	ret    

00800796 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800796:	55                   	push   %ebp
  800797:	89 e5                	mov    %esp,%ebp
  800799:	56                   	push   %esi
  80079a:	53                   	push   %ebx
  80079b:	8b 75 08             	mov    0x8(%ebp),%esi
  80079e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007a1:	8b 55 10             	mov    0x10(%ebp),%edx
  8007a4:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007a6:	85 d2                	test   %edx,%edx
  8007a8:	74 21                	je     8007cb <strlcpy+0x35>
  8007aa:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8007ae:	89 f2                	mov    %esi,%edx
  8007b0:	eb 09                	jmp    8007bb <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8007b2:	83 c2 01             	add    $0x1,%edx
  8007b5:	83 c1 01             	add    $0x1,%ecx
  8007b8:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8007bb:	39 c2                	cmp    %eax,%edx
  8007bd:	74 09                	je     8007c8 <strlcpy+0x32>
  8007bf:	0f b6 19             	movzbl (%ecx),%ebx
  8007c2:	84 db                	test   %bl,%bl
  8007c4:	75 ec                	jne    8007b2 <strlcpy+0x1c>
  8007c6:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  8007c8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007cb:	29 f0                	sub    %esi,%eax
}
  8007cd:	5b                   	pop    %ebx
  8007ce:	5e                   	pop    %esi
  8007cf:	5d                   	pop    %ebp
  8007d0:	c3                   	ret    

008007d1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007d1:	55                   	push   %ebp
  8007d2:	89 e5                	mov    %esp,%ebp
  8007d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007d7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007da:	eb 06                	jmp    8007e2 <strcmp+0x11>
		p++, q++;
  8007dc:	83 c1 01             	add    $0x1,%ecx
  8007df:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8007e2:	0f b6 01             	movzbl (%ecx),%eax
  8007e5:	84 c0                	test   %al,%al
  8007e7:	74 04                	je     8007ed <strcmp+0x1c>
  8007e9:	3a 02                	cmp    (%edx),%al
  8007eb:	74 ef                	je     8007dc <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8007ed:	0f b6 c0             	movzbl %al,%eax
  8007f0:	0f b6 12             	movzbl (%edx),%edx
  8007f3:	29 d0                	sub    %edx,%eax
}
  8007f5:	5d                   	pop    %ebp
  8007f6:	c3                   	ret    

008007f7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8007f7:	55                   	push   %ebp
  8007f8:	89 e5                	mov    %esp,%ebp
  8007fa:	53                   	push   %ebx
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800801:	89 c3                	mov    %eax,%ebx
  800803:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800806:	eb 06                	jmp    80080e <strncmp+0x17>
		n--, p++, q++;
  800808:	83 c0 01             	add    $0x1,%eax
  80080b:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80080e:	39 d8                	cmp    %ebx,%eax
  800810:	74 15                	je     800827 <strncmp+0x30>
  800812:	0f b6 08             	movzbl (%eax),%ecx
  800815:	84 c9                	test   %cl,%cl
  800817:	74 04                	je     80081d <strncmp+0x26>
  800819:	3a 0a                	cmp    (%edx),%cl
  80081b:	74 eb                	je     800808 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80081d:	0f b6 00             	movzbl (%eax),%eax
  800820:	0f b6 12             	movzbl (%edx),%edx
  800823:	29 d0                	sub    %edx,%eax
  800825:	eb 05                	jmp    80082c <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800827:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  80082c:	5b                   	pop    %ebx
  80082d:	5d                   	pop    %ebp
  80082e:	c3                   	ret    

0080082f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80082f:	55                   	push   %ebp
  800830:	89 e5                	mov    %esp,%ebp
  800832:	8b 45 08             	mov    0x8(%ebp),%eax
  800835:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800839:	eb 07                	jmp    800842 <strchr+0x13>
		if (*s == c)
  80083b:	38 ca                	cmp    %cl,%dl
  80083d:	74 0f                	je     80084e <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80083f:	83 c0 01             	add    $0x1,%eax
  800842:	0f b6 10             	movzbl (%eax),%edx
  800845:	84 d2                	test   %dl,%dl
  800847:	75 f2                	jne    80083b <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800849:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80084e:	5d                   	pop    %ebp
  80084f:	c3                   	ret    

00800850 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800850:	55                   	push   %ebp
  800851:	89 e5                	mov    %esp,%ebp
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80085a:	eb 03                	jmp    80085f <strfind+0xf>
  80085c:	83 c0 01             	add    $0x1,%eax
  80085f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800862:	38 ca                	cmp    %cl,%dl
  800864:	74 04                	je     80086a <strfind+0x1a>
  800866:	84 d2                	test   %dl,%dl
  800868:	75 f2                	jne    80085c <strfind+0xc>
			break;
	return (char *) s;
}
  80086a:	5d                   	pop    %ebp
  80086b:	c3                   	ret    

0080086c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80086c:	55                   	push   %ebp
  80086d:	89 e5                	mov    %esp,%ebp
  80086f:	57                   	push   %edi
  800870:	56                   	push   %esi
  800871:	53                   	push   %ebx
  800872:	8b 55 08             	mov    0x8(%ebp),%edx
  800875:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800878:	85 c9                	test   %ecx,%ecx
  80087a:	74 37                	je     8008b3 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80087c:	f6 c2 03             	test   $0x3,%dl
  80087f:	75 2a                	jne    8008ab <memset+0x3f>
  800881:	f6 c1 03             	test   $0x3,%cl
  800884:	75 25                	jne    8008ab <memset+0x3f>
		c &= 0xFF;
  800886:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80088a:	89 df                	mov    %ebx,%edi
  80088c:	c1 e7 08             	shl    $0x8,%edi
  80088f:	89 de                	mov    %ebx,%esi
  800891:	c1 e6 18             	shl    $0x18,%esi
  800894:	89 d8                	mov    %ebx,%eax
  800896:	c1 e0 10             	shl    $0x10,%eax
  800899:	09 f0                	or     %esi,%eax
  80089b:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  80089d:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8008a0:	89 f8                	mov    %edi,%eax
  8008a2:	09 d8                	or     %ebx,%eax
  8008a4:	89 d7                	mov    %edx,%edi
  8008a6:	fc                   	cld    
  8008a7:	f3 ab                	rep stos %eax,%es:(%edi)
  8008a9:	eb 08                	jmp    8008b3 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008ab:	89 d7                	mov    %edx,%edi
  8008ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b0:	fc                   	cld    
  8008b1:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8008b3:	89 d0                	mov    %edx,%eax
  8008b5:	5b                   	pop    %ebx
  8008b6:	5e                   	pop    %esi
  8008b7:	5f                   	pop    %edi
  8008b8:	5d                   	pop    %ebp
  8008b9:	c3                   	ret    

008008ba <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
  8008bd:	57                   	push   %edi
  8008be:	56                   	push   %esi
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008c8:	39 c6                	cmp    %eax,%esi
  8008ca:	73 35                	jae    800901 <memmove+0x47>
  8008cc:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008cf:	39 d0                	cmp    %edx,%eax
  8008d1:	73 2e                	jae    800901 <memmove+0x47>
		s += n;
		d += n;
  8008d3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008d6:	89 d6                	mov    %edx,%esi
  8008d8:	09 fe                	or     %edi,%esi
  8008da:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008e0:	75 13                	jne    8008f5 <memmove+0x3b>
  8008e2:	f6 c1 03             	test   $0x3,%cl
  8008e5:	75 0e                	jne    8008f5 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  8008e7:	83 ef 04             	sub    $0x4,%edi
  8008ea:	8d 72 fc             	lea    -0x4(%edx),%esi
  8008ed:	c1 e9 02             	shr    $0x2,%ecx
  8008f0:	fd                   	std    
  8008f1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008f3:	eb 09                	jmp    8008fe <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8008f5:	83 ef 01             	sub    $0x1,%edi
  8008f8:	8d 72 ff             	lea    -0x1(%edx),%esi
  8008fb:	fd                   	std    
  8008fc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8008fe:	fc                   	cld    
  8008ff:	eb 1d                	jmp    80091e <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800901:	89 f2                	mov    %esi,%edx
  800903:	09 c2                	or     %eax,%edx
  800905:	f6 c2 03             	test   $0x3,%dl
  800908:	75 0f                	jne    800919 <memmove+0x5f>
  80090a:	f6 c1 03             	test   $0x3,%cl
  80090d:	75 0a                	jne    800919 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  80090f:	c1 e9 02             	shr    $0x2,%ecx
  800912:	89 c7                	mov    %eax,%edi
  800914:	fc                   	cld    
  800915:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800917:	eb 05                	jmp    80091e <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800919:	89 c7                	mov    %eax,%edi
  80091b:	fc                   	cld    
  80091c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80091e:	5e                   	pop    %esi
  80091f:	5f                   	pop    %edi
  800920:	5d                   	pop    %ebp
  800921:	c3                   	ret    

00800922 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800922:	55                   	push   %ebp
  800923:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800925:	ff 75 10             	pushl  0x10(%ebp)
  800928:	ff 75 0c             	pushl  0xc(%ebp)
  80092b:	ff 75 08             	pushl  0x8(%ebp)
  80092e:	e8 87 ff ff ff       	call   8008ba <memmove>
}
  800933:	c9                   	leave  
  800934:	c3                   	ret    

00800935 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	56                   	push   %esi
  800939:	53                   	push   %ebx
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800940:	89 c6                	mov    %eax,%esi
  800942:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800945:	eb 1a                	jmp    800961 <memcmp+0x2c>
		if (*s1 != *s2)
  800947:	0f b6 08             	movzbl (%eax),%ecx
  80094a:	0f b6 1a             	movzbl (%edx),%ebx
  80094d:	38 d9                	cmp    %bl,%cl
  80094f:	74 0a                	je     80095b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800951:	0f b6 c1             	movzbl %cl,%eax
  800954:	0f b6 db             	movzbl %bl,%ebx
  800957:	29 d8                	sub    %ebx,%eax
  800959:	eb 0f                	jmp    80096a <memcmp+0x35>
		s1++, s2++;
  80095b:	83 c0 01             	add    $0x1,%eax
  80095e:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800961:	39 f0                	cmp    %esi,%eax
  800963:	75 e2                	jne    800947 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800965:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80096a:	5b                   	pop    %ebx
  80096b:	5e                   	pop    %esi
  80096c:	5d                   	pop    %ebp
  80096d:	c3                   	ret    

0080096e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	53                   	push   %ebx
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800975:	89 c1                	mov    %eax,%ecx
  800977:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  80097a:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80097e:	eb 0a                	jmp    80098a <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800980:	0f b6 10             	movzbl (%eax),%edx
  800983:	39 da                	cmp    %ebx,%edx
  800985:	74 07                	je     80098e <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800987:	83 c0 01             	add    $0x1,%eax
  80098a:	39 c8                	cmp    %ecx,%eax
  80098c:	72 f2                	jb     800980 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  80098e:	5b                   	pop    %ebx
  80098f:	5d                   	pop    %ebp
  800990:	c3                   	ret    

00800991 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	57                   	push   %edi
  800995:	56                   	push   %esi
  800996:	53                   	push   %ebx
  800997:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80099a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80099d:	eb 03                	jmp    8009a2 <strtol+0x11>
		s++;
  80099f:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009a2:	0f b6 01             	movzbl (%ecx),%eax
  8009a5:	3c 20                	cmp    $0x20,%al
  8009a7:	74 f6                	je     80099f <strtol+0xe>
  8009a9:	3c 09                	cmp    $0x9,%al
  8009ab:	74 f2                	je     80099f <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8009ad:	3c 2b                	cmp    $0x2b,%al
  8009af:	75 0a                	jne    8009bb <strtol+0x2a>
		s++;
  8009b1:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8009b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8009b9:	eb 11                	jmp    8009cc <strtol+0x3b>
  8009bb:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8009c0:	3c 2d                	cmp    $0x2d,%al
  8009c2:	75 08                	jne    8009cc <strtol+0x3b>
		s++, neg = 1;
  8009c4:	83 c1 01             	add    $0x1,%ecx
  8009c7:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009cc:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009d2:	75 15                	jne    8009e9 <strtol+0x58>
  8009d4:	80 39 30             	cmpb   $0x30,(%ecx)
  8009d7:	75 10                	jne    8009e9 <strtol+0x58>
  8009d9:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8009dd:	75 7c                	jne    800a5b <strtol+0xca>
		s += 2, base = 16;
  8009df:	83 c1 02             	add    $0x2,%ecx
  8009e2:	bb 10 00 00 00       	mov    $0x10,%ebx
  8009e7:	eb 16                	jmp    8009ff <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  8009e9:	85 db                	test   %ebx,%ebx
  8009eb:	75 12                	jne    8009ff <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009ed:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009f2:	80 39 30             	cmpb   $0x30,(%ecx)
  8009f5:	75 08                	jne    8009ff <strtol+0x6e>
		s++, base = 8;
  8009f7:	83 c1 01             	add    $0x1,%ecx
  8009fa:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  8009ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800a04:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800a07:	0f b6 11             	movzbl (%ecx),%edx
  800a0a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a0d:	89 f3                	mov    %esi,%ebx
  800a0f:	80 fb 09             	cmp    $0x9,%bl
  800a12:	77 08                	ja     800a1c <strtol+0x8b>
			dig = *s - '0';
  800a14:	0f be d2             	movsbl %dl,%edx
  800a17:	83 ea 30             	sub    $0x30,%edx
  800a1a:	eb 22                	jmp    800a3e <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800a1c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a1f:	89 f3                	mov    %esi,%ebx
  800a21:	80 fb 19             	cmp    $0x19,%bl
  800a24:	77 08                	ja     800a2e <strtol+0x9d>
			dig = *s - 'a' + 10;
  800a26:	0f be d2             	movsbl %dl,%edx
  800a29:	83 ea 57             	sub    $0x57,%edx
  800a2c:	eb 10                	jmp    800a3e <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800a2e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a31:	89 f3                	mov    %esi,%ebx
  800a33:	80 fb 19             	cmp    $0x19,%bl
  800a36:	77 16                	ja     800a4e <strtol+0xbd>
			dig = *s - 'A' + 10;
  800a38:	0f be d2             	movsbl %dl,%edx
  800a3b:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800a3e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a41:	7d 0b                	jge    800a4e <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800a43:	83 c1 01             	add    $0x1,%ecx
  800a46:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a4a:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800a4c:	eb b9                	jmp    800a07 <strtol+0x76>

	if (endptr)
  800a4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a52:	74 0d                	je     800a61 <strtol+0xd0>
		*endptr = (char *) s;
  800a54:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a57:	89 0e                	mov    %ecx,(%esi)
  800a59:	eb 06                	jmp    800a61 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a5b:	85 db                	test   %ebx,%ebx
  800a5d:	74 98                	je     8009f7 <strtol+0x66>
  800a5f:	eb 9e                	jmp    8009ff <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800a61:	89 c2                	mov    %eax,%edx
  800a63:	f7 da                	neg    %edx
  800a65:	85 ff                	test   %edi,%edi
  800a67:	0f 45 c2             	cmovne %edx,%eax
}
  800a6a:	5b                   	pop    %ebx
  800a6b:	5e                   	pop    %esi
  800a6c:	5f                   	pop    %edi
  800a6d:	5d                   	pop    %ebp
  800a6e:	c3                   	ret    

00800a6f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	57                   	push   %edi
  800a73:	56                   	push   %esi
  800a74:	53                   	push   %ebx
  800a75:	83 ec 1c             	sub    $0x1c,%esp
  800a78:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a7b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a7e:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800a80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a83:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a86:	8b 7d 10             	mov    0x10(%ebp),%edi
  800a89:	8b 75 14             	mov    0x14(%ebp),%esi
  800a8c:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800a8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a92:	74 1d                	je     800ab1 <syscall+0x42>
  800a94:	85 c0                	test   %eax,%eax
  800a96:	7e 19                	jle    800ab1 <syscall+0x42>
  800a98:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800a9b:	83 ec 0c             	sub    $0xc,%esp
  800a9e:	50                   	push   %eax
  800a9f:	52                   	push   %edx
  800aa0:	68 3f 26 80 00       	push   $0x80263f
  800aa5:	6a 23                	push   $0x23
  800aa7:	68 5c 26 80 00       	push   $0x80265c
  800aac:	e8 98 14 00 00       	call   801f49 <_panic>

	return ret;
}
  800ab1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ab4:	5b                   	pop    %ebx
  800ab5:	5e                   	pop    %esi
  800ab6:	5f                   	pop    %edi
  800ab7:	5d                   	pop    %ebp
  800ab8:	c3                   	ret    

00800ab9 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800abf:	6a 00                	push   $0x0
  800ac1:	6a 00                	push   $0x0
  800ac3:	6a 00                	push   $0x0
  800ac5:	ff 75 0c             	pushl  0xc(%ebp)
  800ac8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800acb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad5:	e8 95 ff ff ff       	call   800a6f <syscall>
}
  800ada:	83 c4 10             	add    $0x10,%esp
  800add:	c9                   	leave  
  800ade:	c3                   	ret    

00800adf <sys_cgetc>:

int
sys_cgetc(void)
{
  800adf:	55                   	push   %ebp
  800ae0:	89 e5                	mov    %esp,%ebp
  800ae2:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800ae5:	6a 00                	push   $0x0
  800ae7:	6a 00                	push   $0x0
  800ae9:	6a 00                	push   $0x0
  800aeb:	6a 00                	push   $0x0
  800aed:	b9 00 00 00 00       	mov    $0x0,%ecx
  800af2:	ba 00 00 00 00       	mov    $0x0,%edx
  800af7:	b8 01 00 00 00       	mov    $0x1,%eax
  800afc:	e8 6e ff ff ff       	call   800a6f <syscall>
}
  800b01:	c9                   	leave  
  800b02:	c3                   	ret    

00800b03 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
  800b06:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800b09:	6a 00                	push   $0x0
  800b0b:	6a 00                	push   $0x0
  800b0d:	6a 00                	push   $0x0
  800b0f:	6a 00                	push   $0x0
  800b11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b14:	ba 01 00 00 00       	mov    $0x1,%edx
  800b19:	b8 03 00 00 00       	mov    $0x3,%eax
  800b1e:	e8 4c ff ff ff       	call   800a6f <syscall>
}
  800b23:	c9                   	leave  
  800b24:	c3                   	ret    

00800b25 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b2b:	6a 00                	push   $0x0
  800b2d:	6a 00                	push   $0x0
  800b2f:	6a 00                	push   $0x0
  800b31:	6a 00                	push   $0x0
  800b33:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b38:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3d:	b8 02 00 00 00       	mov    $0x2,%eax
  800b42:	e8 28 ff ff ff       	call   800a6f <syscall>
}
  800b47:	c9                   	leave  
  800b48:	c3                   	ret    

00800b49 <sys_yield>:

void
sys_yield(void)
{
  800b49:	55                   	push   %ebp
  800b4a:	89 e5                	mov    %esp,%ebp
  800b4c:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b4f:	6a 00                	push   $0x0
  800b51:	6a 00                	push   $0x0
  800b53:	6a 00                	push   $0x0
  800b55:	6a 00                	push   $0x0
  800b57:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b5c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b61:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b66:	e8 04 ff ff ff       	call   800a6f <syscall>
}
  800b6b:	83 c4 10             	add    $0x10,%esp
  800b6e:	c9                   	leave  
  800b6f:	c3                   	ret    

00800b70 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800b76:	6a 00                	push   $0x0
  800b78:	6a 00                	push   $0x0
  800b7a:	ff 75 10             	pushl  0x10(%ebp)
  800b7d:	ff 75 0c             	pushl  0xc(%ebp)
  800b80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b83:	ba 01 00 00 00       	mov    $0x1,%edx
  800b88:	b8 04 00 00 00       	mov    $0x4,%eax
  800b8d:	e8 dd fe ff ff       	call   800a6f <syscall>
}
  800b92:	c9                   	leave  
  800b93:	c3                   	ret    

00800b94 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800b9a:	ff 75 18             	pushl  0x18(%ebp)
  800b9d:	ff 75 14             	pushl  0x14(%ebp)
  800ba0:	ff 75 10             	pushl  0x10(%ebp)
  800ba3:	ff 75 0c             	pushl  0xc(%ebp)
  800ba6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba9:	ba 01 00 00 00       	mov    $0x1,%edx
  800bae:	b8 05 00 00 00       	mov    $0x5,%eax
  800bb3:	e8 b7 fe ff ff       	call   800a6f <syscall>
}
  800bb8:	c9                   	leave  
  800bb9:	c3                   	ret    

00800bba <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800bc0:	6a 00                	push   $0x0
  800bc2:	6a 00                	push   $0x0
  800bc4:	6a 00                	push   $0x0
  800bc6:	ff 75 0c             	pushl  0xc(%ebp)
  800bc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bcc:	ba 01 00 00 00       	mov    $0x1,%edx
  800bd1:	b8 06 00 00 00       	mov    $0x6,%eax
  800bd6:	e8 94 fe ff ff       	call   800a6f <syscall>
}
  800bdb:	c9                   	leave  
  800bdc:	c3                   	ret    

00800bdd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800be3:	6a 00                	push   $0x0
  800be5:	6a 00                	push   $0x0
  800be7:	6a 00                	push   $0x0
  800be9:	ff 75 0c             	pushl  0xc(%ebp)
  800bec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bef:	ba 01 00 00 00       	mov    $0x1,%edx
  800bf4:	b8 08 00 00 00       	mov    $0x8,%eax
  800bf9:	e8 71 fe ff ff       	call   800a6f <syscall>
}
  800bfe:	c9                   	leave  
  800bff:	c3                   	ret    

00800c00 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800c06:	6a 00                	push   $0x0
  800c08:	6a 00                	push   $0x0
  800c0a:	6a 00                	push   $0x0
  800c0c:	ff 75 0c             	pushl  0xc(%ebp)
  800c0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c12:	ba 01 00 00 00       	mov    $0x1,%edx
  800c17:	b8 09 00 00 00       	mov    $0x9,%eax
  800c1c:	e8 4e fe ff ff       	call   800a6f <syscall>
}
  800c21:	c9                   	leave  
  800c22:	c3                   	ret    

00800c23 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800c29:	6a 00                	push   $0x0
  800c2b:	6a 00                	push   $0x0
  800c2d:	6a 00                	push   $0x0
  800c2f:	ff 75 0c             	pushl  0xc(%ebp)
  800c32:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c35:	ba 01 00 00 00       	mov    $0x1,%edx
  800c3a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c3f:	e8 2b fe ff ff       	call   800a6f <syscall>
}
  800c44:	c9                   	leave  
  800c45:	c3                   	ret    

00800c46 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800c4c:	6a 00                	push   $0x0
  800c4e:	ff 75 14             	pushl  0x14(%ebp)
  800c51:	ff 75 10             	pushl  0x10(%ebp)
  800c54:	ff 75 0c             	pushl  0xc(%ebp)
  800c57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c64:	e8 06 fe ff ff       	call   800a6f <syscall>
}
  800c69:	c9                   	leave  
  800c6a:	c3                   	ret    

00800c6b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800c71:	6a 00                	push   $0x0
  800c73:	6a 00                	push   $0x0
  800c75:	6a 00                	push   $0x0
  800c77:	6a 00                	push   $0x0
  800c79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c7c:	ba 01 00 00 00       	mov    $0x1,%edx
  800c81:	b8 0d 00 00 00       	mov    $0xd,%eax
  800c86:	e8 e4 fd ff ff       	call   800a6f <syscall>
}
  800c8b:	c9                   	leave  
  800c8c:	c3                   	ret    

00800c8d <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	53                   	push   %ebx
  800c91:	83 ec 04             	sub    $0x4,%esp

	int perm_w = PTE_COW|PTE_U|PTE_P;
	int perm = PTE_U|PTE_P;

	// LAB 4: Your code here.
	void *addr = (void*) (pn*PGSIZE);
  800c94:	89 d3                	mov    %edx,%ebx
  800c96:	c1 e3 0c             	shl    $0xc,%ebx

	//Si una página tiene el bit PTE_SHARE, se comparte con el hijo con los mismos permisos.
  	if (uvpt[pn] & PTE_SHARE) {
  800c99:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800ca0:	f6 c5 04             	test   $0x4,%ch
  800ca3:	74 3a                	je     800cdf <duppage+0x52>
    	if (sys_page_map(0, addr, envid,addr, uvpt[pn] & PTE_SYSCALL) < 0) {
  800ca5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800cac:	83 ec 0c             	sub    $0xc,%esp
  800caf:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800cb5:	52                   	push   %edx
  800cb6:	53                   	push   %ebx
  800cb7:	50                   	push   %eax
  800cb8:	53                   	push   %ebx
  800cb9:	6a 00                	push   $0x0
  800cbb:	e8 d4 fe ff ff       	call   800b94 <sys_page_map>
  800cc0:	83 c4 20             	add    $0x20,%esp
  800cc3:	85 c0                	test   %eax,%eax
  800cc5:	0f 89 99 00 00 00    	jns    800d64 <duppage+0xd7>
 	     	panic("Error en sys_page_map");
  800ccb:	83 ec 04             	sub    $0x4,%esp
  800cce:	68 6a 26 80 00       	push   $0x80266a
  800cd3:	6a 50                	push   $0x50
  800cd5:	68 80 26 80 00       	push   $0x802680
  800cda:	e8 6a 12 00 00       	call   801f49 <_panic>
    	} 
    	return 0;
	}

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  800cdf:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800ce6:	f6 c1 02             	test   $0x2,%cl
  800ce9:	75 0c                	jne    800cf7 <duppage+0x6a>
  800ceb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800cf2:	f6 c6 08             	test   $0x8,%dh
  800cf5:	74 5b                	je     800d52 <duppage+0xc5>
		if (sys_page_map(0, addr, envid, addr, perm_w) < 0){
  800cf7:	83 ec 0c             	sub    $0xc,%esp
  800cfa:	68 05 08 00 00       	push   $0x805
  800cff:	53                   	push   %ebx
  800d00:	50                   	push   %eax
  800d01:	53                   	push   %ebx
  800d02:	6a 00                	push   $0x0
  800d04:	e8 8b fe ff ff       	call   800b94 <sys_page_map>
  800d09:	83 c4 20             	add    $0x20,%esp
  800d0c:	85 c0                	test   %eax,%eax
  800d0e:	79 14                	jns    800d24 <duppage+0x97>
			panic("Error mapeando pagina Padre");
  800d10:	83 ec 04             	sub    $0x4,%esp
  800d13:	68 8b 26 80 00       	push   $0x80268b
  800d18:	6a 57                	push   $0x57
  800d1a:	68 80 26 80 00       	push   $0x802680
  800d1f:	e8 25 12 00 00       	call   801f49 <_panic>
		}
		if (sys_page_map(0, addr, 0, addr, perm_w) < 0){
  800d24:	83 ec 0c             	sub    $0xc,%esp
  800d27:	68 05 08 00 00       	push   $0x805
  800d2c:	53                   	push   %ebx
  800d2d:	6a 00                	push   $0x0
  800d2f:	53                   	push   %ebx
  800d30:	6a 00                	push   $0x0
  800d32:	e8 5d fe ff ff       	call   800b94 <sys_page_map>
  800d37:	83 c4 20             	add    $0x20,%esp
  800d3a:	85 c0                	test   %eax,%eax
  800d3c:	79 26                	jns    800d64 <duppage+0xd7>
			panic("Error mapeando pagina Hijo");
  800d3e:	83 ec 04             	sub    $0x4,%esp
  800d41:	68 a7 26 80 00       	push   $0x8026a7
  800d46:	6a 5a                	push   $0x5a
  800d48:	68 80 26 80 00       	push   $0x802680
  800d4d:	e8 f7 11 00 00       	call   801f49 <_panic>
		}
	} else sys_page_map(0, addr, envid, addr, perm);
  800d52:	83 ec 0c             	sub    $0xc,%esp
  800d55:	6a 05                	push   $0x5
  800d57:	53                   	push   %ebx
  800d58:	50                   	push   %eax
  800d59:	53                   	push   %ebx
  800d5a:	6a 00                	push   $0x0
  800d5c:	e8 33 fe ff ff       	call   800b94 <sys_page_map>
  800d61:	83 c4 20             	add    $0x20,%esp
	
	return 0;
}
  800d64:	b8 00 00 00 00       	mov    $0x0,%eax
  800d69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d6c:	c9                   	leave  
  800d6d:	c3                   	ret    

00800d6e <dup_or_share>:
//FORK V0

static void
dup_or_share(envid_t dstenv, void *va, int perm){
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	57                   	push   %edi
  800d72:	56                   	push   %esi
  800d73:	53                   	push   %ebx
  800d74:	83 ec 0c             	sub    $0xc,%esp
  800d77:	89 c7                	mov    %eax,%edi
  800d79:	89 d6                	mov    %edx,%esi
  800d7b:	89 cb                	mov    %ecx,%ebx
	int result;
	// Si no es de escritura, comparto la pagina
	if((perm &PTE_W) != PTE_W){
  800d7d:	f6 c1 02             	test   $0x2,%cl
  800d80:	75 2d                	jne    800daf <dup_or_share+0x41>
		if((result = sys_page_map(0, va, dstenv, va, perm))<0){
  800d82:	83 ec 0c             	sub    $0xc,%esp
  800d85:	51                   	push   %ecx
  800d86:	52                   	push   %edx
  800d87:	50                   	push   %eax
  800d88:	52                   	push   %edx
  800d89:	6a 00                	push   $0x0
  800d8b:	e8 04 fe ff ff       	call   800b94 <sys_page_map>
  800d90:	83 c4 20             	add    $0x20,%esp
  800d93:	85 c0                	test   %eax,%eax
  800d95:	0f 89 a4 00 00 00    	jns    800e3f <dup_or_share+0xd1>
			panic("Error compartiendo la pagina");
  800d9b:	83 ec 04             	sub    $0x4,%esp
  800d9e:	68 c2 26 80 00       	push   $0x8026c2
  800da3:	6a 68                	push   $0x68
  800da5:	68 80 26 80 00       	push   $0x802680
  800daa:	e8 9a 11 00 00       	call   801f49 <_panic>
		}
	// Si es de escritura comportamiento de duppage, en dumbfork
	}else{
		if ((result = sys_page_alloc(dstenv, va, perm)) < 0){
  800daf:	83 ec 04             	sub    $0x4,%esp
  800db2:	51                   	push   %ecx
  800db3:	52                   	push   %edx
  800db4:	50                   	push   %eax
  800db5:	e8 b6 fd ff ff       	call   800b70 <sys_page_alloc>
  800dba:	83 c4 10             	add    $0x10,%esp
  800dbd:	85 c0                	test   %eax,%eax
  800dbf:	79 14                	jns    800dd5 <dup_or_share+0x67>
			panic("Error copiando la pagina");
  800dc1:	83 ec 04             	sub    $0x4,%esp
  800dc4:	68 df 26 80 00       	push   $0x8026df
  800dc9:	6a 6d                	push   $0x6d
  800dcb:	68 80 26 80 00       	push   $0x802680
  800dd0:	e8 74 11 00 00       	call   801f49 <_panic>
		}
		if ((result = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0){
  800dd5:	83 ec 0c             	sub    $0xc,%esp
  800dd8:	53                   	push   %ebx
  800dd9:	68 00 00 40 00       	push   $0x400000
  800dde:	6a 00                	push   $0x0
  800de0:	56                   	push   %esi
  800de1:	57                   	push   %edi
  800de2:	e8 ad fd ff ff       	call   800b94 <sys_page_map>
  800de7:	83 c4 20             	add    $0x20,%esp
  800dea:	85 c0                	test   %eax,%eax
  800dec:	79 14                	jns    800e02 <dup_or_share+0x94>
			panic("Error copiando la pagina");
  800dee:	83 ec 04             	sub    $0x4,%esp
  800df1:	68 df 26 80 00       	push   $0x8026df
  800df6:	6a 70                	push   $0x70
  800df8:	68 80 26 80 00       	push   $0x802680
  800dfd:	e8 47 11 00 00       	call   801f49 <_panic>
		}
		memmove(UTEMP, va, PGSIZE);
  800e02:	83 ec 04             	sub    $0x4,%esp
  800e05:	68 00 10 00 00       	push   $0x1000
  800e0a:	56                   	push   %esi
  800e0b:	68 00 00 40 00       	push   $0x400000
  800e10:	e8 a5 fa ff ff       	call   8008ba <memmove>
		if ((result = sys_page_unmap(0, UTEMP)) < 0){
  800e15:	83 c4 08             	add    $0x8,%esp
  800e18:	68 00 00 40 00       	push   $0x400000
  800e1d:	6a 00                	push   $0x0
  800e1f:	e8 96 fd ff ff       	call   800bba <sys_page_unmap>
  800e24:	83 c4 10             	add    $0x10,%esp
  800e27:	85 c0                	test   %eax,%eax
  800e29:	79 14                	jns    800e3f <dup_or_share+0xd1>
			panic("Error copiando la pagina");
  800e2b:	83 ec 04             	sub    $0x4,%esp
  800e2e:	68 df 26 80 00       	push   $0x8026df
  800e33:	6a 74                	push   $0x74
  800e35:	68 80 26 80 00       	push   $0x802680
  800e3a:	e8 0a 11 00 00       	call   801f49 <_panic>
		}
	}	
}
  800e3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e42:	5b                   	pop    %ebx
  800e43:	5e                   	pop    %esi
  800e44:	5f                   	pop    %edi
  800e45:	5d                   	pop    %ebp
  800e46:	c3                   	ret    

00800e47 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
  800e4a:	53                   	push   %ebx
  800e4b:	83 ec 04             	sub    $0x4,%esp
  800e4e:	8b 55 08             	mov    0x8(%ebp),%edx
	void *va = (void *) utf->utf_fault_va;
  800e51:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800e53:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  800e57:	74 2e                	je     800e87 <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
  800e59:	89 c2                	mov    %eax,%edx
  800e5b:	c1 ea 16             	shr    $0x16,%edx
  800e5e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800e65:	f6 c2 01             	test   $0x1,%dl
  800e68:	74 1d                	je     800e87 <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
  800e6a:	89 c2                	mov    %eax,%edx
  800e6c:	c1 ea 0c             	shr    $0xc,%edx
  800e6f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
		(uvpd[PDX(va)] & PTE_P) && 
  800e76:	f6 c1 01             	test   $0x1,%cl
  800e79:	74 0c                	je     800e87 <pgfault+0x40>
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
  800e7b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800e82:	f6 c6 08             	test   $0x8,%dh
  800e85:	75 14                	jne    800e9b <pgfault+0x54>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
		panic("No es copy-on-write");
  800e87:	83 ec 04             	sub    $0x4,%esp
  800e8a:	68 f8 26 80 00       	push   $0x8026f8
  800e8f:	6a 21                	push   $0x21
  800e91:	68 80 26 80 00       	push   $0x802680
  800e96:	e8 ae 10 00 00       	call   801f49 <_panic>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	va = ROUNDDOWN(va, PGSIZE);
  800e9b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ea0:	89 c3                	mov    %eax,%ebx
	if (sys_page_alloc(0, PFTEMP, perm) < 0){
  800ea2:	83 ec 04             	sub    $0x4,%esp
  800ea5:	6a 07                	push   $0x7
  800ea7:	68 00 f0 7f 00       	push   $0x7ff000
  800eac:	6a 00                	push   $0x0
  800eae:	e8 bd fc ff ff       	call   800b70 <sys_page_alloc>
  800eb3:	83 c4 10             	add    $0x10,%esp
  800eb6:	85 c0                	test   %eax,%eax
  800eb8:	79 14                	jns    800ece <pgfault+0x87>
		panic("Error sys_page_alloc");
  800eba:	83 ec 04             	sub    $0x4,%esp
  800ebd:	68 0c 27 80 00       	push   $0x80270c
  800ec2:	6a 2a                	push   $0x2a
  800ec4:	68 80 26 80 00       	push   $0x802680
  800ec9:	e8 7b 10 00 00       	call   801f49 <_panic>
	}
	memcpy(PFTEMP, va, PGSIZE);
  800ece:	83 ec 04             	sub    $0x4,%esp
  800ed1:	68 00 10 00 00       	push   $0x1000
  800ed6:	53                   	push   %ebx
  800ed7:	68 00 f0 7f 00       	push   $0x7ff000
  800edc:	e8 41 fa ff ff       	call   800922 <memcpy>
	if (sys_page_map(0, PFTEMP, 0, va, perm) < 0){
  800ee1:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800ee8:	53                   	push   %ebx
  800ee9:	6a 00                	push   $0x0
  800eeb:	68 00 f0 7f 00       	push   $0x7ff000
  800ef0:	6a 00                	push   $0x0
  800ef2:	e8 9d fc ff ff       	call   800b94 <sys_page_map>
  800ef7:	83 c4 20             	add    $0x20,%esp
  800efa:	85 c0                	test   %eax,%eax
  800efc:	79 14                	jns    800f12 <pgfault+0xcb>
		panic("Error sys_page_map");
  800efe:	83 ec 04             	sub    $0x4,%esp
  800f01:	68 21 27 80 00       	push   $0x802721
  800f06:	6a 2e                	push   $0x2e
  800f08:	68 80 26 80 00       	push   $0x802680
  800f0d:	e8 37 10 00 00       	call   801f49 <_panic>
	}
	if (sys_page_unmap(0, PFTEMP) < 0){
  800f12:	83 ec 08             	sub    $0x8,%esp
  800f15:	68 00 f0 7f 00       	push   $0x7ff000
  800f1a:	6a 00                	push   $0x0
  800f1c:	e8 99 fc ff ff       	call   800bba <sys_page_unmap>
  800f21:	83 c4 10             	add    $0x10,%esp
  800f24:	85 c0                	test   %eax,%eax
  800f26:	79 14                	jns    800f3c <pgfault+0xf5>
		panic("Error sys_page_unmap");
  800f28:	83 ec 04             	sub    $0x4,%esp
  800f2b:	68 34 27 80 00       	push   $0x802734
  800f30:	6a 31                	push   $0x31
  800f32:	68 80 26 80 00       	push   $0x802680
  800f37:	e8 0d 10 00 00       	call   801f49 <_panic>
	}
	return;

}
  800f3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f3f:	c9                   	leave  
  800f40:	c3                   	ret    

00800f41 <fork_v0>:
		}
	}	
}

envid_t
fork_v0(void){
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	57                   	push   %edi
  800f45:	56                   	push   %esi
  800f46:	53                   	push   %ebx
  800f47:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f4a:	b8 07 00 00 00       	mov    $0x7,%eax
  800f4f:	cd 30                	int    $0x30
  800f51:	89 c6                	mov    %eax,%esi
	envid_t envid;
	uint8_t *va;
	int result;	

	envid = sys_exofork();
	if (envid < 0)
  800f53:	85 c0                	test   %eax,%eax
  800f55:	79 15                	jns    800f6c <fork_v0+0x2b>
		panic("sys_exofork: %e", envid);
  800f57:	50                   	push   %eax
  800f58:	68 49 27 80 00       	push   $0x802749
  800f5d:	68 81 00 00 00       	push   $0x81
  800f62:	68 80 26 80 00       	push   $0x802680
  800f67:	e8 dd 0f 00 00       	call   801f49 <_panic>
  800f6c:	89 c7                	mov    %eax,%edi
  800f6e:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {		
  800f73:	85 c0                	test   %eax,%eax
  800f75:	75 1e                	jne    800f95 <fork_v0+0x54>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f77:	e8 a9 fb ff ff       	call   800b25 <sys_getenvid>
  800f7c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f81:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f84:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f89:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800f8e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f93:	eb 7a                	jmp    80100f <fork_v0+0xce>
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  800f95:	89 d8                	mov    %ebx,%eax
  800f97:	c1 e8 16             	shr    $0x16,%eax
  800f9a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fa1:	a8 01                	test   $0x1,%al
  800fa3:	74 33                	je     800fd8 <fork_v0+0x97>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  800fa5:	89 d8                	mov    %ebx,%eax
  800fa7:	c1 e8 0c             	shr    $0xc,%eax
  800faa:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fb1:	f6 c2 01             	test   $0x1,%dl
  800fb4:	74 22                	je     800fd8 <fork_v0+0x97>
  800fb6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fbd:	f6 c2 04             	test   $0x4,%dl
  800fc0:	74 16                	je     800fd8 <fork_v0+0x97>
				pte_t pte =uvpt[PGNUM(va)];
  800fc2:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
  800fc9:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  800fcf:	89 da                	mov    %ebx,%edx
  800fd1:	89 f8                	mov    %edi,%eax
  800fd3:	e8 96 fd ff ff       	call   800d6e <dup_or_share>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
  800fd8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800fde:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  800fe4:	75 af                	jne    800f95 <fork_v0+0x54>
				pte_t pte =uvpt[PGNUM(va)];
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
			}
		}
	}	
	if ((result = sys_env_set_status(envid, ENV_RUNNABLE)) < 0){
  800fe6:	83 ec 08             	sub    $0x8,%esp
  800fe9:	6a 02                	push   $0x2
  800feb:	56                   	push   %esi
  800fec:	e8 ec fb ff ff       	call   800bdd <sys_env_set_status>
  800ff1:	83 c4 10             	add    $0x10,%esp
  800ff4:	85 c0                	test   %eax,%eax
  800ff6:	79 15                	jns    80100d <fork_v0+0xcc>

		panic("sys_env_set_status: %e", result);
  800ff8:	50                   	push   %eax
  800ff9:	68 59 27 80 00       	push   $0x802759
  800ffe:	68 90 00 00 00       	push   $0x90
  801003:	68 80 26 80 00       	push   $0x802680
  801008:	e8 3c 0f 00 00       	call   801f49 <_panic>
	}
	return envid;
  80100d:	89 f0                	mov    %esi,%eax
}
  80100f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801012:	5b                   	pop    %ebx
  801013:	5e                   	pop    %esi
  801014:	5f                   	pop    %edi
  801015:	5d                   	pop    %ebp
  801016:	c3                   	ret    

00801017 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	57                   	push   %edi
  80101b:	56                   	push   %esi
  80101c:	53                   	push   %ebx
  80101d:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801020:	68 47 0e 80 00       	push   $0x800e47
  801025:	e8 65 0f 00 00       	call   801f8f <set_pgfault_handler>
  80102a:	b8 07 00 00 00       	mov    $0x7,%eax
  80102f:	cd 30                	int    $0x30
  801031:	89 c6                	mov    %eax,%esi

	envid_t envid;
	uint32_t va;
	envid = sys_exofork();
	if (envid < 0){
  801033:	83 c4 10             	add    $0x10,%esp
  801036:	85 c0                	test   %eax,%eax
  801038:	79 15                	jns    80104f <fork+0x38>
		panic("sys_exofork: %e", envid);
  80103a:	50                   	push   %eax
  80103b:	68 49 27 80 00       	push   $0x802749
  801040:	68 b1 00 00 00       	push   $0xb1
  801045:	68 80 26 80 00       	push   $0x802680
  80104a:	e8 fa 0e 00 00       	call   801f49 <_panic>
  80104f:	89 c7                	mov    %eax,%edi
  801051:	bb 00 00 00 00       	mov    $0x0,%ebx
	}
	if (envid == 0) {		
  801056:	85 c0                	test   %eax,%eax
  801058:	75 21                	jne    80107b <fork+0x64>
		thisenv = &envs[ENVX(sys_getenvid())];
  80105a:	e8 c6 fa ff ff       	call   800b25 <sys_getenvid>
  80105f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801064:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801067:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80106c:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801071:	b8 00 00 00 00       	mov    $0x0,%eax
  801076:	e9 a7 00 00 00       	jmp    801122 <fork+0x10b>
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  80107b:	89 d8                	mov    %ebx,%eax
  80107d:	c1 e8 16             	shr    $0x16,%eax
  801080:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801087:	a8 01                	test   $0x1,%al
  801089:	74 22                	je     8010ad <fork+0x96>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  80108b:	89 da                	mov    %ebx,%edx
  80108d:	c1 ea 0c             	shr    $0xc,%edx
  801090:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801097:	a8 01                	test   $0x1,%al
  801099:	74 12                	je     8010ad <fork+0x96>
  80109b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8010a2:	a8 04                	test   $0x4,%al
  8010a4:	74 07                	je     8010ad <fork+0x96>
				duppage(envid, PGNUM(va));			
  8010a6:	89 f8                	mov    %edi,%eax
  8010a8:	e8 e0 fb ff ff       	call   800c8d <duppage>
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
  8010ad:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010b3:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8010b9:	75 c0                	jne    80107b <fork+0x64>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
				duppage(envid, PGNUM(va));			
			}
		}
	}
	if (sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P) < 0){
  8010bb:	83 ec 04             	sub    $0x4,%esp
  8010be:	6a 07                	push   $0x7
  8010c0:	68 00 f0 bf ee       	push   $0xeebff000
  8010c5:	56                   	push   %esi
  8010c6:	e8 a5 fa ff ff       	call   800b70 <sys_page_alloc>
  8010cb:	83 c4 10             	add    $0x10,%esp
  8010ce:	85 c0                	test   %eax,%eax
  8010d0:	79 17                	jns    8010e9 <fork+0xd2>
		panic("Se escribio en la pagina de excepciones");
  8010d2:	83 ec 04             	sub    $0x4,%esp
  8010d5:	68 88 27 80 00       	push   $0x802788
  8010da:	68 c0 00 00 00       	push   $0xc0
  8010df:	68 80 26 80 00       	push   $0x802680
  8010e4:	e8 60 0e 00 00       	call   801f49 <_panic>
	}	
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8010e9:	83 ec 08             	sub    $0x8,%esp
  8010ec:	68 fe 1f 80 00       	push   $0x801ffe
  8010f1:	56                   	push   %esi
  8010f2:	e8 2c fb ff ff       	call   800c23 <sys_env_set_pgfault_upcall>

	if (sys_env_set_status(envid, ENV_RUNNABLE) < 0)
  8010f7:	83 c4 08             	add    $0x8,%esp
  8010fa:	6a 02                	push   $0x2
  8010fc:	56                   	push   %esi
  8010fd:	e8 db fa ff ff       	call   800bdd <sys_env_set_status>
  801102:	83 c4 10             	add    $0x10,%esp
  801105:	85 c0                	test   %eax,%eax
  801107:	79 17                	jns    801120 <fork+0x109>
		panic("Status incorrecto de enviroment");
  801109:	83 ec 04             	sub    $0x4,%esp
  80110c:	68 b0 27 80 00       	push   $0x8027b0
  801111:	68 c5 00 00 00       	push   $0xc5
  801116:	68 80 26 80 00       	push   $0x802680
  80111b:	e8 29 0e 00 00       	call   801f49 <_panic>

	return envid;
  801120:	89 f0                	mov    %esi,%eax
	
}
  801122:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801125:	5b                   	pop    %ebx
  801126:	5e                   	pop    %esi
  801127:	5f                   	pop    %edi
  801128:	5d                   	pop    %ebp
  801129:	c3                   	ret    

0080112a <sfork>:


// Challenge!
int
sfork(void)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801130:	68 70 27 80 00       	push   $0x802770
  801135:	68 d1 00 00 00       	push   $0xd1
  80113a:	68 80 26 80 00       	push   $0x802680
  80113f:	e8 05 0e 00 00       	call   801f49 <_panic>

00801144 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801144:	55                   	push   %ebp
  801145:	89 e5                	mov    %esp,%ebp
  801147:	56                   	push   %esi
  801148:	53                   	push   %ebx
  801149:	8b 75 08             	mov    0x8(%ebp),%esi
  80114c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801152:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801154:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801159:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  80115c:	83 ec 0c             	sub    $0xc,%esp
  80115f:	50                   	push   %eax
  801160:	e8 06 fb ff ff       	call   800c6b <sys_ipc_recv>
	if (from_env_store)
  801165:	83 c4 10             	add    $0x10,%esp
  801168:	85 f6                	test   %esi,%esi
  80116a:	74 0b                	je     801177 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  80116c:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801172:	8b 52 74             	mov    0x74(%edx),%edx
  801175:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801177:	85 db                	test   %ebx,%ebx
  801179:	74 0b                	je     801186 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  80117b:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801181:	8b 52 78             	mov    0x78(%edx),%edx
  801184:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  801186:	85 c0                	test   %eax,%eax
  801188:	79 16                	jns    8011a0 <ipc_recv+0x5c>
		if (from_env_store)
  80118a:	85 f6                	test   %esi,%esi
  80118c:	74 06                	je     801194 <ipc_recv+0x50>
			*from_env_store = 0;
  80118e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  801194:	85 db                	test   %ebx,%ebx
  801196:	74 10                	je     8011a8 <ipc_recv+0x64>
			*perm_store = 0;
  801198:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80119e:	eb 08                	jmp    8011a8 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  8011a0:	a1 04 40 80 00       	mov    0x804004,%eax
  8011a5:	8b 40 70             	mov    0x70(%eax),%eax
}
  8011a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011ab:	5b                   	pop    %ebx
  8011ac:	5e                   	pop    %esi
  8011ad:	5d                   	pop    %ebp
  8011ae:	c3                   	ret    

008011af <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8011af:	55                   	push   %ebp
  8011b0:	89 e5                	mov    %esp,%ebp
  8011b2:	57                   	push   %edi
  8011b3:	56                   	push   %esi
  8011b4:	53                   	push   %ebx
  8011b5:	83 ec 0c             	sub    $0xc,%esp
  8011b8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  8011c1:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  8011c3:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8011c8:	0f 44 d8             	cmove  %eax,%ebx
  8011cb:	eb 1c                	jmp    8011e9 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  8011cd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8011d0:	74 12                	je     8011e4 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  8011d2:	50                   	push   %eax
  8011d3:	68 d0 27 80 00       	push   $0x8027d0
  8011d8:	6a 42                	push   $0x42
  8011da:	68 e6 27 80 00       	push   $0x8027e6
  8011df:	e8 65 0d 00 00       	call   801f49 <_panic>
		sys_yield();
  8011e4:	e8 60 f9 ff ff       	call   800b49 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  8011e9:	ff 75 14             	pushl  0x14(%ebp)
  8011ec:	53                   	push   %ebx
  8011ed:	56                   	push   %esi
  8011ee:	57                   	push   %edi
  8011ef:	e8 52 fa ff ff       	call   800c46 <sys_ipc_try_send>
  8011f4:	83 c4 10             	add    $0x10,%esp
  8011f7:	85 c0                	test   %eax,%eax
  8011f9:	75 d2                	jne    8011cd <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  8011fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011fe:	5b                   	pop    %ebx
  8011ff:	5e                   	pop    %esi
  801200:	5f                   	pop    %edi
  801201:	5d                   	pop    %ebp
  801202:	c3                   	ret    

00801203 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
  801206:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801209:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80120e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801211:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801217:	8b 52 50             	mov    0x50(%edx),%edx
  80121a:	39 ca                	cmp    %ecx,%edx
  80121c:	75 0d                	jne    80122b <ipc_find_env+0x28>
			return envs[i].env_id;
  80121e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801221:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801226:	8b 40 48             	mov    0x48(%eax),%eax
  801229:	eb 0f                	jmp    80123a <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80122b:	83 c0 01             	add    $0x1,%eax
  80122e:	3d 00 04 00 00       	cmp    $0x400,%eax
  801233:	75 d9                	jne    80120e <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801235:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80123a:	5d                   	pop    %ebp
  80123b:	c3                   	ret    

0080123c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	05 00 00 00 30       	add    $0x30000000,%eax
  801247:	c1 e8 0c             	shr    $0xc,%eax
}
  80124a:	5d                   	pop    %ebp
  80124b:	c3                   	ret    

0080124c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  80124f:	ff 75 08             	pushl  0x8(%ebp)
  801252:	e8 e5 ff ff ff       	call   80123c <fd2num>
  801257:	83 c4 04             	add    $0x4,%esp
  80125a:	c1 e0 0c             	shl    $0xc,%eax
  80125d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801262:	c9                   	leave  
  801263:	c3                   	ret    

00801264 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80126a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80126f:	89 c2                	mov    %eax,%edx
  801271:	c1 ea 16             	shr    $0x16,%edx
  801274:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80127b:	f6 c2 01             	test   $0x1,%dl
  80127e:	74 11                	je     801291 <fd_alloc+0x2d>
  801280:	89 c2                	mov    %eax,%edx
  801282:	c1 ea 0c             	shr    $0xc,%edx
  801285:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80128c:	f6 c2 01             	test   $0x1,%dl
  80128f:	75 09                	jne    80129a <fd_alloc+0x36>
			*fd_store = fd;
  801291:	89 01                	mov    %eax,(%ecx)
			return 0;
  801293:	b8 00 00 00 00       	mov    $0x0,%eax
  801298:	eb 17                	jmp    8012b1 <fd_alloc+0x4d>
  80129a:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80129f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012a4:	75 c9                	jne    80126f <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012a6:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8012ac:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8012b1:	5d                   	pop    %ebp
  8012b2:	c3                   	ret    

008012b3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012b9:	83 f8 1f             	cmp    $0x1f,%eax
  8012bc:	77 36                	ja     8012f4 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012be:	c1 e0 0c             	shl    $0xc,%eax
  8012c1:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012c6:	89 c2                	mov    %eax,%edx
  8012c8:	c1 ea 16             	shr    $0x16,%edx
  8012cb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012d2:	f6 c2 01             	test   $0x1,%dl
  8012d5:	74 24                	je     8012fb <fd_lookup+0x48>
  8012d7:	89 c2                	mov    %eax,%edx
  8012d9:	c1 ea 0c             	shr    $0xc,%edx
  8012dc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012e3:	f6 c2 01             	test   $0x1,%dl
  8012e6:	74 1a                	je     801302 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012eb:	89 02                	mov    %eax,(%edx)
	return 0;
  8012ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f2:	eb 13                	jmp    801307 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8012f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012f9:	eb 0c                	jmp    801307 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8012fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801300:	eb 05                	jmp    801307 <fd_lookup+0x54>
  801302:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  801307:	5d                   	pop    %ebp
  801308:	c3                   	ret    

00801309 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
  80130c:	83 ec 08             	sub    $0x8,%esp
  80130f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801312:	ba 6c 28 80 00       	mov    $0x80286c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801317:	eb 13                	jmp    80132c <dev_lookup+0x23>
  801319:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  80131c:	39 08                	cmp    %ecx,(%eax)
  80131e:	75 0c                	jne    80132c <dev_lookup+0x23>
			*dev = devtab[i];
  801320:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801323:	89 01                	mov    %eax,(%ecx)
			return 0;
  801325:	b8 00 00 00 00       	mov    $0x0,%eax
  80132a:	eb 2e                	jmp    80135a <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80132c:	8b 02                	mov    (%edx),%eax
  80132e:	85 c0                	test   %eax,%eax
  801330:	75 e7                	jne    801319 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801332:	a1 04 40 80 00       	mov    0x804004,%eax
  801337:	8b 40 48             	mov    0x48(%eax),%eax
  80133a:	83 ec 04             	sub    $0x4,%esp
  80133d:	51                   	push   %ecx
  80133e:	50                   	push   %eax
  80133f:	68 f0 27 80 00       	push   $0x8027f0
  801344:	e8 6c ee ff ff       	call   8001b5 <cprintf>
	*dev = 0;
  801349:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801352:	83 c4 10             	add    $0x10,%esp
  801355:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80135a:	c9                   	leave  
  80135b:	c3                   	ret    

0080135c <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	56                   	push   %esi
  801360:	53                   	push   %ebx
  801361:	83 ec 10             	sub    $0x10,%esp
  801364:	8b 75 08             	mov    0x8(%ebp),%esi
  801367:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80136a:	56                   	push   %esi
  80136b:	e8 cc fe ff ff       	call   80123c <fd2num>
  801370:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801373:	89 14 24             	mov    %edx,(%esp)
  801376:	50                   	push   %eax
  801377:	e8 37 ff ff ff       	call   8012b3 <fd_lookup>
  80137c:	83 c4 08             	add    $0x8,%esp
  80137f:	85 c0                	test   %eax,%eax
  801381:	78 05                	js     801388 <fd_close+0x2c>
	    || fd != fd2)
  801383:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801386:	74 0c                	je     801394 <fd_close+0x38>
		return (must_exist ? r : 0);
  801388:	84 db                	test   %bl,%bl
  80138a:	ba 00 00 00 00       	mov    $0x0,%edx
  80138f:	0f 44 c2             	cmove  %edx,%eax
  801392:	eb 41                	jmp    8013d5 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801394:	83 ec 08             	sub    $0x8,%esp
  801397:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80139a:	50                   	push   %eax
  80139b:	ff 36                	pushl  (%esi)
  80139d:	e8 67 ff ff ff       	call   801309 <dev_lookup>
  8013a2:	89 c3                	mov    %eax,%ebx
  8013a4:	83 c4 10             	add    $0x10,%esp
  8013a7:	85 c0                	test   %eax,%eax
  8013a9:	78 1a                	js     8013c5 <fd_close+0x69>
		if (dev->dev_close)
  8013ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ae:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8013b1:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8013b6:	85 c0                	test   %eax,%eax
  8013b8:	74 0b                	je     8013c5 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  8013ba:	83 ec 0c             	sub    $0xc,%esp
  8013bd:	56                   	push   %esi
  8013be:	ff d0                	call   *%eax
  8013c0:	89 c3                	mov    %eax,%ebx
  8013c2:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8013c5:	83 ec 08             	sub    $0x8,%esp
  8013c8:	56                   	push   %esi
  8013c9:	6a 00                	push   $0x0
  8013cb:	e8 ea f7 ff ff       	call   800bba <sys_page_unmap>
	return r;
  8013d0:	83 c4 10             	add    $0x10,%esp
  8013d3:	89 d8                	mov    %ebx,%eax
}
  8013d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013d8:	5b                   	pop    %ebx
  8013d9:	5e                   	pop    %esi
  8013da:	5d                   	pop    %ebp
  8013db:	c3                   	ret    

008013dc <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8013dc:	55                   	push   %ebp
  8013dd:	89 e5                	mov    %esp,%ebp
  8013df:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013e5:	50                   	push   %eax
  8013e6:	ff 75 08             	pushl  0x8(%ebp)
  8013e9:	e8 c5 fe ff ff       	call   8012b3 <fd_lookup>
  8013ee:	83 c4 08             	add    $0x8,%esp
  8013f1:	85 c0                	test   %eax,%eax
  8013f3:	78 10                	js     801405 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8013f5:	83 ec 08             	sub    $0x8,%esp
  8013f8:	6a 01                	push   $0x1
  8013fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8013fd:	e8 5a ff ff ff       	call   80135c <fd_close>
  801402:	83 c4 10             	add    $0x10,%esp
}
  801405:	c9                   	leave  
  801406:	c3                   	ret    

00801407 <close_all>:

void
close_all(void)
{
  801407:	55                   	push   %ebp
  801408:	89 e5                	mov    %esp,%ebp
  80140a:	53                   	push   %ebx
  80140b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80140e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801413:	83 ec 0c             	sub    $0xc,%esp
  801416:	53                   	push   %ebx
  801417:	e8 c0 ff ff ff       	call   8013dc <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80141c:	83 c3 01             	add    $0x1,%ebx
  80141f:	83 c4 10             	add    $0x10,%esp
  801422:	83 fb 20             	cmp    $0x20,%ebx
  801425:	75 ec                	jne    801413 <close_all+0xc>
		close(i);
}
  801427:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80142a:	c9                   	leave  
  80142b:	c3                   	ret    

0080142c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	57                   	push   %edi
  801430:	56                   	push   %esi
  801431:	53                   	push   %ebx
  801432:	83 ec 2c             	sub    $0x2c,%esp
  801435:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801438:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80143b:	50                   	push   %eax
  80143c:	ff 75 08             	pushl  0x8(%ebp)
  80143f:	e8 6f fe ff ff       	call   8012b3 <fd_lookup>
  801444:	83 c4 08             	add    $0x8,%esp
  801447:	85 c0                	test   %eax,%eax
  801449:	0f 88 c1 00 00 00    	js     801510 <dup+0xe4>
		return r;
	close(newfdnum);
  80144f:	83 ec 0c             	sub    $0xc,%esp
  801452:	56                   	push   %esi
  801453:	e8 84 ff ff ff       	call   8013dc <close>

	newfd = INDEX2FD(newfdnum);
  801458:	89 f3                	mov    %esi,%ebx
  80145a:	c1 e3 0c             	shl    $0xc,%ebx
  80145d:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801463:	83 c4 04             	add    $0x4,%esp
  801466:	ff 75 e4             	pushl  -0x1c(%ebp)
  801469:	e8 de fd ff ff       	call   80124c <fd2data>
  80146e:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  801470:	89 1c 24             	mov    %ebx,(%esp)
  801473:	e8 d4 fd ff ff       	call   80124c <fd2data>
  801478:	83 c4 10             	add    $0x10,%esp
  80147b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80147e:	89 f8                	mov    %edi,%eax
  801480:	c1 e8 16             	shr    $0x16,%eax
  801483:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80148a:	a8 01                	test   $0x1,%al
  80148c:	74 37                	je     8014c5 <dup+0x99>
  80148e:	89 f8                	mov    %edi,%eax
  801490:	c1 e8 0c             	shr    $0xc,%eax
  801493:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80149a:	f6 c2 01             	test   $0x1,%dl
  80149d:	74 26                	je     8014c5 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80149f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014a6:	83 ec 0c             	sub    $0xc,%esp
  8014a9:	25 07 0e 00 00       	and    $0xe07,%eax
  8014ae:	50                   	push   %eax
  8014af:	ff 75 d4             	pushl  -0x2c(%ebp)
  8014b2:	6a 00                	push   $0x0
  8014b4:	57                   	push   %edi
  8014b5:	6a 00                	push   $0x0
  8014b7:	e8 d8 f6 ff ff       	call   800b94 <sys_page_map>
  8014bc:	89 c7                	mov    %eax,%edi
  8014be:	83 c4 20             	add    $0x20,%esp
  8014c1:	85 c0                	test   %eax,%eax
  8014c3:	78 2e                	js     8014f3 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014c8:	89 d0                	mov    %edx,%eax
  8014ca:	c1 e8 0c             	shr    $0xc,%eax
  8014cd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014d4:	83 ec 0c             	sub    $0xc,%esp
  8014d7:	25 07 0e 00 00       	and    $0xe07,%eax
  8014dc:	50                   	push   %eax
  8014dd:	53                   	push   %ebx
  8014de:	6a 00                	push   $0x0
  8014e0:	52                   	push   %edx
  8014e1:	6a 00                	push   $0x0
  8014e3:	e8 ac f6 ff ff       	call   800b94 <sys_page_map>
  8014e8:	89 c7                	mov    %eax,%edi
  8014ea:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  8014ed:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014ef:	85 ff                	test   %edi,%edi
  8014f1:	79 1d                	jns    801510 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8014f3:	83 ec 08             	sub    $0x8,%esp
  8014f6:	53                   	push   %ebx
  8014f7:	6a 00                	push   $0x0
  8014f9:	e8 bc f6 ff ff       	call   800bba <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014fe:	83 c4 08             	add    $0x8,%esp
  801501:	ff 75 d4             	pushl  -0x2c(%ebp)
  801504:	6a 00                	push   $0x0
  801506:	e8 af f6 ff ff       	call   800bba <sys_page_unmap>
	return r;
  80150b:	83 c4 10             	add    $0x10,%esp
  80150e:	89 f8                	mov    %edi,%eax
}
  801510:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801513:	5b                   	pop    %ebx
  801514:	5e                   	pop    %esi
  801515:	5f                   	pop    %edi
  801516:	5d                   	pop    %ebp
  801517:	c3                   	ret    

00801518 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	53                   	push   %ebx
  80151c:	83 ec 14             	sub    $0x14,%esp
  80151f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801522:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801525:	50                   	push   %eax
  801526:	53                   	push   %ebx
  801527:	e8 87 fd ff ff       	call   8012b3 <fd_lookup>
  80152c:	83 c4 08             	add    $0x8,%esp
  80152f:	89 c2                	mov    %eax,%edx
  801531:	85 c0                	test   %eax,%eax
  801533:	78 6d                	js     8015a2 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801535:	83 ec 08             	sub    $0x8,%esp
  801538:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80153b:	50                   	push   %eax
  80153c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153f:	ff 30                	pushl  (%eax)
  801541:	e8 c3 fd ff ff       	call   801309 <dev_lookup>
  801546:	83 c4 10             	add    $0x10,%esp
  801549:	85 c0                	test   %eax,%eax
  80154b:	78 4c                	js     801599 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80154d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801550:	8b 42 08             	mov    0x8(%edx),%eax
  801553:	83 e0 03             	and    $0x3,%eax
  801556:	83 f8 01             	cmp    $0x1,%eax
  801559:	75 21                	jne    80157c <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80155b:	a1 04 40 80 00       	mov    0x804004,%eax
  801560:	8b 40 48             	mov    0x48(%eax),%eax
  801563:	83 ec 04             	sub    $0x4,%esp
  801566:	53                   	push   %ebx
  801567:	50                   	push   %eax
  801568:	68 31 28 80 00       	push   $0x802831
  80156d:	e8 43 ec ff ff       	call   8001b5 <cprintf>
		return -E_INVAL;
  801572:	83 c4 10             	add    $0x10,%esp
  801575:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80157a:	eb 26                	jmp    8015a2 <read+0x8a>
	}
	if (!dev->dev_read)
  80157c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80157f:	8b 40 08             	mov    0x8(%eax),%eax
  801582:	85 c0                	test   %eax,%eax
  801584:	74 17                	je     80159d <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801586:	83 ec 04             	sub    $0x4,%esp
  801589:	ff 75 10             	pushl  0x10(%ebp)
  80158c:	ff 75 0c             	pushl  0xc(%ebp)
  80158f:	52                   	push   %edx
  801590:	ff d0                	call   *%eax
  801592:	89 c2                	mov    %eax,%edx
  801594:	83 c4 10             	add    $0x10,%esp
  801597:	eb 09                	jmp    8015a2 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801599:	89 c2                	mov    %eax,%edx
  80159b:	eb 05                	jmp    8015a2 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80159d:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  8015a2:	89 d0                	mov    %edx,%eax
  8015a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
  8015ac:	57                   	push   %edi
  8015ad:	56                   	push   %esi
  8015ae:	53                   	push   %ebx
  8015af:	83 ec 0c             	sub    $0xc,%esp
  8015b2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015b5:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015bd:	eb 21                	jmp    8015e0 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015bf:	83 ec 04             	sub    $0x4,%esp
  8015c2:	89 f0                	mov    %esi,%eax
  8015c4:	29 d8                	sub    %ebx,%eax
  8015c6:	50                   	push   %eax
  8015c7:	89 d8                	mov    %ebx,%eax
  8015c9:	03 45 0c             	add    0xc(%ebp),%eax
  8015cc:	50                   	push   %eax
  8015cd:	57                   	push   %edi
  8015ce:	e8 45 ff ff ff       	call   801518 <read>
		if (m < 0)
  8015d3:	83 c4 10             	add    $0x10,%esp
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	78 10                	js     8015ea <readn+0x41>
			return m;
		if (m == 0)
  8015da:	85 c0                	test   %eax,%eax
  8015dc:	74 0a                	je     8015e8 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015de:	01 c3                	add    %eax,%ebx
  8015e0:	39 f3                	cmp    %esi,%ebx
  8015e2:	72 db                	jb     8015bf <readn+0x16>
  8015e4:	89 d8                	mov    %ebx,%eax
  8015e6:	eb 02                	jmp    8015ea <readn+0x41>
  8015e8:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8015ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015ed:	5b                   	pop    %ebx
  8015ee:	5e                   	pop    %esi
  8015ef:	5f                   	pop    %edi
  8015f0:	5d                   	pop    %ebp
  8015f1:	c3                   	ret    

008015f2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	53                   	push   %ebx
  8015f6:	83 ec 14             	sub    $0x14,%esp
  8015f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ff:	50                   	push   %eax
  801600:	53                   	push   %ebx
  801601:	e8 ad fc ff ff       	call   8012b3 <fd_lookup>
  801606:	83 c4 08             	add    $0x8,%esp
  801609:	89 c2                	mov    %eax,%edx
  80160b:	85 c0                	test   %eax,%eax
  80160d:	78 68                	js     801677 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80160f:	83 ec 08             	sub    $0x8,%esp
  801612:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801615:	50                   	push   %eax
  801616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801619:	ff 30                	pushl  (%eax)
  80161b:	e8 e9 fc ff ff       	call   801309 <dev_lookup>
  801620:	83 c4 10             	add    $0x10,%esp
  801623:	85 c0                	test   %eax,%eax
  801625:	78 47                	js     80166e <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801627:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80162e:	75 21                	jne    801651 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801630:	a1 04 40 80 00       	mov    0x804004,%eax
  801635:	8b 40 48             	mov    0x48(%eax),%eax
  801638:	83 ec 04             	sub    $0x4,%esp
  80163b:	53                   	push   %ebx
  80163c:	50                   	push   %eax
  80163d:	68 4d 28 80 00       	push   $0x80284d
  801642:	e8 6e eb ff ff       	call   8001b5 <cprintf>
		return -E_INVAL;
  801647:	83 c4 10             	add    $0x10,%esp
  80164a:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80164f:	eb 26                	jmp    801677 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801651:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801654:	8b 52 0c             	mov    0xc(%edx),%edx
  801657:	85 d2                	test   %edx,%edx
  801659:	74 17                	je     801672 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80165b:	83 ec 04             	sub    $0x4,%esp
  80165e:	ff 75 10             	pushl  0x10(%ebp)
  801661:	ff 75 0c             	pushl  0xc(%ebp)
  801664:	50                   	push   %eax
  801665:	ff d2                	call   *%edx
  801667:	89 c2                	mov    %eax,%edx
  801669:	83 c4 10             	add    $0x10,%esp
  80166c:	eb 09                	jmp    801677 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80166e:	89 c2                	mov    %eax,%edx
  801670:	eb 05                	jmp    801677 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801672:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  801677:	89 d0                	mov    %edx,%eax
  801679:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    

0080167e <seek>:

int
seek(int fdnum, off_t offset)
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
  801681:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801684:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801687:	50                   	push   %eax
  801688:	ff 75 08             	pushl  0x8(%ebp)
  80168b:	e8 23 fc ff ff       	call   8012b3 <fd_lookup>
  801690:	83 c4 08             	add    $0x8,%esp
  801693:	85 c0                	test   %eax,%eax
  801695:	78 0e                	js     8016a5 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801697:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80169a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	53                   	push   %ebx
  8016ab:	83 ec 14             	sub    $0x14,%esp
  8016ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b4:	50                   	push   %eax
  8016b5:	53                   	push   %ebx
  8016b6:	e8 f8 fb ff ff       	call   8012b3 <fd_lookup>
  8016bb:	83 c4 08             	add    $0x8,%esp
  8016be:	89 c2                	mov    %eax,%edx
  8016c0:	85 c0                	test   %eax,%eax
  8016c2:	78 65                	js     801729 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c4:	83 ec 08             	sub    $0x8,%esp
  8016c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ca:	50                   	push   %eax
  8016cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ce:	ff 30                	pushl  (%eax)
  8016d0:	e8 34 fc ff ff       	call   801309 <dev_lookup>
  8016d5:	83 c4 10             	add    $0x10,%esp
  8016d8:	85 c0                	test   %eax,%eax
  8016da:	78 44                	js     801720 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016df:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016e3:	75 21                	jne    801706 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8016e5:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016ea:	8b 40 48             	mov    0x48(%eax),%eax
  8016ed:	83 ec 04             	sub    $0x4,%esp
  8016f0:	53                   	push   %ebx
  8016f1:	50                   	push   %eax
  8016f2:	68 10 28 80 00       	push   $0x802810
  8016f7:	e8 b9 ea ff ff       	call   8001b5 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8016fc:	83 c4 10             	add    $0x10,%esp
  8016ff:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801704:	eb 23                	jmp    801729 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  801706:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801709:	8b 52 18             	mov    0x18(%edx),%edx
  80170c:	85 d2                	test   %edx,%edx
  80170e:	74 14                	je     801724 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801710:	83 ec 08             	sub    $0x8,%esp
  801713:	ff 75 0c             	pushl  0xc(%ebp)
  801716:	50                   	push   %eax
  801717:	ff d2                	call   *%edx
  801719:	89 c2                	mov    %eax,%edx
  80171b:	83 c4 10             	add    $0x10,%esp
  80171e:	eb 09                	jmp    801729 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801720:	89 c2                	mov    %eax,%edx
  801722:	eb 05                	jmp    801729 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801724:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  801729:	89 d0                	mov    %edx,%eax
  80172b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	53                   	push   %ebx
  801734:	83 ec 14             	sub    $0x14,%esp
  801737:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80173a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80173d:	50                   	push   %eax
  80173e:	ff 75 08             	pushl  0x8(%ebp)
  801741:	e8 6d fb ff ff       	call   8012b3 <fd_lookup>
  801746:	83 c4 08             	add    $0x8,%esp
  801749:	89 c2                	mov    %eax,%edx
  80174b:	85 c0                	test   %eax,%eax
  80174d:	78 58                	js     8017a7 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80174f:	83 ec 08             	sub    $0x8,%esp
  801752:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801755:	50                   	push   %eax
  801756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801759:	ff 30                	pushl  (%eax)
  80175b:	e8 a9 fb ff ff       	call   801309 <dev_lookup>
  801760:	83 c4 10             	add    $0x10,%esp
  801763:	85 c0                	test   %eax,%eax
  801765:	78 37                	js     80179e <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  801767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80176e:	74 32                	je     8017a2 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801770:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801773:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80177a:	00 00 00 
	stat->st_isdir = 0;
  80177d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801784:	00 00 00 
	stat->st_dev = dev;
  801787:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80178d:	83 ec 08             	sub    $0x8,%esp
  801790:	53                   	push   %ebx
  801791:	ff 75 f0             	pushl  -0x10(%ebp)
  801794:	ff 50 14             	call   *0x14(%eax)
  801797:	89 c2                	mov    %eax,%edx
  801799:	83 c4 10             	add    $0x10,%esp
  80179c:	eb 09                	jmp    8017a7 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80179e:	89 c2                	mov    %eax,%edx
  8017a0:	eb 05                	jmp    8017a7 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8017a2:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8017a7:	89 d0                	mov    %edx,%eax
  8017a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	56                   	push   %esi
  8017b2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017b3:	83 ec 08             	sub    $0x8,%esp
  8017b6:	6a 00                	push   $0x0
  8017b8:	ff 75 08             	pushl  0x8(%ebp)
  8017bb:	e8 06 02 00 00       	call   8019c6 <open>
  8017c0:	89 c3                	mov    %eax,%ebx
  8017c2:	83 c4 10             	add    $0x10,%esp
  8017c5:	85 c0                	test   %eax,%eax
  8017c7:	78 1b                	js     8017e4 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8017c9:	83 ec 08             	sub    $0x8,%esp
  8017cc:	ff 75 0c             	pushl  0xc(%ebp)
  8017cf:	50                   	push   %eax
  8017d0:	e8 5b ff ff ff       	call   801730 <fstat>
  8017d5:	89 c6                	mov    %eax,%esi
	close(fd);
  8017d7:	89 1c 24             	mov    %ebx,(%esp)
  8017da:	e8 fd fb ff ff       	call   8013dc <close>
	return r;
  8017df:	83 c4 10             	add    $0x10,%esp
  8017e2:	89 f0                	mov    %esi,%eax
}
  8017e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e7:	5b                   	pop    %ebx
  8017e8:	5e                   	pop    %esi
  8017e9:	5d                   	pop    %ebp
  8017ea:	c3                   	ret    

008017eb <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	56                   	push   %esi
  8017ef:	53                   	push   %ebx
  8017f0:	89 c6                	mov    %eax,%esi
  8017f2:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017f4:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8017fb:	75 12                	jne    80180f <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017fd:	83 ec 0c             	sub    $0xc,%esp
  801800:	6a 01                	push   $0x1
  801802:	e8 fc f9 ff ff       	call   801203 <ipc_find_env>
  801807:	a3 00 40 80 00       	mov    %eax,0x804000
  80180c:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80180f:	6a 07                	push   $0x7
  801811:	68 00 50 80 00       	push   $0x805000
  801816:	56                   	push   %esi
  801817:	ff 35 00 40 80 00    	pushl  0x804000
  80181d:	e8 8d f9 ff ff       	call   8011af <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801822:	83 c4 0c             	add    $0xc,%esp
  801825:	6a 00                	push   $0x0
  801827:	53                   	push   %ebx
  801828:	6a 00                	push   $0x0
  80182a:	e8 15 f9 ff ff       	call   801144 <ipc_recv>
}
  80182f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801832:	5b                   	pop    %ebx
  801833:	5e                   	pop    %esi
  801834:	5d                   	pop    %ebp
  801835:	c3                   	ret    

00801836 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	8b 40 0c             	mov    0xc(%eax),%eax
  801842:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801847:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184a:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80184f:	ba 00 00 00 00       	mov    $0x0,%edx
  801854:	b8 02 00 00 00       	mov    $0x2,%eax
  801859:	e8 8d ff ff ff       	call   8017eb <fsipc>
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	8b 40 0c             	mov    0xc(%eax),%eax
  80186c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801871:	ba 00 00 00 00       	mov    $0x0,%edx
  801876:	b8 06 00 00 00       	mov    $0x6,%eax
  80187b:	e8 6b ff ff ff       	call   8017eb <fsipc>
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	53                   	push   %ebx
  801886:	83 ec 04             	sub    $0x4,%esp
  801889:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80188c:	8b 45 08             	mov    0x8(%ebp),%eax
  80188f:	8b 40 0c             	mov    0xc(%eax),%eax
  801892:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801897:	ba 00 00 00 00       	mov    $0x0,%edx
  80189c:	b8 05 00 00 00       	mov    $0x5,%eax
  8018a1:	e8 45 ff ff ff       	call   8017eb <fsipc>
  8018a6:	85 c0                	test   %eax,%eax
  8018a8:	78 2c                	js     8018d6 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018aa:	83 ec 08             	sub    $0x8,%esp
  8018ad:	68 00 50 80 00       	push   $0x805000
  8018b2:	53                   	push   %ebx
  8018b3:	e8 6f ee ff ff       	call   800727 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018b8:	a1 80 50 80 00       	mov    0x805080,%eax
  8018bd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018c3:	a1 84 50 80 00       	mov    0x805084,%eax
  8018c8:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018ce:	83 c4 10             	add    $0x10,%esp
  8018d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	83 ec 08             	sub    $0x8,%esp
  8018e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e4:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018ea:	8b 49 0c             	mov    0xc(%ecx),%ecx
  8018ed:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  8018f3:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8018f8:	76 22                	jbe    80191c <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  8018fa:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  801901:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  801904:	83 ec 04             	sub    $0x4,%esp
  801907:	68 f8 0f 00 00       	push   $0xff8
  80190c:	52                   	push   %edx
  80190d:	68 08 50 80 00       	push   $0x805008
  801912:	e8 a3 ef ff ff       	call   8008ba <memmove>
  801917:	83 c4 10             	add    $0x10,%esp
  80191a:	eb 17                	jmp    801933 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  80191c:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  801921:	83 ec 04             	sub    $0x4,%esp
  801924:	50                   	push   %eax
  801925:	52                   	push   %edx
  801926:	68 08 50 80 00       	push   $0x805008
  80192b:	e8 8a ef ff ff       	call   8008ba <memmove>
  801930:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  801933:	ba 00 00 00 00       	mov    $0x0,%edx
  801938:	b8 04 00 00 00       	mov    $0x4,%eax
  80193d:	e8 a9 fe ff ff       	call   8017eb <fsipc>
	if (result < 0)
		return result;

	return result;
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	56                   	push   %esi
  801948:	53                   	push   %ebx
  801949:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	8b 40 0c             	mov    0xc(%eax),%eax
  801952:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801957:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80195d:	ba 00 00 00 00       	mov    $0x0,%edx
  801962:	b8 03 00 00 00       	mov    $0x3,%eax
  801967:	e8 7f fe ff ff       	call   8017eb <fsipc>
  80196c:	89 c3                	mov    %eax,%ebx
  80196e:	85 c0                	test   %eax,%eax
  801970:	78 4b                	js     8019bd <devfile_read+0x79>
		return r;
	assert(r <= n);
  801972:	39 c6                	cmp    %eax,%esi
  801974:	73 16                	jae    80198c <devfile_read+0x48>
  801976:	68 7c 28 80 00       	push   $0x80287c
  80197b:	68 83 28 80 00       	push   $0x802883
  801980:	6a 7c                	push   $0x7c
  801982:	68 98 28 80 00       	push   $0x802898
  801987:	e8 bd 05 00 00       	call   801f49 <_panic>
	assert(r <= PGSIZE);
  80198c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801991:	7e 16                	jle    8019a9 <devfile_read+0x65>
  801993:	68 a3 28 80 00       	push   $0x8028a3
  801998:	68 83 28 80 00       	push   $0x802883
  80199d:	6a 7d                	push   $0x7d
  80199f:	68 98 28 80 00       	push   $0x802898
  8019a4:	e8 a0 05 00 00       	call   801f49 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019a9:	83 ec 04             	sub    $0x4,%esp
  8019ac:	50                   	push   %eax
  8019ad:	68 00 50 80 00       	push   $0x805000
  8019b2:	ff 75 0c             	pushl  0xc(%ebp)
  8019b5:	e8 00 ef ff ff       	call   8008ba <memmove>
	return r;
  8019ba:	83 c4 10             	add    $0x10,%esp
}
  8019bd:	89 d8                	mov    %ebx,%eax
  8019bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019c2:	5b                   	pop    %ebx
  8019c3:	5e                   	pop    %esi
  8019c4:	5d                   	pop    %ebp
  8019c5:	c3                   	ret    

008019c6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	53                   	push   %ebx
  8019ca:	83 ec 20             	sub    $0x20,%esp
  8019cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8019d0:	53                   	push   %ebx
  8019d1:	e8 18 ed ff ff       	call   8006ee <strlen>
  8019d6:	83 c4 10             	add    $0x10,%esp
  8019d9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019de:	7f 67                	jg     801a47 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8019e0:	83 ec 0c             	sub    $0xc,%esp
  8019e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019e6:	50                   	push   %eax
  8019e7:	e8 78 f8 ff ff       	call   801264 <fd_alloc>
  8019ec:	83 c4 10             	add    $0x10,%esp
		return r;
  8019ef:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8019f1:	85 c0                	test   %eax,%eax
  8019f3:	78 57                	js     801a4c <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8019f5:	83 ec 08             	sub    $0x8,%esp
  8019f8:	53                   	push   %ebx
  8019f9:	68 00 50 80 00       	push   $0x805000
  8019fe:	e8 24 ed ff ff       	call   800727 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a03:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a06:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a13:	e8 d3 fd ff ff       	call   8017eb <fsipc>
  801a18:	89 c3                	mov    %eax,%ebx
  801a1a:	83 c4 10             	add    $0x10,%esp
  801a1d:	85 c0                	test   %eax,%eax
  801a1f:	79 14                	jns    801a35 <open+0x6f>
		fd_close(fd, 0);
  801a21:	83 ec 08             	sub    $0x8,%esp
  801a24:	6a 00                	push   $0x0
  801a26:	ff 75 f4             	pushl  -0xc(%ebp)
  801a29:	e8 2e f9 ff ff       	call   80135c <fd_close>
		return r;
  801a2e:	83 c4 10             	add    $0x10,%esp
  801a31:	89 da                	mov    %ebx,%edx
  801a33:	eb 17                	jmp    801a4c <open+0x86>
	}

	return fd2num(fd);
  801a35:	83 ec 0c             	sub    $0xc,%esp
  801a38:	ff 75 f4             	pushl  -0xc(%ebp)
  801a3b:	e8 fc f7 ff ff       	call   80123c <fd2num>
  801a40:	89 c2                	mov    %eax,%edx
  801a42:	83 c4 10             	add    $0x10,%esp
  801a45:	eb 05                	jmp    801a4c <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801a47:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801a4c:	89 d0                	mov    %edx,%eax
  801a4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a59:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5e:	b8 08 00 00 00       	mov    $0x8,%eax
  801a63:	e8 83 fd ff ff       	call   8017eb <fsipc>
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	56                   	push   %esi
  801a6e:	53                   	push   %ebx
  801a6f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a72:	83 ec 0c             	sub    $0xc,%esp
  801a75:	ff 75 08             	pushl  0x8(%ebp)
  801a78:	e8 cf f7 ff ff       	call   80124c <fd2data>
  801a7d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a7f:	83 c4 08             	add    $0x8,%esp
  801a82:	68 af 28 80 00       	push   $0x8028af
  801a87:	53                   	push   %ebx
  801a88:	e8 9a ec ff ff       	call   800727 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a8d:	8b 46 04             	mov    0x4(%esi),%eax
  801a90:	2b 06                	sub    (%esi),%eax
  801a92:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a98:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a9f:	00 00 00 
	stat->st_dev = &devpipe;
  801aa2:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801aa9:	30 80 00 
	return 0;
}
  801aac:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ab4:	5b                   	pop    %ebx
  801ab5:	5e                   	pop    %esi
  801ab6:	5d                   	pop    %ebp
  801ab7:	c3                   	ret    

00801ab8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
  801abb:	53                   	push   %ebx
  801abc:	83 ec 0c             	sub    $0xc,%esp
  801abf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ac2:	53                   	push   %ebx
  801ac3:	6a 00                	push   $0x0
  801ac5:	e8 f0 f0 ff ff       	call   800bba <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801aca:	89 1c 24             	mov    %ebx,(%esp)
  801acd:	e8 7a f7 ff ff       	call   80124c <fd2data>
  801ad2:	83 c4 08             	add    $0x8,%esp
  801ad5:	50                   	push   %eax
  801ad6:	6a 00                	push   $0x0
  801ad8:	e8 dd f0 ff ff       	call   800bba <sys_page_unmap>
}
  801add:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	57                   	push   %edi
  801ae6:	56                   	push   %esi
  801ae7:	53                   	push   %ebx
  801ae8:	83 ec 1c             	sub    $0x1c,%esp
  801aeb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801aee:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801af0:	a1 04 40 80 00       	mov    0x804004,%eax
  801af5:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801af8:	83 ec 0c             	sub    $0xc,%esp
  801afb:	ff 75 e0             	pushl  -0x20(%ebp)
  801afe:	e8 1f 05 00 00       	call   802022 <pageref>
  801b03:	89 c3                	mov    %eax,%ebx
  801b05:	89 3c 24             	mov    %edi,(%esp)
  801b08:	e8 15 05 00 00       	call   802022 <pageref>
  801b0d:	83 c4 10             	add    $0x10,%esp
  801b10:	39 c3                	cmp    %eax,%ebx
  801b12:	0f 94 c1             	sete   %cl
  801b15:	0f b6 c9             	movzbl %cl,%ecx
  801b18:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801b1b:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b21:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b24:	39 ce                	cmp    %ecx,%esi
  801b26:	74 1b                	je     801b43 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801b28:	39 c3                	cmp    %eax,%ebx
  801b2a:	75 c4                	jne    801af0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b2c:	8b 42 58             	mov    0x58(%edx),%eax
  801b2f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b32:	50                   	push   %eax
  801b33:	56                   	push   %esi
  801b34:	68 b6 28 80 00       	push   $0x8028b6
  801b39:	e8 77 e6 ff ff       	call   8001b5 <cprintf>
  801b3e:	83 c4 10             	add    $0x10,%esp
  801b41:	eb ad                	jmp    801af0 <_pipeisclosed+0xe>
	}
}
  801b43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b46:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b49:	5b                   	pop    %ebx
  801b4a:	5e                   	pop    %esi
  801b4b:	5f                   	pop    %edi
  801b4c:	5d                   	pop    %ebp
  801b4d:	c3                   	ret    

00801b4e <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	57                   	push   %edi
  801b52:	56                   	push   %esi
  801b53:	53                   	push   %ebx
  801b54:	83 ec 28             	sub    $0x28,%esp
  801b57:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801b5a:	56                   	push   %esi
  801b5b:	e8 ec f6 ff ff       	call   80124c <fd2data>
  801b60:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b62:	83 c4 10             	add    $0x10,%esp
  801b65:	bf 00 00 00 00       	mov    $0x0,%edi
  801b6a:	eb 4b                	jmp    801bb7 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801b6c:	89 da                	mov    %ebx,%edx
  801b6e:	89 f0                	mov    %esi,%eax
  801b70:	e8 6d ff ff ff       	call   801ae2 <_pipeisclosed>
  801b75:	85 c0                	test   %eax,%eax
  801b77:	75 48                	jne    801bc1 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801b79:	e8 cb ef ff ff       	call   800b49 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b7e:	8b 43 04             	mov    0x4(%ebx),%eax
  801b81:	8b 0b                	mov    (%ebx),%ecx
  801b83:	8d 51 20             	lea    0x20(%ecx),%edx
  801b86:	39 d0                	cmp    %edx,%eax
  801b88:	73 e2                	jae    801b6c <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b8d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b91:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b94:	89 c2                	mov    %eax,%edx
  801b96:	c1 fa 1f             	sar    $0x1f,%edx
  801b99:	89 d1                	mov    %edx,%ecx
  801b9b:	c1 e9 1b             	shr    $0x1b,%ecx
  801b9e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ba1:	83 e2 1f             	and    $0x1f,%edx
  801ba4:	29 ca                	sub    %ecx,%edx
  801ba6:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801baa:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801bae:	83 c0 01             	add    $0x1,%eax
  801bb1:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801bb4:	83 c7 01             	add    $0x1,%edi
  801bb7:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bba:	75 c2                	jne    801b7e <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801bbc:	8b 45 10             	mov    0x10(%ebp),%eax
  801bbf:	eb 05                	jmp    801bc6 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801bc1:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801bc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bc9:	5b                   	pop    %ebx
  801bca:	5e                   	pop    %esi
  801bcb:	5f                   	pop    %edi
  801bcc:	5d                   	pop    %ebp
  801bcd:	c3                   	ret    

00801bce <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
  801bd1:	57                   	push   %edi
  801bd2:	56                   	push   %esi
  801bd3:	53                   	push   %ebx
  801bd4:	83 ec 18             	sub    $0x18,%esp
  801bd7:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801bda:	57                   	push   %edi
  801bdb:	e8 6c f6 ff ff       	call   80124c <fd2data>
  801be0:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801be2:	83 c4 10             	add    $0x10,%esp
  801be5:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bea:	eb 3d                	jmp    801c29 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801bec:	85 db                	test   %ebx,%ebx
  801bee:	74 04                	je     801bf4 <devpipe_read+0x26>
				return i;
  801bf0:	89 d8                	mov    %ebx,%eax
  801bf2:	eb 44                	jmp    801c38 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801bf4:	89 f2                	mov    %esi,%edx
  801bf6:	89 f8                	mov    %edi,%eax
  801bf8:	e8 e5 fe ff ff       	call   801ae2 <_pipeisclosed>
  801bfd:	85 c0                	test   %eax,%eax
  801bff:	75 32                	jne    801c33 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801c01:	e8 43 ef ff ff       	call   800b49 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801c06:	8b 06                	mov    (%esi),%eax
  801c08:	3b 46 04             	cmp    0x4(%esi),%eax
  801c0b:	74 df                	je     801bec <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c0d:	99                   	cltd   
  801c0e:	c1 ea 1b             	shr    $0x1b,%edx
  801c11:	01 d0                	add    %edx,%eax
  801c13:	83 e0 1f             	and    $0x1f,%eax
  801c16:	29 d0                	sub    %edx,%eax
  801c18:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801c1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c20:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801c23:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c26:	83 c3 01             	add    $0x1,%ebx
  801c29:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801c2c:	75 d8                	jne    801c06 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c31:	eb 05                	jmp    801c38 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801c33:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801c38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c3b:	5b                   	pop    %ebx
  801c3c:	5e                   	pop    %esi
  801c3d:	5f                   	pop    %edi
  801c3e:	5d                   	pop    %ebp
  801c3f:	c3                   	ret    

00801c40 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	56                   	push   %esi
  801c44:	53                   	push   %ebx
  801c45:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801c48:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c4b:	50                   	push   %eax
  801c4c:	e8 13 f6 ff ff       	call   801264 <fd_alloc>
  801c51:	83 c4 10             	add    $0x10,%esp
  801c54:	89 c2                	mov    %eax,%edx
  801c56:	85 c0                	test   %eax,%eax
  801c58:	0f 88 2c 01 00 00    	js     801d8a <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c5e:	83 ec 04             	sub    $0x4,%esp
  801c61:	68 07 04 00 00       	push   $0x407
  801c66:	ff 75 f4             	pushl  -0xc(%ebp)
  801c69:	6a 00                	push   $0x0
  801c6b:	e8 00 ef ff ff       	call   800b70 <sys_page_alloc>
  801c70:	83 c4 10             	add    $0x10,%esp
  801c73:	89 c2                	mov    %eax,%edx
  801c75:	85 c0                	test   %eax,%eax
  801c77:	0f 88 0d 01 00 00    	js     801d8a <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801c7d:	83 ec 0c             	sub    $0xc,%esp
  801c80:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c83:	50                   	push   %eax
  801c84:	e8 db f5 ff ff       	call   801264 <fd_alloc>
  801c89:	89 c3                	mov    %eax,%ebx
  801c8b:	83 c4 10             	add    $0x10,%esp
  801c8e:	85 c0                	test   %eax,%eax
  801c90:	0f 88 e2 00 00 00    	js     801d78 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c96:	83 ec 04             	sub    $0x4,%esp
  801c99:	68 07 04 00 00       	push   $0x407
  801c9e:	ff 75 f0             	pushl  -0x10(%ebp)
  801ca1:	6a 00                	push   $0x0
  801ca3:	e8 c8 ee ff ff       	call   800b70 <sys_page_alloc>
  801ca8:	89 c3                	mov    %eax,%ebx
  801caa:	83 c4 10             	add    $0x10,%esp
  801cad:	85 c0                	test   %eax,%eax
  801caf:	0f 88 c3 00 00 00    	js     801d78 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801cb5:	83 ec 0c             	sub    $0xc,%esp
  801cb8:	ff 75 f4             	pushl  -0xc(%ebp)
  801cbb:	e8 8c f5 ff ff       	call   80124c <fd2data>
  801cc0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cc2:	83 c4 0c             	add    $0xc,%esp
  801cc5:	68 07 04 00 00       	push   $0x407
  801cca:	50                   	push   %eax
  801ccb:	6a 00                	push   $0x0
  801ccd:	e8 9e ee ff ff       	call   800b70 <sys_page_alloc>
  801cd2:	89 c3                	mov    %eax,%ebx
  801cd4:	83 c4 10             	add    $0x10,%esp
  801cd7:	85 c0                	test   %eax,%eax
  801cd9:	0f 88 89 00 00 00    	js     801d68 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cdf:	83 ec 0c             	sub    $0xc,%esp
  801ce2:	ff 75 f0             	pushl  -0x10(%ebp)
  801ce5:	e8 62 f5 ff ff       	call   80124c <fd2data>
  801cea:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801cf1:	50                   	push   %eax
  801cf2:	6a 00                	push   $0x0
  801cf4:	56                   	push   %esi
  801cf5:	6a 00                	push   $0x0
  801cf7:	e8 98 ee ff ff       	call   800b94 <sys_page_map>
  801cfc:	89 c3                	mov    %eax,%ebx
  801cfe:	83 c4 20             	add    $0x20,%esp
  801d01:	85 c0                	test   %eax,%eax
  801d03:	78 55                	js     801d5a <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801d05:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0e:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d13:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801d1a:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d23:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d28:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801d2f:	83 ec 0c             	sub    $0xc,%esp
  801d32:	ff 75 f4             	pushl  -0xc(%ebp)
  801d35:	e8 02 f5 ff ff       	call   80123c <fd2num>
  801d3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d3d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d3f:	83 c4 04             	add    $0x4,%esp
  801d42:	ff 75 f0             	pushl  -0x10(%ebp)
  801d45:	e8 f2 f4 ff ff       	call   80123c <fd2num>
  801d4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d4d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d50:	83 c4 10             	add    $0x10,%esp
  801d53:	ba 00 00 00 00       	mov    $0x0,%edx
  801d58:	eb 30                	jmp    801d8a <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801d5a:	83 ec 08             	sub    $0x8,%esp
  801d5d:	56                   	push   %esi
  801d5e:	6a 00                	push   $0x0
  801d60:	e8 55 ee ff ff       	call   800bba <sys_page_unmap>
  801d65:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801d68:	83 ec 08             	sub    $0x8,%esp
  801d6b:	ff 75 f0             	pushl  -0x10(%ebp)
  801d6e:	6a 00                	push   $0x0
  801d70:	e8 45 ee ff ff       	call   800bba <sys_page_unmap>
  801d75:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801d78:	83 ec 08             	sub    $0x8,%esp
  801d7b:	ff 75 f4             	pushl  -0xc(%ebp)
  801d7e:	6a 00                	push   $0x0
  801d80:	e8 35 ee ff ff       	call   800bba <sys_page_unmap>
  801d85:	83 c4 10             	add    $0x10,%esp
  801d88:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  801d8a:	89 d0                	mov    %edx,%eax
  801d8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d8f:	5b                   	pop    %ebx
  801d90:	5e                   	pop    %esi
  801d91:	5d                   	pop    %ebp
  801d92:	c3                   	ret    

00801d93 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d99:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d9c:	50                   	push   %eax
  801d9d:	ff 75 08             	pushl  0x8(%ebp)
  801da0:	e8 0e f5 ff ff       	call   8012b3 <fd_lookup>
  801da5:	83 c4 10             	add    $0x10,%esp
  801da8:	85 c0                	test   %eax,%eax
  801daa:	78 18                	js     801dc4 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801dac:	83 ec 0c             	sub    $0xc,%esp
  801daf:	ff 75 f4             	pushl  -0xc(%ebp)
  801db2:	e8 95 f4 ff ff       	call   80124c <fd2data>
	return _pipeisclosed(fd, p);
  801db7:	89 c2                	mov    %eax,%edx
  801db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbc:	e8 21 fd ff ff       	call   801ae2 <_pipeisclosed>
  801dc1:	83 c4 10             	add    $0x10,%esp
}
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801dc9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dce:	5d                   	pop    %ebp
  801dcf:	c3                   	ret    

00801dd0 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801dd6:	68 ce 28 80 00       	push   $0x8028ce
  801ddb:	ff 75 0c             	pushl  0xc(%ebp)
  801dde:	e8 44 e9 ff ff       	call   800727 <strcpy>
	return 0;
}
  801de3:	b8 00 00 00 00       	mov    $0x0,%eax
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
  801ded:	57                   	push   %edi
  801dee:	56                   	push   %esi
  801def:	53                   	push   %ebx
  801df0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801df6:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801dfb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e01:	eb 2d                	jmp    801e30 <devcons_write+0x46>
		m = n - tot;
  801e03:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e06:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801e08:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801e0b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801e10:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801e13:	83 ec 04             	sub    $0x4,%esp
  801e16:	53                   	push   %ebx
  801e17:	03 45 0c             	add    0xc(%ebp),%eax
  801e1a:	50                   	push   %eax
  801e1b:	57                   	push   %edi
  801e1c:	e8 99 ea ff ff       	call   8008ba <memmove>
		sys_cputs(buf, m);
  801e21:	83 c4 08             	add    $0x8,%esp
  801e24:	53                   	push   %ebx
  801e25:	57                   	push   %edi
  801e26:	e8 8e ec ff ff       	call   800ab9 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e2b:	01 de                	add    %ebx,%esi
  801e2d:	83 c4 10             	add    $0x10,%esp
  801e30:	89 f0                	mov    %esi,%eax
  801e32:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e35:	72 cc                	jb     801e03 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801e37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e3a:	5b                   	pop    %ebx
  801e3b:	5e                   	pop    %esi
  801e3c:	5f                   	pop    %edi
  801e3d:	5d                   	pop    %ebp
  801e3e:	c3                   	ret    

00801e3f <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
  801e42:	83 ec 08             	sub    $0x8,%esp
  801e45:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801e4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e4e:	74 2a                	je     801e7a <devcons_read+0x3b>
  801e50:	eb 05                	jmp    801e57 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801e52:	e8 f2 ec ff ff       	call   800b49 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801e57:	e8 83 ec ff ff       	call   800adf <sys_cgetc>
  801e5c:	85 c0                	test   %eax,%eax
  801e5e:	74 f2                	je     801e52 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801e60:	85 c0                	test   %eax,%eax
  801e62:	78 16                	js     801e7a <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801e64:	83 f8 04             	cmp    $0x4,%eax
  801e67:	74 0c                	je     801e75 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801e69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e6c:	88 02                	mov    %al,(%edx)
	return 1;
  801e6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e73:	eb 05                	jmp    801e7a <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801e75:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
  801e7f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801e88:	6a 01                	push   $0x1
  801e8a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e8d:	50                   	push   %eax
  801e8e:	e8 26 ec ff ff       	call   800ab9 <sys_cputs>
}
  801e93:	83 c4 10             	add    $0x10,%esp
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <getchar>:

int
getchar(void)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801e9e:	6a 01                	push   $0x1
  801ea0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ea3:	50                   	push   %eax
  801ea4:	6a 00                	push   $0x0
  801ea6:	e8 6d f6 ff ff       	call   801518 <read>
	if (r < 0)
  801eab:	83 c4 10             	add    $0x10,%esp
  801eae:	85 c0                	test   %eax,%eax
  801eb0:	78 0f                	js     801ec1 <getchar+0x29>
		return r;
	if (r < 1)
  801eb2:	85 c0                	test   %eax,%eax
  801eb4:	7e 06                	jle    801ebc <getchar+0x24>
		return -E_EOF;
	return c;
  801eb6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801eba:	eb 05                	jmp    801ec1 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801ebc:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
  801ec6:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ec9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ecc:	50                   	push   %eax
  801ecd:	ff 75 08             	pushl  0x8(%ebp)
  801ed0:	e8 de f3 ff ff       	call   8012b3 <fd_lookup>
  801ed5:	83 c4 10             	add    $0x10,%esp
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	78 11                	js     801eed <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edf:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ee5:	39 10                	cmp    %edx,(%eax)
  801ee7:	0f 94 c0             	sete   %al
  801eea:	0f b6 c0             	movzbl %al,%eax
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <opencons>:

int
opencons(void)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801ef5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ef8:	50                   	push   %eax
  801ef9:	e8 66 f3 ff ff       	call   801264 <fd_alloc>
  801efe:	83 c4 10             	add    $0x10,%esp
		return r;
  801f01:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801f03:	85 c0                	test   %eax,%eax
  801f05:	78 3e                	js     801f45 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f07:	83 ec 04             	sub    $0x4,%esp
  801f0a:	68 07 04 00 00       	push   $0x407
  801f0f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f12:	6a 00                	push   $0x0
  801f14:	e8 57 ec ff ff       	call   800b70 <sys_page_alloc>
  801f19:	83 c4 10             	add    $0x10,%esp
		return r;
  801f1c:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f1e:	85 c0                	test   %eax,%eax
  801f20:	78 23                	js     801f45 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801f22:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f30:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f37:	83 ec 0c             	sub    $0xc,%esp
  801f3a:	50                   	push   %eax
  801f3b:	e8 fc f2 ff ff       	call   80123c <fd2num>
  801f40:	89 c2                	mov    %eax,%edx
  801f42:	83 c4 10             	add    $0x10,%esp
}
  801f45:	89 d0                	mov    %edx,%eax
  801f47:	c9                   	leave  
  801f48:	c3                   	ret    

00801f49 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
  801f4c:	56                   	push   %esi
  801f4d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801f4e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801f51:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801f57:	e8 c9 eb ff ff       	call   800b25 <sys_getenvid>
  801f5c:	83 ec 0c             	sub    $0xc,%esp
  801f5f:	ff 75 0c             	pushl  0xc(%ebp)
  801f62:	ff 75 08             	pushl  0x8(%ebp)
  801f65:	56                   	push   %esi
  801f66:	50                   	push   %eax
  801f67:	68 dc 28 80 00       	push   $0x8028dc
  801f6c:	e8 44 e2 ff ff       	call   8001b5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801f71:	83 c4 18             	add    $0x18,%esp
  801f74:	53                   	push   %ebx
  801f75:	ff 75 10             	pushl  0x10(%ebp)
  801f78:	e8 e7 e1 ff ff       	call   800164 <vcprintf>
	cprintf("\n");
  801f7d:	c7 04 24 c7 28 80 00 	movl   $0x8028c7,(%esp)
  801f84:	e8 2c e2 ff ff       	call   8001b5 <cprintf>
  801f89:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801f8c:	cc                   	int3   
  801f8d:	eb fd                	jmp    801f8c <_panic+0x43>

00801f8f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
  801f92:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801f95:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801f9c:	75 2c                	jne    801fca <set_pgfault_handler+0x3b>
		// First time through!
		// LAB 4: Your code here.
		r = sys_page_alloc(0,(void *)(UXSTACKTOP - PGSIZE),PTE_P | PTE_U | PTE_W);
  801f9e:	83 ec 04             	sub    $0x4,%esp
  801fa1:	6a 07                	push   $0x7
  801fa3:	68 00 f0 bf ee       	push   $0xeebff000
  801fa8:	6a 00                	push   $0x0
  801faa:	e8 c1 eb ff ff       	call   800b70 <sys_page_alloc>
		if(r < 0)
  801faf:	83 c4 10             	add    $0x10,%esp
  801fb2:	85 c0                	test   %eax,%eax
  801fb4:	79 14                	jns    801fca <set_pgfault_handler+0x3b>
			panic("set_pgfault_handler: error in sys_page_alloc\n");	
  801fb6:	83 ec 04             	sub    $0x4,%esp
  801fb9:	68 00 29 80 00       	push   $0x802900
  801fbe:	6a 22                	push   $0x22
  801fc0:	68 6c 29 80 00       	push   $0x80296c
  801fc5:	e8 7f ff ff ff       	call   801f49 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801fca:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcd:	a3 00 60 80 00       	mov    %eax,0x806000
	r = sys_env_set_pgfault_upcall(0, _pgfault_upcall); 
  801fd2:	83 ec 08             	sub    $0x8,%esp
  801fd5:	68 fe 1f 80 00       	push   $0x801ffe
  801fda:	6a 00                	push   $0x0
  801fdc:	e8 42 ec ff ff       	call   800c23 <sys_env_set_pgfault_upcall>
	if (r < 0)
  801fe1:	83 c4 10             	add    $0x10,%esp
  801fe4:	85 c0                	test   %eax,%eax
  801fe6:	79 14                	jns    801ffc <set_pgfault_handler+0x6d>
		panic("set_pgfault_handler: error in sys_env_set_pgfault_upcall");
  801fe8:	83 ec 04             	sub    $0x4,%esp
  801feb:	68 30 29 80 00       	push   $0x802930
  801ff0:	6a 29                	push   $0x29
  801ff2:	68 6c 29 80 00       	push   $0x80296c
  801ff7:	e8 4d ff ff ff       	call   801f49 <_panic>
}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801ffe:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801fff:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802004:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802006:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	subl $0x4, 0x30(%esp)
  802009:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  80200e:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 0x28(%esp), %ebx 	
  802012:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  802016:	89 18                	mov    %ebx,(%eax)
	addl $0x8, %esp
  802018:	83 c4 08             	add    $0x8,%esp


	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  80201b:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp 
  80201c:	83 c4 04             	add    $0x4,%esp
	popfl
  80201f:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802020:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802021:	c3                   	ret    

00802022 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
  802025:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802028:	89 d0                	mov    %edx,%eax
  80202a:	c1 e8 16             	shr    $0x16,%eax
  80202d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802034:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802039:	f6 c1 01             	test   $0x1,%cl
  80203c:	74 1d                	je     80205b <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80203e:	c1 ea 0c             	shr    $0xc,%edx
  802041:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802048:	f6 c2 01             	test   $0x1,%dl
  80204b:	74 0e                	je     80205b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80204d:	c1 ea 0c             	shr    $0xc,%edx
  802050:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802057:	ef 
  802058:	0f b7 c0             	movzwl %ax,%eax
}
  80205b:	5d                   	pop    %ebp
  80205c:	c3                   	ret    
  80205d:	66 90                	xchg   %ax,%ax
  80205f:	90                   	nop

00802060 <__udivdi3>:
  802060:	55                   	push   %ebp
  802061:	57                   	push   %edi
  802062:	56                   	push   %esi
  802063:	53                   	push   %ebx
  802064:	83 ec 1c             	sub    $0x1c,%esp
  802067:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80206b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80206f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802073:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802077:	85 f6                	test   %esi,%esi
  802079:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80207d:	89 ca                	mov    %ecx,%edx
  80207f:	89 f8                	mov    %edi,%eax
  802081:	75 3d                	jne    8020c0 <__udivdi3+0x60>
  802083:	39 cf                	cmp    %ecx,%edi
  802085:	0f 87 c5 00 00 00    	ja     802150 <__udivdi3+0xf0>
  80208b:	85 ff                	test   %edi,%edi
  80208d:	89 fd                	mov    %edi,%ebp
  80208f:	75 0b                	jne    80209c <__udivdi3+0x3c>
  802091:	b8 01 00 00 00       	mov    $0x1,%eax
  802096:	31 d2                	xor    %edx,%edx
  802098:	f7 f7                	div    %edi
  80209a:	89 c5                	mov    %eax,%ebp
  80209c:	89 c8                	mov    %ecx,%eax
  80209e:	31 d2                	xor    %edx,%edx
  8020a0:	f7 f5                	div    %ebp
  8020a2:	89 c1                	mov    %eax,%ecx
  8020a4:	89 d8                	mov    %ebx,%eax
  8020a6:	89 cf                	mov    %ecx,%edi
  8020a8:	f7 f5                	div    %ebp
  8020aa:	89 c3                	mov    %eax,%ebx
  8020ac:	89 d8                	mov    %ebx,%eax
  8020ae:	89 fa                	mov    %edi,%edx
  8020b0:	83 c4 1c             	add    $0x1c,%esp
  8020b3:	5b                   	pop    %ebx
  8020b4:	5e                   	pop    %esi
  8020b5:	5f                   	pop    %edi
  8020b6:	5d                   	pop    %ebp
  8020b7:	c3                   	ret    
  8020b8:	90                   	nop
  8020b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020c0:	39 ce                	cmp    %ecx,%esi
  8020c2:	77 74                	ja     802138 <__udivdi3+0xd8>
  8020c4:	0f bd fe             	bsr    %esi,%edi
  8020c7:	83 f7 1f             	xor    $0x1f,%edi
  8020ca:	0f 84 98 00 00 00    	je     802168 <__udivdi3+0x108>
  8020d0:	bb 20 00 00 00       	mov    $0x20,%ebx
  8020d5:	89 f9                	mov    %edi,%ecx
  8020d7:	89 c5                	mov    %eax,%ebp
  8020d9:	29 fb                	sub    %edi,%ebx
  8020db:	d3 e6                	shl    %cl,%esi
  8020dd:	89 d9                	mov    %ebx,%ecx
  8020df:	d3 ed                	shr    %cl,%ebp
  8020e1:	89 f9                	mov    %edi,%ecx
  8020e3:	d3 e0                	shl    %cl,%eax
  8020e5:	09 ee                	or     %ebp,%esi
  8020e7:	89 d9                	mov    %ebx,%ecx
  8020e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020ed:	89 d5                	mov    %edx,%ebp
  8020ef:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020f3:	d3 ed                	shr    %cl,%ebp
  8020f5:	89 f9                	mov    %edi,%ecx
  8020f7:	d3 e2                	shl    %cl,%edx
  8020f9:	89 d9                	mov    %ebx,%ecx
  8020fb:	d3 e8                	shr    %cl,%eax
  8020fd:	09 c2                	or     %eax,%edx
  8020ff:	89 d0                	mov    %edx,%eax
  802101:	89 ea                	mov    %ebp,%edx
  802103:	f7 f6                	div    %esi
  802105:	89 d5                	mov    %edx,%ebp
  802107:	89 c3                	mov    %eax,%ebx
  802109:	f7 64 24 0c          	mull   0xc(%esp)
  80210d:	39 d5                	cmp    %edx,%ebp
  80210f:	72 10                	jb     802121 <__udivdi3+0xc1>
  802111:	8b 74 24 08          	mov    0x8(%esp),%esi
  802115:	89 f9                	mov    %edi,%ecx
  802117:	d3 e6                	shl    %cl,%esi
  802119:	39 c6                	cmp    %eax,%esi
  80211b:	73 07                	jae    802124 <__udivdi3+0xc4>
  80211d:	39 d5                	cmp    %edx,%ebp
  80211f:	75 03                	jne    802124 <__udivdi3+0xc4>
  802121:	83 eb 01             	sub    $0x1,%ebx
  802124:	31 ff                	xor    %edi,%edi
  802126:	89 d8                	mov    %ebx,%eax
  802128:	89 fa                	mov    %edi,%edx
  80212a:	83 c4 1c             	add    $0x1c,%esp
  80212d:	5b                   	pop    %ebx
  80212e:	5e                   	pop    %esi
  80212f:	5f                   	pop    %edi
  802130:	5d                   	pop    %ebp
  802131:	c3                   	ret    
  802132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802138:	31 ff                	xor    %edi,%edi
  80213a:	31 db                	xor    %ebx,%ebx
  80213c:	89 d8                	mov    %ebx,%eax
  80213e:	89 fa                	mov    %edi,%edx
  802140:	83 c4 1c             	add    $0x1c,%esp
  802143:	5b                   	pop    %ebx
  802144:	5e                   	pop    %esi
  802145:	5f                   	pop    %edi
  802146:	5d                   	pop    %ebp
  802147:	c3                   	ret    
  802148:	90                   	nop
  802149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802150:	89 d8                	mov    %ebx,%eax
  802152:	f7 f7                	div    %edi
  802154:	31 ff                	xor    %edi,%edi
  802156:	89 c3                	mov    %eax,%ebx
  802158:	89 d8                	mov    %ebx,%eax
  80215a:	89 fa                	mov    %edi,%edx
  80215c:	83 c4 1c             	add    $0x1c,%esp
  80215f:	5b                   	pop    %ebx
  802160:	5e                   	pop    %esi
  802161:	5f                   	pop    %edi
  802162:	5d                   	pop    %ebp
  802163:	c3                   	ret    
  802164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802168:	39 ce                	cmp    %ecx,%esi
  80216a:	72 0c                	jb     802178 <__udivdi3+0x118>
  80216c:	31 db                	xor    %ebx,%ebx
  80216e:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802172:	0f 87 34 ff ff ff    	ja     8020ac <__udivdi3+0x4c>
  802178:	bb 01 00 00 00       	mov    $0x1,%ebx
  80217d:	e9 2a ff ff ff       	jmp    8020ac <__udivdi3+0x4c>
  802182:	66 90                	xchg   %ax,%ax
  802184:	66 90                	xchg   %ax,%ax
  802186:	66 90                	xchg   %ax,%ax
  802188:	66 90                	xchg   %ax,%ax
  80218a:	66 90                	xchg   %ax,%ax
  80218c:	66 90                	xchg   %ax,%ax
  80218e:	66 90                	xchg   %ax,%ax

00802190 <__umoddi3>:
  802190:	55                   	push   %ebp
  802191:	57                   	push   %edi
  802192:	56                   	push   %esi
  802193:	53                   	push   %ebx
  802194:	83 ec 1c             	sub    $0x1c,%esp
  802197:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80219b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80219f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021a7:	85 d2                	test   %edx,%edx
  8021a9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8021ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021b1:	89 f3                	mov    %esi,%ebx
  8021b3:	89 3c 24             	mov    %edi,(%esp)
  8021b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021ba:	75 1c                	jne    8021d8 <__umoddi3+0x48>
  8021bc:	39 f7                	cmp    %esi,%edi
  8021be:	76 50                	jbe    802210 <__umoddi3+0x80>
  8021c0:	89 c8                	mov    %ecx,%eax
  8021c2:	89 f2                	mov    %esi,%edx
  8021c4:	f7 f7                	div    %edi
  8021c6:	89 d0                	mov    %edx,%eax
  8021c8:	31 d2                	xor    %edx,%edx
  8021ca:	83 c4 1c             	add    $0x1c,%esp
  8021cd:	5b                   	pop    %ebx
  8021ce:	5e                   	pop    %esi
  8021cf:	5f                   	pop    %edi
  8021d0:	5d                   	pop    %ebp
  8021d1:	c3                   	ret    
  8021d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021d8:	39 f2                	cmp    %esi,%edx
  8021da:	89 d0                	mov    %edx,%eax
  8021dc:	77 52                	ja     802230 <__umoddi3+0xa0>
  8021de:	0f bd ea             	bsr    %edx,%ebp
  8021e1:	83 f5 1f             	xor    $0x1f,%ebp
  8021e4:	75 5a                	jne    802240 <__umoddi3+0xb0>
  8021e6:	3b 54 24 04          	cmp    0x4(%esp),%edx
  8021ea:	0f 82 e0 00 00 00    	jb     8022d0 <__umoddi3+0x140>
  8021f0:	39 0c 24             	cmp    %ecx,(%esp)
  8021f3:	0f 86 d7 00 00 00    	jbe    8022d0 <__umoddi3+0x140>
  8021f9:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021fd:	8b 54 24 04          	mov    0x4(%esp),%edx
  802201:	83 c4 1c             	add    $0x1c,%esp
  802204:	5b                   	pop    %ebx
  802205:	5e                   	pop    %esi
  802206:	5f                   	pop    %edi
  802207:	5d                   	pop    %ebp
  802208:	c3                   	ret    
  802209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802210:	85 ff                	test   %edi,%edi
  802212:	89 fd                	mov    %edi,%ebp
  802214:	75 0b                	jne    802221 <__umoddi3+0x91>
  802216:	b8 01 00 00 00       	mov    $0x1,%eax
  80221b:	31 d2                	xor    %edx,%edx
  80221d:	f7 f7                	div    %edi
  80221f:	89 c5                	mov    %eax,%ebp
  802221:	89 f0                	mov    %esi,%eax
  802223:	31 d2                	xor    %edx,%edx
  802225:	f7 f5                	div    %ebp
  802227:	89 c8                	mov    %ecx,%eax
  802229:	f7 f5                	div    %ebp
  80222b:	89 d0                	mov    %edx,%eax
  80222d:	eb 99                	jmp    8021c8 <__umoddi3+0x38>
  80222f:	90                   	nop
  802230:	89 c8                	mov    %ecx,%eax
  802232:	89 f2                	mov    %esi,%edx
  802234:	83 c4 1c             	add    $0x1c,%esp
  802237:	5b                   	pop    %ebx
  802238:	5e                   	pop    %esi
  802239:	5f                   	pop    %edi
  80223a:	5d                   	pop    %ebp
  80223b:	c3                   	ret    
  80223c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802240:	8b 34 24             	mov    (%esp),%esi
  802243:	bf 20 00 00 00       	mov    $0x20,%edi
  802248:	89 e9                	mov    %ebp,%ecx
  80224a:	29 ef                	sub    %ebp,%edi
  80224c:	d3 e0                	shl    %cl,%eax
  80224e:	89 f9                	mov    %edi,%ecx
  802250:	89 f2                	mov    %esi,%edx
  802252:	d3 ea                	shr    %cl,%edx
  802254:	89 e9                	mov    %ebp,%ecx
  802256:	09 c2                	or     %eax,%edx
  802258:	89 d8                	mov    %ebx,%eax
  80225a:	89 14 24             	mov    %edx,(%esp)
  80225d:	89 f2                	mov    %esi,%edx
  80225f:	d3 e2                	shl    %cl,%edx
  802261:	89 f9                	mov    %edi,%ecx
  802263:	89 54 24 04          	mov    %edx,0x4(%esp)
  802267:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80226b:	d3 e8                	shr    %cl,%eax
  80226d:	89 e9                	mov    %ebp,%ecx
  80226f:	89 c6                	mov    %eax,%esi
  802271:	d3 e3                	shl    %cl,%ebx
  802273:	89 f9                	mov    %edi,%ecx
  802275:	89 d0                	mov    %edx,%eax
  802277:	d3 e8                	shr    %cl,%eax
  802279:	89 e9                	mov    %ebp,%ecx
  80227b:	09 d8                	or     %ebx,%eax
  80227d:	89 d3                	mov    %edx,%ebx
  80227f:	89 f2                	mov    %esi,%edx
  802281:	f7 34 24             	divl   (%esp)
  802284:	89 d6                	mov    %edx,%esi
  802286:	d3 e3                	shl    %cl,%ebx
  802288:	f7 64 24 04          	mull   0x4(%esp)
  80228c:	39 d6                	cmp    %edx,%esi
  80228e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802292:	89 d1                	mov    %edx,%ecx
  802294:	89 c3                	mov    %eax,%ebx
  802296:	72 08                	jb     8022a0 <__umoddi3+0x110>
  802298:	75 11                	jne    8022ab <__umoddi3+0x11b>
  80229a:	39 44 24 08          	cmp    %eax,0x8(%esp)
  80229e:	73 0b                	jae    8022ab <__umoddi3+0x11b>
  8022a0:	2b 44 24 04          	sub    0x4(%esp),%eax
  8022a4:	1b 14 24             	sbb    (%esp),%edx
  8022a7:	89 d1                	mov    %edx,%ecx
  8022a9:	89 c3                	mov    %eax,%ebx
  8022ab:	8b 54 24 08          	mov    0x8(%esp),%edx
  8022af:	29 da                	sub    %ebx,%edx
  8022b1:	19 ce                	sbb    %ecx,%esi
  8022b3:	89 f9                	mov    %edi,%ecx
  8022b5:	89 f0                	mov    %esi,%eax
  8022b7:	d3 e0                	shl    %cl,%eax
  8022b9:	89 e9                	mov    %ebp,%ecx
  8022bb:	d3 ea                	shr    %cl,%edx
  8022bd:	89 e9                	mov    %ebp,%ecx
  8022bf:	d3 ee                	shr    %cl,%esi
  8022c1:	09 d0                	or     %edx,%eax
  8022c3:	89 f2                	mov    %esi,%edx
  8022c5:	83 c4 1c             	add    $0x1c,%esp
  8022c8:	5b                   	pop    %ebx
  8022c9:	5e                   	pop    %esi
  8022ca:	5f                   	pop    %edi
  8022cb:	5d                   	pop    %ebp
  8022cc:	c3                   	ret    
  8022cd:	8d 76 00             	lea    0x0(%esi),%esi
  8022d0:	29 f9                	sub    %edi,%ecx
  8022d2:	19 d6                	sbb    %edx,%esi
  8022d4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022d8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022dc:	e9 18 ff ff ff       	jmp    8021f9 <__umoddi3+0x69>
