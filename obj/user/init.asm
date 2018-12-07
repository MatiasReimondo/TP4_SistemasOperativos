
obj/user/init.debug:     formato del fichero elf32-i386


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
  80002c:	e8 6e 03 00 00       	call   80039f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
  80003b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, tot = 0;
  80003e:	b8 00 00 00 00       	mov    $0x0,%eax
	for (i = 0; i < n; i++)
  800043:	ba 00 00 00 00       	mov    $0x0,%edx
  800048:	eb 0c                	jmp    800056 <sum+0x23>
		tot ^= i * s[i];
  80004a:	0f be 0c 16          	movsbl (%esi,%edx,1),%ecx
  80004e:	0f af ca             	imul   %edx,%ecx
  800051:	31 c8                	xor    %ecx,%eax

int
sum(const char *s, int n)
{
	int i, tot = 0;
	for (i = 0; i < n; i++)
  800053:	83 c2 01             	add    $0x1,%edx
  800056:	39 da                	cmp    %ebx,%edx
  800058:	7c f0                	jl     80004a <sum+0x17>
		tot ^= i * s[i];
	return tot;
}
  80005a:	5b                   	pop    %ebx
  80005b:	5e                   	pop    %esi
  80005c:	5d                   	pop    %ebp
  80005d:	c3                   	ret    

0080005e <umain>:

void
umain(int argc, char **argv)
{
  80005e:	55                   	push   %ebp
  80005f:	89 e5                	mov    %esp,%ebp
  800061:	57                   	push   %edi
  800062:	56                   	push   %esi
  800063:	53                   	push   %ebx
  800064:	81 ec 18 01 00 00    	sub    $0x118,%esp
  80006a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  80006d:	68 40 25 80 00       	push   $0x802540
  800072:	e8 65 04 00 00       	call   8004dc <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800077:	83 c4 08             	add    $0x8,%esp
  80007a:	68 70 17 00 00       	push   $0x1770
  80007f:	68 00 30 80 00       	push   $0x803000
  800084:	e8 aa ff ff ff       	call   800033 <sum>
  800089:	83 c4 10             	add    $0x10,%esp
  80008c:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  800091:	74 18                	je     8000ab <umain+0x4d>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	68 9e 98 0f 00       	push   $0xf989e
  80009b:	50                   	push   %eax
  80009c:	68 08 26 80 00       	push   $0x802608
  8000a1:	e8 36 04 00 00       	call   8004dc <cprintf>
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	eb 10                	jmp    8000bb <umain+0x5d>
			x, want);
	else
		cprintf("init: data seems okay\n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 4f 25 80 00       	push   $0x80254f
  8000b3:	e8 24 04 00 00       	call   8004dc <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	if ((x = sum(bss, sizeof bss)) != 0)
  8000bb:	83 ec 08             	sub    $0x8,%esp
  8000be:	68 70 17 00 00       	push   $0x1770
  8000c3:	68 20 50 80 00       	push   $0x805020
  8000c8:	e8 66 ff ff ff       	call   800033 <sum>
  8000cd:	83 c4 10             	add    $0x10,%esp
  8000d0:	85 c0                	test   %eax,%eax
  8000d2:	74 13                	je     8000e7 <umain+0x89>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000d4:	83 ec 08             	sub    $0x8,%esp
  8000d7:	50                   	push   %eax
  8000d8:	68 44 26 80 00       	push   $0x802644
  8000dd:	e8 fa 03 00 00       	call   8004dc <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	eb 10                	jmp    8000f7 <umain+0x99>
	else
		cprintf("init: bss seems okay\n");
  8000e7:	83 ec 0c             	sub    $0xc,%esp
  8000ea:	68 66 25 80 00       	push   $0x802566
  8000ef:	e8 e8 03 00 00       	call   8004dc <cprintf>
  8000f4:	83 c4 10             	add    $0x10,%esp

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000f7:	83 ec 08             	sub    $0x8,%esp
  8000fa:	68 7c 25 80 00       	push   $0x80257c
  8000ff:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800105:	50                   	push   %eax
  800106:	e8 63 09 00 00       	call   800a6e <strcat>
	for (i = 0; i < argc; i++) {
  80010b:	83 c4 10             	add    $0x10,%esp
  80010e:	bb 00 00 00 00       	mov    $0x0,%ebx
		strcat(args, " '");
  800113:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
	for (i = 0; i < argc; i++) {
  800119:	eb 2e                	jmp    800149 <umain+0xeb>
		strcat(args, " '");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 88 25 80 00       	push   $0x802588
  800123:	56                   	push   %esi
  800124:	e8 45 09 00 00       	call   800a6e <strcat>
		strcat(args, argv[i]);
  800129:	83 c4 08             	add    $0x8,%esp
  80012c:	ff 34 9f             	pushl  (%edi,%ebx,4)
  80012f:	56                   	push   %esi
  800130:	e8 39 09 00 00       	call   800a6e <strcat>
		strcat(args, "'");
  800135:	83 c4 08             	add    $0x8,%esp
  800138:	68 89 25 80 00       	push   $0x802589
  80013d:	56                   	push   %esi
  80013e:	e8 2b 09 00 00       	call   800a6e <strcat>
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
	for (i = 0; i < argc; i++) {
  800143:	83 c3 01             	add    $0x1,%ebx
  800146:	83 c4 10             	add    $0x10,%esp
  800149:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  80014c:	7c cd                	jl     80011b <umain+0xbd>
		strcat(args, " '");
		strcat(args, argv[i]);
		strcat(args, "'");
	}
	cprintf("%s\n", args);
  80014e:	83 ec 08             	sub    $0x8,%esp
  800151:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800157:	50                   	push   %eax
  800158:	68 8b 25 80 00       	push   $0x80258b
  80015d:	e8 7a 03 00 00       	call   8004dc <cprintf>

	cprintf("init: running sh\n");
  800162:	c7 04 24 8f 25 80 00 	movl   $0x80258f,(%esp)
  800169:	e8 6e 03 00 00       	call   8004dc <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  80016e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800175:	e8 da 0f 00 00       	call   801154 <close>
	if ((r = opencons()) < 0)
  80017a:	e8 c6 01 00 00       	call   800345 <opencons>
  80017f:	83 c4 10             	add    $0x10,%esp
  800182:	85 c0                	test   %eax,%eax
  800184:	79 12                	jns    800198 <umain+0x13a>
		panic("opencons: %e", r);
  800186:	50                   	push   %eax
  800187:	68 a1 25 80 00       	push   $0x8025a1
  80018c:	6a 37                	push   $0x37
  80018e:	68 ae 25 80 00       	push   $0x8025ae
  800193:	e8 6b 02 00 00       	call   800403 <_panic>
	if (r != 0)
  800198:	85 c0                	test   %eax,%eax
  80019a:	74 12                	je     8001ae <umain+0x150>
		panic("first opencons used fd %d", r);
  80019c:	50                   	push   %eax
  80019d:	68 ba 25 80 00       	push   $0x8025ba
  8001a2:	6a 39                	push   $0x39
  8001a4:	68 ae 25 80 00       	push   $0x8025ae
  8001a9:	e8 55 02 00 00       	call   800403 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001ae:	83 ec 08             	sub    $0x8,%esp
  8001b1:	6a 01                	push   $0x1
  8001b3:	6a 00                	push   $0x0
  8001b5:	e8 ea 0f 00 00       	call   8011a4 <dup>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	85 c0                	test   %eax,%eax
  8001bf:	79 12                	jns    8001d3 <umain+0x175>
		panic("dup: %e", r);
  8001c1:	50                   	push   %eax
  8001c2:	68 d4 25 80 00       	push   $0x8025d4
  8001c7:	6a 3b                	push   $0x3b
  8001c9:	68 ae 25 80 00       	push   $0x8025ae
  8001ce:	e8 30 02 00 00       	call   800403 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
  8001d3:	83 ec 0c             	sub    $0xc,%esp
  8001d6:	68 dc 25 80 00       	push   $0x8025dc
  8001db:	e8 fc 02 00 00       	call   8004dc <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  8001e0:	83 c4 0c             	add    $0xc,%esp
  8001e3:	6a 00                	push   $0x0
  8001e5:	68 f0 25 80 00       	push   $0x8025f0
  8001ea:	68 ef 25 80 00       	push   $0x8025ef
  8001ef:	e8 61 1b 00 00       	call   801d55 <spawnl>
		if (r < 0) {
  8001f4:	83 c4 10             	add    $0x10,%esp
  8001f7:	85 c0                	test   %eax,%eax
  8001f9:	79 13                	jns    80020e <umain+0x1b0>
			cprintf("init: spawn sh: %e\n", r);
  8001fb:	83 ec 08             	sub    $0x8,%esp
  8001fe:	50                   	push   %eax
  8001ff:	68 f3 25 80 00       	push   $0x8025f3
  800204:	e8 d3 02 00 00       	call   8004dc <cprintf>
			continue;
  800209:	83 c4 10             	add    $0x10,%esp
  80020c:	eb c5                	jmp    8001d3 <umain+0x175>
		}
		wait(r);
  80020e:	83 ec 0c             	sub    $0xc,%esp
  800211:	50                   	push   %eax
  800212:	e8 0d 1f 00 00       	call   802124 <wait>
  800217:	83 c4 10             	add    $0x10,%esp
  80021a:	eb b7                	jmp    8001d3 <umain+0x175>

0080021c <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80021f:	b8 00 00 00 00       	mov    $0x0,%eax
  800224:	5d                   	pop    %ebp
  800225:	c3                   	ret    

00800226 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800226:	55                   	push   %ebp
  800227:	89 e5                	mov    %esp,%ebp
  800229:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80022c:	68 73 26 80 00       	push   $0x802673
  800231:	ff 75 0c             	pushl  0xc(%ebp)
  800234:	e8 15 08 00 00       	call   800a4e <strcpy>
	return 0;
}
  800239:	b8 00 00 00 00       	mov    $0x0,%eax
  80023e:	c9                   	leave  
  80023f:	c3                   	ret    

00800240 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
  800243:	57                   	push   %edi
  800244:	56                   	push   %esi
  800245:	53                   	push   %ebx
  800246:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80024c:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800251:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800257:	eb 2d                	jmp    800286 <devcons_write+0x46>
		m = n - tot;
  800259:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80025c:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  80025e:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  800261:	ba 7f 00 00 00       	mov    $0x7f,%edx
  800266:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800269:	83 ec 04             	sub    $0x4,%esp
  80026c:	53                   	push   %ebx
  80026d:	03 45 0c             	add    0xc(%ebp),%eax
  800270:	50                   	push   %eax
  800271:	57                   	push   %edi
  800272:	e8 6a 09 00 00       	call   800be1 <memmove>
		sys_cputs(buf, m);
  800277:	83 c4 08             	add    $0x8,%esp
  80027a:	53                   	push   %ebx
  80027b:	57                   	push   %edi
  80027c:	e8 5f 0b 00 00       	call   800de0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800281:	01 de                	add    %ebx,%esi
  800283:	83 c4 10             	add    $0x10,%esp
  800286:	89 f0                	mov    %esi,%eax
  800288:	3b 75 10             	cmp    0x10(%ebp),%esi
  80028b:	72 cc                	jb     800259 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80028d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800290:	5b                   	pop    %ebx
  800291:	5e                   	pop    %esi
  800292:	5f                   	pop    %edi
  800293:	5d                   	pop    %ebp
  800294:	c3                   	ret    

00800295 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	83 ec 08             	sub    $0x8,%esp
  80029b:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  8002a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002a4:	74 2a                	je     8002d0 <devcons_read+0x3b>
  8002a6:	eb 05                	jmp    8002ad <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8002a8:	e8 c3 0b 00 00       	call   800e70 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8002ad:	e8 54 0b 00 00       	call   800e06 <sys_cgetc>
  8002b2:	85 c0                	test   %eax,%eax
  8002b4:	74 f2                	je     8002a8 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8002b6:	85 c0                	test   %eax,%eax
  8002b8:	78 16                	js     8002d0 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8002ba:	83 f8 04             	cmp    $0x4,%eax
  8002bd:	74 0c                	je     8002cb <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8002bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c2:	88 02                	mov    %al,(%edx)
	return 1;
  8002c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8002c9:	eb 05                	jmp    8002d0 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8002cb:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8002d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002db:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8002de:	6a 01                	push   $0x1
  8002e0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8002e3:	50                   	push   %eax
  8002e4:	e8 f7 0a 00 00       	call   800de0 <sys_cputs>
}
  8002e9:	83 c4 10             	add    $0x10,%esp
  8002ec:	c9                   	leave  
  8002ed:	c3                   	ret    

008002ee <getchar>:

int
getchar(void)
{
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8002f4:	6a 01                	push   $0x1
  8002f6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8002f9:	50                   	push   %eax
  8002fa:	6a 00                	push   $0x0
  8002fc:	e8 8f 0f 00 00       	call   801290 <read>
	if (r < 0)
  800301:	83 c4 10             	add    $0x10,%esp
  800304:	85 c0                	test   %eax,%eax
  800306:	78 0f                	js     800317 <getchar+0x29>
		return r;
	if (r < 1)
  800308:	85 c0                	test   %eax,%eax
  80030a:	7e 06                	jle    800312 <getchar+0x24>
		return -E_EOF;
	return c;
  80030c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800310:	eb 05                	jmp    800317 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800312:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  800317:	c9                   	leave  
  800318:	c3                   	ret    

00800319 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800319:	55                   	push   %ebp
  80031a:	89 e5                	mov    %esp,%ebp
  80031c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80031f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800322:	50                   	push   %eax
  800323:	ff 75 08             	pushl  0x8(%ebp)
  800326:	e8 00 0d 00 00       	call   80102b <fd_lookup>
  80032b:	83 c4 10             	add    $0x10,%esp
  80032e:	85 c0                	test   %eax,%eax
  800330:	78 11                	js     800343 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800335:	8b 15 70 47 80 00    	mov    0x804770,%edx
  80033b:	39 10                	cmp    %edx,(%eax)
  80033d:	0f 94 c0             	sete   %al
  800340:	0f b6 c0             	movzbl %al,%eax
}
  800343:	c9                   	leave  
  800344:	c3                   	ret    

00800345 <opencons>:

int
opencons(void)
{
  800345:	55                   	push   %ebp
  800346:	89 e5                	mov    %esp,%ebp
  800348:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80034b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80034e:	50                   	push   %eax
  80034f:	e8 88 0c 00 00       	call   800fdc <fd_alloc>
  800354:	83 c4 10             	add    $0x10,%esp
		return r;
  800357:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800359:	85 c0                	test   %eax,%eax
  80035b:	78 3e                	js     80039b <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80035d:	83 ec 04             	sub    $0x4,%esp
  800360:	68 07 04 00 00       	push   $0x407
  800365:	ff 75 f4             	pushl  -0xc(%ebp)
  800368:	6a 00                	push   $0x0
  80036a:	e8 28 0b 00 00       	call   800e97 <sys_page_alloc>
  80036f:	83 c4 10             	add    $0x10,%esp
		return r;
  800372:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800374:	85 c0                	test   %eax,%eax
  800376:	78 23                	js     80039b <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800378:	8b 15 70 47 80 00    	mov    0x804770,%edx
  80037e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800381:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800386:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80038d:	83 ec 0c             	sub    $0xc,%esp
  800390:	50                   	push   %eax
  800391:	e8 1e 0c 00 00       	call   800fb4 <fd2num>
  800396:	89 c2                	mov    %eax,%edx
  800398:	83 c4 10             	add    $0x10,%esp
}
  80039b:	89 d0                	mov    %edx,%eax
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	56                   	push   %esi
  8003a3:	53                   	push   %ebx
  8003a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8003a7:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8003aa:	e8 9d 0a 00 00       	call   800e4c <sys_getenvid>
	if (id >= 0)
  8003af:	85 c0                	test   %eax,%eax
  8003b1:	78 12                	js     8003c5 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  8003b3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003b8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8003bb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003c0:	a3 90 67 80 00       	mov    %eax,0x806790

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003c5:	85 db                	test   %ebx,%ebx
  8003c7:	7e 07                	jle    8003d0 <libmain+0x31>
		binaryname = argv[0];
  8003c9:	8b 06                	mov    (%esi),%eax
  8003cb:	a3 8c 47 80 00       	mov    %eax,0x80478c

	// call user main routine
	umain(argc, argv);
  8003d0:	83 ec 08             	sub    $0x8,%esp
  8003d3:	56                   	push   %esi
  8003d4:	53                   	push   %ebx
  8003d5:	e8 84 fc ff ff       	call   80005e <umain>

	// exit gracefully
	exit();
  8003da:	e8 0a 00 00 00       	call   8003e9 <exit>
}
  8003df:	83 c4 10             	add    $0x10,%esp
  8003e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8003e5:	5b                   	pop    %ebx
  8003e6:	5e                   	pop    %esi
  8003e7:	5d                   	pop    %ebp
  8003e8:	c3                   	ret    

008003e9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003e9:	55                   	push   %ebp
  8003ea:	89 e5                	mov    %esp,%ebp
  8003ec:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8003ef:	e8 8b 0d 00 00       	call   80117f <close_all>
	sys_env_destroy(0);
  8003f4:	83 ec 0c             	sub    $0xc,%esp
  8003f7:	6a 00                	push   $0x0
  8003f9:	e8 2c 0a 00 00       	call   800e2a <sys_env_destroy>
}
  8003fe:	83 c4 10             	add    $0x10,%esp
  800401:	c9                   	leave  
  800402:	c3                   	ret    

00800403 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800403:	55                   	push   %ebp
  800404:	89 e5                	mov    %esp,%ebp
  800406:	56                   	push   %esi
  800407:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800408:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80040b:	8b 35 8c 47 80 00    	mov    0x80478c,%esi
  800411:	e8 36 0a 00 00       	call   800e4c <sys_getenvid>
  800416:	83 ec 0c             	sub    $0xc,%esp
  800419:	ff 75 0c             	pushl  0xc(%ebp)
  80041c:	ff 75 08             	pushl  0x8(%ebp)
  80041f:	56                   	push   %esi
  800420:	50                   	push   %eax
  800421:	68 8c 26 80 00       	push   $0x80268c
  800426:	e8 b1 00 00 00       	call   8004dc <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80042b:	83 c4 18             	add    $0x18,%esp
  80042e:	53                   	push   %ebx
  80042f:	ff 75 10             	pushl  0x10(%ebp)
  800432:	e8 54 00 00 00       	call   80048b <vcprintf>
	cprintf("\n");
  800437:	c7 04 24 8c 2b 80 00 	movl   $0x802b8c,(%esp)
  80043e:	e8 99 00 00 00       	call   8004dc <cprintf>
  800443:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800446:	cc                   	int3   
  800447:	eb fd                	jmp    800446 <_panic+0x43>

00800449 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800449:	55                   	push   %ebp
  80044a:	89 e5                	mov    %esp,%ebp
  80044c:	53                   	push   %ebx
  80044d:	83 ec 04             	sub    $0x4,%esp
  800450:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800453:	8b 13                	mov    (%ebx),%edx
  800455:	8d 42 01             	lea    0x1(%edx),%eax
  800458:	89 03                	mov    %eax,(%ebx)
  80045a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80045d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800461:	3d ff 00 00 00       	cmp    $0xff,%eax
  800466:	75 1a                	jne    800482 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  800468:	83 ec 08             	sub    $0x8,%esp
  80046b:	68 ff 00 00 00       	push   $0xff
  800470:	8d 43 08             	lea    0x8(%ebx),%eax
  800473:	50                   	push   %eax
  800474:	e8 67 09 00 00       	call   800de0 <sys_cputs>
		b->idx = 0;
  800479:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80047f:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  800482:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800486:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800489:	c9                   	leave  
  80048a:	c3                   	ret    

0080048b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800494:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80049b:	00 00 00 
	b.cnt = 0;
  80049e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004a5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8004a8:	ff 75 0c             	pushl  0xc(%ebp)
  8004ab:	ff 75 08             	pushl  0x8(%ebp)
  8004ae:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004b4:	50                   	push   %eax
  8004b5:	68 49 04 80 00       	push   $0x800449
  8004ba:	e8 86 01 00 00       	call   800645 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004bf:	83 c4 08             	add    $0x8,%esp
  8004c2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004c8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004ce:	50                   	push   %eax
  8004cf:	e8 0c 09 00 00       	call   800de0 <sys_cputs>

	return b.cnt;
}
  8004d4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004da:	c9                   	leave  
  8004db:	c3                   	ret    

008004dc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004dc:	55                   	push   %ebp
  8004dd:	89 e5                	mov    %esp,%ebp
  8004df:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004e2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004e5:	50                   	push   %eax
  8004e6:	ff 75 08             	pushl  0x8(%ebp)
  8004e9:	e8 9d ff ff ff       	call   80048b <vcprintf>
	va_end(ap);

	return cnt;
}
  8004ee:	c9                   	leave  
  8004ef:	c3                   	ret    

008004f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	57                   	push   %edi
  8004f4:	56                   	push   %esi
  8004f5:	53                   	push   %ebx
  8004f6:	83 ec 1c             	sub    $0x1c,%esp
  8004f9:	89 c7                	mov    %eax,%edi
  8004fb:	89 d6                	mov    %edx,%esi
  8004fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800500:	8b 55 0c             	mov    0xc(%ebp),%edx
  800503:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800506:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800509:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80050c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800511:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800514:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800517:	39 d3                	cmp    %edx,%ebx
  800519:	72 05                	jb     800520 <printnum+0x30>
  80051b:	39 45 10             	cmp    %eax,0x10(%ebp)
  80051e:	77 45                	ja     800565 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800520:	83 ec 0c             	sub    $0xc,%esp
  800523:	ff 75 18             	pushl  0x18(%ebp)
  800526:	8b 45 14             	mov    0x14(%ebp),%eax
  800529:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80052c:	53                   	push   %ebx
  80052d:	ff 75 10             	pushl  0x10(%ebp)
  800530:	83 ec 08             	sub    $0x8,%esp
  800533:	ff 75 e4             	pushl  -0x1c(%ebp)
  800536:	ff 75 e0             	pushl  -0x20(%ebp)
  800539:	ff 75 dc             	pushl  -0x24(%ebp)
  80053c:	ff 75 d8             	pushl  -0x28(%ebp)
  80053f:	e8 6c 1d 00 00       	call   8022b0 <__udivdi3>
  800544:	83 c4 18             	add    $0x18,%esp
  800547:	52                   	push   %edx
  800548:	50                   	push   %eax
  800549:	89 f2                	mov    %esi,%edx
  80054b:	89 f8                	mov    %edi,%eax
  80054d:	e8 9e ff ff ff       	call   8004f0 <printnum>
  800552:	83 c4 20             	add    $0x20,%esp
  800555:	eb 18                	jmp    80056f <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800557:	83 ec 08             	sub    $0x8,%esp
  80055a:	56                   	push   %esi
  80055b:	ff 75 18             	pushl  0x18(%ebp)
  80055e:	ff d7                	call   *%edi
  800560:	83 c4 10             	add    $0x10,%esp
  800563:	eb 03                	jmp    800568 <printnum+0x78>
  800565:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800568:	83 eb 01             	sub    $0x1,%ebx
  80056b:	85 db                	test   %ebx,%ebx
  80056d:	7f e8                	jg     800557 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80056f:	83 ec 08             	sub    $0x8,%esp
  800572:	56                   	push   %esi
  800573:	83 ec 04             	sub    $0x4,%esp
  800576:	ff 75 e4             	pushl  -0x1c(%ebp)
  800579:	ff 75 e0             	pushl  -0x20(%ebp)
  80057c:	ff 75 dc             	pushl  -0x24(%ebp)
  80057f:	ff 75 d8             	pushl  -0x28(%ebp)
  800582:	e8 59 1e 00 00       	call   8023e0 <__umoddi3>
  800587:	83 c4 14             	add    $0x14,%esp
  80058a:	0f be 80 af 26 80 00 	movsbl 0x8026af(%eax),%eax
  800591:	50                   	push   %eax
  800592:	ff d7                	call   *%edi
}
  800594:	83 c4 10             	add    $0x10,%esp
  800597:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80059a:	5b                   	pop    %ebx
  80059b:	5e                   	pop    %esi
  80059c:	5f                   	pop    %edi
  80059d:	5d                   	pop    %ebp
  80059e:	c3                   	ret    

0080059f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80059f:	55                   	push   %ebp
  8005a0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005a2:	83 fa 01             	cmp    $0x1,%edx
  8005a5:	7e 0e                	jle    8005b5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8005a7:	8b 10                	mov    (%eax),%edx
  8005a9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8005ac:	89 08                	mov    %ecx,(%eax)
  8005ae:	8b 02                	mov    (%edx),%eax
  8005b0:	8b 52 04             	mov    0x4(%edx),%edx
  8005b3:	eb 22                	jmp    8005d7 <getuint+0x38>
	else if (lflag)
  8005b5:	85 d2                	test   %edx,%edx
  8005b7:	74 10                	je     8005c9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8005b9:	8b 10                	mov    (%eax),%edx
  8005bb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005be:	89 08                	mov    %ecx,(%eax)
  8005c0:	8b 02                	mov    (%edx),%eax
  8005c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c7:	eb 0e                	jmp    8005d7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8005c9:	8b 10                	mov    (%eax),%edx
  8005cb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005ce:	89 08                	mov    %ecx,(%eax)
  8005d0:	8b 02                	mov    (%edx),%eax
  8005d2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d7:	5d                   	pop    %ebp
  8005d8:	c3                   	ret    

008005d9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005dc:	83 fa 01             	cmp    $0x1,%edx
  8005df:	7e 0e                	jle    8005ef <getint+0x16>
		return va_arg(*ap, long long);
  8005e1:	8b 10                	mov    (%eax),%edx
  8005e3:	8d 4a 08             	lea    0x8(%edx),%ecx
  8005e6:	89 08                	mov    %ecx,(%eax)
  8005e8:	8b 02                	mov    (%edx),%eax
  8005ea:	8b 52 04             	mov    0x4(%edx),%edx
  8005ed:	eb 1a                	jmp    800609 <getint+0x30>
	else if (lflag)
  8005ef:	85 d2                	test   %edx,%edx
  8005f1:	74 0c                	je     8005ff <getint+0x26>
		return va_arg(*ap, long);
  8005f3:	8b 10                	mov    (%eax),%edx
  8005f5:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005f8:	89 08                	mov    %ecx,(%eax)
  8005fa:	8b 02                	mov    (%edx),%eax
  8005fc:	99                   	cltd   
  8005fd:	eb 0a                	jmp    800609 <getint+0x30>
	else
		return va_arg(*ap, int);
  8005ff:	8b 10                	mov    (%eax),%edx
  800601:	8d 4a 04             	lea    0x4(%edx),%ecx
  800604:	89 08                	mov    %ecx,(%eax)
  800606:	8b 02                	mov    (%edx),%eax
  800608:	99                   	cltd   
}
  800609:	5d                   	pop    %ebp
  80060a:	c3                   	ret    

0080060b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80060b:	55                   	push   %ebp
  80060c:	89 e5                	mov    %esp,%ebp
  80060e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800611:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800615:	8b 10                	mov    (%eax),%edx
  800617:	3b 50 04             	cmp    0x4(%eax),%edx
  80061a:	73 0a                	jae    800626 <sprintputch+0x1b>
		*b->buf++ = ch;
  80061c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80061f:	89 08                	mov    %ecx,(%eax)
  800621:	8b 45 08             	mov    0x8(%ebp),%eax
  800624:	88 02                	mov    %al,(%edx)
}
  800626:	5d                   	pop    %ebp
  800627:	c3                   	ret    

00800628 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800628:	55                   	push   %ebp
  800629:	89 e5                	mov    %esp,%ebp
  80062b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  80062e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800631:	50                   	push   %eax
  800632:	ff 75 10             	pushl  0x10(%ebp)
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	ff 75 08             	pushl  0x8(%ebp)
  80063b:	e8 05 00 00 00       	call   800645 <vprintfmt>
	va_end(ap);
}
  800640:	83 c4 10             	add    $0x10,%esp
  800643:	c9                   	leave  
  800644:	c3                   	ret    

00800645 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800645:	55                   	push   %ebp
  800646:	89 e5                	mov    %esp,%ebp
  800648:	57                   	push   %edi
  800649:	56                   	push   %esi
  80064a:	53                   	push   %ebx
  80064b:	83 ec 2c             	sub    $0x2c,%esp
  80064e:	8b 75 08             	mov    0x8(%ebp),%esi
  800651:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800654:	8b 7d 10             	mov    0x10(%ebp),%edi
  800657:	eb 12                	jmp    80066b <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800659:	85 c0                	test   %eax,%eax
  80065b:	0f 84 44 03 00 00    	je     8009a5 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	53                   	push   %ebx
  800665:	50                   	push   %eax
  800666:	ff d6                	call   *%esi
  800668:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80066b:	83 c7 01             	add    $0x1,%edi
  80066e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800672:	83 f8 25             	cmp    $0x25,%eax
  800675:	75 e2                	jne    800659 <vprintfmt+0x14>
  800677:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  80067b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800682:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800689:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800690:	ba 00 00 00 00       	mov    $0x0,%edx
  800695:	eb 07                	jmp    80069e <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800697:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  80069a:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80069e:	8d 47 01             	lea    0x1(%edi),%eax
  8006a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006a4:	0f b6 07             	movzbl (%edi),%eax
  8006a7:	0f b6 c8             	movzbl %al,%ecx
  8006aa:	83 e8 23             	sub    $0x23,%eax
  8006ad:	3c 55                	cmp    $0x55,%al
  8006af:	0f 87 d5 02 00 00    	ja     80098a <vprintfmt+0x345>
  8006b5:	0f b6 c0             	movzbl %al,%eax
  8006b8:	ff 24 85 00 28 80 00 	jmp    *0x802800(,%eax,4)
  8006bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006c2:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8006c6:	eb d6                	jmp    80069e <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8006d0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8006d3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8006d6:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8006da:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8006dd:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8006e0:	83 fa 09             	cmp    $0x9,%edx
  8006e3:	77 39                	ja     80071e <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006e8:	eb e9                	jmp    8006d3 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	8d 48 04             	lea    0x4(%eax),%ecx
  8006f0:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8006fb:	eb 27                	jmp    800724 <vprintfmt+0xdf>
  8006fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800700:	85 c0                	test   %eax,%eax
  800702:	b9 00 00 00 00       	mov    $0x0,%ecx
  800707:	0f 49 c8             	cmovns %eax,%ecx
  80070a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80070d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800710:	eb 8c                	jmp    80069e <vprintfmt+0x59>
  800712:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800715:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80071c:	eb 80                	jmp    80069e <vprintfmt+0x59>
  80071e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800721:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  800724:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800728:	0f 89 70 ff ff ff    	jns    80069e <vprintfmt+0x59>
				width = precision, precision = -1;
  80072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800731:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800734:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80073b:	e9 5e ff ff ff       	jmp    80069e <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800740:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800743:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800746:	e9 53 ff ff ff       	jmp    80069e <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	8d 50 04             	lea    0x4(%eax),%edx
  800751:	89 55 14             	mov    %edx,0x14(%ebp)
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	53                   	push   %ebx
  800758:	ff 30                	pushl  (%eax)
  80075a:	ff d6                	call   *%esi
			break;
  80075c:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80075f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800762:	e9 04 ff ff ff       	jmp    80066b <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	8d 50 04             	lea    0x4(%eax),%edx
  80076d:	89 55 14             	mov    %edx,0x14(%ebp)
  800770:	8b 00                	mov    (%eax),%eax
  800772:	99                   	cltd   
  800773:	31 d0                	xor    %edx,%eax
  800775:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800777:	83 f8 0f             	cmp    $0xf,%eax
  80077a:	7f 0b                	jg     800787 <vprintfmt+0x142>
  80077c:	8b 14 85 60 29 80 00 	mov    0x802960(,%eax,4),%edx
  800783:	85 d2                	test   %edx,%edx
  800785:	75 18                	jne    80079f <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  800787:	50                   	push   %eax
  800788:	68 c7 26 80 00       	push   $0x8026c7
  80078d:	53                   	push   %ebx
  80078e:	56                   	push   %esi
  80078f:	e8 94 fe ff ff       	call   800628 <printfmt>
  800794:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800797:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80079a:	e9 cc fe ff ff       	jmp    80066b <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  80079f:	52                   	push   %edx
  8007a0:	68 91 2a 80 00       	push   $0x802a91
  8007a5:	53                   	push   %ebx
  8007a6:	56                   	push   %esi
  8007a7:	e8 7c fe ff ff       	call   800628 <printfmt>
  8007ac:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8007b2:	e9 b4 fe ff ff       	jmp    80066b <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	8d 50 04             	lea    0x4(%eax),%edx
  8007bd:	89 55 14             	mov    %edx,0x14(%ebp)
  8007c0:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8007c2:	85 ff                	test   %edi,%edi
  8007c4:	b8 c0 26 80 00       	mov    $0x8026c0,%eax
  8007c9:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8007cc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007d0:	0f 8e 94 00 00 00    	jle    80086a <vprintfmt+0x225>
  8007d6:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8007da:	0f 84 98 00 00 00    	je     800878 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e0:	83 ec 08             	sub    $0x8,%esp
  8007e3:	ff 75 d0             	pushl  -0x30(%ebp)
  8007e6:	57                   	push   %edi
  8007e7:	e8 41 02 00 00       	call   800a2d <strnlen>
  8007ec:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007ef:	29 c1                	sub    %eax,%ecx
  8007f1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8007f4:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8007f7:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8007fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007fe:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800801:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800803:	eb 0f                	jmp    800814 <vprintfmt+0x1cf>
					putch(padc, putdat);
  800805:	83 ec 08             	sub    $0x8,%esp
  800808:	53                   	push   %ebx
  800809:	ff 75 e0             	pushl  -0x20(%ebp)
  80080c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80080e:	83 ef 01             	sub    $0x1,%edi
  800811:	83 c4 10             	add    $0x10,%esp
  800814:	85 ff                	test   %edi,%edi
  800816:	7f ed                	jg     800805 <vprintfmt+0x1c0>
  800818:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80081b:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  80081e:	85 c9                	test   %ecx,%ecx
  800820:	b8 00 00 00 00       	mov    $0x0,%eax
  800825:	0f 49 c1             	cmovns %ecx,%eax
  800828:	29 c1                	sub    %eax,%ecx
  80082a:	89 75 08             	mov    %esi,0x8(%ebp)
  80082d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800830:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800833:	89 cb                	mov    %ecx,%ebx
  800835:	eb 4d                	jmp    800884 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800837:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80083b:	74 1b                	je     800858 <vprintfmt+0x213>
  80083d:	0f be c0             	movsbl %al,%eax
  800840:	83 e8 20             	sub    $0x20,%eax
  800843:	83 f8 5e             	cmp    $0x5e,%eax
  800846:	76 10                	jbe    800858 <vprintfmt+0x213>
					putch('?', putdat);
  800848:	83 ec 08             	sub    $0x8,%esp
  80084b:	ff 75 0c             	pushl  0xc(%ebp)
  80084e:	6a 3f                	push   $0x3f
  800850:	ff 55 08             	call   *0x8(%ebp)
  800853:	83 c4 10             	add    $0x10,%esp
  800856:	eb 0d                	jmp    800865 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  800858:	83 ec 08             	sub    $0x8,%esp
  80085b:	ff 75 0c             	pushl  0xc(%ebp)
  80085e:	52                   	push   %edx
  80085f:	ff 55 08             	call   *0x8(%ebp)
  800862:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800865:	83 eb 01             	sub    $0x1,%ebx
  800868:	eb 1a                	jmp    800884 <vprintfmt+0x23f>
  80086a:	89 75 08             	mov    %esi,0x8(%ebp)
  80086d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800870:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800873:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800876:	eb 0c                	jmp    800884 <vprintfmt+0x23f>
  800878:	89 75 08             	mov    %esi,0x8(%ebp)
  80087b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80087e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800881:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800884:	83 c7 01             	add    $0x1,%edi
  800887:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80088b:	0f be d0             	movsbl %al,%edx
  80088e:	85 d2                	test   %edx,%edx
  800890:	74 23                	je     8008b5 <vprintfmt+0x270>
  800892:	85 f6                	test   %esi,%esi
  800894:	78 a1                	js     800837 <vprintfmt+0x1f2>
  800896:	83 ee 01             	sub    $0x1,%esi
  800899:	79 9c                	jns    800837 <vprintfmt+0x1f2>
  80089b:	89 df                	mov    %ebx,%edi
  80089d:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008a3:	eb 18                	jmp    8008bd <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	53                   	push   %ebx
  8008a9:	6a 20                	push   $0x20
  8008ab:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008ad:	83 ef 01             	sub    $0x1,%edi
  8008b0:	83 c4 10             	add    $0x10,%esp
  8008b3:	eb 08                	jmp    8008bd <vprintfmt+0x278>
  8008b5:	89 df                	mov    %ebx,%edi
  8008b7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008bd:	85 ff                	test   %edi,%edi
  8008bf:	7f e4                	jg     8008a5 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8008c4:	e9 a2 fd ff ff       	jmp    80066b <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008c9:	8d 45 14             	lea    0x14(%ebp),%eax
  8008cc:	e8 08 fd ff ff       	call   8005d9 <getint>
  8008d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8008d7:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8008dc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008e0:	79 74                	jns    800956 <vprintfmt+0x311>
				putch('-', putdat);
  8008e2:	83 ec 08             	sub    $0x8,%esp
  8008e5:	53                   	push   %ebx
  8008e6:	6a 2d                	push   $0x2d
  8008e8:	ff d6                	call   *%esi
				num = -(long long) num;
  8008ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8008f0:	f7 d8                	neg    %eax
  8008f2:	83 d2 00             	adc    $0x0,%edx
  8008f5:	f7 da                	neg    %edx
  8008f7:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8008fa:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8008ff:	eb 55                	jmp    800956 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800901:	8d 45 14             	lea    0x14(%ebp),%eax
  800904:	e8 96 fc ff ff       	call   80059f <getuint>
			base = 10;
  800909:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80090e:	eb 46                	jmp    800956 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800910:	8d 45 14             	lea    0x14(%ebp),%eax
  800913:	e8 87 fc ff ff       	call   80059f <getuint>
			base = 8;
  800918:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80091d:	eb 37                	jmp    800956 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  80091f:	83 ec 08             	sub    $0x8,%esp
  800922:	53                   	push   %ebx
  800923:	6a 30                	push   $0x30
  800925:	ff d6                	call   *%esi
			putch('x', putdat);
  800927:	83 c4 08             	add    $0x8,%esp
  80092a:	53                   	push   %ebx
  80092b:	6a 78                	push   $0x78
  80092d:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	8d 50 04             	lea    0x4(%eax),%edx
  800935:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800938:	8b 00                	mov    (%eax),%eax
  80093a:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  80093f:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800942:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800947:	eb 0d                	jmp    800956 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800949:	8d 45 14             	lea    0x14(%ebp),%eax
  80094c:	e8 4e fc ff ff       	call   80059f <getuint>
			base = 16;
  800951:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800956:	83 ec 0c             	sub    $0xc,%esp
  800959:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80095d:	57                   	push   %edi
  80095e:	ff 75 e0             	pushl  -0x20(%ebp)
  800961:	51                   	push   %ecx
  800962:	52                   	push   %edx
  800963:	50                   	push   %eax
  800964:	89 da                	mov    %ebx,%edx
  800966:	89 f0                	mov    %esi,%eax
  800968:	e8 83 fb ff ff       	call   8004f0 <printnum>
			break;
  80096d:	83 c4 20             	add    $0x20,%esp
  800970:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800973:	e9 f3 fc ff ff       	jmp    80066b <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	53                   	push   %ebx
  80097c:	51                   	push   %ecx
  80097d:	ff d6                	call   *%esi
			break;
  80097f:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800982:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800985:	e9 e1 fc ff ff       	jmp    80066b <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80098a:	83 ec 08             	sub    $0x8,%esp
  80098d:	53                   	push   %ebx
  80098e:	6a 25                	push   $0x25
  800990:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	eb 03                	jmp    80099a <vprintfmt+0x355>
  800997:	83 ef 01             	sub    $0x1,%edi
  80099a:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  80099e:	75 f7                	jne    800997 <vprintfmt+0x352>
  8009a0:	e9 c6 fc ff ff       	jmp    80066b <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  8009a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009a8:	5b                   	pop    %ebx
  8009a9:	5e                   	pop    %esi
  8009aa:	5f                   	pop    %edi
  8009ab:	5d                   	pop    %ebp
  8009ac:	c3                   	ret    

008009ad <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009ad:	55                   	push   %ebp
  8009ae:	89 e5                	mov    %esp,%ebp
  8009b0:	83 ec 18             	sub    $0x18,%esp
  8009b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009bc:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009c0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009ca:	85 c0                	test   %eax,%eax
  8009cc:	74 26                	je     8009f4 <vsnprintf+0x47>
  8009ce:	85 d2                	test   %edx,%edx
  8009d0:	7e 22                	jle    8009f4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009d2:	ff 75 14             	pushl  0x14(%ebp)
  8009d5:	ff 75 10             	pushl  0x10(%ebp)
  8009d8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009db:	50                   	push   %eax
  8009dc:	68 0b 06 80 00       	push   $0x80060b
  8009e1:	e8 5f fc ff ff       	call   800645 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009e9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ef:	83 c4 10             	add    $0x10,%esp
  8009f2:	eb 05                	jmp    8009f9 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8009f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8009f9:	c9                   	leave  
  8009fa:	c3                   	ret    

008009fb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a01:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a04:	50                   	push   %eax
  800a05:	ff 75 10             	pushl  0x10(%ebp)
  800a08:	ff 75 0c             	pushl  0xc(%ebp)
  800a0b:	ff 75 08             	pushl  0x8(%ebp)
  800a0e:	e8 9a ff ff ff       	call   8009ad <vsnprintf>
	va_end(ap);

	return rc;
}
  800a13:	c9                   	leave  
  800a14:	c3                   	ret    

00800a15 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a15:	55                   	push   %ebp
  800a16:	89 e5                	mov    %esp,%ebp
  800a18:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a1b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a20:	eb 03                	jmp    800a25 <strlen+0x10>
		n++;
  800a22:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a25:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a29:	75 f7                	jne    800a22 <strlen+0xd>
		n++;
	return n;
}
  800a2b:	5d                   	pop    %ebp
  800a2c:	c3                   	ret    

00800a2d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
  800a30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a33:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a36:	ba 00 00 00 00       	mov    $0x0,%edx
  800a3b:	eb 03                	jmp    800a40 <strnlen+0x13>
		n++;
  800a3d:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a40:	39 c2                	cmp    %eax,%edx
  800a42:	74 08                	je     800a4c <strnlen+0x1f>
  800a44:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a48:	75 f3                	jne    800a3d <strnlen+0x10>
  800a4a:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  800a4c:	5d                   	pop    %ebp
  800a4d:	c3                   	ret    

00800a4e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a4e:	55                   	push   %ebp
  800a4f:	89 e5                	mov    %esp,%ebp
  800a51:	53                   	push   %ebx
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a58:	89 c2                	mov    %eax,%edx
  800a5a:	83 c2 01             	add    $0x1,%edx
  800a5d:	83 c1 01             	add    $0x1,%ecx
  800a60:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a64:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a67:	84 db                	test   %bl,%bl
  800a69:	75 ef                	jne    800a5a <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a6b:	5b                   	pop    %ebx
  800a6c:	5d                   	pop    %ebp
  800a6d:	c3                   	ret    

00800a6e <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	53                   	push   %ebx
  800a72:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a75:	53                   	push   %ebx
  800a76:	e8 9a ff ff ff       	call   800a15 <strlen>
  800a7b:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a7e:	ff 75 0c             	pushl  0xc(%ebp)
  800a81:	01 d8                	add    %ebx,%eax
  800a83:	50                   	push   %eax
  800a84:	e8 c5 ff ff ff       	call   800a4e <strcpy>
	return dst;
}
  800a89:	89 d8                	mov    %ebx,%eax
  800a8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a8e:	c9                   	leave  
  800a8f:	c3                   	ret    

00800a90 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	56                   	push   %esi
  800a94:	53                   	push   %ebx
  800a95:	8b 75 08             	mov    0x8(%ebp),%esi
  800a98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a9b:	89 f3                	mov    %esi,%ebx
  800a9d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aa0:	89 f2                	mov    %esi,%edx
  800aa2:	eb 0f                	jmp    800ab3 <strncpy+0x23>
		*dst++ = *src;
  800aa4:	83 c2 01             	add    $0x1,%edx
  800aa7:	0f b6 01             	movzbl (%ecx),%eax
  800aaa:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aad:	80 39 01             	cmpb   $0x1,(%ecx)
  800ab0:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ab3:	39 da                	cmp    %ebx,%edx
  800ab5:	75 ed                	jne    800aa4 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800ab7:	89 f0                	mov    %esi,%eax
  800ab9:	5b                   	pop    %ebx
  800aba:	5e                   	pop    %esi
  800abb:	5d                   	pop    %ebp
  800abc:	c3                   	ret    

00800abd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	56                   	push   %esi
  800ac1:	53                   	push   %ebx
  800ac2:	8b 75 08             	mov    0x8(%ebp),%esi
  800ac5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac8:	8b 55 10             	mov    0x10(%ebp),%edx
  800acb:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800acd:	85 d2                	test   %edx,%edx
  800acf:	74 21                	je     800af2 <strlcpy+0x35>
  800ad1:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ad5:	89 f2                	mov    %esi,%edx
  800ad7:	eb 09                	jmp    800ae2 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ad9:	83 c2 01             	add    $0x1,%edx
  800adc:	83 c1 01             	add    $0x1,%ecx
  800adf:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ae2:	39 c2                	cmp    %eax,%edx
  800ae4:	74 09                	je     800aef <strlcpy+0x32>
  800ae6:	0f b6 19             	movzbl (%ecx),%ebx
  800ae9:	84 db                	test   %bl,%bl
  800aeb:	75 ec                	jne    800ad9 <strlcpy+0x1c>
  800aed:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  800aef:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800af2:	29 f0                	sub    %esi,%eax
}
  800af4:	5b                   	pop    %ebx
  800af5:	5e                   	pop    %esi
  800af6:	5d                   	pop    %ebp
  800af7:	c3                   	ret    

00800af8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800afe:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b01:	eb 06                	jmp    800b09 <strcmp+0x11>
		p++, q++;
  800b03:	83 c1 01             	add    $0x1,%ecx
  800b06:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b09:	0f b6 01             	movzbl (%ecx),%eax
  800b0c:	84 c0                	test   %al,%al
  800b0e:	74 04                	je     800b14 <strcmp+0x1c>
  800b10:	3a 02                	cmp    (%edx),%al
  800b12:	74 ef                	je     800b03 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b14:	0f b6 c0             	movzbl %al,%eax
  800b17:	0f b6 12             	movzbl (%edx),%edx
  800b1a:	29 d0                	sub    %edx,%eax
}
  800b1c:	5d                   	pop    %ebp
  800b1d:	c3                   	ret    

00800b1e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	53                   	push   %ebx
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b28:	89 c3                	mov    %eax,%ebx
  800b2a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b2d:	eb 06                	jmp    800b35 <strncmp+0x17>
		n--, p++, q++;
  800b2f:	83 c0 01             	add    $0x1,%eax
  800b32:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800b35:	39 d8                	cmp    %ebx,%eax
  800b37:	74 15                	je     800b4e <strncmp+0x30>
  800b39:	0f b6 08             	movzbl (%eax),%ecx
  800b3c:	84 c9                	test   %cl,%cl
  800b3e:	74 04                	je     800b44 <strncmp+0x26>
  800b40:	3a 0a                	cmp    (%edx),%cl
  800b42:	74 eb                	je     800b2f <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b44:	0f b6 00             	movzbl (%eax),%eax
  800b47:	0f b6 12             	movzbl (%edx),%edx
  800b4a:	29 d0                	sub    %edx,%eax
  800b4c:	eb 05                	jmp    800b53 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800b4e:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800b53:	5b                   	pop    %ebx
  800b54:	5d                   	pop    %ebp
  800b55:	c3                   	ret    

00800b56 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b60:	eb 07                	jmp    800b69 <strchr+0x13>
		if (*s == c)
  800b62:	38 ca                	cmp    %cl,%dl
  800b64:	74 0f                	je     800b75 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b66:	83 c0 01             	add    $0x1,%eax
  800b69:	0f b6 10             	movzbl (%eax),%edx
  800b6c:	84 d2                	test   %dl,%dl
  800b6e:	75 f2                	jne    800b62 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800b70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b75:	5d                   	pop    %ebp
  800b76:	c3                   	ret    

00800b77 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b81:	eb 03                	jmp    800b86 <strfind+0xf>
  800b83:	83 c0 01             	add    $0x1,%eax
  800b86:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b89:	38 ca                	cmp    %cl,%dl
  800b8b:	74 04                	je     800b91 <strfind+0x1a>
  800b8d:	84 d2                	test   %dl,%dl
  800b8f:	75 f2                	jne    800b83 <strfind+0xc>
			break;
	return (char *) s;
}
  800b91:	5d                   	pop    %ebp
  800b92:	c3                   	ret    

00800b93 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	57                   	push   %edi
  800b97:	56                   	push   %esi
  800b98:	53                   	push   %ebx
  800b99:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800b9f:	85 c9                	test   %ecx,%ecx
  800ba1:	74 37                	je     800bda <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ba3:	f6 c2 03             	test   $0x3,%dl
  800ba6:	75 2a                	jne    800bd2 <memset+0x3f>
  800ba8:	f6 c1 03             	test   $0x3,%cl
  800bab:	75 25                	jne    800bd2 <memset+0x3f>
		c &= 0xFF;
  800bad:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bb1:	89 df                	mov    %ebx,%edi
  800bb3:	c1 e7 08             	shl    $0x8,%edi
  800bb6:	89 de                	mov    %ebx,%esi
  800bb8:	c1 e6 18             	shl    $0x18,%esi
  800bbb:	89 d8                	mov    %ebx,%eax
  800bbd:	c1 e0 10             	shl    $0x10,%eax
  800bc0:	09 f0                	or     %esi,%eax
  800bc2:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800bc4:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800bc7:	89 f8                	mov    %edi,%eax
  800bc9:	09 d8                	or     %ebx,%eax
  800bcb:	89 d7                	mov    %edx,%edi
  800bcd:	fc                   	cld    
  800bce:	f3 ab                	rep stos %eax,%es:(%edi)
  800bd0:	eb 08                	jmp    800bda <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bd2:	89 d7                	mov    %edx,%edi
  800bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd7:	fc                   	cld    
  800bd8:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800bda:	89 d0                	mov    %edx,%eax
  800bdc:	5b                   	pop    %ebx
  800bdd:	5e                   	pop    %esi
  800bde:	5f                   	pop    %edi
  800bdf:	5d                   	pop    %ebp
  800be0:	c3                   	ret    

00800be1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	57                   	push   %edi
  800be5:	56                   	push   %esi
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bec:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bef:	39 c6                	cmp    %eax,%esi
  800bf1:	73 35                	jae    800c28 <memmove+0x47>
  800bf3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bf6:	39 d0                	cmp    %edx,%eax
  800bf8:	73 2e                	jae    800c28 <memmove+0x47>
		s += n;
		d += n;
  800bfa:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bfd:	89 d6                	mov    %edx,%esi
  800bff:	09 fe                	or     %edi,%esi
  800c01:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c07:	75 13                	jne    800c1c <memmove+0x3b>
  800c09:	f6 c1 03             	test   $0x3,%cl
  800c0c:	75 0e                	jne    800c1c <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  800c0e:	83 ef 04             	sub    $0x4,%edi
  800c11:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c14:	c1 e9 02             	shr    $0x2,%ecx
  800c17:	fd                   	std    
  800c18:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c1a:	eb 09                	jmp    800c25 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c1c:	83 ef 01             	sub    $0x1,%edi
  800c1f:	8d 72 ff             	lea    -0x1(%edx),%esi
  800c22:	fd                   	std    
  800c23:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c25:	fc                   	cld    
  800c26:	eb 1d                	jmp    800c45 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c28:	89 f2                	mov    %esi,%edx
  800c2a:	09 c2                	or     %eax,%edx
  800c2c:	f6 c2 03             	test   $0x3,%dl
  800c2f:	75 0f                	jne    800c40 <memmove+0x5f>
  800c31:	f6 c1 03             	test   $0x3,%cl
  800c34:	75 0a                	jne    800c40 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  800c36:	c1 e9 02             	shr    $0x2,%ecx
  800c39:	89 c7                	mov    %eax,%edi
  800c3b:	fc                   	cld    
  800c3c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c3e:	eb 05                	jmp    800c45 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c40:	89 c7                	mov    %eax,%edi
  800c42:	fc                   	cld    
  800c43:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c45:	5e                   	pop    %esi
  800c46:	5f                   	pop    %edi
  800c47:	5d                   	pop    %ebp
  800c48:	c3                   	ret    

00800c49 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c4c:	ff 75 10             	pushl  0x10(%ebp)
  800c4f:	ff 75 0c             	pushl  0xc(%ebp)
  800c52:	ff 75 08             	pushl  0x8(%ebp)
  800c55:	e8 87 ff ff ff       	call   800be1 <memmove>
}
  800c5a:	c9                   	leave  
  800c5b:	c3                   	ret    

00800c5c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	56                   	push   %esi
  800c60:	53                   	push   %ebx
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
  800c64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c67:	89 c6                	mov    %eax,%esi
  800c69:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c6c:	eb 1a                	jmp    800c88 <memcmp+0x2c>
		if (*s1 != *s2)
  800c6e:	0f b6 08             	movzbl (%eax),%ecx
  800c71:	0f b6 1a             	movzbl (%edx),%ebx
  800c74:	38 d9                	cmp    %bl,%cl
  800c76:	74 0a                	je     800c82 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800c78:	0f b6 c1             	movzbl %cl,%eax
  800c7b:	0f b6 db             	movzbl %bl,%ebx
  800c7e:	29 d8                	sub    %ebx,%eax
  800c80:	eb 0f                	jmp    800c91 <memcmp+0x35>
		s1++, s2++;
  800c82:	83 c0 01             	add    $0x1,%eax
  800c85:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c88:	39 f0                	cmp    %esi,%eax
  800c8a:	75 e2                	jne    800c6e <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c91:	5b                   	pop    %ebx
  800c92:	5e                   	pop    %esi
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    

00800c95 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	53                   	push   %ebx
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800c9c:	89 c1                	mov    %eax,%ecx
  800c9e:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  800ca1:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ca5:	eb 0a                	jmp    800cb1 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ca7:	0f b6 10             	movzbl (%eax),%edx
  800caa:	39 da                	cmp    %ebx,%edx
  800cac:	74 07                	je     800cb5 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800cae:	83 c0 01             	add    $0x1,%eax
  800cb1:	39 c8                	cmp    %ecx,%eax
  800cb3:	72 f2                	jb     800ca7 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800cb5:	5b                   	pop    %ebx
  800cb6:	5d                   	pop    %ebp
  800cb7:	c3                   	ret    

00800cb8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	57                   	push   %edi
  800cbc:	56                   	push   %esi
  800cbd:	53                   	push   %ebx
  800cbe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cc1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cc4:	eb 03                	jmp    800cc9 <strtol+0x11>
		s++;
  800cc6:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cc9:	0f b6 01             	movzbl (%ecx),%eax
  800ccc:	3c 20                	cmp    $0x20,%al
  800cce:	74 f6                	je     800cc6 <strtol+0xe>
  800cd0:	3c 09                	cmp    $0x9,%al
  800cd2:	74 f2                	je     800cc6 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cd4:	3c 2b                	cmp    $0x2b,%al
  800cd6:	75 0a                	jne    800ce2 <strtol+0x2a>
		s++;
  800cd8:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800cdb:	bf 00 00 00 00       	mov    $0x0,%edi
  800ce0:	eb 11                	jmp    800cf3 <strtol+0x3b>
  800ce2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800ce7:	3c 2d                	cmp    $0x2d,%al
  800ce9:	75 08                	jne    800cf3 <strtol+0x3b>
		s++, neg = 1;
  800ceb:	83 c1 01             	add    $0x1,%ecx
  800cee:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cf3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cf9:	75 15                	jne    800d10 <strtol+0x58>
  800cfb:	80 39 30             	cmpb   $0x30,(%ecx)
  800cfe:	75 10                	jne    800d10 <strtol+0x58>
  800d00:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d04:	75 7c                	jne    800d82 <strtol+0xca>
		s += 2, base = 16;
  800d06:	83 c1 02             	add    $0x2,%ecx
  800d09:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d0e:	eb 16                	jmp    800d26 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800d10:	85 db                	test   %ebx,%ebx
  800d12:	75 12                	jne    800d26 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d14:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d19:	80 39 30             	cmpb   $0x30,(%ecx)
  800d1c:	75 08                	jne    800d26 <strtol+0x6e>
		s++, base = 8;
  800d1e:	83 c1 01             	add    $0x1,%ecx
  800d21:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800d26:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2b:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d2e:	0f b6 11             	movzbl (%ecx),%edx
  800d31:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d34:	89 f3                	mov    %esi,%ebx
  800d36:	80 fb 09             	cmp    $0x9,%bl
  800d39:	77 08                	ja     800d43 <strtol+0x8b>
			dig = *s - '0';
  800d3b:	0f be d2             	movsbl %dl,%edx
  800d3e:	83 ea 30             	sub    $0x30,%edx
  800d41:	eb 22                	jmp    800d65 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800d43:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d46:	89 f3                	mov    %esi,%ebx
  800d48:	80 fb 19             	cmp    $0x19,%bl
  800d4b:	77 08                	ja     800d55 <strtol+0x9d>
			dig = *s - 'a' + 10;
  800d4d:	0f be d2             	movsbl %dl,%edx
  800d50:	83 ea 57             	sub    $0x57,%edx
  800d53:	eb 10                	jmp    800d65 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800d55:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d58:	89 f3                	mov    %esi,%ebx
  800d5a:	80 fb 19             	cmp    $0x19,%bl
  800d5d:	77 16                	ja     800d75 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800d5f:	0f be d2             	movsbl %dl,%edx
  800d62:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800d65:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d68:	7d 0b                	jge    800d75 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800d6a:	83 c1 01             	add    $0x1,%ecx
  800d6d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d71:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800d73:	eb b9                	jmp    800d2e <strtol+0x76>

	if (endptr)
  800d75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d79:	74 0d                	je     800d88 <strtol+0xd0>
		*endptr = (char *) s;
  800d7b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d7e:	89 0e                	mov    %ecx,(%esi)
  800d80:	eb 06                	jmp    800d88 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d82:	85 db                	test   %ebx,%ebx
  800d84:	74 98                	je     800d1e <strtol+0x66>
  800d86:	eb 9e                	jmp    800d26 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800d88:	89 c2                	mov    %eax,%edx
  800d8a:	f7 da                	neg    %edx
  800d8c:	85 ff                	test   %edi,%edi
  800d8e:	0f 45 c2             	cmovne %edx,%eax
}
  800d91:	5b                   	pop    %ebx
  800d92:	5e                   	pop    %esi
  800d93:	5f                   	pop    %edi
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    

00800d96 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	57                   	push   %edi
  800d9a:	56                   	push   %esi
  800d9b:	53                   	push   %ebx
  800d9c:	83 ec 1c             	sub    $0x1c,%esp
  800d9f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800da2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800da5:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800da7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800daa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800dad:	8b 7d 10             	mov    0x10(%ebp),%edi
  800db0:	8b 75 14             	mov    0x14(%ebp),%esi
  800db3:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800db5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800db9:	74 1d                	je     800dd8 <syscall+0x42>
  800dbb:	85 c0                	test   %eax,%eax
  800dbd:	7e 19                	jle    800dd8 <syscall+0x42>
  800dbf:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc2:	83 ec 0c             	sub    $0xc,%esp
  800dc5:	50                   	push   %eax
  800dc6:	52                   	push   %edx
  800dc7:	68 bf 29 80 00       	push   $0x8029bf
  800dcc:	6a 23                	push   $0x23
  800dce:	68 dc 29 80 00       	push   $0x8029dc
  800dd3:	e8 2b f6 ff ff       	call   800403 <_panic>

	return ret;
}
  800dd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddb:	5b                   	pop    %ebx
  800ddc:	5e                   	pop    %esi
  800ddd:	5f                   	pop    %edi
  800dde:	5d                   	pop    %ebp
  800ddf:	c3                   	ret    

00800de0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800de6:	6a 00                	push   $0x0
  800de8:	6a 00                	push   $0x0
  800dea:	6a 00                	push   $0x0
  800dec:	ff 75 0c             	pushl  0xc(%ebp)
  800def:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800df2:	ba 00 00 00 00       	mov    $0x0,%edx
  800df7:	b8 00 00 00 00       	mov    $0x0,%eax
  800dfc:	e8 95 ff ff ff       	call   800d96 <syscall>
}
  800e01:	83 c4 10             	add    $0x10,%esp
  800e04:	c9                   	leave  
  800e05:	c3                   	ret    

00800e06 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800e0c:	6a 00                	push   $0x0
  800e0e:	6a 00                	push   $0x0
  800e10:	6a 00                	push   $0x0
  800e12:	6a 00                	push   $0x0
  800e14:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e19:	ba 00 00 00 00       	mov    $0x0,%edx
  800e1e:	b8 01 00 00 00       	mov    $0x1,%eax
  800e23:	e8 6e ff ff ff       	call   800d96 <syscall>
}
  800e28:	c9                   	leave  
  800e29:	c3                   	ret    

00800e2a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800e30:	6a 00                	push   $0x0
  800e32:	6a 00                	push   $0x0
  800e34:	6a 00                	push   $0x0
  800e36:	6a 00                	push   $0x0
  800e38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e3b:	ba 01 00 00 00       	mov    $0x1,%edx
  800e40:	b8 03 00 00 00       	mov    $0x3,%eax
  800e45:	e8 4c ff ff ff       	call   800d96 <syscall>
}
  800e4a:	c9                   	leave  
  800e4b:	c3                   	ret    

00800e4c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800e52:	6a 00                	push   $0x0
  800e54:	6a 00                	push   $0x0
  800e56:	6a 00                	push   $0x0
  800e58:	6a 00                	push   $0x0
  800e5a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e5f:	ba 00 00 00 00       	mov    $0x0,%edx
  800e64:	b8 02 00 00 00       	mov    $0x2,%eax
  800e69:	e8 28 ff ff ff       	call   800d96 <syscall>
}
  800e6e:	c9                   	leave  
  800e6f:	c3                   	ret    

00800e70 <sys_yield>:

void
sys_yield(void)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800e76:	6a 00                	push   $0x0
  800e78:	6a 00                	push   $0x0
  800e7a:	6a 00                	push   $0x0
  800e7c:	6a 00                	push   $0x0
  800e7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e83:	ba 00 00 00 00       	mov    $0x0,%edx
  800e88:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e8d:	e8 04 ff ff ff       	call   800d96 <syscall>
}
  800e92:	83 c4 10             	add    $0x10,%esp
  800e95:	c9                   	leave  
  800e96:	c3                   	ret    

00800e97 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800e9d:	6a 00                	push   $0x0
  800e9f:	6a 00                	push   $0x0
  800ea1:	ff 75 10             	pushl  0x10(%ebp)
  800ea4:	ff 75 0c             	pushl  0xc(%ebp)
  800ea7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eaa:	ba 01 00 00 00       	mov    $0x1,%edx
  800eaf:	b8 04 00 00 00       	mov    $0x4,%eax
  800eb4:	e8 dd fe ff ff       	call   800d96 <syscall>
}
  800eb9:	c9                   	leave  
  800eba:	c3                   	ret    

00800ebb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800ec1:	ff 75 18             	pushl  0x18(%ebp)
  800ec4:	ff 75 14             	pushl  0x14(%ebp)
  800ec7:	ff 75 10             	pushl  0x10(%ebp)
  800eca:	ff 75 0c             	pushl  0xc(%ebp)
  800ecd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ed0:	ba 01 00 00 00       	mov    $0x1,%edx
  800ed5:	b8 05 00 00 00       	mov    $0x5,%eax
  800eda:	e8 b7 fe ff ff       	call   800d96 <syscall>
}
  800edf:	c9                   	leave  
  800ee0:	c3                   	ret    

00800ee1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ee1:	55                   	push   %ebp
  800ee2:	89 e5                	mov    %esp,%ebp
  800ee4:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800ee7:	6a 00                	push   $0x0
  800ee9:	6a 00                	push   $0x0
  800eeb:	6a 00                	push   $0x0
  800eed:	ff 75 0c             	pushl  0xc(%ebp)
  800ef0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ef3:	ba 01 00 00 00       	mov    $0x1,%edx
  800ef8:	b8 06 00 00 00       	mov    $0x6,%eax
  800efd:	e8 94 fe ff ff       	call   800d96 <syscall>
}
  800f02:	c9                   	leave  
  800f03:	c3                   	ret    

00800f04 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800f0a:	6a 00                	push   $0x0
  800f0c:	6a 00                	push   $0x0
  800f0e:	6a 00                	push   $0x0
  800f10:	ff 75 0c             	pushl  0xc(%ebp)
  800f13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f16:	ba 01 00 00 00       	mov    $0x1,%edx
  800f1b:	b8 08 00 00 00       	mov    $0x8,%eax
  800f20:	e8 71 fe ff ff       	call   800d96 <syscall>
}
  800f25:	c9                   	leave  
  800f26:	c3                   	ret    

00800f27 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
  800f2a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800f2d:	6a 00                	push   $0x0
  800f2f:	6a 00                	push   $0x0
  800f31:	6a 00                	push   $0x0
  800f33:	ff 75 0c             	pushl  0xc(%ebp)
  800f36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f39:	ba 01 00 00 00       	mov    $0x1,%edx
  800f3e:	b8 09 00 00 00       	mov    $0x9,%eax
  800f43:	e8 4e fe ff ff       	call   800d96 <syscall>
}
  800f48:	c9                   	leave  
  800f49:	c3                   	ret    

00800f4a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800f50:	6a 00                	push   $0x0
  800f52:	6a 00                	push   $0x0
  800f54:	6a 00                	push   $0x0
  800f56:	ff 75 0c             	pushl  0xc(%ebp)
  800f59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f5c:	ba 01 00 00 00       	mov    $0x1,%edx
  800f61:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f66:	e8 2b fe ff ff       	call   800d96 <syscall>
}
  800f6b:	c9                   	leave  
  800f6c:	c3                   	ret    

00800f6d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
  800f70:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800f73:	6a 00                	push   $0x0
  800f75:	ff 75 14             	pushl  0x14(%ebp)
  800f78:	ff 75 10             	pushl  0x10(%ebp)
  800f7b:	ff 75 0c             	pushl  0xc(%ebp)
  800f7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f81:	ba 00 00 00 00       	mov    $0x0,%edx
  800f86:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f8b:	e8 06 fe ff ff       	call   800d96 <syscall>
}
  800f90:	c9                   	leave  
  800f91:	c3                   	ret    

00800f92 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800f98:	6a 00                	push   $0x0
  800f9a:	6a 00                	push   $0x0
  800f9c:	6a 00                	push   $0x0
  800f9e:	6a 00                	push   $0x0
  800fa0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fa3:	ba 01 00 00 00       	mov    $0x1,%edx
  800fa8:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fad:	e8 e4 fd ff ff       	call   800d96 <syscall>
}
  800fb2:	c9                   	leave  
  800fb3:	c3                   	ret    

00800fb4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	05 00 00 00 30       	add    $0x30000000,%eax
  800fbf:	c1 e8 0c             	shr    $0xc,%eax
}
  800fc2:	5d                   	pop    %ebp
  800fc3:	c3                   	ret    

00800fc4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  800fc7:	ff 75 08             	pushl  0x8(%ebp)
  800fca:	e8 e5 ff ff ff       	call   800fb4 <fd2num>
  800fcf:	83 c4 04             	add    $0x4,%esp
  800fd2:	c1 e0 0c             	shl    $0xc,%eax
  800fd5:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fe2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fe7:	89 c2                	mov    %eax,%edx
  800fe9:	c1 ea 16             	shr    $0x16,%edx
  800fec:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ff3:	f6 c2 01             	test   $0x1,%dl
  800ff6:	74 11                	je     801009 <fd_alloc+0x2d>
  800ff8:	89 c2                	mov    %eax,%edx
  800ffa:	c1 ea 0c             	shr    $0xc,%edx
  800ffd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801004:	f6 c2 01             	test   $0x1,%dl
  801007:	75 09                	jne    801012 <fd_alloc+0x36>
			*fd_store = fd;
  801009:	89 01                	mov    %eax,(%ecx)
			return 0;
  80100b:	b8 00 00 00 00       	mov    $0x0,%eax
  801010:	eb 17                	jmp    801029 <fd_alloc+0x4d>
  801012:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801017:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80101c:	75 c9                	jne    800fe7 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80101e:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801024:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801029:	5d                   	pop    %ebp
  80102a:	c3                   	ret    

0080102b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801031:	83 f8 1f             	cmp    $0x1f,%eax
  801034:	77 36                	ja     80106c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801036:	c1 e0 0c             	shl    $0xc,%eax
  801039:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80103e:	89 c2                	mov    %eax,%edx
  801040:	c1 ea 16             	shr    $0x16,%edx
  801043:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80104a:	f6 c2 01             	test   $0x1,%dl
  80104d:	74 24                	je     801073 <fd_lookup+0x48>
  80104f:	89 c2                	mov    %eax,%edx
  801051:	c1 ea 0c             	shr    $0xc,%edx
  801054:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80105b:	f6 c2 01             	test   $0x1,%dl
  80105e:	74 1a                	je     80107a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801060:	8b 55 0c             	mov    0xc(%ebp),%edx
  801063:	89 02                	mov    %eax,(%edx)
	return 0;
  801065:	b8 00 00 00 00       	mov    $0x0,%eax
  80106a:	eb 13                	jmp    80107f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80106c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801071:	eb 0c                	jmp    80107f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801073:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801078:	eb 05                	jmp    80107f <fd_lookup+0x54>
  80107a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80107f:	5d                   	pop    %ebp
  801080:	c3                   	ret    

00801081 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	83 ec 08             	sub    $0x8,%esp
  801087:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80108a:	ba 68 2a 80 00       	mov    $0x802a68,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80108f:	eb 13                	jmp    8010a4 <dev_lookup+0x23>
  801091:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  801094:	39 08                	cmp    %ecx,(%eax)
  801096:	75 0c                	jne    8010a4 <dev_lookup+0x23>
			*dev = devtab[i];
  801098:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80109d:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a2:	eb 2e                	jmp    8010d2 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8010a4:	8b 02                	mov    (%edx),%eax
  8010a6:	85 c0                	test   %eax,%eax
  8010a8:	75 e7                	jne    801091 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010aa:	a1 90 67 80 00       	mov    0x806790,%eax
  8010af:	8b 40 48             	mov    0x48(%eax),%eax
  8010b2:	83 ec 04             	sub    $0x4,%esp
  8010b5:	51                   	push   %ecx
  8010b6:	50                   	push   %eax
  8010b7:	68 ec 29 80 00       	push   $0x8029ec
  8010bc:	e8 1b f4 ff ff       	call   8004dc <cprintf>
	*dev = 0;
  8010c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010ca:	83 c4 10             	add    $0x10,%esp
  8010cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010d2:	c9                   	leave  
  8010d3:	c3                   	ret    

008010d4 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	56                   	push   %esi
  8010d8:	53                   	push   %ebx
  8010d9:	83 ec 10             	sub    $0x10,%esp
  8010dc:	8b 75 08             	mov    0x8(%ebp),%esi
  8010df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010e2:	56                   	push   %esi
  8010e3:	e8 cc fe ff ff       	call   800fb4 <fd2num>
  8010e8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8010eb:	89 14 24             	mov    %edx,(%esp)
  8010ee:	50                   	push   %eax
  8010ef:	e8 37 ff ff ff       	call   80102b <fd_lookup>
  8010f4:	83 c4 08             	add    $0x8,%esp
  8010f7:	85 c0                	test   %eax,%eax
  8010f9:	78 05                	js     801100 <fd_close+0x2c>
	    || fd != fd2)
  8010fb:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8010fe:	74 0c                	je     80110c <fd_close+0x38>
		return (must_exist ? r : 0);
  801100:	84 db                	test   %bl,%bl
  801102:	ba 00 00 00 00       	mov    $0x0,%edx
  801107:	0f 44 c2             	cmove  %edx,%eax
  80110a:	eb 41                	jmp    80114d <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80110c:	83 ec 08             	sub    $0x8,%esp
  80110f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801112:	50                   	push   %eax
  801113:	ff 36                	pushl  (%esi)
  801115:	e8 67 ff ff ff       	call   801081 <dev_lookup>
  80111a:	89 c3                	mov    %eax,%ebx
  80111c:	83 c4 10             	add    $0x10,%esp
  80111f:	85 c0                	test   %eax,%eax
  801121:	78 1a                	js     80113d <fd_close+0x69>
		if (dev->dev_close)
  801123:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801126:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801129:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80112e:	85 c0                	test   %eax,%eax
  801130:	74 0b                	je     80113d <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  801132:	83 ec 0c             	sub    $0xc,%esp
  801135:	56                   	push   %esi
  801136:	ff d0                	call   *%eax
  801138:	89 c3                	mov    %eax,%ebx
  80113a:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80113d:	83 ec 08             	sub    $0x8,%esp
  801140:	56                   	push   %esi
  801141:	6a 00                	push   $0x0
  801143:	e8 99 fd ff ff       	call   800ee1 <sys_page_unmap>
	return r;
  801148:	83 c4 10             	add    $0x10,%esp
  80114b:	89 d8                	mov    %ebx,%eax
}
  80114d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801150:	5b                   	pop    %ebx
  801151:	5e                   	pop    %esi
  801152:	5d                   	pop    %ebp
  801153:	c3                   	ret    

00801154 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801154:	55                   	push   %ebp
  801155:	89 e5                	mov    %esp,%ebp
  801157:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80115a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80115d:	50                   	push   %eax
  80115e:	ff 75 08             	pushl  0x8(%ebp)
  801161:	e8 c5 fe ff ff       	call   80102b <fd_lookup>
  801166:	83 c4 08             	add    $0x8,%esp
  801169:	85 c0                	test   %eax,%eax
  80116b:	78 10                	js     80117d <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80116d:	83 ec 08             	sub    $0x8,%esp
  801170:	6a 01                	push   $0x1
  801172:	ff 75 f4             	pushl  -0xc(%ebp)
  801175:	e8 5a ff ff ff       	call   8010d4 <fd_close>
  80117a:	83 c4 10             	add    $0x10,%esp
}
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <close_all>:

void
close_all(void)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	53                   	push   %ebx
  801183:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801186:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80118b:	83 ec 0c             	sub    $0xc,%esp
  80118e:	53                   	push   %ebx
  80118f:	e8 c0 ff ff ff       	call   801154 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801194:	83 c3 01             	add    $0x1,%ebx
  801197:	83 c4 10             	add    $0x10,%esp
  80119a:	83 fb 20             	cmp    $0x20,%ebx
  80119d:	75 ec                	jne    80118b <close_all+0xc>
		close(i);
}
  80119f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011a2:	c9                   	leave  
  8011a3:	c3                   	ret    

008011a4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
  8011a7:	57                   	push   %edi
  8011a8:	56                   	push   %esi
  8011a9:	53                   	push   %ebx
  8011aa:	83 ec 2c             	sub    $0x2c,%esp
  8011ad:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011b0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011b3:	50                   	push   %eax
  8011b4:	ff 75 08             	pushl  0x8(%ebp)
  8011b7:	e8 6f fe ff ff       	call   80102b <fd_lookup>
  8011bc:	83 c4 08             	add    $0x8,%esp
  8011bf:	85 c0                	test   %eax,%eax
  8011c1:	0f 88 c1 00 00 00    	js     801288 <dup+0xe4>
		return r;
	close(newfdnum);
  8011c7:	83 ec 0c             	sub    $0xc,%esp
  8011ca:	56                   	push   %esi
  8011cb:	e8 84 ff ff ff       	call   801154 <close>

	newfd = INDEX2FD(newfdnum);
  8011d0:	89 f3                	mov    %esi,%ebx
  8011d2:	c1 e3 0c             	shl    $0xc,%ebx
  8011d5:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8011db:	83 c4 04             	add    $0x4,%esp
  8011de:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011e1:	e8 de fd ff ff       	call   800fc4 <fd2data>
  8011e6:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  8011e8:	89 1c 24             	mov    %ebx,(%esp)
  8011eb:	e8 d4 fd ff ff       	call   800fc4 <fd2data>
  8011f0:	83 c4 10             	add    $0x10,%esp
  8011f3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011f6:	89 f8                	mov    %edi,%eax
  8011f8:	c1 e8 16             	shr    $0x16,%eax
  8011fb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801202:	a8 01                	test   $0x1,%al
  801204:	74 37                	je     80123d <dup+0x99>
  801206:	89 f8                	mov    %edi,%eax
  801208:	c1 e8 0c             	shr    $0xc,%eax
  80120b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801212:	f6 c2 01             	test   $0x1,%dl
  801215:	74 26                	je     80123d <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801217:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80121e:	83 ec 0c             	sub    $0xc,%esp
  801221:	25 07 0e 00 00       	and    $0xe07,%eax
  801226:	50                   	push   %eax
  801227:	ff 75 d4             	pushl  -0x2c(%ebp)
  80122a:	6a 00                	push   $0x0
  80122c:	57                   	push   %edi
  80122d:	6a 00                	push   $0x0
  80122f:	e8 87 fc ff ff       	call   800ebb <sys_page_map>
  801234:	89 c7                	mov    %eax,%edi
  801236:	83 c4 20             	add    $0x20,%esp
  801239:	85 c0                	test   %eax,%eax
  80123b:	78 2e                	js     80126b <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80123d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801240:	89 d0                	mov    %edx,%eax
  801242:	c1 e8 0c             	shr    $0xc,%eax
  801245:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80124c:	83 ec 0c             	sub    $0xc,%esp
  80124f:	25 07 0e 00 00       	and    $0xe07,%eax
  801254:	50                   	push   %eax
  801255:	53                   	push   %ebx
  801256:	6a 00                	push   $0x0
  801258:	52                   	push   %edx
  801259:	6a 00                	push   $0x0
  80125b:	e8 5b fc ff ff       	call   800ebb <sys_page_map>
  801260:	89 c7                	mov    %eax,%edi
  801262:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  801265:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801267:	85 ff                	test   %edi,%edi
  801269:	79 1d                	jns    801288 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80126b:	83 ec 08             	sub    $0x8,%esp
  80126e:	53                   	push   %ebx
  80126f:	6a 00                	push   $0x0
  801271:	e8 6b fc ff ff       	call   800ee1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801276:	83 c4 08             	add    $0x8,%esp
  801279:	ff 75 d4             	pushl  -0x2c(%ebp)
  80127c:	6a 00                	push   $0x0
  80127e:	e8 5e fc ff ff       	call   800ee1 <sys_page_unmap>
	return r;
  801283:	83 c4 10             	add    $0x10,%esp
  801286:	89 f8                	mov    %edi,%eax
}
  801288:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80128b:	5b                   	pop    %ebx
  80128c:	5e                   	pop    %esi
  80128d:	5f                   	pop    %edi
  80128e:	5d                   	pop    %ebp
  80128f:	c3                   	ret    

00801290 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	53                   	push   %ebx
  801294:	83 ec 14             	sub    $0x14,%esp
  801297:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80129a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80129d:	50                   	push   %eax
  80129e:	53                   	push   %ebx
  80129f:	e8 87 fd ff ff       	call   80102b <fd_lookup>
  8012a4:	83 c4 08             	add    $0x8,%esp
  8012a7:	89 c2                	mov    %eax,%edx
  8012a9:	85 c0                	test   %eax,%eax
  8012ab:	78 6d                	js     80131a <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012ad:	83 ec 08             	sub    $0x8,%esp
  8012b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b3:	50                   	push   %eax
  8012b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b7:	ff 30                	pushl  (%eax)
  8012b9:	e8 c3 fd ff ff       	call   801081 <dev_lookup>
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	85 c0                	test   %eax,%eax
  8012c3:	78 4c                	js     801311 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012c8:	8b 42 08             	mov    0x8(%edx),%eax
  8012cb:	83 e0 03             	and    $0x3,%eax
  8012ce:	83 f8 01             	cmp    $0x1,%eax
  8012d1:	75 21                	jne    8012f4 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012d3:	a1 90 67 80 00       	mov    0x806790,%eax
  8012d8:	8b 40 48             	mov    0x48(%eax),%eax
  8012db:	83 ec 04             	sub    $0x4,%esp
  8012de:	53                   	push   %ebx
  8012df:	50                   	push   %eax
  8012e0:	68 2d 2a 80 00       	push   $0x802a2d
  8012e5:	e8 f2 f1 ff ff       	call   8004dc <cprintf>
		return -E_INVAL;
  8012ea:	83 c4 10             	add    $0x10,%esp
  8012ed:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8012f2:	eb 26                	jmp    80131a <read+0x8a>
	}
	if (!dev->dev_read)
  8012f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f7:	8b 40 08             	mov    0x8(%eax),%eax
  8012fa:	85 c0                	test   %eax,%eax
  8012fc:	74 17                	je     801315 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012fe:	83 ec 04             	sub    $0x4,%esp
  801301:	ff 75 10             	pushl  0x10(%ebp)
  801304:	ff 75 0c             	pushl  0xc(%ebp)
  801307:	52                   	push   %edx
  801308:	ff d0                	call   *%eax
  80130a:	89 c2                	mov    %eax,%edx
  80130c:	83 c4 10             	add    $0x10,%esp
  80130f:	eb 09                	jmp    80131a <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801311:	89 c2                	mov    %eax,%edx
  801313:	eb 05                	jmp    80131a <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801315:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  80131a:	89 d0                	mov    %edx,%eax
  80131c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80131f:	c9                   	leave  
  801320:	c3                   	ret    

00801321 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	57                   	push   %edi
  801325:	56                   	push   %esi
  801326:	53                   	push   %ebx
  801327:	83 ec 0c             	sub    $0xc,%esp
  80132a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80132d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801330:	bb 00 00 00 00       	mov    $0x0,%ebx
  801335:	eb 21                	jmp    801358 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801337:	83 ec 04             	sub    $0x4,%esp
  80133a:	89 f0                	mov    %esi,%eax
  80133c:	29 d8                	sub    %ebx,%eax
  80133e:	50                   	push   %eax
  80133f:	89 d8                	mov    %ebx,%eax
  801341:	03 45 0c             	add    0xc(%ebp),%eax
  801344:	50                   	push   %eax
  801345:	57                   	push   %edi
  801346:	e8 45 ff ff ff       	call   801290 <read>
		if (m < 0)
  80134b:	83 c4 10             	add    $0x10,%esp
  80134e:	85 c0                	test   %eax,%eax
  801350:	78 10                	js     801362 <readn+0x41>
			return m;
		if (m == 0)
  801352:	85 c0                	test   %eax,%eax
  801354:	74 0a                	je     801360 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801356:	01 c3                	add    %eax,%ebx
  801358:	39 f3                	cmp    %esi,%ebx
  80135a:	72 db                	jb     801337 <readn+0x16>
  80135c:	89 d8                	mov    %ebx,%eax
  80135e:	eb 02                	jmp    801362 <readn+0x41>
  801360:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801362:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801365:	5b                   	pop    %ebx
  801366:	5e                   	pop    %esi
  801367:	5f                   	pop    %edi
  801368:	5d                   	pop    %ebp
  801369:	c3                   	ret    

0080136a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	53                   	push   %ebx
  80136e:	83 ec 14             	sub    $0x14,%esp
  801371:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801374:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801377:	50                   	push   %eax
  801378:	53                   	push   %ebx
  801379:	e8 ad fc ff ff       	call   80102b <fd_lookup>
  80137e:	83 c4 08             	add    $0x8,%esp
  801381:	89 c2                	mov    %eax,%edx
  801383:	85 c0                	test   %eax,%eax
  801385:	78 68                	js     8013ef <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801387:	83 ec 08             	sub    $0x8,%esp
  80138a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80138d:	50                   	push   %eax
  80138e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801391:	ff 30                	pushl  (%eax)
  801393:	e8 e9 fc ff ff       	call   801081 <dev_lookup>
  801398:	83 c4 10             	add    $0x10,%esp
  80139b:	85 c0                	test   %eax,%eax
  80139d:	78 47                	js     8013e6 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80139f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013a6:	75 21                	jne    8013c9 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013a8:	a1 90 67 80 00       	mov    0x806790,%eax
  8013ad:	8b 40 48             	mov    0x48(%eax),%eax
  8013b0:	83 ec 04             	sub    $0x4,%esp
  8013b3:	53                   	push   %ebx
  8013b4:	50                   	push   %eax
  8013b5:	68 49 2a 80 00       	push   $0x802a49
  8013ba:	e8 1d f1 ff ff       	call   8004dc <cprintf>
		return -E_INVAL;
  8013bf:	83 c4 10             	add    $0x10,%esp
  8013c2:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8013c7:	eb 26                	jmp    8013ef <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013cc:	8b 52 0c             	mov    0xc(%edx),%edx
  8013cf:	85 d2                	test   %edx,%edx
  8013d1:	74 17                	je     8013ea <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013d3:	83 ec 04             	sub    $0x4,%esp
  8013d6:	ff 75 10             	pushl  0x10(%ebp)
  8013d9:	ff 75 0c             	pushl  0xc(%ebp)
  8013dc:	50                   	push   %eax
  8013dd:	ff d2                	call   *%edx
  8013df:	89 c2                	mov    %eax,%edx
  8013e1:	83 c4 10             	add    $0x10,%esp
  8013e4:	eb 09                	jmp    8013ef <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013e6:	89 c2                	mov    %eax,%edx
  8013e8:	eb 05                	jmp    8013ef <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8013ea:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  8013ef:	89 d0                	mov    %edx,%eax
  8013f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013f4:	c9                   	leave  
  8013f5:	c3                   	ret    

008013f6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
  8013f9:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013fc:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8013ff:	50                   	push   %eax
  801400:	ff 75 08             	pushl  0x8(%ebp)
  801403:	e8 23 fc ff ff       	call   80102b <fd_lookup>
  801408:	83 c4 08             	add    $0x8,%esp
  80140b:	85 c0                	test   %eax,%eax
  80140d:	78 0e                	js     80141d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80140f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801412:	8b 55 0c             	mov    0xc(%ebp),%edx
  801415:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801418:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80141d:	c9                   	leave  
  80141e:	c3                   	ret    

0080141f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	53                   	push   %ebx
  801423:	83 ec 14             	sub    $0x14,%esp
  801426:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801429:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80142c:	50                   	push   %eax
  80142d:	53                   	push   %ebx
  80142e:	e8 f8 fb ff ff       	call   80102b <fd_lookup>
  801433:	83 c4 08             	add    $0x8,%esp
  801436:	89 c2                	mov    %eax,%edx
  801438:	85 c0                	test   %eax,%eax
  80143a:	78 65                	js     8014a1 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80143c:	83 ec 08             	sub    $0x8,%esp
  80143f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801442:	50                   	push   %eax
  801443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801446:	ff 30                	pushl  (%eax)
  801448:	e8 34 fc ff ff       	call   801081 <dev_lookup>
  80144d:	83 c4 10             	add    $0x10,%esp
  801450:	85 c0                	test   %eax,%eax
  801452:	78 44                	js     801498 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801454:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801457:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80145b:	75 21                	jne    80147e <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80145d:	a1 90 67 80 00       	mov    0x806790,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801462:	8b 40 48             	mov    0x48(%eax),%eax
  801465:	83 ec 04             	sub    $0x4,%esp
  801468:	53                   	push   %ebx
  801469:	50                   	push   %eax
  80146a:	68 0c 2a 80 00       	push   $0x802a0c
  80146f:	e8 68 f0 ff ff       	call   8004dc <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801474:	83 c4 10             	add    $0x10,%esp
  801477:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80147c:	eb 23                	jmp    8014a1 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  80147e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801481:	8b 52 18             	mov    0x18(%edx),%edx
  801484:	85 d2                	test   %edx,%edx
  801486:	74 14                	je     80149c <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801488:	83 ec 08             	sub    $0x8,%esp
  80148b:	ff 75 0c             	pushl  0xc(%ebp)
  80148e:	50                   	push   %eax
  80148f:	ff d2                	call   *%edx
  801491:	89 c2                	mov    %eax,%edx
  801493:	83 c4 10             	add    $0x10,%esp
  801496:	eb 09                	jmp    8014a1 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801498:	89 c2                	mov    %eax,%edx
  80149a:	eb 05                	jmp    8014a1 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80149c:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  8014a1:	89 d0                	mov    %edx,%eax
  8014a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a6:	c9                   	leave  
  8014a7:	c3                   	ret    

008014a8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
  8014ab:	53                   	push   %ebx
  8014ac:	83 ec 14             	sub    $0x14,%esp
  8014af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014b5:	50                   	push   %eax
  8014b6:	ff 75 08             	pushl  0x8(%ebp)
  8014b9:	e8 6d fb ff ff       	call   80102b <fd_lookup>
  8014be:	83 c4 08             	add    $0x8,%esp
  8014c1:	89 c2                	mov    %eax,%edx
  8014c3:	85 c0                	test   %eax,%eax
  8014c5:	78 58                	js     80151f <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014c7:	83 ec 08             	sub    $0x8,%esp
  8014ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014cd:	50                   	push   %eax
  8014ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d1:	ff 30                	pushl  (%eax)
  8014d3:	e8 a9 fb ff ff       	call   801081 <dev_lookup>
  8014d8:	83 c4 10             	add    $0x10,%esp
  8014db:	85 c0                	test   %eax,%eax
  8014dd:	78 37                	js     801516 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  8014df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e2:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014e6:	74 32                	je     80151a <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014e8:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014eb:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014f2:	00 00 00 
	stat->st_isdir = 0;
  8014f5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014fc:	00 00 00 
	stat->st_dev = dev;
  8014ff:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801505:	83 ec 08             	sub    $0x8,%esp
  801508:	53                   	push   %ebx
  801509:	ff 75 f0             	pushl  -0x10(%ebp)
  80150c:	ff 50 14             	call   *0x14(%eax)
  80150f:	89 c2                	mov    %eax,%edx
  801511:	83 c4 10             	add    $0x10,%esp
  801514:	eb 09                	jmp    80151f <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801516:	89 c2                	mov    %eax,%edx
  801518:	eb 05                	jmp    80151f <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  80151a:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80151f:	89 d0                	mov    %edx,%eax
  801521:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801524:	c9                   	leave  
  801525:	c3                   	ret    

00801526 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	56                   	push   %esi
  80152a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80152b:	83 ec 08             	sub    $0x8,%esp
  80152e:	6a 00                	push   $0x0
  801530:	ff 75 08             	pushl  0x8(%ebp)
  801533:	e8 06 02 00 00       	call   80173e <open>
  801538:	89 c3                	mov    %eax,%ebx
  80153a:	83 c4 10             	add    $0x10,%esp
  80153d:	85 c0                	test   %eax,%eax
  80153f:	78 1b                	js     80155c <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801541:	83 ec 08             	sub    $0x8,%esp
  801544:	ff 75 0c             	pushl  0xc(%ebp)
  801547:	50                   	push   %eax
  801548:	e8 5b ff ff ff       	call   8014a8 <fstat>
  80154d:	89 c6                	mov    %eax,%esi
	close(fd);
  80154f:	89 1c 24             	mov    %ebx,(%esp)
  801552:	e8 fd fb ff ff       	call   801154 <close>
	return r;
  801557:	83 c4 10             	add    $0x10,%esp
  80155a:	89 f0                	mov    %esi,%eax
}
  80155c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80155f:	5b                   	pop    %ebx
  801560:	5e                   	pop    %esi
  801561:	5d                   	pop    %ebp
  801562:	c3                   	ret    

00801563 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
  801566:	56                   	push   %esi
  801567:	53                   	push   %ebx
  801568:	89 c6                	mov    %eax,%esi
  80156a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80156c:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801573:	75 12                	jne    801587 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801575:	83 ec 0c             	sub    $0xc,%esp
  801578:	6a 01                	push   $0x1
  80157a:	e8 b3 0c 00 00       	call   802232 <ipc_find_env>
  80157f:	a3 00 50 80 00       	mov    %eax,0x805000
  801584:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801587:	6a 07                	push   $0x7
  801589:	68 00 70 80 00       	push   $0x807000
  80158e:	56                   	push   %esi
  80158f:	ff 35 00 50 80 00    	pushl  0x805000
  801595:	e8 44 0c 00 00       	call   8021de <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80159a:	83 c4 0c             	add    $0xc,%esp
  80159d:	6a 00                	push   $0x0
  80159f:	53                   	push   %ebx
  8015a0:	6a 00                	push   $0x0
  8015a2:	e8 cc 0b 00 00       	call   802173 <ipc_recv>
}
  8015a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015aa:	5b                   	pop    %ebx
  8015ab:	5e                   	pop    %esi
  8015ac:	5d                   	pop    %ebp
  8015ad:	c3                   	ret    

008015ae <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ba:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  8015bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c2:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015cc:	b8 02 00 00 00       	mov    $0x2,%eax
  8015d1:	e8 8d ff ff ff       	call   801563 <fsipc>
}
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015de:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e4:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  8015e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ee:	b8 06 00 00 00       	mov    $0x6,%eax
  8015f3:	e8 6b ff ff ff       	call   801563 <fsipc>
}
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	53                   	push   %ebx
  8015fe:	83 ec 04             	sub    $0x4,%esp
  801601:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
  801607:	8b 40 0c             	mov    0xc(%eax),%eax
  80160a:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80160f:	ba 00 00 00 00       	mov    $0x0,%edx
  801614:	b8 05 00 00 00       	mov    $0x5,%eax
  801619:	e8 45 ff ff ff       	call   801563 <fsipc>
  80161e:	85 c0                	test   %eax,%eax
  801620:	78 2c                	js     80164e <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801622:	83 ec 08             	sub    $0x8,%esp
  801625:	68 00 70 80 00       	push   $0x807000
  80162a:	53                   	push   %ebx
  80162b:	e8 1e f4 ff ff       	call   800a4e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801630:	a1 80 70 80 00       	mov    0x807080,%eax
  801635:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80163b:	a1 84 70 80 00       	mov    0x807084,%eax
  801640:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801646:	83 c4 10             	add    $0x10,%esp
  801649:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80164e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801651:	c9                   	leave  
  801652:	c3                   	ret    

00801653 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	83 ec 08             	sub    $0x8,%esp
  801659:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165c:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80165f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801662:	8b 49 0c             	mov    0xc(%ecx),%ecx
  801665:	89 0d 00 70 80 00    	mov    %ecx,0x807000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  80166b:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801670:	76 22                	jbe    801694 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  801672:	c7 05 04 70 80 00 f8 	movl   $0xff8,0x807004
  801679:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  80167c:	83 ec 04             	sub    $0x4,%esp
  80167f:	68 f8 0f 00 00       	push   $0xff8
  801684:	52                   	push   %edx
  801685:	68 08 70 80 00       	push   $0x807008
  80168a:	e8 52 f5 ff ff       	call   800be1 <memmove>
  80168f:	83 c4 10             	add    $0x10,%esp
  801692:	eb 17                	jmp    8016ab <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  801694:	a3 04 70 80 00       	mov    %eax,0x807004
		memmove(fsipcbuf.write.req_buf, buf, n);
  801699:	83 ec 04             	sub    $0x4,%esp
  80169c:	50                   	push   %eax
  80169d:	52                   	push   %edx
  80169e:	68 08 70 80 00       	push   $0x807008
  8016a3:	e8 39 f5 ff ff       	call   800be1 <memmove>
  8016a8:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  8016ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b0:	b8 04 00 00 00       	mov    $0x4,%eax
  8016b5:	e8 a9 fe ff ff       	call   801563 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    

008016bc <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
  8016bf:	56                   	push   %esi
  8016c0:	53                   	push   %ebx
  8016c1:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ca:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  8016cf:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016da:	b8 03 00 00 00       	mov    $0x3,%eax
  8016df:	e8 7f fe ff ff       	call   801563 <fsipc>
  8016e4:	89 c3                	mov    %eax,%ebx
  8016e6:	85 c0                	test   %eax,%eax
  8016e8:	78 4b                	js     801735 <devfile_read+0x79>
		return r;
	assert(r <= n);
  8016ea:	39 c6                	cmp    %eax,%esi
  8016ec:	73 16                	jae    801704 <devfile_read+0x48>
  8016ee:	68 78 2a 80 00       	push   $0x802a78
  8016f3:	68 7f 2a 80 00       	push   $0x802a7f
  8016f8:	6a 7c                	push   $0x7c
  8016fa:	68 94 2a 80 00       	push   $0x802a94
  8016ff:	e8 ff ec ff ff       	call   800403 <_panic>
	assert(r <= PGSIZE);
  801704:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801709:	7e 16                	jle    801721 <devfile_read+0x65>
  80170b:	68 9f 2a 80 00       	push   $0x802a9f
  801710:	68 7f 2a 80 00       	push   $0x802a7f
  801715:	6a 7d                	push   $0x7d
  801717:	68 94 2a 80 00       	push   $0x802a94
  80171c:	e8 e2 ec ff ff       	call   800403 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801721:	83 ec 04             	sub    $0x4,%esp
  801724:	50                   	push   %eax
  801725:	68 00 70 80 00       	push   $0x807000
  80172a:	ff 75 0c             	pushl  0xc(%ebp)
  80172d:	e8 af f4 ff ff       	call   800be1 <memmove>
	return r;
  801732:	83 c4 10             	add    $0x10,%esp
}
  801735:	89 d8                	mov    %ebx,%eax
  801737:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80173a:	5b                   	pop    %ebx
  80173b:	5e                   	pop    %esi
  80173c:	5d                   	pop    %ebp
  80173d:	c3                   	ret    

0080173e <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	53                   	push   %ebx
  801742:	83 ec 20             	sub    $0x20,%esp
  801745:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801748:	53                   	push   %ebx
  801749:	e8 c7 f2 ff ff       	call   800a15 <strlen>
  80174e:	83 c4 10             	add    $0x10,%esp
  801751:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801756:	7f 67                	jg     8017bf <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801758:	83 ec 0c             	sub    $0xc,%esp
  80175b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80175e:	50                   	push   %eax
  80175f:	e8 78 f8 ff ff       	call   800fdc <fd_alloc>
  801764:	83 c4 10             	add    $0x10,%esp
		return r;
  801767:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801769:	85 c0                	test   %eax,%eax
  80176b:	78 57                	js     8017c4 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80176d:	83 ec 08             	sub    $0x8,%esp
  801770:	53                   	push   %ebx
  801771:	68 00 70 80 00       	push   $0x807000
  801776:	e8 d3 f2 ff ff       	call   800a4e <strcpy>
	fsipcbuf.open.req_omode = mode;
  80177b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177e:	a3 00 74 80 00       	mov    %eax,0x807400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801783:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801786:	b8 01 00 00 00       	mov    $0x1,%eax
  80178b:	e8 d3 fd ff ff       	call   801563 <fsipc>
  801790:	89 c3                	mov    %eax,%ebx
  801792:	83 c4 10             	add    $0x10,%esp
  801795:	85 c0                	test   %eax,%eax
  801797:	79 14                	jns    8017ad <open+0x6f>
		fd_close(fd, 0);
  801799:	83 ec 08             	sub    $0x8,%esp
  80179c:	6a 00                	push   $0x0
  80179e:	ff 75 f4             	pushl  -0xc(%ebp)
  8017a1:	e8 2e f9 ff ff       	call   8010d4 <fd_close>
		return r;
  8017a6:	83 c4 10             	add    $0x10,%esp
  8017a9:	89 da                	mov    %ebx,%edx
  8017ab:	eb 17                	jmp    8017c4 <open+0x86>
	}

	return fd2num(fd);
  8017ad:	83 ec 0c             	sub    $0xc,%esp
  8017b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8017b3:	e8 fc f7 ff ff       	call   800fb4 <fd2num>
  8017b8:	89 c2                	mov    %eax,%edx
  8017ba:	83 c4 10             	add    $0x10,%esp
  8017bd:	eb 05                	jmp    8017c4 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8017bf:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8017c4:	89 d0                	mov    %edx,%eax
  8017c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d6:	b8 08 00 00 00       	mov    $0x8,%eax
  8017db:	e8 83 fd ff ff       	call   801563 <fsipc>
}
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <copy_shared_pages>:
}

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	57                   	push   %edi
  8017e6:	56                   	push   %esi
  8017e7:	53                   	push   %ebx
  8017e8:	83 ec 1c             	sub    $0x1c,%esp
  8017eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8017ee:	bf 00 04 00 00       	mov    $0x400,%edi
	// LAB 5: Your code here.
	unsigned int pn;
	void* addr;
  	for (int i = 0; i < NPDENTRIES; ++i) {
  8017f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8017fa:	eb 7d                	jmp    801879 <copy_shared_pages+0x97>
	    for (int j = 0; j < NPTENTRIES; ++j) {
    	  pn = i*NPDENTRIES + j;
    	  addr = (void*) (pn*PGSIZE);
      	  if ((pn < (UTOP >> PGSHIFT)) && uvpd[i]) {
  8017fc:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  801802:	77 54                	ja     801858 <copy_shared_pages+0x76>
  801804:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801807:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80180e:	85 c0                	test   %eax,%eax
  801810:	74 46                	je     801858 <copy_shared_pages+0x76>
        	if (uvpt[pn] & PTE_SHARE) {
  801812:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801819:	f6 c4 04             	test   $0x4,%ah
  80181c:	74 3a                	je     801858 <copy_shared_pages+0x76>
          		if (sys_page_map(0, addr, child, addr, uvpt[pn] & PTE_SYSCALL) < 0) {
  80181e:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801825:	83 ec 0c             	sub    $0xc,%esp
  801828:	25 07 0e 00 00       	and    $0xe07,%eax
  80182d:	50                   	push   %eax
  80182e:	56                   	push   %esi
  80182f:	ff 75 e0             	pushl  -0x20(%ebp)
  801832:	56                   	push   %esi
  801833:	6a 00                	push   $0x0
  801835:	e8 81 f6 ff ff       	call   800ebb <sys_page_map>
  80183a:	83 c4 20             	add    $0x20,%esp
  80183d:	85 c0                	test   %eax,%eax
  80183f:	79 17                	jns    801858 <copy_shared_pages+0x76>
              		panic("Error en sys_page_map");
  801841:	83 ec 04             	sub    $0x4,%esp
  801844:	68 ab 2a 80 00       	push   $0x802aab
  801849:	68 4f 01 00 00       	push   $0x14f
  80184e:	68 c1 2a 80 00       	push   $0x802ac1
  801853:	e8 ab eb ff ff       	call   800403 <_panic>
  801858:	83 c3 01             	add    $0x1,%ebx
  80185b:	81 c6 00 10 00 00    	add    $0x1000,%esi
{
	// LAB 5: Your code here.
	unsigned int pn;
	void* addr;
  	for (int i = 0; i < NPDENTRIES; ++i) {
	    for (int j = 0; j < NPTENTRIES; ++j) {
  801861:	39 fb                	cmp    %edi,%ebx
  801863:	75 97                	jne    8017fc <copy_shared_pages+0x1a>
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	unsigned int pn;
	void* addr;
  	for (int i = 0; i < NPDENTRIES; ++i) {
  801865:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  801869:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80186c:	81 c7 00 04 00 00    	add    $0x400,%edi
  801872:	3d 00 04 00 00       	cmp    $0x400,%eax
  801877:	74 10                	je     801889 <copy_shared_pages+0xa7>
  801879:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80187c:	89 f3                	mov    %esi,%ebx
  80187e:	c1 e3 0a             	shl    $0xa,%ebx
  801881:	c1 e6 16             	shl    $0x16,%esi
  801884:	e9 73 ff ff ff       	jmp    8017fc <copy_shared_pages+0x1a>
        	} 
      	  }
    	}
	}
	return 0;
}
  801889:	b8 00 00 00 00       	mov    $0x0,%eax
  80188e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801891:	5b                   	pop    %ebx
  801892:	5e                   	pop    %esi
  801893:	5f                   	pop    %edi
  801894:	5d                   	pop    %ebp
  801895:	c3                   	ret    

00801896 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	57                   	push   %edi
  80189a:	56                   	push   %esi
  80189b:	53                   	push   %ebx
  80189c:	83 ec 2c             	sub    $0x2c,%esp
  80189f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8018a2:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8018a5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8018a8:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8018ad:	be 00 00 00 00       	mov    $0x0,%esi
  8018b2:	89 d7                	mov    %edx,%edi
	for (argc = 0; argv[argc] != 0; argc++)
  8018b4:	eb 13                	jmp    8018c9 <init_stack+0x33>
		string_size += strlen(argv[argc]) + 1;
  8018b6:	83 ec 0c             	sub    $0xc,%esp
  8018b9:	50                   	push   %eax
  8018ba:	e8 56 f1 ff ff       	call   800a15 <strlen>
  8018bf:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8018c3:	83 c3 01             	add    $0x1,%ebx
  8018c6:	83 c4 10             	add    $0x10,%esp
  8018c9:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8018d0:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	75 df                	jne    8018b6 <init_stack+0x20>
  8018d7:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  8018da:	89 4d d8             	mov    %ecx,-0x28(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char *) UTEMP + PGSIZE - string_size;
  8018dd:	bf 00 10 40 00       	mov    $0x401000,%edi
  8018e2:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t *) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8018e4:	89 fa                	mov    %edi,%edx
  8018e6:	83 e2 fc             	and    $0xfffffffc,%edx
  8018e9:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8018f0:	29 c2                	sub    %eax,%edx
  8018f2:	89 55 e4             	mov    %edx,-0x1c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void *) (argv_store - 2) < (void *) UTEMP)
  8018f5:	8d 42 f8             	lea    -0x8(%edx),%eax
  8018f8:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8018fd:	0f 86 fc 00 00 00    	jbe    8019ff <init_stack+0x169>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void *) UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801903:	83 ec 04             	sub    $0x4,%esp
  801906:	6a 07                	push   $0x7
  801908:	68 00 00 40 00       	push   $0x400000
  80190d:	6a 00                	push   $0x0
  80190f:	e8 83 f5 ff ff       	call   800e97 <sys_page_alloc>
  801914:	83 c4 10             	add    $0x10,%esp
  801917:	85 c0                	test   %eax,%eax
  801919:	0f 88 e5 00 00 00    	js     801a04 <init_stack+0x16e>
  80191f:	be 00 00 00 00       	mov    $0x0,%esi
  801924:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  801927:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80192a:	eb 2d                	jmp    801959 <init_stack+0xc3>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  80192c:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801932:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801935:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801938:	83 ec 08             	sub    $0x8,%esp
  80193b:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80193e:	57                   	push   %edi
  80193f:	e8 0a f1 ff ff       	call   800a4e <strcpy>
		string_store += strlen(argv[i]) + 1;
  801944:	83 c4 04             	add    $0x4,%esp
  801947:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80194a:	e8 c6 f0 ff ff       	call   800a15 <strlen>
  80194f:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801953:	83 c6 01             	add    $0x1,%esi
  801956:	83 c4 10             	add    $0x10,%esp
  801959:	39 75 e0             	cmp    %esi,-0x20(%ebp)
  80195c:	7f ce                	jg     80192c <init_stack+0x96>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  80195e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801961:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  801964:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char *) UTEMP + PGSIZE);
  80196b:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801971:	74 19                	je     80198c <init_stack+0xf6>
  801973:	68 4c 2b 80 00       	push   $0x802b4c
  801978:	68 7f 2a 80 00       	push   $0x802a7f
  80197d:	68 fc 00 00 00       	push   $0xfc
  801982:	68 c1 2a 80 00       	push   $0x802ac1
  801987:	e8 77 ea ff ff       	call   800403 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80198c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80198f:	89 d0                	mov    %edx,%eax
  801991:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801996:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801999:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80199c:	89 42 f8             	mov    %eax,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80199f:	8d 82 f8 cf 7f ee    	lea    -0x11803008(%edx),%eax
  8019a5:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8019a8:	89 01                	mov    %eax,(%ecx)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0,
  8019aa:	83 ec 0c             	sub    $0xc,%esp
  8019ad:	6a 07                	push   $0x7
  8019af:	68 00 d0 bf ee       	push   $0xeebfd000
  8019b4:	ff 75 d4             	pushl  -0x2c(%ebp)
  8019b7:	68 00 00 40 00       	push   $0x400000
  8019bc:	6a 00                	push   $0x0
  8019be:	e8 f8 f4 ff ff       	call   800ebb <sys_page_map>
  8019c3:	89 c3                	mov    %eax,%ebx
  8019c5:	83 c4 20             	add    $0x20,%esp
  8019c8:	85 c0                	test   %eax,%eax
  8019ca:	78 1d                	js     8019e9 <init_stack+0x153>
	                      UTEMP,
	                      child,
	                      (void *) (USTACKTOP - PGSIZE),
	                      PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8019cc:	83 ec 08             	sub    $0x8,%esp
  8019cf:	68 00 00 40 00       	push   $0x400000
  8019d4:	6a 00                	push   $0x0
  8019d6:	e8 06 f5 ff ff       	call   800ee1 <sys_page_unmap>
  8019db:	89 c3                	mov    %eax,%ebx
  8019dd:	83 c4 10             	add    $0x10,%esp
		goto error;

	return 0;
  8019e0:	b8 00 00 00 00       	mov    $0x0,%eax
	                      UTEMP,
	                      child,
	                      (void *) (USTACKTOP - PGSIZE),
	                      PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8019e5:	85 db                	test   %ebx,%ebx
  8019e7:	79 1b                	jns    801a04 <init_stack+0x16e>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  8019e9:	83 ec 08             	sub    $0x8,%esp
  8019ec:	68 00 00 40 00       	push   $0x400000
  8019f1:	6a 00                	push   $0x0
  8019f3:	e8 e9 f4 ff ff       	call   800ee1 <sys_page_unmap>
	return r;
  8019f8:	83 c4 10             	add    $0x10,%esp
  8019fb:	89 d8                	mov    %ebx,%eax
  8019fd:	eb 05                	jmp    801a04 <init_stack+0x16e>
	argv_store = (uintptr_t *) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void *) (argv_store - 2) < (void *) UTEMP)
		return -E_NO_MEM;
  8019ff:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return 0;

error:
	sys_page_unmap(0, UTEMP);
	return r;
}
  801a04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a07:	5b                   	pop    %ebx
  801a08:	5e                   	pop    %esi
  801a09:	5f                   	pop    %edi
  801a0a:	5d                   	pop    %ebp
  801a0b:	c3                   	ret    

00801a0c <map_segment>:
            size_t memsz,
            int fd,
            size_t filesz,
            off_t fileoffset,
            int perm)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	57                   	push   %edi
  801a10:	56                   	push   %esi
  801a11:	53                   	push   %ebx
  801a12:	83 ec 1c             	sub    $0x1c,%esp
  801a15:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801a18:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	int i, r;
	void *blk;

	// cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801a1b:	89 d0                	mov    %edx,%eax
  801a1d:	25 ff 0f 00 00       	and    $0xfff,%eax
  801a22:	74 0d                	je     801a31 <map_segment+0x25>
		va -= i;
  801a24:	29 c2                	sub    %eax,%edx
		memsz += i;
  801a26:	01 c1                	add    %eax,%ecx
  801a28:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		filesz += i;
  801a2b:	01 45 0c             	add    %eax,0xc(%ebp)
		fileoffset -= i;
  801a2e:	29 45 10             	sub    %eax,0x10(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801a31:	89 d6                	mov    %edx,%esi
  801a33:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a38:	e9 d6 00 00 00       	jmp    801b13 <map_segment+0x107>
		if (i >= filesz) {
  801a3d:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
  801a40:	77 1f                	ja     801a61 <map_segment+0x55>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void *) (va + i), perm)) < 0)
  801a42:	83 ec 04             	sub    $0x4,%esp
  801a45:	ff 75 14             	pushl  0x14(%ebp)
  801a48:	56                   	push   %esi
  801a49:	ff 75 e0             	pushl  -0x20(%ebp)
  801a4c:	e8 46 f4 ff ff       	call   800e97 <sys_page_alloc>
  801a51:	83 c4 10             	add    $0x10,%esp
  801a54:	85 c0                	test   %eax,%eax
  801a56:	0f 89 ab 00 00 00    	jns    801b07 <map_segment+0xfb>
  801a5c:	e9 c2 00 00 00       	jmp    801b23 <map_segment+0x117>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W)) <
  801a61:	83 ec 04             	sub    $0x4,%esp
  801a64:	6a 07                	push   $0x7
  801a66:	68 00 00 40 00       	push   $0x400000
  801a6b:	6a 00                	push   $0x0
  801a6d:	e8 25 f4 ff ff       	call   800e97 <sys_page_alloc>
  801a72:	83 c4 10             	add    $0x10,%esp
  801a75:	85 c0                	test   %eax,%eax
  801a77:	0f 88 a6 00 00 00    	js     801b23 <map_segment+0x117>
			    0)
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801a7d:	83 ec 08             	sub    $0x8,%esp
  801a80:	89 f8                	mov    %edi,%eax
  801a82:	03 45 10             	add    0x10(%ebp),%eax
  801a85:	50                   	push   %eax
  801a86:	ff 75 08             	pushl  0x8(%ebp)
  801a89:	e8 68 f9 ff ff       	call   8013f6 <seek>
  801a8e:	83 c4 10             	add    $0x10,%esp
  801a91:	85 c0                	test   %eax,%eax
  801a93:	0f 88 8a 00 00 00    	js     801b23 <map_segment+0x117>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz - i))) < 0)
  801a99:	83 ec 04             	sub    $0x4,%esp
  801a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a9f:	29 f8                	sub    %edi,%eax
  801aa1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801aa6:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801aab:	0f 47 c1             	cmova  %ecx,%eax
  801aae:	50                   	push   %eax
  801aaf:	68 00 00 40 00       	push   $0x400000
  801ab4:	ff 75 08             	pushl  0x8(%ebp)
  801ab7:	e8 65 f8 ff ff       	call   801321 <readn>
  801abc:	83 c4 10             	add    $0x10,%esp
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	78 60                	js     801b23 <map_segment+0x117>
				return r;
			if ((r = sys_page_map(
  801ac3:	83 ec 0c             	sub    $0xc,%esp
  801ac6:	ff 75 14             	pushl  0x14(%ebp)
  801ac9:	56                   	push   %esi
  801aca:	ff 75 e0             	pushl  -0x20(%ebp)
  801acd:	68 00 00 40 00       	push   $0x400000
  801ad2:	6a 00                	push   $0x0
  801ad4:	e8 e2 f3 ff ff       	call   800ebb <sys_page_map>
  801ad9:	83 c4 20             	add    $0x20,%esp
  801adc:	85 c0                	test   %eax,%eax
  801ade:	79 15                	jns    801af5 <map_segment+0xe9>
			             0, UTEMP, child, (void *) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
  801ae0:	50                   	push   %eax
  801ae1:	68 cd 2a 80 00       	push   $0x802acd
  801ae6:	68 3a 01 00 00       	push   $0x13a
  801aeb:	68 c1 2a 80 00       	push   $0x802ac1
  801af0:	e8 0e e9 ff ff       	call   800403 <_panic>
			sys_page_unmap(0, UTEMP);
  801af5:	83 ec 08             	sub    $0x8,%esp
  801af8:	68 00 00 40 00       	push   $0x400000
  801afd:	6a 00                	push   $0x0
  801aff:	e8 dd f3 ff ff       	call   800ee1 <sys_page_unmap>
  801b04:	83 c4 10             	add    $0x10,%esp
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801b07:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801b0d:	81 c6 00 10 00 00    	add    $0x1000,%esi
  801b13:	89 df                	mov    %ebx,%edi
  801b15:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
  801b18:	0f 87 1f ff ff ff    	ja     801a3d <map_segment+0x31>
			             0, UTEMP, child, (void *) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  801b1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b26:	5b                   	pop    %ebx
  801b27:	5e                   	pop    %esi
  801b28:	5f                   	pop    %edi
  801b29:	5d                   	pop    %ebp
  801b2a:	c3                   	ret    

00801b2b <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	57                   	push   %edi
  801b2f:	56                   	push   %esi
  801b30:	53                   	push   %ebx
  801b31:	81 ec 74 02 00 00    	sub    $0x274,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801b37:	6a 00                	push   $0x0
  801b39:	ff 75 08             	pushl  0x8(%ebp)
  801b3c:	e8 fd fb ff ff       	call   80173e <open>
  801b41:	89 c7                	mov    %eax,%edi
  801b43:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801b49:	83 c4 10             	add    $0x10,%esp
  801b4c:	85 c0                	test   %eax,%eax
  801b4e:	0f 88 e3 01 00 00    	js     801d37 <spawn+0x20c>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf *) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf) ||
  801b54:	83 ec 04             	sub    $0x4,%esp
  801b57:	68 00 02 00 00       	push   $0x200
  801b5c:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801b62:	50                   	push   %eax
  801b63:	57                   	push   %edi
  801b64:	e8 b8 f7 ff ff       	call   801321 <readn>
  801b69:	83 c4 10             	add    $0x10,%esp
  801b6c:	3d 00 02 00 00       	cmp    $0x200,%eax
  801b71:	75 0c                	jne    801b7f <spawn+0x54>
  801b73:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801b7a:	45 4c 46 
  801b7d:	74 33                	je     801bb2 <spawn+0x87>
	    elf->e_magic != ELF_MAGIC) {
		close(fd);
  801b7f:	83 ec 0c             	sub    $0xc,%esp
  801b82:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801b88:	e8 c7 f5 ff ff       	call   801154 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801b8d:	83 c4 0c             	add    $0xc,%esp
  801b90:	68 7f 45 4c 46       	push   $0x464c457f
  801b95:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801b9b:	68 ea 2a 80 00       	push   $0x802aea
  801ba0:	e8 37 e9 ff ff       	call   8004dc <cprintf>
		return -E_NOT_EXEC;
  801ba5:	83 c4 10             	add    $0x10,%esp
  801ba8:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801bad:	e9 9b 01 00 00       	jmp    801d4d <spawn+0x222>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801bb2:	b8 07 00 00 00       	mov    $0x7,%eax
  801bb7:	cd 30                	int    $0x30
  801bb9:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801bbf:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801bc5:	89 c3                	mov    %eax,%ebx
  801bc7:	85 c0                	test   %eax,%eax
  801bc9:	0f 88 70 01 00 00    	js     801d3f <spawn+0x214>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801bcf:	89 c6                	mov    %eax,%esi
  801bd1:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801bd7:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801bda:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801be0:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801be6:	b9 11 00 00 00       	mov    $0x11,%ecx
  801beb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801bed:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801bf3:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
  801bf9:	8d 8d e0 fd ff ff    	lea    -0x220(%ebp),%ecx
  801bff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c02:	89 d8                	mov    %ebx,%eax
  801c04:	e8 8d fc ff ff       	call   801896 <init_stack>
  801c09:	85 c0                	test   %eax,%eax
  801c0b:	0f 88 3c 01 00 00    	js     801d4d <spawn+0x222>
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr *) (elf_buf + elf->e_phoff);
  801c11:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801c17:	8d 9c 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%ebx
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801c1e:	be 00 00 00 00       	mov    $0x0,%esi
  801c23:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  801c29:	eb 40                	jmp    801c6b <spawn+0x140>
		if (ph->p_type != ELF_PROG_LOAD)
  801c2b:	83 3b 01             	cmpl   $0x1,(%ebx)
  801c2e:	75 35                	jne    801c65 <spawn+0x13a>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801c30:	8b 43 18             	mov    0x18(%ebx),%eax
  801c33:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801c36:	83 f8 01             	cmp    $0x1,%eax
  801c39:	19 c0                	sbb    %eax,%eax
  801c3b:	83 e0 fe             	and    $0xfffffffe,%eax
  801c3e:	83 c0 07             	add    $0x7,%eax
		if ((r = map_segment(child,
  801c41:	8b 4b 14             	mov    0x14(%ebx),%ecx
  801c44:	8b 53 08             	mov    0x8(%ebx),%edx
  801c47:	50                   	push   %eax
  801c48:	ff 73 04             	pushl  0x4(%ebx)
  801c4b:	ff 73 10             	pushl  0x10(%ebx)
  801c4e:	57                   	push   %edi
  801c4f:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801c55:	e8 b2 fd ff ff       	call   801a0c <map_segment>
  801c5a:	83 c4 10             	add    $0x10,%esp
  801c5d:	85 c0                	test   %eax,%eax
  801c5f:	0f 88 ad 00 00 00    	js     801d12 <spawn+0x1e7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr *) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801c65:	83 c6 01             	add    $0x1,%esi
  801c68:	83 c3 20             	add    $0x20,%ebx
  801c6b:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801c72:	39 c6                	cmp    %eax,%esi
  801c74:	7c b5                	jl     801c2b <spawn+0x100>
		                     ph->p_filesz,
		                     ph->p_offset,
		                     perm)) < 0)
			goto error;
	}
	close(fd);
  801c76:	83 ec 0c             	sub    $0xc,%esp
  801c79:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c7f:	e8 d0 f4 ff ff       	call   801154 <close>
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  801c84:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801c8a:	e8 53 fb ff ff       	call   8017e2 <copy_shared_pages>
  801c8f:	83 c4 10             	add    $0x10,%esp
  801c92:	85 c0                	test   %eax,%eax
  801c94:	79 15                	jns    801cab <spawn+0x180>
		panic("copy_shared_pages: %e", r);
  801c96:	50                   	push   %eax
  801c97:	68 04 2b 80 00       	push   $0x802b04
  801c9c:	68 8c 00 00 00       	push   $0x8c
  801ca1:	68 c1 2a 80 00       	push   $0x802ac1
  801ca6:	e8 58 e7 ff ff       	call   800403 <_panic>

	child_tf.tf_eflags |= FL_IOPL_3;  // devious: see user/faultio.c
  801cab:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801cb2:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801cb5:	83 ec 08             	sub    $0x8,%esp
  801cb8:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801cbe:	50                   	push   %eax
  801cbf:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801cc5:	e8 5d f2 ff ff       	call   800f27 <sys_env_set_trapframe>
  801cca:	83 c4 10             	add    $0x10,%esp
  801ccd:	85 c0                	test   %eax,%eax
  801ccf:	79 15                	jns    801ce6 <spawn+0x1bb>
		panic("sys_env_set_trapframe: %e", r);
  801cd1:	50                   	push   %eax
  801cd2:	68 1a 2b 80 00       	push   $0x802b1a
  801cd7:	68 90 00 00 00       	push   $0x90
  801cdc:	68 c1 2a 80 00       	push   $0x802ac1
  801ce1:	e8 1d e7 ff ff       	call   800403 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801ce6:	83 ec 08             	sub    $0x8,%esp
  801ce9:	6a 02                	push   $0x2
  801ceb:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801cf1:	e8 0e f2 ff ff       	call   800f04 <sys_env_set_status>
  801cf6:	83 c4 10             	add    $0x10,%esp
  801cf9:	85 c0                	test   %eax,%eax
  801cfb:	79 4a                	jns    801d47 <spawn+0x21c>
		panic("sys_env_set_status: %e", r);
  801cfd:	50                   	push   %eax
  801cfe:	68 34 2b 80 00       	push   $0x802b34
  801d03:	68 93 00 00 00       	push   $0x93
  801d08:	68 c1 2a 80 00       	push   $0x802ac1
  801d0d:	e8 f1 e6 ff ff       	call   800403 <_panic>
  801d12:	89 c7                	mov    %eax,%edi

	return child;

error:
	sys_env_destroy(child);
  801d14:	83 ec 0c             	sub    $0xc,%esp
  801d17:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801d1d:	e8 08 f1 ff ff       	call   800e2a <sys_env_destroy>
	close(fd);
  801d22:	83 c4 04             	add    $0x4,%esp
  801d25:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801d2b:	e8 24 f4 ff ff       	call   801154 <close>
	return r;
  801d30:	83 c4 10             	add    $0x10,%esp
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child,
  801d33:	89 f8                	mov    %edi,%eax
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  801d35:	eb 16                	jmp    801d4d <spawn+0x222>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  801d37:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801d3d:	eb 0e                	jmp    801d4d <spawn+0x222>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  801d3f:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801d45:	eb 06                	jmp    801d4d <spawn+0x222>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  801d47:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  801d4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d50:	5b                   	pop    %ebx
  801d51:	5e                   	pop    %esi
  801d52:	5f                   	pop    %edi
  801d53:	5d                   	pop    %ebp
  801d54:	c3                   	ret    

00801d55 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	56                   	push   %esi
  801d59:	53                   	push   %ebx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc = 0;
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  801d5a:	8d 55 10             	lea    0x10(%ebp),%edx
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc = 0;
  801d5d:	b8 00 00 00 00       	mov    $0x0,%eax
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  801d62:	eb 03                	jmp    801d67 <spawnl+0x12>
		argc++;
  801d64:	83 c0 01             	add    $0x1,%eax
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc = 0;
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  801d67:	83 c2 04             	add    $0x4,%edx
  801d6a:	83 7a fc 00          	cmpl   $0x0,-0x4(%edx)
  801d6e:	75 f4                	jne    801d64 <spawnl+0xf>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc + 2];
  801d70:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  801d77:	83 e2 f0             	and    $0xfffffff0,%edx
  801d7a:	29 d4                	sub    %edx,%esp
  801d7c:	8d 54 24 03          	lea    0x3(%esp),%edx
  801d80:	c1 ea 02             	shr    $0x2,%edx
  801d83:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801d8a:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801d8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d8f:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc + 1] = NULL;
  801d96:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801d9d:	00 
  801d9e:	89 c2                	mov    %eax,%edx

	va_start(vl, arg0);
	unsigned i;
	for (i = 0; i < argc; i++)
  801da0:	b8 00 00 00 00       	mov    $0x0,%eax
  801da5:	eb 0a                	jmp    801db1 <spawnl+0x5c>
		argv[i + 1] = va_arg(vl, const char *);
  801da7:	83 c0 01             	add    $0x1,%eax
  801daa:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  801dae:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc + 1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for (i = 0; i < argc; i++)
  801db1:	39 d0                	cmp    %edx,%eax
  801db3:	75 f2                	jne    801da7 <spawnl+0x52>
		argv[i + 1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  801db5:	83 ec 08             	sub    $0x8,%esp
  801db8:	56                   	push   %esi
  801db9:	ff 75 08             	pushl  0x8(%ebp)
  801dbc:	e8 6a fd ff ff       	call   801b2b <spawn>
}
  801dc1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dc4:	5b                   	pop    %ebx
  801dc5:	5e                   	pop    %esi
  801dc6:	5d                   	pop    %ebp
  801dc7:	c3                   	ret    

00801dc8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801dc8:	55                   	push   %ebp
  801dc9:	89 e5                	mov    %esp,%ebp
  801dcb:	56                   	push   %esi
  801dcc:	53                   	push   %ebx
  801dcd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801dd0:	83 ec 0c             	sub    $0xc,%esp
  801dd3:	ff 75 08             	pushl  0x8(%ebp)
  801dd6:	e8 e9 f1 ff ff       	call   800fc4 <fd2data>
  801ddb:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ddd:	83 c4 08             	add    $0x8,%esp
  801de0:	68 74 2b 80 00       	push   $0x802b74
  801de5:	53                   	push   %ebx
  801de6:	e8 63 ec ff ff       	call   800a4e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801deb:	8b 46 04             	mov    0x4(%esi),%eax
  801dee:	2b 06                	sub    (%esi),%eax
  801df0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801df6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dfd:	00 00 00 
	stat->st_dev = &devpipe;
  801e00:	c7 83 88 00 00 00 ac 	movl   $0x8047ac,0x88(%ebx)
  801e07:	47 80 00 
	return 0;
}
  801e0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e12:	5b                   	pop    %ebx
  801e13:	5e                   	pop    %esi
  801e14:	5d                   	pop    %ebp
  801e15:	c3                   	ret    

00801e16 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
  801e19:	53                   	push   %ebx
  801e1a:	83 ec 0c             	sub    $0xc,%esp
  801e1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e20:	53                   	push   %ebx
  801e21:	6a 00                	push   $0x0
  801e23:	e8 b9 f0 ff ff       	call   800ee1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e28:	89 1c 24             	mov    %ebx,(%esp)
  801e2b:	e8 94 f1 ff ff       	call   800fc4 <fd2data>
  801e30:	83 c4 08             	add    $0x8,%esp
  801e33:	50                   	push   %eax
  801e34:	6a 00                	push   $0x0
  801e36:	e8 a6 f0 ff ff       	call   800ee1 <sys_page_unmap>
}
  801e3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	57                   	push   %edi
  801e44:	56                   	push   %esi
  801e45:	53                   	push   %ebx
  801e46:	83 ec 1c             	sub    $0x1c,%esp
  801e49:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e4c:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801e4e:	a1 90 67 80 00       	mov    0x806790,%eax
  801e53:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801e56:	83 ec 0c             	sub    $0xc,%esp
  801e59:	ff 75 e0             	pushl  -0x20(%ebp)
  801e5c:	e8 0a 04 00 00       	call   80226b <pageref>
  801e61:	89 c3                	mov    %eax,%ebx
  801e63:	89 3c 24             	mov    %edi,(%esp)
  801e66:	e8 00 04 00 00       	call   80226b <pageref>
  801e6b:	83 c4 10             	add    $0x10,%esp
  801e6e:	39 c3                	cmp    %eax,%ebx
  801e70:	0f 94 c1             	sete   %cl
  801e73:	0f b6 c9             	movzbl %cl,%ecx
  801e76:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801e79:	8b 15 90 67 80 00    	mov    0x806790,%edx
  801e7f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e82:	39 ce                	cmp    %ecx,%esi
  801e84:	74 1b                	je     801ea1 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801e86:	39 c3                	cmp    %eax,%ebx
  801e88:	75 c4                	jne    801e4e <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e8a:	8b 42 58             	mov    0x58(%edx),%eax
  801e8d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e90:	50                   	push   %eax
  801e91:	56                   	push   %esi
  801e92:	68 7b 2b 80 00       	push   $0x802b7b
  801e97:	e8 40 e6 ff ff       	call   8004dc <cprintf>
  801e9c:	83 c4 10             	add    $0x10,%esp
  801e9f:	eb ad                	jmp    801e4e <_pipeisclosed+0xe>
	}
}
  801ea1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ea4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ea7:	5b                   	pop    %ebx
  801ea8:	5e                   	pop    %esi
  801ea9:	5f                   	pop    %edi
  801eaa:	5d                   	pop    %ebp
  801eab:	c3                   	ret    

00801eac <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	57                   	push   %edi
  801eb0:	56                   	push   %esi
  801eb1:	53                   	push   %ebx
  801eb2:	83 ec 28             	sub    $0x28,%esp
  801eb5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801eb8:	56                   	push   %esi
  801eb9:	e8 06 f1 ff ff       	call   800fc4 <fd2data>
  801ebe:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ec0:	83 c4 10             	add    $0x10,%esp
  801ec3:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec8:	eb 4b                	jmp    801f15 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801eca:	89 da                	mov    %ebx,%edx
  801ecc:	89 f0                	mov    %esi,%eax
  801ece:	e8 6d ff ff ff       	call   801e40 <_pipeisclosed>
  801ed3:	85 c0                	test   %eax,%eax
  801ed5:	75 48                	jne    801f1f <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801ed7:	e8 94 ef ff ff       	call   800e70 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801edc:	8b 43 04             	mov    0x4(%ebx),%eax
  801edf:	8b 0b                	mov    (%ebx),%ecx
  801ee1:	8d 51 20             	lea    0x20(%ecx),%edx
  801ee4:	39 d0                	cmp    %edx,%eax
  801ee6:	73 e2                	jae    801eca <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ee8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801eeb:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801eef:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ef2:	89 c2                	mov    %eax,%edx
  801ef4:	c1 fa 1f             	sar    $0x1f,%edx
  801ef7:	89 d1                	mov    %edx,%ecx
  801ef9:	c1 e9 1b             	shr    $0x1b,%ecx
  801efc:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801eff:	83 e2 1f             	and    $0x1f,%edx
  801f02:	29 ca                	sub    %ecx,%edx
  801f04:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f08:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f0c:	83 c0 01             	add    $0x1,%eax
  801f0f:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f12:	83 c7 01             	add    $0x1,%edi
  801f15:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f18:	75 c2                	jne    801edc <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801f1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1d:	eb 05                	jmp    801f24 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f1f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801f24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f27:	5b                   	pop    %ebx
  801f28:	5e                   	pop    %esi
  801f29:	5f                   	pop    %edi
  801f2a:	5d                   	pop    %ebp
  801f2b:	c3                   	ret    

00801f2c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	57                   	push   %edi
  801f30:	56                   	push   %esi
  801f31:	53                   	push   %ebx
  801f32:	83 ec 18             	sub    $0x18,%esp
  801f35:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801f38:	57                   	push   %edi
  801f39:	e8 86 f0 ff ff       	call   800fc4 <fd2data>
  801f3e:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f40:	83 c4 10             	add    $0x10,%esp
  801f43:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f48:	eb 3d                	jmp    801f87 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801f4a:	85 db                	test   %ebx,%ebx
  801f4c:	74 04                	je     801f52 <devpipe_read+0x26>
				return i;
  801f4e:	89 d8                	mov    %ebx,%eax
  801f50:	eb 44                	jmp    801f96 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801f52:	89 f2                	mov    %esi,%edx
  801f54:	89 f8                	mov    %edi,%eax
  801f56:	e8 e5 fe ff ff       	call   801e40 <_pipeisclosed>
  801f5b:	85 c0                	test   %eax,%eax
  801f5d:	75 32                	jne    801f91 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f5f:	e8 0c ef ff ff       	call   800e70 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f64:	8b 06                	mov    (%esi),%eax
  801f66:	3b 46 04             	cmp    0x4(%esi),%eax
  801f69:	74 df                	je     801f4a <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f6b:	99                   	cltd   
  801f6c:	c1 ea 1b             	shr    $0x1b,%edx
  801f6f:	01 d0                	add    %edx,%eax
  801f71:	83 e0 1f             	and    $0x1f,%eax
  801f74:	29 d0                	sub    %edx,%eax
  801f76:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801f7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f7e:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801f81:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f84:	83 c3 01             	add    $0x1,%ebx
  801f87:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801f8a:	75 d8                	jne    801f64 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f8f:	eb 05                	jmp    801f96 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f91:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801f96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f99:	5b                   	pop    %ebx
  801f9a:	5e                   	pop    %esi
  801f9b:	5f                   	pop    %edi
  801f9c:	5d                   	pop    %ebp
  801f9d:	c3                   	ret    

00801f9e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
  801fa1:	56                   	push   %esi
  801fa2:	53                   	push   %ebx
  801fa3:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801fa6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa9:	50                   	push   %eax
  801faa:	e8 2d f0 ff ff       	call   800fdc <fd_alloc>
  801faf:	83 c4 10             	add    $0x10,%esp
  801fb2:	89 c2                	mov    %eax,%edx
  801fb4:	85 c0                	test   %eax,%eax
  801fb6:	0f 88 2c 01 00 00    	js     8020e8 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fbc:	83 ec 04             	sub    $0x4,%esp
  801fbf:	68 07 04 00 00       	push   $0x407
  801fc4:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc7:	6a 00                	push   $0x0
  801fc9:	e8 c9 ee ff ff       	call   800e97 <sys_page_alloc>
  801fce:	83 c4 10             	add    $0x10,%esp
  801fd1:	89 c2                	mov    %eax,%edx
  801fd3:	85 c0                	test   %eax,%eax
  801fd5:	0f 88 0d 01 00 00    	js     8020e8 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801fdb:	83 ec 0c             	sub    $0xc,%esp
  801fde:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fe1:	50                   	push   %eax
  801fe2:	e8 f5 ef ff ff       	call   800fdc <fd_alloc>
  801fe7:	89 c3                	mov    %eax,%ebx
  801fe9:	83 c4 10             	add    $0x10,%esp
  801fec:	85 c0                	test   %eax,%eax
  801fee:	0f 88 e2 00 00 00    	js     8020d6 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ff4:	83 ec 04             	sub    $0x4,%esp
  801ff7:	68 07 04 00 00       	push   $0x407
  801ffc:	ff 75 f0             	pushl  -0x10(%ebp)
  801fff:	6a 00                	push   $0x0
  802001:	e8 91 ee ff ff       	call   800e97 <sys_page_alloc>
  802006:	89 c3                	mov    %eax,%ebx
  802008:	83 c4 10             	add    $0x10,%esp
  80200b:	85 c0                	test   %eax,%eax
  80200d:	0f 88 c3 00 00 00    	js     8020d6 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802013:	83 ec 0c             	sub    $0xc,%esp
  802016:	ff 75 f4             	pushl  -0xc(%ebp)
  802019:	e8 a6 ef ff ff       	call   800fc4 <fd2data>
  80201e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802020:	83 c4 0c             	add    $0xc,%esp
  802023:	68 07 04 00 00       	push   $0x407
  802028:	50                   	push   %eax
  802029:	6a 00                	push   $0x0
  80202b:	e8 67 ee ff ff       	call   800e97 <sys_page_alloc>
  802030:	89 c3                	mov    %eax,%ebx
  802032:	83 c4 10             	add    $0x10,%esp
  802035:	85 c0                	test   %eax,%eax
  802037:	0f 88 89 00 00 00    	js     8020c6 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80203d:	83 ec 0c             	sub    $0xc,%esp
  802040:	ff 75 f0             	pushl  -0x10(%ebp)
  802043:	e8 7c ef ff ff       	call   800fc4 <fd2data>
  802048:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80204f:	50                   	push   %eax
  802050:	6a 00                	push   $0x0
  802052:	56                   	push   %esi
  802053:	6a 00                	push   $0x0
  802055:	e8 61 ee ff ff       	call   800ebb <sys_page_map>
  80205a:	89 c3                	mov    %eax,%ebx
  80205c:	83 c4 20             	add    $0x20,%esp
  80205f:	85 c0                	test   %eax,%eax
  802061:	78 55                	js     8020b8 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802063:	8b 15 ac 47 80 00    	mov    0x8047ac,%edx
  802069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206c:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80206e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802071:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802078:	8b 15 ac 47 80 00    	mov    0x8047ac,%edx
  80207e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802081:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802083:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802086:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80208d:	83 ec 0c             	sub    $0xc,%esp
  802090:	ff 75 f4             	pushl  -0xc(%ebp)
  802093:	e8 1c ef ff ff       	call   800fb4 <fd2num>
  802098:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80209b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80209d:	83 c4 04             	add    $0x4,%esp
  8020a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8020a3:	e8 0c ef ff ff       	call   800fb4 <fd2num>
  8020a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020ab:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020ae:	83 c4 10             	add    $0x10,%esp
  8020b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8020b6:	eb 30                	jmp    8020e8 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  8020b8:	83 ec 08             	sub    $0x8,%esp
  8020bb:	56                   	push   %esi
  8020bc:	6a 00                	push   $0x0
  8020be:	e8 1e ee ff ff       	call   800ee1 <sys_page_unmap>
  8020c3:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  8020c6:	83 ec 08             	sub    $0x8,%esp
  8020c9:	ff 75 f0             	pushl  -0x10(%ebp)
  8020cc:	6a 00                	push   $0x0
  8020ce:	e8 0e ee ff ff       	call   800ee1 <sys_page_unmap>
  8020d3:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  8020d6:	83 ec 08             	sub    $0x8,%esp
  8020d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8020dc:	6a 00                	push   $0x0
  8020de:	e8 fe ed ff ff       	call   800ee1 <sys_page_unmap>
  8020e3:	83 c4 10             	add    $0x10,%esp
  8020e6:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  8020e8:	89 d0                	mov    %edx,%eax
  8020ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ed:	5b                   	pop    %ebx
  8020ee:	5e                   	pop    %esi
  8020ef:	5d                   	pop    %ebp
  8020f0:	c3                   	ret    

008020f1 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
  8020f4:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020fa:	50                   	push   %eax
  8020fb:	ff 75 08             	pushl  0x8(%ebp)
  8020fe:	e8 28 ef ff ff       	call   80102b <fd_lookup>
  802103:	83 c4 10             	add    $0x10,%esp
  802106:	85 c0                	test   %eax,%eax
  802108:	78 18                	js     802122 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  80210a:	83 ec 0c             	sub    $0xc,%esp
  80210d:	ff 75 f4             	pushl  -0xc(%ebp)
  802110:	e8 af ee ff ff       	call   800fc4 <fd2data>
	return _pipeisclosed(fd, p);
  802115:	89 c2                	mov    %eax,%edx
  802117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211a:	e8 21 fd ff ff       	call   801e40 <_pipeisclosed>
  80211f:	83 c4 10             	add    $0x10,%esp
}
  802122:	c9                   	leave  
  802123:	c3                   	ret    

00802124 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
  802127:	56                   	push   %esi
  802128:	53                   	push   %ebx
  802129:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80212c:	85 f6                	test   %esi,%esi
  80212e:	75 16                	jne    802146 <wait+0x22>
  802130:	68 93 2b 80 00       	push   $0x802b93
  802135:	68 7f 2a 80 00       	push   $0x802a7f
  80213a:	6a 09                	push   $0x9
  80213c:	68 9e 2b 80 00       	push   $0x802b9e
  802141:	e8 bd e2 ff ff       	call   800403 <_panic>
	e = &envs[ENVX(envid)];
  802146:	89 f3                	mov    %esi,%ebx
  802148:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80214e:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802151:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802157:	eb 05                	jmp    80215e <wait+0x3a>
		sys_yield();
  802159:	e8 12 ed ff ff       	call   800e70 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80215e:	8b 43 48             	mov    0x48(%ebx),%eax
  802161:	39 c6                	cmp    %eax,%esi
  802163:	75 07                	jne    80216c <wait+0x48>
  802165:	8b 43 54             	mov    0x54(%ebx),%eax
  802168:	85 c0                	test   %eax,%eax
  80216a:	75 ed                	jne    802159 <wait+0x35>
		sys_yield();
}
  80216c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80216f:	5b                   	pop    %ebx
  802170:	5e                   	pop    %esi
  802171:	5d                   	pop    %ebp
  802172:	c3                   	ret    

00802173 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
  802176:	56                   	push   %esi
  802177:	53                   	push   %ebx
  802178:	8b 75 08             	mov    0x8(%ebp),%esi
  80217b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80217e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  802181:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  802183:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802188:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  80218b:	83 ec 0c             	sub    $0xc,%esp
  80218e:	50                   	push   %eax
  80218f:	e8 fe ed ff ff       	call   800f92 <sys_ipc_recv>
	if (from_env_store)
  802194:	83 c4 10             	add    $0x10,%esp
  802197:	85 f6                	test   %esi,%esi
  802199:	74 0b                	je     8021a6 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  80219b:	8b 15 90 67 80 00    	mov    0x806790,%edx
  8021a1:	8b 52 74             	mov    0x74(%edx),%edx
  8021a4:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8021a6:	85 db                	test   %ebx,%ebx
  8021a8:	74 0b                	je     8021b5 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  8021aa:	8b 15 90 67 80 00    	mov    0x806790,%edx
  8021b0:	8b 52 78             	mov    0x78(%edx),%edx
  8021b3:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  8021b5:	85 c0                	test   %eax,%eax
  8021b7:	79 16                	jns    8021cf <ipc_recv+0x5c>
		if (from_env_store)
  8021b9:	85 f6                	test   %esi,%esi
  8021bb:	74 06                	je     8021c3 <ipc_recv+0x50>
			*from_env_store = 0;
  8021bd:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  8021c3:	85 db                	test   %ebx,%ebx
  8021c5:	74 10                	je     8021d7 <ipc_recv+0x64>
			*perm_store = 0;
  8021c7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021cd:	eb 08                	jmp    8021d7 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  8021cf:	a1 90 67 80 00       	mov    0x806790,%eax
  8021d4:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021da:	5b                   	pop    %ebx
  8021db:	5e                   	pop    %esi
  8021dc:	5d                   	pop    %ebp
  8021dd:	c3                   	ret    

008021de <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	57                   	push   %edi
  8021e2:	56                   	push   %esi
  8021e3:	53                   	push   %ebx
  8021e4:	83 ec 0c             	sub    $0xc,%esp
  8021e7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021ea:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  8021f0:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  8021f2:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021f7:	0f 44 d8             	cmove  %eax,%ebx
  8021fa:	eb 1c                	jmp    802218 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  8021fc:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8021ff:	74 12                	je     802213 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  802201:	50                   	push   %eax
  802202:	68 a9 2b 80 00       	push   $0x802ba9
  802207:	6a 42                	push   $0x42
  802209:	68 bf 2b 80 00       	push   $0x802bbf
  80220e:	e8 f0 e1 ff ff       	call   800403 <_panic>
		sys_yield();
  802213:	e8 58 ec ff ff       	call   800e70 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  802218:	ff 75 14             	pushl  0x14(%ebp)
  80221b:	53                   	push   %ebx
  80221c:	56                   	push   %esi
  80221d:	57                   	push   %edi
  80221e:	e8 4a ed ff ff       	call   800f6d <sys_ipc_try_send>
  802223:	83 c4 10             	add    $0x10,%esp
  802226:	85 c0                	test   %eax,%eax
  802228:	75 d2                	jne    8021fc <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  80222a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80222d:	5b                   	pop    %ebx
  80222e:	5e                   	pop    %esi
  80222f:	5f                   	pop    %edi
  802230:	5d                   	pop    %ebp
  802231:	c3                   	ret    

00802232 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
  802235:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802238:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80223d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802240:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802246:	8b 52 50             	mov    0x50(%edx),%edx
  802249:	39 ca                	cmp    %ecx,%edx
  80224b:	75 0d                	jne    80225a <ipc_find_env+0x28>
			return envs[i].env_id;
  80224d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802250:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802255:	8b 40 48             	mov    0x48(%eax),%eax
  802258:	eb 0f                	jmp    802269 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80225a:	83 c0 01             	add    $0x1,%eax
  80225d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802262:	75 d9                	jne    80223d <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802264:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802269:	5d                   	pop    %ebp
  80226a:	c3                   	ret    

0080226b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80226b:	55                   	push   %ebp
  80226c:	89 e5                	mov    %esp,%ebp
  80226e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802271:	89 d0                	mov    %edx,%eax
  802273:	c1 e8 16             	shr    $0x16,%eax
  802276:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80227d:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802282:	f6 c1 01             	test   $0x1,%cl
  802285:	74 1d                	je     8022a4 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802287:	c1 ea 0c             	shr    $0xc,%edx
  80228a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802291:	f6 c2 01             	test   $0x1,%dl
  802294:	74 0e                	je     8022a4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802296:	c1 ea 0c             	shr    $0xc,%edx
  802299:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022a0:	ef 
  8022a1:	0f b7 c0             	movzwl %ax,%eax
}
  8022a4:	5d                   	pop    %ebp
  8022a5:	c3                   	ret    
  8022a6:	66 90                	xchg   %ax,%ax
  8022a8:	66 90                	xchg   %ax,%ax
  8022aa:	66 90                	xchg   %ax,%ax
  8022ac:	66 90                	xchg   %ax,%ax
  8022ae:	66 90                	xchg   %ax,%ax

008022b0 <__udivdi3>:
  8022b0:	55                   	push   %ebp
  8022b1:	57                   	push   %edi
  8022b2:	56                   	push   %esi
  8022b3:	53                   	push   %ebx
  8022b4:	83 ec 1c             	sub    $0x1c,%esp
  8022b7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8022bb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8022bf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8022c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022c7:	85 f6                	test   %esi,%esi
  8022c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022cd:	89 ca                	mov    %ecx,%edx
  8022cf:	89 f8                	mov    %edi,%eax
  8022d1:	75 3d                	jne    802310 <__udivdi3+0x60>
  8022d3:	39 cf                	cmp    %ecx,%edi
  8022d5:	0f 87 c5 00 00 00    	ja     8023a0 <__udivdi3+0xf0>
  8022db:	85 ff                	test   %edi,%edi
  8022dd:	89 fd                	mov    %edi,%ebp
  8022df:	75 0b                	jne    8022ec <__udivdi3+0x3c>
  8022e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8022e6:	31 d2                	xor    %edx,%edx
  8022e8:	f7 f7                	div    %edi
  8022ea:	89 c5                	mov    %eax,%ebp
  8022ec:	89 c8                	mov    %ecx,%eax
  8022ee:	31 d2                	xor    %edx,%edx
  8022f0:	f7 f5                	div    %ebp
  8022f2:	89 c1                	mov    %eax,%ecx
  8022f4:	89 d8                	mov    %ebx,%eax
  8022f6:	89 cf                	mov    %ecx,%edi
  8022f8:	f7 f5                	div    %ebp
  8022fa:	89 c3                	mov    %eax,%ebx
  8022fc:	89 d8                	mov    %ebx,%eax
  8022fe:	89 fa                	mov    %edi,%edx
  802300:	83 c4 1c             	add    $0x1c,%esp
  802303:	5b                   	pop    %ebx
  802304:	5e                   	pop    %esi
  802305:	5f                   	pop    %edi
  802306:	5d                   	pop    %ebp
  802307:	c3                   	ret    
  802308:	90                   	nop
  802309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802310:	39 ce                	cmp    %ecx,%esi
  802312:	77 74                	ja     802388 <__udivdi3+0xd8>
  802314:	0f bd fe             	bsr    %esi,%edi
  802317:	83 f7 1f             	xor    $0x1f,%edi
  80231a:	0f 84 98 00 00 00    	je     8023b8 <__udivdi3+0x108>
  802320:	bb 20 00 00 00       	mov    $0x20,%ebx
  802325:	89 f9                	mov    %edi,%ecx
  802327:	89 c5                	mov    %eax,%ebp
  802329:	29 fb                	sub    %edi,%ebx
  80232b:	d3 e6                	shl    %cl,%esi
  80232d:	89 d9                	mov    %ebx,%ecx
  80232f:	d3 ed                	shr    %cl,%ebp
  802331:	89 f9                	mov    %edi,%ecx
  802333:	d3 e0                	shl    %cl,%eax
  802335:	09 ee                	or     %ebp,%esi
  802337:	89 d9                	mov    %ebx,%ecx
  802339:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80233d:	89 d5                	mov    %edx,%ebp
  80233f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802343:	d3 ed                	shr    %cl,%ebp
  802345:	89 f9                	mov    %edi,%ecx
  802347:	d3 e2                	shl    %cl,%edx
  802349:	89 d9                	mov    %ebx,%ecx
  80234b:	d3 e8                	shr    %cl,%eax
  80234d:	09 c2                	or     %eax,%edx
  80234f:	89 d0                	mov    %edx,%eax
  802351:	89 ea                	mov    %ebp,%edx
  802353:	f7 f6                	div    %esi
  802355:	89 d5                	mov    %edx,%ebp
  802357:	89 c3                	mov    %eax,%ebx
  802359:	f7 64 24 0c          	mull   0xc(%esp)
  80235d:	39 d5                	cmp    %edx,%ebp
  80235f:	72 10                	jb     802371 <__udivdi3+0xc1>
  802361:	8b 74 24 08          	mov    0x8(%esp),%esi
  802365:	89 f9                	mov    %edi,%ecx
  802367:	d3 e6                	shl    %cl,%esi
  802369:	39 c6                	cmp    %eax,%esi
  80236b:	73 07                	jae    802374 <__udivdi3+0xc4>
  80236d:	39 d5                	cmp    %edx,%ebp
  80236f:	75 03                	jne    802374 <__udivdi3+0xc4>
  802371:	83 eb 01             	sub    $0x1,%ebx
  802374:	31 ff                	xor    %edi,%edi
  802376:	89 d8                	mov    %ebx,%eax
  802378:	89 fa                	mov    %edi,%edx
  80237a:	83 c4 1c             	add    $0x1c,%esp
  80237d:	5b                   	pop    %ebx
  80237e:	5e                   	pop    %esi
  80237f:	5f                   	pop    %edi
  802380:	5d                   	pop    %ebp
  802381:	c3                   	ret    
  802382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802388:	31 ff                	xor    %edi,%edi
  80238a:	31 db                	xor    %ebx,%ebx
  80238c:	89 d8                	mov    %ebx,%eax
  80238e:	89 fa                	mov    %edi,%edx
  802390:	83 c4 1c             	add    $0x1c,%esp
  802393:	5b                   	pop    %ebx
  802394:	5e                   	pop    %esi
  802395:	5f                   	pop    %edi
  802396:	5d                   	pop    %ebp
  802397:	c3                   	ret    
  802398:	90                   	nop
  802399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023a0:	89 d8                	mov    %ebx,%eax
  8023a2:	f7 f7                	div    %edi
  8023a4:	31 ff                	xor    %edi,%edi
  8023a6:	89 c3                	mov    %eax,%ebx
  8023a8:	89 d8                	mov    %ebx,%eax
  8023aa:	89 fa                	mov    %edi,%edx
  8023ac:	83 c4 1c             	add    $0x1c,%esp
  8023af:	5b                   	pop    %ebx
  8023b0:	5e                   	pop    %esi
  8023b1:	5f                   	pop    %edi
  8023b2:	5d                   	pop    %ebp
  8023b3:	c3                   	ret    
  8023b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023b8:	39 ce                	cmp    %ecx,%esi
  8023ba:	72 0c                	jb     8023c8 <__udivdi3+0x118>
  8023bc:	31 db                	xor    %ebx,%ebx
  8023be:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8023c2:	0f 87 34 ff ff ff    	ja     8022fc <__udivdi3+0x4c>
  8023c8:	bb 01 00 00 00       	mov    $0x1,%ebx
  8023cd:	e9 2a ff ff ff       	jmp    8022fc <__udivdi3+0x4c>
  8023d2:	66 90                	xchg   %ax,%ax
  8023d4:	66 90                	xchg   %ax,%ax
  8023d6:	66 90                	xchg   %ax,%ax
  8023d8:	66 90                	xchg   %ax,%ax
  8023da:	66 90                	xchg   %ax,%ax
  8023dc:	66 90                	xchg   %ax,%ax
  8023de:	66 90                	xchg   %ax,%ax

008023e0 <__umoddi3>:
  8023e0:	55                   	push   %ebp
  8023e1:	57                   	push   %edi
  8023e2:	56                   	push   %esi
  8023e3:	53                   	push   %ebx
  8023e4:	83 ec 1c             	sub    $0x1c,%esp
  8023e7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023eb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8023ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023f7:	85 d2                	test   %edx,%edx
  8023f9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8023fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802401:	89 f3                	mov    %esi,%ebx
  802403:	89 3c 24             	mov    %edi,(%esp)
  802406:	89 74 24 04          	mov    %esi,0x4(%esp)
  80240a:	75 1c                	jne    802428 <__umoddi3+0x48>
  80240c:	39 f7                	cmp    %esi,%edi
  80240e:	76 50                	jbe    802460 <__umoddi3+0x80>
  802410:	89 c8                	mov    %ecx,%eax
  802412:	89 f2                	mov    %esi,%edx
  802414:	f7 f7                	div    %edi
  802416:	89 d0                	mov    %edx,%eax
  802418:	31 d2                	xor    %edx,%edx
  80241a:	83 c4 1c             	add    $0x1c,%esp
  80241d:	5b                   	pop    %ebx
  80241e:	5e                   	pop    %esi
  80241f:	5f                   	pop    %edi
  802420:	5d                   	pop    %ebp
  802421:	c3                   	ret    
  802422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802428:	39 f2                	cmp    %esi,%edx
  80242a:	89 d0                	mov    %edx,%eax
  80242c:	77 52                	ja     802480 <__umoddi3+0xa0>
  80242e:	0f bd ea             	bsr    %edx,%ebp
  802431:	83 f5 1f             	xor    $0x1f,%ebp
  802434:	75 5a                	jne    802490 <__umoddi3+0xb0>
  802436:	3b 54 24 04          	cmp    0x4(%esp),%edx
  80243a:	0f 82 e0 00 00 00    	jb     802520 <__umoddi3+0x140>
  802440:	39 0c 24             	cmp    %ecx,(%esp)
  802443:	0f 86 d7 00 00 00    	jbe    802520 <__umoddi3+0x140>
  802449:	8b 44 24 08          	mov    0x8(%esp),%eax
  80244d:	8b 54 24 04          	mov    0x4(%esp),%edx
  802451:	83 c4 1c             	add    $0x1c,%esp
  802454:	5b                   	pop    %ebx
  802455:	5e                   	pop    %esi
  802456:	5f                   	pop    %edi
  802457:	5d                   	pop    %ebp
  802458:	c3                   	ret    
  802459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802460:	85 ff                	test   %edi,%edi
  802462:	89 fd                	mov    %edi,%ebp
  802464:	75 0b                	jne    802471 <__umoddi3+0x91>
  802466:	b8 01 00 00 00       	mov    $0x1,%eax
  80246b:	31 d2                	xor    %edx,%edx
  80246d:	f7 f7                	div    %edi
  80246f:	89 c5                	mov    %eax,%ebp
  802471:	89 f0                	mov    %esi,%eax
  802473:	31 d2                	xor    %edx,%edx
  802475:	f7 f5                	div    %ebp
  802477:	89 c8                	mov    %ecx,%eax
  802479:	f7 f5                	div    %ebp
  80247b:	89 d0                	mov    %edx,%eax
  80247d:	eb 99                	jmp    802418 <__umoddi3+0x38>
  80247f:	90                   	nop
  802480:	89 c8                	mov    %ecx,%eax
  802482:	89 f2                	mov    %esi,%edx
  802484:	83 c4 1c             	add    $0x1c,%esp
  802487:	5b                   	pop    %ebx
  802488:	5e                   	pop    %esi
  802489:	5f                   	pop    %edi
  80248a:	5d                   	pop    %ebp
  80248b:	c3                   	ret    
  80248c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802490:	8b 34 24             	mov    (%esp),%esi
  802493:	bf 20 00 00 00       	mov    $0x20,%edi
  802498:	89 e9                	mov    %ebp,%ecx
  80249a:	29 ef                	sub    %ebp,%edi
  80249c:	d3 e0                	shl    %cl,%eax
  80249e:	89 f9                	mov    %edi,%ecx
  8024a0:	89 f2                	mov    %esi,%edx
  8024a2:	d3 ea                	shr    %cl,%edx
  8024a4:	89 e9                	mov    %ebp,%ecx
  8024a6:	09 c2                	or     %eax,%edx
  8024a8:	89 d8                	mov    %ebx,%eax
  8024aa:	89 14 24             	mov    %edx,(%esp)
  8024ad:	89 f2                	mov    %esi,%edx
  8024af:	d3 e2                	shl    %cl,%edx
  8024b1:	89 f9                	mov    %edi,%ecx
  8024b3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024b7:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8024bb:	d3 e8                	shr    %cl,%eax
  8024bd:	89 e9                	mov    %ebp,%ecx
  8024bf:	89 c6                	mov    %eax,%esi
  8024c1:	d3 e3                	shl    %cl,%ebx
  8024c3:	89 f9                	mov    %edi,%ecx
  8024c5:	89 d0                	mov    %edx,%eax
  8024c7:	d3 e8                	shr    %cl,%eax
  8024c9:	89 e9                	mov    %ebp,%ecx
  8024cb:	09 d8                	or     %ebx,%eax
  8024cd:	89 d3                	mov    %edx,%ebx
  8024cf:	89 f2                	mov    %esi,%edx
  8024d1:	f7 34 24             	divl   (%esp)
  8024d4:	89 d6                	mov    %edx,%esi
  8024d6:	d3 e3                	shl    %cl,%ebx
  8024d8:	f7 64 24 04          	mull   0x4(%esp)
  8024dc:	39 d6                	cmp    %edx,%esi
  8024de:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024e2:	89 d1                	mov    %edx,%ecx
  8024e4:	89 c3                	mov    %eax,%ebx
  8024e6:	72 08                	jb     8024f0 <__umoddi3+0x110>
  8024e8:	75 11                	jne    8024fb <__umoddi3+0x11b>
  8024ea:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8024ee:	73 0b                	jae    8024fb <__umoddi3+0x11b>
  8024f0:	2b 44 24 04          	sub    0x4(%esp),%eax
  8024f4:	1b 14 24             	sbb    (%esp),%edx
  8024f7:	89 d1                	mov    %edx,%ecx
  8024f9:	89 c3                	mov    %eax,%ebx
  8024fb:	8b 54 24 08          	mov    0x8(%esp),%edx
  8024ff:	29 da                	sub    %ebx,%edx
  802501:	19 ce                	sbb    %ecx,%esi
  802503:	89 f9                	mov    %edi,%ecx
  802505:	89 f0                	mov    %esi,%eax
  802507:	d3 e0                	shl    %cl,%eax
  802509:	89 e9                	mov    %ebp,%ecx
  80250b:	d3 ea                	shr    %cl,%edx
  80250d:	89 e9                	mov    %ebp,%ecx
  80250f:	d3 ee                	shr    %cl,%esi
  802511:	09 d0                	or     %edx,%eax
  802513:	89 f2                	mov    %esi,%edx
  802515:	83 c4 1c             	add    $0x1c,%esp
  802518:	5b                   	pop    %ebx
  802519:	5e                   	pop    %esi
  80251a:	5f                   	pop    %edi
  80251b:	5d                   	pop    %ebp
  80251c:	c3                   	ret    
  80251d:	8d 76 00             	lea    0x0(%esi),%esi
  802520:	29 f9                	sub    %edi,%ecx
  802522:	19 d6                	sbb    %edx,%esi
  802524:	89 74 24 04          	mov    %esi,0x4(%esp)
  802528:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80252c:	e9 18 ff ff ff       	jmp    802449 <__umoddi3+0x69>
