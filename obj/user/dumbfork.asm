
obj/user/dumbfork.debug:     formato del fichero elf32-i386


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
  80002c:	e8 aa 01 00 00       	call   8001db <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <duppage>:
	}
}

void
duppage(envid_t dstenv, void *addr)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
  80003b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 07                	push   $0x7
  800043:	53                   	push   %ebx
  800044:	56                   	push   %esi
  800045:	e8 89 0c 00 00       	call   800cd3 <sys_page_alloc>
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	79 12                	jns    800063 <duppage+0x30>
		panic("sys_page_alloc: %e", r);
  800051:	50                   	push   %eax
  800052:	68 c0 1e 80 00       	push   $0x801ec0
  800057:	6a 20                	push   $0x20
  800059:	68 d3 1e 80 00       	push   $0x801ed3
  80005e:	e8 dc 01 00 00       	call   80023f <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800063:	83 ec 0c             	sub    $0xc,%esp
  800066:	6a 07                	push   $0x7
  800068:	68 00 00 40 00       	push   $0x400000
  80006d:	6a 00                	push   $0x0
  80006f:	53                   	push   %ebx
  800070:	56                   	push   %esi
  800071:	e8 81 0c 00 00       	call   800cf7 <sys_page_map>
  800076:	83 c4 20             	add    $0x20,%esp
  800079:	85 c0                	test   %eax,%eax
  80007b:	79 12                	jns    80008f <duppage+0x5c>
		panic("sys_page_map: %e", r);
  80007d:	50                   	push   %eax
  80007e:	68 e3 1e 80 00       	push   $0x801ee3
  800083:	6a 22                	push   $0x22
  800085:	68 d3 1e 80 00       	push   $0x801ed3
  80008a:	e8 b0 01 00 00       	call   80023f <_panic>
	memmove(UTEMP, addr, PGSIZE);
  80008f:	83 ec 04             	sub    $0x4,%esp
  800092:	68 00 10 00 00       	push   $0x1000
  800097:	53                   	push   %ebx
  800098:	68 00 00 40 00       	push   $0x400000
  80009d:	e8 7b 09 00 00       	call   800a1d <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8000a2:	83 c4 08             	add    $0x8,%esp
  8000a5:	68 00 00 40 00       	push   $0x400000
  8000aa:	6a 00                	push   $0x0
  8000ac:	e8 6c 0c 00 00       	call   800d1d <sys_page_unmap>
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	85 c0                	test   %eax,%eax
  8000b6:	79 12                	jns    8000ca <duppage+0x97>
		panic("sys_page_unmap: %e", r);
  8000b8:	50                   	push   %eax
  8000b9:	68 f4 1e 80 00       	push   $0x801ef4
  8000be:	6a 25                	push   $0x25
  8000c0:	68 d3 1e 80 00       	push   $0x801ed3
  8000c5:	e8 75 01 00 00       	call   80023f <_panic>
}
  8000ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5d                   	pop    %ebp
  8000d0:	c3                   	ret    

008000d1 <dumbfork>:

envid_t
dumbfork(void)
{
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	56                   	push   %esi
  8000d5:	53                   	push   %ebx
  8000d6:	83 ec 10             	sub    $0x10,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8000d9:	b8 07 00 00 00       	mov    $0x7,%eax
  8000de:	cd 30                	int    $0x30
  8000e0:	89 c3                	mov    %eax,%ebx
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  8000e2:	85 c0                	test   %eax,%eax
  8000e4:	79 12                	jns    8000f8 <dumbfork+0x27>
		panic("sys_exofork: %e", envid);
  8000e6:	50                   	push   %eax
  8000e7:	68 07 1f 80 00       	push   $0x801f07
  8000ec:	6a 37                	push   $0x37
  8000ee:	68 d3 1e 80 00       	push   $0x801ed3
  8000f3:	e8 47 01 00 00       	call   80023f <_panic>
  8000f8:	89 c6                	mov    %eax,%esi
	if (envid == 0) {
  8000fa:	85 c0                	test   %eax,%eax
  8000fc:	75 1e                	jne    80011c <dumbfork+0x4b>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  8000fe:	e8 85 0b 00 00       	call   800c88 <sys_getenvid>
  800103:	25 ff 03 00 00       	and    $0x3ff,%eax
  800108:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80010b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800110:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800115:	b8 00 00 00 00       	mov    $0x0,%eax
  80011a:	eb 60                	jmp    80017c <dumbfork+0xab>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  80011c:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  800123:	eb 14                	jmp    800139 <dumbfork+0x68>
		duppage(envid, addr);
  800125:	83 ec 08             	sub    $0x8,%esp
  800128:	52                   	push   %edx
  800129:	56                   	push   %esi
  80012a:	e8 04 ff ff ff       	call   800033 <duppage>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  80012f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  800136:	83 c4 10             	add    $0x10,%esp
  800139:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80013c:	81 fa 00 60 80 00    	cmp    $0x806000,%edx
  800142:	72 e1                	jb     800125 <dumbfork+0x54>
		duppage(envid, addr);

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  800144:	83 ec 08             	sub    $0x8,%esp
  800147:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80014a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80014f:	50                   	push   %eax
  800150:	53                   	push   %ebx
  800151:	e8 dd fe ff ff       	call   800033 <duppage>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  800156:	83 c4 08             	add    $0x8,%esp
  800159:	6a 02                	push   $0x2
  80015b:	53                   	push   %ebx
  80015c:	e8 df 0b 00 00       	call   800d40 <sys_env_set_status>
  800161:	83 c4 10             	add    $0x10,%esp
  800164:	85 c0                	test   %eax,%eax
  800166:	79 12                	jns    80017a <dumbfork+0xa9>
		panic("sys_env_set_status: %e", r);
  800168:	50                   	push   %eax
  800169:	68 17 1f 80 00       	push   $0x801f17
  80016e:	6a 4c                	push   $0x4c
  800170:	68 d3 1e 80 00       	push   $0x801ed3
  800175:	e8 c5 00 00 00       	call   80023f <_panic>

	return envid;
  80017a:	89 d8                	mov    %ebx,%eax
}
  80017c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80017f:	5b                   	pop    %ebx
  800180:	5e                   	pop    %esi
  800181:	5d                   	pop    %ebp
  800182:	c3                   	ret    

00800183 <umain>:

envid_t dumbfork(void);

void
umain(int argc, char **argv)
{
  800183:	55                   	push   %ebp
  800184:	89 e5                	mov    %esp,%ebp
  800186:	57                   	push   %edi
  800187:	56                   	push   %esi
  800188:	53                   	push   %ebx
  800189:	83 ec 0c             	sub    $0xc,%esp
	envid_t who;
	int i;

	// fork a child process
	who = dumbfork();
  80018c:	e8 40 ff ff ff       	call   8000d1 <dumbfork>
  800191:	89 c7                	mov    %eax,%edi
  800193:	85 c0                	test   %eax,%eax
  800195:	be 35 1f 80 00       	mov    $0x801f35,%esi
  80019a:	b8 2e 1f 80 00       	mov    $0x801f2e,%eax
  80019f:	0f 45 f0             	cmovne %eax,%esi

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  8001a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001a7:	eb 1a                	jmp    8001c3 <umain+0x40>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	56                   	push   %esi
  8001ad:	53                   	push   %ebx
  8001ae:	68 3b 1f 80 00       	push   $0x801f3b
  8001b3:	e8 60 01 00 00       	call   800318 <cprintf>
		sys_yield();
  8001b8:	e8 ef 0a 00 00       	call   800cac <sys_yield>

	// fork a child process
	who = dumbfork();

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  8001bd:	83 c3 01             	add    $0x1,%ebx
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	85 ff                	test   %edi,%edi
  8001c5:	74 07                	je     8001ce <umain+0x4b>
  8001c7:	83 fb 09             	cmp    $0x9,%ebx
  8001ca:	7e dd                	jle    8001a9 <umain+0x26>
  8001cc:	eb 05                	jmp    8001d3 <umain+0x50>
  8001ce:	83 fb 13             	cmp    $0x13,%ebx
  8001d1:	7e d6                	jle    8001a9 <umain+0x26>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
		sys_yield();
	}
}
  8001d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d6:	5b                   	pop    %ebx
  8001d7:	5e                   	pop    %esi
  8001d8:	5f                   	pop    %edi
  8001d9:	5d                   	pop    %ebp
  8001da:	c3                   	ret    

008001db <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
  8001de:	56                   	push   %esi
  8001df:	53                   	push   %ebx
  8001e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001e3:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8001e6:	e8 9d 0a 00 00       	call   800c88 <sys_getenvid>
	if (id >= 0)
  8001eb:	85 c0                	test   %eax,%eax
  8001ed:	78 12                	js     800201 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  8001ef:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001f4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001f7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001fc:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800201:	85 db                	test   %ebx,%ebx
  800203:	7e 07                	jle    80020c <libmain+0x31>
		binaryname = argv[0];
  800205:	8b 06                	mov    (%esi),%eax
  800207:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80020c:	83 ec 08             	sub    $0x8,%esp
  80020f:	56                   	push   %esi
  800210:	53                   	push   %ebx
  800211:	e8 6d ff ff ff       	call   800183 <umain>

	// exit gracefully
	exit();
  800216:	e8 0a 00 00 00       	call   800225 <exit>
}
  80021b:	83 c4 10             	add    $0x10,%esp
  80021e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800221:	5b                   	pop    %ebx
  800222:	5e                   	pop    %esi
  800223:	5d                   	pop    %ebp
  800224:	c3                   	ret    

00800225 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80022b:	e8 8b 0d 00 00       	call   800fbb <close_all>
	sys_env_destroy(0);
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	6a 00                	push   $0x0
  800235:	e8 2c 0a 00 00       	call   800c66 <sys_env_destroy>
}
  80023a:	83 c4 10             	add    $0x10,%esp
  80023d:	c9                   	leave  
  80023e:	c3                   	ret    

0080023f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80023f:	55                   	push   %ebp
  800240:	89 e5                	mov    %esp,%ebp
  800242:	56                   	push   %esi
  800243:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800244:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800247:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80024d:	e8 36 0a 00 00       	call   800c88 <sys_getenvid>
  800252:	83 ec 0c             	sub    $0xc,%esp
  800255:	ff 75 0c             	pushl  0xc(%ebp)
  800258:	ff 75 08             	pushl  0x8(%ebp)
  80025b:	56                   	push   %esi
  80025c:	50                   	push   %eax
  80025d:	68 58 1f 80 00       	push   $0x801f58
  800262:	e8 b1 00 00 00       	call   800318 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800267:	83 c4 18             	add    $0x18,%esp
  80026a:	53                   	push   %ebx
  80026b:	ff 75 10             	pushl  0x10(%ebp)
  80026e:	e8 54 00 00 00       	call   8002c7 <vcprintf>
	cprintf("\n");
  800273:	c7 04 24 4b 1f 80 00 	movl   $0x801f4b,(%esp)
  80027a:	e8 99 00 00 00       	call   800318 <cprintf>
  80027f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800282:	cc                   	int3   
  800283:	eb fd                	jmp    800282 <_panic+0x43>

00800285 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800285:	55                   	push   %ebp
  800286:	89 e5                	mov    %esp,%ebp
  800288:	53                   	push   %ebx
  800289:	83 ec 04             	sub    $0x4,%esp
  80028c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80028f:	8b 13                	mov    (%ebx),%edx
  800291:	8d 42 01             	lea    0x1(%edx),%eax
  800294:	89 03                	mov    %eax,(%ebx)
  800296:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800299:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80029d:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a2:	75 1a                	jne    8002be <putch+0x39>
		sys_cputs(b->buf, b->idx);
  8002a4:	83 ec 08             	sub    $0x8,%esp
  8002a7:	68 ff 00 00 00       	push   $0xff
  8002ac:	8d 43 08             	lea    0x8(%ebx),%eax
  8002af:	50                   	push   %eax
  8002b0:	e8 67 09 00 00       	call   800c1c <sys_cputs>
		b->idx = 0;
  8002b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002bb:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  8002be:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002c5:	c9                   	leave  
  8002c6:	c3                   	ret    

008002c7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002c7:	55                   	push   %ebp
  8002c8:	89 e5                	mov    %esp,%ebp
  8002ca:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002d0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002d7:	00 00 00 
	b.cnt = 0;
  8002da:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002e1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002e4:	ff 75 0c             	pushl  0xc(%ebp)
  8002e7:	ff 75 08             	pushl  0x8(%ebp)
  8002ea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002f0:	50                   	push   %eax
  8002f1:	68 85 02 80 00       	push   $0x800285
  8002f6:	e8 86 01 00 00       	call   800481 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002fb:	83 c4 08             	add    $0x8,%esp
  8002fe:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800304:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80030a:	50                   	push   %eax
  80030b:	e8 0c 09 00 00       	call   800c1c <sys_cputs>

	return b.cnt;
}
  800310:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800316:	c9                   	leave  
  800317:	c3                   	ret    

00800318 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80031e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800321:	50                   	push   %eax
  800322:	ff 75 08             	pushl  0x8(%ebp)
  800325:	e8 9d ff ff ff       	call   8002c7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80032a:	c9                   	leave  
  80032b:	c3                   	ret    

0080032c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
  80032f:	57                   	push   %edi
  800330:	56                   	push   %esi
  800331:	53                   	push   %ebx
  800332:	83 ec 1c             	sub    $0x1c,%esp
  800335:	89 c7                	mov    %eax,%edi
  800337:	89 d6                	mov    %edx,%esi
  800339:	8b 45 08             	mov    0x8(%ebp),%eax
  80033c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80033f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800342:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800345:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800348:	bb 00 00 00 00       	mov    $0x0,%ebx
  80034d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800350:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800353:	39 d3                	cmp    %edx,%ebx
  800355:	72 05                	jb     80035c <printnum+0x30>
  800357:	39 45 10             	cmp    %eax,0x10(%ebp)
  80035a:	77 45                	ja     8003a1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	ff 75 18             	pushl  0x18(%ebp)
  800362:	8b 45 14             	mov    0x14(%ebp),%eax
  800365:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800368:	53                   	push   %ebx
  800369:	ff 75 10             	pushl  0x10(%ebp)
  80036c:	83 ec 08             	sub    $0x8,%esp
  80036f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800372:	ff 75 e0             	pushl  -0x20(%ebp)
  800375:	ff 75 dc             	pushl  -0x24(%ebp)
  800378:	ff 75 d8             	pushl  -0x28(%ebp)
  80037b:	e8 b0 18 00 00       	call   801c30 <__udivdi3>
  800380:	83 c4 18             	add    $0x18,%esp
  800383:	52                   	push   %edx
  800384:	50                   	push   %eax
  800385:	89 f2                	mov    %esi,%edx
  800387:	89 f8                	mov    %edi,%eax
  800389:	e8 9e ff ff ff       	call   80032c <printnum>
  80038e:	83 c4 20             	add    $0x20,%esp
  800391:	eb 18                	jmp    8003ab <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800393:	83 ec 08             	sub    $0x8,%esp
  800396:	56                   	push   %esi
  800397:	ff 75 18             	pushl  0x18(%ebp)
  80039a:	ff d7                	call   *%edi
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	eb 03                	jmp    8003a4 <printnum+0x78>
  8003a1:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003a4:	83 eb 01             	sub    $0x1,%ebx
  8003a7:	85 db                	test   %ebx,%ebx
  8003a9:	7f e8                	jg     800393 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003ab:	83 ec 08             	sub    $0x8,%esp
  8003ae:	56                   	push   %esi
  8003af:	83 ec 04             	sub    $0x4,%esp
  8003b2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b5:	ff 75 e0             	pushl  -0x20(%ebp)
  8003b8:	ff 75 dc             	pushl  -0x24(%ebp)
  8003bb:	ff 75 d8             	pushl  -0x28(%ebp)
  8003be:	e8 9d 19 00 00       	call   801d60 <__umoddi3>
  8003c3:	83 c4 14             	add    $0x14,%esp
  8003c6:	0f be 80 7b 1f 80 00 	movsbl 0x801f7b(%eax),%eax
  8003cd:	50                   	push   %eax
  8003ce:	ff d7                	call   *%edi
}
  8003d0:	83 c4 10             	add    $0x10,%esp
  8003d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003d6:	5b                   	pop    %ebx
  8003d7:	5e                   	pop    %esi
  8003d8:	5f                   	pop    %edi
  8003d9:	5d                   	pop    %ebp
  8003da:	c3                   	ret    

008003db <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003db:	55                   	push   %ebp
  8003dc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003de:	83 fa 01             	cmp    $0x1,%edx
  8003e1:	7e 0e                	jle    8003f1 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003e3:	8b 10                	mov    (%eax),%edx
  8003e5:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003e8:	89 08                	mov    %ecx,(%eax)
  8003ea:	8b 02                	mov    (%edx),%eax
  8003ec:	8b 52 04             	mov    0x4(%edx),%edx
  8003ef:	eb 22                	jmp    800413 <getuint+0x38>
	else if (lflag)
  8003f1:	85 d2                	test   %edx,%edx
  8003f3:	74 10                	je     800405 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003f5:	8b 10                	mov    (%eax),%edx
  8003f7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003fa:	89 08                	mov    %ecx,(%eax)
  8003fc:	8b 02                	mov    (%edx),%eax
  8003fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800403:	eb 0e                	jmp    800413 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800405:	8b 10                	mov    (%eax),%edx
  800407:	8d 4a 04             	lea    0x4(%edx),%ecx
  80040a:	89 08                	mov    %ecx,(%eax)
  80040c:	8b 02                	mov    (%edx),%eax
  80040e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800413:	5d                   	pop    %ebp
  800414:	c3                   	ret    

00800415 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800415:	55                   	push   %ebp
  800416:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800418:	83 fa 01             	cmp    $0x1,%edx
  80041b:	7e 0e                	jle    80042b <getint+0x16>
		return va_arg(*ap, long long);
  80041d:	8b 10                	mov    (%eax),%edx
  80041f:	8d 4a 08             	lea    0x8(%edx),%ecx
  800422:	89 08                	mov    %ecx,(%eax)
  800424:	8b 02                	mov    (%edx),%eax
  800426:	8b 52 04             	mov    0x4(%edx),%edx
  800429:	eb 1a                	jmp    800445 <getint+0x30>
	else if (lflag)
  80042b:	85 d2                	test   %edx,%edx
  80042d:	74 0c                	je     80043b <getint+0x26>
		return va_arg(*ap, long);
  80042f:	8b 10                	mov    (%eax),%edx
  800431:	8d 4a 04             	lea    0x4(%edx),%ecx
  800434:	89 08                	mov    %ecx,(%eax)
  800436:	8b 02                	mov    (%edx),%eax
  800438:	99                   	cltd   
  800439:	eb 0a                	jmp    800445 <getint+0x30>
	else
		return va_arg(*ap, int);
  80043b:	8b 10                	mov    (%eax),%edx
  80043d:	8d 4a 04             	lea    0x4(%edx),%ecx
  800440:	89 08                	mov    %ecx,(%eax)
  800442:	8b 02                	mov    (%edx),%eax
  800444:	99                   	cltd   
}
  800445:	5d                   	pop    %ebp
  800446:	c3                   	ret    

00800447 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800447:	55                   	push   %ebp
  800448:	89 e5                	mov    %esp,%ebp
  80044a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80044d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800451:	8b 10                	mov    (%eax),%edx
  800453:	3b 50 04             	cmp    0x4(%eax),%edx
  800456:	73 0a                	jae    800462 <sprintputch+0x1b>
		*b->buf++ = ch;
  800458:	8d 4a 01             	lea    0x1(%edx),%ecx
  80045b:	89 08                	mov    %ecx,(%eax)
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	88 02                	mov    %al,(%edx)
}
  800462:	5d                   	pop    %ebp
  800463:	c3                   	ret    

00800464 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800464:	55                   	push   %ebp
  800465:	89 e5                	mov    %esp,%ebp
  800467:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  80046a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80046d:	50                   	push   %eax
  80046e:	ff 75 10             	pushl  0x10(%ebp)
  800471:	ff 75 0c             	pushl  0xc(%ebp)
  800474:	ff 75 08             	pushl  0x8(%ebp)
  800477:	e8 05 00 00 00       	call   800481 <vprintfmt>
	va_end(ap);
}
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	c9                   	leave  
  800480:	c3                   	ret    

00800481 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800481:	55                   	push   %ebp
  800482:	89 e5                	mov    %esp,%ebp
  800484:	57                   	push   %edi
  800485:	56                   	push   %esi
  800486:	53                   	push   %ebx
  800487:	83 ec 2c             	sub    $0x2c,%esp
  80048a:	8b 75 08             	mov    0x8(%ebp),%esi
  80048d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800490:	8b 7d 10             	mov    0x10(%ebp),%edi
  800493:	eb 12                	jmp    8004a7 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800495:	85 c0                	test   %eax,%eax
  800497:	0f 84 44 03 00 00    	je     8007e1 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  80049d:	83 ec 08             	sub    $0x8,%esp
  8004a0:	53                   	push   %ebx
  8004a1:	50                   	push   %eax
  8004a2:	ff d6                	call   *%esi
  8004a4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004a7:	83 c7 01             	add    $0x1,%edi
  8004aa:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004ae:	83 f8 25             	cmp    $0x25,%eax
  8004b1:	75 e2                	jne    800495 <vprintfmt+0x14>
  8004b3:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8004b7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8004be:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004c5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8004cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d1:	eb 07                	jmp    8004da <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8004d6:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004da:	8d 47 01             	lea    0x1(%edi),%eax
  8004dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004e0:	0f b6 07             	movzbl (%edi),%eax
  8004e3:	0f b6 c8             	movzbl %al,%ecx
  8004e6:	83 e8 23             	sub    $0x23,%eax
  8004e9:	3c 55                	cmp    $0x55,%al
  8004eb:	0f 87 d5 02 00 00    	ja     8007c6 <vprintfmt+0x345>
  8004f1:	0f b6 c0             	movzbl %al,%eax
  8004f4:	ff 24 85 c0 20 80 00 	jmp    *0x8020c0(,%eax,4)
  8004fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004fe:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800502:	eb d6                	jmp    8004da <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800504:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800507:	b8 00 00 00 00       	mov    $0x0,%eax
  80050c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80050f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800512:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  800516:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  800519:	8d 51 d0             	lea    -0x30(%ecx),%edx
  80051c:	83 fa 09             	cmp    $0x9,%edx
  80051f:	77 39                	ja     80055a <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800521:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800524:	eb e9                	jmp    80050f <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800526:	8b 45 14             	mov    0x14(%ebp),%eax
  800529:	8d 48 04             	lea    0x4(%eax),%ecx
  80052c:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80052f:	8b 00                	mov    (%eax),%eax
  800531:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800534:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800537:	eb 27                	jmp    800560 <vprintfmt+0xdf>
  800539:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80053c:	85 c0                	test   %eax,%eax
  80053e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800543:	0f 49 c8             	cmovns %eax,%ecx
  800546:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800549:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80054c:	eb 8c                	jmp    8004da <vprintfmt+0x59>
  80054e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800551:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800558:	eb 80                	jmp    8004da <vprintfmt+0x59>
  80055a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80055d:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  800560:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800564:	0f 89 70 ff ff ff    	jns    8004da <vprintfmt+0x59>
				width = precision, precision = -1;
  80056a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80056d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800570:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800577:	e9 5e ff ff ff       	jmp    8004da <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80057c:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800582:	e9 53 ff ff ff       	jmp    8004da <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8d 50 04             	lea    0x4(%eax),%edx
  80058d:	89 55 14             	mov    %edx,0x14(%ebp)
  800590:	83 ec 08             	sub    $0x8,%esp
  800593:	53                   	push   %ebx
  800594:	ff 30                	pushl  (%eax)
  800596:	ff d6                	call   *%esi
			break;
  800598:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80059b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  80059e:	e9 04 ff ff ff       	jmp    8004a7 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a6:	8d 50 04             	lea    0x4(%eax),%edx
  8005a9:	89 55 14             	mov    %edx,0x14(%ebp)
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	99                   	cltd   
  8005af:	31 d0                	xor    %edx,%eax
  8005b1:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005b3:	83 f8 0f             	cmp    $0xf,%eax
  8005b6:	7f 0b                	jg     8005c3 <vprintfmt+0x142>
  8005b8:	8b 14 85 20 22 80 00 	mov    0x802220(,%eax,4),%edx
  8005bf:	85 d2                	test   %edx,%edx
  8005c1:	75 18                	jne    8005db <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  8005c3:	50                   	push   %eax
  8005c4:	68 93 1f 80 00       	push   $0x801f93
  8005c9:	53                   	push   %ebx
  8005ca:	56                   	push   %esi
  8005cb:	e8 94 fe ff ff       	call   800464 <printfmt>
  8005d0:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8005d6:	e9 cc fe ff ff       	jmp    8004a7 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  8005db:	52                   	push   %edx
  8005dc:	68 55 23 80 00       	push   $0x802355
  8005e1:	53                   	push   %ebx
  8005e2:	56                   	push   %esi
  8005e3:	e8 7c fe ff ff       	call   800464 <printfmt>
  8005e8:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005ee:	e9 b4 fe ff ff       	jmp    8004a7 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f6:	8d 50 04             	lea    0x4(%eax),%edx
  8005f9:	89 55 14             	mov    %edx,0x14(%ebp)
  8005fc:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8005fe:	85 ff                	test   %edi,%edi
  800600:	b8 8c 1f 80 00       	mov    $0x801f8c,%eax
  800605:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800608:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80060c:	0f 8e 94 00 00 00    	jle    8006a6 <vprintfmt+0x225>
  800612:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800616:	0f 84 98 00 00 00    	je     8006b4 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  80061c:	83 ec 08             	sub    $0x8,%esp
  80061f:	ff 75 d0             	pushl  -0x30(%ebp)
  800622:	57                   	push   %edi
  800623:	e8 41 02 00 00       	call   800869 <strnlen>
  800628:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80062b:	29 c1                	sub    %eax,%ecx
  80062d:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800630:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800633:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800637:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80063a:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80063d:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80063f:	eb 0f                	jmp    800650 <vprintfmt+0x1cf>
					putch(padc, putdat);
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	53                   	push   %ebx
  800645:	ff 75 e0             	pushl  -0x20(%ebp)
  800648:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80064a:	83 ef 01             	sub    $0x1,%edi
  80064d:	83 c4 10             	add    $0x10,%esp
  800650:	85 ff                	test   %edi,%edi
  800652:	7f ed                	jg     800641 <vprintfmt+0x1c0>
  800654:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800657:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  80065a:	85 c9                	test   %ecx,%ecx
  80065c:	b8 00 00 00 00       	mov    $0x0,%eax
  800661:	0f 49 c1             	cmovns %ecx,%eax
  800664:	29 c1                	sub    %eax,%ecx
  800666:	89 75 08             	mov    %esi,0x8(%ebp)
  800669:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80066c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80066f:	89 cb                	mov    %ecx,%ebx
  800671:	eb 4d                	jmp    8006c0 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800673:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800677:	74 1b                	je     800694 <vprintfmt+0x213>
  800679:	0f be c0             	movsbl %al,%eax
  80067c:	83 e8 20             	sub    $0x20,%eax
  80067f:	83 f8 5e             	cmp    $0x5e,%eax
  800682:	76 10                	jbe    800694 <vprintfmt+0x213>
					putch('?', putdat);
  800684:	83 ec 08             	sub    $0x8,%esp
  800687:	ff 75 0c             	pushl  0xc(%ebp)
  80068a:	6a 3f                	push   $0x3f
  80068c:	ff 55 08             	call   *0x8(%ebp)
  80068f:	83 c4 10             	add    $0x10,%esp
  800692:	eb 0d                	jmp    8006a1 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  800694:	83 ec 08             	sub    $0x8,%esp
  800697:	ff 75 0c             	pushl  0xc(%ebp)
  80069a:	52                   	push   %edx
  80069b:	ff 55 08             	call   *0x8(%ebp)
  80069e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006a1:	83 eb 01             	sub    $0x1,%ebx
  8006a4:	eb 1a                	jmp    8006c0 <vprintfmt+0x23f>
  8006a6:	89 75 08             	mov    %esi,0x8(%ebp)
  8006a9:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006ac:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006af:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006b2:	eb 0c                	jmp    8006c0 <vprintfmt+0x23f>
  8006b4:	89 75 08             	mov    %esi,0x8(%ebp)
  8006b7:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006ba:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006bd:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006c0:	83 c7 01             	add    $0x1,%edi
  8006c3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006c7:	0f be d0             	movsbl %al,%edx
  8006ca:	85 d2                	test   %edx,%edx
  8006cc:	74 23                	je     8006f1 <vprintfmt+0x270>
  8006ce:	85 f6                	test   %esi,%esi
  8006d0:	78 a1                	js     800673 <vprintfmt+0x1f2>
  8006d2:	83 ee 01             	sub    $0x1,%esi
  8006d5:	79 9c                	jns    800673 <vprintfmt+0x1f2>
  8006d7:	89 df                	mov    %ebx,%edi
  8006d9:	8b 75 08             	mov    0x8(%ebp),%esi
  8006dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006df:	eb 18                	jmp    8006f9 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006e1:	83 ec 08             	sub    $0x8,%esp
  8006e4:	53                   	push   %ebx
  8006e5:	6a 20                	push   $0x20
  8006e7:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006e9:	83 ef 01             	sub    $0x1,%edi
  8006ec:	83 c4 10             	add    $0x10,%esp
  8006ef:	eb 08                	jmp    8006f9 <vprintfmt+0x278>
  8006f1:	89 df                	mov    %ebx,%edi
  8006f3:	8b 75 08             	mov    0x8(%ebp),%esi
  8006f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006f9:	85 ff                	test   %edi,%edi
  8006fb:	7f e4                	jg     8006e1 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800700:	e9 a2 fd ff ff       	jmp    8004a7 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800705:	8d 45 14             	lea    0x14(%ebp),%eax
  800708:	e8 08 fd ff ff       	call   800415 <getint>
  80070d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800710:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800713:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800718:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80071c:	79 74                	jns    800792 <vprintfmt+0x311>
				putch('-', putdat);
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	53                   	push   %ebx
  800722:	6a 2d                	push   $0x2d
  800724:	ff d6                	call   *%esi
				num = -(long long) num;
  800726:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800729:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80072c:	f7 d8                	neg    %eax
  80072e:	83 d2 00             	adc    $0x0,%edx
  800731:	f7 da                	neg    %edx
  800733:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  800736:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80073b:	eb 55                	jmp    800792 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80073d:	8d 45 14             	lea    0x14(%ebp),%eax
  800740:	e8 96 fc ff ff       	call   8003db <getuint>
			base = 10;
  800745:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80074a:	eb 46                	jmp    800792 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  80074c:	8d 45 14             	lea    0x14(%ebp),%eax
  80074f:	e8 87 fc ff ff       	call   8003db <getuint>
			base = 8;
  800754:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800759:	eb 37                	jmp    800792 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  80075b:	83 ec 08             	sub    $0x8,%esp
  80075e:	53                   	push   %ebx
  80075f:	6a 30                	push   $0x30
  800761:	ff d6                	call   *%esi
			putch('x', putdat);
  800763:	83 c4 08             	add    $0x8,%esp
  800766:	53                   	push   %ebx
  800767:	6a 78                	push   $0x78
  800769:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80076b:	8b 45 14             	mov    0x14(%ebp),%eax
  80076e:	8d 50 04             	lea    0x4(%eax),%edx
  800771:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800774:	8b 00                	mov    (%eax),%eax
  800776:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  80077b:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80077e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800783:	eb 0d                	jmp    800792 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800785:	8d 45 14             	lea    0x14(%ebp),%eax
  800788:	e8 4e fc ff ff       	call   8003db <getuint>
			base = 16;
  80078d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800792:	83 ec 0c             	sub    $0xc,%esp
  800795:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800799:	57                   	push   %edi
  80079a:	ff 75 e0             	pushl  -0x20(%ebp)
  80079d:	51                   	push   %ecx
  80079e:	52                   	push   %edx
  80079f:	50                   	push   %eax
  8007a0:	89 da                	mov    %ebx,%edx
  8007a2:	89 f0                	mov    %esi,%eax
  8007a4:	e8 83 fb ff ff       	call   80032c <printnum>
			break;
  8007a9:	83 c4 20             	add    $0x20,%esp
  8007ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8007af:	e9 f3 fc ff ff       	jmp    8004a7 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007b4:	83 ec 08             	sub    $0x8,%esp
  8007b7:	53                   	push   %ebx
  8007b8:	51                   	push   %ecx
  8007b9:	ff d6                	call   *%esi
			break;
  8007bb:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8007c1:	e9 e1 fc ff ff       	jmp    8004a7 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	53                   	push   %ebx
  8007ca:	6a 25                	push   $0x25
  8007cc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007ce:	83 c4 10             	add    $0x10,%esp
  8007d1:	eb 03                	jmp    8007d6 <vprintfmt+0x355>
  8007d3:	83 ef 01             	sub    $0x1,%edi
  8007d6:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  8007da:	75 f7                	jne    8007d3 <vprintfmt+0x352>
  8007dc:	e9 c6 fc ff ff       	jmp    8004a7 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  8007e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007e4:	5b                   	pop    %ebx
  8007e5:	5e                   	pop    %esi
  8007e6:	5f                   	pop    %edi
  8007e7:	5d                   	pop    %ebp
  8007e8:	c3                   	ret    

008007e9 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007e9:	55                   	push   %ebp
  8007ea:	89 e5                	mov    %esp,%ebp
  8007ec:	83 ec 18             	sub    $0x18,%esp
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007f8:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007fc:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800806:	85 c0                	test   %eax,%eax
  800808:	74 26                	je     800830 <vsnprintf+0x47>
  80080a:	85 d2                	test   %edx,%edx
  80080c:	7e 22                	jle    800830 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80080e:	ff 75 14             	pushl  0x14(%ebp)
  800811:	ff 75 10             	pushl  0x10(%ebp)
  800814:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800817:	50                   	push   %eax
  800818:	68 47 04 80 00       	push   $0x800447
  80081d:	e8 5f fc ff ff       	call   800481 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800822:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800825:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80082b:	83 c4 10             	add    $0x10,%esp
  80082e:	eb 05                	jmp    800835 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800830:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800835:	c9                   	leave  
  800836:	c3                   	ret    

00800837 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800837:	55                   	push   %ebp
  800838:	89 e5                	mov    %esp,%ebp
  80083a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80083d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800840:	50                   	push   %eax
  800841:	ff 75 10             	pushl  0x10(%ebp)
  800844:	ff 75 0c             	pushl  0xc(%ebp)
  800847:	ff 75 08             	pushl  0x8(%ebp)
  80084a:	e8 9a ff ff ff       	call   8007e9 <vsnprintf>
	va_end(ap);

	return rc;
}
  80084f:	c9                   	leave  
  800850:	c3                   	ret    

00800851 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
  800854:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800857:	b8 00 00 00 00       	mov    $0x0,%eax
  80085c:	eb 03                	jmp    800861 <strlen+0x10>
		n++;
  80085e:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800861:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800865:	75 f7                	jne    80085e <strlen+0xd>
		n++;
	return n;
}
  800867:	5d                   	pop    %ebp
  800868:	c3                   	ret    

00800869 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800869:	55                   	push   %ebp
  80086a:	89 e5                	mov    %esp,%ebp
  80086c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80086f:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800872:	ba 00 00 00 00       	mov    $0x0,%edx
  800877:	eb 03                	jmp    80087c <strnlen+0x13>
		n++;
  800879:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80087c:	39 c2                	cmp    %eax,%edx
  80087e:	74 08                	je     800888 <strnlen+0x1f>
  800880:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800884:	75 f3                	jne    800879 <strnlen+0x10>
  800886:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  800888:	5d                   	pop    %ebp
  800889:	c3                   	ret    

0080088a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	53                   	push   %ebx
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800894:	89 c2                	mov    %eax,%edx
  800896:	83 c2 01             	add    $0x1,%edx
  800899:	83 c1 01             	add    $0x1,%ecx
  80089c:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008a0:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008a3:	84 db                	test   %bl,%bl
  8008a5:	75 ef                	jne    800896 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008a7:	5b                   	pop    %ebx
  8008a8:	5d                   	pop    %ebp
  8008a9:	c3                   	ret    

008008aa <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	53                   	push   %ebx
  8008ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008b1:	53                   	push   %ebx
  8008b2:	e8 9a ff ff ff       	call   800851 <strlen>
  8008b7:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008ba:	ff 75 0c             	pushl  0xc(%ebp)
  8008bd:	01 d8                	add    %ebx,%eax
  8008bf:	50                   	push   %eax
  8008c0:	e8 c5 ff ff ff       	call   80088a <strcpy>
	return dst;
}
  8008c5:	89 d8                	mov    %ebx,%eax
  8008c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ca:	c9                   	leave  
  8008cb:	c3                   	ret    

008008cc <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008cc:	55                   	push   %ebp
  8008cd:	89 e5                	mov    %esp,%ebp
  8008cf:	56                   	push   %esi
  8008d0:	53                   	push   %ebx
  8008d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8008d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008d7:	89 f3                	mov    %esi,%ebx
  8008d9:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008dc:	89 f2                	mov    %esi,%edx
  8008de:	eb 0f                	jmp    8008ef <strncpy+0x23>
		*dst++ = *src;
  8008e0:	83 c2 01             	add    $0x1,%edx
  8008e3:	0f b6 01             	movzbl (%ecx),%eax
  8008e6:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008e9:	80 39 01             	cmpb   $0x1,(%ecx)
  8008ec:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008ef:	39 da                	cmp    %ebx,%edx
  8008f1:	75 ed                	jne    8008e0 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008f3:	89 f0                	mov    %esi,%eax
  8008f5:	5b                   	pop    %ebx
  8008f6:	5e                   	pop    %esi
  8008f7:	5d                   	pop    %ebp
  8008f8:	c3                   	ret    

008008f9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	56                   	push   %esi
  8008fd:	53                   	push   %ebx
  8008fe:	8b 75 08             	mov    0x8(%ebp),%esi
  800901:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800904:	8b 55 10             	mov    0x10(%ebp),%edx
  800907:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800909:	85 d2                	test   %edx,%edx
  80090b:	74 21                	je     80092e <strlcpy+0x35>
  80090d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800911:	89 f2                	mov    %esi,%edx
  800913:	eb 09                	jmp    80091e <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800915:	83 c2 01             	add    $0x1,%edx
  800918:	83 c1 01             	add    $0x1,%ecx
  80091b:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80091e:	39 c2                	cmp    %eax,%edx
  800920:	74 09                	je     80092b <strlcpy+0x32>
  800922:	0f b6 19             	movzbl (%ecx),%ebx
  800925:	84 db                	test   %bl,%bl
  800927:	75 ec                	jne    800915 <strlcpy+0x1c>
  800929:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  80092b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80092e:	29 f0                	sub    %esi,%eax
}
  800930:	5b                   	pop    %ebx
  800931:	5e                   	pop    %esi
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    

00800934 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
  800937:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80093a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80093d:	eb 06                	jmp    800945 <strcmp+0x11>
		p++, q++;
  80093f:	83 c1 01             	add    $0x1,%ecx
  800942:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800945:	0f b6 01             	movzbl (%ecx),%eax
  800948:	84 c0                	test   %al,%al
  80094a:	74 04                	je     800950 <strcmp+0x1c>
  80094c:	3a 02                	cmp    (%edx),%al
  80094e:	74 ef                	je     80093f <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800950:	0f b6 c0             	movzbl %al,%eax
  800953:	0f b6 12             	movzbl (%edx),%edx
  800956:	29 d0                	sub    %edx,%eax
}
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	53                   	push   %ebx
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	8b 55 0c             	mov    0xc(%ebp),%edx
  800964:	89 c3                	mov    %eax,%ebx
  800966:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800969:	eb 06                	jmp    800971 <strncmp+0x17>
		n--, p++, q++;
  80096b:	83 c0 01             	add    $0x1,%eax
  80096e:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800971:	39 d8                	cmp    %ebx,%eax
  800973:	74 15                	je     80098a <strncmp+0x30>
  800975:	0f b6 08             	movzbl (%eax),%ecx
  800978:	84 c9                	test   %cl,%cl
  80097a:	74 04                	je     800980 <strncmp+0x26>
  80097c:	3a 0a                	cmp    (%edx),%cl
  80097e:	74 eb                	je     80096b <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800980:	0f b6 00             	movzbl (%eax),%eax
  800983:	0f b6 12             	movzbl (%edx),%edx
  800986:	29 d0                	sub    %edx,%eax
  800988:	eb 05                	jmp    80098f <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  80098a:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  80098f:	5b                   	pop    %ebx
  800990:	5d                   	pop    %ebp
  800991:	c3                   	ret    

00800992 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80099c:	eb 07                	jmp    8009a5 <strchr+0x13>
		if (*s == c)
  80099e:	38 ca                	cmp    %cl,%dl
  8009a0:	74 0f                	je     8009b1 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009a2:	83 c0 01             	add    $0x1,%eax
  8009a5:	0f b6 10             	movzbl (%eax),%edx
  8009a8:	84 d2                	test   %dl,%dl
  8009aa:	75 f2                	jne    80099e <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8009ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009b1:	5d                   	pop    %ebp
  8009b2:	c3                   	ret    

008009b3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009b3:	55                   	push   %ebp
  8009b4:	89 e5                	mov    %esp,%ebp
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009bd:	eb 03                	jmp    8009c2 <strfind+0xf>
  8009bf:	83 c0 01             	add    $0x1,%eax
  8009c2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009c5:	38 ca                	cmp    %cl,%dl
  8009c7:	74 04                	je     8009cd <strfind+0x1a>
  8009c9:	84 d2                	test   %dl,%dl
  8009cb:	75 f2                	jne    8009bf <strfind+0xc>
			break;
	return (char *) s;
}
  8009cd:	5d                   	pop    %ebp
  8009ce:	c3                   	ret    

008009cf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
  8009d2:	57                   	push   %edi
  8009d3:	56                   	push   %esi
  8009d4:	53                   	push   %ebx
  8009d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8009d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  8009db:	85 c9                	test   %ecx,%ecx
  8009dd:	74 37                	je     800a16 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009df:	f6 c2 03             	test   $0x3,%dl
  8009e2:	75 2a                	jne    800a0e <memset+0x3f>
  8009e4:	f6 c1 03             	test   $0x3,%cl
  8009e7:	75 25                	jne    800a0e <memset+0x3f>
		c &= 0xFF;
  8009e9:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009ed:	89 df                	mov    %ebx,%edi
  8009ef:	c1 e7 08             	shl    $0x8,%edi
  8009f2:	89 de                	mov    %ebx,%esi
  8009f4:	c1 e6 18             	shl    $0x18,%esi
  8009f7:	89 d8                	mov    %ebx,%eax
  8009f9:	c1 e0 10             	shl    $0x10,%eax
  8009fc:	09 f0                	or     %esi,%eax
  8009fe:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800a00:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a03:	89 f8                	mov    %edi,%eax
  800a05:	09 d8                	or     %ebx,%eax
  800a07:	89 d7                	mov    %edx,%edi
  800a09:	fc                   	cld    
  800a0a:	f3 ab                	rep stos %eax,%es:(%edi)
  800a0c:	eb 08                	jmp    800a16 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a0e:	89 d7                	mov    %edx,%edi
  800a10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a13:	fc                   	cld    
  800a14:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800a16:	89 d0                	mov    %edx,%eax
  800a18:	5b                   	pop    %ebx
  800a19:	5e                   	pop    %esi
  800a1a:	5f                   	pop    %edi
  800a1b:	5d                   	pop    %ebp
  800a1c:	c3                   	ret    

00800a1d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a1d:	55                   	push   %ebp
  800a1e:	89 e5                	mov    %esp,%ebp
  800a20:	57                   	push   %edi
  800a21:	56                   	push   %esi
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a28:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a2b:	39 c6                	cmp    %eax,%esi
  800a2d:	73 35                	jae    800a64 <memmove+0x47>
  800a2f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a32:	39 d0                	cmp    %edx,%eax
  800a34:	73 2e                	jae    800a64 <memmove+0x47>
		s += n;
		d += n;
  800a36:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a39:	89 d6                	mov    %edx,%esi
  800a3b:	09 fe                	or     %edi,%esi
  800a3d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a43:	75 13                	jne    800a58 <memmove+0x3b>
  800a45:	f6 c1 03             	test   $0x3,%cl
  800a48:	75 0e                	jne    800a58 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  800a4a:	83 ef 04             	sub    $0x4,%edi
  800a4d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a50:	c1 e9 02             	shr    $0x2,%ecx
  800a53:	fd                   	std    
  800a54:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a56:	eb 09                	jmp    800a61 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a58:	83 ef 01             	sub    $0x1,%edi
  800a5b:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a5e:	fd                   	std    
  800a5f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a61:	fc                   	cld    
  800a62:	eb 1d                	jmp    800a81 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a64:	89 f2                	mov    %esi,%edx
  800a66:	09 c2                	or     %eax,%edx
  800a68:	f6 c2 03             	test   $0x3,%dl
  800a6b:	75 0f                	jne    800a7c <memmove+0x5f>
  800a6d:	f6 c1 03             	test   $0x3,%cl
  800a70:	75 0a                	jne    800a7c <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  800a72:	c1 e9 02             	shr    $0x2,%ecx
  800a75:	89 c7                	mov    %eax,%edi
  800a77:	fc                   	cld    
  800a78:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a7a:	eb 05                	jmp    800a81 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a7c:	89 c7                	mov    %eax,%edi
  800a7e:	fc                   	cld    
  800a7f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a81:	5e                   	pop    %esi
  800a82:	5f                   	pop    %edi
  800a83:	5d                   	pop    %ebp
  800a84:	c3                   	ret    

00800a85 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a88:	ff 75 10             	pushl  0x10(%ebp)
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	ff 75 08             	pushl  0x8(%ebp)
  800a91:	e8 87 ff ff ff       	call   800a1d <memmove>
}
  800a96:	c9                   	leave  
  800a97:	c3                   	ret    

00800a98 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	56                   	push   %esi
  800a9c:	53                   	push   %ebx
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa3:	89 c6                	mov    %eax,%esi
  800aa5:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aa8:	eb 1a                	jmp    800ac4 <memcmp+0x2c>
		if (*s1 != *s2)
  800aaa:	0f b6 08             	movzbl (%eax),%ecx
  800aad:	0f b6 1a             	movzbl (%edx),%ebx
  800ab0:	38 d9                	cmp    %bl,%cl
  800ab2:	74 0a                	je     800abe <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800ab4:	0f b6 c1             	movzbl %cl,%eax
  800ab7:	0f b6 db             	movzbl %bl,%ebx
  800aba:	29 d8                	sub    %ebx,%eax
  800abc:	eb 0f                	jmp    800acd <memcmp+0x35>
		s1++, s2++;
  800abe:	83 c0 01             	add    $0x1,%eax
  800ac1:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ac4:	39 f0                	cmp    %esi,%eax
  800ac6:	75 e2                	jne    800aaa <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ac8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800acd:	5b                   	pop    %ebx
  800ace:	5e                   	pop    %esi
  800acf:	5d                   	pop    %ebp
  800ad0:	c3                   	ret    

00800ad1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	53                   	push   %ebx
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800ad8:	89 c1                	mov    %eax,%ecx
  800ada:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  800add:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ae1:	eb 0a                	jmp    800aed <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ae3:	0f b6 10             	movzbl (%eax),%edx
  800ae6:	39 da                	cmp    %ebx,%edx
  800ae8:	74 07                	je     800af1 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800aea:	83 c0 01             	add    $0x1,%eax
  800aed:	39 c8                	cmp    %ecx,%eax
  800aef:	72 f2                	jb     800ae3 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800af1:	5b                   	pop    %ebx
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	57                   	push   %edi
  800af8:	56                   	push   %esi
  800af9:	53                   	push   %ebx
  800afa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800afd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b00:	eb 03                	jmp    800b05 <strtol+0x11>
		s++;
  800b02:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b05:	0f b6 01             	movzbl (%ecx),%eax
  800b08:	3c 20                	cmp    $0x20,%al
  800b0a:	74 f6                	je     800b02 <strtol+0xe>
  800b0c:	3c 09                	cmp    $0x9,%al
  800b0e:	74 f2                	je     800b02 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b10:	3c 2b                	cmp    $0x2b,%al
  800b12:	75 0a                	jne    800b1e <strtol+0x2a>
		s++;
  800b14:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b17:	bf 00 00 00 00       	mov    $0x0,%edi
  800b1c:	eb 11                	jmp    800b2f <strtol+0x3b>
  800b1e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b23:	3c 2d                	cmp    $0x2d,%al
  800b25:	75 08                	jne    800b2f <strtol+0x3b>
		s++, neg = 1;
  800b27:	83 c1 01             	add    $0x1,%ecx
  800b2a:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b2f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b35:	75 15                	jne    800b4c <strtol+0x58>
  800b37:	80 39 30             	cmpb   $0x30,(%ecx)
  800b3a:	75 10                	jne    800b4c <strtol+0x58>
  800b3c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b40:	75 7c                	jne    800bbe <strtol+0xca>
		s += 2, base = 16;
  800b42:	83 c1 02             	add    $0x2,%ecx
  800b45:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b4a:	eb 16                	jmp    800b62 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800b4c:	85 db                	test   %ebx,%ebx
  800b4e:	75 12                	jne    800b62 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b50:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b55:	80 39 30             	cmpb   $0x30,(%ecx)
  800b58:	75 08                	jne    800b62 <strtol+0x6e>
		s++, base = 8;
  800b5a:	83 c1 01             	add    $0x1,%ecx
  800b5d:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800b62:	b8 00 00 00 00       	mov    $0x0,%eax
  800b67:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b6a:	0f b6 11             	movzbl (%ecx),%edx
  800b6d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b70:	89 f3                	mov    %esi,%ebx
  800b72:	80 fb 09             	cmp    $0x9,%bl
  800b75:	77 08                	ja     800b7f <strtol+0x8b>
			dig = *s - '0';
  800b77:	0f be d2             	movsbl %dl,%edx
  800b7a:	83 ea 30             	sub    $0x30,%edx
  800b7d:	eb 22                	jmp    800ba1 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800b7f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b82:	89 f3                	mov    %esi,%ebx
  800b84:	80 fb 19             	cmp    $0x19,%bl
  800b87:	77 08                	ja     800b91 <strtol+0x9d>
			dig = *s - 'a' + 10;
  800b89:	0f be d2             	movsbl %dl,%edx
  800b8c:	83 ea 57             	sub    $0x57,%edx
  800b8f:	eb 10                	jmp    800ba1 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800b91:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b94:	89 f3                	mov    %esi,%ebx
  800b96:	80 fb 19             	cmp    $0x19,%bl
  800b99:	77 16                	ja     800bb1 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800b9b:	0f be d2             	movsbl %dl,%edx
  800b9e:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800ba1:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ba4:	7d 0b                	jge    800bb1 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800ba6:	83 c1 01             	add    $0x1,%ecx
  800ba9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bad:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800baf:	eb b9                	jmp    800b6a <strtol+0x76>

	if (endptr)
  800bb1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb5:	74 0d                	je     800bc4 <strtol+0xd0>
		*endptr = (char *) s;
  800bb7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bba:	89 0e                	mov    %ecx,(%esi)
  800bbc:	eb 06                	jmp    800bc4 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bbe:	85 db                	test   %ebx,%ebx
  800bc0:	74 98                	je     800b5a <strtol+0x66>
  800bc2:	eb 9e                	jmp    800b62 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800bc4:	89 c2                	mov    %eax,%edx
  800bc6:	f7 da                	neg    %edx
  800bc8:	85 ff                	test   %edi,%edi
  800bca:	0f 45 c2             	cmovne %edx,%eax
}
  800bcd:	5b                   	pop    %ebx
  800bce:	5e                   	pop    %esi
  800bcf:	5f                   	pop    %edi
  800bd0:	5d                   	pop    %ebp
  800bd1:	c3                   	ret    

00800bd2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	57                   	push   %edi
  800bd6:	56                   	push   %esi
  800bd7:	53                   	push   %ebx
  800bd8:	83 ec 1c             	sub    $0x1c,%esp
  800bdb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800bde:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800be1:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800be3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800be6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800be9:	8b 7d 10             	mov    0x10(%ebp),%edi
  800bec:	8b 75 14             	mov    0x14(%ebp),%esi
  800bef:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800bf1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bf5:	74 1d                	je     800c14 <syscall+0x42>
  800bf7:	85 c0                	test   %eax,%eax
  800bf9:	7e 19                	jle    800c14 <syscall+0x42>
  800bfb:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800bfe:	83 ec 0c             	sub    $0xc,%esp
  800c01:	50                   	push   %eax
  800c02:	52                   	push   %edx
  800c03:	68 7f 22 80 00       	push   $0x80227f
  800c08:	6a 23                	push   $0x23
  800c0a:	68 9c 22 80 00       	push   $0x80229c
  800c0f:	e8 2b f6 ff ff       	call   80023f <_panic>

	return ret;
}
  800c14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c17:	5b                   	pop    %ebx
  800c18:	5e                   	pop    %esi
  800c19:	5f                   	pop    %edi
  800c1a:	5d                   	pop    %ebp
  800c1b:	c3                   	ret    

00800c1c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800c22:	6a 00                	push   $0x0
  800c24:	6a 00                	push   $0x0
  800c26:	6a 00                	push   $0x0
  800c28:	ff 75 0c             	pushl  0xc(%ebp)
  800c2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c33:	b8 00 00 00 00       	mov    $0x0,%eax
  800c38:	e8 95 ff ff ff       	call   800bd2 <syscall>
}
  800c3d:	83 c4 10             	add    $0x10,%esp
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800c48:	6a 00                	push   $0x0
  800c4a:	6a 00                	push   $0x0
  800c4c:	6a 00                	push   $0x0
  800c4e:	6a 00                	push   $0x0
  800c50:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c55:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5a:	b8 01 00 00 00       	mov    $0x1,%eax
  800c5f:	e8 6e ff ff ff       	call   800bd2 <syscall>
}
  800c64:	c9                   	leave  
  800c65:	c3                   	ret    

00800c66 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
  800c69:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800c6c:	6a 00                	push   $0x0
  800c6e:	6a 00                	push   $0x0
  800c70:	6a 00                	push   $0x0
  800c72:	6a 00                	push   $0x0
  800c74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c77:	ba 01 00 00 00       	mov    $0x1,%edx
  800c7c:	b8 03 00 00 00       	mov    $0x3,%eax
  800c81:	e8 4c ff ff ff       	call   800bd2 <syscall>
}
  800c86:	c9                   	leave  
  800c87:	c3                   	ret    

00800c88 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800c8e:	6a 00                	push   $0x0
  800c90:	6a 00                	push   $0x0
  800c92:	6a 00                	push   $0x0
  800c94:	6a 00                	push   $0x0
  800c96:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca0:	b8 02 00 00 00       	mov    $0x2,%eax
  800ca5:	e8 28 ff ff ff       	call   800bd2 <syscall>
}
  800caa:	c9                   	leave  
  800cab:	c3                   	ret    

00800cac <sys_yield>:

void
sys_yield(void)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800cb2:	6a 00                	push   $0x0
  800cb4:	6a 00                	push   $0x0
  800cb6:	6a 00                	push   $0x0
  800cb8:	6a 00                	push   $0x0
  800cba:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cbf:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc4:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cc9:	e8 04 ff ff ff       	call   800bd2 <syscall>
}
  800cce:	83 c4 10             	add    $0x10,%esp
  800cd1:	c9                   	leave  
  800cd2:	c3                   	ret    

00800cd3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800cd9:	6a 00                	push   $0x0
  800cdb:	6a 00                	push   $0x0
  800cdd:	ff 75 10             	pushl  0x10(%ebp)
  800ce0:	ff 75 0c             	pushl  0xc(%ebp)
  800ce3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ce6:	ba 01 00 00 00       	mov    $0x1,%edx
  800ceb:	b8 04 00 00 00       	mov    $0x4,%eax
  800cf0:	e8 dd fe ff ff       	call   800bd2 <syscall>
}
  800cf5:	c9                   	leave  
  800cf6:	c3                   	ret    

00800cf7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800cfd:	ff 75 18             	pushl  0x18(%ebp)
  800d00:	ff 75 14             	pushl  0x14(%ebp)
  800d03:	ff 75 10             	pushl  0x10(%ebp)
  800d06:	ff 75 0c             	pushl  0xc(%ebp)
  800d09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d0c:	ba 01 00 00 00       	mov    $0x1,%edx
  800d11:	b8 05 00 00 00       	mov    $0x5,%eax
  800d16:	e8 b7 fe ff ff       	call   800bd2 <syscall>
}
  800d1b:	c9                   	leave  
  800d1c:	c3                   	ret    

00800d1d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800d23:	6a 00                	push   $0x0
  800d25:	6a 00                	push   $0x0
  800d27:	6a 00                	push   $0x0
  800d29:	ff 75 0c             	pushl  0xc(%ebp)
  800d2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d2f:	ba 01 00 00 00       	mov    $0x1,%edx
  800d34:	b8 06 00 00 00       	mov    $0x6,%eax
  800d39:	e8 94 fe ff ff       	call   800bd2 <syscall>
}
  800d3e:	c9                   	leave  
  800d3f:	c3                   	ret    

00800d40 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800d46:	6a 00                	push   $0x0
  800d48:	6a 00                	push   $0x0
  800d4a:	6a 00                	push   $0x0
  800d4c:	ff 75 0c             	pushl  0xc(%ebp)
  800d4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d52:	ba 01 00 00 00       	mov    $0x1,%edx
  800d57:	b8 08 00 00 00       	mov    $0x8,%eax
  800d5c:	e8 71 fe ff ff       	call   800bd2 <syscall>
}
  800d61:	c9                   	leave  
  800d62:	c3                   	ret    

00800d63 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800d69:	6a 00                	push   $0x0
  800d6b:	6a 00                	push   $0x0
  800d6d:	6a 00                	push   $0x0
  800d6f:	ff 75 0c             	pushl  0xc(%ebp)
  800d72:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d75:	ba 01 00 00 00       	mov    $0x1,%edx
  800d7a:	b8 09 00 00 00       	mov    $0x9,%eax
  800d7f:	e8 4e fe ff ff       	call   800bd2 <syscall>
}
  800d84:	c9                   	leave  
  800d85:	c3                   	ret    

00800d86 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800d8c:	6a 00                	push   $0x0
  800d8e:	6a 00                	push   $0x0
  800d90:	6a 00                	push   $0x0
  800d92:	ff 75 0c             	pushl  0xc(%ebp)
  800d95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d98:	ba 01 00 00 00       	mov    $0x1,%edx
  800d9d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800da2:	e8 2b fe ff ff       	call   800bd2 <syscall>
}
  800da7:	c9                   	leave  
  800da8:	c3                   	ret    

00800da9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800daf:	6a 00                	push   $0x0
  800db1:	ff 75 14             	pushl  0x14(%ebp)
  800db4:	ff 75 10             	pushl  0x10(%ebp)
  800db7:	ff 75 0c             	pushl  0xc(%ebp)
  800dba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc2:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dc7:	e8 06 fe ff ff       	call   800bd2 <syscall>
}
  800dcc:	c9                   	leave  
  800dcd:	c3                   	ret    

00800dce <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dce:	55                   	push   %ebp
  800dcf:	89 e5                	mov    %esp,%ebp
  800dd1:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800dd4:	6a 00                	push   $0x0
  800dd6:	6a 00                	push   $0x0
  800dd8:	6a 00                	push   $0x0
  800dda:	6a 00                	push   $0x0
  800ddc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ddf:	ba 01 00 00 00       	mov    $0x1,%edx
  800de4:	b8 0d 00 00 00       	mov    $0xd,%eax
  800de9:	e8 e4 fd ff ff       	call   800bd2 <syscall>
}
  800dee:	c9                   	leave  
  800def:	c3                   	ret    

00800df0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	05 00 00 00 30       	add    $0x30000000,%eax
  800dfb:	c1 e8 0c             	shr    $0xc,%eax
}
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    

00800e00 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  800e03:	ff 75 08             	pushl  0x8(%ebp)
  800e06:	e8 e5 ff ff ff       	call   800df0 <fd2num>
  800e0b:	83 c4 04             	add    $0x4,%esp
  800e0e:	c1 e0 0c             	shl    $0xc,%eax
  800e11:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e16:	c9                   	leave  
  800e17:	c3                   	ret    

00800e18 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e18:	55                   	push   %ebp
  800e19:	89 e5                	mov    %esp,%ebp
  800e1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e1e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e23:	89 c2                	mov    %eax,%edx
  800e25:	c1 ea 16             	shr    $0x16,%edx
  800e28:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e2f:	f6 c2 01             	test   $0x1,%dl
  800e32:	74 11                	je     800e45 <fd_alloc+0x2d>
  800e34:	89 c2                	mov    %eax,%edx
  800e36:	c1 ea 0c             	shr    $0xc,%edx
  800e39:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e40:	f6 c2 01             	test   $0x1,%dl
  800e43:	75 09                	jne    800e4e <fd_alloc+0x36>
			*fd_store = fd;
  800e45:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e47:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4c:	eb 17                	jmp    800e65 <fd_alloc+0x4d>
  800e4e:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800e53:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e58:	75 c9                	jne    800e23 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e5a:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800e60:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    

00800e67 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e6d:	83 f8 1f             	cmp    $0x1f,%eax
  800e70:	77 36                	ja     800ea8 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e72:	c1 e0 0c             	shl    $0xc,%eax
  800e75:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e7a:	89 c2                	mov    %eax,%edx
  800e7c:	c1 ea 16             	shr    $0x16,%edx
  800e7f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e86:	f6 c2 01             	test   $0x1,%dl
  800e89:	74 24                	je     800eaf <fd_lookup+0x48>
  800e8b:	89 c2                	mov    %eax,%edx
  800e8d:	c1 ea 0c             	shr    $0xc,%edx
  800e90:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e97:	f6 c2 01             	test   $0x1,%dl
  800e9a:	74 1a                	je     800eb6 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9f:	89 02                	mov    %eax,(%edx)
	return 0;
  800ea1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea6:	eb 13                	jmp    800ebb <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800ea8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ead:	eb 0c                	jmp    800ebb <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800eaf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eb4:	eb 05                	jmp    800ebb <fd_lookup+0x54>
  800eb6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800ebb:	5d                   	pop    %ebp
  800ebc:	c3                   	ret    

00800ebd <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800ebd:	55                   	push   %ebp
  800ebe:	89 e5                	mov    %esp,%ebp
  800ec0:	83 ec 08             	sub    $0x8,%esp
  800ec3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ec6:	ba 2c 23 80 00       	mov    $0x80232c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800ecb:	eb 13                	jmp    800ee0 <dev_lookup+0x23>
  800ecd:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  800ed0:	39 08                	cmp    %ecx,(%eax)
  800ed2:	75 0c                	jne    800ee0 <dev_lookup+0x23>
			*dev = devtab[i];
  800ed4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed7:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ed9:	b8 00 00 00 00       	mov    $0x0,%eax
  800ede:	eb 2e                	jmp    800f0e <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800ee0:	8b 02                	mov    (%edx),%eax
  800ee2:	85 c0                	test   %eax,%eax
  800ee4:	75 e7                	jne    800ecd <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ee6:	a1 04 40 80 00       	mov    0x804004,%eax
  800eeb:	8b 40 48             	mov    0x48(%eax),%eax
  800eee:	83 ec 04             	sub    $0x4,%esp
  800ef1:	51                   	push   %ecx
  800ef2:	50                   	push   %eax
  800ef3:	68 ac 22 80 00       	push   $0x8022ac
  800ef8:	e8 1b f4 ff ff       	call   800318 <cprintf>
	*dev = 0;
  800efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f06:	83 c4 10             	add    $0x10,%esp
  800f09:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f0e:	c9                   	leave  
  800f0f:	c3                   	ret    

00800f10 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	56                   	push   %esi
  800f14:	53                   	push   %ebx
  800f15:	83 ec 10             	sub    $0x10,%esp
  800f18:	8b 75 08             	mov    0x8(%ebp),%esi
  800f1b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f1e:	56                   	push   %esi
  800f1f:	e8 cc fe ff ff       	call   800df0 <fd2num>
  800f24:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800f27:	89 14 24             	mov    %edx,(%esp)
  800f2a:	50                   	push   %eax
  800f2b:	e8 37 ff ff ff       	call   800e67 <fd_lookup>
  800f30:	83 c4 08             	add    $0x8,%esp
  800f33:	85 c0                	test   %eax,%eax
  800f35:	78 05                	js     800f3c <fd_close+0x2c>
	    || fd != fd2)
  800f37:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800f3a:	74 0c                	je     800f48 <fd_close+0x38>
		return (must_exist ? r : 0);
  800f3c:	84 db                	test   %bl,%bl
  800f3e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f43:	0f 44 c2             	cmove  %edx,%eax
  800f46:	eb 41                	jmp    800f89 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f48:	83 ec 08             	sub    $0x8,%esp
  800f4b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800f4e:	50                   	push   %eax
  800f4f:	ff 36                	pushl  (%esi)
  800f51:	e8 67 ff ff ff       	call   800ebd <dev_lookup>
  800f56:	89 c3                	mov    %eax,%ebx
  800f58:	83 c4 10             	add    $0x10,%esp
  800f5b:	85 c0                	test   %eax,%eax
  800f5d:	78 1a                	js     800f79 <fd_close+0x69>
		if (dev->dev_close)
  800f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f62:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800f65:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800f6a:	85 c0                	test   %eax,%eax
  800f6c:	74 0b                	je     800f79 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  800f6e:	83 ec 0c             	sub    $0xc,%esp
  800f71:	56                   	push   %esi
  800f72:	ff d0                	call   *%eax
  800f74:	89 c3                	mov    %eax,%ebx
  800f76:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800f79:	83 ec 08             	sub    $0x8,%esp
  800f7c:	56                   	push   %esi
  800f7d:	6a 00                	push   $0x0
  800f7f:	e8 99 fd ff ff       	call   800d1d <sys_page_unmap>
	return r;
  800f84:	83 c4 10             	add    $0x10,%esp
  800f87:	89 d8                	mov    %ebx,%eax
}
  800f89:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f8c:	5b                   	pop    %ebx
  800f8d:	5e                   	pop    %esi
  800f8e:	5d                   	pop    %ebp
  800f8f:	c3                   	ret    

00800f90 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800f90:	55                   	push   %ebp
  800f91:	89 e5                	mov    %esp,%ebp
  800f93:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f96:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f99:	50                   	push   %eax
  800f9a:	ff 75 08             	pushl  0x8(%ebp)
  800f9d:	e8 c5 fe ff ff       	call   800e67 <fd_lookup>
  800fa2:	83 c4 08             	add    $0x8,%esp
  800fa5:	85 c0                	test   %eax,%eax
  800fa7:	78 10                	js     800fb9 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800fa9:	83 ec 08             	sub    $0x8,%esp
  800fac:	6a 01                	push   $0x1
  800fae:	ff 75 f4             	pushl  -0xc(%ebp)
  800fb1:	e8 5a ff ff ff       	call   800f10 <fd_close>
  800fb6:	83 c4 10             	add    $0x10,%esp
}
  800fb9:	c9                   	leave  
  800fba:	c3                   	ret    

00800fbb <close_all>:

void
close_all(void)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	53                   	push   %ebx
  800fbf:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fc2:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800fc7:	83 ec 0c             	sub    $0xc,%esp
  800fca:	53                   	push   %ebx
  800fcb:	e8 c0 ff ff ff       	call   800f90 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800fd0:	83 c3 01             	add    $0x1,%ebx
  800fd3:	83 c4 10             	add    $0x10,%esp
  800fd6:	83 fb 20             	cmp    $0x20,%ebx
  800fd9:	75 ec                	jne    800fc7 <close_all+0xc>
		close(i);
}
  800fdb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fde:	c9                   	leave  
  800fdf:	c3                   	ret    

00800fe0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	57                   	push   %edi
  800fe4:	56                   	push   %esi
  800fe5:	53                   	push   %ebx
  800fe6:	83 ec 2c             	sub    $0x2c,%esp
  800fe9:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800fec:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fef:	50                   	push   %eax
  800ff0:	ff 75 08             	pushl  0x8(%ebp)
  800ff3:	e8 6f fe ff ff       	call   800e67 <fd_lookup>
  800ff8:	83 c4 08             	add    $0x8,%esp
  800ffb:	85 c0                	test   %eax,%eax
  800ffd:	0f 88 c1 00 00 00    	js     8010c4 <dup+0xe4>
		return r;
	close(newfdnum);
  801003:	83 ec 0c             	sub    $0xc,%esp
  801006:	56                   	push   %esi
  801007:	e8 84 ff ff ff       	call   800f90 <close>

	newfd = INDEX2FD(newfdnum);
  80100c:	89 f3                	mov    %esi,%ebx
  80100e:	c1 e3 0c             	shl    $0xc,%ebx
  801011:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801017:	83 c4 04             	add    $0x4,%esp
  80101a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80101d:	e8 de fd ff ff       	call   800e00 <fd2data>
  801022:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  801024:	89 1c 24             	mov    %ebx,(%esp)
  801027:	e8 d4 fd ff ff       	call   800e00 <fd2data>
  80102c:	83 c4 10             	add    $0x10,%esp
  80102f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801032:	89 f8                	mov    %edi,%eax
  801034:	c1 e8 16             	shr    $0x16,%eax
  801037:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80103e:	a8 01                	test   $0x1,%al
  801040:	74 37                	je     801079 <dup+0x99>
  801042:	89 f8                	mov    %edi,%eax
  801044:	c1 e8 0c             	shr    $0xc,%eax
  801047:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80104e:	f6 c2 01             	test   $0x1,%dl
  801051:	74 26                	je     801079 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801053:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80105a:	83 ec 0c             	sub    $0xc,%esp
  80105d:	25 07 0e 00 00       	and    $0xe07,%eax
  801062:	50                   	push   %eax
  801063:	ff 75 d4             	pushl  -0x2c(%ebp)
  801066:	6a 00                	push   $0x0
  801068:	57                   	push   %edi
  801069:	6a 00                	push   $0x0
  80106b:	e8 87 fc ff ff       	call   800cf7 <sys_page_map>
  801070:	89 c7                	mov    %eax,%edi
  801072:	83 c4 20             	add    $0x20,%esp
  801075:	85 c0                	test   %eax,%eax
  801077:	78 2e                	js     8010a7 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801079:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80107c:	89 d0                	mov    %edx,%eax
  80107e:	c1 e8 0c             	shr    $0xc,%eax
  801081:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801088:	83 ec 0c             	sub    $0xc,%esp
  80108b:	25 07 0e 00 00       	and    $0xe07,%eax
  801090:	50                   	push   %eax
  801091:	53                   	push   %ebx
  801092:	6a 00                	push   $0x0
  801094:	52                   	push   %edx
  801095:	6a 00                	push   $0x0
  801097:	e8 5b fc ff ff       	call   800cf7 <sys_page_map>
  80109c:	89 c7                	mov    %eax,%edi
  80109e:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  8010a1:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010a3:	85 ff                	test   %edi,%edi
  8010a5:	79 1d                	jns    8010c4 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8010a7:	83 ec 08             	sub    $0x8,%esp
  8010aa:	53                   	push   %ebx
  8010ab:	6a 00                	push   $0x0
  8010ad:	e8 6b fc ff ff       	call   800d1d <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010b2:	83 c4 08             	add    $0x8,%esp
  8010b5:	ff 75 d4             	pushl  -0x2c(%ebp)
  8010b8:	6a 00                	push   $0x0
  8010ba:	e8 5e fc ff ff       	call   800d1d <sys_page_unmap>
	return r;
  8010bf:	83 c4 10             	add    $0x10,%esp
  8010c2:	89 f8                	mov    %edi,%eax
}
  8010c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c7:	5b                   	pop    %ebx
  8010c8:	5e                   	pop    %esi
  8010c9:	5f                   	pop    %edi
  8010ca:	5d                   	pop    %ebp
  8010cb:	c3                   	ret    

008010cc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010cc:	55                   	push   %ebp
  8010cd:	89 e5                	mov    %esp,%ebp
  8010cf:	53                   	push   %ebx
  8010d0:	83 ec 14             	sub    $0x14,%esp
  8010d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010d9:	50                   	push   %eax
  8010da:	53                   	push   %ebx
  8010db:	e8 87 fd ff ff       	call   800e67 <fd_lookup>
  8010e0:	83 c4 08             	add    $0x8,%esp
  8010e3:	89 c2                	mov    %eax,%edx
  8010e5:	85 c0                	test   %eax,%eax
  8010e7:	78 6d                	js     801156 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010e9:	83 ec 08             	sub    $0x8,%esp
  8010ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010ef:	50                   	push   %eax
  8010f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010f3:	ff 30                	pushl  (%eax)
  8010f5:	e8 c3 fd ff ff       	call   800ebd <dev_lookup>
  8010fa:	83 c4 10             	add    $0x10,%esp
  8010fd:	85 c0                	test   %eax,%eax
  8010ff:	78 4c                	js     80114d <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801101:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801104:	8b 42 08             	mov    0x8(%edx),%eax
  801107:	83 e0 03             	and    $0x3,%eax
  80110a:	83 f8 01             	cmp    $0x1,%eax
  80110d:	75 21                	jne    801130 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80110f:	a1 04 40 80 00       	mov    0x804004,%eax
  801114:	8b 40 48             	mov    0x48(%eax),%eax
  801117:	83 ec 04             	sub    $0x4,%esp
  80111a:	53                   	push   %ebx
  80111b:	50                   	push   %eax
  80111c:	68 f0 22 80 00       	push   $0x8022f0
  801121:	e8 f2 f1 ff ff       	call   800318 <cprintf>
		return -E_INVAL;
  801126:	83 c4 10             	add    $0x10,%esp
  801129:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80112e:	eb 26                	jmp    801156 <read+0x8a>
	}
	if (!dev->dev_read)
  801130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801133:	8b 40 08             	mov    0x8(%eax),%eax
  801136:	85 c0                	test   %eax,%eax
  801138:	74 17                	je     801151 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80113a:	83 ec 04             	sub    $0x4,%esp
  80113d:	ff 75 10             	pushl  0x10(%ebp)
  801140:	ff 75 0c             	pushl  0xc(%ebp)
  801143:	52                   	push   %edx
  801144:	ff d0                	call   *%eax
  801146:	89 c2                	mov    %eax,%edx
  801148:	83 c4 10             	add    $0x10,%esp
  80114b:	eb 09                	jmp    801156 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80114d:	89 c2                	mov    %eax,%edx
  80114f:	eb 05                	jmp    801156 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801151:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  801156:	89 d0                	mov    %edx,%eax
  801158:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80115b:	c9                   	leave  
  80115c:	c3                   	ret    

0080115d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
  801160:	57                   	push   %edi
  801161:	56                   	push   %esi
  801162:	53                   	push   %ebx
  801163:	83 ec 0c             	sub    $0xc,%esp
  801166:	8b 7d 08             	mov    0x8(%ebp),%edi
  801169:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80116c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801171:	eb 21                	jmp    801194 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801173:	83 ec 04             	sub    $0x4,%esp
  801176:	89 f0                	mov    %esi,%eax
  801178:	29 d8                	sub    %ebx,%eax
  80117a:	50                   	push   %eax
  80117b:	89 d8                	mov    %ebx,%eax
  80117d:	03 45 0c             	add    0xc(%ebp),%eax
  801180:	50                   	push   %eax
  801181:	57                   	push   %edi
  801182:	e8 45 ff ff ff       	call   8010cc <read>
		if (m < 0)
  801187:	83 c4 10             	add    $0x10,%esp
  80118a:	85 c0                	test   %eax,%eax
  80118c:	78 10                	js     80119e <readn+0x41>
			return m;
		if (m == 0)
  80118e:	85 c0                	test   %eax,%eax
  801190:	74 0a                	je     80119c <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801192:	01 c3                	add    %eax,%ebx
  801194:	39 f3                	cmp    %esi,%ebx
  801196:	72 db                	jb     801173 <readn+0x16>
  801198:	89 d8                	mov    %ebx,%eax
  80119a:	eb 02                	jmp    80119e <readn+0x41>
  80119c:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80119e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a1:	5b                   	pop    %ebx
  8011a2:	5e                   	pop    %esi
  8011a3:	5f                   	pop    %edi
  8011a4:	5d                   	pop    %ebp
  8011a5:	c3                   	ret    

008011a6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	53                   	push   %ebx
  8011aa:	83 ec 14             	sub    $0x14,%esp
  8011ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011b3:	50                   	push   %eax
  8011b4:	53                   	push   %ebx
  8011b5:	e8 ad fc ff ff       	call   800e67 <fd_lookup>
  8011ba:	83 c4 08             	add    $0x8,%esp
  8011bd:	89 c2                	mov    %eax,%edx
  8011bf:	85 c0                	test   %eax,%eax
  8011c1:	78 68                	js     80122b <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011c3:	83 ec 08             	sub    $0x8,%esp
  8011c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011c9:	50                   	push   %eax
  8011ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011cd:	ff 30                	pushl  (%eax)
  8011cf:	e8 e9 fc ff ff       	call   800ebd <dev_lookup>
  8011d4:	83 c4 10             	add    $0x10,%esp
  8011d7:	85 c0                	test   %eax,%eax
  8011d9:	78 47                	js     801222 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011de:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011e2:	75 21                	jne    801205 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8011e4:	a1 04 40 80 00       	mov    0x804004,%eax
  8011e9:	8b 40 48             	mov    0x48(%eax),%eax
  8011ec:	83 ec 04             	sub    $0x4,%esp
  8011ef:	53                   	push   %ebx
  8011f0:	50                   	push   %eax
  8011f1:	68 0c 23 80 00       	push   $0x80230c
  8011f6:	e8 1d f1 ff ff       	call   800318 <cprintf>
		return -E_INVAL;
  8011fb:	83 c4 10             	add    $0x10,%esp
  8011fe:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801203:	eb 26                	jmp    80122b <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801205:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801208:	8b 52 0c             	mov    0xc(%edx),%edx
  80120b:	85 d2                	test   %edx,%edx
  80120d:	74 17                	je     801226 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80120f:	83 ec 04             	sub    $0x4,%esp
  801212:	ff 75 10             	pushl  0x10(%ebp)
  801215:	ff 75 0c             	pushl  0xc(%ebp)
  801218:	50                   	push   %eax
  801219:	ff d2                	call   *%edx
  80121b:	89 c2                	mov    %eax,%edx
  80121d:	83 c4 10             	add    $0x10,%esp
  801220:	eb 09                	jmp    80122b <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801222:	89 c2                	mov    %eax,%edx
  801224:	eb 05                	jmp    80122b <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801226:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  80122b:	89 d0                	mov    %edx,%eax
  80122d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801230:	c9                   	leave  
  801231:	c3                   	ret    

00801232 <seek>:

int
seek(int fdnum, off_t offset)
{
  801232:	55                   	push   %ebp
  801233:	89 e5                	mov    %esp,%ebp
  801235:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801238:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80123b:	50                   	push   %eax
  80123c:	ff 75 08             	pushl  0x8(%ebp)
  80123f:	e8 23 fc ff ff       	call   800e67 <fd_lookup>
  801244:	83 c4 08             	add    $0x8,%esp
  801247:	85 c0                	test   %eax,%eax
  801249:	78 0e                	js     801259 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80124b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80124e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801251:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801254:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801259:	c9                   	leave  
  80125a:	c3                   	ret    

0080125b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
  80125e:	53                   	push   %ebx
  80125f:	83 ec 14             	sub    $0x14,%esp
  801262:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801265:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801268:	50                   	push   %eax
  801269:	53                   	push   %ebx
  80126a:	e8 f8 fb ff ff       	call   800e67 <fd_lookup>
  80126f:	83 c4 08             	add    $0x8,%esp
  801272:	89 c2                	mov    %eax,%edx
  801274:	85 c0                	test   %eax,%eax
  801276:	78 65                	js     8012dd <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801278:	83 ec 08             	sub    $0x8,%esp
  80127b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80127e:	50                   	push   %eax
  80127f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801282:	ff 30                	pushl  (%eax)
  801284:	e8 34 fc ff ff       	call   800ebd <dev_lookup>
  801289:	83 c4 10             	add    $0x10,%esp
  80128c:	85 c0                	test   %eax,%eax
  80128e:	78 44                	js     8012d4 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801290:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801293:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801297:	75 21                	jne    8012ba <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801299:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80129e:	8b 40 48             	mov    0x48(%eax),%eax
  8012a1:	83 ec 04             	sub    $0x4,%esp
  8012a4:	53                   	push   %ebx
  8012a5:	50                   	push   %eax
  8012a6:	68 cc 22 80 00       	push   $0x8022cc
  8012ab:	e8 68 f0 ff ff       	call   800318 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8012b0:	83 c4 10             	add    $0x10,%esp
  8012b3:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8012b8:	eb 23                	jmp    8012dd <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  8012ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012bd:	8b 52 18             	mov    0x18(%edx),%edx
  8012c0:	85 d2                	test   %edx,%edx
  8012c2:	74 14                	je     8012d8 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012c4:	83 ec 08             	sub    $0x8,%esp
  8012c7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ca:	50                   	push   %eax
  8012cb:	ff d2                	call   *%edx
  8012cd:	89 c2                	mov    %eax,%edx
  8012cf:	83 c4 10             	add    $0x10,%esp
  8012d2:	eb 09                	jmp    8012dd <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012d4:	89 c2                	mov    %eax,%edx
  8012d6:	eb 05                	jmp    8012dd <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8012d8:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  8012dd:	89 d0                	mov    %edx,%eax
  8012df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012e2:	c9                   	leave  
  8012e3:	c3                   	ret    

008012e4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
  8012e7:	53                   	push   %ebx
  8012e8:	83 ec 14             	sub    $0x14,%esp
  8012eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f1:	50                   	push   %eax
  8012f2:	ff 75 08             	pushl  0x8(%ebp)
  8012f5:	e8 6d fb ff ff       	call   800e67 <fd_lookup>
  8012fa:	83 c4 08             	add    $0x8,%esp
  8012fd:	89 c2                	mov    %eax,%edx
  8012ff:	85 c0                	test   %eax,%eax
  801301:	78 58                	js     80135b <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801303:	83 ec 08             	sub    $0x8,%esp
  801306:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801309:	50                   	push   %eax
  80130a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80130d:	ff 30                	pushl  (%eax)
  80130f:	e8 a9 fb ff ff       	call   800ebd <dev_lookup>
  801314:	83 c4 10             	add    $0x10,%esp
  801317:	85 c0                	test   %eax,%eax
  801319:	78 37                	js     801352 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  80131b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80131e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801322:	74 32                	je     801356 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801324:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801327:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80132e:	00 00 00 
	stat->st_isdir = 0;
  801331:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801338:	00 00 00 
	stat->st_dev = dev;
  80133b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801341:	83 ec 08             	sub    $0x8,%esp
  801344:	53                   	push   %ebx
  801345:	ff 75 f0             	pushl  -0x10(%ebp)
  801348:	ff 50 14             	call   *0x14(%eax)
  80134b:	89 c2                	mov    %eax,%edx
  80134d:	83 c4 10             	add    $0x10,%esp
  801350:	eb 09                	jmp    80135b <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801352:	89 c2                	mov    %eax,%edx
  801354:	eb 05                	jmp    80135b <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801356:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80135b:	89 d0                	mov    %edx,%eax
  80135d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801360:	c9                   	leave  
  801361:	c3                   	ret    

00801362 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
  801365:	56                   	push   %esi
  801366:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801367:	83 ec 08             	sub    $0x8,%esp
  80136a:	6a 00                	push   $0x0
  80136c:	ff 75 08             	pushl  0x8(%ebp)
  80136f:	e8 06 02 00 00       	call   80157a <open>
  801374:	89 c3                	mov    %eax,%ebx
  801376:	83 c4 10             	add    $0x10,%esp
  801379:	85 c0                	test   %eax,%eax
  80137b:	78 1b                	js     801398 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80137d:	83 ec 08             	sub    $0x8,%esp
  801380:	ff 75 0c             	pushl  0xc(%ebp)
  801383:	50                   	push   %eax
  801384:	e8 5b ff ff ff       	call   8012e4 <fstat>
  801389:	89 c6                	mov    %eax,%esi
	close(fd);
  80138b:	89 1c 24             	mov    %ebx,(%esp)
  80138e:	e8 fd fb ff ff       	call   800f90 <close>
	return r;
  801393:	83 c4 10             	add    $0x10,%esp
  801396:	89 f0                	mov    %esi,%eax
}
  801398:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80139b:	5b                   	pop    %ebx
  80139c:	5e                   	pop    %esi
  80139d:	5d                   	pop    %ebp
  80139e:	c3                   	ret    

0080139f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
  8013a2:	56                   	push   %esi
  8013a3:	53                   	push   %ebx
  8013a4:	89 c6                	mov    %eax,%esi
  8013a6:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013a8:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013af:	75 12                	jne    8013c3 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8013b1:	83 ec 0c             	sub    $0xc,%esp
  8013b4:	6a 01                	push   $0x1
  8013b6:	e8 01 08 00 00       	call   801bbc <ipc_find_env>
  8013bb:	a3 00 40 80 00       	mov    %eax,0x804000
  8013c0:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013c3:	6a 07                	push   $0x7
  8013c5:	68 00 50 80 00       	push   $0x805000
  8013ca:	56                   	push   %esi
  8013cb:	ff 35 00 40 80 00    	pushl  0x804000
  8013d1:	e8 92 07 00 00       	call   801b68 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013d6:	83 c4 0c             	add    $0xc,%esp
  8013d9:	6a 00                	push   $0x0
  8013db:	53                   	push   %ebx
  8013dc:	6a 00                	push   $0x0
  8013de:	e8 1a 07 00 00       	call   801afd <ipc_recv>
}
  8013e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013e6:	5b                   	pop    %ebx
  8013e7:	5e                   	pop    %esi
  8013e8:	5d                   	pop    %ebp
  8013e9:	c3                   	ret    

008013ea <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
  8013ed:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8013f6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8013fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fe:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801403:	ba 00 00 00 00       	mov    $0x0,%edx
  801408:	b8 02 00 00 00       	mov    $0x2,%eax
  80140d:	e8 8d ff ff ff       	call   80139f <fsipc>
}
  801412:	c9                   	leave  
  801413:	c3                   	ret    

00801414 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
  801417:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8b 40 0c             	mov    0xc(%eax),%eax
  801420:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801425:	ba 00 00 00 00       	mov    $0x0,%edx
  80142a:	b8 06 00 00 00       	mov    $0x6,%eax
  80142f:	e8 6b ff ff ff       	call   80139f <fsipc>
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	53                   	push   %ebx
  80143a:	83 ec 04             	sub    $0x4,%esp
  80143d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	8b 40 0c             	mov    0xc(%eax),%eax
  801446:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80144b:	ba 00 00 00 00       	mov    $0x0,%edx
  801450:	b8 05 00 00 00       	mov    $0x5,%eax
  801455:	e8 45 ff ff ff       	call   80139f <fsipc>
  80145a:	85 c0                	test   %eax,%eax
  80145c:	78 2c                	js     80148a <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80145e:	83 ec 08             	sub    $0x8,%esp
  801461:	68 00 50 80 00       	push   $0x805000
  801466:	53                   	push   %ebx
  801467:	e8 1e f4 ff ff       	call   80088a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80146c:	a1 80 50 80 00       	mov    0x805080,%eax
  801471:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801477:	a1 84 50 80 00       	mov    0x805084,%eax
  80147c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801482:	83 c4 10             	add    $0x10,%esp
  801485:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	83 ec 08             	sub    $0x8,%esp
  801495:	8b 55 0c             	mov    0xc(%ebp),%edx
  801498:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80149b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80149e:	8b 49 0c             	mov    0xc(%ecx),%ecx
  8014a1:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  8014a7:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8014ac:	76 22                	jbe    8014d0 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  8014ae:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  8014b5:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  8014b8:	83 ec 04             	sub    $0x4,%esp
  8014bb:	68 f8 0f 00 00       	push   $0xff8
  8014c0:	52                   	push   %edx
  8014c1:	68 08 50 80 00       	push   $0x805008
  8014c6:	e8 52 f5 ff ff       	call   800a1d <memmove>
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	eb 17                	jmp    8014e7 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  8014d0:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  8014d5:	83 ec 04             	sub    $0x4,%esp
  8014d8:	50                   	push   %eax
  8014d9:	52                   	push   %edx
  8014da:	68 08 50 80 00       	push   $0x805008
  8014df:	e8 39 f5 ff ff       	call   800a1d <memmove>
  8014e4:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  8014e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ec:	b8 04 00 00 00       	mov    $0x4,%eax
  8014f1:	e8 a9 fe ff ff       	call   80139f <fsipc>
	if (result < 0)
		return result;

	return result;
}
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	56                   	push   %esi
  8014fc:	53                   	push   %ebx
  8014fd:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801500:	8b 45 08             	mov    0x8(%ebp),%eax
  801503:	8b 40 0c             	mov    0xc(%eax),%eax
  801506:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80150b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801511:	ba 00 00 00 00       	mov    $0x0,%edx
  801516:	b8 03 00 00 00       	mov    $0x3,%eax
  80151b:	e8 7f fe ff ff       	call   80139f <fsipc>
  801520:	89 c3                	mov    %eax,%ebx
  801522:	85 c0                	test   %eax,%eax
  801524:	78 4b                	js     801571 <devfile_read+0x79>
		return r;
	assert(r <= n);
  801526:	39 c6                	cmp    %eax,%esi
  801528:	73 16                	jae    801540 <devfile_read+0x48>
  80152a:	68 3c 23 80 00       	push   $0x80233c
  80152f:	68 43 23 80 00       	push   $0x802343
  801534:	6a 7c                	push   $0x7c
  801536:	68 58 23 80 00       	push   $0x802358
  80153b:	e8 ff ec ff ff       	call   80023f <_panic>
	assert(r <= PGSIZE);
  801540:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801545:	7e 16                	jle    80155d <devfile_read+0x65>
  801547:	68 63 23 80 00       	push   $0x802363
  80154c:	68 43 23 80 00       	push   $0x802343
  801551:	6a 7d                	push   $0x7d
  801553:	68 58 23 80 00       	push   $0x802358
  801558:	e8 e2 ec ff ff       	call   80023f <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80155d:	83 ec 04             	sub    $0x4,%esp
  801560:	50                   	push   %eax
  801561:	68 00 50 80 00       	push   $0x805000
  801566:	ff 75 0c             	pushl  0xc(%ebp)
  801569:	e8 af f4 ff ff       	call   800a1d <memmove>
	return r;
  80156e:	83 c4 10             	add    $0x10,%esp
}
  801571:	89 d8                	mov    %ebx,%eax
  801573:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801576:	5b                   	pop    %ebx
  801577:	5e                   	pop    %esi
  801578:	5d                   	pop    %ebp
  801579:	c3                   	ret    

0080157a <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	53                   	push   %ebx
  80157e:	83 ec 20             	sub    $0x20,%esp
  801581:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801584:	53                   	push   %ebx
  801585:	e8 c7 f2 ff ff       	call   800851 <strlen>
  80158a:	83 c4 10             	add    $0x10,%esp
  80158d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801592:	7f 67                	jg     8015fb <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801594:	83 ec 0c             	sub    $0xc,%esp
  801597:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80159a:	50                   	push   %eax
  80159b:	e8 78 f8 ff ff       	call   800e18 <fd_alloc>
  8015a0:	83 c4 10             	add    $0x10,%esp
		return r;
  8015a3:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8015a5:	85 c0                	test   %eax,%eax
  8015a7:	78 57                	js     801600 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8015a9:	83 ec 08             	sub    $0x8,%esp
  8015ac:	53                   	push   %ebx
  8015ad:	68 00 50 80 00       	push   $0x805000
  8015b2:	e8 d3 f2 ff ff       	call   80088a <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ba:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8015c7:	e8 d3 fd ff ff       	call   80139f <fsipc>
  8015cc:	89 c3                	mov    %eax,%ebx
  8015ce:	83 c4 10             	add    $0x10,%esp
  8015d1:	85 c0                	test   %eax,%eax
  8015d3:	79 14                	jns    8015e9 <open+0x6f>
		fd_close(fd, 0);
  8015d5:	83 ec 08             	sub    $0x8,%esp
  8015d8:	6a 00                	push   $0x0
  8015da:	ff 75 f4             	pushl  -0xc(%ebp)
  8015dd:	e8 2e f9 ff ff       	call   800f10 <fd_close>
		return r;
  8015e2:	83 c4 10             	add    $0x10,%esp
  8015e5:	89 da                	mov    %ebx,%edx
  8015e7:	eb 17                	jmp    801600 <open+0x86>
	}

	return fd2num(fd);
  8015e9:	83 ec 0c             	sub    $0xc,%esp
  8015ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8015ef:	e8 fc f7 ff ff       	call   800df0 <fd2num>
  8015f4:	89 c2                	mov    %eax,%edx
  8015f6:	83 c4 10             	add    $0x10,%esp
  8015f9:	eb 05                	jmp    801600 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8015fb:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801600:	89 d0                	mov    %edx,%eax
  801602:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80160d:	ba 00 00 00 00       	mov    $0x0,%edx
  801612:	b8 08 00 00 00       	mov    $0x8,%eax
  801617:	e8 83 fd ff ff       	call   80139f <fsipc>
}
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	56                   	push   %esi
  801622:	53                   	push   %ebx
  801623:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801626:	83 ec 0c             	sub    $0xc,%esp
  801629:	ff 75 08             	pushl  0x8(%ebp)
  80162c:	e8 cf f7 ff ff       	call   800e00 <fd2data>
  801631:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801633:	83 c4 08             	add    $0x8,%esp
  801636:	68 6f 23 80 00       	push   $0x80236f
  80163b:	53                   	push   %ebx
  80163c:	e8 49 f2 ff ff       	call   80088a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801641:	8b 46 04             	mov    0x4(%esi),%eax
  801644:	2b 06                	sub    (%esi),%eax
  801646:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80164c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801653:	00 00 00 
	stat->st_dev = &devpipe;
  801656:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80165d:	30 80 00 
	return 0;
}
  801660:	b8 00 00 00 00       	mov    $0x0,%eax
  801665:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801668:	5b                   	pop    %ebx
  801669:	5e                   	pop    %esi
  80166a:	5d                   	pop    %ebp
  80166b:	c3                   	ret    

0080166c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	53                   	push   %ebx
  801670:	83 ec 0c             	sub    $0xc,%esp
  801673:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801676:	53                   	push   %ebx
  801677:	6a 00                	push   $0x0
  801679:	e8 9f f6 ff ff       	call   800d1d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80167e:	89 1c 24             	mov    %ebx,(%esp)
  801681:	e8 7a f7 ff ff       	call   800e00 <fd2data>
  801686:	83 c4 08             	add    $0x8,%esp
  801689:	50                   	push   %eax
  80168a:	6a 00                	push   $0x0
  80168c:	e8 8c f6 ff ff       	call   800d1d <sys_page_unmap>
}
  801691:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801694:	c9                   	leave  
  801695:	c3                   	ret    

00801696 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	57                   	push   %edi
  80169a:	56                   	push   %esi
  80169b:	53                   	push   %ebx
  80169c:	83 ec 1c             	sub    $0x1c,%esp
  80169f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8016a2:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8016a4:	a1 04 40 80 00       	mov    0x804004,%eax
  8016a9:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  8016ac:	83 ec 0c             	sub    $0xc,%esp
  8016af:	ff 75 e0             	pushl  -0x20(%ebp)
  8016b2:	e8 3e 05 00 00       	call   801bf5 <pageref>
  8016b7:	89 c3                	mov    %eax,%ebx
  8016b9:	89 3c 24             	mov    %edi,(%esp)
  8016bc:	e8 34 05 00 00       	call   801bf5 <pageref>
  8016c1:	83 c4 10             	add    $0x10,%esp
  8016c4:	39 c3                	cmp    %eax,%ebx
  8016c6:	0f 94 c1             	sete   %cl
  8016c9:	0f b6 c9             	movzbl %cl,%ecx
  8016cc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  8016cf:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8016d5:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8016d8:	39 ce                	cmp    %ecx,%esi
  8016da:	74 1b                	je     8016f7 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8016dc:	39 c3                	cmp    %eax,%ebx
  8016de:	75 c4                	jne    8016a4 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8016e0:	8b 42 58             	mov    0x58(%edx),%eax
  8016e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016e6:	50                   	push   %eax
  8016e7:	56                   	push   %esi
  8016e8:	68 76 23 80 00       	push   $0x802376
  8016ed:	e8 26 ec ff ff       	call   800318 <cprintf>
  8016f2:	83 c4 10             	add    $0x10,%esp
  8016f5:	eb ad                	jmp    8016a4 <_pipeisclosed+0xe>
	}
}
  8016f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016fd:	5b                   	pop    %ebx
  8016fe:	5e                   	pop    %esi
  8016ff:	5f                   	pop    %edi
  801700:	5d                   	pop    %ebp
  801701:	c3                   	ret    

00801702 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
  801705:	57                   	push   %edi
  801706:	56                   	push   %esi
  801707:	53                   	push   %ebx
  801708:	83 ec 28             	sub    $0x28,%esp
  80170b:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80170e:	56                   	push   %esi
  80170f:	e8 ec f6 ff ff       	call   800e00 <fd2data>
  801714:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801716:	83 c4 10             	add    $0x10,%esp
  801719:	bf 00 00 00 00       	mov    $0x0,%edi
  80171e:	eb 4b                	jmp    80176b <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801720:	89 da                	mov    %ebx,%edx
  801722:	89 f0                	mov    %esi,%eax
  801724:	e8 6d ff ff ff       	call   801696 <_pipeisclosed>
  801729:	85 c0                	test   %eax,%eax
  80172b:	75 48                	jne    801775 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80172d:	e8 7a f5 ff ff       	call   800cac <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801732:	8b 43 04             	mov    0x4(%ebx),%eax
  801735:	8b 0b                	mov    (%ebx),%ecx
  801737:	8d 51 20             	lea    0x20(%ecx),%edx
  80173a:	39 d0                	cmp    %edx,%eax
  80173c:	73 e2                	jae    801720 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80173e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801741:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801745:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801748:	89 c2                	mov    %eax,%edx
  80174a:	c1 fa 1f             	sar    $0x1f,%edx
  80174d:	89 d1                	mov    %edx,%ecx
  80174f:	c1 e9 1b             	shr    $0x1b,%ecx
  801752:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801755:	83 e2 1f             	and    $0x1f,%edx
  801758:	29 ca                	sub    %ecx,%edx
  80175a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80175e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801762:	83 c0 01             	add    $0x1,%eax
  801765:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801768:	83 c7 01             	add    $0x1,%edi
  80176b:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80176e:	75 c2                	jne    801732 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801770:	8b 45 10             	mov    0x10(%ebp),%eax
  801773:	eb 05                	jmp    80177a <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801775:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80177a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80177d:	5b                   	pop    %ebx
  80177e:	5e                   	pop    %esi
  80177f:	5f                   	pop    %edi
  801780:	5d                   	pop    %ebp
  801781:	c3                   	ret    

00801782 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	57                   	push   %edi
  801786:	56                   	push   %esi
  801787:	53                   	push   %ebx
  801788:	83 ec 18             	sub    $0x18,%esp
  80178b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80178e:	57                   	push   %edi
  80178f:	e8 6c f6 ff ff       	call   800e00 <fd2data>
  801794:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801796:	83 c4 10             	add    $0x10,%esp
  801799:	bb 00 00 00 00       	mov    $0x0,%ebx
  80179e:	eb 3d                	jmp    8017dd <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8017a0:	85 db                	test   %ebx,%ebx
  8017a2:	74 04                	je     8017a8 <devpipe_read+0x26>
				return i;
  8017a4:	89 d8                	mov    %ebx,%eax
  8017a6:	eb 44                	jmp    8017ec <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8017a8:	89 f2                	mov    %esi,%edx
  8017aa:	89 f8                	mov    %edi,%eax
  8017ac:	e8 e5 fe ff ff       	call   801696 <_pipeisclosed>
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	75 32                	jne    8017e7 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8017b5:	e8 f2 f4 ff ff       	call   800cac <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8017ba:	8b 06                	mov    (%esi),%eax
  8017bc:	3b 46 04             	cmp    0x4(%esi),%eax
  8017bf:	74 df                	je     8017a0 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8017c1:	99                   	cltd   
  8017c2:	c1 ea 1b             	shr    $0x1b,%edx
  8017c5:	01 d0                	add    %edx,%eax
  8017c7:	83 e0 1f             	and    $0x1f,%eax
  8017ca:	29 d0                	sub    %edx,%eax
  8017cc:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  8017d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017d4:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  8017d7:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8017da:	83 c3 01             	add    $0x1,%ebx
  8017dd:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8017e0:	75 d8                	jne    8017ba <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8017e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e5:	eb 05                	jmp    8017ec <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8017e7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8017ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017ef:	5b                   	pop    %ebx
  8017f0:	5e                   	pop    %esi
  8017f1:	5f                   	pop    %edi
  8017f2:	5d                   	pop    %ebp
  8017f3:	c3                   	ret    

008017f4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
  8017f7:	56                   	push   %esi
  8017f8:	53                   	push   %ebx
  8017f9:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8017fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ff:	50                   	push   %eax
  801800:	e8 13 f6 ff ff       	call   800e18 <fd_alloc>
  801805:	83 c4 10             	add    $0x10,%esp
  801808:	89 c2                	mov    %eax,%edx
  80180a:	85 c0                	test   %eax,%eax
  80180c:	0f 88 2c 01 00 00    	js     80193e <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801812:	83 ec 04             	sub    $0x4,%esp
  801815:	68 07 04 00 00       	push   $0x407
  80181a:	ff 75 f4             	pushl  -0xc(%ebp)
  80181d:	6a 00                	push   $0x0
  80181f:	e8 af f4 ff ff       	call   800cd3 <sys_page_alloc>
  801824:	83 c4 10             	add    $0x10,%esp
  801827:	89 c2                	mov    %eax,%edx
  801829:	85 c0                	test   %eax,%eax
  80182b:	0f 88 0d 01 00 00    	js     80193e <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801831:	83 ec 0c             	sub    $0xc,%esp
  801834:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801837:	50                   	push   %eax
  801838:	e8 db f5 ff ff       	call   800e18 <fd_alloc>
  80183d:	89 c3                	mov    %eax,%ebx
  80183f:	83 c4 10             	add    $0x10,%esp
  801842:	85 c0                	test   %eax,%eax
  801844:	0f 88 e2 00 00 00    	js     80192c <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80184a:	83 ec 04             	sub    $0x4,%esp
  80184d:	68 07 04 00 00       	push   $0x407
  801852:	ff 75 f0             	pushl  -0x10(%ebp)
  801855:	6a 00                	push   $0x0
  801857:	e8 77 f4 ff ff       	call   800cd3 <sys_page_alloc>
  80185c:	89 c3                	mov    %eax,%ebx
  80185e:	83 c4 10             	add    $0x10,%esp
  801861:	85 c0                	test   %eax,%eax
  801863:	0f 88 c3 00 00 00    	js     80192c <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801869:	83 ec 0c             	sub    $0xc,%esp
  80186c:	ff 75 f4             	pushl  -0xc(%ebp)
  80186f:	e8 8c f5 ff ff       	call   800e00 <fd2data>
  801874:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801876:	83 c4 0c             	add    $0xc,%esp
  801879:	68 07 04 00 00       	push   $0x407
  80187e:	50                   	push   %eax
  80187f:	6a 00                	push   $0x0
  801881:	e8 4d f4 ff ff       	call   800cd3 <sys_page_alloc>
  801886:	89 c3                	mov    %eax,%ebx
  801888:	83 c4 10             	add    $0x10,%esp
  80188b:	85 c0                	test   %eax,%eax
  80188d:	0f 88 89 00 00 00    	js     80191c <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801893:	83 ec 0c             	sub    $0xc,%esp
  801896:	ff 75 f0             	pushl  -0x10(%ebp)
  801899:	e8 62 f5 ff ff       	call   800e00 <fd2data>
  80189e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8018a5:	50                   	push   %eax
  8018a6:	6a 00                	push   $0x0
  8018a8:	56                   	push   %esi
  8018a9:	6a 00                	push   $0x0
  8018ab:	e8 47 f4 ff ff       	call   800cf7 <sys_page_map>
  8018b0:	89 c3                	mov    %eax,%ebx
  8018b2:	83 c4 20             	add    $0x20,%esp
  8018b5:	85 c0                	test   %eax,%eax
  8018b7:	78 55                	js     80190e <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8018b9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8018c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8018ce:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8018d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018dc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8018e3:	83 ec 0c             	sub    $0xc,%esp
  8018e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e9:	e8 02 f5 ff ff       	call   800df0 <fd2num>
  8018ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018f1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8018f3:	83 c4 04             	add    $0x4,%esp
  8018f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8018f9:	e8 f2 f4 ff ff       	call   800df0 <fd2num>
  8018fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801901:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801904:	83 c4 10             	add    $0x10,%esp
  801907:	ba 00 00 00 00       	mov    $0x0,%edx
  80190c:	eb 30                	jmp    80193e <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  80190e:	83 ec 08             	sub    $0x8,%esp
  801911:	56                   	push   %esi
  801912:	6a 00                	push   $0x0
  801914:	e8 04 f4 ff ff       	call   800d1d <sys_page_unmap>
  801919:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  80191c:	83 ec 08             	sub    $0x8,%esp
  80191f:	ff 75 f0             	pushl  -0x10(%ebp)
  801922:	6a 00                	push   $0x0
  801924:	e8 f4 f3 ff ff       	call   800d1d <sys_page_unmap>
  801929:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  80192c:	83 ec 08             	sub    $0x8,%esp
  80192f:	ff 75 f4             	pushl  -0xc(%ebp)
  801932:	6a 00                	push   $0x0
  801934:	e8 e4 f3 ff ff       	call   800d1d <sys_page_unmap>
  801939:	83 c4 10             	add    $0x10,%esp
  80193c:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  80193e:	89 d0                	mov    %edx,%eax
  801940:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801943:	5b                   	pop    %ebx
  801944:	5e                   	pop    %esi
  801945:	5d                   	pop    %ebp
  801946:	c3                   	ret    

00801947 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80194d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801950:	50                   	push   %eax
  801951:	ff 75 08             	pushl  0x8(%ebp)
  801954:	e8 0e f5 ff ff       	call   800e67 <fd_lookup>
  801959:	83 c4 10             	add    $0x10,%esp
  80195c:	85 c0                	test   %eax,%eax
  80195e:	78 18                	js     801978 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801960:	83 ec 0c             	sub    $0xc,%esp
  801963:	ff 75 f4             	pushl  -0xc(%ebp)
  801966:	e8 95 f4 ff ff       	call   800e00 <fd2data>
	return _pipeisclosed(fd, p);
  80196b:	89 c2                	mov    %eax,%edx
  80196d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801970:	e8 21 fd ff ff       	call   801696 <_pipeisclosed>
  801975:	83 c4 10             	add    $0x10,%esp
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80197d:	b8 00 00 00 00       	mov    $0x0,%eax
  801982:	5d                   	pop    %ebp
  801983:	c3                   	ret    

00801984 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80198a:	68 8e 23 80 00       	push   $0x80238e
  80198f:	ff 75 0c             	pushl  0xc(%ebp)
  801992:	e8 f3 ee ff ff       	call   80088a <strcpy>
	return 0;
}
  801997:	b8 00 00 00 00       	mov    $0x0,%eax
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
  8019a1:	57                   	push   %edi
  8019a2:	56                   	push   %esi
  8019a3:	53                   	push   %ebx
  8019a4:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8019aa:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8019af:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8019b5:	eb 2d                	jmp    8019e4 <devcons_write+0x46>
		m = n - tot;
  8019b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8019ba:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  8019bc:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8019bf:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8019c4:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8019c7:	83 ec 04             	sub    $0x4,%esp
  8019ca:	53                   	push   %ebx
  8019cb:	03 45 0c             	add    0xc(%ebp),%eax
  8019ce:	50                   	push   %eax
  8019cf:	57                   	push   %edi
  8019d0:	e8 48 f0 ff ff       	call   800a1d <memmove>
		sys_cputs(buf, m);
  8019d5:	83 c4 08             	add    $0x8,%esp
  8019d8:	53                   	push   %ebx
  8019d9:	57                   	push   %edi
  8019da:	e8 3d f2 ff ff       	call   800c1c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8019df:	01 de                	add    %ebx,%esi
  8019e1:	83 c4 10             	add    $0x10,%esp
  8019e4:	89 f0                	mov    %esi,%eax
  8019e6:	3b 75 10             	cmp    0x10(%ebp),%esi
  8019e9:	72 cc                	jb     8019b7 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8019eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019ee:	5b                   	pop    %ebx
  8019ef:	5e                   	pop    %esi
  8019f0:	5f                   	pop    %edi
  8019f1:	5d                   	pop    %ebp
  8019f2:	c3                   	ret    

008019f3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	83 ec 08             	sub    $0x8,%esp
  8019f9:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  8019fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a02:	74 2a                	je     801a2e <devcons_read+0x3b>
  801a04:	eb 05                	jmp    801a0b <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801a06:	e8 a1 f2 ff ff       	call   800cac <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801a0b:	e8 32 f2 ff ff       	call   800c42 <sys_cgetc>
  801a10:	85 c0                	test   %eax,%eax
  801a12:	74 f2                	je     801a06 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801a14:	85 c0                	test   %eax,%eax
  801a16:	78 16                	js     801a2e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801a18:	83 f8 04             	cmp    $0x4,%eax
  801a1b:	74 0c                	je     801a29 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801a1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a20:	88 02                	mov    %al,(%edx)
	return 1;
  801a22:	b8 01 00 00 00       	mov    $0x1,%eax
  801a27:	eb 05                	jmp    801a2e <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801a29:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801a3c:	6a 01                	push   $0x1
  801a3e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a41:	50                   	push   %eax
  801a42:	e8 d5 f1 ff ff       	call   800c1c <sys_cputs>
}
  801a47:	83 c4 10             	add    $0x10,%esp
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <getchar>:

int
getchar(void)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801a52:	6a 01                	push   $0x1
  801a54:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a57:	50                   	push   %eax
  801a58:	6a 00                	push   $0x0
  801a5a:	e8 6d f6 ff ff       	call   8010cc <read>
	if (r < 0)
  801a5f:	83 c4 10             	add    $0x10,%esp
  801a62:	85 c0                	test   %eax,%eax
  801a64:	78 0f                	js     801a75 <getchar+0x29>
		return r;
	if (r < 1)
  801a66:	85 c0                	test   %eax,%eax
  801a68:	7e 06                	jle    801a70 <getchar+0x24>
		return -E_EOF;
	return c;
  801a6a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801a6e:	eb 05                	jmp    801a75 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801a70:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
  801a7a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a7d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a80:	50                   	push   %eax
  801a81:	ff 75 08             	pushl  0x8(%ebp)
  801a84:	e8 de f3 ff ff       	call   800e67 <fd_lookup>
  801a89:	83 c4 10             	add    $0x10,%esp
  801a8c:	85 c0                	test   %eax,%eax
  801a8e:	78 11                	js     801aa1 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a93:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a99:	39 10                	cmp    %edx,(%eax)
  801a9b:	0f 94 c0             	sete   %al
  801a9e:	0f b6 c0             	movzbl %al,%eax
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <opencons>:

int
opencons(void)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801aa9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aac:	50                   	push   %eax
  801aad:	e8 66 f3 ff ff       	call   800e18 <fd_alloc>
  801ab2:	83 c4 10             	add    $0x10,%esp
		return r;
  801ab5:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801ab7:	85 c0                	test   %eax,%eax
  801ab9:	78 3e                	js     801af9 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801abb:	83 ec 04             	sub    $0x4,%esp
  801abe:	68 07 04 00 00       	push   $0x407
  801ac3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ac6:	6a 00                	push   $0x0
  801ac8:	e8 06 f2 ff ff       	call   800cd3 <sys_page_alloc>
  801acd:	83 c4 10             	add    $0x10,%esp
		return r;
  801ad0:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	78 23                	js     801af9 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801ad6:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801adf:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801aeb:	83 ec 0c             	sub    $0xc,%esp
  801aee:	50                   	push   %eax
  801aef:	e8 fc f2 ff ff       	call   800df0 <fd2num>
  801af4:	89 c2                	mov    %eax,%edx
  801af6:	83 c4 10             	add    $0x10,%esp
}
  801af9:	89 d0                	mov    %edx,%eax
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
  801b00:	56                   	push   %esi
  801b01:	53                   	push   %ebx
  801b02:	8b 75 08             	mov    0x8(%ebp),%esi
  801b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b08:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801b0b:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801b0d:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801b12:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801b15:	83 ec 0c             	sub    $0xc,%esp
  801b18:	50                   	push   %eax
  801b19:	e8 b0 f2 ff ff       	call   800dce <sys_ipc_recv>
	if (from_env_store)
  801b1e:	83 c4 10             	add    $0x10,%esp
  801b21:	85 f6                	test   %esi,%esi
  801b23:	74 0b                	je     801b30 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801b25:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b2b:	8b 52 74             	mov    0x74(%edx),%edx
  801b2e:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801b30:	85 db                	test   %ebx,%ebx
  801b32:	74 0b                	je     801b3f <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  801b34:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b3a:	8b 52 78             	mov    0x78(%edx),%edx
  801b3d:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  801b3f:	85 c0                	test   %eax,%eax
  801b41:	79 16                	jns    801b59 <ipc_recv+0x5c>
		if (from_env_store)
  801b43:	85 f6                	test   %esi,%esi
  801b45:	74 06                	je     801b4d <ipc_recv+0x50>
			*from_env_store = 0;
  801b47:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  801b4d:	85 db                	test   %ebx,%ebx
  801b4f:	74 10                	je     801b61 <ipc_recv+0x64>
			*perm_store = 0;
  801b51:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801b57:	eb 08                	jmp    801b61 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  801b59:	a1 04 40 80 00       	mov    0x804004,%eax
  801b5e:	8b 40 70             	mov    0x70(%eax),%eax
}
  801b61:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b64:	5b                   	pop    %ebx
  801b65:	5e                   	pop    %esi
  801b66:	5d                   	pop    %ebp
  801b67:	c3                   	ret    

00801b68 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	57                   	push   %edi
  801b6c:	56                   	push   %esi
  801b6d:	53                   	push   %ebx
  801b6e:	83 ec 0c             	sub    $0xc,%esp
  801b71:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b74:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b77:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  801b7a:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  801b7c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801b81:	0f 44 d8             	cmove  %eax,%ebx
  801b84:	eb 1c                	jmp    801ba2 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  801b86:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801b89:	74 12                	je     801b9d <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801b8b:	50                   	push   %eax
  801b8c:	68 9a 23 80 00       	push   $0x80239a
  801b91:	6a 42                	push   $0x42
  801b93:	68 b0 23 80 00       	push   $0x8023b0
  801b98:	e8 a2 e6 ff ff       	call   80023f <_panic>
		sys_yield();
  801b9d:	e8 0a f1 ff ff       	call   800cac <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801ba2:	ff 75 14             	pushl  0x14(%ebp)
  801ba5:	53                   	push   %ebx
  801ba6:	56                   	push   %esi
  801ba7:	57                   	push   %edi
  801ba8:	e8 fc f1 ff ff       	call   800da9 <sys_ipc_try_send>
  801bad:	83 c4 10             	add    $0x10,%esp
  801bb0:	85 c0                	test   %eax,%eax
  801bb2:	75 d2                	jne    801b86 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801bb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bb7:	5b                   	pop    %ebx
  801bb8:	5e                   	pop    %esi
  801bb9:	5f                   	pop    %edi
  801bba:	5d                   	pop    %ebp
  801bbb:	c3                   	ret    

00801bbc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
  801bbf:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801bc2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801bc7:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801bca:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801bd0:	8b 52 50             	mov    0x50(%edx),%edx
  801bd3:	39 ca                	cmp    %ecx,%edx
  801bd5:	75 0d                	jne    801be4 <ipc_find_env+0x28>
			return envs[i].env_id;
  801bd7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801bda:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801bdf:	8b 40 48             	mov    0x48(%eax),%eax
  801be2:	eb 0f                	jmp    801bf3 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801be4:	83 c0 01             	add    $0x1,%eax
  801be7:	3d 00 04 00 00       	cmp    $0x400,%eax
  801bec:	75 d9                	jne    801bc7 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801bee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf3:	5d                   	pop    %ebp
  801bf4:	c3                   	ret    

00801bf5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
  801bf8:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801bfb:	89 d0                	mov    %edx,%eax
  801bfd:	c1 e8 16             	shr    $0x16,%eax
  801c00:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801c07:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c0c:	f6 c1 01             	test   $0x1,%cl
  801c0f:	74 1d                	je     801c2e <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801c11:	c1 ea 0c             	shr    $0xc,%edx
  801c14:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801c1b:	f6 c2 01             	test   $0x1,%dl
  801c1e:	74 0e                	je     801c2e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c20:	c1 ea 0c             	shr    $0xc,%edx
  801c23:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801c2a:	ef 
  801c2b:	0f b7 c0             	movzwl %ax,%eax
}
  801c2e:	5d                   	pop    %ebp
  801c2f:	c3                   	ret    

00801c30 <__udivdi3>:
  801c30:	55                   	push   %ebp
  801c31:	57                   	push   %edi
  801c32:	56                   	push   %esi
  801c33:	53                   	push   %ebx
  801c34:	83 ec 1c             	sub    $0x1c,%esp
  801c37:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c3b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c3f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c47:	85 f6                	test   %esi,%esi
  801c49:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c4d:	89 ca                	mov    %ecx,%edx
  801c4f:	89 f8                	mov    %edi,%eax
  801c51:	75 3d                	jne    801c90 <__udivdi3+0x60>
  801c53:	39 cf                	cmp    %ecx,%edi
  801c55:	0f 87 c5 00 00 00    	ja     801d20 <__udivdi3+0xf0>
  801c5b:	85 ff                	test   %edi,%edi
  801c5d:	89 fd                	mov    %edi,%ebp
  801c5f:	75 0b                	jne    801c6c <__udivdi3+0x3c>
  801c61:	b8 01 00 00 00       	mov    $0x1,%eax
  801c66:	31 d2                	xor    %edx,%edx
  801c68:	f7 f7                	div    %edi
  801c6a:	89 c5                	mov    %eax,%ebp
  801c6c:	89 c8                	mov    %ecx,%eax
  801c6e:	31 d2                	xor    %edx,%edx
  801c70:	f7 f5                	div    %ebp
  801c72:	89 c1                	mov    %eax,%ecx
  801c74:	89 d8                	mov    %ebx,%eax
  801c76:	89 cf                	mov    %ecx,%edi
  801c78:	f7 f5                	div    %ebp
  801c7a:	89 c3                	mov    %eax,%ebx
  801c7c:	89 d8                	mov    %ebx,%eax
  801c7e:	89 fa                	mov    %edi,%edx
  801c80:	83 c4 1c             	add    $0x1c,%esp
  801c83:	5b                   	pop    %ebx
  801c84:	5e                   	pop    %esi
  801c85:	5f                   	pop    %edi
  801c86:	5d                   	pop    %ebp
  801c87:	c3                   	ret    
  801c88:	90                   	nop
  801c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c90:	39 ce                	cmp    %ecx,%esi
  801c92:	77 74                	ja     801d08 <__udivdi3+0xd8>
  801c94:	0f bd fe             	bsr    %esi,%edi
  801c97:	83 f7 1f             	xor    $0x1f,%edi
  801c9a:	0f 84 98 00 00 00    	je     801d38 <__udivdi3+0x108>
  801ca0:	bb 20 00 00 00       	mov    $0x20,%ebx
  801ca5:	89 f9                	mov    %edi,%ecx
  801ca7:	89 c5                	mov    %eax,%ebp
  801ca9:	29 fb                	sub    %edi,%ebx
  801cab:	d3 e6                	shl    %cl,%esi
  801cad:	89 d9                	mov    %ebx,%ecx
  801caf:	d3 ed                	shr    %cl,%ebp
  801cb1:	89 f9                	mov    %edi,%ecx
  801cb3:	d3 e0                	shl    %cl,%eax
  801cb5:	09 ee                	or     %ebp,%esi
  801cb7:	89 d9                	mov    %ebx,%ecx
  801cb9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cbd:	89 d5                	mov    %edx,%ebp
  801cbf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cc3:	d3 ed                	shr    %cl,%ebp
  801cc5:	89 f9                	mov    %edi,%ecx
  801cc7:	d3 e2                	shl    %cl,%edx
  801cc9:	89 d9                	mov    %ebx,%ecx
  801ccb:	d3 e8                	shr    %cl,%eax
  801ccd:	09 c2                	or     %eax,%edx
  801ccf:	89 d0                	mov    %edx,%eax
  801cd1:	89 ea                	mov    %ebp,%edx
  801cd3:	f7 f6                	div    %esi
  801cd5:	89 d5                	mov    %edx,%ebp
  801cd7:	89 c3                	mov    %eax,%ebx
  801cd9:	f7 64 24 0c          	mull   0xc(%esp)
  801cdd:	39 d5                	cmp    %edx,%ebp
  801cdf:	72 10                	jb     801cf1 <__udivdi3+0xc1>
  801ce1:	8b 74 24 08          	mov    0x8(%esp),%esi
  801ce5:	89 f9                	mov    %edi,%ecx
  801ce7:	d3 e6                	shl    %cl,%esi
  801ce9:	39 c6                	cmp    %eax,%esi
  801ceb:	73 07                	jae    801cf4 <__udivdi3+0xc4>
  801ced:	39 d5                	cmp    %edx,%ebp
  801cef:	75 03                	jne    801cf4 <__udivdi3+0xc4>
  801cf1:	83 eb 01             	sub    $0x1,%ebx
  801cf4:	31 ff                	xor    %edi,%edi
  801cf6:	89 d8                	mov    %ebx,%eax
  801cf8:	89 fa                	mov    %edi,%edx
  801cfa:	83 c4 1c             	add    $0x1c,%esp
  801cfd:	5b                   	pop    %ebx
  801cfe:	5e                   	pop    %esi
  801cff:	5f                   	pop    %edi
  801d00:	5d                   	pop    %ebp
  801d01:	c3                   	ret    
  801d02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d08:	31 ff                	xor    %edi,%edi
  801d0a:	31 db                	xor    %ebx,%ebx
  801d0c:	89 d8                	mov    %ebx,%eax
  801d0e:	89 fa                	mov    %edi,%edx
  801d10:	83 c4 1c             	add    $0x1c,%esp
  801d13:	5b                   	pop    %ebx
  801d14:	5e                   	pop    %esi
  801d15:	5f                   	pop    %edi
  801d16:	5d                   	pop    %ebp
  801d17:	c3                   	ret    
  801d18:	90                   	nop
  801d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d20:	89 d8                	mov    %ebx,%eax
  801d22:	f7 f7                	div    %edi
  801d24:	31 ff                	xor    %edi,%edi
  801d26:	89 c3                	mov    %eax,%ebx
  801d28:	89 d8                	mov    %ebx,%eax
  801d2a:	89 fa                	mov    %edi,%edx
  801d2c:	83 c4 1c             	add    $0x1c,%esp
  801d2f:	5b                   	pop    %ebx
  801d30:	5e                   	pop    %esi
  801d31:	5f                   	pop    %edi
  801d32:	5d                   	pop    %ebp
  801d33:	c3                   	ret    
  801d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801d38:	39 ce                	cmp    %ecx,%esi
  801d3a:	72 0c                	jb     801d48 <__udivdi3+0x118>
  801d3c:	31 db                	xor    %ebx,%ebx
  801d3e:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d42:	0f 87 34 ff ff ff    	ja     801c7c <__udivdi3+0x4c>
  801d48:	bb 01 00 00 00       	mov    $0x1,%ebx
  801d4d:	e9 2a ff ff ff       	jmp    801c7c <__udivdi3+0x4c>
  801d52:	66 90                	xchg   %ax,%ax
  801d54:	66 90                	xchg   %ax,%ax
  801d56:	66 90                	xchg   %ax,%ax
  801d58:	66 90                	xchg   %ax,%ax
  801d5a:	66 90                	xchg   %ax,%ax
  801d5c:	66 90                	xchg   %ax,%ax
  801d5e:	66 90                	xchg   %ax,%ax

00801d60 <__umoddi3>:
  801d60:	55                   	push   %ebp
  801d61:	57                   	push   %edi
  801d62:	56                   	push   %esi
  801d63:	53                   	push   %ebx
  801d64:	83 ec 1c             	sub    $0x1c,%esp
  801d67:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801d6b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d77:	85 d2                	test   %edx,%edx
  801d79:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d81:	89 f3                	mov    %esi,%ebx
  801d83:	89 3c 24             	mov    %edi,(%esp)
  801d86:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d8a:	75 1c                	jne    801da8 <__umoddi3+0x48>
  801d8c:	39 f7                	cmp    %esi,%edi
  801d8e:	76 50                	jbe    801de0 <__umoddi3+0x80>
  801d90:	89 c8                	mov    %ecx,%eax
  801d92:	89 f2                	mov    %esi,%edx
  801d94:	f7 f7                	div    %edi
  801d96:	89 d0                	mov    %edx,%eax
  801d98:	31 d2                	xor    %edx,%edx
  801d9a:	83 c4 1c             	add    $0x1c,%esp
  801d9d:	5b                   	pop    %ebx
  801d9e:	5e                   	pop    %esi
  801d9f:	5f                   	pop    %edi
  801da0:	5d                   	pop    %ebp
  801da1:	c3                   	ret    
  801da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801da8:	39 f2                	cmp    %esi,%edx
  801daa:	89 d0                	mov    %edx,%eax
  801dac:	77 52                	ja     801e00 <__umoddi3+0xa0>
  801dae:	0f bd ea             	bsr    %edx,%ebp
  801db1:	83 f5 1f             	xor    $0x1f,%ebp
  801db4:	75 5a                	jne    801e10 <__umoddi3+0xb0>
  801db6:	3b 54 24 04          	cmp    0x4(%esp),%edx
  801dba:	0f 82 e0 00 00 00    	jb     801ea0 <__umoddi3+0x140>
  801dc0:	39 0c 24             	cmp    %ecx,(%esp)
  801dc3:	0f 86 d7 00 00 00    	jbe    801ea0 <__umoddi3+0x140>
  801dc9:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dcd:	8b 54 24 04          	mov    0x4(%esp),%edx
  801dd1:	83 c4 1c             	add    $0x1c,%esp
  801dd4:	5b                   	pop    %ebx
  801dd5:	5e                   	pop    %esi
  801dd6:	5f                   	pop    %edi
  801dd7:	5d                   	pop    %ebp
  801dd8:	c3                   	ret    
  801dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801de0:	85 ff                	test   %edi,%edi
  801de2:	89 fd                	mov    %edi,%ebp
  801de4:	75 0b                	jne    801df1 <__umoddi3+0x91>
  801de6:	b8 01 00 00 00       	mov    $0x1,%eax
  801deb:	31 d2                	xor    %edx,%edx
  801ded:	f7 f7                	div    %edi
  801def:	89 c5                	mov    %eax,%ebp
  801df1:	89 f0                	mov    %esi,%eax
  801df3:	31 d2                	xor    %edx,%edx
  801df5:	f7 f5                	div    %ebp
  801df7:	89 c8                	mov    %ecx,%eax
  801df9:	f7 f5                	div    %ebp
  801dfb:	89 d0                	mov    %edx,%eax
  801dfd:	eb 99                	jmp    801d98 <__umoddi3+0x38>
  801dff:	90                   	nop
  801e00:	89 c8                	mov    %ecx,%eax
  801e02:	89 f2                	mov    %esi,%edx
  801e04:	83 c4 1c             	add    $0x1c,%esp
  801e07:	5b                   	pop    %ebx
  801e08:	5e                   	pop    %esi
  801e09:	5f                   	pop    %edi
  801e0a:	5d                   	pop    %ebp
  801e0b:	c3                   	ret    
  801e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801e10:	8b 34 24             	mov    (%esp),%esi
  801e13:	bf 20 00 00 00       	mov    $0x20,%edi
  801e18:	89 e9                	mov    %ebp,%ecx
  801e1a:	29 ef                	sub    %ebp,%edi
  801e1c:	d3 e0                	shl    %cl,%eax
  801e1e:	89 f9                	mov    %edi,%ecx
  801e20:	89 f2                	mov    %esi,%edx
  801e22:	d3 ea                	shr    %cl,%edx
  801e24:	89 e9                	mov    %ebp,%ecx
  801e26:	09 c2                	or     %eax,%edx
  801e28:	89 d8                	mov    %ebx,%eax
  801e2a:	89 14 24             	mov    %edx,(%esp)
  801e2d:	89 f2                	mov    %esi,%edx
  801e2f:	d3 e2                	shl    %cl,%edx
  801e31:	89 f9                	mov    %edi,%ecx
  801e33:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e37:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801e3b:	d3 e8                	shr    %cl,%eax
  801e3d:	89 e9                	mov    %ebp,%ecx
  801e3f:	89 c6                	mov    %eax,%esi
  801e41:	d3 e3                	shl    %cl,%ebx
  801e43:	89 f9                	mov    %edi,%ecx
  801e45:	89 d0                	mov    %edx,%eax
  801e47:	d3 e8                	shr    %cl,%eax
  801e49:	89 e9                	mov    %ebp,%ecx
  801e4b:	09 d8                	or     %ebx,%eax
  801e4d:	89 d3                	mov    %edx,%ebx
  801e4f:	89 f2                	mov    %esi,%edx
  801e51:	f7 34 24             	divl   (%esp)
  801e54:	89 d6                	mov    %edx,%esi
  801e56:	d3 e3                	shl    %cl,%ebx
  801e58:	f7 64 24 04          	mull   0x4(%esp)
  801e5c:	39 d6                	cmp    %edx,%esi
  801e5e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e62:	89 d1                	mov    %edx,%ecx
  801e64:	89 c3                	mov    %eax,%ebx
  801e66:	72 08                	jb     801e70 <__umoddi3+0x110>
  801e68:	75 11                	jne    801e7b <__umoddi3+0x11b>
  801e6a:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801e6e:	73 0b                	jae    801e7b <__umoddi3+0x11b>
  801e70:	2b 44 24 04          	sub    0x4(%esp),%eax
  801e74:	1b 14 24             	sbb    (%esp),%edx
  801e77:	89 d1                	mov    %edx,%ecx
  801e79:	89 c3                	mov    %eax,%ebx
  801e7b:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e7f:	29 da                	sub    %ebx,%edx
  801e81:	19 ce                	sbb    %ecx,%esi
  801e83:	89 f9                	mov    %edi,%ecx
  801e85:	89 f0                	mov    %esi,%eax
  801e87:	d3 e0                	shl    %cl,%eax
  801e89:	89 e9                	mov    %ebp,%ecx
  801e8b:	d3 ea                	shr    %cl,%edx
  801e8d:	89 e9                	mov    %ebp,%ecx
  801e8f:	d3 ee                	shr    %cl,%esi
  801e91:	09 d0                	or     %edx,%eax
  801e93:	89 f2                	mov    %esi,%edx
  801e95:	83 c4 1c             	add    $0x1c,%esp
  801e98:	5b                   	pop    %ebx
  801e99:	5e                   	pop    %esi
  801e9a:	5f                   	pop    %edi
  801e9b:	5d                   	pop    %ebp
  801e9c:	c3                   	ret    
  801e9d:	8d 76 00             	lea    0x0(%esi),%esi
  801ea0:	29 f9                	sub    %edi,%ecx
  801ea2:	19 d6                	sbb    %edx,%esi
  801ea4:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ea8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801eac:	e9 18 ff ff ff       	jmp    801dc9 <__umoddi3+0x69>
