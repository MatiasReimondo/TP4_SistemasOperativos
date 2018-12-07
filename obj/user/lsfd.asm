
obj/user/lsfd.debug:     formato del fichero elf32-i386


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
  80002c:	e8 dc 00 00 00       	call   80010d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: lsfd [-1]\n");
  800039:	68 60 20 80 00       	push   $0x802060
  80003e:	e8 c1 01 00 00       	call   800204 <cprintf>
	exit();
  800043:	e8 0f 01 00 00       	call   800157 <exit>
}
  800048:	83 c4 10             	add    $0x10,%esp
  80004b:	c9                   	leave  
  80004c:	c3                   	ret    

0080004d <umain>:

void
umain(int argc, char **argv)
{
  80004d:	55                   	push   %ebp
  80004e:	89 e5                	mov    %esp,%ebp
  800050:	57                   	push   %edi
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	81 ec b0 00 00 00    	sub    $0xb0,%esp
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800059:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80005f:	50                   	push   %eax
  800060:	ff 75 0c             	pushl  0xc(%ebp)
  800063:	8d 45 08             	lea    0x8(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	e8 70 0c 00 00       	call   800cdc <argstart>
	while ((i = argnext(&args)) >= 0)
  80006c:	83 c4 10             	add    $0x10,%esp
}

void
umain(int argc, char **argv)
{
	int i, usefprint = 0;
  80006f:	be 00 00 00 00       	mov    $0x0,%esi
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  800074:	8d 9d 4c ff ff ff    	lea    -0xb4(%ebp),%ebx
  80007a:	eb 11                	jmp    80008d <umain+0x40>
		if (i == '1')
  80007c:	83 f8 31             	cmp    $0x31,%eax
  80007f:	74 07                	je     800088 <umain+0x3b>
			usefprint = 1;
		else
			usage();
  800081:	e8 ad ff ff ff       	call   800033 <usage>
  800086:	eb 05                	jmp    80008d <umain+0x40>
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
		if (i == '1')
			usefprint = 1;
  800088:	be 01 00 00 00       	mov    $0x1,%esi
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	53                   	push   %ebx
  800091:	e8 76 0c 00 00       	call   800d0c <argnext>
  800096:	83 c4 10             	add    $0x10,%esp
  800099:	85 c0                	test   %eax,%eax
  80009b:	79 df                	jns    80007c <umain+0x2f>
  80009d:	bb 00 00 00 00       	mov    $0x0,%ebx
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
  8000a2:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
  8000a8:	83 ec 08             	sub    $0x8,%esp
  8000ab:	57                   	push   %edi
  8000ac:	53                   	push   %ebx
  8000ad:	e8 72 12 00 00       	call   801324 <fstat>
  8000b2:	83 c4 10             	add    $0x10,%esp
  8000b5:	85 c0                	test   %eax,%eax
  8000b7:	78 44                	js     8000fd <umain+0xb0>
			if (usefprint)
  8000b9:	85 f6                	test   %esi,%esi
  8000bb:	74 22                	je     8000df <umain+0x92>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  8000bd:	83 ec 04             	sub    $0x4,%esp
  8000c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000c3:	ff 70 04             	pushl  0x4(%eax)
  8000c6:	ff 75 dc             	pushl  -0x24(%ebp)
  8000c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8000cc:	57                   	push   %edi
  8000cd:	53                   	push   %ebx
  8000ce:	68 74 20 80 00       	push   $0x802074
  8000d3:	6a 01                	push   $0x1
  8000d5:	e8 67 16 00 00       	call   801741 <fprintf>
  8000da:	83 c4 20             	add    $0x20,%esp
  8000dd:	eb 1e                	jmp    8000fd <umain+0xb0>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8000df:	83 ec 08             	sub    $0x8,%esp
  8000e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e5:	ff 70 04             	pushl  0x4(%eax)
  8000e8:	ff 75 dc             	pushl  -0x24(%ebp)
  8000eb:	ff 75 e0             	pushl  -0x20(%ebp)
  8000ee:	57                   	push   %edi
  8000ef:	53                   	push   %ebx
  8000f0:	68 74 20 80 00       	push   $0x802074
  8000f5:	e8 0a 01 00 00       	call   800204 <cprintf>
  8000fa:	83 c4 20             	add    $0x20,%esp
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  8000fd:	83 c3 01             	add    $0x1,%ebx
  800100:	83 fb 20             	cmp    $0x20,%ebx
  800103:	75 a3                	jne    8000a8 <umain+0x5b>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  800105:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800108:	5b                   	pop    %ebx
  800109:	5e                   	pop    %esi
  80010a:	5f                   	pop    %edi
  80010b:	5d                   	pop    %ebp
  80010c:	c3                   	ret    

0080010d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80010d:	55                   	push   %ebp
  80010e:	89 e5                	mov    %esp,%ebp
  800110:	56                   	push   %esi
  800111:	53                   	push   %ebx
  800112:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800115:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800118:	e8 57 0a 00 00       	call   800b74 <sys_getenvid>
	if (id >= 0)
  80011d:	85 c0                	test   %eax,%eax
  80011f:	78 12                	js     800133 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  800121:	25 ff 03 00 00       	and    $0x3ff,%eax
  800126:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800129:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80012e:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800133:	85 db                	test   %ebx,%ebx
  800135:	7e 07                	jle    80013e <libmain+0x31>
		binaryname = argv[0];
  800137:	8b 06                	mov    (%esi),%eax
  800139:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80013e:	83 ec 08             	sub    $0x8,%esp
  800141:	56                   	push   %esi
  800142:	53                   	push   %ebx
  800143:	e8 05 ff ff ff       	call   80004d <umain>

	// exit gracefully
	exit();
  800148:	e8 0a 00 00 00       	call   800157 <exit>
}
  80014d:	83 c4 10             	add    $0x10,%esp
  800150:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800153:	5b                   	pop    %ebx
  800154:	5e                   	pop    %esi
  800155:	5d                   	pop    %ebp
  800156:	c3                   	ret    

00800157 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800157:	55                   	push   %ebp
  800158:	89 e5                	mov    %esp,%ebp
  80015a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80015d:	e8 99 0e 00 00       	call   800ffb <close_all>
	sys_env_destroy(0);
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	6a 00                	push   $0x0
  800167:	e8 e6 09 00 00       	call   800b52 <sys_env_destroy>
}
  80016c:	83 c4 10             	add    $0x10,%esp
  80016f:	c9                   	leave  
  800170:	c3                   	ret    

00800171 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800171:	55                   	push   %ebp
  800172:	89 e5                	mov    %esp,%ebp
  800174:	53                   	push   %ebx
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80017b:	8b 13                	mov    (%ebx),%edx
  80017d:	8d 42 01             	lea    0x1(%edx),%eax
  800180:	89 03                	mov    %eax,(%ebx)
  800182:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800185:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800189:	3d ff 00 00 00       	cmp    $0xff,%eax
  80018e:	75 1a                	jne    8001aa <putch+0x39>
		sys_cputs(b->buf, b->idx);
  800190:	83 ec 08             	sub    $0x8,%esp
  800193:	68 ff 00 00 00       	push   $0xff
  800198:	8d 43 08             	lea    0x8(%ebx),%eax
  80019b:	50                   	push   %eax
  80019c:	e8 67 09 00 00       	call   800b08 <sys_cputs>
		b->idx = 0;
  8001a1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001a7:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  8001aa:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001b1:	c9                   	leave  
  8001b2:	c3                   	ret    

008001b3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b3:	55                   	push   %ebp
  8001b4:	89 e5                	mov    %esp,%ebp
  8001b6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001bc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c3:	00 00 00 
	b.cnt = 0;
  8001c6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001cd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d0:	ff 75 0c             	pushl  0xc(%ebp)
  8001d3:	ff 75 08             	pushl  0x8(%ebp)
  8001d6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001dc:	50                   	push   %eax
  8001dd:	68 71 01 80 00       	push   $0x800171
  8001e2:	e8 86 01 00 00       	call   80036d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e7:	83 c4 08             	add    $0x8,%esp
  8001ea:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001f0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f6:	50                   	push   %eax
  8001f7:	e8 0c 09 00 00       	call   800b08 <sys_cputs>

	return b.cnt;
}
  8001fc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800202:	c9                   	leave  
  800203:	c3                   	ret    

00800204 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80020a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80020d:	50                   	push   %eax
  80020e:	ff 75 08             	pushl  0x8(%ebp)
  800211:	e8 9d ff ff ff       	call   8001b3 <vcprintf>
	va_end(ap);

	return cnt;
}
  800216:	c9                   	leave  
  800217:	c3                   	ret    

00800218 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	57                   	push   %edi
  80021c:	56                   	push   %esi
  80021d:	53                   	push   %ebx
  80021e:	83 ec 1c             	sub    $0x1c,%esp
  800221:	89 c7                	mov    %eax,%edi
  800223:	89 d6                	mov    %edx,%esi
  800225:	8b 45 08             	mov    0x8(%ebp),%eax
  800228:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80022e:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800231:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800234:	bb 00 00 00 00       	mov    $0x0,%ebx
  800239:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80023c:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80023f:	39 d3                	cmp    %edx,%ebx
  800241:	72 05                	jb     800248 <printnum+0x30>
  800243:	39 45 10             	cmp    %eax,0x10(%ebp)
  800246:	77 45                	ja     80028d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 75 18             	pushl  0x18(%ebp)
  80024e:	8b 45 14             	mov    0x14(%ebp),%eax
  800251:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800254:	53                   	push   %ebx
  800255:	ff 75 10             	pushl  0x10(%ebp)
  800258:	83 ec 08             	sub    $0x8,%esp
  80025b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025e:	ff 75 e0             	pushl  -0x20(%ebp)
  800261:	ff 75 dc             	pushl  -0x24(%ebp)
  800264:	ff 75 d8             	pushl  -0x28(%ebp)
  800267:	e8 64 1b 00 00       	call   801dd0 <__udivdi3>
  80026c:	83 c4 18             	add    $0x18,%esp
  80026f:	52                   	push   %edx
  800270:	50                   	push   %eax
  800271:	89 f2                	mov    %esi,%edx
  800273:	89 f8                	mov    %edi,%eax
  800275:	e8 9e ff ff ff       	call   800218 <printnum>
  80027a:	83 c4 20             	add    $0x20,%esp
  80027d:	eb 18                	jmp    800297 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	56                   	push   %esi
  800283:	ff 75 18             	pushl  0x18(%ebp)
  800286:	ff d7                	call   *%edi
  800288:	83 c4 10             	add    $0x10,%esp
  80028b:	eb 03                	jmp    800290 <printnum+0x78>
  80028d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800290:	83 eb 01             	sub    $0x1,%ebx
  800293:	85 db                	test   %ebx,%ebx
  800295:	7f e8                	jg     80027f <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	56                   	push   %esi
  80029b:	83 ec 04             	sub    $0x4,%esp
  80029e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a1:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a4:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8002aa:	e8 51 1c 00 00       	call   801f00 <__umoddi3>
  8002af:	83 c4 14             	add    $0x14,%esp
  8002b2:	0f be 80 a6 20 80 00 	movsbl 0x8020a6(%eax),%eax
  8002b9:	50                   	push   %eax
  8002ba:	ff d7                	call   *%edi
}
  8002bc:	83 c4 10             	add    $0x10,%esp
  8002bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c2:	5b                   	pop    %ebx
  8002c3:	5e                   	pop    %esi
  8002c4:	5f                   	pop    %edi
  8002c5:	5d                   	pop    %ebp
  8002c6:	c3                   	ret    

008002c7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002c7:	55                   	push   %ebp
  8002c8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002ca:	83 fa 01             	cmp    $0x1,%edx
  8002cd:	7e 0e                	jle    8002dd <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002cf:	8b 10                	mov    (%eax),%edx
  8002d1:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002d4:	89 08                	mov    %ecx,(%eax)
  8002d6:	8b 02                	mov    (%edx),%eax
  8002d8:	8b 52 04             	mov    0x4(%edx),%edx
  8002db:	eb 22                	jmp    8002ff <getuint+0x38>
	else if (lflag)
  8002dd:	85 d2                	test   %edx,%edx
  8002df:	74 10                	je     8002f1 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002e1:	8b 10                	mov    (%eax),%edx
  8002e3:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002e6:	89 08                	mov    %ecx,(%eax)
  8002e8:	8b 02                	mov    (%edx),%eax
  8002ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ef:	eb 0e                	jmp    8002ff <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002f1:	8b 10                	mov    (%eax),%edx
  8002f3:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002f6:	89 08                	mov    %ecx,(%eax)
  8002f8:	8b 02                	mov    (%edx),%eax
  8002fa:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002ff:	5d                   	pop    %ebp
  800300:	c3                   	ret    

00800301 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800301:	55                   	push   %ebp
  800302:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800304:	83 fa 01             	cmp    $0x1,%edx
  800307:	7e 0e                	jle    800317 <getint+0x16>
		return va_arg(*ap, long long);
  800309:	8b 10                	mov    (%eax),%edx
  80030b:	8d 4a 08             	lea    0x8(%edx),%ecx
  80030e:	89 08                	mov    %ecx,(%eax)
  800310:	8b 02                	mov    (%edx),%eax
  800312:	8b 52 04             	mov    0x4(%edx),%edx
  800315:	eb 1a                	jmp    800331 <getint+0x30>
	else if (lflag)
  800317:	85 d2                	test   %edx,%edx
  800319:	74 0c                	je     800327 <getint+0x26>
		return va_arg(*ap, long);
  80031b:	8b 10                	mov    (%eax),%edx
  80031d:	8d 4a 04             	lea    0x4(%edx),%ecx
  800320:	89 08                	mov    %ecx,(%eax)
  800322:	8b 02                	mov    (%edx),%eax
  800324:	99                   	cltd   
  800325:	eb 0a                	jmp    800331 <getint+0x30>
	else
		return va_arg(*ap, int);
  800327:	8b 10                	mov    (%eax),%edx
  800329:	8d 4a 04             	lea    0x4(%edx),%ecx
  80032c:	89 08                	mov    %ecx,(%eax)
  80032e:	8b 02                	mov    (%edx),%eax
  800330:	99                   	cltd   
}
  800331:	5d                   	pop    %ebp
  800332:	c3                   	ret    

00800333 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
  800336:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800339:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80033d:	8b 10                	mov    (%eax),%edx
  80033f:	3b 50 04             	cmp    0x4(%eax),%edx
  800342:	73 0a                	jae    80034e <sprintputch+0x1b>
		*b->buf++ = ch;
  800344:	8d 4a 01             	lea    0x1(%edx),%ecx
  800347:	89 08                	mov    %ecx,(%eax)
  800349:	8b 45 08             	mov    0x8(%ebp),%eax
  80034c:	88 02                	mov    %al,(%edx)
}
  80034e:	5d                   	pop    %ebp
  80034f:	c3                   	ret    

00800350 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  800353:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800356:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800359:	50                   	push   %eax
  80035a:	ff 75 10             	pushl  0x10(%ebp)
  80035d:	ff 75 0c             	pushl  0xc(%ebp)
  800360:	ff 75 08             	pushl  0x8(%ebp)
  800363:	e8 05 00 00 00       	call   80036d <vprintfmt>
	va_end(ap);
}
  800368:	83 c4 10             	add    $0x10,%esp
  80036b:	c9                   	leave  
  80036c:	c3                   	ret    

0080036d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80036d:	55                   	push   %ebp
  80036e:	89 e5                	mov    %esp,%ebp
  800370:	57                   	push   %edi
  800371:	56                   	push   %esi
  800372:	53                   	push   %ebx
  800373:	83 ec 2c             	sub    $0x2c,%esp
  800376:	8b 75 08             	mov    0x8(%ebp),%esi
  800379:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80037c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80037f:	eb 12                	jmp    800393 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800381:	85 c0                	test   %eax,%eax
  800383:	0f 84 44 03 00 00    	je     8006cd <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  800389:	83 ec 08             	sub    $0x8,%esp
  80038c:	53                   	push   %ebx
  80038d:	50                   	push   %eax
  80038e:	ff d6                	call   *%esi
  800390:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800393:	83 c7 01             	add    $0x1,%edi
  800396:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80039a:	83 f8 25             	cmp    $0x25,%eax
  80039d:	75 e2                	jne    800381 <vprintfmt+0x14>
  80039f:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8003a3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8003aa:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003b1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8003b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003bd:	eb 07                	jmp    8003c6 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003c2:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003c6:	8d 47 01             	lea    0x1(%edi),%eax
  8003c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003cc:	0f b6 07             	movzbl (%edi),%eax
  8003cf:	0f b6 c8             	movzbl %al,%ecx
  8003d2:	83 e8 23             	sub    $0x23,%eax
  8003d5:	3c 55                	cmp    $0x55,%al
  8003d7:	0f 87 d5 02 00 00    	ja     8006b2 <vprintfmt+0x345>
  8003dd:	0f b6 c0             	movzbl %al,%eax
  8003e0:	ff 24 85 e0 21 80 00 	jmp    *0x8021e0(,%eax,4)
  8003e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003ea:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003ee:	eb d6                	jmp    8003c6 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003fb:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003fe:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  800402:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  800405:	8d 51 d0             	lea    -0x30(%ecx),%edx
  800408:	83 fa 09             	cmp    $0x9,%edx
  80040b:	77 39                	ja     800446 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80040d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800410:	eb e9                	jmp    8003fb <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800412:	8b 45 14             	mov    0x14(%ebp),%eax
  800415:	8d 48 04             	lea    0x4(%eax),%ecx
  800418:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80041b:	8b 00                	mov    (%eax),%eax
  80041d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800420:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800423:	eb 27                	jmp    80044c <vprintfmt+0xdf>
  800425:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800428:	85 c0                	test   %eax,%eax
  80042a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80042f:	0f 49 c8             	cmovns %eax,%ecx
  800432:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800435:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800438:	eb 8c                	jmp    8003c6 <vprintfmt+0x59>
  80043a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80043d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800444:	eb 80                	jmp    8003c6 <vprintfmt+0x59>
  800446:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800449:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  80044c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800450:	0f 89 70 ff ff ff    	jns    8003c6 <vprintfmt+0x59>
				width = precision, precision = -1;
  800456:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800459:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800463:	e9 5e ff ff ff       	jmp    8003c6 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800468:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80046e:	e9 53 ff ff ff       	jmp    8003c6 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800473:	8b 45 14             	mov    0x14(%ebp),%eax
  800476:	8d 50 04             	lea    0x4(%eax),%edx
  800479:	89 55 14             	mov    %edx,0x14(%ebp)
  80047c:	83 ec 08             	sub    $0x8,%esp
  80047f:	53                   	push   %ebx
  800480:	ff 30                	pushl  (%eax)
  800482:	ff d6                	call   *%esi
			break;
  800484:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800487:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  80048a:	e9 04 ff ff ff       	jmp    800393 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80048f:	8b 45 14             	mov    0x14(%ebp),%eax
  800492:	8d 50 04             	lea    0x4(%eax),%edx
  800495:	89 55 14             	mov    %edx,0x14(%ebp)
  800498:	8b 00                	mov    (%eax),%eax
  80049a:	99                   	cltd   
  80049b:	31 d0                	xor    %edx,%eax
  80049d:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80049f:	83 f8 0f             	cmp    $0xf,%eax
  8004a2:	7f 0b                	jg     8004af <vprintfmt+0x142>
  8004a4:	8b 14 85 40 23 80 00 	mov    0x802340(,%eax,4),%edx
  8004ab:	85 d2                	test   %edx,%edx
  8004ad:	75 18                	jne    8004c7 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  8004af:	50                   	push   %eax
  8004b0:	68 be 20 80 00       	push   $0x8020be
  8004b5:	53                   	push   %ebx
  8004b6:	56                   	push   %esi
  8004b7:	e8 94 fe ff ff       	call   800350 <printfmt>
  8004bc:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8004c2:	e9 cc fe ff ff       	jmp    800393 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  8004c7:	52                   	push   %edx
  8004c8:	68 71 24 80 00       	push   $0x802471
  8004cd:	53                   	push   %ebx
  8004ce:	56                   	push   %esi
  8004cf:	e8 7c fe ff ff       	call   800350 <printfmt>
  8004d4:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004da:	e9 b4 fe ff ff       	jmp    800393 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004df:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e2:	8d 50 04             	lea    0x4(%eax),%edx
  8004e5:	89 55 14             	mov    %edx,0x14(%ebp)
  8004e8:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004ea:	85 ff                	test   %edi,%edi
  8004ec:	b8 b7 20 80 00       	mov    $0x8020b7,%eax
  8004f1:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004f8:	0f 8e 94 00 00 00    	jle    800592 <vprintfmt+0x225>
  8004fe:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800502:	0f 84 98 00 00 00    	je     8005a0 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	ff 75 d0             	pushl  -0x30(%ebp)
  80050e:	57                   	push   %edi
  80050f:	e8 41 02 00 00       	call   800755 <strnlen>
  800514:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800517:	29 c1                	sub    %eax,%ecx
  800519:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  80051c:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80051f:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800523:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800526:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800529:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80052b:	eb 0f                	jmp    80053c <vprintfmt+0x1cf>
					putch(padc, putdat);
  80052d:	83 ec 08             	sub    $0x8,%esp
  800530:	53                   	push   %ebx
  800531:	ff 75 e0             	pushl  -0x20(%ebp)
  800534:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800536:	83 ef 01             	sub    $0x1,%edi
  800539:	83 c4 10             	add    $0x10,%esp
  80053c:	85 ff                	test   %edi,%edi
  80053e:	7f ed                	jg     80052d <vprintfmt+0x1c0>
  800540:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800543:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800546:	85 c9                	test   %ecx,%ecx
  800548:	b8 00 00 00 00       	mov    $0x0,%eax
  80054d:	0f 49 c1             	cmovns %ecx,%eax
  800550:	29 c1                	sub    %eax,%ecx
  800552:	89 75 08             	mov    %esi,0x8(%ebp)
  800555:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800558:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80055b:	89 cb                	mov    %ecx,%ebx
  80055d:	eb 4d                	jmp    8005ac <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80055f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800563:	74 1b                	je     800580 <vprintfmt+0x213>
  800565:	0f be c0             	movsbl %al,%eax
  800568:	83 e8 20             	sub    $0x20,%eax
  80056b:	83 f8 5e             	cmp    $0x5e,%eax
  80056e:	76 10                	jbe    800580 <vprintfmt+0x213>
					putch('?', putdat);
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	ff 75 0c             	pushl  0xc(%ebp)
  800576:	6a 3f                	push   $0x3f
  800578:	ff 55 08             	call   *0x8(%ebp)
  80057b:	83 c4 10             	add    $0x10,%esp
  80057e:	eb 0d                	jmp    80058d <vprintfmt+0x220>
				else
					putch(ch, putdat);
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	ff 75 0c             	pushl  0xc(%ebp)
  800586:	52                   	push   %edx
  800587:	ff 55 08             	call   *0x8(%ebp)
  80058a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80058d:	83 eb 01             	sub    $0x1,%ebx
  800590:	eb 1a                	jmp    8005ac <vprintfmt+0x23f>
  800592:	89 75 08             	mov    %esi,0x8(%ebp)
  800595:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800598:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80059b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80059e:	eb 0c                	jmp    8005ac <vprintfmt+0x23f>
  8005a0:	89 75 08             	mov    %esi,0x8(%ebp)
  8005a3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005a6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005a9:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005ac:	83 c7 01             	add    $0x1,%edi
  8005af:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005b3:	0f be d0             	movsbl %al,%edx
  8005b6:	85 d2                	test   %edx,%edx
  8005b8:	74 23                	je     8005dd <vprintfmt+0x270>
  8005ba:	85 f6                	test   %esi,%esi
  8005bc:	78 a1                	js     80055f <vprintfmt+0x1f2>
  8005be:	83 ee 01             	sub    $0x1,%esi
  8005c1:	79 9c                	jns    80055f <vprintfmt+0x1f2>
  8005c3:	89 df                	mov    %ebx,%edi
  8005c5:	8b 75 08             	mov    0x8(%ebp),%esi
  8005c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005cb:	eb 18                	jmp    8005e5 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005cd:	83 ec 08             	sub    $0x8,%esp
  8005d0:	53                   	push   %ebx
  8005d1:	6a 20                	push   $0x20
  8005d3:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005d5:	83 ef 01             	sub    $0x1,%edi
  8005d8:	83 c4 10             	add    $0x10,%esp
  8005db:	eb 08                	jmp    8005e5 <vprintfmt+0x278>
  8005dd:	89 df                	mov    %ebx,%edi
  8005df:	8b 75 08             	mov    0x8(%ebp),%esi
  8005e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005e5:	85 ff                	test   %edi,%edi
  8005e7:	7f e4                	jg     8005cd <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005ec:	e9 a2 fd ff ff       	jmp    800393 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005f1:	8d 45 14             	lea    0x14(%ebp),%eax
  8005f4:	e8 08 fd ff ff       	call   800301 <getint>
  8005f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fc:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8005ff:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800604:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800608:	79 74                	jns    80067e <vprintfmt+0x311>
				putch('-', putdat);
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	53                   	push   %ebx
  80060e:	6a 2d                	push   $0x2d
  800610:	ff d6                	call   *%esi
				num = -(long long) num;
  800612:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800615:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800618:	f7 d8                	neg    %eax
  80061a:	83 d2 00             	adc    $0x0,%edx
  80061d:	f7 da                	neg    %edx
  80061f:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  800622:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800627:	eb 55                	jmp    80067e <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800629:	8d 45 14             	lea    0x14(%ebp),%eax
  80062c:	e8 96 fc ff ff       	call   8002c7 <getuint>
			base = 10;
  800631:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800636:	eb 46                	jmp    80067e <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800638:	8d 45 14             	lea    0x14(%ebp),%eax
  80063b:	e8 87 fc ff ff       	call   8002c7 <getuint>
			base = 8;
  800640:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800645:	eb 37                	jmp    80067e <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  800647:	83 ec 08             	sub    $0x8,%esp
  80064a:	53                   	push   %ebx
  80064b:	6a 30                	push   $0x30
  80064d:	ff d6                	call   *%esi
			putch('x', putdat);
  80064f:	83 c4 08             	add    $0x8,%esp
  800652:	53                   	push   %ebx
  800653:	6a 78                	push   $0x78
  800655:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8d 50 04             	lea    0x4(%eax),%edx
  80065d:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800660:	8b 00                	mov    (%eax),%eax
  800662:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800667:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80066a:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80066f:	eb 0d                	jmp    80067e <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800671:	8d 45 14             	lea    0x14(%ebp),%eax
  800674:	e8 4e fc ff ff       	call   8002c7 <getuint>
			base = 16;
  800679:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  80067e:	83 ec 0c             	sub    $0xc,%esp
  800681:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800685:	57                   	push   %edi
  800686:	ff 75 e0             	pushl  -0x20(%ebp)
  800689:	51                   	push   %ecx
  80068a:	52                   	push   %edx
  80068b:	50                   	push   %eax
  80068c:	89 da                	mov    %ebx,%edx
  80068e:	89 f0                	mov    %esi,%eax
  800690:	e8 83 fb ff ff       	call   800218 <printnum>
			break;
  800695:	83 c4 20             	add    $0x20,%esp
  800698:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80069b:	e9 f3 fc ff ff       	jmp    800393 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006a0:	83 ec 08             	sub    $0x8,%esp
  8006a3:	53                   	push   %ebx
  8006a4:	51                   	push   %ecx
  8006a5:	ff d6                	call   *%esi
			break;
  8006a7:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8006ad:	e9 e1 fc ff ff       	jmp    800393 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	53                   	push   %ebx
  8006b6:	6a 25                	push   $0x25
  8006b8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006ba:	83 c4 10             	add    $0x10,%esp
  8006bd:	eb 03                	jmp    8006c2 <vprintfmt+0x355>
  8006bf:	83 ef 01             	sub    $0x1,%edi
  8006c2:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  8006c6:	75 f7                	jne    8006bf <vprintfmt+0x352>
  8006c8:	e9 c6 fc ff ff       	jmp    800393 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  8006cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006d0:	5b                   	pop    %ebx
  8006d1:	5e                   	pop    %esi
  8006d2:	5f                   	pop    %edi
  8006d3:	5d                   	pop    %ebp
  8006d4:	c3                   	ret    

008006d5 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006d5:	55                   	push   %ebp
  8006d6:	89 e5                	mov    %esp,%ebp
  8006d8:	83 ec 18             	sub    $0x18,%esp
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006e4:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006e8:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006f2:	85 c0                	test   %eax,%eax
  8006f4:	74 26                	je     80071c <vsnprintf+0x47>
  8006f6:	85 d2                	test   %edx,%edx
  8006f8:	7e 22                	jle    80071c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006fa:	ff 75 14             	pushl  0x14(%ebp)
  8006fd:	ff 75 10             	pushl  0x10(%ebp)
  800700:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800703:	50                   	push   %eax
  800704:	68 33 03 80 00       	push   $0x800333
  800709:	e8 5f fc ff ff       	call   80036d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80070e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800711:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800717:	83 c4 10             	add    $0x10,%esp
  80071a:	eb 05                	jmp    800721 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80071c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800721:	c9                   	leave  
  800722:	c3                   	ret    

00800723 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800723:	55                   	push   %ebp
  800724:	89 e5                	mov    %esp,%ebp
  800726:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800729:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80072c:	50                   	push   %eax
  80072d:	ff 75 10             	pushl  0x10(%ebp)
  800730:	ff 75 0c             	pushl  0xc(%ebp)
  800733:	ff 75 08             	pushl  0x8(%ebp)
  800736:	e8 9a ff ff ff       	call   8006d5 <vsnprintf>
	va_end(ap);

	return rc;
}
  80073b:	c9                   	leave  
  80073c:	c3                   	ret    

0080073d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80073d:	55                   	push   %ebp
  80073e:	89 e5                	mov    %esp,%ebp
  800740:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800743:	b8 00 00 00 00       	mov    $0x0,%eax
  800748:	eb 03                	jmp    80074d <strlen+0x10>
		n++;
  80074a:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80074d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800751:	75 f7                	jne    80074a <strlen+0xd>
		n++;
	return n;
}
  800753:	5d                   	pop    %ebp
  800754:	c3                   	ret    

00800755 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800755:	55                   	push   %ebp
  800756:	89 e5                	mov    %esp,%ebp
  800758:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80075b:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80075e:	ba 00 00 00 00       	mov    $0x0,%edx
  800763:	eb 03                	jmp    800768 <strnlen+0x13>
		n++;
  800765:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800768:	39 c2                	cmp    %eax,%edx
  80076a:	74 08                	je     800774 <strnlen+0x1f>
  80076c:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800770:	75 f3                	jne    800765 <strnlen+0x10>
  800772:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  800774:	5d                   	pop    %ebp
  800775:	c3                   	ret    

00800776 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800776:	55                   	push   %ebp
  800777:	89 e5                	mov    %esp,%ebp
  800779:	53                   	push   %ebx
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800780:	89 c2                	mov    %eax,%edx
  800782:	83 c2 01             	add    $0x1,%edx
  800785:	83 c1 01             	add    $0x1,%ecx
  800788:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80078c:	88 5a ff             	mov    %bl,-0x1(%edx)
  80078f:	84 db                	test   %bl,%bl
  800791:	75 ef                	jne    800782 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800793:	5b                   	pop    %ebx
  800794:	5d                   	pop    %ebp
  800795:	c3                   	ret    

00800796 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800796:	55                   	push   %ebp
  800797:	89 e5                	mov    %esp,%ebp
  800799:	53                   	push   %ebx
  80079a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80079d:	53                   	push   %ebx
  80079e:	e8 9a ff ff ff       	call   80073d <strlen>
  8007a3:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007a6:	ff 75 0c             	pushl  0xc(%ebp)
  8007a9:	01 d8                	add    %ebx,%eax
  8007ab:	50                   	push   %eax
  8007ac:	e8 c5 ff ff ff       	call   800776 <strcpy>
	return dst;
}
  8007b1:	89 d8                	mov    %ebx,%eax
  8007b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b6:	c9                   	leave  
  8007b7:	c3                   	ret    

008007b8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007b8:	55                   	push   %ebp
  8007b9:	89 e5                	mov    %esp,%ebp
  8007bb:	56                   	push   %esi
  8007bc:	53                   	push   %ebx
  8007bd:	8b 75 08             	mov    0x8(%ebp),%esi
  8007c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007c3:	89 f3                	mov    %esi,%ebx
  8007c5:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007c8:	89 f2                	mov    %esi,%edx
  8007ca:	eb 0f                	jmp    8007db <strncpy+0x23>
		*dst++ = *src;
  8007cc:	83 c2 01             	add    $0x1,%edx
  8007cf:	0f b6 01             	movzbl (%ecx),%eax
  8007d2:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007d5:	80 39 01             	cmpb   $0x1,(%ecx)
  8007d8:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007db:	39 da                	cmp    %ebx,%edx
  8007dd:	75 ed                	jne    8007cc <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8007df:	89 f0                	mov    %esi,%eax
  8007e1:	5b                   	pop    %ebx
  8007e2:	5e                   	pop    %esi
  8007e3:	5d                   	pop    %ebp
  8007e4:	c3                   	ret    

008007e5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	56                   	push   %esi
  8007e9:	53                   	push   %ebx
  8007ea:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007f0:	8b 55 10             	mov    0x10(%ebp),%edx
  8007f3:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007f5:	85 d2                	test   %edx,%edx
  8007f7:	74 21                	je     80081a <strlcpy+0x35>
  8007f9:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8007fd:	89 f2                	mov    %esi,%edx
  8007ff:	eb 09                	jmp    80080a <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800801:	83 c2 01             	add    $0x1,%edx
  800804:	83 c1 01             	add    $0x1,%ecx
  800807:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80080a:	39 c2                	cmp    %eax,%edx
  80080c:	74 09                	je     800817 <strlcpy+0x32>
  80080e:	0f b6 19             	movzbl (%ecx),%ebx
  800811:	84 db                	test   %bl,%bl
  800813:	75 ec                	jne    800801 <strlcpy+0x1c>
  800815:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  800817:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80081a:	29 f0                	sub    %esi,%eax
}
  80081c:	5b                   	pop    %ebx
  80081d:	5e                   	pop    %esi
  80081e:	5d                   	pop    %ebp
  80081f:	c3                   	ret    

00800820 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
  800823:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800826:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800829:	eb 06                	jmp    800831 <strcmp+0x11>
		p++, q++;
  80082b:	83 c1 01             	add    $0x1,%ecx
  80082e:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800831:	0f b6 01             	movzbl (%ecx),%eax
  800834:	84 c0                	test   %al,%al
  800836:	74 04                	je     80083c <strcmp+0x1c>
  800838:	3a 02                	cmp    (%edx),%al
  80083a:	74 ef                	je     80082b <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80083c:	0f b6 c0             	movzbl %al,%eax
  80083f:	0f b6 12             	movzbl (%edx),%edx
  800842:	29 d0                	sub    %edx,%eax
}
  800844:	5d                   	pop    %ebp
  800845:	c3                   	ret    

00800846 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800846:	55                   	push   %ebp
  800847:	89 e5                	mov    %esp,%ebp
  800849:	53                   	push   %ebx
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800850:	89 c3                	mov    %eax,%ebx
  800852:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800855:	eb 06                	jmp    80085d <strncmp+0x17>
		n--, p++, q++;
  800857:	83 c0 01             	add    $0x1,%eax
  80085a:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80085d:	39 d8                	cmp    %ebx,%eax
  80085f:	74 15                	je     800876 <strncmp+0x30>
  800861:	0f b6 08             	movzbl (%eax),%ecx
  800864:	84 c9                	test   %cl,%cl
  800866:	74 04                	je     80086c <strncmp+0x26>
  800868:	3a 0a                	cmp    (%edx),%cl
  80086a:	74 eb                	je     800857 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80086c:	0f b6 00             	movzbl (%eax),%eax
  80086f:	0f b6 12             	movzbl (%edx),%edx
  800872:	29 d0                	sub    %edx,%eax
  800874:	eb 05                	jmp    80087b <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800876:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  80087b:	5b                   	pop    %ebx
  80087c:	5d                   	pop    %ebp
  80087d:	c3                   	ret    

0080087e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	8b 45 08             	mov    0x8(%ebp),%eax
  800884:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800888:	eb 07                	jmp    800891 <strchr+0x13>
		if (*s == c)
  80088a:	38 ca                	cmp    %cl,%dl
  80088c:	74 0f                	je     80089d <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80088e:	83 c0 01             	add    $0x1,%eax
  800891:	0f b6 10             	movzbl (%eax),%edx
  800894:	84 d2                	test   %dl,%dl
  800896:	75 f2                	jne    80088a <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800898:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80089d:	5d                   	pop    %ebp
  80089e:	c3                   	ret    

0080089f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80089f:	55                   	push   %ebp
  8008a0:	89 e5                	mov    %esp,%ebp
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008a9:	eb 03                	jmp    8008ae <strfind+0xf>
  8008ab:	83 c0 01             	add    $0x1,%eax
  8008ae:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008b1:	38 ca                	cmp    %cl,%dl
  8008b3:	74 04                	je     8008b9 <strfind+0x1a>
  8008b5:	84 d2                	test   %dl,%dl
  8008b7:	75 f2                	jne    8008ab <strfind+0xc>
			break;
	return (char *) s;
}
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    

008008bb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	57                   	push   %edi
  8008bf:	56                   	push   %esi
  8008c0:	53                   	push   %ebx
  8008c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8008c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  8008c7:	85 c9                	test   %ecx,%ecx
  8008c9:	74 37                	je     800902 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008cb:	f6 c2 03             	test   $0x3,%dl
  8008ce:	75 2a                	jne    8008fa <memset+0x3f>
  8008d0:	f6 c1 03             	test   $0x3,%cl
  8008d3:	75 25                	jne    8008fa <memset+0x3f>
		c &= 0xFF;
  8008d5:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008d9:	89 df                	mov    %ebx,%edi
  8008db:	c1 e7 08             	shl    $0x8,%edi
  8008de:	89 de                	mov    %ebx,%esi
  8008e0:	c1 e6 18             	shl    $0x18,%esi
  8008e3:	89 d8                	mov    %ebx,%eax
  8008e5:	c1 e0 10             	shl    $0x10,%eax
  8008e8:	09 f0                	or     %esi,%eax
  8008ea:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8008ec:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8008ef:	89 f8                	mov    %edi,%eax
  8008f1:	09 d8                	or     %ebx,%eax
  8008f3:	89 d7                	mov    %edx,%edi
  8008f5:	fc                   	cld    
  8008f6:	f3 ab                	rep stos %eax,%es:(%edi)
  8008f8:	eb 08                	jmp    800902 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008fa:	89 d7                	mov    %edx,%edi
  8008fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ff:	fc                   	cld    
  800900:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800902:	89 d0                	mov    %edx,%eax
  800904:	5b                   	pop    %ebx
  800905:	5e                   	pop    %esi
  800906:	5f                   	pop    %edi
  800907:	5d                   	pop    %ebp
  800908:	c3                   	ret    

00800909 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
  80090c:	57                   	push   %edi
  80090d:	56                   	push   %esi
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 75 0c             	mov    0xc(%ebp),%esi
  800914:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800917:	39 c6                	cmp    %eax,%esi
  800919:	73 35                	jae    800950 <memmove+0x47>
  80091b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80091e:	39 d0                	cmp    %edx,%eax
  800920:	73 2e                	jae    800950 <memmove+0x47>
		s += n;
		d += n;
  800922:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800925:	89 d6                	mov    %edx,%esi
  800927:	09 fe                	or     %edi,%esi
  800929:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80092f:	75 13                	jne    800944 <memmove+0x3b>
  800931:	f6 c1 03             	test   $0x3,%cl
  800934:	75 0e                	jne    800944 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  800936:	83 ef 04             	sub    $0x4,%edi
  800939:	8d 72 fc             	lea    -0x4(%edx),%esi
  80093c:	c1 e9 02             	shr    $0x2,%ecx
  80093f:	fd                   	std    
  800940:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800942:	eb 09                	jmp    80094d <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800944:	83 ef 01             	sub    $0x1,%edi
  800947:	8d 72 ff             	lea    -0x1(%edx),%esi
  80094a:	fd                   	std    
  80094b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80094d:	fc                   	cld    
  80094e:	eb 1d                	jmp    80096d <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800950:	89 f2                	mov    %esi,%edx
  800952:	09 c2                	or     %eax,%edx
  800954:	f6 c2 03             	test   $0x3,%dl
  800957:	75 0f                	jne    800968 <memmove+0x5f>
  800959:	f6 c1 03             	test   $0x3,%cl
  80095c:	75 0a                	jne    800968 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  80095e:	c1 e9 02             	shr    $0x2,%ecx
  800961:	89 c7                	mov    %eax,%edi
  800963:	fc                   	cld    
  800964:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800966:	eb 05                	jmp    80096d <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800968:	89 c7                	mov    %eax,%edi
  80096a:	fc                   	cld    
  80096b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80096d:	5e                   	pop    %esi
  80096e:	5f                   	pop    %edi
  80096f:	5d                   	pop    %ebp
  800970:	c3                   	ret    

00800971 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800974:	ff 75 10             	pushl  0x10(%ebp)
  800977:	ff 75 0c             	pushl  0xc(%ebp)
  80097a:	ff 75 08             	pushl  0x8(%ebp)
  80097d:	e8 87 ff ff ff       	call   800909 <memmove>
}
  800982:	c9                   	leave  
  800983:	c3                   	ret    

00800984 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	56                   	push   %esi
  800988:	53                   	push   %ebx
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098f:	89 c6                	mov    %eax,%esi
  800991:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800994:	eb 1a                	jmp    8009b0 <memcmp+0x2c>
		if (*s1 != *s2)
  800996:	0f b6 08             	movzbl (%eax),%ecx
  800999:	0f b6 1a             	movzbl (%edx),%ebx
  80099c:	38 d9                	cmp    %bl,%cl
  80099e:	74 0a                	je     8009aa <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8009a0:	0f b6 c1             	movzbl %cl,%eax
  8009a3:	0f b6 db             	movzbl %bl,%ebx
  8009a6:	29 d8                	sub    %ebx,%eax
  8009a8:	eb 0f                	jmp    8009b9 <memcmp+0x35>
		s1++, s2++;
  8009aa:	83 c0 01             	add    $0x1,%eax
  8009ad:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009b0:	39 f0                	cmp    %esi,%eax
  8009b2:	75 e2                	jne    800996 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8009b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009b9:	5b                   	pop    %ebx
  8009ba:	5e                   	pop    %esi
  8009bb:	5d                   	pop    %ebp
  8009bc:	c3                   	ret    

008009bd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009bd:	55                   	push   %ebp
  8009be:	89 e5                	mov    %esp,%ebp
  8009c0:	53                   	push   %ebx
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  8009c4:	89 c1                	mov    %eax,%ecx
  8009c6:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  8009c9:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8009cd:	eb 0a                	jmp    8009d9 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009cf:	0f b6 10             	movzbl (%eax),%edx
  8009d2:	39 da                	cmp    %ebx,%edx
  8009d4:	74 07                	je     8009dd <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8009d6:	83 c0 01             	add    $0x1,%eax
  8009d9:	39 c8                	cmp    %ecx,%eax
  8009db:	72 f2                	jb     8009cf <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8009dd:	5b                   	pop    %ebx
  8009de:	5d                   	pop    %ebp
  8009df:	c3                   	ret    

008009e0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	57                   	push   %edi
  8009e4:	56                   	push   %esi
  8009e5:	53                   	push   %ebx
  8009e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009ec:	eb 03                	jmp    8009f1 <strtol+0x11>
		s++;
  8009ee:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009f1:	0f b6 01             	movzbl (%ecx),%eax
  8009f4:	3c 20                	cmp    $0x20,%al
  8009f6:	74 f6                	je     8009ee <strtol+0xe>
  8009f8:	3c 09                	cmp    $0x9,%al
  8009fa:	74 f2                	je     8009ee <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8009fc:	3c 2b                	cmp    $0x2b,%al
  8009fe:	75 0a                	jne    800a0a <strtol+0x2a>
		s++;
  800a00:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a03:	bf 00 00 00 00       	mov    $0x0,%edi
  800a08:	eb 11                	jmp    800a1b <strtol+0x3b>
  800a0a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800a0f:	3c 2d                	cmp    $0x2d,%al
  800a11:	75 08                	jne    800a1b <strtol+0x3b>
		s++, neg = 1;
  800a13:	83 c1 01             	add    $0x1,%ecx
  800a16:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a1b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a21:	75 15                	jne    800a38 <strtol+0x58>
  800a23:	80 39 30             	cmpb   $0x30,(%ecx)
  800a26:	75 10                	jne    800a38 <strtol+0x58>
  800a28:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a2c:	75 7c                	jne    800aaa <strtol+0xca>
		s += 2, base = 16;
  800a2e:	83 c1 02             	add    $0x2,%ecx
  800a31:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a36:	eb 16                	jmp    800a4e <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800a38:	85 db                	test   %ebx,%ebx
  800a3a:	75 12                	jne    800a4e <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a3c:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a41:	80 39 30             	cmpb   $0x30,(%ecx)
  800a44:	75 08                	jne    800a4e <strtol+0x6e>
		s++, base = 8;
  800a46:	83 c1 01             	add    $0x1,%ecx
  800a49:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800a4e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a53:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800a56:	0f b6 11             	movzbl (%ecx),%edx
  800a59:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a5c:	89 f3                	mov    %esi,%ebx
  800a5e:	80 fb 09             	cmp    $0x9,%bl
  800a61:	77 08                	ja     800a6b <strtol+0x8b>
			dig = *s - '0';
  800a63:	0f be d2             	movsbl %dl,%edx
  800a66:	83 ea 30             	sub    $0x30,%edx
  800a69:	eb 22                	jmp    800a8d <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800a6b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a6e:	89 f3                	mov    %esi,%ebx
  800a70:	80 fb 19             	cmp    $0x19,%bl
  800a73:	77 08                	ja     800a7d <strtol+0x9d>
			dig = *s - 'a' + 10;
  800a75:	0f be d2             	movsbl %dl,%edx
  800a78:	83 ea 57             	sub    $0x57,%edx
  800a7b:	eb 10                	jmp    800a8d <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800a7d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a80:	89 f3                	mov    %esi,%ebx
  800a82:	80 fb 19             	cmp    $0x19,%bl
  800a85:	77 16                	ja     800a9d <strtol+0xbd>
			dig = *s - 'A' + 10;
  800a87:	0f be d2             	movsbl %dl,%edx
  800a8a:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800a8d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a90:	7d 0b                	jge    800a9d <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800a92:	83 c1 01             	add    $0x1,%ecx
  800a95:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a99:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800a9b:	eb b9                	jmp    800a56 <strtol+0x76>

	if (endptr)
  800a9d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aa1:	74 0d                	je     800ab0 <strtol+0xd0>
		*endptr = (char *) s;
  800aa3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aa6:	89 0e                	mov    %ecx,(%esi)
  800aa8:	eb 06                	jmp    800ab0 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800aaa:	85 db                	test   %ebx,%ebx
  800aac:	74 98                	je     800a46 <strtol+0x66>
  800aae:	eb 9e                	jmp    800a4e <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800ab0:	89 c2                	mov    %eax,%edx
  800ab2:	f7 da                	neg    %edx
  800ab4:	85 ff                	test   %edi,%edi
  800ab6:	0f 45 c2             	cmovne %edx,%eax
}
  800ab9:	5b                   	pop    %ebx
  800aba:	5e                   	pop    %esi
  800abb:	5f                   	pop    %edi
  800abc:	5d                   	pop    %ebp
  800abd:	c3                   	ret    

00800abe <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800abe:	55                   	push   %ebp
  800abf:	89 e5                	mov    %esp,%ebp
  800ac1:	57                   	push   %edi
  800ac2:	56                   	push   %esi
  800ac3:	53                   	push   %ebx
  800ac4:	83 ec 1c             	sub    $0x1c,%esp
  800ac7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800aca:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800acd:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800acf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ad5:	8b 7d 10             	mov    0x10(%ebp),%edi
  800ad8:	8b 75 14             	mov    0x14(%ebp),%esi
  800adb:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800add:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ae1:	74 1d                	je     800b00 <syscall+0x42>
  800ae3:	85 c0                	test   %eax,%eax
  800ae5:	7e 19                	jle    800b00 <syscall+0x42>
  800ae7:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800aea:	83 ec 0c             	sub    $0xc,%esp
  800aed:	50                   	push   %eax
  800aee:	52                   	push   %edx
  800aef:	68 9f 23 80 00       	push   $0x80239f
  800af4:	6a 23                	push   $0x23
  800af6:	68 bc 23 80 00       	push   $0x8023bc
  800afb:	e8 4d 11 00 00       	call   801c4d <_panic>

	return ret;
}
  800b00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b03:	5b                   	pop    %ebx
  800b04:	5e                   	pop    %esi
  800b05:	5f                   	pop    %edi
  800b06:	5d                   	pop    %ebp
  800b07:	c3                   	ret    

00800b08 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800b0e:	6a 00                	push   $0x0
  800b10:	6a 00                	push   $0x0
  800b12:	6a 00                	push   $0x0
  800b14:	ff 75 0c             	pushl  0xc(%ebp)
  800b17:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b1f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b24:	e8 95 ff ff ff       	call   800abe <syscall>
}
  800b29:	83 c4 10             	add    $0x10,%esp
  800b2c:	c9                   	leave  
  800b2d:	c3                   	ret    

00800b2e <sys_cgetc>:

int
sys_cgetc(void)
{
  800b2e:	55                   	push   %ebp
  800b2f:	89 e5                	mov    %esp,%ebp
  800b31:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800b34:	6a 00                	push   $0x0
  800b36:	6a 00                	push   $0x0
  800b38:	6a 00                	push   $0x0
  800b3a:	6a 00                	push   $0x0
  800b3c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b41:	ba 00 00 00 00       	mov    $0x0,%edx
  800b46:	b8 01 00 00 00       	mov    $0x1,%eax
  800b4b:	e8 6e ff ff ff       	call   800abe <syscall>
}
  800b50:	c9                   	leave  
  800b51:	c3                   	ret    

00800b52 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800b58:	6a 00                	push   $0x0
  800b5a:	6a 00                	push   $0x0
  800b5c:	6a 00                	push   $0x0
  800b5e:	6a 00                	push   $0x0
  800b60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b63:	ba 01 00 00 00       	mov    $0x1,%edx
  800b68:	b8 03 00 00 00       	mov    $0x3,%eax
  800b6d:	e8 4c ff ff ff       	call   800abe <syscall>
}
  800b72:	c9                   	leave  
  800b73:	c3                   	ret    

00800b74 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b7a:	6a 00                	push   $0x0
  800b7c:	6a 00                	push   $0x0
  800b7e:	6a 00                	push   $0x0
  800b80:	6a 00                	push   $0x0
  800b82:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b87:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8c:	b8 02 00 00 00       	mov    $0x2,%eax
  800b91:	e8 28 ff ff ff       	call   800abe <syscall>
}
  800b96:	c9                   	leave  
  800b97:	c3                   	ret    

00800b98 <sys_yield>:

void
sys_yield(void)
{
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b9e:	6a 00                	push   $0x0
  800ba0:	6a 00                	push   $0x0
  800ba2:	6a 00                	push   $0x0
  800ba4:	6a 00                	push   $0x0
  800ba6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bab:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bb5:	e8 04 ff ff ff       	call   800abe <syscall>
}
  800bba:	83 c4 10             	add    $0x10,%esp
  800bbd:	c9                   	leave  
  800bbe:	c3                   	ret    

00800bbf <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800bc5:	6a 00                	push   $0x0
  800bc7:	6a 00                	push   $0x0
  800bc9:	ff 75 10             	pushl  0x10(%ebp)
  800bcc:	ff 75 0c             	pushl  0xc(%ebp)
  800bcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd2:	ba 01 00 00 00       	mov    $0x1,%edx
  800bd7:	b8 04 00 00 00       	mov    $0x4,%eax
  800bdc:	e8 dd fe ff ff       	call   800abe <syscall>
}
  800be1:	c9                   	leave  
  800be2:	c3                   	ret    

00800be3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800be9:	ff 75 18             	pushl  0x18(%ebp)
  800bec:	ff 75 14             	pushl  0x14(%ebp)
  800bef:	ff 75 10             	pushl  0x10(%ebp)
  800bf2:	ff 75 0c             	pushl  0xc(%ebp)
  800bf5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf8:	ba 01 00 00 00       	mov    $0x1,%edx
  800bfd:	b8 05 00 00 00       	mov    $0x5,%eax
  800c02:	e8 b7 fe ff ff       	call   800abe <syscall>
}
  800c07:	c9                   	leave  
  800c08:	c3                   	ret    

00800c09 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800c0f:	6a 00                	push   $0x0
  800c11:	6a 00                	push   $0x0
  800c13:	6a 00                	push   $0x0
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c1b:	ba 01 00 00 00       	mov    $0x1,%edx
  800c20:	b8 06 00 00 00       	mov    $0x6,%eax
  800c25:	e8 94 fe ff ff       	call   800abe <syscall>
}
  800c2a:	c9                   	leave  
  800c2b:	c3                   	ret    

00800c2c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c32:	6a 00                	push   $0x0
  800c34:	6a 00                	push   $0x0
  800c36:	6a 00                	push   $0x0
  800c38:	ff 75 0c             	pushl  0xc(%ebp)
  800c3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c3e:	ba 01 00 00 00       	mov    $0x1,%edx
  800c43:	b8 08 00 00 00       	mov    $0x8,%eax
  800c48:	e8 71 fe ff ff       	call   800abe <syscall>
}
  800c4d:	c9                   	leave  
  800c4e:	c3                   	ret    

00800c4f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800c55:	6a 00                	push   $0x0
  800c57:	6a 00                	push   $0x0
  800c59:	6a 00                	push   $0x0
  800c5b:	ff 75 0c             	pushl  0xc(%ebp)
  800c5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c61:	ba 01 00 00 00       	mov    $0x1,%edx
  800c66:	b8 09 00 00 00       	mov    $0x9,%eax
  800c6b:	e8 4e fe ff ff       	call   800abe <syscall>
}
  800c70:	c9                   	leave  
  800c71:	c3                   	ret    

00800c72 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800c78:	6a 00                	push   $0x0
  800c7a:	6a 00                	push   $0x0
  800c7c:	6a 00                	push   $0x0
  800c7e:	ff 75 0c             	pushl  0xc(%ebp)
  800c81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c84:	ba 01 00 00 00       	mov    $0x1,%edx
  800c89:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c8e:	e8 2b fe ff ff       	call   800abe <syscall>
}
  800c93:	c9                   	leave  
  800c94:	c3                   	ret    

00800c95 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800c9b:	6a 00                	push   $0x0
  800c9d:	ff 75 14             	pushl  0x14(%ebp)
  800ca0:	ff 75 10             	pushl  0x10(%ebp)
  800ca3:	ff 75 0c             	pushl  0xc(%ebp)
  800ca6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ca9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cae:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cb3:	e8 06 fe ff ff       	call   800abe <syscall>
}
  800cb8:	c9                   	leave  
  800cb9:	c3                   	ret    

00800cba <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800cc0:	6a 00                	push   $0x0
  800cc2:	6a 00                	push   $0x0
  800cc4:	6a 00                	push   $0x0
  800cc6:	6a 00                	push   $0x0
  800cc8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ccb:	ba 01 00 00 00       	mov    $0x1,%edx
  800cd0:	b8 0d 00 00 00       	mov    $0xd,%eax
  800cd5:	e8 e4 fd ff ff       	call   800abe <syscall>
}
  800cda:	c9                   	leave  
  800cdb:	c3                   	ret    

00800cdc <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce5:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  800ce8:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  800cea:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800ced:	83 3a 01             	cmpl   $0x1,(%edx)
  800cf0:	7e 09                	jle    800cfb <argstart+0x1f>
  800cf2:	ba 71 20 80 00       	mov    $0x802071,%edx
  800cf7:	85 c9                	test   %ecx,%ecx
  800cf9:	75 05                	jne    800d00 <argstart+0x24>
  800cfb:	ba 00 00 00 00       	mov    $0x0,%edx
  800d00:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  800d03:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  800d0a:	5d                   	pop    %ebp
  800d0b:	c3                   	ret    

00800d0c <argnext>:

int
argnext(struct Argstate *args)
{
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
  800d0f:	53                   	push   %ebx
  800d10:	83 ec 04             	sub    $0x4,%esp
  800d13:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  800d16:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  800d1d:	8b 43 08             	mov    0x8(%ebx),%eax
  800d20:	85 c0                	test   %eax,%eax
  800d22:	74 6f                	je     800d93 <argnext+0x87>
		return -1;

	if (!*args->curarg) {
  800d24:	80 38 00             	cmpb   $0x0,(%eax)
  800d27:	75 4e                	jne    800d77 <argnext+0x6b>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  800d29:	8b 0b                	mov    (%ebx),%ecx
  800d2b:	83 39 01             	cmpl   $0x1,(%ecx)
  800d2e:	74 55                	je     800d85 <argnext+0x79>
		    || args->argv[1][0] != '-'
  800d30:	8b 53 04             	mov    0x4(%ebx),%edx
  800d33:	8b 42 04             	mov    0x4(%edx),%eax
  800d36:	80 38 2d             	cmpb   $0x2d,(%eax)
  800d39:	75 4a                	jne    800d85 <argnext+0x79>
		    || args->argv[1][1] == '\0')
  800d3b:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800d3f:	74 44                	je     800d85 <argnext+0x79>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  800d41:	83 c0 01             	add    $0x1,%eax
  800d44:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800d47:	83 ec 04             	sub    $0x4,%esp
  800d4a:	8b 01                	mov    (%ecx),%eax
  800d4c:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  800d53:	50                   	push   %eax
  800d54:	8d 42 08             	lea    0x8(%edx),%eax
  800d57:	50                   	push   %eax
  800d58:	83 c2 04             	add    $0x4,%edx
  800d5b:	52                   	push   %edx
  800d5c:	e8 a8 fb ff ff       	call   800909 <memmove>
		(*args->argc)--;
  800d61:	8b 03                	mov    (%ebx),%eax
  800d63:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800d66:	8b 43 08             	mov    0x8(%ebx),%eax
  800d69:	83 c4 10             	add    $0x10,%esp
  800d6c:	80 38 2d             	cmpb   $0x2d,(%eax)
  800d6f:	75 06                	jne    800d77 <argnext+0x6b>
  800d71:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800d75:	74 0e                	je     800d85 <argnext+0x79>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  800d77:	8b 53 08             	mov    0x8(%ebx),%edx
  800d7a:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  800d7d:	83 c2 01             	add    $0x1,%edx
  800d80:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  800d83:	eb 13                	jmp    800d98 <argnext+0x8c>

    endofargs:
	args->curarg = 0;
  800d85:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  800d8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800d91:	eb 05                	jmp    800d98 <argnext+0x8c>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
  800d93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  800d98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d9b:	c9                   	leave  
  800d9c:	c3                   	ret    

00800d9d <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	53                   	push   %ebx
  800da1:	83 ec 04             	sub    $0x4,%esp
  800da4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  800da7:	8b 43 08             	mov    0x8(%ebx),%eax
  800daa:	85 c0                	test   %eax,%eax
  800dac:	74 58                	je     800e06 <argnextvalue+0x69>
		return 0;
	if (*args->curarg) {
  800dae:	80 38 00             	cmpb   $0x0,(%eax)
  800db1:	74 0c                	je     800dbf <argnextvalue+0x22>
		args->argvalue = args->curarg;
  800db3:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  800db6:	c7 43 08 71 20 80 00 	movl   $0x802071,0x8(%ebx)
  800dbd:	eb 42                	jmp    800e01 <argnextvalue+0x64>
	} else if (*args->argc > 1) {
  800dbf:	8b 13                	mov    (%ebx),%edx
  800dc1:	83 3a 01             	cmpl   $0x1,(%edx)
  800dc4:	7e 2d                	jle    800df3 <argnextvalue+0x56>
		args->argvalue = args->argv[1];
  800dc6:	8b 43 04             	mov    0x4(%ebx),%eax
  800dc9:	8b 48 04             	mov    0x4(%eax),%ecx
  800dcc:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800dcf:	83 ec 04             	sub    $0x4,%esp
  800dd2:	8b 12                	mov    (%edx),%edx
  800dd4:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  800ddb:	52                   	push   %edx
  800ddc:	8d 50 08             	lea    0x8(%eax),%edx
  800ddf:	52                   	push   %edx
  800de0:	83 c0 04             	add    $0x4,%eax
  800de3:	50                   	push   %eax
  800de4:	e8 20 fb ff ff       	call   800909 <memmove>
		(*args->argc)--;
  800de9:	8b 03                	mov    (%ebx),%eax
  800deb:	83 28 01             	subl   $0x1,(%eax)
  800dee:	83 c4 10             	add    $0x10,%esp
  800df1:	eb 0e                	jmp    800e01 <argnextvalue+0x64>
	} else {
		args->argvalue = 0;
  800df3:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  800dfa:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  800e01:	8b 43 0c             	mov    0xc(%ebx),%eax
  800e04:	eb 05                	jmp    800e0b <argnextvalue+0x6e>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
  800e06:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
  800e0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e0e:	c9                   	leave  
  800e0f:	c3                   	ret    

00800e10 <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	83 ec 08             	sub    $0x8,%esp
  800e16:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  800e19:	8b 51 0c             	mov    0xc(%ecx),%edx
  800e1c:	89 d0                	mov    %edx,%eax
  800e1e:	85 d2                	test   %edx,%edx
  800e20:	75 0c                	jne    800e2e <argvalue+0x1e>
  800e22:	83 ec 0c             	sub    $0xc,%esp
  800e25:	51                   	push   %ecx
  800e26:	e8 72 ff ff ff       	call   800d9d <argnextvalue>
  800e2b:	83 c4 10             	add    $0x10,%esp
}
  800e2e:	c9                   	leave  
  800e2f:	c3                   	ret    

00800e30 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	05 00 00 00 30       	add    $0x30000000,%eax
  800e3b:	c1 e8 0c             	shr    $0xc,%eax
}
  800e3e:	5d                   	pop    %ebp
  800e3f:	c3                   	ret    

00800e40 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  800e43:	ff 75 08             	pushl  0x8(%ebp)
  800e46:	e8 e5 ff ff ff       	call   800e30 <fd2num>
  800e4b:	83 c4 04             	add    $0x4,%esp
  800e4e:	c1 e0 0c             	shl    $0xc,%eax
  800e51:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e56:	c9                   	leave  
  800e57:	c3                   	ret    

00800e58 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e5e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e63:	89 c2                	mov    %eax,%edx
  800e65:	c1 ea 16             	shr    $0x16,%edx
  800e68:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e6f:	f6 c2 01             	test   $0x1,%dl
  800e72:	74 11                	je     800e85 <fd_alloc+0x2d>
  800e74:	89 c2                	mov    %eax,%edx
  800e76:	c1 ea 0c             	shr    $0xc,%edx
  800e79:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e80:	f6 c2 01             	test   $0x1,%dl
  800e83:	75 09                	jne    800e8e <fd_alloc+0x36>
			*fd_store = fd;
  800e85:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e87:	b8 00 00 00 00       	mov    $0x0,%eax
  800e8c:	eb 17                	jmp    800ea5 <fd_alloc+0x4d>
  800e8e:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800e93:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e98:	75 c9                	jne    800e63 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e9a:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800ea0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800ea5:	5d                   	pop    %ebp
  800ea6:	c3                   	ret    

00800ea7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ea7:	55                   	push   %ebp
  800ea8:	89 e5                	mov    %esp,%ebp
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800ead:	83 f8 1f             	cmp    $0x1f,%eax
  800eb0:	77 36                	ja     800ee8 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800eb2:	c1 e0 0c             	shl    $0xc,%eax
  800eb5:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800eba:	89 c2                	mov    %eax,%edx
  800ebc:	c1 ea 16             	shr    $0x16,%edx
  800ebf:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ec6:	f6 c2 01             	test   $0x1,%dl
  800ec9:	74 24                	je     800eef <fd_lookup+0x48>
  800ecb:	89 c2                	mov    %eax,%edx
  800ecd:	c1 ea 0c             	shr    $0xc,%edx
  800ed0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ed7:	f6 c2 01             	test   $0x1,%dl
  800eda:	74 1a                	je     800ef6 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800edc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800edf:	89 02                	mov    %eax,(%edx)
	return 0;
  800ee1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee6:	eb 13                	jmp    800efb <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800ee8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eed:	eb 0c                	jmp    800efb <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800eef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ef4:	eb 05                	jmp    800efb <fd_lookup+0x54>
  800ef6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    

00800efd <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	83 ec 08             	sub    $0x8,%esp
  800f03:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f06:	ba 48 24 80 00       	mov    $0x802448,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f0b:	eb 13                	jmp    800f20 <dev_lookup+0x23>
  800f0d:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  800f10:	39 08                	cmp    %ecx,(%eax)
  800f12:	75 0c                	jne    800f20 <dev_lookup+0x23>
			*dev = devtab[i];
  800f14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f17:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f19:	b8 00 00 00 00       	mov    $0x0,%eax
  800f1e:	eb 2e                	jmp    800f4e <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800f20:	8b 02                	mov    (%edx),%eax
  800f22:	85 c0                	test   %eax,%eax
  800f24:	75 e7                	jne    800f0d <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f26:	a1 04 40 80 00       	mov    0x804004,%eax
  800f2b:	8b 40 48             	mov    0x48(%eax),%eax
  800f2e:	83 ec 04             	sub    $0x4,%esp
  800f31:	51                   	push   %ecx
  800f32:	50                   	push   %eax
  800f33:	68 cc 23 80 00       	push   $0x8023cc
  800f38:	e8 c7 f2 ff ff       	call   800204 <cprintf>
	*dev = 0;
  800f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f46:	83 c4 10             	add    $0x10,%esp
  800f49:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f4e:	c9                   	leave  
  800f4f:	c3                   	ret    

00800f50 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	56                   	push   %esi
  800f54:	53                   	push   %ebx
  800f55:	83 ec 10             	sub    $0x10,%esp
  800f58:	8b 75 08             	mov    0x8(%ebp),%esi
  800f5b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f5e:	56                   	push   %esi
  800f5f:	e8 cc fe ff ff       	call   800e30 <fd2num>
  800f64:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800f67:	89 14 24             	mov    %edx,(%esp)
  800f6a:	50                   	push   %eax
  800f6b:	e8 37 ff ff ff       	call   800ea7 <fd_lookup>
  800f70:	83 c4 08             	add    $0x8,%esp
  800f73:	85 c0                	test   %eax,%eax
  800f75:	78 05                	js     800f7c <fd_close+0x2c>
	    || fd != fd2)
  800f77:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800f7a:	74 0c                	je     800f88 <fd_close+0x38>
		return (must_exist ? r : 0);
  800f7c:	84 db                	test   %bl,%bl
  800f7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f83:	0f 44 c2             	cmove  %edx,%eax
  800f86:	eb 41                	jmp    800fc9 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f88:	83 ec 08             	sub    $0x8,%esp
  800f8b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800f8e:	50                   	push   %eax
  800f8f:	ff 36                	pushl  (%esi)
  800f91:	e8 67 ff ff ff       	call   800efd <dev_lookup>
  800f96:	89 c3                	mov    %eax,%ebx
  800f98:	83 c4 10             	add    $0x10,%esp
  800f9b:	85 c0                	test   %eax,%eax
  800f9d:	78 1a                	js     800fb9 <fd_close+0x69>
		if (dev->dev_close)
  800f9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fa2:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800fa5:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800faa:	85 c0                	test   %eax,%eax
  800fac:	74 0b                	je     800fb9 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  800fae:	83 ec 0c             	sub    $0xc,%esp
  800fb1:	56                   	push   %esi
  800fb2:	ff d0                	call   *%eax
  800fb4:	89 c3                	mov    %eax,%ebx
  800fb6:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800fb9:	83 ec 08             	sub    $0x8,%esp
  800fbc:	56                   	push   %esi
  800fbd:	6a 00                	push   $0x0
  800fbf:	e8 45 fc ff ff       	call   800c09 <sys_page_unmap>
	return r;
  800fc4:	83 c4 10             	add    $0x10,%esp
  800fc7:	89 d8                	mov    %ebx,%eax
}
  800fc9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fcc:	5b                   	pop    %ebx
  800fcd:	5e                   	pop    %esi
  800fce:	5d                   	pop    %ebp
  800fcf:	c3                   	ret    

00800fd0 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fd9:	50                   	push   %eax
  800fda:	ff 75 08             	pushl  0x8(%ebp)
  800fdd:	e8 c5 fe ff ff       	call   800ea7 <fd_lookup>
  800fe2:	83 c4 08             	add    $0x8,%esp
  800fe5:	85 c0                	test   %eax,%eax
  800fe7:	78 10                	js     800ff9 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800fe9:	83 ec 08             	sub    $0x8,%esp
  800fec:	6a 01                	push   $0x1
  800fee:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff1:	e8 5a ff ff ff       	call   800f50 <fd_close>
  800ff6:	83 c4 10             	add    $0x10,%esp
}
  800ff9:	c9                   	leave  
  800ffa:	c3                   	ret    

00800ffb <close_all>:

void
close_all(void)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	53                   	push   %ebx
  800fff:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801002:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801007:	83 ec 0c             	sub    $0xc,%esp
  80100a:	53                   	push   %ebx
  80100b:	e8 c0 ff ff ff       	call   800fd0 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801010:	83 c3 01             	add    $0x1,%ebx
  801013:	83 c4 10             	add    $0x10,%esp
  801016:	83 fb 20             	cmp    $0x20,%ebx
  801019:	75 ec                	jne    801007 <close_all+0xc>
		close(i);
}
  80101b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80101e:	c9                   	leave  
  80101f:	c3                   	ret    

00801020 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	57                   	push   %edi
  801024:	56                   	push   %esi
  801025:	53                   	push   %ebx
  801026:	83 ec 2c             	sub    $0x2c,%esp
  801029:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80102c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80102f:	50                   	push   %eax
  801030:	ff 75 08             	pushl  0x8(%ebp)
  801033:	e8 6f fe ff ff       	call   800ea7 <fd_lookup>
  801038:	83 c4 08             	add    $0x8,%esp
  80103b:	85 c0                	test   %eax,%eax
  80103d:	0f 88 c1 00 00 00    	js     801104 <dup+0xe4>
		return r;
	close(newfdnum);
  801043:	83 ec 0c             	sub    $0xc,%esp
  801046:	56                   	push   %esi
  801047:	e8 84 ff ff ff       	call   800fd0 <close>

	newfd = INDEX2FD(newfdnum);
  80104c:	89 f3                	mov    %esi,%ebx
  80104e:	c1 e3 0c             	shl    $0xc,%ebx
  801051:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801057:	83 c4 04             	add    $0x4,%esp
  80105a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80105d:	e8 de fd ff ff       	call   800e40 <fd2data>
  801062:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  801064:	89 1c 24             	mov    %ebx,(%esp)
  801067:	e8 d4 fd ff ff       	call   800e40 <fd2data>
  80106c:	83 c4 10             	add    $0x10,%esp
  80106f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801072:	89 f8                	mov    %edi,%eax
  801074:	c1 e8 16             	shr    $0x16,%eax
  801077:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80107e:	a8 01                	test   $0x1,%al
  801080:	74 37                	je     8010b9 <dup+0x99>
  801082:	89 f8                	mov    %edi,%eax
  801084:	c1 e8 0c             	shr    $0xc,%eax
  801087:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80108e:	f6 c2 01             	test   $0x1,%dl
  801091:	74 26                	je     8010b9 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801093:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80109a:	83 ec 0c             	sub    $0xc,%esp
  80109d:	25 07 0e 00 00       	and    $0xe07,%eax
  8010a2:	50                   	push   %eax
  8010a3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8010a6:	6a 00                	push   $0x0
  8010a8:	57                   	push   %edi
  8010a9:	6a 00                	push   $0x0
  8010ab:	e8 33 fb ff ff       	call   800be3 <sys_page_map>
  8010b0:	89 c7                	mov    %eax,%edi
  8010b2:	83 c4 20             	add    $0x20,%esp
  8010b5:	85 c0                	test   %eax,%eax
  8010b7:	78 2e                	js     8010e7 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010bc:	89 d0                	mov    %edx,%eax
  8010be:	c1 e8 0c             	shr    $0xc,%eax
  8010c1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010c8:	83 ec 0c             	sub    $0xc,%esp
  8010cb:	25 07 0e 00 00       	and    $0xe07,%eax
  8010d0:	50                   	push   %eax
  8010d1:	53                   	push   %ebx
  8010d2:	6a 00                	push   $0x0
  8010d4:	52                   	push   %edx
  8010d5:	6a 00                	push   $0x0
  8010d7:	e8 07 fb ff ff       	call   800be3 <sys_page_map>
  8010dc:	89 c7                	mov    %eax,%edi
  8010de:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  8010e1:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010e3:	85 ff                	test   %edi,%edi
  8010e5:	79 1d                	jns    801104 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8010e7:	83 ec 08             	sub    $0x8,%esp
  8010ea:	53                   	push   %ebx
  8010eb:	6a 00                	push   $0x0
  8010ed:	e8 17 fb ff ff       	call   800c09 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010f2:	83 c4 08             	add    $0x8,%esp
  8010f5:	ff 75 d4             	pushl  -0x2c(%ebp)
  8010f8:	6a 00                	push   $0x0
  8010fa:	e8 0a fb ff ff       	call   800c09 <sys_page_unmap>
	return r;
  8010ff:	83 c4 10             	add    $0x10,%esp
  801102:	89 f8                	mov    %edi,%eax
}
  801104:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801107:	5b                   	pop    %ebx
  801108:	5e                   	pop    %esi
  801109:	5f                   	pop    %edi
  80110a:	5d                   	pop    %ebp
  80110b:	c3                   	ret    

0080110c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	53                   	push   %ebx
  801110:	83 ec 14             	sub    $0x14,%esp
  801113:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801116:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801119:	50                   	push   %eax
  80111a:	53                   	push   %ebx
  80111b:	e8 87 fd ff ff       	call   800ea7 <fd_lookup>
  801120:	83 c4 08             	add    $0x8,%esp
  801123:	89 c2                	mov    %eax,%edx
  801125:	85 c0                	test   %eax,%eax
  801127:	78 6d                	js     801196 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801129:	83 ec 08             	sub    $0x8,%esp
  80112c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80112f:	50                   	push   %eax
  801130:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801133:	ff 30                	pushl  (%eax)
  801135:	e8 c3 fd ff ff       	call   800efd <dev_lookup>
  80113a:	83 c4 10             	add    $0x10,%esp
  80113d:	85 c0                	test   %eax,%eax
  80113f:	78 4c                	js     80118d <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801141:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801144:	8b 42 08             	mov    0x8(%edx),%eax
  801147:	83 e0 03             	and    $0x3,%eax
  80114a:	83 f8 01             	cmp    $0x1,%eax
  80114d:	75 21                	jne    801170 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80114f:	a1 04 40 80 00       	mov    0x804004,%eax
  801154:	8b 40 48             	mov    0x48(%eax),%eax
  801157:	83 ec 04             	sub    $0x4,%esp
  80115a:	53                   	push   %ebx
  80115b:	50                   	push   %eax
  80115c:	68 0d 24 80 00       	push   $0x80240d
  801161:	e8 9e f0 ff ff       	call   800204 <cprintf>
		return -E_INVAL;
  801166:	83 c4 10             	add    $0x10,%esp
  801169:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80116e:	eb 26                	jmp    801196 <read+0x8a>
	}
	if (!dev->dev_read)
  801170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801173:	8b 40 08             	mov    0x8(%eax),%eax
  801176:	85 c0                	test   %eax,%eax
  801178:	74 17                	je     801191 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80117a:	83 ec 04             	sub    $0x4,%esp
  80117d:	ff 75 10             	pushl  0x10(%ebp)
  801180:	ff 75 0c             	pushl  0xc(%ebp)
  801183:	52                   	push   %edx
  801184:	ff d0                	call   *%eax
  801186:	89 c2                	mov    %eax,%edx
  801188:	83 c4 10             	add    $0x10,%esp
  80118b:	eb 09                	jmp    801196 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80118d:	89 c2                	mov    %eax,%edx
  80118f:	eb 05                	jmp    801196 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801191:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  801196:	89 d0                	mov    %edx,%eax
  801198:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80119b:	c9                   	leave  
  80119c:	c3                   	ret    

0080119d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
  8011a0:	57                   	push   %edi
  8011a1:	56                   	push   %esi
  8011a2:	53                   	push   %ebx
  8011a3:	83 ec 0c             	sub    $0xc,%esp
  8011a6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011a9:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011b1:	eb 21                	jmp    8011d4 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011b3:	83 ec 04             	sub    $0x4,%esp
  8011b6:	89 f0                	mov    %esi,%eax
  8011b8:	29 d8                	sub    %ebx,%eax
  8011ba:	50                   	push   %eax
  8011bb:	89 d8                	mov    %ebx,%eax
  8011bd:	03 45 0c             	add    0xc(%ebp),%eax
  8011c0:	50                   	push   %eax
  8011c1:	57                   	push   %edi
  8011c2:	e8 45 ff ff ff       	call   80110c <read>
		if (m < 0)
  8011c7:	83 c4 10             	add    $0x10,%esp
  8011ca:	85 c0                	test   %eax,%eax
  8011cc:	78 10                	js     8011de <readn+0x41>
			return m;
		if (m == 0)
  8011ce:	85 c0                	test   %eax,%eax
  8011d0:	74 0a                	je     8011dc <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011d2:	01 c3                	add    %eax,%ebx
  8011d4:	39 f3                	cmp    %esi,%ebx
  8011d6:	72 db                	jb     8011b3 <readn+0x16>
  8011d8:	89 d8                	mov    %ebx,%eax
  8011da:	eb 02                	jmp    8011de <readn+0x41>
  8011dc:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8011de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011e1:	5b                   	pop    %ebx
  8011e2:	5e                   	pop    %esi
  8011e3:	5f                   	pop    %edi
  8011e4:	5d                   	pop    %ebp
  8011e5:	c3                   	ret    

008011e6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	53                   	push   %ebx
  8011ea:	83 ec 14             	sub    $0x14,%esp
  8011ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011f3:	50                   	push   %eax
  8011f4:	53                   	push   %ebx
  8011f5:	e8 ad fc ff ff       	call   800ea7 <fd_lookup>
  8011fa:	83 c4 08             	add    $0x8,%esp
  8011fd:	89 c2                	mov    %eax,%edx
  8011ff:	85 c0                	test   %eax,%eax
  801201:	78 68                	js     80126b <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801203:	83 ec 08             	sub    $0x8,%esp
  801206:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801209:	50                   	push   %eax
  80120a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80120d:	ff 30                	pushl  (%eax)
  80120f:	e8 e9 fc ff ff       	call   800efd <dev_lookup>
  801214:	83 c4 10             	add    $0x10,%esp
  801217:	85 c0                	test   %eax,%eax
  801219:	78 47                	js     801262 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80121b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80121e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801222:	75 21                	jne    801245 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801224:	a1 04 40 80 00       	mov    0x804004,%eax
  801229:	8b 40 48             	mov    0x48(%eax),%eax
  80122c:	83 ec 04             	sub    $0x4,%esp
  80122f:	53                   	push   %ebx
  801230:	50                   	push   %eax
  801231:	68 29 24 80 00       	push   $0x802429
  801236:	e8 c9 ef ff ff       	call   800204 <cprintf>
		return -E_INVAL;
  80123b:	83 c4 10             	add    $0x10,%esp
  80123e:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801243:	eb 26                	jmp    80126b <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801245:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801248:	8b 52 0c             	mov    0xc(%edx),%edx
  80124b:	85 d2                	test   %edx,%edx
  80124d:	74 17                	je     801266 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80124f:	83 ec 04             	sub    $0x4,%esp
  801252:	ff 75 10             	pushl  0x10(%ebp)
  801255:	ff 75 0c             	pushl  0xc(%ebp)
  801258:	50                   	push   %eax
  801259:	ff d2                	call   *%edx
  80125b:	89 c2                	mov    %eax,%edx
  80125d:	83 c4 10             	add    $0x10,%esp
  801260:	eb 09                	jmp    80126b <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801262:	89 c2                	mov    %eax,%edx
  801264:	eb 05                	jmp    80126b <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801266:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  80126b:	89 d0                	mov    %edx,%eax
  80126d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801270:	c9                   	leave  
  801271:	c3                   	ret    

00801272 <seek>:

int
seek(int fdnum, off_t offset)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801278:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80127b:	50                   	push   %eax
  80127c:	ff 75 08             	pushl  0x8(%ebp)
  80127f:	e8 23 fc ff ff       	call   800ea7 <fd_lookup>
  801284:	83 c4 08             	add    $0x8,%esp
  801287:	85 c0                	test   %eax,%eax
  801289:	78 0e                	js     801299 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80128b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801291:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801294:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801299:	c9                   	leave  
  80129a:	c3                   	ret    

0080129b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80129b:	55                   	push   %ebp
  80129c:	89 e5                	mov    %esp,%ebp
  80129e:	53                   	push   %ebx
  80129f:	83 ec 14             	sub    $0x14,%esp
  8012a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012a5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012a8:	50                   	push   %eax
  8012a9:	53                   	push   %ebx
  8012aa:	e8 f8 fb ff ff       	call   800ea7 <fd_lookup>
  8012af:	83 c4 08             	add    $0x8,%esp
  8012b2:	89 c2                	mov    %eax,%edx
  8012b4:	85 c0                	test   %eax,%eax
  8012b6:	78 65                	js     80131d <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012b8:	83 ec 08             	sub    $0x8,%esp
  8012bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012be:	50                   	push   %eax
  8012bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c2:	ff 30                	pushl  (%eax)
  8012c4:	e8 34 fc ff ff       	call   800efd <dev_lookup>
  8012c9:	83 c4 10             	add    $0x10,%esp
  8012cc:	85 c0                	test   %eax,%eax
  8012ce:	78 44                	js     801314 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012d7:	75 21                	jne    8012fa <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8012d9:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012de:	8b 40 48             	mov    0x48(%eax),%eax
  8012e1:	83 ec 04             	sub    $0x4,%esp
  8012e4:	53                   	push   %ebx
  8012e5:	50                   	push   %eax
  8012e6:	68 ec 23 80 00       	push   $0x8023ec
  8012eb:	e8 14 ef ff ff       	call   800204 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8012f0:	83 c4 10             	add    $0x10,%esp
  8012f3:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8012f8:	eb 23                	jmp    80131d <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  8012fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012fd:	8b 52 18             	mov    0x18(%edx),%edx
  801300:	85 d2                	test   %edx,%edx
  801302:	74 14                	je     801318 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801304:	83 ec 08             	sub    $0x8,%esp
  801307:	ff 75 0c             	pushl  0xc(%ebp)
  80130a:	50                   	push   %eax
  80130b:	ff d2                	call   *%edx
  80130d:	89 c2                	mov    %eax,%edx
  80130f:	83 c4 10             	add    $0x10,%esp
  801312:	eb 09                	jmp    80131d <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801314:	89 c2                	mov    %eax,%edx
  801316:	eb 05                	jmp    80131d <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801318:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  80131d:	89 d0                	mov    %edx,%eax
  80131f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801322:	c9                   	leave  
  801323:	c3                   	ret    

00801324 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
  801327:	53                   	push   %ebx
  801328:	83 ec 14             	sub    $0x14,%esp
  80132b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80132e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801331:	50                   	push   %eax
  801332:	ff 75 08             	pushl  0x8(%ebp)
  801335:	e8 6d fb ff ff       	call   800ea7 <fd_lookup>
  80133a:	83 c4 08             	add    $0x8,%esp
  80133d:	89 c2                	mov    %eax,%edx
  80133f:	85 c0                	test   %eax,%eax
  801341:	78 58                	js     80139b <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801343:	83 ec 08             	sub    $0x8,%esp
  801346:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801349:	50                   	push   %eax
  80134a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80134d:	ff 30                	pushl  (%eax)
  80134f:	e8 a9 fb ff ff       	call   800efd <dev_lookup>
  801354:	83 c4 10             	add    $0x10,%esp
  801357:	85 c0                	test   %eax,%eax
  801359:	78 37                	js     801392 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  80135b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801362:	74 32                	je     801396 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801364:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801367:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80136e:	00 00 00 
	stat->st_isdir = 0;
  801371:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801378:	00 00 00 
	stat->st_dev = dev;
  80137b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801381:	83 ec 08             	sub    $0x8,%esp
  801384:	53                   	push   %ebx
  801385:	ff 75 f0             	pushl  -0x10(%ebp)
  801388:	ff 50 14             	call   *0x14(%eax)
  80138b:	89 c2                	mov    %eax,%edx
  80138d:	83 c4 10             	add    $0x10,%esp
  801390:	eb 09                	jmp    80139b <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801392:	89 c2                	mov    %eax,%edx
  801394:	eb 05                	jmp    80139b <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801396:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80139b:	89 d0                	mov    %edx,%eax
  80139d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a0:	c9                   	leave  
  8013a1:	c3                   	ret    

008013a2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
  8013a5:	56                   	push   %esi
  8013a6:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013a7:	83 ec 08             	sub    $0x8,%esp
  8013aa:	6a 00                	push   $0x0
  8013ac:	ff 75 08             	pushl  0x8(%ebp)
  8013af:	e8 06 02 00 00       	call   8015ba <open>
  8013b4:	89 c3                	mov    %eax,%ebx
  8013b6:	83 c4 10             	add    $0x10,%esp
  8013b9:	85 c0                	test   %eax,%eax
  8013bb:	78 1b                	js     8013d8 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8013bd:	83 ec 08             	sub    $0x8,%esp
  8013c0:	ff 75 0c             	pushl  0xc(%ebp)
  8013c3:	50                   	push   %eax
  8013c4:	e8 5b ff ff ff       	call   801324 <fstat>
  8013c9:	89 c6                	mov    %eax,%esi
	close(fd);
  8013cb:	89 1c 24             	mov    %ebx,(%esp)
  8013ce:	e8 fd fb ff ff       	call   800fd0 <close>
	return r;
  8013d3:	83 c4 10             	add    $0x10,%esp
  8013d6:	89 f0                	mov    %esi,%eax
}
  8013d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013db:	5b                   	pop    %ebx
  8013dc:	5e                   	pop    %esi
  8013dd:	5d                   	pop    %ebp
  8013de:	c3                   	ret    

008013df <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
  8013e2:	56                   	push   %esi
  8013e3:	53                   	push   %ebx
  8013e4:	89 c6                	mov    %eax,%esi
  8013e6:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013e8:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013ef:	75 12                	jne    801403 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8013f1:	83 ec 0c             	sub    $0xc,%esp
  8013f4:	6a 01                	push   $0x1
  8013f6:	e8 57 09 00 00       	call   801d52 <ipc_find_env>
  8013fb:	a3 00 40 80 00       	mov    %eax,0x804000
  801400:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801403:	6a 07                	push   $0x7
  801405:	68 00 50 80 00       	push   $0x805000
  80140a:	56                   	push   %esi
  80140b:	ff 35 00 40 80 00    	pushl  0x804000
  801411:	e8 e8 08 00 00       	call   801cfe <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801416:	83 c4 0c             	add    $0xc,%esp
  801419:	6a 00                	push   $0x0
  80141b:	53                   	push   %ebx
  80141c:	6a 00                	push   $0x0
  80141e:	e8 70 08 00 00       	call   801c93 <ipc_recv>
}
  801423:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801426:	5b                   	pop    %ebx
  801427:	5e                   	pop    %esi
  801428:	5d                   	pop    %ebp
  801429:	c3                   	ret    

0080142a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
  80142d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	8b 40 0c             	mov    0xc(%eax),%eax
  801436:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80143b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801443:	ba 00 00 00 00       	mov    $0x0,%edx
  801448:	b8 02 00 00 00       	mov    $0x2,%eax
  80144d:	e8 8d ff ff ff       	call   8013df <fsipc>
}
  801452:	c9                   	leave  
  801453:	c3                   	ret    

00801454 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
  801457:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80145a:	8b 45 08             	mov    0x8(%ebp),%eax
  80145d:	8b 40 0c             	mov    0xc(%eax),%eax
  801460:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801465:	ba 00 00 00 00       	mov    $0x0,%edx
  80146a:	b8 06 00 00 00       	mov    $0x6,%eax
  80146f:	e8 6b ff ff ff       	call   8013df <fsipc>
}
  801474:	c9                   	leave  
  801475:	c3                   	ret    

00801476 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
  801479:	53                   	push   %ebx
  80147a:	83 ec 04             	sub    $0x4,%esp
  80147d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801480:	8b 45 08             	mov    0x8(%ebp),%eax
  801483:	8b 40 0c             	mov    0xc(%eax),%eax
  801486:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80148b:	ba 00 00 00 00       	mov    $0x0,%edx
  801490:	b8 05 00 00 00       	mov    $0x5,%eax
  801495:	e8 45 ff ff ff       	call   8013df <fsipc>
  80149a:	85 c0                	test   %eax,%eax
  80149c:	78 2c                	js     8014ca <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80149e:	83 ec 08             	sub    $0x8,%esp
  8014a1:	68 00 50 80 00       	push   $0x805000
  8014a6:	53                   	push   %ebx
  8014a7:	e8 ca f2 ff ff       	call   800776 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014ac:	a1 80 50 80 00       	mov    0x805080,%eax
  8014b1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014b7:	a1 84 50 80 00       	mov    0x805084,%eax
  8014bc:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
  8014d2:	83 ec 08             	sub    $0x8,%esp
  8014d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d8:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014de:	8b 49 0c             	mov    0xc(%ecx),%ecx
  8014e1:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  8014e7:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8014ec:	76 22                	jbe    801510 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  8014ee:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  8014f5:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  8014f8:	83 ec 04             	sub    $0x4,%esp
  8014fb:	68 f8 0f 00 00       	push   $0xff8
  801500:	52                   	push   %edx
  801501:	68 08 50 80 00       	push   $0x805008
  801506:	e8 fe f3 ff ff       	call   800909 <memmove>
  80150b:	83 c4 10             	add    $0x10,%esp
  80150e:	eb 17                	jmp    801527 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  801510:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  801515:	83 ec 04             	sub    $0x4,%esp
  801518:	50                   	push   %eax
  801519:	52                   	push   %edx
  80151a:	68 08 50 80 00       	push   $0x805008
  80151f:	e8 e5 f3 ff ff       	call   800909 <memmove>
  801524:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  801527:	ba 00 00 00 00       	mov    $0x0,%edx
  80152c:	b8 04 00 00 00       	mov    $0x4,%eax
  801531:	e8 a9 fe ff ff       	call   8013df <fsipc>
	if (result < 0)
		return result;

	return result;
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	56                   	push   %esi
  80153c:	53                   	push   %ebx
  80153d:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801540:	8b 45 08             	mov    0x8(%ebp),%eax
  801543:	8b 40 0c             	mov    0xc(%eax),%eax
  801546:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80154b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801551:	ba 00 00 00 00       	mov    $0x0,%edx
  801556:	b8 03 00 00 00       	mov    $0x3,%eax
  80155b:	e8 7f fe ff ff       	call   8013df <fsipc>
  801560:	89 c3                	mov    %eax,%ebx
  801562:	85 c0                	test   %eax,%eax
  801564:	78 4b                	js     8015b1 <devfile_read+0x79>
		return r;
	assert(r <= n);
  801566:	39 c6                	cmp    %eax,%esi
  801568:	73 16                	jae    801580 <devfile_read+0x48>
  80156a:	68 58 24 80 00       	push   $0x802458
  80156f:	68 5f 24 80 00       	push   $0x80245f
  801574:	6a 7c                	push   $0x7c
  801576:	68 74 24 80 00       	push   $0x802474
  80157b:	e8 cd 06 00 00       	call   801c4d <_panic>
	assert(r <= PGSIZE);
  801580:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801585:	7e 16                	jle    80159d <devfile_read+0x65>
  801587:	68 7f 24 80 00       	push   $0x80247f
  80158c:	68 5f 24 80 00       	push   $0x80245f
  801591:	6a 7d                	push   $0x7d
  801593:	68 74 24 80 00       	push   $0x802474
  801598:	e8 b0 06 00 00       	call   801c4d <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80159d:	83 ec 04             	sub    $0x4,%esp
  8015a0:	50                   	push   %eax
  8015a1:	68 00 50 80 00       	push   $0x805000
  8015a6:	ff 75 0c             	pushl  0xc(%ebp)
  8015a9:	e8 5b f3 ff ff       	call   800909 <memmove>
	return r;
  8015ae:	83 c4 10             	add    $0x10,%esp
}
  8015b1:	89 d8                	mov    %ebx,%eax
  8015b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b6:	5b                   	pop    %ebx
  8015b7:	5e                   	pop    %esi
  8015b8:	5d                   	pop    %ebp
  8015b9:	c3                   	ret    

008015ba <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	53                   	push   %ebx
  8015be:	83 ec 20             	sub    $0x20,%esp
  8015c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8015c4:	53                   	push   %ebx
  8015c5:	e8 73 f1 ff ff       	call   80073d <strlen>
  8015ca:	83 c4 10             	add    $0x10,%esp
  8015cd:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015d2:	7f 67                	jg     80163b <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8015d4:	83 ec 0c             	sub    $0xc,%esp
  8015d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015da:	50                   	push   %eax
  8015db:	e8 78 f8 ff ff       	call   800e58 <fd_alloc>
  8015e0:	83 c4 10             	add    $0x10,%esp
		return r;
  8015e3:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8015e5:	85 c0                	test   %eax,%eax
  8015e7:	78 57                	js     801640 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8015e9:	83 ec 08             	sub    $0x8,%esp
  8015ec:	53                   	push   %ebx
  8015ed:	68 00 50 80 00       	push   $0x805000
  8015f2:	e8 7f f1 ff ff       	call   800776 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fa:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801602:	b8 01 00 00 00       	mov    $0x1,%eax
  801607:	e8 d3 fd ff ff       	call   8013df <fsipc>
  80160c:	89 c3                	mov    %eax,%ebx
  80160e:	83 c4 10             	add    $0x10,%esp
  801611:	85 c0                	test   %eax,%eax
  801613:	79 14                	jns    801629 <open+0x6f>
		fd_close(fd, 0);
  801615:	83 ec 08             	sub    $0x8,%esp
  801618:	6a 00                	push   $0x0
  80161a:	ff 75 f4             	pushl  -0xc(%ebp)
  80161d:	e8 2e f9 ff ff       	call   800f50 <fd_close>
		return r;
  801622:	83 c4 10             	add    $0x10,%esp
  801625:	89 da                	mov    %ebx,%edx
  801627:	eb 17                	jmp    801640 <open+0x86>
	}

	return fd2num(fd);
  801629:	83 ec 0c             	sub    $0xc,%esp
  80162c:	ff 75 f4             	pushl  -0xc(%ebp)
  80162f:	e8 fc f7 ff ff       	call   800e30 <fd2num>
  801634:	89 c2                	mov    %eax,%edx
  801636:	83 c4 10             	add    $0x10,%esp
  801639:	eb 05                	jmp    801640 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80163b:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801640:	89 d0                	mov    %edx,%eax
  801642:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
  80164a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80164d:	ba 00 00 00 00       	mov    $0x0,%edx
  801652:	b8 08 00 00 00       	mov    $0x8,%eax
  801657:	e8 83 fd ff ff       	call   8013df <fsipc>
}
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80165e:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801662:	7e 37                	jle    80169b <writebuf+0x3d>
};


static void
writebuf(struct printbuf *b)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
  801667:	53                   	push   %ebx
  801668:	83 ec 08             	sub    $0x8,%esp
  80166b:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
		ssize_t result = write(b->fd, b->buf, b->idx);
  80166d:	ff 70 04             	pushl  0x4(%eax)
  801670:	8d 40 10             	lea    0x10(%eax),%eax
  801673:	50                   	push   %eax
  801674:	ff 33                	pushl  (%ebx)
  801676:	e8 6b fb ff ff       	call   8011e6 <write>
		if (result > 0)
  80167b:	83 c4 10             	add    $0x10,%esp
  80167e:	85 c0                	test   %eax,%eax
  801680:	7e 03                	jle    801685 <writebuf+0x27>
			b->result += result;
  801682:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801685:	3b 43 04             	cmp    0x4(%ebx),%eax
  801688:	74 0d                	je     801697 <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  80168a:	85 c0                	test   %eax,%eax
  80168c:	ba 00 00 00 00       	mov    $0x0,%edx
  801691:	0f 4f c2             	cmovg  %edx,%eax
  801694:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801697:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80169a:	c9                   	leave  
  80169b:	f3 c3                	repz ret 

0080169d <putch>:

static void
putch(int ch, void *thunk)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
  8016a0:	53                   	push   %ebx
  8016a1:	83 ec 04             	sub    $0x4,%esp
  8016a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8016a7:	8b 53 04             	mov    0x4(%ebx),%edx
  8016aa:	8d 42 01             	lea    0x1(%edx),%eax
  8016ad:	89 43 04             	mov    %eax,0x4(%ebx)
  8016b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016b3:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8016b7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8016bc:	75 0e                	jne    8016cc <putch+0x2f>
		writebuf(b);
  8016be:	89 d8                	mov    %ebx,%eax
  8016c0:	e8 99 ff ff ff       	call   80165e <writebuf>
		b->idx = 0;
  8016c5:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  8016cc:	83 c4 04             	add    $0x4,%esp
  8016cf:	5b                   	pop    %ebx
  8016d0:	5d                   	pop    %ebp
  8016d1:	c3                   	ret    

008016d2 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
  8016d5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8016e4:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8016eb:	00 00 00 
	b.result = 0;
  8016ee:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8016f5:	00 00 00 
	b.error = 1;
  8016f8:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8016ff:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801702:	ff 75 10             	pushl  0x10(%ebp)
  801705:	ff 75 0c             	pushl  0xc(%ebp)
  801708:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80170e:	50                   	push   %eax
  80170f:	68 9d 16 80 00       	push   $0x80169d
  801714:	e8 54 ec ff ff       	call   80036d <vprintfmt>
	if (b.idx > 0)
  801719:	83 c4 10             	add    $0x10,%esp
  80171c:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801723:	7e 0b                	jle    801730 <vfprintf+0x5e>
		writebuf(&b);
  801725:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80172b:	e8 2e ff ff ff       	call   80165e <writebuf>

	return (b.result ? b.result : b.error);
  801730:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801736:	85 c0                	test   %eax,%eax
  801738:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
  801744:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801747:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  80174a:	50                   	push   %eax
  80174b:	ff 75 0c             	pushl  0xc(%ebp)
  80174e:	ff 75 08             	pushl  0x8(%ebp)
  801751:	e8 7c ff ff ff       	call   8016d2 <vfprintf>
	va_end(ap);

	return cnt;
}
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <printf>:

int
printf(const char *fmt, ...)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80175e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801761:	50                   	push   %eax
  801762:	ff 75 08             	pushl  0x8(%ebp)
  801765:	6a 01                	push   $0x1
  801767:	e8 66 ff ff ff       	call   8016d2 <vfprintf>
	va_end(ap);

	return cnt;
}
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
  801771:	56                   	push   %esi
  801772:	53                   	push   %ebx
  801773:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801776:	83 ec 0c             	sub    $0xc,%esp
  801779:	ff 75 08             	pushl  0x8(%ebp)
  80177c:	e8 bf f6 ff ff       	call   800e40 <fd2data>
  801781:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801783:	83 c4 08             	add    $0x8,%esp
  801786:	68 8b 24 80 00       	push   $0x80248b
  80178b:	53                   	push   %ebx
  80178c:	e8 e5 ef ff ff       	call   800776 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801791:	8b 46 04             	mov    0x4(%esi),%eax
  801794:	2b 06                	sub    (%esi),%eax
  801796:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80179c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017a3:	00 00 00 
	stat->st_dev = &devpipe;
  8017a6:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8017ad:	30 80 00 
	return 0;
}
  8017b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b8:	5b                   	pop    %ebx
  8017b9:	5e                   	pop    %esi
  8017ba:	5d                   	pop    %ebp
  8017bb:	c3                   	ret    

008017bc <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	53                   	push   %ebx
  8017c0:	83 ec 0c             	sub    $0xc,%esp
  8017c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8017c6:	53                   	push   %ebx
  8017c7:	6a 00                	push   $0x0
  8017c9:	e8 3b f4 ff ff       	call   800c09 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8017ce:	89 1c 24             	mov    %ebx,(%esp)
  8017d1:	e8 6a f6 ff ff       	call   800e40 <fd2data>
  8017d6:	83 c4 08             	add    $0x8,%esp
  8017d9:	50                   	push   %eax
  8017da:	6a 00                	push   $0x0
  8017dc:	e8 28 f4 ff ff       	call   800c09 <sys_page_unmap>
}
  8017e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	57                   	push   %edi
  8017ea:	56                   	push   %esi
  8017eb:	53                   	push   %ebx
  8017ec:	83 ec 1c             	sub    $0x1c,%esp
  8017ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8017f2:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8017f4:	a1 04 40 80 00       	mov    0x804004,%eax
  8017f9:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  8017fc:	83 ec 0c             	sub    $0xc,%esp
  8017ff:	ff 75 e0             	pushl  -0x20(%ebp)
  801802:	e8 84 05 00 00       	call   801d8b <pageref>
  801807:	89 c3                	mov    %eax,%ebx
  801809:	89 3c 24             	mov    %edi,(%esp)
  80180c:	e8 7a 05 00 00       	call   801d8b <pageref>
  801811:	83 c4 10             	add    $0x10,%esp
  801814:	39 c3                	cmp    %eax,%ebx
  801816:	0f 94 c1             	sete   %cl
  801819:	0f b6 c9             	movzbl %cl,%ecx
  80181c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  80181f:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801825:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801828:	39 ce                	cmp    %ecx,%esi
  80182a:	74 1b                	je     801847 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  80182c:	39 c3                	cmp    %eax,%ebx
  80182e:	75 c4                	jne    8017f4 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801830:	8b 42 58             	mov    0x58(%edx),%eax
  801833:	ff 75 e4             	pushl  -0x1c(%ebp)
  801836:	50                   	push   %eax
  801837:	56                   	push   %esi
  801838:	68 92 24 80 00       	push   $0x802492
  80183d:	e8 c2 e9 ff ff       	call   800204 <cprintf>
  801842:	83 c4 10             	add    $0x10,%esp
  801845:	eb ad                	jmp    8017f4 <_pipeisclosed+0xe>
	}
}
  801847:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80184a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80184d:	5b                   	pop    %ebx
  80184e:	5e                   	pop    %esi
  80184f:	5f                   	pop    %edi
  801850:	5d                   	pop    %ebp
  801851:	c3                   	ret    

00801852 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
  801855:	57                   	push   %edi
  801856:	56                   	push   %esi
  801857:	53                   	push   %ebx
  801858:	83 ec 28             	sub    $0x28,%esp
  80185b:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80185e:	56                   	push   %esi
  80185f:	e8 dc f5 ff ff       	call   800e40 <fd2data>
  801864:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801866:	83 c4 10             	add    $0x10,%esp
  801869:	bf 00 00 00 00       	mov    $0x0,%edi
  80186e:	eb 4b                	jmp    8018bb <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801870:	89 da                	mov    %ebx,%edx
  801872:	89 f0                	mov    %esi,%eax
  801874:	e8 6d ff ff ff       	call   8017e6 <_pipeisclosed>
  801879:	85 c0                	test   %eax,%eax
  80187b:	75 48                	jne    8018c5 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80187d:	e8 16 f3 ff ff       	call   800b98 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801882:	8b 43 04             	mov    0x4(%ebx),%eax
  801885:	8b 0b                	mov    (%ebx),%ecx
  801887:	8d 51 20             	lea    0x20(%ecx),%edx
  80188a:	39 d0                	cmp    %edx,%eax
  80188c:	73 e2                	jae    801870 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80188e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801891:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801895:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801898:	89 c2                	mov    %eax,%edx
  80189a:	c1 fa 1f             	sar    $0x1f,%edx
  80189d:	89 d1                	mov    %edx,%ecx
  80189f:	c1 e9 1b             	shr    $0x1b,%ecx
  8018a2:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8018a5:	83 e2 1f             	and    $0x1f,%edx
  8018a8:	29 ca                	sub    %ecx,%edx
  8018aa:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8018ae:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8018b2:	83 c0 01             	add    $0x1,%eax
  8018b5:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8018b8:	83 c7 01             	add    $0x1,%edi
  8018bb:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8018be:	75 c2                	jne    801882 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8018c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c3:	eb 05                	jmp    8018ca <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8018c5:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8018ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018cd:	5b                   	pop    %ebx
  8018ce:	5e                   	pop    %esi
  8018cf:	5f                   	pop    %edi
  8018d0:	5d                   	pop    %ebp
  8018d1:	c3                   	ret    

008018d2 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	57                   	push   %edi
  8018d6:	56                   	push   %esi
  8018d7:	53                   	push   %ebx
  8018d8:	83 ec 18             	sub    $0x18,%esp
  8018db:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8018de:	57                   	push   %edi
  8018df:	e8 5c f5 ff ff       	call   800e40 <fd2data>
  8018e4:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8018e6:	83 c4 10             	add    $0x10,%esp
  8018e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018ee:	eb 3d                	jmp    80192d <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8018f0:	85 db                	test   %ebx,%ebx
  8018f2:	74 04                	je     8018f8 <devpipe_read+0x26>
				return i;
  8018f4:	89 d8                	mov    %ebx,%eax
  8018f6:	eb 44                	jmp    80193c <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8018f8:	89 f2                	mov    %esi,%edx
  8018fa:	89 f8                	mov    %edi,%eax
  8018fc:	e8 e5 fe ff ff       	call   8017e6 <_pipeisclosed>
  801901:	85 c0                	test   %eax,%eax
  801903:	75 32                	jne    801937 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801905:	e8 8e f2 ff ff       	call   800b98 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80190a:	8b 06                	mov    (%esi),%eax
  80190c:	3b 46 04             	cmp    0x4(%esi),%eax
  80190f:	74 df                	je     8018f0 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801911:	99                   	cltd   
  801912:	c1 ea 1b             	shr    $0x1b,%edx
  801915:	01 d0                	add    %edx,%eax
  801917:	83 e0 1f             	and    $0x1f,%eax
  80191a:	29 d0                	sub    %edx,%eax
  80191c:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801921:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801924:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801927:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80192a:	83 c3 01             	add    $0x1,%ebx
  80192d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801930:	75 d8                	jne    80190a <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801932:	8b 45 10             	mov    0x10(%ebp),%eax
  801935:	eb 05                	jmp    80193c <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801937:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80193c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80193f:	5b                   	pop    %ebx
  801940:	5e                   	pop    %esi
  801941:	5f                   	pop    %edi
  801942:	5d                   	pop    %ebp
  801943:	c3                   	ret    

00801944 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	56                   	push   %esi
  801948:	53                   	push   %ebx
  801949:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80194c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80194f:	50                   	push   %eax
  801950:	e8 03 f5 ff ff       	call   800e58 <fd_alloc>
  801955:	83 c4 10             	add    $0x10,%esp
  801958:	89 c2                	mov    %eax,%edx
  80195a:	85 c0                	test   %eax,%eax
  80195c:	0f 88 2c 01 00 00    	js     801a8e <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801962:	83 ec 04             	sub    $0x4,%esp
  801965:	68 07 04 00 00       	push   $0x407
  80196a:	ff 75 f4             	pushl  -0xc(%ebp)
  80196d:	6a 00                	push   $0x0
  80196f:	e8 4b f2 ff ff       	call   800bbf <sys_page_alloc>
  801974:	83 c4 10             	add    $0x10,%esp
  801977:	89 c2                	mov    %eax,%edx
  801979:	85 c0                	test   %eax,%eax
  80197b:	0f 88 0d 01 00 00    	js     801a8e <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801981:	83 ec 0c             	sub    $0xc,%esp
  801984:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801987:	50                   	push   %eax
  801988:	e8 cb f4 ff ff       	call   800e58 <fd_alloc>
  80198d:	89 c3                	mov    %eax,%ebx
  80198f:	83 c4 10             	add    $0x10,%esp
  801992:	85 c0                	test   %eax,%eax
  801994:	0f 88 e2 00 00 00    	js     801a7c <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80199a:	83 ec 04             	sub    $0x4,%esp
  80199d:	68 07 04 00 00       	push   $0x407
  8019a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8019a5:	6a 00                	push   $0x0
  8019a7:	e8 13 f2 ff ff       	call   800bbf <sys_page_alloc>
  8019ac:	89 c3                	mov    %eax,%ebx
  8019ae:	83 c4 10             	add    $0x10,%esp
  8019b1:	85 c0                	test   %eax,%eax
  8019b3:	0f 88 c3 00 00 00    	js     801a7c <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8019b9:	83 ec 0c             	sub    $0xc,%esp
  8019bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8019bf:	e8 7c f4 ff ff       	call   800e40 <fd2data>
  8019c4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019c6:	83 c4 0c             	add    $0xc,%esp
  8019c9:	68 07 04 00 00       	push   $0x407
  8019ce:	50                   	push   %eax
  8019cf:	6a 00                	push   $0x0
  8019d1:	e8 e9 f1 ff ff       	call   800bbf <sys_page_alloc>
  8019d6:	89 c3                	mov    %eax,%ebx
  8019d8:	83 c4 10             	add    $0x10,%esp
  8019db:	85 c0                	test   %eax,%eax
  8019dd:	0f 88 89 00 00 00    	js     801a6c <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019e3:	83 ec 0c             	sub    $0xc,%esp
  8019e6:	ff 75 f0             	pushl  -0x10(%ebp)
  8019e9:	e8 52 f4 ff ff       	call   800e40 <fd2data>
  8019ee:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8019f5:	50                   	push   %eax
  8019f6:	6a 00                	push   $0x0
  8019f8:	56                   	push   %esi
  8019f9:	6a 00                	push   $0x0
  8019fb:	e8 e3 f1 ff ff       	call   800be3 <sys_page_map>
  801a00:	89 c3                	mov    %eax,%ebx
  801a02:	83 c4 20             	add    $0x20,%esp
  801a05:	85 c0                	test   %eax,%eax
  801a07:	78 55                	js     801a5e <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801a09:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a12:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a17:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801a1e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a27:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801a33:	83 ec 0c             	sub    $0xc,%esp
  801a36:	ff 75 f4             	pushl  -0xc(%ebp)
  801a39:	e8 f2 f3 ff ff       	call   800e30 <fd2num>
  801a3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a41:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801a43:	83 c4 04             	add    $0x4,%esp
  801a46:	ff 75 f0             	pushl  -0x10(%ebp)
  801a49:	e8 e2 f3 ff ff       	call   800e30 <fd2num>
  801a4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a51:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801a54:	83 c4 10             	add    $0x10,%esp
  801a57:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5c:	eb 30                	jmp    801a8e <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801a5e:	83 ec 08             	sub    $0x8,%esp
  801a61:	56                   	push   %esi
  801a62:	6a 00                	push   $0x0
  801a64:	e8 a0 f1 ff ff       	call   800c09 <sys_page_unmap>
  801a69:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801a6c:	83 ec 08             	sub    $0x8,%esp
  801a6f:	ff 75 f0             	pushl  -0x10(%ebp)
  801a72:	6a 00                	push   $0x0
  801a74:	e8 90 f1 ff ff       	call   800c09 <sys_page_unmap>
  801a79:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801a7c:	83 ec 08             	sub    $0x8,%esp
  801a7f:	ff 75 f4             	pushl  -0xc(%ebp)
  801a82:	6a 00                	push   $0x0
  801a84:	e8 80 f1 ff ff       	call   800c09 <sys_page_unmap>
  801a89:	83 c4 10             	add    $0x10,%esp
  801a8c:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  801a8e:	89 d0                	mov    %edx,%eax
  801a90:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a93:	5b                   	pop    %ebx
  801a94:	5e                   	pop    %esi
  801a95:	5d                   	pop    %ebp
  801a96:	c3                   	ret    

00801a97 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a9d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa0:	50                   	push   %eax
  801aa1:	ff 75 08             	pushl  0x8(%ebp)
  801aa4:	e8 fe f3 ff ff       	call   800ea7 <fd_lookup>
  801aa9:	83 c4 10             	add    $0x10,%esp
  801aac:	85 c0                	test   %eax,%eax
  801aae:	78 18                	js     801ac8 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801ab0:	83 ec 0c             	sub    $0xc,%esp
  801ab3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab6:	e8 85 f3 ff ff       	call   800e40 <fd2data>
	return _pipeisclosed(fd, p);
  801abb:	89 c2                	mov    %eax,%edx
  801abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac0:	e8 21 fd ff ff       	call   8017e6 <_pipeisclosed>
  801ac5:	83 c4 10             	add    $0x10,%esp
}
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801acd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad2:	5d                   	pop    %ebp
  801ad3:	c3                   	ret    

00801ad4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ada:	68 aa 24 80 00       	push   $0x8024aa
  801adf:	ff 75 0c             	pushl  0xc(%ebp)
  801ae2:	e8 8f ec ff ff       	call   800776 <strcpy>
	return 0;
}
  801ae7:	b8 00 00 00 00       	mov    $0x0,%eax
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
  801af1:	57                   	push   %edi
  801af2:	56                   	push   %esi
  801af3:	53                   	push   %ebx
  801af4:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801afa:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801aff:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801b05:	eb 2d                	jmp    801b34 <devcons_write+0x46>
		m = n - tot;
  801b07:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b0a:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801b0c:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801b0f:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801b14:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801b17:	83 ec 04             	sub    $0x4,%esp
  801b1a:	53                   	push   %ebx
  801b1b:	03 45 0c             	add    0xc(%ebp),%eax
  801b1e:	50                   	push   %eax
  801b1f:	57                   	push   %edi
  801b20:	e8 e4 ed ff ff       	call   800909 <memmove>
		sys_cputs(buf, m);
  801b25:	83 c4 08             	add    $0x8,%esp
  801b28:	53                   	push   %ebx
  801b29:	57                   	push   %edi
  801b2a:	e8 d9 ef ff ff       	call   800b08 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801b2f:	01 de                	add    %ebx,%esi
  801b31:	83 c4 10             	add    $0x10,%esp
  801b34:	89 f0                	mov    %esi,%eax
  801b36:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b39:	72 cc                	jb     801b07 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801b3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b3e:	5b                   	pop    %ebx
  801b3f:	5e                   	pop    %esi
  801b40:	5f                   	pop    %edi
  801b41:	5d                   	pop    %ebp
  801b42:	c3                   	ret    

00801b43 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	83 ec 08             	sub    $0x8,%esp
  801b49:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801b4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b52:	74 2a                	je     801b7e <devcons_read+0x3b>
  801b54:	eb 05                	jmp    801b5b <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801b56:	e8 3d f0 ff ff       	call   800b98 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801b5b:	e8 ce ef ff ff       	call   800b2e <sys_cgetc>
  801b60:	85 c0                	test   %eax,%eax
  801b62:	74 f2                	je     801b56 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801b64:	85 c0                	test   %eax,%eax
  801b66:	78 16                	js     801b7e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801b68:	83 f8 04             	cmp    $0x4,%eax
  801b6b:	74 0c                	je     801b79 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801b6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b70:	88 02                	mov    %al,(%edx)
	return 1;
  801b72:	b8 01 00 00 00       	mov    $0x1,%eax
  801b77:	eb 05                	jmp    801b7e <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801b79:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801b8c:	6a 01                	push   $0x1
  801b8e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b91:	50                   	push   %eax
  801b92:	e8 71 ef ff ff       	call   800b08 <sys_cputs>
}
  801b97:	83 c4 10             	add    $0x10,%esp
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <getchar>:

int
getchar(void)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
  801b9f:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801ba2:	6a 01                	push   $0x1
  801ba4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ba7:	50                   	push   %eax
  801ba8:	6a 00                	push   $0x0
  801baa:	e8 5d f5 ff ff       	call   80110c <read>
	if (r < 0)
  801baf:	83 c4 10             	add    $0x10,%esp
  801bb2:	85 c0                	test   %eax,%eax
  801bb4:	78 0f                	js     801bc5 <getchar+0x29>
		return r;
	if (r < 1)
  801bb6:	85 c0                	test   %eax,%eax
  801bb8:	7e 06                	jle    801bc0 <getchar+0x24>
		return -E_EOF;
	return c;
  801bba:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801bbe:	eb 05                	jmp    801bc5 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801bc0:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
  801bca:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bcd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bd0:	50                   	push   %eax
  801bd1:	ff 75 08             	pushl  0x8(%ebp)
  801bd4:	e8 ce f2 ff ff       	call   800ea7 <fd_lookup>
  801bd9:	83 c4 10             	add    $0x10,%esp
  801bdc:	85 c0                	test   %eax,%eax
  801bde:	78 11                	js     801bf1 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801be9:	39 10                	cmp    %edx,(%eax)
  801beb:	0f 94 c0             	sete   %al
  801bee:	0f b6 c0             	movzbl %al,%eax
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <opencons>:

int
opencons(void)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801bf9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bfc:	50                   	push   %eax
  801bfd:	e8 56 f2 ff ff       	call   800e58 <fd_alloc>
  801c02:	83 c4 10             	add    $0x10,%esp
		return r;
  801c05:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801c07:	85 c0                	test   %eax,%eax
  801c09:	78 3e                	js     801c49 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c0b:	83 ec 04             	sub    $0x4,%esp
  801c0e:	68 07 04 00 00       	push   $0x407
  801c13:	ff 75 f4             	pushl  -0xc(%ebp)
  801c16:	6a 00                	push   $0x0
  801c18:	e8 a2 ef ff ff       	call   800bbf <sys_page_alloc>
  801c1d:	83 c4 10             	add    $0x10,%esp
		return r;
  801c20:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c22:	85 c0                	test   %eax,%eax
  801c24:	78 23                	js     801c49 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801c26:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2f:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c34:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801c3b:	83 ec 0c             	sub    $0xc,%esp
  801c3e:	50                   	push   %eax
  801c3f:	e8 ec f1 ff ff       	call   800e30 <fd2num>
  801c44:	89 c2                	mov    %eax,%edx
  801c46:	83 c4 10             	add    $0x10,%esp
}
  801c49:	89 d0                	mov    %edx,%eax
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	56                   	push   %esi
  801c51:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801c52:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801c55:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801c5b:	e8 14 ef ff ff       	call   800b74 <sys_getenvid>
  801c60:	83 ec 0c             	sub    $0xc,%esp
  801c63:	ff 75 0c             	pushl  0xc(%ebp)
  801c66:	ff 75 08             	pushl  0x8(%ebp)
  801c69:	56                   	push   %esi
  801c6a:	50                   	push   %eax
  801c6b:	68 b8 24 80 00       	push   $0x8024b8
  801c70:	e8 8f e5 ff ff       	call   800204 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801c75:	83 c4 18             	add    $0x18,%esp
  801c78:	53                   	push   %ebx
  801c79:	ff 75 10             	pushl  0x10(%ebp)
  801c7c:	e8 32 e5 ff ff       	call   8001b3 <vcprintf>
	cprintf("\n");
  801c81:	c7 04 24 70 20 80 00 	movl   $0x802070,(%esp)
  801c88:	e8 77 e5 ff ff       	call   800204 <cprintf>
  801c8d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801c90:	cc                   	int3   
  801c91:	eb fd                	jmp    801c90 <_panic+0x43>

00801c93 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
  801c96:	56                   	push   %esi
  801c97:	53                   	push   %ebx
  801c98:	8b 75 08             	mov    0x8(%ebp),%esi
  801c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801ca1:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801ca3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801ca8:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801cab:	83 ec 0c             	sub    $0xc,%esp
  801cae:	50                   	push   %eax
  801caf:	e8 06 f0 ff ff       	call   800cba <sys_ipc_recv>
	if (from_env_store)
  801cb4:	83 c4 10             	add    $0x10,%esp
  801cb7:	85 f6                	test   %esi,%esi
  801cb9:	74 0b                	je     801cc6 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801cbb:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801cc1:	8b 52 74             	mov    0x74(%edx),%edx
  801cc4:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801cc6:	85 db                	test   %ebx,%ebx
  801cc8:	74 0b                	je     801cd5 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  801cca:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801cd0:	8b 52 78             	mov    0x78(%edx),%edx
  801cd3:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  801cd5:	85 c0                	test   %eax,%eax
  801cd7:	79 16                	jns    801cef <ipc_recv+0x5c>
		if (from_env_store)
  801cd9:	85 f6                	test   %esi,%esi
  801cdb:	74 06                	je     801ce3 <ipc_recv+0x50>
			*from_env_store = 0;
  801cdd:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  801ce3:	85 db                	test   %ebx,%ebx
  801ce5:	74 10                	je     801cf7 <ipc_recv+0x64>
			*perm_store = 0;
  801ce7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ced:	eb 08                	jmp    801cf7 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  801cef:	a1 04 40 80 00       	mov    0x804004,%eax
  801cf4:	8b 40 70             	mov    0x70(%eax),%eax
}
  801cf7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cfa:	5b                   	pop    %ebx
  801cfb:	5e                   	pop    %esi
  801cfc:	5d                   	pop    %ebp
  801cfd:	c3                   	ret    

00801cfe <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	57                   	push   %edi
  801d02:	56                   	push   %esi
  801d03:	53                   	push   %ebx
  801d04:	83 ec 0c             	sub    $0xc,%esp
  801d07:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d0a:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d0d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  801d10:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  801d12:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801d17:	0f 44 d8             	cmove  %eax,%ebx
  801d1a:	eb 1c                	jmp    801d38 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  801d1c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801d1f:	74 12                	je     801d33 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801d21:	50                   	push   %eax
  801d22:	68 dc 24 80 00       	push   $0x8024dc
  801d27:	6a 42                	push   $0x42
  801d29:	68 f2 24 80 00       	push   $0x8024f2
  801d2e:	e8 1a ff ff ff       	call   801c4d <_panic>
		sys_yield();
  801d33:	e8 60 ee ff ff       	call   800b98 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801d38:	ff 75 14             	pushl  0x14(%ebp)
  801d3b:	53                   	push   %ebx
  801d3c:	56                   	push   %esi
  801d3d:	57                   	push   %edi
  801d3e:	e8 52 ef ff ff       	call   800c95 <sys_ipc_try_send>
  801d43:	83 c4 10             	add    $0x10,%esp
  801d46:	85 c0                	test   %eax,%eax
  801d48:	75 d2                	jne    801d1c <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801d4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d4d:	5b                   	pop    %ebx
  801d4e:	5e                   	pop    %esi
  801d4f:	5f                   	pop    %edi
  801d50:	5d                   	pop    %ebp
  801d51:	c3                   	ret    

00801d52 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
  801d55:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801d58:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801d5d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801d60:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801d66:	8b 52 50             	mov    0x50(%edx),%edx
  801d69:	39 ca                	cmp    %ecx,%edx
  801d6b:	75 0d                	jne    801d7a <ipc_find_env+0x28>
			return envs[i].env_id;
  801d6d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801d70:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801d75:	8b 40 48             	mov    0x48(%eax),%eax
  801d78:	eb 0f                	jmp    801d89 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801d7a:	83 c0 01             	add    $0x1,%eax
  801d7d:	3d 00 04 00 00       	cmp    $0x400,%eax
  801d82:	75 d9                	jne    801d5d <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801d84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d89:	5d                   	pop    %ebp
  801d8a:	c3                   	ret    

00801d8b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801d91:	89 d0                	mov    %edx,%eax
  801d93:	c1 e8 16             	shr    $0x16,%eax
  801d96:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801d9d:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801da2:	f6 c1 01             	test   $0x1,%cl
  801da5:	74 1d                	je     801dc4 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801da7:	c1 ea 0c             	shr    $0xc,%edx
  801daa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801db1:	f6 c2 01             	test   $0x1,%dl
  801db4:	74 0e                	je     801dc4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801db6:	c1 ea 0c             	shr    $0xc,%edx
  801db9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801dc0:	ef 
  801dc1:	0f b7 c0             	movzwl %ax,%eax
}
  801dc4:	5d                   	pop    %ebp
  801dc5:	c3                   	ret    
  801dc6:	66 90                	xchg   %ax,%ax
  801dc8:	66 90                	xchg   %ax,%ax
  801dca:	66 90                	xchg   %ax,%ax
  801dcc:	66 90                	xchg   %ax,%ax
  801dce:	66 90                	xchg   %ax,%ax

00801dd0 <__udivdi3>:
  801dd0:	55                   	push   %ebp
  801dd1:	57                   	push   %edi
  801dd2:	56                   	push   %esi
  801dd3:	53                   	push   %ebx
  801dd4:	83 ec 1c             	sub    $0x1c,%esp
  801dd7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ddb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ddf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801de3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801de7:	85 f6                	test   %esi,%esi
  801de9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ded:	89 ca                	mov    %ecx,%edx
  801def:	89 f8                	mov    %edi,%eax
  801df1:	75 3d                	jne    801e30 <__udivdi3+0x60>
  801df3:	39 cf                	cmp    %ecx,%edi
  801df5:	0f 87 c5 00 00 00    	ja     801ec0 <__udivdi3+0xf0>
  801dfb:	85 ff                	test   %edi,%edi
  801dfd:	89 fd                	mov    %edi,%ebp
  801dff:	75 0b                	jne    801e0c <__udivdi3+0x3c>
  801e01:	b8 01 00 00 00       	mov    $0x1,%eax
  801e06:	31 d2                	xor    %edx,%edx
  801e08:	f7 f7                	div    %edi
  801e0a:	89 c5                	mov    %eax,%ebp
  801e0c:	89 c8                	mov    %ecx,%eax
  801e0e:	31 d2                	xor    %edx,%edx
  801e10:	f7 f5                	div    %ebp
  801e12:	89 c1                	mov    %eax,%ecx
  801e14:	89 d8                	mov    %ebx,%eax
  801e16:	89 cf                	mov    %ecx,%edi
  801e18:	f7 f5                	div    %ebp
  801e1a:	89 c3                	mov    %eax,%ebx
  801e1c:	89 d8                	mov    %ebx,%eax
  801e1e:	89 fa                	mov    %edi,%edx
  801e20:	83 c4 1c             	add    $0x1c,%esp
  801e23:	5b                   	pop    %ebx
  801e24:	5e                   	pop    %esi
  801e25:	5f                   	pop    %edi
  801e26:	5d                   	pop    %ebp
  801e27:	c3                   	ret    
  801e28:	90                   	nop
  801e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e30:	39 ce                	cmp    %ecx,%esi
  801e32:	77 74                	ja     801ea8 <__udivdi3+0xd8>
  801e34:	0f bd fe             	bsr    %esi,%edi
  801e37:	83 f7 1f             	xor    $0x1f,%edi
  801e3a:	0f 84 98 00 00 00    	je     801ed8 <__udivdi3+0x108>
  801e40:	bb 20 00 00 00       	mov    $0x20,%ebx
  801e45:	89 f9                	mov    %edi,%ecx
  801e47:	89 c5                	mov    %eax,%ebp
  801e49:	29 fb                	sub    %edi,%ebx
  801e4b:	d3 e6                	shl    %cl,%esi
  801e4d:	89 d9                	mov    %ebx,%ecx
  801e4f:	d3 ed                	shr    %cl,%ebp
  801e51:	89 f9                	mov    %edi,%ecx
  801e53:	d3 e0                	shl    %cl,%eax
  801e55:	09 ee                	or     %ebp,%esi
  801e57:	89 d9                	mov    %ebx,%ecx
  801e59:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e5d:	89 d5                	mov    %edx,%ebp
  801e5f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e63:	d3 ed                	shr    %cl,%ebp
  801e65:	89 f9                	mov    %edi,%ecx
  801e67:	d3 e2                	shl    %cl,%edx
  801e69:	89 d9                	mov    %ebx,%ecx
  801e6b:	d3 e8                	shr    %cl,%eax
  801e6d:	09 c2                	or     %eax,%edx
  801e6f:	89 d0                	mov    %edx,%eax
  801e71:	89 ea                	mov    %ebp,%edx
  801e73:	f7 f6                	div    %esi
  801e75:	89 d5                	mov    %edx,%ebp
  801e77:	89 c3                	mov    %eax,%ebx
  801e79:	f7 64 24 0c          	mull   0xc(%esp)
  801e7d:	39 d5                	cmp    %edx,%ebp
  801e7f:	72 10                	jb     801e91 <__udivdi3+0xc1>
  801e81:	8b 74 24 08          	mov    0x8(%esp),%esi
  801e85:	89 f9                	mov    %edi,%ecx
  801e87:	d3 e6                	shl    %cl,%esi
  801e89:	39 c6                	cmp    %eax,%esi
  801e8b:	73 07                	jae    801e94 <__udivdi3+0xc4>
  801e8d:	39 d5                	cmp    %edx,%ebp
  801e8f:	75 03                	jne    801e94 <__udivdi3+0xc4>
  801e91:	83 eb 01             	sub    $0x1,%ebx
  801e94:	31 ff                	xor    %edi,%edi
  801e96:	89 d8                	mov    %ebx,%eax
  801e98:	89 fa                	mov    %edi,%edx
  801e9a:	83 c4 1c             	add    $0x1c,%esp
  801e9d:	5b                   	pop    %ebx
  801e9e:	5e                   	pop    %esi
  801e9f:	5f                   	pop    %edi
  801ea0:	5d                   	pop    %ebp
  801ea1:	c3                   	ret    
  801ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801ea8:	31 ff                	xor    %edi,%edi
  801eaa:	31 db                	xor    %ebx,%ebx
  801eac:	89 d8                	mov    %ebx,%eax
  801eae:	89 fa                	mov    %edi,%edx
  801eb0:	83 c4 1c             	add    $0x1c,%esp
  801eb3:	5b                   	pop    %ebx
  801eb4:	5e                   	pop    %esi
  801eb5:	5f                   	pop    %edi
  801eb6:	5d                   	pop    %ebp
  801eb7:	c3                   	ret    
  801eb8:	90                   	nop
  801eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ec0:	89 d8                	mov    %ebx,%eax
  801ec2:	f7 f7                	div    %edi
  801ec4:	31 ff                	xor    %edi,%edi
  801ec6:	89 c3                	mov    %eax,%ebx
  801ec8:	89 d8                	mov    %ebx,%eax
  801eca:	89 fa                	mov    %edi,%edx
  801ecc:	83 c4 1c             	add    $0x1c,%esp
  801ecf:	5b                   	pop    %ebx
  801ed0:	5e                   	pop    %esi
  801ed1:	5f                   	pop    %edi
  801ed2:	5d                   	pop    %ebp
  801ed3:	c3                   	ret    
  801ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ed8:	39 ce                	cmp    %ecx,%esi
  801eda:	72 0c                	jb     801ee8 <__udivdi3+0x118>
  801edc:	31 db                	xor    %ebx,%ebx
  801ede:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ee2:	0f 87 34 ff ff ff    	ja     801e1c <__udivdi3+0x4c>
  801ee8:	bb 01 00 00 00       	mov    $0x1,%ebx
  801eed:	e9 2a ff ff ff       	jmp    801e1c <__udivdi3+0x4c>
  801ef2:	66 90                	xchg   %ax,%ax
  801ef4:	66 90                	xchg   %ax,%ax
  801ef6:	66 90                	xchg   %ax,%ax
  801ef8:	66 90                	xchg   %ax,%ax
  801efa:	66 90                	xchg   %ax,%ax
  801efc:	66 90                	xchg   %ax,%ax
  801efe:	66 90                	xchg   %ax,%ax

00801f00 <__umoddi3>:
  801f00:	55                   	push   %ebp
  801f01:	57                   	push   %edi
  801f02:	56                   	push   %esi
  801f03:	53                   	push   %ebx
  801f04:	83 ec 1c             	sub    $0x1c,%esp
  801f07:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801f0b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801f0f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f17:	85 d2                	test   %edx,%edx
  801f19:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f21:	89 f3                	mov    %esi,%ebx
  801f23:	89 3c 24             	mov    %edi,(%esp)
  801f26:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f2a:	75 1c                	jne    801f48 <__umoddi3+0x48>
  801f2c:	39 f7                	cmp    %esi,%edi
  801f2e:	76 50                	jbe    801f80 <__umoddi3+0x80>
  801f30:	89 c8                	mov    %ecx,%eax
  801f32:	89 f2                	mov    %esi,%edx
  801f34:	f7 f7                	div    %edi
  801f36:	89 d0                	mov    %edx,%eax
  801f38:	31 d2                	xor    %edx,%edx
  801f3a:	83 c4 1c             	add    $0x1c,%esp
  801f3d:	5b                   	pop    %ebx
  801f3e:	5e                   	pop    %esi
  801f3f:	5f                   	pop    %edi
  801f40:	5d                   	pop    %ebp
  801f41:	c3                   	ret    
  801f42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f48:	39 f2                	cmp    %esi,%edx
  801f4a:	89 d0                	mov    %edx,%eax
  801f4c:	77 52                	ja     801fa0 <__umoddi3+0xa0>
  801f4e:	0f bd ea             	bsr    %edx,%ebp
  801f51:	83 f5 1f             	xor    $0x1f,%ebp
  801f54:	75 5a                	jne    801fb0 <__umoddi3+0xb0>
  801f56:	3b 54 24 04          	cmp    0x4(%esp),%edx
  801f5a:	0f 82 e0 00 00 00    	jb     802040 <__umoddi3+0x140>
  801f60:	39 0c 24             	cmp    %ecx,(%esp)
  801f63:	0f 86 d7 00 00 00    	jbe    802040 <__umoddi3+0x140>
  801f69:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f6d:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f71:	83 c4 1c             	add    $0x1c,%esp
  801f74:	5b                   	pop    %ebx
  801f75:	5e                   	pop    %esi
  801f76:	5f                   	pop    %edi
  801f77:	5d                   	pop    %ebp
  801f78:	c3                   	ret    
  801f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f80:	85 ff                	test   %edi,%edi
  801f82:	89 fd                	mov    %edi,%ebp
  801f84:	75 0b                	jne    801f91 <__umoddi3+0x91>
  801f86:	b8 01 00 00 00       	mov    $0x1,%eax
  801f8b:	31 d2                	xor    %edx,%edx
  801f8d:	f7 f7                	div    %edi
  801f8f:	89 c5                	mov    %eax,%ebp
  801f91:	89 f0                	mov    %esi,%eax
  801f93:	31 d2                	xor    %edx,%edx
  801f95:	f7 f5                	div    %ebp
  801f97:	89 c8                	mov    %ecx,%eax
  801f99:	f7 f5                	div    %ebp
  801f9b:	89 d0                	mov    %edx,%eax
  801f9d:	eb 99                	jmp    801f38 <__umoddi3+0x38>
  801f9f:	90                   	nop
  801fa0:	89 c8                	mov    %ecx,%eax
  801fa2:	89 f2                	mov    %esi,%edx
  801fa4:	83 c4 1c             	add    $0x1c,%esp
  801fa7:	5b                   	pop    %ebx
  801fa8:	5e                   	pop    %esi
  801fa9:	5f                   	pop    %edi
  801faa:	5d                   	pop    %ebp
  801fab:	c3                   	ret    
  801fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801fb0:	8b 34 24             	mov    (%esp),%esi
  801fb3:	bf 20 00 00 00       	mov    $0x20,%edi
  801fb8:	89 e9                	mov    %ebp,%ecx
  801fba:	29 ef                	sub    %ebp,%edi
  801fbc:	d3 e0                	shl    %cl,%eax
  801fbe:	89 f9                	mov    %edi,%ecx
  801fc0:	89 f2                	mov    %esi,%edx
  801fc2:	d3 ea                	shr    %cl,%edx
  801fc4:	89 e9                	mov    %ebp,%ecx
  801fc6:	09 c2                	or     %eax,%edx
  801fc8:	89 d8                	mov    %ebx,%eax
  801fca:	89 14 24             	mov    %edx,(%esp)
  801fcd:	89 f2                	mov    %esi,%edx
  801fcf:	d3 e2                	shl    %cl,%edx
  801fd1:	89 f9                	mov    %edi,%ecx
  801fd3:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fd7:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801fdb:	d3 e8                	shr    %cl,%eax
  801fdd:	89 e9                	mov    %ebp,%ecx
  801fdf:	89 c6                	mov    %eax,%esi
  801fe1:	d3 e3                	shl    %cl,%ebx
  801fe3:	89 f9                	mov    %edi,%ecx
  801fe5:	89 d0                	mov    %edx,%eax
  801fe7:	d3 e8                	shr    %cl,%eax
  801fe9:	89 e9                	mov    %ebp,%ecx
  801feb:	09 d8                	or     %ebx,%eax
  801fed:	89 d3                	mov    %edx,%ebx
  801fef:	89 f2                	mov    %esi,%edx
  801ff1:	f7 34 24             	divl   (%esp)
  801ff4:	89 d6                	mov    %edx,%esi
  801ff6:	d3 e3                	shl    %cl,%ebx
  801ff8:	f7 64 24 04          	mull   0x4(%esp)
  801ffc:	39 d6                	cmp    %edx,%esi
  801ffe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802002:	89 d1                	mov    %edx,%ecx
  802004:	89 c3                	mov    %eax,%ebx
  802006:	72 08                	jb     802010 <__umoddi3+0x110>
  802008:	75 11                	jne    80201b <__umoddi3+0x11b>
  80200a:	39 44 24 08          	cmp    %eax,0x8(%esp)
  80200e:	73 0b                	jae    80201b <__umoddi3+0x11b>
  802010:	2b 44 24 04          	sub    0x4(%esp),%eax
  802014:	1b 14 24             	sbb    (%esp),%edx
  802017:	89 d1                	mov    %edx,%ecx
  802019:	89 c3                	mov    %eax,%ebx
  80201b:	8b 54 24 08          	mov    0x8(%esp),%edx
  80201f:	29 da                	sub    %ebx,%edx
  802021:	19 ce                	sbb    %ecx,%esi
  802023:	89 f9                	mov    %edi,%ecx
  802025:	89 f0                	mov    %esi,%eax
  802027:	d3 e0                	shl    %cl,%eax
  802029:	89 e9                	mov    %ebp,%ecx
  80202b:	d3 ea                	shr    %cl,%edx
  80202d:	89 e9                	mov    %ebp,%ecx
  80202f:	d3 ee                	shr    %cl,%esi
  802031:	09 d0                	or     %edx,%eax
  802033:	89 f2                	mov    %esi,%edx
  802035:	83 c4 1c             	add    $0x1c,%esp
  802038:	5b                   	pop    %ebx
  802039:	5e                   	pop    %esi
  80203a:	5f                   	pop    %edi
  80203b:	5d                   	pop    %ebp
  80203c:	c3                   	ret    
  80203d:	8d 76 00             	lea    0x0(%esi),%esi
  802040:	29 f9                	sub    %edi,%ecx
  802042:	19 d6                	sbb    %edx,%esi
  802044:	89 74 24 04          	mov    %esi,0x4(%esp)
  802048:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80204c:	e9 18 ff ff ff       	jmp    801f69 <__umoddi3+0x69>
