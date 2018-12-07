
obj/user/testshell.debug:     formato del fichero elf32-i386


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
  80002c:	e8 5d 04 00 00       	call   80048e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <breakpoint>:

#include <inc/types.h>

static inline void
breakpoint(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	asm volatile("int3");
  800036:	cc                   	int3   
}
  800037:	5d                   	pop    %ebp
  800038:	c3                   	ret    

00800039 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800039:	55                   	push   %ebp
  80003a:	89 e5                	mov    %esp,%ebp
  80003c:	57                   	push   %edi
  80003d:	56                   	push   %esi
  80003e:	53                   	push   %ebx
  80003f:	81 ec 84 00 00 00    	sub    $0x84,%esp
  800045:	8b 75 08             	mov    0x8(%ebp),%esi
  800048:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80004b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  80004e:	53                   	push   %ebx
  80004f:	56                   	push   %esi
  800050:	e8 47 19 00 00       	call   80199c <seek>
	seek(kfd, off);
  800055:	83 c4 08             	add    $0x8,%esp
  800058:	53                   	push   %ebx
  800059:	57                   	push   %edi
  80005a:	e8 3d 19 00 00       	call   80199c <seek>

	cprintf("shell produced incorrect output.\n");
  80005f:	c7 04 24 80 2b 80 00 	movl   $0x802b80,(%esp)
  800066:	e8 60 05 00 00       	call   8005cb <cprintf>
	cprintf("expected:\n===\n");
  80006b:	c7 04 24 eb 2b 80 00 	movl   $0x802beb,(%esp)
  800072:	e8 54 05 00 00       	call   8005cb <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800077:	83 c4 10             	add    $0x10,%esp
  80007a:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  80007d:	eb 0d                	jmp    80008c <wrong+0x53>
		sys_cputs(buf, n);
  80007f:	83 ec 08             	sub    $0x8,%esp
  800082:	50                   	push   %eax
  800083:	53                   	push   %ebx
  800084:	e8 46 0e 00 00       	call   800ecf <sys_cputs>
  800089:	83 c4 10             	add    $0x10,%esp
	seek(rfd, off);
	seek(kfd, off);

	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  80008c:	83 ec 04             	sub    $0x4,%esp
  80008f:	6a 63                	push   $0x63
  800091:	53                   	push   %ebx
  800092:	57                   	push   %edi
  800093:	e8 9e 17 00 00       	call   801836 <read>
  800098:	83 c4 10             	add    $0x10,%esp
  80009b:	85 c0                	test   %eax,%eax
  80009d:	7f e0                	jg     80007f <wrong+0x46>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  80009f:	83 ec 0c             	sub    $0xc,%esp
  8000a2:	68 fa 2b 80 00       	push   $0x802bfa
  8000a7:	e8 1f 05 00 00       	call   8005cb <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000b2:	eb 0d                	jmp    8000c1 <wrong+0x88>
		sys_cputs(buf, n);
  8000b4:	83 ec 08             	sub    $0x8,%esp
  8000b7:	50                   	push   %eax
  8000b8:	53                   	push   %ebx
  8000b9:	e8 11 0e 00 00       	call   800ecf <sys_cputs>
  8000be:	83 c4 10             	add    $0x10,%esp
	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 63                	push   $0x63
  8000c6:	53                   	push   %ebx
  8000c7:	56                   	push   %esi
  8000c8:	e8 69 17 00 00       	call   801836 <read>
  8000cd:	83 c4 10             	add    $0x10,%esp
  8000d0:	85 c0                	test   %eax,%eax
  8000d2:	7f e0                	jg     8000b4 <wrong+0x7b>
		sys_cputs(buf, n);
	cprintf("===\n");
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	68 f5 2b 80 00       	push   $0x802bf5
  8000dc:	e8 ea 04 00 00       	call   8005cb <cprintf>
	exit();
  8000e1:	e8 f2 03 00 00       	call   8004d8 <exit>
}
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000ec:	5b                   	pop    %ebx
  8000ed:	5e                   	pop    %esi
  8000ee:	5f                   	pop    %edi
  8000ef:	5d                   	pop    %ebp
  8000f0:	c3                   	ret    

008000f1 <umain>:

void wrong(int, int, int);

void
umain(int argc, char **argv)
{
  8000f1:	55                   	push   %ebp
  8000f2:	89 e5                	mov    %esp,%ebp
  8000f4:	57                   	push   %edi
  8000f5:	56                   	push   %esi
  8000f6:	53                   	push   %ebx
  8000f7:	83 ec 38             	sub    $0x38,%esp
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;
	int pfds[2];

	close(0);
  8000fa:	6a 00                	push   $0x0
  8000fc:	e8 f9 15 00 00       	call   8016fa <close>
	close(1);
  800101:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800108:	e8 ed 15 00 00       	call   8016fa <close>
	opencons();
  80010d:	e8 22 03 00 00       	call   800434 <opencons>
	opencons();
  800112:	e8 1d 03 00 00       	call   800434 <opencons>

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  800117:	83 c4 08             	add    $0x8,%esp
  80011a:	6a 00                	push   $0x0
  80011c:	68 08 2c 80 00       	push   $0x802c08
  800121:	e8 be 1b 00 00       	call   801ce4 <open>
  800126:	89 c3                	mov    %eax,%ebx
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	85 c0                	test   %eax,%eax
  80012d:	79 12                	jns    800141 <umain+0x50>
		panic("open testshell.sh: %e", rfd);
  80012f:	50                   	push   %eax
  800130:	68 15 2c 80 00       	push   $0x802c15
  800135:	6a 13                	push   $0x13
  800137:	68 2b 2c 80 00       	push   $0x802c2b
  80013c:	e8 b1 03 00 00       	call   8004f2 <_panic>
	if ((wfd = pipe(pfds)) < 0)
  800141:	83 ec 0c             	sub    $0xc,%esp
  800144:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800147:	50                   	push   %eax
  800148:	e8 f7 23 00 00       	call   802544 <pipe>
  80014d:	83 c4 10             	add    $0x10,%esp
  800150:	85 c0                	test   %eax,%eax
  800152:	79 12                	jns    800166 <umain+0x75>
		panic("pipe: %e", wfd);
  800154:	50                   	push   %eax
  800155:	68 3c 2c 80 00       	push   $0x802c3c
  80015a:	6a 15                	push   $0x15
  80015c:	68 2b 2c 80 00       	push   $0x802c2b
  800161:	e8 8c 03 00 00       	call   8004f2 <_panic>
	wfd = pfds[1];
  800166:	8b 75 e0             	mov    -0x20(%ebp),%esi

	cprintf("running sh -x < testshell.sh | cat\n");
  800169:	83 ec 0c             	sub    $0xc,%esp
  80016c:	68 a4 2b 80 00       	push   $0x802ba4
  800171:	e8 55 04 00 00       	call   8005cb <cprintf>
	if ((r = fork()) < 0)
  800176:	e8 b2 12 00 00       	call   80142d <fork>
  80017b:	83 c4 10             	add    $0x10,%esp
  80017e:	85 c0                	test   %eax,%eax
  800180:	79 12                	jns    800194 <umain+0xa3>
		panic("fork: %e", r);
  800182:	50                   	push   %eax
  800183:	68 f0 30 80 00       	push   $0x8030f0
  800188:	6a 1a                	push   $0x1a
  80018a:	68 2b 2c 80 00       	push   $0x802c2b
  80018f:	e8 5e 03 00 00       	call   8004f2 <_panic>
	if (r == 0) {
  800194:	85 c0                	test   %eax,%eax
  800196:	75 7d                	jne    800215 <umain+0x124>
		dup(rfd, 0);
  800198:	83 ec 08             	sub    $0x8,%esp
  80019b:	6a 00                	push   $0x0
  80019d:	53                   	push   %ebx
  80019e:	e8 a7 15 00 00       	call   80174a <dup>
		dup(wfd, 1);
  8001a3:	83 c4 08             	add    $0x8,%esp
  8001a6:	6a 01                	push   $0x1
  8001a8:	56                   	push   %esi
  8001a9:	e8 9c 15 00 00       	call   80174a <dup>
		close(rfd);
  8001ae:	89 1c 24             	mov    %ebx,(%esp)
  8001b1:	e8 44 15 00 00       	call   8016fa <close>
		close(wfd);
  8001b6:	89 34 24             	mov    %esi,(%esp)
  8001b9:	e8 3c 15 00 00       	call   8016fa <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  8001be:	6a 00                	push   $0x0
  8001c0:	68 45 2c 80 00       	push   $0x802c45
  8001c5:	68 12 2c 80 00       	push   $0x802c12
  8001ca:	68 48 2c 80 00       	push   $0x802c48
  8001cf:	e8 27 21 00 00       	call   8022fb <spawnl>
  8001d4:	89 c7                	mov    %eax,%edi
  8001d6:	83 c4 20             	add    $0x20,%esp
  8001d9:	85 c0                	test   %eax,%eax
  8001db:	79 12                	jns    8001ef <umain+0xfe>
			panic("spawn: %e", r);
  8001dd:	50                   	push   %eax
  8001de:	68 4c 2c 80 00       	push   $0x802c4c
  8001e3:	6a 21                	push   $0x21
  8001e5:	68 2b 2c 80 00       	push   $0x802c2b
  8001ea:	e8 03 03 00 00       	call   8004f2 <_panic>
		close(0);
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	6a 00                	push   $0x0
  8001f4:	e8 01 15 00 00       	call   8016fa <close>
		close(1);
  8001f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800200:	e8 f5 14 00 00       	call   8016fa <close>
		wait(r);
  800205:	89 3c 24             	mov    %edi,(%esp)
  800208:	e8 bd 24 00 00       	call   8026ca <wait>
		exit();
  80020d:	e8 c6 02 00 00       	call   8004d8 <exit>
  800212:	83 c4 10             	add    $0x10,%esp
	}
	close(rfd);
  800215:	83 ec 0c             	sub    $0xc,%esp
  800218:	53                   	push   %ebx
  800219:	e8 dc 14 00 00       	call   8016fa <close>
	close(wfd);
  80021e:	89 34 24             	mov    %esi,(%esp)
  800221:	e8 d4 14 00 00       	call   8016fa <close>

	rfd = pfds[0];
  800226:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800229:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  80022c:	83 c4 08             	add    $0x8,%esp
  80022f:	6a 00                	push   $0x0
  800231:	68 56 2c 80 00       	push   $0x802c56
  800236:	e8 a9 1a 00 00       	call   801ce4 <open>
  80023b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80023e:	83 c4 10             	add    $0x10,%esp
  800241:	85 c0                	test   %eax,%eax
  800243:	79 12                	jns    800257 <umain+0x166>
		panic("open testshell.key for reading: %e", kfd);
  800245:	50                   	push   %eax
  800246:	68 c8 2b 80 00       	push   $0x802bc8
  80024b:	6a 2c                	push   $0x2c
  80024d:	68 2b 2c 80 00       	push   $0x802c2b
  800252:	e8 9b 02 00 00       	call   8004f2 <_panic>
  800257:	be 01 00 00 00       	mov    $0x1,%esi
  80025c:	bf 00 00 00 00       	mov    $0x0,%edi

	nloff = 0;
	for (off=0;; off++) {
		n1 = read(rfd, &c1, 1);
  800261:	83 ec 04             	sub    $0x4,%esp
  800264:	6a 01                	push   $0x1
  800266:	8d 45 e7             	lea    -0x19(%ebp),%eax
  800269:	50                   	push   %eax
  80026a:	ff 75 d0             	pushl  -0x30(%ebp)
  80026d:	e8 c4 15 00 00       	call   801836 <read>
  800272:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  800274:	83 c4 0c             	add    $0xc,%esp
  800277:	6a 01                	push   $0x1
  800279:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  80027c:	50                   	push   %eax
  80027d:	ff 75 d4             	pushl  -0x2c(%ebp)
  800280:	e8 b1 15 00 00       	call   801836 <read>
		if (n1 < 0)
  800285:	83 c4 10             	add    $0x10,%esp
  800288:	85 db                	test   %ebx,%ebx
  80028a:	79 12                	jns    80029e <umain+0x1ad>
			panic("reading testshell.out: %e", n1);
  80028c:	53                   	push   %ebx
  80028d:	68 64 2c 80 00       	push   $0x802c64
  800292:	6a 33                	push   $0x33
  800294:	68 2b 2c 80 00       	push   $0x802c2b
  800299:	e8 54 02 00 00       	call   8004f2 <_panic>
		if (n2 < 0)
  80029e:	85 c0                	test   %eax,%eax
  8002a0:	79 12                	jns    8002b4 <umain+0x1c3>
			panic("reading testshell.key: %e", n2);
  8002a2:	50                   	push   %eax
  8002a3:	68 7e 2c 80 00       	push   $0x802c7e
  8002a8:	6a 35                	push   $0x35
  8002aa:	68 2b 2c 80 00       	push   $0x802c2b
  8002af:	e8 3e 02 00 00       	call   8004f2 <_panic>
		if (n1 == 0 && n2 == 0)
  8002b4:	89 da                	mov    %ebx,%edx
  8002b6:	09 c2                	or     %eax,%edx
  8002b8:	74 34                	je     8002ee <umain+0x1fd>
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8002ba:	83 fb 01             	cmp    $0x1,%ebx
  8002bd:	75 0e                	jne    8002cd <umain+0x1dc>
  8002bf:	83 f8 01             	cmp    $0x1,%eax
  8002c2:	75 09                	jne    8002cd <umain+0x1dc>
  8002c4:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  8002c8:	38 45 e7             	cmp    %al,-0x19(%ebp)
  8002cb:	74 12                	je     8002df <umain+0x1ee>
			wrong(rfd, kfd, nloff);
  8002cd:	83 ec 04             	sub    $0x4,%esp
  8002d0:	57                   	push   %edi
  8002d1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002d4:	ff 75 d0             	pushl  -0x30(%ebp)
  8002d7:	e8 5d fd ff ff       	call   800039 <wrong>
  8002dc:	83 c4 10             	add    $0x10,%esp
		if (c1 == '\n')
			nloff = off+1;
  8002df:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8002e3:	0f 44 fe             	cmove  %esi,%edi
  8002e6:	83 c6 01             	add    $0x1,%esi
	}
  8002e9:	e9 73 ff ff ff       	jmp    800261 <umain+0x170>
	cprintf("shell ran correctly\n");
  8002ee:	83 ec 0c             	sub    $0xc,%esp
  8002f1:	68 98 2c 80 00       	push   $0x802c98
  8002f6:	e8 d0 02 00 00       	call   8005cb <cprintf>

	breakpoint();
  8002fb:	e8 33 fd ff ff       	call   800033 <breakpoint>
}
  800300:	83 c4 10             	add    $0x10,%esp
  800303:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800306:	5b                   	pop    %ebx
  800307:	5e                   	pop    %esi
  800308:	5f                   	pop    %edi
  800309:	5d                   	pop    %ebp
  80030a:	c3                   	ret    

0080030b <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80030e:	b8 00 00 00 00       	mov    $0x0,%eax
  800313:	5d                   	pop    %ebp
  800314:	c3                   	ret    

00800315 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80031b:	68 ad 2c 80 00       	push   $0x802cad
  800320:	ff 75 0c             	pushl  0xc(%ebp)
  800323:	e8 15 08 00 00       	call   800b3d <strcpy>
	return 0;
}
  800328:	b8 00 00 00 00       	mov    $0x0,%eax
  80032d:	c9                   	leave  
  80032e:	c3                   	ret    

0080032f <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	57                   	push   %edi
  800333:	56                   	push   %esi
  800334:	53                   	push   %ebx
  800335:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80033b:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800340:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800346:	eb 2d                	jmp    800375 <devcons_write+0x46>
		m = n - tot;
  800348:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80034b:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  80034d:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  800350:	ba 7f 00 00 00       	mov    $0x7f,%edx
  800355:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	53                   	push   %ebx
  80035c:	03 45 0c             	add    0xc(%ebp),%eax
  80035f:	50                   	push   %eax
  800360:	57                   	push   %edi
  800361:	e8 6a 09 00 00       	call   800cd0 <memmove>
		sys_cputs(buf, m);
  800366:	83 c4 08             	add    $0x8,%esp
  800369:	53                   	push   %ebx
  80036a:	57                   	push   %edi
  80036b:	e8 5f 0b 00 00       	call   800ecf <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800370:	01 de                	add    %ebx,%esi
  800372:	83 c4 10             	add    $0x10,%esp
  800375:	89 f0                	mov    %esi,%eax
  800377:	3b 75 10             	cmp    0x10(%ebp),%esi
  80037a:	72 cc                	jb     800348 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80037c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80037f:	5b                   	pop    %ebx
  800380:	5e                   	pop    %esi
  800381:	5f                   	pop    %edi
  800382:	5d                   	pop    %ebp
  800383:	c3                   	ret    

00800384 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	83 ec 08             	sub    $0x8,%esp
  80038a:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  80038f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800393:	74 2a                	je     8003bf <devcons_read+0x3b>
  800395:	eb 05                	jmp    80039c <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800397:	e8 c3 0b 00 00       	call   800f5f <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80039c:	e8 54 0b 00 00       	call   800ef5 <sys_cgetc>
  8003a1:	85 c0                	test   %eax,%eax
  8003a3:	74 f2                	je     800397 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8003a5:	85 c0                	test   %eax,%eax
  8003a7:	78 16                	js     8003bf <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8003a9:	83 f8 04             	cmp    $0x4,%eax
  8003ac:	74 0c                	je     8003ba <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8003ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b1:	88 02                	mov    %al,(%edx)
	return 1;
  8003b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8003b8:	eb 05                	jmp    8003bf <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8003ba:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8003bf:	c9                   	leave  
  8003c0:	c3                   	ret    

008003c1 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8003c1:	55                   	push   %ebp
  8003c2:	89 e5                	mov    %esp,%ebp
  8003c4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8003c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ca:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8003cd:	6a 01                	push   $0x1
  8003cf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003d2:	50                   	push   %eax
  8003d3:	e8 f7 0a 00 00       	call   800ecf <sys_cputs>
}
  8003d8:	83 c4 10             	add    $0x10,%esp
  8003db:	c9                   	leave  
  8003dc:	c3                   	ret    

008003dd <getchar>:

int
getchar(void)
{
  8003dd:	55                   	push   %ebp
  8003de:	89 e5                	mov    %esp,%ebp
  8003e0:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8003e3:	6a 01                	push   $0x1
  8003e5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003e8:	50                   	push   %eax
  8003e9:	6a 00                	push   $0x0
  8003eb:	e8 46 14 00 00       	call   801836 <read>
	if (r < 0)
  8003f0:	83 c4 10             	add    $0x10,%esp
  8003f3:	85 c0                	test   %eax,%eax
  8003f5:	78 0f                	js     800406 <getchar+0x29>
		return r;
	if (r < 1)
  8003f7:	85 c0                	test   %eax,%eax
  8003f9:	7e 06                	jle    800401 <getchar+0x24>
		return -E_EOF;
	return c;
  8003fb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8003ff:	eb 05                	jmp    800406 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800401:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  800406:	c9                   	leave  
  800407:	c3                   	ret    

00800408 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80040e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800411:	50                   	push   %eax
  800412:	ff 75 08             	pushl  0x8(%ebp)
  800415:	e8 b7 11 00 00       	call   8015d1 <fd_lookup>
  80041a:	83 c4 10             	add    $0x10,%esp
  80041d:	85 c0                	test   %eax,%eax
  80041f:	78 11                	js     800432 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800424:	8b 15 00 40 80 00    	mov    0x804000,%edx
  80042a:	39 10                	cmp    %edx,(%eax)
  80042c:	0f 94 c0             	sete   %al
  80042f:	0f b6 c0             	movzbl %al,%eax
}
  800432:	c9                   	leave  
  800433:	c3                   	ret    

00800434 <opencons>:

int
opencons(void)
{
  800434:	55                   	push   %ebp
  800435:	89 e5                	mov    %esp,%ebp
  800437:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80043a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80043d:	50                   	push   %eax
  80043e:	e8 3f 11 00 00       	call   801582 <fd_alloc>
  800443:	83 c4 10             	add    $0x10,%esp
		return r;
  800446:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800448:	85 c0                	test   %eax,%eax
  80044a:	78 3e                	js     80048a <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80044c:	83 ec 04             	sub    $0x4,%esp
  80044f:	68 07 04 00 00       	push   $0x407
  800454:	ff 75 f4             	pushl  -0xc(%ebp)
  800457:	6a 00                	push   $0x0
  800459:	e8 28 0b 00 00       	call   800f86 <sys_page_alloc>
  80045e:	83 c4 10             	add    $0x10,%esp
		return r;
  800461:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800463:	85 c0                	test   %eax,%eax
  800465:	78 23                	js     80048a <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800467:	8b 15 00 40 80 00    	mov    0x804000,%edx
  80046d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800470:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800475:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80047c:	83 ec 0c             	sub    $0xc,%esp
  80047f:	50                   	push   %eax
  800480:	e8 d5 10 00 00       	call   80155a <fd2num>
  800485:	89 c2                	mov    %eax,%edx
  800487:	83 c4 10             	add    $0x10,%esp
}
  80048a:	89 d0                	mov    %edx,%eax
  80048c:	c9                   	leave  
  80048d:	c3                   	ret    

0080048e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80048e:	55                   	push   %ebp
  80048f:	89 e5                	mov    %esp,%ebp
  800491:	56                   	push   %esi
  800492:	53                   	push   %ebx
  800493:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800496:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800499:	e8 9d 0a 00 00       	call   800f3b <sys_getenvid>
	if (id >= 0)
  80049e:	85 c0                	test   %eax,%eax
  8004a0:	78 12                	js     8004b4 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  8004a2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004a7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8004aa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004af:	a3 04 50 80 00       	mov    %eax,0x805004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004b4:	85 db                	test   %ebx,%ebx
  8004b6:	7e 07                	jle    8004bf <libmain+0x31>
		binaryname = argv[0];
  8004b8:	8b 06                	mov    (%esi),%eax
  8004ba:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  8004bf:	83 ec 08             	sub    $0x8,%esp
  8004c2:	56                   	push   %esi
  8004c3:	53                   	push   %ebx
  8004c4:	e8 28 fc ff ff       	call   8000f1 <umain>

	// exit gracefully
	exit();
  8004c9:	e8 0a 00 00 00       	call   8004d8 <exit>
}
  8004ce:	83 c4 10             	add    $0x10,%esp
  8004d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8004d4:	5b                   	pop    %ebx
  8004d5:	5e                   	pop    %esi
  8004d6:	5d                   	pop    %ebp
  8004d7:	c3                   	ret    

008004d8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004d8:	55                   	push   %ebp
  8004d9:	89 e5                	mov    %esp,%ebp
  8004db:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8004de:	e8 42 12 00 00       	call   801725 <close_all>
	sys_env_destroy(0);
  8004e3:	83 ec 0c             	sub    $0xc,%esp
  8004e6:	6a 00                	push   $0x0
  8004e8:	e8 2c 0a 00 00       	call   800f19 <sys_env_destroy>
}
  8004ed:	83 c4 10             	add    $0x10,%esp
  8004f0:	c9                   	leave  
  8004f1:	c3                   	ret    

008004f2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004f2:	55                   	push   %ebp
  8004f3:	89 e5                	mov    %esp,%ebp
  8004f5:	56                   	push   %esi
  8004f6:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8004f7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004fa:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  800500:	e8 36 0a 00 00       	call   800f3b <sys_getenvid>
  800505:	83 ec 0c             	sub    $0xc,%esp
  800508:	ff 75 0c             	pushl  0xc(%ebp)
  80050b:	ff 75 08             	pushl  0x8(%ebp)
  80050e:	56                   	push   %esi
  80050f:	50                   	push   %eax
  800510:	68 c4 2c 80 00       	push   $0x802cc4
  800515:	e8 b1 00 00 00       	call   8005cb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80051a:	83 c4 18             	add    $0x18,%esp
  80051d:	53                   	push   %ebx
  80051e:	ff 75 10             	pushl  0x10(%ebp)
  800521:	e8 54 00 00 00       	call   80057a <vcprintf>
	cprintf("\n");
  800526:	c7 04 24 f8 2b 80 00 	movl   $0x802bf8,(%esp)
  80052d:	e8 99 00 00 00       	call   8005cb <cprintf>
  800532:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800535:	cc                   	int3   
  800536:	eb fd                	jmp    800535 <_panic+0x43>

00800538 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800538:	55                   	push   %ebp
  800539:	89 e5                	mov    %esp,%ebp
  80053b:	53                   	push   %ebx
  80053c:	83 ec 04             	sub    $0x4,%esp
  80053f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800542:	8b 13                	mov    (%ebx),%edx
  800544:	8d 42 01             	lea    0x1(%edx),%eax
  800547:	89 03                	mov    %eax,(%ebx)
  800549:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80054c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800550:	3d ff 00 00 00       	cmp    $0xff,%eax
  800555:	75 1a                	jne    800571 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  800557:	83 ec 08             	sub    $0x8,%esp
  80055a:	68 ff 00 00 00       	push   $0xff
  80055f:	8d 43 08             	lea    0x8(%ebx),%eax
  800562:	50                   	push   %eax
  800563:	e8 67 09 00 00       	call   800ecf <sys_cputs>
		b->idx = 0;
  800568:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80056e:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  800571:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800575:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800578:	c9                   	leave  
  800579:	c3                   	ret    

0080057a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80057a:	55                   	push   %ebp
  80057b:	89 e5                	mov    %esp,%ebp
  80057d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800583:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80058a:	00 00 00 
	b.cnt = 0;
  80058d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800594:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800597:	ff 75 0c             	pushl  0xc(%ebp)
  80059a:	ff 75 08             	pushl  0x8(%ebp)
  80059d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a3:	50                   	push   %eax
  8005a4:	68 38 05 80 00       	push   $0x800538
  8005a9:	e8 86 01 00 00       	call   800734 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005ae:	83 c4 08             	add    $0x8,%esp
  8005b1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005b7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005bd:	50                   	push   %eax
  8005be:	e8 0c 09 00 00       	call   800ecf <sys_cputs>

	return b.cnt;
}
  8005c3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005c9:	c9                   	leave  
  8005ca:	c3                   	ret    

008005cb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005cb:	55                   	push   %ebp
  8005cc:	89 e5                	mov    %esp,%ebp
  8005ce:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005d1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005d4:	50                   	push   %eax
  8005d5:	ff 75 08             	pushl  0x8(%ebp)
  8005d8:	e8 9d ff ff ff       	call   80057a <vcprintf>
	va_end(ap);

	return cnt;
}
  8005dd:	c9                   	leave  
  8005de:	c3                   	ret    

008005df <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	57                   	push   %edi
  8005e3:	56                   	push   %esi
  8005e4:	53                   	push   %ebx
  8005e5:	83 ec 1c             	sub    $0x1c,%esp
  8005e8:	89 c7                	mov    %eax,%edi
  8005ea:	89 d6                	mov    %edx,%esi
  8005ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800600:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800603:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800606:	39 d3                	cmp    %edx,%ebx
  800608:	72 05                	jb     80060f <printnum+0x30>
  80060a:	39 45 10             	cmp    %eax,0x10(%ebp)
  80060d:	77 45                	ja     800654 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80060f:	83 ec 0c             	sub    $0xc,%esp
  800612:	ff 75 18             	pushl  0x18(%ebp)
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80061b:	53                   	push   %ebx
  80061c:	ff 75 10             	pushl  0x10(%ebp)
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	ff 75 e4             	pushl  -0x1c(%ebp)
  800625:	ff 75 e0             	pushl  -0x20(%ebp)
  800628:	ff 75 dc             	pushl  -0x24(%ebp)
  80062b:	ff 75 d8             	pushl  -0x28(%ebp)
  80062e:	e8 ad 22 00 00       	call   8028e0 <__udivdi3>
  800633:	83 c4 18             	add    $0x18,%esp
  800636:	52                   	push   %edx
  800637:	50                   	push   %eax
  800638:	89 f2                	mov    %esi,%edx
  80063a:	89 f8                	mov    %edi,%eax
  80063c:	e8 9e ff ff ff       	call   8005df <printnum>
  800641:	83 c4 20             	add    $0x20,%esp
  800644:	eb 18                	jmp    80065e <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	56                   	push   %esi
  80064a:	ff 75 18             	pushl  0x18(%ebp)
  80064d:	ff d7                	call   *%edi
  80064f:	83 c4 10             	add    $0x10,%esp
  800652:	eb 03                	jmp    800657 <printnum+0x78>
  800654:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800657:	83 eb 01             	sub    $0x1,%ebx
  80065a:	85 db                	test   %ebx,%ebx
  80065c:	7f e8                	jg     800646 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80065e:	83 ec 08             	sub    $0x8,%esp
  800661:	56                   	push   %esi
  800662:	83 ec 04             	sub    $0x4,%esp
  800665:	ff 75 e4             	pushl  -0x1c(%ebp)
  800668:	ff 75 e0             	pushl  -0x20(%ebp)
  80066b:	ff 75 dc             	pushl  -0x24(%ebp)
  80066e:	ff 75 d8             	pushl  -0x28(%ebp)
  800671:	e8 9a 23 00 00       	call   802a10 <__umoddi3>
  800676:	83 c4 14             	add    $0x14,%esp
  800679:	0f be 80 e7 2c 80 00 	movsbl 0x802ce7(%eax),%eax
  800680:	50                   	push   %eax
  800681:	ff d7                	call   *%edi
}
  800683:	83 c4 10             	add    $0x10,%esp
  800686:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800689:	5b                   	pop    %ebx
  80068a:	5e                   	pop    %esi
  80068b:	5f                   	pop    %edi
  80068c:	5d                   	pop    %ebp
  80068d:	c3                   	ret    

0080068e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80068e:	55                   	push   %ebp
  80068f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800691:	83 fa 01             	cmp    $0x1,%edx
  800694:	7e 0e                	jle    8006a4 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800696:	8b 10                	mov    (%eax),%edx
  800698:	8d 4a 08             	lea    0x8(%edx),%ecx
  80069b:	89 08                	mov    %ecx,(%eax)
  80069d:	8b 02                	mov    (%edx),%eax
  80069f:	8b 52 04             	mov    0x4(%edx),%edx
  8006a2:	eb 22                	jmp    8006c6 <getuint+0x38>
	else if (lflag)
  8006a4:	85 d2                	test   %edx,%edx
  8006a6:	74 10                	je     8006b8 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8006a8:	8b 10                	mov    (%eax),%edx
  8006aa:	8d 4a 04             	lea    0x4(%edx),%ecx
  8006ad:	89 08                	mov    %ecx,(%eax)
  8006af:	8b 02                	mov    (%edx),%eax
  8006b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b6:	eb 0e                	jmp    8006c6 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8006b8:	8b 10                	mov    (%eax),%edx
  8006ba:	8d 4a 04             	lea    0x4(%edx),%ecx
  8006bd:	89 08                	mov    %ecx,(%eax)
  8006bf:	8b 02                	mov    (%edx),%eax
  8006c1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006c6:	5d                   	pop    %ebp
  8006c7:	c3                   	ret    

008006c8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006c8:	55                   	push   %ebp
  8006c9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006cb:	83 fa 01             	cmp    $0x1,%edx
  8006ce:	7e 0e                	jle    8006de <getint+0x16>
		return va_arg(*ap, long long);
  8006d0:	8b 10                	mov    (%eax),%edx
  8006d2:	8d 4a 08             	lea    0x8(%edx),%ecx
  8006d5:	89 08                	mov    %ecx,(%eax)
  8006d7:	8b 02                	mov    (%edx),%eax
  8006d9:	8b 52 04             	mov    0x4(%edx),%edx
  8006dc:	eb 1a                	jmp    8006f8 <getint+0x30>
	else if (lflag)
  8006de:	85 d2                	test   %edx,%edx
  8006e0:	74 0c                	je     8006ee <getint+0x26>
		return va_arg(*ap, long);
  8006e2:	8b 10                	mov    (%eax),%edx
  8006e4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8006e7:	89 08                	mov    %ecx,(%eax)
  8006e9:	8b 02                	mov    (%edx),%eax
  8006eb:	99                   	cltd   
  8006ec:	eb 0a                	jmp    8006f8 <getint+0x30>
	else
		return va_arg(*ap, int);
  8006ee:	8b 10                	mov    (%eax),%edx
  8006f0:	8d 4a 04             	lea    0x4(%edx),%ecx
  8006f3:	89 08                	mov    %ecx,(%eax)
  8006f5:	8b 02                	mov    (%edx),%eax
  8006f7:	99                   	cltd   
}
  8006f8:	5d                   	pop    %ebp
  8006f9:	c3                   	ret    

008006fa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006fa:	55                   	push   %ebp
  8006fb:	89 e5                	mov    %esp,%ebp
  8006fd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800700:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800704:	8b 10                	mov    (%eax),%edx
  800706:	3b 50 04             	cmp    0x4(%eax),%edx
  800709:	73 0a                	jae    800715 <sprintputch+0x1b>
		*b->buf++ = ch;
  80070b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80070e:	89 08                	mov    %ecx,(%eax)
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	88 02                	mov    %al,(%edx)
}
  800715:	5d                   	pop    %ebp
  800716:	c3                   	ret    

00800717 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800717:	55                   	push   %ebp
  800718:	89 e5                	mov    %esp,%ebp
  80071a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  80071d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800720:	50                   	push   %eax
  800721:	ff 75 10             	pushl  0x10(%ebp)
  800724:	ff 75 0c             	pushl  0xc(%ebp)
  800727:	ff 75 08             	pushl  0x8(%ebp)
  80072a:	e8 05 00 00 00       	call   800734 <vprintfmt>
	va_end(ap);
}
  80072f:	83 c4 10             	add    $0x10,%esp
  800732:	c9                   	leave  
  800733:	c3                   	ret    

00800734 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800734:	55                   	push   %ebp
  800735:	89 e5                	mov    %esp,%ebp
  800737:	57                   	push   %edi
  800738:	56                   	push   %esi
  800739:	53                   	push   %ebx
  80073a:	83 ec 2c             	sub    $0x2c,%esp
  80073d:	8b 75 08             	mov    0x8(%ebp),%esi
  800740:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800743:	8b 7d 10             	mov    0x10(%ebp),%edi
  800746:	eb 12                	jmp    80075a <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800748:	85 c0                	test   %eax,%eax
  80074a:	0f 84 44 03 00 00    	je     800a94 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  800750:	83 ec 08             	sub    $0x8,%esp
  800753:	53                   	push   %ebx
  800754:	50                   	push   %eax
  800755:	ff d6                	call   *%esi
  800757:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80075a:	83 c7 01             	add    $0x1,%edi
  80075d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800761:	83 f8 25             	cmp    $0x25,%eax
  800764:	75 e2                	jne    800748 <vprintfmt+0x14>
  800766:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  80076a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800771:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800778:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80077f:	ba 00 00 00 00       	mov    $0x0,%edx
  800784:	eb 07                	jmp    80078d <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800786:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800789:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80078d:	8d 47 01             	lea    0x1(%edi),%eax
  800790:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800793:	0f b6 07             	movzbl (%edi),%eax
  800796:	0f b6 c8             	movzbl %al,%ecx
  800799:	83 e8 23             	sub    $0x23,%eax
  80079c:	3c 55                	cmp    $0x55,%al
  80079e:	0f 87 d5 02 00 00    	ja     800a79 <vprintfmt+0x345>
  8007a4:	0f b6 c0             	movzbl %al,%eax
  8007a7:	ff 24 85 20 2e 80 00 	jmp    *0x802e20(,%eax,4)
  8007ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007b1:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8007b5:	eb d6                	jmp    80078d <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8007ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8007bf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8007c2:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8007c5:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8007c9:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8007cc:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8007cf:	83 fa 09             	cmp    $0x9,%edx
  8007d2:	77 39                	ja     80080d <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007d4:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007d7:	eb e9                	jmp    8007c2 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	8d 48 04             	lea    0x4(%eax),%ecx
  8007df:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8007e2:	8b 00                	mov    (%eax),%eax
  8007e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8007ea:	eb 27                	jmp    800813 <vprintfmt+0xdf>
  8007ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ef:	85 c0                	test   %eax,%eax
  8007f1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007f6:	0f 49 c8             	cmovns %eax,%ecx
  8007f9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8007ff:	eb 8c                	jmp    80078d <vprintfmt+0x59>
  800801:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800804:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80080b:	eb 80                	jmp    80078d <vprintfmt+0x59>
  80080d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800810:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  800813:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800817:	0f 89 70 ff ff ff    	jns    80078d <vprintfmt+0x59>
				width = precision, precision = -1;
  80081d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800820:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800823:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80082a:	e9 5e ff ff ff       	jmp    80078d <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80082f:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800832:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800835:	e9 53 ff ff ff       	jmp    80078d <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80083a:	8b 45 14             	mov    0x14(%ebp),%eax
  80083d:	8d 50 04             	lea    0x4(%eax),%edx
  800840:	89 55 14             	mov    %edx,0x14(%ebp)
  800843:	83 ec 08             	sub    $0x8,%esp
  800846:	53                   	push   %ebx
  800847:	ff 30                	pushl  (%eax)
  800849:	ff d6                	call   *%esi
			break;
  80084b:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80084e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800851:	e9 04 ff ff ff       	jmp    80075a <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800856:	8b 45 14             	mov    0x14(%ebp),%eax
  800859:	8d 50 04             	lea    0x4(%eax),%edx
  80085c:	89 55 14             	mov    %edx,0x14(%ebp)
  80085f:	8b 00                	mov    (%eax),%eax
  800861:	99                   	cltd   
  800862:	31 d0                	xor    %edx,%eax
  800864:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800866:	83 f8 0f             	cmp    $0xf,%eax
  800869:	7f 0b                	jg     800876 <vprintfmt+0x142>
  80086b:	8b 14 85 80 2f 80 00 	mov    0x802f80(,%eax,4),%edx
  800872:	85 d2                	test   %edx,%edx
  800874:	75 18                	jne    80088e <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  800876:	50                   	push   %eax
  800877:	68 ff 2c 80 00       	push   $0x802cff
  80087c:	53                   	push   %ebx
  80087d:	56                   	push   %esi
  80087e:	e8 94 fe ff ff       	call   800717 <printfmt>
  800883:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800886:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800889:	e9 cc fe ff ff       	jmp    80075a <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  80088e:	52                   	push   %edx
  80088f:	68 15 32 80 00       	push   $0x803215
  800894:	53                   	push   %ebx
  800895:	56                   	push   %esi
  800896:	e8 7c fe ff ff       	call   800717 <printfmt>
  80089b:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80089e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8008a1:	e9 b4 fe ff ff       	jmp    80075a <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a9:	8d 50 04             	lea    0x4(%eax),%edx
  8008ac:	89 55 14             	mov    %edx,0x14(%ebp)
  8008af:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8008b1:	85 ff                	test   %edi,%edi
  8008b3:	b8 f8 2c 80 00       	mov    $0x802cf8,%eax
  8008b8:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8008bb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008bf:	0f 8e 94 00 00 00    	jle    800959 <vprintfmt+0x225>
  8008c5:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8008c9:	0f 84 98 00 00 00    	je     800967 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008cf:	83 ec 08             	sub    $0x8,%esp
  8008d2:	ff 75 d0             	pushl  -0x30(%ebp)
  8008d5:	57                   	push   %edi
  8008d6:	e8 41 02 00 00       	call   800b1c <strnlen>
  8008db:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008de:	29 c1                	sub    %eax,%ecx
  8008e0:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8008e3:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8008e6:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8008ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008ed:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8008f0:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f2:	eb 0f                	jmp    800903 <vprintfmt+0x1cf>
					putch(padc, putdat);
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	53                   	push   %ebx
  8008f8:	ff 75 e0             	pushl  -0x20(%ebp)
  8008fb:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008fd:	83 ef 01             	sub    $0x1,%edi
  800900:	83 c4 10             	add    $0x10,%esp
  800903:	85 ff                	test   %edi,%edi
  800905:	7f ed                	jg     8008f4 <vprintfmt+0x1c0>
  800907:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80090a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  80090d:	85 c9                	test   %ecx,%ecx
  80090f:	b8 00 00 00 00       	mov    $0x0,%eax
  800914:	0f 49 c1             	cmovns %ecx,%eax
  800917:	29 c1                	sub    %eax,%ecx
  800919:	89 75 08             	mov    %esi,0x8(%ebp)
  80091c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80091f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800922:	89 cb                	mov    %ecx,%ebx
  800924:	eb 4d                	jmp    800973 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800926:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80092a:	74 1b                	je     800947 <vprintfmt+0x213>
  80092c:	0f be c0             	movsbl %al,%eax
  80092f:	83 e8 20             	sub    $0x20,%eax
  800932:	83 f8 5e             	cmp    $0x5e,%eax
  800935:	76 10                	jbe    800947 <vprintfmt+0x213>
					putch('?', putdat);
  800937:	83 ec 08             	sub    $0x8,%esp
  80093a:	ff 75 0c             	pushl  0xc(%ebp)
  80093d:	6a 3f                	push   $0x3f
  80093f:	ff 55 08             	call   *0x8(%ebp)
  800942:	83 c4 10             	add    $0x10,%esp
  800945:	eb 0d                	jmp    800954 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	52                   	push   %edx
  80094e:	ff 55 08             	call   *0x8(%ebp)
  800951:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800954:	83 eb 01             	sub    $0x1,%ebx
  800957:	eb 1a                	jmp    800973 <vprintfmt+0x23f>
  800959:	89 75 08             	mov    %esi,0x8(%ebp)
  80095c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80095f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800962:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800965:	eb 0c                	jmp    800973 <vprintfmt+0x23f>
  800967:	89 75 08             	mov    %esi,0x8(%ebp)
  80096a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80096d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800970:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800973:	83 c7 01             	add    $0x1,%edi
  800976:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80097a:	0f be d0             	movsbl %al,%edx
  80097d:	85 d2                	test   %edx,%edx
  80097f:	74 23                	je     8009a4 <vprintfmt+0x270>
  800981:	85 f6                	test   %esi,%esi
  800983:	78 a1                	js     800926 <vprintfmt+0x1f2>
  800985:	83 ee 01             	sub    $0x1,%esi
  800988:	79 9c                	jns    800926 <vprintfmt+0x1f2>
  80098a:	89 df                	mov    %ebx,%edi
  80098c:	8b 75 08             	mov    0x8(%ebp),%esi
  80098f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800992:	eb 18                	jmp    8009ac <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800994:	83 ec 08             	sub    $0x8,%esp
  800997:	53                   	push   %ebx
  800998:	6a 20                	push   $0x20
  80099a:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80099c:	83 ef 01             	sub    $0x1,%edi
  80099f:	83 c4 10             	add    $0x10,%esp
  8009a2:	eb 08                	jmp    8009ac <vprintfmt+0x278>
  8009a4:	89 df                	mov    %ebx,%edi
  8009a6:	8b 75 08             	mov    0x8(%ebp),%esi
  8009a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009ac:	85 ff                	test   %edi,%edi
  8009ae:	7f e4                	jg     800994 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8009b3:	e9 a2 fd ff ff       	jmp    80075a <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009b8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bb:	e8 08 fd ff ff       	call   8006c8 <getint>
  8009c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8009c6:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8009cb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009cf:	79 74                	jns    800a45 <vprintfmt+0x311>
				putch('-', putdat);
  8009d1:	83 ec 08             	sub    $0x8,%esp
  8009d4:	53                   	push   %ebx
  8009d5:	6a 2d                	push   $0x2d
  8009d7:	ff d6                	call   *%esi
				num = -(long long) num;
  8009d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8009df:	f7 d8                	neg    %eax
  8009e1:	83 d2 00             	adc    $0x0,%edx
  8009e4:	f7 da                	neg    %edx
  8009e6:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8009e9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8009ee:	eb 55                	jmp    800a45 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f3:	e8 96 fc ff ff       	call   80068e <getuint>
			base = 10;
  8009f8:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8009fd:	eb 46                	jmp    800a45 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8009ff:	8d 45 14             	lea    0x14(%ebp),%eax
  800a02:	e8 87 fc ff ff       	call   80068e <getuint>
			base = 8;
  800a07:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800a0c:	eb 37                	jmp    800a45 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  800a0e:	83 ec 08             	sub    $0x8,%esp
  800a11:	53                   	push   %ebx
  800a12:	6a 30                	push   $0x30
  800a14:	ff d6                	call   *%esi
			putch('x', putdat);
  800a16:	83 c4 08             	add    $0x8,%esp
  800a19:	53                   	push   %ebx
  800a1a:	6a 78                	push   $0x78
  800a1c:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800a1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a21:	8d 50 04             	lea    0x4(%eax),%edx
  800a24:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a27:	8b 00                	mov    (%eax),%eax
  800a29:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800a2e:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800a31:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800a36:	eb 0d                	jmp    800a45 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a38:	8d 45 14             	lea    0x14(%ebp),%eax
  800a3b:	e8 4e fc ff ff       	call   80068e <getuint>
			base = 16;
  800a40:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a45:	83 ec 0c             	sub    $0xc,%esp
  800a48:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800a4c:	57                   	push   %edi
  800a4d:	ff 75 e0             	pushl  -0x20(%ebp)
  800a50:	51                   	push   %ecx
  800a51:	52                   	push   %edx
  800a52:	50                   	push   %eax
  800a53:	89 da                	mov    %ebx,%edx
  800a55:	89 f0                	mov    %esi,%eax
  800a57:	e8 83 fb ff ff       	call   8005df <printnum>
			break;
  800a5c:	83 c4 20             	add    $0x20,%esp
  800a5f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800a62:	e9 f3 fc ff ff       	jmp    80075a <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a67:	83 ec 08             	sub    $0x8,%esp
  800a6a:	53                   	push   %ebx
  800a6b:	51                   	push   %ecx
  800a6c:	ff d6                	call   *%esi
			break;
  800a6e:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a71:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800a74:	e9 e1 fc ff ff       	jmp    80075a <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a79:	83 ec 08             	sub    $0x8,%esp
  800a7c:	53                   	push   %ebx
  800a7d:	6a 25                	push   $0x25
  800a7f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a81:	83 c4 10             	add    $0x10,%esp
  800a84:	eb 03                	jmp    800a89 <vprintfmt+0x355>
  800a86:	83 ef 01             	sub    $0x1,%edi
  800a89:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  800a8d:	75 f7                	jne    800a86 <vprintfmt+0x352>
  800a8f:	e9 c6 fc ff ff       	jmp    80075a <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  800a94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a97:	5b                   	pop    %ebx
  800a98:	5e                   	pop    %esi
  800a99:	5f                   	pop    %edi
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    

00800a9c <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	83 ec 18             	sub    $0x18,%esp
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800aa8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800aab:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800aaf:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800ab2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ab9:	85 c0                	test   %eax,%eax
  800abb:	74 26                	je     800ae3 <vsnprintf+0x47>
  800abd:	85 d2                	test   %edx,%edx
  800abf:	7e 22                	jle    800ae3 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ac1:	ff 75 14             	pushl  0x14(%ebp)
  800ac4:	ff 75 10             	pushl  0x10(%ebp)
  800ac7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aca:	50                   	push   %eax
  800acb:	68 fa 06 80 00       	push   $0x8006fa
  800ad0:	e8 5f fc ff ff       	call   800734 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ad5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ad8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ade:	83 c4 10             	add    $0x10,%esp
  800ae1:	eb 05                	jmp    800ae8 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800ae3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800ae8:	c9                   	leave  
  800ae9:	c3                   	ret    

00800aea <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800af0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800af3:	50                   	push   %eax
  800af4:	ff 75 10             	pushl  0x10(%ebp)
  800af7:	ff 75 0c             	pushl  0xc(%ebp)
  800afa:	ff 75 08             	pushl  0x8(%ebp)
  800afd:	e8 9a ff ff ff       	call   800a9c <vsnprintf>
	va_end(ap);

	return rc;
}
  800b02:	c9                   	leave  
  800b03:	c3                   	ret    

00800b04 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b0a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b0f:	eb 03                	jmp    800b14 <strlen+0x10>
		n++;
  800b11:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b14:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b18:	75 f7                	jne    800b11 <strlen+0xd>
		n++;
	return n;
}
  800b1a:	5d                   	pop    %ebp
  800b1b:	c3                   	ret    

00800b1c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b22:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b25:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2a:	eb 03                	jmp    800b2f <strnlen+0x13>
		n++;
  800b2c:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b2f:	39 c2                	cmp    %eax,%edx
  800b31:	74 08                	je     800b3b <strnlen+0x1f>
  800b33:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b37:	75 f3                	jne    800b2c <strnlen+0x10>
  800b39:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  800b3b:	5d                   	pop    %ebp
  800b3c:	c3                   	ret    

00800b3d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	53                   	push   %ebx
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b47:	89 c2                	mov    %eax,%edx
  800b49:	83 c2 01             	add    $0x1,%edx
  800b4c:	83 c1 01             	add    $0x1,%ecx
  800b4f:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800b53:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b56:	84 db                	test   %bl,%bl
  800b58:	75 ef                	jne    800b49 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800b5a:	5b                   	pop    %ebx
  800b5b:	5d                   	pop    %ebp
  800b5c:	c3                   	ret    

00800b5d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b5d:	55                   	push   %ebp
  800b5e:	89 e5                	mov    %esp,%ebp
  800b60:	53                   	push   %ebx
  800b61:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b64:	53                   	push   %ebx
  800b65:	e8 9a ff ff ff       	call   800b04 <strlen>
  800b6a:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800b6d:	ff 75 0c             	pushl  0xc(%ebp)
  800b70:	01 d8                	add    %ebx,%eax
  800b72:	50                   	push   %eax
  800b73:	e8 c5 ff ff ff       	call   800b3d <strcpy>
	return dst;
}
  800b78:	89 d8                	mov    %ebx,%eax
  800b7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b7d:	c9                   	leave  
  800b7e:	c3                   	ret    

00800b7f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
  800b82:	56                   	push   %esi
  800b83:	53                   	push   %ebx
  800b84:	8b 75 08             	mov    0x8(%ebp),%esi
  800b87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b8a:	89 f3                	mov    %esi,%ebx
  800b8c:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b8f:	89 f2                	mov    %esi,%edx
  800b91:	eb 0f                	jmp    800ba2 <strncpy+0x23>
		*dst++ = *src;
  800b93:	83 c2 01             	add    $0x1,%edx
  800b96:	0f b6 01             	movzbl (%ecx),%eax
  800b99:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b9c:	80 39 01             	cmpb   $0x1,(%ecx)
  800b9f:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ba2:	39 da                	cmp    %ebx,%edx
  800ba4:	75 ed                	jne    800b93 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800ba6:	89 f0                	mov    %esi,%eax
  800ba8:	5b                   	pop    %ebx
  800ba9:	5e                   	pop    %esi
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    

00800bac <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	56                   	push   %esi
  800bb0:	53                   	push   %ebx
  800bb1:	8b 75 08             	mov    0x8(%ebp),%esi
  800bb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb7:	8b 55 10             	mov    0x10(%ebp),%edx
  800bba:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800bbc:	85 d2                	test   %edx,%edx
  800bbe:	74 21                	je     800be1 <strlcpy+0x35>
  800bc0:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800bc4:	89 f2                	mov    %esi,%edx
  800bc6:	eb 09                	jmp    800bd1 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800bc8:	83 c2 01             	add    $0x1,%edx
  800bcb:	83 c1 01             	add    $0x1,%ecx
  800bce:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bd1:	39 c2                	cmp    %eax,%edx
  800bd3:	74 09                	je     800bde <strlcpy+0x32>
  800bd5:	0f b6 19             	movzbl (%ecx),%ebx
  800bd8:	84 db                	test   %bl,%bl
  800bda:	75 ec                	jne    800bc8 <strlcpy+0x1c>
  800bdc:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  800bde:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800be1:	29 f0                	sub    %esi,%eax
}
  800be3:	5b                   	pop    %ebx
  800be4:	5e                   	pop    %esi
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bed:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bf0:	eb 06                	jmp    800bf8 <strcmp+0x11>
		p++, q++;
  800bf2:	83 c1 01             	add    $0x1,%ecx
  800bf5:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bf8:	0f b6 01             	movzbl (%ecx),%eax
  800bfb:	84 c0                	test   %al,%al
  800bfd:	74 04                	je     800c03 <strcmp+0x1c>
  800bff:	3a 02                	cmp    (%edx),%al
  800c01:	74 ef                	je     800bf2 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c03:	0f b6 c0             	movzbl %al,%eax
  800c06:	0f b6 12             	movzbl (%edx),%edx
  800c09:	29 d0                	sub    %edx,%eax
}
  800c0b:	5d                   	pop    %ebp
  800c0c:	c3                   	ret    

00800c0d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	53                   	push   %ebx
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c17:	89 c3                	mov    %eax,%ebx
  800c19:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c1c:	eb 06                	jmp    800c24 <strncmp+0x17>
		n--, p++, q++;
  800c1e:	83 c0 01             	add    $0x1,%eax
  800c21:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800c24:	39 d8                	cmp    %ebx,%eax
  800c26:	74 15                	je     800c3d <strncmp+0x30>
  800c28:	0f b6 08             	movzbl (%eax),%ecx
  800c2b:	84 c9                	test   %cl,%cl
  800c2d:	74 04                	je     800c33 <strncmp+0x26>
  800c2f:	3a 0a                	cmp    (%edx),%cl
  800c31:	74 eb                	je     800c1e <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c33:	0f b6 00             	movzbl (%eax),%eax
  800c36:	0f b6 12             	movzbl (%edx),%edx
  800c39:	29 d0                	sub    %edx,%eax
  800c3b:	eb 05                	jmp    800c42 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800c3d:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c42:	5b                   	pop    %ebx
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    

00800c45 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c4f:	eb 07                	jmp    800c58 <strchr+0x13>
		if (*s == c)
  800c51:	38 ca                	cmp    %cl,%dl
  800c53:	74 0f                	je     800c64 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c55:	83 c0 01             	add    $0x1,%eax
  800c58:	0f b6 10             	movzbl (%eax),%edx
  800c5b:	84 d2                	test   %dl,%dl
  800c5d:	75 f2                	jne    800c51 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800c5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c64:	5d                   	pop    %ebp
  800c65:	c3                   	ret    

00800c66 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c70:	eb 03                	jmp    800c75 <strfind+0xf>
  800c72:	83 c0 01             	add    $0x1,%eax
  800c75:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c78:	38 ca                	cmp    %cl,%dl
  800c7a:	74 04                	je     800c80 <strfind+0x1a>
  800c7c:	84 d2                	test   %dl,%dl
  800c7e:	75 f2                	jne    800c72 <strfind+0xc>
			break;
	return (char *) s;
}
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    

00800c82 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	57                   	push   %edi
  800c86:	56                   	push   %esi
  800c87:	53                   	push   %ebx
  800c88:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800c8e:	85 c9                	test   %ecx,%ecx
  800c90:	74 37                	je     800cc9 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c92:	f6 c2 03             	test   $0x3,%dl
  800c95:	75 2a                	jne    800cc1 <memset+0x3f>
  800c97:	f6 c1 03             	test   $0x3,%cl
  800c9a:	75 25                	jne    800cc1 <memset+0x3f>
		c &= 0xFF;
  800c9c:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ca0:	89 df                	mov    %ebx,%edi
  800ca2:	c1 e7 08             	shl    $0x8,%edi
  800ca5:	89 de                	mov    %ebx,%esi
  800ca7:	c1 e6 18             	shl    $0x18,%esi
  800caa:	89 d8                	mov    %ebx,%eax
  800cac:	c1 e0 10             	shl    $0x10,%eax
  800caf:	09 f0                	or     %esi,%eax
  800cb1:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800cb3:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800cb6:	89 f8                	mov    %edi,%eax
  800cb8:	09 d8                	or     %ebx,%eax
  800cba:	89 d7                	mov    %edx,%edi
  800cbc:	fc                   	cld    
  800cbd:	f3 ab                	rep stos %eax,%es:(%edi)
  800cbf:	eb 08                	jmp    800cc9 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800cc1:	89 d7                	mov    %edx,%edi
  800cc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc6:	fc                   	cld    
  800cc7:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800cc9:	89 d0                	mov    %edx,%eax
  800ccb:	5b                   	pop    %ebx
  800ccc:	5e                   	pop    %esi
  800ccd:	5f                   	pop    %edi
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    

00800cd0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	57                   	push   %edi
  800cd4:	56                   	push   %esi
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cdb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cde:	39 c6                	cmp    %eax,%esi
  800ce0:	73 35                	jae    800d17 <memmove+0x47>
  800ce2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ce5:	39 d0                	cmp    %edx,%eax
  800ce7:	73 2e                	jae    800d17 <memmove+0x47>
		s += n;
		d += n;
  800ce9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cec:	89 d6                	mov    %edx,%esi
  800cee:	09 fe                	or     %edi,%esi
  800cf0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cf6:	75 13                	jne    800d0b <memmove+0x3b>
  800cf8:	f6 c1 03             	test   $0x3,%cl
  800cfb:	75 0e                	jne    800d0b <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  800cfd:	83 ef 04             	sub    $0x4,%edi
  800d00:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d03:	c1 e9 02             	shr    $0x2,%ecx
  800d06:	fd                   	std    
  800d07:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d09:	eb 09                	jmp    800d14 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800d0b:	83 ef 01             	sub    $0x1,%edi
  800d0e:	8d 72 ff             	lea    -0x1(%edx),%esi
  800d11:	fd                   	std    
  800d12:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d14:	fc                   	cld    
  800d15:	eb 1d                	jmp    800d34 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d17:	89 f2                	mov    %esi,%edx
  800d19:	09 c2                	or     %eax,%edx
  800d1b:	f6 c2 03             	test   $0x3,%dl
  800d1e:	75 0f                	jne    800d2f <memmove+0x5f>
  800d20:	f6 c1 03             	test   $0x3,%cl
  800d23:	75 0a                	jne    800d2f <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  800d25:	c1 e9 02             	shr    $0x2,%ecx
  800d28:	89 c7                	mov    %eax,%edi
  800d2a:	fc                   	cld    
  800d2b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d2d:	eb 05                	jmp    800d34 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800d2f:	89 c7                	mov    %eax,%edi
  800d31:	fc                   	cld    
  800d32:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d34:	5e                   	pop    %esi
  800d35:	5f                   	pop    %edi
  800d36:	5d                   	pop    %ebp
  800d37:	c3                   	ret    

00800d38 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800d3b:	ff 75 10             	pushl  0x10(%ebp)
  800d3e:	ff 75 0c             	pushl  0xc(%ebp)
  800d41:	ff 75 08             	pushl  0x8(%ebp)
  800d44:	e8 87 ff ff ff       	call   800cd0 <memmove>
}
  800d49:	c9                   	leave  
  800d4a:	c3                   	ret    

00800d4b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
  800d4e:	56                   	push   %esi
  800d4f:	53                   	push   %ebx
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d56:	89 c6                	mov    %eax,%esi
  800d58:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d5b:	eb 1a                	jmp    800d77 <memcmp+0x2c>
		if (*s1 != *s2)
  800d5d:	0f b6 08             	movzbl (%eax),%ecx
  800d60:	0f b6 1a             	movzbl (%edx),%ebx
  800d63:	38 d9                	cmp    %bl,%cl
  800d65:	74 0a                	je     800d71 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800d67:	0f b6 c1             	movzbl %cl,%eax
  800d6a:	0f b6 db             	movzbl %bl,%ebx
  800d6d:	29 d8                	sub    %ebx,%eax
  800d6f:	eb 0f                	jmp    800d80 <memcmp+0x35>
		s1++, s2++;
  800d71:	83 c0 01             	add    $0x1,%eax
  800d74:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d77:	39 f0                	cmp    %esi,%eax
  800d79:	75 e2                	jne    800d5d <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d80:	5b                   	pop    %ebx
  800d81:	5e                   	pop    %esi
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    

00800d84 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	53                   	push   %ebx
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800d8b:	89 c1                	mov    %eax,%ecx
  800d8d:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  800d90:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d94:	eb 0a                	jmp    800da0 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d96:	0f b6 10             	movzbl (%eax),%edx
  800d99:	39 da                	cmp    %ebx,%edx
  800d9b:	74 07                	je     800da4 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d9d:	83 c0 01             	add    $0x1,%eax
  800da0:	39 c8                	cmp    %ecx,%eax
  800da2:	72 f2                	jb     800d96 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800da4:	5b                   	pop    %ebx
  800da5:	5d                   	pop    %ebp
  800da6:	c3                   	ret    

00800da7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	57                   	push   %edi
  800dab:	56                   	push   %esi
  800dac:	53                   	push   %ebx
  800dad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800db0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800db3:	eb 03                	jmp    800db8 <strtol+0x11>
		s++;
  800db5:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800db8:	0f b6 01             	movzbl (%ecx),%eax
  800dbb:	3c 20                	cmp    $0x20,%al
  800dbd:	74 f6                	je     800db5 <strtol+0xe>
  800dbf:	3c 09                	cmp    $0x9,%al
  800dc1:	74 f2                	je     800db5 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800dc3:	3c 2b                	cmp    $0x2b,%al
  800dc5:	75 0a                	jne    800dd1 <strtol+0x2a>
		s++;
  800dc7:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800dca:	bf 00 00 00 00       	mov    $0x0,%edi
  800dcf:	eb 11                	jmp    800de2 <strtol+0x3b>
  800dd1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800dd6:	3c 2d                	cmp    $0x2d,%al
  800dd8:	75 08                	jne    800de2 <strtol+0x3b>
		s++, neg = 1;
  800dda:	83 c1 01             	add    $0x1,%ecx
  800ddd:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800de2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800de8:	75 15                	jne    800dff <strtol+0x58>
  800dea:	80 39 30             	cmpb   $0x30,(%ecx)
  800ded:	75 10                	jne    800dff <strtol+0x58>
  800def:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800df3:	75 7c                	jne    800e71 <strtol+0xca>
		s += 2, base = 16;
  800df5:	83 c1 02             	add    $0x2,%ecx
  800df8:	bb 10 00 00 00       	mov    $0x10,%ebx
  800dfd:	eb 16                	jmp    800e15 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800dff:	85 db                	test   %ebx,%ebx
  800e01:	75 12                	jne    800e15 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e03:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e08:	80 39 30             	cmpb   $0x30,(%ecx)
  800e0b:	75 08                	jne    800e15 <strtol+0x6e>
		s++, base = 8;
  800e0d:	83 c1 01             	add    $0x1,%ecx
  800e10:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800e15:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1a:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e1d:	0f b6 11             	movzbl (%ecx),%edx
  800e20:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e23:	89 f3                	mov    %esi,%ebx
  800e25:	80 fb 09             	cmp    $0x9,%bl
  800e28:	77 08                	ja     800e32 <strtol+0x8b>
			dig = *s - '0';
  800e2a:	0f be d2             	movsbl %dl,%edx
  800e2d:	83 ea 30             	sub    $0x30,%edx
  800e30:	eb 22                	jmp    800e54 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800e32:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e35:	89 f3                	mov    %esi,%ebx
  800e37:	80 fb 19             	cmp    $0x19,%bl
  800e3a:	77 08                	ja     800e44 <strtol+0x9d>
			dig = *s - 'a' + 10;
  800e3c:	0f be d2             	movsbl %dl,%edx
  800e3f:	83 ea 57             	sub    $0x57,%edx
  800e42:	eb 10                	jmp    800e54 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800e44:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e47:	89 f3                	mov    %esi,%ebx
  800e49:	80 fb 19             	cmp    $0x19,%bl
  800e4c:	77 16                	ja     800e64 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800e4e:	0f be d2             	movsbl %dl,%edx
  800e51:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800e54:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e57:	7d 0b                	jge    800e64 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800e59:	83 c1 01             	add    $0x1,%ecx
  800e5c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e60:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800e62:	eb b9                	jmp    800e1d <strtol+0x76>

	if (endptr)
  800e64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e68:	74 0d                	je     800e77 <strtol+0xd0>
		*endptr = (char *) s;
  800e6a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e6d:	89 0e                	mov    %ecx,(%esi)
  800e6f:	eb 06                	jmp    800e77 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e71:	85 db                	test   %ebx,%ebx
  800e73:	74 98                	je     800e0d <strtol+0x66>
  800e75:	eb 9e                	jmp    800e15 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800e77:	89 c2                	mov    %eax,%edx
  800e79:	f7 da                	neg    %edx
  800e7b:	85 ff                	test   %edi,%edi
  800e7d:	0f 45 c2             	cmovne %edx,%eax
}
  800e80:	5b                   	pop    %ebx
  800e81:	5e                   	pop    %esi
  800e82:	5f                   	pop    %edi
  800e83:	5d                   	pop    %ebp
  800e84:	c3                   	ret    

00800e85 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	57                   	push   %edi
  800e89:	56                   	push   %esi
  800e8a:	53                   	push   %ebx
  800e8b:	83 ec 1c             	sub    $0x1c,%esp
  800e8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e91:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800e94:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e99:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800e9c:	8b 7d 10             	mov    0x10(%ebp),%edi
  800e9f:	8b 75 14             	mov    0x14(%ebp),%esi
  800ea2:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ea4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ea8:	74 1d                	je     800ec7 <syscall+0x42>
  800eaa:	85 c0                	test   %eax,%eax
  800eac:	7e 19                	jle    800ec7 <syscall+0x42>
  800eae:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb1:	83 ec 0c             	sub    $0xc,%esp
  800eb4:	50                   	push   %eax
  800eb5:	52                   	push   %edx
  800eb6:	68 df 2f 80 00       	push   $0x802fdf
  800ebb:	6a 23                	push   $0x23
  800ebd:	68 fc 2f 80 00       	push   $0x802ffc
  800ec2:	e8 2b f6 ff ff       	call   8004f2 <_panic>

	return ret;
}
  800ec7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eca:	5b                   	pop    %ebx
  800ecb:	5e                   	pop    %esi
  800ecc:	5f                   	pop    %edi
  800ecd:	5d                   	pop    %ebp
  800ece:	c3                   	ret    

00800ecf <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800ed5:	6a 00                	push   $0x0
  800ed7:	6a 00                	push   $0x0
  800ed9:	6a 00                	push   $0x0
  800edb:	ff 75 0c             	pushl  0xc(%ebp)
  800ede:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ee1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ee6:	b8 00 00 00 00       	mov    $0x0,%eax
  800eeb:	e8 95 ff ff ff       	call   800e85 <syscall>
}
  800ef0:	83 c4 10             	add    $0x10,%esp
  800ef3:	c9                   	leave  
  800ef4:	c3                   	ret    

00800ef5 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800efb:	6a 00                	push   $0x0
  800efd:	6a 00                	push   $0x0
  800eff:	6a 00                	push   $0x0
  800f01:	6a 00                	push   $0x0
  800f03:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f08:	ba 00 00 00 00       	mov    $0x0,%edx
  800f0d:	b8 01 00 00 00       	mov    $0x1,%eax
  800f12:	e8 6e ff ff ff       	call   800e85 <syscall>
}
  800f17:	c9                   	leave  
  800f18:	c3                   	ret    

00800f19 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800f1f:	6a 00                	push   $0x0
  800f21:	6a 00                	push   $0x0
  800f23:	6a 00                	push   $0x0
  800f25:	6a 00                	push   $0x0
  800f27:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f2a:	ba 01 00 00 00       	mov    $0x1,%edx
  800f2f:	b8 03 00 00 00       	mov    $0x3,%eax
  800f34:	e8 4c ff ff ff       	call   800e85 <syscall>
}
  800f39:	c9                   	leave  
  800f3a:	c3                   	ret    

00800f3b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800f41:	6a 00                	push   $0x0
  800f43:	6a 00                	push   $0x0
  800f45:	6a 00                	push   $0x0
  800f47:	6a 00                	push   $0x0
  800f49:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f53:	b8 02 00 00 00       	mov    $0x2,%eax
  800f58:	e8 28 ff ff ff       	call   800e85 <syscall>
}
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    

00800f5f <sys_yield>:

void
sys_yield(void)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800f65:	6a 00                	push   $0x0
  800f67:	6a 00                	push   $0x0
  800f69:	6a 00                	push   $0x0
  800f6b:	6a 00                	push   $0x0
  800f6d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f72:	ba 00 00 00 00       	mov    $0x0,%edx
  800f77:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f7c:	e8 04 ff ff ff       	call   800e85 <syscall>
}
  800f81:	83 c4 10             	add    $0x10,%esp
  800f84:	c9                   	leave  
  800f85:	c3                   	ret    

00800f86 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800f8c:	6a 00                	push   $0x0
  800f8e:	6a 00                	push   $0x0
  800f90:	ff 75 10             	pushl  0x10(%ebp)
  800f93:	ff 75 0c             	pushl  0xc(%ebp)
  800f96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f99:	ba 01 00 00 00       	mov    $0x1,%edx
  800f9e:	b8 04 00 00 00       	mov    $0x4,%eax
  800fa3:	e8 dd fe ff ff       	call   800e85 <syscall>
}
  800fa8:	c9                   	leave  
  800fa9:	c3                   	ret    

00800faa <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800fb0:	ff 75 18             	pushl  0x18(%ebp)
  800fb3:	ff 75 14             	pushl  0x14(%ebp)
  800fb6:	ff 75 10             	pushl  0x10(%ebp)
  800fb9:	ff 75 0c             	pushl  0xc(%ebp)
  800fbc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fbf:	ba 01 00 00 00       	mov    $0x1,%edx
  800fc4:	b8 05 00 00 00       	mov    $0x5,%eax
  800fc9:	e8 b7 fe ff ff       	call   800e85 <syscall>
}
  800fce:	c9                   	leave  
  800fcf:	c3                   	ret    

00800fd0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800fd6:	6a 00                	push   $0x0
  800fd8:	6a 00                	push   $0x0
  800fda:	6a 00                	push   $0x0
  800fdc:	ff 75 0c             	pushl  0xc(%ebp)
  800fdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fe2:	ba 01 00 00 00       	mov    $0x1,%edx
  800fe7:	b8 06 00 00 00       	mov    $0x6,%eax
  800fec:	e8 94 fe ff ff       	call   800e85 <syscall>
}
  800ff1:	c9                   	leave  
  800ff2:	c3                   	ret    

00800ff3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800ff9:	6a 00                	push   $0x0
  800ffb:	6a 00                	push   $0x0
  800ffd:	6a 00                	push   $0x0
  800fff:	ff 75 0c             	pushl  0xc(%ebp)
  801002:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801005:	ba 01 00 00 00       	mov    $0x1,%edx
  80100a:	b8 08 00 00 00       	mov    $0x8,%eax
  80100f:	e8 71 fe ff ff       	call   800e85 <syscall>
}
  801014:	c9                   	leave  
  801015:	c3                   	ret    

00801016 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  80101c:	6a 00                	push   $0x0
  80101e:	6a 00                	push   $0x0
  801020:	6a 00                	push   $0x0
  801022:	ff 75 0c             	pushl  0xc(%ebp)
  801025:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801028:	ba 01 00 00 00       	mov    $0x1,%edx
  80102d:	b8 09 00 00 00       	mov    $0x9,%eax
  801032:	e8 4e fe ff ff       	call   800e85 <syscall>
}
  801037:	c9                   	leave  
  801038:	c3                   	ret    

00801039 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  80103f:	6a 00                	push   $0x0
  801041:	6a 00                	push   $0x0
  801043:	6a 00                	push   $0x0
  801045:	ff 75 0c             	pushl  0xc(%ebp)
  801048:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80104b:	ba 01 00 00 00       	mov    $0x1,%edx
  801050:	b8 0a 00 00 00       	mov    $0xa,%eax
  801055:	e8 2b fe ff ff       	call   800e85 <syscall>
}
  80105a:	c9                   	leave  
  80105b:	c3                   	ret    

0080105c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  801062:	6a 00                	push   $0x0
  801064:	ff 75 14             	pushl  0x14(%ebp)
  801067:	ff 75 10             	pushl  0x10(%ebp)
  80106a:	ff 75 0c             	pushl  0xc(%ebp)
  80106d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801070:	ba 00 00 00 00       	mov    $0x0,%edx
  801075:	b8 0c 00 00 00       	mov    $0xc,%eax
  80107a:	e8 06 fe ff ff       	call   800e85 <syscall>
}
  80107f:	c9                   	leave  
  801080:	c3                   	ret    

00801081 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  801087:	6a 00                	push   $0x0
  801089:	6a 00                	push   $0x0
  80108b:	6a 00                	push   $0x0
  80108d:	6a 00                	push   $0x0
  80108f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801092:	ba 01 00 00 00       	mov    $0x1,%edx
  801097:	b8 0d 00 00 00       	mov    $0xd,%eax
  80109c:	e8 e4 fd ff ff       	call   800e85 <syscall>
}
  8010a1:	c9                   	leave  
  8010a2:	c3                   	ret    

008010a3 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	53                   	push   %ebx
  8010a7:	83 ec 04             	sub    $0x4,%esp

	int perm_w = PTE_COW|PTE_U|PTE_P;
	int perm = PTE_U|PTE_P;

	// LAB 4: Your code here.
	void *addr = (void*) (pn*PGSIZE);
  8010aa:	89 d3                	mov    %edx,%ebx
  8010ac:	c1 e3 0c             	shl    $0xc,%ebx

	//Si una página tiene el bit PTE_SHARE, se comparte con el hijo con los mismos permisos.
  	if (uvpt[pn] & PTE_SHARE) {
  8010af:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010b6:	f6 c5 04             	test   $0x4,%ch
  8010b9:	74 3a                	je     8010f5 <duppage+0x52>
    	if (sys_page_map(0, addr, envid,addr, uvpt[pn] & PTE_SYSCALL) < 0) {
  8010bb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010c2:	83 ec 0c             	sub    $0xc,%esp
  8010c5:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8010cb:	52                   	push   %edx
  8010cc:	53                   	push   %ebx
  8010cd:	50                   	push   %eax
  8010ce:	53                   	push   %ebx
  8010cf:	6a 00                	push   $0x0
  8010d1:	e8 d4 fe ff ff       	call   800faa <sys_page_map>
  8010d6:	83 c4 20             	add    $0x20,%esp
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	0f 89 99 00 00 00    	jns    80117a <duppage+0xd7>
 	     	panic("Error en sys_page_map");
  8010e1:	83 ec 04             	sub    $0x4,%esp
  8010e4:	68 0a 30 80 00       	push   $0x80300a
  8010e9:	6a 50                	push   $0x50
  8010eb:	68 20 30 80 00       	push   $0x803020
  8010f0:	e8 fd f3 ff ff       	call   8004f2 <_panic>
    	} 
    	return 0;
	}

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) {
  8010f5:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010fc:	f6 c1 02             	test   $0x2,%cl
  8010ff:	75 0c                	jne    80110d <duppage+0x6a>
  801101:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801108:	f6 c6 08             	test   $0x8,%dh
  80110b:	74 5b                	je     801168 <duppage+0xc5>
		if (sys_page_map(0, addr, envid, addr, perm_w) < 0){
  80110d:	83 ec 0c             	sub    $0xc,%esp
  801110:	68 05 08 00 00       	push   $0x805
  801115:	53                   	push   %ebx
  801116:	50                   	push   %eax
  801117:	53                   	push   %ebx
  801118:	6a 00                	push   $0x0
  80111a:	e8 8b fe ff ff       	call   800faa <sys_page_map>
  80111f:	83 c4 20             	add    $0x20,%esp
  801122:	85 c0                	test   %eax,%eax
  801124:	79 14                	jns    80113a <duppage+0x97>
			panic("Error mapeando pagina Padre");
  801126:	83 ec 04             	sub    $0x4,%esp
  801129:	68 2b 30 80 00       	push   $0x80302b
  80112e:	6a 57                	push   $0x57
  801130:	68 20 30 80 00       	push   $0x803020
  801135:	e8 b8 f3 ff ff       	call   8004f2 <_panic>
		}
		if (sys_page_map(0, addr, 0, addr, perm_w) < 0){
  80113a:	83 ec 0c             	sub    $0xc,%esp
  80113d:	68 05 08 00 00       	push   $0x805
  801142:	53                   	push   %ebx
  801143:	6a 00                	push   $0x0
  801145:	53                   	push   %ebx
  801146:	6a 00                	push   $0x0
  801148:	e8 5d fe ff ff       	call   800faa <sys_page_map>
  80114d:	83 c4 20             	add    $0x20,%esp
  801150:	85 c0                	test   %eax,%eax
  801152:	79 26                	jns    80117a <duppage+0xd7>
			panic("Error mapeando pagina Hijo");
  801154:	83 ec 04             	sub    $0x4,%esp
  801157:	68 47 30 80 00       	push   $0x803047
  80115c:	6a 5a                	push   $0x5a
  80115e:	68 20 30 80 00       	push   $0x803020
  801163:	e8 8a f3 ff ff       	call   8004f2 <_panic>
		}
	} else sys_page_map(0, addr, envid, addr, perm);
  801168:	83 ec 0c             	sub    $0xc,%esp
  80116b:	6a 05                	push   $0x5
  80116d:	53                   	push   %ebx
  80116e:	50                   	push   %eax
  80116f:	53                   	push   %ebx
  801170:	6a 00                	push   $0x0
  801172:	e8 33 fe ff ff       	call   800faa <sys_page_map>
  801177:	83 c4 20             	add    $0x20,%esp
	
	return 0;
}
  80117a:	b8 00 00 00 00       	mov    $0x0,%eax
  80117f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801182:	c9                   	leave  
  801183:	c3                   	ret    

00801184 <dup_or_share>:
//FORK V0

static void
dup_or_share(envid_t dstenv, void *va, int perm){
  801184:	55                   	push   %ebp
  801185:	89 e5                	mov    %esp,%ebp
  801187:	57                   	push   %edi
  801188:	56                   	push   %esi
  801189:	53                   	push   %ebx
  80118a:	83 ec 0c             	sub    $0xc,%esp
  80118d:	89 c7                	mov    %eax,%edi
  80118f:	89 d6                	mov    %edx,%esi
  801191:	89 cb                	mov    %ecx,%ebx
	int result;
	// Si no es de escritura, comparto la pagina
	if((perm &PTE_W) != PTE_W){
  801193:	f6 c1 02             	test   $0x2,%cl
  801196:	75 2d                	jne    8011c5 <dup_or_share+0x41>
		if((result = sys_page_map(0, va, dstenv, va, perm))<0){
  801198:	83 ec 0c             	sub    $0xc,%esp
  80119b:	51                   	push   %ecx
  80119c:	52                   	push   %edx
  80119d:	50                   	push   %eax
  80119e:	52                   	push   %edx
  80119f:	6a 00                	push   $0x0
  8011a1:	e8 04 fe ff ff       	call   800faa <sys_page_map>
  8011a6:	83 c4 20             	add    $0x20,%esp
  8011a9:	85 c0                	test   %eax,%eax
  8011ab:	0f 89 a4 00 00 00    	jns    801255 <dup_or_share+0xd1>
			panic("Error compartiendo la pagina");
  8011b1:	83 ec 04             	sub    $0x4,%esp
  8011b4:	68 62 30 80 00       	push   $0x803062
  8011b9:	6a 68                	push   $0x68
  8011bb:	68 20 30 80 00       	push   $0x803020
  8011c0:	e8 2d f3 ff ff       	call   8004f2 <_panic>
		}
	// Si es de escritura comportamiento de duppage, en dumbfork
	}else{
		if ((result = sys_page_alloc(dstenv, va, perm)) < 0){
  8011c5:	83 ec 04             	sub    $0x4,%esp
  8011c8:	51                   	push   %ecx
  8011c9:	52                   	push   %edx
  8011ca:	50                   	push   %eax
  8011cb:	e8 b6 fd ff ff       	call   800f86 <sys_page_alloc>
  8011d0:	83 c4 10             	add    $0x10,%esp
  8011d3:	85 c0                	test   %eax,%eax
  8011d5:	79 14                	jns    8011eb <dup_or_share+0x67>
			panic("Error copiando la pagina");
  8011d7:	83 ec 04             	sub    $0x4,%esp
  8011da:	68 7f 30 80 00       	push   $0x80307f
  8011df:	6a 6d                	push   $0x6d
  8011e1:	68 20 30 80 00       	push   $0x803020
  8011e6:	e8 07 f3 ff ff       	call   8004f2 <_panic>
		}
		if ((result = sys_page_map(dstenv, va, 0, UTEMP, perm)) < 0){
  8011eb:	83 ec 0c             	sub    $0xc,%esp
  8011ee:	53                   	push   %ebx
  8011ef:	68 00 00 40 00       	push   $0x400000
  8011f4:	6a 00                	push   $0x0
  8011f6:	56                   	push   %esi
  8011f7:	57                   	push   %edi
  8011f8:	e8 ad fd ff ff       	call   800faa <sys_page_map>
  8011fd:	83 c4 20             	add    $0x20,%esp
  801200:	85 c0                	test   %eax,%eax
  801202:	79 14                	jns    801218 <dup_or_share+0x94>
			panic("Error copiando la pagina");
  801204:	83 ec 04             	sub    $0x4,%esp
  801207:	68 7f 30 80 00       	push   $0x80307f
  80120c:	6a 70                	push   $0x70
  80120e:	68 20 30 80 00       	push   $0x803020
  801213:	e8 da f2 ff ff       	call   8004f2 <_panic>
		}
		memmove(UTEMP, va, PGSIZE);
  801218:	83 ec 04             	sub    $0x4,%esp
  80121b:	68 00 10 00 00       	push   $0x1000
  801220:	56                   	push   %esi
  801221:	68 00 00 40 00       	push   $0x400000
  801226:	e8 a5 fa ff ff       	call   800cd0 <memmove>
		if ((result = sys_page_unmap(0, UTEMP)) < 0){
  80122b:	83 c4 08             	add    $0x8,%esp
  80122e:	68 00 00 40 00       	push   $0x400000
  801233:	6a 00                	push   $0x0
  801235:	e8 96 fd ff ff       	call   800fd0 <sys_page_unmap>
  80123a:	83 c4 10             	add    $0x10,%esp
  80123d:	85 c0                	test   %eax,%eax
  80123f:	79 14                	jns    801255 <dup_or_share+0xd1>
			panic("Error copiando la pagina");
  801241:	83 ec 04             	sub    $0x4,%esp
  801244:	68 7f 30 80 00       	push   $0x80307f
  801249:	6a 74                	push   $0x74
  80124b:	68 20 30 80 00       	push   $0x803020
  801250:	e8 9d f2 ff ff       	call   8004f2 <_panic>
		}
	}	
}
  801255:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801258:	5b                   	pop    %ebx
  801259:	5e                   	pop    %esi
  80125a:	5f                   	pop    %edi
  80125b:	5d                   	pop    %ebp
  80125c:	c3                   	ret    

0080125d <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80125d:	55                   	push   %ebp
  80125e:	89 e5                	mov    %esp,%ebp
  801260:	53                   	push   %ebx
  801261:	83 ec 04             	sub    $0x4,%esp
  801264:	8b 55 08             	mov    0x8(%ebp),%edx
	void *va = (void *) utf->utf_fault_va;
  801267:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  801269:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  80126d:	74 2e                	je     80129d <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
  80126f:	89 c2                	mov    %eax,%edx
  801271:	c1 ea 16             	shr    $0x16,%edx
  801274:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  80127b:	f6 c2 01             	test   $0x1,%dl
  80127e:	74 1d                	je     80129d <pgfault+0x40>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
  801280:	89 c2                	mov    %eax,%edx
  801282:	c1 ea 0c             	shr    $0xc,%edx
  801285:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
		(uvpd[PDX(va)] & PTE_P) && 
  80128c:	f6 c1 01             	test   $0x1,%cl
  80128f:	74 0c                	je     80129d <pgfault+0x40>
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
  801291:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && 
  801298:	f6 c6 08             	test   $0x8,%dh
  80129b:	75 14                	jne    8012b1 <pgfault+0x54>
		(uvpd[PDX(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_P) && 
		(uvpt[PGNUM(va)] & PTE_COW)))
		panic("No es copy-on-write");
  80129d:	83 ec 04             	sub    $0x4,%esp
  8012a0:	68 98 30 80 00       	push   $0x803098
  8012a5:	6a 21                	push   $0x21
  8012a7:	68 20 30 80 00       	push   $0x803020
  8012ac:	e8 41 f2 ff ff       	call   8004f2 <_panic>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	va = ROUNDDOWN(va, PGSIZE);
  8012b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012b6:	89 c3                	mov    %eax,%ebx
	if (sys_page_alloc(0, PFTEMP, perm) < 0){
  8012b8:	83 ec 04             	sub    $0x4,%esp
  8012bb:	6a 07                	push   $0x7
  8012bd:	68 00 f0 7f 00       	push   $0x7ff000
  8012c2:	6a 00                	push   $0x0
  8012c4:	e8 bd fc ff ff       	call   800f86 <sys_page_alloc>
  8012c9:	83 c4 10             	add    $0x10,%esp
  8012cc:	85 c0                	test   %eax,%eax
  8012ce:	79 14                	jns    8012e4 <pgfault+0x87>
		panic("Error sys_page_alloc");
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	68 ac 30 80 00       	push   $0x8030ac
  8012d8:	6a 2a                	push   $0x2a
  8012da:	68 20 30 80 00       	push   $0x803020
  8012df:	e8 0e f2 ff ff       	call   8004f2 <_panic>
	}
	memcpy(PFTEMP, va, PGSIZE);
  8012e4:	83 ec 04             	sub    $0x4,%esp
  8012e7:	68 00 10 00 00       	push   $0x1000
  8012ec:	53                   	push   %ebx
  8012ed:	68 00 f0 7f 00       	push   $0x7ff000
  8012f2:	e8 41 fa ff ff       	call   800d38 <memcpy>
	if (sys_page_map(0, PFTEMP, 0, va, perm) < 0){
  8012f7:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8012fe:	53                   	push   %ebx
  8012ff:	6a 00                	push   $0x0
  801301:	68 00 f0 7f 00       	push   $0x7ff000
  801306:	6a 00                	push   $0x0
  801308:	e8 9d fc ff ff       	call   800faa <sys_page_map>
  80130d:	83 c4 20             	add    $0x20,%esp
  801310:	85 c0                	test   %eax,%eax
  801312:	79 14                	jns    801328 <pgfault+0xcb>
		panic("Error sys_page_map");
  801314:	83 ec 04             	sub    $0x4,%esp
  801317:	68 c1 30 80 00       	push   $0x8030c1
  80131c:	6a 2e                	push   $0x2e
  80131e:	68 20 30 80 00       	push   $0x803020
  801323:	e8 ca f1 ff ff       	call   8004f2 <_panic>
	}
	if (sys_page_unmap(0, PFTEMP) < 0){
  801328:	83 ec 08             	sub    $0x8,%esp
  80132b:	68 00 f0 7f 00       	push   $0x7ff000
  801330:	6a 00                	push   $0x0
  801332:	e8 99 fc ff ff       	call   800fd0 <sys_page_unmap>
  801337:	83 c4 10             	add    $0x10,%esp
  80133a:	85 c0                	test   %eax,%eax
  80133c:	79 14                	jns    801352 <pgfault+0xf5>
		panic("Error sys_page_unmap");
  80133e:	83 ec 04             	sub    $0x4,%esp
  801341:	68 d4 30 80 00       	push   $0x8030d4
  801346:	6a 31                	push   $0x31
  801348:	68 20 30 80 00       	push   $0x803020
  80134d:	e8 a0 f1 ff ff       	call   8004f2 <_panic>
	}
	return;

}
  801352:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801355:	c9                   	leave  
  801356:	c3                   	ret    

00801357 <fork_v0>:
		}
	}	
}

envid_t
fork_v0(void){
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	57                   	push   %edi
  80135b:	56                   	push   %esi
  80135c:	53                   	push   %ebx
  80135d:	83 ec 0c             	sub    $0xc,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801360:	b8 07 00 00 00       	mov    $0x7,%eax
  801365:	cd 30                	int    $0x30
  801367:	89 c6                	mov    %eax,%esi
	envid_t envid;
	uint8_t *va;
	int result;	

	envid = sys_exofork();
	if (envid < 0)
  801369:	85 c0                	test   %eax,%eax
  80136b:	79 15                	jns    801382 <fork_v0+0x2b>
		panic("sys_exofork: %e", envid);
  80136d:	50                   	push   %eax
  80136e:	68 e9 30 80 00       	push   $0x8030e9
  801373:	68 81 00 00 00       	push   $0x81
  801378:	68 20 30 80 00       	push   $0x803020
  80137d:	e8 70 f1 ff ff       	call   8004f2 <_panic>
  801382:	89 c7                	mov    %eax,%edi
  801384:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {		
  801389:	85 c0                	test   %eax,%eax
  80138b:	75 1e                	jne    8013ab <fork_v0+0x54>
		thisenv = &envs[ENVX(sys_getenvid())];
  80138d:	e8 a9 fb ff ff       	call   800f3b <sys_getenvid>
  801392:	25 ff 03 00 00       	and    $0x3ff,%eax
  801397:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80139a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80139f:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  8013a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a9:	eb 7a                	jmp    801425 <fork_v0+0xce>
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  8013ab:	89 d8                	mov    %ebx,%eax
  8013ad:	c1 e8 16             	shr    $0x16,%eax
  8013b0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013b7:	a8 01                	test   $0x1,%al
  8013b9:	74 33                	je     8013ee <fork_v0+0x97>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  8013bb:	89 d8                	mov    %ebx,%eax
  8013bd:	c1 e8 0c             	shr    $0xc,%eax
  8013c0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013c7:	f6 c2 01             	test   $0x1,%dl
  8013ca:	74 22                	je     8013ee <fork_v0+0x97>
  8013cc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013d3:	f6 c2 04             	test   $0x4,%dl
  8013d6:	74 16                	je     8013ee <fork_v0+0x97>
				pte_t pte =uvpt[PGNUM(va)];
  8013d8:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
  8013df:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8013e5:	89 da                	mov    %ebx,%edx
  8013e7:	89 f8                	mov    %edi,%eax
  8013e9:	e8 96 fd ff ff       	call   801184 <dup_or_share>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	
	for (va = 0; va <(uint8_t*) UTOP; va += PGSIZE){
  8013ee:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013f4:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  8013fa:	75 af                	jne    8013ab <fork_v0+0x54>
				pte_t pte =uvpt[PGNUM(va)];
				dup_or_share(envid, (void*)va,pte&PTE_SYSCALL);
			}
		}
	}	
	if ((result = sys_env_set_status(envid, ENV_RUNNABLE)) < 0){
  8013fc:	83 ec 08             	sub    $0x8,%esp
  8013ff:	6a 02                	push   $0x2
  801401:	56                   	push   %esi
  801402:	e8 ec fb ff ff       	call   800ff3 <sys_env_set_status>
  801407:	83 c4 10             	add    $0x10,%esp
  80140a:	85 c0                	test   %eax,%eax
  80140c:	79 15                	jns    801423 <fork_v0+0xcc>

		panic("sys_env_set_status: %e", result);
  80140e:	50                   	push   %eax
  80140f:	68 f9 30 80 00       	push   $0x8030f9
  801414:	68 90 00 00 00       	push   $0x90
  801419:	68 20 30 80 00       	push   $0x803020
  80141e:	e8 cf f0 ff ff       	call   8004f2 <_panic>
	}
	return envid;
  801423:	89 f0                	mov    %esi,%eax
}
  801425:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801428:	5b                   	pop    %ebx
  801429:	5e                   	pop    %esi
  80142a:	5f                   	pop    %edi
  80142b:	5d                   	pop    %ebp
  80142c:	c3                   	ret    

0080142d <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
  801430:	57                   	push   %edi
  801431:	56                   	push   %esi
  801432:	53                   	push   %ebx
  801433:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801436:	68 5d 12 80 00       	push   $0x80125d
  80143b:	e8 d9 12 00 00       	call   802719 <set_pgfault_handler>
  801440:	b8 07 00 00 00       	mov    $0x7,%eax
  801445:	cd 30                	int    $0x30
  801447:	89 c6                	mov    %eax,%esi

	envid_t envid;
	uint32_t va;
	envid = sys_exofork();
	if (envid < 0){
  801449:	83 c4 10             	add    $0x10,%esp
  80144c:	85 c0                	test   %eax,%eax
  80144e:	79 15                	jns    801465 <fork+0x38>
		panic("sys_exofork: %e", envid);
  801450:	50                   	push   %eax
  801451:	68 e9 30 80 00       	push   $0x8030e9
  801456:	68 b1 00 00 00       	push   $0xb1
  80145b:	68 20 30 80 00       	push   $0x803020
  801460:	e8 8d f0 ff ff       	call   8004f2 <_panic>
  801465:	89 c7                	mov    %eax,%edi
  801467:	bb 00 00 00 00       	mov    $0x0,%ebx
	}
	if (envid == 0) {		
  80146c:	85 c0                	test   %eax,%eax
  80146e:	75 21                	jne    801491 <fork+0x64>
		thisenv = &envs[ENVX(sys_getenvid())];
  801470:	e8 c6 fa ff ff       	call   800f3b <sys_getenvid>
  801475:	25 ff 03 00 00       	and    $0x3ff,%eax
  80147a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80147d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801482:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  801487:	b8 00 00 00 00       	mov    $0x0,%eax
  80148c:	e9 a7 00 00 00       	jmp    801538 <fork+0x10b>
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
		if ((uvpd[PDX(va)] & PTE_P)){
  801491:	89 d8                	mov    %ebx,%eax
  801493:	c1 e8 16             	shr    $0x16,%eax
  801496:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80149d:	a8 01                	test   $0x1,%al
  80149f:	74 22                	je     8014c3 <fork+0x96>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
  8014a1:	89 da                	mov    %ebx,%edx
  8014a3:	c1 ea 0c             	shr    $0xc,%edx
  8014a6:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014ad:	a8 01                	test   $0x1,%al
  8014af:	74 12                	je     8014c3 <fork+0x96>
  8014b1:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014b8:	a8 04                	test   $0x4,%al
  8014ba:	74 07                	je     8014c3 <fork+0x96>
				duppage(envid, PGNUM(va));			
  8014bc:	89 f8                	mov    %edi,%eax
  8014be:	e8 e0 fb ff ff       	call   8010a3 <duppage>
	if (envid == 0) {		
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}	

	for (va = 0; va <(uint32_t) USTACKTOP; va += PGSIZE){
  8014c3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014c9:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8014cf:	75 c0                	jne    801491 <fork+0x64>
			if((uvpt[PGNUM(va)] & PTE_P)&&(uvpt[PGNUM(va)] & PTE_U)) {	
				duppage(envid, PGNUM(va));			
			}
		}
	}
	if (sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P) < 0){
  8014d1:	83 ec 04             	sub    $0x4,%esp
  8014d4:	6a 07                	push   $0x7
  8014d6:	68 00 f0 bf ee       	push   $0xeebff000
  8014db:	56                   	push   %esi
  8014dc:	e8 a5 fa ff ff       	call   800f86 <sys_page_alloc>
  8014e1:	83 c4 10             	add    $0x10,%esp
  8014e4:	85 c0                	test   %eax,%eax
  8014e6:	79 17                	jns    8014ff <fork+0xd2>
		panic("Se escribio en la pagina de excepciones");
  8014e8:	83 ec 04             	sub    $0x4,%esp
  8014eb:	68 28 31 80 00       	push   $0x803128
  8014f0:	68 c0 00 00 00       	push   $0xc0
  8014f5:	68 20 30 80 00       	push   $0x803020
  8014fa:	e8 f3 ef ff ff       	call   8004f2 <_panic>
	}	
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8014ff:	83 ec 08             	sub    $0x8,%esp
  801502:	68 88 27 80 00       	push   $0x802788
  801507:	56                   	push   %esi
  801508:	e8 2c fb ff ff       	call   801039 <sys_env_set_pgfault_upcall>

	if (sys_env_set_status(envid, ENV_RUNNABLE) < 0)
  80150d:	83 c4 08             	add    $0x8,%esp
  801510:	6a 02                	push   $0x2
  801512:	56                   	push   %esi
  801513:	e8 db fa ff ff       	call   800ff3 <sys_env_set_status>
  801518:	83 c4 10             	add    $0x10,%esp
  80151b:	85 c0                	test   %eax,%eax
  80151d:	79 17                	jns    801536 <fork+0x109>
		panic("Status incorrecto de enviroment");
  80151f:	83 ec 04             	sub    $0x4,%esp
  801522:	68 50 31 80 00       	push   $0x803150
  801527:	68 c5 00 00 00       	push   $0xc5
  80152c:	68 20 30 80 00       	push   $0x803020
  801531:	e8 bc ef ff ff       	call   8004f2 <_panic>

	return envid;
  801536:	89 f0                	mov    %esi,%eax
	
}
  801538:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80153b:	5b                   	pop    %ebx
  80153c:	5e                   	pop    %esi
  80153d:	5f                   	pop    %edi
  80153e:	5d                   	pop    %ebp
  80153f:	c3                   	ret    

00801540 <sfork>:


// Challenge!
int
sfork(void)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
  801543:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801546:	68 10 31 80 00       	push   $0x803110
  80154b:	68 d1 00 00 00       	push   $0xd1
  801550:	68 20 30 80 00       	push   $0x803020
  801555:	e8 98 ef ff ff       	call   8004f2 <_panic>

0080155a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80155a:	55                   	push   %ebp
  80155b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	05 00 00 00 30       	add    $0x30000000,%eax
  801565:	c1 e8 0c             	shr    $0xc,%eax
}
  801568:	5d                   	pop    %ebp
  801569:	c3                   	ret    

0080156a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  80156d:	ff 75 08             	pushl  0x8(%ebp)
  801570:	e8 e5 ff ff ff       	call   80155a <fd2num>
  801575:	83 c4 04             	add    $0x4,%esp
  801578:	c1 e0 0c             	shl    $0xc,%eax
  80157b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801580:	c9                   	leave  
  801581:	c3                   	ret    

00801582 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801588:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80158d:	89 c2                	mov    %eax,%edx
  80158f:	c1 ea 16             	shr    $0x16,%edx
  801592:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801599:	f6 c2 01             	test   $0x1,%dl
  80159c:	74 11                	je     8015af <fd_alloc+0x2d>
  80159e:	89 c2                	mov    %eax,%edx
  8015a0:	c1 ea 0c             	shr    $0xc,%edx
  8015a3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015aa:	f6 c2 01             	test   $0x1,%dl
  8015ad:	75 09                	jne    8015b8 <fd_alloc+0x36>
			*fd_store = fd;
  8015af:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b6:	eb 17                	jmp    8015cf <fd_alloc+0x4d>
  8015b8:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8015bd:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015c2:	75 c9                	jne    80158d <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015c4:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8015ca:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8015cf:	5d                   	pop    %ebp
  8015d0:	c3                   	ret    

008015d1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015d7:	83 f8 1f             	cmp    $0x1f,%eax
  8015da:	77 36                	ja     801612 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015dc:	c1 e0 0c             	shl    $0xc,%eax
  8015df:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015e4:	89 c2                	mov    %eax,%edx
  8015e6:	c1 ea 16             	shr    $0x16,%edx
  8015e9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015f0:	f6 c2 01             	test   $0x1,%dl
  8015f3:	74 24                	je     801619 <fd_lookup+0x48>
  8015f5:	89 c2                	mov    %eax,%edx
  8015f7:	c1 ea 0c             	shr    $0xc,%edx
  8015fa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801601:	f6 c2 01             	test   $0x1,%dl
  801604:	74 1a                	je     801620 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801606:	8b 55 0c             	mov    0xc(%ebp),%edx
  801609:	89 02                	mov    %eax,(%edx)
	return 0;
  80160b:	b8 00 00 00 00       	mov    $0x0,%eax
  801610:	eb 13                	jmp    801625 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801612:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801617:	eb 0c                	jmp    801625 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801619:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80161e:	eb 05                	jmp    801625 <fd_lookup+0x54>
  801620:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  801625:	5d                   	pop    %ebp
  801626:	c3                   	ret    

00801627 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	83 ec 08             	sub    $0x8,%esp
  80162d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801630:	ba ec 31 80 00       	mov    $0x8031ec,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801635:	eb 13                	jmp    80164a <dev_lookup+0x23>
  801637:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  80163a:	39 08                	cmp    %ecx,(%eax)
  80163c:	75 0c                	jne    80164a <dev_lookup+0x23>
			*dev = devtab[i];
  80163e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801641:	89 01                	mov    %eax,(%ecx)
			return 0;
  801643:	b8 00 00 00 00       	mov    $0x0,%eax
  801648:	eb 2e                	jmp    801678 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80164a:	8b 02                	mov    (%edx),%eax
  80164c:	85 c0                	test   %eax,%eax
  80164e:	75 e7                	jne    801637 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801650:	a1 04 50 80 00       	mov    0x805004,%eax
  801655:	8b 40 48             	mov    0x48(%eax),%eax
  801658:	83 ec 04             	sub    $0x4,%esp
  80165b:	51                   	push   %ecx
  80165c:	50                   	push   %eax
  80165d:	68 70 31 80 00       	push   $0x803170
  801662:	e8 64 ef ff ff       	call   8005cb <cprintf>
	*dev = 0;
  801667:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801670:	83 c4 10             	add    $0x10,%esp
  801673:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	56                   	push   %esi
  80167e:	53                   	push   %ebx
  80167f:	83 ec 10             	sub    $0x10,%esp
  801682:	8b 75 08             	mov    0x8(%ebp),%esi
  801685:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801688:	56                   	push   %esi
  801689:	e8 cc fe ff ff       	call   80155a <fd2num>
  80168e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801691:	89 14 24             	mov    %edx,(%esp)
  801694:	50                   	push   %eax
  801695:	e8 37 ff ff ff       	call   8015d1 <fd_lookup>
  80169a:	83 c4 08             	add    $0x8,%esp
  80169d:	85 c0                	test   %eax,%eax
  80169f:	78 05                	js     8016a6 <fd_close+0x2c>
	    || fd != fd2)
  8016a1:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8016a4:	74 0c                	je     8016b2 <fd_close+0x38>
		return (must_exist ? r : 0);
  8016a6:	84 db                	test   %bl,%bl
  8016a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ad:	0f 44 c2             	cmove  %edx,%eax
  8016b0:	eb 41                	jmp    8016f3 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016b2:	83 ec 08             	sub    $0x8,%esp
  8016b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b8:	50                   	push   %eax
  8016b9:	ff 36                	pushl  (%esi)
  8016bb:	e8 67 ff ff ff       	call   801627 <dev_lookup>
  8016c0:	89 c3                	mov    %eax,%ebx
  8016c2:	83 c4 10             	add    $0x10,%esp
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	78 1a                	js     8016e3 <fd_close+0x69>
		if (dev->dev_close)
  8016c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cc:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8016cf:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8016d4:	85 c0                	test   %eax,%eax
  8016d6:	74 0b                	je     8016e3 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  8016d8:	83 ec 0c             	sub    $0xc,%esp
  8016db:	56                   	push   %esi
  8016dc:	ff d0                	call   *%eax
  8016de:	89 c3                	mov    %eax,%ebx
  8016e0:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8016e3:	83 ec 08             	sub    $0x8,%esp
  8016e6:	56                   	push   %esi
  8016e7:	6a 00                	push   $0x0
  8016e9:	e8 e2 f8 ff ff       	call   800fd0 <sys_page_unmap>
	return r;
  8016ee:	83 c4 10             	add    $0x10,%esp
  8016f1:	89 d8                	mov    %ebx,%eax
}
  8016f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f6:	5b                   	pop    %ebx
  8016f7:	5e                   	pop    %esi
  8016f8:	5d                   	pop    %ebp
  8016f9:	c3                   	ret    

008016fa <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801700:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801703:	50                   	push   %eax
  801704:	ff 75 08             	pushl  0x8(%ebp)
  801707:	e8 c5 fe ff ff       	call   8015d1 <fd_lookup>
  80170c:	83 c4 08             	add    $0x8,%esp
  80170f:	85 c0                	test   %eax,%eax
  801711:	78 10                	js     801723 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801713:	83 ec 08             	sub    $0x8,%esp
  801716:	6a 01                	push   $0x1
  801718:	ff 75 f4             	pushl  -0xc(%ebp)
  80171b:	e8 5a ff ff ff       	call   80167a <fd_close>
  801720:	83 c4 10             	add    $0x10,%esp
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <close_all>:

void
close_all(void)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	53                   	push   %ebx
  801729:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80172c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801731:	83 ec 0c             	sub    $0xc,%esp
  801734:	53                   	push   %ebx
  801735:	e8 c0 ff ff ff       	call   8016fa <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80173a:	83 c3 01             	add    $0x1,%ebx
  80173d:	83 c4 10             	add    $0x10,%esp
  801740:	83 fb 20             	cmp    $0x20,%ebx
  801743:	75 ec                	jne    801731 <close_all+0xc>
		close(i);
}
  801745:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	57                   	push   %edi
  80174e:	56                   	push   %esi
  80174f:	53                   	push   %ebx
  801750:	83 ec 2c             	sub    $0x2c,%esp
  801753:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801756:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801759:	50                   	push   %eax
  80175a:	ff 75 08             	pushl  0x8(%ebp)
  80175d:	e8 6f fe ff ff       	call   8015d1 <fd_lookup>
  801762:	83 c4 08             	add    $0x8,%esp
  801765:	85 c0                	test   %eax,%eax
  801767:	0f 88 c1 00 00 00    	js     80182e <dup+0xe4>
		return r;
	close(newfdnum);
  80176d:	83 ec 0c             	sub    $0xc,%esp
  801770:	56                   	push   %esi
  801771:	e8 84 ff ff ff       	call   8016fa <close>

	newfd = INDEX2FD(newfdnum);
  801776:	89 f3                	mov    %esi,%ebx
  801778:	c1 e3 0c             	shl    $0xc,%ebx
  80177b:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801781:	83 c4 04             	add    $0x4,%esp
  801784:	ff 75 e4             	pushl  -0x1c(%ebp)
  801787:	e8 de fd ff ff       	call   80156a <fd2data>
  80178c:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  80178e:	89 1c 24             	mov    %ebx,(%esp)
  801791:	e8 d4 fd ff ff       	call   80156a <fd2data>
  801796:	83 c4 10             	add    $0x10,%esp
  801799:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80179c:	89 f8                	mov    %edi,%eax
  80179e:	c1 e8 16             	shr    $0x16,%eax
  8017a1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017a8:	a8 01                	test   $0x1,%al
  8017aa:	74 37                	je     8017e3 <dup+0x99>
  8017ac:	89 f8                	mov    %edi,%eax
  8017ae:	c1 e8 0c             	shr    $0xc,%eax
  8017b1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017b8:	f6 c2 01             	test   $0x1,%dl
  8017bb:	74 26                	je     8017e3 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017bd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017c4:	83 ec 0c             	sub    $0xc,%esp
  8017c7:	25 07 0e 00 00       	and    $0xe07,%eax
  8017cc:	50                   	push   %eax
  8017cd:	ff 75 d4             	pushl  -0x2c(%ebp)
  8017d0:	6a 00                	push   $0x0
  8017d2:	57                   	push   %edi
  8017d3:	6a 00                	push   $0x0
  8017d5:	e8 d0 f7 ff ff       	call   800faa <sys_page_map>
  8017da:	89 c7                	mov    %eax,%edi
  8017dc:	83 c4 20             	add    $0x20,%esp
  8017df:	85 c0                	test   %eax,%eax
  8017e1:	78 2e                	js     801811 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017e6:	89 d0                	mov    %edx,%eax
  8017e8:	c1 e8 0c             	shr    $0xc,%eax
  8017eb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017f2:	83 ec 0c             	sub    $0xc,%esp
  8017f5:	25 07 0e 00 00       	and    $0xe07,%eax
  8017fa:	50                   	push   %eax
  8017fb:	53                   	push   %ebx
  8017fc:	6a 00                	push   $0x0
  8017fe:	52                   	push   %edx
  8017ff:	6a 00                	push   $0x0
  801801:	e8 a4 f7 ff ff       	call   800faa <sys_page_map>
  801806:	89 c7                	mov    %eax,%edi
  801808:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  80180b:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80180d:	85 ff                	test   %edi,%edi
  80180f:	79 1d                	jns    80182e <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801811:	83 ec 08             	sub    $0x8,%esp
  801814:	53                   	push   %ebx
  801815:	6a 00                	push   $0x0
  801817:	e8 b4 f7 ff ff       	call   800fd0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80181c:	83 c4 08             	add    $0x8,%esp
  80181f:	ff 75 d4             	pushl  -0x2c(%ebp)
  801822:	6a 00                	push   $0x0
  801824:	e8 a7 f7 ff ff       	call   800fd0 <sys_page_unmap>
	return r;
  801829:	83 c4 10             	add    $0x10,%esp
  80182c:	89 f8                	mov    %edi,%eax
}
  80182e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801831:	5b                   	pop    %ebx
  801832:	5e                   	pop    %esi
  801833:	5f                   	pop    %edi
  801834:	5d                   	pop    %ebp
  801835:	c3                   	ret    

00801836 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	53                   	push   %ebx
  80183a:	83 ec 14             	sub    $0x14,%esp
  80183d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801840:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801843:	50                   	push   %eax
  801844:	53                   	push   %ebx
  801845:	e8 87 fd ff ff       	call   8015d1 <fd_lookup>
  80184a:	83 c4 08             	add    $0x8,%esp
  80184d:	89 c2                	mov    %eax,%edx
  80184f:	85 c0                	test   %eax,%eax
  801851:	78 6d                	js     8018c0 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801853:	83 ec 08             	sub    $0x8,%esp
  801856:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801859:	50                   	push   %eax
  80185a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185d:	ff 30                	pushl  (%eax)
  80185f:	e8 c3 fd ff ff       	call   801627 <dev_lookup>
  801864:	83 c4 10             	add    $0x10,%esp
  801867:	85 c0                	test   %eax,%eax
  801869:	78 4c                	js     8018b7 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80186b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80186e:	8b 42 08             	mov    0x8(%edx),%eax
  801871:	83 e0 03             	and    $0x3,%eax
  801874:	83 f8 01             	cmp    $0x1,%eax
  801877:	75 21                	jne    80189a <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801879:	a1 04 50 80 00       	mov    0x805004,%eax
  80187e:	8b 40 48             	mov    0x48(%eax),%eax
  801881:	83 ec 04             	sub    $0x4,%esp
  801884:	53                   	push   %ebx
  801885:	50                   	push   %eax
  801886:	68 b1 31 80 00       	push   $0x8031b1
  80188b:	e8 3b ed ff ff       	call   8005cb <cprintf>
		return -E_INVAL;
  801890:	83 c4 10             	add    $0x10,%esp
  801893:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801898:	eb 26                	jmp    8018c0 <read+0x8a>
	}
	if (!dev->dev_read)
  80189a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189d:	8b 40 08             	mov    0x8(%eax),%eax
  8018a0:	85 c0                	test   %eax,%eax
  8018a2:	74 17                	je     8018bb <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018a4:	83 ec 04             	sub    $0x4,%esp
  8018a7:	ff 75 10             	pushl  0x10(%ebp)
  8018aa:	ff 75 0c             	pushl  0xc(%ebp)
  8018ad:	52                   	push   %edx
  8018ae:	ff d0                	call   *%eax
  8018b0:	89 c2                	mov    %eax,%edx
  8018b2:	83 c4 10             	add    $0x10,%esp
  8018b5:	eb 09                	jmp    8018c0 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018b7:	89 c2                	mov    %eax,%edx
  8018b9:	eb 05                	jmp    8018c0 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8018bb:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  8018c0:	89 d0                	mov    %edx,%eax
  8018c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	57                   	push   %edi
  8018cb:	56                   	push   %esi
  8018cc:	53                   	push   %ebx
  8018cd:	83 ec 0c             	sub    $0xc,%esp
  8018d0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018d3:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018d6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018db:	eb 21                	jmp    8018fe <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018dd:	83 ec 04             	sub    $0x4,%esp
  8018e0:	89 f0                	mov    %esi,%eax
  8018e2:	29 d8                	sub    %ebx,%eax
  8018e4:	50                   	push   %eax
  8018e5:	89 d8                	mov    %ebx,%eax
  8018e7:	03 45 0c             	add    0xc(%ebp),%eax
  8018ea:	50                   	push   %eax
  8018eb:	57                   	push   %edi
  8018ec:	e8 45 ff ff ff       	call   801836 <read>
		if (m < 0)
  8018f1:	83 c4 10             	add    $0x10,%esp
  8018f4:	85 c0                	test   %eax,%eax
  8018f6:	78 10                	js     801908 <readn+0x41>
			return m;
		if (m == 0)
  8018f8:	85 c0                	test   %eax,%eax
  8018fa:	74 0a                	je     801906 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018fc:	01 c3                	add    %eax,%ebx
  8018fe:	39 f3                	cmp    %esi,%ebx
  801900:	72 db                	jb     8018dd <readn+0x16>
  801902:	89 d8                	mov    %ebx,%eax
  801904:	eb 02                	jmp    801908 <readn+0x41>
  801906:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801908:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80190b:	5b                   	pop    %ebx
  80190c:	5e                   	pop    %esi
  80190d:	5f                   	pop    %edi
  80190e:	5d                   	pop    %ebp
  80190f:	c3                   	ret    

00801910 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
  801913:	53                   	push   %ebx
  801914:	83 ec 14             	sub    $0x14,%esp
  801917:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80191a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80191d:	50                   	push   %eax
  80191e:	53                   	push   %ebx
  80191f:	e8 ad fc ff ff       	call   8015d1 <fd_lookup>
  801924:	83 c4 08             	add    $0x8,%esp
  801927:	89 c2                	mov    %eax,%edx
  801929:	85 c0                	test   %eax,%eax
  80192b:	78 68                	js     801995 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80192d:	83 ec 08             	sub    $0x8,%esp
  801930:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801933:	50                   	push   %eax
  801934:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801937:	ff 30                	pushl  (%eax)
  801939:	e8 e9 fc ff ff       	call   801627 <dev_lookup>
  80193e:	83 c4 10             	add    $0x10,%esp
  801941:	85 c0                	test   %eax,%eax
  801943:	78 47                	js     80198c <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801945:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801948:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80194c:	75 21                	jne    80196f <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80194e:	a1 04 50 80 00       	mov    0x805004,%eax
  801953:	8b 40 48             	mov    0x48(%eax),%eax
  801956:	83 ec 04             	sub    $0x4,%esp
  801959:	53                   	push   %ebx
  80195a:	50                   	push   %eax
  80195b:	68 cd 31 80 00       	push   $0x8031cd
  801960:	e8 66 ec ff ff       	call   8005cb <cprintf>
		return -E_INVAL;
  801965:	83 c4 10             	add    $0x10,%esp
  801968:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80196d:	eb 26                	jmp    801995 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80196f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801972:	8b 52 0c             	mov    0xc(%edx),%edx
  801975:	85 d2                	test   %edx,%edx
  801977:	74 17                	je     801990 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801979:	83 ec 04             	sub    $0x4,%esp
  80197c:	ff 75 10             	pushl  0x10(%ebp)
  80197f:	ff 75 0c             	pushl  0xc(%ebp)
  801982:	50                   	push   %eax
  801983:	ff d2                	call   *%edx
  801985:	89 c2                	mov    %eax,%edx
  801987:	83 c4 10             	add    $0x10,%esp
  80198a:	eb 09                	jmp    801995 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80198c:	89 c2                	mov    %eax,%edx
  80198e:	eb 05                	jmp    801995 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801990:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  801995:	89 d0                	mov    %edx,%eax
  801997:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <seek>:

int
seek(int fdnum, off_t offset)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019a2:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8019a5:	50                   	push   %eax
  8019a6:	ff 75 08             	pushl  0x8(%ebp)
  8019a9:	e8 23 fc ff ff       	call   8015d1 <fd_lookup>
  8019ae:	83 c4 08             	add    $0x8,%esp
  8019b1:	85 c0                	test   %eax,%eax
  8019b3:	78 0e                	js     8019c3 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8019b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
  8019c8:	53                   	push   %ebx
  8019c9:	83 ec 14             	sub    $0x14,%esp
  8019cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019d2:	50                   	push   %eax
  8019d3:	53                   	push   %ebx
  8019d4:	e8 f8 fb ff ff       	call   8015d1 <fd_lookup>
  8019d9:	83 c4 08             	add    $0x8,%esp
  8019dc:	89 c2                	mov    %eax,%edx
  8019de:	85 c0                	test   %eax,%eax
  8019e0:	78 65                	js     801a47 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019e2:	83 ec 08             	sub    $0x8,%esp
  8019e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019e8:	50                   	push   %eax
  8019e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ec:	ff 30                	pushl  (%eax)
  8019ee:	e8 34 fc ff ff       	call   801627 <dev_lookup>
  8019f3:	83 c4 10             	add    $0x10,%esp
  8019f6:	85 c0                	test   %eax,%eax
  8019f8:	78 44                	js     801a3e <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a01:	75 21                	jne    801a24 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801a03:	a1 04 50 80 00       	mov    0x805004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a08:	8b 40 48             	mov    0x48(%eax),%eax
  801a0b:	83 ec 04             	sub    $0x4,%esp
  801a0e:	53                   	push   %ebx
  801a0f:	50                   	push   %eax
  801a10:	68 90 31 80 00       	push   $0x803190
  801a15:	e8 b1 eb ff ff       	call   8005cb <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801a1a:	83 c4 10             	add    $0x10,%esp
  801a1d:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801a22:	eb 23                	jmp    801a47 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  801a24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a27:	8b 52 18             	mov    0x18(%edx),%edx
  801a2a:	85 d2                	test   %edx,%edx
  801a2c:	74 14                	je     801a42 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a2e:	83 ec 08             	sub    $0x8,%esp
  801a31:	ff 75 0c             	pushl  0xc(%ebp)
  801a34:	50                   	push   %eax
  801a35:	ff d2                	call   *%edx
  801a37:	89 c2                	mov    %eax,%edx
  801a39:	83 c4 10             	add    $0x10,%esp
  801a3c:	eb 09                	jmp    801a47 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a3e:	89 c2                	mov    %eax,%edx
  801a40:	eb 05                	jmp    801a47 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801a42:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  801a47:	89 d0                	mov    %edx,%eax
  801a49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
  801a51:	53                   	push   %ebx
  801a52:	83 ec 14             	sub    $0x14,%esp
  801a55:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a58:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a5b:	50                   	push   %eax
  801a5c:	ff 75 08             	pushl  0x8(%ebp)
  801a5f:	e8 6d fb ff ff       	call   8015d1 <fd_lookup>
  801a64:	83 c4 08             	add    $0x8,%esp
  801a67:	89 c2                	mov    %eax,%edx
  801a69:	85 c0                	test   %eax,%eax
  801a6b:	78 58                	js     801ac5 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a6d:	83 ec 08             	sub    $0x8,%esp
  801a70:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a73:	50                   	push   %eax
  801a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a77:	ff 30                	pushl  (%eax)
  801a79:	e8 a9 fb ff ff       	call   801627 <dev_lookup>
  801a7e:	83 c4 10             	add    $0x10,%esp
  801a81:	85 c0                	test   %eax,%eax
  801a83:	78 37                	js     801abc <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  801a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a88:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a8c:	74 32                	je     801ac0 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a8e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a91:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a98:	00 00 00 
	stat->st_isdir = 0;
  801a9b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801aa2:	00 00 00 
	stat->st_dev = dev;
  801aa5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801aab:	83 ec 08             	sub    $0x8,%esp
  801aae:	53                   	push   %ebx
  801aaf:	ff 75 f0             	pushl  -0x10(%ebp)
  801ab2:	ff 50 14             	call   *0x14(%eax)
  801ab5:	89 c2                	mov    %eax,%edx
  801ab7:	83 c4 10             	add    $0x10,%esp
  801aba:	eb 09                	jmp    801ac5 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801abc:	89 c2                	mov    %eax,%edx
  801abe:	eb 05                	jmp    801ac5 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801ac0:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801ac5:	89 d0                	mov    %edx,%eax
  801ac7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	56                   	push   %esi
  801ad0:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801ad1:	83 ec 08             	sub    $0x8,%esp
  801ad4:	6a 00                	push   $0x0
  801ad6:	ff 75 08             	pushl  0x8(%ebp)
  801ad9:	e8 06 02 00 00       	call   801ce4 <open>
  801ade:	89 c3                	mov    %eax,%ebx
  801ae0:	83 c4 10             	add    $0x10,%esp
  801ae3:	85 c0                	test   %eax,%eax
  801ae5:	78 1b                	js     801b02 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801ae7:	83 ec 08             	sub    $0x8,%esp
  801aea:	ff 75 0c             	pushl  0xc(%ebp)
  801aed:	50                   	push   %eax
  801aee:	e8 5b ff ff ff       	call   801a4e <fstat>
  801af3:	89 c6                	mov    %eax,%esi
	close(fd);
  801af5:	89 1c 24             	mov    %ebx,(%esp)
  801af8:	e8 fd fb ff ff       	call   8016fa <close>
	return r;
  801afd:	83 c4 10             	add    $0x10,%esp
  801b00:	89 f0                	mov    %esi,%eax
}
  801b02:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b05:	5b                   	pop    %ebx
  801b06:	5e                   	pop    %esi
  801b07:	5d                   	pop    %ebp
  801b08:	c3                   	ret    

00801b09 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	56                   	push   %esi
  801b0d:	53                   	push   %ebx
  801b0e:	89 c6                	mov    %eax,%esi
  801b10:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b12:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b19:	75 12                	jne    801b2d <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b1b:	83 ec 0c             	sub    $0xc,%esp
  801b1e:	6a 01                	push   $0x1
  801b20:	e8 46 0d 00 00       	call   80286b <ipc_find_env>
  801b25:	a3 00 50 80 00       	mov    %eax,0x805000
  801b2a:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b2d:	6a 07                	push   $0x7
  801b2f:	68 00 60 80 00       	push   $0x806000
  801b34:	56                   	push   %esi
  801b35:	ff 35 00 50 80 00    	pushl  0x805000
  801b3b:	e8 d7 0c 00 00       	call   802817 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b40:	83 c4 0c             	add    $0xc,%esp
  801b43:	6a 00                	push   $0x0
  801b45:	53                   	push   %ebx
  801b46:	6a 00                	push   $0x0
  801b48:	e8 5f 0c 00 00       	call   8027ac <ipc_recv>
}
  801b4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b50:	5b                   	pop    %ebx
  801b51:	5e                   	pop    %esi
  801b52:	5d                   	pop    %ebp
  801b53:	c3                   	ret    

00801b54 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5d:	8b 40 0c             	mov    0xc(%eax),%eax
  801b60:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b68:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b6d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b72:	b8 02 00 00 00       	mov    $0x2,%eax
  801b77:	e8 8d ff ff ff       	call   801b09 <fsipc>
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b84:	8b 45 08             	mov    0x8(%ebp),%eax
  801b87:	8b 40 0c             	mov    0xc(%eax),%eax
  801b8a:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b8f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b94:	b8 06 00 00 00       	mov    $0x6,%eax
  801b99:	e8 6b ff ff ff       	call   801b09 <fsipc>
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	53                   	push   %ebx
  801ba4:	83 ec 04             	sub    $0x4,%esp
  801ba7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb0:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bb5:	ba 00 00 00 00       	mov    $0x0,%edx
  801bba:	b8 05 00 00 00       	mov    $0x5,%eax
  801bbf:	e8 45 ff ff ff       	call   801b09 <fsipc>
  801bc4:	85 c0                	test   %eax,%eax
  801bc6:	78 2c                	js     801bf4 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bc8:	83 ec 08             	sub    $0x8,%esp
  801bcb:	68 00 60 80 00       	push   $0x806000
  801bd0:	53                   	push   %ebx
  801bd1:	e8 67 ef ff ff       	call   800b3d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bd6:	a1 80 60 80 00       	mov    0x806080,%eax
  801bdb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801be1:	a1 84 60 80 00       	mov    0x806084,%eax
  801be6:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801bec:	83 c4 10             	add    $0x10,%esp
  801bef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
  801bfc:	83 ec 08             	sub    $0x8,%esp
  801bff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c02:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c08:	8b 49 0c             	mov    0xc(%ecx),%ecx
  801c0b:	89 0d 00 60 80 00    	mov    %ecx,0x806000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  801c11:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801c16:	76 22                	jbe    801c3a <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  801c18:	c7 05 04 60 80 00 f8 	movl   $0xff8,0x806004
  801c1f:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  801c22:	83 ec 04             	sub    $0x4,%esp
  801c25:	68 f8 0f 00 00       	push   $0xff8
  801c2a:	52                   	push   %edx
  801c2b:	68 08 60 80 00       	push   $0x806008
  801c30:	e8 9b f0 ff ff       	call   800cd0 <memmove>
  801c35:	83 c4 10             	add    $0x10,%esp
  801c38:	eb 17                	jmp    801c51 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  801c3a:	a3 04 60 80 00       	mov    %eax,0x806004
		memmove(fsipcbuf.write.req_buf, buf, n);
  801c3f:	83 ec 04             	sub    $0x4,%esp
  801c42:	50                   	push   %eax
  801c43:	52                   	push   %edx
  801c44:	68 08 60 80 00       	push   $0x806008
  801c49:	e8 82 f0 ff ff       	call   800cd0 <memmove>
  801c4e:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  801c51:	ba 00 00 00 00       	mov    $0x0,%edx
  801c56:	b8 04 00 00 00       	mov    $0x4,%eax
  801c5b:	e8 a9 fe ff ff       	call   801b09 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	56                   	push   %esi
  801c66:	53                   	push   %ebx
  801c67:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	8b 40 0c             	mov    0xc(%eax),%eax
  801c70:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c75:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c7b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c80:	b8 03 00 00 00       	mov    $0x3,%eax
  801c85:	e8 7f fe ff ff       	call   801b09 <fsipc>
  801c8a:	89 c3                	mov    %eax,%ebx
  801c8c:	85 c0                	test   %eax,%eax
  801c8e:	78 4b                	js     801cdb <devfile_read+0x79>
		return r;
	assert(r <= n);
  801c90:	39 c6                	cmp    %eax,%esi
  801c92:	73 16                	jae    801caa <devfile_read+0x48>
  801c94:	68 fc 31 80 00       	push   $0x8031fc
  801c99:	68 03 32 80 00       	push   $0x803203
  801c9e:	6a 7c                	push   $0x7c
  801ca0:	68 18 32 80 00       	push   $0x803218
  801ca5:	e8 48 e8 ff ff       	call   8004f2 <_panic>
	assert(r <= PGSIZE);
  801caa:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801caf:	7e 16                	jle    801cc7 <devfile_read+0x65>
  801cb1:	68 23 32 80 00       	push   $0x803223
  801cb6:	68 03 32 80 00       	push   $0x803203
  801cbb:	6a 7d                	push   $0x7d
  801cbd:	68 18 32 80 00       	push   $0x803218
  801cc2:	e8 2b e8 ff ff       	call   8004f2 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801cc7:	83 ec 04             	sub    $0x4,%esp
  801cca:	50                   	push   %eax
  801ccb:	68 00 60 80 00       	push   $0x806000
  801cd0:	ff 75 0c             	pushl  0xc(%ebp)
  801cd3:	e8 f8 ef ff ff       	call   800cd0 <memmove>
	return r;
  801cd8:	83 c4 10             	add    $0x10,%esp
}
  801cdb:	89 d8                	mov    %ebx,%eax
  801cdd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ce0:	5b                   	pop    %ebx
  801ce1:	5e                   	pop    %esi
  801ce2:	5d                   	pop    %ebp
  801ce3:	c3                   	ret    

00801ce4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
  801ce7:	53                   	push   %ebx
  801ce8:	83 ec 20             	sub    $0x20,%esp
  801ceb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801cee:	53                   	push   %ebx
  801cef:	e8 10 ee ff ff       	call   800b04 <strlen>
  801cf4:	83 c4 10             	add    $0x10,%esp
  801cf7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801cfc:	7f 67                	jg     801d65 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801cfe:	83 ec 0c             	sub    $0xc,%esp
  801d01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d04:	50                   	push   %eax
  801d05:	e8 78 f8 ff ff       	call   801582 <fd_alloc>
  801d0a:	83 c4 10             	add    $0x10,%esp
		return r;
  801d0d:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801d0f:	85 c0                	test   %eax,%eax
  801d11:	78 57                	js     801d6a <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801d13:	83 ec 08             	sub    $0x8,%esp
  801d16:	53                   	push   %ebx
  801d17:	68 00 60 80 00       	push   $0x806000
  801d1c:	e8 1c ee ff ff       	call   800b3d <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d24:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d2c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d31:	e8 d3 fd ff ff       	call   801b09 <fsipc>
  801d36:	89 c3                	mov    %eax,%ebx
  801d38:	83 c4 10             	add    $0x10,%esp
  801d3b:	85 c0                	test   %eax,%eax
  801d3d:	79 14                	jns    801d53 <open+0x6f>
		fd_close(fd, 0);
  801d3f:	83 ec 08             	sub    $0x8,%esp
  801d42:	6a 00                	push   $0x0
  801d44:	ff 75 f4             	pushl  -0xc(%ebp)
  801d47:	e8 2e f9 ff ff       	call   80167a <fd_close>
		return r;
  801d4c:	83 c4 10             	add    $0x10,%esp
  801d4f:	89 da                	mov    %ebx,%edx
  801d51:	eb 17                	jmp    801d6a <open+0x86>
	}

	return fd2num(fd);
  801d53:	83 ec 0c             	sub    $0xc,%esp
  801d56:	ff 75 f4             	pushl  -0xc(%ebp)
  801d59:	e8 fc f7 ff ff       	call   80155a <fd2num>
  801d5e:	89 c2                	mov    %eax,%edx
  801d60:	83 c4 10             	add    $0x10,%esp
  801d63:	eb 05                	jmp    801d6a <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801d65:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801d6a:	89 d0                	mov    %edx,%eax
  801d6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d77:	ba 00 00 00 00       	mov    $0x0,%edx
  801d7c:	b8 08 00 00 00       	mov    $0x8,%eax
  801d81:	e8 83 fd ff ff       	call   801b09 <fsipc>
}
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <copy_shared_pages>:
}

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
  801d8b:	57                   	push   %edi
  801d8c:	56                   	push   %esi
  801d8d:	53                   	push   %ebx
  801d8e:	83 ec 1c             	sub    $0x1c,%esp
  801d91:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d94:	bf 00 04 00 00       	mov    $0x400,%edi
	// LAB 5: Your code here.
	unsigned int pn;
	void* addr;
  	for (int i = 0; i < NPDENTRIES; ++i) {
  801d99:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801da0:	eb 7d                	jmp    801e1f <copy_shared_pages+0x97>
	    for (int j = 0; j < NPTENTRIES; ++j) {
    	  pn = i*NPDENTRIES + j;
    	  addr = (void*) (pn*PGSIZE);
      	  if ((pn < (UTOP >> PGSHIFT)) && uvpd[i]) {
  801da2:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  801da8:	77 54                	ja     801dfe <copy_shared_pages+0x76>
  801daa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dad:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801db4:	85 c0                	test   %eax,%eax
  801db6:	74 46                	je     801dfe <copy_shared_pages+0x76>
        	if (uvpt[pn] & PTE_SHARE) {
  801db8:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801dbf:	f6 c4 04             	test   $0x4,%ah
  801dc2:	74 3a                	je     801dfe <copy_shared_pages+0x76>
          		if (sys_page_map(0, addr, child, addr, uvpt[pn] & PTE_SYSCALL) < 0) {
  801dc4:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801dcb:	83 ec 0c             	sub    $0xc,%esp
  801dce:	25 07 0e 00 00       	and    $0xe07,%eax
  801dd3:	50                   	push   %eax
  801dd4:	56                   	push   %esi
  801dd5:	ff 75 e0             	pushl  -0x20(%ebp)
  801dd8:	56                   	push   %esi
  801dd9:	6a 00                	push   $0x0
  801ddb:	e8 ca f1 ff ff       	call   800faa <sys_page_map>
  801de0:	83 c4 20             	add    $0x20,%esp
  801de3:	85 c0                	test   %eax,%eax
  801de5:	79 17                	jns    801dfe <copy_shared_pages+0x76>
              		panic("Error en sys_page_map");
  801de7:	83 ec 04             	sub    $0x4,%esp
  801dea:	68 0a 30 80 00       	push   $0x80300a
  801def:	68 4f 01 00 00       	push   $0x14f
  801df4:	68 2f 32 80 00       	push   $0x80322f
  801df9:	e8 f4 e6 ff ff       	call   8004f2 <_panic>
  801dfe:	83 c3 01             	add    $0x1,%ebx
  801e01:	81 c6 00 10 00 00    	add    $0x1000,%esi
{
	// LAB 5: Your code here.
	unsigned int pn;
	void* addr;
  	for (int i = 0; i < NPDENTRIES; ++i) {
	    for (int j = 0; j < NPTENTRIES; ++j) {
  801e07:	39 fb                	cmp    %edi,%ebx
  801e09:	75 97                	jne    801da2 <copy_shared_pages+0x1a>
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	unsigned int pn;
	void* addr;
  	for (int i = 0; i < NPDENTRIES; ++i) {
  801e0b:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  801e0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e12:	81 c7 00 04 00 00    	add    $0x400,%edi
  801e18:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e1d:	74 10                	je     801e2f <copy_shared_pages+0xa7>
  801e1f:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801e22:	89 f3                	mov    %esi,%ebx
  801e24:	c1 e3 0a             	shl    $0xa,%ebx
  801e27:	c1 e6 16             	shl    $0x16,%esi
  801e2a:	e9 73 ff ff ff       	jmp    801da2 <copy_shared_pages+0x1a>
        	} 
      	  }
    	}
	}
	return 0;
}
  801e2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e37:	5b                   	pop    %ebx
  801e38:	5e                   	pop    %esi
  801e39:	5f                   	pop    %edi
  801e3a:	5d                   	pop    %ebp
  801e3b:	c3                   	ret    

00801e3c <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	57                   	push   %edi
  801e40:	56                   	push   %esi
  801e41:	53                   	push   %ebx
  801e42:	83 ec 2c             	sub    $0x2c,%esp
  801e45:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801e48:	89 55 d0             	mov    %edx,-0x30(%ebp)
  801e4b:	89 4d cc             	mov    %ecx,-0x34(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801e4e:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801e53:	be 00 00 00 00       	mov    $0x0,%esi
  801e58:	89 d7                	mov    %edx,%edi
	for (argc = 0; argv[argc] != 0; argc++)
  801e5a:	eb 13                	jmp    801e6f <init_stack+0x33>
		string_size += strlen(argv[argc]) + 1;
  801e5c:	83 ec 0c             	sub    $0xc,%esp
  801e5f:	50                   	push   %eax
  801e60:	e8 9f ec ff ff       	call   800b04 <strlen>
  801e65:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801e69:	83 c3 01             	add    $0x1,%ebx
  801e6c:	83 c4 10             	add    $0x10,%esp
  801e6f:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801e76:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801e79:	85 c0                	test   %eax,%eax
  801e7b:	75 df                	jne    801e5c <init_stack+0x20>
  801e7d:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  801e80:	89 4d d8             	mov    %ecx,-0x28(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char *) UTEMP + PGSIZE - string_size;
  801e83:	bf 00 10 40 00       	mov    $0x401000,%edi
  801e88:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t *) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801e8a:	89 fa                	mov    %edi,%edx
  801e8c:	83 e2 fc             	and    $0xfffffffc,%edx
  801e8f:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801e96:	29 c2                	sub    %eax,%edx
  801e98:	89 55 e4             	mov    %edx,-0x1c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void *) (argv_store - 2) < (void *) UTEMP)
  801e9b:	8d 42 f8             	lea    -0x8(%edx),%eax
  801e9e:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801ea3:	0f 86 fc 00 00 00    	jbe    801fa5 <init_stack+0x169>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void *) UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801ea9:	83 ec 04             	sub    $0x4,%esp
  801eac:	6a 07                	push   $0x7
  801eae:	68 00 00 40 00       	push   $0x400000
  801eb3:	6a 00                	push   $0x0
  801eb5:	e8 cc f0 ff ff       	call   800f86 <sys_page_alloc>
  801eba:	83 c4 10             	add    $0x10,%esp
  801ebd:	85 c0                	test   %eax,%eax
  801ebf:	0f 88 e5 00 00 00    	js     801faa <init_stack+0x16e>
  801ec5:	be 00 00 00 00       	mov    $0x0,%esi
  801eca:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  801ecd:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  801ed0:	eb 2d                	jmp    801eff <init_stack+0xc3>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  801ed2:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801ed8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801edb:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801ede:	83 ec 08             	sub    $0x8,%esp
  801ee1:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801ee4:	57                   	push   %edi
  801ee5:	e8 53 ec ff ff       	call   800b3d <strcpy>
		string_store += strlen(argv[i]) + 1;
  801eea:	83 c4 04             	add    $0x4,%esp
  801eed:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801ef0:	e8 0f ec ff ff       	call   800b04 <strlen>
  801ef5:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801ef9:	83 c6 01             	add    $0x1,%esi
  801efc:	83 c4 10             	add    $0x10,%esp
  801eff:	39 75 e0             	cmp    %esi,-0x20(%ebp)
  801f02:	7f ce                	jg     801ed2 <init_stack+0x96>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801f04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f07:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  801f0a:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char *) UTEMP + PGSIZE);
  801f11:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801f17:	74 19                	je     801f32 <init_stack+0xf6>
  801f19:	68 a4 32 80 00       	push   $0x8032a4
  801f1e:	68 03 32 80 00       	push   $0x803203
  801f23:	68 fc 00 00 00       	push   $0xfc
  801f28:	68 2f 32 80 00       	push   $0x80322f
  801f2d:	e8 c0 e5 ff ff       	call   8004f2 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801f32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f35:	89 d0                	mov    %edx,%eax
  801f37:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801f3c:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801f3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f42:	89 42 f8             	mov    %eax,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801f45:	8d 82 f8 cf 7f ee    	lea    -0x11803008(%edx),%eax
  801f4b:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  801f4e:	89 01                	mov    %eax,(%ecx)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0,
  801f50:	83 ec 0c             	sub    $0xc,%esp
  801f53:	6a 07                	push   $0x7
  801f55:	68 00 d0 bf ee       	push   $0xeebfd000
  801f5a:	ff 75 d4             	pushl  -0x2c(%ebp)
  801f5d:	68 00 00 40 00       	push   $0x400000
  801f62:	6a 00                	push   $0x0
  801f64:	e8 41 f0 ff ff       	call   800faa <sys_page_map>
  801f69:	89 c3                	mov    %eax,%ebx
  801f6b:	83 c4 20             	add    $0x20,%esp
  801f6e:	85 c0                	test   %eax,%eax
  801f70:	78 1d                	js     801f8f <init_stack+0x153>
	                      UTEMP,
	                      child,
	                      (void *) (USTACKTOP - PGSIZE),
	                      PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801f72:	83 ec 08             	sub    $0x8,%esp
  801f75:	68 00 00 40 00       	push   $0x400000
  801f7a:	6a 00                	push   $0x0
  801f7c:	e8 4f f0 ff ff       	call   800fd0 <sys_page_unmap>
  801f81:	89 c3                	mov    %eax,%ebx
  801f83:	83 c4 10             	add    $0x10,%esp
		goto error;

	return 0;
  801f86:	b8 00 00 00 00       	mov    $0x0,%eax
	                      UTEMP,
	                      child,
	                      (void *) (USTACKTOP - PGSIZE),
	                      PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801f8b:	85 db                	test   %ebx,%ebx
  801f8d:	79 1b                	jns    801faa <init_stack+0x16e>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801f8f:	83 ec 08             	sub    $0x8,%esp
  801f92:	68 00 00 40 00       	push   $0x400000
  801f97:	6a 00                	push   $0x0
  801f99:	e8 32 f0 ff ff       	call   800fd0 <sys_page_unmap>
	return r;
  801f9e:	83 c4 10             	add    $0x10,%esp
  801fa1:	89 d8                	mov    %ebx,%eax
  801fa3:	eb 05                	jmp    801faa <init_stack+0x16e>
	argv_store = (uintptr_t *) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void *) (argv_store - 2) < (void *) UTEMP)
		return -E_NO_MEM;
  801fa5:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return 0;

error:
	sys_page_unmap(0, UTEMP);
	return r;
}
  801faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fad:	5b                   	pop    %ebx
  801fae:	5e                   	pop    %esi
  801faf:	5f                   	pop    %edi
  801fb0:	5d                   	pop    %ebp
  801fb1:	c3                   	ret    

00801fb2 <map_segment>:
            size_t memsz,
            int fd,
            size_t filesz,
            off_t fileoffset,
            int perm)
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
  801fb5:	57                   	push   %edi
  801fb6:	56                   	push   %esi
  801fb7:	53                   	push   %ebx
  801fb8:	83 ec 1c             	sub    $0x1c,%esp
  801fbb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801fbe:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	int i, r;
	void *blk;

	// cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801fc1:	89 d0                	mov    %edx,%eax
  801fc3:	25 ff 0f 00 00       	and    $0xfff,%eax
  801fc8:	74 0d                	je     801fd7 <map_segment+0x25>
		va -= i;
  801fca:	29 c2                	sub    %eax,%edx
		memsz += i;
  801fcc:	01 c1                	add    %eax,%ecx
  801fce:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		filesz += i;
  801fd1:	01 45 0c             	add    %eax,0xc(%ebp)
		fileoffset -= i;
  801fd4:	29 45 10             	sub    %eax,0x10(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801fd7:	89 d6                	mov    %edx,%esi
  801fd9:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fde:	e9 d6 00 00 00       	jmp    8020b9 <map_segment+0x107>
		if (i >= filesz) {
  801fe3:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
  801fe6:	77 1f                	ja     802007 <map_segment+0x55>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void *) (va + i), perm)) < 0)
  801fe8:	83 ec 04             	sub    $0x4,%esp
  801feb:	ff 75 14             	pushl  0x14(%ebp)
  801fee:	56                   	push   %esi
  801fef:	ff 75 e0             	pushl  -0x20(%ebp)
  801ff2:	e8 8f ef ff ff       	call   800f86 <sys_page_alloc>
  801ff7:	83 c4 10             	add    $0x10,%esp
  801ffa:	85 c0                	test   %eax,%eax
  801ffc:	0f 89 ab 00 00 00    	jns    8020ad <map_segment+0xfb>
  802002:	e9 c2 00 00 00       	jmp    8020c9 <map_segment+0x117>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W)) <
  802007:	83 ec 04             	sub    $0x4,%esp
  80200a:	6a 07                	push   $0x7
  80200c:	68 00 00 40 00       	push   $0x400000
  802011:	6a 00                	push   $0x0
  802013:	e8 6e ef ff ff       	call   800f86 <sys_page_alloc>
  802018:	83 c4 10             	add    $0x10,%esp
  80201b:	85 c0                	test   %eax,%eax
  80201d:	0f 88 a6 00 00 00    	js     8020c9 <map_segment+0x117>
			    0)
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802023:	83 ec 08             	sub    $0x8,%esp
  802026:	89 f8                	mov    %edi,%eax
  802028:	03 45 10             	add    0x10(%ebp),%eax
  80202b:	50                   	push   %eax
  80202c:	ff 75 08             	pushl  0x8(%ebp)
  80202f:	e8 68 f9 ff ff       	call   80199c <seek>
  802034:	83 c4 10             	add    $0x10,%esp
  802037:	85 c0                	test   %eax,%eax
  802039:	0f 88 8a 00 00 00    	js     8020c9 <map_segment+0x117>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz - i))) < 0)
  80203f:	83 ec 04             	sub    $0x4,%esp
  802042:	8b 45 0c             	mov    0xc(%ebp),%eax
  802045:	29 f8                	sub    %edi,%eax
  802047:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80204c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802051:	0f 47 c1             	cmova  %ecx,%eax
  802054:	50                   	push   %eax
  802055:	68 00 00 40 00       	push   $0x400000
  80205a:	ff 75 08             	pushl  0x8(%ebp)
  80205d:	e8 65 f8 ff ff       	call   8018c7 <readn>
  802062:	83 c4 10             	add    $0x10,%esp
  802065:	85 c0                	test   %eax,%eax
  802067:	78 60                	js     8020c9 <map_segment+0x117>
				return r;
			if ((r = sys_page_map(
  802069:	83 ec 0c             	sub    $0xc,%esp
  80206c:	ff 75 14             	pushl  0x14(%ebp)
  80206f:	56                   	push   %esi
  802070:	ff 75 e0             	pushl  -0x20(%ebp)
  802073:	68 00 00 40 00       	push   $0x400000
  802078:	6a 00                	push   $0x0
  80207a:	e8 2b ef ff ff       	call   800faa <sys_page_map>
  80207f:	83 c4 20             	add    $0x20,%esp
  802082:	85 c0                	test   %eax,%eax
  802084:	79 15                	jns    80209b <map_segment+0xe9>
			             0, UTEMP, child, (void *) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
  802086:	50                   	push   %eax
  802087:	68 3b 32 80 00       	push   $0x80323b
  80208c:	68 3a 01 00 00       	push   $0x13a
  802091:	68 2f 32 80 00       	push   $0x80322f
  802096:	e8 57 e4 ff ff       	call   8004f2 <_panic>
			sys_page_unmap(0, UTEMP);
  80209b:	83 ec 08             	sub    $0x8,%esp
  80209e:	68 00 00 40 00       	push   $0x400000
  8020a3:	6a 00                	push   $0x0
  8020a5:	e8 26 ef ff ff       	call   800fd0 <sys_page_unmap>
  8020aa:	83 c4 10             	add    $0x10,%esp
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8020ad:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8020b3:	81 c6 00 10 00 00    	add    $0x1000,%esi
  8020b9:	89 df                	mov    %ebx,%edi
  8020bb:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
  8020be:	0f 87 1f ff ff ff    	ja     801fe3 <map_segment+0x31>
			             0, UTEMP, child, (void *) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  8020c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020cc:	5b                   	pop    %ebx
  8020cd:	5e                   	pop    %esi
  8020ce:	5f                   	pop    %edi
  8020cf:	5d                   	pop    %ebp
  8020d0:	c3                   	ret    

008020d1 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
  8020d4:	57                   	push   %edi
  8020d5:	56                   	push   %esi
  8020d6:	53                   	push   %ebx
  8020d7:	81 ec 74 02 00 00    	sub    $0x274,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8020dd:	6a 00                	push   $0x0
  8020df:	ff 75 08             	pushl  0x8(%ebp)
  8020e2:	e8 fd fb ff ff       	call   801ce4 <open>
  8020e7:	89 c7                	mov    %eax,%edi
  8020e9:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8020ef:	83 c4 10             	add    $0x10,%esp
  8020f2:	85 c0                	test   %eax,%eax
  8020f4:	0f 88 e3 01 00 00    	js     8022dd <spawn+0x20c>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf *) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf) ||
  8020fa:	83 ec 04             	sub    $0x4,%esp
  8020fd:	68 00 02 00 00       	push   $0x200
  802102:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802108:	50                   	push   %eax
  802109:	57                   	push   %edi
  80210a:	e8 b8 f7 ff ff       	call   8018c7 <readn>
  80210f:	83 c4 10             	add    $0x10,%esp
  802112:	3d 00 02 00 00       	cmp    $0x200,%eax
  802117:	75 0c                	jne    802125 <spawn+0x54>
  802119:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802120:	45 4c 46 
  802123:	74 33                	je     802158 <spawn+0x87>
	    elf->e_magic != ELF_MAGIC) {
		close(fd);
  802125:	83 ec 0c             	sub    $0xc,%esp
  802128:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80212e:	e8 c7 f5 ff ff       	call   8016fa <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802133:	83 c4 0c             	add    $0xc,%esp
  802136:	68 7f 45 4c 46       	push   $0x464c457f
  80213b:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  802141:	68 58 32 80 00       	push   $0x803258
  802146:	e8 80 e4 ff ff       	call   8005cb <cprintf>
		return -E_NOT_EXEC;
  80214b:	83 c4 10             	add    $0x10,%esp
  80214e:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  802153:	e9 9b 01 00 00       	jmp    8022f3 <spawn+0x222>
  802158:	b8 07 00 00 00       	mov    $0x7,%eax
  80215d:	cd 30                	int    $0x30
  80215f:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  802165:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80216b:	89 c3                	mov    %eax,%ebx
  80216d:	85 c0                	test   %eax,%eax
  80216f:	0f 88 70 01 00 00    	js     8022e5 <spawn+0x214>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802175:	89 c6                	mov    %eax,%esi
  802177:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  80217d:	6b f6 7c             	imul   $0x7c,%esi,%esi
  802180:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  802186:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  80218c:	b9 11 00 00 00       	mov    $0x11,%ecx
  802191:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  802193:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802199:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
  80219f:	8d 8d e0 fd ff ff    	lea    -0x220(%ebp),%ecx
  8021a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a8:	89 d8                	mov    %ebx,%eax
  8021aa:	e8 8d fc ff ff       	call   801e3c <init_stack>
  8021af:	85 c0                	test   %eax,%eax
  8021b1:	0f 88 3c 01 00 00    	js     8022f3 <spawn+0x222>
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr *) (elf_buf + elf->e_phoff);
  8021b7:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8021bd:	8d 9c 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%ebx
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8021c4:	be 00 00 00 00       	mov    $0x0,%esi
  8021c9:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  8021cf:	eb 40                	jmp    802211 <spawn+0x140>
		if (ph->p_type != ELF_PROG_LOAD)
  8021d1:	83 3b 01             	cmpl   $0x1,(%ebx)
  8021d4:	75 35                	jne    80220b <spawn+0x13a>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8021d6:	8b 43 18             	mov    0x18(%ebx),%eax
  8021d9:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  8021dc:	83 f8 01             	cmp    $0x1,%eax
  8021df:	19 c0                	sbb    %eax,%eax
  8021e1:	83 e0 fe             	and    $0xfffffffe,%eax
  8021e4:	83 c0 07             	add    $0x7,%eax
		if ((r = map_segment(child,
  8021e7:	8b 4b 14             	mov    0x14(%ebx),%ecx
  8021ea:	8b 53 08             	mov    0x8(%ebx),%edx
  8021ed:	50                   	push   %eax
  8021ee:	ff 73 04             	pushl  0x4(%ebx)
  8021f1:	ff 73 10             	pushl  0x10(%ebx)
  8021f4:	57                   	push   %edi
  8021f5:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8021fb:	e8 b2 fd ff ff       	call   801fb2 <map_segment>
  802200:	83 c4 10             	add    $0x10,%esp
  802203:	85 c0                	test   %eax,%eax
  802205:	0f 88 ad 00 00 00    	js     8022b8 <spawn+0x1e7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr *) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80220b:	83 c6 01             	add    $0x1,%esi
  80220e:	83 c3 20             	add    $0x20,%ebx
  802211:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802218:	39 c6                	cmp    %eax,%esi
  80221a:	7c b5                	jl     8021d1 <spawn+0x100>
		                     ph->p_filesz,
		                     ph->p_offset,
		                     perm)) < 0)
			goto error;
	}
	close(fd);
  80221c:	83 ec 0c             	sub    $0xc,%esp
  80221f:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802225:	e8 d0 f4 ff ff       	call   8016fa <close>
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  80222a:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802230:	e8 53 fb ff ff       	call   801d88 <copy_shared_pages>
  802235:	83 c4 10             	add    $0x10,%esp
  802238:	85 c0                	test   %eax,%eax
  80223a:	79 15                	jns    802251 <spawn+0x180>
		panic("copy_shared_pages: %e", r);
  80223c:	50                   	push   %eax
  80223d:	68 72 32 80 00       	push   $0x803272
  802242:	68 8c 00 00 00       	push   $0x8c
  802247:	68 2f 32 80 00       	push   $0x80322f
  80224c:	e8 a1 e2 ff ff       	call   8004f2 <_panic>

	child_tf.tf_eflags |= FL_IOPL_3;  // devious: see user/faultio.c
  802251:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  802258:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80225b:	83 ec 08             	sub    $0x8,%esp
  80225e:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802264:	50                   	push   %eax
  802265:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  80226b:	e8 a6 ed ff ff       	call   801016 <sys_env_set_trapframe>
  802270:	83 c4 10             	add    $0x10,%esp
  802273:	85 c0                	test   %eax,%eax
  802275:	79 15                	jns    80228c <spawn+0x1bb>
		panic("sys_env_set_trapframe: %e", r);
  802277:	50                   	push   %eax
  802278:	68 88 32 80 00       	push   $0x803288
  80227d:	68 90 00 00 00       	push   $0x90
  802282:	68 2f 32 80 00       	push   $0x80322f
  802287:	e8 66 e2 ff ff       	call   8004f2 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80228c:	83 ec 08             	sub    $0x8,%esp
  80228f:	6a 02                	push   $0x2
  802291:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802297:	e8 57 ed ff ff       	call   800ff3 <sys_env_set_status>
  80229c:	83 c4 10             	add    $0x10,%esp
  80229f:	85 c0                	test   %eax,%eax
  8022a1:	79 4a                	jns    8022ed <spawn+0x21c>
		panic("sys_env_set_status: %e", r);
  8022a3:	50                   	push   %eax
  8022a4:	68 f9 30 80 00       	push   $0x8030f9
  8022a9:	68 93 00 00 00       	push   $0x93
  8022ae:	68 2f 32 80 00       	push   $0x80322f
  8022b3:	e8 3a e2 ff ff       	call   8004f2 <_panic>
  8022b8:	89 c7                	mov    %eax,%edi

	return child;

error:
	sys_env_destroy(child);
  8022ba:	83 ec 0c             	sub    $0xc,%esp
  8022bd:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8022c3:	e8 51 ec ff ff       	call   800f19 <sys_env_destroy>
	close(fd);
  8022c8:	83 c4 04             	add    $0x4,%esp
  8022cb:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8022d1:	e8 24 f4 ff ff       	call   8016fa <close>
	return r;
  8022d6:	83 c4 10             	add    $0x10,%esp
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child,
  8022d9:	89 f8                	mov    %edi,%eax
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  8022db:	eb 16                	jmp    8022f3 <spawn+0x222>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  8022dd:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8022e3:	eb 0e                	jmp    8022f3 <spawn+0x222>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  8022e5:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  8022eb:	eb 06                	jmp    8022f3 <spawn+0x222>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  8022ed:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  8022f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022f6:	5b                   	pop    %ebx
  8022f7:	5e                   	pop    %esi
  8022f8:	5f                   	pop    %edi
  8022f9:	5d                   	pop    %ebp
  8022fa:	c3                   	ret    

008022fb <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
  8022fe:	56                   	push   %esi
  8022ff:	53                   	push   %ebx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc = 0;
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  802300:	8d 55 10             	lea    0x10(%ebp),%edx
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc = 0;
  802303:	b8 00 00 00 00       	mov    $0x0,%eax
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  802308:	eb 03                	jmp    80230d <spawnl+0x12>
		argc++;
  80230a:	83 c0 01             	add    $0x1,%eax
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc = 0;
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  80230d:	83 c2 04             	add    $0x4,%edx
  802310:	83 7a fc 00          	cmpl   $0x0,-0x4(%edx)
  802314:	75 f4                	jne    80230a <spawnl+0xf>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc + 2];
  802316:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  80231d:	83 e2 f0             	and    $0xfffffff0,%edx
  802320:	29 d4                	sub    %edx,%esp
  802322:	8d 54 24 03          	lea    0x3(%esp),%edx
  802326:	c1 ea 02             	shr    $0x2,%edx
  802329:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  802330:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802332:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802335:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc + 1] = NULL;
  80233c:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802343:	00 
  802344:	89 c2                	mov    %eax,%edx

	va_start(vl, arg0);
	unsigned i;
	for (i = 0; i < argc; i++)
  802346:	b8 00 00 00 00       	mov    $0x0,%eax
  80234b:	eb 0a                	jmp    802357 <spawnl+0x5c>
		argv[i + 1] = va_arg(vl, const char *);
  80234d:	83 c0 01             	add    $0x1,%eax
  802350:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  802354:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc + 1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for (i = 0; i < argc; i++)
  802357:	39 d0                	cmp    %edx,%eax
  802359:	75 f2                	jne    80234d <spawnl+0x52>
		argv[i + 1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  80235b:	83 ec 08             	sub    $0x8,%esp
  80235e:	56                   	push   %esi
  80235f:	ff 75 08             	pushl  0x8(%ebp)
  802362:	e8 6a fd ff ff       	call   8020d1 <spawn>
}
  802367:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80236a:	5b                   	pop    %ebx
  80236b:	5e                   	pop    %esi
  80236c:	5d                   	pop    %ebp
  80236d:	c3                   	ret    

0080236e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
  802371:	56                   	push   %esi
  802372:	53                   	push   %ebx
  802373:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802376:	83 ec 0c             	sub    $0xc,%esp
  802379:	ff 75 08             	pushl  0x8(%ebp)
  80237c:	e8 e9 f1 ff ff       	call   80156a <fd2data>
  802381:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802383:	83 c4 08             	add    $0x8,%esp
  802386:	68 cc 32 80 00       	push   $0x8032cc
  80238b:	53                   	push   %ebx
  80238c:	e8 ac e7 ff ff       	call   800b3d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802391:	8b 46 04             	mov    0x4(%esi),%eax
  802394:	2b 06                	sub    (%esi),%eax
  802396:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80239c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023a3:	00 00 00 
	stat->st_dev = &devpipe;
  8023a6:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8023ad:	40 80 00 
	return 0;
}
  8023b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023b8:	5b                   	pop    %ebx
  8023b9:	5e                   	pop    %esi
  8023ba:	5d                   	pop    %ebp
  8023bb:	c3                   	ret    

008023bc <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
  8023bf:	53                   	push   %ebx
  8023c0:	83 ec 0c             	sub    $0xc,%esp
  8023c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023c6:	53                   	push   %ebx
  8023c7:	6a 00                	push   $0x0
  8023c9:	e8 02 ec ff ff       	call   800fd0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023ce:	89 1c 24             	mov    %ebx,(%esp)
  8023d1:	e8 94 f1 ff ff       	call   80156a <fd2data>
  8023d6:	83 c4 08             	add    $0x8,%esp
  8023d9:	50                   	push   %eax
  8023da:	6a 00                	push   $0x0
  8023dc:	e8 ef eb ff ff       	call   800fd0 <sys_page_unmap>
}
  8023e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023e4:	c9                   	leave  
  8023e5:	c3                   	ret    

008023e6 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8023e6:	55                   	push   %ebp
  8023e7:	89 e5                	mov    %esp,%ebp
  8023e9:	57                   	push   %edi
  8023ea:	56                   	push   %esi
  8023eb:	53                   	push   %ebx
  8023ec:	83 ec 1c             	sub    $0x1c,%esp
  8023ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8023f2:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8023f4:	a1 04 50 80 00       	mov    0x805004,%eax
  8023f9:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  8023fc:	83 ec 0c             	sub    $0xc,%esp
  8023ff:	ff 75 e0             	pushl  -0x20(%ebp)
  802402:	e8 9d 04 00 00       	call   8028a4 <pageref>
  802407:	89 c3                	mov    %eax,%ebx
  802409:	89 3c 24             	mov    %edi,(%esp)
  80240c:	e8 93 04 00 00       	call   8028a4 <pageref>
  802411:	83 c4 10             	add    $0x10,%esp
  802414:	39 c3                	cmp    %eax,%ebx
  802416:	0f 94 c1             	sete   %cl
  802419:	0f b6 c9             	movzbl %cl,%ecx
  80241c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  80241f:	8b 15 04 50 80 00    	mov    0x805004,%edx
  802425:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802428:	39 ce                	cmp    %ecx,%esi
  80242a:	74 1b                	je     802447 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  80242c:	39 c3                	cmp    %eax,%ebx
  80242e:	75 c4                	jne    8023f4 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802430:	8b 42 58             	mov    0x58(%edx),%eax
  802433:	ff 75 e4             	pushl  -0x1c(%ebp)
  802436:	50                   	push   %eax
  802437:	56                   	push   %esi
  802438:	68 d3 32 80 00       	push   $0x8032d3
  80243d:	e8 89 e1 ff ff       	call   8005cb <cprintf>
  802442:	83 c4 10             	add    $0x10,%esp
  802445:	eb ad                	jmp    8023f4 <_pipeisclosed+0xe>
	}
}
  802447:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80244a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80244d:	5b                   	pop    %ebx
  80244e:	5e                   	pop    %esi
  80244f:	5f                   	pop    %edi
  802450:	5d                   	pop    %ebp
  802451:	c3                   	ret    

00802452 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
  802455:	57                   	push   %edi
  802456:	56                   	push   %esi
  802457:	53                   	push   %ebx
  802458:	83 ec 28             	sub    $0x28,%esp
  80245b:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80245e:	56                   	push   %esi
  80245f:	e8 06 f1 ff ff       	call   80156a <fd2data>
  802464:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802466:	83 c4 10             	add    $0x10,%esp
  802469:	bf 00 00 00 00       	mov    $0x0,%edi
  80246e:	eb 4b                	jmp    8024bb <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802470:	89 da                	mov    %ebx,%edx
  802472:	89 f0                	mov    %esi,%eax
  802474:	e8 6d ff ff ff       	call   8023e6 <_pipeisclosed>
  802479:	85 c0                	test   %eax,%eax
  80247b:	75 48                	jne    8024c5 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80247d:	e8 dd ea ff ff       	call   800f5f <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802482:	8b 43 04             	mov    0x4(%ebx),%eax
  802485:	8b 0b                	mov    (%ebx),%ecx
  802487:	8d 51 20             	lea    0x20(%ecx),%edx
  80248a:	39 d0                	cmp    %edx,%eax
  80248c:	73 e2                	jae    802470 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80248e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802491:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802495:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802498:	89 c2                	mov    %eax,%edx
  80249a:	c1 fa 1f             	sar    $0x1f,%edx
  80249d:	89 d1                	mov    %edx,%ecx
  80249f:	c1 e9 1b             	shr    $0x1b,%ecx
  8024a2:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8024a5:	83 e2 1f             	and    $0x1f,%edx
  8024a8:	29 ca                	sub    %ecx,%edx
  8024aa:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8024ae:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024b2:	83 c0 01             	add    $0x1,%eax
  8024b5:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024b8:	83 c7 01             	add    $0x1,%edi
  8024bb:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024be:	75 c2                	jne    802482 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8024c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8024c3:	eb 05                	jmp    8024ca <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8024c5:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8024ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024cd:	5b                   	pop    %ebx
  8024ce:	5e                   	pop    %esi
  8024cf:	5f                   	pop    %edi
  8024d0:	5d                   	pop    %ebp
  8024d1:	c3                   	ret    

008024d2 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8024d2:	55                   	push   %ebp
  8024d3:	89 e5                	mov    %esp,%ebp
  8024d5:	57                   	push   %edi
  8024d6:	56                   	push   %esi
  8024d7:	53                   	push   %ebx
  8024d8:	83 ec 18             	sub    $0x18,%esp
  8024db:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8024de:	57                   	push   %edi
  8024df:	e8 86 f0 ff ff       	call   80156a <fd2data>
  8024e4:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024e6:	83 c4 10             	add    $0x10,%esp
  8024e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8024ee:	eb 3d                	jmp    80252d <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8024f0:	85 db                	test   %ebx,%ebx
  8024f2:	74 04                	je     8024f8 <devpipe_read+0x26>
				return i;
  8024f4:	89 d8                	mov    %ebx,%eax
  8024f6:	eb 44                	jmp    80253c <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8024f8:	89 f2                	mov    %esi,%edx
  8024fa:	89 f8                	mov    %edi,%eax
  8024fc:	e8 e5 fe ff ff       	call   8023e6 <_pipeisclosed>
  802501:	85 c0                	test   %eax,%eax
  802503:	75 32                	jne    802537 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802505:	e8 55 ea ff ff       	call   800f5f <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80250a:	8b 06                	mov    (%esi),%eax
  80250c:	3b 46 04             	cmp    0x4(%esi),%eax
  80250f:	74 df                	je     8024f0 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802511:	99                   	cltd   
  802512:	c1 ea 1b             	shr    $0x1b,%edx
  802515:	01 d0                	add    %edx,%eax
  802517:	83 e0 1f             	and    $0x1f,%eax
  80251a:	29 d0                	sub    %edx,%eax
  80251c:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  802521:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802524:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  802527:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80252a:	83 c3 01             	add    $0x1,%ebx
  80252d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802530:	75 d8                	jne    80250a <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802532:	8b 45 10             	mov    0x10(%ebp),%eax
  802535:	eb 05                	jmp    80253c <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802537:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80253c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80253f:	5b                   	pop    %ebx
  802540:	5e                   	pop    %esi
  802541:	5f                   	pop    %edi
  802542:	5d                   	pop    %ebp
  802543:	c3                   	ret    

00802544 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802544:	55                   	push   %ebp
  802545:	89 e5                	mov    %esp,%ebp
  802547:	56                   	push   %esi
  802548:	53                   	push   %ebx
  802549:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80254c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80254f:	50                   	push   %eax
  802550:	e8 2d f0 ff ff       	call   801582 <fd_alloc>
  802555:	83 c4 10             	add    $0x10,%esp
  802558:	89 c2                	mov    %eax,%edx
  80255a:	85 c0                	test   %eax,%eax
  80255c:	0f 88 2c 01 00 00    	js     80268e <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802562:	83 ec 04             	sub    $0x4,%esp
  802565:	68 07 04 00 00       	push   $0x407
  80256a:	ff 75 f4             	pushl  -0xc(%ebp)
  80256d:	6a 00                	push   $0x0
  80256f:	e8 12 ea ff ff       	call   800f86 <sys_page_alloc>
  802574:	83 c4 10             	add    $0x10,%esp
  802577:	89 c2                	mov    %eax,%edx
  802579:	85 c0                	test   %eax,%eax
  80257b:	0f 88 0d 01 00 00    	js     80268e <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802581:	83 ec 0c             	sub    $0xc,%esp
  802584:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802587:	50                   	push   %eax
  802588:	e8 f5 ef ff ff       	call   801582 <fd_alloc>
  80258d:	89 c3                	mov    %eax,%ebx
  80258f:	83 c4 10             	add    $0x10,%esp
  802592:	85 c0                	test   %eax,%eax
  802594:	0f 88 e2 00 00 00    	js     80267c <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80259a:	83 ec 04             	sub    $0x4,%esp
  80259d:	68 07 04 00 00       	push   $0x407
  8025a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8025a5:	6a 00                	push   $0x0
  8025a7:	e8 da e9 ff ff       	call   800f86 <sys_page_alloc>
  8025ac:	89 c3                	mov    %eax,%ebx
  8025ae:	83 c4 10             	add    $0x10,%esp
  8025b1:	85 c0                	test   %eax,%eax
  8025b3:	0f 88 c3 00 00 00    	js     80267c <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8025b9:	83 ec 0c             	sub    $0xc,%esp
  8025bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8025bf:	e8 a6 ef ff ff       	call   80156a <fd2data>
  8025c4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025c6:	83 c4 0c             	add    $0xc,%esp
  8025c9:	68 07 04 00 00       	push   $0x407
  8025ce:	50                   	push   %eax
  8025cf:	6a 00                	push   $0x0
  8025d1:	e8 b0 e9 ff ff       	call   800f86 <sys_page_alloc>
  8025d6:	89 c3                	mov    %eax,%ebx
  8025d8:	83 c4 10             	add    $0x10,%esp
  8025db:	85 c0                	test   %eax,%eax
  8025dd:	0f 88 89 00 00 00    	js     80266c <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025e3:	83 ec 0c             	sub    $0xc,%esp
  8025e6:	ff 75 f0             	pushl  -0x10(%ebp)
  8025e9:	e8 7c ef ff ff       	call   80156a <fd2data>
  8025ee:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025f5:	50                   	push   %eax
  8025f6:	6a 00                	push   $0x0
  8025f8:	56                   	push   %esi
  8025f9:	6a 00                	push   $0x0
  8025fb:	e8 aa e9 ff ff       	call   800faa <sys_page_map>
  802600:	89 c3                	mov    %eax,%ebx
  802602:	83 c4 20             	add    $0x20,%esp
  802605:	85 c0                	test   %eax,%eax
  802607:	78 55                	js     80265e <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802609:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802617:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  80261e:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802624:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802627:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802629:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802633:	83 ec 0c             	sub    $0xc,%esp
  802636:	ff 75 f4             	pushl  -0xc(%ebp)
  802639:	e8 1c ef ff ff       	call   80155a <fd2num>
  80263e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802641:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802643:	83 c4 04             	add    $0x4,%esp
  802646:	ff 75 f0             	pushl  -0x10(%ebp)
  802649:	e8 0c ef ff ff       	call   80155a <fd2num>
  80264e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802651:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802654:	83 c4 10             	add    $0x10,%esp
  802657:	ba 00 00 00 00       	mov    $0x0,%edx
  80265c:	eb 30                	jmp    80268e <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  80265e:	83 ec 08             	sub    $0x8,%esp
  802661:	56                   	push   %esi
  802662:	6a 00                	push   $0x0
  802664:	e8 67 e9 ff ff       	call   800fd0 <sys_page_unmap>
  802669:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  80266c:	83 ec 08             	sub    $0x8,%esp
  80266f:	ff 75 f0             	pushl  -0x10(%ebp)
  802672:	6a 00                	push   $0x0
  802674:	e8 57 e9 ff ff       	call   800fd0 <sys_page_unmap>
  802679:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  80267c:	83 ec 08             	sub    $0x8,%esp
  80267f:	ff 75 f4             	pushl  -0xc(%ebp)
  802682:	6a 00                	push   $0x0
  802684:	e8 47 e9 ff ff       	call   800fd0 <sys_page_unmap>
  802689:	83 c4 10             	add    $0x10,%esp
  80268c:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  80268e:	89 d0                	mov    %edx,%eax
  802690:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802693:	5b                   	pop    %ebx
  802694:	5e                   	pop    %esi
  802695:	5d                   	pop    %ebp
  802696:	c3                   	ret    

00802697 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802697:	55                   	push   %ebp
  802698:	89 e5                	mov    %esp,%ebp
  80269a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80269d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026a0:	50                   	push   %eax
  8026a1:	ff 75 08             	pushl  0x8(%ebp)
  8026a4:	e8 28 ef ff ff       	call   8015d1 <fd_lookup>
  8026a9:	83 c4 10             	add    $0x10,%esp
  8026ac:	85 c0                	test   %eax,%eax
  8026ae:	78 18                	js     8026c8 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8026b0:	83 ec 0c             	sub    $0xc,%esp
  8026b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8026b6:	e8 af ee ff ff       	call   80156a <fd2data>
	return _pipeisclosed(fd, p);
  8026bb:	89 c2                	mov    %eax,%edx
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	e8 21 fd ff ff       	call   8023e6 <_pipeisclosed>
  8026c5:	83 c4 10             	add    $0x10,%esp
}
  8026c8:	c9                   	leave  
  8026c9:	c3                   	ret    

008026ca <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8026ca:	55                   	push   %ebp
  8026cb:	89 e5                	mov    %esp,%ebp
  8026cd:	56                   	push   %esi
  8026ce:	53                   	push   %ebx
  8026cf:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8026d2:	85 f6                	test   %esi,%esi
  8026d4:	75 16                	jne    8026ec <wait+0x22>
  8026d6:	68 eb 32 80 00       	push   $0x8032eb
  8026db:	68 03 32 80 00       	push   $0x803203
  8026e0:	6a 09                	push   $0x9
  8026e2:	68 f6 32 80 00       	push   $0x8032f6
  8026e7:	e8 06 de ff ff       	call   8004f2 <_panic>
	e = &envs[ENVX(envid)];
  8026ec:	89 f3                	mov    %esi,%ebx
  8026ee:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8026f4:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  8026f7:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8026fd:	eb 05                	jmp    802704 <wait+0x3a>
		sys_yield();
  8026ff:	e8 5b e8 ff ff       	call   800f5f <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802704:	8b 43 48             	mov    0x48(%ebx),%eax
  802707:	39 c6                	cmp    %eax,%esi
  802709:	75 07                	jne    802712 <wait+0x48>
  80270b:	8b 43 54             	mov    0x54(%ebx),%eax
  80270e:	85 c0                	test   %eax,%eax
  802710:	75 ed                	jne    8026ff <wait+0x35>
		sys_yield();
}
  802712:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802715:	5b                   	pop    %ebx
  802716:	5e                   	pop    %esi
  802717:	5d                   	pop    %ebp
  802718:	c3                   	ret    

00802719 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802719:	55                   	push   %ebp
  80271a:	89 e5                	mov    %esp,%ebp
  80271c:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80271f:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802726:	75 2c                	jne    802754 <set_pgfault_handler+0x3b>
		// First time through!
		// LAB 4: Your code here.
		r = sys_page_alloc(0,(void *)(UXSTACKTOP - PGSIZE),PTE_P | PTE_U | PTE_W);
  802728:	83 ec 04             	sub    $0x4,%esp
  80272b:	6a 07                	push   $0x7
  80272d:	68 00 f0 bf ee       	push   $0xeebff000
  802732:	6a 00                	push   $0x0
  802734:	e8 4d e8 ff ff       	call   800f86 <sys_page_alloc>
		if(r < 0)
  802739:	83 c4 10             	add    $0x10,%esp
  80273c:	85 c0                	test   %eax,%eax
  80273e:	79 14                	jns    802754 <set_pgfault_handler+0x3b>
			panic("set_pgfault_handler: error in sys_page_alloc\n");	
  802740:	83 ec 04             	sub    $0x4,%esp
  802743:	68 04 33 80 00       	push   $0x803304
  802748:	6a 22                	push   $0x22
  80274a:	68 70 33 80 00       	push   $0x803370
  80274f:	e8 9e dd ff ff       	call   8004f2 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802754:	8b 45 08             	mov    0x8(%ebp),%eax
  802757:	a3 00 70 80 00       	mov    %eax,0x807000
	r = sys_env_set_pgfault_upcall(0, _pgfault_upcall); 
  80275c:	83 ec 08             	sub    $0x8,%esp
  80275f:	68 88 27 80 00       	push   $0x802788
  802764:	6a 00                	push   $0x0
  802766:	e8 ce e8 ff ff       	call   801039 <sys_env_set_pgfault_upcall>
	if (r < 0)
  80276b:	83 c4 10             	add    $0x10,%esp
  80276e:	85 c0                	test   %eax,%eax
  802770:	79 14                	jns    802786 <set_pgfault_handler+0x6d>
		panic("set_pgfault_handler: error in sys_env_set_pgfault_upcall");
  802772:	83 ec 04             	sub    $0x4,%esp
  802775:	68 34 33 80 00       	push   $0x803334
  80277a:	6a 29                	push   $0x29
  80277c:	68 70 33 80 00       	push   $0x803370
  802781:	e8 6c dd ff ff       	call   8004f2 <_panic>
}
  802786:	c9                   	leave  
  802787:	c3                   	ret    

00802788 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802788:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802789:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  80278e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802790:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	subl $0x4, 0x30(%esp)
  802793:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  802798:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 0x28(%esp), %ebx 	
  80279c:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  8027a0:	89 18                	mov    %ebx,(%eax)
	addl $0x8, %esp
  8027a2:	83 c4 08             	add    $0x8,%esp


	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8027a5:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp 
  8027a6:	83 c4 04             	add    $0x4,%esp
	popfl
  8027a9:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8027aa:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8027ab:	c3                   	ret    

008027ac <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027ac:	55                   	push   %ebp
  8027ad:	89 e5                	mov    %esp,%ebp
  8027af:	56                   	push   %esi
  8027b0:	53                   	push   %ebx
  8027b1:	8b 75 08             	mov    0x8(%ebp),%esi
  8027b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  8027ba:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  8027bc:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8027c1:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  8027c4:	83 ec 0c             	sub    $0xc,%esp
  8027c7:	50                   	push   %eax
  8027c8:	e8 b4 e8 ff ff       	call   801081 <sys_ipc_recv>
	if (from_env_store)
  8027cd:	83 c4 10             	add    $0x10,%esp
  8027d0:	85 f6                	test   %esi,%esi
  8027d2:	74 0b                	je     8027df <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  8027d4:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8027da:	8b 52 74             	mov    0x74(%edx),%edx
  8027dd:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8027df:	85 db                	test   %ebx,%ebx
  8027e1:	74 0b                	je     8027ee <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  8027e3:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8027e9:	8b 52 78             	mov    0x78(%edx),%edx
  8027ec:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  8027ee:	85 c0                	test   %eax,%eax
  8027f0:	79 16                	jns    802808 <ipc_recv+0x5c>
		if (from_env_store)
  8027f2:	85 f6                	test   %esi,%esi
  8027f4:	74 06                	je     8027fc <ipc_recv+0x50>
			*from_env_store = 0;
  8027f6:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  8027fc:	85 db                	test   %ebx,%ebx
  8027fe:	74 10                	je     802810 <ipc_recv+0x64>
			*perm_store = 0;
  802800:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802806:	eb 08                	jmp    802810 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  802808:	a1 04 50 80 00       	mov    0x805004,%eax
  80280d:	8b 40 70             	mov    0x70(%eax),%eax
}
  802810:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802813:	5b                   	pop    %ebx
  802814:	5e                   	pop    %esi
  802815:	5d                   	pop    %ebp
  802816:	c3                   	ret    

00802817 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802817:	55                   	push   %ebp
  802818:	89 e5                	mov    %esp,%ebp
  80281a:	57                   	push   %edi
  80281b:	56                   	push   %esi
  80281c:	53                   	push   %ebx
  80281d:	83 ec 0c             	sub    $0xc,%esp
  802820:	8b 7d 08             	mov    0x8(%ebp),%edi
  802823:	8b 75 0c             	mov    0xc(%ebp),%esi
  802826:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  802829:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  80282b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802830:	0f 44 d8             	cmove  %eax,%ebx
  802833:	eb 1c                	jmp    802851 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  802835:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802838:	74 12                	je     80284c <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  80283a:	50                   	push   %eax
  80283b:	68 7e 33 80 00       	push   $0x80337e
  802840:	6a 42                	push   $0x42
  802842:	68 94 33 80 00       	push   $0x803394
  802847:	e8 a6 dc ff ff       	call   8004f2 <_panic>
		sys_yield();
  80284c:	e8 0e e7 ff ff       	call   800f5f <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  802851:	ff 75 14             	pushl  0x14(%ebp)
  802854:	53                   	push   %ebx
  802855:	56                   	push   %esi
  802856:	57                   	push   %edi
  802857:	e8 00 e8 ff ff       	call   80105c <sys_ipc_try_send>
  80285c:	83 c4 10             	add    $0x10,%esp
  80285f:	85 c0                	test   %eax,%eax
  802861:	75 d2                	jne    802835 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  802863:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802866:	5b                   	pop    %ebx
  802867:	5e                   	pop    %esi
  802868:	5f                   	pop    %edi
  802869:	5d                   	pop    %ebp
  80286a:	c3                   	ret    

0080286b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80286b:	55                   	push   %ebp
  80286c:	89 e5                	mov    %esp,%ebp
  80286e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802871:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802876:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802879:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80287f:	8b 52 50             	mov    0x50(%edx),%edx
  802882:	39 ca                	cmp    %ecx,%edx
  802884:	75 0d                	jne    802893 <ipc_find_env+0x28>
			return envs[i].env_id;
  802886:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802889:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80288e:	8b 40 48             	mov    0x48(%eax),%eax
  802891:	eb 0f                	jmp    8028a2 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802893:	83 c0 01             	add    $0x1,%eax
  802896:	3d 00 04 00 00       	cmp    $0x400,%eax
  80289b:	75 d9                	jne    802876 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80289d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028a2:	5d                   	pop    %ebp
  8028a3:	c3                   	ret    

008028a4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028a4:	55                   	push   %ebp
  8028a5:	89 e5                	mov    %esp,%ebp
  8028a7:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028aa:	89 d0                	mov    %edx,%eax
  8028ac:	c1 e8 16             	shr    $0x16,%eax
  8028af:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028b6:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028bb:	f6 c1 01             	test   $0x1,%cl
  8028be:	74 1d                	je     8028dd <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8028c0:	c1 ea 0c             	shr    $0xc,%edx
  8028c3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028ca:	f6 c2 01             	test   $0x1,%dl
  8028cd:	74 0e                	je     8028dd <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028cf:	c1 ea 0c             	shr    $0xc,%edx
  8028d2:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028d9:	ef 
  8028da:	0f b7 c0             	movzwl %ax,%eax
}
  8028dd:	5d                   	pop    %ebp
  8028de:	c3                   	ret    
  8028df:	90                   	nop

008028e0 <__udivdi3>:
  8028e0:	55                   	push   %ebp
  8028e1:	57                   	push   %edi
  8028e2:	56                   	push   %esi
  8028e3:	53                   	push   %ebx
  8028e4:	83 ec 1c             	sub    $0x1c,%esp
  8028e7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8028eb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8028ef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8028f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8028f7:	85 f6                	test   %esi,%esi
  8028f9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028fd:	89 ca                	mov    %ecx,%edx
  8028ff:	89 f8                	mov    %edi,%eax
  802901:	75 3d                	jne    802940 <__udivdi3+0x60>
  802903:	39 cf                	cmp    %ecx,%edi
  802905:	0f 87 c5 00 00 00    	ja     8029d0 <__udivdi3+0xf0>
  80290b:	85 ff                	test   %edi,%edi
  80290d:	89 fd                	mov    %edi,%ebp
  80290f:	75 0b                	jne    80291c <__udivdi3+0x3c>
  802911:	b8 01 00 00 00       	mov    $0x1,%eax
  802916:	31 d2                	xor    %edx,%edx
  802918:	f7 f7                	div    %edi
  80291a:	89 c5                	mov    %eax,%ebp
  80291c:	89 c8                	mov    %ecx,%eax
  80291e:	31 d2                	xor    %edx,%edx
  802920:	f7 f5                	div    %ebp
  802922:	89 c1                	mov    %eax,%ecx
  802924:	89 d8                	mov    %ebx,%eax
  802926:	89 cf                	mov    %ecx,%edi
  802928:	f7 f5                	div    %ebp
  80292a:	89 c3                	mov    %eax,%ebx
  80292c:	89 d8                	mov    %ebx,%eax
  80292e:	89 fa                	mov    %edi,%edx
  802930:	83 c4 1c             	add    $0x1c,%esp
  802933:	5b                   	pop    %ebx
  802934:	5e                   	pop    %esi
  802935:	5f                   	pop    %edi
  802936:	5d                   	pop    %ebp
  802937:	c3                   	ret    
  802938:	90                   	nop
  802939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802940:	39 ce                	cmp    %ecx,%esi
  802942:	77 74                	ja     8029b8 <__udivdi3+0xd8>
  802944:	0f bd fe             	bsr    %esi,%edi
  802947:	83 f7 1f             	xor    $0x1f,%edi
  80294a:	0f 84 98 00 00 00    	je     8029e8 <__udivdi3+0x108>
  802950:	bb 20 00 00 00       	mov    $0x20,%ebx
  802955:	89 f9                	mov    %edi,%ecx
  802957:	89 c5                	mov    %eax,%ebp
  802959:	29 fb                	sub    %edi,%ebx
  80295b:	d3 e6                	shl    %cl,%esi
  80295d:	89 d9                	mov    %ebx,%ecx
  80295f:	d3 ed                	shr    %cl,%ebp
  802961:	89 f9                	mov    %edi,%ecx
  802963:	d3 e0                	shl    %cl,%eax
  802965:	09 ee                	or     %ebp,%esi
  802967:	89 d9                	mov    %ebx,%ecx
  802969:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80296d:	89 d5                	mov    %edx,%ebp
  80296f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802973:	d3 ed                	shr    %cl,%ebp
  802975:	89 f9                	mov    %edi,%ecx
  802977:	d3 e2                	shl    %cl,%edx
  802979:	89 d9                	mov    %ebx,%ecx
  80297b:	d3 e8                	shr    %cl,%eax
  80297d:	09 c2                	or     %eax,%edx
  80297f:	89 d0                	mov    %edx,%eax
  802981:	89 ea                	mov    %ebp,%edx
  802983:	f7 f6                	div    %esi
  802985:	89 d5                	mov    %edx,%ebp
  802987:	89 c3                	mov    %eax,%ebx
  802989:	f7 64 24 0c          	mull   0xc(%esp)
  80298d:	39 d5                	cmp    %edx,%ebp
  80298f:	72 10                	jb     8029a1 <__udivdi3+0xc1>
  802991:	8b 74 24 08          	mov    0x8(%esp),%esi
  802995:	89 f9                	mov    %edi,%ecx
  802997:	d3 e6                	shl    %cl,%esi
  802999:	39 c6                	cmp    %eax,%esi
  80299b:	73 07                	jae    8029a4 <__udivdi3+0xc4>
  80299d:	39 d5                	cmp    %edx,%ebp
  80299f:	75 03                	jne    8029a4 <__udivdi3+0xc4>
  8029a1:	83 eb 01             	sub    $0x1,%ebx
  8029a4:	31 ff                	xor    %edi,%edi
  8029a6:	89 d8                	mov    %ebx,%eax
  8029a8:	89 fa                	mov    %edi,%edx
  8029aa:	83 c4 1c             	add    $0x1c,%esp
  8029ad:	5b                   	pop    %ebx
  8029ae:	5e                   	pop    %esi
  8029af:	5f                   	pop    %edi
  8029b0:	5d                   	pop    %ebp
  8029b1:	c3                   	ret    
  8029b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029b8:	31 ff                	xor    %edi,%edi
  8029ba:	31 db                	xor    %ebx,%ebx
  8029bc:	89 d8                	mov    %ebx,%eax
  8029be:	89 fa                	mov    %edi,%edx
  8029c0:	83 c4 1c             	add    $0x1c,%esp
  8029c3:	5b                   	pop    %ebx
  8029c4:	5e                   	pop    %esi
  8029c5:	5f                   	pop    %edi
  8029c6:	5d                   	pop    %ebp
  8029c7:	c3                   	ret    
  8029c8:	90                   	nop
  8029c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029d0:	89 d8                	mov    %ebx,%eax
  8029d2:	f7 f7                	div    %edi
  8029d4:	31 ff                	xor    %edi,%edi
  8029d6:	89 c3                	mov    %eax,%ebx
  8029d8:	89 d8                	mov    %ebx,%eax
  8029da:	89 fa                	mov    %edi,%edx
  8029dc:	83 c4 1c             	add    $0x1c,%esp
  8029df:	5b                   	pop    %ebx
  8029e0:	5e                   	pop    %esi
  8029e1:	5f                   	pop    %edi
  8029e2:	5d                   	pop    %ebp
  8029e3:	c3                   	ret    
  8029e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029e8:	39 ce                	cmp    %ecx,%esi
  8029ea:	72 0c                	jb     8029f8 <__udivdi3+0x118>
  8029ec:	31 db                	xor    %ebx,%ebx
  8029ee:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8029f2:	0f 87 34 ff ff ff    	ja     80292c <__udivdi3+0x4c>
  8029f8:	bb 01 00 00 00       	mov    $0x1,%ebx
  8029fd:	e9 2a ff ff ff       	jmp    80292c <__udivdi3+0x4c>
  802a02:	66 90                	xchg   %ax,%ax
  802a04:	66 90                	xchg   %ax,%ax
  802a06:	66 90                	xchg   %ax,%ax
  802a08:	66 90                	xchg   %ax,%ax
  802a0a:	66 90                	xchg   %ax,%ax
  802a0c:	66 90                	xchg   %ax,%ax
  802a0e:	66 90                	xchg   %ax,%ax

00802a10 <__umoddi3>:
  802a10:	55                   	push   %ebp
  802a11:	57                   	push   %edi
  802a12:	56                   	push   %esi
  802a13:	53                   	push   %ebx
  802a14:	83 ec 1c             	sub    $0x1c,%esp
  802a17:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802a1b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802a1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a27:	85 d2                	test   %edx,%edx
  802a29:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802a2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a31:	89 f3                	mov    %esi,%ebx
  802a33:	89 3c 24             	mov    %edi,(%esp)
  802a36:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a3a:	75 1c                	jne    802a58 <__umoddi3+0x48>
  802a3c:	39 f7                	cmp    %esi,%edi
  802a3e:	76 50                	jbe    802a90 <__umoddi3+0x80>
  802a40:	89 c8                	mov    %ecx,%eax
  802a42:	89 f2                	mov    %esi,%edx
  802a44:	f7 f7                	div    %edi
  802a46:	89 d0                	mov    %edx,%eax
  802a48:	31 d2                	xor    %edx,%edx
  802a4a:	83 c4 1c             	add    $0x1c,%esp
  802a4d:	5b                   	pop    %ebx
  802a4e:	5e                   	pop    %esi
  802a4f:	5f                   	pop    %edi
  802a50:	5d                   	pop    %ebp
  802a51:	c3                   	ret    
  802a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a58:	39 f2                	cmp    %esi,%edx
  802a5a:	89 d0                	mov    %edx,%eax
  802a5c:	77 52                	ja     802ab0 <__umoddi3+0xa0>
  802a5e:	0f bd ea             	bsr    %edx,%ebp
  802a61:	83 f5 1f             	xor    $0x1f,%ebp
  802a64:	75 5a                	jne    802ac0 <__umoddi3+0xb0>
  802a66:	3b 54 24 04          	cmp    0x4(%esp),%edx
  802a6a:	0f 82 e0 00 00 00    	jb     802b50 <__umoddi3+0x140>
  802a70:	39 0c 24             	cmp    %ecx,(%esp)
  802a73:	0f 86 d7 00 00 00    	jbe    802b50 <__umoddi3+0x140>
  802a79:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a7d:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a81:	83 c4 1c             	add    $0x1c,%esp
  802a84:	5b                   	pop    %ebx
  802a85:	5e                   	pop    %esi
  802a86:	5f                   	pop    %edi
  802a87:	5d                   	pop    %ebp
  802a88:	c3                   	ret    
  802a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a90:	85 ff                	test   %edi,%edi
  802a92:	89 fd                	mov    %edi,%ebp
  802a94:	75 0b                	jne    802aa1 <__umoddi3+0x91>
  802a96:	b8 01 00 00 00       	mov    $0x1,%eax
  802a9b:	31 d2                	xor    %edx,%edx
  802a9d:	f7 f7                	div    %edi
  802a9f:	89 c5                	mov    %eax,%ebp
  802aa1:	89 f0                	mov    %esi,%eax
  802aa3:	31 d2                	xor    %edx,%edx
  802aa5:	f7 f5                	div    %ebp
  802aa7:	89 c8                	mov    %ecx,%eax
  802aa9:	f7 f5                	div    %ebp
  802aab:	89 d0                	mov    %edx,%eax
  802aad:	eb 99                	jmp    802a48 <__umoddi3+0x38>
  802aaf:	90                   	nop
  802ab0:	89 c8                	mov    %ecx,%eax
  802ab2:	89 f2                	mov    %esi,%edx
  802ab4:	83 c4 1c             	add    $0x1c,%esp
  802ab7:	5b                   	pop    %ebx
  802ab8:	5e                   	pop    %esi
  802ab9:	5f                   	pop    %edi
  802aba:	5d                   	pop    %ebp
  802abb:	c3                   	ret    
  802abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ac0:	8b 34 24             	mov    (%esp),%esi
  802ac3:	bf 20 00 00 00       	mov    $0x20,%edi
  802ac8:	89 e9                	mov    %ebp,%ecx
  802aca:	29 ef                	sub    %ebp,%edi
  802acc:	d3 e0                	shl    %cl,%eax
  802ace:	89 f9                	mov    %edi,%ecx
  802ad0:	89 f2                	mov    %esi,%edx
  802ad2:	d3 ea                	shr    %cl,%edx
  802ad4:	89 e9                	mov    %ebp,%ecx
  802ad6:	09 c2                	or     %eax,%edx
  802ad8:	89 d8                	mov    %ebx,%eax
  802ada:	89 14 24             	mov    %edx,(%esp)
  802add:	89 f2                	mov    %esi,%edx
  802adf:	d3 e2                	shl    %cl,%edx
  802ae1:	89 f9                	mov    %edi,%ecx
  802ae3:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ae7:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802aeb:	d3 e8                	shr    %cl,%eax
  802aed:	89 e9                	mov    %ebp,%ecx
  802aef:	89 c6                	mov    %eax,%esi
  802af1:	d3 e3                	shl    %cl,%ebx
  802af3:	89 f9                	mov    %edi,%ecx
  802af5:	89 d0                	mov    %edx,%eax
  802af7:	d3 e8                	shr    %cl,%eax
  802af9:	89 e9                	mov    %ebp,%ecx
  802afb:	09 d8                	or     %ebx,%eax
  802afd:	89 d3                	mov    %edx,%ebx
  802aff:	89 f2                	mov    %esi,%edx
  802b01:	f7 34 24             	divl   (%esp)
  802b04:	89 d6                	mov    %edx,%esi
  802b06:	d3 e3                	shl    %cl,%ebx
  802b08:	f7 64 24 04          	mull   0x4(%esp)
  802b0c:	39 d6                	cmp    %edx,%esi
  802b0e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b12:	89 d1                	mov    %edx,%ecx
  802b14:	89 c3                	mov    %eax,%ebx
  802b16:	72 08                	jb     802b20 <__umoddi3+0x110>
  802b18:	75 11                	jne    802b2b <__umoddi3+0x11b>
  802b1a:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802b1e:	73 0b                	jae    802b2b <__umoddi3+0x11b>
  802b20:	2b 44 24 04          	sub    0x4(%esp),%eax
  802b24:	1b 14 24             	sbb    (%esp),%edx
  802b27:	89 d1                	mov    %edx,%ecx
  802b29:	89 c3                	mov    %eax,%ebx
  802b2b:	8b 54 24 08          	mov    0x8(%esp),%edx
  802b2f:	29 da                	sub    %ebx,%edx
  802b31:	19 ce                	sbb    %ecx,%esi
  802b33:	89 f9                	mov    %edi,%ecx
  802b35:	89 f0                	mov    %esi,%eax
  802b37:	d3 e0                	shl    %cl,%eax
  802b39:	89 e9                	mov    %ebp,%ecx
  802b3b:	d3 ea                	shr    %cl,%edx
  802b3d:	89 e9                	mov    %ebp,%ecx
  802b3f:	d3 ee                	shr    %cl,%esi
  802b41:	09 d0                	or     %edx,%eax
  802b43:	89 f2                	mov    %esi,%edx
  802b45:	83 c4 1c             	add    $0x1c,%esp
  802b48:	5b                   	pop    %ebx
  802b49:	5e                   	pop    %esi
  802b4a:	5f                   	pop    %edi
  802b4b:	5d                   	pop    %ebp
  802b4c:	c3                   	ret    
  802b4d:	8d 76 00             	lea    0x0(%esi),%esi
  802b50:	29 f9                	sub    %edi,%ecx
  802b52:	19 d6                	sbb    %edx,%esi
  802b54:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b58:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b5c:	e9 18 ff ff ff       	jmp    802a79 <__umoddi3+0x69>
