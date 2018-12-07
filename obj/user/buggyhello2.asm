
obj/user/buggyhello2.debug:     formato del fichero elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs(hello, 1024*1024);
  800039:	68 00 00 10 00       	push   $0x100000
  80003e:	ff 35 00 30 80 00    	pushl  0x803000
  800044:	e8 b3 00 00 00       	call   8000fc <sys_cputs>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800056:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800059:	e8 0a 01 00 00       	call   800168 <sys_getenvid>
	if (id >= 0)
  80005e:	85 c0                	test   %eax,%eax
  800060:	78 12                	js     800074 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  800062:	25 ff 03 00 00       	and    $0x3ff,%eax
  800067:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006f:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800074:	85 db                	test   %ebx,%ebx
  800076:	7e 07                	jle    80007f <libmain+0x31>
		binaryname = argv[0];
  800078:	8b 06                	mov    (%esi),%eax
  80007a:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  80007f:	83 ec 08             	sub    $0x8,%esp
  800082:	56                   	push   %esi
  800083:	53                   	push   %ebx
  800084:	e8 aa ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800089:	e8 0a 00 00 00       	call   800098 <exit>
}
  80008e:	83 c4 10             	add    $0x10,%esp
  800091:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800094:	5b                   	pop    %ebx
  800095:	5e                   	pop    %esi
  800096:	5d                   	pop    %ebp
  800097:	c3                   	ret    

00800098 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800098:	55                   	push   %ebp
  800099:	89 e5                	mov    %esp,%ebp
  80009b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80009e:	e8 f8 03 00 00       	call   80049b <close_all>
	sys_env_destroy(0);
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	6a 00                	push   $0x0
  8000a8:	e8 99 00 00 00       	call   800146 <sys_env_destroy>
}
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	c9                   	leave  
  8000b1:	c3                   	ret    

008000b2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8000b2:	55                   	push   %ebp
  8000b3:	89 e5                	mov    %esp,%ebp
  8000b5:	57                   	push   %edi
  8000b6:	56                   	push   %esi
  8000b7:	53                   	push   %ebx
  8000b8:	83 ec 1c             	sub    $0x1c,%esp
  8000bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000be:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8000c1:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000c6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000c9:	8b 7d 10             	mov    0x10(%ebp),%edi
  8000cc:	8b 75 14             	mov    0x14(%ebp),%esi
  8000cf:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8000d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000d5:	74 1d                	je     8000f4 <syscall+0x42>
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	7e 19                	jle    8000f4 <syscall+0x42>
  8000db:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  8000de:	83 ec 0c             	sub    $0xc,%esp
  8000e1:	50                   	push   %eax
  8000e2:	52                   	push   %edx
  8000e3:	68 58 1d 80 00       	push   $0x801d58
  8000e8:	6a 23                	push   $0x23
  8000ea:	68 75 1d 80 00       	push   $0x801d75
  8000ef:	e8 e9 0e 00 00       	call   800fdd <_panic>

	return ret;
}
  8000f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f7:	5b                   	pop    %ebx
  8000f8:	5e                   	pop    %esi
  8000f9:	5f                   	pop    %edi
  8000fa:	5d                   	pop    %ebp
  8000fb:	c3                   	ret    

008000fc <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8000fc:	55                   	push   %ebp
  8000fd:	89 e5                	mov    %esp,%ebp
  8000ff:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800102:	6a 00                	push   $0x0
  800104:	6a 00                	push   $0x0
  800106:	6a 00                	push   $0x0
  800108:	ff 75 0c             	pushl  0xc(%ebp)
  80010b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80010e:	ba 00 00 00 00       	mov    $0x0,%edx
  800113:	b8 00 00 00 00       	mov    $0x0,%eax
  800118:	e8 95 ff ff ff       	call   8000b2 <syscall>
}
  80011d:	83 c4 10             	add    $0x10,%esp
  800120:	c9                   	leave  
  800121:	c3                   	ret    

00800122 <sys_cgetc>:

int
sys_cgetc(void)
{
  800122:	55                   	push   %ebp
  800123:	89 e5                	mov    %esp,%ebp
  800125:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800128:	6a 00                	push   $0x0
  80012a:	6a 00                	push   $0x0
  80012c:	6a 00                	push   $0x0
  80012e:	6a 00                	push   $0x0
  800130:	b9 00 00 00 00       	mov    $0x0,%ecx
  800135:	ba 00 00 00 00       	mov    $0x0,%edx
  80013a:	b8 01 00 00 00       	mov    $0x1,%eax
  80013f:	e8 6e ff ff ff       	call   8000b2 <syscall>
}
  800144:	c9                   	leave  
  800145:	c3                   	ret    

00800146 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800146:	55                   	push   %ebp
  800147:	89 e5                	mov    %esp,%ebp
  800149:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80014c:	6a 00                	push   $0x0
  80014e:	6a 00                	push   $0x0
  800150:	6a 00                	push   $0x0
  800152:	6a 00                	push   $0x0
  800154:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800157:	ba 01 00 00 00       	mov    $0x1,%edx
  80015c:	b8 03 00 00 00       	mov    $0x3,%eax
  800161:	e8 4c ff ff ff       	call   8000b2 <syscall>
}
  800166:	c9                   	leave  
  800167:	c3                   	ret    

00800168 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800168:	55                   	push   %ebp
  800169:	89 e5                	mov    %esp,%ebp
  80016b:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80016e:	6a 00                	push   $0x0
  800170:	6a 00                	push   $0x0
  800172:	6a 00                	push   $0x0
  800174:	6a 00                	push   $0x0
  800176:	b9 00 00 00 00       	mov    $0x0,%ecx
  80017b:	ba 00 00 00 00       	mov    $0x0,%edx
  800180:	b8 02 00 00 00       	mov    $0x2,%eax
  800185:	e8 28 ff ff ff       	call   8000b2 <syscall>
}
  80018a:	c9                   	leave  
  80018b:	c3                   	ret    

0080018c <sys_yield>:

void
sys_yield(void)
{
  80018c:	55                   	push   %ebp
  80018d:	89 e5                	mov    %esp,%ebp
  80018f:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800192:	6a 00                	push   $0x0
  800194:	6a 00                	push   $0x0
  800196:	6a 00                	push   $0x0
  800198:	6a 00                	push   $0x0
  80019a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80019f:	ba 00 00 00 00       	mov    $0x0,%edx
  8001a4:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001a9:	e8 04 ff ff ff       	call   8000b2 <syscall>
}
  8001ae:	83 c4 10             	add    $0x10,%esp
  8001b1:	c9                   	leave  
  8001b2:	c3                   	ret    

008001b3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001b3:	55                   	push   %ebp
  8001b4:	89 e5                	mov    %esp,%ebp
  8001b6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8001b9:	6a 00                	push   $0x0
  8001bb:	6a 00                	push   $0x0
  8001bd:	ff 75 10             	pushl  0x10(%ebp)
  8001c0:	ff 75 0c             	pushl  0xc(%ebp)
  8001c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001c6:	ba 01 00 00 00       	mov    $0x1,%edx
  8001cb:	b8 04 00 00 00       	mov    $0x4,%eax
  8001d0:	e8 dd fe ff ff       	call   8000b2 <syscall>
}
  8001d5:	c9                   	leave  
  8001d6:	c3                   	ret    

008001d7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001d7:	55                   	push   %ebp
  8001d8:	89 e5                	mov    %esp,%ebp
  8001da:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8001dd:	ff 75 18             	pushl  0x18(%ebp)
  8001e0:	ff 75 14             	pushl  0x14(%ebp)
  8001e3:	ff 75 10             	pushl  0x10(%ebp)
  8001e6:	ff 75 0c             	pushl  0xc(%ebp)
  8001e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ec:	ba 01 00 00 00       	mov    $0x1,%edx
  8001f1:	b8 05 00 00 00       	mov    $0x5,%eax
  8001f6:	e8 b7 fe ff ff       	call   8000b2 <syscall>
}
  8001fb:	c9                   	leave  
  8001fc:	c3                   	ret    

008001fd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001fd:	55                   	push   %ebp
  8001fe:	89 e5                	mov    %esp,%ebp
  800200:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800203:	6a 00                	push   $0x0
  800205:	6a 00                	push   $0x0
  800207:	6a 00                	push   $0x0
  800209:	ff 75 0c             	pushl  0xc(%ebp)
  80020c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80020f:	ba 01 00 00 00       	mov    $0x1,%edx
  800214:	b8 06 00 00 00       	mov    $0x6,%eax
  800219:	e8 94 fe ff ff       	call   8000b2 <syscall>
}
  80021e:	c9                   	leave  
  80021f:	c3                   	ret    

00800220 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800226:	6a 00                	push   $0x0
  800228:	6a 00                	push   $0x0
  80022a:	6a 00                	push   $0x0
  80022c:	ff 75 0c             	pushl  0xc(%ebp)
  80022f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800232:	ba 01 00 00 00       	mov    $0x1,%edx
  800237:	b8 08 00 00 00       	mov    $0x8,%eax
  80023c:	e8 71 fe ff ff       	call   8000b2 <syscall>
}
  800241:	c9                   	leave  
  800242:	c3                   	ret    

00800243 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800249:	6a 00                	push   $0x0
  80024b:	6a 00                	push   $0x0
  80024d:	6a 00                	push   $0x0
  80024f:	ff 75 0c             	pushl  0xc(%ebp)
  800252:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800255:	ba 01 00 00 00       	mov    $0x1,%edx
  80025a:	b8 09 00 00 00       	mov    $0x9,%eax
  80025f:	e8 4e fe ff ff       	call   8000b2 <syscall>
}
  800264:	c9                   	leave  
  800265:	c3                   	ret    

00800266 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  80026c:	6a 00                	push   $0x0
  80026e:	6a 00                	push   $0x0
  800270:	6a 00                	push   $0x0
  800272:	ff 75 0c             	pushl  0xc(%ebp)
  800275:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800278:	ba 01 00 00 00       	mov    $0x1,%edx
  80027d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800282:	e8 2b fe ff ff       	call   8000b2 <syscall>
}
  800287:	c9                   	leave  
  800288:	c3                   	ret    

00800289 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800289:	55                   	push   %ebp
  80028a:	89 e5                	mov    %esp,%ebp
  80028c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  80028f:	6a 00                	push   $0x0
  800291:	ff 75 14             	pushl  0x14(%ebp)
  800294:	ff 75 10             	pushl  0x10(%ebp)
  800297:	ff 75 0c             	pushl  0xc(%ebp)
  80029a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80029d:	ba 00 00 00 00       	mov    $0x0,%edx
  8002a2:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002a7:	e8 06 fe ff ff       	call   8000b2 <syscall>
}
  8002ac:	c9                   	leave  
  8002ad:	c3                   	ret    

008002ae <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002ae:	55                   	push   %ebp
  8002af:	89 e5                	mov    %esp,%ebp
  8002b1:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8002b4:	6a 00                	push   $0x0
  8002b6:	6a 00                	push   $0x0
  8002b8:	6a 00                	push   $0x0
  8002ba:	6a 00                	push   $0x0
  8002bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002bf:	ba 01 00 00 00       	mov    $0x1,%edx
  8002c4:	b8 0d 00 00 00       	mov    $0xd,%eax
  8002c9:	e8 e4 fd ff ff       	call   8000b2 <syscall>
}
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8002d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d6:	05 00 00 00 30       	add    $0x30000000,%eax
  8002db:	c1 e8 0c             	shr    $0xc,%eax
}
  8002de:	5d                   	pop    %ebp
  8002df:	c3                   	ret    

008002e0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  8002e3:	ff 75 08             	pushl  0x8(%ebp)
  8002e6:	e8 e5 ff ff ff       	call   8002d0 <fd2num>
  8002eb:	83 c4 04             	add    $0x4,%esp
  8002ee:	c1 e0 0c             	shl    $0xc,%eax
  8002f1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8002f6:	c9                   	leave  
  8002f7:	c3                   	ret    

008002f8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8002f8:	55                   	push   %ebp
  8002f9:	89 e5                	mov    %esp,%ebp
  8002fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002fe:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800303:	89 c2                	mov    %eax,%edx
  800305:	c1 ea 16             	shr    $0x16,%edx
  800308:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80030f:	f6 c2 01             	test   $0x1,%dl
  800312:	74 11                	je     800325 <fd_alloc+0x2d>
  800314:	89 c2                	mov    %eax,%edx
  800316:	c1 ea 0c             	shr    $0xc,%edx
  800319:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800320:	f6 c2 01             	test   $0x1,%dl
  800323:	75 09                	jne    80032e <fd_alloc+0x36>
			*fd_store = fd;
  800325:	89 01                	mov    %eax,(%ecx)
			return 0;
  800327:	b8 00 00 00 00       	mov    $0x0,%eax
  80032c:	eb 17                	jmp    800345 <fd_alloc+0x4d>
  80032e:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800333:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800338:	75 c9                	jne    800303 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80033a:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800340:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800345:	5d                   	pop    %ebp
  800346:	c3                   	ret    

00800347 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800347:	55                   	push   %ebp
  800348:	89 e5                	mov    %esp,%ebp
  80034a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80034d:	83 f8 1f             	cmp    $0x1f,%eax
  800350:	77 36                	ja     800388 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800352:	c1 e0 0c             	shl    $0xc,%eax
  800355:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80035a:	89 c2                	mov    %eax,%edx
  80035c:	c1 ea 16             	shr    $0x16,%edx
  80035f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800366:	f6 c2 01             	test   $0x1,%dl
  800369:	74 24                	je     80038f <fd_lookup+0x48>
  80036b:	89 c2                	mov    %eax,%edx
  80036d:	c1 ea 0c             	shr    $0xc,%edx
  800370:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800377:	f6 c2 01             	test   $0x1,%dl
  80037a:	74 1a                	je     800396 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80037c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80037f:	89 02                	mov    %eax,(%edx)
	return 0;
  800381:	b8 00 00 00 00       	mov    $0x0,%eax
  800386:	eb 13                	jmp    80039b <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800388:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80038d:	eb 0c                	jmp    80039b <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80038f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800394:	eb 05                	jmp    80039b <fd_lookup+0x54>
  800396:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80039b:	5d                   	pop    %ebp
  80039c:	c3                   	ret    

0080039d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	83 ec 08             	sub    $0x8,%esp
  8003a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a6:	ba 00 1e 80 00       	mov    $0x801e00,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8003ab:	eb 13                	jmp    8003c0 <dev_lookup+0x23>
  8003ad:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  8003b0:	39 08                	cmp    %ecx,(%eax)
  8003b2:	75 0c                	jne    8003c0 <dev_lookup+0x23>
			*dev = devtab[i];
  8003b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003b7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003be:	eb 2e                	jmp    8003ee <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8003c0:	8b 02                	mov    (%edx),%eax
  8003c2:	85 c0                	test   %eax,%eax
  8003c4:	75 e7                	jne    8003ad <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8003c6:	a1 04 40 80 00       	mov    0x804004,%eax
  8003cb:	8b 40 48             	mov    0x48(%eax),%eax
  8003ce:	83 ec 04             	sub    $0x4,%esp
  8003d1:	51                   	push   %ecx
  8003d2:	50                   	push   %eax
  8003d3:	68 84 1d 80 00       	push   $0x801d84
  8003d8:	e8 d9 0c 00 00       	call   8010b6 <cprintf>
	*dev = 0;
  8003dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8003e6:	83 c4 10             	add    $0x10,%esp
  8003e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8003ee:	c9                   	leave  
  8003ef:	c3                   	ret    

008003f0 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	56                   	push   %esi
  8003f4:	53                   	push   %ebx
  8003f5:	83 ec 10             	sub    $0x10,%esp
  8003f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8003fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8003fe:	56                   	push   %esi
  8003ff:	e8 cc fe ff ff       	call   8002d0 <fd2num>
  800404:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800407:	89 14 24             	mov    %edx,(%esp)
  80040a:	50                   	push   %eax
  80040b:	e8 37 ff ff ff       	call   800347 <fd_lookup>
  800410:	83 c4 08             	add    $0x8,%esp
  800413:	85 c0                	test   %eax,%eax
  800415:	78 05                	js     80041c <fd_close+0x2c>
	    || fd != fd2)
  800417:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80041a:	74 0c                	je     800428 <fd_close+0x38>
		return (must_exist ? r : 0);
  80041c:	84 db                	test   %bl,%bl
  80041e:	ba 00 00 00 00       	mov    $0x0,%edx
  800423:	0f 44 c2             	cmove  %edx,%eax
  800426:	eb 41                	jmp    800469 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800428:	83 ec 08             	sub    $0x8,%esp
  80042b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80042e:	50                   	push   %eax
  80042f:	ff 36                	pushl  (%esi)
  800431:	e8 67 ff ff ff       	call   80039d <dev_lookup>
  800436:	89 c3                	mov    %eax,%ebx
  800438:	83 c4 10             	add    $0x10,%esp
  80043b:	85 c0                	test   %eax,%eax
  80043d:	78 1a                	js     800459 <fd_close+0x69>
		if (dev->dev_close)
  80043f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800442:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800445:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80044a:	85 c0                	test   %eax,%eax
  80044c:	74 0b                	je     800459 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  80044e:	83 ec 0c             	sub    $0xc,%esp
  800451:	56                   	push   %esi
  800452:	ff d0                	call   *%eax
  800454:	89 c3                	mov    %eax,%ebx
  800456:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800459:	83 ec 08             	sub    $0x8,%esp
  80045c:	56                   	push   %esi
  80045d:	6a 00                	push   $0x0
  80045f:	e8 99 fd ff ff       	call   8001fd <sys_page_unmap>
	return r;
  800464:	83 c4 10             	add    $0x10,%esp
  800467:	89 d8                	mov    %ebx,%eax
}
  800469:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80046c:	5b                   	pop    %ebx
  80046d:	5e                   	pop    %esi
  80046e:	5d                   	pop    %ebp
  80046f:	c3                   	ret    

00800470 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800470:	55                   	push   %ebp
  800471:	89 e5                	mov    %esp,%ebp
  800473:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800476:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800479:	50                   	push   %eax
  80047a:	ff 75 08             	pushl  0x8(%ebp)
  80047d:	e8 c5 fe ff ff       	call   800347 <fd_lookup>
  800482:	83 c4 08             	add    $0x8,%esp
  800485:	85 c0                	test   %eax,%eax
  800487:	78 10                	js     800499 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800489:	83 ec 08             	sub    $0x8,%esp
  80048c:	6a 01                	push   $0x1
  80048e:	ff 75 f4             	pushl  -0xc(%ebp)
  800491:	e8 5a ff ff ff       	call   8003f0 <fd_close>
  800496:	83 c4 10             	add    $0x10,%esp
}
  800499:	c9                   	leave  
  80049a:	c3                   	ret    

0080049b <close_all>:

void
close_all(void)
{
  80049b:	55                   	push   %ebp
  80049c:	89 e5                	mov    %esp,%ebp
  80049e:	53                   	push   %ebx
  80049f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8004a2:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8004a7:	83 ec 0c             	sub    $0xc,%esp
  8004aa:	53                   	push   %ebx
  8004ab:	e8 c0 ff ff ff       	call   800470 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8004b0:	83 c3 01             	add    $0x1,%ebx
  8004b3:	83 c4 10             	add    $0x10,%esp
  8004b6:	83 fb 20             	cmp    $0x20,%ebx
  8004b9:	75 ec                	jne    8004a7 <close_all+0xc>
		close(i);
}
  8004bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004be:	c9                   	leave  
  8004bf:	c3                   	ret    

008004c0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	57                   	push   %edi
  8004c4:	56                   	push   %esi
  8004c5:	53                   	push   %ebx
  8004c6:	83 ec 2c             	sub    $0x2c,%esp
  8004c9:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8004cc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004cf:	50                   	push   %eax
  8004d0:	ff 75 08             	pushl  0x8(%ebp)
  8004d3:	e8 6f fe ff ff       	call   800347 <fd_lookup>
  8004d8:	83 c4 08             	add    $0x8,%esp
  8004db:	85 c0                	test   %eax,%eax
  8004dd:	0f 88 c1 00 00 00    	js     8005a4 <dup+0xe4>
		return r;
	close(newfdnum);
  8004e3:	83 ec 0c             	sub    $0xc,%esp
  8004e6:	56                   	push   %esi
  8004e7:	e8 84 ff ff ff       	call   800470 <close>

	newfd = INDEX2FD(newfdnum);
  8004ec:	89 f3                	mov    %esi,%ebx
  8004ee:	c1 e3 0c             	shl    $0xc,%ebx
  8004f1:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8004f7:	83 c4 04             	add    $0x4,%esp
  8004fa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004fd:	e8 de fd ff ff       	call   8002e0 <fd2data>
  800502:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  800504:	89 1c 24             	mov    %ebx,(%esp)
  800507:	e8 d4 fd ff ff       	call   8002e0 <fd2data>
  80050c:	83 c4 10             	add    $0x10,%esp
  80050f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800512:	89 f8                	mov    %edi,%eax
  800514:	c1 e8 16             	shr    $0x16,%eax
  800517:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80051e:	a8 01                	test   $0x1,%al
  800520:	74 37                	je     800559 <dup+0x99>
  800522:	89 f8                	mov    %edi,%eax
  800524:	c1 e8 0c             	shr    $0xc,%eax
  800527:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80052e:	f6 c2 01             	test   $0x1,%dl
  800531:	74 26                	je     800559 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800533:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80053a:	83 ec 0c             	sub    $0xc,%esp
  80053d:	25 07 0e 00 00       	and    $0xe07,%eax
  800542:	50                   	push   %eax
  800543:	ff 75 d4             	pushl  -0x2c(%ebp)
  800546:	6a 00                	push   $0x0
  800548:	57                   	push   %edi
  800549:	6a 00                	push   $0x0
  80054b:	e8 87 fc ff ff       	call   8001d7 <sys_page_map>
  800550:	89 c7                	mov    %eax,%edi
  800552:	83 c4 20             	add    $0x20,%esp
  800555:	85 c0                	test   %eax,%eax
  800557:	78 2e                	js     800587 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800559:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80055c:	89 d0                	mov    %edx,%eax
  80055e:	c1 e8 0c             	shr    $0xc,%eax
  800561:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800568:	83 ec 0c             	sub    $0xc,%esp
  80056b:	25 07 0e 00 00       	and    $0xe07,%eax
  800570:	50                   	push   %eax
  800571:	53                   	push   %ebx
  800572:	6a 00                	push   $0x0
  800574:	52                   	push   %edx
  800575:	6a 00                	push   $0x0
  800577:	e8 5b fc ff ff       	call   8001d7 <sys_page_map>
  80057c:	89 c7                	mov    %eax,%edi
  80057e:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  800581:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800583:	85 ff                	test   %edi,%edi
  800585:	79 1d                	jns    8005a4 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	53                   	push   %ebx
  80058b:	6a 00                	push   $0x0
  80058d:	e8 6b fc ff ff       	call   8001fd <sys_page_unmap>
	sys_page_unmap(0, nva);
  800592:	83 c4 08             	add    $0x8,%esp
  800595:	ff 75 d4             	pushl  -0x2c(%ebp)
  800598:	6a 00                	push   $0x0
  80059a:	e8 5e fc ff ff       	call   8001fd <sys_page_unmap>
	return r;
  80059f:	83 c4 10             	add    $0x10,%esp
  8005a2:	89 f8                	mov    %edi,%eax
}
  8005a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005a7:	5b                   	pop    %ebx
  8005a8:	5e                   	pop    %esi
  8005a9:	5f                   	pop    %edi
  8005aa:	5d                   	pop    %ebp
  8005ab:	c3                   	ret    

008005ac <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8005ac:	55                   	push   %ebp
  8005ad:	89 e5                	mov    %esp,%ebp
  8005af:	53                   	push   %ebx
  8005b0:	83 ec 14             	sub    $0x14,%esp
  8005b3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8005b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8005b9:	50                   	push   %eax
  8005ba:	53                   	push   %ebx
  8005bb:	e8 87 fd ff ff       	call   800347 <fd_lookup>
  8005c0:	83 c4 08             	add    $0x8,%esp
  8005c3:	89 c2                	mov    %eax,%edx
  8005c5:	85 c0                	test   %eax,%eax
  8005c7:	78 6d                	js     800636 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8005c9:	83 ec 08             	sub    $0x8,%esp
  8005cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005cf:	50                   	push   %eax
  8005d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005d3:	ff 30                	pushl  (%eax)
  8005d5:	e8 c3 fd ff ff       	call   80039d <dev_lookup>
  8005da:	83 c4 10             	add    $0x10,%esp
  8005dd:	85 c0                	test   %eax,%eax
  8005df:	78 4c                	js     80062d <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8005e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8005e4:	8b 42 08             	mov    0x8(%edx),%eax
  8005e7:	83 e0 03             	and    $0x3,%eax
  8005ea:	83 f8 01             	cmp    $0x1,%eax
  8005ed:	75 21                	jne    800610 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8005ef:	a1 04 40 80 00       	mov    0x804004,%eax
  8005f4:	8b 40 48             	mov    0x48(%eax),%eax
  8005f7:	83 ec 04             	sub    $0x4,%esp
  8005fa:	53                   	push   %ebx
  8005fb:	50                   	push   %eax
  8005fc:	68 c5 1d 80 00       	push   $0x801dc5
  800601:	e8 b0 0a 00 00       	call   8010b6 <cprintf>
		return -E_INVAL;
  800606:	83 c4 10             	add    $0x10,%esp
  800609:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80060e:	eb 26                	jmp    800636 <read+0x8a>
	}
	if (!dev->dev_read)
  800610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800613:	8b 40 08             	mov    0x8(%eax),%eax
  800616:	85 c0                	test   %eax,%eax
  800618:	74 17                	je     800631 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80061a:	83 ec 04             	sub    $0x4,%esp
  80061d:	ff 75 10             	pushl  0x10(%ebp)
  800620:	ff 75 0c             	pushl  0xc(%ebp)
  800623:	52                   	push   %edx
  800624:	ff d0                	call   *%eax
  800626:	89 c2                	mov    %eax,%edx
  800628:	83 c4 10             	add    $0x10,%esp
  80062b:	eb 09                	jmp    800636 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80062d:	89 c2                	mov    %eax,%edx
  80062f:	eb 05                	jmp    800636 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800631:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  800636:	89 d0                	mov    %edx,%eax
  800638:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80063b:	c9                   	leave  
  80063c:	c3                   	ret    

0080063d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80063d:	55                   	push   %ebp
  80063e:	89 e5                	mov    %esp,%ebp
  800640:	57                   	push   %edi
  800641:	56                   	push   %esi
  800642:	53                   	push   %ebx
  800643:	83 ec 0c             	sub    $0xc,%esp
  800646:	8b 7d 08             	mov    0x8(%ebp),%edi
  800649:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80064c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800651:	eb 21                	jmp    800674 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800653:	83 ec 04             	sub    $0x4,%esp
  800656:	89 f0                	mov    %esi,%eax
  800658:	29 d8                	sub    %ebx,%eax
  80065a:	50                   	push   %eax
  80065b:	89 d8                	mov    %ebx,%eax
  80065d:	03 45 0c             	add    0xc(%ebp),%eax
  800660:	50                   	push   %eax
  800661:	57                   	push   %edi
  800662:	e8 45 ff ff ff       	call   8005ac <read>
		if (m < 0)
  800667:	83 c4 10             	add    $0x10,%esp
  80066a:	85 c0                	test   %eax,%eax
  80066c:	78 10                	js     80067e <readn+0x41>
			return m;
		if (m == 0)
  80066e:	85 c0                	test   %eax,%eax
  800670:	74 0a                	je     80067c <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800672:	01 c3                	add    %eax,%ebx
  800674:	39 f3                	cmp    %esi,%ebx
  800676:	72 db                	jb     800653 <readn+0x16>
  800678:	89 d8                	mov    %ebx,%eax
  80067a:	eb 02                	jmp    80067e <readn+0x41>
  80067c:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80067e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800681:	5b                   	pop    %ebx
  800682:	5e                   	pop    %esi
  800683:	5f                   	pop    %edi
  800684:	5d                   	pop    %ebp
  800685:	c3                   	ret    

00800686 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800686:	55                   	push   %ebp
  800687:	89 e5                	mov    %esp,%ebp
  800689:	53                   	push   %ebx
  80068a:	83 ec 14             	sub    $0x14,%esp
  80068d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800690:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800693:	50                   	push   %eax
  800694:	53                   	push   %ebx
  800695:	e8 ad fc ff ff       	call   800347 <fd_lookup>
  80069a:	83 c4 08             	add    $0x8,%esp
  80069d:	89 c2                	mov    %eax,%edx
  80069f:	85 c0                	test   %eax,%eax
  8006a1:	78 68                	js     80070b <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006a3:	83 ec 08             	sub    $0x8,%esp
  8006a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006a9:	50                   	push   %eax
  8006aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ad:	ff 30                	pushl  (%eax)
  8006af:	e8 e9 fc ff ff       	call   80039d <dev_lookup>
  8006b4:	83 c4 10             	add    $0x10,%esp
  8006b7:	85 c0                	test   %eax,%eax
  8006b9:	78 47                	js     800702 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8006bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006be:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8006c2:	75 21                	jne    8006e5 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8006c4:	a1 04 40 80 00       	mov    0x804004,%eax
  8006c9:	8b 40 48             	mov    0x48(%eax),%eax
  8006cc:	83 ec 04             	sub    $0x4,%esp
  8006cf:	53                   	push   %ebx
  8006d0:	50                   	push   %eax
  8006d1:	68 e1 1d 80 00       	push   $0x801de1
  8006d6:	e8 db 09 00 00       	call   8010b6 <cprintf>
		return -E_INVAL;
  8006db:	83 c4 10             	add    $0x10,%esp
  8006de:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8006e3:	eb 26                	jmp    80070b <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8006e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006e8:	8b 52 0c             	mov    0xc(%edx),%edx
  8006eb:	85 d2                	test   %edx,%edx
  8006ed:	74 17                	je     800706 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8006ef:	83 ec 04             	sub    $0x4,%esp
  8006f2:	ff 75 10             	pushl  0x10(%ebp)
  8006f5:	ff 75 0c             	pushl  0xc(%ebp)
  8006f8:	50                   	push   %eax
  8006f9:	ff d2                	call   *%edx
  8006fb:	89 c2                	mov    %eax,%edx
  8006fd:	83 c4 10             	add    $0x10,%esp
  800700:	eb 09                	jmp    80070b <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800702:	89 c2                	mov    %eax,%edx
  800704:	eb 05                	jmp    80070b <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  800706:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  80070b:	89 d0                	mov    %edx,%eax
  80070d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800710:	c9                   	leave  
  800711:	c3                   	ret    

00800712 <seek>:

int
seek(int fdnum, off_t offset)
{
  800712:	55                   	push   %ebp
  800713:	89 e5                	mov    %esp,%ebp
  800715:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800718:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80071b:	50                   	push   %eax
  80071c:	ff 75 08             	pushl  0x8(%ebp)
  80071f:	e8 23 fc ff ff       	call   800347 <fd_lookup>
  800724:	83 c4 08             	add    $0x8,%esp
  800727:	85 c0                	test   %eax,%eax
  800729:	78 0e                	js     800739 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80072b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80072e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800731:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800734:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800739:	c9                   	leave  
  80073a:	c3                   	ret    

0080073b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80073b:	55                   	push   %ebp
  80073c:	89 e5                	mov    %esp,%ebp
  80073e:	53                   	push   %ebx
  80073f:	83 ec 14             	sub    $0x14,%esp
  800742:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800745:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800748:	50                   	push   %eax
  800749:	53                   	push   %ebx
  80074a:	e8 f8 fb ff ff       	call   800347 <fd_lookup>
  80074f:	83 c4 08             	add    $0x8,%esp
  800752:	89 c2                	mov    %eax,%edx
  800754:	85 c0                	test   %eax,%eax
  800756:	78 65                	js     8007bd <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800758:	83 ec 08             	sub    $0x8,%esp
  80075b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80075e:	50                   	push   %eax
  80075f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800762:	ff 30                	pushl  (%eax)
  800764:	e8 34 fc ff ff       	call   80039d <dev_lookup>
  800769:	83 c4 10             	add    $0x10,%esp
  80076c:	85 c0                	test   %eax,%eax
  80076e:	78 44                	js     8007b4 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800770:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800773:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800777:	75 21                	jne    80079a <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800779:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80077e:	8b 40 48             	mov    0x48(%eax),%eax
  800781:	83 ec 04             	sub    $0x4,%esp
  800784:	53                   	push   %ebx
  800785:	50                   	push   %eax
  800786:	68 a4 1d 80 00       	push   $0x801da4
  80078b:	e8 26 09 00 00       	call   8010b6 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800790:	83 c4 10             	add    $0x10,%esp
  800793:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800798:	eb 23                	jmp    8007bd <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  80079a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80079d:	8b 52 18             	mov    0x18(%edx),%edx
  8007a0:	85 d2                	test   %edx,%edx
  8007a2:	74 14                	je     8007b8 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8007a4:	83 ec 08             	sub    $0x8,%esp
  8007a7:	ff 75 0c             	pushl  0xc(%ebp)
  8007aa:	50                   	push   %eax
  8007ab:	ff d2                	call   *%edx
  8007ad:	89 c2                	mov    %eax,%edx
  8007af:	83 c4 10             	add    $0x10,%esp
  8007b2:	eb 09                	jmp    8007bd <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007b4:	89 c2                	mov    %eax,%edx
  8007b6:	eb 05                	jmp    8007bd <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8007b8:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  8007bd:	89 d0                	mov    %edx,%eax
  8007bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c2:	c9                   	leave  
  8007c3:	c3                   	ret    

008007c4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8007c4:	55                   	push   %ebp
  8007c5:	89 e5                	mov    %esp,%ebp
  8007c7:	53                   	push   %ebx
  8007c8:	83 ec 14             	sub    $0x14,%esp
  8007cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007d1:	50                   	push   %eax
  8007d2:	ff 75 08             	pushl  0x8(%ebp)
  8007d5:	e8 6d fb ff ff       	call   800347 <fd_lookup>
  8007da:	83 c4 08             	add    $0x8,%esp
  8007dd:	89 c2                	mov    %eax,%edx
  8007df:	85 c0                	test   %eax,%eax
  8007e1:	78 58                	js     80083b <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007e3:	83 ec 08             	sub    $0x8,%esp
  8007e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007e9:	50                   	push   %eax
  8007ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ed:	ff 30                	pushl  (%eax)
  8007ef:	e8 a9 fb ff ff       	call   80039d <dev_lookup>
  8007f4:	83 c4 10             	add    $0x10,%esp
  8007f7:	85 c0                	test   %eax,%eax
  8007f9:	78 37                	js     800832 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  8007fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007fe:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800802:	74 32                	je     800836 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800804:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800807:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80080e:	00 00 00 
	stat->st_isdir = 0;
  800811:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800818:	00 00 00 
	stat->st_dev = dev;
  80081b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	53                   	push   %ebx
  800825:	ff 75 f0             	pushl  -0x10(%ebp)
  800828:	ff 50 14             	call   *0x14(%eax)
  80082b:	89 c2                	mov    %eax,%edx
  80082d:	83 c4 10             	add    $0x10,%esp
  800830:	eb 09                	jmp    80083b <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800832:	89 c2                	mov    %eax,%edx
  800834:	eb 05                	jmp    80083b <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800836:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80083b:	89 d0                	mov    %edx,%eax
  80083d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800840:	c9                   	leave  
  800841:	c3                   	ret    

00800842 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800842:	55                   	push   %ebp
  800843:	89 e5                	mov    %esp,%ebp
  800845:	56                   	push   %esi
  800846:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800847:	83 ec 08             	sub    $0x8,%esp
  80084a:	6a 00                	push   $0x0
  80084c:	ff 75 08             	pushl  0x8(%ebp)
  80084f:	e8 06 02 00 00       	call   800a5a <open>
  800854:	89 c3                	mov    %eax,%ebx
  800856:	83 c4 10             	add    $0x10,%esp
  800859:	85 c0                	test   %eax,%eax
  80085b:	78 1b                	js     800878 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	ff 75 0c             	pushl  0xc(%ebp)
  800863:	50                   	push   %eax
  800864:	e8 5b ff ff ff       	call   8007c4 <fstat>
  800869:	89 c6                	mov    %eax,%esi
	close(fd);
  80086b:	89 1c 24             	mov    %ebx,(%esp)
  80086e:	e8 fd fb ff ff       	call   800470 <close>
	return r;
  800873:	83 c4 10             	add    $0x10,%esp
  800876:	89 f0                	mov    %esi,%eax
}
  800878:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80087b:	5b                   	pop    %ebx
  80087c:	5e                   	pop    %esi
  80087d:	5d                   	pop    %ebp
  80087e:	c3                   	ret    

0080087f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80087f:	55                   	push   %ebp
  800880:	89 e5                	mov    %esp,%ebp
  800882:	56                   	push   %esi
  800883:	53                   	push   %ebx
  800884:	89 c6                	mov    %eax,%esi
  800886:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800888:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80088f:	75 12                	jne    8008a3 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800891:	83 ec 0c             	sub    $0xc,%esp
  800894:	6a 01                	push   $0x1
  800896:	e8 94 11 00 00       	call   801a2f <ipc_find_env>
  80089b:	a3 00 40 80 00       	mov    %eax,0x804000
  8008a0:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8008a3:	6a 07                	push   $0x7
  8008a5:	68 00 50 80 00       	push   $0x805000
  8008aa:	56                   	push   %esi
  8008ab:	ff 35 00 40 80 00    	pushl  0x804000
  8008b1:	e8 25 11 00 00       	call   8019db <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8008b6:	83 c4 0c             	add    $0xc,%esp
  8008b9:	6a 00                	push   $0x0
  8008bb:	53                   	push   %ebx
  8008bc:	6a 00                	push   $0x0
  8008be:	e8 ad 10 00 00       	call   801970 <ipc_recv>
}
  8008c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008c6:	5b                   	pop    %ebx
  8008c7:	5e                   	pop    %esi
  8008c8:	5d                   	pop    %ebp
  8008c9:	c3                   	ret    

008008ca <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8008ca:	55                   	push   %ebp
  8008cb:	89 e5                	mov    %esp,%ebp
  8008cd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8008d6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8008db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008de:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8008e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e8:	b8 02 00 00 00       	mov    $0x2,%eax
  8008ed:	e8 8d ff ff ff       	call   80087f <fsipc>
}
  8008f2:	c9                   	leave  
  8008f3:	c3                   	ret    

008008f4 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	8b 40 0c             	mov    0xc(%eax),%eax
  800900:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800905:	ba 00 00 00 00       	mov    $0x0,%edx
  80090a:	b8 06 00 00 00       	mov    $0x6,%eax
  80090f:	e8 6b ff ff ff       	call   80087f <fsipc>
}
  800914:	c9                   	leave  
  800915:	c3                   	ret    

00800916 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	53                   	push   %ebx
  80091a:	83 ec 04             	sub    $0x4,%esp
  80091d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	8b 40 0c             	mov    0xc(%eax),%eax
  800926:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80092b:	ba 00 00 00 00       	mov    $0x0,%edx
  800930:	b8 05 00 00 00       	mov    $0x5,%eax
  800935:	e8 45 ff ff ff       	call   80087f <fsipc>
  80093a:	85 c0                	test   %eax,%eax
  80093c:	78 2c                	js     80096a <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80093e:	83 ec 08             	sub    $0x8,%esp
  800941:	68 00 50 80 00       	push   $0x805000
  800946:	53                   	push   %ebx
  800947:	e8 dc 0c 00 00       	call   801628 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80094c:	a1 80 50 80 00       	mov    0x805080,%eax
  800951:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800957:	a1 84 50 80 00       	mov    0x805084,%eax
  80095c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800962:	83 c4 10             	add    $0x10,%esp
  800965:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80096a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80096d:	c9                   	leave  
  80096e:	c3                   	ret    

0080096f <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	83 ec 08             	sub    $0x8,%esp
  800975:	8b 55 0c             	mov    0xc(%ebp),%edx
  800978:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80097b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80097e:	8b 49 0c             	mov    0xc(%ecx),%ecx
  800981:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  800987:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80098c:	76 22                	jbe    8009b0 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  80098e:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  800995:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  800998:	83 ec 04             	sub    $0x4,%esp
  80099b:	68 f8 0f 00 00       	push   $0xff8
  8009a0:	52                   	push   %edx
  8009a1:	68 08 50 80 00       	push   $0x805008
  8009a6:	e8 10 0e 00 00       	call   8017bb <memmove>
  8009ab:	83 c4 10             	add    $0x10,%esp
  8009ae:	eb 17                	jmp    8009c7 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  8009b0:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  8009b5:	83 ec 04             	sub    $0x4,%esp
  8009b8:	50                   	push   %eax
  8009b9:	52                   	push   %edx
  8009ba:	68 08 50 80 00       	push   $0x805008
  8009bf:	e8 f7 0d 00 00       	call   8017bb <memmove>
  8009c4:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  8009c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009cc:	b8 04 00 00 00       	mov    $0x4,%eax
  8009d1:	e8 a9 fe ff ff       	call   80087f <fsipc>
	if (result < 0)
		return result;

	return result;
}
  8009d6:	c9                   	leave  
  8009d7:	c3                   	ret    

008009d8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	56                   	push   %esi
  8009dc:	53                   	push   %ebx
  8009dd:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8009e6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8009eb:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8009f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f6:	b8 03 00 00 00       	mov    $0x3,%eax
  8009fb:	e8 7f fe ff ff       	call   80087f <fsipc>
  800a00:	89 c3                	mov    %eax,%ebx
  800a02:	85 c0                	test   %eax,%eax
  800a04:	78 4b                	js     800a51 <devfile_read+0x79>
		return r;
	assert(r <= n);
  800a06:	39 c6                	cmp    %eax,%esi
  800a08:	73 16                	jae    800a20 <devfile_read+0x48>
  800a0a:	68 10 1e 80 00       	push   $0x801e10
  800a0f:	68 17 1e 80 00       	push   $0x801e17
  800a14:	6a 7c                	push   $0x7c
  800a16:	68 2c 1e 80 00       	push   $0x801e2c
  800a1b:	e8 bd 05 00 00       	call   800fdd <_panic>
	assert(r <= PGSIZE);
  800a20:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a25:	7e 16                	jle    800a3d <devfile_read+0x65>
  800a27:	68 37 1e 80 00       	push   $0x801e37
  800a2c:	68 17 1e 80 00       	push   $0x801e17
  800a31:	6a 7d                	push   $0x7d
  800a33:	68 2c 1e 80 00       	push   $0x801e2c
  800a38:	e8 a0 05 00 00       	call   800fdd <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a3d:	83 ec 04             	sub    $0x4,%esp
  800a40:	50                   	push   %eax
  800a41:	68 00 50 80 00       	push   $0x805000
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	e8 6d 0d 00 00       	call   8017bb <memmove>
	return r;
  800a4e:	83 c4 10             	add    $0x10,%esp
}
  800a51:	89 d8                	mov    %ebx,%eax
  800a53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a56:	5b                   	pop    %ebx
  800a57:	5e                   	pop    %esi
  800a58:	5d                   	pop    %ebp
  800a59:	c3                   	ret    

00800a5a <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	53                   	push   %ebx
  800a5e:	83 ec 20             	sub    $0x20,%esp
  800a61:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800a64:	53                   	push   %ebx
  800a65:	e8 85 0b 00 00       	call   8015ef <strlen>
  800a6a:	83 c4 10             	add    $0x10,%esp
  800a6d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800a72:	7f 67                	jg     800adb <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800a74:	83 ec 0c             	sub    $0xc,%esp
  800a77:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a7a:	50                   	push   %eax
  800a7b:	e8 78 f8 ff ff       	call   8002f8 <fd_alloc>
  800a80:	83 c4 10             	add    $0x10,%esp
		return r;
  800a83:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800a85:	85 c0                	test   %eax,%eax
  800a87:	78 57                	js     800ae0 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800a89:	83 ec 08             	sub    $0x8,%esp
  800a8c:	53                   	push   %ebx
  800a8d:	68 00 50 80 00       	push   $0x805000
  800a92:	e8 91 0b 00 00       	call   801628 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800a97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9a:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800a9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aa2:	b8 01 00 00 00       	mov    $0x1,%eax
  800aa7:	e8 d3 fd ff ff       	call   80087f <fsipc>
  800aac:	89 c3                	mov    %eax,%ebx
  800aae:	83 c4 10             	add    $0x10,%esp
  800ab1:	85 c0                	test   %eax,%eax
  800ab3:	79 14                	jns    800ac9 <open+0x6f>
		fd_close(fd, 0);
  800ab5:	83 ec 08             	sub    $0x8,%esp
  800ab8:	6a 00                	push   $0x0
  800aba:	ff 75 f4             	pushl  -0xc(%ebp)
  800abd:	e8 2e f9 ff ff       	call   8003f0 <fd_close>
		return r;
  800ac2:	83 c4 10             	add    $0x10,%esp
  800ac5:	89 da                	mov    %ebx,%edx
  800ac7:	eb 17                	jmp    800ae0 <open+0x86>
	}

	return fd2num(fd);
  800ac9:	83 ec 0c             	sub    $0xc,%esp
  800acc:	ff 75 f4             	pushl  -0xc(%ebp)
  800acf:	e8 fc f7 ff ff       	call   8002d0 <fd2num>
  800ad4:	89 c2                	mov    %eax,%edx
  800ad6:	83 c4 10             	add    $0x10,%esp
  800ad9:	eb 05                	jmp    800ae0 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800adb:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800ae0:	89 d0                	mov    %edx,%eax
  800ae2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ae5:	c9                   	leave  
  800ae6:	c3                   	ret    

00800ae7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800aed:	ba 00 00 00 00       	mov    $0x0,%edx
  800af2:	b8 08 00 00 00       	mov    $0x8,%eax
  800af7:	e8 83 fd ff ff       	call   80087f <fsipc>
}
  800afc:	c9                   	leave  
  800afd:	c3                   	ret    

00800afe <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
  800b01:	56                   	push   %esi
  800b02:	53                   	push   %ebx
  800b03:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800b06:	83 ec 0c             	sub    $0xc,%esp
  800b09:	ff 75 08             	pushl  0x8(%ebp)
  800b0c:	e8 cf f7 ff ff       	call   8002e0 <fd2data>
  800b11:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800b13:	83 c4 08             	add    $0x8,%esp
  800b16:	68 43 1e 80 00       	push   $0x801e43
  800b1b:	53                   	push   %ebx
  800b1c:	e8 07 0b 00 00       	call   801628 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800b21:	8b 46 04             	mov    0x4(%esi),%eax
  800b24:	2b 06                	sub    (%esi),%eax
  800b26:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800b2c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800b33:	00 00 00 
	stat->st_dev = &devpipe;
  800b36:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  800b3d:	30 80 00 
	return 0;
}
  800b40:	b8 00 00 00 00       	mov    $0x0,%eax
  800b45:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b48:	5b                   	pop    %ebx
  800b49:	5e                   	pop    %esi
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	53                   	push   %ebx
  800b50:	83 ec 0c             	sub    $0xc,%esp
  800b53:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800b56:	53                   	push   %ebx
  800b57:	6a 00                	push   $0x0
  800b59:	e8 9f f6 ff ff       	call   8001fd <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800b5e:	89 1c 24             	mov    %ebx,(%esp)
  800b61:	e8 7a f7 ff ff       	call   8002e0 <fd2data>
  800b66:	83 c4 08             	add    $0x8,%esp
  800b69:	50                   	push   %eax
  800b6a:	6a 00                	push   $0x0
  800b6c:	e8 8c f6 ff ff       	call   8001fd <sys_page_unmap>
}
  800b71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b74:	c9                   	leave  
  800b75:	c3                   	ret    

00800b76 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	57                   	push   %edi
  800b7a:	56                   	push   %esi
  800b7b:	53                   	push   %ebx
  800b7c:	83 ec 1c             	sub    $0x1c,%esp
  800b7f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b82:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  800b84:	a1 04 40 80 00       	mov    0x804004,%eax
  800b89:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  800b8c:	83 ec 0c             	sub    $0xc,%esp
  800b8f:	ff 75 e0             	pushl  -0x20(%ebp)
  800b92:	e8 d1 0e 00 00       	call   801a68 <pageref>
  800b97:	89 c3                	mov    %eax,%ebx
  800b99:	89 3c 24             	mov    %edi,(%esp)
  800b9c:	e8 c7 0e 00 00       	call   801a68 <pageref>
  800ba1:	83 c4 10             	add    $0x10,%esp
  800ba4:	39 c3                	cmp    %eax,%ebx
  800ba6:	0f 94 c1             	sete   %cl
  800ba9:	0f b6 c9             	movzbl %cl,%ecx
  800bac:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  800baf:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800bb5:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800bb8:	39 ce                	cmp    %ecx,%esi
  800bba:	74 1b                	je     800bd7 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  800bbc:	39 c3                	cmp    %eax,%ebx
  800bbe:	75 c4                	jne    800b84 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800bc0:	8b 42 58             	mov    0x58(%edx),%eax
  800bc3:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bc6:	50                   	push   %eax
  800bc7:	56                   	push   %esi
  800bc8:	68 4a 1e 80 00       	push   $0x801e4a
  800bcd:	e8 e4 04 00 00       	call   8010b6 <cprintf>
  800bd2:	83 c4 10             	add    $0x10,%esp
  800bd5:	eb ad                	jmp    800b84 <_pipeisclosed+0xe>
	}
}
  800bd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bdd:	5b                   	pop    %ebx
  800bde:	5e                   	pop    %esi
  800bdf:	5f                   	pop    %edi
  800be0:	5d                   	pop    %ebp
  800be1:	c3                   	ret    

00800be2 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	57                   	push   %edi
  800be6:	56                   	push   %esi
  800be7:	53                   	push   %ebx
  800be8:	83 ec 28             	sub    $0x28,%esp
  800beb:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  800bee:	56                   	push   %esi
  800bef:	e8 ec f6 ff ff       	call   8002e0 <fd2data>
  800bf4:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800bf6:	83 c4 10             	add    $0x10,%esp
  800bf9:	bf 00 00 00 00       	mov    $0x0,%edi
  800bfe:	eb 4b                	jmp    800c4b <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  800c00:	89 da                	mov    %ebx,%edx
  800c02:	89 f0                	mov    %esi,%eax
  800c04:	e8 6d ff ff ff       	call   800b76 <_pipeisclosed>
  800c09:	85 c0                	test   %eax,%eax
  800c0b:	75 48                	jne    800c55 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  800c0d:	e8 7a f5 ff ff       	call   80018c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800c12:	8b 43 04             	mov    0x4(%ebx),%eax
  800c15:	8b 0b                	mov    (%ebx),%ecx
  800c17:	8d 51 20             	lea    0x20(%ecx),%edx
  800c1a:	39 d0                	cmp    %edx,%eax
  800c1c:	73 e2                	jae    800c00 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800c1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c21:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800c25:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800c28:	89 c2                	mov    %eax,%edx
  800c2a:	c1 fa 1f             	sar    $0x1f,%edx
  800c2d:	89 d1                	mov    %edx,%ecx
  800c2f:	c1 e9 1b             	shr    $0x1b,%ecx
  800c32:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800c35:	83 e2 1f             	and    $0x1f,%edx
  800c38:	29 ca                	sub    %ecx,%edx
  800c3a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800c3e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800c42:	83 c0 01             	add    $0x1,%eax
  800c45:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800c48:	83 c7 01             	add    $0x1,%edi
  800c4b:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c4e:	75 c2                	jne    800c12 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  800c50:	8b 45 10             	mov    0x10(%ebp),%eax
  800c53:	eb 05                	jmp    800c5a <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800c55:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  800c5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c5d:	5b                   	pop    %ebx
  800c5e:	5e                   	pop    %esi
  800c5f:	5f                   	pop    %edi
  800c60:	5d                   	pop    %ebp
  800c61:	c3                   	ret    

00800c62 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	57                   	push   %edi
  800c66:	56                   	push   %esi
  800c67:	53                   	push   %ebx
  800c68:	83 ec 18             	sub    $0x18,%esp
  800c6b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  800c6e:	57                   	push   %edi
  800c6f:	e8 6c f6 ff ff       	call   8002e0 <fd2data>
  800c74:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800c76:	83 c4 10             	add    $0x10,%esp
  800c79:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c7e:	eb 3d                	jmp    800cbd <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  800c80:	85 db                	test   %ebx,%ebx
  800c82:	74 04                	je     800c88 <devpipe_read+0x26>
				return i;
  800c84:	89 d8                	mov    %ebx,%eax
  800c86:	eb 44                	jmp    800ccc <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  800c88:	89 f2                	mov    %esi,%edx
  800c8a:	89 f8                	mov    %edi,%eax
  800c8c:	e8 e5 fe ff ff       	call   800b76 <_pipeisclosed>
  800c91:	85 c0                	test   %eax,%eax
  800c93:	75 32                	jne    800cc7 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  800c95:	e8 f2 f4 ff ff       	call   80018c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  800c9a:	8b 06                	mov    (%esi),%eax
  800c9c:	3b 46 04             	cmp    0x4(%esi),%eax
  800c9f:	74 df                	je     800c80 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800ca1:	99                   	cltd   
  800ca2:	c1 ea 1b             	shr    $0x1b,%edx
  800ca5:	01 d0                	add    %edx,%eax
  800ca7:	83 e0 1f             	and    $0x1f,%eax
  800caa:	29 d0                	sub    %edx,%eax
  800cac:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  800cb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb4:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  800cb7:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800cba:	83 c3 01             	add    $0x1,%ebx
  800cbd:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800cc0:	75 d8                	jne    800c9a <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  800cc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc5:	eb 05                	jmp    800ccc <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800cc7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  800ccc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ccf:	5b                   	pop    %ebx
  800cd0:	5e                   	pop    %esi
  800cd1:	5f                   	pop    %edi
  800cd2:	5d                   	pop    %ebp
  800cd3:	c3                   	ret    

00800cd4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	56                   	push   %esi
  800cd8:	53                   	push   %ebx
  800cd9:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  800cdc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800cdf:	50                   	push   %eax
  800ce0:	e8 13 f6 ff ff       	call   8002f8 <fd_alloc>
  800ce5:	83 c4 10             	add    $0x10,%esp
  800ce8:	89 c2                	mov    %eax,%edx
  800cea:	85 c0                	test   %eax,%eax
  800cec:	0f 88 2c 01 00 00    	js     800e1e <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800cf2:	83 ec 04             	sub    $0x4,%esp
  800cf5:	68 07 04 00 00       	push   $0x407
  800cfa:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfd:	6a 00                	push   $0x0
  800cff:	e8 af f4 ff ff       	call   8001b3 <sys_page_alloc>
  800d04:	83 c4 10             	add    $0x10,%esp
  800d07:	89 c2                	mov    %eax,%edx
  800d09:	85 c0                	test   %eax,%eax
  800d0b:	0f 88 0d 01 00 00    	js     800e1e <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  800d11:	83 ec 0c             	sub    $0xc,%esp
  800d14:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d17:	50                   	push   %eax
  800d18:	e8 db f5 ff ff       	call   8002f8 <fd_alloc>
  800d1d:	89 c3                	mov    %eax,%ebx
  800d1f:	83 c4 10             	add    $0x10,%esp
  800d22:	85 c0                	test   %eax,%eax
  800d24:	0f 88 e2 00 00 00    	js     800e0c <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d2a:	83 ec 04             	sub    $0x4,%esp
  800d2d:	68 07 04 00 00       	push   $0x407
  800d32:	ff 75 f0             	pushl  -0x10(%ebp)
  800d35:	6a 00                	push   $0x0
  800d37:	e8 77 f4 ff ff       	call   8001b3 <sys_page_alloc>
  800d3c:	89 c3                	mov    %eax,%ebx
  800d3e:	83 c4 10             	add    $0x10,%esp
  800d41:	85 c0                	test   %eax,%eax
  800d43:	0f 88 c3 00 00 00    	js     800e0c <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  800d49:	83 ec 0c             	sub    $0xc,%esp
  800d4c:	ff 75 f4             	pushl  -0xc(%ebp)
  800d4f:	e8 8c f5 ff ff       	call   8002e0 <fd2data>
  800d54:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d56:	83 c4 0c             	add    $0xc,%esp
  800d59:	68 07 04 00 00       	push   $0x407
  800d5e:	50                   	push   %eax
  800d5f:	6a 00                	push   $0x0
  800d61:	e8 4d f4 ff ff       	call   8001b3 <sys_page_alloc>
  800d66:	89 c3                	mov    %eax,%ebx
  800d68:	83 c4 10             	add    $0x10,%esp
  800d6b:	85 c0                	test   %eax,%eax
  800d6d:	0f 88 89 00 00 00    	js     800dfc <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d73:	83 ec 0c             	sub    $0xc,%esp
  800d76:	ff 75 f0             	pushl  -0x10(%ebp)
  800d79:	e8 62 f5 ff ff       	call   8002e0 <fd2data>
  800d7e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800d85:	50                   	push   %eax
  800d86:	6a 00                	push   $0x0
  800d88:	56                   	push   %esi
  800d89:	6a 00                	push   $0x0
  800d8b:	e8 47 f4 ff ff       	call   8001d7 <sys_page_map>
  800d90:	89 c3                	mov    %eax,%ebx
  800d92:	83 c4 20             	add    $0x20,%esp
  800d95:	85 c0                	test   %eax,%eax
  800d97:	78 55                	js     800dee <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  800d99:	8b 15 24 30 80 00    	mov    0x803024,%edx
  800d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800da2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800da7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  800dae:	8b 15 24 30 80 00    	mov    0x803024,%edx
  800db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dbc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  800dc3:	83 ec 0c             	sub    $0xc,%esp
  800dc6:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc9:	e8 02 f5 ff ff       	call   8002d0 <fd2num>
  800dce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dd1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800dd3:	83 c4 04             	add    $0x4,%esp
  800dd6:	ff 75 f0             	pushl  -0x10(%ebp)
  800dd9:	e8 f2 f4 ff ff       	call   8002d0 <fd2num>
  800dde:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800de1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800de4:	83 c4 10             	add    $0x10,%esp
  800de7:	ba 00 00 00 00       	mov    $0x0,%edx
  800dec:	eb 30                	jmp    800e1e <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  800dee:	83 ec 08             	sub    $0x8,%esp
  800df1:	56                   	push   %esi
  800df2:	6a 00                	push   $0x0
  800df4:	e8 04 f4 ff ff       	call   8001fd <sys_page_unmap>
  800df9:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  800dfc:	83 ec 08             	sub    $0x8,%esp
  800dff:	ff 75 f0             	pushl  -0x10(%ebp)
  800e02:	6a 00                	push   $0x0
  800e04:	e8 f4 f3 ff ff       	call   8001fd <sys_page_unmap>
  800e09:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  800e0c:	83 ec 08             	sub    $0x8,%esp
  800e0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800e12:	6a 00                	push   $0x0
  800e14:	e8 e4 f3 ff ff       	call   8001fd <sys_page_unmap>
  800e19:	83 c4 10             	add    $0x10,%esp
  800e1c:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  800e1e:	89 d0                	mov    %edx,%eax
  800e20:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e23:	5b                   	pop    %ebx
  800e24:	5e                   	pop    %esi
  800e25:	5d                   	pop    %ebp
  800e26:	c3                   	ret    

00800e27 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e2d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e30:	50                   	push   %eax
  800e31:	ff 75 08             	pushl  0x8(%ebp)
  800e34:	e8 0e f5 ff ff       	call   800347 <fd_lookup>
  800e39:	83 c4 10             	add    $0x10,%esp
  800e3c:	85 c0                	test   %eax,%eax
  800e3e:	78 18                	js     800e58 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  800e40:	83 ec 0c             	sub    $0xc,%esp
  800e43:	ff 75 f4             	pushl  -0xc(%ebp)
  800e46:	e8 95 f4 ff ff       	call   8002e0 <fd2data>
	return _pipeisclosed(fd, p);
  800e4b:	89 c2                	mov    %eax,%edx
  800e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e50:	e8 21 fd ff ff       	call   800b76 <_pipeisclosed>
  800e55:	83 c4 10             	add    $0x10,%esp
}
  800e58:	c9                   	leave  
  800e59:	c3                   	ret    

00800e5a <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800e5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e62:	5d                   	pop    %ebp
  800e63:	c3                   	ret    

00800e64 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800e6a:	68 62 1e 80 00       	push   $0x801e62
  800e6f:	ff 75 0c             	pushl  0xc(%ebp)
  800e72:	e8 b1 07 00 00       	call   801628 <strcpy>
	return 0;
}
  800e77:	b8 00 00 00 00       	mov    $0x0,%eax
  800e7c:	c9                   	leave  
  800e7d:	c3                   	ret    

00800e7e <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	57                   	push   %edi
  800e82:	56                   	push   %esi
  800e83:	53                   	push   %ebx
  800e84:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800e8a:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800e8f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800e95:	eb 2d                	jmp    800ec4 <devcons_write+0x46>
		m = n - tot;
  800e97:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e9a:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  800e9c:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  800e9f:	ba 7f 00 00 00       	mov    $0x7f,%edx
  800ea4:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800ea7:	83 ec 04             	sub    $0x4,%esp
  800eaa:	53                   	push   %ebx
  800eab:	03 45 0c             	add    0xc(%ebp),%eax
  800eae:	50                   	push   %eax
  800eaf:	57                   	push   %edi
  800eb0:	e8 06 09 00 00       	call   8017bb <memmove>
		sys_cputs(buf, m);
  800eb5:	83 c4 08             	add    $0x8,%esp
  800eb8:	53                   	push   %ebx
  800eb9:	57                   	push   %edi
  800eba:	e8 3d f2 ff ff       	call   8000fc <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800ebf:	01 de                	add    %ebx,%esi
  800ec1:	83 c4 10             	add    $0x10,%esp
  800ec4:	89 f0                	mov    %esi,%eax
  800ec6:	3b 75 10             	cmp    0x10(%ebp),%esi
  800ec9:	72 cc                	jb     800e97 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  800ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ece:	5b                   	pop    %ebx
  800ecf:	5e                   	pop    %esi
  800ed0:	5f                   	pop    %edi
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    

00800ed3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	83 ec 08             	sub    $0x8,%esp
  800ed9:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  800ede:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee2:	74 2a                	je     800f0e <devcons_read+0x3b>
  800ee4:	eb 05                	jmp    800eeb <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800ee6:	e8 a1 f2 ff ff       	call   80018c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800eeb:	e8 32 f2 ff ff       	call   800122 <sys_cgetc>
  800ef0:	85 c0                	test   %eax,%eax
  800ef2:	74 f2                	je     800ee6 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800ef4:	85 c0                	test   %eax,%eax
  800ef6:	78 16                	js     800f0e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  800ef8:	83 f8 04             	cmp    $0x4,%eax
  800efb:	74 0c                	je     800f09 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  800efd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f00:	88 02                	mov    %al,(%edx)
	return 1;
  800f02:	b8 01 00 00 00       	mov    $0x1,%eax
  800f07:	eb 05                	jmp    800f0e <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  800f09:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800f0e:	c9                   	leave  
  800f0f:	c3                   	ret    

00800f10 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800f1c:	6a 01                	push   $0x1
  800f1e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f21:	50                   	push   %eax
  800f22:	e8 d5 f1 ff ff       	call   8000fc <sys_cputs>
}
  800f27:	83 c4 10             	add    $0x10,%esp
  800f2a:	c9                   	leave  
  800f2b:	c3                   	ret    

00800f2c <getchar>:

int
getchar(void)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800f32:	6a 01                	push   $0x1
  800f34:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f37:	50                   	push   %eax
  800f38:	6a 00                	push   $0x0
  800f3a:	e8 6d f6 ff ff       	call   8005ac <read>
	if (r < 0)
  800f3f:	83 c4 10             	add    $0x10,%esp
  800f42:	85 c0                	test   %eax,%eax
  800f44:	78 0f                	js     800f55 <getchar+0x29>
		return r;
	if (r < 1)
  800f46:	85 c0                	test   %eax,%eax
  800f48:	7e 06                	jle    800f50 <getchar+0x24>
		return -E_EOF;
	return c;
  800f4a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800f4e:	eb 05                	jmp    800f55 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800f50:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  800f55:	c9                   	leave  
  800f56:	c3                   	ret    

00800f57 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800f57:	55                   	push   %ebp
  800f58:	89 e5                	mov    %esp,%ebp
  800f5a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f5d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f60:	50                   	push   %eax
  800f61:	ff 75 08             	pushl  0x8(%ebp)
  800f64:	e8 de f3 ff ff       	call   800347 <fd_lookup>
  800f69:	83 c4 10             	add    $0x10,%esp
  800f6c:	85 c0                	test   %eax,%eax
  800f6e:	78 11                	js     800f81 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f73:	8b 15 40 30 80 00    	mov    0x803040,%edx
  800f79:	39 10                	cmp    %edx,(%eax)
  800f7b:	0f 94 c0             	sete   %al
  800f7e:	0f b6 c0             	movzbl %al,%eax
}
  800f81:	c9                   	leave  
  800f82:	c3                   	ret    

00800f83 <opencons>:

int
opencons(void)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800f89:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f8c:	50                   	push   %eax
  800f8d:	e8 66 f3 ff ff       	call   8002f8 <fd_alloc>
  800f92:	83 c4 10             	add    $0x10,%esp
		return r;
  800f95:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800f97:	85 c0                	test   %eax,%eax
  800f99:	78 3e                	js     800fd9 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800f9b:	83 ec 04             	sub    $0x4,%esp
  800f9e:	68 07 04 00 00       	push   $0x407
  800fa3:	ff 75 f4             	pushl  -0xc(%ebp)
  800fa6:	6a 00                	push   $0x0
  800fa8:	e8 06 f2 ff ff       	call   8001b3 <sys_page_alloc>
  800fad:	83 c4 10             	add    $0x10,%esp
		return r;
  800fb0:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800fb2:	85 c0                	test   %eax,%eax
  800fb4:	78 23                	js     800fd9 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800fb6:	8b 15 40 30 80 00    	mov    0x803040,%edx
  800fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fbf:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fc4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800fcb:	83 ec 0c             	sub    $0xc,%esp
  800fce:	50                   	push   %eax
  800fcf:	e8 fc f2 ff ff       	call   8002d0 <fd2num>
  800fd4:	89 c2                	mov    %eax,%edx
  800fd6:	83 c4 10             	add    $0x10,%esp
}
  800fd9:	89 d0                	mov    %edx,%eax
  800fdb:	c9                   	leave  
  800fdc:	c3                   	ret    

00800fdd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	56                   	push   %esi
  800fe1:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800fe2:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800fe5:	8b 35 04 30 80 00    	mov    0x803004,%esi
  800feb:	e8 78 f1 ff ff       	call   800168 <sys_getenvid>
  800ff0:	83 ec 0c             	sub    $0xc,%esp
  800ff3:	ff 75 0c             	pushl  0xc(%ebp)
  800ff6:	ff 75 08             	pushl  0x8(%ebp)
  800ff9:	56                   	push   %esi
  800ffa:	50                   	push   %eax
  800ffb:	68 70 1e 80 00       	push   $0x801e70
  801000:	e8 b1 00 00 00       	call   8010b6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801005:	83 c4 18             	add    $0x18,%esp
  801008:	53                   	push   %ebx
  801009:	ff 75 10             	pushl  0x10(%ebp)
  80100c:	e8 54 00 00 00       	call   801065 <vcprintf>
	cprintf("\n");
  801011:	c7 04 24 5b 1e 80 00 	movl   $0x801e5b,(%esp)
  801018:	e8 99 00 00 00       	call   8010b6 <cprintf>
  80101d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801020:	cc                   	int3   
  801021:	eb fd                	jmp    801020 <_panic+0x43>

00801023 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801023:	55                   	push   %ebp
  801024:	89 e5                	mov    %esp,%ebp
  801026:	53                   	push   %ebx
  801027:	83 ec 04             	sub    $0x4,%esp
  80102a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80102d:	8b 13                	mov    (%ebx),%edx
  80102f:	8d 42 01             	lea    0x1(%edx),%eax
  801032:	89 03                	mov    %eax,(%ebx)
  801034:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801037:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80103b:	3d ff 00 00 00       	cmp    $0xff,%eax
  801040:	75 1a                	jne    80105c <putch+0x39>
		sys_cputs(b->buf, b->idx);
  801042:	83 ec 08             	sub    $0x8,%esp
  801045:	68 ff 00 00 00       	push   $0xff
  80104a:	8d 43 08             	lea    0x8(%ebx),%eax
  80104d:	50                   	push   %eax
  80104e:	e8 a9 f0 ff ff       	call   8000fc <sys_cputs>
		b->idx = 0;
  801053:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801059:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  80105c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801060:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801063:	c9                   	leave  
  801064:	c3                   	ret    

00801065 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80106e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801075:	00 00 00 
	b.cnt = 0;
  801078:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80107f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801082:	ff 75 0c             	pushl  0xc(%ebp)
  801085:	ff 75 08             	pushl  0x8(%ebp)
  801088:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80108e:	50                   	push   %eax
  80108f:	68 23 10 80 00       	push   $0x801023
  801094:	e8 86 01 00 00       	call   80121f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801099:	83 c4 08             	add    $0x8,%esp
  80109c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8010a2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8010a8:	50                   	push   %eax
  8010a9:	e8 4e f0 ff ff       	call   8000fc <sys_cputs>

	return b.cnt;
}
  8010ae:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8010bc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8010bf:	50                   	push   %eax
  8010c0:	ff 75 08             	pushl  0x8(%ebp)
  8010c3:	e8 9d ff ff ff       	call   801065 <vcprintf>
	va_end(ap);

	return cnt;
}
  8010c8:	c9                   	leave  
  8010c9:	c3                   	ret    

008010ca <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
  8010cd:	57                   	push   %edi
  8010ce:	56                   	push   %esi
  8010cf:	53                   	push   %ebx
  8010d0:	83 ec 1c             	sub    $0x1c,%esp
  8010d3:	89 c7                	mov    %eax,%edi
  8010d5:	89 d6                	mov    %edx,%esi
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8010e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010eb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8010ee:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8010f1:	39 d3                	cmp    %edx,%ebx
  8010f3:	72 05                	jb     8010fa <printnum+0x30>
  8010f5:	39 45 10             	cmp    %eax,0x10(%ebp)
  8010f8:	77 45                	ja     80113f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8010fa:	83 ec 0c             	sub    $0xc,%esp
  8010fd:	ff 75 18             	pushl  0x18(%ebp)
  801100:	8b 45 14             	mov    0x14(%ebp),%eax
  801103:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801106:	53                   	push   %ebx
  801107:	ff 75 10             	pushl  0x10(%ebp)
  80110a:	83 ec 08             	sub    $0x8,%esp
  80110d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801110:	ff 75 e0             	pushl  -0x20(%ebp)
  801113:	ff 75 dc             	pushl  -0x24(%ebp)
  801116:	ff 75 d8             	pushl  -0x28(%ebp)
  801119:	e8 92 09 00 00       	call   801ab0 <__udivdi3>
  80111e:	83 c4 18             	add    $0x18,%esp
  801121:	52                   	push   %edx
  801122:	50                   	push   %eax
  801123:	89 f2                	mov    %esi,%edx
  801125:	89 f8                	mov    %edi,%eax
  801127:	e8 9e ff ff ff       	call   8010ca <printnum>
  80112c:	83 c4 20             	add    $0x20,%esp
  80112f:	eb 18                	jmp    801149 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801131:	83 ec 08             	sub    $0x8,%esp
  801134:	56                   	push   %esi
  801135:	ff 75 18             	pushl  0x18(%ebp)
  801138:	ff d7                	call   *%edi
  80113a:	83 c4 10             	add    $0x10,%esp
  80113d:	eb 03                	jmp    801142 <printnum+0x78>
  80113f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801142:	83 eb 01             	sub    $0x1,%ebx
  801145:	85 db                	test   %ebx,%ebx
  801147:	7f e8                	jg     801131 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801149:	83 ec 08             	sub    $0x8,%esp
  80114c:	56                   	push   %esi
  80114d:	83 ec 04             	sub    $0x4,%esp
  801150:	ff 75 e4             	pushl  -0x1c(%ebp)
  801153:	ff 75 e0             	pushl  -0x20(%ebp)
  801156:	ff 75 dc             	pushl  -0x24(%ebp)
  801159:	ff 75 d8             	pushl  -0x28(%ebp)
  80115c:	e8 7f 0a 00 00       	call   801be0 <__umoddi3>
  801161:	83 c4 14             	add    $0x14,%esp
  801164:	0f be 80 93 1e 80 00 	movsbl 0x801e93(%eax),%eax
  80116b:	50                   	push   %eax
  80116c:	ff d7                	call   *%edi
}
  80116e:	83 c4 10             	add    $0x10,%esp
  801171:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801174:	5b                   	pop    %ebx
  801175:	5e                   	pop    %esi
  801176:	5f                   	pop    %edi
  801177:	5d                   	pop    %ebp
  801178:	c3                   	ret    

00801179 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80117c:	83 fa 01             	cmp    $0x1,%edx
  80117f:	7e 0e                	jle    80118f <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801181:	8b 10                	mov    (%eax),%edx
  801183:	8d 4a 08             	lea    0x8(%edx),%ecx
  801186:	89 08                	mov    %ecx,(%eax)
  801188:	8b 02                	mov    (%edx),%eax
  80118a:	8b 52 04             	mov    0x4(%edx),%edx
  80118d:	eb 22                	jmp    8011b1 <getuint+0x38>
	else if (lflag)
  80118f:	85 d2                	test   %edx,%edx
  801191:	74 10                	je     8011a3 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801193:	8b 10                	mov    (%eax),%edx
  801195:	8d 4a 04             	lea    0x4(%edx),%ecx
  801198:	89 08                	mov    %ecx,(%eax)
  80119a:	8b 02                	mov    (%edx),%eax
  80119c:	ba 00 00 00 00       	mov    $0x0,%edx
  8011a1:	eb 0e                	jmp    8011b1 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8011a3:	8b 10                	mov    (%eax),%edx
  8011a5:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011a8:	89 08                	mov    %ecx,(%eax)
  8011aa:	8b 02                	mov    (%edx),%eax
  8011ac:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8011b1:	5d                   	pop    %ebp
  8011b2:	c3                   	ret    

008011b3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8011b3:	55                   	push   %ebp
  8011b4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8011b6:	83 fa 01             	cmp    $0x1,%edx
  8011b9:	7e 0e                	jle    8011c9 <getint+0x16>
		return va_arg(*ap, long long);
  8011bb:	8b 10                	mov    (%eax),%edx
  8011bd:	8d 4a 08             	lea    0x8(%edx),%ecx
  8011c0:	89 08                	mov    %ecx,(%eax)
  8011c2:	8b 02                	mov    (%edx),%eax
  8011c4:	8b 52 04             	mov    0x4(%edx),%edx
  8011c7:	eb 1a                	jmp    8011e3 <getint+0x30>
	else if (lflag)
  8011c9:	85 d2                	test   %edx,%edx
  8011cb:	74 0c                	je     8011d9 <getint+0x26>
		return va_arg(*ap, long);
  8011cd:	8b 10                	mov    (%eax),%edx
  8011cf:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011d2:	89 08                	mov    %ecx,(%eax)
  8011d4:	8b 02                	mov    (%edx),%eax
  8011d6:	99                   	cltd   
  8011d7:	eb 0a                	jmp    8011e3 <getint+0x30>
	else
		return va_arg(*ap, int);
  8011d9:	8b 10                	mov    (%eax),%edx
  8011db:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011de:	89 08                	mov    %ecx,(%eax)
  8011e0:	8b 02                	mov    (%edx),%eax
  8011e2:	99                   	cltd   
}
  8011e3:	5d                   	pop    %ebp
  8011e4:	c3                   	ret    

008011e5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
  8011e8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8011eb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8011ef:	8b 10                	mov    (%eax),%edx
  8011f1:	3b 50 04             	cmp    0x4(%eax),%edx
  8011f4:	73 0a                	jae    801200 <sprintputch+0x1b>
		*b->buf++ = ch;
  8011f6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011f9:	89 08                	mov    %ecx,(%eax)
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	88 02                	mov    %al,(%edx)
}
  801200:	5d                   	pop    %ebp
  801201:	c3                   	ret    

00801202 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801202:	55                   	push   %ebp
  801203:	89 e5                	mov    %esp,%ebp
  801205:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  801208:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80120b:	50                   	push   %eax
  80120c:	ff 75 10             	pushl  0x10(%ebp)
  80120f:	ff 75 0c             	pushl  0xc(%ebp)
  801212:	ff 75 08             	pushl  0x8(%ebp)
  801215:	e8 05 00 00 00       	call   80121f <vprintfmt>
	va_end(ap);
}
  80121a:	83 c4 10             	add    $0x10,%esp
  80121d:	c9                   	leave  
  80121e:	c3                   	ret    

0080121f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80121f:	55                   	push   %ebp
  801220:	89 e5                	mov    %esp,%ebp
  801222:	57                   	push   %edi
  801223:	56                   	push   %esi
  801224:	53                   	push   %ebx
  801225:	83 ec 2c             	sub    $0x2c,%esp
  801228:	8b 75 08             	mov    0x8(%ebp),%esi
  80122b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80122e:	8b 7d 10             	mov    0x10(%ebp),%edi
  801231:	eb 12                	jmp    801245 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801233:	85 c0                	test   %eax,%eax
  801235:	0f 84 44 03 00 00    	je     80157f <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  80123b:	83 ec 08             	sub    $0x8,%esp
  80123e:	53                   	push   %ebx
  80123f:	50                   	push   %eax
  801240:	ff d6                	call   *%esi
  801242:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801245:	83 c7 01             	add    $0x1,%edi
  801248:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80124c:	83 f8 25             	cmp    $0x25,%eax
  80124f:	75 e2                	jne    801233 <vprintfmt+0x14>
  801251:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  801255:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80125c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801263:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80126a:	ba 00 00 00 00       	mov    $0x0,%edx
  80126f:	eb 07                	jmp    801278 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801271:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  801274:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801278:	8d 47 01             	lea    0x1(%edi),%eax
  80127b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80127e:	0f b6 07             	movzbl (%edi),%eax
  801281:	0f b6 c8             	movzbl %al,%ecx
  801284:	83 e8 23             	sub    $0x23,%eax
  801287:	3c 55                	cmp    $0x55,%al
  801289:	0f 87 d5 02 00 00    	ja     801564 <vprintfmt+0x345>
  80128f:	0f b6 c0             	movzbl %al,%eax
  801292:	ff 24 85 e0 1f 80 00 	jmp    *0x801fe0(,%eax,4)
  801299:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80129c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8012a0:	eb d6                	jmp    801278 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8012a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012aa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8012ad:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8012b0:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8012b4:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8012b7:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8012ba:	83 fa 09             	cmp    $0x9,%edx
  8012bd:	77 39                	ja     8012f8 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8012bf:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8012c2:	eb e9                	jmp    8012ad <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8012c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c7:	8d 48 04             	lea    0x4(%eax),%ecx
  8012ca:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8012cd:	8b 00                	mov    (%eax),%eax
  8012cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8012d5:	eb 27                	jmp    8012fe <vprintfmt+0xdf>
  8012d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012da:	85 c0                	test   %eax,%eax
  8012dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012e1:	0f 49 c8             	cmovns %eax,%ecx
  8012e4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8012ea:	eb 8c                	jmp    801278 <vprintfmt+0x59>
  8012ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8012ef:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8012f6:	eb 80                	jmp    801278 <vprintfmt+0x59>
  8012f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012fb:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  8012fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801302:	0f 89 70 ff ff ff    	jns    801278 <vprintfmt+0x59>
				width = precision, precision = -1;
  801308:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80130b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80130e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801315:	e9 5e ff ff ff       	jmp    801278 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80131a:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80131d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801320:	e9 53 ff ff ff       	jmp    801278 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801325:	8b 45 14             	mov    0x14(%ebp),%eax
  801328:	8d 50 04             	lea    0x4(%eax),%edx
  80132b:	89 55 14             	mov    %edx,0x14(%ebp)
  80132e:	83 ec 08             	sub    $0x8,%esp
  801331:	53                   	push   %ebx
  801332:	ff 30                	pushl  (%eax)
  801334:	ff d6                	call   *%esi
			break;
  801336:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801339:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  80133c:	e9 04 ff ff ff       	jmp    801245 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801341:	8b 45 14             	mov    0x14(%ebp),%eax
  801344:	8d 50 04             	lea    0x4(%eax),%edx
  801347:	89 55 14             	mov    %edx,0x14(%ebp)
  80134a:	8b 00                	mov    (%eax),%eax
  80134c:	99                   	cltd   
  80134d:	31 d0                	xor    %edx,%eax
  80134f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801351:	83 f8 0f             	cmp    $0xf,%eax
  801354:	7f 0b                	jg     801361 <vprintfmt+0x142>
  801356:	8b 14 85 40 21 80 00 	mov    0x802140(,%eax,4),%edx
  80135d:	85 d2                	test   %edx,%edx
  80135f:	75 18                	jne    801379 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  801361:	50                   	push   %eax
  801362:	68 ab 1e 80 00       	push   $0x801eab
  801367:	53                   	push   %ebx
  801368:	56                   	push   %esi
  801369:	e8 94 fe ff ff       	call   801202 <printfmt>
  80136e:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801371:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  801374:	e9 cc fe ff ff       	jmp    801245 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  801379:	52                   	push   %edx
  80137a:	68 29 1e 80 00       	push   $0x801e29
  80137f:	53                   	push   %ebx
  801380:	56                   	push   %esi
  801381:	e8 7c fe ff ff       	call   801202 <printfmt>
  801386:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801389:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80138c:	e9 b4 fe ff ff       	jmp    801245 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801391:	8b 45 14             	mov    0x14(%ebp),%eax
  801394:	8d 50 04             	lea    0x4(%eax),%edx
  801397:	89 55 14             	mov    %edx,0x14(%ebp)
  80139a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80139c:	85 ff                	test   %edi,%edi
  80139e:	b8 a4 1e 80 00       	mov    $0x801ea4,%eax
  8013a3:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8013a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013aa:	0f 8e 94 00 00 00    	jle    801444 <vprintfmt+0x225>
  8013b0:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8013b4:	0f 84 98 00 00 00    	je     801452 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8013ba:	83 ec 08             	sub    $0x8,%esp
  8013bd:	ff 75 d0             	pushl  -0x30(%ebp)
  8013c0:	57                   	push   %edi
  8013c1:	e8 41 02 00 00       	call   801607 <strnlen>
  8013c6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8013c9:	29 c1                	sub    %eax,%ecx
  8013cb:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8013ce:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8013d1:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8013d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013d8:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8013db:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013dd:	eb 0f                	jmp    8013ee <vprintfmt+0x1cf>
					putch(padc, putdat);
  8013df:	83 ec 08             	sub    $0x8,%esp
  8013e2:	53                   	push   %ebx
  8013e3:	ff 75 e0             	pushl  -0x20(%ebp)
  8013e6:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013e8:	83 ef 01             	sub    $0x1,%edi
  8013eb:	83 c4 10             	add    $0x10,%esp
  8013ee:	85 ff                	test   %edi,%edi
  8013f0:	7f ed                	jg     8013df <vprintfmt+0x1c0>
  8013f2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8013f5:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8013f8:	85 c9                	test   %ecx,%ecx
  8013fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ff:	0f 49 c1             	cmovns %ecx,%eax
  801402:	29 c1                	sub    %eax,%ecx
  801404:	89 75 08             	mov    %esi,0x8(%ebp)
  801407:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80140a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80140d:	89 cb                	mov    %ecx,%ebx
  80140f:	eb 4d                	jmp    80145e <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801411:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801415:	74 1b                	je     801432 <vprintfmt+0x213>
  801417:	0f be c0             	movsbl %al,%eax
  80141a:	83 e8 20             	sub    $0x20,%eax
  80141d:	83 f8 5e             	cmp    $0x5e,%eax
  801420:	76 10                	jbe    801432 <vprintfmt+0x213>
					putch('?', putdat);
  801422:	83 ec 08             	sub    $0x8,%esp
  801425:	ff 75 0c             	pushl  0xc(%ebp)
  801428:	6a 3f                	push   $0x3f
  80142a:	ff 55 08             	call   *0x8(%ebp)
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	eb 0d                	jmp    80143f <vprintfmt+0x220>
				else
					putch(ch, putdat);
  801432:	83 ec 08             	sub    $0x8,%esp
  801435:	ff 75 0c             	pushl  0xc(%ebp)
  801438:	52                   	push   %edx
  801439:	ff 55 08             	call   *0x8(%ebp)
  80143c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80143f:	83 eb 01             	sub    $0x1,%ebx
  801442:	eb 1a                	jmp    80145e <vprintfmt+0x23f>
  801444:	89 75 08             	mov    %esi,0x8(%ebp)
  801447:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80144a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80144d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801450:	eb 0c                	jmp    80145e <vprintfmt+0x23f>
  801452:	89 75 08             	mov    %esi,0x8(%ebp)
  801455:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801458:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80145b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80145e:	83 c7 01             	add    $0x1,%edi
  801461:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801465:	0f be d0             	movsbl %al,%edx
  801468:	85 d2                	test   %edx,%edx
  80146a:	74 23                	je     80148f <vprintfmt+0x270>
  80146c:	85 f6                	test   %esi,%esi
  80146e:	78 a1                	js     801411 <vprintfmt+0x1f2>
  801470:	83 ee 01             	sub    $0x1,%esi
  801473:	79 9c                	jns    801411 <vprintfmt+0x1f2>
  801475:	89 df                	mov    %ebx,%edi
  801477:	8b 75 08             	mov    0x8(%ebp),%esi
  80147a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80147d:	eb 18                	jmp    801497 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80147f:	83 ec 08             	sub    $0x8,%esp
  801482:	53                   	push   %ebx
  801483:	6a 20                	push   $0x20
  801485:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801487:	83 ef 01             	sub    $0x1,%edi
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	eb 08                	jmp    801497 <vprintfmt+0x278>
  80148f:	89 df                	mov    %ebx,%edi
  801491:	8b 75 08             	mov    0x8(%ebp),%esi
  801494:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801497:	85 ff                	test   %edi,%edi
  801499:	7f e4                	jg     80147f <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80149b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80149e:	e9 a2 fd ff ff       	jmp    801245 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8014a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8014a6:	e8 08 fd ff ff       	call   8011b3 <getint>
  8014ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8014ae:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8014b1:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8014b6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8014ba:	79 74                	jns    801530 <vprintfmt+0x311>
				putch('-', putdat);
  8014bc:	83 ec 08             	sub    $0x8,%esp
  8014bf:	53                   	push   %ebx
  8014c0:	6a 2d                	push   $0x2d
  8014c2:	ff d6                	call   *%esi
				num = -(long long) num;
  8014c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014ca:	f7 d8                	neg    %eax
  8014cc:	83 d2 00             	adc    $0x0,%edx
  8014cf:	f7 da                	neg    %edx
  8014d1:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8014d4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014d9:	eb 55                	jmp    801530 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8014db:	8d 45 14             	lea    0x14(%ebp),%eax
  8014de:	e8 96 fc ff ff       	call   801179 <getuint>
			base = 10;
  8014e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8014e8:	eb 46                	jmp    801530 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8014ea:	8d 45 14             	lea    0x14(%ebp),%eax
  8014ed:	e8 87 fc ff ff       	call   801179 <getuint>
			base = 8;
  8014f2:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8014f7:	eb 37                	jmp    801530 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  8014f9:	83 ec 08             	sub    $0x8,%esp
  8014fc:	53                   	push   %ebx
  8014fd:	6a 30                	push   $0x30
  8014ff:	ff d6                	call   *%esi
			putch('x', putdat);
  801501:	83 c4 08             	add    $0x8,%esp
  801504:	53                   	push   %ebx
  801505:	6a 78                	push   $0x78
  801507:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  801509:	8b 45 14             	mov    0x14(%ebp),%eax
  80150c:	8d 50 04             	lea    0x4(%eax),%edx
  80150f:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801512:	8b 00                	mov    (%eax),%eax
  801514:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  801519:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80151c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801521:	eb 0d                	jmp    801530 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801523:	8d 45 14             	lea    0x14(%ebp),%eax
  801526:	e8 4e fc ff ff       	call   801179 <getuint>
			base = 16;
  80152b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801530:	83 ec 0c             	sub    $0xc,%esp
  801533:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801537:	57                   	push   %edi
  801538:	ff 75 e0             	pushl  -0x20(%ebp)
  80153b:	51                   	push   %ecx
  80153c:	52                   	push   %edx
  80153d:	50                   	push   %eax
  80153e:	89 da                	mov    %ebx,%edx
  801540:	89 f0                	mov    %esi,%eax
  801542:	e8 83 fb ff ff       	call   8010ca <printnum>
			break;
  801547:	83 c4 20             	add    $0x20,%esp
  80154a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80154d:	e9 f3 fc ff ff       	jmp    801245 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801552:	83 ec 08             	sub    $0x8,%esp
  801555:	53                   	push   %ebx
  801556:	51                   	push   %ecx
  801557:	ff d6                	call   *%esi
			break;
  801559:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80155c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  80155f:	e9 e1 fc ff ff       	jmp    801245 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801564:	83 ec 08             	sub    $0x8,%esp
  801567:	53                   	push   %ebx
  801568:	6a 25                	push   $0x25
  80156a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80156c:	83 c4 10             	add    $0x10,%esp
  80156f:	eb 03                	jmp    801574 <vprintfmt+0x355>
  801571:	83 ef 01             	sub    $0x1,%edi
  801574:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  801578:	75 f7                	jne    801571 <vprintfmt+0x352>
  80157a:	e9 c6 fc ff ff       	jmp    801245 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  80157f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801582:	5b                   	pop    %ebx
  801583:	5e                   	pop    %esi
  801584:	5f                   	pop    %edi
  801585:	5d                   	pop    %ebp
  801586:	c3                   	ret    

00801587 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	83 ec 18             	sub    $0x18,%esp
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
  801590:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801593:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801596:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80159a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80159d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8015a4:	85 c0                	test   %eax,%eax
  8015a6:	74 26                	je     8015ce <vsnprintf+0x47>
  8015a8:	85 d2                	test   %edx,%edx
  8015aa:	7e 22                	jle    8015ce <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8015ac:	ff 75 14             	pushl  0x14(%ebp)
  8015af:	ff 75 10             	pushl  0x10(%ebp)
  8015b2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8015b5:	50                   	push   %eax
  8015b6:	68 e5 11 80 00       	push   $0x8011e5
  8015bb:	e8 5f fc ff ff       	call   80121f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8015c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8015c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c9:	83 c4 10             	add    $0x10,%esp
  8015cc:	eb 05                	jmp    8015d3 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8015ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8015db:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8015de:	50                   	push   %eax
  8015df:	ff 75 10             	pushl  0x10(%ebp)
  8015e2:	ff 75 0c             	pushl  0xc(%ebp)
  8015e5:	ff 75 08             	pushl  0x8(%ebp)
  8015e8:	e8 9a ff ff ff       	call   801587 <vsnprintf>
	va_end(ap);

	return rc;
}
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
  8015f2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8015f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fa:	eb 03                	jmp    8015ff <strlen+0x10>
		n++;
  8015fc:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015ff:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801603:	75 f7                	jne    8015fc <strlen+0xd>
		n++;
	return n;
}
  801605:	5d                   	pop    %ebp
  801606:	c3                   	ret    

00801607 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80160d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801610:	ba 00 00 00 00       	mov    $0x0,%edx
  801615:	eb 03                	jmp    80161a <strnlen+0x13>
		n++;
  801617:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80161a:	39 c2                	cmp    %eax,%edx
  80161c:	74 08                	je     801626 <strnlen+0x1f>
  80161e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801622:	75 f3                	jne    801617 <strnlen+0x10>
  801624:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  801626:	5d                   	pop    %ebp
  801627:	c3                   	ret    

00801628 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
  80162b:	53                   	push   %ebx
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801632:	89 c2                	mov    %eax,%edx
  801634:	83 c2 01             	add    $0x1,%edx
  801637:	83 c1 01             	add    $0x1,%ecx
  80163a:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80163e:	88 5a ff             	mov    %bl,-0x1(%edx)
  801641:	84 db                	test   %bl,%bl
  801643:	75 ef                	jne    801634 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801645:	5b                   	pop    %ebx
  801646:	5d                   	pop    %ebp
  801647:	c3                   	ret    

00801648 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	53                   	push   %ebx
  80164c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80164f:	53                   	push   %ebx
  801650:	e8 9a ff ff ff       	call   8015ef <strlen>
  801655:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801658:	ff 75 0c             	pushl  0xc(%ebp)
  80165b:	01 d8                	add    %ebx,%eax
  80165d:	50                   	push   %eax
  80165e:	e8 c5 ff ff ff       	call   801628 <strcpy>
	return dst;
}
  801663:	89 d8                	mov    %ebx,%eax
  801665:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801668:	c9                   	leave  
  801669:	c3                   	ret    

0080166a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
  80166d:	56                   	push   %esi
  80166e:	53                   	push   %ebx
  80166f:	8b 75 08             	mov    0x8(%ebp),%esi
  801672:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801675:	89 f3                	mov    %esi,%ebx
  801677:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80167a:	89 f2                	mov    %esi,%edx
  80167c:	eb 0f                	jmp    80168d <strncpy+0x23>
		*dst++ = *src;
  80167e:	83 c2 01             	add    $0x1,%edx
  801681:	0f b6 01             	movzbl (%ecx),%eax
  801684:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801687:	80 39 01             	cmpb   $0x1,(%ecx)
  80168a:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80168d:	39 da                	cmp    %ebx,%edx
  80168f:	75 ed                	jne    80167e <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801691:	89 f0                	mov    %esi,%eax
  801693:	5b                   	pop    %ebx
  801694:	5e                   	pop    %esi
  801695:	5d                   	pop    %ebp
  801696:	c3                   	ret    

00801697 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	56                   	push   %esi
  80169b:	53                   	push   %ebx
  80169c:	8b 75 08             	mov    0x8(%ebp),%esi
  80169f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016a2:	8b 55 10             	mov    0x10(%ebp),%edx
  8016a5:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8016a7:	85 d2                	test   %edx,%edx
  8016a9:	74 21                	je     8016cc <strlcpy+0x35>
  8016ab:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8016af:	89 f2                	mov    %esi,%edx
  8016b1:	eb 09                	jmp    8016bc <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8016b3:	83 c2 01             	add    $0x1,%edx
  8016b6:	83 c1 01             	add    $0x1,%ecx
  8016b9:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016bc:	39 c2                	cmp    %eax,%edx
  8016be:	74 09                	je     8016c9 <strlcpy+0x32>
  8016c0:	0f b6 19             	movzbl (%ecx),%ebx
  8016c3:	84 db                	test   %bl,%bl
  8016c5:	75 ec                	jne    8016b3 <strlcpy+0x1c>
  8016c7:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  8016c9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016cc:	29 f0                	sub    %esi,%eax
}
  8016ce:	5b                   	pop    %ebx
  8016cf:	5e                   	pop    %esi
  8016d0:	5d                   	pop    %ebp
  8016d1:	c3                   	ret    

008016d2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
  8016d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016d8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8016db:	eb 06                	jmp    8016e3 <strcmp+0x11>
		p++, q++;
  8016dd:	83 c1 01             	add    $0x1,%ecx
  8016e0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016e3:	0f b6 01             	movzbl (%ecx),%eax
  8016e6:	84 c0                	test   %al,%al
  8016e8:	74 04                	je     8016ee <strcmp+0x1c>
  8016ea:	3a 02                	cmp    (%edx),%al
  8016ec:	74 ef                	je     8016dd <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016ee:	0f b6 c0             	movzbl %al,%eax
  8016f1:	0f b6 12             	movzbl (%edx),%edx
  8016f4:	29 d0                	sub    %edx,%eax
}
  8016f6:	5d                   	pop    %ebp
  8016f7:	c3                   	ret    

008016f8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
  8016fb:	53                   	push   %ebx
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801702:	89 c3                	mov    %eax,%ebx
  801704:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801707:	eb 06                	jmp    80170f <strncmp+0x17>
		n--, p++, q++;
  801709:	83 c0 01             	add    $0x1,%eax
  80170c:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80170f:	39 d8                	cmp    %ebx,%eax
  801711:	74 15                	je     801728 <strncmp+0x30>
  801713:	0f b6 08             	movzbl (%eax),%ecx
  801716:	84 c9                	test   %cl,%cl
  801718:	74 04                	je     80171e <strncmp+0x26>
  80171a:	3a 0a                	cmp    (%edx),%cl
  80171c:	74 eb                	je     801709 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80171e:	0f b6 00             	movzbl (%eax),%eax
  801721:	0f b6 12             	movzbl (%edx),%edx
  801724:	29 d0                	sub    %edx,%eax
  801726:	eb 05                	jmp    80172d <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801728:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  80172d:	5b                   	pop    %ebx
  80172e:	5d                   	pop    %ebp
  80172f:	c3                   	ret    

00801730 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80173a:	eb 07                	jmp    801743 <strchr+0x13>
		if (*s == c)
  80173c:	38 ca                	cmp    %cl,%dl
  80173e:	74 0f                	je     80174f <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801740:	83 c0 01             	add    $0x1,%eax
  801743:	0f b6 10             	movzbl (%eax),%edx
  801746:	84 d2                	test   %dl,%dl
  801748:	75 f2                	jne    80173c <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  80174a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174f:	5d                   	pop    %ebp
  801750:	c3                   	ret    

00801751 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
  801754:	8b 45 08             	mov    0x8(%ebp),%eax
  801757:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80175b:	eb 03                	jmp    801760 <strfind+0xf>
  80175d:	83 c0 01             	add    $0x1,%eax
  801760:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801763:	38 ca                	cmp    %cl,%dl
  801765:	74 04                	je     80176b <strfind+0x1a>
  801767:	84 d2                	test   %dl,%dl
  801769:	75 f2                	jne    80175d <strfind+0xc>
			break;
	return (char *) s;
}
  80176b:	5d                   	pop    %ebp
  80176c:	c3                   	ret    

0080176d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	57                   	push   %edi
  801771:	56                   	push   %esi
  801772:	53                   	push   %ebx
  801773:	8b 55 08             	mov    0x8(%ebp),%edx
  801776:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  801779:	85 c9                	test   %ecx,%ecx
  80177b:	74 37                	je     8017b4 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80177d:	f6 c2 03             	test   $0x3,%dl
  801780:	75 2a                	jne    8017ac <memset+0x3f>
  801782:	f6 c1 03             	test   $0x3,%cl
  801785:	75 25                	jne    8017ac <memset+0x3f>
		c &= 0xFF;
  801787:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80178b:	89 df                	mov    %ebx,%edi
  80178d:	c1 e7 08             	shl    $0x8,%edi
  801790:	89 de                	mov    %ebx,%esi
  801792:	c1 e6 18             	shl    $0x18,%esi
  801795:	89 d8                	mov    %ebx,%eax
  801797:	c1 e0 10             	shl    $0x10,%eax
  80179a:	09 f0                	or     %esi,%eax
  80179c:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  80179e:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8017a1:	89 f8                	mov    %edi,%eax
  8017a3:	09 d8                	or     %ebx,%eax
  8017a5:	89 d7                	mov    %edx,%edi
  8017a7:	fc                   	cld    
  8017a8:	f3 ab                	rep stos %eax,%es:(%edi)
  8017aa:	eb 08                	jmp    8017b4 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8017ac:	89 d7                	mov    %edx,%edi
  8017ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b1:	fc                   	cld    
  8017b2:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8017b4:	89 d0                	mov    %edx,%eax
  8017b6:	5b                   	pop    %ebx
  8017b7:	5e                   	pop    %esi
  8017b8:	5f                   	pop    %edi
  8017b9:	5d                   	pop    %ebp
  8017ba:	c3                   	ret    

008017bb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
  8017be:	57                   	push   %edi
  8017bf:	56                   	push   %esi
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8017c9:	39 c6                	cmp    %eax,%esi
  8017cb:	73 35                	jae    801802 <memmove+0x47>
  8017cd:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8017d0:	39 d0                	cmp    %edx,%eax
  8017d2:	73 2e                	jae    801802 <memmove+0x47>
		s += n;
		d += n;
  8017d4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8017d7:	89 d6                	mov    %edx,%esi
  8017d9:	09 fe                	or     %edi,%esi
  8017db:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8017e1:	75 13                	jne    8017f6 <memmove+0x3b>
  8017e3:	f6 c1 03             	test   $0x3,%cl
  8017e6:	75 0e                	jne    8017f6 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  8017e8:	83 ef 04             	sub    $0x4,%edi
  8017eb:	8d 72 fc             	lea    -0x4(%edx),%esi
  8017ee:	c1 e9 02             	shr    $0x2,%ecx
  8017f1:	fd                   	std    
  8017f2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8017f4:	eb 09                	jmp    8017ff <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8017f6:	83 ef 01             	sub    $0x1,%edi
  8017f9:	8d 72 ff             	lea    -0x1(%edx),%esi
  8017fc:	fd                   	std    
  8017fd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017ff:	fc                   	cld    
  801800:	eb 1d                	jmp    80181f <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801802:	89 f2                	mov    %esi,%edx
  801804:	09 c2                	or     %eax,%edx
  801806:	f6 c2 03             	test   $0x3,%dl
  801809:	75 0f                	jne    80181a <memmove+0x5f>
  80180b:	f6 c1 03             	test   $0x3,%cl
  80180e:	75 0a                	jne    80181a <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  801810:	c1 e9 02             	shr    $0x2,%ecx
  801813:	89 c7                	mov    %eax,%edi
  801815:	fc                   	cld    
  801816:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801818:	eb 05                	jmp    80181f <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80181a:	89 c7                	mov    %eax,%edi
  80181c:	fc                   	cld    
  80181d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80181f:	5e                   	pop    %esi
  801820:	5f                   	pop    %edi
  801821:	5d                   	pop    %ebp
  801822:	c3                   	ret    

00801823 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801826:	ff 75 10             	pushl  0x10(%ebp)
  801829:	ff 75 0c             	pushl  0xc(%ebp)
  80182c:	ff 75 08             	pushl  0x8(%ebp)
  80182f:	e8 87 ff ff ff       	call   8017bb <memmove>
}
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	56                   	push   %esi
  80183a:	53                   	push   %ebx
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801841:	89 c6                	mov    %eax,%esi
  801843:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801846:	eb 1a                	jmp    801862 <memcmp+0x2c>
		if (*s1 != *s2)
  801848:	0f b6 08             	movzbl (%eax),%ecx
  80184b:	0f b6 1a             	movzbl (%edx),%ebx
  80184e:	38 d9                	cmp    %bl,%cl
  801850:	74 0a                	je     80185c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  801852:	0f b6 c1             	movzbl %cl,%eax
  801855:	0f b6 db             	movzbl %bl,%ebx
  801858:	29 d8                	sub    %ebx,%eax
  80185a:	eb 0f                	jmp    80186b <memcmp+0x35>
		s1++, s2++;
  80185c:	83 c0 01             	add    $0x1,%eax
  80185f:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801862:	39 f0                	cmp    %esi,%eax
  801864:	75 e2                	jne    801848 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801866:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80186b:	5b                   	pop    %ebx
  80186c:	5e                   	pop    %esi
  80186d:	5d                   	pop    %ebp
  80186e:	c3                   	ret    

0080186f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	53                   	push   %ebx
  801873:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  801876:	89 c1                	mov    %eax,%ecx
  801878:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  80187b:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80187f:	eb 0a                	jmp    80188b <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  801881:	0f b6 10             	movzbl (%eax),%edx
  801884:	39 da                	cmp    %ebx,%edx
  801886:	74 07                	je     80188f <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801888:	83 c0 01             	add    $0x1,%eax
  80188b:	39 c8                	cmp    %ecx,%eax
  80188d:	72 f2                	jb     801881 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  80188f:	5b                   	pop    %ebx
  801890:	5d                   	pop    %ebp
  801891:	c3                   	ret    

00801892 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
  801895:	57                   	push   %edi
  801896:	56                   	push   %esi
  801897:	53                   	push   %ebx
  801898:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80189b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80189e:	eb 03                	jmp    8018a3 <strtol+0x11>
		s++;
  8018a0:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018a3:	0f b6 01             	movzbl (%ecx),%eax
  8018a6:	3c 20                	cmp    $0x20,%al
  8018a8:	74 f6                	je     8018a0 <strtol+0xe>
  8018aa:	3c 09                	cmp    $0x9,%al
  8018ac:	74 f2                	je     8018a0 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8018ae:	3c 2b                	cmp    $0x2b,%al
  8018b0:	75 0a                	jne    8018bc <strtol+0x2a>
		s++;
  8018b2:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8018b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8018ba:	eb 11                	jmp    8018cd <strtol+0x3b>
  8018bc:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8018c1:	3c 2d                	cmp    $0x2d,%al
  8018c3:	75 08                	jne    8018cd <strtol+0x3b>
		s++, neg = 1;
  8018c5:	83 c1 01             	add    $0x1,%ecx
  8018c8:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018cd:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8018d3:	75 15                	jne    8018ea <strtol+0x58>
  8018d5:	80 39 30             	cmpb   $0x30,(%ecx)
  8018d8:	75 10                	jne    8018ea <strtol+0x58>
  8018da:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8018de:	75 7c                	jne    80195c <strtol+0xca>
		s += 2, base = 16;
  8018e0:	83 c1 02             	add    $0x2,%ecx
  8018e3:	bb 10 00 00 00       	mov    $0x10,%ebx
  8018e8:	eb 16                	jmp    801900 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  8018ea:	85 db                	test   %ebx,%ebx
  8018ec:	75 12                	jne    801900 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8018ee:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8018f3:	80 39 30             	cmpb   $0x30,(%ecx)
  8018f6:	75 08                	jne    801900 <strtol+0x6e>
		s++, base = 8;
  8018f8:	83 c1 01             	add    $0x1,%ecx
  8018fb:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  801900:	b8 00 00 00 00       	mov    $0x0,%eax
  801905:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801908:	0f b6 11             	movzbl (%ecx),%edx
  80190b:	8d 72 d0             	lea    -0x30(%edx),%esi
  80190e:	89 f3                	mov    %esi,%ebx
  801910:	80 fb 09             	cmp    $0x9,%bl
  801913:	77 08                	ja     80191d <strtol+0x8b>
			dig = *s - '0';
  801915:	0f be d2             	movsbl %dl,%edx
  801918:	83 ea 30             	sub    $0x30,%edx
  80191b:	eb 22                	jmp    80193f <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  80191d:	8d 72 9f             	lea    -0x61(%edx),%esi
  801920:	89 f3                	mov    %esi,%ebx
  801922:	80 fb 19             	cmp    $0x19,%bl
  801925:	77 08                	ja     80192f <strtol+0x9d>
			dig = *s - 'a' + 10;
  801927:	0f be d2             	movsbl %dl,%edx
  80192a:	83 ea 57             	sub    $0x57,%edx
  80192d:	eb 10                	jmp    80193f <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  80192f:	8d 72 bf             	lea    -0x41(%edx),%esi
  801932:	89 f3                	mov    %esi,%ebx
  801934:	80 fb 19             	cmp    $0x19,%bl
  801937:	77 16                	ja     80194f <strtol+0xbd>
			dig = *s - 'A' + 10;
  801939:	0f be d2             	movsbl %dl,%edx
  80193c:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  80193f:	3b 55 10             	cmp    0x10(%ebp),%edx
  801942:	7d 0b                	jge    80194f <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  801944:	83 c1 01             	add    $0x1,%ecx
  801947:	0f af 45 10          	imul   0x10(%ebp),%eax
  80194b:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  80194d:	eb b9                	jmp    801908 <strtol+0x76>

	if (endptr)
  80194f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801953:	74 0d                	je     801962 <strtol+0xd0>
		*endptr = (char *) s;
  801955:	8b 75 0c             	mov    0xc(%ebp),%esi
  801958:	89 0e                	mov    %ecx,(%esi)
  80195a:	eb 06                	jmp    801962 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  80195c:	85 db                	test   %ebx,%ebx
  80195e:	74 98                	je     8018f8 <strtol+0x66>
  801960:	eb 9e                	jmp    801900 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  801962:	89 c2                	mov    %eax,%edx
  801964:	f7 da                	neg    %edx
  801966:	85 ff                	test   %edi,%edi
  801968:	0f 45 c2             	cmovne %edx,%eax
}
  80196b:	5b                   	pop    %ebx
  80196c:	5e                   	pop    %esi
  80196d:	5f                   	pop    %edi
  80196e:	5d                   	pop    %ebp
  80196f:	c3                   	ret    

00801970 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	56                   	push   %esi
  801974:	53                   	push   %ebx
  801975:	8b 75 08             	mov    0x8(%ebp),%esi
  801978:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  80197e:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801980:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801985:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801988:	83 ec 0c             	sub    $0xc,%esp
  80198b:	50                   	push   %eax
  80198c:	e8 1d e9 ff ff       	call   8002ae <sys_ipc_recv>
	if (from_env_store)
  801991:	83 c4 10             	add    $0x10,%esp
  801994:	85 f6                	test   %esi,%esi
  801996:	74 0b                	je     8019a3 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801998:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80199e:	8b 52 74             	mov    0x74(%edx),%edx
  8019a1:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8019a3:	85 db                	test   %ebx,%ebx
  8019a5:	74 0b                	je     8019b2 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  8019a7:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019ad:	8b 52 78             	mov    0x78(%edx),%edx
  8019b0:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  8019b2:	85 c0                	test   %eax,%eax
  8019b4:	79 16                	jns    8019cc <ipc_recv+0x5c>
		if (from_env_store)
  8019b6:	85 f6                	test   %esi,%esi
  8019b8:	74 06                	je     8019c0 <ipc_recv+0x50>
			*from_env_store = 0;
  8019ba:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  8019c0:	85 db                	test   %ebx,%ebx
  8019c2:	74 10                	je     8019d4 <ipc_recv+0x64>
			*perm_store = 0;
  8019c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8019ca:	eb 08                	jmp    8019d4 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  8019cc:	a1 04 40 80 00       	mov    0x804004,%eax
  8019d1:	8b 40 70             	mov    0x70(%eax),%eax
}
  8019d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019d7:	5b                   	pop    %ebx
  8019d8:	5e                   	pop    %esi
  8019d9:	5d                   	pop    %ebp
  8019da:	c3                   	ret    

008019db <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	57                   	push   %edi
  8019df:	56                   	push   %esi
  8019e0:	53                   	push   %ebx
  8019e1:	83 ec 0c             	sub    $0xc,%esp
  8019e4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019e7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  8019ed:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  8019ef:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8019f4:	0f 44 d8             	cmove  %eax,%ebx
  8019f7:	eb 1c                	jmp    801a15 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  8019f9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8019fc:	74 12                	je     801a10 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  8019fe:	50                   	push   %eax
  8019ff:	68 a0 21 80 00       	push   $0x8021a0
  801a04:	6a 42                	push   $0x42
  801a06:	68 b6 21 80 00       	push   $0x8021b6
  801a0b:	e8 cd f5 ff ff       	call   800fdd <_panic>
		sys_yield();
  801a10:	e8 77 e7 ff ff       	call   80018c <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801a15:	ff 75 14             	pushl  0x14(%ebp)
  801a18:	53                   	push   %ebx
  801a19:	56                   	push   %esi
  801a1a:	57                   	push   %edi
  801a1b:	e8 69 e8 ff ff       	call   800289 <sys_ipc_try_send>
  801a20:	83 c4 10             	add    $0x10,%esp
  801a23:	85 c0                	test   %eax,%eax
  801a25:	75 d2                	jne    8019f9 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801a27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a2a:	5b                   	pop    %ebx
  801a2b:	5e                   	pop    %esi
  801a2c:	5f                   	pop    %edi
  801a2d:	5d                   	pop    %ebp
  801a2e:	c3                   	ret    

00801a2f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801a35:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801a3a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801a3d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801a43:	8b 52 50             	mov    0x50(%edx),%edx
  801a46:	39 ca                	cmp    %ecx,%edx
  801a48:	75 0d                	jne    801a57 <ipc_find_env+0x28>
			return envs[i].env_id;
  801a4a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a4d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a52:	8b 40 48             	mov    0x48(%eax),%eax
  801a55:	eb 0f                	jmp    801a66 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801a57:	83 c0 01             	add    $0x1,%eax
  801a5a:	3d 00 04 00 00       	cmp    $0x400,%eax
  801a5f:	75 d9                	jne    801a3a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801a61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a66:	5d                   	pop    %ebp
  801a67:	c3                   	ret    

00801a68 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
  801a6b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a6e:	89 d0                	mov    %edx,%eax
  801a70:	c1 e8 16             	shr    $0x16,%eax
  801a73:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801a7a:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a7f:	f6 c1 01             	test   $0x1,%cl
  801a82:	74 1d                	je     801aa1 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801a84:	c1 ea 0c             	shr    $0xc,%edx
  801a87:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801a8e:	f6 c2 01             	test   $0x1,%dl
  801a91:	74 0e                	je     801aa1 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801a93:	c1 ea 0c             	shr    $0xc,%edx
  801a96:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801a9d:	ef 
  801a9e:	0f b7 c0             	movzwl %ax,%eax
}
  801aa1:	5d                   	pop    %ebp
  801aa2:	c3                   	ret    
  801aa3:	66 90                	xchg   %ax,%ax
  801aa5:	66 90                	xchg   %ax,%ax
  801aa7:	66 90                	xchg   %ax,%ax
  801aa9:	66 90                	xchg   %ax,%ax
  801aab:	66 90                	xchg   %ax,%ax
  801aad:	66 90                	xchg   %ax,%ax
  801aaf:	90                   	nop

00801ab0 <__udivdi3>:
  801ab0:	55                   	push   %ebp
  801ab1:	57                   	push   %edi
  801ab2:	56                   	push   %esi
  801ab3:	53                   	push   %ebx
  801ab4:	83 ec 1c             	sub    $0x1c,%esp
  801ab7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801abb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801abf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ac3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ac7:	85 f6                	test   %esi,%esi
  801ac9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801acd:	89 ca                	mov    %ecx,%edx
  801acf:	89 f8                	mov    %edi,%eax
  801ad1:	75 3d                	jne    801b10 <__udivdi3+0x60>
  801ad3:	39 cf                	cmp    %ecx,%edi
  801ad5:	0f 87 c5 00 00 00    	ja     801ba0 <__udivdi3+0xf0>
  801adb:	85 ff                	test   %edi,%edi
  801add:	89 fd                	mov    %edi,%ebp
  801adf:	75 0b                	jne    801aec <__udivdi3+0x3c>
  801ae1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae6:	31 d2                	xor    %edx,%edx
  801ae8:	f7 f7                	div    %edi
  801aea:	89 c5                	mov    %eax,%ebp
  801aec:	89 c8                	mov    %ecx,%eax
  801aee:	31 d2                	xor    %edx,%edx
  801af0:	f7 f5                	div    %ebp
  801af2:	89 c1                	mov    %eax,%ecx
  801af4:	89 d8                	mov    %ebx,%eax
  801af6:	89 cf                	mov    %ecx,%edi
  801af8:	f7 f5                	div    %ebp
  801afa:	89 c3                	mov    %eax,%ebx
  801afc:	89 d8                	mov    %ebx,%eax
  801afe:	89 fa                	mov    %edi,%edx
  801b00:	83 c4 1c             	add    $0x1c,%esp
  801b03:	5b                   	pop    %ebx
  801b04:	5e                   	pop    %esi
  801b05:	5f                   	pop    %edi
  801b06:	5d                   	pop    %ebp
  801b07:	c3                   	ret    
  801b08:	90                   	nop
  801b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801b10:	39 ce                	cmp    %ecx,%esi
  801b12:	77 74                	ja     801b88 <__udivdi3+0xd8>
  801b14:	0f bd fe             	bsr    %esi,%edi
  801b17:	83 f7 1f             	xor    $0x1f,%edi
  801b1a:	0f 84 98 00 00 00    	je     801bb8 <__udivdi3+0x108>
  801b20:	bb 20 00 00 00       	mov    $0x20,%ebx
  801b25:	89 f9                	mov    %edi,%ecx
  801b27:	89 c5                	mov    %eax,%ebp
  801b29:	29 fb                	sub    %edi,%ebx
  801b2b:	d3 e6                	shl    %cl,%esi
  801b2d:	89 d9                	mov    %ebx,%ecx
  801b2f:	d3 ed                	shr    %cl,%ebp
  801b31:	89 f9                	mov    %edi,%ecx
  801b33:	d3 e0                	shl    %cl,%eax
  801b35:	09 ee                	or     %ebp,%esi
  801b37:	89 d9                	mov    %ebx,%ecx
  801b39:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b3d:	89 d5                	mov    %edx,%ebp
  801b3f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b43:	d3 ed                	shr    %cl,%ebp
  801b45:	89 f9                	mov    %edi,%ecx
  801b47:	d3 e2                	shl    %cl,%edx
  801b49:	89 d9                	mov    %ebx,%ecx
  801b4b:	d3 e8                	shr    %cl,%eax
  801b4d:	09 c2                	or     %eax,%edx
  801b4f:	89 d0                	mov    %edx,%eax
  801b51:	89 ea                	mov    %ebp,%edx
  801b53:	f7 f6                	div    %esi
  801b55:	89 d5                	mov    %edx,%ebp
  801b57:	89 c3                	mov    %eax,%ebx
  801b59:	f7 64 24 0c          	mull   0xc(%esp)
  801b5d:	39 d5                	cmp    %edx,%ebp
  801b5f:	72 10                	jb     801b71 <__udivdi3+0xc1>
  801b61:	8b 74 24 08          	mov    0x8(%esp),%esi
  801b65:	89 f9                	mov    %edi,%ecx
  801b67:	d3 e6                	shl    %cl,%esi
  801b69:	39 c6                	cmp    %eax,%esi
  801b6b:	73 07                	jae    801b74 <__udivdi3+0xc4>
  801b6d:	39 d5                	cmp    %edx,%ebp
  801b6f:	75 03                	jne    801b74 <__udivdi3+0xc4>
  801b71:	83 eb 01             	sub    $0x1,%ebx
  801b74:	31 ff                	xor    %edi,%edi
  801b76:	89 d8                	mov    %ebx,%eax
  801b78:	89 fa                	mov    %edi,%edx
  801b7a:	83 c4 1c             	add    $0x1c,%esp
  801b7d:	5b                   	pop    %ebx
  801b7e:	5e                   	pop    %esi
  801b7f:	5f                   	pop    %edi
  801b80:	5d                   	pop    %ebp
  801b81:	c3                   	ret    
  801b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801b88:	31 ff                	xor    %edi,%edi
  801b8a:	31 db                	xor    %ebx,%ebx
  801b8c:	89 d8                	mov    %ebx,%eax
  801b8e:	89 fa                	mov    %edi,%edx
  801b90:	83 c4 1c             	add    $0x1c,%esp
  801b93:	5b                   	pop    %ebx
  801b94:	5e                   	pop    %esi
  801b95:	5f                   	pop    %edi
  801b96:	5d                   	pop    %ebp
  801b97:	c3                   	ret    
  801b98:	90                   	nop
  801b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ba0:	89 d8                	mov    %ebx,%eax
  801ba2:	f7 f7                	div    %edi
  801ba4:	31 ff                	xor    %edi,%edi
  801ba6:	89 c3                	mov    %eax,%ebx
  801ba8:	89 d8                	mov    %ebx,%eax
  801baa:	89 fa                	mov    %edi,%edx
  801bac:	83 c4 1c             	add    $0x1c,%esp
  801baf:	5b                   	pop    %ebx
  801bb0:	5e                   	pop    %esi
  801bb1:	5f                   	pop    %edi
  801bb2:	5d                   	pop    %ebp
  801bb3:	c3                   	ret    
  801bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801bb8:	39 ce                	cmp    %ecx,%esi
  801bba:	72 0c                	jb     801bc8 <__udivdi3+0x118>
  801bbc:	31 db                	xor    %ebx,%ebx
  801bbe:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bc2:	0f 87 34 ff ff ff    	ja     801afc <__udivdi3+0x4c>
  801bc8:	bb 01 00 00 00       	mov    $0x1,%ebx
  801bcd:	e9 2a ff ff ff       	jmp    801afc <__udivdi3+0x4c>
  801bd2:	66 90                	xchg   %ax,%ax
  801bd4:	66 90                	xchg   %ax,%ax
  801bd6:	66 90                	xchg   %ax,%ax
  801bd8:	66 90                	xchg   %ax,%ax
  801bda:	66 90                	xchg   %ax,%ax
  801bdc:	66 90                	xchg   %ax,%ax
  801bde:	66 90                	xchg   %ax,%ax

00801be0 <__umoddi3>:
  801be0:	55                   	push   %ebp
  801be1:	57                   	push   %edi
  801be2:	56                   	push   %esi
  801be3:	53                   	push   %ebx
  801be4:	83 ec 1c             	sub    $0x1c,%esp
  801be7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801beb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bef:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bf3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bf7:	85 d2                	test   %edx,%edx
  801bf9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801bfd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c01:	89 f3                	mov    %esi,%ebx
  801c03:	89 3c 24             	mov    %edi,(%esp)
  801c06:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c0a:	75 1c                	jne    801c28 <__umoddi3+0x48>
  801c0c:	39 f7                	cmp    %esi,%edi
  801c0e:	76 50                	jbe    801c60 <__umoddi3+0x80>
  801c10:	89 c8                	mov    %ecx,%eax
  801c12:	89 f2                	mov    %esi,%edx
  801c14:	f7 f7                	div    %edi
  801c16:	89 d0                	mov    %edx,%eax
  801c18:	31 d2                	xor    %edx,%edx
  801c1a:	83 c4 1c             	add    $0x1c,%esp
  801c1d:	5b                   	pop    %ebx
  801c1e:	5e                   	pop    %esi
  801c1f:	5f                   	pop    %edi
  801c20:	5d                   	pop    %ebp
  801c21:	c3                   	ret    
  801c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c28:	39 f2                	cmp    %esi,%edx
  801c2a:	89 d0                	mov    %edx,%eax
  801c2c:	77 52                	ja     801c80 <__umoddi3+0xa0>
  801c2e:	0f bd ea             	bsr    %edx,%ebp
  801c31:	83 f5 1f             	xor    $0x1f,%ebp
  801c34:	75 5a                	jne    801c90 <__umoddi3+0xb0>
  801c36:	3b 54 24 04          	cmp    0x4(%esp),%edx
  801c3a:	0f 82 e0 00 00 00    	jb     801d20 <__umoddi3+0x140>
  801c40:	39 0c 24             	cmp    %ecx,(%esp)
  801c43:	0f 86 d7 00 00 00    	jbe    801d20 <__umoddi3+0x140>
  801c49:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c4d:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c51:	83 c4 1c             	add    $0x1c,%esp
  801c54:	5b                   	pop    %ebx
  801c55:	5e                   	pop    %esi
  801c56:	5f                   	pop    %edi
  801c57:	5d                   	pop    %ebp
  801c58:	c3                   	ret    
  801c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c60:	85 ff                	test   %edi,%edi
  801c62:	89 fd                	mov    %edi,%ebp
  801c64:	75 0b                	jne    801c71 <__umoddi3+0x91>
  801c66:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6b:	31 d2                	xor    %edx,%edx
  801c6d:	f7 f7                	div    %edi
  801c6f:	89 c5                	mov    %eax,%ebp
  801c71:	89 f0                	mov    %esi,%eax
  801c73:	31 d2                	xor    %edx,%edx
  801c75:	f7 f5                	div    %ebp
  801c77:	89 c8                	mov    %ecx,%eax
  801c79:	f7 f5                	div    %ebp
  801c7b:	89 d0                	mov    %edx,%eax
  801c7d:	eb 99                	jmp    801c18 <__umoddi3+0x38>
  801c7f:	90                   	nop
  801c80:	89 c8                	mov    %ecx,%eax
  801c82:	89 f2                	mov    %esi,%edx
  801c84:	83 c4 1c             	add    $0x1c,%esp
  801c87:	5b                   	pop    %ebx
  801c88:	5e                   	pop    %esi
  801c89:	5f                   	pop    %edi
  801c8a:	5d                   	pop    %ebp
  801c8b:	c3                   	ret    
  801c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801c90:	8b 34 24             	mov    (%esp),%esi
  801c93:	bf 20 00 00 00       	mov    $0x20,%edi
  801c98:	89 e9                	mov    %ebp,%ecx
  801c9a:	29 ef                	sub    %ebp,%edi
  801c9c:	d3 e0                	shl    %cl,%eax
  801c9e:	89 f9                	mov    %edi,%ecx
  801ca0:	89 f2                	mov    %esi,%edx
  801ca2:	d3 ea                	shr    %cl,%edx
  801ca4:	89 e9                	mov    %ebp,%ecx
  801ca6:	09 c2                	or     %eax,%edx
  801ca8:	89 d8                	mov    %ebx,%eax
  801caa:	89 14 24             	mov    %edx,(%esp)
  801cad:	89 f2                	mov    %esi,%edx
  801caf:	d3 e2                	shl    %cl,%edx
  801cb1:	89 f9                	mov    %edi,%ecx
  801cb3:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cb7:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801cbb:	d3 e8                	shr    %cl,%eax
  801cbd:	89 e9                	mov    %ebp,%ecx
  801cbf:	89 c6                	mov    %eax,%esi
  801cc1:	d3 e3                	shl    %cl,%ebx
  801cc3:	89 f9                	mov    %edi,%ecx
  801cc5:	89 d0                	mov    %edx,%eax
  801cc7:	d3 e8                	shr    %cl,%eax
  801cc9:	89 e9                	mov    %ebp,%ecx
  801ccb:	09 d8                	or     %ebx,%eax
  801ccd:	89 d3                	mov    %edx,%ebx
  801ccf:	89 f2                	mov    %esi,%edx
  801cd1:	f7 34 24             	divl   (%esp)
  801cd4:	89 d6                	mov    %edx,%esi
  801cd6:	d3 e3                	shl    %cl,%ebx
  801cd8:	f7 64 24 04          	mull   0x4(%esp)
  801cdc:	39 d6                	cmp    %edx,%esi
  801cde:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ce2:	89 d1                	mov    %edx,%ecx
  801ce4:	89 c3                	mov    %eax,%ebx
  801ce6:	72 08                	jb     801cf0 <__umoddi3+0x110>
  801ce8:	75 11                	jne    801cfb <__umoddi3+0x11b>
  801cea:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801cee:	73 0b                	jae    801cfb <__umoddi3+0x11b>
  801cf0:	2b 44 24 04          	sub    0x4(%esp),%eax
  801cf4:	1b 14 24             	sbb    (%esp),%edx
  801cf7:	89 d1                	mov    %edx,%ecx
  801cf9:	89 c3                	mov    %eax,%ebx
  801cfb:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cff:	29 da                	sub    %ebx,%edx
  801d01:	19 ce                	sbb    %ecx,%esi
  801d03:	89 f9                	mov    %edi,%ecx
  801d05:	89 f0                	mov    %esi,%eax
  801d07:	d3 e0                	shl    %cl,%eax
  801d09:	89 e9                	mov    %ebp,%ecx
  801d0b:	d3 ea                	shr    %cl,%edx
  801d0d:	89 e9                	mov    %ebp,%ecx
  801d0f:	d3 ee                	shr    %cl,%esi
  801d11:	09 d0                	or     %edx,%eax
  801d13:	89 f2                	mov    %esi,%edx
  801d15:	83 c4 1c             	add    $0x1c,%esp
  801d18:	5b                   	pop    %ebx
  801d19:	5e                   	pop    %esi
  801d1a:	5f                   	pop    %edi
  801d1b:	5d                   	pop    %ebp
  801d1c:	c3                   	ret    
  801d1d:	8d 76 00             	lea    0x0(%esi),%esi
  801d20:	29 f9                	sub    %edi,%ecx
  801d22:	19 d6                	sbb    %edx,%esi
  801d24:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d28:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d2c:	e9 18 ff ff ff       	jmp    801c49 <__umoddi3+0x69>
