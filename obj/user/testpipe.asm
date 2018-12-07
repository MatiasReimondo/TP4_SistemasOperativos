
obj/user/testpipe.debug:     formato del fichero elf32-i386


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
  80002c:	e8 81 02 00 00       	call   8002b2 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 7c             	sub    $0x7c,%esp
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80003b:	c7 05 04 30 80 00 40 	movl   $0x802540,0x803004
  800042:	25 80 00 

	if ((i = pipe(p)) < 0)
  800045:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800048:	50                   	push   %eax
  800049:	e8 34 1d 00 00       	call   801d82 <pipe>
  80004e:	89 c6                	mov    %eax,%esi
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	79 12                	jns    800069 <umain+0x36>
		panic("pipe: %e", i);
  800057:	50                   	push   %eax
  800058:	68 4c 25 80 00       	push   $0x80254c
  80005d:	6a 0e                	push   $0xe
  80005f:	68 55 25 80 00       	push   $0x802555
  800064:	e8 ad 02 00 00       	call   800316 <_panic>

	if ((pid = fork()) < 0)
  800069:	e8 e3 11 00 00       	call   801251 <fork>
  80006e:	89 c3                	mov    %eax,%ebx
  800070:	85 c0                	test   %eax,%eax
  800072:	79 12                	jns    800086 <umain+0x53>
		panic("fork: %e", i);
  800074:	56                   	push   %esi
  800075:	68 d0 2a 80 00       	push   $0x802ad0
  80007a:	6a 11                	push   $0x11
  80007c:	68 55 25 80 00       	push   $0x802555
  800081:	e8 90 02 00 00       	call   800316 <_panic>

	if (pid == 0) {
  800086:	85 c0                	test   %eax,%eax
  800088:	0f 85 b8 00 00 00    	jne    800146 <umain+0x113>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  80008e:	a1 04 40 80 00       	mov    0x804004,%eax
  800093:	8b 40 48             	mov    0x48(%eax),%eax
  800096:	83 ec 04             	sub    $0x4,%esp
  800099:	ff 75 90             	pushl  -0x70(%ebp)
  80009c:	50                   	push   %eax
  80009d:	68 65 25 80 00       	push   $0x802565
  8000a2:	e8 48 03 00 00       	call   8003ef <cprintf>
		close(p[1]);
  8000a7:	83 c4 04             	add    $0x4,%esp
  8000aa:	ff 75 90             	pushl  -0x70(%ebp)
  8000ad:	e8 6c 14 00 00       	call   80151e <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  8000b2:	a1 04 40 80 00       	mov    0x804004,%eax
  8000b7:	8b 40 48             	mov    0x48(%eax),%eax
  8000ba:	83 c4 0c             	add    $0xc,%esp
  8000bd:	ff 75 8c             	pushl  -0x74(%ebp)
  8000c0:	50                   	push   %eax
  8000c1:	68 82 25 80 00       	push   $0x802582
  8000c6:	e8 24 03 00 00       	call   8003ef <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000cb:	83 c4 0c             	add    $0xc,%esp
  8000ce:	6a 63                	push   $0x63
  8000d0:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000d3:	50                   	push   %eax
  8000d4:	ff 75 8c             	pushl  -0x74(%ebp)
  8000d7:	e8 0f 16 00 00       	call   8016eb <readn>
  8000dc:	89 c6                	mov    %eax,%esi
		if (i < 0)
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	85 c0                	test   %eax,%eax
  8000e3:	79 12                	jns    8000f7 <umain+0xc4>
			panic("read: %e", i);
  8000e5:	50                   	push   %eax
  8000e6:	68 9f 25 80 00       	push   $0x80259f
  8000eb:	6a 19                	push   $0x19
  8000ed:	68 55 25 80 00       	push   $0x802555
  8000f2:	e8 1f 02 00 00       	call   800316 <_panic>
		buf[i] = 0;
  8000f7:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  8000fc:	83 ec 08             	sub    $0x8,%esp
  8000ff:	ff 35 00 30 80 00    	pushl  0x803000
  800105:	8d 45 94             	lea    -0x6c(%ebp),%eax
  800108:	50                   	push   %eax
  800109:	e8 fd 08 00 00       	call   800a0b <strcmp>
  80010e:	83 c4 10             	add    $0x10,%esp
  800111:	85 c0                	test   %eax,%eax
  800113:	75 12                	jne    800127 <umain+0xf4>
			cprintf("\npipe read closed properly\n");
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	68 a8 25 80 00       	push   $0x8025a8
  80011d:	e8 cd 02 00 00       	call   8003ef <cprintf>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	eb 15                	jmp    80013c <umain+0x109>
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
  800127:	83 ec 04             	sub    $0x4,%esp
  80012a:	8d 45 94             	lea    -0x6c(%ebp),%eax
  80012d:	50                   	push   %eax
  80012e:	56                   	push   %esi
  80012f:	68 c4 25 80 00       	push   $0x8025c4
  800134:	e8 b6 02 00 00       	call   8003ef <cprintf>
  800139:	83 c4 10             	add    $0x10,%esp
		exit();
  80013c:	e8 bb 01 00 00       	call   8002fc <exit>
  800141:	e9 94 00 00 00       	jmp    8001da <umain+0x1a7>
	} else {
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  800146:	a1 04 40 80 00       	mov    0x804004,%eax
  80014b:	8b 40 48             	mov    0x48(%eax),%eax
  80014e:	83 ec 04             	sub    $0x4,%esp
  800151:	ff 75 8c             	pushl  -0x74(%ebp)
  800154:	50                   	push   %eax
  800155:	68 65 25 80 00       	push   $0x802565
  80015a:	e8 90 02 00 00       	call   8003ef <cprintf>
		close(p[0]);
  80015f:	83 c4 04             	add    $0x4,%esp
  800162:	ff 75 8c             	pushl  -0x74(%ebp)
  800165:	e8 b4 13 00 00       	call   80151e <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  80016a:	a1 04 40 80 00       	mov    0x804004,%eax
  80016f:	8b 40 48             	mov    0x48(%eax),%eax
  800172:	83 c4 0c             	add    $0xc,%esp
  800175:	ff 75 90             	pushl  -0x70(%ebp)
  800178:	50                   	push   %eax
  800179:	68 d7 25 80 00       	push   $0x8025d7
  80017e:	e8 6c 02 00 00       	call   8003ef <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  800183:	83 c4 04             	add    $0x4,%esp
  800186:	ff 35 00 30 80 00    	pushl  0x803000
  80018c:	e8 97 07 00 00       	call   800928 <strlen>
  800191:	83 c4 0c             	add    $0xc,%esp
  800194:	50                   	push   %eax
  800195:	ff 35 00 30 80 00    	pushl  0x803000
  80019b:	ff 75 90             	pushl  -0x70(%ebp)
  80019e:	e8 91 15 00 00       	call   801734 <write>
  8001a3:	89 c6                	mov    %eax,%esi
  8001a5:	83 c4 04             	add    $0x4,%esp
  8001a8:	ff 35 00 30 80 00    	pushl  0x803000
  8001ae:	e8 75 07 00 00       	call   800928 <strlen>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	39 c6                	cmp    %eax,%esi
  8001b8:	74 12                	je     8001cc <umain+0x199>
			panic("write: %e", i);
  8001ba:	56                   	push   %esi
  8001bb:	68 f4 25 80 00       	push   $0x8025f4
  8001c0:	6a 25                	push   $0x25
  8001c2:	68 55 25 80 00       	push   $0x802555
  8001c7:	e8 4a 01 00 00       	call   800316 <_panic>
		close(p[1]);
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	ff 75 90             	pushl  -0x70(%ebp)
  8001d2:	e8 47 13 00 00       	call   80151e <close>
  8001d7:	83 c4 10             	add    $0x10,%esp
	}
	wait(pid);
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	53                   	push   %ebx
  8001de:	e8 25 1d 00 00       	call   801f08 <wait>

	binaryname = "pipewriteeof";
  8001e3:	c7 05 04 30 80 00 fe 	movl   $0x8025fe,0x803004
  8001ea:	25 80 00 
	if ((i = pipe(p)) < 0)
  8001ed:	8d 45 8c             	lea    -0x74(%ebp),%eax
  8001f0:	89 04 24             	mov    %eax,(%esp)
  8001f3:	e8 8a 1b 00 00       	call   801d82 <pipe>
  8001f8:	89 c6                	mov    %eax,%esi
  8001fa:	83 c4 10             	add    $0x10,%esp
  8001fd:	85 c0                	test   %eax,%eax
  8001ff:	79 12                	jns    800213 <umain+0x1e0>
		panic("pipe: %e", i);
  800201:	50                   	push   %eax
  800202:	68 4c 25 80 00       	push   $0x80254c
  800207:	6a 2c                	push   $0x2c
  800209:	68 55 25 80 00       	push   $0x802555
  80020e:	e8 03 01 00 00       	call   800316 <_panic>

	if ((pid = fork()) < 0)
  800213:	e8 39 10 00 00       	call   801251 <fork>
  800218:	89 c3                	mov    %eax,%ebx
  80021a:	85 c0                	test   %eax,%eax
  80021c:	79 12                	jns    800230 <umain+0x1fd>
		panic("fork: %e", i);
  80021e:	56                   	push   %esi
  80021f:	68 d0 2a 80 00       	push   $0x802ad0
  800224:	6a 2f                	push   $0x2f
  800226:	68 55 25 80 00       	push   $0x802555
  80022b:	e8 e6 00 00 00       	call   800316 <_panic>

	if (pid == 0) {
  800230:	85 c0                	test   %eax,%eax
  800232:	75 4a                	jne    80027e <umain+0x24b>
		close(p[0]);
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	ff 75 8c             	pushl  -0x74(%ebp)
  80023a:	e8 df 12 00 00       	call   80151e <close>
  80023f:	83 c4 10             	add    $0x10,%esp
		while (1) {
			cprintf(".");
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 0b 26 80 00       	push   $0x80260b
  80024a:	e8 a0 01 00 00       	call   8003ef <cprintf>
			if (write(p[1], "x", 1) != 1)
  80024f:	83 c4 0c             	add    $0xc,%esp
  800252:	6a 01                	push   $0x1
  800254:	68 0d 26 80 00       	push   $0x80260d
  800259:	ff 75 90             	pushl  -0x70(%ebp)
  80025c:	e8 d3 14 00 00       	call   801734 <write>
  800261:	83 c4 10             	add    $0x10,%esp
  800264:	83 f8 01             	cmp    $0x1,%eax
  800267:	74 d9                	je     800242 <umain+0x20f>
				break;
		}
		cprintf("\npipe write closed properly\n");
  800269:	83 ec 0c             	sub    $0xc,%esp
  80026c:	68 0f 26 80 00       	push   $0x80260f
  800271:	e8 79 01 00 00       	call   8003ef <cprintf>
		exit();
  800276:	e8 81 00 00 00       	call   8002fc <exit>
  80027b:	83 c4 10             	add    $0x10,%esp
	}
	close(p[0]);
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	ff 75 8c             	pushl  -0x74(%ebp)
  800284:	e8 95 12 00 00       	call   80151e <close>
	close(p[1]);
  800289:	83 c4 04             	add    $0x4,%esp
  80028c:	ff 75 90             	pushl  -0x70(%ebp)
  80028f:	e8 8a 12 00 00       	call   80151e <close>
	wait(pid);
  800294:	89 1c 24             	mov    %ebx,(%esp)
  800297:	e8 6c 1c 00 00       	call   801f08 <wait>

	cprintf("pipe tests passed\n");
  80029c:	c7 04 24 2c 26 80 00 	movl   $0x80262c,(%esp)
  8002a3:	e8 47 01 00 00       	call   8003ef <cprintf>
}
  8002a8:	83 c4 10             	add    $0x10,%esp
  8002ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002ae:	5b                   	pop    %ebx
  8002af:	5e                   	pop    %esi
  8002b0:	5d                   	pop    %ebp
  8002b1:	c3                   	ret    

008002b2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	56                   	push   %esi
  8002b6:	53                   	push   %ebx
  8002b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002ba:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8002bd:	e8 9d 0a 00 00       	call   800d5f <sys_getenvid>
	if (id >= 0)
  8002c2:	85 c0                	test   %eax,%eax
  8002c4:	78 12                	js     8002d8 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  8002c6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002cb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002ce:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002d3:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002d8:	85 db                	test   %ebx,%ebx
  8002da:	7e 07                	jle    8002e3 <libmain+0x31>
		binaryname = argv[0];
  8002dc:	8b 06                	mov    (%esi),%eax
  8002de:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8002e3:	83 ec 08             	sub    $0x8,%esp
  8002e6:	56                   	push   %esi
  8002e7:	53                   	push   %ebx
  8002e8:	e8 46 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8002ed:	e8 0a 00 00 00       	call   8002fc <exit>
}
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002f8:	5b                   	pop    %ebx
  8002f9:	5e                   	pop    %esi
  8002fa:	5d                   	pop    %ebp
  8002fb:	c3                   	ret    

008002fc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002fc:	55                   	push   %ebp
  8002fd:	89 e5                	mov    %esp,%ebp
  8002ff:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800302:	e8 42 12 00 00       	call   801549 <close_all>
	sys_env_destroy(0);
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	6a 00                	push   $0x0
  80030c:	e8 2c 0a 00 00       	call   800d3d <sys_env_destroy>
}
  800311:	83 c4 10             	add    $0x10,%esp
  800314:	c9                   	leave  
  800315:	c3                   	ret    

00800316 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800316:	55                   	push   %ebp
  800317:	89 e5                	mov    %esp,%ebp
  800319:	56                   	push   %esi
  80031a:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80031b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80031e:	8b 35 04 30 80 00    	mov    0x803004,%esi
  800324:	e8 36 0a 00 00       	call   800d5f <sys_getenvid>
  800329:	83 ec 0c             	sub    $0xc,%esp
  80032c:	ff 75 0c             	pushl  0xc(%ebp)
  80032f:	ff 75 08             	pushl  0x8(%ebp)
  800332:	56                   	push   %esi
  800333:	50                   	push   %eax
  800334:	68 90 26 80 00       	push   $0x802690
  800339:	e8 b1 00 00 00       	call   8003ef <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80033e:	83 c4 18             	add    $0x18,%esp
  800341:	53                   	push   %ebx
  800342:	ff 75 10             	pushl  0x10(%ebp)
  800345:	e8 54 00 00 00       	call   80039e <vcprintf>
	cprintf("\n");
  80034a:	c7 04 24 80 25 80 00 	movl   $0x802580,(%esp)
  800351:	e8 99 00 00 00       	call   8003ef <cprintf>
  800356:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800359:	cc                   	int3   
  80035a:	eb fd                	jmp    800359 <_panic+0x43>

0080035c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	53                   	push   %ebx
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800366:	8b 13                	mov    (%ebx),%edx
  800368:	8d 42 01             	lea    0x1(%edx),%eax
  80036b:	89 03                	mov    %eax,(%ebx)
  80036d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800370:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800374:	3d ff 00 00 00       	cmp    $0xff,%eax
  800379:	75 1a                	jne    800395 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  80037b:	83 ec 08             	sub    $0x8,%esp
  80037e:	68 ff 00 00 00       	push   $0xff
  800383:	8d 43 08             	lea    0x8(%ebx),%eax
  800386:	50                   	push   %eax
  800387:	e8 67 09 00 00       	call   800cf3 <sys_cputs>
		b->idx = 0;
  80038c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800392:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  800395:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800399:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80039c:	c9                   	leave  
  80039d:	c3                   	ret    

0080039e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80039e:	55                   	push   %ebp
  80039f:	89 e5                	mov    %esp,%ebp
  8003a1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003a7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003ae:	00 00 00 
	b.cnt = 0;
  8003b1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003b8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003bb:	ff 75 0c             	pushl  0xc(%ebp)
  8003be:	ff 75 08             	pushl  0x8(%ebp)
  8003c1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003c7:	50                   	push   %eax
  8003c8:	68 5c 03 80 00       	push   $0x80035c
  8003cd:	e8 86 01 00 00       	call   800558 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003d2:	83 c4 08             	add    $0x8,%esp
  8003d5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003db:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003e1:	50                   	push   %eax
  8003e2:	e8 0c 09 00 00       	call   800cf3 <sys_cputs>

	return b.cnt;
}
  8003e7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003ed:	c9                   	leave  
  8003ee:	c3                   	ret    

008003ef <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
  8003f2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003f5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003f8:	50                   	push   %eax
  8003f9:	ff 75 08             	pushl  0x8(%ebp)
  8003fc:	e8 9d ff ff ff       	call   80039e <vcprintf>
	va_end(ap);

	return cnt;
}
  800401:	c9                   	leave  
  800402:	c3                   	ret    

00800403 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800403:	55                   	push   %ebp
  800404:	89 e5                	mov    %esp,%ebp
  800406:	57                   	push   %edi
  800407:	56                   	push   %esi
  800408:	53                   	push   %ebx
  800409:	83 ec 1c             	sub    $0x1c,%esp
  80040c:	89 c7                	mov    %eax,%edi
  80040e:	89 d6                	mov    %edx,%esi
  800410:	8b 45 08             	mov    0x8(%ebp),%eax
  800413:	8b 55 0c             	mov    0xc(%ebp),%edx
  800416:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800419:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80041c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80041f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800424:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800427:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80042a:	39 d3                	cmp    %edx,%ebx
  80042c:	72 05                	jb     800433 <printnum+0x30>
  80042e:	39 45 10             	cmp    %eax,0x10(%ebp)
  800431:	77 45                	ja     800478 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800433:	83 ec 0c             	sub    $0xc,%esp
  800436:	ff 75 18             	pushl  0x18(%ebp)
  800439:	8b 45 14             	mov    0x14(%ebp),%eax
  80043c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80043f:	53                   	push   %ebx
  800440:	ff 75 10             	pushl  0x10(%ebp)
  800443:	83 ec 08             	sub    $0x8,%esp
  800446:	ff 75 e4             	pushl  -0x1c(%ebp)
  800449:	ff 75 e0             	pushl  -0x20(%ebp)
  80044c:	ff 75 dc             	pushl  -0x24(%ebp)
  80044f:	ff 75 d8             	pushl  -0x28(%ebp)
  800452:	e8 49 1e 00 00       	call   8022a0 <__udivdi3>
  800457:	83 c4 18             	add    $0x18,%esp
  80045a:	52                   	push   %edx
  80045b:	50                   	push   %eax
  80045c:	89 f2                	mov    %esi,%edx
  80045e:	89 f8                	mov    %edi,%eax
  800460:	e8 9e ff ff ff       	call   800403 <printnum>
  800465:	83 c4 20             	add    $0x20,%esp
  800468:	eb 18                	jmp    800482 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80046a:	83 ec 08             	sub    $0x8,%esp
  80046d:	56                   	push   %esi
  80046e:	ff 75 18             	pushl  0x18(%ebp)
  800471:	ff d7                	call   *%edi
  800473:	83 c4 10             	add    $0x10,%esp
  800476:	eb 03                	jmp    80047b <printnum+0x78>
  800478:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80047b:	83 eb 01             	sub    $0x1,%ebx
  80047e:	85 db                	test   %ebx,%ebx
  800480:	7f e8                	jg     80046a <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800482:	83 ec 08             	sub    $0x8,%esp
  800485:	56                   	push   %esi
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	ff 75 e4             	pushl  -0x1c(%ebp)
  80048c:	ff 75 e0             	pushl  -0x20(%ebp)
  80048f:	ff 75 dc             	pushl  -0x24(%ebp)
  800492:	ff 75 d8             	pushl  -0x28(%ebp)
  800495:	e8 36 1f 00 00       	call   8023d0 <__umoddi3>
  80049a:	83 c4 14             	add    $0x14,%esp
  80049d:	0f be 80 b3 26 80 00 	movsbl 0x8026b3(%eax),%eax
  8004a4:	50                   	push   %eax
  8004a5:	ff d7                	call   *%edi
}
  8004a7:	83 c4 10             	add    $0x10,%esp
  8004aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004ad:	5b                   	pop    %ebx
  8004ae:	5e                   	pop    %esi
  8004af:	5f                   	pop    %edi
  8004b0:	5d                   	pop    %ebp
  8004b1:	c3                   	ret    

008004b2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004b2:	55                   	push   %ebp
  8004b3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004b5:	83 fa 01             	cmp    $0x1,%edx
  8004b8:	7e 0e                	jle    8004c8 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8004ba:	8b 10                	mov    (%eax),%edx
  8004bc:	8d 4a 08             	lea    0x8(%edx),%ecx
  8004bf:	89 08                	mov    %ecx,(%eax)
  8004c1:	8b 02                	mov    (%edx),%eax
  8004c3:	8b 52 04             	mov    0x4(%edx),%edx
  8004c6:	eb 22                	jmp    8004ea <getuint+0x38>
	else if (lflag)
  8004c8:	85 d2                	test   %edx,%edx
  8004ca:	74 10                	je     8004dc <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8004cc:	8b 10                	mov    (%eax),%edx
  8004ce:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004d1:	89 08                	mov    %ecx,(%eax)
  8004d3:	8b 02                	mov    (%edx),%eax
  8004d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8004da:	eb 0e                	jmp    8004ea <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004dc:	8b 10                	mov    (%eax),%edx
  8004de:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004e1:	89 08                	mov    %ecx,(%eax)
  8004e3:	8b 02                	mov    (%edx),%eax
  8004e5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004ea:	5d                   	pop    %ebp
  8004eb:	c3                   	ret    

008004ec <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004ec:	55                   	push   %ebp
  8004ed:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004ef:	83 fa 01             	cmp    $0x1,%edx
  8004f2:	7e 0e                	jle    800502 <getint+0x16>
		return va_arg(*ap, long long);
  8004f4:	8b 10                	mov    (%eax),%edx
  8004f6:	8d 4a 08             	lea    0x8(%edx),%ecx
  8004f9:	89 08                	mov    %ecx,(%eax)
  8004fb:	8b 02                	mov    (%edx),%eax
  8004fd:	8b 52 04             	mov    0x4(%edx),%edx
  800500:	eb 1a                	jmp    80051c <getint+0x30>
	else if (lflag)
  800502:	85 d2                	test   %edx,%edx
  800504:	74 0c                	je     800512 <getint+0x26>
		return va_arg(*ap, long);
  800506:	8b 10                	mov    (%eax),%edx
  800508:	8d 4a 04             	lea    0x4(%edx),%ecx
  80050b:	89 08                	mov    %ecx,(%eax)
  80050d:	8b 02                	mov    (%edx),%eax
  80050f:	99                   	cltd   
  800510:	eb 0a                	jmp    80051c <getint+0x30>
	else
		return va_arg(*ap, int);
  800512:	8b 10                	mov    (%eax),%edx
  800514:	8d 4a 04             	lea    0x4(%edx),%ecx
  800517:	89 08                	mov    %ecx,(%eax)
  800519:	8b 02                	mov    (%edx),%eax
  80051b:	99                   	cltd   
}
  80051c:	5d                   	pop    %ebp
  80051d:	c3                   	ret    

0080051e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800524:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800528:	8b 10                	mov    (%eax),%edx
  80052a:	3b 50 04             	cmp    0x4(%eax),%edx
  80052d:	73 0a                	jae    800539 <sprintputch+0x1b>
		*b->buf++ = ch;
  80052f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800532:	89 08                	mov    %ecx,(%eax)
  800534:	8b 45 08             	mov    0x8(%ebp),%eax
  800537:	88 02                	mov    %al,(%edx)
}
  800539:	5d                   	pop    %ebp
  80053a:	c3                   	ret    

0080053b <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80053b:	55                   	push   %ebp
  80053c:	89 e5                	mov    %esp,%ebp
  80053e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800541:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800544:	50                   	push   %eax
  800545:	ff 75 10             	pushl  0x10(%ebp)
  800548:	ff 75 0c             	pushl  0xc(%ebp)
  80054b:	ff 75 08             	pushl  0x8(%ebp)
  80054e:	e8 05 00 00 00       	call   800558 <vprintfmt>
	va_end(ap);
}
  800553:	83 c4 10             	add    $0x10,%esp
  800556:	c9                   	leave  
  800557:	c3                   	ret    

00800558 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800558:	55                   	push   %ebp
  800559:	89 e5                	mov    %esp,%ebp
  80055b:	57                   	push   %edi
  80055c:	56                   	push   %esi
  80055d:	53                   	push   %ebx
  80055e:	83 ec 2c             	sub    $0x2c,%esp
  800561:	8b 75 08             	mov    0x8(%ebp),%esi
  800564:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800567:	8b 7d 10             	mov    0x10(%ebp),%edi
  80056a:	eb 12                	jmp    80057e <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80056c:	85 c0                	test   %eax,%eax
  80056e:	0f 84 44 03 00 00    	je     8008b8 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	53                   	push   %ebx
  800578:	50                   	push   %eax
  800579:	ff d6                	call   *%esi
  80057b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80057e:	83 c7 01             	add    $0x1,%edi
  800581:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800585:	83 f8 25             	cmp    $0x25,%eax
  800588:	75 e2                	jne    80056c <vprintfmt+0x14>
  80058a:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  80058e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800595:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80059c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8005a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a8:	eb 07                	jmp    8005b1 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8005ad:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005b1:	8d 47 01             	lea    0x1(%edi),%eax
  8005b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005b7:	0f b6 07             	movzbl (%edi),%eax
  8005ba:	0f b6 c8             	movzbl %al,%ecx
  8005bd:	83 e8 23             	sub    $0x23,%eax
  8005c0:	3c 55                	cmp    $0x55,%al
  8005c2:	0f 87 d5 02 00 00    	ja     80089d <vprintfmt+0x345>
  8005c8:	0f b6 c0             	movzbl %al,%eax
  8005cb:	ff 24 85 00 28 80 00 	jmp    *0x802800(,%eax,4)
  8005d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005d5:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8005d9:	eb d6                	jmp    8005b1 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005de:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8005e6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005e9:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8005ed:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8005f0:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8005f3:	83 fa 09             	cmp    $0x9,%edx
  8005f6:	77 39                	ja     800631 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005f8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005fb:	eb e9                	jmp    8005e6 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8d 48 04             	lea    0x4(%eax),%ecx
  800603:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800606:	8b 00                	mov    (%eax),%eax
  800608:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80060b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  80060e:	eb 27                	jmp    800637 <vprintfmt+0xdf>
  800610:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800613:	85 c0                	test   %eax,%eax
  800615:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061a:	0f 49 c8             	cmovns %eax,%ecx
  80061d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800620:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800623:	eb 8c                	jmp    8005b1 <vprintfmt+0x59>
  800625:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800628:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80062f:	eb 80                	jmp    8005b1 <vprintfmt+0x59>
  800631:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800634:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  800637:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80063b:	0f 89 70 ff ff ff    	jns    8005b1 <vprintfmt+0x59>
				width = precision, precision = -1;
  800641:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800644:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800647:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80064e:	e9 5e ff ff ff       	jmp    8005b1 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800653:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800656:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800659:	e9 53 ff ff ff       	jmp    8005b1 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	8d 50 04             	lea    0x4(%eax),%edx
  800664:	89 55 14             	mov    %edx,0x14(%ebp)
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	53                   	push   %ebx
  80066b:	ff 30                	pushl  (%eax)
  80066d:	ff d6                	call   *%esi
			break;
  80066f:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800672:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800675:	e9 04 ff ff ff       	jmp    80057e <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	8d 50 04             	lea    0x4(%eax),%edx
  800680:	89 55 14             	mov    %edx,0x14(%ebp)
  800683:	8b 00                	mov    (%eax),%eax
  800685:	99                   	cltd   
  800686:	31 d0                	xor    %edx,%eax
  800688:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80068a:	83 f8 0f             	cmp    $0xf,%eax
  80068d:	7f 0b                	jg     80069a <vprintfmt+0x142>
  80068f:	8b 14 85 60 29 80 00 	mov    0x802960(,%eax,4),%edx
  800696:	85 d2                	test   %edx,%edx
  800698:	75 18                	jne    8006b2 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  80069a:	50                   	push   %eax
  80069b:	68 cb 26 80 00       	push   $0x8026cb
  8006a0:	53                   	push   %ebx
  8006a1:	56                   	push   %esi
  8006a2:	e8 94 fe ff ff       	call   80053b <printfmt>
  8006a7:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8006ad:	e9 cc fe ff ff       	jmp    80057e <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  8006b2:	52                   	push   %edx
  8006b3:	68 f5 2b 80 00       	push   $0x802bf5
  8006b8:	53                   	push   %ebx
  8006b9:	56                   	push   %esi
  8006ba:	e8 7c fe ff ff       	call   80053b <printfmt>
  8006bf:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006c5:	e9 b4 fe ff ff       	jmp    80057e <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cd:	8d 50 04             	lea    0x4(%eax),%edx
  8006d0:	89 55 14             	mov    %edx,0x14(%ebp)
  8006d3:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8006d5:	85 ff                	test   %edi,%edi
  8006d7:	b8 c4 26 80 00       	mov    $0x8026c4,%eax
  8006dc:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8006df:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006e3:	0f 8e 94 00 00 00    	jle    80077d <vprintfmt+0x225>
  8006e9:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8006ed:	0f 84 98 00 00 00    	je     80078b <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f3:	83 ec 08             	sub    $0x8,%esp
  8006f6:	ff 75 d0             	pushl  -0x30(%ebp)
  8006f9:	57                   	push   %edi
  8006fa:	e8 41 02 00 00       	call   800940 <strnlen>
  8006ff:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800702:	29 c1                	sub    %eax,%ecx
  800704:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800707:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80070a:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800711:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800714:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800716:	eb 0f                	jmp    800727 <vprintfmt+0x1cf>
					putch(padc, putdat);
  800718:	83 ec 08             	sub    $0x8,%esp
  80071b:	53                   	push   %ebx
  80071c:	ff 75 e0             	pushl  -0x20(%ebp)
  80071f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800721:	83 ef 01             	sub    $0x1,%edi
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	85 ff                	test   %edi,%edi
  800729:	7f ed                	jg     800718 <vprintfmt+0x1c0>
  80072b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80072e:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800731:	85 c9                	test   %ecx,%ecx
  800733:	b8 00 00 00 00       	mov    $0x0,%eax
  800738:	0f 49 c1             	cmovns %ecx,%eax
  80073b:	29 c1                	sub    %eax,%ecx
  80073d:	89 75 08             	mov    %esi,0x8(%ebp)
  800740:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800743:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800746:	89 cb                	mov    %ecx,%ebx
  800748:	eb 4d                	jmp    800797 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80074a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80074e:	74 1b                	je     80076b <vprintfmt+0x213>
  800750:	0f be c0             	movsbl %al,%eax
  800753:	83 e8 20             	sub    $0x20,%eax
  800756:	83 f8 5e             	cmp    $0x5e,%eax
  800759:	76 10                	jbe    80076b <vprintfmt+0x213>
					putch('?', putdat);
  80075b:	83 ec 08             	sub    $0x8,%esp
  80075e:	ff 75 0c             	pushl  0xc(%ebp)
  800761:	6a 3f                	push   $0x3f
  800763:	ff 55 08             	call   *0x8(%ebp)
  800766:	83 c4 10             	add    $0x10,%esp
  800769:	eb 0d                	jmp    800778 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  80076b:	83 ec 08             	sub    $0x8,%esp
  80076e:	ff 75 0c             	pushl  0xc(%ebp)
  800771:	52                   	push   %edx
  800772:	ff 55 08             	call   *0x8(%ebp)
  800775:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800778:	83 eb 01             	sub    $0x1,%ebx
  80077b:	eb 1a                	jmp    800797 <vprintfmt+0x23f>
  80077d:	89 75 08             	mov    %esi,0x8(%ebp)
  800780:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800783:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800786:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800789:	eb 0c                	jmp    800797 <vprintfmt+0x23f>
  80078b:	89 75 08             	mov    %esi,0x8(%ebp)
  80078e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800791:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800794:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800797:	83 c7 01             	add    $0x1,%edi
  80079a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80079e:	0f be d0             	movsbl %al,%edx
  8007a1:	85 d2                	test   %edx,%edx
  8007a3:	74 23                	je     8007c8 <vprintfmt+0x270>
  8007a5:	85 f6                	test   %esi,%esi
  8007a7:	78 a1                	js     80074a <vprintfmt+0x1f2>
  8007a9:	83 ee 01             	sub    $0x1,%esi
  8007ac:	79 9c                	jns    80074a <vprintfmt+0x1f2>
  8007ae:	89 df                	mov    %ebx,%edi
  8007b0:	8b 75 08             	mov    0x8(%ebp),%esi
  8007b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007b6:	eb 18                	jmp    8007d0 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	53                   	push   %ebx
  8007bc:	6a 20                	push   $0x20
  8007be:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007c0:	83 ef 01             	sub    $0x1,%edi
  8007c3:	83 c4 10             	add    $0x10,%esp
  8007c6:	eb 08                	jmp    8007d0 <vprintfmt+0x278>
  8007c8:	89 df                	mov    %ebx,%edi
  8007ca:	8b 75 08             	mov    0x8(%ebp),%esi
  8007cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007d0:	85 ff                	test   %edi,%edi
  8007d2:	7f e4                	jg     8007b8 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8007d7:	e9 a2 fd ff ff       	jmp    80057e <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007dc:	8d 45 14             	lea    0x14(%ebp),%eax
  8007df:	e8 08 fd ff ff       	call   8004ec <getint>
  8007e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8007ea:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8007ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007f3:	79 74                	jns    800869 <vprintfmt+0x311>
				putch('-', putdat);
  8007f5:	83 ec 08             	sub    $0x8,%esp
  8007f8:	53                   	push   %ebx
  8007f9:	6a 2d                	push   $0x2d
  8007fb:	ff d6                	call   *%esi
				num = -(long long) num;
  8007fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800800:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800803:	f7 d8                	neg    %eax
  800805:	83 d2 00             	adc    $0x0,%edx
  800808:	f7 da                	neg    %edx
  80080a:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  80080d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800812:	eb 55                	jmp    800869 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800814:	8d 45 14             	lea    0x14(%ebp),%eax
  800817:	e8 96 fc ff ff       	call   8004b2 <getuint>
			base = 10;
  80081c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800821:	eb 46                	jmp    800869 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800823:	8d 45 14             	lea    0x14(%ebp),%eax
  800826:	e8 87 fc ff ff       	call   8004b2 <getuint>
			base = 8;
  80082b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800830:	eb 37                	jmp    800869 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	53                   	push   %ebx
  800836:	6a 30                	push   $0x30
  800838:	ff d6                	call   *%esi
			putch('x', putdat);
  80083a:	83 c4 08             	add    $0x8,%esp
  80083d:	53                   	push   %ebx
  80083e:	6a 78                	push   $0x78
  800840:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	8d 50 04             	lea    0x4(%eax),%edx
  800848:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80084b:	8b 00                	mov    (%eax),%eax
  80084d:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800852:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800855:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80085a:	eb 0d                	jmp    800869 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80085c:	8d 45 14             	lea    0x14(%ebp),%eax
  80085f:	e8 4e fc ff ff       	call   8004b2 <getuint>
			base = 16;
  800864:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800869:	83 ec 0c             	sub    $0xc,%esp
  80086c:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800870:	57                   	push   %edi
  800871:	ff 75 e0             	pushl  -0x20(%ebp)
  800874:	51                   	push   %ecx
  800875:	52                   	push   %edx
  800876:	50                   	push   %eax
  800877:	89 da                	mov    %ebx,%edx
  800879:	89 f0                	mov    %esi,%eax
  80087b:	e8 83 fb ff ff       	call   800403 <printnum>
			break;
  800880:	83 c4 20             	add    $0x20,%esp
  800883:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800886:	e9 f3 fc ff ff       	jmp    80057e <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80088b:	83 ec 08             	sub    $0x8,%esp
  80088e:	53                   	push   %ebx
  80088f:	51                   	push   %ecx
  800890:	ff d6                	call   *%esi
			break;
  800892:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800895:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800898:	e9 e1 fc ff ff       	jmp    80057e <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80089d:	83 ec 08             	sub    $0x8,%esp
  8008a0:	53                   	push   %ebx
  8008a1:	6a 25                	push   $0x25
  8008a3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008a5:	83 c4 10             	add    $0x10,%esp
  8008a8:	eb 03                	jmp    8008ad <vprintfmt+0x355>
  8008aa:	83 ef 01             	sub    $0x1,%edi
  8008ad:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  8008b1:	75 f7                	jne    8008aa <vprintfmt+0x352>
  8008b3:	e9 c6 fc ff ff       	jmp    80057e <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  8008b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008bb:	5b                   	pop    %ebx
  8008bc:	5e                   	pop    %esi
  8008bd:	5f                   	pop    %edi
  8008be:	5d                   	pop    %ebp
  8008bf:	c3                   	ret    

008008c0 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	83 ec 18             	sub    $0x18,%esp
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008cf:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008d3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008dd:	85 c0                	test   %eax,%eax
  8008df:	74 26                	je     800907 <vsnprintf+0x47>
  8008e1:	85 d2                	test   %edx,%edx
  8008e3:	7e 22                	jle    800907 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008e5:	ff 75 14             	pushl  0x14(%ebp)
  8008e8:	ff 75 10             	pushl  0x10(%ebp)
  8008eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ee:	50                   	push   %eax
  8008ef:	68 1e 05 80 00       	push   $0x80051e
  8008f4:	e8 5f fc ff ff       	call   800558 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008fc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800902:	83 c4 10             	add    $0x10,%esp
  800905:	eb 05                	jmp    80090c <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800907:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80090c:	c9                   	leave  
  80090d:	c3                   	ret    

0080090e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
  800911:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800914:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800917:	50                   	push   %eax
  800918:	ff 75 10             	pushl  0x10(%ebp)
  80091b:	ff 75 0c             	pushl  0xc(%ebp)
  80091e:	ff 75 08             	pushl  0x8(%ebp)
  800921:	e8 9a ff ff ff       	call   8008c0 <vsnprintf>
	va_end(ap);

	return rc;
}
  800926:	c9                   	leave  
  800927:	c3                   	ret    

00800928 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80092e:	b8 00 00 00 00       	mov    $0x0,%eax
  800933:	eb 03                	jmp    800938 <strlen+0x10>
		n++;
  800935:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800938:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80093c:	75 f7                	jne    800935 <strlen+0xd>
		n++;
	return n;
}
  80093e:	5d                   	pop    %ebp
  80093f:	c3                   	ret    

00800940 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800946:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800949:	ba 00 00 00 00       	mov    $0x0,%edx
  80094e:	eb 03                	jmp    800953 <strnlen+0x13>
		n++;
  800950:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800953:	39 c2                	cmp    %eax,%edx
  800955:	74 08                	je     80095f <strnlen+0x1f>
  800957:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80095b:	75 f3                	jne    800950 <strnlen+0x10>
  80095d:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  80095f:	5d                   	pop    %ebp
  800960:	c3                   	ret    

00800961 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800961:	55                   	push   %ebp
  800962:	89 e5                	mov    %esp,%ebp
  800964:	53                   	push   %ebx
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80096b:	89 c2                	mov    %eax,%edx
  80096d:	83 c2 01             	add    $0x1,%edx
  800970:	83 c1 01             	add    $0x1,%ecx
  800973:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800977:	88 5a ff             	mov    %bl,-0x1(%edx)
  80097a:	84 db                	test   %bl,%bl
  80097c:	75 ef                	jne    80096d <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80097e:	5b                   	pop    %ebx
  80097f:	5d                   	pop    %ebp
  800980:	c3                   	ret    

00800981 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	53                   	push   %ebx
  800985:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800988:	53                   	push   %ebx
  800989:	e8 9a ff ff ff       	call   800928 <strlen>
  80098e:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800991:	ff 75 0c             	pushl  0xc(%ebp)
  800994:	01 d8                	add    %ebx,%eax
  800996:	50                   	push   %eax
  800997:	e8 c5 ff ff ff       	call   800961 <strcpy>
	return dst;
}
  80099c:	89 d8                	mov    %ebx,%eax
  80099e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009a1:	c9                   	leave  
  8009a2:	c3                   	ret    

008009a3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
  8009a6:	56                   	push   %esi
  8009a7:	53                   	push   %ebx
  8009a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ae:	89 f3                	mov    %esi,%ebx
  8009b0:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009b3:	89 f2                	mov    %esi,%edx
  8009b5:	eb 0f                	jmp    8009c6 <strncpy+0x23>
		*dst++ = *src;
  8009b7:	83 c2 01             	add    $0x1,%edx
  8009ba:	0f b6 01             	movzbl (%ecx),%eax
  8009bd:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009c0:	80 39 01             	cmpb   $0x1,(%ecx)
  8009c3:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009c6:	39 da                	cmp    %ebx,%edx
  8009c8:	75 ed                	jne    8009b7 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009ca:	89 f0                	mov    %esi,%eax
  8009cc:	5b                   	pop    %ebx
  8009cd:	5e                   	pop    %esi
  8009ce:	5d                   	pop    %ebp
  8009cf:	c3                   	ret    

008009d0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	56                   	push   %esi
  8009d4:	53                   	push   %ebx
  8009d5:	8b 75 08             	mov    0x8(%ebp),%esi
  8009d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009db:	8b 55 10             	mov    0x10(%ebp),%edx
  8009de:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009e0:	85 d2                	test   %edx,%edx
  8009e2:	74 21                	je     800a05 <strlcpy+0x35>
  8009e4:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009e8:	89 f2                	mov    %esi,%edx
  8009ea:	eb 09                	jmp    8009f5 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009ec:	83 c2 01             	add    $0x1,%edx
  8009ef:	83 c1 01             	add    $0x1,%ecx
  8009f2:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009f5:	39 c2                	cmp    %eax,%edx
  8009f7:	74 09                	je     800a02 <strlcpy+0x32>
  8009f9:	0f b6 19             	movzbl (%ecx),%ebx
  8009fc:	84 db                	test   %bl,%bl
  8009fe:	75 ec                	jne    8009ec <strlcpy+0x1c>
  800a00:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  800a02:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a05:	29 f0                	sub    %esi,%eax
}
  800a07:	5b                   	pop    %ebx
  800a08:	5e                   	pop    %esi
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a11:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a14:	eb 06                	jmp    800a1c <strcmp+0x11>
		p++, q++;
  800a16:	83 c1 01             	add    $0x1,%ecx
  800a19:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a1c:	0f b6 01             	movzbl (%ecx),%eax
  800a1f:	84 c0                	test   %al,%al
  800a21:	74 04                	je     800a27 <strcmp+0x1c>
  800a23:	3a 02                	cmp    (%edx),%al
  800a25:	74 ef                	je     800a16 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a27:	0f b6 c0             	movzbl %al,%eax
  800a2a:	0f b6 12             	movzbl (%edx),%edx
  800a2d:	29 d0                	sub    %edx,%eax
}
  800a2f:	5d                   	pop    %ebp
  800a30:	c3                   	ret    

00800a31 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a31:	55                   	push   %ebp
  800a32:	89 e5                	mov    %esp,%ebp
  800a34:	53                   	push   %ebx
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3b:	89 c3                	mov    %eax,%ebx
  800a3d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a40:	eb 06                	jmp    800a48 <strncmp+0x17>
		n--, p++, q++;
  800a42:	83 c0 01             	add    $0x1,%eax
  800a45:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a48:	39 d8                	cmp    %ebx,%eax
  800a4a:	74 15                	je     800a61 <strncmp+0x30>
  800a4c:	0f b6 08             	movzbl (%eax),%ecx
  800a4f:	84 c9                	test   %cl,%cl
  800a51:	74 04                	je     800a57 <strncmp+0x26>
  800a53:	3a 0a                	cmp    (%edx),%cl
  800a55:	74 eb                	je     800a42 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a57:	0f b6 00             	movzbl (%eax),%eax
  800a5a:	0f b6 12             	movzbl (%edx),%edx
  800a5d:	29 d0                	sub    %edx,%eax
  800a5f:	eb 05                	jmp    800a66 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a61:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a66:	5b                   	pop    %ebx
  800a67:	5d                   	pop    %ebp
  800a68:	c3                   	ret    

00800a69 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
  800a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a73:	eb 07                	jmp    800a7c <strchr+0x13>
		if (*s == c)
  800a75:	38 ca                	cmp    %cl,%dl
  800a77:	74 0f                	je     800a88 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a79:	83 c0 01             	add    $0x1,%eax
  800a7c:	0f b6 10             	movzbl (%eax),%edx
  800a7f:	84 d2                	test   %dl,%dl
  800a81:	75 f2                	jne    800a75 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a88:	5d                   	pop    %ebp
  800a89:	c3                   	ret    

00800a8a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a94:	eb 03                	jmp    800a99 <strfind+0xf>
  800a96:	83 c0 01             	add    $0x1,%eax
  800a99:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a9c:	38 ca                	cmp    %cl,%dl
  800a9e:	74 04                	je     800aa4 <strfind+0x1a>
  800aa0:	84 d2                	test   %dl,%dl
  800aa2:	75 f2                	jne    800a96 <strfind+0xc>
			break;
	return (char *) s;
}
  800aa4:	5d                   	pop    %ebp
  800aa5:	c3                   	ret    

00800aa6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
  800aa9:	57                   	push   %edi
  800aaa:	56                   	push   %esi
  800aab:	53                   	push   %ebx
  800aac:	8b 55 08             	mov    0x8(%ebp),%edx
  800aaf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800ab2:	85 c9                	test   %ecx,%ecx
  800ab4:	74 37                	je     800aed <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ab6:	f6 c2 03             	test   $0x3,%dl
  800ab9:	75 2a                	jne    800ae5 <memset+0x3f>
  800abb:	f6 c1 03             	test   $0x3,%cl
  800abe:	75 25                	jne    800ae5 <memset+0x3f>
		c &= 0xFF;
  800ac0:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ac4:	89 df                	mov    %ebx,%edi
  800ac6:	c1 e7 08             	shl    $0x8,%edi
  800ac9:	89 de                	mov    %ebx,%esi
  800acb:	c1 e6 18             	shl    $0x18,%esi
  800ace:	89 d8                	mov    %ebx,%eax
  800ad0:	c1 e0 10             	shl    $0x10,%eax
  800ad3:	09 f0                	or     %esi,%eax
  800ad5:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800ad7:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800ada:	89 f8                	mov    %edi,%eax
  800adc:	09 d8                	or     %ebx,%eax
  800ade:	89 d7                	mov    %edx,%edi
  800ae0:	fc                   	cld    
  800ae1:	f3 ab                	rep stos %eax,%es:(%edi)
  800ae3:	eb 08                	jmp    800aed <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ae5:	89 d7                	mov    %edx,%edi
  800ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aea:	fc                   	cld    
  800aeb:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800aed:	89 d0                	mov    %edx,%eax
  800aef:	5b                   	pop    %ebx
  800af0:	5e                   	pop    %esi
  800af1:	5f                   	pop    %edi
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	57                   	push   %edi
  800af8:	56                   	push   %esi
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aff:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b02:	39 c6                	cmp    %eax,%esi
  800b04:	73 35                	jae    800b3b <memmove+0x47>
  800b06:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b09:	39 d0                	cmp    %edx,%eax
  800b0b:	73 2e                	jae    800b3b <memmove+0x47>
		s += n;
		d += n;
  800b0d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b10:	89 d6                	mov    %edx,%esi
  800b12:	09 fe                	or     %edi,%esi
  800b14:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b1a:	75 13                	jne    800b2f <memmove+0x3b>
  800b1c:	f6 c1 03             	test   $0x3,%cl
  800b1f:	75 0e                	jne    800b2f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  800b21:	83 ef 04             	sub    $0x4,%edi
  800b24:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b27:	c1 e9 02             	shr    $0x2,%ecx
  800b2a:	fd                   	std    
  800b2b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b2d:	eb 09                	jmp    800b38 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b2f:	83 ef 01             	sub    $0x1,%edi
  800b32:	8d 72 ff             	lea    -0x1(%edx),%esi
  800b35:	fd                   	std    
  800b36:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b38:	fc                   	cld    
  800b39:	eb 1d                	jmp    800b58 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b3b:	89 f2                	mov    %esi,%edx
  800b3d:	09 c2                	or     %eax,%edx
  800b3f:	f6 c2 03             	test   $0x3,%dl
  800b42:	75 0f                	jne    800b53 <memmove+0x5f>
  800b44:	f6 c1 03             	test   $0x3,%cl
  800b47:	75 0a                	jne    800b53 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  800b49:	c1 e9 02             	shr    $0x2,%ecx
  800b4c:	89 c7                	mov    %eax,%edi
  800b4e:	fc                   	cld    
  800b4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b51:	eb 05                	jmp    800b58 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b53:	89 c7                	mov    %eax,%edi
  800b55:	fc                   	cld    
  800b56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b58:	5e                   	pop    %esi
  800b59:	5f                   	pop    %edi
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b5f:	ff 75 10             	pushl  0x10(%ebp)
  800b62:	ff 75 0c             	pushl  0xc(%ebp)
  800b65:	ff 75 08             	pushl  0x8(%ebp)
  800b68:	e8 87 ff ff ff       	call   800af4 <memmove>
}
  800b6d:	c9                   	leave  
  800b6e:	c3                   	ret    

00800b6f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	56                   	push   %esi
  800b73:	53                   	push   %ebx
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7a:	89 c6                	mov    %eax,%esi
  800b7c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b7f:	eb 1a                	jmp    800b9b <memcmp+0x2c>
		if (*s1 != *s2)
  800b81:	0f b6 08             	movzbl (%eax),%ecx
  800b84:	0f b6 1a             	movzbl (%edx),%ebx
  800b87:	38 d9                	cmp    %bl,%cl
  800b89:	74 0a                	je     800b95 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b8b:	0f b6 c1             	movzbl %cl,%eax
  800b8e:	0f b6 db             	movzbl %bl,%ebx
  800b91:	29 d8                	sub    %ebx,%eax
  800b93:	eb 0f                	jmp    800ba4 <memcmp+0x35>
		s1++, s2++;
  800b95:	83 c0 01             	add    $0x1,%eax
  800b98:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b9b:	39 f0                	cmp    %esi,%eax
  800b9d:	75 e2                	jne    800b81 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ba4:	5b                   	pop    %ebx
  800ba5:	5e                   	pop    %esi
  800ba6:	5d                   	pop    %ebp
  800ba7:	c3                   	ret    

00800ba8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ba8:	55                   	push   %ebp
  800ba9:	89 e5                	mov    %esp,%ebp
  800bab:	53                   	push   %ebx
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800baf:	89 c1                	mov    %eax,%ecx
  800bb1:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  800bb4:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bb8:	eb 0a                	jmp    800bc4 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bba:	0f b6 10             	movzbl (%eax),%edx
  800bbd:	39 da                	cmp    %ebx,%edx
  800bbf:	74 07                	je     800bc8 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bc1:	83 c0 01             	add    $0x1,%eax
  800bc4:	39 c8                	cmp    %ecx,%eax
  800bc6:	72 f2                	jb     800bba <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800bc8:	5b                   	pop    %ebx
  800bc9:	5d                   	pop    %ebp
  800bca:	c3                   	ret    

00800bcb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	57                   	push   %edi
  800bcf:	56                   	push   %esi
  800bd0:	53                   	push   %ebx
  800bd1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bd7:	eb 03                	jmp    800bdc <strtol+0x11>
		s++;
  800bd9:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bdc:	0f b6 01             	movzbl (%ecx),%eax
  800bdf:	3c 20                	cmp    $0x20,%al
  800be1:	74 f6                	je     800bd9 <strtol+0xe>
  800be3:	3c 09                	cmp    $0x9,%al
  800be5:	74 f2                	je     800bd9 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800be7:	3c 2b                	cmp    $0x2b,%al
  800be9:	75 0a                	jne    800bf5 <strtol+0x2a>
		s++;
  800beb:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800bee:	bf 00 00 00 00       	mov    $0x0,%edi
  800bf3:	eb 11                	jmp    800c06 <strtol+0x3b>
  800bf5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800bfa:	3c 2d                	cmp    $0x2d,%al
  800bfc:	75 08                	jne    800c06 <strtol+0x3b>
		s++, neg = 1;
  800bfe:	83 c1 01             	add    $0x1,%ecx
  800c01:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c06:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c0c:	75 15                	jne    800c23 <strtol+0x58>
  800c0e:	80 39 30             	cmpb   $0x30,(%ecx)
  800c11:	75 10                	jne    800c23 <strtol+0x58>
  800c13:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c17:	75 7c                	jne    800c95 <strtol+0xca>
		s += 2, base = 16;
  800c19:	83 c1 02             	add    $0x2,%ecx
  800c1c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c21:	eb 16                	jmp    800c39 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800c23:	85 db                	test   %ebx,%ebx
  800c25:	75 12                	jne    800c39 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c27:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c2c:	80 39 30             	cmpb   $0x30,(%ecx)
  800c2f:	75 08                	jne    800c39 <strtol+0x6e>
		s++, base = 8;
  800c31:	83 c1 01             	add    $0x1,%ecx
  800c34:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800c39:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3e:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c41:	0f b6 11             	movzbl (%ecx),%edx
  800c44:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c47:	89 f3                	mov    %esi,%ebx
  800c49:	80 fb 09             	cmp    $0x9,%bl
  800c4c:	77 08                	ja     800c56 <strtol+0x8b>
			dig = *s - '0';
  800c4e:	0f be d2             	movsbl %dl,%edx
  800c51:	83 ea 30             	sub    $0x30,%edx
  800c54:	eb 22                	jmp    800c78 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800c56:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c59:	89 f3                	mov    %esi,%ebx
  800c5b:	80 fb 19             	cmp    $0x19,%bl
  800c5e:	77 08                	ja     800c68 <strtol+0x9d>
			dig = *s - 'a' + 10;
  800c60:	0f be d2             	movsbl %dl,%edx
  800c63:	83 ea 57             	sub    $0x57,%edx
  800c66:	eb 10                	jmp    800c78 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800c68:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c6b:	89 f3                	mov    %esi,%ebx
  800c6d:	80 fb 19             	cmp    $0x19,%bl
  800c70:	77 16                	ja     800c88 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800c72:	0f be d2             	movsbl %dl,%edx
  800c75:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800c78:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c7b:	7d 0b                	jge    800c88 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800c7d:	83 c1 01             	add    $0x1,%ecx
  800c80:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c84:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800c86:	eb b9                	jmp    800c41 <strtol+0x76>

	if (endptr)
  800c88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8c:	74 0d                	je     800c9b <strtol+0xd0>
		*endptr = (char *) s;
  800c8e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c91:	89 0e                	mov    %ecx,(%esi)
  800c93:	eb 06                	jmp    800c9b <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c95:	85 db                	test   %ebx,%ebx
  800c97:	74 98                	je     800c31 <strtol+0x66>
  800c99:	eb 9e                	jmp    800c39 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800c9b:	89 c2                	mov    %eax,%edx
  800c9d:	f7 da                	neg    %edx
  800c9f:	85 ff                	test   %edi,%edi
  800ca1:	0f 45 c2             	cmovne %edx,%eax
}
  800ca4:	5b                   	pop    %ebx
  800ca5:	5e                   	pop    %esi
  800ca6:	5f                   	pop    %edi
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	57                   	push   %edi
  800cad:	56                   	push   %esi
  800cae:	53                   	push   %ebx
  800caf:	83 ec 1c             	sub    $0x1c,%esp
  800cb2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800cb5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800cb8:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cbd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800cc0:	8b 7d 10             	mov    0x10(%ebp),%edi
  800cc3:	8b 75 14             	mov    0x14(%ebp),%esi
  800cc6:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800cc8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ccc:	74 1d                	je     800ceb <syscall+0x42>
  800cce:	85 c0                	test   %eax,%eax
  800cd0:	7e 19                	jle    800ceb <syscall+0x42>
  800cd2:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd5:	83 ec 0c             	sub    $0xc,%esp
  800cd8:	50                   	push   %eax
  800cd9:	52                   	push   %edx
  800cda:	68 bf 29 80 00       	push   $0x8029bf
  800cdf:	6a 23                	push   $0x23
  800ce1:	68 dc 29 80 00       	push   $0x8029dc
  800ce6:	e8 2b f6 ff ff       	call   800316 <_panic>

	return ret;
}
  800ceb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cee:	5b                   	pop    %ebx
  800cef:	5e                   	pop    %esi
  800cf0:	5f                   	pop    %edi
  800cf1:	5d                   	pop    %ebp
  800cf2:	c3                   	ret    

00800cf3 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800cf9:	6a 00                	push   $0x0
  800cfb:	6a 00                	push   $0x0
  800cfd:	6a 00                	push   $0x0
  800cff:	ff 75 0c             	pushl  0xc(%ebp)
  800d02:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d05:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0f:	e8 95 ff ff ff       	call   800ca9 <syscall>
}
  800d14:	83 c4 10             	add    $0x10,%esp
  800d17:	c9                   	leave  
  800d18:	c3                   	ret    

00800d19 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800d1f:	6a 00                	push   $0x0
  800d21:	6a 00                	push   $0x0
  800d23:	6a 00                	push   $0x0
  800d25:	6a 00                	push   $0x0
  800d27:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d31:	b8 01 00 00 00       	mov    $0x1,%eax
  800d36:	e8 6e ff ff ff       	call   800ca9 <syscall>
}
  800d3b:	c9                   	leave  
  800d3c:	c3                   	ret    

00800d3d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800d43:	6a 00                	push   $0x0
  800d45:	6a 00                	push   $0x0
  800d47:	6a 00                	push   $0x0
  800d49:	6a 00                	push   $0x0
  800d4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d4e:	ba 01 00 00 00       	mov    $0x1,%edx
  800d53:	b8 03 00 00 00       	mov    $0x3,%eax
  800d58:	e8 4c ff ff ff       	call   800ca9 <syscall>
}
  800d5d:	c9                   	leave  
  800d5e:	c3                   	ret    

00800d5f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800d65:	6a 00                	push   $0x0
  800d67:	6a 00                	push   $0x0
  800d69:	6a 00                	push   $0x0
  800d6b:	6a 00                	push   $0x0
  800d6d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d72:	ba 00 00 00 00       	mov    $0x0,%edx
  800d77:	b8 02 00 00 00       	mov    $0x2,%eax
  800d7c:	e8 28 ff ff ff       	call   800ca9 <syscall>
}
  800d81:	c9                   	leave  
  800d82:	c3                   	ret    

00800d83 <sys_yield>:

void
sys_yield(void)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800d89:	6a 00                	push   $0x0
  800d8b:	6a 00                	push   $0x0
  800d8d:	6a 00                	push   $0x0
  800d8f:	6a 00                	push   $0x0
  800d91:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d96:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800da0:	e8 04 ff ff ff       	call   800ca9 <syscall>
}
  800da5:	83 c4 10             	add    $0x10,%esp
  800da8:	c9                   	leave  
  800da9:	c3                   	ret    

00800daa <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800db0:	6a 00                	push   $0x0
  800db2:	6a 00                	push   $0x0
  800db4:	ff 75 10             	pushl  0x10(%ebp)
  800db7:	ff 75 0c             	pushl  0xc(%ebp)
  800dba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dbd:	ba 01 00 00 00       	mov    $0x1,%edx
  800dc2:	b8 04 00 00 00       	mov    $0x4,%eax
  800dc7:	e8 dd fe ff ff       	call   800ca9 <syscall>
}
  800dcc:	c9                   	leave  
  800dcd:	c3                   	ret    

00800dce <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dce:	55                   	push   %ebp
  800dcf:	89 e5                	mov    %esp,%ebp
  800dd1:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800dd4:	ff 75 18             	pushl  0x18(%ebp)
  800dd7:	ff 75 14             	pushl  0x14(%ebp)
  800dda:	ff 75 10             	pushl  0x10(%ebp)
  800ddd:	ff 75 0c             	pushl  0xc(%ebp)
  800de0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800de3:	ba 01 00 00 00       	mov    $0x1,%edx
  800de8:	b8 05 00 00 00       	mov    $0x5,%eax
  800ded:	e8 b7 fe ff ff       	call   800ca9 <syscall>
}
  800df2:	c9                   	leave  
  800df3:	c3                   	ret    

00800df4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800dfa:	6a 00                	push   $0x0
  800dfc:	6a 00                	push   $0x0
  800dfe:	6a 00                	push   $0x0
  800e00:	ff 75 0c             	pushl  0xc(%ebp)
  800e03:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e06:	ba 01 00 00 00       	mov    $0x1,%edx
  800e0b:	b8 06 00 00 00       	mov    $0x6,%eax
  800e10:	e8 94 fe ff ff       	call   800ca9 <syscall>
}
  800e15:	c9                   	leave  
  800e16:	c3                   	ret    

00800e17 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800e1d:	6a 00                	push   $0x0
  800e1f:	6a 00                	push   $0x0
  800e21:	6a 00                	push   $0x0
  800e23:	ff 75 0c             	pushl  0xc(%ebp)
  800e26:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e29:	ba 01 00 00 00       	mov    $0x1,%edx
  800e2e:	b8 08 00 00 00       	mov    $0x8,%eax
  800e33:	e8 71 fe ff ff       	call   800ca9 <syscall>
}
  800e38:	c9                   	leave  
  800e39:	c3                   	ret    

00800e3a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800e40:	6a 00                	push   $0x0
  800e42:	6a 00                	push   $0x0
  800e44:	6a 00                	push   $0x0
  800e46:	ff 75 0c             	pushl  0xc(%ebp)
  800e49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e4c:	ba 01 00 00 00       	mov    $0x1,%edx
  800e51:	b8 09 00 00 00       	mov    $0x9,%eax
  800e56:	e8 4e fe ff ff       	call   800ca9 <syscall>
}
  800e5b:	c9                   	leave  
  800e5c:	c3                   	ret    

00800e5d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800e63:	6a 00                	push   $0x0
  800e65:	6a 00                	push   $0x0
  800e67:	6a 00                	push   $0x0
  800e69:	ff 75 0c             	pushl  0xc(%ebp)
  800e6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e6f:	ba 01 00 00 00       	mov    $0x1,%edx
  800e74:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e79:	e8 2b fe ff ff       	call   800ca9 <syscall>
}
  800e7e:	c9                   	leave  
  800e7f:	c3                   	ret    

00800e80 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800e86:	6a 00                	push   $0x0
  800e88:	ff 75 14             	pushl  0x14(%ebp)
  800e8b:	ff 75 10             	pushl  0x10(%ebp)
  800e8e:	ff 75 0c             	pushl  0xc(%ebp)
  800e91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e94:	ba 00 00 00 00       	mov    $0x0,%edx
  800e99:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e9e:	e8 06 fe ff ff       	call   800ca9 <syscall>
}
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800eab:	6a 00                	push   $0x0
  800ead:	6a 00                	push   $0x0
  800eaf:	6a 00                	push   $0x0
  800eb1:	6a 00                	push   $0x0
  800eb3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eb6:	ba 01 00 00 00       	mov    $0x1,%edx
  800ebb:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ec0:	e8 e4 fd ff ff       	call   800ca9 <syscall>
}
  800ec5:	c9                   	leave  
  800ec6:	c3                   	ret    

00800ec7 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	53                   	push   %ebx
  800ecb:	83 ec 04             	sub    $0x4,%esp

	int perm_w = PTE_COW|PTE_U|PTE_P;
	int perm = PTE_U|PTE_P;

	// LAB 4: Your code here.
	void *addr = (void*) (pn*PGSIZE);
  800ece:	89 d3                	mov    %edx,%ebx
  800ed0:	c1 e3 0c             	shl    $0xc,%ebx

	//Si una página tiene el bit PTE_SHARE, se comparte con el hijo con los mismos permisos.
  	if (uvpt[pn] & PTE_SHARE) {
  800ed3:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800eda:	f6 c5 04             	test   $0x4,%ch
  800edd:	74 3a                	je     800f19 <duppage+0x52>
    	if (sys_page_map(0, addr, envid,addr, uvpt[pn] & PTE_SYSCALL) < 0) {
  800edf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ee6:	83 ec 0c             	sub    $0xc,%esp
  800ee9:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800eef:	52                   	push   %edx
  800ef0:	53                   	push   %ebx
  800ef1:	50                   	push   %eax
  800ef2:	53                   	push   %ebx
  800ef3:	6a 00                	push   $0x0
  800ef5:	e8 d4 fe ff ff       	call   800dce <sys_page_map>
  800efa:	83 c4 20             	add    $0x20,%esp
  800efd:	85 c0                	test   %eax,%eax
  800eff:	0f 89 99 00 00 00    	jns    800f9e <duppage+0xd7>
 	     	panic("Error en sys_page_map");
  800f05:	83 ec 04             	sub    $0x4,%esp
  800f08:	68 ea 29 80 00       	push   $0x8029ea
  800f0d:	6a 50                	push   $0x50
  800f0f:	68 00 2a 80 00       	push   $0x802a00
  800f14:	e8 fd f3 ff ff       	call   800316 <_panic>
    	} 
    	return 0;
	}

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  800f19:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800f20:	f6 c1 02             	test   $0x2,%cl
  800f23:	75 0c                	jne    800f31 <duppage+0x6a>
  800f25:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f2c:	f6 c6 08             	test   $0x8,%dh
  800f2f:	74 5b                	je     800f8c <duppage+0xc5>
		if (sys_page_map(0, addr, envid, addr, perm_w) < 0){
  800f31:	83 ec 0c             	sub    $0xc,%esp
  800f34:	68 05 08 00 00       	push   $0x805
  800f39:	53                   	push   %ebx
  800f3a:	50                   	push   %eax
  800f3b:	53                   	push   %ebx
  800f3c:	6a 00                	push   $0x0
  800f3e:	e8 8b fe ff ff       	call   800dce <sys_page_map>
  800f43:	83 c4 20             	add    $0x20,%esp
  800f46:	85 c0                	test   %eax,%eax
  800f48:	79 14                	jns    800f5e <duppage+0x97>
			panic("Error mapeando pagina Padre");
  800f4a:	83 ec 04             	sub    $0x4,%esp
  800f4d:	68 0b 2a 80 00       	push   $0x802a0b
  800f52:	6a 57                	push   $0x57
  800f54:	68 00 2a 80 00       	push   $0x802a00
  800f59:	e8 b8 f3 ff ff       	call   800316 <_panic>
		}
		if (sys_page_map(0, addr, 0, addr, perm_w) < 0){
  800f5e:	83 ec 0c             	sub    $0xc,%esp
  800f61:	68 05 08 00 00       	push   $0x805
  800f66:	53                   	push   %ebx
  800f67:	6a 00                	push   $0x0
  800f69:	53                   	push   %ebx
  800f6a:	6a 00                	push   $0x0
  800f6c:	e8 5d fe ff ff       	call   800dce <sys_page_map>
  800f71:	83 c4 20             	add    $0x20,%esp
  800f74:	85 c0                	test   %eax,%eax
  800f76:	79 26                	jns    800f9e <duppage+0xd7>
			panic("Error mapeando pagina Hijo");
  800f78:	83 ec 04             	sub    $0x4,%esp
  800f7b:	68 27 2a 80 00       	push   $0x802a27
  800f80:	6a 5a                	push   $0x5a
  800f82:	68 00 2a 80 00       	push   $0x802a00
  800f87:	e8 8a f3 ff ff       	call   800316 <_panic>
		}
	} else sys_page_map(0, addr, envid, addr, perm);
  800f8c:	83 ec 0c             	sub    $0xc,%esp
  800f8f:	6a 05                	push   $0x5
  800f91:	53                   	push   %ebx
  800f92:	50                   	push   %eax
  800f93:	53                   	push   %ebx
  800f94:	6a 00                	push   $0x0
  800f96:	e8 33 fe ff ff       	call   800dce <sys_page_map>
  800f9b:	83 c4 20             	add    $0x20,%esp
	
	return 0;
}
  800f9e:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fa6:	c9                   	leave  
  800fa7:	c3                   	ret    

00800fa8 <dup_or_share>:
//FORK V0

static void
dup_or_share(envid_t dstenv, void *va, int perm){
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	57                   	push   %edi
  800fac:	56                   	push   %esi
  800fad:	53                   	push   %ebx
  800fae:	83 ec 0c             	sub    $0xc,%esp
  800fb1:	89 c7                	mov    %eax,%edi
  800fb3:	89 d6                	mov    %edx,%esi
  800fb5:	89 cb                	mov    %ecx,%ebx
	int result;
	// Si no es de escritura, comparto la pagina
	if((perm &PTE_W) != PTE_W){
  800fb7:	f6 c1 02             	test   $0x2,%cl
  800fba:	75 2d                	jne    800fe9 <dup_or_share+0x41>
		if((result = sys_page_map(0, va, dstenv, va, perm))<0){
  800fbc:	83 ec 0c             	sub    $0xc,%esp
  800fbf:	51                   	push   %ecx
  800fc0:	52                   	push   %edx
  800fc1:	50                   	push   %eax
  800fc2:	52                   	push   %edx
  800fc3:	6a 00                	push   $0x0
  800fc5:	e8 04 fe ff ff       	call   800dce <sys_page_map>
  800fca:	83 c4 20             	add    $0x20,%esp
  800fcd:	85 c0                	test   %eax,%eax
  800fcf:	0f 89 a4 00 00 00    	jns    801079 <dup_or_share+0xd1>
			panic("Error compartiendo la pagina");
  800fd5:	83 ec 04             	sub    $0x4,%esp
  800fd8:	68 42 2a 80 00       	push   $0x802a42
  800fdd:	6a 68                	push   $0x68
  800fdf:	68 00 2a 80 00       	push   $0x802a00
  800fe4:	e8 2d f3 ff ff       	call   800316 <_panic>
		}
	// Si es de escritura comportamiento de duppage, en dumbfork
	}else{
		if ((result = sys_page_alloc(dstenv, va, perm)) < 0){
  800fe9:	83 ec 04             	sub    $0x4,%esp
  800fec:	51                   	push   %ecx
  800fed:	52                   	push   %edx
  800fee:	50                   	push   %eax
  800fef:	e8 b6 fd ff ff       	call   800daa <sys_page_alloc>
  800ff4:	83 c4 10             	add    $0x10,%esp
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	79 14                	jns    80100f <dup_or_share+0x67>
			panic("Error copiando la pagina");
  800ffb:	83 ec 04             	sub    $0x4,%esp
  800ffe:	68 5f 2a 80 00       	push   $0x802a5f
  801003:	6a 6d                	push   $0x6d
  801005:	68 00 2a 80 00       	push   $0x802a00
  80100a:	e8 07 f3 ff ff       	call   800316 <_panic>
		}
		if ((result = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0){
  80100f:	83 ec 0c             	sub    $0xc,%esp
  801012:	53                   	push   %ebx
  801013:	68 00 00 40 00       	push   $0x400000
  801018:	6a 00                	push   $0x0
  80101a:	56                   	push   %esi
  80101b:	57                   	push   %edi
  80101c:	e8 ad fd ff ff       	call   800dce <sys_page_map>
  801021:	83 c4 20             	add    $0x20,%esp
  801024:	85 c0                	test   %eax,%eax
  801026:	79 14                	jns    80103c <dup_or_share+0x94>
			panic("Error copiando la pagina");
  801028:	83 ec 04             	sub    $0x4,%esp
  80102b:	68 5f 2a 80 00       	push   $0x802a5f
  801030:	6a 70                	push   $0x70
  801032:	68 00 2a 80 00       	push   $0x802a00
  801037:	e8 da f2 ff ff       	call   800316 <_panic>
		}
		memmove(UTEMP, va, PGSIZE);
  80103c:	83 ec 04             	sub    $0x4,%esp
  80103f:	68 00 10 00 00       	push   $0x1000
  801044:	56                   	push   %esi
  801045:	68 00 00 40 00       	push   $0x400000
  80104a:	e8 a5 fa ff ff       	call   800af4 <memmove>
		if ((result = sys_page_unmap(0, UTEMP)) < 0){
  80104f:	83 c4 08             	add    $0x8,%esp
  801052:	68 00 00 40 00       	push   $0x400000
  801057:	6a 00                	push   $0x0
  801059:	e8 96 fd ff ff       	call   800df4 <sys_page_unmap>
  80105e:	83 c4 10             	add    $0x10,%esp
  801061:	85 c0                	test   %eax,%eax
  801063:	79 14                	jns    801079 <dup_or_share+0xd1>
			panic("Error copiando la pagina");
  801065:	83 ec 04             	sub    $0x4,%esp
  801068:	68 5f 2a 80 00       	push   $0x802a5f
  80106d:	6a 74                	push   $0x74
  80106f:	68 00 2a 80 00       	push   $0x802a00
  801074:	e8 9d f2 ff ff       	call   800316 <_panic>
		}
	}	
}
  801079:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80107c:	5b                   	pop    %ebx
  80107d:	5e                   	pop    %esi
  80107e:	5f                   	pop    %edi
  80107f:	5d                   	pop    %ebp
  801080:	c3                   	ret    

00801081 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	53                   	push   %ebx
  801085:	83 ec 04             	sub    $0x4,%esp
  801088:	8b 55 08             	mov    0x8(%ebp),%edx
	void *va = (void *) utf->utf_fault_va;
  80108b:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  80108d:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801091:	74 2e                	je     8010c1 <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
  801093:	89 c2                	mov    %eax,%edx
  801095:	c1 ea 16             	shr    $0x16,%edx
  801098:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  80109f:	f6 c2 01             	test   $0x1,%dl
  8010a2:	74 1d                	je     8010c1 <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
  8010a4:	89 c2                	mov    %eax,%edx
  8010a6:	c1 ea 0c             	shr    $0xc,%edx
  8010a9:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
		(uvpd[PDX(va)] & PTE_P) && 
  8010b0:	f6 c1 01             	test   $0x1,%cl
  8010b3:	74 0c                	je     8010c1 <pgfault+0x40>
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
  8010b5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  8010bc:	f6 c6 08             	test   $0x8,%dh
  8010bf:	75 14                	jne    8010d5 <pgfault+0x54>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
		panic("No es copy-on-write");
  8010c1:	83 ec 04             	sub    $0x4,%esp
  8010c4:	68 78 2a 80 00       	push   $0x802a78
  8010c9:	6a 21                	push   $0x21
  8010cb:	68 00 2a 80 00       	push   $0x802a00
  8010d0:	e8 41 f2 ff ff       	call   800316 <_panic>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	va = ROUNDDOWN(va, PGSIZE);
  8010d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010da:	89 c3                	mov    %eax,%ebx
	if (sys_page_alloc(0, PFTEMP, perm) < 0){
  8010dc:	83 ec 04             	sub    $0x4,%esp
  8010df:	6a 07                	push   $0x7
  8010e1:	68 00 f0 7f 00       	push   $0x7ff000
  8010e6:	6a 00                	push   $0x0
  8010e8:	e8 bd fc ff ff       	call   800daa <sys_page_alloc>
  8010ed:	83 c4 10             	add    $0x10,%esp
  8010f0:	85 c0                	test   %eax,%eax
  8010f2:	79 14                	jns    801108 <pgfault+0x87>
		panic("Error sys_page_alloc");
  8010f4:	83 ec 04             	sub    $0x4,%esp
  8010f7:	68 8c 2a 80 00       	push   $0x802a8c
  8010fc:	6a 2a                	push   $0x2a
  8010fe:	68 00 2a 80 00       	push   $0x802a00
  801103:	e8 0e f2 ff ff       	call   800316 <_panic>
	}
	memcpy(PFTEMP, va, PGSIZE);
  801108:	83 ec 04             	sub    $0x4,%esp
  80110b:	68 00 10 00 00       	push   $0x1000
  801110:	53                   	push   %ebx
  801111:	68 00 f0 7f 00       	push   $0x7ff000
  801116:	e8 41 fa ff ff       	call   800b5c <memcpy>
	if (sys_page_map(0, PFTEMP, 0, va, perm) < 0){
  80111b:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801122:	53                   	push   %ebx
  801123:	6a 00                	push   $0x0
  801125:	68 00 f0 7f 00       	push   $0x7ff000
  80112a:	6a 00                	push   $0x0
  80112c:	e8 9d fc ff ff       	call   800dce <sys_page_map>
  801131:	83 c4 20             	add    $0x20,%esp
  801134:	85 c0                	test   %eax,%eax
  801136:	79 14                	jns    80114c <pgfault+0xcb>
		panic("Error sys_page_map");
  801138:	83 ec 04             	sub    $0x4,%esp
  80113b:	68 a1 2a 80 00       	push   $0x802aa1
  801140:	6a 2e                	push   $0x2e
  801142:	68 00 2a 80 00       	push   $0x802a00
  801147:	e8 ca f1 ff ff       	call   800316 <_panic>
	}
	if (sys_page_unmap(0, PFTEMP) < 0){
  80114c:	83 ec 08             	sub    $0x8,%esp
  80114f:	68 00 f0 7f 00       	push   $0x7ff000
  801154:	6a 00                	push   $0x0
  801156:	e8 99 fc ff ff       	call   800df4 <sys_page_unmap>
  80115b:	83 c4 10             	add    $0x10,%esp
  80115e:	85 c0                	test   %eax,%eax
  801160:	79 14                	jns    801176 <pgfault+0xf5>
		panic("Error sys_page_unmap");
  801162:	83 ec 04             	sub    $0x4,%esp
  801165:	68 b4 2a 80 00       	push   $0x802ab4
  80116a:	6a 31                	push   $0x31
  80116c:	68 00 2a 80 00       	push   $0x802a00
  801171:	e8 a0 f1 ff ff       	call   800316 <_panic>
	}
	return;

}
  801176:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801179:	c9                   	leave  
  80117a:	c3                   	ret    

0080117b <fork_v0>:
		}
	}	
}

envid_t
fork_v0(void){
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	57                   	push   %edi
  80117f:	56                   	push   %esi
  801180:	53                   	push   %ebx
  801181:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801184:	b8 07 00 00 00       	mov    $0x7,%eax
  801189:	cd 30                	int    $0x30
  80118b:	89 c6                	mov    %eax,%esi
	envid_t envid;
	uint8_t *va;
	int result;	

	envid = sys_exofork();
	if (envid < 0)
  80118d:	85 c0                	test   %eax,%eax
  80118f:	79 15                	jns    8011a6 <fork_v0+0x2b>
		panic("sys_exofork: %e", envid);
  801191:	50                   	push   %eax
  801192:	68 c9 2a 80 00       	push   $0x802ac9
  801197:	68 81 00 00 00       	push   $0x81
  80119c:	68 00 2a 80 00       	push   $0x802a00
  8011a1:	e8 70 f1 ff ff       	call   800316 <_panic>
  8011a6:	89 c7                	mov    %eax,%edi
  8011a8:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {		
  8011ad:	85 c0                	test   %eax,%eax
  8011af:	75 1e                	jne    8011cf <fork_v0+0x54>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011b1:	e8 a9 fb ff ff       	call   800d5f <sys_getenvid>
  8011b6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011bb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011be:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011c3:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8011c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8011cd:	eb 7a                	jmp    801249 <fork_v0+0xce>
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  8011cf:	89 d8                	mov    %ebx,%eax
  8011d1:	c1 e8 16             	shr    $0x16,%eax
  8011d4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011db:	a8 01                	test   $0x1,%al
  8011dd:	74 33                	je     801212 <fork_v0+0x97>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  8011df:	89 d8                	mov    %ebx,%eax
  8011e1:	c1 e8 0c             	shr    $0xc,%eax
  8011e4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011eb:	f6 c2 01             	test   $0x1,%dl
  8011ee:	74 22                	je     801212 <fork_v0+0x97>
  8011f0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011f7:	f6 c2 04             	test   $0x4,%dl
  8011fa:	74 16                	je     801212 <fork_v0+0x97>
				pte_t pte =uvpt[PGNUM(va)];
  8011fc:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
  801203:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801209:	89 da                	mov    %ebx,%edx
  80120b:	89 f8                	mov    %edi,%eax
  80120d:	e8 96 fd ff ff       	call   800fa8 <dup_or_share>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
  801212:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801218:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  80121e:	75 af                	jne    8011cf <fork_v0+0x54>
				pte_t pte =uvpt[PGNUM(va)];
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
			}
		}
	}	
	if ((result = sys_env_set_status(envid, ENV_RUNNABLE)) < 0){
  801220:	83 ec 08             	sub    $0x8,%esp
  801223:	6a 02                	push   $0x2
  801225:	56                   	push   %esi
  801226:	e8 ec fb ff ff       	call   800e17 <sys_env_set_status>
  80122b:	83 c4 10             	add    $0x10,%esp
  80122e:	85 c0                	test   %eax,%eax
  801230:	79 15                	jns    801247 <fork_v0+0xcc>

		panic("sys_env_set_status: %e", result);
  801232:	50                   	push   %eax
  801233:	68 d9 2a 80 00       	push   $0x802ad9
  801238:	68 90 00 00 00       	push   $0x90
  80123d:	68 00 2a 80 00       	push   $0x802a00
  801242:	e8 cf f0 ff ff       	call   800316 <_panic>
	}
	return envid;
  801247:	89 f0                	mov    %esi,%eax
}
  801249:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80124c:	5b                   	pop    %ebx
  80124d:	5e                   	pop    %esi
  80124e:	5f                   	pop    %edi
  80124f:	5d                   	pop    %ebp
  801250:	c3                   	ret    

00801251 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	57                   	push   %edi
  801255:	56                   	push   %esi
  801256:	53                   	push   %ebx
  801257:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  80125a:	68 81 10 80 00       	push   $0x801081
  80125f:	e8 76 0e 00 00       	call   8020da <set_pgfault_handler>
  801264:	b8 07 00 00 00       	mov    $0x7,%eax
  801269:	cd 30                	int    $0x30
  80126b:	89 c6                	mov    %eax,%esi

	envid_t envid;
	uint32_t va;
	envid = sys_exofork();
	if (envid < 0){
  80126d:	83 c4 10             	add    $0x10,%esp
  801270:	85 c0                	test   %eax,%eax
  801272:	79 15                	jns    801289 <fork+0x38>
		panic("sys_exofork: %e", envid);
  801274:	50                   	push   %eax
  801275:	68 c9 2a 80 00       	push   $0x802ac9
  80127a:	68 b1 00 00 00       	push   $0xb1
  80127f:	68 00 2a 80 00       	push   $0x802a00
  801284:	e8 8d f0 ff ff       	call   800316 <_panic>
  801289:	89 c7                	mov    %eax,%edi
  80128b:	bb 00 00 00 00       	mov    $0x0,%ebx
	}
	if (envid == 0) {		
  801290:	85 c0                	test   %eax,%eax
  801292:	75 21                	jne    8012b5 <fork+0x64>
		thisenv = &envs[ENVX(sys_getenvid())];
  801294:	e8 c6 fa ff ff       	call   800d5f <sys_getenvid>
  801299:	25 ff 03 00 00       	and    $0x3ff,%eax
  80129e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012a1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012a6:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8012ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b0:	e9 a7 00 00 00       	jmp    80135c <fork+0x10b>
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  8012b5:	89 d8                	mov    %ebx,%eax
  8012b7:	c1 e8 16             	shr    $0x16,%eax
  8012ba:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012c1:	a8 01                	test   $0x1,%al
  8012c3:	74 22                	je     8012e7 <fork+0x96>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  8012c5:	89 da                	mov    %ebx,%edx
  8012c7:	c1 ea 0c             	shr    $0xc,%edx
  8012ca:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8012d1:	a8 01                	test   $0x1,%al
  8012d3:	74 12                	je     8012e7 <fork+0x96>
  8012d5:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8012dc:	a8 04                	test   $0x4,%al
  8012de:	74 07                	je     8012e7 <fork+0x96>
				duppage(envid, PGNUM(va));			
  8012e0:	89 f8                	mov    %edi,%eax
  8012e2:	e8 e0 fb ff ff       	call   800ec7 <duppage>
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
  8012e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012ed:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8012f3:	75 c0                	jne    8012b5 <fork+0x64>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
				duppage(envid, PGNUM(va));			
			}
		}
	}
	if (sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P) < 0){
  8012f5:	83 ec 04             	sub    $0x4,%esp
  8012f8:	6a 07                	push   $0x7
  8012fa:	68 00 f0 bf ee       	push   $0xeebff000
  8012ff:	56                   	push   %esi
  801300:	e8 a5 fa ff ff       	call   800daa <sys_page_alloc>
  801305:	83 c4 10             	add    $0x10,%esp
  801308:	85 c0                	test   %eax,%eax
  80130a:	79 17                	jns    801323 <fork+0xd2>
		panic("Se escribio en la pagina de excepciones");
  80130c:	83 ec 04             	sub    $0x4,%esp
  80130f:	68 08 2b 80 00       	push   $0x802b08
  801314:	68 c0 00 00 00       	push   $0xc0
  801319:	68 00 2a 80 00       	push   $0x802a00
  80131e:	e8 f3 ef ff ff       	call   800316 <_panic>
	}	
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801323:	83 ec 08             	sub    $0x8,%esp
  801326:	68 49 21 80 00       	push   $0x802149
  80132b:	56                   	push   %esi
  80132c:	e8 2c fb ff ff       	call   800e5d <sys_env_set_pgfault_upcall>

	if (sys_env_set_status(envid, ENV_RUNNABLE) < 0)
  801331:	83 c4 08             	add    $0x8,%esp
  801334:	6a 02                	push   $0x2
  801336:	56                   	push   %esi
  801337:	e8 db fa ff ff       	call   800e17 <sys_env_set_status>
  80133c:	83 c4 10             	add    $0x10,%esp
  80133f:	85 c0                	test   %eax,%eax
  801341:	79 17                	jns    80135a <fork+0x109>
		panic("Status incorrecto de enviroment");
  801343:	83 ec 04             	sub    $0x4,%esp
  801346:	68 30 2b 80 00       	push   $0x802b30
  80134b:	68 c5 00 00 00       	push   $0xc5
  801350:	68 00 2a 80 00       	push   $0x802a00
  801355:	e8 bc ef ff ff       	call   800316 <_panic>

	return envid;
  80135a:	89 f0                	mov    %esi,%eax
	
}
  80135c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80135f:	5b                   	pop    %ebx
  801360:	5e                   	pop    %esi
  801361:	5f                   	pop    %edi
  801362:	5d                   	pop    %ebp
  801363:	c3                   	ret    

00801364 <sfork>:


// Challenge!
int
sfork(void)
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
  801367:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80136a:	68 f0 2a 80 00       	push   $0x802af0
  80136f:	68 d1 00 00 00       	push   $0xd1
  801374:	68 00 2a 80 00       	push   $0x802a00
  801379:	e8 98 ef ff ff       	call   800316 <_panic>

0080137e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	05 00 00 00 30       	add    $0x30000000,%eax
  801389:	c1 e8 0c             	shr    $0xc,%eax
}
  80138c:	5d                   	pop    %ebp
  80138d:	c3                   	ret    

0080138e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  801391:	ff 75 08             	pushl  0x8(%ebp)
  801394:	e8 e5 ff ff ff       	call   80137e <fd2num>
  801399:	83 c4 04             	add    $0x4,%esp
  80139c:	c1 e0 0c             	shl    $0xc,%eax
  80139f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013a4:	c9                   	leave  
  8013a5:	c3                   	ret    

008013a6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
  8013a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013ac:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013b1:	89 c2                	mov    %eax,%edx
  8013b3:	c1 ea 16             	shr    $0x16,%edx
  8013b6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013bd:	f6 c2 01             	test   $0x1,%dl
  8013c0:	74 11                	je     8013d3 <fd_alloc+0x2d>
  8013c2:	89 c2                	mov    %eax,%edx
  8013c4:	c1 ea 0c             	shr    $0xc,%edx
  8013c7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013ce:	f6 c2 01             	test   $0x1,%dl
  8013d1:	75 09                	jne    8013dc <fd_alloc+0x36>
			*fd_store = fd;
  8013d3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013da:	eb 17                	jmp    8013f3 <fd_alloc+0x4d>
  8013dc:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8013e1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013e6:	75 c9                	jne    8013b1 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013e8:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8013ee:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8013f3:	5d                   	pop    %ebp
  8013f4:	c3                   	ret    

008013f5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013fb:	83 f8 1f             	cmp    $0x1f,%eax
  8013fe:	77 36                	ja     801436 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801400:	c1 e0 0c             	shl    $0xc,%eax
  801403:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801408:	89 c2                	mov    %eax,%edx
  80140a:	c1 ea 16             	shr    $0x16,%edx
  80140d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801414:	f6 c2 01             	test   $0x1,%dl
  801417:	74 24                	je     80143d <fd_lookup+0x48>
  801419:	89 c2                	mov    %eax,%edx
  80141b:	c1 ea 0c             	shr    $0xc,%edx
  80141e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801425:	f6 c2 01             	test   $0x1,%dl
  801428:	74 1a                	je     801444 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80142a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80142d:	89 02                	mov    %eax,(%edx)
	return 0;
  80142f:	b8 00 00 00 00       	mov    $0x0,%eax
  801434:	eb 13                	jmp    801449 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801436:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80143b:	eb 0c                	jmp    801449 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80143d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801442:	eb 05                	jmp    801449 <fd_lookup+0x54>
  801444:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  801449:	5d                   	pop    %ebp
  80144a:	c3                   	ret    

0080144b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
  80144e:	83 ec 08             	sub    $0x8,%esp
  801451:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801454:	ba cc 2b 80 00       	mov    $0x802bcc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801459:	eb 13                	jmp    80146e <dev_lookup+0x23>
  80145b:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  80145e:	39 08                	cmp    %ecx,(%eax)
  801460:	75 0c                	jne    80146e <dev_lookup+0x23>
			*dev = devtab[i];
  801462:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801465:	89 01                	mov    %eax,(%ecx)
			return 0;
  801467:	b8 00 00 00 00       	mov    $0x0,%eax
  80146c:	eb 2e                	jmp    80149c <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80146e:	8b 02                	mov    (%edx),%eax
  801470:	85 c0                	test   %eax,%eax
  801472:	75 e7                	jne    80145b <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801474:	a1 04 40 80 00       	mov    0x804004,%eax
  801479:	8b 40 48             	mov    0x48(%eax),%eax
  80147c:	83 ec 04             	sub    $0x4,%esp
  80147f:	51                   	push   %ecx
  801480:	50                   	push   %eax
  801481:	68 50 2b 80 00       	push   $0x802b50
  801486:	e8 64 ef ff ff       	call   8003ef <cprintf>
	*dev = 0;
  80148b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801494:	83 c4 10             	add    $0x10,%esp
  801497:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    

0080149e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
  8014a1:	56                   	push   %esi
  8014a2:	53                   	push   %ebx
  8014a3:	83 ec 10             	sub    $0x10,%esp
  8014a6:	8b 75 08             	mov    0x8(%ebp),%esi
  8014a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014ac:	56                   	push   %esi
  8014ad:	e8 cc fe ff ff       	call   80137e <fd2num>
  8014b2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8014b5:	89 14 24             	mov    %edx,(%esp)
  8014b8:	50                   	push   %eax
  8014b9:	e8 37 ff ff ff       	call   8013f5 <fd_lookup>
  8014be:	83 c4 08             	add    $0x8,%esp
  8014c1:	85 c0                	test   %eax,%eax
  8014c3:	78 05                	js     8014ca <fd_close+0x2c>
	    || fd != fd2)
  8014c5:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8014c8:	74 0c                	je     8014d6 <fd_close+0x38>
		return (must_exist ? r : 0);
  8014ca:	84 db                	test   %bl,%bl
  8014cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d1:	0f 44 c2             	cmove  %edx,%eax
  8014d4:	eb 41                	jmp    801517 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014d6:	83 ec 08             	sub    $0x8,%esp
  8014d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014dc:	50                   	push   %eax
  8014dd:	ff 36                	pushl  (%esi)
  8014df:	e8 67 ff ff ff       	call   80144b <dev_lookup>
  8014e4:	89 c3                	mov    %eax,%ebx
  8014e6:	83 c4 10             	add    $0x10,%esp
  8014e9:	85 c0                	test   %eax,%eax
  8014eb:	78 1a                	js     801507 <fd_close+0x69>
		if (dev->dev_close)
  8014ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f0:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8014f3:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8014f8:	85 c0                	test   %eax,%eax
  8014fa:	74 0b                	je     801507 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  8014fc:	83 ec 0c             	sub    $0xc,%esp
  8014ff:	56                   	push   %esi
  801500:	ff d0                	call   *%eax
  801502:	89 c3                	mov    %eax,%ebx
  801504:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801507:	83 ec 08             	sub    $0x8,%esp
  80150a:	56                   	push   %esi
  80150b:	6a 00                	push   $0x0
  80150d:	e8 e2 f8 ff ff       	call   800df4 <sys_page_unmap>
	return r;
  801512:	83 c4 10             	add    $0x10,%esp
  801515:	89 d8                	mov    %ebx,%eax
}
  801517:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80151a:	5b                   	pop    %ebx
  80151b:	5e                   	pop    %esi
  80151c:	5d                   	pop    %ebp
  80151d:	c3                   	ret    

0080151e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
  801521:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801524:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801527:	50                   	push   %eax
  801528:	ff 75 08             	pushl  0x8(%ebp)
  80152b:	e8 c5 fe ff ff       	call   8013f5 <fd_lookup>
  801530:	83 c4 08             	add    $0x8,%esp
  801533:	85 c0                	test   %eax,%eax
  801535:	78 10                	js     801547 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801537:	83 ec 08             	sub    $0x8,%esp
  80153a:	6a 01                	push   $0x1
  80153c:	ff 75 f4             	pushl  -0xc(%ebp)
  80153f:	e8 5a ff ff ff       	call   80149e <fd_close>
  801544:	83 c4 10             	add    $0x10,%esp
}
  801547:	c9                   	leave  
  801548:	c3                   	ret    

00801549 <close_all>:

void
close_all(void)
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
  80154c:	53                   	push   %ebx
  80154d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801550:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801555:	83 ec 0c             	sub    $0xc,%esp
  801558:	53                   	push   %ebx
  801559:	e8 c0 ff ff ff       	call   80151e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80155e:	83 c3 01             	add    $0x1,%ebx
  801561:	83 c4 10             	add    $0x10,%esp
  801564:	83 fb 20             	cmp    $0x20,%ebx
  801567:	75 ec                	jne    801555 <close_all+0xc>
		close(i);
}
  801569:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

0080156e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	57                   	push   %edi
  801572:	56                   	push   %esi
  801573:	53                   	push   %ebx
  801574:	83 ec 2c             	sub    $0x2c,%esp
  801577:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80157a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80157d:	50                   	push   %eax
  80157e:	ff 75 08             	pushl  0x8(%ebp)
  801581:	e8 6f fe ff ff       	call   8013f5 <fd_lookup>
  801586:	83 c4 08             	add    $0x8,%esp
  801589:	85 c0                	test   %eax,%eax
  80158b:	0f 88 c1 00 00 00    	js     801652 <dup+0xe4>
		return r;
	close(newfdnum);
  801591:	83 ec 0c             	sub    $0xc,%esp
  801594:	56                   	push   %esi
  801595:	e8 84 ff ff ff       	call   80151e <close>

	newfd = INDEX2FD(newfdnum);
  80159a:	89 f3                	mov    %esi,%ebx
  80159c:	c1 e3 0c             	shl    $0xc,%ebx
  80159f:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8015a5:	83 c4 04             	add    $0x4,%esp
  8015a8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015ab:	e8 de fd ff ff       	call   80138e <fd2data>
  8015b0:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  8015b2:	89 1c 24             	mov    %ebx,(%esp)
  8015b5:	e8 d4 fd ff ff       	call   80138e <fd2data>
  8015ba:	83 c4 10             	add    $0x10,%esp
  8015bd:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015c0:	89 f8                	mov    %edi,%eax
  8015c2:	c1 e8 16             	shr    $0x16,%eax
  8015c5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015cc:	a8 01                	test   $0x1,%al
  8015ce:	74 37                	je     801607 <dup+0x99>
  8015d0:	89 f8                	mov    %edi,%eax
  8015d2:	c1 e8 0c             	shr    $0xc,%eax
  8015d5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015dc:	f6 c2 01             	test   $0x1,%dl
  8015df:	74 26                	je     801607 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015e1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015e8:	83 ec 0c             	sub    $0xc,%esp
  8015eb:	25 07 0e 00 00       	and    $0xe07,%eax
  8015f0:	50                   	push   %eax
  8015f1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8015f4:	6a 00                	push   $0x0
  8015f6:	57                   	push   %edi
  8015f7:	6a 00                	push   $0x0
  8015f9:	e8 d0 f7 ff ff       	call   800dce <sys_page_map>
  8015fe:	89 c7                	mov    %eax,%edi
  801600:	83 c4 20             	add    $0x20,%esp
  801603:	85 c0                	test   %eax,%eax
  801605:	78 2e                	js     801635 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801607:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80160a:	89 d0                	mov    %edx,%eax
  80160c:	c1 e8 0c             	shr    $0xc,%eax
  80160f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801616:	83 ec 0c             	sub    $0xc,%esp
  801619:	25 07 0e 00 00       	and    $0xe07,%eax
  80161e:	50                   	push   %eax
  80161f:	53                   	push   %ebx
  801620:	6a 00                	push   $0x0
  801622:	52                   	push   %edx
  801623:	6a 00                	push   $0x0
  801625:	e8 a4 f7 ff ff       	call   800dce <sys_page_map>
  80162a:	89 c7                	mov    %eax,%edi
  80162c:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  80162f:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801631:	85 ff                	test   %edi,%edi
  801633:	79 1d                	jns    801652 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801635:	83 ec 08             	sub    $0x8,%esp
  801638:	53                   	push   %ebx
  801639:	6a 00                	push   $0x0
  80163b:	e8 b4 f7 ff ff       	call   800df4 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801640:	83 c4 08             	add    $0x8,%esp
  801643:	ff 75 d4             	pushl  -0x2c(%ebp)
  801646:	6a 00                	push   $0x0
  801648:	e8 a7 f7 ff ff       	call   800df4 <sys_page_unmap>
	return r;
  80164d:	83 c4 10             	add    $0x10,%esp
  801650:	89 f8                	mov    %edi,%eax
}
  801652:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801655:	5b                   	pop    %ebx
  801656:	5e                   	pop    %esi
  801657:	5f                   	pop    %edi
  801658:	5d                   	pop    %ebp
  801659:	c3                   	ret    

0080165a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	53                   	push   %ebx
  80165e:	83 ec 14             	sub    $0x14,%esp
  801661:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801664:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801667:	50                   	push   %eax
  801668:	53                   	push   %ebx
  801669:	e8 87 fd ff ff       	call   8013f5 <fd_lookup>
  80166e:	83 c4 08             	add    $0x8,%esp
  801671:	89 c2                	mov    %eax,%edx
  801673:	85 c0                	test   %eax,%eax
  801675:	78 6d                	js     8016e4 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801677:	83 ec 08             	sub    $0x8,%esp
  80167a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167d:	50                   	push   %eax
  80167e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801681:	ff 30                	pushl  (%eax)
  801683:	e8 c3 fd ff ff       	call   80144b <dev_lookup>
  801688:	83 c4 10             	add    $0x10,%esp
  80168b:	85 c0                	test   %eax,%eax
  80168d:	78 4c                	js     8016db <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80168f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801692:	8b 42 08             	mov    0x8(%edx),%eax
  801695:	83 e0 03             	and    $0x3,%eax
  801698:	83 f8 01             	cmp    $0x1,%eax
  80169b:	75 21                	jne    8016be <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80169d:	a1 04 40 80 00       	mov    0x804004,%eax
  8016a2:	8b 40 48             	mov    0x48(%eax),%eax
  8016a5:	83 ec 04             	sub    $0x4,%esp
  8016a8:	53                   	push   %ebx
  8016a9:	50                   	push   %eax
  8016aa:	68 91 2b 80 00       	push   $0x802b91
  8016af:	e8 3b ed ff ff       	call   8003ef <cprintf>
		return -E_INVAL;
  8016b4:	83 c4 10             	add    $0x10,%esp
  8016b7:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8016bc:	eb 26                	jmp    8016e4 <read+0x8a>
	}
	if (!dev->dev_read)
  8016be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c1:	8b 40 08             	mov    0x8(%eax),%eax
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	74 17                	je     8016df <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016c8:	83 ec 04             	sub    $0x4,%esp
  8016cb:	ff 75 10             	pushl  0x10(%ebp)
  8016ce:	ff 75 0c             	pushl  0xc(%ebp)
  8016d1:	52                   	push   %edx
  8016d2:	ff d0                	call   *%eax
  8016d4:	89 c2                	mov    %eax,%edx
  8016d6:	83 c4 10             	add    $0x10,%esp
  8016d9:	eb 09                	jmp    8016e4 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016db:	89 c2                	mov    %eax,%edx
  8016dd:	eb 05                	jmp    8016e4 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8016df:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  8016e4:	89 d0                	mov    %edx,%eax
  8016e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    

008016eb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	57                   	push   %edi
  8016ef:	56                   	push   %esi
  8016f0:	53                   	push   %ebx
  8016f1:	83 ec 0c             	sub    $0xc,%esp
  8016f4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016f7:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016ff:	eb 21                	jmp    801722 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801701:	83 ec 04             	sub    $0x4,%esp
  801704:	89 f0                	mov    %esi,%eax
  801706:	29 d8                	sub    %ebx,%eax
  801708:	50                   	push   %eax
  801709:	89 d8                	mov    %ebx,%eax
  80170b:	03 45 0c             	add    0xc(%ebp),%eax
  80170e:	50                   	push   %eax
  80170f:	57                   	push   %edi
  801710:	e8 45 ff ff ff       	call   80165a <read>
		if (m < 0)
  801715:	83 c4 10             	add    $0x10,%esp
  801718:	85 c0                	test   %eax,%eax
  80171a:	78 10                	js     80172c <readn+0x41>
			return m;
		if (m == 0)
  80171c:	85 c0                	test   %eax,%eax
  80171e:	74 0a                	je     80172a <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801720:	01 c3                	add    %eax,%ebx
  801722:	39 f3                	cmp    %esi,%ebx
  801724:	72 db                	jb     801701 <readn+0x16>
  801726:	89 d8                	mov    %ebx,%eax
  801728:	eb 02                	jmp    80172c <readn+0x41>
  80172a:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80172c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80172f:	5b                   	pop    %ebx
  801730:	5e                   	pop    %esi
  801731:	5f                   	pop    %edi
  801732:	5d                   	pop    %ebp
  801733:	c3                   	ret    

00801734 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
  801737:	53                   	push   %ebx
  801738:	83 ec 14             	sub    $0x14,%esp
  80173b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80173e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801741:	50                   	push   %eax
  801742:	53                   	push   %ebx
  801743:	e8 ad fc ff ff       	call   8013f5 <fd_lookup>
  801748:	83 c4 08             	add    $0x8,%esp
  80174b:	89 c2                	mov    %eax,%edx
  80174d:	85 c0                	test   %eax,%eax
  80174f:	78 68                	js     8017b9 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801751:	83 ec 08             	sub    $0x8,%esp
  801754:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801757:	50                   	push   %eax
  801758:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175b:	ff 30                	pushl  (%eax)
  80175d:	e8 e9 fc ff ff       	call   80144b <dev_lookup>
  801762:	83 c4 10             	add    $0x10,%esp
  801765:	85 c0                	test   %eax,%eax
  801767:	78 47                	js     8017b0 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801769:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801770:	75 21                	jne    801793 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801772:	a1 04 40 80 00       	mov    0x804004,%eax
  801777:	8b 40 48             	mov    0x48(%eax),%eax
  80177a:	83 ec 04             	sub    $0x4,%esp
  80177d:	53                   	push   %ebx
  80177e:	50                   	push   %eax
  80177f:	68 ad 2b 80 00       	push   $0x802bad
  801784:	e8 66 ec ff ff       	call   8003ef <cprintf>
		return -E_INVAL;
  801789:	83 c4 10             	add    $0x10,%esp
  80178c:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801791:	eb 26                	jmp    8017b9 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801793:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801796:	8b 52 0c             	mov    0xc(%edx),%edx
  801799:	85 d2                	test   %edx,%edx
  80179b:	74 17                	je     8017b4 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80179d:	83 ec 04             	sub    $0x4,%esp
  8017a0:	ff 75 10             	pushl  0x10(%ebp)
  8017a3:	ff 75 0c             	pushl  0xc(%ebp)
  8017a6:	50                   	push   %eax
  8017a7:	ff d2                	call   *%edx
  8017a9:	89 c2                	mov    %eax,%edx
  8017ab:	83 c4 10             	add    $0x10,%esp
  8017ae:	eb 09                	jmp    8017b9 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017b0:	89 c2                	mov    %eax,%edx
  8017b2:	eb 05                	jmp    8017b9 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8017b4:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  8017b9:	89 d0                	mov    %edx,%eax
  8017bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017c6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8017c9:	50                   	push   %eax
  8017ca:	ff 75 08             	pushl  0x8(%ebp)
  8017cd:	e8 23 fc ff ff       	call   8013f5 <fd_lookup>
  8017d2:	83 c4 08             	add    $0x8,%esp
  8017d5:	85 c0                	test   %eax,%eax
  8017d7:	78 0e                	js     8017e7 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8017d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017df:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	53                   	push   %ebx
  8017ed:	83 ec 14             	sub    $0x14,%esp
  8017f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017f6:	50                   	push   %eax
  8017f7:	53                   	push   %ebx
  8017f8:	e8 f8 fb ff ff       	call   8013f5 <fd_lookup>
  8017fd:	83 c4 08             	add    $0x8,%esp
  801800:	89 c2                	mov    %eax,%edx
  801802:	85 c0                	test   %eax,%eax
  801804:	78 65                	js     80186b <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801806:	83 ec 08             	sub    $0x8,%esp
  801809:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80180c:	50                   	push   %eax
  80180d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801810:	ff 30                	pushl  (%eax)
  801812:	e8 34 fc ff ff       	call   80144b <dev_lookup>
  801817:	83 c4 10             	add    $0x10,%esp
  80181a:	85 c0                	test   %eax,%eax
  80181c:	78 44                	js     801862 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80181e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801821:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801825:	75 21                	jne    801848 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801827:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80182c:	8b 40 48             	mov    0x48(%eax),%eax
  80182f:	83 ec 04             	sub    $0x4,%esp
  801832:	53                   	push   %ebx
  801833:	50                   	push   %eax
  801834:	68 70 2b 80 00       	push   $0x802b70
  801839:	e8 b1 eb ff ff       	call   8003ef <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80183e:	83 c4 10             	add    $0x10,%esp
  801841:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801846:	eb 23                	jmp    80186b <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  801848:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80184b:	8b 52 18             	mov    0x18(%edx),%edx
  80184e:	85 d2                	test   %edx,%edx
  801850:	74 14                	je     801866 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801852:	83 ec 08             	sub    $0x8,%esp
  801855:	ff 75 0c             	pushl  0xc(%ebp)
  801858:	50                   	push   %eax
  801859:	ff d2                	call   *%edx
  80185b:	89 c2                	mov    %eax,%edx
  80185d:	83 c4 10             	add    $0x10,%esp
  801860:	eb 09                	jmp    80186b <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801862:	89 c2                	mov    %eax,%edx
  801864:	eb 05                	jmp    80186b <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801866:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  80186b:	89 d0                	mov    %edx,%eax
  80186d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	53                   	push   %ebx
  801876:	83 ec 14             	sub    $0x14,%esp
  801879:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80187c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80187f:	50                   	push   %eax
  801880:	ff 75 08             	pushl  0x8(%ebp)
  801883:	e8 6d fb ff ff       	call   8013f5 <fd_lookup>
  801888:	83 c4 08             	add    $0x8,%esp
  80188b:	89 c2                	mov    %eax,%edx
  80188d:	85 c0                	test   %eax,%eax
  80188f:	78 58                	js     8018e9 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801891:	83 ec 08             	sub    $0x8,%esp
  801894:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801897:	50                   	push   %eax
  801898:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189b:	ff 30                	pushl  (%eax)
  80189d:	e8 a9 fb ff ff       	call   80144b <dev_lookup>
  8018a2:	83 c4 10             	add    $0x10,%esp
  8018a5:	85 c0                	test   %eax,%eax
  8018a7:	78 37                	js     8018e0 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  8018a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ac:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018b0:	74 32                	je     8018e4 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018b2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018b5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018bc:	00 00 00 
	stat->st_isdir = 0;
  8018bf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018c6:	00 00 00 
	stat->st_dev = dev;
  8018c9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018cf:	83 ec 08             	sub    $0x8,%esp
  8018d2:	53                   	push   %ebx
  8018d3:	ff 75 f0             	pushl  -0x10(%ebp)
  8018d6:	ff 50 14             	call   *0x14(%eax)
  8018d9:	89 c2                	mov    %eax,%edx
  8018db:	83 c4 10             	add    $0x10,%esp
  8018de:	eb 09                	jmp    8018e9 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018e0:	89 c2                	mov    %eax,%edx
  8018e2:	eb 05                	jmp    8018e9 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8018e4:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8018e9:	89 d0                	mov    %edx,%eax
  8018eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	56                   	push   %esi
  8018f4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018f5:	83 ec 08             	sub    $0x8,%esp
  8018f8:	6a 00                	push   $0x0
  8018fa:	ff 75 08             	pushl  0x8(%ebp)
  8018fd:	e8 06 02 00 00       	call   801b08 <open>
  801902:	89 c3                	mov    %eax,%ebx
  801904:	83 c4 10             	add    $0x10,%esp
  801907:	85 c0                	test   %eax,%eax
  801909:	78 1b                	js     801926 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80190b:	83 ec 08             	sub    $0x8,%esp
  80190e:	ff 75 0c             	pushl  0xc(%ebp)
  801911:	50                   	push   %eax
  801912:	e8 5b ff ff ff       	call   801872 <fstat>
  801917:	89 c6                	mov    %eax,%esi
	close(fd);
  801919:	89 1c 24             	mov    %ebx,(%esp)
  80191c:	e8 fd fb ff ff       	call   80151e <close>
	return r;
  801921:	83 c4 10             	add    $0x10,%esp
  801924:	89 f0                	mov    %esi,%eax
}
  801926:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801929:	5b                   	pop    %ebx
  80192a:	5e                   	pop    %esi
  80192b:	5d                   	pop    %ebp
  80192c:	c3                   	ret    

0080192d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
  801930:	56                   	push   %esi
  801931:	53                   	push   %ebx
  801932:	89 c6                	mov    %eax,%esi
  801934:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801936:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80193d:	75 12                	jne    801951 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80193f:	83 ec 0c             	sub    $0xc,%esp
  801942:	6a 01                	push   $0x1
  801944:	e8 e3 08 00 00       	call   80222c <ipc_find_env>
  801949:	a3 00 40 80 00       	mov    %eax,0x804000
  80194e:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801951:	6a 07                	push   $0x7
  801953:	68 00 50 80 00       	push   $0x805000
  801958:	56                   	push   %esi
  801959:	ff 35 00 40 80 00    	pushl  0x804000
  80195f:	e8 74 08 00 00       	call   8021d8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801964:	83 c4 0c             	add    $0xc,%esp
  801967:	6a 00                	push   $0x0
  801969:	53                   	push   %ebx
  80196a:	6a 00                	push   $0x0
  80196c:	e8 fc 07 00 00       	call   80216d <ipc_recv>
}
  801971:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801974:	5b                   	pop    %ebx
  801975:	5e                   	pop    %esi
  801976:	5d                   	pop    %ebp
  801977:	c3                   	ret    

00801978 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	8b 40 0c             	mov    0xc(%eax),%eax
  801984:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801989:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198c:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801991:	ba 00 00 00 00       	mov    $0x0,%edx
  801996:	b8 02 00 00 00       	mov    $0x2,%eax
  80199b:	e8 8d ff ff ff       	call   80192d <fsipc>
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ae:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8019b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b8:	b8 06 00 00 00       	mov    $0x6,%eax
  8019bd:	e8 6b ff ff ff       	call   80192d <fsipc>
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	53                   	push   %ebx
  8019c8:	83 ec 04             	sub    $0x4,%esp
  8019cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d4:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019de:	b8 05 00 00 00       	mov    $0x5,%eax
  8019e3:	e8 45 ff ff ff       	call   80192d <fsipc>
  8019e8:	85 c0                	test   %eax,%eax
  8019ea:	78 2c                	js     801a18 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019ec:	83 ec 08             	sub    $0x8,%esp
  8019ef:	68 00 50 80 00       	push   $0x805000
  8019f4:	53                   	push   %ebx
  8019f5:	e8 67 ef ff ff       	call   800961 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019fa:	a1 80 50 80 00       	mov    0x805080,%eax
  8019ff:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a05:	a1 84 50 80 00       	mov    0x805084,%eax
  801a0a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a10:	83 c4 10             	add    $0x10,%esp
  801a13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	83 ec 08             	sub    $0x8,%esp
  801a23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a26:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a2c:	8b 49 0c             	mov    0xc(%ecx),%ecx
  801a2f:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  801a35:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801a3a:	76 22                	jbe    801a5e <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  801a3c:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  801a43:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  801a46:	83 ec 04             	sub    $0x4,%esp
  801a49:	68 f8 0f 00 00       	push   $0xff8
  801a4e:	52                   	push   %edx
  801a4f:	68 08 50 80 00       	push   $0x805008
  801a54:	e8 9b f0 ff ff       	call   800af4 <memmove>
  801a59:	83 c4 10             	add    $0x10,%esp
  801a5c:	eb 17                	jmp    801a75 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  801a5e:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  801a63:	83 ec 04             	sub    $0x4,%esp
  801a66:	50                   	push   %eax
  801a67:	52                   	push   %edx
  801a68:	68 08 50 80 00       	push   $0x805008
  801a6d:	e8 82 f0 ff ff       	call   800af4 <memmove>
  801a72:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  801a75:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7a:	b8 04 00 00 00       	mov    $0x4,%eax
  801a7f:	e8 a9 fe ff ff       	call   80192d <fsipc>
	if (result < 0)
		return result;

	return result;
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	56                   	push   %esi
  801a8a:	53                   	push   %ebx
  801a8b:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	8b 40 0c             	mov    0xc(%eax),%eax
  801a94:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a99:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a9f:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa4:	b8 03 00 00 00       	mov    $0x3,%eax
  801aa9:	e8 7f fe ff ff       	call   80192d <fsipc>
  801aae:	89 c3                	mov    %eax,%ebx
  801ab0:	85 c0                	test   %eax,%eax
  801ab2:	78 4b                	js     801aff <devfile_read+0x79>
		return r;
	assert(r <= n);
  801ab4:	39 c6                	cmp    %eax,%esi
  801ab6:	73 16                	jae    801ace <devfile_read+0x48>
  801ab8:	68 dc 2b 80 00       	push   $0x802bdc
  801abd:	68 e3 2b 80 00       	push   $0x802be3
  801ac2:	6a 7c                	push   $0x7c
  801ac4:	68 f8 2b 80 00       	push   $0x802bf8
  801ac9:	e8 48 e8 ff ff       	call   800316 <_panic>
	assert(r <= PGSIZE);
  801ace:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ad3:	7e 16                	jle    801aeb <devfile_read+0x65>
  801ad5:	68 03 2c 80 00       	push   $0x802c03
  801ada:	68 e3 2b 80 00       	push   $0x802be3
  801adf:	6a 7d                	push   $0x7d
  801ae1:	68 f8 2b 80 00       	push   $0x802bf8
  801ae6:	e8 2b e8 ff ff       	call   800316 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801aeb:	83 ec 04             	sub    $0x4,%esp
  801aee:	50                   	push   %eax
  801aef:	68 00 50 80 00       	push   $0x805000
  801af4:	ff 75 0c             	pushl  0xc(%ebp)
  801af7:	e8 f8 ef ff ff       	call   800af4 <memmove>
	return r;
  801afc:	83 c4 10             	add    $0x10,%esp
}
  801aff:	89 d8                	mov    %ebx,%eax
  801b01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b04:	5b                   	pop    %ebx
  801b05:	5e                   	pop    %esi
  801b06:	5d                   	pop    %ebp
  801b07:	c3                   	ret    

00801b08 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	53                   	push   %ebx
  801b0c:	83 ec 20             	sub    $0x20,%esp
  801b0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801b12:	53                   	push   %ebx
  801b13:	e8 10 ee ff ff       	call   800928 <strlen>
  801b18:	83 c4 10             	add    $0x10,%esp
  801b1b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b20:	7f 67                	jg     801b89 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801b22:	83 ec 0c             	sub    $0xc,%esp
  801b25:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b28:	50                   	push   %eax
  801b29:	e8 78 f8 ff ff       	call   8013a6 <fd_alloc>
  801b2e:	83 c4 10             	add    $0x10,%esp
		return r;
  801b31:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801b33:	85 c0                	test   %eax,%eax
  801b35:	78 57                	js     801b8e <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801b37:	83 ec 08             	sub    $0x8,%esp
  801b3a:	53                   	push   %ebx
  801b3b:	68 00 50 80 00       	push   $0x805000
  801b40:	e8 1c ee ff ff       	call   800961 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b45:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b48:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b50:	b8 01 00 00 00       	mov    $0x1,%eax
  801b55:	e8 d3 fd ff ff       	call   80192d <fsipc>
  801b5a:	89 c3                	mov    %eax,%ebx
  801b5c:	83 c4 10             	add    $0x10,%esp
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	79 14                	jns    801b77 <open+0x6f>
		fd_close(fd, 0);
  801b63:	83 ec 08             	sub    $0x8,%esp
  801b66:	6a 00                	push   $0x0
  801b68:	ff 75 f4             	pushl  -0xc(%ebp)
  801b6b:	e8 2e f9 ff ff       	call   80149e <fd_close>
		return r;
  801b70:	83 c4 10             	add    $0x10,%esp
  801b73:	89 da                	mov    %ebx,%edx
  801b75:	eb 17                	jmp    801b8e <open+0x86>
	}

	return fd2num(fd);
  801b77:	83 ec 0c             	sub    $0xc,%esp
  801b7a:	ff 75 f4             	pushl  -0xc(%ebp)
  801b7d:	e8 fc f7 ff ff       	call   80137e <fd2num>
  801b82:	89 c2                	mov    %eax,%edx
  801b84:	83 c4 10             	add    $0x10,%esp
  801b87:	eb 05                	jmp    801b8e <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801b89:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801b8e:	89 d0                	mov    %edx,%eax
  801b90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
  801b98:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba0:	b8 08 00 00 00       	mov    $0x8,%eax
  801ba5:	e8 83 fd ff ff       	call   80192d <fsipc>
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	56                   	push   %esi
  801bb0:	53                   	push   %ebx
  801bb1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801bb4:	83 ec 0c             	sub    $0xc,%esp
  801bb7:	ff 75 08             	pushl  0x8(%ebp)
  801bba:	e8 cf f7 ff ff       	call   80138e <fd2data>
  801bbf:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801bc1:	83 c4 08             	add    $0x8,%esp
  801bc4:	68 0f 2c 80 00       	push   $0x802c0f
  801bc9:	53                   	push   %ebx
  801bca:	e8 92 ed ff ff       	call   800961 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801bcf:	8b 46 04             	mov    0x4(%esi),%eax
  801bd2:	2b 06                	sub    (%esi),%eax
  801bd4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801bda:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801be1:	00 00 00 
	stat->st_dev = &devpipe;
  801be4:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801beb:	30 80 00 
	return 0;
}
  801bee:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bf6:	5b                   	pop    %ebx
  801bf7:	5e                   	pop    %esi
  801bf8:	5d                   	pop    %ebp
  801bf9:	c3                   	ret    

00801bfa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
  801bfd:	53                   	push   %ebx
  801bfe:	83 ec 0c             	sub    $0xc,%esp
  801c01:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c04:	53                   	push   %ebx
  801c05:	6a 00                	push   $0x0
  801c07:	e8 e8 f1 ff ff       	call   800df4 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c0c:	89 1c 24             	mov    %ebx,(%esp)
  801c0f:	e8 7a f7 ff ff       	call   80138e <fd2data>
  801c14:	83 c4 08             	add    $0x8,%esp
  801c17:	50                   	push   %eax
  801c18:	6a 00                	push   $0x0
  801c1a:	e8 d5 f1 ff ff       	call   800df4 <sys_page_unmap>
}
  801c1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
  801c27:	57                   	push   %edi
  801c28:	56                   	push   %esi
  801c29:	53                   	push   %ebx
  801c2a:	83 ec 1c             	sub    $0x1c,%esp
  801c2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801c30:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801c32:	a1 04 40 80 00       	mov    0x804004,%eax
  801c37:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801c3a:	83 ec 0c             	sub    $0xc,%esp
  801c3d:	ff 75 e0             	pushl  -0x20(%ebp)
  801c40:	e8 20 06 00 00       	call   802265 <pageref>
  801c45:	89 c3                	mov    %eax,%ebx
  801c47:	89 3c 24             	mov    %edi,(%esp)
  801c4a:	e8 16 06 00 00       	call   802265 <pageref>
  801c4f:	83 c4 10             	add    $0x10,%esp
  801c52:	39 c3                	cmp    %eax,%ebx
  801c54:	0f 94 c1             	sete   %cl
  801c57:	0f b6 c9             	movzbl %cl,%ecx
  801c5a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801c5d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c63:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c66:	39 ce                	cmp    %ecx,%esi
  801c68:	74 1b                	je     801c85 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801c6a:	39 c3                	cmp    %eax,%ebx
  801c6c:	75 c4                	jne    801c32 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c6e:	8b 42 58             	mov    0x58(%edx),%eax
  801c71:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c74:	50                   	push   %eax
  801c75:	56                   	push   %esi
  801c76:	68 16 2c 80 00       	push   $0x802c16
  801c7b:	e8 6f e7 ff ff       	call   8003ef <cprintf>
  801c80:	83 c4 10             	add    $0x10,%esp
  801c83:	eb ad                	jmp    801c32 <_pipeisclosed+0xe>
	}
}
  801c85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c8b:	5b                   	pop    %ebx
  801c8c:	5e                   	pop    %esi
  801c8d:	5f                   	pop    %edi
  801c8e:	5d                   	pop    %ebp
  801c8f:	c3                   	ret    

00801c90 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	57                   	push   %edi
  801c94:	56                   	push   %esi
  801c95:	53                   	push   %ebx
  801c96:	83 ec 28             	sub    $0x28,%esp
  801c99:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801c9c:	56                   	push   %esi
  801c9d:	e8 ec f6 ff ff       	call   80138e <fd2data>
  801ca2:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ca4:	83 c4 10             	add    $0x10,%esp
  801ca7:	bf 00 00 00 00       	mov    $0x0,%edi
  801cac:	eb 4b                	jmp    801cf9 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801cae:	89 da                	mov    %ebx,%edx
  801cb0:	89 f0                	mov    %esi,%eax
  801cb2:	e8 6d ff ff ff       	call   801c24 <_pipeisclosed>
  801cb7:	85 c0                	test   %eax,%eax
  801cb9:	75 48                	jne    801d03 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801cbb:	e8 c3 f0 ff ff       	call   800d83 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801cc0:	8b 43 04             	mov    0x4(%ebx),%eax
  801cc3:	8b 0b                	mov    (%ebx),%ecx
  801cc5:	8d 51 20             	lea    0x20(%ecx),%edx
  801cc8:	39 d0                	cmp    %edx,%eax
  801cca:	73 e2                	jae    801cae <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ccc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ccf:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801cd3:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801cd6:	89 c2                	mov    %eax,%edx
  801cd8:	c1 fa 1f             	sar    $0x1f,%edx
  801cdb:	89 d1                	mov    %edx,%ecx
  801cdd:	c1 e9 1b             	shr    $0x1b,%ecx
  801ce0:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ce3:	83 e2 1f             	and    $0x1f,%edx
  801ce6:	29 ca                	sub    %ecx,%edx
  801ce8:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801cec:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801cf0:	83 c0 01             	add    $0x1,%eax
  801cf3:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801cf6:	83 c7 01             	add    $0x1,%edi
  801cf9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801cfc:	75 c2                	jne    801cc0 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801cfe:	8b 45 10             	mov    0x10(%ebp),%eax
  801d01:	eb 05                	jmp    801d08 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801d03:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801d08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d0b:	5b                   	pop    %ebx
  801d0c:	5e                   	pop    %esi
  801d0d:	5f                   	pop    %edi
  801d0e:	5d                   	pop    %ebp
  801d0f:	c3                   	ret    

00801d10 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	57                   	push   %edi
  801d14:	56                   	push   %esi
  801d15:	53                   	push   %ebx
  801d16:	83 ec 18             	sub    $0x18,%esp
  801d19:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801d1c:	57                   	push   %edi
  801d1d:	e8 6c f6 ff ff       	call   80138e <fd2data>
  801d22:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d24:	83 c4 10             	add    $0x10,%esp
  801d27:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d2c:	eb 3d                	jmp    801d6b <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801d2e:	85 db                	test   %ebx,%ebx
  801d30:	74 04                	je     801d36 <devpipe_read+0x26>
				return i;
  801d32:	89 d8                	mov    %ebx,%eax
  801d34:	eb 44                	jmp    801d7a <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801d36:	89 f2                	mov    %esi,%edx
  801d38:	89 f8                	mov    %edi,%eax
  801d3a:	e8 e5 fe ff ff       	call   801c24 <_pipeisclosed>
  801d3f:	85 c0                	test   %eax,%eax
  801d41:	75 32                	jne    801d75 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801d43:	e8 3b f0 ff ff       	call   800d83 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801d48:	8b 06                	mov    (%esi),%eax
  801d4a:	3b 46 04             	cmp    0x4(%esi),%eax
  801d4d:	74 df                	je     801d2e <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d4f:	99                   	cltd   
  801d50:	c1 ea 1b             	shr    $0x1b,%edx
  801d53:	01 d0                	add    %edx,%eax
  801d55:	83 e0 1f             	and    $0x1f,%eax
  801d58:	29 d0                	sub    %edx,%eax
  801d5a:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801d5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d62:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801d65:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d68:	83 c3 01             	add    $0x1,%ebx
  801d6b:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801d6e:	75 d8                	jne    801d48 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801d70:	8b 45 10             	mov    0x10(%ebp),%eax
  801d73:	eb 05                	jmp    801d7a <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801d75:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801d7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d7d:	5b                   	pop    %ebx
  801d7e:	5e                   	pop    %esi
  801d7f:	5f                   	pop    %edi
  801d80:	5d                   	pop    %ebp
  801d81:	c3                   	ret    

00801d82 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	56                   	push   %esi
  801d86:	53                   	push   %ebx
  801d87:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801d8a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d8d:	50                   	push   %eax
  801d8e:	e8 13 f6 ff ff       	call   8013a6 <fd_alloc>
  801d93:	83 c4 10             	add    $0x10,%esp
  801d96:	89 c2                	mov    %eax,%edx
  801d98:	85 c0                	test   %eax,%eax
  801d9a:	0f 88 2c 01 00 00    	js     801ecc <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801da0:	83 ec 04             	sub    $0x4,%esp
  801da3:	68 07 04 00 00       	push   $0x407
  801da8:	ff 75 f4             	pushl  -0xc(%ebp)
  801dab:	6a 00                	push   $0x0
  801dad:	e8 f8 ef ff ff       	call   800daa <sys_page_alloc>
  801db2:	83 c4 10             	add    $0x10,%esp
  801db5:	89 c2                	mov    %eax,%edx
  801db7:	85 c0                	test   %eax,%eax
  801db9:	0f 88 0d 01 00 00    	js     801ecc <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801dbf:	83 ec 0c             	sub    $0xc,%esp
  801dc2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dc5:	50                   	push   %eax
  801dc6:	e8 db f5 ff ff       	call   8013a6 <fd_alloc>
  801dcb:	89 c3                	mov    %eax,%ebx
  801dcd:	83 c4 10             	add    $0x10,%esp
  801dd0:	85 c0                	test   %eax,%eax
  801dd2:	0f 88 e2 00 00 00    	js     801eba <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dd8:	83 ec 04             	sub    $0x4,%esp
  801ddb:	68 07 04 00 00       	push   $0x407
  801de0:	ff 75 f0             	pushl  -0x10(%ebp)
  801de3:	6a 00                	push   $0x0
  801de5:	e8 c0 ef ff ff       	call   800daa <sys_page_alloc>
  801dea:	89 c3                	mov    %eax,%ebx
  801dec:	83 c4 10             	add    $0x10,%esp
  801def:	85 c0                	test   %eax,%eax
  801df1:	0f 88 c3 00 00 00    	js     801eba <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801df7:	83 ec 0c             	sub    $0xc,%esp
  801dfa:	ff 75 f4             	pushl  -0xc(%ebp)
  801dfd:	e8 8c f5 ff ff       	call   80138e <fd2data>
  801e02:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e04:	83 c4 0c             	add    $0xc,%esp
  801e07:	68 07 04 00 00       	push   $0x407
  801e0c:	50                   	push   %eax
  801e0d:	6a 00                	push   $0x0
  801e0f:	e8 96 ef ff ff       	call   800daa <sys_page_alloc>
  801e14:	89 c3                	mov    %eax,%ebx
  801e16:	83 c4 10             	add    $0x10,%esp
  801e19:	85 c0                	test   %eax,%eax
  801e1b:	0f 88 89 00 00 00    	js     801eaa <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e21:	83 ec 0c             	sub    $0xc,%esp
  801e24:	ff 75 f0             	pushl  -0x10(%ebp)
  801e27:	e8 62 f5 ff ff       	call   80138e <fd2data>
  801e2c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e33:	50                   	push   %eax
  801e34:	6a 00                	push   $0x0
  801e36:	56                   	push   %esi
  801e37:	6a 00                	push   $0x0
  801e39:	e8 90 ef ff ff       	call   800dce <sys_page_map>
  801e3e:	89 c3                	mov    %eax,%ebx
  801e40:	83 c4 20             	add    $0x20,%esp
  801e43:	85 c0                	test   %eax,%eax
  801e45:	78 55                	js     801e9c <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801e47:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e50:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e55:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801e5c:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e65:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801e71:	83 ec 0c             	sub    $0xc,%esp
  801e74:	ff 75 f4             	pushl  -0xc(%ebp)
  801e77:	e8 02 f5 ff ff       	call   80137e <fd2num>
  801e7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e7f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e81:	83 c4 04             	add    $0x4,%esp
  801e84:	ff 75 f0             	pushl  -0x10(%ebp)
  801e87:	e8 f2 f4 ff ff       	call   80137e <fd2num>
  801e8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e8f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e92:	83 c4 10             	add    $0x10,%esp
  801e95:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9a:	eb 30                	jmp    801ecc <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801e9c:	83 ec 08             	sub    $0x8,%esp
  801e9f:	56                   	push   %esi
  801ea0:	6a 00                	push   $0x0
  801ea2:	e8 4d ef ff ff       	call   800df4 <sys_page_unmap>
  801ea7:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801eaa:	83 ec 08             	sub    $0x8,%esp
  801ead:	ff 75 f0             	pushl  -0x10(%ebp)
  801eb0:	6a 00                	push   $0x0
  801eb2:	e8 3d ef ff ff       	call   800df4 <sys_page_unmap>
  801eb7:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801eba:	83 ec 08             	sub    $0x8,%esp
  801ebd:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec0:	6a 00                	push   $0x0
  801ec2:	e8 2d ef ff ff       	call   800df4 <sys_page_unmap>
  801ec7:	83 c4 10             	add    $0x10,%esp
  801eca:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  801ecc:	89 d0                	mov    %edx,%eax
  801ece:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ed1:	5b                   	pop    %ebx
  801ed2:	5e                   	pop    %esi
  801ed3:	5d                   	pop    %ebp
  801ed4:	c3                   	ret    

00801ed5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
  801ed8:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801edb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ede:	50                   	push   %eax
  801edf:	ff 75 08             	pushl  0x8(%ebp)
  801ee2:	e8 0e f5 ff ff       	call   8013f5 <fd_lookup>
  801ee7:	83 c4 10             	add    $0x10,%esp
  801eea:	85 c0                	test   %eax,%eax
  801eec:	78 18                	js     801f06 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801eee:	83 ec 0c             	sub    $0xc,%esp
  801ef1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef4:	e8 95 f4 ff ff       	call   80138e <fd2data>
	return _pipeisclosed(fd, p);
  801ef9:	89 c2                	mov    %eax,%edx
  801efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efe:	e8 21 fd ff ff       	call   801c24 <_pipeisclosed>
  801f03:	83 c4 10             	add    $0x10,%esp
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	56                   	push   %esi
  801f0c:	53                   	push   %ebx
  801f0d:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801f10:	85 f6                	test   %esi,%esi
  801f12:	75 16                	jne    801f2a <wait+0x22>
  801f14:	68 2e 2c 80 00       	push   $0x802c2e
  801f19:	68 e3 2b 80 00       	push   $0x802be3
  801f1e:	6a 09                	push   $0x9
  801f20:	68 39 2c 80 00       	push   $0x802c39
  801f25:	e8 ec e3 ff ff       	call   800316 <_panic>
	e = &envs[ENVX(envid)];
  801f2a:	89 f3                	mov    %esi,%ebx
  801f2c:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801f32:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  801f35:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801f3b:	eb 05                	jmp    801f42 <wait+0x3a>
		sys_yield();
  801f3d:	e8 41 ee ff ff       	call   800d83 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801f42:	8b 43 48             	mov    0x48(%ebx),%eax
  801f45:	39 c6                	cmp    %eax,%esi
  801f47:	75 07                	jne    801f50 <wait+0x48>
  801f49:	8b 43 54             	mov    0x54(%ebx),%eax
  801f4c:	85 c0                	test   %eax,%eax
  801f4e:	75 ed                	jne    801f3d <wait+0x35>
		sys_yield();
}
  801f50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f53:	5b                   	pop    %ebx
  801f54:	5e                   	pop    %esi
  801f55:	5d                   	pop    %ebp
  801f56:	c3                   	ret    

00801f57 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801f5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5f:	5d                   	pop    %ebp
  801f60:	c3                   	ret    

00801f61 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
  801f64:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f67:	68 44 2c 80 00       	push   $0x802c44
  801f6c:	ff 75 0c             	pushl  0xc(%ebp)
  801f6f:	e8 ed e9 ff ff       	call   800961 <strcpy>
	return 0;
}
  801f74:	b8 00 00 00 00       	mov    $0x0,%eax
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	57                   	push   %edi
  801f7f:	56                   	push   %esi
  801f80:	53                   	push   %ebx
  801f81:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801f87:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801f8c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801f92:	eb 2d                	jmp    801fc1 <devcons_write+0x46>
		m = n - tot;
  801f94:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f97:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801f99:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801f9c:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801fa1:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801fa4:	83 ec 04             	sub    $0x4,%esp
  801fa7:	53                   	push   %ebx
  801fa8:	03 45 0c             	add    0xc(%ebp),%eax
  801fab:	50                   	push   %eax
  801fac:	57                   	push   %edi
  801fad:	e8 42 eb ff ff       	call   800af4 <memmove>
		sys_cputs(buf, m);
  801fb2:	83 c4 08             	add    $0x8,%esp
  801fb5:	53                   	push   %ebx
  801fb6:	57                   	push   %edi
  801fb7:	e8 37 ed ff ff       	call   800cf3 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801fbc:	01 de                	add    %ebx,%esi
  801fbe:	83 c4 10             	add    $0x10,%esp
  801fc1:	89 f0                	mov    %esi,%eax
  801fc3:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fc6:	72 cc                	jb     801f94 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801fc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fcb:	5b                   	pop    %ebx
  801fcc:	5e                   	pop    %esi
  801fcd:	5f                   	pop    %edi
  801fce:	5d                   	pop    %ebp
  801fcf:	c3                   	ret    

00801fd0 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	83 ec 08             	sub    $0x8,%esp
  801fd6:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801fdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fdf:	74 2a                	je     80200b <devcons_read+0x3b>
  801fe1:	eb 05                	jmp    801fe8 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801fe3:	e8 9b ed ff ff       	call   800d83 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801fe8:	e8 2c ed ff ff       	call   800d19 <sys_cgetc>
  801fed:	85 c0                	test   %eax,%eax
  801fef:	74 f2                	je     801fe3 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801ff1:	85 c0                	test   %eax,%eax
  801ff3:	78 16                	js     80200b <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801ff5:	83 f8 04             	cmp    $0x4,%eax
  801ff8:	74 0c                	je     802006 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801ffa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffd:	88 02                	mov    %al,(%edx)
	return 1;
  801fff:	b8 01 00 00 00       	mov    $0x1,%eax
  802004:	eb 05                	jmp    80200b <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802006:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  80200b:	c9                   	leave  
  80200c:	c3                   	ret    

0080200d <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
  802010:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802013:	8b 45 08             	mov    0x8(%ebp),%eax
  802016:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802019:	6a 01                	push   $0x1
  80201b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80201e:	50                   	push   %eax
  80201f:	e8 cf ec ff ff       	call   800cf3 <sys_cputs>
}
  802024:	83 c4 10             	add    $0x10,%esp
  802027:	c9                   	leave  
  802028:	c3                   	ret    

00802029 <getchar>:

int
getchar(void)
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
  80202c:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80202f:	6a 01                	push   $0x1
  802031:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802034:	50                   	push   %eax
  802035:	6a 00                	push   $0x0
  802037:	e8 1e f6 ff ff       	call   80165a <read>
	if (r < 0)
  80203c:	83 c4 10             	add    $0x10,%esp
  80203f:	85 c0                	test   %eax,%eax
  802041:	78 0f                	js     802052 <getchar+0x29>
		return r;
	if (r < 1)
  802043:	85 c0                	test   %eax,%eax
  802045:	7e 06                	jle    80204d <getchar+0x24>
		return -E_EOF;
	return c;
  802047:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  80204b:	eb 05                	jmp    802052 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  80204d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802052:	c9                   	leave  
  802053:	c3                   	ret    

00802054 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
  802057:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80205a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80205d:	50                   	push   %eax
  80205e:	ff 75 08             	pushl  0x8(%ebp)
  802061:	e8 8f f3 ff ff       	call   8013f5 <fd_lookup>
  802066:	83 c4 10             	add    $0x10,%esp
  802069:	85 c0                	test   %eax,%eax
  80206b:	78 11                	js     80207e <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  80206d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802070:	8b 15 40 30 80 00    	mov    0x803040,%edx
  802076:	39 10                	cmp    %edx,(%eax)
  802078:	0f 94 c0             	sete   %al
  80207b:	0f b6 c0             	movzbl %al,%eax
}
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <opencons>:

int
opencons(void)
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
  802083:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802086:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802089:	50                   	push   %eax
  80208a:	e8 17 f3 ff ff       	call   8013a6 <fd_alloc>
  80208f:	83 c4 10             	add    $0x10,%esp
		return r;
  802092:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802094:	85 c0                	test   %eax,%eax
  802096:	78 3e                	js     8020d6 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802098:	83 ec 04             	sub    $0x4,%esp
  80209b:	68 07 04 00 00       	push   $0x407
  8020a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8020a3:	6a 00                	push   $0x0
  8020a5:	e8 00 ed ff ff       	call   800daa <sys_page_alloc>
  8020aa:	83 c4 10             	add    $0x10,%esp
		return r;
  8020ad:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	78 23                	js     8020d6 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8020b3:	8b 15 40 30 80 00    	mov    0x803040,%edx
  8020b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020c8:	83 ec 0c             	sub    $0xc,%esp
  8020cb:	50                   	push   %eax
  8020cc:	e8 ad f2 ff ff       	call   80137e <fd2num>
  8020d1:	89 c2                	mov    %eax,%edx
  8020d3:	83 c4 10             	add    $0x10,%esp
}
  8020d6:	89 d0                	mov    %edx,%eax
  8020d8:	c9                   	leave  
  8020d9:	c3                   	ret    

008020da <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
  8020dd:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8020e0:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8020e7:	75 2c                	jne    802115 <set_pgfault_handler+0x3b>
		// First time through!
		// LAB 4: Your code here.
		r = sys_page_alloc(0,(void *)(UXSTACKTOP - PGSIZE),PTE_P | PTE_U | PTE_W);
  8020e9:	83 ec 04             	sub    $0x4,%esp
  8020ec:	6a 07                	push   $0x7
  8020ee:	68 00 f0 bf ee       	push   $0xeebff000
  8020f3:	6a 00                	push   $0x0
  8020f5:	e8 b0 ec ff ff       	call   800daa <sys_page_alloc>
		if(r < 0)
  8020fa:	83 c4 10             	add    $0x10,%esp
  8020fd:	85 c0                	test   %eax,%eax
  8020ff:	79 14                	jns    802115 <set_pgfault_handler+0x3b>
			panic("set_pgfault_handler: error in sys_page_alloc\n");	
  802101:	83 ec 04             	sub    $0x4,%esp
  802104:	68 50 2c 80 00       	push   $0x802c50
  802109:	6a 22                	push   $0x22
  80210b:	68 bc 2c 80 00       	push   $0x802cbc
  802110:	e8 01 e2 ff ff       	call   800316 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802115:	8b 45 08             	mov    0x8(%ebp),%eax
  802118:	a3 00 60 80 00       	mov    %eax,0x806000
	r = sys_env_set_pgfault_upcall(0, _pgfault_upcall); 
  80211d:	83 ec 08             	sub    $0x8,%esp
  802120:	68 49 21 80 00       	push   $0x802149
  802125:	6a 00                	push   $0x0
  802127:	e8 31 ed ff ff       	call   800e5d <sys_env_set_pgfault_upcall>
	if (r < 0)
  80212c:	83 c4 10             	add    $0x10,%esp
  80212f:	85 c0                	test   %eax,%eax
  802131:	79 14                	jns    802147 <set_pgfault_handler+0x6d>
		panic("set_pgfault_handler: error in sys_env_set_pgfault_upcall");
  802133:	83 ec 04             	sub    $0x4,%esp
  802136:	68 80 2c 80 00       	push   $0x802c80
  80213b:	6a 29                	push   $0x29
  80213d:	68 bc 2c 80 00       	push   $0x802cbc
  802142:	e8 cf e1 ff ff       	call   800316 <_panic>
}
  802147:	c9                   	leave  
  802148:	c3                   	ret    

00802149 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802149:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80214a:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  80214f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802151:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	subl $0x4, 0x30(%esp)
  802154:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  802159:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 0x28(%esp), %ebx 	
  80215d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  802161:	89 18                	mov    %ebx,(%eax)
	addl $0x8, %esp
  802163:	83 c4 08             	add    $0x8,%esp


	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  802166:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp 
  802167:	83 c4 04             	add    $0x4,%esp
	popfl
  80216a:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80216b:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80216c:	c3                   	ret    

0080216d <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80216d:	55                   	push   %ebp
  80216e:	89 e5                	mov    %esp,%ebp
  802170:	56                   	push   %esi
  802171:	53                   	push   %ebx
  802172:	8b 75 08             	mov    0x8(%ebp),%esi
  802175:	8b 45 0c             	mov    0xc(%ebp),%eax
  802178:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  80217b:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  80217d:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802182:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  802185:	83 ec 0c             	sub    $0xc,%esp
  802188:	50                   	push   %eax
  802189:	e8 17 ed ff ff       	call   800ea5 <sys_ipc_recv>
	if (from_env_store)
  80218e:	83 c4 10             	add    $0x10,%esp
  802191:	85 f6                	test   %esi,%esi
  802193:	74 0b                	je     8021a0 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  802195:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80219b:	8b 52 74             	mov    0x74(%edx),%edx
  80219e:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8021a0:	85 db                	test   %ebx,%ebx
  8021a2:	74 0b                	je     8021af <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  8021a4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8021aa:	8b 52 78             	mov    0x78(%edx),%edx
  8021ad:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  8021af:	85 c0                	test   %eax,%eax
  8021b1:	79 16                	jns    8021c9 <ipc_recv+0x5c>
		if (from_env_store)
  8021b3:	85 f6                	test   %esi,%esi
  8021b5:	74 06                	je     8021bd <ipc_recv+0x50>
			*from_env_store = 0;
  8021b7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  8021bd:	85 db                	test   %ebx,%ebx
  8021bf:	74 10                	je     8021d1 <ipc_recv+0x64>
			*perm_store = 0;
  8021c1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021c7:	eb 08                	jmp    8021d1 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  8021c9:	a1 04 40 80 00       	mov    0x804004,%eax
  8021ce:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021d4:	5b                   	pop    %ebx
  8021d5:	5e                   	pop    %esi
  8021d6:	5d                   	pop    %ebp
  8021d7:	c3                   	ret    

008021d8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
  8021db:	57                   	push   %edi
  8021dc:	56                   	push   %esi
  8021dd:	53                   	push   %ebx
  8021de:	83 ec 0c             	sub    $0xc,%esp
  8021e1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021e4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  8021ea:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  8021ec:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021f1:	0f 44 d8             	cmove  %eax,%ebx
  8021f4:	eb 1c                	jmp    802212 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  8021f6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8021f9:	74 12                	je     80220d <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  8021fb:	50                   	push   %eax
  8021fc:	68 ca 2c 80 00       	push   $0x802cca
  802201:	6a 42                	push   $0x42
  802203:	68 e0 2c 80 00       	push   $0x802ce0
  802208:	e8 09 e1 ff ff       	call   800316 <_panic>
		sys_yield();
  80220d:	e8 71 eb ff ff       	call   800d83 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  802212:	ff 75 14             	pushl  0x14(%ebp)
  802215:	53                   	push   %ebx
  802216:	56                   	push   %esi
  802217:	57                   	push   %edi
  802218:	e8 63 ec ff ff       	call   800e80 <sys_ipc_try_send>
  80221d:	83 c4 10             	add    $0x10,%esp
  802220:	85 c0                	test   %eax,%eax
  802222:	75 d2                	jne    8021f6 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  802224:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802227:	5b                   	pop    %ebx
  802228:	5e                   	pop    %esi
  802229:	5f                   	pop    %edi
  80222a:	5d                   	pop    %ebp
  80222b:	c3                   	ret    

0080222c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802232:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802237:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80223a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802240:	8b 52 50             	mov    0x50(%edx),%edx
  802243:	39 ca                	cmp    %ecx,%edx
  802245:	75 0d                	jne    802254 <ipc_find_env+0x28>
			return envs[i].env_id;
  802247:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80224a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80224f:	8b 40 48             	mov    0x48(%eax),%eax
  802252:	eb 0f                	jmp    802263 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802254:	83 c0 01             	add    $0x1,%eax
  802257:	3d 00 04 00 00       	cmp    $0x400,%eax
  80225c:	75 d9                	jne    802237 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80225e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802263:	5d                   	pop    %ebp
  802264:	c3                   	ret    

00802265 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
  802268:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80226b:	89 d0                	mov    %edx,%eax
  80226d:	c1 e8 16             	shr    $0x16,%eax
  802270:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802277:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80227c:	f6 c1 01             	test   $0x1,%cl
  80227f:	74 1d                	je     80229e <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802281:	c1 ea 0c             	shr    $0xc,%edx
  802284:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80228b:	f6 c2 01             	test   $0x1,%dl
  80228e:	74 0e                	je     80229e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802290:	c1 ea 0c             	shr    $0xc,%edx
  802293:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80229a:	ef 
  80229b:	0f b7 c0             	movzwl %ax,%eax
}
  80229e:	5d                   	pop    %ebp
  80229f:	c3                   	ret    

008022a0 <__udivdi3>:
  8022a0:	55                   	push   %ebp
  8022a1:	57                   	push   %edi
  8022a2:	56                   	push   %esi
  8022a3:	53                   	push   %ebx
  8022a4:	83 ec 1c             	sub    $0x1c,%esp
  8022a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8022ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8022af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8022b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022b7:	85 f6                	test   %esi,%esi
  8022b9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022bd:	89 ca                	mov    %ecx,%edx
  8022bf:	89 f8                	mov    %edi,%eax
  8022c1:	75 3d                	jne    802300 <__udivdi3+0x60>
  8022c3:	39 cf                	cmp    %ecx,%edi
  8022c5:	0f 87 c5 00 00 00    	ja     802390 <__udivdi3+0xf0>
  8022cb:	85 ff                	test   %edi,%edi
  8022cd:	89 fd                	mov    %edi,%ebp
  8022cf:	75 0b                	jne    8022dc <__udivdi3+0x3c>
  8022d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8022d6:	31 d2                	xor    %edx,%edx
  8022d8:	f7 f7                	div    %edi
  8022da:	89 c5                	mov    %eax,%ebp
  8022dc:	89 c8                	mov    %ecx,%eax
  8022de:	31 d2                	xor    %edx,%edx
  8022e0:	f7 f5                	div    %ebp
  8022e2:	89 c1                	mov    %eax,%ecx
  8022e4:	89 d8                	mov    %ebx,%eax
  8022e6:	89 cf                	mov    %ecx,%edi
  8022e8:	f7 f5                	div    %ebp
  8022ea:	89 c3                	mov    %eax,%ebx
  8022ec:	89 d8                	mov    %ebx,%eax
  8022ee:	89 fa                	mov    %edi,%edx
  8022f0:	83 c4 1c             	add    $0x1c,%esp
  8022f3:	5b                   	pop    %ebx
  8022f4:	5e                   	pop    %esi
  8022f5:	5f                   	pop    %edi
  8022f6:	5d                   	pop    %ebp
  8022f7:	c3                   	ret    
  8022f8:	90                   	nop
  8022f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802300:	39 ce                	cmp    %ecx,%esi
  802302:	77 74                	ja     802378 <__udivdi3+0xd8>
  802304:	0f bd fe             	bsr    %esi,%edi
  802307:	83 f7 1f             	xor    $0x1f,%edi
  80230a:	0f 84 98 00 00 00    	je     8023a8 <__udivdi3+0x108>
  802310:	bb 20 00 00 00       	mov    $0x20,%ebx
  802315:	89 f9                	mov    %edi,%ecx
  802317:	89 c5                	mov    %eax,%ebp
  802319:	29 fb                	sub    %edi,%ebx
  80231b:	d3 e6                	shl    %cl,%esi
  80231d:	89 d9                	mov    %ebx,%ecx
  80231f:	d3 ed                	shr    %cl,%ebp
  802321:	89 f9                	mov    %edi,%ecx
  802323:	d3 e0                	shl    %cl,%eax
  802325:	09 ee                	or     %ebp,%esi
  802327:	89 d9                	mov    %ebx,%ecx
  802329:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80232d:	89 d5                	mov    %edx,%ebp
  80232f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802333:	d3 ed                	shr    %cl,%ebp
  802335:	89 f9                	mov    %edi,%ecx
  802337:	d3 e2                	shl    %cl,%edx
  802339:	89 d9                	mov    %ebx,%ecx
  80233b:	d3 e8                	shr    %cl,%eax
  80233d:	09 c2                	or     %eax,%edx
  80233f:	89 d0                	mov    %edx,%eax
  802341:	89 ea                	mov    %ebp,%edx
  802343:	f7 f6                	div    %esi
  802345:	89 d5                	mov    %edx,%ebp
  802347:	89 c3                	mov    %eax,%ebx
  802349:	f7 64 24 0c          	mull   0xc(%esp)
  80234d:	39 d5                	cmp    %edx,%ebp
  80234f:	72 10                	jb     802361 <__udivdi3+0xc1>
  802351:	8b 74 24 08          	mov    0x8(%esp),%esi
  802355:	89 f9                	mov    %edi,%ecx
  802357:	d3 e6                	shl    %cl,%esi
  802359:	39 c6                	cmp    %eax,%esi
  80235b:	73 07                	jae    802364 <__udivdi3+0xc4>
  80235d:	39 d5                	cmp    %edx,%ebp
  80235f:	75 03                	jne    802364 <__udivdi3+0xc4>
  802361:	83 eb 01             	sub    $0x1,%ebx
  802364:	31 ff                	xor    %edi,%edi
  802366:	89 d8                	mov    %ebx,%eax
  802368:	89 fa                	mov    %edi,%edx
  80236a:	83 c4 1c             	add    $0x1c,%esp
  80236d:	5b                   	pop    %ebx
  80236e:	5e                   	pop    %esi
  80236f:	5f                   	pop    %edi
  802370:	5d                   	pop    %ebp
  802371:	c3                   	ret    
  802372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802378:	31 ff                	xor    %edi,%edi
  80237a:	31 db                	xor    %ebx,%ebx
  80237c:	89 d8                	mov    %ebx,%eax
  80237e:	89 fa                	mov    %edi,%edx
  802380:	83 c4 1c             	add    $0x1c,%esp
  802383:	5b                   	pop    %ebx
  802384:	5e                   	pop    %esi
  802385:	5f                   	pop    %edi
  802386:	5d                   	pop    %ebp
  802387:	c3                   	ret    
  802388:	90                   	nop
  802389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802390:	89 d8                	mov    %ebx,%eax
  802392:	f7 f7                	div    %edi
  802394:	31 ff                	xor    %edi,%edi
  802396:	89 c3                	mov    %eax,%ebx
  802398:	89 d8                	mov    %ebx,%eax
  80239a:	89 fa                	mov    %edi,%edx
  80239c:	83 c4 1c             	add    $0x1c,%esp
  80239f:	5b                   	pop    %ebx
  8023a0:	5e                   	pop    %esi
  8023a1:	5f                   	pop    %edi
  8023a2:	5d                   	pop    %ebp
  8023a3:	c3                   	ret    
  8023a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023a8:	39 ce                	cmp    %ecx,%esi
  8023aa:	72 0c                	jb     8023b8 <__udivdi3+0x118>
  8023ac:	31 db                	xor    %ebx,%ebx
  8023ae:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8023b2:	0f 87 34 ff ff ff    	ja     8022ec <__udivdi3+0x4c>
  8023b8:	bb 01 00 00 00       	mov    $0x1,%ebx
  8023bd:	e9 2a ff ff ff       	jmp    8022ec <__udivdi3+0x4c>
  8023c2:	66 90                	xchg   %ax,%ax
  8023c4:	66 90                	xchg   %ax,%ax
  8023c6:	66 90                	xchg   %ax,%ax
  8023c8:	66 90                	xchg   %ax,%ax
  8023ca:	66 90                	xchg   %ax,%ax
  8023cc:	66 90                	xchg   %ax,%ax
  8023ce:	66 90                	xchg   %ax,%ax

008023d0 <__umoddi3>:
  8023d0:	55                   	push   %ebp
  8023d1:	57                   	push   %edi
  8023d2:	56                   	push   %esi
  8023d3:	53                   	push   %ebx
  8023d4:	83 ec 1c             	sub    $0x1c,%esp
  8023d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023db:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8023df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023e7:	85 d2                	test   %edx,%edx
  8023e9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8023ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023f1:	89 f3                	mov    %esi,%ebx
  8023f3:	89 3c 24             	mov    %edi,(%esp)
  8023f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023fa:	75 1c                	jne    802418 <__umoddi3+0x48>
  8023fc:	39 f7                	cmp    %esi,%edi
  8023fe:	76 50                	jbe    802450 <__umoddi3+0x80>
  802400:	89 c8                	mov    %ecx,%eax
  802402:	89 f2                	mov    %esi,%edx
  802404:	f7 f7                	div    %edi
  802406:	89 d0                	mov    %edx,%eax
  802408:	31 d2                	xor    %edx,%edx
  80240a:	83 c4 1c             	add    $0x1c,%esp
  80240d:	5b                   	pop    %ebx
  80240e:	5e                   	pop    %esi
  80240f:	5f                   	pop    %edi
  802410:	5d                   	pop    %ebp
  802411:	c3                   	ret    
  802412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802418:	39 f2                	cmp    %esi,%edx
  80241a:	89 d0                	mov    %edx,%eax
  80241c:	77 52                	ja     802470 <__umoddi3+0xa0>
  80241e:	0f bd ea             	bsr    %edx,%ebp
  802421:	83 f5 1f             	xor    $0x1f,%ebp
  802424:	75 5a                	jne    802480 <__umoddi3+0xb0>
  802426:	3b 54 24 04          	cmp    0x4(%esp),%edx
  80242a:	0f 82 e0 00 00 00    	jb     802510 <__umoddi3+0x140>
  802430:	39 0c 24             	cmp    %ecx,(%esp)
  802433:	0f 86 d7 00 00 00    	jbe    802510 <__umoddi3+0x140>
  802439:	8b 44 24 08          	mov    0x8(%esp),%eax
  80243d:	8b 54 24 04          	mov    0x4(%esp),%edx
  802441:	83 c4 1c             	add    $0x1c,%esp
  802444:	5b                   	pop    %ebx
  802445:	5e                   	pop    %esi
  802446:	5f                   	pop    %edi
  802447:	5d                   	pop    %ebp
  802448:	c3                   	ret    
  802449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802450:	85 ff                	test   %edi,%edi
  802452:	89 fd                	mov    %edi,%ebp
  802454:	75 0b                	jne    802461 <__umoddi3+0x91>
  802456:	b8 01 00 00 00       	mov    $0x1,%eax
  80245b:	31 d2                	xor    %edx,%edx
  80245d:	f7 f7                	div    %edi
  80245f:	89 c5                	mov    %eax,%ebp
  802461:	89 f0                	mov    %esi,%eax
  802463:	31 d2                	xor    %edx,%edx
  802465:	f7 f5                	div    %ebp
  802467:	89 c8                	mov    %ecx,%eax
  802469:	f7 f5                	div    %ebp
  80246b:	89 d0                	mov    %edx,%eax
  80246d:	eb 99                	jmp    802408 <__umoddi3+0x38>
  80246f:	90                   	nop
  802470:	89 c8                	mov    %ecx,%eax
  802472:	89 f2                	mov    %esi,%edx
  802474:	83 c4 1c             	add    $0x1c,%esp
  802477:	5b                   	pop    %ebx
  802478:	5e                   	pop    %esi
  802479:	5f                   	pop    %edi
  80247a:	5d                   	pop    %ebp
  80247b:	c3                   	ret    
  80247c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802480:	8b 34 24             	mov    (%esp),%esi
  802483:	bf 20 00 00 00       	mov    $0x20,%edi
  802488:	89 e9                	mov    %ebp,%ecx
  80248a:	29 ef                	sub    %ebp,%edi
  80248c:	d3 e0                	shl    %cl,%eax
  80248e:	89 f9                	mov    %edi,%ecx
  802490:	89 f2                	mov    %esi,%edx
  802492:	d3 ea                	shr    %cl,%edx
  802494:	89 e9                	mov    %ebp,%ecx
  802496:	09 c2                	or     %eax,%edx
  802498:	89 d8                	mov    %ebx,%eax
  80249a:	89 14 24             	mov    %edx,(%esp)
  80249d:	89 f2                	mov    %esi,%edx
  80249f:	d3 e2                	shl    %cl,%edx
  8024a1:	89 f9                	mov    %edi,%ecx
  8024a3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024a7:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8024ab:	d3 e8                	shr    %cl,%eax
  8024ad:	89 e9                	mov    %ebp,%ecx
  8024af:	89 c6                	mov    %eax,%esi
  8024b1:	d3 e3                	shl    %cl,%ebx
  8024b3:	89 f9                	mov    %edi,%ecx
  8024b5:	89 d0                	mov    %edx,%eax
  8024b7:	d3 e8                	shr    %cl,%eax
  8024b9:	89 e9                	mov    %ebp,%ecx
  8024bb:	09 d8                	or     %ebx,%eax
  8024bd:	89 d3                	mov    %edx,%ebx
  8024bf:	89 f2                	mov    %esi,%edx
  8024c1:	f7 34 24             	divl   (%esp)
  8024c4:	89 d6                	mov    %edx,%esi
  8024c6:	d3 e3                	shl    %cl,%ebx
  8024c8:	f7 64 24 04          	mull   0x4(%esp)
  8024cc:	39 d6                	cmp    %edx,%esi
  8024ce:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024d2:	89 d1                	mov    %edx,%ecx
  8024d4:	89 c3                	mov    %eax,%ebx
  8024d6:	72 08                	jb     8024e0 <__umoddi3+0x110>
  8024d8:	75 11                	jne    8024eb <__umoddi3+0x11b>
  8024da:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8024de:	73 0b                	jae    8024eb <__umoddi3+0x11b>
  8024e0:	2b 44 24 04          	sub    0x4(%esp),%eax
  8024e4:	1b 14 24             	sbb    (%esp),%edx
  8024e7:	89 d1                	mov    %edx,%ecx
  8024e9:	89 c3                	mov    %eax,%ebx
  8024eb:	8b 54 24 08          	mov    0x8(%esp),%edx
  8024ef:	29 da                	sub    %ebx,%edx
  8024f1:	19 ce                	sbb    %ecx,%esi
  8024f3:	89 f9                	mov    %edi,%ecx
  8024f5:	89 f0                	mov    %esi,%eax
  8024f7:	d3 e0                	shl    %cl,%eax
  8024f9:	89 e9                	mov    %ebp,%ecx
  8024fb:	d3 ea                	shr    %cl,%edx
  8024fd:	89 e9                	mov    %ebp,%ecx
  8024ff:	d3 ee                	shr    %cl,%esi
  802501:	09 d0                	or     %edx,%eax
  802503:	89 f2                	mov    %esi,%edx
  802505:	83 c4 1c             	add    $0x1c,%esp
  802508:	5b                   	pop    %ebx
  802509:	5e                   	pop    %esi
  80250a:	5f                   	pop    %edi
  80250b:	5d                   	pop    %ebp
  80250c:	c3                   	ret    
  80250d:	8d 76 00             	lea    0x0(%esi),%esi
  802510:	29 f9                	sub    %edi,%ecx
  802512:	19 d6                	sbb    %edx,%esi
  802514:	89 74 24 04          	mov    %esi,0x4(%esp)
  802518:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80251c:	e9 18 ff ff ff       	jmp    802439 <__umoddi3+0x69>
