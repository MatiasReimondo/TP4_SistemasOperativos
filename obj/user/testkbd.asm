
obj/user/testkbd.debug:     formato del fichero elf32-i386


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
  80002c:	e8 3b 02 00 00       	call   80026c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
  80003a:	bb 0a 00 00 00       	mov    $0xa,%ebx
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
		sys_yield();
  80003f:	e8 ec 0d 00 00       	call   800e30 <sys_yield>
umain(int argc, char **argv)
{
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800044:	83 eb 01             	sub    $0x1,%ebx
  800047:	75 f6                	jne    80003f <umain+0xc>
		sys_yield();

	close(0);
  800049:	83 ec 0c             	sub    $0xc,%esp
  80004c:	6a 00                	push   $0x0
  80004e:	e8 c1 10 00 00       	call   801114 <close>
	if ((r = opencons()) < 0)
  800053:	e8 ba 01 00 00       	call   800212 <opencons>
  800058:	83 c4 10             	add    $0x10,%esp
  80005b:	85 c0                	test   %eax,%eax
  80005d:	79 12                	jns    800071 <umain+0x3e>
		panic("opencons: %e", r);
  80005f:	50                   	push   %eax
  800060:	68 e0 1f 80 00       	push   $0x801fe0
  800065:	6a 0f                	push   $0xf
  800067:	68 ed 1f 80 00       	push   $0x801fed
  80006c:	e8 5f 02 00 00       	call   8002d0 <_panic>
	if (r != 0)
  800071:	85 c0                	test   %eax,%eax
  800073:	74 12                	je     800087 <umain+0x54>
		panic("first opencons used fd %d", r);
  800075:	50                   	push   %eax
  800076:	68 fc 1f 80 00       	push   $0x801ffc
  80007b:	6a 11                	push   $0x11
  80007d:	68 ed 1f 80 00       	push   $0x801fed
  800082:	e8 49 02 00 00       	call   8002d0 <_panic>
	if ((r = dup(0, 1)) < 0)
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	6a 01                	push   $0x1
  80008c:	6a 00                	push   $0x0
  80008e:	e8 d1 10 00 00       	call   801164 <dup>
  800093:	83 c4 10             	add    $0x10,%esp
  800096:	85 c0                	test   %eax,%eax
  800098:	79 12                	jns    8000ac <umain+0x79>
		panic("dup: %e", r);
  80009a:	50                   	push   %eax
  80009b:	68 16 20 80 00       	push   $0x802016
  8000a0:	6a 13                	push   $0x13
  8000a2:	68 ed 1f 80 00       	push   $0x801fed
  8000a7:	e8 24 02 00 00       	call   8002d0 <_panic>

	for(;;){
		char *buf;

		buf = readline("Type a line: ");
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 1e 20 80 00       	push   $0x80201e
  8000b4:	e8 29 08 00 00       	call   8008e2 <readline>
		if (buf != NULL)
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	85 c0                	test   %eax,%eax
  8000be:	74 15                	je     8000d5 <umain+0xa2>
			fprintf(1, "%s\n", buf);
  8000c0:	83 ec 04             	sub    $0x4,%esp
  8000c3:	50                   	push   %eax
  8000c4:	68 2c 20 80 00       	push   $0x80202c
  8000c9:	6a 01                	push   $0x1
  8000cb:	e8 b5 17 00 00       	call   801885 <fprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	eb d7                	jmp    8000ac <umain+0x79>
		else
			fprintf(1, "(end of file received)\n");
  8000d5:	83 ec 08             	sub    $0x8,%esp
  8000d8:	68 30 20 80 00       	push   $0x802030
  8000dd:	6a 01                	push   $0x1
  8000df:	e8 a1 17 00 00       	call   801885 <fprintf>
  8000e4:	83 c4 10             	add    $0x10,%esp
  8000e7:	eb c3                	jmp    8000ac <umain+0x79>

008000e9 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8000ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f1:	5d                   	pop    %ebp
  8000f2:	c3                   	ret    

008000f3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8000f9:	68 48 20 80 00       	push   $0x802048
  8000fe:	ff 75 0c             	pushl  0xc(%ebp)
  800101:	e8 08 09 00 00       	call   800a0e <strcpy>
	return 0;
}
  800106:	b8 00 00 00 00       	mov    $0x0,%eax
  80010b:	c9                   	leave  
  80010c:	c3                   	ret    

0080010d <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80010d:	55                   	push   %ebp
  80010e:	89 e5                	mov    %esp,%ebp
  800110:	57                   	push   %edi
  800111:	56                   	push   %esi
  800112:	53                   	push   %ebx
  800113:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800119:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80011e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800124:	eb 2d                	jmp    800153 <devcons_write+0x46>
		m = n - tot;
  800126:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800129:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  80012b:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80012e:	ba 7f 00 00 00       	mov    $0x7f,%edx
  800133:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800136:	83 ec 04             	sub    $0x4,%esp
  800139:	53                   	push   %ebx
  80013a:	03 45 0c             	add    0xc(%ebp),%eax
  80013d:	50                   	push   %eax
  80013e:	57                   	push   %edi
  80013f:	e8 5d 0a 00 00       	call   800ba1 <memmove>
		sys_cputs(buf, m);
  800144:	83 c4 08             	add    $0x8,%esp
  800147:	53                   	push   %ebx
  800148:	57                   	push   %edi
  800149:	e8 52 0c 00 00       	call   800da0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80014e:	01 de                	add    %ebx,%esi
  800150:	83 c4 10             	add    $0x10,%esp
  800153:	89 f0                	mov    %esi,%eax
  800155:	3b 75 10             	cmp    0x10(%ebp),%esi
  800158:	72 cc                	jb     800126 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80015a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80015d:	5b                   	pop    %ebx
  80015e:	5e                   	pop    %esi
  80015f:	5f                   	pop    %edi
  800160:	5d                   	pop    %ebp
  800161:	c3                   	ret    

00800162 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800162:	55                   	push   %ebp
  800163:	89 e5                	mov    %esp,%ebp
  800165:	83 ec 08             	sub    $0x8,%esp
  800168:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  80016d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800171:	74 2a                	je     80019d <devcons_read+0x3b>
  800173:	eb 05                	jmp    80017a <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800175:	e8 b6 0c 00 00       	call   800e30 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80017a:	e8 47 0c 00 00       	call   800dc6 <sys_cgetc>
  80017f:	85 c0                	test   %eax,%eax
  800181:	74 f2                	je     800175 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800183:	85 c0                	test   %eax,%eax
  800185:	78 16                	js     80019d <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  800187:	83 f8 04             	cmp    $0x4,%eax
  80018a:	74 0c                	je     800198 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80018c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80018f:	88 02                	mov    %al,(%edx)
	return 1;
  800191:	b8 01 00 00 00       	mov    $0x1,%eax
  800196:	eb 05                	jmp    80019d <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  800198:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  80019d:	c9                   	leave  
  80019e:	c3                   	ret    

0080019f <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8001a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a8:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8001ab:	6a 01                	push   $0x1
  8001ad:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001b0:	50                   	push   %eax
  8001b1:	e8 ea 0b 00 00       	call   800da0 <sys_cputs>
}
  8001b6:	83 c4 10             	add    $0x10,%esp
  8001b9:	c9                   	leave  
  8001ba:	c3                   	ret    

008001bb <getchar>:

int
getchar(void)
{
  8001bb:	55                   	push   %ebp
  8001bc:	89 e5                	mov    %esp,%ebp
  8001be:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8001c1:	6a 01                	push   $0x1
  8001c3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001c6:	50                   	push   %eax
  8001c7:	6a 00                	push   $0x0
  8001c9:	e8 82 10 00 00       	call   801250 <read>
	if (r < 0)
  8001ce:	83 c4 10             	add    $0x10,%esp
  8001d1:	85 c0                	test   %eax,%eax
  8001d3:	78 0f                	js     8001e4 <getchar+0x29>
		return r;
	if (r < 1)
  8001d5:	85 c0                	test   %eax,%eax
  8001d7:	7e 06                	jle    8001df <getchar+0x24>
		return -E_EOF;
	return c;
  8001d9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8001dd:	eb 05                	jmp    8001e4 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8001df:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8001e4:	c9                   	leave  
  8001e5:	c3                   	ret    

008001e6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8001ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8001ef:	50                   	push   %eax
  8001f0:	ff 75 08             	pushl  0x8(%ebp)
  8001f3:	e8 f3 0d 00 00       	call   800feb <fd_lookup>
  8001f8:	83 c4 10             	add    $0x10,%esp
  8001fb:	85 c0                	test   %eax,%eax
  8001fd:	78 11                	js     800210 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8001ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800202:	8b 15 00 30 80 00    	mov    0x803000,%edx
  800208:	39 10                	cmp    %edx,(%eax)
  80020a:	0f 94 c0             	sete   %al
  80020d:	0f b6 c0             	movzbl %al,%eax
}
  800210:	c9                   	leave  
  800211:	c3                   	ret    

00800212 <opencons>:

int
opencons(void)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800218:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80021b:	50                   	push   %eax
  80021c:	e8 7b 0d 00 00       	call   800f9c <fd_alloc>
  800221:	83 c4 10             	add    $0x10,%esp
		return r;
  800224:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800226:	85 c0                	test   %eax,%eax
  800228:	78 3e                	js     800268 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80022a:	83 ec 04             	sub    $0x4,%esp
  80022d:	68 07 04 00 00       	push   $0x407
  800232:	ff 75 f4             	pushl  -0xc(%ebp)
  800235:	6a 00                	push   $0x0
  800237:	e8 1b 0c 00 00       	call   800e57 <sys_page_alloc>
  80023c:	83 c4 10             	add    $0x10,%esp
		return r;
  80023f:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800241:	85 c0                	test   %eax,%eax
  800243:	78 23                	js     800268 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800245:	8b 15 00 30 80 00    	mov    0x803000,%edx
  80024b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80024e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800250:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800253:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80025a:	83 ec 0c             	sub    $0xc,%esp
  80025d:	50                   	push   %eax
  80025e:	e8 11 0d 00 00       	call   800f74 <fd2num>
  800263:	89 c2                	mov    %eax,%edx
  800265:	83 c4 10             	add    $0x10,%esp
}
  800268:	89 d0                	mov    %edx,%eax
  80026a:	c9                   	leave  
  80026b:	c3                   	ret    

0080026c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	56                   	push   %esi
  800270:	53                   	push   %ebx
  800271:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800274:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800277:	e8 90 0b 00 00       	call   800e0c <sys_getenvid>
	if (id >= 0)
  80027c:	85 c0                	test   %eax,%eax
  80027e:	78 12                	js     800292 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  800280:	25 ff 03 00 00       	and    $0x3ff,%eax
  800285:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800288:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80028d:	a3 04 44 80 00       	mov    %eax,0x804404

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800292:	85 db                	test   %ebx,%ebx
  800294:	7e 07                	jle    80029d <libmain+0x31>
		binaryname = argv[0];
  800296:	8b 06                	mov    (%esi),%eax
  800298:	a3 1c 30 80 00       	mov    %eax,0x80301c

	// call user main routine
	umain(argc, argv);
  80029d:	83 ec 08             	sub    $0x8,%esp
  8002a0:	56                   	push   %esi
  8002a1:	53                   	push   %ebx
  8002a2:	e8 8c fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8002a7:	e8 0a 00 00 00       	call   8002b6 <exit>
}
  8002ac:	83 c4 10             	add    $0x10,%esp
  8002af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002b2:	5b                   	pop    %ebx
  8002b3:	5e                   	pop    %esi
  8002b4:	5d                   	pop    %ebp
  8002b5:	c3                   	ret    

008002b6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
  8002b9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8002bc:	e8 7e 0e 00 00       	call   80113f <close_all>
	sys_env_destroy(0);
  8002c1:	83 ec 0c             	sub    $0xc,%esp
  8002c4:	6a 00                	push   $0x0
  8002c6:	e8 1f 0b 00 00       	call   800dea <sys_env_destroy>
}
  8002cb:	83 c4 10             	add    $0x10,%esp
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	56                   	push   %esi
  8002d4:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8002d5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002d8:	8b 35 1c 30 80 00    	mov    0x80301c,%esi
  8002de:	e8 29 0b 00 00       	call   800e0c <sys_getenvid>
  8002e3:	83 ec 0c             	sub    $0xc,%esp
  8002e6:	ff 75 0c             	pushl  0xc(%ebp)
  8002e9:	ff 75 08             	pushl  0x8(%ebp)
  8002ec:	56                   	push   %esi
  8002ed:	50                   	push   %eax
  8002ee:	68 60 20 80 00       	push   $0x802060
  8002f3:	e8 b1 00 00 00       	call   8003a9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002f8:	83 c4 18             	add    $0x18,%esp
  8002fb:	53                   	push   %ebx
  8002fc:	ff 75 10             	pushl  0x10(%ebp)
  8002ff:	e8 54 00 00 00       	call   800358 <vcprintf>
	cprintf("\n");
  800304:	c7 04 24 46 20 80 00 	movl   $0x802046,(%esp)
  80030b:	e8 99 00 00 00       	call   8003a9 <cprintf>
  800310:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800313:	cc                   	int3   
  800314:	eb fd                	jmp    800313 <_panic+0x43>

00800316 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800316:	55                   	push   %ebp
  800317:	89 e5                	mov    %esp,%ebp
  800319:	53                   	push   %ebx
  80031a:	83 ec 04             	sub    $0x4,%esp
  80031d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800320:	8b 13                	mov    (%ebx),%edx
  800322:	8d 42 01             	lea    0x1(%edx),%eax
  800325:	89 03                	mov    %eax,(%ebx)
  800327:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80032a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80032e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800333:	75 1a                	jne    80034f <putch+0x39>
		sys_cputs(b->buf, b->idx);
  800335:	83 ec 08             	sub    $0x8,%esp
  800338:	68 ff 00 00 00       	push   $0xff
  80033d:	8d 43 08             	lea    0x8(%ebx),%eax
  800340:	50                   	push   %eax
  800341:	e8 5a 0a 00 00       	call   800da0 <sys_cputs>
		b->idx = 0;
  800346:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80034c:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  80034f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800353:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800356:	c9                   	leave  
  800357:	c3                   	ret    

00800358 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800358:	55                   	push   %ebp
  800359:	89 e5                	mov    %esp,%ebp
  80035b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800361:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800368:	00 00 00 
	b.cnt = 0;
  80036b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800372:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800375:	ff 75 0c             	pushl  0xc(%ebp)
  800378:	ff 75 08             	pushl  0x8(%ebp)
  80037b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800381:	50                   	push   %eax
  800382:	68 16 03 80 00       	push   $0x800316
  800387:	e8 86 01 00 00       	call   800512 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80038c:	83 c4 08             	add    $0x8,%esp
  80038f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800395:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80039b:	50                   	push   %eax
  80039c:	e8 ff 09 00 00       	call   800da0 <sys_cputs>

	return b.cnt;
}
  8003a1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003a7:	c9                   	leave  
  8003a8:	c3                   	ret    

008003a9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003af:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003b2:	50                   	push   %eax
  8003b3:	ff 75 08             	pushl  0x8(%ebp)
  8003b6:	e8 9d ff ff ff       	call   800358 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003bb:	c9                   	leave  
  8003bc:	c3                   	ret    

008003bd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	57                   	push   %edi
  8003c1:	56                   	push   %esi
  8003c2:	53                   	push   %ebx
  8003c3:	83 ec 1c             	sub    $0x1c,%esp
  8003c6:	89 c7                	mov    %eax,%edi
  8003c8:	89 d6                	mov    %edx,%esi
  8003ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8003d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003de:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8003e1:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8003e4:	39 d3                	cmp    %edx,%ebx
  8003e6:	72 05                	jb     8003ed <printnum+0x30>
  8003e8:	39 45 10             	cmp    %eax,0x10(%ebp)
  8003eb:	77 45                	ja     800432 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003ed:	83 ec 0c             	sub    $0xc,%esp
  8003f0:	ff 75 18             	pushl  0x18(%ebp)
  8003f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003f9:	53                   	push   %ebx
  8003fa:	ff 75 10             	pushl  0x10(%ebp)
  8003fd:	83 ec 08             	sub    $0x8,%esp
  800400:	ff 75 e4             	pushl  -0x1c(%ebp)
  800403:	ff 75 e0             	pushl  -0x20(%ebp)
  800406:	ff 75 dc             	pushl  -0x24(%ebp)
  800409:	ff 75 d8             	pushl  -0x28(%ebp)
  80040c:	e8 3f 19 00 00       	call   801d50 <__udivdi3>
  800411:	83 c4 18             	add    $0x18,%esp
  800414:	52                   	push   %edx
  800415:	50                   	push   %eax
  800416:	89 f2                	mov    %esi,%edx
  800418:	89 f8                	mov    %edi,%eax
  80041a:	e8 9e ff ff ff       	call   8003bd <printnum>
  80041f:	83 c4 20             	add    $0x20,%esp
  800422:	eb 18                	jmp    80043c <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800424:	83 ec 08             	sub    $0x8,%esp
  800427:	56                   	push   %esi
  800428:	ff 75 18             	pushl  0x18(%ebp)
  80042b:	ff d7                	call   *%edi
  80042d:	83 c4 10             	add    $0x10,%esp
  800430:	eb 03                	jmp    800435 <printnum+0x78>
  800432:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800435:	83 eb 01             	sub    $0x1,%ebx
  800438:	85 db                	test   %ebx,%ebx
  80043a:	7f e8                	jg     800424 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80043c:	83 ec 08             	sub    $0x8,%esp
  80043f:	56                   	push   %esi
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	ff 75 e4             	pushl  -0x1c(%ebp)
  800446:	ff 75 e0             	pushl  -0x20(%ebp)
  800449:	ff 75 dc             	pushl  -0x24(%ebp)
  80044c:	ff 75 d8             	pushl  -0x28(%ebp)
  80044f:	e8 2c 1a 00 00       	call   801e80 <__umoddi3>
  800454:	83 c4 14             	add    $0x14,%esp
  800457:	0f be 80 83 20 80 00 	movsbl 0x802083(%eax),%eax
  80045e:	50                   	push   %eax
  80045f:	ff d7                	call   *%edi
}
  800461:	83 c4 10             	add    $0x10,%esp
  800464:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800467:	5b                   	pop    %ebx
  800468:	5e                   	pop    %esi
  800469:	5f                   	pop    %edi
  80046a:	5d                   	pop    %ebp
  80046b:	c3                   	ret    

0080046c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80046f:	83 fa 01             	cmp    $0x1,%edx
  800472:	7e 0e                	jle    800482 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800474:	8b 10                	mov    (%eax),%edx
  800476:	8d 4a 08             	lea    0x8(%edx),%ecx
  800479:	89 08                	mov    %ecx,(%eax)
  80047b:	8b 02                	mov    (%edx),%eax
  80047d:	8b 52 04             	mov    0x4(%edx),%edx
  800480:	eb 22                	jmp    8004a4 <getuint+0x38>
	else if (lflag)
  800482:	85 d2                	test   %edx,%edx
  800484:	74 10                	je     800496 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800486:	8b 10                	mov    (%eax),%edx
  800488:	8d 4a 04             	lea    0x4(%edx),%ecx
  80048b:	89 08                	mov    %ecx,(%eax)
  80048d:	8b 02                	mov    (%edx),%eax
  80048f:	ba 00 00 00 00       	mov    $0x0,%edx
  800494:	eb 0e                	jmp    8004a4 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800496:	8b 10                	mov    (%eax),%edx
  800498:	8d 4a 04             	lea    0x4(%edx),%ecx
  80049b:	89 08                	mov    %ecx,(%eax)
  80049d:	8b 02                	mov    (%edx),%eax
  80049f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004a4:	5d                   	pop    %ebp
  8004a5:	c3                   	ret    

008004a6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004a9:	83 fa 01             	cmp    $0x1,%edx
  8004ac:	7e 0e                	jle    8004bc <getint+0x16>
		return va_arg(*ap, long long);
  8004ae:	8b 10                	mov    (%eax),%edx
  8004b0:	8d 4a 08             	lea    0x8(%edx),%ecx
  8004b3:	89 08                	mov    %ecx,(%eax)
  8004b5:	8b 02                	mov    (%edx),%eax
  8004b7:	8b 52 04             	mov    0x4(%edx),%edx
  8004ba:	eb 1a                	jmp    8004d6 <getint+0x30>
	else if (lflag)
  8004bc:	85 d2                	test   %edx,%edx
  8004be:	74 0c                	je     8004cc <getint+0x26>
		return va_arg(*ap, long);
  8004c0:	8b 10                	mov    (%eax),%edx
  8004c2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004c5:	89 08                	mov    %ecx,(%eax)
  8004c7:	8b 02                	mov    (%edx),%eax
  8004c9:	99                   	cltd   
  8004ca:	eb 0a                	jmp    8004d6 <getint+0x30>
	else
		return va_arg(*ap, int);
  8004cc:	8b 10                	mov    (%eax),%edx
  8004ce:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004d1:	89 08                	mov    %ecx,(%eax)
  8004d3:	8b 02                	mov    (%edx),%eax
  8004d5:	99                   	cltd   
}
  8004d6:	5d                   	pop    %ebp
  8004d7:	c3                   	ret    

008004d8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004d8:	55                   	push   %ebp
  8004d9:	89 e5                	mov    %esp,%ebp
  8004db:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004de:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004e2:	8b 10                	mov    (%eax),%edx
  8004e4:	3b 50 04             	cmp    0x4(%eax),%edx
  8004e7:	73 0a                	jae    8004f3 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004e9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004ec:	89 08                	mov    %ecx,(%eax)
  8004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f1:	88 02                	mov    %al,(%edx)
}
  8004f3:	5d                   	pop    %ebp
  8004f4:	c3                   	ret    

008004f5 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8004f5:	55                   	push   %ebp
  8004f6:	89 e5                	mov    %esp,%ebp
  8004f8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8004fb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004fe:	50                   	push   %eax
  8004ff:	ff 75 10             	pushl  0x10(%ebp)
  800502:	ff 75 0c             	pushl  0xc(%ebp)
  800505:	ff 75 08             	pushl  0x8(%ebp)
  800508:	e8 05 00 00 00       	call   800512 <vprintfmt>
	va_end(ap);
}
  80050d:	83 c4 10             	add    $0x10,%esp
  800510:	c9                   	leave  
  800511:	c3                   	ret    

00800512 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800512:	55                   	push   %ebp
  800513:	89 e5                	mov    %esp,%ebp
  800515:	57                   	push   %edi
  800516:	56                   	push   %esi
  800517:	53                   	push   %ebx
  800518:	83 ec 2c             	sub    $0x2c,%esp
  80051b:	8b 75 08             	mov    0x8(%ebp),%esi
  80051e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800521:	8b 7d 10             	mov    0x10(%ebp),%edi
  800524:	eb 12                	jmp    800538 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800526:	85 c0                	test   %eax,%eax
  800528:	0f 84 44 03 00 00    	je     800872 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  80052e:	83 ec 08             	sub    $0x8,%esp
  800531:	53                   	push   %ebx
  800532:	50                   	push   %eax
  800533:	ff d6                	call   *%esi
  800535:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800538:	83 c7 01             	add    $0x1,%edi
  80053b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80053f:	83 f8 25             	cmp    $0x25,%eax
  800542:	75 e2                	jne    800526 <vprintfmt+0x14>
  800544:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800548:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80054f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800556:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80055d:	ba 00 00 00 00       	mov    $0x0,%edx
  800562:	eb 07                	jmp    80056b <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800564:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800567:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80056b:	8d 47 01             	lea    0x1(%edi),%eax
  80056e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800571:	0f b6 07             	movzbl (%edi),%eax
  800574:	0f b6 c8             	movzbl %al,%ecx
  800577:	83 e8 23             	sub    $0x23,%eax
  80057a:	3c 55                	cmp    $0x55,%al
  80057c:	0f 87 d5 02 00 00    	ja     800857 <vprintfmt+0x345>
  800582:	0f b6 c0             	movzbl %al,%eax
  800585:	ff 24 85 c0 21 80 00 	jmp    *0x8021c0(,%eax,4)
  80058c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80058f:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800593:	eb d6                	jmp    80056b <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800595:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800598:	b8 00 00 00 00       	mov    $0x0,%eax
  80059d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8005a0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005a3:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8005a7:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8005aa:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8005ad:	83 fa 09             	cmp    $0x9,%edx
  8005b0:	77 39                	ja     8005eb <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005b2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005b5:	eb e9                	jmp    8005a0 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8d 48 04             	lea    0x4(%eax),%ecx
  8005bd:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8005c0:	8b 00                	mov    (%eax),%eax
  8005c2:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8005c8:	eb 27                	jmp    8005f1 <vprintfmt+0xdf>
  8005ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005cd:	85 c0                	test   %eax,%eax
  8005cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d4:	0f 49 c8             	cmovns %eax,%ecx
  8005d7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005dd:	eb 8c                	jmp    80056b <vprintfmt+0x59>
  8005df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8005e2:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005e9:	eb 80                	jmp    80056b <vprintfmt+0x59>
  8005eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005ee:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  8005f1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005f5:	0f 89 70 ff ff ff    	jns    80056b <vprintfmt+0x59>
				width = precision, precision = -1;
  8005fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800601:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800608:	e9 5e ff ff ff       	jmp    80056b <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80060d:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800610:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800613:	e9 53 ff ff ff       	jmp    80056b <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8d 50 04             	lea    0x4(%eax),%edx
  80061e:	89 55 14             	mov    %edx,0x14(%ebp)
  800621:	83 ec 08             	sub    $0x8,%esp
  800624:	53                   	push   %ebx
  800625:	ff 30                	pushl  (%eax)
  800627:	ff d6                	call   *%esi
			break;
  800629:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80062c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  80062f:	e9 04 ff ff ff       	jmp    800538 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	8d 50 04             	lea    0x4(%eax),%edx
  80063a:	89 55 14             	mov    %edx,0x14(%ebp)
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	99                   	cltd   
  800640:	31 d0                	xor    %edx,%eax
  800642:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800644:	83 f8 0f             	cmp    $0xf,%eax
  800647:	7f 0b                	jg     800654 <vprintfmt+0x142>
  800649:	8b 14 85 20 23 80 00 	mov    0x802320(,%eax,4),%edx
  800650:	85 d2                	test   %edx,%edx
  800652:	75 18                	jne    80066c <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  800654:	50                   	push   %eax
  800655:	68 9b 20 80 00       	push   $0x80209b
  80065a:	53                   	push   %ebx
  80065b:	56                   	push   %esi
  80065c:	e8 94 fe ff ff       	call   8004f5 <printfmt>
  800661:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800664:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800667:	e9 cc fe ff ff       	jmp    800538 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  80066c:	52                   	push   %edx
  80066d:	68 65 24 80 00       	push   $0x802465
  800672:	53                   	push   %ebx
  800673:	56                   	push   %esi
  800674:	e8 7c fe ff ff       	call   8004f5 <printfmt>
  800679:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80067f:	e9 b4 fe ff ff       	jmp    800538 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8d 50 04             	lea    0x4(%eax),%edx
  80068a:	89 55 14             	mov    %edx,0x14(%ebp)
  80068d:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80068f:	85 ff                	test   %edi,%edi
  800691:	b8 94 20 80 00       	mov    $0x802094,%eax
  800696:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800699:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80069d:	0f 8e 94 00 00 00    	jle    800737 <vprintfmt+0x225>
  8006a3:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8006a7:	0f 84 98 00 00 00    	je     800745 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ad:	83 ec 08             	sub    $0x8,%esp
  8006b0:	ff 75 d0             	pushl  -0x30(%ebp)
  8006b3:	57                   	push   %edi
  8006b4:	e8 34 03 00 00       	call   8009ed <strnlen>
  8006b9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006bc:	29 c1                	sub    %eax,%ecx
  8006be:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8006c1:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8006c4:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006cb:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006ce:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d0:	eb 0f                	jmp    8006e1 <vprintfmt+0x1cf>
					putch(padc, putdat);
  8006d2:	83 ec 08             	sub    $0x8,%esp
  8006d5:	53                   	push   %ebx
  8006d6:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d9:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006db:	83 ef 01             	sub    $0x1,%edi
  8006de:	83 c4 10             	add    $0x10,%esp
  8006e1:	85 ff                	test   %edi,%edi
  8006e3:	7f ed                	jg     8006d2 <vprintfmt+0x1c0>
  8006e5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006e8:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8006eb:	85 c9                	test   %ecx,%ecx
  8006ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f2:	0f 49 c1             	cmovns %ecx,%eax
  8006f5:	29 c1                	sub    %eax,%ecx
  8006f7:	89 75 08             	mov    %esi,0x8(%ebp)
  8006fa:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006fd:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800700:	89 cb                	mov    %ecx,%ebx
  800702:	eb 4d                	jmp    800751 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800704:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800708:	74 1b                	je     800725 <vprintfmt+0x213>
  80070a:	0f be c0             	movsbl %al,%eax
  80070d:	83 e8 20             	sub    $0x20,%eax
  800710:	83 f8 5e             	cmp    $0x5e,%eax
  800713:	76 10                	jbe    800725 <vprintfmt+0x213>
					putch('?', putdat);
  800715:	83 ec 08             	sub    $0x8,%esp
  800718:	ff 75 0c             	pushl  0xc(%ebp)
  80071b:	6a 3f                	push   $0x3f
  80071d:	ff 55 08             	call   *0x8(%ebp)
  800720:	83 c4 10             	add    $0x10,%esp
  800723:	eb 0d                	jmp    800732 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  800725:	83 ec 08             	sub    $0x8,%esp
  800728:	ff 75 0c             	pushl  0xc(%ebp)
  80072b:	52                   	push   %edx
  80072c:	ff 55 08             	call   *0x8(%ebp)
  80072f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800732:	83 eb 01             	sub    $0x1,%ebx
  800735:	eb 1a                	jmp    800751 <vprintfmt+0x23f>
  800737:	89 75 08             	mov    %esi,0x8(%ebp)
  80073a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80073d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800740:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800743:	eb 0c                	jmp    800751 <vprintfmt+0x23f>
  800745:	89 75 08             	mov    %esi,0x8(%ebp)
  800748:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80074b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80074e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800751:	83 c7 01             	add    $0x1,%edi
  800754:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800758:	0f be d0             	movsbl %al,%edx
  80075b:	85 d2                	test   %edx,%edx
  80075d:	74 23                	je     800782 <vprintfmt+0x270>
  80075f:	85 f6                	test   %esi,%esi
  800761:	78 a1                	js     800704 <vprintfmt+0x1f2>
  800763:	83 ee 01             	sub    $0x1,%esi
  800766:	79 9c                	jns    800704 <vprintfmt+0x1f2>
  800768:	89 df                	mov    %ebx,%edi
  80076a:	8b 75 08             	mov    0x8(%ebp),%esi
  80076d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800770:	eb 18                	jmp    80078a <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800772:	83 ec 08             	sub    $0x8,%esp
  800775:	53                   	push   %ebx
  800776:	6a 20                	push   $0x20
  800778:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80077a:	83 ef 01             	sub    $0x1,%edi
  80077d:	83 c4 10             	add    $0x10,%esp
  800780:	eb 08                	jmp    80078a <vprintfmt+0x278>
  800782:	89 df                	mov    %ebx,%edi
  800784:	8b 75 08             	mov    0x8(%ebp),%esi
  800787:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80078a:	85 ff                	test   %edi,%edi
  80078c:	7f e4                	jg     800772 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80078e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800791:	e9 a2 fd ff ff       	jmp    800538 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800796:	8d 45 14             	lea    0x14(%ebp),%eax
  800799:	e8 08 fd ff ff       	call   8004a6 <getint>
  80079e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8007a4:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8007a9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007ad:	79 74                	jns    800823 <vprintfmt+0x311>
				putch('-', putdat);
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	53                   	push   %ebx
  8007b3:	6a 2d                	push   $0x2d
  8007b5:	ff d6                	call   *%esi
				num = -(long long) num;
  8007b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ba:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007bd:	f7 d8                	neg    %eax
  8007bf:	83 d2 00             	adc    $0x0,%edx
  8007c2:	f7 da                	neg    %edx
  8007c4:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8007c7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8007cc:	eb 55                	jmp    800823 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007ce:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d1:	e8 96 fc ff ff       	call   80046c <getuint>
			base = 10;
  8007d6:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8007db:	eb 46                	jmp    800823 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8007dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8007e0:	e8 87 fc ff ff       	call   80046c <getuint>
			base = 8;
  8007e5:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8007ea:	eb 37                	jmp    800823 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  8007ec:	83 ec 08             	sub    $0x8,%esp
  8007ef:	53                   	push   %ebx
  8007f0:	6a 30                	push   $0x30
  8007f2:	ff d6                	call   *%esi
			putch('x', putdat);
  8007f4:	83 c4 08             	add    $0x8,%esp
  8007f7:	53                   	push   %ebx
  8007f8:	6a 78                	push   $0x78
  8007fa:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ff:	8d 50 04             	lea    0x4(%eax),%edx
  800802:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800805:	8b 00                	mov    (%eax),%eax
  800807:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  80080c:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80080f:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800814:	eb 0d                	jmp    800823 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800816:	8d 45 14             	lea    0x14(%ebp),%eax
  800819:	e8 4e fc ff ff       	call   80046c <getuint>
			base = 16;
  80081e:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800823:	83 ec 0c             	sub    $0xc,%esp
  800826:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80082a:	57                   	push   %edi
  80082b:	ff 75 e0             	pushl  -0x20(%ebp)
  80082e:	51                   	push   %ecx
  80082f:	52                   	push   %edx
  800830:	50                   	push   %eax
  800831:	89 da                	mov    %ebx,%edx
  800833:	89 f0                	mov    %esi,%eax
  800835:	e8 83 fb ff ff       	call   8003bd <printnum>
			break;
  80083a:	83 c4 20             	add    $0x20,%esp
  80083d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800840:	e9 f3 fc ff ff       	jmp    800538 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	53                   	push   %ebx
  800849:	51                   	push   %ecx
  80084a:	ff d6                	call   *%esi
			break;
  80084c:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80084f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800852:	e9 e1 fc ff ff       	jmp    800538 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800857:	83 ec 08             	sub    $0x8,%esp
  80085a:	53                   	push   %ebx
  80085b:	6a 25                	push   $0x25
  80085d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80085f:	83 c4 10             	add    $0x10,%esp
  800862:	eb 03                	jmp    800867 <vprintfmt+0x355>
  800864:	83 ef 01             	sub    $0x1,%edi
  800867:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  80086b:	75 f7                	jne    800864 <vprintfmt+0x352>
  80086d:	e9 c6 fc ff ff       	jmp    800538 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  800872:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800875:	5b                   	pop    %ebx
  800876:	5e                   	pop    %esi
  800877:	5f                   	pop    %edi
  800878:	5d                   	pop    %ebp
  800879:	c3                   	ret    

0080087a <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80087a:	55                   	push   %ebp
  80087b:	89 e5                	mov    %esp,%ebp
  80087d:	83 ec 18             	sub    $0x18,%esp
  800880:	8b 45 08             	mov    0x8(%ebp),%eax
  800883:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800886:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800889:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80088d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800890:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800897:	85 c0                	test   %eax,%eax
  800899:	74 26                	je     8008c1 <vsnprintf+0x47>
  80089b:	85 d2                	test   %edx,%edx
  80089d:	7e 22                	jle    8008c1 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80089f:	ff 75 14             	pushl  0x14(%ebp)
  8008a2:	ff 75 10             	pushl  0x10(%ebp)
  8008a5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008a8:	50                   	push   %eax
  8008a9:	68 d8 04 80 00       	push   $0x8004d8
  8008ae:	e8 5f fc ff ff       	call   800512 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008bc:	83 c4 10             	add    $0x10,%esp
  8008bf:	eb 05                	jmp    8008c6 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8008c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8008c6:	c9                   	leave  
  8008c7:	c3                   	ret    

008008c8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008ce:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008d1:	50                   	push   %eax
  8008d2:	ff 75 10             	pushl  0x10(%ebp)
  8008d5:	ff 75 0c             	pushl  0xc(%ebp)
  8008d8:	ff 75 08             	pushl  0x8(%ebp)
  8008db:	e8 9a ff ff ff       	call   80087a <vsnprintf>
	va_end(ap);

	return rc;
}
  8008e0:	c9                   	leave  
  8008e1:	c3                   	ret    

008008e2 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
  8008e5:	57                   	push   %edi
  8008e6:	56                   	push   %esi
  8008e7:	53                   	push   %ebx
  8008e8:	83 ec 0c             	sub    $0xc,%esp
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  8008ee:	85 c0                	test   %eax,%eax
  8008f0:	74 13                	je     800905 <readline+0x23>
		fprintf(1, "%s", prompt);
  8008f2:	83 ec 04             	sub    $0x4,%esp
  8008f5:	50                   	push   %eax
  8008f6:	68 65 24 80 00       	push   $0x802465
  8008fb:	6a 01                	push   $0x1
  8008fd:	e8 83 0f 00 00       	call   801885 <fprintf>
  800902:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  800905:	83 ec 0c             	sub    $0xc,%esp
  800908:	6a 00                	push   $0x0
  80090a:	e8 d7 f8 ff ff       	call   8001e6 <iscons>
  80090f:	89 c7                	mov    %eax,%edi
  800911:	83 c4 10             	add    $0x10,%esp
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
  800914:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
	while (1) {
		c = getchar();
  800919:	e8 9d f8 ff ff       	call   8001bb <getchar>
  80091e:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  800920:	85 c0                	test   %eax,%eax
  800922:	79 29                	jns    80094d <readline+0x6b>
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  800924:	b8 00 00 00 00       	mov    $0x0,%eax
	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
  800929:	83 fb f8             	cmp    $0xfffffff8,%ebx
  80092c:	0f 84 9b 00 00 00    	je     8009cd <readline+0xeb>
				cprintf("read error: %e\n", c);
  800932:	83 ec 08             	sub    $0x8,%esp
  800935:	53                   	push   %ebx
  800936:	68 7f 23 80 00       	push   $0x80237f
  80093b:	e8 69 fa ff ff       	call   8003a9 <cprintf>
  800940:	83 c4 10             	add    $0x10,%esp
			return NULL;
  800943:	b8 00 00 00 00       	mov    $0x0,%eax
  800948:	e9 80 00 00 00       	jmp    8009cd <readline+0xeb>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  80094d:	83 f8 08             	cmp    $0x8,%eax
  800950:	0f 94 c2             	sete   %dl
  800953:	83 f8 7f             	cmp    $0x7f,%eax
  800956:	0f 94 c0             	sete   %al
  800959:	08 c2                	or     %al,%dl
  80095b:	74 1a                	je     800977 <readline+0x95>
  80095d:	85 f6                	test   %esi,%esi
  80095f:	7e 16                	jle    800977 <readline+0x95>
			if (echoing)
  800961:	85 ff                	test   %edi,%edi
  800963:	74 0d                	je     800972 <readline+0x90>
				cputchar('\b');
  800965:	83 ec 0c             	sub    $0xc,%esp
  800968:	6a 08                	push   $0x8
  80096a:	e8 30 f8 ff ff       	call   80019f <cputchar>
  80096f:	83 c4 10             	add    $0x10,%esp
			i--;
  800972:	83 ee 01             	sub    $0x1,%esi
  800975:	eb a2                	jmp    800919 <readline+0x37>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800977:	83 fb 1f             	cmp    $0x1f,%ebx
  80097a:	7e 26                	jle    8009a2 <readline+0xc0>
  80097c:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800982:	7f 1e                	jg     8009a2 <readline+0xc0>
			if (echoing)
  800984:	85 ff                	test   %edi,%edi
  800986:	74 0c                	je     800994 <readline+0xb2>
				cputchar(c);
  800988:	83 ec 0c             	sub    $0xc,%esp
  80098b:	53                   	push   %ebx
  80098c:	e8 0e f8 ff ff       	call   80019f <cputchar>
  800991:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800994:	88 9e 00 40 80 00    	mov    %bl,0x804000(%esi)
  80099a:	8d 76 01             	lea    0x1(%esi),%esi
  80099d:	e9 77 ff ff ff       	jmp    800919 <readline+0x37>
		} else if (c == '\n' || c == '\r') {
  8009a2:	83 fb 0a             	cmp    $0xa,%ebx
  8009a5:	74 09                	je     8009b0 <readline+0xce>
  8009a7:	83 fb 0d             	cmp    $0xd,%ebx
  8009aa:	0f 85 69 ff ff ff    	jne    800919 <readline+0x37>
			if (echoing)
  8009b0:	85 ff                	test   %edi,%edi
  8009b2:	74 0d                	je     8009c1 <readline+0xdf>
				cputchar('\n');
  8009b4:	83 ec 0c             	sub    $0xc,%esp
  8009b7:	6a 0a                	push   $0xa
  8009b9:	e8 e1 f7 ff ff       	call   80019f <cputchar>
  8009be:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8009c1:	c6 86 00 40 80 00 00 	movb   $0x0,0x804000(%esi)
			return buf;
  8009c8:	b8 00 40 80 00       	mov    $0x804000,%eax
		}
	}
}
  8009cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009d0:	5b                   	pop    %ebx
  8009d1:	5e                   	pop    %esi
  8009d2:	5f                   	pop    %edi
  8009d3:	5d                   	pop    %ebp
  8009d4:	c3                   	ret    

008009d5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009db:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e0:	eb 03                	jmp    8009e5 <strlen+0x10>
		n++;
  8009e2:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009e5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009e9:	75 f7                	jne    8009e2 <strlen+0xd>
		n++;
	return n;
}
  8009eb:	5d                   	pop    %ebp
  8009ec:	c3                   	ret    

008009ed <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f3:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fb:	eb 03                	jmp    800a00 <strnlen+0x13>
		n++;
  8009fd:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a00:	39 c2                	cmp    %eax,%edx
  800a02:	74 08                	je     800a0c <strnlen+0x1f>
  800a04:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a08:	75 f3                	jne    8009fd <strnlen+0x10>
  800a0a:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  800a0c:	5d                   	pop    %ebp
  800a0d:	c3                   	ret    

00800a0e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	53                   	push   %ebx
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a18:	89 c2                	mov    %eax,%edx
  800a1a:	83 c2 01             	add    $0x1,%edx
  800a1d:	83 c1 01             	add    $0x1,%ecx
  800a20:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a24:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a27:	84 db                	test   %bl,%bl
  800a29:	75 ef                	jne    800a1a <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a2b:	5b                   	pop    %ebx
  800a2c:	5d                   	pop    %ebp
  800a2d:	c3                   	ret    

00800a2e <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a2e:	55                   	push   %ebp
  800a2f:	89 e5                	mov    %esp,%ebp
  800a31:	53                   	push   %ebx
  800a32:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a35:	53                   	push   %ebx
  800a36:	e8 9a ff ff ff       	call   8009d5 <strlen>
  800a3b:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a3e:	ff 75 0c             	pushl  0xc(%ebp)
  800a41:	01 d8                	add    %ebx,%eax
  800a43:	50                   	push   %eax
  800a44:	e8 c5 ff ff ff       	call   800a0e <strcpy>
	return dst;
}
  800a49:	89 d8                	mov    %ebx,%eax
  800a4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a4e:	c9                   	leave  
  800a4f:	c3                   	ret    

00800a50 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	56                   	push   %esi
  800a54:	53                   	push   %ebx
  800a55:	8b 75 08             	mov    0x8(%ebp),%esi
  800a58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a5b:	89 f3                	mov    %esi,%ebx
  800a5d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a60:	89 f2                	mov    %esi,%edx
  800a62:	eb 0f                	jmp    800a73 <strncpy+0x23>
		*dst++ = *src;
  800a64:	83 c2 01             	add    $0x1,%edx
  800a67:	0f b6 01             	movzbl (%ecx),%eax
  800a6a:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a6d:	80 39 01             	cmpb   $0x1,(%ecx)
  800a70:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a73:	39 da                	cmp    %ebx,%edx
  800a75:	75 ed                	jne    800a64 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a77:	89 f0                	mov    %esi,%eax
  800a79:	5b                   	pop    %ebx
  800a7a:	5e                   	pop    %esi
  800a7b:	5d                   	pop    %ebp
  800a7c:	c3                   	ret    

00800a7d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a7d:	55                   	push   %ebp
  800a7e:	89 e5                	mov    %esp,%ebp
  800a80:	56                   	push   %esi
  800a81:	53                   	push   %ebx
  800a82:	8b 75 08             	mov    0x8(%ebp),%esi
  800a85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a88:	8b 55 10             	mov    0x10(%ebp),%edx
  800a8b:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a8d:	85 d2                	test   %edx,%edx
  800a8f:	74 21                	je     800ab2 <strlcpy+0x35>
  800a91:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a95:	89 f2                	mov    %esi,%edx
  800a97:	eb 09                	jmp    800aa2 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a99:	83 c2 01             	add    $0x1,%edx
  800a9c:	83 c1 01             	add    $0x1,%ecx
  800a9f:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800aa2:	39 c2                	cmp    %eax,%edx
  800aa4:	74 09                	je     800aaf <strlcpy+0x32>
  800aa6:	0f b6 19             	movzbl (%ecx),%ebx
  800aa9:	84 db                	test   %bl,%bl
  800aab:	75 ec                	jne    800a99 <strlcpy+0x1c>
  800aad:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  800aaf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ab2:	29 f0                	sub    %esi,%eax
}
  800ab4:	5b                   	pop    %ebx
  800ab5:	5e                   	pop    %esi
  800ab6:	5d                   	pop    %ebp
  800ab7:	c3                   	ret    

00800ab8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ab8:	55                   	push   %ebp
  800ab9:	89 e5                	mov    %esp,%ebp
  800abb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800abe:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ac1:	eb 06                	jmp    800ac9 <strcmp+0x11>
		p++, q++;
  800ac3:	83 c1 01             	add    $0x1,%ecx
  800ac6:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ac9:	0f b6 01             	movzbl (%ecx),%eax
  800acc:	84 c0                	test   %al,%al
  800ace:	74 04                	je     800ad4 <strcmp+0x1c>
  800ad0:	3a 02                	cmp    (%edx),%al
  800ad2:	74 ef                	je     800ac3 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ad4:	0f b6 c0             	movzbl %al,%eax
  800ad7:	0f b6 12             	movzbl (%edx),%edx
  800ada:	29 d0                	sub    %edx,%eax
}
  800adc:	5d                   	pop    %ebp
  800add:	c3                   	ret    

00800ade <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ade:	55                   	push   %ebp
  800adf:	89 e5                	mov    %esp,%ebp
  800ae1:	53                   	push   %ebx
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae8:	89 c3                	mov    %eax,%ebx
  800aea:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800aed:	eb 06                	jmp    800af5 <strncmp+0x17>
		n--, p++, q++;
  800aef:	83 c0 01             	add    $0x1,%eax
  800af2:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800af5:	39 d8                	cmp    %ebx,%eax
  800af7:	74 15                	je     800b0e <strncmp+0x30>
  800af9:	0f b6 08             	movzbl (%eax),%ecx
  800afc:	84 c9                	test   %cl,%cl
  800afe:	74 04                	je     800b04 <strncmp+0x26>
  800b00:	3a 0a                	cmp    (%edx),%cl
  800b02:	74 eb                	je     800aef <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b04:	0f b6 00             	movzbl (%eax),%eax
  800b07:	0f b6 12             	movzbl (%edx),%edx
  800b0a:	29 d0                	sub    %edx,%eax
  800b0c:	eb 05                	jmp    800b13 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800b0e:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800b13:	5b                   	pop    %ebx
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b20:	eb 07                	jmp    800b29 <strchr+0x13>
		if (*s == c)
  800b22:	38 ca                	cmp    %cl,%dl
  800b24:	74 0f                	je     800b35 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b26:	83 c0 01             	add    $0x1,%eax
  800b29:	0f b6 10             	movzbl (%eax),%edx
  800b2c:	84 d2                	test   %dl,%dl
  800b2e:	75 f2                	jne    800b22 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800b30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b35:	5d                   	pop    %ebp
  800b36:	c3                   	ret    

00800b37 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b41:	eb 03                	jmp    800b46 <strfind+0xf>
  800b43:	83 c0 01             	add    $0x1,%eax
  800b46:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b49:	38 ca                	cmp    %cl,%dl
  800b4b:	74 04                	je     800b51 <strfind+0x1a>
  800b4d:	84 d2                	test   %dl,%dl
  800b4f:	75 f2                	jne    800b43 <strfind+0xc>
			break;
	return (char *) s;
}
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	57                   	push   %edi
  800b57:	56                   	push   %esi
  800b58:	53                   	push   %ebx
  800b59:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800b5f:	85 c9                	test   %ecx,%ecx
  800b61:	74 37                	je     800b9a <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b63:	f6 c2 03             	test   $0x3,%dl
  800b66:	75 2a                	jne    800b92 <memset+0x3f>
  800b68:	f6 c1 03             	test   $0x3,%cl
  800b6b:	75 25                	jne    800b92 <memset+0x3f>
		c &= 0xFF;
  800b6d:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b71:	89 df                	mov    %ebx,%edi
  800b73:	c1 e7 08             	shl    $0x8,%edi
  800b76:	89 de                	mov    %ebx,%esi
  800b78:	c1 e6 18             	shl    $0x18,%esi
  800b7b:	89 d8                	mov    %ebx,%eax
  800b7d:	c1 e0 10             	shl    $0x10,%eax
  800b80:	09 f0                	or     %esi,%eax
  800b82:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800b84:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b87:	89 f8                	mov    %edi,%eax
  800b89:	09 d8                	or     %ebx,%eax
  800b8b:	89 d7                	mov    %edx,%edi
  800b8d:	fc                   	cld    
  800b8e:	f3 ab                	rep stos %eax,%es:(%edi)
  800b90:	eb 08                	jmp    800b9a <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b92:	89 d7                	mov    %edx,%edi
  800b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b97:	fc                   	cld    
  800b98:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800b9a:	89 d0                	mov    %edx,%eax
  800b9c:	5b                   	pop    %ebx
  800b9d:	5e                   	pop    %esi
  800b9e:	5f                   	pop    %edi
  800b9f:	5d                   	pop    %ebp
  800ba0:	c3                   	ret    

00800ba1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
  800ba4:	57                   	push   %edi
  800ba5:	56                   	push   %esi
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bac:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800baf:	39 c6                	cmp    %eax,%esi
  800bb1:	73 35                	jae    800be8 <memmove+0x47>
  800bb3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bb6:	39 d0                	cmp    %edx,%eax
  800bb8:	73 2e                	jae    800be8 <memmove+0x47>
		s += n;
		d += n;
  800bba:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bbd:	89 d6                	mov    %edx,%esi
  800bbf:	09 fe                	or     %edi,%esi
  800bc1:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bc7:	75 13                	jne    800bdc <memmove+0x3b>
  800bc9:	f6 c1 03             	test   $0x3,%cl
  800bcc:	75 0e                	jne    800bdc <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  800bce:	83 ef 04             	sub    $0x4,%edi
  800bd1:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bd4:	c1 e9 02             	shr    $0x2,%ecx
  800bd7:	fd                   	std    
  800bd8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bda:	eb 09                	jmp    800be5 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800bdc:	83 ef 01             	sub    $0x1,%edi
  800bdf:	8d 72 ff             	lea    -0x1(%edx),%esi
  800be2:	fd                   	std    
  800be3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800be5:	fc                   	cld    
  800be6:	eb 1d                	jmp    800c05 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be8:	89 f2                	mov    %esi,%edx
  800bea:	09 c2                	or     %eax,%edx
  800bec:	f6 c2 03             	test   $0x3,%dl
  800bef:	75 0f                	jne    800c00 <memmove+0x5f>
  800bf1:	f6 c1 03             	test   $0x3,%cl
  800bf4:	75 0a                	jne    800c00 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  800bf6:	c1 e9 02             	shr    $0x2,%ecx
  800bf9:	89 c7                	mov    %eax,%edi
  800bfb:	fc                   	cld    
  800bfc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bfe:	eb 05                	jmp    800c05 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c00:	89 c7                	mov    %eax,%edi
  800c02:	fc                   	cld    
  800c03:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c05:	5e                   	pop    %esi
  800c06:	5f                   	pop    %edi
  800c07:	5d                   	pop    %ebp
  800c08:	c3                   	ret    

00800c09 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c0c:	ff 75 10             	pushl  0x10(%ebp)
  800c0f:	ff 75 0c             	pushl  0xc(%ebp)
  800c12:	ff 75 08             	pushl  0x8(%ebp)
  800c15:	e8 87 ff ff ff       	call   800ba1 <memmove>
}
  800c1a:	c9                   	leave  
  800c1b:	c3                   	ret    

00800c1c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	56                   	push   %esi
  800c20:	53                   	push   %ebx
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c27:	89 c6                	mov    %eax,%esi
  800c29:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c2c:	eb 1a                	jmp    800c48 <memcmp+0x2c>
		if (*s1 != *s2)
  800c2e:	0f b6 08             	movzbl (%eax),%ecx
  800c31:	0f b6 1a             	movzbl (%edx),%ebx
  800c34:	38 d9                	cmp    %bl,%cl
  800c36:	74 0a                	je     800c42 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800c38:	0f b6 c1             	movzbl %cl,%eax
  800c3b:	0f b6 db             	movzbl %bl,%ebx
  800c3e:	29 d8                	sub    %ebx,%eax
  800c40:	eb 0f                	jmp    800c51 <memcmp+0x35>
		s1++, s2++;
  800c42:	83 c0 01             	add    $0x1,%eax
  800c45:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c48:	39 f0                	cmp    %esi,%eax
  800c4a:	75 e2                	jne    800c2e <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c51:	5b                   	pop    %ebx
  800c52:	5e                   	pop    %esi
  800c53:	5d                   	pop    %ebp
  800c54:	c3                   	ret    

00800c55 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	53                   	push   %ebx
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800c5c:	89 c1                	mov    %eax,%ecx
  800c5e:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  800c61:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c65:	eb 0a                	jmp    800c71 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c67:	0f b6 10             	movzbl (%eax),%edx
  800c6a:	39 da                	cmp    %ebx,%edx
  800c6c:	74 07                	je     800c75 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c6e:	83 c0 01             	add    $0x1,%eax
  800c71:	39 c8                	cmp    %ecx,%eax
  800c73:	72 f2                	jb     800c67 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c75:	5b                   	pop    %ebx
  800c76:	5d                   	pop    %ebp
  800c77:	c3                   	ret    

00800c78 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	57                   	push   %edi
  800c7c:	56                   	push   %esi
  800c7d:	53                   	push   %ebx
  800c7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c81:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c84:	eb 03                	jmp    800c89 <strtol+0x11>
		s++;
  800c86:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c89:	0f b6 01             	movzbl (%ecx),%eax
  800c8c:	3c 20                	cmp    $0x20,%al
  800c8e:	74 f6                	je     800c86 <strtol+0xe>
  800c90:	3c 09                	cmp    $0x9,%al
  800c92:	74 f2                	je     800c86 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c94:	3c 2b                	cmp    $0x2b,%al
  800c96:	75 0a                	jne    800ca2 <strtol+0x2a>
		s++;
  800c98:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c9b:	bf 00 00 00 00       	mov    $0x0,%edi
  800ca0:	eb 11                	jmp    800cb3 <strtol+0x3b>
  800ca2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800ca7:	3c 2d                	cmp    $0x2d,%al
  800ca9:	75 08                	jne    800cb3 <strtol+0x3b>
		s++, neg = 1;
  800cab:	83 c1 01             	add    $0x1,%ecx
  800cae:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cb3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cb9:	75 15                	jne    800cd0 <strtol+0x58>
  800cbb:	80 39 30             	cmpb   $0x30,(%ecx)
  800cbe:	75 10                	jne    800cd0 <strtol+0x58>
  800cc0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cc4:	75 7c                	jne    800d42 <strtol+0xca>
		s += 2, base = 16;
  800cc6:	83 c1 02             	add    $0x2,%ecx
  800cc9:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cce:	eb 16                	jmp    800ce6 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800cd0:	85 db                	test   %ebx,%ebx
  800cd2:	75 12                	jne    800ce6 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cd4:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cd9:	80 39 30             	cmpb   $0x30,(%ecx)
  800cdc:	75 08                	jne    800ce6 <strtol+0x6e>
		s++, base = 8;
  800cde:	83 c1 01             	add    $0x1,%ecx
  800ce1:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ceb:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cee:	0f b6 11             	movzbl (%ecx),%edx
  800cf1:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cf4:	89 f3                	mov    %esi,%ebx
  800cf6:	80 fb 09             	cmp    $0x9,%bl
  800cf9:	77 08                	ja     800d03 <strtol+0x8b>
			dig = *s - '0';
  800cfb:	0f be d2             	movsbl %dl,%edx
  800cfe:	83 ea 30             	sub    $0x30,%edx
  800d01:	eb 22                	jmp    800d25 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800d03:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d06:	89 f3                	mov    %esi,%ebx
  800d08:	80 fb 19             	cmp    $0x19,%bl
  800d0b:	77 08                	ja     800d15 <strtol+0x9d>
			dig = *s - 'a' + 10;
  800d0d:	0f be d2             	movsbl %dl,%edx
  800d10:	83 ea 57             	sub    $0x57,%edx
  800d13:	eb 10                	jmp    800d25 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800d15:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d18:	89 f3                	mov    %esi,%ebx
  800d1a:	80 fb 19             	cmp    $0x19,%bl
  800d1d:	77 16                	ja     800d35 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800d1f:	0f be d2             	movsbl %dl,%edx
  800d22:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800d25:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d28:	7d 0b                	jge    800d35 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800d2a:	83 c1 01             	add    $0x1,%ecx
  800d2d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d31:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800d33:	eb b9                	jmp    800cee <strtol+0x76>

	if (endptr)
  800d35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d39:	74 0d                	je     800d48 <strtol+0xd0>
		*endptr = (char *) s;
  800d3b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d3e:	89 0e                	mov    %ecx,(%esi)
  800d40:	eb 06                	jmp    800d48 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d42:	85 db                	test   %ebx,%ebx
  800d44:	74 98                	je     800cde <strtol+0x66>
  800d46:	eb 9e                	jmp    800ce6 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800d48:	89 c2                	mov    %eax,%edx
  800d4a:	f7 da                	neg    %edx
  800d4c:	85 ff                	test   %edi,%edi
  800d4e:	0f 45 c2             	cmovne %edx,%eax
}
  800d51:	5b                   	pop    %ebx
  800d52:	5e                   	pop    %esi
  800d53:	5f                   	pop    %edi
  800d54:	5d                   	pop    %ebp
  800d55:	c3                   	ret    

00800d56 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	57                   	push   %edi
  800d5a:	56                   	push   %esi
  800d5b:	53                   	push   %ebx
  800d5c:	83 ec 1c             	sub    $0x1c,%esp
  800d5f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d62:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800d65:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d6a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d6d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800d70:	8b 75 14             	mov    0x14(%ebp),%esi
  800d73:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d75:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d79:	74 1d                	je     800d98 <syscall+0x42>
  800d7b:	85 c0                	test   %eax,%eax
  800d7d:	7e 19                	jle    800d98 <syscall+0x42>
  800d7f:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800d82:	83 ec 0c             	sub    $0xc,%esp
  800d85:	50                   	push   %eax
  800d86:	52                   	push   %edx
  800d87:	68 8f 23 80 00       	push   $0x80238f
  800d8c:	6a 23                	push   $0x23
  800d8e:	68 ac 23 80 00       	push   $0x8023ac
  800d93:	e8 38 f5 ff ff       	call   8002d0 <_panic>

	return ret;
}
  800d98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9b:	5b                   	pop    %ebx
  800d9c:	5e                   	pop    %esi
  800d9d:	5f                   	pop    %edi
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    

00800da0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800da6:	6a 00                	push   $0x0
  800da8:	6a 00                	push   $0x0
  800daa:	6a 00                	push   $0x0
  800dac:	ff 75 0c             	pushl  0xc(%ebp)
  800daf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800db2:	ba 00 00 00 00       	mov    $0x0,%edx
  800db7:	b8 00 00 00 00       	mov    $0x0,%eax
  800dbc:	e8 95 ff ff ff       	call   800d56 <syscall>
}
  800dc1:	83 c4 10             	add    $0x10,%esp
  800dc4:	c9                   	leave  
  800dc5:	c3                   	ret    

00800dc6 <sys_cgetc>:

int
sys_cgetc(void)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800dcc:	6a 00                	push   $0x0
  800dce:	6a 00                	push   $0x0
  800dd0:	6a 00                	push   $0x0
  800dd2:	6a 00                	push   $0x0
  800dd4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dd9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dde:	b8 01 00 00 00       	mov    $0x1,%eax
  800de3:	e8 6e ff ff ff       	call   800d56 <syscall>
}
  800de8:	c9                   	leave  
  800de9:	c3                   	ret    

00800dea <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800df0:	6a 00                	push   $0x0
  800df2:	6a 00                	push   $0x0
  800df4:	6a 00                	push   $0x0
  800df6:	6a 00                	push   $0x0
  800df8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dfb:	ba 01 00 00 00       	mov    $0x1,%edx
  800e00:	b8 03 00 00 00       	mov    $0x3,%eax
  800e05:	e8 4c ff ff ff       	call   800d56 <syscall>
}
  800e0a:	c9                   	leave  
  800e0b:	c3                   	ret    

00800e0c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800e12:	6a 00                	push   $0x0
  800e14:	6a 00                	push   $0x0
  800e16:	6a 00                	push   $0x0
  800e18:	6a 00                	push   $0x0
  800e1a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800e24:	b8 02 00 00 00       	mov    $0x2,%eax
  800e29:	e8 28 ff ff ff       	call   800d56 <syscall>
}
  800e2e:	c9                   	leave  
  800e2f:	c3                   	ret    

00800e30 <sys_yield>:

void
sys_yield(void)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800e36:	6a 00                	push   $0x0
  800e38:	6a 00                	push   $0x0
  800e3a:	6a 00                	push   $0x0
  800e3c:	6a 00                	push   $0x0
  800e3e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e43:	ba 00 00 00 00       	mov    $0x0,%edx
  800e48:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e4d:	e8 04 ff ff ff       	call   800d56 <syscall>
}
  800e52:	83 c4 10             	add    $0x10,%esp
  800e55:	c9                   	leave  
  800e56:	c3                   	ret    

00800e57 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800e5d:	6a 00                	push   $0x0
  800e5f:	6a 00                	push   $0x0
  800e61:	ff 75 10             	pushl  0x10(%ebp)
  800e64:	ff 75 0c             	pushl  0xc(%ebp)
  800e67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e6a:	ba 01 00 00 00       	mov    $0x1,%edx
  800e6f:	b8 04 00 00 00       	mov    $0x4,%eax
  800e74:	e8 dd fe ff ff       	call   800d56 <syscall>
}
  800e79:	c9                   	leave  
  800e7a:	c3                   	ret    

00800e7b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
  800e7e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800e81:	ff 75 18             	pushl  0x18(%ebp)
  800e84:	ff 75 14             	pushl  0x14(%ebp)
  800e87:	ff 75 10             	pushl  0x10(%ebp)
  800e8a:	ff 75 0c             	pushl  0xc(%ebp)
  800e8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e90:	ba 01 00 00 00       	mov    $0x1,%edx
  800e95:	b8 05 00 00 00       	mov    $0x5,%eax
  800e9a:	e8 b7 fe ff ff       	call   800d56 <syscall>
}
  800e9f:	c9                   	leave  
  800ea0:	c3                   	ret    

00800ea1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800ea7:	6a 00                	push   $0x0
  800ea9:	6a 00                	push   $0x0
  800eab:	6a 00                	push   $0x0
  800ead:	ff 75 0c             	pushl  0xc(%ebp)
  800eb0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eb3:	ba 01 00 00 00       	mov    $0x1,%edx
  800eb8:	b8 06 00 00 00       	mov    $0x6,%eax
  800ebd:	e8 94 fe ff ff       	call   800d56 <syscall>
}
  800ec2:	c9                   	leave  
  800ec3:	c3                   	ret    

00800ec4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800eca:	6a 00                	push   $0x0
  800ecc:	6a 00                	push   $0x0
  800ece:	6a 00                	push   $0x0
  800ed0:	ff 75 0c             	pushl  0xc(%ebp)
  800ed3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ed6:	ba 01 00 00 00       	mov    $0x1,%edx
  800edb:	b8 08 00 00 00       	mov    $0x8,%eax
  800ee0:	e8 71 fe ff ff       	call   800d56 <syscall>
}
  800ee5:	c9                   	leave  
  800ee6:	c3                   	ret    

00800ee7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ee7:	55                   	push   %ebp
  800ee8:	89 e5                	mov    %esp,%ebp
  800eea:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800eed:	6a 00                	push   $0x0
  800eef:	6a 00                	push   $0x0
  800ef1:	6a 00                	push   $0x0
  800ef3:	ff 75 0c             	pushl  0xc(%ebp)
  800ef6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ef9:	ba 01 00 00 00       	mov    $0x1,%edx
  800efe:	b8 09 00 00 00       	mov    $0x9,%eax
  800f03:	e8 4e fe ff ff       	call   800d56 <syscall>
}
  800f08:	c9                   	leave  
  800f09:	c3                   	ret    

00800f0a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800f10:	6a 00                	push   $0x0
  800f12:	6a 00                	push   $0x0
  800f14:	6a 00                	push   $0x0
  800f16:	ff 75 0c             	pushl  0xc(%ebp)
  800f19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f1c:	ba 01 00 00 00       	mov    $0x1,%edx
  800f21:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f26:	e8 2b fe ff ff       	call   800d56 <syscall>
}
  800f2b:	c9                   	leave  
  800f2c:	c3                   	ret    

00800f2d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800f33:	6a 00                	push   $0x0
  800f35:	ff 75 14             	pushl  0x14(%ebp)
  800f38:	ff 75 10             	pushl  0x10(%ebp)
  800f3b:	ff 75 0c             	pushl  0xc(%ebp)
  800f3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f41:	ba 00 00 00 00       	mov    $0x0,%edx
  800f46:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f4b:	e8 06 fe ff ff       	call   800d56 <syscall>
}
  800f50:	c9                   	leave  
  800f51:	c3                   	ret    

00800f52 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f52:	55                   	push   %ebp
  800f53:	89 e5                	mov    %esp,%ebp
  800f55:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800f58:	6a 00                	push   $0x0
  800f5a:	6a 00                	push   $0x0
  800f5c:	6a 00                	push   $0x0
  800f5e:	6a 00                	push   $0x0
  800f60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f63:	ba 01 00 00 00       	mov    $0x1,%edx
  800f68:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f6d:	e8 e4 fd ff ff       	call   800d56 <syscall>
}
  800f72:	c9                   	leave  
  800f73:	c3                   	ret    

00800f74 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	05 00 00 00 30       	add    $0x30000000,%eax
  800f7f:	c1 e8 0c             	shr    $0xc,%eax
}
  800f82:	5d                   	pop    %ebp
  800f83:	c3                   	ret    

00800f84 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  800f87:	ff 75 08             	pushl  0x8(%ebp)
  800f8a:	e8 e5 ff ff ff       	call   800f74 <fd2num>
  800f8f:	83 c4 04             	add    $0x4,%esp
  800f92:	c1 e0 0c             	shl    $0xc,%eax
  800f95:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fa2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fa7:	89 c2                	mov    %eax,%edx
  800fa9:	c1 ea 16             	shr    $0x16,%edx
  800fac:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fb3:	f6 c2 01             	test   $0x1,%dl
  800fb6:	74 11                	je     800fc9 <fd_alloc+0x2d>
  800fb8:	89 c2                	mov    %eax,%edx
  800fba:	c1 ea 0c             	shr    $0xc,%edx
  800fbd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fc4:	f6 c2 01             	test   $0x1,%dl
  800fc7:	75 09                	jne    800fd2 <fd_alloc+0x36>
			*fd_store = fd;
  800fc9:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fcb:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd0:	eb 17                	jmp    800fe9 <fd_alloc+0x4d>
  800fd2:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800fd7:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800fdc:	75 c9                	jne    800fa7 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800fde:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800fe4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800fe9:	5d                   	pop    %ebp
  800fea:	c3                   	ret    

00800feb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800ff1:	83 f8 1f             	cmp    $0x1f,%eax
  800ff4:	77 36                	ja     80102c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800ff6:	c1 e0 0c             	shl    $0xc,%eax
  800ff9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ffe:	89 c2                	mov    %eax,%edx
  801000:	c1 ea 16             	shr    $0x16,%edx
  801003:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80100a:	f6 c2 01             	test   $0x1,%dl
  80100d:	74 24                	je     801033 <fd_lookup+0x48>
  80100f:	89 c2                	mov    %eax,%edx
  801011:	c1 ea 0c             	shr    $0xc,%edx
  801014:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80101b:	f6 c2 01             	test   $0x1,%dl
  80101e:	74 1a                	je     80103a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801020:	8b 55 0c             	mov    0xc(%ebp),%edx
  801023:	89 02                	mov    %eax,(%edx)
	return 0;
  801025:	b8 00 00 00 00       	mov    $0x0,%eax
  80102a:	eb 13                	jmp    80103f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80102c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801031:	eb 0c                	jmp    80103f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801033:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801038:	eb 05                	jmp    80103f <fd_lookup+0x54>
  80103a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80103f:	5d                   	pop    %ebp
  801040:	c3                   	ret    

00801041 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	83 ec 08             	sub    $0x8,%esp
  801047:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80104a:	ba 3c 24 80 00       	mov    $0x80243c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80104f:	eb 13                	jmp    801064 <dev_lookup+0x23>
  801051:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  801054:	39 08                	cmp    %ecx,(%eax)
  801056:	75 0c                	jne    801064 <dev_lookup+0x23>
			*dev = devtab[i];
  801058:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80105d:	b8 00 00 00 00       	mov    $0x0,%eax
  801062:	eb 2e                	jmp    801092 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801064:	8b 02                	mov    (%edx),%eax
  801066:	85 c0                	test   %eax,%eax
  801068:	75 e7                	jne    801051 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80106a:	a1 04 44 80 00       	mov    0x804404,%eax
  80106f:	8b 40 48             	mov    0x48(%eax),%eax
  801072:	83 ec 04             	sub    $0x4,%esp
  801075:	51                   	push   %ecx
  801076:	50                   	push   %eax
  801077:	68 bc 23 80 00       	push   $0x8023bc
  80107c:	e8 28 f3 ff ff       	call   8003a9 <cprintf>
	*dev = 0;
  801081:	8b 45 0c             	mov    0xc(%ebp),%eax
  801084:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80108a:	83 c4 10             	add    $0x10,%esp
  80108d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801092:	c9                   	leave  
  801093:	c3                   	ret    

00801094 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	56                   	push   %esi
  801098:	53                   	push   %ebx
  801099:	83 ec 10             	sub    $0x10,%esp
  80109c:	8b 75 08             	mov    0x8(%ebp),%esi
  80109f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010a2:	56                   	push   %esi
  8010a3:	e8 cc fe ff ff       	call   800f74 <fd2num>
  8010a8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8010ab:	89 14 24             	mov    %edx,(%esp)
  8010ae:	50                   	push   %eax
  8010af:	e8 37 ff ff ff       	call   800feb <fd_lookup>
  8010b4:	83 c4 08             	add    $0x8,%esp
  8010b7:	85 c0                	test   %eax,%eax
  8010b9:	78 05                	js     8010c0 <fd_close+0x2c>
	    || fd != fd2)
  8010bb:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8010be:	74 0c                	je     8010cc <fd_close+0x38>
		return (must_exist ? r : 0);
  8010c0:	84 db                	test   %bl,%bl
  8010c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c7:	0f 44 c2             	cmove  %edx,%eax
  8010ca:	eb 41                	jmp    80110d <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010cc:	83 ec 08             	sub    $0x8,%esp
  8010cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010d2:	50                   	push   %eax
  8010d3:	ff 36                	pushl  (%esi)
  8010d5:	e8 67 ff ff ff       	call   801041 <dev_lookup>
  8010da:	89 c3                	mov    %eax,%ebx
  8010dc:	83 c4 10             	add    $0x10,%esp
  8010df:	85 c0                	test   %eax,%eax
  8010e1:	78 1a                	js     8010fd <fd_close+0x69>
		if (dev->dev_close)
  8010e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010e6:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8010e9:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8010ee:	85 c0                	test   %eax,%eax
  8010f0:	74 0b                	je     8010fd <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  8010f2:	83 ec 0c             	sub    $0xc,%esp
  8010f5:	56                   	push   %esi
  8010f6:	ff d0                	call   *%eax
  8010f8:	89 c3                	mov    %eax,%ebx
  8010fa:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8010fd:	83 ec 08             	sub    $0x8,%esp
  801100:	56                   	push   %esi
  801101:	6a 00                	push   $0x0
  801103:	e8 99 fd ff ff       	call   800ea1 <sys_page_unmap>
	return r;
  801108:	83 c4 10             	add    $0x10,%esp
  80110b:	89 d8                	mov    %ebx,%eax
}
  80110d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801110:	5b                   	pop    %ebx
  801111:	5e                   	pop    %esi
  801112:	5d                   	pop    %ebp
  801113:	c3                   	ret    

00801114 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80111a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80111d:	50                   	push   %eax
  80111e:	ff 75 08             	pushl  0x8(%ebp)
  801121:	e8 c5 fe ff ff       	call   800feb <fd_lookup>
  801126:	83 c4 08             	add    $0x8,%esp
  801129:	85 c0                	test   %eax,%eax
  80112b:	78 10                	js     80113d <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80112d:	83 ec 08             	sub    $0x8,%esp
  801130:	6a 01                	push   $0x1
  801132:	ff 75 f4             	pushl  -0xc(%ebp)
  801135:	e8 5a ff ff ff       	call   801094 <fd_close>
  80113a:	83 c4 10             	add    $0x10,%esp
}
  80113d:	c9                   	leave  
  80113e:	c3                   	ret    

0080113f <close_all>:

void
close_all(void)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	53                   	push   %ebx
  801143:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801146:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80114b:	83 ec 0c             	sub    $0xc,%esp
  80114e:	53                   	push   %ebx
  80114f:	e8 c0 ff ff ff       	call   801114 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801154:	83 c3 01             	add    $0x1,%ebx
  801157:	83 c4 10             	add    $0x10,%esp
  80115a:	83 fb 20             	cmp    $0x20,%ebx
  80115d:	75 ec                	jne    80114b <close_all+0xc>
		close(i);
}
  80115f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801162:	c9                   	leave  
  801163:	c3                   	ret    

00801164 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801164:	55                   	push   %ebp
  801165:	89 e5                	mov    %esp,%ebp
  801167:	57                   	push   %edi
  801168:	56                   	push   %esi
  801169:	53                   	push   %ebx
  80116a:	83 ec 2c             	sub    $0x2c,%esp
  80116d:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801170:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801173:	50                   	push   %eax
  801174:	ff 75 08             	pushl  0x8(%ebp)
  801177:	e8 6f fe ff ff       	call   800feb <fd_lookup>
  80117c:	83 c4 08             	add    $0x8,%esp
  80117f:	85 c0                	test   %eax,%eax
  801181:	0f 88 c1 00 00 00    	js     801248 <dup+0xe4>
		return r;
	close(newfdnum);
  801187:	83 ec 0c             	sub    $0xc,%esp
  80118a:	56                   	push   %esi
  80118b:	e8 84 ff ff ff       	call   801114 <close>

	newfd = INDEX2FD(newfdnum);
  801190:	89 f3                	mov    %esi,%ebx
  801192:	c1 e3 0c             	shl    $0xc,%ebx
  801195:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  80119b:	83 c4 04             	add    $0x4,%esp
  80119e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011a1:	e8 de fd ff ff       	call   800f84 <fd2data>
  8011a6:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  8011a8:	89 1c 24             	mov    %ebx,(%esp)
  8011ab:	e8 d4 fd ff ff       	call   800f84 <fd2data>
  8011b0:	83 c4 10             	add    $0x10,%esp
  8011b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011b6:	89 f8                	mov    %edi,%eax
  8011b8:	c1 e8 16             	shr    $0x16,%eax
  8011bb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011c2:	a8 01                	test   $0x1,%al
  8011c4:	74 37                	je     8011fd <dup+0x99>
  8011c6:	89 f8                	mov    %edi,%eax
  8011c8:	c1 e8 0c             	shr    $0xc,%eax
  8011cb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011d2:	f6 c2 01             	test   $0x1,%dl
  8011d5:	74 26                	je     8011fd <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011d7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011de:	83 ec 0c             	sub    $0xc,%esp
  8011e1:	25 07 0e 00 00       	and    $0xe07,%eax
  8011e6:	50                   	push   %eax
  8011e7:	ff 75 d4             	pushl  -0x2c(%ebp)
  8011ea:	6a 00                	push   $0x0
  8011ec:	57                   	push   %edi
  8011ed:	6a 00                	push   $0x0
  8011ef:	e8 87 fc ff ff       	call   800e7b <sys_page_map>
  8011f4:	89 c7                	mov    %eax,%edi
  8011f6:	83 c4 20             	add    $0x20,%esp
  8011f9:	85 c0                	test   %eax,%eax
  8011fb:	78 2e                	js     80122b <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801200:	89 d0                	mov    %edx,%eax
  801202:	c1 e8 0c             	shr    $0xc,%eax
  801205:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80120c:	83 ec 0c             	sub    $0xc,%esp
  80120f:	25 07 0e 00 00       	and    $0xe07,%eax
  801214:	50                   	push   %eax
  801215:	53                   	push   %ebx
  801216:	6a 00                	push   $0x0
  801218:	52                   	push   %edx
  801219:	6a 00                	push   $0x0
  80121b:	e8 5b fc ff ff       	call   800e7b <sys_page_map>
  801220:	89 c7                	mov    %eax,%edi
  801222:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  801225:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801227:	85 ff                	test   %edi,%edi
  801229:	79 1d                	jns    801248 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80122b:	83 ec 08             	sub    $0x8,%esp
  80122e:	53                   	push   %ebx
  80122f:	6a 00                	push   $0x0
  801231:	e8 6b fc ff ff       	call   800ea1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801236:	83 c4 08             	add    $0x8,%esp
  801239:	ff 75 d4             	pushl  -0x2c(%ebp)
  80123c:	6a 00                	push   $0x0
  80123e:	e8 5e fc ff ff       	call   800ea1 <sys_page_unmap>
	return r;
  801243:	83 c4 10             	add    $0x10,%esp
  801246:	89 f8                	mov    %edi,%eax
}
  801248:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80124b:	5b                   	pop    %ebx
  80124c:	5e                   	pop    %esi
  80124d:	5f                   	pop    %edi
  80124e:	5d                   	pop    %ebp
  80124f:	c3                   	ret    

00801250 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	53                   	push   %ebx
  801254:	83 ec 14             	sub    $0x14,%esp
  801257:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80125a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80125d:	50                   	push   %eax
  80125e:	53                   	push   %ebx
  80125f:	e8 87 fd ff ff       	call   800feb <fd_lookup>
  801264:	83 c4 08             	add    $0x8,%esp
  801267:	89 c2                	mov    %eax,%edx
  801269:	85 c0                	test   %eax,%eax
  80126b:	78 6d                	js     8012da <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80126d:	83 ec 08             	sub    $0x8,%esp
  801270:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801273:	50                   	push   %eax
  801274:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801277:	ff 30                	pushl  (%eax)
  801279:	e8 c3 fd ff ff       	call   801041 <dev_lookup>
  80127e:	83 c4 10             	add    $0x10,%esp
  801281:	85 c0                	test   %eax,%eax
  801283:	78 4c                	js     8012d1 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801285:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801288:	8b 42 08             	mov    0x8(%edx),%eax
  80128b:	83 e0 03             	and    $0x3,%eax
  80128e:	83 f8 01             	cmp    $0x1,%eax
  801291:	75 21                	jne    8012b4 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801293:	a1 04 44 80 00       	mov    0x804404,%eax
  801298:	8b 40 48             	mov    0x48(%eax),%eax
  80129b:	83 ec 04             	sub    $0x4,%esp
  80129e:	53                   	push   %ebx
  80129f:	50                   	push   %eax
  8012a0:	68 00 24 80 00       	push   $0x802400
  8012a5:	e8 ff f0 ff ff       	call   8003a9 <cprintf>
		return -E_INVAL;
  8012aa:	83 c4 10             	add    $0x10,%esp
  8012ad:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8012b2:	eb 26                	jmp    8012da <read+0x8a>
	}
	if (!dev->dev_read)
  8012b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b7:	8b 40 08             	mov    0x8(%eax),%eax
  8012ba:	85 c0                	test   %eax,%eax
  8012bc:	74 17                	je     8012d5 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012be:	83 ec 04             	sub    $0x4,%esp
  8012c1:	ff 75 10             	pushl  0x10(%ebp)
  8012c4:	ff 75 0c             	pushl  0xc(%ebp)
  8012c7:	52                   	push   %edx
  8012c8:	ff d0                	call   *%eax
  8012ca:	89 c2                	mov    %eax,%edx
  8012cc:	83 c4 10             	add    $0x10,%esp
  8012cf:	eb 09                	jmp    8012da <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012d1:	89 c2                	mov    %eax,%edx
  8012d3:	eb 05                	jmp    8012da <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8012d5:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  8012da:	89 d0                	mov    %edx,%eax
  8012dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012df:	c9                   	leave  
  8012e0:	c3                   	ret    

008012e1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012e1:	55                   	push   %ebp
  8012e2:	89 e5                	mov    %esp,%ebp
  8012e4:	57                   	push   %edi
  8012e5:	56                   	push   %esi
  8012e6:	53                   	push   %ebx
  8012e7:	83 ec 0c             	sub    $0xc,%esp
  8012ea:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012ed:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012f5:	eb 21                	jmp    801318 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012f7:	83 ec 04             	sub    $0x4,%esp
  8012fa:	89 f0                	mov    %esi,%eax
  8012fc:	29 d8                	sub    %ebx,%eax
  8012fe:	50                   	push   %eax
  8012ff:	89 d8                	mov    %ebx,%eax
  801301:	03 45 0c             	add    0xc(%ebp),%eax
  801304:	50                   	push   %eax
  801305:	57                   	push   %edi
  801306:	e8 45 ff ff ff       	call   801250 <read>
		if (m < 0)
  80130b:	83 c4 10             	add    $0x10,%esp
  80130e:	85 c0                	test   %eax,%eax
  801310:	78 10                	js     801322 <readn+0x41>
			return m;
		if (m == 0)
  801312:	85 c0                	test   %eax,%eax
  801314:	74 0a                	je     801320 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801316:	01 c3                	add    %eax,%ebx
  801318:	39 f3                	cmp    %esi,%ebx
  80131a:	72 db                	jb     8012f7 <readn+0x16>
  80131c:	89 d8                	mov    %ebx,%eax
  80131e:	eb 02                	jmp    801322 <readn+0x41>
  801320:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801322:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801325:	5b                   	pop    %ebx
  801326:	5e                   	pop    %esi
  801327:	5f                   	pop    %edi
  801328:	5d                   	pop    %ebp
  801329:	c3                   	ret    

0080132a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	53                   	push   %ebx
  80132e:	83 ec 14             	sub    $0x14,%esp
  801331:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801334:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801337:	50                   	push   %eax
  801338:	53                   	push   %ebx
  801339:	e8 ad fc ff ff       	call   800feb <fd_lookup>
  80133e:	83 c4 08             	add    $0x8,%esp
  801341:	89 c2                	mov    %eax,%edx
  801343:	85 c0                	test   %eax,%eax
  801345:	78 68                	js     8013af <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801347:	83 ec 08             	sub    $0x8,%esp
  80134a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80134d:	50                   	push   %eax
  80134e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801351:	ff 30                	pushl  (%eax)
  801353:	e8 e9 fc ff ff       	call   801041 <dev_lookup>
  801358:	83 c4 10             	add    $0x10,%esp
  80135b:	85 c0                	test   %eax,%eax
  80135d:	78 47                	js     8013a6 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80135f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801362:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801366:	75 21                	jne    801389 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801368:	a1 04 44 80 00       	mov    0x804404,%eax
  80136d:	8b 40 48             	mov    0x48(%eax),%eax
  801370:	83 ec 04             	sub    $0x4,%esp
  801373:	53                   	push   %ebx
  801374:	50                   	push   %eax
  801375:	68 1c 24 80 00       	push   $0x80241c
  80137a:	e8 2a f0 ff ff       	call   8003a9 <cprintf>
		return -E_INVAL;
  80137f:	83 c4 10             	add    $0x10,%esp
  801382:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801387:	eb 26                	jmp    8013af <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801389:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138c:	8b 52 0c             	mov    0xc(%edx),%edx
  80138f:	85 d2                	test   %edx,%edx
  801391:	74 17                	je     8013aa <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801393:	83 ec 04             	sub    $0x4,%esp
  801396:	ff 75 10             	pushl  0x10(%ebp)
  801399:	ff 75 0c             	pushl  0xc(%ebp)
  80139c:	50                   	push   %eax
  80139d:	ff d2                	call   *%edx
  80139f:	89 c2                	mov    %eax,%edx
  8013a1:	83 c4 10             	add    $0x10,%esp
  8013a4:	eb 09                	jmp    8013af <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013a6:	89 c2                	mov    %eax,%edx
  8013a8:	eb 05                	jmp    8013af <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8013aa:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  8013af:	89 d0                	mov    %edx,%eax
  8013b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013b4:	c9                   	leave  
  8013b5:	c3                   	ret    

008013b6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
  8013b9:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013bc:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8013bf:	50                   	push   %eax
  8013c0:	ff 75 08             	pushl  0x8(%ebp)
  8013c3:	e8 23 fc ff ff       	call   800feb <fd_lookup>
  8013c8:	83 c4 08             	add    $0x8,%esp
  8013cb:	85 c0                	test   %eax,%eax
  8013cd:	78 0e                	js     8013dd <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8013cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013dd:	c9                   	leave  
  8013de:	c3                   	ret    

008013df <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
  8013e2:	53                   	push   %ebx
  8013e3:	83 ec 14             	sub    $0x14,%esp
  8013e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013ec:	50                   	push   %eax
  8013ed:	53                   	push   %ebx
  8013ee:	e8 f8 fb ff ff       	call   800feb <fd_lookup>
  8013f3:	83 c4 08             	add    $0x8,%esp
  8013f6:	89 c2                	mov    %eax,%edx
  8013f8:	85 c0                	test   %eax,%eax
  8013fa:	78 65                	js     801461 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013fc:	83 ec 08             	sub    $0x8,%esp
  8013ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801402:	50                   	push   %eax
  801403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801406:	ff 30                	pushl  (%eax)
  801408:	e8 34 fc ff ff       	call   801041 <dev_lookup>
  80140d:	83 c4 10             	add    $0x10,%esp
  801410:	85 c0                	test   %eax,%eax
  801412:	78 44                	js     801458 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801417:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80141b:	75 21                	jne    80143e <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80141d:	a1 04 44 80 00       	mov    0x804404,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801422:	8b 40 48             	mov    0x48(%eax),%eax
  801425:	83 ec 04             	sub    $0x4,%esp
  801428:	53                   	push   %ebx
  801429:	50                   	push   %eax
  80142a:	68 dc 23 80 00       	push   $0x8023dc
  80142f:	e8 75 ef ff ff       	call   8003a9 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801434:	83 c4 10             	add    $0x10,%esp
  801437:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80143c:	eb 23                	jmp    801461 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  80143e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801441:	8b 52 18             	mov    0x18(%edx),%edx
  801444:	85 d2                	test   %edx,%edx
  801446:	74 14                	je     80145c <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801448:	83 ec 08             	sub    $0x8,%esp
  80144b:	ff 75 0c             	pushl  0xc(%ebp)
  80144e:	50                   	push   %eax
  80144f:	ff d2                	call   *%edx
  801451:	89 c2                	mov    %eax,%edx
  801453:	83 c4 10             	add    $0x10,%esp
  801456:	eb 09                	jmp    801461 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801458:	89 c2                	mov    %eax,%edx
  80145a:	eb 05                	jmp    801461 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80145c:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  801461:	89 d0                	mov    %edx,%eax
  801463:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	53                   	push   %ebx
  80146c:	83 ec 14             	sub    $0x14,%esp
  80146f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801472:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801475:	50                   	push   %eax
  801476:	ff 75 08             	pushl  0x8(%ebp)
  801479:	e8 6d fb ff ff       	call   800feb <fd_lookup>
  80147e:	83 c4 08             	add    $0x8,%esp
  801481:	89 c2                	mov    %eax,%edx
  801483:	85 c0                	test   %eax,%eax
  801485:	78 58                	js     8014df <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801487:	83 ec 08             	sub    $0x8,%esp
  80148a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80148d:	50                   	push   %eax
  80148e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801491:	ff 30                	pushl  (%eax)
  801493:	e8 a9 fb ff ff       	call   801041 <dev_lookup>
  801498:	83 c4 10             	add    $0x10,%esp
  80149b:	85 c0                	test   %eax,%eax
  80149d:	78 37                	js     8014d6 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  80149f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a2:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014a6:	74 32                	je     8014da <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014a8:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014ab:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014b2:	00 00 00 
	stat->st_isdir = 0;
  8014b5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014bc:	00 00 00 
	stat->st_dev = dev;
  8014bf:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014c5:	83 ec 08             	sub    $0x8,%esp
  8014c8:	53                   	push   %ebx
  8014c9:	ff 75 f0             	pushl  -0x10(%ebp)
  8014cc:	ff 50 14             	call   *0x14(%eax)
  8014cf:	89 c2                	mov    %eax,%edx
  8014d1:	83 c4 10             	add    $0x10,%esp
  8014d4:	eb 09                	jmp    8014df <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014d6:	89 c2                	mov    %eax,%edx
  8014d8:	eb 05                	jmp    8014df <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8014da:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8014df:	89 d0                	mov    %edx,%eax
  8014e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	56                   	push   %esi
  8014ea:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014eb:	83 ec 08             	sub    $0x8,%esp
  8014ee:	6a 00                	push   $0x0
  8014f0:	ff 75 08             	pushl  0x8(%ebp)
  8014f3:	e8 06 02 00 00       	call   8016fe <open>
  8014f8:	89 c3                	mov    %eax,%ebx
  8014fa:	83 c4 10             	add    $0x10,%esp
  8014fd:	85 c0                	test   %eax,%eax
  8014ff:	78 1b                	js     80151c <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801501:	83 ec 08             	sub    $0x8,%esp
  801504:	ff 75 0c             	pushl  0xc(%ebp)
  801507:	50                   	push   %eax
  801508:	e8 5b ff ff ff       	call   801468 <fstat>
  80150d:	89 c6                	mov    %eax,%esi
	close(fd);
  80150f:	89 1c 24             	mov    %ebx,(%esp)
  801512:	e8 fd fb ff ff       	call   801114 <close>
	return r;
  801517:	83 c4 10             	add    $0x10,%esp
  80151a:	89 f0                	mov    %esi,%eax
}
  80151c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80151f:	5b                   	pop    %ebx
  801520:	5e                   	pop    %esi
  801521:	5d                   	pop    %ebp
  801522:	c3                   	ret    

00801523 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
  801526:	56                   	push   %esi
  801527:	53                   	push   %ebx
  801528:	89 c6                	mov    %eax,%esi
  80152a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80152c:	83 3d 00 44 80 00 00 	cmpl   $0x0,0x804400
  801533:	75 12                	jne    801547 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801535:	83 ec 0c             	sub    $0xc,%esp
  801538:	6a 01                	push   $0x1
  80153a:	e8 8e 07 00 00       	call   801ccd <ipc_find_env>
  80153f:	a3 00 44 80 00       	mov    %eax,0x804400
  801544:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801547:	6a 07                	push   $0x7
  801549:	68 00 50 80 00       	push   $0x805000
  80154e:	56                   	push   %esi
  80154f:	ff 35 00 44 80 00    	pushl  0x804400
  801555:	e8 1f 07 00 00       	call   801c79 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80155a:	83 c4 0c             	add    $0xc,%esp
  80155d:	6a 00                	push   $0x0
  80155f:	53                   	push   %ebx
  801560:	6a 00                	push   $0x0
  801562:	e8 a7 06 00 00       	call   801c0e <ipc_recv>
}
  801567:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80156a:	5b                   	pop    %ebx
  80156b:	5e                   	pop    %esi
  80156c:	5d                   	pop    %ebp
  80156d:	c3                   	ret    

0080156e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	8b 40 0c             	mov    0xc(%eax),%eax
  80157a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80157f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801582:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801587:	ba 00 00 00 00       	mov    $0x0,%edx
  80158c:	b8 02 00 00 00       	mov    $0x2,%eax
  801591:	e8 8d ff ff ff       	call   801523 <fsipc>
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a4:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ae:	b8 06 00 00 00       	mov    $0x6,%eax
  8015b3:	e8 6b ff ff ff       	call   801523 <fsipc>
}
  8015b8:	c9                   	leave  
  8015b9:	c3                   	ret    

008015ba <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	53                   	push   %ebx
  8015be:	83 ec 04             	sub    $0x4,%esp
  8015c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ca:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d4:	b8 05 00 00 00       	mov    $0x5,%eax
  8015d9:	e8 45 ff ff ff       	call   801523 <fsipc>
  8015de:	85 c0                	test   %eax,%eax
  8015e0:	78 2c                	js     80160e <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015e2:	83 ec 08             	sub    $0x8,%esp
  8015e5:	68 00 50 80 00       	push   $0x805000
  8015ea:	53                   	push   %ebx
  8015eb:	e8 1e f4 ff ff       	call   800a0e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015f0:	a1 80 50 80 00       	mov    0x805080,%eax
  8015f5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015fb:	a1 84 50 80 00       	mov    0x805084,%eax
  801600:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801606:	83 c4 10             	add    $0x10,%esp
  801609:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80160e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801611:	c9                   	leave  
  801612:	c3                   	ret    

00801613 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	83 ec 08             	sub    $0x8,%esp
  801619:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161c:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80161f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801622:	8b 49 0c             	mov    0xc(%ecx),%ecx
  801625:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  80162b:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801630:	76 22                	jbe    801654 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  801632:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  801639:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	68 f8 0f 00 00       	push   $0xff8
  801644:	52                   	push   %edx
  801645:	68 08 50 80 00       	push   $0x805008
  80164a:	e8 52 f5 ff ff       	call   800ba1 <memmove>
  80164f:	83 c4 10             	add    $0x10,%esp
  801652:	eb 17                	jmp    80166b <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  801654:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  801659:	83 ec 04             	sub    $0x4,%esp
  80165c:	50                   	push   %eax
  80165d:	52                   	push   %edx
  80165e:	68 08 50 80 00       	push   $0x805008
  801663:	e8 39 f5 ff ff       	call   800ba1 <memmove>
  801668:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  80166b:	ba 00 00 00 00       	mov    $0x0,%edx
  801670:	b8 04 00 00 00       	mov    $0x4,%eax
  801675:	e8 a9 fe ff ff       	call   801523 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    

0080167c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	56                   	push   %esi
  801680:	53                   	push   %ebx
  801681:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	8b 40 0c             	mov    0xc(%eax),%eax
  80168a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80168f:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801695:	ba 00 00 00 00       	mov    $0x0,%edx
  80169a:	b8 03 00 00 00       	mov    $0x3,%eax
  80169f:	e8 7f fe ff ff       	call   801523 <fsipc>
  8016a4:	89 c3                	mov    %eax,%ebx
  8016a6:	85 c0                	test   %eax,%eax
  8016a8:	78 4b                	js     8016f5 <devfile_read+0x79>
		return r;
	assert(r <= n);
  8016aa:	39 c6                	cmp    %eax,%esi
  8016ac:	73 16                	jae    8016c4 <devfile_read+0x48>
  8016ae:	68 4c 24 80 00       	push   $0x80244c
  8016b3:	68 53 24 80 00       	push   $0x802453
  8016b8:	6a 7c                	push   $0x7c
  8016ba:	68 68 24 80 00       	push   $0x802468
  8016bf:	e8 0c ec ff ff       	call   8002d0 <_panic>
	assert(r <= PGSIZE);
  8016c4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016c9:	7e 16                	jle    8016e1 <devfile_read+0x65>
  8016cb:	68 73 24 80 00       	push   $0x802473
  8016d0:	68 53 24 80 00       	push   $0x802453
  8016d5:	6a 7d                	push   $0x7d
  8016d7:	68 68 24 80 00       	push   $0x802468
  8016dc:	e8 ef eb ff ff       	call   8002d0 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016e1:	83 ec 04             	sub    $0x4,%esp
  8016e4:	50                   	push   %eax
  8016e5:	68 00 50 80 00       	push   $0x805000
  8016ea:	ff 75 0c             	pushl  0xc(%ebp)
  8016ed:	e8 af f4 ff ff       	call   800ba1 <memmove>
	return r;
  8016f2:	83 c4 10             	add    $0x10,%esp
}
  8016f5:	89 d8                	mov    %ebx,%eax
  8016f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016fa:	5b                   	pop    %ebx
  8016fb:	5e                   	pop    %esi
  8016fc:	5d                   	pop    %ebp
  8016fd:	c3                   	ret    

008016fe <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	53                   	push   %ebx
  801702:	83 ec 20             	sub    $0x20,%esp
  801705:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801708:	53                   	push   %ebx
  801709:	e8 c7 f2 ff ff       	call   8009d5 <strlen>
  80170e:	83 c4 10             	add    $0x10,%esp
  801711:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801716:	7f 67                	jg     80177f <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801718:	83 ec 0c             	sub    $0xc,%esp
  80171b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80171e:	50                   	push   %eax
  80171f:	e8 78 f8 ff ff       	call   800f9c <fd_alloc>
  801724:	83 c4 10             	add    $0x10,%esp
		return r;
  801727:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801729:	85 c0                	test   %eax,%eax
  80172b:	78 57                	js     801784 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80172d:	83 ec 08             	sub    $0x8,%esp
  801730:	53                   	push   %ebx
  801731:	68 00 50 80 00       	push   $0x805000
  801736:	e8 d3 f2 ff ff       	call   800a0e <strcpy>
	fsipcbuf.open.req_omode = mode;
  80173b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173e:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801743:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801746:	b8 01 00 00 00       	mov    $0x1,%eax
  80174b:	e8 d3 fd ff ff       	call   801523 <fsipc>
  801750:	89 c3                	mov    %eax,%ebx
  801752:	83 c4 10             	add    $0x10,%esp
  801755:	85 c0                	test   %eax,%eax
  801757:	79 14                	jns    80176d <open+0x6f>
		fd_close(fd, 0);
  801759:	83 ec 08             	sub    $0x8,%esp
  80175c:	6a 00                	push   $0x0
  80175e:	ff 75 f4             	pushl  -0xc(%ebp)
  801761:	e8 2e f9 ff ff       	call   801094 <fd_close>
		return r;
  801766:	83 c4 10             	add    $0x10,%esp
  801769:	89 da                	mov    %ebx,%edx
  80176b:	eb 17                	jmp    801784 <open+0x86>
	}

	return fd2num(fd);
  80176d:	83 ec 0c             	sub    $0xc,%esp
  801770:	ff 75 f4             	pushl  -0xc(%ebp)
  801773:	e8 fc f7 ff ff       	call   800f74 <fd2num>
  801778:	89 c2                	mov    %eax,%edx
  80177a:	83 c4 10             	add    $0x10,%esp
  80177d:	eb 05                	jmp    801784 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80177f:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801784:	89 d0                	mov    %edx,%eax
  801786:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801791:	ba 00 00 00 00       	mov    $0x0,%edx
  801796:	b8 08 00 00 00       	mov    $0x8,%eax
  80179b:	e8 83 fd ff ff       	call   801523 <fsipc>
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8017a2:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8017a6:	7e 37                	jle    8017df <writebuf+0x3d>
};


static void
writebuf(struct printbuf *b)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	53                   	push   %ebx
  8017ac:	83 ec 08             	sub    $0x8,%esp
  8017af:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
		ssize_t result = write(b->fd, b->buf, b->idx);
  8017b1:	ff 70 04             	pushl  0x4(%eax)
  8017b4:	8d 40 10             	lea    0x10(%eax),%eax
  8017b7:	50                   	push   %eax
  8017b8:	ff 33                	pushl  (%ebx)
  8017ba:	e8 6b fb ff ff       	call   80132a <write>
		if (result > 0)
  8017bf:	83 c4 10             	add    $0x10,%esp
  8017c2:	85 c0                	test   %eax,%eax
  8017c4:	7e 03                	jle    8017c9 <writebuf+0x27>
			b->result += result;
  8017c6:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8017c9:	3b 43 04             	cmp    0x4(%ebx),%eax
  8017cc:	74 0d                	je     8017db <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  8017ce:	85 c0                	test   %eax,%eax
  8017d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d5:	0f 4f c2             	cmovg  %edx,%eax
  8017d8:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8017db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017de:	c9                   	leave  
  8017df:	f3 c3                	repz ret 

008017e1 <putch>:

static void
putch(int ch, void *thunk)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	53                   	push   %ebx
  8017e5:	83 ec 04             	sub    $0x4,%esp
  8017e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8017eb:	8b 53 04             	mov    0x4(%ebx),%edx
  8017ee:	8d 42 01             	lea    0x1(%edx),%eax
  8017f1:	89 43 04             	mov    %eax,0x4(%ebx)
  8017f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017f7:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8017fb:	3d 00 01 00 00       	cmp    $0x100,%eax
  801800:	75 0e                	jne    801810 <putch+0x2f>
		writebuf(b);
  801802:	89 d8                	mov    %ebx,%eax
  801804:	e8 99 ff ff ff       	call   8017a2 <writebuf>
		b->idx = 0;
  801809:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801810:	83 c4 04             	add    $0x4,%esp
  801813:	5b                   	pop    %ebx
  801814:	5d                   	pop    %ebp
  801815:	c3                   	ret    

00801816 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
  801819:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801828:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  80182f:	00 00 00 
	b.result = 0;
  801832:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801839:	00 00 00 
	b.error = 1;
  80183c:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801843:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801846:	ff 75 10             	pushl  0x10(%ebp)
  801849:	ff 75 0c             	pushl  0xc(%ebp)
  80184c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801852:	50                   	push   %eax
  801853:	68 e1 17 80 00       	push   $0x8017e1
  801858:	e8 b5 ec ff ff       	call   800512 <vprintfmt>
	if (b.idx > 0)
  80185d:	83 c4 10             	add    $0x10,%esp
  801860:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801867:	7e 0b                	jle    801874 <vfprintf+0x5e>
		writebuf(&b);
  801869:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80186f:	e8 2e ff ff ff       	call   8017a2 <writebuf>

	return (b.result ? b.result : b.error);
  801874:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80187a:	85 c0                	test   %eax,%eax
  80187c:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801883:	c9                   	leave  
  801884:	c3                   	ret    

00801885 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80188b:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  80188e:	50                   	push   %eax
  80188f:	ff 75 0c             	pushl  0xc(%ebp)
  801892:	ff 75 08             	pushl  0x8(%ebp)
  801895:	e8 7c ff ff ff       	call   801816 <vfprintf>
	va_end(ap);

	return cnt;
}
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <printf>:

int
printf(const char *fmt, ...)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8018a2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8018a5:	50                   	push   %eax
  8018a6:	ff 75 08             	pushl  0x8(%ebp)
  8018a9:	6a 01                	push   $0x1
  8018ab:	e8 66 ff ff ff       	call   801816 <vfprintf>
	va_end(ap);

	return cnt;
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	56                   	push   %esi
  8018b6:	53                   	push   %ebx
  8018b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8018ba:	83 ec 0c             	sub    $0xc,%esp
  8018bd:	ff 75 08             	pushl  0x8(%ebp)
  8018c0:	e8 bf f6 ff ff       	call   800f84 <fd2data>
  8018c5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8018c7:	83 c4 08             	add    $0x8,%esp
  8018ca:	68 7f 24 80 00       	push   $0x80247f
  8018cf:	53                   	push   %ebx
  8018d0:	e8 39 f1 ff ff       	call   800a0e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8018d5:	8b 46 04             	mov    0x4(%esi),%eax
  8018d8:	2b 06                	sub    (%esi),%eax
  8018da:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8018e0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018e7:	00 00 00 
	stat->st_dev = &devpipe;
  8018ea:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  8018f1:	30 80 00 
	return 0;
}
  8018f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018fc:	5b                   	pop    %ebx
  8018fd:	5e                   	pop    %esi
  8018fe:	5d                   	pop    %ebp
  8018ff:	c3                   	ret    

00801900 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	53                   	push   %ebx
  801904:	83 ec 0c             	sub    $0xc,%esp
  801907:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80190a:	53                   	push   %ebx
  80190b:	6a 00                	push   $0x0
  80190d:	e8 8f f5 ff ff       	call   800ea1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801912:	89 1c 24             	mov    %ebx,(%esp)
  801915:	e8 6a f6 ff ff       	call   800f84 <fd2data>
  80191a:	83 c4 08             	add    $0x8,%esp
  80191d:	50                   	push   %eax
  80191e:	6a 00                	push   $0x0
  801920:	e8 7c f5 ff ff       	call   800ea1 <sys_page_unmap>
}
  801925:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	57                   	push   %edi
  80192e:	56                   	push   %esi
  80192f:	53                   	push   %ebx
  801930:	83 ec 1c             	sub    $0x1c,%esp
  801933:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801936:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801938:	a1 04 44 80 00       	mov    0x804404,%eax
  80193d:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801940:	83 ec 0c             	sub    $0xc,%esp
  801943:	ff 75 e0             	pushl  -0x20(%ebp)
  801946:	e8 bb 03 00 00       	call   801d06 <pageref>
  80194b:	89 c3                	mov    %eax,%ebx
  80194d:	89 3c 24             	mov    %edi,(%esp)
  801950:	e8 b1 03 00 00       	call   801d06 <pageref>
  801955:	83 c4 10             	add    $0x10,%esp
  801958:	39 c3                	cmp    %eax,%ebx
  80195a:	0f 94 c1             	sete   %cl
  80195d:	0f b6 c9             	movzbl %cl,%ecx
  801960:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801963:	8b 15 04 44 80 00    	mov    0x804404,%edx
  801969:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80196c:	39 ce                	cmp    %ecx,%esi
  80196e:	74 1b                	je     80198b <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801970:	39 c3                	cmp    %eax,%ebx
  801972:	75 c4                	jne    801938 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801974:	8b 42 58             	mov    0x58(%edx),%eax
  801977:	ff 75 e4             	pushl  -0x1c(%ebp)
  80197a:	50                   	push   %eax
  80197b:	56                   	push   %esi
  80197c:	68 86 24 80 00       	push   $0x802486
  801981:	e8 23 ea ff ff       	call   8003a9 <cprintf>
  801986:	83 c4 10             	add    $0x10,%esp
  801989:	eb ad                	jmp    801938 <_pipeisclosed+0xe>
	}
}
  80198b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80198e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801991:	5b                   	pop    %ebx
  801992:	5e                   	pop    %esi
  801993:	5f                   	pop    %edi
  801994:	5d                   	pop    %ebp
  801995:	c3                   	ret    

00801996 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	57                   	push   %edi
  80199a:	56                   	push   %esi
  80199b:	53                   	push   %ebx
  80199c:	83 ec 28             	sub    $0x28,%esp
  80199f:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8019a2:	56                   	push   %esi
  8019a3:	e8 dc f5 ff ff       	call   800f84 <fd2data>
  8019a8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019aa:	83 c4 10             	add    $0x10,%esp
  8019ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8019b2:	eb 4b                	jmp    8019ff <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8019b4:	89 da                	mov    %ebx,%edx
  8019b6:	89 f0                	mov    %esi,%eax
  8019b8:	e8 6d ff ff ff       	call   80192a <_pipeisclosed>
  8019bd:	85 c0                	test   %eax,%eax
  8019bf:	75 48                	jne    801a09 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8019c1:	e8 6a f4 ff ff       	call   800e30 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019c6:	8b 43 04             	mov    0x4(%ebx),%eax
  8019c9:	8b 0b                	mov    (%ebx),%ecx
  8019cb:	8d 51 20             	lea    0x20(%ecx),%edx
  8019ce:	39 d0                	cmp    %edx,%eax
  8019d0:	73 e2                	jae    8019b4 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8019d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019d5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8019d9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8019dc:	89 c2                	mov    %eax,%edx
  8019de:	c1 fa 1f             	sar    $0x1f,%edx
  8019e1:	89 d1                	mov    %edx,%ecx
  8019e3:	c1 e9 1b             	shr    $0x1b,%ecx
  8019e6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8019e9:	83 e2 1f             	and    $0x1f,%edx
  8019ec:	29 ca                	sub    %ecx,%edx
  8019ee:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8019f2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8019f6:	83 c0 01             	add    $0x1,%eax
  8019f9:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019fc:	83 c7 01             	add    $0x1,%edi
  8019ff:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a02:	75 c2                	jne    8019c6 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801a04:	8b 45 10             	mov    0x10(%ebp),%eax
  801a07:	eb 05                	jmp    801a0e <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801a09:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801a0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a11:	5b                   	pop    %ebx
  801a12:	5e                   	pop    %esi
  801a13:	5f                   	pop    %edi
  801a14:	5d                   	pop    %ebp
  801a15:	c3                   	ret    

00801a16 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	57                   	push   %edi
  801a1a:	56                   	push   %esi
  801a1b:	53                   	push   %ebx
  801a1c:	83 ec 18             	sub    $0x18,%esp
  801a1f:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801a22:	57                   	push   %edi
  801a23:	e8 5c f5 ff ff       	call   800f84 <fd2data>
  801a28:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a2a:	83 c4 10             	add    $0x10,%esp
  801a2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a32:	eb 3d                	jmp    801a71 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801a34:	85 db                	test   %ebx,%ebx
  801a36:	74 04                	je     801a3c <devpipe_read+0x26>
				return i;
  801a38:	89 d8                	mov    %ebx,%eax
  801a3a:	eb 44                	jmp    801a80 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801a3c:	89 f2                	mov    %esi,%edx
  801a3e:	89 f8                	mov    %edi,%eax
  801a40:	e8 e5 fe ff ff       	call   80192a <_pipeisclosed>
  801a45:	85 c0                	test   %eax,%eax
  801a47:	75 32                	jne    801a7b <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801a49:	e8 e2 f3 ff ff       	call   800e30 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801a4e:	8b 06                	mov    (%esi),%eax
  801a50:	3b 46 04             	cmp    0x4(%esi),%eax
  801a53:	74 df                	je     801a34 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801a55:	99                   	cltd   
  801a56:	c1 ea 1b             	shr    $0x1b,%edx
  801a59:	01 d0                	add    %edx,%eax
  801a5b:	83 e0 1f             	and    $0x1f,%eax
  801a5e:	29 d0                	sub    %edx,%eax
  801a60:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801a65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a68:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801a6b:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a6e:	83 c3 01             	add    $0x1,%ebx
  801a71:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801a74:	75 d8                	jne    801a4e <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801a76:	8b 45 10             	mov    0x10(%ebp),%eax
  801a79:	eb 05                	jmp    801a80 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801a7b:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801a80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a83:	5b                   	pop    %ebx
  801a84:	5e                   	pop    %esi
  801a85:	5f                   	pop    %edi
  801a86:	5d                   	pop    %ebp
  801a87:	c3                   	ret    

00801a88 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	56                   	push   %esi
  801a8c:	53                   	push   %ebx
  801a8d:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801a90:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a93:	50                   	push   %eax
  801a94:	e8 03 f5 ff ff       	call   800f9c <fd_alloc>
  801a99:	83 c4 10             	add    $0x10,%esp
  801a9c:	89 c2                	mov    %eax,%edx
  801a9e:	85 c0                	test   %eax,%eax
  801aa0:	0f 88 2c 01 00 00    	js     801bd2 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801aa6:	83 ec 04             	sub    $0x4,%esp
  801aa9:	68 07 04 00 00       	push   $0x407
  801aae:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab1:	6a 00                	push   $0x0
  801ab3:	e8 9f f3 ff ff       	call   800e57 <sys_page_alloc>
  801ab8:	83 c4 10             	add    $0x10,%esp
  801abb:	89 c2                	mov    %eax,%edx
  801abd:	85 c0                	test   %eax,%eax
  801abf:	0f 88 0d 01 00 00    	js     801bd2 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801ac5:	83 ec 0c             	sub    $0xc,%esp
  801ac8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801acb:	50                   	push   %eax
  801acc:	e8 cb f4 ff ff       	call   800f9c <fd_alloc>
  801ad1:	89 c3                	mov    %eax,%ebx
  801ad3:	83 c4 10             	add    $0x10,%esp
  801ad6:	85 c0                	test   %eax,%eax
  801ad8:	0f 88 e2 00 00 00    	js     801bc0 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ade:	83 ec 04             	sub    $0x4,%esp
  801ae1:	68 07 04 00 00       	push   $0x407
  801ae6:	ff 75 f0             	pushl  -0x10(%ebp)
  801ae9:	6a 00                	push   $0x0
  801aeb:	e8 67 f3 ff ff       	call   800e57 <sys_page_alloc>
  801af0:	89 c3                	mov    %eax,%ebx
  801af2:	83 c4 10             	add    $0x10,%esp
  801af5:	85 c0                	test   %eax,%eax
  801af7:	0f 88 c3 00 00 00    	js     801bc0 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801afd:	83 ec 0c             	sub    $0xc,%esp
  801b00:	ff 75 f4             	pushl  -0xc(%ebp)
  801b03:	e8 7c f4 ff ff       	call   800f84 <fd2data>
  801b08:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b0a:	83 c4 0c             	add    $0xc,%esp
  801b0d:	68 07 04 00 00       	push   $0x407
  801b12:	50                   	push   %eax
  801b13:	6a 00                	push   $0x0
  801b15:	e8 3d f3 ff ff       	call   800e57 <sys_page_alloc>
  801b1a:	89 c3                	mov    %eax,%ebx
  801b1c:	83 c4 10             	add    $0x10,%esp
  801b1f:	85 c0                	test   %eax,%eax
  801b21:	0f 88 89 00 00 00    	js     801bb0 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b27:	83 ec 0c             	sub    $0xc,%esp
  801b2a:	ff 75 f0             	pushl  -0x10(%ebp)
  801b2d:	e8 52 f4 ff ff       	call   800f84 <fd2data>
  801b32:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801b39:	50                   	push   %eax
  801b3a:	6a 00                	push   $0x0
  801b3c:	56                   	push   %esi
  801b3d:	6a 00                	push   $0x0
  801b3f:	e8 37 f3 ff ff       	call   800e7b <sys_page_map>
  801b44:	89 c3                	mov    %eax,%ebx
  801b46:	83 c4 20             	add    $0x20,%esp
  801b49:	85 c0                	test   %eax,%eax
  801b4b:	78 55                	js     801ba2 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801b4d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b56:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801b62:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b6b:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b70:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801b77:	83 ec 0c             	sub    $0xc,%esp
  801b7a:	ff 75 f4             	pushl  -0xc(%ebp)
  801b7d:	e8 f2 f3 ff ff       	call   800f74 <fd2num>
  801b82:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b85:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801b87:	83 c4 04             	add    $0x4,%esp
  801b8a:	ff 75 f0             	pushl  -0x10(%ebp)
  801b8d:	e8 e2 f3 ff ff       	call   800f74 <fd2num>
  801b92:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b95:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801b98:	83 c4 10             	add    $0x10,%esp
  801b9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba0:	eb 30                	jmp    801bd2 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801ba2:	83 ec 08             	sub    $0x8,%esp
  801ba5:	56                   	push   %esi
  801ba6:	6a 00                	push   $0x0
  801ba8:	e8 f4 f2 ff ff       	call   800ea1 <sys_page_unmap>
  801bad:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801bb0:	83 ec 08             	sub    $0x8,%esp
  801bb3:	ff 75 f0             	pushl  -0x10(%ebp)
  801bb6:	6a 00                	push   $0x0
  801bb8:	e8 e4 f2 ff ff       	call   800ea1 <sys_page_unmap>
  801bbd:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801bc0:	83 ec 08             	sub    $0x8,%esp
  801bc3:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc6:	6a 00                	push   $0x0
  801bc8:	e8 d4 f2 ff ff       	call   800ea1 <sys_page_unmap>
  801bcd:	83 c4 10             	add    $0x10,%esp
  801bd0:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  801bd2:	89 d0                	mov    %edx,%eax
  801bd4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bd7:	5b                   	pop    %ebx
  801bd8:	5e                   	pop    %esi
  801bd9:	5d                   	pop    %ebp
  801bda:	c3                   	ret    

00801bdb <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
  801bde:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801be1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801be4:	50                   	push   %eax
  801be5:	ff 75 08             	pushl  0x8(%ebp)
  801be8:	e8 fe f3 ff ff       	call   800feb <fd_lookup>
  801bed:	83 c4 10             	add    $0x10,%esp
  801bf0:	85 c0                	test   %eax,%eax
  801bf2:	78 18                	js     801c0c <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801bf4:	83 ec 0c             	sub    $0xc,%esp
  801bf7:	ff 75 f4             	pushl  -0xc(%ebp)
  801bfa:	e8 85 f3 ff ff       	call   800f84 <fd2data>
	return _pipeisclosed(fd, p);
  801bff:	89 c2                	mov    %eax,%edx
  801c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c04:	e8 21 fd ff ff       	call   80192a <_pipeisclosed>
  801c09:	83 c4 10             	add    $0x10,%esp
}
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	56                   	push   %esi
  801c12:	53                   	push   %ebx
  801c13:	8b 75 08             	mov    0x8(%ebp),%esi
  801c16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c19:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801c1c:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801c1e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801c23:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801c26:	83 ec 0c             	sub    $0xc,%esp
  801c29:	50                   	push   %eax
  801c2a:	e8 23 f3 ff ff       	call   800f52 <sys_ipc_recv>
	if (from_env_store)
  801c2f:	83 c4 10             	add    $0x10,%esp
  801c32:	85 f6                	test   %esi,%esi
  801c34:	74 0b                	je     801c41 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801c36:	8b 15 04 44 80 00    	mov    0x804404,%edx
  801c3c:	8b 52 74             	mov    0x74(%edx),%edx
  801c3f:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801c41:	85 db                	test   %ebx,%ebx
  801c43:	74 0b                	je     801c50 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  801c45:	8b 15 04 44 80 00    	mov    0x804404,%edx
  801c4b:	8b 52 78             	mov    0x78(%edx),%edx
  801c4e:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  801c50:	85 c0                	test   %eax,%eax
  801c52:	79 16                	jns    801c6a <ipc_recv+0x5c>
		if (from_env_store)
  801c54:	85 f6                	test   %esi,%esi
  801c56:	74 06                	je     801c5e <ipc_recv+0x50>
			*from_env_store = 0;
  801c58:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  801c5e:	85 db                	test   %ebx,%ebx
  801c60:	74 10                	je     801c72 <ipc_recv+0x64>
			*perm_store = 0;
  801c62:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801c68:	eb 08                	jmp    801c72 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  801c6a:	a1 04 44 80 00       	mov    0x804404,%eax
  801c6f:	8b 40 70             	mov    0x70(%eax),%eax
}
  801c72:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c75:	5b                   	pop    %ebx
  801c76:	5e                   	pop    %esi
  801c77:	5d                   	pop    %ebp
  801c78:	c3                   	ret    

00801c79 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	57                   	push   %edi
  801c7d:	56                   	push   %esi
  801c7e:	53                   	push   %ebx
  801c7f:	83 ec 0c             	sub    $0xc,%esp
  801c82:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c85:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c88:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  801c8b:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  801c8d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801c92:	0f 44 d8             	cmove  %eax,%ebx
  801c95:	eb 1c                	jmp    801cb3 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  801c97:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c9a:	74 12                	je     801cae <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801c9c:	50                   	push   %eax
  801c9d:	68 9e 24 80 00       	push   $0x80249e
  801ca2:	6a 42                	push   $0x42
  801ca4:	68 b4 24 80 00       	push   $0x8024b4
  801ca9:	e8 22 e6 ff ff       	call   8002d0 <_panic>
		sys_yield();
  801cae:	e8 7d f1 ff ff       	call   800e30 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801cb3:	ff 75 14             	pushl  0x14(%ebp)
  801cb6:	53                   	push   %ebx
  801cb7:	56                   	push   %esi
  801cb8:	57                   	push   %edi
  801cb9:	e8 6f f2 ff ff       	call   800f2d <sys_ipc_try_send>
  801cbe:	83 c4 10             	add    $0x10,%esp
  801cc1:	85 c0                	test   %eax,%eax
  801cc3:	75 d2                	jne    801c97 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801cc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cc8:	5b                   	pop    %ebx
  801cc9:	5e                   	pop    %esi
  801cca:	5f                   	pop    %edi
  801ccb:	5d                   	pop    %ebp
  801ccc:	c3                   	ret    

00801ccd <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801cd3:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801cd8:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801cdb:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801ce1:	8b 52 50             	mov    0x50(%edx),%edx
  801ce4:	39 ca                	cmp    %ecx,%edx
  801ce6:	75 0d                	jne    801cf5 <ipc_find_env+0x28>
			return envs[i].env_id;
  801ce8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ceb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801cf0:	8b 40 48             	mov    0x48(%eax),%eax
  801cf3:	eb 0f                	jmp    801d04 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801cf5:	83 c0 01             	add    $0x1,%eax
  801cf8:	3d 00 04 00 00       	cmp    $0x400,%eax
  801cfd:	75 d9                	jne    801cd8 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801cff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d04:	5d                   	pop    %ebp
  801d05:	c3                   	ret    

00801d06 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
  801d09:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801d0c:	89 d0                	mov    %edx,%eax
  801d0e:	c1 e8 16             	shr    $0x16,%eax
  801d11:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801d18:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801d1d:	f6 c1 01             	test   $0x1,%cl
  801d20:	74 1d                	je     801d3f <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801d22:	c1 ea 0c             	shr    $0xc,%edx
  801d25:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801d2c:	f6 c2 01             	test   $0x1,%dl
  801d2f:	74 0e                	je     801d3f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801d31:	c1 ea 0c             	shr    $0xc,%edx
  801d34:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801d3b:	ef 
  801d3c:	0f b7 c0             	movzwl %ax,%eax
}
  801d3f:	5d                   	pop    %ebp
  801d40:	c3                   	ret    
  801d41:	66 90                	xchg   %ax,%ax
  801d43:	66 90                	xchg   %ax,%ax
  801d45:	66 90                	xchg   %ax,%ax
  801d47:	66 90                	xchg   %ax,%ax
  801d49:	66 90                	xchg   %ax,%ax
  801d4b:	66 90                	xchg   %ax,%ax
  801d4d:	66 90                	xchg   %ax,%ax
  801d4f:	90                   	nop

00801d50 <__udivdi3>:
  801d50:	55                   	push   %ebp
  801d51:	57                   	push   %edi
  801d52:	56                   	push   %esi
  801d53:	53                   	push   %ebx
  801d54:	83 ec 1c             	sub    $0x1c,%esp
  801d57:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d5b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d5f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d67:	85 f6                	test   %esi,%esi
  801d69:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d6d:	89 ca                	mov    %ecx,%edx
  801d6f:	89 f8                	mov    %edi,%eax
  801d71:	75 3d                	jne    801db0 <__udivdi3+0x60>
  801d73:	39 cf                	cmp    %ecx,%edi
  801d75:	0f 87 c5 00 00 00    	ja     801e40 <__udivdi3+0xf0>
  801d7b:	85 ff                	test   %edi,%edi
  801d7d:	89 fd                	mov    %edi,%ebp
  801d7f:	75 0b                	jne    801d8c <__udivdi3+0x3c>
  801d81:	b8 01 00 00 00       	mov    $0x1,%eax
  801d86:	31 d2                	xor    %edx,%edx
  801d88:	f7 f7                	div    %edi
  801d8a:	89 c5                	mov    %eax,%ebp
  801d8c:	89 c8                	mov    %ecx,%eax
  801d8e:	31 d2                	xor    %edx,%edx
  801d90:	f7 f5                	div    %ebp
  801d92:	89 c1                	mov    %eax,%ecx
  801d94:	89 d8                	mov    %ebx,%eax
  801d96:	89 cf                	mov    %ecx,%edi
  801d98:	f7 f5                	div    %ebp
  801d9a:	89 c3                	mov    %eax,%ebx
  801d9c:	89 d8                	mov    %ebx,%eax
  801d9e:	89 fa                	mov    %edi,%edx
  801da0:	83 c4 1c             	add    $0x1c,%esp
  801da3:	5b                   	pop    %ebx
  801da4:	5e                   	pop    %esi
  801da5:	5f                   	pop    %edi
  801da6:	5d                   	pop    %ebp
  801da7:	c3                   	ret    
  801da8:	90                   	nop
  801da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801db0:	39 ce                	cmp    %ecx,%esi
  801db2:	77 74                	ja     801e28 <__udivdi3+0xd8>
  801db4:	0f bd fe             	bsr    %esi,%edi
  801db7:	83 f7 1f             	xor    $0x1f,%edi
  801dba:	0f 84 98 00 00 00    	je     801e58 <__udivdi3+0x108>
  801dc0:	bb 20 00 00 00       	mov    $0x20,%ebx
  801dc5:	89 f9                	mov    %edi,%ecx
  801dc7:	89 c5                	mov    %eax,%ebp
  801dc9:	29 fb                	sub    %edi,%ebx
  801dcb:	d3 e6                	shl    %cl,%esi
  801dcd:	89 d9                	mov    %ebx,%ecx
  801dcf:	d3 ed                	shr    %cl,%ebp
  801dd1:	89 f9                	mov    %edi,%ecx
  801dd3:	d3 e0                	shl    %cl,%eax
  801dd5:	09 ee                	or     %ebp,%esi
  801dd7:	89 d9                	mov    %ebx,%ecx
  801dd9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ddd:	89 d5                	mov    %edx,%ebp
  801ddf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801de3:	d3 ed                	shr    %cl,%ebp
  801de5:	89 f9                	mov    %edi,%ecx
  801de7:	d3 e2                	shl    %cl,%edx
  801de9:	89 d9                	mov    %ebx,%ecx
  801deb:	d3 e8                	shr    %cl,%eax
  801ded:	09 c2                	or     %eax,%edx
  801def:	89 d0                	mov    %edx,%eax
  801df1:	89 ea                	mov    %ebp,%edx
  801df3:	f7 f6                	div    %esi
  801df5:	89 d5                	mov    %edx,%ebp
  801df7:	89 c3                	mov    %eax,%ebx
  801df9:	f7 64 24 0c          	mull   0xc(%esp)
  801dfd:	39 d5                	cmp    %edx,%ebp
  801dff:	72 10                	jb     801e11 <__udivdi3+0xc1>
  801e01:	8b 74 24 08          	mov    0x8(%esp),%esi
  801e05:	89 f9                	mov    %edi,%ecx
  801e07:	d3 e6                	shl    %cl,%esi
  801e09:	39 c6                	cmp    %eax,%esi
  801e0b:	73 07                	jae    801e14 <__udivdi3+0xc4>
  801e0d:	39 d5                	cmp    %edx,%ebp
  801e0f:	75 03                	jne    801e14 <__udivdi3+0xc4>
  801e11:	83 eb 01             	sub    $0x1,%ebx
  801e14:	31 ff                	xor    %edi,%edi
  801e16:	89 d8                	mov    %ebx,%eax
  801e18:	89 fa                	mov    %edi,%edx
  801e1a:	83 c4 1c             	add    $0x1c,%esp
  801e1d:	5b                   	pop    %ebx
  801e1e:	5e                   	pop    %esi
  801e1f:	5f                   	pop    %edi
  801e20:	5d                   	pop    %ebp
  801e21:	c3                   	ret    
  801e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e28:	31 ff                	xor    %edi,%edi
  801e2a:	31 db                	xor    %ebx,%ebx
  801e2c:	89 d8                	mov    %ebx,%eax
  801e2e:	89 fa                	mov    %edi,%edx
  801e30:	83 c4 1c             	add    $0x1c,%esp
  801e33:	5b                   	pop    %ebx
  801e34:	5e                   	pop    %esi
  801e35:	5f                   	pop    %edi
  801e36:	5d                   	pop    %ebp
  801e37:	c3                   	ret    
  801e38:	90                   	nop
  801e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e40:	89 d8                	mov    %ebx,%eax
  801e42:	f7 f7                	div    %edi
  801e44:	31 ff                	xor    %edi,%edi
  801e46:	89 c3                	mov    %eax,%ebx
  801e48:	89 d8                	mov    %ebx,%eax
  801e4a:	89 fa                	mov    %edi,%edx
  801e4c:	83 c4 1c             	add    $0x1c,%esp
  801e4f:	5b                   	pop    %ebx
  801e50:	5e                   	pop    %esi
  801e51:	5f                   	pop    %edi
  801e52:	5d                   	pop    %ebp
  801e53:	c3                   	ret    
  801e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801e58:	39 ce                	cmp    %ecx,%esi
  801e5a:	72 0c                	jb     801e68 <__udivdi3+0x118>
  801e5c:	31 db                	xor    %ebx,%ebx
  801e5e:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801e62:	0f 87 34 ff ff ff    	ja     801d9c <__udivdi3+0x4c>
  801e68:	bb 01 00 00 00       	mov    $0x1,%ebx
  801e6d:	e9 2a ff ff ff       	jmp    801d9c <__udivdi3+0x4c>
  801e72:	66 90                	xchg   %ax,%ax
  801e74:	66 90                	xchg   %ax,%ax
  801e76:	66 90                	xchg   %ax,%ax
  801e78:	66 90                	xchg   %ax,%ax
  801e7a:	66 90                	xchg   %ax,%ax
  801e7c:	66 90                	xchg   %ax,%ax
  801e7e:	66 90                	xchg   %ax,%ax

00801e80 <__umoddi3>:
  801e80:	55                   	push   %ebp
  801e81:	57                   	push   %edi
  801e82:	56                   	push   %esi
  801e83:	53                   	push   %ebx
  801e84:	83 ec 1c             	sub    $0x1c,%esp
  801e87:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801e8b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e97:	85 d2                	test   %edx,%edx
  801e99:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ea1:	89 f3                	mov    %esi,%ebx
  801ea3:	89 3c 24             	mov    %edi,(%esp)
  801ea6:	89 74 24 04          	mov    %esi,0x4(%esp)
  801eaa:	75 1c                	jne    801ec8 <__umoddi3+0x48>
  801eac:	39 f7                	cmp    %esi,%edi
  801eae:	76 50                	jbe    801f00 <__umoddi3+0x80>
  801eb0:	89 c8                	mov    %ecx,%eax
  801eb2:	89 f2                	mov    %esi,%edx
  801eb4:	f7 f7                	div    %edi
  801eb6:	89 d0                	mov    %edx,%eax
  801eb8:	31 d2                	xor    %edx,%edx
  801eba:	83 c4 1c             	add    $0x1c,%esp
  801ebd:	5b                   	pop    %ebx
  801ebe:	5e                   	pop    %esi
  801ebf:	5f                   	pop    %edi
  801ec0:	5d                   	pop    %ebp
  801ec1:	c3                   	ret    
  801ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801ec8:	39 f2                	cmp    %esi,%edx
  801eca:	89 d0                	mov    %edx,%eax
  801ecc:	77 52                	ja     801f20 <__umoddi3+0xa0>
  801ece:	0f bd ea             	bsr    %edx,%ebp
  801ed1:	83 f5 1f             	xor    $0x1f,%ebp
  801ed4:	75 5a                	jne    801f30 <__umoddi3+0xb0>
  801ed6:	3b 54 24 04          	cmp    0x4(%esp),%edx
  801eda:	0f 82 e0 00 00 00    	jb     801fc0 <__umoddi3+0x140>
  801ee0:	39 0c 24             	cmp    %ecx,(%esp)
  801ee3:	0f 86 d7 00 00 00    	jbe    801fc0 <__umoddi3+0x140>
  801ee9:	8b 44 24 08          	mov    0x8(%esp),%eax
  801eed:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ef1:	83 c4 1c             	add    $0x1c,%esp
  801ef4:	5b                   	pop    %ebx
  801ef5:	5e                   	pop    %esi
  801ef6:	5f                   	pop    %edi
  801ef7:	5d                   	pop    %ebp
  801ef8:	c3                   	ret    
  801ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f00:	85 ff                	test   %edi,%edi
  801f02:	89 fd                	mov    %edi,%ebp
  801f04:	75 0b                	jne    801f11 <__umoddi3+0x91>
  801f06:	b8 01 00 00 00       	mov    $0x1,%eax
  801f0b:	31 d2                	xor    %edx,%edx
  801f0d:	f7 f7                	div    %edi
  801f0f:	89 c5                	mov    %eax,%ebp
  801f11:	89 f0                	mov    %esi,%eax
  801f13:	31 d2                	xor    %edx,%edx
  801f15:	f7 f5                	div    %ebp
  801f17:	89 c8                	mov    %ecx,%eax
  801f19:	f7 f5                	div    %ebp
  801f1b:	89 d0                	mov    %edx,%eax
  801f1d:	eb 99                	jmp    801eb8 <__umoddi3+0x38>
  801f1f:	90                   	nop
  801f20:	89 c8                	mov    %ecx,%eax
  801f22:	89 f2                	mov    %esi,%edx
  801f24:	83 c4 1c             	add    $0x1c,%esp
  801f27:	5b                   	pop    %ebx
  801f28:	5e                   	pop    %esi
  801f29:	5f                   	pop    %edi
  801f2a:	5d                   	pop    %ebp
  801f2b:	c3                   	ret    
  801f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f30:	8b 34 24             	mov    (%esp),%esi
  801f33:	bf 20 00 00 00       	mov    $0x20,%edi
  801f38:	89 e9                	mov    %ebp,%ecx
  801f3a:	29 ef                	sub    %ebp,%edi
  801f3c:	d3 e0                	shl    %cl,%eax
  801f3e:	89 f9                	mov    %edi,%ecx
  801f40:	89 f2                	mov    %esi,%edx
  801f42:	d3 ea                	shr    %cl,%edx
  801f44:	89 e9                	mov    %ebp,%ecx
  801f46:	09 c2                	or     %eax,%edx
  801f48:	89 d8                	mov    %ebx,%eax
  801f4a:	89 14 24             	mov    %edx,(%esp)
  801f4d:	89 f2                	mov    %esi,%edx
  801f4f:	d3 e2                	shl    %cl,%edx
  801f51:	89 f9                	mov    %edi,%ecx
  801f53:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f57:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801f5b:	d3 e8                	shr    %cl,%eax
  801f5d:	89 e9                	mov    %ebp,%ecx
  801f5f:	89 c6                	mov    %eax,%esi
  801f61:	d3 e3                	shl    %cl,%ebx
  801f63:	89 f9                	mov    %edi,%ecx
  801f65:	89 d0                	mov    %edx,%eax
  801f67:	d3 e8                	shr    %cl,%eax
  801f69:	89 e9                	mov    %ebp,%ecx
  801f6b:	09 d8                	or     %ebx,%eax
  801f6d:	89 d3                	mov    %edx,%ebx
  801f6f:	89 f2                	mov    %esi,%edx
  801f71:	f7 34 24             	divl   (%esp)
  801f74:	89 d6                	mov    %edx,%esi
  801f76:	d3 e3                	shl    %cl,%ebx
  801f78:	f7 64 24 04          	mull   0x4(%esp)
  801f7c:	39 d6                	cmp    %edx,%esi
  801f7e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f82:	89 d1                	mov    %edx,%ecx
  801f84:	89 c3                	mov    %eax,%ebx
  801f86:	72 08                	jb     801f90 <__umoddi3+0x110>
  801f88:	75 11                	jne    801f9b <__umoddi3+0x11b>
  801f8a:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801f8e:	73 0b                	jae    801f9b <__umoddi3+0x11b>
  801f90:	2b 44 24 04          	sub    0x4(%esp),%eax
  801f94:	1b 14 24             	sbb    (%esp),%edx
  801f97:	89 d1                	mov    %edx,%ecx
  801f99:	89 c3                	mov    %eax,%ebx
  801f9b:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f9f:	29 da                	sub    %ebx,%edx
  801fa1:	19 ce                	sbb    %ecx,%esi
  801fa3:	89 f9                	mov    %edi,%ecx
  801fa5:	89 f0                	mov    %esi,%eax
  801fa7:	d3 e0                	shl    %cl,%eax
  801fa9:	89 e9                	mov    %ebp,%ecx
  801fab:	d3 ea                	shr    %cl,%edx
  801fad:	89 e9                	mov    %ebp,%ecx
  801faf:	d3 ee                	shr    %cl,%esi
  801fb1:	09 d0                	or     %edx,%eax
  801fb3:	89 f2                	mov    %esi,%edx
  801fb5:	83 c4 1c             	add    $0x1c,%esp
  801fb8:	5b                   	pop    %ebx
  801fb9:	5e                   	pop    %esi
  801fba:	5f                   	pop    %edi
  801fbb:	5d                   	pop    %ebp
  801fbc:	c3                   	ret    
  801fbd:	8d 76 00             	lea    0x0(%esi),%esi
  801fc0:	29 f9                	sub    %edi,%ecx
  801fc2:	19 d6                	sbb    %edx,%esi
  801fc4:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fc8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fcc:	e9 18 ff ff ff       	jmp    801ee9 <__umoddi3+0x69>
