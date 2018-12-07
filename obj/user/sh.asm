
obj/user/sh.debug:     formato del fichero elf32-i386


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
  80002c:	e8 84 09 00 00       	call   8009b5 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 0c             	sub    $0xc,%esp
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int t;

	if (s == 0) {
  800042:	85 db                	test   %ebx,%ebx
  800044:	75 2c                	jne    800072 <_gettoken+0x3f>
		if (debug > 1)
			cprintf("GETTOKEN NULL\n");
		return 0;
  800046:	b8 00 00 00 00       	mov    $0x0,%eax
_gettoken(char *s, char **p1, char **p2)
{
	int t;

	if (s == 0) {
		if (debug > 1)
  80004b:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800052:	0f 8e 3e 01 00 00    	jle    800196 <_gettoken+0x163>
			cprintf("GETTOKEN NULL\n");
  800058:	83 ec 0c             	sub    $0xc,%esp
  80005b:	68 00 34 80 00       	push   $0x803400
  800060:	e8 8d 0a 00 00       	call   800af2 <cprintf>
  800065:	83 c4 10             	add    $0x10,%esp
		return 0;
  800068:	b8 00 00 00 00       	mov    $0x0,%eax
  80006d:	e9 24 01 00 00       	jmp    800196 <_gettoken+0x163>
	}

	if (debug > 1)
  800072:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800079:	7e 11                	jle    80008c <_gettoken+0x59>
		cprintf("GETTOKEN: %s\n", s);
  80007b:	83 ec 08             	sub    $0x8,%esp
  80007e:	53                   	push   %ebx
  80007f:	68 0f 34 80 00       	push   $0x80340f
  800084:	e8 69 0a 00 00       	call   800af2 <cprintf>
  800089:	83 c4 10             	add    $0x10,%esp

	*p1 = 0;
  80008c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	*p2 = 0;
  800092:	8b 45 10             	mov    0x10(%ebp),%eax
  800095:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	while (strchr(WHITESPACE, *s))
  80009b:	eb 07                	jmp    8000a4 <_gettoken+0x71>
		*s++ = 0;
  80009d:	83 c3 01             	add    $0x1,%ebx
  8000a0:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
  8000a4:	83 ec 08             	sub    $0x8,%esp
  8000a7:	0f be 03             	movsbl (%ebx),%eax
  8000aa:	50                   	push   %eax
  8000ab:	68 1d 34 80 00       	push   $0x80341d
  8000b0:	e8 aa 11 00 00       	call   80125f <strchr>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	85 c0                	test   %eax,%eax
  8000ba:	75 e1                	jne    80009d <_gettoken+0x6a>
		*s++ = 0;
	if (*s == 0) {
  8000bc:	0f b6 03             	movzbl (%ebx),%eax
  8000bf:	84 c0                	test   %al,%al
  8000c1:	75 2c                	jne    8000ef <_gettoken+0xbc>
		if (debug > 1)
			cprintf("EOL\n");
		return 0;
  8000c3:	b8 00 00 00 00       	mov    $0x0,%eax
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
		*s++ = 0;
	if (*s == 0) {
		if (debug > 1)
  8000c8:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  8000cf:	0f 8e c1 00 00 00    	jle    800196 <_gettoken+0x163>
			cprintf("EOL\n");
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 22 34 80 00       	push   $0x803422
  8000dd:	e8 10 0a 00 00       	call   800af2 <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
		return 0;
  8000e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ea:	e9 a7 00 00 00       	jmp    800196 <_gettoken+0x163>
	}
	if (strchr(SYMBOLS, *s)) {
  8000ef:	83 ec 08             	sub    $0x8,%esp
  8000f2:	0f be c0             	movsbl %al,%eax
  8000f5:	50                   	push   %eax
  8000f6:	68 33 34 80 00       	push   $0x803433
  8000fb:	e8 5f 11 00 00       	call   80125f <strchr>
  800100:	83 c4 10             	add    $0x10,%esp
  800103:	85 c0                	test   %eax,%eax
  800105:	74 30                	je     800137 <_gettoken+0x104>
		t = *s;
  800107:	0f be 3b             	movsbl (%ebx),%edi
		*p1 = s;
  80010a:	89 1e                	mov    %ebx,(%esi)
		*s++ = 0;
  80010c:	c6 03 00             	movb   $0x0,(%ebx)
		*p2 = s;
  80010f:	83 c3 01             	add    $0x1,%ebx
  800112:	8b 45 10             	mov    0x10(%ebp),%eax
  800115:	89 18                	mov    %ebx,(%eax)
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
  800117:	89 f8                	mov    %edi,%eax
	if (strchr(SYMBOLS, *s)) {
		t = *s;
		*p1 = s;
		*s++ = 0;
		*p2 = s;
		if (debug > 1)
  800119:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800120:	7e 74                	jle    800196 <_gettoken+0x163>
			cprintf("TOK %c\n", t);
  800122:	83 ec 08             	sub    $0x8,%esp
  800125:	57                   	push   %edi
  800126:	68 27 34 80 00       	push   $0x803427
  80012b:	e8 c2 09 00 00       	call   800af2 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp
		return t;
  800133:	89 f8                	mov    %edi,%eax
  800135:	eb 5f                	jmp    800196 <_gettoken+0x163>
	}
	*p1 = s;
  800137:	89 1e                	mov    %ebx,(%esi)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  800139:	eb 03                	jmp    80013e <_gettoken+0x10b>
		s++;
  80013b:	83 c3 01             	add    $0x1,%ebx
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80013e:	0f b6 03             	movzbl (%ebx),%eax
  800141:	84 c0                	test   %al,%al
  800143:	74 18                	je     80015d <_gettoken+0x12a>
  800145:	83 ec 08             	sub    $0x8,%esp
  800148:	0f be c0             	movsbl %al,%eax
  80014b:	50                   	push   %eax
  80014c:	68 2f 34 80 00       	push   $0x80342f
  800151:	e8 09 11 00 00       	call   80125f <strchr>
  800156:	83 c4 10             	add    $0x10,%esp
  800159:	85 c0                	test   %eax,%eax
  80015b:	74 de                	je     80013b <_gettoken+0x108>
		s++;
	*p2 = s;
  80015d:	8b 45 10             	mov    0x10(%ebp),%eax
  800160:	89 18                	mov    %ebx,(%eax)
		t = **p2;
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
  800162:	b8 77 00 00 00       	mov    $0x77,%eax
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
		s++;
	*p2 = s;
	if (debug > 1) {
  800167:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  80016e:	7e 26                	jle    800196 <_gettoken+0x163>
		t = **p2;
  800170:	0f b6 3b             	movzbl (%ebx),%edi
		**p2 = 0;
  800173:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  800176:	83 ec 08             	sub    $0x8,%esp
  800179:	ff 36                	pushl  (%esi)
  80017b:	68 3b 34 80 00       	push   $0x80343b
  800180:	e8 6d 09 00 00       	call   800af2 <cprintf>
		**p2 = t;
  800185:	8b 45 10             	mov    0x10(%ebp),%eax
  800188:	8b 00                	mov    (%eax),%eax
  80018a:	89 fa                	mov    %edi,%edx
  80018c:	88 10                	mov    %dl,(%eax)
  80018e:	83 c4 10             	add    $0x10,%esp
	}
	return 'w';
  800191:	b8 77 00 00 00       	mov    $0x77,%eax
}
  800196:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800199:	5b                   	pop    %ebx
  80019a:	5e                   	pop    %esi
  80019b:	5f                   	pop    %edi
  80019c:	5d                   	pop    %ebp
  80019d:	c3                   	ret    

0080019e <gettoken>:

int
gettoken(char *s, char **p1)
{
  80019e:	55                   	push   %ebp
  80019f:	89 e5                	mov    %esp,%ebp
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char *np1, *np2;

	if (s) {
  8001a7:	85 c0                	test   %eax,%eax
  8001a9:	74 22                	je     8001cd <gettoken+0x2f>
		nc = _gettoken(s, &np1, &np2);
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	68 0c 50 80 00       	push   $0x80500c
  8001b3:	68 10 50 80 00       	push   $0x805010
  8001b8:	50                   	push   %eax
  8001b9:	e8 75 fe ff ff       	call   800033 <_gettoken>
  8001be:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8001c3:	83 c4 10             	add    $0x10,%esp
  8001c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cb:	eb 3a                	jmp    800207 <gettoken+0x69>
	}
	c = nc;
  8001cd:	a1 08 50 80 00       	mov    0x805008,%eax
  8001d2:	a3 04 50 80 00       	mov    %eax,0x805004
	*p1 = np1;
  8001d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001da:	8b 15 10 50 80 00    	mov    0x805010,%edx
  8001e0:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	68 0c 50 80 00       	push   $0x80500c
  8001ea:	68 10 50 80 00       	push   $0x805010
  8001ef:	ff 35 0c 50 80 00    	pushl  0x80500c
  8001f5:	e8 39 fe ff ff       	call   800033 <_gettoken>
  8001fa:	a3 08 50 80 00       	mov    %eax,0x805008
	return c;
  8001ff:	a1 04 50 80 00       	mov    0x805004,%eax
  800204:	83 c4 10             	add    $0x10,%esp
}
  800207:	c9                   	leave  
  800208:	c3                   	ret    

00800209 <runcmd>:
// runcmd() is called in a forked child,
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char *s)
{
  800209:	55                   	push   %ebp
  80020a:	89 e5                	mov    %esp,%ebp
  80020c:	57                   	push   %edi
  80020d:	56                   	push   %esi
  80020e:	53                   	push   %ebx
  80020f:	81 ec 64 04 00 00    	sub    $0x464,%esp
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
	gettoken(s, 0);
  800215:	6a 00                	push   $0x0
  800217:	ff 75 08             	pushl  0x8(%ebp)
  80021a:	e8 7f ff ff ff       	call   80019e <gettoken>
  80021f:	83 c4 10             	add    $0x10,%esp

again:
	argc = 0;
	while (1) {
		switch ((c = gettoken(0, &t))) {
  800222:	8d 5d a4             	lea    -0x5c(%ebp),%ebx

	pipe_child = 0;
	gettoken(s, 0);

again:
	argc = 0;
  800225:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		switch ((c = gettoken(0, &t))) {
  80022a:	83 ec 08             	sub    $0x8,%esp
  80022d:	53                   	push   %ebx
  80022e:	6a 00                	push   $0x0
  800230:	e8 69 ff ff ff       	call   80019e <gettoken>
  800235:	83 c4 10             	add    $0x10,%esp
  800238:	83 f8 3e             	cmp    $0x3e,%eax
  80023b:	0f 84 cc 00 00 00    	je     80030d <runcmd+0x104>
  800241:	83 f8 3e             	cmp    $0x3e,%eax
  800244:	7f 12                	jg     800258 <runcmd+0x4f>
  800246:	85 c0                	test   %eax,%eax
  800248:	0f 84 3b 02 00 00    	je     800489 <runcmd+0x280>
  80024e:	83 f8 3c             	cmp    $0x3c,%eax
  800251:	74 3e                	je     800291 <runcmd+0x88>
  800253:	e9 1f 02 00 00       	jmp    800477 <runcmd+0x26e>
  800258:	83 f8 77             	cmp    $0x77,%eax
  80025b:	74 0e                	je     80026b <runcmd+0x62>
  80025d:	83 f8 7c             	cmp    $0x7c,%eax
  800260:	0f 84 25 01 00 00    	je     80038b <runcmd+0x182>
  800266:	e9 0c 02 00 00       	jmp    800477 <runcmd+0x26e>
		case 'w':  // Add an argument
			if (argc == MAXARGS) {
  80026b:	83 fe 10             	cmp    $0x10,%esi
  80026e:	75 15                	jne    800285 <runcmd+0x7c>
				cprintf("too many arguments\n");
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	68 45 34 80 00       	push   $0x803445
  800278:	e8 75 08 00 00       	call   800af2 <cprintf>
				exit();
  80027d:	e8 7d 07 00 00       	call   8009ff <exit>
  800282:	83 c4 10             	add    $0x10,%esp
			}
			argv[argc++] = t;
  800285:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800288:	89 44 b5 a8          	mov    %eax,-0x58(%ebp,%esi,4)
  80028c:	8d 76 01             	lea    0x1(%esi),%esi
			break;
  80028f:	eb 99                	jmp    80022a <runcmd+0x21>

		case '<':  // Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  800291:	83 ec 08             	sub    $0x8,%esp
  800294:	53                   	push   %ebx
  800295:	6a 00                	push   $0x0
  800297:	e8 02 ff ff ff       	call   80019e <gettoken>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	83 f8 77             	cmp    $0x77,%eax
  8002a2:	74 15                	je     8002b9 <runcmd+0xb0>
				cprintf("syntax error: < not followed by "
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	68 90 35 80 00       	push   $0x803590
  8002ac:	e8 41 08 00 00       	call   800af2 <cprintf>
				        "word\n");
				exit();
  8002b1:	e8 49 07 00 00       	call   8009ff <exit>
  8002b6:	83 c4 10             	add    $0x10,%esp
			// then check whether 'fd' is 0.
			// If not, dup 'fd' onto file descriptor 0,
			// then close the original 'fd'.

			// LAB 5: Your code here.
			if ((fd = open(t, O_RDONLY)) < 0) {
  8002b9:	83 ec 08             	sub    $0x8,%esp
  8002bc:	6a 00                	push   $0x0
  8002be:	ff 75 a4             	pushl  -0x5c(%ebp)
  8002c1:	e8 8c 21 00 00       	call   802452 <open>
  8002c6:	89 c7                	mov    %eax,%edi
  8002c8:	83 c4 10             	add    $0x10,%esp
  8002cb:	85 c0                	test   %eax,%eax
  8002cd:	79 1b                	jns    8002ea <runcmd+0xe1>
				cprintf("open %s for read: %e", t, fd);
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	50                   	push   %eax
  8002d3:	ff 75 a4             	pushl  -0x5c(%ebp)
  8002d6:	68 59 34 80 00       	push   $0x803459
  8002db:	e8 12 08 00 00       	call   800af2 <cprintf>
				exit();
  8002e0:	e8 1a 07 00 00       	call   8009ff <exit>
  8002e5:	83 c4 10             	add    $0x10,%esp
  8002e8:	eb 04                	jmp    8002ee <runcmd+0xe5>
			}
			if (fd) 
  8002ea:	85 c0                	test   %eax,%eax
  8002ec:	74 0e                	je     8002fc <runcmd+0xf3>
				dup(fd, 0);
  8002ee:	83 ec 08             	sub    $0x8,%esp
  8002f1:	6a 00                	push   $0x0
  8002f3:	57                   	push   %edi
  8002f4:	e8 bf 1b 00 00       	call   801eb8 <dup>
  8002f9:	83 c4 10             	add    $0x10,%esp
			close(fd);
  8002fc:	83 ec 0c             	sub    $0xc,%esp
  8002ff:	57                   	push   %edi
  800300:	e8 63 1b 00 00       	call   801e68 <close>
			break;
  800305:	83 c4 10             	add    $0x10,%esp
  800308:	e9 1d ff ff ff       	jmp    80022a <runcmd+0x21>

		case '>':  // Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  80030d:	83 ec 08             	sub    $0x8,%esp
  800310:	53                   	push   %ebx
  800311:	6a 00                	push   $0x0
  800313:	e8 86 fe ff ff       	call   80019e <gettoken>
  800318:	83 c4 10             	add    $0x10,%esp
  80031b:	83 f8 77             	cmp    $0x77,%eax
  80031e:	74 15                	je     800335 <runcmd+0x12c>
				cprintf("syntax error: > not followed by "
  800320:	83 ec 0c             	sub    $0xc,%esp
  800323:	68 b8 35 80 00       	push   $0x8035b8
  800328:	e8 c5 07 00 00       	call   800af2 <cprintf>
				        "word\n");
				exit();
  80032d:	e8 cd 06 00 00       	call   8009ff <exit>
  800332:	83 c4 10             	add    $0x10,%esp
			}
			if ((fd = open(t, O_WRONLY | O_CREAT | O_TRUNC)) < 0) {
  800335:	83 ec 08             	sub    $0x8,%esp
  800338:	68 01 03 00 00       	push   $0x301
  80033d:	ff 75 a4             	pushl  -0x5c(%ebp)
  800340:	e8 0d 21 00 00       	call   802452 <open>
  800345:	89 c7                	mov    %eax,%edi
  800347:	83 c4 10             	add    $0x10,%esp
  80034a:	85 c0                	test   %eax,%eax
  80034c:	79 19                	jns    800367 <runcmd+0x15e>
				cprintf("open %s for write: %e", t, fd);
  80034e:	83 ec 04             	sub    $0x4,%esp
  800351:	50                   	push   %eax
  800352:	ff 75 a4             	pushl  -0x5c(%ebp)
  800355:	68 6e 34 80 00       	push   $0x80346e
  80035a:	e8 93 07 00 00       	call   800af2 <cprintf>
				exit();
  80035f:	e8 9b 06 00 00       	call   8009ff <exit>
  800364:	83 c4 10             	add    $0x10,%esp
			}
			if (fd != 1) {
  800367:	83 ff 01             	cmp    $0x1,%edi
  80036a:	0f 84 ba fe ff ff    	je     80022a <runcmd+0x21>
				dup(fd, 1);
  800370:	83 ec 08             	sub    $0x8,%esp
  800373:	6a 01                	push   $0x1
  800375:	57                   	push   %edi
  800376:	e8 3d 1b 00 00       	call   801eb8 <dup>
				close(fd);
  80037b:	89 3c 24             	mov    %edi,(%esp)
  80037e:	e8 e5 1a 00 00       	call   801e68 <close>
  800383:	83 c4 10             	add    $0x10,%esp
  800386:	e9 9f fe ff ff       	jmp    80022a <runcmd+0x21>
			}
			break;

		case '|':  // Pipe
			if ((r = pipe(p)) < 0) {
  80038b:	83 ec 0c             	sub    $0xc,%esp
  80038e:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  800394:	50                   	push   %eax
  800395:	e8 28 2a 00 00       	call   802dc2 <pipe>
  80039a:	83 c4 10             	add    $0x10,%esp
  80039d:	85 c0                	test   %eax,%eax
  80039f:	79 16                	jns    8003b7 <runcmd+0x1ae>
				cprintf("pipe: %e", r);
  8003a1:	83 ec 08             	sub    $0x8,%esp
  8003a4:	50                   	push   %eax
  8003a5:	68 84 34 80 00       	push   $0x803484
  8003aa:	e8 43 07 00 00       	call   800af2 <cprintf>
				exit();
  8003af:	e8 4b 06 00 00       	call   8009ff <exit>
  8003b4:	83 c4 10             	add    $0x10,%esp
			}
			if (debug)
  8003b7:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8003be:	74 1c                	je     8003dc <runcmd+0x1d3>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  8003c0:	83 ec 04             	sub    $0x4,%esp
  8003c3:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  8003c9:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  8003cf:	68 8d 34 80 00       	push   $0x80348d
  8003d4:	e8 19 07 00 00       	call   800af2 <cprintf>
  8003d9:	83 c4 10             	add    $0x10,%esp
			if ((r = fork()) < 0) {
  8003dc:	e8 66 16 00 00       	call   801a47 <fork>
  8003e1:	89 c7                	mov    %eax,%edi
  8003e3:	85 c0                	test   %eax,%eax
  8003e5:	79 16                	jns    8003fd <runcmd+0x1f4>
				cprintf("fork: %e", r);
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	50                   	push   %eax
  8003eb:	68 60 3a 80 00       	push   $0x803a60
  8003f0:	e8 fd 06 00 00       	call   800af2 <cprintf>
				exit();
  8003f5:	e8 05 06 00 00       	call   8009ff <exit>
  8003fa:	83 c4 10             	add    $0x10,%esp
			}
			if (r == 0) {
  8003fd:	85 ff                	test   %edi,%edi
  8003ff:	75 3c                	jne    80043d <runcmd+0x234>
				if (p[0] != 0) {
  800401:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  800407:	85 c0                	test   %eax,%eax
  800409:	74 1c                	je     800427 <runcmd+0x21e>
					dup(p[0], 0);
  80040b:	83 ec 08             	sub    $0x8,%esp
  80040e:	6a 00                	push   $0x0
  800410:	50                   	push   %eax
  800411:	e8 a2 1a 00 00       	call   801eb8 <dup>
					close(p[0]);
  800416:	83 c4 04             	add    $0x4,%esp
  800419:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80041f:	e8 44 1a 00 00       	call   801e68 <close>
  800424:	83 c4 10             	add    $0x10,%esp
				}
				close(p[1]);
  800427:	83 ec 0c             	sub    $0xc,%esp
  80042a:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  800430:	e8 33 1a 00 00       	call   801e68 <close>
				goto again;
  800435:	83 c4 10             	add    $0x10,%esp
  800438:	e9 e8 fd ff ff       	jmp    800225 <runcmd+0x1c>
			} else {
				pipe_child = r;
				if (p[1] != 1) {
  80043d:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800443:	83 f8 01             	cmp    $0x1,%eax
  800446:	74 1c                	je     800464 <runcmd+0x25b>
					dup(p[1], 1);
  800448:	83 ec 08             	sub    $0x8,%esp
  80044b:	6a 01                	push   $0x1
  80044d:	50                   	push   %eax
  80044e:	e8 65 1a 00 00       	call   801eb8 <dup>
					close(p[1]);
  800453:	83 c4 04             	add    $0x4,%esp
  800456:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  80045c:	e8 07 1a 00 00       	call   801e68 <close>
  800461:	83 c4 10             	add    $0x10,%esp
				}
				close(p[0]);
  800464:	83 ec 0c             	sub    $0xc,%esp
  800467:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80046d:	e8 f6 19 00 00       	call   801e68 <close>
				goto runit;
  800472:	83 c4 10             	add    $0x10,%esp
  800475:	eb 17                	jmp    80048e <runcmd+0x285>
		case 0:  // String is complete
			// Run the current command!
			goto runit;

		default:
			panic("bad return %d from gettoken", c);
  800477:	50                   	push   %eax
  800478:	68 9a 34 80 00       	push   $0x80349a
  80047d:	6a 77                	push   $0x77
  80047f:	68 b6 34 80 00       	push   $0x8034b6
  800484:	e8 90 05 00 00       	call   800a19 <_panic>
runcmd(char *s)
{
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
  800489:	bf 00 00 00 00       	mov    $0x0,%edi
		}
	}

runit:
	// Return immediately if command line was empty.
	if (argc == 0) {
  80048e:	85 f6                	test   %esi,%esi
  800490:	75 22                	jne    8004b4 <runcmd+0x2ab>
		if (debug)
  800492:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800499:	0f 84 96 01 00 00    	je     800635 <runcmd+0x42c>
			cprintf("EMPTY COMMAND\n");
  80049f:	83 ec 0c             	sub    $0xc,%esp
  8004a2:	68 c0 34 80 00       	push   $0x8034c0
  8004a7:	e8 46 06 00 00       	call   800af2 <cprintf>
  8004ac:	83 c4 10             	add    $0x10,%esp
  8004af:	e9 81 01 00 00       	jmp    800635 <runcmd+0x42c>

	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
  8004b4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004b7:	80 38 2f             	cmpb   $0x2f,(%eax)
  8004ba:	74 23                	je     8004df <runcmd+0x2d6>
		argv0buf[0] = '/';
  8004bc:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  8004c3:	83 ec 08             	sub    $0x8,%esp
  8004c6:	50                   	push   %eax
  8004c7:	8d 9d a4 fb ff ff    	lea    -0x45c(%ebp),%ebx
  8004cd:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  8004d3:	50                   	push   %eax
  8004d4:	e8 7e 0c 00 00       	call   801157 <strcpy>
		argv[0] = argv0buf;
  8004d9:	89 5d a8             	mov    %ebx,-0x58(%ebp)
  8004dc:	83 c4 10             	add    $0x10,%esp
	}
	argv[argc] = 0;
  8004df:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
  8004e6:	00 

	// Print the command.
	if (debug) {
  8004e7:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8004ee:	74 49                	je     800539 <runcmd+0x330>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  8004f0:	a1 24 54 80 00       	mov    0x805424,%eax
  8004f5:	8b 40 48             	mov    0x48(%eax),%eax
  8004f8:	83 ec 08             	sub    $0x8,%esp
  8004fb:	50                   	push   %eax
  8004fc:	68 cf 34 80 00       	push   $0x8034cf
  800501:	e8 ec 05 00 00       	call   800af2 <cprintf>
  800506:	8d 5d a8             	lea    -0x58(%ebp),%ebx
		for (i = 0; argv[i]; i++)
  800509:	83 c4 10             	add    $0x10,%esp
  80050c:	eb 11                	jmp    80051f <runcmd+0x316>
			cprintf(" %s", argv[i]);
  80050e:	83 ec 08             	sub    $0x8,%esp
  800511:	50                   	push   %eax
  800512:	68 57 35 80 00       	push   $0x803557
  800517:	e8 d6 05 00 00       	call   800af2 <cprintf>
  80051c:	83 c4 10             	add    $0x10,%esp
  80051f:	83 c3 04             	add    $0x4,%ebx
	argv[argc] = 0;

	// Print the command.
	if (debug) {
		cprintf("[%08x] SPAWN:", thisenv->env_id);
		for (i = 0; argv[i]; i++)
  800522:	8b 43 fc             	mov    -0x4(%ebx),%eax
  800525:	85 c0                	test   %eax,%eax
  800527:	75 e5                	jne    80050e <runcmd+0x305>
			cprintf(" %s", argv[i]);
		cprintf("\n");
  800529:	83 ec 0c             	sub    $0xc,%esp
  80052c:	68 20 34 80 00       	push   $0x803420
  800531:	e8 bc 05 00 00       	call   800af2 <cprintf>
  800536:	83 c4 10             	add    $0x10,%esp
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char **) argv)) < 0)
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	8d 45 a8             	lea    -0x58(%ebp),%eax
  80053f:	50                   	push   %eax
  800540:	ff 75 a8             	pushl  -0x58(%ebp)
  800543:	e8 07 24 00 00       	call   80294f <spawn>
  800548:	89 c3                	mov    %eax,%ebx
  80054a:	83 c4 10             	add    $0x10,%esp
  80054d:	85 c0                	test   %eax,%eax
  80054f:	0f 89 c3 00 00 00    	jns    800618 <runcmd+0x40f>
		cprintf("spawn %s: %e\n", argv[0], r);
  800555:	83 ec 04             	sub    $0x4,%esp
  800558:	50                   	push   %eax
  800559:	ff 75 a8             	pushl  -0x58(%ebp)
  80055c:	68 dd 34 80 00       	push   $0x8034dd
  800561:	e8 8c 05 00 00       	call   800af2 <cprintf>

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  800566:	e8 28 19 00 00       	call   801e93 <close_all>
  80056b:	83 c4 10             	add    $0x10,%esp
  80056e:	eb 4c                	jmp    8005bc <runcmd+0x3b3>
	if (r >= 0) {
		if (debug)
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  800570:	a1 24 54 80 00       	mov    0x805424,%eax
  800575:	8b 40 48             	mov    0x48(%eax),%eax
  800578:	53                   	push   %ebx
  800579:	ff 75 a8             	pushl  -0x58(%ebp)
  80057c:	50                   	push   %eax
  80057d:	68 eb 34 80 00       	push   $0x8034eb
  800582:	e8 6b 05 00 00       	call   800af2 <cprintf>
  800587:	83 c4 10             	add    $0x10,%esp
		wait(r);
  80058a:	83 ec 0c             	sub    $0xc,%esp
  80058d:	53                   	push   %ebx
  80058e:	e8 b5 29 00 00       	call   802f48 <wait>
		if (debug)
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80059d:	0f 84 8c 00 00 00    	je     80062f <runcmd+0x426>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  8005a3:	a1 24 54 80 00       	mov    0x805424,%eax
  8005a8:	8b 40 48             	mov    0x48(%eax),%eax
  8005ab:	83 ec 08             	sub    $0x8,%esp
  8005ae:	50                   	push   %eax
  8005af:	68 00 35 80 00       	push   $0x803500
  8005b4:	e8 39 05 00 00       	call   800af2 <cprintf>
  8005b9:	83 c4 10             	add    $0x10,%esp
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  8005bc:	85 ff                	test   %edi,%edi
  8005be:	74 51                	je     800611 <runcmd+0x408>
		if (debug)
  8005c0:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8005c7:	74 1a                	je     8005e3 <runcmd+0x3da>
			cprintf("[%08x] WAIT pipe_child %08x\n",
			        thisenv->env_id,
  8005c9:	a1 24 54 80 00       	mov    0x805424,%eax

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
		if (debug)
			cprintf("[%08x] WAIT pipe_child %08x\n",
  8005ce:	8b 40 48             	mov    0x48(%eax),%eax
  8005d1:	83 ec 04             	sub    $0x4,%esp
  8005d4:	57                   	push   %edi
  8005d5:	50                   	push   %eax
  8005d6:	68 16 35 80 00       	push   $0x803516
  8005db:	e8 12 05 00 00       	call   800af2 <cprintf>
  8005e0:	83 c4 10             	add    $0x10,%esp
			        thisenv->env_id,
			        pipe_child);
		wait(pipe_child);
  8005e3:	83 ec 0c             	sub    $0xc,%esp
  8005e6:	57                   	push   %edi
  8005e7:	e8 5c 29 00 00       	call   802f48 <wait>
		if (debug)
  8005ec:	83 c4 10             	add    $0x10,%esp
  8005ef:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8005f6:	74 19                	je     800611 <runcmd+0x408>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  8005f8:	a1 24 54 80 00       	mov    0x805424,%eax
  8005fd:	8b 40 48             	mov    0x48(%eax),%eax
  800600:	83 ec 08             	sub    $0x8,%esp
  800603:	50                   	push   %eax
  800604:	68 00 35 80 00       	push   $0x803500
  800609:	e8 e4 04 00 00       	call   800af2 <cprintf>
  80060e:	83 c4 10             	add    $0x10,%esp
	}

	// Done!
	exit();
  800611:	e8 e9 03 00 00       	call   8009ff <exit>
  800616:	eb 1d                	jmp    800635 <runcmd+0x42c>
	if ((r = spawn(argv[0], (const char **) argv)) < 0)
		cprintf("spawn %s: %e\n", argv[0], r);

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  800618:	e8 76 18 00 00       	call   801e93 <close_all>
	if (r >= 0) {
		if (debug)
  80061d:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800624:	0f 84 60 ff ff ff    	je     80058a <runcmd+0x381>
  80062a:	e9 41 ff ff ff       	jmp    800570 <runcmd+0x367>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  80062f:	85 ff                	test   %edi,%edi
  800631:	75 b0                	jne    8005e3 <runcmd+0x3da>
  800633:	eb dc                	jmp    800611 <runcmd+0x408>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
	}

	// Done!
	exit();
}
  800635:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800638:	5b                   	pop    %ebx
  800639:	5e                   	pop    %esi
  80063a:	5f                   	pop    %edi
  80063b:	5d                   	pop    %ebp
  80063c:	c3                   	ret    

0080063d <usage>:
}


void
usage(void)
{
  80063d:	55                   	push   %ebp
  80063e:	89 e5                	mov    %esp,%ebp
  800640:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  800643:	68 e0 35 80 00       	push   $0x8035e0
  800648:	e8 a5 04 00 00       	call   800af2 <cprintf>
	exit();
  80064d:	e8 ad 03 00 00       	call   8009ff <exit>
}
  800652:	83 c4 10             	add    $0x10,%esp
  800655:	c9                   	leave  
  800656:	c3                   	ret    

00800657 <umain>:

void
umain(int argc, char **argv)
{
  800657:	55                   	push   %ebp
  800658:	89 e5                	mov    %esp,%ebp
  80065a:	57                   	push   %edi
  80065b:	56                   	push   %esi
  80065c:	53                   	push   %ebx
  80065d:	83 ec 30             	sub    $0x30,%esp
  800660:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  800663:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800666:	50                   	push   %eax
  800667:	57                   	push   %edi
  800668:	8d 45 08             	lea    0x8(%ebp),%eax
  80066b:	50                   	push   %eax
  80066c:	e8 03 15 00 00       	call   801b74 <argstart>
	while ((r = argnext(&args)) >= 0)
  800671:	83 c4 10             	add    $0x10,%esp
{
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
  800674:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
umain(int argc, char **argv)
{
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
  80067b:	be 3f 00 00 00       	mov    $0x3f,%esi
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  800680:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  800683:	eb 2f                	jmp    8006b4 <umain+0x5d>
		switch (r) {
  800685:	83 f8 69             	cmp    $0x69,%eax
  800688:	74 25                	je     8006af <umain+0x58>
  80068a:	83 f8 78             	cmp    $0x78,%eax
  80068d:	74 07                	je     800696 <umain+0x3f>
  80068f:	83 f8 64             	cmp    $0x64,%eax
  800692:	75 14                	jne    8006a8 <umain+0x51>
  800694:	eb 09                	jmp    80069f <umain+0x48>
			break;
		case 'i':
			interactive = 1;
			break;
		case 'x':
			echocmds = 1;
  800696:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  80069d:	eb 15                	jmp    8006b4 <umain+0x5d>
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
		switch (r) {
		case 'd':
			debug++;
  80069f:	83 05 00 50 80 00 01 	addl   $0x1,0x805000
			break;
  8006a6:	eb 0c                	jmp    8006b4 <umain+0x5d>
			break;
		case 'x':
			echocmds = 1;
			break;
		default:
			usage();
  8006a8:	e8 90 ff ff ff       	call   80063d <usage>
  8006ad:	eb 05                	jmp    8006b4 <umain+0x5d>
		switch (r) {
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
  8006af:	be 01 00 00 00       	mov    $0x1,%esi
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  8006b4:	83 ec 0c             	sub    $0xc,%esp
  8006b7:	53                   	push   %ebx
  8006b8:	e8 e7 14 00 00       	call   801ba4 <argnext>
  8006bd:	83 c4 10             	add    $0x10,%esp
  8006c0:	85 c0                	test   %eax,%eax
  8006c2:	79 c1                	jns    800685 <umain+0x2e>
			break;
		default:
			usage();
		}

	if (argc > 2)
  8006c4:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  8006c8:	7e 05                	jle    8006cf <umain+0x78>
		usage();
  8006ca:	e8 6e ff ff ff       	call   80063d <usage>
	if (argc == 2) {
  8006cf:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  8006d3:	75 56                	jne    80072b <umain+0xd4>
		close(0);
  8006d5:	83 ec 0c             	sub    $0xc,%esp
  8006d8:	6a 00                	push   $0x0
  8006da:	e8 89 17 00 00       	call   801e68 <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  8006df:	83 c4 08             	add    $0x8,%esp
  8006e2:	6a 00                	push   $0x0
  8006e4:	ff 77 04             	pushl  0x4(%edi)
  8006e7:	e8 66 1d 00 00       	call   802452 <open>
  8006ec:	83 c4 10             	add    $0x10,%esp
  8006ef:	85 c0                	test   %eax,%eax
  8006f1:	79 1b                	jns    80070e <umain+0xb7>
			panic("open %s: %e", argv[1], r);
  8006f3:	83 ec 0c             	sub    $0xc,%esp
  8006f6:	50                   	push   %eax
  8006f7:	ff 77 04             	pushl  0x4(%edi)
  8006fa:	68 33 35 80 00       	push   $0x803533
  8006ff:	68 28 01 00 00       	push   $0x128
  800704:	68 b6 34 80 00       	push   $0x8034b6
  800709:	e8 0b 03 00 00       	call   800a19 <_panic>
		assert(r == 0);
  80070e:	85 c0                	test   %eax,%eax
  800710:	74 19                	je     80072b <umain+0xd4>
  800712:	68 3f 35 80 00       	push   $0x80353f
  800717:	68 46 35 80 00       	push   $0x803546
  80071c:	68 29 01 00 00       	push   $0x129
  800721:	68 b6 34 80 00       	push   $0x8034b6
  800726:	e8 ee 02 00 00       	call   800a19 <_panic>
	}
	if (interactive == '?')
  80072b:	83 fe 3f             	cmp    $0x3f,%esi
  80072e:	75 0f                	jne    80073f <umain+0xe8>
		interactive = iscons(0);
  800730:	83 ec 0c             	sub    $0xc,%esp
  800733:	6a 00                	push   $0x0
  800735:	e8 f5 01 00 00       	call   80092f <iscons>
  80073a:	89 c6                	mov    %eax,%esi
  80073c:	83 c4 10             	add    $0x10,%esp
  80073f:	85 f6                	test   %esi,%esi
  800741:	b8 00 00 00 00       	mov    $0x0,%eax
  800746:	bf 5b 35 80 00       	mov    $0x80355b,%edi
  80074b:	0f 44 f8             	cmove  %eax,%edi

	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
  80074e:	83 ec 0c             	sub    $0xc,%esp
  800751:	57                   	push   %edi
  800752:	e8 d4 08 00 00       	call   80102b <readline>
  800757:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  800759:	83 c4 10             	add    $0x10,%esp
  80075c:	85 c0                	test   %eax,%eax
  80075e:	75 1e                	jne    80077e <umain+0x127>
			if (debug)
  800760:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800767:	74 10                	je     800779 <umain+0x122>
				cprintf("EXITING\n");
  800769:	83 ec 0c             	sub    $0xc,%esp
  80076c:	68 5e 35 80 00       	push   $0x80355e
  800771:	e8 7c 03 00 00       	call   800af2 <cprintf>
  800776:	83 c4 10             	add    $0x10,%esp
			exit();  // end of file
  800779:	e8 81 02 00 00       	call   8009ff <exit>
		}
		if (debug)
  80077e:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800785:	74 11                	je     800798 <umain+0x141>
			cprintf("LINE: %s\n", buf);
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	53                   	push   %ebx
  80078b:	68 67 35 80 00       	push   $0x803567
  800790:	e8 5d 03 00 00       	call   800af2 <cprintf>
  800795:	83 c4 10             	add    $0x10,%esp
		if (buf[0] == '#')
  800798:	80 3b 23             	cmpb   $0x23,(%ebx)
  80079b:	74 b1                	je     80074e <umain+0xf7>
			continue;
		if (echocmds)
  80079d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007a1:	74 11                	je     8007b4 <umain+0x15d>
			printf("# %s\n", buf);
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	53                   	push   %ebx
  8007a7:	68 71 35 80 00       	push   $0x803571
  8007ac:	e8 3f 1e 00 00       	call   8025f0 <printf>
  8007b1:	83 c4 10             	add    $0x10,%esp
		if (debug)
  8007b4:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8007bb:	74 10                	je     8007cd <umain+0x176>
			cprintf("BEFORE FORK\n");
  8007bd:	83 ec 0c             	sub    $0xc,%esp
  8007c0:	68 77 35 80 00       	push   $0x803577
  8007c5:	e8 28 03 00 00       	call   800af2 <cprintf>
  8007ca:	83 c4 10             	add    $0x10,%esp
		if ((r = fork()) < 0)
  8007cd:	e8 75 12 00 00       	call   801a47 <fork>
  8007d2:	89 c6                	mov    %eax,%esi
  8007d4:	85 c0                	test   %eax,%eax
  8007d6:	79 15                	jns    8007ed <umain+0x196>
			panic("fork: %e", r);
  8007d8:	50                   	push   %eax
  8007d9:	68 60 3a 80 00       	push   $0x803a60
  8007de:	68 40 01 00 00       	push   $0x140
  8007e3:	68 b6 34 80 00       	push   $0x8034b6
  8007e8:	e8 2c 02 00 00       	call   800a19 <_panic>
		if (debug)
  8007ed:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8007f4:	74 11                	je     800807 <umain+0x1b0>
			cprintf("FORK: %d\n", r);
  8007f6:	83 ec 08             	sub    $0x8,%esp
  8007f9:	50                   	push   %eax
  8007fa:	68 84 35 80 00       	push   $0x803584
  8007ff:	e8 ee 02 00 00       	call   800af2 <cprintf>
  800804:	83 c4 10             	add    $0x10,%esp
		if (r == 0) {
  800807:	85 f6                	test   %esi,%esi
  800809:	75 16                	jne    800821 <umain+0x1ca>
			runcmd(buf);
  80080b:	83 ec 0c             	sub    $0xc,%esp
  80080e:	53                   	push   %ebx
  80080f:	e8 f5 f9 ff ff       	call   800209 <runcmd>
			exit();
  800814:	e8 e6 01 00 00       	call   8009ff <exit>
  800819:	83 c4 10             	add    $0x10,%esp
  80081c:	e9 2d ff ff ff       	jmp    80074e <umain+0xf7>
		} else
			wait(r);
  800821:	83 ec 0c             	sub    $0xc,%esp
  800824:	56                   	push   %esi
  800825:	e8 1e 27 00 00       	call   802f48 <wait>
  80082a:	83 c4 10             	add    $0x10,%esp
  80082d:	e9 1c ff ff ff       	jmp    80074e <umain+0xf7>

00800832 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800835:	b8 00 00 00 00       	mov    $0x0,%eax
  80083a:	5d                   	pop    %ebp
  80083b:	c3                   	ret    

0080083c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80083c:	55                   	push   %ebp
  80083d:	89 e5                	mov    %esp,%ebp
  80083f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800842:	68 01 36 80 00       	push   $0x803601
  800847:	ff 75 0c             	pushl  0xc(%ebp)
  80084a:	e8 08 09 00 00       	call   801157 <strcpy>
	return 0;
}
  80084f:	b8 00 00 00 00       	mov    $0x0,%eax
  800854:	c9                   	leave  
  800855:	c3                   	ret    

00800856 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800856:	55                   	push   %ebp
  800857:	89 e5                	mov    %esp,%ebp
  800859:	57                   	push   %edi
  80085a:	56                   	push   %esi
  80085b:	53                   	push   %ebx
  80085c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800862:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800867:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80086d:	eb 2d                	jmp    80089c <devcons_write+0x46>
		m = n - tot;
  80086f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800872:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  800874:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  800877:	ba 7f 00 00 00       	mov    $0x7f,%edx
  80087c:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80087f:	83 ec 04             	sub    $0x4,%esp
  800882:	53                   	push   %ebx
  800883:	03 45 0c             	add    0xc(%ebp),%eax
  800886:	50                   	push   %eax
  800887:	57                   	push   %edi
  800888:	e8 5d 0a 00 00       	call   8012ea <memmove>
		sys_cputs(buf, m);
  80088d:	83 c4 08             	add    $0x8,%esp
  800890:	53                   	push   %ebx
  800891:	57                   	push   %edi
  800892:	e8 52 0c 00 00       	call   8014e9 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800897:	01 de                	add    %ebx,%esi
  800899:	83 c4 10             	add    $0x10,%esp
  80089c:	89 f0                	mov    %esi,%eax
  80089e:	3b 75 10             	cmp    0x10(%ebp),%esi
  8008a1:	72 cc                	jb     80086f <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8008a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008a6:	5b                   	pop    %ebx
  8008a7:	5e                   	pop    %esi
  8008a8:	5f                   	pop    %edi
  8008a9:	5d                   	pop    %ebp
  8008aa:	c3                   	ret    

008008ab <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  8008b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8008ba:	74 2a                	je     8008e6 <devcons_read+0x3b>
  8008bc:	eb 05                	jmp    8008c3 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8008be:	e8 b6 0c 00 00       	call   801579 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8008c3:	e8 47 0c 00 00       	call   80150f <sys_cgetc>
  8008c8:	85 c0                	test   %eax,%eax
  8008ca:	74 f2                	je     8008be <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8008cc:	85 c0                	test   %eax,%eax
  8008ce:	78 16                	js     8008e6 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8008d0:	83 f8 04             	cmp    $0x4,%eax
  8008d3:	74 0c                	je     8008e1 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8008d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d8:	88 02                	mov    %al,(%edx)
	return 1;
  8008da:	b8 01 00 00 00       	mov    $0x1,%eax
  8008df:	eb 05                	jmp    8008e6 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8008e1:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8008e6:	c9                   	leave  
  8008e7:	c3                   	ret    

008008e8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8008f4:	6a 01                	push   $0x1
  8008f6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8008f9:	50                   	push   %eax
  8008fa:	e8 ea 0b 00 00       	call   8014e9 <sys_cputs>
}
  8008ff:	83 c4 10             	add    $0x10,%esp
  800902:	c9                   	leave  
  800903:	c3                   	ret    

00800904 <getchar>:

int
getchar(void)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80090a:	6a 01                	push   $0x1
  80090c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80090f:	50                   	push   %eax
  800910:	6a 00                	push   $0x0
  800912:	e8 8d 16 00 00       	call   801fa4 <read>
	if (r < 0)
  800917:	83 c4 10             	add    $0x10,%esp
  80091a:	85 c0                	test   %eax,%eax
  80091c:	78 0f                	js     80092d <getchar+0x29>
		return r;
	if (r < 1)
  80091e:	85 c0                	test   %eax,%eax
  800920:	7e 06                	jle    800928 <getchar+0x24>
		return -E_EOF;
	return c;
  800922:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800926:	eb 05                	jmp    80092d <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800928:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80092d:	c9                   	leave  
  80092e:	c3                   	ret    

0080092f <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800935:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800938:	50                   	push   %eax
  800939:	ff 75 08             	pushl  0x8(%ebp)
  80093c:	e8 fe 13 00 00       	call   801d3f <fd_lookup>
  800941:	83 c4 10             	add    $0x10,%esp
  800944:	85 c0                	test   %eax,%eax
  800946:	78 11                	js     800959 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80094b:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800951:	39 10                	cmp    %edx,(%eax)
  800953:	0f 94 c0             	sete   %al
  800956:	0f b6 c0             	movzbl %al,%eax
}
  800959:	c9                   	leave  
  80095a:	c3                   	ret    

0080095b <opencons>:

int
opencons(void)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800961:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800964:	50                   	push   %eax
  800965:	e8 86 13 00 00       	call   801cf0 <fd_alloc>
  80096a:	83 c4 10             	add    $0x10,%esp
		return r;
  80096d:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80096f:	85 c0                	test   %eax,%eax
  800971:	78 3e                	js     8009b1 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800973:	83 ec 04             	sub    $0x4,%esp
  800976:	68 07 04 00 00       	push   $0x407
  80097b:	ff 75 f4             	pushl  -0xc(%ebp)
  80097e:	6a 00                	push   $0x0
  800980:	e8 1b 0c 00 00       	call   8015a0 <sys_page_alloc>
  800985:	83 c4 10             	add    $0x10,%esp
		return r;
  800988:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80098a:	85 c0                	test   %eax,%eax
  80098c:	78 23                	js     8009b1 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80098e:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800997:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80099c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8009a3:	83 ec 0c             	sub    $0xc,%esp
  8009a6:	50                   	push   %eax
  8009a7:	e8 1c 13 00 00       	call   801cc8 <fd2num>
  8009ac:	89 c2                	mov    %eax,%edx
  8009ae:	83 c4 10             	add    $0x10,%esp
}
  8009b1:	89 d0                	mov    %edx,%eax
  8009b3:	c9                   	leave  
  8009b4:	c3                   	ret    

008009b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8009b5:	55                   	push   %ebp
  8009b6:	89 e5                	mov    %esp,%ebp
  8009b8:	56                   	push   %esi
  8009b9:	53                   	push   %ebx
  8009ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8009bd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8009c0:	e8 90 0b 00 00       	call   801555 <sys_getenvid>
	if (id >= 0)
  8009c5:	85 c0                	test   %eax,%eax
  8009c7:	78 12                	js     8009db <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  8009c9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8009ce:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8009d1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8009d6:	a3 24 54 80 00       	mov    %eax,0x805424

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8009db:	85 db                	test   %ebx,%ebx
  8009dd:	7e 07                	jle    8009e6 <libmain+0x31>
		binaryname = argv[0];
  8009df:	8b 06                	mov    (%esi),%eax
  8009e1:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  8009e6:	83 ec 08             	sub    $0x8,%esp
  8009e9:	56                   	push   %esi
  8009ea:	53                   	push   %ebx
  8009eb:	e8 67 fc ff ff       	call   800657 <umain>

	// exit gracefully
	exit();
  8009f0:	e8 0a 00 00 00       	call   8009ff <exit>
}
  8009f5:	83 c4 10             	add    $0x10,%esp
  8009f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009fb:	5b                   	pop    %ebx
  8009fc:	5e                   	pop    %esi
  8009fd:	5d                   	pop    %ebp
  8009fe:	c3                   	ret    

008009ff <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800a05:	e8 89 14 00 00       	call   801e93 <close_all>
	sys_env_destroy(0);
  800a0a:	83 ec 0c             	sub    $0xc,%esp
  800a0d:	6a 00                	push   $0x0
  800a0f:	e8 1f 0b 00 00       	call   801533 <sys_env_destroy>
}
  800a14:	83 c4 10             	add    $0x10,%esp
  800a17:	c9                   	leave  
  800a18:	c3                   	ret    

00800a19 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	56                   	push   %esi
  800a1d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800a1e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800a21:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  800a27:	e8 29 0b 00 00       	call   801555 <sys_getenvid>
  800a2c:	83 ec 0c             	sub    $0xc,%esp
  800a2f:	ff 75 0c             	pushl  0xc(%ebp)
  800a32:	ff 75 08             	pushl  0x8(%ebp)
  800a35:	56                   	push   %esi
  800a36:	50                   	push   %eax
  800a37:	68 18 36 80 00       	push   $0x803618
  800a3c:	e8 b1 00 00 00       	call   800af2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800a41:	83 c4 18             	add    $0x18,%esp
  800a44:	53                   	push   %ebx
  800a45:	ff 75 10             	pushl  0x10(%ebp)
  800a48:	e8 54 00 00 00       	call   800aa1 <vcprintf>
	cprintf("\n");
  800a4d:	c7 04 24 20 34 80 00 	movl   $0x803420,(%esp)
  800a54:	e8 99 00 00 00       	call   800af2 <cprintf>
  800a59:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800a5c:	cc                   	int3   
  800a5d:	eb fd                	jmp    800a5c <_panic+0x43>

00800a5f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	53                   	push   %ebx
  800a63:	83 ec 04             	sub    $0x4,%esp
  800a66:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800a69:	8b 13                	mov    (%ebx),%edx
  800a6b:	8d 42 01             	lea    0x1(%edx),%eax
  800a6e:	89 03                	mov    %eax,(%ebx)
  800a70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a73:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800a77:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a7c:	75 1a                	jne    800a98 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  800a7e:	83 ec 08             	sub    $0x8,%esp
  800a81:	68 ff 00 00 00       	push   $0xff
  800a86:	8d 43 08             	lea    0x8(%ebx),%eax
  800a89:	50                   	push   %eax
  800a8a:	e8 5a 0a 00 00       	call   8014e9 <sys_cputs>
		b->idx = 0;
  800a8f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800a95:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  800a98:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800a9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a9f:	c9                   	leave  
  800aa0:	c3                   	ret    

00800aa1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800aaa:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ab1:	00 00 00 
	b.cnt = 0;
  800ab4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800abb:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	ff 75 08             	pushl  0x8(%ebp)
  800ac4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800aca:	50                   	push   %eax
  800acb:	68 5f 0a 80 00       	push   $0x800a5f
  800ad0:	e8 86 01 00 00       	call   800c5b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800ad5:	83 c4 08             	add    $0x8,%esp
  800ad8:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800ade:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800ae4:	50                   	push   %eax
  800ae5:	e8 ff 09 00 00       	call   8014e9 <sys_cputs>

	return b.cnt;
}
  800aea:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800af0:	c9                   	leave  
  800af1:	c3                   	ret    

00800af2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800af8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800afb:	50                   	push   %eax
  800afc:	ff 75 08             	pushl  0x8(%ebp)
  800aff:	e8 9d ff ff ff       	call   800aa1 <vcprintf>
	va_end(ap);

	return cnt;
}
  800b04:	c9                   	leave  
  800b05:	c3                   	ret    

00800b06 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	57                   	push   %edi
  800b0a:	56                   	push   %esi
  800b0b:	53                   	push   %ebx
  800b0c:	83 ec 1c             	sub    $0x1c,%esp
  800b0f:	89 c7                	mov    %eax,%edi
  800b11:	89 d6                	mov    %edx,%esi
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b19:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b1c:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b1f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b22:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b27:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800b2a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800b2d:	39 d3                	cmp    %edx,%ebx
  800b2f:	72 05                	jb     800b36 <printnum+0x30>
  800b31:	39 45 10             	cmp    %eax,0x10(%ebp)
  800b34:	77 45                	ja     800b7b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b36:	83 ec 0c             	sub    $0xc,%esp
  800b39:	ff 75 18             	pushl  0x18(%ebp)
  800b3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b42:	53                   	push   %ebx
  800b43:	ff 75 10             	pushl  0x10(%ebp)
  800b46:	83 ec 08             	sub    $0x8,%esp
  800b49:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b4c:	ff 75 e0             	pushl  -0x20(%ebp)
  800b4f:	ff 75 dc             	pushl  -0x24(%ebp)
  800b52:	ff 75 d8             	pushl  -0x28(%ebp)
  800b55:	e8 06 26 00 00       	call   803160 <__udivdi3>
  800b5a:	83 c4 18             	add    $0x18,%esp
  800b5d:	52                   	push   %edx
  800b5e:	50                   	push   %eax
  800b5f:	89 f2                	mov    %esi,%edx
  800b61:	89 f8                	mov    %edi,%eax
  800b63:	e8 9e ff ff ff       	call   800b06 <printnum>
  800b68:	83 c4 20             	add    $0x20,%esp
  800b6b:	eb 18                	jmp    800b85 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	56                   	push   %esi
  800b71:	ff 75 18             	pushl  0x18(%ebp)
  800b74:	ff d7                	call   *%edi
  800b76:	83 c4 10             	add    $0x10,%esp
  800b79:	eb 03                	jmp    800b7e <printnum+0x78>
  800b7b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b7e:	83 eb 01             	sub    $0x1,%ebx
  800b81:	85 db                	test   %ebx,%ebx
  800b83:	7f e8                	jg     800b6d <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b85:	83 ec 08             	sub    $0x8,%esp
  800b88:	56                   	push   %esi
  800b89:	83 ec 04             	sub    $0x4,%esp
  800b8c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b8f:	ff 75 e0             	pushl  -0x20(%ebp)
  800b92:	ff 75 dc             	pushl  -0x24(%ebp)
  800b95:	ff 75 d8             	pushl  -0x28(%ebp)
  800b98:	e8 f3 26 00 00       	call   803290 <__umoddi3>
  800b9d:	83 c4 14             	add    $0x14,%esp
  800ba0:	0f be 80 3b 36 80 00 	movsbl 0x80363b(%eax),%eax
  800ba7:	50                   	push   %eax
  800ba8:	ff d7                	call   *%edi
}
  800baa:	83 c4 10             	add    $0x10,%esp
  800bad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bb0:	5b                   	pop    %ebx
  800bb1:	5e                   	pop    %esi
  800bb2:	5f                   	pop    %edi
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    

00800bb5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bb8:	83 fa 01             	cmp    $0x1,%edx
  800bbb:	7e 0e                	jle    800bcb <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800bbd:	8b 10                	mov    (%eax),%edx
  800bbf:	8d 4a 08             	lea    0x8(%edx),%ecx
  800bc2:	89 08                	mov    %ecx,(%eax)
  800bc4:	8b 02                	mov    (%edx),%eax
  800bc6:	8b 52 04             	mov    0x4(%edx),%edx
  800bc9:	eb 22                	jmp    800bed <getuint+0x38>
	else if (lflag)
  800bcb:	85 d2                	test   %edx,%edx
  800bcd:	74 10                	je     800bdf <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800bcf:	8b 10                	mov    (%eax),%edx
  800bd1:	8d 4a 04             	lea    0x4(%edx),%ecx
  800bd4:	89 08                	mov    %ecx,(%eax)
  800bd6:	8b 02                	mov    (%edx),%eax
  800bd8:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdd:	eb 0e                	jmp    800bed <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800bdf:	8b 10                	mov    (%eax),%edx
  800be1:	8d 4a 04             	lea    0x4(%edx),%ecx
  800be4:	89 08                	mov    %ecx,(%eax)
  800be6:	8b 02                	mov    (%edx),%eax
  800be8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bed:	5d                   	pop    %ebp
  800bee:	c3                   	ret    

00800bef <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bf2:	83 fa 01             	cmp    $0x1,%edx
  800bf5:	7e 0e                	jle    800c05 <getint+0x16>
		return va_arg(*ap, long long);
  800bf7:	8b 10                	mov    (%eax),%edx
  800bf9:	8d 4a 08             	lea    0x8(%edx),%ecx
  800bfc:	89 08                	mov    %ecx,(%eax)
  800bfe:	8b 02                	mov    (%edx),%eax
  800c00:	8b 52 04             	mov    0x4(%edx),%edx
  800c03:	eb 1a                	jmp    800c1f <getint+0x30>
	else if (lflag)
  800c05:	85 d2                	test   %edx,%edx
  800c07:	74 0c                	je     800c15 <getint+0x26>
		return va_arg(*ap, long);
  800c09:	8b 10                	mov    (%eax),%edx
  800c0b:	8d 4a 04             	lea    0x4(%edx),%ecx
  800c0e:	89 08                	mov    %ecx,(%eax)
  800c10:	8b 02                	mov    (%edx),%eax
  800c12:	99                   	cltd   
  800c13:	eb 0a                	jmp    800c1f <getint+0x30>
	else
		return va_arg(*ap, int);
  800c15:	8b 10                	mov    (%eax),%edx
  800c17:	8d 4a 04             	lea    0x4(%edx),%ecx
  800c1a:	89 08                	mov    %ecx,(%eax)
  800c1c:	8b 02                	mov    (%edx),%eax
  800c1e:	99                   	cltd   
}
  800c1f:	5d                   	pop    %ebp
  800c20:	c3                   	ret    

00800c21 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800c27:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800c2b:	8b 10                	mov    (%eax),%edx
  800c2d:	3b 50 04             	cmp    0x4(%eax),%edx
  800c30:	73 0a                	jae    800c3c <sprintputch+0x1b>
		*b->buf++ = ch;
  800c32:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c35:	89 08                	mov    %ecx,(%eax)
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	88 02                	mov    %al,(%edx)
}
  800c3c:	5d                   	pop    %ebp
  800c3d:	c3                   	ret    

00800c3e <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c3e:	55                   	push   %ebp
  800c3f:	89 e5                	mov    %esp,%ebp
  800c41:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800c44:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800c47:	50                   	push   %eax
  800c48:	ff 75 10             	pushl  0x10(%ebp)
  800c4b:	ff 75 0c             	pushl  0xc(%ebp)
  800c4e:	ff 75 08             	pushl  0x8(%ebp)
  800c51:	e8 05 00 00 00       	call   800c5b <vprintfmt>
	va_end(ap);
}
  800c56:	83 c4 10             	add    $0x10,%esp
  800c59:	c9                   	leave  
  800c5a:	c3                   	ret    

00800c5b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	57                   	push   %edi
  800c5f:	56                   	push   %esi
  800c60:	53                   	push   %ebx
  800c61:	83 ec 2c             	sub    $0x2c,%esp
  800c64:	8b 75 08             	mov    0x8(%ebp),%esi
  800c67:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c6a:	8b 7d 10             	mov    0x10(%ebp),%edi
  800c6d:	eb 12                	jmp    800c81 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800c6f:	85 c0                	test   %eax,%eax
  800c71:	0f 84 44 03 00 00    	je     800fbb <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  800c77:	83 ec 08             	sub    $0x8,%esp
  800c7a:	53                   	push   %ebx
  800c7b:	50                   	push   %eax
  800c7c:	ff d6                	call   *%esi
  800c7e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c81:	83 c7 01             	add    $0x1,%edi
  800c84:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800c88:	83 f8 25             	cmp    $0x25,%eax
  800c8b:	75 e2                	jne    800c6f <vprintfmt+0x14>
  800c8d:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800c91:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800c98:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800c9f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800ca6:	ba 00 00 00 00       	mov    $0x0,%edx
  800cab:	eb 07                	jmp    800cb4 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cad:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800cb0:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cb4:	8d 47 01             	lea    0x1(%edi),%eax
  800cb7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cba:	0f b6 07             	movzbl (%edi),%eax
  800cbd:	0f b6 c8             	movzbl %al,%ecx
  800cc0:	83 e8 23             	sub    $0x23,%eax
  800cc3:	3c 55                	cmp    $0x55,%al
  800cc5:	0f 87 d5 02 00 00    	ja     800fa0 <vprintfmt+0x345>
  800ccb:	0f b6 c0             	movzbl %al,%eax
  800cce:	ff 24 85 80 37 80 00 	jmp    *0x803780(,%eax,4)
  800cd5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cd8:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800cdc:	eb d6                	jmp    800cb4 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cde:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800ce1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800ce9:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800cec:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  800cf0:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  800cf3:	8d 51 d0             	lea    -0x30(%ecx),%edx
  800cf6:	83 fa 09             	cmp    $0x9,%edx
  800cf9:	77 39                	ja     800d34 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cfb:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cfe:	eb e9                	jmp    800ce9 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d00:	8b 45 14             	mov    0x14(%ebp),%eax
  800d03:	8d 48 04             	lea    0x4(%eax),%ecx
  800d06:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800d09:	8b 00                	mov    (%eax),%eax
  800d0b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d0e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800d11:	eb 27                	jmp    800d3a <vprintfmt+0xdf>
  800d13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d16:	85 c0                	test   %eax,%eax
  800d18:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d1d:	0f 49 c8             	cmovns %eax,%ecx
  800d20:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d23:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800d26:	eb 8c                	jmp    800cb4 <vprintfmt+0x59>
  800d28:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800d2b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800d32:	eb 80                	jmp    800cb4 <vprintfmt+0x59>
  800d34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800d37:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  800d3a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d3e:	0f 89 70 ff ff ff    	jns    800cb4 <vprintfmt+0x59>
				width = precision, precision = -1;
  800d44:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d47:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d4a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800d51:	e9 5e ff ff ff       	jmp    800cb4 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d56:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d59:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800d5c:	e9 53 ff ff ff       	jmp    800cb4 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d61:	8b 45 14             	mov    0x14(%ebp),%eax
  800d64:	8d 50 04             	lea    0x4(%eax),%edx
  800d67:	89 55 14             	mov    %edx,0x14(%ebp)
  800d6a:	83 ec 08             	sub    $0x8,%esp
  800d6d:	53                   	push   %ebx
  800d6e:	ff 30                	pushl  (%eax)
  800d70:	ff d6                	call   *%esi
			break;
  800d72:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d75:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800d78:	e9 04 ff ff ff       	jmp    800c81 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d80:	8d 50 04             	lea    0x4(%eax),%edx
  800d83:	89 55 14             	mov    %edx,0x14(%ebp)
  800d86:	8b 00                	mov    (%eax),%eax
  800d88:	99                   	cltd   
  800d89:	31 d0                	xor    %edx,%eax
  800d8b:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d8d:	83 f8 0f             	cmp    $0xf,%eax
  800d90:	7f 0b                	jg     800d9d <vprintfmt+0x142>
  800d92:	8b 14 85 e0 38 80 00 	mov    0x8038e0(,%eax,4),%edx
  800d99:	85 d2                	test   %edx,%edx
  800d9b:	75 18                	jne    800db5 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  800d9d:	50                   	push   %eax
  800d9e:	68 53 36 80 00       	push   $0x803653
  800da3:	53                   	push   %ebx
  800da4:	56                   	push   %esi
  800da5:	e8 94 fe ff ff       	call   800c3e <printfmt>
  800daa:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800db0:	e9 cc fe ff ff       	jmp    800c81 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  800db5:	52                   	push   %edx
  800db6:	68 58 35 80 00       	push   $0x803558
  800dbb:	53                   	push   %ebx
  800dbc:	56                   	push   %esi
  800dbd:	e8 7c fe ff ff       	call   800c3e <printfmt>
  800dc2:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dc5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800dc8:	e9 b4 fe ff ff       	jmp    800c81 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dcd:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd0:	8d 50 04             	lea    0x4(%eax),%edx
  800dd3:	89 55 14             	mov    %edx,0x14(%ebp)
  800dd6:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800dd8:	85 ff                	test   %edi,%edi
  800dda:	b8 4c 36 80 00       	mov    $0x80364c,%eax
  800ddf:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800de2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800de6:	0f 8e 94 00 00 00    	jle    800e80 <vprintfmt+0x225>
  800dec:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800df0:	0f 84 98 00 00 00    	je     800e8e <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  800df6:	83 ec 08             	sub    $0x8,%esp
  800df9:	ff 75 d0             	pushl  -0x30(%ebp)
  800dfc:	57                   	push   %edi
  800dfd:	e8 34 03 00 00       	call   801136 <strnlen>
  800e02:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800e05:	29 c1                	sub    %eax,%ecx
  800e07:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800e0a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800e0d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800e11:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e14:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800e17:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e19:	eb 0f                	jmp    800e2a <vprintfmt+0x1cf>
					putch(padc, putdat);
  800e1b:	83 ec 08             	sub    $0x8,%esp
  800e1e:	53                   	push   %ebx
  800e1f:	ff 75 e0             	pushl  -0x20(%ebp)
  800e22:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e24:	83 ef 01             	sub    $0x1,%edi
  800e27:	83 c4 10             	add    $0x10,%esp
  800e2a:	85 ff                	test   %edi,%edi
  800e2c:	7f ed                	jg     800e1b <vprintfmt+0x1c0>
  800e2e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800e31:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800e34:	85 c9                	test   %ecx,%ecx
  800e36:	b8 00 00 00 00       	mov    $0x0,%eax
  800e3b:	0f 49 c1             	cmovns %ecx,%eax
  800e3e:	29 c1                	sub    %eax,%ecx
  800e40:	89 75 08             	mov    %esi,0x8(%ebp)
  800e43:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800e46:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800e49:	89 cb                	mov    %ecx,%ebx
  800e4b:	eb 4d                	jmp    800e9a <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800e4d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800e51:	74 1b                	je     800e6e <vprintfmt+0x213>
  800e53:	0f be c0             	movsbl %al,%eax
  800e56:	83 e8 20             	sub    $0x20,%eax
  800e59:	83 f8 5e             	cmp    $0x5e,%eax
  800e5c:	76 10                	jbe    800e6e <vprintfmt+0x213>
					putch('?', putdat);
  800e5e:	83 ec 08             	sub    $0x8,%esp
  800e61:	ff 75 0c             	pushl  0xc(%ebp)
  800e64:	6a 3f                	push   $0x3f
  800e66:	ff 55 08             	call   *0x8(%ebp)
  800e69:	83 c4 10             	add    $0x10,%esp
  800e6c:	eb 0d                	jmp    800e7b <vprintfmt+0x220>
				else
					putch(ch, putdat);
  800e6e:	83 ec 08             	sub    $0x8,%esp
  800e71:	ff 75 0c             	pushl  0xc(%ebp)
  800e74:	52                   	push   %edx
  800e75:	ff 55 08             	call   *0x8(%ebp)
  800e78:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e7b:	83 eb 01             	sub    $0x1,%ebx
  800e7e:	eb 1a                	jmp    800e9a <vprintfmt+0x23f>
  800e80:	89 75 08             	mov    %esi,0x8(%ebp)
  800e83:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800e86:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800e89:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800e8c:	eb 0c                	jmp    800e9a <vprintfmt+0x23f>
  800e8e:	89 75 08             	mov    %esi,0x8(%ebp)
  800e91:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800e94:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800e97:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800e9a:	83 c7 01             	add    $0x1,%edi
  800e9d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ea1:	0f be d0             	movsbl %al,%edx
  800ea4:	85 d2                	test   %edx,%edx
  800ea6:	74 23                	je     800ecb <vprintfmt+0x270>
  800ea8:	85 f6                	test   %esi,%esi
  800eaa:	78 a1                	js     800e4d <vprintfmt+0x1f2>
  800eac:	83 ee 01             	sub    $0x1,%esi
  800eaf:	79 9c                	jns    800e4d <vprintfmt+0x1f2>
  800eb1:	89 df                	mov    %ebx,%edi
  800eb3:	8b 75 08             	mov    0x8(%ebp),%esi
  800eb6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800eb9:	eb 18                	jmp    800ed3 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800ebb:	83 ec 08             	sub    $0x8,%esp
  800ebe:	53                   	push   %ebx
  800ebf:	6a 20                	push   $0x20
  800ec1:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ec3:	83 ef 01             	sub    $0x1,%edi
  800ec6:	83 c4 10             	add    $0x10,%esp
  800ec9:	eb 08                	jmp    800ed3 <vprintfmt+0x278>
  800ecb:	89 df                	mov    %ebx,%edi
  800ecd:	8b 75 08             	mov    0x8(%ebp),%esi
  800ed0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ed3:	85 ff                	test   %edi,%edi
  800ed5:	7f e4                	jg     800ebb <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ed7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800eda:	e9 a2 fd ff ff       	jmp    800c81 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800edf:	8d 45 14             	lea    0x14(%ebp),%eax
  800ee2:	e8 08 fd ff ff       	call   800bef <getint>
  800ee7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800eea:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800eed:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800ef2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ef6:	79 74                	jns    800f6c <vprintfmt+0x311>
				putch('-', putdat);
  800ef8:	83 ec 08             	sub    $0x8,%esp
  800efb:	53                   	push   %ebx
  800efc:	6a 2d                	push   $0x2d
  800efe:	ff d6                	call   *%esi
				num = -(long long) num;
  800f00:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800f03:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800f06:	f7 d8                	neg    %eax
  800f08:	83 d2 00             	adc    $0x0,%edx
  800f0b:	f7 da                	neg    %edx
  800f0d:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  800f10:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f15:	eb 55                	jmp    800f6c <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f17:	8d 45 14             	lea    0x14(%ebp),%eax
  800f1a:	e8 96 fc ff ff       	call   800bb5 <getuint>
			base = 10;
  800f1f:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800f24:	eb 46                	jmp    800f6c <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800f26:	8d 45 14             	lea    0x14(%ebp),%eax
  800f29:	e8 87 fc ff ff       	call   800bb5 <getuint>
			base = 8;
  800f2e:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800f33:	eb 37                	jmp    800f6c <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  800f35:	83 ec 08             	sub    $0x8,%esp
  800f38:	53                   	push   %ebx
  800f39:	6a 30                	push   $0x30
  800f3b:	ff d6                	call   *%esi
			putch('x', putdat);
  800f3d:	83 c4 08             	add    $0x8,%esp
  800f40:	53                   	push   %ebx
  800f41:	6a 78                	push   $0x78
  800f43:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800f45:	8b 45 14             	mov    0x14(%ebp),%eax
  800f48:	8d 50 04             	lea    0x4(%eax),%edx
  800f4b:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f4e:	8b 00                	mov    (%eax),%eax
  800f50:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800f55:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800f58:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800f5d:	eb 0d                	jmp    800f6c <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f5f:	8d 45 14             	lea    0x14(%ebp),%eax
  800f62:	e8 4e fc ff ff       	call   800bb5 <getuint>
			base = 16;
  800f67:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f6c:	83 ec 0c             	sub    $0xc,%esp
  800f6f:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800f73:	57                   	push   %edi
  800f74:	ff 75 e0             	pushl  -0x20(%ebp)
  800f77:	51                   	push   %ecx
  800f78:	52                   	push   %edx
  800f79:	50                   	push   %eax
  800f7a:	89 da                	mov    %ebx,%edx
  800f7c:	89 f0                	mov    %esi,%eax
  800f7e:	e8 83 fb ff ff       	call   800b06 <printnum>
			break;
  800f83:	83 c4 20             	add    $0x20,%esp
  800f86:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800f89:	e9 f3 fc ff ff       	jmp    800c81 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f8e:	83 ec 08             	sub    $0x8,%esp
  800f91:	53                   	push   %ebx
  800f92:	51                   	push   %ecx
  800f93:	ff d6                	call   *%esi
			break;
  800f95:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f98:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800f9b:	e9 e1 fc ff ff       	jmp    800c81 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fa0:	83 ec 08             	sub    $0x8,%esp
  800fa3:	53                   	push   %ebx
  800fa4:	6a 25                	push   $0x25
  800fa6:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fa8:	83 c4 10             	add    $0x10,%esp
  800fab:	eb 03                	jmp    800fb0 <vprintfmt+0x355>
  800fad:	83 ef 01             	sub    $0x1,%edi
  800fb0:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  800fb4:	75 f7                	jne    800fad <vprintfmt+0x352>
  800fb6:	e9 c6 fc ff ff       	jmp    800c81 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  800fbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fbe:	5b                   	pop    %ebx
  800fbf:	5e                   	pop    %esi
  800fc0:	5f                   	pop    %edi
  800fc1:	5d                   	pop    %ebp
  800fc2:	c3                   	ret    

00800fc3 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	83 ec 18             	sub    $0x18,%esp
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fcf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fd2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800fd6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800fd9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fe0:	85 c0                	test   %eax,%eax
  800fe2:	74 26                	je     80100a <vsnprintf+0x47>
  800fe4:	85 d2                	test   %edx,%edx
  800fe6:	7e 22                	jle    80100a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fe8:	ff 75 14             	pushl  0x14(%ebp)
  800feb:	ff 75 10             	pushl  0x10(%ebp)
  800fee:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ff1:	50                   	push   %eax
  800ff2:	68 21 0c 80 00       	push   $0x800c21
  800ff7:	e8 5f fc ff ff       	call   800c5b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ffc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fff:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801005:	83 c4 10             	add    $0x10,%esp
  801008:	eb 05                	jmp    80100f <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80100a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80100f:	c9                   	leave  
  801010:	c3                   	ret    

00801011 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801017:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80101a:	50                   	push   %eax
  80101b:	ff 75 10             	pushl  0x10(%ebp)
  80101e:	ff 75 0c             	pushl  0xc(%ebp)
  801021:	ff 75 08             	pushl  0x8(%ebp)
  801024:	e8 9a ff ff ff       	call   800fc3 <vsnprintf>
	va_end(ap);

	return rc;
}
  801029:	c9                   	leave  
  80102a:	c3                   	ret    

0080102b <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	57                   	push   %edi
  80102f:	56                   	push   %esi
  801030:	53                   	push   %ebx
  801031:	83 ec 0c             	sub    $0xc,%esp
  801034:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  801037:	85 c0                	test   %eax,%eax
  801039:	74 13                	je     80104e <readline+0x23>
		fprintf(1, "%s", prompt);
  80103b:	83 ec 04             	sub    $0x4,%esp
  80103e:	50                   	push   %eax
  80103f:	68 58 35 80 00       	push   $0x803558
  801044:	6a 01                	push   $0x1
  801046:	e8 8e 15 00 00       	call   8025d9 <fprintf>
  80104b:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  80104e:	83 ec 0c             	sub    $0xc,%esp
  801051:	6a 00                	push   $0x0
  801053:	e8 d7 f8 ff ff       	call   80092f <iscons>
  801058:	89 c7                	mov    %eax,%edi
  80105a:	83 c4 10             	add    $0x10,%esp
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
  80105d:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
	while (1) {
		c = getchar();
  801062:	e8 9d f8 ff ff       	call   800904 <getchar>
  801067:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  801069:	85 c0                	test   %eax,%eax
  80106b:	79 29                	jns    801096 <readline+0x6b>
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  80106d:	b8 00 00 00 00       	mov    $0x0,%eax
	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
  801072:	83 fb f8             	cmp    $0xfffffff8,%ebx
  801075:	0f 84 9b 00 00 00    	je     801116 <readline+0xeb>
				cprintf("read error: %e\n", c);
  80107b:	83 ec 08             	sub    $0x8,%esp
  80107e:	53                   	push   %ebx
  80107f:	68 3f 39 80 00       	push   $0x80393f
  801084:	e8 69 fa ff ff       	call   800af2 <cprintf>
  801089:	83 c4 10             	add    $0x10,%esp
			return NULL;
  80108c:	b8 00 00 00 00       	mov    $0x0,%eax
  801091:	e9 80 00 00 00       	jmp    801116 <readline+0xeb>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  801096:	83 f8 08             	cmp    $0x8,%eax
  801099:	0f 94 c2             	sete   %dl
  80109c:	83 f8 7f             	cmp    $0x7f,%eax
  80109f:	0f 94 c0             	sete   %al
  8010a2:	08 c2                	or     %al,%dl
  8010a4:	74 1a                	je     8010c0 <readline+0x95>
  8010a6:	85 f6                	test   %esi,%esi
  8010a8:	7e 16                	jle    8010c0 <readline+0x95>
			if (echoing)
  8010aa:	85 ff                	test   %edi,%edi
  8010ac:	74 0d                	je     8010bb <readline+0x90>
				cputchar('\b');
  8010ae:	83 ec 0c             	sub    $0xc,%esp
  8010b1:	6a 08                	push   $0x8
  8010b3:	e8 30 f8 ff ff       	call   8008e8 <cputchar>
  8010b8:	83 c4 10             	add    $0x10,%esp
			i--;
  8010bb:	83 ee 01             	sub    $0x1,%esi
  8010be:	eb a2                	jmp    801062 <readline+0x37>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8010c0:	83 fb 1f             	cmp    $0x1f,%ebx
  8010c3:	7e 26                	jle    8010eb <readline+0xc0>
  8010c5:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  8010cb:	7f 1e                	jg     8010eb <readline+0xc0>
			if (echoing)
  8010cd:	85 ff                	test   %edi,%edi
  8010cf:	74 0c                	je     8010dd <readline+0xb2>
				cputchar(c);
  8010d1:	83 ec 0c             	sub    $0xc,%esp
  8010d4:	53                   	push   %ebx
  8010d5:	e8 0e f8 ff ff       	call   8008e8 <cputchar>
  8010da:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8010dd:	88 9e 20 50 80 00    	mov    %bl,0x805020(%esi)
  8010e3:	8d 76 01             	lea    0x1(%esi),%esi
  8010e6:	e9 77 ff ff ff       	jmp    801062 <readline+0x37>
		} else if (c == '\n' || c == '\r') {
  8010eb:	83 fb 0a             	cmp    $0xa,%ebx
  8010ee:	74 09                	je     8010f9 <readline+0xce>
  8010f0:	83 fb 0d             	cmp    $0xd,%ebx
  8010f3:	0f 85 69 ff ff ff    	jne    801062 <readline+0x37>
			if (echoing)
  8010f9:	85 ff                	test   %edi,%edi
  8010fb:	74 0d                	je     80110a <readline+0xdf>
				cputchar('\n');
  8010fd:	83 ec 0c             	sub    $0xc,%esp
  801100:	6a 0a                	push   $0xa
  801102:	e8 e1 f7 ff ff       	call   8008e8 <cputchar>
  801107:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  80110a:	c6 86 20 50 80 00 00 	movb   $0x0,0x805020(%esi)
			return buf;
  801111:	b8 20 50 80 00       	mov    $0x805020,%eax
		}
	}
}
  801116:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801119:	5b                   	pop    %ebx
  80111a:	5e                   	pop    %esi
  80111b:	5f                   	pop    %edi
  80111c:	5d                   	pop    %ebp
  80111d:	c3                   	ret    

0080111e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801124:	b8 00 00 00 00       	mov    $0x0,%eax
  801129:	eb 03                	jmp    80112e <strlen+0x10>
		n++;
  80112b:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80112e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801132:	75 f7                	jne    80112b <strlen+0xd>
		n++;
	return n;
}
  801134:	5d                   	pop    %ebp
  801135:	c3                   	ret    

00801136 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80113c:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80113f:	ba 00 00 00 00       	mov    $0x0,%edx
  801144:	eb 03                	jmp    801149 <strnlen+0x13>
		n++;
  801146:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801149:	39 c2                	cmp    %eax,%edx
  80114b:	74 08                	je     801155 <strnlen+0x1f>
  80114d:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801151:	75 f3                	jne    801146 <strnlen+0x10>
  801153:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  801155:	5d                   	pop    %ebp
  801156:	c3                   	ret    

00801157 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	53                   	push   %ebx
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801161:	89 c2                	mov    %eax,%edx
  801163:	83 c2 01             	add    $0x1,%edx
  801166:	83 c1 01             	add    $0x1,%ecx
  801169:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80116d:	88 5a ff             	mov    %bl,-0x1(%edx)
  801170:	84 db                	test   %bl,%bl
  801172:	75 ef                	jne    801163 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801174:	5b                   	pop    %ebx
  801175:	5d                   	pop    %ebp
  801176:	c3                   	ret    

00801177 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
  80117a:	53                   	push   %ebx
  80117b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80117e:	53                   	push   %ebx
  80117f:	e8 9a ff ff ff       	call   80111e <strlen>
  801184:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801187:	ff 75 0c             	pushl  0xc(%ebp)
  80118a:	01 d8                	add    %ebx,%eax
  80118c:	50                   	push   %eax
  80118d:	e8 c5 ff ff ff       	call   801157 <strcpy>
	return dst;
}
  801192:	89 d8                	mov    %ebx,%eax
  801194:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801197:	c9                   	leave  
  801198:	c3                   	ret    

00801199 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801199:	55                   	push   %ebp
  80119a:	89 e5                	mov    %esp,%ebp
  80119c:	56                   	push   %esi
  80119d:	53                   	push   %ebx
  80119e:	8b 75 08             	mov    0x8(%ebp),%esi
  8011a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a4:	89 f3                	mov    %esi,%ebx
  8011a6:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011a9:	89 f2                	mov    %esi,%edx
  8011ab:	eb 0f                	jmp    8011bc <strncpy+0x23>
		*dst++ = *src;
  8011ad:	83 c2 01             	add    $0x1,%edx
  8011b0:	0f b6 01             	movzbl (%ecx),%eax
  8011b3:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8011b6:	80 39 01             	cmpb   $0x1,(%ecx)
  8011b9:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011bc:	39 da                	cmp    %ebx,%edx
  8011be:	75 ed                	jne    8011ad <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8011c0:	89 f0                	mov    %esi,%eax
  8011c2:	5b                   	pop    %ebx
  8011c3:	5e                   	pop    %esi
  8011c4:	5d                   	pop    %ebp
  8011c5:	c3                   	ret    

008011c6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011c6:	55                   	push   %ebp
  8011c7:	89 e5                	mov    %esp,%ebp
  8011c9:	56                   	push   %esi
  8011ca:	53                   	push   %ebx
  8011cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8011ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d1:	8b 55 10             	mov    0x10(%ebp),%edx
  8011d4:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8011d6:	85 d2                	test   %edx,%edx
  8011d8:	74 21                	je     8011fb <strlcpy+0x35>
  8011da:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8011de:	89 f2                	mov    %esi,%edx
  8011e0:	eb 09                	jmp    8011eb <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8011e2:	83 c2 01             	add    $0x1,%edx
  8011e5:	83 c1 01             	add    $0x1,%ecx
  8011e8:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011eb:	39 c2                	cmp    %eax,%edx
  8011ed:	74 09                	je     8011f8 <strlcpy+0x32>
  8011ef:	0f b6 19             	movzbl (%ecx),%ebx
  8011f2:	84 db                	test   %bl,%bl
  8011f4:	75 ec                	jne    8011e2 <strlcpy+0x1c>
  8011f6:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  8011f8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011fb:	29 f0                	sub    %esi,%eax
}
  8011fd:	5b                   	pop    %ebx
  8011fe:	5e                   	pop    %esi
  8011ff:	5d                   	pop    %ebp
  801200:	c3                   	ret    

00801201 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801201:	55                   	push   %ebp
  801202:	89 e5                	mov    %esp,%ebp
  801204:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801207:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80120a:	eb 06                	jmp    801212 <strcmp+0x11>
		p++, q++;
  80120c:	83 c1 01             	add    $0x1,%ecx
  80120f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801212:	0f b6 01             	movzbl (%ecx),%eax
  801215:	84 c0                	test   %al,%al
  801217:	74 04                	je     80121d <strcmp+0x1c>
  801219:	3a 02                	cmp    (%edx),%al
  80121b:	74 ef                	je     80120c <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80121d:	0f b6 c0             	movzbl %al,%eax
  801220:	0f b6 12             	movzbl (%edx),%edx
  801223:	29 d0                	sub    %edx,%eax
}
  801225:	5d                   	pop    %ebp
  801226:	c3                   	ret    

00801227 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
  80122a:	53                   	push   %ebx
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801231:	89 c3                	mov    %eax,%ebx
  801233:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801236:	eb 06                	jmp    80123e <strncmp+0x17>
		n--, p++, q++;
  801238:	83 c0 01             	add    $0x1,%eax
  80123b:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80123e:	39 d8                	cmp    %ebx,%eax
  801240:	74 15                	je     801257 <strncmp+0x30>
  801242:	0f b6 08             	movzbl (%eax),%ecx
  801245:	84 c9                	test   %cl,%cl
  801247:	74 04                	je     80124d <strncmp+0x26>
  801249:	3a 0a                	cmp    (%edx),%cl
  80124b:	74 eb                	je     801238 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80124d:	0f b6 00             	movzbl (%eax),%eax
  801250:	0f b6 12             	movzbl (%edx),%edx
  801253:	29 d0                	sub    %edx,%eax
  801255:	eb 05                	jmp    80125c <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801257:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  80125c:	5b                   	pop    %ebx
  80125d:	5d                   	pop    %ebp
  80125e:	c3                   	ret    

0080125f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801269:	eb 07                	jmp    801272 <strchr+0x13>
		if (*s == c)
  80126b:	38 ca                	cmp    %cl,%dl
  80126d:	74 0f                	je     80127e <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80126f:	83 c0 01             	add    $0x1,%eax
  801272:	0f b6 10             	movzbl (%eax),%edx
  801275:	84 d2                	test   %dl,%dl
  801277:	75 f2                	jne    80126b <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  801279:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80127e:	5d                   	pop    %ebp
  80127f:	c3                   	ret    

00801280 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80128a:	eb 03                	jmp    80128f <strfind+0xf>
  80128c:	83 c0 01             	add    $0x1,%eax
  80128f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801292:	38 ca                	cmp    %cl,%dl
  801294:	74 04                	je     80129a <strfind+0x1a>
  801296:	84 d2                	test   %dl,%dl
  801298:	75 f2                	jne    80128c <strfind+0xc>
			break;
	return (char *) s;
}
  80129a:	5d                   	pop    %ebp
  80129b:	c3                   	ret    

0080129c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	57                   	push   %edi
  8012a0:	56                   	push   %esi
  8012a1:	53                   	push   %ebx
  8012a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  8012a8:	85 c9                	test   %ecx,%ecx
  8012aa:	74 37                	je     8012e3 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8012ac:	f6 c2 03             	test   $0x3,%dl
  8012af:	75 2a                	jne    8012db <memset+0x3f>
  8012b1:	f6 c1 03             	test   $0x3,%cl
  8012b4:	75 25                	jne    8012db <memset+0x3f>
		c &= 0xFF;
  8012b6:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8012ba:	89 df                	mov    %ebx,%edi
  8012bc:	c1 e7 08             	shl    $0x8,%edi
  8012bf:	89 de                	mov    %ebx,%esi
  8012c1:	c1 e6 18             	shl    $0x18,%esi
  8012c4:	89 d8                	mov    %ebx,%eax
  8012c6:	c1 e0 10             	shl    $0x10,%eax
  8012c9:	09 f0                	or     %esi,%eax
  8012cb:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8012cd:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8012d0:	89 f8                	mov    %edi,%eax
  8012d2:	09 d8                	or     %ebx,%eax
  8012d4:	89 d7                	mov    %edx,%edi
  8012d6:	fc                   	cld    
  8012d7:	f3 ab                	rep stos %eax,%es:(%edi)
  8012d9:	eb 08                	jmp    8012e3 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8012db:	89 d7                	mov    %edx,%edi
  8012dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e0:	fc                   	cld    
  8012e1:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8012e3:	89 d0                	mov    %edx,%eax
  8012e5:	5b                   	pop    %ebx
  8012e6:	5e                   	pop    %esi
  8012e7:	5f                   	pop    %edi
  8012e8:	5d                   	pop    %ebp
  8012e9:	c3                   	ret    

008012ea <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	57                   	push   %edi
  8012ee:	56                   	push   %esi
  8012ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012f8:	39 c6                	cmp    %eax,%esi
  8012fa:	73 35                	jae    801331 <memmove+0x47>
  8012fc:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8012ff:	39 d0                	cmp    %edx,%eax
  801301:	73 2e                	jae    801331 <memmove+0x47>
		s += n;
		d += n;
  801303:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801306:	89 d6                	mov    %edx,%esi
  801308:	09 fe                	or     %edi,%esi
  80130a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801310:	75 13                	jne    801325 <memmove+0x3b>
  801312:	f6 c1 03             	test   $0x3,%cl
  801315:	75 0e                	jne    801325 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  801317:	83 ef 04             	sub    $0x4,%edi
  80131a:	8d 72 fc             	lea    -0x4(%edx),%esi
  80131d:	c1 e9 02             	shr    $0x2,%ecx
  801320:	fd                   	std    
  801321:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801323:	eb 09                	jmp    80132e <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801325:	83 ef 01             	sub    $0x1,%edi
  801328:	8d 72 ff             	lea    -0x1(%edx),%esi
  80132b:	fd                   	std    
  80132c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80132e:	fc                   	cld    
  80132f:	eb 1d                	jmp    80134e <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801331:	89 f2                	mov    %esi,%edx
  801333:	09 c2                	or     %eax,%edx
  801335:	f6 c2 03             	test   $0x3,%dl
  801338:	75 0f                	jne    801349 <memmove+0x5f>
  80133a:	f6 c1 03             	test   $0x3,%cl
  80133d:	75 0a                	jne    801349 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  80133f:	c1 e9 02             	shr    $0x2,%ecx
  801342:	89 c7                	mov    %eax,%edi
  801344:	fc                   	cld    
  801345:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801347:	eb 05                	jmp    80134e <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801349:	89 c7                	mov    %eax,%edi
  80134b:	fc                   	cld    
  80134c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80134e:	5e                   	pop    %esi
  80134f:	5f                   	pop    %edi
  801350:	5d                   	pop    %ebp
  801351:	c3                   	ret    

00801352 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801352:	55                   	push   %ebp
  801353:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801355:	ff 75 10             	pushl  0x10(%ebp)
  801358:	ff 75 0c             	pushl  0xc(%ebp)
  80135b:	ff 75 08             	pushl  0x8(%ebp)
  80135e:	e8 87 ff ff ff       	call   8012ea <memmove>
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	56                   	push   %esi
  801369:	53                   	push   %ebx
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801370:	89 c6                	mov    %eax,%esi
  801372:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801375:	eb 1a                	jmp    801391 <memcmp+0x2c>
		if (*s1 != *s2)
  801377:	0f b6 08             	movzbl (%eax),%ecx
  80137a:	0f b6 1a             	movzbl (%edx),%ebx
  80137d:	38 d9                	cmp    %bl,%cl
  80137f:	74 0a                	je     80138b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  801381:	0f b6 c1             	movzbl %cl,%eax
  801384:	0f b6 db             	movzbl %bl,%ebx
  801387:	29 d8                	sub    %ebx,%eax
  801389:	eb 0f                	jmp    80139a <memcmp+0x35>
		s1++, s2++;
  80138b:	83 c0 01             	add    $0x1,%eax
  80138e:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801391:	39 f0                	cmp    %esi,%eax
  801393:	75 e2                	jne    801377 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801395:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80139a:	5b                   	pop    %ebx
  80139b:	5e                   	pop    %esi
  80139c:	5d                   	pop    %ebp
  80139d:	c3                   	ret    

0080139e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
  8013a1:	53                   	push   %ebx
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  8013a5:	89 c1                	mov    %eax,%ecx
  8013a7:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  8013aa:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013ae:	eb 0a                	jmp    8013ba <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013b0:	0f b6 10             	movzbl (%eax),%edx
  8013b3:	39 da                	cmp    %ebx,%edx
  8013b5:	74 07                	je     8013be <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013b7:	83 c0 01             	add    $0x1,%eax
  8013ba:	39 c8                	cmp    %ecx,%eax
  8013bc:	72 f2                	jb     8013b0 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8013be:	5b                   	pop    %ebx
  8013bf:	5d                   	pop    %ebp
  8013c0:	c3                   	ret    

008013c1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
  8013c4:	57                   	push   %edi
  8013c5:	56                   	push   %esi
  8013c6:	53                   	push   %ebx
  8013c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013cd:	eb 03                	jmp    8013d2 <strtol+0x11>
		s++;
  8013cf:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013d2:	0f b6 01             	movzbl (%ecx),%eax
  8013d5:	3c 20                	cmp    $0x20,%al
  8013d7:	74 f6                	je     8013cf <strtol+0xe>
  8013d9:	3c 09                	cmp    $0x9,%al
  8013db:	74 f2                	je     8013cf <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013dd:	3c 2b                	cmp    $0x2b,%al
  8013df:	75 0a                	jne    8013eb <strtol+0x2a>
		s++;
  8013e1:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8013e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8013e9:	eb 11                	jmp    8013fc <strtol+0x3b>
  8013eb:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8013f0:	3c 2d                	cmp    $0x2d,%al
  8013f2:	75 08                	jne    8013fc <strtol+0x3b>
		s++, neg = 1;
  8013f4:	83 c1 01             	add    $0x1,%ecx
  8013f7:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013fc:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801402:	75 15                	jne    801419 <strtol+0x58>
  801404:	80 39 30             	cmpb   $0x30,(%ecx)
  801407:	75 10                	jne    801419 <strtol+0x58>
  801409:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80140d:	75 7c                	jne    80148b <strtol+0xca>
		s += 2, base = 16;
  80140f:	83 c1 02             	add    $0x2,%ecx
  801412:	bb 10 00 00 00       	mov    $0x10,%ebx
  801417:	eb 16                	jmp    80142f <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  801419:	85 db                	test   %ebx,%ebx
  80141b:	75 12                	jne    80142f <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80141d:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801422:	80 39 30             	cmpb   $0x30,(%ecx)
  801425:	75 08                	jne    80142f <strtol+0x6e>
		s++, base = 8;
  801427:	83 c1 01             	add    $0x1,%ecx
  80142a:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  80142f:	b8 00 00 00 00       	mov    $0x0,%eax
  801434:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801437:	0f b6 11             	movzbl (%ecx),%edx
  80143a:	8d 72 d0             	lea    -0x30(%edx),%esi
  80143d:	89 f3                	mov    %esi,%ebx
  80143f:	80 fb 09             	cmp    $0x9,%bl
  801442:	77 08                	ja     80144c <strtol+0x8b>
			dig = *s - '0';
  801444:	0f be d2             	movsbl %dl,%edx
  801447:	83 ea 30             	sub    $0x30,%edx
  80144a:	eb 22                	jmp    80146e <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  80144c:	8d 72 9f             	lea    -0x61(%edx),%esi
  80144f:	89 f3                	mov    %esi,%ebx
  801451:	80 fb 19             	cmp    $0x19,%bl
  801454:	77 08                	ja     80145e <strtol+0x9d>
			dig = *s - 'a' + 10;
  801456:	0f be d2             	movsbl %dl,%edx
  801459:	83 ea 57             	sub    $0x57,%edx
  80145c:	eb 10                	jmp    80146e <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  80145e:	8d 72 bf             	lea    -0x41(%edx),%esi
  801461:	89 f3                	mov    %esi,%ebx
  801463:	80 fb 19             	cmp    $0x19,%bl
  801466:	77 16                	ja     80147e <strtol+0xbd>
			dig = *s - 'A' + 10;
  801468:	0f be d2             	movsbl %dl,%edx
  80146b:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  80146e:	3b 55 10             	cmp    0x10(%ebp),%edx
  801471:	7d 0b                	jge    80147e <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  801473:	83 c1 01             	add    $0x1,%ecx
  801476:	0f af 45 10          	imul   0x10(%ebp),%eax
  80147a:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  80147c:	eb b9                	jmp    801437 <strtol+0x76>

	if (endptr)
  80147e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801482:	74 0d                	je     801491 <strtol+0xd0>
		*endptr = (char *) s;
  801484:	8b 75 0c             	mov    0xc(%ebp),%esi
  801487:	89 0e                	mov    %ecx,(%esi)
  801489:	eb 06                	jmp    801491 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  80148b:	85 db                	test   %ebx,%ebx
  80148d:	74 98                	je     801427 <strtol+0x66>
  80148f:	eb 9e                	jmp    80142f <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  801491:	89 c2                	mov    %eax,%edx
  801493:	f7 da                	neg    %edx
  801495:	85 ff                	test   %edi,%edi
  801497:	0f 45 c2             	cmovne %edx,%eax
}
  80149a:	5b                   	pop    %ebx
  80149b:	5e                   	pop    %esi
  80149c:	5f                   	pop    %edi
  80149d:	5d                   	pop    %ebp
  80149e:	c3                   	ret    

0080149f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
  8014a2:	57                   	push   %edi
  8014a3:	56                   	push   %esi
  8014a4:	53                   	push   %ebx
  8014a5:	83 ec 1c             	sub    $0x1c,%esp
  8014a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8014ab:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8014ae:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8014b6:	8b 7d 10             	mov    0x10(%ebp),%edi
  8014b9:	8b 75 14             	mov    0x14(%ebp),%esi
  8014bc:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8014be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014c2:	74 1d                	je     8014e1 <syscall+0x42>
  8014c4:	85 c0                	test   %eax,%eax
  8014c6:	7e 19                	jle    8014e1 <syscall+0x42>
  8014c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  8014cb:	83 ec 0c             	sub    $0xc,%esp
  8014ce:	50                   	push   %eax
  8014cf:	52                   	push   %edx
  8014d0:	68 4f 39 80 00       	push   $0x80394f
  8014d5:	6a 23                	push   $0x23
  8014d7:	68 6c 39 80 00       	push   $0x80396c
  8014dc:	e8 38 f5 ff ff       	call   800a19 <_panic>

	return ret;
}
  8014e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014e4:	5b                   	pop    %ebx
  8014e5:	5e                   	pop    %esi
  8014e6:	5f                   	pop    %edi
  8014e7:	5d                   	pop    %ebp
  8014e8:	c3                   	ret    

008014e9 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
  8014ec:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	ff 75 0c             	pushl  0xc(%ebp)
  8014f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801500:	b8 00 00 00 00       	mov    $0x0,%eax
  801505:	e8 95 ff ff ff       	call   80149f <syscall>
}
  80150a:	83 c4 10             	add    $0x10,%esp
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    

0080150f <sys_cgetc>:

int
sys_cgetc(void)
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
  801512:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801522:	ba 00 00 00 00       	mov    $0x0,%edx
  801527:	b8 01 00 00 00       	mov    $0x1,%eax
  80152c:	e8 6e ff ff ff       	call   80149f <syscall>
}
  801531:	c9                   	leave  
  801532:	c3                   	ret    

00801533 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
  801536:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801544:	ba 01 00 00 00       	mov    $0x1,%edx
  801549:	b8 03 00 00 00       	mov    $0x3,%eax
  80154e:	e8 4c ff ff ff       	call   80149f <syscall>
}
  801553:	c9                   	leave  
  801554:	c3                   	ret    

00801555 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
  801558:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	b9 00 00 00 00       	mov    $0x0,%ecx
  801568:	ba 00 00 00 00       	mov    $0x0,%edx
  80156d:	b8 02 00 00 00       	mov    $0x2,%eax
  801572:	e8 28 ff ff ff       	call   80149f <syscall>
}
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <sys_yield>:

void
sys_yield(void)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	b9 00 00 00 00       	mov    $0x0,%ecx
  80158c:	ba 00 00 00 00       	mov    $0x0,%edx
  801591:	b8 0b 00 00 00       	mov    $0xb,%eax
  801596:	e8 04 ff ff ff       	call   80149f <syscall>
}
  80159b:	83 c4 10             	add    $0x10,%esp
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	ff 75 10             	pushl  0x10(%ebp)
  8015ad:	ff 75 0c             	pushl  0xc(%ebp)
  8015b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015b3:	ba 01 00 00 00       	mov    $0x1,%edx
  8015b8:	b8 04 00 00 00       	mov    $0x4,%eax
  8015bd:	e8 dd fe ff ff       	call   80149f <syscall>
}
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8015ca:	ff 75 18             	pushl  0x18(%ebp)
  8015cd:	ff 75 14             	pushl  0x14(%ebp)
  8015d0:	ff 75 10             	pushl  0x10(%ebp)
  8015d3:	ff 75 0c             	pushl  0xc(%ebp)
  8015d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015d9:	ba 01 00 00 00       	mov    $0x1,%edx
  8015de:	b8 05 00 00 00       	mov    $0x5,%eax
  8015e3:	e8 b7 fe ff ff       	call   80149f <syscall>
}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
  8015ed:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	ff 75 0c             	pushl  0xc(%ebp)
  8015f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015fc:	ba 01 00 00 00       	mov    $0x1,%edx
  801601:	b8 06 00 00 00       	mov    $0x6,%eax
  801606:	e8 94 fe ff ff       	call   80149f <syscall>
}
  80160b:	c9                   	leave  
  80160c:	c3                   	ret    

0080160d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
  801610:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	ff 75 0c             	pushl  0xc(%ebp)
  80161c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80161f:	ba 01 00 00 00       	mov    $0x1,%edx
  801624:	b8 08 00 00 00       	mov    $0x8,%eax
  801629:	e8 71 fe ff ff       	call   80149f <syscall>
}
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    

00801630 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	ff 75 0c             	pushl  0xc(%ebp)
  80163f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801642:	ba 01 00 00 00       	mov    $0x1,%edx
  801647:	b8 09 00 00 00       	mov    $0x9,%eax
  80164c:	e8 4e fe ff ff       	call   80149f <syscall>
}
  801651:	c9                   	leave  
  801652:	c3                   	ret    

00801653 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	ff 75 0c             	pushl  0xc(%ebp)
  801662:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801665:	ba 01 00 00 00       	mov    $0x1,%edx
  80166a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80166f:	e8 2b fe ff ff       	call   80149f <syscall>
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  80167c:	6a 00                	push   $0x0
  80167e:	ff 75 14             	pushl  0x14(%ebp)
  801681:	ff 75 10             	pushl  0x10(%ebp)
  801684:	ff 75 0c             	pushl  0xc(%ebp)
  801687:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80168a:	ba 00 00 00 00       	mov    $0x0,%edx
  80168f:	b8 0c 00 00 00       	mov    $0xc,%eax
  801694:	e8 06 fe ff ff       	call   80149f <syscall>
}
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
  80169e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016ac:	ba 01 00 00 00       	mov    $0x1,%edx
  8016b1:	b8 0d 00 00 00       	mov    $0xd,%eax
  8016b6:	e8 e4 fd ff ff       	call   80149f <syscall>
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	53                   	push   %ebx
  8016c1:	83 ec 04             	sub    $0x4,%esp

	int perm_w = PTE_COW|PTE_U|PTE_P;
	int perm = PTE_U|PTE_P;

	// LAB 4: Your code here.
	void *addr = (void*) (pn*PGSIZE);
  8016c4:	89 d3                	mov    %edx,%ebx
  8016c6:	c1 e3 0c             	shl    $0xc,%ebx

	//Si una página tiene el bit PTE_SHARE, se comparte con el hijo con los mismos permisos.
  	if (uvpt[pn] & PTE_SHARE) {
  8016c9:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8016d0:	f6 c5 04             	test   $0x4,%ch
  8016d3:	74 3a                	je     80170f <duppage+0x52>
    	if (sys_page_map(0, addr, envid,addr, uvpt[pn] & PTE_SYSCALL) < 0) {
  8016d5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016dc:	83 ec 0c             	sub    $0xc,%esp
  8016df:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8016e5:	52                   	push   %edx
  8016e6:	53                   	push   %ebx
  8016e7:	50                   	push   %eax
  8016e8:	53                   	push   %ebx
  8016e9:	6a 00                	push   $0x0
  8016eb:	e8 d4 fe ff ff       	call   8015c4 <sys_page_map>
  8016f0:	83 c4 20             	add    $0x20,%esp
  8016f3:	85 c0                	test   %eax,%eax
  8016f5:	0f 89 99 00 00 00    	jns    801794 <duppage+0xd7>
 	     	panic("Error en sys_page_map");
  8016fb:	83 ec 04             	sub    $0x4,%esp
  8016fe:	68 7a 39 80 00       	push   $0x80397a
  801703:	6a 50                	push   $0x50
  801705:	68 90 39 80 00       	push   $0x803990
  80170a:	e8 0a f3 ff ff       	call   800a19 <_panic>
    	} 
    	return 0;
	}

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  80170f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801716:	f6 c1 02             	test   $0x2,%cl
  801719:	75 0c                	jne    801727 <duppage+0x6a>
  80171b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801722:	f6 c6 08             	test   $0x8,%dh
  801725:	74 5b                	je     801782 <duppage+0xc5>
		if (sys_page_map(0, addr, envid, addr, perm_w) < 0){
  801727:	83 ec 0c             	sub    $0xc,%esp
  80172a:	68 05 08 00 00       	push   $0x805
  80172f:	53                   	push   %ebx
  801730:	50                   	push   %eax
  801731:	53                   	push   %ebx
  801732:	6a 00                	push   $0x0
  801734:	e8 8b fe ff ff       	call   8015c4 <sys_page_map>
  801739:	83 c4 20             	add    $0x20,%esp
  80173c:	85 c0                	test   %eax,%eax
  80173e:	79 14                	jns    801754 <duppage+0x97>
			panic("Error mapeando pagina Padre");
  801740:	83 ec 04             	sub    $0x4,%esp
  801743:	68 9b 39 80 00       	push   $0x80399b
  801748:	6a 57                	push   $0x57
  80174a:	68 90 39 80 00       	push   $0x803990
  80174f:	e8 c5 f2 ff ff       	call   800a19 <_panic>
		}
		if (sys_page_map(0, addr, 0, addr, perm_w) < 0){
  801754:	83 ec 0c             	sub    $0xc,%esp
  801757:	68 05 08 00 00       	push   $0x805
  80175c:	53                   	push   %ebx
  80175d:	6a 00                	push   $0x0
  80175f:	53                   	push   %ebx
  801760:	6a 00                	push   $0x0
  801762:	e8 5d fe ff ff       	call   8015c4 <sys_page_map>
  801767:	83 c4 20             	add    $0x20,%esp
  80176a:	85 c0                	test   %eax,%eax
  80176c:	79 26                	jns    801794 <duppage+0xd7>
			panic("Error mapeando pagina Hijo");
  80176e:	83 ec 04             	sub    $0x4,%esp
  801771:	68 b7 39 80 00       	push   $0x8039b7
  801776:	6a 5a                	push   $0x5a
  801778:	68 90 39 80 00       	push   $0x803990
  80177d:	e8 97 f2 ff ff       	call   800a19 <_panic>
		}
	} else sys_page_map(0, addr, envid, addr, perm);
  801782:	83 ec 0c             	sub    $0xc,%esp
  801785:	6a 05                	push   $0x5
  801787:	53                   	push   %ebx
  801788:	50                   	push   %eax
  801789:	53                   	push   %ebx
  80178a:	6a 00                	push   $0x0
  80178c:	e8 33 fe ff ff       	call   8015c4 <sys_page_map>
  801791:	83 c4 20             	add    $0x20,%esp
	
	return 0;
}
  801794:	b8 00 00 00 00       	mov    $0x0,%eax
  801799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    

0080179e <dup_or_share>:
//FORK V0

static void
dup_or_share(envid_t dstenv, void *va, int perm){
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
  8017a1:	57                   	push   %edi
  8017a2:	56                   	push   %esi
  8017a3:	53                   	push   %ebx
  8017a4:	83 ec 0c             	sub    $0xc,%esp
  8017a7:	89 c7                	mov    %eax,%edi
  8017a9:	89 d6                	mov    %edx,%esi
  8017ab:	89 cb                	mov    %ecx,%ebx
	int result;
	// Si no es de escritura, comparto la pagina
	if((perm &PTE_W) != PTE_W){
  8017ad:	f6 c1 02             	test   $0x2,%cl
  8017b0:	75 2d                	jne    8017df <dup_or_share+0x41>
		if((result = sys_page_map(0, va, dstenv, va, perm))<0){
  8017b2:	83 ec 0c             	sub    $0xc,%esp
  8017b5:	51                   	push   %ecx
  8017b6:	52                   	push   %edx
  8017b7:	50                   	push   %eax
  8017b8:	52                   	push   %edx
  8017b9:	6a 00                	push   $0x0
  8017bb:	e8 04 fe ff ff       	call   8015c4 <sys_page_map>
  8017c0:	83 c4 20             	add    $0x20,%esp
  8017c3:	85 c0                	test   %eax,%eax
  8017c5:	0f 89 a4 00 00 00    	jns    80186f <dup_or_share+0xd1>
			panic("Error compartiendo la pagina");
  8017cb:	83 ec 04             	sub    $0x4,%esp
  8017ce:	68 d2 39 80 00       	push   $0x8039d2
  8017d3:	6a 68                	push   $0x68
  8017d5:	68 90 39 80 00       	push   $0x803990
  8017da:	e8 3a f2 ff ff       	call   800a19 <_panic>
		}
	// Si es de escritura comportamiento de duppage, en dumbfork
	}else{
		if ((result = sys_page_alloc(dstenv, va, perm)) < 0){
  8017df:	83 ec 04             	sub    $0x4,%esp
  8017e2:	51                   	push   %ecx
  8017e3:	52                   	push   %edx
  8017e4:	50                   	push   %eax
  8017e5:	e8 b6 fd ff ff       	call   8015a0 <sys_page_alloc>
  8017ea:	83 c4 10             	add    $0x10,%esp
  8017ed:	85 c0                	test   %eax,%eax
  8017ef:	79 14                	jns    801805 <dup_or_share+0x67>
			panic("Error copiando la pagina");
  8017f1:	83 ec 04             	sub    $0x4,%esp
  8017f4:	68 ef 39 80 00       	push   $0x8039ef
  8017f9:	6a 6d                	push   $0x6d
  8017fb:	68 90 39 80 00       	push   $0x803990
  801800:	e8 14 f2 ff ff       	call   800a19 <_panic>
		}
		if ((result = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0){
  801805:	83 ec 0c             	sub    $0xc,%esp
  801808:	53                   	push   %ebx
  801809:	68 00 00 40 00       	push   $0x400000
  80180e:	6a 00                	push   $0x0
  801810:	56                   	push   %esi
  801811:	57                   	push   %edi
  801812:	e8 ad fd ff ff       	call   8015c4 <sys_page_map>
  801817:	83 c4 20             	add    $0x20,%esp
  80181a:	85 c0                	test   %eax,%eax
  80181c:	79 14                	jns    801832 <dup_or_share+0x94>
			panic("Error copiando la pagina");
  80181e:	83 ec 04             	sub    $0x4,%esp
  801821:	68 ef 39 80 00       	push   $0x8039ef
  801826:	6a 70                	push   $0x70
  801828:	68 90 39 80 00       	push   $0x803990
  80182d:	e8 e7 f1 ff ff       	call   800a19 <_panic>
		}
		memmove(UTEMP, va, PGSIZE);
  801832:	83 ec 04             	sub    $0x4,%esp
  801835:	68 00 10 00 00       	push   $0x1000
  80183a:	56                   	push   %esi
  80183b:	68 00 00 40 00       	push   $0x400000
  801840:	e8 a5 fa ff ff       	call   8012ea <memmove>
		if ((result = sys_page_unmap(0, UTEMP)) < 0){
  801845:	83 c4 08             	add    $0x8,%esp
  801848:	68 00 00 40 00       	push   $0x400000
  80184d:	6a 00                	push   $0x0
  80184f:	e8 96 fd ff ff       	call   8015ea <sys_page_unmap>
  801854:	83 c4 10             	add    $0x10,%esp
  801857:	85 c0                	test   %eax,%eax
  801859:	79 14                	jns    80186f <dup_or_share+0xd1>
			panic("Error copiando la pagina");
  80185b:	83 ec 04             	sub    $0x4,%esp
  80185e:	68 ef 39 80 00       	push   $0x8039ef
  801863:	6a 74                	push   $0x74
  801865:	68 90 39 80 00       	push   $0x803990
  80186a:	e8 aa f1 ff ff       	call   800a19 <_panic>
		}
	}	
}
  80186f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801872:	5b                   	pop    %ebx
  801873:	5e                   	pop    %esi
  801874:	5f                   	pop    %edi
  801875:	5d                   	pop    %ebp
  801876:	c3                   	ret    

00801877 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	53                   	push   %ebx
  80187b:	83 ec 04             	sub    $0x4,%esp
  80187e:	8b 55 08             	mov    0x8(%ebp),%edx
	void *va = (void *) utf->utf_fault_va;
  801881:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  801883:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801887:	74 2e                	je     8018b7 <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
  801889:	89 c2                	mov    %eax,%edx
  80188b:	c1 ea 16             	shr    $0x16,%edx
  80188e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  801895:	f6 c2 01             	test   $0x1,%dl
  801898:	74 1d                	je     8018b7 <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
  80189a:	89 c2                	mov    %eax,%edx
  80189c:	c1 ea 0c             	shr    $0xc,%edx
  80189f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
		(uvpd[PDX(va)] & PTE_P) && 
  8018a6:	f6 c1 01             	test   $0x1,%cl
  8018a9:	74 0c                	je     8018b7 <pgfault+0x40>
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
  8018ab:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  8018b2:	f6 c6 08             	test   $0x8,%dh
  8018b5:	75 14                	jne    8018cb <pgfault+0x54>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
		panic("No es copy-on-write");
  8018b7:	83 ec 04             	sub    $0x4,%esp
  8018ba:	68 08 3a 80 00       	push   $0x803a08
  8018bf:	6a 21                	push   $0x21
  8018c1:	68 90 39 80 00       	push   $0x803990
  8018c6:	e8 4e f1 ff ff       	call   800a19 <_panic>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	va = ROUNDDOWN(va, PGSIZE);
  8018cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018d0:	89 c3                	mov    %eax,%ebx
	if (sys_page_alloc(0, PFTEMP, perm) < 0){
  8018d2:	83 ec 04             	sub    $0x4,%esp
  8018d5:	6a 07                	push   $0x7
  8018d7:	68 00 f0 7f 00       	push   $0x7ff000
  8018dc:	6a 00                	push   $0x0
  8018de:	e8 bd fc ff ff       	call   8015a0 <sys_page_alloc>
  8018e3:	83 c4 10             	add    $0x10,%esp
  8018e6:	85 c0                	test   %eax,%eax
  8018e8:	79 14                	jns    8018fe <pgfault+0x87>
		panic("Error sys_page_alloc");
  8018ea:	83 ec 04             	sub    $0x4,%esp
  8018ed:	68 1c 3a 80 00       	push   $0x803a1c
  8018f2:	6a 2a                	push   $0x2a
  8018f4:	68 90 39 80 00       	push   $0x803990
  8018f9:	e8 1b f1 ff ff       	call   800a19 <_panic>
	}
	memcpy(PFTEMP, va, PGSIZE);
  8018fe:	83 ec 04             	sub    $0x4,%esp
  801901:	68 00 10 00 00       	push   $0x1000
  801906:	53                   	push   %ebx
  801907:	68 00 f0 7f 00       	push   $0x7ff000
  80190c:	e8 41 fa ff ff       	call   801352 <memcpy>
	if (sys_page_map(0, PFTEMP, 0, va, perm) < 0){
  801911:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801918:	53                   	push   %ebx
  801919:	6a 00                	push   $0x0
  80191b:	68 00 f0 7f 00       	push   $0x7ff000
  801920:	6a 00                	push   $0x0
  801922:	e8 9d fc ff ff       	call   8015c4 <sys_page_map>
  801927:	83 c4 20             	add    $0x20,%esp
  80192a:	85 c0                	test   %eax,%eax
  80192c:	79 14                	jns    801942 <pgfault+0xcb>
		panic("Error sys_page_map");
  80192e:	83 ec 04             	sub    $0x4,%esp
  801931:	68 31 3a 80 00       	push   $0x803a31
  801936:	6a 2e                	push   $0x2e
  801938:	68 90 39 80 00       	push   $0x803990
  80193d:	e8 d7 f0 ff ff       	call   800a19 <_panic>
	}
	if (sys_page_unmap(0, PFTEMP) < 0){
  801942:	83 ec 08             	sub    $0x8,%esp
  801945:	68 00 f0 7f 00       	push   $0x7ff000
  80194a:	6a 00                	push   $0x0
  80194c:	e8 99 fc ff ff       	call   8015ea <sys_page_unmap>
  801951:	83 c4 10             	add    $0x10,%esp
  801954:	85 c0                	test   %eax,%eax
  801956:	79 14                	jns    80196c <pgfault+0xf5>
		panic("Error sys_page_unmap");
  801958:	83 ec 04             	sub    $0x4,%esp
  80195b:	68 44 3a 80 00       	push   $0x803a44
  801960:	6a 31                	push   $0x31
  801962:	68 90 39 80 00       	push   $0x803990
  801967:	e8 ad f0 ff ff       	call   800a19 <_panic>
	}
	return;

}
  80196c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <fork_v0>:
		}
	}	
}

envid_t
fork_v0(void){
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
  801974:	57                   	push   %edi
  801975:	56                   	push   %esi
  801976:	53                   	push   %ebx
  801977:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80197a:	b8 07 00 00 00       	mov    $0x7,%eax
  80197f:	cd 30                	int    $0x30
  801981:	89 c6                	mov    %eax,%esi
	envid_t envid;
	uint8_t *va;
	int result;	

	envid = sys_exofork();
	if (envid < 0)
  801983:	85 c0                	test   %eax,%eax
  801985:	79 15                	jns    80199c <fork_v0+0x2b>
		panic("sys_exofork: %e", envid);
  801987:	50                   	push   %eax
  801988:	68 59 3a 80 00       	push   $0x803a59
  80198d:	68 81 00 00 00       	push   $0x81
  801992:	68 90 39 80 00       	push   $0x803990
  801997:	e8 7d f0 ff ff       	call   800a19 <_panic>
  80199c:	89 c7                	mov    %eax,%edi
  80199e:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {		
  8019a3:	85 c0                	test   %eax,%eax
  8019a5:	75 1e                	jne    8019c5 <fork_v0+0x54>
		thisenv = &envs[ENVX(sys_getenvid())];
  8019a7:	e8 a9 fb ff ff       	call   801555 <sys_getenvid>
  8019ac:	25 ff 03 00 00       	and    $0x3ff,%eax
  8019b1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8019b4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8019b9:	a3 24 54 80 00       	mov    %eax,0x805424
		return 0;
  8019be:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c3:	eb 7a                	jmp    801a3f <fork_v0+0xce>
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  8019c5:	89 d8                	mov    %ebx,%eax
  8019c7:	c1 e8 16             	shr    $0x16,%eax
  8019ca:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019d1:	a8 01                	test   $0x1,%al
  8019d3:	74 33                	je     801a08 <fork_v0+0x97>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  8019d5:	89 d8                	mov    %ebx,%eax
  8019d7:	c1 e8 0c             	shr    $0xc,%eax
  8019da:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019e1:	f6 c2 01             	test   $0x1,%dl
  8019e4:	74 22                	je     801a08 <fork_v0+0x97>
  8019e6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019ed:	f6 c2 04             	test   $0x4,%dl
  8019f0:	74 16                	je     801a08 <fork_v0+0x97>
				pte_t pte =uvpt[PGNUM(va)];
  8019f2:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
  8019f9:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8019ff:	89 da                	mov    %ebx,%edx
  801a01:	89 f8                	mov    %edi,%eax
  801a03:	e8 96 fd ff ff       	call   80179e <dup_or_share>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
  801a08:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a0e:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801a14:	75 af                	jne    8019c5 <fork_v0+0x54>
				pte_t pte =uvpt[PGNUM(va)];
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
			}
		}
	}	
	if ((result = sys_env_set_status(envid, ENV_RUNNABLE)) < 0){
  801a16:	83 ec 08             	sub    $0x8,%esp
  801a19:	6a 02                	push   $0x2
  801a1b:	56                   	push   %esi
  801a1c:	e8 ec fb ff ff       	call   80160d <sys_env_set_status>
  801a21:	83 c4 10             	add    $0x10,%esp
  801a24:	85 c0                	test   %eax,%eax
  801a26:	79 15                	jns    801a3d <fork_v0+0xcc>

		panic("sys_env_set_status: %e", result);
  801a28:	50                   	push   %eax
  801a29:	68 69 3a 80 00       	push   $0x803a69
  801a2e:	68 90 00 00 00       	push   $0x90
  801a33:	68 90 39 80 00       	push   $0x803990
  801a38:	e8 dc ef ff ff       	call   800a19 <_panic>
	}
	return envid;
  801a3d:	89 f0                	mov    %esi,%eax
}
  801a3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a42:	5b                   	pop    %ebx
  801a43:	5e                   	pop    %esi
  801a44:	5f                   	pop    %edi
  801a45:	5d                   	pop    %ebp
  801a46:	c3                   	ret    

00801a47 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	57                   	push   %edi
  801a4b:	56                   	push   %esi
  801a4c:	53                   	push   %ebx
  801a4d:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801a50:	68 77 18 80 00       	push   $0x801877
  801a55:	e8 3d 15 00 00       	call   802f97 <set_pgfault_handler>
  801a5a:	b8 07 00 00 00       	mov    $0x7,%eax
  801a5f:	cd 30                	int    $0x30
  801a61:	89 c6                	mov    %eax,%esi

	envid_t envid;
	uint32_t va;
	envid = sys_exofork();
	if (envid < 0){
  801a63:	83 c4 10             	add    $0x10,%esp
  801a66:	85 c0                	test   %eax,%eax
  801a68:	79 15                	jns    801a7f <fork+0x38>
		panic("sys_exofork: %e", envid);
  801a6a:	50                   	push   %eax
  801a6b:	68 59 3a 80 00       	push   $0x803a59
  801a70:	68 b1 00 00 00       	push   $0xb1
  801a75:	68 90 39 80 00       	push   $0x803990
  801a7a:	e8 9a ef ff ff       	call   800a19 <_panic>
  801a7f:	89 c7                	mov    %eax,%edi
  801a81:	bb 00 00 00 00       	mov    $0x0,%ebx
	}
	if (envid == 0) {		
  801a86:	85 c0                	test   %eax,%eax
  801a88:	75 21                	jne    801aab <fork+0x64>
		thisenv = &envs[ENVX(sys_getenvid())];
  801a8a:	e8 c6 fa ff ff       	call   801555 <sys_getenvid>
  801a8f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a94:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a97:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a9c:	a3 24 54 80 00       	mov    %eax,0x805424
		return 0;
  801aa1:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa6:	e9 a7 00 00 00       	jmp    801b52 <fork+0x10b>
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  801aab:	89 d8                	mov    %ebx,%eax
  801aad:	c1 e8 16             	shr    $0x16,%eax
  801ab0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ab7:	a8 01                	test   $0x1,%al
  801ab9:	74 22                	je     801add <fork+0x96>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  801abb:	89 da                	mov    %ebx,%edx
  801abd:	c1 ea 0c             	shr    $0xc,%edx
  801ac0:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801ac7:	a8 01                	test   $0x1,%al
  801ac9:	74 12                	je     801add <fork+0x96>
  801acb:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801ad2:	a8 04                	test   $0x4,%al
  801ad4:	74 07                	je     801add <fork+0x96>
				duppage(envid, PGNUM(va));			
  801ad6:	89 f8                	mov    %edi,%eax
  801ad8:	e8 e0 fb ff ff       	call   8016bd <duppage>
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
  801add:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ae3:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801ae9:	75 c0                	jne    801aab <fork+0x64>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
				duppage(envid, PGNUM(va));			
			}
		}
	}
	if (sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P) < 0){
  801aeb:	83 ec 04             	sub    $0x4,%esp
  801aee:	6a 07                	push   $0x7
  801af0:	68 00 f0 bf ee       	push   $0xeebff000
  801af5:	56                   	push   %esi
  801af6:	e8 a5 fa ff ff       	call   8015a0 <sys_page_alloc>
  801afb:	83 c4 10             	add    $0x10,%esp
  801afe:	85 c0                	test   %eax,%eax
  801b00:	79 17                	jns    801b19 <fork+0xd2>
		panic("Se escribio en la pagina de excepciones");
  801b02:	83 ec 04             	sub    $0x4,%esp
  801b05:	68 98 3a 80 00       	push   $0x803a98
  801b0a:	68 c0 00 00 00       	push   $0xc0
  801b0f:	68 90 39 80 00       	push   $0x803990
  801b14:	e8 00 ef ff ff       	call   800a19 <_panic>
	}	
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801b19:	83 ec 08             	sub    $0x8,%esp
  801b1c:	68 06 30 80 00       	push   $0x803006
  801b21:	56                   	push   %esi
  801b22:	e8 2c fb ff ff       	call   801653 <sys_env_set_pgfault_upcall>

	if (sys_env_set_status(envid, ENV_RUNNABLE) < 0)
  801b27:	83 c4 08             	add    $0x8,%esp
  801b2a:	6a 02                	push   $0x2
  801b2c:	56                   	push   %esi
  801b2d:	e8 db fa ff ff       	call   80160d <sys_env_set_status>
  801b32:	83 c4 10             	add    $0x10,%esp
  801b35:	85 c0                	test   %eax,%eax
  801b37:	79 17                	jns    801b50 <fork+0x109>
		panic("Status incorrecto de enviroment");
  801b39:	83 ec 04             	sub    $0x4,%esp
  801b3c:	68 c0 3a 80 00       	push   $0x803ac0
  801b41:	68 c5 00 00 00       	push   $0xc5
  801b46:	68 90 39 80 00       	push   $0x803990
  801b4b:	e8 c9 ee ff ff       	call   800a19 <_panic>

	return envid;
  801b50:	89 f0                	mov    %esi,%eax
	
}
  801b52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b55:	5b                   	pop    %ebx
  801b56:	5e                   	pop    %esi
  801b57:	5f                   	pop    %edi
  801b58:	5d                   	pop    %ebp
  801b59:	c3                   	ret    

00801b5a <sfork>:


// Challenge!
int
sfork(void)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801b60:	68 80 3a 80 00       	push   $0x803a80
  801b65:	68 d1 00 00 00       	push   $0xd1
  801b6a:	68 90 39 80 00       	push   $0x803990
  801b6f:	e8 a5 ee ff ff       	call   800a19 <_panic>

00801b74 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
  801b77:	8b 55 08             	mov    0x8(%ebp),%edx
  801b7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b7d:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801b80:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801b82:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801b85:	83 3a 01             	cmpl   $0x1,(%edx)
  801b88:	7e 09                	jle    801b93 <argstart+0x1f>
  801b8a:	ba 21 34 80 00       	mov    $0x803421,%edx
  801b8f:	85 c9                	test   %ecx,%ecx
  801b91:	75 05                	jne    801b98 <argstart+0x24>
  801b93:	ba 00 00 00 00       	mov    $0x0,%edx
  801b98:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801b9b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801ba2:	5d                   	pop    %ebp
  801ba3:	c3                   	ret    

00801ba4 <argnext>:

int
argnext(struct Argstate *args)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	53                   	push   %ebx
  801ba8:	83 ec 04             	sub    $0x4,%esp
  801bab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801bae:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801bb5:	8b 43 08             	mov    0x8(%ebx),%eax
  801bb8:	85 c0                	test   %eax,%eax
  801bba:	74 6f                	je     801c2b <argnext+0x87>
		return -1;

	if (!*args->curarg) {
  801bbc:	80 38 00             	cmpb   $0x0,(%eax)
  801bbf:	75 4e                	jne    801c0f <argnext+0x6b>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801bc1:	8b 0b                	mov    (%ebx),%ecx
  801bc3:	83 39 01             	cmpl   $0x1,(%ecx)
  801bc6:	74 55                	je     801c1d <argnext+0x79>
		    || args->argv[1][0] != '-'
  801bc8:	8b 53 04             	mov    0x4(%ebx),%edx
  801bcb:	8b 42 04             	mov    0x4(%edx),%eax
  801bce:	80 38 2d             	cmpb   $0x2d,(%eax)
  801bd1:	75 4a                	jne    801c1d <argnext+0x79>
		    || args->argv[1][1] == '\0')
  801bd3:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801bd7:	74 44                	je     801c1d <argnext+0x79>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801bd9:	83 c0 01             	add    $0x1,%eax
  801bdc:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801bdf:	83 ec 04             	sub    $0x4,%esp
  801be2:	8b 01                	mov    (%ecx),%eax
  801be4:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801beb:	50                   	push   %eax
  801bec:	8d 42 08             	lea    0x8(%edx),%eax
  801bef:	50                   	push   %eax
  801bf0:	83 c2 04             	add    $0x4,%edx
  801bf3:	52                   	push   %edx
  801bf4:	e8 f1 f6 ff ff       	call   8012ea <memmove>
		(*args->argc)--;
  801bf9:	8b 03                	mov    (%ebx),%eax
  801bfb:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801bfe:	8b 43 08             	mov    0x8(%ebx),%eax
  801c01:	83 c4 10             	add    $0x10,%esp
  801c04:	80 38 2d             	cmpb   $0x2d,(%eax)
  801c07:	75 06                	jne    801c0f <argnext+0x6b>
  801c09:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801c0d:	74 0e                	je     801c1d <argnext+0x79>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801c0f:	8b 53 08             	mov    0x8(%ebx),%edx
  801c12:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801c15:	83 c2 01             	add    $0x1,%edx
  801c18:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  801c1b:	eb 13                	jmp    801c30 <argnext+0x8c>

    endofargs:
	args->curarg = 0;
  801c1d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801c24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801c29:	eb 05                	jmp    801c30 <argnext+0x8c>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
  801c2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801c30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	53                   	push   %ebx
  801c39:	83 ec 04             	sub    $0x4,%esp
  801c3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801c3f:	8b 43 08             	mov    0x8(%ebx),%eax
  801c42:	85 c0                	test   %eax,%eax
  801c44:	74 58                	je     801c9e <argnextvalue+0x69>
		return 0;
	if (*args->curarg) {
  801c46:	80 38 00             	cmpb   $0x0,(%eax)
  801c49:	74 0c                	je     801c57 <argnextvalue+0x22>
		args->argvalue = args->curarg;
  801c4b:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801c4e:	c7 43 08 21 34 80 00 	movl   $0x803421,0x8(%ebx)
  801c55:	eb 42                	jmp    801c99 <argnextvalue+0x64>
	} else if (*args->argc > 1) {
  801c57:	8b 13                	mov    (%ebx),%edx
  801c59:	83 3a 01             	cmpl   $0x1,(%edx)
  801c5c:	7e 2d                	jle    801c8b <argnextvalue+0x56>
		args->argvalue = args->argv[1];
  801c5e:	8b 43 04             	mov    0x4(%ebx),%eax
  801c61:	8b 48 04             	mov    0x4(%eax),%ecx
  801c64:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801c67:	83 ec 04             	sub    $0x4,%esp
  801c6a:	8b 12                	mov    (%edx),%edx
  801c6c:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801c73:	52                   	push   %edx
  801c74:	8d 50 08             	lea    0x8(%eax),%edx
  801c77:	52                   	push   %edx
  801c78:	83 c0 04             	add    $0x4,%eax
  801c7b:	50                   	push   %eax
  801c7c:	e8 69 f6 ff ff       	call   8012ea <memmove>
		(*args->argc)--;
  801c81:	8b 03                	mov    (%ebx),%eax
  801c83:	83 28 01             	subl   $0x1,(%eax)
  801c86:	83 c4 10             	add    $0x10,%esp
  801c89:	eb 0e                	jmp    801c99 <argnextvalue+0x64>
	} else {
		args->argvalue = 0;
  801c8b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801c92:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  801c99:	8b 43 0c             	mov    0xc(%ebx),%eax
  801c9c:	eb 05                	jmp    801ca3 <argnextvalue+0x6e>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
  801c9e:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
  801ca3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 08             	sub    $0x8,%esp
  801cae:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801cb1:	8b 51 0c             	mov    0xc(%ecx),%edx
  801cb4:	89 d0                	mov    %edx,%eax
  801cb6:	85 d2                	test   %edx,%edx
  801cb8:	75 0c                	jne    801cc6 <argvalue+0x1e>
  801cba:	83 ec 0c             	sub    $0xc,%esp
  801cbd:	51                   	push   %ecx
  801cbe:	e8 72 ff ff ff       	call   801c35 <argnextvalue>
  801cc3:	83 c4 10             	add    $0x10,%esp
}
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	05 00 00 00 30       	add    $0x30000000,%eax
  801cd3:	c1 e8 0c             	shr    $0xc,%eax
}
  801cd6:	5d                   	pop    %ebp
  801cd7:	c3                   	ret    

00801cd8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  801cdb:	ff 75 08             	pushl  0x8(%ebp)
  801cde:	e8 e5 ff ff ff       	call   801cc8 <fd2num>
  801ce3:	83 c4 04             	add    $0x4,%esp
  801ce6:	c1 e0 0c             	shl    $0xc,%eax
  801ce9:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cf6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801cfb:	89 c2                	mov    %eax,%edx
  801cfd:	c1 ea 16             	shr    $0x16,%edx
  801d00:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801d07:	f6 c2 01             	test   $0x1,%dl
  801d0a:	74 11                	je     801d1d <fd_alloc+0x2d>
  801d0c:	89 c2                	mov    %eax,%edx
  801d0e:	c1 ea 0c             	shr    $0xc,%edx
  801d11:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801d18:	f6 c2 01             	test   $0x1,%dl
  801d1b:	75 09                	jne    801d26 <fd_alloc+0x36>
			*fd_store = fd;
  801d1d:	89 01                	mov    %eax,(%ecx)
			return 0;
  801d1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d24:	eb 17                	jmp    801d3d <fd_alloc+0x4d>
  801d26:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d2b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801d30:	75 c9                	jne    801cfb <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d32:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801d38:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801d3d:	5d                   	pop    %ebp
  801d3e:	c3                   	ret    

00801d3f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d45:	83 f8 1f             	cmp    $0x1f,%eax
  801d48:	77 36                	ja     801d80 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801d4a:	c1 e0 0c             	shl    $0xc,%eax
  801d4d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801d52:	89 c2                	mov    %eax,%edx
  801d54:	c1 ea 16             	shr    $0x16,%edx
  801d57:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801d5e:	f6 c2 01             	test   $0x1,%dl
  801d61:	74 24                	je     801d87 <fd_lookup+0x48>
  801d63:	89 c2                	mov    %eax,%edx
  801d65:	c1 ea 0c             	shr    $0xc,%edx
  801d68:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801d6f:	f6 c2 01             	test   $0x1,%dl
  801d72:	74 1a                	je     801d8e <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801d74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d77:	89 02                	mov    %eax,(%edx)
	return 0;
  801d79:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7e:	eb 13                	jmp    801d93 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d80:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d85:	eb 0c                	jmp    801d93 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d87:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d8c:	eb 05                	jmp    801d93 <fd_lookup+0x54>
  801d8e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  801d93:	5d                   	pop    %ebp
  801d94:	c3                   	ret    

00801d95 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	83 ec 08             	sub    $0x8,%esp
  801d9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d9e:	ba 5c 3b 80 00       	mov    $0x803b5c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801da3:	eb 13                	jmp    801db8 <dev_lookup+0x23>
  801da5:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  801da8:	39 08                	cmp    %ecx,(%eax)
  801daa:	75 0c                	jne    801db8 <dev_lookup+0x23>
			*dev = devtab[i];
  801dac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801daf:	89 01                	mov    %eax,(%ecx)
			return 0;
  801db1:	b8 00 00 00 00       	mov    $0x0,%eax
  801db6:	eb 2e                	jmp    801de6 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801db8:	8b 02                	mov    (%edx),%eax
  801dba:	85 c0                	test   %eax,%eax
  801dbc:	75 e7                	jne    801da5 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801dbe:	a1 24 54 80 00       	mov    0x805424,%eax
  801dc3:	8b 40 48             	mov    0x48(%eax),%eax
  801dc6:	83 ec 04             	sub    $0x4,%esp
  801dc9:	51                   	push   %ecx
  801dca:	50                   	push   %eax
  801dcb:	68 e0 3a 80 00       	push   $0x803ae0
  801dd0:	e8 1d ed ff ff       	call   800af2 <cprintf>
	*dev = 0;
  801dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801dde:	83 c4 10             	add    $0x10,%esp
  801de1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	56                   	push   %esi
  801dec:	53                   	push   %ebx
  801ded:	83 ec 10             	sub    $0x10,%esp
  801df0:	8b 75 08             	mov    0x8(%ebp),%esi
  801df3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801df6:	56                   	push   %esi
  801df7:	e8 cc fe ff ff       	call   801cc8 <fd2num>
  801dfc:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801dff:	89 14 24             	mov    %edx,(%esp)
  801e02:	50                   	push   %eax
  801e03:	e8 37 ff ff ff       	call   801d3f <fd_lookup>
  801e08:	83 c4 08             	add    $0x8,%esp
  801e0b:	85 c0                	test   %eax,%eax
  801e0d:	78 05                	js     801e14 <fd_close+0x2c>
	    || fd != fd2)
  801e0f:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801e12:	74 0c                	je     801e20 <fd_close+0x38>
		return (must_exist ? r : 0);
  801e14:	84 db                	test   %bl,%bl
  801e16:	ba 00 00 00 00       	mov    $0x0,%edx
  801e1b:	0f 44 c2             	cmove  %edx,%eax
  801e1e:	eb 41                	jmp    801e61 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e20:	83 ec 08             	sub    $0x8,%esp
  801e23:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e26:	50                   	push   %eax
  801e27:	ff 36                	pushl  (%esi)
  801e29:	e8 67 ff ff ff       	call   801d95 <dev_lookup>
  801e2e:	89 c3                	mov    %eax,%ebx
  801e30:	83 c4 10             	add    $0x10,%esp
  801e33:	85 c0                	test   %eax,%eax
  801e35:	78 1a                	js     801e51 <fd_close+0x69>
		if (dev->dev_close)
  801e37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3a:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801e3d:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801e42:	85 c0                	test   %eax,%eax
  801e44:	74 0b                	je     801e51 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  801e46:	83 ec 0c             	sub    $0xc,%esp
  801e49:	56                   	push   %esi
  801e4a:	ff d0                	call   *%eax
  801e4c:	89 c3                	mov    %eax,%ebx
  801e4e:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801e51:	83 ec 08             	sub    $0x8,%esp
  801e54:	56                   	push   %esi
  801e55:	6a 00                	push   $0x0
  801e57:	e8 8e f7 ff ff       	call   8015ea <sys_page_unmap>
	return r;
  801e5c:	83 c4 10             	add    $0x10,%esp
  801e5f:	89 d8                	mov    %ebx,%eax
}
  801e61:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e64:	5b                   	pop    %ebx
  801e65:	5e                   	pop    %esi
  801e66:	5d                   	pop    %ebp
  801e67:	c3                   	ret    

00801e68 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
  801e6b:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e6e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e71:	50                   	push   %eax
  801e72:	ff 75 08             	pushl  0x8(%ebp)
  801e75:	e8 c5 fe ff ff       	call   801d3f <fd_lookup>
  801e7a:	83 c4 08             	add    $0x8,%esp
  801e7d:	85 c0                	test   %eax,%eax
  801e7f:	78 10                	js     801e91 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801e81:	83 ec 08             	sub    $0x8,%esp
  801e84:	6a 01                	push   $0x1
  801e86:	ff 75 f4             	pushl  -0xc(%ebp)
  801e89:	e8 5a ff ff ff       	call   801de8 <fd_close>
  801e8e:	83 c4 10             	add    $0x10,%esp
}
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

00801e93 <close_all>:

void
close_all(void)
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
  801e96:	53                   	push   %ebx
  801e97:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801e9a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801e9f:	83 ec 0c             	sub    $0xc,%esp
  801ea2:	53                   	push   %ebx
  801ea3:	e8 c0 ff ff ff       	call   801e68 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801ea8:	83 c3 01             	add    $0x1,%ebx
  801eab:	83 c4 10             	add    $0x10,%esp
  801eae:	83 fb 20             	cmp    $0x20,%ebx
  801eb1:	75 ec                	jne    801e9f <close_all+0xc>
		close(i);
}
  801eb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
  801ebb:	57                   	push   %edi
  801ebc:	56                   	push   %esi
  801ebd:	53                   	push   %ebx
  801ebe:	83 ec 2c             	sub    $0x2c,%esp
  801ec1:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801ec4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801ec7:	50                   	push   %eax
  801ec8:	ff 75 08             	pushl  0x8(%ebp)
  801ecb:	e8 6f fe ff ff       	call   801d3f <fd_lookup>
  801ed0:	83 c4 08             	add    $0x8,%esp
  801ed3:	85 c0                	test   %eax,%eax
  801ed5:	0f 88 c1 00 00 00    	js     801f9c <dup+0xe4>
		return r;
	close(newfdnum);
  801edb:	83 ec 0c             	sub    $0xc,%esp
  801ede:	56                   	push   %esi
  801edf:	e8 84 ff ff ff       	call   801e68 <close>

	newfd = INDEX2FD(newfdnum);
  801ee4:	89 f3                	mov    %esi,%ebx
  801ee6:	c1 e3 0c             	shl    $0xc,%ebx
  801ee9:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801eef:	83 c4 04             	add    $0x4,%esp
  801ef2:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ef5:	e8 de fd ff ff       	call   801cd8 <fd2data>
  801efa:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  801efc:	89 1c 24             	mov    %ebx,(%esp)
  801eff:	e8 d4 fd ff ff       	call   801cd8 <fd2data>
  801f04:	83 c4 10             	add    $0x10,%esp
  801f07:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801f0a:	89 f8                	mov    %edi,%eax
  801f0c:	c1 e8 16             	shr    $0x16,%eax
  801f0f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801f16:	a8 01                	test   $0x1,%al
  801f18:	74 37                	je     801f51 <dup+0x99>
  801f1a:	89 f8                	mov    %edi,%eax
  801f1c:	c1 e8 0c             	shr    $0xc,%eax
  801f1f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801f26:	f6 c2 01             	test   $0x1,%dl
  801f29:	74 26                	je     801f51 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801f2b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801f32:	83 ec 0c             	sub    $0xc,%esp
  801f35:	25 07 0e 00 00       	and    $0xe07,%eax
  801f3a:	50                   	push   %eax
  801f3b:	ff 75 d4             	pushl  -0x2c(%ebp)
  801f3e:	6a 00                	push   $0x0
  801f40:	57                   	push   %edi
  801f41:	6a 00                	push   $0x0
  801f43:	e8 7c f6 ff ff       	call   8015c4 <sys_page_map>
  801f48:	89 c7                	mov    %eax,%edi
  801f4a:	83 c4 20             	add    $0x20,%esp
  801f4d:	85 c0                	test   %eax,%eax
  801f4f:	78 2e                	js     801f7f <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801f51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f54:	89 d0                	mov    %edx,%eax
  801f56:	c1 e8 0c             	shr    $0xc,%eax
  801f59:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801f60:	83 ec 0c             	sub    $0xc,%esp
  801f63:	25 07 0e 00 00       	and    $0xe07,%eax
  801f68:	50                   	push   %eax
  801f69:	53                   	push   %ebx
  801f6a:	6a 00                	push   $0x0
  801f6c:	52                   	push   %edx
  801f6d:	6a 00                	push   $0x0
  801f6f:	e8 50 f6 ff ff       	call   8015c4 <sys_page_map>
  801f74:	89 c7                	mov    %eax,%edi
  801f76:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  801f79:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801f7b:	85 ff                	test   %edi,%edi
  801f7d:	79 1d                	jns    801f9c <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801f7f:	83 ec 08             	sub    $0x8,%esp
  801f82:	53                   	push   %ebx
  801f83:	6a 00                	push   $0x0
  801f85:	e8 60 f6 ff ff       	call   8015ea <sys_page_unmap>
	sys_page_unmap(0, nva);
  801f8a:	83 c4 08             	add    $0x8,%esp
  801f8d:	ff 75 d4             	pushl  -0x2c(%ebp)
  801f90:	6a 00                	push   $0x0
  801f92:	e8 53 f6 ff ff       	call   8015ea <sys_page_unmap>
	return r;
  801f97:	83 c4 10             	add    $0x10,%esp
  801f9a:	89 f8                	mov    %edi,%eax
}
  801f9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f9f:	5b                   	pop    %ebx
  801fa0:	5e                   	pop    %esi
  801fa1:	5f                   	pop    %edi
  801fa2:	5d                   	pop    %ebp
  801fa3:	c3                   	ret    

00801fa4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	53                   	push   %ebx
  801fa8:	83 ec 14             	sub    $0x14,%esp
  801fab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801fae:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fb1:	50                   	push   %eax
  801fb2:	53                   	push   %ebx
  801fb3:	e8 87 fd ff ff       	call   801d3f <fd_lookup>
  801fb8:	83 c4 08             	add    $0x8,%esp
  801fbb:	89 c2                	mov    %eax,%edx
  801fbd:	85 c0                	test   %eax,%eax
  801fbf:	78 6d                	js     80202e <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801fc1:	83 ec 08             	sub    $0x8,%esp
  801fc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fc7:	50                   	push   %eax
  801fc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fcb:	ff 30                	pushl  (%eax)
  801fcd:	e8 c3 fd ff ff       	call   801d95 <dev_lookup>
  801fd2:	83 c4 10             	add    $0x10,%esp
  801fd5:	85 c0                	test   %eax,%eax
  801fd7:	78 4c                	js     802025 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801fd9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fdc:	8b 42 08             	mov    0x8(%edx),%eax
  801fdf:	83 e0 03             	and    $0x3,%eax
  801fe2:	83 f8 01             	cmp    $0x1,%eax
  801fe5:	75 21                	jne    802008 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801fe7:	a1 24 54 80 00       	mov    0x805424,%eax
  801fec:	8b 40 48             	mov    0x48(%eax),%eax
  801fef:	83 ec 04             	sub    $0x4,%esp
  801ff2:	53                   	push   %ebx
  801ff3:	50                   	push   %eax
  801ff4:	68 21 3b 80 00       	push   $0x803b21
  801ff9:	e8 f4 ea ff ff       	call   800af2 <cprintf>
		return -E_INVAL;
  801ffe:	83 c4 10             	add    $0x10,%esp
  802001:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  802006:	eb 26                	jmp    80202e <read+0x8a>
	}
	if (!dev->dev_read)
  802008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200b:	8b 40 08             	mov    0x8(%eax),%eax
  80200e:	85 c0                	test   %eax,%eax
  802010:	74 17                	je     802029 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802012:	83 ec 04             	sub    $0x4,%esp
  802015:	ff 75 10             	pushl  0x10(%ebp)
  802018:	ff 75 0c             	pushl  0xc(%ebp)
  80201b:	52                   	push   %edx
  80201c:	ff d0                	call   *%eax
  80201e:	89 c2                	mov    %eax,%edx
  802020:	83 c4 10             	add    $0x10,%esp
  802023:	eb 09                	jmp    80202e <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802025:	89 c2                	mov    %eax,%edx
  802027:	eb 05                	jmp    80202e <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  802029:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  80202e:	89 d0                	mov    %edx,%eax
  802030:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
  802038:	57                   	push   %edi
  802039:	56                   	push   %esi
  80203a:	53                   	push   %ebx
  80203b:	83 ec 0c             	sub    $0xc,%esp
  80203e:	8b 7d 08             	mov    0x8(%ebp),%edi
  802041:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802044:	bb 00 00 00 00       	mov    $0x0,%ebx
  802049:	eb 21                	jmp    80206c <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80204b:	83 ec 04             	sub    $0x4,%esp
  80204e:	89 f0                	mov    %esi,%eax
  802050:	29 d8                	sub    %ebx,%eax
  802052:	50                   	push   %eax
  802053:	89 d8                	mov    %ebx,%eax
  802055:	03 45 0c             	add    0xc(%ebp),%eax
  802058:	50                   	push   %eax
  802059:	57                   	push   %edi
  80205a:	e8 45 ff ff ff       	call   801fa4 <read>
		if (m < 0)
  80205f:	83 c4 10             	add    $0x10,%esp
  802062:	85 c0                	test   %eax,%eax
  802064:	78 10                	js     802076 <readn+0x41>
			return m;
		if (m == 0)
  802066:	85 c0                	test   %eax,%eax
  802068:	74 0a                	je     802074 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80206a:	01 c3                	add    %eax,%ebx
  80206c:	39 f3                	cmp    %esi,%ebx
  80206e:	72 db                	jb     80204b <readn+0x16>
  802070:	89 d8                	mov    %ebx,%eax
  802072:	eb 02                	jmp    802076 <readn+0x41>
  802074:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  802076:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802079:	5b                   	pop    %ebx
  80207a:	5e                   	pop    %esi
  80207b:	5f                   	pop    %edi
  80207c:	5d                   	pop    %ebp
  80207d:	c3                   	ret    

0080207e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	53                   	push   %ebx
  802082:	83 ec 14             	sub    $0x14,%esp
  802085:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802088:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80208b:	50                   	push   %eax
  80208c:	53                   	push   %ebx
  80208d:	e8 ad fc ff ff       	call   801d3f <fd_lookup>
  802092:	83 c4 08             	add    $0x8,%esp
  802095:	89 c2                	mov    %eax,%edx
  802097:	85 c0                	test   %eax,%eax
  802099:	78 68                	js     802103 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80209b:	83 ec 08             	sub    $0x8,%esp
  80209e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020a1:	50                   	push   %eax
  8020a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a5:	ff 30                	pushl  (%eax)
  8020a7:	e8 e9 fc ff ff       	call   801d95 <dev_lookup>
  8020ac:	83 c4 10             	add    $0x10,%esp
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	78 47                	js     8020fa <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8020b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8020ba:	75 21                	jne    8020dd <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8020bc:	a1 24 54 80 00       	mov    0x805424,%eax
  8020c1:	8b 40 48             	mov    0x48(%eax),%eax
  8020c4:	83 ec 04             	sub    $0x4,%esp
  8020c7:	53                   	push   %ebx
  8020c8:	50                   	push   %eax
  8020c9:	68 3d 3b 80 00       	push   $0x803b3d
  8020ce:	e8 1f ea ff ff       	call   800af2 <cprintf>
		return -E_INVAL;
  8020d3:	83 c4 10             	add    $0x10,%esp
  8020d6:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8020db:	eb 26                	jmp    802103 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8020dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e0:	8b 52 0c             	mov    0xc(%edx),%edx
  8020e3:	85 d2                	test   %edx,%edx
  8020e5:	74 17                	je     8020fe <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8020e7:	83 ec 04             	sub    $0x4,%esp
  8020ea:	ff 75 10             	pushl  0x10(%ebp)
  8020ed:	ff 75 0c             	pushl  0xc(%ebp)
  8020f0:	50                   	push   %eax
  8020f1:	ff d2                	call   *%edx
  8020f3:	89 c2                	mov    %eax,%edx
  8020f5:	83 c4 10             	add    $0x10,%esp
  8020f8:	eb 09                	jmp    802103 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8020fa:	89 c2                	mov    %eax,%edx
  8020fc:	eb 05                	jmp    802103 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8020fe:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  802103:	89 d0                	mov    %edx,%eax
  802105:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802108:	c9                   	leave  
  802109:	c3                   	ret    

0080210a <seek>:

int
seek(int fdnum, off_t offset)
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
  80210d:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802110:	8d 45 fc             	lea    -0x4(%ebp),%eax
  802113:	50                   	push   %eax
  802114:	ff 75 08             	pushl  0x8(%ebp)
  802117:	e8 23 fc ff ff       	call   801d3f <fd_lookup>
  80211c:	83 c4 08             	add    $0x8,%esp
  80211f:	85 c0                	test   %eax,%eax
  802121:	78 0e                	js     802131 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  802123:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802126:	8b 55 0c             	mov    0xc(%ebp),%edx
  802129:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80212c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802131:	c9                   	leave  
  802132:	c3                   	ret    

00802133 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	53                   	push   %ebx
  802137:	83 ec 14             	sub    $0x14,%esp
  80213a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80213d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802140:	50                   	push   %eax
  802141:	53                   	push   %ebx
  802142:	e8 f8 fb ff ff       	call   801d3f <fd_lookup>
  802147:	83 c4 08             	add    $0x8,%esp
  80214a:	89 c2                	mov    %eax,%edx
  80214c:	85 c0                	test   %eax,%eax
  80214e:	78 65                	js     8021b5 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802150:	83 ec 08             	sub    $0x8,%esp
  802153:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802156:	50                   	push   %eax
  802157:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215a:	ff 30                	pushl  (%eax)
  80215c:	e8 34 fc ff ff       	call   801d95 <dev_lookup>
  802161:	83 c4 10             	add    $0x10,%esp
  802164:	85 c0                	test   %eax,%eax
  802166:	78 44                	js     8021ac <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802168:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80216f:	75 21                	jne    802192 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802171:	a1 24 54 80 00       	mov    0x805424,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802176:	8b 40 48             	mov    0x48(%eax),%eax
  802179:	83 ec 04             	sub    $0x4,%esp
  80217c:	53                   	push   %ebx
  80217d:	50                   	push   %eax
  80217e:	68 00 3b 80 00       	push   $0x803b00
  802183:	e8 6a e9 ff ff       	call   800af2 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802188:	83 c4 10             	add    $0x10,%esp
  80218b:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  802190:	eb 23                	jmp    8021b5 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  802192:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802195:	8b 52 18             	mov    0x18(%edx),%edx
  802198:	85 d2                	test   %edx,%edx
  80219a:	74 14                	je     8021b0 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80219c:	83 ec 08             	sub    $0x8,%esp
  80219f:	ff 75 0c             	pushl  0xc(%ebp)
  8021a2:	50                   	push   %eax
  8021a3:	ff d2                	call   *%edx
  8021a5:	89 c2                	mov    %eax,%edx
  8021a7:	83 c4 10             	add    $0x10,%esp
  8021aa:	eb 09                	jmp    8021b5 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021ac:	89 c2                	mov    %eax,%edx
  8021ae:	eb 05                	jmp    8021b5 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8021b0:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  8021b5:	89 d0                	mov    %edx,%eax
  8021b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021ba:	c9                   	leave  
  8021bb:	c3                   	ret    

008021bc <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
  8021bf:	53                   	push   %ebx
  8021c0:	83 ec 14             	sub    $0x14,%esp
  8021c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021c9:	50                   	push   %eax
  8021ca:	ff 75 08             	pushl  0x8(%ebp)
  8021cd:	e8 6d fb ff ff       	call   801d3f <fd_lookup>
  8021d2:	83 c4 08             	add    $0x8,%esp
  8021d5:	89 c2                	mov    %eax,%edx
  8021d7:	85 c0                	test   %eax,%eax
  8021d9:	78 58                	js     802233 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021db:	83 ec 08             	sub    $0x8,%esp
  8021de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021e1:	50                   	push   %eax
  8021e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e5:	ff 30                	pushl  (%eax)
  8021e7:	e8 a9 fb ff ff       	call   801d95 <dev_lookup>
  8021ec:	83 c4 10             	add    $0x10,%esp
  8021ef:	85 c0                	test   %eax,%eax
  8021f1:	78 37                	js     80222a <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  8021f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f6:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8021fa:	74 32                	je     80222e <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8021fc:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8021ff:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802206:	00 00 00 
	stat->st_isdir = 0;
  802209:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802210:	00 00 00 
	stat->st_dev = dev;
  802213:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802219:	83 ec 08             	sub    $0x8,%esp
  80221c:	53                   	push   %ebx
  80221d:	ff 75 f0             	pushl  -0x10(%ebp)
  802220:	ff 50 14             	call   *0x14(%eax)
  802223:	89 c2                	mov    %eax,%edx
  802225:	83 c4 10             	add    $0x10,%esp
  802228:	eb 09                	jmp    802233 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80222a:	89 c2                	mov    %eax,%edx
  80222c:	eb 05                	jmp    802233 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  80222e:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  802233:	89 d0                	mov    %edx,%eax
  802235:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802238:	c9                   	leave  
  802239:	c3                   	ret    

0080223a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	56                   	push   %esi
  80223e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80223f:	83 ec 08             	sub    $0x8,%esp
  802242:	6a 00                	push   $0x0
  802244:	ff 75 08             	pushl  0x8(%ebp)
  802247:	e8 06 02 00 00       	call   802452 <open>
  80224c:	89 c3                	mov    %eax,%ebx
  80224e:	83 c4 10             	add    $0x10,%esp
  802251:	85 c0                	test   %eax,%eax
  802253:	78 1b                	js     802270 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  802255:	83 ec 08             	sub    $0x8,%esp
  802258:	ff 75 0c             	pushl  0xc(%ebp)
  80225b:	50                   	push   %eax
  80225c:	e8 5b ff ff ff       	call   8021bc <fstat>
  802261:	89 c6                	mov    %eax,%esi
	close(fd);
  802263:	89 1c 24             	mov    %ebx,(%esp)
  802266:	e8 fd fb ff ff       	call   801e68 <close>
	return r;
  80226b:	83 c4 10             	add    $0x10,%esp
  80226e:	89 f0                	mov    %esi,%eax
}
  802270:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802273:	5b                   	pop    %ebx
  802274:	5e                   	pop    %esi
  802275:	5d                   	pop    %ebp
  802276:	c3                   	ret    

00802277 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
  80227a:	56                   	push   %esi
  80227b:	53                   	push   %ebx
  80227c:	89 c6                	mov    %eax,%esi
  80227e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  802280:	83 3d 20 54 80 00 00 	cmpl   $0x0,0x805420
  802287:	75 12                	jne    80229b <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802289:	83 ec 0c             	sub    $0xc,%esp
  80228c:	6a 01                	push   $0x1
  80228e:	e8 56 0e 00 00       	call   8030e9 <ipc_find_env>
  802293:	a3 20 54 80 00       	mov    %eax,0x805420
  802298:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80229b:	6a 07                	push   $0x7
  80229d:	68 00 60 80 00       	push   $0x806000
  8022a2:	56                   	push   %esi
  8022a3:	ff 35 20 54 80 00    	pushl  0x805420
  8022a9:	e8 e7 0d 00 00       	call   803095 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8022ae:	83 c4 0c             	add    $0xc,%esp
  8022b1:	6a 00                	push   $0x0
  8022b3:	53                   	push   %ebx
  8022b4:	6a 00                	push   $0x0
  8022b6:	e8 6f 0d 00 00       	call   80302a <ipc_recv>
}
  8022bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022be:	5b                   	pop    %ebx
  8022bf:	5e                   	pop    %esi
  8022c0:	5d                   	pop    %ebp
  8022c1:	c3                   	ret    

008022c2 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8022c2:	55                   	push   %ebp
  8022c3:	89 e5                	mov    %esp,%ebp
  8022c5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ce:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8022d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d6:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8022db:	ba 00 00 00 00       	mov    $0x0,%edx
  8022e0:	b8 02 00 00 00       	mov    $0x2,%eax
  8022e5:	e8 8d ff ff ff       	call   802277 <fsipc>
}
  8022ea:	c9                   	leave  
  8022eb:	c3                   	ret    

008022ec <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8022ec:	55                   	push   %ebp
  8022ed:	89 e5                	mov    %esp,%ebp
  8022ef:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8022f8:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8022fd:	ba 00 00 00 00       	mov    $0x0,%edx
  802302:	b8 06 00 00 00       	mov    $0x6,%eax
  802307:	e8 6b ff ff ff       	call   802277 <fsipc>
}
  80230c:	c9                   	leave  
  80230d:	c3                   	ret    

0080230e <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80230e:	55                   	push   %ebp
  80230f:	89 e5                	mov    %esp,%ebp
  802311:	53                   	push   %ebx
  802312:	83 ec 04             	sub    $0x4,%esp
  802315:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802318:	8b 45 08             	mov    0x8(%ebp),%eax
  80231b:	8b 40 0c             	mov    0xc(%eax),%eax
  80231e:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802323:	ba 00 00 00 00       	mov    $0x0,%edx
  802328:	b8 05 00 00 00       	mov    $0x5,%eax
  80232d:	e8 45 ff ff ff       	call   802277 <fsipc>
  802332:	85 c0                	test   %eax,%eax
  802334:	78 2c                	js     802362 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802336:	83 ec 08             	sub    $0x8,%esp
  802339:	68 00 60 80 00       	push   $0x806000
  80233e:	53                   	push   %ebx
  80233f:	e8 13 ee ff ff       	call   801157 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802344:	a1 80 60 80 00       	mov    0x806080,%eax
  802349:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80234f:	a1 84 60 80 00       	mov    0x806084,%eax
  802354:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80235a:	83 c4 10             	add    $0x10,%esp
  80235d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802362:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802365:	c9                   	leave  
  802366:	c3                   	ret    

00802367 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
  80236a:	83 ec 08             	sub    $0x8,%esp
  80236d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802370:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802373:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802376:	8b 49 0c             	mov    0xc(%ecx),%ecx
  802379:	89 0d 00 60 80 00    	mov    %ecx,0x806000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  80237f:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  802384:	76 22                	jbe    8023a8 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  802386:	c7 05 04 60 80 00 f8 	movl   $0xff8,0x806004
  80238d:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  802390:	83 ec 04             	sub    $0x4,%esp
  802393:	68 f8 0f 00 00       	push   $0xff8
  802398:	52                   	push   %edx
  802399:	68 08 60 80 00       	push   $0x806008
  80239e:	e8 47 ef ff ff       	call   8012ea <memmove>
  8023a3:	83 c4 10             	add    $0x10,%esp
  8023a6:	eb 17                	jmp    8023bf <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  8023a8:	a3 04 60 80 00       	mov    %eax,0x806004
		memmove(fsipcbuf.write.req_buf, buf, n);
  8023ad:	83 ec 04             	sub    $0x4,%esp
  8023b0:	50                   	push   %eax
  8023b1:	52                   	push   %edx
  8023b2:	68 08 60 80 00       	push   $0x806008
  8023b7:	e8 2e ef ff ff       	call   8012ea <memmove>
  8023bc:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  8023bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8023c4:	b8 04 00 00 00       	mov    $0x4,%eax
  8023c9:	e8 a9 fe ff ff       	call   802277 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  8023ce:	c9                   	leave  
  8023cf:	c3                   	ret    

008023d0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
  8023d3:	56                   	push   %esi
  8023d4:	53                   	push   %ebx
  8023d5:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8023d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023db:	8b 40 0c             	mov    0xc(%eax),%eax
  8023de:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8023e3:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8023e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8023ee:	b8 03 00 00 00       	mov    $0x3,%eax
  8023f3:	e8 7f fe ff ff       	call   802277 <fsipc>
  8023f8:	89 c3                	mov    %eax,%ebx
  8023fa:	85 c0                	test   %eax,%eax
  8023fc:	78 4b                	js     802449 <devfile_read+0x79>
		return r;
	assert(r <= n);
  8023fe:	39 c6                	cmp    %eax,%esi
  802400:	73 16                	jae    802418 <devfile_read+0x48>
  802402:	68 6c 3b 80 00       	push   $0x803b6c
  802407:	68 46 35 80 00       	push   $0x803546
  80240c:	6a 7c                	push   $0x7c
  80240e:	68 73 3b 80 00       	push   $0x803b73
  802413:	e8 01 e6 ff ff       	call   800a19 <_panic>
	assert(r <= PGSIZE);
  802418:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80241d:	7e 16                	jle    802435 <devfile_read+0x65>
  80241f:	68 7e 3b 80 00       	push   $0x803b7e
  802424:	68 46 35 80 00       	push   $0x803546
  802429:	6a 7d                	push   $0x7d
  80242b:	68 73 3b 80 00       	push   $0x803b73
  802430:	e8 e4 e5 ff ff       	call   800a19 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802435:	83 ec 04             	sub    $0x4,%esp
  802438:	50                   	push   %eax
  802439:	68 00 60 80 00       	push   $0x806000
  80243e:	ff 75 0c             	pushl  0xc(%ebp)
  802441:	e8 a4 ee ff ff       	call   8012ea <memmove>
	return r;
  802446:	83 c4 10             	add    $0x10,%esp
}
  802449:	89 d8                	mov    %ebx,%eax
  80244b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80244e:	5b                   	pop    %ebx
  80244f:	5e                   	pop    %esi
  802450:	5d                   	pop    %ebp
  802451:	c3                   	ret    

00802452 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
  802455:	53                   	push   %ebx
  802456:	83 ec 20             	sub    $0x20,%esp
  802459:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80245c:	53                   	push   %ebx
  80245d:	e8 bc ec ff ff       	call   80111e <strlen>
  802462:	83 c4 10             	add    $0x10,%esp
  802465:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80246a:	7f 67                	jg     8024d3 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80246c:	83 ec 0c             	sub    $0xc,%esp
  80246f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802472:	50                   	push   %eax
  802473:	e8 78 f8 ff ff       	call   801cf0 <fd_alloc>
  802478:	83 c4 10             	add    $0x10,%esp
		return r;
  80247b:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80247d:	85 c0                	test   %eax,%eax
  80247f:	78 57                	js     8024d8 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  802481:	83 ec 08             	sub    $0x8,%esp
  802484:	53                   	push   %ebx
  802485:	68 00 60 80 00       	push   $0x806000
  80248a:	e8 c8 ec ff ff       	call   801157 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80248f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802492:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802497:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249a:	b8 01 00 00 00       	mov    $0x1,%eax
  80249f:	e8 d3 fd ff ff       	call   802277 <fsipc>
  8024a4:	89 c3                	mov    %eax,%ebx
  8024a6:	83 c4 10             	add    $0x10,%esp
  8024a9:	85 c0                	test   %eax,%eax
  8024ab:	79 14                	jns    8024c1 <open+0x6f>
		fd_close(fd, 0);
  8024ad:	83 ec 08             	sub    $0x8,%esp
  8024b0:	6a 00                	push   $0x0
  8024b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8024b5:	e8 2e f9 ff ff       	call   801de8 <fd_close>
		return r;
  8024ba:	83 c4 10             	add    $0x10,%esp
  8024bd:	89 da                	mov    %ebx,%edx
  8024bf:	eb 17                	jmp    8024d8 <open+0x86>
	}

	return fd2num(fd);
  8024c1:	83 ec 0c             	sub    $0xc,%esp
  8024c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8024c7:	e8 fc f7 ff ff       	call   801cc8 <fd2num>
  8024cc:	89 c2                	mov    %eax,%edx
  8024ce:	83 c4 10             	add    $0x10,%esp
  8024d1:	eb 05                	jmp    8024d8 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8024d3:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8024d8:	89 d0                	mov    %edx,%eax
  8024da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024dd:	c9                   	leave  
  8024de:	c3                   	ret    

008024df <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8024df:	55                   	push   %ebp
  8024e0:	89 e5                	mov    %esp,%ebp
  8024e2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8024e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8024ea:	b8 08 00 00 00       	mov    $0x8,%eax
  8024ef:	e8 83 fd ff ff       	call   802277 <fsipc>
}
  8024f4:	c9                   	leave  
  8024f5:	c3                   	ret    

008024f6 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8024f6:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8024fa:	7e 37                	jle    802533 <writebuf+0x3d>
};


static void
writebuf(struct printbuf *b)
{
  8024fc:	55                   	push   %ebp
  8024fd:	89 e5                	mov    %esp,%ebp
  8024ff:	53                   	push   %ebx
  802500:	83 ec 08             	sub    $0x8,%esp
  802503:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
		ssize_t result = write(b->fd, b->buf, b->idx);
  802505:	ff 70 04             	pushl  0x4(%eax)
  802508:	8d 40 10             	lea    0x10(%eax),%eax
  80250b:	50                   	push   %eax
  80250c:	ff 33                	pushl  (%ebx)
  80250e:	e8 6b fb ff ff       	call   80207e <write>
		if (result > 0)
  802513:	83 c4 10             	add    $0x10,%esp
  802516:	85 c0                	test   %eax,%eax
  802518:	7e 03                	jle    80251d <writebuf+0x27>
			b->result += result;
  80251a:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80251d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802520:	74 0d                	je     80252f <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  802522:	85 c0                	test   %eax,%eax
  802524:	ba 00 00 00 00       	mov    $0x0,%edx
  802529:	0f 4f c2             	cmovg  %edx,%eax
  80252c:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80252f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802532:	c9                   	leave  
  802533:	f3 c3                	repz ret 

00802535 <putch>:

static void
putch(int ch, void *thunk)
{
  802535:	55                   	push   %ebp
  802536:	89 e5                	mov    %esp,%ebp
  802538:	53                   	push   %ebx
  802539:	83 ec 04             	sub    $0x4,%esp
  80253c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80253f:	8b 53 04             	mov    0x4(%ebx),%edx
  802542:	8d 42 01             	lea    0x1(%edx),%eax
  802545:	89 43 04             	mov    %eax,0x4(%ebx)
  802548:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80254b:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80254f:	3d 00 01 00 00       	cmp    $0x100,%eax
  802554:	75 0e                	jne    802564 <putch+0x2f>
		writebuf(b);
  802556:	89 d8                	mov    %ebx,%eax
  802558:	e8 99 ff ff ff       	call   8024f6 <writebuf>
		b->idx = 0;
  80255d:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  802564:	83 c4 04             	add    $0x4,%esp
  802567:	5b                   	pop    %ebx
  802568:	5d                   	pop    %ebp
  802569:	c3                   	ret    

0080256a <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80256a:	55                   	push   %ebp
  80256b:	89 e5                	mov    %esp,%ebp
  80256d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  802573:	8b 45 08             	mov    0x8(%ebp),%eax
  802576:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  80257c:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  802583:	00 00 00 
	b.result = 0;
  802586:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80258d:	00 00 00 
	b.error = 1;
  802590:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  802597:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80259a:	ff 75 10             	pushl  0x10(%ebp)
  80259d:	ff 75 0c             	pushl  0xc(%ebp)
  8025a0:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8025a6:	50                   	push   %eax
  8025a7:	68 35 25 80 00       	push   $0x802535
  8025ac:	e8 aa e6 ff ff       	call   800c5b <vprintfmt>
	if (b.idx > 0)
  8025b1:	83 c4 10             	add    $0x10,%esp
  8025b4:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8025bb:	7e 0b                	jle    8025c8 <vfprintf+0x5e>
		writebuf(&b);
  8025bd:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8025c3:	e8 2e ff ff ff       	call   8024f6 <writebuf>

	return (b.result ? b.result : b.error);
  8025c8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8025ce:	85 c0                	test   %eax,%eax
  8025d0:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8025d7:	c9                   	leave  
  8025d8:	c3                   	ret    

008025d9 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8025d9:	55                   	push   %ebp
  8025da:	89 e5                	mov    %esp,%ebp
  8025dc:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8025df:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8025e2:	50                   	push   %eax
  8025e3:	ff 75 0c             	pushl  0xc(%ebp)
  8025e6:	ff 75 08             	pushl  0x8(%ebp)
  8025e9:	e8 7c ff ff ff       	call   80256a <vfprintf>
	va_end(ap);

	return cnt;
}
  8025ee:	c9                   	leave  
  8025ef:	c3                   	ret    

008025f0 <printf>:

int
printf(const char *fmt, ...)
{
  8025f0:	55                   	push   %ebp
  8025f1:	89 e5                	mov    %esp,%ebp
  8025f3:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8025f6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8025f9:	50                   	push   %eax
  8025fa:	ff 75 08             	pushl  0x8(%ebp)
  8025fd:	6a 01                	push   $0x1
  8025ff:	e8 66 ff ff ff       	call   80256a <vfprintf>
	va_end(ap);

	return cnt;
}
  802604:	c9                   	leave  
  802605:	c3                   	ret    

00802606 <copy_shared_pages>:
}

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  802606:	55                   	push   %ebp
  802607:	89 e5                	mov    %esp,%ebp
  802609:	57                   	push   %edi
  80260a:	56                   	push   %esi
  80260b:	53                   	push   %ebx
  80260c:	83 ec 1c             	sub    $0x1c,%esp
  80260f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802612:	bf 00 04 00 00       	mov    $0x400,%edi
	// LAB 5: Your code here.
	unsigned int pn;
	void* addr;
  	for (int i = 0; i < NPDENTRIES; ++i) {
  802617:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80261e:	eb 7d                	jmp    80269d <copy_shared_pages+0x97>
	    for (int j = 0; j < NPTENTRIES; ++j) {
    	  pn = i*NPDENTRIES + j;
    	  addr = (void*) (pn*PGSIZE);
      	  if ((pn < (UTOP >> PGSHIFT)) && uvpd[i]) {
  802620:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  802626:	77 54                	ja     80267c <copy_shared_pages+0x76>
  802628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802632:	85 c0                	test   %eax,%eax
  802634:	74 46                	je     80267c <copy_shared_pages+0x76>
        	if (uvpt[pn] & PTE_SHARE) {
  802636:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80263d:	f6 c4 04             	test   $0x4,%ah
  802640:	74 3a                	je     80267c <copy_shared_pages+0x76>
          		if (sys_page_map(0, addr, child, addr, uvpt[pn] & PTE_SYSCALL) < 0) {
  802642:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  802649:	83 ec 0c             	sub    $0xc,%esp
  80264c:	25 07 0e 00 00       	and    $0xe07,%eax
  802651:	50                   	push   %eax
  802652:	56                   	push   %esi
  802653:	ff 75 e0             	pushl  -0x20(%ebp)
  802656:	56                   	push   %esi
  802657:	6a 00                	push   $0x0
  802659:	e8 66 ef ff ff       	call   8015c4 <sys_page_map>
  80265e:	83 c4 20             	add    $0x20,%esp
  802661:	85 c0                	test   %eax,%eax
  802663:	79 17                	jns    80267c <copy_shared_pages+0x76>
              		panic("Error en sys_page_map");
  802665:	83 ec 04             	sub    $0x4,%esp
  802668:	68 7a 39 80 00       	push   $0x80397a
  80266d:	68 4f 01 00 00       	push   $0x14f
  802672:	68 8a 3b 80 00       	push   $0x803b8a
  802677:	e8 9d e3 ff ff       	call   800a19 <_panic>
  80267c:	83 c3 01             	add    $0x1,%ebx
  80267f:	81 c6 00 10 00 00    	add    $0x1000,%esi
{
	// LAB 5: Your code here.
	unsigned int pn;
	void* addr;
  	for (int i = 0; i < NPDENTRIES; ++i) {
	    for (int j = 0; j < NPTENTRIES; ++j) {
  802685:	39 fb                	cmp    %edi,%ebx
  802687:	75 97                	jne    802620 <copy_shared_pages+0x1a>
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	unsigned int pn;
	void* addr;
  	for (int i = 0; i < NPDENTRIES; ++i) {
  802689:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  80268d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802690:	81 c7 00 04 00 00    	add    $0x400,%edi
  802696:	3d 00 04 00 00       	cmp    $0x400,%eax
  80269b:	74 10                	je     8026ad <copy_shared_pages+0xa7>
  80269d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8026a0:	89 f3                	mov    %esi,%ebx
  8026a2:	c1 e3 0a             	shl    $0xa,%ebx
  8026a5:	c1 e6 16             	shl    $0x16,%esi
  8026a8:	e9 73 ff ff ff       	jmp    802620 <copy_shared_pages+0x1a>
        	} 
      	  }
    	}
	}
	return 0;
}
  8026ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026b5:	5b                   	pop    %ebx
  8026b6:	5e                   	pop    %esi
  8026b7:	5f                   	pop    %edi
  8026b8:	5d                   	pop    %ebp
  8026b9:	c3                   	ret    

008026ba <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  8026ba:	55                   	push   %ebp
  8026bb:	89 e5                	mov    %esp,%ebp
  8026bd:	57                   	push   %edi
  8026be:	56                   	push   %esi
  8026bf:	53                   	push   %ebx
  8026c0:	83 ec 2c             	sub    $0x2c,%esp
  8026c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026c6:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8026c9:	89 4d cc             	mov    %ecx,-0x34(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8026cc:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8026d1:	be 00 00 00 00       	mov    $0x0,%esi
  8026d6:	89 d7                	mov    %edx,%edi
	for (argc = 0; argv[argc] != 0; argc++)
  8026d8:	eb 13                	jmp    8026ed <init_stack+0x33>
		string_size += strlen(argv[argc]) + 1;
  8026da:	83 ec 0c             	sub    $0xc,%esp
  8026dd:	50                   	push   %eax
  8026de:	e8 3b ea ff ff       	call   80111e <strlen>
  8026e3:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8026e7:	83 c3 01             	add    $0x1,%ebx
  8026ea:	83 c4 10             	add    $0x10,%esp
  8026ed:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8026f4:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8026f7:	85 c0                	test   %eax,%eax
  8026f9:	75 df                	jne    8026da <init_stack+0x20>
  8026fb:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  8026fe:	89 4d d8             	mov    %ecx,-0x28(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char *) UTEMP + PGSIZE - string_size;
  802701:	bf 00 10 40 00       	mov    $0x401000,%edi
  802706:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t *) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802708:	89 fa                	mov    %edi,%edx
  80270a:	83 e2 fc             	and    $0xfffffffc,%edx
  80270d:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802714:	29 c2                	sub    %eax,%edx
  802716:	89 55 e4             	mov    %edx,-0x1c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void *) (argv_store - 2) < (void *) UTEMP)
  802719:	8d 42 f8             	lea    -0x8(%edx),%eax
  80271c:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802721:	0f 86 fc 00 00 00    	jbe    802823 <init_stack+0x169>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void *) UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  802727:	83 ec 04             	sub    $0x4,%esp
  80272a:	6a 07                	push   $0x7
  80272c:	68 00 00 40 00       	push   $0x400000
  802731:	6a 00                	push   $0x0
  802733:	e8 68 ee ff ff       	call   8015a0 <sys_page_alloc>
  802738:	83 c4 10             	add    $0x10,%esp
  80273b:	85 c0                	test   %eax,%eax
  80273d:	0f 88 e5 00 00 00    	js     802828 <init_stack+0x16e>
  802743:	be 00 00 00 00       	mov    $0x0,%esi
  802748:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  80274b:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80274e:	eb 2d                	jmp    80277d <init_stack+0xc3>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  802750:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802756:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  802759:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  80275c:	83 ec 08             	sub    $0x8,%esp
  80275f:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802762:	57                   	push   %edi
  802763:	e8 ef e9 ff ff       	call   801157 <strcpy>
		string_store += strlen(argv[i]) + 1;
  802768:	83 c4 04             	add    $0x4,%esp
  80276b:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80276e:	e8 ab e9 ff ff       	call   80111e <strlen>
  802773:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802777:	83 c6 01             	add    $0x1,%esi
  80277a:	83 c4 10             	add    $0x10,%esp
  80277d:	39 75 e0             	cmp    %esi,-0x20(%ebp)
  802780:	7f ce                	jg     802750 <init_stack+0x96>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  802782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802785:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  802788:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char *) UTEMP + PGSIZE);
  80278f:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802795:	74 19                	je     8027b0 <init_stack+0xf6>
  802797:	68 00 3c 80 00       	push   $0x803c00
  80279c:	68 46 35 80 00       	push   $0x803546
  8027a1:	68 fc 00 00 00       	push   $0xfc
  8027a6:	68 8a 3b 80 00       	push   $0x803b8a
  8027ab:	e8 69 e2 ff ff       	call   800a19 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8027b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027b3:	89 d0                	mov    %edx,%eax
  8027b5:	2d 00 30 80 11       	sub    $0x11803000,%eax
  8027ba:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  8027bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027c0:	89 42 f8             	mov    %eax,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8027c3:	8d 82 f8 cf 7f ee    	lea    -0x11803008(%edx),%eax
  8027c9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8027cc:	89 01                	mov    %eax,(%ecx)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0,
  8027ce:	83 ec 0c             	sub    $0xc,%esp
  8027d1:	6a 07                	push   $0x7
  8027d3:	68 00 d0 bf ee       	push   $0xeebfd000
  8027d8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8027db:	68 00 00 40 00       	push   $0x400000
  8027e0:	6a 00                	push   $0x0
  8027e2:	e8 dd ed ff ff       	call   8015c4 <sys_page_map>
  8027e7:	89 c3                	mov    %eax,%ebx
  8027e9:	83 c4 20             	add    $0x20,%esp
  8027ec:	85 c0                	test   %eax,%eax
  8027ee:	78 1d                	js     80280d <init_stack+0x153>
	                      UTEMP,
	                      child,
	                      (void *) (USTACKTOP - PGSIZE),
	                      PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8027f0:	83 ec 08             	sub    $0x8,%esp
  8027f3:	68 00 00 40 00       	push   $0x400000
  8027f8:	6a 00                	push   $0x0
  8027fa:	e8 eb ed ff ff       	call   8015ea <sys_page_unmap>
  8027ff:	89 c3                	mov    %eax,%ebx
  802801:	83 c4 10             	add    $0x10,%esp
		goto error;

	return 0;
  802804:	b8 00 00 00 00       	mov    $0x0,%eax
	                      UTEMP,
	                      child,
	                      (void *) (USTACKTOP - PGSIZE),
	                      PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802809:	85 db                	test   %ebx,%ebx
  80280b:	79 1b                	jns    802828 <init_stack+0x16e>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  80280d:	83 ec 08             	sub    $0x8,%esp
  802810:	68 00 00 40 00       	push   $0x400000
  802815:	6a 00                	push   $0x0
  802817:	e8 ce ed ff ff       	call   8015ea <sys_page_unmap>
	return r;
  80281c:	83 c4 10             	add    $0x10,%esp
  80281f:	89 d8                	mov    %ebx,%eax
  802821:	eb 05                	jmp    802828 <init_stack+0x16e>
	argv_store = (uintptr_t *) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void *) (argv_store - 2) < (void *) UTEMP)
		return -E_NO_MEM;
  802823:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return 0;

error:
	sys_page_unmap(0, UTEMP);
	return r;
}
  802828:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80282b:	5b                   	pop    %ebx
  80282c:	5e                   	pop    %esi
  80282d:	5f                   	pop    %edi
  80282e:	5d                   	pop    %ebp
  80282f:	c3                   	ret    

00802830 <map_segment>:
            size_t memsz,
            int fd,
            size_t filesz,
            off_t fileoffset,
            int perm)
{
  802830:	55                   	push   %ebp
  802831:	89 e5                	mov    %esp,%ebp
  802833:	57                   	push   %edi
  802834:	56                   	push   %esi
  802835:	53                   	push   %ebx
  802836:	83 ec 1c             	sub    $0x1c,%esp
  802839:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80283c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	int i, r;
	void *blk;

	// cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  80283f:	89 d0                	mov    %edx,%eax
  802841:	25 ff 0f 00 00       	and    $0xfff,%eax
  802846:	74 0d                	je     802855 <map_segment+0x25>
		va -= i;
  802848:	29 c2                	sub    %eax,%edx
		memsz += i;
  80284a:	01 c1                	add    %eax,%ecx
  80284c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		filesz += i;
  80284f:	01 45 0c             	add    %eax,0xc(%ebp)
		fileoffset -= i;
  802852:	29 45 10             	sub    %eax,0x10(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802855:	89 d6                	mov    %edx,%esi
  802857:	bb 00 00 00 00       	mov    $0x0,%ebx
  80285c:	e9 d6 00 00 00       	jmp    802937 <map_segment+0x107>
		if (i >= filesz) {
  802861:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
  802864:	77 1f                	ja     802885 <map_segment+0x55>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void *) (va + i), perm)) < 0)
  802866:	83 ec 04             	sub    $0x4,%esp
  802869:	ff 75 14             	pushl  0x14(%ebp)
  80286c:	56                   	push   %esi
  80286d:	ff 75 e0             	pushl  -0x20(%ebp)
  802870:	e8 2b ed ff ff       	call   8015a0 <sys_page_alloc>
  802875:	83 c4 10             	add    $0x10,%esp
  802878:	85 c0                	test   %eax,%eax
  80287a:	0f 89 ab 00 00 00    	jns    80292b <map_segment+0xfb>
  802880:	e9 c2 00 00 00       	jmp    802947 <map_segment+0x117>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W)) <
  802885:	83 ec 04             	sub    $0x4,%esp
  802888:	6a 07                	push   $0x7
  80288a:	68 00 00 40 00       	push   $0x400000
  80288f:	6a 00                	push   $0x0
  802891:	e8 0a ed ff ff       	call   8015a0 <sys_page_alloc>
  802896:	83 c4 10             	add    $0x10,%esp
  802899:	85 c0                	test   %eax,%eax
  80289b:	0f 88 a6 00 00 00    	js     802947 <map_segment+0x117>
			    0)
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8028a1:	83 ec 08             	sub    $0x8,%esp
  8028a4:	89 f8                	mov    %edi,%eax
  8028a6:	03 45 10             	add    0x10(%ebp),%eax
  8028a9:	50                   	push   %eax
  8028aa:	ff 75 08             	pushl  0x8(%ebp)
  8028ad:	e8 58 f8 ff ff       	call   80210a <seek>
  8028b2:	83 c4 10             	add    $0x10,%esp
  8028b5:	85 c0                	test   %eax,%eax
  8028b7:	0f 88 8a 00 00 00    	js     802947 <map_segment+0x117>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz - i))) < 0)
  8028bd:	83 ec 04             	sub    $0x4,%esp
  8028c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028c3:	29 f8                	sub    %edi,%eax
  8028c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8028ca:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8028cf:	0f 47 c1             	cmova  %ecx,%eax
  8028d2:	50                   	push   %eax
  8028d3:	68 00 00 40 00       	push   $0x400000
  8028d8:	ff 75 08             	pushl  0x8(%ebp)
  8028db:	e8 55 f7 ff ff       	call   802035 <readn>
  8028e0:	83 c4 10             	add    $0x10,%esp
  8028e3:	85 c0                	test   %eax,%eax
  8028e5:	78 60                	js     802947 <map_segment+0x117>
				return r;
			if ((r = sys_page_map(
  8028e7:	83 ec 0c             	sub    $0xc,%esp
  8028ea:	ff 75 14             	pushl  0x14(%ebp)
  8028ed:	56                   	push   %esi
  8028ee:	ff 75 e0             	pushl  -0x20(%ebp)
  8028f1:	68 00 00 40 00       	push   $0x400000
  8028f6:	6a 00                	push   $0x0
  8028f8:	e8 c7 ec ff ff       	call   8015c4 <sys_page_map>
  8028fd:	83 c4 20             	add    $0x20,%esp
  802900:	85 c0                	test   %eax,%eax
  802902:	79 15                	jns    802919 <map_segment+0xe9>
			             0, UTEMP, child, (void *) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
  802904:	50                   	push   %eax
  802905:	68 96 3b 80 00       	push   $0x803b96
  80290a:	68 3a 01 00 00       	push   $0x13a
  80290f:	68 8a 3b 80 00       	push   $0x803b8a
  802914:	e8 00 e1 ff ff       	call   800a19 <_panic>
			sys_page_unmap(0, UTEMP);
  802919:	83 ec 08             	sub    $0x8,%esp
  80291c:	68 00 00 40 00       	push   $0x400000
  802921:	6a 00                	push   $0x0
  802923:	e8 c2 ec ff ff       	call   8015ea <sys_page_unmap>
  802928:	83 c4 10             	add    $0x10,%esp
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80292b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802931:	81 c6 00 10 00 00    	add    $0x1000,%esi
  802937:	89 df                	mov    %ebx,%edi
  802939:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
  80293c:	0f 87 1f ff ff ff    	ja     802861 <map_segment+0x31>
			             0, UTEMP, child, (void *) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  802942:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802947:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80294a:	5b                   	pop    %ebx
  80294b:	5e                   	pop    %esi
  80294c:	5f                   	pop    %edi
  80294d:	5d                   	pop    %ebp
  80294e:	c3                   	ret    

0080294f <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80294f:	55                   	push   %ebp
  802950:	89 e5                	mov    %esp,%ebp
  802952:	57                   	push   %edi
  802953:	56                   	push   %esi
  802954:	53                   	push   %ebx
  802955:	81 ec 74 02 00 00    	sub    $0x274,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80295b:	6a 00                	push   $0x0
  80295d:	ff 75 08             	pushl  0x8(%ebp)
  802960:	e8 ed fa ff ff       	call   802452 <open>
  802965:	89 c7                	mov    %eax,%edi
  802967:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80296d:	83 c4 10             	add    $0x10,%esp
  802970:	85 c0                	test   %eax,%eax
  802972:	0f 88 e3 01 00 00    	js     802b5b <spawn+0x20c>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf *) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf) ||
  802978:	83 ec 04             	sub    $0x4,%esp
  80297b:	68 00 02 00 00       	push   $0x200
  802980:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802986:	50                   	push   %eax
  802987:	57                   	push   %edi
  802988:	e8 a8 f6 ff ff       	call   802035 <readn>
  80298d:	83 c4 10             	add    $0x10,%esp
  802990:	3d 00 02 00 00       	cmp    $0x200,%eax
  802995:	75 0c                	jne    8029a3 <spawn+0x54>
  802997:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  80299e:	45 4c 46 
  8029a1:	74 33                	je     8029d6 <spawn+0x87>
	    elf->e_magic != ELF_MAGIC) {
		close(fd);
  8029a3:	83 ec 0c             	sub    $0xc,%esp
  8029a6:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8029ac:	e8 b7 f4 ff ff       	call   801e68 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8029b1:	83 c4 0c             	add    $0xc,%esp
  8029b4:	68 7f 45 4c 46       	push   $0x464c457f
  8029b9:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  8029bf:	68 b3 3b 80 00       	push   $0x803bb3
  8029c4:	e8 29 e1 ff ff       	call   800af2 <cprintf>
		return -E_NOT_EXEC;
  8029c9:	83 c4 10             	add    $0x10,%esp
  8029cc:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8029d1:	e9 9b 01 00 00       	jmp    802b71 <spawn+0x222>
  8029d6:	b8 07 00 00 00       	mov    $0x7,%eax
  8029db:	cd 30                	int    $0x30
  8029dd:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  8029e3:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8029e9:	89 c3                	mov    %eax,%ebx
  8029eb:	85 c0                	test   %eax,%eax
  8029ed:	0f 88 70 01 00 00    	js     802b63 <spawn+0x214>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8029f3:	89 c6                	mov    %eax,%esi
  8029f5:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  8029fb:	6b f6 7c             	imul   $0x7c,%esi,%esi
  8029fe:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  802a04:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802a0a:	b9 11 00 00 00       	mov    $0x11,%ecx
  802a0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  802a11:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802a17:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
  802a1d:	8d 8d e0 fd ff ff    	lea    -0x220(%ebp),%ecx
  802a23:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a26:	89 d8                	mov    %ebx,%eax
  802a28:	e8 8d fc ff ff       	call   8026ba <init_stack>
  802a2d:	85 c0                	test   %eax,%eax
  802a2f:	0f 88 3c 01 00 00    	js     802b71 <spawn+0x222>
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr *) (elf_buf + elf->e_phoff);
  802a35:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802a3b:	8d 9c 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%ebx
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802a42:	be 00 00 00 00       	mov    $0x0,%esi
  802a47:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  802a4d:	eb 40                	jmp    802a8f <spawn+0x140>
		if (ph->p_type != ELF_PROG_LOAD)
  802a4f:	83 3b 01             	cmpl   $0x1,(%ebx)
  802a52:	75 35                	jne    802a89 <spawn+0x13a>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802a54:	8b 43 18             	mov    0x18(%ebx),%eax
  802a57:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802a5a:	83 f8 01             	cmp    $0x1,%eax
  802a5d:	19 c0                	sbb    %eax,%eax
  802a5f:	83 e0 fe             	and    $0xfffffffe,%eax
  802a62:	83 c0 07             	add    $0x7,%eax
		if ((r = map_segment(child,
  802a65:	8b 4b 14             	mov    0x14(%ebx),%ecx
  802a68:	8b 53 08             	mov    0x8(%ebx),%edx
  802a6b:	50                   	push   %eax
  802a6c:	ff 73 04             	pushl  0x4(%ebx)
  802a6f:	ff 73 10             	pushl  0x10(%ebx)
  802a72:	57                   	push   %edi
  802a73:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802a79:	e8 b2 fd ff ff       	call   802830 <map_segment>
  802a7e:	83 c4 10             	add    $0x10,%esp
  802a81:	85 c0                	test   %eax,%eax
  802a83:	0f 88 ad 00 00 00    	js     802b36 <spawn+0x1e7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr *) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802a89:	83 c6 01             	add    $0x1,%esi
  802a8c:	83 c3 20             	add    $0x20,%ebx
  802a8f:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802a96:	39 c6                	cmp    %eax,%esi
  802a98:	7c b5                	jl     802a4f <spawn+0x100>
		                     ph->p_filesz,
		                     ph->p_offset,
		                     perm)) < 0)
			goto error;
	}
	close(fd);
  802a9a:	83 ec 0c             	sub    $0xc,%esp
  802a9d:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802aa3:	e8 c0 f3 ff ff       	call   801e68 <close>
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802aa8:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802aae:	e8 53 fb ff ff       	call   802606 <copy_shared_pages>
  802ab3:	83 c4 10             	add    $0x10,%esp
  802ab6:	85 c0                	test   %eax,%eax
  802ab8:	79 15                	jns    802acf <spawn+0x180>
		panic("copy_shared_pages: %e", r);
  802aba:	50                   	push   %eax
  802abb:	68 cd 3b 80 00       	push   $0x803bcd
  802ac0:	68 8c 00 00 00       	push   $0x8c
  802ac5:	68 8a 3b 80 00       	push   $0x803b8a
  802aca:	e8 4a df ff ff       	call   800a19 <_panic>

	child_tf.tf_eflags |= FL_IOPL_3;  // devious: see user/faultio.c
  802acf:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  802ad6:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802ad9:	83 ec 08             	sub    $0x8,%esp
  802adc:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802ae2:	50                   	push   %eax
  802ae3:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802ae9:	e8 42 eb ff ff       	call   801630 <sys_env_set_trapframe>
  802aee:	83 c4 10             	add    $0x10,%esp
  802af1:	85 c0                	test   %eax,%eax
  802af3:	79 15                	jns    802b0a <spawn+0x1bb>
		panic("sys_env_set_trapframe: %e", r);
  802af5:	50                   	push   %eax
  802af6:	68 e3 3b 80 00       	push   $0x803be3
  802afb:	68 90 00 00 00       	push   $0x90
  802b00:	68 8a 3b 80 00       	push   $0x803b8a
  802b05:	e8 0f df ff ff       	call   800a19 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802b0a:	83 ec 08             	sub    $0x8,%esp
  802b0d:	6a 02                	push   $0x2
  802b0f:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802b15:	e8 f3 ea ff ff       	call   80160d <sys_env_set_status>
  802b1a:	83 c4 10             	add    $0x10,%esp
  802b1d:	85 c0                	test   %eax,%eax
  802b1f:	79 4a                	jns    802b6b <spawn+0x21c>
		panic("sys_env_set_status: %e", r);
  802b21:	50                   	push   %eax
  802b22:	68 69 3a 80 00       	push   $0x803a69
  802b27:	68 93 00 00 00       	push   $0x93
  802b2c:	68 8a 3b 80 00       	push   $0x803b8a
  802b31:	e8 e3 de ff ff       	call   800a19 <_panic>
  802b36:	89 c7                	mov    %eax,%edi

	return child;

error:
	sys_env_destroy(child);
  802b38:	83 ec 0c             	sub    $0xc,%esp
  802b3b:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802b41:	e8 ed e9 ff ff       	call   801533 <sys_env_destroy>
	close(fd);
  802b46:	83 c4 04             	add    $0x4,%esp
  802b49:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802b4f:	e8 14 f3 ff ff       	call   801e68 <close>
	return r;
  802b54:	83 c4 10             	add    $0x10,%esp
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child,
  802b57:	89 f8                	mov    %edi,%eax
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  802b59:	eb 16                	jmp    802b71 <spawn+0x222>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  802b5b:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802b61:	eb 0e                	jmp    802b71 <spawn+0x222>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  802b63:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802b69:	eb 06                	jmp    802b71 <spawn+0x222>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  802b6b:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  802b71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802b74:	5b                   	pop    %ebx
  802b75:	5e                   	pop    %esi
  802b76:	5f                   	pop    %edi
  802b77:	5d                   	pop    %ebp
  802b78:	c3                   	ret    

00802b79 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802b79:	55                   	push   %ebp
  802b7a:	89 e5                	mov    %esp,%ebp
  802b7c:	56                   	push   %esi
  802b7d:	53                   	push   %ebx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc = 0;
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  802b7e:	8d 55 10             	lea    0x10(%ebp),%edx
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc = 0;
  802b81:	b8 00 00 00 00       	mov    $0x0,%eax
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  802b86:	eb 03                	jmp    802b8b <spawnl+0x12>
		argc++;
  802b88:	83 c0 01             	add    $0x1,%eax
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc = 0;
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  802b8b:	83 c2 04             	add    $0x4,%edx
  802b8e:	83 7a fc 00          	cmpl   $0x0,-0x4(%edx)
  802b92:	75 f4                	jne    802b88 <spawnl+0xf>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc + 2];
  802b94:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  802b9b:	83 e2 f0             	and    $0xfffffff0,%edx
  802b9e:	29 d4                	sub    %edx,%esp
  802ba0:	8d 54 24 03          	lea    0x3(%esp),%edx
  802ba4:	c1 ea 02             	shr    $0x2,%edx
  802ba7:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  802bae:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802bb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802bb3:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc + 1] = NULL;
  802bba:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802bc1:	00 
  802bc2:	89 c2                	mov    %eax,%edx

	va_start(vl, arg0);
	unsigned i;
	for (i = 0; i < argc; i++)
  802bc4:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc9:	eb 0a                	jmp    802bd5 <spawnl+0x5c>
		argv[i + 1] = va_arg(vl, const char *);
  802bcb:	83 c0 01             	add    $0x1,%eax
  802bce:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  802bd2:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc + 1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for (i = 0; i < argc; i++)
  802bd5:	39 d0                	cmp    %edx,%eax
  802bd7:	75 f2                	jne    802bcb <spawnl+0x52>
		argv[i + 1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802bd9:	83 ec 08             	sub    $0x8,%esp
  802bdc:	56                   	push   %esi
  802bdd:	ff 75 08             	pushl  0x8(%ebp)
  802be0:	e8 6a fd ff ff       	call   80294f <spawn>
}
  802be5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802be8:	5b                   	pop    %ebx
  802be9:	5e                   	pop    %esi
  802bea:	5d                   	pop    %ebp
  802beb:	c3                   	ret    

00802bec <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802bec:	55                   	push   %ebp
  802bed:	89 e5                	mov    %esp,%ebp
  802bef:	56                   	push   %esi
  802bf0:	53                   	push   %ebx
  802bf1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802bf4:	83 ec 0c             	sub    $0xc,%esp
  802bf7:	ff 75 08             	pushl  0x8(%ebp)
  802bfa:	e8 d9 f0 ff ff       	call   801cd8 <fd2data>
  802bff:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802c01:	83 c4 08             	add    $0x8,%esp
  802c04:	68 28 3c 80 00       	push   $0x803c28
  802c09:	53                   	push   %ebx
  802c0a:	e8 48 e5 ff ff       	call   801157 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802c0f:	8b 46 04             	mov    0x4(%esi),%eax
  802c12:	2b 06                	sub    (%esi),%eax
  802c14:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802c1a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802c21:	00 00 00 
	stat->st_dev = &devpipe;
  802c24:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802c2b:	40 80 00 
	return 0;
}
  802c2e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c33:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c36:	5b                   	pop    %ebx
  802c37:	5e                   	pop    %esi
  802c38:	5d                   	pop    %ebp
  802c39:	c3                   	ret    

00802c3a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802c3a:	55                   	push   %ebp
  802c3b:	89 e5                	mov    %esp,%ebp
  802c3d:	53                   	push   %ebx
  802c3e:	83 ec 0c             	sub    $0xc,%esp
  802c41:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802c44:	53                   	push   %ebx
  802c45:	6a 00                	push   $0x0
  802c47:	e8 9e e9 ff ff       	call   8015ea <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802c4c:	89 1c 24             	mov    %ebx,(%esp)
  802c4f:	e8 84 f0 ff ff       	call   801cd8 <fd2data>
  802c54:	83 c4 08             	add    $0x8,%esp
  802c57:	50                   	push   %eax
  802c58:	6a 00                	push   $0x0
  802c5a:	e8 8b e9 ff ff       	call   8015ea <sys_page_unmap>
}
  802c5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c62:	c9                   	leave  
  802c63:	c3                   	ret    

00802c64 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802c64:	55                   	push   %ebp
  802c65:	89 e5                	mov    %esp,%ebp
  802c67:	57                   	push   %edi
  802c68:	56                   	push   %esi
  802c69:	53                   	push   %ebx
  802c6a:	83 ec 1c             	sub    $0x1c,%esp
  802c6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802c70:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802c72:	a1 24 54 80 00       	mov    0x805424,%eax
  802c77:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  802c7a:	83 ec 0c             	sub    $0xc,%esp
  802c7d:	ff 75 e0             	pushl  -0x20(%ebp)
  802c80:	e8 9d 04 00 00       	call   803122 <pageref>
  802c85:	89 c3                	mov    %eax,%ebx
  802c87:	89 3c 24             	mov    %edi,(%esp)
  802c8a:	e8 93 04 00 00       	call   803122 <pageref>
  802c8f:	83 c4 10             	add    $0x10,%esp
  802c92:	39 c3                	cmp    %eax,%ebx
  802c94:	0f 94 c1             	sete   %cl
  802c97:	0f b6 c9             	movzbl %cl,%ecx
  802c9a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  802c9d:	8b 15 24 54 80 00    	mov    0x805424,%edx
  802ca3:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802ca6:	39 ce                	cmp    %ecx,%esi
  802ca8:	74 1b                	je     802cc5 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802caa:	39 c3                	cmp    %eax,%ebx
  802cac:	75 c4                	jne    802c72 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802cae:	8b 42 58             	mov    0x58(%edx),%eax
  802cb1:	ff 75 e4             	pushl  -0x1c(%ebp)
  802cb4:	50                   	push   %eax
  802cb5:	56                   	push   %esi
  802cb6:	68 2f 3c 80 00       	push   $0x803c2f
  802cbb:	e8 32 de ff ff       	call   800af2 <cprintf>
  802cc0:	83 c4 10             	add    $0x10,%esp
  802cc3:	eb ad                	jmp    802c72 <_pipeisclosed+0xe>
	}
}
  802cc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ccb:	5b                   	pop    %ebx
  802ccc:	5e                   	pop    %esi
  802ccd:	5f                   	pop    %edi
  802cce:	5d                   	pop    %ebp
  802ccf:	c3                   	ret    

00802cd0 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802cd0:	55                   	push   %ebp
  802cd1:	89 e5                	mov    %esp,%ebp
  802cd3:	57                   	push   %edi
  802cd4:	56                   	push   %esi
  802cd5:	53                   	push   %ebx
  802cd6:	83 ec 28             	sub    $0x28,%esp
  802cd9:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802cdc:	56                   	push   %esi
  802cdd:	e8 f6 ef ff ff       	call   801cd8 <fd2data>
  802ce2:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802ce4:	83 c4 10             	add    $0x10,%esp
  802ce7:	bf 00 00 00 00       	mov    $0x0,%edi
  802cec:	eb 4b                	jmp    802d39 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802cee:	89 da                	mov    %ebx,%edx
  802cf0:	89 f0                	mov    %esi,%eax
  802cf2:	e8 6d ff ff ff       	call   802c64 <_pipeisclosed>
  802cf7:	85 c0                	test   %eax,%eax
  802cf9:	75 48                	jne    802d43 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802cfb:	e8 79 e8 ff ff       	call   801579 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802d00:	8b 43 04             	mov    0x4(%ebx),%eax
  802d03:	8b 0b                	mov    (%ebx),%ecx
  802d05:	8d 51 20             	lea    0x20(%ecx),%edx
  802d08:	39 d0                	cmp    %edx,%eax
  802d0a:	73 e2                	jae    802cee <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802d0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802d0f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802d13:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802d16:	89 c2                	mov    %eax,%edx
  802d18:	c1 fa 1f             	sar    $0x1f,%edx
  802d1b:	89 d1                	mov    %edx,%ecx
  802d1d:	c1 e9 1b             	shr    $0x1b,%ecx
  802d20:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802d23:	83 e2 1f             	and    $0x1f,%edx
  802d26:	29 ca                	sub    %ecx,%edx
  802d28:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802d2c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802d30:	83 c0 01             	add    $0x1,%eax
  802d33:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802d36:	83 c7 01             	add    $0x1,%edi
  802d39:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802d3c:	75 c2                	jne    802d00 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802d3e:	8b 45 10             	mov    0x10(%ebp),%eax
  802d41:	eb 05                	jmp    802d48 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802d43:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  802d48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d4b:	5b                   	pop    %ebx
  802d4c:	5e                   	pop    %esi
  802d4d:	5f                   	pop    %edi
  802d4e:	5d                   	pop    %ebp
  802d4f:	c3                   	ret    

00802d50 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802d50:	55                   	push   %ebp
  802d51:	89 e5                	mov    %esp,%ebp
  802d53:	57                   	push   %edi
  802d54:	56                   	push   %esi
  802d55:	53                   	push   %ebx
  802d56:	83 ec 18             	sub    $0x18,%esp
  802d59:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802d5c:	57                   	push   %edi
  802d5d:	e8 76 ef ff ff       	call   801cd8 <fd2data>
  802d62:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802d64:	83 c4 10             	add    $0x10,%esp
  802d67:	bb 00 00 00 00       	mov    $0x0,%ebx
  802d6c:	eb 3d                	jmp    802dab <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802d6e:	85 db                	test   %ebx,%ebx
  802d70:	74 04                	je     802d76 <devpipe_read+0x26>
				return i;
  802d72:	89 d8                	mov    %ebx,%eax
  802d74:	eb 44                	jmp    802dba <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802d76:	89 f2                	mov    %esi,%edx
  802d78:	89 f8                	mov    %edi,%eax
  802d7a:	e8 e5 fe ff ff       	call   802c64 <_pipeisclosed>
  802d7f:	85 c0                	test   %eax,%eax
  802d81:	75 32                	jne    802db5 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802d83:	e8 f1 e7 ff ff       	call   801579 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802d88:	8b 06                	mov    (%esi),%eax
  802d8a:	3b 46 04             	cmp    0x4(%esi),%eax
  802d8d:	74 df                	je     802d6e <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802d8f:	99                   	cltd   
  802d90:	c1 ea 1b             	shr    $0x1b,%edx
  802d93:	01 d0                	add    %edx,%eax
  802d95:	83 e0 1f             	and    $0x1f,%eax
  802d98:	29 d0                	sub    %edx,%eax
  802d9a:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  802d9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802da2:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  802da5:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802da8:	83 c3 01             	add    $0x1,%ebx
  802dab:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802dae:	75 d8                	jne    802d88 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802db0:	8b 45 10             	mov    0x10(%ebp),%eax
  802db3:	eb 05                	jmp    802dba <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802db5:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802dba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802dbd:	5b                   	pop    %ebx
  802dbe:	5e                   	pop    %esi
  802dbf:	5f                   	pop    %edi
  802dc0:	5d                   	pop    %ebp
  802dc1:	c3                   	ret    

00802dc2 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802dc2:	55                   	push   %ebp
  802dc3:	89 e5                	mov    %esp,%ebp
  802dc5:	56                   	push   %esi
  802dc6:	53                   	push   %ebx
  802dc7:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802dca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802dcd:	50                   	push   %eax
  802dce:	e8 1d ef ff ff       	call   801cf0 <fd_alloc>
  802dd3:	83 c4 10             	add    $0x10,%esp
  802dd6:	89 c2                	mov    %eax,%edx
  802dd8:	85 c0                	test   %eax,%eax
  802dda:	0f 88 2c 01 00 00    	js     802f0c <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802de0:	83 ec 04             	sub    $0x4,%esp
  802de3:	68 07 04 00 00       	push   $0x407
  802de8:	ff 75 f4             	pushl  -0xc(%ebp)
  802deb:	6a 00                	push   $0x0
  802ded:	e8 ae e7 ff ff       	call   8015a0 <sys_page_alloc>
  802df2:	83 c4 10             	add    $0x10,%esp
  802df5:	89 c2                	mov    %eax,%edx
  802df7:	85 c0                	test   %eax,%eax
  802df9:	0f 88 0d 01 00 00    	js     802f0c <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802dff:	83 ec 0c             	sub    $0xc,%esp
  802e02:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802e05:	50                   	push   %eax
  802e06:	e8 e5 ee ff ff       	call   801cf0 <fd_alloc>
  802e0b:	89 c3                	mov    %eax,%ebx
  802e0d:	83 c4 10             	add    $0x10,%esp
  802e10:	85 c0                	test   %eax,%eax
  802e12:	0f 88 e2 00 00 00    	js     802efa <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e18:	83 ec 04             	sub    $0x4,%esp
  802e1b:	68 07 04 00 00       	push   $0x407
  802e20:	ff 75 f0             	pushl  -0x10(%ebp)
  802e23:	6a 00                	push   $0x0
  802e25:	e8 76 e7 ff ff       	call   8015a0 <sys_page_alloc>
  802e2a:	89 c3                	mov    %eax,%ebx
  802e2c:	83 c4 10             	add    $0x10,%esp
  802e2f:	85 c0                	test   %eax,%eax
  802e31:	0f 88 c3 00 00 00    	js     802efa <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802e37:	83 ec 0c             	sub    $0xc,%esp
  802e3a:	ff 75 f4             	pushl  -0xc(%ebp)
  802e3d:	e8 96 ee ff ff       	call   801cd8 <fd2data>
  802e42:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e44:	83 c4 0c             	add    $0xc,%esp
  802e47:	68 07 04 00 00       	push   $0x407
  802e4c:	50                   	push   %eax
  802e4d:	6a 00                	push   $0x0
  802e4f:	e8 4c e7 ff ff       	call   8015a0 <sys_page_alloc>
  802e54:	89 c3                	mov    %eax,%ebx
  802e56:	83 c4 10             	add    $0x10,%esp
  802e59:	85 c0                	test   %eax,%eax
  802e5b:	0f 88 89 00 00 00    	js     802eea <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e61:	83 ec 0c             	sub    $0xc,%esp
  802e64:	ff 75 f0             	pushl  -0x10(%ebp)
  802e67:	e8 6c ee ff ff       	call   801cd8 <fd2data>
  802e6c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802e73:	50                   	push   %eax
  802e74:	6a 00                	push   $0x0
  802e76:	56                   	push   %esi
  802e77:	6a 00                	push   $0x0
  802e79:	e8 46 e7 ff ff       	call   8015c4 <sys_page_map>
  802e7e:	89 c3                	mov    %eax,%ebx
  802e80:	83 c4 20             	add    $0x20,%esp
  802e83:	85 c0                	test   %eax,%eax
  802e85:	78 55                	js     802edc <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802e87:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e95:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802e9c:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea5:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eaa:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802eb1:	83 ec 0c             	sub    $0xc,%esp
  802eb4:	ff 75 f4             	pushl  -0xc(%ebp)
  802eb7:	e8 0c ee ff ff       	call   801cc8 <fd2num>
  802ebc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802ebf:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802ec1:	83 c4 04             	add    $0x4,%esp
  802ec4:	ff 75 f0             	pushl  -0x10(%ebp)
  802ec7:	e8 fc ed ff ff       	call   801cc8 <fd2num>
  802ecc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802ecf:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802ed2:	83 c4 10             	add    $0x10,%esp
  802ed5:	ba 00 00 00 00       	mov    $0x0,%edx
  802eda:	eb 30                	jmp    802f0c <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  802edc:	83 ec 08             	sub    $0x8,%esp
  802edf:	56                   	push   %esi
  802ee0:	6a 00                	push   $0x0
  802ee2:	e8 03 e7 ff ff       	call   8015ea <sys_page_unmap>
  802ee7:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  802eea:	83 ec 08             	sub    $0x8,%esp
  802eed:	ff 75 f0             	pushl  -0x10(%ebp)
  802ef0:	6a 00                	push   $0x0
  802ef2:	e8 f3 e6 ff ff       	call   8015ea <sys_page_unmap>
  802ef7:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  802efa:	83 ec 08             	sub    $0x8,%esp
  802efd:	ff 75 f4             	pushl  -0xc(%ebp)
  802f00:	6a 00                	push   $0x0
  802f02:	e8 e3 e6 ff ff       	call   8015ea <sys_page_unmap>
  802f07:	83 c4 10             	add    $0x10,%esp
  802f0a:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  802f0c:	89 d0                	mov    %edx,%eax
  802f0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f11:	5b                   	pop    %ebx
  802f12:	5e                   	pop    %esi
  802f13:	5d                   	pop    %ebp
  802f14:	c3                   	ret    

00802f15 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802f15:	55                   	push   %ebp
  802f16:	89 e5                	mov    %esp,%ebp
  802f18:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f1e:	50                   	push   %eax
  802f1f:	ff 75 08             	pushl  0x8(%ebp)
  802f22:	e8 18 ee ff ff       	call   801d3f <fd_lookup>
  802f27:	83 c4 10             	add    $0x10,%esp
  802f2a:	85 c0                	test   %eax,%eax
  802f2c:	78 18                	js     802f46 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802f2e:	83 ec 0c             	sub    $0xc,%esp
  802f31:	ff 75 f4             	pushl  -0xc(%ebp)
  802f34:	e8 9f ed ff ff       	call   801cd8 <fd2data>
	return _pipeisclosed(fd, p);
  802f39:	89 c2                	mov    %eax,%edx
  802f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3e:	e8 21 fd ff ff       	call   802c64 <_pipeisclosed>
  802f43:	83 c4 10             	add    $0x10,%esp
}
  802f46:	c9                   	leave  
  802f47:	c3                   	ret    

00802f48 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802f48:	55                   	push   %ebp
  802f49:	89 e5                	mov    %esp,%ebp
  802f4b:	56                   	push   %esi
  802f4c:	53                   	push   %ebx
  802f4d:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802f50:	85 f6                	test   %esi,%esi
  802f52:	75 16                	jne    802f6a <wait+0x22>
  802f54:	68 47 3c 80 00       	push   $0x803c47
  802f59:	68 46 35 80 00       	push   $0x803546
  802f5e:	6a 09                	push   $0x9
  802f60:	68 52 3c 80 00       	push   $0x803c52
  802f65:	e8 af da ff ff       	call   800a19 <_panic>
	e = &envs[ENVX(envid)];
  802f6a:	89 f3                	mov    %esi,%ebx
  802f6c:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802f72:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802f75:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802f7b:	eb 05                	jmp    802f82 <wait+0x3a>
		sys_yield();
  802f7d:	e8 f7 e5 ff ff       	call   801579 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802f82:	8b 43 48             	mov    0x48(%ebx),%eax
  802f85:	39 c6                	cmp    %eax,%esi
  802f87:	75 07                	jne    802f90 <wait+0x48>
  802f89:	8b 43 54             	mov    0x54(%ebx),%eax
  802f8c:	85 c0                	test   %eax,%eax
  802f8e:	75 ed                	jne    802f7d <wait+0x35>
		sys_yield();
}
  802f90:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f93:	5b                   	pop    %ebx
  802f94:	5e                   	pop    %esi
  802f95:	5d                   	pop    %ebp
  802f96:	c3                   	ret    

00802f97 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802f97:	55                   	push   %ebp
  802f98:	89 e5                	mov    %esp,%ebp
  802f9a:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802f9d:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802fa4:	75 2c                	jne    802fd2 <set_pgfault_handler+0x3b>
		// First time through!
		// LAB 4: Your code here.
		r = sys_page_alloc(0,(void *)(UXSTACKTOP - PGSIZE),PTE_P | PTE_U | PTE_W);
  802fa6:	83 ec 04             	sub    $0x4,%esp
  802fa9:	6a 07                	push   $0x7
  802fab:	68 00 f0 bf ee       	push   $0xeebff000
  802fb0:	6a 00                	push   $0x0
  802fb2:	e8 e9 e5 ff ff       	call   8015a0 <sys_page_alloc>
		if(r < 0)
  802fb7:	83 c4 10             	add    $0x10,%esp
  802fba:	85 c0                	test   %eax,%eax
  802fbc:	79 14                	jns    802fd2 <set_pgfault_handler+0x3b>
			panic("set_pgfault_handler: error in sys_page_alloc\n");	
  802fbe:	83 ec 04             	sub    $0x4,%esp
  802fc1:	68 60 3c 80 00       	push   $0x803c60
  802fc6:	6a 22                	push   $0x22
  802fc8:	68 cc 3c 80 00       	push   $0x803ccc
  802fcd:	e8 47 da ff ff       	call   800a19 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd5:	a3 00 70 80 00       	mov    %eax,0x807000
	r = sys_env_set_pgfault_upcall(0, _pgfault_upcall); 
  802fda:	83 ec 08             	sub    $0x8,%esp
  802fdd:	68 06 30 80 00       	push   $0x803006
  802fe2:	6a 00                	push   $0x0
  802fe4:	e8 6a e6 ff ff       	call   801653 <sys_env_set_pgfault_upcall>
	if (r < 0)
  802fe9:	83 c4 10             	add    $0x10,%esp
  802fec:	85 c0                	test   %eax,%eax
  802fee:	79 14                	jns    803004 <set_pgfault_handler+0x6d>
		panic("set_pgfault_handler: error in sys_env_set_pgfault_upcall");
  802ff0:	83 ec 04             	sub    $0x4,%esp
  802ff3:	68 90 3c 80 00       	push   $0x803c90
  802ff8:	6a 29                	push   $0x29
  802ffa:	68 cc 3c 80 00       	push   $0x803ccc
  802fff:	e8 15 da ff ff       	call   800a19 <_panic>
}
  803004:	c9                   	leave  
  803005:	c3                   	ret    

00803006 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803006:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803007:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  80300c:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80300e:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	subl $0x4, 0x30(%esp)
  803011:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  803016:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 0x28(%esp), %ebx 	
  80301a:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  80301e:	89 18                	mov    %ebx,(%eax)
	addl $0x8, %esp
  803020:	83 c4 08             	add    $0x8,%esp


	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  803023:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp 
  803024:	83 c4 04             	add    $0x4,%esp
	popfl
  803027:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  803028:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  803029:	c3                   	ret    

0080302a <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80302a:	55                   	push   %ebp
  80302b:	89 e5                	mov    %esp,%ebp
  80302d:	56                   	push   %esi
  80302e:	53                   	push   %ebx
  80302f:	8b 75 08             	mov    0x8(%ebp),%esi
  803032:	8b 45 0c             	mov    0xc(%ebp),%eax
  803035:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  803038:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  80303a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80303f:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  803042:	83 ec 0c             	sub    $0xc,%esp
  803045:	50                   	push   %eax
  803046:	e8 50 e6 ff ff       	call   80169b <sys_ipc_recv>
	if (from_env_store)
  80304b:	83 c4 10             	add    $0x10,%esp
  80304e:	85 f6                	test   %esi,%esi
  803050:	74 0b                	je     80305d <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  803052:	8b 15 24 54 80 00    	mov    0x805424,%edx
  803058:	8b 52 74             	mov    0x74(%edx),%edx
  80305b:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  80305d:	85 db                	test   %ebx,%ebx
  80305f:	74 0b                	je     80306c <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  803061:	8b 15 24 54 80 00    	mov    0x805424,%edx
  803067:	8b 52 78             	mov    0x78(%edx),%edx
  80306a:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  80306c:	85 c0                	test   %eax,%eax
  80306e:	79 16                	jns    803086 <ipc_recv+0x5c>
		if (from_env_store)
  803070:	85 f6                	test   %esi,%esi
  803072:	74 06                	je     80307a <ipc_recv+0x50>
			*from_env_store = 0;
  803074:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  80307a:	85 db                	test   %ebx,%ebx
  80307c:	74 10                	je     80308e <ipc_recv+0x64>
			*perm_store = 0;
  80307e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  803084:	eb 08                	jmp    80308e <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  803086:	a1 24 54 80 00       	mov    0x805424,%eax
  80308b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80308e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803091:	5b                   	pop    %ebx
  803092:	5e                   	pop    %esi
  803093:	5d                   	pop    %ebp
  803094:	c3                   	ret    

00803095 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803095:	55                   	push   %ebp
  803096:	89 e5                	mov    %esp,%ebp
  803098:	57                   	push   %edi
  803099:	56                   	push   %esi
  80309a:	53                   	push   %ebx
  80309b:	83 ec 0c             	sub    $0xc,%esp
  80309e:	8b 7d 08             	mov    0x8(%ebp),%edi
  8030a1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8030a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  8030a7:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  8030a9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8030ae:	0f 44 d8             	cmove  %eax,%ebx
  8030b1:	eb 1c                	jmp    8030cf <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  8030b3:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8030b6:	74 12                	je     8030ca <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  8030b8:	50                   	push   %eax
  8030b9:	68 da 3c 80 00       	push   $0x803cda
  8030be:	6a 42                	push   $0x42
  8030c0:	68 f0 3c 80 00       	push   $0x803cf0
  8030c5:	e8 4f d9 ff ff       	call   800a19 <_panic>
		sys_yield();
  8030ca:	e8 aa e4 ff ff       	call   801579 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  8030cf:	ff 75 14             	pushl  0x14(%ebp)
  8030d2:	53                   	push   %ebx
  8030d3:	56                   	push   %esi
  8030d4:	57                   	push   %edi
  8030d5:	e8 9c e5 ff ff       	call   801676 <sys_ipc_try_send>
  8030da:	83 c4 10             	add    $0x10,%esp
  8030dd:	85 c0                	test   %eax,%eax
  8030df:	75 d2                	jne    8030b3 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  8030e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8030e4:	5b                   	pop    %ebx
  8030e5:	5e                   	pop    %esi
  8030e6:	5f                   	pop    %edi
  8030e7:	5d                   	pop    %ebp
  8030e8:	c3                   	ret    

008030e9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8030e9:	55                   	push   %ebp
  8030ea:	89 e5                	mov    %esp,%ebp
  8030ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8030ef:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8030f4:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8030f7:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8030fd:	8b 52 50             	mov    0x50(%edx),%edx
  803100:	39 ca                	cmp    %ecx,%edx
  803102:	75 0d                	jne    803111 <ipc_find_env+0x28>
			return envs[i].env_id;
  803104:	6b c0 7c             	imul   $0x7c,%eax,%eax
  803107:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80310c:	8b 40 48             	mov    0x48(%eax),%eax
  80310f:	eb 0f                	jmp    803120 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803111:	83 c0 01             	add    $0x1,%eax
  803114:	3d 00 04 00 00       	cmp    $0x400,%eax
  803119:	75 d9                	jne    8030f4 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80311b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803120:	5d                   	pop    %ebp
  803121:	c3                   	ret    

00803122 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803122:	55                   	push   %ebp
  803123:	89 e5                	mov    %esp,%ebp
  803125:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803128:	89 d0                	mov    %edx,%eax
  80312a:	c1 e8 16             	shr    $0x16,%eax
  80312d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803134:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803139:	f6 c1 01             	test   $0x1,%cl
  80313c:	74 1d                	je     80315b <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80313e:	c1 ea 0c             	shr    $0xc,%edx
  803141:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803148:	f6 c2 01             	test   $0x1,%dl
  80314b:	74 0e                	je     80315b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80314d:	c1 ea 0c             	shr    $0xc,%edx
  803150:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803157:	ef 
  803158:	0f b7 c0             	movzwl %ax,%eax
}
  80315b:	5d                   	pop    %ebp
  80315c:	c3                   	ret    
  80315d:	66 90                	xchg   %ax,%ax
  80315f:	90                   	nop

00803160 <__udivdi3>:
  803160:	55                   	push   %ebp
  803161:	57                   	push   %edi
  803162:	56                   	push   %esi
  803163:	53                   	push   %ebx
  803164:	83 ec 1c             	sub    $0x1c,%esp
  803167:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80316b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80316f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803173:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803177:	85 f6                	test   %esi,%esi
  803179:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80317d:	89 ca                	mov    %ecx,%edx
  80317f:	89 f8                	mov    %edi,%eax
  803181:	75 3d                	jne    8031c0 <__udivdi3+0x60>
  803183:	39 cf                	cmp    %ecx,%edi
  803185:	0f 87 c5 00 00 00    	ja     803250 <__udivdi3+0xf0>
  80318b:	85 ff                	test   %edi,%edi
  80318d:	89 fd                	mov    %edi,%ebp
  80318f:	75 0b                	jne    80319c <__udivdi3+0x3c>
  803191:	b8 01 00 00 00       	mov    $0x1,%eax
  803196:	31 d2                	xor    %edx,%edx
  803198:	f7 f7                	div    %edi
  80319a:	89 c5                	mov    %eax,%ebp
  80319c:	89 c8                	mov    %ecx,%eax
  80319e:	31 d2                	xor    %edx,%edx
  8031a0:	f7 f5                	div    %ebp
  8031a2:	89 c1                	mov    %eax,%ecx
  8031a4:	89 d8                	mov    %ebx,%eax
  8031a6:	89 cf                	mov    %ecx,%edi
  8031a8:	f7 f5                	div    %ebp
  8031aa:	89 c3                	mov    %eax,%ebx
  8031ac:	89 d8                	mov    %ebx,%eax
  8031ae:	89 fa                	mov    %edi,%edx
  8031b0:	83 c4 1c             	add    $0x1c,%esp
  8031b3:	5b                   	pop    %ebx
  8031b4:	5e                   	pop    %esi
  8031b5:	5f                   	pop    %edi
  8031b6:	5d                   	pop    %ebp
  8031b7:	c3                   	ret    
  8031b8:	90                   	nop
  8031b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8031c0:	39 ce                	cmp    %ecx,%esi
  8031c2:	77 74                	ja     803238 <__udivdi3+0xd8>
  8031c4:	0f bd fe             	bsr    %esi,%edi
  8031c7:	83 f7 1f             	xor    $0x1f,%edi
  8031ca:	0f 84 98 00 00 00    	je     803268 <__udivdi3+0x108>
  8031d0:	bb 20 00 00 00       	mov    $0x20,%ebx
  8031d5:	89 f9                	mov    %edi,%ecx
  8031d7:	89 c5                	mov    %eax,%ebp
  8031d9:	29 fb                	sub    %edi,%ebx
  8031db:	d3 e6                	shl    %cl,%esi
  8031dd:	89 d9                	mov    %ebx,%ecx
  8031df:	d3 ed                	shr    %cl,%ebp
  8031e1:	89 f9                	mov    %edi,%ecx
  8031e3:	d3 e0                	shl    %cl,%eax
  8031e5:	09 ee                	or     %ebp,%esi
  8031e7:	89 d9                	mov    %ebx,%ecx
  8031e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031ed:	89 d5                	mov    %edx,%ebp
  8031ef:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031f3:	d3 ed                	shr    %cl,%ebp
  8031f5:	89 f9                	mov    %edi,%ecx
  8031f7:	d3 e2                	shl    %cl,%edx
  8031f9:	89 d9                	mov    %ebx,%ecx
  8031fb:	d3 e8                	shr    %cl,%eax
  8031fd:	09 c2                	or     %eax,%edx
  8031ff:	89 d0                	mov    %edx,%eax
  803201:	89 ea                	mov    %ebp,%edx
  803203:	f7 f6                	div    %esi
  803205:	89 d5                	mov    %edx,%ebp
  803207:	89 c3                	mov    %eax,%ebx
  803209:	f7 64 24 0c          	mull   0xc(%esp)
  80320d:	39 d5                	cmp    %edx,%ebp
  80320f:	72 10                	jb     803221 <__udivdi3+0xc1>
  803211:	8b 74 24 08          	mov    0x8(%esp),%esi
  803215:	89 f9                	mov    %edi,%ecx
  803217:	d3 e6                	shl    %cl,%esi
  803219:	39 c6                	cmp    %eax,%esi
  80321b:	73 07                	jae    803224 <__udivdi3+0xc4>
  80321d:	39 d5                	cmp    %edx,%ebp
  80321f:	75 03                	jne    803224 <__udivdi3+0xc4>
  803221:	83 eb 01             	sub    $0x1,%ebx
  803224:	31 ff                	xor    %edi,%edi
  803226:	89 d8                	mov    %ebx,%eax
  803228:	89 fa                	mov    %edi,%edx
  80322a:	83 c4 1c             	add    $0x1c,%esp
  80322d:	5b                   	pop    %ebx
  80322e:	5e                   	pop    %esi
  80322f:	5f                   	pop    %edi
  803230:	5d                   	pop    %ebp
  803231:	c3                   	ret    
  803232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803238:	31 ff                	xor    %edi,%edi
  80323a:	31 db                	xor    %ebx,%ebx
  80323c:	89 d8                	mov    %ebx,%eax
  80323e:	89 fa                	mov    %edi,%edx
  803240:	83 c4 1c             	add    $0x1c,%esp
  803243:	5b                   	pop    %ebx
  803244:	5e                   	pop    %esi
  803245:	5f                   	pop    %edi
  803246:	5d                   	pop    %ebp
  803247:	c3                   	ret    
  803248:	90                   	nop
  803249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803250:	89 d8                	mov    %ebx,%eax
  803252:	f7 f7                	div    %edi
  803254:	31 ff                	xor    %edi,%edi
  803256:	89 c3                	mov    %eax,%ebx
  803258:	89 d8                	mov    %ebx,%eax
  80325a:	89 fa                	mov    %edi,%edx
  80325c:	83 c4 1c             	add    $0x1c,%esp
  80325f:	5b                   	pop    %ebx
  803260:	5e                   	pop    %esi
  803261:	5f                   	pop    %edi
  803262:	5d                   	pop    %ebp
  803263:	c3                   	ret    
  803264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803268:	39 ce                	cmp    %ecx,%esi
  80326a:	72 0c                	jb     803278 <__udivdi3+0x118>
  80326c:	31 db                	xor    %ebx,%ebx
  80326e:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803272:	0f 87 34 ff ff ff    	ja     8031ac <__udivdi3+0x4c>
  803278:	bb 01 00 00 00       	mov    $0x1,%ebx
  80327d:	e9 2a ff ff ff       	jmp    8031ac <__udivdi3+0x4c>
  803282:	66 90                	xchg   %ax,%ax
  803284:	66 90                	xchg   %ax,%ax
  803286:	66 90                	xchg   %ax,%ax
  803288:	66 90                	xchg   %ax,%ax
  80328a:	66 90                	xchg   %ax,%ax
  80328c:	66 90                	xchg   %ax,%ax
  80328e:	66 90                	xchg   %ax,%ax

00803290 <__umoddi3>:
  803290:	55                   	push   %ebp
  803291:	57                   	push   %edi
  803292:	56                   	push   %esi
  803293:	53                   	push   %ebx
  803294:	83 ec 1c             	sub    $0x1c,%esp
  803297:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80329b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80329f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8032a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032a7:	85 d2                	test   %edx,%edx
  8032a9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8032ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032b1:	89 f3                	mov    %esi,%ebx
  8032b3:	89 3c 24             	mov    %edi,(%esp)
  8032b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8032ba:	75 1c                	jne    8032d8 <__umoddi3+0x48>
  8032bc:	39 f7                	cmp    %esi,%edi
  8032be:	76 50                	jbe    803310 <__umoddi3+0x80>
  8032c0:	89 c8                	mov    %ecx,%eax
  8032c2:	89 f2                	mov    %esi,%edx
  8032c4:	f7 f7                	div    %edi
  8032c6:	89 d0                	mov    %edx,%eax
  8032c8:	31 d2                	xor    %edx,%edx
  8032ca:	83 c4 1c             	add    $0x1c,%esp
  8032cd:	5b                   	pop    %ebx
  8032ce:	5e                   	pop    %esi
  8032cf:	5f                   	pop    %edi
  8032d0:	5d                   	pop    %ebp
  8032d1:	c3                   	ret    
  8032d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8032d8:	39 f2                	cmp    %esi,%edx
  8032da:	89 d0                	mov    %edx,%eax
  8032dc:	77 52                	ja     803330 <__umoddi3+0xa0>
  8032de:	0f bd ea             	bsr    %edx,%ebp
  8032e1:	83 f5 1f             	xor    $0x1f,%ebp
  8032e4:	75 5a                	jne    803340 <__umoddi3+0xb0>
  8032e6:	3b 54 24 04          	cmp    0x4(%esp),%edx
  8032ea:	0f 82 e0 00 00 00    	jb     8033d0 <__umoddi3+0x140>
  8032f0:	39 0c 24             	cmp    %ecx,(%esp)
  8032f3:	0f 86 d7 00 00 00    	jbe    8033d0 <__umoddi3+0x140>
  8032f9:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032fd:	8b 54 24 04          	mov    0x4(%esp),%edx
  803301:	83 c4 1c             	add    $0x1c,%esp
  803304:	5b                   	pop    %ebx
  803305:	5e                   	pop    %esi
  803306:	5f                   	pop    %edi
  803307:	5d                   	pop    %ebp
  803308:	c3                   	ret    
  803309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803310:	85 ff                	test   %edi,%edi
  803312:	89 fd                	mov    %edi,%ebp
  803314:	75 0b                	jne    803321 <__umoddi3+0x91>
  803316:	b8 01 00 00 00       	mov    $0x1,%eax
  80331b:	31 d2                	xor    %edx,%edx
  80331d:	f7 f7                	div    %edi
  80331f:	89 c5                	mov    %eax,%ebp
  803321:	89 f0                	mov    %esi,%eax
  803323:	31 d2                	xor    %edx,%edx
  803325:	f7 f5                	div    %ebp
  803327:	89 c8                	mov    %ecx,%eax
  803329:	f7 f5                	div    %ebp
  80332b:	89 d0                	mov    %edx,%eax
  80332d:	eb 99                	jmp    8032c8 <__umoddi3+0x38>
  80332f:	90                   	nop
  803330:	89 c8                	mov    %ecx,%eax
  803332:	89 f2                	mov    %esi,%edx
  803334:	83 c4 1c             	add    $0x1c,%esp
  803337:	5b                   	pop    %ebx
  803338:	5e                   	pop    %esi
  803339:	5f                   	pop    %edi
  80333a:	5d                   	pop    %ebp
  80333b:	c3                   	ret    
  80333c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803340:	8b 34 24             	mov    (%esp),%esi
  803343:	bf 20 00 00 00       	mov    $0x20,%edi
  803348:	89 e9                	mov    %ebp,%ecx
  80334a:	29 ef                	sub    %ebp,%edi
  80334c:	d3 e0                	shl    %cl,%eax
  80334e:	89 f9                	mov    %edi,%ecx
  803350:	89 f2                	mov    %esi,%edx
  803352:	d3 ea                	shr    %cl,%edx
  803354:	89 e9                	mov    %ebp,%ecx
  803356:	09 c2                	or     %eax,%edx
  803358:	89 d8                	mov    %ebx,%eax
  80335a:	89 14 24             	mov    %edx,(%esp)
  80335d:	89 f2                	mov    %esi,%edx
  80335f:	d3 e2                	shl    %cl,%edx
  803361:	89 f9                	mov    %edi,%ecx
  803363:	89 54 24 04          	mov    %edx,0x4(%esp)
  803367:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80336b:	d3 e8                	shr    %cl,%eax
  80336d:	89 e9                	mov    %ebp,%ecx
  80336f:	89 c6                	mov    %eax,%esi
  803371:	d3 e3                	shl    %cl,%ebx
  803373:	89 f9                	mov    %edi,%ecx
  803375:	89 d0                	mov    %edx,%eax
  803377:	d3 e8                	shr    %cl,%eax
  803379:	89 e9                	mov    %ebp,%ecx
  80337b:	09 d8                	or     %ebx,%eax
  80337d:	89 d3                	mov    %edx,%ebx
  80337f:	89 f2                	mov    %esi,%edx
  803381:	f7 34 24             	divl   (%esp)
  803384:	89 d6                	mov    %edx,%esi
  803386:	d3 e3                	shl    %cl,%ebx
  803388:	f7 64 24 04          	mull   0x4(%esp)
  80338c:	39 d6                	cmp    %edx,%esi
  80338e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803392:	89 d1                	mov    %edx,%ecx
  803394:	89 c3                	mov    %eax,%ebx
  803396:	72 08                	jb     8033a0 <__umoddi3+0x110>
  803398:	75 11                	jne    8033ab <__umoddi3+0x11b>
  80339a:	39 44 24 08          	cmp    %eax,0x8(%esp)
  80339e:	73 0b                	jae    8033ab <__umoddi3+0x11b>
  8033a0:	2b 44 24 04          	sub    0x4(%esp),%eax
  8033a4:	1b 14 24             	sbb    (%esp),%edx
  8033a7:	89 d1                	mov    %edx,%ecx
  8033a9:	89 c3                	mov    %eax,%ebx
  8033ab:	8b 54 24 08          	mov    0x8(%esp),%edx
  8033af:	29 da                	sub    %ebx,%edx
  8033b1:	19 ce                	sbb    %ecx,%esi
  8033b3:	89 f9                	mov    %edi,%ecx
  8033b5:	89 f0                	mov    %esi,%eax
  8033b7:	d3 e0                	shl    %cl,%eax
  8033b9:	89 e9                	mov    %ebp,%ecx
  8033bb:	d3 ea                	shr    %cl,%edx
  8033bd:	89 e9                	mov    %ebp,%ecx
  8033bf:	d3 ee                	shr    %cl,%esi
  8033c1:	09 d0                	or     %edx,%eax
  8033c3:	89 f2                	mov    %esi,%edx
  8033c5:	83 c4 1c             	add    $0x1c,%esp
  8033c8:	5b                   	pop    %ebx
  8033c9:	5e                   	pop    %esi
  8033ca:	5f                   	pop    %edi
  8033cb:	5d                   	pop    %ebp
  8033cc:	c3                   	ret    
  8033cd:	8d 76 00             	lea    0x0(%esi),%esi
  8033d0:	29 f9                	sub    %edi,%ecx
  8033d2:	19 d6                	sbb    %edx,%esi
  8033d4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8033d8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033dc:	e9 18 ff ff ff       	jmp    8032f9 <__umoddi3+0x69>
