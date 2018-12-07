
obj/user/badsegment.debug:     formato del fichero elf32-i386


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
  80002c:	e8 0d 00 00 00       	call   80003e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800036:	66 b8 28 00          	mov    $0x28,%ax
  80003a:	8e d8                	mov    %eax,%ds
}
  80003c:	5d                   	pop    %ebp
  80003d:	c3                   	ret    

0080003e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003e:	55                   	push   %ebp
  80003f:	89 e5                	mov    %esp,%ebp
  800041:	56                   	push   %esi
  800042:	53                   	push   %ebx
  800043:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800046:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800049:	e8 0a 01 00 00       	call   800158 <sys_getenvid>
	if (id >= 0)
  80004e:	85 c0                	test   %eax,%eax
  800050:	78 12                	js     800064 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  800052:	25 ff 03 00 00       	and    $0x3ff,%eax
  800057:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005f:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800064:	85 db                	test   %ebx,%ebx
  800066:	7e 07                	jle    80006f <libmain+0x31>
		binaryname = argv[0];
  800068:	8b 06                	mov    (%esi),%eax
  80006a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80006f:	83 ec 08             	sub    $0x8,%esp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	e8 ba ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800079:	e8 0a 00 00 00       	call   800088 <exit>
}
  80007e:	83 c4 10             	add    $0x10,%esp
  800081:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800084:	5b                   	pop    %ebx
  800085:	5e                   	pop    %esi
  800086:	5d                   	pop    %ebp
  800087:	c3                   	ret    

00800088 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800088:	55                   	push   %ebp
  800089:	89 e5                	mov    %esp,%ebp
  80008b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80008e:	e8 f8 03 00 00       	call   80048b <close_all>
	sys_env_destroy(0);
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	6a 00                	push   $0x0
  800098:	e8 99 00 00 00       	call   800136 <sys_env_destroy>
}
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	57                   	push   %edi
  8000a6:	56                   	push   %esi
  8000a7:	53                   	push   %ebx
  8000a8:	83 ec 1c             	sub    $0x1c,%esp
  8000ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000ae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8000b1:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000b9:	8b 7d 10             	mov    0x10(%ebp),%edi
  8000bc:	8b 75 14             	mov    0x14(%ebp),%esi
  8000bf:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8000c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000c5:	74 1d                	je     8000e4 <syscall+0x42>
  8000c7:	85 c0                	test   %eax,%eax
  8000c9:	7e 19                	jle    8000e4 <syscall+0x42>
  8000cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	50                   	push   %eax
  8000d2:	52                   	push   %edx
  8000d3:	68 4a 1d 80 00       	push   $0x801d4a
  8000d8:	6a 23                	push   $0x23
  8000da:	68 67 1d 80 00       	push   $0x801d67
  8000df:	e8 e9 0e 00 00       	call   800fcd <_panic>

	return ret;
}
  8000e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000e7:	5b                   	pop    %ebx
  8000e8:	5e                   	pop    %esi
  8000e9:	5f                   	pop    %edi
  8000ea:	5d                   	pop    %ebp
  8000eb:	c3                   	ret    

008000ec <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8000ec:	55                   	push   %ebp
  8000ed:	89 e5                	mov    %esp,%ebp
  8000ef:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  8000f2:	6a 00                	push   $0x0
  8000f4:	6a 00                	push   $0x0
  8000f6:	6a 00                	push   $0x0
  8000f8:	ff 75 0c             	pushl  0xc(%ebp)
  8000fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800103:	b8 00 00 00 00       	mov    $0x0,%eax
  800108:	e8 95 ff ff ff       	call   8000a2 <syscall>
}
  80010d:	83 c4 10             	add    $0x10,%esp
  800110:	c9                   	leave  
  800111:	c3                   	ret    

00800112 <sys_cgetc>:

int
sys_cgetc(void)
{
  800112:	55                   	push   %ebp
  800113:	89 e5                	mov    %esp,%ebp
  800115:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800118:	6a 00                	push   $0x0
  80011a:	6a 00                	push   $0x0
  80011c:	6a 00                	push   $0x0
  80011e:	6a 00                	push   $0x0
  800120:	b9 00 00 00 00       	mov    $0x0,%ecx
  800125:	ba 00 00 00 00       	mov    $0x0,%edx
  80012a:	b8 01 00 00 00       	mov    $0x1,%eax
  80012f:	e8 6e ff ff ff       	call   8000a2 <syscall>
}
  800134:	c9                   	leave  
  800135:	c3                   	ret    

00800136 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800136:	55                   	push   %ebp
  800137:	89 e5                	mov    %esp,%ebp
  800139:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80013c:	6a 00                	push   $0x0
  80013e:	6a 00                	push   $0x0
  800140:	6a 00                	push   $0x0
  800142:	6a 00                	push   $0x0
  800144:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800147:	ba 01 00 00 00       	mov    $0x1,%edx
  80014c:	b8 03 00 00 00       	mov    $0x3,%eax
  800151:	e8 4c ff ff ff       	call   8000a2 <syscall>
}
  800156:	c9                   	leave  
  800157:	c3                   	ret    

00800158 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800158:	55                   	push   %ebp
  800159:	89 e5                	mov    %esp,%ebp
  80015b:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80015e:	6a 00                	push   $0x0
  800160:	6a 00                	push   $0x0
  800162:	6a 00                	push   $0x0
  800164:	6a 00                	push   $0x0
  800166:	b9 00 00 00 00       	mov    $0x0,%ecx
  80016b:	ba 00 00 00 00       	mov    $0x0,%edx
  800170:	b8 02 00 00 00       	mov    $0x2,%eax
  800175:	e8 28 ff ff ff       	call   8000a2 <syscall>
}
  80017a:	c9                   	leave  
  80017b:	c3                   	ret    

0080017c <sys_yield>:

void
sys_yield(void)
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800182:	6a 00                	push   $0x0
  800184:	6a 00                	push   $0x0
  800186:	6a 00                	push   $0x0
  800188:	6a 00                	push   $0x0
  80018a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80018f:	ba 00 00 00 00       	mov    $0x0,%edx
  800194:	b8 0b 00 00 00       	mov    $0xb,%eax
  800199:	e8 04 ff ff ff       	call   8000a2 <syscall>
}
  80019e:	83 c4 10             	add    $0x10,%esp
  8001a1:	c9                   	leave  
  8001a2:	c3                   	ret    

008001a3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8001a9:	6a 00                	push   $0x0
  8001ab:	6a 00                	push   $0x0
  8001ad:	ff 75 10             	pushl  0x10(%ebp)
  8001b0:	ff 75 0c             	pushl  0xc(%ebp)
  8001b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001b6:	ba 01 00 00 00       	mov    $0x1,%edx
  8001bb:	b8 04 00 00 00       	mov    $0x4,%eax
  8001c0:	e8 dd fe ff ff       	call   8000a2 <syscall>
}
  8001c5:	c9                   	leave  
  8001c6:	c3                   	ret    

008001c7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001c7:	55                   	push   %ebp
  8001c8:	89 e5                	mov    %esp,%ebp
  8001ca:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8001cd:	ff 75 18             	pushl  0x18(%ebp)
  8001d0:	ff 75 14             	pushl  0x14(%ebp)
  8001d3:	ff 75 10             	pushl  0x10(%ebp)
  8001d6:	ff 75 0c             	pushl  0xc(%ebp)
  8001d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001dc:	ba 01 00 00 00       	mov    $0x1,%edx
  8001e1:	b8 05 00 00 00       	mov    $0x5,%eax
  8001e6:	e8 b7 fe ff ff       	call   8000a2 <syscall>
}
  8001eb:	c9                   	leave  
  8001ec:	c3                   	ret    

008001ed <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  8001f3:	6a 00                	push   $0x0
  8001f5:	6a 00                	push   $0x0
  8001f7:	6a 00                	push   $0x0
  8001f9:	ff 75 0c             	pushl  0xc(%ebp)
  8001fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ff:	ba 01 00 00 00       	mov    $0x1,%edx
  800204:	b8 06 00 00 00       	mov    $0x6,%eax
  800209:	e8 94 fe ff ff       	call   8000a2 <syscall>
}
  80020e:	c9                   	leave  
  80020f:	c3                   	ret    

00800210 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800216:	6a 00                	push   $0x0
  800218:	6a 00                	push   $0x0
  80021a:	6a 00                	push   $0x0
  80021c:	ff 75 0c             	pushl  0xc(%ebp)
  80021f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800222:	ba 01 00 00 00       	mov    $0x1,%edx
  800227:	b8 08 00 00 00       	mov    $0x8,%eax
  80022c:	e8 71 fe ff ff       	call   8000a2 <syscall>
}
  800231:	c9                   	leave  
  800232:	c3                   	ret    

00800233 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800239:	6a 00                	push   $0x0
  80023b:	6a 00                	push   $0x0
  80023d:	6a 00                	push   $0x0
  80023f:	ff 75 0c             	pushl  0xc(%ebp)
  800242:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800245:	ba 01 00 00 00       	mov    $0x1,%edx
  80024a:	b8 09 00 00 00       	mov    $0x9,%eax
  80024f:	e8 4e fe ff ff       	call   8000a2 <syscall>
}
  800254:	c9                   	leave  
  800255:	c3                   	ret    

00800256 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800256:	55                   	push   %ebp
  800257:	89 e5                	mov    %esp,%ebp
  800259:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  80025c:	6a 00                	push   $0x0
  80025e:	6a 00                	push   $0x0
  800260:	6a 00                	push   $0x0
  800262:	ff 75 0c             	pushl  0xc(%ebp)
  800265:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800268:	ba 01 00 00 00       	mov    $0x1,%edx
  80026d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800272:	e8 2b fe ff ff       	call   8000a2 <syscall>
}
  800277:	c9                   	leave  
  800278:	c3                   	ret    

00800279 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  80027f:	6a 00                	push   $0x0
  800281:	ff 75 14             	pushl  0x14(%ebp)
  800284:	ff 75 10             	pushl  0x10(%ebp)
  800287:	ff 75 0c             	pushl  0xc(%ebp)
  80028a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80028d:	ba 00 00 00 00       	mov    $0x0,%edx
  800292:	b8 0c 00 00 00       	mov    $0xc,%eax
  800297:	e8 06 fe ff ff       	call   8000a2 <syscall>
}
  80029c:	c9                   	leave  
  80029d:	c3                   	ret    

0080029e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80029e:	55                   	push   %ebp
  80029f:	89 e5                	mov    %esp,%ebp
  8002a1:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8002a4:	6a 00                	push   $0x0
  8002a6:	6a 00                	push   $0x0
  8002a8:	6a 00                	push   $0x0
  8002aa:	6a 00                	push   $0x0
  8002ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002af:	ba 01 00 00 00       	mov    $0x1,%edx
  8002b4:	b8 0d 00 00 00       	mov    $0xd,%eax
  8002b9:	e8 e4 fd ff ff       	call   8000a2 <syscall>
}
  8002be:	c9                   	leave  
  8002bf:	c3                   	ret    

008002c0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8002c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c6:	05 00 00 00 30       	add    $0x30000000,%eax
  8002cb:	c1 e8 0c             	shr    $0xc,%eax
}
  8002ce:	5d                   	pop    %ebp
  8002cf:	c3                   	ret    

008002d0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  8002d3:	ff 75 08             	pushl  0x8(%ebp)
  8002d6:	e8 e5 ff ff ff       	call   8002c0 <fd2num>
  8002db:	83 c4 04             	add    $0x4,%esp
  8002de:	c1 e0 0c             	shl    $0xc,%eax
  8002e1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8002e6:	c9                   	leave  
  8002e7:	c3                   	ret    

008002e8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8002e8:	55                   	push   %ebp
  8002e9:	89 e5                	mov    %esp,%ebp
  8002eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002ee:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8002f3:	89 c2                	mov    %eax,%edx
  8002f5:	c1 ea 16             	shr    $0x16,%edx
  8002f8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8002ff:	f6 c2 01             	test   $0x1,%dl
  800302:	74 11                	je     800315 <fd_alloc+0x2d>
  800304:	89 c2                	mov    %eax,%edx
  800306:	c1 ea 0c             	shr    $0xc,%edx
  800309:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800310:	f6 c2 01             	test   $0x1,%dl
  800313:	75 09                	jne    80031e <fd_alloc+0x36>
			*fd_store = fd;
  800315:	89 01                	mov    %eax,(%ecx)
			return 0;
  800317:	b8 00 00 00 00       	mov    $0x0,%eax
  80031c:	eb 17                	jmp    800335 <fd_alloc+0x4d>
  80031e:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800323:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800328:	75 c9                	jne    8002f3 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80032a:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800330:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800335:	5d                   	pop    %ebp
  800336:	c3                   	ret    

00800337 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800337:	55                   	push   %ebp
  800338:	89 e5                	mov    %esp,%ebp
  80033a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80033d:	83 f8 1f             	cmp    $0x1f,%eax
  800340:	77 36                	ja     800378 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800342:	c1 e0 0c             	shl    $0xc,%eax
  800345:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80034a:	89 c2                	mov    %eax,%edx
  80034c:	c1 ea 16             	shr    $0x16,%edx
  80034f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800356:	f6 c2 01             	test   $0x1,%dl
  800359:	74 24                	je     80037f <fd_lookup+0x48>
  80035b:	89 c2                	mov    %eax,%edx
  80035d:	c1 ea 0c             	shr    $0xc,%edx
  800360:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800367:	f6 c2 01             	test   $0x1,%dl
  80036a:	74 1a                	je     800386 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80036c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80036f:	89 02                	mov    %eax,(%edx)
	return 0;
  800371:	b8 00 00 00 00       	mov    $0x0,%eax
  800376:	eb 13                	jmp    80038b <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800378:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80037d:	eb 0c                	jmp    80038b <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80037f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800384:	eb 05                	jmp    80038b <fd_lookup+0x54>
  800386:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80038b:	5d                   	pop    %ebp
  80038c:	c3                   	ret    

0080038d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80038d:	55                   	push   %ebp
  80038e:	89 e5                	mov    %esp,%ebp
  800390:	83 ec 08             	sub    $0x8,%esp
  800393:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800396:	ba f4 1d 80 00       	mov    $0x801df4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80039b:	eb 13                	jmp    8003b0 <dev_lookup+0x23>
  80039d:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  8003a0:	39 08                	cmp    %ecx,(%eax)
  8003a2:	75 0c                	jne    8003b0 <dev_lookup+0x23>
			*dev = devtab[i];
  8003a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003a7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ae:	eb 2e                	jmp    8003de <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8003b0:	8b 02                	mov    (%edx),%eax
  8003b2:	85 c0                	test   %eax,%eax
  8003b4:	75 e7                	jne    80039d <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8003b6:	a1 04 40 80 00       	mov    0x804004,%eax
  8003bb:	8b 40 48             	mov    0x48(%eax),%eax
  8003be:	83 ec 04             	sub    $0x4,%esp
  8003c1:	51                   	push   %ecx
  8003c2:	50                   	push   %eax
  8003c3:	68 78 1d 80 00       	push   $0x801d78
  8003c8:	e8 d9 0c 00 00       	call   8010a6 <cprintf>
	*dev = 0;
  8003cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8003de:	c9                   	leave  
  8003df:	c3                   	ret    

008003e0 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8003e0:	55                   	push   %ebp
  8003e1:	89 e5                	mov    %esp,%ebp
  8003e3:	56                   	push   %esi
  8003e4:	53                   	push   %ebx
  8003e5:	83 ec 10             	sub    $0x10,%esp
  8003e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8003eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8003ee:	56                   	push   %esi
  8003ef:	e8 cc fe ff ff       	call   8002c0 <fd2num>
  8003f4:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8003f7:	89 14 24             	mov    %edx,(%esp)
  8003fa:	50                   	push   %eax
  8003fb:	e8 37 ff ff ff       	call   800337 <fd_lookup>
  800400:	83 c4 08             	add    $0x8,%esp
  800403:	85 c0                	test   %eax,%eax
  800405:	78 05                	js     80040c <fd_close+0x2c>
	    || fd != fd2)
  800407:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80040a:	74 0c                	je     800418 <fd_close+0x38>
		return (must_exist ? r : 0);
  80040c:	84 db                	test   %bl,%bl
  80040e:	ba 00 00 00 00       	mov    $0x0,%edx
  800413:	0f 44 c2             	cmove  %edx,%eax
  800416:	eb 41                	jmp    800459 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800418:	83 ec 08             	sub    $0x8,%esp
  80041b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80041e:	50                   	push   %eax
  80041f:	ff 36                	pushl  (%esi)
  800421:	e8 67 ff ff ff       	call   80038d <dev_lookup>
  800426:	89 c3                	mov    %eax,%ebx
  800428:	83 c4 10             	add    $0x10,%esp
  80042b:	85 c0                	test   %eax,%eax
  80042d:	78 1a                	js     800449 <fd_close+0x69>
		if (dev->dev_close)
  80042f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800432:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800435:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80043a:	85 c0                	test   %eax,%eax
  80043c:	74 0b                	je     800449 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  80043e:	83 ec 0c             	sub    $0xc,%esp
  800441:	56                   	push   %esi
  800442:	ff d0                	call   *%eax
  800444:	89 c3                	mov    %eax,%ebx
  800446:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800449:	83 ec 08             	sub    $0x8,%esp
  80044c:	56                   	push   %esi
  80044d:	6a 00                	push   $0x0
  80044f:	e8 99 fd ff ff       	call   8001ed <sys_page_unmap>
	return r;
  800454:	83 c4 10             	add    $0x10,%esp
  800457:	89 d8                	mov    %ebx,%eax
}
  800459:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80045c:	5b                   	pop    %ebx
  80045d:	5e                   	pop    %esi
  80045e:	5d                   	pop    %ebp
  80045f:	c3                   	ret    

00800460 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800460:	55                   	push   %ebp
  800461:	89 e5                	mov    %esp,%ebp
  800463:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800466:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800469:	50                   	push   %eax
  80046a:	ff 75 08             	pushl  0x8(%ebp)
  80046d:	e8 c5 fe ff ff       	call   800337 <fd_lookup>
  800472:	83 c4 08             	add    $0x8,%esp
  800475:	85 c0                	test   %eax,%eax
  800477:	78 10                	js     800489 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800479:	83 ec 08             	sub    $0x8,%esp
  80047c:	6a 01                	push   $0x1
  80047e:	ff 75 f4             	pushl  -0xc(%ebp)
  800481:	e8 5a ff ff ff       	call   8003e0 <fd_close>
  800486:	83 c4 10             	add    $0x10,%esp
}
  800489:	c9                   	leave  
  80048a:	c3                   	ret    

0080048b <close_all>:

void
close_all(void)
{
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	53                   	push   %ebx
  80048f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800492:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800497:	83 ec 0c             	sub    $0xc,%esp
  80049a:	53                   	push   %ebx
  80049b:	e8 c0 ff ff ff       	call   800460 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8004a0:	83 c3 01             	add    $0x1,%ebx
  8004a3:	83 c4 10             	add    $0x10,%esp
  8004a6:	83 fb 20             	cmp    $0x20,%ebx
  8004a9:	75 ec                	jne    800497 <close_all+0xc>
		close(i);
}
  8004ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004ae:	c9                   	leave  
  8004af:	c3                   	ret    

008004b0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	57                   	push   %edi
  8004b4:	56                   	push   %esi
  8004b5:	53                   	push   %ebx
  8004b6:	83 ec 2c             	sub    $0x2c,%esp
  8004b9:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8004bc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004bf:	50                   	push   %eax
  8004c0:	ff 75 08             	pushl  0x8(%ebp)
  8004c3:	e8 6f fe ff ff       	call   800337 <fd_lookup>
  8004c8:	83 c4 08             	add    $0x8,%esp
  8004cb:	85 c0                	test   %eax,%eax
  8004cd:	0f 88 c1 00 00 00    	js     800594 <dup+0xe4>
		return r;
	close(newfdnum);
  8004d3:	83 ec 0c             	sub    $0xc,%esp
  8004d6:	56                   	push   %esi
  8004d7:	e8 84 ff ff ff       	call   800460 <close>

	newfd = INDEX2FD(newfdnum);
  8004dc:	89 f3                	mov    %esi,%ebx
  8004de:	c1 e3 0c             	shl    $0xc,%ebx
  8004e1:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8004e7:	83 c4 04             	add    $0x4,%esp
  8004ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004ed:	e8 de fd ff ff       	call   8002d0 <fd2data>
  8004f2:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  8004f4:	89 1c 24             	mov    %ebx,(%esp)
  8004f7:	e8 d4 fd ff ff       	call   8002d0 <fd2data>
  8004fc:	83 c4 10             	add    $0x10,%esp
  8004ff:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800502:	89 f8                	mov    %edi,%eax
  800504:	c1 e8 16             	shr    $0x16,%eax
  800507:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80050e:	a8 01                	test   $0x1,%al
  800510:	74 37                	je     800549 <dup+0x99>
  800512:	89 f8                	mov    %edi,%eax
  800514:	c1 e8 0c             	shr    $0xc,%eax
  800517:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80051e:	f6 c2 01             	test   $0x1,%dl
  800521:	74 26                	je     800549 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800523:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80052a:	83 ec 0c             	sub    $0xc,%esp
  80052d:	25 07 0e 00 00       	and    $0xe07,%eax
  800532:	50                   	push   %eax
  800533:	ff 75 d4             	pushl  -0x2c(%ebp)
  800536:	6a 00                	push   $0x0
  800538:	57                   	push   %edi
  800539:	6a 00                	push   $0x0
  80053b:	e8 87 fc ff ff       	call   8001c7 <sys_page_map>
  800540:	89 c7                	mov    %eax,%edi
  800542:	83 c4 20             	add    $0x20,%esp
  800545:	85 c0                	test   %eax,%eax
  800547:	78 2e                	js     800577 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800549:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80054c:	89 d0                	mov    %edx,%eax
  80054e:	c1 e8 0c             	shr    $0xc,%eax
  800551:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800558:	83 ec 0c             	sub    $0xc,%esp
  80055b:	25 07 0e 00 00       	and    $0xe07,%eax
  800560:	50                   	push   %eax
  800561:	53                   	push   %ebx
  800562:	6a 00                	push   $0x0
  800564:	52                   	push   %edx
  800565:	6a 00                	push   $0x0
  800567:	e8 5b fc ff ff       	call   8001c7 <sys_page_map>
  80056c:	89 c7                	mov    %eax,%edi
  80056e:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  800571:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800573:	85 ff                	test   %edi,%edi
  800575:	79 1d                	jns    800594 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	53                   	push   %ebx
  80057b:	6a 00                	push   $0x0
  80057d:	e8 6b fc ff ff       	call   8001ed <sys_page_unmap>
	sys_page_unmap(0, nva);
  800582:	83 c4 08             	add    $0x8,%esp
  800585:	ff 75 d4             	pushl  -0x2c(%ebp)
  800588:	6a 00                	push   $0x0
  80058a:	e8 5e fc ff ff       	call   8001ed <sys_page_unmap>
	return r;
  80058f:	83 c4 10             	add    $0x10,%esp
  800592:	89 f8                	mov    %edi,%eax
}
  800594:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800597:	5b                   	pop    %ebx
  800598:	5e                   	pop    %esi
  800599:	5f                   	pop    %edi
  80059a:	5d                   	pop    %ebp
  80059b:	c3                   	ret    

0080059c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80059c:	55                   	push   %ebp
  80059d:	89 e5                	mov    %esp,%ebp
  80059f:	53                   	push   %ebx
  8005a0:	83 ec 14             	sub    $0x14,%esp
  8005a3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8005a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8005a9:	50                   	push   %eax
  8005aa:	53                   	push   %ebx
  8005ab:	e8 87 fd ff ff       	call   800337 <fd_lookup>
  8005b0:	83 c4 08             	add    $0x8,%esp
  8005b3:	89 c2                	mov    %eax,%edx
  8005b5:	85 c0                	test   %eax,%eax
  8005b7:	78 6d                	js     800626 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005bf:	50                   	push   %eax
  8005c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005c3:	ff 30                	pushl  (%eax)
  8005c5:	e8 c3 fd ff ff       	call   80038d <dev_lookup>
  8005ca:	83 c4 10             	add    $0x10,%esp
  8005cd:	85 c0                	test   %eax,%eax
  8005cf:	78 4c                	js     80061d <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8005d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8005d4:	8b 42 08             	mov    0x8(%edx),%eax
  8005d7:	83 e0 03             	and    $0x3,%eax
  8005da:	83 f8 01             	cmp    $0x1,%eax
  8005dd:	75 21                	jne    800600 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8005df:	a1 04 40 80 00       	mov    0x804004,%eax
  8005e4:	8b 40 48             	mov    0x48(%eax),%eax
  8005e7:	83 ec 04             	sub    $0x4,%esp
  8005ea:	53                   	push   %ebx
  8005eb:	50                   	push   %eax
  8005ec:	68 b9 1d 80 00       	push   $0x801db9
  8005f1:	e8 b0 0a 00 00       	call   8010a6 <cprintf>
		return -E_INVAL;
  8005f6:	83 c4 10             	add    $0x10,%esp
  8005f9:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8005fe:	eb 26                	jmp    800626 <read+0x8a>
	}
	if (!dev->dev_read)
  800600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800603:	8b 40 08             	mov    0x8(%eax),%eax
  800606:	85 c0                	test   %eax,%eax
  800608:	74 17                	je     800621 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80060a:	83 ec 04             	sub    $0x4,%esp
  80060d:	ff 75 10             	pushl  0x10(%ebp)
  800610:	ff 75 0c             	pushl  0xc(%ebp)
  800613:	52                   	push   %edx
  800614:	ff d0                	call   *%eax
  800616:	89 c2                	mov    %eax,%edx
  800618:	83 c4 10             	add    $0x10,%esp
  80061b:	eb 09                	jmp    800626 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80061d:	89 c2                	mov    %eax,%edx
  80061f:	eb 05                	jmp    800626 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800621:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  800626:	89 d0                	mov    %edx,%eax
  800628:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80062b:	c9                   	leave  
  80062c:	c3                   	ret    

0080062d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80062d:	55                   	push   %ebp
  80062e:	89 e5                	mov    %esp,%ebp
  800630:	57                   	push   %edi
  800631:	56                   	push   %esi
  800632:	53                   	push   %ebx
  800633:	83 ec 0c             	sub    $0xc,%esp
  800636:	8b 7d 08             	mov    0x8(%ebp),%edi
  800639:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80063c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800641:	eb 21                	jmp    800664 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800643:	83 ec 04             	sub    $0x4,%esp
  800646:	89 f0                	mov    %esi,%eax
  800648:	29 d8                	sub    %ebx,%eax
  80064a:	50                   	push   %eax
  80064b:	89 d8                	mov    %ebx,%eax
  80064d:	03 45 0c             	add    0xc(%ebp),%eax
  800650:	50                   	push   %eax
  800651:	57                   	push   %edi
  800652:	e8 45 ff ff ff       	call   80059c <read>
		if (m < 0)
  800657:	83 c4 10             	add    $0x10,%esp
  80065a:	85 c0                	test   %eax,%eax
  80065c:	78 10                	js     80066e <readn+0x41>
			return m;
		if (m == 0)
  80065e:	85 c0                	test   %eax,%eax
  800660:	74 0a                	je     80066c <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800662:	01 c3                	add    %eax,%ebx
  800664:	39 f3                	cmp    %esi,%ebx
  800666:	72 db                	jb     800643 <readn+0x16>
  800668:	89 d8                	mov    %ebx,%eax
  80066a:	eb 02                	jmp    80066e <readn+0x41>
  80066c:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80066e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800671:	5b                   	pop    %ebx
  800672:	5e                   	pop    %esi
  800673:	5f                   	pop    %edi
  800674:	5d                   	pop    %ebp
  800675:	c3                   	ret    

00800676 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800676:	55                   	push   %ebp
  800677:	89 e5                	mov    %esp,%ebp
  800679:	53                   	push   %ebx
  80067a:	83 ec 14             	sub    $0x14,%esp
  80067d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800680:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800683:	50                   	push   %eax
  800684:	53                   	push   %ebx
  800685:	e8 ad fc ff ff       	call   800337 <fd_lookup>
  80068a:	83 c4 08             	add    $0x8,%esp
  80068d:	89 c2                	mov    %eax,%edx
  80068f:	85 c0                	test   %eax,%eax
  800691:	78 68                	js     8006fb <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800693:	83 ec 08             	sub    $0x8,%esp
  800696:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800699:	50                   	push   %eax
  80069a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80069d:	ff 30                	pushl  (%eax)
  80069f:	e8 e9 fc ff ff       	call   80038d <dev_lookup>
  8006a4:	83 c4 10             	add    $0x10,%esp
  8006a7:	85 c0                	test   %eax,%eax
  8006a9:	78 47                	js     8006f2 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8006ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ae:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8006b2:	75 21                	jne    8006d5 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8006b4:	a1 04 40 80 00       	mov    0x804004,%eax
  8006b9:	8b 40 48             	mov    0x48(%eax),%eax
  8006bc:	83 ec 04             	sub    $0x4,%esp
  8006bf:	53                   	push   %ebx
  8006c0:	50                   	push   %eax
  8006c1:	68 d5 1d 80 00       	push   $0x801dd5
  8006c6:	e8 db 09 00 00       	call   8010a6 <cprintf>
		return -E_INVAL;
  8006cb:	83 c4 10             	add    $0x10,%esp
  8006ce:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8006d3:	eb 26                	jmp    8006fb <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8006d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d8:	8b 52 0c             	mov    0xc(%edx),%edx
  8006db:	85 d2                	test   %edx,%edx
  8006dd:	74 17                	je     8006f6 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8006df:	83 ec 04             	sub    $0x4,%esp
  8006e2:	ff 75 10             	pushl  0x10(%ebp)
  8006e5:	ff 75 0c             	pushl  0xc(%ebp)
  8006e8:	50                   	push   %eax
  8006e9:	ff d2                	call   *%edx
  8006eb:	89 c2                	mov    %eax,%edx
  8006ed:	83 c4 10             	add    $0x10,%esp
  8006f0:	eb 09                	jmp    8006fb <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006f2:	89 c2                	mov    %eax,%edx
  8006f4:	eb 05                	jmp    8006fb <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8006f6:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  8006fb:	89 d0                	mov    %edx,%eax
  8006fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800700:	c9                   	leave  
  800701:	c3                   	ret    

00800702 <seek>:

int
seek(int fdnum, off_t offset)
{
  800702:	55                   	push   %ebp
  800703:	89 e5                	mov    %esp,%ebp
  800705:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800708:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80070b:	50                   	push   %eax
  80070c:	ff 75 08             	pushl  0x8(%ebp)
  80070f:	e8 23 fc ff ff       	call   800337 <fd_lookup>
  800714:	83 c4 08             	add    $0x8,%esp
  800717:	85 c0                	test   %eax,%eax
  800719:	78 0e                	js     800729 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80071b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80071e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800721:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800724:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800729:	c9                   	leave  
  80072a:	c3                   	ret    

0080072b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	53                   	push   %ebx
  80072f:	83 ec 14             	sub    $0x14,%esp
  800732:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800735:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800738:	50                   	push   %eax
  800739:	53                   	push   %ebx
  80073a:	e8 f8 fb ff ff       	call   800337 <fd_lookup>
  80073f:	83 c4 08             	add    $0x8,%esp
  800742:	89 c2                	mov    %eax,%edx
  800744:	85 c0                	test   %eax,%eax
  800746:	78 65                	js     8007ad <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800748:	83 ec 08             	sub    $0x8,%esp
  80074b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80074e:	50                   	push   %eax
  80074f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800752:	ff 30                	pushl  (%eax)
  800754:	e8 34 fc ff ff       	call   80038d <dev_lookup>
  800759:	83 c4 10             	add    $0x10,%esp
  80075c:	85 c0                	test   %eax,%eax
  80075e:	78 44                	js     8007a4 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800763:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800767:	75 21                	jne    80078a <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800769:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80076e:	8b 40 48             	mov    0x48(%eax),%eax
  800771:	83 ec 04             	sub    $0x4,%esp
  800774:	53                   	push   %ebx
  800775:	50                   	push   %eax
  800776:	68 98 1d 80 00       	push   $0x801d98
  80077b:	e8 26 09 00 00       	call   8010a6 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800780:	83 c4 10             	add    $0x10,%esp
  800783:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800788:	eb 23                	jmp    8007ad <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  80078a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80078d:	8b 52 18             	mov    0x18(%edx),%edx
  800790:	85 d2                	test   %edx,%edx
  800792:	74 14                	je     8007a8 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800794:	83 ec 08             	sub    $0x8,%esp
  800797:	ff 75 0c             	pushl  0xc(%ebp)
  80079a:	50                   	push   %eax
  80079b:	ff d2                	call   *%edx
  80079d:	89 c2                	mov    %eax,%edx
  80079f:	83 c4 10             	add    $0x10,%esp
  8007a2:	eb 09                	jmp    8007ad <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007a4:	89 c2                	mov    %eax,%edx
  8007a6:	eb 05                	jmp    8007ad <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8007a8:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  8007ad:	89 d0                	mov    %edx,%eax
  8007af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b2:	c9                   	leave  
  8007b3:	c3                   	ret    

008007b4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8007b4:	55                   	push   %ebp
  8007b5:	89 e5                	mov    %esp,%ebp
  8007b7:	53                   	push   %ebx
  8007b8:	83 ec 14             	sub    $0x14,%esp
  8007bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007be:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007c1:	50                   	push   %eax
  8007c2:	ff 75 08             	pushl  0x8(%ebp)
  8007c5:	e8 6d fb ff ff       	call   800337 <fd_lookup>
  8007ca:	83 c4 08             	add    $0x8,%esp
  8007cd:	89 c2                	mov    %eax,%edx
  8007cf:	85 c0                	test   %eax,%eax
  8007d1:	78 58                	js     80082b <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007d3:	83 ec 08             	sub    $0x8,%esp
  8007d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007d9:	50                   	push   %eax
  8007da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007dd:	ff 30                	pushl  (%eax)
  8007df:	e8 a9 fb ff ff       	call   80038d <dev_lookup>
  8007e4:	83 c4 10             	add    $0x10,%esp
  8007e7:	85 c0                	test   %eax,%eax
  8007e9:	78 37                	js     800822 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  8007eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007ee:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8007f2:	74 32                	je     800826 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8007f4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8007f7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8007fe:	00 00 00 
	stat->st_isdir = 0;
  800801:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800808:	00 00 00 
	stat->st_dev = dev;
  80080b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800811:	83 ec 08             	sub    $0x8,%esp
  800814:	53                   	push   %ebx
  800815:	ff 75 f0             	pushl  -0x10(%ebp)
  800818:	ff 50 14             	call   *0x14(%eax)
  80081b:	89 c2                	mov    %eax,%edx
  80081d:	83 c4 10             	add    $0x10,%esp
  800820:	eb 09                	jmp    80082b <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800822:	89 c2                	mov    %eax,%edx
  800824:	eb 05                	jmp    80082b <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800826:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80082b:	89 d0                	mov    %edx,%eax
  80082d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800830:	c9                   	leave  
  800831:	c3                   	ret    

00800832 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
  800835:	56                   	push   %esi
  800836:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800837:	83 ec 08             	sub    $0x8,%esp
  80083a:	6a 00                	push   $0x0
  80083c:	ff 75 08             	pushl  0x8(%ebp)
  80083f:	e8 06 02 00 00       	call   800a4a <open>
  800844:	89 c3                	mov    %eax,%ebx
  800846:	83 c4 10             	add    $0x10,%esp
  800849:	85 c0                	test   %eax,%eax
  80084b:	78 1b                	js     800868 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80084d:	83 ec 08             	sub    $0x8,%esp
  800850:	ff 75 0c             	pushl  0xc(%ebp)
  800853:	50                   	push   %eax
  800854:	e8 5b ff ff ff       	call   8007b4 <fstat>
  800859:	89 c6                	mov    %eax,%esi
	close(fd);
  80085b:	89 1c 24             	mov    %ebx,(%esp)
  80085e:	e8 fd fb ff ff       	call   800460 <close>
	return r;
  800863:	83 c4 10             	add    $0x10,%esp
  800866:	89 f0                	mov    %esi,%eax
}
  800868:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80086b:	5b                   	pop    %ebx
  80086c:	5e                   	pop    %esi
  80086d:	5d                   	pop    %ebp
  80086e:	c3                   	ret    

0080086f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
  800872:	56                   	push   %esi
  800873:	53                   	push   %ebx
  800874:	89 c6                	mov    %eax,%esi
  800876:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800878:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80087f:	75 12                	jne    800893 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800881:	83 ec 0c             	sub    $0xc,%esp
  800884:	6a 01                	push   $0x1
  800886:	e8 94 11 00 00       	call   801a1f <ipc_find_env>
  80088b:	a3 00 40 80 00       	mov    %eax,0x804000
  800890:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800893:	6a 07                	push   $0x7
  800895:	68 00 50 80 00       	push   $0x805000
  80089a:	56                   	push   %esi
  80089b:	ff 35 00 40 80 00    	pushl  0x804000
  8008a1:	e8 25 11 00 00       	call   8019cb <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8008a6:	83 c4 0c             	add    $0xc,%esp
  8008a9:	6a 00                	push   $0x0
  8008ab:	53                   	push   %ebx
  8008ac:	6a 00                	push   $0x0
  8008ae:	e8 ad 10 00 00       	call   801960 <ipc_recv>
}
  8008b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008b6:	5b                   	pop    %ebx
  8008b7:	5e                   	pop    %esi
  8008b8:	5d                   	pop    %ebp
  8008b9:	c3                   	ret    

008008ba <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
  8008bd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8008c6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8008cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ce:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8008d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d8:	b8 02 00 00 00       	mov    $0x2,%eax
  8008dd:	e8 8d ff ff ff       	call   80086f <fsipc>
}
  8008e2:	c9                   	leave  
  8008e3:	c3                   	ret    

008008e4 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8008f0:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8008f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008fa:	b8 06 00 00 00       	mov    $0x6,%eax
  8008ff:	e8 6b ff ff ff       	call   80086f <fsipc>
}
  800904:	c9                   	leave  
  800905:	c3                   	ret    

00800906 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	53                   	push   %ebx
  80090a:	83 ec 04             	sub    $0x4,%esp
  80090d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	8b 40 0c             	mov    0xc(%eax),%eax
  800916:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80091b:	ba 00 00 00 00       	mov    $0x0,%edx
  800920:	b8 05 00 00 00       	mov    $0x5,%eax
  800925:	e8 45 ff ff ff       	call   80086f <fsipc>
  80092a:	85 c0                	test   %eax,%eax
  80092c:	78 2c                	js     80095a <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80092e:	83 ec 08             	sub    $0x8,%esp
  800931:	68 00 50 80 00       	push   $0x805000
  800936:	53                   	push   %ebx
  800937:	e8 dc 0c 00 00       	call   801618 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80093c:	a1 80 50 80 00       	mov    0x805080,%eax
  800941:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800947:	a1 84 50 80 00       	mov    0x805084,%eax
  80094c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800952:	83 c4 10             	add    $0x10,%esp
  800955:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80095a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80095d:	c9                   	leave  
  80095e:	c3                   	ret    

0080095f <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80095f:	55                   	push   %ebp
  800960:	89 e5                	mov    %esp,%ebp
  800962:	83 ec 08             	sub    $0x8,%esp
  800965:	8b 55 0c             	mov    0xc(%ebp),%edx
  800968:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80096b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80096e:	8b 49 0c             	mov    0xc(%ecx),%ecx
  800971:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  800977:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80097c:	76 22                	jbe    8009a0 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  80097e:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  800985:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  800988:	83 ec 04             	sub    $0x4,%esp
  80098b:	68 f8 0f 00 00       	push   $0xff8
  800990:	52                   	push   %edx
  800991:	68 08 50 80 00       	push   $0x805008
  800996:	e8 10 0e 00 00       	call   8017ab <memmove>
  80099b:	83 c4 10             	add    $0x10,%esp
  80099e:	eb 17                	jmp    8009b7 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  8009a0:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  8009a5:	83 ec 04             	sub    $0x4,%esp
  8009a8:	50                   	push   %eax
  8009a9:	52                   	push   %edx
  8009aa:	68 08 50 80 00       	push   $0x805008
  8009af:	e8 f7 0d 00 00       	call   8017ab <memmove>
  8009b4:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  8009b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009bc:	b8 04 00 00 00       	mov    $0x4,%eax
  8009c1:	e8 a9 fe ff ff       	call   80086f <fsipc>
	if (result < 0)
		return result;

	return result;
}
  8009c6:	c9                   	leave  
  8009c7:	c3                   	ret    

008009c8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8009c8:	55                   	push   %ebp
  8009c9:	89 e5                	mov    %esp,%ebp
  8009cb:	56                   	push   %esi
  8009cc:	53                   	push   %ebx
  8009cd:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8009d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8009d6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8009db:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8009e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e6:	b8 03 00 00 00       	mov    $0x3,%eax
  8009eb:	e8 7f fe ff ff       	call   80086f <fsipc>
  8009f0:	89 c3                	mov    %eax,%ebx
  8009f2:	85 c0                	test   %eax,%eax
  8009f4:	78 4b                	js     800a41 <devfile_read+0x79>
		return r;
	assert(r <= n);
  8009f6:	39 c6                	cmp    %eax,%esi
  8009f8:	73 16                	jae    800a10 <devfile_read+0x48>
  8009fa:	68 04 1e 80 00       	push   $0x801e04
  8009ff:	68 0b 1e 80 00       	push   $0x801e0b
  800a04:	6a 7c                	push   $0x7c
  800a06:	68 20 1e 80 00       	push   $0x801e20
  800a0b:	e8 bd 05 00 00       	call   800fcd <_panic>
	assert(r <= PGSIZE);
  800a10:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a15:	7e 16                	jle    800a2d <devfile_read+0x65>
  800a17:	68 2b 1e 80 00       	push   $0x801e2b
  800a1c:	68 0b 1e 80 00       	push   $0x801e0b
  800a21:	6a 7d                	push   $0x7d
  800a23:	68 20 1e 80 00       	push   $0x801e20
  800a28:	e8 a0 05 00 00       	call   800fcd <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a2d:	83 ec 04             	sub    $0x4,%esp
  800a30:	50                   	push   %eax
  800a31:	68 00 50 80 00       	push   $0x805000
  800a36:	ff 75 0c             	pushl  0xc(%ebp)
  800a39:	e8 6d 0d 00 00       	call   8017ab <memmove>
	return r;
  800a3e:	83 c4 10             	add    $0x10,%esp
}
  800a41:	89 d8                	mov    %ebx,%eax
  800a43:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a46:	5b                   	pop    %ebx
  800a47:	5e                   	pop    %esi
  800a48:	5d                   	pop    %ebp
  800a49:	c3                   	ret    

00800a4a <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	53                   	push   %ebx
  800a4e:	83 ec 20             	sub    $0x20,%esp
  800a51:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800a54:	53                   	push   %ebx
  800a55:	e8 85 0b 00 00       	call   8015df <strlen>
  800a5a:	83 c4 10             	add    $0x10,%esp
  800a5d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800a62:	7f 67                	jg     800acb <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800a64:	83 ec 0c             	sub    $0xc,%esp
  800a67:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a6a:	50                   	push   %eax
  800a6b:	e8 78 f8 ff ff       	call   8002e8 <fd_alloc>
  800a70:	83 c4 10             	add    $0x10,%esp
		return r;
  800a73:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800a75:	85 c0                	test   %eax,%eax
  800a77:	78 57                	js     800ad0 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800a79:	83 ec 08             	sub    $0x8,%esp
  800a7c:	53                   	push   %ebx
  800a7d:	68 00 50 80 00       	push   $0x805000
  800a82:	e8 91 0b 00 00       	call   801618 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8a:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800a8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a92:	b8 01 00 00 00       	mov    $0x1,%eax
  800a97:	e8 d3 fd ff ff       	call   80086f <fsipc>
  800a9c:	89 c3                	mov    %eax,%ebx
  800a9e:	83 c4 10             	add    $0x10,%esp
  800aa1:	85 c0                	test   %eax,%eax
  800aa3:	79 14                	jns    800ab9 <open+0x6f>
		fd_close(fd, 0);
  800aa5:	83 ec 08             	sub    $0x8,%esp
  800aa8:	6a 00                	push   $0x0
  800aaa:	ff 75 f4             	pushl  -0xc(%ebp)
  800aad:	e8 2e f9 ff ff       	call   8003e0 <fd_close>
		return r;
  800ab2:	83 c4 10             	add    $0x10,%esp
  800ab5:	89 da                	mov    %ebx,%edx
  800ab7:	eb 17                	jmp    800ad0 <open+0x86>
	}

	return fd2num(fd);
  800ab9:	83 ec 0c             	sub    $0xc,%esp
  800abc:	ff 75 f4             	pushl  -0xc(%ebp)
  800abf:	e8 fc f7 ff ff       	call   8002c0 <fd2num>
  800ac4:	89 c2                	mov    %eax,%edx
  800ac6:	83 c4 10             	add    $0x10,%esp
  800ac9:	eb 05                	jmp    800ad0 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800acb:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800ad0:	89 d0                	mov    %edx,%eax
  800ad2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ad5:	c9                   	leave  
  800ad6:	c3                   	ret    

00800ad7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800add:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae2:	b8 08 00 00 00       	mov    $0x8,%eax
  800ae7:	e8 83 fd ff ff       	call   80086f <fsipc>
}
  800aec:	c9                   	leave  
  800aed:	c3                   	ret    

00800aee <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	56                   	push   %esi
  800af2:	53                   	push   %ebx
  800af3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800af6:	83 ec 0c             	sub    $0xc,%esp
  800af9:	ff 75 08             	pushl  0x8(%ebp)
  800afc:	e8 cf f7 ff ff       	call   8002d0 <fd2data>
  800b01:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800b03:	83 c4 08             	add    $0x8,%esp
  800b06:	68 37 1e 80 00       	push   $0x801e37
  800b0b:	53                   	push   %ebx
  800b0c:	e8 07 0b 00 00       	call   801618 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800b11:	8b 46 04             	mov    0x4(%esi),%eax
  800b14:	2b 06                	sub    (%esi),%eax
  800b16:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800b1c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800b23:	00 00 00 
	stat->st_dev = &devpipe;
  800b26:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800b2d:	30 80 00 
	return 0;
}
  800b30:	b8 00 00 00 00       	mov    $0x0,%eax
  800b35:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b38:	5b                   	pop    %ebx
  800b39:	5e                   	pop    %esi
  800b3a:	5d                   	pop    %ebp
  800b3b:	c3                   	ret    

00800b3c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	53                   	push   %ebx
  800b40:	83 ec 0c             	sub    $0xc,%esp
  800b43:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800b46:	53                   	push   %ebx
  800b47:	6a 00                	push   $0x0
  800b49:	e8 9f f6 ff ff       	call   8001ed <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800b4e:	89 1c 24             	mov    %ebx,(%esp)
  800b51:	e8 7a f7 ff ff       	call   8002d0 <fd2data>
  800b56:	83 c4 08             	add    $0x8,%esp
  800b59:	50                   	push   %eax
  800b5a:	6a 00                	push   $0x0
  800b5c:	e8 8c f6 ff ff       	call   8001ed <sys_page_unmap>
}
  800b61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b64:	c9                   	leave  
  800b65:	c3                   	ret    

00800b66 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	57                   	push   %edi
  800b6a:	56                   	push   %esi
  800b6b:	53                   	push   %ebx
  800b6c:	83 ec 1c             	sub    $0x1c,%esp
  800b6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b72:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  800b74:	a1 04 40 80 00       	mov    0x804004,%eax
  800b79:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  800b7c:	83 ec 0c             	sub    $0xc,%esp
  800b7f:	ff 75 e0             	pushl  -0x20(%ebp)
  800b82:	e8 d1 0e 00 00       	call   801a58 <pageref>
  800b87:	89 c3                	mov    %eax,%ebx
  800b89:	89 3c 24             	mov    %edi,(%esp)
  800b8c:	e8 c7 0e 00 00       	call   801a58 <pageref>
  800b91:	83 c4 10             	add    $0x10,%esp
  800b94:	39 c3                	cmp    %eax,%ebx
  800b96:	0f 94 c1             	sete   %cl
  800b99:	0f b6 c9             	movzbl %cl,%ecx
  800b9c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  800b9f:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800ba5:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800ba8:	39 ce                	cmp    %ecx,%esi
  800baa:	74 1b                	je     800bc7 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  800bac:	39 c3                	cmp    %eax,%ebx
  800bae:	75 c4                	jne    800b74 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800bb0:	8b 42 58             	mov    0x58(%edx),%eax
  800bb3:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bb6:	50                   	push   %eax
  800bb7:	56                   	push   %esi
  800bb8:	68 3e 1e 80 00       	push   $0x801e3e
  800bbd:	e8 e4 04 00 00       	call   8010a6 <cprintf>
  800bc2:	83 c4 10             	add    $0x10,%esp
  800bc5:	eb ad                	jmp    800b74 <_pipeisclosed+0xe>
	}
}
  800bc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bcd:	5b                   	pop    %ebx
  800bce:	5e                   	pop    %esi
  800bcf:	5f                   	pop    %edi
  800bd0:	5d                   	pop    %ebp
  800bd1:	c3                   	ret    

00800bd2 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	57                   	push   %edi
  800bd6:	56                   	push   %esi
  800bd7:	53                   	push   %ebx
  800bd8:	83 ec 28             	sub    $0x28,%esp
  800bdb:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  800bde:	56                   	push   %esi
  800bdf:	e8 ec f6 ff ff       	call   8002d0 <fd2data>
  800be4:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800be6:	83 c4 10             	add    $0x10,%esp
  800be9:	bf 00 00 00 00       	mov    $0x0,%edi
  800bee:	eb 4b                	jmp    800c3b <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  800bf0:	89 da                	mov    %ebx,%edx
  800bf2:	89 f0                	mov    %esi,%eax
  800bf4:	e8 6d ff ff ff       	call   800b66 <_pipeisclosed>
  800bf9:	85 c0                	test   %eax,%eax
  800bfb:	75 48                	jne    800c45 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  800bfd:	e8 7a f5 ff ff       	call   80017c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800c02:	8b 43 04             	mov    0x4(%ebx),%eax
  800c05:	8b 0b                	mov    (%ebx),%ecx
  800c07:	8d 51 20             	lea    0x20(%ecx),%edx
  800c0a:	39 d0                	cmp    %edx,%eax
  800c0c:	73 e2                	jae    800bf0 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800c0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c11:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800c15:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800c18:	89 c2                	mov    %eax,%edx
  800c1a:	c1 fa 1f             	sar    $0x1f,%edx
  800c1d:	89 d1                	mov    %edx,%ecx
  800c1f:	c1 e9 1b             	shr    $0x1b,%ecx
  800c22:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800c25:	83 e2 1f             	and    $0x1f,%edx
  800c28:	29 ca                	sub    %ecx,%edx
  800c2a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800c2e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800c32:	83 c0 01             	add    $0x1,%eax
  800c35:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800c38:	83 c7 01             	add    $0x1,%edi
  800c3b:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c3e:	75 c2                	jne    800c02 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  800c40:	8b 45 10             	mov    0x10(%ebp),%eax
  800c43:	eb 05                	jmp    800c4a <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800c45:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  800c4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c4d:	5b                   	pop    %ebx
  800c4e:	5e                   	pop    %esi
  800c4f:	5f                   	pop    %edi
  800c50:	5d                   	pop    %ebp
  800c51:	c3                   	ret    

00800c52 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	57                   	push   %edi
  800c56:	56                   	push   %esi
  800c57:	53                   	push   %ebx
  800c58:	83 ec 18             	sub    $0x18,%esp
  800c5b:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  800c5e:	57                   	push   %edi
  800c5f:	e8 6c f6 ff ff       	call   8002d0 <fd2data>
  800c64:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800c66:	83 c4 10             	add    $0x10,%esp
  800c69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c6e:	eb 3d                	jmp    800cad <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  800c70:	85 db                	test   %ebx,%ebx
  800c72:	74 04                	je     800c78 <devpipe_read+0x26>
				return i;
  800c74:	89 d8                	mov    %ebx,%eax
  800c76:	eb 44                	jmp    800cbc <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  800c78:	89 f2                	mov    %esi,%edx
  800c7a:	89 f8                	mov    %edi,%eax
  800c7c:	e8 e5 fe ff ff       	call   800b66 <_pipeisclosed>
  800c81:	85 c0                	test   %eax,%eax
  800c83:	75 32                	jne    800cb7 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  800c85:	e8 f2 f4 ff ff       	call   80017c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  800c8a:	8b 06                	mov    (%esi),%eax
  800c8c:	3b 46 04             	cmp    0x4(%esi),%eax
  800c8f:	74 df                	je     800c70 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800c91:	99                   	cltd   
  800c92:	c1 ea 1b             	shr    $0x1b,%edx
  800c95:	01 d0                	add    %edx,%eax
  800c97:	83 e0 1f             	and    $0x1f,%eax
  800c9a:	29 d0                	sub    %edx,%eax
  800c9c:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  800ca1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca4:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  800ca7:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800caa:	83 c3 01             	add    $0x1,%ebx
  800cad:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800cb0:	75 d8                	jne    800c8a <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  800cb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb5:	eb 05                	jmp    800cbc <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800cb7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  800cbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cbf:	5b                   	pop    %ebx
  800cc0:	5e                   	pop    %esi
  800cc1:	5f                   	pop    %edi
  800cc2:	5d                   	pop    %ebp
  800cc3:	c3                   	ret    

00800cc4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	56                   	push   %esi
  800cc8:	53                   	push   %ebx
  800cc9:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  800ccc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ccf:	50                   	push   %eax
  800cd0:	e8 13 f6 ff ff       	call   8002e8 <fd_alloc>
  800cd5:	83 c4 10             	add    $0x10,%esp
  800cd8:	89 c2                	mov    %eax,%edx
  800cda:	85 c0                	test   %eax,%eax
  800cdc:	0f 88 2c 01 00 00    	js     800e0e <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800ce2:	83 ec 04             	sub    $0x4,%esp
  800ce5:	68 07 04 00 00       	push   $0x407
  800cea:	ff 75 f4             	pushl  -0xc(%ebp)
  800ced:	6a 00                	push   $0x0
  800cef:	e8 af f4 ff ff       	call   8001a3 <sys_page_alloc>
  800cf4:	83 c4 10             	add    $0x10,%esp
  800cf7:	89 c2                	mov    %eax,%edx
  800cf9:	85 c0                	test   %eax,%eax
  800cfb:	0f 88 0d 01 00 00    	js     800e0e <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  800d01:	83 ec 0c             	sub    $0xc,%esp
  800d04:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d07:	50                   	push   %eax
  800d08:	e8 db f5 ff ff       	call   8002e8 <fd_alloc>
  800d0d:	89 c3                	mov    %eax,%ebx
  800d0f:	83 c4 10             	add    $0x10,%esp
  800d12:	85 c0                	test   %eax,%eax
  800d14:	0f 88 e2 00 00 00    	js     800dfc <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d1a:	83 ec 04             	sub    $0x4,%esp
  800d1d:	68 07 04 00 00       	push   $0x407
  800d22:	ff 75 f0             	pushl  -0x10(%ebp)
  800d25:	6a 00                	push   $0x0
  800d27:	e8 77 f4 ff ff       	call   8001a3 <sys_page_alloc>
  800d2c:	89 c3                	mov    %eax,%ebx
  800d2e:	83 c4 10             	add    $0x10,%esp
  800d31:	85 c0                	test   %eax,%eax
  800d33:	0f 88 c3 00 00 00    	js     800dfc <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  800d39:	83 ec 0c             	sub    $0xc,%esp
  800d3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800d3f:	e8 8c f5 ff ff       	call   8002d0 <fd2data>
  800d44:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d46:	83 c4 0c             	add    $0xc,%esp
  800d49:	68 07 04 00 00       	push   $0x407
  800d4e:	50                   	push   %eax
  800d4f:	6a 00                	push   $0x0
  800d51:	e8 4d f4 ff ff       	call   8001a3 <sys_page_alloc>
  800d56:	89 c3                	mov    %eax,%ebx
  800d58:	83 c4 10             	add    $0x10,%esp
  800d5b:	85 c0                	test   %eax,%eax
  800d5d:	0f 88 89 00 00 00    	js     800dec <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d63:	83 ec 0c             	sub    $0xc,%esp
  800d66:	ff 75 f0             	pushl  -0x10(%ebp)
  800d69:	e8 62 f5 ff ff       	call   8002d0 <fd2data>
  800d6e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800d75:	50                   	push   %eax
  800d76:	6a 00                	push   $0x0
  800d78:	56                   	push   %esi
  800d79:	6a 00                	push   $0x0
  800d7b:	e8 47 f4 ff ff       	call   8001c7 <sys_page_map>
  800d80:	89 c3                	mov    %eax,%ebx
  800d82:	83 c4 20             	add    $0x20,%esp
  800d85:	85 c0                	test   %eax,%eax
  800d87:	78 55                	js     800dde <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  800d89:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d92:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d97:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  800d9e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800da7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dac:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  800db3:	83 ec 0c             	sub    $0xc,%esp
  800db6:	ff 75 f4             	pushl  -0xc(%ebp)
  800db9:	e8 02 f5 ff ff       	call   8002c0 <fd2num>
  800dbe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dc1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800dc3:	83 c4 04             	add    $0x4,%esp
  800dc6:	ff 75 f0             	pushl  -0x10(%ebp)
  800dc9:	e8 f2 f4 ff ff       	call   8002c0 <fd2num>
  800dce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dd1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800dd4:	83 c4 10             	add    $0x10,%esp
  800dd7:	ba 00 00 00 00       	mov    $0x0,%edx
  800ddc:	eb 30                	jmp    800e0e <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  800dde:	83 ec 08             	sub    $0x8,%esp
  800de1:	56                   	push   %esi
  800de2:	6a 00                	push   $0x0
  800de4:	e8 04 f4 ff ff       	call   8001ed <sys_page_unmap>
  800de9:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  800dec:	83 ec 08             	sub    $0x8,%esp
  800def:	ff 75 f0             	pushl  -0x10(%ebp)
  800df2:	6a 00                	push   $0x0
  800df4:	e8 f4 f3 ff ff       	call   8001ed <sys_page_unmap>
  800df9:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  800dfc:	83 ec 08             	sub    $0x8,%esp
  800dff:	ff 75 f4             	pushl  -0xc(%ebp)
  800e02:	6a 00                	push   $0x0
  800e04:	e8 e4 f3 ff ff       	call   8001ed <sys_page_unmap>
  800e09:	83 c4 10             	add    $0x10,%esp
  800e0c:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  800e0e:	89 d0                	mov    %edx,%eax
  800e10:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e13:	5b                   	pop    %ebx
  800e14:	5e                   	pop    %esi
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e1d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e20:	50                   	push   %eax
  800e21:	ff 75 08             	pushl  0x8(%ebp)
  800e24:	e8 0e f5 ff ff       	call   800337 <fd_lookup>
  800e29:	83 c4 10             	add    $0x10,%esp
  800e2c:	85 c0                	test   %eax,%eax
  800e2e:	78 18                	js     800e48 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  800e30:	83 ec 0c             	sub    $0xc,%esp
  800e33:	ff 75 f4             	pushl  -0xc(%ebp)
  800e36:	e8 95 f4 ff ff       	call   8002d0 <fd2data>
	return _pipeisclosed(fd, p);
  800e3b:	89 c2                	mov    %eax,%edx
  800e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e40:	e8 21 fd ff ff       	call   800b66 <_pipeisclosed>
  800e45:	83 c4 10             	add    $0x10,%esp
}
  800e48:	c9                   	leave  
  800e49:	c3                   	ret    

00800e4a <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800e4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e52:	5d                   	pop    %ebp
  800e53:	c3                   	ret    

00800e54 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800e5a:	68 56 1e 80 00       	push   $0x801e56
  800e5f:	ff 75 0c             	pushl  0xc(%ebp)
  800e62:	e8 b1 07 00 00       	call   801618 <strcpy>
	return 0;
}
  800e67:	b8 00 00 00 00       	mov    $0x0,%eax
  800e6c:	c9                   	leave  
  800e6d:	c3                   	ret    

00800e6e <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	57                   	push   %edi
  800e72:	56                   	push   %esi
  800e73:	53                   	push   %ebx
  800e74:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800e7a:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800e7f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800e85:	eb 2d                	jmp    800eb4 <devcons_write+0x46>
		m = n - tot;
  800e87:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e8a:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  800e8c:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  800e8f:	ba 7f 00 00 00       	mov    $0x7f,%edx
  800e94:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800e97:	83 ec 04             	sub    $0x4,%esp
  800e9a:	53                   	push   %ebx
  800e9b:	03 45 0c             	add    0xc(%ebp),%eax
  800e9e:	50                   	push   %eax
  800e9f:	57                   	push   %edi
  800ea0:	e8 06 09 00 00       	call   8017ab <memmove>
		sys_cputs(buf, m);
  800ea5:	83 c4 08             	add    $0x8,%esp
  800ea8:	53                   	push   %ebx
  800ea9:	57                   	push   %edi
  800eaa:	e8 3d f2 ff ff       	call   8000ec <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800eaf:	01 de                	add    %ebx,%esi
  800eb1:	83 c4 10             	add    $0x10,%esp
  800eb4:	89 f0                	mov    %esi,%eax
  800eb6:	3b 75 10             	cmp    0x10(%ebp),%esi
  800eb9:	72 cc                	jb     800e87 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  800ebb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebe:	5b                   	pop    %ebx
  800ebf:	5e                   	pop    %esi
  800ec0:	5f                   	pop    %edi
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    

00800ec3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	83 ec 08             	sub    $0x8,%esp
  800ec9:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  800ece:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed2:	74 2a                	je     800efe <devcons_read+0x3b>
  800ed4:	eb 05                	jmp    800edb <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800ed6:	e8 a1 f2 ff ff       	call   80017c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800edb:	e8 32 f2 ff ff       	call   800112 <sys_cgetc>
  800ee0:	85 c0                	test   %eax,%eax
  800ee2:	74 f2                	je     800ed6 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800ee4:	85 c0                	test   %eax,%eax
  800ee6:	78 16                	js     800efe <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  800ee8:	83 f8 04             	cmp    $0x4,%eax
  800eeb:	74 0c                	je     800ef9 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  800eed:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef0:	88 02                	mov    %al,(%edx)
	return 1;
  800ef2:	b8 01 00 00 00       	mov    $0x1,%eax
  800ef7:	eb 05                	jmp    800efe <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  800ef9:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800efe:	c9                   	leave  
  800eff:	c3                   	ret    

00800f00 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800f0c:	6a 01                	push   $0x1
  800f0e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f11:	50                   	push   %eax
  800f12:	e8 d5 f1 ff ff       	call   8000ec <sys_cputs>
}
  800f17:	83 c4 10             	add    $0x10,%esp
  800f1a:	c9                   	leave  
  800f1b:	c3                   	ret    

00800f1c <getchar>:

int
getchar(void)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800f22:	6a 01                	push   $0x1
  800f24:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f27:	50                   	push   %eax
  800f28:	6a 00                	push   $0x0
  800f2a:	e8 6d f6 ff ff       	call   80059c <read>
	if (r < 0)
  800f2f:	83 c4 10             	add    $0x10,%esp
  800f32:	85 c0                	test   %eax,%eax
  800f34:	78 0f                	js     800f45 <getchar+0x29>
		return r;
	if (r < 1)
  800f36:	85 c0                	test   %eax,%eax
  800f38:	7e 06                	jle    800f40 <getchar+0x24>
		return -E_EOF;
	return c;
  800f3a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800f3e:	eb 05                	jmp    800f45 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800f40:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  800f45:	c9                   	leave  
  800f46:	c3                   	ret    

00800f47 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f4d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f50:	50                   	push   %eax
  800f51:	ff 75 08             	pushl  0x8(%ebp)
  800f54:	e8 de f3 ff ff       	call   800337 <fd_lookup>
  800f59:	83 c4 10             	add    $0x10,%esp
  800f5c:	85 c0                	test   %eax,%eax
  800f5e:	78 11                	js     800f71 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f63:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800f69:	39 10                	cmp    %edx,(%eax)
  800f6b:	0f 94 c0             	sete   %al
  800f6e:	0f b6 c0             	movzbl %al,%eax
}
  800f71:	c9                   	leave  
  800f72:	c3                   	ret    

00800f73 <opencons>:

int
opencons(void)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800f79:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f7c:	50                   	push   %eax
  800f7d:	e8 66 f3 ff ff       	call   8002e8 <fd_alloc>
  800f82:	83 c4 10             	add    $0x10,%esp
		return r;
  800f85:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800f87:	85 c0                	test   %eax,%eax
  800f89:	78 3e                	js     800fc9 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800f8b:	83 ec 04             	sub    $0x4,%esp
  800f8e:	68 07 04 00 00       	push   $0x407
  800f93:	ff 75 f4             	pushl  -0xc(%ebp)
  800f96:	6a 00                	push   $0x0
  800f98:	e8 06 f2 ff ff       	call   8001a3 <sys_page_alloc>
  800f9d:	83 c4 10             	add    $0x10,%esp
		return r;
  800fa0:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800fa2:	85 c0                	test   %eax,%eax
  800fa4:	78 23                	js     800fc9 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800fa6:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800faf:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800fbb:	83 ec 0c             	sub    $0xc,%esp
  800fbe:	50                   	push   %eax
  800fbf:	e8 fc f2 ff ff       	call   8002c0 <fd2num>
  800fc4:	89 c2                	mov    %eax,%edx
  800fc6:	83 c4 10             	add    $0x10,%esp
}
  800fc9:	89 d0                	mov    %edx,%eax
  800fcb:	c9                   	leave  
  800fcc:	c3                   	ret    

00800fcd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	56                   	push   %esi
  800fd1:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800fd2:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800fd5:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800fdb:	e8 78 f1 ff ff       	call   800158 <sys_getenvid>
  800fe0:	83 ec 0c             	sub    $0xc,%esp
  800fe3:	ff 75 0c             	pushl  0xc(%ebp)
  800fe6:	ff 75 08             	pushl  0x8(%ebp)
  800fe9:	56                   	push   %esi
  800fea:	50                   	push   %eax
  800feb:	68 64 1e 80 00       	push   $0x801e64
  800ff0:	e8 b1 00 00 00       	call   8010a6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800ff5:	83 c4 18             	add    $0x18,%esp
  800ff8:	53                   	push   %ebx
  800ff9:	ff 75 10             	pushl  0x10(%ebp)
  800ffc:	e8 54 00 00 00       	call   801055 <vcprintf>
	cprintf("\n");
  801001:	c7 04 24 4f 1e 80 00 	movl   $0x801e4f,(%esp)
  801008:	e8 99 00 00 00       	call   8010a6 <cprintf>
  80100d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801010:	cc                   	int3   
  801011:	eb fd                	jmp    801010 <_panic+0x43>

00801013 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	53                   	push   %ebx
  801017:	83 ec 04             	sub    $0x4,%esp
  80101a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80101d:	8b 13                	mov    (%ebx),%edx
  80101f:	8d 42 01             	lea    0x1(%edx),%eax
  801022:	89 03                	mov    %eax,(%ebx)
  801024:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801027:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80102b:	3d ff 00 00 00       	cmp    $0xff,%eax
  801030:	75 1a                	jne    80104c <putch+0x39>
		sys_cputs(b->buf, b->idx);
  801032:	83 ec 08             	sub    $0x8,%esp
  801035:	68 ff 00 00 00       	push   $0xff
  80103a:	8d 43 08             	lea    0x8(%ebx),%eax
  80103d:	50                   	push   %eax
  80103e:	e8 a9 f0 ff ff       	call   8000ec <sys_cputs>
		b->idx = 0;
  801043:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801049:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  80104c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801050:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801053:	c9                   	leave  
  801054:	c3                   	ret    

00801055 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801055:	55                   	push   %ebp
  801056:	89 e5                	mov    %esp,%ebp
  801058:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80105e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801065:	00 00 00 
	b.cnt = 0;
  801068:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80106f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801072:	ff 75 0c             	pushl  0xc(%ebp)
  801075:	ff 75 08             	pushl  0x8(%ebp)
  801078:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80107e:	50                   	push   %eax
  80107f:	68 13 10 80 00       	push   $0x801013
  801084:	e8 86 01 00 00       	call   80120f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801089:	83 c4 08             	add    $0x8,%esp
  80108c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801092:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801098:	50                   	push   %eax
  801099:	e8 4e f0 ff ff       	call   8000ec <sys_cputs>

	return b.cnt;
}
  80109e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8010a4:	c9                   	leave  
  8010a5:	c3                   	ret    

008010a6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8010ac:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8010af:	50                   	push   %eax
  8010b0:	ff 75 08             	pushl  0x8(%ebp)
  8010b3:	e8 9d ff ff ff       	call   801055 <vcprintf>
	va_end(ap);

	return cnt;
}
  8010b8:	c9                   	leave  
  8010b9:	c3                   	ret    

008010ba <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	57                   	push   %edi
  8010be:	56                   	push   %esi
  8010bf:	53                   	push   %ebx
  8010c0:	83 ec 1c             	sub    $0x1c,%esp
  8010c3:	89 c7                	mov    %eax,%edi
  8010c5:	89 d6                	mov    %edx,%esi
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8010d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010d6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010db:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8010de:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8010e1:	39 d3                	cmp    %edx,%ebx
  8010e3:	72 05                	jb     8010ea <printnum+0x30>
  8010e5:	39 45 10             	cmp    %eax,0x10(%ebp)
  8010e8:	77 45                	ja     80112f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8010ea:	83 ec 0c             	sub    $0xc,%esp
  8010ed:	ff 75 18             	pushl  0x18(%ebp)
  8010f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8010f6:	53                   	push   %ebx
  8010f7:	ff 75 10             	pushl  0x10(%ebp)
  8010fa:	83 ec 08             	sub    $0x8,%esp
  8010fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  801100:	ff 75 e0             	pushl  -0x20(%ebp)
  801103:	ff 75 dc             	pushl  -0x24(%ebp)
  801106:	ff 75 d8             	pushl  -0x28(%ebp)
  801109:	e8 92 09 00 00       	call   801aa0 <__udivdi3>
  80110e:	83 c4 18             	add    $0x18,%esp
  801111:	52                   	push   %edx
  801112:	50                   	push   %eax
  801113:	89 f2                	mov    %esi,%edx
  801115:	89 f8                	mov    %edi,%eax
  801117:	e8 9e ff ff ff       	call   8010ba <printnum>
  80111c:	83 c4 20             	add    $0x20,%esp
  80111f:	eb 18                	jmp    801139 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801121:	83 ec 08             	sub    $0x8,%esp
  801124:	56                   	push   %esi
  801125:	ff 75 18             	pushl  0x18(%ebp)
  801128:	ff d7                	call   *%edi
  80112a:	83 c4 10             	add    $0x10,%esp
  80112d:	eb 03                	jmp    801132 <printnum+0x78>
  80112f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801132:	83 eb 01             	sub    $0x1,%ebx
  801135:	85 db                	test   %ebx,%ebx
  801137:	7f e8                	jg     801121 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801139:	83 ec 08             	sub    $0x8,%esp
  80113c:	56                   	push   %esi
  80113d:	83 ec 04             	sub    $0x4,%esp
  801140:	ff 75 e4             	pushl  -0x1c(%ebp)
  801143:	ff 75 e0             	pushl  -0x20(%ebp)
  801146:	ff 75 dc             	pushl  -0x24(%ebp)
  801149:	ff 75 d8             	pushl  -0x28(%ebp)
  80114c:	e8 7f 0a 00 00       	call   801bd0 <__umoddi3>
  801151:	83 c4 14             	add    $0x14,%esp
  801154:	0f be 80 87 1e 80 00 	movsbl 0x801e87(%eax),%eax
  80115b:	50                   	push   %eax
  80115c:	ff d7                	call   *%edi
}
  80115e:	83 c4 10             	add    $0x10,%esp
  801161:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801164:	5b                   	pop    %ebx
  801165:	5e                   	pop    %esi
  801166:	5f                   	pop    %edi
  801167:	5d                   	pop    %ebp
  801168:	c3                   	ret    

00801169 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80116c:	83 fa 01             	cmp    $0x1,%edx
  80116f:	7e 0e                	jle    80117f <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801171:	8b 10                	mov    (%eax),%edx
  801173:	8d 4a 08             	lea    0x8(%edx),%ecx
  801176:	89 08                	mov    %ecx,(%eax)
  801178:	8b 02                	mov    (%edx),%eax
  80117a:	8b 52 04             	mov    0x4(%edx),%edx
  80117d:	eb 22                	jmp    8011a1 <getuint+0x38>
	else if (lflag)
  80117f:	85 d2                	test   %edx,%edx
  801181:	74 10                	je     801193 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801183:	8b 10                	mov    (%eax),%edx
  801185:	8d 4a 04             	lea    0x4(%edx),%ecx
  801188:	89 08                	mov    %ecx,(%eax)
  80118a:	8b 02                	mov    (%edx),%eax
  80118c:	ba 00 00 00 00       	mov    $0x0,%edx
  801191:	eb 0e                	jmp    8011a1 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  801193:	8b 10                	mov    (%eax),%edx
  801195:	8d 4a 04             	lea    0x4(%edx),%ecx
  801198:	89 08                	mov    %ecx,(%eax)
  80119a:	8b 02                	mov    (%edx),%eax
  80119c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8011a1:	5d                   	pop    %ebp
  8011a2:	c3                   	ret    

008011a3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8011a6:	83 fa 01             	cmp    $0x1,%edx
  8011a9:	7e 0e                	jle    8011b9 <getint+0x16>
		return va_arg(*ap, long long);
  8011ab:	8b 10                	mov    (%eax),%edx
  8011ad:	8d 4a 08             	lea    0x8(%edx),%ecx
  8011b0:	89 08                	mov    %ecx,(%eax)
  8011b2:	8b 02                	mov    (%edx),%eax
  8011b4:	8b 52 04             	mov    0x4(%edx),%edx
  8011b7:	eb 1a                	jmp    8011d3 <getint+0x30>
	else if (lflag)
  8011b9:	85 d2                	test   %edx,%edx
  8011bb:	74 0c                	je     8011c9 <getint+0x26>
		return va_arg(*ap, long);
  8011bd:	8b 10                	mov    (%eax),%edx
  8011bf:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011c2:	89 08                	mov    %ecx,(%eax)
  8011c4:	8b 02                	mov    (%edx),%eax
  8011c6:	99                   	cltd   
  8011c7:	eb 0a                	jmp    8011d3 <getint+0x30>
	else
		return va_arg(*ap, int);
  8011c9:	8b 10                	mov    (%eax),%edx
  8011cb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011ce:	89 08                	mov    %ecx,(%eax)
  8011d0:	8b 02                	mov    (%edx),%eax
  8011d2:	99                   	cltd   
}
  8011d3:	5d                   	pop    %ebp
  8011d4:	c3                   	ret    

008011d5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011d5:	55                   	push   %ebp
  8011d6:	89 e5                	mov    %esp,%ebp
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8011db:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8011df:	8b 10                	mov    (%eax),%edx
  8011e1:	3b 50 04             	cmp    0x4(%eax),%edx
  8011e4:	73 0a                	jae    8011f0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8011e6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011e9:	89 08                	mov    %ecx,(%eax)
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	88 02                	mov    %al,(%edx)
}
  8011f0:	5d                   	pop    %ebp
  8011f1:	c3                   	ret    

008011f2 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011f2:	55                   	push   %ebp
  8011f3:	89 e5                	mov    %esp,%ebp
  8011f5:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8011f8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8011fb:	50                   	push   %eax
  8011fc:	ff 75 10             	pushl  0x10(%ebp)
  8011ff:	ff 75 0c             	pushl  0xc(%ebp)
  801202:	ff 75 08             	pushl  0x8(%ebp)
  801205:	e8 05 00 00 00       	call   80120f <vprintfmt>
	va_end(ap);
}
  80120a:	83 c4 10             	add    $0x10,%esp
  80120d:	c9                   	leave  
  80120e:	c3                   	ret    

0080120f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80120f:	55                   	push   %ebp
  801210:	89 e5                	mov    %esp,%ebp
  801212:	57                   	push   %edi
  801213:	56                   	push   %esi
  801214:	53                   	push   %ebx
  801215:	83 ec 2c             	sub    $0x2c,%esp
  801218:	8b 75 08             	mov    0x8(%ebp),%esi
  80121b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80121e:	8b 7d 10             	mov    0x10(%ebp),%edi
  801221:	eb 12                	jmp    801235 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801223:	85 c0                	test   %eax,%eax
  801225:	0f 84 44 03 00 00    	je     80156f <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  80122b:	83 ec 08             	sub    $0x8,%esp
  80122e:	53                   	push   %ebx
  80122f:	50                   	push   %eax
  801230:	ff d6                	call   *%esi
  801232:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801235:	83 c7 01             	add    $0x1,%edi
  801238:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80123c:	83 f8 25             	cmp    $0x25,%eax
  80123f:	75 e2                	jne    801223 <vprintfmt+0x14>
  801241:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  801245:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80124c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801253:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80125a:	ba 00 00 00 00       	mov    $0x0,%edx
  80125f:	eb 07                	jmp    801268 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801261:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  801264:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801268:	8d 47 01             	lea    0x1(%edi),%eax
  80126b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80126e:	0f b6 07             	movzbl (%edi),%eax
  801271:	0f b6 c8             	movzbl %al,%ecx
  801274:	83 e8 23             	sub    $0x23,%eax
  801277:	3c 55                	cmp    $0x55,%al
  801279:	0f 87 d5 02 00 00    	ja     801554 <vprintfmt+0x345>
  80127f:	0f b6 c0             	movzbl %al,%eax
  801282:	ff 24 85 c0 1f 80 00 	jmp    *0x801fc0(,%eax,4)
  801289:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80128c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801290:	eb d6                	jmp    801268 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801292:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801295:	b8 00 00 00 00       	mov    $0x0,%eax
  80129a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80129d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8012a0:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8012a4:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8012a7:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8012aa:	83 fa 09             	cmp    $0x9,%edx
  8012ad:	77 39                	ja     8012e8 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8012af:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8012b2:	eb e9                	jmp    80129d <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8012b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b7:	8d 48 04             	lea    0x4(%eax),%ecx
  8012ba:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8012bd:	8b 00                	mov    (%eax),%eax
  8012bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8012c5:	eb 27                	jmp    8012ee <vprintfmt+0xdf>
  8012c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ca:	85 c0                	test   %eax,%eax
  8012cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012d1:	0f 49 c8             	cmovns %eax,%ecx
  8012d4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8012da:	eb 8c                	jmp    801268 <vprintfmt+0x59>
  8012dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8012df:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8012e6:	eb 80                	jmp    801268 <vprintfmt+0x59>
  8012e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012eb:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  8012ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012f2:	0f 89 70 ff ff ff    	jns    801268 <vprintfmt+0x59>
				width = precision, precision = -1;
  8012f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8012fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8012fe:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801305:	e9 5e ff ff ff       	jmp    801268 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80130a:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80130d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801310:	e9 53 ff ff ff       	jmp    801268 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801315:	8b 45 14             	mov    0x14(%ebp),%eax
  801318:	8d 50 04             	lea    0x4(%eax),%edx
  80131b:	89 55 14             	mov    %edx,0x14(%ebp)
  80131e:	83 ec 08             	sub    $0x8,%esp
  801321:	53                   	push   %ebx
  801322:	ff 30                	pushl  (%eax)
  801324:	ff d6                	call   *%esi
			break;
  801326:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801329:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  80132c:	e9 04 ff ff ff       	jmp    801235 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801331:	8b 45 14             	mov    0x14(%ebp),%eax
  801334:	8d 50 04             	lea    0x4(%eax),%edx
  801337:	89 55 14             	mov    %edx,0x14(%ebp)
  80133a:	8b 00                	mov    (%eax),%eax
  80133c:	99                   	cltd   
  80133d:	31 d0                	xor    %edx,%eax
  80133f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801341:	83 f8 0f             	cmp    $0xf,%eax
  801344:	7f 0b                	jg     801351 <vprintfmt+0x142>
  801346:	8b 14 85 20 21 80 00 	mov    0x802120(,%eax,4),%edx
  80134d:	85 d2                	test   %edx,%edx
  80134f:	75 18                	jne    801369 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  801351:	50                   	push   %eax
  801352:	68 9f 1e 80 00       	push   $0x801e9f
  801357:	53                   	push   %ebx
  801358:	56                   	push   %esi
  801359:	e8 94 fe ff ff       	call   8011f2 <printfmt>
  80135e:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801361:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  801364:	e9 cc fe ff ff       	jmp    801235 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  801369:	52                   	push   %edx
  80136a:	68 1d 1e 80 00       	push   $0x801e1d
  80136f:	53                   	push   %ebx
  801370:	56                   	push   %esi
  801371:	e8 7c fe ff ff       	call   8011f2 <printfmt>
  801376:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801379:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80137c:	e9 b4 fe ff ff       	jmp    801235 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801381:	8b 45 14             	mov    0x14(%ebp),%eax
  801384:	8d 50 04             	lea    0x4(%eax),%edx
  801387:	89 55 14             	mov    %edx,0x14(%ebp)
  80138a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80138c:	85 ff                	test   %edi,%edi
  80138e:	b8 98 1e 80 00       	mov    $0x801e98,%eax
  801393:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801396:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80139a:	0f 8e 94 00 00 00    	jle    801434 <vprintfmt+0x225>
  8013a0:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8013a4:	0f 84 98 00 00 00    	je     801442 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8013aa:	83 ec 08             	sub    $0x8,%esp
  8013ad:	ff 75 d0             	pushl  -0x30(%ebp)
  8013b0:	57                   	push   %edi
  8013b1:	e8 41 02 00 00       	call   8015f7 <strnlen>
  8013b6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8013b9:	29 c1                	sub    %eax,%ecx
  8013bb:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8013be:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8013c1:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8013c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013c8:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8013cb:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013cd:	eb 0f                	jmp    8013de <vprintfmt+0x1cf>
					putch(padc, putdat);
  8013cf:	83 ec 08             	sub    $0x8,%esp
  8013d2:	53                   	push   %ebx
  8013d3:	ff 75 e0             	pushl  -0x20(%ebp)
  8013d6:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013d8:	83 ef 01             	sub    $0x1,%edi
  8013db:	83 c4 10             	add    $0x10,%esp
  8013de:	85 ff                	test   %edi,%edi
  8013e0:	7f ed                	jg     8013cf <vprintfmt+0x1c0>
  8013e2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8013e5:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8013e8:	85 c9                	test   %ecx,%ecx
  8013ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ef:	0f 49 c1             	cmovns %ecx,%eax
  8013f2:	29 c1                	sub    %eax,%ecx
  8013f4:	89 75 08             	mov    %esi,0x8(%ebp)
  8013f7:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8013fa:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8013fd:	89 cb                	mov    %ecx,%ebx
  8013ff:	eb 4d                	jmp    80144e <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801401:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801405:	74 1b                	je     801422 <vprintfmt+0x213>
  801407:	0f be c0             	movsbl %al,%eax
  80140a:	83 e8 20             	sub    $0x20,%eax
  80140d:	83 f8 5e             	cmp    $0x5e,%eax
  801410:	76 10                	jbe    801422 <vprintfmt+0x213>
					putch('?', putdat);
  801412:	83 ec 08             	sub    $0x8,%esp
  801415:	ff 75 0c             	pushl  0xc(%ebp)
  801418:	6a 3f                	push   $0x3f
  80141a:	ff 55 08             	call   *0x8(%ebp)
  80141d:	83 c4 10             	add    $0x10,%esp
  801420:	eb 0d                	jmp    80142f <vprintfmt+0x220>
				else
					putch(ch, putdat);
  801422:	83 ec 08             	sub    $0x8,%esp
  801425:	ff 75 0c             	pushl  0xc(%ebp)
  801428:	52                   	push   %edx
  801429:	ff 55 08             	call   *0x8(%ebp)
  80142c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80142f:	83 eb 01             	sub    $0x1,%ebx
  801432:	eb 1a                	jmp    80144e <vprintfmt+0x23f>
  801434:	89 75 08             	mov    %esi,0x8(%ebp)
  801437:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80143a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80143d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801440:	eb 0c                	jmp    80144e <vprintfmt+0x23f>
  801442:	89 75 08             	mov    %esi,0x8(%ebp)
  801445:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801448:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80144b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80144e:	83 c7 01             	add    $0x1,%edi
  801451:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801455:	0f be d0             	movsbl %al,%edx
  801458:	85 d2                	test   %edx,%edx
  80145a:	74 23                	je     80147f <vprintfmt+0x270>
  80145c:	85 f6                	test   %esi,%esi
  80145e:	78 a1                	js     801401 <vprintfmt+0x1f2>
  801460:	83 ee 01             	sub    $0x1,%esi
  801463:	79 9c                	jns    801401 <vprintfmt+0x1f2>
  801465:	89 df                	mov    %ebx,%edi
  801467:	8b 75 08             	mov    0x8(%ebp),%esi
  80146a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80146d:	eb 18                	jmp    801487 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80146f:	83 ec 08             	sub    $0x8,%esp
  801472:	53                   	push   %ebx
  801473:	6a 20                	push   $0x20
  801475:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801477:	83 ef 01             	sub    $0x1,%edi
  80147a:	83 c4 10             	add    $0x10,%esp
  80147d:	eb 08                	jmp    801487 <vprintfmt+0x278>
  80147f:	89 df                	mov    %ebx,%edi
  801481:	8b 75 08             	mov    0x8(%ebp),%esi
  801484:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801487:	85 ff                	test   %edi,%edi
  801489:	7f e4                	jg     80146f <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80148b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80148e:	e9 a2 fd ff ff       	jmp    801235 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801493:	8d 45 14             	lea    0x14(%ebp),%eax
  801496:	e8 08 fd ff ff       	call   8011a3 <getint>
  80149b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80149e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8014a1:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8014a6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8014aa:	79 74                	jns    801520 <vprintfmt+0x311>
				putch('-', putdat);
  8014ac:	83 ec 08             	sub    $0x8,%esp
  8014af:	53                   	push   %ebx
  8014b0:	6a 2d                	push   $0x2d
  8014b2:	ff d6                	call   *%esi
				num = -(long long) num;
  8014b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014ba:	f7 d8                	neg    %eax
  8014bc:	83 d2 00             	adc    $0x0,%edx
  8014bf:	f7 da                	neg    %edx
  8014c1:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8014c4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014c9:	eb 55                	jmp    801520 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8014cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8014ce:	e8 96 fc ff ff       	call   801169 <getuint>
			base = 10;
  8014d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8014d8:	eb 46                	jmp    801520 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8014da:	8d 45 14             	lea    0x14(%ebp),%eax
  8014dd:	e8 87 fc ff ff       	call   801169 <getuint>
			base = 8;
  8014e2:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8014e7:	eb 37                	jmp    801520 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  8014e9:	83 ec 08             	sub    $0x8,%esp
  8014ec:	53                   	push   %ebx
  8014ed:	6a 30                	push   $0x30
  8014ef:	ff d6                	call   *%esi
			putch('x', putdat);
  8014f1:	83 c4 08             	add    $0x8,%esp
  8014f4:	53                   	push   %ebx
  8014f5:	6a 78                	push   $0x78
  8014f7:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8014f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014fc:	8d 50 04             	lea    0x4(%eax),%edx
  8014ff:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801502:	8b 00                	mov    (%eax),%eax
  801504:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  801509:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80150c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801511:	eb 0d                	jmp    801520 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801513:	8d 45 14             	lea    0x14(%ebp),%eax
  801516:	e8 4e fc ff ff       	call   801169 <getuint>
			base = 16;
  80151b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801520:	83 ec 0c             	sub    $0xc,%esp
  801523:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801527:	57                   	push   %edi
  801528:	ff 75 e0             	pushl  -0x20(%ebp)
  80152b:	51                   	push   %ecx
  80152c:	52                   	push   %edx
  80152d:	50                   	push   %eax
  80152e:	89 da                	mov    %ebx,%edx
  801530:	89 f0                	mov    %esi,%eax
  801532:	e8 83 fb ff ff       	call   8010ba <printnum>
			break;
  801537:	83 c4 20             	add    $0x20,%esp
  80153a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80153d:	e9 f3 fc ff ff       	jmp    801235 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801542:	83 ec 08             	sub    $0x8,%esp
  801545:	53                   	push   %ebx
  801546:	51                   	push   %ecx
  801547:	ff d6                	call   *%esi
			break;
  801549:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80154c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  80154f:	e9 e1 fc ff ff       	jmp    801235 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801554:	83 ec 08             	sub    $0x8,%esp
  801557:	53                   	push   %ebx
  801558:	6a 25                	push   $0x25
  80155a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80155c:	83 c4 10             	add    $0x10,%esp
  80155f:	eb 03                	jmp    801564 <vprintfmt+0x355>
  801561:	83 ef 01             	sub    $0x1,%edi
  801564:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  801568:	75 f7                	jne    801561 <vprintfmt+0x352>
  80156a:	e9 c6 fc ff ff       	jmp    801235 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  80156f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801572:	5b                   	pop    %ebx
  801573:	5e                   	pop    %esi
  801574:	5f                   	pop    %edi
  801575:	5d                   	pop    %ebp
  801576:	c3                   	ret    

00801577 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	83 ec 18             	sub    $0x18,%esp
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801583:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801586:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80158a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80158d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801594:	85 c0                	test   %eax,%eax
  801596:	74 26                	je     8015be <vsnprintf+0x47>
  801598:	85 d2                	test   %edx,%edx
  80159a:	7e 22                	jle    8015be <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80159c:	ff 75 14             	pushl  0x14(%ebp)
  80159f:	ff 75 10             	pushl  0x10(%ebp)
  8015a2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8015a5:	50                   	push   %eax
  8015a6:	68 d5 11 80 00       	push   $0x8011d5
  8015ab:	e8 5f fc ff ff       	call   80120f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8015b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8015b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b9:	83 c4 10             	add    $0x10,%esp
  8015bc:	eb 05                	jmp    8015c3 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8015be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    

008015c5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8015cb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8015ce:	50                   	push   %eax
  8015cf:	ff 75 10             	pushl  0x10(%ebp)
  8015d2:	ff 75 0c             	pushl  0xc(%ebp)
  8015d5:	ff 75 08             	pushl  0x8(%ebp)
  8015d8:	e8 9a ff ff ff       	call   801577 <vsnprintf>
	va_end(ap);

	return rc;
}
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8015e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ea:	eb 03                	jmp    8015ef <strlen+0x10>
		n++;
  8015ec:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015ef:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8015f3:	75 f7                	jne    8015ec <strlen+0xd>
		n++;
	return n;
}
  8015f5:	5d                   	pop    %ebp
  8015f6:	c3                   	ret    

008015f7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801600:	ba 00 00 00 00       	mov    $0x0,%edx
  801605:	eb 03                	jmp    80160a <strnlen+0x13>
		n++;
  801607:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80160a:	39 c2                	cmp    %eax,%edx
  80160c:	74 08                	je     801616 <strnlen+0x1f>
  80160e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801612:	75 f3                	jne    801607 <strnlen+0x10>
  801614:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  801616:	5d                   	pop    %ebp
  801617:	c3                   	ret    

00801618 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801618:	55                   	push   %ebp
  801619:	89 e5                	mov    %esp,%ebp
  80161b:	53                   	push   %ebx
  80161c:	8b 45 08             	mov    0x8(%ebp),%eax
  80161f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801622:	89 c2                	mov    %eax,%edx
  801624:	83 c2 01             	add    $0x1,%edx
  801627:	83 c1 01             	add    $0x1,%ecx
  80162a:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80162e:	88 5a ff             	mov    %bl,-0x1(%edx)
  801631:	84 db                	test   %bl,%bl
  801633:	75 ef                	jne    801624 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801635:	5b                   	pop    %ebx
  801636:	5d                   	pop    %ebp
  801637:	c3                   	ret    

00801638 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	53                   	push   %ebx
  80163c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80163f:	53                   	push   %ebx
  801640:	e8 9a ff ff ff       	call   8015df <strlen>
  801645:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801648:	ff 75 0c             	pushl  0xc(%ebp)
  80164b:	01 d8                	add    %ebx,%eax
  80164d:	50                   	push   %eax
  80164e:	e8 c5 ff ff ff       	call   801618 <strcpy>
	return dst;
}
  801653:	89 d8                	mov    %ebx,%eax
  801655:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	56                   	push   %esi
  80165e:	53                   	push   %ebx
  80165f:	8b 75 08             	mov    0x8(%ebp),%esi
  801662:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801665:	89 f3                	mov    %esi,%ebx
  801667:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80166a:	89 f2                	mov    %esi,%edx
  80166c:	eb 0f                	jmp    80167d <strncpy+0x23>
		*dst++ = *src;
  80166e:	83 c2 01             	add    $0x1,%edx
  801671:	0f b6 01             	movzbl (%ecx),%eax
  801674:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801677:	80 39 01             	cmpb   $0x1,(%ecx)
  80167a:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80167d:	39 da                	cmp    %ebx,%edx
  80167f:	75 ed                	jne    80166e <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801681:	89 f0                	mov    %esi,%eax
  801683:	5b                   	pop    %ebx
  801684:	5e                   	pop    %esi
  801685:	5d                   	pop    %ebp
  801686:	c3                   	ret    

00801687 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	56                   	push   %esi
  80168b:	53                   	push   %ebx
  80168c:	8b 75 08             	mov    0x8(%ebp),%esi
  80168f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801692:	8b 55 10             	mov    0x10(%ebp),%edx
  801695:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801697:	85 d2                	test   %edx,%edx
  801699:	74 21                	je     8016bc <strlcpy+0x35>
  80169b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80169f:	89 f2                	mov    %esi,%edx
  8016a1:	eb 09                	jmp    8016ac <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8016a3:	83 c2 01             	add    $0x1,%edx
  8016a6:	83 c1 01             	add    $0x1,%ecx
  8016a9:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016ac:	39 c2                	cmp    %eax,%edx
  8016ae:	74 09                	je     8016b9 <strlcpy+0x32>
  8016b0:	0f b6 19             	movzbl (%ecx),%ebx
  8016b3:	84 db                	test   %bl,%bl
  8016b5:	75 ec                	jne    8016a3 <strlcpy+0x1c>
  8016b7:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  8016b9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016bc:	29 f0                	sub    %esi,%eax
}
  8016be:	5b                   	pop    %ebx
  8016bf:	5e                   	pop    %esi
  8016c0:	5d                   	pop    %ebp
  8016c1:	c3                   	ret    

008016c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
  8016c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016c8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8016cb:	eb 06                	jmp    8016d3 <strcmp+0x11>
		p++, q++;
  8016cd:	83 c1 01             	add    $0x1,%ecx
  8016d0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016d3:	0f b6 01             	movzbl (%ecx),%eax
  8016d6:	84 c0                	test   %al,%al
  8016d8:	74 04                	je     8016de <strcmp+0x1c>
  8016da:	3a 02                	cmp    (%edx),%al
  8016dc:	74 ef                	je     8016cd <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016de:	0f b6 c0             	movzbl %al,%eax
  8016e1:	0f b6 12             	movzbl (%edx),%edx
  8016e4:	29 d0                	sub    %edx,%eax
}
  8016e6:	5d                   	pop    %ebp
  8016e7:	c3                   	ret    

008016e8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	53                   	push   %ebx
  8016ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f2:	89 c3                	mov    %eax,%ebx
  8016f4:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8016f7:	eb 06                	jmp    8016ff <strncmp+0x17>
		n--, p++, q++;
  8016f9:	83 c0 01             	add    $0x1,%eax
  8016fc:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8016ff:	39 d8                	cmp    %ebx,%eax
  801701:	74 15                	je     801718 <strncmp+0x30>
  801703:	0f b6 08             	movzbl (%eax),%ecx
  801706:	84 c9                	test   %cl,%cl
  801708:	74 04                	je     80170e <strncmp+0x26>
  80170a:	3a 0a                	cmp    (%edx),%cl
  80170c:	74 eb                	je     8016f9 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80170e:	0f b6 00             	movzbl (%eax),%eax
  801711:	0f b6 12             	movzbl (%edx),%edx
  801714:	29 d0                	sub    %edx,%eax
  801716:	eb 05                	jmp    80171d <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801718:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  80171d:	5b                   	pop    %ebx
  80171e:	5d                   	pop    %ebp
  80171f:	c3                   	ret    

00801720 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80172a:	eb 07                	jmp    801733 <strchr+0x13>
		if (*s == c)
  80172c:	38 ca                	cmp    %cl,%dl
  80172e:	74 0f                	je     80173f <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801730:	83 c0 01             	add    $0x1,%eax
  801733:	0f b6 10             	movzbl (%eax),%edx
  801736:	84 d2                	test   %dl,%dl
  801738:	75 f2                	jne    80172c <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  80173a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173f:	5d                   	pop    %ebp
  801740:	c3                   	ret    

00801741 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80174b:	eb 03                	jmp    801750 <strfind+0xf>
  80174d:	83 c0 01             	add    $0x1,%eax
  801750:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801753:	38 ca                	cmp    %cl,%dl
  801755:	74 04                	je     80175b <strfind+0x1a>
  801757:	84 d2                	test   %dl,%dl
  801759:	75 f2                	jne    80174d <strfind+0xc>
			break;
	return (char *) s;
}
  80175b:	5d                   	pop    %ebp
  80175c:	c3                   	ret    

0080175d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	57                   	push   %edi
  801761:	56                   	push   %esi
  801762:	53                   	push   %ebx
  801763:	8b 55 08             	mov    0x8(%ebp),%edx
  801766:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  801769:	85 c9                	test   %ecx,%ecx
  80176b:	74 37                	je     8017a4 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80176d:	f6 c2 03             	test   $0x3,%dl
  801770:	75 2a                	jne    80179c <memset+0x3f>
  801772:	f6 c1 03             	test   $0x3,%cl
  801775:	75 25                	jne    80179c <memset+0x3f>
		c &= 0xFF;
  801777:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80177b:	89 df                	mov    %ebx,%edi
  80177d:	c1 e7 08             	shl    $0x8,%edi
  801780:	89 de                	mov    %ebx,%esi
  801782:	c1 e6 18             	shl    $0x18,%esi
  801785:	89 d8                	mov    %ebx,%eax
  801787:	c1 e0 10             	shl    $0x10,%eax
  80178a:	09 f0                	or     %esi,%eax
  80178c:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  80178e:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801791:	89 f8                	mov    %edi,%eax
  801793:	09 d8                	or     %ebx,%eax
  801795:	89 d7                	mov    %edx,%edi
  801797:	fc                   	cld    
  801798:	f3 ab                	rep stos %eax,%es:(%edi)
  80179a:	eb 08                	jmp    8017a4 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80179c:	89 d7                	mov    %edx,%edi
  80179e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a1:	fc                   	cld    
  8017a2:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8017a4:	89 d0                	mov    %edx,%eax
  8017a6:	5b                   	pop    %ebx
  8017a7:	5e                   	pop    %esi
  8017a8:	5f                   	pop    %edi
  8017a9:	5d                   	pop    %ebp
  8017aa:	c3                   	ret    

008017ab <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	57                   	push   %edi
  8017af:	56                   	push   %esi
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8017b9:	39 c6                	cmp    %eax,%esi
  8017bb:	73 35                	jae    8017f2 <memmove+0x47>
  8017bd:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8017c0:	39 d0                	cmp    %edx,%eax
  8017c2:	73 2e                	jae    8017f2 <memmove+0x47>
		s += n;
		d += n;
  8017c4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8017c7:	89 d6                	mov    %edx,%esi
  8017c9:	09 fe                	or     %edi,%esi
  8017cb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8017d1:	75 13                	jne    8017e6 <memmove+0x3b>
  8017d3:	f6 c1 03             	test   $0x3,%cl
  8017d6:	75 0e                	jne    8017e6 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  8017d8:	83 ef 04             	sub    $0x4,%edi
  8017db:	8d 72 fc             	lea    -0x4(%edx),%esi
  8017de:	c1 e9 02             	shr    $0x2,%ecx
  8017e1:	fd                   	std    
  8017e2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8017e4:	eb 09                	jmp    8017ef <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8017e6:	83 ef 01             	sub    $0x1,%edi
  8017e9:	8d 72 ff             	lea    -0x1(%edx),%esi
  8017ec:	fd                   	std    
  8017ed:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017ef:	fc                   	cld    
  8017f0:	eb 1d                	jmp    80180f <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8017f2:	89 f2                	mov    %esi,%edx
  8017f4:	09 c2                	or     %eax,%edx
  8017f6:	f6 c2 03             	test   $0x3,%dl
  8017f9:	75 0f                	jne    80180a <memmove+0x5f>
  8017fb:	f6 c1 03             	test   $0x3,%cl
  8017fe:	75 0a                	jne    80180a <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  801800:	c1 e9 02             	shr    $0x2,%ecx
  801803:	89 c7                	mov    %eax,%edi
  801805:	fc                   	cld    
  801806:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801808:	eb 05                	jmp    80180f <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80180a:	89 c7                	mov    %eax,%edi
  80180c:	fc                   	cld    
  80180d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80180f:	5e                   	pop    %esi
  801810:	5f                   	pop    %edi
  801811:	5d                   	pop    %ebp
  801812:	c3                   	ret    

00801813 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801816:	ff 75 10             	pushl  0x10(%ebp)
  801819:	ff 75 0c             	pushl  0xc(%ebp)
  80181c:	ff 75 08             	pushl  0x8(%ebp)
  80181f:	e8 87 ff ff ff       	call   8017ab <memmove>
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	56                   	push   %esi
  80182a:	53                   	push   %ebx
  80182b:	8b 45 08             	mov    0x8(%ebp),%eax
  80182e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801831:	89 c6                	mov    %eax,%esi
  801833:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801836:	eb 1a                	jmp    801852 <memcmp+0x2c>
		if (*s1 != *s2)
  801838:	0f b6 08             	movzbl (%eax),%ecx
  80183b:	0f b6 1a             	movzbl (%edx),%ebx
  80183e:	38 d9                	cmp    %bl,%cl
  801840:	74 0a                	je     80184c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  801842:	0f b6 c1             	movzbl %cl,%eax
  801845:	0f b6 db             	movzbl %bl,%ebx
  801848:	29 d8                	sub    %ebx,%eax
  80184a:	eb 0f                	jmp    80185b <memcmp+0x35>
		s1++, s2++;
  80184c:	83 c0 01             	add    $0x1,%eax
  80184f:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801852:	39 f0                	cmp    %esi,%eax
  801854:	75 e2                	jne    801838 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801856:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80185b:	5b                   	pop    %ebx
  80185c:	5e                   	pop    %esi
  80185d:	5d                   	pop    %ebp
  80185e:	c3                   	ret    

0080185f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	53                   	push   %ebx
  801863:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  801866:	89 c1                	mov    %eax,%ecx
  801868:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  80186b:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80186f:	eb 0a                	jmp    80187b <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  801871:	0f b6 10             	movzbl (%eax),%edx
  801874:	39 da                	cmp    %ebx,%edx
  801876:	74 07                	je     80187f <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801878:	83 c0 01             	add    $0x1,%eax
  80187b:	39 c8                	cmp    %ecx,%eax
  80187d:	72 f2                	jb     801871 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  80187f:	5b                   	pop    %ebx
  801880:	5d                   	pop    %ebp
  801881:	c3                   	ret    

00801882 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	57                   	push   %edi
  801886:	56                   	push   %esi
  801887:	53                   	push   %ebx
  801888:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80188b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80188e:	eb 03                	jmp    801893 <strtol+0x11>
		s++;
  801890:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801893:	0f b6 01             	movzbl (%ecx),%eax
  801896:	3c 20                	cmp    $0x20,%al
  801898:	74 f6                	je     801890 <strtol+0xe>
  80189a:	3c 09                	cmp    $0x9,%al
  80189c:	74 f2                	je     801890 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  80189e:	3c 2b                	cmp    $0x2b,%al
  8018a0:	75 0a                	jne    8018ac <strtol+0x2a>
		s++;
  8018a2:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8018a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8018aa:	eb 11                	jmp    8018bd <strtol+0x3b>
  8018ac:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8018b1:	3c 2d                	cmp    $0x2d,%al
  8018b3:	75 08                	jne    8018bd <strtol+0x3b>
		s++, neg = 1;
  8018b5:	83 c1 01             	add    $0x1,%ecx
  8018b8:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018bd:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8018c3:	75 15                	jne    8018da <strtol+0x58>
  8018c5:	80 39 30             	cmpb   $0x30,(%ecx)
  8018c8:	75 10                	jne    8018da <strtol+0x58>
  8018ca:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8018ce:	75 7c                	jne    80194c <strtol+0xca>
		s += 2, base = 16;
  8018d0:	83 c1 02             	add    $0x2,%ecx
  8018d3:	bb 10 00 00 00       	mov    $0x10,%ebx
  8018d8:	eb 16                	jmp    8018f0 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  8018da:	85 db                	test   %ebx,%ebx
  8018dc:	75 12                	jne    8018f0 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8018de:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8018e3:	80 39 30             	cmpb   $0x30,(%ecx)
  8018e6:	75 08                	jne    8018f0 <strtol+0x6e>
		s++, base = 8;
  8018e8:	83 c1 01             	add    $0x1,%ecx
  8018eb:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  8018f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f5:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018f8:	0f b6 11             	movzbl (%ecx),%edx
  8018fb:	8d 72 d0             	lea    -0x30(%edx),%esi
  8018fe:	89 f3                	mov    %esi,%ebx
  801900:	80 fb 09             	cmp    $0x9,%bl
  801903:	77 08                	ja     80190d <strtol+0x8b>
			dig = *s - '0';
  801905:	0f be d2             	movsbl %dl,%edx
  801908:	83 ea 30             	sub    $0x30,%edx
  80190b:	eb 22                	jmp    80192f <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  80190d:	8d 72 9f             	lea    -0x61(%edx),%esi
  801910:	89 f3                	mov    %esi,%ebx
  801912:	80 fb 19             	cmp    $0x19,%bl
  801915:	77 08                	ja     80191f <strtol+0x9d>
			dig = *s - 'a' + 10;
  801917:	0f be d2             	movsbl %dl,%edx
  80191a:	83 ea 57             	sub    $0x57,%edx
  80191d:	eb 10                	jmp    80192f <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  80191f:	8d 72 bf             	lea    -0x41(%edx),%esi
  801922:	89 f3                	mov    %esi,%ebx
  801924:	80 fb 19             	cmp    $0x19,%bl
  801927:	77 16                	ja     80193f <strtol+0xbd>
			dig = *s - 'A' + 10;
  801929:	0f be d2             	movsbl %dl,%edx
  80192c:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  80192f:	3b 55 10             	cmp    0x10(%ebp),%edx
  801932:	7d 0b                	jge    80193f <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  801934:	83 c1 01             	add    $0x1,%ecx
  801937:	0f af 45 10          	imul   0x10(%ebp),%eax
  80193b:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  80193d:	eb b9                	jmp    8018f8 <strtol+0x76>

	if (endptr)
  80193f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801943:	74 0d                	je     801952 <strtol+0xd0>
		*endptr = (char *) s;
  801945:	8b 75 0c             	mov    0xc(%ebp),%esi
  801948:	89 0e                	mov    %ecx,(%esi)
  80194a:	eb 06                	jmp    801952 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  80194c:	85 db                	test   %ebx,%ebx
  80194e:	74 98                	je     8018e8 <strtol+0x66>
  801950:	eb 9e                	jmp    8018f0 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  801952:	89 c2                	mov    %eax,%edx
  801954:	f7 da                	neg    %edx
  801956:	85 ff                	test   %edi,%edi
  801958:	0f 45 c2             	cmovne %edx,%eax
}
  80195b:	5b                   	pop    %ebx
  80195c:	5e                   	pop    %esi
  80195d:	5f                   	pop    %edi
  80195e:	5d                   	pop    %ebp
  80195f:	c3                   	ret    

00801960 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	56                   	push   %esi
  801964:	53                   	push   %ebx
  801965:	8b 75 08             	mov    0x8(%ebp),%esi
  801968:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  80196e:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801970:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801975:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801978:	83 ec 0c             	sub    $0xc,%esp
  80197b:	50                   	push   %eax
  80197c:	e8 1d e9 ff ff       	call   80029e <sys_ipc_recv>
	if (from_env_store)
  801981:	83 c4 10             	add    $0x10,%esp
  801984:	85 f6                	test   %esi,%esi
  801986:	74 0b                	je     801993 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801988:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80198e:	8b 52 74             	mov    0x74(%edx),%edx
  801991:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801993:	85 db                	test   %ebx,%ebx
  801995:	74 0b                	je     8019a2 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  801997:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80199d:	8b 52 78             	mov    0x78(%edx),%edx
  8019a0:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  8019a2:	85 c0                	test   %eax,%eax
  8019a4:	79 16                	jns    8019bc <ipc_recv+0x5c>
		if (from_env_store)
  8019a6:	85 f6                	test   %esi,%esi
  8019a8:	74 06                	je     8019b0 <ipc_recv+0x50>
			*from_env_store = 0;
  8019aa:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  8019b0:	85 db                	test   %ebx,%ebx
  8019b2:	74 10                	je     8019c4 <ipc_recv+0x64>
			*perm_store = 0;
  8019b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8019ba:	eb 08                	jmp    8019c4 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  8019bc:	a1 04 40 80 00       	mov    0x804004,%eax
  8019c1:	8b 40 70             	mov    0x70(%eax),%eax
}
  8019c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019c7:	5b                   	pop    %ebx
  8019c8:	5e                   	pop    %esi
  8019c9:	5d                   	pop    %ebp
  8019ca:	c3                   	ret    

008019cb <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
  8019ce:	57                   	push   %edi
  8019cf:	56                   	push   %esi
  8019d0:	53                   	push   %ebx
  8019d1:	83 ec 0c             	sub    $0xc,%esp
  8019d4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019d7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019da:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  8019dd:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  8019df:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8019e4:	0f 44 d8             	cmove  %eax,%ebx
  8019e7:	eb 1c                	jmp    801a05 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  8019e9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8019ec:	74 12                	je     801a00 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  8019ee:	50                   	push   %eax
  8019ef:	68 80 21 80 00       	push   $0x802180
  8019f4:	6a 42                	push   $0x42
  8019f6:	68 96 21 80 00       	push   $0x802196
  8019fb:	e8 cd f5 ff ff       	call   800fcd <_panic>
		sys_yield();
  801a00:	e8 77 e7 ff ff       	call   80017c <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801a05:	ff 75 14             	pushl  0x14(%ebp)
  801a08:	53                   	push   %ebx
  801a09:	56                   	push   %esi
  801a0a:	57                   	push   %edi
  801a0b:	e8 69 e8 ff ff       	call   800279 <sys_ipc_try_send>
  801a10:	83 c4 10             	add    $0x10,%esp
  801a13:	85 c0                	test   %eax,%eax
  801a15:	75 d2                	jne    8019e9 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801a17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a1a:	5b                   	pop    %ebx
  801a1b:	5e                   	pop    %esi
  801a1c:	5f                   	pop    %edi
  801a1d:	5d                   	pop    %ebp
  801a1e:	c3                   	ret    

00801a1f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801a25:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801a2a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801a2d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801a33:	8b 52 50             	mov    0x50(%edx),%edx
  801a36:	39 ca                	cmp    %ecx,%edx
  801a38:	75 0d                	jne    801a47 <ipc_find_env+0x28>
			return envs[i].env_id;
  801a3a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a3d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a42:	8b 40 48             	mov    0x48(%eax),%eax
  801a45:	eb 0f                	jmp    801a56 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801a47:	83 c0 01             	add    $0x1,%eax
  801a4a:	3d 00 04 00 00       	cmp    $0x400,%eax
  801a4f:	75 d9                	jne    801a2a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801a51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a56:	5d                   	pop    %ebp
  801a57:	c3                   	ret    

00801a58 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
  801a5b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a5e:	89 d0                	mov    %edx,%eax
  801a60:	c1 e8 16             	shr    $0x16,%eax
  801a63:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801a6a:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a6f:	f6 c1 01             	test   $0x1,%cl
  801a72:	74 1d                	je     801a91 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801a74:	c1 ea 0c             	shr    $0xc,%edx
  801a77:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801a7e:	f6 c2 01             	test   $0x1,%dl
  801a81:	74 0e                	je     801a91 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801a83:	c1 ea 0c             	shr    $0xc,%edx
  801a86:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801a8d:	ef 
  801a8e:	0f b7 c0             	movzwl %ax,%eax
}
  801a91:	5d                   	pop    %ebp
  801a92:	c3                   	ret    
  801a93:	66 90                	xchg   %ax,%ax
  801a95:	66 90                	xchg   %ax,%ax
  801a97:	66 90                	xchg   %ax,%ax
  801a99:	66 90                	xchg   %ax,%ax
  801a9b:	66 90                	xchg   %ax,%ax
  801a9d:	66 90                	xchg   %ax,%ax
  801a9f:	90                   	nop

00801aa0 <__udivdi3>:
  801aa0:	55                   	push   %ebp
  801aa1:	57                   	push   %edi
  801aa2:	56                   	push   %esi
  801aa3:	53                   	push   %ebx
  801aa4:	83 ec 1c             	sub    $0x1c,%esp
  801aa7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801aab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801aaf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ab3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ab7:	85 f6                	test   %esi,%esi
  801ab9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801abd:	89 ca                	mov    %ecx,%edx
  801abf:	89 f8                	mov    %edi,%eax
  801ac1:	75 3d                	jne    801b00 <__udivdi3+0x60>
  801ac3:	39 cf                	cmp    %ecx,%edi
  801ac5:	0f 87 c5 00 00 00    	ja     801b90 <__udivdi3+0xf0>
  801acb:	85 ff                	test   %edi,%edi
  801acd:	89 fd                	mov    %edi,%ebp
  801acf:	75 0b                	jne    801adc <__udivdi3+0x3c>
  801ad1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad6:	31 d2                	xor    %edx,%edx
  801ad8:	f7 f7                	div    %edi
  801ada:	89 c5                	mov    %eax,%ebp
  801adc:	89 c8                	mov    %ecx,%eax
  801ade:	31 d2                	xor    %edx,%edx
  801ae0:	f7 f5                	div    %ebp
  801ae2:	89 c1                	mov    %eax,%ecx
  801ae4:	89 d8                	mov    %ebx,%eax
  801ae6:	89 cf                	mov    %ecx,%edi
  801ae8:	f7 f5                	div    %ebp
  801aea:	89 c3                	mov    %eax,%ebx
  801aec:	89 d8                	mov    %ebx,%eax
  801aee:	89 fa                	mov    %edi,%edx
  801af0:	83 c4 1c             	add    $0x1c,%esp
  801af3:	5b                   	pop    %ebx
  801af4:	5e                   	pop    %esi
  801af5:	5f                   	pop    %edi
  801af6:	5d                   	pop    %ebp
  801af7:	c3                   	ret    
  801af8:	90                   	nop
  801af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801b00:	39 ce                	cmp    %ecx,%esi
  801b02:	77 74                	ja     801b78 <__udivdi3+0xd8>
  801b04:	0f bd fe             	bsr    %esi,%edi
  801b07:	83 f7 1f             	xor    $0x1f,%edi
  801b0a:	0f 84 98 00 00 00    	je     801ba8 <__udivdi3+0x108>
  801b10:	bb 20 00 00 00       	mov    $0x20,%ebx
  801b15:	89 f9                	mov    %edi,%ecx
  801b17:	89 c5                	mov    %eax,%ebp
  801b19:	29 fb                	sub    %edi,%ebx
  801b1b:	d3 e6                	shl    %cl,%esi
  801b1d:	89 d9                	mov    %ebx,%ecx
  801b1f:	d3 ed                	shr    %cl,%ebp
  801b21:	89 f9                	mov    %edi,%ecx
  801b23:	d3 e0                	shl    %cl,%eax
  801b25:	09 ee                	or     %ebp,%esi
  801b27:	89 d9                	mov    %ebx,%ecx
  801b29:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b2d:	89 d5                	mov    %edx,%ebp
  801b2f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b33:	d3 ed                	shr    %cl,%ebp
  801b35:	89 f9                	mov    %edi,%ecx
  801b37:	d3 e2                	shl    %cl,%edx
  801b39:	89 d9                	mov    %ebx,%ecx
  801b3b:	d3 e8                	shr    %cl,%eax
  801b3d:	09 c2                	or     %eax,%edx
  801b3f:	89 d0                	mov    %edx,%eax
  801b41:	89 ea                	mov    %ebp,%edx
  801b43:	f7 f6                	div    %esi
  801b45:	89 d5                	mov    %edx,%ebp
  801b47:	89 c3                	mov    %eax,%ebx
  801b49:	f7 64 24 0c          	mull   0xc(%esp)
  801b4d:	39 d5                	cmp    %edx,%ebp
  801b4f:	72 10                	jb     801b61 <__udivdi3+0xc1>
  801b51:	8b 74 24 08          	mov    0x8(%esp),%esi
  801b55:	89 f9                	mov    %edi,%ecx
  801b57:	d3 e6                	shl    %cl,%esi
  801b59:	39 c6                	cmp    %eax,%esi
  801b5b:	73 07                	jae    801b64 <__udivdi3+0xc4>
  801b5d:	39 d5                	cmp    %edx,%ebp
  801b5f:	75 03                	jne    801b64 <__udivdi3+0xc4>
  801b61:	83 eb 01             	sub    $0x1,%ebx
  801b64:	31 ff                	xor    %edi,%edi
  801b66:	89 d8                	mov    %ebx,%eax
  801b68:	89 fa                	mov    %edi,%edx
  801b6a:	83 c4 1c             	add    $0x1c,%esp
  801b6d:	5b                   	pop    %ebx
  801b6e:	5e                   	pop    %esi
  801b6f:	5f                   	pop    %edi
  801b70:	5d                   	pop    %ebp
  801b71:	c3                   	ret    
  801b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801b78:	31 ff                	xor    %edi,%edi
  801b7a:	31 db                	xor    %ebx,%ebx
  801b7c:	89 d8                	mov    %ebx,%eax
  801b7e:	89 fa                	mov    %edi,%edx
  801b80:	83 c4 1c             	add    $0x1c,%esp
  801b83:	5b                   	pop    %ebx
  801b84:	5e                   	pop    %esi
  801b85:	5f                   	pop    %edi
  801b86:	5d                   	pop    %ebp
  801b87:	c3                   	ret    
  801b88:	90                   	nop
  801b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801b90:	89 d8                	mov    %ebx,%eax
  801b92:	f7 f7                	div    %edi
  801b94:	31 ff                	xor    %edi,%edi
  801b96:	89 c3                	mov    %eax,%ebx
  801b98:	89 d8                	mov    %ebx,%eax
  801b9a:	89 fa                	mov    %edi,%edx
  801b9c:	83 c4 1c             	add    $0x1c,%esp
  801b9f:	5b                   	pop    %ebx
  801ba0:	5e                   	pop    %esi
  801ba1:	5f                   	pop    %edi
  801ba2:	5d                   	pop    %ebp
  801ba3:	c3                   	ret    
  801ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ba8:	39 ce                	cmp    %ecx,%esi
  801baa:	72 0c                	jb     801bb8 <__udivdi3+0x118>
  801bac:	31 db                	xor    %ebx,%ebx
  801bae:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bb2:	0f 87 34 ff ff ff    	ja     801aec <__udivdi3+0x4c>
  801bb8:	bb 01 00 00 00       	mov    $0x1,%ebx
  801bbd:	e9 2a ff ff ff       	jmp    801aec <__udivdi3+0x4c>
  801bc2:	66 90                	xchg   %ax,%ax
  801bc4:	66 90                	xchg   %ax,%ax
  801bc6:	66 90                	xchg   %ax,%ax
  801bc8:	66 90                	xchg   %ax,%ax
  801bca:	66 90                	xchg   %ax,%ax
  801bcc:	66 90                	xchg   %ax,%ax
  801bce:	66 90                	xchg   %ax,%ax

00801bd0 <__umoddi3>:
  801bd0:	55                   	push   %ebp
  801bd1:	57                   	push   %edi
  801bd2:	56                   	push   %esi
  801bd3:	53                   	push   %ebx
  801bd4:	83 ec 1c             	sub    $0x1c,%esp
  801bd7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801bdb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bdf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801be3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801be7:	85 d2                	test   %edx,%edx
  801be9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801bed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bf1:	89 f3                	mov    %esi,%ebx
  801bf3:	89 3c 24             	mov    %edi,(%esp)
  801bf6:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bfa:	75 1c                	jne    801c18 <__umoddi3+0x48>
  801bfc:	39 f7                	cmp    %esi,%edi
  801bfe:	76 50                	jbe    801c50 <__umoddi3+0x80>
  801c00:	89 c8                	mov    %ecx,%eax
  801c02:	89 f2                	mov    %esi,%edx
  801c04:	f7 f7                	div    %edi
  801c06:	89 d0                	mov    %edx,%eax
  801c08:	31 d2                	xor    %edx,%edx
  801c0a:	83 c4 1c             	add    $0x1c,%esp
  801c0d:	5b                   	pop    %ebx
  801c0e:	5e                   	pop    %esi
  801c0f:	5f                   	pop    %edi
  801c10:	5d                   	pop    %ebp
  801c11:	c3                   	ret    
  801c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c18:	39 f2                	cmp    %esi,%edx
  801c1a:	89 d0                	mov    %edx,%eax
  801c1c:	77 52                	ja     801c70 <__umoddi3+0xa0>
  801c1e:	0f bd ea             	bsr    %edx,%ebp
  801c21:	83 f5 1f             	xor    $0x1f,%ebp
  801c24:	75 5a                	jne    801c80 <__umoddi3+0xb0>
  801c26:	3b 54 24 04          	cmp    0x4(%esp),%edx
  801c2a:	0f 82 e0 00 00 00    	jb     801d10 <__umoddi3+0x140>
  801c30:	39 0c 24             	cmp    %ecx,(%esp)
  801c33:	0f 86 d7 00 00 00    	jbe    801d10 <__umoddi3+0x140>
  801c39:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c3d:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c41:	83 c4 1c             	add    $0x1c,%esp
  801c44:	5b                   	pop    %ebx
  801c45:	5e                   	pop    %esi
  801c46:	5f                   	pop    %edi
  801c47:	5d                   	pop    %ebp
  801c48:	c3                   	ret    
  801c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c50:	85 ff                	test   %edi,%edi
  801c52:	89 fd                	mov    %edi,%ebp
  801c54:	75 0b                	jne    801c61 <__umoddi3+0x91>
  801c56:	b8 01 00 00 00       	mov    $0x1,%eax
  801c5b:	31 d2                	xor    %edx,%edx
  801c5d:	f7 f7                	div    %edi
  801c5f:	89 c5                	mov    %eax,%ebp
  801c61:	89 f0                	mov    %esi,%eax
  801c63:	31 d2                	xor    %edx,%edx
  801c65:	f7 f5                	div    %ebp
  801c67:	89 c8                	mov    %ecx,%eax
  801c69:	f7 f5                	div    %ebp
  801c6b:	89 d0                	mov    %edx,%eax
  801c6d:	eb 99                	jmp    801c08 <__umoddi3+0x38>
  801c6f:	90                   	nop
  801c70:	89 c8                	mov    %ecx,%eax
  801c72:	89 f2                	mov    %esi,%edx
  801c74:	83 c4 1c             	add    $0x1c,%esp
  801c77:	5b                   	pop    %ebx
  801c78:	5e                   	pop    %esi
  801c79:	5f                   	pop    %edi
  801c7a:	5d                   	pop    %ebp
  801c7b:	c3                   	ret    
  801c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801c80:	8b 34 24             	mov    (%esp),%esi
  801c83:	bf 20 00 00 00       	mov    $0x20,%edi
  801c88:	89 e9                	mov    %ebp,%ecx
  801c8a:	29 ef                	sub    %ebp,%edi
  801c8c:	d3 e0                	shl    %cl,%eax
  801c8e:	89 f9                	mov    %edi,%ecx
  801c90:	89 f2                	mov    %esi,%edx
  801c92:	d3 ea                	shr    %cl,%edx
  801c94:	89 e9                	mov    %ebp,%ecx
  801c96:	09 c2                	or     %eax,%edx
  801c98:	89 d8                	mov    %ebx,%eax
  801c9a:	89 14 24             	mov    %edx,(%esp)
  801c9d:	89 f2                	mov    %esi,%edx
  801c9f:	d3 e2                	shl    %cl,%edx
  801ca1:	89 f9                	mov    %edi,%ecx
  801ca3:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ca7:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801cab:	d3 e8                	shr    %cl,%eax
  801cad:	89 e9                	mov    %ebp,%ecx
  801caf:	89 c6                	mov    %eax,%esi
  801cb1:	d3 e3                	shl    %cl,%ebx
  801cb3:	89 f9                	mov    %edi,%ecx
  801cb5:	89 d0                	mov    %edx,%eax
  801cb7:	d3 e8                	shr    %cl,%eax
  801cb9:	89 e9                	mov    %ebp,%ecx
  801cbb:	09 d8                	or     %ebx,%eax
  801cbd:	89 d3                	mov    %edx,%ebx
  801cbf:	89 f2                	mov    %esi,%edx
  801cc1:	f7 34 24             	divl   (%esp)
  801cc4:	89 d6                	mov    %edx,%esi
  801cc6:	d3 e3                	shl    %cl,%ebx
  801cc8:	f7 64 24 04          	mull   0x4(%esp)
  801ccc:	39 d6                	cmp    %edx,%esi
  801cce:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cd2:	89 d1                	mov    %edx,%ecx
  801cd4:	89 c3                	mov    %eax,%ebx
  801cd6:	72 08                	jb     801ce0 <__umoddi3+0x110>
  801cd8:	75 11                	jne    801ceb <__umoddi3+0x11b>
  801cda:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801cde:	73 0b                	jae    801ceb <__umoddi3+0x11b>
  801ce0:	2b 44 24 04          	sub    0x4(%esp),%eax
  801ce4:	1b 14 24             	sbb    (%esp),%edx
  801ce7:	89 d1                	mov    %edx,%ecx
  801ce9:	89 c3                	mov    %eax,%ebx
  801ceb:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cef:	29 da                	sub    %ebx,%edx
  801cf1:	19 ce                	sbb    %ecx,%esi
  801cf3:	89 f9                	mov    %edi,%ecx
  801cf5:	89 f0                	mov    %esi,%eax
  801cf7:	d3 e0                	shl    %cl,%eax
  801cf9:	89 e9                	mov    %ebp,%ecx
  801cfb:	d3 ea                	shr    %cl,%edx
  801cfd:	89 e9                	mov    %ebp,%ecx
  801cff:	d3 ee                	shr    %cl,%esi
  801d01:	09 d0                	or     %edx,%eax
  801d03:	89 f2                	mov    %esi,%edx
  801d05:	83 c4 1c             	add    $0x1c,%esp
  801d08:	5b                   	pop    %ebx
  801d09:	5e                   	pop    %esi
  801d0a:	5f                   	pop    %edi
  801d0b:	5d                   	pop    %ebp
  801d0c:	c3                   	ret    
  801d0d:	8d 76 00             	lea    0x0(%esi),%esi
  801d10:	29 f9                	sub    %edi,%ecx
  801d12:	19 d6                	sbb    %edx,%esi
  801d14:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d18:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d1c:	e9 18 ff ff ff       	jmp    801c39 <__umoddi3+0x69>
