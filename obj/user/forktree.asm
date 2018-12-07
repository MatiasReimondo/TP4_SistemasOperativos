
obj/user/forktree.debug:     formato del fichero elf32-i386


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
  80002c:	e8 b0 00 00 00       	call   8000e1 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <forktree>:
	}
}

void
forktree(const char *cur)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
  80003a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  80003d:	e8 06 0b 00 00       	call   800b48 <sys_getenvid>
  800042:	83 ec 04             	sub    $0x4,%esp
  800045:	53                   	push   %ebx
  800046:	50                   	push   %eax
  800047:	68 20 23 80 00       	push   $0x802320
  80004c:	e8 87 01 00 00       	call   8001d8 <cprintf>

	forkchild(cur, '0');
  800051:	83 c4 08             	add    $0x8,%esp
  800054:	6a 30                	push   $0x30
  800056:	53                   	push   %ebx
  800057:	e8 13 00 00 00       	call   80006f <forkchild>
	forkchild(cur, '1');
  80005c:	83 c4 08             	add    $0x8,%esp
  80005f:	6a 31                	push   $0x31
  800061:	53                   	push   %ebx
  800062:	e8 08 00 00 00       	call   80006f <forkchild>
}
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80006d:	c9                   	leave  
  80006e:	c3                   	ret    

0080006f <forkchild>:

void forktree(const char *cur);

void
forkchild(const char *cur, char branch)
{
  80006f:	55                   	push   %ebp
  800070:	89 e5                	mov    %esp,%ebp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	83 ec 1c             	sub    $0x1c,%esp
  800077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80007a:	8b 75 0c             	mov    0xc(%ebp),%esi
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
  80007d:	53                   	push   %ebx
  80007e:	e8 8e 06 00 00       	call   800711 <strlen>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	83 f8 02             	cmp    $0x2,%eax
  800089:	7f 3a                	jg     8000c5 <forkchild+0x56>
		return;

	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	89 f0                	mov    %esi,%eax
  800090:	0f be f0             	movsbl %al,%esi
  800093:	56                   	push   %esi
  800094:	53                   	push   %ebx
  800095:	68 31 23 80 00       	push   $0x802331
  80009a:	6a 04                	push   $0x4
  80009c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	e8 52 06 00 00       	call   8006f7 <snprintf>
	if (fork() == 0) {
  8000a5:	83 c4 20             	add    $0x20,%esp
  8000a8:	e8 8d 0f 00 00       	call   80103a <fork>
  8000ad:	85 c0                	test   %eax,%eax
  8000af:	75 14                	jne    8000c5 <forkchild+0x56>
		forktree(nxt);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000b7:	50                   	push   %eax
  8000b8:	e8 76 ff ff ff       	call   800033 <forktree>
		exit();
  8000bd:	e8 69 00 00 00       	call   80012b <exit>
  8000c2:	83 c4 10             	add    $0x10,%esp
	}
}
  8000c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c8:	5b                   	pop    %ebx
  8000c9:	5e                   	pop    %esi
  8000ca:	5d                   	pop    %ebp
  8000cb:	c3                   	ret    

008000cc <umain>:
	forkchild(cur, '1');
}

void
umain(int argc, char **argv)
{
  8000cc:	55                   	push   %ebp
  8000cd:	89 e5                	mov    %esp,%ebp
  8000cf:	83 ec 14             	sub    $0x14,%esp
	forktree("");
  8000d2:	68 30 23 80 00       	push   $0x802330
  8000d7:	e8 57 ff ff ff       	call   800033 <forktree>
}
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	c9                   	leave  
  8000e0:	c3                   	ret    

008000e1 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e1:	55                   	push   %ebp
  8000e2:	89 e5                	mov    %esp,%ebp
  8000e4:	56                   	push   %esi
  8000e5:	53                   	push   %ebx
  8000e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000e9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8000ec:	e8 57 0a 00 00       	call   800b48 <sys_getenvid>
	if (id >= 0)
  8000f1:	85 c0                	test   %eax,%eax
  8000f3:	78 12                	js     800107 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  8000f5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000fa:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000fd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800102:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800107:	85 db                	test   %ebx,%ebx
  800109:	7e 07                	jle    800112 <libmain+0x31>
		binaryname = argv[0];
  80010b:	8b 06                	mov    (%esi),%eax
  80010d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800112:	83 ec 08             	sub    $0x8,%esp
  800115:	56                   	push   %esi
  800116:	53                   	push   %ebx
  800117:	e8 b0 ff ff ff       	call   8000cc <umain>

	// exit gracefully
	exit();
  80011c:	e8 0a 00 00 00       	call   80012b <exit>
}
  800121:	83 c4 10             	add    $0x10,%esp
  800124:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800127:	5b                   	pop    %ebx
  800128:	5e                   	pop    %esi
  800129:	5d                   	pop    %ebp
  80012a:	c3                   	ret    

0080012b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012b:	55                   	push   %ebp
  80012c:	89 e5                	mov    %esp,%ebp
  80012e:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800131:	e8 fc 11 00 00       	call   801332 <close_all>
	sys_env_destroy(0);
  800136:	83 ec 0c             	sub    $0xc,%esp
  800139:	6a 00                	push   $0x0
  80013b:	e8 e6 09 00 00       	call   800b26 <sys_env_destroy>
}
  800140:	83 c4 10             	add    $0x10,%esp
  800143:	c9                   	leave  
  800144:	c3                   	ret    

00800145 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800145:	55                   	push   %ebp
  800146:	89 e5                	mov    %esp,%ebp
  800148:	53                   	push   %ebx
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80014f:	8b 13                	mov    (%ebx),%edx
  800151:	8d 42 01             	lea    0x1(%edx),%eax
  800154:	89 03                	mov    %eax,(%ebx)
  800156:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800159:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80015d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800162:	75 1a                	jne    80017e <putch+0x39>
		sys_cputs(b->buf, b->idx);
  800164:	83 ec 08             	sub    $0x8,%esp
  800167:	68 ff 00 00 00       	push   $0xff
  80016c:	8d 43 08             	lea    0x8(%ebx),%eax
  80016f:	50                   	push   %eax
  800170:	e8 67 09 00 00       	call   800adc <sys_cputs>
		b->idx = 0;
  800175:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80017b:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  80017e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800182:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800185:	c9                   	leave  
  800186:	c3                   	ret    

00800187 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800187:	55                   	push   %ebp
  800188:	89 e5                	mov    %esp,%ebp
  80018a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800190:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800197:	00 00 00 
	b.cnt = 0;
  80019a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001a1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001a4:	ff 75 0c             	pushl  0xc(%ebp)
  8001a7:	ff 75 08             	pushl  0x8(%ebp)
  8001aa:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001b0:	50                   	push   %eax
  8001b1:	68 45 01 80 00       	push   $0x800145
  8001b6:	e8 86 01 00 00       	call   800341 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001bb:	83 c4 08             	add    $0x8,%esp
  8001be:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001c4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001ca:	50                   	push   %eax
  8001cb:	e8 0c 09 00 00       	call   800adc <sys_cputs>

	return b.cnt;
}
  8001d0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001d6:	c9                   	leave  
  8001d7:	c3                   	ret    

008001d8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001d8:	55                   	push   %ebp
  8001d9:	89 e5                	mov    %esp,%ebp
  8001db:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001de:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001e1:	50                   	push   %eax
  8001e2:	ff 75 08             	pushl  0x8(%ebp)
  8001e5:	e8 9d ff ff ff       	call   800187 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ea:	c9                   	leave  
  8001eb:	c3                   	ret    

008001ec <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	57                   	push   %edi
  8001f0:	56                   	push   %esi
  8001f1:	53                   	push   %ebx
  8001f2:	83 ec 1c             	sub    $0x1c,%esp
  8001f5:	89 c7                	mov    %eax,%edi
  8001f7:	89 d6                	mov    %edx,%esi
  8001f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800202:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800205:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800208:	bb 00 00 00 00       	mov    $0x0,%ebx
  80020d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800210:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800213:	39 d3                	cmp    %edx,%ebx
  800215:	72 05                	jb     80021c <printnum+0x30>
  800217:	39 45 10             	cmp    %eax,0x10(%ebp)
  80021a:	77 45                	ja     800261 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80021c:	83 ec 0c             	sub    $0xc,%esp
  80021f:	ff 75 18             	pushl  0x18(%ebp)
  800222:	8b 45 14             	mov    0x14(%ebp),%eax
  800225:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800228:	53                   	push   %ebx
  800229:	ff 75 10             	pushl  0x10(%ebp)
  80022c:	83 ec 08             	sub    $0x8,%esp
  80022f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800232:	ff 75 e0             	pushl  -0x20(%ebp)
  800235:	ff 75 dc             	pushl  -0x24(%ebp)
  800238:	ff 75 d8             	pushl  -0x28(%ebp)
  80023b:	e8 40 1e 00 00       	call   802080 <__udivdi3>
  800240:	83 c4 18             	add    $0x18,%esp
  800243:	52                   	push   %edx
  800244:	50                   	push   %eax
  800245:	89 f2                	mov    %esi,%edx
  800247:	89 f8                	mov    %edi,%eax
  800249:	e8 9e ff ff ff       	call   8001ec <printnum>
  80024e:	83 c4 20             	add    $0x20,%esp
  800251:	eb 18                	jmp    80026b <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800253:	83 ec 08             	sub    $0x8,%esp
  800256:	56                   	push   %esi
  800257:	ff 75 18             	pushl  0x18(%ebp)
  80025a:	ff d7                	call   *%edi
  80025c:	83 c4 10             	add    $0x10,%esp
  80025f:	eb 03                	jmp    800264 <printnum+0x78>
  800261:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800264:	83 eb 01             	sub    $0x1,%ebx
  800267:	85 db                	test   %ebx,%ebx
  800269:	7f e8                	jg     800253 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	56                   	push   %esi
  80026f:	83 ec 04             	sub    $0x4,%esp
  800272:	ff 75 e4             	pushl  -0x1c(%ebp)
  800275:	ff 75 e0             	pushl  -0x20(%ebp)
  800278:	ff 75 dc             	pushl  -0x24(%ebp)
  80027b:	ff 75 d8             	pushl  -0x28(%ebp)
  80027e:	e8 2d 1f 00 00       	call   8021b0 <__umoddi3>
  800283:	83 c4 14             	add    $0x14,%esp
  800286:	0f be 80 40 23 80 00 	movsbl 0x802340(%eax),%eax
  80028d:	50                   	push   %eax
  80028e:	ff d7                	call   *%edi
}
  800290:	83 c4 10             	add    $0x10,%esp
  800293:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800296:	5b                   	pop    %ebx
  800297:	5e                   	pop    %esi
  800298:	5f                   	pop    %edi
  800299:	5d                   	pop    %ebp
  80029a:	c3                   	ret    

0080029b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80029b:	55                   	push   %ebp
  80029c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80029e:	83 fa 01             	cmp    $0x1,%edx
  8002a1:	7e 0e                	jle    8002b1 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002a3:	8b 10                	mov    (%eax),%edx
  8002a5:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002a8:	89 08                	mov    %ecx,(%eax)
  8002aa:	8b 02                	mov    (%edx),%eax
  8002ac:	8b 52 04             	mov    0x4(%edx),%edx
  8002af:	eb 22                	jmp    8002d3 <getuint+0x38>
	else if (lflag)
  8002b1:	85 d2                	test   %edx,%edx
  8002b3:	74 10                	je     8002c5 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002b5:	8b 10                	mov    (%eax),%edx
  8002b7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002ba:	89 08                	mov    %ecx,(%eax)
  8002bc:	8b 02                	mov    (%edx),%eax
  8002be:	ba 00 00 00 00       	mov    $0x0,%edx
  8002c3:	eb 0e                	jmp    8002d3 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002c5:	8b 10                	mov    (%eax),%edx
  8002c7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002ca:	89 08                	mov    %ecx,(%eax)
  8002cc:	8b 02                	mov    (%edx),%eax
  8002ce:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002d3:	5d                   	pop    %ebp
  8002d4:	c3                   	ret    

008002d5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8002d5:	55                   	push   %ebp
  8002d6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002d8:	83 fa 01             	cmp    $0x1,%edx
  8002db:	7e 0e                	jle    8002eb <getint+0x16>
		return va_arg(*ap, long long);
  8002dd:	8b 10                	mov    (%eax),%edx
  8002df:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002e2:	89 08                	mov    %ecx,(%eax)
  8002e4:	8b 02                	mov    (%edx),%eax
  8002e6:	8b 52 04             	mov    0x4(%edx),%edx
  8002e9:	eb 1a                	jmp    800305 <getint+0x30>
	else if (lflag)
  8002eb:	85 d2                	test   %edx,%edx
  8002ed:	74 0c                	je     8002fb <getint+0x26>
		return va_arg(*ap, long);
  8002ef:	8b 10                	mov    (%eax),%edx
  8002f1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002f4:	89 08                	mov    %ecx,(%eax)
  8002f6:	8b 02                	mov    (%edx),%eax
  8002f8:	99                   	cltd   
  8002f9:	eb 0a                	jmp    800305 <getint+0x30>
	else
		return va_arg(*ap, int);
  8002fb:	8b 10                	mov    (%eax),%edx
  8002fd:	8d 4a 04             	lea    0x4(%edx),%ecx
  800300:	89 08                	mov    %ecx,(%eax)
  800302:	8b 02                	mov    (%edx),%eax
  800304:	99                   	cltd   
}
  800305:	5d                   	pop    %ebp
  800306:	c3                   	ret    

00800307 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80030d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800311:	8b 10                	mov    (%eax),%edx
  800313:	3b 50 04             	cmp    0x4(%eax),%edx
  800316:	73 0a                	jae    800322 <sprintputch+0x1b>
		*b->buf++ = ch;
  800318:	8d 4a 01             	lea    0x1(%edx),%ecx
  80031b:	89 08                	mov    %ecx,(%eax)
  80031d:	8b 45 08             	mov    0x8(%ebp),%eax
  800320:	88 02                	mov    %al,(%edx)
}
  800322:	5d                   	pop    %ebp
  800323:	c3                   	ret    

00800324 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800324:	55                   	push   %ebp
  800325:	89 e5                	mov    %esp,%ebp
  800327:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  80032a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80032d:	50                   	push   %eax
  80032e:	ff 75 10             	pushl  0x10(%ebp)
  800331:	ff 75 0c             	pushl  0xc(%ebp)
  800334:	ff 75 08             	pushl  0x8(%ebp)
  800337:	e8 05 00 00 00       	call   800341 <vprintfmt>
	va_end(ap);
}
  80033c:	83 c4 10             	add    $0x10,%esp
  80033f:	c9                   	leave  
  800340:	c3                   	ret    

00800341 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800341:	55                   	push   %ebp
  800342:	89 e5                	mov    %esp,%ebp
  800344:	57                   	push   %edi
  800345:	56                   	push   %esi
  800346:	53                   	push   %ebx
  800347:	83 ec 2c             	sub    $0x2c,%esp
  80034a:	8b 75 08             	mov    0x8(%ebp),%esi
  80034d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800350:	8b 7d 10             	mov    0x10(%ebp),%edi
  800353:	eb 12                	jmp    800367 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800355:	85 c0                	test   %eax,%eax
  800357:	0f 84 44 03 00 00    	je     8006a1 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  80035d:	83 ec 08             	sub    $0x8,%esp
  800360:	53                   	push   %ebx
  800361:	50                   	push   %eax
  800362:	ff d6                	call   *%esi
  800364:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800367:	83 c7 01             	add    $0x1,%edi
  80036a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80036e:	83 f8 25             	cmp    $0x25,%eax
  800371:	75 e2                	jne    800355 <vprintfmt+0x14>
  800373:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800377:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80037e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800385:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80038c:	ba 00 00 00 00       	mov    $0x0,%edx
  800391:	eb 07                	jmp    80039a <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800393:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800396:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80039a:	8d 47 01             	lea    0x1(%edi),%eax
  80039d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003a0:	0f b6 07             	movzbl (%edi),%eax
  8003a3:	0f b6 c8             	movzbl %al,%ecx
  8003a6:	83 e8 23             	sub    $0x23,%eax
  8003a9:	3c 55                	cmp    $0x55,%al
  8003ab:	0f 87 d5 02 00 00    	ja     800686 <vprintfmt+0x345>
  8003b1:	0f b6 c0             	movzbl %al,%eax
  8003b4:	ff 24 85 80 24 80 00 	jmp    *0x802480(,%eax,4)
  8003bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003be:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003c2:	eb d6                	jmp    80039a <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003cc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003cf:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003d2:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8003d6:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8003d9:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8003dc:	83 fa 09             	cmp    $0x9,%edx
  8003df:	77 39                	ja     80041a <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003e1:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003e4:	eb e9                	jmp    8003cf <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e9:	8d 48 04             	lea    0x4(%eax),%ecx
  8003ec:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8003ef:	8b 00                	mov    (%eax),%eax
  8003f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003f7:	eb 27                	jmp    800420 <vprintfmt+0xdf>
  8003f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003fc:	85 c0                	test   %eax,%eax
  8003fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800403:	0f 49 c8             	cmovns %eax,%ecx
  800406:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800409:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80040c:	eb 8c                	jmp    80039a <vprintfmt+0x59>
  80040e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800411:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800418:	eb 80                	jmp    80039a <vprintfmt+0x59>
  80041a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80041d:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  800420:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800424:	0f 89 70 ff ff ff    	jns    80039a <vprintfmt+0x59>
				width = precision, precision = -1;
  80042a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80042d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800430:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800437:	e9 5e ff ff ff       	jmp    80039a <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80043c:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80043f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800442:	e9 53 ff ff ff       	jmp    80039a <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800447:	8b 45 14             	mov    0x14(%ebp),%eax
  80044a:	8d 50 04             	lea    0x4(%eax),%edx
  80044d:	89 55 14             	mov    %edx,0x14(%ebp)
  800450:	83 ec 08             	sub    $0x8,%esp
  800453:	53                   	push   %ebx
  800454:	ff 30                	pushl  (%eax)
  800456:	ff d6                	call   *%esi
			break;
  800458:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80045b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  80045e:	e9 04 ff ff ff       	jmp    800367 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800463:	8b 45 14             	mov    0x14(%ebp),%eax
  800466:	8d 50 04             	lea    0x4(%eax),%edx
  800469:	89 55 14             	mov    %edx,0x14(%ebp)
  80046c:	8b 00                	mov    (%eax),%eax
  80046e:	99                   	cltd   
  80046f:	31 d0                	xor    %edx,%eax
  800471:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800473:	83 f8 0f             	cmp    $0xf,%eax
  800476:	7f 0b                	jg     800483 <vprintfmt+0x142>
  800478:	8b 14 85 e0 25 80 00 	mov    0x8025e0(,%eax,4),%edx
  80047f:	85 d2                	test   %edx,%edx
  800481:	75 18                	jne    80049b <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  800483:	50                   	push   %eax
  800484:	68 58 23 80 00       	push   $0x802358
  800489:	53                   	push   %ebx
  80048a:	56                   	push   %esi
  80048b:	e8 94 fe ff ff       	call   800324 <printfmt>
  800490:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800493:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800496:	e9 cc fe ff ff       	jmp    800367 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  80049b:	52                   	push   %edx
  80049c:	68 75 28 80 00       	push   $0x802875
  8004a1:	53                   	push   %ebx
  8004a2:	56                   	push   %esi
  8004a3:	e8 7c fe ff ff       	call   800324 <printfmt>
  8004a8:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ae:	e9 b4 fe ff ff       	jmp    800367 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b6:	8d 50 04             	lea    0x4(%eax),%edx
  8004b9:	89 55 14             	mov    %edx,0x14(%ebp)
  8004bc:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004be:	85 ff                	test   %edi,%edi
  8004c0:	b8 51 23 80 00       	mov    $0x802351,%eax
  8004c5:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004c8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004cc:	0f 8e 94 00 00 00    	jle    800566 <vprintfmt+0x225>
  8004d2:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004d6:	0f 84 98 00 00 00    	je     800574 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004dc:	83 ec 08             	sub    $0x8,%esp
  8004df:	ff 75 d0             	pushl  -0x30(%ebp)
  8004e2:	57                   	push   %edi
  8004e3:	e8 41 02 00 00       	call   800729 <strnlen>
  8004e8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004eb:	29 c1                	sub    %eax,%ecx
  8004ed:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8004f0:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004f3:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004fa:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004fd:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ff:	eb 0f                	jmp    800510 <vprintfmt+0x1cf>
					putch(padc, putdat);
  800501:	83 ec 08             	sub    $0x8,%esp
  800504:	53                   	push   %ebx
  800505:	ff 75 e0             	pushl  -0x20(%ebp)
  800508:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80050a:	83 ef 01             	sub    $0x1,%edi
  80050d:	83 c4 10             	add    $0x10,%esp
  800510:	85 ff                	test   %edi,%edi
  800512:	7f ed                	jg     800501 <vprintfmt+0x1c0>
  800514:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800517:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  80051a:	85 c9                	test   %ecx,%ecx
  80051c:	b8 00 00 00 00       	mov    $0x0,%eax
  800521:	0f 49 c1             	cmovns %ecx,%eax
  800524:	29 c1                	sub    %eax,%ecx
  800526:	89 75 08             	mov    %esi,0x8(%ebp)
  800529:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80052c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80052f:	89 cb                	mov    %ecx,%ebx
  800531:	eb 4d                	jmp    800580 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800533:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800537:	74 1b                	je     800554 <vprintfmt+0x213>
  800539:	0f be c0             	movsbl %al,%eax
  80053c:	83 e8 20             	sub    $0x20,%eax
  80053f:	83 f8 5e             	cmp    $0x5e,%eax
  800542:	76 10                	jbe    800554 <vprintfmt+0x213>
					putch('?', putdat);
  800544:	83 ec 08             	sub    $0x8,%esp
  800547:	ff 75 0c             	pushl  0xc(%ebp)
  80054a:	6a 3f                	push   $0x3f
  80054c:	ff 55 08             	call   *0x8(%ebp)
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	eb 0d                	jmp    800561 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  800554:	83 ec 08             	sub    $0x8,%esp
  800557:	ff 75 0c             	pushl  0xc(%ebp)
  80055a:	52                   	push   %edx
  80055b:	ff 55 08             	call   *0x8(%ebp)
  80055e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800561:	83 eb 01             	sub    $0x1,%ebx
  800564:	eb 1a                	jmp    800580 <vprintfmt+0x23f>
  800566:	89 75 08             	mov    %esi,0x8(%ebp)
  800569:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80056c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80056f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800572:	eb 0c                	jmp    800580 <vprintfmt+0x23f>
  800574:	89 75 08             	mov    %esi,0x8(%ebp)
  800577:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80057a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80057d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800580:	83 c7 01             	add    $0x1,%edi
  800583:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800587:	0f be d0             	movsbl %al,%edx
  80058a:	85 d2                	test   %edx,%edx
  80058c:	74 23                	je     8005b1 <vprintfmt+0x270>
  80058e:	85 f6                	test   %esi,%esi
  800590:	78 a1                	js     800533 <vprintfmt+0x1f2>
  800592:	83 ee 01             	sub    $0x1,%esi
  800595:	79 9c                	jns    800533 <vprintfmt+0x1f2>
  800597:	89 df                	mov    %ebx,%edi
  800599:	8b 75 08             	mov    0x8(%ebp),%esi
  80059c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80059f:	eb 18                	jmp    8005b9 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	53                   	push   %ebx
  8005a5:	6a 20                	push   $0x20
  8005a7:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005a9:	83 ef 01             	sub    $0x1,%edi
  8005ac:	83 c4 10             	add    $0x10,%esp
  8005af:	eb 08                	jmp    8005b9 <vprintfmt+0x278>
  8005b1:	89 df                	mov    %ebx,%edi
  8005b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8005b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005b9:	85 ff                	test   %edi,%edi
  8005bb:	7f e4                	jg     8005a1 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005c0:	e9 a2 fd ff ff       	jmp    800367 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005c5:	8d 45 14             	lea    0x14(%ebp),%eax
  8005c8:	e8 08 fd ff ff       	call   8002d5 <getint>
  8005cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8005d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8005d8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005dc:	79 74                	jns    800652 <vprintfmt+0x311>
				putch('-', putdat);
  8005de:	83 ec 08             	sub    $0x8,%esp
  8005e1:	53                   	push   %ebx
  8005e2:	6a 2d                	push   $0x2d
  8005e4:	ff d6                	call   *%esi
				num = -(long long) num;
  8005e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005e9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005ec:	f7 d8                	neg    %eax
  8005ee:	83 d2 00             	adc    $0x0,%edx
  8005f1:	f7 da                	neg    %edx
  8005f3:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8005f6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8005fb:	eb 55                	jmp    800652 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8005fd:	8d 45 14             	lea    0x14(%ebp),%eax
  800600:	e8 96 fc ff ff       	call   80029b <getuint>
			base = 10;
  800605:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80060a:	eb 46                	jmp    800652 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  80060c:	8d 45 14             	lea    0x14(%ebp),%eax
  80060f:	e8 87 fc ff ff       	call   80029b <getuint>
			base = 8;
  800614:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800619:	eb 37                	jmp    800652 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	53                   	push   %ebx
  80061f:	6a 30                	push   $0x30
  800621:	ff d6                	call   *%esi
			putch('x', putdat);
  800623:	83 c4 08             	add    $0x8,%esp
  800626:	53                   	push   %ebx
  800627:	6a 78                	push   $0x78
  800629:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80062b:	8b 45 14             	mov    0x14(%ebp),%eax
  80062e:	8d 50 04             	lea    0x4(%eax),%edx
  800631:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800634:	8b 00                	mov    (%eax),%eax
  800636:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  80063b:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80063e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800643:	eb 0d                	jmp    800652 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800645:	8d 45 14             	lea    0x14(%ebp),%eax
  800648:	e8 4e fc ff ff       	call   80029b <getuint>
			base = 16;
  80064d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800652:	83 ec 0c             	sub    $0xc,%esp
  800655:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800659:	57                   	push   %edi
  80065a:	ff 75 e0             	pushl  -0x20(%ebp)
  80065d:	51                   	push   %ecx
  80065e:	52                   	push   %edx
  80065f:	50                   	push   %eax
  800660:	89 da                	mov    %ebx,%edx
  800662:	89 f0                	mov    %esi,%eax
  800664:	e8 83 fb ff ff       	call   8001ec <printnum>
			break;
  800669:	83 c4 20             	add    $0x20,%esp
  80066c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80066f:	e9 f3 fc ff ff       	jmp    800367 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800674:	83 ec 08             	sub    $0x8,%esp
  800677:	53                   	push   %ebx
  800678:	51                   	push   %ecx
  800679:	ff d6                	call   *%esi
			break;
  80067b:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800681:	e9 e1 fc ff ff       	jmp    800367 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800686:	83 ec 08             	sub    $0x8,%esp
  800689:	53                   	push   %ebx
  80068a:	6a 25                	push   $0x25
  80068c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80068e:	83 c4 10             	add    $0x10,%esp
  800691:	eb 03                	jmp    800696 <vprintfmt+0x355>
  800693:	83 ef 01             	sub    $0x1,%edi
  800696:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  80069a:	75 f7                	jne    800693 <vprintfmt+0x352>
  80069c:	e9 c6 fc ff ff       	jmp    800367 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  8006a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006a4:	5b                   	pop    %ebx
  8006a5:	5e                   	pop    %esi
  8006a6:	5f                   	pop    %edi
  8006a7:	5d                   	pop    %ebp
  8006a8:	c3                   	ret    

008006a9 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006a9:	55                   	push   %ebp
  8006aa:	89 e5                	mov    %esp,%ebp
  8006ac:	83 ec 18             	sub    $0x18,%esp
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006b8:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006bc:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006c6:	85 c0                	test   %eax,%eax
  8006c8:	74 26                	je     8006f0 <vsnprintf+0x47>
  8006ca:	85 d2                	test   %edx,%edx
  8006cc:	7e 22                	jle    8006f0 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006ce:	ff 75 14             	pushl  0x14(%ebp)
  8006d1:	ff 75 10             	pushl  0x10(%ebp)
  8006d4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006d7:	50                   	push   %eax
  8006d8:	68 07 03 80 00       	push   $0x800307
  8006dd:	e8 5f fc ff ff       	call   800341 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006e5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006eb:	83 c4 10             	add    $0x10,%esp
  8006ee:	eb 05                	jmp    8006f5 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8006f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8006f5:	c9                   	leave  
  8006f6:	c3                   	ret    

008006f7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006f7:	55                   	push   %ebp
  8006f8:	89 e5                	mov    %esp,%ebp
  8006fa:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8006fd:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800700:	50                   	push   %eax
  800701:	ff 75 10             	pushl  0x10(%ebp)
  800704:	ff 75 0c             	pushl  0xc(%ebp)
  800707:	ff 75 08             	pushl  0x8(%ebp)
  80070a:	e8 9a ff ff ff       	call   8006a9 <vsnprintf>
	va_end(ap);

	return rc;
}
  80070f:	c9                   	leave  
  800710:	c3                   	ret    

00800711 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800711:	55                   	push   %ebp
  800712:	89 e5                	mov    %esp,%ebp
  800714:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800717:	b8 00 00 00 00       	mov    $0x0,%eax
  80071c:	eb 03                	jmp    800721 <strlen+0x10>
		n++;
  80071e:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800721:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800725:	75 f7                	jne    80071e <strlen+0xd>
		n++;
	return n;
}
  800727:	5d                   	pop    %ebp
  800728:	c3                   	ret    

00800729 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800729:	55                   	push   %ebp
  80072a:	89 e5                	mov    %esp,%ebp
  80072c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80072f:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800732:	ba 00 00 00 00       	mov    $0x0,%edx
  800737:	eb 03                	jmp    80073c <strnlen+0x13>
		n++;
  800739:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80073c:	39 c2                	cmp    %eax,%edx
  80073e:	74 08                	je     800748 <strnlen+0x1f>
  800740:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800744:	75 f3                	jne    800739 <strnlen+0x10>
  800746:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  800748:	5d                   	pop    %ebp
  800749:	c3                   	ret    

0080074a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80074a:	55                   	push   %ebp
  80074b:	89 e5                	mov    %esp,%ebp
  80074d:	53                   	push   %ebx
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800754:	89 c2                	mov    %eax,%edx
  800756:	83 c2 01             	add    $0x1,%edx
  800759:	83 c1 01             	add    $0x1,%ecx
  80075c:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800760:	88 5a ff             	mov    %bl,-0x1(%edx)
  800763:	84 db                	test   %bl,%bl
  800765:	75 ef                	jne    800756 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800767:	5b                   	pop    %ebx
  800768:	5d                   	pop    %ebp
  800769:	c3                   	ret    

0080076a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	53                   	push   %ebx
  80076e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800771:	53                   	push   %ebx
  800772:	e8 9a ff ff ff       	call   800711 <strlen>
  800777:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80077a:	ff 75 0c             	pushl  0xc(%ebp)
  80077d:	01 d8                	add    %ebx,%eax
  80077f:	50                   	push   %eax
  800780:	e8 c5 ff ff ff       	call   80074a <strcpy>
	return dst;
}
  800785:	89 d8                	mov    %ebx,%eax
  800787:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80078a:	c9                   	leave  
  80078b:	c3                   	ret    

0080078c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80078c:	55                   	push   %ebp
  80078d:	89 e5                	mov    %esp,%ebp
  80078f:	56                   	push   %esi
  800790:	53                   	push   %ebx
  800791:	8b 75 08             	mov    0x8(%ebp),%esi
  800794:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800797:	89 f3                	mov    %esi,%ebx
  800799:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80079c:	89 f2                	mov    %esi,%edx
  80079e:	eb 0f                	jmp    8007af <strncpy+0x23>
		*dst++ = *src;
  8007a0:	83 c2 01             	add    $0x1,%edx
  8007a3:	0f b6 01             	movzbl (%ecx),%eax
  8007a6:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007a9:	80 39 01             	cmpb   $0x1,(%ecx)
  8007ac:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007af:	39 da                	cmp    %ebx,%edx
  8007b1:	75 ed                	jne    8007a0 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8007b3:	89 f0                	mov    %esi,%eax
  8007b5:	5b                   	pop    %ebx
  8007b6:	5e                   	pop    %esi
  8007b7:	5d                   	pop    %ebp
  8007b8:	c3                   	ret    

008007b9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007b9:	55                   	push   %ebp
  8007ba:	89 e5                	mov    %esp,%ebp
  8007bc:	56                   	push   %esi
  8007bd:	53                   	push   %ebx
  8007be:	8b 75 08             	mov    0x8(%ebp),%esi
  8007c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007c4:	8b 55 10             	mov    0x10(%ebp),%edx
  8007c7:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007c9:	85 d2                	test   %edx,%edx
  8007cb:	74 21                	je     8007ee <strlcpy+0x35>
  8007cd:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8007d1:	89 f2                	mov    %esi,%edx
  8007d3:	eb 09                	jmp    8007de <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8007d5:	83 c2 01             	add    $0x1,%edx
  8007d8:	83 c1 01             	add    $0x1,%ecx
  8007db:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8007de:	39 c2                	cmp    %eax,%edx
  8007e0:	74 09                	je     8007eb <strlcpy+0x32>
  8007e2:	0f b6 19             	movzbl (%ecx),%ebx
  8007e5:	84 db                	test   %bl,%bl
  8007e7:	75 ec                	jne    8007d5 <strlcpy+0x1c>
  8007e9:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  8007eb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007ee:	29 f0                	sub    %esi,%eax
}
  8007f0:	5b                   	pop    %ebx
  8007f1:	5e                   	pop    %esi
  8007f2:	5d                   	pop    %ebp
  8007f3:	c3                   	ret    

008007f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007f4:	55                   	push   %ebp
  8007f5:	89 e5                	mov    %esp,%ebp
  8007f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007fa:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007fd:	eb 06                	jmp    800805 <strcmp+0x11>
		p++, q++;
  8007ff:	83 c1 01             	add    $0x1,%ecx
  800802:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800805:	0f b6 01             	movzbl (%ecx),%eax
  800808:	84 c0                	test   %al,%al
  80080a:	74 04                	je     800810 <strcmp+0x1c>
  80080c:	3a 02                	cmp    (%edx),%al
  80080e:	74 ef                	je     8007ff <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800810:	0f b6 c0             	movzbl %al,%eax
  800813:	0f b6 12             	movzbl (%edx),%edx
  800816:	29 d0                	sub    %edx,%eax
}
  800818:	5d                   	pop    %ebp
  800819:	c3                   	ret    

0080081a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	53                   	push   %ebx
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	8b 55 0c             	mov    0xc(%ebp),%edx
  800824:	89 c3                	mov    %eax,%ebx
  800826:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800829:	eb 06                	jmp    800831 <strncmp+0x17>
		n--, p++, q++;
  80082b:	83 c0 01             	add    $0x1,%eax
  80082e:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800831:	39 d8                	cmp    %ebx,%eax
  800833:	74 15                	je     80084a <strncmp+0x30>
  800835:	0f b6 08             	movzbl (%eax),%ecx
  800838:	84 c9                	test   %cl,%cl
  80083a:	74 04                	je     800840 <strncmp+0x26>
  80083c:	3a 0a                	cmp    (%edx),%cl
  80083e:	74 eb                	je     80082b <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800840:	0f b6 00             	movzbl (%eax),%eax
  800843:	0f b6 12             	movzbl (%edx),%edx
  800846:	29 d0                	sub    %edx,%eax
  800848:	eb 05                	jmp    80084f <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  80084a:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  80084f:	5b                   	pop    %ebx
  800850:	5d                   	pop    %ebp
  800851:	c3                   	ret    

00800852 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	8b 45 08             	mov    0x8(%ebp),%eax
  800858:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80085c:	eb 07                	jmp    800865 <strchr+0x13>
		if (*s == c)
  80085e:	38 ca                	cmp    %cl,%dl
  800860:	74 0f                	je     800871 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800862:	83 c0 01             	add    $0x1,%eax
  800865:	0f b6 10             	movzbl (%eax),%edx
  800868:	84 d2                	test   %dl,%dl
  80086a:	75 f2                	jne    80085e <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  80086c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800871:	5d                   	pop    %ebp
  800872:	c3                   	ret    

00800873 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800873:	55                   	push   %ebp
  800874:	89 e5                	mov    %esp,%ebp
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80087d:	eb 03                	jmp    800882 <strfind+0xf>
  80087f:	83 c0 01             	add    $0x1,%eax
  800882:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800885:	38 ca                	cmp    %cl,%dl
  800887:	74 04                	je     80088d <strfind+0x1a>
  800889:	84 d2                	test   %dl,%dl
  80088b:	75 f2                	jne    80087f <strfind+0xc>
			break;
	return (char *) s;
}
  80088d:	5d                   	pop    %ebp
  80088e:	c3                   	ret    

0080088f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
  800892:	57                   	push   %edi
  800893:	56                   	push   %esi
  800894:	53                   	push   %ebx
  800895:	8b 55 08             	mov    0x8(%ebp),%edx
  800898:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  80089b:	85 c9                	test   %ecx,%ecx
  80089d:	74 37                	je     8008d6 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80089f:	f6 c2 03             	test   $0x3,%dl
  8008a2:	75 2a                	jne    8008ce <memset+0x3f>
  8008a4:	f6 c1 03             	test   $0x3,%cl
  8008a7:	75 25                	jne    8008ce <memset+0x3f>
		c &= 0xFF;
  8008a9:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008ad:	89 df                	mov    %ebx,%edi
  8008af:	c1 e7 08             	shl    $0x8,%edi
  8008b2:	89 de                	mov    %ebx,%esi
  8008b4:	c1 e6 18             	shl    $0x18,%esi
  8008b7:	89 d8                	mov    %ebx,%eax
  8008b9:	c1 e0 10             	shl    $0x10,%eax
  8008bc:	09 f0                	or     %esi,%eax
  8008be:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8008c0:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8008c3:	89 f8                	mov    %edi,%eax
  8008c5:	09 d8                	or     %ebx,%eax
  8008c7:	89 d7                	mov    %edx,%edi
  8008c9:	fc                   	cld    
  8008ca:	f3 ab                	rep stos %eax,%es:(%edi)
  8008cc:	eb 08                	jmp    8008d6 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008ce:	89 d7                	mov    %edx,%edi
  8008d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d3:	fc                   	cld    
  8008d4:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8008d6:	89 d0                	mov    %edx,%eax
  8008d8:	5b                   	pop    %ebx
  8008d9:	5e                   	pop    %esi
  8008da:	5f                   	pop    %edi
  8008db:	5d                   	pop    %ebp
  8008dc:	c3                   	ret    

008008dd <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	57                   	push   %edi
  8008e1:	56                   	push   %esi
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008eb:	39 c6                	cmp    %eax,%esi
  8008ed:	73 35                	jae    800924 <memmove+0x47>
  8008ef:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008f2:	39 d0                	cmp    %edx,%eax
  8008f4:	73 2e                	jae    800924 <memmove+0x47>
		s += n;
		d += n;
  8008f6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008f9:	89 d6                	mov    %edx,%esi
  8008fb:	09 fe                	or     %edi,%esi
  8008fd:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800903:	75 13                	jne    800918 <memmove+0x3b>
  800905:	f6 c1 03             	test   $0x3,%cl
  800908:	75 0e                	jne    800918 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  80090a:	83 ef 04             	sub    $0x4,%edi
  80090d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800910:	c1 e9 02             	shr    $0x2,%ecx
  800913:	fd                   	std    
  800914:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800916:	eb 09                	jmp    800921 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800918:	83 ef 01             	sub    $0x1,%edi
  80091b:	8d 72 ff             	lea    -0x1(%edx),%esi
  80091e:	fd                   	std    
  80091f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800921:	fc                   	cld    
  800922:	eb 1d                	jmp    800941 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800924:	89 f2                	mov    %esi,%edx
  800926:	09 c2                	or     %eax,%edx
  800928:	f6 c2 03             	test   $0x3,%dl
  80092b:	75 0f                	jne    80093c <memmove+0x5f>
  80092d:	f6 c1 03             	test   $0x3,%cl
  800930:	75 0a                	jne    80093c <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  800932:	c1 e9 02             	shr    $0x2,%ecx
  800935:	89 c7                	mov    %eax,%edi
  800937:	fc                   	cld    
  800938:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80093a:	eb 05                	jmp    800941 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80093c:	89 c7                	mov    %eax,%edi
  80093e:	fc                   	cld    
  80093f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800941:	5e                   	pop    %esi
  800942:	5f                   	pop    %edi
  800943:	5d                   	pop    %ebp
  800944:	c3                   	ret    

00800945 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800948:	ff 75 10             	pushl  0x10(%ebp)
  80094b:	ff 75 0c             	pushl  0xc(%ebp)
  80094e:	ff 75 08             	pushl  0x8(%ebp)
  800951:	e8 87 ff ff ff       	call   8008dd <memmove>
}
  800956:	c9                   	leave  
  800957:	c3                   	ret    

00800958 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
  80095b:	56                   	push   %esi
  80095c:	53                   	push   %ebx
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	8b 55 0c             	mov    0xc(%ebp),%edx
  800963:	89 c6                	mov    %eax,%esi
  800965:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800968:	eb 1a                	jmp    800984 <memcmp+0x2c>
		if (*s1 != *s2)
  80096a:	0f b6 08             	movzbl (%eax),%ecx
  80096d:	0f b6 1a             	movzbl (%edx),%ebx
  800970:	38 d9                	cmp    %bl,%cl
  800972:	74 0a                	je     80097e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800974:	0f b6 c1             	movzbl %cl,%eax
  800977:	0f b6 db             	movzbl %bl,%ebx
  80097a:	29 d8                	sub    %ebx,%eax
  80097c:	eb 0f                	jmp    80098d <memcmp+0x35>
		s1++, s2++;
  80097e:	83 c0 01             	add    $0x1,%eax
  800981:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800984:	39 f0                	cmp    %esi,%eax
  800986:	75 e2                	jne    80096a <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800988:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80098d:	5b                   	pop    %ebx
  80098e:	5e                   	pop    %esi
  80098f:	5d                   	pop    %ebp
  800990:	c3                   	ret    

00800991 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	53                   	push   %ebx
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800998:	89 c1                	mov    %eax,%ecx
  80099a:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  80099d:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8009a1:	eb 0a                	jmp    8009ad <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009a3:	0f b6 10             	movzbl (%eax),%edx
  8009a6:	39 da                	cmp    %ebx,%edx
  8009a8:	74 07                	je     8009b1 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8009aa:	83 c0 01             	add    $0x1,%eax
  8009ad:	39 c8                	cmp    %ecx,%eax
  8009af:	72 f2                	jb     8009a3 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8009b1:	5b                   	pop    %ebx
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	57                   	push   %edi
  8009b8:	56                   	push   %esi
  8009b9:	53                   	push   %ebx
  8009ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009c0:	eb 03                	jmp    8009c5 <strtol+0x11>
		s++;
  8009c2:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009c5:	0f b6 01             	movzbl (%ecx),%eax
  8009c8:	3c 20                	cmp    $0x20,%al
  8009ca:	74 f6                	je     8009c2 <strtol+0xe>
  8009cc:	3c 09                	cmp    $0x9,%al
  8009ce:	74 f2                	je     8009c2 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8009d0:	3c 2b                	cmp    $0x2b,%al
  8009d2:	75 0a                	jne    8009de <strtol+0x2a>
		s++;
  8009d4:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8009d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8009dc:	eb 11                	jmp    8009ef <strtol+0x3b>
  8009de:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8009e3:	3c 2d                	cmp    $0x2d,%al
  8009e5:	75 08                	jne    8009ef <strtol+0x3b>
		s++, neg = 1;
  8009e7:	83 c1 01             	add    $0x1,%ecx
  8009ea:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009ef:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009f5:	75 15                	jne    800a0c <strtol+0x58>
  8009f7:	80 39 30             	cmpb   $0x30,(%ecx)
  8009fa:	75 10                	jne    800a0c <strtol+0x58>
  8009fc:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a00:	75 7c                	jne    800a7e <strtol+0xca>
		s += 2, base = 16;
  800a02:	83 c1 02             	add    $0x2,%ecx
  800a05:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a0a:	eb 16                	jmp    800a22 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800a0c:	85 db                	test   %ebx,%ebx
  800a0e:	75 12                	jne    800a22 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a10:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a15:	80 39 30             	cmpb   $0x30,(%ecx)
  800a18:	75 08                	jne    800a22 <strtol+0x6e>
		s++, base = 8;
  800a1a:	83 c1 01             	add    $0x1,%ecx
  800a1d:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800a22:	b8 00 00 00 00       	mov    $0x0,%eax
  800a27:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800a2a:	0f b6 11             	movzbl (%ecx),%edx
  800a2d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a30:	89 f3                	mov    %esi,%ebx
  800a32:	80 fb 09             	cmp    $0x9,%bl
  800a35:	77 08                	ja     800a3f <strtol+0x8b>
			dig = *s - '0';
  800a37:	0f be d2             	movsbl %dl,%edx
  800a3a:	83 ea 30             	sub    $0x30,%edx
  800a3d:	eb 22                	jmp    800a61 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800a3f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a42:	89 f3                	mov    %esi,%ebx
  800a44:	80 fb 19             	cmp    $0x19,%bl
  800a47:	77 08                	ja     800a51 <strtol+0x9d>
			dig = *s - 'a' + 10;
  800a49:	0f be d2             	movsbl %dl,%edx
  800a4c:	83 ea 57             	sub    $0x57,%edx
  800a4f:	eb 10                	jmp    800a61 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800a51:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a54:	89 f3                	mov    %esi,%ebx
  800a56:	80 fb 19             	cmp    $0x19,%bl
  800a59:	77 16                	ja     800a71 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800a5b:	0f be d2             	movsbl %dl,%edx
  800a5e:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800a61:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a64:	7d 0b                	jge    800a71 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800a66:	83 c1 01             	add    $0x1,%ecx
  800a69:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a6d:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800a6f:	eb b9                	jmp    800a2a <strtol+0x76>

	if (endptr)
  800a71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a75:	74 0d                	je     800a84 <strtol+0xd0>
		*endptr = (char *) s;
  800a77:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a7a:	89 0e                	mov    %ecx,(%esi)
  800a7c:	eb 06                	jmp    800a84 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a7e:	85 db                	test   %ebx,%ebx
  800a80:	74 98                	je     800a1a <strtol+0x66>
  800a82:	eb 9e                	jmp    800a22 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800a84:	89 c2                	mov    %eax,%edx
  800a86:	f7 da                	neg    %edx
  800a88:	85 ff                	test   %edi,%edi
  800a8a:	0f 45 c2             	cmovne %edx,%eax
}
  800a8d:	5b                   	pop    %ebx
  800a8e:	5e                   	pop    %esi
  800a8f:	5f                   	pop    %edi
  800a90:	5d                   	pop    %ebp
  800a91:	c3                   	ret    

00800a92 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	57                   	push   %edi
  800a96:	56                   	push   %esi
  800a97:	53                   	push   %ebx
  800a98:	83 ec 1c             	sub    $0x1c,%esp
  800a9b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a9e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800aa1:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800aa3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aa6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800aa9:	8b 7d 10             	mov    0x10(%ebp),%edi
  800aac:	8b 75 14             	mov    0x14(%ebp),%esi
  800aaf:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ab1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ab5:	74 1d                	je     800ad4 <syscall+0x42>
  800ab7:	85 c0                	test   %eax,%eax
  800ab9:	7e 19                	jle    800ad4 <syscall+0x42>
  800abb:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800abe:	83 ec 0c             	sub    $0xc,%esp
  800ac1:	50                   	push   %eax
  800ac2:	52                   	push   %edx
  800ac3:	68 3f 26 80 00       	push   $0x80263f
  800ac8:	6a 23                	push   $0x23
  800aca:	68 5c 26 80 00       	push   $0x80265c
  800acf:	e8 a0 13 00 00       	call   801e74 <_panic>

	return ret;
}
  800ad4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ad7:	5b                   	pop    %ebx
  800ad8:	5e                   	pop    %esi
  800ad9:	5f                   	pop    %edi
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    

00800adc <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800ae2:	6a 00                	push   $0x0
  800ae4:	6a 00                	push   $0x0
  800ae6:	6a 00                	push   $0x0
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aee:	ba 00 00 00 00       	mov    $0x0,%edx
  800af3:	b8 00 00 00 00       	mov    $0x0,%eax
  800af8:	e8 95 ff ff ff       	call   800a92 <syscall>
}
  800afd:	83 c4 10             	add    $0x10,%esp
  800b00:	c9                   	leave  
  800b01:	c3                   	ret    

00800b02 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800b08:	6a 00                	push   $0x0
  800b0a:	6a 00                	push   $0x0
  800b0c:	6a 00                	push   $0x0
  800b0e:	6a 00                	push   $0x0
  800b10:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b15:	ba 00 00 00 00       	mov    $0x0,%edx
  800b1a:	b8 01 00 00 00       	mov    $0x1,%eax
  800b1f:	e8 6e ff ff ff       	call   800a92 <syscall>
}
  800b24:	c9                   	leave  
  800b25:	c3                   	ret    

00800b26 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800b2c:	6a 00                	push   $0x0
  800b2e:	6a 00                	push   $0x0
  800b30:	6a 00                	push   $0x0
  800b32:	6a 00                	push   $0x0
  800b34:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b37:	ba 01 00 00 00       	mov    $0x1,%edx
  800b3c:	b8 03 00 00 00       	mov    $0x3,%eax
  800b41:	e8 4c ff ff ff       	call   800a92 <syscall>
}
  800b46:	c9                   	leave  
  800b47:	c3                   	ret    

00800b48 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
  800b4b:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b4e:	6a 00                	push   $0x0
  800b50:	6a 00                	push   $0x0
  800b52:	6a 00                	push   $0x0
  800b54:	6a 00                	push   $0x0
  800b56:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b60:	b8 02 00 00 00       	mov    $0x2,%eax
  800b65:	e8 28 ff ff ff       	call   800a92 <syscall>
}
  800b6a:	c9                   	leave  
  800b6b:	c3                   	ret    

00800b6c <sys_yield>:

void
sys_yield(void)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b72:	6a 00                	push   $0x0
  800b74:	6a 00                	push   $0x0
  800b76:	6a 00                	push   $0x0
  800b78:	6a 00                	push   $0x0
  800b7a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b7f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b84:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b89:	e8 04 ff ff ff       	call   800a92 <syscall>
}
  800b8e:	83 c4 10             	add    $0x10,%esp
  800b91:	c9                   	leave  
  800b92:	c3                   	ret    

00800b93 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800b99:	6a 00                	push   $0x0
  800b9b:	6a 00                	push   $0x0
  800b9d:	ff 75 10             	pushl  0x10(%ebp)
  800ba0:	ff 75 0c             	pushl  0xc(%ebp)
  800ba3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba6:	ba 01 00 00 00       	mov    $0x1,%edx
  800bab:	b8 04 00 00 00       	mov    $0x4,%eax
  800bb0:	e8 dd fe ff ff       	call   800a92 <syscall>
}
  800bb5:	c9                   	leave  
  800bb6:	c3                   	ret    

00800bb7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800bbd:	ff 75 18             	pushl  0x18(%ebp)
  800bc0:	ff 75 14             	pushl  0x14(%ebp)
  800bc3:	ff 75 10             	pushl  0x10(%ebp)
  800bc6:	ff 75 0c             	pushl  0xc(%ebp)
  800bc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bcc:	ba 01 00 00 00       	mov    $0x1,%edx
  800bd1:	b8 05 00 00 00       	mov    $0x5,%eax
  800bd6:	e8 b7 fe ff ff       	call   800a92 <syscall>
}
  800bdb:	c9                   	leave  
  800bdc:	c3                   	ret    

00800bdd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800be3:	6a 00                	push   $0x0
  800be5:	6a 00                	push   $0x0
  800be7:	6a 00                	push   $0x0
  800be9:	ff 75 0c             	pushl  0xc(%ebp)
  800bec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bef:	ba 01 00 00 00       	mov    $0x1,%edx
  800bf4:	b8 06 00 00 00       	mov    $0x6,%eax
  800bf9:	e8 94 fe ff ff       	call   800a92 <syscall>
}
  800bfe:	c9                   	leave  
  800bff:	c3                   	ret    

00800c00 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c06:	6a 00                	push   $0x0
  800c08:	6a 00                	push   $0x0
  800c0a:	6a 00                	push   $0x0
  800c0c:	ff 75 0c             	pushl  0xc(%ebp)
  800c0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c12:	ba 01 00 00 00       	mov    $0x1,%edx
  800c17:	b8 08 00 00 00       	mov    $0x8,%eax
  800c1c:	e8 71 fe ff ff       	call   800a92 <syscall>
}
  800c21:	c9                   	leave  
  800c22:	c3                   	ret    

00800c23 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800c29:	6a 00                	push   $0x0
  800c2b:	6a 00                	push   $0x0
  800c2d:	6a 00                	push   $0x0
  800c2f:	ff 75 0c             	pushl  0xc(%ebp)
  800c32:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c35:	ba 01 00 00 00       	mov    $0x1,%edx
  800c3a:	b8 09 00 00 00       	mov    $0x9,%eax
  800c3f:	e8 4e fe ff ff       	call   800a92 <syscall>
}
  800c44:	c9                   	leave  
  800c45:	c3                   	ret    

00800c46 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800c4c:	6a 00                	push   $0x0
  800c4e:	6a 00                	push   $0x0
  800c50:	6a 00                	push   $0x0
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c58:	ba 01 00 00 00       	mov    $0x1,%edx
  800c5d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c62:	e8 2b fe ff ff       	call   800a92 <syscall>
}
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800c6f:	6a 00                	push   $0x0
  800c71:	ff 75 14             	pushl  0x14(%ebp)
  800c74:	ff 75 10             	pushl  0x10(%ebp)
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c82:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c87:	e8 06 fe ff ff       	call   800a92 <syscall>
}
  800c8c:	c9                   	leave  
  800c8d:	c3                   	ret    

00800c8e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800c94:	6a 00                	push   $0x0
  800c96:	6a 00                	push   $0x0
  800c98:	6a 00                	push   $0x0
  800c9a:	6a 00                	push   $0x0
  800c9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c9f:	ba 01 00 00 00       	mov    $0x1,%edx
  800ca4:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ca9:	e8 e4 fd ff ff       	call   800a92 <syscall>
}
  800cae:	c9                   	leave  
  800caf:	c3                   	ret    

00800cb0 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	53                   	push   %ebx
  800cb4:	83 ec 04             	sub    $0x4,%esp

	int perm_w = PTE_COW|PTE_U|PTE_P;
	int perm = PTE_U|PTE_P;

	// LAB 4: Your code here.
	void *addr = (void*) (pn*PGSIZE);
  800cb7:	89 d3                	mov    %edx,%ebx
  800cb9:	c1 e3 0c             	shl    $0xc,%ebx

	//Si una página tiene el bit PTE_SHARE, se comparte con el hijo con los mismos permisos.
  	if (uvpt[pn] & PTE_SHARE) {
  800cbc:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800cc3:	f6 c5 04             	test   $0x4,%ch
  800cc6:	74 3a                	je     800d02 <duppage+0x52>
    	if (sys_page_map(0, addr, envid,addr, uvpt[pn] & PTE_SYSCALL) < 0) {
  800cc8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ccf:	83 ec 0c             	sub    $0xc,%esp
  800cd2:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800cd8:	52                   	push   %edx
  800cd9:	53                   	push   %ebx
  800cda:	50                   	push   %eax
  800cdb:	53                   	push   %ebx
  800cdc:	6a 00                	push   $0x0
  800cde:	e8 d4 fe ff ff       	call   800bb7 <sys_page_map>
  800ce3:	83 c4 20             	add    $0x20,%esp
  800ce6:	85 c0                	test   %eax,%eax
  800ce8:	0f 89 99 00 00 00    	jns    800d87 <duppage+0xd7>
 	     	panic("Error en sys_page_map");
  800cee:	83 ec 04             	sub    $0x4,%esp
  800cf1:	68 6a 26 80 00       	push   $0x80266a
  800cf6:	6a 50                	push   $0x50
  800cf8:	68 80 26 80 00       	push   $0x802680
  800cfd:	e8 72 11 00 00       	call   801e74 <_panic>
    	} 
    	return 0;
	}

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  800d02:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800d09:	f6 c1 02             	test   $0x2,%cl
  800d0c:	75 0c                	jne    800d1a <duppage+0x6a>
  800d0e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d15:	f6 c6 08             	test   $0x8,%dh
  800d18:	74 5b                	je     800d75 <duppage+0xc5>
		if (sys_page_map(0, addr, envid, addr, perm_w) < 0){
  800d1a:	83 ec 0c             	sub    $0xc,%esp
  800d1d:	68 05 08 00 00       	push   $0x805
  800d22:	53                   	push   %ebx
  800d23:	50                   	push   %eax
  800d24:	53                   	push   %ebx
  800d25:	6a 00                	push   $0x0
  800d27:	e8 8b fe ff ff       	call   800bb7 <sys_page_map>
  800d2c:	83 c4 20             	add    $0x20,%esp
  800d2f:	85 c0                	test   %eax,%eax
  800d31:	79 14                	jns    800d47 <duppage+0x97>
			panic("Error mapeando pagina Padre");
  800d33:	83 ec 04             	sub    $0x4,%esp
  800d36:	68 8b 26 80 00       	push   $0x80268b
  800d3b:	6a 57                	push   $0x57
  800d3d:	68 80 26 80 00       	push   $0x802680
  800d42:	e8 2d 11 00 00       	call   801e74 <_panic>
		}
		if (sys_page_map(0, addr, 0, addr, perm_w) < 0){
  800d47:	83 ec 0c             	sub    $0xc,%esp
  800d4a:	68 05 08 00 00       	push   $0x805
  800d4f:	53                   	push   %ebx
  800d50:	6a 00                	push   $0x0
  800d52:	53                   	push   %ebx
  800d53:	6a 00                	push   $0x0
  800d55:	e8 5d fe ff ff       	call   800bb7 <sys_page_map>
  800d5a:	83 c4 20             	add    $0x20,%esp
  800d5d:	85 c0                	test   %eax,%eax
  800d5f:	79 26                	jns    800d87 <duppage+0xd7>
			panic("Error mapeando pagina Hijo");
  800d61:	83 ec 04             	sub    $0x4,%esp
  800d64:	68 a7 26 80 00       	push   $0x8026a7
  800d69:	6a 5a                	push   $0x5a
  800d6b:	68 80 26 80 00       	push   $0x802680
  800d70:	e8 ff 10 00 00       	call   801e74 <_panic>
		}
	} else sys_page_map(0, addr, envid, addr, perm);
  800d75:	83 ec 0c             	sub    $0xc,%esp
  800d78:	6a 05                	push   $0x5
  800d7a:	53                   	push   %ebx
  800d7b:	50                   	push   %eax
  800d7c:	53                   	push   %ebx
  800d7d:	6a 00                	push   $0x0
  800d7f:	e8 33 fe ff ff       	call   800bb7 <sys_page_map>
  800d84:	83 c4 20             	add    $0x20,%esp
	
	return 0;
}
  800d87:	b8 00 00 00 00       	mov    $0x0,%eax
  800d8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d8f:	c9                   	leave  
  800d90:	c3                   	ret    

00800d91 <dup_or_share>:
//FORK V0

static void
dup_or_share(envid_t dstenv, void *va, int perm){
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	57                   	push   %edi
  800d95:	56                   	push   %esi
  800d96:	53                   	push   %ebx
  800d97:	83 ec 0c             	sub    $0xc,%esp
  800d9a:	89 c7                	mov    %eax,%edi
  800d9c:	89 d6                	mov    %edx,%esi
  800d9e:	89 cb                	mov    %ecx,%ebx
	int result;
	// Si no es de escritura, comparto la pagina
	if((perm &PTE_W) != PTE_W){
  800da0:	f6 c1 02             	test   $0x2,%cl
  800da3:	75 2d                	jne    800dd2 <dup_or_share+0x41>
		if((result = sys_page_map(0, va, dstenv, va, perm))<0){
  800da5:	83 ec 0c             	sub    $0xc,%esp
  800da8:	51                   	push   %ecx
  800da9:	52                   	push   %edx
  800daa:	50                   	push   %eax
  800dab:	52                   	push   %edx
  800dac:	6a 00                	push   $0x0
  800dae:	e8 04 fe ff ff       	call   800bb7 <sys_page_map>
  800db3:	83 c4 20             	add    $0x20,%esp
  800db6:	85 c0                	test   %eax,%eax
  800db8:	0f 89 a4 00 00 00    	jns    800e62 <dup_or_share+0xd1>
			panic("Error compartiendo la pagina");
  800dbe:	83 ec 04             	sub    $0x4,%esp
  800dc1:	68 c2 26 80 00       	push   $0x8026c2
  800dc6:	6a 68                	push   $0x68
  800dc8:	68 80 26 80 00       	push   $0x802680
  800dcd:	e8 a2 10 00 00       	call   801e74 <_panic>
		}
	// Si es de escritura comportamiento de duppage, en dumbfork
	}else{
		if ((result = sys_page_alloc(dstenv, va, perm)) < 0){
  800dd2:	83 ec 04             	sub    $0x4,%esp
  800dd5:	51                   	push   %ecx
  800dd6:	52                   	push   %edx
  800dd7:	50                   	push   %eax
  800dd8:	e8 b6 fd ff ff       	call   800b93 <sys_page_alloc>
  800ddd:	83 c4 10             	add    $0x10,%esp
  800de0:	85 c0                	test   %eax,%eax
  800de2:	79 14                	jns    800df8 <dup_or_share+0x67>
			panic("Error copiando la pagina");
  800de4:	83 ec 04             	sub    $0x4,%esp
  800de7:	68 df 26 80 00       	push   $0x8026df
  800dec:	6a 6d                	push   $0x6d
  800dee:	68 80 26 80 00       	push   $0x802680
  800df3:	e8 7c 10 00 00       	call   801e74 <_panic>
		}
		if ((result = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0){
  800df8:	83 ec 0c             	sub    $0xc,%esp
  800dfb:	53                   	push   %ebx
  800dfc:	68 00 00 40 00       	push   $0x400000
  800e01:	6a 00                	push   $0x0
  800e03:	56                   	push   %esi
  800e04:	57                   	push   %edi
  800e05:	e8 ad fd ff ff       	call   800bb7 <sys_page_map>
  800e0a:	83 c4 20             	add    $0x20,%esp
  800e0d:	85 c0                	test   %eax,%eax
  800e0f:	79 14                	jns    800e25 <dup_or_share+0x94>
			panic("Error copiando la pagina");
  800e11:	83 ec 04             	sub    $0x4,%esp
  800e14:	68 df 26 80 00       	push   $0x8026df
  800e19:	6a 70                	push   $0x70
  800e1b:	68 80 26 80 00       	push   $0x802680
  800e20:	e8 4f 10 00 00       	call   801e74 <_panic>
		}
		memmove(UTEMP, va, PGSIZE);
  800e25:	83 ec 04             	sub    $0x4,%esp
  800e28:	68 00 10 00 00       	push   $0x1000
  800e2d:	56                   	push   %esi
  800e2e:	68 00 00 40 00       	push   $0x400000
  800e33:	e8 a5 fa ff ff       	call   8008dd <memmove>
		if ((result = sys_page_unmap(0, UTEMP)) < 0){
  800e38:	83 c4 08             	add    $0x8,%esp
  800e3b:	68 00 00 40 00       	push   $0x400000
  800e40:	6a 00                	push   $0x0
  800e42:	e8 96 fd ff ff       	call   800bdd <sys_page_unmap>
  800e47:	83 c4 10             	add    $0x10,%esp
  800e4a:	85 c0                	test   %eax,%eax
  800e4c:	79 14                	jns    800e62 <dup_or_share+0xd1>
			panic("Error copiando la pagina");
  800e4e:	83 ec 04             	sub    $0x4,%esp
  800e51:	68 df 26 80 00       	push   $0x8026df
  800e56:	6a 74                	push   $0x74
  800e58:	68 80 26 80 00       	push   $0x802680
  800e5d:	e8 12 10 00 00       	call   801e74 <_panic>
		}
	}	
}
  800e62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e65:	5b                   	pop    %ebx
  800e66:	5e                   	pop    %esi
  800e67:	5f                   	pop    %edi
  800e68:	5d                   	pop    %ebp
  800e69:	c3                   	ret    

00800e6a <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	53                   	push   %ebx
  800e6e:	83 ec 04             	sub    $0x4,%esp
  800e71:	8b 55 08             	mov    0x8(%ebp),%edx
	void *va = (void *) utf->utf_fault_va;
  800e74:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800e76:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  800e7a:	74 2e                	je     800eaa <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
  800e7c:	89 c2                	mov    %eax,%edx
  800e7e:	c1 ea 16             	shr    $0x16,%edx
  800e81:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800e88:	f6 c2 01             	test   $0x1,%dl
  800e8b:	74 1d                	je     800eaa <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
  800e8d:	89 c2                	mov    %eax,%edx
  800e8f:	c1 ea 0c             	shr    $0xc,%edx
  800e92:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
		(uvpd[PDX(va)] & PTE_P) && 
  800e99:	f6 c1 01             	test   $0x1,%cl
  800e9c:	74 0c                	je     800eaa <pgfault+0x40>
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
  800e9e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  800ea5:	f6 c6 08             	test   $0x8,%dh
  800ea8:	75 14                	jne    800ebe <pgfault+0x54>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
		panic("No es copy-on-write");
  800eaa:	83 ec 04             	sub    $0x4,%esp
  800ead:	68 f8 26 80 00       	push   $0x8026f8
  800eb2:	6a 21                	push   $0x21
  800eb4:	68 80 26 80 00       	push   $0x802680
  800eb9:	e8 b6 0f 00 00       	call   801e74 <_panic>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	va = ROUNDDOWN(va, PGSIZE);
  800ebe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ec3:	89 c3                	mov    %eax,%ebx
	if (sys_page_alloc(0, PFTEMP, perm) < 0){
  800ec5:	83 ec 04             	sub    $0x4,%esp
  800ec8:	6a 07                	push   $0x7
  800eca:	68 00 f0 7f 00       	push   $0x7ff000
  800ecf:	6a 00                	push   $0x0
  800ed1:	e8 bd fc ff ff       	call   800b93 <sys_page_alloc>
  800ed6:	83 c4 10             	add    $0x10,%esp
  800ed9:	85 c0                	test   %eax,%eax
  800edb:	79 14                	jns    800ef1 <pgfault+0x87>
		panic("Error sys_page_alloc");
  800edd:	83 ec 04             	sub    $0x4,%esp
  800ee0:	68 0c 27 80 00       	push   $0x80270c
  800ee5:	6a 2a                	push   $0x2a
  800ee7:	68 80 26 80 00       	push   $0x802680
  800eec:	e8 83 0f 00 00       	call   801e74 <_panic>
	}
	memcpy(PFTEMP, va, PGSIZE);
  800ef1:	83 ec 04             	sub    $0x4,%esp
  800ef4:	68 00 10 00 00       	push   $0x1000
  800ef9:	53                   	push   %ebx
  800efa:	68 00 f0 7f 00       	push   $0x7ff000
  800eff:	e8 41 fa ff ff       	call   800945 <memcpy>
	if (sys_page_map(0, PFTEMP, 0, va, perm) < 0){
  800f04:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f0b:	53                   	push   %ebx
  800f0c:	6a 00                	push   $0x0
  800f0e:	68 00 f0 7f 00       	push   $0x7ff000
  800f13:	6a 00                	push   $0x0
  800f15:	e8 9d fc ff ff       	call   800bb7 <sys_page_map>
  800f1a:	83 c4 20             	add    $0x20,%esp
  800f1d:	85 c0                	test   %eax,%eax
  800f1f:	79 14                	jns    800f35 <pgfault+0xcb>
		panic("Error sys_page_map");
  800f21:	83 ec 04             	sub    $0x4,%esp
  800f24:	68 21 27 80 00       	push   $0x802721
  800f29:	6a 2e                	push   $0x2e
  800f2b:	68 80 26 80 00       	push   $0x802680
  800f30:	e8 3f 0f 00 00       	call   801e74 <_panic>
	}
	if (sys_page_unmap(0, PFTEMP) < 0){
  800f35:	83 ec 08             	sub    $0x8,%esp
  800f38:	68 00 f0 7f 00       	push   $0x7ff000
  800f3d:	6a 00                	push   $0x0
  800f3f:	e8 99 fc ff ff       	call   800bdd <sys_page_unmap>
  800f44:	83 c4 10             	add    $0x10,%esp
  800f47:	85 c0                	test   %eax,%eax
  800f49:	79 14                	jns    800f5f <pgfault+0xf5>
		panic("Error sys_page_unmap");
  800f4b:	83 ec 04             	sub    $0x4,%esp
  800f4e:	68 34 27 80 00       	push   $0x802734
  800f53:	6a 31                	push   $0x31
  800f55:	68 80 26 80 00       	push   $0x802680
  800f5a:	e8 15 0f 00 00       	call   801e74 <_panic>
	}
	return;

}
  800f5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f62:	c9                   	leave  
  800f63:	c3                   	ret    

00800f64 <fork_v0>:
		}
	}	
}

envid_t
fork_v0(void){
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	57                   	push   %edi
  800f68:	56                   	push   %esi
  800f69:	53                   	push   %ebx
  800f6a:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f6d:	b8 07 00 00 00       	mov    $0x7,%eax
  800f72:	cd 30                	int    $0x30
  800f74:	89 c6                	mov    %eax,%esi
	envid_t envid;
	uint8_t *va;
	int result;	

	envid = sys_exofork();
	if (envid < 0)
  800f76:	85 c0                	test   %eax,%eax
  800f78:	79 15                	jns    800f8f <fork_v0+0x2b>
		panic("sys_exofork: %e", envid);
  800f7a:	50                   	push   %eax
  800f7b:	68 49 27 80 00       	push   $0x802749
  800f80:	68 81 00 00 00       	push   $0x81
  800f85:	68 80 26 80 00       	push   $0x802680
  800f8a:	e8 e5 0e 00 00       	call   801e74 <_panic>
  800f8f:	89 c7                	mov    %eax,%edi
  800f91:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {		
  800f96:	85 c0                	test   %eax,%eax
  800f98:	75 1e                	jne    800fb8 <fork_v0+0x54>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f9a:	e8 a9 fb ff ff       	call   800b48 <sys_getenvid>
  800f9f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800fa4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800fa7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800fac:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800fb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb6:	eb 7a                	jmp    801032 <fork_v0+0xce>
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  800fb8:	89 d8                	mov    %ebx,%eax
  800fba:	c1 e8 16             	shr    $0x16,%eax
  800fbd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fc4:	a8 01                	test   $0x1,%al
  800fc6:	74 33                	je     800ffb <fork_v0+0x97>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  800fc8:	89 d8                	mov    %ebx,%eax
  800fca:	c1 e8 0c             	shr    $0xc,%eax
  800fcd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fd4:	f6 c2 01             	test   $0x1,%dl
  800fd7:	74 22                	je     800ffb <fork_v0+0x97>
  800fd9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fe0:	f6 c2 04             	test   $0x4,%dl
  800fe3:	74 16                	je     800ffb <fork_v0+0x97>
				pte_t pte =uvpt[PGNUM(va)];
  800fe5:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
  800fec:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  800ff2:	89 da                	mov    %ebx,%edx
  800ff4:	89 f8                	mov    %edi,%eax
  800ff6:	e8 96 fd ff ff       	call   800d91 <dup_or_share>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
  800ffb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801001:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801007:	75 af                	jne    800fb8 <fork_v0+0x54>
				pte_t pte =uvpt[PGNUM(va)];
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
			}
		}
	}	
	if ((result = sys_env_set_status(envid, ENV_RUNNABLE)) < 0){
  801009:	83 ec 08             	sub    $0x8,%esp
  80100c:	6a 02                	push   $0x2
  80100e:	56                   	push   %esi
  80100f:	e8 ec fb ff ff       	call   800c00 <sys_env_set_status>
  801014:	83 c4 10             	add    $0x10,%esp
  801017:	85 c0                	test   %eax,%eax
  801019:	79 15                	jns    801030 <fork_v0+0xcc>

		panic("sys_env_set_status: %e", result);
  80101b:	50                   	push   %eax
  80101c:	68 59 27 80 00       	push   $0x802759
  801021:	68 90 00 00 00       	push   $0x90
  801026:	68 80 26 80 00       	push   $0x802680
  80102b:	e8 44 0e 00 00       	call   801e74 <_panic>
	}
	return envid;
  801030:	89 f0                	mov    %esi,%eax
}
  801032:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801035:	5b                   	pop    %ebx
  801036:	5e                   	pop    %esi
  801037:	5f                   	pop    %edi
  801038:	5d                   	pop    %ebp
  801039:	c3                   	ret    

0080103a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	57                   	push   %edi
  80103e:	56                   	push   %esi
  80103f:	53                   	push   %ebx
  801040:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801043:	68 6a 0e 80 00       	push   $0x800e6a
  801048:	e8 6d 0e 00 00       	call   801eba <set_pgfault_handler>
  80104d:	b8 07 00 00 00       	mov    $0x7,%eax
  801052:	cd 30                	int    $0x30
  801054:	89 c6                	mov    %eax,%esi

	envid_t envid;
	uint32_t va;
	envid = sys_exofork();
	if (envid < 0){
  801056:	83 c4 10             	add    $0x10,%esp
  801059:	85 c0                	test   %eax,%eax
  80105b:	79 15                	jns    801072 <fork+0x38>
		panic("sys_exofork: %e", envid);
  80105d:	50                   	push   %eax
  80105e:	68 49 27 80 00       	push   $0x802749
  801063:	68 b1 00 00 00       	push   $0xb1
  801068:	68 80 26 80 00       	push   $0x802680
  80106d:	e8 02 0e 00 00       	call   801e74 <_panic>
  801072:	89 c7                	mov    %eax,%edi
  801074:	bb 00 00 00 00       	mov    $0x0,%ebx
	}
	if (envid == 0) {		
  801079:	85 c0                	test   %eax,%eax
  80107b:	75 21                	jne    80109e <fork+0x64>
		thisenv = &envs[ENVX(sys_getenvid())];
  80107d:	e8 c6 fa ff ff       	call   800b48 <sys_getenvid>
  801082:	25 ff 03 00 00       	and    $0x3ff,%eax
  801087:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80108a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80108f:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801094:	b8 00 00 00 00       	mov    $0x0,%eax
  801099:	e9 a7 00 00 00       	jmp    801145 <fork+0x10b>
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  80109e:	89 d8                	mov    %ebx,%eax
  8010a0:	c1 e8 16             	shr    $0x16,%eax
  8010a3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010aa:	a8 01                	test   $0x1,%al
  8010ac:	74 22                	je     8010d0 <fork+0x96>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  8010ae:	89 da                	mov    %ebx,%edx
  8010b0:	c1 ea 0c             	shr    $0xc,%edx
  8010b3:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8010ba:	a8 01                	test   $0x1,%al
  8010bc:	74 12                	je     8010d0 <fork+0x96>
  8010be:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8010c5:	a8 04                	test   $0x4,%al
  8010c7:	74 07                	je     8010d0 <fork+0x96>
				duppage(envid, PGNUM(va));			
  8010c9:	89 f8                	mov    %edi,%eax
  8010cb:	e8 e0 fb ff ff       	call   800cb0 <duppage>
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
  8010d0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010d6:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8010dc:	75 c0                	jne    80109e <fork+0x64>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
				duppage(envid, PGNUM(va));			
			}
		}
	}
	if (sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P) < 0){
  8010de:	83 ec 04             	sub    $0x4,%esp
  8010e1:	6a 07                	push   $0x7
  8010e3:	68 00 f0 bf ee       	push   $0xeebff000
  8010e8:	56                   	push   %esi
  8010e9:	e8 a5 fa ff ff       	call   800b93 <sys_page_alloc>
  8010ee:	83 c4 10             	add    $0x10,%esp
  8010f1:	85 c0                	test   %eax,%eax
  8010f3:	79 17                	jns    80110c <fork+0xd2>
		panic("Se escribio en la pagina de excepciones");
  8010f5:	83 ec 04             	sub    $0x4,%esp
  8010f8:	68 88 27 80 00       	push   $0x802788
  8010fd:	68 c0 00 00 00       	push   $0xc0
  801102:	68 80 26 80 00       	push   $0x802680
  801107:	e8 68 0d 00 00       	call   801e74 <_panic>
	}	
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80110c:	83 ec 08             	sub    $0x8,%esp
  80110f:	68 29 1f 80 00       	push   $0x801f29
  801114:	56                   	push   %esi
  801115:	e8 2c fb ff ff       	call   800c46 <sys_env_set_pgfault_upcall>

	if (sys_env_set_status(envid, ENV_RUNNABLE) < 0)
  80111a:	83 c4 08             	add    $0x8,%esp
  80111d:	6a 02                	push   $0x2
  80111f:	56                   	push   %esi
  801120:	e8 db fa ff ff       	call   800c00 <sys_env_set_status>
  801125:	83 c4 10             	add    $0x10,%esp
  801128:	85 c0                	test   %eax,%eax
  80112a:	79 17                	jns    801143 <fork+0x109>
		panic("Status incorrecto de enviroment");
  80112c:	83 ec 04             	sub    $0x4,%esp
  80112f:	68 b0 27 80 00       	push   $0x8027b0
  801134:	68 c5 00 00 00       	push   $0xc5
  801139:	68 80 26 80 00       	push   $0x802680
  80113e:	e8 31 0d 00 00       	call   801e74 <_panic>

	return envid;
  801143:	89 f0                	mov    %esi,%eax
	
}
  801145:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801148:	5b                   	pop    %ebx
  801149:	5e                   	pop    %esi
  80114a:	5f                   	pop    %edi
  80114b:	5d                   	pop    %ebp
  80114c:	c3                   	ret    

0080114d <sfork>:


// Challenge!
int
sfork(void)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801153:	68 70 27 80 00       	push   $0x802770
  801158:	68 d1 00 00 00       	push   $0xd1
  80115d:	68 80 26 80 00       	push   $0x802680
  801162:	e8 0d 0d 00 00       	call   801e74 <_panic>

00801167 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801167:	55                   	push   %ebp
  801168:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	05 00 00 00 30       	add    $0x30000000,%eax
  801172:	c1 e8 0c             	shr    $0xc,%eax
}
  801175:	5d                   	pop    %ebp
  801176:	c3                   	ret    

00801177 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  80117a:	ff 75 08             	pushl  0x8(%ebp)
  80117d:	e8 e5 ff ff ff       	call   801167 <fd2num>
  801182:	83 c4 04             	add    $0x4,%esp
  801185:	c1 e0 0c             	shl    $0xc,%eax
  801188:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80118d:	c9                   	leave  
  80118e:	c3                   	ret    

0080118f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
  801192:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801195:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80119a:	89 c2                	mov    %eax,%edx
  80119c:	c1 ea 16             	shr    $0x16,%edx
  80119f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011a6:	f6 c2 01             	test   $0x1,%dl
  8011a9:	74 11                	je     8011bc <fd_alloc+0x2d>
  8011ab:	89 c2                	mov    %eax,%edx
  8011ad:	c1 ea 0c             	shr    $0xc,%edx
  8011b0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011b7:	f6 c2 01             	test   $0x1,%dl
  8011ba:	75 09                	jne    8011c5 <fd_alloc+0x36>
			*fd_store = fd;
  8011bc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011be:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c3:	eb 17                	jmp    8011dc <fd_alloc+0x4d>
  8011c5:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8011ca:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011cf:	75 c9                	jne    80119a <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011d1:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8011d7:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8011dc:	5d                   	pop    %ebp
  8011dd:	c3                   	ret    

008011de <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011de:	55                   	push   %ebp
  8011df:	89 e5                	mov    %esp,%ebp
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011e4:	83 f8 1f             	cmp    $0x1f,%eax
  8011e7:	77 36                	ja     80121f <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011e9:	c1 e0 0c             	shl    $0xc,%eax
  8011ec:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011f1:	89 c2                	mov    %eax,%edx
  8011f3:	c1 ea 16             	shr    $0x16,%edx
  8011f6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011fd:	f6 c2 01             	test   $0x1,%dl
  801200:	74 24                	je     801226 <fd_lookup+0x48>
  801202:	89 c2                	mov    %eax,%edx
  801204:	c1 ea 0c             	shr    $0xc,%edx
  801207:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80120e:	f6 c2 01             	test   $0x1,%dl
  801211:	74 1a                	je     80122d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801213:	8b 55 0c             	mov    0xc(%ebp),%edx
  801216:	89 02                	mov    %eax,(%edx)
	return 0;
  801218:	b8 00 00 00 00       	mov    $0x0,%eax
  80121d:	eb 13                	jmp    801232 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80121f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801224:	eb 0c                	jmp    801232 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801226:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80122b:	eb 05                	jmp    801232 <fd_lookup+0x54>
  80122d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  801232:	5d                   	pop    %ebp
  801233:	c3                   	ret    

00801234 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801234:	55                   	push   %ebp
  801235:	89 e5                	mov    %esp,%ebp
  801237:	83 ec 08             	sub    $0x8,%esp
  80123a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123d:	ba 4c 28 80 00       	mov    $0x80284c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801242:	eb 13                	jmp    801257 <dev_lookup+0x23>
  801244:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  801247:	39 08                	cmp    %ecx,(%eax)
  801249:	75 0c                	jne    801257 <dev_lookup+0x23>
			*dev = devtab[i];
  80124b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80124e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801250:	b8 00 00 00 00       	mov    $0x0,%eax
  801255:	eb 2e                	jmp    801285 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801257:	8b 02                	mov    (%edx),%eax
  801259:	85 c0                	test   %eax,%eax
  80125b:	75 e7                	jne    801244 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80125d:	a1 04 40 80 00       	mov    0x804004,%eax
  801262:	8b 40 48             	mov    0x48(%eax),%eax
  801265:	83 ec 04             	sub    $0x4,%esp
  801268:	51                   	push   %ecx
  801269:	50                   	push   %eax
  80126a:	68 d0 27 80 00       	push   $0x8027d0
  80126f:	e8 64 ef ff ff       	call   8001d8 <cprintf>
	*dev = 0;
  801274:	8b 45 0c             	mov    0xc(%ebp),%eax
  801277:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80127d:	83 c4 10             	add    $0x10,%esp
  801280:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801285:	c9                   	leave  
  801286:	c3                   	ret    

00801287 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801287:	55                   	push   %ebp
  801288:	89 e5                	mov    %esp,%ebp
  80128a:	56                   	push   %esi
  80128b:	53                   	push   %ebx
  80128c:	83 ec 10             	sub    $0x10,%esp
  80128f:	8b 75 08             	mov    0x8(%ebp),%esi
  801292:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801295:	56                   	push   %esi
  801296:	e8 cc fe ff ff       	call   801167 <fd2num>
  80129b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80129e:	89 14 24             	mov    %edx,(%esp)
  8012a1:	50                   	push   %eax
  8012a2:	e8 37 ff ff ff       	call   8011de <fd_lookup>
  8012a7:	83 c4 08             	add    $0x8,%esp
  8012aa:	85 c0                	test   %eax,%eax
  8012ac:	78 05                	js     8012b3 <fd_close+0x2c>
	    || fd != fd2)
  8012ae:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8012b1:	74 0c                	je     8012bf <fd_close+0x38>
		return (must_exist ? r : 0);
  8012b3:	84 db                	test   %bl,%bl
  8012b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8012ba:	0f 44 c2             	cmove  %edx,%eax
  8012bd:	eb 41                	jmp    801300 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012bf:	83 ec 08             	sub    $0x8,%esp
  8012c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012c5:	50                   	push   %eax
  8012c6:	ff 36                	pushl  (%esi)
  8012c8:	e8 67 ff ff ff       	call   801234 <dev_lookup>
  8012cd:	89 c3                	mov    %eax,%ebx
  8012cf:	83 c4 10             	add    $0x10,%esp
  8012d2:	85 c0                	test   %eax,%eax
  8012d4:	78 1a                	js     8012f0 <fd_close+0x69>
		if (dev->dev_close)
  8012d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d9:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8012dc:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8012e1:	85 c0                	test   %eax,%eax
  8012e3:	74 0b                	je     8012f0 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  8012e5:	83 ec 0c             	sub    $0xc,%esp
  8012e8:	56                   	push   %esi
  8012e9:	ff d0                	call   *%eax
  8012eb:	89 c3                	mov    %eax,%ebx
  8012ed:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8012f0:	83 ec 08             	sub    $0x8,%esp
  8012f3:	56                   	push   %esi
  8012f4:	6a 00                	push   $0x0
  8012f6:	e8 e2 f8 ff ff       	call   800bdd <sys_page_unmap>
	return r;
  8012fb:	83 c4 10             	add    $0x10,%esp
  8012fe:	89 d8                	mov    %ebx,%eax
}
  801300:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801303:	5b                   	pop    %ebx
  801304:	5e                   	pop    %esi
  801305:	5d                   	pop    %ebp
  801306:	c3                   	ret    

00801307 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
  80130a:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80130d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801310:	50                   	push   %eax
  801311:	ff 75 08             	pushl  0x8(%ebp)
  801314:	e8 c5 fe ff ff       	call   8011de <fd_lookup>
  801319:	83 c4 08             	add    $0x8,%esp
  80131c:	85 c0                	test   %eax,%eax
  80131e:	78 10                	js     801330 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801320:	83 ec 08             	sub    $0x8,%esp
  801323:	6a 01                	push   $0x1
  801325:	ff 75 f4             	pushl  -0xc(%ebp)
  801328:	e8 5a ff ff ff       	call   801287 <fd_close>
  80132d:	83 c4 10             	add    $0x10,%esp
}
  801330:	c9                   	leave  
  801331:	c3                   	ret    

00801332 <close_all>:

void
close_all(void)
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
  801335:	53                   	push   %ebx
  801336:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801339:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80133e:	83 ec 0c             	sub    $0xc,%esp
  801341:	53                   	push   %ebx
  801342:	e8 c0 ff ff ff       	call   801307 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801347:	83 c3 01             	add    $0x1,%ebx
  80134a:	83 c4 10             	add    $0x10,%esp
  80134d:	83 fb 20             	cmp    $0x20,%ebx
  801350:	75 ec                	jne    80133e <close_all+0xc>
		close(i);
}
  801352:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801355:	c9                   	leave  
  801356:	c3                   	ret    

00801357 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	57                   	push   %edi
  80135b:	56                   	push   %esi
  80135c:	53                   	push   %ebx
  80135d:	83 ec 2c             	sub    $0x2c,%esp
  801360:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801363:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801366:	50                   	push   %eax
  801367:	ff 75 08             	pushl  0x8(%ebp)
  80136a:	e8 6f fe ff ff       	call   8011de <fd_lookup>
  80136f:	83 c4 08             	add    $0x8,%esp
  801372:	85 c0                	test   %eax,%eax
  801374:	0f 88 c1 00 00 00    	js     80143b <dup+0xe4>
		return r;
	close(newfdnum);
  80137a:	83 ec 0c             	sub    $0xc,%esp
  80137d:	56                   	push   %esi
  80137e:	e8 84 ff ff ff       	call   801307 <close>

	newfd = INDEX2FD(newfdnum);
  801383:	89 f3                	mov    %esi,%ebx
  801385:	c1 e3 0c             	shl    $0xc,%ebx
  801388:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  80138e:	83 c4 04             	add    $0x4,%esp
  801391:	ff 75 e4             	pushl  -0x1c(%ebp)
  801394:	e8 de fd ff ff       	call   801177 <fd2data>
  801399:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  80139b:	89 1c 24             	mov    %ebx,(%esp)
  80139e:	e8 d4 fd ff ff       	call   801177 <fd2data>
  8013a3:	83 c4 10             	add    $0x10,%esp
  8013a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013a9:	89 f8                	mov    %edi,%eax
  8013ab:	c1 e8 16             	shr    $0x16,%eax
  8013ae:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013b5:	a8 01                	test   $0x1,%al
  8013b7:	74 37                	je     8013f0 <dup+0x99>
  8013b9:	89 f8                	mov    %edi,%eax
  8013bb:	c1 e8 0c             	shr    $0xc,%eax
  8013be:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013c5:	f6 c2 01             	test   $0x1,%dl
  8013c8:	74 26                	je     8013f0 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013ca:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013d1:	83 ec 0c             	sub    $0xc,%esp
  8013d4:	25 07 0e 00 00       	and    $0xe07,%eax
  8013d9:	50                   	push   %eax
  8013da:	ff 75 d4             	pushl  -0x2c(%ebp)
  8013dd:	6a 00                	push   $0x0
  8013df:	57                   	push   %edi
  8013e0:	6a 00                	push   $0x0
  8013e2:	e8 d0 f7 ff ff       	call   800bb7 <sys_page_map>
  8013e7:	89 c7                	mov    %eax,%edi
  8013e9:	83 c4 20             	add    $0x20,%esp
  8013ec:	85 c0                	test   %eax,%eax
  8013ee:	78 2e                	js     80141e <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013f3:	89 d0                	mov    %edx,%eax
  8013f5:	c1 e8 0c             	shr    $0xc,%eax
  8013f8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013ff:	83 ec 0c             	sub    $0xc,%esp
  801402:	25 07 0e 00 00       	and    $0xe07,%eax
  801407:	50                   	push   %eax
  801408:	53                   	push   %ebx
  801409:	6a 00                	push   $0x0
  80140b:	52                   	push   %edx
  80140c:	6a 00                	push   $0x0
  80140e:	e8 a4 f7 ff ff       	call   800bb7 <sys_page_map>
  801413:	89 c7                	mov    %eax,%edi
  801415:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  801418:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80141a:	85 ff                	test   %edi,%edi
  80141c:	79 1d                	jns    80143b <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80141e:	83 ec 08             	sub    $0x8,%esp
  801421:	53                   	push   %ebx
  801422:	6a 00                	push   $0x0
  801424:	e8 b4 f7 ff ff       	call   800bdd <sys_page_unmap>
	sys_page_unmap(0, nva);
  801429:	83 c4 08             	add    $0x8,%esp
  80142c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80142f:	6a 00                	push   $0x0
  801431:	e8 a7 f7 ff ff       	call   800bdd <sys_page_unmap>
	return r;
  801436:	83 c4 10             	add    $0x10,%esp
  801439:	89 f8                	mov    %edi,%eax
}
  80143b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80143e:	5b                   	pop    %ebx
  80143f:	5e                   	pop    %esi
  801440:	5f                   	pop    %edi
  801441:	5d                   	pop    %ebp
  801442:	c3                   	ret    

00801443 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
  801446:	53                   	push   %ebx
  801447:	83 ec 14             	sub    $0x14,%esp
  80144a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80144d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801450:	50                   	push   %eax
  801451:	53                   	push   %ebx
  801452:	e8 87 fd ff ff       	call   8011de <fd_lookup>
  801457:	83 c4 08             	add    $0x8,%esp
  80145a:	89 c2                	mov    %eax,%edx
  80145c:	85 c0                	test   %eax,%eax
  80145e:	78 6d                	js     8014cd <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801460:	83 ec 08             	sub    $0x8,%esp
  801463:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801466:	50                   	push   %eax
  801467:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146a:	ff 30                	pushl  (%eax)
  80146c:	e8 c3 fd ff ff       	call   801234 <dev_lookup>
  801471:	83 c4 10             	add    $0x10,%esp
  801474:	85 c0                	test   %eax,%eax
  801476:	78 4c                	js     8014c4 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801478:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80147b:	8b 42 08             	mov    0x8(%edx),%eax
  80147e:	83 e0 03             	and    $0x3,%eax
  801481:	83 f8 01             	cmp    $0x1,%eax
  801484:	75 21                	jne    8014a7 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801486:	a1 04 40 80 00       	mov    0x804004,%eax
  80148b:	8b 40 48             	mov    0x48(%eax),%eax
  80148e:	83 ec 04             	sub    $0x4,%esp
  801491:	53                   	push   %ebx
  801492:	50                   	push   %eax
  801493:	68 11 28 80 00       	push   $0x802811
  801498:	e8 3b ed ff ff       	call   8001d8 <cprintf>
		return -E_INVAL;
  80149d:	83 c4 10             	add    $0x10,%esp
  8014a0:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8014a5:	eb 26                	jmp    8014cd <read+0x8a>
	}
	if (!dev->dev_read)
  8014a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014aa:	8b 40 08             	mov    0x8(%eax),%eax
  8014ad:	85 c0                	test   %eax,%eax
  8014af:	74 17                	je     8014c8 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014b1:	83 ec 04             	sub    $0x4,%esp
  8014b4:	ff 75 10             	pushl  0x10(%ebp)
  8014b7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ba:	52                   	push   %edx
  8014bb:	ff d0                	call   *%eax
  8014bd:	89 c2                	mov    %eax,%edx
  8014bf:	83 c4 10             	add    $0x10,%esp
  8014c2:	eb 09                	jmp    8014cd <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014c4:	89 c2                	mov    %eax,%edx
  8014c6:	eb 05                	jmp    8014cd <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8014c8:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  8014cd:	89 d0                	mov    %edx,%eax
  8014cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d2:	c9                   	leave  
  8014d3:	c3                   	ret    

008014d4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	57                   	push   %edi
  8014d8:	56                   	push   %esi
  8014d9:	53                   	push   %ebx
  8014da:	83 ec 0c             	sub    $0xc,%esp
  8014dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014e0:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014e8:	eb 21                	jmp    80150b <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014ea:	83 ec 04             	sub    $0x4,%esp
  8014ed:	89 f0                	mov    %esi,%eax
  8014ef:	29 d8                	sub    %ebx,%eax
  8014f1:	50                   	push   %eax
  8014f2:	89 d8                	mov    %ebx,%eax
  8014f4:	03 45 0c             	add    0xc(%ebp),%eax
  8014f7:	50                   	push   %eax
  8014f8:	57                   	push   %edi
  8014f9:	e8 45 ff ff ff       	call   801443 <read>
		if (m < 0)
  8014fe:	83 c4 10             	add    $0x10,%esp
  801501:	85 c0                	test   %eax,%eax
  801503:	78 10                	js     801515 <readn+0x41>
			return m;
		if (m == 0)
  801505:	85 c0                	test   %eax,%eax
  801507:	74 0a                	je     801513 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801509:	01 c3                	add    %eax,%ebx
  80150b:	39 f3                	cmp    %esi,%ebx
  80150d:	72 db                	jb     8014ea <readn+0x16>
  80150f:	89 d8                	mov    %ebx,%eax
  801511:	eb 02                	jmp    801515 <readn+0x41>
  801513:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801515:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801518:	5b                   	pop    %ebx
  801519:	5e                   	pop    %esi
  80151a:	5f                   	pop    %edi
  80151b:	5d                   	pop    %ebp
  80151c:	c3                   	ret    

0080151d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
  801520:	53                   	push   %ebx
  801521:	83 ec 14             	sub    $0x14,%esp
  801524:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801527:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80152a:	50                   	push   %eax
  80152b:	53                   	push   %ebx
  80152c:	e8 ad fc ff ff       	call   8011de <fd_lookup>
  801531:	83 c4 08             	add    $0x8,%esp
  801534:	89 c2                	mov    %eax,%edx
  801536:	85 c0                	test   %eax,%eax
  801538:	78 68                	js     8015a2 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80153a:	83 ec 08             	sub    $0x8,%esp
  80153d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801540:	50                   	push   %eax
  801541:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801544:	ff 30                	pushl  (%eax)
  801546:	e8 e9 fc ff ff       	call   801234 <dev_lookup>
  80154b:	83 c4 10             	add    $0x10,%esp
  80154e:	85 c0                	test   %eax,%eax
  801550:	78 47                	js     801599 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801555:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801559:	75 21                	jne    80157c <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80155b:	a1 04 40 80 00       	mov    0x804004,%eax
  801560:	8b 40 48             	mov    0x48(%eax),%eax
  801563:	83 ec 04             	sub    $0x4,%esp
  801566:	53                   	push   %ebx
  801567:	50                   	push   %eax
  801568:	68 2d 28 80 00       	push   $0x80282d
  80156d:	e8 66 ec ff ff       	call   8001d8 <cprintf>
		return -E_INVAL;
  801572:	83 c4 10             	add    $0x10,%esp
  801575:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80157a:	eb 26                	jmp    8015a2 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80157c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157f:	8b 52 0c             	mov    0xc(%edx),%edx
  801582:	85 d2                	test   %edx,%edx
  801584:	74 17                	je     80159d <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801586:	83 ec 04             	sub    $0x4,%esp
  801589:	ff 75 10             	pushl  0x10(%ebp)
  80158c:	ff 75 0c             	pushl  0xc(%ebp)
  80158f:	50                   	push   %eax
  801590:	ff d2                	call   *%edx
  801592:	89 c2                	mov    %eax,%edx
  801594:	83 c4 10             	add    $0x10,%esp
  801597:	eb 09                	jmp    8015a2 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801599:	89 c2                	mov    %eax,%edx
  80159b:	eb 05                	jmp    8015a2 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80159d:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  8015a2:	89 d0                	mov    %edx,%eax
  8015a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
  8015ac:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015af:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015b2:	50                   	push   %eax
  8015b3:	ff 75 08             	pushl  0x8(%ebp)
  8015b6:	e8 23 fc ff ff       	call   8011de <fd_lookup>
  8015bb:	83 c4 08             	add    $0x8,%esp
  8015be:	85 c0                	test   %eax,%eax
  8015c0:	78 0e                	js     8015d0 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d0:	c9                   	leave  
  8015d1:	c3                   	ret    

008015d2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
  8015d5:	53                   	push   %ebx
  8015d6:	83 ec 14             	sub    $0x14,%esp
  8015d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015dc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015df:	50                   	push   %eax
  8015e0:	53                   	push   %ebx
  8015e1:	e8 f8 fb ff ff       	call   8011de <fd_lookup>
  8015e6:	83 c4 08             	add    $0x8,%esp
  8015e9:	89 c2                	mov    %eax,%edx
  8015eb:	85 c0                	test   %eax,%eax
  8015ed:	78 65                	js     801654 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ef:	83 ec 08             	sub    $0x8,%esp
  8015f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f5:	50                   	push   %eax
  8015f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f9:	ff 30                	pushl  (%eax)
  8015fb:	e8 34 fc ff ff       	call   801234 <dev_lookup>
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	85 c0                	test   %eax,%eax
  801605:	78 44                	js     80164b <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80160e:	75 21                	jne    801631 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801610:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801615:	8b 40 48             	mov    0x48(%eax),%eax
  801618:	83 ec 04             	sub    $0x4,%esp
  80161b:	53                   	push   %ebx
  80161c:	50                   	push   %eax
  80161d:	68 f0 27 80 00       	push   $0x8027f0
  801622:	e8 b1 eb ff ff       	call   8001d8 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801627:	83 c4 10             	add    $0x10,%esp
  80162a:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80162f:	eb 23                	jmp    801654 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  801631:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801634:	8b 52 18             	mov    0x18(%edx),%edx
  801637:	85 d2                	test   %edx,%edx
  801639:	74 14                	je     80164f <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80163b:	83 ec 08             	sub    $0x8,%esp
  80163e:	ff 75 0c             	pushl  0xc(%ebp)
  801641:	50                   	push   %eax
  801642:	ff d2                	call   *%edx
  801644:	89 c2                	mov    %eax,%edx
  801646:	83 c4 10             	add    $0x10,%esp
  801649:	eb 09                	jmp    801654 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80164b:	89 c2                	mov    %eax,%edx
  80164d:	eb 05                	jmp    801654 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80164f:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  801654:	89 d0                	mov    %edx,%eax
  801656:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	53                   	push   %ebx
  80165f:	83 ec 14             	sub    $0x14,%esp
  801662:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801665:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801668:	50                   	push   %eax
  801669:	ff 75 08             	pushl  0x8(%ebp)
  80166c:	e8 6d fb ff ff       	call   8011de <fd_lookup>
  801671:	83 c4 08             	add    $0x8,%esp
  801674:	89 c2                	mov    %eax,%edx
  801676:	85 c0                	test   %eax,%eax
  801678:	78 58                	js     8016d2 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80167a:	83 ec 08             	sub    $0x8,%esp
  80167d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801680:	50                   	push   %eax
  801681:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801684:	ff 30                	pushl  (%eax)
  801686:	e8 a9 fb ff ff       	call   801234 <dev_lookup>
  80168b:	83 c4 10             	add    $0x10,%esp
  80168e:	85 c0                	test   %eax,%eax
  801690:	78 37                	js     8016c9 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  801692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801695:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801699:	74 32                	je     8016cd <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80169b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80169e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016a5:	00 00 00 
	stat->st_isdir = 0;
  8016a8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016af:	00 00 00 
	stat->st_dev = dev;
  8016b2:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016b8:	83 ec 08             	sub    $0x8,%esp
  8016bb:	53                   	push   %ebx
  8016bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8016bf:	ff 50 14             	call   *0x14(%eax)
  8016c2:	89 c2                	mov    %eax,%edx
  8016c4:	83 c4 10             	add    $0x10,%esp
  8016c7:	eb 09                	jmp    8016d2 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c9:	89 c2                	mov    %eax,%edx
  8016cb:	eb 05                	jmp    8016d2 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8016cd:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8016d2:	89 d0                	mov    %edx,%eax
  8016d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
  8016dc:	56                   	push   %esi
  8016dd:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016de:	83 ec 08             	sub    $0x8,%esp
  8016e1:	6a 00                	push   $0x0
  8016e3:	ff 75 08             	pushl  0x8(%ebp)
  8016e6:	e8 06 02 00 00       	call   8018f1 <open>
  8016eb:	89 c3                	mov    %eax,%ebx
  8016ed:	83 c4 10             	add    $0x10,%esp
  8016f0:	85 c0                	test   %eax,%eax
  8016f2:	78 1b                	js     80170f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016f4:	83 ec 08             	sub    $0x8,%esp
  8016f7:	ff 75 0c             	pushl  0xc(%ebp)
  8016fa:	50                   	push   %eax
  8016fb:	e8 5b ff ff ff       	call   80165b <fstat>
  801700:	89 c6                	mov    %eax,%esi
	close(fd);
  801702:	89 1c 24             	mov    %ebx,(%esp)
  801705:	e8 fd fb ff ff       	call   801307 <close>
	return r;
  80170a:	83 c4 10             	add    $0x10,%esp
  80170d:	89 f0                	mov    %esi,%eax
}
  80170f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801712:	5b                   	pop    %ebx
  801713:	5e                   	pop    %esi
  801714:	5d                   	pop    %ebp
  801715:	c3                   	ret    

00801716 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	56                   	push   %esi
  80171a:	53                   	push   %ebx
  80171b:	89 c6                	mov    %eax,%esi
  80171d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80171f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801726:	75 12                	jne    80173a <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801728:	83 ec 0c             	sub    $0xc,%esp
  80172b:	6a 01                	push   $0x1
  80172d:	e8 da 08 00 00       	call   80200c <ipc_find_env>
  801732:	a3 00 40 80 00       	mov    %eax,0x804000
  801737:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80173a:	6a 07                	push   $0x7
  80173c:	68 00 50 80 00       	push   $0x805000
  801741:	56                   	push   %esi
  801742:	ff 35 00 40 80 00    	pushl  0x804000
  801748:	e8 6b 08 00 00       	call   801fb8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80174d:	83 c4 0c             	add    $0xc,%esp
  801750:	6a 00                	push   $0x0
  801752:	53                   	push   %ebx
  801753:	6a 00                	push   $0x0
  801755:	e8 f3 07 00 00       	call   801f4d <ipc_recv>
}
  80175a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80175d:	5b                   	pop    %ebx
  80175e:	5e                   	pop    %esi
  80175f:	5d                   	pop    %ebp
  801760:	c3                   	ret    

00801761 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
  801764:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
  80176a:	8b 40 0c             	mov    0xc(%eax),%eax
  80176d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801772:	8b 45 0c             	mov    0xc(%ebp),%eax
  801775:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80177a:	ba 00 00 00 00       	mov    $0x0,%edx
  80177f:	b8 02 00 00 00       	mov    $0x2,%eax
  801784:	e8 8d ff ff ff       	call   801716 <fsipc>
}
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	8b 40 0c             	mov    0xc(%eax),%eax
  801797:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80179c:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a1:	b8 06 00 00 00       	mov    $0x6,%eax
  8017a6:	e8 6b ff ff ff       	call   801716 <fsipc>
}
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	53                   	push   %ebx
  8017b1:	83 ec 04             	sub    $0x4,%esp
  8017b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8017bd:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c7:	b8 05 00 00 00       	mov    $0x5,%eax
  8017cc:	e8 45 ff ff ff       	call   801716 <fsipc>
  8017d1:	85 c0                	test   %eax,%eax
  8017d3:	78 2c                	js     801801 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017d5:	83 ec 08             	sub    $0x8,%esp
  8017d8:	68 00 50 80 00       	push   $0x805000
  8017dd:	53                   	push   %ebx
  8017de:	e8 67 ef ff ff       	call   80074a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017e3:	a1 80 50 80 00       	mov    0x805080,%eax
  8017e8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017ee:	a1 84 50 80 00       	mov    0x805084,%eax
  8017f3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017f9:	83 c4 10             	add    $0x10,%esp
  8017fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801801:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 08             	sub    $0x8,%esp
  80180c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180f:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801812:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801815:	8b 49 0c             	mov    0xc(%ecx),%ecx
  801818:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  80181e:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801823:	76 22                	jbe    801847 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  801825:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  80182c:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  80182f:	83 ec 04             	sub    $0x4,%esp
  801832:	68 f8 0f 00 00       	push   $0xff8
  801837:	52                   	push   %edx
  801838:	68 08 50 80 00       	push   $0x805008
  80183d:	e8 9b f0 ff ff       	call   8008dd <memmove>
  801842:	83 c4 10             	add    $0x10,%esp
  801845:	eb 17                	jmp    80185e <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  801847:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  80184c:	83 ec 04             	sub    $0x4,%esp
  80184f:	50                   	push   %eax
  801850:	52                   	push   %edx
  801851:	68 08 50 80 00       	push   $0x805008
  801856:	e8 82 f0 ff ff       	call   8008dd <memmove>
  80185b:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  80185e:	ba 00 00 00 00       	mov    $0x0,%edx
  801863:	b8 04 00 00 00       	mov    $0x4,%eax
  801868:	e8 a9 fe ff ff       	call   801716 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	56                   	push   %esi
  801873:	53                   	push   %ebx
  801874:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	8b 40 0c             	mov    0xc(%eax),%eax
  80187d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801882:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801888:	ba 00 00 00 00       	mov    $0x0,%edx
  80188d:	b8 03 00 00 00       	mov    $0x3,%eax
  801892:	e8 7f fe ff ff       	call   801716 <fsipc>
  801897:	89 c3                	mov    %eax,%ebx
  801899:	85 c0                	test   %eax,%eax
  80189b:	78 4b                	js     8018e8 <devfile_read+0x79>
		return r;
	assert(r <= n);
  80189d:	39 c6                	cmp    %eax,%esi
  80189f:	73 16                	jae    8018b7 <devfile_read+0x48>
  8018a1:	68 5c 28 80 00       	push   $0x80285c
  8018a6:	68 63 28 80 00       	push   $0x802863
  8018ab:	6a 7c                	push   $0x7c
  8018ad:	68 78 28 80 00       	push   $0x802878
  8018b2:	e8 bd 05 00 00       	call   801e74 <_panic>
	assert(r <= PGSIZE);
  8018b7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018bc:	7e 16                	jle    8018d4 <devfile_read+0x65>
  8018be:	68 83 28 80 00       	push   $0x802883
  8018c3:	68 63 28 80 00       	push   $0x802863
  8018c8:	6a 7d                	push   $0x7d
  8018ca:	68 78 28 80 00       	push   $0x802878
  8018cf:	e8 a0 05 00 00       	call   801e74 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018d4:	83 ec 04             	sub    $0x4,%esp
  8018d7:	50                   	push   %eax
  8018d8:	68 00 50 80 00       	push   $0x805000
  8018dd:	ff 75 0c             	pushl  0xc(%ebp)
  8018e0:	e8 f8 ef ff ff       	call   8008dd <memmove>
	return r;
  8018e5:	83 c4 10             	add    $0x10,%esp
}
  8018e8:	89 d8                	mov    %ebx,%eax
  8018ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ed:	5b                   	pop    %ebx
  8018ee:	5e                   	pop    %esi
  8018ef:	5d                   	pop    %ebp
  8018f0:	c3                   	ret    

008018f1 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
  8018f4:	53                   	push   %ebx
  8018f5:	83 ec 20             	sub    $0x20,%esp
  8018f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8018fb:	53                   	push   %ebx
  8018fc:	e8 10 ee ff ff       	call   800711 <strlen>
  801901:	83 c4 10             	add    $0x10,%esp
  801904:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801909:	7f 67                	jg     801972 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80190b:	83 ec 0c             	sub    $0xc,%esp
  80190e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801911:	50                   	push   %eax
  801912:	e8 78 f8 ff ff       	call   80118f <fd_alloc>
  801917:	83 c4 10             	add    $0x10,%esp
		return r;
  80191a:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80191c:	85 c0                	test   %eax,%eax
  80191e:	78 57                	js     801977 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801920:	83 ec 08             	sub    $0x8,%esp
  801923:	53                   	push   %ebx
  801924:	68 00 50 80 00       	push   $0x805000
  801929:	e8 1c ee ff ff       	call   80074a <strcpy>
	fsipcbuf.open.req_omode = mode;
  80192e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801931:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801936:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801939:	b8 01 00 00 00       	mov    $0x1,%eax
  80193e:	e8 d3 fd ff ff       	call   801716 <fsipc>
  801943:	89 c3                	mov    %eax,%ebx
  801945:	83 c4 10             	add    $0x10,%esp
  801948:	85 c0                	test   %eax,%eax
  80194a:	79 14                	jns    801960 <open+0x6f>
		fd_close(fd, 0);
  80194c:	83 ec 08             	sub    $0x8,%esp
  80194f:	6a 00                	push   $0x0
  801951:	ff 75 f4             	pushl  -0xc(%ebp)
  801954:	e8 2e f9 ff ff       	call   801287 <fd_close>
		return r;
  801959:	83 c4 10             	add    $0x10,%esp
  80195c:	89 da                	mov    %ebx,%edx
  80195e:	eb 17                	jmp    801977 <open+0x86>
	}

	return fd2num(fd);
  801960:	83 ec 0c             	sub    $0xc,%esp
  801963:	ff 75 f4             	pushl  -0xc(%ebp)
  801966:	e8 fc f7 ff ff       	call   801167 <fd2num>
  80196b:	89 c2                	mov    %eax,%edx
  80196d:	83 c4 10             	add    $0x10,%esp
  801970:	eb 05                	jmp    801977 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801972:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801977:	89 d0                	mov    %edx,%eax
  801979:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
  801981:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801984:	ba 00 00 00 00       	mov    $0x0,%edx
  801989:	b8 08 00 00 00       	mov    $0x8,%eax
  80198e:	e8 83 fd ff ff       	call   801716 <fsipc>
}
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
  801998:	56                   	push   %esi
  801999:	53                   	push   %ebx
  80199a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80199d:	83 ec 0c             	sub    $0xc,%esp
  8019a0:	ff 75 08             	pushl  0x8(%ebp)
  8019a3:	e8 cf f7 ff ff       	call   801177 <fd2data>
  8019a8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8019aa:	83 c4 08             	add    $0x8,%esp
  8019ad:	68 8f 28 80 00       	push   $0x80288f
  8019b2:	53                   	push   %ebx
  8019b3:	e8 92 ed ff ff       	call   80074a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8019b8:	8b 46 04             	mov    0x4(%esi),%eax
  8019bb:	2b 06                	sub    (%esi),%eax
  8019bd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8019c3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019ca:	00 00 00 
	stat->st_dev = &devpipe;
  8019cd:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8019d4:	30 80 00 
	return 0;
}
  8019d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019df:	5b                   	pop    %ebx
  8019e0:	5e                   	pop    %esi
  8019e1:	5d                   	pop    %ebp
  8019e2:	c3                   	ret    

008019e3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	53                   	push   %ebx
  8019e7:	83 ec 0c             	sub    $0xc,%esp
  8019ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8019ed:	53                   	push   %ebx
  8019ee:	6a 00                	push   $0x0
  8019f0:	e8 e8 f1 ff ff       	call   800bdd <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8019f5:	89 1c 24             	mov    %ebx,(%esp)
  8019f8:	e8 7a f7 ff ff       	call   801177 <fd2data>
  8019fd:	83 c4 08             	add    $0x8,%esp
  801a00:	50                   	push   %eax
  801a01:	6a 00                	push   $0x0
  801a03:	e8 d5 f1 ff ff       	call   800bdd <sys_page_unmap>
}
  801a08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	57                   	push   %edi
  801a11:	56                   	push   %esi
  801a12:	53                   	push   %ebx
  801a13:	83 ec 1c             	sub    $0x1c,%esp
  801a16:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801a19:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801a1b:	a1 04 40 80 00       	mov    0x804004,%eax
  801a20:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801a23:	83 ec 0c             	sub    $0xc,%esp
  801a26:	ff 75 e0             	pushl  -0x20(%ebp)
  801a29:	e8 17 06 00 00       	call   802045 <pageref>
  801a2e:	89 c3                	mov    %eax,%ebx
  801a30:	89 3c 24             	mov    %edi,(%esp)
  801a33:	e8 0d 06 00 00       	call   802045 <pageref>
  801a38:	83 c4 10             	add    $0x10,%esp
  801a3b:	39 c3                	cmp    %eax,%ebx
  801a3d:	0f 94 c1             	sete   %cl
  801a40:	0f b6 c9             	movzbl %cl,%ecx
  801a43:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801a46:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a4c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a4f:	39 ce                	cmp    %ecx,%esi
  801a51:	74 1b                	je     801a6e <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801a53:	39 c3                	cmp    %eax,%ebx
  801a55:	75 c4                	jne    801a1b <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a57:	8b 42 58             	mov    0x58(%edx),%eax
  801a5a:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a5d:	50                   	push   %eax
  801a5e:	56                   	push   %esi
  801a5f:	68 96 28 80 00       	push   $0x802896
  801a64:	e8 6f e7 ff ff       	call   8001d8 <cprintf>
  801a69:	83 c4 10             	add    $0x10,%esp
  801a6c:	eb ad                	jmp    801a1b <_pipeisclosed+0xe>
	}
}
  801a6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a74:	5b                   	pop    %ebx
  801a75:	5e                   	pop    %esi
  801a76:	5f                   	pop    %edi
  801a77:	5d                   	pop    %ebp
  801a78:	c3                   	ret    

00801a79 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
  801a7c:	57                   	push   %edi
  801a7d:	56                   	push   %esi
  801a7e:	53                   	push   %ebx
  801a7f:	83 ec 28             	sub    $0x28,%esp
  801a82:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801a85:	56                   	push   %esi
  801a86:	e8 ec f6 ff ff       	call   801177 <fd2data>
  801a8b:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a8d:	83 c4 10             	add    $0x10,%esp
  801a90:	bf 00 00 00 00       	mov    $0x0,%edi
  801a95:	eb 4b                	jmp    801ae2 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801a97:	89 da                	mov    %ebx,%edx
  801a99:	89 f0                	mov    %esi,%eax
  801a9b:	e8 6d ff ff ff       	call   801a0d <_pipeisclosed>
  801aa0:	85 c0                	test   %eax,%eax
  801aa2:	75 48                	jne    801aec <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801aa4:	e8 c3 f0 ff ff       	call   800b6c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801aa9:	8b 43 04             	mov    0x4(%ebx),%eax
  801aac:	8b 0b                	mov    (%ebx),%ecx
  801aae:	8d 51 20             	lea    0x20(%ecx),%edx
  801ab1:	39 d0                	cmp    %edx,%eax
  801ab3:	73 e2                	jae    801a97 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ab5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ab8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801abc:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801abf:	89 c2                	mov    %eax,%edx
  801ac1:	c1 fa 1f             	sar    $0x1f,%edx
  801ac4:	89 d1                	mov    %edx,%ecx
  801ac6:	c1 e9 1b             	shr    $0x1b,%ecx
  801ac9:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801acc:	83 e2 1f             	and    $0x1f,%edx
  801acf:	29 ca                	sub    %ecx,%edx
  801ad1:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ad5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ad9:	83 c0 01             	add    $0x1,%eax
  801adc:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801adf:	83 c7 01             	add    $0x1,%edi
  801ae2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ae5:	75 c2                	jne    801aa9 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801ae7:	8b 45 10             	mov    0x10(%ebp),%eax
  801aea:	eb 05                	jmp    801af1 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801aec:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801af1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801af4:	5b                   	pop    %ebx
  801af5:	5e                   	pop    %esi
  801af6:	5f                   	pop    %edi
  801af7:	5d                   	pop    %ebp
  801af8:	c3                   	ret    

00801af9 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
  801afc:	57                   	push   %edi
  801afd:	56                   	push   %esi
  801afe:	53                   	push   %ebx
  801aff:	83 ec 18             	sub    $0x18,%esp
  801b02:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801b05:	57                   	push   %edi
  801b06:	e8 6c f6 ff ff       	call   801177 <fd2data>
  801b0b:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b0d:	83 c4 10             	add    $0x10,%esp
  801b10:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b15:	eb 3d                	jmp    801b54 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801b17:	85 db                	test   %ebx,%ebx
  801b19:	74 04                	je     801b1f <devpipe_read+0x26>
				return i;
  801b1b:	89 d8                	mov    %ebx,%eax
  801b1d:	eb 44                	jmp    801b63 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801b1f:	89 f2                	mov    %esi,%edx
  801b21:	89 f8                	mov    %edi,%eax
  801b23:	e8 e5 fe ff ff       	call   801a0d <_pipeisclosed>
  801b28:	85 c0                	test   %eax,%eax
  801b2a:	75 32                	jne    801b5e <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801b2c:	e8 3b f0 ff ff       	call   800b6c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801b31:	8b 06                	mov    (%esi),%eax
  801b33:	3b 46 04             	cmp    0x4(%esi),%eax
  801b36:	74 df                	je     801b17 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b38:	99                   	cltd   
  801b39:	c1 ea 1b             	shr    $0x1b,%edx
  801b3c:	01 d0                	add    %edx,%eax
  801b3e:	83 e0 1f             	and    $0x1f,%eax
  801b41:	29 d0                	sub    %edx,%eax
  801b43:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801b48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b4b:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801b4e:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b51:	83 c3 01             	add    $0x1,%ebx
  801b54:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801b57:	75 d8                	jne    801b31 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801b59:	8b 45 10             	mov    0x10(%ebp),%eax
  801b5c:	eb 05                	jmp    801b63 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801b5e:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801b63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b66:	5b                   	pop    %ebx
  801b67:	5e                   	pop    %esi
  801b68:	5f                   	pop    %edi
  801b69:	5d                   	pop    %ebp
  801b6a:	c3                   	ret    

00801b6b <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
  801b6e:	56                   	push   %esi
  801b6f:	53                   	push   %ebx
  801b70:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801b73:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b76:	50                   	push   %eax
  801b77:	e8 13 f6 ff ff       	call   80118f <fd_alloc>
  801b7c:	83 c4 10             	add    $0x10,%esp
  801b7f:	89 c2                	mov    %eax,%edx
  801b81:	85 c0                	test   %eax,%eax
  801b83:	0f 88 2c 01 00 00    	js     801cb5 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b89:	83 ec 04             	sub    $0x4,%esp
  801b8c:	68 07 04 00 00       	push   $0x407
  801b91:	ff 75 f4             	pushl  -0xc(%ebp)
  801b94:	6a 00                	push   $0x0
  801b96:	e8 f8 ef ff ff       	call   800b93 <sys_page_alloc>
  801b9b:	83 c4 10             	add    $0x10,%esp
  801b9e:	89 c2                	mov    %eax,%edx
  801ba0:	85 c0                	test   %eax,%eax
  801ba2:	0f 88 0d 01 00 00    	js     801cb5 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801ba8:	83 ec 0c             	sub    $0xc,%esp
  801bab:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bae:	50                   	push   %eax
  801baf:	e8 db f5 ff ff       	call   80118f <fd_alloc>
  801bb4:	89 c3                	mov    %eax,%ebx
  801bb6:	83 c4 10             	add    $0x10,%esp
  801bb9:	85 c0                	test   %eax,%eax
  801bbb:	0f 88 e2 00 00 00    	js     801ca3 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bc1:	83 ec 04             	sub    $0x4,%esp
  801bc4:	68 07 04 00 00       	push   $0x407
  801bc9:	ff 75 f0             	pushl  -0x10(%ebp)
  801bcc:	6a 00                	push   $0x0
  801bce:	e8 c0 ef ff ff       	call   800b93 <sys_page_alloc>
  801bd3:	89 c3                	mov    %eax,%ebx
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	85 c0                	test   %eax,%eax
  801bda:	0f 88 c3 00 00 00    	js     801ca3 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801be0:	83 ec 0c             	sub    $0xc,%esp
  801be3:	ff 75 f4             	pushl  -0xc(%ebp)
  801be6:	e8 8c f5 ff ff       	call   801177 <fd2data>
  801beb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bed:	83 c4 0c             	add    $0xc,%esp
  801bf0:	68 07 04 00 00       	push   $0x407
  801bf5:	50                   	push   %eax
  801bf6:	6a 00                	push   $0x0
  801bf8:	e8 96 ef ff ff       	call   800b93 <sys_page_alloc>
  801bfd:	89 c3                	mov    %eax,%ebx
  801bff:	83 c4 10             	add    $0x10,%esp
  801c02:	85 c0                	test   %eax,%eax
  801c04:	0f 88 89 00 00 00    	js     801c93 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c0a:	83 ec 0c             	sub    $0xc,%esp
  801c0d:	ff 75 f0             	pushl  -0x10(%ebp)
  801c10:	e8 62 f5 ff ff       	call   801177 <fd2data>
  801c15:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c1c:	50                   	push   %eax
  801c1d:	6a 00                	push   $0x0
  801c1f:	56                   	push   %esi
  801c20:	6a 00                	push   $0x0
  801c22:	e8 90 ef ff ff       	call   800bb7 <sys_page_map>
  801c27:	89 c3                	mov    %eax,%ebx
  801c29:	83 c4 20             	add    $0x20,%esp
  801c2c:	85 c0                	test   %eax,%eax
  801c2e:	78 55                	js     801c85 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801c30:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c39:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801c45:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c4e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801c50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c53:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801c5a:	83 ec 0c             	sub    $0xc,%esp
  801c5d:	ff 75 f4             	pushl  -0xc(%ebp)
  801c60:	e8 02 f5 ff ff       	call   801167 <fd2num>
  801c65:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c68:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c6a:	83 c4 04             	add    $0x4,%esp
  801c6d:	ff 75 f0             	pushl  -0x10(%ebp)
  801c70:	e8 f2 f4 ff ff       	call   801167 <fd2num>
  801c75:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c78:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c7b:	83 c4 10             	add    $0x10,%esp
  801c7e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c83:	eb 30                	jmp    801cb5 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801c85:	83 ec 08             	sub    $0x8,%esp
  801c88:	56                   	push   %esi
  801c89:	6a 00                	push   $0x0
  801c8b:	e8 4d ef ff ff       	call   800bdd <sys_page_unmap>
  801c90:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801c93:	83 ec 08             	sub    $0x8,%esp
  801c96:	ff 75 f0             	pushl  -0x10(%ebp)
  801c99:	6a 00                	push   $0x0
  801c9b:	e8 3d ef ff ff       	call   800bdd <sys_page_unmap>
  801ca0:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801ca3:	83 ec 08             	sub    $0x8,%esp
  801ca6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca9:	6a 00                	push   $0x0
  801cab:	e8 2d ef ff ff       	call   800bdd <sys_page_unmap>
  801cb0:	83 c4 10             	add    $0x10,%esp
  801cb3:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  801cb5:	89 d0                	mov    %edx,%eax
  801cb7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cba:	5b                   	pop    %ebx
  801cbb:	5e                   	pop    %esi
  801cbc:	5d                   	pop    %ebp
  801cbd:	c3                   	ret    

00801cbe <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
  801cc1:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cc7:	50                   	push   %eax
  801cc8:	ff 75 08             	pushl  0x8(%ebp)
  801ccb:	e8 0e f5 ff ff       	call   8011de <fd_lookup>
  801cd0:	83 c4 10             	add    $0x10,%esp
  801cd3:	85 c0                	test   %eax,%eax
  801cd5:	78 18                	js     801cef <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801cd7:	83 ec 0c             	sub    $0xc,%esp
  801cda:	ff 75 f4             	pushl  -0xc(%ebp)
  801cdd:	e8 95 f4 ff ff       	call   801177 <fd2data>
	return _pipeisclosed(fd, p);
  801ce2:	89 c2                	mov    %eax,%edx
  801ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce7:	e8 21 fd ff ff       	call   801a0d <_pipeisclosed>
  801cec:	83 c4 10             	add    $0x10,%esp
}
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    

00801cf1 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf9:	5d                   	pop    %ebp
  801cfa:	c3                   	ret    

00801cfb <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
  801cfe:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801d01:	68 ae 28 80 00       	push   $0x8028ae
  801d06:	ff 75 0c             	pushl  0xc(%ebp)
  801d09:	e8 3c ea ff ff       	call   80074a <strcpy>
	return 0;
}
  801d0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	57                   	push   %edi
  801d19:	56                   	push   %esi
  801d1a:	53                   	push   %ebx
  801d1b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d21:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801d26:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d2c:	eb 2d                	jmp    801d5b <devcons_write+0x46>
		m = n - tot;
  801d2e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d31:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801d33:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801d36:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801d3b:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801d3e:	83 ec 04             	sub    $0x4,%esp
  801d41:	53                   	push   %ebx
  801d42:	03 45 0c             	add    0xc(%ebp),%eax
  801d45:	50                   	push   %eax
  801d46:	57                   	push   %edi
  801d47:	e8 91 eb ff ff       	call   8008dd <memmove>
		sys_cputs(buf, m);
  801d4c:	83 c4 08             	add    $0x8,%esp
  801d4f:	53                   	push   %ebx
  801d50:	57                   	push   %edi
  801d51:	e8 86 ed ff ff       	call   800adc <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d56:	01 de                	add    %ebx,%esi
  801d58:	83 c4 10             	add    $0x10,%esp
  801d5b:	89 f0                	mov    %esi,%eax
  801d5d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d60:	72 cc                	jb     801d2e <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801d62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d65:	5b                   	pop    %ebx
  801d66:	5e                   	pop    %esi
  801d67:	5f                   	pop    %edi
  801d68:	5d                   	pop    %ebp
  801d69:	c3                   	ret    

00801d6a <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	83 ec 08             	sub    $0x8,%esp
  801d70:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801d75:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d79:	74 2a                	je     801da5 <devcons_read+0x3b>
  801d7b:	eb 05                	jmp    801d82 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801d7d:	e8 ea ed ff ff       	call   800b6c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801d82:	e8 7b ed ff ff       	call   800b02 <sys_cgetc>
  801d87:	85 c0                	test   %eax,%eax
  801d89:	74 f2                	je     801d7d <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801d8b:	85 c0                	test   %eax,%eax
  801d8d:	78 16                	js     801da5 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801d8f:	83 f8 04             	cmp    $0x4,%eax
  801d92:	74 0c                	je     801da0 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801d94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d97:	88 02                	mov    %al,(%edx)
	return 1;
  801d99:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9e:	eb 05                	jmp    801da5 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801da0:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
  801daa:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801dad:	8b 45 08             	mov    0x8(%ebp),%eax
  801db0:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801db3:	6a 01                	push   $0x1
  801db5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801db8:	50                   	push   %eax
  801db9:	e8 1e ed ff ff       	call   800adc <sys_cputs>
}
  801dbe:	83 c4 10             	add    $0x10,%esp
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <getchar>:

int
getchar(void)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801dc9:	6a 01                	push   $0x1
  801dcb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801dce:	50                   	push   %eax
  801dcf:	6a 00                	push   $0x0
  801dd1:	e8 6d f6 ff ff       	call   801443 <read>
	if (r < 0)
  801dd6:	83 c4 10             	add    $0x10,%esp
  801dd9:	85 c0                	test   %eax,%eax
  801ddb:	78 0f                	js     801dec <getchar+0x29>
		return r;
	if (r < 1)
  801ddd:	85 c0                	test   %eax,%eax
  801ddf:	7e 06                	jle    801de7 <getchar+0x24>
		return -E_EOF;
	return c;
  801de1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801de5:	eb 05                	jmp    801dec <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801de7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801df4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801df7:	50                   	push   %eax
  801df8:	ff 75 08             	pushl  0x8(%ebp)
  801dfb:	e8 de f3 ff ff       	call   8011de <fd_lookup>
  801e00:	83 c4 10             	add    $0x10,%esp
  801e03:	85 c0                	test   %eax,%eax
  801e05:	78 11                	js     801e18 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e10:	39 10                	cmp    %edx,(%eax)
  801e12:	0f 94 c0             	sete   %al
  801e15:	0f b6 c0             	movzbl %al,%eax
}
  801e18:	c9                   	leave  
  801e19:	c3                   	ret    

00801e1a <opencons>:

int
opencons(void)
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
  801e1d:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801e20:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e23:	50                   	push   %eax
  801e24:	e8 66 f3 ff ff       	call   80118f <fd_alloc>
  801e29:	83 c4 10             	add    $0x10,%esp
		return r;
  801e2c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801e2e:	85 c0                	test   %eax,%eax
  801e30:	78 3e                	js     801e70 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e32:	83 ec 04             	sub    $0x4,%esp
  801e35:	68 07 04 00 00       	push   $0x407
  801e3a:	ff 75 f4             	pushl  -0xc(%ebp)
  801e3d:	6a 00                	push   $0x0
  801e3f:	e8 4f ed ff ff       	call   800b93 <sys_page_alloc>
  801e44:	83 c4 10             	add    $0x10,%esp
		return r;
  801e47:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e49:	85 c0                	test   %eax,%eax
  801e4b:	78 23                	js     801e70 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801e4d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e56:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e62:	83 ec 0c             	sub    $0xc,%esp
  801e65:	50                   	push   %eax
  801e66:	e8 fc f2 ff ff       	call   801167 <fd2num>
  801e6b:	89 c2                	mov    %eax,%edx
  801e6d:	83 c4 10             	add    $0x10,%esp
}
  801e70:	89 d0                	mov    %edx,%eax
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
  801e77:	56                   	push   %esi
  801e78:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801e79:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801e7c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801e82:	e8 c1 ec ff ff       	call   800b48 <sys_getenvid>
  801e87:	83 ec 0c             	sub    $0xc,%esp
  801e8a:	ff 75 0c             	pushl  0xc(%ebp)
  801e8d:	ff 75 08             	pushl  0x8(%ebp)
  801e90:	56                   	push   %esi
  801e91:	50                   	push   %eax
  801e92:	68 bc 28 80 00       	push   $0x8028bc
  801e97:	e8 3c e3 ff ff       	call   8001d8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801e9c:	83 c4 18             	add    $0x18,%esp
  801e9f:	53                   	push   %ebx
  801ea0:	ff 75 10             	pushl  0x10(%ebp)
  801ea3:	e8 df e2 ff ff       	call   800187 <vcprintf>
	cprintf("\n");
  801ea8:	c7 04 24 2f 23 80 00 	movl   $0x80232f,(%esp)
  801eaf:	e8 24 e3 ff ff       	call   8001d8 <cprintf>
  801eb4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801eb7:	cc                   	int3   
  801eb8:	eb fd                	jmp    801eb7 <_panic+0x43>

00801eba <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801ec0:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801ec7:	75 2c                	jne    801ef5 <set_pgfault_handler+0x3b>
		// First time through!
		// LAB 4: Your code here.
		r = sys_page_alloc(0,(void *)(UXSTACKTOP - PGSIZE),PTE_P | PTE_U | PTE_W);
  801ec9:	83 ec 04             	sub    $0x4,%esp
  801ecc:	6a 07                	push   $0x7
  801ece:	68 00 f0 bf ee       	push   $0xeebff000
  801ed3:	6a 00                	push   $0x0
  801ed5:	e8 b9 ec ff ff       	call   800b93 <sys_page_alloc>
		if(r < 0)
  801eda:	83 c4 10             	add    $0x10,%esp
  801edd:	85 c0                	test   %eax,%eax
  801edf:	79 14                	jns    801ef5 <set_pgfault_handler+0x3b>
			panic("set_pgfault_handler: error in sys_page_alloc\n");	
  801ee1:	83 ec 04             	sub    $0x4,%esp
  801ee4:	68 e0 28 80 00       	push   $0x8028e0
  801ee9:	6a 22                	push   $0x22
  801eeb:	68 4c 29 80 00       	push   $0x80294c
  801ef0:	e8 7f ff ff ff       	call   801e74 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef8:	a3 00 60 80 00       	mov    %eax,0x806000
	r = sys_env_set_pgfault_upcall(0, _pgfault_upcall); 
  801efd:	83 ec 08             	sub    $0x8,%esp
  801f00:	68 29 1f 80 00       	push   $0x801f29
  801f05:	6a 00                	push   $0x0
  801f07:	e8 3a ed ff ff       	call   800c46 <sys_env_set_pgfault_upcall>
	if (r < 0)
  801f0c:	83 c4 10             	add    $0x10,%esp
  801f0f:	85 c0                	test   %eax,%eax
  801f11:	79 14                	jns    801f27 <set_pgfault_handler+0x6d>
		panic("set_pgfault_handler: error in sys_env_set_pgfault_upcall");
  801f13:	83 ec 04             	sub    $0x4,%esp
  801f16:	68 10 29 80 00       	push   $0x802910
  801f1b:	6a 29                	push   $0x29
  801f1d:	68 4c 29 80 00       	push   $0x80294c
  801f22:	e8 4d ff ff ff       	call   801e74 <_panic>
}
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801f29:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801f2a:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801f2f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801f31:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	subl $0x4, 0x30(%esp)
  801f34:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  801f39:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 0x28(%esp), %ebx 	
  801f3d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  801f41:	89 18                	mov    %ebx,(%eax)
	addl $0x8, %esp
  801f43:	83 c4 08             	add    $0x8,%esp


	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  801f46:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp 
  801f47:	83 c4 04             	add    $0x4,%esp
	popfl
  801f4a:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801f4b:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801f4c:	c3                   	ret    

00801f4d <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	56                   	push   %esi
  801f51:	53                   	push   %ebx
  801f52:	8b 75 08             	mov    0x8(%ebp),%esi
  801f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f58:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801f5b:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801f5d:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801f62:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801f65:	83 ec 0c             	sub    $0xc,%esp
  801f68:	50                   	push   %eax
  801f69:	e8 20 ed ff ff       	call   800c8e <sys_ipc_recv>
	if (from_env_store)
  801f6e:	83 c4 10             	add    $0x10,%esp
  801f71:	85 f6                	test   %esi,%esi
  801f73:	74 0b                	je     801f80 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801f75:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801f7b:	8b 52 74             	mov    0x74(%edx),%edx
  801f7e:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801f80:	85 db                	test   %ebx,%ebx
  801f82:	74 0b                	je     801f8f <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  801f84:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801f8a:	8b 52 78             	mov    0x78(%edx),%edx
  801f8d:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  801f8f:	85 c0                	test   %eax,%eax
  801f91:	79 16                	jns    801fa9 <ipc_recv+0x5c>
		if (from_env_store)
  801f93:	85 f6                	test   %esi,%esi
  801f95:	74 06                	je     801f9d <ipc_recv+0x50>
			*from_env_store = 0;
  801f97:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  801f9d:	85 db                	test   %ebx,%ebx
  801f9f:	74 10                	je     801fb1 <ipc_recv+0x64>
			*perm_store = 0;
  801fa1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801fa7:	eb 08                	jmp    801fb1 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  801fa9:	a1 04 40 80 00       	mov    0x804004,%eax
  801fae:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fb1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fb4:	5b                   	pop    %ebx
  801fb5:	5e                   	pop    %esi
  801fb6:	5d                   	pop    %ebp
  801fb7:	c3                   	ret    

00801fb8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
  801fbb:	57                   	push   %edi
  801fbc:	56                   	push   %esi
  801fbd:	53                   	push   %ebx
  801fbe:	83 ec 0c             	sub    $0xc,%esp
  801fc1:	8b 7d 08             	mov    0x8(%ebp),%edi
  801fc4:	8b 75 0c             	mov    0xc(%ebp),%esi
  801fc7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  801fca:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  801fcc:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801fd1:	0f 44 d8             	cmove  %eax,%ebx
  801fd4:	eb 1c                	jmp    801ff2 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  801fd6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801fd9:	74 12                	je     801fed <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801fdb:	50                   	push   %eax
  801fdc:	68 5a 29 80 00       	push   $0x80295a
  801fe1:	6a 42                	push   $0x42
  801fe3:	68 70 29 80 00       	push   $0x802970
  801fe8:	e8 87 fe ff ff       	call   801e74 <_panic>
		sys_yield();
  801fed:	e8 7a eb ff ff       	call   800b6c <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801ff2:	ff 75 14             	pushl  0x14(%ebp)
  801ff5:	53                   	push   %ebx
  801ff6:	56                   	push   %esi
  801ff7:	57                   	push   %edi
  801ff8:	e8 6c ec ff ff       	call   800c69 <sys_ipc_try_send>
  801ffd:	83 c4 10             	add    $0x10,%esp
  802000:	85 c0                	test   %eax,%eax
  802002:	75 d2                	jne    801fd6 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  802004:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802007:	5b                   	pop    %ebx
  802008:	5e                   	pop    %esi
  802009:	5f                   	pop    %edi
  80200a:	5d                   	pop    %ebp
  80200b:	c3                   	ret    

0080200c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
  80200f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802012:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802017:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80201a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802020:	8b 52 50             	mov    0x50(%edx),%edx
  802023:	39 ca                	cmp    %ecx,%edx
  802025:	75 0d                	jne    802034 <ipc_find_env+0x28>
			return envs[i].env_id;
  802027:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80202a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80202f:	8b 40 48             	mov    0x48(%eax),%eax
  802032:	eb 0f                	jmp    802043 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802034:	83 c0 01             	add    $0x1,%eax
  802037:	3d 00 04 00 00       	cmp    $0x400,%eax
  80203c:	75 d9                	jne    802017 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80203e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802043:	5d                   	pop    %ebp
  802044:	c3                   	ret    

00802045 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80204b:	89 d0                	mov    %edx,%eax
  80204d:	c1 e8 16             	shr    $0x16,%eax
  802050:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802057:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80205c:	f6 c1 01             	test   $0x1,%cl
  80205f:	74 1d                	je     80207e <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802061:	c1 ea 0c             	shr    $0xc,%edx
  802064:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80206b:	f6 c2 01             	test   $0x1,%dl
  80206e:	74 0e                	je     80207e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802070:	c1 ea 0c             	shr    $0xc,%edx
  802073:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80207a:	ef 
  80207b:	0f b7 c0             	movzwl %ax,%eax
}
  80207e:	5d                   	pop    %ebp
  80207f:	c3                   	ret    

00802080 <__udivdi3>:
  802080:	55                   	push   %ebp
  802081:	57                   	push   %edi
  802082:	56                   	push   %esi
  802083:	53                   	push   %ebx
  802084:	83 ec 1c             	sub    $0x1c,%esp
  802087:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80208b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80208f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802093:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802097:	85 f6                	test   %esi,%esi
  802099:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80209d:	89 ca                	mov    %ecx,%edx
  80209f:	89 f8                	mov    %edi,%eax
  8020a1:	75 3d                	jne    8020e0 <__udivdi3+0x60>
  8020a3:	39 cf                	cmp    %ecx,%edi
  8020a5:	0f 87 c5 00 00 00    	ja     802170 <__udivdi3+0xf0>
  8020ab:	85 ff                	test   %edi,%edi
  8020ad:	89 fd                	mov    %edi,%ebp
  8020af:	75 0b                	jne    8020bc <__udivdi3+0x3c>
  8020b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b6:	31 d2                	xor    %edx,%edx
  8020b8:	f7 f7                	div    %edi
  8020ba:	89 c5                	mov    %eax,%ebp
  8020bc:	89 c8                	mov    %ecx,%eax
  8020be:	31 d2                	xor    %edx,%edx
  8020c0:	f7 f5                	div    %ebp
  8020c2:	89 c1                	mov    %eax,%ecx
  8020c4:	89 d8                	mov    %ebx,%eax
  8020c6:	89 cf                	mov    %ecx,%edi
  8020c8:	f7 f5                	div    %ebp
  8020ca:	89 c3                	mov    %eax,%ebx
  8020cc:	89 d8                	mov    %ebx,%eax
  8020ce:	89 fa                	mov    %edi,%edx
  8020d0:	83 c4 1c             	add    $0x1c,%esp
  8020d3:	5b                   	pop    %ebx
  8020d4:	5e                   	pop    %esi
  8020d5:	5f                   	pop    %edi
  8020d6:	5d                   	pop    %ebp
  8020d7:	c3                   	ret    
  8020d8:	90                   	nop
  8020d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020e0:	39 ce                	cmp    %ecx,%esi
  8020e2:	77 74                	ja     802158 <__udivdi3+0xd8>
  8020e4:	0f bd fe             	bsr    %esi,%edi
  8020e7:	83 f7 1f             	xor    $0x1f,%edi
  8020ea:	0f 84 98 00 00 00    	je     802188 <__udivdi3+0x108>
  8020f0:	bb 20 00 00 00       	mov    $0x20,%ebx
  8020f5:	89 f9                	mov    %edi,%ecx
  8020f7:	89 c5                	mov    %eax,%ebp
  8020f9:	29 fb                	sub    %edi,%ebx
  8020fb:	d3 e6                	shl    %cl,%esi
  8020fd:	89 d9                	mov    %ebx,%ecx
  8020ff:	d3 ed                	shr    %cl,%ebp
  802101:	89 f9                	mov    %edi,%ecx
  802103:	d3 e0                	shl    %cl,%eax
  802105:	09 ee                	or     %ebp,%esi
  802107:	89 d9                	mov    %ebx,%ecx
  802109:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80210d:	89 d5                	mov    %edx,%ebp
  80210f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802113:	d3 ed                	shr    %cl,%ebp
  802115:	89 f9                	mov    %edi,%ecx
  802117:	d3 e2                	shl    %cl,%edx
  802119:	89 d9                	mov    %ebx,%ecx
  80211b:	d3 e8                	shr    %cl,%eax
  80211d:	09 c2                	or     %eax,%edx
  80211f:	89 d0                	mov    %edx,%eax
  802121:	89 ea                	mov    %ebp,%edx
  802123:	f7 f6                	div    %esi
  802125:	89 d5                	mov    %edx,%ebp
  802127:	89 c3                	mov    %eax,%ebx
  802129:	f7 64 24 0c          	mull   0xc(%esp)
  80212d:	39 d5                	cmp    %edx,%ebp
  80212f:	72 10                	jb     802141 <__udivdi3+0xc1>
  802131:	8b 74 24 08          	mov    0x8(%esp),%esi
  802135:	89 f9                	mov    %edi,%ecx
  802137:	d3 e6                	shl    %cl,%esi
  802139:	39 c6                	cmp    %eax,%esi
  80213b:	73 07                	jae    802144 <__udivdi3+0xc4>
  80213d:	39 d5                	cmp    %edx,%ebp
  80213f:	75 03                	jne    802144 <__udivdi3+0xc4>
  802141:	83 eb 01             	sub    $0x1,%ebx
  802144:	31 ff                	xor    %edi,%edi
  802146:	89 d8                	mov    %ebx,%eax
  802148:	89 fa                	mov    %edi,%edx
  80214a:	83 c4 1c             	add    $0x1c,%esp
  80214d:	5b                   	pop    %ebx
  80214e:	5e                   	pop    %esi
  80214f:	5f                   	pop    %edi
  802150:	5d                   	pop    %ebp
  802151:	c3                   	ret    
  802152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802158:	31 ff                	xor    %edi,%edi
  80215a:	31 db                	xor    %ebx,%ebx
  80215c:	89 d8                	mov    %ebx,%eax
  80215e:	89 fa                	mov    %edi,%edx
  802160:	83 c4 1c             	add    $0x1c,%esp
  802163:	5b                   	pop    %ebx
  802164:	5e                   	pop    %esi
  802165:	5f                   	pop    %edi
  802166:	5d                   	pop    %ebp
  802167:	c3                   	ret    
  802168:	90                   	nop
  802169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802170:	89 d8                	mov    %ebx,%eax
  802172:	f7 f7                	div    %edi
  802174:	31 ff                	xor    %edi,%edi
  802176:	89 c3                	mov    %eax,%ebx
  802178:	89 d8                	mov    %ebx,%eax
  80217a:	89 fa                	mov    %edi,%edx
  80217c:	83 c4 1c             	add    $0x1c,%esp
  80217f:	5b                   	pop    %ebx
  802180:	5e                   	pop    %esi
  802181:	5f                   	pop    %edi
  802182:	5d                   	pop    %ebp
  802183:	c3                   	ret    
  802184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802188:	39 ce                	cmp    %ecx,%esi
  80218a:	72 0c                	jb     802198 <__udivdi3+0x118>
  80218c:	31 db                	xor    %ebx,%ebx
  80218e:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802192:	0f 87 34 ff ff ff    	ja     8020cc <__udivdi3+0x4c>
  802198:	bb 01 00 00 00       	mov    $0x1,%ebx
  80219d:	e9 2a ff ff ff       	jmp    8020cc <__udivdi3+0x4c>
  8021a2:	66 90                	xchg   %ax,%ax
  8021a4:	66 90                	xchg   %ax,%ax
  8021a6:	66 90                	xchg   %ax,%ax
  8021a8:	66 90                	xchg   %ax,%ax
  8021aa:	66 90                	xchg   %ax,%ax
  8021ac:	66 90                	xchg   %ax,%ax
  8021ae:	66 90                	xchg   %ax,%ax

008021b0 <__umoddi3>:
  8021b0:	55                   	push   %ebp
  8021b1:	57                   	push   %edi
  8021b2:	56                   	push   %esi
  8021b3:	53                   	push   %ebx
  8021b4:	83 ec 1c             	sub    $0x1c,%esp
  8021b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8021bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021c7:	85 d2                	test   %edx,%edx
  8021c9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8021cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021d1:	89 f3                	mov    %esi,%ebx
  8021d3:	89 3c 24             	mov    %edi,(%esp)
  8021d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021da:	75 1c                	jne    8021f8 <__umoddi3+0x48>
  8021dc:	39 f7                	cmp    %esi,%edi
  8021de:	76 50                	jbe    802230 <__umoddi3+0x80>
  8021e0:	89 c8                	mov    %ecx,%eax
  8021e2:	89 f2                	mov    %esi,%edx
  8021e4:	f7 f7                	div    %edi
  8021e6:	89 d0                	mov    %edx,%eax
  8021e8:	31 d2                	xor    %edx,%edx
  8021ea:	83 c4 1c             	add    $0x1c,%esp
  8021ed:	5b                   	pop    %ebx
  8021ee:	5e                   	pop    %esi
  8021ef:	5f                   	pop    %edi
  8021f0:	5d                   	pop    %ebp
  8021f1:	c3                   	ret    
  8021f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021f8:	39 f2                	cmp    %esi,%edx
  8021fa:	89 d0                	mov    %edx,%eax
  8021fc:	77 52                	ja     802250 <__umoddi3+0xa0>
  8021fe:	0f bd ea             	bsr    %edx,%ebp
  802201:	83 f5 1f             	xor    $0x1f,%ebp
  802204:	75 5a                	jne    802260 <__umoddi3+0xb0>
  802206:	3b 54 24 04          	cmp    0x4(%esp),%edx
  80220a:	0f 82 e0 00 00 00    	jb     8022f0 <__umoddi3+0x140>
  802210:	39 0c 24             	cmp    %ecx,(%esp)
  802213:	0f 86 d7 00 00 00    	jbe    8022f0 <__umoddi3+0x140>
  802219:	8b 44 24 08          	mov    0x8(%esp),%eax
  80221d:	8b 54 24 04          	mov    0x4(%esp),%edx
  802221:	83 c4 1c             	add    $0x1c,%esp
  802224:	5b                   	pop    %ebx
  802225:	5e                   	pop    %esi
  802226:	5f                   	pop    %edi
  802227:	5d                   	pop    %ebp
  802228:	c3                   	ret    
  802229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802230:	85 ff                	test   %edi,%edi
  802232:	89 fd                	mov    %edi,%ebp
  802234:	75 0b                	jne    802241 <__umoddi3+0x91>
  802236:	b8 01 00 00 00       	mov    $0x1,%eax
  80223b:	31 d2                	xor    %edx,%edx
  80223d:	f7 f7                	div    %edi
  80223f:	89 c5                	mov    %eax,%ebp
  802241:	89 f0                	mov    %esi,%eax
  802243:	31 d2                	xor    %edx,%edx
  802245:	f7 f5                	div    %ebp
  802247:	89 c8                	mov    %ecx,%eax
  802249:	f7 f5                	div    %ebp
  80224b:	89 d0                	mov    %edx,%eax
  80224d:	eb 99                	jmp    8021e8 <__umoddi3+0x38>
  80224f:	90                   	nop
  802250:	89 c8                	mov    %ecx,%eax
  802252:	89 f2                	mov    %esi,%edx
  802254:	83 c4 1c             	add    $0x1c,%esp
  802257:	5b                   	pop    %ebx
  802258:	5e                   	pop    %esi
  802259:	5f                   	pop    %edi
  80225a:	5d                   	pop    %ebp
  80225b:	c3                   	ret    
  80225c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802260:	8b 34 24             	mov    (%esp),%esi
  802263:	bf 20 00 00 00       	mov    $0x20,%edi
  802268:	89 e9                	mov    %ebp,%ecx
  80226a:	29 ef                	sub    %ebp,%edi
  80226c:	d3 e0                	shl    %cl,%eax
  80226e:	89 f9                	mov    %edi,%ecx
  802270:	89 f2                	mov    %esi,%edx
  802272:	d3 ea                	shr    %cl,%edx
  802274:	89 e9                	mov    %ebp,%ecx
  802276:	09 c2                	or     %eax,%edx
  802278:	89 d8                	mov    %ebx,%eax
  80227a:	89 14 24             	mov    %edx,(%esp)
  80227d:	89 f2                	mov    %esi,%edx
  80227f:	d3 e2                	shl    %cl,%edx
  802281:	89 f9                	mov    %edi,%ecx
  802283:	89 54 24 04          	mov    %edx,0x4(%esp)
  802287:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80228b:	d3 e8                	shr    %cl,%eax
  80228d:	89 e9                	mov    %ebp,%ecx
  80228f:	89 c6                	mov    %eax,%esi
  802291:	d3 e3                	shl    %cl,%ebx
  802293:	89 f9                	mov    %edi,%ecx
  802295:	89 d0                	mov    %edx,%eax
  802297:	d3 e8                	shr    %cl,%eax
  802299:	89 e9                	mov    %ebp,%ecx
  80229b:	09 d8                	or     %ebx,%eax
  80229d:	89 d3                	mov    %edx,%ebx
  80229f:	89 f2                	mov    %esi,%edx
  8022a1:	f7 34 24             	divl   (%esp)
  8022a4:	89 d6                	mov    %edx,%esi
  8022a6:	d3 e3                	shl    %cl,%ebx
  8022a8:	f7 64 24 04          	mull   0x4(%esp)
  8022ac:	39 d6                	cmp    %edx,%esi
  8022ae:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022b2:	89 d1                	mov    %edx,%ecx
  8022b4:	89 c3                	mov    %eax,%ebx
  8022b6:	72 08                	jb     8022c0 <__umoddi3+0x110>
  8022b8:	75 11                	jne    8022cb <__umoddi3+0x11b>
  8022ba:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8022be:	73 0b                	jae    8022cb <__umoddi3+0x11b>
  8022c0:	2b 44 24 04          	sub    0x4(%esp),%eax
  8022c4:	1b 14 24             	sbb    (%esp),%edx
  8022c7:	89 d1                	mov    %edx,%ecx
  8022c9:	89 c3                	mov    %eax,%ebx
  8022cb:	8b 54 24 08          	mov    0x8(%esp),%edx
  8022cf:	29 da                	sub    %ebx,%edx
  8022d1:	19 ce                	sbb    %ecx,%esi
  8022d3:	89 f9                	mov    %edi,%ecx
  8022d5:	89 f0                	mov    %esi,%eax
  8022d7:	d3 e0                	shl    %cl,%eax
  8022d9:	89 e9                	mov    %ebp,%ecx
  8022db:	d3 ea                	shr    %cl,%edx
  8022dd:	89 e9                	mov    %ebp,%ecx
  8022df:	d3 ee                	shr    %cl,%esi
  8022e1:	09 d0                	or     %edx,%eax
  8022e3:	89 f2                	mov    %esi,%edx
  8022e5:	83 c4 1c             	add    $0x1c,%esp
  8022e8:	5b                   	pop    %ebx
  8022e9:	5e                   	pop    %esi
  8022ea:	5f                   	pop    %edi
  8022eb:	5d                   	pop    %ebp
  8022ec:	c3                   	ret    
  8022ed:	8d 76 00             	lea    0x0(%esi),%esi
  8022f0:	29 f9                	sub    %edi,%ecx
  8022f2:	19 d6                	sbb    %edx,%esi
  8022f4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022f8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022fc:	e9 18 ff ff ff       	jmp    802219 <__umoddi3+0x69>
